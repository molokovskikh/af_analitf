object DM: TDM
  OldCreateOrder = True
  OnCreate = DMCreate
  OnDestroy = DataModuleDestroy
  Left = 149
  Top = 111
  Height = 627
  Width = 859
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
  object dsTablesUpdates: TDataSource
    DataSet = adtTablesUpdates
    Left = 360
    Top = 272
  end
  object Ras: TARas
    Left = 16
    Top = 544
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
  object dsReclame: TDataSource
    DataSet = adtReclame
    Left = 200
    Top = 272
  end
  object MainConnection1: TpFIBDatabase
    DBName = 'C:\Work\Analit\VSS\Inforoom\Delphi\AnalitF\src\bin\ANALITF.FDB'
    DBParams.Strings = (
      'lc_ctype=WIN1251'
      'password=masterkey'
      'user_name=sysdba')
    DefaultTransaction = DefTran
    SQLDialect = 3
    Timeout = 0
    DesignDBOptions = []
    LibraryName = 'fbclient.dll'
    WaitForRestoreConnect = 0
    AfterConnect = MainConnection1AfterConnect
    Left = 32
    Top = 168
  end
  object DefTran: TpFIBTransaction
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
      '    HTTPNAMECHANGED = :HTTPNAMECHANGED,'
      '    SHOWALLCATALOG = :SHOWALLCATALOG'
      'WHERE'
      '    ID = :OLD_ID'
      '    ')
    RefreshSQL.Strings = (
      'select * from Params where(  ID = 0'
      '     ) and (     PARAMS.ID = :OLD_ID'
      '     )'
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
    UpdateSQL.Strings = (
      'UPDATE RECLAME'
      'SET '
      '    UPDATEDATETIME = :UPDATEDATETIME'
      'WHERE'
      '    RECLAMEURL = :RECLAMEURL'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    RECLAMEURL,'
      '    UPDATEDATETIME'
      'FROM'
      '    RECLAME ')
    Transaction = DefTran
    Database = MainConnection1
    AutoCommit = True
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
    oFetchAll = True
    object adtClientsCLIENTID: TFIBBCDField
      FieldName = 'CLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adtClientsNAME: TFIBStringField
      FieldName = 'NAME'
      Size = 50
      EmptyStrToNull = False
    end
    object adtClientsREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adtClientsADDRESS: TFIBStringField
      FieldName = 'ADDRESS'
      Size = 100
      EmptyStrToNull = False
    end
    object adtClientsPHONE: TFIBStringField
      FieldName = 'PHONE'
      EmptyStrToNull = False
    end
    object adtClientsFORCOUNT: TFIBIntegerField
      FieldName = 'FORCOUNT'
    end
    object adtClientsEMAIL: TFIBStringField
      FieldName = 'EMAIL'
      Size = 30
      EmptyStrToNull = False
    end
    object adtClientsMAXUSERS: TFIBIntegerField
      FieldName = 'MAXUSERS'
    end
    object adtClientsUSEEXCESS: TFIBBooleanField
      FieldName = 'USEEXCESS'
    end
    object adtClientsEXCESS: TFIBIntegerField
      FieldName = 'EXCESS'
    end
    object adtClientsDELTAMODE: TFIBSmallIntField
      FieldName = 'DELTAMODE'
    end
    object adtClientsONLYLEADERS: TFIBBooleanField
      FieldName = 'ONLYLEADERS'
    end
    object adtClientsREQMASK: TFIBBCDField
      FieldName = 'REQMASK'
      Size = 0
      RoundByScale = True
    end
    object adtClientsTECHSUPPORT: TFIBStringField
      FieldName = 'TECHSUPPORT'
      Size = 255
      EmptyStrToNull = False
    end
    object adtClientsLEADFROMBASIC: TFIBSmallIntField
      FieldName = 'LEADFROMBASIC'
    end
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
      '    ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    FLAGS'
      'WHERE'
      '        ID = :OLD_ID'
      '    ')
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
      '    id,'
      '    COMPUTERNAME,'
      '    EXCLUSIVEID'
      'FROM'
      '    FLAGS '
      'where '
      '  ID = 0')
    SelectSQL.Strings = (
      'SELECT'
      '    id,'
      '    COMPUTERNAME,'
      '    EXCLUSIVEID'
      'FROM'
      '    FLAGS '
      'where'
      '  ID = 0')
    Transaction = DefTran
    Database = MainConnection1
    AutoCommit = True
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
    UpdateSQL.Strings = (
      'update'
      '  orders'
      'set'
      '  COREID = :NEW_COREID,'
      '  Price = :NEW_PRICE'
      'where'
      '  ID = :OLD_ID')
    Transaction = DefTran
    Database = MainConnection1
    AutoCommit = True
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
    oFetchAll = True
  end
  object adsOrdersH: TpFIBDataSet
    UpdateSQL.Strings = (
      'update ordersh'
      'set'
      '  SERVERORDERID = :SERVERORDERID,'
      '  SENDDATE = :SENDDATE,'
      '  CLOSED = :CLOSED,'
      '  SEND = :SEND'
      'where'
      '  orderid = :orderid')
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
      '  Send = :ASend')
    Transaction = DefTran
    Database = MainConnection1
    AutoCommit = True
    Left = 64
    Top = 344
    oFetchAll = True
  end
  object adsOrders: TpFIBDataSet
    UpdateSQL.Strings = (
      'update orders'
      'set'
      '  coreid = :new_coreid '
      'where'
      '    orderid = :orderid'
      'and coreid = :old_coreid')
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
    AutoCommit = True
    Left = 144
    Top = 344
    oFetchAll = True
  end
  object BackService: TpFIBBackupService
    LoginPrompt = False
    LibraryName = 'fbclient.dll'
    BlockingFactor = 0
    Options = [NoGarbageCollection]
    Left = 368
    Top = 384
  end
  object RestService: TpFIBRestoreService
    LoginPrompt = False
    LibraryName = 'fbclient.dll'
    PageSize = 4096
    PageBuffers = 3000
    Options = [Replace, CreateNewDB, UseAllSpace]
    Left = 432
    Top = 384
  end
  object ConfigService: TpFIBConfigService
    LoginPrompt = False
    LibraryName = 'fbclient.dll'
    Left = 504
    Top = 384
  end
  object ValidService: TpFIBValidationService
    LoginPrompt = False
    LibraryName = 'fbclient.dll'
    Options = [SweepDB]
    GlobalAction = CommitGlobal
    Left = 576
    Top = 384
  end
  object t: TpFIBQuery
    Transaction = DefTran
    Database = MainConnection1
    SQL.Strings = (
      'select distinct c.Pricecode'
      '    from'
      '      core c'
      '      left join synonyms s on s.synonymcode = c.synonymcode'
      
        '      left join synonymfirmcr sfc on sfc.synonymfirmcrcode = c.s' +
        'ynonymfirmcrcode'
      '    where'
      '           c.synonymcode > 0'
      
        '       and ((s.synonymcode is null) or (sfc.synonymfirmcrcode is' +
        ' null))')
    Left = 648
    Top = 344
  end
end
