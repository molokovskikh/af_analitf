inherited SummaryForm: TSummaryForm
  Left = 296
  Top = 232
  ActiveControl = dbgSummary
  Caption = #1057#1074#1086#1076#1085#1099#1081' '#1079#1072#1082#1072#1079
  ClientHeight = 465
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 0
    Top = 232
    Width = 684
    Height = 4
    Align = alBottom
    Shape = bsTopLine
  end
  object dbgSummary: TToughDBGrid
    Left = 0
    Top = 0
    Width = 684
    Height = 232
    Align = alClient
    AutoFitColWidths = True
    DataSource = dsSummary
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
    OnGetCellParams = dbgSummaryGetCellParams
    SearchField = 'Synonym'
    InputField = 'Order'
    SearchPosition = spBottom
    ForceRus = True
    OnSortChange = dbgSummarySortChange
    OnCanInput = dbgSummaryCanInput
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Synonym'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 87
      end
      item
        EditButtons = <>
        FieldName = 'SynonymFirm'
        Footers = <>
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Title.TitleButton = True
        Width = 87
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'Volume'
        Footers = <>
        Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
        Title.TitleButton = True
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'Note'
        Footers = <>
        Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 49
      end
      item
        EditButtons = <>
        FieldName = 'Period'
        Footers = <>
        Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
        Title.TitleButton = True
        Width = 56
      end
      item
        EditButtons = <>
        FieldName = 'PriceName'
        Footers = <>
        Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
        Title.TitleButton = True
        Width = 52
      end
      item
        EditButtons = <>
        FieldName = 'RegionName'
        Footers = <>
        Title.Caption = #1056#1077#1075#1080#1086#1085
        Title.TitleButton = True
        Width = 67
      end
      item
        EditButtons = <>
        FieldName = 'BaseCost'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Footers = <>
        Title.Caption = #1062#1077#1085#1072
        Title.TitleButton = True
        Width = 46
      end
      item
        EditButtons = <>
        FieldName = 'PriceRet'
        Footers = <>
        Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
        Title.TitleButton = True
        Width = 47
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'Quantity'
        Footers = <>
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Title.TitleButton = True
        Width = 42
      end
      item
        Color = 16775406
        EditButtons = <>
        FieldName = 'Order'
        Footers = <>
        Title.Caption = #1047#1072#1082#1072#1079
      end
      item
        Color = 16775406
        EditButtons = <>
        FieldName = 'SumOrder'
        Footers = <>
        Title.Caption = #1057#1091#1084#1084#1072
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 436
    Width = 684
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      684
      29)
    object dbtCountOrder: TDBText
      Left = 76
      Top = 7
      Width = 41
      Height = 17
      Anchors = [akLeft, akBottom]
      DataField = 'CountOrder'
      DataSource = dsSummaryH
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 12
      Top = 7
      Width = 56
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1079#1080#1094#1080#1081':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 124
      Top = 7
      Width = 60
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1085#1072' '#1089#1091#1084#1084#1091':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtSumOrder: TDBText
      Left = 188
      Top = 7
      Width = 81
      Height = 17
      Anchors = [akLeft, akBottom]
      DataField = 'SumOrder'
      DataSource = dsSummaryH
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 684
      Height = 29
      Align = alClient
      Shape = bsTopLine
    end
  end
  object WebBrowser1: TWebBrowser
    Tag = 6
    Left = 0
    Top = 236
    Width = 684
    Height = 200
    Align = alBottom
    TabOrder = 2
    ControlData = {
      4C000000B2460000AC1400000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object adsSummary: TADODataSet
    AutoCalcFields = False
    Connection = DM.MainConnection
    CursorLocation = clUseServer
    BeforePost = adsSummaryBeforePost
    AfterPost = adsSummaryAfterPost
    OnCalcFields = adsSummaryCalcFields
    CommandText = 'SELECT * FROM SummaryShow'
    Parameters = <
      item
        Name = 'RetailForcount'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 30
      end
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 1
      end>
    Prepared = True
    Left = 304
    Top = 88
    object adsSummarySynonym: TWideStringField
      FieldName = 'Synonym'
      Size = 255
    end
    object adsSummarySynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsSummaryPriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 25
    end
    object adsSummaryRegionName: TWideStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsSummaryVolume: TWideStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsSummaryNote: TWideStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsSummaryPeriod: TWideStringField
      FieldName = 'Period'
    end
    object adsSummaryJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsSummaryBaseCost: TBCDField
      FieldName = 'BaseCost'
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
    end
    object adsSummaryPriceRet: TFloatField
      FieldName = 'PriceRet'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      currency = True
    end
    object adsSummaryQuantity: TWideStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsSummaryOrder: TIntegerField
      FieldName = 'Order'
      DisplayFormat = '#'
    end
    object adsSummarySumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryAwait: TBooleanField
      FieldName = 'Await'
    end
  end
  object dsSummary: TDataSource
    DataSet = adsSummary
    Left = 304
    Top = 136
  end
  object adsSummaryH: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    CommandText = 'SELECT * FROM SummaryHShow'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 1
      end>
    Prepared = True
    Left = 432
    Top = 88
    object adsSummaryHCountOrder: TIntegerField
      FieldName = 'CountOrder'
    end
    object adsSummaryHSumOrder: TBCDField
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Precision = 19
    end
  end
  object dsSummaryH: TDataSource
    DataSet = adsSummaryH
    Left = 432
    Top = 136
  end
  object frdsSummary: TfrDBDataSet
    DataSource = dsSummary
    OpenDataSource = False
    Left = 304
    Top = 184
  end
end
