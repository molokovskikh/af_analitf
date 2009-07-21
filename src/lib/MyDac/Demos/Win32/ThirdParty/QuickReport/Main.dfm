object fmMain: TfmMain
  Left = 299
  Top = 138
  BorderStyle = bsSingle
  Caption = 'MySQL Data Access Demo - using MyDAC with Quick Report'
  ClientHeight = 57
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object btPreview: TButton
    Left = 192
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Preview'
    TabOrder = 0
    OnClick = btPreviewClick
  end
  object Connect: TButton
    Left = 8
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 1
    OnClick = ConnectClick
  end
  object Disconnect: TButton
    Left = 88
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 2
    OnClick = DisconnectClick
  end
  object MyConnection: TMyConnection
    Database = 'test'
    Server = 'Kimdiss-2000'
    Left = 8
    Top = 16
  end
end
