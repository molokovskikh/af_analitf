inherited DocumentBodiesForm: TDocumentBodiesForm
  ActiveControl = dbgDocumentBodies
  Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  ClientWidth = 856
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object pOrderHeader: TPanel [0]
    Left = 0
    Top = 76
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
    object dbtPositions: TDBText
      Left = 75
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
  end
  object pGrid: TPanel [1]
    Left = 0
    Top = 127
    Width = 856
    Height = 322
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgDocumentBodies: TDBGridEh
      Left = 0
      Top = 0
      Width = 856
      Height = 322
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
    Height = 76
    Align = alTop
    Caption = ' '#1053#1072#1082#1083#1072#1076#1085#1099#1077' '
    TabOrder = 2
    DesignSize = (
      856
      76)
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
  end
  inherited tCheckVolume: TTimer
    Left = 104
    Top = 152
  end
  object adsDocumentHeaders: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      'dh.*,'
      'dh.WriteTime as LocalWriteTime,'
      'p.FullName as ProviderName,'
      'count(dbodies.Id) as Positions'
      'from'
      '  ('
      '  DocumentHeaders dh,'
      '  providers p'
      '  )'
      '  left join DocumentBodies dbodies on dbodies.DocumentId = dh.Id'
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
    SQLUpdate.Strings = (
      'update'
      '  DocumentBodies dbodies'
      'set'
      '  RetailMarkup     = :RetailMarkup,'
      '  ManualCorrection = :ManualCorrection,'
      '  ManualRetailPrice = :ManualRetailPrice'
      'where'
      '  dbodies.Id = :OLD_Id')
    SQLRefresh.Strings = (
      'select'
      ' *'
      'from'
      '  DocumentBodies dbodies'
      'where'
      '  dbodies.Id = :OLD_Id')
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      ' *'
      'from'
      '  DocumentBodies dbodies'
      'where'
      '  dbodies.DocumentId = :DocumentId'
      'order by dbodies.Product')
    RefreshOptions = [roAfterUpdate]
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
  end
  object tmrVitallyImportantChange: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrVitallyImportantChangeTimer
    Left = 320
    Top = 167
  end
end
