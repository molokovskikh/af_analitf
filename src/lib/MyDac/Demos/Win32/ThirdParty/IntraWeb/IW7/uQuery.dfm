inherited fmQuery: TfmQuery
  Width = 677
  Height = 416
  OnCreate = IWAppFormCreate
  DesignSize = (
    677
    416)
  DesignLeft = 8
  DesignTop = 8
  inherited IWRectangle: TIWRectangle
    Width = 656
  end
  inherited lbPageName: TIWLabel
    Left = 619
    Width = 44
    Caption = 'Query'
  end
  inherited lnkQuery: TIWLink
    TabOrder = 4
  end
  inherited lnkCachedUpdates: TIWLink
    TabOrder = 5
  end
  inherited lnkMasterDetail: TIWLink
    TabOrder = 7
  end
  object IWRegion1: TIWRegion [7]
    Left = 16
    Top = 184
    Width = 654
    Height = 65
    Cursor = crAuto
    TabOrder = 0
    Anchors = [akLeft, akTop, akRight]
    BorderOptions.NumericWidth = 1
    BorderOptions.BorderWidth = cbwNumeric
    BorderOptions.Style = cbsSolid
    BorderOptions.Color = clNone
    Color = clWebBLACK
    ParentShowHint = False
    ShowHint = True
    ZIndex = 1000
    DesignSize = (
      654
      65)
    object IWRectangle1: TIWRectangle
      Left = 1
      Top = 1
      Width = 652
      Height = 63
      Cursor = crAuto
      Anchors = [akLeft, akTop, akRight, akBottom]
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = -1
      RenderSize = True
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      BorderOptions.Color = clNone
      BorderOptions.Width = 0
      FriendlyName = 'IWRectangle1'
      Color = 14811135
      Alignment = taLeftJustify
      VAlign = vaMiddle
    end
    object IWLabel1: TIWLabel
      Left = 7
      Top = 7
      Width = 38
      Height = 18
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Alignment = taLeftJustify
      BGColor = clNone
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 12
      Font.Style = [fsBold]
      NoWrap = False
      FriendlyName = 'IWLabel1'
      Caption = 'SQL'
      RawText = False
    end
    object IWRegion3: TIWRegion
      Left = 56
      Top = 8
      Width = 589
      Height = 49
      Cursor = crAuto
      TabOrder = 0
      Anchors = [akLeft, akTop, akRight]
      BorderOptions.NumericWidth = 1
      BorderOptions.BorderWidth = cbwNumeric
      BorderOptions.Style = cbsSolid
      BorderOptions.Color = clNone
      Color = clNone
      ParentShowHint = False
      ShowHint = True
      ZIndex = 1000
      object meSQL: TIWMemo
        Left = 1
        Top = 1
        Width = 587
        Height = 47
        Cursor = crAuto
        Align = alClient
        IW50Hint = False
        ParentShowHint = False
        ShowHint = True
        ZIndex = 0
        RenderSize = True
        BGColor = clNone
        Editable = True
        Font.Color = clNone
        Font.Size = 10
        Font.Style = []
        ScriptEvents = <>
        InvisibleBorder = False
        HorizScrollBar = False
        VertScrollBar = True
        Required = False
        TabOrder = 14
        FriendlyName = 'meSQL'
      end
    end
  end
  object IWRegion2: TIWRegion [8]
    Left = 16
    Top = 256
    Width = 654
    Height = 141
    Cursor = crAuto
    TabOrder = 1
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderOptions.NumericWidth = 1
    BorderOptions.BorderWidth = cbwNumeric
    BorderOptions.Style = cbsSolid
    BorderOptions.Color = clNone
    Color = clWebBLACK
    ParentShowHint = False
    ShowHint = True
    ZIndex = 1000
    DesignSize = (
      654
      141)
    object IWRectangle2: TIWRectangle
      Left = 1
      Top = 1
      Width = 652
      Height = 139
      Cursor = crAuto
      Anchors = [akLeft, akTop, akRight, akBottom]
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = -1
      RenderSize = True
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      BorderOptions.Color = clNone
      BorderOptions.Width = 0
      FriendlyName = 'IWRectangle2'
      Color = 14811135
      Alignment = taLeftJustify
      VAlign = vaMiddle
    end
    object IWDBNavigator: TIWDBNavigator
      Left = 6
      Top = 29
      Width = 135
      Height = 30
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Confirmations.Delete = 'Are you sure you want to delete this record?'
      Confirmations.Post = 'Are you sure you want to update this record?'
      Confirmations.Cancel = 'Are you sure you want to cancel your changes to this record?'
      DataSource = DataSource
      FriendlyName = 'IWDBNavigator'
      ImageHeight = 21
      ImageWidth = 21
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh]
      Orientation = orHorizontal
      OnFirst = IWDBNavigatorRefresh
      OnPrior = IWDBNavigatorRefresh
      OnNext = IWDBNavigatorRefresh
      OnLast = IWDBNavigatorRefresh
      OnRefresh = IWDBNavigatorRefresh
    end
    object IWLabel2: TIWLabel
      Left = 7
      Top = 7
      Width = 46
      Height = 18
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Alignment = taLeftJustify
      BGColor = clNone
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 12
      Font.Style = [fsBold]
      NoWrap = False
      FriendlyName = 'IWLabel2'
      Caption = 'Data'
      RawText = False
    end
    object IWDBGrid: TIWDBGrid
      Left = 144
      Top = 28
      Width = 502
      Height = 105
      Cursor = crAuto
      Anchors = [akLeft, akTop, akRight, akBottom]
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      BorderColors.Color = clNone
      BorderColors.Light = clNone
      BorderColors.Dark = clNone
      BGColor = clSkyBlue
      BorderSize = 1
      BorderStyle = tfDefault
      CellPadding = 0
      CellSpacing = 0
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = []
      FrameBuffer = 40
      Lines = tlAll
      UseFrame = True
      UseSize = True
      ScrollToCurrentRow = False
      Columns = <>
      DataSource = DataSource
      FooterRowCount = 0
      FriendlyName = 'IWDBGrid'
      FromStart = True
      HighlightColor = clNone
      HighlightRows = False
      Options = [dgShowTitles]
      RefreshMode = rmAutomatic
      RowLimit = 0
      RollOver = False
      RowClick = False
      RollOverColor = clNone
      RowHeaderColor = 12876667
      RowAlternateColor = clNone
      RowCurrentColor = clMoneyGreen
      TabOrder = 21
    end
    object lbResult: TIWLabel
      Left = 144
      Top = 7
      Width = 63
      Height = 16
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Alignment = taLeftJustify
      BGColor = clNone
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      NoWrap = False
      FriendlyName = 'lbResult'
      Caption = 'lbResult'
      RawText = False
    end
  end
  object IWRegion4: TIWRegion [9]
    Left = 16
    Top = 128
    Width = 653
    Height = 46
    Cursor = crAuto
    TabOrder = 2
    Anchors = [akLeft, akTop, akRight]
    BorderOptions.NumericWidth = 1
    BorderOptions.BorderWidth = cbwNumeric
    BorderOptions.Style = cbsSolid
    BorderOptions.Color = clNone
    Color = clWebBLACK
    ParentShowHint = False
    ShowHint = True
    ZIndex = 1000
    DesignSize = (
      653
      46)
    object IWRectangle3: TIWRectangle
      Left = 1
      Top = 1
      Width = 651
      Height = 44
      Cursor = crAuto
      Anchors = [akLeft, akTop, akRight, akBottom]
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = -1
      RenderSize = True
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      BorderOptions.Color = clNone
      BorderOptions.Width = 0
      FriendlyName = 'IWRectangle3'
      Color = 14811135
      Alignment = taLeftJustify
      VAlign = vaMiddle
    end
    object btOpen: TIWButton
      Left = 11
      Top = 11
      Width = 94
      Height = 25
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      Caption = 'Open'
      DoSubmitValidation = True
      Color = clBtnFace
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      FriendlyName = 'btOpen'
      ScriptEvents = <>
      TabOrder = 6
      OnClick = btOpenClick
    end
    object btClose: TIWButton
      Left = 112
      Top = 11
      Width = 97
      Height = 25
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      Caption = 'Close'
      DoSubmitValidation = True
      Color = clBtnFace
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      FriendlyName = 'btClose'
      ScriptEvents = <>
      TabOrder = 9
      OnClick = btCloseClick
    end
  end
  inherited rgConnection: TIWRegion
    Width = 653
    TabOrder = 3
    DesignSize = (
      653
      42)
    inherited IWRectangle4: TIWRectangle
      Width = 651
    end
    inherited btConnect: TIWButton
      TabOrder = 11
    end
    inherited btDisconnect: TIWButton
      TabOrder = 16
    end
  end
  object Query: TMyQuery
    FetchAll = True
    Left = 328
    Top = 48
  end
  object DataSource: TDataSource
    DataSet = Query
    Left = 424
    Top = 48
  end
end
