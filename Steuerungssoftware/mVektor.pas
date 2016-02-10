//******************************************************************************
{*
 * @file Vorlage_Unit.pas
 * @author Eugen, Sven
 * @date 05.01.2016
 * @brief Dieses Modul stellt einen 2D-Vektortyp für
 *  verschiedene Berechnungen zur Verfügung
 * @copyright Copyright © 2016 Obi8, Nevsor
 *
 * @license
 *
 *  Diese Datei ist Teil von Roboter-Fangen.
 *
 *  Roboter-Fangen ist Freie Software: Sie können es unter den Bedingungen
 *  der GNU General Public License, wie von der Free Software Foundation,
 *  Version 3 der Lizenz oder (nach Ihrer Wahl) jeder späteren
 *  veröffentlichten Version, weiterverbreiten und/oder modifizieren.
 *
 *  Roboter-Fangen wird in der Hoffnung, dass es nützlich sein wird, aber
 *  OHNE JEDE GEWÄHRLEISTUNG, bereitgestellt; sogar ohne die implizite
 *  Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.
 *  Siehe die GNU General Public License für weitere Details.
 *
 *  Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
 *  Programm erhalten haben. Wenn nicht, siehe <http://www.gnu.org/licenses/>.
 *}
//******************************************************************************

unit mVektor;

interface

uses SysUtils, Math;

type TVektor = record
    /// Die Komponenten des Vektors
    x,y: Double;

    /// Komponentenweise Addition zweier Vektoren
    class operator Add(const Summand1, Summand2: TVektor): TVektor;

    /// Komponentenweise Subtraktion zweier Vektoren
    class operator Subtract(const Subtrahend, Minuend: TVektor): TVektor;

    /// Komponentenweise Multiplikation eines Vektors mit einem Skalar
    class operator Multiply(const Skalar:Double;
      const Vektor:TVektor): TVektor; overload;
    /// Komponentenweise Multiplikation eines Skalars mit einem Vektor
    class operator Multiply(const Vektor:TVektor;
      const Skalar:Double): TVektor; overload;
    class operator Equal(const Vektor1, Vektor2: TVektor): Boolean;

    /// Gibt den Winkel des Vektors zurück bezogen auf die x-Achse
    /// @return Winkel in Bogenmaß im halboffenen Intervall [0;2*Pi)
    /// @exception Es wird eine Exception ausgelöst,
    /// wenn der Vektor gleich dem Nullvektor ist
    function Winkel: Double; overload;
    /// Gibt den Winkel des Vektors zurück bezogen auf den Bezugsvektor
    /// @return Winkel in Bogenmaß im halboffenen Intervall [0;2*Pi)
    /// @exception Es wird eine Exception ausgelöst, wenn der Vektor oder der
    /// Bezugsvektor gleich dem Nullvektor ist
    function Winkel(const Bezugsvektor: TVektor): Double; overload;

    /// Gibt die Länge des Vektors zurück (Euklidische Norm)
    function Betrag: Double;

    // Gibt den Vektor nach einer Drehung um einen Winkel zurück
    function Drehen(Winkel: Double): TVektor;

end;

implementation

{ TVektor }

class operator TVektor.Add(const Summand1, Summand2: TVektor): TVektor;
begin
  //Es werden die Komponenten der jeweiligen Vektoren addiert
  //und anschließend zurückgegeben.
  Result.x := Summand1.x + Summand2.x;
  Result.y := Summand1.y + Summand2.y;
end;

class operator TVektor.Subtract(const Subtrahend, Minuend: TVektor): TVektor;
begin
  //Es werden die Komponenten der jeweiligen Vektoren subtrahiert
  //und anschließend zurückgegeben.
  Result.x := Subtrahend.x - Minuend.x;
  Result.y := Subtrahend.y - Minuend.y;
end;

class operator TVektor.Multiply(const Skalar: Double;
  const Vektor: TVektor): TVektor;
begin
  //Es werden die einzelnen Komponenten des Vektors mit einem Skalar
  //multipliziert und zurückgegeben
  Result.x := Skalar * Vektor.x;
  Result.y := Skalar * Vektor.y;
end;

function TVektor.Betrag: Double;
begin
  Result := Sqrt(Sqr(x) + Sqr(y));
end;

function TVektor.Drehen(Winkel: Double): TVektor;
begin
  //Mit der Drehmatrix wird ein neuer Vektor berechnet, der um einen als
  //Parameter übergebenen Winkel nach links(positiv) bzw.
  //rechts(negativ) gedreht ist.
  result.x :=  cos(Winkel)*self.x - sin(Winkel)*self.y;
  result.y :=  sin(Winkel)*self.x + cos(Winkel)*self.y;
end;

class operator TVektor.Equal(const Vektor1, Vektor2: TVektor): Boolean;
begin
  Result := (Vektor1.x = Vektor2.x) and (Vektor1.y = Vektor2.y);
end;

class operator TVektor.Multiply(const Vektor: TVektor;
  const Skalar: Double): TVektor;
begin
	//Es werden die einzelnen Komponenten des Vektors mit einem Skalar
  //multipliziert und zurückgegeben
	Result.x := Skalar * Vektor.x;
  Result.y := Skalar * Vektor.y;
end;

function TVektor.Winkel: Double;
begin
  //Es wird der Winkel zwischen dem Vektor und der X-Achse berechnet und
  //anschließend zurückgegeben.
  if Self.x = 0.0 then // Wenn x = 0, kann arctan(Self.y/Self.x)
                       // nicht berechnet werden.
  begin
    if Self.y > 0.0 then
      Result := Pi * 0.5
    else if y < 0.0 then
      Result := Pi * 1.5
    else
      raise EMathError.Create('Winkel des Nullvektors'+
      ' kann nicht berechnet werden.');
  end
  else
  begin
	  Result := arctan(Self.y/Self.x); // Passt nur für den ersten Quadranten
    if Self.x < 0 then
      Result := Result + Pi // Für den zweiten und dritten Quadranten
    else if Self.y < 0 then
      Result := Result + Pi * 2; // Für den vierten Quadranten
  end;
end;

function TVektor.Winkel( Bezugsvektor: TVektor): Double;
begin
  Result := self.Winkel - Bezugsvektor.Winkel;
  if Result < 0 then
    Result := Result + 2*Pi;
end;

end.
