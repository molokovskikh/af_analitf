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
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
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
      SearchField = 'PriceName'
      SearchPosition = spBottom
      Columns = <
        item
          EditButtons = <>
          FieldName = 'PriceName'
          Footers = <>
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Title.TitleButton = True
          Width = 75
        end
        item
          EditButtons = <>
          FieldName = 'RegionName'
          Footers = <>
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Title.TitleButton = True
          Width = 57
        end
        item
          Checkboxes = False
          EditButtons = <>
          FieldName = 'Storage'
          Footers = <>
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
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'pricesize'
          Footers = <>
          Title.Caption = #1055#1086#1079#1080#1094#1080#1081
          Title.TitleButton = True
          Width = 50
        end
        item
          EditButtons = <>
          FieldName = 'Positions'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079
          Title.TitleButton = True
          Width = 45
        end
        item
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072
          Title.TitleButton = True
          Width = 51
        end
        item
          Alignment = taCenter
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'DatePrice'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Title.TitleButton = True
          Width = 95
        end
        item
          EditButtons = <>
          FieldName = 'sumbycurrentmonth'
          Footers = <>
          Title.Caption = #1052#1077#1089#1103#1095#1085#1099#1081' '#1079#1072#1082#1072#1079
          Title.Hint = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
          Title.TitleButton = True
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
  object adsPricesOld: TpFIBDataSet
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
    Database = DM.MainConnectionOld
    AutoCommit = True
    Left = 96
    Top = 152
    oCacheCalcFields = True
    object adsPricesOldPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsPricesOldPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsPricesOldDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsPricesOldMINREQ: TFIBIntegerField
      FieldName = 'MINREQ'
    end
    object adsPricesOldENABLED: TFIBIntegerField
      FieldName = 'ENABLED'
    end
    object adsPricesOldPRICEINFO: TFIBBlobField
      FieldName = 'PRICEINFO'
      Size = 8
    end
    object adsPricesOldFIRMCODE: TFIBBCDField
      FieldName = 'FIRMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsPricesOldFULLNAME: TFIBStringField
      FieldName = 'FULLNAME'
      Size = 40
      EmptyStrToNull = True
    end
    object adsPricesOldSTORAGE: TFIBIntegerField
      Alignment = taCenter
      FieldName = 'STORAGE'
      OnGetText = adsPricesOldSTORAGEGetText
    end
    object adsPricesOldADMINMAIL: TFIBStringField
      FieldName = 'ADMINMAIL'
      Size = 50
      EmptyStrToNull = True
    end
    object adsPricesOldSUPPORTPHONE: TFIBStringField
      FieldName = 'SUPPORTPHONE'
      EmptyStrToNull = True
    end
    object adsPricesOldCONTACTINFO: TFIBBlobField
      FieldName = 'CONTACTINFO'
      Size = 8
    end
    object adsPricesOldOPERATIVEINFO: TFIBBlobField
      FieldName = 'OPERATIVEINFO'
      Size = 8
    end
    object adsPricesOldREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsPricesOldREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsPricesOldPOSITIONS: TFIBIntegerField
      FieldName = 'POSITIONS'
    end
    object adsPricesOldPRICESIZE: TFIBIntegerField
      FieldName = 'PRICESIZE'
    end
    object adsPricesOldSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsPricesOldINJOB: TFIBBooleanField
      FieldName = 'INJOB'
      OnChange = adsPricesOldINJOBChange
    end
    object adsPricesOldSUMBYCURRENTMONTH: TFIBBCDField
      FieldName = 'SUMBYCURRENTMONTH'
      Size = 2
      RoundByScale = True
    end
  end
  object tmStopEdit: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmStopEditTimer
    Left = 288
    Top = 272
  end
  object adsPrices: TMyQuery
    SQLUpdate.Strings = (
      'call updateupcost(:OLD_PRICECODE, :OLD_RegionCODE, :INJOB)')
    SQLRefresh.Strings = (
      'SELECT '
      'pricesshow.*,'
      
        'pricesshow.UniversalDatePrice - interval :TimeZoneBias minute AS' +
        ' DatePrice,'
      '('
      '  SELECT'
      '    Count(*)'
      '  FROM'
      '    OrdersH'
      '    INNER JOIN Orders ON Orders.OrderId=OrdersH.OrderId'
      '  WHERE OrdersH.ClientId   = :AClientId'
      '     AND OrdersH.PriceCode = pricesshow.PriceCode'
      '     AND OrdersH.RegionCode = pricesshow.RegionCode'
      '     AND OrdersH.Closed <> 1'
      '     AND Orders.OrderCount > 0'
      ') as Positions,'
      '('
      '  select'
      '    Sum(Orders.SendPrice * Orders.OrderCount)'
      '  from'
      '    OrdersH'
      '    INNER JOIN Orders ON Orders.OrderId=OrdersH.OrderId'
      '  WHERE OrdersH.ClientId = :AClientId'
      '     AND OrdersH.PriceCode = pricesshow.PriceCode'
      '     AND OrdersH.RegionCode = pricesshow.RegionCode'
      
        '     and ordersh.senddate > curdate() + interval (1-day(curdate(' +
        '))) day'
      '     AND OrdersH.Closed = 1'
      '     AND OrdersH.send = 1'
      '     AND Orders.OrderCount>0'
      ') as sumbycurrentmonth'
      'FROM pricesshow'
      'where'
      '    PriceCode = :pricecode'
      'and RegionCode = :regioncode')
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '  pricesshow.*,'
      
        '  pricesshow.UniversalDatePrice - interval :TimeZoneBias minute ' +
        'AS DatePrice,'
      '  count(OrdersList.ID) as Positions,'
      
        '  ifnull(Sum(OrdersList.Price * OrdersList.OrderCount), 0) as Su' +
        'mOrder,'
      '/*'
      '('
      '  SELECT'
      '    Count(*)'
      '  FROM'
      '    OrdersHead'
      
        '    INNER JOIN OrdersList ON OrdersList.OrderId=OrdersHead.Order' +
        'Id'
      '  WHERE OrdersHead.ClientId   = :AClientId'
      '     AND OrdersHead.PriceCode = pricesshow.PriceCode'
      '     AND OrdersHead.RegionCode = pricesshow.RegionCode'
      '     AND OrdersHead.Closed <> 1'
      '     AND OrdersList.OrderCount > 0'
      ') as Positions,'
      '*/'
      '  ('
      '    select'
      '      ifnull(Sum(OrdersList.Price * OrdersList.OrderCount), 0)'
      '    from'
      '      OrdersHead'
      
        '      INNER JOIN OrdersList ON OrdersList.OrderId=OrdersHead.Ord' +
        'erId'
      '    WHERE OrdersHead.ClientId = :AClientId'
      '       AND OrdersHead.PriceCode = pricesshow.PriceCode'
      '       AND OrdersHead.RegionCode = pricesshow.RegionCode'
      
        '       and OrdersHead.senddate > curdate() + interval (1-day(cur' +
        'date())) day'
      '       AND OrdersHead.Closed = 1'
      '       AND OrdersHead.send = 1'
      '       AND OrdersList.OrderCount>0'
      '  ) as sumbycurrentmonth'
      'FROM '
      '  pricesshow'
      '  left join Ordershead on '
      '        Ordershead.Pricecode = pricesshow.PriceCode '
      '    and Ordershead.Regioncode = pricesshow.RegionCode'
      '    and OrdersHead.ClientId   = :AClientId'
      '    and OrdersHead.Closed <> 1'
      '  left join OrdersList on '
      '        OrdersList.ORDERID = Ordershead.ORDERID'
      '    and OrdersList.OrderCount > 0'
      'group by pricesshow.PriceCode, pricesshow.RegionCode')
    AfterOpen = adsPrices2AfterOpen
    AfterScroll = adsPrices2AfterScroll
    Options.StrictUpdate = False
    Left = 144
    Top = 152
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TimeZoneBias'
      end
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end>
    object adsPricesPriceCode: TLargeintField
      FieldName = 'PriceCode'
      ReadOnly = True
    end
    object adsPricesPriceName: TStringField
      FieldName = 'PriceName'
      ReadOnly = True
      Size = 70
    end
    object adsPricesUniversalDatePrice: TDateTimeField
      FieldName = 'UniversalDatePrice'
      ReadOnly = True
    end
    object adsPricesMinReq: TIntegerField
      FieldName = 'MinReq'
      ReadOnly = True
    end
    object adsPricesEnabled: TBooleanField
      FieldName = 'Enabled'
      ReadOnly = True
    end
    object adsPricesPriceInfo: TMemoField
      FieldName = 'PriceInfo'
      ReadOnly = True
      BlobType = ftMemo
    end
    object adsPricesFirmCode: TLargeintField
      FieldName = 'FirmCode'
      ReadOnly = True
    end
    object adsPricesFullName: TStringField
      FieldName = 'FullName'
      ReadOnly = True
      Size = 40
    end
    object adsPricesStorage: TBooleanField
      Alignment = taCenter
      FieldName = 'Storage'
      ReadOnly = True
      OnGetText = adsPricesOldSTORAGEGetText
    end
    object adsPricesAdminMail: TStringField
      FieldName = 'AdminMail'
      ReadOnly = True
      Size = 50
    end
    object adsPricesSupportPhone: TStringField
      FieldName = 'SupportPhone'
      ReadOnly = True
    end
    object adsPricesContactInfo: TMemoField
      FieldName = 'ContactInfo'
      ReadOnly = True
      BlobType = ftMemo
    end
    object adsPricesOperativeInfo: TMemoField
      FieldName = 'OperativeInfo'
      ReadOnly = True
      BlobType = ftMemo
    end
    object adsPricesRegionCode: TLargeintField
      FieldName = 'RegionCode'
      ReadOnly = True
    end
    object adsPricesRegionName: TStringField
      FieldName = 'RegionName'
      ReadOnly = True
      Size = 25
    end
    object adsPricespricesize: TIntegerField
      FieldName = 'pricesize'
      ReadOnly = True
    end
    object adsPricesINJOB: TBooleanField
      FieldName = 'INJOB'
      OnChange = adsPricesOldINJOBChange
    end
    object adsPricesCONTROLMINREQ: TBooleanField
      FieldName = 'CONTROLMINREQ'
      ReadOnly = True
    end
    object adsPricesDatePrice: TDateTimeField
      FieldName = 'DatePrice'
      ReadOnly = True
    end
    object adsPricesPositions: TLargeintField
      FieldName = 'Positions'
      ReadOnly = True
    end
    object adsPricessumbycurrentmonth: TFloatField
      FieldName = 'sumbycurrentmonth'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
    end
    object adsPricesSumOrder: TFloatField
      FieldName = 'SumOrder'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
    end
  end
end
