inherited CRDBGridFrame: TCRDBGridFrame
  Width = 443
  Height = 277
  Align = alClient
  object CRDBGrid: TCRDBGrid
    Left = 0
    Top = 50
    Width = 443
    Height = 227
    OptionsEx = [dgeLocalFilter, dgeLocalSorting]
    Align = alClient
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = 'PERSON|NAME'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'COUNTRY'
        Title.Caption = 'PERSON|ADDRESS|COUNTRY'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CITY'
        Title.Caption = 'PERSON|ADDRESS|CITY'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STREET'
        Title.Caption = 'PERSON|ADDRESS|STREET'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BIRTHDATE'
        Title.Caption = 'PERSON|BIRTHDATE'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'JOB'
        Title.Caption = 'JOB|JOB NAME'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'HIREDATE'
        Title.Caption = 'JOB|HIREDATE'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SAL'
        Title.Caption = 'JOB|SAL'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'REMARKS'
        Width = 63
        Visible = True
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 424
      Height = 48
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 75
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object btClose: TSpeedButton
        Left = 77
        Top = 1
        Width = 75
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object Panel3: TPanel
        Left = 1
        Top = 24
        Width = 422
        Height = 23
        BevelOuter = bvNone
        TabOrder = 0
        object chkFiltered: TCheckBox
          Left = 5
          Top = 4
          Width = 65
          Height = 17
          Caption = 'Filtered'
          TabOrder = 0
          OnClick = chkFilteredClick
        end
        object chkFilterBar: TCheckBox
          Left = 85
          Top = 4
          Width = 65
          Height = 17
          Action = actFilterBar
          TabOrder = 1
        end
        object chkSearchBar: TCheckBox
          Left = 165
          Top = 4
          Width = 81
          Height = 17
          Action = actSearchBar
          TabOrder = 2
        end
        object chkRecCount: TCheckBox
          Left = 253
          Top = 4
          Width = 89
          Height = 17
          Caption = 'Record Count'
          TabOrder = 3
          OnClick = chkRecCountClick
        end
        object chkStretch: TCheckBox
          Left = 357
          Top = 4
          Width = 57
          Height = 17
          Caption = 'Stretch'
          TabOrder = 4
          OnClick = chkStretchClick
        end
      end
      object DBNavigator1: TDBNavigator
        Left = 153
        Top = 1
        Width = 270
        Height = 22
        DataSource = DataSource
        Flat = True
        TabOrder = 1
      end
    end
  end
  object MyQuery: TMyQuery
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'SELECT * FROM CRGRID_TEST')
    FetchAll = True
    Left = 160
    Top = 168
  end
  object DataSource: TDataSource
    DataSet = MyQuery
    Left = 192
    Top = 168
  end
  object ActionList1: TActionList
    Left = 224
    Top = 168
    object actSearchBar: TAction
      Caption = 'Search Bar'
      OnExecute = actSearchBarExecute
      OnUpdate = actSearchBarUpdate
    end
    object actFilterBar: TAction
      Caption = 'Filter Bar'
      OnExecute = actFilterBarExecute
      OnUpdate = actFilterBarUpdate
    end
  end
end
