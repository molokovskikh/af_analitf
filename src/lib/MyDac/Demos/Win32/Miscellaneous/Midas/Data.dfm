object Datas: TDatas
  OldCreateOrder = False
  OnCreate = DatasCreate
  OnDestroy = DatasDestroy
  Left = 245
  Top = 271
  Height = 480
  Width = 696
  object MyConnection: TMyConnection
    Database = 'test'
    AfterConnect = ConnectionChange
    AfterDisconnect = ConnectionChange
    ConnectDialog = MyConnectDialog
    Left = 24
    Top = 16
  end
  object Query: TMyQuery
    Connection = MyConnection
    SQL.Strings = (
      'SELECT *'
      'FROM EMP'
      'WHERE EmpNo < :EmpNo')
    Debug = True
    Left = 72
    Top = 16
    ParamData = <
      item
        DataType = ftInteger
        Name = 'EmpNo'
        ParamType = ptInput
      end>
  end
  object DataSetProvider: TDataSetProvider
    DataSet = Query
    ResolveToDataSet = True
    Options = [poNoReset]
    Left = 128
    Top = 64
  end
  object MyConnectDialog: TMyConnectDialog
    DatabaseLabel = 'Database'
    PortLabel = 'Port'
    SavePassword = True
    Caption = 'Connect'
    UsernameLabel = 'User Name'
    PasswordLabel = 'Password'
    ServerLabel = 'Server'
    ConnectButton = 'Connect'
    CancelButton = 'Cancel'
    Left = 24
    Top = 64
  end
  object MyDataSetProvider: TDataSetProvider
    DataSet = Query
    Left = 128
    Top = 16
  end
end
