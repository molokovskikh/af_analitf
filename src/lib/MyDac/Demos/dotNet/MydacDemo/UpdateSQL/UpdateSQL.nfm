inherited UpdateSQLFrame: TUpdateSQLFrame
  Width = 443
  Height = 277
  Align = alClient
  object DBGrid: TDBGrid
    Left = 0
    Top = 146
    Width = 443
    Height = 131
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
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 416
      Height = 46
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
      object Panel4: TPanel
        Left = 1
        Top = 24
        Width = 414
        Height = 21
        BevelOuter = bvNone
        TabOrder = 0
        object cbDeleteObject: TCheckBox
          Left = 15
          Top = 3
          Width = 91
          Height = 17
          Caption = 'DeleteObject'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          OnClick = cbDeleteObjectClick
        end
        object cbInsertObject: TCheckBox
          Left = 110
          Top = 3
          Width = 81
          Height = 17
          Caption = 'InsertObject'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          OnClick = cbDeleteObjectClick
        end
        object cbModifyObject: TCheckBox
          Left = 205
          Top = 3
          Width = 91
          Height = 17
          Caption = 'ModifyObject'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          OnClick = cbDeleteObjectClick
        end
        object cbRefreshObject: TCheckBox
          Left = 315
          Top = 3
          Width = 93
          Height = 17
          Caption = 'RefreshObject'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
          OnClick = cbDeleteObjectClick
        end
      end
    end
  end
  object meSQL: TMemo
    Left = 0
    Top = 48
    Width = 443
    Height = 72
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 1
    OnExit = meSQLExit
  end
  object Panel1: TPanel
    Left = 0
    Top = 120
    Width = 443
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 325
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object btRefreshRecord: TSpeedButton
        Left = 242
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
        Width = 240
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object DBNavigator1: TDBNavigator
          Left = 0
          Top = 0
          Width = 240
          Height = 22
          DataSource = DataSource
          Flat = True
          TabOrder = 0
        end
      end
    end
  end
  object MyQuery: TMyQuery
    SQL.Strings = (
      'SELECT * FROM EMP')
    UpdateObject = MyUpdateSQL
    Left = 31
    Top = 92
  end
  object DataSource: TDataSource
    DataSet = MyQuery
    Left = 60
    Top = 92
  end
  object MyUpdateSQL: TMyUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO EMP'
      
        '  (EMP.ENAME, EMP.JOB, EMP.MGR, EMP.HIREDATE, EMP.SAL, EMP.COMM,' +
        ' EMP.DEPTNO)'
      'VALUES'
      '  (:ENAME, :JOB, :MGR, :HIREDATE, :SAL, :COMM, :DEPTNO)')
    DeleteSQL.Strings = (
      'DELETE FROM EMP'
      'WHERE'
      '  EMPNO = :Old_EMPNO')
    ModifySQL.Strings = (
      'UPDATE EMP'
      'SET'
      
        '  ENAME = :ENAME, JOB = :JOB, MGR = :MGR, HIREDATE = :HIREDATE, ' +
        'SAL = :SAL, COMM = :COMM, DEPTNO = :DEPTNO'
      'WHERE'
      '  EMPNO = :Old_EMPNO')
    RefreshSQL.Strings = (
      
        'SELECT EMP.ENAME, EMP.JOB, EMP.MGR, EMP.HIREDATE, EMP.SAL, EMP.C' +
        'OMM, EMP.DEPTNO FROM EMP'
      'WHERE'
      '  EMP.EMPNO = :Old_EMPNO')
    Left = 98
    Top = 92
  end
  object DeleteSQL: TMyCommand
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'DELETE FROM EMP'
      'WHERE'
      '  EMPNO = :Old_EMPNO')
    Left = 145
    Top = 65
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'Old_EMPNO'
      end>
  end
  object InsertSQL: TMyCommand
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'INSERT INTO EMP'
      
        '  (EMP.ENAME, EMP.JOB, EMP.MGR, EMP.HIREDATE, EMP.SAL, EMP.COMM,' +
        ' EMP.DEPTNO)'
      'VALUES'
      '  (:ENAME, :JOB, :MGR, :HIREDATE, :SAL, :COMM, :DEPTNO)')
    Left = 145
    Top = 100
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ENAME'
      end
      item
        DataType = ftUnknown
        Name = 'JOB'
      end
      item
        DataType = ftUnknown
        Name = 'MGR'
      end
      item
        DataType = ftUnknown
        Name = 'HIREDATE'
      end
      item
        DataType = ftUnknown
        Name = 'SAL'
      end
      item
        DataType = ftUnknown
        Name = 'COMM'
      end
      item
        DataType = ftUnknown
        Name = 'DEPTNO'
      end>
  end
  object RefreshQuery: TMyQuery
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      
        'SELECT EMP.ENAME, EMP.JOB, EMP.MGR, EMP.HIREDATE, EMP.SAL, EMP.C' +
        'OMM, EMP.DEPTNO FROM EMP'
      'WHERE'
      '  EMP.EMPNO = :Old_EMPNO')
    Left = 145
    Top = 165
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'Old_EMPNO'
      end>
  end
  object ModifyQuery: TMyQuery
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'UPDATE EMP'
      'SET'
      
        '  ENAME = :ENAME, JOB = :JOB, MGR = :MGR, HIREDATE = :HIREDATE, ' +
        'SAL = :SAL, COMM = :COMM, DEPTNO = :DEPTNO'
      'WHERE'
      '  EMPNO = :Old_EMPNO')
    Left = 145
    Top = 135
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ENAME'
      end
      item
        DataType = ftUnknown
        Name = 'JOB'
      end
      item
        DataType = ftUnknown
        Name = 'MGR'
      end
      item
        DataType = ftUnknown
        Name = 'HIREDATE'
      end
      item
        DataType = ftUnknown
        Name = 'SAL'
      end
      item
        DataType = ftUnknown
        Name = 'COMM'
      end
      item
        DataType = ftUnknown
        Name = 'DEPTNO'
      end
      item
        DataType = ftUnknown
        Name = 'Old_EMPNO'
      end>
  end
end
