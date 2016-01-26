{
Dieses Modul enthält die Klasse TTXTRoboter.

@author Michael Gebing, Sven Stegemann
@date 21.12.2015

Copyright © 2015 FH Münster

Diese Datei ist Teil von libTXT.

libTXT ist Freie Software: Sie können es unter den Bedingungen
der GNU General Public License, wie von der Free Software Foundation,
Version 3 der Lizenz oder (nach Ihrer Wahl) jeder späteren
veröffentlichten Version, weiterverbreiten und/oder modifizieren.

libTXT wird in der Hoffnung, dass es nützlich sein wird, aber
OHNE JEDE GEWÄHRLEISTUNG, bereitgestellt; sogar ohne die implizite
Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.
Siehe die GNU General Public License für weitere Details.

Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
Programm erhalten haben. Wenn nicht, siehe http://www.gnu.org/licenses/.
}

unit mTXTRoboter;

interface

uses Winapi.Windows, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.Graphics, SysUtils, Classes, IdTCPClient,
  mSRWLock, mTXTRecordsUndKonstanten;

type

 {
  Die Grundklasse für die Steuerung des TXT-Controllers.

  Stellt die wichtigsten Funktionen des TXT-Protokolls zur Verfügung.
  In abgeleiteten Klassen (z.B. TTXTMobilRoboter) können Vereinfachungen
  und Anpassungen an den jeweiligen Schaltplan des Roboters vorgenommen
  werden. Dies betrifft vor allem die Variable konfiguration.

  @see TTXTMobilRoboter
  }
  TTXTRoboter = class
  protected
    var konfiguration: ftIF2013Command_UpdateConfig; //< Die Konfiguration des Roboters (z.B: Motor- und Inputmodi)
    var befehle: ftIF2013Command_ExchangeData; //< Die Befehle, die dem Roboter beim nächsten SendeAustausch geschickt werden
    var antworten: ftIF2013Response_ExchangeData; //< Die Informationen, die der Roboter beim letzten SendeAustausch geschickt hat
    var kamerabild: TJpegImage; //< TODO: Beschreibung

    var IdTCPClient_Normal: TIdTCPClient; //< Der TCP-Client für die Kommunikation mit dem Roboter (außer Kamerabilder)
    var IdTCPClient_Kamera: TIdTCPClient; //< Der TCP-Client für die Übertragung der Kamerabilder

    var LVerbindungNormal: TRTLCriticalSection; //< Regelt den Zugriff auf IdTCPClient_Normal (für Multi-Threading)
    var LVerbindungKamera: TRTLCriticalSection; //< Regelt den Zugriff auf IdTCPClient_Kamera (für Multi-Threading)
    var LKonfiguration: TSRWLock; //< Regelt den Zugriff auf konfiguration (für Multi-Threading)
    var LBefehle: TSRWLock; //< Regelt den Zugriff auf befehle (für Multi-Threading)
    var LAntworten: TSRWLock; //< Regelt den Zugriff auf antworten (für Multi-Threading)
    var LKamerabild: TSRWLock; //< Regelt den Zugriff auf kamerabild (für Multi-Threading)

    {
      Sendet Daten an den Roboter und empfängt die Antwort.
      Diese Funktion bildet die Grundlage für die Funktionen SendeAustausch, SendeKonfig und HoleStatus.

      @param Nachricht Beinhaltet die Daten, die gesendet werden sollen.
      @param Antwort Beinhaltet die Daten, die empfangen wurden (wird in der Methode erzeugt).
      @param AntwortLaenge Die Anzahl Bytes, die vom Roboter empfangen werden sollen.
      @return True, wenn beim Senden und Empfangen keine Fehler aufgetreten sind.

      @comment Der Aufruf dieser Methode ist thread-sicher bezüglich des Zugriffs auf IdTCPClient_Normal
    }
    function Senden(Nachricht: TMemoryStream; out Antwort: TMemoryStream; AntwortLaenge: Int64): Boolean;
    function SendeAustausch: Boolean; //< Sendet befehl an den Roboter und schreibt die Antwort in antworten.
    function SendeKonfig: Boolean; //< Sendet konfiguration als neue Konfiguration an den Roboter.
    function HoleStatus: ftIF2013Response_QueryStatus; /// Fragt einige Informationen des Roboters ab (Version, etc.)

    function Verbinden: Boolean; //< Baut eine TCP-Verbindung zum Roboter auf´, wechselt in den Online-Modus und ruft SendeKonfig auf. TODO Funktionalität aufteilen?
    function Trennen: Boolean; //< Beendet den Online-Modus und trennt die TCP-Verbindung.

  public

    constructor Create(IP_Adresse: String); reintroduce;

    destructor Destroy; override;

    {
      Gibt den Wert des Counters mit dem angegebenen Index zurück.

      @comment Der Wert entspricht dem Wert zum Zeitpunkt des letzten Aufrufes von SendeAustausch.
    }
    function LiesCounter(Index: Integer): Integer;

    {
      Gibt den Zustand des digitalen Eingangs mit dem angegebenen Index zurück.
      Der Modus der Eingänge wird durch SendeKonfig gesetzt.

      @comment Der Wert entspricht dem Wert zum Zeitpunkt des letzten Aufrufes von SendeAustausch.
    }
    function LiesDigital(Index: Integer): Boolean;

    {
      Gibt den Zustand des digitalen Eingangs mit dem angegebenen Index zurück.
      Der Modus der Eingänge wird durch SendeKonfig gesetzt.

      @comment Der Wert entspricht dem Wert zum Zeitpunkt des letzten Aufrufes von SendeAustausch.
    }
    function LiesAnalog(Index: Integer): Integer;

    {
      Gibt das als letztes empfangene Kamerabild als TJpegImage zurück.
      KamerabildJpeg eignet sich zum Anzeigen von Bildern,
      KamerabildBitmap hingegen zum Zugriff auf Pixeldaten (z.B. für Bilderkennung)
      Damit Kamerabilder übertragen werden, muss StarteKamera aufgerufen werden.

      @comment Noch nicht implementiert
    }
    function KamerabildJpeg: TJpegImage;

    {
      Gibt das als letztes empfangene Kamerabild als TBitmap zurück.
      KamerabildJpeg eignet sich zum Anzeigen von Bildern,
      KamerabildBitmap hingegen zum Zugriff auf Pixeldaten (z.B. für Bilderkennung)
      Damit Kamerabilder übertragen werden, muss StarteKamera aufgerufen werden.

      @comment Noch nicht implementiert
    }
    function KamerabildBitmap: TBitmap;

    {
      Startet die Kamera.
      Die Bilder müssen mit EmpfangeBild gelesen werden.

      @return True, wenn keine Fehler aufgetreten sind.
      @comment noch nicht implementiert
    }
    function StarteKamera: Boolean;
  end;

implementation

{ TTXTController }

constructor TTXTRoboter.Create(IP_Adresse: String);
begin
  inherited Create;

  InitializeCriticalSection(LVerbindungNormal);
  InitializeCriticalSection(LVerbindungKamera);
  LKonfiguration := TSRWLock.Create;
  LBefehle := TSRWLock.Create;
  LAntworten := TSRWLock.Create;
  LKamerabild := TSRWLock.Create;
  IdTCPClient_Normal := TIdTCPClient.Create;
  IdTCPClient_Kamera := TIdTCPClient.Create;

  FillChar(befehle, sizeof(befehle), #0);
  FillChar(konfiguration, sizeof(konfiguration), #0);
  befehle.m_id := ftIF2013CommandId_ExchangeData;
  konfiguration.m_id := ftIF2013CommandId_UpdateConfig;

  IdTCPClient_Normal.Host := IP_Adresse;
  IdTCPClient_Normal.Port := 65000;

  IdTCPClient_Kamera.Host := IP_Adresse;
  IdTCPClient_Kamera.Port := 65001;
end;

destructor TTXTRoboter.Destroy;
begin
  DeleteCriticalSection(LVerbindungNormal);
  DeleteCriticalSection(LVerbindungKamera);

  FreeAndNil(LKonfiguration);
  FreeAndNil(LBefehle);
  FreeAndNil(LAntworten);
  FreeAndNil(LKamerabild);

  FreeAndNil(IdTCPClient_Normal);
  FreeAndNil(IdTCPClient_Kamera);

  FreeAndNil(kamerabild);

  inherited;
end;

function TTXTRoboter.KamerabildBitmap: TBitmap;
begin

end;

function TTXTRoboter.KamerabildJpeg: TJpegImage;
begin

end;

function TTXTRoboter.LiesAnalog(Index: Integer): Integer;
begin
  LAntworten.AcquireShared;
  try
    Result := antworten.m_universalInputs[Index - 1];
  finally
    LAntworten.ReleaseShared;
  end;
end;

function TTXTRoboter.LiesCounter(Index: Integer): Integer;
begin
  LAntworten.AcquireShared;
  try
    Result := antworten.m_counter_value[Index - 1];
  finally
    LAntworten.ReleaseShared;
  end;
end;

function TTXTRoboter.LiesDigital(Index: Integer): Boolean;
begin
  LAntworten.AcquireShared;
  try
    Result := not(antworten.m_universalInputs[Index - 1] = 0);
  finally
    LAntworten.ReleaseShared;
  end;
end;

function TTXTRoboter.Senden(Nachricht: TMemoryStream;
  out Antwort: TMemoryStream; AntwortLaenge: Int64): Boolean;
begin
  if not IdTCPClient_Normal.Connected then
  begin
    ShowMessage('Der TXT-Controller ist nicht verbunden!');
    Result := False;
    Exit;
  end;

  try
    // Senden
    Nachricht.Position := 0;
    EnterCriticalSection(LVerbindungNormal);
    try
      IdTCPClient_Normal.IOHandler.Write(Nachricht, Nachricht.Size);

      // Empfangen
      Antwort := TMemoryStream.Create;
      IdTCPClient_Normal.IOHandler.ReadStream(Antwort, AntwortLaenge, False);
      IdTCPClient_Normal.IOHandler.InputBuffer.Clear;
    finally
      LeaveCriticalSection(LVerbindungNormal);
    end;
    Antwort.Position := 0;

    Result := True;
  except
    ShowMessage
      ('Fehler in Funktion TTXTRoboter.Senden; Verbindung abgebrochen?');
    Result := False;
  end;
end;

function TTXTRoboter.StarteKamera: Boolean;
var
  StartCam: FTXStartCam;
  //RecDataCam: KameraData;
  Kommando, Antwort: TMemoryStream;
  ID: Int32;
begin

// Aus dem C++-Beispielcode:
//
// Start camera server
// Tested resolutions/frame rates are
// 160 x 120 @ 60fps (useful for closed loop control applications)
// 320 x 240 @ 30fps
// 640 x 480 @ 15fps (might lead to frame drops / distortions, especially over WiFi/BT)
// Other resolutions might be supported, see "Resolutions.txt"
// Many resolutions which are supported by the camera overload the TXT,
// so there is no guarantee that any of these work!
// Also the ft-camera seems to have some bugs, e.g. 1280x960 result in 1280x720.
// More expensive cameras with large internal buffers might support higher resolutions.
//
// width         = requested frame width
// height        = requested frame height
// framerate     = requested frame rate in frames per second
// powerlinefreq = Frequency of artificial illumination
// This is required to adjust exposure to avoid flicker
// Supported values are 50 and 60

  // Grundeinstellungen
  StartCam.m_id := ftIF2013CommandId_StartCameraOnline;

  // Tested resolutions
  // frame rates for the ft-camera are 320x240@30fps and 640x480@15fps
  StartCam.m_width := 320;
  StartCam.m_height := 240;
  StartCam.m_framerate := 30;
  StartCam.m_powerlinefreq := 0; // 0=auto, 1=50Hz, 2=60Hz

  Kommando := TMemoryStream.Create;
  Kommando.Write(StartCam, sizeof(StartCam));
  Result := Senden(Kommando, Antwort, sizeof(ID));

  if Result = False then
    Exit;

  Antwort.Read(ID, sizeof(ID));

  if ID <> Int32(ftIF2013ResponseId_StartCameraOnline) then
  begin
    ShowMessage('Falsche ID; ftIF2013ResponseId_StartCameraOnline erwartet');
    Result := False;
    Exit;
  end;


end;

function TTXTRoboter.Trennen: Boolean;
begin
  // TODO: StopOnline senden
  IdTCPClient_Normal.Disconnect;
  Result := True;
end;

function TTXTRoboter.HoleStatus: ftIF2013Response_QueryStatus;
var
  Kommando: TMemoryStream;
  Antwort: TMemoryStream;
  ZwSp: Int32;
  status: ftIF2013Response_QueryStatus;
begin
  Kommando := TMemoryStream.Create;

  Kommando.Position := 0;
  ZwSp := ftIF2013CommandId_QueryStatus;
  Kommando.Write(ZwSp, sizeof(ZwSp));

  Senden(Kommando, Antwort, sizeof(status));
  Antwort.Read(status, sizeof(status));

  FreeAndNil(Kommando);
  FreeAndNil(Antwort);
end;

function TTXTRoboter.SendeAustausch(): Boolean;
var
  Kommando: TMemoryStream;
  Antwort: TMemoryStream;
begin
  Kommando := TMemoryStream.Create;

  Kommando.Position := 0;
  LBefehle.AcquireShared;
  Kommando.Write(befehle, sizeof(befehle));
  LBefehle.ReleaseShared;

  Result := Senden(Kommando, Antwort, sizeof(antworten) - 1);
  LAntworten.AcquireExclusive;
  Antwort.Read(antworten, sizeof(antworten));
  LAntworten.ReleaseExclusive;

  FreeAndNil(Kommando);
  FreeAndNil(Antwort);
end;

function TTXTRoboter.SendeKonfig: Boolean;
var
  Kommando: TMemoryStream;
  Antwort: TMemoryStream;
  ID: Int32;
begin
  Kommando := TMemoryStream.Create;

  Kommando.Position := 0;
  LKonfiguration.AcquireExclusive;
  Inc(konfiguration.m_config_id);
  Kommando.Write(konfiguration, sizeof(konfiguration));
  LKonfiguration.ReleaseExclusive;

  Result := Senden(Kommando, Antwort, sizeof(ID));
  Antwort.Read(ID, sizeof(ID));

  if ID <> Int32(ftIF2013ResponseId_UpdateConfig) then
  begin
    ShowMessage('Falsche ID; ftIF2013ResponseId_UpdateConfig erwartet');
    Result := False;
  end;

  FreeAndNil(Kommando);
  FreeAndNil(Antwort);
end;

function TTXTRoboter.Verbinden: Boolean;
var
  Kommando, Antwort: TMemoryStream;
  name: array [0 .. 63] of AnsiChar;
  ID: Int32;
begin
  Try
    EnterCriticalSection(LVerbindungNormal);

    if IdTCPClient_Normal.Connected then
    begin
      Result := False;
      Exit;
    end;

    Try
      IdTCPClient_Normal.Connect;
    Except
      ShowMessage('Verbindung kann nicht hergestellt werden!' + System.sLineBreak +
                  'Ist der Controller eingeschaltet und in Reichweite?');
      Result := False;
      Exit;
    End;
  Finally
    LeaveCriticalSection(LVerbindungNormal);
  End;

  ID := ftIF2013CommandId_StartOnline;
  Kommando := TMemoryStream.Create;
  Kommando.Write(ID, sizeof(ID));
  Kommando.Write(name, sizeof(name));

  Result := Senden(Kommando, Antwort, sizeof(ID));
  Antwort.Read(ID, sizeof(ID));

  if ID <> Int32(ftIF2013ResponseId_StartOnline) then
  begin
    ShowMessage('Falsche ID; ftIF2013ResponseId_StartOnline erwartet');
    Result := False;
    Exit;
  end;

  LKonfiguration.AcquireExclusive;
  konfiguration.m_config_id := 0;
  LKonfiguration.ReleaseExclusive;

  SendeKonfig;

  FreeAndNil(Kommando);
  FreeAndNil(Antwort);
end;

end.
