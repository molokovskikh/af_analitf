inherited SummaryForm: TSummaryForm
  Left = 264
  Top = 230
  ActiveControl = dbgSummary
  Caption = #1057#1074#1086#1076#1085#1099#1081' '#1079#1072#1082#1072#1079
  ClientHeight = 465
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pClient: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 267
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object dbgSummary: TToughDBGrid
      Left = 0
      Top = 52
      Width = 684
      Height = 182
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
      OnKeyDown = dbgSummaryKeyDown
      OnSortMarkingChanged = dbgSummarySortMarkingChanged
      SearchField = 'SynonymName'
      InputField = 'OrderCount'
      SearchPosition = spBottom
      ForceRus = True
      OnCanInput = dbgSummaryCanInput
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SYNONYMNAME'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 87
        end
        item
          EditButtons = <>
          FieldName = 'SYNONYMFIRM'
          Footers = <>
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Title.TitleButton = True
          Width = 87
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'VOLUME'
          Footers = <>
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Title.TitleButton = True
          Width = 70
        end
        item
          EditButtons = <>
          FieldName = 'NOTE'
          Footers = <>
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 49
        end
        item
          EditButtons = <>
          FieldName = 'DOC'
          Footers = <>
          Title.Caption = #1044#1086#1082#1091#1084#1077#1085#1090
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'PERIOD'
          Footers = <>
          Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
          Title.TitleButton = True
          Width = 56
        end
        item
          EditButtons = <>
          FieldName = 'PRICENAME'
          Footers = <>
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Title.TitleButton = True
          Width = 52
        end
        item
          EditButtons = <>
          FieldName = 'REGIONNAME'
          Footers = <>
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Title.TitleButton = True
          Width = 67
        end
        item
          EditButtons = <>
          FieldName = 'REGISTRYCOST'
          Footers = <>
          Title.Caption = #1056#1077#1077#1089#1090#1088'. '#1094#1077#1085#1072
        end
        item
          EditButtons = <>
          FieldName = 'REQUESTRATIO'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1079#1072#1082#1072#1079
        end
        item
          EditButtons = <>
          FieldName = 'CryptBASECOST'
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
          FieldName = 'QUANTITY'
          Footers = <>
          Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          Title.TitleButton = True
          Width = 42
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'ORDERCOUNT'
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
    object pStatus: TPanel
      Left = 0
      Top = 234
      Width = 684
      Height = 33
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        684
        33)
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 684
        Height = 33
        Align = alClient
        Shape = bsTopLine
      end
      object dbtCountOrder: TDBText
        Left = 412
        Top = 11
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
        Visible = False
      end
      object Label1: TLabel
        Left = 108
        Top = 11
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
        Left = 220
        Top = 11
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
        Left = 460
        Top = 11
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
        Visible = False
      end
      object lSumOrder: TLabel
        Left = 288
        Top = 11
        Width = 59
        Height = 13
        Caption = 'lSumOrder'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lPosCount: TLabel
        Left = 168
        Top = 11
        Width = 58
        Height = 13
        Caption = 'lPosCount'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnDelete: TButton
        Left = 8
        Top = 5
        Width = 75
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 0
        OnClick = btnDeleteClick
      end
    end
    object pTopSettings: TPanel
      Left = 0
      Top = 0
      Width = 684
      Height = 52
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object Label7: TLabel
        Left = 10
        Top = 19
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
        Top = 19
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
      object bvSettings: TBevel
        Left = 0
        Top = 49
        Width = 684
        Height = 3
        Align = alBottom
        Shape = bsBottomLine
      end
      object dtpDateFrom: TDateTimePicker
        Left = 127
        Top = 15
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
        Top = 15
        Width = 81
        Height = 21
        Date = 0.631934409720997800
        Time = 0.631934409720997800
        TabOrder = 1
        OnCloseUp = dtpDateCloseUp
      end
      object rgSummaryType: TRadioGroup
        Left = 328
        Top = 0
        Width = 185
        Height = 48
        Caption = ' '#1048#1089#1090#1086#1095#1085#1080#1082' '
        Items.Strings = (
          #1042#1099#1073#1080#1088#1072#1090#1100' '#1080#1079' '#1090#1077#1082#1091#1097#1080#1093
          #1042#1099#1073#1080#1088#1072#1090#1100' '#1080#1079' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1093)
        TabOrder = 2
        OnClick = rgSummaryTypeClick
      end
      object btnSelectPrices: TBitBtn
        Left = 528
        Top = 13
        Width = 105
        Height = 25
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
        TabOrder = 3
        OnClick = btnSelectPricesClick
        Glyph.Data = {
          A6000000424DA600000000000000760000002800000009000000060000000100
          0400000000003000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333000
          0000333303333000000033300033300000003300000330000000300000003000
          00003333333330000000}
        Layout = blGlyphRight
        Spacing = 10
      end
    end
  end
  object pWebBrowser: TPanel
    Tag = 200
    Left = 0
    Top = 267
    Width = 684
    Height = 198
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object Bevel2: TBevel
      Left = 0
      Top = 0
      Width = 684
      Height = 4
      Align = alTop
      Shape = bsTopLine
    end
    object WebBrowser1: TWebBrowser
      Tag = 6
      Left = 0
      Top = 4
      Width = 684
      Height = 194
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C000000B24600000D1400000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object dsSummary: TDataSource
    DataSet = adsSummary
    Left = 296
    Top = 136
  end
  object dsSummaryH: TDataSource
    DataSet = adsSummaryH
    Left = 432
    Top = 168
  end
  object frdsSummary: TfrDBDataSet
    DataSource = dsSummary
    OpenDataSource = False
    Left = 304
    Top = 184
  end
  object adsSummary: TpFIBDataSet
    UpdateSQL.Strings = (
      'update'
      '  orders'
      'set'
      '  ORDERCOUNT = :ORDERCOUNT'
      'where'
      '   COREID = :ORDERSCOREID'
      'and ORDERID = :ORDERSORDERID')
    DeleteSQL.Strings = (
      'delete from'
      '  orders'
      'where'
      '   COREID = :ORDERSCOREID'
      'and ORDERID = :ORDERSORDERID')
    SelectSQL.Strings = (
      'SELECT'
      '*'
      'FROM'
      '    SUMMARYSHOW(:ACLIENTID, :ADATEFROM, :ADATETO) ')
    AfterPost = adsSummary2AfterPost
    AfterScroll = adsSummary2AfterScroll
    BeforeDelete = adsSummaryBeforeDelete
    BeforeEdit = adsSummaryBeforeEdit
    BeforePost = adsSummary2BeforePost
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    UpdateTransaction = DM.UpTran
    AutoCommit = True
    Left = 296
    Top = 96
    oTrimCharFields = False
    oCacheCalcFields = True
    oRefreshAfterPost = False
    object adsSummaryVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = True
    end
    object adsSummaryQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = True
    end
    object adsSummaryNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = True
    end
    object adsSummaryPERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = True
    end
    object adsSummaryJUNK: TFIBIntegerField
      FieldName = 'JUNK'
    end
    object adsSummaryAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsSummarySYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsSummarySYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsSummaryPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsSummaryREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsSummaryORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
      DisplayFormat = '#'
    end
    object adsSummaryORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsSummaryORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsSummarySumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryCryptBASECOST: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptBASECOST'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSummaryCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSummaryPriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 60
      EmptyStrToNull = True
    end
    object adsSummaryDOC: TFIBStringField
      FieldName = 'DOC'
      EmptyStrToNull = True
    end
    object adsSummaryREGISTRYCOST: TFIBFloatField
      FieldName = 'REGISTRYCOST'
      DisplayFormat = '#'
    end
    object adsSummaryVITALLYIMPORTANT: TFIBIntegerField
      FieldName = 'VITALLYIMPORTANT'
    end
    object adsSummaryREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
      DisplayFormat = '#'
    end
  end
  object adsSummaryH: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    COUNTORDER,'
      '    SUMORDER'
      'FROM'
      '    SUMMARYHSHOW(:ACLIENTID) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 432
    Top = 128
    oCacheCalcFields = True
  end
  object pmSelectedPrices: TPopupMenu
    AutoPopup = False
    Left = 640
    Top = 8
    object miSelectedAll: TMenuItem
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077#1093
      OnClick = miSelectedAllClick
    end
    object miUnselectedAll: TMenuItem
      Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1074#1089#1077#1093
      OnClick = miUnselectedAllClick
    end
    object miSeparator: TMenuItem
      Caption = '-'
    end
  end
end
