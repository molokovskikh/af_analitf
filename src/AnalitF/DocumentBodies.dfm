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
    object dbtPriceName: TDBText
      Left = 619
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
      Visible = False
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
      DataField = 'Id'
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
    object lblSum: TLabel
      Left = 468
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
      Visible = False
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
    object dbtSumOrder: TDBText
      Left = 842
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
      Left = 539
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
      Visible = False
    end
    object Label5: TLabel
      Left = 566
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
      Visible = False
    end
    object dbtRegionName: TDBText
      Left = 619
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
      Visible = False
    end
    object lSumOrder: TLabel
      Left = 533
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
      Visible = False
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
    object dbgDocumentBodies: TToughDBGrid
      Left = 0
      Top = 0
      Width = 856
      Height = 322
      Align = alClient
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
      SearchField = 'SynonymName'
      InputField = 'OrderCount'
      SearchPosition = spBottom
      ForceRus = True
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
    object spPrintTickets: TSpeedButton
      Left = 328
      Top = 19
      Width = 121
      Height = 25
      Caption = #1055#1077#1095#1072#1090#1100' '#1094#1077#1085#1085#1080#1082#1086#1074
      OnClick = spPrintTicketsClick
    end
    object spPrintReestr: TSpeedButton
      Left = 464
      Top = 19
      Width = 121
      Height = 25
      Caption = #1055#1077#1095#1072#1090#1100' '#1088#1077#1077#1089#1090#1088#1072
      OnClick = spPrintReestrClick
    end
    object spEditMarkups: TSpeedButton
      Left = 600
      Top = 19
      Width = 121
      Height = 25
      Caption = #1053#1072#1094#1077#1085#1082#1080' '#1046#1053#1042#1051#1057
      OnClick = spEditMarkupsClick
    end
    object cbPrintEmptyTickets: TCheckBox
      Left = 8
      Top = 16
      Width = 161
      Height = 17
      Caption = #1055#1077#1095#1072#1090#1100' "'#1087#1091#1089#1090#1099#1093'" '#1094#1077#1085#1085#1080#1082#1086#1074
      TabOrder = 0
      OnClick = cbPrintEmptyTicketsClick
    end
    object cbClearRetailPrice: TCheckBox
      Left = 8
      Top = 35
      Width = 297
      Height = 17
      Caption = #1054#1090#1073#1088#1072#1089#1099#1074#1072#1090#1100' '#1088#1086#1079#1085#1080#1095#1085#1091#1102' '#1094#1077#1085#1091' '#1076#1086' 10 '#1082#1086#1087'. '#1074' "'#1084#1077#1085#1100#1096#1077'"'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = cbClearRetailPriceClick
    end
    object cbWaybillAsVitallyImportant: TCheckBox
      Left = 8
      Top = 54
      Width = 297
      Height = 17
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1085#1072#1082#1083#1072#1076#1085#1091#1102' '#1082#1072#1082' '#1046#1053#1042#1051#1057
      TabOrder = 2
      OnClick = cbWaybillAsVitallyImportantClick
    end
  end
  inherited tCheckVolume: TTimer
    Top = 112
  end
  object adsDocumentHeaders: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      'dh.*,'
      'dh.WriteTime  - interval :timezonebias minute as LocalWriteTime,'
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
    Left = 64
    Top = 87
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'timezonebias'
      end
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
    Left = 128
    Top = 111
  end
  object dsDocumentBodies: TDataSource
    DataSet = adsDocumentBodies
    Left = 152
    Top = 243
  end
  object adsDocumentBodies: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      ' *'
      'from'
      '  DocumentBodies dbodies'
      'where'
      '  dbodies.DocumentId = :DocumentId')
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
    object adsDocumentBodiesPositionName: TStringField
      FieldName = 'PositionName'
      Size = 255
    end
    object adsDocumentBodiesCode: TStringField
      FieldName = 'Code'
    end
    object adsDocumentBodiesSeriesOfCertificates: TStringField
      FieldName = 'SeriesOfCertificates'
      Size = 50
    end
    object adsDocumentBodiesPeriod: TStringField
      FieldName = 'Period'
    end
    object adsDocumentBodiesProducerName: TStringField
      FieldName = 'ProducerName'
      Size = 255
    end
    object adsDocumentBodiesCountry: TStringField
      FieldName = 'Country'
      Size = 150
    end
    object adsDocumentBodiesProducerCost: TFloatField
      FieldName = 'ProducerCost'
    end
    object adsDocumentBodiesGRCost: TFloatField
      FieldName = 'GRCost'
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
    object adsDocumentBodiesQuantity: TLargeintField
      FieldName = 'Quantity'
    end
  end
  object frdsDocumentBodies: TfrDBDataSet
    DataSource = dsDocumentBodies
    OpenDataSource = False
    Left = 120
    Top = 219
  end
end
