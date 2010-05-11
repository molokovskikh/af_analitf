inherited PreviousOrdersForm: TPreviousOrdersForm
  ActiveControl = gbPrevOrders
  Caption = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1079#1072#1082#1072#1079#1099
  ClientHeight = 364
  ClientWidth = 665
  PixelsPerInch = 96
  TextHeight = 13
  object gbPrevOrders: TGroupBox [0]
    Left = 0
    Top = 0
    Width = 665
    Height = 364
    Align = alClient
    Caption = ' '#1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1079#1072#1082#1072#1079#1099' '
    TabOrder = 0
    object dbgHistory: TToughDBGrid
      Left = 2
      Top = 15
      Width = 661
      Height = 316
      Align = alClient
      AutoFitColWidths = True
      DataSource = dsPreviousOrders
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
      OnKeyDown = dbgHistoryKeyDown
      SearchPosition = spBottom
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SynonymName'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = 220
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
          FieldName = 'PriceName'
          Footers = <>
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Width = 110
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
    object pBottom: TPanel
      Left = 2
      Top = 331
      Width = 661
      Height = 31
      Align = alBottom
      TabOrder = 1
      object lblPriceAvg: TLabel
        Left = 8
        Top = 10
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
        Left = 266
        Top = 10
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
    end
  end
  object dsPreviousOrders: TDataSource
    DataSet = adsPreviousOrders
    Left = 144
    Top = 208
  end
  object adsPreviousOrders: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      '#ORDERSSHOWBYFORM'
      'SELECT '
      '    products.catalogid as FullCode,'
      '    osbc.productid,'
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
      '  inner join catalogs on catalogs.FullCode = products.catalogid'
      '  INNER JOIN PostedOrderHeads ON osbc.OrderId=PostedOrderHeads.OrderId'
      'WHERE'
      '    (osbc.clientid = :ClientID)'
      'and (osbc.OrderCount > 0)'
      
        'and (((:ByShortCode = 0) and (products.catalogid = :ParentCode))' +
        ' or ((:ByShortCode = 1) and (catalogs.ShortCode = :ParentCode)))'
      'And (PostedOrderHeads.Closed = 1)'
      'ORDER BY PostedOrderHeads.SendDate DESC')
    Left = 200
    Top = 197
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ClientID'
      end
      item
        DataType = ftUnknown
        Name = 'ByShortCode'
      end
      item
        DataType = ftUnknown
        Name = 'ParentCode'
      end
      item
        DataType = ftUnknown
        Name = 'ByShortCode'
      end
      item
        DataType = ftUnknown
        Name = 'ParentCode'
      end>
    object adsPreviousOrdersFullCode: TLargeintField
      FieldName = 'FullCode'
    end
    object adsPreviousOrdersCode: TStringField
      FieldName = 'Code'
      Size = 84
    end
    object adsPreviousOrdersCodeCR: TStringField
      FieldName = 'CodeCR'
      Size = 84
    end
    object adsPreviousOrdersSynonymName: TStringField
      FieldName = 'SynonymName'
      Size = 250
    end
    object adsPreviousOrdersSynonymFirm: TStringField
      FieldName = 'SynonymFirm'
      Size = 250
    end
    object adsPreviousOrdersOrderCount: TIntegerField
      FieldName = 'OrderCount'
    end
    object adsPreviousOrdersOrderDate: TDateTimeField
      FieldName = 'OrderDate'
    end
    object adsPreviousOrdersPriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsPreviousOrdersRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsPreviousOrdersPrice: TFloatField
      FieldName = 'Price'
    end
    object adsPreviousOrdersAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsPreviousOrdersJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsPreviousOrdersproductid: TLargeintField
      FieldName = 'productid'
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
    MasterSource = dsPreviousOrders
    MasterFields = 'productid'
    DetailFields = 'PRODUCTID'
    Left = 360
    Top = 205
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CLIENTID'
      end
      item
        DataType = ftUnknown
        Name = 'productid'
      end>
    object adsAvgOrdersPRICEAVG: TFloatField
      FieldName = 'PRICEAVG'
    end
    object adsAvgOrdersPRODUCTID: TLargeintField
      FieldName = 'PRODUCTID'
    end
  end
  object dsAvgOrders: TDataSource
    DataSet = adsAvgOrders
    Left = 312
    Top = 216
  end
end
