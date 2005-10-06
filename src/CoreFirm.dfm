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
    OnKeyPress = dbgCoreKeyPress
    SearchField = 'CryptSynonymName'
    InputField = 'OrderCount'
    SearchPosition = spTop
    ForceRus = True
    FindInterval = 2500
    OnSortChange = dbgCoreSortChange
    OnCanInput = dbgCoreCanInput
    Columns = <
      item
        EditButtons = <>
        FieldName = 'CryptCODE'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1050#1086#1076
        Title.TitleButton = True
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'CryptSYNONYMNAME'
        Footers = <>
        MinWidth = 5
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 117
      end
      item
        EditButtons = <>
        FieldName = 'CryptSYNONYMFIRM'
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
        FieldName = 'CryptBASECOST'
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
        FieldName = 'PriceRet'
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
      '    :ACLIENTID,'
      '    :APRICENAME) '
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
      '    ORDERSHREGIONNAME'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :ACLIENTID,'
      '    :APRICENAME) ')
    AutoCalcFields = False
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
      Size = 84
      EmptyStrToNull = False
    end
    object adsCoreCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
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
    object adsCoreMINPRICE: TFIBBCDField
      FieldName = 'MINPRICE'
      Size = 2
      RoundByScale = True
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
      Size = 84
      EmptyStrToNull = False
    end
    object adsCoreORDERSCODECR: TFIBStringField
      FieldName = 'ORDERSCODECR'
      Size = 84
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
    object adsCoreSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreCryptSYNONYMNAME: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptSYNONYMNAME'
      Size = 250
      Calculated = True
    end
    object adsCoreCryptSYNONYMFIRM: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptSYNONYMFIRM'
      Size = 250
      Calculated = True
    end
    object adsCoreCryptBASECOST: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptBASECOST'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCorePriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreCryptCODE: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptCODE'
      Calculated = True
    end
    object adsCoreCryptCODECR: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptCODECR'
      Calculated = True
    end
    object adsCoreCryptORDERSSYNONYM: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptORDERSSYNONYM'
      Calculated = True
    end
    object adsCoreCryptORDERSSYNONYMFIRM: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptORDERSSYNONYMFIRM'
      Calculated = True
    end
    object adsCoreCryptORDERSCODE: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptORDERSCODE'
      Calculated = True
    end
    object adsCoreCryptORDERSCODECR: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptORDERSCODECR'
      Calculated = True
    end
    object adsCoreBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 48
      EmptyStrToNull = False
    end
    object adsCoreORDERSPRICE: TFIBStringField
      FieldName = 'ORDERSPRICE'
      Size = 48
      EmptyStrToNull = False
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
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 640
    Top = 216
  end
  object mdCore: TRxMemoryData
    FieldDefs = <
      item
        Name = 'COREID'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'FULLCODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'SHORTCODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'CODEFIRMCR'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'SYNONYMCODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'SYNONYMFIRMCRCODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'CODE'
        DataType = ftString
        Size = 84
      end
      item
        Name = 'CODECR'
        DataType = ftString
        Size = 84
      end
      item
        Name = 'VOLUME'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'DOC'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'NOTE'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'PERIOD'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'AWAIT'
        DataType = ftInteger
      end
      item
        Name = 'JUNK'
        DataType = ftInteger
      end
      item
        Name = 'BASECOST'
        DataType = ftString
        Size = 48
      end
      item
        Name = 'QUANTITY'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'SYNONYMNAME'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'SYNONYMFIRM'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'MINPRICE'
        DataType = ftBCD
        Size = 2
      end
      item
        Name = 'LEADERPRICECODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'LEADERREGIONCODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'LEADERREGIONNAME'
        DataType = ftString
        Size = 25
      end
      item
        Name = 'LEADERPRICENAME'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'ORDERSCOREID'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSORDERID'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSCLIENTID'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSFULLCODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSCODEFIRMCR'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSSYNONYMCODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSSYNONYMFIRMCRCODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSCODE'
        DataType = ftString
        Size = 84
      end
      item
        Name = 'ORDERSCODECR'
        DataType = ftString
        Size = 84
      end
      item
        Name = 'ORDERCOUNT'
        DataType = ftInteger
      end
      item
        Name = 'ORDERSSYNONYM'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'ORDERSSYNONYMFIRM'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'ORDERSPRICE'
        DataType = ftString
        Size = 48
      end
      item
        Name = 'ORDERSJUNK'
        DataType = ftInteger
      end
      item
        Name = 'ORDERSAWAIT'
        DataType = ftInteger
      end
      item
        Name = 'ORDERSHORDERID'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSHCLIENTID'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSHPRICECODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSHREGIONCODE'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'ORDERSHPRICENAME'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'ORDERSHREGIONNAME'
        DataType = ftString
        Size = 25
      end>
    BeforeEdit = mdCoreBeforeEdit
    BeforePost = mdCoreBeforePost
    AfterPost = mdCoreAfterPost
    OnCalcFields = mdCoreCalcFields
    Left = 264
    Top = 208
    object mdCoreCOREID: TBCDField
      FieldName = 'COREID'
      Size = 0
    end
    object mdCoreFULLCODE: TBCDField
      FieldName = 'FULLCODE'
      Size = 0
    end
    object mdCoreSHORTCODE: TBCDField
      FieldName = 'SHORTCODE'
      Size = 0
    end
    object mdCoreCODEFIRMCR: TBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
    end
    object mdCoreSYNONYMCODE: TBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
    end
    object mdCoreSYNONYMFIRMCRCODE: TBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
    end
    object mdCoreCODE: TStringField
      FieldName = 'CODE'
      Size = 84
    end
    object mdCoreCODECR: TStringField
      FieldName = 'CODECR'
      Size = 84
    end
    object mdCoreVOLUME: TStringField
      FieldName = 'VOLUME'
      Size = 15
    end
    object mdCoreDOC: TStringField
      FieldName = 'DOC'
    end
    object mdCoreNOTE: TStringField
      FieldName = 'NOTE'
      Size = 50
    end
    object mdCorePERIOD: TStringField
      FieldName = 'PERIOD'
    end
    object mdCoreAWAIT: TIntegerField
      FieldName = 'AWAIT'
    end
    object mdCoreJUNK: TIntegerField
      FieldName = 'JUNK'
    end
    object mdCoreBASECOST: TStringField
      FieldName = 'BASECOST'
      Size = 48
    end
    object mdCoreQUANTITY: TStringField
      FieldName = 'QUANTITY'
      Size = 15
    end
    object mdCoreSYNONYMNAME: TStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
    end
    object mdCoreSYNONYMFIRM: TStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
    end
    object mdCoreMINPRICE: TBCDField
      FieldName = 'MINPRICE'
      Size = 2
    end
    object mdCoreLEADERPRICECODE: TBCDField
      FieldName = 'LEADERPRICECODE'
      Size = 0
    end
    object mdCoreLEADERREGIONCODE: TBCDField
      FieldName = 'LEADERREGIONCODE'
      Size = 0
    end
    object mdCoreLEADERREGIONNAME: TStringField
      FieldName = 'LEADERREGIONNAME'
      Size = 25
    end
    object mdCoreLEADERPRICENAME: TStringField
      FieldName = 'LEADERPRICENAME'
      Size = 70
    end
    object mdCoreORDERSCOREID: TBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
    end
    object mdCoreORDERSORDERID: TBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
    end
    object mdCoreORDERSCLIENTID: TBCDField
      FieldName = 'ORDERSCLIENTID'
      Size = 0
    end
    object mdCoreORDERSFULLCODE: TBCDField
      FieldName = 'ORDERSFULLCODE'
      Size = 0
    end
    object mdCoreORDERSCODEFIRMCR: TBCDField
      FieldName = 'ORDERSCODEFIRMCR'
      Size = 0
    end
    object mdCoreORDERSSYNONYMCODE: TBCDField
      FieldName = 'ORDERSSYNONYMCODE'
      Size = 0
    end
    object mdCoreORDERSSYNONYMFIRMCRCODE: TBCDField
      FieldName = 'ORDERSSYNONYMFIRMCRCODE'
      Size = 0
    end
    object mdCoreORDERSCODE: TStringField
      FieldName = 'ORDERSCODE'
      Size = 84
    end
    object mdCoreORDERSCODECR: TStringField
      FieldName = 'ORDERSCODECR'
      Size = 84
    end
    object mdCoreORDERCOUNT: TIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object mdCoreORDERSSYNONYM: TStringField
      FieldName = 'ORDERSSYNONYM'
      Size = 250
    end
    object mdCoreORDERSSYNONYMFIRM: TStringField
      FieldName = 'ORDERSSYNONYMFIRM'
      Size = 250
    end
    object mdCoreORDERSPRICE: TStringField
      FieldName = 'ORDERSPRICE'
      Size = 48
    end
    object mdCoreORDERSJUNK: TIntegerField
      FieldName = 'ORDERSJUNK'
    end
    object mdCoreORDERSAWAIT: TIntegerField
      FieldName = 'ORDERSAWAIT'
    end
    object mdCoreORDERSHORDERID: TBCDField
      FieldName = 'ORDERSHORDERID'
      Size = 0
    end
    object mdCoreORDERSHCLIENTID: TBCDField
      FieldName = 'ORDERSHCLIENTID'
      Size = 0
    end
    object mdCoreORDERSHPRICECODE: TBCDField
      FieldName = 'ORDERSHPRICECODE'
      Size = 0
    end
    object mdCoreORDERSHREGIONCODE: TBCDField
      FieldName = 'ORDERSHREGIONCODE'
      Size = 0
    end
    object mdCoreORDERSHPRICENAME: TStringField
      FieldName = 'ORDERSHPRICENAME'
      Size = 70
    end
    object mdCoreORDERSHREGIONNAME: TStringField
      FieldName = 'ORDERSHREGIONNAME'
      Size = 25
    end
    object mdCoreSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object mdCorePriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      Calculated = True
    end
    object mdCoreCryptCODE: TStringField
      Tag = 2
      FieldName = 'CryptCODE'
    end
    object mdCoreCryptSYNONYMNAME: TStringField
      Tag = 1
      FieldName = 'CryptSYNONYMNAME'
    end
    object mdCoreCryptSYNONYMFIRM: TStringField
      Tag = 1
      FieldName = 'CryptSYNONYMFIRM'
    end
    object mdCoreCryptBASECOST: TCurrencyField
      FieldName = 'CryptBASECOST'
    end
  end
  object dsmdCode: TDataSource
    DataSet = mdCore
    Left = 304
    Top = 248
  end
  object qCore: TpFIBQuery
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    SQL.Strings = (
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
      '    ORDERSHREGIONNAME'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :ACLIENTID,'
      '    :APRICENAME) ')
    Left = 136
    Top = 112
  end
  object qCoreUpdate: TpFIBQuery
    Transaction = DM.UpTran
    Database = DM.MainConnection1
    SQL.Strings = (
      'execute procedure '
      '  updateordercount('
      '    :new_ORDERSHORDERID, '
      '    :Aclientid, '
      '    :APRICECODE, '
      '    :AREGIONCODE, '
      '    :new_ORDERSORDERID, '
      '    :new_COREID, '
      '    :NEW_ORDERCOUNT)')
    Left = 136
    Top = 152
  end
  object qCoreRefresh: TpFIBQuery
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    SQL.Strings = (
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
      '    ORDERSHREGIONNAME'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :ACLIENTID,'
      '    :APRICENAME) '
      'where'
      '  CoreID = :OLD_COREID')
    Left = 136
    Top = 192
  end
end
