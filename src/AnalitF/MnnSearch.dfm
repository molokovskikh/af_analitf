inherited MnnSearchForm: TMnnSearchForm
  Left = 471
  Top = 333
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
      OnGetCellParams = dbgMnnGetCellParams
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
      object cbShowAll: TCheckBox
        Left = 334
        Top = 10
        Width = 210
        Height = 17
        Action = actShowAll
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
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
      '  Mnn.Mnn,'
      '  sum(CATALOGS.CoreExists) as CoreExists'
      'from'
      '  Mnn'
      '  left join CATALOGS on CATALOGS.MnnId = Mnn.Id '
      'where'
      '     Mnn.Mnn like :LikeParam'
      'group by Mnn.Id'
      'having  (CoreExists >= :ShowAll)'
      'order by Mnn.Mnn')
    Left = 200
    Top = 168
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'LikeParam'
      end
      item
        DataType = ftUnknown
        Name = 'ShowAll'
      end>
    object adsMNNId: TLargeintField
      FieldName = 'Id'
    end
    object adsMNNMnn: TStringField
      FieldName = 'Mnn'
      Size = 250
    end
    object adsMNNCoreExists: TFloatField
      FieldName = 'CoreExists'
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
  object ActionList: TActionList
    Left = 336
    Top = 144
    object actShowAll: TAction
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1074#1077#1089#1100' '#1082#1072#1090#1072#1083#1086#1075
      Hint = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1074#1077#1089#1100' '#1082#1072#1090#1072#1083#1086#1075
      OnExecute = actShowAllExecute
    end
  end
end
