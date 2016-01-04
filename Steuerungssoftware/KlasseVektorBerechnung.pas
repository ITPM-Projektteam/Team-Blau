unit KlasseVektorBerechnung;

interface

uses SysUtils, Math;

type TVektor = Array[0..1] of Double;

///VektorAddition: Es werden zwei Vektoren(NVektor: NewVektor, OVektor: OldVektor) der
///Funktion f�r die Berechnung �bergeben. Diese werden addiert und
///man erh�lt einen neuen Vektor als R�ckgabewert.
function VektorAddition(NVektor, OVektor: TVektor):TVektor;

///VektorSubtraktion: Es werden zwei Vektoren(NVektor: NewVektor, OVektor: OldVektor) der
///Funktion f�r die Berechnung �bergeben. Diese werden subtrahiert und
///man erh�lt einen neuen Vektor als R�ckgabewert.
function VektorSubtraktion(NVektor, OVektor: TVektor):TVektor;

///VektorSkalarProdukt: Es werden zwei Vektoren(NVektor: NewVektor, OVektor: OldVektor)
///der Funktion f�r die Berechnung �bergeben. Es wird der erste Wert des NVektors
///mit dem ersten Wert des OVektors multipliziert. Anschlie�end addiert man das
///Produkt aus den n�chsten Werten der Vektoren.
function VektorSkalarProdukt(NVektor, OVektor: TVektor): Double;

///VektorWinkel: Es werden zwei Vektoren(NVektor: NewVektor, OVektor: OldVektor)
///der Funktion f�r die Berechnung �bergeben. Als erstes wird das Skalarprodukt
///aus den �bergebenen Vektoren berechnet, dann jeweils die Zwei Norm und
///anschlie�end wird aus der Division von dem Skalarprodukt durch das Produkt
///der beiden Zwei Normen der Winkel mit der Funktion arccos berechnet.
///Als R�ckgabewert erh�lt man einen ganzzahligen Wert.
function VektorWinkel(NVektor, OVektor: TVektor): Double;


implementation
function VektorAddition(NVektor, OVektor: TVektor):TVekotr;
//Ausgabevektor mit der L�nge 2 mit ganzzahligen Werten
var AVektor: TVektor;
begin
    //Zuerst wird der erste Wert des Ausgabevektors(AVektor) berechnet und
    //anschlie�end der zweite Wert.
    //Zum Schluss wird der Ausgabevektor(AVektor) zur�ck gegeben.
	AVektor[0] := NVektor[0] + OVektor[0];
    AVektor[1] := NVektor[1] + OVektor[1];

    Result := AVektor;
end;

function VektorSubtraktion(NVektor, OVektor: TVektor):TVektor;
//Ausgabevektor mit der L�nge 2 mit ganzzahligen Werten
var SVektor: TVektor;
begin
	//Zuerst wird der erste Wert des Ausgabevektors(SVektor) berechnet und
    //anschlie�end der zweite Wert.
    //Zum Schluss wird der Ausgabevektor(SVektor) zur�ck gegeben.
	SVektor[0] := NVektor[0] - OVektor[0];
    SVektor[1] := NVektor[1] - OVektor[1];

    Result := SVektor;
end;

function VektorSkalarProdukt(NVektor, OVektor: TVektor): Double;
//Ein ganzzahliger Wert
var SkalarProdukt: Double;
begin
	//Es wird das Skalarprodukt aus den zwei �bergebenen Vektoren
    //(NVektor, OVektor) berechnet.
    //Anschlie�end wird der Skalar zur�ck gegeben.
	SkalarProdukt := NVektor[0] * OVektor[0] + NVektor[1] * OVektor[1];

    Result := SkalarProdukt;
end;

function VektorWinkel(NVektor, OVektor: TVektor): Double;
//Ganzzahlige Werte
var Winkel, SkalarProdukt, ZweiNormN, ZweiNormO: Double;
begin
	//Zuerst wird das Skalarprodukt aus den beiden �bergebenen Vektoren
    //berechnet. Danach wird von den �bergebenen Vektoren jeweils die Zwei Norm
    //gebildet. Anschlie�end wird der Winkel mit der Funktion arccos berechnet.
    //Zum Schluss wird der Winkel zur�ck gegeben.
    SkalarProdukt := VektorSkalarProdukt(NVektor, OVektor);
    ZweiNormN := sqrt(sqr(NVektor[0])+sqr(NVektor[1]));
    ZweiNormO := sqrt(sqr(OVektor[0])+sqr(OVektor[1]));
    Winkel := arccos(SkalarProdukt/(ZweiNormN * ZweiNormO));

    Result := Winkel;
end;
end.
