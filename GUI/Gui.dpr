program Gui_exe;

uses
  Vcl.Forms,
  Gui_Form1 in 'Gui_Form1.pas' {Form1},
  Gui_From2 in 'Gui_From2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
