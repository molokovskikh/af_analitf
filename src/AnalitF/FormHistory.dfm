object FormsHistoryForm: TFormsHistoryForm
  Left = 281
  Top = 180
  ActiveControl = Grid
  BorderStyle = bsDialog
  Caption = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1079#1072#1082#1072#1079#1099
  ClientHeight = 385
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object dbtName: TDBText
    Left = 8
    Top = 8
    Width = 51
    Height = 13
    AutoSize = True
    DataField = 'NAME'
    DataSource = dsCatalogName
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object dbrForm: TDBText
    Left = 8
    Top = 24
    Width = 46
    Height = 13
    AutoSize = True
    DataField = 'FORM'
    DataSource = dsCatalogName
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 126
    Top = 358
    Width = 233
    Height = 13
    Caption = #1057#1088#1077#1076#1085#1103#1103' '#1094#1077#1085#1072' '#1087#1086' '#1087#1086#1089#1083#1077#1076#1085#1080#1084' '#1079#1072#1103#1074#1082#1072#1084' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lPriceAvg: TLabel
    Left = 363
    Top = 358
    Width = 55
    Height = 13
    Caption = 'lPriceAvg'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Grid: TToughDBGrid
    Left = 8
    Top = 48
    Width = 713
    Height = 297
    AutoFitColWidths = True
    DataSource = dsPreviosOrders
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    SearchPosition = spBottom
    Columns = <
      item
        EditButtons = <>
        FieldName = 'SynonymFirm'
        Footers = <>
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Width = 149
      end
      item
        EditButtons = <>
        FieldName = 'PriceName'
        Footers = <>
        Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
        Width = 109
      end
      item
        EditButtons = <>
        FieldName = 'RegionName'
        Footers = <>
        Title.Caption = #1056#1077#1075#1080#1086#1085
        Width = 94
      end
      item
        DisplayFormat = 'dd.mm.yyyy hh:nn'
        EditButtons = <>
        FieldName = 'OrderDate'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072
        Width = 85
      end
      item
        EditButtons = <>
        FieldName = 'OrderCount'
        Footers = <>
        Title.Caption = #1047#1072#1082#1072#1079
        Width = 57
      end
      item
        EditButtons = <>
        FieldName = 'Price'
        Footers = <>
        Title.Caption = #1062#1077#1085#1072
        Width = 82
      end>
  end
  object btnClose: TButton
    Left = 8
    Top = 352
    Width = 97
    Height = 27
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object dsPreviosOrders: TDataSource
    DataSet = adsPreviosOrders
    Left = 112
    Top = 200
  end
  object adsOrdersOld: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    FULLCODE,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    ORDERCOUNT,'
      '    CODE,'
      '    CODECR,'
      '    PRICE,'
      '    ORDERDATE,'
      '    PRICENAME,'
      '    REGIONNAME,'
      '    AWAIT,'
      '    JUNK,'
      '    sendprice'
      'FROM'
      '    ORDERSSHOWBYFORM(:AFULLCODE,'
      '    :ACLIENTID) ')
    Left = 112
    Top = 152
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
    object adsOrdersOldORDERDATE: TFIBDateTimeField
      FieldName = 'ORDERDATE'
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
      '    OrdersHead.SendDate as OrderDate,'
      '    OrdersHead.PriceName,'
      '    OrdersHead.RegionName,'
      '    osbc.Await,'
      '    osbc.Junk'
      'FROM'
      '  OrdersList osbc'
      '  inner join products on products.productid = osbc.productid'
      '  INNER JOIN OrdersHead ON osbc.OrderId=OrdersHead.OrderId'
      'WHERE'
      '    (osbc.clientid = :ClientID)'
      'and (osbc.OrderCount > 0)'
      
        'and (((:GroupByProducts = 0) and (products.catalogid = :FullCode' +
        ')) or ((:GroupByProducts = 1) and (osbc.productid = :productid))' +
        ')'
      'And (OrdersHead.Closed = 1)'
      'ORDER BY OrdersHead.SendDate DESC'
      'limit 20')
    Left = 152
    Top = 152
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
  object adsCatalogName: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      '*'
      'from'
      'Catalogs'
      'where'
      'FullCode = :FullCode')
    Left = 128
    Top = 264
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'FullCode'
      end>
    object adsCatalogNameNAME: TStringField
      FieldName = 'NAME'
      Size = 250
    end
    object adsCatalogNameFORM: TStringField
      FieldName = 'FORM'
      Size = 250
    end
  end
  object dsCatalogName: TDataSource
    DataSet = adsCatalogName
    Left = 176
    Top = 264
  end
end
