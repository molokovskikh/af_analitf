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
                FieldName = 'SENDDATE'
                Footers = <>
                Title.Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086
                Title.TitleButton = True
                Width = 70
              end
              item
                EditButtons = <>
                FieldName = 'ORDERDATE'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1057#1086#1079#1076#1072#1085#1086
                Title.TitleButton = True
                Width = 60
              end
              item
                EditButtons = <>
                FieldName = 'PRICENAME'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
                Title.TitleButton = True
                Width = 72
              end
              item
                EditButtons = <>
                FieldName = 'REGIONNAME'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1056#1077#1075#1080#1086#1085
                Title.TitleButton = True
                Width = 68
              end
              item
                EditButtons = <>
                FieldName = 'POSITIONS'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1055#1086#1079#1080#1094#1080#1081
                Title.TitleButton = True
                Width = 53
              end
              item
                EditButtons = <>
                FieldName = 'SUMORDER'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1057#1091#1084#1084#1072
                Title.TitleButton = True
                Width = 60
              end
              item
                Checkboxes = True
                EditButtons = <>
                FieldName = 'SEND'
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
              DataField = 'MESSAGETO'
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
  object adsOrdersH2: TADODataSet
    CursorType = ctStatic
    BeforePost = adsOrdersH2BeforePost
    AfterPost = adsOrdersH2AfterPost
    BeforeDelete = adsOrdersH2BeforeDelete
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
    object adsOrdersH2OrderId: TAutoIncField
      FieldName = 'OrderId'
      ReadOnly = True
    end
    object adsOrdersH2PriceCode: TIntegerField
      FieldName = 'PriceCode'
    end
    object adsOrdersH2RegionCode: TIntegerField
      FieldName = 'RegionCode'
    end
    object adsOrdersH2Closed: TBooleanField
      FieldName = 'Closed'
      DisplayValues = '+;'
    end
    object adsOrdersH2Send: TBooleanField
      AutoGenerateValue = arDefault
      FieldName = 'Send'
      OnChange = adsOrdersH2SendChange
      DisplayValues = '+;'
    end
    object adsOrdersH2OrderDate: TDateTimeField
      FieldName = 'OrderDate'
    end
    object adsOrdersH2SendDate: TDateTimeField
      FieldName = 'SendDate'
    end
    object adsOrdersH2PriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 25
    end
    object adsOrdersH2RegionName: TWideStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsOrdersH2Positions: TIntegerField
      FieldName = 'Positions'
      ReadOnly = True
      DisplayFormat = '#'
    end
    object adsOrdersH2SumOrder: TBCDField
      FieldName = 'SumOrder'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
    end
    object adsOrdersH2DatePrice: TDateTimeField
      FieldName = 'DatePrice'
    end
    object adsOrdersH2SupportPhone: TWideStringField
      FieldName = 'SupportPhone'
    end
    object adsOrdersH2Message: TWideStringField
      FieldName = 'Message'
      Size = 100
    end
    object adsOrdersH2Comments: TWideStringField
      FieldName = 'Comments'
      Size = 100
    end
    object adsOrdersH2ServerOrderId: TIntegerField
      FieldName = 'ServerOrderId'
    end
  end
  object dsOrdersH: TDataSource
    DataSet = adsOrdersH
    Left = 72
    Top = 176
  end
  object adsCore2: TADODataSet
    AutoCalcFields = False
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
    object adsCore2CoreId: TAutoIncField
      FieldName = 'CoreId'
      ReadOnly = True
    end
    object adsCore2FullCode: TIntegerField
      FieldName = 'FullCode'
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
    object adsCore2Volume: TWideStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsCore2Doc: TWideStringField
      FieldName = 'Doc'
    end
    object adsCore2Note: TWideStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsCore2Period: TWideStringField
      FieldName = 'Period'
    end
    object adsCore2Await: TBooleanField
      FieldName = 'Await'
    end
    object adsCore2Junk: TBooleanField
      FieldName = 'Junk'
    end
    object adsCore2BaseCost: TBCDField
      FieldName = 'BaseCost'
      Precision = 19
    end
    object adsCore2Quantity: TWideStringField
      FieldName = 'Quantity'
      Size = 15
    end
    object adsCore2Synonym: TWideStringField
      FieldName = 'Synonym'
      Size = 255
    end
    object adsCore2SynonymFirm: TWideStringField
      FieldName = 'SynonymFirm'
      Size = 255
    end
    object adsCore2MinPrice: TBCDField
      FieldName = 'MinPrice'
      Precision = 19
    end
    object adsCore2LeaderFirmCode: TIntegerField
      FieldName = 'LeaderPriceCode'
    end
    object adsCore2LeaderRegionCode: TIntegerField
      FieldName = 'LeaderRegionCode'
    end
    object adsCore2LeaderRegionName: TWideStringField
      FieldName = 'LeaderRegionName'
      Size = 25
    end
    object adsCore2LeaderPriceName: TWideStringField
      FieldName = 'LeaderPriceName'
      Size = 70
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
    object adsCore2PriceRet: TFloatField
      FieldName = 'PriceRet'
      ReadOnly = True
    end
    object adsCore2SumOrder: TBCDField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
      currency = True
      Precision = 19
      Calculated = True
    end
  end
  object adsWayBillHead2: TADODataSet
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
    object adsWayBillHead2ServerID: TIntegerField
      FieldName = 'ServerID'
    end
    object adsWayBillHead2ServerOrderID: TIntegerField
      FieldName = 'ServerOrderID'
    end
    object adsWayBillHead2WriteTime: TDateTimeField
      FieldName = 'WriteTime'
    end
    object adsWayBillHead2ClientID: TIntegerField
      FieldName = 'ClientID'
    end
    object adsWayBillHead2PriceCode: TIntegerField
      FieldName = 'PriceCode'
    end
    object adsWayBillHead2RegionCode: TIntegerField
      FieldName = 'RegionCode'
    end
    object adsWayBillHead2PriceName: TWideStringField
      FieldName = 'PriceName'
      Size = 100
    end
    object adsWayBillHead2RegionName: TWideStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsWayBillHead2FirmComment: TWideStringField
      FieldName = 'FirmComment'
      Size = 100
    end
    object adsWayBillHead2RowCount: TSmallintField
      FieldName = 'RowCount'
    end
  end
  object dsWayBillHead: TDataSource
    DataSet = adsWayBillHead
    Left = 284
    Top = 183
  end
  object tmOrderDateChange: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmOrderDateChangeTimer
    Left = 76
    Top = 223
  end
  object adsOrdersH: TpFIBDataSet
    UpdateSQL.Strings = (
      'update ordersh'
      'set'
      '  SEND = :SEND,'
      '  CLOSED = :CLOSED,'
      '  MESSAGETO = :MESSAGETO,'
      '  COMMENTS = :COMMENTS'
      'where'
      '  orderid = :old_ORDERID')
    DeleteSQL.Strings = (
      'delete from'
      '  ordersh'
      'where'
      '  orderid = :orderid')
    RefreshSQL.Strings = (
      'SELECT'
      '    ORDERID,'
      '    SERVERORDERID,'
      '    DATEPRICE,'
      '    PRICECODE,'
      '    REGIONCODE,'
      '    ORDERDATE,'
      '    SENDDATE,'
      '    CLOSED,'
      '    SEND,'
      '    PRICENAME,'
      '    REGIONNAME,'
      '    POSITIONS,'
      '    SUMORDER,'
      '    SUPPORTPHONE,'
      '    MESSAGETO,'
      '    COMMENTS'
      'FROM'
      '    ORDERSHSHOW (:ACLIENTID,'
      '    :ACLOSED,'
      '    :TIMEZONEBIAS)'
      'WHERE(  OrderDate BETWEEN :DateFrom AND :DateTo'
      '     ) and ( ORDERID = :OLD_ORDERID'
      '     )'
      '     ')
    SelectSQL.Strings = (
      'SELECT'
      '    ORDERID,'
      '    SERVERORDERID,'
      '    DATEPRICE,'
      '    PRICECODE,'
      '    REGIONCODE,'
      '    ORDERDATE,'
      '    SENDDATE,'
      '    CLOSED,'
      '    SEND,'
      '    PRICENAME,'
      '    REGIONNAME,'
      '    POSITIONS,'
      '    SUMORDER,'
      '    SUPPORTPHONE,'
      '    MESSAGETO,'
      '    COMMENTS'
      'FROM'
      '    ORDERSHSHOW (:ACLIENTID,'
      '    :ACLOSED,'
      '    :TIMEZONEBIAS)'
      'WHERE OrderDate BETWEEN :DateFrom AND :DateTo ')
    AfterPost = adsOrdersH2AfterPost
    BeforeDelete = adsOrdersH2BeforeDelete
    BeforePost = adsOrdersH2BeforePost
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    AutoCommit = True
    Left = 68
    Top = 119
    object adsOrdersHORDERID: TFIBBCDField
      FieldName = 'ORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHSERVERORDERID: TFIBBCDField
      FieldName = 'SERVERORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsOrdersHPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHORDERDATE: TFIBDateTimeField
      FieldName = 'ORDERDATE'
    end
    object adsOrdersHSENDDATE: TFIBDateTimeField
      FieldName = 'SENDDATE'
    end
    object adsOrdersHCLOSED: TFIBBooleanField
      FieldName = 'CLOSED'
    end
    object adsOrdersHSEND: TFIBBooleanField
      FieldName = 'SEND'
      OnChange = adsOrdersH2SendChange
    end
    object adsOrdersHPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = False
    end
    object adsOrdersHREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = False
    end
    object adsOrdersHPOSITIONS: TFIBIntegerField
      FieldName = 'POSITIONS'
    end
    object adsOrdersHSUMORDER: TFIBIntegerField
      FieldName = 'SUMORDER'
    end
    object adsOrdersHSUPPORTPHONE: TFIBStringField
      FieldName = 'SUPPORTPHONE'
      EmptyStrToNull = False
    end
    object adsOrdersHMESSAGETO: TFIBStringField
      FieldName = 'MESSAGETO'
      Size = 100
      EmptyStrToNull = False
    end
    object adsOrdersHCOMMENTS: TFIBStringField
      FieldName = 'COMMENTS'
      Size = 100
      EmptyStrToNull = False
    end
  end
  object adsCore: TpFIBDataSet
    UpdateSQL.Strings = (
      'execute procedure updateordercount('
      '  :new_ORDERSHORDERID, '
      '  :Aclientid, '
      '  :APRICECODE, '
      '  :AREGIONCODE, '
      '  :new_ORDERSORDERID, '
      '  :new_COREID, '
      '  :NEW_ORDERCOUNT)')
    RefreshSQL.Strings = (
      'SELECT'
      '    COREID,'
      '    FULLCODE,'
      '    SHORTCODE,'
      '    CODEFIRMCR,'
      '    SYNONYMCODE,'
      '    SYNONYMFIRMCRCODE,'
      '    CODE,'
      '    CODECR,'
      '    VOLUME,'
      '    DOC,'
      '    NOTE,'
      '    PERIOD,'
      '    AWAIT,'
      '    JUNK,'
      '    BASECOST,'
      '    QUANTITY,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    MINPRICE,'
      '    LEADERPRICECODE,'
      '    LEADERREGIONCODE,'
      '    LEADERREGIONNAME,'
      '    LEADERPRICENAME,'
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
      '    ORDERSHREGIONNAME,'
      '    PRICERET'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :RETAILFORCOUNT,'
      '    :ACLIENTID) '
      'where'
      '  CoreID = :OLD_COREID')
    SelectSQL.Strings = (
      'SELECT'
      '    COREID,'
      '    FULLCODE,'
      '    SHORTCODE,'
      '    CODEFIRMCR,'
      '    SYNONYMCODE,'
      '    SYNONYMFIRMCRCODE,'
      '    CODE,'
      '    CODECR,'
      '    VOLUME,'
      '    DOC,'
      '    NOTE,'
      '    PERIOD,'
      '    AWAIT,'
      '    JUNK,'
      '    BASECOST,'
      '    QUANTITY,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    MINPRICE,'
      '    LEADERPRICECODE,'
      '    LEADERREGIONCODE,'
      '    LEADERREGIONNAME,'
      '    LEADERPRICENAME,'
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
      '    ORDERSHREGIONNAME,'
      '    PRICERET'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :RETAILFORCOUNT,'
      '    :ACLIENTID) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    AutoCommit = True
    Left = 188
    Top = 119
  end
  object adsWayBillHead: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    SERVERID,'
      '    SERVERORDERID,'
      '    WRITETIME,'
      '    CLIENTID,'
      '    PRICECODE,'
      '    REGIONCODE,'
      '    PRICENAME,'
      '    REGIONNAME,'
      '    FIRMCOMMENT,'
      '    ROWCOUNT'
      'FROM'
      '    WAYBILLHEADSHOWCURRENT(:ASERVERORDERID) ')
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    Left = 284
    Top = 144
    object adsWayBillHeadSERVERID: TFIBBCDField
      FieldName = 'SERVERID'
      Size = 0
      RoundByScale = True
    end
    object adsWayBillHeadSERVERORDERID: TFIBBCDField
      FieldName = 'SERVERORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsWayBillHeadWRITETIME: TFIBDateTimeField
      FieldName = 'WRITETIME'
    end
    object adsWayBillHeadCLIENTID: TFIBBCDField
      FieldName = 'CLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsWayBillHeadPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsWayBillHeadREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsWayBillHeadPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = False
    end
    object adsWayBillHeadREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = False
    end
    object adsWayBillHeadFIRMCOMMENT: TFIBStringField
      FieldName = 'FIRMCOMMENT'
      Size = 100
      EmptyStrToNull = False
    end
    object adsWayBillHeadROWCOUNT: TFIBIntegerField
      FieldName = 'ROWCOUNT'
    end
  end
end
