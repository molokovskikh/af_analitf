object CoreFirmForm: TCoreFirmForm
  Left = 256
  Top = 152
  ActiveControl = dbgCore
  Align = alClient
  Anchors = [akTop, akBottom]
  BorderIcons = []
  BorderStyle = bsNone
  Caption = #1047#1072#1103#1074#1082#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
  ClientHeight = 551
  ClientWidth = 768
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
    Left = 248
    Top = 192
    Width = 305
    Height = 57
    Caption = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1089#1088#1077#1076#1085#1077#1081' '#1094#1077#1085#1099'!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Visible = False
  end
  object dbgCore: TToughDBGrid
    Left = 0
    Top = 29
    Width = 768
    Height = 484
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
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnGetCellParams = dbgCoreGetCellParams
    OnKeyDown = dbgCoreKeyDown
    SearchField = 'SynonymName'
    InputField = 'OrderCount'
    SearchPosition = spTop
    ForceRus = True
    FindInterval = 2500
    OnSortChange = dbgCoreSortChange
    OnCanInput = dbgCoreCanInput
    Columns = <
      item
        EditButtons = <>
        FieldName = 'CODE'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1050#1086#1076
        Title.TitleButton = True
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'SYNONYMNAME'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 117
      end
      item
        EditButtons = <>
        FieldName = 'SYNONYMFIRM'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Title.TitleButton = True
        Width = 92
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'VOLUME'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
        Title.TitleButton = True
        Width = 87
      end
      item
        EditButtons = <>
        FieldName = 'DOC'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1044#1086#1082#1091#1084#1077#1085#1090
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'NOTE'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 118
      end
      item
        Alignment = taCenter
        EditButtons = <>
        FieldName = 'PERIOD'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1057#1088#1086#1082'. '#1075#1086#1076#1085'.'
        Title.TitleButton = True
        Width = 77
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
        MinWidth = 5
        Title.Caption = #1062#1077#1085#1072
        Title.TitleButton = True
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'QUANTITY'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'PRICERET'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'MINPRICE'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1052#1080#1085'. '#1094#1077#1085#1072
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'LEADERPRICENAME'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1055#1088#1072#1081#1089' - '#1083#1080#1076#1077#1088
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'LEADERREGIONNAME'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1056#1077#1075#1080#1086#1085' - '#1083#1080#1076#1077#1088
        Title.TitleButton = True
      end
      item
        Color = 16775406
        EditButtons = <>
        FieldName = 'ORDERCOUNT'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1047#1072#1082#1072#1079
      end
      item
        Color = 16775406
        EditButtons = <>
        FieldName = 'SumOrder'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1057#1091#1084#1084#1072
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 513
    Width = 768
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      768
      38)
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 768
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
    Width = 768
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      768
      29)
    object lblRecordCount: TLabel
      Left = 486
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
    object cbFilter: TComboBox
      Left = 605
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
      ShortCut = 113
      OnExecute = actFlipCoreExecute
    end
  end
  object frdsCore: TfrDBDataSet
    DataSource = dsCore
    Left = 88
    Top = 192
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
    Left = 280
    Top = 80
  end
  object adsCountFields2: TADODataSet
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM CoreCountPriceFields'
    Parameters = <
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
    Left = 208
    Top = 80
  end
  object adsOrdersShowFormSummary2: TADODataSet
    CursorLocation = clUseServer
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM OrdersShowFormSummary'
    DataSource = dsCore
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
    Left = 200
    Top = 216
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
    Left = 640
    Top = 216
  end
  object adsCore2: TADODataSet
    AutoCalcFields = False
    CursorLocation = clUseServer
    AfterOpen = adsCore2AfterOpen
    BeforeClose = adsCore2BeforeClose
    BeforeEdit = adsCore2BeforeEdit
    BeforePost = adsCore2BeforePost
    AfterPost = adsCore2AfterPost
    OnCalcFields = adsCore2CalcFields
    CommandText = 'SELECT * FROM CoreShowByFirm'
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
        Name = 'RetailForcount'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '30'
      end
      item
        Name = 'APriceCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '7'
      end
      item
        Name = 'ARegionCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '1'
      end>
    Prepared = True
    Left = 88
    Top = 72
    object adsCore2CoreId: TAutoIncField
      FieldName = 'CoreId'
      ReadOnly = True
    end
    object adsCore2FullCode: TIntegerField
      FieldName = 'FullCode'
    end
    object adsCore2ShortCode: TIntegerField
      FieldName = 'ShortCode'
    end
    object adsCore2CodeFirmCr: TIntegerField
      FieldName = 'CodeFirmCr'
    end
    object adsCore2SynonymCode: TIntegerField
      FieldName = 'SynonymCode'
    end
    object adsCore2SynonymFirmCrCode: TIntegerField
      FieldName = 'SynonymFirmCrCode'
    end
    object adsCore2Code: TWideStringField
      FieldName = 'Code'
    end
    object adsCore2CodeCr: TWideStringField
      FieldName = 'CodeCr'
    end
    object adsCore2Volume: TWideStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsCore2Doc: TWideStringField
      FieldName = 'Doc'
    end
    object adsCore2Note: TWideStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsCore2Period: TWideStringField
      FieldName = 'Period'
    end
    object adsCore2Await: TBooleanField
      FieldName = 'Await'
    end
    object adsCore2Junk: TBooleanField
      FieldName = 'Junk'
    end
    object adsCore2BaseCost: TBCDField
      FieldName = 'BaseCost'
      Precision = 19
    end
    object adsCore2Quantity: TWideStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsCore2Synonym: TWideStringField
      FieldName = 'Synonym'
      Size = 255
    end
    object adsCore2SynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsCore2MinPrice: TBCDField
      FieldName = 'MinPrice'
      Precision = 19
    end
    object adsCore2LeaderFirmCode: TIntegerField
      FieldName = 'LeaderPriceCode'
    end
    object adsCore2LeaderRegionCode: TIntegerField
      FieldName = 'LeaderRegionCode'
    end
    object adsCore2LeaderRegionName: TWideStringField
      FieldName = 'LeaderRegionName'
      Size = 25
    end
    object adsCore2LeaderPriceName: TWideStringField
      FieldName = 'LeaderPriceName'
      Size = 70
    end
    object adsCore2OrdersCoreId: TIntegerField
      FieldName = 'OrdersCoreId'
    end
    object adsCore2OrdersOrderId: TIntegerField
      FieldName = 'OrdersOrderId'
    end
    object adsCore2OrdersClientId: TSmallintField
      FieldName = 'OrdersClientId'
    end
    object adsCore2OrdersFullCode: TIntegerField
      FieldName = 'OrdersFullCode'
    end
    object adsCore2OrdersCodeFirmCr: TIntegerField
      FieldName = 'OrdersCodeFirmCr'
    end
    object adsCore2OrdersSynonymCode: TIntegerField
      FieldName = 'OrdersSynonymCode'
    end
    object adsCore2OrdersSynonymFirmCrCode: TIntegerField
      FieldName = 'OrdersSynonymFirmCrCode'
    end
    object adsCore2OrdersCode: TWideStringField
      FieldName = 'OrdersCode'
    end
    object adsCore2OrdersCodeCr: TWideStringField
      FieldName = 'OrdersCodeCr'
    end
    object adsCore2Order: TIntegerField
      FieldName = 'Order'
      DisplayFormat = '#'
    end
    object adsCore2OrdersSynonym: TWideStringField
      FieldName = 'OrdersSynonym'
      Size = 255
    end
    object adsCore2OrdersSynonymFirm: TWideStringField
      FieldName = 'OrdersSynonymFirm'
      Size = 50
    end
    object adsCore2OrdersPrice: TBCDField
      FieldName = 'OrdersPrice'
      Precision = 19
    end
    object adsCore2OrdersJunk: TBooleanField
      FieldName = 'OrdersJunk'
    end
    object adsCore2OrdersAwait: TBooleanField
      FieldName = 'OrdersAwait'
    end
    object adsCore2OrdersHOrderId: TAutoIncField
      FieldName = 'OrdersHOrderId'
      ReadOnly = True
    end
    object adsCore2OrdersHClientId: TSmallintField
      FieldName = 'OrdersHClientId'
    end
    object adsCore2OrdersHPriceCode: TIntegerField
      FieldName = 'OrdersHPriceCode'
    end
    object adsCore2OrdersHRegionCode: TIntegerField
      FieldName = 'OrdersHRegionCode'
    end
    object adsCore2OrdersHPriceName: TWideStringField
      FieldName = 'OrdersHPriceName'
      Size = 25
    end
    object adsCore2OrdersHRegionName: TWideStringField
      FieldName = 'OrdersHRegionName'
      Size = 25
    end
    object adsCore2PriceRet: TFloatField
      FieldName = 'PriceRet'
      ReadOnly = True
    end
    object adsCore2SumOrder: TBCDField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
      Calculated = True
    end
  end
  object adsCore: TpFIBDataSet
    UpdateSQL.Strings = (
      
        'execute procedure updateordercount(:new_ORDERSHORDERID, :Aclient' +
        'id, :APRICECODE, :AREGIONCODE, :new_ORDERSORDERID, :new_COREID, ' +
        ':NEW_ORDERCOUNT)')
    RefreshSQL.Strings = (
      'SELECT'
      '    COREID,'
      '    FULLCODE,'
      '    SHORTCODE,'
      '    CODEFIRMCR,'
      '    SYNONYMCODE,'
      '    SYNONYMFIRMCRCODE,'
      '    CODE,'
      '    CODECR,'
      '    VOLUME,'
      '    DOC,'
      '    NOTE,'
      '    PERIOD,'
      '    AWAIT,'
      '    JUNK,'
      '    BASECOST,'
      '    QUANTITY,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    MINPRICE,'
      '    LEADERPRICECODE,'
      '    LEADERREGIONCODE,'
      '    LEADERREGIONNAME,'
      '    LEADERPRICENAME,'
      '    ORDERSCOREID,'
      '    ORDERSORDERID,'
      '    ORDERSCLIENTID,'
      '    ORDERSFULLCODE,'
      '    ORDERSCODEFIRMCR,'
      '    ORDERSSYNONYMCODE,'
      '    ORDERSSYNONYMFIRMCRCODE,'
      '    ORDERSCODE,'
      '    ORDERSCODECR,'
      '    ORDERCOUNT,'
      '    ORDERSSYNONYM,'
      '    ORDERSSYNONYMFIRM,'
      '    ORDERSPRICE,'
      '    ORDERSJUNK,'
      '    ORDERSAWAIT,'
      '    ORDERSHORDERID,'
      '    ORDERSHCLIENTID,'
      '    ORDERSHPRICECODE,'
      '    ORDERSHREGIONCODE,'
      '    ORDERSHPRICENAME,'
      '    ORDERSHREGIONNAME,'
      '    PRICERET'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :RETAILFORCOUNT,'
      '    :ACLIENTID) '
      'where'
      '  CoreID = :OLD_COREID')
    SelectSQL.Strings = (
      'SELECT'
      '    COREID,'
      '    FULLCODE,'
      '    SHORTCODE,'
      '    CODEFIRMCR,'
      '    SYNONYMCODE,'
      '    SYNONYMFIRMCRCODE,'
      '    CODE,'
      '    CODECR,'
      '    VOLUME,'
      '    DOC,'
      '    NOTE,'
      '    PERIOD,'
      '    AWAIT,'
      '    JUNK,'
      '    BASECOST,'
      '    QUANTITY,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    MINPRICE,'
      '    LEADERPRICECODE,'
      '    LEADERREGIONCODE,'
      '    LEADERREGIONNAME,'
      '    LEADERPRICENAME,'
      '    ORDERSCOREID,'
      '    ORDERSORDERID,'
      '    ORDERSCLIENTID,'
      '    ORDERSFULLCODE,'
      '    ORDERSCODEFIRMCR,'
      '    ORDERSSYNONYMCODE,'
      '    ORDERSSYNONYMFIRMCRCODE,'
      '    ORDERSCODE,'
      '    ORDERSCODECR,'
      '    ORDERCOUNT,'
      '    ORDERSSYNONYM,'
      '    ORDERSSYNONYMFIRM,'
      '    ORDERSPRICE,'
      '    ORDERSJUNK,'
      '    ORDERSAWAIT,'
      '    ORDERSHORDERID,'
      '    ORDERSHCLIENTID,'
      '    ORDERSHPRICECODE,'
      '    ORDERSHREGIONCODE,'
      '    ORDERSHPRICENAME,'
      '    ORDERSHREGIONNAME,'
      '    PRICERET'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :RETAILFORCOUNT,'
      '    :ACLIENTID) ')
    AfterOpen = adsCore2AfterOpen
    AfterPost = adsCore2AfterPost
    BeforeClose = adsCore2BeforeClose
    BeforeEdit = adsCore2BeforeEdit
    BeforePost = adsCore2BeforePost
    OnCalcFields = adsCore2CalcFields
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    AutoCommit = True
    Left = 88
    Top = 112
    object adsCoreCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreSHORTCODE: TFIBBCDField
      FieldName = 'SHORTCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsCoreSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreCODE: TFIBStringField
      FieldName = 'CODE'
      EmptyStrToNull = False
    end
    object adsCoreCODECR: TFIBStringField
      FieldName = 'CODECR'
      EmptyStrToNull = False
    end
    object adsCoreVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = False
    end
    object adsCoreDOC: TFIBStringField
      FieldName = 'DOC'
      EmptyStrToNull = False
    end
    object adsCoreNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = False
    end
    object adsCorePERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = False
    end
    object adsCoreAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsCoreJUNK: TFIBIntegerField
      FieldName = 'JUNK'
    end
    object adsCoreBASECOST: TFIBBCDField
      FieldName = 'BASECOST'
      DisplayFormat = '0.00;;'#39#39
      Size = 4
      RoundByScale = True
    end
    object adsCoreQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = False
    end
    object adsCoreSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = False
    end
    object adsCoreSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = False
    end
    object adsCoreMINPRICE: TFIBIntegerField
      FieldName = 'MINPRICE'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCoreLEADERPRICECODE: TFIBBCDField
      FieldName = 'LEADERPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreLEADERREGIONCODE: TFIBBCDField
      FieldName = 'LEADERREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreLEADERREGIONNAME: TFIBStringField
      FieldName = 'LEADERREGIONNAME'
      Size = 25
      EmptyStrToNull = False
    end
    object adsCoreLEADERPRICENAME: TFIBStringField
      FieldName = 'LEADERPRICENAME'
      Size = 70
      EmptyStrToNull = False
    end
    object adsCoreORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSCLIENTID: TFIBBCDField
      FieldName = 'ORDERSCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSFULLCODE: TFIBBCDField
      FieldName = 'ORDERSFULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSCODEFIRMCR: TFIBBCDField
      FieldName = 'ORDERSCODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSSYNONYMCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSCODE: TFIBStringField
      FieldName = 'ORDERSCODE'
      EmptyStrToNull = False
    end
    object adsCoreORDERSCODECR: TFIBStringField
      FieldName = 'ORDERSCODECR'
      EmptyStrToNull = False
    end
    object adsCoreORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
      DisplayFormat = '#'
    end
    object adsCoreORDERSSYNONYM: TFIBStringField
      FieldName = 'ORDERSSYNONYM'
      Size = 250
      EmptyStrToNull = False
    end
    object adsCoreORDERSSYNONYMFIRM: TFIBStringField
      FieldName = 'ORDERSSYNONYMFIRM'
      Size = 250
      EmptyStrToNull = False
    end
    object adsCoreORDERSPRICE: TFIBBCDField
      FieldName = 'ORDERSPRICE'
      Size = 4
      RoundByScale = True
    end
    object adsCoreORDERSJUNK: TFIBIntegerField
      FieldName = 'ORDERSJUNK'
    end
    object adsCoreORDERSAWAIT: TFIBIntegerField
      FieldName = 'ORDERSAWAIT'
    end
    object adsCoreORDERSHORDERID: TFIBBCDField
      FieldName = 'ORDERSHORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHCLIENTID: TFIBBCDField
      FieldName = 'ORDERSHCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHPRICECODE: TFIBBCDField
      FieldName = 'ORDERSHPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHREGIONCODE: TFIBBCDField
      FieldName = 'ORDERSHREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHPRICENAME: TFIBStringField
      FieldName = 'ORDERSHPRICENAME'
      Size = 70
      EmptyStrToNull = False
    end
    object adsCoreORDERSHREGIONNAME: TFIBStringField
      FieldName = 'ORDERSHREGIONNAME'
      Size = 25
      EmptyStrToNull = False
    end
    object adsCorePRICERET: TFIBBCDField
      FieldName = 'PRICERET'
      DisplayFormat = '0.00;;'#39#39
      Size = 4
      RoundByScale = True
    end
    object adsCoreSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
  end
  object adsCountFields: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    CCOUNT,'
      '    CODE,'
      '    SYNONYMFIRM,'
      '    VOLUME,'
      '    DOC,'
      '    NOTE,'
      '    PERIOD,'
      '    QUANTITY'
      'FROM'
      '    CORECOUNTPRICEFIELDS(:AREGIONCODE,'
      '    :APRICECODE) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 208
    Top = 128
    oFetchAll = True
  end
  object adsOrdersH: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ORDERID,'
      '    SERVERORDERID,'
      '    CLIENTID,'
      '    PRICECODE,'
      '    REGIONCODE,'
      '    PRICENAME,'
      '    REGIONNAME,'
      '    ORDERDATE,'
      '    SENDDATE,'
      '    CLOSED,'
      '    SEND,'
      '    COMMENTS,'
      '    MESSAGETO'
      'FROM'
      '    ORDERSHSHOWCURRENT(:ACLIENTID,'
      '    :APRICECODE,'
      '    :AREGIONCODE) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 280
    Top = 120
    oFetchAll = True
  end
  object adsOrdersShowFormSummary: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    PRICEAVG'
      'FROM'
      '    ORDERSSHOWFORMSUMMARY(:FULLCODE,'
      '    :ACLIENTID) ')
    DataSource = dsCore
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 200
    Top = 264
    WaitEndMasterScroll = True
    object adsOrdersShowFormSummaryPRICEAVG: TFIBIntegerField
      FieldName = 'PRICEAVG'
    end
  end
end
