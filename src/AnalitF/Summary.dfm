inherited SummaryForm: TSummaryForm
  Left = 350
  Top = 172
  ActiveControl = dbgSummary
  Caption = #1057#1074#1086#1076#1085#1099#1081' '#1079#1072#1082#1072#1079
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
    Height = 342
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object dbgSummary: TToughDBGrid
      Left = 0
      Top = 52
      Width = 792
      Height = 257
      Align = alClient
      AutoFitColWidths = True
      DataSource = dsSummary
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
      OnGetCellParams = dbgSummaryGetCellParams
      OnKeyDown = dbgSummaryKeyDown
      OnSortMarkingChanged = dbgSummarySortMarkingChanged
      SearchField = 'SynonymName'
      InputField = 'OrderCount'
      SearchPosition = spBottom
      ForceRus = True
      OnCanInput = dbgSummaryCanInput
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SynonymName'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 225
        end
        item
          EditButtons = <>
          FieldName = 'SynonymFirm'
          Footers = <>
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Title.TitleButton = True
          Width = 140
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Volume'
          Footers = <>
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'Note'
          Footers = <>
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Title.TitleButton = True
          Visible = False
          Width = 45
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
          EditButtons = <>
          FieldName = 'Period'
          Footers = <>
          Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
          Title.TitleButton = True
          Width = 61
        end
        item
          EditButtons = <>
          FieldName = 'PriceName'
          Footers = <>
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Title.TitleButton = True
          Width = 82
        end
        item
          EditButtons = <>
          FieldName = 'RegionName'
          Footers = <>
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Title.TitleButton = True
          Visible = False
          Width = 62
        end
        item
          EditButtons = <>
          FieldName = 'registrycost'
          Footers = <>
          Title.Caption = #1056#1077#1077#1089#1090#1088'. '#1094#1077#1085#1072
          Title.TitleButton = True
          Visible = False
          Width = 58
        end
        item
          EditButtons = <>
          FieldName = 'RequestRatio'
          Footers = <>
          Title.Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
          Title.TitleButton = True
          Visible = False
          Width = 59
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
          FieldName = 'MINORDERCOUNT'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086
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
          Width = 67
        end
        item
          EditButtons = <>
          FieldName = 'PriceRet'
          Footers = <>
          Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
          Title.TitleButton = True
          Width = 62
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Quantity'
          Footers = <>
          Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          Title.TitleButton = True
          Width = 43
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'OrderCount'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079
          Title.TitleButton = True
          Width = 44
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072
          Title.TitleButton = True
          Width = 58
        end>
    end
    object pStatus: TPanel
      Left = 0
      Top = 309
      Width = 792
      Height = 33
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        792
        33)
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 792
        Height = 33
        Align = alClient
        Shape = bsTopLine
      end
      object Label1: TLabel
        Left = 195
        Top = 11
        Width = 56
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = #1055#1086#1079#1080#1094#1080#1081':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 307
        Top = 11
        Width = 60
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = #1085#1072' '#1089#1091#1084#1084#1091':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lSumOrder: TLabel
        Left = 375
        Top = 11
        Width = 59
        Height = 13
        Caption = 'lSumOrder'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lPosCount: TLabel
        Left = 255
        Top = 11
        Width = 58
        Height = 13
        Caption = 'lPosCount'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnDelete: TButton
        Left = 8
        Top = 5
        Width = 75
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 0
        OnClick = btnDeleteClick
      end
      object btnGotoCore: TButton
        Left = 91
        Top = 5
        Width = 94
        Height = 25
        Caption = #1042' '#1082#1072#1090#1072#1083#1086#1075' (F2)'
        TabOrder = 1
        Visible = False
      end
    end
    object pTopSettings: TPanel
      Left = 0
      Top = 0
      Width = 792
      Height = 52
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object bvSettings: TBevel
        Left = 0
        Top = 49
        Width = 792
        Height = 3
        Align = alBottom
        Shape = bsBottomLine
      end
      object rgSummaryType: TRadioGroup
        Left = 0
        Top = 0
        Width = 433
        Height = 48
        Caption = ' '#1048#1089#1090#1086#1095#1085#1080#1082' '
        Items.Strings = (
          #1042#1099#1073#1080#1088#1072#1090#1100' '#1080#1079' '#1090#1077#1082#1091#1097#1080#1093
          
            #1042#1099#1073#1080#1088#1072#1090#1100' '#1080#1079' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1093' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089'                            ' +
            '    '#1087#1086)
        TabOrder = 0
        OnClick = rgSummaryTypeClick
      end
      object btnSelectPrices: TBitBtn
        Left = 456
        Top = 13
        Width = 105
        Height = 25
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
        TabOrder = 1
        OnClick = btnSelectPricesClick
        Glyph.Data = {
          A6000000424DA600000000000000760000002800000009000000060000000100
          0400000000003000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333000
          0000333303333000000033300033300000003300000330000000300000003000
          00003333333330000000}
        Layout = blGlyphRight
        Spacing = 10
      end
      object dtpDateFrom: TDateTimePicker
        Left = 234
        Top = 23
        Width = 81
        Height = 21
        Date = 36526.631636412040000000
        Time = 36526.631636412040000000
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnCloseUp = dtpDateCloseUp
      end
      object dtpDateTo: TDateTimePicker
        Left = 346
        Top = 23
        Width = 81
        Height = 21
        Date = 0.631934409720997800
        Time = 0.631934409720997800
        Enabled = False
        TabOrder = 3
        OnCloseUp = dtpDateCloseUp
      end
    end
  end
  object pWebBrowser: TPanel [2]
    Tag = 200
    Left = 0
    Top = 342
    Width = 792
    Height = 198
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
      Tag = 6
      Left = 0
      Top = 4
      Width = 792
      Height = 194
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C000000DB5100000D1400000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  inline frameLegeng: TframeLegeng [3]
    Left = 0
    Top = 540
    Width = 792
    Height = 33
    Align = alBottom
    Color = clWindow
    ParentColor = False
    TabOrder = 3
    inherited gbLegend: TGroupBox
      Width = 792
      inherited lNotBasicLegend: TLabel
        Visible = False
      end
      inherited lLeaderLegend: TLabel
        Visible = False
      end
    end
  end
  object dsSummary: TDataSource
    DataSet = adsSummary
    Left = 296
    Top = 136
  end
  object frdsSummary: TfrDBDataSet
    DataSource = dsSummary
    OpenDataSource = False
    Left = 304
    Top = 184
  end
  object adsSummaryOld: TpFIBDataSet
    UpdateSQL.Strings = (
      'update'
      '  orders'
      'set'
      '  ORDERCOUNT = :ORDERCOUNT'
      'where'
      '   COREID = :ORDERSCOREID'
      'and ORDERID = :ORDERSORDERID')
    DeleteSQL.Strings = (
      'delete from'
      '  orders'
      'where'
      '   COREID = :ORDERSCOREID'
      'and ORDERID = :ORDERSORDERID')
    SelectSQL.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    Core.CoreId,'
      '    Core.Volume,'
      '    Core.Quantity,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Junk,'
      '    Core.Await,'
      '    Core.CODE,'
      '    Core.CODECR,'
      
        '    coalesce(Synonyms.SynonymName, catalogs.name || '#39' '#39' || catal' +
        'ogs.form) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    Core.BaseCost,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    Orders.OrderCount,'
      '    Orders.CoreId AS OrdersCoreId,'
      '    Orders.OrderId AS OrdersOrderId,'
      '    pricesdata.pricecode,'
      '    Regions.regioncode,'
      '    core.doc,'
      '    core.registrycost,'
      '    core.vitallyimportant,'
      '    core.requestratio,'
      '    Orders.SendPrice,'
      '    core.ordercost,'
      '    core.minordercount'
      'FROM'
      '    PricesData,'
      '    Regions,'
      '    Core,'
      '    OrdersH,'
      '    products,'
      '    catalogs, '
      '    Orders'
      
        '    left join Synonyms on Orders.SynonymCode=Synonyms.SynonymCod' +
        'e'
      
        '    LEFT JOIN SynonymFirmCr ON Orders.SynonymFirmCrCode=SynonymF' +
        'irmCr.SynonymFirmCrCode'
      'WHERE'
      '    OrdersH.ClientId = :AClientId'
      'and Orders.OrderId=OrdersH.OrderId'
      'and Orders.OrderCount>0'
      'and Core.CoreId=Orders.CoreId'
      'and products.productid = orders.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = OrdersH.PriceCode'
      'and Regions.RegionCode = OrdersH.RegionCode')
    AfterPost = adsSummary2AfterPost
    AfterScroll = adsSummary2AfterScroll
    BeforePost = adsSummary2BeforePost
    Database = DM.MainConnectionOld
    AutoCommit = True
    Left = 296
    Top = 96
    oTrimCharFields = False
    oCacheCalcFields = True
    oRefreshAfterPost = False
    object adsSummaryOldSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryOldCryptBASECOST: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptBASECOST'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryOldPriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryOldVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = True
    end
    object adsSummaryOldQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = True
    end
    object adsSummaryOldNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = True
    end
    object adsSummaryOldPERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = True
    end
    object adsSummaryOldJUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsSummaryOldAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsSummaryOldCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSummaryOldCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSummaryOldSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 501
      EmptyStrToNull = True
    end
    object adsSummaryOldSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsSummaryOldBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 60
      EmptyStrToNull = True
    end
    object adsSummaryOldPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsSummaryOldREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsSummaryOldORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsSummaryOldORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsSummaryOldORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsSummaryOldPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsSummaryOldREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsSummaryOldDOC: TFIBStringField
      FieldName = 'DOC'
      EmptyStrToNull = True
    end
    object adsSummaryOldREGISTRYCOST: TFIBFloatField
      FieldName = 'REGISTRYCOST'
    end
    object adsSummaryOldVITALLYIMPORTANT: TFIBBooleanField
      FieldName = 'VITALLYIMPORTANT'
    end
    object adsSummaryOldREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
    end
    object adsSummaryOldSENDPRICE: TFIBBCDField
      FieldName = 'SENDPRICE'
      Size = 2
      RoundByScale = True
    end
    object adsSummaryOldORDERCOST: TFIBBCDField
      FieldName = 'ORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsSummaryOldMINORDERCOUNT: TFIBIntegerField
      FieldName = 'MINORDERCOUNT'
    end
    object adsSummaryOldCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsSummaryOldFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsSummaryOldSHORTCODE: TFIBBCDField
      FieldName = 'SHORTCODE'
      Size = 0
      RoundByScale = True
    end
  end
  object pmSelectedPrices: TPopupMenu
    AutoPopup = False
    Left = 640
    Top = 8
    object miSelectedAll: TMenuItem
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077#1093
      OnClick = miSelectedAllClick
    end
    object miUnselectedAll: TMenuItem
      Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1074#1089#1077#1093
      OnClick = miUnselectedAllClick
    end
    object miSeparator: TMenuItem
      Caption = '-'
    end
  end
  object adsCurrentSummaryOld: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    Core.CoreID,'
      '    Core.Volume,'
      '    Core.Quantity,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Junk,'
      '    Core.Await,'
      '    Core.CODE,'
      '    Core.CODECR,'
      
        '    coalesce(Synonyms.SynonymName, catalogs.name || '#39' '#39' || catal' +
        'ogs.form) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    Core.BaseCost,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    Orders.OrderCount,'
      '    Orders.CoreId AS OrdersCoreId,'
      '    Orders.OrderId AS OrdersOrderId,'
      '    pricesdata.pricecode,'
      '    Regions.regioncode,'
      '    core.doc,'
      '    core.registrycost,'
      '    core.vitallyimportant,'
      '    core.requestratio,'
      '    Orders.SendPrice,'
      '    core.ordercost,'
      '    core.minordercount'
      'FROM'
      '    PricesData,'
      '    Regions,'
      '    Core,'
      '    OrdersH,'
      '    products,'
      '    catalogs, '
      '    Orders'
      
        '    left join Synonyms on Orders.SynonymCode=Synonyms.SynonymCod' +
        'e'
      
        '    LEFT JOIN SynonymFirmCr ON Orders.SynonymFirmCrCode=SynonymF' +
        'irmCr.SynonymFirmCrCode'
      'WHERE'
      '    OrdersH.ClientId = :AClientId'
      'and Orders.OrderId=OrdersH.OrderId'
      'and Orders.OrderCount>0'
      'and Core.CoreId=Orders.CoreId'
      'and products.productid = orders.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = OrdersH.PriceCode'
      'and Regions.RegionCode = OrdersH.RegionCode')
    Database = DM.MainConnectionOld
    Left = 96
    Top = 112
    oCacheCalcFields = True
  end
  object adsSendSummaryOld: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    Orders.CoreId AS CoreId,'
      '    cast('#39#39' as varchar(15)) as Volume,'
      '    cast('#39#39' as varchar(15)) as Quantity,'
      '    cast('#39#39' as varchar(50)) as Note,'
      '    cast('#39#39' as varchar(20)) as Period,'
      '    Orders.Junk,'
      '    Orders.Await,'
      '    Orders.CODE,'
      '    Orders.CODECR,'
      
        '    coalesce(Synonyms.SynonymName, catalogs.name || '#39' '#39' || catal' +
        'ogs.form) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    Orders.Price as BaseCost,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    Orders.OrderCount,'
      '    Orders.CoreId AS OrdersCoreId,'
      '    Orders.OrderId AS OrdersOrderId,'
      '    PricesData.pricecode,'
      '    Regions.regioncode,'
      '    cast('#39#39' as varchar(20)) as doc,'
      '    cast(0.0 as numeric(8,2)) as registrycost,'
      '    0 as vitallyimportant,'
      '    0 as requestratio,'
      '    Orders.SendPrice,'
      '    0.0 as ordercost,'
      '    0 as minordercount'
      'FROM'
      '    PricesData,'
      '    Regions,'
      '    OrdersH,'
      '    products,'
      '    catalogs, '
      '    Orders'
      
        '    left join Synonyms on Orders.SynonymCode=Synonyms.SynonymCod' +
        'e'
      
        '    LEFT JOIN SynonymFirmCr ON Orders.SynonymFirmCrCode=SynonymF' +
        'irmCr.SynonymFirmCrCode'
      'WHERE'
      '    OrdersH.ClientId = :AClientId'
      'and Orders.OrderId=OrdersH.OrderId'
      'and Orders.OrderCount>0'
      'and Orders.CoreId is null'
      'and products.productid = orders.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = OrdersH.PriceCode'
      'and Regions.RegionCode = OrdersH.RegionCode'
      'and ordersh.senddate >= :datefrom'
      'and ordersh.senddate <= :dateTo')
    Database = DM.MainConnectionOld
    Left = 144
    Top = 112
    oCacheCalcFields = True
    object adsSendSummaryOldVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = True
    end
    object adsSendSummaryOldQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = True
    end
    object adsSendSummaryOldNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = True
    end
    object adsSendSummaryOldPERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = True
    end
    object adsSendSummaryOldJUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsSendSummaryOldAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsSendSummaryOldCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSendSummaryOldCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSendSummaryOldSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 501
      EmptyStrToNull = True
    end
    object adsSendSummaryOldSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsSendSummaryOldBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 60
      EmptyStrToNull = True
    end
    object adsSendSummaryOldPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsSendSummaryOldREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsSendSummaryOldORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsSendSummaryOldORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsSendSummaryOldORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsSendSummaryOldPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsSendSummaryOldREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsSendSummaryOldDOC: TFIBStringField
      FieldName = 'DOC'
      EmptyStrToNull = True
    end
    object adsSendSummaryOldVITALLYIMPORTANT: TFIBIntegerField
      FieldName = 'VITALLYIMPORTANT'
    end
    object adsSendSummaryOldREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
    end
    object adsSendSummaryOldREGISTRYCOST: TFIBFloatField
      FieldName = 'REGISTRYCOST'
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
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 640
    Top = 216
  end
  object adsCurrentSummary: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    Core.CoreID,'
      '    Core.Volume,'
      '    Core.Quantity,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Junk,'
      '    Core.Await,'
      '    Core.CODE,'
      '    Core.CODECR,'
      '    core.doc,'
      '    core.registrycost,'
      '    core.vitallyimportant as vitallyimportant,'
      '    core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    Core.Cost,'
      
        '    coalesce(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', ca' +
        'talogs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    OrdersList.OrderCount,'
      '    OrdersList.CoreId AS OrdersCoreId,'
      '    OrdersList.OrderId AS OrdersOrderId,'
      '    pricesdata.pricecode,'
      '    Regions.regioncode,'
      '    OrdersHead.OrderId as OrdersHOrderId'
      'FROM'
      '    PricesData,'
      '    Regions,'
      '    Core,'
      '    OrdersHead,'
      '    products,'
      '    catalogs,'
      '    OrdersList'
      
        '    left join Synonyms on OrdersList.SynonymCode=Synonyms.Synony' +
        'mCode'
      
        '    LEFT JOIN SynonymFirmCr ON OrdersList.SynonymFirmCrCode=Syno' +
        'nymFirmCr.SynonymFirmCrCode'
      'WHERE'
      '    OrdersHead.ClientId = :AClientId'
      'and OrdersList.OrderId=OrdersHead.OrderId'
      'and OrdersList.OrderCount>0'
      'and Core.CoreId=OrdersList.CoreId'
      'and products.productid = OrdersList.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = OrdersHead.PriceCode'
      'and Regions.RegionCode = OrdersHead.RegionCode')
    Left = 104
    Top = 152
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end>
  end
  object adsSendSummary: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    OrdersList.CoreId AS CoreId,'
      '    cast('#39#39' as char(15)) as Volume,'
      '    cast('#39#39' as char(15)) as Quantity,'
      '    cast('#39#39' as char(50)) as Note,'
      '    cast('#39#39' as char(20)) as Period,'
      '    OrdersList.Junk,'
      '    OrdersList.Await,'
      '    OrdersList.CODE,'
      '    OrdersList.CODECR,'
      '    cast('#39#39' as char(20)) as doc,'
      '    0.0  as registrycost,'
      '    x_cast_to_tinyint(0) as vitallyimportant,'
      '    x_cast_to_int10(0) as requestratio,'
      '    0.0 as ordercost,'
      '    x_cast_to_int10(0) as minordercount,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    OrdersList.Price as Cost,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    OrdersList.OrderCount,'
      '    OrdersList.CoreId AS OrdersCoreId,'
      '    OrdersList.OrderId AS OrdersOrderId,'
      '    PricesData.pricecode,'
      '    Regions.regioncode,'
      '    OrdersHead.OrderId as OrdersHOrderId  '
      'FROM'
      '    PricesData,'
      '    Regions,'
      '    OrdersHead,'
      '    products,'
      '    catalogs,'
      '    OrdersList'
      
        '    left join Synonyms on OrdersList.SynonymCode=Synonyms.Synony' +
        'mCode'
      
        '    LEFT JOIN SynonymFirmCr ON OrdersList.SynonymFirmCrCode=Syno' +
        'nymFirmCr.SynonymFirmCrCode'
      'WHERE'
      '    OrdersHead.ClientId = :AClientId'
      'and OrdersList.OrderId=OrdersHead.OrderId'
      'and OrdersList.OrderCount>0'
      'and OrdersList.CoreId is null'
      'and products.productid = OrdersList.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = OrdersHead.PriceCode'
      'and Regions.RegionCode = OrdersHead.RegionCode'
      'and OrdersHead.senddate >= :datefrom'
      'and OrdersHead.senddate <= :dateTo')
    Left = 152
    Top = 152
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end
      item
        DataType = ftUnknown
        Name = 'datefrom'
      end
      item
        DataType = ftUnknown
        Name = 'dateTo'
      end>
  end
  object adsSummary: TMyQuery
    SQLUpdate.Strings = (
      
        'call updateordercount(:OLD_ORDERSHORDERID, :AClientid, :OLD_PRIC' +
        'ECODE, :OLD_REGIONCODE, :OLD_ORDERSORDERID, :OLD_COREID, :ORDERC' +
        'OUNT)')
    SQLRefresh.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    Core.CoreID,'
      '    Core.Volume,'
      '    Core.Quantity,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Junk,'
      '    Core.Await,'
      '    Core.CODE,'
      '    Core.CODECR,'
      '    core.doc,'
      '    core.registrycost,'
      '    core.vitallyimportant as vitallyimportant,'
      '    core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    Core.Cost,'
      
        '    coalesce(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', ca' +
        'talogs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    OrdersList.OrderCount,'
      '    OrdersList.CoreId AS OrdersCoreId,'
      '    OrdersList.OrderId AS OrdersOrderId,'
      '    pricesdata.pricecode,'
      '    Regions.regioncode,'
      '    OrdersHead.OrderId as OrdersHOrderId'
      'FROM'
      '    PricesData,'
      '    Regions,'
      '    Core,'
      '    OrdersHead,'
      '    products,'
      '    catalogs,'
      '    OrdersList'
      
        '    left join Synonyms on OrdersList.SynonymCode=Synonyms.Synony' +
        'mCode'
      
        '    LEFT JOIN SynonymFirmCr ON OrdersList.SynonymFirmCrCode=Syno' +
        'nymFirmCr.SynonymFirmCrCode'
      'WHERE'
      '    OrdersHead.ClientId = :AClientId'
      'and OrdersList.OrderId=OrdersHead.OrderId'
      'and OrdersList.OrderCount>0'
      'and Core.CoreId=OrdersList.CoreId'
      'and products.productid = OrdersList.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = OrdersHead.PriceCode'
      'and Regions.RegionCode = OrdersHead.RegionCode'
      'and Core.CoreId = :CoreId')
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    Core.CoreID,'
      '    Core.Volume,'
      '    Core.Quantity,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Junk,'
      '    Core.Await,'
      '    Core.CODE,'
      '    Core.CODECR,'
      '    core.doc,'
      '    core.registrycost,'
      '    core.vitallyimportant,'
      '    core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    Core.Cost,'
      
        '    coalesce(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', ca' +
        'talogs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    OrdersList.OrderCount,'
      '    OrdersList.CoreId AS OrdersCoreId,'
      '    OrdersList.OrderId AS OrdersOrderId,'
      '    pricesdata.pricecode,'
      '    Regions.regioncode,'
      '    OrdersHead.OrderId as OrdersHOrderId'
      'FROM'
      '    PricesData,'
      '    Regions,'
      '    Core,'
      '    OrdersHead,'
      '    products,'
      '    catalogs,'
      '    OrdersList'
      
        '    left join Synonyms on OrdersList.SynonymCode=Synonyms.Synony' +
        'mCode'
      
        '    LEFT JOIN SynonymFirmCr ON OrdersList.SynonymFirmCrCode=Syno' +
        'nymFirmCr.SynonymFirmCrCode'
      'WHERE'
      '    OrdersHead.ClientId = :AClientId'
      'and OrdersList.OrderId=OrdersHead.OrderId'
      'and OrdersList.OrderCount>0'
      'and Core.CoreId=OrdersList.CoreId'
      'and products.productid = OrdersList.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = OrdersHead.PriceCode'
      'and Regions.RegionCode = OrdersHead.RegionCode')
    BeforeUpdateExecute = BeforeUpdateExecuteForClientID
    BeforePost = adsSummary2BeforePost
    AfterPost = adsSummary2AfterPost
    AfterScroll = adsSummary2AfterScroll
    Left = 336
    Top = 104
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end>
    object adsSummaryfullcode: TLargeintField
      FieldName = 'fullcode'
    end
    object adsSummaryshortcode: TLargeintField
      FieldName = 'shortcode'
    end
    object adsSummaryCoreID: TLargeintField
      FieldName = 'CoreID'
    end
    object adsSummaryVolume: TStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsSummaryQuantity: TStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsSummaryNote: TStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsSummaryPeriod: TStringField
      FieldName = 'Period'
    end
    object adsSummaryJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsSummaryAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsSummaryCODE: TStringField
      FieldName = 'CODE'
      Size = 84
    end
    object adsSummaryCODECR: TStringField
      FieldName = 'CODECR'
      Size = 84
    end
    object adsSummarydoc: TStringField
      FieldName = 'doc'
    end
    object adsSummaryregistrycost: TFloatField
      FieldName = 'registrycost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsSummaryordercost: TFloatField
      FieldName = 'ordercost'
    end
    object adsSummaryCost: TFloatField
      FieldName = 'Cost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsSummarySynonymName: TStringField
      FieldName = 'SynonymName'
      Size = 501
    end
    object adsSummarySynonymFirm: TStringField
      FieldName = 'SynonymFirm'
      Size = 250
    end
    object adsSummaryPriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsSummaryRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsSummaryOrderCount: TIntegerField
      FieldName = 'OrderCount'
    end
    object adsSummaryOrdersCoreId: TLargeintField
      FieldName = 'OrdersCoreId'
    end
    object adsSummaryOrdersOrderId: TLargeintField
      FieldName = 'OrdersOrderId'
    end
    object adsSummarypricecode: TLargeintField
      FieldName = 'pricecode'
    end
    object adsSummaryregioncode: TLargeintField
      FieldName = 'regioncode'
    end
    object adsSummaryPriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryRequestRatio: TIntegerField
      FieldName = 'RequestRatio'
    end
    object adsSummaryMINORDERCOUNT: TIntegerField
      FieldName = 'MINORDERCOUNT'
    end
    object adsSummaryVitallyImportant: TBooleanField
      FieldName = 'VitallyImportant'
    end
    object adsSummarySumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryOrdersHOrderId: TLargeintField
      FieldName = 'OrdersHOrderId'
    end
  end
end
