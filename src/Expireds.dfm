inherited ExpiredsForm: TExpiredsForm
  Left = 327
  Top = 229
  Caption = #1055#1088#1077#1087#1072#1088#1072#1090#1099' '#1089' '#1080#1089#1090#1077#1082#1072#1102#1097#1080#1084#1080' '#1089#1088#1086#1082#1072#1084#1080' '#1075#1086#1076#1085#1086#1089#1090#1080
  ClientHeight = 462
  ClientWidth = 613
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
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
    TabOrder = 1
    Visible = False
  end
  object pClient: TPanel
    Left = 0
    Top = 0
    Width = 613
    Height = 433
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pWebBrowser: TPanel
      Tag = 209
      Left = 0
      Top = 224
      Width = 613
      Height = 209
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object Bevel2: TBevel
        Left = 0
        Top = 0
        Width = 613
        Height = 4
        Align = alTop
        Shape = bsTopLine
      end
      object WebBrowser1: TWebBrowser
        Tag = 4
        Left = 0
        Top = 4
        Width = 613
        Height = 205
        Align = alClient
        TabOrder = 0
        ControlData = {
          4C0000005B3F0000301500000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object dbgExpireds: TToughDBGrid
      Left = 0
      Top = 0
      Width = 613
      Height = 224
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
      TabOrder = 1
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
          FieldName = 'SYNONYMFIRM'
          Footers = <>
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Title.TitleButton = True
          Width = 81
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'VOLUME'
          Footers = <>
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'NOTE'
          Footers = <>
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 78
        end
        item
          Alignment = taCenter
          EditButtons = <>
          FieldName = 'PERIOD'
          Footers = <>
          Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'PRICENAME'
          Footers = <>
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'REGIONNAME'
          Footers = <>
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Title.TitleButton = True
        end
        item
          Alignment = taCenter
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'DATEPRICE'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Title.TitleButton = True
          Width = 99
        end
        item
          EditButtons = <>
          FieldName = 'BASECOST'
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
          FieldName = 'PRICERET'
          Footers = <>
          Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
          Title.TitleButton = True
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'QUANTITY'
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
  end
  object Panel1: TPanel
    Left = 0
    Top = 433
    Width = 613
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
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
  object dsExpireds: TDataSource
    DataSet = adsExpireds
    Left = 128
    Top = 152
  end
  object adsOrdersH2: TADODataSet
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
    Left = 232
    Top = 96
  end
  object adsOrdersShowFormSummary2: TADODataSet
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
    Left = 312
    Top = 104
    object adsOrdersShowFormSummary2PriceAvg: TBCDField
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
  object adsExpireds2: TADODataSet
    CursorLocation = clUseServer
    AfterOpen = adsExpireds2AfterOpen
    BeforeClose = adsExpireds2BeforeClose
    BeforePost = adsExpireds2BeforePost
    AfterPost = adsExpireds2AfterPost
    AfterScroll = adsExpireds2AfterScroll
    OnCalcFields = adsExpireds2CalcFields
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
    Left = 128
    Top = 72
    object adsExpireds2CoreId: TIntegerField
      FieldName = 'CoreId'
    end
    object adsExpireds2PriceCode: TIntegerField
      FieldName = 'PriceCode'
    end
    object adsExpireds2RegionCode: TIntegerField
      FieldName = 'RegionCode'
    end
    object adsExpireds2FullCode: TIntegerField
      FieldName = 'FullCode'
    end
    object adsExpireds2CodeFirmCr: TIntegerField
      FieldName = 'CodeFirmCr'
    end
    object adsExpireds2SynonymCode: TIntegerField
      FieldName = 'SynonymCode'
    end
    object adsExpireds2SynonymFirmCrCode: TIntegerField
      FieldName = 'SynonymFirmCrCode'
    end
    object adsExpireds2Code: TWideStringField
      FieldName = 'Code'
    end
    object adsExpireds2CodeCr: TWideStringField
      FieldName = 'CodeCr'
    end
    object adsExpireds2Order: TIntegerField
      FieldName = 'Order'
      DisplayFormat = '#'
    end
    object adsExpireds2Note: TWideStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsExpireds2Await: TBooleanField
      FieldName = 'Await'
    end
    object adsExpireds2Period: TWideStringField
      FieldName = 'Period'
    end
    object adsExpireds2Volume: TWideStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsExpireds2BaseCost: TBCDField
      FieldName = 'BaseCost'
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
    end
    object adsExpireds2Quantity: TWideStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsExpireds2Synonym: TWideStringField
      FieldName = 'Synonym'
      Size = 255
    end
    object adsExpireds2SynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsExpireds2PriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 25
    end
    object adsExpireds2RegionName: TWideStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsExpireds2DatePrice: TDateTimeField
      FieldName = 'DatePrice'
      ReadOnly = True
    end
    object adsExpireds2PriceRet: TFloatField
      FieldName = 'PriceRet'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      currency = True
    end
    object adsExpireds2SumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsExpireds2OrdersCoreId: TIntegerField
      FieldName = 'OrdersCoreId'
    end
    object adsExpireds2OrdersOrderId: TIntegerField
      FieldName = 'OrdersOrderId'
    end
    object adsExpireds2OrdersClientId: TSmallintField
      FieldName = 'OrdersClientId'
    end
    object adsExpireds2OrdersFullCode: TIntegerField
      FieldName = 'OrdersFullCode'
    end
    object adsExpireds2OrdersCodeFirmCr: TIntegerField
      FieldName = 'OrdersCodeFirmCr'
    end
    object adsExpireds2OrdersSynonymCode: TIntegerField
      FieldName = 'OrdersSynonymCode'
    end
    object adsExpireds2OrdersSynonymFirmCrCode: TIntegerField
      FieldName = 'OrdersSynonymFirmCrCode'
    end
    object adsExpireds2OrdersCode: TWideStringField
      FieldName = 'OrdersCode'
    end
    object adsExpireds2OrdersCodeCr: TWideStringField
      FieldName = 'OrdersCodeCr'
    end
    object adsExpireds2OrdersPrice: TBCDField
      FieldName = 'OrdersPrice'
      Precision = 19
    end
    object adsExpireds2OrdersJunk: TBooleanField
      FieldName = 'OrdersJunk'
    end
    object adsExpireds2OrdersAwait: TBooleanField
      FieldName = 'OrdersAwait'
    end
    object adsExpireds2OrdersHOrderId: TAutoIncField
      FieldName = 'OrdersHOrderId'
      ReadOnly = True
    end
    object adsExpireds2OrdersHClientId: TSmallintField
      FieldName = 'OrdersHClientId'
    end
    object adsExpireds2OrdersHPriceCode: TIntegerField
      FieldName = 'OrdersHPriceCode'
    end
    object adsExpireds2OrdersHRegionCode: TIntegerField
      FieldName = 'OrdersHRegionCode'
    end
    object adsExpireds2OrdersHPriceName: TWideStringField
      FieldName = 'OrdersHPriceName'
      Size = 25
    end
    object adsExpireds2OrdersHRegionName: TWideStringField
      FieldName = 'OrdersHRegionName'
      Size = 25
    end
    object adsExpireds2OrdersSynonym: TWideStringField
      FieldName = 'OrdersSynonym'
      Size = 255
    end
    object adsExpireds2OrdersSynonymFirm: TWideStringField
      FieldName = 'OrdersSynonymFirm'
      Size = 50
    end
  end
  object adsExpireds: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '*'
      'FROM'
      '    EXPIREDSSHOW(:TIMEZONEBIAS,'
      '    :ACLIENTID,'
      '    :RETAILFORCOUNT) ')
    AfterOpen = adsExpireds2AfterOpen
    AfterPost = adsExpireds2AfterPost
    AfterScroll = adsExpireds2AfterScroll
    BeforeClose = adsExpireds2BeforeClose
    BeforePost = adsExpireds2BeforePost
    OnCalcFields = adsExpireds2CalcFields
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 128
    Top = 112
    object adsExpiredsCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsCODE: TFIBStringField
      FieldName = 'CODE'
      EmptyStrToNull = False
    end
    object adsExpiredsCODECR: TFIBStringField
      FieldName = 'CODECR'
      EmptyStrToNull = False
    end
    object adsExpiredsNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = False
    end
    object adsExpiredsPERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = False
    end
    object adsExpiredsVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = False
    end
    object adsExpiredsBASECOST: TFIBBCDField
      FieldName = 'BASECOST'
      Size = 4
      RoundByScale = True
    end
    object adsExpiredsQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = False
    end
    object adsExpiredsSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = False
    end
    object adsExpiredsSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = False
    end
    object adsExpiredsAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsExpiredsPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = False
    end
    object adsExpiredsDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsExpiredsREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = False
    end
    object adsExpiredsORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSCLIENTID: TFIBBCDField
      FieldName = 'ORDERSCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSFULLCODE: TFIBBCDField
      FieldName = 'ORDERSFULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSCODEFIRMCR: TFIBBCDField
      FieldName = 'ORDERSCODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSSYNONYMCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSCODE: TFIBStringField
      FieldName = 'ORDERSCODE'
      EmptyStrToNull = False
    end
    object adsExpiredsORDERSCODECR: TFIBStringField
      FieldName = 'ORDERSCODECR'
      EmptyStrToNull = False
    end
    object adsExpiredsORDERSSYNONYM: TFIBStringField
      FieldName = 'ORDERSSYNONYM'
      Size = 250
      EmptyStrToNull = False
    end
    object adsExpiredsORDERSSYNONYMFIRM: TFIBStringField
      FieldName = 'ORDERSSYNONYMFIRM'
      Size = 250
      EmptyStrToNull = False
    end
    object adsExpiredsORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsExpiredsORDERSPRICE: TFIBBCDField
      FieldName = 'ORDERSPRICE'
      Size = 4
      RoundByScale = True
    end
    object adsExpiredsORDERSJUNK: TFIBIntegerField
      FieldName = 'ORDERSJUNK'
    end
    object adsExpiredsORDERSAWAIT: TFIBIntegerField
      FieldName = 'ORDERSAWAIT'
    end
    object adsExpiredsORDERSHORDERID: TFIBBCDField
      FieldName = 'ORDERSHORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSHCLIENTID: TFIBBCDField
      FieldName = 'ORDERSHCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSHPRICECODE: TFIBBCDField
      FieldName = 'ORDERSHPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSHREGIONCODE: TFIBBCDField
      FieldName = 'ORDERSHREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSHPRICENAME: TFIBStringField
      FieldName = 'ORDERSHPRICENAME'
      Size = 70
      EmptyStrToNull = False
    end
    object adsExpiredsORDERSHREGIONNAME: TFIBStringField
      FieldName = 'ORDERSHREGIONNAME'
      Size = 25
      EmptyStrToNull = False
    end
    object adsExpiredsPRICERET: TFIBBCDField
      FieldName = 'PRICERET'
      Size = 4
      RoundByScale = True
    end
    object adsExpiredsSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      Calculated = True
    end
  end
  object adsOrdersH: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      ' *'
      'FROM'
      '    ORDERSHSHOWCURRENT(:ACLIENTID,'
      '    :APRICECODE,'
      '    :AREGIONCODE) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 232
    Top = 136
  end
  object adsOrdersShowFormSummary: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    *'
      'FROM'
      '    ORDERSSHOWFORMSUMMARY(:FULLCODE,'
      '    :ACLIENTID) ')
    DataSource = dsExpireds
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 312
    Top = 152
    WaitEndMasterScroll = True
    dcForceOpen = True
    object adsOrdersShowFormSummaryPRICEAVG: TFIBIntegerField
      FieldName = 'PRICEAVG'
    end
  end
end
