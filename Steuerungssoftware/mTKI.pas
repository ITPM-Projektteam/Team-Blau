unit mTKI;

interface

uses mVektor, mTXTMobilRoboter, Client, ClientUndServer, DateUtils,
     mHauptformular, Math, Generics.Collections, mRoboterDaten;

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
begin

end;

class function TKI.FangvektorBerechnen(index,ziel: Integer): TVektor;
begin

end;

class function TKI.FliehvektorBerechnen(index,ziel: Integer): TVektor;
begin

end;

class procedure TKI.GeschwindigkeitenBerechnen(zeit: TDateTime);
var
  deltaZeit: Double;
  einRoboter: TRoboterDaten;
  team: TTeam;
  i: Integer;
begin
  ZeitLetzterFrames.Enqueue(zeit);
  deltaZeit := SecondSpan(zeit, ZeitLetzterFrames.Dequeue);

  for team in [TEAM_ROT, TEAM_BLAU] do
  begin
    for i := Low(RoboterDaten[team]) to High(RoboterDaten[team]) do
    begin
      einRoboter.Geschwindigkeit := (RoboterDaten[team,i].Position -
      RoboterDaten[team,i].Positionsverlauf.Dequeue)*(1/deltaZeit);
    end;
  end;
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
        Hauptformular.Log_Schreiben('Verbindung nicht möglich', Fehler);
    end;
  end;
end;

class function TKI.PrioritaetFestlegen(index: Integer; out ziel: Integer): TAktion;
var DeltaVektor: TVektor;
    i,j: Integer;

begin
  j := 0;
  DeltaVektor.x := RoboterDaten[TEAM_BLAU,index].Position.x - RoboterDaten[TEAM_ROT,0].Position.x;
  DeltaVektor.y := RoboterDaten[TEAM_BLAU,index].Position.y - RoboterDaten[TEAM_ROT,0].Position.y;


  for i := Low(RoboterDaten[TEAM_ROT])+1 to High(RoboterDaten[TEAM_ROT]) do
  begin
    if (RoboterDaten[TEAM_ROT,i].Position.x < DeltaVektor.x) and
       (RoboterDaten[TEAM_ROT,i].Position.y < DeltaVektor.y) then
       begin
         DeltaVektor.x := RoboterDaten[TEAM_ROT,i].Position.x;
         DeltaVektor.y := RoboterDaten[TEAM_ROT,i].Position.y;
         j := i;
       end;
  end;

  if (RoboterDaten[TEAM_BLAU,index].Position.Winkel = 0) or (RoboterDaten[TEAM_ROT,j].Position.Winkel = 0) then
  begin
    Formular.Log_Schreiben('Null Vektor', Warnung);
  end
  else if (RoboterDaten[TEAM_BLAU,index].Position.Winkel-RoboterDaten[TEAM_ROT,j].Position.Winkel) < (pi/2) then
  begin
    ziel := j;
    Result := FLIEHEN;
  end
  else
  begin
    ziel := j;
    Result := FANGEN;
  end;
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
begin

end;

class procedure TKI.SteuerbefehlSenden(index: Integer; vektor: TVektor);
begin

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
