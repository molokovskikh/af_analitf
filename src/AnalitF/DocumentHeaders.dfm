inherited DocumentHeaderForm: TDocumentHeaderForm
  Left = 317
  Top = 160
  ActiveControl = dbgHeaders
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 684
    Height = 39
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      684
      39)
    object Label7: TLabel
      Left = 10
      Top = 12
      Width = 107
      Height = 13
      Caption = #1042#1099#1074#1077#1089#1090#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 215
      Top = 12
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
      Left = 0
      Top = 0
      Width = 684
      Height = 39
      Align = alClient
      Shape = bsBottomLine
    end
    object spDelete: TSpeedButton
      Left = 344
      Top = 5
      Width = 97
      Height = 27
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = spDeleteClick
    end
    object spOpenFolders: TSpeedButton
      Left = 576
      Top = 5
      Width = 101
      Height = 27
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1087#1082#1080
      OnClick = spOpenFoldersClick
    end
    object dtpDateFrom: TDateTimePicker
      Left = 127
      Top = 9
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
      Left = 234
      Top = 9
      Width = 81
      Height = 21
      Date = 0.631934409720997800
      Time = 0.631934409720997800
      TabOrder = 1
      OnCloseUp = dtpDateCloseUp
    end
  end
  object pGrid: TPanel [1]
    Left = 0
    Top = 39
    Width = 684
    Height = 410
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgHeaders: TToughDBGrid
      Tag = 1024
      Left = 0
      Top = 0
      Width = 684
      Height = 410
      Align = alClient
      AllowedOperations = [alopUpdateEh]
      AllowedSelections = [gstRecordBookmarks, gstRectangle, gstAll]
      AutoFitColWidths = True
      DataSource = dsDocumentHeaders
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
      OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghRowHighlight]
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgHeadersDblClick
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
          Footers = <>
          Title.Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
          Title.TitleButton = True
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
      'dh.*,'
      'dh.WriteTime  - interval :timezonebias minute as LocalWriteTime,'
      'p.FullName as ProviderName'
      'from'
      '  DocumentHeaders dh,'
      '  providers p'
      'where'
      '    (dh.ClientId = :ClientId)'
      'and (dh.LoadTime BETWEEN :DateFrom AND :DateTo)'
      'and (p.FirmCode = dh.FirmCode)'
      'order by dh.LoadTime DESC')
    Options.StrictUpdate = False
    Left = 64
    Top = 87
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'timezonebias'
      end
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
      Size = 40
    end
    object adsDocumentHeadersLocalWriteTime: TDateTimeField
      FieldName = 'LocalWriteTime'
    end
    object adsDocumentHeadersLoadTime: TDateTimeField
      FieldName = 'LoadTime'
    end
  end
  object dsDocumentHeaders: TDataSource
    DataSet = adsDocumentHeaders
    Left = 128
    Top = 111
  end
end
