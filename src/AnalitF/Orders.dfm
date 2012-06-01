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
    object gbMessageTo: TGroupBox
      Left = 1
      Top = 264
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
      Top = 224
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
    object gbComment: TGroupBox
      Left = 1
      Top = 184
      Width = 791
      Height = 40
      Align = alBottom
      Caption = ' '#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '
      TabOrder = 3
      object dbmComment: TDBMemo
        Left = 2
        Top = 15
        Width = 787
        Height = 23
        Align = alClient
        DataField = 'Comment'
        DataSource = dsOrders
        TabOrder = 0
        OnExit = dbmCommentExit
        OnKeyDown = dbmCommentKeyDown
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
      '    Producers.Name as ProducerName,'
      '    ol.RetailVitallyImportant,'
      '    ol.Comment'
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
      'WHERE '
      '    (ol.OrderId = :OrderId)'
      'AND (OrderCount>0)'
      
        'and ((:NeedCorrect = 0) or ((:NeedCorrect = 1) and (ol.DropReaso' +
        'n is not null)))'
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
  object dsDocumentBodies: TDataSource
    DataSet = adsDocumentBodies
    Left = 152
    Top = 243
  end
  object adsDocumentBodies: TMyQuery
    SQLRefresh.Strings = (
      'select'
      'Id,'
      'dbodies.DocumentId,'
      'dbodies.ServerId,'
      'dbodies.ServerDocumentId,'
      'dbodies.Product,'
      'dbodies.Code,'
      'dbodies.Certificates,'
      'dbodies.Period,'
      'dbodies.Producer,'
      'dbodies.Country,'
      'dbodies.ProducerCost,'
      'dbodies.RegistryCost,'
      'dbodies.SupplierPriceMarkup,'
      'dbodies.SupplierCostWithoutNDS,'
      'dbodies.SupplierCost,'
      'dbodies.Quantity,'
      'dbodies.VitallyImportant,'
      'dbodies.NDS,'
      'dbodies.SerialNumber,'
      'dbodies.RetailMarkup,'
      'dbodies.ManualCorrection,'
      'dbodies.ManualRetailPrice,'
      'dbodies.Printed,'
      'dbodies.Amount,'
      'dbodies.NdsAmount,'
      'dbodies.RetailAmount,'
      'dbodies.Unit,'
      'dbodies.ExciseTax,'
      'dbodies.BillOfEntryNumber,'
      'dbodies.EAN13,'
      'dbodies.RequestCertificate,'
      'dbodies.CertificateId,'
      'cr.DocumentBodyId,'
      'catalogs.Markup as CatalogMarkup,'
      'catalogs.MaxMarkup as CatalogMaxMarkup,'
      'catalogs.MaxSupplierMarkup as CatalogMaxSupplierMarkup'
      'from'
      '  DocumentBodies dbodies'
      
        '  left join CertificateRequests cr on cr.DocumentBodyId = dbodie' +
        's.ServerId'
      '  left join products p on p.productid = dbodies.productid'
      '  left join catalogs on catalogs.fullcode = p.catalogid'
      'where'
      '  dbodies.Id = :OLD_Id')
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      'Id,'
      'dbodies.DocumentId,'
      'dbodies.ServerId,'
      'dbodies.ServerDocumentId,'
      'dbodies.Product,'
      'dbodies.Code,'
      'dbodies.Certificates,'
      'dbodies.Period,'
      'dbodies.Producer,'
      'dbodies.Country,'
      'dbodies.ProducerCost,'
      'dbodies.RegistryCost,'
      'dbodies.SupplierPriceMarkup,'
      'dbodies.SupplierCostWithoutNDS,'
      'dbodies.SupplierCost,'
      'dbodies.Quantity,'
      'dbodies.VitallyImportant,'
      'dbodies.NDS,'
      'dbodies.SerialNumber,'
      'dbodies.RetailMarkup,'
      'dbodies.ManualCorrection,'
      'dbodies.ManualRetailPrice,'
      'dbodies.Printed,'
      'dbodies.Amount,'
      'dbodies.NdsAmount,'
      'dbodies.RetailAmount,'
      'dbodies.Unit,'
      'dbodies.ExciseTax,'
      'dbodies.BillOfEntryNumber,'
      'dbodies.EAN13,'
      'dbodies.RequestCertificate,'
      'dbodies.CertificateId,'
      'cr.DocumentBodyId,'
      'catalogs.Markup as CatalogMarkup,'
      'catalogs.MaxMarkup as CatalogMaxMarkup,'
      'catalogs.MaxSupplierMarkup as CatalogMaxSupplierMarkup'
      'from'
      '  DocumentBodies dbodies'
      
        '  left join CertificateRequests cr on cr.DocumentBodyId = dbodie' +
        's.ServerId'
      '  left join products p on p.productid = dbodies.productid'
      '  left join catalogs on catalogs.fullcode = p.catalogid'
      'where'
      '  dbodies.DocumentId = :DocumentId')
    RefreshOptions = [roAfterInsert, roAfterUpdate]
    KeyFields = 'Id'
    Left = 208
    Top = 251
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DocumentId'
      end>
    object adsDocumentBodiesId: TLargeintField
      FieldName = 'Id'
    end
    object adsDocumentBodiesDocumentId: TLargeintField
      FieldName = 'DocumentId'
    end
    object adsDocumentBodiesProduct: TStringField
      FieldName = 'Product'
      Size = 255
    end
    object adsDocumentBodiesCode: TStringField
      FieldName = 'Code'
    end
    object adsDocumentBodiesCertificates: TStringField
      FieldName = 'Certificates'
      Size = 50
    end
    object adsDocumentBodiesPeriod: TStringField
      FieldName = 'Period'
    end
    object adsDocumentBodiesProducer: TStringField
      FieldName = 'Producer'
      Size = 255
    end
    object adsDocumentBodiesCountry: TStringField
      FieldName = 'Country'
      Size = 150
    end
    object adsDocumentBodiesProducerCost: TFloatField
      FieldName = 'ProducerCost'
    end
    object adsDocumentBodiesRegistryCost: TFloatField
      FieldName = 'RegistryCost'
    end
    object adsDocumentBodiesSupplierPriceMarkup: TFloatField
      FieldName = 'SupplierPriceMarkup'
    end
    object adsDocumentBodiesSupplierCostWithoutNDS: TFloatField
      FieldName = 'SupplierCostWithoutNDS'
    end
    object adsDocumentBodiesSupplierCost: TFloatField
      FieldName = 'SupplierCost'
    end
    object adsDocumentBodiesQuantity: TIntegerField
      FieldName = 'Quantity'
    end
    object adsDocumentBodiesVitallyImportant: TBooleanField
      FieldName = 'VitallyImportant'
    end
    object adsDocumentBodiesSerialNumber: TStringField
      FieldName = 'SerialNumber'
      Size = 50
    end
    object adsDocumentBodiesPrinted: TBooleanField
      FieldName = 'Printed'
    end
    object adsDocumentBodiesAmount: TFloatField
      FieldName = 'Amount'
    end
    object adsDocumentBodiesNdsAmount: TFloatField
      FieldName = 'NdsAmount'
    end
    object adsDocumentBodiesUnit: TStringField
      FieldName = 'Unit'
      Size = 0
    end
    object adsDocumentBodiesExciseTax: TFloatField
      FieldName = 'ExciseTax'
    end
    object adsDocumentBodiesBillOfEntryNumber: TStringField
      FieldName = 'BillOfEntryNumber'
    end
    object adsDocumentBodiesEAN13: TStringField
      FieldName = 'EAN13'
    end
    object adsDocumentBodiesRequestCertificate: TBooleanField
      FieldName = 'RequestCertificate'
    end
    object adsDocumentBodiesCertificateId: TLargeintField
      FieldName = 'CertificateId'
    end
    object adsDocumentBodiesDocumentBodyId: TLargeintField
      FieldName = 'DocumentBodyId'
    end
    object adsDocumentBodiesServerId: TLargeintField
      FieldName = 'ServerId'
    end
    object adsDocumentBodiesServerDocumentId: TLargeintField
      FieldName = 'ServerDocumentId'
    end
    object adsDocumentBodiesCatalogMarkup: TFloatField
      FieldName = 'CatalogMarkup'
    end
    object adsDocumentBodiesCatalogMaxMarkup: TFloatField
      FieldName = 'CatalogMaxMarkup'
    end
    object adsDocumentBodiesCatalogMaxSupplierMarkup: TFloatField
      FieldName = 'CatalogMaxSupplierMarkup'
    end
  end
  object shPositionFullUpdate: TStrHolder
    Capacity = 44
    Macros = <>
    Left = 304
    Top = 391
    InternalVer = 1
    StrData = (
      ''
      '757064617465'
      '2020446f63756d656e74426f646965732064626f64696573'
      '736574'
      
        '202052657461696c4d61726b757020202020203d203a52657461696c4d61726b' +
        '75702c'
      
        '20204d616e75616c436f7272656374696f6e203d203a4d616e75616c436f7272' +
        '656374696f6e2c'
      
        '20204d616e75616c52657461696c5072696365203d203a4d616e75616c526574' +
        '61696c50726963652c'
      '202052657461696c416d6f756e74203d203a52657461696c416d6f756e742c'
      '20205072696e746564203d203a5072696e7465642c'
      
        '2020526571756573744365727469666963617465203d203a5265717565737443' +
        '657274696669636174652c'
      '50726f64756374203d203a50726f647563742c20'
      '436f6465203d203a436f64652c20'
      '436572746966696361746573203d203a4365727469666963617465732c20'
      '506572696f64203d203a506572696f642c20'
      '50726f6475636572203d203a50726f64756365722c20'
      '436f756e747279203d203a436f756e7472792c20'
      '50726f6475636572436f7374203d203a50726f6475636572436f73742c20'
      '5265676973747279436f7374203d203a5265676973747279436f73742c20'
      
        '537570706c69657250726963654d61726b7570203d203a537570706c69657250' +
        '726963654d61726b75702c20'
      
        '537570706c696572436f7374576974686f75744e4453203d203a537570706c69' +
        '6572436f7374576974686f75744e44532c20'
      '537570706c696572436f7374203d203a537570706c696572436f73742c20'
      '5175616e74697479203d203a5175616e746974792c20'
      
        '566974616c6c79496d706f7274616e74203d203a566974616c6c79496d706f72' +
        '74616e742c20'
      '4e4453203d203a4e44532c20'
      '53657269616c4e756d626572203d203a53657269616c4e756d6265722c20'
      '416d6f756e74203d203a416d6f756e742c20'
      '4e6473416d6f756e74203d203a4e6473416d6f756e742c20'
      '556e6974203d203a556e69742c20'
      '457863697365546178203d203a4578636973655461782c20'
      
        '42696c6c4f66456e7472794e756d626572203d203a42696c6c4f66456e747279' +
        '4e756d6265722c20'
      '45414e3133203d203a45414e3133'
      '7768657265'
      '202064626f646965732e4964203d203a4f4c445f4964')
  end
end
