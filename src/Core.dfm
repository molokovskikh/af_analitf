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
  KeyPreview = True
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
            FieldName = 'PRICENAME'
            Footers = <>
            Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
            Width = 110
          end
          item
            EditButtons = <>
            FieldName = 'SYNONYMFIRM'
            Footers = <>
            Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            Width = 102
          end
          item
            EditButtons = <>
            FieldName = 'ORDERCOUNT'
            Footers = <>
            Title.Caption = #1047#1072#1082#1072#1079
            Width = 38
          end
          item
            EditButtons = <>
            FieldName = 'PRICE'
            Footers = <>
            Title.Caption = #1062#1077#1085#1072
            Width = 49
          end
          item
            Alignment = taCenter
            DisplayFormat = 'dd.mm.yyyy'
            EditButtons = <>
            FieldName = 'ORDERDATE'
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
      InputField = 'OrderCount'
      SearchPosition = spTop
      OnCanInput = dbgCoreCanInput
      Columns = <
        item
          EditButtons = <>
          FieldName = 'SYNONYMNAME'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
          Width = 196
        end
        item
          EditButtons = <>
          FieldName = 'SYNONYMFIRM'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Width = 85
        end
        item
          EditButtons = <>
          FieldName = 'VOLUME'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1059#1087#1072#1082#1086#1074#1082#1072
          Width = 63
        end
        item
          EditButtons = <>
          FieldName = 'NOTE'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          Width = 69
        end
        item
          Alignment = taCenter
          EditButtons = <>
          FieldName = 'PERIOD'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
          Width = 85
        end
        item
          EditButtons = <>
          FieldName = 'PRICENAME'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Width = 85
        end
        item
          EditButtons = <>
          FieldName = 'REGIONNAME'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Width = 72
        end
        item
          Alignment = taCenter
          Checkboxes = False
          EditButtons = <>
          FieldName = 'STORAGE'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1057#1082#1083#1072#1076
          Width = 37
        end
        item
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'DATEPRICE'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Width = 103
        end
        item
          EditButtons = <>
          FieldName = 'BASECOST'
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
          FieldName = 'QUANTITY'
          Footers = <>
          MinWidth = 5
          Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          Width = 68
        end
        item
          Color = 16775406
          EditButtons = <>
          FieldName = 'ORDERCOUNT'
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
    Left = 152
    Top = 408
  end
  object adsOrders2: TADODataSet
    AutoCalcFields = False
    CursorLocation = clUseServer
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM OrdersShowByForm'
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
    Left = 152
    Top = 360
    object adsOrders2PriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 25
    end
    object adsOrders2Synonym: TWideStringField
      FieldName = 'Synonym'
      Size = 255
    end
    object adsOrders2SynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsOrders2Order: TIntegerField
      FieldName = 'Order'
    end
    object adsOrders2Price: TBCDField
      FieldName = 'Price'
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
    end
    object adsOrders2OrderDate: TDateTimeField
      FieldName = 'OrderDate'
    end
    object adsOrders2Await: TBooleanField
      FieldName = 'Await'
    end
    object adsOrders2Junk: TBooleanField
      FieldName = 'Junk'
    end
  end
  object adsOrdersH2: TADODataSet
    AutoCalcFields = False
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
  object adsOrdersShowFormSummary2: TADODataSet
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
    object adsOrdersShowFormSummary2PriceAvg: TBCDField
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
  object adsFirmsInfo2: TADODataSet
    CursorType = ctStatic
    CommandText = 
      'SELECT FirmCode, RegionCode, SupportPhone, OperativeInfo FROM Re' +
      'gionalData'
    MasterFields = 'FirmCode;RegionCode'
    Parameters = <>
    Left = 584
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
  object adsCore2: TADODataSet
    AutoCalcFields = False
    CursorLocation = clUseServer
    AfterOpen = adsCore2AfterOpen
    BeforeClose = adsCore2BeforeClose
    BeforeEdit = adsCore2BeforeEdit
    BeforePost = adsCore2BeforePost
    AfterPost = adsCore2AfterPost
    AfterScroll = adsCore2AfterScroll
    OnCalcFields = adsCore2CalcFields
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
    Top = 88
    object adsCore2CoreId: TAutoIncField
      FieldName = 'CoreId'
      ReadOnly = True
    end
    object adsCore2FirmCode: TAutoIncField
      FieldName = 'FirmCode'
      ReadOnly = True
    end
    object adsCore2PriceCode: TIntegerField
      FieldName = 'PriceCode'
    end
    object adsCore2RegionCode: TIntegerField
      FieldName = 'RegionCode'
    end
    object adsCore2AFullCode: TIntegerField
      FieldName = 'AFullCode'
    end
    object adsCore2ShortCode: TIntegerField
      FieldName = 'ShortCode'
    end
    object adsCore2CodeFirmCr: TIntegerField
      FieldName = 'CodeFirmCr'
    end
    object adsCore2SynonymCode: TIntegerField
      FieldName = 'SynonymCode'
    end
    object adsCore2SynonymFirmCrCode: TIntegerField
      FieldName = 'SynonymFirmCrCode'
    end
    object adsCore2Code: TWideStringField
      FieldName = 'Code'
    end
    object adsCore2CodeCr: TWideStringField
      FieldName = 'CodeCr'
    end
    object adsCore2Period: TWideStringField
      FieldName = 'Period'
    end
    object adsCore2Sale: TSmallintField
      FieldName = 'Sale'
      ReadOnly = True
    end
    object adsCore2Volume: TWideStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsCore2Note: TWideStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsCore2BaseCost: TBCDField
      FieldName = 'BaseCost'
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
    end
    object adsCore2Quantity: TWideStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsCore2Await: TBooleanField
      FieldName = 'Await'
      DisplayValues = '+;'
    end
    object adsCore2Junk: TBooleanField
      FieldName = 'Junk'
    end
    object adsCore2Synonym: TWideStringField
      FieldName = 'Synonym'
      OnGetText = adsCore2SynonymGetText
      Size = 255
    end
    object adsCore2SynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsCore2DatePrice: TDateTimeField
      FieldName = 'DatePrice'
      ReadOnly = True
    end
    object adsCore2PriceEnabled: TBooleanField
      FieldName = 'PriceEnabled'
    end
    object adsCore2PriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 25
    end
    object adsCore2Storage: TBooleanField
      FieldName = 'Storage'
      DisplayValues = '+;'
    end
    object adsCore2RegionName: TWideStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsCore2OrdersCoreId: TIntegerField
      FieldName = 'OrdersCoreId'
    end
    object adsCore2OrdersOrderId: TIntegerField
      FieldName = 'OrdersOrderId'
    end
    object adsCore2OrdersClientId: TSmallintField
      FieldName = 'OrdersClientId'
    end
    object adsCore2OrdersFullCode: TIntegerField
      FieldName = 'OrdersFullCode'
    end
    object adsCore2OrdersCodeFirmCr: TIntegerField
      FieldName = 'OrdersCodeFirmCr'
    end
    object adsCore2OrdersSynonymCode: TIntegerField
      FieldName = 'OrdersSynonymCode'
    end
    object adsCore2OrdersSynonymFirmCrCode: TIntegerField
      FieldName = 'OrdersSynonymFirmCrCode'
    end
    object adsCore2OrdersCode: TWideStringField
      FieldName = 'OrdersCode'
    end
    object adsCore2OrdersCodeCr: TWideStringField
      FieldName = 'OrdersCodeCr'
    end
    object adsCore2Order: TIntegerField
      FieldName = 'Order'
      DisplayFormat = '#'
    end
    object adsCore2OrdersSynonym: TWideStringField
      FieldName = 'OrdersSynonym'
      Size = 255
    end
    object adsCore2OrdersSynonymFirm: TWideStringField
      FieldName = 'OrdersSynonymFirm'
      Size = 50
    end
    object adsCore2OrdersPrice: TBCDField
      FieldName = 'OrdersPrice'
      Precision = 19
    end
    object adsCore2OrdersJunk: TBooleanField
      FieldName = 'OrdersJunk'
    end
    object adsCore2OrdersAwait: TBooleanField
      FieldName = 'OrdersAwait'
    end
    object adsCore2OrdersHOrderId: TAutoIncField
      FieldName = 'OrdersHOrderId'
      ReadOnly = True
    end
    object adsCore2OrdersHClientId: TSmallintField
      FieldName = 'OrdersHClientId'
    end
    object adsCore2OrdersHPriceCode: TIntegerField
      FieldName = 'OrdersHPriceCode'
    end
    object adsCore2OrdersHRegionCode: TIntegerField
      FieldName = 'OrdersHRegionCode'
    end
    object adsCore2OrdersHPriceName: TWideStringField
      FieldName = 'OrdersHPriceName'
      Size = 25
    end
    object adsCore2OrdersHRegionName: TWideStringField
      FieldName = 'OrdersHRegionName'
      Size = 25
    end
    object adsCore2SumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCore2PriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      DisplayFormat = '0.00;;'#39#39
      Calculated = True
    end
    object adsCore2PriceDelta: TFloatField
      FieldKind = fkCalculated
      FieldName = 'PriceDelta'
      DisplayFormat = '0.0;;'#39#39
      Calculated = True
    end
  end
  object adsRegions2: TADODataSet
    CursorType = ctStatic
    CommandText = 'SELECT * FROM Regions'
    Parameters = <>
    Left = 152
    Top = 120
  end
  object ActionList: TActionList
    Left = 352
    Top = 192
    object actFlipCore: TAction
      ShortCut = 113
      OnExecute = actFlipCoreExecute
    end
  end
  object adsCore: TpFIBDataSet
    UpdateSQL.Strings = (
      
        'execute procedure updateordercount(:new_ORDERSHORDERID, :Aclient' +
        'id, :new_PRICECODE, :new_REGIONCODE, :new_ORDERSORDERID, :new_CO' +
        'REID, :NEW_ORDERCOUNT)')
    RefreshSQL.Strings = (
      'SELECT'
      '    COREID,'
      '    PRICECODE,'
      '    REGIONCODE,'
      '    FULLCODE,'
      '    SHORTCODE,'
      '    CODEFIRMCR,'
      '    SYNONYMCODE,'
      '    SYNONYMFIRMCRCODE,'
      '    CODE,'
      '    CODECR,'
      '    PERIOD,'
      '    SALE,'
      '    VOLUME,'
      '    NOTE,'
      '    BASECOST,'
      '    QUANTITY,'
      '    AWAIT,'
      '    JUNK,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    DATEPRICE,'
      '    PRICENAME,'
      '    PRICEENABLED,'
      '    FIRMCODE,'
      '    STORAGE,'
      '    REGIONNAME,'
      '    ORDERSCOREID,'
      '    ORDERSORDERID,'
      '    ORDERSCLIENTID,'
      '    ORDERSFULLCODE,'
      '    ORDERSCODEFIRMCR,'
      '    ORDERSSYNONYMCODE,'
      '    ORDERSSYNONYMFIRMCRCODE,'
      '    ORDERSCODE,'
      '    ORDERSCODECR,'
      '    ORDERCOUNT,'
      '    ORDERSSYNONYM,'
      '    ORDERSSYNONYMFIRM,'
      '    ORDERSPRICE,'
      '    ORDERSJUNK,'
      '    ORDERSAWAIT,'
      '    ORDERSHORDERID,'
      '    ORDERSHCLIENTID,'
      '    ORDERSHPRICECODE,'
      '    ORDERSHREGIONCODE,'
      '    ORDERSHPRICENAME,'
      '    ORDERSHREGIONNAME'
      'FROM'
      '    CORESHOWBYNAME(:ACLIENTID,'
      '    :TIMEZONEBIAS,'
      '    :PARENTCODE,'
      '    :SHOWREGISTER,'
      '    :REGISTERID) '
      'where'
      '  COREID = :OLD_COREID')
    SelectSQL.Strings = (
      'SELECT'
      '    COREID,'
      '    PRICECODE,'
      '    REGIONCODE,'
      '    FULLCODE,'
      '    SHORTCODE,'
      '    CODEFIRMCR,'
      '    SYNONYMCODE,'
      '    SYNONYMFIRMCRCODE,'
      '    CODE,'
      '    CODECR,'
      '    PERIOD,'
      '    SALE,'
      '    VOLUME,'
      '    NOTE,'
      '    BASECOST,'
      '    QUANTITY,'
      '    AWAIT,'
      '    JUNK,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    DATEPRICE,'
      '    PRICENAME,'
      '    PRICEENABLED,'
      '    FIRMCODE,'
      '    STORAGE,'
      '    REGIONNAME,'
      '    ORDERSCOREID,'
      '    ORDERSORDERID,'
      '    ORDERSCLIENTID,'
      '    ORDERSFULLCODE,'
      '    ORDERSCODEFIRMCR,'
      '    ORDERSSYNONYMCODE,'
      '    ORDERSSYNONYMFIRMCRCODE,'
      '    ORDERSCODE,'
      '    ORDERSCODECR,'
      '    ORDERCOUNT,'
      '    ORDERSSYNONYM,'
      '    ORDERSSYNONYMFIRM,'
      '    ORDERSPRICE,'
      '    ORDERSJUNK,'
      '    ORDERSAWAIT,'
      '    ORDERSHORDERID,'
      '    ORDERSHCLIENTID,'
      '    ORDERSHPRICECODE,'
      '    ORDERSHREGIONCODE,'
      '    ORDERSHPRICENAME,'
      '    ORDERSHREGIONNAME'
      'FROM'
      '    CORESHOWBYNAME(:ACLIENT,'
      '    :TIMEZONEBIAS,'
      '    :PARENTCODE,'
      '    :SHOWREGISTER,'
      '    :REGISTERID) ')
    AfterOpen = adsCore2AfterOpen
    AfterPost = adsCore2AfterPost
    AfterScroll = adsCore2AfterScroll
    BeforeClose = adsCore2BeforeClose
    BeforeEdit = adsCore2BeforeEdit
    BeforePost = adsCore2BeforePost
    OnCalcFields = adsCore2CalcFields
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    AutoCommit = True
    RefreshTransactionKind = tkUpdateTransaction
    Left = 64
    Top = 133
    oFetchAll = True
    object adsCoreCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsCorePRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreSHORTCODE: TFIBBCDField
      FieldName = 'SHORTCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsCoreSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreCODE: TFIBStringField
      FieldName = 'CODE'
      EmptyStrToNull = False
    end
    object adsCoreCODECR: TFIBStringField
      FieldName = 'CODECR'
      EmptyStrToNull = False
    end
    object adsCorePERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = False
    end
    object adsCoreSALE: TFIBIntegerField
      FieldName = 'SALE'
    end
    object adsCoreVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = False
    end
    object adsCoreNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = False
    end
    object adsCoreBASECOST: TFIBBCDField
      FieldName = 'BASECOST'
      DisplayFormat = '0.00;;'#39#39
      Size = 4
      RoundByScale = True
    end
    object adsCoreQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = False
    end
    object adsCoreAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
      DisplayValues = '+;'
    end
    object adsCoreJUNK: TFIBBooleanField
      FieldName = 'JUNK'
      DisplayValues = '+;'
    end
    object adsCoreSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = False
    end
    object adsCoreSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = False
    end
    object adsCoreDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsCorePRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = False
    end
    object adsCoreFIRMCODE: TFIBBCDField
      FieldName = 'FIRMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCorePRICEENABLED: TFIBBooleanField
      FieldName = 'PRICEENABLED'
      DisplayValues = '+;'
    end
    object adsCoreSTORAGE: TFIBBooleanField
      FieldName = 'STORAGE'
      OnGetText = adsCoreSTORAGEGetText
      DisplayValues = '+;Fail'
    end
    object adsCoreREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = False
    end
    object adsCoreORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSCLIENTID: TFIBBCDField
      FieldName = 'ORDERSCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSFULLCODE: TFIBBCDField
      FieldName = 'ORDERSFULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSCODEFIRMCR: TFIBBCDField
      FieldName = 'ORDERSCODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSSYNONYMCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSCODE: TFIBStringField
      FieldName = 'ORDERSCODE'
      EmptyStrToNull = False
    end
    object adsCoreORDERSCODECR: TFIBStringField
      FieldName = 'ORDERSCODECR'
      EmptyStrToNull = False
    end
    object adsCoreORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
      DisplayFormat = '#'
    end
    object adsCoreORDERSSYNONYM: TFIBStringField
      FieldName = 'ORDERSSYNONYM'
      Size = 250
      EmptyStrToNull = False
    end
    object adsCoreORDERSSYNONYMFIRM: TFIBStringField
      FieldName = 'ORDERSSYNONYMFIRM'
      Size = 250
      EmptyStrToNull = False
    end
    object adsCoreORDERSPRICE: TFIBBCDField
      FieldName = 'ORDERSPRICE'
      Size = 4
      RoundByScale = True
    end
    object adsCoreORDERSJUNK: TFIBBooleanField
      FieldName = 'ORDERSJUNK'
      DisplayValues = '+;'
    end
    object adsCoreORDERSAWAIT: TFIBBooleanField
      FieldName = 'ORDERSAWAIT'
      DisplayValues = '+;'
    end
    object adsCoreORDERSHORDERID: TFIBBCDField
      FieldName = 'ORDERSHORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHCLIENTID: TFIBBCDField
      FieldName = 'ORDERSHCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHPRICECODE: TFIBBCDField
      FieldName = 'ORDERSHPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHREGIONCODE: TFIBBCDField
      FieldName = 'ORDERSHREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHPRICENAME: TFIBStringField
      FieldName = 'ORDERSHPRICENAME'
      Size = 70
      EmptyStrToNull = False
    end
    object adsCoreORDERSHREGIONNAME: TFIBStringField
      FieldName = 'ORDERSHREGIONNAME'
      Size = 25
      EmptyStrToNull = False
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
  object adsRegions: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT * FROM Regions')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 152
    Top = 173
  end
  object adsOrdersH: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ORDERID,'
      '    SERVERORDERID,'
      '    CLIENTID,'
      '    PRICECODE,'
      '    REGIONCODE,'
      '    PRICENAME,'
      '    REGIONNAME,'
      '    ORDERDATE,'
      '    SENDDATE,'
      '    CLOSED,'
      '    SEND,'
      '    COMMENTS,'
      '    MESSAGETO'
      'FROM'
      '    ORDERSHSHOWCURRENT(:ACLIENTID,'
      '    :APRICECODE,'
      '    :AREGIONCODE) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 240
    Top = 173
  end
  object adsOrders: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    FULLCODE,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    ORDERCOUNT,'
      '    PRICE,'
      '    ORDERDATE,'
      '    PRICENAME,'
      '    REGIONNAME,'
      '    AWAIT,'
      '    JUNK'
      'FROM'
      '    ORDERSSHOWBYFORM(:FULLCODE,'
      '    :ACLIENTID) ')
    DataSource = dsCore
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 184
    Top = 388
    WaitEndMasterScroll = True
    dcForceOpen = True
    object adsOrdersFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = False
    end
    object adsOrdersSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = False
    end
    object adsOrdersORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsOrdersPRICE: TFIBBCDField
      FieldName = 'PRICE'
      Size = 4
      RoundByScale = True
    end
    object adsOrdersORDERDATE: TFIBDateTimeField
      FieldName = 'ORDERDATE'
    end
    object adsOrdersPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = False
    end
    object adsOrdersREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = False
    end
    object adsOrdersAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsOrdersJUNK: TFIBIntegerField
      FieldName = 'JUNK'
    end
  end
  object adsOrdersShowFormSummary: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    PRICEAVG'
      'FROM'
      '    ORDERSSHOWFORMSUMMARY(:FULLCODE,'
      '    :ACLIENTID) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 344
    Top = 396
    object adsOrdersShowFormSummaryPRICEAVG: TFIBIntegerField
      FieldName = 'PRICEAVG'
    end
  end
  object adsFirmsInfo: TpFIBDataSet
    SelectSQL.Strings = (
      
        'SELECT FirmCode, RegionCode, SupportPhone, OperativeInfo FROM Re' +
        'gionalData'
      'where'
      '  FirmCode = :FirmCode'
      'and RegionCode = :RegionCode')
    DataSource = dsCore
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 626
    Top = 404
  end
end
