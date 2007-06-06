inherited ExpiredsForm: TExpiredsForm
  Left = 362
  Top = 206
  ActiveControl = dbgExpireds
  Caption = #1055#1088#1077#1087#1072#1088#1072#1090#1099' '#1089' '#1080#1089#1090#1077#1082#1072#1102#1097#1080#1084#1080' '#1089#1088#1086#1082#1072#1084#1080' '#1075#1086#1076#1085#1086#1089#1090#1080
  ClientHeight = 573
  ClientWidth = 792
  OldCreateOrder = True
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object plOverCost: TPanel [0]
    Left = 176
    Top = 176
    Width = 305
    Height = 57
    Caption = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1089#1088#1077#1076#1085#1077#1081' '#1094#1077#1085#1099'!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
  end
  object pClient: TPanel [1]
    Left = 0
    Top = 0
    Width = 792
    Height = 364
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgExpireds: TToughDBGrid
      Tag = 4096
      Left = 0
      Top = 0
      Width = 792
      Height = 335
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
          FieldName = 'SYNONYMNAME'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 174
        end
        item
          EditButtons = <>
          FieldName = 'SYNONYMFIRM'
          Footers = <>
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Title.TitleButton = True
          Width = 70
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'VOLUME'
          Footers = <>
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Title.TitleButton = True
          Width = 37
        end
        item
          EditButtons = <>
          FieldName = 'NOTE'
          Footers = <>
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Title.TitleButton = True
          Visible = False
          Width = 37
        end
        item
          EditButtons = <>
          FieldName = 'DOC'
          Footers = <>
          Title.Caption = #1044#1086#1082#1091#1084#1077#1085#1090
          Visible = False
        end
        item
          Alignment = taCenter
          EditButtons = <>
          FieldName = 'PERIOD'
          Footers = <>
          Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'PRICENAME'
          Footers = <>
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Title.TitleButton = True
          Width = 92
        end
        item
          EditButtons = <>
          FieldName = 'REGIONNAME'
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
          FieldName = 'DATEPRICE'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Title.TitleButton = True
          Width = 90
        end
        item
          EditButtons = <>
          FieldName = 'REGISTRYCOST'
          Footers = <>
          Title.Caption = #1056#1077#1077#1089#1090#1088'. '#1094#1077#1085#1072
          Visible = False
          Width = 30
        end
        item
          EditButtons = <>
          FieldName = 'REQUESTRATIO'
          Footers = <>
          Title.Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
          Visible = False
          Width = 30
        end
        item
          EditButtons = <>
          FieldName = 'ORDERCOST'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'MINORDERCOUNT'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086
          Visible = False
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
          FieldName = 'QUANTITY'
          Footers = <>
          Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          Title.TitleButton = True
          Width = 37
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'ORDERCOUNT'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079
          Width = 46
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072
          Width = 51
        end>
    end
    object pRecordCount: TPanel
      Left = 0
      Top = 335
      Width = 792
      Height = 29
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        792
        29)
      object lblRecordCount: TLabel
        Left = 12
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
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 792
        Height = 29
        Align = alClient
        Shape = bsTopLine
      end
    end
  end
  object pWebBrowser: TPanel [2]
    Tag = 209
    Left = 0
    Top = 364
    Width = 792
    Height = 209
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
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
      Tag = 4
      Left = 0
      Top = 4
      Width = 792
      Height = 205
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C000000DB510000301500000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object dsExpireds: TDataSource
    DataSet = adsExpireds
    Left = 128
    Top = 152
  end
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 416
    Top = 224
  end
  object adsExpireds: TpFIBDataSet
    UpdateSQL.Strings = (
      
        'execute procedure updateordercount(:new_ORDERSHORDERID, :Aclient' +
        'id, :PRICECODE, :REGIONCODE, :new_ORDERSORDERID, :new_COREID, :N' +
        'EW_ORDERCOUNT)')
    SelectSQL.Strings = (
      'SELECT'
      '*'
      'FROM'
      '    EXPIREDSSHOW(:TIMEZONEBIAS,'
      '    :ACLIENTID, null) ')
    AfterPost = adsExpireds2AfterPost
    AfterScroll = adsExpireds2AfterScroll
    BeforeEdit = adsExpiredsBeforeEdit
    BeforePost = adsExpireds2BeforePost
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    UpdateTransaction = DM.UpTran
    AutoCommit = True
    Left = 128
    Top = 112
    oTrimCharFields = False
    oCacheCalcFields = True
    oRefreshAfterPost = False
    object adsExpiredsCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsExpiredsCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsExpiredsNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = True
    end
    object adsExpiredsPERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = True
    end
    object adsExpiredsVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = True
    end
    object adsExpiredsQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = True
    end
    object adsExpiredsSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsExpiredsSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsExpiredsAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsExpiredsPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsExpiredsDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsExpiredsREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsExpiredsORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSCLIENTID: TFIBBCDField
      FieldName = 'ORDERSCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSFULLCODE: TFIBBCDField
      FieldName = 'ORDERSFULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSCODEFIRMCR: TFIBBCDField
      FieldName = 'ORDERSCODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSSYNONYMCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSCODE: TFIBStringField
      FieldName = 'ORDERSCODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsExpiredsORDERSCODECR: TFIBStringField
      FieldName = 'ORDERSCODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsExpiredsORDERSSYNONYM: TFIBStringField
      FieldName = 'ORDERSSYNONYM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsExpiredsORDERSSYNONYMFIRM: TFIBStringField
      FieldName = 'ORDERSSYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsExpiredsORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
      DisplayFormat = '#'
    end
    object adsExpiredsORDERSJUNK: TFIBIntegerField
      FieldName = 'ORDERSJUNK'
    end
    object adsExpiredsORDERSAWAIT: TFIBIntegerField
      FieldName = 'ORDERSAWAIT'
    end
    object adsExpiredsORDERSHORDERID: TFIBBCDField
      FieldName = 'ORDERSHORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSHCLIENTID: TFIBBCDField
      FieldName = 'ORDERSHCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSHPRICECODE: TFIBBCDField
      FieldName = 'ORDERSHPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSHREGIONCODE: TFIBBCDField
      FieldName = 'ORDERSHREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsExpiredsORDERSHPRICENAME: TFIBStringField
      FieldName = 'ORDERSHPRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsExpiredsORDERSHREGIONNAME: TFIBStringField
      FieldName = 'ORDERSHREGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsExpiredsSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsExpiredsPriceRet: TCurrencyField
      Tag = 4
      FieldKind = fkCalculated
      FieldName = 'CryptPriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsExpiredsCryptBASECOST: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptBASECOST'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsExpiredsBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 60
      EmptyStrToNull = True
    end
    object adsExpiredsORDERSPRICE: TFIBStringField
      FieldName = 'ORDERSPRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsExpiredsDOC: TFIBStringField
      FieldName = 'DOC'
      EmptyStrToNull = True
    end
    object adsExpiredsREGISTRYCOST: TFIBFloatField
      FieldName = 'REGISTRYCOST'
      DisplayFormat = '#'
    end
    object adsExpiredsVITALLYIMPORTANT: TFIBIntegerField
      FieldName = 'VITALLYIMPORTANT'
    end
    object adsExpiredsREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
      DisplayFormat = '#'
    end
    object adsExpiredsORDERCOST: TFIBBCDField
      FieldName = 'ORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsExpiredsMINORDERCOUNT: TFIBIntegerField
      FieldName = 'MINORDERCOUNT'
    end
  end
  object adsOrdersShowFormSummary: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    *'
      'FROM'
      '   PriceAVG'
      'where'
      '  ClientCode = :ACLIENTID'
      'and FullCode = :FullCode')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    DataSource = dsExpireds
    Left = 312
    Top = 152
    WaitEndMasterScroll = True
    dcForceOpen = True
    oCacheCalcFields = True
    object adsOrdersShowFormSummaryORDERPRICEAVG: TFIBBCDField
      FieldName = 'ORDERPRICEAVG'
      Size = 2
      RoundByScale = True
    end
  end
end
