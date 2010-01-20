inherited ExpiredsForm: TExpiredsForm
  Left = 362
  Top = 200
  ActiveControl = dbgExpireds
  Caption = #1055#1088#1077#1087#1072#1088#1072#1090#1099' '#1089' '#1080#1089#1090#1077#1082#1072#1102#1097#1080#1084#1080' '#1089#1088#1086#1082#1072#1084#1080' '#1075#1086#1076#1085#1086#1089#1090#1080
  ClientHeight = 573
  ClientWidth = 792
  OldCreateOrder = True
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object plOverCost: TPanel [0]
    Left = 104
    Top = 232
    Width = 545
    Height = 97
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Visible = False
    DesignSize = (
      545
      97)
    object lWarning: TLabel
      Left = 1
      Top = 8
      Width = 543
      Height = 81
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1089#1088#1077#1076#1085#1077#1081' '#1094#1077#1085#1099'!'#13#10#1042#1099' '#1079#1072#1082#1072#1079#1072#1083#1080' '#1085#1077#1082#1086#1085#1076#1080#1094#1080#1086#1085#1085#1099#1081' '#1087#1088#1077#1087#1072#1088#1072#1090'.'#13#10 +
        #1042#1085#1080#1084#1072#1085#1080#1077'! '#1042#1099' '#1079#1072#1082#1072#1079#1072#1083#1080' '#1073#1086#1083#1100#1096#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1088#1077#1087#1072#1088#1072#1090#1072'.'
    end
  end
  object pClient: TPanel [1]
    Left = 0
    Top = 0
    Width = 792
    Height = 364
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object dbgExpireds: TToughDBGrid
      Tag = 4096
      Left = 0
      Top = 0
      Width = 792
      Height = 335
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
      OnGetCellParams = dbgExpiredsGetCellParams
      OnSortMarkingChanged = dbgExpiredsSortMarkingChanged
      SearchField = 'SynonymName'
      InputField = 'OrderCount'
      SearchPosition = spTop
      ForceRus = True
      OnCanInput = dbgExpiredsCanInput
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SynonymName'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 174
        end
        item
          EditButtons = <>
          FieldName = 'SynonymFirm'
          Footers = <>
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Title.TitleButton = True
          Width = 70
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Volume'
          Footers = <>
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Title.TitleButton = True
          Width = 37
        end
        item
          EditButtons = <>
          FieldName = 'Note'
          Footers = <>
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Title.TitleButton = True
          Visible = False
          Width = 37
        end
        item
          EditButtons = <>
          FieldName = 'doc'
          Footers = <>
          Title.Caption = #1044#1086#1082#1091#1084#1077#1085#1090
          Title.TitleButton = True
          Visible = False
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
          Width = 92
        end
        item
          EditButtons = <>
          FieldName = 'RegionName'
          Footers = <>
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Title.TitleButton = True
          Visible = False
          Width = 73
        end
        item
          Alignment = taCenter
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'DatePrice'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Title.TitleButton = True
          Width = 90
        end
        item
          EditButtons = <>
          FieldName = 'registrycost'
          Footers = <>
          Title.Caption = #1056#1077#1077#1089#1090#1088'. '#1094#1077#1085#1072
          Title.TitleButton = True
          Visible = False
          Width = 30
        end
        item
          EditButtons = <>
          FieldName = 'requestratio'
          Footers = <>
          Title.Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
          Title.TitleButton = True
          Visible = False
          Width = 30
        end
        item
          EditButtons = <>
          FieldName = 'ordercost'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'minordercount'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'RealCost'
          Footers = <>
          Title.Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1086#1090#1089#1088#1086#1095#1082#1080
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'Cost'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Footers = <>
          Title.Caption = #1062#1077#1085#1072
          Title.TitleButton = True
          Width = 63
        end
        item
          EditButtons = <>
          FieldName = 'CryptPriceRet'
          Footers = <>
          Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
          Title.TitleButton = True
          Width = 50
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Quantity'
          Footers = <>
          Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          Title.TitleButton = True
          Width = 37
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'OrderCount'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079
          Title.TitleButton = True
          Width = 46
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072
          Title.TitleButton = True
          Width = 51
        end>
    end
    object pRecordCount: TPanel
      Left = 0
      Top = 335
      Width = 792
      Height = 29
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        792
        29)
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 792
        Height = 29
        Align = alClient
        Shape = bsTopLine
      end
      object lblRecordCount: TLabel
        Left = 109
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
      object btnGotoCore: TButton
        Left = 5
        Top = 3
        Width = 94
        Height = 25
        Caption = #1042' '#1082#1072#1090#1072#1083#1086#1075' (F2)'
        TabOrder = 0
        Visible = False
      end
    end
  end
  object pWebBrowser: TPanel [2]
    Tag = 209
    Left = 0
    Top = 364
    Width = 792
    Height = 209
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object Bevel2: TBevel
      Left = 0
      Top = 0
      Width = 792
      Height = 4
      Align = alTop
      Shape = bsTopLine
    end
    object WebBrowser1: TWebBrowser
      Tag = 4
      Left = 0
      Top = 4
      Width = 792
      Height = 205
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C000000DB510000301500000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object dsExpireds: TDataSource
    DataSet = adsExpireds
    Left = 128
    Top = 152
  end
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 416
    Top = 224
  end
  object adsExpiredsOld: TpFIBDataSet
    UpdateSQL.Strings = (
      
        'execute procedure updateordercount(:new_ORDERSHORDERID, :clienti' +
        'd, :PRICECODE, :REGIONCODE, :new_ORDERSORDERID, :new_COREID, :NE' +
        'W_ORDERCOUNT)')
    SelectSQL.Strings = (
      'SELECT'
      '*'
      'FROM'
      '    EXPIREDSSHOW(:TIMEZONEBIAS,'
      '    :CLIENTID, null) ')
    AfterPost = adsExpireds2AfterPost
    AfterScroll = adsExpireds2AfterScroll
    BeforePost = adsExpireds2BeforePost
    Database = DM.MainConnectionOld
    AutoCommit = True
    Left = 128
    Top = 112
    oTrimCharFields = False
    oCacheCalcFields = True
    oRefreshAfterPost = False
    object adsExpiredsOldCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsExpiredsOldCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsExpiredsOldNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = True
    end
    object adsExpiredsOldPERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = True
    end
    object adsExpiredsOldVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = True
    end
    object adsExpiredsOldQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = True
    end
    object adsExpiredsOldSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsExpiredsOldSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsExpiredsOldAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsExpiredsOldPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsExpiredsOldDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsExpiredsOldREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsExpiredsOldORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSCLIENTID: TFIBBCDField
      FieldName = 'ORDERSCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSFULLCODE: TFIBBCDField
      FieldName = 'ORDERSFULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSCODEFIRMCR: TFIBBCDField
      FieldName = 'ORDERSCODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSSYNONYMCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSCODE: TFIBStringField
      FieldName = 'ORDERSCODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsExpiredsOldORDERSCODECR: TFIBStringField
      FieldName = 'ORDERSCODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsExpiredsOldORDERSSYNONYM: TFIBStringField
      FieldName = 'ORDERSSYNONYM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsExpiredsOldORDERSSYNONYMFIRM: TFIBStringField
      FieldName = 'ORDERSSYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsExpiredsOldORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
      DisplayFormat = '#'
    end
    object adsExpiredsOldORDERSJUNK: TFIBIntegerField
      FieldName = 'ORDERSJUNK'
    end
    object adsExpiredsOldORDERSAWAIT: TFIBIntegerField
      FieldName = 'ORDERSAWAIT'
    end
    object adsExpiredsOldORDERSHORDERID: TFIBBCDField
      FieldName = 'ORDERSHORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSHCLIENTID: TFIBBCDField
      FieldName = 'ORDERSHCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSHPRICECODE: TFIBBCDField
      FieldName = 'ORDERSHPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSHREGIONCODE: TFIBBCDField
      FieldName = 'ORDERSHREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsOldORDERSHPRICENAME: TFIBStringField
      FieldName = 'ORDERSHPRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsExpiredsOldORDERSHREGIONNAME: TFIBStringField
      FieldName = 'ORDERSHREGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsExpiredsOldSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsExpiredsOldPriceRet: TCurrencyField
      Tag = 4
      FieldKind = fkCalculated
      FieldName = 'CryptPriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsExpiredsOldCryptBASECOST: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptBASECOST'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsExpiredsOldBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 60
      EmptyStrToNull = True
    end
    object adsExpiredsOldORDERSPRICE: TFIBStringField
      FieldName = 'ORDERSPRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsExpiredsOldDOC: TFIBStringField
      FieldName = 'DOC'
      EmptyStrToNull = True
    end
    object adsExpiredsOldREGISTRYCOST: TFIBFloatField
      FieldName = 'REGISTRYCOST'
      DisplayFormat = '#'
    end
    object adsExpiredsOldREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
      DisplayFormat = '#'
    end
    object adsExpiredsOldVITALLYIMPORTANT: TFIBIntegerField
      FieldName = 'VITALLYIMPORTANT'
    end
    object adsExpiredsOldORDERCOST: TFIBBCDField
      FieldName = 'ORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsExpiredsOldMINORDERCOUNT: TFIBIntegerField
      FieldName = 'MINORDERCOUNT'
    end
  end
  object adsOrdersShowFormSummaryOld: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    *'
      'FROM'
      '   ClientAVG'
      'where'
      '  ClientCode = :CLIENTID'
      'and ProductId = :ProductId')
    Database = DM.MainConnectionOld
    Left = 312
    Top = 152
    WaitEndMasterScroll = True
    dcForceOpen = True
    oCacheCalcFields = True
    object adsOrdersShowFormSummaryOldPRICEAVG: TFIBBCDField
      FieldName = 'PRICEAVG'
      Size = 2
      RoundByScale = True
    end
  end
  object ActionList: TActionList
    Left = 352
    Top = 192
    object actFlipCore: TAction
      Caption = #1042' '#1082#1072#1090#1072#1083#1086#1075' (F2)'
      ShortCut = 113
      OnExecute = actFlipCoreExecute
    end
  end
  object adsAvgOrders: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT'
      '    *'
      'FROM'
      '   ClientAVG'
      'where'
      '  ClientCode = :CLIENTID')
    MasterSource = dsExpireds
    MasterFields = 'productid'
    DetailFields = 'PRODUCTID'
    Left = 352
    Top = 152
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CLIENTID'
      end
      item
        DataType = ftUnknown
        Name = 'productid'
      end>
    object adsAvgOrdersPRICEAVG: TFloatField
      FieldName = 'PRICEAVG'
    end
    object adsAvgOrdersPRODUCTID: TLargeintField
      FieldName = 'PRODUCTID'
    end
  end
  object adsExpireds: TMyQuery
    SQLUpdate.Strings = (
      'update'
      '  orderslist'
      'set'
      '  OrderCount = :ORDERCOUNT,'
      '  DropReason = if(:ORDERCOUNT = 0, null, DropReason),'
      '  ServerCost = if(:ORDERCOUNT = 0, null, ServerCost),'
      '  ServerQuantity = if(:ORDERCOUNT = 0, null, ServerQuantity)'
      'where'
      '    OrderId = :ORDERSORDERID'
      'and CoreId  = :OLD_COREID')
    SQLRefresh.Strings = (
      'SELECT '
      '    Core.CoreId,'
      '    Core.PriceCode,'
      '    Core.RegionCode,'
      '    Core.productid,'
      '    catalogs.fullcode,'
      '    Core.CodeFirmCr,'
      '    Core.SynonymCode,'
      '    Core.SynonymFirmCrCode,'
      '    Core.Code,'
      '    Core.CodeCr,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Volume,'
      '    Core.Cost as RealCost,'
      
        '    if(dop.Percent is null, Core.Cost, cast(Core.Cost * (1 + dop' +
        '.Percent/100) as decimal(18, 2))) as Cost,'
      '    Core.Quantity,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    Core.ordercost,'
      '    Core.minordercount,'
      '    Core.SupplierPriceMarkup,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    Core.Await,'
      '    PricesData.PriceName,'
      
        '    PricesData.DatePrice + interval  -:TimeZoneBias minute AS Da' +
        'tePrice,'
      '    Regions.RegionName,'
      '    osbc.CoreId AS OrdersCoreId,'
      '    osbc.OrderId AS OrdersOrderId,'
      '    osbc.ClientId AS OrdersClientId,'
      '    catalogs.fullcode AS OrdersFullCode,'
      '    osbc.CodeFirmCr AS OrdersCodeFirmCr,'
      '    osbc.SynonymCode AS OrdersSynonymCode,'
      '    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,'
      '    osbc.Code AS OrdersCode,'
      '    osbc.CodeCr AS OrdersCodeCr,'
      '    osbc.SynonymName AS OrdersSynonym,'
      '    osbc.SynonymFirm AS OrdersSynonymFirm,'
      '    osbc.OrderCount,'
      '    osbc.Price AS OrdersPrice,'
      '    osbc.Price*osbc.OrderCount AS SumOrder,'
      '    osbc.Junk AS OrdersJunk,'
      '    osbc.Await AS OrdersAwait,'
      '    OrdersHead.OrderId AS OrdersHOrderId,'
      '    OrdersHead.ClientId AS OrdersHClientId,'
      '    OrdersHead.PriceCode AS OrdersHPriceCode,'
      '    OrdersHead.RegionCode AS OrdersHRegionCode,'
      '    OrdersHead.PriceName AS OrdersHPriceName,'
      '    OrdersHead.RegionName AS OrdersHRegionName'
      'FROM'
      '    Core'
      '    left JOIN PricesData ON Core.PriceCode=PricesData.PriceCode'
      '    left JOIN Regions ON Core.RegionCode=Regions.RegionCode'
      '    left join products on products.productid = core.productid'
      '    left join catalogs on catalogs.fullcode = products.catalogid'
      '    left JOIN Synonyms ON Core.SynonymCode=Synonyms.SynonymCode'
      
        '    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFir' +
        'mCr.SynonymFirmCrCode'
      
        '    LEFT JOIN OrdersList osbc ON osbc.clientid = :ClientId and o' +
        'sbc.CoreId=Core.CoreId'
      
        '    left join DelayOfPayments dop on (dop.FirmCode = PricesData.' +
        'FirmCode) '
      '    LEFT JOIN OrdersHead ON osbc.OrderId=OrdersHead.OrderId'
      'WHERE'
      '  Core.CoreID = :CoreID')
    Connection = DM.MyConnection
    SQL.Strings = (
      '#EXPIREDSSHOW'
      'SELECT '
      '    Core.CoreId,'
      '    Core.PriceCode,'
      '    Core.RegionCode,'
      '    Core.productid,'
      '    catalogs.fullcode,'
      '    Core.CodeFirmCr,'
      '    Core.SynonymCode,'
      '    Core.SynonymFirmCrCode,'
      '    Core.Code,'
      '    Core.CodeCr,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Volume,'
      '    Core.Cost as RealCost,'
      
        '    if(dop.Percent is null, Core.Cost, cast(Core.Cost * (1 + dop' +
        '.Percent/100) as decimal(18, 2))) as Cost,'
      '    Core.Quantity,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    Core.ordercost,'
      '    Core.minordercount,'
      '    Core.SupplierPriceMarkup,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    Core.Await,'
      '    PricesData.PriceName,'
      
        '    PricesData.DatePrice + interval  -:TimeZoneBias minute AS Da' +
        'tePrice,'
      '    Regions.RegionName,'
      '    osbc.CoreId AS OrdersCoreId,'
      '    osbc.OrderId AS OrdersOrderId,'
      '    osbc.ClientId AS OrdersClientId,'
      '    catalogs.fullcode AS OrdersFullCode,'
      '    osbc.CodeFirmCr AS OrdersCodeFirmCr,'
      '    osbc.SynonymCode AS OrdersSynonymCode,'
      '    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,'
      '    osbc.Code AS OrdersCode,'
      '    osbc.CodeCr AS OrdersCodeCr,'
      '    osbc.SynonymName AS OrdersSynonym,'
      '    osbc.SynonymFirm AS OrdersSynonymFirm,'
      '    osbc.OrderCount,'
      '    osbc.Price AS OrdersPrice,'
      '    osbc.Price*osbc.OrderCount AS SumOrder,'
      '    osbc.Junk AS OrdersJunk,'
      '    osbc.Await AS OrdersAwait,'
      '    OrdersHead.OrderId AS OrdersHOrderId,'
      '    OrdersHead.ClientId AS OrdersHClientId,'
      '    OrdersHead.PriceCode AS OrdersHPriceCode,'
      '    OrdersHead.RegionCode AS OrdersHRegionCode,'
      '    OrdersHead.PriceName AS OrdersHPriceName,'
      '    OrdersHead.RegionName AS OrdersHRegionName'
      'FROM'
      '    Core'
      '    left JOIN PricesData ON Core.PriceCode=PricesData.PriceCode'
      '    left JOIN Regions ON Core.RegionCode=Regions.RegionCode'
      '    left join products on products.productid = core.productid'
      '    left join catalogs on catalogs.fullcode = products.catalogid'
      '    left JOIN Synonyms ON Core.SynonymCode=Synonyms.SynonymCode'
      
        '    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFir' +
        'mCr.SynonymFirmCrCode'
      
        '    LEFT JOIN OrdersList osbc ON osbc.clientid = :ClientId and o' +
        'sbc.CoreId=Core.CoreId'
      
        '    left join DelayOfPayments dop on (dop.FirmCode = PricesData.' +
        'FirmCode) '
      '    LEFT JOIN OrdersHead ON osbc.OrderId=OrdersHead.OrderId'
      'WHERE'
      '    (Core.productid > 0)'
      'and (Core.Junk = 1)')
    BeforeUpdateExecute = BeforeUpdateExecuteForClientID
    RefreshOptions = [roAfterUpdate]
    BeforePost = adsExpireds2BeforePost
    AfterPost = adsExpireds2AfterPost
    AfterScroll = adsExpireds2AfterScroll
    Left = 160
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TimeZoneBias'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end>
    object adsExpiredsCoreId: TLargeintField
      FieldName = 'CoreId'
    end
    object adsExpiredsPriceCode: TLargeintField
      FieldName = 'PriceCode'
    end
    object adsExpiredsRegionCode: TLargeintField
      FieldName = 'RegionCode'
    end
    object adsExpiredsproductid: TLargeintField
      FieldName = 'productid'
    end
    object adsExpiredsfullcode: TLargeintField
      FieldName = 'fullcode'
    end
    object adsExpiredsCodeFirmCr: TLargeintField
      FieldName = 'CodeFirmCr'
    end
    object adsExpiredsSynonymCode: TLargeintField
      FieldName = 'SynonymCode'
    end
    object adsExpiredsSynonymFirmCrCode: TLargeintField
      FieldName = 'SynonymFirmCrCode'
    end
    object adsExpiredsCode: TStringField
      FieldName = 'Code'
      Size = 84
    end
    object adsExpiredsCodeCr: TStringField
      FieldName = 'CodeCr'
      Size = 84
    end
    object adsExpiredsNote: TStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsExpiredsPeriod: TStringField
      FieldName = 'Period'
    end
    object adsExpiredsVolume: TStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsExpiredsCost: TFloatField
      FieldName = 'Cost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsExpiredsQuantity: TStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsExpiredsdoc: TStringField
      FieldName = 'doc'
    end
    object adsExpiredsregistrycost: TFloatField
      FieldName = 'registrycost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsExpiredsvitallyimportant: TBooleanField
      FieldName = 'vitallyimportant'
    end
    object adsExpiredsrequestratio: TIntegerField
      FieldName = 'requestratio'
      DisplayFormat = '#'
    end
    object adsExpiredsordercost: TFloatField
      FieldName = 'ordercost'
    end
    object adsExpiredsminordercount: TIntegerField
      FieldName = 'minordercount'
    end
    object adsExpiredsSynonymName: TStringField
      FieldName = 'SynonymName'
      Size = 501
    end
    object adsExpiredsSynonymFirm: TStringField
      FieldName = 'SynonymFirm'
      Size = 250
    end
    object adsExpiredsAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsExpiredsPriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsExpiredsDatePrice: TDateTimeField
      FieldName = 'DatePrice'
    end
    object adsExpiredsRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsExpiredsOrdersCoreId: TLargeintField
      FieldName = 'OrdersCoreId'
    end
    object adsExpiredsOrdersOrderId: TLargeintField
      FieldName = 'OrdersOrderId'
    end
    object adsExpiredsOrdersClientId: TLargeintField
      FieldName = 'OrdersClientId'
    end
    object adsExpiredsOrdersFullCode: TLargeintField
      FieldName = 'OrdersFullCode'
    end
    object adsExpiredsOrdersCodeFirmCr: TLargeintField
      FieldName = 'OrdersCodeFirmCr'
    end
    object adsExpiredsOrdersSynonymCode: TLargeintField
      FieldName = 'OrdersSynonymCode'
    end
    object adsExpiredsOrdersSynonymFirmCrCode: TLargeintField
      FieldName = 'OrdersSynonymFirmCrCode'
    end
    object adsExpiredsOrdersCode: TStringField
      FieldName = 'OrdersCode'
      Size = 84
    end
    object adsExpiredsOrdersCodeCr: TStringField
      FieldName = 'OrdersCodeCr'
      Size = 84
    end
    object adsExpiredsOrdersSynonym: TStringField
      FieldName = 'OrdersSynonym'
      Size = 250
    end
    object adsExpiredsOrdersSynonymFirm: TStringField
      FieldName = 'OrdersSynonymFirm'
      Size = 250
    end
    object adsExpiredsOrderCount: TIntegerField
      FieldName = 'OrderCount'
      DisplayFormat = '#'
    end
    object adsExpiredsOrdersPrice: TFloatField
      FieldName = 'OrdersPrice'
    end
    object adsExpiredsSumOrder: TFloatField
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsExpiredsOrdersJunk: TBooleanField
      FieldName = 'OrdersJunk'
    end
    object adsExpiredsOrdersAwait: TBooleanField
      FieldName = 'OrdersAwait'
    end
    object adsExpiredsOrdersHOrderId: TLargeintField
      FieldName = 'OrdersHOrderId'
    end
    object adsExpiredsOrdersHClientId: TLargeintField
      FieldName = 'OrdersHClientId'
    end
    object adsExpiredsOrdersHPriceCode: TLargeintField
      FieldName = 'OrdersHPriceCode'
    end
    object adsExpiredsOrdersHRegionCode: TLargeintField
      FieldName = 'OrdersHRegionCode'
    end
    object adsExpiredsOrdersHPriceName: TStringField
      FieldName = 'OrdersHPriceName'
      Size = 70
    end
    object adsExpiredsOrdersHRegionName: TStringField
      FieldName = 'OrdersHRegionName'
      Size = 25
    end
    object adsExpiredsCryptPriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPriceRet'
      Calculated = True
    end
    object adsExpiredsRealCost: TFloatField
      FieldName = 'RealCost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsExpiredsSupplierPriceMarkup: TFloatField
      FieldName = 'SupplierPriceMarkup'
    end
  end
end
