object Hauptformular: THauptformular
  Left = 0
  Top = 0
  Caption = 'Hauptformular'
  ClientHeight = 707
  ClientWidth = 928
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
    Left = 8
    Top = 8
    Width = 600
    Height = 609
    Caption = 'Kamera Bilder'
    TabOrder = 0
    object Image1: TImage
      Left = 3
      Top = 19
      Width = 290
      Height = 290
    end
    object Image2: TImage
      Left = 299
      Top = 19
      Width = 290
      Height = 290
    end
    object Image3: TImage
      Left = 3
      Top = 315
      Width = 290
      Height = 290
    end
    object Image4: TImage
      Left = 299
      Top = 315
      Width = 290
      Height = 290
    end
  end
  object Button2: TButton
    Left = 600
    Top = 674
    Width = 75
    Height = 25
    Caption = 'test'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox2: TGroupBox
    Left = 624
    Top = 8
    Width = 281
    Height = 609
    Caption = 'Steuerung'
    TabOrder = 2
    object Label1: TLabel
      Left = 33
      Top = 24
      Width = 78
      Height = 13
      Caption = 'Log-Nachrichten'
    end
    object CheckBox1: TCheckBox
      Left = 22
      Top = 569
      Width = 97
      Height = 17
      Caption = 'Bereit'
      TabOrder = 0
    end
    object B_Verbinden: TButton
      Left = 133
      Top = 565
      Width = 114
      Height = 25
      Caption = 'Verbinden'
      TabOrder = 1
    end
    object M_Log: TMemo
      Left = 19
      Top = 43
      Width = 228
      Height = 502
      TabOrder = 2
    end
  end
end