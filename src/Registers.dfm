inherited RegistersForm: TRegistersForm
  Left = 303
  Top = 157
  ActiveControl = dbgRegistry
  Caption = #1043#1086#1089#1091#1076#1072#1088#1089#1090#1074#1077#1085#1085#1099#1081' '#1088#1077#1077#1089#1090#1088' '#1094#1077#1085
  ClientHeight = 448
  ClientWidth = 633
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object dbgRegistry: TToughDBGrid
    Left = 0
    Top = 0
    Width = 633
    Height = 384
    Align = alClient
    AutoFitColWidths = True
    DataSource = dsRegistry
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
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    SearchField = 'Name'
    SearchPosition = spTop
    ForceRus = True
    OnSortChange = dbgRegistrySortChange
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Name'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 257
      end
      item
        EditButtons = <>
        FieldName = 'Form'
        Footers = <>
        Title.Caption = #1060#1086#1088#1084#1072' '#1074#1099#1087#1091#1089#1082#1072
        Title.TitleButton = True
        Width = 236
      end
      item
        EditButtons = <>
        FieldName = 'Producer'
        Footers = <>
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Title.TitleButton = True
        Width = 189
      end
      item
        Alignment = taRightJustify
        EditButtons = <>
        FieldName = 'Box'
        Footers = <>
        Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
        Title.TitleButton = True
        Width = 59
      end
      item
        EditButtons = <>
        FieldName = 'Price'
        Footers = <>
        Title.Caption = #1062#1077#1085#1072' '#1074' '#1074#1072#1083'.'
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'Curr'
        Footers = <>
        Title.Caption = #1042#1072#1083#1102#1090#1072
        Title.TitleButton = True
        Width = 48
      end
      item
        EditButtons = <>
        FieldName = 'PriceRub'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Footers = <>
        Title.Caption = #1062#1077#1085#1072' '#1074' '#1088#1091#1073'.'
        Title.TitleButton = True
        Width = 62
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 384
    Width = 633
    Height = 64
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      633
      64)
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 633
      Height = 64
      Align = alClient
      Shape = bsTopLine
    end
    object dbtName: TDBText
      Left = 113
      Top = 9
      Width = 51
      Height = 13
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = True
      DataField = 'Name'
      DataSource = dsRegistry
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtProducer: TDBText
      Left = 113
      Top = 26
      Width = 70
      Height = 13
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = True
      DataField = 'Producer'
      DataSource = dsRegistry
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtBox: TDBText
      Left = 113
      Top = 42
      Width = 40
      Height = 13
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = True
      DataField = 'Box'
      DataSource = dsRegistry
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 42
      Top = 42
      Width = 67
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1059#1087#1072#1082#1086#1074#1082#1072' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 26
      Width = 101
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 12
      Top = 9
      Width = 97
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object dsRegistry: TDataSource
    DataSet = adsRegistry
    Left = 200
    Top = 144
  end
  object adsRegistry: TADODataSet
    Connection = DM.MainConnection
    CommandText = 'SELECT * FROM Registry'
    Parameters = <>
    Left = 200
    Top = 96
    object adsRegistryId: TAutoIncField
      FieldName = 'Id'
      ReadOnly = True
    end
    object adsRegistryName: TWideStringField
      FieldName = 'Name'
      Size = 150
    end
    object adsRegistryForm: TWideStringField
      FieldName = 'Form'
      Size = 250
    end
    object adsRegistryProducer: TWideStringField
      FieldName = 'Producer'
      Size = 150
    end
    object adsRegistryBox: TWideStringField
      FieldName = 'Box'
      Size = 10
    end
    object adsRegistryPrice: TBCDField
      FieldName = 'Price'
      DisplayFormat = '0.00;;'#39#39
      Precision = 19
    end
    object adsRegistryCurrency: TWideStringField
      FieldName = 'Curr'
      Size = 10
    end
    object adsRegistryPriceRub: TBCDField
      FieldName = 'PriceRub'
      DisplayFormat = '0.00;;'#39#39
      Precision = 19
    end
  end
end
