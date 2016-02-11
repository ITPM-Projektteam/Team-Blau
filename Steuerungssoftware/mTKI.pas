unit mTKI;

interface

uses mVektor, mTXTMobilRoboter, Client, ClientUndServer, DateUtils,
     mHauptformular, mKonstanten, Math, Generics.Collections, mRoboterDaten, SysUtils;

type TAktion = (FANGEN, FLIEHEN);

type TKI = class(TObject)
  strict private
      class var Formular: THauptformular;
      class var ZeitLetzterFrames: TQueue<TDateTime>;
      class var RoboterDaten: Array[TTeam] of Array of TRoboterDaten;
      class var Roboter: Array of TTXTMobilRoboter;
      class var Spielfeld: TVektor;
      class var Server: TServerVerbindung;

      class function PrioritaetFestlegen(index: Integer; out Ziel: Integer): TAktion;
      class function FangvektorBerechnen(index, Ziel: Integer): TVektor;
      class function FliehvektorBerechnen(index, Ziel: Integer): TVektor;
      class function AusweichvektorBerechnen(index: Integer; Vektor: TVektor): TVektor;
      class function RausfahrvektorBerechnen(index: Integer): TVektor;
      class procedure SteuerbefehlSenden(index: Integer; Vektor: TVektor);
      class procedure GeschwindigkeitenBerechnen(zeit: TDateTime);
      class function ServerdatenEmpfangen: Boolean;

  public
      class procedure Init(Spielfeld: TVektor; IP_Adressen: Array of String; Server_Adresse: String; Port: Integer);
      class procedure Steuern(Spielende: TDateTime);
      class function Anmelden(Teamwahl: TTeam): Boolean;
end;

implementation

{ TKuenstlicheIntelligenz }

class function TKI.Anmelden(Teamwahl: TTeam): Boolean;
begin
  Server.anmelden(Teamwahl);
  if Server.anmelden then
    Formular.Log_Schreiben('Anmelden erfolgreich', Hinweis)
  else
    Formular.Log_Schreiben('Anmelden nicht erfolgreich', Fehler);

end;

class function TKI.AusweichvektorBerechnen(index: Integer; vektor: TVektor): TVektor;
var
  ZielPosition, aktPos: TVektor;
  VWinkel, t: Double;
  i: integer;
  deltaP, deltaV: TVektor;
  deltaWinkel: Double;
begin
  ZielPosition := RoboterDaten[TEAM_BLAU,index].Position + vektor;
  aktPos := RoboterDaten[TEAM_BLAU,index].Position;
  VWinkel := 0;

  if vektor = NULLVEKTOR then exit;

  //Roboter befindet sich in der Nähe des Spielfeldrandes
  //und darf nur in eine Richtung ablenken
  if aktPos.x > Spielfeld.x-RAND then
    if RoboterDaten[TEAM_BLAU,index].Geschwindigkeit.Winkel(vektor.winkel) < pi and
    (RoboterDaten[TEAM_BLAU,index].Geschwindigkeit.Winkel(vektor.winkel) > pi/2) then
      result := RoboterDaten[TEAM_BLAU,index].Geschwindigkeit.Drehen(DegToRad(179))
    else if vektor.winkel(RoboterDaten[TEAM_BLAU,index].Geschwindigkeit.Winkel) < pi and
    (vektor.winkel(RoboterDaten[TEAM_BLAU,index].Geschwindigkeit.Winkel) > pi/2) then
      result := RoboterDaten[TEAM_BLAU,index].Geschwindigkeit.Drehen(-DegToRad(179));
  //Nur für den oberen Spielfeldrand


  //Roboter befindet sich außerhalb des Spielfeldes
  if (aktPos.x>Spielfeld.x) or (aktPos.x<0) or (aktPos.y<0) or (aktPos.y>Spielfeld.y) then
     result := Spielfeld*0.5 - aktPos
  //Aus Ecke herausfahren
  else if (Zielposition.x>Spielfeld.x) and (Zielposition.y>Spielfeld.y) or
          (Zielposition.x>Spielfeld.x) and (Zielposition.y<0) or
          (Zielposition.y>Spielfeld.y) and (Zielposition.x<0) or
          (Zielposition.x<0) and (Zielposition.y<0) then
  begin
    result.x := -(vektor.x);
    result.y := -(vektor.y);
  end
  //Oberen Spielfeldrand nicht überfahren
  else if (Zielposition.y > Spielfeld.y) then begin
    result.y := Spielfeld.y-aktPos.y;
    result.x := Sqrt(Sqr(LAENGE_FLIEHVEKTOR)-Sqr(result.y));
	if vektor.x < 0 then
		result.x := -result.x;
  end
  //Unteren Spielfeldrand nicht überfahren
  else if Zielposition.y < 0 then begin
    result.y := -aktPos.y;
    result.x := Sqrt(Sqr(LAENGE_FLIEHVEKTOR)-Sqr(result.y));
	if vektor.x < 0 then
		result.x := -result.x;
  end
  //Rechten Spielfeldrand nicht überfahren
  else if (Zielposition.x > Spielfeld.x) then begin
    result.x := Spielfeld.x-aktPos.x;
    result.y := Sqrt(Sqr(LAENGE_FLIEHVEKTOR)-Sqr(result.x));
	if vektor.y < 0 then
		result.y := -result.y;
  end
  //Linken Spielfeldrand nicht überfahren
  else if (Zielposition.x < 0) then begin
    result.x := -aktPos.x;
    result.y := Sqrt(Sqr(LAENGE_FLIEHVEKTOR)-Sqr(result.x));
	if vektor.y < 0 then
		result.y := -result.y;
  end;

  //Kollisionen mit TeamRobotern vermeiden
  if index = High(RoboterDaten[TEAM_BLAU]) then Exit;
  if RoboterDaten[TEAM_BLAU,index].Geschwindigkeit.Winkel(vektor.winkel) > AUSWEICHWINKEL then Exit;

  for i := index+1 to High(RoboterDaten[TEAM_BLAU]) do begin
    deltaP := RoboterDaten[TEAM_BLAU,index].Position - RoboterDaten[TEAM_BLAU,i].Position;
    deltaV := RoboterDaten[TEAM_BLAU,index].Geschwindigkeit - RoboterDaten[TEAM_BLAU,i].Geschwindigkeit;
    try
      t := (deltaP.x*deltaV.x+deltaP.y*deltaV.y)/Power(deltaV.Betrag,2);
    except
      on EDivByZero do Continue; // Zu kleines deltaV => Roboter fahren parallel => kein Ausweichen nötig
    end;

    if (t>=0) and (t<5) then
      if ((RoboterDaten[TEAM_BLAU,index].Position+t*RoboterDaten[TEAM_BLAU,index].Geschwindigkeit) -
         (RoboterDaten[TEAM_BLAU,i].Position+t*RoboterDaten[TEAM_BLAU,i].Geschwindigkeit)).Betrag < MINDESTABSTAND then
      begin
        deltaWinkel := RoboterDaten[TEAM_BLAU,i].Geschwindigkeit.winkel - RoboterDaten[TEAM_BLAU,index].Geschwindigkeit.winkel;
        if deltaWinkel < 0 then
          deltaWinkel := deltaWinkel + 2*pi;
        if deltaWinkel < Pi then begin
          // Weiche nach rechts aus
          result := vektor.Drehen(-AUSWEICHWINKEL);
        end
        else begin
          // Weiche nach links aus
          result := vektor.Drehen(AUSWEICHWINKEL);
        end;
      end;
  end;
end;

class function TKI.FangvektorBerechnen(index,ziel: Integer): TVektor;
begin
  result := RoboterDaten[TEAM_Rot,ziel].Position-RoboterDaten[TEAM_BLAU,index].Position;
end;

class function TKI.FliehvektorBerechnen(index,ziel: Integer): TVektor;
begin
  result := RoboterDaten[TEAM_BLAU,index].Position-RoboterDaten[TEAM_rot,ziel].Position;
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
		  RoboterDaten[team,i].Positionsverlauf.Dequeue)*(1/SecondSpan(zeit, ZeitLetzterFrames.Dequeue));
    end;
  end;
end;


class procedure TKI.Init(Spielfeld: TVektor; IP_Adressen: Array of String; Server_Adresse: String; Port: Integer);
var i: Integer;
begin
  Server.Create(Server_Adresse, Port);

  setlength(Roboter, Length(IP_Adressen));
  for i:= Low(Roboter) to High(Roboter) do
  begin
    try
        Roboter[i]:=TTXTMobilRoboter.Create(Ip_Adressen[i]);
        Roboter[i].Start;
    except
        Hauptformular.Log_Schreiben('Verbindung nicht möglich', Fehler);
    end;
  end;
end;

class function TKI.PrioritaetFestlegen(index: Integer; out ziel: Integer): TAktion;
var DeltaVektor: TRoboterDaten;
    KleinsterAbstand,Abstand: Double;
    i,NaechsterRoboter: Integer;
begin
  NaechsterRoboter := 0;
  KleinsterAbstand := (RoboterDaten[TEAM_BLAU,index].Position -
                       RoboterDaten[TEAM_ROT,0].Position).Betrag;

  //Pruefung welcher Roboter vom Team Rot am naehesten am Roboter vom Team Blau ist
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
	if InRange(
		(RoboterDaten[TEAM_BLAU,index].Position - RoboterDaten[TEAM_ROT,NaechsterRoboter].Position)
		  .Winkel(RoboterDaten[TEAM_BLAU,index].Geschwindigkeit), pi*0.5, pi*1.5) then
      Result := FLIEHEN
    else
      Result := FANGEN;
  Except
	on EMathError do Formular.Log_Schreiben('Zwei Roboter haben die gleiche Position oder ein eigener Roboter steht still.', Warnung);
  End;
end;


class function TKI.RausfahrvektorBerechnen(
  index: Integer): TVektor;
var Position: TVektor;
    Abstand: Array[0..3] of Double;
    KAbstand: Double;
begin
   Position := RoboterDaten[TEAM_BLAU,index].Position;
   //Berechnung der Seitenabstände mit der Annahame,
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
  Serverdaten:= Server.StatusEmpfangen;
  for Team in [Team_Blau,Team_Rot] do
  begin
    for i := low(Roboterdaten[Team]) to High(Roboterdaten[Team]) do
    begin
      Roboterdaten[Team,i].Position.x:=Serverdaten.Roboterpositionen[Team,i].x;
      Roboterdaten[Team,i].Position.y:=Serverdaten.Roboterpositionen[Team,i].y;
      Roboterdaten[Team,i].Aktiv:=Serverdaten.RoboterIstAktiv[Team,i];

      Roboterdaten[Team,i].Positionsverlauf.Enqueue(Roboterdaten[Team,i].Position);

      GeschwindigkeitenBerechnen(Serverdaten.Zeit);
    end;
  end;
end;

class procedure TKI.SteuerbefehlSenden(index: Integer; vektor: TVektor);
var
 Roboter_Blau: TTXTMobilRoboter;
 Daten: TRoboterDaten;
 akt_Vektor: tVektor;

const
  Geschwindigkeit= 512;
  c_Radius = 2;         //Konstante zum dehen, auf ° bezogen

begin
  Roboter_Blau:= Roboter[Index];
  akt_Vektor:=Roboterdaten[Team_Blau,Index].Geschwindigkeit;

  if not((akt_Vektor=NULLVEKTOR) or (vektor=NULLVEKTOR)) then
  begin
    if Vektor.Winkel(akt_Vektor)<pi then
    Roboter_Blau.Bewegenalle(Geschwindigkeit,
                                 Geschwindigkeit- round(c_Radius*RadToDeg(Vektor.Winkel(akt_Vektor))))
    else
    Roboter_Blau.Bewegenalle(Geschwindigkeit- round(c_Radius*RadToDeg(Vektor.Winkel(akt_Vektor))),
                                 Geschwindigkeit)
  end;
end;


class procedure TKI.Steuern(spielende: TDateTime);
var einRoboter: TTXTMobilRoboter;
begin
  // Startaufstellung einnehmen
  // Queues füllen

  while True do // Andere Bedingung
  begin
    ServerdatenEmpfangen;
    GeschwindigkeitenBerechnen;
    for einRoboter in Roboter do
    begin

    {if einRoboter then

      if einRoboter.LiesDigital() then
     }
    end;

  end;
end;

end.
