program RoboterFangen;

uses
  Vcl.Forms,
  mHauptformular in 'mHauptformular.pas' {Hauptformular},
  mTXTMobilRoboter in 'mTXTMobilRoboter.pas',
  mTXTRecordsUndKonstanten in 'mTXTRecordsUndKonstanten.pas',
  mTXTRoboter in 'mTXTRoboter.pas',
  mVektor in 'mVektor.pas',
  mSRWLock in 'mSRWLock.pas',
  mTKI in 'mTKI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THauptformular, Hauptformular);
  Application.Run;
end.
