unit mTKI;

interface

uses mVektor, mTXTMobilRoboter, Client, ClientUndServer, DateUtils,
     mHauptformular, Math, Generics.Collections, mRoboterDaten, SysUtils;

type TAktion = (FANGEN, FLIEHEN);

type TKI = class(TObject)
  strict private
      class var Formular: THauptformular;
      class var ZeitLetzterFrames: TQueue<TDateTime>;
      class var RoboterDaten: Array[TTeam] of Array of TRoboterDaten;
      class var Roboter: Array of TTXTMobilRoboter;
      class var Spielfeld: TVektor;

      class function PrioritaetFestlegen(index: Integer; out Ziel: Integer): TAktion;
      class function FangvektorBerechnen(index, Ziel: Integer): TVektor;
      class function FliehvektorBerechnen(index, Ziel: Integer): TVektor;
      class function AusweichvektorBerechnen(index: Integer; Vektor: TVektor): TVektor;
      class function RausfahrvektorBerechnen(index: Integer): TVektor;
      class procedure SteuerbefehlSenden(index: Integer; Vektor: TVektor);
      class procedure GeschwindigkeitenBerechnen(zeit: TDateTime);
      class function ServerdatenEmpfangen: Boolean;

  public
      class procedure Init(Spielfeld: TVektor; IP_Adressen: Array of String);
      class procedure Steuern(Spielende: TDateTime);
end;

implementation

{ TKuenstlicheIntelligenz }

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
  //Roboter befindet sich au�erhalb des Spielfeldes
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
  //Oberen Spielfeldrand nicht �berfahren
  else if (Zielposition.y > Spielfeld.y) then begin
    result.y := Spielfeld.y-aktPos.y;
    result.x := Sqrt(LAENGE_FLIEHVEKTOR*LAENGE_FLIEHVEKTOR-result.y*result.y);
    if vektor.x < 0 then
      result.x := -result.x;
  end
  //Unteren Spielfeldrand nicht �berfahren
  else if Zielposition.y < 0 then begin
    result.y := -aktPos.y;
    result.x := Sqrt(LAENGE_FLIEHVEKTOR*LAENGE_FLIEHVEKTOR-result.y*result.y);
    if vektor.x < 0 then
      result.x := -result.x;
  end
  //Rechten Spielfeldrand nicht �berfahren
  else if (Zielposition.x > Spielfeld.x) then begin
    result.x := Spielfeld.x-aktPos.x;
    result.y := Sqrt(LAENGE_FLIEHVEKTOR*LAENGE_FLIEHVEKTOR-result.x*result.x);
    if vektor.y < 0 then
      result.y := -result.y;
  end
  //Linken Spielfeldrand nicht �berfahren
  else if (Zielposition.x < 0) then begin
    result.x := -aktPos.x;
    result.y := Sqrt(LAENGE_FLIEHVEKTOR*LAENGE_FLIEHVEKTOR-result.x*result.x);
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
      on EDivByZero do Continue; // Zu kleines deltaV => Roboter fahren parallel => kein Ausweichen n�tig
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
          result.x :=  cos(AUSWEICHWINKEL)*vektor.x + sin(AUSWEICHWINKEL)*vektor.y;
          result.y := -sin(AUSWEICHWINKEL)*vektor.x + cos(AUSWEICHWINKEL)*vektor.y;
        end
        else begin
          // Weiche nach links aus
          result.x :=  cos(-AUSWEICHWINKEL)*vektor.x + sin(-AUSWEICHWINKEL)*vektor.y;
          result.y := -sin(-AUSWEICHWINKEL)*vektor.x + cos(-AUSWEICHWINKEL)*vektor.y;
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
  deltaZeit: Double;
  einRoboter: TRoboterDaten;
  team: TTeam;
begin
  ZeitLetzterFrames.Enqueue(zeit);
  deltaZeit := SecondSpan(zeit, ZeitLetzterFrames.Dequeue);

  for team in [TEAM_ROT, TEAM_BLAU] do
    for einRoboter in RoboterDaten do
      einRoboter.Geschwindigkeit :=
          (einRoboter.Position - einRoboter.Positionsverlauf.Dequeue) *
          (1 / deltaZeit);
end;

class procedure TKI.Init(Spielfeld: TVektor; IP_Adressen: Array of String);
var i: Integer;
begin
  setlength(Roboter, Length(IP_Adressen));
  for i:= Low(Roboter) to High(Roboter) do
  begin
    try
        Roboter[i]:=TTXTMobilRoboter.Create(Ip_Adressen[i]);
        Roboter[i].Start;
    except
        Hauptformular.Log_Schreiben('Verbindung nicht m�glich', Fehler);
    end;
  end;
end;

class function TKI.PrioritaetFestlegen(index: Integer; out ziel: Integer): TAktion;
begin



end;


class function TKI.RausfahrvektorBerechnen(
  index: Integer): TVektor;
var Position: TVektor;
    Abstand: Array[0..3] of Double;
    KAbstand: Double;
begin
   Position := RoboterDaten[TEAM_BLAU,index].Position;
   //Berechnung der Seitenabst�nde mit der Annahame,
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
begin

end;

class procedure TKI.SteuerbefehlSenden(index: Integer; vektor: TVektor);
begin

end;

class procedure TKI.Steuern(spielende: TDateTime);
var einRoboter: TTXTMobilRoboter;
begin
  // Startaufstellung einnehmen
  // Queues f�llen

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
