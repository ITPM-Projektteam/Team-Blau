unit mTKI;

interface

uses mVektor,mTXTMobilRoboter,Client,ClientUndServer,DateUtils,mHauptformular,
     mKonstanten, Math, Generics.Collections, mRoboterDaten, SysUtils, IdTCPClient;

type TAktion = (FANGEN, FLIEHEN);

type TKI = class(TObject)
  strict private
    class var Formular: THauptformular;
    class var ZeitLetzterFrames: TQueue<TDateTime>;
    class var RoboterDaten: A_RoboterDaten;
    class var Roboter: Array of TTXTMobilRoboter;
    class var Spielfeld: TVektor;
    class var Client: TServerVerbindung;

    class function PrioritaetFestlegen(index: Integer;
      out Ziel: Integer): TAktion;
    class function FangvektorBerechnen(index, Ziel: Integer): TVektor;
    class function FliehvektorBerechnen(index, Ziel: Integer): TVektor;
    class function RandAusweichvektorBerechnen(index: Integer;
      Zielvektor: TVektor): TVektor;
    class function RoboterAusweichvektorBerechnen(index: Integer;
      Zielvektor: TVektor): TVektor;
    class function RausfahrvektorBerechnen(index: Integer): TVektor;
    class procedure SteuerbefehlSenden(index: Integer; Zielvektor: TVektor);
    class procedure GeschwindigkeitenBerechnen(zeit: TDateTime);
    class function ServerdatenEmpfangen: Boolean;

  public
    class procedure Init(IP_Adressen: Array of String;
      Server_Adresse: String; Port: Integer; Formular: THauptformular);
    class procedure Steuern(Spielende: TDateTime);
    class procedure Anmelden(Teamwahl: TTeam);
end;

implementation

{ TKuenstlicheIntelligenz }

class procedure TKI.Anmelden(Teamwahl: TTeam);
begin
  if Client.anmelden(Teamwahl) then
    Formular.Log_Schreiben('Anmelden erfolgreich', Hinweis)
  else
    Formular.Log_Schreiben('Anmelden nicht erfolgreich', Fehler);


 if Client.WarteAufSpielstart then
  TKI.Steuern(Now); // TODO: Richtige Zeit einfügen                                                                                       //!!!!!!!!
end;

class function TKI.RandAusweichvektorBerechnen(index: Integer;
  Zielvektor: TVektor): TVektor;
var
  ZielPosition, aktPos, Geschwindigkeit: TVektor;

begin
  ZielPosition := RoboterDaten[TEAM_BLAU,index].Position + Zielvektor;
  aktPos := RoboterDaten[TEAM_BLAU,index].Position;
  Geschwindigkeit := RoboterDaten[TEAM_BLAU,index].Geschwindigkeit;

  if Zielvektor = NULLVEKTOR then exit;

  //Roboter befindet sich in der Naehe des Spielfeldrandes
  //und darf nur in eine Richtung ablenken
  if aktPos.x > Spielfeld.x-RAND then begin
    if (Geschwindigkeit.x > 0) and (Zielvektor.x < 0) then
      result := Geschwindigkeit.Drehen(-DegToRad(179))
    else if (Geschwindigkeit.x < 0) and (Zielvektor.x < 0) then
      result := Geschwindigkeit.Drehen(DegToRad(179));
  end
  else if aktPos.x < RAND then begin
    if (Geschwindigkeit.x > 0) and (Zielvektor.x < 0) then
      result := Geschwindigkeit.Drehen(-DegToRad(179))
    else if (Geschwindigkeit.x < 0) and (Zielvektor.x < 0) then
      result := Geschwindigkeit.Drehen(DegToRad(179));
  end
  else if aktPos.y > Spielfeld.y-RAND then begin
    if (Geschwindigkeit.y > 0) and (Zielvektor.y < 0) then
      result := Geschwindigkeit.Drehen(-DegToRad(179))
    else if (Geschwindigkeit.y < 0) and (Zielvektor.y < 0) then
      result := Geschwindigkeit.Drehen(DegToRad(179));
  end
  else if aktPos.y < RAND then begin
    if (Geschwindigkeit.y > 0) and (Zielvektor.y < 0) then
      result := Geschwindigkeit.Drehen(DegToRad(179))
    else if (Geschwindigkeit.y < 0) and (Zielvektor.y < 0) then
      result := Geschwindigkeit.Drehen(-DegToRad(179));
  end;

  //Roboter befindet sich ausserhalb des Spielfeldes
  if (aktPos.x>Spielfeld.x) or (aktPos.x<0) or (aktPos.y<0) or
    (aktPos.y>Spielfeld.y) then
    result := Spielfeld*0.5 - aktPos
  //Aus Ecke herausfahren
  else if (Zielposition.x>Spielfeld.x) and (Zielposition.y>Spielfeld.y) or
          (Zielposition.x>Spielfeld.x) and (Zielposition.y<0) or
          (Zielposition.y>Spielfeld.y) and (Zielposition.x<0) or
          (Zielposition.x<0) and (Zielposition.y<0) then
  begin
    result.x := -(Zielvektor.x);
    result.y := -(Zielvektor.y);
  end
  //Oberen Spielfeldrand nicht ueberfahren
  else if (Zielposition.y > Spielfeld.y) then begin
    result.y := Spielfeld.y-aktPos.y;
    result.x := Sqrt(Sqr(LAENGE_FLIEHVEKTOR)-Sqr(result.y));
	if Zielvektor.x < 0 then
		result.x := -result.x;
  end
  //Unteren Spielfeldrand nicht ueberfahren
  else if Zielposition.y < 0 then begin
    result.y := -aktPos.y;
    result.x := Sqrt(Sqr(LAENGE_FLIEHVEKTOR)-Sqr(result.y));
	if Zielvektor.x < 0 then
		result.x := -result.x;
  end
  //Rechten Spielfeldrand nicht ueberfahren
  else if (Zielposition.x > Spielfeld.x) then begin
    result.x := Spielfeld.x-aktPos.x;
    result.y := Sqrt(Sqr(LAENGE_FLIEHVEKTOR)-Sqr(result.x));
	if Zielvektor.y < 0 then
		result.y := -result.y;
  end
  //Linken Spielfeldrand nicht ueberfahren
  else if (Zielposition.x < 0) then begin
    result.x := -aktPos.x;
    result.y := Sqrt(Sqr(LAENGE_FLIEHVEKTOR)-Sqr(result.x));
	if Zielvektor.y < 0 then
		result.y := -result.y;
  end;

end;

class function TKI.RoboterAusweichvektorBerechnen(index: Integer;
  Zielvektor: TVektor): TVektor;
var
  t: Double;
  i: Integer;
  deltaP, deltaV: TVektor;
  deltaWinkel: Double;
  aktPos, Geschwindigkeit: TVektor;
begin
  aktPos := RoboterDaten[TEAM_BLAU,index].Position;
  Geschwindigkeit := RoboterDaten[TEAM_BLAU,index].Geschwindigkeit;
  //Kollisionen mit TeamRobotern vermeiden
  if index = High(RoboterDaten[TEAM_BLAU]) then Exit;
  if Geschwindigkeit.Winkel(Zielvektor) > AUSWEICHWINKEL then Exit;

  for i := index+1 to High(RoboterDaten[TEAM_BLAU]) do begin
    deltaP := aktPos - RoboterDaten[TEAM_BLAU,i].Position;
    deltaV := Geschwindigkeit - RoboterDaten[TEAM_BLAU,i].Geschwindigkeit;
    try
      t := (deltaP.x*deltaV.x+deltaP.y*deltaV.y)/Power(deltaV.Betrag,2);
    except
      on EDivByZero do Continue; // Zu kleines deltaV => Roboter fahren parallel
                                 // => kein Ausweichen noetig
    end;

    if (t>=0) and (t<5) then
      if ((aktPos+t*Geschwindigkeit) -
         (RoboterDaten[TEAM_BLAU,i].Position+t*
         RoboterDaten[TEAM_BLAU,i].Geschwindigkeit)).Betrag< MINDESTABSTAND then
      begin
        deltaWinkel := RoboterDaten[TEAM_BLAU,i].Geschwindigkeit.winkel -
        Geschwindigkeit.winkel;
        if deltaWinkel < 0 then
          deltaWinkel := deltaWinkel + 2*pi;
        if deltaWinkel < Pi then begin
          // Weiche nach rechts aus
          result := Zielvektor.Drehen(-AUSWEICHWINKEL);
        end
        else begin
          // Weiche nach links aus
          result := Zielvektor.Drehen(AUSWEICHWINKEL);
        end;
      end;
  end;
end;

class function TKI.FangvektorBerechnen(index,ziel: Integer): TVektor;
begin
  result := RoboterDaten[TEAM_Rot,ziel].Position-
  RoboterDaten[TEAM_BLAU,index].Position;
end;

class function TKI.FliehvektorBerechnen(index,ziel: Integer): TVektor;
begin
  result := RoboterDaten[TEAM_BLAU,index].Position-
  RoboterDaten[TEAM_rot,ziel].Position;
  result := (LAENGE_FLIEHVEKTOR/result.Betrag)*result;
end;

class procedure TKI.GeschwindigkeitenBerechnen(zeit: TDateTime);
var
  einRoboter: TRoboterDaten;
  team: TTeam;
  i: Integer;
begin
  ZeitLetzterFrames.Enqueue(zeit);

  for team in [TEAM_ROT, TEAM_BLAU] do
  begin
    for i := Low(RoboterDaten[team]) to High(RoboterDaten[team]) do
    begin
      einRoboter.Geschwindigkeit := (RoboterDaten[team,i].Position -
		  RoboterDaten[team,i].Positionsverlauf.Dequeue)*
      (1/SecondSpan(zeit, ZeitLetzterFrames.Dequeue));
    end;
  end;
end;


class procedure TKI.Init(IP_Adressen: Array of String;
  Server_Adresse: String; Port: Integer; Formular: THauptformular);
var i: Integer;
begin
  Client:= TServerVerbindung.create(Server_Adresse, Port);

  self.Formular:=Formular;

  setlength(Roboter, Length(IP_Adressen));
  for i:= Low(Roboter) to High(Roboter) do
  begin
    try
        Roboter[i]:=TTXTMobilRoboter.Create(Ip_Adressen[i], i);
        Roboter[i].Start;
        Formular.Log_Schreiben('Verbindung zum Server Erfolgreich', Hinweis);
    except
        formular.Log_Schreiben('Verbindung nicht moeglich', Fehler);
    end;
  end;
end;

class function TKI.PrioritaetFestlegen(index: Integer;
  out ziel: Integer): TAktion;
var DeltaVektor: TRoboterDaten;
    KleinsterAbstand,Abstand: Double;
    i,NaechsterRoboter: Integer;
begin
  NaechsterRoboter := 0;
  KleinsterAbstand := (RoboterDaten[TEAM_BLAU,index].Position -
                       RoboterDaten[TEAM_ROT,0].Position).Betrag;

  //Pruefung welcher Roboter vom Team Rot am
  //naehesten am Roboter vom Team Blau ist
  for i := Low(RoboterDaten[TEAM_ROT])+1 to High(RoboterDaten[TEAM_ROT]) do
  begin
    if RoboterDaten[TEAM_ROT,i].Aktiv then
    begin
      Abstand := (RoboterDaten[TEAM_BLAU,index].Position -
                  RoboterDaten[TEAM_ROT,i].Position).Betrag;
      if Abstand < KleinsterAbstand then
         begin
           KleinsterAbstand := Abstand;
           NaechsterRoboter := i;
         end;
    end;
  end;

  ziel := NaechsterRoboter;
  
  //Pruefung ob der Roboter von Team Rot sich vor oder hinter dem Roboter von
  //Team Blau befindet
  Try
	if InRange((RoboterDaten[TEAM_BLAU,index].Position -
    RoboterDaten[TEAM_ROT,NaechsterRoboter].Position)
    .Winkel(RoboterDaten[TEAM_BLAU,index].Geschwindigkeit), pi*0.5, pi*1.5) then
    Result := FLIEHEN
  else
    Result := FANGEN;
  Except on EMathError do
    Formular.Log_Schreiben('Zwei Roboter haben die gleiche '+
    'Position oder ein eigener Roboter steht still.', Warnung);
  End;
end;


class function TKI.RausfahrvektorBerechnen(
  index: Integer): TVektor;
var Position: TVektor;
    Abstand: Array[0..3] of Double;
    KAbstand: Double;
begin
   Position := RoboterDaten[TEAM_BLAU,index].Position;
   //Berechnung der Seitenabstaende mit der Annahame,
   //dass sich unten links der Koordinatenursprung befindet.
   Abstand[0] := Position.x;                //links
   Abstand[1] := Spielfeld.x-Position.x;    //rechts
   Abstand[2] := Spielfeld.y-Position.y;    //oben
   Abstand[3] := Position.y;                //unten
   KAbstand := MinValue(Abstand);
   //in x- oder y-Richtung herausfahren
   if (KAbstand=Abstand[0]) or (KAbstand=Abstand[1]) then begin
     result.x := -KAbstand;
     result.y := 0;
   end
   else begin
     result.x := 0;
     result.y := -KAbstand;
   end
end;

class function TKI.ServerdatenEmpfangen: Boolean;
var
  i: Integer;
  Team: TTeam;
  Serverdaten: TSpielstatus;
begin
  Serverdaten:= Client.StatusEmpfangen;
  for Team in [Team_Blau,Team_Rot] do
  begin
    for i := low(Roboterdaten[Team]) to High(Roboterdaten[Team]) do
    begin
      // Roboterdaten des Servers werden in eingene Arrays usw. verpackt
      Roboterdaten[Team,i].Position.x:=Serverdaten.Roboterpositionen[Team,i].x;
      Roboterdaten[Team,i].Position.y:=Serverdaten.Roboterpositionen[Team,i].y;
      Roboterdaten[Team,i].Aktiv:=Serverdaten.RoboterIstAktiv[Team,i];

      Roboterdaten[Team,i].Positionsverlauf.
      Enqueue(Roboterdaten[Team,i].Position);

      GeschwindigkeitenBerechnen(Serverdaten.Zeit);
    end;
  end;
end;

class procedure TKI.SteuerbefehlSenden(index: Integer; Zielvektor: TVektor);
var
 Roboter_Blau: TTXTMobilRoboter;
 akt_Vektor: tVektor;

const
  Geschwindigkeit= 512;   // Standartgeschwindigkeit der Roboter
  c_Radius = 2;         //Konstante zum dehen, auf Grad bezogen

begin
  Roboter_Blau:= Roboter[Index];
  akt_Vektor:=Roboterdaten[Team_Blau,Index].Geschwindigkeit;

  if not((akt_Vektor=NULLVEKTOR) or (Zielvektor=NULLVEKTOR)) then
  begin
    // Liegt der neue Vekter links oder rechts des Roboters
    if Zielvektor.Winkel(akt_Vektor)<pi then
    Roboter_Blau.Bewegenalle(Geschwindigkeit,
                                 Geschwindigkeit- round(c_Radius*RadToDeg(Zielvektor.Winkel(akt_Vektor))))
    // Der Kurvenradius hängt vom Winkel der 2 Vektoren ab, je groesser der Winkel desto größer der Radius
    else
    Roboter_Blau.Bewegenalle(Geschwindigkeit-
    round(c_Radius*RadToDeg(Zielvektor.Winkel(akt_Vektor))),Geschwindigkeit)
  end;
end;


class procedure TKI.Steuern(spielende: TDateTime);
var einRoboter: integer;
Ziel_R: Integer;
FahrVektor: TVektor;
Aktion: TAktion;
begin
  // Startaufstellung einnehmen
  // Queues fuellen

  while True do // Andere Bedingung
  begin
    ServerdatenEmpfangen;
    // Gewindigkeiten werden in ServerdatenEmpfangen Berechnet

    //Fuer jeden Roboter wird ein Vektor festergelegt, den er entlang fahren soll
    for einRoboter := low(Roboter)to High(Roboter) do
    begin

      if Roboterdaten[TEAM_BLAU,einRoboter].Aktiv then
      begin
        // soll der Roboter fliehen oder fangen
        Aktion:=PrioritaetFestlegen(einRoboter,Ziel_R);
        // Abfrage ob der Roboter gefangen wurden
        if Roboter[einRoboter].LiesDigital(5) or Roboter[einRoboter].LiesDigital(6) then
        begin
          Client.GefangenMelden(einRoboter);
          Fahrvektor:=RausfahrvektorBerechnen(einRoboter);
          Formular.Log_Schreiben('Roboter: '+ Inttostr(einRoboter) + ' wurde gefangen', Warnung);
        end
        //Wenn der Roboter nicht gefangen wurde
        else
        begin
          // flieht er
          if Aktion=FLIEHEN then
          begin
            FahrVektor:= FliehvektorBerechnen(einRoboter,Ziel_R);
            FahrVektor:= RandAusweichVektorBerechnen(einRoboter,FahrVektor
            );
            Formular.Log_Schreiben('Roboter: '+ Inttostr(einRoboter) + ' flieht', Hinweis)
          end
          // oder faengt er
          else if Aktion=Fangen then
          begin
            FahrVektor:= FangvektorBerechnen(einRoboter,Ziel_R);
            FahrVektor:= RandAusweichVektorBerechnen(einRoboter,FahrVektor);
            Formular.Log_Schreiben('Roboter: '+ Inttostr(einRoboter) + ' verfolgt', Hinweis)
          end;
        end;
      end
      else
      begin
        FahrVektor:=RausFahrvektorBerechnen(einRoboter);
      end;
      // Ueberpruefungsmechanismus auf Kreuzverkehr oder Spielfeldgrenzen
      FahrVektor:= RoboterAusweichVektorBerechnen(einRoboter, FahrVektor);
      // Befehele werden an dern Roboter gesendet
      SteuerbefehlSenden(einRoboter ,FahrVektor);
    end;
          Formular.Visualisieren(RoboterDaten, Fahrvektor);
  end;
end;

end.
