inherited TableFrame: TTableFrame
  Width = 443
  Height = 277
  Align = alClient
  object DBGrid: TDBGrid
    Left = 0
    Top = 78
    Width = 443
    Height = 199
    Align = alClient
    DataSource = DataSource
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 78
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 647
      Height = 75
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object btClose: TSpeedButton
        Left = 84
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object btExecute: TSpeedButton
        Left = 333
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Execute'
        Flat = True
        Transparent = False
        OnClick = btExecuteClick
      end
      object btUnPrepare: TSpeedButton
        Left = 250
        Top = 1
        Width = 82
        Height = 22
        Caption = 'UnPrepare'
        Flat = True
        Transparent = False
        OnClick = btUnPrepareClick
      end
      object btPrepare: TSpeedButton
        Left = 167
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Prepare'
        Flat = True
        Transparent = False
        OnClick = btPrepareClick
      end
      object Panel3: TPanel
        Left = 1
        Top = 24
        Width = 248
        Height = 50
        BevelOuter = bvNone
        TabOrder = 2
        object Label1: TLabel
          Left = 6
          Top = 4
          Width = 56
          Height = 13
          Caption = 'Table name'
        end
        object edTableName: TComboBox
          Left = 6
          Top = 20
          Width = 224
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          OnDropDown = edTableNameDropDown
          OnExit = edTableNameExit
        end
      end
      object Panel4: TPanel
        Left = 416
        Top = 24
        Width = 230
        Height = 50
        BevelOuter = bvNone
        TabOrder = 1
        object Label3: TLabel
          Left = 6
          Top = 4
          Width = 53
          Height = 13
          Caption = 'OrderFields'
        end
        object edOrderFields: TComboBox
          Left = 6
          Top = 20
          Width = 212
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          OnDropDown = edOrderFieldsDropDown
          OnExit = edOrderFieldsExit
        end
      end
      object Panel9: TPanel
        Left = 416
        Top = 1
        Width = 230
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object DBNavigator: TDBNavigator
          Left = 0
          Top = 0
          Width = 230
          Height = 22
          DataSource = DataSource
          Flat = True
          TabOrder = 0
        end
      end
      object Panel8: TPanel
        Left = 250
        Top = 24
        Width = 165
        Height = 50
        BevelOuter = bvNone
        TabOrder = 3
        object Label4: TLabel
          Left = 6
          Top = 4
          Width = 43
          Height = 13
          Caption = 'FilterSQL'
        end
        object edFilterSQL: TEdit
          Left = 6
          Top = 20
          Width = 140
          Height = 21
          TabOrder = 0
        end
      end
    end
  end
  object DataSource: TDataSource
    DataSet = MyTable
    Left = 424
    Top = 87
  end
  object MyTable: TMyTable
    TableName = 'EMP'
    OrderFields = 'ENAME'
    Connection = MyDACForm.MyConnection
    FetchAll = True
    Left = 392
    Top = 87
  end
end
