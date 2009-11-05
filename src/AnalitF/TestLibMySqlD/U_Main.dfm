object Form1: TForm1
  Left = 191
  Top = 108
  Width = 619
  Height = 489
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 72
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object MyConnection: TMyEmbConnection
    Database = 'test'
    Params.Strings = (
      '--basedir=.'
      '--datadir=data'
      '--character_set_server=cp1251'
      '--character_set_filesystem=cp1251'
      '--skip-innodb')
    Username = 'root'
    Left = 32
    Top = 16
  end
end
