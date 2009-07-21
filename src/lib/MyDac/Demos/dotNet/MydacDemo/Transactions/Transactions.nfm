inherited TransactionsFrame: TTransactionsFrame
  Width = 443
  Height = 277
  Align = alClient
  object DBGrid: TDBGrid
    Left = 0
    Top = 76
    Width = 443
    Height = 201
    Align = alClient
    DataSource = DataSource
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 503
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object RefreshRecord: TSpeedButton
        Left = 405
        Top = 1
        Width = 97
        Height = 22
        Caption = 'RefreshRecord'
        Flat = True
        Transparent = False
        OnClick = RefreshRecordClick
      end
      object btClose: TSpeedButton
        Left = 83
        Top = 1
        Width = 80
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 81
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object DBNavigator: TDBNavigator
        Left = 164
        Top = 1
        Width = 240
        Height = 22
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 24
      Width = 280
      Height = 51
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 1
      object Panel3: TPanel
        Left = 1
        Top = 1
        Width = 278
        Height = 49
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 10
          Top = 3
          Width = 68
          Height = 13
          Caption = 'Transaction'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Panel4: TPanel
          Left = 11
          Top = 20
          Width = 250
          Height = 24
          BevelOuter = bvNone
          Color = 16591631
          TabOrder = 0
          object btRollbackTrans: TSpeedButton
            Left = 167
            Top = 1
            Width = 82
            Height = 22
            Caption = 'Rollback'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            OnClick = btRollbackTransClick
          end
          object btCommitTrans: TSpeedButton
            Left = 84
            Top = 1
            Width = 82
            Height = 22
            Caption = 'Commit'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            OnClick = btCommitTransClick
          end
          object btStartTrans: TSpeedButton
            Left = 1
            Top = 1
            Width = 82
            Height = 22
            Caption = 'Start'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = False
            OnClick = btStartTransClick
          end
        end
      end
    end
  end
  object DataSource: TDataSource
    DataSet = MyQuery
    OnStateChange = DataSourceStateChange
    OnDataChange = DataSourceDataChange
    Left = 185
    Top = 56
  end
  object MyQuery: TMyQuery
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'SELECT * FROM EMP_TRANACTION_SAFE')
    FetchAll = True
    Left = 152
    Top = 56
  end
end
