object FormsHistoryForm: TFormsHistoryForm
  Left = 281
  Top = 180
  ActiveControl = Grid
  BorderStyle = bsDialog
  Caption = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1079#1072#1082#1072#1079#1099
  ClientHeight = 385
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object dbtName: TDBText
    Left = 8
    Top = 8
    Width = 51
    Height = 13
    AutoSize = True
    DataField = 'Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object dbrForm: TDBText
    Left = 8
    Top = 24
    Width = 46
    Height = 13
    AutoSize = True
    DataField = 'Form'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 126
    Top = 358
    Width = 233
    Height = 13
    Caption = #1057#1088#1077#1076#1085#1103#1103' '#1094#1077#1085#1072' '#1087#1086' '#1087#1086#1089#1083#1077#1076#1085#1080#1084' '#1079#1072#1103#1074#1082#1072#1084' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object dbtPriceAvg: TDBText
    Left = 523
    Top = 358
    Width = 70
    Height = 13
    AutoSize = True
    DataField = 'PriceAvg'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object lPriceAvg: TLabel
    Left = 363
    Top = 358
    Width = 55
    Height = 13
    Caption = 'lPriceAvg'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Grid: TToughDBGrid
    Left = 8
    Top = 48
    Width = 713
    Height = 297
    AutoFitColWidths = True
    DataSource = dsOrders
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    SearchPosition = spBottom
    Columns = <
      item
        EditButtons = <>
        FieldName = 'SYNONYMFIRM'
        Footers = <>
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Width = 149
      end
      item
        EditButtons = <>
        FieldName = 'PRICENAME'
        Footers = <>
        Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
        Width = 109
      end
      item
        EditButtons = <>
        FieldName = 'REGIONNAME'
        Footers = <>
        Title.Caption = #1056#1077#1075#1080#1086#1085
        Width = 94
      end
      item
        DisplayFormat = 'dd.mm.yyyy hh:nn'
        EditButtons = <>
        FieldName = 'ORDERDATE'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072
        Width = 85
      end
      item
        EditButtons = <>
        FieldName = 'ORDERCOUNT'
        Footers = <>
        Title.Caption = #1047#1072#1082#1072#1079
        Width = 57
      end
      item
        EditButtons = <>
        FieldName = 'SENDPRICE'
        Footers = <>
        Title.Caption = #1062#1077#1085#1072
        Width = 82
      end>
  end
  object btnClose: TButton
    Left = 8
    Top = 352
    Width = 97
    Height = 27
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object dsOrders: TDataSource
    DataSet = adsOrders
    Left = 112
    Top = 200
  end
  object adsOrders: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    FULLCODE,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    ORDERCOUNT,'
      '    CODE,'
      '    CODECR,'
      '    PRICE,'
      '    ORDERDATE,'
      '    PRICENAME,'
      '    REGIONNAME,'
      '    AWAIT,'
      '    JUNK,'
      '    sendprice'
      'FROM'
      '    ORDERSSHOWBYFORM(:AFULLCODE,'
      '    :ACLIENTID) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 112
    Top = 152
    oTrimCharFields = False
    oCacheCalcFields = True
    object adsOrdersFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsOrdersSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsOrdersORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsOrdersCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsOrdersCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsOrdersORDERDATE: TFIBDateTimeField
      FieldName = 'ORDERDATE'
    end
    object adsOrdersPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsOrdersREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsOrdersAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsOrdersJUNK: TFIBIntegerField
      FieldName = 'JUNK'
    end
    object adsOrdersPRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsOrdersSENDPRICE: TFIBBCDField
      FieldName = 'SENDPRICE'
      Size = 2
      RoundByScale = True
    end
  end
end