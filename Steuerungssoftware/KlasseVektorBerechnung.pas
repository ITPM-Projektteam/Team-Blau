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

    ///Komponentenweise multiplikation eines Vektors mit einem Skalar
    class operator multiply(Skalar:Double; Vektor1:TVektor): TVektor;

    //Gibt den Winkel zwischen dem Vektor und der X-Achse zur�ck
    function Winkel:Double;
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

class operator TVektor.multiply(Skalar: Double; Vektor: TVektor): TVektor;
begin
	//Es werden die einzelnen Komponenten des Vektors mit einem Skalar
    //multipliziert und zur�ckgegeben
	Result.x := Skalar * Vektor.x;
    Result.y := Skalar * Vektor.y;
end;

class operator TVektor.substract(const Subtrahend, Minuend: TVektor): TVektor;
begin
   //Es werden die Komponenten der jeweiligen Vektoren subtrahiert
   //und anschlie�end zur�ckgegeben.
   Result.x := Subtrahend.x - Minuend.x;
   Result.y := Subtrahend.y - Minuend.y;
end;

function TVektor.Winkel: Double;
begin
	//Es wird der Winkel zwischen dem Vektor und der X-Achse berechnet und
    //anschlie�end zur�ckgegeben.
	Result := arctan(Self.y/Self.x);
end;
end.
