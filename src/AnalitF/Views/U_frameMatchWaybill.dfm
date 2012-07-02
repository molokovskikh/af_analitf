object frameMatchWaybill: TframeMatchWaybill
  Left = 0
  Top = 0
  Width = 783
  Height = 246
  TabOrder = 0
  object pNotFound: TPanel
    Left = 0
    Top = 0
    Width = 783
    Height = 246
    Align = alClient
    BevelOuter = bvNone
    Caption = #1053#1072#1082#1083#1072#1076#1085#1099#1093' '#1085#1077' '#1085#1072#1081#1076#1077#1085#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object pGrid: TPanel
    Left = 0
    Top = 0
    Width = 783
    Height = 246
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pOrderHeader: TPanel
      Left = 0
      Top = 0
      Width = 783
      Height = 51
      Align = alTop
      BevelInner = bvLowered
      TabOrder = 0
      DesignSize = (
        783
        51)
      object dbtProviderName: TDBText
        Left = 515
        Top = 9
        Width = 176
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        DataField = 'ProviderName'
        DataSource = dsDocumentHeaders
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 116
        Top = 9
        Width = 13
        Height = 13
        Caption = #8470
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtId: TDBText
        Left = 139
        Top = 9
        Width = 109
        Height = 13
        DataField = 'DownloadId'
        DataSource = dsDocumentHeaders
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 252
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
        Left = 269
        Top = 9
        Width = 124
        Height = 13
        DataField = 'LocalWriteTime'
        DataSource = dsDocumentHeaders
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblRecordCount: TLabel
        Left = 252
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
      object dbtPositions: TDBText
        Left = 315
        Top = 29
        Width = 62
        Height = 13
        DataField = 'Positions'
        DataSource = dsDocumentHeaders
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 435
        Top = 9
        Width = 74
        Height = 13
        Caption = #1087#1086#1089#1090#1072#1074#1097#1080#1082' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lProviderDocumentId: TLabel
        Left = 11
        Top = 29
        Width = 89
        Height = 13
        Caption = #8470' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtProviderDocumentId: TDBText
        Left = 139
        Top = 29
        Width = 109
        Height = 13
        DataField = 'ProviderDocumentId'
        DataSource = dsDocumentHeaders
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 11
        Top = 9
        Width = 66
        Height = 13
        Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object dbgWaybill: TDBGridEh
      Left = 0
      Top = 51
      Width = 783
      Height = 195
      Align = alClient
      AllowedOperations = [alopUpdateEh]
      AutoFitColWidths = True
      DataSource = dsDocumentBodies
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
    end
  end
  object dsDocumentBodies: TDataSource
    DataSet = adsDocumentBodies
    Left = 32
    Top = 83
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
      '  dbodies.ServerDocumentId = :ServerDocumentId'
      'order by dbodies.Product')
    RefreshOptions = [roAfterInsert, roAfterUpdate]
    KeyFields = 'Id'
    Left = 72
    Top = 99
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ServerDocumentId'
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
      DisplayFormat = '0.00;;'#39#39
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
  object tmrShowMatchWaybill: TTimer
    Enabled = False
    Interval = 350
    OnTimer = tmrShowMatchWaybillTimer
    Left = 152
    Top = 100
  end
  object adsDocumentHeaders: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      'dh.Id,'
      'ifnull(dh.DownloadId, dh.Id) as DownloadId,'
      'dh.WriteTime,'
      'dh.FirmCode,'
      'dh.ClientId,'
      'dh.DocumentType,'
      'dh.ProviderDocumentId,'
      'dh.OrderId,'
      'dh.Header,'
      'dh.LoadTime,'
      'dh.RetailAmountCalculated,'
      'dh.WriteTime as LocalWriteTime,'
      'dh.CreatedByUser,'
      
        'if(p.FirmCode is null, dh.SupplierNameByUser, p.FullName) as Pro' +
        'viderName,'
      'count(dbodies.Id) as Positions,'
      'invoiceheaders.Id,'
      'invoiceheaders.InvoiceNumber,'
      'invoiceheaders.InvoiceDate,'
      'invoiceheaders.SellerName,'
      'invoiceheaders.SellerAddress,'
      'invoiceheaders.SellerINN,'
      'invoiceheaders.SellerKPP,'
      'invoiceheaders.ShipperInfo,'
      'invoiceheaders.ConsigneeInfo,'
      'invoiceheaders.PaymentDocumentInfo,'
      'invoiceheaders.BuyerName,'
      'invoiceheaders.BuyerAddress,'
      'invoiceheaders.BuyerINN,'
      'invoiceheaders.BuyerKPP,'
      'invoiceheaders.AmountWithoutNDS0,'
      'invoiceheaders.AmountWithoutNDS10,'
      'invoiceheaders.NDSAmount10,'
      'invoiceheaders.Amount10,'
      'invoiceheaders.AmountWithoutNDS18,'
      'invoiceheaders.NDSAmount18,'
      'invoiceheaders.Amount18,'
      'invoiceheaders.AmountWithoutNDS,'
      'invoiceheaders.NDSAmount,'
      'invoiceheaders.Amount'
      'from'
      '  DocumentHeaders dh'
      '  left join providers p on p.FirmCode = dh.FirmCode'
      '  left join DocumentBodies dbodies on dbodies.DocumentId = dh.Id'
      '  left join invoiceheaders on invoiceheaders.Id = dh.ServerId'
      'where'
      '    (dh.ServerId = :ServerDocumentId)')
    Left = 56
    Top = 159
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ServerDocumentId'
      end>
    object adsDocumentHeadersId: TLargeintField
      FieldName = 'Id'
    end
    object adsDocumentHeadersDownloadId: TLargeintField
      FieldName = 'DownloadId'
    end
    object adsDocumentHeadersWriteTime: TDateTimeField
      FieldName = 'WriteTime'
    end
    object adsDocumentHeadersFirmCode: TLargeintField
      FieldName = 'FirmCode'
    end
    object adsDocumentHeadersClientId: TLargeintField
      FieldName = 'ClientId'
    end
    object adsDocumentHeadersDocumentType: TWordField
      Alignment = taLeftJustify
      FieldName = 'DocumentType'
    end
    object adsDocumentHeadersProviderDocumentId: TStringField
      FieldName = 'ProviderDocumentId'
    end
    object adsDocumentHeadersOrderId: TLargeintField
      FieldName = 'OrderId'
    end
    object adsDocumentHeadersHeader: TStringField
      FieldName = 'Header'
      Size = 255
    end
    object adsDocumentHeadersProviderName: TStringField
      FieldName = 'ProviderName'
      Size = 255
    end
    object adsDocumentHeadersPositions: TLargeintField
      FieldName = 'Positions'
    end
    object adsDocumentHeadersLocalWriteTime: TDateTimeField
      FieldName = 'LocalWriteTime'
    end
    object adsDocumentHeadersCreatedByUser: TBooleanField
      FieldName = 'CreatedByUser'
    end
  end
  object dsDocumentHeaders: TDataSource
    DataSet = adsDocumentHeaders
    Left = 136
    Top = 151
  end
end
