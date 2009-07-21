inherited StoredProcFrame: TStoredProcFrame
  Width = 443
  Height = 277
  Align = alClient
  object DBGrid: TDBGrid
    Left = 0
    Top = 48
    Width = 443
    Height = 229
    Align = alClient
    DataSource = DataSource
    TabOrder = 1
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
    object Panel1: TPanel
      Left = 1
      Top = 0
      Width = 517
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 85
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object btClose: TSpeedButton
        Left = 87
        Top = 1
        Width = 85
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object btPrepare: TSpeedButton
        Left = 173
        Top = 1
        Width = 85
        Height = 22
        Caption = 'Prepare'
        Flat = True
        Transparent = False
        OnClick = btPrepareClick
      end
      object btUnPrepare: TSpeedButton
        Left = 259
        Top = 1
        Width = 85
        Height = 22
        Caption = 'UnPrepare'
        Flat = True
        Transparent = False
        OnClick = btUnPrepareClick
      end
      object btExecute: TSpeedButton
        Left = 345
        Top = 1
        Width = 85
        Height = 22
        Caption = 'Execute'
        Flat = True
        Transparent = False
        OnClick = btExecuteClick
      end
      object btPrepareSQL: TSpeedButton
        Left = 431
        Top = 1
        Width = 85
        Height = 22
        Caption = 'PrepareSQL'
        Flat = True
        Transparent = False
        OnClick = btPrepareSQLClick
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 23
      Width = 517
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 1
      object Panel4: TPanel
        Left = 296
        Top = 1
        Width = 220
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object DBNavigator: TDBNavigator
          Left = 0
          Top = 0
          Width = 220
          Height = 22
          DataSource = DataSource
          Flat = True
          TabOrder = 0
        end
      end
      object Panel3: TPanel
        Left = 1
        Top = 1
        Width = 294
        Height = 22
        BevelOuter = bvNone
        TabOrder = 1
        object Label1: TLabel
          Left = 4
          Top = 5
          Width = 82
          Height = 13
          Caption = 'StoredProc name'
        end
        object edStoredProcName: TEdit
          Left = 95
          Top = 1
          Width = 181
          Height = 21
          TabOrder = 0
          Text = 'sel_from_emp'
        end
      end
    end
  end
  object DataSource: TDataSource
    DataSet = MyStoredProc
    Left = 432
    Top = 72
  end
  object MyStoredProc: TMyStoredProc
    StoredProcName = 'sel_from_emp'
    SQLInsert.Strings = (
      'INSERT INTO EMP'
      '  (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)'
      'VALUES'
      '  (:EMPNO, :ENAME, :JOB, :MGR, :HIREDATE, :SAL, :COMM, :DEPTNO)')
    SQLDelete.Strings = (
      'DELETE FROM EMP'
      'WHERE'
      '  EMPNO = :Old_EMPNO')
    SQLUpdate.Strings = (
      'UPDATE EMP'
      'SET'
      
        '  EMPNO = :EMPNO, ENAME = :ENAME, JOB = :JOB, MGR = :MGR, HIREDA' +
        'TE = :HIREDATE, SAL = :SAL, COMM = :COMM, DEPTNO = :DEPTNO'
      'WHERE'
      '  EMPNO = :Old_EMPNO')
    SQLRefresh.Strings = (
      
        'SELECT EMP.EMPNO, EMP.ENAME, EMP.JOB, EMP.MGR, EMP.HIREDATE, EMP' +
        '.SAL, EMP.COMM, EMP.DEPTNO FROM EMP'
      'WHERE'
      '  EMPNO = :EMPNO')
    Connection = MyDACForm.MyConnection
    Debug = True
    FetchAll = True
    Left = 400
    Top = 72
  end
end
