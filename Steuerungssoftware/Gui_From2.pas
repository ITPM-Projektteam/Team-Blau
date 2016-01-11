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
unit Gui_From2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Log_Art= (Hinweis, Warnung, Fehler);
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Button2: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    Button1: TButton;
    M_Log: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Log_Schreiben(Meldung: string; Art: Log_Art);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

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
//  Form1.close;

end;

procedure TForm2.FormCreate(Sender: TObject);
var
  i,j: Integer;
  hilf: String;
begin
  Form2.Hide;

  // Log Datei erzeugen
  assignfile(Log_Datei, 'Log.txt');
  rewrite(Log_Datei);

  // Config Datei erzeuen
  assignfile(Ip_Config, 'IP_Config.txt');
  reset(Ip_Config);

  i:=1;
  j:=1;

  //IP Adressen anzeigen
  while not eof(IP_Config) do
  begin
      readln(IP_Config, hilf);
      if i=2 then
      begin
        Server_IP:=hilf;
        Log_Schreiben('ServerIP ' + hilf, Hinweis);
      end;

      if i>3 then
      begin
        Log_Schreiben('Roboter ' + inttostr(j)+ ' ' + hilf, Hinweis);
        IP_Adressen[j]:=hilf;
        inc(j);
      end;
      inc(i);
  end;

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

//Test
procedure TForm2.Button2Click(Sender: TObject);
begin
  Log_Schreiben('Meldung', Hinweis);
end;

initialization

finalization

CloseFile(Log_Datei);
end.
