inherited PricesForm: TPricesForm
  Left = 253
  Top = 134
  ActiveControl = dbgPrices
  Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 571
  ClientWidth = 790
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 541
    Width = 790
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      790
      30)
    object cbOnlyLeaders: TCheckBox
      Left = 13
      Top = 7
      Width = 316
      Height = 17
      Action = actOnlyLeaders
      Anchors = [akLeft, akBottom]
      Caption = ' '#1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1083#1080#1076#1080#1088#1091#1102#1097#1080#1077' '#1087#1086#1079#1080#1094#1080#1080' (F3)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 790
    Height = 541
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgPrices: TToughDBGrid
      Left = 0
      Top = 29
      Width = 534
      Height = 512
      Align = alClient
      AutoFitColWidths = True
      DataSource = dsPrices
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgPricesDblClick
      OnGetCellParams = dbgPricesGetCellParams
      OnKeyDown = dbgPricesKeyDown
      SearchField = 'PriceName'
      SearchPosition = spBottom
      ForceRus = True
      OnSortChange = dbgPricesSortChange
      Columns = <
        item
          EditButtons = <>
          FieldName = 'PriceName'
          Footers = <>
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Title.TitleButton = True
          Width = 86
        end
        item
          EditButtons = <>
          FieldName = 'RegionName'
          Footers = <>
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Title.TitleButton = True
          Width = 98
        end
        item
          Checkboxes = False
          EditButtons = <>
          FieldName = 'Storage'
          Footers = <>
          Title.Caption = #1057#1082#1083#1072#1076
          Title.TitleButton = True
          Width = 39
        end
        item
          Alignment = taCenter
          EditButtons = <>
          FieldName = 'UpCost'
          Footers = <>
          Title.Caption = '%'
          Title.TitleButton = True
          Width = 37
        end
        item
          EditButtons = <>
          FieldName = 'PriceSize'
          Footers = <>
          Title.Caption = #1055#1086#1079#1080#1094#1080#1081
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'Positions'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072
          Title.TitleButton = True
        end
        item
          Alignment = taCenter
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'DatePrice'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Title.TitleButton = True
          Width = 104
        end>
    end
    object GroupBox1: TGroupBox
      Left = 534
      Top = 29
      Width = 256
      Height = 512
      Align = alRight
      Caption = ' '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '
      TabOrder = 0
      DesignSize = (
        256
        512)
      object dbtPhones: TDBText
        Left = 72
        Top = 37
        Width = 61
        Height = 13
        AutoSize = True
        DataField = 'SupportPhone'
        DataSource = dsPrices
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtAdminMail: TDBText
        Left = 55
        Top = 55
        Width = 76
        Height = 13
        Cursor = crHandPoint
        AutoSize = True
        Color = clBtnFace
        DataField = 'AdminMail'
        DataSource = dsPrices
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentColor = False
        ParentFont = False
        OnClick = dbtAdminMailClick
      end
      object dbtFullName: TDBText
        Left = 5
        Top = 20
        Width = 244
        Height = 13
        DataField = 'FullName'
        DataSource = dsPrices
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtMinOrder: TDBText
        Left = 174
        Top = 71
        Width = 70
        Height = 13
        AutoSize = True
        DataField = 'MinReq'
        DataSource = dsPrices
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 6
        Top = 196
        Width = 156
        Height = 13
        Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 6
        Top = 71
        Width = 164
        Height = 13
        Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1079#1072#1082#1072#1079', '#1088#1091#1073'. :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 5
        Top = 37
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
      object Label4: TLabel
        Left = 6
        Top = 104
        Width = 173
        Height = 13
        Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1077' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 6
        Top = 55
        Width = 44
        Height = 13
        Caption = 'E-Mail :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel1: TBevel
        Left = 6
        Top = 95
        Width = 243
        Height = 3
        Shape = bsTopLine
      end
      object Bevel2: TBevel
        Left = 5
        Top = 187
        Width = 243
        Height = 3
        Shape = bsTopLine
      end
      object Label6: TLabel
        Left = 6
        Top = 342
        Width = 165
        Height = 13
        Caption = #1054#1087#1077#1088#1072#1090#1080#1074#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel3: TBevel
        Left = 5
        Top = 333
        Width = 243
        Height = 3
        Shape = bsTopLine
      end
      object DBMemo1: TDBMemo
        Left = 6
        Top = 121
        Width = 243
        Height = 64
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        DataField = 'PriceInfo'
        DataSource = dsPrices
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object DBMemo2: TDBMemo
        Left = 6
        Top = 215
        Width = 243
        Height = 115
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        DataField = 'ContactInfo'
        DataSource = dsPrices
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object DBMemo3: TDBMemo
        Left = 6
        Top = 361
        Width = 243
        Height = 136
        Anchors = [akLeft, akTop, akBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        DataField = 'OperativeInfo'
        DataSource = dsPrices
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 790
      Height = 29
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object lblPriceCount: TLabel
        Left = 7
        Top = 6
        Width = 93
        Height = 16
        Caption = 'lblPriceCount'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object ActionList: TActionList
    Left = 208
    Top = 112
    object actCurrentOrders: TAction
      Caption = #1058#1086#1083#1100#1082#1086' '#1090#1077#1082#1091#1097#1080#1077' '#1079#1072#1103#1074#1082#1080
    end
    object actOnlyLeaders: TAction
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1083#1080#1076#1080#1088#1091#1102#1097#1080#1077' '#1087#1086#1079#1080#1094#1080#1080' (F3)'
      ShortCut = 114
      OnExecute = actOnlyLeadersExecute
    end
  end
  object adsPrices: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    AfterOpen = adsPricesAfterOpen
    AfterScroll = adsPricesAfterScroll
    CommandText = 'SELECT * FROM PricesShow'
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
        Name = 'TimeZoneBias'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = -180
      end>
    Prepared = True
    Left = 96
    Top = 112
    object adsPricesPriceCode: TIntegerField
      FieldName = 'PriceCode'
    end
    object adsPricesPriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 25
    end
    object adsPricesDatePrice: TDateTimeField
      FieldName = 'DatePrice'
    end
    object adsPricesUpCost: TFloatField
      FieldName = 'UpCost'
    end
    object adsPricesPriceInfo: TMemoField
      FieldName = 'PriceInfo'
      BlobType = ftMemo
    end
    object adsPricesFirmCode: TIntegerField
      FieldName = 'FirmCode'
    end
    object adsPricesFullName: TWideStringField
      FieldName = 'FullName'
      Size = 40
    end
    object adsPricesStorage: TBooleanField
      Alignment = taCenter
      FieldName = 'Storage'
      DisplayValues = '+;'
    end
    object adsPricesAdminMail: TWideStringField
      FieldName = 'AdminMail'
      Size = 100
    end
    object adsPricesSupportPhone: TWideStringField
      FieldName = 'SupportPhone'
    end
    object adsPricesContactInfo: TMemoField
      FieldName = 'ContactInfo'
      BlobType = ftMemo
    end
    object adsPricesOperativeInfo: TMemoField
      FieldName = 'OperativeInfo'
      BlobType = ftMemo
    end
    object adsPricesEnabled: TBooleanField
      FieldName = 'Enabled'
    end
    object adsPricesRegionCode: TIntegerField
      FieldName = 'RegionCode'
    end
    object adsPricesRegionName: TWideStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsPricesPositions: TIntegerField
      FieldName = 'Positions'
      DisplayFormat = '#'
    end
    object adsPricesSumOrder: TBCDField
      DisplayWidth = 11
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
    end
    object adsPricesPriceSize: TIntegerField
      FieldName = 'PriceSize'
      DisplayFormat = '#'
    end
    object adsPricesMinReq: TIntegerField
      FieldName = 'MinReq'
    end
  end
  object dsPrices: TDataSource
    DataSet = adsPrices
    Left = 96
    Top = 160
  end
  object adsClientsData: TADODataSet
    Parameters = <>
    Left = 208
    Top = 160
  end
end
