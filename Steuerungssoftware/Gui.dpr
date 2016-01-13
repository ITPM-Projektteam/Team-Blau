//******************************************************************************
{*
 * @file Gui.exe
 * @author Jonah
 * @date 04.01.2016
 * @brief Benutzeroberfl�che
 * @copyright Copyright � 2015 ITPM-Projektteam
 *
 * @license
 *
 *  Diese Datei ist Teil von ***.
 *
 *  *** ist Freie Software: Sie k�nnen es unter den Bedingungen
 *  der GNU General Public License, wie von der Free Software Foundation,
 *  Version 3 der Lizenz oder (nach Ihrer Wahl) jeder sp�teren
 *  ver�ffentlichten Version, weiterverbreiten und/oder modifizieren.
 *
 *  *** wird in der Hoffnung, dass es n�tzlich sein wird, aber
 *  OHNE JEDE GEW�HRLEISTUNG, bereitgestellt; sogar ohne die implizite
 *  Gew�hrleistung der MARKTF�HIGKEIT oder EIGNUNG F�R EINEN BESTIMMTEN ZWECK.
 *  Siehe die GNU General Public License f�r weitere Details.
 *
 *  Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
 *  Programm erhalten haben. Wenn nicht, siehe <http://www.gnu.org/licenses/>.
 *}
//******************************************************************************

program Gui_exe;

uses
  Vcl.Forms,
  Gui_From1 in 'Gui_From1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
//  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
