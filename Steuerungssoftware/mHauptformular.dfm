object Hauptformular: THauptformular
  Left = 0
  Top = 0
  Caption = 'Hauptformular'
  ClientHeight = 671
  ClientWidth = 1390
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
  object I_MiniMap: TImage
    Left = 928
    Top = 8
    Width = 440
    Height = 640
  end
  object G_Bilder: TGroupBox
    Left = 8
    Top = 8
    Width = 600
    Height = 609
    Caption = 'Kamera Bilder'
    TabOrder = 0
    object I_Roboter1: TImage
      Left = 3
      Top = 19
      Width = 290
      Height = 290
    end
    object I_Roboter2: TImage
      Left = 299
      Top = 19
      Width = 290
      Height = 290
    end
    object I_Roboter3: TImage
      Left = 3
      Top = 315
      Width = 290
      Height = 290
    end
    object I_Roboter4: TImage
      Left = 299
      Top = 315
      Width = 290
      Height = 290
    end
  end
  object Button2: TButton
    Left = 624
    Top = 623
    Width = 75
    Height = 25
    Caption = 'test'
    TabOrder = 1
    OnClick = Button2Click
  end
  object G_Steuerung: TGroupBox
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
    object CB_Bereit: TCheckBox
      Left = 22
      Top = 569
      Width = 97
      Height = 17
      Caption = 'Bereit'
      Enabled = False
      TabOrder = 0
      OnClick = CB_BereitClick
    end
    object B_Verbinden: TButton
      Left = 133
      Top = 565
      Width = 114
      Height = 25
      Caption = 'Verbinden'
      TabOrder = 1
      OnClick = B_VerbindenClick
    end
    object M_Log: TMemo
      Left = 19
      Top = 43
      Width = 228
      Height = 502
      TabOrder = 2
    end
  end
  object B_Kamera: TButton
    Left = 11
    Top = 623
    Width = 102
    Height = 25
    Caption = 'Kamera aktivieren'
    TabOrder = 3
    OnClick = B_KameraClick
  end
end
