inherited NamesFormsForm: TNamesFormsForm
  Left = 288
  Top = 198
  ActiveControl = dbgNames
  Caption = #1057#1087#1080#1089#1086#1082' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
  ClientWidth = 687
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
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
      Left = 217
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
      TabOrder = 1
    end
    object chkNewWares: TCheckBox
      Left = 13
      Top = 7
      Width = 199
      Height = 17
      Action = actNewWares
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object pnlTop: TPanel
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
    object Panel1: TPanel
      Left = 269
      Top = 0
      Width = 418
      Height = 419
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Bevel1: TBevel
        Left = 0
        Top = 231
        Width = 418
        Height = 4
        Align = alBottom
        Shape = bsTopLine
      end
      object dbgForms: TToughDBGrid
        Left = 0
        Top = 0
        Width = 418
        Height = 231
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
      object WebBrowser1: TWebBrowser
        Tag = 2
        Left = 0
        Top = 235
        Width = 418
        Height = 184
        Align = alBottom
        TabOrder = 1
        ControlData = {
          4C000000342B0000041300000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
  end
  object dsNames: TDataSource
    DataSet = adsNames
    Left = 80
    Top = 168
  end
  object adsForms: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM CatalogShowByForm'
    DataSource = dsNames
    Parameters = <
      item
        Name = 'AShortCode'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Value = 25
      end>
    Prepared = True
    Left = 440
    Top = 120
  end
  object dsForms: TDataSource
    DataSet = adsForms
    Left = 440
    Top = 168
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
  end
  object adsNames: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM CatalogShowByName'
    Parameters = <
      item
        Name = 'NewWares'
        Attributes = [paNullable]
        DataType = ftBoolean
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = False
      end>
    Prepared = True
    Left = 80
    Top = 120
  end
end
