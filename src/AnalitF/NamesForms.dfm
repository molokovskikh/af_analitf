inherited NamesFormsForm: TNamesFormsForm
  Left = 453
  Top = 223
  Caption = #1057#1087#1080#1089#1086#1082' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
  ClientWidth = 687
  OldCreateOrder = True
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 419
    Width = 687
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object chkUseForms: TCheckBox
      Left = 450
      Top = 7
      Width = 210
      Height = 17
      Action = actUseForms
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object cbShowAll: TCheckBox
      Left = 230
      Top = 8
      Width = 210
      Height = 17
      Action = actShowAll
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object cbNewSearch: TCheckBox
      Left = 10
      Top = 8
      Width = 210
      Height = 17
      Action = actNewSearch
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1095#1072#1089#1090#1080' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object pnlTopOld: TPanel [1]
    Left = 0
    Top = 49
    Width = 687
    Height = 370
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 266
      Top = 0
      Height = 370
    end
    object dbgNames: TToughDBGrid
      Tag = 4
      Left = 0
      Top = 0
      Width = 266
      Height = 370
      Align = alLeft
      AutoFitColWidths = True
      Constraints.MaxWidth = 500
      Constraints.MinWidth = 50
      DataSource = dsNames
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgNamesDblClick
      OnEnter = dbgNamesEnter
      OnExit = dbgNamesExit
      OnGetCellParams = dbgNamesGetCellParams
      OnKeyDown = dbgNamesKeyDown
      SearchField = 'Name'
      SearchPosition = spBottom
      ForceRus = True
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Name'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = 136
        end>
    end
    object pClient: TPanel
      Left = 269
      Top = 0
      Width = 418
      Height = 370
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object dbgForms: TToughDBGrid
        Tag = 8
        Left = 0
        Top = 0
        Width = 418
        Height = 235
        Align = alClient
        AutoFitColWidths = True
        DataSource = dsForms
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = dbgFormsDblClick
        OnEnter = dbgFormsEnter
        OnExit = dbgFormsExit
        OnGetCellParams = dbgFormsGetCellParams
        OnKeyDown = dbgFormsKeyDown
        SearchField = 'Form'
        SearchPosition = spBottom
        ForceRus = True
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Form'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1072' '#1074#1099#1087#1091#1089#1082#1072
            Width = 203
          end>
      end
      object pWebBrowser: TPanel
        Left = 0
        Top = 235
        Width = 418
        Height = 135
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Bevel1: TBevel
          Left = 0
          Top = 0
          Width = 418
          Height = 4
          Align = alTop
          Shape = bsTopLine
        end
        object HTMLViewer1: THTMLViewer
          Tag = 2
          Left = 0
          Top = 4
          Width = 418
          Height = 131
          TabOrder = 0
          Align = alClient
          BorderStyle = htFocused
          HistoryMaxCount = 0
          DefFontName = 'Times New Roman'
          DefPreFontName = 'Courier New'
          NoSelect = False
          CharSet = DEFAULT_CHARSET
          PrintMarginLeft = 2.000000000000000000
          PrintMarginRight = 2.000000000000000000
          PrintMarginTop = 2.000000000000000000
          PrintMarginBottom = 2.000000000000000000
          PrintScale = 1.000000000000000000
        end
      end
    end
  end
  object pnlTop: TPanel [2]
    Left = 0
    Top = 49
    Width = 687
    Height = 370
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pWebBrowserCatalog: TPanel
      Left = 0
      Top = 235
      Width = 687
      Height = 135
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object Bevel2: TBevel
        Left = 0
        Top = 0
        Width = 687
        Height = 4
        Align = alTop
        Shape = bsTopLine
      end
      object HTMLViewer2: THTMLViewer
        Tag = 2
        Left = 0
        Top = 4
        Width = 687
        Height = 131
        TabOrder = 0
        Align = alClient
        BorderStyle = htFocused
        HistoryMaxCount = 0
        DefFontName = 'Times New Roman'
        DefPreFontName = 'Courier New'
        NoSelect = False
        CharSet = DEFAULT_CHARSET
        PrintMarginLeft = 2.000000000000000000
        PrintMarginRight = 2.000000000000000000
        PrintMarginTop = 2.000000000000000000
        PrintMarginBottom = 2.000000000000000000
        PrintScale = 1.000000000000000000
      end
    end
    object dbgCatalog: TToughDBGrid
      Tag = 16
      Left = 0
      Top = 41
      Width = 687
      Height = 194
      Align = alClient
      AutoFitColWidths = True
      DataSource = dsCatalog
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgCatalogDblClick
      OnDrawColumnCell = dbgCatalogDrawColumnCell
      OnGetCellParams = dbgCatalogGetCellParams
      OnKeyDown = dbgCatalogKeyDown
      OnKeyPress = dbgCatalogKeyPress
      SearchPosition = spBottom
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Name'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Width = 136
        end
        item
          EditButtons = <>
          FieldName = 'FORM'
          Footers = <>
          Title.Caption = #1060#1086#1088#1084#1072' '#1074#1099#1087#1091#1089#1082#1072
          Width = 134
        end>
    end
    object pnlSearch: TPanel
      Left = 0
      Top = 0
      Width = 687
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object eSearch: TEdit
        Left = 1
        Top = 10
        Width = 320
        Height = 21
        TabOrder = 0
        OnKeyDown = eSearchKeyDown
        OnKeyPress = eSearchKeyPress
      end
      object btnSearch: TButton
        Left = 520
        Top = 8
        Width = 75
        Height = 25
        Caption = #1055#1086#1080#1089#1082
        TabOrder = 1
        Visible = False
        OnClick = tmrSearchTimer
      end
      object cbSearchInBegin: TCheckBox
        Left = 336
        Top = 12
        Width = 145
        Height = 17
        Action = actSearchInBegin
        TabOrder = 2
      end
    end
  end
  object gbFilters: TGroupBox [3]
    Left = 0
    Top = 0
    Width = 687
    Height = 49
    Align = alTop
    Caption = ' '#1060#1080#1083#1100#1090#1088#1099' '
    TabOrder = 3
    DesignSize = (
      687
      49)
    object lUsedFilter: TLabel
      Left = 392
      Top = 24
      Width = 49
      Height = 13
      Caption = 'lUsedFilter'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object sbShowSynonymMNN: TSpeedButton
      Left = 214
      Top = 16
      Width = 171
      Height = 25
      AllowAllUp = True
      GroupIndex = 1
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1080#1085#1086#1085#1080#1084#1099' (Ctrl+N)'
      OnClick = sbShowSynonymMNNClick
    end
    object sbAwaitedProducts: TSpeedButton
      Left = 547
      Top = 16
      Width = 131
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1078#1080#1076#1072#1077#1084#1099#1077' '#1087#1086#1079#1080#1094#1080#1080
      OnClick = sbAwaitedProductsClick
    end
    object cbMnnFilter: TComboBox
      Left = 8
      Top = 16
      Width = 193
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = #1042#1089#1077
      OnSelect = cbMnnFilterSelect
      Items.Strings = (
        #1042#1089#1077
        #1046#1080#1079#1085#1077#1085#1085#1086' '#1074#1072#1078#1085#1099#1077
        #1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1081' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090
        #1054#1078#1080#1076#1072#1077#1084#1099#1077' '#1087#1086#1079#1080#1094#1080#1080)
    end
  end
  object dsNames: TDataSource
    DataSet = adsNames
    Left = 80
    Top = 208
  end
  object dsForms: TDataSource
    DataSet = adsForms
    Left = 440
    Top = 192
  end
  object ActionList: TActionList
    Left = 512
    Top = 168
    object actUseForms: TAction
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1092#1086#1088#1084#1077' '#1074#1099#1087#1091#1089#1082#1072' (F4)'
      Hint = #1055#1086#1080#1089#1082' '#1087#1086' '#1092#1086#1088#1084#1077' '#1074#1099#1087#1091#1089#1082#1072
      ShortCut = 115
      OnExecute = actUseFormsExecute
      OnUpdate = actUseFormsUpdate
    end
    object actShowAll: TAction
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1074#1077#1089#1100' '#1082#1072#1090#1072#1083#1086#1075
      Hint = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1074#1077#1089#1100' '#1082#1072#1090#1072#1083#1086#1075
      OnExecute = actShowAllExecute
    end
    object actNewSearch: TAction
      Caption = #1053#1086#1074#1099#1081' '#1087#1086#1080#1089#1082
      OnExecute = actNewSearchExecute
    end
    object actSearchInBegin: TAction
      Caption = #1048#1089#1082#1072#1090#1100' '#1074' '#1085#1072#1095#1072#1083#1077' '#1089#1083#1086#1074#1072
      OnExecute = actSearchInBeginExecute
    end
    object actShowSynonymMNN: TAction
      Caption = 'actShowSynonymMNN'
      ShortCut = 16462
      OnExecute = actShowSynonymMNNExecute
    end
  end
  object dsCatalog: TDataSource
    DataSet = adsCatalog
    Left = 176
    Top = 208
  end
  object tmrShowCatalog: TTimer
    Enabled = False
    Interval = 250
    OnTimer = tmrShowCatalogTimer
    Left = 256
    Top = 184
  end
  object tmrSearch: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmrSearchTimer
    Left = 304
    Top = 184
  end
  object adsForms: TMyQuery
    Connection = DM.MyConnection
    AfterScroll = adsFormsAfterScroll
    MasterSource = dsNames
    Left = 456
    Top = 184
  end
  object adsCatalog: TMyQuery
    Connection = DM.MyConnection
    Left = 200
    Top = 168
  end
  object adsNames: TMyQuery
    Connection = DM.MyConnection
    Left = 128
    Top = 184
  end
  object pmNotFoundPositions: TPopupMenu
    Left = 312
    Top = 96
    object miNotFound: TMenuItem
      Caption = #1053#1077#1090' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1081
      Default = True
    end
    object miViewOrdersHistory: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1080#1089#1090#1086#1088#1080#1102' '#1079#1072#1082#1072#1079#1086#1074
      OnClick = miViewOrdersHistoryClick
    end
  end
end
