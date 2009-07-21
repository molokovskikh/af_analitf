object fmDllMain: TfmDllMain
  Left = 240
  Top = 404
  Width = 599
  Height = 337
  Caption = 'My Data Access Demo - DLL'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid: TDBGrid
    Left = 0
    Top = 26
    Width = 591
    Height = 188
    Align = alClient
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object pnToolBar: TPanel
    Left = 0
    Top = 0
    Width = 591
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 394
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 75
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object btClose: TSpeedButton
        Left = 77
        Top = 1
        Width = 75
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object DBNavigator: TDBNavigator
        Left = 153
        Top = 1
        Width = 240
        Height = 22
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
    end
  end
  object DBMemo1: TDBMemo
    Left = 0
    Top = 214
    Width = 591
    Height = 89
    Align = alBottom
    DataField = 'picture'
    DataSource = DataSource
    TabOrder = 2
  end
  object MyQuery: TMyQuery
    SQL.Strings = (
      'SELECT * FROM MYDAC_Pictures')
    FetchAll = True
    Left = 24
    Top = 56
  end
  object DataSource: TDataSource
    DataSet = MyQuery
    Left = 56
    Top = 56
  end
end
