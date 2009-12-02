object Form1: TForm1
  Left = 192
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'TFakeDll Example by Dr.Golova'
  ClientHeight = 259
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 353
    Height = 97
    Caption = ' Normal Call Function from DLL. '
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 56
      Width = 43
      Height = 13
      Caption = 'Handle - '
    end
    object Label2: TLabel
      Left = 64
      Top = 56
      Width = 54
      Height = 13
      Caption = '00000000h'
    end
    object Button1: TButton
      Left = 16
      Top = 24
      Width = 97
      Height = 25
      Caption = 'LoadLibrary.'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 128
      Top = 24
      Width = 65
      Height = 25
      Caption = 'Name 1.'
      Enabled = False
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 200
      Top = 24
      Width = 65
      Height = 25
      Caption = 'Name 2.'
      Enabled = False
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button8: TButton
      Left = 272
      Top = 24
      Width = 65
      Height = 25
      Caption = 'Name 3.'
      Enabled = False
      TabOrder = 3
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 128
      Top = 56
      Width = 65
      Height = 25
      Caption = 'Ordinal #1.'
      Enabled = False
      TabOrder = 4
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 200
      Top = 56
      Width = 65
      Height = 25
      Caption = 'Ordinal #2.'
      Enabled = False
      TabOrder = 5
      OnClick = Button10Click
    end
    object Button11: TButton
      Left = 272
      Top = 56
      Width = 65
      Height = 25
      Caption = 'Ordinal #3.'
      Enabled = False
      TabOrder = 6
      OnClick = Button11Click
    end
  end
  object Button4: TButton
    Left = 280
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Close.'
    TabOrder = 1
    OnClick = Button4Click
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 112
    Width = 353
    Height = 97
    Caption = ' Usung TFakeDll. '
    TabOrder = 2
    object Label3: TLabel
      Left = 16
      Top = 56
      Width = 43
      Height = 13
      Caption = 'Handle - '
    end
    object Label4: TLabel
      Left = 64
      Top = 56
      Width = 54
      Height = 13
      Caption = '00000000h'
    end
    object Button5: TButton
      Left = 16
      Top = 24
      Width = 97
      Height = 25
      Caption = 'LoadLibrary.'
      TabOrder = 0
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 128
      Top = 24
      Width = 65
      Height = 25
      Caption = 'Name 1.'
      Enabled = False
      TabOrder = 1
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 200
      Top = 24
      Width = 65
      Height = 25
      Caption = 'Name 2.'
      Enabled = False
      TabOrder = 2
      OnClick = Button7Click
    end
    object Button12: TButton
      Left = 272
      Top = 24
      Width = 65
      Height = 25
      Caption = 'Name 3.'
      Enabled = False
      TabOrder = 3
      OnClick = Button12Click
    end
    object Button13: TButton
      Left = 128
      Top = 56
      Width = 65
      Height = 25
      Caption = 'Ordinal #1.'
      Enabled = False
      TabOrder = 4
      OnClick = Button13Click
    end
    object Button14: TButton
      Left = 200
      Top = 56
      Width = 65
      Height = 25
      Caption = 'Ordinal #2.'
      Enabled = False
      TabOrder = 5
      OnClick = Button14Click
    end
    object Button15: TButton
      Left = 272
      Top = 56
      Width = 65
      Height = 25
      Caption = 'Ordinal #3.'
      Enabled = False
      TabOrder = 6
      OnClick = Button15Click
    end
  end
end
