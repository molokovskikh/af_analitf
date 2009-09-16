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
    Height = 437
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
    end
    object btnGotoCore: TButton
      Left = 407
      Top = 2
      Width = 94
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1042' '#1082#1072#1090#1072#1083#1086#1075' (F2)'
      TabOrder = 2
      Visible = False
    end
  end
  inline frameLegeng: TframeLegeng
    Left = 0
    Top = 502
    Width = 792
    Height = 33
    Align = alBottom
    Color = clWindow
    ParentColor = False
    TabOrder = 4
    inherited gbLegend: TGroupBox
      Width = 792
      inherited lNotBasicLegend: TLabel
        Visible = False
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
  object frdsCore: TfrDBDataSet
    DataSource = dsCore
    Left = 88
    Top = 192
  end
  object adsCoreOld: TpFIBDataSet
    UpdateSQL.Strings = (
      
        'execute procedure updateordercount(:new_ORDERSHORDERID, :Aclient' +
        'id, :APRICECODE, :AREGIONCODE, :new_ORDERSORDERID, :new_COREID, ' +
        ':NEW_ORDERCOUNT)')
    SelectSQL.Strings = (
      'SELECT'
      '*'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :ACLIENTID) ')
    FilterOptions = [foCaseInsensitive]
    AfterPost = adsCore2AfterPost
    BeforePost = adsCore2BeforePost
    Database = DM.MainConnectionOld
    AutoCommit = True
    Left = 88
    Top = 112
    oTrimCharFields = False
    oCacheCalcFields = True
    oRefreshAfterPost = False
    oFetchAll = True
    object adsCoreOldCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
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
    object adsCoreOldVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = True
    end
    object adsCoreOldDOC: TFIBStringField
      FieldName = 'DOC'
      EmptyStrToNull = True
    end
    object adsCoreOldNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = True
    end
    object adsCoreOldPERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = True
    end
    object adsCoreOldAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsCoreOldJUNK: TFIBIntegerField
      FieldName = 'JUNK'
    end
    object adsCoreOldQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = True
    end
    object adsCoreOldSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreOldSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreOldLEADERPRICECODE: TFIBBCDField
      FieldName = 'LEADERPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldLEADERREGIONCODE: TFIBBCDField
      FieldName = 'LEADERREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreOldLEADERREGIONNAME: TFIBStringField
      FieldName = 'LEADERREGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsCoreOldLEADERPRICENAME: TFIBStringField
      FieldName = 'LEADERPRICENAME'
      OnGetText = adsCoreOldLEADERPRICENAMEGetText
      Size = 70
      EmptyStrToNull = True
    end
    object adsCoreOldLEADERCODE: TFIBStringField
      FieldName = 'LEADERCODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreOldLEADERCODECR: TFIBStringField
      FieldName = 'LEADERCODECR'
      Size = 84
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
    object adsCoreOldORDERSJUNK: TFIBIntegerField
      FieldName = 'ORDERSJUNK'
    end
    object adsCoreOldORDERSAWAIT: TFIBIntegerField
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
    object adsCoreOldBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 60
      EmptyStrToNull = True
    end
    object adsCoreOldLEADERPRICE: TFIBStringField
      FieldName = 'LEADERPRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsCoreOldORDERSPRICE: TFIBStringField
      FieldName = 'ORDERSPRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsCoreOldREGISTRYCOST: TFIBFloatField
      FieldName = 'REGISTRYCOST'
      DisplayFormat = '#'
    end
    object adsCoreOldVITALLYIMPORTANT: TFIBIntegerField
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
    object adsCoreOldCryptLEADERPRICE: TCurrencyField
      Tag = 3
      FieldKind = fkCalculated
      FieldName = 'CryptLEADERPRICE'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreOldPriceRet: TCurrencyField
      Tag = 4
      FieldKind = fkCalculated
      FieldName = 'CryptPriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreOldCryptBASECOST: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptBASECOST'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreOldSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
  end
  object adsCountFieldsOld: TpFIBDataSet
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
    Database = DM.MainConnectionOld
    Left = 208
    Top = 128
    oCacheCalcFields = True
    oFetchAll = True
  end
  object adsOrdersHOld: TpFIBDataSet
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
    Database = DM.MainConnectionOld
    Left = 304
    Top = 136
    oCacheCalcFields = True
    oFetchAll = True
  end
  object adsOrdersShowFormSummaryOld: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    *'
      'FROM'
      '   ClientAVG'
      'where'
      '  ClientCode = :ACLIENTID')
    Database = DM.MainConnectionOld
    Left = 200
    Top = 264
    WaitEndMasterScroll = True
    dcForceOpen = True
    oCacheCalcFields = True
    object adsOrdersShowFormSummaryOldPRODUCTID: TFIBBCDField
      FieldName = 'PRODUCTID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersShowFormSummaryOldPRICEAVG: TFIBBCDField
      FieldName = 'PRICEAVG'
      Size = 2
      RoundByScale = True
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
  object adsCoreWithLikeOld: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '*'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :ACLIENTID) '
      'where'
      '  upper(SynonymName) like upper(:LikeParam)')
    Database = DM.MainConnectionOld
    Left = 160
    Top = 144
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
      '  ordershead.ORDERID,'
      '  ordershead.SERVERORDERID,'
      
        '  ifnull(ordershead.SERVERORDERID, ordershead.ORDERID) as Displa' +
        'yOrderId,'
      '  ordershead.CLIENTID,'
      '  ordershead.PRICECODE,'
      '  ordershead.REGIONCODE,'
      '  ordershead.PRICENAME,'
      '  ordershead.REGIONNAME,'
      '  ordershead.ORDERDATE,'
      '  ordershead.SENDDATE,'
      '  ordershead.CLOSED,'
      '  ordershead.SEND,'
      '  ordershead.COMMENTS,'
      '  ordershead.MESSAGETO '
      'from '
      '  ordershead '
      'where '
      '    (ordershead.ClientId   = :CLIENTID)'
      'and (ordershead.PriceCode  = :PRICECODE)'
      'and (ordershead.RegionCode = :REGIONCODE)'
      'and (ordershead.CLOSED <> 1)')
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
      
        'call updateordercount(:OLD_ORDERSHORDERID, :AClientid, :OLD_PRIC' +
        'ECODE, :OLD_REGIONCODE, :OLD_ORDERSORDERID, :OLD_COREID, :ORDERC' +
        'OUNT)')
    SQLRefresh.Strings = (
      'SELECT'
      '    CCore.CoreId AS CoreId,'
      '    CCore.productid,'
      '    CCore.PriceCode,'
      '    CCore.RegionCode,'
      '    catalogs.FullCode,'
      '    catalogs.shortcode,'
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
      '    CCore.Cost,'
      '    CCore.Quantity,'
      '    CCore.registrycost,'
      '    CCore.vitallyimportant,'
      '    CCore.requestratio,'
      '    CCore.ordercost,'
      '    CCore.minordercount,'
      
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
      '    OrdersHead.OrderId AS OrdersHOrderId,'
      '    OrdersHead.ClientId AS OrdersHClientId,'
      '    OrdersHead.PriceCode AS OrdersHPriceCode,'
      '    OrdersHead.RegionCode AS OrdersHRegionCode,'
      '    OrdersHead.PriceName AS OrdersHPriceName,'
      '    OrdersHead.RegionName AS OrdersHRegionName'
      'FROM'
      '    Core CCore'
      
        '    inner join products       on (products.productid = CCore.pro' +
        'ductid)'
      
        '    inner join catalogs       on (catalogs.fullcode = products.c' +
        'atalogid)'
      
        '    inner JOIN MinPrices      ON (MinPrices.productid = CCore.pr' +
        'oductid) and (minprices.regioncode = CCore.regioncode)'
      
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
      
        '    left JOIN OrdersList osbc ON (osbc.ClientID = :AClientId) an' +
        'd (osbc.CoreId = CCore.CoreId)'
      
        '    left JOIN OrdersHead      ON OrdersHead.OrderId = osbc.Order' +
        'Id'
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
      '    CCore.Cost,'
      '    CCore.Quantity,'
      '    CCore.registrycost,'
      '    CCore.vitallyimportant,'
      '    CCore.requestratio,'
      '    CCore.ordercost,'
      '    CCore.minordercount,'
      
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
      '    OrdersHead.OrderId AS OrdersHOrderId,'
      '    OrdersHead.ClientId AS OrdersHClientId,'
      '    OrdersHead.PriceCode AS OrdersHPriceCode,'
      '    OrdersHead.RegionCode AS OrdersHRegionCode,'
      '    OrdersHead.PriceName AS OrdersHPriceName,'
      '    OrdersHead.RegionName AS OrdersHRegionName'
      'FROM'
      '    Core CCore'
      
        '    inner join products       on (products.productid = CCore.pro' +
        'ductid)'
      
        '    inner join catalogs       on (catalogs.fullcode = products.c' +
        'atalogid)'
      
        '    inner JOIN MinPrices      ON (MinPrices.productid = CCore.pr' +
        'oductid) and (minprices.regioncode = CCore.regioncode)'
      
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
      
        '    left JOIN OrdersList osbc ON (osbc.ClientID = :AClientId) an' +
        'd (osbc.CoreId = CCore.CoreId)'
      
        '    left JOIN OrdersHead      ON OrdersHead.OrderId = osbc.Order' +
        'Id'
      'WHERE '
      '    (CCore.PriceCode = :APriceCode) '
      'And (CCore.RegionCode = :ARegionCode)')
    BeforeUpdateExecute = BeforeUpdateExecuteForClientID
    RefreshOptions = [roAfterUpdate]
    BeforePost = adsCore2BeforePost
    AfterPost = adsCore2AfterPost
    Left = 120
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end
      item
        DataType = ftUnknown
        Name = 'APriceCode'
      end
      item
        DataType = ftUnknown
        Name = 'ARegionCode'
      end>
    object adsCoreCoreId: TLargeintField
      FieldName = 'CoreId'
    end
    object adsCoreproductid: TLargeintField
      FieldName = 'productid'
    end
    object adsCorePriceCode: TLargeintField
      FieldName = 'PriceCode'
    end
    object adsCoreRegionCode: TLargeintField
      FieldName = 'RegionCode'
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
    object adsCoreVolume: TStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsCoreDoc: TStringField
      FieldName = 'Doc'
    end
    object adsCoreNote: TStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsCorePeriod: TStringField
      FieldName = 'Period'
    end
    object adsCoreAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsCoreJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsCoreCost: TFloatField
      FieldName = 'Cost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsCoreQuantity: TStringField
      FieldName = 'Quantity'
      Size = 15
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
    object adsCoreLeaderPriceCode: TLargeintField
      FieldName = 'LeaderPriceCode'
    end
    object adsCoreLeaderRegionCode: TLargeintField
      FieldName = 'LeaderRegionCode'
    end
    object adsCoreLeaderRegionName: TStringField
      FieldName = 'LeaderRegionName'
      Size = 25
    end
    object adsCoreLeaderPriceName: TStringField
      FieldName = 'LeaderPriceName'
      Size = 70
    end
    object adsCoreLeaderPRICE: TFloatField
      FieldName = 'LeaderPRICE'
      DisplayFormat = '0.00;;'#39#39
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
    object adsCoreCryptPriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCoreSumOrder: TFloatField
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
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
      '    CCore.Cost,'
      '    CCore.Quantity,'
      '    CCore.registrycost,'
      '    CCore.vitallyimportant,'
      '    CCore.requestratio,'
      '    CCore.ordercost,'
      '    CCore.minordercount,'
      
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
      '    OrdersHead.OrderId AS OrdersHOrderId,'
      '    OrdersHead.ClientId AS OrdersHClientId,'
      '    OrdersHead.PriceCode AS OrdersHPriceCode,'
      '    OrdersHead.RegionCode AS OrdersHRegionCode,'
      '    OrdersHead.PriceName AS OrdersHPriceName,'
      '    OrdersHead.RegionName AS OrdersHRegionName'
      'FROM'
      '    Core CCore'
      
        '    inner join products       on (products.productid = CCore.pro' +
        'ductid)'
      
        '    inner join catalogs       on (catalogs.fullcode = products.c' +
        'atalogid)'
      
        '    inner JOIN MinPrices      ON (MinPrices.productid = CCore.pr' +
        'oductid) and (minprices.regioncode = CCore.regioncode)'
      
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
      
        '    left JOIN OrdersList osbc ON (osbc.ClientID = :AClientId) an' +
        'd (osbc.CoreId = CCore.CoreId)'
      
        '    left JOIN OrdersHead      ON OrdersHead.OrderId = osbc.Order' +
        'Id'
      'WHERE '
      '    (CCore.PriceCode = :APriceCode) '
      'and (CCore.RegionCode = :ARegionCode)'
      'and (Synonyms.SynonymName like :LikeParam)')
    Left = 128
    Top = 160
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end
      item
        DataType = ftUnknown
        Name = 'APriceCode'
      end
      item
        DataType = ftUnknown
        Name = 'ARegionCode'
      end
      item
        DataType = ftUnknown
        Name = 'LikeParam'
      end>
  end
end
