object CoreFirmForm: TCoreFirmForm
  Left = 256
  Top = 152
  ActiveControl = dbgCore
  Align = alClient
  Anchors = [akTop, akBottom]
  BorderIcons = []
  BorderStyle = bsNone
  Caption = #1047#1072#1103#1074#1082#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
  ClientHeight = 551
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object plOverCost: TPanel
    Left = 248
    Top = 192
    Width = 305
    Height = 57
    Caption = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1089#1088#1077#1076#1085#1077#1081' '#1094#1077#1085#1099'!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Visible = False
  end
  object dbgCore: TToughDBGrid
    Left = 0
    Top = 29
    Width = 768
    Height = 484
    Align = alClient
    AutoFitColWidths = True
    DataSource = dsCore
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnGetCellParams = dbgCoreGetCellParams
    OnKeyDown = dbgCoreKeyDown
    SearchField = 'Synonym'
    InputField = 'Order'
    SearchPosition = spTop
    ForceRus = True
    FindInterval = 2500
    OnSortChange = dbgCoreSortChange
    OnCanInput = dbgCoreCanInput
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Code'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1050#1086#1076
        Title.TitleButton = True
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'Synonym'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 117
      end
      item
        EditButtons = <>
        FieldName = 'SynonymFirm'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Title.TitleButton = True
        Width = 92
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'Volume'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
        Title.TitleButton = True
        Width = 87
      end
      item
        EditButtons = <>
        FieldName = 'Doc'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1044#1086#1082#1091#1084#1077#1085#1090
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'Note'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 118
      end
      item
        Alignment = taCenter
        EditButtons = <>
        FieldName = 'Period'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1057#1088#1086#1082'. '#1075#1086#1076#1085'.'
        Title.TitleButton = True
        Width = 77
      end
      item
        EditButtons = <>
        FieldName = 'BaseCost'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Footers = <>
        MinWidth = 5
        Title.Caption = #1062#1077#1085#1072
        Title.TitleButton = True
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'Quantity'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'PriceRet'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'MinPrice'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1052#1080#1085'. '#1094#1077#1085#1072
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'LeaderPriceName'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1055#1088#1072#1081#1089' - '#1083#1080#1076#1077#1088
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'LeaderRegionName'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1056#1077#1075#1080#1086#1085' - '#1083#1080#1076#1077#1088
        Title.TitleButton = True
      end
      item
        Color = 16775406
        EditButtons = <>
        FieldName = 'Order'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1047#1072#1082#1072#1079
      end
      item
        Color = 16775406
        EditButtons = <>
        FieldName = 'SumOrder'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1057#1091#1084#1084#1072
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 513
    Width = 768
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      768
      38)
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 768
      Height = 38
      Align = alClient
      Shape = bsTopLine
    end
    object lblOrderLabel: TLabel
      Left = 316
      Top = 13
      Width = 238
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1047#1072#1082#1072#1079#1072#1085#1086' 0 '#1087#1086#1079#1080#1094#1080#1081' '#1085#1072' '#1089#1091#1084#1084#1091' 0,00 '#1088#1091#1073'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnDeleteOrder: TSpeedButton
      Left = 141
      Top = 6
      Width = 129
      Height = 27
      Action = actDeleteOrder
      Anchors = [akLeft, akBottom]
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1082#1072#1079
    end
    object btnFormHistory: TSpeedButton
      Left = 7
      Top = 6
      Width = 129
      Height = 27
      Anchors = [akLeft, akBottom]
      Caption = #1048#1089#1090#1086#1088#1080#1103
      OnClick = btnFormHistoryClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 768
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      768
      29)
    object lblRecordCount: TLabel
      Left = 486
      Top = 8
      Width = 60
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1055#1086#1079#1080#1094#1080#1081' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblFirmPrice: TLabel
      Left = 7
      Top = 6
      Width = 84
      Height = 16
      Caption = 'lblFirmPrice'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbFilter: TComboBox
      Left = 605
      Top = 4
      Width = 161
      Height = 21
      Hint = #1054#1090#1073#1086#1088' '#1079#1072#1087#1080#1089#1077#1081
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      OnClick = cbFilterClick
      Items.Strings = (
        #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' (F4)'
        #1047#1072#1082#1072#1079' (F5)'
        #1051#1091#1095#1096#1080#1077' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1103' (F6)')
    end
  end
  object dsCore: TDataSource
    DataSet = adsCore
    Left = 144
    Top = 128
  end
  object ActionList: TActionList
    Left = 404
    Top = 86
    object actFilterAll: TAction
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' (F4)'
      ShortCut = 115
      OnExecute = actFilterAllExecute
    end
    object actFilterOrder: TAction
      Caption = #1047#1072#1103#1074#1082#1072' (F5)'
      ShortCut = 116
      OnExecute = actFilterOrderExecute
    end
    object actFilterLeader: TAction
      Caption = #1051#1091#1095#1096#1080#1077' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1103' (F6)'
      ShortCut = 117
      OnExecute = actFilterLeaderExecute
    end
    object actSaveToFile: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083' (F11)'
      ShortCut = 122
    end
    object actDeleteOrder: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1103#1074#1082#1091' (F10)'
      ShortCut = 121
      OnExecute = actDeleteOrderExecute
    end
    object actFlipCore: TAction
      ShortCut = 113
      OnExecute = actFlipCoreExecute
    end
  end
  object frdsCore: TfrDBDataSet
    DataSource = dsCore
    Left = 144
    Top = 176
  end
  object adsOrdersH: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM OrdersHShowCurrent'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 1
      end
      item
        Name = 'APriceCode'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 31
      end
      item
        Name = 'ARegionCode'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 1
      end>
    Prepared = True
    Left = 280
    Top = 80
  end
  object adsCountFields: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM CoreCountPriceFields'
    Parameters = <
      item
        Name = 'APriceCode'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 31
      end
      item
        Name = 'ARegionCode'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 1
      end>
    Prepared = True
    Left = 208
    Top = 80
  end
  object adsOrdersShowFormSummary: TADODataSet
    Connection = DM.MainConnection
    CursorLocation = clUseServer
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM OrdersShowFormSummary'
    DataSource = dsCore
    MasterFields = 'FullCode'
    Parameters = <
      item
        Name = 'FullCode'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 1
      end
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
    Left = 256
    Top = 176
    object adsOrdersShowFormSummaryPriceAvg: TBCDField
      FieldName = 'PriceAvg'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      Precision = 19
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 640
    Top = 216
  end
  object adsCore: TADODataSet
    AutoCalcFields = False
    Connection = DM.MainConnection
    CursorLocation = clUseServer
    AfterOpen = adsCoreAfterOpen
    BeforeClose = adsCoreBeforeClose
    BeforeEdit = adsCoreBeforeEdit
    BeforePost = adsCoreBeforePost
    AfterPost = adsCoreAfterPost
    OnCalcFields = adsCoreCalcFields
    CommandText = 'SELECT * FROM CoreShowByFirm'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '928'
      end
      item
        Name = 'RetailForcount'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '30'
      end
      item
        Name = 'APriceCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '7'
      end
      item
        Name = 'ARegionCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '1'
      end>
    Prepared = True
    Left = 144
    Top = 80
    object adsCoreCoreId: TAutoIncField
      FieldName = 'CoreId'
      ReadOnly = True
    end
    object adsCoreFullCode: TIntegerField
      FieldName = 'FullCode'
    end
    object adsCoreShortCode: TIntegerField
      FieldName = 'ShortCode'
    end
    object adsCoreCodeFirmCr: TIntegerField
      FieldName = 'CodeFirmCr'
    end
    object adsCoreSynonymCode: TIntegerField
      FieldName = 'SynonymCode'
    end
    object adsCoreSynonymFirmCrCode: TIntegerField
      FieldName = 'SynonymFirmCrCode'
    end
    object adsCoreCode: TWideStringField
      FieldName = 'Code'
    end
    object adsCoreCodeCr: TWideStringField
      FieldName = 'CodeCr'
    end
    object adsCoreVolume: TWideStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsCoreDoc: TWideStringField
      FieldName = 'Doc'
    end
    object adsCoreNote: TWideStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsCorePeriod: TWideStringField
      FieldName = 'Period'
    end
    object adsCoreAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsCoreJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsCoreBaseCost: TBCDField
      FieldName = 'BaseCost'
      Precision = 19
    end
    object adsCoreQuantity: TWideStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsCoreSynonym: TWideStringField
      FieldName = 'Synonym'
      Size = 255
    end
    object adsCoreSynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsCoreMinPrice: TBCDField
      FieldName = 'MinPrice'
      Precision = 19
    end
    object adsCoreLeaderFirmCode: TIntegerField
      FieldName = 'LeaderPriceCode'
    end
    object adsCoreLeaderRegionCode: TIntegerField
      FieldName = 'LeaderRegionCode'
    end
    object adsCoreLeaderRegionName: TWideStringField
      FieldName = 'LeaderRegionName'
      Size = 25
    end
    object adsCoreLeaderPriceName: TWideStringField
      FieldName = 'LeaderPriceName'
      Size = 70
    end
    object adsCoreOrdersCoreId: TIntegerField
      FieldName = 'OrdersCoreId'
    end
    object adsCoreOrdersOrderId: TIntegerField
      FieldName = 'OrdersOrderId'
    end
    object adsCoreOrdersClientId: TSmallintField
      FieldName = 'OrdersClientId'
    end
    object adsCoreOrdersFullCode: TIntegerField
      FieldName = 'OrdersFullCode'
    end
    object adsCoreOrdersCodeFirmCr: TIntegerField
      FieldName = 'OrdersCodeFirmCr'
    end
    object adsCoreOrdersSynonymCode: TIntegerField
      FieldName = 'OrdersSynonymCode'
    end
    object adsCoreOrdersSynonymFirmCrCode: TIntegerField
      FieldName = 'OrdersSynonymFirmCrCode'
    end
    object adsCoreOrdersCode: TWideStringField
      FieldName = 'OrdersCode'
    end
    object adsCoreOrdersCodeCr: TWideStringField
      FieldName = 'OrdersCodeCr'
    end
    object adsCoreOrder: TIntegerField
      FieldName = 'Order'
      DisplayFormat = '#'
    end
    object adsCoreOrdersSynonym: TWideStringField
      FieldName = 'OrdersSynonym'
      Size = 255
    end
    object adsCoreOrdersSynonymFirm: TWideStringField
      FieldName = 'OrdersSynonymFirm'
      Size = 50
    end
    object adsCoreOrdersPrice: TBCDField
      FieldName = 'OrdersPrice'
      Precision = 19
    end
    object adsCoreOrdersJunk: TBooleanField
      FieldName = 'OrdersJunk'
    end
    object adsCoreOrdersAwait: TBooleanField
      FieldName = 'OrdersAwait'
    end
    object adsCoreOrdersHOrderId: TAutoIncField
      FieldName = 'OrdersHOrderId'
      ReadOnly = True
    end
    object adsCoreOrdersHClientId: TSmallintField
      FieldName = 'OrdersHClientId'
    end
    object adsCoreOrdersHPriceCode: TIntegerField
      FieldName = 'OrdersHPriceCode'
    end
    object adsCoreOrdersHRegionCode: TIntegerField
      FieldName = 'OrdersHRegionCode'
    end
    object adsCoreOrdersHPriceName: TWideStringField
      FieldName = 'OrdersHPriceName'
      Size = 25
    end
    object adsCoreOrdersHRegionName: TWideStringField
      FieldName = 'OrdersHRegionName'
      Size = 25
    end
    object adsCorePriceRet: TFloatField
      FieldName = 'PriceRet'
      ReadOnly = True
    end
    object adsCoreSumOrder: TBCDField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
      Calculated = True
    end
  end
end
