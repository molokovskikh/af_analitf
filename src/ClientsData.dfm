inherited ClientsDataForm: TClientsDataForm
  Left = 249
  Top = 157
  ActiveControl = dbgFirms
  Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 529
  ClientWidth = 714
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object dbtFullName: TDBText
    Left = 296
    Top = 0
    Width = 59
    Height = 13
    AutoSize = True
    DataField = 'FullName'
    DataSource = dsFirms
  end
  object dbtPhones: TDBText
    Left = 296
    Top = 16
    Width = 51
    Height = 13
    AutoSize = True
    DataField = 'SupportPhone'
    DataSource = dsFirms
  end
  object dbtEMail: TDBText
    Left = 296
    Top = 32
    Width = 41
    Height = 13
    Cursor = crHandPoint
    AutoSize = True
    Color = clBtnFace
    DataField = 'AdminMail'
    DataSource = dsFirms
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnClick = dbtEMailClick
  end
  object Label2: TLabel
    Left = 296
    Top = 48
    Width = 135
    Height = 13
    Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1079#1072#1082#1072#1079', '#1088#1091#1073'.:'
  end
  object Label1: TLabel
    Left = 296
    Top = 72
    Width = 126
    Height = 13
    Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
  end
  object Label93: TLabel
    Left = 296
    Top = 280
    Width = 134
    Height = 13
    Caption = #1054#1087#1077#1088#1072#1090#1080#1074#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
  end
  object dbtMinOrder: TDBText
    Left = 432
    Top = 48
    Width = 58
    Height = 13
    AutoSize = True
    DataSource = dsFirms
  end
  object btnOrder: TSpeedButton
    Left = 200
    Top = 488
    Width = 89
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1047#1072#1103#1074#1082#1072
    OnClick = btnOrderClick
  end
  object dbtDatePrice: TDBText
    Left = 96
    Top = 488
    Width = 62
    Height = 13
    Anchors = [akLeft, akBottom]
    AutoSize = True
    DataField = 'DatePrice'
    DataSource = dsPrices
  end
  object Label3: TLabel
    Left = 0
    Top = 488
    Width = 94
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072':'
  end
  object dbgFirms: TADBGrid
    Left = 0
    Top = 0
    Width = 227
    Height = 329
    Anchors = [akLeft, akTop, akBottom]
    DataSource = dsFirms
    Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnGetCellParams = dbgFirmsGetCellParams
    FocusNext = dbgPrices
    FindColumnName = 'ShortName'
    Columns = <
      item
        Expanded = False
        FieldName = 'ShortName'
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 158
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Storage'
        Title.Caption = #1057#1082#1083#1072#1076
        Width = 17
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Forcount'
        Title.Alignment = taCenter
        Title.Caption = '%'
        Width = 29
        Visible = True
      end>
  end
  object dbmAddInfo: TDBMemo
    Left = 296
    Top = 88
    Width = 418
    Height = 185
    Anchors = [akLeft, akTop, akRight]
    DataField = 'ContactInfo'
    DataSource = dsFirms
    ReadOnly = True
    TabOrder = 2
  end
  object dbmComments: TDBMemo
    Left = 296
    Top = 296
    Width = 418
    Height = 209
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataField = 'OperativeInfo'
    DataSource = dsFirms
    ReadOnly = True
    TabOrder = 3
  end
  object cbOnlyLeaders: TCheckBox
    Left = 296
    Top = 512
    Width = 257
    Height = 17
    Action = actOnlyLeaders
    Anchors = [akLeft, akBottom]
    TabOrder = 5
  end
  object cbCurrentOrders: TCheckBox
    Left = 0
    Top = 512
    Width = 145
    Height = 17
    Action = actCurrentOrders
    Anchors = [akLeft, akBottom]
    TabOrder = 4
  end
  object dbgPrices: TADBGrid
    Left = 0
    Top = 336
    Width = 277
    Height = 148
    Anchors = [akLeft, akBottom]
    DataSource = dsPrices
    Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    FocusPrev = dbgFirms
    OnCanFocusNext = dbgPricesCanFocusNext
    Columns = <
      item
        Expanded = False
        FieldName = 'PriceName'
        Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RegionName'
        Title.Caption = #1056#1077#1075#1080#1086#1085
        Width = 125
        Visible = True
      end>
  end
  object ActionList: TActionList
    Left = 196
    Top = 54
    object actCurrentOrders: TAction
      Caption = #1058#1086#1083#1100#1082#1086' '#1090#1077#1082#1091#1097#1080#1077' '#1079#1072#1103#1074#1082#1080
      OnExecute = actCurrentOrdersExecute
    end
    object actOnlyLeaders: TAction
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1083#1080#1076#1080#1088#1091#1102#1097#1080#1077' '#1087#1086#1079#1080#1094#1080#1080' (F3)'
      ShortCut = 114
      OnExecute = actOnlyLeadersExecute
    end
  end
  object adsClientsData: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    CommandText = 'SELECT * FROM ClientsDataShow'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 1
      end>
    Prepared = True
    Left = 96
    Top = 112
    object adsClientsDataAFirmCode: TIntegerField
      FieldName = 'AFirmCode'
    end
    object adsClientsDataShortName: TWideStringField
      FieldName = 'ShortName'
    end
    object adsClientsDataFullName: TWideStringField
      FieldName = 'FullName'
      Size = 40
    end
    object adsClientsDataStorage: TBooleanField
      FieldName = 'Storage'
      DisplayValues = '+;'
    end
    object adsClientsDataAdminMail: TWideStringField
      FieldName = 'AdminMail'
      Size = 100
    end
    object adsClientsDataSupportPhone: TWideStringField
      FieldName = 'SupportPhone'
    end
    object adsClientsDataContactInfo: TMemoField
      FieldName = 'ContactInfo'
      BlobType = ftMemo
    end
    object adsClientsDataOperativeInfo: TMemoField
      FieldName = 'OperativeInfo'
      BlobType = ftMemo
    end
    object adsClientsDataForcount: TSmallintField
      FieldName = 'Forcount'
      DisplayFormat = '#'
    end
    object adsClientsDataEnabled: TBooleanField
      FieldName = 'Enabled'
    end
    object adsClientsDataPositions: TIntegerField
      FieldName = 'Positions'
      ReadOnly = True
      DisplayFormat = '#'
    end
  end
  object dsFirms: TDataSource
    DataSet = adsClientsData
    Left = 96
    Top = 160
  end
  object adsPrices: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    CommandText = 'SELECT * FROM PricesShowByFirm'
    DataSource = dsFirms
    MasterFields = 'AFirmCode'
    Parameters = <
      item
        Name = 'TimeZoneBias'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 240
      end
      item
        Name = 'AFirmCode'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Value = 31
      end>
    Prepared = True
    Left = 112
    Top = 352
  end
  object dsPrices: TDataSource
    DataSet = adsPrices
    Left = 112
    Top = 400
  end
end
