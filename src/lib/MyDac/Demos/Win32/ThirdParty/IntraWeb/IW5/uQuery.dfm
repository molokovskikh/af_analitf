inherited fmQuery: TfmQuery
  Width = 677
  Height = 416
  OnCreate = IWAppFormCreate
  DesignSize = (
    677
    416)
  DesignLeft = 265
  DesignTop = 95
  inherited IWRectangle: TIWRectangle
    Width = 656
  end
  inherited lbPageName: TIWLabel
    Left = 619
    Width = 44
    Caption = 'Query'
  end
  inherited rgConnection: TIWRegion
    Width = 653
    DesignSize = (
      653
      42)
    inherited IWRectangle4: TIWRectangle
      Width = 651
    end
  end
  object IWRegion1: TIWRegion
    Left = 16
    Top = 184
    Width = 654
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Color = clBlack
    DesignSize = (
      654
      65)
    object IWRectangle1: TIWRectangle
      Left = 1
      Top = 1
      Width = 652
      Height = 63
      Anchors = [akLeft, akTop, akRight, akBottom]
      ShowHint = True
      ParentShowHint = False
      ZIndex = -1
      Font.Color = clNone
      Font.Enabled = True
      Font.Size = 10
      Font.Style = []
      Color = 14811135
      Alignment = taLeftJustify
      VAlign = vaMiddle
    end
    object IWLabel1: TIWLabel
      Left = 7
      Top = 7
      Width = 38
      Height = 18
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 12
      Font.Style = [fsBold]
      Caption = 'SQL'
      RawText = False
    end
    object IWRegion3: TIWRegion
      Left = 56
      Top = 8
      Width = 589
      Height = 49
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Color = clNone
      object meSQL: TIWMemo
        Left = 0
        Top = 0
        Width = 589
        Height = 49
        Align = alClient
        ShowHint = True
        ParentShowHint = False
        ZIndex = 0
        Editable = True
        Font.Color = clNone
        Font.Enabled = True
        Font.Size = 10
        Font.Style = []
        ScriptEvents = <>
        RawText = False
        ReadOnly = False
        Required = False
        TabOrder = 4
        WantReturns = False
        FriendlyName = 'meSQL'
      end
    end
  end
  object IWRegion2: TIWRegion
    Left = 16
    Top = 256
    Width = 654
    Height = 141
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    Color = clBlack
    DesignSize = (
      654
      141)
    object IWRectangle2: TIWRectangle
      Left = 1
      Top = 1
      Width = 652
      Height = 139
      Anchors = [akLeft, akTop, akRight, akBottom]
      ShowHint = True
      ParentShowHint = False
      ZIndex = -1
      Font.Color = clNone
      Font.Enabled = True
      Font.Size = 10
      Font.Style = []
      Color = 14811135
      Alignment = taLeftJustify
      VAlign = vaMiddle
    end
    object IWDBNavigator: TIWDBNavigator
      Left = 6
      Top = 29
      Width = 115
      Height = 30
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Confirmations.Delete = 'Are you sure you want to delete this record?'
      Confirmations.Post = 'Are you sure you want to update this record?'
      Confirmations.Cancel = 'Are you sure you want to cancel your changes to this record?'
      DataSource = DataSource
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
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 12
      Font.Style = [fsBold]
      Caption = 'Data'
      RawText = False
    end
    object IWDBGrid: TIWDBGrid
      Left = 144
      Top = 28
      Width = 502
      Height = 105
      Anchors = [akLeft, akTop, akRight, akBottom]
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      BorderColors.Color = clNone
      BorderColors.Light = clNone
      BorderColors.Dark = clNone
      BGColor = clSkyBlue
      BorderSize = 1
      BorderStyle = tfDefault
      CellPadding = 0
      CellSpacing = 0
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = []
      FrameBuffer = 40
      Lines = tlAll
      UseFrame = True
      UseWidth = True
      Columns = <>
      DataSource = DataSource
      FooterRowCount = 0
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
    end
    object lbResult: TIWLabel
      Left = 144
      Top = 7
      Width = 63
      Height = 16
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      Caption = 'lbResult'
      RawText = False
    end
  end
  object IWRegion4: TIWRegion
    Left = 16
    Top = 128
    Width = 653
    Height = 46
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Color = clBlack
    DesignSize = (
      653
      46)
    object IWRectangle3: TIWRectangle
      Left = 1
      Top = 1
      Width = 651
      Height = 44
      Anchors = [akLeft, akTop, akRight, akBottom]
      ShowHint = True
      ParentShowHint = False
      ZIndex = -1
      Font.Color = clNone
      Font.Enabled = True
      Font.Size = 10
      Font.Style = []
      Color = 14811135
      Alignment = taLeftJustify
      VAlign = vaMiddle
    end
    object btOpen: TIWButton
      Left = 11
      Top = 11
      Width = 94
      Height = 25
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      ButtonType = btButton
      Caption = 'Open'
      Color = clBtnFace
      DoSubmitValidation = True
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      ScriptEvents = <>
      TabOrder = 2
      OnClick = btOpenClick
    end
    object btClose: TIWButton
      Left = 112
      Top = 11
      Width = 97
      Height = 25
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      ButtonType = btButton
      Caption = 'Close'
      Color = clBtnFace
      DoSubmitValidation = True
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      ScriptEvents = <>
      TabOrder = 3
      OnClick = btCloseClick
    end
  end
  object Query: TMyQuery
    FetchAll = True
    Left = 272
    Top = 48
  end
  object DataSource: TDataSource
    DataSet = Query
    Left = 304
    Top = 48
  end
end
