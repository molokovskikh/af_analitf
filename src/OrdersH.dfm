inherited OrdersHForm: TOrdersHForm
  Left = 280
  Top = 299
  ActiveControl = dbgOrdersH
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
          object dbgOrdersH: TToughDBGrid
            Left = 0
            Top = 0
            Width = 483
            Height = 360
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
            OnSortMarkingChanged = dbgOrdersHSortMarkingChanged
            SearchPosition = spBottom
            Columns = <
              item
                DisplayFormat = 'dd.mm.yyyy hh:nn'
                EditButtons = <>
                FieldName = 'SENDDATE'
                Footers = <>
                Title.Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086
                Title.TitleButton = True
                Width = 70
              end
              item
                DisplayFormat = 'dd.mm.yyyy hh:nn'
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
                Checkboxes = True
                EditButtons = <>
                FieldName = 'SEND'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
                Title.TitleButton = True
                Width = 60
              end
              item
                EditButtons = <>
                FieldName = 'SumOrder'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1057#1091#1084#1084#1072
                Title.TitleButton = True
                Width = 60
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
  object dsOrdersH: TDataSource
    DataSet = adsOrdersHForm
    Left = 72
    Top = 176
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
  object adsOrdersHForm: TpFIBDataSet
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
    BeforePost = adsOrdersH2BeforePost
    OnCalcFields = adsOrdersHFormCalcFields
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    AfterFetchRecord = adsOrdersHFormAfterFetchRecord
    UpdateTransaction = DM.UpTran
    AutoCommit = True
    Left = 68
    Top = 119
    oCacheCalcFields = True
    oFetchAll = True
    object adsOrdersHFormORDERID: TFIBBCDField
      FieldName = 'ORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHFormSERVERORDERID: TFIBBCDField
      FieldName = 'SERVERORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHFormDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsOrdersHFormPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHFormREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersHFormORDERDATE: TFIBDateTimeField
      FieldName = 'ORDERDATE'
    end
    object adsOrdersHFormSENDDATE: TFIBDateTimeField
      FieldName = 'SENDDATE'
    end
    object adsOrdersHFormCLOSED: TFIBBooleanField
      FieldName = 'CLOSED'
    end
    object adsOrdersHFormSEND: TFIBBooleanField
      FieldName = 'SEND'
      OnChange = adsOrdersH2SendChange
    end
    object adsOrdersHFormPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsOrdersHFormREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsOrdersHFormPOSITIONS: TFIBIntegerField
      FieldName = 'POSITIONS'
    end
    object adsOrdersHFormSUPPORTPHONE: TFIBStringField
      FieldName = 'SUPPORTPHONE'
      EmptyStrToNull = True
    end
    object adsOrdersHFormSumOrder: TFIBBCDField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      DisplayFormat = '0.00;;'#39#39
      Size = 2
      RoundByScale = True
      Calculated = True
    end
    object adsOrdersHFormMESSAGETO: TFIBMemoField
      FieldName = 'MESSAGETO'
      BlobType = ftMemo
      Size = 8
    end
    object adsOrdersHFormCOMMENTS: TFIBMemoField
      FieldName = 'COMMENTS'
      BlobType = ftMemo
      Size = 8
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
      '    CCore.RequestRatio'
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
    Transaction = DM.DefTran
    Database = DM.MainConnection1
    UpdateTransaction = DM.UpTran
    AutoCommit = True
    Left = 188
    Top = 119
    oCacheCalcFields = True
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
    oCacheCalcFields = True
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
      EmptyStrToNull = True
    end
    object adsWayBillHeadREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsWayBillHeadFIRMCOMMENT: TFIBStringField
      FieldName = 'FIRMCOMMENT'
      Size = 100
      EmptyStrToNull = True
    end
    object adsWayBillHeadROWCOUNT: TFIBIntegerField
      FieldName = 'ROWCOUNT'
    end
  end
end
