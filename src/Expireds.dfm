inherited ExpiredsForm: TExpiredsForm
  Left = 327
  Top = 229
  ActiveControl = dbgExpireds
  Caption = #1055#1088#1077#1087#1072#1088#1072#1090#1099' '#1089' '#1080#1089#1090#1077#1082#1072#1102#1097#1080#1084#1080' '#1089#1088#1086#1082#1072#1084#1080' '#1075#1086#1076#1085#1086#1089#1090#1080
  ClientHeight = 462
  ClientWidth = 613
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 0
    Top = 218
    Width = 613
    Height = 4
    Align = alBottom
    Shape = bsTopLine
  end
  object plOverCost: TPanel
    Left = 176
    Top = 176
    Width = 305
    Height = 57
    Caption = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1089#1088#1077#1076#1085#1077#1081' '#1094#1077#1085#1099'!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Visible = False
  end
  object dbgExpireds: TToughDBGrid
    Left = 0
    Top = 0
    Width = 613
    Height = 218
    Align = alClient
    AutoFitColWidths = True
    DataSource = dsExpireds
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
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    SearchField = 'Synonym'
    InputField = 'Order'
    SearchPosition = spTop
    ForceRus = True
    OnSortChange = dbgExpiredsSortChange
    OnCanInput = dbgExpiredsCanInput
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Synonym'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 95
      end
      item
        EditButtons = <>
        FieldName = 'SynonymFirm'
        Footers = <>
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Title.TitleButton = True
        Width = 81
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'Volume'
        Footers = <>
        Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'Note'
        Footers = <>
        Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 78
      end
      item
        Alignment = taCenter
        EditButtons = <>
        FieldName = 'Period'
        Footers = <>
        Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'PriceName'
        Footers = <>
        Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'RegionName'
        Footers = <>
        Title.Caption = #1056#1077#1075#1080#1086#1085
        Title.TitleButton = True
      end
      item
        Alignment = taCenter
        DisplayFormat = 'dd.mm.yyyy hh:nn'
        EditButtons = <>
        FieldName = 'DatePrice'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
        Title.TitleButton = True
        Width = 99
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
        Title.Caption = #1062#1077#1085#1072
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'PriceRet'
        Footers = <>
        Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
        Title.TitleButton = True
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'Quantity'
        Footers = <>
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Title.TitleButton = True
      end
      item
        Color = 16775406
        EditButtons = <>
        FieldName = 'Order'
        Footers = <>
        Title.Caption = #1047#1072#1082#1072#1079
      end
      item
        Color = 16775406
        EditButtons = <>
        FieldName = 'SumOrder'
        Footers = <>
        Title.Caption = #1057#1091#1084#1084#1072
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 433
    Width = 613
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      613
      29)
    object lblRecordCount: TLabel
      Left = 12
      Top = 8
      Width = 80
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1079#1080#1094#1080#1081' : %d'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 613
      Height = 29
      Align = alClient
      Shape = bsTopLine
    end
  end
  object WebBrowser1: TWebBrowser
    Tag = 4
    Left = 0
    Top = 222
    Width = 613
    Height = 211
    Align = alBottom
    TabOrder = 3
    ControlData = {
      4C0000005B3F0000CF1500000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object dsExpireds: TDataSource
    DataSet = adsExpireds
    Left = 152
    Top = 144
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
    Left = 240
    Top = 96
  end
  object adsOrdersShowFormSummary: TADODataSet
    Connection = DM.MainConnection
    CursorLocation = clUseServer
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM OrdersShowFormSummary'
    DataSource = dsExpireds
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
    Left = 240
    Top = 152
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
    Left = 416
    Top = 224
  end
  object adsExpireds: TADODataSet
    Connection = DM.MainConnection
    CursorLocation = clUseServer
    AfterOpen = adsExpiredsAfterOpen
    BeforeClose = adsExpiredsBeforeClose
    BeforePost = adsExpiredsBeforePost
    AfterPost = adsExpiredsAfterPost
    OnCalcFields = adsExpiredsCalcFields
    CommandText = 'SELECT * FROM ExpiredsShow'
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
        Name = 'TimeZoneBias'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '-180'
      end
      item
        Name = 'RetailForcount'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '30'
      end>
    Prepared = True
    Left = 152
    Top = 96
    object adsExpiredsCoreId: TIntegerField
      FieldName = 'CoreId'
    end
    object adsExpiredsPriceCode: TIntegerField
      FieldName = 'PriceCode'
    end
    object adsExpiredsRegionCode: TIntegerField
      FieldName = 'RegionCode'
    end
    object adsExpiredsFullCode: TIntegerField
      FieldName = 'FullCode'
    end
    object adsExpiredsCodeFirmCr: TIntegerField
      FieldName = 'CodeFirmCr'
    end
    object adsExpiredsSynonymCode: TIntegerField
      FieldName = 'SynonymCode'
    end
    object adsExpiredsSynonymFirmCrCode: TIntegerField
      FieldName = 'SynonymFirmCrCode'
    end
    object adsExpiredsCode: TWideStringField
      FieldName = 'Code'
    end
    object adsExpiredsCodeCr: TWideStringField
      FieldName = 'CodeCr'
    end
    object adsExpiredsOrder: TIntegerField
      FieldName = 'Order'
      DisplayFormat = '#'
    end
    object adsExpiredsNote: TWideStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsExpiredsAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsExpiredsPeriod: TWideStringField
      FieldName = 'Period'
    end
    object adsExpiredsVolume: TWideStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsExpiredsBaseCost: TBCDField
      FieldName = 'BaseCost'
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
    end
    object adsExpiredsQuantity: TWideStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsExpiredsSynonym: TWideStringField
      FieldName = 'Synonym'
      Size = 255
    end
    object adsExpiredsSynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsExpiredsPriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 25
    end
    object adsExpiredsRegionName: TWideStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsExpiredsDatePrice: TDateTimeField
      FieldName = 'DatePrice'
      ReadOnly = True
    end
    object adsExpiredsPriceRet: TFloatField
      FieldName = 'PriceRet'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      currency = True
    end
    object adsExpiredsSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsExpiredsOrdersCoreId: TIntegerField
      FieldName = 'OrdersCoreId'
    end
    object adsExpiredsOrdersOrderId: TIntegerField
      FieldName = 'OrdersOrderId'
    end
    object adsExpiredsOrdersClientId: TSmallintField
      FieldName = 'OrdersClientId'
    end
    object adsExpiredsOrdersFullCode: TIntegerField
      FieldName = 'OrdersFullCode'
    end
    object adsExpiredsOrdersCodeFirmCr: TIntegerField
      FieldName = 'OrdersCodeFirmCr'
    end
    object adsExpiredsOrdersSynonymCode: TIntegerField
      FieldName = 'OrdersSynonymCode'
    end
    object adsExpiredsOrdersSynonymFirmCrCode: TIntegerField
      FieldName = 'OrdersSynonymFirmCrCode'
    end
    object adsExpiredsOrdersCode: TWideStringField
      FieldName = 'OrdersCode'
    end
    object adsExpiredsOrdersCodeCr: TWideStringField
      FieldName = 'OrdersCodeCr'
    end
    object adsExpiredsOrdersPrice: TBCDField
      FieldName = 'OrdersPrice'
      Precision = 19
    end
    object adsExpiredsOrdersJunk: TBooleanField
      FieldName = 'OrdersJunk'
    end
    object adsExpiredsOrdersAwait: TBooleanField
      FieldName = 'OrdersAwait'
    end
    object adsExpiredsOrdersHOrderId: TAutoIncField
      FieldName = 'OrdersHOrderId'
      ReadOnly = True
    end
    object adsExpiredsOrdersHClientId: TSmallintField
      FieldName = 'OrdersHClientId'
    end
    object adsExpiredsOrdersHPriceCode: TIntegerField
      FieldName = 'OrdersHPriceCode'
    end
    object adsExpiredsOrdersHRegionCode: TIntegerField
      FieldName = 'OrdersHRegionCode'
    end
    object adsExpiredsOrdersHPriceName: TWideStringField
      FieldName = 'OrdersHPriceName'
      Size = 25
    end
    object adsExpiredsOrdersHRegionName: TWideStringField
      FieldName = 'OrdersHRegionName'
      Size = 25
    end
    object adsExpiredsOrdersSynonym: TWideStringField
      FieldName = 'OrdersSynonym'
      Size = 255
    end
    object adsExpiredsOrdersSynonymFirm: TWideStringField
      FieldName = 'OrdersSynonymFirm'
      Size = 50
    end
  end
end
