unit KlasseVektorBerechnung;

interface

///Vektoraddition: Es werden zwei Vektoren(NVektor: NewVektor, OVektor: OldVektor) der
///Funktion für die Berechnung übergeben. Diese werden addiert und
///man erhält einen neuen Vektor als Rückgabewert.
function AVektorBerechnung(NVektor, OVektor: Array[0..1] of Integer):Array[0..1] of Integer;

///Vektorsubtraktion: Es werden zwei Vektoren(NVektor: NewVektor, OVektor: OldVektor) der
///Funktion für die Berechnung übergeben. Diese werden subtrahiert und
///man erhält einen neuen Vektor als Rückgabewert.
function SVektorBerechnung(NVektor, OVektor: Array[0..1] of Integer):Array[0..1] of Integer;


implementation
function AVektorBerechnung(NVektor, OVektor: Array[0..1] of Integer):Array[0..1] of Integer;
///Ausgabevektor mit der Länge 2 mit ganzzahligen Werten
var AVektor: Array[0..1] of Integer;
begin
	///Der erste Wert des Ausgabevektors(AVektor) wird berechnet:
    ///Es wird von dem ersten Wert des NVektors(NewVektor)
    ///der erste Wert des OVektors(OldVektor) hinzu addiert.
    ///Davon wird mit abs() der Betrag gebildet und dem
    ///ersten Wert vom AVektor zugewiesen.
	AVektor[0] := abs(NVektor[0] + OVektor[0]);

    ///Der zweite Wert des Ausgabevektors(AVektor) wird berechnet:
    ///Es wird von dem zweiten Wert des NVektors(NewVektor)
    ///der zweite Wert des OVektors(OldVektor) hinzu addiert.
    ///Davon wird mit abs() der Betrag gebildet und dem
    ///zweiten Wert vom AVektor zugewiesen.
    AVektor[1] := abs(NVektor[1] + OVektor[1]);

    ///Der Ausgabevektor(SVektor) wird zurück gegeben.
    Result := AVektor;
end;

function SVektorBerechnung(NVektor, OVektor: Array[0..1] of Integer):Array[0..1] of Integer;
///Ausgabevektor mit der Länge 2 mit ganzzahligen Werten
var SVektor: Array[0..1] of Integer;
begin
	///Der erste Wert des Ausgabevektors(SVektor) wird berechnet:
    ///Es wird von dem ersten Wert des NVektors(NewVektor)
    ///der erste Wert des OVektors(OldVektor) subtrahiert.
    ///Davon wird mit abs() der Betrag gebildet und dem
    ///ersten Wert vom SVektor zugewiesen.
	SVektor[0] := abs(NVektor[0] - OVektor[0]);

    ///Der zweite Wert des Ausgabevektors(SVektor) wird berechnet:
    ///Es wird von dem zweiten Wert des NVektors(NewVektor)
    ///der zweite Wert des OVektors(OldVektor) subtrahiert.
    ///Davon wird mit abs() der Betrag gebildet und dem
    ///zweiten Wert vom SVektor zugewiesen.
    SVektor[1] := abs(NVektor[1] - OVektor[1]);

    ///Der Ausgabevektor(SVektor) wird zurück gegeben.
    Result := SVektor;
end;

end.
