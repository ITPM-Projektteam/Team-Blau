unit mRoboterDaten;

interface

  uses mVektor, Generics.Collections;

  type
    TRoboterDaten = record
      Position: TVektor;
      Geschwindigkeit: TVektor;
      Positionsverlauf: TQueue<TVektor>;
      Aktiv: Boolean;
    end;

implementation

end.
