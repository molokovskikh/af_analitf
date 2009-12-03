inherited CorrectOrdersForm: TCorrectOrdersForm
  Left = 255
  Top = 174
  Height = 384
  ActiveControl = tvList
  Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1099#1093' '#1079#1072#1082#1072#1079#1086#1074
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pBottom: TPanel
    Left = 0
    Top = 315
    Width = 643
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
    object btnGoToReport: TButton
      Left = 104
      Top = 8
      Width = 121
      Height = 25
      Caption = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1086#1090#1095#1077#1090#1091
      ModalResult = 6
      TabOrder = 1
    end
  end
  object pClient: TPanel
    Left = 0
    Top = 0
    Width = 643
    Height = 315
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 1
      Top = 185
      Width = 641
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object dbgCore: TToughDBGrid
      Tag = 32
      Left = 1
      Top = 188
      Width = 641
      Height = 126
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
      Width = 641
      Height = 184
      Align = alTop
      TabOrder = 1
      object Splitter2: TSplitter
        Left = 268
        Top = 1
        Height = 182
        Align = alRight
      end
      object pRight: TPanel
        Left = 271
        Top = 1
        Width = 369
        Height = 182
        Align = alRight
        TabOrder = 1
        object lReason: TLabel
          Left = 8
          Top = 8
          Width = 49
          Height = 13
          Caption = #1055#1088#1080#1095#1080#1085#1072' :'
        end
        object dbtReason: TDBText
          Left = 16
          Top = 24
          Width = 337
          Height = 57
          DataField = 'Reason'
          DataSource = dsOrders
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object dbgValues: TToughDBGrid
          Tag = 32
          Left = 1
          Top = 88
          Width = 367
          Height = 81
          AutoFitColWidths = True
          DataSource = dsValues
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          FrozenCols = 1
          Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghFrozen3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnGetCellParams = dbgValuesGetCellParams
          SearchPosition = spTop
          Columns = <
            item
              EditButtons = <>
              FieldName = 'ParametrName'
              Footers = <>
            end
            item
              EditButtons = <>
              FieldName = 'OldValue'
              Footers = <>
            end
            item
              EditButtons = <>
              FieldName = 'NewValue'
              Footers = <>
            end>
        end
      end
      object tvList: TTreeView
        Left = 1
        Top = 1
        Width = 267
        Height = 182
        Align = alClient
        ChangeDelay = 300
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        OnChange = tvListChange
        OnKeyDown = tvListKeyDown
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
      '  orderslist'
      'set'
      '  OrderCount = :ORDERCOUNT'
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
      '    OrdersHead.OrderId AS OrdersHOrderId,'
      '    OrdersHead.ClientId AS OrdersHClientId,'
      '    OrdersHead.PriceCode AS OrdersHPriceCode,'
      '    OrdersHead.RegionCode AS OrdersHRegionCode,'
      '    OrdersHead.PriceName AS OrdersHPriceName,'
      '    OrdersHead.RegionName AS OrdersHRegionName'
      'FROM'
      '    Synonyms'
      '    inner join Core on (Core.SynonymCode = Synonyms.synonymcode)'
      '    left join products on products.productid = core.productid'
      '    left join catalogs on catalogs.fullcode = products.catalogid'
      
        '    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFir' +
        'mCr.SynonymFirmCrCode'
      '    LEFT JOIN PricesData ON Core.PriceCode=PricesData.PriceCode'
      
        '    LEFT JOIN PricesRegionalData PRD ON (Core.RegionCode=PRD.Reg' +
        'ionCode) AND (Core.PriceCode=PRD.PriceCode)'
      
        '    LEFT JOIN Providers ON PricesData.FirmCode=Providers.FirmCod' +
        'e'
      '    LEFT JOIN Regions ON Core.RegionCode=Regions.RegionCode'
      
        '    LEFT JOIN OrdersList osbc ON osbc.clientid = :clientid and o' +
        'sbc.CoreId = Core.CoreId'
      
        '    left join DelayOfPayments dop on (dop.FirmCode = Providers.F' +
        'irmCode) '
      '    LEFT JOIN OrdersHead ON osbc.OrderId=OrdersHead.OrderId'
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
      '    OrdersHead.OrderId AS OrdersHOrderId,'
      '    OrdersHead.ClientId AS OrdersHClientId,'
      '    OrdersHead.PriceCode AS OrdersHPriceCode,'
      '    OrdersHead.RegionCode AS OrdersHRegionCode,'
      '    OrdersHead.PriceName AS OrdersHPriceName,'
      '    OrdersHead.RegionName AS OrdersHRegionName'
      'FROM'
      '    products'
      
        '    inner join Catalogs on catalogs.fullcode = products.catalogi' +
        'd'
      '    left JOIN Core ON Core.productid = products.productid'
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
      
        '    LEFT JOIN OrdersList osbc ON osbc.clientid = :clientid and o' +
        'sbc.CoreId = Core.CoreId'
      
        '    left join DelayOfPayments dop on (dop.FirmCode = Providers.F' +
        'irmCode) '
      '    LEFT JOIN OrdersHead ON OrdersHead.OrderId = osbc.OrderId'
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
end
