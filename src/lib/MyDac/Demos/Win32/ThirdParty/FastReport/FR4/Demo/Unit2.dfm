object ReportData: TReportData
  OldCreateOrder = False
  Left = 422
  Top = 104
  Height = 220
  Width = 254
  object MyConnection: TMyConnection
    Database = 'test'
    Username = 'root'
    Server = 'Server'
    Left = 24
    Top = 16
  end
  object Dept: TMyTable
    TableName = 'dept'
    Connection = MyConnection
    FetchAll = True
    Left = 96
    Top = 16
  end
  object Emp: TMyTable
    TableName = 'emp'
    MasterFields = 'DEPTNO'
    DetailFields = 'DEPTNO'
    MasterSource = DeptSource
    Connection = MyConnection
    FetchAll = True
    Left = 168
    Top = 16
    ParamData = <
      item
        DataType = ftInteger
        Name = 'DEPTNO'
        ParamType = ptInput
        Value = 60
      end>
  end
  object DeptSource: TDataSource
    DataSet = Dept
    Left = 96
    Top = 64
  end
  object EmpSource: TDataSource
    DataSet = Emp
    Left = 168
    Top = 64
  end
  object DeptDS: TfrxDBDataset
    UserName = 'Dept'
    DataSource = DeptSource
    Left = 96
    Top = 112
  end
  object EmpDS: TfrxDBDataset
    UserName = 'Emp'
    DataSource = EmpSource
    Left = 168
    Top = 112
  end
end
