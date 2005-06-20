inherited OrdersHForm: TOrdersHForm
  Left = 219
  Top = 211
  Caption = #1047#1072#1082#1072#1079#1099
  ClientHeight = 487
  ClientWidth = 792
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl: TTabControl
    Left = 0
    Top = 39
    Width = 792
    Height = 448
    Align = alClient
    TabOrder = 0
    Tabs.Strings = (
      #1058#1077#1082#1091#1097#1080#1077
      #1054#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1077)
    TabIndex = 0
    OnChange = TabControlChange
    object pTabSheet: TPanel
      Left = 4
      Top = 24
      Width = 784
      Height = 420
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object pBottom: TPanel
        Tag = 146
        Left = 0
        Top = 384
        Width = 784
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          784
          36)
        object btnMoveSend: TButton
          Left = 3
          Top = 4
          Width = 150
          Height = 27
          Anchors = [akLeft, akBottom]
          Caption = #1055#1077#1088#1077#1074#1077#1089#1090#1080' '#1074' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1077
          TabOrder = 0
          OnClick = btnMoveSendClick
        end
        object btnDelete: TButton
          Left = 163
          Top = 4
          Width = 150
          Height = 27
          Anchors = [akLeft, akBottom]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 1
          OnClick = btnDeleteClick
        end
        object btnWayBillList: TButton
          Left = 328
          Top = 4
          Width = 150
          Height = 27
          Anchors = [akLeft, akBottom]
          Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
          TabOrder = 2
          OnClick = btnWayBillListClick
        end
      end
      object pClient: TPanel
        Left = 0
        Top = 0
        Width = 784
        Height = 384
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object pGrid: TPanel
          Left = 0
          Top = 0
          Width = 483
          Height = 278
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object ToughDBGrid1: TToughDBGrid
            Left = 112
            Top = 224
            Width = 185
            Height = 57
            Flat = True
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'MS Sans Serif'
            FooterFont.Style = []
            Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking]
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            SearchPosition = spBottom
          end
          object dbgOrdersH: TToughDBGrid
            Left = 0
            Top = 0
            Width = 483
            Height = 278
            Align = alClient
            AllowedOperations = [alopUpdateEh]
            AutoFitColWidths = True
            DataSource = dsOrdersH
            Flat = True
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'MS Sans Serif'
            FooterFont.Style = []
            Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking]
            ReadOnly = True
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            OnDblClick = dbgOrdersHDblClick
            OnExit = dbgOrdersHExit
            OnGetCellParams = dbgOrdersHGetCellParams
            OnKeyDown = dbgOrdersHKeyDown
            OnKeyPress = dbgOrdersHKeyPress
            SearchPosition = spBottom
            OnSortChange = dbgOrdersHSortChange
            Columns = <
              item
                EditButtons = <>
                FieldName = 'SendDate'
                Footers = <>
                Title.Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086
                Title.TitleButton = True
                Width = 70
              end
              item
                EditButtons = <>
                FieldName = 'OrderDate'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1057#1086#1079#1076#1072#1085#1086
                Title.TitleButton = True
                Width = 60
              end
              item
                EditButtons = <>
                FieldName = 'PriceName'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
                Title.TitleButton = True
                Width = 72
              end
              item
                EditButtons = <>
                FieldName = 'RegionName'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1056#1077#1075#1080#1086#1085
                Title.TitleButton = True
                Width = 68
              end
              item
                EditButtons = <>
                FieldName = 'Positions'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1055#1086#1079#1080#1094#1080#1081
                Title.TitleButton = True
                Width = 53
              end
              item
                EditButtons = <>
                FieldName = 'SumOrder'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1057#1091#1084#1084#1072
                Title.TitleButton = True
                Width = 60
              end
              item
                Checkboxes = True
                EditButtons = <>
                FieldName = 'Send'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
                Title.TitleButton = True
                Width = 60
              end>
          end
        end
        object pRight: TPanel
          Left = 483
          Top = 0
          Width = 301
          Height = 278
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object gbMessage: TGroupBox
            Left = 7
            Top = 0
            Width = 291
            Height = 131
            Caption = ' '#1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '
            TabOrder = 0
            object dbmMessage: TDBMemo
              Left = 7
              Top = 19
              Width = 278
              Height = 104
              DataField = 'Message'
              DataSource = dsOrdersH
              MaxLength = 100
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object gbComments: TGroupBox
            Left = 6
            Top = 135
            Width = 292
            Height = 131
            Caption = ' '#1051#1080#1095#1085#1099#1077' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080' '
            TabOrder = 1
            object dbmComments: TDBMemo
              Left = 7
              Top = 19
              Width = 279
              Height = 104
              DataField = 'Comments'
              DataSource = dsOrdersH
              MaxLength = 100
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
        end
        object pWebBrowser: TPanel
          Tag = 106
          Left = 0
          Top = 278
          Width = 784
          Height = 106
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
          object Bevel2: TBevel
            Left = 0
            Top = 0
            Width = 784
            Height = 4
            Align = alTop
            Shape = bsTopLine
          end
          object WebBrowser1: TWebBrowser
            Tag = 5
            Left = 0
            Top = 4
            Width = 784
            Height = 102
            Align = alClient
            TabOrder = 0
            ControlData = {
              4C000000075100008B0A00000000000000000000000000000000000000000000
              000000004C000000000000000000000001000000E0D057007335CF11AE690800
              2B2E126208000000000000004C0000000114020000000000C000000000000046
              8000000000000000000000000000000000000000000000000000000000000000
              00000000000000000100000000000000000000000000000000000000}
          end
        end
      end
    end
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 39
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label7: TLabel
      Left = 10
      Top = 12
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
      Top = 12
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
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 792
      Height = 39
      Align = alClient
      Shape = bsBottomLine
    end
    object dtpDateFrom: TDateTimePicker
      Left = 127
      Top = 9
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
      Top = 9
      Width = 81
      Height = 21
      Date = 0.631934409720997800
      Time = 0.631934409720997800
      TabOrder = 1
      OnCloseUp = dtpDateCloseUp
    end
  end
  object adsOrdersH: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    BeforePost = adsOrdersHBeforePost
    AfterPost = adsOrdersHAfterPost
    BeforeDelete = adsOrdersHBeforeDelete
    CommandText = 
      'SELECT * FROM OrdersHShow'#13#10'WHERE OrderDate BETWEEN DateFrom AND ' +
      'DateTo'
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
        Name = 'TimeZoneBias'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'AClosed'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'DateFrom'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'DateTo'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    Prepared = True
    Left = 64
    Top = 80
    object adsOrdersHOrderId: TAutoIncField
      FieldName = 'OrderId'
      ReadOnly = True
    end
    object adsOrdersHPriceCode: TIntegerField
      FieldName = 'PriceCode'
    end
    object adsOrdersHRegionCode: TIntegerField
      FieldName = 'RegionCode'
    end
    object adsOrdersHClosed: TBooleanField
      FieldName = 'Closed'
      DisplayValues = '+;'
    end
    object adsOrdersHSend: TBooleanField
      AutoGenerateValue = arDefault
      FieldName = 'Send'
      OnChange = adsOrdersHSendChange
      DisplayValues = '+;'
    end
    object adsOrdersHOrderDate: TDateTimeField
      FieldName = 'OrderDate'
    end
    object adsOrdersHSendDate: TDateTimeField
      FieldName = 'SendDate'
    end
    object adsOrdersHPriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 25
    end
    object adsOrdersHRegionName: TWideStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsOrdersHPositions: TIntegerField
      FieldName = 'Positions'
      ReadOnly = True
      DisplayFormat = '#'
    end
    object adsOrdersHSumOrder: TBCDField
      FieldName = 'SumOrder'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
    end
    object adsOrdersHDatePrice: TDateTimeField
      FieldName = 'DatePrice'
    end
    object adsOrdersHSupportPhone: TWideStringField
      FieldName = 'SupportPhone'
    end
    object adsOrdersHMessage: TWideStringField
      FieldName = 'Message'
      Size = 100
    end
    object adsOrdersHComments: TWideStringField
      FieldName = 'Comments'
      Size = 100
    end
    object adsOrdersHServerOrderId: TIntegerField
      FieldName = 'ServerOrderId'
    end
  end
  object dsOrdersH: TDataSource
    DataSet = adsOrdersH
    Left = 64
    Top = 128
  end
  object adsCore: TADODataSet
    AutoCalcFields = False
    Connection = DM.MainConnection
    CursorLocation = clUseServer
    CommandText = 'SELECT * FROM CoreShowByFirm'
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
        Name = 'RetailForcount'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '30'
      end
      item
        Name = 'APriceCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '7'
      end
      item
        Name = 'ARegionCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '1'
      end>
    Prepared = True
    Left = 184
    Top = 80
    object adsCoreCoreId: TAutoIncField
      FieldName = 'CoreId'
      ReadOnly = True
    end
    object adsCoreFullCode: TIntegerField
      FieldName = 'FullCode'
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
    object adsCoreVolume: TWideStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsCoreDoc: TWideStringField
      FieldName = 'Doc'
    end
    object adsCoreNote: TWideStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsCorePeriod: TWideStringField
      FieldName = 'Period'
    end
    object adsCoreAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsCoreJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsCoreBaseCost: TBCDField
      FieldName = 'BaseCost'
      Precision = 19
    end
    object adsCoreQuantity: TWideStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsCoreSynonym: TWideStringField
      FieldName = 'Synonym'
      Size = 255
    end
    object adsCoreSynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsCoreMinPrice: TBCDField
      FieldName = 'MinPrice'
      Precision = 19
    end
    object adsCoreLeaderFirmCode: TIntegerField
      FieldName = 'LeaderPriceCode'
    end
    object adsCoreLeaderRegionCode: TIntegerField
      FieldName = 'LeaderRegionCode'
    end
    object adsCoreLeaderRegionName: TWideStringField
      FieldName = 'LeaderRegionName'
      Size = 25
    end
    object adsCoreLeaderPriceName: TWideStringField
      FieldName = 'LeaderPriceName'
      Size = 70
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
    object adsCorePriceRet: TFloatField
      FieldName = 'PriceRet'
      ReadOnly = True
    end
    object adsCoreSumOrder: TBCDField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
      Calculated = True
    end
  end
  object adsWayBillHead: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    CommandText = 'select * from WayBillHeadShowCurrent'
    Parameters = <
      item
        Name = '[AServerOrderID]'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    Left = 284
    Top = 103
    object adsWayBillHeadServerID: TIntegerField
      FieldName = 'ServerID'
    end
    object adsWayBillHeadServerOrderID: TIntegerField
      FieldName = 'ServerOrderID'
    end
    object adsWayBillHeadWriteTime: TDateTimeField
      FieldName = 'WriteTime'
    end
    object adsWayBillHeadClientID: TIntegerField
      FieldName = 'ClientID'
    end
    object adsWayBillHeadPriceCode: TIntegerField
      FieldName = 'PriceCode'
    end
    object adsWayBillHeadRegionCode: TIntegerField
      FieldName = 'RegionCode'
    end
    object adsWayBillHeadPriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 100
    end
    object adsWayBillHeadRegionName: TWideStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsWayBillHeadFirmComment: TWideStringField
      FieldName = 'FirmComment'
      Size = 100
    end
    object adsWayBillHeadRowCount: TSmallintField
      FieldName = 'RowCount'
    end
  end
  object dsWayBillHead: TDataSource
    DataSet = adsWayBillHead
    Left = 284
    Top = 143
  end
  object tmOrderDateChange: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmOrderDateChangeTimer
    Left = 60
    Top = 191
  end
end
