inherited NamesFormsForm: TNamesFormsForm
  Left = 288
  Top = 198
  Caption = #1057#1087#1080#1089#1086#1082' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
  ClientWidth = 687
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 419
    Width = 687
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object chkUseForms: TCheckBox
      Left = 321
      Top = 7
      Width = 205
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
      Left = 128
      Top = 8
      Width = 193
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
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Action = actNewSearch
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object pnlTopOld: TPanel
    Left = 0
    Top = 0
    Width = 687
    Height = 419
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 266
      Top = 0
      Height = 419
    end
    object dbgNames: TToughDBGrid
      Left = 0
      Top = 0
      Width = 266
      Height = 419
      Align = alLeft
      AutoFitColWidths = True
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
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking]
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
      OnKeyDown = dbgNamesKeyDown
      SearchField = 'Name'
      SearchPosition = spBottom
      ForceRus = True
      OnSortChange = dbgNamesSortChange
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Name'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 136
        end>
    end
    object pClient: TPanel
      Left = 269
      Top = 0
      Width = 418
      Height = 419
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object dbgForms: TToughDBGrid
        Left = 0
        Top = 0
        Width = 418
        Height = 232
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
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking]
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
            Title.TitleButton = True
            Width = 203
          end>
      end
      object pWebBrowser: TPanel
        Left = 0
        Top = 232
        Width = 418
        Height = 187
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
        object WebBrowser1: TWebBrowser
          Tag = 2
          Left = 0
          Top = 4
          Width = 418
          Height = 183
          Align = alClient
          TabOrder = 0
          ControlData = {
            4C000000342B0000EA1200000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 687
    Height = 419
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pWebBrowserCatalog: TPanel
      Left = 0
      Top = 232
      Width = 687
      Height = 187
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
      object WebBrowser2: TWebBrowser
        Tag = 2
        Left = 0
        Top = 4
        Width = 687
        Height = 183
        Align = alClient
        TabOrder = 0
        ControlData = {
          4C00000001470000EA1200000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object dbgCatalog: TToughDBGrid
      Left = 0
      Top = 41
      Width = 687
      Height = 191
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
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
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
      OnKeyDown = dbgCatalogKeyDown
      OnKeyPress = dbgCatalogKeyPress
      SearchPosition = spBottom
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Name'
          Footers = <>
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Title.TitleButton = True
          Width = 136
        end
        item
          EditButtons = <>
          FieldName = 'FORM'
          Footers = <>
          Title.Caption = #1060#1086#1088#1084#1072' '#1074#1099#1087#1091#1089#1082#1072
          Title.TitleButton = True
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
      DesignSize = (
        687
        41)
      object eSearch: TEdit
        Left = 194
        Top = 10
        Width = 300
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnKeyDown = eSearchKeyDown
        OnKeyPress = eSearchKeyPress
      end
      object btnSearch: TButton
        Left = 520
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1055#1086#1080#1089#1082
        TabOrder = 1
        OnClick = tmrSearchTimer
      end
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
    object actNewWares: TAction
      Caption = #1053#1086#1074#1099#1077' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103' (F3)'
      Hint = #1053#1086#1074#1099#1077' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103
      ShortCut = 114
      OnExecute = actNewWaresExecute
    end
    object actUseForms: TAction
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1092#1086#1088#1084#1077' '#1074#1099#1087#1091#1089#1082#1072' (F4)'
      Hint = #1055#1086#1080#1089#1082' '#1087#1086' '#1092#1086#1088#1084#1077' '#1074#1099#1087#1091#1089#1082#1072
      ShortCut = 115
      OnExecute = actUseFormsExecute
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
  end
  object adsNames: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ASHORTCODE,'
      '    NAME'
      'FROM'
      '    CATALOGSHOWBYNAME(:SHOWALL) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 80
    Top = 160
    oCacheCalcFields = True
  end
  object adsForms: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '*'
      'FROM'
      '    CATALOGSHOWBYFORM(:ASHORTCODE, :SHOWAll) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    DataSource = dsNames
    Left = 437
    Top = 152
    dcForceOpen = True
    oCacheCalcFields = True
  end
  object adsCatalog: TpFIBDataSet
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    UpdateTransaction = DM.UpTran
    Left = 176
    Top = 168
    oCacheCalcFields = True
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
    OnTimer = tmrSearchTimer
    Left = 304
    Top = 184
  end
end
