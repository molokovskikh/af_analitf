inherited OrdersForm: TOrdersForm
  Left = 276
  Top = 204
  ActiveControl = dbgOrders
  Caption = #1040#1088#1093#1080#1074#1085#1099#1081' '#1079#1072#1082#1072#1079
  ClientHeight = 443
  ClientWidth = 793
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 793
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object dbtPriceName: TDBText
      Left = 355
      Top = 9
      Width = 272
      Height = 13
      DataField = 'PriceName'
      DataSource = OrdersHForm.dsOrdersH
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
      Width = 53
      Height = 13
      Caption = #1047#1072#1082#1072#1079' '#8470
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtId: TDBText
      Left = 76
      Top = 9
      Width = 41
      Height = 13
      DataField = 'OrderId'
      DataSource = OrdersHForm.dsOrdersH
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 124
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
      Left = 141
      Top = 9
      Width = 124
      Height = 13
      DataField = 'OrderDate'
      DataSource = OrdersHForm.dsOrdersH
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
      Left = 124
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
    end
    object dbtPositions: TDBText
      Left = 75
      Top = 29
      Width = 41
      Height = 13
      DataField = 'Positions'
      DataSource = OrdersHForm.dsOrdersH
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtSumOrder: TDBText
      Left = 192
      Top = 29
      Width = 81
      Height = 13
      DataField = 'SumOrder'
      DataSource = OrdersHForm.dsOrdersH
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 275
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
    end
    object Label5: TLabel
      Left = 275
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
    end
    object dbtRegionName: TDBText
      Left = 328
      Top = 29
      Width = 283
      Height = 13
      DataField = 'RegionName'
      DataSource = OrdersHForm.dsOrdersH
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object dbgOrders: TToughDBGrid
    Left = 0
    Top = 51
    Width = 793
    Height = 392
    Align = alClient
    AutoFitColWidths = True
    DataSource = dsOrders
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
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnGetCellParams = dbgOrdersGetCellParams
    OnKeyDown = dbgOrdersKeyDown
    SearchField = 'Orders.Synonym'
    SearchPosition = spBottom
    ForceRus = True
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Synonym'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 97
      end
      item
        EditButtons = <>
        FieldName = 'SynonymFirm'
        Footers = <>
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Title.TitleButton = True
        Width = 156
      end
      item
        EditButtons = <>
        FieldName = 'Price'
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
        FieldName = 'Order'
        Footers = <>
        Title.Caption = #1047#1072#1082#1072#1079
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'SumOrder'
        Footers = <>
        Title.Caption = #1057#1091#1084#1084#1072
        Title.TitleButton = True
      end>
  end
  object adsOrders: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    CommandText = 'SELECT * FROM OrdersShow'
    Parameters = <
      item
        Name = 'AOrderId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 40
      end>
    Left = 144
    Top = 144
    object adsOrdersOrderId: TIntegerField
      FieldName = 'OrderId'
    end
    object adsOrdersFullCode: TIntegerField
      FieldName = 'FullCode'
    end
    object adsOrdersCode: TWideStringField
      FieldName = 'Code'
    end
    object adsOrdersCodeCr: TWideStringField
      FieldName = 'CodeCr'
    end
    object adsOrdersSynonymCode: TIntegerField
      FieldName = 'SynonymCode'
    end
    object adsOrdersSynonym: TWideStringField
      FieldName = 'Synonym'
      Size = 255
    end
    object adsOrdersSynonymFirmCrCode: TIntegerField
      FieldName = 'SynonymFirmCrCode'
    end
    object adsOrdersSynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsOrdersPrice: TBCDField
      FieldName = 'Price'
      DisplayFormat = '0.00;;'#39#39
      Precision = 19
    end
    object adsOrdersJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsOrdersOrder: TIntegerField
      FieldName = 'Order'
      DisplayFormat = '#'
    end
    object adsOrdersSumOrder: TBCDField
      FieldName = 'SumOrder'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      Precision = 19
    end
    object adsOrdersAwait: TBooleanField
      FieldName = 'Await'
    end
  end
  object dsOrders: TDataSource
    DataSet = adsOrders
    Left = 144
    Top = 192
  end
  object frdsOrders: TfrDBDataSet
    DataSource = dsOrders
    Left = 144
    Top = 240
  end
end
