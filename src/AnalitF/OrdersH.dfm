inherited OrdersHForm: TOrdersHForm
  Left = 368
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
        object sbMoveToPrice: TSpeedButton
          Left = 632
          Top = 4
          Width = 150
          Height = 27
          Hint = #1055#1077#1088#1077#1088#1072#1089#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084' '#1080#1084#1077#1102#1097#1080#1084' '#1079#1072#1082#1072#1079#1099
          Caption = #1055#1077#1088#1077#1088#1072#1089#1087#1088#1077#1076#1077#1083#1080#1090#1100
          Layout = blGlyphRight
          ParentShowHint = False
          ShowHint = True
          Spacing = 10
          OnClick = sbMoveToPriceClick
        end
        object sbMoveToClient: TSpeedButton
          Left = 480
          Top = 4
          Width = 150
          Height = 27
          Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1085#1072' '#1076#1088'.'#1072#1076#1088#1077#1089
          Glyph.Data = {
            A6000000424DA600000000000000760000002800000009000000060000000100
            0400000000003000000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333000
            0000333303333000000033300033300000003300000330000000300000003000
            00003333333330000000}
          Layout = blGlyphRight
          Spacing = 10
          OnClick = sbMoveToClientClick
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
        object btnUnFrozen: TButton
          Left = 328
          Top = 4
          Width = 150
          Height = 27
          Anchors = [akLeft, akBottom]
          Caption = '"'#1056#1072#1079#1084#1086#1088#1086#1079#1080#1090#1100'" '#1079#1072#1082#1072#1079#1099
          TabOrder = 4
          OnClick = btnUnFrozenClick
        end
        object btnMoveSend: TButton
          Left = 163
          Top = 4
          Width = 150
          Height = 27
          Anchors = [akLeft, akBottom]
          Caption = #1042#1077#1088#1085#1091#1090#1100' '#1074' '#1090#1077#1082#1091#1097#1080#1077
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
        object btnFrozen: TButton
          Left = 163
          Top = 4
          Width = 150
          Height = 27
          Anchors = [akLeft, akBottom]
          Caption = '"'#1047#1072#1084#1086#1088#1086#1079#1080#1090#1100'" '#1079#1072#1082#1072#1079#1099
          TabOrder = 3
          OnClick = btnFrozenClick
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
          Top = 466
          Width = 784
          Height = 4
          Align = alBottom
          Shape = bsTopLine
        end
        object pGrid: TPanel
          Left = 0
          Top = 0
          Width = 483
          Height = 466
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object dbgSendedOrders: TToughDBGrid
            Tag = 2048
            Left = 0
            Top = 0
            Width = 483
            Height = 466
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
            OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
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
                EditButtons = <>
                FieldName = 'DisplayOrderId'
                Footers = <>
                MinWidth = 5
                Title.Caption = #1047#1072#1082#1072#1079' '#8470
                Title.TitleButton = True
              end
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
          object dbgCurrentOrders: TToughDBGrid
            Tag = 1024
            Left = 0
            Top = 0
            Width = 483
            Height = 466
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
            OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
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
                OnGetCellParams = dbgCurrentOrdersColumns4GetCellParams
              end
              item
                EditButtons = <>
                FieldName = 'MinReq'
                Footers = <>
                Title.Caption = #1052#1080#1085'.'#1089#1091#1084#1084#1072
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
        end
        object pRight: TPanel
          Left = 483
          Top = 0
          Width = 301
          Height = 466
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
              OnEnter = dbMemoEnter
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
              OnEnter = dbMemoEnter
            end
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
  object adsOrdersHForm: TMyQuery
    SQLDelete.Strings = (
      'delete from CurrentOrderLists where OrderId = :Old_OrderId;'
      'delete from CurrentOrderHeads where OrderId = :Old_OrderId;')
    SQLUpdate.Strings = (
      'update CurrentOrderHeads'
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
      '    CurrentOrderHeads.OrderId,'
      '    CurrentOrderHeads.ClientID,'
      '    CurrentOrderHeads.ServerOrderId,'
      
        '    PricesData.DatePrice - interval :timezonebias minute AS Date' +
        'Price,'
      '    CurrentOrderHeads.PriceCode,'
      '    CurrentOrderHeads.RegionCode,'
      '    CurrentOrderHeads.OrderDate,'
      '    CurrentOrderHeads.SendDate,'
      '    CurrentOrderHeads.Closed,'
      '    CurrentOrderHeads.Send,'
      '    CurrentOrderHeads.PriceName,'
      '    CurrentOrderHeads.RegionName,'
      '    RegionalData.SupportPhone,'
      '    CurrentOrderHeads.MessageTo,'
      '    CurrentOrderHeads.Comments,'
      
        '    GREATEST(MinReqRules.minreq, ifnull(CurrentOrderHeads.Server' +
        'MinReq, 0)) as MinReq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(CurrentOrderLists.Id) as Positions,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 1 or CurrentOrderLists.DropReason = ' +
        '3), 1, null)) as DifferentCostCount,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 2 or CurrentOrderLists.DropReason = ' +
        '3), 1, null)) as DifferentQuantityCount,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 0), 1, null)) as NotExistsCount,'
      
        '    ifnull(Sum(CurrentOrderLists.RealPrice * CurrentOrderLists.O' +
        'rderCount), 0) as SumOrder,'
      '     ('
      '  select'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0)'
      '  from'
      '    PostedOrderHeads header'
      
        '    INNER JOIN PostedOrderLists ON (PostedOrderLists.OrderId = h' +
        'eader.OrderId)'
      '  WHERE header.ClientId = :ClientId'
      '     AND header.PriceCode = CurrentOrderHeads.PriceCode'
      '     AND header.RegionCode = CurrentOrderHeads.RegionCode'
      
        '     and header.senddate > curdate() + interval (1-day(curdate()' +
        ')) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND PostedOrderLists.OrderCount>0'
      ') as sumbycurrentmonth,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1091#1102' '#1085#1077#1076#1077#1083#1102
      '('
      '  select'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0)'
      '  from'
      '    PostedOrderHeads header'
      
        '    INNER JOIN PostedOrderLists ON (PostedOrderLists.OrderId = h' +
        'eader.OrderId)'
      '  WHERE header.ClientId = :ClientId'
      '     AND header.PriceCode = CurrentOrderHeads.PriceCode'
      '     AND header.RegionCode = CurrentOrderHeads.RegionCode'
      
        '     and header.senddate > curdate() + interval (-WEEKDAY(curdat' +
        'e())) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND PostedOrderLists.OrderCount>0'
      '  ) as sumbycurrentweek'
      'FROM'
      '   CurrentOrderHeads'
      '   inner join CurrentOrderLists on '
      
        '         (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId)' +
        ' '
      '     and (CurrentOrderLists.OrderCount > 0)'
      '   LEFT JOIN PricesData ON '
      '         (CurrentOrderHeads.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      
        '         (pricesregionaldata.PriceCode = CurrentOrderHeads.Price' +
        'Code) '
      
        '     and pricesregionaldata.regioncode = CurrentOrderHeads.regio' +
        'ncode'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=CurrentOrderHeads.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      '   LEFT JOIN MinReqRules  ON '
      '         (MinReqRules.ClientId = CurrentOrderHeads.ClientId) '
      '     and (MinReqRules.PriceCode = CurrentOrderHeads.PriceCode) '
      '     and (MinReqRules.RegionCode = CurrentOrderHeads.RegionCode)'
      'WHERE'
      '    (CurrentOrderHeads.OrderId = :Old_OrderId)'
      'group by CurrentOrderHeads.OrderId'
      'having count(CurrentOrderLists.Id) > 0')
    Connection = DM.MyConnection
    SQL.Strings = (
      '#ORDERSHSHOW'
      'SELECT'
      '    CurrentOrderHeads.OrderId,'
      
        '    ifnull(CurrentOrderHeads.ServerOrderId, CurrentOrderHeads.Or' +
        'derId) as DisplayOrderId,'
      '    CurrentOrderHeads.ClientID,'
      '    CurrentOrderHeads.ServerOrderId,'
      
        '    PricesData.DatePrice - interval :timezonebias minute AS Date' +
        'Price,'
      '    CurrentOrderHeads.PriceCode,'
      '    CurrentOrderHeads.RegionCode,'
      '    CurrentOrderHeads.OrderDate,'
      '    CurrentOrderHeads.SendDate,'
      '    CurrentOrderHeads.Closed,'
      '    CurrentOrderHeads.Send,'
      '    CurrentOrderHeads.Frozen,'
      '    CurrentOrderHeads.PriceName,'
      '    CurrentOrderHeads.RegionName,'
      '    RegionalData.SupportPhone,'
      '    CurrentOrderHeads.MessageTo,'
      '    CurrentOrderHeads.Comments,'
      
        '    GREATEST(MinReqRules.minreq, ifnull(CurrentOrderHeads.Server' +
        'MinReq, 0)) as MinReq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(CurrentOrderLists.Id) as Positions,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 1 or CurrentOrderLists.DropReason = ' +
        '3), 1, null)) as DifferentCostCount,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 2 or CurrentOrderLists.DropReason = ' +
        '3), 1, null)) as DifferentQuantityCount,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 0), 1, null)) as NotExistsCount,'
      
        '    ifnull(Sum(CurrentOrderLists.RealPrice * CurrentOrderLists.O' +
        'rderCount), 0) as SumOrder,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
      '     ('
      '  select'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0)'
      '  from'
      '    PostedOrderHeads header'
      
        '    INNER JOIN PostedOrderLists ON (PostedOrderLists.OrderId = h' +
        'eader.OrderId)'
      '  WHERE header.ClientId = :ClientId'
      '     AND header.PriceCode = CurrentOrderHeads.PriceCode'
      '     AND header.RegionCode = CurrentOrderHeads.RegionCode'
      
        '     and header.senddate > curdate() + interval (1-day(curdate()' +
        ')) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND PostedOrderLists.OrderCount>0'
      ')'
      '   as sumbycurrentmonth,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1091#1102' '#1085#1077#1076#1077#1083#1102
      '('
      '  select'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0)'
      '  from'
      '    PostedOrderHeads header'
      
        '    INNER JOIN PostedOrderLists ON (PostedOrderLists.OrderId = h' +
        'eader.OrderId)'
      '  WHERE header.ClientId = :ClientId'
      '     AND header.PriceCode = CurrentOrderHeads.PriceCode'
      '     AND header.RegionCode = CurrentOrderHeads.RegionCode'
      
        '     and header.senddate > curdate() + interval (-WEEKDAY(curdat' +
        'e())) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND PostedOrderLists.OrderCount>0'
      '  ) '
      'as sumbycurrentweek,'
      '  c.Name as AddressName'
      'FROM'
      '   CurrentOrderHeads'
      
        '   inner join clients c on c.ClientId = CurrentOrderHeads.Client' +
        'Id'
      '   inner join CurrentOrderLists on '
      
        '         (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId)' +
        ' '
      '     and (CurrentOrderLists.OrderCount > 0)'
      '   LEFT JOIN PricesData ON '
      '         (CurrentOrderHeads.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      
        '         (pricesregionaldata.PriceCode = CurrentOrderHeads.Price' +
        'Code) '
      
        '     and pricesregionaldata.regioncode = CurrentOrderHeads.regio' +
        'ncode'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=CurrentOrderHeads.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      '   LEFT JOIN MinReqRules  ON '
      '         (MinReqRules.ClientId = CurrentOrderHeads.ClientId) '
      '     and (MinReqRules.PriceCode = CurrentOrderHeads.PriceCode) '
      '     and (MinReqRules.RegionCode = CurrentOrderHeads.RegionCode)'
      'WHERE'
      '    (CurrentOrderHeads.ClientId = :ClientId)'
      'and (CurrentOrderHeads.Closed = :Closed)'
      
        'and (((:Closed = 1) and (CurrentOrderHeads.OrderDate BETWEEN :Da' +
        'teFrom AND :DateTo ))'
      
        'or ((:Closed = 0) and (PricesData.PriceCode is not null) and (Re' +
        'gionalData.RegionCode is not null) and (pricesregionaldata.Price' +
        'Code is not null)))'
      'group by CurrentOrderHeads.OrderId'
      'having count(CurrentOrderLists.Id) > 0'
      'order by CurrentOrderHeads.SendDate DESC')
    BeforeInsert = adsOrdersHFormBeforeInsert
    BeforePost = adsOrdersH2BeforePost
    AfterPost = adsOrdersH2AfterPost
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
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'DateFrom'
      end
      item
        DataType = ftUnknown
        Name = 'DateTo'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
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
      Required = True
      OnChange = adsOrdersH2SendChange
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
      DisplayFormat = '0.00;;'#39#39
    end
    object adsOrdersHFormDisplayOrderId: TLargeintField
      FieldName = 'DisplayOrderId'
    end
    object adsOrdersHFormMinReq: TLargeintField
      FieldName = 'MinReq'
    end
    object adsOrdersHFormDifferentCostCount: TLargeintField
      FieldName = 'DifferentCostCount'
    end
    object adsOrdersHFormDifferentQuantityCount: TLargeintField
      FieldName = 'DifferentQuantityCount'
    end
    object adsOrdersHFormsumbycurrentweek: TFloatField
      FieldName = 'sumbycurrentweek'
      DisplayFormat = '0.00;;'#39#39
    end
    object adsOrdersHFormFrozen: TBooleanField
      FieldName = 'Frozen'
    end
    object adsOrdersHFormAddressName: TStringField
      FieldName = 'AddressName'
    end
    object adsOrdersHFormNotExistsCount: TLargeintField
      FieldName = 'NotExistsCount'
    end
    object adsOrdersHFormRealClientId: TLargeintField
      FieldName = 'RealClientId'
    end
  end
  object adsCore: TMyQuery
    SQLUpdate.Strings = (
      'update'
      '  CurrentOrderLists'
      'set'
      '  OrderCount = :ORDERCOUNT'
      'where'
      '    OrderId = :ORDERSORDERID'
      'and CoreId  = :OLD_COREID')
    SQLRefresh.Strings = (
      'SELECT'
      '    CCore.CoreId AS CoreId,'
      '    Clients.ClientID,'
      '    CCore.productid,'
      '    CCore.PriceCode,'
      '    CCore.RegionCode,'
      '    catalogs.FullCode,'
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
      '    CCore.Cost as RealCost,'
      '  if(dop.OtherDelay is null,'
      '      CCore.Cost,'
      
        '      if(CCore.VitallyImportant || ifnull(catalogs.VitallyImport' +
        'ant, 0),'
      
        '          cast(CCore.Cost * (1 + dop.VitallyImportantDelay/100) ' +
        'as decimal(18, 2)),'
      
        '          cast(CCore.Cost * (1 + dop.OtherDelay/100) as decimal(' +
        '18, 2))'
      '       )'
      '  )'
      '      as Cost,'
      '    CCore.Quantity,'
      '    CCore.registrycost,'
      '    CCore.vitallyimportant,'
      '    CCore.requestratio,'
      '    CCore.ordercost,'
      '    CCore.minordercount,'
      '    CCore.SupplierPriceMarkup,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceCode AS LeaderPriceCode,'
      '    MinPrices.RegionCode AS LeaderRegionCode,'
      '    Regions.RegionName AS LeaderRegionName,'
      '    PricesData.PriceName AS LeaderPriceName,'
      '    MinPrices.MinCost As LeaderPRICE,'
      '    osbc.CoreId AS OrdersCoreId,'
      '    osbc.OrderId AS OrdersOrderId,'
      '    osbc.ClientId AS OrdersClientId,'
      '    catalogs.FullCode AS OrdersFullCode,'
      '    osbc.CodeFirmCr AS OrdersCodeFirmCr,'
      '    osbc.SynonymCode AS OrdersSynonymCode,'
      '    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,'
      '    osbc.Code AS OrdersCode,'
      '    osbc.CodeCr AS OrdersCodeCr,'
      '    osbc.OrderCount,'
      '    osbc.SynonymName AS OrdersSynonym,'
      '    osbc.SynonymFirm AS OrdersSynonymFirm,'
      '    osbc.Price AS OrdersPrice,'
      '    (osbc.Price*osbc.OrderCount) AS SumOrder,'
      '    osbc.Junk AS OrdersJunk,'
      '    osbc.Await AS OrdersAwait,'
      '    CurrentOrderHeads.OrderId AS OrdersHOrderId,'
      '    CurrentOrderHeads.ClientId AS OrdersHClientId,'
      '    CurrentOrderHeads.PriceCode AS OrdersHPriceCode,'
      '    CurrentOrderHeads.RegionCode AS OrdersHRegionCode,'
      '    CurrentOrderHeads.PriceName AS OrdersHPriceName,'
      '    CurrentOrderHeads.RegionName AS OrdersHRegionName'
      'FROM'
      '    Core CCore'
      
        '    inner join products       on (products.productid = CCore.pro' +
        'ductid)'
      
        '    inner join catalogs       on (catalogs.fullcode = products.c' +
        'atalogid)'
      
        '    inner JOIN MinPrices      ON (MinPrices.productid = CCore.pr' +
        'oductid) and (minprices.regioncode = CCore.regioncode)'
      '    inner join Clients        on (Clients.ClientID = :ClientID)'
      
        '    left join Core LCore      on LCore.servercoreid = minprices.' +
        'servercoreid and LCore.RegionCode = minprices.regioncode'
      
        '    left JOIN PricesData      ON (PricesData.PriceCode = MinPric' +
        'es.pricecode)'
      
        '    left JOIN Regions         ON (Regions.RegionCode = MinPrices' +
        '.RegionCode)'
      
        '    left JOIN SynonymFirmCr   ON (SynonymFirmCr.SynonymFirmCrCod' +
        'e = CCore.SynonymFirmCrCode)'
      
        '    left join synonyms        on (Synonyms.SynonymCode = CCore.S' +
        'ynonymCode)'
      
        '    left JOIN CurrentOrderLists osbc ON (osbc.ClientID = :Client' +
        'Id) and (osbc.CoreId = CCore.CoreId)'
      
        '    left JOIN PricesData cpd  ON (cpd.PriceCode = CCore.pricecod' +
        'e)'
      
        '    left join DelayOfPayments dop on (dop.PriceCode = cpd.PriceC' +
        'ode) and (dop.DayOfWeek = :DayOfWeek) '
      
        '    left JOIN CurrentOrderHeads      ON CurrentOrderHeads.OrderI' +
        'd = osbc.OrderId and CurrentOrderHeads.Frozen = 0'
      'WHERE '
      '  (CCore.CoreId = :CoreId)')
    Connection = DM.MyConnection
    SQL.Strings = (
      '#CORESHOWBYFIRM'
      'SELECT'
      '    CCore.CoreId AS CoreId,'
      '    Clients.ClientID,'
      '    CCore.productid,'
      '    CCore.PriceCode,'
      '    CCore.RegionCode,'
      '    catalogs.FullCode,'
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
      '    CCore.Cost as RealCost,'
      '  if(dop.OtherDelay is null,'
      '      CCore.Cost,'
      
        '      if(CCore.VitallyImportant || ifnull(catalogs.VitallyImport' +
        'ant, 0),'
      
        '          cast(CCore.Cost * (1 + dop.VitallyImportantDelay/100) ' +
        'as decimal(18, 2)),'
      
        '          cast(CCore.Cost * (1 + dop.OtherDelay/100) as decimal(' +
        '18, 2))'
      '       )'
      '  )'
      '      as Cost,'
      '    CCore.Quantity,'
      '    CCore.registrycost,'
      '    CCore.vitallyimportant,'
      '    CCore.requestratio,'
      '    CCore.ordercost,'
      '    CCore.minordercount,'
      '    CCore.SupplierPriceMarkup,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceCode AS LeaderPriceCode,'
      '    MinPrices.RegionCode AS LeaderRegionCode,'
      '    Regions.RegionName AS LeaderRegionName,'
      '    PricesData.PriceName AS LeaderPriceName,'
      '    MinPrices.MinCost As LeaderPRICE,'
      '    osbc.CoreId AS OrdersCoreId,'
      '    osbc.OrderId AS OrdersOrderId,'
      '    osbc.ClientId AS OrdersClientId,'
      '    catalogs.FullCode AS OrdersFullCode,'
      '    osbc.CodeFirmCr AS OrdersCodeFirmCr,'
      '    osbc.SynonymCode AS OrdersSynonymCode,'
      '    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,'
      '    osbc.Code AS OrdersCode,'
      '    osbc.CodeCr AS OrdersCodeCr,'
      '    osbc.OrderCount,'
      '    osbc.SynonymName AS OrdersSynonym,'
      '    osbc.SynonymFirm AS OrdersSynonymFirm,'
      '    osbc.Price AS OrdersPrice,'
      '    (osbc.Price*osbc.OrderCount) AS SumOrder,'
      '    osbc.Junk AS OrdersJunk,'
      '    osbc.Await AS OrdersAwait,'
      '    CurrentOrderHeads.OrderId AS OrdersHOrderId,'
      '    CurrentOrderHeads.ClientId AS OrdersHClientId,'
      '    CurrentOrderHeads.PriceCode AS OrdersHPriceCode,'
      '    CurrentOrderHeads.RegionCode AS OrdersHRegionCode,'
      '    CurrentOrderHeads.PriceName AS OrdersHPriceName,'
      '    CurrentOrderHeads.RegionName AS OrdersHRegionName'
      'FROM'
      '    Core CCore'
      
        '    inner join products       on (products.productid = CCore.pro' +
        'ductid)'
      
        '    inner join catalogs       on (catalogs.fullcode = products.c' +
        'atalogid)'
      
        '    inner JOIN MinPrices      ON (MinPrices.productid = CCore.pr' +
        'oductid) and (minprices.regioncode = CCore.regioncode)'
      '    inner join Clients        on (Clients.ClientID = :ClientID)'
      
        '    left join Core LCore      on LCore.servercoreid = minprices.' +
        'servercoreid and LCore.RegionCode = minprices.regioncode'
      
        '    left JOIN PricesData      ON (PricesData.PriceCode = MinPric' +
        'es.pricecode)'
      
        '    left JOIN Regions         ON (Regions.RegionCode = MinPrices' +
        '.RegionCode)'
      
        '    left JOIN SynonymFirmCr   ON (SynonymFirmCr.SynonymFirmCrCod' +
        'e = CCore.SynonymFirmCrCode)'
      
        '    left join synonyms        on (Synonyms.SynonymCode = CCore.S' +
        'ynonymCode)'
      
        '    left JOIN CurrentOrderLists osbc ON (osbc.ClientID = :Client' +
        'Id) and (osbc.CoreId = CCore.CoreId)'
      
        '    left JOIN PricesData cpd  ON (cpd.PriceCode = CCore.pricecod' +
        'e)'
      
        '    left join DelayOfPayments dop on (dop.PriceCode = cpd.PriceC' +
        'ode) and (dop.DayOfWeek = :DayOfWeek) '
      
        '    left JOIN CurrentOrderHeads      ON CurrentOrderHeads.OrderI' +
        'd = osbc.OrderId and CurrentOrderHeads.Frozen = 0'
      'WHERE '
      '    (CCore.PriceCode = :PriceCode) '
      'And (CCore.RegionCode = :RegionCode)')
    BeforePost = adsCoreBeforePost
    Left = 228
    Top = 119
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ClientID'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'DayOfWeek'
      end
      item
        DataType = ftUnknown
        Name = 'PriceCode'
      end
      item
        DataType = ftUnknown
        Name = 'RegionCode'
      end>
  end
  object adsCurrentOrders: TMyQuery
    SQLDelete.Strings = (
      'delete from CurrentOrderLists where OrderId = :Old_OrderId;'
      'delete from CurrentOrderHeads where OrderId = :Old_OrderId;')
    SQLUpdate.Strings = (
      'update CurrentOrderHeads'
      'set'
      '  SEND = :SEND,'
      '  CLOSED = :CLOSED,'
      '  MESSAGETO = :MESSAGETO,'
      '  COMMENTS = :COMMENTS,'
      '  Frozen = :Frozen'
      'where'
      '  orderid = :old_ORDERID')
    SQLRefresh.Strings = (
      '#ORDERSHSHOW'
      'SELECT'
      '    CurrentOrderHeads.OrderId,'
      '    CurrentOrderHeads.ClientID,'
      '    CurrentOrderHeads.ServerOrderId,'
      
        '    PricesData.DatePrice - interval :timezonebias minute AS Date' +
        'Price,'
      '    CurrentOrderHeads.PriceCode,'
      '    CurrentOrderHeads.RegionCode,'
      '    CurrentOrderHeads.OrderDate,'
      '    CurrentOrderHeads.SendDate,'
      '    CurrentOrderHeads.Closed,'
      '    CurrentOrderHeads.Send,'
      '    CurrentOrderHeads.Frozen,'
      '    CurrentOrderHeads.PriceName,'
      '    CurrentOrderHeads.RegionName,'
      '    RegionalData.SupportPhone,'
      '    CurrentOrderHeads.MessageTo,'
      '    CurrentOrderHeads.Comments,'
      
        '    GREATEST(MinReqRules.minreq, ifnull(CurrentOrderHeads.Server' +
        'MinReq, 0)) as MinReq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(CurrentOrderLists.Id) as Positions,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 1 or CurrentOrderLists.DropReason = ' +
        '3), 1, null)) as DifferentCostCount,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 2 or CurrentOrderLists.DropReason = ' +
        '3), 1, null)) as DifferentQuantityCount,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 0), 1, null)) as NotExistsCount,'
      
        '    ifnull(Sum(CurrentOrderLists.RealPrice * CurrentOrderLists.O' +
        'rderCount), 0) as SumOrder,'
      '     ('
      '  select'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0)'
      '  from'
      '    PostedOrderHeads header'
      
        '    INNER JOIN PostedOrderLists ON (PostedOrderLists.OrderId = h' +
        'eader.OrderId)'
      '  WHERE header.ClientId = :ClientId'
      '     AND header.PriceCode = CurrentOrderHeads.PriceCode'
      '     AND header.RegionCode = CurrentOrderHeads.RegionCode'
      
        '     and header.senddate > curdate() + interval (1-day(curdate()' +
        ')) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND PostedOrderLists.OrderCount>0'
      ') as sumbycurrentmonth,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1091#1102' '#1085#1077#1076#1077#1083#1102
      '('
      '  select'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0)'
      '  from'
      '    PostedOrderHeads header'
      
        '    INNER JOIN PostedOrderLists ON (PostedOrderLists.OrderId = h' +
        'eader.OrderId)'
      '  WHERE header.ClientId = :ClientId'
      '     AND header.PriceCode = CurrentOrderHeads.PriceCode'
      '     AND header.RegionCode = CurrentOrderHeads.RegionCode'
      
        '     and header.senddate > curdate() + interval (-WEEKDAY(curdat' +
        'e())) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND PostedOrderLists.OrderCount>0'
      '  ) as sumbycurrentweek,'
      '  c.ClientId as RealClientId,'
      
        '  if(c.ClientId is not null, c.Name, '#39#1040#1076#1088#1077#1089' '#1086#1090#1082#1083#1102#1095#1077#1085'/'#1091#1076#1072#1083#1077#1085' '#1080#1079' '#1089 +
        #1080#1089#1090#1077#1084#1099#39') as AddressName'
      'FROM'
      '   CurrentOrderHeads'
      '   inner join CurrentOrderLists on '
      
        '         (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId)' +
        ' '
      '     and (CurrentOrderLists.OrderCount > 0)'
      
        '   left join clients c on c.ClientId = CurrentOrderHeads.ClientI' +
        'd'
      '   LEFT JOIN PricesData ON '
      '         (CurrentOrderHeads.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      
        '         (pricesregionaldata.PriceCode = CurrentOrderHeads.Price' +
        'Code) '
      
        '     and pricesregionaldata.regioncode = CurrentOrderHeads.regio' +
        'ncode'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=CurrentOrderHeads.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      '   LEFT JOIN MinReqRules  ON '
      '         (MinReqRules.ClientId = CurrentOrderHeads.ClientId) '
      '     and (MinReqRules.PriceCode = CurrentOrderHeads.PriceCode) '
      
        '     and (MinReqRules.RegionCode = CurrentOrderHeads.RegionCode)' +
        ' '
      'WHERE'
      '    (CurrentOrderHeads.OrderId = :Old_OrderId)'
      'group by CurrentOrderHeads.OrderId'
      'having count(CurrentOrderLists.Id) > 0')
    SQL.Strings = (
      '#ORDERSHSHOW'
      'SELECT'
      '    CurrentOrderHeads.OrderId,'
      
        '    ifnull(CurrentOrderHeads.ServerOrderId, CurrentOrderHeads.Or' +
        'derId) as DisplayOrderId,'
      '    CurrentOrderHeads.ClientID,'
      '    CurrentOrderHeads.ServerOrderId,'
      
        '    PricesData.DatePrice - interval :timezonebias minute AS Date' +
        'Price,'
      '    CurrentOrderHeads.PriceCode,'
      '    CurrentOrderHeads.RegionCode,'
      '    CurrentOrderHeads.OrderDate,'
      '    CurrentOrderHeads.SendDate,'
      '    CurrentOrderHeads.Closed,'
      '    CurrentOrderHeads.Send,'
      '    CurrentOrderHeads.Frozen,'
      '    CurrentOrderHeads.PriceName,'
      '    CurrentOrderHeads.RegionName,'
      '    RegionalData.SupportPhone,'
      '    CurrentOrderHeads.MessageTo,'
      '    CurrentOrderHeads.Comments,'
      
        '    GREATEST(MinReqRules.minreq, ifnull(CurrentOrderHeads.Server' +
        'MinReq, 0)) as MinReq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(CurrentOrderLists.Id) as Positions,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 1 or CurrentOrderLists.DropReason = ' +
        '3), 1, null)) as DifferentCostCount,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 2 or CurrentOrderLists.DropReason = ' +
        '3), 1, null)) as DifferentQuantityCount,'
      
        '    count(if((CurrentOrderLists.DropReason is not null) and (Cur' +
        'rentOrderLists.DropReason = 0), 1, null)) as NotExistsCount,'
      
        '    ifnull(Sum(CurrentOrderLists.RealPrice * CurrentOrderLists.O' +
        'rderCount), 0) as SumOrder,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
      '     ('
      '  select'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0)'
      '  from'
      '    PostedOrderHeads header'
      
        '    INNER JOIN PostedOrderLists ON (PostedOrderLists.OrderId = h' +
        'eader.OrderId)'
      '  WHERE header.ClientId = :ClientId'
      '     AND header.PriceCode = CurrentOrderHeads.PriceCode'
      '     AND header.RegionCode = CurrentOrderHeads.RegionCode'
      
        '     and header.senddate > curdate() + interval (1-day(curdate()' +
        ')) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND PostedOrderLists.OrderCount>0'
      ')'
      '   as sumbycurrentmonth,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1091#1102' '#1085#1077#1076#1077#1083#1102
      '('
      '  select'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0)'
      '  from'
      '    PostedOrderHeads header'
      
        '    INNER JOIN PostedOrderLists ON (PostedOrderLists.OrderId = h' +
        'eader.OrderId)'
      '  WHERE header.ClientId = :ClientId'
      '     AND header.PriceCode = CurrentOrderHeads.PriceCode'
      '     AND header.RegionCode = CurrentOrderHeads.RegionCode'
      
        '     and header.senddate > curdate() + interval (-WEEKDAY(curdat' +
        'e())) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND PostedOrderLists.OrderCount>0'
      '  ) '
      'as sumbycurrentweek,'
      '  c.ClientId as RealClientId,'
      
        '  if(c.ClientId is not null, c.Name, '#39#1040#1076#1088#1077#1089' '#1086#1090#1082#1083#1102#1095#1077#1085'/'#1091#1076#1072#1083#1077#1085' '#1080#1079' '#1089 +
        #1080#1089#1090#1077#1084#1099#39') as AddressName'
      'FROM'
      '   CurrentOrderHeads'
      '   inner join CurrentOrderLists on '
      
        '         (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId)' +
        ' '
      '     and (CurrentOrderLists.OrderCount > 0)'
      
        '   left join clients c on c.ClientId = CurrentOrderHeads.ClientI' +
        'd'
      '   LEFT JOIN PricesData ON '
      '         (CurrentOrderHeads.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      
        '         (pricesregionaldata.PriceCode = CurrentOrderHeads.Price' +
        'Code) '
      
        '     and pricesregionaldata.regioncode = CurrentOrderHeads.regio' +
        'ncode'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=CurrentOrderHeads.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      '   LEFT JOIN MinReqRules  ON '
      '         (MinReqRules.ClientId = CurrentOrderHeads.ClientId) '
      '     and (MinReqRules.PriceCode = CurrentOrderHeads.PriceCode) '
      
        '     and (MinReqRules.RegionCode = CurrentOrderHeads.RegionCode)' +
        ' '
      'WHERE'
      '    (CurrentOrderHeads.Closed = 0)'
      ' and (((PricesData.PriceCode is not null) '
      '        and (RegionalData.RegionCode is not null) '
      '        and (pricesregionaldata.PriceCode is not null)) '
      '    or (CurrentOrderHeads.Frozen = 1))')
    Left = 132
    Top = 183
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'timezonebias'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end>
  end
  object adsSendOrders: TMyQuery
    SQLDelete.Strings = (
      'delete from PostedOrderLists where OrderId = :Old_OrderId;'
      'delete from PostedOrderHeads where OrderId = :Old_OrderId;')
    SQLUpdate.Strings = (
      'update PostedOrderHeads'
      'set'
      '  MESSAGETO = :MESSAGETO,'
      '  COMMENTS = :COMMENTS'
      'where'
      '  orderid = :old_ORDERID')
    SQLRefresh.Strings = (
      '#ORDERSHSHOW'
      'SELECT'
      '    PostedOrderHeads.OrderId,'
      
        '    ifnull(PostedOrderHeads.ServerOrderId, PostedOrderHeads.Orde' +
        'rId) as DisplayOrderId,'
      '    PostedOrderHeads.ClientID,'
      '    PostedOrderHeads.ServerOrderId,'
      
        '    PostedOrderHeads.PriceDate - interval :timezonebias minute A' +
        'S DatePrice,'
      '    PostedOrderHeads.PriceCode,'
      '    PostedOrderHeads.RegionCode,'
      '    PostedOrderHeads.OrderDate,'
      '    PostedOrderHeads.SendDate,'
      '    PostedOrderHeads.Closed,'
      '    PostedOrderHeads.Send,'
      '    PostedOrderHeads.Send as Frozen,'
      '    PostedOrderHeads.PriceName,'
      '    PostedOrderHeads.RegionName,'
      '    RegionalData.SupportPhone,'
      '    PostedOrderHeads.MessageTo,'
      '    PostedOrderHeads.Comments,'
      
        '    GREATEST(MinReqRules.minreq, ifnull(PostedOrderHeads.ServerM' +
        'inReq, 0)) as MinReq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(PostedOrderLists.Id) as Positions,'
      
        '    count(if((PostedOrderLists.DropReason is not null) and (Post' +
        'edOrderLists.DropReason = 1 or PostedOrderLists.DropReason = 3),' +
        ' 1, null)) as DifferentCostCount,'
      
        '    count(if((PostedOrderLists.DropReason is not null) and (Post' +
        'edOrderLists.DropReason = 2 or PostedOrderLists.DropReason = 3),' +
        ' 1, null)) as DifferentQuantityCount,'
      
        '    count(if((PostedOrderLists.DropReason is not null) and (Post' +
        'edOrderLists.DropReason = 0), 1, null)) as NotExistsCount,'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0) as SumOrder,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
      '  0.0'
      '   as sumbycurrentmonth,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1091#1102' '#1085#1077#1076#1077#1083#1102
      '  0.0'
      'as sumbycurrentweek,'
      '  c.ClientId as RealClientId,'
      
        '  if(c.ClientId is not null, c.Name, '#39#1040#1076#1088#1077#1089' '#1086#1090#1082#1083#1102#1095#1077#1085'/'#1091#1076#1072#1083#1077#1085' '#1080#1079' '#1089 +
        #1080#1089#1090#1077#1084#1099#39') as AddressName'
      'FROM'
      '   PostedOrderHeads'
      '   inner join PostedOrderLists on '
      '         (PostedOrderLists.OrderId = PostedOrderHeads.OrderId) '
      '     and (PostedOrderLists.OrderCount > 0)'
      '   left join clients c on c.ClientId = PostedOrderHeads.ClientId'
      '   LEFT JOIN PricesData ON '
      '         (PostedOrderHeads.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      
        '         (pricesregionaldata.PriceCode = PostedOrderHeads.PriceC' +
        'ode) '
      
        '     and pricesregionaldata.regioncode = PostedOrderHeads.region' +
        'code'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=PostedOrderHeads.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      '   LEFT JOIN MinReqRules  ON '
      '         (MinReqRules.ClientId = PostedOrderHeads.ClientId) '
      '     and (MinReqRules.PriceCode = PostedOrderHeads.PriceCode) '
      '     and (MinReqRules.RegionCode = PostedOrderHeads.RegionCode)'
      'WHERE'
      '    (PostedOrderHeads.OrderId = :Old_OrderId)'
      'group by PostedOrderHeads.OrderId'
      'having count(PostedOrderLists.Id) > 0'
      'order by PostedOrderHeads.SendDate DESC')
    SQL.Strings = (
      '#ORDERSHSHOW'
      'SELECT'
      '    PostedOrderHeads.OrderId,'
      
        '    ifnull(PostedOrderHeads.ServerOrderId, PostedOrderHeads.Orde' +
        'rId) as DisplayOrderId,'
      '    PostedOrderHeads.ClientID,'
      '    PostedOrderHeads.ServerOrderId,'
      
        '    PostedOrderHeads.PriceDate - interval :timezonebias minute A' +
        'S DatePrice,'
      '    PostedOrderHeads.PriceCode,'
      '    PostedOrderHeads.RegionCode,'
      '    PostedOrderHeads.OrderDate,'
      '    PostedOrderHeads.SendDate,'
      '    PostedOrderHeads.Closed,'
      '    PostedOrderHeads.Send,'
      '    PostedOrderHeads.Send as Frozen,'
      '    PostedOrderHeads.PriceName,'
      '    PostedOrderHeads.RegionName,'
      '    RegionalData.SupportPhone,'
      '    PostedOrderHeads.MessageTo,'
      '    PostedOrderHeads.Comments,'
      
        '    GREATEST(MinReqRules.minreq, ifnull(PostedOrderHeads.ServerM' +
        'inReq, 0)) as MinReq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(PostedOrderLists.Id) as Positions,'
      
        '    count(if((PostedOrderLists.DropReason is not null) and (Post' +
        'edOrderLists.DropReason = 1 or PostedOrderLists.DropReason = 3),' +
        ' 1, null)) as DifferentCostCount,'
      
        '    count(if((PostedOrderLists.DropReason is not null) and (Post' +
        'edOrderLists.DropReason = 2 or PostedOrderLists.DropReason = 3),' +
        ' 1, null)) as DifferentQuantityCount,'
      
        '    count(if((PostedOrderLists.DropReason is not null) and (Post' +
        'edOrderLists.DropReason = 0), 1, null)) as NotExistsCount,'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0) as SumOrder,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
      '  0.0'
      '   as sumbycurrentmonth,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1091#1102' '#1085#1077#1076#1077#1083#1102
      '  0.0'
      'as sumbycurrentweek,'
      '  c.ClientId as RealClientId,'
      
        '  if(c.ClientId is not null, c.Name, '#39#1040#1076#1088#1077#1089' '#1086#1090#1082#1083#1102#1095#1077#1085'/'#1091#1076#1072#1083#1077#1085' '#1080#1079' '#1089 +
        #1080#1089#1090#1077#1084#1099#39') as AddressName'
      'FROM'
      '   PostedOrderHeads'
      '   inner join PostedOrderLists on '
      '         (PostedOrderLists.OrderId = PostedOrderHeads.OrderId) '
      '     and (PostedOrderLists.OrderCount > 0)'
      '   left join clients c on c.ClientId = PostedOrderHeads.ClientId'
      '   LEFT JOIN PricesData ON '
      '         (PostedOrderHeads.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      
        '         (pricesregionaldata.PriceCode = PostedOrderHeads.PriceC' +
        'ode) '
      
        '     and pricesregionaldata.regioncode = PostedOrderHeads.region' +
        'code'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=PostedOrderHeads.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      '   LEFT JOIN MinReqRules  ON '
      '         (MinReqRules.ClientId = PostedOrderHeads.ClientId) '
      '     and (MinReqRules.PriceCode = PostedOrderHeads.PriceCode) '
      '     and (MinReqRules.RegionCode = PostedOrderHeads.RegionCode)'
      'WHERE')
    Left = 180
    Top = 183
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'timezonebias'
      end>
  end
  object pmDestinationClients: TPopupMenu
    Left = 164
    Top = 459
  end
  object tmrFillReport: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmrFillReportTimer
    Left = 424
    Top = 104
  end
  object pmDestinationPrices: TPopupMenu
    Left = 212
    Top = 459
  end
  object strhPostedBegin: TStrHolder
    Capacity = 8
    Macros = <>
    Left = 228
    Top = 191
    InternalVer = 1
    StrData = (
      ''
      
        '64726f702074656d706f72617279207461626c65206966206578697374732050' +
        '6f737465644f72646572486561647354656d703b'
      
        '6372656174652074656d706f72617279207461626c6520506f737465644f7264' +
        '6572486561647354656d70206173'
      '73656c656374'
      '4f726465724964'
      '46524f4d'
      '202020506f737465644f72646572486561647320'
      '7768657265')
  end
  object strhPostedEnd: TStrHolder
    Capacity = 60
    Macros = <>
    Left = 228
    Top = 223
    InternalVer = 1
    StrData = (
      ''
      '53454c454354'
      '20202020506f737465644f7264657248656164732e4f7264657249642c'
      
        '2020202069666e756c6c28506f737465644f7264657248656164732e53657276' +
        '65724f7264657249642c20506f737465644f7264657248656164732e4f726465' +
        '7249642920617320446973706c61794f7264657249642c'
      '20202020506f737465644f7264657248656164732e436c69656e7449442c'
      
        '20202020506f737465644f7264657248656164732e5365727665724f72646572' +
        '49642c'
      
        '20202020506f737465644f7264657248656164732e507269636544617465202d' +
        '20696e74657276616c203a74696d657a6f6e6562696173206d696e7574652041' +
        '53204461746550726963652c'
      '20202020506f737465644f7264657248656164732e5072696365436f64652c'
      '20202020506f737465644f7264657248656164732e526567696f6e436f64652c'
      '20202020506f737465644f7264657248656164732e4f72646572446174652c'
      '20202020506f737465644f7264657248656164732e53656e64446174652c'
      '20202020506f737465644f7264657248656164732e436c6f7365642c'
      '20202020506f737465644f7264657248656164732e53656e642c'
      
        '20202020506f737465644f7264657248656164732e53656e642061732046726f' +
        '7a656e2c'
      '20202020506f737465644f7264657248656164732e50726963654e616d652c'
      '20202020506f737465644f7264657248656164732e526567696f6e4e616d652c'
      '20202020526567696f6e616c446174612e537570706f727450686f6e652c'
      '20202020506f737465644f7264657248656164732e4d657373616765546f2c'
      '20202020506f737465644f7264657248656164732e436f6d6d656e74732c'
      
        '202020204752454154455354284d696e52657152756c65732e6d696e7265712c' +
        '2069666e756c6c28506f737465644f7264657248656164732e5365727665724d' +
        '696e5265712c20302929206173204d696e5265712c'
      
        '20202020707269636573726567696f6e616c646174612e456e61626c65642061' +
        '73205072696365456e61626c65642c'
      
        '20202020636f756e7428506f737465644f726465724c697374732e4964292061' +
        '7320506f736974696f6e732c'
      
        '20202020636f756e742869662828506f737465644f726465724c697374732e44' +
        '726f70526561736f6e206973206e6f74206e756c6c2920616e642028506f7374' +
        '65644f726465724c697374732e44726f70526561736f6e203d2031206f722050' +
        '6f737465644f726465724c697374732e44726f70526561736f6e203d2033292c' +
        '20312c206e756c6c292920617320446966666572656e74436f7374436f756e74' +
        '2c'
      
        '20202020636f756e742869662828506f737465644f726465724c697374732e44' +
        '726f70526561736f6e206973206e6f74206e756c6c2920616e642028506f7374' +
        '65644f726465724c697374732e44726f70526561736f6e203d2032206f722050' +
        '6f737465644f726465724c697374732e44726f70526561736f6e203d2033292c' +
        '20312c206e756c6c292920617320446966666572656e745175616e7469747943' +
        '6f756e742c'
      
        '20202020636f756e742869662828506f737465644f726465724c697374732e44' +
        '726f70526561736f6e206973206e6f74206e756c6c2920616e642028506f7374' +
        '65644f726465724c697374732e44726f70526561736f6e203d2030292c20312c' +
        '206e756c6c2929206173204e6f74457869737473436f756e742c'
      
        '2020202069666e756c6c2853756d28506f737465644f726465724c697374732e' +
        '5265616c5072696365202a20506f737465644f726465724c697374732e4f7264' +
        '6572436f756e74292c2030292061732053756d4f726465722c'
      
        '20202320d1f3ecece020e7e0eae0e7eee220e7e020f2e5eaf3f9e8e920ece5f1' +
        'fff6'
      '2020302e30'
      '20202061732073756d627963757272656e746d6f6e74682c'
      
        '20202320d1f3ecece020e7e0eae0e7eee220e7e020f2e5eaf3f9f3fe20ede5e4' +
        'e5ebfe'
      '2020302e30'
      '61732073756d627963757272656e747765656b2c'
      '2020632e436c69656e744964206173205265616c436c69656e7449642c'
      
        '2020696628632e436c69656e744964206973206e6f74206e756c6c2c20632e4e' +
        '616d652c2027c0e4f0e5f120eef2eaebfef7e5ed2ff3e4e0ebe5ed20e8e720f1' +
        'e8f1f2e5ecfb272920617320416464726573734e616d65'
      '46524f4d'
      '202020506f737465644f72646572486561647354656d70'
      
        '202020696e6e6572206a6f696e20506f737465644f726465724865616473206f' +
        '6e20506f737465644f7264657248656164732e4f726465724964203d20506f73' +
        '7465644f72646572486561647354656d702e4f726465724964'
      
        '202020696e6e6572206a6f696e20506f737465644f726465724c69737473206f' +
        '6e'
      
        '20202020202020202028506f737465644f726465724c697374732e4f72646572' +
        '4964203d20506f737465644f7264657248656164732e4f72646572496429'
      
        '2020202020616e642028506f737465644f726465724c697374732e4f72646572' +
        '436f756e74203e203029'
      
        '2020206c656674206a6f696e20636c69656e74732063206f6e20632e436c6965' +
        '6e744964203d20506f737465644f7264657248656164732e436c69656e744964'
      '2020204c454654204a4f494e2050726963657344617461204f4e'
      
        '20202020202020202028506f737465644f7264657248656164732e5072696365' +
        '436f64653d507269636573446174612e5072696365436f646529'
      
        '2020206c656674206a6f696e20707269636573726567696f6e616c6461746120' +
        '6f6e'
      
        '20202020202020202028707269636573726567696f6e616c646174612e507269' +
        '6365436f6465203d20506f737465644f7264657248656164732e507269636543' +
        '6f646529'
      
        '2020202020616e6420707269636573726567696f6e616c646174612e72656769' +
        '6f6e636f6465203d20506f737465644f7264657248656164732e726567696f6e' +
        '636f6465'
      '2020204c454654204a4f494e20526567696f6e616c44617461204f4e'
      
        '20202020202020202028526567696f6e616c446174612e526567696f6e436f64' +
        '653d506f737465644f7264657248656164732e526567696f6e436f646529'
      
        '2020202020414e442028507269636573446174612e4669726d436f64653d5265' +
        '67696f6e616c446174612e4669726d436f646529'
      '2020204c454654204a4f494e204d696e52657152756c657320204f4e'
      
        '202020202020202020284d696e52657152756c65732e436c69656e744964203d' +
        '20506f737465644f7264657248656164732e436c69656e74496429'
      
        '2020202020616e6420284d696e52657152756c65732e5072696365436f646520' +
        '3d20506f737465644f7264657248656164732e5072696365436f646529'
      
        '2020202020616e6420284d696e52657152756c65732e526567696f6e436f6465' +
        '203d20506f737465644f7264657248656164732e526567696f6e436f646529'
      
        '67726f757020627920506f737465644f7264657248656164732e4f7264657249' +
        '64'
      
        '686176696e6720636f756e7428506f737465644f726465724c697374732e4964' +
        '29203e2030'
      
        '6f7264657220627920506f737465644f7264657248656164732e53656e644461' +
        '74652044455343')
  end
end
