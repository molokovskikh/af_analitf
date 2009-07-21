inherited fmMasterDetail: TfmMasterDetail
  Width = 605
  Height = 567
  OnCreate = IWAppFormCreate
  DesignLeft = 261
  DesignTop = 79
  inherited IWRectangle: TIWRectangle
    Width = 582
  end
  inherited lbPageName: TIWLabel
    Left = 495
    Width = 97
    Caption = 'Master/Detail'
  end
  inherited rgConnection: TIWRegion
    Width = 577
    inherited IWRectangle4: TIWRectangle
      Width = 575
    end
  end
  object IWRegion1: TIWRegion
    Left = 16
    Top = 127
    Width = 577
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Color = clBlack
    DesignSize = (
      577
      65)
    object IWRectangle1: TIWRectangle
      Left = 1
      Top = 1
      Width = 575
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
    object btOpen: TIWButton
      Left = 8
      Top = 32
      Width = 97
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
      TabOrder = 4
      OnClick = btOpenClick
    end
    object cbLocalMasterDetail: TIWCheckBox
      Left = 7
      Top = 10
      Width = 153
      Height = 21
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Caption = 'LocalMasterDetail'
      Editable = True
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      ScriptEvents = <>
      DoSubmitValidation = True
      Style = stNormal
      TabOrder = 2
      Checked = False
    end
    object btClose: TIWButton
      Left = 114
      Top = 32
      Width = 95
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
      TabOrder = 5
      OnClick = btCloseClick
    end
    object cbCachedCalcFields: TIWCheckBox
      Left = 167
      Top = 10
      Width = 151
      Height = 21
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Caption = 'CachedCalcFields'
      Editable = True
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      ScriptEvents = <>
      DoSubmitValidation = True
      Style = stNormal
      TabOrder = 3
      Checked = False
    end
    object lbResult: TIWLabel
      Left = 333
      Top = 12
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
  object IWRegion3: TIWRegion
    Left = 16
    Top = 382
    Width = 577
    Height = 174
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    Color = clBlack
    DesignSize = (
      577
      174)
    object IWRectangle3: TIWRectangle
      Left = 1
      Top = 1
      Width = 575
      Height = 172
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
    object IWLabel4: TIWLabel
      Left = 8
      Top = 7
      Width = 55
      Height = 18
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 12
      Font.Style = [fsBold]
      Caption = 'Detail'
      RawText = False
    end
    object IWLabel3: TIWLabel
      Left = 8
      Top = 33
      Width = 93
      Height = 16
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      Caption = 'DetailFields'
      RawText = False
    end
    object edDetailFields: TIWEdit
      Left = 8
      Top = 52
      Width = 121
      Height = 21
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      BGColor = clNone
      DoSubmitValidation = True
      Editable = True
      Font.Color = clNone
      Font.Enabled = True
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'edDetailFields'
      MaxLength = 0
      ReadOnly = False
      Required = False
      ScriptEvents = <>
      TabOrder = 8
      PasswordPrompt = False
      Text = 'edDetailFields'
    end
    object IWDBGrid2: TIWDBGrid
      Left = 144
      Top = 81
      Width = 422
      Height = 85
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
      DataSource = dsDetail
      FooterRowCount = 0
      FromStart = True
      HighlightColor = clNone
      HighlightRows = True
      Options = [dgIndicator, dgShowTitles]
      RefreshMode = rmAutomatic
      RowLimit = 0
      RollOver = False
      RowClick = False
      RollOverColor = clNone
      RowHeaderColor = 12876667
      RowAlternateColor = clNone
      RowCurrentColor = clMoneyGreen
    end
    object IWRegion5: TIWRegion
      Left = 144
      Top = 8
      Width = 422
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Color = clNone
      object meDetail: TIWMemo
        Left = 0
        Top = 0
        Width = 422
        Height = 65
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
        TabOrder = 9
        WantReturns = False
        FriendlyName = 'meDetail'
      end
    end
  end
  object IWRegion2: TIWRegion
    Left = 16
    Top = 199
    Width = 577
    Height = 178
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Color = clBlack
    DesignSize = (
      577
      178)
    object IWRectangle2: TIWRectangle
      Left = 1
      Top = 1
      Width = 575
      Height = 176
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
    object IWDBNavigator1: TIWDBNavigator
      Left = 8
      Top = 104
      Width = 115
      Height = 30
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Confirmations.Delete = 'Are you sure you want to delete this record?'
      Confirmations.Post = 'Are you sure you want to update this record?'
      Confirmations.Cancel = 'Are you sure you want to cancel your changes to this record?'
      DataSource = dsMaster
      ImageHeight = 21
      ImageWidth = 21
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh]
      Orientation = orHorizontal
      OnFirst = IWDBNavigator1Refresh
      OnPrior = IWDBNavigator1Refresh
      OnNext = IWDBNavigator1Refresh
      OnLast = IWDBNavigator1Refresh
      OnRefresh = IWDBNavigator1Refresh
    end
    object IWLabel1: TIWLabel
      Left = 8
      Top = 6
      Width = 67
      Height = 18
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 12
      Font.Style = [fsBold]
      Caption = 'Master'
      RawText = False
    end
    object IWLabel2: TIWLabel
      Left = 8
      Top = 33
      Width = 102
      Height = 16
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      Caption = 'MasterFields'
      RawText = False
    end
    object edMasterFields: TIWEdit
      Left = 8
      Top = 52
      Width = 121
      Height = 21
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      BGColor = clNone
      DoSubmitValidation = True
      Editable = True
      Font.Color = clNone
      Font.Enabled = True
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'edMasterFields'
      MaxLength = 0
      ReadOnly = False
      Required = False
      ScriptEvents = <>
      TabOrder = 6
      PasswordPrompt = False
      Text = 'edMasterFields'
    end
    object IWDBGrid1: TIWDBGrid
      Left = 144
      Top = 80
      Width = 422
      Height = 89
      Anchors = [akLeft, akTop, akRight]
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
      DataSource = dsMaster
      FooterRowCount = 0
      FromStart = True
      HighlightColor = clNone
      HighlightRows = True
      Options = [dgIndicator, dgShowTitles]
      RefreshMode = rmAutomatic
      RowLimit = 0
      RollOver = False
      RowClick = False
      RollOverColor = clNone
      RowHeaderColor = 12876667
      RowAlternateColor = clNone
      RowCurrentColor = clMoneyGreen
    end
    object IWRegion4: TIWRegion
      Left = 144
      Top = 8
      Width = 422
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Color = clNone
      object meMaster: TIWMemo
        Left = 0
        Top = 0
        Width = 422
        Height = 65
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
        TabOrder = 7
        WantReturns = False
        FriendlyName = 'meMaster'
      end
    end
  end
  object quMaster: TMyQuery
    FetchAll = True
    Left = 192
    Top = 239
  end
  object quDetail: TMyQuery
    MasterSource = dsMaster
    FetchAll = True
    Left = 128
    Top = 407
  end
  object dsMaster: TDataSource
    DataSet = quMaster
    Left = 224
    Top = 239
  end
  object dsDetail: TDataSource
    DataSet = quDetail
    Left = 160
    Top = 407
  end
end
