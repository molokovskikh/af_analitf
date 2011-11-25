inherited SerialNumberSearchForm: TSerialNumberSearchForm
  Left = 459
  Top = 304
  ActiveControl = dbgSerialNumberSearch
  Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072' '#1074' '#1085#1072#1082#1083#1072#1076#1085#1099#1093
  ClientWidth = 683
  OnDestroy = FormDestroy
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object pTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 683
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      683
      36)
    object spDelete: TSpeedButton
      Left = 580
      Top = 4
      Width = 97
      Height = 27
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1079#1072#1076
      OnClick = spDeleteClick
    end
    object eSearch: TEdit
      Left = 8
      Top = 8
      Width = 185
      Height = 21
      TabOrder = 0
      OnKeyDown = eSearchKeyDown
      OnKeyPress = eSearchKeyPress
    end
  end
  object pGrid: TPanel [1]
    Left = 0
    Top = 36
    Width = 683
    Height = 413
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgSerialNumberSearch: TDBGridEh
      Left = 0
      Top = 0
      Width = 683
      Height = 413
      Align = alClient
      AllowedOperations = [alopUpdateEh]
      DataSource = dsSerialNumberSearch
      Flat = False
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghDialogFind]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnCellClick = dbgSerialNumberSearchCellClick
      OnDrawColumnCell = dbgSerialNumberSearchDrawColumnCell
      OnGetCellParams = dbgSerialNumberSearchGetCellParams
      OnKeyDown = dbgSerialNumberSearchKeyDown
      OnKeyPress = dbgSerialNumberSearchKeyPress
      OnSortMarkingChanged = dbgSerialNumberSearchSortMarkingChanged
    end
  end
  object tmrSearch: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmrSearchTimer
    Left = 176
    Top = 68
  end
  object dsSerialNumberSearch: TDataSource
    DataSet = adsSerialNumberSearch
    Left = 152
    Top = 243
  end
  object adsSerialNumberSearch: TMyQuery
    SQLUpdate.Strings = (
      'update'
      '  DocumentBodies dbodies'
      'set'
      '  RequestCertificate = :RequestCertificate'
      'where'
      '  dbodies.Id = :OLD_Id')
    SQLRefresh.Strings = (
      'select'
      '  dbodies.Id,'
      '  p.ShortName as ProviderName,'
      '  dh.WriteTime as LocalWriteTime, '
      '  dbodies.SerialNumber,'
      '  dbodies.Product,'
      '  dbodies.RequestCertificate,'
      '  dbodies.CertificateId'
      'from '
      '  DocumentBodies dbodies'
      '  inner join DocumentHeaders dh on dh.Id = dbodies.DocumentId '
      '  inner join Providers p on p.FirmCode = dh.FirmCode'
      'where '
      '   dbodies.Id = :OLD_Id')
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      '  dbodies.Id,'
      '  p.ShortName as ProviderName,'
      '  dh.WriteTime as LocalWriteTime, '
      '  dbodies.SerialNumber,'
      '  dbodies.Product,'
      '  dbodies.RequestCertificate,'
      '  dbodies.CertificateId'
      'from '
      '  DocumentBodies dbodies'
      '  inner join DocumentHeaders dh on dh.Id = dbodies.DocumentId '
      '  inner join Providers p on p.FirmCode = dh.FirmCode'
      'where '
      
        '  (ifnull(dh.WriteTime, dh.LoadTime) BETWEEN :DateFrom AND :Date' +
        'To)'
      
        'and (dbodies.Product like :LikeParam or dbodies.SerialNumber lik' +
        'e :LikeParam)'
      'order by dbodies.Product')
    RefreshOptions = [roAfterUpdate]
    Left = 208
    Top = 251
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DateFrom'
      end
      item
        DataType = ftUnknown
        Name = 'DateTo'
      end
      item
        DataType = ftUnknown
        Name = 'LikeParam'
      end
      item
        DataType = ftUnknown
        Name = 'LikeParam'
      end>
    object adsSerialNumberSearchId: TLargeintField
      FieldName = 'Id'
    end
    object adsSerialNumberSearchProduct: TStringField
      FieldName = 'Product'
      Size = 255
    end
    object adsSerialNumberSearchSerialNumber: TStringField
      FieldName = 'SerialNumber'
      Size = 50
    end
    object adsSerialNumberSearchRequestCertificate: TBooleanField
      FieldName = 'RequestCertificate'
      OnChange = adsSerialNumberSearchRequestCertificateChange
      OnValidate = adsSerialNumberSearchRequestCertificateValidate
    end
    object adsSerialNumberSearchCertificateId: TLargeintField
      FieldName = 'CertificateId'
      OnGetText = adsSerialNumberSearchCertificateIdGetText
    end
    object adsSerialNumberSearchLocalWriteTime: TDateTimeField
      FieldName = 'LocalWriteTime'
    end
    object adsSerialNumberSearchProviderName: TStringField
      FieldName = 'ProviderName'
    end
  end
  object tmrPrintedChange: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrPrintedChangeTimer
    Left = 248
    Top = 76
  end
  object tmrShowCertificateWarning: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrShowCertificateWarningTimer
    Left = 304
    Top = 79
  end
end
