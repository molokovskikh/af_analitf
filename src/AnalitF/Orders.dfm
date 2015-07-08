inherited OrdersForm: TOrdersForm
  Left = 318
  Top = 240
  ActiveControl = dbgOrders
  Caption = #1040#1088#1093#1080#1074#1085#1099#1081' '#1079#1072#1082#1072#1079
  ClientHeight = 443
  ClientWidth = 793
  OldCreateOrder = True
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pClient: TPanel [0]
    Left = 0
    Top = 108
    Width = 793
    Height = 335
    Align = alClient
    TabOrder = 0
    object dbgOrders: TToughDBGrid
      Left = 1
      Top = 1
      Width = 791
      Height = 183
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
          FieldName = 'Period'
          Footers = <>
          Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
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
    object pClientBottom: TPanel
      Left = 1
      Top = 184
      Width = 791
      Height = 150
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'pClientBottom'
      TabOrder = 1
      object pClientRight: TPanel
        Left = 526
        Top = 0
        Width = 265
        Height = 150
        Align = alRight
        BevelOuter = bvNone
        Caption = 'pClientRight'
        TabOrder = 0
        object gbMessageTo: TGroupBox
          Left = 0
          Top = 0
          Width = 265
          Height = 150
          Align = alClient
          Caption = ' '#1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '
          TabOrder = 0
          object dbmMessageTo: TDBMemo
            Left = 2
            Top = 15
            Width = 261
            Height = 133
            Align = alClient
            DataField = 'MessageTo'
            DataSource = OrdersHForm.dsOrdersH
            TabOrder = 0
            OnExit = dbmMessageToExit
            OnKeyDown = dbmMessageToKeyDown
          end
        end
      end
      object pClientLeft: TPanel
        Left = 0
        Top = 0
        Width = 526
        Height = 150
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pClientLeft'
        TabOrder = 1
        object gbComment: TGroupBox
          Left = 0
          Top = 70
          Width = 526
          Height = 40
          Align = alBottom
          Caption = ' '#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '
          TabOrder = 0
          object dbmComment: TDBMemo
            Left = 2
            Top = 15
            Width = 522
            Height = 23
            Align = alClient
            DataField = 'Comment'
            DataSource = dsOrders
            TabOrder = 0
            OnExit = dbmCommentExit
            OnKeyDown = dbmCommentKeyDown
          end
        end
        object gbCorrectMessage: TGroupBox
          Left = 0
          Top = 110
          Width = 526
          Height = 40
          Align = alBottom
          Caption = ' '#1055#1088#1080#1095#1080#1085#1072' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' '
          TabOrder = 1
          object mCorrectMessage: TMemo
            Left = 2
            Top = 15
            Width = 522
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
    end
  end
  object pTop: TPanel [1]
    Left = 0
    Top = 33
    Width = 793
    Height = 75
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
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
      object lDatePrice: TLabel
        Left = 632
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
      object dbtDatePrice: TDBText
        Left = 649
        Top = 9
        Width = 124
        Height = 13
        DataField = 'DatePrice'
        DataSource = OrdersHForm.dsOrdersH
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
  object pButtons: TPanel [2]
    Left = 0
    Top = 0
    Width = 793
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
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
    object btnGotoPrice: TSpeedButton
      Left = 301
      Top = 3
      Width = 105
      Height = 25
      Caption = #1042' '#1087#1088#1072#1081#1089
      OnClick = btnGotoPriceClick
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
  object tmrCheckOrderCount: TTimer
    Enabled = False
    Interval = 250
    OnTimer = tmrCheckOrderCountTimer
    Left = 264
    Top = 136
  end
  object adsOrders: TMyQuery
    SQLDelete.Strings = (
      'DELETE FROM CurrentOrderLists'
      'WHERE'
      '  ID = :Old_ID')
    SQLUpdate.Strings = (
      'UPDATE CurrentOrderLists'
      'SET'
      '  ORDERCOUNT = :ORDERCOUNT,'
      '  DropReason = if(:ORDERCOUNT = 0, null, DropReason),'
      '  ServerCost = if(:ORDERCOUNT = 0, null, ServerCost),'
      '  ServerQuantity = if(:ORDERCOUNT = 0, null, ServerQuantity),'
      '  RetailCost = :RetailCost,'
      '  Comment = :Comment'
      'WHERE'
      '  ID = :Old_ID')
    SQLRefresh.Strings = (
      'SELECT '
      '  CurrentOrderLists.Id, '
      '  CurrentOrderLists.ORDERCOUNT, '
      '  CurrentOrderLists.RetailCost,'
      '  CurrentOrderLists.Comment'
      'FROM CurrentOrderLists'
      'WHERE'
      '    (CurrentOrderLists.ID = :ID)')
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    ol.Id, '
      '    ol.OrderId,'
      '    ol.ClientId,'
      '    ol.CoreId,'
      '    products.catalogid as fullcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    catalogs.Markup,'
      '    ol.productid,'
      '    ol.codefirmcr,'
      '    ol.synonymcode,'
      '    ol.synonymfirmcrcode,'
      '    ol.code,'
      '    ol.codecr,'
      '    ol.synonymname,'
      '    ol.synonymfirm,'
      '    ol.await,'
      '    ol.junk,'
      '    ol.ordercount,'
      '    ol.RealPrice,'
      '    ol.price,'
      '    ol.VitallyImportant,'
      '    core.Quantity,'
      '    core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    ol.requestratio as Ordersrequestratio,'
      '    ol.ordercost as Ordersordercost,'
      '    ol.minordercount as Ordersminordercount,'
      '    ol.DropReason,'
      '    ol.ServerCost,'
      '    ol.ServerQuantity,'
      '    ol.ProducerCost,'
      '    ol.NDS,'
      '    ol.SupplierPriceMarkup,'
      '    Mnn.Id as MnnId,'
      '    Mnn.Mnn,'
      '    ol.RetailMarkup,'
      '    ol.RetailCost,'
      '    GroupMaxProducerCosts.MaxProducerCost,'
      '    ol.Period,'
      '    ol.Exp,'
      '    Producers.Name as ProducerName,'
      '    ol.RetailVitallyImportant,'
      '    ol.Comment,'
      '    dbodies.ServerId as ServerDocumentLineId,'
      '    dbodies.RejectId,'
      '    dbodies.ServerDocumentId,'
      '    dbodies.SupplierCost,'
      '    dbodies.Quantity as WaybillQuantity'
      'FROM '
      '  CurrentOrderLists ol'
      '  left join products on products.productid = ol.productid'
      '  left join catalogs on catalogs.fullcode = products.catalogid '
      '  left join Producers on Producers.Id = ol.CodeFirmCr'
      '  left join Mnn on mnn.Id = Catalogs.MnnId'
      '  left join GroupMaxProducerCosts on '
      '    (GroupMaxProducerCosts.ProductId = ol.productid) '
      '    and (ol.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      '  left join core on core.coreid = ol.coreid'
      
        '  left join waybillorders wo on wo.ServerOrderListId = ol.Server' +
        'OrderListId'
      
        '  left join documentbodies dbodies on dbodies.ServerId = wo.Serv' +
        'erDocumentLineId'
      'WHERE '
      '    (ol.OrderId = :OrderId)'
      'AND (OrderCount>0)'
      
        'and ((:NeedCorrect = 0) or ((:NeedCorrect = 1) and (ol.DropReaso' +
        'n is not null)))'
      'group by ol.Id'
      'ORDER BY SynonymName, SynonymFirm')
    RefreshOptions = [roAfterUpdate]
    AfterOpen = adsOrdersAfterOpen
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
    object adsOrdersProducerCost: TFloatField
      FieldName = 'ProducerCost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsOrdersNDS: TSmallintField
      FieldName = 'NDS'
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
    object adsOrdersMaxProducerCost: TFloatField
      FieldName = 'MaxProducerCost'
    end
    object adsOrdersEditRetailMarkup: TFloatField
      FieldKind = fkCalculated
      FieldName = 'EditRetailMarkup'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsOrdersVitallyImportant: TBooleanField
      FieldName = 'VitallyImportant'
    end
    object adsOrdersPeriod: TStringField
      FieldName = 'Period'
    end
    object adsOrdersProducerName: TStringField
      FieldName = 'ProducerName'
    end
    object adsOrdersRetailCost: TFloatField
      FieldName = 'RetailCost'
    end
    object adsOrdersRetailVitallyImportant: TBooleanField
      FieldName = 'RetailVitallyImportant'
    end
    object adsOrdersComment: TStringField
      FieldName = 'Comment'
    end
    object adsOrdersMarkup: TFloatField
      FieldName = 'Markup'
    end
    object adsOrdersServerDocumentLineId: TLargeintField
      FieldName = 'ServerDocumentLineId'
    end
    object adsOrdersRejectId: TLargeintField
      FieldName = 'RejectId'
    end
    object adsOrdersServerDocumentId: TLargeintField
      FieldName = 'ServerDocumentId'
    end
    object adsOrdersSupplierCost: TFloatField
      FieldName = 'SupplierCost'
    end
    object adsOrdersWaybillQuantity: TIntegerField
      FieldName = 'WaybillQuantity'
    end
    object adsOrdersQuantity: TStringField
      FieldName = 'Quantity'
    end
    object adsOrdersExp: TDateField
      FieldName = 'Exp'
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
