object CoreFirmForm: TCoreFirmForm
  Left = 310
  Top = 172
  ActiveControl = dbgCore
  Align = alClient
  Anchors = [akTop, akBottom]
  BorderIcons = []
  BorderStyle = bsNone
  Caption = #1047#1072#1103#1074#1082#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
  ClientHeight = 573
  ClientWidth = 792
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
    TabOrder = 3
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
  object dbgCore: TToughDBGrid
    Tag = 128
    Left = 0
    Top = 65
    Width = 792
    Height = 470
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
    Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
    OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = dbgCoreDrawColumnCell
    OnGetCellParams = dbgCoreGetCellParams
    OnKeyDown = dbgCoreKeyDown
    OnKeyPress = dbgCoreKeyPress
    OnSortMarkingChanged = dbgCoreSortMarkingChanged
    InputField = 'OrderCount'
    SearchPosition = spTop
    FindInterval = 2500
    OnCanInput = dbgCoreCanInput
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Code'
        Footers = <>
        Title.Caption = #1050#1086#1076
        Title.TitleButton = True
        Width = 26
      end
      item
        EditButtons = <>
        FieldName = 'SynonymName'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 218
      end
      item
        EditButtons = <>
        FieldName = 'SynonymFirm'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Title.TitleButton = True
        Width = 69
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'Volume'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
        Title.TitleButton = True
        Width = 36
      end
      item
        EditButtons = <>
        FieldName = 'Doc'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1044#1086#1082#1091#1084#1077#1085#1090
        Title.TitleButton = True
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'Note'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        Title.TitleButton = True
        Visible = False
        Width = 56
      end
      item
        Alignment = taCenter
        EditButtons = <>
        FieldName = 'Period'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1057#1088#1086#1082'. '#1075#1086#1076#1085'.'
        Title.TitleButton = True
        Width = 58
      end
      item
        EditButtons = <>
        FieldName = 'registrycost'
        Footers = <>
        Title.Caption = #1056#1077#1077#1089#1090#1088'. '#1094#1077#1085#1072
        Title.TitleButton = True
        Visible = False
        Width = 31
      end
      item
        EditButtons = <>
        FieldName = 'requestratio'
        Footers = <>
        Title.Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
        Title.TitleButton = True
        Visible = False
        Width = 67
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
        MinWidth = 5
        Title.Caption = #1062#1077#1085#1072
        Title.TitleButton = True
        Width = 59
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'Quantity'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Title.TitleButton = True
        Width = 39
      end
      item
        EditButtons = <>
        FieldName = 'CryptPriceRet'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
        Title.TitleButton = True
        Width = 51
      end
      item
        EditButtons = <>
        FieldName = 'LeaderPRICE'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1052#1080#1085'. '#1094#1077#1085#1072
        Title.TitleButton = True
        Width = 51
      end
      item
        EditButtons = <>
        FieldName = 'LeaderPriceName'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1055#1088#1072#1081#1089' - '#1083#1080#1076#1077#1088
        Title.TitleButton = True
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'LeaderRegionName'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1056#1077#1075#1080#1086#1085' - '#1083#1080#1076#1077#1088
        Title.TitleButton = True
        Visible = False
        Width = 70
      end
      item
        Color = 16775406
        EditButtons = <>
        FieldName = 'OrderCount'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1047#1072#1082#1072#1079
        Title.TitleButton = True
        Width = 42
      end
      item
        Color = 16775406
        EditButtons = <>
        FieldName = 'SumOrder'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1057#1091#1084#1084#1072
        Title.TitleButton = True
        Width = 48
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 535
    Width = 792
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      792
      38)
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 792
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
    Width = 792
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      792
      65)
    object lblRecordCount: TLabel
      Left = 510
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
    object btnGotoCore: TSpeedButton
      Left = 223
      Top = 2
      Width = 94
      Height = 25
      Action = actFlipCore
      Anchors = [akTop, akRight]
    end
    object btnGotoMNN: TSpeedButton
      Left = 328
      Top = 2
      Width = 177
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'GotoMNN'
    end
    object cbFilter: TComboBox
      Left = 629
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
    object pTop: TPanel
      Left = 0
      Top = 28
      Width = 792
      Height = 37
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 1
      DesignSize = (
        792
        37)
      object eSearch: TEdit
        Left = 1
        Top = 8
        Width = 320
        Height = 21
        TabOrder = 0
        OnKeyDown = eSearchKeyDown
        OnKeyPress = eSearchKeyPress
      end
      object btnSearch: TButton
        Left = 356
        Top = 4
        Width = 75
        Height = 25
        Caption = #1055#1086#1080#1089#1082
        TabOrder = 1
        Visible = False
        OnClick = tmrSearchTimer
      end
      object dblProducers: TDBLookupComboBox
        Left = 376
        Top = 8
        Width = 412
        Height = 21
        Anchors = [akRight]
        TabOrder = 2
        OnCloseUp = dblProducersCloseUp
      end
    end
  end
  object dsCore: TDataSource
    DataSet = adsCore
    Left = 88
    Top = 152
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
      Caption = #1042' '#1082#1072#1090#1072#1083#1086#1075' (F2)'
      ShortCut = 113
      OnExecute = actFlipCoreExecute
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 640
    Top = 216
  end
  object tmrSearch: TTimer
    Enabled = False
    Interval = 2500
    OnTimer = tmrSearchTimer
    Left = 472
    Top = 213
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
    MasterFields = 'productid'
    DetailFields = 'PRODUCTID'
    Left = 240
    Top = 264
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CLIENTID'
      end
      item
        DataType = ftUnknown
        Name = 'productid'
      end>
    object adsAvgOrdersPRODUCTID: TLargeintField
      FieldName = 'PRODUCTID'
    end
    object adsAvgOrdersPRICEAVG: TFloatField
      FieldName = 'PRICEAVG'
    end
  end
  object adsCurrentOrderHeader: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      '#ordershshowcurrent'
      'select '
      '  CurrentOrderHeads.ORDERID,'
      '  CurrentOrderHeads.SERVERORDERID,'
      
        '  ifnull(CurrentOrderHeads.SERVERORDERID, CurrentOrderHeads.ORDE' +
        'RID) as DisplayOrderId,'
      '  CurrentOrderHeads.CLIENTID,'
      '  CurrentOrderHeads.PRICECODE,'
      '  CurrentOrderHeads.REGIONCODE,'
      '  CurrentOrderHeads.PRICENAME,'
      '  CurrentOrderHeads.REGIONNAME,'
      '  CurrentOrderHeads.ORDERDATE,'
      '  CurrentOrderHeads.SENDDATE,'
      '  CurrentOrderHeads.CLOSED,'
      '  CurrentOrderHeads.SEND,'
      '  CurrentOrderHeads.COMMENTS,'
      '  CurrentOrderHeads.MESSAGETO '
      'from '
      '  CurrentOrderHeads '
      'where '
      '    (CurrentOrderHeads.ClientId   = :CLIENTID)'
      'and (CurrentOrderHeads.PriceCode  = :PRICECODE)'
      'and (CurrentOrderHeads.RegionCode = :REGIONCODE)'
      'and (CurrentOrderHeads.CLOSED <> 1)')
    Left = 344
    Top = 136
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CLIENTID'
      end
      item
        DataType = ftUnknown
        Name = 'PRICECODE'
      end
      item
        DataType = ftUnknown
        Name = 'REGIONCODE'
      end>
  end
  object adsCountFields: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT Count(*) AS CCount,'
      '    Count(nullif(code, '#39#39')) AS Code,'
      '    Count(SynonymFirmCrCode) AS SynonymFirm,'
      '    Count(nullif(Volume, '#39#39')) AS Volume,'
      '    Count(nullif(Doc, '#39#39')) AS Doc,'
      '    Count(nullif(Note, '#39#39')) AS Note,'
      '    Count(nullif(Period, '#39#39')) AS Period,'
      '    Count(nullif(Quantity, '#39#39')) AS Quantity'
      'FROM Core'
      'WHERE PriceCode = :PriceCode AND RegionCode = :RegionCode')
    Left = 240
    Top = 128
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PriceCode'
      end
      item
        DataType = ftUnknown
        Name = 'RegionCode'
      end>
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
      '    CCore.CoreId AS CoreId,'
      '    CCore.productid,'
      '    CCore.PriceCode,'
      '    CCore.RegionCode,'
      '    catalogs.FullCode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    CCore.CodeFirmCr,'
      '    CCore.SynonymCode,'
      '    CCore.SynonymFirmCrCode,'
      '    CCore.Code,'
      '    CCore.CodeCr,'
      '    CCore.Volume,'
      '    CCore.Doc,'
      '    CCore.Note,'
      '    CCore.Period,'
      '    CCore.Await,'
      '    CCore.Junk,'
      '    CCore.Cost as RealCost,'
      
        '    if(dop.Percent is null, CCore.Cost, cast(CCore.Cost * (1 + d' +
        'op.Percent/100) as decimal(18, 2))) as Cost,'
      '    CCore.Quantity,'
      '    CCore.registrycost,'
      '    CCore.vitallyimportant,'
      '    CCore.requestratio,'
      '    CCore.ordercost,'
      '    CCore.minordercount,'
      '    CCore.ProducerCost,'
      '    CCore.NDS,'
      '    CCore.SupplierPriceMarkup,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceCode AS LeaderPriceCode,'
      '    MinPrices.RegionCode AS LeaderRegionCode,'
      '    Regions.RegionName AS LeaderRegionName,'
      '    PricesData.PriceName AS LeaderPriceName,'
      '    MinPrices.MinCost As LeaderPRICE,'
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
      '    (osbc.Price*osbc.OrderCount) AS SumOrder,'
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
      '    GroupMaxProducerCosts.MaxProducerCost'
      'FROM'
      '    Core CCore'
      
        '    inner join products       on (products.productid = CCore.pro' +
        'ductid)'
      
        '    inner join catalogs       on (catalogs.fullcode = products.c' +
        'atalogid)'
      
        '    inner JOIN MinPrices      ON (MinPrices.productid = CCore.pr' +
        'oductid) and (minprices.regioncode = CCore.regioncode)'
      '    left join Mnn             on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = CCore.productid) '
      '      and (CCore.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      
        '    left join Core LCore      on LCore.servercoreid = minprices.' +
        'servercoreid and LCore.RegionCode = minprices.regioncode'
      
        '    left JOIN PricesData      ON (PricesData.PriceCode = MinPric' +
        'es.pricecode)'
      
        '    left JOIN Regions         ON (Regions.RegionCode = MinPrices' +
        '.RegionCode)'
      
        '    left JOIN SynonymFirmCr   ON (SynonymFirmCr.SynonymFirmCrCod' +
        'e = CCore.SynonymFirmCrCode)'
      
        '    left join synonyms        on (Synonyms.SynonymCode = CCore.S' +
        'ynonymCode)'
      
        '    left JOIN CurrentOrderLists osbc ON (osbc.ClientID = :Client' +
        'Id) and (osbc.CoreId = CCore.CoreId)'
      
        '    left JOIN PricesData cpd  ON (cpd.PriceCode = CCore.pricecod' +
        'e)'
      
        '    left join DelayOfPayments dop on (dop.FirmCode = cpd.FirmCod' +
        'e) '
      
        '    left JOIN CurrentOrderHeads      ON CurrentOrderHeads.OrderI' +
        'd = osbc.OrderId'
      'WHERE '
      '  (CCore.CoreId = :CoreId)')
    Connection = DM.MyConnection
    SQL.Strings = (
      '#CORESHOWBYFIRM'
      'SELECT'
      '    CCore.CoreId AS CoreId,'
      '    CCore.productid,'
      '    CCore.PriceCode,'
      '    CCore.RegionCode,'
      '    catalogs.FullCode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    CCore.CodeFirmCr,'
      '    CCore.SynonymCode,'
      '    CCore.SynonymFirmCrCode,'
      '    CCore.Code,'
      '    CCore.CodeCr,'
      '    CCore.Volume,'
      '    CCore.Doc,'
      '    CCore.Note,'
      '    CCore.Period,'
      '    CCore.Await,'
      '    CCore.Junk,'
      '    CCore.Cost as RealCost,'
      
        '    if(dop.Percent is null, CCore.Cost, cast(CCore.Cost * (1 + d' +
        'op.Percent/100) as decimal(18, 2))) as Cost,'
      '    CCore.Quantity,'
      '    CCore.registrycost,'
      '    CCore.vitallyimportant,'
      '    CCore.requestratio,'
      '    CCore.ordercost,'
      '    CCore.minordercount,'
      '    CCore.ProducerCost,'
      '    CCore.NDS,'
      '    CCore.SupplierPriceMarkup,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceCode AS LeaderPriceCode,'
      '    MinPrices.RegionCode AS LeaderRegionCode,'
      '    Regions.RegionName AS LeaderRegionName,'
      '    PricesData.PriceName AS LeaderPriceName,'
      '    MinPrices.MinCost As LeaderPRICE,'
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
      '    (osbc.Price*osbc.OrderCount) AS SumOrder,'
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
      '    GroupMaxProducerCosts.MaxProducerCost'
      'FROM'
      '    Core CCore'
      
        '    inner join products       on (products.productid = CCore.pro' +
        'ductid)'
      
        '    inner join catalogs       on (catalogs.fullcode = products.c' +
        'atalogid)'
      
        '    inner JOIN MinPrices      ON (MinPrices.productid = CCore.pr' +
        'oductid) and (minprices.regioncode = CCore.regioncode)'
      '    left join Mnn             on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = CCore.productid) '
      '      and (CCore.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      
        '    left join Core LCore      on LCore.servercoreid = minprices.' +
        'servercoreid and LCore.RegionCode = minprices.regioncode'
      
        '    left JOIN PricesData      ON (PricesData.PriceCode = MinPric' +
        'es.pricecode)'
      
        '    left JOIN Regions         ON (Regions.RegionCode = MinPrices' +
        '.RegionCode)'
      
        '    left JOIN SynonymFirmCr   ON (SynonymFirmCr.SynonymFirmCrCod' +
        'e = CCore.SynonymFirmCrCode)'
      
        '    left join synonyms        on (Synonyms.SynonymCode = CCore.S' +
        'ynonymCode)'
      
        '    left JOIN CurrentOrderLists osbc ON (osbc.ClientID = :Client' +
        'Id) and (osbc.CoreId = CCore.CoreId)'
      
        '    left JOIN PricesData cpd  ON (cpd.PriceCode = CCore.pricecod' +
        'e)'
      
        '    left join DelayOfPayments dop on (dop.FirmCode = cpd.FirmCod' +
        'e) '
      
        '    left JOIN CurrentOrderHeads      ON CurrentOrderHeads.OrderI' +
        'd = osbc.OrderId'
      'WHERE '
      '    (CCore.PriceCode = :PriceCode) '
      'And (CCore.RegionCode = :RegionCode)')
    BeforeUpdateExecute = BeforeUpdateExecuteForClientID
    RefreshOptions = [roAfterUpdate]
    BeforePost = adsCore2BeforePost
    AfterPost = adsCore2AfterPost
    Left = 120
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'PriceCode'
      end
      item
        DataType = ftUnknown
        Name = 'RegionCode'
      end>
    object adsCoreCoreId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'CoreId'
      Origin = 'Core.CoreId'
    end
    object adsCoreproductid: TLargeintField
      FieldName = 'productid'
      Origin = 'Core.productid'
    end
    object adsCorePriceCode: TLargeintField
      FieldName = 'PriceCode'
      Origin = 'Core.PriceCode'
    end
    object adsCoreRegionCode: TLargeintField
      FieldName = 'RegionCode'
      Origin = 'Core.RegionCode'
    end
    object adsCoreFullCode: TLargeintField
      FieldName = 'FullCode'
      Origin = 'catalogs.FULLCODE'
    end
    object adsCoreshortcode: TLargeintField
      FieldName = 'shortcode'
      Origin = 'catalogs.SHORTCODE'
    end
    object adsCoreCodeFirmCr: TLargeintField
      FieldName = 'CodeFirmCr'
      Origin = 'Core.CodeFirmCr'
    end
    object adsCoreSynonymCode: TLargeintField
      FieldName = 'SynonymCode'
      Origin = 'Core.SynonymCode'
    end
    object adsCoreSynonymFirmCrCode: TLargeintField
      FieldName = 'SynonymFirmCrCode'
      Origin = 'Core.SynonymFirmCrCode'
    end
    object adsCoreCode: TStringField
      FieldName = 'Code'
      Origin = 'Core.Code'
      Size = 84
    end
    object adsCoreCodeCr: TStringField
      FieldName = 'CodeCr'
      Origin = 'Core.CodeCr'
      Size = 84
    end
    object adsCoreVolume: TStringField
      FieldName = 'Volume'
      Origin = 'Core.Volume'
      Size = 15
    end
    object adsCoreDoc: TStringField
      FieldName = 'Doc'
      Origin = 'Core.Doc'
    end
    object adsCoreNote: TStringField
      FieldName = 'Note'
      Origin = 'Core.Note'
      Size = 50
    end
    object adsCorePeriod: TStringField
      FieldName = 'Period'
      Origin = 'Core.Period'
    end
    object adsCoreAwait: TBooleanField
      FieldName = 'Await'
      Origin = 'Core.Await'
    end
    object adsCoreJunk: TBooleanField
      FieldName = 'Junk'
      Origin = 'Core.Junk'
    end
    object adsCoreCost: TFloatField
      FieldName = 'Cost'
      Origin = '.Cost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCoreQuantity: TStringField
      FieldName = 'Quantity'
      Origin = 'Core.Quantity'
      Size = 15
    end
    object adsCoreregistrycost: TFloatField
      FieldName = 'registrycost'
      Origin = 'Core.registrycost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCorevitallyimportant: TBooleanField
      FieldName = 'vitallyimportant'
      Origin = 'Core.vitallyimportant'
    end
    object adsCorerequestratio: TIntegerField
      FieldName = 'requestratio'
      Origin = 'Core.requestratio'
      DisplayFormat = '#'
    end
    object adsCoreordercost: TFloatField
      FieldName = 'ordercost'
      Origin = 'Core.ordercost'
    end
    object adsCoreminordercount: TIntegerField
      FieldName = 'minordercount'
      Origin = 'Core.minordercount'
    end
    object adsCoreSynonymName: TStringField
      FieldName = 'SynonymName'
      Origin = '.SynonymName'
      Size = 501
    end
    object adsCoreSynonymFirm: TStringField
      FieldName = 'SynonymFirm'
      Origin = 'SynonymFirmCr.SYNONYMNAME'
      Size = 250
    end
    object adsCoreLeaderPriceCode: TLargeintField
      FieldName = 'LeaderPriceCode'
      Origin = 'PricesData.PRICECODE'
    end
    object adsCoreLeaderRegionCode: TLargeintField
      FieldName = 'LeaderRegionCode'
      Origin = 'MinPrices.REGIONCODE'
    end
    object adsCoreLeaderRegionName: TStringField
      FieldName = 'LeaderRegionName'
      Origin = 'Regions.REGIONNAME'
      Size = 25
    end
    object adsCoreLeaderPriceName: TStringField
      FieldName = 'LeaderPriceName'
      Origin = 'PricesData.PRICENAME'
      Size = 70
    end
    object adsCoreLeaderPRICE: TFloatField
      FieldName = 'LeaderPRICE'
      Origin = 'MinPrices.MinCost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCoreOrdersCoreId: TLargeintField
      FieldName = 'OrdersCoreId'
      Origin = 'osbc.OrdersCoreId'
    end
    object adsCoreOrdersOrderId: TLargeintField
      FieldName = 'OrdersOrderId'
      Origin = 'osbc.OrdersOrderId'
    end
    object adsCoreOrdersClientId: TLargeintField
      FieldName = 'OrdersClientId'
      Origin = 'osbc.OrdersClientId'
    end
    object adsCoreOrdersFullCode: TLargeintField
      FieldName = 'OrdersFullCode'
      Origin = 'catalogs.FULLCODE'
    end
    object adsCoreOrdersCodeFirmCr: TLargeintField
      FieldName = 'OrdersCodeFirmCr'
      Origin = 'osbc.OrdersCodeFirmCr'
    end
    object adsCoreOrdersSynonymCode: TLargeintField
      FieldName = 'OrdersSynonymCode'
      Origin = 'osbc.OrdersSynonymCode'
    end
    object adsCoreOrdersSynonymFirmCrCode: TLargeintField
      FieldName = 'OrdersSynonymFirmCrCode'
      Origin = 'osbc.OrdersSynonymFirmCrCode'
    end
    object adsCoreOrdersCode: TStringField
      FieldName = 'OrdersCode'
      Origin = 'osbc.OrdersCode'
      Size = 84
    end
    object adsCoreOrdersCodeCr: TStringField
      FieldName = 'OrdersCodeCr'
      Origin = 'osbc.OrdersCodeCr'
      Size = 84
    end
    object adsCoreOrderCount: TIntegerField
      FieldName = 'OrderCount'
      Origin = 'osbc.OrderCount'
      DisplayFormat = '#'
    end
    object adsCoreOrdersSynonym: TStringField
      FieldName = 'OrdersSynonym'
      Origin = 'osbc.OrdersSynonym'
      Size = 250
    end
    object adsCoreOrdersSynonymFirm: TStringField
      FieldName = 'OrdersSynonymFirm'
      Origin = 'osbc.OrdersSynonymFirm'
      Size = 250
    end
    object adsCoreOrdersPrice: TFloatField
      FieldName = 'OrdersPrice'
      Origin = 'osbc.OrdersPrice'
    end
    object adsCoreOrdersJunk: TBooleanField
      FieldName = 'OrdersJunk'
      Origin = 'osbc.OrdersJunk'
    end
    object adsCoreOrdersAwait: TBooleanField
      FieldName = 'OrdersAwait'
      Origin = 'osbc.OrdersAwait'
    end
    object adsCoreOrdersHOrderId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'OrdersHOrderId'
      Origin = 'CurrentOrderHeads.ORDERID'
    end
    object adsCoreOrdersHClientId: TLargeintField
      FieldName = 'OrdersHClientId'
      Origin = 'CurrentOrderHeads.CLIENTID'
    end
    object adsCoreOrdersHPriceCode: TLargeintField
      FieldName = 'OrdersHPriceCode'
      Origin = 'CurrentOrderHeads.PRICECODE'
    end
    object adsCoreOrdersHRegionCode: TLargeintField
      FieldName = 'OrdersHRegionCode'
      Origin = 'CurrentOrderHeads.REGIONCODE'
    end
    object adsCoreOrdersHPriceName: TStringField
      FieldName = 'OrdersHPriceName'
      Origin = 'CurrentOrderHeads.PRICENAME'
      Size = 70
    end
    object adsCoreOrdersHRegionName: TStringField
      FieldName = 'OrdersHRegionName'
      Origin = 'CurrentOrderHeads.REGIONNAME'
      Size = 25
    end
    object adsCoreCryptPriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreSumOrder: TFloatField
      FieldName = 'SumOrder'
      Origin = '.SumOrder'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCoreRealCost: TFloatField
      FieldName = 'RealCost'
      Origin = 'Core.RealCost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCoreMnnId: TLargeintField
      FieldName = 'MnnId'
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
  end
  object adsCoreWithLike: TMyQuery
    SQL.Strings = (
      'SELECT'
      '    CCore.CoreId AS CoreId,'
      '    CCore.productid,'
      '    CCore.PriceCode,'
      '    CCore.RegionCode,'
      '    catalogs.FullCode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    CCore.CodeFirmCr,'
      '    CCore.SynonymCode,'
      '    CCore.SynonymFirmCrCode,'
      '    CCore.Code,'
      '    CCore.CodeCr,'
      '    CCore.Volume,'
      '    CCore.Doc,'
      '    CCore.Note,'
      '    CCore.Period,'
      '    CCore.Await,'
      '    CCore.Junk,'
      '    CCore.Cost as RealCost,'
      
        '    if(dop.Percent is null, CCore.Cost, cast(CCore.Cost * (1 + d' +
        'op.Percent/100) as decimal(18, 2))) as Cost,'
      '    CCore.Quantity,'
      '    CCore.registrycost,'
      '    CCore.vitallyimportant,'
      '    CCore.requestratio,'
      '    CCore.ordercost,'
      '    CCore.minordercount,'
      '    CCore.ProducerCost,'
      '    CCore.NDS,'
      '    CCore.SupplierPriceMarkup,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceCode AS LeaderPriceCode,'
      '    MinPrices.RegionCode AS LeaderRegionCode,'
      '    Regions.RegionName AS LeaderRegionName,'
      '    PricesData.PriceName AS LeaderPriceName,'
      '    MinPrices.MinCost As LeaderPRICE,'
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
      '    (osbc.Price*osbc.OrderCount) AS SumOrder,'
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
      '    GroupMaxProducerCosts.MaxProducerCost'
      'FROM'
      
        '    (select * from synonyms where (synonyms.SynonymName like :Li' +
        'keParam)) as synonyms,'
      '    Core CCore'
      
        '    inner join products       on (products.productid = CCore.pro' +
        'ductid)'
      
        '    inner join catalogs       on (catalogs.fullcode = products.c' +
        'atalogid)'
      
        '    inner JOIN MinPrices      ON (MinPrices.productid = CCore.pr' +
        'oductid) and (minprices.regioncode = CCore.regioncode)'
      '    left join Mnn             on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = CCore.productid) '
      '      and (CCore.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      
        '    left join Core LCore      on LCore.servercoreid = minprices.' +
        'servercoreid and LCore.RegionCode = minprices.regioncode'
      
        '    left JOIN PricesData      ON (PricesData.PriceCode = MinPric' +
        'es.pricecode)'
      
        '    left JOIN Regions         ON (Regions.RegionCode = MinPrices' +
        '.RegionCode)'
      
        '    left JOIN SynonymFirmCr   ON (SynonymFirmCr.SynonymFirmCrCod' +
        'e = CCore.SynonymFirmCrCode)'
      
        '    left JOIN CurrentOrderLists osbc ON (osbc.ClientID = :Client' +
        'Id) and (osbc.CoreId = CCore.CoreId)'
      
        '    left JOIN PricesData cpd  ON (cpd.PriceCode = CCore.pricecod' +
        'e)'
      
        '    left join DelayOfPayments dop on (dop.FirmCode = cpd.FirmCod' +
        'e) '
      
        '    left JOIN CurrentOrderHeads      ON CurrentOrderHeads.OrderI' +
        'd = osbc.OrderId'
      'WHERE '
      '    (Synonyms.SynonymCode = CCore.SynonymCode)'
      'and (CCore.PriceCode = :PriceCode) '
      'and (CCore.RegionCode = :RegionCode)')
    Left = 128
    Top = 160
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'LikeParam'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'PriceCode'
      end
      item
        DataType = ftUnknown
        Name = 'RegionCode'
      end>
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
      '  prod.*'
      'from'
      '('
      'SELECT '
      '  p.Id,'
      '  p.Name'
      'FROM'
      '  Core,'
      '  Producers p'
      'where'
      '    (Core.PriceCode = :PriceCode)'
      'and (Core.RegionCode = :RegionCode)'
      'and (p.Id = Core.CodeFirmCr)  '
      'order by p.Name'
      ') prod')
    Left = 384
    Top = 253
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PriceCode'
      end
      item
        DataType = ftUnknown
        Name = 'RegionCode'
      end>
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
    Left = 384
    Top = 289
  end
end
