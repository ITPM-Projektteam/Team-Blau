//******************************************************************************
{*
 * @file Gui_Form2.pas
 * @author Jonah
 * @date 04.01.2016
 * @brief Benutzeroberfläche
 * @copyright Copyright © 2015 ITPM-Projektteam
 *
 * @license
}
//******************************************************************************
unit Gui_Form2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Log_Art= (Hinweis, Warnung, Fehler);
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    M_Log: TMemo;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Log_Schreiben(Meldung: string; Art: Log_Art);
    procedure Button2Click(Sender: TObject);
    procedure InputEingabedaten;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

const SPIELFELDBREITE = {};
			SPIELFELDHOEHE = {};

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Gui_Form1;

var M_Log: TMemo;
  Log_Datei: Textfile;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Form1.show;
  Form1.Formstyle:=fsStayOnTop;
end;

//Form1 schließen wenn Form2 geschlossen wird
procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Form1.close;

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Form2.Hide;

  // Log Datei erzeugen
  assignfile(Log_Datei, 'Log.txt');
  rewrite(Log_Datei);

end;

/// Log Funktion, es wird eine Fehlermeldung als String und eine Priorität (0-3) als Integer Übergeben
/// @param Meldung Beschreibung der Meldung
/// @param Art Entwerder Hinweis Fehler oder Warnung
procedure TForm2.Log_Schreiben(Meldung: string; Art: Log_Art);
var Ausgabe: String;
begin
  case art of
    Hinweis: Ausgabe:= '[Hinweis]  '+ Timetostr(now)+ '  ' +  Meldung ;
    Warnung: Ausgabe:= '[Warnung]  '+ Timetostr(now)+ '  ' +  Meldung;
    Fehler: Ausgabe := '[Fehler]   '+ Timetostr(now)+ '  ' +  Meldung;
  end;

  M_Log.Lines.Add(Ausgabe);
  writeln(Log_Datei, Ausgabe);
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Log_Schreiben('Meldung', Hinweis);
end;

procedure TForm2.InputEingabedaten;
var i: Integer;
begin
	for i := 1 to Gui_Form1.AnzRoboter do
  begin
    If {BezeichnerRoboter[id].InputDigital(3) or BezeichnerRoboter[id].InputDigital(4)} then
  	begin
    	Log_Schreiben('Roboter ' + IntToStr(i) + ' wurde gefangen!', 'Hinweis');
    	//An den Server senden, dass der Roboter gefangen wurde
  	end;
  end;
end;

initialization

finalization

CloseFile(Log_Datei);
end.
