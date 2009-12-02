object Form1: TForm1
  Left = 191
  Top = 108
  Width = 870
  Height = 640
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnMySqlLoad1: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'MySqlLoad1'
    TabOrder = 0
    OnClick = btnMySqlLoad1Click
  end
  object btnConnect: TButton
    Left = 232
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 1
    OnClick = btnConnectClick
  end
  object btnCrypt: TButton
    Left = 16
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Crypt'
    TabOrder = 2
    OnClick = btnCryptClick
  end
  object btnGetMemoryStream: TButton
    Left = 16
    Top = 104
    Width = 169
    Height = 25
    Caption = 'GetMemoryStream'
    TabOrder = 3
    OnClick = btnGetMemoryStreamClick
  end
  object MyEmbConnection1: TMyEmbConnection
    Params.Strings = (
      '--basedir=.'
      '--datadir=data')
    Username = 'root'
    Left = 328
    Top = 16
  end
end
