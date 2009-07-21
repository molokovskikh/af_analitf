object fmMain: TfmMain
  Left = 268
  Top = 161
  Width = 641
  Height = 371
  Caption = 'MySQL Data Access demo - InfoPower support'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object wwDBGrid1: TwwDBGrid
    Left = 0
    Top = 25
    Width = 633
    Height = 319
    Selected.Strings = (
      'DEPTNO'#9'10'#9'DEPTNO'
      'DNAME'#9'14'#9'DNAME'
      'LOC'#9'13'#9'LOC')
    IniAttributes.Delimiter = ';;'
    TitleColor = clBtnFace
    FixedCols = 0
    ShowHorzScrollBar = True
    Align = alClient
    DataSource = wwDataSource1
    TabOrder = 0
    TitleAlignment = taLeftJustify
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleLines = 1
    TitleButtons = False
    IndicatorColor = icBlack
    FooterCellColor = clInfoBk
    object wwDBGrid1IButton: TwwIButton
      Left = 0
      Top = 0
      Width = 13
      Height = 22
      AllowAllUp = True
      Caption = '!'
    end
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btOpen: TButton
      Left = 0
      Top = 1
      Width = 75
      Height = 25
      Caption = 'Open'
      TabOrder = 0
      OnClick = btOpenClick
    end
    object btClose: TButton
      Left = 76
      Top = 1
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 1
      OnClick = btCloseClick
    end
    object wwDBNavigator1: TwwDBNavigator
      Left = 152
      Top = 0
      Width = 350
      Height = 25
      DataSource = wwDataSource1
      RepeatInterval.InitialDelay = 500
      RepeatInterval.Interval = 100
      object wwDBNavigator1First: TwwNavButton
        Left = 0
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Move to first record'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1First'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 0
        Style = nbsFirst
      end
      object wwDBNavigator1PriorPage: TwwNavButton
        Left = 25
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Move backward 10 records'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1PriorPage'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 1
        Style = nbsPriorPage
      end
      object wwDBNavigator1Prior: TwwNavButton
        Left = 50
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Move to prior record'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1Prior'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 2
        Style = nbsPrior
      end
      object wwDBNavigator1Next: TwwNavButton
        Left = 75
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Move to next record'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1Next'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 3
        Style = nbsNext
      end
      object wwDBNavigator1NextPage: TwwNavButton
        Left = 100
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Move forward 10 records'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1NextPage'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 4
        Style = nbsNextPage
      end
      object wwDBNavigator1Last: TwwNavButton
        Left = 125
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Move to last record'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1Last'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 5
        Style = nbsLast
      end
      object wwDBNavigator1Insert: TwwNavButton
        Left = 150
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Insert new record'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1Insert'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 6
        Style = nbsInsert
      end
      object wwDBNavigator1Delete: TwwNavButton
        Left = 175
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Delete current record'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1Delete'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 7
        Style = nbsDelete
      end
      object wwDBNavigator1Edit: TwwNavButton
        Left = 200
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Edit current record'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1Edit'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 8
        Style = nbsEdit
      end
      object wwDBNavigator1Post: TwwNavButton
        Left = 225
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Post changes of current record'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1Post'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 9
        Style = nbsPost
      end
      object wwDBNavigator1Cancel: TwwNavButton
        Left = 250
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Cancel changes made to current record'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1Cancel'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 10
        Style = nbsCancel
      end
      object wwDBNavigator1Refresh: TwwNavButton
        Left = 275
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Refresh the contents of the dataset'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1Refresh'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 11
        Style = nbsRefresh
      end
      object wwDBNavigator1SaveBookmark: TwwNavButton
        Left = 300
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Bookmark current record'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1SaveBookmark'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 12
        Style = nbsSaveBookmark
      end
      object wwDBNavigator1RestoreBookmark: TwwNavButton
        Left = 325
        Top = 0
        Width = 25
        Height = 25
        Hint = 'Go back to saved bookmark'
        ImageIndex = -1
        NumGlyphs = 2
        Spacing = 4
        Transparent = False
        Caption = 'wwDBNavigator1RestoreBookmark'
        Enabled = False
        DisabledTextColors.ShadeColor = clGray
        DisabledTextColors.HighlightColor = clBtnHighlight
        Index = 13
        Style = nbsRestoreBookmark
      end
    end
  end
  object MyConnection1: TMyConnection
    Database = 'test'
    Username = 'root'
    Left = 280
    Top = 32
  end
  object wwDataSource1: TwwDataSource
    DataSet = wwMyQuery
    Left = 344
    Top = 32
  end
  object wwMyQuery: TwwMyQuery
    Connection = MyConnection1
    SQL.Strings = (
      'SELECT * FROM DEPT')
    ValidateWithMask = True
    Left = 312
    Top = 32
    object wwMyQueryDEPTNO: TIntegerField
      FieldName = 'DEPTNO'
    end
    object wwMyQueryDNAME: TStringField
      FieldName = 'DNAME'
      Size = 14
    end
    object wwMyQueryLOC: TStringField
      FieldName = 'LOC'
      Size = 13
    end
  end
end
