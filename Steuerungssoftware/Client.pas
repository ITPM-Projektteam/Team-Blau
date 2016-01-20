unit Client;

interface

  uses IdTCPClient, IdGlobal, ClientUndServer;

  type
    TServerVerbindung = class
      private
        tcpClient: TIdTCPClient;
      public
        constructor Create(IP: String; Port: Integer);
        function Anmelden(Teamwahl: Teams): Boolean;
        function GefangenMelden(index: Integer): Boolean;
        function WarteAufSpielstart: Boolean;
    end;

implementation

{ TServerVerbindung }

constructor TServerVerbindung.Create(IP: String; Port: Integer);
begin
  tcpClient.Host := IP;
  tcpClient.Port := Port;
end;

function TServerVerbindung.Anmelden(Teamwahl: Teams): Boolean;
begin
  Try
    tcpClient.Connect;
    tcpClient.Socket.Write(Byte(ANMELDUNG));
    tcpClient.Socket.Write(Byte(Teamwahl));
    Result := tcpClient.Socket.ReadByte = Byte(ANMELDUNG_ERFOLGREICH);
  Except
    Result := False;
    Exit;
  End;
end;

function TServerVerbindung.GefangenMelden(index: Integer): Boolean;
begin
  Try
    tcpClient.Socket.Write(Byte(MELDUNG_GEFANGEN));
    tcpClient.Socket.Write(index);
    Result := True;
  Except
    Result := False;
  End;
end;

function TServerVerbindung.WarteAufSpielstart: Boolean;
var alterTimeout: Integer;
begin
  alterTimeout := tcpClient.ReadTimeout;
  tcpClient.ReadTimeout := IdTimeoutInfinite;
  Result := tcpClient.Socket.ReadByte = SPIELBEGINN;
  tcpClient.ReadTimeout := alterTimeout;
end;

end.
