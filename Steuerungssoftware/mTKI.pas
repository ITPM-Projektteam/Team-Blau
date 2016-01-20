unit mTKI;

interface

uses mVektor, mTXTMobilRoboter, Client, ClientUndServer;

type TAktion = (FANGEN,FLIEHEN);

type TKI = class(TObject)
	  strict private
    	  //gegnerPositionen: Array of TQueue<TVektor>;
        //unserePositionen: Array of TQueue<TVektor>;
        Positionen: Array[TTeam] of Array of TQueue<TVektor>;
        Geschwindigkeiten: Array[TTeam] of TVektor;
        //gegnerGeschwindigkeiten: Array of TQueue<TVektor>;
        //unsereGeschwindigkeiten: Array of TQueue<TVektor>;
        roboter: Array of TTXTMobilRoboter;
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

class function TKI.AusweichvektorBerechnen(index: Integer;
  vektor: TVektor): TVektor;
begin

end;

class function TKI.FangvektorBerechnen(index,
  ziel: Integer): TVektor;
begin

end;

class function TKI.FliehvektorBerechnen(index,
  ziel: Integer): TVektor;
begin

end;

class procedure TKI.GeschwindigkeitenBerechnen;
begin

end;

class procedure TKI.Init(anzahlRoboter: Integer;
  spielfeld: TVektor);
begin

end;

class function TKI.PrioritaetFestlegen(index: Integer;
  out ziel: Integer): TAktion;
begin

end;

class function TKI.RausfahrvektorBerechnen(
  index: Integer): TVektor;
begin

end;

class procedure TKI.SteuerbefehlSenden(index: Integer;
  vektor: TVektor);
begin

end;

class procedure TKI.Steuern(spielende: TDateTime);
begin

end;

end.
