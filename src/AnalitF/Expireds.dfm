inherited ExpiredsForm: TExpiredsForm
  Left = 362
  Top = 200
  ActiveControl = dbgExpireds
  Caption = #1055#1088#1077#1087#1072#1088#1072#1090#1099' '#1089' '#1080#1089#1090#1077#1082#1072#1102#1097#1080#1084#1080' '#1089#1088#1086#1082#1072#1084#1080' '#1075#1086#1076#1085#1086#1089#1090#1080
  ClientHeight = 573
  ClientWidth = 792
  OldCreateOrder = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pClient: TPanel [0]
    Left = 0
    Top = 0
    Width = 792
    Height = 573
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object dbgExpireds: TToughDBGrid
      Tag = 4096
      Left = 0
      Top = 0
      Width = 792
      Height = 544
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
          Title.TitleButton = True
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
      Top = 544
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
        Left = 301
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
      object btnGotoCore: TSpeedButton
        Left = 5
        Top = 3
        Width = 94
        Height = 25
        Action = actFlipCore
      end
      object btnGotoMNN: TSpeedButton
        Left = 109
        Top = 3
        Width = 177
        Height = 25
        Caption = 'GotoMNN'
        Visible = False
      end
    end
  end
  object dsExpireds: TDataSource
    DataSet = adsExpireds
    Left = 128
    Top = 152
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
      'ClientAVG.ClientCode,'
      'ClientAVG.ProductId,'
      'ClientAVG.PriceAvg,'
      'ClientAVG.OrderCountAvg'
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
    object adsAvgOrdersOrderCountAvg: TFloatField
      FieldName = 'OrderCountAvg'
    end
  end
  object adsExpireds: TMyQuery
    SQLUpdate.Strings = (
      'update'
      '  CurrentOrderLists'
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
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    catalogs.Markup,'
      '    Core.RetailVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    Core.CodeFirmCr,'
      '    Core.SynonymCode,'
      '    Core.SynonymFirmCrCode,'
      '    Core.Code,'
      '    Core.CodeCr,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Exp,'
      '    Core.Volume,'
      '    Core.Cost as RealCost,'
      '  if(dop.OtherDelay is null,'
      '      Core.Cost,'
      
        '      if(Core.VitallyImportant || ifnull(catalogs.VitallyImporta' +
        'nt, 0),'
      
        '          cast(Core.Cost * (1 + dop.VitallyImportantDelay/100) a' +
        's decimal(18, 2)),'
      
        '          cast(Core.Cost * (1 + dop.OtherDelay/100) as decimal(1' +
        '8, 2))'
      '       )'
      '  )'
      '      as Cost,'
      '    Core.Quantity,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    Core.ordercost,'
      '    Core.minordercount,'
      '    Core.ProducerCost,'
      '    Core.NDS,'
      '    Core.SupplierPriceMarkup,'
      '    Core.BuyingMatrixType,'
      
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
      '    CurrentOrderHeads.OrderId AS OrdersHOrderId,'
      '    CurrentOrderHeads.ClientId AS OrdersHClientId,'
      '    CurrentOrderHeads.PriceCode AS OrdersHPriceCode,'
      '    CurrentOrderHeads.RegionCode AS OrdersHRegionCode,'
      '    CurrentOrderHeads.PriceName AS OrdersHPriceName,'
      '    CurrentOrderHeads.RegionName AS OrdersHRegionName,'
      '    Mnn.Id as MnnId,'
      '    Mnn.Mnn,'
      '    GroupMaxProducerCosts.MaxProducerCost,'
      '    Producers.Name as ProducerName'
      'FROM'
      '    Core'
      '    inner JOIN PricesData ON Core.PriceCode=PricesData.PriceCode'
      '    inner JOIN Regions ON Core.RegionCode=Regions.RegionCode'
      '    left join products on products.productid = core.productid'
      '    left join catalogs on catalogs.fullcode = products.catalogid'
      '    left join Producers on Producers.Id = Core.CodeFirmCr'
      '    left join Mnn on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = Core.productid) '
      '      and (Core.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      '    left JOIN Synonyms ON Core.SynonymCode=Synonyms.SynonymCode'
      
        '    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFir' +
        'mCr.SynonymFirmCrCode'
      
        '    LEFT JOIN CurrentOrderLists osbc ON osbc.clientid = :ClientI' +
        'd and osbc.CoreId=Core.CoreId'
      
        '    left join DelayOfPayments dop on (dop.PriceCode = PricesData' +
        '.PriceCode) and (dop.DayOfWeek = :DayOfWeek) '
      
        '    LEFT JOIN CurrentOrderHeads ON osbc.OrderId=CurrentOrderHead' +
        's.OrderId and CurrentOrderHeads.Frozen = 0 '
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
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    catalogs.Markup,'
      '    Core.RetailVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    Core.CodeFirmCr,'
      '    Core.SynonymCode,'
      '    Core.SynonymFirmCrCode,'
      '    Core.Code,'
      '    Core.CodeCr,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Exp,'
      '    Core.Volume,'
      '    Core.Cost as RealCost,'
      '  if(dop.OtherDelay is null,'
      '      Core.Cost,'
      
        '      if(Core.VitallyImportant || ifnull(catalogs.VitallyImporta' +
        'nt, 0),'
      
        '          cast(Core.Cost * (1 + dop.VitallyImportantDelay/100) a' +
        's decimal(18, 2)),'
      
        '          cast(Core.Cost * (1 + dop.OtherDelay/100) as decimal(1' +
        '8, 2))'
      '       )'
      '  )'
      '      as Cost,'
      '    Core.Quantity,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    Core.ordercost,'
      '    Core.minordercount,'
      '    Core.ProducerCost,'
      '    Core.NDS,'
      '    Core.SupplierPriceMarkup,'
      '    Core.BuyingMatrixType,'
      
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
      '    CurrentOrderHeads.OrderId AS OrdersHOrderId,'
      '    CurrentOrderHeads.ClientId AS OrdersHClientId,'
      '    CurrentOrderHeads.PriceCode AS OrdersHPriceCode,'
      '    CurrentOrderHeads.RegionCode AS OrdersHRegionCode,'
      '    CurrentOrderHeads.PriceName AS OrdersHPriceName,'
      '    CurrentOrderHeads.RegionName AS OrdersHRegionName,'
      '    Mnn.Id as MnnId,'
      '    Mnn.Mnn,'
      '    GroupMaxProducerCosts.MaxProducerCost,'
      '    Producers.Name as ProducerName'
      'FROM'
      '    Core'
      '    inner JOIN PricesData ON Core.PriceCode=PricesData.PriceCode'
      '    inner JOIN Regions ON Core.RegionCode=Regions.RegionCode'
      '    left join products on products.productid = core.productid'
      '    left join catalogs on catalogs.fullcode = products.catalogid'
      '    left join Producers on Producers.Id = Core.CodeFirmCr'
      '    left join Mnn on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = Core.productid) '
      '      and (Core.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      '    left JOIN Synonyms ON Core.SynonymCode=Synonyms.SynonymCode'
      
        '    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFir' +
        'mCr.SynonymFirmCrCode'
      
        '    LEFT JOIN CurrentOrderLists osbc ON osbc.clientid = :ClientI' +
        'd and osbc.CoreId=Core.CoreId'
      
        '    left join DelayOfPayments dop on (dop.PriceCode = PricesData' +
        '.PriceCode) and (dop.DayOfWeek = :DayOfWeek) '
      
        '    LEFT JOIN CurrentOrderHeads ON osbc.OrderId=CurrentOrderHead' +
        's.OrderId and CurrentOrderHeads.Frozen = 0 '
      'WHERE'
      '    (Core.productid > 0)'
      'and (Core.Junk = 1)')
    BeforeUpdateExecute = BeforeUpdateExecuteForClientID
    RefreshOptions = [roAfterUpdate]
    BeforePost = adsExpireds2BeforePost
    AfterPost = adsExpireds2AfterPost
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
      end
      item
        DataType = ftUnknown
        Name = 'DayOfWeek'
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
      Size = 100
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
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsExpiredsRealCost: TFloatField
      FieldName = 'RealCost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsExpiredsSupplierPriceMarkup: TFloatField
      FieldName = 'SupplierPriceMarkup'
    end
    object adsExpiredsProducerCost: TFloatField
      FieldName = 'ProducerCost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsExpiredsNDS: TSmallintField
      FieldName = 'NDS'
    end
    object adsExpiredsMnnId: TLargeintField
      FieldName = 'MnnId'
    end
    object adsExpiredsMnn: TStringField
      FieldName = 'Mnn'
      Size = 250
    end
    object adsExpiredsDescriptionId: TLargeintField
      FieldName = 'DescriptionId'
    end
    object adsExpiredsCatalogVitallyImportant: TBooleanField
      FieldName = 'CatalogVitallyImportant'
    end
    object adsExpiredsCatalogMandatoryList: TBooleanField
      FieldName = 'CatalogMandatoryList'
    end
    object adsExpiredsMaxProducerCost: TFloatField
      FieldName = 'MaxProducerCost'
    end
    object adsExpiredsBuyingMatrixType: TIntegerField
      FieldName = 'BuyingMatrixType'
    end
    object adsExpiredsProducerName: TStringField
      FieldName = 'ProducerName'
    end
    object adsExpiredsRetailVitallyImportant: TBooleanField
      FieldName = 'RetailVitallyImportant'
    end
    object adsExpiredsMarkup: TFloatField
      FieldName = 'Markup'
    end
    object adsExpiredsExp: TDateField
      FieldName = 'Exp'
    end
  end
end
