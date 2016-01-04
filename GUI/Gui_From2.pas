//******************************************************************************
{*
 * @file Gui_Form2.pas
 * @author Jonah
 * @date 04.01.2016
 * @brief Benutzeroberfl‰che
 * @copyright Copyright © 2015 ITPM-Projektteam
 *
 * @license
}
//******************************************************************************
unit Gui_From2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Onclosequary(Sender: TObject);
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
end;


procedure TForm2.FormCreate(Sender: TObject);
begin
  Form2.Hide;


  // Memo zur Laufzeit erzeugen
  M_Log:=TMemo.Create(self);
  M_Log.Name:= 'Memo_Log';
  M_Log.Parent:=self;
  M_Log.Width:= 217;
  M_Log.Height:=217;
  M_Log.Left:= 365;
  M_Log.Top:= 26;
  M_log.Lines.Clear;

  // Log Datei erzeugen
  assignfile(Log_Datei, 'Log.txt');
  rewrite(Log_Datei);

end;



/// Log Funktion, es wird eine Fehlermeldung als String und eine Priorit‰t (0-3) als Integer ‹bergeben
procedure Log_Schreiben(Meldung: string; Art: Integer);
var Ausgabe: String;
begin
  Ausgabe:= inttostr(Art) + '  '+ Timetostr(now)+ '  ' +  Meldung;
  M_Log.Lines.Add(Ausgabe);
  writeln(Log_Datei, Ausgabe);
end;

//Form1 schlieﬂen wenn Form2 geschlossen wird
procedure TForm2.Onclosequary(Sender: TObject);
begin
  Form1.close;
end;

end.
