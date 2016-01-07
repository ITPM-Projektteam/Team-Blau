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
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form1.hide;
  Form2.show;
end;


end.
