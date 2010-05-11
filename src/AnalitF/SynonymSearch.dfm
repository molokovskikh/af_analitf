inherited SynonymSearchForm: TSynonymSearchForm
  Left = 368
  Top = 226
  ActiveControl = dbgCore
  Caption = #1055#1086#1080#1089#1082' '#1074' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1093
  ClientHeight = 573
  ClientWidth = 792
  OldCreateOrder = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 792
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lFilter: TLabel
      Left = 442
      Top = 8
      Width = 99
      Height = 13
      Caption = '('#1060#1080#1083#1100#1090#1088' '#1087#1088#1080#1084#1077#1085#1077#1085')'
      Visible = False
    end
    object btnGotoCore: TSpeedButton
      Left = 680
      Top = 4
      Width = 94
      Height = 25
      Action = actFlipCore
    end
    object btnGotoMNN: TSpeedButton
      Left = 785
      Top = 4
      Width = 177
      Height = 25
      Caption = 'GotoMNN'
      Visible = False
    end
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
      Left = 204
      Top = 4
      Width = 75
      Height = 25
      Caption = #1055#1086#1080#1089#1082
      TabOrder = 1
      Visible = False
      OnClick = tmrSearchTimer
    end
    object cbBaseOnly: TCheckBox
      Left = 560
      Top = 8
      Width = 113
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1086#1089#1085#1086#1074#1085#1099#1077
      TabOrder = 2
      OnClick = cbBaseOnlyClick
    end
    object btnSelectPrices: TBitBtn
      Left = 332
      Top = 4
      Width = 105
      Height = 25
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
      TabOrder = 3
      OnClick = btnSelectPricesClick
      Glyph.Data = {
        A6000000424DA600000000000000760000002800000009000000060000000100
        0400000000003000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333000
        0000333303333000000033300033300000003300000330000000300000003000
        00003333333330000000}
      Layout = blGlyphRight
    end
    object dblProducers: TDBLookupComboBox
      Left = 1
      Top = 37
      Width = 320
      Height = 21
      DropDownRows = 30
      TabOrder = 4
      OnCloseUp = dblProducersCloseUp
    end
  end
  object pCenter: TPanel [1]
    Left = 0
    Top = 65
    Width = 792
    Height = 344
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgCore: TToughDBGrid
      Tag = 32
      Left = 0
      Top = 0
      Width = 792
      Height = 344
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
      OnDrawColumnCell = dbgCoreDrawColumnCell
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
          FieldName = 'OrderCost'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072
        end
        item
          EditButtons = <>
          FieldName = 'MinOrderCount'
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
          FieldName = 'PriceDelta'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1056#1072#1079#1085#1080#1094#1072', %'
          Visible = False
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
  end
  object pBottom: TPanel [2]
    Left = 0
    Top = 409
    Width = 792
    Height = 131
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object gbPrevOrders: TGroupBox
      Left = 0
      Top = 0
      Width = 792
      Height = 131
      Align = alClient
      Caption = ' '#1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1079#1072#1082#1072#1079#1099' '
      TabOrder = 0
      DesignSize = (
        792
        131)
      object lblPriceAvg: TLabel
        Left = 8
        Top = 110
        Width = 244
        Height = 13
        Caption = #1057#1088#1077#1076#1085#1103#1103' '#1094#1077#1085#1072' '#1087#1086' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1084' '#1079#1072#1082#1072#1079#1072#1084' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtPriceAvg: TDBText
        Left = 258
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
      object dbgHistory: TToughDBGrid
        Left = 2
        Top = 15
        Width = 788
        Height = 90
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
  end
  object plOverCost: TPanel [3]
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
  inline frameLegeng: TframeLegeng [4]
    Left = 0
    Top = 540
    Width = 792
    Height = 33
    Align = alBottom
    Color = clWindow
    ParentColor = False
    TabOrder = 4
    inherited gbLegend: TGroupBox
      Width = 792
      inherited lLeaderLegend: TLabel
        Visible = False
      end
    end
  end
  object dsCore: TDataSource
    DataSet = adsCore
    Left = 64
    Top = 168
  end
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 544
    Top = 168
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
  object adsCoreOld: TpFIBDataSet
    UpdateSQL.Strings = (
      
        'execute procedure updateordercount(:new_ORDERSHORDERID, :clienti' +
        'd, :new_PRICECODE, :new_REGIONCODE, :new_ORDERSORDERID, :new_COR' +
        'EID, :NEW_ORDERCOUNT)')
    SelectSQL.Strings = (
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
      '    0 AS Sale,'
      '    Core.Volume,'
      '    Core.Note,'
      '    Core.BaseCost,'
      '    Core.Quantity,'
      '    Core.Await,'
      '    Core.Junk,'
      
        '    coalesce(Synonyms.SynonymName, catalogs.name || '#39' '#39' || catal' +
        'ogs.form) as SynonymName ,'
      ''
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    -- null as DatePrice,'
      ''
      '    CASE'
      
        '       WHEN (PricesData.DatePrice IS NOT NULL) THEN addminute(Pr' +
        'icesData.DatePrice, -coalesce(:timezonebias, 0))'
      '       ELSE null'
      '    END AS DatePrice,'
      ''
      '    PricesData.PriceName,'
      '    Enabled AS PriceEnabled,'
      '    ClientsDataN.FirmCode AS FirmCode,'
      '    Storage,'
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
      '    osbc.Junk AS OrdersJunk,'
      '    osbc.Await AS OrdersAwait,'
      '    OrdersH.OrderId AS OrdersHOrderId,'
      '    OrdersH.ClientId AS OrdersHClientId,'
      '    OrdersH.PriceCode AS OrdersHPriceCode,'
      '    OrdersH.RegionCode AS OrdersHRegionCode,'
      '    OrdersH.PriceName AS OrdersHPriceName,'
      '    OrdersH.RegionName AS OrdersHRegionName,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    Core.OrderCost,'
      '    Core.MinOrderCount'
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
      
        '    LEFT JOIN ClientsDataN ON PricesData.FirmCode=ClientsDataN.F' +
        'irmCode'
      '    LEFT JOIN Regions ON Core.RegionCode=Regions.RegionCode'
      
        '    LEFT JOIN Orders osbc ON osbc.clientid = :clientid and osbc.' +
        'CoreId = Core.CoreId'
      '    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId'
      'WHERE (upper(synonyms.synonymname) like upper(:LikeParam))'
      'and (Synonyms.synonymcode > 0)')
    AfterPost = adsCoreOldAfterPost
    BeforeEdit = adsCoreOldBeforeEdit
    BeforePost = adsCoreOldBeforePost
    AutoCommit = True
    Left = 64
    Top = 133
    oTrimCharFields = False
    oCacheCalcFields = True
    oRefreshAfterPost = False
    oPersistentSorting = True
    oFetchAll = True
    object adsCoreOldSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreOldPriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreOldPriceDelta: TFloatField
      FieldKind = fkCalculated
      FieldName = 'PriceDelta'
      DisplayFormat = '0.0;;'#39#39
      Calculated = True
    end
    object adsCoreOldCryptBASECOST: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptBASECOST'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreOldCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldSHORTCODE: TFIBBCDField
      FieldName = 'SHORTCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreOldCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreOldPERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = True
    end
    object adsCoreOldSALE: TFIBIntegerField
      FieldName = 'SALE'
    end
    object adsCoreOldVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = True
    end
    object adsCoreOldNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = True
    end
    object adsCoreOldQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = True
    end
    object adsCoreOldAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsCoreOldJUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsCoreOldSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 501
      EmptyStrToNull = True
    end
    object adsCoreOldSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreOldPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsCoreOldPRICEENABLED: TFIBBooleanField
      FieldName = 'PRICEENABLED'
    end
    object adsCoreOldFIRMCODE: TFIBBCDField
      FieldName = 'FIRMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldSTORAGE: TFIBBooleanField
      FieldName = 'STORAGE'
      OnGetText = adsCoreOldSTORAGEGetText
    end
    object adsCoreOldREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsCoreOldORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSCLIENTID: TFIBBCDField
      FieldName = 'ORDERSCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSFULLCODE: TFIBBCDField
      FieldName = 'ORDERSFULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSCODEFIRMCR: TFIBBCDField
      FieldName = 'ORDERSCODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSSYNONYMCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSCODE: TFIBStringField
      FieldName = 'ORDERSCODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreOldORDERSCODECR: TFIBStringField
      FieldName = 'ORDERSCODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreOldORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
      DisplayFormat = '#'
    end
    object adsCoreOldORDERSSYNONYM: TFIBStringField
      FieldName = 'ORDERSSYNONYM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreOldORDERSSYNONYMFIRM: TFIBStringField
      FieldName = 'ORDERSSYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreOldORDERSJUNK: TFIBBooleanField
      FieldName = 'ORDERSJUNK'
    end
    object adsCoreOldORDERSAWAIT: TFIBBooleanField
      FieldName = 'ORDERSAWAIT'
    end
    object adsCoreOldORDERSHORDERID: TFIBBCDField
      FieldName = 'ORDERSHORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSHCLIENTID: TFIBBCDField
      FieldName = 'ORDERSHCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSHPRICECODE: TFIBBCDField
      FieldName = 'ORDERSHPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSHREGIONCODE: TFIBBCDField
      FieldName = 'ORDERSHREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldORDERSHPRICENAME: TFIBStringField
      FieldName = 'ORDERSHPRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsCoreOldORDERSHREGIONNAME: TFIBStringField
      FieldName = 'ORDERSHREGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsCoreOldFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsCoreOldBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 60
      EmptyStrToNull = True
    end
    object adsCoreOldORDERSPRICE: TFIBStringField
      FieldName = 'ORDERSPRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsCoreOldDOC: TFIBStringField
      FieldName = 'DOC'
      EmptyStrToNull = True
    end
    object adsCoreOldREGISTRYCOST: TFIBFloatField
      FieldName = 'REGISTRYCOST'
      DisplayFormat = '#'
    end
    object adsCoreOldVITALLYIMPORTANT: TFIBBooleanField
      FieldName = 'VITALLYIMPORTANT'
    end
    object adsCoreOldREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
      DisplayFormat = '#'
    end
    object adsCoreOldORDERCOST: TFIBBCDField
      FieldName = 'ORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsCoreOldMINORDERCOUNT: TFIBIntegerField
      FieldName = 'MINORDERCOUNT'
    end
    object adsCoreOldPRODUCTID: TFIBBCDField
      FieldName = 'PRODUCTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldSortOrder: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'SortOrder'
      Calculated = True
    end
  end
  object tmrSearch: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmrSearchTimer
    Left = 488
    Top = 165
  end
  object pmSelectedPrices: TPopupMenu
    Left = 520
    Top = 48
    object miSelectAll: TMenuItem
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077#1093
      OnClick = miSelectAllClick
    end
    object miUnselecAll: TMenuItem
      Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1074#1089#1077#1093
      OnClick = miUnselecAllClick
    end
    object miSep: TMenuItem
      Caption = '-'
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
    Left = 384
    Top = 460
    WaitEndMasterScroll = True
    dcForceOpen = True
    oCacheCalcFields = True
    object adsOrdersShowFormSummaryOldPRICEAVG: TFIBBCDField
      FieldName = 'PRICEAVG'
      Size = 2
      RoundByScale = True
    end
  end
  object adsOrdersOld: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    FULLCODE,'
      '    CODE,'
      '    CODECR,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    ORDERCOUNT,'
      '    PRICE,'
      '    ORDERDATE,'
      '    PRICENAME,'
      '    REGIONNAME,'
      '    AWAIT,'
      '    JUNK,'
      '    sendprice'
      'FROM'
      '    ORDERSSHOWBYFORM(:FULLCODE,'
      '    :CLIENTID) ')
    Left = 168
    Top = 468
    WaitEndMasterScroll = True
    dcForceOpen = True
    oTrimCharFields = False
    oCacheCalcFields = True
    object adsOrdersOldFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersOldSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsOrdersOldSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsOrdersOldORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsOrdersOldORDERDATE: TFIBDateTimeField
      FieldName = 'ORDERDATE'
      DisplayFormat = 'dd.mm.yyyy hh:mm AMPM'
    end
    object adsOrdersOldPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsOrdersOldREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsOrdersOldAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsOrdersOldJUNK: TFIBIntegerField
      FieldName = 'JUNK'
    end
    object adsOrdersOldCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsOrdersOldCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsOrdersOldPRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsOrdersOldSENDPRICE: TFIBBCDField
      FieldName = 'SENDPRICE'
      Size = 2
      RoundByScale = True
    end
  end
  object dsPreviosOrders: TDataSource
    DataSet = adsPreviosOrders
    Left = 160
    Top = 496
  end
  object dsAvgOrders: TDataSource
    DataSet = adsAvgOrders
    Left = 344
    Top = 480
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
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
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
      '    GroupMaxProducerCosts.MaxProducerCost'
      'FROM'
      '    Synonyms'
      '    inner join Core on (Core.SynonymCode = Synonyms.synonymcode)'
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
        's.OrderId'
      'WHERE '
      '  Core.CoreID = :CoreId')
    Connection = DM.MyConnection
    SQL.Strings = (
      'drop temporary table if exists SynonymSearch;'
      'create temporary table SynonymSearch ENGINE=MEMORY'
      'as'
      'SELECT'
      '    Core.CoreId,'
      '    Core.PriceCode,'
      '    Core.RegionCode,'
      '    Core.ProductID,'
      '    catalogs.FullCode AS FullCode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
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
      '    GroupMaxProducerCosts.MaxProducerCost'
      'FROM'
      '  ('
      
        '  (select * from Synonyms where (synonyms.synonymname LIKE :Like' +
        'Param)) as Synonyms,'
      '  #Synonyms,'
      '  Core,'
      '  products,'
      '  catalogs,'
      '  PricesData,'
      '  PricesRegionalData PRD,'
      '  Providers,'
      '  Regions'
      '  )'
      
        '  LEFT JOIN SynonymFirmCr ON (SynonymFirmCr.SynonymFirmCrCode = ' +
        'Core.SynonymFirmCrCode)'
      '  left join Mnn on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = Core.productid) '
      '      and (Core.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      
        '  LEFT JOIN CurrentOrderLists osbc ON (osbc.CoreId = Core.CoreId' +
        ') AND (osbc.clientid = :clientid)'
      
        '  left join DelayOfPayments dop on (dop.FirmCode = Providers.Fir' +
        'mCode) '
      
        '  LEFT JOIN CurrentOrderHeads ON (CurrentOrderHeads.ClientId = o' +
        'sbc.ClientId) AND (CurrentOrderHeads.OrderId = osbc.OrderId)'
      'WHERE'
      '  #(synonyms.synonymname LIKE :LikeParam)'
      '  #AND (Synonyms.synonymcode > 0)'
      '  #and '
      '  (Core.SynonymCode = Synonyms.synonymcode)'
      '  AND (products.productid = core.productid)'
      '  AND (catalogs.fullcode = products.catalogid)'
      '  AND (Core.PriceCode = PricesData.PriceCode)'
      '  AND (Core.RegionCode = PRD.RegionCode)'
      '  AND (Core.PriceCode = PRD.PriceCode)'
      '  AND (PricesData.FirmCode = Providers.FirmCode)'
      '  AND (Core.RegionCode = Regions.RegionCode);'
      'drop temporary table if exists SynonymSearchGroup;'
      'create temporary table SynonymSearchGroup ENGINE=MEMORY'
      'as'
      'select'
      '  ProductID,'
      '  Min(Cost) as MinCost'
      'from'
      '  SynonymSearch'
      'group by ProductID'
      'order by 2;'
      'set @ColorNumber := 0;'
      'drop temporary table if exists SynonymSearchGroupColor;'
      'create temporary table SynonymSearchGroupColor ENGINE=MEMORY'
      'as'
      'select'
      '  SynonymSearchGroup.*,'
      '  @ColorNumber := @ColorNumber + 1 as ColorIndex'
      'from'
      '  SynonymSearchGroup;'
      'select'
      ' SynonymSearch.*,'
      ' SynonymSearchGroupColor.ColorIndex '
      'from'
      ' SynonymSearch,'
      ' SynonymSearchGroupColor'
      'where'
      '  (SynonymSearch.ProductId = SynonymSearchGroupColor.ProductId)')
    BeforeUpdateExecute = BeforeUpdateExecuteForClientID
    RefreshOptions = [roAfterUpdate]
    AfterOpen = adsCoreAfterOpen
    BeforeClose = adsCoreBeforeClose
    BeforeEdit = adsCoreOldBeforeEdit
    BeforePost = adsCoreOldBeforePost
    AfterPost = adsCoreOldAfterPost
    AfterScroll = adsCoreAfterScroll
    Left = 104
    Top = 133
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TimeZoneBias'
      end
      item
        DataType = ftUnknown
        Name = 'LikeParam'
      end
      item
        DataType = ftUnknown
        Name = 'clientid'
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
    object adsCoreProductID: TLargeintField
      FieldName = 'ProductID'
    end
    object adsCoreFullCode: TLargeintField
      FieldName = 'FullCode'
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
    object adsCoreOrderCost: TFloatField
      FieldName = 'OrderCost'
    end
    object adsCoreMinOrderCount: TIntegerField
      FieldName = 'MinOrderCount'
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
      Calculated = True
    end
    object adsCoreSortOrder: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'SortOrder'
      Calculated = True
    end
    object adsCoreColorIndex: TLargeintField
      FieldName = 'ColorIndex'
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
    object adsCoreMnn: TStringField
      FieldName = 'Mnn'
      Size = 250
    end
    object adsCoreMnnId: TLargeintField
      FieldName = 'MnnId'
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
      '    osbc.Junk'
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
    Top = 465
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
        Name = 'FullCode'
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
    object adsPreviosOrdersPrice: TFloatField
      FieldName = 'Price'
    end
    object adsPreviosOrdersOrderDate: TDateTimeField
      FieldName = 'OrderDate'
      DisplayFormat = 'dd.mm.yyyy hh:mm AMPM'
    end
    object adsPreviosOrdersPriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsPreviosOrdersRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsPreviosOrdersAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsPreviosOrdersJunk: TBooleanField
      FieldName = 'Junk'
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
    MasterSource = dsCore
    MasterFields = 'ProductID'
    DetailFields = 'PRODUCTID'
    Left = 424
    Top = 457
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
  object tmrUpdatePreviosOrders: TTimer
    Enabled = False
    Interval = 700
    OnTimer = tmrUpdatePreviosOrdersTimer
    Left = 592
    Top = 173
  end
  object tmrSelectedPrices: TTimer
    Enabled = False
    OnTimer = tmrSelectedPricesTimer
    Left = 656
    Top = 173
  end
  object adsCoreStartSQL: TMyQuery
    SQL.Strings = (
      'drop temporary table if exists SynonymSearch;'
      'create temporary table SynonymSearch ENGINE=MEMORY'
      'as'
      'SELECT'
      '    Core.CoreId,'
      '    Core.PriceCode,'
      '    Core.RegionCode,'
      '    Core.ProductID,'
      '    catalogs.FullCode AS FullCode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
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
      '    GroupMaxProducerCosts.MaxProducerCost'
      'FROM'
      '  ('
      
        '  (select * from Synonyms where (synonyms.synonymname LIKE :Like' +
        'Param)) as Synonyms,'
      '  Core,'
      '  products,'
      '  catalogs,'
      '  PricesData,'
      '  PricesRegionalData PRD,'
      '  Providers,'
      '  Regions'
      '  )'
      
        '  LEFT JOIN SynonymFirmCr ON (SynonymFirmCr.SynonymFirmCrCode = ' +
        'Core.SynonymFirmCrCode)'
      '  left join Mnn on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = Core.productid) '
      '      and (Core.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      
        '  LEFT JOIN CurrentOrderLists osbc ON (osbc.CoreId = Core.CoreId' +
        ') AND (osbc.clientid = :clientid)'
      
        '  left join DelayOfPayments dop on (dop.FirmCode = Providers.Fir' +
        'mCode) '
      
        '  LEFT JOIN CurrentOrderHeads ON (CurrentOrderHeads.ClientId = o' +
        'sbc.ClientId) AND (CurrentOrderHeads.OrderId = osbc.OrderId)'
      'WHERE'
      '  (Core.SynonymCode = Synonyms.synonymcode)'
      '  AND (products.productid = core.productid)'
      '  AND (catalogs.fullcode = products.catalogid)'
      '  AND (Core.PriceCode = PricesData.PriceCode)'
      '  AND (Core.RegionCode = PRD.RegionCode)'
      '  AND (Core.PriceCode = PRD.PriceCode)'
      '  AND (PricesData.FirmCode = Providers.FirmCode)'
      '  AND (Core.RegionCode = Regions.RegionCode)')
    Left = 160
    Top = 125
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TimeZoneBias'
      end
      item
        DataType = ftUnknown
        Name = 'LikeParam'
      end
      item
        DataType = ftUnknown
        Name = 'clientid'
      end>
  end
  object adsCoreByProducts: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'drop temporary table if exists SynonymSearchGroup;'
      'create temporary table SynonymSearchGroup ENGINE=MEMORY'
      'as'
      'select'
      '  ProductID,'
      '  Min(Cost) as MinCost'
      'from'
      '  SynonymSearch'
      'group by ProductID'
      'order by 2;'
      'set @ColorNumber := 0;'
      'drop temporary table if exists SynonymSearchGroupColor;'
      'create temporary table SynonymSearchGroupColor ENGINE=MEMORY'
      'as'
      'select'
      '  SynonymSearchGroup.*,'
      '  @ColorNumber := @ColorNumber + 1 as ColorIndex'
      'from'
      '  SynonymSearchGroup;'
      'select'
      ' SynonymSearch.*,'
      ' SynonymSearchGroupColor.ColorIndex '
      'from'
      ' SynonymSearch,'
      ' SynonymSearchGroupColor'
      'where'
      '  (SynonymSearch.ProductId = SynonymSearchGroupColor.ProductId)'
      'order by SynonymSearchGroupColor.ColorIndex, SynonymSearch.Cost;')
    Left = 152
    Top = 173
  end
  object adsCoreByFullcode: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'drop temporary table if exists SynonymSearchGroup;'
      'create temporary table SynonymSearchGroup ENGINE=MEMORY'
      'as'
      'select'
      '  Fullcode,'
      '  Min(Cost) as MinCost'
      'from'
      '  SynonymSearch'
      'group by Fullcode'
      'order by 2;'
      'set @ColorNumber := 0;'
      'drop temporary table if exists SynonymSearchGroupColor;'
      'create temporary table SynonymSearchGroupColor ENGINE=MEMORY'
      'as'
      'select'
      '  SynonymSearchGroup.*,'
      '  @ColorNumber := @ColorNumber + 1 as ColorIndex'
      'from'
      '  SynonymSearchGroup;'
      'select'
      ' SynonymSearch.*,'
      ' SynonymSearchGroupColor.ColorIndex '
      'from'
      ' SynonymSearch,'
      ' SynonymSearchGroupColor'
      'where'
      '  (SynonymSearch.Fullcode = SynonymSearchGroupColor.Fullcode)'
      'order by SynonymSearchGroupColor.ColorIndex, SynonymSearch.Cost;')
    Left = 192
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
      '  prod.*'
      'from'
      '('
      'SELECT '
      '  p.Id,'
      '  p.Name'
      'FROM'
      '  Producers p'
      'order by p.Name'
      ') prod')
    Left = 384
    Top = 253
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
