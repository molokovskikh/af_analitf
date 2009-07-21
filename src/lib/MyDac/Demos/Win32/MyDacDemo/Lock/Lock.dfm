inherited LockFrame: TLockFrame
  Width = 443
  Height = 277
  Align = alClient
  object Splitter1: TSplitter
    Left = 0
    Top = 338
    Width = 427
    Height = 2
    Cursor = crVSplit
    Align = alTop
    Color = 16591631
    ParentColor = False
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 427
    Height = 179
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel5: TPanel
      Left = 2
      Top = 1
      Width = 687
      Height = 156
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 685
        Height = 81
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Lines.Strings = (
          
            'To see how this demo works you should open two instances of it. ' +
            'In the first instance of demo start editing any record, '
          'then try to edit the same record in the second instance.'
          
            'Immediately lock mode equals to SELECT ... FOR UPDATE command.De' +
            'layed lock mode equals to SELECT ... '
          
            'LOCK IN SHARE MODE command. You can read more about these comman' +
            'ds in MySQL Reference Manual.     ')
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        WantTabs = True
      end
      object meSQL: TMemo
        Left = 1
        Top = 83
        Width = 685
        Height = 72
        ScrollBars = ssVertical
        TabOrder = 1
        OnChange = btCloseClick
        OnExit = meSQLExit
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 156
      Width = 167
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 1
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
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 181
    Width = 427
    Height = 157
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel6'
    TabOrder = 1
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 427
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label2: TLabel
        Left = 8
        Top = 5
        Width = 136
        Height = 16
        Caption = 'The first connection'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Panel2: TPanel
        Left = 200
        Top = 1
        Width = 500
        Height = 24
        BevelOuter = bvNone
        Color = 16591631
        TabOrder = 0
        object Panel4: TPanel
          Left = 252
          Top = 1
          Width = 247
          Height = 22
          BevelOuter = bvNone
          TabOrder = 0
          object Label1: TLabel
            Left = 8
            Top = 4
            Width = 47
            Height = 13
            Caption = 'Lock type'
          end
          object rbLockDelayed: TRadioButton
            Left = 172
            Top = 4
            Width = 67
            Height = 17
            Caption = 'Delayed'
            TabOrder = 0
          end
          object rbLockImmediately: TRadioButton
            Left = 67
            Top = 4
            Width = 85
            Height = 17
            Caption = 'Immediately'
            Checked = True
            TabOrder = 1
            TabStop = True
          end
        end
        object Panel12: TPanel
          Left = 1
          Top = 1
          Width = 250
          Height = 22
          BevelOuter = bvNone
          Caption = 'Panel12'
          TabOrder = 1
          object DBNavigator1: TDBNavigator
            Left = 0
            Top = 0
            Width = 250
            Height = 22
            DataSource = DataSource1
            Flat = True
            TabOrder = 0
          end
        end
      end
    end
    object DBGrid: TDBGrid
      Left = 0
      Top = 26
      Width = 427
      Height = 131
      Align = alClient
      DataSource = DataSource1
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 340
    Width = 427
    Height = 0
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel6'
    TabOrder = 2
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 427
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label3: TLabel
        Left = 8
        Top = 5
        Width = 162
        Height = 16
        Caption = 'The second connection'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Panel9: TPanel
        Left = 200
        Top = 1
        Width = 500
        Height = 24
        BevelOuter = bvNone
        Color = 16591631
        TabOrder = 0
        object Panel10: TPanel
          Left = 252
          Top = 1
          Width = 247
          Height = 22
          BevelOuter = bvNone
          TabOrder = 1
          object Label4: TLabel
            Left = 8
            Top = 4
            Width = 47
            Height = 13
            Caption = 'Lock type'
          end
          object RadioButton1: TRadioButton
            Left = 172
            Top = 4
            Width = 67
            Height = 17
            Caption = 'Delayed'
            TabOrder = 0
          end
          object RadioButton2: TRadioButton
            Left = 67
            Top = 4
            Width = 85
            Height = 17
            Caption = 'Immediately'
            Checked = True
            TabOrder = 1
            TabStop = True
          end
        end
        object Panel14: TPanel
          Left = 1
          Top = 1
          Width = 250
          Height = 22
          BevelOuter = bvNone
          TabOrder = 0
          object DBNavigator2: TDBNavigator
            Left = 0
            Top = 0
            Width = 250
            Height = 22
            DataSource = DataSource2
            Flat = True
            TabOrder = 0
          end
        end
      end
    end
    object DBGrid1: TDBGrid
      Left = 0
      Top = 26
      Width = 427
      Height = 149
      Align = alClient
      DataSource = DataSource2
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel11: TPanel
    Left = 0
    Top = 179
    Width = 427
    Height = 2
    Align = alTop
    BevelOuter = bvNone
    Color = 16591631
    TabOrder = 3
  end
  object MyQuery1: TMyQuery
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'SELECT * FROM EMP_TRANACTION_SAFE')
    AfterExecute = MyQuery1AfterExecute
    BeforeEdit = MyQuery1BeforeEdit
    AfterPost = MyQuery1AfterPost
    AfterCancel = MyQuery1AfterCancel
    CommandTimeout = 30
    Left = 173
    Top = 101
  end
  object DataSource1: TDataSource
    DataSet = MyQuery1
    Left = 205
    Top = 101
  end
  object MyQuery2: TMyQuery
    Connection = MyConnection2
    SQL.Strings = (
      'SELECT * FROM EMP_TRANACTION_SAFE')
    AfterExecute = MyQuery1AfterExecute
    BeforeEdit = MyQuery1BeforeEdit
    AfterPost = MyQuery1AfterPost
    AfterCancel = MyQuery1AfterCancel
    CommandTimeout = 30
    Left = 83
    Top = 416
  end
  object MyConnection2: TMyConnection
    Left = 55
    Top = 415
  end
  object DataSource2: TDataSource
    DataSet = MyQuery2
    Left = 115
    Top = 416
  end
end
