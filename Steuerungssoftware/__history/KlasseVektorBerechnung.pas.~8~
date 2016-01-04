unit KlasseVektorBerechnung;

interface

type TVektor = Array[0..1] of Double;

///VektorAddition: Es werden zwei Vektoren(NVektor: NewVektor, OVektor: OldVektor) der
///Funktion für die Berechnung übergeben. Diese werden addiert und
///man erhält einen neuen Vektor als Rückgabewert.
function VektorAddition(NVektor, OVektor: TVektor):TVektor;

///VektorSubtraktion: Es werden zwei Vektoren(NVektor: NewVektor, OVektor: OldVektor) der
///Funktion für die Berechnung übergeben. Diese werden subtrahiert und
///man erhält einen neuen Vektor als Rückgabewert.
function VektorSubtraktion(NVektor, OVektor: TVektor):TVektor;


implementation
function VektorAddition(NVektor, OVektor: TVektor):TVekotr;
//Ausgabevektor mit der Länge 2 mit ganzzahligen Werten
var AVektor: TVektor;
begin
    //Zuerst wird der erste Wert des Ausgabevektors(AVektor) berechnet und
    //anschließend der zweite Wert.
    //Zum Schluss wird der Ausgabevektor(AVektor) zurück gegeben.
	AVektor[0] := NVektor[0] + OVektor[0];
    AVektor[1] := NVektor[1] + OVektor[1];

    Result := AVektor;
end;

function VektorSubtraktion(NVektor, OVektor: TVektor):TVektor;
//Ausgabevektor mit der Länge 2 mit ganzzahligen Werten
var SVektor: TVektor
begin
	//Zuerst wird der erste Wert des Ausgabevektors(SVektor) berechnet und
    //anschließend der zweite Wert.
    //Zum Schluss wird der Ausgabevektor(SVektor) zurück gegeben.
	SVektor[0] := NVektor[0] - OVektor[0];
    SVektor[1] := NVektor[1] - OVektor[1];

    Result := SVektor;
end;

end.
