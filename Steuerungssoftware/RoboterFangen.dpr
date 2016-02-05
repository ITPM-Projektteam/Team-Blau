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
<<<<<<< HEAD
  ClientUndServer in '..\..\Schiedsrichter-Server\ClientUndServer.pas',
  Client in '..\..\Schiedsrichter-Server\Client.pas',
  mKonstanten in 'mKonstanten.pas';
=======
  ClientUndServer in 'ClientUndServer.pas',
  Client in 'Client.pas',
  mKonstanten in 'mKonstanten.pas',
>>>>>>> refs/remotes/origin/master
  mRoboterDaten in 'mRoboterDaten.pas';

mRoboterDaten in 'mRoboterDaten.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THauptformular, Hauptformular);
  Application.Run;
end.
