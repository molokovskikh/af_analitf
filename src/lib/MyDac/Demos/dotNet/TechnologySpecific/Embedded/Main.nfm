object fmMain: TfmMain
  Left = 207
  Top = 155
  Width = 740
  Height = 437
  Caption = 'MySQL Data Access Demo - using MySQL Embedded Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid: TDBGrid
    Left = 0
    Top = 25
    Width = 732
    Height = 185
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
    Width = 732
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 1
      Top = 0
      Width = 398
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
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
      object DBNavigator: TDBNavigator
        Left = 167
        Top = 1
        Width = 230
        Height = 22
        DataSource = DataSource
        Flat = True
        TabOrder = 0
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 391
    Width = 732
    Height = 19
    Panels = <
      item
        Text = 'State'
        Width = 50
      end>
  end
  object Memo1: TMemo
    Left = 0
    Top = 210
    Width = 732
    Height = 181
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object DataSource: TDataSource
    DataSet = MyTable
    Left = 320
    Top = 144
  end
  object MyTable: TMyTable
    TableName = 'EMP'
    OrderFields = 'ENAME'
    Connection = MyConnection
    FetchAll = True
    Left = 288
    Top = 144
  end
  object MyScript: TMyScript
    SQL.Strings = (
      'CREATE TABLE EMP ('
      '  EMPNO INT PRIMARY KEY,'
      '  ENAME VARCHAR(10),'
      '  JOB VARCHAR(9),'
      '  MGR INT,'
      '  HIREDATE DATETIME,'
      '  SAL FLOAT,'
      '  COMM FLOAT,'
      '  DEPTNO INT REFERENCES DEPT'
      ');'
      ''
      'INSERT INTO EMP VALUES'
      '  (7369,'#39'SMITH'#39','#39'CLERK'#39',7902,'#39'1980-12-17'#39',800,NULL,20);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7499,'#39'ALLEN'#39','#39'SALESMAN'#39',7698,'#39'1981-2-20'#39',1600,300,30);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7521,'#39'WARD'#39','#39'SALESMAN'#39',7698,'#39'1981-2-22'#39',1250,500,30);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7566,'#39'JONES'#39','#39'MANAGER'#39',7839,'#39'1981-4-2'#39',2975,NULL,20);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7654,'#39'MARTIN'#39','#39'SALESMAN'#39',7698,'#39'1981-9-28'#39',1250,1400,30);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7698,'#39'BLAKE'#39','#39'MANAGER'#39',7839,'#39'1981-5-1'#39',2850,NULL,30);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7782,'#39'CLARK'#39','#39'MANAGER'#39',7839,'#39'1981-6-9'#39',2450,NULL,10);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7788,'#39'SCOTT'#39','#39'ANALYST'#39',7566,'#39'1987-7-13'#39',3000,NULL,20);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7839,'#39'KING'#39','#39'PRESIDENT'#39',NULL,'#39'1981-11-17'#39',5000,NULL,10);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7844,'#39'TURNER'#39','#39'SALESMAN'#39',7698,'#39'1981-9-8'#39',1500,0,30);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7876,'#39'ADAMS'#39','#39'CLERK'#39',7788,'#39'1987-7-13'#39',1100,NULL,20);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7900,'#39'JAMES'#39','#39'CLERK'#39',7698,'#39'1981-12-3'#39',950,NULL,30);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7902,'#39'FORD'#39','#39'ANALYST'#39',7566,'#39'1981-12-3'#39',3000,NULL,20);'
      ''
      'INSERT INTO EMP VALUES'
      '  (7934,'#39'MILLER'#39','#39'CLERK'#39',7782,'#39'1982-1-23'#39',1300,NULL,10);')
    Connection = MyConnection
    Left = 256
    Top = 144
  end
  object MyConnection: TMyEmbConnection
    Database = 'test'
    Params.Strings = (
      '--basedir=.'
      '--datadir=data')
    OnLog = MyConnectionLog
    OnLogError = MyConnectionLog
    Left = 224
    Top = 144
  end
end
