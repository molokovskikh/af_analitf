object DM: TDM
  OldCreateOrder = True
  OnCreate = DMCreate
  OnDestroy = DataModuleDestroy
  Left = 305
  Top = 135
  Height = 627
  Width = 859
  object frReport: TfrReport
    InitialZoom = pzPageWidth
    PreviewButtons = [pbZoom, pbPrint, pbFind, pbExit]
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
    DefaultUpdateTransaction = UpTran
    SQLDialect = 3
    Timeout = 0
    DesignDBOptions = []
    LibraryName = 'fbclient.dll'
    WaitForRestoreConnect = 0
    AfterConnect = MainConnection1AfterConnect
    Left = 40
    Top = 168
  end
  object DefTran: TpFIBTransaction
    DefaultDatabase = MainConnection1
    TimeoutAction = TARollback
    TRParams.Strings = (
      'read'
      'read_committed'
      'rec_version')
    TPBMode = tpbDefault
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
      '    SHOWALLCATALOG = :SHOWALLCATALOG,'
      '    CDS = :CDS'
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
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 48
    Top = 216
    oCacheCalcFields = True
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
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 112
    Top = 216
    oCacheCalcFields = True
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
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 200
    Top = 216
    oCacheCalcFields = True
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
      'where'
      '  Clientid = :OLD_ClientID')
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
    AfterOpen = adtClientsAfterOpen
    AllowedUpdateKinds = [ukModify]
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 280
    Top = 216
    oCacheCalcFields = True
    oFetchAll = True
    object adtClientsCLIENTID: TFIBBCDField
      FieldName = 'CLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adtClientsNAME: TFIBStringField
      FieldName = 'NAME'
      Size = 50
      EmptyStrToNull = True
    end
    object adtClientsREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adtClientsADDRESS: TFIBStringField
      FieldName = 'ADDRESS'
      Size = 100
      EmptyStrToNull = True
    end
    object adtClientsPHONE: TFIBStringField
      FieldName = 'PHONE'
      EmptyStrToNull = True
    end
    object adtClientsFORCOUNT: TFIBIntegerField
      FieldName = 'FORCOUNT'
    end
    object adtClientsEMAIL: TFIBStringField
      FieldName = 'EMAIL'
      Size = 30
      EmptyStrToNull = True
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
      EmptyStrToNull = True
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
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 360
    Top = 216
    oCacheCalcFields = True
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
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 448
    Top = 216
    oCacheCalcFields = True
  end
  object adcUpdate: TpFIBQuery
    Transaction = UpTran
    Database = MainConnection1
    Left = 536
    Top = 216
  end
  object adsSelect: TpFIBDataSet
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    Left = 600
    Top = 216
    oCacheCalcFields = True
  end
  object adsSelect2: TpFIBDataSet
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    Left = 664
    Top = 216
    oCacheCalcFields = True
  end
  object adsSelect3: TpFIBDataSet
    UpdateSQL.Strings = (
      'update'
      '  orders'
      'set'
      '  COREID = :NEW_COREID,'
      '  Price = :NEW_PRICE,'
      '  CODE = :NEW_CODE,'
      '  CODECR = :NEW_CODECR'
      'where'
      '  ID = :OLD_ID')
    SelectSQL.Strings = (
      'SELECT '
      '  Id, '
      '  CoreId, '
      '  PriceCode, '
      '  RegionCode, '
      '  Code, '
      '  CodeCr, '
      '  Price, '
      '  SynonymCode, '
      '  SynonymFirmCrCode, '
      '  SynonymName, '
      '  SynonymFirm, '
      '  Junk, '
      '  Await, '
      '  OrderCount, '
      '  PriceName '
      'FROM '
      '  Orders '
      
        '  INNER JOIN OrdersH ON (OrdersH.OrderId=Orders.OrderId AND Orde' +
        'rsH.Closed = 0)'
      'WHERE '
      '  (OrderCount>0)'#39)
    OnCalcFields = adsSelect3CalcFields
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 728
    Top = 216
    oCacheCalcFields = True
    object adsSelect3ID: TFIBBCDField
      FieldName = 'ID'
      Size = 0
      RoundByScale = True
    end
    object adsSelect3COREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsSelect3PRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsSelect3REGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsSelect3CODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSelect3CODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSelect3PRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 48
      EmptyStrToNull = True
    end
    object adsSelect3SYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsSelect3SYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsSelect3SYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsSelect3SYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsSelect3JUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsSelect3AWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsSelect3ORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsSelect3PRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsSelect3CryptSYNONYMNAME: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptSYNONYMNAME'
      Size = 250
      Calculated = True
    end
    object adsSelect3CryptSYNONYMFIRM: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptSYNONYMFIRM'
      Size = 250
      Calculated = True
    end
    object adsSelect3CryptCODE: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptCODE'
      Calculated = True
    end
    object adsSelect3CryptCODECR: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptCODECR'
      Calculated = True
    end
    object adsSelect3CryptPRICE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPRICE'
      Calculated = True
    end
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
      '    ORDERSHREGIONNAME'
      'FROM'
      '    CORESHOWBYFIRM(:APRICECODE,'
      '    :AREGIONCODE,'
      '    :ACLIENTID,'
      '    :APRICENAME) ')
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    Left = 240
    Top = 344
    oCacheCalcFields = True
    oFetchAll = True
    object adsCoreCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreSHORTCODE: TFIBBCDField
      FieldName = 'SHORTCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsCoreSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = True
    end
    object adsCoreDOC: TFIBStringField
      FieldName = 'DOC'
      EmptyStrToNull = True
    end
    object adsCoreNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = True
    end
    object adsCorePERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = True
    end
    object adsCoreAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsCoreJUNK: TFIBIntegerField
      FieldName = 'JUNK'
    end
    object adsCoreBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 48
      EmptyStrToNull = True
    end
    object adsCoreQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = True
    end
    object adsCoreSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreMINPRICE: TFIBBCDField
      FieldName = 'MINPRICE'
      Size = 2
      RoundByScale = True
    end
    object adsCoreLEADERPRICECODE: TFIBBCDField
      FieldName = 'LEADERPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreLEADERREGIONCODE: TFIBBCDField
      FieldName = 'LEADERREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreLEADERREGIONNAME: TFIBStringField
      FieldName = 'LEADERREGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsCoreLEADERPRICENAME: TFIBStringField
      FieldName = 'LEADERPRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsCoreORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSCLIENTID: TFIBBCDField
      FieldName = 'ORDERSCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSFULLCODE: TFIBBCDField
      FieldName = 'ORDERSFULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSCODEFIRMCR: TFIBBCDField
      FieldName = 'ORDERSCODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSSYNONYMCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSCODE: TFIBStringField
      FieldName = 'ORDERSCODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreORDERSCODECR: TFIBStringField
      FieldName = 'ORDERSCODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsCoreORDERSSYNONYM: TFIBStringField
      FieldName = 'ORDERSSYNONYM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreORDERSSYNONYMFIRM: TFIBStringField
      FieldName = 'ORDERSSYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreORDERSPRICE: TFIBStringField
      FieldName = 'ORDERSPRICE'
      Size = 48
      EmptyStrToNull = True
    end
    object adsCoreORDERSJUNK: TFIBIntegerField
      FieldName = 'ORDERSJUNK'
    end
    object adsCoreORDERSAWAIT: TFIBIntegerField
      FieldName = 'ORDERSAWAIT'
    end
    object adsCoreORDERSHORDERID: TFIBBCDField
      FieldName = 'ORDERSHORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHCLIENTID: TFIBBCDField
      FieldName = 'ORDERSHCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHPRICECODE: TFIBBCDField
      FieldName = 'ORDERSHPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHREGIONCODE: TFIBBCDField
      FieldName = 'ORDERSHREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreORDERSHPRICENAME: TFIBStringField
      FieldName = 'ORDERSHPRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsCoreORDERSHREGIONNAME: TFIBStringField
      FieldName = 'ORDERSHREGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
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
      '    OH.ORDERID,'
      '    OH.SERVERORDERID,'
      '    OH.DATEPRICE,'
      '    OH.PRICECODE,'
      '    OH.REGIONCODE,'
      '    OH.ORDERDATE,'
      '    OH.SENDDATE,'
      '    OH.CLOSED,'
      '    OH.SEND,'
      '    OH.PRICENAME,'
      '    OH.REGIONNAME,'
      '    OH.POSITIONS,'
      '    OH.SUMORDER,'
      '    OH.SUPPORTPHONE,'
      '    OH.MESSAGETO,'
      '    OH.COMMENTS,'
      '    PRD.MinReq,'
      '    PRD.ControlMinReq'
      'FROM'
      '    ORDERSHSHOW(:ACLIENTID,'
      '    :ACLOSED,'
      '    :TIMEZONEBIAS) OH'
      
        '    LEFT JOIN PricesRegionalData PRD ON (OH.PriceCode=PRD.PriceC' +
        'ode AND OH.RegionCode=PRD.RegionCode)  '
      'where'
      '  Send = :ASend')
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 64
    Top = 344
    oCacheCalcFields = True
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
    OnCalcFields = adsOrdersCalcFields
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 144
    Top = 344
    oCacheCalcFields = True
    oFetchAll = True
    object adsOrdersCryptSUMORDER: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptSUMORDER'
      Calculated = True
    end
    object adsOrdersORDERID: TFIBBCDField
      FieldName = 'ORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersCLIENTID: TFIBBCDField
      FieldName = 'CLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrdersCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsOrdersCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsOrdersSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsOrdersSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsOrdersPRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 48
      EmptyStrToNull = True
    end
    object adsOrdersAWAIT: TFIBIntegerField
      FieldName = 'AWAIT'
    end
    object adsOrdersJUNK: TFIBIntegerField
      FieldName = 'JUNK'
    end
    object adsOrdersORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsOrdersSUMORDER: TFIBBCDField
      FieldName = 'SUMORDER'
      Size = 2
      RoundByScale = True
    end
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
  object UpTran: TpFIBTransaction
    DefaultDatabase = MainConnection1
    TimeoutAction = TACommit
    Left = 144
    Top = 168
  end
  object adsRetailMargins: TpFIBDataSet
    CachedUpdates = True
    UpdateSQL.Strings = (
      'UPDATE RETAILMARGINS'
      'SET '
      '    LEFTLIMIT = :LEFTLIMIT,'
      '    RIGHTLIMIT = :RIGHTLIMIT,'
      '    RETAIL = :RETAIL'
      'WHERE'
      '    ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    RETAILMARGINS'
      'WHERE'
      '        ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO RETAILMARGINS('
      '    LEFTLIMIT,'
      '    RIGHTLIMIT,'
      '    RETAIL'
      ')'
      'VALUES('
      '    :LEFTLIMIT,'
      '    :RIGHTLIMIT,'
      '    :RETAIL'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    ID,'
      '    LEFTLIMIT,'
      '    RIGHTLIMIT,'
      '    RETAIL'
      'FROM'
      '    RETAILMARGINS'
      ' WHERE '
      '        RETAILMARGINS.ID = :OLD_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    ID,'
      '    LEFTLIMIT,'
      '    RIGHTLIMIT,'
      '    RETAIL'
      'FROM'
      '    RETAILMARGINS'
      'order by LEFTLIMIT ')
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 128
    Top = 400
    oCacheCalcFields = True
    object adsRetailMarginsID: TFIBBCDField
      FieldName = 'ID'
      Size = 0
      RoundByScale = True
    end
    object adsRetailMarginsLEFTLIMIT: TFIBBCDField
      FieldName = 'LEFTLIMIT'
      Required = True
      OnChange = adsRetailMarginsLEFTLIMITChange
      DisplayFormat = '0.00;;'
      Size = 4
      RoundByScale = True
    end
    object adsRetailMarginsRIGHTLIMIT: TFIBBCDField
      FieldName = 'RIGHTLIMIT'
      Required = True
      OnChange = adsRetailMarginsLEFTLIMITChange
      DisplayFormat = '0.00;;'
      Size = 4
      RoundByScale = True
    end
    object adsRetailMarginsRETAIL: TFIBIntegerField
      FieldName = 'RETAIL'
      Required = True
      MaxValue = 100
    end
  end
  object dsRetailMargins: TDataSource
    DataSet = adsRetailMargins
    Left = 192
    Top = 400
  end
  object adsSumOrders: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '  Orders.code,'
      '  Orders.codecr,'
      '  Orders.price,'
      '  Orders.ordercount'
      'FROM'
      'ordersh oh'
      'inner join orders ol on ol.orderid = oh.orderid'
      'WHERE'
      '    (oh.ClientId=:AClientId)'
      'and (oh.Closed <> 1)'
      'AND (ol.OrderCount > 0)')
    OnCalcFields = adsSumOrdersCalcFields
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    Left = 616
    Top = 272
    oCacheCalcFields = True
    object adsSumOrdersCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSumOrdersCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSumOrdersPRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 48
      EmptyStrToNull = True
    end
    object adsSumOrdersORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsSumOrdersCryptPRICE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPRICE'
      Calculated = True
    end
    object adsSumOrdersSumOrders: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrders'
      Calculated = True
    end
  end
  object adsPrices: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    PRICECODE,'
      '    PRICENAME,'
      '    DATEPRICE,'
      '    UPCOST,'
      '    MINREQ,'
      '    ENABLED,'
      '    PRICEINFO,'
      '    FIRMCODE,'
      '    FULLNAME,'
      '    STORAGE,'
      '    ADMINMAIL,'
      '    SUPPORTPHONE,'
      '    CONTACTINFO,'
      '    OPERATIVEINFO,'
      '    REGIONCODE,'
      '    REGIONNAME,'
      '    POSITIONS,'
      '    SUMORDER,'
      '    PRICESIZE,'
      '    INJOB'
      'FROM'
      '    PRICESSHOW(:ACLIENTID,'
      '    :TIMEZONEBIAS) ')
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    AutoCommit = True
    Left = 304
    Top = 344
    oCacheCalcFields = True
  end
  object adsAllOrders: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ORDERS'
      'SET '
      '    CODE = :CODE,'
      '    CODECR = :CODECR,'
      '    SYNONYMNAME = :SYNONYMNAME,'
      '    SYNONYMFIRM = :SYNONYMFIRM,'
      '    PRICE = :PRICE'
      'WHERE'
      '    ID = :OLD_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    ID,'
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
      '    ORDERCOUNT'
      'FROM'
      '    ORDERS ')
    OnCalcFields = adsAllOrdersCalcFields
    Transaction = DefTran
    Database = MainConnection1
    UpdateTransaction = UpTran
    Left = 688
    Top = 272
    oCacheCalcFields = True
    object adsAllOrdersID: TFIBBCDField
      FieldName = 'ID'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersORDERID: TFIBBCDField
      FieldName = 'ORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersCLIENTID: TFIBBCDField
      FieldName = 'CLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsAllOrdersCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsAllOrdersSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsAllOrdersSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsAllOrdersPRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 48
      EmptyStrToNull = True
    end
    object adsAllOrdersAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsAllOrdersJUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsAllOrdersORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsAllOrdersCryptSYNONYMNAME: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptSYNONYMNAME'
      Calculated = True
    end
    object adsAllOrdersCryptSYNONYMFIRM: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptSYNONYMFIRM'
      Calculated = True
    end
    object adsAllOrdersCryptCODE: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptCODE'
      Calculated = True
    end
    object adsAllOrdersCryptCODECR: TStringField
      FieldKind = fkCalculated
      FieldName = 'CryptCODECR'
      Calculated = True
    end
    object adsAllOrdersCryptPRICE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPRICE'
      Calculated = True
    end
  end
end
