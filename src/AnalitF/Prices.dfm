inherited PricesForm: TPricesForm
  Left = 283
  Top = 179
  ActiveControl = dbgPrices
  Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 573
  ClientWidth = 792
  OldCreateOrder = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 543
    Width = 792
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      792
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
  object Panel2: TPanel [1]
    Left = 0
    Top = 0
    Width = 792
    Height = 543
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object dbgPrices: TToughDBGrid
      Tag = 64
      Left = 0
      Top = 29
      Width = 536
      Height = 514
      Align = alClient
      AllowedOperations = [alopUpdateEh]
      AutoFitColWidths = True
      DataSource = dsPrices
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgPricesDblClick
      OnExit = dbgPricesExit
      OnGetCellParams = dbgPricesGetCellParams
      OnKeyDown = dbgPricesKeyDown
      OnSortMarkingChanged = dbgPricesSortMarkingChanged
      SearchField = 'PriceName'
      SearchPosition = spBottom
      Columns = <
        item
          EditButtons = <>
          FieldName = 'PriceName'
          Footers = <>
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Title.TitleButton = True
          Width = 75
        end
        item
          EditButtons = <>
          FieldName = 'RegionName'
          Footers = <>
          Title.Caption = #1056#1077#1075#1080#1086#1085
          Title.TitleButton = True
          Width = 57
        end
        item
          Checkboxes = False
          EditButtons = <>
          FieldName = 'Storage'
          Footers = <>
          Title.Caption = #1057#1082#1083#1072#1076
          Title.TitleButton = True
          Width = 36
        end
        item
          Checkboxes = True
          EditButtons = <>
          FieldName = 'INJOB'
          Footers = <>
          Title.Caption = #1042' '#1088#1072#1073#1086#1090#1077
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'pricesize'
          Footers = <>
          Title.Caption = #1055#1086#1079#1080#1094#1080#1081
          Title.TitleButton = True
          Width = 50
        end
        item
          EditButtons = <>
          FieldName = 'Positions'
          Footers = <>
          Title.Caption = #1047#1072#1082#1072#1079
          Title.TitleButton = True
          Width = 45
        end
        item
          EditButtons = <>
          FieldName = 'SumOrder'
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072
          Title.TitleButton = True
          Width = 51
        end
        item
          Alignment = taCenter
          DisplayFormat = 'dd.mm.yyyy hh:nn'
          EditButtons = <>
          FieldName = 'DatePrice'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
          Title.TitleButton = True
          Width = 95
        end
        item
          EditButtons = <>
          FieldName = 'sumbycurrentmonth'
          Footers = <>
          Title.Caption = #1052#1077#1089#1103#1095#1085#1099#1081' '#1079#1072#1082#1072#1079
          Title.Hint = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
          Title.TitleButton = True
          Width = 60
        end
        item
          EditButtons = <>
          FieldName = 'sumbycurrentweek'
          Footers = <>
          Title.Caption = #1053#1077#1076#1077#1083#1100#1085#1099#1081' '#1079#1072#1082#1072#1079
          Title.Hint = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' '#1079#1072' '#1090#1077#1082#1091#1097#1091#1102' '#1085#1077#1076#1077#1083#1102
          Title.TitleButton = True
        end>
    end
    object GroupBox1: TGroupBox
      Left = 536
      Top = 29
      Width = 256
      Height = 514
      Align = alRight
      Caption = ' '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '
      TabOrder = 0
      object pPriceHeader: TPanel
        Left = 2
        Top = 41
        Width = 252
        Height = 96
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label3: TLabel
          Left = 5
          Top = 4
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
        object dbtPhones: TDBText
          Left = 72
          Top = 4
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
        object Label5: TLabel
          Left = 5
          Top = 38
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
        object Label2: TLabel
          Left = 5
          Top = 21
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
        object dbtMinOrder: TDBText
          Left = 174
          Top = 21
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
        object stManagerMail: TStaticText
          Left = 24
          Top = 55
          Width = 225
          Height = 33
          Cursor = crHandPoint
          AutoSize = False
          Caption = 'stManagerMail'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold, fsUnderline]
          ParentFont = False
          TabOrder = 0
          Transparent = False
          OnClick = stManagerMailClick
        end
      end
      object pPriceFooter: TPanel
        Left = 2
        Top = 137
        Width = 252
        Height = 375
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object pContact: TPanel
          Left = 0
          Top = 0
          Width = 252
          Height = 120
          Align = alTop
          BevelOuter = bvNone
          Caption = 'pContact'
          TabOrder = 0
          object LabelContact: TLabel
            Left = 0
            Top = 3
            Width = 252
            Height = 13
            Align = alTop
            Caption = ' '#1050#1086#1085#1090#1072#1082#1090#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BevelContact: TBevel
            Left = 0
            Top = 0
            Width = 252
            Height = 3
            Align = alTop
            Shape = bsTopLine
          end
          object DBMemoContact: TDBMemo
            Left = 0
            Top = 16
            Width = 252
            Height = 104
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvSpace
            BevelKind = bkSoft
            BevelWidth = 4
            BorderStyle = bsNone
            Color = clBtnFace
            DataField = 'ContactInfo'
            DataSource = dsPrices
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object pOperativInfo: TPanel
          Left = 0
          Top = 120
          Width = 252
          Height = 255
          Align = alClient
          BevelOuter = bvNone
          Caption = 'pOperativeInfo'
          TabOrder = 1
          object BevelOperativeInfo: TBevel
            Left = 0
            Top = 0
            Width = 252
            Height = 3
            Align = alTop
            Shape = bsTopLine
          end
          object LabelOperativeInfo: TLabel
            Left = 0
            Top = 3
            Width = 252
            Height = 13
            Align = alTop
            Caption = ' '#1054#1087#1077#1088#1072#1090#1080#1074#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object DBMemoOperativeInfo: TDBMemo
            Left = 0
            Top = 16
            Width = 252
            Height = 239
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvSpace
            BevelKind = bkSoft
            BevelWidth = 4
            BorderStyle = bsNone
            Color = clBtnFace
            DataField = 'OperativeInfo'
            DataSource = dsPrices
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
      end
      object pFullName: TPanel
        Left = 2
        Top = 15
        Width = 252
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          252
          26)
        object dbtFullName: TDBText
          Left = 5
          Top = 4
          Width = 71
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = True
          DataField = 'FullName'
          DataSource = dsPrices
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 792
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
  object dsPrices: TDataSource
    DataSet = adsPrices
    Left = 96
    Top = 216
  end
  object tmStopEdit: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmStopEditTimer
    Left = 288
    Top = 272
  end
  object adsPrices: TMyQuery
    SQLUpdate.Strings = (
      'update pricesregionaldata '
      'set'
      '  INJOB = :INJOB'
      'where'
      '    PriceCode = :OLD_PRICECODE'
      'and RegionCode = :OLD_RegionCODE;'
      'insert into pricesregionaldataup '
      'select PriceCode, RegionCode '
      'from'
      '  pricesregionaldata'
      'where'
      '    PriceCode = :OLD_PRICECODE'
      'and RegionCode = :OLD_RegionCODE'
      
        'and not exists(select * from pricesregionaldataup where PriceCod' +
        'e = :OLD_PRICECODE and RegionCode = :OLD_RegionCODE);')
    SQLRefresh.Strings = (
      'SELECT '
      '  pricesshow.*,'
      '  minreqrules.ControlMinReq,'
      '  minreqrules.MinReq,'
      '  pd.PriceInfo,'
      '  rd.SupportPhone, '
      '  rd.ContactInfo, '
      '  rd.OperativeInfo, '
      '  prd.InJob, '
      
        '  pricesshow.UniversalDatePrice - interval :TimeZoneBias minute ' +
        'AS DatePrice,'
      '  count(CurrentOrderLists.ID) as Positions,'
      
        '  ifnull(Sum(CurrentOrderLists.RealPrice * CurrentOrderLists.Ord' +
        'erCount), 0) as SumOrder,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
      '  ('
      '    select'
      
        '      ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.O' +
        'rderCount), 0)'
      '    from'
      '      PostedOrderHeads'
      
        '      INNER JOIN PostedOrderLists ON PostedOrderLists.OrderId=Po' +
        'stedOrderHeads.OrderId'
      '    WHERE PostedOrderHeads.ClientId = :ClientId'
      '       AND PostedOrderHeads.PriceCode = pricesshow.PriceCode'
      '       AND PostedOrderHeads.RegionCode = pricesshow.RegionCode'
      
        '       and PostedOrderHeads.senddate > curdate() + interval (1-d' +
        'ay(curdate())) day'
      '       AND PostedOrderHeads.Closed = 1'
      '       AND PostedOrderHeads.send = 1'
      '       AND PostedOrderLists.OrderCount>0'
      '  ) as sumbycurrentmonth,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1091#1102' '#1085#1077#1076#1077#1083#1102
      '  ('
      '    select'
      
        '      ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.O' +
        'rderCount), 0)'
      '    from'
      '      PostedOrderHeads'
      
        '      INNER JOIN PostedOrderLists ON PostedOrderLists.OrderId=Po' +
        'stedOrderHeads.OrderId'
      '    WHERE PostedOrderHeads.ClientId = :ClientId'
      '       AND PostedOrderHeads.PriceCode = pricesshow.PriceCode'
      '       AND PostedOrderHeads.RegionCode = pricesshow.RegionCode'
      
        '       and PostedOrderHeads.senddate > curdate() + interval (-WE' +
        'EKDAY(curdate())) day'
      '       AND PostedOrderHeads.Closed = 1'
      '       AND PostedOrderHeads.send = 1'
      '       AND PostedOrderLists.OrderCount>0'
      '  ) as sumbycurrentweek'
      'FROM '
      '  pricesshow'
      '  join pricesdata pd on (pd.PriceCode = pricesshow.PriceCode)'
      
        '  join pricesregionaldata prd ON (prd.PRICECODE = pricesshow.Pri' +
        'ceCode) and (prd.RegionCode = pricesshow.RegionCode)'
      
        '  join regionaldata rd on (rd.REGIONCODE = pricesshow.REGIONCODE' +
        ') and (rd.FIRMCODE = pricesshow.FIRMCODE)'
      
        '  left join minreqrules on (minreqrules.ClientId = :ClientId) an' +
        'd (minreqrules.PriceCode = pricesshow.PriceCode) and (minreqrule' +
        's.RegionCode = pricesshow.RegionCode)'
      '  left join CurrentOrderHeads on '
      '        CurrentOrderHeads.Pricecode = pricesshow.PriceCode '
      '    and CurrentOrderHeads.Regioncode = pricesshow.RegionCode'
      '    and CurrentOrderHeads.ClientId   = :ClientId'
      '    and CurrentOrderHeads.Frozen = 0 '
      '    and CurrentOrderHeads.Closed <> 1'
      '  left join CurrentOrderLists on '
      '        CurrentOrderLists.ORDERID = CurrentOrderHeads.ORDERID'
      '    and CurrentOrderLists.OrderCount > 0'
      'where'
      '    pricesshow.PriceCode = :pricecode'
      'and pricesshow.RegionCode = :regioncode'
      'group by pricesshow.PriceCode, pricesshow.RegionCode')
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '  pricesshow.*,'
      '  minreqrules.ControlMinReq,'
      '  minreqrules.MinReq,'
      '  pd.PriceInfo,'
      '  rd.SupportPhone, '
      '  rd.ContactInfo, '
      '  rd.OperativeInfo, '
      '  prd.InJob, '
      
        '  pricesshow.UniversalDatePrice - interval :TimeZoneBias minute ' +
        'AS DatePrice,'
      '  count(CurrentOrderLists.ID) as Positions,'
      
        '  ifnull(Sum(CurrentOrderLists.RealPrice * CurrentOrderLists.Ord' +
        'erCount), 0) as SumOrder,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
      '  ('
      '    select'
      
        '      ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.O' +
        'rderCount), 0)'
      '    from'
      '      PostedOrderHeads'
      
        '      INNER JOIN PostedOrderLists ON PostedOrderLists.OrderId=Po' +
        'stedOrderHeads.OrderId'
      '    WHERE PostedOrderHeads.ClientId = :ClientId'
      '       AND PostedOrderHeads.PriceCode = pricesshow.PriceCode'
      '       AND PostedOrderHeads.RegionCode = pricesshow.RegionCode'
      
        '       and PostedOrderHeads.senddate > curdate() + interval (1-d' +
        'ay(curdate())) day'
      '       AND PostedOrderHeads.Closed = 1'
      '       AND PostedOrderHeads.send = 1'
      '       AND PostedOrderLists.OrderCount>0'
      '  ) as sumbycurrentmonth,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1091#1102' '#1085#1077#1076#1077#1083#1102
      '  ('
      '    select'
      
        '      ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.O' +
        'rderCount), 0)'
      '    from'
      '      PostedOrderHeads'
      
        '      INNER JOIN PostedOrderLists ON PostedOrderLists.OrderId=Po' +
        'stedOrderHeads.OrderId'
      '    WHERE PostedOrderHeads.ClientId = :ClientId'
      '       AND PostedOrderHeads.PriceCode = pricesshow.PriceCode'
      '       AND PostedOrderHeads.RegionCode = pricesshow.RegionCode'
      
        '       and PostedOrderHeads.senddate > curdate() + interval (-WE' +
        'EKDAY(curdate())) day'
      '       AND PostedOrderHeads.Closed = 1'
      '       AND PostedOrderHeads.send = 1'
      '       AND PostedOrderLists.OrderCount>0'
      '  ) as sumbycurrentweek'
      'FROM '
      '  pricesshow'
      '  join pricesdata pd on (pd.PriceCode = pricesshow.PriceCode)'
      
        '  join pricesregionaldata prd ON (prd.PRICECODE = pricesshow.Pri' +
        'ceCode) and (prd.RegionCode = pricesshow.RegionCode)'
      
        '  join regionaldata rd on (rd.REGIONCODE = pricesshow.REGIONCODE' +
        ') and (rd.FIRMCODE = pricesshow.FIRMCODE)'
      
        '  left join minreqrules on (minreqrules.ClientId = :ClientId) an' +
        'd (minreqrules.PriceCode = pricesshow.PriceCode) and (minreqrule' +
        's.RegionCode = pricesshow.RegionCode)'
      '  left join CurrentOrderHeads on '
      '        CurrentOrderHeads.Pricecode = pricesshow.PriceCode '
      '    and CurrentOrderHeads.Regioncode = pricesshow.RegionCode'
      '    and CurrentOrderHeads.ClientId   = :ClientId'
      '    and CurrentOrderHeads.Frozen = 0 '
      '    and CurrentOrderHeads.Closed <> 1'
      '  left join CurrentOrderLists on '
      '        CurrentOrderLists.ORDERID = CurrentOrderHeads.ORDERID'
      '    and CurrentOrderLists.OrderCount > 0'
      'group by pricesshow.PriceCode, pricesshow.RegionCode')
    RefreshOptions = [roAfterUpdate]
    AfterOpen = adsPrices2AfterOpen
    AfterScroll = adsPrices2AfterScroll
    Left = 144
    Top = 152
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TimeZoneBias'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end>
    object adsPricesPriceCode: TLargeintField
      FieldName = 'PriceCode'
      ReadOnly = True
    end
    object adsPricesPriceName: TStringField
      FieldName = 'PriceName'
      ReadOnly = True
      Size = 70
    end
    object adsPricesUniversalDatePrice: TDateTimeField
      FieldName = 'UniversalDatePrice'
      ReadOnly = True
    end
    object adsPricesMinReq: TIntegerField
      FieldName = 'MinReq'
      ReadOnly = True
    end
    object adsPricesEnabled: TBooleanField
      FieldName = 'Enabled'
      ReadOnly = True
    end
    object adsPricesPriceInfo: TMemoField
      FieldName = 'PriceInfo'
      ReadOnly = True
      BlobType = ftMemo
    end
    object adsPricesFirmCode: TLargeintField
      FieldName = 'FirmCode'
      ReadOnly = True
    end
    object adsPricesFullName: TStringField
      FieldName = 'FullName'
      ReadOnly = True
      Size = 40
    end
    object adsPricesStorage: TBooleanField
      Alignment = taCenter
      FieldName = 'Storage'
      ReadOnly = True
      OnGetText = adsPricesOldSTORAGEGetText
    end
    object adsPricesManagerMail: TStringField
      FieldName = 'ManagerMail'
      ReadOnly = True
      Size = 50
    end
    object adsPricesSupportPhone: TStringField
      FieldName = 'SupportPhone'
      ReadOnly = True
    end
    object adsPricesContactInfo: TMemoField
      FieldName = 'ContactInfo'
      ReadOnly = True
      BlobType = ftMemo
    end
    object adsPricesOperativeInfo: TMemoField
      FieldName = 'OperativeInfo'
      ReadOnly = True
      BlobType = ftMemo
    end
    object adsPricesRegionCode: TLargeintField
      FieldName = 'RegionCode'
      ReadOnly = True
    end
    object adsPricesRegionName: TStringField
      FieldName = 'RegionName'
      ReadOnly = True
      Size = 25
    end
    object adsPricespricesize: TIntegerField
      FieldName = 'pricesize'
      ReadOnly = True
    end
    object adsPricesINJOB: TBooleanField
      FieldName = 'INJOB'
      OnChange = adsPricesOldINJOBChange
    end
    object adsPricesCONTROLMINREQ: TBooleanField
      FieldName = 'CONTROLMINREQ'
      ReadOnly = True
    end
    object adsPricesDatePrice: TDateTimeField
      FieldName = 'DatePrice'
      ReadOnly = True
    end
    object adsPricesPositions: TLargeintField
      FieldName = 'Positions'
      ReadOnly = True
    end
    object adsPricessumbycurrentmonth: TFloatField
      FieldName = 'sumbycurrentmonth'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
    end
    object adsPricesSumOrder: TFloatField
      FieldName = 'SumOrder'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
    end
    object adsPricessumbycurrentweek: TFloatField
      FieldName = 'sumbycurrentweek'
      ReadOnly = True
      DisplayFormat = '0.00;;'#39#39
    end
  end
end
