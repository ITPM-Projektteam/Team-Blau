object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 133
  ClientWidth = 262
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 8
    Width = 257
    Height = 129
    Caption = 'IP-Adresse'
    TabOrder = 0
    object Label1: TLabel
      Left = 176
      Top = 19
      Width = 53
      Height = 13
      Caption = 'IP-Adresse'
    end
    object Edit1: TEdit
      Left = 16
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 94
      Top = 64
      Width = 75
      Height = 25
      Caption = 'Verbinden'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
