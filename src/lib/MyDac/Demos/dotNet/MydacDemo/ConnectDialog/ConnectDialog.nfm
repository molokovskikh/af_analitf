inherited ConnectDialogFrame: TConnectDialogFrame
  Width = 451
  Height = 304
  VertScrollBar.Range = 54
  Align = alClient
  object DBGrid: TDBGrid
    Left = 0
    Top = 54
    Width = 451
    Height = 250
    Align = alClient
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Color = clBlack
    TitleFont.Height = 11
    TitleFont.Name = 'helvetica'
    TitleFont.Pitch = fpVariable
    TitleFont.Style = []
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 54
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 398
      Height = 52
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
      object DBNavigator: TDBNavigator
        Left = 167
        Top = 1
        Width = 230
        Height = 22
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
      object Panel3: TPanel
        Left = 1
        Top = 24
        Width = 396
        Height = 27
        BevelOuter = bvNone
        TabOrder = 1
        object rbInherited: TRadioButton
          Left = 221
          Top = 5
          Width = 113
          Height = 17
          Caption = 'Inherited dialog'
          TabOrder = 0
          TabStop = False
          OnClick = rbInheritedClick
        end
        object rbMy: TRadioButton
          Left = 111
          Top = 5
          Width = 96
          Height = 17
          Caption = 'Custom dialog'
          TabOrder = 1
          TabStop = False
          OnClick = rbMyClick
        end
        object rbDefault: TRadioButton
          Left = 8
          Top = 5
          Width = 88
          Height = 17
          Caption = 'Default dialog'
          Checked = True
          TabOrder = 2
          OnClick = rbDefaultClick
        end
      end
    end
  end
  object DataSource: TDataSource
    DataSet = MyQuery
    Left = 114
    Top = 72
  end
  object MyQuery: TMyQuery
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'SELECT * FROM EMP')
    Left = 82
    Top = 72
  end
end
