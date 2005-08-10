object DM: TDM
  OldCreateOrder = True
  OnCreate = DMCreate
  OnDestroy = DataModuleDestroy
  Left = 149
  Top = 249
  Height = 627
  Width = 859
  object MainConnection: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=Anali' +
      'tF.mdb;Persist Security Info=False;Jet OLEDB:Registry Path="";Je' +
      't OLEDB:Database Password=commonpas;Jet OLEDB:Engine Type=5;Jet ' +
      'OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=' +
      '2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Pa' +
      'ssword="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encry' +
      'pt Database=False;Jet OLEDB:Don'#39't Copy Locale on Compact=False;J' +
      'et OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=Fals' +
      'e'
    IsolationLevel = ilReadCommitted
    KeepConnection = False
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    AfterConnect = MainConnectionAfterConnect
    Left = 32
    Top = 8
  end
  object adtParams2: TADOTable
    Connection = MainConnection
    CursorType = ctStatic
    AfterOpen = adtParamsAfterOpen
    IndexName = 'PrimaryKey'
    TableName = 'Params'
    Left = 96
    Top = 8
  end
  object adtProvider2: TADOTable
    Connection = MainConnection
    CursorType = ctStatic
    TableName = 'Provider'
    Left = 152
    Top = 8
  end
  object adcUpdate2: TADOCommand
    CommandTimeout = 60
    Connection = MainConnection
    Parameters = <>
    Left = 528
    Top = 8
  end
  object adsSelect_OLD: TADODataSet
    Connection = MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'AClientId'
        Size = -1
        Value = Null
      end>
    Left = 592
    Top = 8
  end
  object frReport: TfrReport
    InitialZoom = pzPageWidth
    PreviewButtons = [pbZoom, pbSave, pbPrint, pbFind, pbExit]
    RebuildPrinter = False
    Left = 16
    Top = 488
    ReportForm = {19000000}
  end
  object dsParams: TDataSource
    DataSet = adtParams
    Left = 48
    Top = 272
  end
  object dsAnalit: TDataSource
    DataSet = adtProvider
    Left = 112
    Top = 272
  end
  object dsClients: TDataSource
    DataSet = adtClients
    Left = 280
    Top = 272
  end
  object adtTablesUpdates2: TADOTable
    Connection = MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    IndexName = 'PrimaryKey'
    TableDirect = True
    TableName = 'TablesUpdates'
    Left = 360
    Top = 8
  end
  object dsTablesUpdates: TDataSource
    DataSet = adtTablesUpdates
    Left = 360
    Top = 272
  end
  object Ras: TARas
    Left = 16
    Top = 544
  end
  object adsSelect2_OLD: TADODataSet
    Connection = MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    Left = 672
    Top = 8
  end
  object frOLEObject: TfrOLEObject
    Left = 56
    Top = 488
  end
  object frRichObject: TfrRichObject
    Left = 96
    Top = 488
  end
  object frCheckBoxObject: TfrCheckBoxObject
    Left = 136
    Top = 488
  end
  object frShapeObject: TfrShapeObject
    Left = 176
    Top = 488
  end
  object frChartObject: TfrChartObject
    Left = 216
    Top = 488
  end
  object frRoundRectObject: TfrRoundRectObject
    Left = 256
    Top = 488
  end
  object frTextExport: TfrTextExport
    ShowDialog = False
    ScaleX = 1.000000000000000000
    ScaleY = 1.000000000000000000
    KillEmptyLines = False
    PageBreaks = False
    Left = 336
    Top = 488
  end
  object frDialogControls: TfrDialogControls
    Left = 296
    Top = 488
  end
  object frHTML2Export: TfrHTML2Export
    ShowDialog = False
    Scale = 1.000000000000000000
    AllJPEG = True
    Navigator.Position = []
    Navigator.Font.Charset = DEFAULT_CHARSET
    Navigator.Font.Color = clWindowText
    Navigator.Font.Height = -11
    Navigator.Font.Name = 'MS Sans Serif'
    Navigator.Font.Style = []
    Navigator.InFrame = False
    Navigator.WideInFrame = False
    Left = 376
    Top = 488
  end
  object frOLEExcelExport: TfrOLEExcelExport
    ShowDialog = False
    PageBreaks = False
    Left = 416
    Top = 488
  end
  object frBMPExport: TfrBMPExport
    ShowDialog = False
    Left = 456
    Top = 488
  end
  object frJPEGExport: TfrJPEGExport
    ShowDialog = False
    Left = 496
    Top = 488
  end
  object frTIFFExport: TfrTIFFExport
    ShowDialog = False
    Left = 536
    Top = 488
  end
  object frRtfAdvExport: TfrRtfAdvExport
    ShowDialog = False
    Left = 576
    Top = 488
  end
  object adsOrders1: TADODataSet
    Connection = MainConnection
    CursorType = ctStatic
    CommandText = 'SELECT * FROM OrdersShow'
    Parameters = <
      item
        Name = 'AOrderId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    Prepared = True
    Left = 96
    Top = 112
  end
  object adsSelect3_OLD: TADODataSet
    Connection = MainConnection
    CursorType = ctStatic
    Parameters = <>
    Left = 764
    Top = 12
  end
  object adsCore1: TADODataSet
    AutoCalcFields = False
    Connection = MainConnection
    CommandText = 'SELECT * FROM CoreShowByFirm'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '928'
      end
      item
        Name = 'RetailForcount'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '0'
      end
      item
        Name = 'APriceCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '31'
      end
      item
        Name = 'ARegionCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '1'
      end>
    Prepared = True
    Left = 248
    Top = 116
  end
  object adtReclame2: TADOTable
    Connection = MainConnection
    CursorType = ctStatic
    TableName = 'Reclame'
    Left = 224
    Top = 8
  end
  object adtClients2: TADOTable
    Connection = MainConnection
    CursorType = ctStatic
    AfterOpen = adtClientsAfterOpen
    AfterInsert = adtClientsAfterInsert
    AfterPost = adtClientsAfterPost
    BeforeDelete = adtClientsBeforeDelete
    IndexName = 'PrimaryKey'
    TableName = 'Clients'
    Left = 288
    Top = 8
  end
  object dsReclame: TDataSource
    DataSet = adtReclame
    Left = 200
    Top = 272
  end
  object adtFlags2: TADOTable
    Connection = MainConnection
    TableName = 'Flags'
    Left = 448
    Top = 8
  end
  object adsOrdersH1: TADODataSet
    Connection = MainConnection
    CursorType = ctStatic
    CommandText = 'SELECT * FROM OrdersHShow WHERE Send=ASend'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'TimeZoneBias'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'AClosed'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'ASend'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    Prepared = True
    Left = 32
    Top = 112
  end
  object MainConnection1: TpFIBDatabase
    Connected = True
    DBName = 'C:\Program Files\Firebird\ANALITF.FDB'
    DBParams.Strings = (
      'lc_ctype=WIN1251'
      'password=masterkey'
      'user_name=sysdba')
    DefaultTransaction = DefTran
    SQLDialect = 3
    Timeout = 0
    LibraryName = 'fbclient.dll'
    WaitForRestoreConnect = 0
    AfterConnect = MainConnection1AfterConnect
    Left = 32
    Top = 168
  end
  object DefTran: TpFIBTransaction
    Active = True
    DefaultDatabase = MainConnection1
    TimeoutAction = TARollback
    Left = 88
    Top = 168
  end
  object adtParams: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE PARAMS'
      'SET '
      '    CLIENTID = :CLIENTID,'
      '    RASCONNECT = :RASCONNECT,'
      '    RASENTRY = :RASENTRY,'
      '    RASNAME = :RASNAME,'
      '    RASPASS = :RASPASS,'
      '    CONNECTCOUNT = :CONNECTCOUNT,'
      '    CONNECTPAUSE = :CONNECTPAUSE,'
      '    PROXYCONNECT = :PROXYCONNECT,'
      '    PROXYNAME = :PROXYNAME,'
      '    PROXYPORT = :PROXYPORT,'
      '    PROXYUSER = :PROXYUSER,'
      '    PROXYPASS = :PROXYPASS,'
      '    SERVICENAME = :SERVICENAME,'
      '    HTTPHOST = :HTTPHOST,'
      '    HTTPPORT = :HTTPPORT,'
      '    HTTPNAME = :HTTPNAME,'
      '    HTTPPASS = :HTTPPASS,'
      '    UPDATEDATETIME = :UPDATEDATETIME,'
      '    LASTDATETIME = :LASTDATETIME,'
      '    FASTPRINT = :FASTPRINT,'
      '    SHOWREGISTER = :SHOWREGISTER,'
      '    NEWWARES = :NEWWARES,'
      '    USEFORMS = :USEFORMS,'
      '    OPERATEFORMS = :OPERATEFORMS,'
      '    OPERATEFORMSSET = :OPERATEFORMSSET,'
      '    AUTOPRINT = :AUTOPRINT,'
      '    STARTPAGE = :STARTPAGE,'
      '    LASTCOMPACT = :LASTCOMPACT,'
      '    CUMULATIVE = :CUMULATIVE,'
      '    STARTED = :STARTED,'
      '    EXTERNALORDERSEXE = :EXTERNALORDERSEXE,'
      '    EXTERNALORDERSPATH = :EXTERNALORDERSPATH,'
      '    EXTERNALORDERSCREATE = :EXTERNALORDERSCREATE,'
      '    RASSLEEP = :RASSLEEP,'
      '    HTTPNAMECHANGED = :HTTPNAMECHANGED'
      'WHERE'
      '    ID = :OLD_ID'
      '    ')
    SelectSQL.Strings = (
      'select * from Params where ID = 0')
    AfterOpen = adtParamsAfterOpen
    Transaction = DefTran
    Database = MainConnection1
    AutoCommit = True
    Left = 48
    Top = 216
  end
  object adtProvider: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE PROVIDER'
      'SET '
      '    NAME = :NAME,'
      '    ADDRESS = :ADDRESS,'
      '    PHONES = :PHONES,'
      '    EMAIL = :EMAIL,'
      '    WEB = :WEB,'
      '    MDBVERSION = :MDBVERSION'
      'WHERE'
      '    ID = :OLD_ID'
      '    ')
    SelectSQL.Strings = (
      'select * from Provider where ID = 0')
    Transaction = DefTran
    Database = MainConnection1
    AutoCommit = True
    Left = 112
    Top = 216
  end
  object adtReclame: TpFIBDataSet
    SelectSQL.Strings = (
      'select * from Reclame')
    Transaction = DefTran
    Database = MainConnection1
    Left = 200
    Top = 216
  end
  object adtClients: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE CLIENTS'
      'SET '
      '    NAME = :NAME,'
      '    REGIONCODE = :REGIONCODE,'
      '    ADDRESS = :ADDRESS,'
      '    PHONE = :PHONE,'
      '    FORCOUNT = :FORCOUNT,'
      '    EMAIL = :EMAIL,'
      '    MAXUSERS = :MAXUSERS,'
      '    USEEXCESS = :USEEXCESS,'
      '    EXCESS = :EXCESS,'
      '    DELTAMODE = :DELTAMODE,'
      '    ONLYLEADERS = :ONLYLEADERS,'
      '    REQMASK = :REQMASK,'
      '    TECHSUPPORT = :TECHSUPPORT,'
      '    LEADFROMBASIC = :LEADFROMBASIC'
      'WHERE'
      '    CLIENTID = :OLD_CLIENTID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    CLIENTS'
      'WHERE'
      '        CLIENTID = :OLD_CLIENTID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO CLIENTS('
      '    CLIENTID,'
      '    NAME,'
      '    REGIONCODE,'
      '    ADDRESS,'
      '    PHONE,'
      '    FORCOUNT,'
      '    EMAIL,'
      '    MAXUSERS,'
      '    USEEXCESS,'
      '    EXCESS,'
      '    DELTAMODE,'
      '    ONLYLEADERS,'
      '    REQMASK,'
      '    TECHSUPPORT,'
      '    LEADFROMBASIC'
      ')'
      'VALUES('
      '    :CLIENTID,'
      '    :NAME,'
      '    :REGIONCODE,'
      '    :ADDRESS,'
      '    :PHONE,'
      '    :FORCOUNT,'
      '    :EMAIL,'
      '    :MAXUSERS,'
      '    :USEEXCESS,'
      '    :EXCESS,'
      '    :DELTAMODE,'
      '    :ONLYLEADERS,'
      '    :REQMASK,'
      '    :TECHSUPPORT,'
      '    :LEADFROMBASIC'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    CLIENTID,'
      '    NAME,'
      '    REGIONCODE,'
      '    ADDRESS,'
      '    PHONE,'
      '    FORCOUNT,'
      '    EMAIL,'
      '    MAXUSERS,'
      '    USEEXCESS,'
      '    EXCESS,'
      '    DELTAMODE,'
      '    ONLYLEADERS,'
      '    REQMASK,'
      '    TECHSUPPORT,'
      '    LEADFROMBASIC'
      'FROM'
      '    CLIENTS'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    CLIENTID,'
      '    NAME,'
      '    REGIONCODE,'
      '    ADDRESS,'
      '    PHONE,'
      '    FORCOUNT,'
      '    EMAIL,'
      '    MAXUSERS,'
      '    USEEXCESS,'
      '    EXCESS,'
      '    DELTAMODE,'
      '    ONLYLEADERS,'
      '    REQMASK,'
      '    TECHSUPPORT,'
      '    LEADFROMBASIC'
      'FROM'
      '    CLIENTS ')
    AfterInsert = adtClientsAfterInsert
    AfterOpen = adtClientsAfterOpen
    AfterPost = adtClientsAfterPost
    BeforeDelete = adtClientsBeforeDelete
    Transaction = DefTran
    Database = MainConnection1
    AutoCommit = True
    Left = 280
    Top = 216
  end
  object adtTablesUpdates: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE TABLESUPDATES'
      'SET '
      '    UPDATEDATE = :UPDATEDATE'
      'WHERE'
      '    TABLENAME = :OLD_TABLENAME'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    TABLESUPDATES'
      'WHERE'
      '        TABLENAME = :OLD_TABLENAME'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO TABLESUPDATES('
      '    tablename,'
      '    UPDATEDATE'
      ')'
      'VALUES('
      '    :tablename'
      '    :UPDATEDATE'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    TABLENAME,'
      '    UPDATEDATE'
      'FROM'
      '    TABLESUPDATES '
      ' WHERE '
      '        TABLESUPDATES.TABLENAME = :OLD_TABLENAME'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    TABLENAME,'
      '    UPDATEDATE'
      'FROM'
      '    TABLESUPDATES ')
    Transaction = DefTran
    Database = MainConnection1
    AutoCommit = True
    Left = 360
    Top = 216
  end
  object adtFlags: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE FLAGS'
      'SET '
      '    COMPUTERNAME = :COMPUTERNAME,'
      '    EXCLUSIVEID = :EXCLUSIVEID'
      'WHERE'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    FLAGS'
      'WHERE'
      '        ')
    InsertSQL.Strings = (
      'INSERT INTO FLAGS('
      '    COMPUTERNAME,'
      '    EXCLUSIVEID'
      ')'
      'VALUES('
      '    :COMPUTERNAME,'
      '    :EXCLUSIVEID'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    COMPUTERNAME,'
      '    EXCLUSIVEID'
      'FROM'
      '    FLAGS ')
    SelectSQL.Strings = (
      'SELECT'
      '    COMPUTERNAME,'
      '    EXCLUSIVEID'
      'FROM'
      '    FLAGS ')
    Transaction = DefTran
    Database = MainConnection1
    Left = 448
    Top = 216
  end
  object adcUpdate: TpFIBQuery
    Transaction = DefTran
    Database = MainConnection1
    Left = 536
    Top = 216
  end
  object adsSelect: TpFIBDataSet
    Transaction = DefTran
    Database = MainConnection1
    Left = 600
    Top = 216
  end
  object adsSelect2: TpFIBDataSet
    Transaction = DefTran
    Database = MainConnection1
    Left = 664
    Top = 216
  end
  object adsSelect3: TpFIBDataSet
    Transaction = DefTran
    Database = MainConnection1
    Left = 728
    Top = 216
  end
  object adsCore: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    COREID,'
      '    FULLCODE,'
      '    SHORTCODE,'
      '    CODEFIRMCR,'
      '    SYNONYMCODE,'
      '    SYNONYMFIRMCRCODE,'
      '    CODE,'
      '    CODECR,'
      '    VOLUME,'
      '    DOC,'
      '    NOTE,'
      '    PERIOD,'
      '    AWAIT,'
      '    JUNK,'
      '    BASECOST,'
      '    QUANTITY,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    MINPRICE,'
      '    LEADERPRICECODE,'
      '    LEADERREGIONCODE,'
      '    LEADERREGIONNAME,'
      '    LEADERPRICENAME,'
      '    ORDERSCOREID,'
      '    ORDERSORDERID,'
      '    ORDERSCLIENTID,'
      '    ORDERSFULLCODE,'
      '    ORDERSCODEFIRMCR,'
      '    ORDERSSYNONYMCODE,'
      '    ORDERSSYNONYMFIRMCRCODE,'
      '    ORDERSCODE,'
      '    ORDERSCODECR,'
      '    ORDERCOUNT,'
      '    ORDERSSYNONYM,'
      '    ORDERSSYNONYMFIRM,'
      '    ORDERSPRICE,'
      '    ORDERSJUNK,'
      '    ORDERSAWAIT,'
      '    ORDERSHORDERID,'
      '    ORDERSHCLIENTID,'
      '    ORDERSHPRICECODE,'
      '    ORDERSHREGIONCODE,'
      '    ORDERSHPRICENAME,'
      '    ORDERSHREGIONNAME,'
      '    PRICERET'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :RETAILFORCOUNT,'
      '    :ACLIENTID) ')
    Transaction = DefTran
    Database = MainConnection1
    Left = 240
    Top = 344
  end
  object adsOrdersH: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ORDERID,'
      '    SERVERORDERID,'
      '    DATEPRICE,'
      '    PRICECODE,'
      '    REGIONCODE,'
      '    ORDERDATE,'
      '    SENDDATE,'
      '    CLOSED,'
      '    SEND,'
      '    PRICENAME,'
      '    REGIONNAME,'
      '    POSITIONS,'
      '    SUMORDER,'
      '    SUPPORTPHONE,'
      '    MESSAGETO,'
      '    COMMENTS'
      'FROM'
      '    ORDERSHSHOW(:ACLIENTID,'
      '    :ACLOSED,'
      '    :TIMEZONEBIAS) '
      'where'
      '  Send = :Send')
    Transaction = DefTran
    Database = MainConnection1
    Left = 64
    Top = 344
  end
  object adsOrders: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    ORDERID,'
      '    CLIENTID,'
      '    COREID,'
      '    FULLCODE,'
      '    CODEFIRMCR,'
      '    SYNONYMCODE,'
      '    SYNONYMFIRMCRCODE,'
      '    CODE,'
      '    CODECR,'
      '    SYNONYMNAME,'
      '    SYNONYMFIRM,'
      '    PRICE,'
      '    AWAIT,'
      '    JUNK,'
      '    ORDERCOUNT,'
      '    SUMORDER'
      'FROM'
      '    ORDERSSHOW(:AORDERID) ')
    Transaction = DefTran
    Database = MainConnection1
    Left = 144
    Top = 344
  end
end
