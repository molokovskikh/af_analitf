inherited OrdersForm: TOrdersForm
  Left = 279
  Top = 243
  ActiveControl = dbgOrders
  Caption = #1040#1088#1093#1080#1074#1085#1099#1081' '#1079#1072#1082#1072#1079
  ClientHeight = 443
  ClientWidth = 793
  OldCreateOrder = True
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
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 793
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object dbtPriceName: TDBText
      Left = 355
      Top = 9
      Width = 272
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
      Left = 76
      Top = 9
      Width = 41
      Height = 13
      DataField = 'OrderId'
      DataSource = OrdersHForm.dsOrdersH
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 124
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
      Left = 141
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
      Left = 124
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
      Width = 41
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
      Left = 275
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
      Left = 275
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
      Left = 328
      Top = 29
      Width = 283
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
      Left = 192
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
  object dbgOrders: TToughDBGrid [2]
    Left = 0
    Top = 51
    Width = 793
    Height = 359
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
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
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
        FieldName = 'SYNONYMNAME'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 97
      end
      item
        EditButtons = <>
        FieldName = 'SYNONYMFIRM'
        Footers = <>
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Title.TitleButton = True
        Width = 156
      end
      item
        EditButtons = <>
        FieldName = 'CryptPRICE'
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
        FieldName = 'ORDERCOUNT'
        Footers = <>
        Title.Caption = #1047#1072#1082#1072#1079
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'CryptSUMORDER'
        Footers = <>
        Title.Caption = #1057#1091#1084#1084#1072
        Title.TitleButton = True
      end>
  end
  inline frameLegeng: TframeLegeng [3]
    Left = 0
    Top = 410
    Width = 793
    Height = 33
    Align = alBottom
    Color = clWindow
    ParentColor = False
    TabOrder = 3
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
  object adsOrders: TpFIBDataSet
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
      '    (Orders.OrderId=:AOrderId)'
      'AND (OrderCount>0)'
      'ORDER BY SynonymName, SynonymFirm')
    AfterPost = adsOrdersAfterPost
    BeforeEdit = adsOrdersBeforeEdit
    BeforePost = adsOrdersBeforePost
    Transaction = DM.DefTran
    Database = DM.MainConnectionOld
    UpdateTransaction = DM.UpTran
    AutoCommit = True
    Left = 144
    Top = 184
    oTrimCharFields = False
    oCacheCalcFields = True
    oRefreshAfterPost = False
    object adsOrdersCryptPRICE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPRICE'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsOrdersCryptSUMORDER: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptSUMORDER'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsOrdersORDERID: TFIBBCDField
      FieldName = 'ORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersCLIENTID: TFIBBCDField
      FieldName = 'CLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsOrdersCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsOrdersSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsOrdersSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsOrdersORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsOrdersPRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsOrdersAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsOrdersJUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsOrdersSUMORDER: TFIBBCDField
      FieldName = 'SUMORDER'
      Size = 2
      RoundByScale = True
    end
    object adsOrdersSENDPRICE: TFIBBCDField
      FieldName = 'SENDPRICE'
      Size = 2
      RoundByScale = True
    end
    object adsOrdersREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
    end
    object adsOrdersORDERCOST: TFIBBCDField
      FieldName = 'ORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsOrdersMINORDERCOUNT: TFIBIntegerField
      FieldName = 'MINORDERCOUNT'
    end
    object adsOrdersPRODUCTID: TFIBBCDField
      FieldName = 'PRODUCTID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersORDERSREQUESTRATIO: TFIBIntegerField
      FieldName = 'ORDERSREQUESTRATIO'
    end
    object adsOrdersORDERSORDERCOST: TFIBBCDField
      FieldName = 'ORDERSORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsOrdersORDERSMINORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERSMINORDERCOUNT'
    end
  end
  object tmrCheckOrderCount: TTimer
    Enabled = False
    Interval = 500
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
end
