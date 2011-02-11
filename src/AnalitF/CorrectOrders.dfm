inherited CorrectOrdersForm: TCorrectOrdersForm
  Left = 255
  Top = 174
  Width = 868
  Height = 444
  ActiveControl = dbgLog
  Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1099#1093' '#1079#1072#1082#1072#1079#1086#1074
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pBottom: TPanel
    Left = 0
    Top = 365
    Width = 852
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnClose: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 1
      TabOrder = 0
    end
    object btnSaveReport: TButton
      Left = 104
      Top = 8
      Width = 121
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1086#1090#1095#1077#1090
      TabOrder = 1
      OnClick = btnSaveReportClick
    end
    object btnRetrySend: TButton
      Left = 240
      Top = 8
      Width = 129
      Height = 25
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1082#1072#1082' '#1077#1089#1090#1100
      ModalResult = 4
      TabOrder = 2
      OnClick = btnRetrySendClick
    end
    object btnRefresh: TButton
      Left = 384
      Top = 8
      Width = 129
      Height = 25
      Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ModalResult = 5
      TabOrder = 3
      OnClick = btnRefreshClick
    end
    object btnEditOrders: TButton
      Left = 528
      Top = 8
      Width = 145
      Height = 25
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1082#1072#1079#1099
      ModalResult = 7
      TabOrder = 4
      OnClick = btnEditOrdersClick
    end
  end
  object pClient: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 365
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 1
      Top = 185
      Width = 850
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object dbgCore: TToughDBGrid
      Tag = 32
      Left = 1
      Top = 188
      Width = 850
      Height = 176
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
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnExit = dbgCoreExit
      OnGetCellParams = dbgCoreGetCellParams
      OnKeyDown = dbgCoreKeyDown
      InputField = 'OrderCount'
      SearchPosition = spTop
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SynonymName'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
          Width = 196
        end
        item
          EditButtons = <>
          FieldName = 'SynonymFirm'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Width = 85
        end
        item
          EditButtons = <>
          FieldName = 'Volume'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Width = 63
        end
        item
          EditButtons = <>
          FieldName = 'Note'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Width = 69
        end
        item
          EditButtons = <>
          FieldName = 'doc'
          Footers = <>
          Title.Caption = #1044#1086#1082#1091#1084#1077#1085#1090
          Visible = False
        end
        item
          Alignment = taCenter
          EditButtons = <>
          FieldName = 'Period'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
          Width = 85
        end
        item
          EditButtons = <>
          FieldName = 'PriceName'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Width = 85
        end
        item
          EditButtons = <>
          FieldName = 'RegionName'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Visible = False
          Width = 72
        end
        item
          Alignment = taCenter
          Checkboxes = False
          EditButtons = <>
          FieldName = 'Storage'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1057#1082#1083#1072#1076
          Visible = False
          Width = 37
        end
        item
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'DatePrice'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Width = 103
        end
        item
          EditButtons = <>
          FieldName = 'registrycost'
          Footers = <>
          Title.Caption = #1056#1077#1077#1089#1090#1088'. '#1094#1077#1085#1072
        end
        item
          EditButtons = <>
          FieldName = 'requestratio'
          Footers = <>
          Title.Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
        end
        item
          EditButtons = <>
          FieldName = 'ordercost'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072
        end
        item
          EditButtons = <>
          FieldName = 'minordercount'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086
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
          MinWidth = 5
          Title.Caption = #1062#1077#1085#1072
          Width = 55
        end
        item
          EditButtons = <>
          FieldName = 'PriceRet'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
          Width = 62
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Quantity'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          Width = 68
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'OrderCount'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1047#1072#1082#1072#1079
          Width = 47
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1057#1091#1084#1084#1072
          Width = 70
        end>
    end
    object pTop: TPanel
      Left = 1
      Top = 1
      Width = 850
      Height = 184
      Align = alTop
      TabOrder = 1
      object pLog: TPanel
        Left = 1
        Top = 1
        Width = 848
        Height = 143
        Align = alClient
        TabOrder = 0
        object dbgLog: TToughDBGrid
          Tag = 32
          Left = 1
          Top = 1
          Width = 846
          Height = 141
          Align = alClient
          AutoFitColWidths = True
          DataSource = dsLog
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawColumnCell = dbgLogDrawColumnCell
          OnGetCellParams = dbgLogGetCellParams
          OnKeyDown = dbgLogKeyDown
          SearchPosition = spTop
          Columns = <
            item
              EditButtons = <>
              FieldName = 'NodeName'
              Footers = <>
              MinWidth = 5
              ReadOnly = True
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 330
            end
            item
              Alignment = taCenter
              Checkboxes = True
              EditButtons = <>
              FieldName = 'Send'
              Footers = <>
              MinWidth = 5
              Title.Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
              Width = 30
            end
            item
              EditButtons = <>
              FieldName = 'SynonymFirm'
              Footers = <>
              MinWidth = 5
              ReadOnly = True
              Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
              Width = 330
            end
            item
              EditButtons = <>
              FieldName = 'OldOrderCount'
              Footers = <>
              MinWidth = 5
              ReadOnly = True
              Title.Caption = #1057#1090#1072#1088#1086#1077' '#1082#1086#1083'-'#1074#1086
              Width = 35
            end
            item
              EditButtons = <>
              FieldName = 'NewOrderCount'
              Footers = <>
              MinWidth = 5
              ReadOnly = True
              Title.Caption = #1053#1086#1074#1086#1077' '#1082#1086#1083'-'#1074#1086
              Width = 35
            end
            item
              EditButtons = <>
              FieldName = 'OldPrice'
              Footers = <>
              MinWidth = 5
              ReadOnly = True
              Title.Caption = #1057#1090#1072#1088#1072#1103' '#1094#1077#1085#1072
              Width = 35
            end
            item
              EditButtons = <>
              FieldName = 'NewPrice'
              Footers = <>
              MinWidth = 5
              ReadOnly = True
              Title.Caption = #1053#1086#1074#1072#1103' '#1094#1077#1085#1072
              Width = 35
            end>
        end
      end
      object gbCorrectMessage: TGroupBox
        Left = 1
        Top = 144
        Width = 848
        Height = 39
        Align = alBottom
        Caption = ' '#1055#1088#1080#1095#1080#1085#1072' '
        TabOrder = 1
        object dbmCorrectMessage: TDBMemo
          Left = 2
          Top = 15
          Width = 844
          Height = 22
          Align = alClient
          DataField = 'Reason'
          DataSource = dsLog
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
  end
  object plOverCost: TPanel
    Left = 66
    Top = 186
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
  object MyScript1: TMyScript
    Left = 200
    Top = 184
  end
  object dsOrders: TDataSource
    Left = 112
    Top = 184
  end
  object dsCore: TDataSource
    DataSet = adsCore
    Left = 304
    Top = 200
  end
  object adsCore: TMyQuery
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
      'SELECT'
      '    Core.CoreId,'
      '    Core.PriceCode,'
      '    Core.RegionCode,'
      '    Core.ProductID,'
      '    catalogs.FullCode AS FullCode,'
      '    catalogs.shortcode,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    Core.CodeFirmCr,'
      '    Core.SynonymCode,'
      '    Core.SynonymFirmCrCode,'
      '    Core.Code,'
      '    Core.CodeCr,'
      '    Core.Period,'
      '    Core.Volume,'
      '    Core.Note,'
      '    Core.Cost as RealCost,'
      
        '    if(dop.Percent is null, Core.Cost, cast(Core.Cost * (1 + dop' +
        '.Percent/100) as decimal(18, 2))) as Cost,'
      '    Core.Quantity,'
      '    Core.Await,'
      '    Core.Junk,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    Core.OrderCost,'
      '    Core.MinOrderCount,'
      '    Core.ProducerCost,'
      '    Core.NDS,'
      '    Core.SupplierPriceMarkup,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName ,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      
        '    PricesData.DatePrice + interval  -:TimeZoneBias minute AS Da' +
        'tePrice,'
      '    PricesData.PriceName,'
      '    PRD.Enabled AS PriceEnabled,'
      '    Providers.FirmCode AS FirmCode,'
      '    PRD.Storage,'
      '    Regions.RegionName,'
      '    osbc.CoreId AS OrdersCoreId,'
      '    osbc.OrderId AS OrdersOrderId,'
      '    osbc.ClientId AS OrdersClientId,'
      '    catalogs.FullCode AS OrdersFullCode,'
      '    osbc.CodeFirmCr AS OrdersCodeFirmCr,'
      '    osbc.SynonymCode AS OrdersSynonymCode,'
      '    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,'
      '    osbc.Code AS OrdersCode,'
      '    osbc.CodeCr AS OrdersCodeCr,'
      '    osbc.OrderCount,'
      '    osbc.SynonymName AS OrdersSynonym,'
      '    osbc.SynonymFirm AS OrdersSynonymFirm,'
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
      '    Synonyms'
      '    inner join Core on (Core.SynonymCode = Synonyms.synonymcode)'
      '    left join Producers on Producers.Id = Core.CodeFirmCr'
      '    left join products on products.productid = core.productid'
      '    left join catalogs on catalogs.fullcode = products.catalogid'
      '    left join Mnn on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = Core.productid) '
      '      and (Core.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      
        '    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFir' +
        'mCr.SynonymFirmCrCode'
      '    LEFT JOIN PricesData ON Core.PriceCode=PricesData.PriceCode'
      
        '    LEFT JOIN PricesRegionalData PRD ON (Core.RegionCode=PRD.Reg' +
        'ionCode) AND (Core.PriceCode=PRD.PriceCode)'
      
        '    LEFT JOIN Providers ON PricesData.FirmCode=Providers.FirmCod' +
        'e'
      '    LEFT JOIN Regions ON Core.RegionCode=Regions.RegionCode'
      
        '    LEFT JOIN CurrentOrderLists osbc ON osbc.clientid = :clienti' +
        'd and osbc.CoreId = Core.CoreId'
      
        '    left join DelayOfPayments dop on (dop.FirmCode = Providers.F' +
        'irmCode) '
      
        '    LEFT JOIN CurrentOrderHeads ON osbc.OrderId=CurrentOrderHead' +
        's.OrderId and CurrentOrderHeads.Frozen = 0 '
      'WHERE '
      '  Core.CoreID = :CoreId')
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    Core.CoreId,'
      '    Core.PriceCode,'
      '    Core.RegionCode,'
      '    Core.productid,'
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    Core.CodeFirmCr,'
      '    Core.SynonymCode,'
      '    Core.SynonymFirmCrCode,'
      '    Core.Code,'
      '    Core.CodeCr,'
      '    Core.Period,'
      '    Core.Volume,'
      '    Core.Note,'
      '    Core.Cost as RealCost,'
      
        '    if(dop.Percent is null, Core.Cost, cast(Core.Cost * (1 + dop' +
        '.Percent/100) as decimal(18, 2))) as Cost,'
      '    Core.Quantity,'
      '    Core.Await,'
      '    Core.Junk,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    Core.ProducerCost,'
      '    Core.NDS,'
      '    core.SupplierPriceMarkup,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      
        '    if(PricesData.DatePrice IS NOT NULL, PricesData.DatePrice + ' +
        'interval -:timezonebias minute, null) AS DatePrice,'
      '    PricesData.PriceName,'
      '    PRD.Enabled AS PriceEnabled,'
      '    Providers.FirmCode AS FirmCode,'
      '    PRD.Storage,'
      '    Regions.RegionName,'
      '    osbc.Id as OrderListId,'
      '    osbc.CoreId AS OrdersCoreId,'
      '    osbc.OrderId AS OrdersOrderId,'
      '    osbc.ClientId AS OrdersClientId,'
      '    catalogs.fullcode AS OrdersFullCode,'
      '    osbc.CodeFirmCr AS OrdersCodeFirmCr,'
      '    osbc.SynonymCode AS OrdersSynonymCode,'
      '    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,'
      '    osbc.Code AS OrdersCode,'
      '    osbc.CodeCr AS OrdersCodeCr,'
      '    osbc.OrderCount,'
      '    osbc.SynonymName AS OrdersSynonym,'
      '    osbc.SynonymFirm AS OrdersSynonymFirm,'
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
      '    products'
      
        '    inner join Catalogs on catalogs.fullcode = products.catalogi' +
        'd'
      '    left JOIN Core ON Core.productid = products.productid'
      '    left join Producers on Producers.Id = Core.CodeFirmCr'
      '    left join Mnn on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = Core.productid) '
      '      and (Core.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      '    left join Synonyms on Core.SynonymCode=Synonyms.SynonymCode'
      
        '    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFir' +
        'mCr.SynonymFirmCrCode'
      '    LEFT JOIN PricesData ON Core.PriceCode=PricesData.PriceCode'
      
        '    LEFT JOIN PricesRegionalData PRD ON (Core.RegionCode=PRD.Reg' +
        'ionCode)'
      '        AND (Core.PriceCode=PRD.PriceCode)'
      
        '    LEFT JOIN Providers ON PricesData.FirmCode=Providers.FirmCod' +
        'e'
      '    LEFT JOIN Regions ON Core.RegionCode=Regions.RegionCode'
      
        '    LEFT JOIN CurrentOrderLists osbc ON osbc.clientid = :clienti' +
        'd and osbc.CoreId = Core.CoreId'
      
        '    left join DelayOfPayments dop on (dop.FirmCode = Providers.F' +
        'irmCode) '
      
        '    LEFT JOIN CurrentOrderHeads ON CurrentOrderHeads.OrderId = o' +
        'sbc.OrderId and CurrentOrderHeads.Frozen = 0 '
      'WHERE '
      '    (products.ProductId = :ProductId)'
      'and (Core.coreid is not null)'
      'order by Cost')
    BeforeUpdateExecute = adsCoreBeforeUpdateExecute
    RefreshOptions = [roAfterUpdate]
    BeforePost = adsCoreBeforePost
    AfterPost = adsCoreAfterPost
    BeforeScroll = adsCoreBeforeScroll
    OnCalcFields = adsCoreCalcFields
    Options.StrictUpdate = False
    Left = 248
    Top = 205
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TimeZoneBias'
      end
      item
        DataType = ftUnknown
        Name = 'clientid'
      end
      item
        DataType = ftUnknown
        Name = 'ProductId'
      end>
    object adsCoreCoreId: TLargeintField
      FieldName = 'CoreId'
    end
    object adsCorePriceCode: TLargeintField
      FieldName = 'PriceCode'
    end
    object adsCoreRegionCode: TLargeintField
      FieldName = 'RegionCode'
    end
    object adsCoreproductid: TLargeintField
      FieldName = 'productid'
    end
    object adsCorefullcode: TLargeintField
      FieldName = 'fullcode'
    end
    object adsCoreshortcode: TLargeintField
      FieldName = 'shortcode'
    end
    object adsCoreCodeFirmCr: TLargeintField
      FieldName = 'CodeFirmCr'
    end
    object adsCoreSynonymCode: TLargeintField
      FieldName = 'SynonymCode'
    end
    object adsCoreSynonymFirmCrCode: TLargeintField
      FieldName = 'SynonymFirmCrCode'
    end
    object adsCoreCode: TStringField
      FieldName = 'Code'
      Size = 84
    end
    object adsCoreCodeCr: TStringField
      FieldName = 'CodeCr'
      Size = 84
    end
    object adsCorePeriod: TStringField
      FieldName = 'Period'
    end
    object adsCoreVolume: TStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsCoreNote: TStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsCoreCost: TFloatField
      FieldName = 'Cost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCoreQuantity: TStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsCoreAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsCoreJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsCoredoc: TStringField
      FieldName = 'doc'
    end
    object adsCoreregistrycost: TFloatField
      FieldName = 'registrycost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCorevitallyimportant: TBooleanField
      FieldName = 'vitallyimportant'
    end
    object adsCorerequestratio: TIntegerField
      FieldName = 'requestratio'
      DisplayFormat = '#'
    end
    object adsCoreordercost: TFloatField
      FieldName = 'ordercost'
    end
    object adsCoreminordercount: TIntegerField
      FieldName = 'minordercount'
    end
    object adsCoreSynonymName: TStringField
      FieldName = 'SynonymName'
      Size = 501
    end
    object adsCoreSynonymFirm: TStringField
      FieldName = 'SynonymFirm'
      Size = 250
    end
    object adsCoreDatePrice: TDateTimeField
      FieldName = 'DatePrice'
    end
    object adsCorePriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsCorePriceEnabled: TBooleanField
      FieldName = 'PriceEnabled'
    end
    object adsCoreFirmCode: TLargeintField
      FieldName = 'FirmCode'
    end
    object adsCoreStorage: TBooleanField
      FieldName = 'Storage'
    end
    object adsCoreRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsCoreOrderListId: TLargeintField
      FieldName = 'OrderListId'
    end
    object adsCoreOrdersCoreId: TLargeintField
      FieldName = 'OrdersCoreId'
    end
    object adsCoreOrdersOrderId: TLargeintField
      FieldName = 'OrdersOrderId'
    end
    object adsCoreOrdersClientId: TLargeintField
      FieldName = 'OrdersClientId'
    end
    object adsCoreOrdersFullCode: TLargeintField
      FieldName = 'OrdersFullCode'
    end
    object adsCoreOrdersCodeFirmCr: TLargeintField
      FieldName = 'OrdersCodeFirmCr'
    end
    object adsCoreOrdersSynonymCode: TLargeintField
      FieldName = 'OrdersSynonymCode'
    end
    object adsCoreOrdersSynonymFirmCrCode: TLargeintField
      FieldName = 'OrdersSynonymFirmCrCode'
    end
    object adsCoreOrdersCode: TStringField
      FieldName = 'OrdersCode'
      Size = 84
    end
    object adsCoreOrdersCodeCr: TStringField
      FieldName = 'OrdersCodeCr'
      Size = 84
    end
    object adsCoreOrderCount: TIntegerField
      FieldName = 'OrderCount'
      DisplayFormat = '#'
    end
    object adsCoreOrdersSynonym: TStringField
      FieldName = 'OrdersSynonym'
      Size = 250
    end
    object adsCoreOrdersSynonymFirm: TStringField
      FieldName = 'OrdersSynonymFirm'
      Size = 250
    end
    object adsCoreOrdersPrice: TFloatField
      FieldName = 'OrdersPrice'
    end
    object adsCoreSumOrder: TFloatField
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCoreOrdersJunk: TBooleanField
      FieldName = 'OrdersJunk'
    end
    object adsCoreOrdersAwait: TBooleanField
      FieldName = 'OrdersAwait'
    end
    object adsCoreOrdersHOrderId: TLargeintField
      FieldName = 'OrdersHOrderId'
    end
    object adsCoreOrdersHClientId: TLargeintField
      FieldName = 'OrdersHClientId'
    end
    object adsCoreOrdersHPriceCode: TLargeintField
      FieldName = 'OrdersHPriceCode'
    end
    object adsCoreOrdersHRegionCode: TLargeintField
      FieldName = 'OrdersHRegionCode'
    end
    object adsCoreOrdersHPriceName: TStringField
      FieldName = 'OrdersHPriceName'
      Size = 70
    end
    object adsCoreOrdersHRegionName: TStringField
      FieldName = 'OrdersHRegionName'
      Size = 25
    end
    object adsCorePriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      Calculated = True
    end
    object adsCoreRealCost: TFloatField
      FieldName = 'RealCost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCoreSupplierPriceMarkup: TFloatField
      FieldName = 'SupplierPriceMarkup'
    end
    object adsCoreProducerCost: TFloatField
      FieldName = 'ProducerCost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCoreNDS: TSmallintField
      FieldName = 'NDS'
    end
    object adsCoreMnnId: TLargeintField
      FieldName = 'MnnId'
    end
    object adsCoreMnn: TStringField
      FieldName = 'Mnn'
      Size = 250
    end
    object adsCoreMaxProducerCost: TFloatField
      FieldName = 'MaxProducerCost'
    end
    object adsCoreProducerName: TStringField
      FieldName = 'ProducerName'
    end
    object adsCoreCatalogVitallyImportant: TBooleanField
      FieldName = 'CatalogVitallyImportant'
    end
  end
  object mdValues: TRxMemoryData
    FieldDefs = <>
    Left = 400
    Top = 208
    object mdValuesParametrName: TStringField
      FieldName = 'ParametrName'
    end
    object mdValuesOldValue: TStringField
      DisplayLabel = #1057#1090#1072#1088#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      FieldName = 'OldValue'
    end
    object mdValuesNewValue: TStringField
      DisplayLabel = #1053#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      FieldName = 'NewValue'
    end
  end
  object dsValues: TDataSource
    DataSet = mdValues
    Left = 368
    Top = 216
  end
  object OverCostHideTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = OverCostHideTimerTimer
    Left = 32
    Top = 192
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
    MasterSource = dsCore
    MasterFields = 'ProductID'
    DetailFields = 'PRODUCTID'
    Left = 300
    Top = 244
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CLIENTID'
      end
      item
        DataType = ftUnknown
        Name = 'ProductID'
      end>
    object adsAvgOrdersPRICEAVG: TFloatField
      FieldName = 'PRICEAVG'
    end
    object adsAvgOrdersPRODUCTID: TLargeintField
      FieldName = 'PRODUCTID'
    end
  end
  object tCheckVolume: TTimer
    Enabled = False
    Interval = 750
    OnTimer = tCheckVolumeTimer
    Left = 40
    Top = 56
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099' (*.txt)|*.txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofOverwritePrompt, ofPathMustExist, ofEnableSizing]
    Left = 224
    Top = 104
  end
  object mtLog: TMemTableEh
    Active = True
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftLargeint
      end
      item
        Name = 'ParentId'
        DataType = ftLargeint
      end
      item
        Name = 'NodeName'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Send'
        DataType = ftBoolean
      end
      item
        Name = 'SynonymFirm'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'OldOrderCount'
        DataType = ftInteger
      end
      item
        Name = 'NewOrderCount'
        DataType = ftInteger
      end
      item
        Name = 'OldPrice'
        DataType = ftCurrency
      end
      item
        Name = 'NewPrice'
        DataType = ftCurrency
      end
      item
        Name = 'Reason'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'SelfId'
        DataType = ftLargeint
      end
      item
        Name = 'NodeType'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    TreeList.KeyFieldName = 'Id'
    TreeList.RefParentFieldName = 'ParentId'
    TreeList.DefaultNodeExpanded = True
    AfterScroll = mtLogAfterScroll
    Left = 362
    Top = 74
    object mtLogId: TLargeintField
      DisplayWidth = 15
      FieldName = 'Id'
    end
    object mtLogParentId: TLargeintField
      DisplayWidth = 15
      FieldName = 'ParentId'
    end
    object mtLogNodeName: TStringField
      FieldName = 'NodeName'
      Size = 255
    end
    object mtLogSend: TBooleanField
      DisplayWidth = 5
      FieldName = 'Send'
    end
    object mtLogSynonymFirm: TStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object mtLogOldOrderCount: TIntegerField
      DisplayWidth = 10
      FieldName = 'OldOrderCount'
    end
    object mtLogNewOrderCount: TIntegerField
      DisplayWidth = 10
      FieldName = 'NewOrderCount'
    end
    object mtLogOldPrice: TCurrencyField
      DisplayWidth = 10
      FieldName = 'OldPrice'
    end
    object mtLogNewPrice: TCurrencyField
      DisplayWidth = 10
      FieldName = 'NewPrice'
    end
    object mtLogReason: TStringField
      FieldName = 'Reason'
      Size = 255
    end
    object mtLogSelfId: TLargeintField
      FieldName = 'SelfId'
    end
    object mtLogNodeType: TIntegerField
      FieldName = 'NodeType'
    end
    object MemTableData: TMemTableDataEh
      object DataStruct: TMTDataStructEh
        object Id: TMTNumericDataFieldEh
          FieldName = 'Id'
          NumericDataType = fdtLargeintEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object ParentId: TMTNumericDataFieldEh
          FieldName = 'ParentId'
          NumericDataType = fdtLargeintEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object NodeName: TMTStringDataFieldEh
          FieldName = 'NodeName'
          StringDataType = fdtStringEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          Size = 255
          Transliterate = False
        end
        object Send: TMTBooleanDataFieldEh
          FieldName = 'Send'
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
        end
        object SynonymFirm: TMTStringDataFieldEh
          FieldName = 'SynonymFirm'
          StringDataType = fdtStringEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          Size = 255
          Transliterate = False
        end
        object OldOrderCount: TMTNumericDataFieldEh
          FieldName = 'OldOrderCount'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object NewOrderCount: TMTNumericDataFieldEh
          FieldName = 'NewOrderCount'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object OldPrice: TMTNumericDataFieldEh
          FieldName = 'OldPrice'
          NumericDataType = fdtCurrencyEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object NewPrice: TMTNumericDataFieldEh
          FieldName = 'NewPrice'
          NumericDataType = fdtCurrencyEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object Reason: TMTStringDataFieldEh
          FieldName = 'Reason'
          StringDataType = fdtStringEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          Size = 255
          Transliterate = False
        end
        object SelfId: TMTNumericDataFieldEh
          FieldName = 'SelfId'
          NumericDataType = fdtLargeintEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
        object NodeType: TMTNumericDataFieldEh
          FieldName = 'NodeType'
          NumericDataType = fdtIntegerEh
          Alignment = taLeftJustify
          DisplayWidth = 0
          Required = False
          Visible = False
          currency = False
          Precision = 0
        end
      end
      object RecordsList: TRecordsListEh
      end
    end
  end
  object dsLog: TDataSource
    DataSet = mtLog
    Left = 394
    Top = 74
  end
end
