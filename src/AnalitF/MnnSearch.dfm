inherited MnnSearchForm: TMnnSearchForm
  ActiveControl = dbgMnn
  Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1052#1053#1053
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 684
    Height = 449
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object dbgMnn: TToughDBGrid
      Tag = 16
      Left = 0
      Top = 41
      Width = 684
      Height = 408
      Align = alClient
      AutoFitColWidths = True
      DataSource = dsMNN
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgMnnDblClick
      OnDrawColumnCell = dbgMnnDrawColumnCell
      OnKeyDown = dbgMnnKeyDown
      OnKeyPress = dbgMnnKeyPress
      SearchPosition = spBottom
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Mnn'
          Footers = <>
          Title.Caption = #1052#1053#1053
          Width = 136
        end>
    end
    object pnlSearch: TPanel
      Left = 0
      Top = 0
      Width = 684
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object eSearch: TEdit
        Left = 1
        Top = 10
        Width = 320
        Height = 21
        TabOrder = 0
        OnKeyDown = eSearchKeyDown
        OnKeyPress = eSearchKeyPress
      end
    end
  end
  inherited tCheckVolume: TTimer
    Left = 64
    Top = 80
  end
  object dsMNN: TDataSource
    DataSet = adsMNN
    Left = 176
    Top = 208
  end
  object adsMNN: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      '  Mnn.Id,'
      '  Mnn.Mnn'
      'from'
      '  Mnn'
      'where'
      '  Mnn.Mnn like :LikeParam'
      'order by Mnn')
    Left = 200
    Top = 168
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'LikeParam'
      end>
    object adsMNNId: TLargeintField
      FieldName = 'Id'
    end
    object adsMNNMnn: TStringField
      FieldName = 'Mnn'
      Size = 250
    end
  end
  object tmrSearch: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmrSearchTimer
    Left = 488
    Top = 165
  end
  object tmrFlipToMNN: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrFlipToMNNTimer
    Left = 264
    Top = 184
  end
end
