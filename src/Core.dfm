object CoreForm: TCoreForm
  Left = 205
  Top = 138
  Align = alClient
  BorderIcons = []
  BorderStyle = bsNone
  Caption = #1057#1074#1086#1076#1085#1099#1081' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090
  ClientHeight = 479
  ClientWidth = 792
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object plOverCost: TPanel
    Left = 248
    Top = 192
    Width = 305
    Height = 57
    Caption = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1089#1088#1077#1076#1085#1077#1081' '#1094#1077#1085#1099'!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Visible = False
  end
  object pBottom: TPanel
    Left = 0
    Top = 348
    Width = 792
    Height = 131
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object gbPrevOrders: TGroupBox
      Left = 0
      Top = 0
      Width = 482
      Height = 131
      Align = alLeft
      Caption = ' '#1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1079#1072#1082#1072#1079#1099' '
      TabOrder = 0
      object lblPriceAvg: TLabel
        Left = 8
        Top = 110
        Width = 244
        Height = 13
        Caption = #1057#1088#1077#1076#1085#1103#1103' '#1094#1077#1085#1072' '#1087#1086' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1084' '#1079#1072#1082#1072#1079#1072#1084' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtPriceAvg: TDBText
        Left = 258
        Top = 110
        Width = 70
        Height = 13
        AutoSize = True
        DataField = 'PriceAvg'
        DataSource = dsOrdersShowFormSummary
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbgHistory: TToughDBGrid
        Left = 8
        Top = 16
        Width = 465
        Height = 87
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
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        VertScrollBar.VisibleMode = sbNeverShowEh
        OnGetCellParams = dbgHistoryGetCellParams
        SearchPosition = spBottom
        Columns = <
          item
            EditButtons = <>
            FieldName = 'PriceName'
            Footers = <>
            Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
            Width = 110
          end
          item
            EditButtons = <>
            FieldName = 'SynonymFirm'
            Footers = <>
            Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            Width = 102
          end
          item
            EditButtons = <>
            FieldName = 'Order'
            Footers = <>
            Title.Caption = #1047#1072#1082#1072#1079
            Width = 38
          end
          item
            EditButtons = <>
            FieldName = 'Price'
            Footers = <>
            Title.Caption = #1062#1077#1085#1072
            Width = 49
          end
          item
            Alignment = taCenter
            DisplayFormat = 'dd.mm.yyyy'
            EditButtons = <>
            FieldName = 'OrderDate'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072
            Width = 68
          end>
      end
    end
    object gbFirmInfo: TGroupBox
      Left = 482
      Top = 0
      Width = 310
      Height = 131
      Align = alClient
      Caption = ' '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1092#1080#1088#1084#1077' '
      TabOrder = 1
      DesignSize = (
        310
        131)
      object lblSupportPhone: TLabel
        Left = 6
        Top = 16
        Width = 61
        Height = 13
        Caption = #1058#1077#1083#1077#1092#1086#1085' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtSupportPhone: TDBText
        Left = 73
        Top = 16
        Width = 99
        Height = 13
        AutoSize = True
        DataField = 'SupportPhone'
        DataSource = dsFirmsInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbmContactInfo: TDBMemo
        Left = 6
        Top = 32
        Width = 301
        Height = 93
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        DataField = 'OperativeInfo'
        DataSource = dsFirmsInfo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      792
      29)
    object lblName: TLabel
      Left = 7
      Top = 6
      Width = 59
      Height = 16
      Caption = 'lblName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbFilter: TComboBox
      Left = 646
      Top = 4
      Width = 143
      Height = 21
      Hint = #1054#1090#1073#1086#1088' '#1079#1072#1087#1080#1089#1077#1081
      Style = csDropDownList
      Anchors = [akTop, akRight]
      DropDownCount = 30
      ItemHeight = 13
      TabOrder = 0
      OnSelect = cbFilterSelect
    end
    object cbEnabled: TComboBox
      Left = 497
      Top = 4
      Width = 143
      Height = 21
      Hint = #1054#1090#1073#1086#1088' '#1079#1072#1087#1080#1089#1077#1081
      Style = csDropDownList
      Anchors = [akTop, akRight]
      DropDownCount = 30
      ItemHeight = 13
      TabOrder = 1
      OnSelect = cbFilterSelect
      Items.Strings = (
        #1042#1089#1077
        #1054#1089#1085#1086#1074#1085#1099#1077
        #1053#1077#1086#1089#1085#1086#1074#1085#1099#1077)
    end
  end
  object pCenter: TPanel
    Left = 0
    Top = 29
    Width = 792
    Height = 319
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object pWebBrowser: TPanel
      Tag = 84
      Left = 0
      Top = 235
      Width = 792
      Height = 84
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 792
        Height = 4
        Align = alTop
        Shape = bsTopLine
      end
      object WebBrowser1: TWebBrowser
        Tag = 3
        Left = 0
        Top = 4
        Width = 792
        Height = 80
        Align = alClient
        TabOrder = 0
        ControlData = {
          4C000000DB510000450800000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object dbgCore: TToughDBGrid
      Left = 0
      Top = 0
      Width = 792
      Height = 235
      Align = alClient
      AutoFitColWidths = True
      DataSource = dsCore
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
      OnGetCellParams = dbgCoreGetCellParams
      OnKeyDown = dbgCoreKeyDown
      OnKeyPress = dbgCoreKeyPress
      InputField = 'Order'
      SearchPosition = spTop
      OnCanInput = dbgCoreCanInput
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Synonym'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
          Width = 196
        end
        item
          EditButtons = <>
          FieldName = 'SynonymFirm'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Width = 85
        end
        item
          EditButtons = <>
          FieldName = 'Volume'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Width = 63
        end
        item
          EditButtons = <>
          FieldName = 'Note'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Width = 69
        end
        item
          Alignment = taCenter
          EditButtons = <>
          FieldName = 'Period'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
          Width = 85
        end
        item
          EditButtons = <>
          FieldName = 'PriceName'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Width = 85
        end
        item
          EditButtons = <>
          FieldName = 'RegionName'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Width = 72
        end
        item
          Alignment = taCenter
          Checkboxes = False
          EditButtons = <>
          FieldName = 'Storage'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1057#1082#1083#1072#1076
          Width = 37
        end
        item
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'DatePrice'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Width = 103
        end
        item
          EditButtons = <>
          FieldName = 'BaseCost'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Footers = <>
          MinWidth = 5
          Title.Caption = #1062#1077#1085#1072
          Width = 55
        end
        item
          EditButtons = <>
          FieldName = 'PriceDelta'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1056#1072#1079#1085#1080#1094#1072', %'
        end
        item
          EditButtons = <>
          FieldName = 'PriceRet'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
          Width = 62
        end
        item
          Alignment = taRightJustify
          EditButtons = <>
          FieldName = 'Quantity'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          Width = 68
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'Order'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1047#1072#1082#1072#1079
          Width = 47
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1057#1091#1084#1084#1072
          Width = 70
        end>
    end
  end
  object dsCore: TDataSource
    DataSet = adsCore
    Left = 64
    Top = 168
  end
  object frdsCore: TfrDBDataSet
    DataSource = dsCore
    OpenDataSource = False
    Left = 64
    Top = 216
  end
  object dsOrders: TDataSource
    DataSet = adsOrders
    Left = 176
    Top = 400
  end
  object adsOrders: TADODataSet
    AutoCalcFields = False
    Connection = DM.MainConnection
    CursorLocation = clUseServer
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM OrdersShowByForm'
    DataSource = dsCore
    MasterFields = 'AFullCode'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'AFullCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    Prepared = True
    Left = 176
    Top = 352
    object adsOrdersPriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 25
    end
    object adsOrdersSynonym: TWideStringField
      FieldName = 'Synonym'
      Size = 255
    end
    object adsOrdersSynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsOrdersOrder: TIntegerField
      FieldName = 'Order'
    end
    object adsOrdersPrice: TBCDField
      FieldName = 'Price'
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
    end
    object adsOrdersOrderDate: TDateTimeField
      FieldName = 'OrderDate'
    end
    object adsOrdersAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsOrdersJunk: TBooleanField
      FieldName = 'Junk'
    end
  end
  object adsOrdersH: TADODataSet
    AutoCalcFields = False
    Connection = DM.MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM OrdersHShowCurrent'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 1
      end
      item
        Name = 'APriceCode'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 31
      end
      item
        Name = 'ARegionCode'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 1
      end>
    Prepared = True
    Left = 240
    Top = 120
  end
  object adsOrdersShowFormSummary: TADODataSet
    Connection = DM.MainConnection
    CursorLocation = clUseServer
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM OrdersShowFormSummary'
    MasterFields = 'AFullCode'
    Parameters = <
      item
        Name = 'AFullCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    Prepared = True
    Left = 296
    Top = 352
    object adsOrdersShowFormSummaryPriceAvg: TBCDField
      FieldName = 'PriceAvg'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      Precision = 19
    end
  end
  object dsOrdersShowFormSummary: TDataSource
    DataSet = adsOrdersShowFormSummary
    Left = 296
    Top = 400
  end
  object adsFirmsInfo: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    CommandText = 
      'SELECT FirmCode, RegionCode, SupportPhone, OperativeInfo FROM Re' +
      'gionalData'
    DataSource = dsCore
    MasterFields = 'FirmCode;RegionCode'
    Parameters = <>
    Left = 568
    Top = 384
  end
  object dsFirmsInfo: TDataSource
    DataSet = adsFirmsInfo
    Left = 568
    Top = 424
  end
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerTimer
    Left = 640
    Top = 216
  end
  object adsCore: TADODataSet
    AutoCalcFields = False
    Connection = DM.MainConnection
    CursorLocation = clUseServer
    AfterOpen = adsCoreAfterOpen
    BeforeClose = adsCoreBeforeClose
    BeforeEdit = adsCoreBeforeEdit
    BeforePost = adsCoreBeforePost
    AfterPost = adsCoreAfterPost
    AfterScroll = adsCoreAfterScroll
    OnCalcFields = adsCoreCalcFields
    CommandText = 'SELECT * FROM CoreShowByName'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '928'
      end
      item
        Name = 'TimeZoneBias'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '-240'
      end
      item
        Name = 'ParentCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '5'
      end
      item
        Name = 'ShowRegister'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '0'
      end
      item
        Name = 'RegisterId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '0'
      end>
    Left = 64
    Top = 120
    object adsCoreCoreId: TAutoIncField
      FieldName = 'CoreId'
      ReadOnly = True
    end
    object adsCoreFirmCode: TAutoIncField
      FieldName = 'FirmCode'
      ReadOnly = True
    end
    object adsCorePriceCode: TIntegerField
      FieldName = 'PriceCode'
    end
    object adsCoreRegionCode: TIntegerField
      FieldName = 'RegionCode'
    end
    object adsCoreAFullCode: TIntegerField
      FieldName = 'AFullCode'
    end
    object adsCoreShortCode: TIntegerField
      FieldName = 'ShortCode'
    end
    object adsCoreCodeFirmCr: TIntegerField
      FieldName = 'CodeFirmCr'
    end
    object adsCoreSynonymCode: TIntegerField
      FieldName = 'SynonymCode'
    end
    object adsCoreSynonymFirmCrCode: TIntegerField
      FieldName = 'SynonymFirmCrCode'
    end
    object adsCoreCode: TWideStringField
      FieldName = 'Code'
    end
    object adsCoreCodeCr: TWideStringField
      FieldName = 'CodeCr'
    end
    object adsCorePeriod: TWideStringField
      FieldName = 'Period'
    end
    object adsCoreSale: TSmallintField
      FieldName = 'Sale'
      ReadOnly = True
    end
    object adsCoreVolume: TWideStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsCoreNote: TWideStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsCoreBaseCost: TBCDField
      FieldName = 'BaseCost'
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
    end
    object adsCoreQuantity: TWideStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsCoreAwait: TBooleanField
      FieldName = 'Await'
      DisplayValues = '+;'
    end
    object adsCoreJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsCoreSynonym: TWideStringField
      FieldName = 'Synonym'
      OnGetText = adsCoreSynonymGetText
      Size = 255
    end
    object adsCoreSynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsCoreDatePrice: TDateTimeField
      FieldName = 'DatePrice'
      ReadOnly = True
    end
    object adsCorePriceEnabled: TBooleanField
      FieldName = 'PriceEnabled'
    end
    object adsCorePriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 25
    end
    object adsCoreStorage: TBooleanField
      FieldName = 'Storage'
      DisplayValues = '+;'
    end
    object adsCoreRegionName: TWideStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsCoreOrdersCoreId: TIntegerField
      FieldName = 'OrdersCoreId'
    end
    object adsCoreOrdersOrderId: TIntegerField
      FieldName = 'OrdersOrderId'
    end
    object adsCoreOrdersClientId: TSmallintField
      FieldName = 'OrdersClientId'
    end
    object adsCoreOrdersFullCode: TIntegerField
      FieldName = 'OrdersFullCode'
    end
    object adsCoreOrdersCodeFirmCr: TIntegerField
      FieldName = 'OrdersCodeFirmCr'
    end
    object adsCoreOrdersSynonymCode: TIntegerField
      FieldName = 'OrdersSynonymCode'
    end
    object adsCoreOrdersSynonymFirmCrCode: TIntegerField
      FieldName = 'OrdersSynonymFirmCrCode'
    end
    object adsCoreOrdersCode: TWideStringField
      FieldName = 'OrdersCode'
    end
    object adsCoreOrdersCodeCr: TWideStringField
      FieldName = 'OrdersCodeCr'
    end
    object adsCoreOrder: TIntegerField
      FieldName = 'Order'
      DisplayFormat = '#'
    end
    object adsCoreOrdersSynonym: TWideStringField
      FieldName = 'OrdersSynonym'
      Size = 255
    end
    object adsCoreOrdersSynonymFirm: TWideStringField
      FieldName = 'OrdersSynonymFirm'
      Size = 50
    end
    object adsCoreOrdersPrice: TBCDField
      FieldName = 'OrdersPrice'
      Precision = 19
    end
    object adsCoreOrdersJunk: TBooleanField
      FieldName = 'OrdersJunk'
    end
    object adsCoreOrdersAwait: TBooleanField
      FieldName = 'OrdersAwait'
    end
    object adsCoreOrdersHOrderId: TAutoIncField
      FieldName = 'OrdersHOrderId'
      ReadOnly = True
    end
    object adsCoreOrdersHClientId: TSmallintField
      FieldName = 'OrdersHClientId'
    end
    object adsCoreOrdersHPriceCode: TIntegerField
      FieldName = 'OrdersHPriceCode'
    end
    object adsCoreOrdersHRegionCode: TIntegerField
      FieldName = 'OrdersHRegionCode'
    end
    object adsCoreOrdersHPriceName: TWideStringField
      FieldName = 'OrdersHPriceName'
      Size = 25
    end
    object adsCoreOrdersHRegionName: TWideStringField
      FieldName = 'OrdersHRegionName'
      Size = 25
    end
    object adsCoreSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCorePriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCorePriceDelta: TFloatField
      FieldKind = fkCalculated
      FieldName = 'PriceDelta'
      DisplayFormat = '0.0;;'#39#39
      Calculated = True
    end
  end
  object adsRegions: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    CommandText = 'SELECT * FROM Regions'
    Parameters = <>
    Left = 152
    Top = 120
  end
  object ActionList: TActionList
    Left = 240
    Top = 184
    object actFlipCore: TAction
      ShortCut = 113
      OnExecute = actFlipCoreExecute
    end
  end
end
