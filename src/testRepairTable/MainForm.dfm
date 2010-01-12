object MainFrm: TMainFrm
  Left = 281
  Top = 205
  Width = 647
  Height = 285
  Caption = 'MainFrm'
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
  object btnTestPrepare: TButton
    Left = 56
    Top = 16
    Width = 121
    Height = 25
    Caption = 'TestPrepare'
    TabOrder = 0
    OnClick = btnTestPrepareClick
  end
  object btnCorruptDataFile: TButton
    Left = 56
    Top = 64
    Width = 121
    Height = 25
    Caption = 'CorruptDataFile'
    TabOrder = 1
    OnClick = btnCorruptDataFileClick
  end
  object mLog: TMemo
    Left = 0
    Top = 111
    Width = 639
    Height = 146
    Align = alBottom
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object btnCorruptIndexFile: TButton
    Left = 200
    Top = 64
    Width = 121
    Height = 25
    Caption = 'CorruptIndexFile'
    TabOrder = 3
    OnClick = btnCorruptIndexFileClick
  end
  object MyEmbConnection: TMyEmbConnection
    Params.Strings = (
      '--basedir=.'
      '--datadir=data')
    Left = 16
    Top = 8
  end
end
