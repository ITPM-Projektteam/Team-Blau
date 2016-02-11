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
  mKonstanten in 'mKonstanten.pas',
  Client in '..\..\Schiedsrichter-Server\Client.pas',
  ClientUndServer in '..\..\Schiedsrichter-Server\ClientUndServer.pas',
  mRoboterDaten in 'mRoboterDaten.pas',
  GlobaleTypen in '..\..\Schiedsrichter-Server\GlobaleTypen.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THauptformular, Hauptformular);
  Application.Run;
end.
