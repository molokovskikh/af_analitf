inherited QueryFrame: TQueryFrame
  Width = 443
  Height = 277
  Align = alClient
  object DBGrid: TDBGrid
    Left = 0
    Top = 124
    Width = 443
    Height = 153
    Align = alClient
    DataSource = DataSource
    TabOrder = 3
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
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 573
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
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
      object btSaveToXML: TSpeedButton
        Left = 416
        Top = 1
        Width = 82
        Height = 22
        Caption = 'SaveToXML'
        Flat = True
        Transparent = False
        OnClick = btSaveToXMLClick
      end
      object Panel4: TPanel
        Left = 499
        Top = 1
        Width = 73
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object cbFetchAll: TCheckBox
          Left = 7
          Top = 4
          Width = 68
          Height = 16
          Caption = 'FetchAll'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          OnClick = cbFetchAllClick
        end
      end
    end
  end
  object meSQL: TMemo
    Left = 0
    Top = 26
    Width = 443
    Height = 72
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 1
    OnExit = meSQLExit
  end
  object Panel1: TPanel
    Left = 0
    Top = 98
    Width = 443
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 335
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object btRefreshRecord: TSpeedButton
        Left = 252
        Top = 1
        Width = 82
        Height = 22
        Caption = 'RefreshRecord'
        Flat = True
        Transparent = False
        OnClick = btRefreshRecordClick
      end
      object Panel5: TPanel
        Left = 1
        Top = 1
        Width = 250
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object DBNavigator1: TDBNavigator
          Left = 0
          Top = 0
          Width = 250
          Height = 22
          DataSource = DataSource
          Flat = True
          TabOrder = 0
        end
      end
    end
  end
  object MyQuery: TMyQuery
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'SELECT A.*, B.*'
      'FROM EMP A, DEPT B'
      'WHERE (A.DEPTNO = B.DEPTNO)')
    AfterExecute = MyQueryAfterExecute
    Left = 128
    Top = 56
  end
  object DataSource: TDataSource
    DataSet = MyQuery
    Left = 160
    Top = 56
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'XML (*.xml)|*.xml'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 193
    Top = 53
  end
end
