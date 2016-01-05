unit KlasseVektorBerechnung;

interface

uses SysUtils, Math;

type TVektor = record
    ///Die Komponenten des Vektors
    x,y: Double;

    ///Komponentenweise Addition zweier Vektoren.
    class operator add(const Summand1, Summand2: TVektor): TVektor;

    ///Komponentenweise Subtraktion zweier Vektoren.
    class operator substract(const Subtrahend, Minuend: TVektor): TVektor;

    ///Komponentenweise Multiplikation zweier Vektoren und anschlie�end
    ///eine Addition.
    class operator SkalarProduct(const Vektor1,Vektor2: TVektor): Double;

    //Es wird der Winkel zwischen den zwei Vektoren berechnet.
    class operator WinkelZwischenVektoren(const Vektor1,Vektor2: TVektor): Double;
end;

implementation

{ TVektor }

class operator TVektor.add(const Summand1, Summand2: TVektor): TVektor;
begin
	//Es werden die Komponenten der jeweiligen Vektoren addiert
    //und anschlie�end zur�ckgegeben.
	Result.x := Summand1.x + Summand2.x;
    Result.y := Summand1.y + Summand2.y;
end;

class operator TVektor.SkalarProduct(const Vektor1, Vektor2: TVektor): Double;
var Skalar: Double;
begin
	//Die jeweiligen Komponenten der Vektoren werden mit einander multipliziert
    //und anschlie�end addiert.
    //Danach wird eine Skalar vom Typ Double zur�ckgegeben.
	Skalar := Vektor1.x * Vektor2.x + Vektor1.y * Vektor2.y;
    Result := Skalar;
end;

class operator TVektor.substract(const Subtrahend, Minuend: TVektor): TVektor;
begin
   //Es werden die Komponenten der jeweiligen Vektoren subtrahiert
   //und anschlie�end zur�ckgegeben.
   Result.x := Subtrahend.x - Minuend.x;
   Result.y := Subtrahend.y - Minuend.y;
end;

class operator TVektor.WinkelZwischenVektoren(const Vektor1, Vektor2: TVektor): Double;
var Skalar, Winkel, ZweiNorm1, ZweiNorm2: Double;
begin
	//Als erstes wird ein Skalarprodukt der beiden Vektoren gebildet.
    //Danach wird von jedem Vektor eine ZweiNorm gebildet.
    //Anschlie�end wird mit der Funktion arccos aus der Divison des
    //Skalarproduktes und dem Produkt der beiden ZweiNormen, der Winkel
    //berechnet und zum Schluss zur�ckgegeben.
	Skalar := add(Vektor1,Vektor2);
    ZweiNorm1 := sqrt(sqr(Vektor1.x)+sqr(Vektor2.x));
    ZweiNorm2 := sqrt(sqr(Vektor1.y)+sqr(Vektor2.y));
    Winkel := arccos(Skalar/(ZweiNorm1*ZweiNorm2));

    Result := Winkel;
end;
end.
