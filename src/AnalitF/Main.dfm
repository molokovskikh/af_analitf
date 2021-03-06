object MainForm: TMainForm
  Left = 78
  Top = 138
  AutoScroll = False
  Caption = 'MainForm'
  ClientHeight = 554
  ClientWidth = 1016
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 1016
    Height = 42
    AutoSize = True
    BandBorderStyle = bsNone
    BandMaximize = bmNone
    Bands = <
      item
        Control = ToolBar
        HorizontalOnly = True
        ImageIndex = -1
        MinHeight = 38
        Width = 1016
      end>
    Color = clBtnFace
    EdgeBorders = [ebTop, ebBottom]
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    object ToolBar: TToolBar
      Left = 9
      Top = 0
      Width = 1003
      Height = 38
      ButtonHeight = 38
      ButtonWidth = 39
      Color = clBtnFace
      EdgeBorders = []
      Flat = True
      Images = ImageList
      ParentColor = False
      TabOrder = 0
      Transparent = True
      Wrapable = False
      OnAdvancedCustomDraw = ToolBarAdvancedCustomDraw
      OnMouseDown = ToolBarMouseDown
      OnMouseMove = ToolBarMouseMove
      object btnStartExchange: TToolButton
        Left = 0
        Top = 0
        Action = actReceive
        DropdownMenu = DownloadMenu
        ImageIndex = 0
        Style = tbsDropDown
      end
      object ToolButton2: TToolButton
        Left = 54
        Top = 0
        Action = actSendOrders
        ImageIndex = 1
      end
      object ToolButton5: TToolButton
        Left = 93
        Top = 0
        Width = 8
        Caption = 'ToolButton5'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object ToolButton1: TToolButton
        Left = 101
        Top = 0
        Action = actSave
        ImageIndex = 2
      end
      object btnPrint: TToolButton
        Left = 140
        Top = 0
        Action = actPrint
        ImageIndex = 3
      end
      object tbFind: TToolButton
        Left = 179
        Top = 0
        Action = actFind
        ImageIndex = 13
      end
      object ToolButton11: TToolButton
        Left = 218
        Top = 0
        Width = 8
        Caption = 'ToolButton11'
        ImageIndex = 9
        Style = tbsSeparator
      end
      object btnOrderAll: TToolButton
        Left = 226
        Top = 0
        Hint = #1055#1086#1080#1089#1082' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074' '#1074' '#1082#1072#1090#1072#1083#1086#1075#1077
        Action = actOrderAll
        ImageIndex = 4
      end
      object tbSynonymSearch: TToolButton
        Left = 265
        Top = 0
        Action = actSynonymSearch
        ImageIndex = 16
      end
      object tbMnnSearch: TToolButton
        Left = 304
        Top = 0
        Action = actMnnSearch
      end
      object btnOrderPrice: TToolButton
        Left = 343
        Top = 0
        Action = actOrderPrice
        ImageIndex = 6
      end
      object btnShowMinPrices: TToolButton
        Left = 382
        Top = 0
        Action = actShowMinPrices
      end
      object tbAwaitedProducts: TToolButton
        Left = 421
        Top = 0
        Action = actAwaitedProducts
      end
      object ToolButton3: TToolButton
        Left = 460
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 20
        Style = tbsSeparator
      end
      object btnOrderSummary: TToolButton
        Left = 468
        Top = 0
        Action = actOrderSummary
        ImageIndex = 17
      end
      object btnClosedOrders: TToolButton
        Left = 507
        Top = 0
        Action = actClosedOrders
        ImageIndex = 8
      end
      object btnPostOrderBatch: TToolButton
        Left = 546
        Top = 0
        Action = actPostOrderBatch
      end
      object ToolButton4: TToolButton
        Left = 585
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 20
        Style = tbsSeparator
      end
      object btnOrderRegister: TToolButton
        Left = 593
        Top = 0
        Action = actRegistry
        Caption = #1043#1086#1089#1091#1076#1072#1088#1089#1090#1074#1077#1085#1085#1099#1081' '#1088#1077#1077#1089#1090#1088' '#1094#1077#1085
        ImageIndex = 9
      end
      object btnExpireds: TToolButton
        Left = 632
        Top = 0
        Action = actSale
        ImageIndex = 5
      end
      object btnDefectives: TToolButton
        Left = 671
        Top = 0
        Action = actDefectives
        ImageIndex = 10
      end
      object ToolButton10: TToolButton
        Left = 710
        Top = 0
        Width = 8
        Caption = 'ToolButton10'
        ImageIndex = 14
        Style = tbsSeparator
      end
      object tbWaybill: TToolButton
        Left = 718
        Top = 0
        Action = actWayBill
      end
      object tbViewDocs: TToolButton
        Left = 757
        Top = 0
        Action = actViewDocs
      end
      object ToolButton9: TToolButton
        Left = 796
        Top = 0
        Width = 8
        Caption = 'ToolButton9'
        ImageIndex = 5
        Style = tbsSeparator
      end
      object btnHome: TToolButton
        Left = 804
        Top = 0
        Action = actHome
      end
      object btnConfig: TToolButton
        Left = 843
        Top = 0
        Action = actConfig
        ImageIndex = 12
      end
      object tbLastSeparator: TToolButton
        Left = 882
        Top = 0
        Width = 8
        Caption = 'tbLastSeparator'
        ImageIndex = 13
        Style = tbsSeparator
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 535
    Width = 1016
    Height = 19
    Panels = <
      item
        Text = #1047#1072#1082#1072#1079#1086#1074' :'
        Width = 70
      end
      item
        Text = #1055#1086#1079#1080#1094#1080#1081' :'
        Width = 100
      end
      item
        Text = 'C'#1091#1084#1084#1072':'
        Width = 120
      end
      item
        Text = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' :'
        Width = 183
      end
      item
        Text = #1047#1072' '#1084#1077#1089#1103#1094':'
        Width = 130
      end
      item
        Text = #1047#1072' '#1085#1077#1076#1077#1083#1102':'
        Width = 130
      end
      item
        Alignment = taRightJustify
        Text = 'ID information       '
        Width = 100
      end>
    OnDrawPanel = StatusBarDrawPanel
  end
  object pMain: TPanel
    Left = 0
    Top = 42
    Width = 1016
    Height = 493
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object HTMLViewer: THTMLViewer
      Tag = 1
      Left = 0
      Top = 169
      Width = 1016
      Height = 324
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
    object pTopContact: TPanel
      Left = 0
      Top = 0
      Width = 1016
      Height = 169
      Align = alTop
      TabOrder = 1
      object htmlContact: THTMLViewer
        Tag = 1
        Left = 1
        Top = 1
        Width = 320
        Height = 167
        TabOrder = 0
        Align = alLeft
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
      object pNews: TPanel
        Left = 321
        Top = 1
        Width = 694
        Height = 167
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object dbgNews: TToughDBGrid
          Left = 0
          Top = 33
          Width = 694
          Height = 134
          Align = alClient
          DataSource = dsNews
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghDialogFind]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          SearchPosition = spBottom
        end
        object pFilter: TPanel
          Left = 0
          Top = 0
          Width = 694
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object lHeader: TLabel
            Left = 8
            Top = 8
            Width = 51
            Height = 13
            Caption = #1053#1086#1074#1086#1089#1090#1080
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
    end
  end
  object pStartUp: TPanel
    Left = 0
    Top = 42
    Width = 1016
    Height = 493
    Align = alClient
    Caption = #1047#1072#1087#1091#1089#1082' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object MainMenu: TMainMenu
    Left = 224
    Top = 160
    object itmActions: TMenuItem
      Caption = '&'#1060#1072#1081#1083
      object itmReceive: TMenuItem
        Action = actReceive
      end
      object itmSendOrders: TMenuItem
        Action = actSendOrders
      end
      object itmReceiveTickets: TMenuItem
        Action = actWayBill
      end
      object N17: TMenuItem
        Action = actReceiveAll
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object itmSave: TMenuItem
        Action = actSave
      end
      object N4: TMenuItem
        Action = actPreview
      end
      object itmPrint: TMenuItem
        Action = actPrint
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object itmExit: TMenuItem
        Action = actExit
      end
    end
    object itmOrder: TMenuItem
      Caption = '&'#1047#1072#1082#1072#1079
      object itmOrderAll: TMenuItem
        Action = actOrderAll
      end
      object itmExpireds: TMenuItem
        Action = actSale
      end
      object itmOrderPrice: TMenuItem
        Action = actOrderPrice
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object itmOrderSummary: TMenuItem
        Action = actOrderSummary
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object itmClosedOrders: TMenuItem
        Action = actClosedOrders
      end
      object miOrderBatch: TMenuItem
        Action = actPostOrderBatch
      end
    end
    object itmDocuments: TMenuItem
      Caption = '&'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      object itmRegistry: TMenuItem
        Action = actRegistry
        Caption = #1043#1086#1089#1091#1076#1072#1088#1089#1090#1074#1077#1085#1085#1099#1081' '#1088#1077#1077#1089#1090#1088' '#1094#1077#1085
      end
      object itmDefective: TMenuItem
        Action = actDefectives
      end
      object miMiniMailFromDocs: TMenuItem
        Action = actMiniMail
      end
    end
    object itmService: TMenuItem
      Caption = #1057#1077'&'#1088#1074#1080#1089
      object itmConfig: TMenuItem
        Action = actConfig
      end
      object miSendLetter: TMenuItem
        Action = actSendLetter
      end
      object itmServiceLog: TMenuItem
        Action = actServiceLog
      end
      object itmMiniMail: TMenuItem
        Action = actMiniMail
      end
      object itmCompact: TMenuItem
        Action = actCompact
      end
      object itmRestoreDatabase: TMenuItem
        Action = actRestoreDatabase
      end
      object itmActiveUsers: TMenuItem
        Caption = #1040#1082#1090#1080#1074#1085#1099#1077' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
        Hint = #1040#1082#1090#1080#1074#1085#1099#1077' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
        ImageIndex = 20
        Visible = False
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object itmSystem: TMenuItem
        Caption = #1057#1083#1091#1078#1077#1073#1085#1099#1077
        object itmFreeChildForms: TMenuItem
          Action = actCloseAll
        end
        object N2: TMenuItem
          Caption = '-'
          Visible = False
        end
        object itmLinkExternal: TMenuItem
          Caption = #1055#1088#1080#1089#1086#1077#1076#1080#1085#1080#1090#1100' '#1074#1085#1077#1096#1085#1080#1077' '#1090#1072#1073#1083#1080#1094#1099
          Visible = False
          OnClick = itmLinkExternalClick
        end
        object itmUnlinkExternal: TMenuItem
          Caption = #1054#1090#1089#1086#1077#1076#1080#1085#1080#1090#1100' '#1074#1085#1077#1096#1085#1080#1077' '#1090#1072#1073#1083#1080#1094#1099
          Visible = False
          OnClick = itmUnlinkExternalClick
        end
        object N6: TMenuItem
          Caption = '-'
        end
        object itmClearDatabase: TMenuItem
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1073#1072#1079#1091
          Visible = False
          OnClick = itmClearDatabaseClick
        end
        object itmImport: TMenuItem
          Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077
          OnClick = itmImportClick
        end
        object itmRestoreDatabaseFromEtalon: TMenuItem
          Action = actRestoreDatabaseFromEtalon
          Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' '#1089' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1077#1084' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1093' '#1079#1072#1082#1072#1079#1086#1074
        end
        object miGetHistoryOrders: TMenuItem
          Action = actGetHistoryOrders
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1089#1090#1086#1088#1080#1102' '#1079#1072#1082#1072#1079#1086#1074'/'#1085#1072#1082#1083#1072#1076#1085#1099#1093
        end
      end
    end
    object itmHelp: TMenuItem
      Caption = '&'#1057#1087#1088#1072#1074#1082#1072
      object itmAbout: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
        OnClick = itmAboutClick
      end
    end
  end
  object FormPlacement: TFormPlacement
    UseRegistry = True
    Left = 192
    Top = 192
  end
  object XPManifest1: TXPManifest
    Left = 224
    Top = 192
  end
  object DownloadMenu: TPopupMenu
    Left = 256
    Top = 192
    object miReceive: TMenuItem
      Action = actReceive
      Default = True
    end
    object N12: TMenuItem
      Action = actSendOrders
    end
    object N13: TMenuItem
      Action = actWayBill
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object N15: TMenuItem
      Action = actReceiveAll
    end
  end
  object ActionList: TActionList
    Left = 192
    Top = 160
    object actReceive: TAction
      Category = 'Actions'
      Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 16466
      OnExecute = actReceiveExecute
    end
    object actHelpContent: TAction
      Category = 'Help'
      Caption = #1055#1086#1084#1086#1097#1100
      Hint = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077' '#1087#1086#1084#1086#1097#1080
      ImageIndex = 1
      ShortCut = 112
    end
    object actSendOrders: TAction
      Category = 'Actions'
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1079#1072#1082#1072#1079#1099
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1079#1072#1082#1072#1079#1099
      ImageIndex = 3
      ShortCut = 16467
      OnExecute = actSendOrdersExecute
      OnUpdate = actSendOrdersUpdate
    end
    object actPreview: TAction
      Category = 'Actions'
      Caption = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088'...'
      Hint = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088
      OnExecute = actPreviewExecute
      OnUpdate = actPreviewUpdate
    end
    object actConfig: TAction
      Category = 'Service'
      Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1103
      Hint = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1103
      ImageIndex = 4
      OnExecute = actConfigExecute
    end
    object actOrderAll: TAction
      Category = 'Order'
      Caption = 'C'#1087#1080#1089#1086#1082' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
      Hint = #1055#1086#1080#1089#1082' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074' '#1074' '#1082#1072#1090#1072#1083#1086#1075#1077' (F8)'
      ImageIndex = 9
      ShortCut = 119
      OnExecute = actOrderAllExecute
    end
    object actSale: TAction
      Category = 'Order'
      Caption = #1059#1094#1077#1085#1077#1085#1085#1099#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1099
      Hint = #1059#1094#1077#1085#1077#1085#1085#1099#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1099
      ImageIndex = 18
      OnExecute = actSaleExecute
    end
    object actOrderPrice: TAction
      Category = 'Order'
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
      Hint = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099' '#1092#1080#1088#1084
      ImageIndex = 11
      ShortCut = 120
      OnExecute = actOrderPriceExecute
    end
    object actCompact: TAction
      Category = 'Service'
      Caption = #1057#1078#1072#1090#1080#1077' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
      Hint = #1057#1078#1072#1090#1080#1077' '#1080' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
      ImageIndex = 5
      OnExecute = actCompactExecute
    end
    object actOrderSummary: TAction
      Category = 'Order'
      Caption = #1057#1074#1086#1076#1085#1099#1081' '#1079#1072#1082#1072#1079
      Hint = #1057#1074#1086#1076#1085#1099#1081' '#1079#1072#1082#1072#1079
      ImageIndex = 10
      ShortCut = 121
      OnExecute = actOrderSummaryExecute
    end
    object actAbout: TAction
      Category = 'Help'
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      Hint = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      ImageIndex = 6
    end
    object actPrint: TAction
      Category = 'Actions'
      Caption = #1055#1077#1095#1072#1090#1100
      Enabled = False
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 7
      ShortCut = 16464
      OnExecute = actPrintExecute
      OnUpdate = actPrintUpdate
    end
    object actRegistry: TAction
      Category = 'Documents'
      Caption = #1043#1086#1089'. '#1088#1077#1077#1089#1090#1088' '#1094#1077#1085
      Hint = #1043#1086#1089#1091#1076#1072#1088#1089#1090#1074#1077#1085#1085#1099#1081' '#1088#1077#1077#1089#1090#1088' '#1094#1077#1085
      ImageIndex = 12
      Visible = False
      OnExecute = actRegistryExecute
    end
    object actDefectives: TAction
      Category = 'Documents'
      Caption = #1047#1072#1073#1088#1072#1082#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1099
      Hint = #1047#1072#1073#1088#1072#1082#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1099
      ImageIndex = 15
      OnExecute = actDefectivesExecute
    end
    object actClosedOrders: TAction
      Category = 'Order'
      Caption = #1047#1072#1082#1072#1079#1099
      Hint = #1047#1072#1082#1072#1079#1099
      ImageIndex = 13
      ShortCut = 123
      OnExecute = actClosedOrdersExecute
    end
    object actExit: TAction
      Category = 'Actions'
      Caption = #1042#1099#1093#1086#1076
      Hint = #1042#1099#1093#1086#1076' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      ImageIndex = 19
      ShortCut = 32883
      OnExecute = actExitExecute
    end
    object actSave: TAction
      Category = 'Actions'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1090#1072#1073#1083#1080#1094#1091
      ImageIndex = 21
      ShortCut = 16468
      OnExecute = actSaveExecute
      OnUpdate = actSaveUpdate
    end
    object actCloseAll: TAction
      Category = 'Actions'
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1089#1077' '#1086#1082#1085#1072
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1074#1089#1077' '#1086#1082#1085#1072
      ShortCut = 16499
      OnExecute = actCloseAllExecute
    end
    object actReceiveAll: TAction
      Category = 'Actions'
      Caption = #1050#1091#1084#1091#1083#1103#1090#1080#1074#1085#1086#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077
      Hint = #1050#1091#1084#1091#1083#1103#1090#1080#1074#1085#1086#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077
      OnExecute = actReceiveAllExecute
    end
    object actFind: TAction
      Category = 'Actions'
      Caption = #1053#1072#1081#1090#1080'...'
      Hint = #1053#1072#1081#1090#1080' (Ctrl+F)'
      Visible = False
      OnExecute = actFindExecute
      OnUpdate = actFindUpdate
    end
    object actHome: TAction
      Category = 'Service'
      Caption = #1053#1072' '#1075#1083#1072#1074#1085#1091#1102' '#1089#1090#1088#1072#1085#1080#1094#1091
      Hint = #1053#1072' '#1075#1083#1072#1074#1085#1091#1102' '#1089#1090#1088#1072#1085#1080#1094#1091
      ImageIndex = 14
      OnExecute = actHomeExecute
      OnUpdate = actHomeUpdate
    end
    object actWayBill: TAction
      Category = 'Order'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080' '#1087#1086#1083#1091#1095#1080#1090#1100' '#1085#1072#1082#1083#1072#1076#1085#1099#1077', '#1089#1077#1088#1090#1080#1092#1080#1082#1072#1090#1099
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080' '#1087#1086#1083#1091#1095#1080#1090#1100' '#1085#1072#1082#1083#1072#1076#1085#1099#1077', '#1089#1077#1088#1090#1080#1092#1080#1082#1072#1090#1099
      ImageIndex = 15
      OnExecute = actWayBillExecute
    end
    object actSynonymSearch: TAction
      Category = 'Order'
      Caption = #1055#1086#1080#1089#1082' '#1074' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1093
      Hint = #1055#1086#1080#1089#1082' '#1074' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1093
      OnExecute = actSynonymSearchExecute
    end
    object actSendLetter: TAction
      Category = 'Service'
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1080#1089#1100#1084#1086' '#1074' '#1040#1050' "'#1048#1085#1092#1086#1088#1091#1084'"'
      OnExecute = actSendLetterExecute
    end
    object actViewDocs: TAction
      Category = 'Order'
      Caption = #1053#1072#1082#1083#1072#1076#1085#1099#1077
      Hint = #1053#1072#1082#1083#1072#1076#1085#1099#1077
      ImageIndex = 18
      OnExecute = actViewDocsExecute
    end
    object actMnnSearch: TAction
      Category = 'Order'
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1052#1053#1053
      Hint = #1055#1086#1080#1089#1082' '#1087#1086' '#1052#1053#1053
      ImageIndex = 19
      ShortCut = 16461
      OnExecute = actMnnSearchExecute
    end
    object actRestoreDatabase: TAction
      Category = 'Service'
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
      OnExecute = actRestoreDatabaseExecute
    end
    object actRestoreDatabaseFromEtalon: TAction
      Category = 'Service'
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1101#1090#1072#1083#1086#1085#1072
      OnExecute = actRestoreDatabaseFromEtalonExecute
    end
    object actPostOrderBatch: TAction
      Category = 'Order'
      Caption = #1040#1074#1090#1086#1047#1072#1082#1072#1079
      Hint = #1040#1074#1090#1086#1047#1072#1082#1072#1079
      ImageIndex = 7
      Visible = False
      OnExecute = actPostOrderBatchExecute
    end
    object actGetHistoryOrders: TAction
      Category = 'Order'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1089#1090#1086#1088#1080#1102' '#1079#1072#1082#1072#1079#1086#1074
      OnExecute = actGetHistoryOrdersExecute
    end
    object actShowMinPrices: TAction
      Category = 'Order'
      Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1077' '#1094#1077#1085#1099
      Hint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1077' '#1094#1077#1085#1099
      ImageIndex = 11
      OnExecute = actShowMinPricesExecute
    end
    object actServiceLog: TAction
      Category = 'Service'
      Caption = #1046#1091#1088#1085#1072#1083' '#1088#1072#1073#1086#1090#1099' '#1089#1077#1088#1074#1080#1089#1072
      Hint = #1046#1091#1088#1085#1072#1083' '#1088#1072#1073#1086#1090#1099' '#1089#1077#1088#1074#1080#1089#1072
      OnExecute = actServiceLogExecute
    end
    object actMiniMail: TAction
      Category = 'Service'
      Caption = #1052#1080#1085#1080'-'#1087#1086#1095#1090#1072
      Hint = #1052#1080#1085#1080'-'#1087#1086#1095#1090#1072
      OnExecute = actMiniMailExecute
    end
    object actAwaitedProducts: TAction
      Category = 'Order'
      Caption = #1054#1078#1080#1076#1072#1077#1084#1099#1077' '#1087#1086#1079#1080#1094#1080#1080
      Hint = #1054#1078#1080#1076#1072#1077#1084#1099#1077' '#1087#1086#1079#1080#1094#1080#1080
      ImageIndex = 20
      OnExecute = actAwaitedProductsExecute
    end
  end
  object AppEvents: TApplicationEvents
    OnActivate = AppEventsActivate
    OnIdle = AppEventsIdle
    OnMessage = AppEventsMessage
    OnRestore = AppEventsRestore
    Left = 288
    Top = 160
  end
  object ImageList: TImageList
    Height = 32
    Width = 32
    Left = 256
    Top = 160
    Bitmap = {
      494C010115001800040020002000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000080000000C000000001002000000000000080
      010000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FFFEFEFEFFEEEE
      EEFFCFCFCFFFC7C7C7FFCECECEFFE0E0E0FFFAFAFAFF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FFE7E8E9FF82A0
      B5FF467FA6FF457AA0FF607C92FF919497FFD3D3D3FFF6F6F6FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF8CB8D8FF138D
      E3FF0099FFFF05A6FEFF1EBAE8FF2D83BBFF787F86FFB9B9B9FFF1F1F1FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF529FD7FF0794
      F2FF0098FFFF0FCCFFFF1DFCFDFF1DD1EFFF327BB3FF6D7B87FFBDBDBDFFECEC
      ECFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FFECF0F2FF228DD7FF0298
      F9FF019EFFFF15E4FFFF1CFAFFFF1BFEFFFF1DDFF4FF2297D3FF5C7388FF9FA0
      A0FFE4E4E4FFFBFBFBFF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FFC3D1DBFF148EE1FF0098
      FDFF04A8FFFF18EDFFFF1BF6FFFF1CF6FFFF1CFAFEFF1CE8F7FF2490CBFF5073
      91FFA7A7A7FFDCDCDCFFFBFBFBFF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF89ACC5FF0C93EDFF0097
      FFFF09BAFFFF19F1FFFF1AF3FFFF19F4FFFF1BF4FFFF1BF7FFFF1AF0FAFF1DAF
      E5FF44739AFF7C848BFFB4B4B4FFC5C5C5FFC7C7C7FFC7C7C7FFC7C7C7FFC2C2
      C3FFBFBFBFFFCECECEFFF3F3F3FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFF3F4F5FF62A1D0FF0597F6FF0096
      FFFF0ECCFFFF19F0FFFF18F0FFFF1AF0FFFF1AF3FFFF19F2FFFF1BF6FFFF1AF1
      FCFF1FB4E2FF2B81BAFF44739BFF4C789EFF4D799FFF4C799EFF4A79A0FF4279
      A4FF4579A1FF74838FFFD5D5D5FFFEFEFEFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFD5DADDFF3D96D7FF009AFEFF0098
      FFFF14DEFFFF18ECFFFF17EBFFFF17EEFFFF19EEFFFF19F0FFFF18F0FFFF1AF2
      FFFF19F6FFFF19F1FCFF1CDDF5FF1CDDF5FF1CDDF5FF1CDEF5FF1CE1F5FF1DE9
      F8FF1DD2EFFF3886B9FFCCCCCCFFFDFDFDFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFB7C6D0FF2391DCFF009BFFFF01A1
      FFFF16E6FFFF17E8FFFF18E9FFFF18EBFFFF18ECFFFF17EDFFFF19EEFFFF18EE
      FFFF1AF1FFFF1AF2FFFF19F5FFFF1BF6FFFF1BF7FFFF1AF8FFFF1CF9FFFF1CFD
      FFFF1CD4F1FF4887B2FFDEDEDEFFFEFEFEFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FFF8F8F8FF62A0CCFF0B94EDFF009BFFFF06B2
      FFFF16E6FFFF16E3FFFF15E4FFFF15E7FFFF17E7FFFF16E8FFFF18E9FFFF18EC
      FFFF17ECFFFF19EDFFFF19EEFFFF18EFFFFF1AF1FFFF1AF2FFFF19F3FFFF1BFB
      FFFF21A9DBFF798E9EFFF2F2F2FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FFF4F4F4FFA7B4BEFF208DD8FF029CF9FF009BFFFF0AC0
      FFFF15E2FFFF14E0FFFF16E2FFFF16E2FFFF16E5FFFF15E6FFFF17E8FFFF16E7
      FFFF18EAFFFF18EBFFFF17EDFFFF19ECFFFF19EFFFFF18F0FFFF1AF2FFFF19F3
      FEFF2D8EC7FF9FA7ADFFFBFBFBFF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FFFBFBFBFFDEDFE0FF7597AFFF248BD2FF039EF8FF009FFFFF06B5FFFF12D7
      FFFF12DCFFFF14DCFFFF13DDFFFF13E0FFFF15E0FFFF14E1FFFF16E4FFFF16E5
      FFFF15E5FFFF17E6FFFF17E7FFFF16E8FFFF18EBFFFF18EBFFFF17EFFFFF1AD8
      F5FF497EA9FFCBCCCDFF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FFFBFB
      FBFFC8CBCDFF6390B3FF1891DCFF05A1F6FF00A4FFFF07B9FFFF11D5FFFF12D8
      FFFF13D9FFFF13DAFFFF12DCFFFF14DBFFFF14DEFFFF13DFFFFF15DFFFFF14E2
      FFFF16E3FFFF16E4FFFF15E5FFFF17E5FFFF17E8FFFF16E9FFFF17ECFEFF1BBB
      EAFF6E8AA1FFE4E4E4FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FFE8E8E8FF9FAE
      B9FF2D8BCCFF0E9EEBFF00ADFFFF01AFFFFF0CC6FFFF10D1FFFF0FD2FFFF11D4
      FFFF10D4FFFF10D5FFFF12D8FFFF11D7FFFF13DAFFFF13DAFFFF12DBFFFF14DC
      FFFF13DFFFFF13DFFFFF15E2FFFF14E3FFFF16E3FFFF15E5FFFF16E1FAFF1E9B
      DAFFA2AAB0FFF5F5F5FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FFF3F3F3FF7A9BB4FF2B8C
      CCFF07ADF3FF00B5FDFF02B7FFFF0BC5FFFF0FCDFFFF0ECCFFFF10CFFFFF10CF
      FFFF0FD2FFFF11D1FFFF10D4FFFF12D5FFFF12D5FFFF11D8FFFF13D9FFFF13DA
      FFFF12DCFFFF14DDFFFF14DFFFFF13E0FFFF15E1FFFF14E2FFFF17D7F7FF2B8B
      C5FFBBBBBBFFF8F8F8FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FAFBFCFF6DA2C9FF12A3E5FF02C2
      FAFF00C2FFFF03BEFFFF0CC5FFFF0DC7FFFF0CC7FFFF0EC8FFFF0DCBFFFF0DCB
      FFFF0FCCFFFF0ECFFFFF10CFFFFF0FD0FFFF11D1FFFF11D2FFFF10D5FFFF12D5
      FFFF12D6FFFF11D9FFFF13D9FFFF12DAFFFF14DDFFFF13DEFFFF16D2F6FF2D87
      C0FFB1B1B1FFF3F3F3FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F2F7FBFF379CD8FF00D6FDFF00D1
      FFFF01C7FFFF0AC0FFFF0CC2FFFF0CC3FFFF0BC5FFFF0DC6FFFF0CC8FFFF0EC9
      FFFF0ECAFFFF0DCAFFFF0FCDFFFF0ECEFFFF10CFFFFF10D0FFFF0FD2FFFF11D3
      FFFF10D4FFFF12D4FFFF12D7FFFF11D8FFFF13DAFFFF12DBFFFF13D4F8FF2391
      D1FF96999BFFE6E6E6FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F8FBFDFF54A3DAFF08C8F2FF00DC
      FCFF00D5FFFF05C5FFFF0ABDFFFF0ABDFFFF0BC0FFFF0AC0FFFF0CC2FFFF0BC3
      FFFF0DC6FFFF0DC6FFFF0CC9FFFF0ECAFFFF0DCAFFFF0DCBFFFF0FCEFFFF0ECE
      FFFF10D1FFFF0FD2FFFF11D2FFFF11D3FFFF10D4FFFF12D7FFFF11D9FDFF19A9
      E7FF667D91FFCCCCCCFF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FFCBDCE9FF46A1DDFF13A7
      E3FF03D6FAFF00DDFFFF02CCFFFF07C0FFFF0ABBFFFF0ABDFFFF0BC0FFFF0AC1
      FFFF0CC3FFFF0BC2FFFF0DC5FFFF0DC5FFFF0EC8FFFF0EC9FFFF0DCBFFFF0FCA
      FFFF0FCDFFFF0ECDFFFF10D0FFFF0FD1FFFF11D2FFFF11D2FFFF10D7FFFF15BF
      F1FF46749BFFB0B0B0FFFAFAFAFF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FFFAFAFAFFB3C8
      D8FF4B9FDBFF17AAE2FF04D4F7FF00DCFEFF02CCFFFF06BFFFFF09BAFFFF0ABB
      FFFF09BDFFFF0BBEFFFF0AC1FFFF0AC2FFFF0CC2FFFF0BC3FFFF0DC5FFFF0CC6
      FFFF0EC9FFFF0EC9FFFF0DCCFFFF0FCDFFFF0ECDFFFF0ED0FFFF10D2FFFF10D1
      FDFF2B84BDFF848E94FFEDEDEDFF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FFE2E8EDFF9CC9ECFF2A9AD9FF0FB4E8FF00DDFDFF00D6FFFF03C5FFFF08B9
      FFFF0ABBFFFF0ABCFFFF09BEFFFF0BBDFFFF0BC0FFFF0AC1FFFF0CC3FFFF0BC4
      FFFF0DC6FFFF0CC7FFFF0EC9FFFF0EC8FFFF0DCBFFFF0FCBFFFF0FCDFFFF0ED2
      FFFF1F99D8FF657889FFDBDBDBFFFEFEFEFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FFEDF2F6FF94BCDDFF299DDAFF06D1F5FF00DDFFFF02C7
      FFFF08B4FFFF07B6FFFF09B8FFFF08BAFFFF0ABAFFFF0ABDFFFF09BDFFFF0BC0
      FFFF0AC0FFFF0CC1FFFF0CC3FFFF0BC4FFFF0DC6FFFF0CC9FFFF0CCAFFFF0CCC
      FFFF14B5EFFF4480A9FFD0D0D0FFFDFDFDFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFA0CBEDFF23A0DCFF01E3FFFF00DD
      FFFF06B4FFFF07B2FFFF08B6FFFF07B5FFFF09B8FFFF09B8FFFF0ABBFFFF0ABB
      FFFF09BEFFFF0ABFFFFF09C2FFFF09C5FFFF0AC5FFFF0BC5FFFF0DC3FCFF0EBF
      F8FF15ABEAFF4D91C0FFE4E4E4FFFEFEFEFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFF7F7F8FF72A6D1FF0CCCF2FF04E8
      FFFF04C5FFFF06AEFFFF07B0FFFF07B1FFFF06B4FFFF06B5FFFF08B5FFFF07B7
      FFFF08B9FEFF0CB4F8FF15A0E7FF279DDFFF369EDCFF429CD9FF519ED6FF60A3
      D5FF7EAACCFFD1D8DDFFFEFEFEFF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FFB5C9D9FF16AFE4FF08EA
      FDFF05D6FFFF04ADFFFF04AEFFFF06ADFFFF07B0FFFF07B0FFFF07B3FFFF06B6
      FFFF0FA6EEFF288FD4FF8AAFCBFFBBC5CDFFCFD5D9FFDADEE2FFE8EBEDFFF6F7
      F7FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FFF8F9FAFF359CD9FF0FDE
      F6FF0BE8FFFF04B7FFFF03A7FFFF03AAFFFF05ACFFFF04ACFFFF05AEFDFF0FA0
      ECFF4B8CBDFFC6CBCFFF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF75B5E3FF16CA
      EDFF0EF2FFFF07CAFFFF02A1FFFF04A6FFFF04A8FFFF02AAFFFF0E9DECFF388F
      CDFFC8CCCEFFFCFCFCFF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FFBFD4E4FF2CA8
      DDFF13FBFFFF10E8FFFF019FFFFF01A0FFFF02A3FCFF0F98EBFF4F8DBDFFCACD
      D0FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FFE5E9EBFF4DA1
      DDFF17EFFAFF15FCFFFF04AEFFFF009CFFFF0F96EAFF3C8FCBFFCBCED1FFFCFC
      FCFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FFB8CB
      DBFF2AA3DDFF1BD9F0FF12D2F6FF1095E8FF5893C0FFCED1D3FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FFB5D6F0FF6AAEDEFF4BA2D7FF78B0D7FFDBDDDFFFFEFEFEFF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00E7E7E700CECECE00D6D6D600E7E7E700F7F7F700FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00F7F7F700DEDE
      DE00D6D6D600E7E7E700FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7E7E700CECE
      CE00E7E7E700FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000FFFFFF00D6D6CE00B5948C00AD8C7B009C8C84009C9C9C00B5B5B500CECE
      CE00E7E7E700F7F7F700FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00E7E7E7008C9CB500527B
      A5005A7394008C949400D6D6D600F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF00848C
      9C00526B84007B848400B5B5B500EFEFEF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7E7E7009C3931008C39
      3900734A4A007B6B6B009C9C9C00C6C6C600E7E7E700F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000DED6D600E7AD8C00F7AD8400F7B58C00F7B58C00EFAD8400C69C8400A58C
      7B00948484009C9C9400B5B5B500CECECE00E7E7E700EFEFEF00FFFFFF00FFFF
      FF00FFFFFF00EFEFEF00E7E7E700DEDEDE00949CA500425A84001852A5000884
      DE0000ADFF00108CD600848C9400DEDEDE000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004284A5000063
      A5000863B5000063B500105A840063737B00C6C6C600F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6B5B500AD4A4200CE6B
      3900CE6B3900BD5A3100B54A31008C423900734242007B63630094949400BDBD
      BD00DEDEDE00F7F7F70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FFEEEEEEFFDADADAFFF2F2F2FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000000000000000000000FFFF
      FF00D6B59C00EFA57B00FFD6C600FFEFE700FFDECE00FFCEB500F7BD9400F7B5
      8C00EFAD8400DEA58400A58C7B007B7B8C00848C9400A5A5A500C6C6C600D6D6
      D600CECECE008C9CAD00848C9C00636B8400314A7B00294A7B00315A8C002963
      A50000C6EF0000E7FF004A7B9400CECECE000000000000000000000000000000
      00000000000000000000000000000000000000000000D6D6DE000063A5001873
      CE002184D6002184D6001873CE000863AD00215A7B007B848400CECECE00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5A5A500C6735A00BD5A
      3900D66B3900D66B3900CE6B3900D66B3900CE6B3900C65A3100B54A31009442
      31007342420073636300948C8C00BDBDBD00DEDEDE00F7F7F700FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FFD7DCDFFF527D97FF66767FFFB6B6B6FFEDEDEDFF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000000000000000000000DED6
      CE00EF9C7300F7C6B500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7EF
      E700B5BDC60052BDCE0000DEF70000E7FF0000C6F70008A5DE00427BA5006373
      8C001084D60000A5FF00009CF700106BB50029528C003163A500397BBD004A8C
      D60031ADD60021FFFF00429CAD00D6D6D6000000000000000000000000000000
      000000000000000000000000000000000000000000006B9CB5000863B500298C
      D600319CDE00299CDE002994DE002184D6001873C6000063AD00315A73009494
      9400DEDEDE00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AD949400D6846300B55A
      4200D66B3900D66B3900D66B3900CE6B3900CE6B3900CE6B3900CE6B3900D66B
      3900D66B3900C65A3100BD4A31009C4231007B424200735A5A008C848C00BDBD
      BD00DEDEDE00F7F7F700FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF75A3BEFF2896E1FF1B7BBAFF4B6777FFA4A4A4FFDEDE
      DEFFFCFCFCFF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000FFFFFF00D6AD
      9C00F7AD8400FFEFEF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BDD6F7004AA5
      F70018E7F70000E7FF004ABDD6007BB5B5007BB5B5005AC6CE0008CEF700089C
      E700009CE70000C6F70000CEFF0000D6F7002184BD00427BC6004A9CE70052A5
      F7004A9CD6006BEFF7007394AD00EFEFEF000000000000000000000000000000
      00000000000000000000000000000000000000000000106B9C001873CE002994
      DE004A9CD600949CAD003994D6002194E700298CDE002184D600106BC6000063
      9C0042637300A5A5A500E7E7E700000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A58C8C00D68C6B00C66B
      5A00CE6B3900D66B3900CE6B3900D66B3900CE6B3900CE6B3900CE6B3900CE6B
      3900CE6B3900CE6B3900CE6B3900D66B3900D66B3900CE633900BD523100A542
      31007B42390073525A0084848400B5B5B500EFEFEF0000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FFF7F7F7FF3886B8FF2F98E0FF2692DDFF0E7AC3FF39657FFF8B8C
      8DFFCFCFCFFFF4F4F4FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000D6D6CE00E79C
      7300F7CEBD00FFFFFF00FFFFFF00FFF7EF00FFE7DE0094ADCE000084F70010CE
      FF0018DEF7008CA5AD00FFA57300FFB58400FFAD8400FFA57B00DEA5840052C6
      CE0000A5F700007BE70000D6FF0000DEFF004ADEF7004A9CEF004A94E700427B
      BD00396B9C00739CC600E7E7EF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000BDC6CE000063A5002984D600219C
      E700D6A59400FFF7EF00FFDEC600ADA5A5003194D6002194DE00218CD600187B
      CE00086BBD00085A9400526B7300B5B5B500F7F7F70000000000000000000000
      00000000000000000000000000000000000000000000AD848400DE8C7300D68C
      7300C6634200D67B4A00D6734A00D6734200CE6B4200CE6B3900CE6B3900CE6B
      3900CE6B3900CE6B3900CE6B3900CE6B3900CE6B3900BD633100C6633100D66B
      3900D66B3900CE633900BD523100A54231009C7B7B0000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FFB8C6CEFF238CD0FF2E98E0FF2A82C4FF437BB2FF0F7DCCFF1E6A
      9AFF64727AFFACACACFFDEDEDEFFF8F8F8FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000DEBDAD00EF94
      6B00FFF7F700FFFFFF00FFFFFF00FFC6AD00D6948400218CDE0000A5FF0021EF
      FF0042B5D600EF947300FF9C7300FFAD8400FFBD8C00FFBD9400FFB58400EFA5
      7B0039C6DE00009CEF0039C6E70010E7FF0042DEFF00429CD60029639C003152
      8400949CAD00E7E7E70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005A8CAD00106BBD003194DE0039A5
      DE00FFC69C00FFF7EF00FFEFD600FFF7EF00FFD6BD00A59CA500298CD6002194
      DE00218CD6001873CE000863B500105A8C006B737B00C6C6C600F7F7F7000000
      00000000000000000000000000000000000000000000A57B7300DE947B00EFA5
      8C00BD634A00DE8C6300D6845A00D6845A00D67B5200D67B5200D6734A00CE6B
      4200CE6B3900CE6B3900CE6B3900CE6B3900C66B3900C66B4200AD5A2900BD5A
      3100CE6B3900CE6B3900CE6B3900CE633100AD523900FFF7F700000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF6C99B3FF309AE0FF1E8FDCFF8197AEFFF9D8B5FF8B96AAFF1A79
      C5FF0973BAFF376580FF808588FFB9B9B9FFE2E2E2FFF7F7F7FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF00000000FFFFFF00E7947300F7AD
      9400FFFFFF00FFFFFF00FFF7EF00FFC6AD008CA5BD0000ADFF0008C6FF0021EF
      FF008C94AD00FF8C6B00FF946B00FF8C6B00FF946B00FF947300FF9C7B00FFA5
      7B00DEA5840031C6E7001094E70000C6EF0000D6FF002194BD0094848400B5AD
      AD00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F7F7F70000639C00217BD600319CE70094A5
      B500FFE7D600FFEFDE00FFEFD600FFE7CE00FFE7D600FFF7E700FFD6BD009C9C
      A500298CD600188CDE002184D6001073CE000063B500215A7B007B848400D6D6
      D600FFFFFF00000000000000000000000000000000009C6B6B00DE9C8400EFAD
      8C00BD6B5A00DE946B00DE8C6B00DE8C6300DE8C6300D6845A00D6845A00D684
      5200D67B5200CE734200CE6B3900C66B3900D67B5200D67B5200CE734200B563
      3100B55A3100BD633100C6633900C6633100C66B4200DEC6C600000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FFEAEBECFF388FC4FF369FE5FF2488D0FFCABBB2FFFFE0C1FFFFD7B5FFCDB8
      ADFF5283B3FF0E7ACAFF0A6DACFF3D6780FF7C8386FFABABABFFD2D2D2FFE7E7
      E7FFF3F3F3FFFCFCFCFF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF00000000EFE7DE00E7846300F7CE
      C600FFFFFF00FFFFF700FFE7D600FFBDA50063A5CE0000BDFF0008D6FF0021EF
      FF00A594A500FFA57300FF946B00FF8C6B00FF8C6B00FF946B00FF946B00FF94
      6B00FF946B0084B5AD0000A5F700009CE70000ADFF0073A5BD00C6AD9C00E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A5B5BD000063AD00318CDE0029A5EF00E7B5
      9400FFFFF700FFEFDE00FFEFDE00FFEFD600FFE7CE00FFE7CE00FFE7C600FFF7
      E700FFD6BD009C94A500218CD600188CDE001884D600106BC6000063AD00315A
      73009C9C9C00F7F7F7000000000000000000000000009C6B6300E7A58C00EFAD
      9400D68C7300D6846B00DE9C7B00DE947300DE946B00DE8C6B00DE8C6300DE8C
      6300DE846300D6845A00CE7B5200D67B5200D67B5200D67B5200D67B5200CE73
      4200BD633900C66B3900BD633100B55A2900C6734200B5635200000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FFB0C0C9FF2C93D2FF2F9FE7FF4C8CBEFFFBD8BFFFFED1B8FFFCC0A3FFFFCD
      ACFFFFD5B5FFB5ABABFF4C82B4FF0E76C6FF086DB2FF25668EFF506C7EFF7884
      8BFF9C9D9FFFC2C2C2FFEDEDEDFF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF00000000CEB5AD00EF8C6B00FFEF
      E700FFFFF700FFFFF700FFC6B500FFB59C0063B5CE0000DEFF0000EFFF0029F7
      FF0084A5BD00FFD6A500FFE7BD00FFD6AD00FFBD9400FFA57B00FF947300FF94
      6B00FF8C6B00E79C7B0000C6FF000884DE00638CC600BDA59400E7E7E700FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000397BA5001873C600319CE7005AA5DE00FFCE
      AD00FFFFF700FFF7E700FFEFDE00FFEFDE00FFE7D600FFE7CE00FFE7CE00FFDE
      C600FFDEBD00FFEFDE00FFD6BD009494A5002184D600188CD600187BCE00106B
      C600105A8C00A5A5A5000000000000000000000000009C635A00E7AD9400EFB5
      9C00EFAD9400BD6B5A00E7AD8C00DEA58400E79C7B00DE9C7B00DE9C7300DE94
      7300DE946B00D68C6B00DE947300DE947300DE8C6300D67B4A00D67B4A00D67B
      4A00CE734200BD633900CE734200CE6B4200BD633900BD6B4200BDADAD000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF669CBBFF38A3E7FF2698E3FF91A0B3FFFFEACFFFFCC4ABFFFBC3A9FFFCC5
      AAFFFEBE9FFFFFCEA9FFFBCFAEFFC4AFA8FF718BACFF317BBDFF0E73C0FF036E
      B6FF10649DFF4F6978FFACACACFFE8E8E8FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFFFFFFF00D69C8400EF9C7B00FFF7
      F700FFF7F700FFFFF700FFAD8C00FF9473007BA5AD0000EFFF0008FFFF0031FF
      FF005AADD600EFC69C00FFFFCE00FFF7CE00FFEFBD00FFE7B500FFCEA500FFBD
      8C00FF9C7B00FF946B0010C6F7006B9CC600E7AD8C00B5ADA500FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EFEFEF0000639C00298CDE0039A5EF00ADADAD00FFEF
      E700FFF7F700FFE7CE00FFEFE700FFEFDE00FFEFDE00FFE7D600FFE7CE00FFDE
      C600FFDEC600FFDEBD00FFD6BD00FFEFDE00FFCEB5008C8CA5001884D6001884
      D6000863BD0063737B00FFFFFF000000000000000000B5635A00E7AD9C00EFB5
      9C00EFB59C00BD6B5A00E7B59C00E7AD9400E7AD8C00E7AD8C00E7A58400E7A5
      8400DE9C7B00DEA58400E7A58400DE9C7B00DE9C7B00DE9C7300D6845A00D67B
      4A00D67B4A00D6734A00BD633100CE734200D67B4A00CE734200944A4200A5A5
      A500E7E7E700000000000000000000000000000000FF000000FF000000FFEDEE
      EFFF2F8AC0FF2590D9FF2384CAFFD1C2BCFFFFEED8FFFFE2C8FFFDD0B6FFFCBF
      A4FFFED5BBFFFDC9ADFFFEBA9AFFFFCAA6FFFFDBB3FFEFC3A5FFC1ABA2FF9D9C
      A6FF5C80A5FF0670B8FF44657BFF9F9F9FFFDFDFDFFFFCFCFCFF000000FF0000
      00FF000000FF000000FF000000FF000000FFE7E7E700E78C6B00EFB5A500FFFF
      F700FFF7EF00FFF7F700FFDECE00FFB59C00BDADA50021E7F70029FFFF0039FF
      FF0039DEF700A5A5AD00FFEFBD00FFF7CE00FFEFC600FFE7B500FFDEAD00FFD6
      A500FFBD8C00F7A57B0008CEF7007BA5BD00BD9C8C00DEDEDE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008CA5B500086BB500319CE70039ADEF00F7BD9C00FFFF
      FF00FFF7F700FFEFDE00FFDEBD00FFDEC600FFEFDE00FFEFDE00FFE7D600FFE7
      CE00FFDEC600FFDEBD00FFD6BD00FFD6B500FFD6B500FFEFD600F7B59C001884
      D6000863BD0073848C00000000000000000000000000AD5A5A00E7B59C00EFBD
      A500EFBDA500CE847300E7AD9C00EFBDA500E7B59C00E7B59C00E7B59400E7AD
      9400E7AD9400E7B59400E7AD8C00E7AD8C00DEA58C00E7A58400E7A58400DE9C
      7300DE845A00D67B4A00D6734200BD633100C66B4200D67B4A00CE6B4A00AD73
      630073636300A5A5A500E7E7E70000000000000000FF000000FF000000FFA6BA
      C6FF2A91D4FF9C6261FFAB716BFFF4E2D1FFFEE9D7FFFFEDD9FFFFE4CBFFFFDC
      C2FFFFDEC5FFFFE4CDFFFFDCC2FFFED2B5FFFFDABCFFFFDCB9FFFFDCB4FFFFD4
      A7FFFEBD91FF8597ACFF0471BEFF306383FF898B8CFFC9C9C9FFEFEFEFFFFEFE
      FEFF000000FF000000FF000000FF000000FFD6D6CE00E77B5A00F7CEBD00FFF7
      F700FFF7EF00FFF7EF00FFE7DE00FFBDA500E7B5A50052CEDE004AFFFF005AFF
      FF0052FFFF0042BDE700EFBD9400FFE7B500FFEFBD00FFE7B500FFDEA500FFCE
      9C00FFAD8400D6A58C0000CEFF0094A5AD00B5ADAD00F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021739C00187BCE0039A5E70073B5D600FFDEC600FFFF
      FF00FFFFF700FFFFF700FFF7EF00FFF7E700FFDEC600FFD6BD00FFE7CE00FFE7
      D600FFE7CE00FFDEC600FFDEBD00FFDEBD00FFD6B500FFD6B500E7BDB500107B
      D6000063AD00BDBDBD00000000000000000000000000AD5A5200EFBDA500EFC6
      AD00EFBDA500E7AD9C00CE8C7B00EFCEB500EFC6AD00EFBDAD00E7BDA500E7BD
      A500EFBDA500E7BDA500E7B59C00E7B59C00E7B59C00E7B59400E7AD9400E7AD
      8C00E7AD8C00E7A58400DE946B00D6845A00BD633100C66B3900D67B4200CE84
      6B00FFD6AD00B5846B0073636300CECECE00000000FF000000FF000000FF5997
      BBFF578BB9FFE86D42FFFDA07CFFFFEFDFFFFCC5ACFFFDD0B8FFFFE8D6FFFFE8
      D3FFFFDFC4FFFFDCBFFFFFDCC1FFFFDDC2FFFFDBBEFFFFD9BAFFFFD9B9FFFEC7
      A4FFFFC5A2FFFFC59BFFA7A2A7FF1E7AC1FF16679DFF586E7AFF9F9F9FFFCDCD
      CDFFECECECFFF9F9F9FFFDFDFDFF000000FFE7C6BD00DE6B4A00FFE7DE00FFF7
      EF00FFF7E700FFDECE00FFDECE00FFC6AD00FFBD9C00BDADAD0063EFF70084FF
      FF008CFFFF005AFFFF0042B5DE00C6A59C00FFC69400FFCE9C00FFC69400FFB5
      8400EF9C7B0052BDCE0018CEEF00A5948C00D6D6D600FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6D6DE000063A5003194DE0039ADEF00C6B5AD00FFF7EF00FFFF
      FF00FFDEC600FFEFDE00FFFFF700FFF7EF00FFF7EF00FFEFE700FFE7C600FFE7
      D600FFE7CE00FFDECE00FFDEC600FFDEBD00FFD6B500FFEFD600848CA5001073
      CE0029638C00F7F7F700000000000000000000000000AD5A5200EFC6AD00EFC6
      B500EFC6AD00F7C6AD00BD736300F7D6C600F7D6C600EFCEBD00EFCEBD00EFCE
      BD00EFC6B500EFC6AD00EFC6AD00E7BDA500E7BDA500EFBDA500EFBD9C00E7B5
      9C00E7B59400E7AD9400E7AD8C00E7AD8C00E7A58400CE8C6300CE7B5200BD63
      4200FFCEAD00FFDEB500DE9C7B00D6D6D600000000FF000000FFDEE0E2FF2B94
      D1FF928490FFF7895AFFFAD0BBFFFDDDCDFFFCC8B1FFFCCBB4FFFCC1A7FFFDCC
      B4FFFEE0CBFFFFE6CEFFFFDFC4FFFFD9BBFFFFD9B9FFFFD7B7FFFFD6B6FFFDC4
      A3FFFDC1A0FFFCAF8DFFFFC39AFFD6B9A7FF538BBBFF0A74BDFF206593FF5770
      7FFF8D9092FFACACACFFCDCDCDFFF1F1F1FFE7B5A500DE6B4A00FFF7EF00FFF7
      E700FFEFE700FFC6AD00FF9C7B00FF9C7B00FFA57B00F7AD8C008CB5C60094F7
      FF0094FFFF007BFFFF0042F7FF0039CEEF0084A5B500C69C9400D69C8C00BD9C
      94004ABDD60000EFFF0063A5B500AD8C8400EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007394AD001073B500399CE7004AB5EF00FFCEA500FFFFFF00FFFF
      FF00FFFFFF00FFEFDE00FFDEC600FFE7CE00FFF7E700FFF7E700FFEFE700FFEF
      DE00FFE7D600FFE7CE00FFDEC600FFDEBD00FFDEBD00FFDEC6002984C600086B
      BD007B8C940000000000000000000000000000000000B55A5200EFCEB500F7CE
      B500F7C6B500EFC6AD00E7B5A500BD736300CE948400DEADA500EFCEBD00F7D6
      CE00F7D6C600EFD6C600EFCEBD00EFCEBD00EFC6B500EFC6AD00EFC6AD00EFBD
      AD00EFBDA500EFBD9C00EFB59C00E7B59400E7B59400E7AD9400DE9C8400D694
      7B00CE847300FFDEB5008C736B00FFFFFF00000000FF000000FF9EB8C7FF3695
      D1FFD6957CFFFAA780FFFEEADDFFFFEEDFFFFED5C2FFFCC4ADFFFCCEB6FFFDCF
      B8FFFCC0A5FFFCC0A5FFFED8BEFFFFE2C9FFFFDDC1FFFFDBBEFFFED0B0FFFECA
      AAFFFDCDADFFFCB797FFFCB393FFFFB994FFFFC6A4FFB7ADADFF588CB8FF1B78
      BCFF1571ADFF2B709AFF697B86FFDDDDDDFFDE9C8C00DE734A00FFFFFF00FFEF
      DE00FFEFDE00FFEFE700FFEFDE00FFDECE00FFB59C00FF9C7B00EF94730094A5
      AD0052EFF70042FFFF0029FFFF0029FFFF0021F7FF0018E7FF0008E7FF0000E7
      FF0018E7F70063B5C600E7947300A59C9C00F7F7F70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000106BA5002184D60042ADEF008CBDCE00FFE7CE00FFFFFF00FFFF
      F700FFFFFF00FFFFFF00FFFFFF00FFF7EF00FFE7CE00FFDEBD00FFE7CE00FFEF
      E700FFEFDE00FFE7D600FFE7CE00FFDEC600FFE7CE00CEB5AD001084D6000863
      A500D6D6D600000000000000000000000000FFFFFF00B5635A00F7CEBD00F7CE
      BD00F7CEBD00EFCEB500F7C6B500EFBDA500CEADA500E7CECE00BD949400C68C
      8C00C68C8400BD847B00CE948C00F7D6CE00EFD6C600EFCEBD00EFCEBD00EFCE
      B500EFC6B500EFC6AD00EFC6AD00EFBDA500EFBDA500EFBD9C00E7B59C00E7AD
      9400AD635200CE947B00D6D6D60000000000000000FF000000FF5799BFFF579D
      C9FFFFAB77FFFCC5A8FFFFF9F2FFFFEDDDFFFFE9D5FFFFE6D4FFFEDDCBFFFFEF
      DFFFFFE9D7FFFDD8C1FFFED9C1FFFFE2CAFFFFDEC5FFFFDFC3FFFECAABFFFED4
      B7FFFFE2C5FFFFD1B2FFFECFB2FFFDD5BBFFFEBB9BFFFFDFBFFFFCDDC2FFDEC5
      B6FF7B95BCFF1F93E4FF4F778DFFEBEBEBFFE7947B00E7846300FFF7F700FFEF
      DE00FFEFDE00FFEFDE00FFEFDE00FFEFE700FFEFDE00FFCEB500FFAD9400F7AD
      8C0094ADB50029D6E70000F7FF0000EFFF0000DEFF0008CEFF0018BDF70063CE
      E700CEE7F700EFBDA500D68C7300B5B5B500FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDC6CE000063A500399CE70042B5F700D6BDAD00FFFFFF00FFFFFF00FFE7
      D600FFDEC600FFE7D600FFFFF700FFFFFF00FFFFF700FFF7F700FFEFDE00FFDE
      BD00FFDEBD00FFE7D600FFE7D600FFE7C600FFEFDE006B8CAD001073CE00396B
      8C00F7F7F700000000000000000000000000FFFFFF00BD736300F7D6C600F7D6
      C600F7CEBD00F7CEBD00EFC6B500CEADA500F7F7F700F7F7EF00E7E7DE00DED6
      D600F7F7E700EFE7DE00D6BDB500C6847300F7E7D600F7DECE00EFD6C600EFD6
      C600EFD6C600EFCEBD00EFCEBD00EFCEB500EFC6B500EFC6AD00EFC6AD00EFBD
      A500DEA58C00846363000000000000000000000000FFE0E5E8FF3395C8FF2061
      CBFF835289FFFADBC8FFFFE1D1FFFEE0D1FFFFF2E5FFFFEBD8FFFFE6D1FFFFE5
      CFFFFFE7D3FFFFE8D5FFFFE7D2FFFFE3CBFFFFE0C7FFFFDDC3FFFDC9AAFFFCC7
      ABFFFED1B5FFFFE5CBFFFFDFC3FFFFE1C7FFFFE7D1FFFFE5D1FFFFE8D3FFFFF0
      DAFF8DA96FFF047099FF909CA6FFFAFAFAFFEF947B00EF8C6300FFBDA500FFBD
      A500FFCEAD00FFC6AD00FFD6C600FFE7D600FFEFDE00FFF7E700FFDEC600FFC6
      AD00FFBD9C00F7AD9C00A5A5AD007BA5C6006BA5CE008C8CAD00E7C6C600FFFF
      F700FFF7F700F7AD8C00B5847300CECECE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000528CAD001073C60042A5EF005ABDEF00FFD6B500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFF7F700FFE7CE00FFDEC600FFEFD600FFF7F700FFF7EF00FFF7
      EF00FFEFE700FFDEC600FFD6B500FFE7CE00FFD6BD00218CD600086BBD00949C
      A50000000000000000000000000000000000F7F7F700BD7B7300F7DECE00F7DE
      C600F7D6C600F7CEBD00CEB5AD00F7F7F700FFF7F700E7E7E700EFE7E700E7E7
      DE00DED6CE00EFE7DE00F7EFDE00D6B5AD00C6847B00F7DECE00F7E7DE00F7DE
      D600F7DED600F7DECE00F7DECE00F7D6C600F7D6BD00EFCEBD00EFCEB500E7C6
      AD00EFCEB500AD736B000000000000000000000000FF93ADBBFF3899D8FF133F
      E4FF505DE3FFFDEDDAFFFEDBC8FFFDCBB7FFFCCBB6FFFDDBCAFFFEE9D8FFFFEA
      D8FFFFE6D0FFFFE1C8FFFFDFC6FFFFE0C6FFFFE1C7FFFED7BBFFFDCBAFFFFCC3
      A6FFFBBB9DFFFCC5ABFFFEE0CAFFFFE5CEFFFFDEC5FFFFE2C9FFFFE8D5FFFCDE
      C4FF3AA73CFF1D6981FFCECECFFF000000FFD6C6BD00EF9C8400F7BD9400FFBD
      9C00FFAD8C00F79C7300FF9C7300FFA58400FFBD9C00FFCEB500FFE7D600FFEF
      DE00FFDECE00FFD6BD00FFCEB500FFD6C600FFE7DE00FFEFDE00FFF7E700FFF7
      EF00FFEFEF00EFA57B00AD8C7B00DEDEDE000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7F7
      F70000639C002994DE004AB5F700A5C6CE00FFEFDE00FFFFFF00FFE7CE00FFEF
      E700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7EF00FFDEC600FFDEC600FFEF
      D600FFF7EF00FFEFE700FFEFDE00FFF7E700B5ADAD001884DE0010639C00E7E7
      E70000000000000000000000000000000000EFEFEF00C6847B00F7DECE00F7DE
      CE00F7DECE00D6B5AD00F7EFEF00FFFFFF00FFFFFF00FFFFF700EFE7E700F7EF
      E700E7DED600DED6CE00E7DED600F7EFDE00D6BDB500C6948400BD7B7300CE94
      8400CE8C8400C68C8400D6A59400E7BDAD00EFCEC600F7DECE00EFD6C600F7D6
      CE00EFD6C600D6A59400F7F7F70000000000FAFAFAFF579BBEFF3985D9FF2C4E
      EEFFAFA7D6FFFFFDEFFFFDD1C0FFFCCCB7FFFCD1BEFFFCCEB8FFFCC4ADFFFCCA
      B2FFFDD7C2FFFFE7D5FFFFE5CFFFFFE1C9FFFFE2C7FFFECDB1FFFFDCC3FFFDD4
      BBFFFCBFA4FFFCC6ACFFFCBEA4FFFDCCB4FFFFE8D6FFFFE6D1FFFFE7D7FFD1D6
      9CFF14975CFF597892FFEDEDEDFF000000FF00000000F7EFEF00FFFFF700FFF7
      EF00FFDECE00F7C6A500EF9C7B00EF846300EF846300FF947300FF9C7B00FFA5
      8400FFBD9C00FFD6BD00FFE7D600FFEFDE00FFF7E700FFF7E700FFF7E700FFF7
      EF00FFE7DE00EF947300A5948C00E7E7E7000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A5B5
      BD00086BAD0042A5EF0042BDFF00EFCEAD00FFFFFF00FFFFFF00FFFFFF00FFEF
      E700FFDEC600FFDEC600FFEFDE00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFEF
      DE00FFDEC600FFDEBD00FFEFD600FFEFE7006394BD00107BCE0052738C00FFFF
      FF0000000000000000000000000000000000EFE7E700CE8C8400FFE7D600FFE7
      D600DEC6BD00EFE7E700FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFF7
      F700F7E7DE00DED6CE00E7D6CE00EFDECE00FFEFDE00DECEBD00EFD6C600DECE
      B500FFE7CE00F7D6BD00D6B59C00D6A58C00D6947B009C524200CE8C7B00BD7B
      6B00C6847B00C68C7B00EFDEDE0000000000D1D5D8FF3B9FD3FF4374DBFF6477
      EEFFEEDAD9FFFFFCF5FFFFF9F1FFFEEDE3FFFDD5C4FFFFEBDFFFFFF1E6FFFEE0
      CFFFFDD4BFFFFFE8D6FFFFE9D7FFFFE8D4FFFEE2CCFFFDCCB3FFFFE3CEFFFFE7
      CFFFFEDEC5FFFFE4D1FFFFEBDAFFFDD7C4FFFFE8D8FFFFEEE2FFFFEBE2FF93CA
      76FF0A7C80FF989FA8FFFDFDFDFF000000FF00000000FFFFFF00FFEFDE00FFF7
      EF00FFFFFF00FFFFF700FFEFE700F7BDAD00E76B4A00F7A58400FFD6BD00FFCE
      B500FFB59C00FFA58400FF9C7B00FFA58C00FFC6AD00FFDECE00FFEFE700FFF7
      EF00FFDED600EF8C6B00A59C9400EFEFEF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000397B
      A500187BCE004AADF7006BC6EF00FFDEBD00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFF7EF00FFE7CE00FFDEC600FFEFDE00FFFFF700FFFF
      F700FFFFF700FFF7EF00FFEFE700F7CEBD002194DE00086BB500ADADB5000000
      000000000000000000000000000000000000F7EFEF00C68C8400FFE7D600FFE7
      D600DECED600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFF7
      EF00FFF7EF00FFEFE700E7DECE00DED6C600DECEBD00FFE7D600DEC6B500EFD6
      BD00DEC6B500FFDEC600F7D6BD00FFE7BD00B5846B00D6C6AD00FFE7C6009484
      7B0000000000FFFFFF0000000000000000008EB1C4FF45A8E4FF6C89E9FFB0A9
      DDFFFFF2E6FFFDDACBFFFEE6D6FFFFF2E4FFFFF5EAFFFFF2E8FFFFF2E8FFFFF2
      E7FFFFF2E4FFFFECDCFFFFE9D8FFFFE9D6FFFEDAC3FFFDD2BBFFFDC7AFFFFDD7
      C2FFFFEBD7FFFFE7D1FFFFE8D4FFFFEFE1FFFFF0E3FFFFF4E8FFEEDACCFF4B96
      B0FF2F759FFFCFCFD0FF000000FF000000FF0000000000000000F7F7F700EFDE
      CE00FFF7F700FFF7EF00FFEFDE00FFFFFF00EF947300F7A58400FFDEBD00FFE7
      CE00FFEFD600FFEFD600FFE7CE00FFCEB500FFB59400FFAD8C00FFEFDE00FFF7
      EF00F7D6C600E7846300ADA5A500F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7E7E7000063
      9C00319CE7004ABDF700B5C6C600FFF7E700FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7EF00FFE7CE00FFDE
      C600FFE7D600FFF7EF00FFFFF700A5ADAD00218CDE0018639400EFEFEF000000
      000000000000000000000000000000000000FFFFFF00B56B6300F7E7D600FFE7
      DE00F7E7D600E7D6D600FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFF7
      F700FFF7EF00FFF7EF00F7EFDE00E7D6CE00DECEC600E7D6C600FFE7D600E7CE
      BD00E7CEBD00DEC6AD00FFE7C600BD8C7B00DEC6AD00FFE7CE00CEA58C00DEDE
      DE0000000000000000000000000000000000519AC3FF5CC4FCFF5888DAFFD7C2
      D0FFFFF3E9FFFDD4C6FFFCCCBCFFFDD1BEFFFEDCCAFFFFE5D3FFFFEAD8FFFFEB
      D9FFFFE8D7FFFFEAD9FFFFE7D5FFFFE8D6FFFDD4BEFFFDD6C1FFFCC1A8FFFBC1
      A9FFFCC5AEFFFEDECCFFFFEAD8FFFFE6D2FFFFE6D3FFFFF3DFFFC0BCBFFF2E95
      DFFF608194FFF1F1F1FF000000FF000000FF000000000000000000000000F7EF
      EF00FFE7D600FFFFF700FFF7EF00FFFFFF00F7A58400F7A58400FFD6BD00FFE7
      CE00FFE7CE00FFE7CE00FFE7D600FFE7D600FFE7D600FFE7D600FFEFDE00FFF7
      EF00F7CEBD00DE7B5A00B5B5AD00F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000849CAD000873
      B50042ADEF004ABDFF00F7CEAD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFF7EF00FFEFE700FFEFDE00529CCE00187BCE006B848C00000000000000
      00000000000000000000000000000000000000000000A5736B00EFD6C600FFEF
      DE00FFEFDE00F7E7D600DECECE00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFF
      F700FFF7EF00FFF7EF00FFF7E700FFEFDE00E7D6CE00E7D6C600F7DECE00FFE7
      D600E7CEB500FFE7CE00C6948400C6AD9C00FFE7CE00FFE7CE0094847B000000
      00000000000000000000000000000000000041A0D1FF65D1FFFF5FB7E6FFEADB
      D6FFFFF0E8FFFDCEBCFFFDD3C3FFFCD5C6FFFDD3C3FFFCCAB7FFFCC9B3FFFED7
      C4FFFFEBDCFFFFE6D3FFFFE5D0FFFFE4CFFFFDD3BDFFFFF1E0FFFDDCCBFFFCC7
      B1FFFDDDCCFFFCC8B3FFFDD0BCFFFFF3EAFFFFF1E6FFFFF0DEFF83A5C3FF1D88
      C7FFA3A9ADFFFCFCFCFF000000FF000000FF0000000000000000000000000000
      0000E7E7E700FFE7D600FFFFFF00FFFFFF00F7BD9400FFAD8400FFD6B500FFDE
      C600FFDEC600FFE7C600FFE7CE00FFE7CE00FFE7CE00FFE7D600FFE7D600FFFF
      F700F7BDAD00D67B5A00BDBDBD00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000216B9C002184
      D6004AB5F70084C6E700FFEFCE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7CEBD00299CE700086BAD00C6C6C600000000000000
      00000000000000000000000000000000000000000000DED6D600CE847B00F7E7
      D600FFE7DE00FFEFDE00FFE7D600DECECE00FFFFFF00FFFFFF00FFFFF700FFFF
      F700FFF7EF00FFF7EF00FFF7E700FFEFE700FFEFDE00E7D6C600DECEBD00EFD6
      C600FFEFD600D6A59400CEB5A500E7D6C600FFE7CE00CEA59400DEDEDE000000
      00000000000000000000000000000000000070A7C8FF4CB1E4FF60C9FBFF99C1
      DAFFE5D8D6FFFEF3EBFFFFE8DCFFFFE2D4FFFFFFFBFFFFF9F2FFFEEBE1FFFEEA
      DEFFFFF2E7FFFFEFE2FFFFF0E3FFFEDFCBFFFDD5C3FFFED8C2FFFFEBD8FFFFEF
      E2FFFFF4EBFFFFF8F0FFFFF1E7FFFFF4ECFFFFFBF4FFF2DDD3FF4F9DD4FF367C
      A4FFD6D6D6FF000000FF000000FF000000FF0000000000000000000000000000
      0000FFFFFF00F7EFE700FFF7E700FFFFFF00FFC6A500FFAD8400FFCEAD00FFDE
      BD00FFDEBD00FFDEC600FFDEC600FFDEC600FFE7CE00FFE7CE00FFE7CE00FFF7
      F700EFB59C00CE735200BDBDBD00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00085A94002994
      E7004AB5F700B5CED600B5ADAD00BDBDBD00DEDEDE00F7F7F700FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0094ADB500298CE70029638C00F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000B5848400BD63
      6300C67B7B00CE948C00DEADA500EFC6B500DEC6BD00FFFFFF00FFFFFF00FFF7
      F700FFF7F700FFF7EF00FFF7E700FFEFE700FFEFDE00FFEFDE00E7D6C600FFE7
      CE00DEB5A500CEB5A500FFEFDE00FFEFD600FFE7D60094848400000000000000
      000000000000000000000000000000000000FDFDFEFFA5C4D8FF529AC4FF39A7
      E1FF5AB8ECFF87BCDFFFB9C8D6FFDDD9D9FFF8E7DDFFFFF4E7FFFFF8ECFFFFF9
      ECFFFFF8EAFFFFF5E7FFFFF7E6FFFFDCC7FFFDD9C7FFFBC4AEFFFCC8B2FFFED8
      C2FFFFECDBFFFFF2E6FFFFF4EBFFFFF6EFFFFFFFF6FFBABCC5FF319DDEFF6C86
      94FFF3F3F3FF000000FF000000FF000000FF0000000000000000000000000000
      00000000000000000000EFE7DE00FFFFFF00FFCEAD00FFB59400FFD6BD00FFDE
      BD00FFD6B500FFD6B500FFDEBD00FFDEBD00FFDEC600FFDEC600FFE7C600FFF7
      EF00EFAD9C00C6735200BDBDBD00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000528CB5000873
      BD0039A5EF0063BDEF00ADA59C00B5B5B500BDBDBD00ADADAD00ADADAD00BDBD
      BD00D6D6D600EFEFEF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFE7D6004AA5DE00187BCE00848C940000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7F7F700D6CECE00BDADAD00A58C8C00A5737300AD949400FFF7EF00FFFF
      F700FFF7EF00FFF7EF00FFF7EF00FFF7E700FFEFDE00FFEFDE00FFEFDE00E7C6
      B500C6ADA500FFF7E700FFEFDE00FFEFDE00CEA59C00E7E7E700000000000000
      000000000000000000000000000000000000000000FF000000FFF4F7F9FFB4CF
      DEFF63A2C6FF3598CFFF39A5E0FF52ADE2FF71B3DCFF94B9D4FFABC0D1FFBEC6
      CFFFCDCBCDFFD9CFCDFFD1C5C3FFDFC0B3FFFFE7D4FFFFCCB7FFFCCCB9FFFCCF
      BDFFFCC5AEFFFEDAC8FFFFF0E3FFFFEFE2FFFFEFDFFF82ADCDFF2A8EC7FFA5A9
      ACFF000000FF000000FF000000FF000000FF0000000000000000000000000000
      00000000000000000000F7F7F700E7E7E700F7AD8C00F7A58400FFDED600FFF7
      EF00FFF7E700FFE7CE00FFDEBD00FFD6B500FFDEBD00FFDEBD00FFDEC600FFF7
      F700EF9C8400C66B5200BDBDBD00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF006B9C
      BD00106BAD000873C60073A5C600BDB5B500C6BDB500C6C6C600D6D6D600CECE
      CE00BDBDBD00B5B5B500ADADAD00BDBDBD00D6D6D600EFEFEF00FFFFFF00FFFF
      FF00FFFFFF00D6C6BD00319CEF00086BA500D6D6D60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFE7E700EFE7
      E700FFFFF700FFF7EF00FFF7EF00FFEFE700FFEFDE00FFEFDE00EFD6C600C6A5
      9C00FFF7EF00FFF7E700FFEFDE00FFEFDE00948C8C0000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FFE9F0F4FFA8C7D9FF74ABCBFF4F9AC5FF3D97CCFF2F94CEFF2C90
      CEFF2B90CFFF2C90CFFF197EBCFF3B91C5FFB6C4D0FFF0DED2FFFFE5D3FFFFFF
      FBFFFFF7F1FFFFEEE8FFFFFDFAFFFFFFFDFFE5D8D4FF57AADEFF3E7B9EFFD9D9
      D9FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      000000000000000000000000000000000000D6AD9C00EF8C6B00DE5A3100DE63
      4200EF9C8400F7C6B500FFE7DE00FFEFEF00FFEFE700FFE7D600FFDEC600FFF7
      F700E7947300C66B4A00BDBDBD00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00CED6D6008CADBD005294BD004A8CB500BDB5B500D6D6D600DEDE
      DE00DEDEDE00DEDEDE00D6D6D600CECECE00C6C6C600B5B5B500B5B5B500BDBD
      BD00E7DED6008CB5C6002994E700426B8400F7F7F70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7EF
      EF00EFDED600FFFFF700FFF7EF00FFEFE700FFEFE700F7E7D600C6A59C00FFF7
      EF00FFF7EF00FFEFE700FFF7E700CEADA500E7E7E70000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFF9FAFCFFE5EDF2FFD3E3ECFFC8DC
      E8FFBBD2E1FFBDD1DEFFC5D4DDFF6FAACBFF2B93CFFF67B0DCFFAFC7D8FFE8DA
      D5FFFFF0E6FFFFFCF4FFFFFDF9FFFFFEF8FFBCBDC6FF3CA8E4FF6D8796FFF4F4
      F4FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      000000000000000000000000000000000000F7F7F700DEDED600EFBDB500E794
      8400DE6B4A00DE523100DE6B4A00E7846300EFB5A500F7D6CE00FFF7F700FFEF
      EF00E7735200C66B4A00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CECECE00D6D6D600E7E7
      E700E7E7E700E7E7E700DEDEDE00DEDEDE00CECECE00CEC6C600C6BDBD00B5AD
      A500ADB5BD0042ADEF00107BC600A5ADAD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7F7F700DECEC600FFFFF700FFF7E700FFEFE700AD8C8C00D6BDBD00F7E7
      DE00FFFFF700FFF7EF00FFEFE7009C8C8C000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFC8DAE6FF64A3C7FF3999CEFF4AA6
      DAFF78B6DAFFA0C3DBFFBFCDDAFFC9CFD5FF81C6EBFF2F91C6FFBFC1C4FFFEFE
      FEFF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00F7E7E700CEADA500D68C7B00DE735200DE634200DE634200DE63
      3900DE633900CE735A00DEDEDE00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFEFEF00DEDEDE00CECE
      CE00CECECE00CECECE00D6D6D600CECECE00B5B5B500528CB500528CAD003984
      B500107BCE000873BD005284A500FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFF7F700D6BDB500FFFFEF00AD949400FFFFFF0000000000F7EF
      EF00D6BDB500F7E7DE00C6ADA500E7E7E7000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FFD9E5EDFFA5C6
      DAFF6CA9CBFF519DC7FF4499C8FF3E9ACCFF479CC9FF91AFC1FFFAFAFAFF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00E7DEDE00EFD6CE00EFAD9C00E78C
      7300DE7B5A00D6ADA500F7F7F700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00F7F7F700F7F7F700EFEFEF00FFFFFF000000000000000000E7EF
      F700D6DEE700DEE7EF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00CEB5AD00F7F7F70000000000000000000000
      000000000000F7EFEF00DED6D600000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      00000000000000000000F7F7F700CECECE00ADADAD00ADADAD00BDBDBD00E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EFEFEF00BDBDBD00BDBDBD00BDBDBD00BDBDBD00CECE
      CE00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7F7F700D6D6
      D600A5A5A500A5A5A500BDBDBD00D6D6D600E7E7E700EFEFEF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6D6D6007B7B7B00A5A5A500B5B5B500B5B5B5008C8C8C006B6B
      6B00BDBDBD00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000009C9C9C00A5A5A500ADADAD00ADADAD00A5A5A5007373
      7300F7F7F7000000000000000000000000000000000000000000000000000000
      0000FFFFFF00E7E7E700D6D6D600D6D6D600DEDEDE00EFEFEF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CECECE00635A
      5A004A4A4A004A4A4A005A5A5A00737373008C8C8C00ADADAD00C6C6C600DEDE
      DE00EFEFEF00F7F7F700FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D6D6D6009C9C9C00DEDEDE00E7E7E700E7E7E700E7E7E700E7E7E700C6C6
      C6006B6B6B00C6C6C60000000000000000000000000000000000000000000000
      000000000000E7E7E700ADADAD00E7E7E700EFEFEF00E7E7E700DEDEDE007373
      7300D6D6D600000000000000000000000000000000000000000000000000E7E7
      E70094949C005A637B0042526B004A526B006B6B7B00ADADAD00EFEFEF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00EFEF
      EF00CECECE00CECECE00E7E7E700F7F7F700FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF009C9494009C52
      10008C390800633110004A3129003939390042424200525252006B6B6B008484
      84009C9C9C00BDBDBD00CECECE00E7E7E700EFEFEF00F7F7F700FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000094949400DEDEDE00E7E7E700DEDEDE00B5B5B500C6C6C600E7E7E700E7E7
      E700B5B5B5007B7B7B00FFFFFF00000000000000000000000000000000000000
      000000000000B5B5B500CECECE00EFEFEF00EFEFEF00EFEFEF00E7E7E7009494
      9400B5B5B5000000000000000000000000000000000000000000C6C6CE005263
      840021427300294A7B0029528400295A8C0029427B00525A6B00B5B5B500EFEF
      EF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00F7F7F700C6C6C600B594
      8C00B58C7B009C847B009C9C9C00BDBDBD00DEDEDE00F7F7F700FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF008C848400B55A
      0800AD390000A53900009C3900008C2900007329080052312100423131003939
      39004A4A4A005A5A5A00737373008C8C8C00ADADAD00C6C6C600DEDEDE00EFEF
      EF00F7F7F700FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00ADADAD00E7E7E700DEDEDE0084848400EFEFEF00CECECE00B5B5B500E7E7
      E700D6D6D6006B6B6B00EFEFEF00000000000000000000000000000000000000
      0000000000009C9C9C00DEDEDE00E7E7E700EFEFEF00EFEFEF00E7E7E700ADAD
      AD0084848400FFFFFF00000000000000000000000000CECECE0039527B00294A
      7B0029528400315A940031639C003973AD0031639C002142730063637300BDBD
      BD00F7F7F7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F7F7F700CECECE00BD9C9400F7B59400FFDE
      BD00FFE7C600FFD6BD00EFAD9400BD8C7B008C7B7B009C949400BDBDBD00DEDE
      DE00F7F7F700FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF007B7B7300B55A
      1000A5390000C67B4A00E7BD9C00D68C6300BD633100AD420800943100007B31
      08006B3110004A3121003939390042424200525252006B6B6B00848484009C9C
      9C00BDBDBD00D6D6D600EFEFEF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      DE00B5B5B500E7E7E700CECECE0073737300F7F7F70000000000A5A5A500E7E7
      E700DEDEDE0073737300E7E7E700000000000000000000000000000000000000
      000000000000A5A5A500DEDEDE00E7E7E700E7E7E700E7E7E700E7E7E700C6C6
      C60073737300F7F7F7000000000000000000EFEFEF0052638C00315A8C003163
      9C00396BA5003973B500397BBD004284CE00427BBD00294A7B00294273006B73
      7B00CECECE00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00E7E7E700BDB5AD00D6A58C00FFCEB500FFE7CE00FFDE
      C600FFDEC600FFE7CE00FFE7D600FFDECE00F7C6AD00A5847B005A636B008C84
      8400B5B5B500CECECE00EFEFEF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00847B7300C663
      10009C310000CE8C6300FFF7DE00FFEFCE00FFDEBD00F7CEAD00E7AD8400CE7B
      4A00B5521800A54208008C310000732900005231180042313100393939004A4A
      4A005A5A5A007B7B7B00B5B5B500EFEFEF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6D6
      D600BDBDBD00DEDEDE00DEDEDE007B7B7B008C8C8C0094949400B5B5B500E7E7
      E700DEDEDE007B7B7B00DEDEDE00000000000000000000000000000000000000
      0000F7F7F700A5A5A500DEDEDE00E7E7E700E7E7E700E7E7E700DEDEDE00CECE
      CE0073737300EFEFEF0000000000000000009CA5B500315A94003973AD003973
      B500427BC6004284CE00428CD6004A94DE004284CE0029528400294A7B00314A
      6B0084848400D6D6D600FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00EFEFEF00BDBDB500CE9C8C00FFC6AD00FFE7D600FFE7D600FFE7CE00FFDE
      C600FFDEC600FFE7D600FFEFDE00FFEFDE00FFEFDE008494A500004A8C001052
      7B0039526B005A636B00948C8C00ADADAD00D6D6D600EFEFEF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00736B6300CE6B
      10009C310000CE846300FFEFD600FFE7C600FFE7C600FFE7C600FFE7BD00FFE7
      BD00FFDEB500EFB58C00DE946300C6733900B55218009C3100007B3108006331
      10004A312900424242008C8C8C00DEDEDE00FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6D6
      D600BDBDBD00DEDEDE00DEDEDE00CECECE00ADADAD00BDBDBD00DEDEDE00DEDE
      DE00D6D6D6007B7B7B00DEDEDE00000000000000000000000000000000000000
      0000000000009C9C9C00CECECE00DEDEDE00DEDEDE00DEDEDE00D6D6D600BDBD
      BD008C8C8C00FFFFFF0000000000000000005A739400397BBD004284CE00428C
      CE004A8CD6004A94DE004A9CE70052A5F700427BBD0029528C0029528400294A
      8400394A6B008C8C8C00B5B5B500D6D6D600F7F7F70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00DEDE
      DE00BD9C8C00E7AD9400FFDEC600FFE7D600FFEFD600FFE7D600FFE7D600FFDE
      C600FFDEC600FFE7D600FFEFDE00FFEFE700FFF7E7007B8CA50000639C000063
      A50000639400005284005A5A6B00AD84730094847B00A59C9C00C6C6C600E7E7
      E700F7F7F70000000000000000000000000000000000FFFFFF00635A5200CE6B
      1800A5390000D69C7B00FFEFD600FFE7C600FFE7C600FFDEC600FFDEBD00FFDE
      BD00FFDEB500FFDEB500FFE7B500FFDEAD00F7C69400EFAD7300DE8C5200BD5A
      21009C390000423931007B7B7B00DEDEDE00FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6D6
      D600B5B5B500DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00D6D6D6007B7B7B00DEDEDE00000000000000000000000000000000000000
      000000000000CECECE0094949400CECECE00DEDEDE00D6D6D600B5B5B5008C8C
      8C00F7F7F700000000000000000000000000396394004A94DE004A94DE004A94
      E700529CE700529CEF0052A5F700529CEF00316BA500315A9C00315A94002952
      8C0021427B005263730084847B0073737300BDBDBD00F7F7F70000000000FFFF
      FF00EFEFEF00DEDEDE00CECECE00CECECE00CECECE00D6D6D600EFEFEF00FFFF
      FF00000000000000000000000000000000000000000000000000D6C6C600E7AD
      8C00FFD6BD00FFE7D600FFE7D600FFEFDE00FFEFDE00FFEFDE00FFE7D600FFDE
      C600FFDEC600FFE7D600FFEFDE00FFF7E700FFF7E7006B8CA500105A8C001063
      9400086BA500006BA500396B9400EFDEC600FFCEAD00E7A58C00A58473009484
      7B00B5B5B500EFEFEF00000000000000000000000000FFFFFF0073635200CE6B
      1800A5390000DEAD8C00FFEFDE00FFE7CE00FFE7C600FFE7C600FFDEC600FFDE
      BD00FFDEBD00FFDEB500FFD6B500FFD6B500FFD69C00FFC67300FFCE8C00E7A5
      6B00A54200004A3929007B7B7B00DEDEDE00FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6D6
      D600B5B5B500DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00D6D6D6007B7B7B00DEDEDE00000000000000000000000000000000000000
      00000000000000000000E7E7E700ADADAD00D6D6D600CECECE0073737300EFEF
      EF000000000000000000000000000000000039639C0052A5EF00529CEF0052A5
      F70052A5F70052ADFF0052A5F700427BBD00396BA5003163A50031639C00315A
      940029528C00214A7B009CADBD00A59C9C007B7B7B00D6D6D600CECECE00A5A5
      A5008C8484007B7B7B007B7B7B007B7B73007B7B73007B7B7B0094949400D6D6
      D600FFFFFF000000000000000000000000000000000000000000F7BDA500FFD6
      BD00FFE7CE00FFE7D600FFEFDE00FFEFDE00FFEFDE00FFEFDE00FFE7CE00FFDE
      C600FFDEC600FFE7D600FFEFDE00FFF7E700FFEFE7006B8CA5002173A500216B
      9C00107BB5001073AD0039739400E7DECE00FFE7D600FFE7CE00FFCEB500EFAD
      94009C848400D6D6D600000000000000000000000000FFFFFF007B6B5200CE6B
      21009C310000DEAD8C00FFF7DE00FFE7D600FFE7CE00FFE7C600FFE7C600EFDE
      C600DED6BD00FFDEBD00FFDEB500FFDEB500FFCE8C00FFB55200FFC66B00E79C
      5A00A54200004A3929007B848400DEDEDE00FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6D6
      D600B5B5B500D6D6D600DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00CECECE007B7B7B00DEDEDE00000000000000000000000000000000000000
      00000000000000000000E7E7E700ADADAD00CECECE00C6C6C60073737300E7E7
      E70000000000000000000000000000000000637BA5004A9CE7005AADFF0052AD
      F70052A5F700529CEF004284CE00427BBD003973B500396BAD00316BA5003163
      9C00315A9400214A8400526B9400DEDEDE00737373007B7B7B008C8C84009494
      9400A59C9C00A5A59C009C9C9C009C94940094948C008C8C8C00737373008C8C
      8C00DEDEDE000000000000000000000000000000000000000000FFBDA500FFDE
      C600FFE7CE00FFE7D600FFEFDE00FFEFDE00FFEFDE00FFEFD600FFE7CE00FFDE
      BD00FFDEBD00FFE7CE00FFEFDE00FFEFE700F7EFDE00638CA500319CD6002994
      C600298CC6002184BD00397B9C00E7DECE00FFEFD600FFE7D600FFDEC600FFDE
      BD00AD847B00D6D6D600000000000000000000000000EFEFEF0073634A00CE73
      2100A5390000E7B59C00FFF7DE00FFEFD600FFE7D600FFE7CE00FFE7C6004AAD
      CE0073BDC600FFE7BD00FFDEBD00FFDEB500FFBD5A00FFAD3900FFC67300E7A5
      6B00A54208004A3931008C8C8C00E7E7E700FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6D6
      D600ADADAD00D6D6D600DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00D6D6
      D600CECECE007B7B7B00DEDEDE00000000000000000000000000000000000000
      00000000000000000000E7E7E700A5A5A500CECECE00C6C6C60073737300E7E7
      E70000000000000000000000000000000000D6DEE700426394004A9CE70052AD
      F7004A9CE7004A8CD600428CCE004284CE00427BBD003973B5003973AD00396B
      A50031639C0029528C00526B9400EFEFEF0094948C00ADADAD00BDB5B500B5B5
      AD00ADADAD00A5A5A5009C9C9C009C94940094948C008C8C8C008C8C8C007373
      7300ADADAD00F7F7F70000000000000000000000000000000000FFBD9C00FFDE
      C600FFE7CE00FFE7D600FFE7D600FFE7D600FFE7D600FFE7D600FFDEC600FFCE
      B500FFD6BD00FFE7CE00FFEFDE00FFEFDE00F7E7D6005A84A50042ADE70042A5
      DE00399CD6003194CE00397BA500DED6CE00FFEFDE00FFE7D600FFE7CE00FFDE
      BD00AD847B00D6D6D600000000000000000000000000EFEFEF00846B5200CE6B
      2100A5390000EFCEBD00FFF7E700FFEFD600FFEFD600FFEFD6008CC6CE000094
      CE0042ADCE00FFDEC600FFDEBD00FFDEAD00FFAD2900FFBD6300FFE7B500EFAD
      84009C420800423939008C8C8C00E7E7E700FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6D6
      D600ADADAD00D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6
      D600C6C6C6007B7B7B00DEDEDE00000000000000000000000000000000000000
      00000000000000000000E7E7E700A5A5A500C6C6C600BDBDBD0073737300E7E7
      E7000000000000000000000000000000000000000000DEDEE700526B9400428C
      CE0052A5F7004A9CE7004A94DE004A8CD6004284CE00427BC600397BBD003973
      AD00396BAD0021528C007B94AD00F7EFEF00948C8C00BDBDBD00BDBDBD00B5B5
      AD00ADADAD00A5A5A500A59C9C009C9C9C0094949400948C8C008C8C84008484
      84007B7B7B00D6D6D60000000000000000000000000000000000FFBD9C00FFDE
      BD00FFE7CE00FFE7CE00FFE7CE00FFE7D600FFE7CE00FFD6B500FFAD8C00EF9C
      7B00FFBD9400FFDEC600FFE7D600FFEFDE00FFEFD600B5B5B5004A84AD00429C
      CE0042ADDE0042ADE7004284B500D6D6C600FFEFD600FFE7D600FFE7CE00FFDE
      BD00AD847B00D6D6D600000000000000000000000000E7E7E7008C6B5200CE6B
      2100A5390000EFCEBD00FFF7E700FFEFDE00FFEFD600ADD6D600009CCE0018A5
      CE00109CCE00E7DEC600FFE7C600FFC67B00DEA54A00C6BDAD00DEBD9C00DE94
      52009C420800393939007B7B7B00C6C6C600EFEFEF00F7F7F700FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000D6D6
      D600ADADAD00CECECE00D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6
      D600C6C6C6007B7B7B00DEDEDE00000000000000000000000000000000000000
      000000000000FFFFFF00CECECE00A5A59C00CEC6C600BDBDBD0073737300C6C6
      C600EFEFEF000000000000000000000000000000000000000000EFF7F7006B84
      9C00427BC60052A5F700529CE7004A94DE004A8CD6004284CE00427BC600427B
      BD003973B500294A8400D6D6DE00C6C6BD00B5B5B500A5A59C00BDBDBD00B5B5
      B500B5ADAD00ADADA500A5A5A5009C9C9C009C949400949494008C8C8C008C8C
      8C0073737300A5A5A500F7F7F700000000000000000000000000FFBD9C00FFD6
      BD00FFDEC600FFE7CE00FFE7CE00FFDEC600FFC69C00E7A58400635284003939
      9400A5738400FFC6A500FFE7D600FFE7D600FFE7D600FFEFD600E7D6C600BDB5
      B5006B94AD00428CB5003173A500D6CEC600FFE7D600FFE7D600FFDEC600FFDE
      BD00AD847B00D6D6D600000000000000000000000000CECECE00846B4A00CE73
      2100A5390000EFD6C600FFF7EF00FFF7E700ADD6D6000094CE004AB5CE00D6DE
      D6000094CE00A5CECE00FFEFCE009C7B52001842520052949C00B5732900DE7B
      2900BD5A00006B42210052524A0073737300A5A5A500C6C6C600E7E7E700F7F7
      F700FFFFFF00000000000000000000000000000000000000000000000000D6D6
      D600A5A5A500CECECE00D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6
      D600C6C6C6007B7B7B00DEDEDE00000000000000000000000000000000000000
      0000EFEFEF00636BA5002952B5003963CE00396BD600396BD600315AC600214A
      A500525A7B00BDBDBD00FFFFFF00000000000000000000000000000000000000
      00008C9CB500396BAD0052A5F700529CEF004A94DE004A8CD600428CCE004284
      C60021528C008C9CAD00DED6D600ADADAD00FFFFFF00ADADAD00BDBDB500BDB5
      B500B5B5B500ADADAD00ADADA500A5A5A5009C9C9C00949494008C8C8C008C8C
      8C008484840073737300CECECE00FFFFFF000000000000000000FFB59C00FFD6
      B500FFDEBD00FFDEBD00FFC69C00EFA584007B63840018299C000021BD000821
      BD000821A5008C6B8400FFCEAD00FFE7CE00FFE7D600FFE7D600FFE7D600FFEF
      D600FFEFD600EFD6C600BDB5AD00F7E7CE00FFE7CE00FFE7CE00FFDEC600FFD6
      B500AD847B00D6D6D600000000000000000000000000CECECE009C735200CE6B
      2100A5420800FFEFE700FFF7EF00B5D6DE000094CE0039ADCE00F7EFD600FFEF
      D60031ADCE0042ADCE00FFEFCE00E7CEB500527B8C007B7B5200FFC68C00FFDE
      AD00F7BD7B00E78C3900BD6B100084522100635A4A006B6B6B0094949400B5B5
      B500DEDEDE00EFEFEF00FFFFFF00FFFFFF00000000000000000000000000D6D6
      D600A5A5A500CECECE00D6D6D600CECECE00CECECE00CECECE00D6D6D600CECE
      CE00C6C6C6007B7B7B00DEDEDE0000000000000000000000000000000000FFFF
      FF00315AC6006BA5F7008CC6FF0094CEFF0094CEFF0094CEFF0094CEFF008CC6
      FF004A8CF700314A8C00C6C6C600000000000000000000000000000000000000
      000000000000A5ADBD0031639C004A9CEF0052A5F7004A9CE7003984CE00295A
      94007B849C00D6CECE009C9C9C00DEDEDE00F7F7F700ADADA500BDBDBD00BDBD
      BD00B5B5B500ADA5AD009C949400948C8C009C8C8400A58C7B00A5847B009484
      8400848C8C00737373009C9C9C00EFEFEF000000000000000000FFB59C00FFD6
      AD00FFC6A500FFB58C00B584840042428C000821AD000821BD000829BD000821
      BD000829BD001029A500C68C8400FFD6B500FFE7CE00FFE7CE00FFE7CE00FFE7
      CE00FFE7CE00FFE7CE00FFE7CE00FFE7CE00FFE7CE00FFE7CE00FFDEBD00FFD6
      B500AD847B00D6D6D600000000000000000000000000C6C6C600A57B5200CE6B
      1800A5420800FFF7EF00FFFFEF008CCEDE004AB5D600EFEFDE00FFEFDE00FFEF
      D60084C6D600009CCE00E7DECE00FFEFCE00EFE7D600BD8C5200DEA56B00FFE7
      C600FFEFCE00FFDEB500FFC68C00E79C4A00CE7318009C5A1800735239006363
      630084848400ADADAD00CECECE00E7E7E700000000000000000000000000CECE
      CE00ADADAD00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00C6C6C60073737300CECECE00000000000000000000000000000000008C94
      C6005A9CF70084CEFF008CD6FF008CD6FF008CD6FF008CD6FF008CD6FF008CCE
      FF0084C6FF003173EF007B7B8400FFFFFF000000000000000000000000000000
      000000000000FFFFFF0073737B00395A8C003973B500396BA50042638C008C94
      9C00C6BDBD009C9C9400BDBDBD00E7E7E700CECECE00ADADA500CECECE00ADB5
      B5009C9C9C00AD9C9400CEBD9C00E7D6B500FFE7BD00FFE7BD00FFDEB500F7B5
      8C00CEADA500949494007B7B7B00DEDEDE000000000000000000FFB59400FFB5
      8400C68C7B005A4A8C000018AD000821BD000829BD000821BD000829BD000829
      BD001031C6001039C6002139A500BD848400FFD6B500FFE7C600FFE7CE00FFE7
      CE00FFE7CE00FFDEC600FFDEC600FFDECE00FFE7C600FFDEC600FFDEBD00FFD6
      AD00AD847B00D6D6D600000000000000000000000000B5B5B500A57B5200CE6B
      2100A5420000FFF7EF00FFF7F700FFF7EF00FFF7E700FFF7E700FFEFDE00FFF7
      DE00C6DED600009CCE0094C6CE00FFEFCE00FFE7CE00FFDEBD00E7AD7300D684
      3100E7A56300FFD6B500FFE7CE00FFE7BD00FFC68C00EFA55A00D67B21008C5A
      29005A52520052525A0073737300A5A5A500000000000000000000000000ADAD
      AD00B5B5B500CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00C6C6C600949494008C8C8C00F7F7F7000000000000000000000000004A6B
      BD006BB5FF007BCEFF007BCEFF007BCEFF007BCEFF007BCEFF007BCEFF007BCE
      FF0073C6FF00529CF700525A8C00FFFFFF000000000000000000000000000000
      00000000000000000000C6C6BD007B7B7B0073737B007B7B8400A59C9C00A5A5
      9C0094948C00B5ADAD00CECECE00CECECE00A5A5A500BDBDBD00A5A5A500B5A5
      9400E7CEAD00FFEFBD00FFF7C600FFF7CE00FFF7CE00FFFFCE00FFFFD600FFF7
      CE00FFBD9C00DECECE007B7B7B00D6D6D60000000000F7F7F700EFA58400946B
      7B0018299C000821B5000821BD000821BD000829BD000829BD001031C6001031
      C6001039C6001042CE001042CE0029429C00EFA58C00FFD6BD00FFDEC600FFDE
      C600FFDEC600FFDEC600FFDEC600FFDEC600FFDEC600FFDEC600FFD6B500FFCE
      AD00AD847300D6D6D600000000000000000000000000ADADB500B58C5A00CE63
      1000AD522100FFF7F700FFFFF700FFF7EF00FFF7EF00FFF7E700FFF7E700FFF7
      DE00FFEFDE0029A5CE004AADCE00FFEFD600FFE7CE00FFE7CE00FFF7D600D68C
      5A00A54200009C5A1800DE944A00EFC69400FFE7CE00FFE7C600BDA58400A5AD
      A5007B7B9C001018840031316B006B6B6B000000000000000000E7E7E7008C8C
      8C00BDBDBD00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00C6C6C600B5B5B50073737300ADADAD00FFFFFF0000000000000000004A6B
      BD005AB5FF0063C6FF0063C6FF006BC6FF006BC6FF006BC6FF006BC6FF0063C6
      FF0063BDFF0052A5FF004A528C00FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00C6C6C60094948C009C9C9400847B7B008C8C
      8C00A5A5A500B5B5AD00B5ADAD009C9C9C00A5A5A500ADA59400DEC69C00FFE7
      B500FFEFBD00FFEFBD00FFE7BD00FFEFBD00FFEFBD00FFEFC600FFEFC600FFF7
      CE00FFCEA500F7DED60084848400D6D6D600DEDEDE0084849C00213194000021
      B5000821BD000829BD000829BD000829BD001031C6000831C6001039C6001042
      C6001842CE00184ACE001852D6001052D600424A9400DE9C8400FFD6BD00FFDE
      BD00FFDEBD00FFDEBD00FFDEBD00FFDEBD00FFDEBD00FFDEBD00FFD6B500FFCE
      A500AD847300CECECE00F7F7F700F7F7F70000000000ADADAD00CE9C6300C663
      0800B5633900FFFFFF00FFFFF700FFFFF700FFF7EF00FFF7EF00FFF7E700FFF7
      E700FFF7E7007BC6D600089CCE00DEDED600FFEFD600FFE7CE00FFF7D600D684
      52008C3900005A4A3900A5948400D6A57300D68C3900F7B57B009C8C8400E7EF
      F7004A52C600084AD6000821B5004A4A7B0000000000000000008C8C8C00B5B5
      B500C6C6C600CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00CECECE00C6C6C600ADADAD006B6B6B00C6C6C60000000000000000004263
      BD004AADFF0052BDFF0052BDFF0052BDFF0052BDFF0052BDFF0052BDFF0052BD
      FF004AB5FF004294F7004A528C00FFFFFF000000000000000000000000000000
      0000000000000000000000000000CECECE00CECEC600F7F7F700A5A5A5008484
      84008C8C8C0094949400A5A5A5009C9C9C00BDAD9400F7D6A500FFE7AD00FFDE
      AD00FFDEAD00FFE7B500FFE7B500FFE7B500FFE7B500FFEFBD00FFEFBD00FFEF
      C600FFC69C00FFE7DE0084848400DEDEDE00636BA5001029A5000821BD000821
      BD000821BD000829BD000831BD001031C6000831C600394AB5002142C6001042
      CE00184ACE001852D6001852D600185ADE001852D6005A528C00FFBD9400FFD6
      B500FFDEBD00FFDEBD00FFDEBD00FFDEBD00FFDEBD00FFD6B500FFCEA500FFBD
      9400AD846B009C9CA500ADADB500EFEFEF000000000094949400CE9C6B00C663
      1000B5633100FFFFFF00FFFFFF00FFFFF700FFFFF700FFF7EF00FFF7EF00FFF7
      E700FFF7E700E7E7DE000094CE008CC6D600FFEFD600FFE7D600FFF7DE00D68C
      52009C390000394242009C9C9C00EFEFEF00FFF7F700EFBD9C00AD8C63008484
      9C002139B5002173EF000829B5008484A50000000000A5A5A500ADADAD00D6D6
      D600DEDEDE00DEDEDE00DEDEDE00D6D6D600CECECE00CECECE00CECECE00CECE
      CE00CECECE00CECECE00BDBDBD009C9C9C007B7B7B00F7F7F700000000004263
      BD00319CFF0039ADFF0039B5FF0039B5FF0039B5FF0039B5FF0039B5FF0039B5
      FF0039ADFF00298CF7004A528C00FFFFFF000000000000000000000000000000
      0000000000000000000000000000ADADAD00E7E7E700FFFFFF00FFFFFF00DEDE
      DE00CECECE00D6DEDE00ADA5A500CEAD8C00FFD69C00FFD6A500FFD6A500FFD6
      A500FFDEA500FFDEAD00FFDEAD00FFDEAD00FFDEAD00FFE7AD00FFE7B500FFEF
      C600FFBDA500E7DEDE008C8C8C00F7F7F7003142A5000821BD000821BD000829
      BD001029BD001031C6001039C6002942BD00AD94AD00FFE7D600C6A5B5002952
      C6001852D600185ADE002163DE002163DE00216BE7001863DE006B638C00F7AD
      8C00FFD6B500FFD6B500FFD6B500FFD6AD00FFC6A500FFB58C00EF9C7B00CE8C
      7B005A4A7B00394A8C00ADB5BD00FFFFFF00000000009C9C9C00D69C6B00C65A
      0000BD734200FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFF7EF00FFF7
      EF00FFF7E700FFF7E70052B5D60018A5CE00FFEFD600FFEFD600FFF7E700D68C
      52009C420000394242009C9C9C00EFEFEF00FFFFFF0000000000FFFFFF00DEDE
      D6007B7BB5002931B5007B7BC600EFEFEF000000000094949400D6D6D600DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00CECECE00CECECE00CECE
      CE00CECECE00CECECE00CECECE00B5B5B50073737300CECECE00000000004263
      BD002194FF0021A5FF0021ADFF0021ADFF0021ADFF0021ADFF0021ADFF0029AD
      FF0021A5FF001884F7004A528C00FFFFFF000000000000000000000000000000
      0000000000000000000000000000B5ADAD00E7E7E700EFEFEF00FFFFFF00FFFF
      FF00FFFFFF00ADADAD00D6A58400FFCE9C00FFCE9C00FFCE9C00FFCE9C00FFD6
      9C00FFD69C00FFD6A500FFD6A500FFD6A500FFDEAD00FFE7B500FFEFCE00FFCE
      AD00FFCEBD00A5ADAD00BDBDBD00FFFFFF00B5B5C6002139AD000829BD001031
      BD001031C6001039C6004252B500CEADAD00FFF7E700FFFFFF00FFEFDE00AD94
      AD00105ADE002163DE002163DE00216BE7002173E7002973EF002163CE008C6B
      8400FFBD9400FFC6A500FFBD9400FFB58400F79C7B00AD7B7B00525294002131
      9400737BA500CECED600FFFFFF0000000000FFFFFF009C9C9400DEAD7300BD4A
      0000C68C6300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFF7
      EF00FFF7EF00FFF7EF00BDDEDE000094CE009CCED600FFEFDE00FFF7E700D68C
      5A009C42000042424200A5A5A500EFEFEF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF0000000000EFEFEF00B5B5B500DEDEDE00E7E7
      E700E7E7E700E7E7E700E7E7E700DEDEDE00DEDEDE00E7E7E700D6D6D600CECE
      CE00CECECE00CECECE00CECECE00BDBDBD0094949400B5B5B500000000003963
      BD00108CFF0010A5FF0010A5FF0010A5FF0010A5FF0010A5FF0010A5FF0010A5
      FF00109CFF00107BF7004A528C00FFFFFF000000000000000000000000000000
      0000000000000000000000000000B5B5B500DED6D600EFEFEF00F7F7F700FFFF
      FF00BDBDBD00CE947B00FFC69400FFC69400FFC69400FFC69400FFC69400FFCE
      9400FFCE9C00FFCE9C00FFD6AD00FFDEB500FFE7C600FFEFCE00FFDEBD00FFB5
      9C00CECECE0094949400F7F7F7000000000000000000CECED6002139AD001039
      C6001042CE001042CE005A63B500F7D6BD00FFF7F700FFFFFF00FFF7EF00FFDE
      BD009484AD00216BDE002173E7002173EF00297BEF00297BEF002984F700186B
      DE009C737B00DE947300BD847B0073638C002142AD001039AD005A6BA500C6CE
      D60000000000000000000000000000000000FFFFFF0084848400DEAD7B00BD4A
      0000C6846300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFF
      F700FFF7EF00FFF7EF00F7F7E70031ADD60031ADCE00FFEFDE00FFEFDE00CE7B
      42008C42000042424A00ADADAD00EFEFEF000000000000000000000000000000
      000000000000000000000000000000000000E7E7E700C6C6C600DEDEDE00E7E7
      E700E7E7E700E7E7E700DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00E7E7
      E700DEDEDE00D6D6D600CECECE00C6C6C600A5A5A50094949400000000004263
      BD002994FF0031ADFF0031ADFF0029ADFF0010A5FF00009CFF00089CFF00089C
      FF00089CFF00007BF7004A528C00FFFFFF000000000000000000000000000000
      0000000000000000000000000000DEDEDE00B5B5AD00E7E7E700F7F7F700D6DE
      DE00B58C7300FFB58400FFBD8C00FFBD9400FFC69C00FFCEA500FFCEAD00FFD6
      AD00FFD6B500FFDEBD00FFE7C600FFE7CE00FFE7CE00FFE7C600FFB59400DECE
      C6008C949400E7E7E70000000000000000000000000000000000A5ADBD002142
      B500184ACE00104AD6005A63BD00F7D6BD00FFF7EF00FFFFFF00FFF7EF00FFE7
      C600EFBDA500527BD6002173EF00297BEF002984F7002984F700318CF7003194
      FF002973D600395AB5002152C600104ACE00314AA500949CB500EFEFEF000000
      000000000000000000000000000000000000FFFFFF0084848400DEAD7300BD4A
      0000C68C6B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      F700FFFFF700FFF7EF00FFFFEF00CEE7E700CEE7DE00FFF7E700FFEFDE00CE7B
      42008C4200004A4A4A00ADADAD00EFEFEF000000000000000000000000000000
      000000000000000000000000000000000000E7E7E700CECECE00E7E7E700E7E7
      E700E7E7E700E7E7E700E7E7E700A5A5A5009494940094949400CECECE00E7E7
      E700E7E7E700E7E7E700E7E7E700E7E7E700BDBDBD008C8C8C00000000004A6B
      BD0063B5FF005ABDFF005ABDFF005ABDFF0063C6FF0042B5FF00009CFF00009C
      FF000094FF000073F7004A528C00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000ADADAD00D6D6D600EFEFEF00AD9C
      9400F79C7300FFC69C00FFCEAD00FFCEB500FFD6B500FFD6BD00FFDEBD00FFDE
      C600FFDEC600FFDEC600FFE7CE00FFE7D600FFDEC600FFB59400D6BDB5009494
      9400D6D6D600000000000000000000000000000000000000000000000000BDBD
      D600214AB5001852D6005A6BBD00F7D6BD00FFF7EF00FFEFE700FFE7DE00FFEF
      DE00EFCEB5005A84D6002984F7002984F700298CF7003194FF003194FF002984
      F700216BE700185ADE003152AD007B84A500EFEFF70000000000000000000000
      000000000000000000000000000000000000FFFFFF00948C8C00E7AD6B00BD52
      0000BD632100C6845A00CE9C8400E7C6B500EFDED600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFF700FFFFEF00FFF7EF00FFF7E700FFEFE700CE7B
      42008C4200004A4A4A00ADADAD00EFEFEF000000000000000000000000000000
      000000000000000000000000000000000000E7E7E700CECECE00E7E7E700E7E7
      E700E7E7E700E7E7E700C6C6C6009494940000000000000000009C9C9C00E7E7
      E700E7E7E700E7E7E700E7E7E700E7E7E700BDBDBD009C9C9C00000000004A6B
      BD0073BDFF006BC6FF006BC6FF006BC6FF006BC6FF0073C6FF006BC6FF0042B5
      FF0039ADFF0052A5FF004A528C00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000E7E7E700B5ADAD00CECED600BD84
      7300FFBD9400FFCEB500FFCEB500FFCEB500FFD6BD00FFD6C600FFDEC600FFDE
      C600FFDECE00FFE7CE00FFE7D600FFD6B500F7AD9400CEB5AD0094949C00D6D6
      D600000000000000000000000000000000000000000000000000000000000000
      000094A5CE002152BD00637BC600FFDEC600FFEFE700FFDECE00FFDECE00FFE7
      CE00D6B5B5004A84E700298CF700318CFF003194FF00318CF700297BEF002163
      E700184ABD005263A500CECECE00F7F7F7000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF007B7B7300E7AD7300C65A
      0000BD520000BD4A0000BD4A0000BD520000B5520800B55A1800BD7B5200CE9C
      7B00E7C6AD00EFD6CE00F7E7DE00FFF7EF00FFFFFF00FFFFFF00FFF7EF00D684
      42008C4200004A4A4A00ADADAD00EFEFEF000000000000000000000000000000
      000000000000000000000000000000000000EFEFEF00C6C6C600E7E7E700E7E7
      E700E7E7E700E7E7E700B5B5B500BDBDBD000000000000000000A5A5A500E7E7
      E700E7E7E700E7E7E700E7E7E700E7E7E700B5B5B500C6C6C60000000000526B
      BD0084C6FF0084CEFF0084CEFF0084CEFF0084CEFF0084CEFF0084CEFF0084CE
      FF0084CEFF007BBDFF004A528C00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000B5B5B5009CA5A500BD8C
      7B00FFC6AD00FFCEBD00FFCEBD00FFD6BD00FFD6C600FFDEC600FFDECE00FFDE
      CE00FFE7D600FFDECE00FFBDA500E7AD9400B5ADA500949C9C00E7E7E7000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000ADB5CE00315ABD007B84BD00CEB5B500EFD6C600DEC6BD009494
      BD002984EF00298CFF003194FF00318CFF00297BEF002163DE00214ABD004A5A
      A500BDBDC600FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0084847B00EFBD7B00C65A
      0000C65A0000C65A0000C65A0000C65A0000C65A0000C65A0000C65A0000BD52
      0000B5420000B54A0000BD632100C67B4A00CE8C6B00D6A58C00E7C6AD00C673
      31008C4A08004A4A4A00ADADAD00EFEFEF000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00A5A5A500E7E7E700EFEF
      EF00EFEFEF00E7E7E700ADADAD00BDBDBD0000000000000000009C9C9C00E7E7
      E700EFEFEF00EFEFEF00EFEFEF00E7E7E70084848400EFEFEF00000000005273
      BD009CCEFF0094D6FF0094D6FF0094D6FF0094D6FF0094D6FF0094D6FF0094D6
      FF0094D6FF0094C6FF004A528C00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000EFEFEF0084848400A58C
      7B00FFAD9400FFD6C600FFDECE00FFDECE00FFDECE00FFE7D600FFE7D600FFD6
      C600FFBDA500EFA58C00C6A594009C9C9C00ADADAD00F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008C9CC600215ACE00317BE7005A84D6004A84DE00298C
      F7003194FF003194FF00298CF7002173E700214AB5005263A500ADB5C600E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084847B00FFE7AD00E79C
      4200D6731800D66B1000CE630000C65A0000C6520000C65A0000C65A0000C65A
      0000CE630000CE630000C65A0000BD520000BD4A0000BD4A0000B5520800BD52
      0000945210004A4A4A00B5B5B500F7F7F7000000000000000000000000000000
      000000000000000000000000000000000000000000009C9C9C00DEDEDE00EFEF
      EF00EFEFEF00E7E7E700ADADAD00BDBDBD0000000000000000009C9C9C00E7E7
      E700EFEFEF00EFEFEF00E7E7E700CECECE009C9C9C0000000000000000005273
      BD00ADD6FF00A5DEFF00A5DEFF00A5DEFF00A5DEFF00A5DEFF00A5DEFF00A5DE
      FF00A5DEFF0094C6FF005A639400FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD008484
      8400BD8C7B00F7A58C00FFBDA500FFCEB500FFC6AD00FFBDA500F7AD9400DE9C
      8C00BD9C8C009C9494009CA5A500D6D6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00A5ADC600296BD600298CFF003194FF003194
      FF002984F700296BD6004263AD007B84A500D6DEDE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BDBDBD008C847300BDB5
      9400D6C69C00DEC69400EFC68400F7BD7300EFAD5A00E7943900D6842100CE6B
      1000CE5A0000C65A0000C65A0000C65A0000CE630000CE630000C65A0000CE63
      0000844A180052525200BDBDBD00F7F7F7000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700A5A5A500EFEF
      EF00EFEFEF00EFEFEF00ADADAD00C6C6C6000000000000000000A5A5A500E7E7
      E700EFEFEF00EFEFEF00E7E7E70084848400FFFFFF0000000000000000008494
      C600A5C6FF00B5DEFF00B5DEFF00B5E7FF00B5E7FF00B5E7FF00B5DEFF00B5DE
      FF00BDDEFF006394F700ADADB500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7F7F700A5A5
      A5007B84840094847B00AD8C7B00BD8C7B00B58C8400AD8C84009C8C8C009C9C
      9C009C9CA500CECECE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF008494C6002973D600298CF700216B
      D6004263AD00949CBD00DEDEDE00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEDEDE00C6C6
      C600ADADA5008C8C8C0084847B007B7B73008C8C7B00A5A58400BDAD8400D6C6
      9400E7CE9400E7BD7B00E7AD6300DE943900DE842100D6731000D66B0800D66B
      00007B4A180063636300C6C6C600F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEDEDE00ADAD
      AD00EFEFEF00EFEFEF008C8C8C00E7E7E7000000000000000000BDBDBD00D6D6
      D600EFEFEF00E7E7E7008C8C8C00EFEFEF00000000000000000000000000FFFF
      FF00396BDE00B5D6FF00C6E7FF00C6E7FF00C6E7FF00C6E7FF00C6E7FF00CEE7
      FF0094B5FF005A73B500FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      F700CECECE00A5A5A5009C9C9C00949C9C009CA5A500ADB5B500C6C6C600E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00DEDEEF00B5BDD600D6D6
      E700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00EFEFEF00CECECE00ADADB5009494
      9400848C84008C8C84008C8C840094948400ADAD9400BDB58C00CEAD7B00D6A5
      6300846B4A008C8C8C00E7E7E700FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E70094949400ADADAD00B5B5B500000000000000000000000000FFFFFF009C9C
      9C00ADADAD009C9C9C00F7F7F700000000000000000000000000000000000000
      0000FFFFFF007B8CC600527BE7005A7BDE005A84DE005A84DE005A84DE005273
      CE009CA5BD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00EFEFEF00DEDEDE00C6C6CE00B5B5B5009CA59C008C8C
      8C008C8C8C00DEDEDE00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEDEDE00E7E7E7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFEFEF008484840073737300ADADAD00DEDEDE00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E7E7E700EFEFEF0052425A00942910004A313100BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7F7F700CECECE00CECECE00E7E7E700F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000949CAD00395273005A6B73009C9C9C00CECECE00E7E7E700FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EFEFEF003163A5002973EF001852A50018294A003139420073737300A5A5
      A500DEDEDE00F7F7F70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000428CA50021C6E70031637B00CE391000D64A2900B53100004A31
      2900BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7F7F7008CADCE00399CCE004A84A5007B848C009CA5A500CECECE00E7E7
      E700F7F7F700FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7F7F70000397300004A8400004A8C00004A840008427300294A6B005A6B
      730094949C00C6C6C600E7E7E700FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C9CAD001863E7004294FF004A94FF00317BEF002163C60010396B002931
      42005A5A5A0094949400D6D6D600F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CED6DE0031CEEF0042314A00BD421000B55A3900CE735200C6421800B531
      08004A312900BDBDBD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CED6D600429CDE0008BDFF0010BDF700299CD6004284B5006B8494009494
      9400BDBDBD00DEDEDE00F7F7F700FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDCEDE00004A8400005A9C0000639C00005A9400005A940000528C000052
      8C00004A840008427300294A6B005A63730094949400C6C6C600E7E7E700FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000296BC600216BFF00398CFF00529CFF00529CFF00529CFF004294FF003184
      FF00185AB50010315A00293142005A5A5A009C9C9C00CECECE00F7F7F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E700D6D6D60042DEEF0084392100B54221009C391800AD5A4200E77B5A00B531
      0800BD3910004A312900BDBDBD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006BB5DE0010ADEF0018B5F70010CEFF0010CEFF0018CEFF0021BDF70029A5
      E7004A84AD006B7B8C00949C9C00BDBDBD00DEDEDE00F7F7F700FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000094ADC600005294000063A500086BA500006BA5000063A50000639C000063
      9C00005A9C00005A94000052940000528C00004A840000427B00214A6B005263
      73008C8C9400C6C6C600E7E7E700FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6CE
      D600216BF7002973FF00317BFF0052A5FF00529CFF00529CFF00529CFF00529C
      FF004A9CFF00398CF7002163C600104284002131420042424A0084848400BDBD
      BD00EFEFEF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000428CA50021C6
      E70031637300B55A390073E7EF0063E7EF009C523900D6735A00E78C6B00CE5A
      3100CE4A2100BD3908004A312900BDBDBD000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      EF0021ADEF0008BDFF0021ADEF0021CEFF0021CEFF0021CEFF0021CEFF0021CE
      FF0021C6FF0029B5E700398CBD00527B9C00848C9400ADADAD00D6D6D600EFEF
      EF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000638CB500085A9C00086BAD00086BAD00086BAD00086BAD00086BAD00006B
      A500006BA5000063A5000063A50000639C0000639C00005A9400005A94000052
      8C00004A840000427B00214A6B0052637300848C8C00BDBDBD00E7E7E700FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF00396B
      A500317BFF00397BFF00317BFF005A9CFF005AA5FF005AA5FF005AA5FF0052A5
      FF0052A5FF0052A5FF0052A5FF004A9CFF003984FF00216BD60010396B001829
      42004A4A520084848400C6C6C600EFEFEF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CED6DE0031CEEF004231
      4A00BD421800B55A3900D67B6300E7846300E77B5A00E7846300E7846300E784
      6300BD421800E7633900BD3108004A312900BDBDBD0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008CAD
      CE0008BDFF0000C6FF0021ADEF0029CEFF0029D6FF0029D6FF0029D6FF0029D6
      FF0029D6FF0029D6FF0029D6FF0029CEFF0031ADE7003994BD005A7B8C00848C
      9400B5B5B500D6D6D600EFEFEF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000316BA5000863A5001073B5000873B5000873B5000873B500086BB500086B
      AD00086BAD00086BAD00086BA500006BA500006BA500006BA5000063A5000063
      9C0000639C00005A9400005A940000528C00004A8C0000427B00184A6B004A5A
      730084848C00BDBDBD00E7E7E700000000000000000000000000CECED600216B
      CE00427BFF00397BFF003173FF005A9CFF0063A5FF005AA5FF005AA5FF005AA5
      FF005AA5FF005AA5FF0052A5FF0052A5FF0052A5FF00529CFF00428CFF003173
      DE00104A940010315200394242006B6B6B00B5B5B500DEDEDE00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E7E7E700D6D6D60042DEEF008439
      2100B54221009C391800AD523900E78C6B00E7846B00E77B5A00E7846300E784
      6300CE5A3900DE7B5A00E75A3900BD3108004A312900BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000E7E7EF0052AD
      DE0008C6FF0008C6FF0021ADEF0031CEFF0031D6FF0031D6FF0031D6FF0031D6
      FF0031D6FF0031D6FF0031D6FF0031D6FF0039D6FF0031D6FF0031BDEF00399C
      CE004A7BA50073849400A5A5A500C6C6C600E7E7E700F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008529400106BB500107BBD00107BBD001073BD001073B500106BAD0029C6
      E7001073B5000873B5000873AD00086BAD00086BAD00086BAD00086BAD00086B
      A500086BA500006BA5000063A50000639C0000639C00005A9C00005A94000052
      8C0000528C0000427B00394A6300DEDEDE0000000000000000006B849C003173
      F7004A84FF004284FF00317BFF00529CFF0063ADFF0063ADFF0063ADFF0063A5
      FF0063A5FF005AA5FF005AA5FF005AA5FF005AA5FF005AA5FF005AA5FF005AA5
      FF00529CFF00428CFF002973DE00184A8C00182939003939420073737300ADAD
      AD00E7E7E700F7F7F70000000000000000000000000000000000000000000000
      0000000000000000000000000000428CA50021C6E70031637300B55A390073E7
      EF0063E7F7009C5A3900D6735200E7846300E7846B00E7846300E77B5A00E784
      5A00E77B6300BD4A2100FFC6B500DE5A3100B53108004A312900BDBDBD000000
      0000000000000000000000000000000000000000000000000000B5C6CE0021B5
      F70010C6FF0008C6FF0018ADEF0039CEF70042DEFF0042DEFF0042DEFF0042DE
      FF0042DEFF0042DEFF0042DEFF0042DEFF0042DEFF0042DEFF0042DEFF0042DE
      FF0042D6FF0039C6F700399CCE0052849C007B848C00A5A5A500CECECE00E7E7
      E700F7F7F700FFFFFF000000000000000000000000000000000000000000E7E7
      E7000863AD001073BD00187BC600187BC600107BC600298CC60029EFFF0021EF
      FF0021B5DE001073B5001073BD000873B5001073B5000873B5000873B5000873
      AD00086BAD00086BAD00086BAD00086BAD00086BA500006BA5000063A5000063
      A50000639C00005A940008427300CECECE0000000000000000003173C6004284
      FF004A8CFF004A8CFF00397BFF00529CFF006BADFF006BADFF0063ADFF0063AD
      FF0063ADFF0063A5FF0063ADFF0063A5FF005AA5FF005AA5FF005AA5FF005AA5
      FF005AA5FF005AA5FF00529CFF004A94FF00317BE700185AB50010315A002931
      3900636363009C9C9C00EFEFEF00000000000000000000000000000000000000
      00000000000000000000CED6DE0031CEEF0042314A00BD421800B55A3900D673
      5A00E7846300E78C7300E78C6B00E77B6300E7846300E7846300E7846300E77B
      5A00E7846300D6633900D6947B00FFCEBD00DE523100BD3108004A312900BDBD
      BD000000000000000000000000000000000000000000000000007BBDE70018BD
      FF0010C6FF0010C6FF0018B5F70042CEF7004AE7FF004ADEFF004ADEFF004ADE
      FF004ADEFF004ADEFF004ADEFF004ADEFF004ADEFF004ADEFF004ADEFF004ADE
      FF004AE7FF004AE7FF004ADEFF0042CEF70042ADD6004284AD006B8494009494
      9400BDBDBD00DEDEDE00FFFFFF00000000000000000000000000FFFFFF006373
      840008427B0010639C001873B500187BC600187BCE002994CE008CFFFF009CFF
      FF0063FFFF001873B500107BC600107BBD001073BD00107BBD001073BD001073
      B5001073B5000873B5000873B500086BAD000863AD00086BAD00086BAD00086B
      AD00086BA50000639C00184A7300EFEFEF0000000000F7F7F7002973E700528C
      FF00528CFF00528CFF004284FF005294FF0073B5FF0073ADFF006BADFF006BAD
      FF006BADFF006BADFF006BADFF0063ADFF0063ADFF0063ADFF0063A5FF0063A5
      FF0063A5FF005AA5FF005AA5FF005AA5FF005AA5FF005AA5FF004A94FF00317B
      F70018529C001829390084848400EFEFEF000000000000000000000000000000
      000000000000E7E7E700D6D6D60042DEEF0084392100B54221009C391800AD5A
      4200E7846300E7846B00E78C6B00E7846B00E7845A00E7846300E7846300E784
      6300E77B5A00E7845A00BD391000FFE7CE00FFC6B500DE523100BD3108004A31
      2900BDBDBD0000000000000000000000000000000000FFFFFF0039ADE70018C6
      FF0018CEFF0018CEFF0018BDF70042CEF70052E7FF0052E7FF0052E7FF0052E7
      FF0052E7FF0052E7FF0052E7FF0052E7FF0052E7FF0052E7FF0052E7FF0052E7
      FF0052E7FF005AE7FF005AE7FF005AE7FF005AEFFF005AE7FF004ACEF70042AD
      DE004A84A50073848C00D6D6D600FFFFFF0000000000000000008494A5000039
      7B0000427B00004273000039730000397300084A7B0000427B00005A9C00187B
      AD002984B500187BC6001884CE00187BCE00107BC600107BC600107BC600107B
      BD00107BBD00107BBD00106BB500188CC60021CEEF000863AD000873B5000873
      B500086BAD000863A500395A7300FFFFFF0000000000B5BDD600397BFF005A94
      FF005A94FF005294FF004A84FF005294FF007BB5FF0073B5FF0073B5FF0073B5
      FF006BB5FF006BADFF006BADFF006BADFF006BADFF006BADFF0063ADFF0063AD
      FF0063ADFF0063A5FF0063A5FF005AA5FF005AA5FF005AA5FF005AA5FF005AA5
      FF004A94FF00215AB50052525200DEDEDE000000000000000000000000000000
      0000428CA50021C6E70031637300B55A390073E7EF0063E7EF009C523900D67B
      6B00E78C7300E7846300E7846B00E7846B00E7846B00E77B5A00E77B6300E784
      6300E7846300E7845A00BD391000F7C6A500FFEFD600FFC6B500DE523100BD39
      08004A313100E7E7E700000000000000000000000000D6DEE70021B5F70018CE
      FF0018CEFF0018CEFF0018BDF7004ACEF70063EFFF005AEFFF005AEFFF005AEF
      FF005AEFFF005AEFFF005AEFFF005AEFFF005AEFFF005AEFFF005AEFFF005AEF
      FF0063EFFF005AEFFF005AEFFF005AEFFF005AEFFF0063EFFF0063EFFF005AEF
      FF0052D6F7004294C600B5B5B500F7F7F70000000000000000004A6B94000052
      8C00005A9400005A9400005A940000528C00004A8400004A7B00005A9400005A
      940000397300084A7B0010528C001063A5001873BD00187BC6001884CE001884
      CE00187BC600107BC600299CCE0052FFFF0039F7FF00189CCE001073BD001073
      BD001073B5000863A5006373840000000000000000004A73A500528CFF00639C
      FF005A94FF005A94FF00528CFF005294FF007BBDFF0073ADF7006BADEF0073B5
      FF0073B5FF0073B5FF0073B5FF0073ADFF0073ADFF006BADFF006BADFF006BAD
      FF006BADFF006BADFF0063ADFF0063ADFF0063A5FF0063ADFF0063A5FF0063A5
      FF005AA5FF00317BEF0029393100BDBDBD00000000000000000000000000CED6
      DE0031CEEF0042314A00BD421800B55A3900D67B6300E7847300E7846B00E784
      6300E78C7300E78C7300E77B5A00E7846300E7846B00E7846B00E7846300E784
      6300E7846B00CE5A3900CE734A00FFDEBD00FFCEAD00FFE7CE00FFBDAD00DE4A
      290094290800CECECE0000000000000000000000000094B5CE0029C6FF0021CE
      FF0021CEFF0021CEFF0021BDF7004ACEF7006BF7FF0063E7F70063EFF7006BEF
      FF006BEFFF006BEFFF006BEFFF006BEFFF006BEFFF006BEFFF006BEFFF006BEF
      FF006BEFFF006BEFFF006BEFFF006BEFFF006BEFFF006BEFFF006BEFFF006BEF
      FF006BEFFF004AB5E7009C9C9C00EFEFEF000000000000000000215A8C00005A
      940000639C000063A50000639C0000639C0000639C00004A840000639C00005A
      8C00004A840000528C00004A840000427B000039730000427300084A7B001052
      8C001063A5001873BD00187BB5005ACEE7007BF7FF0031A5D600107BC600107B
      C600107BBD000863AD008C94940000000000F7F7F7002963B500639CFF00639C
      FF00639CFF00639CFF00528CFF005294FF0094BDEF00C6A5A50094849400738C
      B500639CDE006BADF7007BB5FF007BB5FF0073B5FF0073B5FF0073B5FF0073B5
      FF006BADFF006BADFF006BADFF006BADFF0063ADFF006BADFF0063ADFF0063AD
      FF005AA5F7004284EF0018393900ADADAD000000000000000000E7E7E700D6D6
      D60042DEEF0084392100B54A21009C391800AD523900E78C7B00E78C7300E784
      6300E7846300E78C7300E78C7300E77B5A00E78C6B00E78C7300E78C7300E78C
      6B00CE5A3900CE735200FFE7C600FFD6AD00FFD6AD00FFEFE700F79C8400CE42
      18007B423100FFFFFF000000000000000000FFFFFF006BADDE0029D6FF0029D6
      FF0029CEFF0021D6FF0021C6F70052CEF7008CE7E700BDAD9C00849C9C0063B5
      BD005ADEE7006BF7FF0073F7FF0073F7FF0073F7FF0073F7FF0073F7FF0073F7
      FF0073F7FF0073F7FF0073F7FF0073F7FF0073F7FF0073F7FF0073F7FF0073F7
      FF0073EFFF005ACEEF0084949C00DEDEDE0000000000EFEFEF00084A8C00005A
      9C00006BA5000063A500006BA5000063A50000639C0000528C0000639C000052
      8C0000639C0000639C0000639C00005A9C00005A940000528C00004A8C00004A
      840000427B000039730000427300005A9400004A8400105A9C00187BBD00187B
      C600187BC600085AAD00BDBDBD0000000000C6CECE002973D60073A5FF006BA5
      FF006BA5FF006B9CFF005A94FF005A94FF009CBDE700EFC6AD00FFD6AD00FFC6
      9C00D6A58C00AD8C8C00848CA5007394C6006BA5E70073B5F7007BB5FF0073B5
      FF0073B5FF0073B5FF0073B5FF006BB5FF006BADFF006BADFF006BADFF006BAD
      FF005AA5E7005294DE00103952009C9C9C0000000000398C940021C6E7003163
      7300B55A390073E7EF0063E7F7009C5A4200D67B6300E7846300E78C7300E78C
      7300E7846300E7846300E78C7300E78C7300E78C6B00E7947300EF947B00D663
      4200CE734A00FFE7C600FFDEBD00FFD6B500FFF7E700F79C8400CE4218008439
      2900FFFFFF00000000000000000000000000DEE7E70052B5E70031D6FF0031D6
      FF0029D6FF0029D6FF0029C6F70052CEF70094E7E700F7C6A500FFCEAD00F7B5
      9400CE9C8400A59C8C007BB5AD0073CED60073E7EF007BF7FF007BF7FF007BF7
      FF007BF7FF007BF7FF007BF7FF007BF7FF007BF7FF007BF7FF007BF7FF007BF7
      FF0084EFF70073DEEF006B8C9C00D6D6D60000000000CECED600005294000863
      A500086BAD00086BAD00086BA500086BA50000639C0000427B00005A8C00004A
      8400006BA5000063A5000063A5000063A50000639C0000639C0000639C000063
      9C00005A9400005A9400004A840000639C00004A840000427B00003973000042
      7300084A7B0010426B00B5B5B50000000000949CAD00397BE7007BADFF0073A5
      FF0073A5FF006BA5FF005A94FF00639CFF0094BDEF00E7C6B500FFDEC600FFDE
      BD00FFDEBD00FFD6B500EFBDA500DEAD9400A58C8C006B94CE007BBDFF007BB5
      FF007BB5FF0073B5FF0073B5FF0073B5FF0073B5FF0073B5FF0073B5FF006BAD
      FF0063A5CE005A9CDE001039630094949400DEE7E70029C6E70042314A00BD42
      1800B55A4200D67B6300E77B5A00E78C7300E78C7300E7846B00E7846300E78C
      7300E78C7300E78C7300CE846B00B5635200BD736300D6846B00CE633900CE73
      5200FFEFDE00FFDEB500FFD6B500FFF7EF00F79C8400CE42180084392900FFFF
      FF0000000000000000000000000000000000CED6D60042BDEF0039DEFF0031D6
      FF0031D6FF0031D6FF0029C6F7005AD6F7008CEFEF00EFC6AD00FFDEC600FFDE
      BD00FFDEBD00FFCEAD00EFBD9C00D6A58C009C9C8C0073CECE0084FFFF007BF7
      FF007BF7FF007BF7FF007BF7FF007BF7FF0084F7FF007BF7FF007BF7FF0084F7
      FF008CEFEF0084E7EF00638CA500D6D6D600000000009CA5B50008529C00086B
      A500086BAD00086BAD00086BAD00086BAD00086BAD00086BAD0008639C000863
      9C00086BAD00006BA500086BA500006BA5000063A500006BA5000063A5000063
      A5000063A50000639C0000528C0000639400004A840000639C00005A9400005A
      940000528C00003973006B6B7300FFFFFF006B8CB500528CF7007BADFF007BAD
      FF007BADFF0073ADFF005A94FF006BA5FF009CC6F700E7C6BD00FFE7D600FFC6
      A500FFBD9C00FFC6A500FFCEAD00FFDEBD00EFC6A500848CAD0084BDFF0084BD
      FF0084BDFF007BBDFF007BB5FF007BB5FF007BB5FF007BB5FF0073B5FF006BAD
      F70063A5C60063A5D60010426B008C8C8C000000000039D6E70084392100B54A
      21009C391800AD5A4200E78C7300E77B5A00E78C7300E78C7300E7846B00E78C
      6B00EFA59400EFA59400D6947B00A56B5A00C69C9C00B55A4A00845A5200738C
      9400A58C7B00D6BDA500FFF7E700F79C8400CE42180084392900FFFFFF000000
      000000000000000000000000000000000000B5CEE70039C6F70042DEFF0039DE
      FF0039DEFF0039DEFF0031C6F7006BDEF70094F7EF00E7CEB500FFE7CE00FFBD
      A500FFBD9C00FFC6A500FFD6B500FFDEBD00EFBD9C0084B5AD008CFFFF008CFF
      FF008CFFFF008CF7FF008CF7FF008CF7FF008CF7FF008CF7FF008CF7FF008CF7
      FF009CEFEF0094EFEF005A84A500CECECE00000000006B84A500085A9C00086B
      AD000873B5000873B5000873B500086BB5000873AD00086BAD00086BAD00086B
      AD00086BAD00086BAD00086BAD00086BAD00086BA500086BAD00006BA500086B
      A500006BA500005A9C0000528C00005A940000528C000063A5000063A5000063
      9C00005A9C00004A840084848400000000004A84BD00639CFF0084B5FF007BAD
      FF007BADFF007BADFF005A94FF0073ADFF009CC6EF00E7CEC600FFF7E700FFE7
      D600FFE7D600FFDEC600FFC6AD00FFC6AD00F7CEB5008C94A50073ADFF005294
      FF0073ADFF0084BDFF0084BDFF0084BDFF007BBDFF007BB5FF007BB5FF006BAD
      E7006BA5C60063A5D600104273008C8C8C00CEC6DE00A54A290073E7E70063E7
      EF009C523900D67B6300E78C7300E7846B00E7846300E79C8C00EFAD9C00EFAD
      9C00EFA59400EFAD9C00EFAD9C00C6A5A500C6634A009C736B0084DEFF0052BD
      FF002194F7005A738400CE846300CE42180084392900FFFFFF00000000000000
      00000000000000000000000000000000000094C6E70042CEF70042DEFF0042DE
      FF0042DEFF0042DEFF0039C6F70073DEF7009CEFEF00EFCEBD00FFEFE700FFEF
      D600FFE7CE00FFD6BD00FFBDA500FFC6AD00F7CEB50094ADA5007BE7FF0063CE
      EF0084EFF70094FFFF0094FFFF0094FFFF0094F7FF0094F7FF0094F7FF0094EF
      F700A5EFEF009CEFEF005284A500CECECE0000000000426B9C000863A5001073
      B5001073BD001073B5000873B5001073B5000873B5000873B5000873B5000873
      B5000873B500086BAD000873B500086BAD00086BAD00086BAD00086BAD00086B
      AD00086BAD00086BAD00005A940000528C0000639C00086BA500006BA500006B
      A50000639C0000427B00ADADAD0000000000317BC60073ADFF008CB5FF0084B5
      FF0084B5FF0084B5FF005A94FF007BB5FF00ADC6E700E7BDAD00DED6C600F7C6
      B500FFBDA500FFC6AD00FFD6C600FFE7CE00F7D6C6009494A5008CC6FF0073AD
      FF005294FF004A8CFF005294FF0063A5FF0073ADFF007BB5FF007BB5FF0073AD
      D60073ADC6006BADD600104273008C8C8C009C84AD00C6422100EF8C7300EFA5
      8C00EFAD9C00EFAD9C00EFAD9C00EFB5AD00EFB5AD00EFAD9C00EFB5AD00EFB5
      AD00EFB5A500EFB59C00F7BDAD00C66B52009C736B008CDEFF0039C6FF001894
      F700218CF7002194FF004A39420063292100FFFFFF0000000000000000000000
      00000000000000000000000000000000000073BDE7004ADEFF004AE7FF004AE7
      FF004ADEFF004AE7FF0042BDF70084E7F700ADE7E700E7C6AD00E7D6CE00F7C6
      B500FFC6AD00FFCEB500FFDEC600FFE7D600FFD6BD00A5ADA50094F7FF007BDE
      F7005ABDE70052B5E7005AC6EF0073D6F7008CEFF70094F7FF009CF7FF00A5EF
      EF00ADEFEF00ADEFEF005284A500CECECE00FFFFFF0018639C00106BAD001073
      BD00107BBD001073BD00107BBD001073BD001073BD001073BD001073BD001073
      B5001073B5000873B5001073B5000873B5000873B5000873B5000873B5000873
      B5000873AD00086BAD00086BAD00086BAD00086BAD00086BAD00086BAD00086B
      AD000863A50010426B00CECECE00000000002973CE0084B5FF008CBDFF008CBD
      FF008CB5FF008CBDFF005A94FF008CBDFF00A5CEF700E7B5A500D6B59C00DED6
      CE00FFF7E700FFE7D600FFD6BD00FFCEBD00F7DECE009494AD0094CEFF009CCE
      FF0094C6FF008CBDFF007BB5FF0063A5FF00528CFF004A8CFF005294F700639C
      D60073ADCE006BADD6001042730094949400DEDEEF00A5291000DE8C7B00EFAD
      9400F7BDB500F7BDB500F7BDB500F7BDB500F7BDB500F7BDAD00F7B5A500F7BD
      B500F7BDB500F7C6B500D66B4A00A573630073D6FF0039CEFF0000BDFF0000BD
      FF002194F700218CF7002194FF0029425200BDBDBD0000000000000000000000
      00000000000000000000000000000000000063B5E70052E7FF0052E7FF0052E7
      FF0052E7FF0052E7FF0042BDEF0094EFFF00ADF7F700E7BDA500D6B59C00DED6
      CE00FFEFE700FFE7D600FFCEBD00FFCEBD00FFDECE00A5B5AD00A5FFFF00ADFF
      FF00A5FFFF009CF7FF008CE7F70073CEEF005AB5E70052B5E7006BC6E70094DE
      E700ADEFEF00ADEFEF005A84A500D6D6D600E7E7E700085AA5001073B500107B
      C600107BC600107BC600107BBD00107BBD00107BBD00107BBD00107BBD001073
      BD00107BBD001073BD001073BD001073BD001073BD001073B5001073B5000873
      B5001073B5000873B5000873B5000873B5000873B500086BAD000873B500086B
      AD000863A50021426300E7E7E70000000000317BD6008CBDFF0094BDFF0094BD
      FF008CBDFF0094BDFF005A94FF009CC6FF00A5D6FF00ADC6EF00EFAD9400F7DE
      D600FFFFF700FFFFF700FFFFFF00FFFFFF00EFDECE009C9CBD0084BDFF005A94
      FF006BA5FF007BB5FF008CBDFF0094C6FF0094CEFF008CC6FF00639CEF005294
      DE0073B5CE006BADDE00104263009C9C9C00000000006B396B00C6635200E7AD
      9C00EFB5A500F7C6BD00F7C6BD00F7C6BD00F7CEBD00F7CEBD00F7C6BD00F7C6
      B500F7CEC600D6735A00CE7B5A00FFE7D6004ACEFF0010EFFF0000BDFF0000BD
      FF0000BDFF002194F700218CF7002194FF0031425200BDBDBD00000000000000
      00000000000000000000000000000000000052B5E7005AEFFF005AEFFF005AEF
      FF005AE7FF005AE7FF0052BDEF00A5F7FF00ADFFFF00BDE7E700EFB59400F7DE
      D600FFFFF700FFFFFF00FFFFFF00FFFFFF00F7D6CE00A5BDB50094EFFF0063C6
      E7007BD6EF0094E7F700A5F7FF00B5FFFF00B5FFFF00ADF7FF0084D6EF0073BD
      DE00B5E7EF00ADE7EF00638CA500D6D6D600BDC6CE001063AD002184C600218C
      CE00218CCE00218CCE001884C6001884C6001884C600187BC600107BC600107B
      C600107BBD00107BBD00107BBD00107BBD00107BBD001073BD00107BBD001073
      BD001073BD001073BD001073B5001073BD001073B5000873B5001073B5000873
      B5000863A50042526300F7F7F70000000000397BDE0094C6FF009CC6FF0094C6
      FF0094BDFF0094C6FF005294FF00A5CEFF00B5D6FF00ADD6FF00B5C6E700CEC6
      CE00E7CEC600F7D6CE00FFE7D600FFF7EF00EFD6C60094ADCE009CCEFF008CBD
      FF0073ADFF005A9CFF004A8CFF005294FF0073ADFF0084B5FF0084B5E70084B5
      C6007BB5CE006BADE70010426300A5A5A50000000000DEDEE7009C292100E7AD
      AD00E7B5A500F7C6B500F7CEC600F7D6C600F7CEC600F7D6C600F7D6CE00F7D6
      CE00D6735200CE846B00FFFFFF00FFEFDE0042E7EF0010EFFF0018EFFF0000BD
      FF0000BDFF0000BDFF002194F700218CF7002994FF0031425A00BDBDBD000000
      00000000000000000000000000000000000052BDE7006BEFFF0063EFFF0063EF
      FF0063EFFF005AEFFF005ABDEF00B5FFFF00BDFFFF00B5FFFF00C6E7DE00DECE
      C600EFCEBD00F7D6C600FFDED600FFEFEF00EFCEC600ADCEC600ADFFFF009CE7
      F7007BCEEF006BBDE7005AB5E70063BDE7008CDEF700A5EFFF00C6F7F700C6EF
      EF00C6EFEF00ADE7EF00638CA500DEDEDE0094A5BD00186BB500319CD60042AD
      DE0042B5DE0042ADDE0039A5DE0039A5D600319CD6002994D6002994CE00218C
      CE00218CCE001884C6001884C600187BC600107BC600107BC600107BC600107B
      BD00107BBD00107BBD00107BBD00107BBD001073BD001073BD001073BD001073
      B500085AA5006B6B7300FFFFFF00000000004284EF00A5CEFF00A5CEFF00A5CE
      FF009CC6FF009CC6FF006BA5FF005294FF0073A5FF0084B5FF0094C6FF009CCE
      FF00A5D6FF00ADCEFF00B5C6E700BDC6D600C6BDCE00A5CEF700A5CEFF00A5CE
      FF00A5CEFF00A5CEFF009CCEFF008CBDFF006BA5FF005294FF004A84EF005294
      DE0084B5CE006BA5E70018395200ADADAD000000000000000000734A7B00C65A
      4A00F7D6D600EFC6B500F7CEBD00F7D6D600F7DED600F7DED600FFE7DE00D67B
      5A00CE7B6300FFE7CE00FFFFFF00FFFFF700EFF7F70021EFFF0018EFFF0018EF
      FF0000BDFF0000BDFF0000BDFF002194F700218CF7002194FF0031425A00BDBD
      BD00000000000000000000000000000000004ABDEF0073F7FF0073F7FF006BF7
      FF006BEFFF006BEFFF004AC6F7005ABDEF007BD6F70094DEF700ADEFFF00B5F7
      FF00BDFFFF00C6F7F700CEE7DE00D6D6CE00DED6C600C6F7F700BDFFFF00BDFF
      FF00C6FFFF00C6FFFF00BDFFFF00ADEFF70084CEEF0063B5E70063ADDE007BBD
      DE00C6E7EF00A5DEEF007394A500E7E7E7007B9CBD001063AD00298CC60039A5
      D60042ADDE0042B5DE004AB5DE004AB5E7004AB5E7004AB5E7004AB5DE0042B5
      DE0042ADDE0039ADDE0039A5D600319CD6002994D6002994CE00218CCE00218C
      CE001884C6001884C600187BC600107BC600107BC600107BC600107BC6001073
      BD00085AA500949494000000000000000000297BDE006BA5FF008CBDFF009CC6
      FF00A5CEFF00A5CEFF00A5CEFF0094BDFF007BADFF006BA5FF006394FF00528C
      FF00639CFF0073A5FF0094C6FF00A5CEFF00ADD6FF00ADD6FF00ADD6FF00A5CE
      FF00A5CEFF00A5CEFF00A5CEFF00A5CEFF00A5CEFF0094C6FF007BADD60073AD
      D60084BDCE005A9CE70021394200C6C6C6000000000000000000000000009429
      2100EFB5B500F7DEDE00EFCEC600F7D6CE00FFE7DE00FFEFE700D67B6300CE84
      6300FFFFFF00FFFFF700FFDEBD00FFFFFF00FFAD8C00BD52310021EFFF0018EF
      FF0018EFFF0000BDFF0000BDFF0000BDFF002194F700218CF7002994FF003142
      5A00BDBDBD000000000000000000000000005AB5EF005AD6F7006BEFFF0073F7
      FF0073FFFF0073F7FF006BF7FF0063E7FF005AD6F70052CEF70052C6EF005ABD
      EF0073C6EF008CD6F700B5EFFF00C6FFFF00CEFFFF00CEFFFF00CEFFFF00C6FF
      FF00C6FFFF00C6FFFF00C6FFFF00C6FFFF00CEFFFF00C6F7FF00BDDEE700ADD6
      E700CEEFEF0094D6EF00849CAD00EFEFEF00F7F7F7006B94B5004273A500296B
      A5001863AD00216BB500217BBD002184BD00318CC6003194CE0039A5D60042AD
      D60042ADDE004AB5DE004AB5E7004AB5E7004AB5E7004AB5DE0042B5DE0042AD
      DE0039ADDE0039A5D600319CD6002994D6002994CE00218CCE001884CE00187B
      BD00084A8C00BDBDBD000000000000000000DEE7EF007B9CB500316BA5002973
      C600317BD6004A8CE700639CF7007BADFF0094BDFF009CC6FF00A5CEFF00A5CE
      FF0094BDFF007BADFF005A94FF005294FF005A94FF006B9CFF0084B5FF0094BD
      FF00A5CEFF00A5CEFF00ADD6FF00ADD6FF00A5CEFF0094BDFF008CB5CE008CBD
      CE008CBDCE004A8CE700394A4200DEDEDE000000000000000000000000007B63
      9400BD523900FFEFEF00F7E7E700F7DED600FFEFE700D67B6300CE846B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFAD9400CE421800843129009CC6C60018FF
      FF0018EFFF0018EFFF0000BDFF0000BDFF0000BDFF002194F700218CF7002994
      FF0031425200BDBDBD000000000000000000EFF7F700C6D6E70094BDD6007BC6
      EF0063BDEF0063C6EF005AD6F70063DEF7006BEFFF006BF7FF0073F7FF006BF7
      FF0063E7FF0052D6F70042C6EF004ABDEF005ABDEF007BCEEF009CDEF700B5EF
      F700C6F7FF00CEFFFF00D6FFFF00D6FFFF00CEFFFF00CEF7FF00D6EFEF00D6EF
      EF00DEEFEF007BBDE700A5ADB500F7F7F7000000000000000000000000000000
      0000FFFFFF00E7F7F700CEDEE70073CEDE0029A5CE002194C600107BB5001073
      B5001873B500217BBD00297BBD00298CC6003194CE00399CD60039A5D60042AD
      DE004AB5DE004AB5DE004AB5E7004ABDE7004AB5DE0042B5DE0039ADDE00218C
      C600184A7B00D6D6D6000000000000000000000000000000000000000000F7F7
      FF00BDC6CE00949CA5006B9CCE00428CC600317BCE00397BE7005294FF006BA5
      FF0084B5FF009CC6FF00A5CEFF00A5CEFF0094BDFF0084B5FF006BA5FF006394
      FF00528CFF005A94FF0073A5FF008CBDFF00A5CEFF0094C6F70094BDCE0094BD
      CE008CBDD600397BCE005A635A00E7E7E7000000000000000000000000000000
      00008C213100E7B5AD00FFF7F700FFF7F700CE6B5200C6522100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFB59400CE42180084392900FFFFFF0000000000A5CE
      D60018FFFF0018EFFF0018EFFF0000BDFF0000BDFF0000BDFF002194F700218C
      F7002994FF0031425A00BDBDBD0000000000000000000000000000000000FFFF
      FF00E7E7EF00D6D6DE00BDE7F7009CCEEF0073BDEF005ABDEF004AC6EF0052D6
      F70063E7FF006BF7FF006BF7FF006BF7FF0063E7FF0052DEF70052CEF7004AC6
      EF005ABDEF006BC6EF0094D6F700B5E7F700D6F7FF00DEF7F700E7EFE700DEEF
      EF00DEEFEF006BB5DE00BDBDBD00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000DEF7FF00297BA50042A5C6005AB5
      BD009CADAD00E7EFEF00C6EFEF00A5BDCE0084A5C6005A94BD001884BD00106B
      AD00186BB5002173B5002184C600318CCE003194CE0039A5D60039A5D6002184
      C600314A6B00EFEFEF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CED6E7007B9C
      B500396B9C002973C600317BD600428CE7006BA5FF009CC6FF00A5CEFF00A5CE
      FF009CC6FF0094BDFF007BADFF00639CFF004A8CFF003173E7005294D6006BA5
      DE007BADE700296BAD00A5A5A500FFFFFF000000000000000000000000000000
      00008C84AD00BD422900FFFFFF00C6736B008C424A00A5291800EF8C6300FFFF
      F700FFFFFF00FFB59400CE42180084392900FFFFFF0000000000000000000000
      0000A5CED60018FFFF0018EFFF0018EFFF0000BDFF0000BDFF0000BDFF002194
      F700218CF7002194FF0031425A00DEDEDE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFF700C6D6
      E7009CB5CE007BB5DE0063BDEF0063C6EF005AD6F7006BEFFF006BF7FF006BF7
      FF0063EFFF005AE7FF004AD6F70042C6F70042B5EF005AADDE008CC6E700ADD6
      EF00BDDEEF006BADD600DEDEDE00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000527B9C002973A500004A
      84004A526300A5A5A500D6D6D600E7E7E700F7F7F700F7F7F7007BB5BD0042B5
      CE004AC6DE0063CEDE008CB5BD00A5C6D60084ADC600638CB5003973AD002963
      9C00B5BDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00C6CED6009CA5AD00317BDE0094C6FF00A5CEFF00A5CE
      FF009CC6FF009CC6FF009CC6FF009CC6FF007BADFF00104A7B00636B7B006394
      AD00398CC6005A8C9400F7F7F700000000000000000000000000000000000000
      0000000000007B294200C65239009C5A5A0000000000A59CBD00AD291000EF8C
      6300F7AD8400CE42180084392900FFFFFF000000000000000000000000000000
      000000000000A5CED60018FFFF0018EFFF0018EFFF0000BDFF0000BDFF0000BD
      FF0029A5FF0073CEFF005AADDE00EFEFEF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00EFEFEF00D6DEDE006BBDE7006BEFFF0073F7FF0073F7
      FF006BF7FF006BF7FF006BF7FF006BF7FF005ADEFF005A8CAD00BDC6CE00BDD6
      E70094CEEF00BDD6DE00FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF004A739C005A94
      BD003984AD001863940018527B00215273002952730018527B0010639400186B
      9C00425A7B00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004A8CD6008CBDFF00ADD6FF00ADCE
      FF00A5CEFF00A5CEFF00A5CEFF00A5CEFF005294F70021424A00E7E7E7000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CECED600AD9C9C00000000000000000000000000A59CB500A529
      1000BD31080084392900FFFFFF00000000000000000000000000000000000000
      000000000000000000009CCED60018FFFF0018EFFF0018EFFF0000BDFF0021CE
      FF00426373007BC6EF007B8C9400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009CCEEF006BE7F70084FFFF007BF7
      FF007BF7FF0073F7FF0073F7FF0073F7FF0052C6EF0094A5AD00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF009CB5
      C600638CAD005284AD006394B500639CBD00639CBD005A94BD00427BA5008C94
      A500FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000073A5DE005294F7008CBDFF009CC6
      FF00ADD6FF00B5D6FF00B5D6FF0094BDFF0018529C00848C8C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6CE
      DE00CEBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B5E7E70008EFFF0018EFFF0021E7FF00426B
      8400395A6300638CAD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDE7F7005AC6EF0073EFFF007BF7
      FF0084FFFF0084FFFF0084FFFF0073EFFF005A9CBD00D6D6DE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00E7EFF700E7E7EF00E7E7EF00DEE7E700FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF009CB5CE004273A500316B
      C6002973CE00397BDE00528CE7002973D6008C949400F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CEFFFF0000EFFF006BD6FF0084CE
      F7006394B5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00D6E7EF00A5BDD6008CBD
      DE006BBDE70063BDE70063C6EF005AB5E700DEDEDE00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7FFFF00EFEFF700DEE7F700E7EFF7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6F7FF0063B5EF00C6CE
      D600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00F7FFFF00F7F7FF00F7FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFEFEF00F7F7F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00E7E7
      E700ADADAD00A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5
      A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5
      A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500ADAD
      AD00D6D6D600FFFFFF000000000000000000000000000000000000000000F7F7
      F700D6D6D600CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00D6D6
      D600EFEFEF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000F7F7F700B5B5B5009C9C9C00CECECE00EFEFEF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00EFEFEF00FFFFFF006B6B9C00212194007B7B8400E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEDEDE00AD84
      7300945A4A008C5242008C5239008C5239008C5239008C4A39008C4A39008C4A
      31008C4A31008C4A31008C4A3100844231008442290084422900844229008442
      2900843929008439290084392100843921008439210084312100843921007339
      29007B737300D6D6D60000000000000000000000000000000000F7EFEF00CEB5
      A500AD847300A57B6B00A57B6B00A57B6300A5736300A5736300A5736300A573
      6300A5736300A5736300A5735A00A56B5A00A56B5A00A56B5A00A56B5A009C6B
      5A009C6B52009C6352009C6352009C6352009C6352009C6352009C6352009473
      6B00B5B5B500EFEFEF0000000000000000000000000000000000000000000000
      000000000000638C8C000873210010522100314239005A6363009C9C9C00C6C6
      C600EFEFEF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006BB5C60042CEE700315294002110BD001810C60010109C007B7B
      8400E7E7E7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEDEDE00F794
      7300F7AD8C00F7D6C600F7D6C600F7CEC600F7CEBD00F7CEBD00F7CEBD00F7CE
      BD00F7CEBD00F7CEBD00F7CEBD00F7C6BD00F7C6B500F7C6B500F7C6B500F7C6
      B500F7C6B500F7C6B500F7BDB500F7BDAD00F7BDAD00F7BDAD00EFAD9400E763
      420073393100A5A5A500FFFFFF00000000000000000000000000F7F7F700F7B5
      9400EFA58400F7CEBD00F7D6C600F7CEC600F7CEBD00F7CEBD00F7CEBD00F7CE
      BD00F7CEBD00F7CEBD00F7C6BD00F7C6B500F7C6B500F7C6B500F7C6B500F7C6
      B500F7C6B500F7C6B500F7BDB500F7BDAD00F7BDAD00F7BDAD00EF9C8C00DE5A
      3900947B7300D6D6D60000000000000000000000000000000000000000000000
      0000BDC6C600106B3900089C100008A518000084100008631800214A31004A52
      52008C8C8C00B5B5B500E7E7E700F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CEDEDE0052B5BD005A5A94002110AD006B5ACE00634AD6000808A5001810
      A5007B7B8400E7E7E70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C694
      7B00F7BDA500FFFFFF00FFFFF700FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7
      EF00FFF7EF00FFF7E700FFF7E700FFF7E700FFF7E700FFEFE700FFEFE700FFEF
      DE00FFEFDE00FFEFDE00FFEFDE00FFEFDE00FFEFDE00FFEFE700FFFFFF00EFAD
      940094392100847B7B00FFFFFF0000000000000000000000000000000000DEBD
      B500F7B59400FFFFFF00FFFFFF00FFF7F700FFF7F700FFF7EF00FFF7EF00FFF7
      EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7E700FFF7E700FFF7
      E700FFF7E700FFEFE700FFEFE700FFEFDE00FFEFDE00FFF7E700FFFFFF00E78C
      73009C635200BDBDBD00FFFFFF00000000000000000000000000000000000000
      00004284840008841800088C100010B5210008B5210008B51800089C10000084
      1000085A210021423100525A520084848400BDBDBD00DEDEDE00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00EFEF
      EF00DEDEDE004AC6DE0018088C00394ABD00181894007363E7003129C6001008
      BD001810A5007B7B8400E7E7E700000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CEBD
      AD00F7AD8C00FFF7EF00FFF7E700FFEFDE00FFEFD600FFE7D600FFE7D600FFE7
      CE00FFE7CE00FFE7CE00FFE7C600FFDEC600FFDEC600FFDEC600FFDEBD00FFDE
      BD00FFD6B500FFD6B500FFDEC600FFDEC600FFD6AD00FFCEA500FFEFE700F7D6
      CE00BD4221006B5A5200F7F7F70000000000000000000000000000000000EFE7
      DE00EFA58400FFEFEF00FFF7EF00FFEFDE00FFEFD600FFEFD600FFE7D600FFE7
      D600FFE7CE00FFE7CE00FFE7CE00FFE7C600FFDEC600FFDEC600FFDEBD00FFDE
      BD00FFD6B500FFD6B500FFDEC600FFDEC600FFD6AD00FFCEA500FFF7EF00F7BD
      B500B5523100A5A5A500FFFFFF0000000000000000000000000000000000E7E7
      EF00087B3900109C21000884100010B5210010B5210010B5210010B5210008B5
      210008A5180008941800086B1800104A2100424A420073737300ADADAD00D6D6
      D600F7F7F7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006BB5C60042CE
      E700314A9400426BD60063E7F70063DEEF00524AC6007363E7006B63EF001008
      A5002918DE001010A5007B7B8400E7E7E7000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFDE
      DE00EF9C7B00FFEFE700FFF7EF00FFEFDE00FFEFDE00FFEFE700FFF7EF00FFEF
      E700FFE7CE00FFE7D600FFE7CE00FFE7CE00FFDECE00FFDEC600FFDEC600FFDE
      C600FFDEBD00FFE7CE00FFFFFF00FFFFFF00FFEFE700FFD6AD00FFE7D600FFF7
      EF00CE4A2900634A4A00EFEFEF0000000000000000000000000000000000FFFF
      F700EF9C7B00FFE7DE00FFF7F700FFEFDE00FFE7D600FFCEB500FFAD8C00FFBD
      A500FFC6AD00FFAD8C00FFC6A500FFBDA500FFAD8C00FFC6A500FFB59400FFAD
      8C00FFC69C00FFAD8C00FFCEBD00FFBDAD00FFCEB500FFD6AD00FFEFDE00F7D6
      CE00C65231009C949400F7F7F70000000000000000000000000000000000638C
      9400088C180018AD2900088C100010AD210010B5290010B5290010B5290010B5
      290010B5210010B5210010B5210008AD1800088C1000086B180018422900394A
      420073737300A5A5A500DEDEDE00F7F7F700FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CEDEDE0052B5BD005A5A
      94002110B500635AD6006B63EF006B5AE700735ADE007363E7007363E7003931
      CE00523194003121E7001010A5007B7B8400E7E7E70000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFF7
      F700EF9C7B00FFE7DE00FFFFF700FFEFDE00FFF7EF00FFFFFF00FFFFFF00FFFF
      FF00FFF7EF00FFE7D600FFE7D600FFE7CE00FFE7CE00FFE7CE00FFDEC600FFDE
      C600FFDEBD00FFEFE700FFFFFF00FFFFFF00FFFFFF00FFDEC600FFE7CE00FFFF
      FF00D663420063423900EFEFEF00000000000000000000000000000000000000
      0000EFA58400FFDED600FFFFF700FFEFE700FFD6BD00FF9C7B00FFB5A500FFA5
      8C00FF9C7B00FFAD8C00FF9C7B00FF9C7B00FFAD8C00FF9C7300FFA58400FFA5
      8400FF947300FFAD9400FF9C7B00FFA58400FFE7D600FFDEBD00FFE7D600FFEF
      E700CE5A39009C8C8400F7F7F700000000000000000000000000E7E7E700217B
      5A0010A5290018AD2900088C180010AD210018BD310018BD290018BD290018B5
      290010B5290010B5290010B5210010B5210010B5210010AD2100089C1800087B
      180010522100294A39006B6B6B0094949400CECECE00EFEFEF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00EFEFEF00DEDEDE004AC6DE001808
      8C00394ABD00181894006B63DE007363EF007363E700735AD6007363E700735A
      E7000808AD00CE8494002918DE001010A5007B7B8400E7E7E700000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00EF9C7B00FFE7D600FFFFF700FFEFE700FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFEFDE00FFE7D600FFE7D600FFE7CE00FFE7CE00FFE7C600FFDE
      C600FFDEC600FFE7CE00FFFFFF00FFFFFF00FFFFF700FFDEBD00FFE7CE00FFFF
      FF00D663420063423900EFEFEF00000000000000000000000000000000000000
      0000EFAD8C00FFDECE00FFFFF700FFEFE700FFF7F700FFF7EF00FFFFFF00FFF7
      F700FFEFEF00FFEFDE00FFE7CE00FFDECE00FFE7CE00FFDEC600FFDEC600FFDE
      C600FFD6BD00FFE7D600FFF7EF00FFF7F700FFF7EF00FFD6B500FFE7D600FFEF
      EF00CE5A39009C8C8400F7F7F70000000000000000000000000094A5AD000884
      310018AD310018AD3100109C210010A5210021BD390018BD310018BD310018BD
      310018BD310018BD310018BD290018BD290010B5290010B5290010B5290010B5
      290010AD2100089C1800087318001052210031423900636363009C9C9C00C6C6
      C600EFEFEF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000006BB5C60042CEE700314A9400426BD60063E7
      F70063DEF7005252CE00735ADE007363E7007363E7007363E700735AD6007363
      E7004A39CE004A4AB500F7AD9C002918DE001010A5007B7B8400E7E7E7000000
      000000000000000000000000000000000000000000000000000000000000FFF7
      F700EFA57B00FFE7DE00FFFFF700FFEFE700FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFEFDE00FFE7D600FFE7D600FFE7D600FFE7CE00FFE7CE00FFE7
      C600FFDEC600FFDEC600FFE7CE00FFE7D600FFDEBD00FFD6B500FFE7CE00FFFF
      FF00D6634200634A4200EFEFEF00000000000000000000000000000000000000
      0000F7AD8C00FFDED600FFFFFF00FFEFE700FFFFFF00FFFFFF00FFFFF700FFFF
      FF00FFFFFF00FFEFDE00FFEFD600FFE7D600FFE7CE00FFE7CE00FFE7CE00FFDE
      C600FFE7C600FFDEBD00FFE7CE00FFE7D600FFDEBD00FFD6B500FFEFD600FFEF
      EF00CE5A39009C8C8C00F7F7F700000000000000000000000000529494001094
      290021AD310018AD3100109C2900109C210021C6390021C6390021C6390018BD
      390018BD310018BD310018BD310018BD310018BD310018BD290010B5290010B5
      290010B5290010B5290010B5210008A5180008841800085A1800214A31005252
      52008C8C8C00BDBDBD00EFEFEF00000000000000000000000000000000000000
      00000000000000000000CEDEDE0052B5BD005A5A94002110B500635AD6006B5A
      DE006B63EF00736BEF007363EF00735ADE007363E7007363E7007363E700735A
      D6007363DE000808AD00CEC6DE00EFA59C002918DE001010A5007B7B8400E7E7
      E70000000000000000000000000000000000000000000000000000000000F7EF
      EF00F7A58400FFEFE700FFFFF700FFF7E700FFF7F700FFFFFF00FFFFFF00FFFF
      FF00FFF7EF00FFEFDE00FFEFD600FFEFD600FFE7D600FFE7CE00FFE7CE00FFE7
      CE00FFDEC600FFDEC600FFDEC600FFDEBD00FFDEBD00FFD6B500FFE7D600FFFF
      FF00D66342006B524A00EFEFEF00000000000000000000000000000000000000
      0000EFAD8400FFE7D600FFFFFF00FFF7E700FFE7DE00FFC6B500FFAD8C00FFBD
      A500FFC6AD00FFA58400FFBD9C00FFB59400FFA58400FFBD9C00FFAD8400FFA5
      8400FFB59C00FFA58400FFB59400FFA58400FFC6A500FFDEB500FFEFDE00FFE7
      E700CE634200A5949400FFFFFF000000000000000000000000001884520021A5
      310021AD390021AD390018A531001094210029CE420021C6420021C6420021C6
      390021C6390021C6390021C6390021BD310018BD310018BD310018BD310018BD
      310018BD310018BD290018BD290018BD290010BD290010B5290008A518000884
      1000085A2100294231009C9C9C00F7F7F7000000000000000000000000000000
      0000FFFFFF00EFEFEF00DEDEDE004AC6DE0018088C00394ABD00182194006B63
      E700735ADE007363EF007363EF007363EF00735ADE007363E7007363E7007363
      DE00735AD6005242D60031219C00FFFFE700E79C9C002918DE001010A5007B7B
      8400E7E7E700000000000000000000000000000000000000000000000000DED6
      CE00F7AD8C00FFEFEF00FFF7F700FFF7E700FFF7E700FFF7EF00FFF7EF00FFF7
      E700FFEFDE00FFEFDE00FFEFDE00FFEFD600FFE7D600FFEFDE00FFFFFF00FFFF
      FF00FFE7CE00FFE7C600FFDEC600FFDEC600FFDEC600FFDEBD00FFEFDE00FFEF
      EF00CE5A390073635A00F7F7F70000000000000000000000000000000000F7F7
      EF00F7AD8C00FFEFE700FFFFF700FFF7EF00FFCEBD00FFA58400FFBDA500FFAD
      8C00FFA58400FFBDA500FFA58400FFAD8C00FFB59C00FFA58400FFBDA500FFBD
      A500FFA58400FFB59400FFA58400FFAD8C00FFD6B500FFDEBD00FFF7E700F7D6
      CE00C6634200ADA5A500FFFFFF000000000000000000D6DEE7000884290021B5
      390021B5390021B5390021A531001094210029CE4A0029C6420029C6420021C6
      420021C6420021C6420021C6420021C6390021C6390021BD390021BD390018BD
      390018BD310018BD310018BD310018BD310018BD290018BD290010BD290010B5
      290010AD21000873100073737300E7E7E7000000000000000000000000000000
      00006BB5C60042CEE700314A9400426BD60063E7F70063DEEF005252CE00736B
      F700736BF700735ADE007363EF007363EF007363EF006B5ADE006B63E7006B63
      E7007363DE00634AD6001818A500FFDEAD00FFF7DE00EF9C9C002918DE001010
      A50084848400FFFFFF000000000000000000000000000000000000000000CEB5
      AD00F7BD9C00FFF7F700FFF7F700FFF7EF00FFF7EF00FFF7E700FFEFE700FFEF
      E700FFEFE700FFEFDE00FFEFDE00FFEFDE00FFEFD600FFF7EF00FFFFFF00FFFF
      FF00FFE7CE00FFE7CE00FFE7C600FFDEC600FFDEC600FFDEBD00FFF7E700F7DE
      D600C652310084737300FFFFFF0000000000000000000000000000000000E7DE
      DE00F7B58C00FFF7EF00FFFFF700FFF7EF00FFF7E700FFEFE700FFF7E700FFEF
      DE00FFEFDE00FFEFDE00FFEFD600FFEFD600FFEFD600FFEFE700FFFFFF00FFFF
      FF00FFE7CE00FFE7CE00FFDEC600FFDEC600FFDEC600FFDEBD00FFF7EF00F7C6
      BD00BD634A00BDB5B500FFFFFF000000000000000000739CA5001894290029B5
      420029B5420029B5420021AD39001094210031D6520029C64A0029C6420029CE
      4A0029CE4A0029CE4A0029C6420021C6420021C6420021C6420021C6420021C6
      390021C6390021C6390021BD390018BD390018BD310018BD310018BD310018BD
      310018BD2900089418004A5A4A00CECECE00000000000000000000000000CEDE
      DE0052B5BD005A5A94002110B500635AD6006B63F7006B63F700735ADE007363
      EF00736BF700736BEF00735ADE007363EF006B63EF007363E700735ADE007363
      E7007363E7001008AD00B594A500FFDEB500FFCEAD00FFF7DE00CE8C9C001010
      E70039398400EFEFEF000000000000000000000000000000000000000000BD9C
      8C00F7C6AD00FFFFFF00FFF7EF00FFF7EF00FFF7EF00FFF7E700FFF7E700FFEF
      E700FFEFE700FFEFE700FFEFDE00FFEFDE00FFEFDE00FFEFDE00FFF7EF00FFEF
      DE00FFE7CE00FFE7CE00FFE7CE00FFE7CE00FFDEC600FFDEC600FFFFF700F7C6
      B500AD4A31009C9C9C00FFFFFF0000000000000000000000000000000000D6C6
      BD00FFBDA500FFFFF700FFF7F700FFF7EF00FFF7EF00FFEFE700FFEFE700FFF7
      E700FFEFDE00FFEFDE00FFEFDE00FFE7D600FFE7D600FFEFDE00FFEFE700FFEF
      DE00FFE7CE00FFDECE00FFDEC600FFDEC600FFDEC600FFDEC600FFFFFF00EFAD
      9C00AD6B5A00D6D6D6000000000000000000000000004284840021AD390029BD
      4A0029B5420029B5420021AD39001094210031D6630031AD9C00298C6B002194
      4A0029B5390029C6420029CE4A0029CE4A0029CE4A0029C6420021C6420029C6
      420021C6420021C6420021C6390021C6390021BD390021BD390018BD310018BD
      310018BD310010A5290031523900BDBDBD0000000000FFFFFF00EFEFEF00DEDE
      DE004AC6DE0018088C00394ABD00181894006B63DE00736BF700736BF700735A
      DE007363EF00736BEF006B63EF006B5ADE00736BEF007B6BEF007B6BE7007363
      DE001010AD00B59CB500FFE7BD00FFCEAD00FFD6AD00FFF7DE00A56BAD000808
      CE008C8CAD000000000000000000000000000000000000000000F7F7F700DEA5
      8400FFD6C600FFFFFF00FFF7EF00FFF7EF00FFF7F700FFFFF700FFFFF700FFF7
      F700FFF7E700FFEFE700FFEFDE00FFEFDE00FFEFDE00FFEFDE00FFEFD600FFE7
      D600FFE7D600FFE7D600FFE7CE00FFE7CE00FFE7C600FFE7C600FFFFFF00EFAD
      9400944A3900BDBDBD0000000000000000000000000000000000FFFFFF00D6BD
      AD00FFCEB500FFFFFF00FFF7F700FFF7EF00FFBDA500FFA58400FFA58400FFB5
      9C00FF9C7B00FFA58400FFB59400FF9C7B00FFAD8C00FFAD8C00FF9C7B00FFAD
      8C00FF9C7B00FFA58400FFA58400FFA58400FFE7CE00FFE7CE00FFFFF700EF94
      7B00A57B7300E7E7E7000000000000000000DEDEE7002184520031BD4A0031BD
      4A0029BD4A0031BD4A0029AD4200189C290039D663005ACECE009CF7FF0073D6
      F70052ADBD00399494002994630029A54A0029BD420029CE4A0029CE4A0029CE
      4A0029CE4A0029C6420029C6420021C6420021C6420021C6390021C6390021C6
      390021B5390021AD420021523900B5B5B5000000000063B5BD0042CEE700314A
      9400426BD60063E7F70063DEF7005252D6007363E7007363E700736BF700736B
      F7006B5ADE006B63EF00736BEF007B73EF00846BDE008473EF007B73EF001010
      B500B594AD00FFE7C600FFDEBD00FFD6B500FFF7DE00B56B9C000808CE007B7B
      A500000000000000000000000000000000000000000000000000D6D6CE00EFAD
      8C00FFEFDE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFF700FFEFE700FFEFDE00FFEFDE00FFEFDE00FFEFDE00FFEF
      D600FFEFD600FFE7D600FFE7D600FFE7CE00FFE7CE00FFE7D600FFF7EF00EF8C
      7300845A5200DEDEDE0000000000000000000000000000000000EFEFEF00EFBD
      9C00FFE7D600FFFFFF00FFFFFF00FFF7F700FFB59C00FFCEBD00FFCEB500FFB5
      9400FFCEBD00FFC6B500FFB59400FFCEB500FFB59400FFB59400FFC6AD00FFAD
      8C00FFBDA500FFBD9C00FFAD9400FFD6B500FFE7CE00FFEFDE00FFEFE700E784
      6300AD9C9400F7F7F7000000000000000000BDC6C6001884420031C6520031BD
      520031BD520031BD520029B54200189C290039DE630052C6BD00ADFFFF00A5FF
      FF00A5FFFF0094F7FF007BD6E7005ABDCE0031948C00299C4A0031D6520029CE
      4A0029CE4A0029CE4A0029CE4A0029C64A0029C6420029C6420029C6420021C6
      420021B5420029B54A0021523900B5B5B500DEE7EF0052ADBD005A5A94002118
      B500635AD6006B5AE7006B5AE700736BF700736BF7007363E7006B63E7006B6B
      F7006B6BF7007B73E700635ACE00524ABD006363D6007363D6001810AD00AD9C
      BD00FFEFCE00FFD6AD00FFDEBD00FFF7DE00B56B9C000808CE007B7BA5000000
      0000000000000000000000000000000000000000000000000000C6B5B500F7B5
      8C00FFFFF700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFF700FFF7E700FFEFDE00FFEFDE00FFEFDE00FFEF
      DE00FFEFD600FFEFD600FFE7D600FFE7D600FFE7CE00FFEFE700FFE7DE00E77B
      5A0084737300EFEFEF0000000000000000000000000000000000DEDEDE00F7BD
      9C00FFF7EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFF700FFF7E700FFEFE700FFEFDE00FFEFDE00FFEF
      DE00FFEFDE00FFEFD600FFE7D600FFE7D600FFE7CE00FFF7EF00F7DED600DE7B
      5200BDBDB500F7F7F700000000000000000094ADBD001894420039C65A0031BD
      5A0031C6520031BD520029B5420021A5310042DE6B004AC6B500B5FFFF0073CE
      EF0063BDE70073CEEF0084E7F7009CF7FF008CEFF7003194730031D6520031D6
      5A0031D6520031CE520031CE520031CE4A0029CE4A0029CE4A0029CE4A0021BD
      420031B5520031BD5200215A3900ADADAD00F7F7F70042C6D60018088C00394A
      BD00182194006B6BEF007363EF006B63E7006B6BF7006B6BF7006B63E7007B73
      EF008C8CF700948CF7006B63CE005A5ACE006B7BFF001010AD00426BAD00848C
      8400AD948400EFCEB500FFF7DE00B56BA5000808CE007B7BA500000000000000
      0000000000000000000000000000000000000000000000000000DEBDA500FFC6
      AD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7E700FFEFDE00FFEFDE00FFEF
      DE00FFEFDE00FFEFD600FFEFD600FFE7D600FFE7D600FFFFF700F7CEBD00CE6B
      4A00A5A5A500FFFFFF0000000000000000000000000000000000E7D6CE00F7BD
      9C00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFEFE700FFEFEF00FFFFF700FFEF
      E700FFF7F700FFF7EF00FFF7EF00FFFFFF00FFF7E700FFEFDE00FFEFDE00FFEF
      DE00FFEFDE00FFEFD600FFE7D600FFE7D600FFE7D600FFFFF700F7BDAD00C673
      5A00D6D6D600FFFFFF00000000000000000073A5AD0021A5420039C6630039C6
      5A0039C65A0039C65A0029AD420021AD390042DE6B005ACEBD00C6FFFF00B5F7
      FF00ADEFFF0094E7F70073CEEF006BC6EF009CEFFF003994840031CE4A0021A5
      310029BD4A0031D6520031D65A0031D6520031CE520031CE520031CE4A0029BD
      4A0039BD5A0039C65A00215A3900ADADAD00C6C6E700315ACE0063DEF70063DE
      F7005252D6006B6BF7006B6BF7006B63E7007B6BE7008C84F7009C94F7009C94
      EF009C94EF009C94F7009494F700738CFF001810AD005A94DE0084DEFF0042AD
      FF002184E7007B7B7300A56394000808CE007B7BA50000000000000000000000
      0000000000000000000000000000000000000000000000000000EFBD9C00FFD6
      BD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7E700FFEFDE00FFEF
      DE00FFEFDE00FFEFDE00FFEFD600FFE7D600FFEFD600FFFFFF00F7B59C00AD63
      4200C6C6C600FFFFFF0000000000000000000000000000000000EFCEBD00FFCE
      AD00FFFFFF00FFFFFF00FFF7EF00FFBDA500FF947300FF9C7B00FFAD8C00FF94
      7300FFA58C00FF9C7B00FF9C7B00FFDED600FFFFFF00FFF7E700FFEFDE00FFEF
      DE00FFEFDE00FFEFDE00FFE7D600FFE7D600FFEFDE00FFFFFF00EF9C8400AD7B
      6B00E7E7E7000000000000000000000000004A948C0029AD4A0042CE630039C6
      630039C6630039C65A0029AD420031BD4A0042DE7B005ABDCE00ADDEE7008CCE
      E7006BBDE7007BCEEF0094DEF700A5EFF700ADF7FF004A9C9C0039D65A0031C6
      520021A5310018942900189C290021AD390029C64A0031CE520031CE520031BD
      520042BD630039C66300215A3900ADADAD00847BCE003129D6008C7BE700948C
      F7009494F700948CF7009C94F700A5A5FF00A59CF700A59CEF00A5A5F700A5A5
      FF00A59CEF00A59CF700A59CFF001010AD005A94DE0094DEFF0018BDFF00218C
      F700218CFF00298CEF0000086B00737394000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00F7BD9400FFEF
      DE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7EF00FFEF
      E700FFEFDE00FFEFDE00FFEFDE00FFEFD600FFEFE700FFFFFF00EF947300845A
      4A00E7E7E7000000000000000000000000000000000000000000F7C6AD00FFE7
      CE00FFFFFF00FFFFFF00FFF7F700FFC6B500FFDECE00FFD6CE00FFC6AD00FFDE
      D600FFC6B500FFD6C600FFCEBD00FFE7DE00FFFFFF00FFFFFF00FFF7EF00FFEF
      E700FFEFDE00FFEFDE00FFEFDE00FFEFD600FFF7E700FFFFFF00E78463009C8C
      8400F7F7F7000000000000000000000000003194730031B5520042CE630042CE
      630042C6630042CE630029AD420039C65A004AE77B0039D6C60052B5DE009CC6
      CE00CEF7FF00B5E7F70094D6EF007BC6EF00B5F7FF004AA59C0042DE630042E7
      6B0042DE6B0039D6630031C6520029B54200189C290018942900189C290029AD
      4A0042C6630042C66300215A3900ADADAD00DEDEF7001010AD008484EF00AD9C
      EF00B5ADF700ADADFF00ADADFF00ADADFF00ADADFF00ADADF700B5ADEF00B5AD
      FF00B5ADFF00ADA5F7001810AD005A8CDE0084DEFF0010BDFF0000BDFF0000BD
      FF00298CF7002194FF00298CEF007B7B8400E7E7E70000000000000000000000
      00000000000000000000000000000000000000000000F7F7EF00FFC69C00FFF7
      EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      F700FFEFE700FFEFDE00FFEFDE00FFEFD600FFF7EF00FFF7F700DE7B5A007363
      5A00EFEFEF0000000000000000000000000000000000FFFFFF00F7C6A500FFEF
      E700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7
      F700FFEFE700FFEFDE00FFEFDE00FFEFD600FFF7EF00FFEFE700D67B5A00ADA5
      9C00FFFFFF00000000000000000000000000298C630042C6630042CE6B0042CE
      6B0042CE6B0042CE6B0021A5390042D66B0052EF7B004AE7840031CEDE009CCE
      E700EFFFFF00E7FFFF00E7FFFF00E7FFFF00C6EFF70042A58C0042D6630021A5
      390029B5420031C6520039D6630042DE6B0042E76B0042DE6B0029B54A00219C
      390042BD630042CE6B00215A3900B5B5B500000000004A4ABD006B63DE009494
      EF00B5ADEF00BDBDF700BDB5FF00BDB5FF00BDBDFF00BDBDFF00BDB5F700BDB5
      F700BDB5FF001818B500B59CBD00DEDEDE0031DEFF0010E7FF0000BDFF0000BD
      FF0000BDFF00298CF7002194FF00298CEF007B7B8400E7E7E700000000000000
      00000000000000000000000000000000000000000000F7E7DE00FFD6B500FFFF
      F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFF700FFF7EF00FFF7E700FFFFF700FFDED600C66B4A00847B
      7B00FFFFFF0000000000000000000000000000000000FFF7EF00FFCEAD00FFF7
      F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFF700FFF7EF00FFF7E700FFFFFF00F7D6C600C67B5A00BDBD
      BD00FFFFFF00000000000000000000000000218C5A0042CE6B004AD673004ACE
      730042CE6B004AD67300219C31004ADE73005AF78C005AEF84004AE7940052CE
      AD0073CEC6008CCEDE00BDDEF700D6EFFF00BDDEF70042AD84004AE7730042D6
      630031BD520029AD3900189C2900219C310029B5420039CE5A0042CE63004ACE
      73004ACE730042CE6B00215A3900B5B5B50000000000DEDEE7001810B500BDB5
      F700A59CEF00BDB5EF00C6C6FF00C6C6FF00C6C6FF00C6C6FF00CEC6FF00C6BD
      F7001810AD00ADADDE00FFFFFF00FFE7CE0008EFFF0018EFFF0010E7FF0000BD
      FF0000BDFF0000BDFF00298CF7002194FF00298CEF007B7B8400E7E7E7000000
      00000000000000000000000000000000000000000000F7D6C600F7AD9400F7CE
      C600F7CEC600F7CEC600F7CEC600F7CEC600F7CEC600F7CEC600F7CEC600F7CE
      C600F7D6CE00FFFFF700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7CEBD00B5634A009C94
      9400FFFFFF0000000000000000000000000000000000FFEFE700F7AD8C00F7CE
      BD00F7CEC600F7CEC600F7CEC600F7CEC600F7CEC600F7CEC600F7CEC600F7CE
      C600F7D6CE00FFFFF700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7C6AD00AD7B6B00CECE
      CE0000000000000000000000000000000000218C52004ACE730052D67B004AD6
      73004AD673004AD6730039BD5A00219C310031B54A0039C65A004ADE6B0052E7
      7B0052EF7B0052EF84004ADE8C0042D694004ACEA5004AE7840052E77B004AE7
      7B004AE77B004AEF7B004AE77B0042DE6B0031BD4A0021A5310018942900219C
      39004AC66B0042C66B0029523900C6C6C60000000000000000006363C600736B
      DE00CECEFF00B5B5F700CEC6F700D6CEFF00D6CEFF00D6D6FF00CECEFF001818
      B500ADA5C600FFEFD600FFFFFF00FFFFFF00C6F7EF0010F7FF0018EFFF0010E7
      FF0000BDFF0000BDFF0000BDFF00298CF7002194FF00298CEF007B7B8400E7E7
      E7000000000000000000000000000000000000000000F7D6C600F7AD8400EFAD
      8C00EFA58400EF9C8400EF947B00E78C7300E7846B00E7846300E77B6300E794
      7B00EFAD9C00FFEFEF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7BDAD00945A4A00ADAD
      AD000000000000000000000000000000000000000000FFE7DE00F7AD8400EFAD
      8C00EFA58400EF9C8400EF947B00E78C7300E7846B00E7846B00E77B6300E794
      7B00EFAD9C00FFEFEF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7AD9400A5847300DEDE
      DE00000000000000000000000000000000002994630029A5420042C663004ACE
      730052D67B0052DE7B0052D67B004ACE6B0039BD5A0031B54A0021A53900219C
      310021A5390031B54A0042D6630052E77B005AF784005AF78C0052EF840052EF
      840052EF7B0052E77B004AE77B004AE77B004AE77B0042DE730042C66B0042BD
      630052CE730039C66300395A4200CECECE000000000000000000EFEFF7001010
      AD00D6CEFF00D6D6FF00C6C6F700D6D6F700DEDEFF00D6D6FF001818B500ADAD
      DE00FFFFFF00FFEFDE00FFE7D600FFFFEF00B573AD00104AD60018F7FF0018EF
      FF0010E7FF0000BDFF0000BDFF0000BDFF00298CF7002194FF00298CEF007B7B
      8400E7E7E70000000000000000000000000000000000F7EFEF00FFD6B500FFCE
      B500F7C6A500F7B59C00EFAD8C00EFA58400EF947B00E78C6B00DE5A3100DE73
      5200EFB5A500FFF7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7B59C008C5A4A00BDBD
      BD000000000000000000000000000000000000000000FFFFFF00FFDEC600FFD6
      B500F7C6A500F7BD9C00EFAD8C00EFA58400EF947B00E78C6B00DE5A3100DE73
      5200EFB5AD00FFF7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7F700F7AD8C00A58C7B00DEDE
      DE0000000000000000000000000000000000EFEFF7009CBDBD005A8C8400318C
      6B00218C4A0021944A0029AD520039B55A0042C66B004ACE730052D67B0052D6
      7B004ACE6B0039BD5A0029A54200219C3100219C310029AD420039BD520042CE
      63004AE77B0052EF840052EF840052EF840052EF84004ADE730052CE7B005AD6
      84005AD6840031B55200526B5A00E7E7E7000000000000000000000000007B7B
      C600635AD600EFEFFF00DEDEFF00D6D6FF00DEDEFF002121B500ADADDE00FFFF
      FF00FFFFFF00FFFFFF00FFFFEF00B57BAD000800CE00847BA500B5DEDE0018F7
      FF0018EFFF0010E7FF0000BDFF0000BDFF0000BDFF00298CF7002194FF00298C
      EF007B7B8400E7E7E70000000000000000000000000000000000DEDEDE00EFE7
      E700FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFFF00E7947300E77B
      5A00EFBDAD00FFF7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700F7AD9400845A5200C6C6
      C600000000000000000000000000000000000000000000000000EFEFEF00EFEF
      EF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFFF00E7947B00E77B
      5A00EFBDAD00FFF7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7EF00F7A58400A5948400E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      0000D6DEDE00B5BDBD008CB5B50063AD940031946B00218C4A002194390029A5
      420039BD5A004ACE730052D67B0052D67B004ACE6B0039BD5A0031B54A0029A5
      4200219C3100219C310029B54A0039C65A004AE773004ADE730063D6840063D6
      8C0063D6840029A542007B7B7B00EFEFEF00000000000000000000000000FFFF
      FF001010AD00D6D6FF00F7F7FF00E7E7FF001818B5008C73AD00FFFFFF00FFFF
      FF00FFFFFF00FFFFEF00B57BAD000800CE007B7BA5000000000000000000B5E7
      E70018F7FF0018EFFF0010E7FF0000BDFF0000BDFF0000BDFF00298CF7002194
      FF00298CEF007B7B8400E7E7E70000000000000000000000000000000000E7E7
      E700FFFFFF00FFF7EF00FFEFDE00FFDEC600FFDEC600FFFFFF00EF9C8400E784
      6B00EFBDAD00FFF7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7F700F7AD8C007B5A5200BDBD
      BD0000000000000000000000000000000000000000000000000000000000F7F7
      F700FFFFFF00FFF7F700FFEFDE00FFE7CE00FFDEC600FFFFFF00EFA58C00E784
      6300EFBDAD00FFF7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFEFEF00F7A584009C8C8C00E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7EFEF00A5BD
      BD00638C8400398C6300218C520021944A0029A54A004ACE6B004AD673004AD6
      7B004AD673004ACE6B0039BD5A0029AD4A002194310010842100319C520042B5
      63004AC66B00218C3900BDBDBD00FFFFFF000000000000000000000000000000
      00009C94CE004A4ACE00FFF7FF002929BD007373BD001810B500DEADB500FFFF
      FF00FFFFEF00B584B5000800CE007B7BA5000000000000000000000000000000
      0000B5E7E70018F7FF0018EFFF0010E7FF0000BDFF0000BDFF0000BDFF00298C
      F700218CFF00298CEF007B848400F7F7F7000000000000000000000000000000
      0000EFEFEF00EFEFEF00FFF7EF00FFEFDE00FFE7CE00FFFFF700EFB59C00E78C
      6B00EFBDAD00FFF7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7B59C00845A4A00B5B5
      B500000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00F7F7F700FFF7EF00FFEFDE00FFE7CE00FFFFF700EFB59C00E78C
      6B00EFB5AD00FFF7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7EF00F7AD8C009C8C8400DEDE
      DE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DEDEE700BDC6C6003194730039BD630052D67B004AD6
      73004AD673004AD673004AD673004AD6730042CE6B00186B290084948C008CB5
      A50052A5840073A58C00F7F7F700000000000000000000000000000000000000
      0000000000002921B5002121BD00ADADCE0000000000B5B5D6001008B500CE9C
      B500A57BBD000800CE007B7BA500000000000000000000000000000000000000
      000000000000B5E7E70018F7FF0018EFFF0010E7FF0000BDFF0000BDFF0000B5
      FF0039A5FF0084D6FF00739CB500FFFFFF000000000000000000000000000000
      000000000000F7F7F700FFFFFF00FFF7EF00FFEFDE00FFFFF700F7C6AD00EF94
      7300EFB5A500FFF7EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7BDA5008C634A00A5A5
      A500FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFF700FFEFDE00FFFFF700F7C6B500EF94
      7300EFB5A500FFF7EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF7F700F7B594009C847B00D6D6
      D600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006BADAD0039B55A005ADE840052DE
      840052D67B0052D67B004AD67B0052D67B0031B55200396B4A00EFEFEF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6D6E700CECEDE00000000000000000000000000B5B5D6000000
      BD000800BD00847BA50000000000000000000000000000000000000000000000
      00000000000000000000B5DEE70018F7FF0018EFFF0010E7FF0000BDFF0039C6
      FF0039525A0084DEFF00CECED600000000000000000000000000000000000000
      0000000000000000000000000000D6D6D600FFF7EF00FFFFFF00FFDECE00EF9C
      7B00EFAD9C00FFEFE700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFD6BD00A56B52007B7B
      7B00F7F7F7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E7E7E700FFFFF700FFFFF700FFDED600EF9C
      7B00EFAD9C00FFEFE700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7C6AD00A5846B00BDBD
      BD00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A5C6CE002194420042BD63004ACE
      6B0052D67B0052DE84005ADE840052D67B0018732900A5A5A500FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      EF00DEDEEF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6EFEF0010EFFF0018EFFF0039E7FF002129
      31005A9CB500A5B5BD0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEDEDE00FFFFFF00FFEFE700F7AD
      8400EFA59400F7DED600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFE7DE00CE8463006B63
      5A00E7E7E7000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFEFEF00FFFFFF00FFEFEF00F7AD
      8C00EFA59400F7DED600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFDECE00BD846B00A5A5
      A500F7F7F7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6D6D6006B948C004A84
      7B00298C5A00218C4A0021944A0018843900ADADAD00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6FFFF0010E7FF0084D6FF007BCE
      FF00ADBDC6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DED6D600FFCE
      AD00EFA58400EFB5A500FFF7EF00FFEFE700FFEFE700FFEFE700FFEFE700FFEF
      E700FFEFE700FFEFE700FFEFE700FFEFE700FFEFE700FFDECE00EF9C7300735A
      5200D6D6D6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFE7E700FFD6
      BD00EFA58400EFB5A500FFF7EF00FFEFE700FFEFE700FFEFE700FFEFE700FFEF
      E700FFEFE700FFEFE700FFEFE700FFEFE700FFEFE700F7D6BD00DE9473009C94
      8C00EFEFEF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00F7F7F700E7F7EF00EFF7F700FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEF7FF0094C6E700EFEF
      EF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00EFDE
      D600F7B59400E7946B00F7C69C00F7C69C00F7BD9C00F7BD9C00F7BD9400F7B5
      9400F7B58C00F7B58C00F7AD8C00EFAD8C00EFAD8400EFA57B00EFA57B00BD94
      8400EFEFEF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00F7EF
      EF00F7C6AD00EF9C7B00FFC6A500FFC6A500F7C69C00F7BD9C00F7BD9C00F7BD
      9C00F7B59400F7B59400F7B58C00F7B58C00F7AD8C00EFAD8400F7A58400C6B5
      B500FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00F7F7F700F7F7F700F7F7
      F700F7F7F700F7F7F700F7F7F700FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00F7F7F700E7E7E700D6D6D600D6D6D600DEDEDE00E7E7E700EFEFEF00F7F7
      F700FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00F7F7F700EFEFEF00DEDEDE00D6D6D600CECECE00CECE
      CE00C6C6C600CECECE00DEDEDE00E7E7E700F7F7F700FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00EFEF
      EF009CA59C005A8463004A7B5200527B5200637B6300848C8400A5A5A500BDBD
      BD00CECECE00DEDEDE00EFEFEF00F7F7F700FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E700BDBDBD00BDBDBD00E7E7E700DEDEDE00EFEFEF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700EFEFEF00DEDEDE00CECECE00BDBDBD00A5A5A5009C9C9C00848C84007B8C
      7B00738C7300738473009C9C9C00ADADAD00C6C6C600D6D6D600EFEFEF00F7F7
      F700FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6DED6004294
      4A00089C180018C6310021CE390018C6310010B5290010A5210018842100427B
      420052735200637363007B847B00949C9400B5B5B500B5B5B5009C9C9C008C84
      8400C6AD9C00948C7B0073737300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00F7F7F700FFFFFF000000000000000000FFFFFF00EFEFEF00B5B5B5009C94
      8C00CEB5A5009C8C8400737373007373730073737300A5A5A500E7E7E700FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00EFEFEF00DEDEDE00D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600CECE
      CE00BDBDBD00B5B5B500A5A5A50094949400848484005A7B5A00297B29002994
      310021AD3100109C1800637B630094949400ADADAD00BDBDBD00D6D6D600EFEF
      EF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00E7E7E700EFEFEF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094BD940008A5
      180018BD290021C6390021C6390021C6390018C6310018C6310031B54200ADC6
      B5008CB594007BA584006B946B00528C5200396B390031523100525A42008C84
      7300ADADAD00C6BDB500A58C7B0063524A006B525200635A5A00848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7F7F700DEDE
      DE00BDBDBD00C6C6C600E7E7E700F7F7F700C6C6C600A5A5A500C6A59400EFDE
      CE00FFFFF700FFF7EF00C6A59400735A52006B5A5A006B63630084848C00BDBD
      BD00F7F7F700000000000000000000000000000000000000000000000000F7F7
      F700D6D6D600B5B5B500A5A5A5009C9C9C009C9C9C009C9C9C009C9C9C009494
      9400949494009C9C9C009C9C9C008C8C8C004A735200088C0800089C100031CE
      4A0008B5180008BD1800218C21008C948C00C6C6C600D6D6D600E7E7E700F7F7
      F700FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00F7F7F700EFEFEF00EFEFEF00EFEFEF00EFEFEF00F7F7F700FFFF
      FF00000000009CAD9C006B7B6B00B5B5B500F7F7F70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000073B57B0018B5
      290029C6390021CE420021CE390021C6390018C6310018C6310039BD4A00B5BD
      B5004ADE73004AE77B006BD68400BDCEBD00CED6CE00B5C6B5008CAD8C00639C
      63004A7B420042733900527352006B735A005A5A4A005A4A42005A4A4A00635A
      5A00B5B5B500E7E7E700FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00E7E7E700C6C6C600A5949400CE9C
      9C00D6948C009C7B7B007B7B7B008C848400AD948400F7CEB500FFFFF700FFEF
      E700FFDED600FFD6CE00FFF7EF00FFF7E700B59C8C0094736B007B636B007B6B
      6B00CECECE00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00DEDEDE00BDBDBD00A5A5A500949494008C8C8C008C8C8C008C8C8C008484
      84008C8C8C009494940094949400848C8400188418000094080029C6420018C6
      310008B5100008B5180008AD1800639C6300EFEFEF00F7F7F700FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000D6D6
      D6009CA59C007B8C7B006B846B006B846B006B846B00848C84009C9C9C00BDBD
      BD00A5ADA50018A5290010A52100526B5200BDBDBD00EFEFEF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000063AD6B0021B5
      310031C6420021CE420021CE390021C6390021C6390018C631004ABD5200ADBD
      AD0039DE630042E76B004ADE7300ADC6B500CEDECE00CED6CE00C6CEC600C6CE
      C600B5BDB500A5B5A5007BA57B0042BD6300319C4A0021732100295218003142
      21004A524A008C8C8C00CECECE00F7F7F7000000000000000000000000000000
      000000000000FFFFFF00EFEFEF00CEC6C600AD949400C6A5A500F7D6CE00FFC6
      B500FFAD8C00DE8C7300A56B6300CE9C8C00FFE7DE00FFE7D600FFE7D600FFDE
      CE00FFCEBD00FFE7DE00FFCEBD00FFEFE700FFFFF700EFD6C600A58473008C6B
      6B0094949400E7E7E70000000000000000000000000000000000000000000000
      0000FFFFFF00EFEFEF00D6D6D600C6C6C600B5B5B500ADADAD00ADADAD00A5A5
      A500A5A5A500ADADAD00A5A5A5004A844A00109C180021B5310029CE4A0008B5
      180008B5180008B5180008B5210010A52100C6D6C60000000000000000000000
      00000000000000000000000000000000000000000000000000009CAD9C004294
      4A0031B5520039CE5A0039D65A0031CE520029C6420021AD3100219431003973
      3900297B290018C6310018CE3100109418005263520052738C00188CDE000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000052A55A0031BD
      390039C64A0029CE420021CE420021CE420021CE390018C631005ABD6300A5BD
      A50031D6520031DE5A0042CE6300BDCEBD00D6DED600CED6CE00C6D6C600C6CE
      C600BDC6BD00BDC6BD0094B59C0052E7840052EF7B0010AD210008B5180008AD
      1000009C10000884100073847300DEDEDE00000000000000000000000000FFFF
      FF00DEDEDE00BDB5B500AD9C9C00D6B5B500F7E7E700FFFFF700FFE7E700FFCE
      BD00FFB59C00DE947B00AD948C00DECEBD00FFCEB500FFD6BD00FFCEB500FFCE
      B500FFDED600FFD6BD00FFDECE00FFF7EF00FFFFFF00FFFFFF00FFFFF700F7D6
      C60094847B00ADADAD00FFFFFF00000000000000000000000000000000000000
      000000000000FFFFFF00F7F7F700EFEFEF00E7E7E700DEDEDE00DEDEDE00D6D6
      D600D6D6D600D6D6D6009CB59C00219C290018AD290039D6520010BD210008B5
      180008BD210008BD210008B5210008BD21005AAD6300EFF7EF00000000000000
      00000000000000000000000000000000000000000000A5BDA50039C652005AFF
      8C0052FF84004AEF7B0042EF730042E7630039DE5A0031DE520029D64A0021CE
      420018C6310018C6310018C6290010C6290008731800104A6B001084C60018A5
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000429C420039C6
      4A0039CE520029CE420021CE420021CE420021CE390018CE390063BD73009CBD
      A50021CE420029D64A0042C65A00C6D6C600D6DED600D6DED600CED6CE00C6D6
      C600BDCEBD00BDC6BD008CB594004ADE730042D6630008A5180008B5180008B5
      180008B5180008AD10005A7B5A00DEDEDE0000000000FFFFFF00E7E7E700C6BD
      BD00AD949400CEB5B500F7E7E700FFF7F700FFF7F700FFF7EF00FFE7DE00FFD6
      C600FFB5A500DEA58C00A58C7B00A57B6B00BD9C8C00E7B59C00FFCEAD00FFD6
      C600FFCEBD00FFCEBD00FFDECE00FFCEBD00FFDED600FFFFF700FFFFFF00FFFF
      FF00FFDEC600BDBDB500FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F7F7F70039A5420021B5310031CE520021CE390010B5210010BD
      210010BD210010BD210010BD210010BD290018B529008CC68C00000000000000
      000000000000000000000000000000000000F7F7F7004AAD5A0063FF9C0052F7
      84004AEF7B004AE7730042E7630039DE5A0031D6520031D64A0029CE420021CE
      420021C6390018C6310010BD290010BD290010BD21000063210008638C00107B
      C6001894E700189CF70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000318C31004ACE
      5A0042CE520029D64A0029CE4A0029CE420021CE420018CE390073BD7B008CBD
      940018C6310021CE39004ABD5A00CEDECE00DEE7DE00D6DED600D6DECE00CED6
      CE00C6D6C600C6CEC60084B58C0039DE5A0031CE520008A5180008B5180008B5
      180008B5180008AD100063846300DEDEDE00FFFFFF00CEC6C600C6A5A500DEBD
      BD00FFF7F700FFFFF700FFF7F700FFF7EF00FFEFEF00FFEFE700FFE7DE00FFD6
      CE00FFBDAD00F7AD9C00AD8C7B00A58C7300A57B6B00A5847300C6A59400EFB5
      9400FFD6BD00FFD6BD00FFCEB500FFE7D600FFE7D600FFF7EF00FFE7DE00D6B5
      AD00E7E7E700FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF009CC69C0021B5390031C64A0031D65A0010BD290010BD290010BD
      290010BD290010BD290010BD290010BD290010BD290029A53100E7EFE7000000
      000000000000000000000000000000000000CED6CE004AD66B0063FF940052EF
      7B004AEF730042E76B0039DE630031D65A0029D6520029CE4A0021CE420021CE
      390018C6310018C6310010BD290010BD210010BD210008B51000085A3900085A
      8400085A8C00107BBD00188CDE002194DE000000000000000000000000000000
      00000000000000000000000000000000000000000000CEADAD00319C310052CE
      630042D65A0029D64A0029CE4A0029CE420029CE420018CE390084BD8C007BBD
      840010C6290010C631004AB55A00D6DED600DEE7DE00DEE7D600D6DED600CEDE
      D600CED6CE00CED6CE0073B5840031D6520021BD420008AD180008B5180008B5
      180008B5180008A51000738C7300E7E7E700FFFFFF00CEADAD00F7EFEF00FFFF
      F700FFF7F700FFF7EF00FFEFEF00FFEFEF00FFEFE700FFE7E700FFE7DE00FFDE
      D600FFC6B500FFBDAD00E7AD9400B5948400A58C7300A58C7300A5947B00AD94
      8400D6AD9400F7C6A500FFDEC600FFE7D600FFEFE700FFCEB500D6C6C600EFEF
      EF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E7EFE70039AD4A0039CE5A0042DE6B0018C6310018BD290018C6310018C6
      310018C6310018C6310018C6310018C6310018C6310018C6310063AD6B00FFFF
      FF00000000000000000000000000000000009CBDA5004AE77B005AFF940063F7
      8C0063F7940063F78C005AF7840052EF7B0042E76B0039DE5A0029D64A0021C6
      390018C6310018C6310010BD290010BD210008B5210008BD180000A51000218C
      84002984BD0010528400085284001063A500216BB500217BD600218CEF000000
      00000000000000000000000000000000000000000000CEBDB50031A5390063D6
      6B0042D65A0029D64A0029D64A0029CE4A0029CE420018CE39009CC69C007BBD
      840010B5210010B521005AB56300DEE7DE00DEEFE700DEE7DE00D6E7DE00D6DE
      D600CEDECE00D6D6D60063B5730021CE390018B5310008AD180008B5180008B5
      180008B51800009C100084948400EFEFEF00FFFFFF00DEC6C600FFF7F700FFF7
      EF00FFEFEF00FFEFE700FFEFE700FFE7E700FFE7DE00FFE7DE00FFDEDE00FFE7
      DE00FFCEC600FFC6B500FFBDAD00FFBDAD00DEA59400B5947B00A58C7300A58C
      7B00A58C7B00AD9C8C00E7C6BD00F7C6B500BD948C00CECECE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000063AD6B0039CE5A0042DE6B0031D6520018C6310018C6310018C6310018C6
      310018C6310018C6310018C6310018C6310018C6310018C6310021AD3100C6DE
      C600000000000000000000000000000000006BAD730073FFA5009CFFBD009CFF
      C6008CFFB5007BF7A5006BF7940063F78C0063FF94005AF7840042DE630031D6
      520018C6310018BD290010BD290010BD210008B5180008B5100000B50800089C
      100052BDDE005AC6FF00399CD6002173A50010528400104A84001863A500187B
      CE00218CE7002194F700000000000000000000000000BDADA50039AD42006BD6
      730042D65A0031D6520031D6520029D64A0029CE4A0021CE42007BBD8400CECE
      CE00B5C6AD009CC69C00B5CEB500EFF7EF00E7F7E700E7EFE700DEE7DE00D6E7
      DE00D6DED600D6DED60052AD630018C6310010AD210008AD180008B5180008B5
      180008B5180008941000949C9400F7F7F700FFF7F700DEC6BD00FFF7EF00FFEF
      EF00FFEFE700FFEFE700FFE7DE00FFE7DE00FFDED600FFDED600FFDED600FFE7
      DE00FFCEC600FFCEBD00FFC6BD00FFC6B500FFBDAD00F7B5A500CE9C8C00AD8C
      7300A59484009C847B0094635200EF9473009C7B7B00C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDDE
      C60039CE5A004AE7730042DE6B0021C6390021C6390021C6390021C6390021C6
      390021C6390021C6390021C6390021C6390021C6390021C6390021C6390031A5
      3900F7FFF7000000000000000000000000005AB56B00B5FFD600A5F7C60052BD
      6300219C29001094210029946B0042B58C0039B57B0031B55A0018A5290031CE
      4A0018C6310010BD290008B5210008B5180008B5180018C6290029D64A0018AD
      310052BDD60063CEFF0063CEFF0063CEFF0052B5EF003994C60021639C00104A
      7B00105A9400186BA500A5A5AD00F7F7F70000000000AD9C94004AB5520073DE
      840042DE5A0031D6520031D6520031D6520029D64A0029CE420021C6390031B5
      420042B552005AB5630073BD7B0084BD84009CC69C00ADCEAD00BDCEBD00C6D6
      C600CED6CE00CED6CE0039AD420010BD210008A5180008B5210008B5210008B5
      180008B5180008941000ADADAD00F7F7F700FFFFFF00DEBDBD00FFEFEF00FFE7
      E700FFE7E700FFE7DE00FFE7DE00FFDED600FFDED600FFD6CE00FFE7DE00FFDE
      DE00FFCEC600FFCEC600FFCEC600FFCEBD00FFC6BD00FFC6B500FFBDAD00F7B5
      A500B58473007B5252007B5A5200F79C84009C7B7300C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7FFF70052B5
      630052EF840052EF840029CE4A0021CE390021CE420021CE390021CE390021CE
      390021CE390021CE390021CE390021CE390021CE390021CE390021CE420021C6
      390094C69400FFFFFF00000000000000000073C68400BDFFDE0052BD6300007B
      0000008C0000008C18004AA5D60073D6FF006BCEF70063C6E700299C630029CE
      420018C6310021CE390031D6520042E76B0052F7840063F794004ADE730042AD
      94006BCEFF0063CEF70063CEF70063CEF70063CEFF0063CEFF005AC6FF0052B5
      E7003184BD00295A84007B848C00E7E7E700000000009C94840052C663007BDE
      840039DE630031DE5A0031D6520031D6520029D64A0042D66B004AD66B0039D6
      5A0021CE420018C6390010C6310010BD290018BD290018B5310029B5390031B5
      420042AD52004AA55200109C1800089C1800089C180010B5210008B5210008B5
      210008B51800108C1800B5B5B500F7F7F700FFFFFF00DEBDBD00FFE7E700FFE7
      DE00FFE7DE00FFDED600FFDED600FFDED600FFD6CE00FFDED600FFE7E700FFDE
      D600FFD6CE00F7CEC600FFCEC600FFCEC600FFCEC600FFCEBD00FFC6B500FFBD
      AD00FFB5A500DE9C8C00BD847B00FFAD94009C7B7300C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF009CCE
      A50073BD7B0073B57B007BC684007BC684007BC684007BC6840052AD5A005AE7
      840063FF940042E7730021CE420029CE420029CE420029CE420029CE420029CE
      420029CE420029CE420029CE420029CE420029CE420029CE420029CE4A0029D6
      4A0039AD4200F7F7F700000000000000000063B57300BDFFDE0042B552000084
      0000009C0800108C4A0063BDF70073D6FF0073D6FF006BCEFF001894390039D6
      52004AE7730052EF730052E773004AD6730042C6730042B57B004AB59C006BCE
      EF0073D6FF006BD6F7006BCEF7006BCEF7006BCEF7006BCEF7006BD6FF0063CE
      F7004ABDF70042ADEF005A7B9400E7E7E70000000000848C73006BCE73007BDE
      8C0039DE630039DE5A0031D6520031D65200A5F7D600CEFFFF00C6FFFF00C6FF
      FF00BDFFFF00ADF7EF009CEFD6008CEFC60073E7AD0063DE9C004AD67B0042D6
      6B0031CE520021C6420021C6390018BD310010BD210008BD210010BD210008B5
      210008B5180018842100C6C6C600FFFFFF00FFFFFF00DEBDB500FFE7DE00FFDE
      D600FFDED600FFDED600FFD6CE00FFD6CE00FFDECE00FFEFE700FFE7E700FFDE
      D600B5C69400088410001884180094AD7300F7CEBD00FFCEC600FFCEC600FFCE
      BD00FFC6B500FFC6AD00FFBDA500FFBDA5009C7B7300C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000EFF7EF0052CE
      730052E7840031BD52005AEF8C0052EF8C0052EF8C0052EF8C0031BD52005AEF
      8C0063FF9C005AFF8C004AEF730042E7730042E7730039DE630029CE4A0029D6
      4A0029D64A0029D64A0029D64A0029CE4A0031D6520031D65A0021BD390031AD
      42008CBD8C00FFFFFF0000000000000000009CC69C0084E7A5008CF7AD00088C
      1000008C0000218C7B0073D6FF0073D6F70073D6FF006BCEEF00108C290021A5
      310031AD630039AD7B0039A59C005ABDC60073D6E70084DEFF0084E7FF007BDE
      FF0073D6F70073D6F70073D6F70073D6F70073D6F7006BCEF70052B5EF004AAD
      E70052C6F7004AB5EF007B8C9C00F7F7F700000000007384630073D684007BDE
      8C0039DE630039DE5A0031D652005ADE7B00D6FFFF00CEFFFF00C6FFFF00C6FF
      FF00C6FFFF00BDFFFF00BDFFFF00BDFFFF00B5FFFF00B5FFFF00ADFFFF00A5F7
      F7009CF7EF0094F7E7008CEFD6007BEFCE006BE7BD004AD6840008B5180010B5
      210008B52100217B2900CECECE00FFFFFF00FFFFFF00DEB5B500FFDED600FFDE
      D600FFD6CE00FFD6CE00FFD6C600FFD6C600FFEFEF00FFF7EF00FFE7E700FFE7
      DE0029AD290000940800008C0800007B08004A944200CEBD9C00FFD6CE00FFCE
      C600FFCEBD00FFC6BD00FFC6B500FFBDAD009C7B7B00C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000EFF7EF004AD6
      730052EF8C0031BD52004ADE84004ADE84004ADE84004AE7840039CE6B0029B5
      520031AD4A006BBD73005AB56B0052DE84005AF794004AEF7B0031D6520031D6
      520031D6520031D6520031D6520031DE5A0039B54A0094C69400E7EFE700F7FF
      F70000000000000000000000000000000000DEDEDE004A8C4A0084F7AD0073E7
      9400108C1800399CAD007BDEFF007BDEF7007BDEF70073D6FF0063C6D60063C6
      D6006BCEF70073D6FF006BCEFF0063C6F70094EFFF0073D6F7005AC6EF0073D6
      F70084E7FF007BDEF7007BDEFF0073D6F7005ABDEF004AB5E70052BDEF0063CE
      F70063CEFF004294C600ADB5B500FFFFFF00000000005A844A0084DE940084E7
      940039DE630039DE630031DE5A006BE79400DEFFFF00CEFFFF00CEFFFF00CEFF
      FF00C6FFFF00C6FFFF00BDFFFF00BDFFFF00B5FFFF00B5FFFF00B5FFFF00ADFF
      FF00ADFFFF00ADFFFF00A5FFFF00A5FFFF00A5FFFF00A5FFFF0039CE630008B5
      210008B52100297B3100D6D6D600FFFFFF00FFFFFF00C6A5A500FFDED600FFD6
      CE00FFD6C600FFD6C600FFDED600FFF7F700F7EFF700E7D6E700F7EFE70073D6
      7B0008B5180008AD180000A510000094080000840800007B00006B9C5200CEBD
      9C00FFD6C600FFCEC600FFCEBD00FFCEBD009C7B7B00C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000EFF7EF004AC6
      6B004AE7840029B5520039CE730039D6730039D6730039D6730039D6730039D6
      7B0042B55A00EFF7EF00A5CEA5004AD6730052EF8C004AE7730031D65A0031DE
      5A0031DE5A0031DE5A0039DE5A0039DE63005AB56300F7FFF700000000000000
      00000000000000000000000000000000000000000000A5ADA500528C520063DE
      840063DE9C0052B5D60084E7FF007BDEF7007BDEF7007BDEF7007BDEFF007BDE
      FF007BDEFF0073DEF7007BDEFF005ABDEF004AB5E7004AB5EF004AB5F70042AD
      E70084DEF70084E7F7006BCEEF0052B5E7005ABDEF0063CEF7006BCEF70063CE
      F70063CEFF004A84AD00D6D6D600FFFFFF00FFFFFF00528C52008CE79C0084E7
      940039E7630039DE630039DE5A0084EFA500DEFFFF00CEF7FF00CEF7F700CEF7
      FF00CEFFFF00C6FFFF00C6FFFF00C6FFFF00BDFFFF00BDFFFF00B5FFFF00B5FF
      FF00B5FFFF00ADFFFF00ADFFFF00A5FFFF00A5FFFF00A5FFFF004AD6840008BD
      210008B52100397B3900D6D6D600FFFFFF0000000000CEBDBD00EFC6C600FFDE
      DE00FFDEDE00FFEFE700FFF7F700FFFFFF00EFE7EF00A58CD6008CE79C0039D6
      5A0021CE420018BD290008B5180000A51000009C1000008C0800008408001884
      180094AD7300FFCEC600FFCEC600FFCEC6009C7B7B00CECECE00000000000000
      0000000000000000000000000000000000000000000000000000F7F7F70042BD
      630042DE840029AD4A0029BD5A0029C6630029BD630029BD630029BD630029C6
      630039B55A00C6DEC60094C6940042CE73004AE784004AE7730039DE630039DE
      630039DE630039DE630039DE630042E76B006BB57300FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008CB5
      8C0039946B0073CEF70084E7FF0084E7F70084DEF7007BDEF7007BDEF7007BDE
      F70084DEF70073D6F70052BDEF004AB5EF0052BDF7005AC6F7005AC6F70052BD
      F70052B5E7005ABDEF005ABDEF006BCEF7006BD6F7006BD6F7006BCEF7006BD6
      F70063C6F70063849400EFEFEF0000000000F7F7F7005A9C5A009CEFA5007BE7
      940039E76B0042E76B0039DE630094EFBD00DEFFFF00CEEFEF00BDCECE00BDCE
      CE00BDCECE00BDCECE00B5CECE00B5CECE00B5CED600B5D6D600B5D6DE00B5DE
      DE00B5DEE700ADE7E700ADE7E700ADE7EF00A5EFF700ADFFFF0042D6730010BD
      210010AD21004A7B4A00E7E7E7000000000000000000E7E7E700CE8C8400D6AD
      A500F7D6D600FFE7E700DEDECE00B5CEAD00E7F7E7009CFFBD0052F78C0052EF
      7B0042E7630031D6520021CE420010BD290008B5180000A51000009C1000008C
      0800007B000021841800F7CEBD00FFCEC600AD9C9C00E7E7E700000000000000
      0000000000000000000000000000000000000000000000000000F7FFF70042B5
      5A0042DE7B0029AD4A0021AD4A0021BD520021B5520021B5520021B5520021BD
      520029AD5200ADD6AD007BBD840039CE730042DE7B004AEF7B0042E76B0042E7
      6B0042E76B0042E76B0042E76B0042E76B0084BD8400FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006394A5008CE7FF008CE7FF0084E7F70084E7F70084E7FF008CE7FF007BDE
      F7005ABDEF0052B5E7005AC6F70063CEF70063CEF70063CEF70063C6F70063CE
      F70042ADEF0063C6EF007BDEFF0073D6F70073D6F70073D6F7006BD6F70073D6
      FF0052B5E70084949C00FFFFFF0000000000EFEFEF00529C5A00A5EFAD007BE7
      940042E76B0042E76B0042DE6300A5F7C600DEFFFF00DEFFFF00D6FFFF00D6FF
      FF00D6FFFF00CEF7FF00CEF7F700C6F7F700C6EFEF00C6EFEF00BDE7EF00BDE7
      E700B5E7E700B5DEE700ADD6DE00ADD6D600ADDEDE00B5FFFF0039CE630010BD
      210010AD21005A7B5A00E7E7E7000000000000000000E7E7E700E7AD9C00EFBD
      B500D6B5B500D6ADA500A5D694006BD67B0063EF8C005AF78C0063FF940063FF
      940052F784004AEF730039DE5A0029CE4A0018C6310010BD210008AD100000A5
      10000094080000840800EFCEBD00E7B5B500B5ADAD00F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF0052AD
      630039D67B0029B55200109C310018AD420018AD390018AD390018AD390018AD
      390018AD39008CC694005AB56B0031CE730042DE7B004AEF7B004AE773004AEF
      73004AEF73004AEF73004AEF7B0042DE6B00B5D6B50000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E7005A9CC60094F7FF008CEFF7008CEFF70094EFFF0084E7F70063C6EF0052BD
      E70063C6F70073D6F70073D6F7006BCEF7006BCEF7006BCEF70063CEF70063CE
      F70063C6F7004AB5E7007BD6F70073D6F70073D6F70073D6F70073D6F70073DE
      FF004A94C600ADB5B5000000000000000000DEE7DE005AA55A00ADEFB50073EF
      940042E7730042E76B0042E76B00B5F7D600E7FFFF00DEFFFF00DEFFFF00DEFF
      FF00D6FFFF00D6FFFF00D6FFFF00CEFFFF00CEFFFF00CEFFFF00C6FFFF00C6FF
      FF00C6FFFF00BDFFFF00BDFFFF00B5FFFF00B5FFFF00B5FFFF0031CE520010BD
      210010A521006B846B00EFEFEF000000000000000000EFE7E700E7C6BD00FFEF
      EF00F7BDA500EFC6BD00ADA57B0052AD520031CE520039E7630052EF7B005AF7
      8C0063FF940063FF940052F784004AE7730039DE5A0029CE4A0018C6310010BD
      210008AD10007BBD6B00FFD6CE00C69C9C00DEDEDE00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF0073B5
      7B0039CE730031BD63001094210010A5310010A5310010A5310010A5310010A5
      310010A531004A9C520039AD520031CE6B004AE7840052EF7B004AEF7B004AEF
      7B004AEF7B004AEF7B0052F7840042CE6300DEEFDE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008C94
      A5006BC6E7009CF7FF009CF7FF0094EFF7006BCEEF005ABDEF006BCEEF007BDE
      F7007BDEF70073D6F70073D6F70073D6F70073D6F7006BD6F7006BD6F7006BCE
      F7006BD6F70052BDEF0063C6EF0084DEFF007BDEF7007BDEF7007BDEF70073DE
      FF004A84A500D6D6D6000000000000000000D6DED60063AD6B00ADEFBD0073EF
      940042EF73004AE773004AE77300BDF7DE00E7FFFF00DEF7F700D6F7F700D6F7
      F700D6F7FF00D6F7FF00D6FFFF00D6FFFF00CEFFFF00CEFFFF00CEFFFF00C6FF
      FF00C6FFFF00C6FFFF00BDFFFF00BDFFFF00BDFFFF00B5FFFF0029C64A0010BD
      290010A5210073847300F7F7F7000000000000000000FFFFFF00DEBDBD00E7B5
      AD00F7AD9400FFE7D600FFDEC600DEBDA500849C6B0031BD420031DE5A0042E7
      730052F784005AFF940063FF94005AFF94004AEF7B0042E76B0031D6520021CE
      39004AC65200EFDECE00E7BDBD00ADA5A500F7F7F70000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B5D6
      B50029BD630031CE730010942100089C1800089C2100089C2100089C2100089C
      2100089C21000884100029BD5A0031C66B0052EF84005AF7840052F7840052F7
      840052F7840052F784005AF78C0052BD6300FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B94
      A50094EFFF009CF7FF007BD6EF0063C6EF0073D6EF0084E7F7008CE7FF0084E7
      F70084DEF7007BDEF7007BDEF7007BDEF7007BDEF70073D6F70073D6F70073D6
      F70073D6F7006BD6F70052B5E7007BDEF70084DEF7007BDEF7007BDEFF006BCE
      F7006B849400EFEFEF000000000000000000CED6CE006BBD7300ADF7BD006BEF
      94004AEF73004AEF730052E77B00D6FFE700E7FFFF00D6E7E700C6D6D600C6D6
      D600C6CECE00BDCECE00BDCECE00BDCECE00BDCECE00BDCECE00BDCECE00BDCE
      CE00B5CECE00B5CECE00B5CECE00B5CECE00BDE7EF00BDFFFF0021C6390010C6
      2900189C290084948400F7F7F70000000000000000000000000000000000D6C6
      BD00F7BD9C00FFE7DE00FFE7D600FFE7CE00FFDEC600DEADA50073A5630039C6
      4A0039DE5A004AE7730052F784005AFF940063FF94005AF78C004AEF7B0052E7
      7300F7EFE700F7D6D600B59C9C00E7E7E7000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFF7
      EF0029AD4A0031CE7300189C390000941000089C1800089C1000089C10000894
      100008941000088C180031C66B0031CE6B005AFF94005AFF8C005AF78C005AF7
      8C005AF78C005AFF8C005AEF840073BD7B000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000073AD
      CE008CEFF70073D6EF007BDEF70094F7FF009CF7FF0094EFFF008CEFFF008CE7
      F7008CE7F70084E7F70084E7F70084E7F70084DEF7007BDEF7007BDEF7007BDE
      F7007BDEF7007BDEF7006BCEF7005ABDEF008CE7FF0084DEF70084E7FF005AB5
      DE00949CA500FFFFFF000000000000000000C6CEC60073C67B00ADF7BD006BEF
      94004AEF7B004AEF73005AEF8400DEFFEF00EFFFFF00EFFFFF00E7FFFF00E7FF
      FF00E7FFFF00DEFFFF00DEFFFF00DEFFFF00D6FFFF00D6FFFF00D6F7F700CEF7
      F700CEF7F700C6F7F700C6F7F700C6EFEF00C6F7F700B5F7F70018C6310018C6
      3100189429008C9C8C00F7F7F70000000000000000000000000000000000DECE
      C600FFC6A500FFEFDE00FFEFDE00FFE7D600FFE7CE00FFE7CE00EFCEB500BDAD
      8C0052AD520029CE4A0042E76B004AEF7B005AF78C005AFF940084FFAD00DEFF
      E700F7E7E700C6A5A500DEDEDE00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF005AAD630029C66B0029BD5A00088C10000094080000940800009408000094
      0800008C080018A5420031C66B0042DE7B0063FF9C0063FF9C0063FF9C0063FF
      9C0063FF9C006BFF9C0052CE7300D6E7D6000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000094BD
      DE004A9CCE006BBDDE008CDEEF0094EFF7009CF7FF00A5FFFF009CFFFF009CF7
      FF009CF7FF0094EFFF008CEFFF008CE7F7008CE7F70084E7F70084E7F70084DE
      F70084DEF7007BDEF7007BDEFF005ABDEF007BD6F7008CE7FF008CEFFF004A94
      BD00C6C6C600FFFFFF000000000000000000B5CEB50084CE8C00ADF7BD006BF7
      940052EF7B004AEF7B006BEF9400E7FFF700EFFFFF00EFFFFF00EFFFFF00E7FF
      FF00E7FFFF00E7FFFF00E7FFFF00DEFFFF00DEFFFF00DEFFFF00D6FFFF00D6FF
      FF00D6FFFF00CEFFFF00CEFFFF00CEFFFF00CEFFFF00ADF7E70018C6290018C6
      3100218C29009CA59C00FFFFFF0000000000000000000000000000000000DED6
      CE00FFCEB500FFEFE700FFF7EF00FFEFE700FFEFDE00FFEFD600FFE7CE00FFE7
      CE00EFC6BD00B59C84004AB552004AD6630073E78400ADEFB500FFEFEF00EFD6
      D600BDA5A500E7E7E70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009CCE9C0031B55A0031C66B0018A5420000840000008C000000940000008C
      0000088C210029BD630031C66B005AEF94007BFFAD0073FFA50073FFA50073FF
      A5007BFFA5007BFFAD006BB57300FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EFF7FF00CEDEEF00ADC6DE00739CBD005A94B50063A5C6006BB5D60073CE
      E7008CDEEF0094EFF7009CF7FF009CF7FF009CF7FF0094EFFF008CEFFF008CE7
      F70084E7F70084E7F70084E7F7007BDEF7005ABDE70094EFFF008CE7FF005284
      A500DEDEDE00000000000000000000000000A5C6A5008CCE9400B5F7C60063F7
      8C0052F7840052EF7B0073EF9C00EFFFF700EFF7F700DEEFEF00DEEFEF00DEEF
      EF00DEEFEF00D6EFEF00D6EFEF00D6EFEF00D6EFEF00D6EFEF00CEEFEF00CEEF
      EF00CEEFEF00CEEFEF00C6EFEF00C6EFEF00CEFFFF00A5EFD60018C6290018CE
      310021842900A5ADA500FFFFFF0000000000000000000000000000000000E7D6
      CE00FFD6B500FFF7EF00FFFFF700FFF7EF00FFF7E700FFEFDE00FFEFD600FFE7
      D600FFEFD600F7C6AD009C948C00BDAD9400D6B5A500E7B5B500D6ADAD00BDB5
      B500F7F7F700FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0052AD630039CE730031CE730018A5390008841000008408001094
      210031C66B0031CE6B004ADE84008CFFB5009CFFBD009CFFBD009CFFBD009CFF
      BD009CFFC6006BCE7B00E7EFE700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CED6D600B5BDC60094A5
      B5007BA5B5006B9CBD0063A5C6005AADCE006BC6DE007BD6EF008CE7F70094EF
      FF0094F7FF0094F7FF0094EFFF0094EFFF006BCEEF007BDEF7007BDEF7007384
      9400F7F7F7000000000000000000000000008CBD94009CDEA500ADF7BD005AEF
      8C004ADE73004AE7730084F7A500F7FFFF00E7EFF700D6DEDE00D6DEDE00D6DE
      DE00CEDEDE00CEDEDE00CEDEDE00CEDEDE00CEDEDE00CEDEDE00CEDEDE00C6DE
      DE00C6DEDE00C6DEDE00C6D6D600C6DEDE00D6FFFF009CEFC60010BD290021C6
      390029843100BDBDBD00FFFFFF0000000000000000000000000000000000EFE7
      DE00FFE7CE00FFDEC600FFF7EF00FFFFFF00FFFFF700FFF7EF00FFEFE700FFEF
      DE00FFEFE700FFCEB500ADADAD00FFFFFF00F7EFEF00F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6DEC60031BD630042DE840042D67B0039CE6B0031C6630039D6
      730042DE7B0039DE73008CFFB500B5FFCE00B5FFCE00B5FFCE00B5FFCE00BDFF
      D60094E7AD0084BD8C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009CA5A500C6D6E700ADCEDE008CBDD6007BAD
      D6006BB5D6006BBDD60073C6E70084DEEF008CE7F7006BCEF7005AB5D600A5AD
      AD00FFFFFF0000000000000000000000000084B58400A5E7B500ADF7C6004AD6
      6B0031CE520031CE5A0094F7B500F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FF
      FF00EFFFFF00EFFFFF00EFFFFF00EFFFFF00E7FFFF00E7FFFF00E7FFFF00DEFF
      FF00DEFFFF00DEFFFF00DEFFFF00D6FFFF00D6FFFF0094E7B50010B5290021BD
      3900317B3900C6C6C6000000000000000000000000000000000000000000FFFF
      FF00CEC6BD00FFE7CE00FFE7C600FFE7CE00FFF7F700FFFFFF00FFF7F700FFF7
      EF00FFF7EF00FFD6BD00ADADAD00F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000094C6940042C66B0052EF8C0052EF8C0052EF8C0052EF
      8C0052EF8C0094FFBD00DEFFEF00D6FFE700D6FFE700D6FFE700D6FFE700ADDE
      BD009CC69C00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EFF7F700DEE7F700C6DEEF00A5C6DE0084B5D60063A5CE0073A5C600EFEF
      EF000000000000000000000000000000000073AD7300B5EFBD00ADFFC60042D6
      630018BD310029C64A00ADFFC600FFFFFF00F7FFFF00F7FFFF00F7FFFF00F7FF
      FF00F7FFFF00EFFFFF00EFFFFF00EFFFFF00EFFFFF00E7FFFF00E7FFFF00E7FF
      FF00DEFFFF00DEFFFF00DEFFFF00DEFFFF00DEFFFF0084E7A50008B5210018BD
      31004A7B4A00DEDEDE0000000000000000000000000000000000000000000000
      000000000000FFFFFF00E7D6C600FFE7CE00FFDEC600FFE7D600FFFFF700FFFF
      FF00FFFFF700FFDEC600ADADAD00F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00B5D6BD004ABD63004ADE7B0052EF840052EF
      84009CEFB500D6F7DE00DEF7DE00DEF7E700DEF7E700CEEFD6008CBD8C0094C6
      9C00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006BAD6B00BDEFC600A5FFBD005AF7
      940052EF84004AF77B00B5FFCE00FFFFFF00FFFFFF00F7FFFF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00EFFFFF00EFFFFF00EFFFFF00EFFFFF00EFFFFF00EFFF
      FF00EFFFFF00E7FFFF00E7FFFF00E7FFFF00EFFFFF008CEFAD0021C6390010A5
      210094AD9400F7F7F70000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00DEDEDE00FFE7CE00FFE7C600FFE7CE00FFEF
      DE00FFFFFF00FFE7CE00ADADAD00F7F7F7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E7F7E700C6DEC600BDDEBD00BDDE
      BD00C6DEC600C6DEC600C6DEC600C6DEC600C6DEC600C6DEC600EFF7EF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000063AD6B00BDF7CE00C6FFD60094FF
      B50084F7AD008CF7AD00CEF7D600EFF7EF00E7F7E700E7EFE700E7EFE700DEEF
      DE00DEEFDE00D6E7D600CEE7CE00CEE7CE00C6DEC600C6DEC600BDDEBD00B5D6
      BD00BDD6BD00ADD6B500ADD6AD00ADCEAD0094C69C0073B57B0073A57300CED6
      CE00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFE7DE00FFE7CE00FFDE
      C600FFDEC600FFE7C600CECECE00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A5CEA50063AD630063AD6B0063AD
      6B006BAD6B0073AD730073AD730073AD7B007BAD7B007BB57B007BAD7B007BA5
      73008CA56B00739C730094BD94009CC69C00A5C6A500ADCEAD00ADCEAD00B5D6
      B500B5D6B500BDCEBD00C6CEC600C6CEC600CED6CE00D6DED600FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF00E7DE
      CE00FFDEC600D6CEC600FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000C00000000100010000000000000C00000000000000000000
      000000000000000000000000FFFFFF00FFC07FFF000000000000000000000000
      FFC03FFF000000000000000000000000FFC01FFF000000000000000000000000
      FFC00FFF000000000000000000000000FF8003FF000000000000000000000000
      FF8001FF000000000000000000000000FF800001000000000000000000000000
      FF000000000000000000000000000000FF000000000000000000000000000000
      FF000000000000000000000000000000FE000001000000000000000000000000
      FC000001000000000000000000000000F0000003000000000000000000000000
      E0000003000000000000000000000000C0000003000000000000000000000000
      8000000300000000000000000000000000000003000000000000000000000000
      0000000300000000000000000000000000000003000000000000000000000000
      80000001000000000000000000000000C0000001000000000000000000000000
      F0000000000000000000000000000000FC000000000000000000000000000000
      FF000000000000000000000000000000FF000001000000000000000000000000
      FF80000F000000000000000000000000FF8003FF000000000000000000000000
      FFC003FF000000000000000000000000FFC00FFF000000000000000000000000
      FFC00FFF000000000000000000000000FFE03FFF000000000000000000000000
      FFF03FFF000000000000000000000000F80FFF81FFF3FFFFC3FFFFFFFFFFFFFF
      F001FF00FFC0FFFF803FFFFFFFFFFFFFF0000000FFC03FFF8003FFFFFE3FFFFF
      E0000000FF800FFF80001FFFFC1FFFFFE0000000FF8003FF800001FFFC07FFFF
      C0000000FF8001FF8000007FF803FFFFC0000000FF00007F8000007FF800FFFF
      C0000003FF00001F8000003FF8003FFF80000007FE0000078000003FF00003FF
      8000000FFE0000038000003FF00001FF8000000FFE0000038000001FF00000FF
      0000001FFC00000180000007E000003F0000003FFC00000380000001E000000F
      0000003FFC00000380000000E00000010000003FF800000380000000C0000000
      0000007FF800000780000000C00000000000007FF800000700000001C0000000
      0000007FF00000070000000380000000000000FFF000000F0000000380000001
      000000FFE000000F0000000100000001800000FFE000000F0000000100000001
      800000FFE000001F0000000B00000003C00000FFC000001F0000000F00000003
      E00000FFC000003F8000001F00000003F00000FFC000003F8000001F00000007
      F00000FF8000003FC000003F00000007FC0000FFC000007FF000003FC000000F
      FC0000FFC000007FFFC0007FF800000FFF0000FFF000007FFFE0007FFF00000F
      FF0000FFFF8000FFFFF000FFFFFF000FFFF000FFFF8000FFFFF820FFFFFFC01F
      FFFE01FFFFF063FFFFFC79FFFFFFFFFFFC0FFC07FFFFFFFFFFFFFFFFC007FFFF
      F803FC07F03FFFFFFFFFFFFFC000FFFFF003F807E01FFFFFFFC07FFF80000FFF
      F001F807C00FFFFFFF001FFF800001FFE001F8038007FFFFFE0003FF800000FF
      E041F8030003FFFFF80000FF8000007FE001F0030001FFFFE000000F8000007F
      E001F80300007FFFC00000078000007FE001F8070000200FC00000038000007F
      E001FC0F00000007C00000038000007FE001FC0F00000007C00000038000007F
      E001FC0F00000003C00000038000007FE001FC0F80000003C00000038000001F
      E001F807C0000001C000000380000007E001F001F0000000C000000380000000
      E001E001F8000000C000000380000000E001E000F8000000C000000380000000
      E000E000FC0000008000000380000000C0006000FC0000000000000080000000
      C0006000FE000000000000008000000080002000FE0000000000000080000040
      80002000FE00000000000001000000F900002000FE0000018000000F000000FF
      00002000FE000003C000001F000000FF00002000FF000007E000007F000000FF
      00C02000FF00000FF00000FF000000FF00C02000FF80001FF80003FF000000FF
      00C02000FF80003FFC000FFF800000FF80C06000FFC000FFFC007FFF800000FF
      80C06001FFC003FFFE00FFFFC00000FFC0C0E001FFE00FFFFF0FFFFFFC0000FF
      E1C1F007FFFFFFFFFFFFFFFFFFF800FFFFFFFFFFFC7FFFFFFFFF9FFFFCFFFFFF
      FCFFFFFFF81FFFFFFFFC0FFFF83FFFFFF80FFFFFF003FFFFFFF807FFF003FFFF
      F000FFFFF000FFFFFFF003FFF000FFFFF0000FFFF0001FFFFFE001FFF0001FFF
      F00000FFE00003FFFFC000FFE00007FFF000000FC000007FFF80007FC00000FF
      F0000001C000001FFF00003FC000003FF0000000C0000003FE00001FC0000003
      E0000000C0000001FC00000FC0000001C000000080000000F800000780000000
      C000000080000000F000000380000000C000000180000000E000000380000000
      C000000100000000C00000030000000080000001000000008000000700000000
      80000001000000000000000F0000000080000000000000008000001F00000000
      80000001000000000000003F0000000080000001000000000000007F00000000
      00000001000000000000007F0000000000000001000000008000003F00000000
      00000001000000008000001F000000000000000100000000C000000F00000000
      0000000300000000E0000007000000000000000300000000E000000300000000
      F0000003E0000000F0002001E0000000FF000003FFC00000F0007000FFC00000
      FF800007FFF80001F880F800FFF80001FF8003FFFFFF001FF9C1FC01FFFF001F
      FFC007FFFFFF003FFFE7FE03FFFF003FFFF81FFFFFFF003FFFFFFF07FFFF003F
      FFFFFFFFFFFFF0FFFFFFFF8FFFFFF07FFC7FFFFFFFFF9FFFC0000003E0000003
      F81FFFFFFFF80FFFC0000003C0000003F803FFFFFFF807FFC0000001C0000003
      F000FFFFFFF003FFC0000001E0000001F0001FFFFFC001FFE0000001E0000001
      E00007FFFFC000FFE0000001E0000001E000007FFF80007FE0000001F0000001
      C000001FFE00003FE0000001F0000001C0000003FE00001FE0000001F0000001
      C0000001FC00000FE0000001F0000001C0000000F0000007E0000001E0000001
      80000000F0000003E0000001E000000180000000E0000003E0000001E0000003
      8000000080000007C0000003C0000003000000008000000FC0000003C0000003
      000000000000001FC0000003C0000003000000000000003FC0000003C0000003
      000000000000007FC0000003C000000700000000000000FF80000007C0000007
      000000000000007F8000000780000007000000008000003F8000000780000007
      000000008000001F800000078000000F00000000C000000F8000000F8000000F
      00000000C00000078000000F8000000F00000000E0000003C000000FC000000F
      F0000000E0006001E000000FE000000FFFC00000F000F000F000000FF000000F
      FFFC0001F881F800F8000007F800000FFFFF001FF9C3FC01FE000007FE000007
      FFFF001FFFE7FE03FF000007FF000007FFFF803FFFFFFF07FFC00007FFC00007
      FFFFF07FFFFFFF8FFFC00007FFC00007FFFE00FFFFFFFFFFE003FFFFFFFFF3FF
      FFF8001FFFFFFFFFC0007FFFFFFFE03FF0000007FFFFFFFFC00001FFFFE3000F
      E0000007FFF8FFFFC000001FFFC00007E0000007F0087FFFC0000001FE000003
      E000000FE0003FFFC0000000F8000003F000007FC0001FFFC0000000E0000001
      F800003F80000FFFC000000080000001FF00003F000003FFC000000000000003
      FFF0001F000000FF800000000000000FFFF0000F0000001F800000000000003F
      FFF0000F00000003800000000000003FFFE0000700000000800000000000003F
      FFC0000300000000800000000000003FC000000300000000800000000000003F
      C000000300000000800000000000003FC000000F00000000800000000000003F
      C000003F80000000000000008000003FC000003FE0000001000000018000003F
      C000003FF0000001000000018000003FC000007FE0000003000000018000003F
      C000007FE0000003000000018000007FE000007FE000000300000001E00000FF
      E00000FFE000000300000001E00000FFE00000FFE000000300000001E00003FF
      F00000FFF000000700000001E00003FFF00001FFFF80000700000001E0003FFF
      F80003FFFFFE000700000003E000FFFFFC0003FFFFFFF00F00000003F800FFFF
      FC0007FFFFFFFFFF00000003FC00FFFFFF001FFFFFFFFFFF00000007FF80FFFF
      FFFFFFFFFFFFFFFF0000001FFFC1FFFF}
  end
  object pmClients: TPopupMenu
    Left = 328
    Top = 160
    object est11: TMenuItem
      Caption = 
        'Test1 Test1 Test1 Test1 Test1 Test1Test1 Test1 Test1Test1 Test1 ' +
        'Test1Test1 Test1 Test1Test1 Test1 Test1Test1 Test1 Test1Test1 Te' +
        'st1 Test1'
    end
    object est21: TMenuItem
      Caption = 'Test2'
    end
  end
  object adsOrdersHead: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT'
      '    CurrentOrderHeads.OrderId'
      'FROM'
      '    CurrentOrderHeads'
      '    inner join CurrentOrderLists on '
      
        '           (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderI' +
        'd)'
      '       and (CurrentOrderLists.OrderCount > 0)'
      
        '    LEFT JOIN PricesData ON (CurrentOrderHeads.PriceCode=PricesD' +
        'ata.PriceCode)'
      '    left join pricesregionaldata on '
      
        '           (pricesregionaldata.PriceCode = CurrentOrderHeads.Pri' +
        'ceCode) '
      
        '       and (pricesregionaldata.regioncode = CurrentOrderHeads.re' +
        'gioncode)'
      '    LEFT JOIN RegionalData ON '
      
        '           (RegionalData.RegionCode=CurrentOrderHeads.RegionCode' +
        ') '
      '       AND (PricesData.FirmCode=RegionalData.FirmCode)'
      'WHERE'
      '    (CurrentOrderHeads.ClientId = :ClientId)'
      'and (CurrentOrderHeads.Frozen = 0) '
      'and (:Closed = CurrentOrderHeads.Closed)'
      
        'and ((:Closed = 1) or ((:Closed = 0) and (PricesData.PriceCode i' +
        's not null) and (RegionalData.RegionCode is not null) and (price' +
        'sregionaldata.PriceCode is not null)))'
      'and (CurrentOrderHeads.SEND = :Send)'
      'group by CurrentOrderHeads.OrderId')
    Left = 232
    Top = 272
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'Send'
      end>
  end
  object tmrRestoreOnError: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrRestoreOnErrorTimer
    Left = 320
    Top = 240
  end
  object tmrOnExclusive: TTimer
    Enabled = False
    OnTimer = tmrOnExclusiveTimer
    Left = 472
    Top = 272
  end
  object SearchMenu: TPopupMenu
    Left = 288
    Top = 192
    object miOrderAll: TMenuItem
      Action = actOrderAll
      Default = True
    end
    object miSynonymSearch: TMenuItem
      Action = actSynonymSearch
    end
    object miMnnSearch: TMenuItem
      Action = actMnnSearch
    end
    object miShowMinPrices: TMenuItem
      Action = actShowMinPrices
    end
    object miAwaitedProducts: TMenuItem
      Action = actAwaitedProducts
    end
  end
  object JunkMenu: TPopupMenu
    Left = 328
    Top = 192
    object miSale: TMenuItem
      Action = actSale
      Default = True
    end
    object miDefectives: TMenuItem
      Action = actDefectives
    end
  end
  object WaybillMenu: TPopupMenu
    Left = 368
    Top = 192
    object miViewDocs: TMenuItem
      Action = actViewDocs
      Default = True
    end
    object miWayBill: TMenuItem
      Action = actWayBill
    end
  end
  object ConfigMenu: TPopupMenu
    Left = 408
    Top = 192
    object miConfig: TMenuItem
      Action = actConfig
      Default = True
    end
    object miHome: TMenuItem
      Action = actHome
    end
  end
  object tmrOnNeedUpdate: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrOnNeedUpdateTimer
    Left = 360
    Top = 280
  end
  object tmrNeedUpdateCheck: TTimer
    Enabled = False
    Interval = 20000
    OnTimer = tmrNeedUpdateCheckTimer
    Left = 408
    Top = 280
  end
  object tmrStartUp: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrStartUpTimer
    Left = 656
    Top = 282
  end
  object shIndexTemplate: TStrHolder
    Capacity = 118
    Macros = <
      item
      end
      item
        Name = 'InforoomLogo'
      end
      item
        Name = 'TechContact'
      end
      item
        Name = 'TechOperatingMode'
      end>
    Left = 368
    Top = 311
    InternalVer = 1
    StrData = (
      ''
      
        '3c21444f43545950452048544d4c205055424c494320222d2f2f5733432f2f44' +
        '54442048544d4c20342e30205472616e736974696f6e616c2f2f454e223e'
      '3c68746d6c3e'
      '3c686561643e'
      '20203c7469746c653e3c2f7469746c653e'
      
        '20203c6d657461206e616d653d2276735f746172676574536368656d61222063' +
        '6f6e74656e743d22687474703a2f2f736368656d61732e6d6963726f736f6674' +
        '2e636f6d2f696e74656c6c6973656e73652f696535223e'
      
        '20203c6d65746120687474702d65717569763d22436f6e74656e742d54797065' +
        '2220636f6e74656e743d22746578742f68746d6c3b20636861727365743d7769' +
        '6e646f77732d31323531223e'
      '20203c7374796c6520747970653d22746578742f637373223e'
      '3c212d2d'
      '626f64792c74642c7468207b'
      
        '09666f6e742d66616d696c793a2056657264616e612c2047656e6576612c2073' +
        '616e732d73657269663b'
      '09666f6e742d73697a653a20313370783b'
      '7d'
      '2e636f6e7461637454657874207b'
      '09666f6e742d73697a653a20736d616c6c3b'
      
        '09666f6e742d66616d696c793a2056657264616e612c20417269616c2c204865' +
        '6c7665746963612c2073616e732d73657269663b'
      '7d'
      '2e446174615461626c65207b'
      '096261636b67726f756e642d636f6c6f723a20234542454245423b'
      '09626f726465723a20736f6c69642031707820234441444144413b'
      '0977696474683a20313030253b'
      '09746578742d616c69676e3a206c6566743b'
      '7d'
      '2e446174615461626c65202e4576656e526f772c2074722e6576656e'
      '7b'
      '096261636b67726f756e642d636f6c6f723a20234636463646363b'
      '7d'
      ''
      '2e446174615461626c65202e4f6464526f772c2074722e6f6464'
      '7b'
      '096261636b67726f756e642d636f6c6f723a20234545463846463b'
      '7d'
      ''
      '2e446174615461626c65202e43656c6c44617461'
      '7b'
      '09746578742d616c69676e3a206c6566743b'
      '7d'
      ''
      
        '2ec6e8f0edfbe9f1e8ede8e9207b09666f6e742d66616d696c793a2056657264' +
        '616e612c2047656e6576612c2073616e732d73657269663b'
      '09666f6e742d73697a653a20313370783b'
      '09666f6e742d7374796c653a206e6f726d616c3b'
      '09666f6e742d7765696768743a20626f6c643b'
      '09636f6c6f723a20233030463b'
      '09746578742d616c69676e3a2063656e7465723b'
      '7d'
      '2ecaf0e0f1edfbe9207b'
      '09636f6c6f723a20233930303b'
      '09666f6e742d73697a653a20313570783b'
      '7d'
      
        '2ecaf0e0f1edfbe9e6e8f0edfbe9efeee4f7e5f0eaedf3f2fbe9207b09666f6e' +
        '742d7765696768743a20626f6c643b'
      '09636f6c6f723a20233930303b'
      '09746578742d6465636f726174696f6e3a20756e6465726c696e653b'
      '7d'
      '2ed1e8ede8e9207b09636f6c6f723a20233030463b'
      '7d'
      '2ed7e5f0edfbe9207b09636f6c6f723a20233030303b'
      '7d'
      '235461626c6531207472207464207461626c652074722074642070207b'
      '09746578742d616c69676e3a206a7573746966793b'
      '7d'
      '696d67207b'
      
        '09636c69703a2072656374286175746f2c6175746f2c6175746f2c6175746f29' +
        '3b'
      '7d'
      ''
      '7d'
      '23e6e8f0edfbe9207b'
      '09666f6e742d7765696768743a20626f6c643b'
      '7d'
      '2d2d3e'
      '202020203c2f7374796c653e'
      '3c2f686561643e'
      
        '3c626f6479206267436f6c6f723d222366666666666622206c696e6b3d222330' +
        '30393365312220766c696e6b3d22236162353163632220616c696e6b3d222330' +
        '3039336531223e'
      
        '3c5441424c452069643d225461626c6531222063656c6c53706163696e673d22' +
        '30222063656c6c50616464696e673d2230222077696474683d22313030252220' +
        '626f726465723d2230223e'
      '20203c54523e20'
      
        '202020203c54442077696474683d223239352220616c69676e3d226c65667422' +
        '2076616c69676e3d22746f70223e'
      
        '2020202020203c7461626c652077696474683d22313030252220626f72646572' +
        '3d2230222063656c6c70616464696e673d2230222063656c6c73706163696e67' +
        '3d2230223e'
      '20202020202020203c74723e20'
      
        '202020202020202020203c74643e3c696d67207372633d25496e666f726f6f6d' +
        '4c6f676f2077696474683d2232343822206865696768743d223835223e3c2f74' +
        '643e'
      '20202020202020203c2f74723e'
      '20202020202020203c74723e20'
      '202020202020202020203c7464206865696768743d223130223e3c2f74643e'
      '20202020202020203c2f74723e'
      '20202020202020203c74723e20'
      
        '202020202020202020203c746420636c6173733d22636f6e7461637454657874' +
        '223ed6e5edf2f0e0ebe8e7eee2e0edede0ff20f1ebf3e6e1e020efeee4e4e5f0' +
        'e6eae820efeeebfce7eee2e0f2e5ebe5e93a3c2f74643e'
      '20202020202020203c2f74723e'
      '20202020202020203c74723e20'
      
        '202020202020202020203c746420636c6173733d22636f6e7461637454657874' +
        '223e'
      '202020202020202020202554656368436f6e74616374'
      '202020202020202020203c2f74643e'
      '20202020202020203c2f74723e20202020202020'
      '20202020202020203c74723e20'
      
        '202020202020202020203c746420636c6173733d22636f6e7461637454657874' +
        '223ed0e5e6e8ec20f0e0e1eef2fb3a3c2f74643e'
      '20202020202020203c2f74723e'
      '20202020202020203c74723e20'
      
        '202020202020202020203c746420636c6173733d22636f6e7461637454657874' +
        '223e'
      '2020202020202020202025546563684f7065726174696e674d6f6465'
      '202020202020202020203c2f74643e'
      '20202020202020203c2f74723e20202020202020'
      '20202020202020203c74723e20'
      
        '202020202020202020203c746420636c6173733d22636f6e7461637454657874' +
        '223e452d6d61696c3a203c6120687265663d227465636840616e616c69742e6e' +
        '6574223e7465636840616e616c69742e6e65743c2f613e3c2f74643e'
      '20202020202020203c2f74723e'
      '20202020202020203c74723e20'
      
        '202020202020202020203c74642020636c6173733d22636f6e74616374546578' +
        '74223e3c6120687265663d22687474703a2f2f7777772e616e616c69742e6e65' +
        '7422207461726765743d225f626c616e6b223e7777772e616e616c69742e6e65' +
        '743c2f613e3c2f74643e'
      '20202020202020203c2f74723e'
      '2020202020203c2f7461626c653e'
      '202020203c2f54443e'
      '20203c2f74723e'
      '3c2f5441424c453e'
      '3c2f626f64793e'
      '3c2f68746d6c3e')
  end
  object dsNews: TDataSource
    DataSet = adsNews
    Left = 265
    Top = 340
  end
  object adsNews: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      
        'select Id , PublicationDate , Header from News order by Publicat' +
        'ionDate desc')
    Left = 304
    Top = 344
  end
end
