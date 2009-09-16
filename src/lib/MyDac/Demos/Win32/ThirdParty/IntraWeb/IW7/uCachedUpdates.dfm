inherited fmCachedUpdates: TfmCachedUpdates
  Width = 662
  Height = 570
  OnCreate = IWAppFormCreate
  DesignLeft = 8
  DesignTop = 8
  inherited IWRectangle: TIWRectangle
    Width = 625
  end
  inherited lbPageName: TIWLabel
    Left = 522
    Width = 113
    Caption = 'CachedUpdates'
  end
  inherited lnkMain: TIWLink
    TabOrder = 1
  end
  inherited lnkQuery: TIWLink
    TabOrder = 4
  end
  inherited lnkCachedUpdates: TIWLink
    TabOrder = 6
  end
  inherited lnkMasterDetail: TIWLink
    TabOrder = 8
  end
  object IWDBNavigator1: TIWDBNavigator [7]
    Left = 16
    Top = 312
    Width = 270
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
    FriendlyName = 'IWDBNavigator1'
    ImageHeight = 21
    ImageWidth = 21
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh]
    Orientation = orHorizontal
  end
  object IWDBGrid1: TIWDBGrid [8]
    Left = 16
    Top = 344
    Width = 621
    Height = 135
    Cursor = crAuto
    Anchors = [akLeft, akTop, akRight]
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
    FriendlyName = 'IWDBGrid1'
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
    TabOrder = 33
  end
  inherited rgConnection: TIWRegion
    Width = 620
    inherited IWRectangle4: TIWRectangle
      Width = 618
    end
    inherited btConnect: TIWButton
      TabOrder = 0
    end
    inherited btDisconnect: TIWButton
      TabOrder = 11
    end
  end
  object IWRegion4: TIWRegion
    Left = 16
    Top = 128
    Width = 620
    Height = 177
    Cursor = crAuto
    TabOrder = 1
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
      620
      177)
    object IWRectangle3: TIWRectangle
      Left = 1
      Top = 1
      Width = 618
      Height = 175
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
    object cbCachedUpdates: TIWCheckBox
      Left = 8
      Top = 8
      Width = 137
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Caption = 'CachedUpdates'
      Editable = True
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      ScriptEvents = <>
      DoSubmitValidation = True
      Style = stNormal
      TabOrder = 7
      Checked = False
      FriendlyName = 'cbCachedUpdates'
    end
    object IWLabel1: TIWLabel
      Left = 8
      Top = 111
      Width = 30
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
      FriendlyName = 'IWLabel1'
      Caption = 'SQL'
      RawText = False
    end
    object btOpen: TIWButton
      Left = 8
      Top = 30
      Width = 97
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
      TabOrder = 17
      OnClick = btOpenClick
    end
    object btClose: TIWButton
      Left = 112
      Top = 31
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
      TabOrder = 18
      OnClick = btCloseClick
    end
    object cbUnmodified: TIWCheckBox
      Left = 265
      Top = 9
      Width = 98
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Caption = 'Unmodified'
      Editable = True
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = []
      ScriptEvents = <>
      DoSubmitValidation = True
      Style = stNormal
      TabOrder = 9
      OnClick = cbModifiedClick
      Checked = False
      FriendlyName = 'cbUnmodified'
    end
    object cbModified: TIWCheckBox
      Left = 361
      Top = 9
      Width = 82
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Caption = 'Modified'
      Editable = True
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = []
      ScriptEvents = <>
      DoSubmitValidation = True
      Style = stNormal
      TabOrder = 12
      OnClick = cbModifiedClick
      Checked = False
      FriendlyName = 'cbModified'
    end
    object cbInserted: TIWCheckBox
      Left = 441
      Top = 9
      Width = 82
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Caption = 'Inserted'
      Editable = True
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = []
      ScriptEvents = <>
      DoSubmitValidation = True
      Style = stNormal
      TabOrder = 13
      OnClick = cbModifiedClick
      Checked = False
      FriendlyName = 'cbInserted'
    end
    object cbDeleted: TIWCheckBox
      Left = 521
      Top = 9
      Width = 74
      Height = 21
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Caption = 'Deleted'
      Editable = True
      Font.Color = clNone
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = []
      ScriptEvents = <>
      DoSubmitValidation = True
      Style = stNormal
      TabOrder = 14
      OnClick = cbModifiedClick
      Checked = False
      FriendlyName = 'cbDeleted'
    end
    object IWLabel2: TIWLabel
      Left = 162
      Top = 10
      Width = 107
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
      FriendlyName = 'IWLabel2'
      Caption = 'RecordTypes:'
      RawText = False
    end
    object lbResult: TIWLabel
      Left = 226
      Top = 34
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
    object lbUpdates: TIWLabel
      Left = 177
      Top = 60
      Width = 80
      Height = 16
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Alignment = taLeftJustify
      BGColor = clNone
      Font.Color = 6956042
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      NoWrap = False
      FriendlyName = 'lbUpdates'
      Caption = 'lbUpdates'
      RawText = False
    end
    object btApply: TIWButton
      Left = 8
      Top = 80
      Width = 75
      Height = 25
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      Caption = 'Apply'
      DoSubmitValidation = True
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'btApply'
      ScriptEvents = <>
      TabOrder = 20
      OnClick = btApplyClick
    end
    object btCommit: TIWButton
      Left = 88
      Top = 80
      Width = 75
      Height = 25
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      Caption = 'Commit'
      DoSubmitValidation = True
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'btCommit'
      ScriptEvents = <>
      TabOrder = 21
      OnClick = btCommitClick
    end
    object btCancel: TIWButton
      Left = 168
      Top = 80
      Width = 75
      Height = 25
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      Caption = 'Cancel'
      DoSubmitValidation = True
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'btCancel'
      ScriptEvents = <>
      TabOrder = 22
      OnClick = btCancelClick
    end
    object btRevert: TIWButton
      Left = 248
      Top = 80
      Width = 75
      Height = 25
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      Caption = 'Revert'
      DoSubmitValidation = True
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'btRevert'
      ScriptEvents = <>
      TabOrder = 24
      OnClick = btRevertClick
    end
    object btTransStart: TIWButton
      Left = 352
      Top = 80
      Width = 75
      Height = 25
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      Caption = 'Start'
      DoSubmitValidation = True
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'btTransStart'
      ScriptEvents = <>
      TabOrder = 25
      OnClick = btTransStartClick
    end
    object btTransCommit: TIWButton
      Left = 432
      Top = 80
      Width = 75
      Height = 25
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      Caption = 'Commit'
      DoSubmitValidation = True
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'btTransCommit'
      ScriptEvents = <>
      TabOrder = 26
      OnClick = btTransCommitClick
    end
    object btTransRollback: TIWButton
      Left = 512
      Top = 80
      Width = 75
      Height = 25
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = True
      Caption = 'Rollback'
      DoSubmitValidation = True
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'btTransRollback'
      ScriptEvents = <>
      TabOrder = 27
      OnClick = btTransRollbackClick
    end
    object IWLabel4: TIWLabel
      Left = 16
      Top = 60
      Width = 66
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
      FriendlyName = 'IWLabel4'
      Caption = 'Updates'
      RawText = False
    end
    object IWLabel6: TIWLabel
      Left = 368
      Top = 60
      Width = 93
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
      FriendlyName = 'IWLabel6'
      Caption = 'Transaction'
      RawText = False
    end
    object lbTransaction: TIWLabel
      Left = 472
      Top = 60
      Width = 107
      Height = 16
      Cursor = crAuto
      IW50Hint = False
      ParentShowHint = False
      ShowHint = True
      ZIndex = 0
      RenderSize = False
      Alignment = taLeftJustify
      BGColor = clNone
      Font.Color = 6956042
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      NoWrap = False
      FriendlyName = 'lbTransaction'
      Caption = 'lbTransaction'
      RawText = False
    end
    object IWRegion1: TIWRegion
      Left = 48
      Top = 112
      Width = 562
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
        Width = 560
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
        TabOrder = 28
        FriendlyName = 'meSQL'
      end
    end
  end
  object rgEdits: TIWRegion
    Left = 16
    Top = 485
    Width = 621
    Height = 62
    Cursor = crAuto
    Visible = False
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
      621
      62)
    object rcEdits: TIWRectangle
      Left = 1
      Top = 1
      Width = 619
      Height = 60
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
      FriendlyName = 'rcEdits'
      Color = 14811135
      Alignment = taLeftJustify
      VAlign = vaMiddle
    end
  end
  object Query: TMyQuery
    FetchAll = True
    Left = 432
    Top = 264
  end
  object DataSource: TDataSource
    DataSet = Query
    Left = 456
    Top = 264
  end
end