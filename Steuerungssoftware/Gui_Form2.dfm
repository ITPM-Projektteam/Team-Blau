object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 341
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
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
  object CheckBox1: TCheckBox
    Left = 365
    Top = 249
    Width = 97
    Height = 17
    Caption = 'Bereit'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 468
    Top = 249
    Width = 114
    Height = 25
    Caption = 'Wiederverbinden'
    TabOrder = 2
    OnClick = Button1Click
  end
  object M_Log: TMemo
    Left = 365
    Top = 27
    Width = 228
    Height = 216
    TabOrder = 3
  end
  object Button2: TButton
    Left = 264
    Top = 304
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 4
    OnClick = Button2Click
  end
end
