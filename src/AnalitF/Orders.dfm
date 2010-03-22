inherited OrdersForm: TOrdersForm
  Left = 316
  Top = 239
  ActiveControl = dbgOrders
  Caption = #1040#1088#1093#1080#1074#1085#1099#1081' '#1079#1072#1082#1072#1079
  ClientHeight = 443
  ClientWidth = 793
  OldCreateOrder = True
  OnDestroy = FormDestroy
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
    TabOrder = 0
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
  inline frameLegeng: TframeLegeng [1]
    Left = 0
    Top = 410
    Width = 793
    Height = 33
    Align = alBottom
    Color = clWindow
    ParentColor = False
    TabOrder = 1
    inherited gbLegend: TGroupBox
      inherited lVitallyImportantLegend: TLabel
        Visible = False
      end
      inherited lNotBasicLegend: TLabel
        Visible = False
      end
      inherited lLeaderLegend: TLabel
        Visible = False
      end
    end
  end
  object pClient: TPanel
    Left = 0
    Top = 108
    Width = 793
    Height = 302
    Align = alClient
    TabOrder = 2
    object dbgOrders: TToughDBGrid
      Left = 1
      Top = 1
      Width = 791
      Height = 190
      Align = alClient
      AutoFitColWidths = True
      DataSource = dsOrders
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
      OnDblClick = dbgOrdersDblClick
      OnGetCellParams = dbgOrdersGetCellParams
      OnKeyDown = dbgOrdersKeyDown
      OnKeyPress = dbgOrdersKeyPress
      OnSortMarkingChanged = dbgOrdersSortMarkingChanged
      SearchField = 'SynonymName'
      InputField = 'OrderCount'
      SearchPosition = spBottom
      ForceRus = True
      OnCanInput = dbgOrdersCanInput
      Columns = <
        item
          EditButtons = <>
          FieldName = 'synonymname'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 97
        end
        item
          EditButtons = <>
          FieldName = 'synonymfirm'
          Footers = <>
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Title.TitleButton = True
          Width = 156
        end
        item
          EditButtons = <>
          FieldName = 'RealPrice'
          Footers = <>
          Title.Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1086#1090#1089#1088#1086#1095#1082#1080
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'price'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Footers = <>
          Title.Caption = #1062#1077#1085#1072
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'ordercount'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072
          Title.TitleButton = True
        end>
    end
    object gbMessageTo: TGroupBox
      Left = 1
      Top = 231
      Width = 791
      Height = 70
      Align = alBottom
      Caption = ' '#1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '
      TabOrder = 1
      object dbmMessageTo: TDBMemo
        Left = 2
        Top = 15
        Width = 787
        Height = 53
        Align = alClient
        DataField = 'MessageTo'
        DataSource = OrdersHForm.dsOrdersH
        TabOrder = 0
        OnExit = dbmMessageToExit
        OnKeyDown = dbmMessageToKeyDown
      end
    end
    object gbCorrectMessage: TGroupBox
      Left = 1
      Top = 191
      Width = 791
      Height = 40
      Align = alBottom
      Caption = ' '#1055#1088#1080#1095#1080#1085#1072' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' '
      TabOrder = 2
      object mCorrectMessage: TMemo
        Left = 2
        Top = 15
        Width = 787
        Height = 23
        Align = alClient
        Lines.Strings = (
          'mCorrectMessage')
        ReadOnly = True
        TabOrder = 0
        OnKeyDown = dbmMessageToKeyDown
      end
    end
  end
  object pTop: TPanel
    Left = 0
    Top = 33
    Width = 793
    Height = 75
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object pOrderHeader: TPanel
      Left = 0
      Top = 0
      Width = 793
      Height = 51
      Align = alTop
      BevelInner = bvLowered
      TabOrder = 0
      object dbtPriceName: TDBText
        Left = 427
        Top = 9
        Width = 198
        Height = 13
        DataField = 'PriceName'
        DataSource = OrdersHForm.dsOrdersH
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 12
        Top = 9
        Width = 53
        Height = 13
        Caption = #1047#1072#1082#1072#1079' '#8470
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtId: TDBText
        Left = 75
        Top = 9
        Width = 109
        Height = 13
        DataField = 'DisplayOrderId'
        DataSource = OrdersHForm.dsOrdersH
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 196
        Top = 9
        Width = 14
        Height = 13
        Caption = #1086#1090
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtOrderDate: TDBText
        Left = 213
        Top = 9
        Width = 124
        Height = 13
        DataField = 'OrderDate'
        DataSource = OrdersHForm.dsOrdersH
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblRecordCount: TLabel
        Left = 12
        Top = 29
        Width = 60
        Height = 13
        Caption = #1055#1086#1079#1080#1094#1080#1081' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSum: TLabel
        Left = 148
        Top = 29
        Width = 64
        Height = 13
        Caption = #1085#1072' '#1089#1091#1084#1084#1091' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtPositions: TDBText
        Left = 75
        Top = 29
        Width = 62
        Height = 13
        DataField = 'Positions'
        DataSource = OrdersHForm.dsOrdersH
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtSumOrder: TDBText
        Left = 674
        Top = 29
        Width = 81
        Height = 13
        DataField = 'PRICENAME'
        DataSource = OrdersHForm.dsOrdersH
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Label4: TLabel
        Left = 347
        Top = 9
        Width = 77
        Height = 13
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 374
        Top = 29
        Width = 51
        Height = 13
        Caption = #1056#1077#1075#1080#1086#1085' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtRegionName: TDBText
        Left = 427
        Top = 29
        Width = 198
        Height = 13
        DataField = 'RegionName'
        DataSource = OrdersHForm.dsOrdersH
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lSumOrder: TLabel
        Left = 213
        Top = 29
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
    end
    object cbNeedCorrect: TCheckBox
      Left = 8
      Top = 56
      Width = 225
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1087#1086#1079#1080#1094#1080#1080' '#1089' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1086#1081
      TabOrder = 1
      OnClick = cbNeedCorrectClick
    end
  end
  object pButtons: TPanel
    Left = 0
    Top = 0
    Width = 793
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object btnGotoCore: TSpeedButton
      Left = 5
      Top = 3
      Width = 105
      Height = 25
      Action = actFlipCore
    end
    object btnGotoMNN: TSpeedButton
      Left = 117
      Top = 3
      Width = 177
      Height = 25
      Caption = 'GotoMNN'
      Visible = False
    end
  end
  inherited tCheckVolume: TTimer
    Left = 480
    Top = 176
  end
  object dsOrders: TDataSource
    DataSet = adsOrders
    Left = 144
    Top = 256
  end
  object frdsOrders: TfrDBDataSet
    DataSource = dsOrders
    Left = 144
    Top = 288
  end
  object adsOrdersOld: TpFIBDataSet
    UpdateSQL.Strings = (
      'update'
      '  orders'
      'set'
      '  ordercount = :ordercount'
      'where'
      '  orderid = :orderid'
      'and coreid = :coreid')
    DeleteSQL.Strings = (
      'delete from orders'
      'where'
      '  orderid = :orderid'
      'and coreid = :coreid')
    SelectSQL.Strings = (
      'SELECT Orders.OrderId,'
      '    Orders.ClientId,'
      '    Orders.CoreId,'
      '    products.catalogid as fullcode,'
      '    orders.productid,'
      '    Orders.codefirmcr,'
      '    Orders.synonymcode,'
      '    Orders.synonymfirmcrcode,'
      '    Orders.code,'
      '    Orders.codecr,'
      '    Orders.synonymname,'
      '    Orders.synonymfirm,'
      '    Orders.price,'
      '    Orders.await,'
      '    Orders.junk,'
      '    Orders.ordercount,'
      '    Orders.SendPrice*Orders.OrderCount AS SumOrder,'
      '    Orders.SendPrice,'
      '    core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    Orders.requestratio as Ordersrequestratio,'
      '    Orders.ordercost as Ordersordercost,'
      '    Orders.minordercount as Ordersminordercount   '
      'FROM '
      '  Orders'
      '  left join products on products.productid = orders.productid'
      '  left join core on core.coreid = orders.coreid'
      'WHERE '
      '    (Orders.OrderId=:OrderId)'
      'AND (OrderCount>0)'
      'ORDER BY SynonymName, SynonymFirm')
    AfterPost = adsOrdersOldAfterPost
    BeforePost = adsOrdersOldBeforePost
    Database = DM.MainConnectionOld
    AutoCommit = True
    Left = 144
    Top = 184
    oTrimCharFields = False
    oCacheCalcFields = True
    oRefreshAfterPost = False
    object adsOrdersOldCryptPRICE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPRICE'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsOrdersOldCryptSUMORDER: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptSUMORDER'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsOrdersOldORDERID: TFIBBCDField
      FieldName = 'ORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersOldCLIENTID: TFIBBCDField
      FieldName = 'CLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersOldCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersOldFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersOldCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersOldSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersOldSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
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
    object adsOrdersOldPRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsOrdersOldAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsOrdersOldJUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsOrdersOldSUMORDER: TFIBBCDField
      FieldName = 'SUMORDER'
      Size = 2
      RoundByScale = True
    end
    object adsOrdersOldSENDPRICE: TFIBBCDField
      FieldName = 'SENDPRICE'
      Size = 2
      RoundByScale = True
    end
    object adsOrdersOldREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
    end
    object adsOrdersOldORDERCOST: TFIBBCDField
      FieldName = 'ORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsOrdersOldMINORDERCOUNT: TFIBIntegerField
      FieldName = 'MINORDERCOUNT'
    end
    object adsOrdersOldPRODUCTID: TFIBBCDField
      FieldName = 'PRODUCTID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersOldORDERSREQUESTRATIO: TFIBIntegerField
      FieldName = 'ORDERSREQUESTRATIO'
    end
    object adsOrdersOldORDERSORDERCOST: TFIBBCDField
      FieldName = 'ORDERSORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsOrdersOldORDERSMINORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERSMINORDERCOUNT'
    end
  end
  object tmrCheckOrderCount: TTimer
    Enabled = False
    Interval = 250
    OnTimer = tmrCheckOrderCountTimer
    Left = 264
    Top = 136
  end
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 640
    Top = 216
  end
  object adsOrders: TMyQuery
    SQLDelete.Strings = (
      'DELETE FROM OrdersList'
      'WHERE'
      '  ID = :Old_ID')
    SQLUpdate.Strings = (
      'UPDATE OrdersList'
      'SET'
      '  ORDERCOUNT = :ORDERCOUNT,'
      '  DropReason = if(:ORDERCOUNT = 0, null, DropReason),'
      '  ServerCost = if(:ORDERCOUNT = 0, null, ServerCost),'
      '  ServerQuantity = if(:ORDERCOUNT = 0, null, ServerQuantity)'
      'WHERE'
      '  ID = :Old_ID')
    SQLRefresh.Strings = (
      'SELECT OrdersList.Id, OrdersList.ORDERCOUNT '
      'FROM OrdersList'
      'WHERE'
      '    (OrdersList.ID = :ID)')
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    OrdersList.Id, '
      '    OrdersList.OrderId,'
      '    OrdersList.ClientId,'
      '    OrdersList.CoreId,'
      '    products.catalogid as fullcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    OrdersList.productid,'
      '    OrdersList.codefirmcr,'
      '    OrdersList.synonymcode,'
      '    OrdersList.synonymfirmcrcode,'
      '    OrdersList.code,'
      '    OrdersList.codecr,'
      '    OrdersList.synonymname,'
      '    OrdersList.synonymfirm,'
      '    OrdersList.await,'
      '    OrdersList.junk,'
      '    OrdersList.ordercount,'
      '    OrdersList.RealPrice,'
      '    OrdersList.price,'
      '    core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    OrdersList.requestratio as Ordersrequestratio,'
      '    OrdersList.ordercost as Ordersordercost,'
      '    OrdersList.minordercount as Ordersminordercount,'
      '    OrdersList.DropReason,'
      '    OrdersList.ServerCost,'
      '    OrdersList.ServerQuantity,'
      '    OrdersList.SupplierPriceMarkup,'
      '    Mnn.Id as MnnId,'
      '    Mnn.Mnn,'
      '    OrdersList.RetailMarkup'
      'FROM '
      '  OrdersList'
      
        '  left join products on products.productid = OrdersList.producti' +
        'd'
      '  left join catalogs on catalogs.fullcode = products.catalogid '
      '  left join Mnn on mnn.Id = Catalogs.MnnId'
      '  left join core on core.coreid = OrdersList.coreid'
      'WHERE '
      '    (OrdersList.OrderId = :OrderId)'
      'AND (OrderCount>0)'
      
        'and ((:NeedCorrect = 0) or ((:NeedCorrect = 1) and (OrdersList.D' +
        'ropReason is not null)))'
      'ORDER BY SynonymName, SynonymFirm')
    RefreshOptions = [roAfterUpdate]
    BeforePost = adsOrdersOldBeforePost
    AfterPost = adsOrdersOldAfterPost
    AfterScroll = adsOrdersAfterScroll
    Options.StrictUpdate = False
    Left = 184
    Top = 184
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OrderId'
      end
      item
        DataType = ftUnknown
        Name = 'NeedCorrect'
      end
      item
        DataType = ftUnknown
        Name = 'NeedCorrect'
      end>
    object adsOrdersOrderId: TLargeintField
      FieldName = 'OrderId'
    end
    object adsOrdersClientId: TLargeintField
      FieldName = 'ClientId'
    end
    object adsOrdersCoreId: TLargeintField
      FieldName = 'CoreId'
    end
    object adsOrdersfullcode: TLargeintField
      FieldName = 'fullcode'
    end
    object adsOrdersproductid: TLargeintField
      FieldName = 'productid'
    end
    object adsOrderscodefirmcr: TLargeintField
      FieldName = 'codefirmcr'
    end
    object adsOrderssynonymcode: TLargeintField
      FieldName = 'synonymcode'
    end
    object adsOrderssynonymfirmcrcode: TLargeintField
      FieldName = 'synonymfirmcrcode'
    end
    object adsOrderscode: TStringField
      FieldName = 'code'
      Size = 84
    end
    object adsOrderscodecr: TStringField
      FieldName = 'codecr'
      Size = 84
    end
    object adsOrderssynonymname: TStringField
      FieldName = 'synonymname'
      Size = 250
    end
    object adsOrderssynonymfirm: TStringField
      FieldName = 'synonymfirm'
      Size = 250
    end
    object adsOrdersawait: TBooleanField
      FieldName = 'await'
    end
    object adsOrdersjunk: TBooleanField
      FieldName = 'junk'
    end
    object adsOrdersordercount: TIntegerField
      FieldName = 'ordercount'
    end
    object adsOrdersprice: TFloatField
      FieldName = 'price'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsOrdersrequestratio: TIntegerField
      FieldName = 'requestratio'
    end
    object adsOrdersordercost: TFloatField
      FieldName = 'ordercost'
    end
    object adsOrdersminordercount: TIntegerField
      FieldName = 'minordercount'
    end
    object adsOrdersOrdersrequestratio: TIntegerField
      FieldName = 'Ordersrequestratio'
    end
    object adsOrdersOrdersordercost: TFloatField
      FieldName = 'Ordersordercost'
    end
    object adsOrdersOrdersminordercount: TIntegerField
      FieldName = 'Ordersminordercount'
    end
    object adsOrdersSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsOrdersId: TLargeintField
      FieldName = 'Id'
    end
    object adsOrdersRealPrice: TFloatField
      FieldName = 'RealPrice'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsOrdersDropReason: TSmallintField
      FieldName = 'DropReason'
    end
    object adsOrdersServerCost: TFloatField
      FieldName = 'ServerCost'
    end
    object adsOrdersServerQuantity: TIntegerField
      FieldName = 'ServerQuantity'
    end
    object adsOrdersSupplierPriceMarkup: TFloatField
      FieldName = 'SupplierPriceMarkup'
    end
    object adsOrdersMnnId: TLargeintField
      FieldName = 'MnnId'
    end
    object adsOrdersMnn: TStringField
      FieldName = 'Mnn'
      Size = 250
    end
    object adsOrdersDescriptionId: TLargeintField
      FieldName = 'DescriptionId'
    end
    object adsOrdersCatalogVitallyImportant: TBooleanField
      FieldName = 'CatalogVitallyImportant'
    end
    object adsOrdersCatalogMandatoryList: TBooleanField
      FieldName = 'CatalogMandatoryList'
    end
    object adsOrdersRetailPrice: TFloatField
      FieldKind = fkCalculated
      FieldName = 'RetailPrice'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsOrdersRetailMarkup: TFloatField
      FieldName = 'RetailMarkup'
    end
  end
  object ActionList: TActionList
    Left = 360
    Top = 187
    object actFlipCore: TAction
      Caption = #1042' '#1082#1072#1090#1072#1083#1086#1075' (F2)'
      ShortCut = 113
      OnExecute = actFlipCoreExecute
    end
  end
end
