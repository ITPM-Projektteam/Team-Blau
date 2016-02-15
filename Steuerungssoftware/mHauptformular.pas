//******************************************************************************
{*
 * @file Gui_Form2.pas
 * @author Jonah
 * @date 04.01.2016
 * @brief Benutzeroberfläche
 * @copyright Copyright © 2015 ITPM-Projektteam
 *
 * @license
}
//******************************************************************************
unit mHauptformular;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, mTXTRoboter, mTXTMobilRoboter, MVektor, Math,
  Client, ClientUndServer, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, mRoboterDaten;


type
  Log_Art= (Hinweis, Warnung, Fehler);
  THauptformular = class(TForm)
    Button2: TButton;
    I_Roboter1: TImage;
    I_Roboter2: TImage;
    I_Roboter3: TImage;
    I_Roboter4: TImage;
    G_Steuerung: TGroupBox;
    Label1: TLabel;
    CB_Bereit: TCheckBox;
    B_Verbinden: TButton;
    M_Log: TMemo;
    I_MiniMap: TImage;
    B_Kamera: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Log_Schreiben(Meldung: string; Art: Log_Art);
    procedure Button2Click(Sender: TObject);
    procedure B_VerbindenClick(Sender: TObject);
    procedure Visualisieren(RoboterDaten: A_RoboterDaten; ZielVektor: Tvektor);
    procedure CB_BereitClick(Sender: TObject);
    procedure KamerabilderAnzeigen(Roboter: TTXTMobilRoboter);
    procedure B_KameraClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    IPConfig: Textfile;
    Server_IP: String;
    Port: Integer;
    IP_Adressen: Array of string;
    Anz_Roboter: Integer;
    Kamerabilder: Array[1..4] of TImage;
    { Public-Deklarationen }
  end;

var
  Hauptformular: THauptformular;
  Log_Datei: Textfile;

implementation

{$R *.dfm}

uses mTKI;

procedure THauptformular.FormCreate(Sender: TObject);
var
  i: Integer;
  hilf: String;
begin

  Kamerabilder[1] := I_Roboter1;
  Kamerabilder[2] := I_Roboter2;
  Kamerabilder[3] := I_Roboter3;
  Kamerabilder[4] := I_Roboter4;

  // Log Datei erzeugen
  assignfile(Log_Datei, 'Log.txt');
  rewrite(Log_Datei);

  // Config Datei erzeuen
  assignfile(IpConfig, 'IP_Config.txt');
  reset(IpConfig);

  i:=1;

  //IP Adressen anzeigen und Speichern
  while not eof(IPConfig) do
  begin
      readln(IPConfig, hilf);
      if i=2 then
      begin
        Server_IP:=hilf.split([':'])[0];
        Port:=strtoint(hilf.split([':'])[1]);
        Log_Schreiben('ServerIP ' + hilf, Hinweis);
      end;

      if i>3 then
      begin
        setlength(IP_Adressen,Length(IP_Adressen)+1);
        Log_Schreiben('Roboter ' + inttostr(High(IP_Adressen))+ ' ' + hilf, Hinweis);
        IP_Adressen[high(IP_Adressen)]:=hilf;

      end;
      inc(i);
  end;
  Anz_Roboter:=Length(IP_Adressen)+1;
  closeFile(IPConfig);
end;


/// Log Funktion, es wird eine Fehlermeldung als String und eine Priorität (0-3) als Integer Übergeben
/// @param Meldung Beschreibung der Meldung
/// @param Art Entwerder Hinweis Fehler oder Warnung
procedure THauptformular.Log_Schreiben(Meldung: string; Art: Log_Art);
var Ausgabe: String;
begin
  case art of
    Hinweis: Ausgabe:= '[Hinweis]  '+ Timetostr(now)+ '  ' +  Meldung ;
    Warnung: Ausgabe:= '[Warnung]  '+ Timetostr(now)+ '  ' +  Meldung;
    Fehler: Ausgabe := '[Fehler]   '+ Timetostr(now)+ '  ' +  Meldung;
  end;

  M_Log.Lines.Add(Ausgabe);
  writeln(Log_Datei, Ausgabe);
end;


procedure THauptformular.B_KameraClick(Sender: TObject);
var i: Integer;
begin
  for i:= 1 to Anz_Roboter do
    TKI.getRoboter(i-1).StarteKamera(Kamerabilder[i]);
end;

procedure THauptformular.Button2Click(Sender: TObject);
begin
  Log_Schreiben('Meldung', Hinweis);
end;

procedure THauptformular.B_VerbindenClick(Sender: TObject);
begin
  Log_Schreiben('Suche Verbindung', Hinweis);
  TKI.Init(IP_Adressen,Server_IP,Port,Self);
  CB_Bereit.Enabled := True;
end;

procedure THauptformular.CB_BereitClick(Sender: TObject);
begin
  TKI.Anmelden(Team_Blau)
end;

///Visualisierung der Bewegungen
procedure THauptformular.Visualisieren(RoboterDaten: A_RoboterDaten; ZielVektor: Tvektor);
var
 Team: TTeam;
 i, x1,x2,y2,y1,r1,r2,r3,r4: Integer;
begin
{  //Testdaten
  Positionen[1].x:=10;
  Positionen[1].y:= 10;
  Positionen[2].x:=100;
  Positionen[2].y:= 100;
  Positionen[3].x:=200;
  Positionen[3].y:= 300;

  Gegner[1].x:=400;
  Gegner[1].y:=400;
  Gegner[2].x:=300;
  Gegner[2].y:=300;
  Gegner[3].x:=350;
  Gegner[3].y:=350;

  UnsereGewindigkeiten[1].x:=50;
  UnsereGewindigkeiten[1].y:=50;
  UnsereGewindigkeiten[2].x:=-50;
  UnsereGewindigkeiten[2].y:=20;
  UnsereGewindigkeiten[3].x:=-100;
  UnsereGewindigkeiten[3].y:=-100;  }

  for team in [TEAM_ROT,TEAM_BLAU] do
  begin

    for i := Low(Roboterdaten[Team]) to High(Roboterdaten[Team]) do
    begin
      if Team=TEAM_ROT then
        I_Minimap.canvas.Brush.Color:=CLRed
      else
        I_Minimap.canvas.Brush.Color:=CLBlue;
      x1:=Round(Roboterdaten[Team,i].Position.x+10);
      y1:=Round(Roboterdaten[Team,i].Position.y+10);
      x2:=Round(Roboterdaten[Team,i].Position.x-10);
      y2:=Round(Roboterdaten[Team,i].Position.y-10);

      r1:=Round(Roboterdaten[Team,i].Position.x);
      r2:=Round(Roboterdaten[Team,i].Position.y);
      r3:=Round(Roboterdaten[Team,i].Position.x+Zielvektor.x);
      r4:=Round(Roboterdaten[Team,i].Position.y+Zielvektor.y);

      with I_MiniMap.Canvas do
      begin
        Rectangle(x1,y1,x2,y2);
        Brush.Color:=CLBlack;
        MoveTo(r1,r2);
        LineTo(r3,r4);
      end;
    end;

//      // Winkel Für die Pfeilspitze
//      Vektorx:=UnsereGewindigkeiten[i].x;
//      Vektory:=UnsereGewindigkeiten[i].y;
//      hilf:= Vektorx/(Sqrt((Vektory*Vektory)+(Vektorx*Vektorx)));
//      alphax:= arccos(hilf)-0.5*PI;
//      alphay:=arccos(hilf)+0.5*PI;
//
//
//      Log_Schreiben(Floattostr(alphax),Hinweis);
////      Log_Schreiben(Floattostr(sin(alphax)*10),Hinweis);
////      Log_Schreiben(Floattostr(cos(alphax)*10),Hinweis);
//
//      //Pfeilspitze erstellen
//      Moveto(r3,r4);
//      LineTo(r3+round(sin(alphax)*10),round(r4+cos(alphax)*10));
//      Moveto(r3,r4);
//      LineTo(r3+round(sin(alphay)*10),r4+round(cos(alphay)*10));
  end;
end;

initialization

finalization

CloseFile(Log_Datei);
end.
