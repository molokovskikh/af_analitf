object CoreForm: TCoreForm
  Left = 256
  Top = 184
  Align = alClient
  BorderIcons = []
  BorderStyle = bsNone
  Caption = #1057#1074#1086#1076#1085#1099#1081' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090
  ClientHeight = 573
  ClientWidth = 792
  Color = clBtnFace
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pBottom: TPanel
    Left = 0
    Top = 442
    Width = 792
    Height = 131
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object gbPrevOrders: TGroupBox
      Left = 0
      Top = 0
      Width = 480
      Height = 131
      Align = alLeft
      Caption = ' '#1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1079#1072#1082#1072#1079#1099' '
      Constraints.MinWidth = 480
      TabOrder = 0
      DesignSize = (
        480
        131)
      object lblPriceAvg: TLabel
        Left = 8
        Top = 110
        Width = 285
        Height = 13
        Caption = #1057#1088#1077#1076#1085#1080#1077' '#1094#1077#1085#1072'/'#1079#1072#1082#1072#1079' '#1087#1086' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1084' '#1079#1072#1082#1072#1079#1072#1084' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtPriceAvg: TDBText
        Left = 293
        Top = 110
        Width = 70
        Height = 13
        AutoSize = True
        DataField = 'PRICEAVG'
        DataSource = dsAvgOrders
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lDiveder: TLabel
        Left = 366
        Top = 110
        Width = 7
        Height = 13
        Caption = '/'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtOrderCountAvg: TDBText
        Left = 377
        Top = 110
        Width = 105
        Height = 13
        AutoSize = True
        DataField = 'OrderCountAvg'
        DataSource = dsAvgOrders
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbgHistory: TToughDBGrid
        Left = 8
        Top = 16
        Width = 463
        Height = 87
        Anchors = [akLeft, akTop, akRight]
        AutoFitColWidths = True
        DataSource = dsPreviosOrders
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
        OnGetCellParams = dbgHistoryGetCellParams
        SearchPosition = spBottom
        Columns = <
          item
            EditButtons = <>
            FieldName = 'PriceName'
            Footers = <>
            Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
            Width = 110
          end
          item
            EditButtons = <>
            FieldName = 'SynonymFirm'
            Footers = <>
            Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            Width = 102
          end
          item
            EditButtons = <>
            FieldName = 'Period'
            Footers = <>
            Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
          end
          item
            EditButtons = <>
            FieldName = 'OrderCount'
            Footers = <>
            Title.Caption = #1047#1072#1082#1072#1079
            Width = 38
          end
          item
            EditButtons = <>
            FieldName = 'Price'
            Footers = <>
            Title.Caption = #1062#1077#1085#1072
            Width = 49
          end
          item
            Alignment = taCenter
            DisplayFormat = 'dd.mm.yyyy'
            EditButtons = <>
            FieldName = 'OrderDate'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072
            Width = 68
          end>
      end
    end
    object gbFirmInfo: TGroupBox
      Left = 480
      Top = 0
      Width = 224
      Height = 131
      Align = alClient
      Caption = ' '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1077' '
      TabOrder = 1
      DesignSize = (
        224
        131)
      object lblSupportPhone: TLabel
        Left = 6
        Top = 16
        Width = 61
        Height = 13
        Caption = #1058#1077#1083#1077#1092#1086#1085' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtSupportPhone: TDBText
        Left = 73
        Top = 16
        Width = 99
        Height = 13
        AutoSize = True
        DataField = 'SupportPhone'
        DataSource = dsFirmsInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbmContactInfo: TDBMemo
        Left = 6
        Top = 32
        Width = 215
        Height = 93
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        DataField = 'OperativeInfo'
        DataSource = dsFirmsInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object pRight: TPanel
      Left = 704
      Top = 0
      Width = 88
      Height = 131
      Align = alRight
      TabOrder = 2
      object gbRetUpCost: TGroupBox
        Left = 1
        Top = 1
        Width = 86
        Height = 80
        Align = alClient
        Caption = ' '#1053#1072#1094#1077#1085#1082#1072' '
        TabOrder = 0
        object seRetUpCost: TSpinEdit
          Left = 8
          Top = 16
          Width = 73
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnChange = seRetUpCostChange
        end
        object eRetUpCost: TEdit
          Left = 8
          Top = 48
          Width = 73
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
      end
      object gbSum: TGroupBox
        Left = 1
        Top = 81
        Width = 86
        Height = 49
        Align = alBottom
        Caption = ' '#1057#1091#1084#1084#1072' '
        TabOrder = 1
        DesignSize = (
          86
          49)
        object lCurrentSumma: TLabel
          Left = 2
          Top = 18
          Width = 82
          Height = 13
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lCurrentSumma'
        end
      end
    end
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      792
      57)
    object lblName: TLabel
      Left = 7
      Top = 6
      Width = 59
      Height = 16
      Caption = 'lblName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnGotoCoreFirm: TSpeedButton
      Left = 264
      Top = 3
      Width = 107
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1042' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090' (F2)'
      Visible = False
    end
    object cbFilter: TComboBox
      Left = 646
      Top = 4
      Width = 143
      Height = 21
      Hint = #1054#1090#1073#1086#1088' '#1079#1072#1087#1080#1089#1077#1081
      Style = csDropDownList
      Anchors = [akTop, akRight]
      DropDownCount = 30
      ItemHeight = 13
      TabOrder = 0
      OnSelect = cbFilterSelect
    end
    object cbEnabled: TComboBox
      Left = 497
      Top = 4
      Width = 143
      Height = 21
      Hint = #1054#1090#1073#1086#1088' '#1079#1072#1087#1080#1089#1077#1081
      Style = csDropDownList
      Anchors = [akTop, akRight]
      DropDownCount = 30
      ItemHeight = 13
      TabOrder = 1
      OnSelect = cbFilterSelect
      Items.Strings = (
        #1042#1089#1077
        #1054#1089#1085#1086#1074#1085#1099#1077
        #1053#1077#1086#1089#1085#1086#1074#1085#1099#1077)
    end
    object btnGroupUngroup: TButton
      Left = 376
      Top = 3
      Width = 113
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1056#1072#1079#1075#1088#1091#1087#1087#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 2
      OnClick = btnGroupUngroupClick
    end
    object cbProducers: TComboBox
      Left = 376
      Top = 32
      Width = 412
      Height = 21
      Style = csDropDownList
      Anchors = [akRight]
      ItemHeight = 13
      TabOrder = 3
      OnCloseUp = cbProducersCloseUp
    end
  end
  object pCenter: TPanel
    Left = 0
    Top = 57
    Width = 792
    Height = 385
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object dbgCore: TToughDBGrid
      Tag = 16384
      Left = 0
      Top = 0
      Width = 792
      Height = 385
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
      ParentShowHint = False
      ReadOnly = True
      ShowHint = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnGetCellParams = dbgCoreGetCellParams
      OnKeyDown = dbgCoreKeyDown
      OnKeyPress = dbgCoreKeyPress
      InputField = 'OrderCount'
      SearchPosition = spTop
      OnCanInput = dbgCoreCanInput
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SynonymName'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
          Width = 177
        end
        item
          EditButtons = <>
          FieldName = 'SynonymFirm'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Width = 89
        end
        item
          EditButtons = <>
          FieldName = 'Volume'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Width = 33
        end
        item
          EditButtons = <>
          FieldName = 'Note'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Visible = False
          Width = 48
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
          Width = 56
        end
        item
          EditButtons = <>
          FieldName = 'PriceName'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Width = 74
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
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'DatePrice'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Width = 87
        end
        item
          EditButtons = <>
          FieldName = 'requestratio'
          Footers = <>
          Title.Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
          Visible = False
          Width = 61
        end
        item
          EditButtons = <>
          FieldName = 'ordercost'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'minordercount'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'PriceDelta'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1056#1072#1079#1085#1080#1094#1072', %'
          Visible = False
          Width = 26
        end
        item
          EditButtons = <>
          FieldName = 'registrycost'
          Footers = <>
          Title.Caption = #1056#1077#1077#1089#1090#1088'. '#1094#1077#1085#1072
          Visible = False
          Width = 46
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
          Width = 59
        end
        item
          EditButtons = <>
          FieldName = 'PriceRet'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
          Width = 48
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Quantity'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          Width = 39
        end
        item
          EditButtons = <>
          FieldName = 'OrdersComment'
          Footers = <>
          Title.Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'OrderCount'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1047#1072#1082#1072#1079
          Width = 34
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1057#1091#1084#1084#1072
          Width = 51
        end>
    end
  end
  object dsCore: TDataSource
    DataSet = adsCore
    Left = 64
    Top = 168
  end
  object dsPreviosOrders: TDataSource
    DataSet = adsPreviosOrders
    Left = 152
    Top = 408
  end
  object dsAvgOrders: TDataSource
    DataSet = adsAvgOrders
    Left = 328
    Top = 440
  end
  object dsFirmsInfo: TDataSource
    DataSet = adsFirmsInfo
    Left = 568
    Top = 424
  end
  object ActionList: TActionList
    Left = 304
    Top = 248
    object actFlipCore: TAction
      Caption = #1042' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090' (F2)'
      ShortCut = 113
      OnExecute = actFlipCoreExecute
    end
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
      'SELECT '
      '    Core.CoreId,'
      '    Core.PriceCode,'
      '    Core.RegionCode,'
      '    Core.productid,'
      '    catalogs.fullcode AS AFullCode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    Core.RetailVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    catalogs.NamePromotionsCount,'
      '    catalogs.Markup,'
      '    Core.CodeFirmCr,'
      '    Core.SynonymCode,'
      '    Core.SynonymFirmCrCode,'
      '    Core.Code,'
      '    Core.CodeCr,'
      '    Core.Period,'
      '    Core.Volume,'
      '    Core.Note,'
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
      '    Core.Await,'
      '    Core.Junk,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    core.ProducerCost,'
      '    core.NDS,'
      '    core.SupplierPriceMarkup,'
      '    core.BuyingMatrixType,'
      
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
      '    osbc.Comment AS OrdersComment,'
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
      '    Catalogs'
      
        '    inner join products on products.catalogid = catalogs.fullcod' +
        'e'
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
      
        '    left join DelayOfPayments dop on (dop.PriceCode = PricesData' +
        '.PriceCode) and (dop.DayOfWeek = :DayOfWeek) '
      
        '    LEFT JOIN CurrentOrderHeads ON CurrentOrderHeads.OrderId = o' +
        'sbc.OrderId and CurrentOrderHeads.Frozen = 0 '
      'WHERE '
      '  Core.CoreId = :CoreID')
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    Core.CoreId,'
      '    Core.PriceCode,'
      '    Core.RegionCode,'
      '    Core.productid,'
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    Core.RetailVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    catalogs.NamePromotionsCount,'
      '    catalogs.Markup,'
      '    Core.CodeFirmCr,'
      '    Core.SynonymCode,'
      '    Core.SynonymFirmCrCode,'
      '    Core.Code,'
      '    Core.CodeCr,'
      '    Core.Period,'
      '    Core.Volume,'
      '    Core.Note,'
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
      '    Core.Await,'
      '    Core.Junk,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    core.ProducerCost,'
      '    core.NDS,'
      '    core.SupplierPriceMarkup,'
      '    core.BuyingMatrixType,'
      
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
      '    osbc.Comment AS OrdersComment,'
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
      '    Catalogs'
      
        '    inner join products on products.catalogid = catalogs.fullcod' +
        'e'
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
      
        '    left join DelayOfPayments dop on (dop.PriceCode = PricesData' +
        '.PriceCode) and (dop.DayOfWeek = :DayOfWeek) '
      
        '    LEFT JOIN CurrentOrderHeads ON CurrentOrderHeads.OrderId = o' +
        'sbc.OrderId and CurrentOrderHeads.Frozen = 0 '
      'WHERE '
      '    (Catalogs.FullCode = :ParentCode)'
      'and (Core.coreid is not null)'
      'And ((:ShowRegister = 1) Or (Providers.FirmCode <> :RegisterId))')
    BeforeUpdateExecute = BeforeUpdateExecuteForClientID
    RefreshOptions = [roAfterUpdate]
    AfterOpen = adsCoreAfterOpen
    BeforeClose = adsCoreBeforeClose
    BeforeEdit = adsCore2BeforeEdit
    BeforePost = adsCore2BeforePost
    AfterPost = adsCore2AfterPost
    AfterScroll = adsCore2AfterScroll
    Left = 96
    Top = 141
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TIMEZONEBIAS'
      end
      item
        DataType = ftUnknown
        Name = 'clientid'
      end
      item
        DataType = ftUnknown
        Name = 'DayOfWeek'
      end
      item
        DataType = ftUnknown
        Name = 'PARENTCODE'
      end
      item
        DataType = ftUnknown
        Name = 'SHOWREGISTER'
      end
      item
        DataType = ftUnknown
        Name = 'REGISTERID'
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
      Size = 505
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
      OnGetText = adsCoreOldSTORAGEGetText
    end
    object adsCoreRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
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
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCorePriceDelta: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceDelta'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreSortOrder: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'SortOrder'
      Calculated = True
    end
    object adsCorefullcode: TLargeintField
      FieldName = 'fullcode'
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
    object adsCoreDescriptionId: TLargeintField
      FieldName = 'DescriptionId'
    end
    object adsCoreCatalogVitallyImportant: TBooleanField
      FieldName = 'CatalogVitallyImportant'
    end
    object adsCoreCatalogMandatoryList: TBooleanField
      FieldName = 'CatalogMandatoryList'
    end
    object adsCoreMaxProducerCost: TFloatField
      FieldName = 'MaxProducerCost'
    end
    object adsCoreBuyingMatrixType: TIntegerField
      FieldName = 'BuyingMatrixType'
    end
    object adsCoreProducerName: TStringField
      FieldName = 'ProducerName'
    end
    object adsCoreNamePromotionsCount: TIntegerField
      FieldName = 'NamePromotionsCount'
    end
    object adsCoreRetailVitallyImportant: TBooleanField
      FieldName = 'RetailVitallyImportant'
    end
    object adsCoreOrdersComment: TStringField
      FieldName = 'OrdersComment'
    end
    object adsCoreMarkup: TFloatField
      FieldName = 'Markup'
    end
  end
  object adsRegions: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '  Regions.RegionCode,'
      '  Regions.RegionName,'
      '  Regions.PriceRet'
      'FROM '
      '  Regions,'
      '  PricesRegionalData'
      'where'
      '  Regions.RegionCode = PricesRegionalData.RegionCode'
      'group by Regions.RegionCode')
    Left = 160
    Top = 205
  end
  object adsPreviosOrders: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      '#ORDERSSHOWBYFORM'
      'SELECT '
      '    products.catalogid as FullCode,'
      '    osbc.Code,'
      '    osbc.CodeCR,'
      '    osbc.SynonymName,'
      '    osbc.SynonymFirm,'
      '    osbc.OrderCount,'
      '    osbc.Price,'
      '    PostedOrderHeads.SendDate as OrderDate,'
      '    PostedOrderHeads.PriceName,'
      '    PostedOrderHeads.RegionName,'
      '    osbc.Await,'
      '    osbc.Junk,'
      '    osbc.Period'
      'FROM'
      '  PostedOrderLists osbc'
      '  inner join products on products.productid = osbc.productid'
      
        '  INNER JOIN PostedOrderHeads ON osbc.OrderId=PostedOrderHeads.O' +
        'rderId'
      'WHERE'
      '    (osbc.clientid = :ClientID)'
      'and (osbc.OrderCount > 0)'
      
        'and (((:GroupByProducts = 0) and (products.catalogid = :FullCode' +
        ')) or ((:GroupByProducts = 1) and (osbc.productid = :productid))' +
        ')'
      'And (PostedOrderHeads.Closed = 1)'
      'ORDER BY PostedOrderHeads.SendDate DESC'
      'limit 20')
    Left = 208
    Top = 389
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ClientID'
      end
      item
        DataType = ftUnknown
        Name = 'GroupByProducts'
      end
      item
        DataType = ftUnknown
        Name = 'FULLCODE'
      end
      item
        DataType = ftUnknown
        Name = 'GroupByProducts'
      end
      item
        DataType = ftUnknown
        Name = 'productid'
      end>
    object adsPreviosOrdersFullCode: TLargeintField
      FieldName = 'FullCode'
    end
    object adsPreviosOrdersCode: TStringField
      FieldName = 'Code'
      Size = 84
    end
    object adsPreviosOrdersCodeCR: TStringField
      FieldName = 'CodeCR'
      Size = 84
    end
    object adsPreviosOrdersSynonymName: TStringField
      FieldName = 'SynonymName'
      Size = 250
    end
    object adsPreviosOrdersSynonymFirm: TStringField
      FieldName = 'SynonymFirm'
      Size = 250
    end
    object adsPreviosOrdersOrderCount: TIntegerField
      FieldName = 'OrderCount'
    end
    object adsPreviosOrdersOrderDate: TDateTimeField
      FieldName = 'OrderDate'
    end
    object adsPreviosOrdersPriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsPreviosOrdersRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsPreviosOrdersPrice: TFloatField
      FieldName = 'Price'
    end
    object adsPreviosOrdersAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsPreviosOrdersJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsPreviosOrdersPeriod: TStringField
      FieldName = 'Period'
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
    MasterSource = dsCore
    MasterFields = 'productid'
    DetailFields = 'PRODUCTID'
    Left = 376
    Top = 453
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
      DisplayFormat = '0.00;;'#39#39
    end
    object adsAvgOrdersPRODUCTID: TLargeintField
      FieldName = 'PRODUCTID'
    end
    object adsAvgOrdersOrderCountAvg: TFloatField
      FieldName = 'OrderCountAvg'
      DisplayFormat = '0.00;;'#39#39
    end
  end
  object adsFirmsInfo: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '  RegionalData.FirmCode, '
      '  RegionalData.RegionCode, '
      '  RegionalData.SupportPhone, '
      '  RegionalData.OperativeInfo,'
      '  PricesRegionalData.MinReq '
      'FROM '
      '  RegionalData,'
      '  PricesRegionalData'
      'where'
      '    RegionalData.FirmCode = :FirmCode'
      'and RegionalData.RegionCode = :RegionCode'
      'and PricesRegionalData.RegionCode = RegionalData.RegionCode'
      'and PricesRegionalData.PriceCode = :PriceCode')
    MasterSource = dsCore
    Left = 618
    Top = 433
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'FirmCode'
      end
      item
        DataType = ftUnknown
        Name = 'RegionCode'
      end
      item
        DataType = ftUnknown
        Name = 'PriceCode'
      end>
  end
  object adsCoreEtalon: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    Core.CoreId,'
      '    Core.PriceCode,'
      '    Core.RegionCode,'
      '    Core.productid,'
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    Core.RetailVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    catalogs.NamePromotionsCount,'
      '    catalogs.Markup,'
      '    Core.CodeFirmCr,'
      '    Core.SynonymCode,'
      '    Core.SynonymFirmCrCode,'
      '    Core.Code,'
      '    Core.CodeCr,'
      '    Core.Period,'
      '    Core.Volume,'
      '    Core.Note,'
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
      '    Core.Await,'
      '    Core.Junk,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    core.ProducerCost,'
      '    core.NDS,'
      '    core.SupplierPriceMarkup,'
      '    core.BuyingMatrixType,'
      
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
      '    osbc.Comment AS OrdersComment,'
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
      '    Catalogs'
      
        '    inner join products on products.catalogid = catalogs.fullcod' +
        'e'
      '    left JOIN Core ON Core.productid = products.productid'
      '    left join Producers on Producers.Id = Core.CodeFirmCr'
      '    left join Mnn on mnn.Id = Catalogs.MnnId    '
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
      
        '    left join DelayOfPayments dop on (dop.PriceCode = PricesData' +
        '.PriceCode) and (dop.DayOfWeek = :DayOfWeek) '
      
        '    LEFT JOIN CurrentOrderHeads ON CurrentOrderHeads.OrderId = o' +
        'sbc.OrderId and CurrentOrderHeads.Frozen = 0 '
      'WHERE '
      '    (Catalogs.ShortCode = :ParentCode)'
      'and (Core.coreid is not null)'
      'And ((:ShowRegister = 1) Or (Providers.FirmCode <> :RegisterId))')
    Left = 152
    Top = 109
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'timezonebias'
      end
      item
        DataType = ftUnknown
        Name = 'clientid'
      end
      item
        DataType = ftUnknown
        Name = 'DayOfWeek'
      end
      item
        DataType = ftUnknown
        Name = 'ParentCode'
      end
      item
        DataType = ftUnknown
        Name = 'ShowRegister'
      end
      item
        DataType = ftUnknown
        Name = 'RegisterId'
      end>
  end
  object tmrUpdatePreviosOrders: TTimer
    Enabled = False
    Interval = 700
    OnTimer = tmrUpdatePreviosOrdersTimer
    Left = 576
    Top = 173
  end
  object adsProducers: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      '  0 as Id,'
      '  '#39#1042#1089#1077' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080#39' as Name'
      'union'
      'select'
      '  1 as Id,'
      '  '#39#1054#1089#1090#1072#1083#1100#1085#1099#1077' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080#39' as Name'
      'union'
      'select'
      '  prod.Id,'
      '  prod.Name'
      'from'
      '('
      'SELECT '
      '  p.Id,'
      '  p.Name'
      'FROM'
      '  Producers p'
      'order by p.Name'
      'limit 20'
      ') prod')
    Left = 248
    Top = 165
    object adsProducersId: TLargeintField
      FieldName = 'Id'
    end
    object adsProducersName: TStringField
      FieldName = 'Name'
      Size = 255
    end
  end
  object dsProducers: TDataSource
    DataSet = adsProducers
    Left = 248
    Top = 201
  end
  object adsProducersEtalon: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      '  0 as Id,'
      '  '#39#1042#1089#1077' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080#39' as Name'
      'union'
      'select'
      '  1 as Id,'
      '  '#39#1054#1089#1090#1072#1083#1100#1085#1099#1077' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080#39' as Name'
      'union'
      'select'
      '  prod.Id,'
      '  prod.Name'
      'from'
      '('
      'SELECT '
      '  p.Id,'
      '  p.Name'
      'FROM'
      '  Catalogs,'
      '  products,'
      '  Core,'
      '  Producers p'
      'where'
      '    (Catalogs.ShortCode = :ParentCode)'
      'and (products.catalogid = catalogs.fullcode)'
      'and (Core.productid = products.productid)'
      'and (p.Id = Core.CodeFirmCr)  '
      'order by p.Name'
      ') prod')
    Left = 288
    Top = 165
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ParentCode'
      end>
  end
end
