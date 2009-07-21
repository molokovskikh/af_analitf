object fmClient: TfmClient
  Left = 171
  Top = 304
  Width = 788
  Height = 377
  Caption = 'MS Data Access Demo - MIDAS Client'
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
  object DBGrid: TDBGrid
    Left = 0
    Top = 49
    Width = 780
    Height = 275
    Align = alClient
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ToolBar1: TPanel
    Left = 0
    Top = 0
    Width = 780
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object ToolBar: TPanel
      Left = 1
      Top = 1
      Width = 499
      Height = 47
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object brConnect: TSpeedButton
        Left = 1
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Connect'
        Flat = True
        Transparent = False
        OnClick = brConnectClick
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
      object btOpen: TSpeedButton
        Left = 167
        Top = 1
        Width = 84
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object btClose: TSpeedButton
        Left = 252
        Top = 1
        Width = 80
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object btApplyUpd: TSpeedButton
        Left = 333
        Top = 1
        Width = 82
        Height = 22
        Caption = 'ApplyUpd'
        Flat = True
        Transparent = False
        OnClick = btApplyUpdClick
      end
      object btCancelUpd: TSpeedButton
        Left = 416
        Top = 1
        Width = 82
        Height = 22
        Caption = 'CancelUpd'
        Flat = True
        Transparent = False
        OnClick = btCancelUpdClick
      end
      object Panel1: TPanel
        Left = 252
        Top = 24
        Width = 246
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object EmpNo: TLabel
          Left = 6
          Top = 3
          Width = 71
          Height = 17
          Alignment = taCenter
          AutoSize = False
          Caption = 'EmpNo'
          Layout = tlCenter
        end
        object edEmpNo: TEdit
          Left = 94
          Top = 2
          Width = 127
          Height = 17
          TabOrder = 0
          Text = '10'
        end
      end
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 24
        Width = 250
        Height = 22
        DataSource = DataSource
        Flat = True
        TabOrder = 1
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 324
    Width = 780
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 333
    Top = 205
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftInteger
        Name = 'EmpNo'
        ParamType = ptInput
        Value = 10
      end>
    ProviderName = 'MyDataSetProvider'
    RemoteServer = RemoteServer
    Left = 301
    Top = 205
  end
  object RemoteServer: TDCOMConnection
    ServerGUID = '{706739B2-FB40-49CC-9041-2B82CFFC520C}'
    ServerName = 'Server.Datas'
    Left = 269
    Top = 205
  end
end
