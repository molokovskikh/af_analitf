object frmMain: TfrmMain
  Left = 258
  Top = 175
  Width = 391
  Height = 277
  Caption = 'Main'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnDeleteWithPrepare: TButton
    Left = 24
    Top = 16
    Width = 145
    Height = 25
    Caption = 'Delete With Prepare'
    TabOrder = 0
    OnClick = btnDeleteWithPrepareClick
  end
  object btnDeleteWithoutPrepare: TButton
    Left = 24
    Top = 64
    Width = 145
    Height = 25
    Caption = 'Delete Without Prepare'
    TabOrder = 1
    OnClick = btnDeleteWithoutPrepareClick
  end
  object MyEmbConnection: TMyEmbConnection
    Params.Strings = (
      '--basedir=.'
      '--datadir=data')
    Left = 176
    Top = 24
  end
  object MySQLMonitor1: TMySQLMonitor
    OnSQL = MySQLMonitor1SQL
    Left = 232
    Top = 8
  end
end
