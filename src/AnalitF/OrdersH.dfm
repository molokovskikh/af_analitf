inherited OrdersHForm: TOrdersHForm
  Left = 280
  Top = 172
  ActiveControl = dbgCurrentOrders
  Caption = #1047#1072#1082#1072#1079#1099
  ClientHeight = 573
  ClientWidth = 792
  OldCreateOrder = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl: TTabControl [0]
    Left = 0
    Top = 39
    Width = 792
    Height = 534
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
      Height = 506
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object pBottom: TPanel
        Tag = 146
        Left = 0
        Top = 470
        Width = 784
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          784
          36)
        object btnMoveSend: TButton
          Left = 163
          Top = 4
          Width = 150
          Height = 27
          Anchors = [akLeft, akBottom]
          Caption = #1055#1077#1088#1077#1074#1077#1089#1090#1080' '#1074' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1077
          TabOrder = 1
          OnClick = btnMoveSendClick
        end
        object btnDelete: TButton
          Left = 3
          Top = 4
          Width = 150
          Height = 27
          Anchors = [akLeft, akBottom]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 0
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
        Height = 470
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object bevClient: TBevel
          Left = 0
          Top = 360
          Width = 784
          Height = 4
          Align = alBottom
          Shape = bsTopLine
        end
        object pGrid: TPanel
          Left = 0
          Top = 0
          Width = 483
          Height = 360
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object dbgCurrentOrders: TToughDBGrid
            Tag = 1024
            Left = 0
            Top = 0
            Width = 483
            Height = 360
            Align = alClient
            AllowedOperations = [alopUpdateEh]
            AllowedSelections = [gstRecordBookmarks, gstRectangle, gstAll]
            AutoFitColWidths = True
            DataSource = dsOrdersH
            Flat = True
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'MS Sans Serif'
            FooterFont.Style = []
            Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            OnDblClick = dbgCurrentOrdersDblClick
            OnExit = dbgCurrentOrdersExit
            OnGetCellParams = dbgCurrentOrdersGetCellParams
            OnKeyDown = dbgCurrentOrdersKeyDown
            OnKeyPress = dbgCurrentOrdersKeyPress
            OnSortMarkingChanged = dbgCurrentOrdersSortMarkingChanged
            SearchPosition = spBottom
            Columns = <
              item
                DisplayFormat = 'dd.mm.yyyy hh:nn'
                EditButtons = <>
                FieldName = 'OrderDate'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1057#1086#1079#1076#1072#1085#1086
                Title.TitleButton = True
                Width = 48
              end
              item
                EditButtons = <>
                FieldName = 'PriceName'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
                Title.TitleButton = True
                Width = 65
              end
              item
                EditButtons = <>
                FieldName = 'RegionName'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1056#1077#1075#1080#1086#1085
                Title.TitleButton = True
                Width = 42
              end
              item
                EditButtons = <>
                FieldName = 'Positions'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1055#1086#1079#1080#1094#1080#1081
                Title.TitleButton = True
                Width = 48
              end
              item
                Checkboxes = True
                EditButtons = <>
                FieldName = 'Send'
                Footers = <>
                MinWidth = 5
                ReadOnly = False
                Title.Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
                Title.TitleButton = True
                Width = 56
              end
              item
                EditButtons = <>
                FieldName = 'minreq'
                Footers = <>
                Title.Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072
                Title.TitleButton = True
              end
              item
                EditButtons = <>
                FieldName = 'SumOrder'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1057#1091#1084#1084#1072
                Title.TitleButton = True
                Width = 38
              end
              item
                EditButtons = <>
                FieldName = 'sumbycurrentmonth'
                Footers = <>
                Title.Caption = #1052#1077#1089#1103#1095#1085#1099#1081' '#1079#1072#1082#1072#1079
                Title.Hint = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
                Title.TitleButton = True
                Width = 40
              end>
          end
          object dbgSendedOrders: TToughDBGrid
            Tag = 2048
            Left = 0
            Top = 0
            Width = 483
            Height = 360
            Align = alClient
            AllowedOperations = [alopUpdateEh]
            AllowedSelections = [gstRecordBookmarks, gstRectangle, gstAll]
            AutoFitColWidths = True
            DataSource = dsOrdersH
            Flat = True
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'MS Sans Serif'
            FooterFont.Style = []
            Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            Visible = False
            OnDblClick = dbgCurrentOrdersDblClick
            OnExit = dbgCurrentOrdersExit
            OnGetCellParams = dbgCurrentOrdersGetCellParams
            OnKeyDown = dbgCurrentOrdersKeyDown
            OnKeyPress = dbgCurrentOrdersKeyPress
            OnSortMarkingChanged = dbgCurrentOrdersSortMarkingChanged
            SearchPosition = spBottom
            Columns = <
              item
                DisplayFormat = 'dd.mm.yyyy hh:nn'
                EditButtons = <>
                FieldName = 'SendDate'
                Footers = <>
                Title.Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086
                Title.TitleButton = True
                Width = 66
              end
              item
                DisplayFormat = 'dd.mm.yyyy hh:nn'
                EditButtons = <>
                FieldName = 'OrderDate'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1057#1086#1079#1076#1072#1085#1086
                Title.TitleButton = True
                Width = 48
              end
              item
                EditButtons = <>
                FieldName = 'PriceName'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
                Title.TitleButton = True
                Width = 65
              end
              item
                EditButtons = <>
                FieldName = 'RegionName'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1056#1077#1075#1080#1086#1085
                Title.TitleButton = True
                Width = 42
              end
              item
                EditButtons = <>
                FieldName = 'Positions'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1055#1086#1079#1080#1094#1080#1081
                Title.TitleButton = True
                Width = 48
              end
              item
                EditButtons = <>
                FieldName = 'SumOrder'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1057#1091#1084#1084#1072
                Title.TitleButton = True
                Width = 38
              end>
          end
        end
        object pRight: TPanel
          Left = 483
          Top = 0
          Width = 301
          Height = 360
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
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
        end
        object pWebBrowser: TPanel
          Tag = 106
          Left = 0
          Top = 364
          Width = 784
          Height = 106
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
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
  object pTop: TPanel [1]
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
  inherited tCheckVolume: TTimer
    Top = 88
  end
  object dsOrdersH: TDataSource
    DataSet = adsOrdersHForm
    Left = 72
    Top = 176
  end
  object tmOrderDateChange: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmOrderDateChangeTimer
    Left = 76
    Top = 223
  end
  object adsOrdersHFormOld: TpFIBDataSet
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
      '    SUPPORTPHONE,'
      '    MESSAGETO,'
      '    COMMENTS'
      'FROM'
      '    ORDERSHSHOW (:ACLIENTID,'
      '    :ACLOSED,'
      '    :TIMEZONEBIAS)'
      'WHERE'
      '(ORDERID = :OLD_ORDERID)'
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
      '    SUPPORTPHONE,'
      '    MESSAGETO,'
      '    COMMENTS,'
      '    MinReq,'
      '    SUMBYCURRENTMONTH'
      'FROM'
      '    ORDERSHSHOW (:ACLIENTID,'
      '    :ACLOSED,'
      '    :TIMEZONEBIAS)'
      'WHERE OrderDate BETWEEN :DateFrom AND :DateTo '
      'order by SendDate DESC')
    AfterPost = adsOrdersH2AfterPost
    BeforePost = adsOrdersH2BeforePost
    OnCalcFields = adsOrdersHFormOldCalcFields
    Database = DM.MainConnectionOld
    AfterFetchRecord = adsOrdersHFormOldAfterFetchRecord
    AutoCommit = True
    Left = 68
    Top = 119
    oCacheCalcFields = True
    oFetchAll = True
    object adsOrdersHFormOldORDERID: TFIBBCDField
      FieldName = 'ORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHFormOldSERVERORDERID: TFIBBCDField
      FieldName = 'SERVERORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHFormOldDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsOrdersHFormOldPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHFormOldREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHFormOldORDERDATE: TFIBDateTimeField
      FieldName = 'ORDERDATE'
    end
    object adsOrdersHFormOldSENDDATE: TFIBDateTimeField
      FieldName = 'SENDDATE'
    end
    object adsOrdersHFormOldCLOSED: TFIBBooleanField
      FieldName = 'CLOSED'
    end
    object adsOrdersHFormOldSEND: TFIBBooleanField
      FieldName = 'SEND'
      OnChange = adsOrdersH2SendChange
    end
    object adsOrdersHFormOldPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsOrdersHFormOldREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsOrdersHFormOldPOSITIONS: TFIBIntegerField
      FieldName = 'POSITIONS'
    end
    object adsOrdersHFormOldSUPPORTPHONE: TFIBStringField
      FieldName = 'SUPPORTPHONE'
      EmptyStrToNull = True
    end
    object adsOrdersHFormOldSumOrder: TFIBBCDField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Size = 2
      RoundByScale = True
      Calculated = True
    end
    object adsOrdersHFormOldMESSAGETO: TFIBMemoField
      FieldName = 'MESSAGETO'
      BlobType = ftMemo
      Size = 8
    end
    object adsOrdersHFormOldCOMMENTS: TFIBMemoField
      FieldName = 'COMMENTS'
      BlobType = ftMemo
      Size = 8
    end
    object adsOrdersHFormOldMINREQ: TFIBIntegerField
      FieldName = 'MINREQ'
    end
    object adsOrdersHFormOldSUMBYCURRENTMONTH: TFIBBCDField
      FieldName = 'SUMBYCURRENTMONTH'
      Size = 2
      RoundByScale = True
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
    SelectSQL.Strings = (
      'SELECT'
      '    CCore.CoreId AS CoreId,'
      '    catalogs.fullcode as FullCode,'
      '    catalogs.shortcode,'
      '    CCore.CodeFirmCr,'
      '    CCore.SynonymCode,'
      '    CCore.SynonymFirmCrCode,'
      '    CCore.Code,'
      '    CCore.CodeCr,'
      '    CCore.Volume,'
      '    CCore.Doc,'
      '    CCore.Note,'
      '    CCore.Period,'
      '    CCore.Await,'
      '    CCore.Junk,'
      '    CCore.BaseCost,'
      '    CCore.Quantity,'
      
        '    coalesce(Synonyms.SynonymName, catalogs.name || '#39' '#39' || catal' +
        'ogs.form) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceCode AS LeaderPriceCode,'
      '    MinPrices.RegionCode AS LeaderRegionCode,'
      '    Regions.RegionName AS LeaderRegionName,'
      '    PricesData.PriceName AS LeaderPriceName,'
      '    LCore.code as LeaderCODE,'
      '    LCore.codecr as LeaderCODECR,'
      '    LCore.basecost as LeaderPRICE,'
      '    osbc.CoreId AS OrdersCoreId,'
      '    osbc.OrderId AS OrdersOrderId,'
      '    osbc.ClientId AS OrdersClientId,'
      '    catalogs.fullcode AS OrdersFullCode,'
      '    osbc.CodeFirmCr AS OrdersCodeFirmCr,'
      '    osbc.SynonymCode AS OrdersSynonymCode,'
      '    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,'
      '    osbc.Code AS OrdersCode,'
      '    osbc.CodeCr AS OrdersCodeCr,'
      '    osbc.OrderCount,'
      '    osbc.SynonymName AS OrdersSynonym,'
      '    osbc.SynonymFirm AS OrdersSynonymFirm,'
      '    osbc.Price AS OrdersPrice,'
      '    osbc.Junk AS OrdersJunk,'
      '    osbc.Await AS OrdersAwait,'
      '    OrdersH.OrderId AS OrdersHOrderId,'
      '    OrdersH.ClientId AS OrdersHClientId,'
      '    OrdersH.PriceCode AS OrdersHPriceCode,'
      '    OrdersH.RegionCode AS OrdersHRegionCode,'
      '    OrdersH.PriceName AS OrdersHPriceName,'
      '    OrdersH.RegionName AS OrdersHRegionName,'
      '    CCore.VitallyImportant,'
      '    CCore.RequestRatio,'
      '    CCore.OrderCost,'
      '    CCore.MinOrderCount'
      'FROM'
      '    Core CCore'
      '    left join products on products.productid = CCore.productid'
      '    left join catalogs on catalogs.fullcode = products.catalogid'
      
        '    LEFT JOIN MinPrices ON MinPrices.productid = CCore.productid' +
        ' and minprices.regioncode = :aregioncode'
      
        '    left join Core LCore on LCore.servercoreid = minprices.serve' +
        'rcoreid and LCore.RegionCode = minprices.regioncode'
      '    LEFT JOIN PricesData ON PricesData.PriceCode=LCore.pricecode'
      '    LEFT JOIN Regions ON MinPrices.RegionCode=Regions.RegionCode'
      
        '    LEFT JOIN SynonymFirmCr ON CCore.SynonymFirmCrCode=SynonymFi' +
        'rmCr.SynonymFirmCrCode'
      '    left join synonyms on CCore.SynonymCode=Synonyms.SynonymCode'
      
        '    LEFT JOIN Orders osbc ON osbc.ClientId = :AClientId and osbc' +
        '.CoreId=CCore.CoreId'
      '    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId'
      
        'WHERE (CCore.PriceCode=:APriceCode) And (CCore.RegionCode=:ARegi' +
        'onCode)'
      'and  CCore.SYNONYMCODE = :SYNONYMCODE'
      'and CCore.SYNONYMFIRMCRCODE = :SYNONYMFIRMCRCODE')
    Database = DM.MainConnectionOld
    AutoCommit = True
    Left = 188
    Top = 119
    oCacheCalcFields = True
  end
  object adsOrdersHForm: TMyQuery
    SQLDelete.Strings = (
      'call DeleteOrder(:Old_OrderId)')
    SQLUpdate.Strings = (
      'update ordershead'
      'set'
      '  SEND = :SEND,'
      '  CLOSED = :CLOSED,'
      '  MESSAGETO = :MESSAGETO,'
      '  COMMENTS = :COMMENTS'
      'where'
      '  orderid = :old_ORDERID')
    SQLRefresh.Strings = (
      '#ORDERSHSHOW'
      'SELECT'
      '    OrdersHead.OrderId,'
      '    OrdersHead.ClientID,'
      '    OrdersHead.ServerOrderId,'
      
        '    PricesData.DatePrice - interval :timezonebias minute AS Date' +
        'Price,'
      '    OrdersHead.PriceCode,'
      '    OrdersHead.RegionCode,'
      '    OrdersHead.OrderDate,'
      '    OrdersHead.SendDate,'
      '    OrdersHead.Closed,'
      '    OrdersHead.Send,'
      '    OrdersHead.PriceName,'
      '    OrdersHead.RegionName,'
      '    RegionalData.SupportPhone,'
      '    OrdersHead.MessageTo,'
      '    OrdersHead.Comments,'
      '    pricesregionaldata.minreq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(OrdersList.Id) as Positions,'
      
        '    ifnull(Sum(OrdersList.Price * OrdersList.OrderCount), 0) as ' +
        'SumOrder,'
      '     ('
      '  select'
      '    ifnull(Sum(OrdersList.Price * OrdersList.OrderCount), 0)'
      '  from'
      '    OrdersHead header'
      
        '    INNER JOIN OrdersList ON (OrdersList.OrderId = header.OrderI' +
        'd)'
      '  WHERE OrdersHead.ClientId = :ClientId'
      '     AND header.PriceCode = OrdersHead.PriceCode'
      '     AND header.RegionCode = OrdersHead.RegionCode'
      
        '     and header.senddate > curdate() + interval (1-day(curdate()' +
        ')) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND OrdersList.OrderCount>0'
      ') as sumbycurrentmonth'
      'FROM'
      '   OrdersHead'
      '   inner join OrdersList on '
      '         (OrdersList.OrderId = OrdersHead.OrderId) '
      '     and (OrdersList.OrderCount > 0)'
      '   LEFT JOIN PricesData ON '
      '         (OrdersHead.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      '         (pricesregionaldata.PriceCode = OrdersHead.PriceCode) '
      '     and pricesregionaldata.regioncode = OrdersHead.regioncode'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=OrdersHead.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      'WHERE'
      '    (OrdersHead.OrderId = :Old_OrderId)'
      'group by OrdersHead.OrderId'
      'having count(OrdersList.Id) > 0')
    Connection = DM.MyConnection
    SQL.Strings = (
      '#ORDERSHSHOW'
      'SELECT'
      '    OrdersHead.OrderId,'
      '    OrdersHead.ClientID,'
      '    OrdersHead.ServerOrderId,'
      
        '    PricesData.DatePrice - interval :timezonebias minute AS Date' +
        'Price,'
      '    OrdersHead.PriceCode,'
      '    OrdersHead.RegionCode,'
      '    OrdersHead.OrderDate,'
      '    OrdersHead.SendDate,'
      '    OrdersHead.Closed,'
      '    OrdersHead.Send,'
      '    OrdersHead.PriceName,'
      '    OrdersHead.RegionName,'
      '    RegionalData.SupportPhone,'
      '    OrdersHead.MessageTo,'
      '    OrdersHead.Comments,'
      '    pricesregionaldata.minreq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(OrdersList.Id) as Positions,'
      
        '    ifnull(Sum(OrdersList.Price * OrdersList.OrderCount), 0) as ' +
        'SumOrder,'
      '     ('
      '  select'
      '    ifnull(Sum(OrdersList.Price * OrdersList.OrderCount), 0)'
      '  from'
      '    OrdersHead header'
      
        '    INNER JOIN OrdersList ON (OrdersList.OrderId = header.OrderI' +
        'd)'
      '  WHERE OrdersHead.ClientId = :AClientId'
      '     AND header.PriceCode = OrdersHead.PriceCode'
      '     AND header.RegionCode = OrdersHead.RegionCode'
      
        '     and header.senddate > curdate() + interval (1-day(curdate()' +
        ')) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND OrdersList.OrderCount>0'
      ') as sumbycurrentmonth'
      'FROM'
      '   OrdersHead'
      '   inner join OrdersList on '
      '         (OrdersList.OrderId = OrdersHead.OrderId) '
      '     and (OrdersList.OrderCount > 0)'
      '   LEFT JOIN PricesData ON '
      '         (OrdersHead.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      '         (pricesregionaldata.PriceCode = OrdersHead.PriceCode) '
      '     and pricesregionaldata.regioncode = OrdersHead.regioncode'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=OrdersHead.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      'WHERE'
      '    (OrdersHead.ClientId = :AClientId)'
      'and (OrdersHead.Closed = :AClosed)'
      
        'and ((:AClosed = 1) or ((:AClosed = 0) and (PricesData.PriceCode' +
        ' is not null) and (RegionalData.RegionCode is not null) and (pri' +
        'cesregionaldata.PriceCode is not null)))'
      'and (OrdersHead.OrderDate BETWEEN :DateFrom AND :DateTo )'
      'group by OrdersHead.OrderId'
      'having count(OrdersList.Id) > 0'
      'order by OrdersHead.SendDate DESC')
    Options.StrictUpdate = False
    Left = 108
    Top = 119
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'timezonebias'
      end
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end
      item
        DataType = ftUnknown
        Name = 'AClosed'
      end
      item
        DataType = ftUnknown
        Name = 'AClosed'
      end
      item
        DataType = ftUnknown
        Name = 'AClosed'
      end
      item
        DataType = ftUnknown
        Name = 'DateFrom'
      end
      item
        DataType = ftUnknown
        Name = 'DateTo'
      end>
    object adsOrdersHFormOrderId: TLargeintField
      FieldName = 'OrderId'
    end
    object adsOrdersHFormClientID: TLargeintField
      FieldName = 'ClientID'
    end
    object adsOrdersHFormServerOrderId: TLargeintField
      FieldName = 'ServerOrderId'
    end
    object adsOrdersHFormDatePrice: TDateTimeField
      FieldName = 'DatePrice'
    end
    object adsOrdersHFormPriceCode: TLargeintField
      FieldName = 'PriceCode'
    end
    object adsOrdersHFormRegionCode: TLargeintField
      FieldName = 'RegionCode'
    end
    object adsOrdersHFormOrderDate: TDateTimeField
      FieldName = 'OrderDate'
    end
    object adsOrdersHFormSendDate: TDateTimeField
      FieldName = 'SendDate'
    end
    object adsOrdersHFormClosed: TBooleanField
      FieldName = 'Closed'
    end
    object adsOrdersHFormSend: TBooleanField
      FieldName = 'Send'
    end
    object adsOrdersHFormPriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsOrdersHFormRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsOrdersHFormSupportPhone: TStringField
      FieldName = 'SupportPhone'
    end
    object adsOrdersHFormMessageTo: TMemoField
      FieldName = 'MessageTo'
      BlobType = ftMemo
    end
    object adsOrdersHFormComments: TMemoField
      FieldName = 'Comments'
      BlobType = ftMemo
    end
    object adsOrdersHFormminreq: TIntegerField
      FieldName = 'minreq'
    end
    object adsOrdersHFormPriceEnabled: TBooleanField
      FieldName = 'PriceEnabled'
    end
    object adsOrdersHFormPositions: TLargeintField
      FieldName = 'Positions'
    end
    object adsOrdersHFormSumOrder: TFloatField
      FieldName = 'SumOrder'
    end
    object adsOrdersHFormsumbycurrentmonth: TFloatField
      FieldName = 'sumbycurrentmonth'
    end
  end
end
