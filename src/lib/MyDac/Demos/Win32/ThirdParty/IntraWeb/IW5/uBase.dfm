object fmBase: TfmBase
  Left = 0
  Top = 0
  Width = 620
  Height = 430
  Background.Fixed = False
  HandleTabs = False
  Title = 'MySQL Data Access Demo - IntraWeb'
  SupportedBrowsers = [brIE, brNetscape6]
  ShowHint = True
  OnRender = IWAppFormRender
  DesignSize = (
    620
    430)
  DesignLeft = 189
  DesignTop = 24
  object IWRectangle: TIWRectangle
    Left = 12
    Top = 16
    Width = 599
    Height = 28
    Anchors = [akLeft, akTop, akRight]
    ShowHint = True
    ParentShowHint = False
    ZIndex = 0
    Font.Color = clHighlight
    Font.Enabled = True
    Font.FontName = 'Verdana'
    Font.Size = 12
    Font.Style = [fsBold]
    Color = clSkyBlue
    Alignment = taLeftJustify
    VAlign = vaMiddle
  end
  object lbDemoCaption: TIWLabel
    Left = 20
    Top = 21
    Width = 359
    Height = 18
    ShowHint = True
    ParentShowHint = False
    ZIndex = 0
    Font.Color = 6956042
    Font.Enabled = True
    Font.FontName = 'Verdana'
    Font.Size = 12
    Font.Style = [fsBold]
    AutoSize = False
    Caption = 'MySQL Data Access Demo - IntraWeb'
    RawText = False
  end
  object lbPageName: TIWLabel
    Left = 515
    Top = 22
    Width = 88
    Height = 16
    Anchors = [akTop, akRight]
    ShowHint = True
    ParentShowHint = False
    ZIndex = 0
    Font.Color = 6956042
    Font.Enabled = True
    Font.FontName = 'Verdana'
    Font.Size = 10
    Font.Style = [fsItalic]
    Caption = 'lbPageName'
    RawText = False
  end
  object lnkMain: TIWLink
    Left = 16
    Top = 56
    Width = 41
    Height = 25
    ShowHint = True
    ParentShowHint = False
    ZIndex = 0
    Color = clNone
    Caption = 'Main'
    Font.Color = clNone
    Font.Enabled = True
    Font.FontName = 'Verdana'
    Font.Size = 10
    Font.Style = [fsBold]
    ScriptEvents = <>
    DoSubmitValidation = False
    OnClick = lnkMainClick
  end
  object lnkQuery: TIWLink
    Left = 69
    Top = 56
    Width = 65
    Height = 17
    ShowHint = True
    ParentShowHint = False
    ZIndex = 0
    Color = clNone
    Caption = 'Query'
    Font.Color = clNone
    Font.Enabled = True
    Font.FontName = 'Verdana'
    Font.Size = 10
    Font.Style = [fsBold]
    ScriptEvents = <>
    DoSubmitValidation = False
    OnClick = lnkQueryClick
  end
  object lnkCachedUpdates: TIWLink
    Left = 138
    Top = 56
    Width = 121
    Height = 17
    ShowHint = True
    ParentShowHint = False
    ZIndex = 0
    Color = clNone
    Caption = 'CachedUpdates'
    Font.Color = clNone
    Font.Enabled = True
    Font.FontName = 'Verdana'
    Font.Size = 10
    Font.Style = [fsBold]
    ScriptEvents = <>
    DoSubmitValidation = False
    OnClick = lnkCachedUpdatesClick
  end
  object lnkMasterDetail: TIWLink
    Left = 264
    Top = 56
    Width = 105
    Height = 17
    ShowHint = True
    ParentShowHint = False
    ZIndex = 0
    Color = clNone
    Caption = 'MasterDetail'
    Font.Color = clNone
    Font.Enabled = True
    Font.FontName = 'Verdana'
    Font.Size = 10
    Font.Style = [fsBold]
    ScriptEvents = <>
    DoSubmitValidation = False
    OnClick = lnkMasterDetailClick
  end
  object rgConnection: TIWRegion
    Left = 16
    Top = 78
    Width = 594
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Color = clBlack
    DesignSize = (
      594
      42)
    object IWRectangle4: TIWRectangle
      Left = 1
      Top = 1
      Width = 592
      Height = 40
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
    object btConnect: TIWButton
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      ButtonType = btButton
      Caption = 'Connect'
      Color = clBtnFace
      DoSubmitValidation = True
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      ScriptEvents = <>
      TabOrder = 0
      OnClick = btConnectClick
    end
    object btDisconnect: TIWButton
      Left = 112
      Top = 8
      Width = 97
      Height = 25
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      ButtonType = btButton
      Caption = 'Disconnect'
      Color = clBtnFace
      DoSubmitValidation = True
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      ScriptEvents = <>
      TabOrder = 1
      OnClick = btDisconnectClick
    end
    object lbStateConnection: TIWLabel
      Left = 216
      Top = 11
      Width = 147
      Height = 16
      ShowHint = True
      ParentShowHint = False
      ZIndex = 0
      Font.Color = clNone
      Font.Enabled = True
      Font.FontName = 'Verdana'
      Font.Size = 10
      Font.Style = [fsBold]
      Caption = 'lbStateConnection'
      RawText = False
    end
  end
end
