unit TKI;

interface

uses mVektor, mTXTMobilRoboter;

type TAktion = (FANGEN,FLIEHEN);

type TKuenstlicheIntelligenz = class(TObject)
	strict private
    	gegnerPositionen: Array of TQueue<TVektor>;
        unserePositionen: Array of TQueue<TVektor>;
        gegnerGeschwindigkeiten: Array of TQueue<TVektor>;
        unsereGeschwindigkeiten: Array of TQueue<TVektor>;
        roboter: TTXTMobilRoboter;
        spielfeld: TVektor;

        class function PrioritaetFestlegen(index: Integer; out ziel: Integer): TAktion;
        class function FangvektorBerechnen(index, ziel: Integer): TVektor;
        class function FliehvektorBerechnen(index, ziel: Integer): TVektor;
        class function AusweichvektorBerechnen(index: Integer; vektor: TVektor): TVektor;
        class function RausfahrvektorBerechnen(index: Integer): TVektor;
        class procedure SteuerbefehlSenden(index: Integer; vektor: TVektor);
        class procedure GeschwindigkeitenBerechnen;

    public
    	class procedure Init(anzahlRoboter: Integer; spielfeld: TVektor);
        class procedure Steuern(spielende: TDateTime);
end;

implementation

{ TKuenstlicheIntelligenz }

class function TKuenstlicheIntelligenz.AusweichvektorBerechnen(index: Integer;
  vektor: TVektor): TVektor;
begin

end;

class function TKuenstlicheIntelligenz.FangvektorBerechnen(index,
  ziel: Integer): TVektor;
begin

end;

class function TKuenstlicheIntelligenz.FliehvektorBerechnen(index,
  ziel: Integer): TVektor;
begin

end;

class procedure TKuenstlicheIntelligenz.GeschwindigkeitenBerechnen;
begin

end;

class procedure TKuenstlicheIntelligenz.Init(anzahlRoboter: Integer;
  spielfeld: TVektor);
begin

end;

class function TKuenstlicheIntelligenz.PrioritaetFestlegen(index: Integer;
  out ziel: Integer): TAktion;
begin

end;

class function TKuenstlicheIntelligenz.RausfahrvektorBerechnen(
  index: Integer): TVektor;
begin

end;

class procedure TKuenstlicheIntelligenz.SteuerbefehlSenden(index: Integer;
  vektor: TVektor);
begin

end;

class procedure TKuenstlicheIntelligenz.Steuern(spielende: TDateTime);
begin

end;

end.
