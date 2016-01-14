program RoboterFangen;

uses
  Vcl.Forms,
  Hauptformular in 'Hauptformular.pas' {Form1},
  mTXTMobilRoboter in 'mTXTMobilRoboter.pas',
  mTXTRecordsUndKonstanten in 'mTXTRecordsUndKonstanten.pas',
  mTXTRoboter in 'mTXTRoboter.pas',
  mVektor in 'mVektor.pas',
  mSRWLock in 'mSRWLock.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
