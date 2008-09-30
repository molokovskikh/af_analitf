inherited WayBillListForm: TWayBillListForm
  Left = 217
  Top = 186
  ActiveControl = dbgWBL
  Caption = #1053#1072#1082#1083#1072#1076#1085#1099#1077
  ClientHeight = 587
  ClientWidth = 838
  PixelsPerInch = 96
  TextHeight = 13
  object pHeader: TPanel
    Left = 0
    Top = 0
    Width = 838
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 82
      Height = 13
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#8470
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtID: TDBText
      Left = 100
      Top = 8
      Width = 41
      Height = 17
      DataField = 'ServerID'
      DataSource = OrdersHForm.dsWayBillHead
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 144
      Top = 8
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
    object Label3: TLabel
      Left = 342
      Top = 8
      Width = 69
      Height = 13
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 16
      Top = 40
      Width = 52
      Height = 13
      Caption = #1055#1086#1079#1080#1094#1080#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtDate: TDBText
      Left = 162
      Top = 8
      Width = 167
      Height = 17
      DataField = 'WriteTime'
      DataSource = OrdersHForm.dsWayBillHead
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtPriceName: TDBText
      Left = 406
      Top = 8
      Width = 153
      Height = 17
      DataField = 'PriceName'
      DataSource = OrdersHForm.dsWayBillHead
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtRowCount: TDBText
      Left = 72
      Top = 40
      Width = 81
      Height = 17
      DataField = 'RowCount'
      DataSource = OrdersHForm.dsWayBillHead
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object gbComment: TGroupBox
      Left = 560
      Top = 0
      Width = 278
      Height = 65
      Align = alRight
      Caption = ' '#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '
      TabOrder = 0
      object dbmComment: TDBMemo
        Left = 2
        Top = 15
        Width = 274
        Height = 48
        Align = alClient
        BevelInner = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        DataField = 'FirmComment'
        DataSource = OrdersHForm.dsWayBillHead
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object dbgWBL: TToughDBGrid
    Left = 0
    Top = 65
    Width = 838
    Height = 522
    Align = alClient
    AutoFitColWidths = True
    DataSource = dsWBL
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
    OnKeyDown = dbgWBLKeyDown
    OnSortMarkingChanged = dbgWBLSortMarkingChanged
    SearchPosition = spBottom
    ForceRus = True
    Columns = <
      item
        EditButtons = <>
        FieldName = 'ServerID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'ServerWayBillID'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'FullCode'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'CodeFirmCr'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'SynonymCode'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'SynonymFirmCrCode'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'Synonym'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 150
      end
      item
        EditButtons = <>
        FieldName = 'SynonymFirm'
        Footers = <>
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
      end
      item
        EditButtons = <>
        FieldName = 'Code'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'CodeCr'
        Footers = <>
        Visible = False
      end
      item
        EditButtons = <>
        FieldName = 'Quantity'
        Footers = <>
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      end
      item
        EditButtons = <>
        FieldName = 'Cost'
        Footers = <>
        Title.Caption = #1062#1077#1085#1072
      end>
  end
  object dsWBL: TDataSource
    DataSet = adsWBL
    Left = 96
    Top = 208
  end
  object adsWBL: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    SERVERID,'
      '    SERVERWAYBILLID,'
      '    FULLCODE,'
      '    CODEFIRMCR,'
      '    SYNONYMCODE,'
      '    SYNONYMFIRMCRCODE,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    CODE,'
      '    CODECR,'
      '    QUANTITY,'
      '    COST'
      'FROM'
      '    WAYBILLLISTSHOW(:AWAYBILLID) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 96
    Top = 152
  end
end
