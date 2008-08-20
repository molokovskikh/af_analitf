inherited PricesForm: TPricesForm
  Left = 283
  Top = 179
  ActiveControl = dbgPrices
  Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 573
  ClientWidth = 792
  OldCreateOrder = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 543
    Width = 792
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      792
      30)
    object cbOnlyLeaders: TCheckBox
      Left = 13
      Top = 7
      Width = 316
      Height = 17
      Action = actOnlyLeaders
      Anchors = [akLeft, akBottom]
      Caption = ' '#1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1083#1080#1076#1080#1088#1091#1102#1097#1080#1077' '#1087#1086#1079#1080#1094#1080#1080' (F3)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 0
    Width = 792
    Height = 543
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgPrices: TToughDBGrid
      Tag = 64
      Left = 0
      Top = 29
      Width = 536
      Height = 514
      Align = alClient
      AllowedOperations = [alopUpdateEh]
      AutoFitColWidths = True
      DataSource = dsPrices
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch, dghPreferIncSearch, dghRowHighlight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgPricesDblClick
      OnExit = dbgPricesExit
      OnGetCellParams = dbgPricesGetCellParams
      OnKeyDown = dbgPricesKeyDown
      OnSortMarkingChanged = dbgPricesSortMarkingChanged
      SearchPosition = spBottom
      Columns = <
        item
          EditButtons = <>
          FieldName = 'PRICENAME'
          Footers = <>
          ReadOnly = True
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Title.TitleButton = True
          Width = 75
        end
        item
          EditButtons = <>
          FieldName = 'REGIONNAME'
          Footers = <>
          ReadOnly = True
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Title.TitleButton = True
          Width = 57
        end
        item
          Checkboxes = False
          EditButtons = <>
          FieldName = 'STORAGE'
          Footers = <>
          ReadOnly = True
          Title.Caption = #1057#1082#1083#1072#1076
          Title.TitleButton = True
          Width = 36
        end
        item
          Checkboxes = True
          EditButtons = <>
          FieldName = 'INJOB'
          Footers = <>
          Title.Caption = #1042' '#1088#1072#1073#1086#1090#1077
        end
        item
          EditButtons = <>
          FieldName = 'PRICESIZE'
          Footers = <>
          ReadOnly = True
          Title.Caption = #1055#1086#1079#1080#1094#1080#1081
          Title.TitleButton = True
          Width = 50
        end
        item
          EditButtons = <>
          FieldName = 'POSITIONS'
          Footers = <>
          ReadOnly = True
          Title.Caption = #1047#1072#1082#1072#1079
          Title.TitleButton = True
          Width = 45
        end
        item
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          ReadOnly = True
          Title.Caption = #1057#1091#1084#1084#1072
          Title.TitleButton = True
          Width = 51
        end
        item
          Alignment = taCenter
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'DATEPRICE'
          Footers = <>
          ReadOnly = True
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Title.TitleButton = True
          Width = 95
        end
        item
          EditButtons = <>
          FieldName = 'SUMBYCURRENTMONTH'
          Footers = <>
          Title.Caption = #1052#1077#1089#1103#1095#1085#1099#1081' '#1079#1072#1082#1072#1079
          Title.Hint = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
          Width = 76
        end>
    end
    object GroupBox1: TGroupBox
      Left = 536
      Top = 29
      Width = 256
      Height = 514
      Align = alRight
      Caption = ' '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '
      TabOrder = 0
      DesignSize = (
        256
        514)
      object dbtPhones: TDBText
        Left = 72
        Top = 37
        Width = 61
        Height = 13
        AutoSize = True
        DataField = 'SupportPhone'
        DataSource = dsPrices
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtAdminMail: TDBText
        Left = 55
        Top = 55
        Width = 76
        Height = 13
        Cursor = crHandPoint
        AutoSize = True
        Color = clBtnFace
        DataField = 'AdminMail'
        DataSource = dsPrices
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentColor = False
        ParentFont = False
        OnClick = dbtAdminMailClick
      end
      object dbtFullName: TDBText
        Left = 5
        Top = 20
        Width = 244
        Height = 13
        DataField = 'FullName'
        DataSource = dsPrices
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtMinOrder: TDBText
        Left = 174
        Top = 71
        Width = 70
        Height = 13
        AutoSize = True
        DataField = 'MinReq'
        DataSource = dsPrices
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 6
        Top = 100
        Width = 156
        Height = 13
        Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 6
        Top = 71
        Width = 164
        Height = 13
        Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1079#1072#1082#1072#1079', '#1088#1091#1073'. :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 5
        Top = 37
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
      object Label5: TLabel
        Left = 6
        Top = 55
        Width = 44
        Height = 13
        Caption = 'E-Mail :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel2: TBevel
        Left = 5
        Top = 91
        Width = 243
        Height = 3
        Shape = bsTopLine
      end
      object Label6: TLabel
        Left = 6
        Top = 246
        Width = 165
        Height = 13
        Caption = #1054#1087#1077#1088#1072#1090#1080#1074#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel3: TBevel
        Left = 5
        Top = 237
        Width = 243
        Height = 3
        Shape = bsTopLine
      end
      object DBMemo2: TDBMemo
        Left = 6
        Top = 119
        Width = 243
        Height = 115
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        DataField = 'ContactInfo'
        DataSource = dsPrices
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object DBMemo3: TDBMemo
        Left = 6
        Top = 264
        Width = 243
        Height = 235
        Anchors = [akLeft, akTop, akBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        DataField = 'OperativeInfo'
        DataSource = dsPrices
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 792
      Height = 29
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object lblPriceCount: TLabel
        Left = 7
        Top = 6
        Width = 93
        Height = 16
        Caption = 'lblPriceCount'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object ActionList: TActionList
    Left = 208
    Top = 112
    object actCurrentOrders: TAction
      Caption = #1058#1086#1083#1100#1082#1086' '#1090#1077#1082#1091#1097#1080#1077' '#1079#1072#1103#1074#1082#1080
    end
    object actOnlyLeaders: TAction
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1083#1080#1076#1080#1088#1091#1102#1097#1080#1077' '#1087#1086#1079#1080#1094#1080#1080' (F3)'
      ShortCut = 114
      OnExecute = actOnlyLeadersExecute
    end
  end
  object dsPrices: TDataSource
    DataSet = adsPrices
    Left = 96
    Top = 216
  end
  object adsPrices: TpFIBDataSet
    UpdateSQL.Strings = (
      
        'execute procedure updateupcost(:OLD_PRICECODE, :OLD_RegionCODE, ' +
        ':NEW_INJOB)')
    RefreshSQL.Strings = (
      'SELECT'
      '    PRICECODE,'
      '    PRICENAME,'
      '    DATEPRICE,'
      '    MINREQ,'
      '    ENABLED,'
      '    PRICEINFO,'
      '    FIRMCODE,'
      '    FULLNAME,'
      '    STORAGE,'
      '    ADMINMAIL,'
      '    SUPPORTPHONE,'
      '    CONTACTINFO,'
      '    OPERATIVEINFO,'
      '    REGIONCODE,'
      '    REGIONNAME,'
      '    POSITIONS,'
      '    PRICESIZE,'
      '    INJOB'
      'FROM'
      '    PRICESSHOW(:ACLIENTID,'
      '    :TIMEZONEBIAS) '
      'where'
      '  PRICECODE = :OLD_PRICECODE'
      'and REGIONCODE = :OLD_REGIONCODE')
    SelectSQL.Strings = (
      'SELECT'
      '    PRICECODE,'
      '    PRICENAME,'
      '    DATEPRICE,'
      '    MINREQ,'
      '    ENABLED,'
      '    PRICEINFO,'
      '    FIRMCODE,'
      '    FULLNAME,'
      '    STORAGE,'
      '    ADMINMAIL,'
      '    SUPPORTPHONE,'
      '    CONTACTINFO,'
      '    OPERATIVEINFO,'
      '    REGIONCODE,'
      '    REGIONNAME,'
      '    POSITIONS,'
      '    PRICESIZE,'
      '    INJOB,'
      '    SUMBYCURRENTMONTH'
      'FROM'
      '    PRICESSHOW(:ACLIENTID,'
      '    :TIMEZONEBIAS) ')
    AfterOpen = adsPrices2AfterOpen
    AfterScroll = adsPrices2AfterScroll
    OnCalcFields = adsPricesCalcFields
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    UpdateTransaction = DM.UpTran
    AutoCommit = True
    Left = 96
    Top = 152
    oCacheCalcFields = True
    object adsPricesPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsPricesPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsPricesDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsPricesMINREQ: TFIBIntegerField
      FieldName = 'MINREQ'
    end
    object adsPricesENABLED: TFIBIntegerField
      FieldName = 'ENABLED'
    end
    object adsPricesPRICEINFO: TFIBBlobField
      FieldName = 'PRICEINFO'
      Size = 8
    end
    object adsPricesFIRMCODE: TFIBBCDField
      FieldName = 'FIRMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsPricesFULLNAME: TFIBStringField
      FieldName = 'FULLNAME'
      Size = 40
      EmptyStrToNull = True
    end
    object adsPricesSTORAGE: TFIBIntegerField
      Alignment = taCenter
      FieldName = 'STORAGE'
      OnGetText = adsPricesSTORAGEGetText
    end
    object adsPricesADMINMAIL: TFIBStringField
      FieldName = 'ADMINMAIL'
      Size = 50
      EmptyStrToNull = True
    end
    object adsPricesSUPPORTPHONE: TFIBStringField
      FieldName = 'SUPPORTPHONE'
      EmptyStrToNull = True
    end
    object adsPricesCONTACTINFO: TFIBBlobField
      FieldName = 'CONTACTINFO'
      Size = 8
    end
    object adsPricesOPERATIVEINFO: TFIBBlobField
      FieldName = 'OPERATIVEINFO'
      Size = 8
    end
    object adsPricesREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsPricesREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsPricesPOSITIONS: TFIBIntegerField
      FieldName = 'POSITIONS'
    end
    object adsPricesPRICESIZE: TFIBIntegerField
      FieldName = 'PRICESIZE'
    end
    object adsPricesSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsPricesINJOB: TFIBBooleanField
      FieldName = 'INJOB'
      OnChange = adsPricesINJOBChange
    end
    object adsPricesSUMBYCURRENTMONTH: TFIBBCDField
      FieldName = 'SUMBYCURRENTMONTH'
      Size = 2
      RoundByScale = True
    end
  end
  object adsClientsData: TpFIBDataSet
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 208
    Top = 200
    oCacheCalcFields = True
  end
  object tmStopEdit: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmStopEditTimer
    Left = 288
    Top = 272
  end
end
