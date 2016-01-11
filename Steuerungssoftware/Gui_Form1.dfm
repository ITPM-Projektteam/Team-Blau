object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 367
  ClientWidth = 271
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 4
    Width = 263
    Height = 166
    Caption = 'IP-Adresse'
    TabOrder = 0
    object Label1: TLabel
      Left = 160
      Top = 19
      Width = 84
      Height = 13
      Caption = 'Server IPAdresse'
    end
    object Label2: TLabel
      Left = 160
      Top = 59
      Width = 97
      Height = 13
      Caption = 'Roboter IPAdressen'
    end
    object E_ServerIP: TEdit
      Left = 16
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'E_ServerIP'
    end
    object B_Verbinden: TButton
      Left = 160
      Top = 94
      Width = 75
      Height = 25
      Caption = 'B_Verbinden'
      TabOrder = 1
      OnClick = B_VerbindenClick
    end
    object M_Adressen: TMemo
      Left = 16
      Top = 56
      Width = 121
      Height = 97
      ReadOnly = True
      TabOrder = 2
    end
  end
  object Memo1: TMemo
    Left = 16
    Top = 176
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
end
