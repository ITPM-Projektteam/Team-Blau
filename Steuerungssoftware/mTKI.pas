unit mTKI;

interface

uses mVektor, mTXTMobilRoboter, Client, ClientUndServer, mHauptformular, Generics.Collections;

type TAktion = (FANGEN,FLIEHEN);

type TKI = class(TObject)
	strict private
        class var Formular: THauptformular;
        class var Positionen: Array[TTeam] of Array of TQueue<TVektor>;
        class var Geschwindigkeiten: Array[TTeam] of Array of TVektor;
        class var Roboter: Array of TTXTMobilRoboter;
        class var Spielfeld: TVektor;
        class var Zeit: TQueue<TDateTime>;

        class function PrioritaetFestlegen(index: Integer; out Ziel: Integer): TAktion;
        class function FangvektorBerechnen(index, Ziel: Integer): TVektor;
        class function FliehvektorBerechnen(index, Ziel: Integer): TVektor;
        class function AusweichvektorBerechnen(index: Integer; Vektor: TVektor): TVektor;
        class function RausfahrvektorBerechnen(index: Integer): TVektor;
        class procedure SteuerbefehlSenden(index: Integer; Vektor: TVektor);
        class procedure GeschwindigkeitenBerechnen;

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

class procedure TKI.GeschwindigkeitenBerechnen;
begin

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

class function TKI.RausfahrvektorBerechnen(index: Integer): TVektor;
begin

end;

class procedure TKI.SteuerbefehlSenden(index: Integer; vektor: TVektor);
begin

end;

class procedure TKI.Steuern(spielende: TDateTime);
begin

end;

end.
