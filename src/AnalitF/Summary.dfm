inherited SummaryForm: TSummaryForm
  Left = 350
  Top = 172
  ActiveControl = dbgSummaryCurrent
  Caption = #1057#1074#1086#1076#1085#1099#1081' '#1079#1072#1082#1072#1079
  ClientHeight = 573
  ClientWidth = 792
  OldCreateOrder = True
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object plOverCost: TPanel [0]
    Left = 104
    Top = 232
    Width = 545
    Height = 97
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Visible = False
    DesignSize = (
      545
      97)
    object lWarning: TLabel
      Left = 1
      Top = 8
      Width = 543
      Height = 81
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1089#1088#1077#1076#1085#1077#1081' '#1094#1077#1085#1099'!'#13#10#1042#1099' '#1079#1072#1082#1072#1079#1072#1083#1080' '#1085#1077#1082#1086#1085#1076#1080#1094#1080#1086#1085#1085#1099#1081' '#1087#1088#1077#1087#1072#1088#1072#1090'.'#13#10 +
        #1042#1085#1080#1084#1072#1085#1080#1077'! '#1042#1099' '#1079#1072#1082#1072#1079#1072#1083#1080' '#1073#1086#1083#1100#1096#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1088#1077#1087#1072#1088#1072#1090#1072'.'
    end
  end
  object pClient: TPanel [1]
    Left = 0
    Top = 0
    Width = 792
    Height = 375
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object dbgSummaryCurrent: TToughDBGrid
      Left = 0
      Top = 52
      Width = 792
      Height = 210
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
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
      OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgSummaryCurrentDblClick
      OnGetCellParams = dbgSummaryCurrentGetCellParams
      OnKeyDown = dbgSummaryCurrentKeyDown
      OnSortMarkingChanged = dbgSummaryCurrentSortMarkingChanged
      SearchField = 'SynonymName'
      InputField = 'OrderCount'
      SearchPosition = spBottom
      ForceRus = True
      OnCanInput = dbgSummaryCurrentCanInput
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SynonymName'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 225
        end
        item
          EditButtons = <>
          FieldName = 'SynonymFirm'
          Footers = <>
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Title.TitleButton = True
          Width = 140
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Volume'
          Footers = <>
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'Note'
          Footers = <>
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Title.TitleButton = True
          Visible = False
          Width = 45
        end
        item
          EditButtons = <>
          FieldName = 'doc'
          Footers = <>
          Title.Caption = #1044#1086#1082#1091#1084#1077#1085#1090
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'Period'
          Footers = <>
          Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
          Title.TitleButton = True
          Width = 61
        end
        item
          EditButtons = <>
          FieldName = 'PriceName'
          Footers = <>
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Title.TitleButton = True
          Width = 82
        end
        item
          EditButtons = <>
          FieldName = 'RegionName'
          Footers = <>
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Title.TitleButton = True
          Visible = False
          Width = 62
        end
        item
          EditButtons = <>
          FieldName = 'registrycost'
          Footers = <>
          Title.Caption = #1056#1077#1077#1089#1090#1088'. '#1094#1077#1085#1072
          Title.TitleButton = True
          Visible = False
          Width = 58
        end
        item
          EditButtons = <>
          FieldName = 'RequestRatio'
          Footers = <>
          Title.Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
          Title.TitleButton = True
          Visible = False
          Width = 59
        end
        item
          EditButtons = <>
          FieldName = 'ordercost'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'MINORDERCOUNT'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'RealCost'
          Footers = <>
          Title.Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1086#1090#1089#1088#1086#1095#1082#1080
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'Cost'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Footers = <>
          Title.Caption = #1062#1077#1085#1072
          Title.TitleButton = True
          Width = 67
        end
        item
          EditButtons = <>
          FieldName = 'PriceRet'
          Footers = <>
          Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
          Title.TitleButton = True
          Width = 62
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Quantity'
          Footers = <>
          Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          Title.TitleButton = True
          Width = 43
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'OrderCount'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079
          Title.TitleButton = True
          Width = 44
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072
          Title.TitleButton = True
          Width = 58
        end>
    end
    object pStatus: TPanel
      Left = 0
      Top = 342
      Width = 792
      Height = 33
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        792
        33)
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 792
        Height = 33
        Align = alClient
        Shape = bsTopLine
      end
      object Label1: TLabel
        Left = 387
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
        Left = 499
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
      object lSumOrder: TLabel
        Left = 567
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
        Left = 447
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
      object btnGotoCore: TSpeedButton
        Left = 91
        Top = 5
        Width = 94
        Height = 25
        Action = actFlipCore
      end
      object btnGotoMNN: TSpeedButton
        Left = 193
        Top = 5
        Width = 177
        Height = 25
        Caption = 'GotoMNN'
        Visible = False
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
      Width = 792
      Height = 52
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object bvSettings: TBevel
        Left = 0
        Top = 49
        Width = 792
        Height = 3
        Align = alBottom
        Shape = bsBottomLine
      end
      object rgSummaryType: TRadioGroup
        Left = 0
        Top = 0
        Width = 433
        Height = 48
        Caption = ' '#1048#1089#1090#1086#1095#1085#1080#1082' '
        Items.Strings = (
          #1042#1099#1073#1080#1088#1072#1090#1100' '#1080#1079' '#1090#1077#1082#1091#1097#1080#1093
          
            #1042#1099#1073#1080#1088#1072#1090#1100' '#1080#1079' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1093' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089'                            ' +
            '    '#1087#1086)
        TabOrder = 0
        OnClick = rgSummaryTypeClick
      end
      object btnSelectPrices: TBitBtn
        Left = 456
        Top = 13
        Width = 105
        Height = 25
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
        TabOrder = 1
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
      object dtpDateFrom: TDateTimePicker
        Left = 234
        Top = 23
        Width = 81
        Height = 21
        Date = 36526.631636412040000000
        Time = 36526.631636412040000000
        Enabled = False
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
        Left = 346
        Top = 23
        Width = 81
        Height = 21
        Date = 0.631934409720997800
        Time = 0.631934409720997800
        Enabled = False
        TabOrder = 3
        OnCloseUp = dtpDateCloseUp
      end
      object cbNeedCorrect: TCheckBox
        Left = 584
        Top = 16
        Width = 201
        Height = 17
        Caption = #1058#1086#1083#1100#1082#1086' '#1087#1086#1079#1080#1094#1080#1080' '#1089' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1086#1081
        TabOrder = 4
        OnClick = cbNeedCorrectClick
      end
    end
    object dbgSummarySend: TToughDBGrid
      Left = 0
      Top = 52
      Width = 792
      Height = 210
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
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgSummaryCurrentDblClick
      OnGetCellParams = dbgSummaryCurrentGetCellParams
      OnKeyDown = dbgSummaryCurrentKeyDown
      OnSortMarkingChanged = dbgSummaryCurrentSortMarkingChanged
      SearchField = 'SynonymName'
      SearchPosition = spBottom
      ForceRus = True
      OnCanInput = dbgSummaryCurrentCanInput
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SynonymName'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 225
        end
        item
          EditButtons = <>
          FieldName = 'SynonymFirm'
          Footers = <>
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Title.TitleButton = True
          Width = 140
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Volume'
          Footers = <>
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'Note'
          Footers = <>
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Title.TitleButton = True
          Visible = False
          Width = 45
        end
        item
          EditButtons = <>
          FieldName = 'doc'
          Footers = <>
          Title.Caption = #1044#1086#1082#1091#1084#1077#1085#1090
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'Period'
          Footers = <>
          Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
          Title.TitleButton = True
          Width = 61
        end
        item
          EditButtons = <>
          FieldName = 'PriceName'
          Footers = <>
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Title.TitleButton = True
          Width = 82
        end
        item
          EditButtons = <>
          FieldName = 'RegionName'
          Footers = <>
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Title.TitleButton = True
          Visible = False
          Width = 62
        end
        item
          EditButtons = <>
          FieldName = 'registrycost'
          Footers = <>
          Title.Caption = #1056#1077#1077#1089#1090#1088'. '#1094#1077#1085#1072
          Title.TitleButton = True
          Visible = False
          Width = 58
        end
        item
          EditButtons = <>
          FieldName = 'RequestRatio'
          Footers = <>
          Title.Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
          Title.TitleButton = True
          Visible = False
          Width = 59
        end
        item
          EditButtons = <>
          FieldName = 'ordercost'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'MINORDERCOUNT'
          Footers = <>
          Title.Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'RealCost'
          Footers = <>
          Title.Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1086#1090#1089#1088#1086#1095#1082#1080
          Title.TitleButton = True
          Visible = False
        end
        item
          EditButtons = <>
          FieldName = 'Cost'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Footers = <>
          Title.Caption = #1062#1077#1085#1072
          Title.TitleButton = True
          Width = 67
        end
        item
          EditButtons = <>
          FieldName = 'PriceRet'
          Footers = <>
          Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
          Title.TitleButton = True
          Width = 62
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Quantity'
          Footers = <>
          Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          Title.TitleButton = True
          Width = 43
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'OrderCount'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079
          Title.TitleButton = True
          Width = 44
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072
          Title.TitleButton = True
          Width = 58
        end
        item
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'SendDate'
          Footers = <>
          Title.Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086
        end>
    end
    object gbCorrectMessage: TGroupBox
      Left = 0
      Top = 302
      Width = 792
      Height = 40
      Align = alBottom
      Caption = ' '#1055#1088#1080#1095#1080#1085#1072' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' '
      TabOrder = 4
      object mCorrectMessage: TMemo
        Left = 2
        Top = 15
        Width = 788
        Height = 23
        Align = alClient
        Lines.Strings = (
          'mCorrectMessage')
        ReadOnly = True
        TabOrder = 0
      end
    end
    object gbComment: TGroupBox
      Left = 0
      Top = 262
      Width = 792
      Height = 40
      Align = alBottom
      Caption = ' '#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '
      TabOrder = 5
      object dbmComment: TDBMemo
        Left = 2
        Top = 15
        Width = 788
        Height = 23
        Align = alClient
        DataField = 'Comment'
        DataSource = dsSummary
        TabOrder = 0
      end
    end
  end
  object pWebBrowser: TPanel [2]
    Tag = 200
    Left = 0
    Top = 375
    Width = 792
    Height = 198
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object Bevel2: TBevel
      Left = 0
      Top = 0
      Width = 792
      Height = 4
      Align = alTop
      Shape = bsTopLine
    end
    object WebBrowser1: TWebBrowser
      Tag = 6
      Left = 0
      Top = 4
      Width = 792
      Height = 194
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C000000DB5100000D1400000000000000000000000000000000000000000000
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
  object pmSelectedPrices: TPopupMenu
    AutoPopup = False
    Left = 560
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
  object ActionList: TActionList
    Left = 352
    Top = 192
    object actFlipCore: TAction
      Caption = #1042' '#1082#1072#1090#1072#1083#1086#1075' (F2)'
      ShortCut = 113
      OnExecute = actFlipCoreExecute
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 640
    Top = 216
  end
  object adsCurrentSummary: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    CurrentOrderLists.RetailVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    Core.CoreID,'
      '    Core.Volume,'
      '    Core.Quantity,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Junk,'
      '    Core.Await,'
      '    Core.CODE,'
      '    Core.CODECR,'
      '    core.doc,'
      '    core.registrycost,'
      '    core.vitallyimportant as vitallyimportant,'
      '    core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    core.ProducerCost,'
      '    core.NDS,'
      '    core.SupplierPriceMarkup,'
      '    CurrentOrderLists.RealPrice as RealCost,'
      '    CurrentOrderLists.Price as Cost,'
      
        '    coalesce(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', ca' +
        'talogs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    CurrentOrderLists.OrderCount,'
      '    CurrentOrderLists.CoreId AS OrdersCoreId,'
      '    CurrentOrderLists.OrderId AS OrdersOrderId,'
      '    pricesdata.pricecode,'
      '    Regions.regioncode,'
      '    CurrentOrderHeads.OrderId as OrdersHOrderId,'
      '    CurrentOrderHeads.SendDate,'
      '    CurrentOrderLists.DropReason,'
      '    CurrentOrderLists.ServerCost,'
      '    CurrentOrderLists.ServerQuantity,'
      '    CurrentOrderLists.RetailMarkup,'
      '    CurrentOrderLists.RetailCost,'
      '    CurrentOrderLists.Comment,'
      '    CurrentOrderHeads.SendResult,'
      '    Mnn.Id as MnnId,'
      '    Mnn.Mnn,'
      '    GroupMaxProducerCosts.MaxProducerCost,'
      '    Producers.Name as ProducerName,'
      '    c.Name as AddressName'
      'FROM'
      '    ('
      '    PricesData,'
      '    Regions,'
      '    Core,'
      '    CurrentOrderHeads,'
      '    products,'
      '    catalogs,'
      '    CurrentOrderLists,'
      '    clients c'
      '    ) '
      '    left join Producers on Producers.Id = Core.CodeFirmCr'
      '    left join Mnn on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = Core.productid) '
      '      and (Core.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      
        '    left join Synonyms on CurrentOrderLists.SynonymCode=Synonyms' +
        '.SynonymCode'
      
        '    LEFT JOIN SynonymFirmCr ON CurrentOrderLists.SynonymFirmCrCo' +
        'de=SynonymFirmCr.SynonymFirmCrCode'
      'WHERE'
      '    CurrentOrderHeads.Frozen = 0 '
      'and c.ClientId = CurrentOrderHeads.ClientId'
      'and CurrentOrderLists.OrderId=CurrentOrderHeads.OrderId'
      'and CurrentOrderLists.OrderCount>0'
      'and Core.CoreId=CurrentOrderLists.CoreId'
      'and products.productid = CurrentOrderLists.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = CurrentOrderHeads.PriceCode'
      'and Regions.RegionCode = CurrentOrderHeads.RegionCode')
    Left = 104
    Top = 152
  end
  object adsSendSummary: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    PostedOrderLists.RetailVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    PostedOrderLists.CoreId AS CoreId,'
      '    PostedOrderLists.Volume,'
      '    PostedOrderLists.CoreQuantity as Quantity,'
      '    PostedOrderLists.Note,'
      '    PostedOrderLists.Period,'
      '    PostedOrderLists.Junk,'
      '    PostedOrderLists.Await,'
      '    PostedOrderLists.CODE,'
      '    PostedOrderLists.CODECR,'
      '    PostedOrderLists.Doc,'
      '    PostedOrderLists.Registrycost,'
      '    PostedOrderLists.VitallyImportant,'
      '    PostedOrderLists.requestratio,'
      '    PostedOrderLists.ordercost,'
      '    PostedOrderLists.minordercount,'
      '    PostedOrderLists.ProducerCost,'
      '    PostedOrderLists.NDS,'
      '    PostedOrderLists.SupplierPriceMarkup, '
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PostedOrderLists.RealPrice as RealCost,'
      '    PostedOrderLists.Price as Cost,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    PostedOrderLists.OrderCount,'
      '    PostedOrderLists.CoreId AS OrdersCoreId,'
      '    PostedOrderLists.OrderId AS OrdersOrderId,'
      '    PricesData.pricecode,'
      '    Regions.regioncode,'
      '    PostedOrderHeads.OrderId as OrdersHOrderId,'
      '    PostedOrderHeads.SendDate,'
      '    PostedOrderLists.DropReason,'
      '    PostedOrderLists.ServerCost,'
      '    PostedOrderLists.ServerQuantity,'
      '    PostedOrderLists.RetailMarkup,'
      '    PostedOrderLists.RetailCost,'
      '    PostedOrderLists.Comment,'
      '    PostedOrderHeads.SendResult,'
      '    Mnn.Id as MnnId,'
      '    Mnn.Mnn,'
      '    GroupMaxProducerCosts.MaxProducerCost,'
      '    Producers.Name as ProducerName,'
      '    c.Name As AddressName'
      'FROM'
      '   ('
      '    PricesData,'
      '    Regions,'
      '    PostedOrderHeads,'
      '    products,'
      '    catalogs,'
      '    PostedOrderLists,'
      '    clients c'
      '   )'
      
        '    left join Producers on Producers.Id = PostedOrderLists.CodeF' +
        'irmCr'
      '    left join Mnn on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      
        '      (GroupMaxProducerCosts.ProductId = PostedOrderLists.produc' +
        'tid) '
      
        '      and (PostedOrderLists.CodeFirmCr = GroupMaxProducerCosts.P' +
        'roducerId)'
      
        '    left join Synonyms on PostedOrderLists.SynonymCode=Synonyms.' +
        'SynonymCode'
      
        '    LEFT JOIN SynonymFirmCr ON PostedOrderLists.SynonymFirmCrCod' +
        'e=SynonymFirmCr.SynonymFirmCrCode'
      'WHERE'
      '    PostedOrderLists.OrderId=PostedOrderHeads.OrderId'
      'and PostedOrderLists.OrderCount>0'
      'and PostedOrderLists.CoreId is null'
      'and c.ClientId = PostedOrderHeads.ClientId'
      'and products.productid = PostedOrderLists.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = PostedOrderHeads.PriceCode'
      'and Regions.RegionCode = PostedOrderHeads.RegionCode'
      'and PostedOrderHeads.senddate >= :datefrom'
      'and PostedOrderHeads.senddate <= :dateTo')
    Left = 152
    Top = 152
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'datefrom'
      end
      item
        DataType = ftUnknown
        Name = 'dateTo'
      end>
  end
  object adsSummary: TMyQuery
    SQLDelete.Strings = (
      'DELETE FROM CurrentOrderLists'
      'where'
      '    OrderId = :OLD_ORDERSORDERID'
      'and CoreId  = :OLD_COREID')
    SQLUpdate.Strings = (
      'update'
      '  CurrentOrderLists'
      'set'
      '  OrderCount = :ORDERCOUNT,'
      '  DropReason = if(:ORDERCOUNT = 0, null, DropReason),'
      '  ServerCost = if(:ORDERCOUNT = 0, null, ServerCost),'
      '  ServerQuantity = if(:ORDERCOUNT = 0, null, ServerQuantity),'
      '  Comment = :Comment'
      'where'
      '    OrderId = :ORDERSORDERID'
      'and CoreId  = :OLD_COREID')
    SQLRefresh.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    CurrentOrderLists.RetailVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    Core.CoreID,'
      '    Core.Volume,'
      '    Core.Quantity,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Junk,'
      '    Core.Await,'
      '    Core.CODE,'
      '    Core.CODECR,'
      '    core.doc,'
      '    core.registrycost,'
      '    core.vitallyimportant as vitallyimportant,'
      '    core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    core.ProducerCost,'
      '    core.NDS,'
      '    core.SupplierPriceMarkup,'
      '    CurrentOrderLists.RealPrice as RealCost,'
      '    CurrentOrderLists.Price as Cost,'
      
        '    coalesce(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', ca' +
        'talogs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    CurrentOrderLists.OrderCount,'
      '    CurrentOrderLists.CoreId AS OrdersCoreId,'
      '    CurrentOrderLists.OrderId AS OrdersOrderId,'
      '    pricesdata.pricecode,'
      '    Regions.regioncode,'
      '    CurrentOrderHeads.OrderId as OrdersHOrderId,'
      '    CurrentOrderHeads.SendDate,'
      '    CurrentOrderLists.DropReason,'
      '    CurrentOrderLists.ServerCost,'
      '    CurrentOrderLists.ServerQuantity,'
      '    CurrentOrderLists.RetailMarkup,'
      '    CurrentOrderLists.RetailCost,'
      '    CurrentOrderLists.Comment,'
      '    CurrentOrderHeads.SendResult,'
      '    Mnn.Id as MnnId,'
      '    Mnn.Mnn,'
      '    GroupMaxProducerCosts.MaxProducerCost,'
      '    Producers.Name as ProducerName'
      'FROM'
      '   ('
      '    PricesData,'
      '    Regions,'
      '    Core,'
      '    CurrentOrderHeads,'
      '    products,'
      '    catalogs,'
      '    CurrentOrderLists'
      '   )'
      '    left join Producers on Producers.Id = Core.CodeFirmCr'
      '    left join Mnn on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = Core.productid) '
      '      and (Core.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      
        '    left join Synonyms on CurrentOrderLists.SynonymCode=Synonyms' +
        '.SynonymCode'
      
        '    LEFT JOIN SynonymFirmCr ON CurrentOrderLists.SynonymFirmCrCo' +
        'de=SynonymFirmCr.SynonymFirmCrCode'
      'WHERE'
      '    CurrentOrderHeads.OrderId = :OrdersOrderId'
      'and CurrentOrderHeads.Frozen = 0 '
      'and CurrentOrderLists.OrderId=CurrentOrderHeads.OrderId'
      'and CurrentOrderLists.OrderCount>0'
      'and Core.CoreId=CurrentOrderLists.CoreId'
      'and products.productid = CurrentOrderLists.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = CurrentOrderHeads.PriceCode'
      'and Regions.RegionCode = CurrentOrderHeads.RegionCode'
      'and Core.CoreId = :CoreId')
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    catalogs.DescriptionId,'
      '    catalogs.VitallyImportant as CatalogVitallyImportant,'
      '    CurrentOrderLists.RetailVitallyImportant,'
      '    catalogs.MandatoryList as CatalogMandatoryList,'
      '    Core.CoreID,'
      '    Core.Volume,'
      '    Core.Quantity,'
      '    Core.Note,'
      '    Core.Period,'
      '    Core.Junk,'
      '    Core.Await,'
      '    Core.CODE,'
      '    Core.CODECR,'
      '    core.doc,'
      '    core.registrycost,'
      '    core.vitallyimportant,'
      '    core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    core.ProducerCost,'
      '    core.NDS,'
      '    core.SupplierPriceMarkup,'
      '    CurrentOrderLists.RealPrice as RealCost,'
      '    CurrentOrderLists.Price as Cost,'
      
        '    coalesce(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', ca' +
        'talogs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceName,'
      '    Regions.RegionName,'
      '    CurrentOrderLists.OrderCount,'
      '    CurrentOrderLists.CoreId AS OrdersCoreId,'
      '    CurrentOrderLists.OrderId AS OrdersOrderId,'
      '    pricesdata.pricecode,'
      '    Regions.regioncode,'
      '    CurrentOrderHeads.OrderId as OrdersHOrderId,'
      '    CurrentOrderHeads.SendDate,'
      '    CurrentOrderLists.DropReason,'
      '    CurrentOrderLists.ServerCost,'
      '    CurrentOrderLists.ServerQuantity,'
      '    CurrentOrderLists.RetailMarkup,'
      '    CurrentOrderLists.RetailCost,'
      '    CurrentOrderLists.Comment,'
      '    CurrentOrderHeads.SendResult,'
      '    Mnn.Id as MnnId,'
      '    Mnn.Mnn,'
      '    GroupMaxProducerCosts.MaxProducerCost,'
      '    Producers.Name as ProducerName,'
      '    c.Name As AddressName'
      'FROM'
      '   ('
      '    PricesData,'
      '    Regions,'
      '    Core,'
      '    CurrentOrderHeads,'
      '    products,'
      '    catalogs,'
      '    CurrentOrderLists,'
      '    clients c'
      '   )'
      '    left join Producers on Producers.Id = Core.CodeFirmCr'
      '    left join Mnn on mnn.Id = Catalogs.MnnId'
      '    left join GroupMaxProducerCosts on '
      '      (GroupMaxProducerCosts.ProductId = Core.productid) '
      '      and (Core.CodeFirmCr = GroupMaxProducerCosts.ProducerId)'
      
        '    left join Synonyms on CurrentOrderLists.SynonymCode=Synonyms' +
        '.SynonymCode'
      
        '    LEFT JOIN SynonymFirmCr ON CurrentOrderLists.SynonymFirmCrCo' +
        'de=SynonymFirmCr.SynonymFirmCrCode'
      'WHERE'
      '    CurrentOrderHeads.Frozen = 0 '
      'and CurrentOrderLists.OrderId=CurrentOrderHeads.OrderId'
      'and CurrentOrderLists.OrderCount>0'
      'and c.ClientId = CurrentOrderHeads.ClientId'
      'and Core.CoreId=CurrentOrderLists.CoreId'
      'and products.productid = CurrentOrderLists.productid'
      'and catalogs.fullcode = products.catalogid'
      'and PricesData.PriceCode = CurrentOrderHeads.PriceCode'
      'and Regions.RegionCode = CurrentOrderHeads.RegionCode')
    BeforeUpdateExecute = BeforeUpdateExecuteForClientID
    RefreshOptions = [roAfterUpdate]
    BeforeInsert = adsSummaryBeforeInsert
    BeforePost = adsSummary2BeforePost
    AfterPost = adsSummary2AfterPost
    AfterScroll = adsSummary2AfterScroll
    Options.StrictUpdate = False
    Left = 336
    Top = 104
    object adsSummaryfullcode: TLargeintField
      FieldName = 'fullcode'
    end
    object adsSummaryshortcode: TLargeintField
      FieldName = 'shortcode'
    end
    object adsSummaryCoreID: TLargeintField
      FieldName = 'CoreID'
    end
    object adsSummaryVolume: TStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsSummaryQuantity: TStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsSummaryNote: TStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsSummaryPeriod: TStringField
      FieldName = 'Period'
    end
    object adsSummaryJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsSummaryAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsSummaryCODE: TStringField
      FieldName = 'CODE'
      Size = 84
    end
    object adsSummaryCODECR: TStringField
      FieldName = 'CODECR'
      Size = 84
    end
    object adsSummarydoc: TStringField
      FieldName = 'doc'
    end
    object adsSummaryregistrycost: TFloatField
      FieldName = 'registrycost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsSummaryordercost: TFloatField
      FieldName = 'ordercost'
    end
    object adsSummaryCost: TFloatField
      FieldName = 'Cost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsSummarySynonymName: TStringField
      FieldName = 'SynonymName'
      Size = 501
    end
    object adsSummarySynonymFirm: TStringField
      FieldName = 'SynonymFirm'
      Size = 250
    end
    object adsSummaryPriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsSummaryRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsSummaryOrderCount: TIntegerField
      FieldName = 'OrderCount'
    end
    object adsSummaryOrdersCoreId: TLargeintField
      FieldName = 'OrdersCoreId'
    end
    object adsSummaryOrdersOrderId: TLargeintField
      FieldName = 'OrdersOrderId'
    end
    object adsSummarypricecode: TLargeintField
      FieldName = 'pricecode'
    end
    object adsSummaryregioncode: TLargeintField
      FieldName = 'regioncode'
    end
    object adsSummaryPriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryRequestRatio: TIntegerField
      FieldName = 'RequestRatio'
    end
    object adsSummaryMINORDERCOUNT: TIntegerField
      FieldName = 'MINORDERCOUNT'
    end
    object adsSummaryVitallyImportant: TBooleanField
      FieldName = 'VitallyImportant'
    end
    object adsSummarySumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsSummaryOrdersHOrderId: TLargeintField
      FieldName = 'OrdersHOrderId'
    end
    object adsSummaryRealCost: TFloatField
      FieldName = 'RealCost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsSummarySendDate: TDateTimeField
      FieldName = 'SendDate'
    end
    object adsSummaryDropReason: TSmallintField
      FieldName = 'DropReason'
    end
    object adsSummaryServerCost: TFloatField
      FieldName = 'ServerCost'
    end
    object adsSummaryServerQuantity: TIntegerField
      FieldName = 'ServerQuantity'
    end
    object adsSummarySendResult: TSmallintField
      FieldName = 'SendResult'
    end
    object adsSummarySupplierPriceMarkup: TFloatField
      FieldName = 'SupplierPriceMarkup'
    end
    object adsSummaryProducerCost: TFloatField
      FieldName = 'ProducerCost'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsSummaryNDS: TSmallintField
      FieldName = 'NDS'
    end
    object adsSummaryMnnId: TLargeintField
      FieldName = 'MnnId'
    end
    object adsSummaryMnn: TStringField
      FieldName = 'Mnn'
      Size = 250
    end
    object adsSummaryDescriptionId: TLargeintField
      FieldName = 'DescriptionId'
    end
    object adsSummaryCatalogVitallyImportant: TBooleanField
      FieldName = 'CatalogVitallyImportant'
    end
    object adsSummaryCatalogMandatoryList: TBooleanField
      FieldName = 'CatalogMandatoryList'
    end
    object adsSummaryRetailMarkup: TFloatField
      FieldName = 'RetailMarkup'
    end
    object adsSummaryMaxProducerCost: TFloatField
      FieldName = 'MaxProducerCost'
    end
    object adsSummaryProducerName: TStringField
      FieldName = 'ProducerName'
    end
    object adsSummaryAddressName: TStringField
      FieldName = 'AddressName'
      Size = 0
    end
    object adsSummaryRetailCost: TFloatField
      FieldName = 'RetailCost'
    end
    object adsSummaryRetailVitallyImportant: TBooleanField
      FieldName = 'RetailVitallyImportant'
    end
    object adsSummaryComment: TStringField
      FieldName = 'Comment'
    end
  end
  object tmrFillReport: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmrFillReportTimer
    Left = 424
    Top = 104
  end
end
