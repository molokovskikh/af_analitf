inherited DocumentHeaderForm: TDocumentHeaderForm
  Left = 317
  Top = 160
  Caption = 'DocumentHeaderForm'
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
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
      OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      SearchPosition = spBottom
      Columns = <
        item
          EditButtons = <>
          Footers = <>
        end>
    end
  end
  object adsDocumentHeaders: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      '*'
      'from'
      '  DocumentHeaders dh'
      'where'
      '    (dh.ClientId = :ClientId)'
      'and (dh.WriteTime BETWEEN :DateFrom AND :DateTo )')
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
  end
end
