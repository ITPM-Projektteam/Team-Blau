unit Gui_From2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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

procedure TForm2.Button1Click(Sender: TObject);
begin
  Form1.show;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Form2.Hide;
end;

end.
