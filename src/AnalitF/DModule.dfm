object DM: TDM
  OldCreateOrder = True
  OnCreate = DMCreate
  Left = 421
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
    Left = 168
    Top = 224
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
  object frdsReportOrder: TfrDBDataSet
    OpenDataSource = False
    Left = 128
    Top = 544
  end
  object MyConnection: TMyConnection
    Options.Charset = 'cp1251'
    Options.KeepDesignConnected = False
    Username = 'root'
    Server = 'localhost'
    AfterConnect = MainConnectionOldAfterConnect
    LoginPrompt = False
    Left = 32
    Top = 104
  end
  object adtParams: TMyTable
    TableName = 'params'
    Connection = MyConnection
    Filter = 'id = 0'
    AfterPost = adtParamsAfterPost
    Left = 48
    Top = 232
  end
  object adtClients: TMyQuery
    SQLUpdate.Strings = (
      'UPDATE ClientSettings'
      'SET'
      '  ONLYLEADERS = :ONLYLEADERS,'
      '  Address = :Address,'
      '  Director = :Director,'
      '  DeputyDirector = :DeputyDirector,'
      '  Accountant = :Accountant,'
      '  MethodOfTaxation = :MethodOfTaxation,'
      '  CalculateWithNDS = :CalculateWithNDS,'
      '  Name = :EditName'
      'WHERE'
      '  CLIENTID = :Old_CLIENTID')
    SQLRefresh.Strings = (
      'SELECT'
      ' CLIENTS.CLIENTID,'
      ' CLIENTS.NAME,'
      ' CLIENTS.REGIONCODE,'
      ' CLIENTS.EXCESS,'
      ' CLIENTS.DELTAMODE,'
      ' CLIENTS.MAXUSERS,'
      ' CLIENTS.REQMASK,'
      ' CLIENTS.CALCULATELEADER,'
      ' CLIENTS.AllowDelayOfPayment,'
      ' CLIENTS.SelfAddressId, '
      ' ClientSettings.ONLYLEADERS,'
      ' ClientSettings.Address,'
      ' ClientSettings.Director,'
      ' ClientSettings.DeputyDirector,'
      ' ClientSettings.Accountant,'
      ' ClientSettings.MethodOfTaxation,'
      ' ClientSettings.CalculateWithNDS,'
      ' ClientSettings.Name as EditName'
      'FROM'
      ' CLIENTS,'
      ' ClientSettings'
      'where'
      '    (CLIENTS.CLIENTID = :CLIENTID)'
      'and (ClientSettings.ClientId = CLIENTS.ClientId)')
    Connection = MyConnection
    SQL.Strings = (
      'SELECT'
      ' CLIENTS.CLIENTID,'
      ' CLIENTS.NAME,'
      ' CLIENTS.REGIONCODE,'
      ' CLIENTS.EXCESS,'
      ' CLIENTS.DELTAMODE,'
      ' CLIENTS.MAXUSERS,'
      ' CLIENTS.REQMASK,'
      ' CLIENTS.CALCULATELEADER,'
      ' CLIENTS.AllowDelayOfPayment,'
      ' CLIENTS.SelfAddressId,'
      ' ClientSettings.ONLYLEADERS,'
      ' ClientSettings.Address,'
      ' ClientSettings.Director,'
      ' ClientSettings.DeputyDirector,'
      ' ClientSettings.Accountant,'
      ' ClientSettings.MethodOfTaxation,'
      ' ClientSettings.CalculateWithNDS,'
      ' ClientSettings.Name as EditName'
      'FROM'
      ' CLIENTS,'
      ' ClientSettings'
      'where'
      '  (ClientSettings.ClientId = CLIENTS.ClientId)')
    AfterOpen = adtClientsOldAfterOpen
    Left = 168
    Top = 200
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
    object adtClientsCALCULATELEADER: TBooleanField
      FieldName = 'CALCULATELEADER'
    end
    object adtClientsONLYLEADERS: TBooleanField
      FieldName = 'ONLYLEADERS'
    end
    object adtClientsAllowDelayOfPayment: TBooleanField
      FieldName = 'AllowDelayOfPayment'
    end
    object adtClientsSelfAddressId: TStringField
      FieldName = 'SelfAddressId'
    end
    object adtClientsAddress: TStringField
      FieldName = 'Address'
      Size = 255
    end
    object adtClientsDirector: TStringField
      FieldName = 'Director'
      Size = 255
    end
    object adtClientsDeputyDirector: TStringField
      FieldName = 'DeputyDirector'
      Size = 255
    end
    object adtClientsAccountant: TStringField
      FieldName = 'Accountant'
      Size = 255
    end
    object adtClientsMethodOfTaxation: TSmallintField
      FieldName = 'MethodOfTaxation'
    end
    object adtClientsCalculateWithNDS: TBooleanField
      FieldName = 'CalculateWithNDS'
    end
    object adtClientsEditName: TStringField
      FieldName = 'EditName'
      Size = 255
    end
  end
  object MyEmbConnection: TMyEmbConnection
    Options.Charset = 'cp1251'
    Options.KeepDesignConnected = False
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
    Active = False
    TraceFlags = [tfQPrepare, tfQExecute, tfQFetch, tfError, tfStmt, tfConnect, tfTransact, tfBlob, tfService, tfMisc, tfParams]
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
    AfterPost = adtReceivedDocsAfterPost
    Left = 312
    Top = 232
  end
  object adsPrices: TMyQuery
    Connection = MyConnection
    SQL.Strings = (
      'SELECT '
      '  pricesshow.*,'
      '  minreqrules.ControlMinReq,'
      '  minreqrules.MinReq,'
      '  pd.PriceInfo,'
      '  rd.SupportPhone, '
      '  rd.ContactInfo, '
      '  rd.OperativeInfo, '
      '  prd.InJob,'
      
        '  pricesshow.UniversalDatePrice - interval :TimeZoneBias minute ' +
        'AS DatePrice,'
      '  count(CurrentOrderLists.ID) as Positions,'
      
        '  ifnull(Sum(CurrentOrderLists.RealPrice * CurrentOrderLists.Ord' +
        'erCount), 0) as SumOrder,'
      '  # '#1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1086#1074' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
      '  ('
      '    select'
      
        '      ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.O' +
        'rderCount), 0)'
      '    from'
      '      PostedOrderHeads'
      
        '      INNER JOIN PostedOrderLists ON PostedOrderLists.OrderId=Po' +
        'stedOrderHeads.OrderId'
      '    WHERE PostedOrderHeads.ClientId = :ClientId'
      '       AND PostedOrderHeads.PriceCode = pricesshow.PriceCode'
      '       AND PostedOrderHeads.RegionCode = pricesshow.RegionCode'
      
        '       and PostedOrderHeads.senddate > curdate() + interval (1-d' +
        'ay(curdate())) day'
      '       AND PostedOrderHeads.Closed = 1'
      '       AND PostedOrderHeads.send = 1'
      '       AND PostedOrderLists.OrderCount>0'
      '  ) as sumbycurrentmonth'
      'FROM '
      '  pricesshow'
      '  join pricesdata pd on (pd.PriceCode = pricesshow.PriceCode)'
      
        '  join pricesregionaldata prd ON (prd.PRICECODE = pricesshow.Pri' +
        'ceCode) and (prd.RegionCode = pricesshow.RegionCode)'
      
        '  join regionaldata rd on (rd.REGIONCODE = pricesshow.REGIONCODE' +
        ') and (rd.FIRMCODE = pricesshow.FIRMCODE)'
      
        '  left join minreqrules on (minreqrules.ClientId = :ClientId) an' +
        'd (minreqrules.PriceCode = pricesshow.PriceCode) and (minreqrule' +
        's.RegionCode = pricesshow.RegionCode)'
      '  left join CurrentOrderHeads on '
      '        CurrentOrderHeads.Pricecode = pricesshow.PriceCode '
      '    and CurrentOrderHeads.Regioncode = pricesshow.RegionCode'
      '    and CurrentOrderHeads.ClientId   = :ClientId'
      '    and CurrentOrderHeads.Frozen = 0 '
      '    and CurrentOrderHeads.Closed <> 1'
      '  left join CurrentOrderLists on '
      '        CurrentOrderLists.ORDERID = CurrentOrderHeads.ORDERID'
      '    and CurrentOrderLists.OrderCount > 0'
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
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
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
    object adsPricesManagerMail: TStringField
      FieldName = 'ManagerMail'
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
  object adsOrderCore: TMyQuery
    Connection = MyConnection
    SQL.Strings = (
      '#call CORESHOWBYFORM'
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
      '    Core.Cost as RealCost,'
      '  if(dop.DayOfWeek is null,'
      '      Core.Cost,'
      
        '      if(Core.VitallyImportant || ifnull(catalogs.VitallyImporta' +
        'nt, 0),'
      
        '          cast(Core.Cost * (1 + dop.VitallyImportantDelay/100) a' +
        's decimal(18, 2)),'
      
        '          cast(Core.Cost * (1 + dop.OtherDelay/100) as decimal(1' +
        '8, 2))'
      '       )'
      '  )'
      '      as Cost,'
      '    Core.Quantity,'
      '    Core.Await,'
      '    Core.Junk,'
      '    Core.doc,'
      '    Core.registrycost,'
      '    Core.vitallyimportant,'
      '    Core.requestratio,'
      '    core.ordercost,'
      '    core.minordercount,'
      '    core.SupplierPriceMarkup,'
      
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
      '    CurrentOrderHeads.OrderId AS OrdersHOrderId,'
      '    CurrentOrderHeads.ClientId AS OrdersHClientId,'
      '    CurrentOrderHeads.PriceCode AS OrdersHPriceCode,'
      '    CurrentOrderHeads.RegionCode AS OrdersHRegionCode,'
      '    CurrentOrderHeads.PriceName AS OrdersHPriceName,'
      '    CurrentOrderHeads.RegionName AS OrdersHRegionName'
      'FROM'
      '    Catalogs'
      
        '    inner join products on products.catalogid = catalogs.fullcod' +
        'e'
      '    inner join Clients on Clients.Clientid = :ClientID'
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
      
        '    LEFT JOIN CurrentOrderLists osbc ON osbc.clientid = :clienti' +
        'd and osbc.CoreId = Core.CoreId'
      
        '    left join DelayOfPayments dop on (dop.FirmCode = Providers.F' +
        'irmCode) and (dop.DayOfWeek = :DayOfWeek) '
      
        '    LEFT JOIN CurrentOrderHeads ON CurrentOrderHeads.OrderId = o' +
        'sbc.OrderId and CurrentOrderHeads.Frozen = 0 '
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
        Name = 'ClientID'
      end
      item
        DataType = ftUnknown
        Name = 'clientid'
      end
      item
        DataType = ftUnknown
        Name = 'DayOfWeek'
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
    object adsOrderCoreRealCost: TFloatField
      FieldName = 'RealCost'
    end
  end
  object adsOrderDetails: TMyQuery
    SQLUpdate.Strings = (
      'update CurrentOrderLists'
      'set'
      '  coreid = :coreid'
      'where'
      '  id = :old_id')
    Connection = MyConnection
    SQL.Strings = (
      'SELECT '
      '    list.id,'
      '    list.OrderId,'
      '    list.ClientId,'
      '    list.CoreId,'
      '    products.catalogid as fullcode,'
      '    list.productid,'
      '    list.codefirmcr,'
      '    list.synonymcode,'
      '    list.synonymfirmcrcode,'
      '    list.code,'
      '    list.codecr,'
      '    list.synonymname,'
      '    list.synonymfirm,'
      '    list.RealPrice,'
      '    list.price,'
      '    list.await,'
      '    list.junk,'
      '    list.ordercount,'
      '    list.RealPrice*list.OrderCount AS SumOrder,'
      '    list.RequestRatio,'
      '    list.OrderCost,'
      '    list.MinOrderCount,'
      '    list.SupplierPriceMarkup,'
      '    list.CoreQuantity, '
      '    list.ServerCoreID,'
      '    list.Unit, '
      '    list.Volume, '
      '    list.Note, '
      '    list.Period, '
      '    list.Doc, '
      '    list.RegistryCost, '
      '    list.VitallyImportant,'
      '    list.ProducerCost, '
      '    list.NDS,'
      '    list.RetailMarkup,'
      '    list.RetailCost,'
      
        '    (ifnull(catalogs.VitallyImportant, 0) || list.VitallyImporta' +
        'nt) as RetailVitallyImportant'
      'FROM '
      '  CurrentOrderLists list'
      '  left join products on products.productid = list.productid'
      '  left join catalogs on catalogs.fullcode = products.catalogid'
      'WHERE '
      '    (list.OrderId=:OrderId) '
      'AND (list.OrderCount>0)'
      'ORDER BY SynonymName, SynonymFirm')
    CachedUpdates = True
    Left = 144
    Top = 384
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OrderId'
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
    object adsOrderDetailsRealPrice: TFloatField
      FieldName = 'RealPrice'
    end
    object adsOrderDetailsSupplierPriceMarkup: TFloatField
      FieldName = 'SupplierPriceMarkup'
    end
    object adsOrderDetailsCoreQuantity: TStringField
      FieldName = 'CoreQuantity'
      Size = 15
    end
    object adsOrderDetailsServerCoreID: TLargeintField
      FieldName = 'ServerCoreID'
    end
    object adsOrderDetailsUnit: TStringField
      FieldName = 'Unit'
      Size = 15
    end
    object adsOrderDetailsVolume: TStringField
      FieldName = 'Volume'
      Size = 15
    end
    object adsOrderDetailsNote: TStringField
      FieldName = 'Note'
      Size = 50
    end
    object adsOrderDetailsPeriod: TStringField
      FieldName = 'Period'
    end
    object adsOrderDetailsDoc: TStringField
      FieldName = 'Doc'
    end
    object adsOrderDetailsRegistryCost: TFloatField
      FieldName = 'RegistryCost'
    end
    object adsOrderDetailsVitallyImportant: TBooleanField
      FieldName = 'VitallyImportant'
    end
    object adsOrderDetailsProducerCost: TFloatField
      FieldName = 'ProducerCost'
    end
    object adsOrderDetailsNDS: TSmallintField
      FieldName = 'NDS'
    end
    object adsOrderDetailsRetailMarkup: TFloatField
      FieldName = 'RetailMarkup'
    end
    object adsOrderDetailsRetailCost: TFloatField
      FieldName = 'RetailCost'
    end
    object adsOrderDetailsRetailVitallyImportant: TLargeintField
      FieldName = 'RetailVitallyImportant'
    end
  end
  object adsOrdersHeaders: TMyQuery
    SQLUpdate.Strings = (
      'update CurrentOrderHeads'
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
      '    CurrentOrderHeads.OrderId,'
      
        '    ifnull(CurrentOrderHeads.ServerOrderId, CurrentOrderHeads.Or' +
        'derId) as DisplayOrderId,'
      '    CurrentOrderHeads.ClientID,'
      '    CurrentOrderHeads.ServerOrderId,'
      
        '    PricesData.DatePrice - interval :timezonebias minute AS Date' +
        'Price,'
      '    CurrentOrderHeads.PriceCode,'
      '    CurrentOrderHeads.RegionCode,'
      '    CurrentOrderHeads.OrderDate,'
      '    CurrentOrderHeads.SendDate,'
      '    CurrentOrderHeads.Closed,'
      '    CurrentOrderHeads.Send,'
      '    CurrentOrderHeads.PriceName,'
      '    CurrentOrderHeads.RegionName,'
      '    RegionalData.SupportPhone,'
      '    CurrentOrderHeads.MessageTo,'
      '    CurrentOrderHeads.Comments,'
      '    CurrentOrderHeads.DelayOfPayment,'
      '    CurrentOrderHeads.VitallyDelayOfPayment,'
      '    pricesregionaldata.minreq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(CurrentOrderLists.Id) as Positions,'
      
        '    ifnull(Sum(CurrentOrderLists.RealPrice * CurrentOrderLists.O' +
        'rderCount), 0) as SumOrder,'
      '     ('
      '  select'
      
        '    ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.Ord' +
        'erCount), 0)'
      '  from'
      '    PostedOrderHeads header'
      
        '    INNER JOIN PostedOrderLists ON (PostedOrderLists.OrderId = h' +
        'eader.OrderId)'
      '  WHERE header.ClientId = :ClientId'
      '     AND header.PriceCode = CurrentOrderHeads.PriceCode'
      '     AND header.RegionCode = CurrentOrderHeads.RegionCode'
      
        '     and header.senddate > curdate() + interval (1-day(curdate()' +
        ')) day'
      '     AND header.Closed = 1'
      '     AND header.send = 1'
      '     AND PostedOrderLists.OrderCount>0'
      ') as sumbycurrentmonth'
      'FROM'
      '   CurrentOrderHeads'
      '   inner join CurrentOrderLists on '
      
        '         (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId)' +
        ' '
      '     and (CurrentOrderLists.OrderCount > 0)'
      '   LEFT JOIN PricesData ON '
      '         (CurrentOrderHeads.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      
        '         (pricesregionaldata.PriceCode = CurrentOrderHeads.Price' +
        'Code) '
      
        '     and pricesregionaldata.regioncode = CurrentOrderHeads.regio' +
        'ncode'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=CurrentOrderHeads.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      'WHERE'
      '    (CurrentOrderHeads.ClientId = :ClientId)'
      'and (CurrentOrderHeads.Frozen = 0)  '
      'and (CurrentOrderHeads.Closed = :Closed)'
      
        'and ((:Closed = 1) or ((:Closed = 0) and (PricesData.PriceCode i' +
        's not null) and (RegionalData.RegionCode is not null) and (price' +
        'sregionaldata.PriceCode is not null)))'
      'and (CurrentOrderHeads.Send = :Send)'
      'group by CurrentOrderHeads.OrderId'
      'having count(CurrentOrderLists.Id) > 0')
    Left = 48
    Top = 384
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'timezonebias'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'Send'
      end>
  end
  object adsRepareOrders: TMyQuery
    SQLUpdate.Strings = (
      'update'
      '  CurrentOrderLists'
      'set'
      '  COREID = :COREID,'
      '  Price = :PRICE,'
      '  RealPrice = :RealPRICE,'
      '  CodeFirmCr = :CodeFirmCr,'
      '  CODE = :CODE,'
      '  CODECR = :CODECR,'
      '  ORDERCOUNT = :ORDERCOUNT,'
      '  DropReason = :DropReason,'
      '  ServerCost = :ServerCost,'
      '  ServerQuantity = :ServerQuantity,'
      '  SupplierPriceMarkup = :SupplierPriceMarkup,'
      '  CoreQuantity = :CoreQuantity,'
      '  ServerCoreID = :ServerCoreID,'
      '  Unit = :Unit,'
      '  Volume = :Volume,'
      '  Note = :Note,'
      '  Period = :Period,'
      '  Doc = :Doc,'
      '  RegistryCost = :RegistryCost,'
      '  VitallyImportant = :VitallyImportant,'
      '  ProducerCost = :ProducerCost,'
      '  NDS = :NDS'
      'where'
      '  ID = :OLD_ID')
    Connection = MyConnection
    SQL.Strings = (
      'SELECT'
      '  clients.ClientId,'
      '  clients.Name as ClientName, '
      '  CurrentOrderHeads.PriceCode, '
      '  CurrentOrderHeads.RegionCode, '
      '  CurrentOrderHeads.PriceName,'
      '  CurrentOrderLists.Id, '
      '  CurrentOrderLists.ProductId,'
      '  CurrentOrderLists.CodeFirmCr, '
      '  CurrentOrderLists.CoreId, '
      '  CurrentOrderLists.Code, '
      '  CurrentOrderLists.CodeCr, '
      '  CurrentOrderLists.RealPrice, '
      '  CurrentOrderLists.Price, '
      '  CurrentOrderLists.SynonymCode, '
      '  CurrentOrderLists.SynonymFirmCrCode, '
      '  CurrentOrderLists.SynonymName, '
      '  CurrentOrderLists.SynonymFirm, '
      '  CurrentOrderLists.Junk, '
      '  CurrentOrderLists.Await, '
      '  CurrentOrderLists.OrderCount, '
      '  CurrentOrderLists.requestratio,'
      '  CurrentOrderLists.ordercost,'
      '  CurrentOrderLists.minordercount, '
      '  CurrentOrderLists.DropReason, '
      '  CurrentOrderLists.ServerCost, '
      '  CurrentOrderLists.ServerQuantity,'
      '  CurrentOrderLists.SupplierPriceMarkup,'
      '  CurrentOrderLists.CoreQuantity,'
      '  CurrentOrderLists.ServerCoreID,'
      '  CurrentOrderLists.Unit,'
      '  CurrentOrderLists.Volume,'
      '  CurrentOrderLists.Note,'
      '  CurrentOrderLists.Period,'
      '  CurrentOrderLists.Doc,'
      '  CurrentOrderLists.RegistryCost,'
      '  CurrentOrderLists.VitallyImportant,'
      '  CurrentOrderLists.ProducerCost,'
      '  CurrentOrderLists.NDS'
      'FROM '
      '  CurrentOrderLists '
      
        '  INNER JOIN CurrentOrderHeads ON (CurrentOrderHeads.OrderId=Cur' +
        'rentOrderLists.OrderId AND CurrentOrderHeads.Closed = 0 and Curr' +
        'entOrderHeads.Frozen = 0 )'
      
        '  inner join clients    on (clients.clientid = CurrentOrderHeads' +
        '.ClientId)'
      'WHERE '
      '  (CurrentOrderLists.OrderCount>0)')
    Left = 776
    Top = 200
    object adsRepareOrdersId: TLargeintField
      FieldName = 'Id'
    end
    object adsRepareOrdersCoreId: TLargeintField
      FieldName = 'CoreId'
    end
    object adsRepareOrdersPriceCode: TLargeintField
      FieldName = 'PriceCode'
    end
    object adsRepareOrdersRegionCode: TLargeintField
      FieldName = 'RegionCode'
    end
    object adsRepareOrdersCode: TStringField
      FieldName = 'Code'
      Size = 84
    end
    object adsRepareOrdersCodeCr: TStringField
      FieldName = 'CodeCr'
      Size = 84
    end
    object adsRepareOrdersPrice: TFloatField
      FieldName = 'Price'
    end
    object adsRepareOrdersSynonymCode: TLargeintField
      FieldName = 'SynonymCode'
    end
    object adsRepareOrdersSynonymFirmCrCode: TLargeintField
      FieldName = 'SynonymFirmCrCode'
    end
    object adsRepareOrdersSynonymName: TStringField
      FieldName = 'SynonymName'
      Size = 250
    end
    object adsRepareOrdersSynonymFirm: TStringField
      FieldName = 'SynonymFirm'
      Size = 250
    end
    object adsRepareOrdersJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsRepareOrdersAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsRepareOrdersOrderCount: TIntegerField
      FieldName = 'OrderCount'
    end
    object adsRepareOrdersPriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsRepareOrdersrequestratio: TIntegerField
      FieldName = 'requestratio'
    end
    object adsRepareOrdersordercost: TFloatField
      FieldName = 'ordercost'
    end
    object adsRepareOrdersminordercount: TIntegerField
      FieldName = 'minordercount'
    end
    object adsRepareOrdersClientName: TStringField
      FieldName = 'ClientName'
      Size = 50
    end
    object adsRepareOrdersClientId: TLargeintField
      FieldName = 'ClientId'
    end
    object adsRepareOrdersProductId: TLargeintField
      FieldName = 'ProductId'
    end
    object adsRepareOrdersCodeFirmCr: TLargeintField
      FieldName = 'CodeFirmCr'
    end
    object adsRepareOrdersRealPrice: TFloatField
      FieldName = 'RealPrice'
    end
    object adsRepareOrdersDropReason: TSmallintField
      FieldName = 'DropReason'
    end
    object adsRepareOrdersServerCost: TFloatField
      FieldName = 'ServerCost'
    end
    object adsRepareOrdersServerQuantity: TIntegerField
      FieldName = 'ServerQuantity'
    end
    object adsRepareOrdersSupplierPriceMarkup: TFloatField
      FieldName = 'SupplierPriceMarkup'
    end
    object adsRepareOrdersCoreQuantity: TStringField
      FieldName = 'CoreQuantity'
    end
    object adsRepareOrdersServerCoreID: TLargeintField
      FieldName = 'ServerCoreID'
    end
    object adsRepareOrdersUnit: TStringField
      FieldName = 'Unit'
    end
    object adsRepareOrdersVolume: TStringField
      FieldName = 'Volume'
    end
    object adsRepareOrdersNote: TStringField
      FieldName = 'Note'
    end
    object adsRepareOrdersPeriod: TStringField
      FieldName = 'Period'
    end
    object adsRepareOrdersDoc: TStringField
      FieldName = 'Doc'
    end
    object adsRepareOrdersRegistryCost: TFloatField
      FieldName = 'RegistryCost'
    end
    object adsRepareOrdersVitallyImportant: TBooleanField
      FieldName = 'VitallyImportant'
    end
    object adsRepareOrdersProducerCost: TFloatField
      FieldName = 'ProducerCost'
    end
    object adsRepareOrdersNDS: TSmallintField
      FieldName = 'NDS'
    end
  end
  object adsUser: TMyQuery
    Connection = MyConnection
    SQL.Strings = (
      'SELECT'
      '  CLIENTS.CLIENTID,'
      '  CLIENTS.NAME,'
      '  UserInfo.UserId,'
      '  UserInfo.Addition,'
      '  UserInfo.InheritPrices,'
      '  UserInfo.IsFutureClient,'
      '  UserInfo.UseCorrectOrders,'
      '  client.Id as MainClientId,'
      '  client.Name as MainClientName,'
      '  client.CalculateOnProducerCost,'
      '  client.ParseWaybills,'
      '  client.SendRetailMarkup,'
      '  client.ShowAdvertising,'
      '  client.SendWaybillsFromClient,'
      '  client.EnableSmartOrder,'
      '  client.EnableImpersonalPrice'
      'FROM'
      '  ('
      '  analitf.UserInfo,'
      '  analitf.client'
      '  )'
      
        '  left join analitf.CLIENTS on CLIENTS.ClientId = UserInfo.Clien' +
        'tId '
      'where'
      
        '  (((UserInfo.IsFutureClient = 0) and (client.Id = UserInfo.Clie' +
        'ntId)) or (UserInfo.IsFutureClient = 1))')
    Left = 240
    Top = 184
  end
  object dsUser: TDataSource
    DataSet = adsUser
    Left = 240
    Top = 224
  end
  object adsPrintOrderHeader: TMyQuery
    SQLUpdate.Strings = (
      'update CurrentOrderHeads'
      'set'
      '  SERVERORDERID = :SERVERORDERID,'
      '  SENDDATE = :SENDDATE,'
      '  CLOSED = :CLOSED,'
      '  SEND = :SEND'
      'where'
      '  orderid = :old_orderid')
    SQLRefresh.Strings = (
      '#ORDERSHSHOW'
      'SELECT'
      '    header.OrderId,'
      
        '    ifnull(header.ServerOrderId, header.OrderId) as DisplayOrder' +
        'Id,'
      '    header.ClientID,'
      '    header.ServerOrderId,'
      
        '    PricesData.DatePrice - interval :timezonebias minute AS Date' +
        'Price,'
      '    header.PriceCode,'
      '    header.RegionCode,'
      '    header.OrderDate,'
      '    header.SendDate,'
      '    header.Closed,'
      '    header.Send,'
      '    header.PriceName,'
      '    header.RegionName,'
      '    RegionalData.SupportPhone,'
      '    header.MessageTo,'
      '    header.Comments,'
      '    pricesregionaldata.minreq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(list.Id) as Positions,'
      '    ifnull(Sum(list.RealPrice * list.OrderCount), 0) as SumOrder'
      'FROM'
      '   CurrentOrderHeads header'
      '   inner join CurrentOrderLists list on '
      '         (list.OrderId = header.OrderId) '
      '     and (list.OrderCount > 0)'
      '   LEFT JOIN PricesData ON '
      '         (header.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      '         (pricesregionaldata.PriceCode = header.PriceCode) '
      '     and pricesregionaldata.regioncode = header.regioncode'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=header.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      'WHERE'
      '    (header.OrderId = :OrderId)'
      'and (header.ClientId = :ClientId)'
      'and (header.Closed = :Closed)'
      
        'and ((:Closed = 1) or ((:Closed = 0) and (PricesData.PriceCode i' +
        's not null) and (RegionalData.RegionCode is not null) and (price' +
        'sregionaldata.PriceCode is not null)))'
      'and (header.Send = :Send)'
      'group by header.OrderId'
      'having count(list.Id) > 0')
    Connection = MyConnection
    SQL.Strings = (
      '#ORDERSHSHOW'
      'SELECT'
      '    header.OrderId,'
      
        '    ifnull(header.ServerOrderId, header.OrderId) as DisplayOrder' +
        'Id,'
      '    header.ClientID,'
      '    header.ServerOrderId,'
      
        '    PricesData.DatePrice - interval :timezonebias minute AS Date' +
        'Price,'
      '    header.PriceCode,'
      '    header.RegionCode,'
      '    header.OrderDate,'
      '    header.SendDate,'
      '    header.Closed,'
      '    header.Send,'
      '    header.PriceName,'
      '    header.RegionName,'
      '    RegionalData.SupportPhone,'
      '    header.MessageTo,'
      '    header.Comments,'
      '    pricesregionaldata.minreq,'
      '    pricesregionaldata.Enabled as PriceEnabled,'
      '    count(list.Id) as Positions,'
      '    ifnull(Sum(list.RealPrice * list.OrderCount), 0) as SumOrder'
      'FROM'
      '   CurrentOrderHeads header'
      '   inner join CurrentOrderLists list on '
      '         (list.OrderId = header.OrderId) '
      '     and (list.OrderCount > 0)'
      '   LEFT JOIN PricesData ON '
      '         (header.PriceCode=PricesData.PriceCode)'
      '   left join pricesregionaldata on '
      '         (pricesregionaldata.PriceCode = header.PriceCode) '
      '     and pricesregionaldata.regioncode = header.regioncode'
      '   LEFT JOIN RegionalData ON '
      '         (RegionalData.RegionCode=header.RegionCode) '
      '     AND (PricesData.FirmCode=RegionalData.FirmCode)'
      'WHERE'
      '    (header.OrderId = :OrderId)'
      'and (header.ClientId = :ClientId)'
      'and (header.Closed = :Closed)'
      
        'and ((:Closed = 1) or ((:Closed = 0) and (PricesData.PriceCode i' +
        's not null) and (RegionalData.RegionCode is not null) and (price' +
        'sregionaldata.PriceCode is not null)))'
      'and (header.Send = :Send)'
      'group by header.OrderId'
      'having count(list.Id) > 0')
    Left = 48
    Top = 408
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'timezonebias'
      end
      item
        DataType = ftUnknown
        Name = 'OrderId'
      end
      item
        DataType = ftUnknown
        Name = 'ClientId'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'Closed'
      end
      item
        DataType = ftUnknown
        Name = 'Send'
      end>
  end
  object adcTemporaryTable: TMyQuery
    Connection = MyConnection
    SQL.Strings = (
      'drop temporary table if exists pricesshow;'
      'create temporary table pricesshow ENGINE=MEMORY '
      'as'
      'SELECT'
      '   pd.PRICECODE AS PriceCode, '
      '  `pd`.`PRICENAME` AS `PriceName`, '
      '  `pd`.`DATEPRICE` AS `UniversalDatePrice`, '
      '  `prd`.`MINREQ` AS `MinReq`, '
      '  `prd`.`ENABLED` AS `Enabled`, '
      '  `cd`.`FIRMCODE` AS `FirmCode`, '
      '  `cd`.`FULLNAME` AS `FullName`, '
      '  `prd`.`STORAGE` AS `Storage`, '
      '  `cd`.`MANAGERMAIL` AS `ManagerMail`, '
      '  `r`.`REGIONCODE` AS `RegionCode`, '
      '  `r`.`REGIONNAME` AS `RegionName`, '
      '  `prd`.`PRICESIZE` AS `pricesize`, '
      '  `prd`.`CONTROLMINREQ` AS `CONTROLMINREQ`'
      'FROM'
      '  (((`pricesdata` `pd`'
      
        '  JOIN `pricesregionaldata` `prd` ON (`pd`.`PRICECODE` = `prd`.`' +
        'PRICECODE`))'
      '  JOIN `regions` `r` ON (`prd`.`REGIONCODE` = `r`.`REGIONCODE`))'
      '  JOIN `providers` `cd` ON (`cd`.`FIRMCODE` = `pd`.`FIRMCODE`));'
      ''
      'drop temporary table if exists clientavg;'
      'create temporary table clientavg ENGINE=MEMORY '
      'as'
      'SELECT'
      
        '  `CurrentOrderHeads`.`CLIENTID` AS `CLIENTCODE`, `CurrentOrderL' +
        'ists`.`PRODUCTID` AS `PRODUCTID`, AVG(`CurrentOrderLists`.`PRICE' +
        '`) AS `PRICEAVG`'
      'FROM'
      '  (`CurrentOrderHeads`'
      '  JOIN `CurrentOrderLists`)'
      'WHERE'
      
        '  ((`CurrentOrderLists`.`ORDERID` = `CurrentOrderHeads`.`ORDERID' +
        '`) AND (`ordershead`.`ORDERDATE` >= (CURDATE() - INTERVAL 1 MONT' +
        'H)) AND (`ordershead`.`CLOSED` = 1) AND (`CurrentOrderHeads`.`SE' +
        'ND` = 1) AND (`orderslist`.`ORDERCOUNT` > 0) AND (`CurrentOrderL' +
        'ists`.`PRICE` IS NOT NULL))'
      'GROUP BY'
      
        '  `CurrentOrderHeads`.`CLIENTID`, `CurrentOrderLists`.`PRODUCTID' +
        '`;')
    Left = 400
    Top = 104
  end
  object frDBDataSet: TfrDBDataSet
    OpenDataSource = False
    Left = 232
    Top = 544
  end
  object adsOrderDetailsEtalon: TMyQuery
    SQLUpdate.Strings = (
      'update CurrentOrderLists'
      'set'
      '  coreid = :coreid'
      'where'
      '  id = :old_id')
    Connection = MyConnection
    SQL.Strings = (
      'SELECT '
      '    list.id,'
      '    list.OrderId,'
      '    list.ClientId,'
      '    list.CoreId,'
      '    products.catalogid as fullcode,'
      '    list.productid,'
      '    list.codefirmcr,'
      '    list.synonymcode,'
      '    list.synonymfirmcrcode,'
      '    list.code,'
      '    list.codecr,'
      '    list.synonymname,'
      '    list.synonymfirm,'
      '    list.RealPrice,'
      '    list.price,'
      '    list.await,'
      '    list.junk,'
      '    list.ordercount,'
      '    list.RealPrice*list.OrderCount AS SumOrder,'
      '    list.RequestRatio,'
      '    list.OrderCost,'
      '    list.MinOrderCount,'
      '    list.SupplierPriceMarkup,'
      '    list.CoreQuantity, '
      '    list.ServerCoreID,'
      '    list.Unit, '
      '    list.Volume, '
      '    list.Note, '
      '    list.Period, '
      '    list.Doc, '
      '    list.RegistryCost, '
      '    list.VitallyImportant,'
      '    list.ProducerCost, '
      '    list.NDS, '
      '    list.RetailMarkup,'
      '    list.RetailCost,'
      
        '    (ifnull(catalogs.VitallyImportant, 0) || list.VitallyImporta' +
        'nt) as RetailVitallyImportant'
      'FROM '
      '  CurrentOrderLists list'
      '  left join products on products.productid = list.productid'
      '  left join catalogs on catalogs.fullcode = products.catalogid'
      'WHERE '
      '    (list.OrderId=:OrderId) '
      'AND (list.OrderCount>0)'
      'ORDER BY SynonymName, SynonymFirm')
    CachedUpdates = True
    Left = 152
    Top = 424
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OrderId'
      end>
  end
end
