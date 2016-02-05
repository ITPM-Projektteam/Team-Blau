unit mTKI;

interface

uses mVektor, mTXTMobilRoboter, Client, ClientUndServer, DateUtils,
     mHauptformular, mKonstanten, Math, Generics.Collections, mRoboterDaten;

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
    Abstand := (RoboterDaten[TEAM_BLAU,index].Position -
                RoboterDaten[TEAM_ROT,i].Position).Betrag;
    if Abstand < KleinsterAbstand then
       begin
         KleinsterAbstand := Abstand;
         NaechsterRoboter := i;
       end;
  end;

  //Pruefung ob der Roboter von Team Rot sich vor oder hinter dem Roboter von
  //Team Blau befindet
  if (RoboterDaten[TEAM_BLAU,index].Position = NULLVEKTOR) or
     (RoboterDaten[TEAM_ROT,NaechsterRoboter].Position = NULLVEKTOR) then
  begin
    Formular.Log_Schreiben('Null Vektor', Warnung);
  end
  else if (abs((RoboterDaten[TEAM_BLAU,index].Position.Winkel -
           RoboterDaten[TEAM_ROT,NaechsterRoboter].Position.Winkel)) < (pi/2)) then
  begin
    ziel := NaechsterRoboter;
    Result := FLIEHEN;
  end
  else
  begin
    ziel := NaechsterRoboter;
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
