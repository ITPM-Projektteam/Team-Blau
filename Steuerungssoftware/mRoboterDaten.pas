unit mRoboterDaten;

interface

  uses mVektor, Generics.Collections, ClientUndServer;

  type

    TRoboterDaten = record
      Position: TVektor;
      Geschwindigkeit: TVektor;
      Positionsverlauf: TQueue<TVektor>;
      Aktiv: Boolean;
    end;
    A_Roboterdaten= Array[TTeam] of array of TRoboterDaten;

implementation

end.
