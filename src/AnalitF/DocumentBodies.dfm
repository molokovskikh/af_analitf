inherited DocumentBodiesForm: TDocumentBodiesForm
  ActiveControl = dbgDocumentBodies
  Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  ClientWidth = 856
  OnDestroy = FormDestroy
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object pOrderHeader: TPanel [0]
    Left = 0
    Top = 81
    Width = 856
    Height = 51
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    DesignSize = (
      856
      51)
    object dbtProviderName: TDBText
      Left = 515
      Top = 9
      Width = 334
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
    object dbtDocumentType: TDBText
      Left = 11
      Top = 9
      Width = 94
      Height = 13
      DataField = 'DocumentType'
      DataSource = dsDocumentHeaders
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
  end
  object pGrid: TPanel [1]
    Left = 0
    Top = 132
    Width = 856
    Height = 317
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgDocumentBodies: TDBGridEh
      Left = 0
      Top = 0
      Width = 856
      Height = 317
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
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnKeyDown = dbgDocumentBodiesKeyDown
      OnSortMarkingChanged = dbgDocumentBodiesSortMarkingChanged
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Name'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 97
        end
        item
          EditButtons = <>
          FieldName = 'Cost'
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
          FieldName = 'Quantity'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079
          Title.TitleButton = True
        end>
    end
  end
  object gbPrint: TGroupBox [2]
    Left = 0
    Top = 0
    Width = 856
    Height = 81
    Align = alTop
    Caption = ' '#1053#1072#1082#1083#1072#1076#1085#1099#1077' '
    Constraints.MinHeight = 81
    TabOrder = 2
    DesignSize = (
      856
      81)
    object sbPrintTickets: TSpeedButton
      Left = 310
      Top = 12
      Width = 121
      Height = 25
      Caption = #1055#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074
      OnClick = sbPrintTicketsClick
    end
    object sbPrintReestr: TSpeedButton
      Left = 311
      Top = 42
      Width = 121
      Height = 25
      Caption = #1055#1077#1095#1072#1090#1100' '#1088#1077#1077#1089#1090#1088#1072
      OnClick = sbPrintReestrClick
    end
    object sbEditAddress: TSpeedButton
      Left = 685
      Top = 12
      Width = 165
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1085#1072#1082#1083#1072#1076#1085#1099#1093
      OnClick = sbEditAddressClick
    end
    object sbPrintWaybill: TSpeedButton
      Left = 438
      Top = 12
      Width = 121
      Height = 25
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
      OnClick = sbPrintWaybillClick
    end
    object sbPrintInvoice: TSpeedButton
      Left = 438
      Top = 42
      Width = 121
      Height = 25
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090'-'#1092#1072#1082#1090#1091#1088#1099
      OnClick = sbPrintInvoiceClick
    end
    object sbEditTicketReportParams: TSpeedButton
      Left = 685
      Top = 42
      Width = 165
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
      OnClick = sbEditTicketReportParamsClick
    end
    object sbPrintRackCard: TSpeedButton
      Left = 566
      Top = 18
      Width = 121
      Height = 25
      Caption = #1057#1090#1077#1083#1083#1072#1078#1085#1072#1103' '#1082#1072#1088#1090#1072
      OnClick = sbPrintRackCardClick
    end
    object sbEditRackCardParams: TSpeedButton
      Left = 691
      Top = 50
      Width = 165
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1090#1077#1083#1083#1072#1078#1085#1086#1081' '#1082#1072#1088#1090#1099
      OnClick = sbEditRackCardParamsClick
    end
    object sbReestrToExcel: TSpeedButton
      Left = 574
      Top = 26
      Width = 121
      Height = 25
      Caption = #1056#1077#1077#1089#1090#1088' '#1074' Excel'
      OnClick = sbReestrToExcelClick
    end
    object sbWaybillToExcel: TSpeedButton
      Left = 582
      Top = 34
      Width = 121
      Height = 25
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1074' Excel'
      OnClick = sbWaybillToExcelClick
    end
    object lNDS: TLabel
      Left = 8
      Top = 56
      Width = 30
      Height = 13
      Caption = #1053#1044#1057' :'
    end
    object cbClearRetailPrice: TCheckBox
      Left = 8
      Top = 16
      Width = 297
      Height = 17
      Caption = #1054#1090#1073#1088#1072#1089#1099#1074#1072#1090#1100' '#1088#1086#1079#1085#1080#1095#1085#1091#1102' '#1094#1077#1085#1091' '#1076#1086' 10 '#1082#1086#1087'. '#1074' "'#1084#1077#1085#1100#1096#1077'"'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbClearRetailPriceClick
    end
    object cbWaybillAsVitallyImportant: TCheckBox
      Left = 8
      Top = 35
      Width = 297
      Height = 17
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1085#1072#1082#1083#1072#1076#1085#1091#1102' '#1082#1072#1082' '#1046#1053#1042#1051#1057
      TabOrder = 1
      OnClick = cbWaybillAsVitallyImportantClick
    end
    object cbNDS: TComboBox
      Left = 45
      Top = 53
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnSelect = cbNDSSelect
      Items.Strings = (
        #1042#1089#1077
        #1085#1077#1090' '#1079#1085#1072#1095#1077#1085#1080#1081)
    end
  end
  inherited tCheckVolume: TTimer
    Left = 104
    Top = 152
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
      'p.FullName as ProviderName,'
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
      '  ('
      '  DocumentHeaders dh,'
      '  providers p'
      '  )'
      '  left join DocumentBodies dbodies on dbodies.DocumentId = dh.Id'
      '  left join invoiceheaders on invoiceheaders.Id = dh.ServerId'
      'where'
      '    (dh.Id = :DocumentId)'
      'and (p.FirmCode = dh.FirmCode)')
    Left = 56
    Top = 159
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DocumentId'
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
      OnGetText = adsDocumentHeadersDocumentTypeGetText
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
      Size = 40
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
      OnChange = adsDocumentBodiesPrintedChange
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
      OnChange = adsDocumentBodiesPrintedChange
      OnValidate = adsDocumentBodiesRequestCertificateValidate
    end
    object adsDocumentBodiesCertificateId: TLargeintField
      FieldName = 'CertificateId'
      OnGetText = adsDocumentBodiesCertificateIdGetText
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
  object tmrPrintedChange: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrPrintedChangeTimer
    Left = 320
    Top = 167
  end
  object adsInvoiceHeaders: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
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
      '  documentHeaders'
      
        '  inner join invoiceheaders on invoiceheaders.Id = documentHeade' +
        'rs.ServerId'
      'where'
      '  documentHeaders.Id = :DocumentId')
    Left = 272
    Top = 251
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DocumentId'
      end>
  end
  object dsInvoiceHeaders: TDataSource
    DataSet = adsDocumentHeaders
    Left = 272
    Top = 219
  end
  object tmrShowCertificateWarning: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrShowCertificateWarningTimer
    Left = 376
    Top = 167
  end
  object shPositionInsert: TStrHolder
    Capacity = 8
    Macros = <>
    Left = 304
    Top = 311
    InternalVer = 1
    StrData = (
      ''
      '696e7365727420696e746f20446f63756d656e74426f64696573'
      
        '28446f63756d656e7449642c2050726f647563742c2052657461696c4d61726b' +
        '75702c204d616e75616c436f7272656374696f6e2c204d616e75616c52657461' +
        '696c50726963652c2052657461696c416d6f756e742c205072696e7465642c20' +
        '5265717565737443657274696669636174652c20436f64652c20436572746966' +
        '6963617465732c20506572696f642c2050726f64756365722c20436f756e7472' +
        '792c2050726f6475636572436f73742c205265676973747279436f73742c'
      
        '537570706c69657250726963654d61726b75702c20537570706c696572436f73' +
        '74576974686f75744e44532c20537570706c696572436f73742c205175616e74' +
        '6974792c20566974616c6c79496d706f7274616e742c204e44532c2053657269' +
        '616c4e756d6265722c20416d6f756e742c204e6473416d6f756e742c20556e69' +
        '742c204578636973655461782c2042696c6c4f66456e7472794e756d6265722c' +
        '2045414e31332920'
      '76616c75657320'
      
        '283a446f63756d656e7449642c203a50726f647563742c203a52657461696c4d' +
        '61726b75702c203a4d616e75616c436f7272656374696f6e2c203a4d616e7561' +
        '6c52657461696c50726963652c203a52657461696c416d6f756e742c2069666e' +
        '756c6c283a5072696e7465642c2031292c2069666e756c6c283a526571756573' +
        '7443657274696669636174652c2030292c203a436f64652c203a436572746966' +
        '6963617465732c203a506572696f642c203a50726f64756365722c203a436f75' +
        '6e7472792c203a50726f6475636572436f73742c203a5265676973747279436f' +
        '73742c'
      
        '3a537570706c69657250726963654d61726b75702c203a537570706c69657243' +
        '6f7374576974686f75744e44532c203a537570706c696572436f73742c203a51' +
        '75616e746974792c203a566974616c6c79496d706f7274616e742c203a4e4453' +
        '2c203a53657269616c4e756d6265722c203a416d6f756e742c203a4e6473416d' +
        '6f756e742c203a556e69742c203a4578636973655461782c203a42696c6c4f66' +
        '456e7472794e756d6265722c203a45414e31332920')
  end
  object shPositionDelete: TStrHolder
    Capacity = 4
    Macros = <>
    Left = 304
    Top = 351
    InternalVer = 1
    StrData = (
      ''
      
        '64656c6574652066726f6d20446f63756d656e74426f64696573207768657265' +
        '204964203d203a4f4c445f4964')
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
  object shPositionUpdate: TStrHolder
    Capacity = 12
    Macros = <>
    Left = 368
    Top = 311
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
        '65727469666963617465'
      '7768657265'
      '202064626f646965732e4964203d203a4f4c445f4964')
  end
  object adsOrder: TMyQuery
    Connection = DM.MyConnection
    RefreshOptions = [roAfterInsert, roAfterUpdate]
    KeyFields = 'Id'
    Left = 208
    Top = 307
    object LargeintField1: TLargeintField
      FieldName = 'Id'
    end
    object LargeintField2: TLargeintField
      FieldName = 'DocumentId'
    end
    object StringField1: TStringField
      FieldName = 'Product'
      Size = 255
    end
    object StringField2: TStringField
      FieldName = 'Code'
    end
    object StringField3: TStringField
      FieldName = 'Certificates'
      Size = 50
    end
    object StringField4: TStringField
      FieldName = 'Period'
    end
    object StringField5: TStringField
      FieldName = 'Producer'
      Size = 255
    end
    object StringField6: TStringField
      FieldName = 'Country'
      Size = 150
    end
    object FloatField1: TFloatField
      FieldName = 'ProducerCost'
    end
    object FloatField2: TFloatField
      FieldName = 'RegistryCost'
    end
    object FloatField3: TFloatField
      FieldName = 'SupplierPriceMarkup'
    end
    object FloatField4: TFloatField
      FieldName = 'SupplierCostWithoutNDS'
    end
    object FloatField5: TFloatField
      FieldName = 'SupplierCost'
    end
    object IntegerField1: TIntegerField
      FieldName = 'Quantity'
    end
    object BooleanField1: TBooleanField
      FieldName = 'VitallyImportant'
    end
    object StringField7: TStringField
      FieldName = 'SerialNumber'
      Size = 50
    end
    object BooleanField2: TBooleanField
      FieldName = 'Printed'
      OnChange = adsDocumentBodiesPrintedChange
    end
    object FloatField6: TFloatField
      FieldName = 'Amount'
    end
    object FloatField7: TFloatField
      FieldName = 'NdsAmount'
    end
    object StringField8: TStringField
      FieldName = 'Unit'
      Size = 0
    end
    object FloatField8: TFloatField
      FieldName = 'ExciseTax'
    end
    object StringField9: TStringField
      FieldName = 'BillOfEntryNumber'
    end
    object StringField10: TStringField
      FieldName = 'EAN13'
    end
    object BooleanField3: TBooleanField
      FieldName = 'RequestCertificate'
      OnChange = adsDocumentBodiesPrintedChange
      OnValidate = adsDocumentBodiesRequestCertificateValidate
    end
    object LargeintField3: TLargeintField
      FieldName = 'CertificateId'
      OnGetText = adsDocumentBodiesCertificateIdGetText
    end
    object LargeintField4: TLargeintField
      FieldName = 'DocumentBodyId'
    end
    object LargeintField5: TLargeintField
      FieldName = 'ServerId'
    end
    object LargeintField6: TLargeintField
      FieldName = 'ServerDocumentId'
    end
    object FloatField9: TFloatField
      FieldName = 'CatalogMarkup'
    end
    object FloatField10: TFloatField
      FieldName = 'CatalogMaxMarkup'
    end
    object FloatField11: TFloatField
      FieldName = 'CatalogMaxSupplierMarkup'
    end
  end
  object dsOrder: TDataSource
    DataSet = adsOrder
    Left = 152
    Top = 307
  end
  object shOrder: TStrHolder
    Capacity = 44
    Macros = <>
    Left = 224
    Top = 367
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
