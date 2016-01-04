object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 280
  ClientWidth = 590
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
  object Label1: TLabel
    Left = 365
    Top = 8
    Width = 78
    Height = 13
    Caption = 'Log-Nachrichten'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 329
    Height = 258
    Caption = 'Kamera Bilder'
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 365
    Top = 26
    Width = 217
    Height = 217
    ReadOnly = True
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 365
    Top = 249
    Width = 97
    Height = 17
    Caption = 'Bereit'
    TabOrder = 2
  end
  object Button1: TButton
    Left = 468
    Top = 249
    Width = 114
    Height = 25
    Caption = 'Wiederverbinden'
    TabOrder = 3
    OnClick = Button1Click
  end
end
