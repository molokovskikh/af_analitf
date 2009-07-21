object fmServer: TfmServer
  Left = 219
  Top = 210
  Width = 608
  Height = 394
  Caption = 'MS Data Access Demo - MIDAS Server'
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
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 2
      Width = 333
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object btClose: TSpeedButton
        Left = 250
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object btOpen: TSpeedButton
        Left = 167
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object btDisconnect: TSpeedButton
        Left = 84
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Disconnect'
        Flat = True
        Transparent = False
        OnClick = btDisconnectClick
      end
      object btConnect: TSpeedButton
        Left = 1
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Connect'
        Flat = True
        Transparent = False
        OnClick = btConnectClick
      end
    end
  end
  object meSQL: TMemo
    Left = 0
    Top = 28
    Width = 600
    Height = 76
    Align = alTop
    TabOrder = 1
    OnExit = meSQLExit
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 131
    Width = 600
    Height = 210
    Align = alClient
    DataSource = DataSource
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ToolBar1: TPanel
    Left = 0
    Top = 104
    Width = 600
    Height = 27
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Panel2: TPanel
      Left = 2
      Top = 2
      Width = 569
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object Panel3: TPanel
        Left = 242
        Top = 1
        Width = 75
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object cbDebug: TCheckBox
          Left = 5
          Top = 0
          Width = 64
          Height = 22
          Caption = 'Debug'
          TabOrder = 0
          OnClick = cbDebugClick
        end
      end
      object Panel5: TPanel
        Left = 318
        Top = 1
        Width = 250
        Height = 22
        BevelOuter = bvNone
        TabOrder = 1
        object rbDSResolve: TRadioButton
          Left = 8
          Top = 1
          Width = 120
          Height = 22
          Caption = 'Resolve to Dataset'
          TabOrder = 0
          OnClick = rbDSResolveClick
        end
        object rbSQLResolve: TRadioButton
          Left = 141
          Top = 1
          Width = 104
          Height = 22
          Caption = 'Resolve by SQL'
          TabOrder = 1
          OnClick = rbSQLResolveClick
        end
      end
      object DBNavigator: TDBNavigator
        Left = 1
        Top = 1
        Width = 240
        Height = 22
        DataSource = DataSource
        Flat = True
        TabOrder = 2
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 341
    Width = 600
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object DataSource: TDataSource
    Left = 8
    Top = 64
  end
end
