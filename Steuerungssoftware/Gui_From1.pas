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
unit Gui_From1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, mTXTRoboter, mTXTMobilRoboter;

type
  Log_Art= (Hinweis, Warnung, Fehler);
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Button2: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    B_Verbinden: TButton;
    M_Log: TMemo;
    procedure Roboterverbinden();
    procedure FormCreate(Sender: TObject);
    procedure Log_Schreiben(Meldung: string; Art: Log_Art);
    procedure Button2Click(Sender: TObject);
    procedure B_VerbindenClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    IPConfig: Textfile;
    Server_IP: String;
    IP_Adressen: Array of string;
    Anz_Roboter: Integer;
    Roboter1: TTxtMobilRoboter;
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  Log_Datei: Textfile;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
var
  i,j: Integer;
  hilf: String;
begin

  // Log Datei erzeugen
  assignfile(Log_Datei, 'Log.txt');
  rewrite(Log_Datei);

  // Config Datei erzeuen
  assignfile(IpConfig, 'IP_Config.txt');
  reset(IpConfig);

  i:=1;

  //IP Adressen anzeigen und Speichern
  while not eof(IPConfig) do
  begin
      readln(IPConfig, hilf);
      if i=2 then
      begin
        Server_IP:=hilf;
        Log_Schreiben('ServerIP ' + hilf, Hinweis);
      end;

      if i>3 then
      begin
        setlength(IP_Adressen,Length(IP_Adressen)+1);
        Log_Schreiben('Roboter ' + inttostr(High(IP_Adressen))+ ' ' + hilf, Hinweis);
        IP_Adressen[high(IP_Adressen)]:=hilf;

      end;
      inc(i);
  end;
  Anz_Roboter:=Length(IP_Adressen)+1;
  closeFile(IPConfig);


end;



/// Log Funktion, es wird eine Fehlermeldung als String und eine Priorität (0-3) als Integer Übergeben
/// @param Meldung Beschreibung der Meldung
/// @param Art Entwerder Hinweis Fehler oder Warnung
procedure TForm1.Log_Schreiben(Meldung: string; Art: Log_Art);
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

// Roboter Verbinden
procedure TForm1.Roboterverbinden;
var i: Integer;
    Roboter: array of TTXTMobilRoboter;
begin
  setlength(Roboter, length(IP_Adressen));
  for i:= Low(Roboter) to High(Roboter) do
  begin
    try
        Roboter[i]:=TTXTMobilRoboter.Create(Ip_Adressen[i]);
        Roboter[i].Start;
    except
        Log_Schreiben('Verbindung nicht möglich',Fehler);
    end;
  end;
//  Roboter[0].BewegenAlle(50,-50);
//  Roboter[1].BewegenAlle(50,-50);
end;

//Test
procedure TForm1.Button2Click(Sender: TObject);
begin
  Log_Schreiben('Meldung', Hinweis);
end;

procedure TForm1.B_VerbindenClick(Sender: TObject);
begin
  Roboterverbinden();
end;

initialization

finalization

CloseFile(Log_Datei);
end.
