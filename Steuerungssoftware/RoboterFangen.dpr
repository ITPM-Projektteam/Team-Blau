program RoboterFangen;

uses
  Vcl.Forms,
  mTXTMobilRoboter in 'mTXTMobilRoboter.pas',
  mTXTRecordsUndKonstanten in 'mTXTRecordsUndKonstanten.pas',
  mTXTRoboter in 'mTXTRoboter.pas',
  mVektor in 'mVektor.pas',
  mSRWLock in 'mSRWLock.pas',
  mHauptformular in 'mHauptformular.pas' {Hauptformular},
  mTKI in 'mTKI.pas',
  ClientUndServer in 'ClientUndServer.pas',
  Client in 'Client.pas',
  mKonstanten in 'mKonstanten.pas';
  mRoboterDaten in 'mRoboterDaten.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THauptformular, Hauptformular);
  Application.Run;
end.
