inherited DefectivesForm: TDefectivesForm
  Left = 307
  Top = 159
  ActiveControl = dbgDefectives
  Caption = #1047#1072#1073#1088#1072#1082#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1099
  ClientHeight = 573
  ClientWidth = 792
  OldCreateOrder = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel [0]
    Left = 0
    Top = 496
    Width = 792
    Height = 77
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      792
      77)
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 792
      Height = 77
      Align = alClient
      Shape = bsTopLine
    end
    object dbtLetterDate: TDBText
      Left = 283
      Top = 22
      Width = 79
      Height = 13
      AutoSize = True
      DataField = 'LetterDate'
      DataSource = dsDefectives
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtSeries: TDBText
      Left = 108
      Top = 6
      Width = 54
      Height = 13
      AutoSize = True
      DataField = 'Series'
      DataSource = dsDefectives
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtLetterNumber: TDBText
      Left = 108
      Top = 22
      Width = 94
      Height = 13
      DataField = 'LetterNumber'
      DataSource = dsDefectives
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 256
      Top = 22
      Width = 18
      Height = 13
      Caption = #1086#1090' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 22
      Width = 96
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1087#1080#1089#1100#1084#1072' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 58
      Top = 6
      Width = 45
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1057#1077#1088#1080#1103' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbmReason: TDBMemo
      Left = 8
      Top = 40
      Width = 778
      Height = 29
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      DataField = 'REASON'
      DataSource = dsDefectives
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object dbgDefectives: TToughDBGrid [1]
    Tag = 8192
    Left = 0
    Top = 39
    Width = 792
    Height = 457
    Align = alClient
    AutoFitColWidths = True
    DataSource = dsDefectives
    DrawMemoText = True
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnGetCellParams = dbgDefectivesGetCellParams
    OnSortMarkingChanged = dbgDefectivesSortMarkingChanged
    SearchField = 'Name'
    SearchPosition = spBottom
    ForceRus = True
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Name'
        Footers = <>
        Title.Caption = #1058#1086#1074#1072#1088
        Title.TitleButton = True
        Width = 189
      end
      item
        EditButtons = <>
        FieldName = 'Producer'
        Footers = <>
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Title.TitleButton = True
        Width = 86
      end
      item
        EditButtons = <>
        FieldName = 'Series'
        Footers = <>
        Title.Caption = #1057#1077#1088#1080#1103
        Title.TitleButton = True
        Width = 86
      end
      item
        EditButtons = <>
        FieldName = 'LetterNumber'
        Footers = <>
        Title.Caption = #1053#1086#1084#1077#1088' '#1087#1080#1089#1100#1084#1072
        Title.TitleButton = True
        Width = 62
      end
      item
        Alignment = taCenter
        DisplayFormat = 'dd.mm.yyyy hh:nn'
        EditButtons = <>
        FieldName = 'LetterDate'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072' '#1087#1080#1089#1100#1084#1072
        Title.TitleButton = True
        Width = 88
      end
      item
        EditButtons = <>
        FieldName = 'Reason'
        Footers = <>
        Title.Caption = #1055#1088#1080#1095#1080#1085#1072
        Title.TitleButton = True
        Width = 135
      end>
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 792
    Height = 39
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      792
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
    object btnCheck: TButton
      Left = 560
      Top = 7
      Width = 107
      Height = 25
      Action = actCheck
      Anchors = [akTop, akRight]
      Caption = #1055#1086#1084#1077#1090#1080#1090#1100' (F2)'
      TabOrder = 0
    end
    object btnUnCheckAll: TButton
      Left = 680
      Top = 7
      Width = 107
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1057#1085#1103#1090#1100' '#1074#1089#1077' '#1087#1086#1084#1077#1090#1082#1080
      TabOrder = 1
      OnClick = btnUnCheckAllClick
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
      TabOrder = 2
      OnCloseUp = dtpDateCloseUp
    end
    object dtpDateTo: TDateTimePicker
      Left = 234
      Top = 9
      Width = 81
      Height = 21
      Date = 0.631934409720997800
      Time = 0.631934409720997800
      TabOrder = 3
      OnCloseUp = dtpDateCloseUp
    end
  end
  object dsDefectives: TDataSource
    DataSet = adsDefectives
    Left = 160
    Top = 192
  end
  object ActionList: TActionList
    Left = 504
    Top = 112
    object actCheck: TAction
      Caption = 'actCheckForPrint'
      ShortCut = 113
      OnExecute = actCheckExecute
    end
  end
  object adsPrint: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '  Rejects.Id,'
      '  Rejects.Name,'
      '  Rejects.Producer,'
      '  Rejects.Series,'
      '  Rejects.LETTERNUMBER,'
      '  Rejects.LETTERDATE,'
      '  Rejects.REASON,'
      '  Rejects.CHECKPRINT'
      'FROM Rejects'
      'WHERE '
      '  LetterDate BETWEEN :DateFrom And :DateTo '
      'AND (CheckPrint = 1 Or :ShowAll = 1)')
    Left = 288
    Top = 160
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
        Name = 'ShowAll'
      end>
  end
  object adsDefectives: TMyQuery
    SQLUpdate.Strings = (
      'UPDATE Rejects'
      'SET '
      '    CHECKPRINT = :CHECKPRINT'
      'WHERE'
      '    ID = :OLD_ID')
    SQLRefresh.Strings = (
      'SELECT '
      '  Rejects.Id,'
      '  Rejects.Name,'
      '  Rejects.Producer,'
      '  Rejects.Series,'
      '  Rejects.LETTERNUMBER,'
      '  Rejects.LETTERDATE,'
      '  Rejects.REASON,'
      '  Rejects.CHECKPRINT '
      'FROM Rejects'
      'WHERE'
      '(DEFECTIVES.ID = :OLD_ID)')
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '  Rejects.Id,'
      '  Rejects.Name,'
      '  Rejects.Producer,'
      '  Rejects.Series,'
      '  Rejects.LETTERNUMBER,'
      '  Rejects.LETTERDATE,'
      '  Rejects.REASON,'
      '  Rejects.CHECKPRINT'
      'FROM Rejects'
      'WHERE LetterDate BETWEEN :DateFrom And :DateTo')
    RefreshOptions = [roAfterUpdate]
    Left = 160
    Top = 160
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DateFrom'
      end
      item
        DataType = ftUnknown
        Name = 'DateTo'
      end>
  end
end
