object DM: TDM
  OldCreateOrder = False
  Left = 185
  Top = 105
  Height = 227
  Width = 284
  object Connection: TMyConnection
    Options.DisconnectedMode = True
    Options.LocalFailover = True
    Left = 32
    Top = 32
  end
  object quDetail: TMyQuery
    Connection = Connection
    SQL.Strings = (
      'select * from EMP')
    Debug = True
    CachedUpdates = True
    Options.LocalMasterDetail = True
    MasterSource = dsMaster
    MasterFields = 'DEPTNO'
    DetailFields = 'DEPTNO'
    FetchAll = True
    Left = 74
    Top = 79
  end
  object quMaster: TMyQuery
    Connection = Connection
    SQL.Strings = (
      'select * from DEPT'
      '')
    Debug = True
    CachedUpdates = True
    FetchAll = True
    Left = 74
    Top = 32
  end
  object dsDetail: TDataSource
    DataSet = quDetail
    Left = 117
    Top = 80
  end
  object dsMaster: TDataSource
    DataSet = quMaster
    Left = 116
    Top = 32
  end
  object scCreate: TMyScript
    SQL.Strings = (
      'CREATE TABLE DEPT ('
      '  DEPTNO INT PRIMARY KEY,'
      '  DNAME VARCHAR(14),'
      '  LOC VARCHAR(13)'
      ');'
      'INSERT INTO DEPT VALUES (10,'#39'ACCOUNTING'#39','#39'NEW YORK'#39');'
      'INSERT INTO DEPT VALUES (20,'#39'RESEARCH'#39','#39'DALLAS'#39');'
      'INSERT INTO DEPT VALUES (30,'#39'SALES'#39','#39'CHICAGO'#39');'
      'INSERT INTO DEPT VALUES (40,'#39'OPERATIONS'#39','#39'BOSTON'#39');'
      ''
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
      
        'INSERT INTO EMP VALUES (7369,'#39'SMITH'#39','#39'CLERK'#39',7902,'#39'1980-12-17'#39',8' +
        '00,NULL,20);'
      
        'INSERT INTO EMP VALUES (7499,'#39'ALLEN'#39','#39'SALESMAN'#39',7698,'#39'1981-2-20'#39 +
        ',1600,300,30);'
      
        'INSERT INTO EMP VALUES (7521,'#39'WARD'#39','#39'SALESMAN'#39',7698,'#39'1981-2-22'#39',' +
        '1250,500,30);'
      
        'INSERT INTO EMP VALUES (7566,'#39'JONES'#39','#39'MANAGER'#39',7839,'#39'1981-4-2'#39',2' +
        '975,NULL,20);'
      
        'INSERT INTO EMP VALUES (7654,'#39'MARTIN'#39','#39'SALESMAN'#39',7698,'#39'1981-9-28' +
        #39',1250,1400,30);'
      
        'INSERT INTO EMP VALUES (7698,'#39'BLAKE'#39','#39'MANAGER'#39',7839,'#39'1981-5-1'#39',2' +
        '850,NULL,30);'
      
        'INSERT INTO EMP VALUES (7782,'#39'CLARK'#39','#39'MANAGER'#39',7839,'#39'1981-6-9'#39',2' +
        '450,NULL,10);'
      
        'INSERT INTO EMP VALUES (7788,'#39'SCOTT'#39','#39'ANALYST'#39',7566,'#39'1987-7-13'#39',' +
        '3000,NULL,20);'
      
        'INSERT INTO EMP VALUES (7839,'#39'KING'#39','#39'PRESIDENT'#39',NULL,'#39'1981-11-17' +
        #39',5000,NULL,10);'
      
        'INSERT INTO EMP VALUES (7844,'#39'TURNER'#39','#39'SALESMAN'#39',7698,'#39'1981-9-8'#39 +
        ',1500,0,30);'
      
        'INSERT INTO EMP VALUES (7876,'#39'ADAMS'#39','#39'CLERK'#39',7788,'#39'1987-7-13'#39',11' +
        '00,NULL,20);'
      
        'INSERT INTO EMP VALUES (7900,'#39'JAMES'#39','#39'CLERK'#39',7698,'#39'1981-12-3'#39',95' +
        '0,NULL,30);'
      
        'INSERT INTO EMP VALUES (7902,'#39'FORD'#39','#39'ANALYST'#39',7566,'#39'1981-12-3'#39',3' +
        '000,NULL,20);'
      
        'INSERT INTO EMP VALUES (7934,'#39'MILLER'#39','#39'CLERK'#39',7782,'#39'1982-1-23'#39',1' +
        '300,NULL,10);'
      '')
    Connection = Connection
    Left = 165
    Top = 30
  end
  object scDrop: TMyScript
    SQL.Strings = (
      'DROP TABLE IF EXISTS DEPT;'
      'DROP TABLE IF EXISTS EMP;')
    Connection = Connection
    Left = 210
    Top = 29
  end
end
