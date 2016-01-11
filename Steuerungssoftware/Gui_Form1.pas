//******************************************************************************
{*
 * @file Gui_Form1.pas
 * @author Jonah
 * @date 04.01.2016
 * @brief Benutzeroberfläche
 * @copyright Copyright © 2015 ITPM-Projektteam
 *
 * @license
}
//******************************************************************************


unit Gui_Form1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Gui_From2;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    B_Verbinden: TButton;
    Label1: TLabel;
    M_Adressen: TMemo;
    Label2: TLabel;
    Memo1: TMemo;
    E_ServerIP: TEdit;
    procedure B_VerbindenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;



Const
// Anzahl der Roboter als Konstante
AnzRoboter= 4;

var
  Form1: TForm1;
  IP_Config: textfile;
  // Array für die IP Adressen
  IP_Adressen: Array[1..AnzRoboter] of String;
  Server_IP: String;


implementation

{$R *.dfm}

procedure TForm1.B_VerbindenClick(Sender: TObject);
begin
  Form1.hide;
  Form2.show;
end;




procedure TForm1.FormCreate(Sender: TObject);
Var
  i,j: Integer;
  hilf: String;
begin
  assignfile(Ip_Config, 'IP_Config.txt');
  reset(Ip_Config);

  i:=1;
  j:=1;

  while not eof(IP_Config) do
  begin
      readln(IP_Config, hilf);
      if i=2 then
      begin
        Server_IP:=hilf;

      end;

      if i>3 then
      begin
        M_Adressen.Lines.Add(hilf);
        IP_Adressen[j]:=hilf;
        inc(j);
      end;
      inc(i);
  end;

end;

end.
