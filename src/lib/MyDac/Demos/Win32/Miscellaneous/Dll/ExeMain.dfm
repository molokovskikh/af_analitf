object fmExeMain: TfmExeMain
  Left = 194
  Top = 336
  Width = 625
  Height = 336
  Caption = 'My Data Access Demo - Application'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnToolBar: TPanel
    Left = 0
    Top = 0
    Width = 617
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 2
      Top = 1
      Width = 333
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
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
        Width = 82
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
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
    end
    object Panel2: TPanel
      Left = 2
      Top = 24
      Width = 574
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 1
      object btFreeDLL: TSpeedButton
        Left = 250
        Top = 1
        Width = 82
        Height = 22
        Caption = '4. Free DLL'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        OnClick = btFreeDLLClick
      end
      object btLoadDLL: TSpeedButton
        Left = 1
        Top = 1
        Width = 82
        Height = 22
        Caption = '1. Load DLL'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        OnClick = btLoadDLLClick
      end
      object btShowForm: TSpeedButton
        Left = 84
        Top = 1
        Width = 82
        Height = 22
        Caption = '2. Show Form'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        OnClick = btShowFormClick
      end
      object btHideForms: TSpeedButton
        Left = 167
        Top = 1
        Width = 82
        Height = 22
        Caption = '3. Hide Form'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        OnClick = btHideFormsClick
      end
      object DBNavigator: TDBNavigator
        Left = 333
        Top = 1
        Width = 240
        Height = 22
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 49
    Width = 617
    Height = 164
    Align = alClient
    DataSource = DataSource
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBMemo1: TDBMemo
    Left = 0
    Top = 213
    Width = 617
    Height = 89
    Align = alBottom
    DataField = 'picture'
    DataSource = DataSource
    TabOrder = 2
  end
  object MyConnection: TMyConnection
    ConnectDialog = MyConnectDialog
    Left = 16
    Top = 88
  end
  object MyConnectDialog: TMyConnectDialog
    DatabaseLabel = 'Database'
    PortLabel = 'Port'
    SavePassword = True
    Caption = 'Connect'
    UsernameLabel = 'User Name'
    PasswordLabel = 'Password'
    ServerLabel = 'Server'
    ConnectButton = 'Connect'
    CancelButton = 'Cancel'
    Left = 48
    Top = 88
  end
  object MyQuery: TMyQuery
    Connection = MyConnection
    SQL.Strings = (
      'SELECT * FROM MYDAC_Pictures')
    FetchAll = True
    Left = 16
    Top = 120
  end
  object DataSource: TDataSource
    DataSet = MyQuery
    Left = 48
    Top = 120
  end
end
