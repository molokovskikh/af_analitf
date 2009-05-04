object DM: TDM
  OldCreateOrder = True
  OnCreate = DMCreate
  OnDestroy = DataModuleDestroy
  Left = 206
  Top = 145
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
    Top = 256
  end
  object dsAnalit: TDataSource
    DataSet = adtParams
    Left = 104
    Top = 256
  end
  object dsClients: TDataSource
    DataSet = adtClients
    Left = 216
    Top = 240
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
    OpenAfterExport = True
    Wysiwyg = True
    Creator = 'FastReport http://www.fast-report.com'
    Left = 576
    Top = 488
  end
  object MainConnectionOld: TpFIBDatabase
    DBName = 
      'localhost:C:\Work\Analit\VSS\Inforoom\Delphi\AnalitF R 4.2.151.4' +
      '70\src\bin\ANALITF.FDB'
    DBParams.Strings = (
      'lc_ctype=WIN1251'
      'password=masterkey'
      'user_name=sysdba'
      'sweep_interval=0')
    SQLDialect = 3
    Timeout = 0
    DesignDBOptions = []
    LibraryName = 'fbclient.dll'
    WaitForRestoreConnect = 0
    AfterConnect = MainConnectionOldAfterConnect
    Left = 32
    Top = 168
  end
  object adtParamsOld: TpFIBDataSet
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
      '    CDS = :CDS,'
      '    ORDERSHISTORYDAYCOUNT = :ORDERSHISTORYDAYCOUNT,'
      '    CONFIRMDELETEOLDORDERS = :CONFIRMDELETEOLDORDERS,'
      '    USEOSOPENWAYBILL = :USEOSOPENWAYBILL,'
      '    USEOSOPENREJECT = :USEOSOPENREJECT,'
      '    GROUPBYPRODUCTS = :GROUPBYPRODUCTS,'
      '    PRINTORDERSAFTERSEND = :PRINTORDERSAFTERSEND'
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
    Database = MainConnectionOld
    AutoCommit = True
    Left = 48
    Top = 216
    oTrimCharFields = False
    oCacheCalcFields = True
  end
  object adtClientsOld: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE CLIENTS'
      'SET '
      ' NAME = :NAME,'
      ' REGIONCODE = :REGIONCODE,'
      ' EXCESS = :EXCESS,'
      ' DELTAMODE = :DELTAMODE,'
      ' MAXUSERS = :MAXUSERS,'
      ' REQMASK = :REQMASK,'
      ' TECHSUPPORT = :TECHSUPPORT,'
      ' CALCULATELEADER = :CALCULATELEADER,'
      ' ONLYLEADERS = :ONLYLEADERS'
      'WHERE'
      ' CLIENTID = :OLD_CLIENTID'
      ' ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      ' CLIENTS'
      'WHERE'
      '  CLIENTID = :OLD_CLIENTID'
      ' ')
    InsertSQL.Strings = (
      'INSERT INTO CLIENTS('
      ' NAME,'
      ' REGIONCODE,'
      ' EXCESS,'
      ' DELTAMODE,'
      ' MAXUSERS,'
      ' REQMASK,'
      ' TECHSUPPORT,'
      ' CALCULATELEADER,'
      ' ONLYLEADERS'
      ')'
      'VALUES('
      ' :NAME,'
      ' :REGIONCODE,'
      ' :EXCESS,'
      ' :DELTAMODE,'
      ' :MAXUSERS,'
      ' :REQMASK,'
      ' :TECHSUPPORT,'
      ' :CALCULATELEADER,'
      ' :ONLYLEADERS'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      ' CLIENTID,'
      ' NAME,'
      ' REGIONCODE,'
      ' EXCESS,'
      ' DELTAMODE,'
      ' MAXUSERS,'
      ' REQMASK,'
      ' TECHSUPPORT,'
      ' CALCULATELEADER,'
      ' ONLYLEADERS'
      'FROM'
      ' CLIENTS '
      ''
      ' WHERE '
      '  CLIENTS.CLIENTID = :OLD_CLIENTID'
      ' ')
    SelectSQL.Strings = (
      'SELECT'
      ' CLIENTID,'
      ' NAME,'
      ' REGIONCODE,'
      ' EXCESS,'
      ' DELTAMODE,'
      ' MAXUSERS,'
      ' REQMASK,'
      ' TECHSUPPORT,'
      ' CALCULATELEADER,'
      ' ONLYLEADERS'
      'FROM'
      ' CLIENTS ')
    AfterOpen = adtClientsOldAfterOpen
    AllowedUpdateKinds = [ukModify]
    Database = MainConnectionOld
    AutoCommit = True
    Left = 216
    Top = 192
    oCacheCalcFields = True
    oFetchAll = True
    object adtClientsOldCLIENTID: TFIBBCDField
      FieldName = 'CLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adtClientsOldNAME: TFIBStringField
      FieldName = 'NAME'
      Size = 50
      EmptyStrToNull = True
    end
    object adtClientsOldREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adtClientsOldEXCESS: TFIBIntegerField
      FieldName = 'EXCESS'
    end
    object adtClientsOldDELTAMODE: TFIBSmallIntField
      FieldName = 'DELTAMODE'
    end
    object adtClientsOldMAXUSERS: TFIBIntegerField
      FieldName = 'MAXUSERS'
    end
    object adtClientsOldREQMASK: TFIBBCDField
      FieldName = 'REQMASK'
      Size = 0
      RoundByScale = True
    end
    object adtClientsOldTECHSUPPORT: TFIBStringField
      FieldName = 'TECHSUPPORT'
      Size = 255
      EmptyStrToNull = True
    end
    object adtClientsOldCALCULATELEADER: TFIBBooleanField
      FieldName = 'CALCULATELEADER'
    end
    object adtClientsOldONLYLEADERS: TFIBBooleanField
      FieldName = 'ONLYLEADERS'
    end
  end
  object adcUpdateOld: TpFIBQuery
    Database = MainConnectionOld
    Left = 488
    Top = 48
  end
  object adsRepareOrders: TpFIBDataSet
    UpdateSQL.Strings = (
      'update'
      '  orders'
      'set'
      '  COREID = :NEW_COREID,'
      '  Price = :NEW_PRICE,'
      '  CODE = :NEW_CODE,'
      '  CODECR = :NEW_CODECR,'
      '  ORDERCOUNT = :ORDERCOUNT'
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
      '  PriceName,'
      '  requestratio,'
      '  ordercost,'
      '  minordercount '
      'FROM '
      '  Orders '
      
        '  INNER JOIN OrdersH ON (OrdersH.OrderId=Orders.OrderId AND Orde' +
        'rsH.Closed = 0)'
      'WHERE '
      '  (OrderCount>0)')
    Database = MainConnectionOld
    AutoCommit = True
    Left = 744
    Top = 200
    oTrimCharFields = False
    oCacheCalcFields = True
    object adsRepareOrdersID: TFIBBCDField
      FieldName = 'ID'
      Size = 0
      RoundByScale = True
    end
    object adsRepareOrdersCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsRepareOrdersPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsRepareOrdersREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsRepareOrdersCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsRepareOrdersCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsRepareOrdersSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsRepareOrdersSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsRepareOrdersSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsRepareOrdersSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsRepareOrdersJUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsRepareOrdersAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsRepareOrdersORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsRepareOrdersPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsRepareOrdersCryptPRICE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPRICE'
      Calculated = True
    end
    object adsRepareOrdersPRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsRepareOrdersREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
    end
    object adsRepareOrdersORDERCOST: TFIBBCDField
      FieldName = 'ORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsRepareOrdersMINORDERCOUNT: TFIBIntegerField
      FieldName = 'MINORDERCOUNT'
    end
  end
  object adsCoreRepare: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    CCore.CoreId AS CoreId,'
      '    catalogs.fullcode as FullCode,'
      '    catalogs.shortcode,'
      '    CCore.CodeFirmCr,'
      '    CCore.SynonymCode,'
      '    CCore.SynonymFirmCrCode,'
      '    CCore.Code,'
      '    CCore.CodeCr,'
      '    CCore.Volume,'
      '    CCore.Doc,'
      '    CCore.Note,'
      '    CCore.Period,'
      '    CCore.Await,'
      '    CCore.Junk,'
      '    CCore.BaseCost,'
      '    CCore.Quantity,'
      
        '    coalesce(Synonyms.SynonymName, catalogs.name || '#39' '#39' || catal' +
        'ogs.form) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      '    PricesData.PriceCode AS LeaderPriceCode,'
      '    MinPrices.RegionCode AS LeaderRegionCode,'
      '    Regions.RegionName AS LeaderRegionName,'
      '    PricesData.PriceName AS LeaderPriceName,'
      '    LCore.code as LeaderCODE,'
      '    LCore.codecr as LeaderCODECR,'
      '    LCore.basecost as LeaderPRICE,'
      '    osbc.CoreId AS OrdersCoreId,'
      '    osbc.OrderId AS OrdersOrderId,'
      '    osbc.ClientId AS OrdersClientId,'
      '    catalogs.fullcode AS OrdersFullCode,'
      '    osbc.CodeFirmCr AS OrdersCodeFirmCr,'
      '    osbc.SynonymCode AS OrdersSynonymCode,'
      '    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,'
      '    osbc.Code AS OrdersCode,'
      '    osbc.CodeCr AS OrdersCodeCr,'
      '    osbc.OrderCount,'
      '    osbc.SynonymName AS OrdersSynonym,'
      '    osbc.SynonymFirm AS OrdersSynonymFirm,'
      '    osbc.Price AS OrdersPrice,'
      '    osbc.Junk AS OrdersJunk,'
      '    osbc.Await AS OrdersAwait,'
      '    OrdersH.OrderId AS OrdersHOrderId,'
      '    OrdersH.ClientId AS OrdersHClientId,'
      '    OrdersH.PriceCode AS OrdersHPriceCode,'
      '    OrdersH.RegionCode AS OrdersHRegionCode,'
      '    OrdersH.PriceName AS OrdersHPriceName,'
      '    OrdersH.RegionName AS OrdersHRegionName,'
      '    CCore.VitallyImportant,'
      '    CCore.RequestRatio,'
      '    CCore.OrderCost,'
      '    CCore.MinOrderCount'
      'FROM'
      '    Core CCore'
      '    left join products on products.productid = CCore.productid'
      '    left join catalogs on catalogs.fullcode = products.catalogid'
      
        '    LEFT JOIN MinPrices ON MinPrices.Productid = CCore.Productid' +
        ' and minprices.regioncode = :aregioncode'
      
        '    left join Core LCore on LCore.servercoreid = minprices.serve' +
        'rcoreid and LCore.RegionCode = minprices.regioncode'
      '    LEFT JOIN PricesData ON PricesData.PriceCode=LCore.pricecode'
      '    LEFT JOIN Regions ON MinPrices.RegionCode=Regions.RegionCode'
      
        '    LEFT JOIN SynonymFirmCr ON CCore.SynonymFirmCrCode=SynonymFi' +
        'rmCr.SynonymFirmCrCode'
      '    left join synonyms on CCore.SynonymCode=Synonyms.SynonymCode'
      
        '    LEFT JOIN Orders osbc ON osbc.ClientID = :AClientId and osbc' +
        '.CoreId=CCore.CoreId'
      '    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId'
      
        'WHERE (CCore.PriceCode=:APriceCode) And (CCore.RegionCode=:ARegi' +
        'onCode)'
      'and  CCore.SYNONYMCODE = :SYNONYMCODE'
      'and CCore.SYNONYMFIRMCRCODE = :SYNONYMFIRMCRCODE'
      'and CCore.AWAIT = :AWAIT'
      'and CCore.JUNK = :JUNK')
    Database = MainConnectionOld
    Left = 752
    Top = 256
    oCacheCalcFields = True
    object adsCoreRepareCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareSHORTCODE: TFIBBCDField
      FieldName = 'SHORTCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreRepareCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreRepareVOLUME: TFIBStringField
      FieldName = 'VOLUME'
      Size = 15
      EmptyStrToNull = True
    end
    object adsCoreRepareDOC: TFIBStringField
      FieldName = 'DOC'
      EmptyStrToNull = True
    end
    object adsCoreRepareNOTE: TFIBStringField
      FieldName = 'NOTE'
      Size = 50
      EmptyStrToNull = True
    end
    object adsCoreReparePERIOD: TFIBStringField
      FieldName = 'PERIOD'
      EmptyStrToNull = True
    end
    object adsCoreRepareQUANTITY: TFIBStringField
      FieldName = 'QUANTITY'
      Size = 15
      EmptyStrToNull = True
    end
    object adsCoreRepareSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 501
      EmptyStrToNull = True
    end
    object adsCoreRepareSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreRepareLEADERPRICECODE: TFIBBCDField
      FieldName = 'LEADERPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareLEADERREGIONCODE: TFIBBCDField
      FieldName = 'LEADERREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareLEADERREGIONNAME: TFIBStringField
      FieldName = 'LEADERREGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsCoreRepareLEADERPRICENAME: TFIBStringField
      FieldName = 'LEADERPRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsCoreRepareORDERSCOREID: TFIBBCDField
      FieldName = 'ORDERSCOREID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSORDERID: TFIBBCDField
      FieldName = 'ORDERSORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSCLIENTID: TFIBBCDField
      FieldName = 'ORDERSCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSFULLCODE: TFIBBCDField
      FieldName = 'ORDERSFULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSCODEFIRMCR: TFIBBCDField
      FieldName = 'ORDERSCODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSSYNONYMCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'ORDERSSYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSCODE: TFIBStringField
      FieldName = 'ORDERSCODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreRepareORDERSCODECR: TFIBStringField
      FieldName = 'ORDERSCODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsCoreRepareORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsCoreRepareORDERSSYNONYM: TFIBStringField
      FieldName = 'ORDERSSYNONYM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreRepareORDERSSYNONYMFIRM: TFIBStringField
      FieldName = 'ORDERSSYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsCoreRepareORDERSHORDERID: TFIBBCDField
      FieldName = 'ORDERSHORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSHCLIENTID: TFIBBCDField
      FieldName = 'ORDERSHCLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSHPRICECODE: TFIBBCDField
      FieldName = 'ORDERSHPRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSHREGIONCODE: TFIBBCDField
      FieldName = 'ORDERSHREGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsCoreRepareORDERSHPRICENAME: TFIBStringField
      FieldName = 'ORDERSHPRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsCoreRepareORDERSHREGIONNAME: TFIBStringField
      FieldName = 'ORDERSHREGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsCoreRepareAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsCoreRepareJUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsCoreRepareBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 60
      EmptyStrToNull = True
    end
    object adsCoreRepareORDERSPRICE: TFIBStringField
      FieldName = 'ORDERSPRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsCoreRepareORDERSJUNK: TFIBBooleanField
      FieldName = 'ORDERSJUNK'
    end
    object adsCoreRepareORDERSAWAIT: TFIBBooleanField
      FieldName = 'ORDERSAWAIT'
    end
    object adsCoreRepareREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
    end
    object adsCoreRepareVITALLYIMPORTANT: TFIBBooleanField
      FieldName = 'VITALLYIMPORTANT'
    end
    object adsCoreRepareORDERCOST: TFIBBCDField
      FieldName = 'ORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsCoreRepareMINORDERCOUNT: TFIBIntegerField
      FieldName = 'MINORDERCOUNT'
    end
  end
  object adsOrdersHeadersOld: TpFIBDataSet
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
      '    OH.SUPPORTPHONE,'
      '    OH.MESSAGETO,'
      '    OH.COMMENTS,'
      '    PRD.MinReq,'
      '    PRD.ControlMinReq,'
      '    PRD.Enabled as PriceEnabled'
      'FROM'
      '    ORDERSHSHOW(:ACLIENTID,'
      '    :ACLOSED,'
      '    :TIMEZONEBIAS) OH'
      
        '    LEFT JOIN PricesRegionalData PRD ON (OH.PriceCode=PRD.PriceC' +
        'ode AND OH.RegionCode=PRD.RegionCode)  '
      'where'
      '  Send = :ASend')
    Database = MainConnectionOld
    Left = 48
    Top = 344
    oCacheCalcFields = True
    oFetchAll = True
  end
  object adsOrderDetailsOld: TpFIBDataSet
    CachedUpdates = True
    UpdateSQL.Strings = (
      'update orders'
      'set'
      '  coreid = :new_coreid,'
      '  price = :new_price,'
      '  sendprice = :new_sendprice '
      'where'
      '  id = :old_id')
    SelectSQL.Strings = (
      'SELECT '
      '    Orders.id,'
      '    Orders.OrderId,'
      '    Orders.ClientId,'
      '    Orders.CoreId,'
      '    products.catalogid as fullcode,'
      '    Orders.productid,'
      '    Orders.codefirmcr,'
      '    Orders.synonymcode,'
      '    Orders.synonymfirmcrcode,'
      '    Orders.code,'
      '    Orders.codecr,'
      '    Orders.synonymname,'
      '    Orders.synonymfirm,'
      '    Orders.price,'
      '    Orders.await,'
      '    Orders.junk,'
      '    Orders.ordercount,'
      '    Orders.SendPrice*Orders.OrderCount AS SumOrder,'
      '    Orders.SendPrice,'
      '    Orders.RequestRatio,'
      '    Orders.OrderCost,'
      '    Orders.MinOrderCount'
      'FROM '
      '  Orders'
      '  left join products on products.productid = orders.productid'
      'WHERE '
      '    (Orders.OrderId=:AOrderId) '
      'AND (Orders.OrderCount>0)'
      'ORDER BY SynonymName, SynonymFirm')
    Database = MainConnectionOld
    Left = 144
    Top = 344
    oTrimCharFields = False
    oCacheCalcFields = True
    oFetchAll = True
    object adsOrderDetailsOldORDERID: TFIBBCDField
      FieldName = 'ORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsOrderDetailsOldCLIENTID: TFIBBCDField
      FieldName = 'CLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsOrderDetailsOldCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsOrderDetailsOldCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsOrderDetailsOldSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrderDetailsOldSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrderDetailsOldCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsOrderDetailsOldCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsOrderDetailsOldSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsOrderDetailsOldSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsOrderDetailsOldORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsOrderDetailsOldPRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsOrderDetailsOldSENDPRICE: TFIBBCDField
      FieldName = 'SENDPRICE'
      Size = 2
      RoundByScale = True
    end
    object adsOrderDetailsOldAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsOrderDetailsOldJUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsOrderDetailsOldID: TFIBBCDField
      FieldName = 'ID'
      Size = 0
      RoundByScale = True
    end
    object adsOrderDetailsOldPRODUCTID: TFIBBCDField
      FieldName = 'PRODUCTID'
      Size = 0
      RoundByScale = True
    end
    object adsOrderDetailsOldFULLCODE: TFIBBCDField
      FieldName = 'FULLCODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrderDetailsOldSUMORDER: TFIBBCDField
      FieldName = 'SUMORDER'
      Size = 2
      RoundByScale = True
    end
    object adsOrderDetailsOldREQUESTRATIO: TFIBIntegerField
      FieldName = 'REQUESTRATIO'
    end
    object adsOrderDetailsOldORDERCOST: TFIBBCDField
      FieldName = 'ORDERCOST'
      Size = 2
      RoundByScale = True
    end
    object adsOrderDetailsOldMINORDERCOUNT: TFIBIntegerField
      FieldName = 'MINORDERCOUNT'
    end
    object adsOrderDetailsOldCryptPRICE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPRICE'
      Calculated = True
    end
    object adsOrderDetailsOldCryptSUMORDER: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptSUMORDER'
      Calculated = True
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
  object adsRetailMarginsOld: TpFIBDataSet
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
    Database = MainConnectionOld
    AutoCommit = True
    Left = 496
    Top = 192
    oCacheCalcFields = True
    object adsRetailMarginsOldID: TFIBBCDField
      FieldName = 'ID'
      Size = 0
      RoundByScale = True
    end
    object adsRetailMarginsOldLEFTLIMIT: TFIBBCDField
      FieldName = 'LEFTLIMIT'
      Required = True
      OnChange = adsRetailMarginsOldLEFTLIMITChange
      DisplayFormat = '0.00;;'
      Size = 4
      RoundByScale = True
    end
    object adsRetailMarginsOldRIGHTLIMIT: TFIBBCDField
      FieldName = 'RIGHTLIMIT'
      Required = True
      OnChange = adsRetailMarginsOldLEFTLIMITChange
      DisplayFormat = '0.00;;'
      Size = 4
      RoundByScale = True
    end
    object adsRetailMarginsOldRETAIL: TFIBIntegerField
      FieldName = 'RETAIL'
      Required = True
      MaxValue = 100
    end
  end
  object dsRetailMargins: TDataSource
    DataSet = adsRetailMargins
    Left = 528
    Top = 192
  end
  object adsSumOrdersOldForDelete: TpFIBDataSet
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
    Left = 576
    Top = 536
    oTrimCharFields = False
    oCacheCalcFields = True
    object adsSumOrdersOldForDeleteCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSumOrdersOldForDeleteCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsSumOrdersOldForDeleteORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsSumOrdersOldForDeleteCryptPRICE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPRICE'
      Calculated = True
    end
    object adsSumOrdersOldForDeleteSumOrders: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrders'
      Calculated = True
    end
    object adsSumOrdersOldForDeletePRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 60
      EmptyStrToNull = True
    end
  end
  object adsPricesOld: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    PRICECODE,'
      '    PRICENAME,'
      '    DATEPRICE,'
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
      '    PRICESIZE,'
      '    INJOB'
      'FROM'
      '    PRICESSHOW(:ACLIENTID,'
      '    :TIMEZONEBIAS) ')
    Database = MainConnectionOld
    AutoCommit = True
    Left = 408
    Top = 192
    oCacheCalcFields = True
    object adsPricesOldPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsPricesOldPRICENAME: TFIBStringField
      FieldName = 'PRICENAME'
      Size = 70
      EmptyStrToNull = True
    end
    object adsPricesOldDATEPRICE: TFIBDateTimeField
      FieldName = 'DATEPRICE'
    end
    object adsPricesOldMINREQ: TFIBIntegerField
      FieldName = 'MINREQ'
    end
    object adsPricesOldENABLED: TFIBIntegerField
      FieldName = 'ENABLED'
    end
    object adsPricesOldPRICEINFO: TFIBMemoField
      FieldName = 'PRICEINFO'
      BlobType = ftMemo
      Size = 8
    end
    object adsPricesOldFIRMCODE: TFIBBCDField
      FieldName = 'FIRMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsPricesOldFULLNAME: TFIBStringField
      FieldName = 'FULLNAME'
      Size = 40
      EmptyStrToNull = True
    end
    object adsPricesOldSTORAGE: TFIBIntegerField
      FieldName = 'STORAGE'
    end
    object adsPricesOldADMINMAIL: TFIBStringField
      FieldName = 'ADMINMAIL'
      Size = 50
      EmptyStrToNull = True
    end
    object adsPricesOldSUPPORTPHONE: TFIBStringField
      FieldName = 'SUPPORTPHONE'
      EmptyStrToNull = True
    end
    object adsPricesOldCONTACTINFO: TFIBMemoField
      FieldName = 'CONTACTINFO'
      BlobType = ftMemo
      Size = 8
    end
    object adsPricesOldOPERATIVEINFO: TFIBMemoField
      FieldName = 'OPERATIVEINFO'
      BlobType = ftMemo
      Size = 8
    end
    object adsPricesOldREGIONCODE: TFIBBCDField
      FieldName = 'REGIONCODE'
      Size = 0
      RoundByScale = True
    end
    object adsPricesOldREGIONNAME: TFIBStringField
      FieldName = 'REGIONNAME'
      Size = 25
      EmptyStrToNull = True
    end
    object adsPricesOldPOSITIONS: TFIBIntegerField
      FieldName = 'POSITIONS'
    end
    object adsPricesOldPRICESIZE: TFIBIntegerField
      FieldName = 'PRICESIZE'
    end
    object adsPricesOldINJOB: TFIBIntegerField
      FieldName = 'INJOB'
    end
  end
  object adsAllOrdersOld: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE ORDERS'
      'SET '
      '    PRICE = :PRICE,'
      '    CODE = :CODE,'
      '    CODECR = :CODECR'
      'WHERE'
      '    ID = :OLD_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    ORDERS.ID,'
      '    ORDERS.ORDERID,'
      '    ORDERS.CLIENTID,'
      '    ORDERS.COREID,'
      '    ORDERS.PRODUCTID,'
      '    ORDERS.CODEFIRMCR,'
      '    ORDERS.SYNONYMCODE,'
      '    ORDERS.SYNONYMFIRMCRCODE,'
      '    ORDERS.CODE,'
      '    ORDERS.CODECR,'
      '    ORDERS.SYNONYMNAME,'
      '    ORDERS.SYNONYMFIRM,'
      '    ORDERS.PRICE,'
      '    ORDERS.AWAIT,'
      '    ORDERS.JUNK,'
      '    ORDERS.ORDERCOUNT'
      'FROM'
      '    ORDERS,'
      '    ordersh'
      'where'
      '    ordersh.orderid = orders.orderid'
      'and ordersh.closed <> 1')
    Database = MainConnectionOld
    Left = 648
    Top = 48
    oTrimCharFields = False
    oCacheCalcFields = True
    oRefreshAfterPost = False
    object adsAllOrdersOldID: TFIBBCDField
      FieldName = 'ID'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersOldORDERID: TFIBBCDField
      FieldName = 'ORDERID'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersOldCLIENTID: TFIBBCDField
      FieldName = 'CLIENTID'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersOldCOREID: TFIBBCDField
      FieldName = 'COREID'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersOldCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersOldSYNONYMCODE: TFIBBCDField
      FieldName = 'SYNONYMCODE'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersOldSYNONYMFIRMCRCODE: TFIBBCDField
      FieldName = 'SYNONYMFIRMCRCODE'
      Size = 0
      RoundByScale = True
    end
    object adsAllOrdersOldCODE: TFIBStringField
      FieldName = 'CODE'
      Size = 84
      EmptyStrToNull = True
    end
    object adsAllOrdersOldCODECR: TFIBStringField
      FieldName = 'CODECR'
      Size = 84
      EmptyStrToNull = True
    end
    object adsAllOrdersOldSYNONYMNAME: TFIBStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
      EmptyStrToNull = True
    end
    object adsAllOrdersOldSYNONYMFIRM: TFIBStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
      EmptyStrToNull = True
    end
    object adsAllOrdersOldAWAIT: TFIBBooleanField
      FieldName = 'AWAIT'
    end
    object adsAllOrdersOldJUNK: TFIBBooleanField
      FieldName = 'JUNK'
    end
    object adsAllOrdersOldORDERCOUNT: TFIBIntegerField
      FieldName = 'ORDERCOUNT'
    end
    object adsAllOrdersOldCryptPRICE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptPRICE'
      Calculated = True
    end
    object adsAllOrdersOldPRICE: TFIBStringField
      FieldName = 'PRICE'
      Size = 60
      EmptyStrToNull = True
    end
    object adsAllOrdersOldPRODUCTID: TFIBBCDField
      FieldName = 'PRODUCTID'
      Size = 0
      RoundByScale = True
    end
  end
  object adsOrderCoreOld: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT * '
      'FROM '
      
        'CORESHOWBYFORM(:ACLIENTID, :TIMEZONEBIAS, :PARENTCODE, :SHOWREGI' +
        'STER, :REGISTERID)')
    Database = MainConnectionOld
    Left = 232
    Top = 344
    oTrimCharFields = False
    oCacheCalcFields = True
    object adsOrderCoreOldPRICECODE: TFIBBCDField
      FieldName = 'PRICECODE'
      Size = 0
      RoundByScale = True
    end
    object adsOrderCoreOldBASECOST: TFIBStringField
      FieldName = 'BASECOST'
      Size = 60
      EmptyStrToNull = True
    end
    object adsOrderCoreOldPRICEENABLED: TFIBIntegerField
      FieldName = 'PRICEENABLED'
    end
    object adsOrderCoreOldJUNK: TFIBIntegerField
      FieldName = 'JUNK'
    end
    object adsOrderCoreOldCODEFIRMCR: TFIBBCDField
      FieldName = 'CODEFIRMCR'
      Size = 0
      RoundByScale = True
    end
    object adsOrderCoreOldPRODUCTID: TFIBBCDField
      FieldName = 'PRODUCTID'
      Size = 0
      RoundByScale = True
    end
    object adsOrderCoreOldCryptBASECOST: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'CryptBASECOST'
      Calculated = True
    end
  end
  object adtReceivedDocsOld: TpFIBDataSet
    UpdateSQL.Strings = (
      'UPDATE RECEIVEDDOCS'
      'SET '
      '    FILENAME = :FILENAME,'
      '    FILEDATETIME = :FILEDATETIME'
      'WHERE'
      '    ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    RECEIVEDDOCS'
      'WHERE'
      '        ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO RECEIVEDDOCS('
      '    FILENAME,'
      '    FILEDATETIME'
      ')'
      'VALUES('
      '    :FILENAME,'
      '    :FILEDATETIME'
      ')')
    RefreshSQL.Strings = (
      'select * from Receiveddocs'
      ''
      ' WHERE '
      '        RECEIVEDDOCS.ID = :OLD_ID'
      '    ')
    SelectSQL.Strings = (
      'select * from Receiveddocs'
      'order by filedatetime desc')
    Database = MainConnectionOld
    AutoCommit = True
    Left = 312
    Top = 192
    oTrimCharFields = False
    oCacheCalcFields = True
  end
  object frdsReportOrder: TfrDBDataSet
    OpenDataSource = False
    Left = 128
    Top = 544
  end
  object MyConnection: TMyConnection
    Database = 'analitf'
    Options.Charset = 'cp1251'
    Options.KeepDesignConnected = False
    Username = 'root'
    Server = 'localhost'
    Connected = True
    AfterConnect = MainConnectionOldAfterConnect
    LoginPrompt = False
    Left = 32
    Top = 104
  end
  object adtParams: TMyTable
    TableName = 'params'
    Connection = MyConnection
    Left = 48
    Top = 232
  end
  object adtClients: TMyQuery
    Connection = MyConnection
    SQL.Strings = (
      'SELECT'
      ' CLIENTID,'
      ' NAME,'
      ' REGIONCODE,'
      ' EXCESS,'
      ' DELTAMODE,'
      ' MAXUSERS,'
      ' REQMASK,'
      ' TECHSUPPORT,'
      ' CALCULATELEADER,'
      ' ONLYLEADERS'
      'FROM'
      ' CLIENTS')
    AfterOpen = adtClientsOldAfterOpen
    Left = 216
    Top = 208
    object adtClientsCLIENTID: TLargeintField
      FieldName = 'CLIENTID'
    end
    object adtClientsNAME: TStringField
      FieldName = 'NAME'
      Size = 50
    end
    object adtClientsREGIONCODE: TLargeintField
      FieldName = 'REGIONCODE'
    end
    object adtClientsEXCESS: TIntegerField
      FieldName = 'EXCESS'
    end
    object adtClientsDELTAMODE: TSmallintField
      FieldName = 'DELTAMODE'
    end
    object adtClientsMAXUSERS: TIntegerField
      FieldName = 'MAXUSERS'
    end
    object adtClientsREQMASK: TLargeintField
      FieldName = 'REQMASK'
    end
    object adtClientsTECHSUPPORT: TStringField
      FieldName = 'TECHSUPPORT'
      Size = 255
    end
    object adtClientsCALCULATELEADER: TBooleanField
      FieldName = 'CALCULATELEADER'
    end
    object adtClientsONLYLEADERS: TBooleanField
      FieldName = 'ONLYLEADERS'
    end
  end
  object adsRetailMargins: TMyQuery
    Connection = MyConnection
    SQL.Strings = (
      'SELECT'
      '    ID,'
      '    LEFTLIMIT,'
      '    RIGHTLIMIT,'
      '    RETAIL'
      'FROM'
      '    RETAILMARGINS'
      'order by LEFTLIMIT')
    CachedUpdates = True
    Left = 496
    Top = 232
    object adsRetailMarginsID: TLargeintField
      FieldName = 'ID'
    end
    object adsRetailMarginsLEFTLIMIT: TFloatField
      FieldName = 'LEFTLIMIT'
    end
    object adsRetailMarginsRIGHTLIMIT: TFloatField
      FieldName = 'RIGHTLIMIT'
    end
    object adsRetailMarginsRETAIL: TIntegerField
      FieldName = 'RETAIL'
    end
  end
  object MyEmbConnection: TMyEmbConnection
    Database = 'AnalitF'
    Options.Charset = 'cp1251'
    Options.KeepDesignConnected = False
    Params.Strings = (
      '--basedir=.'
      '--datadir=data'
      '--skip-innodb'
      '--character_set_server=cp1251'
      '--character_set_filesystem=cp1251'
      '--key_buffer_size=32M'
      '--max_allowed_packet=16777216')
    Username = 'root'
    AfterConnect = MainConnectionOldAfterConnect
    LoginPrompt = False
    Left = 128
    Top = 104
  end
  object adcUpdate: TMyQuery
    Connection = MyConnection
    Left = 488
    Top = 72
  end
  object MyServerControl: TMyServerControl
    Connection = MyConnection
    Left = 256
    Top = 112
  end
  object MySQLMonitor: TMySQLMonitor
    TraceFlags = [tfError, tfService]
    OnSQL = MySQLMonitorSQL
    Left = 376
    Top = 8
  end
  object adtReceivedDocs: TMyQuery
    SQLInsert.Strings = (
      'INSERT INTO Receiveddocs'
      '  (FILENAME, FILEDATETIME)'
      'VALUES'
      '  (:FILENAME, :FILEDATETIME)')
    SQLDelete.Strings = (
      'DELETE FROM Receiveddocs'
      'WHERE'
      '  ID = :Old_ID')
    SQLUpdate.Strings = (
      'UPDATE Receiveddocs'
      'SET'
      '  FILENAME = :FILENAME, FILEDATETIME = :FILEDATETIME'
      'WHERE'
      '  ID = :Old_ID')
    SQLRefresh.Strings = (
      
        'SELECT Receiveddocs.FILENAME, Receiveddocs.FILEDATETIME FROM Rec' +
        'eiveddocs'
      'WHERE'
      '  Receiveddocs.ID = :ID')
    Connection = MyConnection
    SQL.Strings = (
      'select * from Receiveddocs'
      'order by filedatetime desc')
    Left = 312
    Top = 232
  end
  object adsPrices: TMyQuery
    Connection = MyConnection
    SQL.Strings = (
      'SELECT '
      '  pricesshow.*,'
      
        '  pricesshow.UniversalDatePrice - interval :TimeZoneBias minute ' +
        'AS DatePrice,'
      '  count(OrdersList.ID) as Positions,'
      
        '  ifnull(Sum(OrdersList.Price * OrdersList.OrderCount), 0) as Su' +
        'mOrder,'
      '/*'
      '('
      '  SELECT'
      '    Count(*)'
      '  FROM'
      '    OrdersHead'
      
        '    INNER JOIN OrdersList ON OrdersList.OrderId=OrdersHead.Order' +
        'Id'
      '  WHERE OrdersHead.ClientId   = :AClientId'
      '     AND OrdersHead.PriceCode = pricesshow.PriceCode'
      '     AND OrdersHead.RegionCode = pricesshow.RegionCode'
      '     AND OrdersHead.Closed <> 1'
      '     AND OrdersList.OrderCount > 0'
      ') as Positions,'
      '*/'
      '  ('
      '    select'
      '      ifnull(Sum(OrdersList.Price * OrdersList.OrderCount), 0)'
      '    from'
      '      OrdersHead'
      
        '      INNER JOIN OrdersList ON OrdersList.OrderId=OrdersHead.Ord' +
        'erId'
      '    WHERE OrdersHead.ClientId = :AClientId'
      '       AND OrdersHead.PriceCode = pricesshow.PriceCode'
      '       AND OrdersHead.RegionCode = pricesshow.RegionCode'
      
        '       and OrdersHead.senddate > curdate() + interval (1-day(cur' +
        'date())) day'
      '       AND OrdersHead.Closed = 1'
      '       AND OrdersHead.send = 1'
      '       AND OrdersList.OrderCount>0'
      '  ) as sumbycurrentmonth'
      'FROM '
      '  pricesshow'
      '  left join Ordershead on '
      '        Ordershead.Pricecode = pricesshow.PriceCode '
      '    and Ordershead.Regioncode = pricesshow.RegionCode'
      '    and OrdersHead.ClientId   = :AClientId'
      '    and OrdersHead.Closed <> 1'
      '  left join OrdersList on '
      '        OrdersList.ORDERID = Ordershead.ORDERID'
      '    and OrdersList.OrderCount > 0'
      'group by pricesshow.PriceCode, pricesshow.RegionCode')
    Left = 408
    Top = 232
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TimeZoneBias'
      end
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end>
    object adsPricesPriceCode: TLargeintField
      FieldName = 'PriceCode'
    end
    object adsPricesPriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsPricesUniversalDatePrice: TDateTimeField
      FieldName = 'UniversalDatePrice'
    end
    object adsPricesMinReq: TIntegerField
      FieldName = 'MinReq'
    end
    object adsPricesEnabled: TBooleanField
      FieldName = 'Enabled'
    end
    object adsPricesPriceInfo: TMemoField
      FieldName = 'PriceInfo'
      BlobType = ftMemo
    end
    object adsPricesFirmCode: TLargeintField
      FieldName = 'FirmCode'
    end
    object adsPricesFullName: TStringField
      FieldName = 'FullName'
      Size = 40
    end
    object adsPricesStorage: TBooleanField
      FieldName = 'Storage'
    end
    object adsPricesAdminMail: TStringField
      FieldName = 'AdminMail'
      Size = 50
    end
    object adsPricesSupportPhone: TStringField
      FieldName = 'SupportPhone'
    end
    object adsPricesContactInfo: TMemoField
      FieldName = 'ContactInfo'
      BlobType = ftMemo
    end
    object adsPricesOperativeInfo: TMemoField
      FieldName = 'OperativeInfo'
      BlobType = ftMemo
    end
    object adsPricesRegionCode: TLargeintField
      FieldName = 'RegionCode'
    end
    object adsPricesRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsPricespricesize: TIntegerField
      FieldName = 'pricesize'
    end
    object adsPricesINJOB: TBooleanField
      FieldName = 'INJOB'
    end
    object adsPricesCONTROLMINREQ: TBooleanField
      FieldName = 'CONTROLMINREQ'
    end
    object adsPricesDatePrice: TDateTimeField
      FieldName = 'DatePrice'
    end
    object adsPricesPositions: TLargeintField
      FieldName = 'Positions'
    end
    object adsPricessumbycurrentmonth: TFloatField
      FieldName = 'sumbycurrentmonth'
    end
    object adsPricesSumOrder: TFloatField
      FieldName = 'SumOrder'
    end
  end
  object adsQueryValue: TMyQuery
    Connection = MyConnection
    Left = 568
    Top = 48
  end
  object adsAllOrders: TMyQuery
    SQLUpdate.Strings = (
      'UPDATE ORDERS'
      'SET '
      '    PRICE = :PRICE,'
      '    CODE = :CODE,'
      '    CODECR = :CODECR'
      'WHERE'
      '    ID = :OLD_ID')
    Connection = MyConnection
    SQL.Strings = (
      'SELECT'
      '    OrdersList.ID,'
      '    OrdersList.ORDERID,'
      '    OrdersList.CLIENTID,'
      '    OrdersList.COREID,'
      '    OrdersList.PRODUCTID,'
      '    OrdersList.CODEFIRMCR,'
      '    OrdersList.SYNONYMCODE,'
      '    OrdersList.SYNONYMFIRMCRCODE,'
      '    OrdersList.CODE,'
      '    OrdersList.CODECR,'
      '    OrdersList.SYNONYMNAME,'
      '    OrdersList.SYNONYMFIRM,'
      '    OrdersList.PRICE,'
      '    OrdersList.AWAIT,'
      '    OrdersList.JUNK,'
      '    OrdersList.ORDERCOUNT'
      'FROM'
      '    OrdersList,'
      '    OrdersHead'
      'where'
      '    OrdersHead.orderid = OrdersList.orderid'
      'and OrdersHead.closed <> 1')
    Left = 648
    Top = 72
    object adsAllOrdersID: TLargeintField
      FieldName = 'ID'
    end
    object adsAllOrdersORDERID: TLargeintField
      FieldName = 'ORDERID'
    end
    object adsAllOrdersCLIENTID: TLargeintField
      FieldName = 'CLIENTID'
    end
    object adsAllOrdersCOREID: TLargeintField
      FieldName = 'COREID'
    end
    object adsAllOrdersPRODUCTID: TLargeintField
      FieldName = 'PRODUCTID'
    end
    object adsAllOrdersCODEFIRMCR: TLargeintField
      FieldName = 'CODEFIRMCR'
    end
    object adsAllOrdersSYNONYMCODE: TLargeintField
      FieldName = 'SYNONYMCODE'
    end
    object adsAllOrdersSYNONYMFIRMCRCODE: TLargeintField
      FieldName = 'SYNONYMFIRMCRCODE'
    end
    object adsAllOrdersCODE: TStringField
      FieldName = 'CODE'
      Size = 84
    end
    object adsAllOrdersCODECR: TStringField
      FieldName = 'CODECR'
      Size = 84
    end
    object adsAllOrdersSYNONYMNAME: TStringField
      FieldName = 'SYNONYMNAME'
      Size = 250
    end
    object adsAllOrdersSYNONYMFIRM: TStringField
      FieldName = 'SYNONYMFIRM'
      Size = 250
    end
    object adsAllOrdersPRICE: TStringField
      FieldName = 'PRICE'
      Size = 60
    end
    object adsAllOrdersAWAIT: TBooleanField
      FieldName = 'AWAIT'
    end
    object adsAllOrdersJUNK: TBooleanField
      FieldName = 'JUNK'
    end
    object adsAllOrdersORDERCOUNT: TIntegerField
      FieldName = 'ORDERCOUNT'
    end
  end
  object adsOrderCore: TMyQuery
    Connection = MyConnection
    SQL.Strings = (
      
        '#call CORESHOWBYFORM(:ACLIENTID, :TIMEZONEBIAS, :PARENTCODE, :SH' +
        'OWREGISTER, :REGISTERID)'
      'SELECT '
      '    Core.CoreId,'
      '    Clients.Clientid,'
      '    Core.PriceCode,'
      '    Core.RegionCode,'
      '    Core.productid,'
      '    catalogs.fullcode,'
      '    catalogs.shortcode,'
      '    Core.CodeFirmCr,'
      '    Core.SynonymCode,'
      '    Core.SynonymFirmCrCode,'
      '    Core.Code,'
      '    Core.CodeCr,'
      '    Core.Period,'
      '    Core.Volume,'
      '    Core.Note,'
      '    Core.Cost,'
      '    Core.Quantity,'
      '    Core.Await,'
      '    Core.Junk,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      
        '    ifnull(Synonyms.SynonymName, concat(catalogs.name, '#39' '#39', cata' +
        'logs.form)) as SynonymName,'
      '    SynonymFirmCr.SynonymName AS SynonymFirm,'
      
        '    if(PricesData.DatePrice IS NOT NULL, PricesData.DatePrice + ' +
        'interval -:timezonebias minute, null) AS DatePrice,'
      '    PricesData.PriceName,'
      '    PRD.Enabled AS PriceEnabled,'
      '    Providers.FirmCode AS FirmCode,'
      '    PRD.Storage,'
      '    Regions.RegionName,'
      '    osbc.CoreId AS OrdersCoreId,'
      '    osbc.OrderId AS OrdersOrderId,'
      '    osbc.ClientId AS OrdersClientId,'
      '    catalogs.fullcode AS OrdersFullCode,'
      '    osbc.CodeFirmCr AS OrdersCodeFirmCr,'
      '    osbc.SynonymCode AS OrdersSynonymCode,'
      '    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,'
      '    osbc.Code AS OrdersCode,'
      '    osbc.CodeCr AS OrdersCodeCr,'
      '    osbc.OrderCount,'
      '    osbc.SynonymName AS OrdersSynonym,'
      '    osbc.SynonymFirm AS OrdersSynonymFirm,'
      '    osbc.Price AS OrdersPrice,'
      '    osbc.Price*osbc.OrderCount AS SumOrder,'
      '    osbc.Junk AS OrdersJunk,'
      '    osbc.Await AS OrdersAwait,'
      '    OrdersHead.OrderId AS OrdersHOrderId,'
      '    OrdersHead.ClientId AS OrdersHClientId,'
      '    OrdersHead.PriceCode AS OrdersHPriceCode,'
      '    OrdersHead.RegionCode AS OrdersHRegionCode,'
      '    OrdersHead.PriceName AS OrdersHPriceName,'
      '    OrdersHead.RegionName AS OrdersHRegionName'
      'FROM'
      '    Catalogs'
      
        '    inner join products on products.catalogid = catalogs.fullcod' +
        'e'
      '    inner join Clients on Clients.Clientid = :AClientID'
      '    left JOIN Core ON Core.productid = products.productid'
      '    left join Synonyms on Core.SynonymCode=Synonyms.SynonymCode'
      
        '    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFir' +
        'mCr.SynonymFirmCrCode'
      '    LEFT JOIN PricesData ON Core.PriceCode=PricesData.PriceCode'
      
        '    LEFT JOIN PricesRegionalData PRD ON (Core.RegionCode=PRD.Reg' +
        'ionCode)'
      '        AND (Core.PriceCode=PRD.PriceCode)'
      
        '    LEFT JOIN Providers ON PricesData.FirmCode=Providers.FirmCod' +
        'e'
      '    LEFT JOIN Regions ON Core.RegionCode=Regions.RegionCode'
      
        '    LEFT JOIN OrdersList osbc ON osbc.clientid = :aclientid and ' +
        'osbc.CoreId = Core.CoreId'
      '    LEFT JOIN OrdersHead ON OrdersHead.OrderId = osbc.OrderId'
      'WHERE '
      '    (Catalogs.FullCode = :ParentCode)'
      'and (Core.coreid is not null)'
      'And ((:ShowRegister = 1) Or (Providers.FirmCode <> :RegisterId))')
    Left = 232
    Top = 384
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TIMEZONEBIAS'
      end
      item
        DataType = ftUnknown
        Name = 'ACLIENTID'
      end
      item
        DataType = ftUnknown
        Name = 'aclientid'
      end
      item
        DataType = ftUnknown
        Name = 'PARENTCODE'
      end
      item
        DataType = ftUnknown
        Name = 'SHOWREGISTER'
      end
      item
        DataType = ftUnknown
        Name = 'REGISTERID'
      end>
    object adsOrderCorePriceCode: TLargeintField
      FieldName = 'PriceCode'
    end
    object adsOrderCorePriceEnabled: TBooleanField
      FieldName = 'PriceEnabled'
    end
    object adsOrderCoreJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsOrderCoreCodeFirmCr: TLargeintField
      FieldName = 'CodeFirmCr'
    end
    object adsOrderCoreproductid: TLargeintField
      FieldName = 'productid'
    end
    object adsOrderCoreCost: TFloatField
      FieldName = 'Cost'
    end
  end
  object adsOrderDetails: TMyQuery
    SQLUpdate.Strings = (
      'update ordersList'
      'set'
      '  coreid = :coreid'
      'where'
      '  id = :old_id')
    Connection = MyConnection
    SQL.Strings = (
      'SELECT '
      '    OrdersList.id,'
      '    OrdersList.OrderId,'
      '    OrdersList.ClientId,'
      '    OrdersList.CoreId,'
      '    products.catalogid as fullcode,'
      '    OrdersList.productid,'
      '    OrdersList.codefirmcr,'
      '    OrdersList.synonymcode,'
      '    OrdersList.synonymfirmcrcode,'
      '    OrdersList.code,'
      '    OrdersList.codecr,'
      '    OrdersList.synonymname,'
      '    OrdersList.synonymfirm,'
      '    OrdersList.price,'
      '    OrdersList.await,'
      '    OrdersList.junk,'
      '    OrdersList.ordercount,'
      '    OrdersList.Price*OrdersList.OrderCount AS SumOrder,'
      '    OrdersList.RequestRatio,'
      '    OrdersList.OrderCost,'
      '    OrdersList.MinOrderCount'
      'FROM '
      '  OrdersList'
      
        '  left join products on products.productid = OrdersList.producti' +
        'd'
      'WHERE '
      '    (OrdersList.OrderId=:AOrderId) '
      'AND (OrdersList.OrderCount>0)'
      'ORDER BY SynonymName, SynonymFirm')
    CachedUpdates = True
    Left = 144
    Top = 384
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'AOrderId'
      end>
    object adsOrderDetailsid: TLargeintField
      FieldName = 'id'
    end
    object adsOrderDetailsOrderId: TLargeintField
      FieldName = 'OrderId'
    end
    object adsOrderDetailsClientId: TLargeintField
      FieldName = 'ClientId'
    end
    object adsOrderDetailsCoreId: TLargeintField
      FieldName = 'CoreId'
    end
    object adsOrderDetailsfullcode: TLargeintField
      FieldName = 'fullcode'
    end
    object adsOrderDetailsproductid: TLargeintField
      FieldName = 'productid'
    end
    object adsOrderDetailscodefirmcr: TLargeintField
      FieldName = 'codefirmcr'
    end
    object adsOrderDetailssynonymcode: TLargeintField
      FieldName = 'synonymcode'
    end
    object adsOrderDetailssynonymfirmcrcode: TLargeintField
      FieldName = 'synonymfirmcrcode'
    end
    object adsOrderDetailscode: TStringField
      FieldName = 'code'
      Size = 84
    end
    object adsOrderDetailscodecr: TStringField
      FieldName = 'codecr'
      Size = 84
    end
    object adsOrderDetailssynonymname: TStringField
      FieldName = 'synonymname'
      Size = 250
    end
    object adsOrderDetailssynonymfirm: TStringField
      FieldName = 'synonymfirm'
      Size = 250
    end
    object adsOrderDetailsawait: TBooleanField
      FieldName = 'await'
    end
    object adsOrderDetailsjunk: TBooleanField
      FieldName = 'junk'
    end
    object adsOrderDetailsordercount: TIntegerField
      FieldName = 'ordercount'
    end
    object adsOrderDetailsSumOrder: TFloatField
      FieldName = 'SumOrder'
    end
    object adsOrderDetailsRequestRatio: TIntegerField
      FieldName = 'RequestRatio'
    end
    object adsOrderDetailsOrderCost: TFloatField
      FieldName = 'OrderCost'
    end
    object adsOrderDetailsMinOrderCount: TIntegerField
      FieldName = 'MinOrderCount'
    end
    object adsOrderDetailsprice: TFloatField
      FieldName = 'price'
    end
  end
  object adsOrdersHeaders: TMyQuery
    SQLUpdate.Strings = (
      'update ordershead'
      'set'
      '  SERVERORDERID = :SERVERORDERID,'
      '  SENDDATE = :SENDDATE,'
      '  CLOSED = :CLOSED,'
      '  SEND = :SEND'
      'where'
      '  orderid = :old_orderid')
    Connection = MyConnection
    SQL.Strings = (
      '#ORDERSHSHOW'
      'SELECT'
      '    OrdersHead.OrderId,'
      '    OrdersHead.ClientID,'
      '    OrdersHead.ServerOrderId,'
      
        '    PricesData.DatePrice - interval :timezonebias minute AS Date' +
        'Price,'
      '    OrdersHead.PriceCode,'
      '    OrdersHead.RegionCode,'
      '    OrdersHead.OrderDate,'
      '    OrdersHead.SendDate,'
      '    OrdersHead.Closed,'
      '    OrdersHead.Send,'
      '    OrdersHead.PriceName,'
      '    OrdersHead.RegionName,'
      '    RegionalData.SupportPhone,'
      '    OrdersHead.MessageTo,'
      '    OrdersHead.Comments,'
      '    pricesregionaldata.minreq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(OrdersList.Id) as Positions,'
      
        '    ifnull(Sum(OrdersList.Price * OrdersList.OrderCount), 0) as ' +
        'SumOrder,'
      '     ('
      '  select'
      '    ifnull(Sum(OrdersList.Price * OrdersList.OrderCount), 0)'
      '  from'
      '    OrdersHead header'
      
        '    INNER JOIN OrdersList ON (OrdersList.OrderId = header.OrderI' +
        'd)'
      '  WHERE OrdersHead.ClientId = :AClientId'
      '     AND header.PriceCode = OrdersHead.PriceCode'
      '     AND header.RegionCode = OrdersHead.RegionCode'
      
        '     and header.senddate > curdate() + interval (1-day(curdate()' +
        ')) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND OrdersList.OrderCount>0'
      ') as sumbycurrentmonth'
      'FROM'
      '   OrdersHead'
      '   inner join OrdersList on '
      '         (OrdersList.OrderId = OrdersHead.OrderId) '
      '     and (OrdersList.OrderCount > 0)'
      '   LEFT JOIN PricesData ON '
      '         (OrdersHead.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      '         (pricesregionaldata.PriceCode = OrdersHead.PriceCode) '
      '     and pricesregionaldata.regioncode = OrdersHead.regioncode'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=OrdersHead.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      'WHERE'
      '    (OrdersHead.ClientId = :AClientId)'
      'and (OrdersHead.Closed = :AClosed)'
      
        'and ((:AClosed = 1) or ((:AClosed = 0) and (PricesData.PriceCode' +
        ' is not null) and (RegionalData.RegionCode is not null) and (pri' +
        'cesregionaldata.PriceCode is not null)))'
      'and (OrdersHead.Send = :ASend)'
      'group by OrdersHead.OrderId'
      'having count(OrdersList.Id) > 0')
    Left = 48
    Top = 384
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'timezonebias'
      end
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end
      item
        DataType = ftUnknown
        Name = 'AClientId'
      end
      item
        DataType = ftUnknown
        Name = 'AClosed'
      end
      item
        DataType = ftUnknown
        Name = 'AClosed'
      end
      item
        DataType = ftUnknown
        Name = 'AClosed'
      end
      item
        DataType = ftUnknown
        Name = 'ASend'
      end>
  end
end
