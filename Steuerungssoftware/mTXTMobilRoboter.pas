{
Dieses Modul enthält die Klasse TTXTMobilRoboter.

@author Sven Stegemann
@date 06.01.2016

Copyright © 2015, 2016 FH Münster

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

unit mTXTMobilRoboter;

interface

uses mTXTRoboter, mTXTRecordsUndKonstanten, Classes, Math, SysUtils;

type
  TTXTMobilRoboter = class; // Vorwärtdeklaration zum Vermeiden zirkulärer Abhängigkeiten mit dem Threadklassen
  TCallback = procedure;

  /// Thread-Klasse für die Kommunikation mit dem Roboter im Hintergrund (außer Kamera)
  TNetzwerkThread = class(TThread)
    private
      delay: Integer; //< Die Zeit die nach jedem Datenaustausch gewartet werden soll in Millisekunden
      roboter: TTXTMobilRoboter; //< Der Roboter, mit dem kommuniziert wird.
      callback: TCallback; //< Callback-Funktion die nach jedem Datenaustausch aufgerufen wird.
    public
      /// Baut eine Verbindung zu dem Roboter auf und startet den gesteuerten Modus.
      /// Im Hintergrund werden - bis der Thread beendet wird - die aktuellen Befehle gesendet
      /// und die Eingabedaten ausgelesen (Datenaustausch).
      /// Nach jedem Datenaustausch wird delay Millisekunden gewartet.
      constructor Create(roboter: TTXTMobilRoboter; delay: Integer = 100; callback: TCallback = nil);
      procedure Execute; override;
  end;

  /// Thread-Klasse für das Empfangen der Kamerabilder
  ///
  /// @comment diese Klasse ist noch nicht implementiert!
  TKameraThread = class(TThread)
    private
      delay: Integer; //< Die Zeit die nach jedem Frame gewartet werden soll
      roboter: TTXTMobilRoboter; //< Der Roboter, dessen Kamera wiedergegeben wird.
      callback: TCallback; //< Callback-Funktion die nach jedem Kamerabild aufgerufen wird.
    public
      /// Startet die Übertragung der Kamerabilder und empfängt diese.
      /// Nach jedem empfangenen Bild wird delay Millisekunden gewartet.
      constructor Create(roboter: TTXTMobilRoboter; delay: Integer = 100; callback: TCallback = nil);
      procedure Execute; override;
  end;

  {
  Die Klasse für die Steuerung des bei uns benutzten Roboters.

  Ermöglicht einen einfacheren Zugriff auf den Roboter.
  Diese Klasse benutzt die Methoden der Oberklasse TTXTRoboter, passt sie jedoch
  für unseren Anwendungsfall (Roboter mit 2 Motoren M1 und M2 und 2 Tastern I5 und I6) an.

  @see TTXTRoboter
  }

  TTXTMobilRoboter = class(TTXTRoboter)
  protected
    var
      nwThread: TNetzwerkThread; //< Der Thread für die nebenläufige Kommunikation mit dem Roboter
      kamThread: TKameraThread; //< Der Thread für das nebenläufige Empfangen der Kamerabilder
      ID: Integer;
  public

    constructor Create(IP_Adresse: String; ID: Integer);

    destructor Destroy;

    /// Öffnet eine Verbindung zu dem Roboter und startet den gesteuerten Modus.
    /// Muss aufgerufen werden, bevor der Roboter gesteuert werden kann.
    procedure Start;

    /// Schließt die Verbindung zu dem Roboter.
    procedure Ende;

    /// Bewegt einen Motor bis ein neuer Befehl für diesen Motor übergeben wird.
    /// @param Index Der Index des zu bewegenden Motors: 1 oder 2
    /// @param Geschwindigkeit Motorgeschwindigkeit im Bereich 0-512.
    procedure BewegenEiner(Index: Integer; Geschwindigkeit: Integer = 512);

    /// Bewegt einen Motor für eine vorgegebene Anzahl Schritte oder bis ein
    /// neuer Befehl für diesen Motor übergeben wird.
    /// @param Index Der Index des zu bewegenden Motors: 1 oder 2
    /// @param Schritte Die Anzahl Schritte, die der Motor bewegt werden soll.
    /// @param Geschwindigkeit Motorgeschwindigkeit: Ganzzahl im Bereich 0-512.
    procedure BewegenEinerBis(Index, Schritte: Integer; Geschwindigkeit: Integer = 512);

    /// Bewegt alle Motoren bis ein neuer Befehl für die jeweiligen Motoren übergeben wird.
    /// @param GeschwindigkeitRechts Motorgeschwindigkeit für den rechten Motor im Bereich 0-512.
    /// @param GeschwindigkeitRechts Motorgeschwindigkeit für den linken Motor im Bereich 0-512.
    procedure BewegenAlle(GeschwindigkeitRechts,
                                GeschwindigkeitLinks: Integer);

    /// Bewegt alle Motoren für eine vorgegebene Anzahl Schritte oder bis ein
    /// neuer Befehl für die jeweiligen Motoren übergeben wird.
    /// @param SchritteRechts Die Anzahl Schritte, die der rechte Motor bewegt werden soll.
    /// @param SchritteLinks Die Anzahl Schritte, die der linke Motor bewegt werden soll.
    /// @param Geschwindigkeit Motorgeschwindigkeit im Bereich 0-512.
    procedure BewegenAlleBis(SchritteRechts, SchritteLinks: Integer;
                                   Geschwindigkeit: Integer = 512);

    /// Gibt True zurück, wenn alle Motoren die vorgegebene Anzahl Schritte absolviert haben.
    function ZielErreicht: Boolean;

    function HoleID: Integer;
  end;

implementation

{ TNetzwerkThread }

constructor TNetzwerkThread.Create(roboter: TTXTMobilRoboter; delay: Integer; callback: TCallback);
begin
  inherited Create(False);
  self.roboter := roboter;
  self.delay := delay;
  self.callback := callback;
end;

procedure TNetzwerkThread.Execute;
begin
  roboter.Verbinden;
  //roboter.SendeKonfig;

  while not Terminated do
  begin
    roboter.SendeAustausch;
    Sleep(100);
  end;
end;

{ TKameraThread }

constructor TKameraThread.Create(roboter: TTXTMobilRoboter; delay: Integer; callback: TCallback);
begin
  inherited Create(False);
  self.roboter := roboter;
  self.delay := delay;
  self.callback := callback;
end;

procedure TKameraThread.Execute;
begin
  // TODO: KameraStart senden

  while not Terminated do
  begin
    // TODO: Kamerabild empfangen
    // TODO: Bestätigung senden
    Sleep(100);
  end;
end;

{ TTXTMobilRoboter }

procedure TTXTMobilRoboter.Start;
begin
  if nwThread = nil then
    nwThread := TNetzwerkThread.Create(self);
  if kamThread = nil then
    kamThread := TKameraThread.Create(self);
end;

procedure TTXTMobilRoboter.Ende;
begin
  nwThread.Terminate;
  kamThread.Terminate;

  nwThread.WaitFor;
  kamThread.WaitFor;

  FreeAndNil(nwThread);
  FreeAndNil(kamThread);
end;

function TTXTMobilRoboter.HoleID: Integer;
begin
	Result := ID;
end;

procedure TTXTMobilRoboter.BewegenAlle(GeschwindigkeitRechts,
                                       GeschwindigkeitLinks: Integer);
begin
  LBefehle.AcquireExclusive;

  befehle.m_pwmOutputValues[0] := Max(0, GeschwindigkeitRechts);
  befehle.m_pwmOutputValues[1] := Max(0, -GeschwindigkeitRechts);
  befehle.m_pwmOutputValues[2] := Max(0, GeschwindigkeitLinks);
  befehle.m_pwmOutputValues[3] := Max(0, -GeschwindigkeitLinks);

  befehle.m_motor_distance[0] := 0;
  befehle.m_motor_distance[1] := 0;

  befehle.m_motor_master[0] := 0;
  if GeschwindigkeitLinks = GeschwindigkeitRechts then
    befehle.m_motor_master[1] := 1
  else
    befehle.m_motor_master[1] := 0;

  Inc(befehle.m_motor_command_id[0]);
  Inc(befehle.m_motor_command_id[1]);
  LBefehle.ReleaseExclusive;
end;

procedure TTXTMobilRoboter.BewegenAlleBis(SchritteRechts, SchritteLinks,
                                                Geschwindigkeit: Integer);
var
  maxSchritte: Integer;
begin

  maxSchritte := Max(Abs(SchritteRechts), Abs(SchritteLinks));

  if maxSchritte = 0 then
    Exit;

  LBefehle.AcquireExclusive;

  befehle.m_pwmOutputValues[0] :=
    Max(0, Geschwindigkeit * Round(SchritteRechts / maxSchritte));
  befehle.m_pwmOutputValues[1] :=
    Max(0, -Geschwindigkeit * Round(SchritteRechts / maxSchritte));
  befehle.m_pwmOutputValues[2] :=
    Max(0, Geschwindigkeit * Round(SchritteLinks / maxSchritte));
  befehle.m_pwmOutputValues[3] :=
    Max(0, -Geschwindigkeit * Round(SchritteLinks / maxSchritte));

  befehle.m_motor_distance[0] := SchritteRechts;
  befehle.m_motor_distance[1] := SchritteLinks;

  befehle.m_motor_master[0] := 0;
  if SchritteLinks = SchritteRechts then
    befehle.m_motor_master[1] := 1
  else
    befehle.m_motor_master[1] := 0;

  Inc(befehle.m_motor_command_id[0]);
  Inc(befehle.m_motor_command_id[1]);
  LBefehle.ReleaseExclusive;
end;

procedure TTXTMobilRoboter.BewegenEiner(Index, Geschwindigkeit: Integer);
begin
  LBefehle.AcquireExclusive;

  befehle.m_pwmOutputValues[Index * 2 - 2] := Max(0, Geschwindigkeit);
  befehle.m_pwmOutputValues[Index * 2 - 1] := Max(0, -Geschwindigkeit);

  befehle.m_motor_distance[Index - 1] := 0;

  befehle.m_motor_master[0] := 0;
  befehle.m_motor_master[1] := 0;

  Inc(befehle.m_motor_command_id[Index - 1]);
  LBefehle.ReleaseExclusive;
end;

procedure TTXTMobilRoboter.BewegenEinerBis(Index, Schritte, Geschwindigkeit: Integer);
begin
  LBefehle.AcquireExclusive;

  befehle.m_pwmOutputValues[Index * 2 - 2] := Max(0, Geschwindigkeit);
  befehle.m_pwmOutputValues[Index * 2 - 1] := Max(0, -Geschwindigkeit);

  befehle.m_motor_distance[Index - 1] := Schritte;

  if (Index = 1) or (Index = 2) then
  begin
    befehle.m_motor_master[0] := 0;
    befehle.m_motor_master[1] := 0;
  end;

  Inc(befehle.m_motor_command_id[Index - 1]);
  LBefehle.ReleaseExclusive;
end;

constructor TTXTMobilRoboter.Create(IP_Adresse: String; ID: Integer);
begin
  inherited Create(IP_Adresse);

  self.ID := ID;

  konfiguration.m_extension_id := 0;
  konfiguration.m_config.motor[0] := 1;
  konfiguration.m_config.motor[1] := 1;
  konfiguration.m_config.uni[4].mode := Byte(InputMode.MODE_R);
  konfiguration.m_config.uni[4].digital := True;
  konfiguration.m_config.uni[5].mode := Byte(InputMode.MODE_R);
  konfiguration.m_config.uni[5].digital := True;
end;

destructor TTXTMobilRoboter.Destroy;
begin
  self.Ende;

  inherited;
end;

function TTXTMobilRoboter.ZielErreicht: Boolean;
var
  i: Integer;
begin
  Result := True;
  // TODO: Möglichkeit eines Deadlocks überprüfen
  // Immer gleiche Reihenfolge bei Aquirieren beider Locks?
  LBefehle.AcquireShared;
  Try
    LAntworten.AcquireShared;
    Try
      for i := 0 to 1 do
      Result := Result and (befehle.m_motor_distance[i] <=
        antworten.m_counter_value[i]);
    Finally
      LAntworten.ReleaseShared;
    End;
    
  Finally
    LBefehle.ReleaseShared;
  End;


end;

end.
