inherited DocumentHeaderForm: TDocumentHeaderForm
  Left = 317
  Top = 160
  ActiveControl = dbgHeaders
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
  ClientWidth = 882
  OnDestroy = FormDestroy
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object pTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 882
    Height = 53
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      882
      53)
    object lBefore: TLabel
      Left = 131
      Top = 6
      Width = 60
      Height = 13
      Caption = #1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lInterval: TLabel
      Left = 179
      Top = 29
      Width = 12
      Height = 13
      Caption = #1087#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 129
      Top = 0
      Width = 753
      Height = 53
      Align = alClient
      Shape = bsBottomLine
    end
    object spDelete: TSpeedButton
      Left = 280
      Top = 11
      Width = 97
      Height = 27
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = spDeleteClick
    end
    object spOpenFolders: TSpeedButton
      Left = 774
      Top = 9
      Width = 101
      Height = 27
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1087#1082#1080
      OnClick = spOpenFoldersClick
    end
    object sbListToExcel: TSpeedButton
      Left = 502
      Top = 9
      Width = 97
      Height = 27
      Caption = #1057#1087#1080#1089#1086#1082' '#1074' Excel'
      OnClick = sbListToExcelClick
    end
    object sbSearch: TSpeedButton
      Left = 678
      Top = 9
      Width = 88
      Height = 27
      Anchors = [akTop, akRight]
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072
      OnClick = sbSearchClick
    end
    object sbAdd: TSpeedButton
      Left = 606
      Top = 9
      Width = 97
      Height = 27
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = sbAddClick
    end
    object dtpDateFrom: TDateTimePicker
      Left = 193
      Top = 2
      Width = 81
      Height = 21
      Date = 36526.631636412040000000
      Time = 36526.631636412040000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnCloseUp = dtpDateCloseUp
    end
    object dtpDateTo: TDateTimePicker
      Left = 193
      Top = 26
      Width = 81
      Height = 21
      Date = 0.631934409720997800
      Time = 0.631934409720997800
      TabOrder = 1
      OnCloseUp = dtpDateCloseUp
    end
    object rgColumn: TRadioGroup
      Left = 0
      Top = 0
      Width = 129
      Height = 53
      Align = alLeft
      Caption = ' '#1060#1080#1083#1100#1090#1088#1086#1074#1072#1090#1100' '
      ItemIndex = 0
      Items.Strings = (
        #1087#1086' '#1076#1072#1090#1077' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
        #1087#1086' '#1076#1072#1090#1077' '#1079#1072#1075#1088#1091#1079#1082#1080)
      TabOrder = 2
      OnClick = rgColumnClick
    end
    object gbReject: TGroupBox
      Left = 424
      Top = 0
      Width = 163
      Height = 45
      Caption = ' '#1047#1072#1073#1088#1072#1082#1086#1074#1082#1072' '
      TabOrder = 3
      object cbReject: TComboBox
        Left = 9
        Top = 16
        Width = 149
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = #1042#1089#1077
        OnChange = cbRejectChange
        Items.Strings = (
          #1042#1089#1077
          #1048#1079#1084#1077#1085#1077#1085#1085#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077)
      end
    end
  end
  object pGrid: TPanel [1]
    Left = 0
    Top = 53
    Width = 882
    Height = 396
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgHeaders: TToughDBGrid
      Tag = -1
      Left = 0
      Top = 0
      Width = 882
      Height = 396
      Align = alClient
      AllowedOperations = [alopUpdateEh]
      AllowedSelections = [gstRecordBookmarks, gstRectangle, gstAll]
      AutoFitColWidths = True
      DataSource = dsDocumentHeaders
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = [fsBold]
      FooterRowCount = 1
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
      OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghRowHighlight]
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      SumList.Active = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgHeadersDblClick
      OnGetCellParams = dbgHeadersGetCellParams
      OnKeyDown = dbgHeadersKeyDown
      OnSortMarkingChanged = dbgHeadersSortMarkingChanged
      SearchPosition = spBottom
      Columns = <
        item
          EditButtons = <>
          FieldName = 'DownloadId'
          Footers = <>
          Title.Caption = #8470
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'ProviderDocumentId'
          Footers = <>
          Title.Caption = #8470' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'LocalWriteTime'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          Title.TitleButton = True
          Width = 150
        end
        item
          EditButtons = <>
          FieldName = 'LoadTime'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'DocumentType'
          Footers = <>
          Title.Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          Title.TitleButton = True
          Width = 100
        end
        item
          EditButtons = <>
          FieldName = 'ProviderName'
          Footer.Value = #1048#1090#1086#1075#1086
          Footer.ValueType = fvtStaticText
          Footers = <>
          Title.Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'TotalSumm'
          Footer.FieldName = 'TotalSumm'
          Footer.ValueType = fvtSum
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072' '#1086#1087#1090
        end
        item
          EditButtons = <>
          FieldName = 'TotalRetailSumm'
          Footer.FieldName = 'TotalRetailSumm'
          Footer.ValueType = fvtSum
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072' '#1088#1086#1079#1085#1080#1094#1072
        end>
    end
  end
  object adsDocumentHeaders: TMyQuery
    SQLDelete.Strings = (
      'delete from DocumentBodies where DocumentId = :Old_Id;'
      'delete from DocumentHeaders where Id = :Old_Id;')
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
      'sum(db.Amount) as TotalSumm,'
      'sum(db.RetailAmount) as TotalRetailSumm,'
      'count(db.RejectId) as RejectsCount,'
      'max(db.LastRejectStatusTime) as LastRejectStatusTime,'
      
        'if(c.ClientId is not null, c.Name, '#39#1040#1076#1088#1077#1089' '#1086#1090#1082#1083#1102#1095#1077#1085'/'#1091#1076#1072#1083#1077#1085' '#1080#1079' '#1089#1080#1089 +
        #1090#1077#1084#1099#39') as AddressName'
      'from'
      '  DocumentHeaders dh,'
      '  providers p,'
      '  DocumentBodies db'
      'where'
      '    (dh.ClientId = :ClientId)'
      'and (dh.LoadTime BETWEEN :DateFrom AND :DateTo)'
      'and (p.FirmCode = dh.FirmCode)'
      'and (db.DocumentId = dh.Id)'
      'group by dh.Id')
    Options.StrictUpdate = False
    Left = 64
    Top = 87
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'DateFrom'
      end
      item
        DataType = ftUnknown
        Name = 'DateTo'
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
      Size = 255
    end
    object adsDocumentHeadersLocalWriteTime: TDateTimeField
      FieldName = 'LocalWriteTime'
    end
    object adsDocumentHeadersLoadTime: TDateTimeField
      FieldName = 'LoadTime'
    end
    object adsDocumentHeadersTotalSumm: TFloatField
      FieldName = 'TotalSumm'
    end
    object adsDocumentHeadersTotalRetailSumm: TFloatField
      FieldName = 'TotalRetailSumm'
    end
    object adsDocumentHeadersRetailAmountCalculated: TBooleanField
      FieldName = 'RetailAmountCalculated'
    end
    object adsDocumentHeadersCreatedByUser: TBooleanField
      FieldName = 'CreatedByUser'
    end
    object adsDocumentHeadersLastRejectStatusTime: TDateTimeField
      FieldName = 'LastRejectStatusTime'
    end
    object adsDocumentHeadersRejectsCount: TLargeintField
      FieldName = 'RejectsCount'
    end
    object adsDocumentHeadersAddressName: TStringField
      FieldName = 'AddressName'
      Size = 255
    end
  end
  object dsDocumentHeaders: TDataSource
    DataSet = adsDocumentHeaders
    Left = 128
    Top = 111
  end
  object shDocumentHeaders: TStrHolder
    Capacity = 44
    Macros = <>
    Left = 304
    Top = 135
    InternalVer = 1
    StrData = (
      ''
      '73656c656374'
      '64682e49642c'
      
        '69666e756c6c2864682e446f776e6c6f616449642c2064682e49642920617320' +
        '446f776e6c6f616449642c'
      '64682e577269746554696d652c'
      '64682e4669726d436f64652c'
      '64682e436c69656e7449642c'
      '64682e446f63756d656e74547970652c'
      '64682e50726f7669646572446f63756d656e7449642c'
      '64682e4f7264657249642c'
      '64682e4865616465722c'
      '64682e4c6f616454696d652c'
      '64682e52657461696c416d6f756e7443616c63756c617465642c'
      '64682e577269746554696d65206173204c6f63616c577269746554696d652c'
      '64682e437265617465644279557365722c'
      
        '696628702e4669726d436f6465206973206e756c6c2c2064682e537570706c69' +
        '65724e616d654279557365722c20'
      '2020702e46756c6c4e616d65292061732050726f76696465724e616d652c'
      '73756d2864622e416d6f756e742920617320546f74616c53756d6d2c'
      
        '73756d2864622e52657461696c416d6f756e742920617320546f74616c526574' +
        '61696c53756d6d2c'
      '636f756e742864622e52656a65637449642920'
      '202061732052656a65637473436f756e742c'
      '6d61782864622e4c61737452656a65637453746174757354696d652920617320'
      '20204c61737452656a65637453746174757354696d652c'
      
        '696628632e436c69656e744964206973206e6f74206e756c6c2c20632e4e616d' +
        '652c2027c0e4f0e5f120eef2eaebfef7e5ed2ff3e4e0ebe5ed20e8e720f1e8f1' +
        'f2e5ecfb272920617320416464726573734e616d65'
      '66726f6d'
      '2020446f63756d656e7448656164657273206468'
      
        '20206c656674206a6f696e20636c69656e74732063206f6e20632e436c69656e' +
        '744964203d2064682e436c69656e744964'
      
        '20206c656674206a6f696e2070726f7669646572732070206f6e20702e466972' +
        '6d436f6465203d2064682e4669726d436f646520'
      
        '20206c656674206a6f696e20446f63756d656e74426f64696573206462206f6e' +
        '2064622e446f63756d656e744964203d2064682e4964'
      '7768657265'
      '2020202831203d203129')
  end
  object tmrChangeFilterSuppliers: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmrChangeFilterSuppliersTimer
    Left = 176
    Top = 183
  end
  object tmrProcessWaybils: TTimer
    Enabled = False
    Interval = 750
    OnTimer = tmrProcessWaybilsTimer
    Left = 240
    Top = 183
  end
  object adsRetailProcessed: TMyQuery
    Connection = DM.MyConnection
    Options.StrictUpdate = False
    Left = 80
    Top = 127
  end
end
