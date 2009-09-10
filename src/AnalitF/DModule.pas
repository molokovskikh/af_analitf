unit DModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Variants, FileUtil, ARas, ComObj, FR_Class, FR_View,
  FR_DBSet, FR_DCtrl, FR_RRect, FR_Chart, FR_Shape, FR_ChBox, IB_Services,
  FIBQuery, pFIBQuery, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase,
  frRtfExp, frexpimg, FR_E_HTML2, FR_E_TXT, FR_Rich,
  CompactThread, FIB, IB_ErrorCodes, Math, IdIcmpClient, FIBMiscellaneous,
  U_TINFIBInputDelimitedStream, incrt, hlpcodecs, StrUtils, RxMemDS,
  Contnrs, SevenZip, infvercls, IdHashMessageDigest, IdSSLOpenSSLHeaders, pFIBScript,
  pFIBProps, U_UpdateDBThread, pFIBExtract, DateUtils, ShellAPI, ibase, IdHTTP,
  IdGlobal, FR_DSet, Menus, MyEmbConnection, DBAccess, MyAccess, MemDS,
  MyServerControl, DASQLMonitor, MyDacMonitor, MySQLMonitor, MyBackup, MyClasses,
  MyDump, MySqlApi;

{
Криптование
  Синонимы - все в хексе без %
  Цена     - все в хексе без %
  Code, CodeCr - смешанный тип
}

const
  HistoryMaxRec=5;
  //макс. кол-во писем доставаемых с сервера
  RegisterId=59; //код реестра в справочнике фирм
  //Строка для шифрации паролей
  PassPassW = 'sh' + #90 + 'kjw' + #10 + 'h';
  //Список критических библиотек
  CriticalLibraryHashes : array[0..18] of array[0..4] of string =
  (
      ('dbrtl70.bpl', '0650B08C', '583E1038', '5F35A236', '6DD703FA'),
      ('designide70.bpl', 'F16F1849', 'E4827C1D', 'C4FD04B9', '968D63F9'),
      ('EhLib70.bpl', '10FCCB4D', '5DE0A836', 'CCBC83EC', 'B5A52ACC'),
      ('FIBPlus7.bpl', '93C1BA38', '07A95850', '3E51729A', '30003797'),
      ('fr7.bpl', 'F7516F76', '2191B5F2', '43975BC8', '5602F31A'),
      ('IndySystem70.bpl', 'F10B27ED', 'B8E3BE27', '66042960', '8FC2AF12'),
      ('IndyCore70.bpl', '12A2BB12', 'AEA739A4', '4E08CED3', '771EBF60'),
      ('IndyProtocols70.bpl', '2941685C', 'B2BFBA12', '7A42BD1C', 'ED939D35'),
      ('rtl70.bpl', 'E4E90D2F', 'C6C35486', '68351583', '3D4ECB44'),
      ('tee70.bpl', '0AADB9CB', '5EE4338D', '61BA4EA3', 'A9E6098C'),
      ('Tough.bpl', '5A07C426', '0F669C58', '1821E4C7', 'D1680737'),
      ('vcl70.bpl', 'DCBC1726', '16A4CA76', '7D5C8162', '2D7512E7'),
      ('vclactnband70.bpl', '86913722', '1C217FB1', 'C86C8AA3', '3132DDFC'),
      ('vcldb70.bpl', 'EAC7B8AE', '4E416522', '6E16BA01', '4FDC98D7'),
//      ('vclie70.bpl', '463BB658', '6C74C812', '33C92380', 'CAC85ED6'),
      ('vcljpg70.bpl', '334355C1', '34EDB2AE', '88BC6505', '9AB7B17E'),
      ('vclsmp70.bpl', 'D7B49DA9', '80884F53', 'C3D78E1E', '853B02E4'),
      ('vclx70.bpl', 'E12C66FF', 'D510C787', '31D5400E', 'DDECD8C8'),
      ('libeay32.dll', '791361C0', '65BF50F4', '309A59E3', '27DBC261'),
      ('ssleay32.dll', '6E56CDE5', 'CA285535', '3FEDAFE7', 'CABB4B58')
  );

type
  //способ вычисления разницы в цены от другого поставщика
  //pdmPrev - от предыдущего Поставщика, pdmMin - от Поставщика с min ценой,
  //pdmMinEnabled - от Основн.Пост. с min ценой
  TPriceDeltaMode =( pdmPrev, pdmMin, pdmMinEnabled);

  //exit codes - Коды ошибок выхода из программы
  TAnalitFExitCode = (ecOK, ecDBFileNotExists, ecDBFileReadOnly, ecDBFileError,
    ecDoubleStart, ecColor, ecTCPNotExists, ecUserLimit, ecFreeDiskSpace,
    ecGetFreeDiskSpace, ecIE40, ecSevenZip, ecNotCheckUIN, ecSSLOpen, ecNotChechHashes,
    ecDBUpdateError, ecDiffDBVersion, ecDeleteDBFiles);

  TRetMass = array[1..3] of Variant;

  TSelectPrice = class
    PriceCode :Integer;
    RegionCode : Integer;
    Selected : Boolean;
    PriceName : String;
    constructor Create(APriceCode, ARegionCode :Integer;
    ASelected : Boolean;
    APriceName : String);
  end;

  TOrderInfo = class
    PriceCode,
    RegionCode : Integer;
    Summ : Currency;
    constructor Create(APriceCode, ARegionCode : Integer);
  end;
  
  TMySQLAPIEmbeddedEx = class(TMySQLAPIEmbedded)
  end;

  TDM = class(TDataModule)
    frReport: TfrReport;
    dsParams: TDataSource;
    dsAnalit: TDataSource;
    dsClients: TDataSource;
    Ras: TARas;
    frRichObject: TfrRichObject;
    frCheckBoxObject: TfrCheckBoxObject;
    frShapeObject: TfrShapeObject;
    frChartObject: TfrChartObject;
    frRoundRectObject: TfrRoundRectObject;
    frTextExport: TfrTextExport;
    frDialogControls: TfrDialogControls;
    frHTML2Export: TfrHTML2Export;
    frBMPExport: TfrBMPExport;
    frJPEGExport: TfrJPEGExport;
    frTIFFExport: TfrTIFFExport;
    frRtfAdvExport: TfrRtfAdvExport;
    MainConnectionOld: TpFIBDatabase;
    adtParamsOld: TpFIBDataSet;
    adtClientsOld: TpFIBDataSet;
    adcUpdateOld: TpFIBQuery;
    adsRepareOrdersOld: TpFIBDataSet;
    adsCoreRepareOld: TpFIBDataSet;
    adsOrdersHeadersOld: TpFIBDataSet;
    adsOrderDetailsOld: TpFIBDataSet;
    BackService: TpFIBBackupService;
    RestService: TpFIBRestoreService;
    ConfigService: TpFIBConfigService;
    ValidService: TpFIBValidationService;
    adsRepareOrdersOldID: TFIBBCDField;
    adsRepareOrdersOldCOREID: TFIBBCDField;
    adsRepareOrdersOldPRICECODE: TFIBBCDField;
    adsRepareOrdersOldREGIONCODE: TFIBBCDField;
    adsRepareOrdersOldCODE: TFIBStringField;
    adsRepareOrdersOldCODECR: TFIBStringField;
    adsRepareOrdersOldSYNONYMCODE: TFIBBCDField;
    adsRepareOrdersOldSYNONYMFIRMCRCODE: TFIBBCDField;
    adsRepareOrdersOldSYNONYMNAME: TFIBStringField;
    adsRepareOrdersOldSYNONYMFIRM: TFIBStringField;
    adsRepareOrdersOldJUNK: TFIBBooleanField;
    adsRepareOrdersOldAWAIT: TFIBBooleanField;
    adsRepareOrdersOldORDERCOUNT: TFIBIntegerField;
    adsRepareOrdersOldPRICENAME: TFIBStringField;
    adsRepareOrdersOldCryptPRICE: TCurrencyField;
    adsCoreRepareOldCOREID: TFIBBCDField;
    adsCoreRepareOldFULLCODE: TFIBBCDField;
    adsCoreRepareOldSHORTCODE: TFIBBCDField;
    adsCoreRepareOldCODEFIRMCR: TFIBBCDField;
    adsCoreRepareOldSYNONYMCODE: TFIBBCDField;
    adsCoreRepareOldSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreRepareOldCODE: TFIBStringField;
    adsCoreRepareOldCODECR: TFIBStringField;
    adsCoreRepareOldVOLUME: TFIBStringField;
    adsCoreRepareOldDOC: TFIBStringField;
    adsCoreRepareOldNOTE: TFIBStringField;
    adsCoreRepareOldPERIOD: TFIBStringField;
    adsCoreRepareOldQUANTITY: TFIBStringField;
    adsCoreRepareOldSYNONYMNAME: TFIBStringField;
    adsCoreRepareOldSYNONYMFIRM: TFIBStringField;
    adsCoreRepareOldLEADERPRICECODE: TFIBBCDField;
    adsCoreRepareOldLEADERREGIONCODE: TFIBBCDField;
    adsCoreRepareOldLEADERREGIONNAME: TFIBStringField;
    adsCoreRepareOldLEADERPRICENAME: TFIBStringField;
    adsCoreRepareOldORDERSCOREID: TFIBBCDField;
    adsCoreRepareOldORDERSORDERID: TFIBBCDField;
    adsCoreRepareOldORDERSCLIENTID: TFIBBCDField;
    adsCoreRepareOldORDERSFULLCODE: TFIBBCDField;
    adsCoreRepareOldORDERSCODEFIRMCR: TFIBBCDField;
    adsCoreRepareOldORDERSSYNONYMCODE: TFIBBCDField;
    adsCoreRepareOldORDERSSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreRepareOldORDERSCODE: TFIBStringField;
    adsCoreRepareOldORDERSCODECR: TFIBStringField;
    adsCoreRepareOldORDERCOUNT: TFIBIntegerField;
    adsCoreRepareOldORDERSSYNONYM: TFIBStringField;
    adsCoreRepareOldORDERSSYNONYMFIRM: TFIBStringField;
    adsCoreRepareOldORDERSHORDERID: TFIBBCDField;
    adsCoreRepareOldORDERSHCLIENTID: TFIBBCDField;
    adsCoreRepareOldORDERSHPRICECODE: TFIBBCDField;
    adsCoreRepareOldORDERSHREGIONCODE: TFIBBCDField;
    adsCoreRepareOldORDERSHPRICENAME: TFIBStringField;
    adsCoreRepareOldORDERSHREGIONNAME: TFIBStringField;
    adsRetailMarginsOld: TpFIBDataSet;
    adsRetailMarginsOldID: TFIBBCDField;
    adsRetailMarginsOldLEFTLIMIT: TFIBBCDField;
    adsRetailMarginsOldRIGHTLIMIT: TFIBBCDField;
    adsRetailMarginsOldRETAIL: TFIBIntegerField;
    dsRetailMargins: TDataSource;
    adsSumOrdersOldForDelete: TpFIBDataSet;
    adsSumOrdersOldForDeleteCODE: TFIBStringField;
    adsSumOrdersOldForDeleteCODECR: TFIBStringField;
    adsSumOrdersOldForDeleteORDERCOUNT: TFIBIntegerField;
    adsSumOrdersOldForDeleteCryptPRICE: TCurrencyField;
    adsSumOrdersOldForDeleteSumOrders: TCurrencyField;
    adsPricesOld: TpFIBDataSet;
    adsOrderDetailsOldCryptSUMORDER: TCurrencyField;
    adsOrderDetailsOldORDERID: TFIBBCDField;
    adsOrderDetailsOldCLIENTID: TFIBBCDField;
    adsOrderDetailsOldCOREID: TFIBBCDField;
    adsOrderDetailsOldCODEFIRMCR: TFIBBCDField;
    adsOrderDetailsOldSYNONYMCODE: TFIBBCDField;
    adsOrderDetailsOldSYNONYMFIRMCRCODE: TFIBBCDField;
    adsOrderDetailsOldCODE: TFIBStringField;
    adsOrderDetailsOldCODECR: TFIBStringField;
    adsOrderDetailsOldSYNONYMNAME: TFIBStringField;
    adsOrderDetailsOldSYNONYMFIRM: TFIBStringField;
    adsOrderDetailsOldORDERCOUNT: TFIBIntegerField;
    adsAllOrdersOld: TpFIBDataSet;
    adsAllOrdersOldID: TFIBBCDField;
    adsAllOrdersOldORDERID: TFIBBCDField;
    adsAllOrdersOldCLIENTID: TFIBBCDField;
    adsAllOrdersOldCOREID: TFIBBCDField;
    adsAllOrdersOldCODEFIRMCR: TFIBBCDField;
    adsAllOrdersOldSYNONYMCODE: TFIBBCDField;
    adsAllOrdersOldSYNONYMFIRMCRCODE: TFIBBCDField;
    adsAllOrdersOldCODE: TFIBStringField;
    adsAllOrdersOldCODECR: TFIBStringField;
    adsAllOrdersOldSYNONYMNAME: TFIBStringField;
    adsAllOrdersOldSYNONYMFIRM: TFIBStringField;
    adsAllOrdersOldAWAIT: TFIBBooleanField;
    adsAllOrdersOldJUNK: TFIBBooleanField;
    adsAllOrdersOldORDERCOUNT: TFIBIntegerField;
    adsAllOrdersOldCryptPRICE: TCurrencyField;
    adsPricesOldPRICECODE: TFIBBCDField;
    adsPricesOldPRICENAME: TFIBStringField;
    adsPricesOldDATEPRICE: TFIBDateTimeField;
    adsPricesOldMINREQ: TFIBIntegerField;
    adsPricesOldENABLED: TFIBIntegerField;
    adsPricesOldPRICEINFO: TFIBMemoField;
    adsPricesOldFIRMCODE: TFIBBCDField;
    adsPricesOldFULLNAME: TFIBStringField;
    adsPricesOldSTORAGE: TFIBIntegerField;
    adsPricesOldADMINMAIL: TFIBStringField;
    adsPricesOldSUPPORTPHONE: TFIBStringField;
    adsPricesOldCONTACTINFO: TFIBMemoField;
    adsPricesOldOPERATIVEINFO: TFIBMemoField;
    adsPricesOldREGIONCODE: TFIBBCDField;
    adsPricesOldREGIONNAME: TFIBStringField;
    adsPricesOldPOSITIONS: TFIBIntegerField;
    adsPricesOldPRICESIZE: TFIBIntegerField;
    adsPricesOldINJOB: TFIBIntegerField;
    adsCoreRepareOldAWAIT: TFIBBooleanField;
    adsCoreRepareOldJUNK: TFIBBooleanField;
    adsRepareOrdersOldPRICE: TFIBStringField;
    adsCoreRepareOldBASECOST: TFIBStringField;
    adsCoreRepareOldORDERSPRICE: TFIBStringField;
    adsOrderDetailsOldPRICE: TFIBStringField;
    adsSumOrdersOldForDeletePRICE: TFIBStringField;
    adsAllOrdersOldPRICE: TFIBStringField;
    adsCoreRepareOldORDERSJUNK: TFIBBooleanField;
    adsCoreRepareOldORDERSAWAIT: TFIBBooleanField;
    adsOrderCoreOld: TpFIBDataSet;
    adsOrderCoreOldPRICECODE: TFIBBCDField;
    adsOrderCoreOldBASECOST: TFIBStringField;
    adsOrderCoreOldCryptBASECOST: TCurrencyField;
    adsOrderCoreOldPRICEENABLED: TFIBIntegerField;
    adsOrderCoreOldJUNK: TFIBIntegerField;
    adtClientsOldCLIENTID: TFIBBCDField;
    adtClientsOldNAME: TFIBStringField;
    adtClientsOldREGIONCODE: TFIBBCDField;
    adtClientsOldEXCESS: TFIBIntegerField;
    adtClientsOldDELTAMODE: TFIBSmallIntField;
    adtClientsOldMAXUSERS: TFIBIntegerField;
    adtClientsOldREQMASK: TFIBBCDField;
    adtClientsOldTECHSUPPORT: TFIBStringField;
    adtClientsOldCALCULATELEADER: TFIBBooleanField;
    adtClientsOldONLYLEADERS: TFIBBooleanField;
    adsOrderCoreOldCODEFIRMCR: TFIBBCDField;
    adsCoreRepareOldREQUESTRATIO: TFIBIntegerField;
    adsOrderDetailsOldSENDPRICE: TFIBBCDField;
    adsOrderDetailsOldAWAIT: TFIBBooleanField;
    adsOrderDetailsOldJUNK: TFIBBooleanField;
    adsOrderDetailsOldID: TFIBBCDField;
    adtReceivedDocsOld: TpFIBDataSet;
    adsOrderDetailsOldPRODUCTID: TFIBBCDField;
    adsOrderDetailsOldFULLCODE: TFIBBCDField;
    adsOrderCoreOldPRODUCTID: TFIBBCDField;
    adsAllOrdersOldPRODUCTID: TFIBBCDField;
    adsRepareOrdersOldREQUESTRATIO: TFIBIntegerField;
    adsRepareOrdersOldORDERCOST: TFIBBCDField;
    adsRepareOrdersOldMINORDERCOUNT: TFIBIntegerField;
    adsCoreRepareOldVITALLYIMPORTANT: TFIBBooleanField;
    adsCoreRepareOldORDERCOST: TFIBBCDField;
    adsCoreRepareOldMINORDERCOUNT: TFIBIntegerField;
    frdsReportOrder: TfrDBDataSet;
    adsOrderDetailsOldSUMORDER: TFIBBCDField;
    adsOrderDetailsOldCryptPRICE: TCurrencyField;
    adsOrderDetailsOldREQUESTRATIO: TFIBIntegerField;
    adsOrderDetailsOldORDERCOST: TFIBBCDField;
    adsOrderDetailsOldMINORDERCOUNT: TFIBIntegerField;
    MyConnection: TMyConnection;
    adtParams: TMyTable;
    adtClients: TMyQuery;
    adsRetailMargins: TMyQuery;
    adtClientsCLIENTID: TLargeintField;
    adtClientsNAME: TStringField;
    adtClientsREGIONCODE: TLargeintField;
    adtClientsEXCESS: TIntegerField;
    adtClientsDELTAMODE: TSmallintField;
    adtClientsMAXUSERS: TIntegerField;
    adtClientsREQMASK: TLargeintField;
    adsRetailMarginsID: TLargeintField;
    adsRetailMarginsLEFTLIMIT: TFloatField;
    adsRetailMarginsRIGHTLIMIT: TFloatField;
    adsRetailMarginsRETAIL: TIntegerField;
    adcUpdate: TMyQuery;
    adtClientsCALCULATELEADER: TBooleanField;
    adtClientsONLYLEADERS: TBooleanField;
    MyServerControl: TMyServerControl;
    MySQLMonitor: TMySQLMonitor;
    adtReceivedDocs: TMyQuery;
    adsPrices: TMyQuery;
    adsPricesPriceCode: TLargeintField;
    adsPricesPriceName: TStringField;
    adsPricesUniversalDatePrice: TDateTimeField;
    adsPricesMinReq: TIntegerField;
    adsPricesEnabled: TBooleanField;
    adsPricesPriceInfo: TMemoField;
    adsPricesFirmCode: TLargeintField;
    adsPricesFullName: TStringField;
    adsPricesStorage: TBooleanField;
    adsPricesManagerMail: TStringField;
    adsPricesSupportPhone: TStringField;
    adsPricesContactInfo: TMemoField;
    adsPricesOperativeInfo: TMemoField;
    adsPricesRegionCode: TLargeintField;
    adsPricesRegionName: TStringField;
    adsPricespricesize: TIntegerField;
    adsPricesINJOB: TBooleanField;
    adsPricesCONTROLMINREQ: TBooleanField;
    adsPricesDatePrice: TDateTimeField;
    adsPricesPositions: TLargeintField;
    adsPricessumbycurrentmonth: TFloatField;
    adsQueryValue: TMyQuery;
    adsAllOrders: TMyQuery;
    adsAllOrdersID: TLargeintField;
    adsAllOrdersORDERID: TLargeintField;
    adsAllOrdersCLIENTID: TLargeintField;
    adsAllOrdersCOREID: TLargeintField;
    adsAllOrdersPRODUCTID: TLargeintField;
    adsAllOrdersCODEFIRMCR: TLargeintField;
    adsAllOrdersSYNONYMCODE: TLargeintField;
    adsAllOrdersSYNONYMFIRMCRCODE: TLargeintField;
    adsAllOrdersCODE: TStringField;
    adsAllOrdersCODECR: TStringField;
    adsAllOrdersSYNONYMNAME: TStringField;
    adsAllOrdersSYNONYMFIRM: TStringField;
    adsAllOrdersPRICE: TStringField;
    adsAllOrdersAWAIT: TBooleanField;
    adsAllOrdersJUNK: TBooleanField;
    adsAllOrdersORDERCOUNT: TIntegerField;
    adsOrderCore: TMyQuery;
    adsOrderCorePriceCode: TLargeintField;
    adsOrderCoreproductid: TLargeintField;
    adsOrderCoreJunk: TBooleanField;
    adsOrderCorePriceEnabled: TBooleanField;
    adsOrderCoreCodeFirmCr: TLargeintField;
    adsOrderDetails: TMyQuery;
    adsOrderDetailsid: TLargeintField;
    adsOrderDetailsOrderId: TLargeintField;
    adsOrderDetailsClientId: TLargeintField;
    adsOrderDetailsCoreId: TLargeintField;
    adsOrderDetailsfullcode: TLargeintField;
    adsOrderDetailsproductid: TLargeintField;
    adsOrderDetailscodefirmcr: TLargeintField;
    adsOrderDetailssynonymcode: TLargeintField;
    adsOrderDetailssynonymfirmcrcode: TLargeintField;
    adsOrderDetailscode: TStringField;
    adsOrderDetailscodecr: TStringField;
    adsOrderDetailssynonymname: TStringField;
    adsOrderDetailssynonymfirm: TStringField;
    adsOrderDetailsawait: TBooleanField;
    adsOrderDetailsjunk: TBooleanField;
    adsOrderDetailsordercount: TIntegerField;
    adsOrderDetailsSumOrder: TFloatField;
    adsOrderDetailsRequestRatio: TIntegerField;
    adsOrderDetailsOrderCost: TFloatField;
    adsOrderDetailsMinOrderCount: TIntegerField;
    adsOrdersHeaders: TMyQuery;
    adsPricesSumOrder: TFloatField;
    adsOrderDetailsprice: TFloatField;
    adsOrderCoreCost: TFloatField;
    adsRepareOrders: TMyQuery;
    adsRepareOrdersId: TLargeintField;
    adsRepareOrdersCoreId: TLargeintField;
    adsRepareOrdersPriceCode: TLargeintField;
    adsRepareOrdersRegionCode: TLargeintField;
    adsRepareOrdersCode: TStringField;
    adsRepareOrdersCodeCr: TStringField;
    adsRepareOrdersPrice: TFloatField;
    adsRepareOrdersSynonymCode: TLargeintField;
    adsRepareOrdersSynonymFirmCrCode: TLargeintField;
    adsRepareOrdersSynonymName: TStringField;
    adsRepareOrdersSynonymFirm: TStringField;
    adsRepareOrdersJunk: TBooleanField;
    adsRepareOrdersAwait: TBooleanField;
    adsRepareOrdersOrderCount: TIntegerField;
    adsRepareOrdersPriceName: TStringField;
    adsRepareOrdersrequestratio: TIntegerField;
    adsRepareOrdersordercost: TFloatField;
    adsRepareOrdersminordercount: TIntegerField;
    adsCoreRepare: TMyQuery;
    adsCoreRepareCoreId: TLargeintField;
    adsCoreRepareClientID: TLargeintField;
    adsCoreRepareproductid: TLargeintField;
    adsCoreReparePriceCode: TLargeintField;
    adsCoreRepareRegionCode: TLargeintField;
    adsCoreRepareFullCode: TLargeintField;
    adsCoreRepareshortcode: TLargeintField;
    adsCoreRepareCodeFirmCr: TLargeintField;
    adsCoreRepareSynonymCode: TLargeintField;
    adsCoreRepareSynonymFirmCrCode: TLargeintField;
    adsCoreRepareCode: TStringField;
    adsCoreRepareCodeCr: TStringField;
    adsCoreRepareVolume: TStringField;
    adsCoreRepareDoc: TStringField;
    adsCoreRepareNote: TStringField;
    adsCoreReparePeriod: TStringField;
    adsCoreRepareAwait: TBooleanField;
    adsCoreRepareJunk: TBooleanField;
    adsCoreRepareCost: TFloatField;
    adsCoreRepareQuantity: TStringField;
    adsCoreRepareregistrycost: TFloatField;
    adsCoreReparevitallyimportant: TBooleanField;
    adsCoreReparerequestratio: TIntegerField;
    adsCoreRepareordercost: TFloatField;
    adsCoreRepareminordercount: TIntegerField;
    adsCoreRepareSynonymName: TStringField;
    adsCoreRepareSynonymFirm: TStringField;
    adsCoreRepareLeaderPriceCode: TLargeintField;
    adsCoreRepareLeaderRegionCode: TLargeintField;
    adsCoreRepareLeaderRegionName: TStringField;
    adsCoreRepareLeaderPriceName: TStringField;
    adsCoreRepareLeaderPRICE: TFloatField;
    adsCoreRepareOrdersCoreId: TLargeintField;
    adsCoreRepareOrdersOrderId: TLargeintField;
    adsCoreRepareOrdersClientId: TLargeintField;
    adsCoreRepareOrdersFullCode: TLargeintField;
    adsCoreRepareOrdersCodeFirmCr: TLargeintField;
    adsCoreRepareOrdersSynonymCode: TLargeintField;
    adsCoreRepareOrdersSynonymFirmCrCode: TLargeintField;
    adsCoreRepareOrdersCode: TStringField;
    adsCoreRepareOrdersCodeCr: TStringField;
    adsCoreRepareOrderCount: TIntegerField;
    adsCoreRepareOrdersSynonym: TStringField;
    adsCoreRepareOrdersSynonymFirm: TStringField;
    adsCoreRepareOrdersPrice: TFloatField;
    adsCoreRepareSumOrder: TFloatField;
    adsCoreRepareOrdersJunk: TBooleanField;
    adsCoreRepareOrdersAwait: TBooleanField;
    adsCoreRepareOrdersHOrderId: TLargeintField;
    adsCoreRepareOrdersHClientId: TLargeintField;
    adsCoreRepareOrdersHPriceCode: TLargeintField;
    adsCoreRepareOrdersHRegionCode: TLargeintField;
    adsCoreRepareOrdersHPriceName: TStringField;
    adsCoreRepareOrdersHRegionName: TStringField;
    adsRepareOrdersClientName: TStringField;
    MyEmbConnection: TMyEmbConnection;
    procedure DMCreate(Sender: TObject);
    procedure adtClientsOldAfterOpen(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure MainConnectionOldAfterConnect(Sender: TObject);
    procedure adsRetailMarginsOldLEFTLIMITChange(Sender: TField);
    procedure MySQLMonitorSQL(Sender: TObject; Text: String;
      Flag: TDATraceFlag);
  private
    //Требуется ли подтверждение обмена
    FNeedCommitExchange : Boolean;
    //Код подтверждения обновления, полученный с сервера
    FServerUpdateId : String;
    SynonymPassword,
    CodesPassword,
    BaseCostPassword,
    DBUIN : String;
    //Требуется обновления из-за того, что некорректный UIN
    NeedUpdateByCheckUIN : Boolean;
    //Требуется обновления из-за того, что некорректные Hash'и компонент
    NeedUpdateByCheckHashes : Boolean;
    //Требуется импорт после восстановления из эталонной копии
    FNeedImportAfterRecovery : Boolean;
    //Была создана "чистая" база данных
    FCreateClearDatabase     : Boolean;
    FGetCatalogsCount : Integer;
    FRetMargins : array of TRetMass;
    SynC,
    HTTPC,
    CodeC,
    BasecostC : TINFCrypt;
    OrdersInfo : TStringList;
    procedure CheckRestrictToRun;
    procedure CheckDBFile;
    procedure ReadPasswords;
    function CheckCopyIDFromDB : Boolean;
    function GetCatalogsCount : Integer;
    procedure LoadSelectedPrices;
    function CheckCriticalLibrary : Boolean;
    function GetFileHash(AFileName : String) : String;
    procedure s3cf(DataSet: TDataSet);
    procedure socf(DataSet: TDataSet);
    //Проверяем версию базы и обновляем ее в случае необходимости
    procedure UpdateDB;
    //Обновления UIN в базе данных в случае обновления версии программы
    procedure UpdateDBUIN(dbCon : TCustomMyConnection);
    //Проверяем наличие всех объектов в базе данных
    procedure CheckDBObjects(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    //Проверяем и обновляем определенный файл
    procedure UpdateDBFile(dbCon : TpFIBDatabase; trMain : TpFIBTransaction; FileName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure OnScriptParseError(
      Sender: TObject;
      Error: string;
      SQLText: string;
      LineIndex: Integer);
    procedure OnScriptExecuteError(
      Sender: TObject;
      Error: string;
      SQLText: string;
      LineIndex: Integer;
      var Ignore: Boolean);
    //Обновление определенных данных в таблице
{$ifdef DEBUG}
    procedure UpdateDBFileDataFor29(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor36(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor35(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor37(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor40(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
{$endif}
    procedure UpdateDBFileDataFor42(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    //Установить галочку отправить для текущих заказов
    procedure SetSendToNotClosedOrders;
    function GetLastCreateScript : String;
    function GetFullLastCreateScript : String;
    //создаем базу данных
    procedure CreateClearDatabaseFromScript(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    //восстанавливаем базу данных из предыдущей успешной копии
    procedure RestoreDatabaseFromPrevios(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    //Производим обновлением базы данных Firebird на базу данных MySql
    procedure UpdateFirebirdToMySql(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure InternalUpdateFirebirdToMySql(dbCon : TCustomMyConnection; firebirdDB : TpFIBDatabase; firebirdTransaction : TpFIBTransaction);
    //Производим восстановлени из эталонной копии (если она существует) или создаем чистую базу данных
    procedure RecoverDatabase(E : Exception);
{$ifdef DEBUG}
    procedure ExtractDBScript(dbCon : TCustomMyConnection);
{$endif}
{//$define TestEmbeddedMysql}
{$ifdef TestEmbeddedMysql}
    procedure TestEmbeddedMysql;
  {$ifdef USEMYSQLEMBEDDED}
    procedure TestOpenDatabase;
    procedure TestDumpDatabase;
    procedure TestEmbeddedThread;
  {$endif}
    procedure TestDirectoriesOperation;
{$endif}
    function GetMainConnection: TCustomMyConnection;
    procedure PatchMyDataSets;
  public
    FFS : TFormatSettings;
    SerBeg,
    SerEnd : String;
    SaveGridMask : Integer;
    procedure CompactDataBase();
    procedure ShowFastReport(FileName: string; DataSet: TDataSet = nil;
      APreview: boolean = False; PrintDlg: boolean = True);
    procedure ShowOrderDetailsReport(
      OrderId  : Integer;
      Closed   : Boolean;
      Send     : Boolean;
      Preview  : Boolean = False;
      PrintDlg : Boolean = True);
    procedure ClientChanged;
    procedure LinkExternalTables;
    procedure UnLinkExternalTables;
    procedure ClearDatabase;
    procedure DeleteEmptyOrders;
    procedure BackupDatabase;
    procedure RestoreDatabase;
    function IsBackuped : Boolean;
    procedure ClearBackup;
    procedure SetCumulative;
    procedure ResetCumulative;
    function GetCumulative: boolean;
    procedure SetStarted;
    procedure ResetStarted;
    function GetStarted: Boolean;
    {function OrderToArchiv(ClientId: Integer=0; PriceCode: Integer=0;
      RegionCode: Integer=0): Boolean;}
    procedure SweepDB;
    function GetDisplayColors : Integer;
    function TCPPresent : Boolean;
    function NeedCommitExchange : Boolean;
    procedure SetNeedCommitExchange();
    procedure SetServerUpdateId(AServerUpdateId : String);
    procedure ResetNeedCommitExchange;
    function GetServerUpdateId() : String;

    function D_B_N(BaseC: String) : String;
    function D_B_N_C(c : TINFCrypt; BaseC: String) : String;
    function E_B_N(c : TINFCrypt; BaseCost: String) : String;
    function D_B_N_OLD(c : TINFCrypt; BaseC: String) : String;
    function E_B_N_OLD(c : TINFCrypt; BaseCost: String) : String;
    //Декодируем поле CODE от версии 29
    function D_29_C_OLD(c : TINFCrypt; CodeS : String) : String;
    //Декодируем поле PRICE от версии 29
    function D_29_B_OLD(c : TINFCrypt; CodeS1, CodeS2 : String) : String;
    function D_HP(HTTPPassC: String) : String;
    function E_HP(HTTPPass: String) : String;
    procedure SavePass(ASyn, ACodes, AB, ASGM : String);
    procedure LoadRetailMargins;
    //Получить розничную цену товара в зависимости от наценки
    function GetPriceRet(BaseCost : Currency) : Currency;
    //Получить розничную наценку товара
    function GetRetUpCost(BaseCost : Currency) : Integer;

    //Обрабатываем папки с документами
    procedure ProcessDocs;
    //обрабатываем каждую конкретную папку
    procedure ProcessDocsDir(DirName : String; MaxFileDate : TDateTime; FileList : TStringList);
    procedure OpenDocsDir(DirName : String; FileList : TStringList; OpenEachFile : Boolean);

    //получить сумму заказа
    function GetSumOrder (AOrderID : Integer) : Currency;
    //получить сумму заказа по PriceCode и RegionCode
    function FindOrderInfo (APriceCode, ARegionCode : Integer) : Currency;

    property NeedImportAfterRecovery : Boolean read FNeedImportAfterRecovery;
    property CreateClearDatabase : Boolean read FCreateClearDatabase;
    //Установить параметры для компонента TIdHTTP
    procedure InternalSetHTTPParams(SetHTTP : TIdHTTP);
    function  QueryValue(SQL : String; Params: array of string; Values: array of Variant) : Variant;
    property MainConnection : TCustomMyConnection read GetMainConnection;
  end;

var
  DM: TDM;
  PassC : TINFCrypt;
  SummarySelectedPrices,
  SynonymSelectedPrices : TStringList;

procedure ClearSelectedPrices(SelectedPrices : TStringList);

function GetSelectedPricesSQL(SelectedPrices : TStringList; Suffix : String = '') : String;

function gcp : String;

function gop : String;

implementation

{$R *.DFM}

uses AProc, Main, DBProc, Exchange, Constant, SysNames, UniqueID, RxVerInf,
     LU_Tracer, LU_MutexSystem, Config, U_ExchangeLog,
     U_DeleteDBThread;

type
  TestMyDBThreadState = (
    mtsInit,
    mtsTestParentData,
    mtsCloseParent,
    mtsOpenChild,
    mtsCloseChild,
    mtsClosingInMain,
    mtsClosedInMain,
    mtsOpenParentInChild,
    mtsCloseParentInChild,
    mtsStopped);

  TTestMyDBThread = class(TThread)
   private
    FEmbConnection : TMyEmbConnection;
    FParent : TMyEmbConnection;
   protected
    procedure Execute; override;
   public
    State : TestMyDBThreadState;
    constructor Create(Parent : TMyEmbConnection);
    destructor  Destroy; override;
  end;

constructor TTestMyDBThread.Create(Parent : TMyEmbConnection);
begin
  inherited Create(False);

  FreeOnTerminate := True;

  State := mtsInit;

  FParent := Parent;
  FEmbConnection := TMyEmbConnection.Create(nil);
  FEmbConnection.Database := Parent.Database;
  FEmbConnection.Username := Parent.Username;
  FEmbConnection.DataDir := Parent.DataDir;
  FEmbConnection.Options := Parent.Options;
  FEmbConnection.Params.Clear;
  FEmbConnection.Params.AddStrings(Parent.Params);
  FEmbConnection.LoginPrompt := False;
end;

destructor  TTestMyDBThread.Destroy;
begin
  FEmbConnection.Free;
  inherited;
end;

procedure TTestMyDBThread.Execute;
var
  FQuery : TMyQuery;
begin
  try

    try
      State := mtsTestParentData;
      FQuery := TMyQuery.Create(nil);
      try

        FQuery.Connection := FParent;
        
        try
          FQuery.SQL.Text := 'select * from analitf.params';
          FQuery.Open;
          if FQuery.RecordCount = 1 then
            WriteExchangeLog('thread.mtsTestParentData', 'Params consists data')
          else
            WriteExchangeLog('thread.mtsTestParentData', 'Params - no data');
          FQuery.Close;
        except
          on E : Exception do
            WriteExchangeLog('thread.ErrorOn_mtsTestParentData_Select', E.Message);
        end;

        try
          FQuery.SQL.Text := 'update analitF.params set RasName = "test" where Id = 0';
          FQuery.Execute;
        except
          on E : Exception do
            WriteExchangeLog('thread.ErrorOn_mtsTestParentData_Update', E.Message);
        end;
        
      finally
        FQuery.Free;
      end;
    except
      on E : Exception do
        WriteExchangeLog('thread.ErrorOn_mtsTestParentData', E.Message);
    end;
    Sleep(200);

    try
      State := mtsCloseParent;
      FParent.Close;
    except
      on E : Exception do
        WriteExchangeLog('thread.ErrorOn_mtsCloseParent', E.Message);
    end;
    Sleep(200);

    try
      State := mtsOpenChild;
      FEmbConnection.Open;
    except
      on E : Exception do
        WriteExchangeLog('thread.ErrorOn_mtsOpenChild', E.Message);
    end;
    Sleep(200);

    try
      State := mtsCloseChild;
      if FEmbConnection.Connected then begin

        FQuery := TMyQuery.Create(nil);
        try
          FQuery.Connection := FEmbConnection;

          try
            FQuery.SQL.Text := 'select * from analitf.params';
            FQuery.Open;
            if FQuery.RecordCount = 1 then
              WriteExchangeLog('thread.mtsCloseChild', 'Params consists data')
            else
              WriteExchangeLog('thread.mtsCloseChild', 'Params - no data');
            FQuery.Close;
          except
            on E : Exception do
              WriteExchangeLog('thread.ErrorOn_mtsCloseChild_Select', E.Message);
          end;

          try
            FQuery.SQL.Text := 'update analitF.params set RasName = "test" where Id = 0';
            FQuery.Execute;
          except
            on E : Exception do
              WriteExchangeLog('thread.ErrorOn_mtsCloseChild_Update', E.Message);
          end;

        finally
          FQuery.Free;
        end;

        FEmbConnection.Close;
      end
      else
        WriteExchangeLog('thread.mtsCloseChild', 'Connection not opened');
    except
      on E : Exception do
        WriteExchangeLog('thread.ErrorOn_mtsCloseChild', E.Message);
    end;
    Sleep(200);

    State := mtsClosingInMain;
    while (State <> mtsClosedInMain) do
      Sleep(500);

    try
      State := mtsOpenParentInChild;
      FParent.Open;
    except
      on E : Exception do
        WriteExchangeLog('thread.ErrorOn_mtsOpenParentInChild', E.Message);
    end;
    Sleep(200);

    try
      State := mtsCloseParentInChild;
      if FParent.Connected then begin
        FQuery := TMyQuery.Create(nil);
        try
          FQuery.Connection := FEmbConnection;

          try
            FQuery.SQL.Text := 'select * from analitf.params';
            FQuery.Open;
            if FQuery.RecordCount = 1 then
              WriteExchangeLog('thread.mtsCloseParentInChild', 'Params consists data')
            else
              WriteExchangeLog('thread.mtsCloseParentInChild', 'Params - no data');
            FQuery.Close;
          except
            on E : Exception do
              WriteExchangeLog('thread.ErrorOn_mtsCloseParentInChild_Select', E.Message);
          end;

          try
            FQuery.SQL.Text := 'update analitF.params set RasName = "test" where Id = 0';
            FQuery.Execute;
          except
            on E : Exception do
              WriteExchangeLog('thread.ErrorOn_mtsCloseParentInChild_Update', E.Message);
          end;

        finally
          FQuery.Free;
        end;

        FParent.Close;
      end
      else
        WriteExchangeLog('thread.mtsCloseParentInChild', 'Connection not opened');
    except
      on E : Exception do
        WriteExchangeLog('thread.ErrorOn_mtsCloseParentInChild', E.Message);
    end;
    Sleep(200);

  except
    on E : Exception do
      WriteExchangeLog('TTestMyDBThread.Execute', E.Message);
  end;
  State := mtsStopped;
end;

procedure ClearSelectedPrices(SelectedPrices : TStringList);
var
  I : Integer;
begin
  for I := 0 to SelectedPrices.Count-1 do
    SelectedPrices.Objects[i].Free;
  SelectedPrices.Clear;
end;

function GetSelectedPricesSQL(SelectedPrices : TStringList; Suffix : String = '') : String;
var
  I : Integer;
  sp : TSelectPrice;
  SelectedCount : Integer;
begin
  Result := '';
  SelectedCount := 0;
  for I := 0 to SelectedPrices.Count-1 do begin
    sp := TSelectPrice(SelectedPrices.Objects[i]);
    if sp.Selected then begin
      Inc(SelectedCount);
      if Result = '' then
        Result := Format('((' + Suffix + 'PriceCode = %d) and (' + Suffix + 'RegionCode = %d))', [sp.PriceCode, sp.RegionCode])
      else
        Result := Result + ' or ' + Format('((' + Suffix + 'PriceCode = %d) and (' + Suffix + 'RegionCode = %d))', [sp.PriceCode, sp.RegionCode]);
    end;
  end;
  if SelectedCount = 0 then
    Result := ' (' + Suffix + 'PriceCode = -1)'
  else
    if SelectedCount = SelectedPrices.Count then
      Result := ''
    else
      Result := ' ' + Result;
end;

procedure TDM.DMCreate(Sender: TObject);
var
  HTTPS,
  HTTPE : String;
  UpdateByCheckUINExchangeActions : TExchangeActions;
  UpdateByCheckUINSuccess : Boolean;
begin
  //MySqlApi.MySQLEmbDisableEventLog := True;

  SerBeg := '8F24';
  SerEnd := 'BB48';
  HTTPS := 'rkhgjsdk';
  HTTPE := 'fhhjfgfh';

  PatchMyDataSets;

  OrdersInfo := TStringList.Create;
  OrdersInfo.Sorted := True;

  //adsRepareOrders.OnCalcFields := s3cf;
  //adsOrderDetails.OnCalcFields := ocf;
  adsSumOrdersOldForDelete.OnCalcFields := socf;
 // adsOrderCore.OnCalcFields := occf;

  SynC := TINFCrypt.Create('', 300);
  CodeC := TINFCrypt.Create('', 60);
  BasecostC := TINFCrypt.Create('', 50);
  HTTPC := TINFCrypt.Create(HTTPS + HTTPE, 255);

  ResetNeedCommitExchange;
  GetLocaleFormatSettings(0, FFS);

  if not IsOneStart then
    LogExitError('Запуск двух копий программы на одном компьютере невозможен.', Integer(ecDoubleStart));

  WriteExchangeLog('AnalitF', 'Программа запущена.');

{$ifdef TestEmbeddedMysql}
  TestEmbeddedMysql();
  ExitProcess(1);
{$endif}

  //Удаляем файлы базы данных для переустановки
  if FindCmdLineSwitch('renew') then
    RunDeleteDBFiles();

  FNeedImportAfterRecovery := False;
  FCreateClearDatabase     := False;
  if IsBackuped then
    try
      RestoreDatabase;
      FNeedImportAfterRecovery := True;
    except
      on E : Exception do
        LogExitError(Format( 'Не возможно переместить AnalitF.bak в AnalitF.fdb : %s ', [ E.Message ]), Integer(ecDBFileError));
    end;

{
  if FileExists(ExePath + DatabaseName) and ((FileGetAttr(ExePath + DatabaseName) and SysUtils.faReadOnly) = SysUtils.faReadOnly)
  then
    LogExitError(Format( 'Файл базы данных %s имеет атрибут "Только чтение".', [ ExePath + DatabaseName ]), Integer(ecDBFileReadOnly));
    }

  //Делаем проверку файла базы данных и в случае проблем производим восстановление из предыдущей удачной копии
  //Проверяем файл, если используем Embedded-сервер, в ином случае - происходит процесс разработки программы и проверять ничего не надо
  if MainConnection is TMyEmbConnection then
    CheckDBFile
  else begin
{$ifdef DEBUG}
    try
      MainConnection.Database := 'analitf';
      MainConnection.Open;
      try
        ExtractDBScript(MainConnection);
      finally
        MainConnection.Close;
      end;
    finally
      MainConnection.Database := '';
    end;
{$endif}
  end;

  try
    try
      CheckRestrictToRun;
    finally
      MainConnection.Close;
    end;
  except
    on E : Exception do
      LogExitError(Format( 'Не возможно открыть файл базы данных : %s ', [ E.Message ]), Integer(ecDBFileError));
  end;

  MainConnection.Open;

  { устанавливаем текущие записи в Clients и Users }
  if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
    then adtClients.First;

  SetStarted;
  ClientChanged;
  
  { устанавливаем параметры печати }
  frReport.Title := Application.Title;
  { проверяем и если надо создаем нужные каталоги }
  if not DirectoryExists( ExePath + SDirDocs) then CreateDir( ExePath + SDirDocs);
  if not DirectoryExists( ExePath + SDirWaybills) then CreateDir( ExePath + SDirWaybills);
  if not DirectoryExists( ExePath + SDirRejects) then CreateDir( ExePath + SDirRejects);
  if not DirectoryExists( ExePath + SDirIn) then CreateDir( ExePath + SDirIn);
  if not DirectoryExists( ExePath + SDirReclame) then CreateDir( ExePath + SDirReclame);
  MainForm.SetUpdateDateTime;
  Application.HintPause := 0;

  DeleteFilesByMask(ExePath + SDirIn + '\*.zip', False);
  DeleteFilesByMask(ExePath + SDirIn + '\*.zi_', False);

  SetSendToNotClosedOrders;

  if NeedUpdateByCheckUIN then begin
    UpdateByCheckUINExchangeActions := [eaGetPrice];
    if (adtParams.FieldByName( 'UpdateDateTime').AsDateTime <> adtParams.FieldByName( 'LastDateTime').AsDateTime)
    then
      UpdateByCheckUINExchangeActions := UpdateByCheckUINExchangeActions + [eaGetFullData];

    if not RunExchange(UpdateByCheckUINExchangeActions)
    then begin
      //Если не получилось обновиться, то отображаем форму конфигурации для корректировки настроек и авторизации
      UpdateByCheckUINSuccess := ShowConfig(True);

      //Если пользователь ввел корректировки, то пытаемся обновиться еще раз
      if UpdateByCheckUINSuccess then
        UpdateByCheckUINSuccess := RunExchange(UpdateByCheckUINExchangeActions);

      //Если пользователь обновился не успешно, то проверяем заблокированы ли визуальные контролы
      //Если контролы не заблокированы, то завершаем с ошибой выполение программы
      //Если контролы заблокированы, то логируем неуспешную проверку UIN и
      //отображаем программу с заблокированными контролами 
      if not UpdateByCheckUINSuccess then
        if adtParams.FieldByName('HTTPNameChanged').AsBoolean then begin
          MainForm.DisableByHTTPName;
          LogCriticalError('Не прошла проверка на UIN в базе.');
        end
        else
          LogExitError(
            'Не прошла проверка на UIN в базе. ' +
              'Не удалось заблокировать визуальные компоненты',
            Integer(ecNotCheckUIN), False);
    end;
  end;

  if NeedUpdateByCheckHashes then begin
    if not RunExchange([ eaGetPrice]) then
      LogExitError('Не прошла проверка на подлинность компонент.', Integer(ecNotChechHashes), False);
  end;

  { Запуск с ключем -e (Получение данных и выход)}
  if FindCmdLineSwitch('e') then
  begin
    MainForm.ExchangeOnly := True;
    //Производим только в том случае, если не была создана "чистая" база
    if not CreateClearDatabase then
      RunExchange([ eaGetPrice]);
    Application.Terminate;
  end;
  //"Безмолвное импортирование" - производится в том случае, если была получена новая версия программы при
  if FindCmdLineSwitch('si') then
  begin
    MainForm.ExchangeOnly := True;
    //Производим только в том случае, если не была создана "чистая" база
    if not CreateClearDatabase then
      RunExchange([ eaImportOnly]);
    Application.Terminate;
  end;

  if adtParams.FieldByName('HTTPNameChanged').AsBoolean then
    MainForm.DisableByHTTPName;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  WriteExchangeLog('AnalitF', 'Попытка закрыть программу.');
  if not MainConnection.Connected then exit;

  try
    adtParams.Edit;
    adtParams.FieldByName( 'ClientId').Value := adtClients.FieldByName( 'ClientId').Value;
    adtParams.Post;
  except
    on E : Exception do
      AProc.LogCriticalError('Ошибка при изменении ClientId: ' + E.Message);
  end;
  ResetStarted;
  WriteExchangeLog('AnalitF', 'Программа закрыта.');
end;

procedure TDM.ClientChanged;
begin
  MainForm.CurrentUser := adtClients.FieldByName( 'Name').AsString;
  //Закрываем все формы перед сменой клиента, т.к. их вид зависит от клиента 
  MainForm.FreeChildForms;
  MainForm.SetOrdersInfo;
  DoPost(adtParams, True);
end;

{ Проверки на невозможность запуска программы }
procedure TDM.CheckRestrictToRun;
var
  MaxUsers, ProcessCount: integer;
  FreeAvail,
  Total,
  TotalFree,
  DBFileSize : Int64;
  Kbd: HKL;
begin
  //Если попытка загрузить клавиатуру окажется удачной, то делаем ее активной
  Kbd := LoadKeyboardLayout('00000419', 0);
  if Kbd<>0 then
    ActivateKeyboardLayout(Kbd,0);

  if GetDisplayColors < 16 then
    LogExitError('Не возможен запуск программы с текущим качеством цветопередачи. Минимальное качество цветопередачи : 16 бит.', Integer(ecColor));

  if not TCPPresent then
    LogExitError('Не возможен запуск программы без установленной библиотеки Windows Sockets версии 2.0.', Integer(ecTCPNotExists));

  if not LoadSevenZipDLL then
    LogExitError('Не найдена библиотека 7-zip32.dll, необходимая для работы программы.', Integer(ecSevenZip));

  if not IdSSLOpenSSLHeaders.Load then
    LogExitError('Не найдены библиотеки libeay32.dll и ssleay32.dll, необходимые для работы программы.', Integer(ecSSLOpen));

  DM.MainConnection.Open;
  try
    MaxUsers := DM.adtClients.FieldByName( 'MaxUsers').AsInteger;
    FGetCatalogsCount := GetCatalogsCount;
    try
      MyServerControl.ShowProcessList();
      ProcessCount := MyServerControl.RecordCount;
    finally
      MyServerControl.Close;
    end;
  finally
    DM.MainConnection.Close;
  end;
  if ( MaxUsers > 0) and ( ProcessCount > MaxUsers)
  then
    LogExitError(Format( 'Исчерпан лимит на подключение к базе данных (копий : %d). ' +
      'Запуск программы невозможен.', [ MaxUsers]), Integer(ecUserLimit));

{
  todo: надо восстановить это
  if GetDiskFreeSpaceEx(PChar(ExtractFilePath(ParamStr(0))), FreeAvail, Total, @TotalFree) then begin
    DBFileSize := GetFileSize(MainConnectionOld.DBName);
    DBFileSize := Max(2*DBFileSize, 200*1024*1024);
    if DBFileSize > FreeAvail then
      LogExitError(Format( 'Недостаточно свободного места на диске для запуска приложения. Необходимо %d байт.', [ DBFileSize ]), Integer(ecFreeDiskSpace));
  end
  else
    LogExitError(Format( 'Не удается получить количество свободного места на диске.' +
      #13#10#13#10'Сообщение об ошибке:'#13#10'%s', [ SysErrorMessage(GetLastError) ]), Integer(ecGetFreeDiskSpace));
}

  NeedUpdateByCheckUIN := not CheckCopyIDFromDB;
  if NeedUpdateByCheckUIN then begin
    DM.MainConnection.Open;
    try
      adtParams.Edit;
      adtParams.FieldByName('HTTPNameChanged').AsBoolean := True;
      adtParams.FieldByName('CDS').AsString := '';
      adtParams.Post;
    finally
      DM.MainConnection.Close;
    end;
    MainForm.DisableByHTTPName;
    AProc.MessageBox( 'Ошибка проверки подлинности программы. Необходимо выполнить обновление данных.',
      MB_ICONERROR or MB_OK);
    DM.MainConnection.Open;
    try
      if (Trim( adtParams.FieldByName( 'HTTPName').AsString) = '') then
        ShowConfig( True );
    finally
      DM.MainConnection.Close;
    end;
  end;

  NeedUpdateByCheckHashes := not CheckCriticalLibrary;
  if NeedUpdateByCheckHashes then
    AProc.MessageBox( 'Ошибка проверки подлинности компонент программы. Необходимо выполнить обновление данных.',
      MB_ICONERROR or MB_OK);
end;

procedure TDM.CompactDataBase();
begin
  MainConnection.Open;
  try
    MyServerControl.OptimizeTable;
    try
      MainConnection.ExecSQL('update params set LastCompact = :LastCompact where ID = 0', [Now]);
    except
      on E : Exception do
        Tracer.TR('BackupRestore', 'Не получилось обновить LastCompact: ' + E.Message);
    end;
  finally
    MainConnection.Close;
  end;
end;

//загружает отчет и выводит на экран или печатает; если указан DataSet, то
//блокируется визуальное перемещение по нему и происходит возврат на первичную запись
procedure TDM.ShowFastReport(FileName: string; DataSet: TDataSet = nil;
  APreview: boolean = False; PrintDlg: boolean = True);
var
  Mark: TBookmarkStr;
begin
  //находим и проверяем полное имя файла; загружаем файл
  FileName:=Trim(FileName);
  if FileName<>'' then begin
    FileName:=ExePath+FileName;
    if not FileExists(FileName) then
      raise Exception.Create( 'Файл не найден:'+#13+FileName);
    frReport.LoadFromFile(FileName);
  end;
  //находим набор данных для табличной части для того, чтобы сделать невидимым
  //передвижение по нему в процессе построения отчета и вернуться на старую запись
  if (DataSet<>nil) and DataSet.Active then begin
    Mark:=DataSet.BookMark;
    DataSet.DisableControls;
  end;
  try

    if not APreview then begin
      frReport.PrepareReport;
      if PrintDlg then
        frReport.PrintPreparedReportDlg
      else
        frReport.PrintPreparedReport( '', 1, False, frAll);
    end
    else
      frReport.ShowReport;
  finally
    if (DataSet<>nil) and DataSet.Active then begin
      DataSet.BookMark:=Mark;
      DataSet.EnableControls;
    end;
  end;
end;

procedure TDM.adtClientsOldAfterOpen(DataSet: TDataSet);
var
  mi :TMenuItem;
  LastClientId : Integer;
  MaxClientNameWidth, CurrentClientNameWidth : Integer;
begin
  if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
  then begin
    adtClients.First;
    adtParams.Edit;
    adtParams.FieldByName( 'ClientId').Value := adtClients.FieldByName( 'ClientId').Value;
    adtParams.Post;
  end;

  //Заполняем PopupMenu клиентов
  MainForm.pmClients.Items.Clear;
  LastClientId := adtClients.FieldByName( 'ClientId').AsInteger;
  adtClients.First;
  MaxClientNameWidth := 0;
  while not adtClients.Eof do begin
    mi := TMenuItem.Create(MainForm.pmClients);
    mi.Name := 'miClient' + adtClients.FieldByName('ClientId').AsString;
    mi.Caption := adtClients.FieldByName('Name').AsString;
    mi.Tag := adtClients.FieldByName('ClientId').AsInteger;
    mi.Checked := LastClientId = adtClients.FieldByName('ClientId').AsInteger;

    mi.OnClick := MainForm.OnSelectClientClick;
    MainForm.pmClients.Items.Add(mi);

    CurrentClientNameWidth := MainForm.ToolBar.Canvas.TextWidth(adtClients.FieldByName('Name').AsString);
    if CurrentClientNameWidth > MaxClientNameWidth then
      MaxClientNameWidth := CurrentClientNameWidth;
    adtClients.Next;
  end;
  MainForm.MaxClientNameWidth := MaxClientNameWidth;
  //Восстанавливаем выбранного клиента
  adtClients.Locate('ClientId', LastClientId, []);
  ClientChanged;
end;

//подключает в качестве внешних текстовые таблицы из папки In
procedure TDM.LinkExternalTables;
const
  ExcludeExtTables : array[0..9] of string =
  ('EXTCORE', 'EXTSYNONYM', 'EXTREGISTRY', 'EXTMINPRICES',
   'EXTCATALOGFARMGROUPS', 'EXTCATALOG', 'EXTCATDEL', 'EXTCATFARMGROUPSDEL',
   'EXTCATALOGNAMES', 'EXTPRODUCTS');
var
  SR: TSearchRec;
  FileName,
  ShortName : String;
  Files : TStringList;
  Tables : TStringList;
  I : Integer;

  function NeedImport(TableName : String) : Boolean;
  var
    I : Integer;
  begin
    for I := Low(ExcludeExtTables) to High(ExcludeExtTables) do
      if ExcludeExtTables[i] = TableName then begin
        Result := False;
        Exit;
      end;
    Result := True;
  end;

begin
  if FindFirst(ExePath+SDirIn+'\*.txt',faAnyFile,SR)=0 then begin
    Screen.Cursor:=crHourglass;
    Files := TStringList.Create;
    Tables := TStringList.Create;
    try
        //Сначала очистили внешние таблицы от предыдущих данных
        repeat
          FileName := ExePath+SDirIn+ '\' + SR.Name;
          ShortName := ChangeFileExt(SR.Name,'');

          //Проверяем, что существует временная таблица для импорта в базе
          adcUpdate.SQL.Text := 'select * from information_schema.tables where table_schema = ''analitf'' and table_name = :tablename';
          adcUpdate.ParamByName('tablename').Value := 'tmp' + ShortName;
          adcUpdate.Execute;
          if adcUpdate.RecordCount = 1 then begin
            adcUpdate.Close;

            adcUpdate.SQL.Text := 'delete from tmp' + ShortName;
            adcUpdate.Execute;

            Tracer.TR('CreateExternal', ShortName);

            Files.Add(FileName);
            Tables.Add(UpperCase(ShortName));
          end
          else
            adcUpdate.Close;
        until FindNext(SR)<>0;
        FindClose(SR);

        for I := 0 to Files.Count-1 do begin
          if NeedImport(Tables[i]) then begin
            adcUpdate.SQL.Text := GetLoadDataSQL('tmp' + Tables[i], Files[i]);
            adcUpdate.Execute;
          end;
        end;

    finally
      Files.Free;
      Tables.Free;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

//отключает все подключенные внешние таблицы
procedure TDM.UnLinkExternalTables;
{$ifndef DEBUG}
var
  I: Integer;
  Tables : TStringList;
{$endif}
begin
{$ifndef DEBUG}
  //Заполняем список со всеми временными таблицами (префикс tmp) и удаляем из них данные
  Tables := TStringList.Create();
  try
    //Проверяем, что существует временная таблица для импорта в базе
    adcUpdate.SQL.Text := 'select table_name from information_schema.tables where table_schema = ''analitf'' and table_name like "tmp%"';
    adcUpdate.Open;
    try
      while not adcUpdate.Eof do begin
        Tables.Add(adcUpdate.FieldByName('table_name').AsString);
        adcUpdate.Next;
      end;
    finally
      adcUpdate.Close;
    end;

    for I := 0 to Tables.Count-1 do begin
      adcUpdate.SQL.Text := 'delete from ' + Tables[i];
      adcUpdate.Execute;
    end;

  finally
    Tables.Free;
  end;
{$endif}
end;

procedure TDM.ClearDatabase;
begin
  Screen.Cursor:=crHourglass;
  with adcUpdate do try

    MainForm.StatusText:='Очищается MinPrices';
    SQL.Text:='DELETE FROM MinPrices;'; Execute;
    MainForm.StatusText:='Очищается Core';
    SQL.Text:='DELETE FROM Core;'; Execute;
    MainForm.StatusText:='Очищается Catalog';
    SQL.Text:='DELETE FROM CATALOGS;'; Execute;
    MainForm.StatusText:='Очищается CatalogNames';
    SQL.Text:='DELETE FROM catalognames;'; Execute;
    MainForm.StatusText:='Очищается CatalogFarmGroups';
    SQL.Text:='delete from CATALOGFARMGROUPS;'; Execute;
    MainForm.StatusText:='Очищается Products';
    SQL.Text:='delete from Products;'; Execute;
    MainForm.StatusText:='Очищается PricesRegionalData';
    SQL.Text:='DELETE FROM PricesRegionalData;'; Execute;
    MainForm.StatusText:='Очищается PricesData';
    SQL.Text:='DELETE FROM PricesData;'; Execute;
    MainForm.StatusText:='Очищается RegionalData';
    SQL.Text:='DELETE FROM RegionalData;'; Execute;
    MainForm.StatusText:='Очищается Providers';
    SQL.Text:='DELETE FROM Providers;'; Execute;
    MainForm.StatusText:='Очищается Synonym';
    SQL.Text:='DELETE FROM Synonyms;'; Execute;
    MainForm.StatusText:='Очищается SynonymFirmCr';
    SQL.Text:='DELETE FROM SynonymFirmCr;'; Execute;
    MainForm.StatusText:='Очищается Defectives';
    SQL.Text:='DELETE FROM Defectives;'; Execute;

  finally
    Screen.Cursor:=crDefault;
    MainForm.StatusText:='';
  end;
end;

procedure TDM.DeleteEmptyOrders;
begin
  Screen.Cursor:=crHourglass;
  try
    with adcUpdate do begin
      SqL.Text:='DELETE FROM OrdersList WHERE OrderCount=0'; Execute;
      SQL.Text:='DELETE FROM OrdersHead WHERE NOT Exists(SELECT OrderId FROM OrdersList WHERE OrderId=OrdersHead.OrderId)'; Execute;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TDM.BackupDatabase;
begin
  if TCustomMyConnection(MainConnection) is TMyEmbConnection then begin
    MainConnection.Close;
    CopyDataDirToBackup(ExePath + SDirData, ExePath + SDirDataBackup);
    MainConnection.Open;
  end;
end;

function TDM.IsBackuped : Boolean;
begin
  if TCustomMyConnection(MainConnection) is TMyEmbConnection then
    Result := DirectoryExists(ExePath + SDirDataBackup)
  else
    Result := False;
end;

procedure TDM.RestoreDatabase;
var
  FEmbConnection : TMyEmbConnection;
  MyServerControl : TMyServerControl;
begin
  if TCustomMyConnection(MainConnection) is TMyEmbConnection then begin
    MainConnection.Close;

    FEmbConnection := TMyEmbConnection.Create(nil);
    try
      FEmbConnection.Database := MainConnection.Database;
      FEmbConnection.Username := MainConnection.Username;
      FEmbConnection.DataDir := TMyEmbConnection(MainConnection).DataDir;
      FEmbConnection.Options := TMyEmbConnection(MainConnection).Options;
      FEmbConnection.Params.Clear;
      FEmbConnection.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
      FEmbConnection.LoginPrompt := False;
      try
        MyServerControl := TMyServerControl.Create(nil);
        try
          MyServerControl.Connection := FEmbConnection;
          MyServerControl.DropDatabase('analitf');
          MyServerControl.DropDatabase('mysql');
        finally
          MyServerControl.Free;
        end;
      finally
        FEmbConnection.Close;
        //FEmbConnection.RemoveFromPool;
      end;
    finally
      FEmbConnection.Free;
    end;
    
    //удаляем директорию
    DeleteDataDir(ExePath + SDirData);

    //копируем данные из эталонной копии
    MoveDirectories(ExePath + SDirDataBackup, ExePath + SDirData);
    
    MainConnection.Open;
  end;
end;

procedure TDM.ClearBackup;
begin
  if TCustomMyConnection(MainConnection) is TMyEmbConnection then
  begin
    DeleteDirectory(ExePath + SDirDataPrev);
    MoveDirectories(ExePath + SDirDataBackup, ExePath + SDirDataPrev);
  end;
end;

function TDM.GetCumulative: boolean;
begin
  try
    result := adtParams.FieldByName( 'Cumulative').AsBoolean;
  except
    result := False;
  end;
end;

procedure TDM.ResetCumulative;
begin
  try
    adtParams.Edit;
    adtParams.FieldByName( 'Cumulative').AsBoolean := False;
    adtParams.Post;
  except
  end;
end;

procedure TDM.SetCumulative;
begin
  try
    adtParams.Edit;
    adtParams.FieldByName( 'Cumulative').AsBoolean := True;
    adtParams.Post;
  except
  end;
end;

function TDM.GetStarted: Boolean;
begin
  try
    result := adtParams.FieldByName( 'Started').AsBoolean;
  except
    result := False;
  end;
end;

procedure TDM.ResetStarted;
begin
  try
    adtParams.Edit;
    adtParams.FieldByName( 'Started').AsBoolean := False;
    adtParams.Post;
  except
  end;
end;

procedure TDM.SetStarted;
begin
  try
    adtParams.Edit;
    adtParams.FieldByName( 'Started').AsBoolean := True;
    adtParams.Post;
  except
  end;
end;

procedure TDM.MainConnectionOldAfterConnect(Sender: TObject);
begin
  MainConnection.ExecSQL('use analitf', []);
  //открываем таблицы с параметрами
  adtParams.Close;
  adtParams.Open;
  ReadPasswords;
  adtClients.Close;
  adtClients.Open;
  adsRetailMargins.Close;
  adsRetailMargins.Open;
  LoadRetailMargins;
  LoadSelectedPrices;
end;

procedure TDM.SweepDB;
begin
{
  MainConnection1.Close;
  try
    with ValidService do
    begin
      ServerName := '';
      DatabaseName := MainConnection1.DBName;
      Params.Clear;
      Params.Add('user_name=' + MainConnection1.ConnectParams.UserName);
      Params.Add('password=' + MainConnection1.ConnectParams.Password);
      Active := True;
      try
        Tracer.TR('Sweep', 'Try sweep DB');
        ServiceStart;
        While not Eof do
          Tracer.TR('Sweep', GetNextLine);
      finally
        Active := False;
      end;
    end;
  finally
    MainConnection1.Open;
  end;
  }
end;

function TDM.GetDisplayColors: Integer;
var
  tHDC: hdc;
begin
  tHDC := GetDC(0);
  result := GetDeviceCaps(tHDC, BITSPIXEL);
  ReleaseDC(0, tHDC);
end;

function TDM.TCPPresent: Boolean;
var
  hWS : THandle;
begin
  try
    hWS := LoadLibrary('ws2_32.dll');
    Result := hWS <> 0;
    if Result then
      FreeLibrary(hWS);
  except
    Result := False;
  end;
end;

function TDM.NeedCommitExchange: Boolean;
begin
  Result := FNeedCommitExchange;
end;

procedure TDM.ResetNeedCommitExchange;
begin
  FNeedCommitExchange := False;
  FServerUpdateId := '';
end;

procedure TDM.SetNeedCommitExchange();
begin
  FNeedCommitExchange := True;
end;

procedure TDM.ReadPasswords;
var
  SaveGridMaskStr : String;
begin
  try
    SynonymPassword := Copy(adtParams.FieldByName('CDS').AsString, 1, 64);
    CodesPassword := Copy(adtParams.FieldByName('CDS').AsString, 65, 64);
    BasecostPassword := Copy(adtParams.FieldByName('CDS').AsString, 129, 64);
    DBUIN := Copy(adtParams.FieldByName('CDS').AsString, 193, 32);
    SynonymPassword := PassC.DecodeHex(SynonymPassword);
    CodesPassword := PassC.DecodeHex(CodesPassword);
    BasecostPassword := PassC.DecodeHex(BasecostPassword);
    DBUIN := PassC.DecodeHex(DBUIN);
    SaveGridMaskStr := '$' + Copy(DBUIN, 9, 7);
    DBUIN := Copy(DBUIN, 1, 8);
    SaveGridMask := StrToIntDef(SaveGridMaskStr, 0);
  except
    SynonymPassword := '';
    CodesPassword := '';
    BasecostPassword := '';
    DBUIN := '';
  end;

  SynC.UpdateKey(SynonymPassword);
  CodeC.UpdateKey(CodesPassword);
  BasecostC.UpdateKey(BasecostPassword);
end;

procedure TDM.SavePass(ASyn, ACodes, AB, ASGM: String);
{
var
  Price : String;
  tmps,
  tmpc,
  tmpb,
  tmpvb : TINFCrypt;
}  
begin
{
  todo: Это пока не нужно, т.к. цену у нас не шифруются и перешифровывать ничего не надо
  if (SynonymPassword <> ASyn) or (CodesPassword <> ACodes) or (BaseCostPassword <> AB) then
    try
      if adsAllOrders.Active then
        adsAllOrders.Close;
      tmps := TINFCrypt.Create(ASyn, 300);
      tmpc := TINFCrypt.Create(ACodes, 60);
      tmpb := TINFCrypt.Create(AB, 50);
      tmpvb := TINFCrypt.Create(LeftStr(ASyn, 4) + RightStr(AB, 4) + Copy(ACodes, 5, 8), 50);
      try
        adsAllOrders.Open;
        while not adsAllOrders.Eof do begin

          Price := D_B_N(adsAllOrdersPRICE.AsString);

          Price := E_B_N(tmpb, Price);

          adsAllOrders.Edit;

          adsAllOrdersPRICE.AsString := Price;

          adsAllOrders.Post;

          adsAllOrders.Next;
        end;
      finally
        adsAllOrders.Close;
        tmps.Free;
        tmpc.Free;
        tmpb.Free;
        tmpvb.Free;
      end;
    except
      on E : Exception do begin
        Tracer.TR('SavePass', 'Error : ' + E.Message);
      end;
    end;
}

  SynonymPassword := ASyn;
  CodesPassword := ACodes;
  BaseCostPassword := AB;
  SynC.UpdateKey(SynonymPassword);
  CodeC.UpdateKey(CodesPassword);
  BasecostC.UpdateKey(BasecostPassword);
  adtParams.Edit;
  adtParams.FieldByName('CDS').AsString :=
    PassC.EncodeHex(SynonymPassword) +
    PassC.EncodeHex(CodesPassword) +
    PassC.EncodeHex(BaseCostPassword) +
    PassC.EncodeHex(IntToHex(GetDBID(), 8) + ASGM);
  adtParams.Post;
end;

procedure TDM.s3cf(DataSet: TDataSet);
begin
  try
    //adsRepareOrdersCryptPRICE.AsCurrency := StrToFloat(DM.D_B_N(adsRepareOrdersPRICE.AsString));
  except
  end;
end;

function TDM.GetPriceRet(BaseCost: Currency): Currency;
begin
  Result := (1 + GetRetUpCost(BaseCost)/100)*BaseCost;
end;

procedure TDM.LoadRetailMargins;
var
  I : Integer;
begin
  SetLength(FRetMargins, adsRetailMargins.RecordCount);
  adsRetailMargins.First;
  I := 0;
  while not adsRetailMargins.Eof do begin
    FRetMargins[i][1] := adsRetailMarginsLEFTLIMIT.AsCurrency;
    FRetMargins[i][2] := adsRetailMarginsRIGHTLIMIT.AsCurrency;
    FRetMargins[i][3] := adsRetailMarginsRETAIL.Value;
    Inc(I);
    adsRetailMargins.Next;
  end;
end;

procedure TDM.adsRetailMarginsOldLEFTLIMITChange(Sender: TField);
begin
//  adsRetailMargins.DoSort(['LEFTLIMIT'], [True]);
end;

procedure TDM.socf(DataSet: TDataSet);
var
  S : String;
begin
  try
    S := D_B_N(adsSumOrdersOldForDeletePRICE.AsString);
    adsSumOrdersOldForDeleteCryptPRICE.AsCurrency := StrToCurr(S);
    adsSumOrdersOldForDeleteSumOrders.AsCurrency := StrToCurr(S) * adsSumOrdersOldForDeleteORDERCOUNT.AsInteger;
  except
  end;
end;

function TDM.GetSumOrder(AOrderID: Integer): Currency;
begin
  try
    Result := DM.QueryValue(
      'SELECT ifnull(Sum(OrdersList.price*OrdersList.OrderCount), 0) SumOrder '
      + 'FROM OrdersList '
      + 'WHERE OrdersList.OrderId = :OrderId AND OrdersList.OrderCount>0',
      ['OrderId'],
      [AOrderID]);
  except
    Result := 0;
  end;
end;

function TDM.CheckCopyIDFromDB: Boolean;
begin
  Result := DBUIN = IntToHex(GetDBID, 8);
  if not Result then begin
    Result := (DBUIN = '') and (FGetCatalogsCount = 0);
  end;
end;

function TDM.GetCatalogsCount: Integer;
begin
  try
    Result := QueryValue('SELECT COUNT(*) AS CatNum FROM Catalogs', [], []);
  except
    Result := 0;
  end;
end;

{ TSelectPrice }

constructor TSelectPrice.Create(APriceCode, ARegionCode: Integer; ASelected: Boolean;
  APriceName: String);
begin
  PriceCode := APriceCode;
  RegionCode := ARegionCode;
  Selected := ASelected;
  PriceName := APriceName;
end;

procedure TDM.LoadSelectedPrices;
begin
  ClearSelectedPrices(SummarySelectedPrices);
  ClearSelectedPrices(SynonymSelectedPrices);
  adsPrices.IndexFieldNames := 'PRICENAME';
  if adsPrices.Active then
    adsPrices.Close;
  adsPrices.Open;
  try
    adsPrices.First;
    while not adsPrices.Eof do begin
      SummarySelectedPrices.AddObject(adsPricesPRICECODE.AsString + '_' + adsPricesREGIONCODE.AsString, TSelectPrice.Create(adsPricesPRICECODE.AsInteger, adsPricesREGIONCODE.AsInteger, True, adsPricesPRICENAME.Value));
      SynonymSelectedPrices.AddObject(adsPricesPRICECODE.AsString + '_' + adsPricesREGIONCODE.AsString, TSelectPrice.Create(adsPricesPRICECODE.AsInteger, adsPricesREGIONCODE.AsInteger, True, adsPricesPRICENAME.Value));
      adsPrices.Next;
    end;
  finally
    adsPrices.Close;
  end;
end;

function TDM.CheckCriticalLibrary: Boolean;
var
  I : Integer;
  libname, libfilename, hash, caclhash : String;
begin
  Result := True;
  for I := low(CriticalLibraryHashes) to High(CriticalLibraryHashes) do begin
    libname := CriticalLibraryHashes[i][0];
    hash := CriticalLibraryHashes[i][1] + CriticalLibraryHashes[i][2] + CriticalLibraryHashes[i][3] + CriticalLibraryHashes[i][4];
    libfilename := GetModuleName(GetModuleHandle(PChar(libname)));
    caclhash := GetFileHash(libfilename);
    if caclhash <> hash then begin
      Result := False;
      exit;
    end;
  end;
end;

function TDM.GetFileHash(AFileName: String): String;
var
  md5 : TIdHashMessageDigest5;
  fs : TFileStream;
begin
  md5 := TIdHashMessageDigest5.Create;
  try

    fs := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
    try
      Result := md5.HashStreamAsHex(fs);
    finally
      fs.Free;
    end;

  finally
    md5.Free;
  end;
end;

function TDM.D_B_N(BaseC: String): String;
{
var
  tmp : String;
  Len : Integer;
}  
begin
  result := D_B_N_C(BasecostC, BaseC);
{
  Len := Length(BaseC);
  if Len > 6 then begin

    tmp := BaseC[1] + Copy(BaseC, 3, Len-6) + Copy(BaseC, Len-2, 3);
    if Length(tmp) > 1 then begin
      Result := BasecostC.DecodeMix(tmp);
      Result := StringReplace(Result, '.', DM.FFS.DecimalSeparator, [rfReplaceAll]);
    end
    else
      Result := '';
  end
  else
    Result := '';
}    
end;

function TDM.D_HP(HTTPPassC: String): String;
var
  tmp : String;
begin
  if Length(HTTPPassC) > 3 then begin
    tmp := HTTPPassC[2] + Copy(HTTPPassC, 4, Length(HTTPPassC));
    if Length(tmp) > 1 then begin
      Result := HTTPC.DecodeMix(tmp);
    end
    else
      Result := '';
  end
  else
    Result := '';
end;

function TDM.E_HP(HTTPPass: String): String;
begin
  Result := HTTPC.EncodeMix( HTTPPass );

  if Length(Result) > 2 then
    Result := chr(random(110) + 32) + Result[1] + chr(random(110) + 32) + Copy(Result, 2, Length(Result))
  else
    Result := '';
end;

procedure TDM.UpdateDB;
var
  dbCon : TMyEmbConnection;
  DBVersion : Integer;
  EtlName : String;
begin
  dbCon := TMyEmbConnection.Create(nil);
  try

    dbCon.Database := MainConnection.Database;
    dbCon.Username := MainConnection.Username;
    dbCon.DataDir := TMyEmbConnection(MainConnection).DataDir;
    dbCon.Options := TMyEmbConnection(MainConnection).Options;
    dbCon.Params.Clear;
    dbCon.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
    dbCon.LoginPrompt := False;

{$ifdef DEBUG}
    try
      dbCon.Database := 'analitf';
      dbCon.Open;
      try
        ExtractDBScript(dbCon);
      finally
        dbCon.Close;
      end;
    finally
      dbCon.Database := '';
    end;
{$endif}

    dbCon.Open;
    try
      DBVersion := DBProc.QueryValue(dbCon, 'select ProviderMDBVersion from analitf.params where id = 0', [], []);
    finally
      dbCon.Close;
      //dbCon.RemoveFromPool;
    end;

    //Мы получим с обновлением версию 49 и обновляем ее до 50
    if DBVersion = 49 then begin
      RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateFirebirdToMySql, nil);
      DBVersion := 50;
    end;

    if DBVersion <> CURRENT_DB_VERSION then
      raise Exception.CreateFmt('Версия базы данных %d не совпадает с необходимой версией %d.', [DBVersion, CURRENT_DB_VERSION])
    //Если у нас не отладочная версия, то влючаем проверку целостности базы данных
{$ifndef DEBUG}
    else
      RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, CheckDBObjects, nil, 'Происходит проверка базы данных. Подождите...');
{$else}
      ;
{$endif}

    //todo: Ддя MySql это будет включено в следующем обновлении 
    //Если было произведено обновление программы, то обновляем ключи
//    if FindCmdLineSwitch('i') or FindCmdLineSwitch('si') then
//      UpdateDBUIN(dbCon);

  finally
    dbCon.Free;
  end;
end;

procedure TDM.UpdateDBFile(dbCon: TpFIBDatabase; trMain: TpFIBTransaction;
  FileName: String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
var
 FIBScript : TpFIBScript;
 CompareScript: TResourceStream;
 CurrentDBVersion : Integer;

begin
  dbCon.DBName := FileName;
  dbCon.Open;
  try
    FIBScript := TpFIBScript.Create(nil);
    FIBScript.Database := dbCon;
    FIBScript.Transaction := trMain;
    FIBScript.SQLDialect := dbCon.SQLDialect;
    //Авто-коммит после каждого DDL-запроса
    FIBScript.AutoDDL := True;

    try

      //Иногда может получиться так, что мы обновили эталонную копию, но не обновили файл
      //Этим мы это проверяем
      CurrentDBVersion := dbCon.QueryValue('select mdbversion from provider where id = 0', 0);
      if CurrentDBVersion > OldDBVersion then
        Exit;

      CompareScript := TResourceStream.Create( hInstance, 'COMPARESCRIPT' + IntToStr(OldDBVersion), RT_RCDATA);
      try
        FIBScript.Script.LoadFromStream(CompareScript);
      finally
        try CompareScript.Free; except end;
      end;

      FIBScript.OnParseError := OnScriptParseError;
      try
        FIBScript.ValidateScript;
      finally
        FIBScript.OnParseError := nil;
      end;

      FIBScript.OnExecuteError := OnScriptExecuteError;
      try
        FIBScript.ExecuteScript;
      finally
        FIBScript.OnExecuteError := nil;
      end;

{
      if Assigned(AOnUpdateDBFileData) then
        AOnUpdateDBFileData(dbCon, trMain);
}        

    finally
      try FIBScript.Free; except  end;
    end;

  finally
    try dbCon.Close; except end;
  end;
end;

procedure TDM.OnScriptParseError(Sender: TObject; Error, SQLText: string;
  LineIndex: Integer);
begin
  raise Exception.CreateFmt('Ошибка при разборе скрипта: %s'#13#10'SQL: %s'#13#10'Номер строки: %d', [Error, SQLText, LineIndex]);
end;

procedure TDM.OnScriptExecuteError(Sender: TObject; Error, SQLText: string;
  LineIndex: Integer; var Ignore: Boolean);
begin
  raise Exception.CreateFmt('Ошибка при выполнении скрипта: %s'#13#10'SQL: %s'#13#10'Номер строки: %d', [Error, SQLText, LineIndex]);
end;

function TDM.D_B_N_OLD(c : TINFCrypt; BaseC: String): String;
var
  tmp : String;
begin
  if Length(BaseC) > 3 then begin
    tmp := BaseC[2] + Copy(BaseC, 4, Length(BaseC));
    if Length(tmp) > 1 then begin
      Result := c.DecodeMix(tmp);
      Result := StringReplace(Result, '.', DM.FFS.DecimalSeparator, [rfReplaceAll]);
    end
    else
      Result := '';
  end
  else
    Result := '';
end;

function TDM.E_B_N_OLD(c : TINFCrypt; BaseCost: String): String;
begin
  Result := StringReplace(BaseCost, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
  Result := c.EncodeMix( Result );

  if Length(Result) > 2 then
    Result := chr(random(110) + 32) + Result[1] + chr(random(110) + 32) + Copy(Result, 2, Length(Result))
  else
    Result := '';
end;

function TDM.E_B_N(c: TINFCrypt; BaseCost: String): String;
var
  Len : Integer;
begin
  Result := StringReplace(BaseCost, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
  Result := c.EncodeMix( Result );

  Len := Length(Result);

  if Length(Result) > 3 then
    Result := Result[1] + chr(random(110) + 32) + Copy(Result, 2, Len-4)+ chr(random(110) + 32) + Copy(Result, Len-2, 3)
  else
    Result := '';
end;

{$ifdef DEBUG}
procedure TDM.UpdateDBFileDataFor35(dbCon: TpFIBDatabase;
  trMain: TpFIBTransaction);
var
  adsAllOrdersUpdate : TpFIBDataSet;
  CDS,
  BaseCostPass,
  Price : String;
  bc : TINFCrypt;
  AllCount,
  CryptErrorCount : Integer;
begin
  adsAllOrdersUpdate := TpFIBDataSet.Create(nil);

  try
    adsAllOrdersUpdate.Database := dbCon;
    adsAllOrdersUpdate.Transaction := trMain;
    adsAllOrdersUpdate.UpdateTransaction := trMain;
    adsAllOrdersUpdate.SelectSQL.Text := 'SELECT ORDERS.* FROM ORDERS';
    adsAllOrdersUpdate.UpdateSQL.Text := 'UPDATE ORDERS SET PRICE = :PRICE, CODE = :CODE, CODECR = :CODECR WHERE ID = :OLD_ID';
    adsAllOrdersUpdate.Options := adsAllOrdersUpdate.Options - [poTrimCharFields];

    trMain.StartTransaction;

    try
      CDS := dbCon.QueryValue('select CDS from params where ID = 0', 0);
      //Если это поле пустое, то ничего не делаем, предполагая, что база пустая
      if Length(CDS) = 0 then
        Exit;
      BaseCostPass := PassC.DecodeHex(Copy(CDS, 129, 64));
      if Length(BaseCostPass) = 0 then
        raise Exception.Create('Нет необходимой информации.');
    except
      on E : Exception do
       raise Exception.CreateFmt('Невозможно произвести обновление данных: %s', [E.Message]);
    end;

    bc := TINFCrypt.Create(BaseCostPass, 50);
    try

      CryptErrorCount := 0;

      adsAllOrdersUpdate.Open;

      while not adsAllOrdersUpdate.Eof do begin

        try
          Price := D_B_N_OLD(bc, adsAllOrdersUpdate.FieldByName('PRICE').AsString);

          Price := E_B_N(bc, Price);

          adsAllOrdersUpdate.Edit;
          adsAllOrdersUpdate.FieldByName('PRICE').AsString := Price;
          adsAllOrdersUpdate.Post;
        except
          on E : Exception do
            Inc(CryptErrorCount)
        end;

        adsAllOrdersUpdate.Next;
      end;

      AllCount := adsAllOrdersUpdate.RecordCount;

      adsAllOrdersUpdate.Close;

      if CryptErrorCount > 0 then
        AProc.LogCriticalError('Количество нерасшифрованных позиций в заказах : ' + IntToStr(CryptErrorCount) + ' Всего позиций : ' + IntToStr(AllCount));

    finally
      try bc.Free except end;
    end;

    trMain.Commit;

  finally
    try adsAllOrdersUpdate.Free; except end;
  end;
end;
{$endif}

procedure TDM.CheckDBFile;
var
  OpenSuccess : Boolean;
  RecoveryCount : Integer;
begin
  OpenSuccess := False;
  RecoveryCount := 0;
  try
    repeat
    try

      UpdateDB();

      OpenSuccess := True;

    except
      on E : Exception do begin
        LogCriticalError(Format('Ошибка при открытии (%d): %s', [RecoveryCount, E.Message]));
        if (RecoveryCount < 2) then begin
          try
{
            if MainConnection is TMyEmbConnection then
              MyAPIEmbedded.FreeMySQLLib;
}              
            RecoverDatabase(E);
          except
            on E : Exception do
              if (RecoveryCount < 1) then
                LogCriticalError(Format('Ошибка при восстановлении (%d): %s', [RecoveryCount, E.Message]))
              else
                raise;
          end;
          Inc(RecoveryCount);
        end
        else
          raise;
      end;
    end;
    until OpenSuccess;

  except
    on E : Exception do
      LogExitError(Format( 'Не возможно открыть файл базы данных: %s ', [ E.Message ]), Integer(ecDBFileError));
  end;
end;

{$ifdef DEBUG}
procedure TDM.UpdateDBFileDataFor29(dbCon: TpFIBDatabase;
  trMain: TpFIBTransaction);
var
  qUpdatePass : TpFIBQuery;
  OldPass : String;

  adsAllOrdersUpdate : TpFIBDataSet;
  CDS,
  BaseCostPass,
  CodesPass,
  CodeStr,
  CodeCrStr,
  Price : String;
  bc : TINFCrypt;
  cc : TINFCrypt;
  AllCount,
  CryptErrorCount : Integer;
begin
  qUpdatePass := TpFIBQuery.Create(nil);

  try
    qUpdatePass.Database := dbCon;
    qUpdatePass.Transaction := trMain;

    OldPass := dbCon.QueryValue('select httppass from params where id = 0', 0);

    if Length(OldPass) > 0 then begin
      trMain.StartTransaction;
      qUpdatePass.SQL.Text := 'update params set httppass = :httppass where id = 0';
      qUpdatePass.ParamByName('httppass').AsString := E_HP(OldPass);
      qUpdatePass.ExecQuery;

      trMain.Commit;
    end;

  finally
    qUpdatePass.Free;
  end;

  adsAllOrdersUpdate := TpFIBDataSet.Create(nil);

  try
    adsAllOrdersUpdate.Database := dbCon;
    adsAllOrdersUpdate.Transaction := trMain;
    adsAllOrdersUpdate.UpdateTransaction := trMain;
    adsAllOrdersUpdate.SelectSQL.Text := 'SELECT ORDERS.* FROM ORDERS';
    adsAllOrdersUpdate.UpdateSQL.Text := 'UPDATE ORDERS SET PRICE = :PRICE, CODE = :CODE, CODECR = :CODECR WHERE ID = :OLD_ID';
    adsAllOrdersUpdate.Options := adsAllOrdersUpdate.Options - [poTrimCharFields];

    trMain.StartTransaction;

    try
      CDS := dbCon.QueryValue('select CDS from params where ID = 0', 0);
      //Если это поле пустое, то ничего не делаем, предполагая, что база пустая
      if Length(CDS) = 0 then
        Exit;

      BaseCostPass := PassC.DecodeHex(Copy(CDS, 129, 64));
      if Length(BaseCostPass) = 0 then
        raise Exception.Create('Нет необходимой информации 1.');

      CodesPass := PassC.DecodeHex(Copy(CDS, 65, 64));
      if Length(CodesPass) = 0 then
        raise Exception.Create('Нет необходимой информации 2.');
    except
      on E : Exception do
       raise Exception.CreateFmt('Невозможно произвести обновление данных: %s', [E.Message]);
    end;

    bc := TINFCrypt.Create(BaseCostPass, 50);
    cc := TINFCrypt.Create(CodesPass, 60);
    try

      CryptErrorCount := 0;

      adsAllOrdersUpdate.Open;

      while not adsAllOrdersUpdate.Eof do begin

        try
          CodeStr := D_29_C_OLD(cc, adsAllOrdersUpdate.FieldByName('CODE').AsString);
          CodeCrStr := D_29_C_OLD(cc, adsAllOrdersUpdate.FieldByName('CODECR').AsString);

          Price := D_29_B_OLD(bc, adsAllOrdersUpdate.FieldByName('CODE').AsString, adsAllOrdersUpdate.FieldByName('CODECR').AsString);

          Price := E_B_N(bc, Price);

          adsAllOrdersUpdate.Edit;
          adsAllOrdersUpdate.FieldByName('CODE').AsString := CodeStr;
          adsAllOrdersUpdate.FieldByName('CODECR').AsString := CodeCrStr;
          adsAllOrdersUpdate.FieldByName('PRICE').AsString := Price;
          adsAllOrdersUpdate.Post;
        except
          on E : Exception do
            Inc(CryptErrorCount)
        end;

        adsAllOrdersUpdate.Next;
      end;

      AllCount := adsAllOrdersUpdate.RecordCount;

      adsAllOrdersUpdate.Close;

      if CryptErrorCount > 0 then
        AProc.LogCriticalError('Количество нерасшифрованных позиций в заказах : ' + IntToStr(CryptErrorCount) + ' Всего позиций : ' + IntToStr(AllCount));

    finally
      try bc.Free except end;
      try cc.Free except end;
    end;

    trMain.Commit;

  finally
    try adsAllOrdersUpdate.Free; except end;
  end;
end;
{$endif}

function TDM.D_29_C_OLD(c : TINFCrypt; CodeS: String): String;
begin
  CodeS := Copy(CodeS, 1, Length(CodeS)-16);
  if Length(CodeS) >= 16 then
    Result := c.DecodeMix(CodeS)
  else
    Result := CodeS;
end;

function TDM.D_29_B_OLD(c : TINFCrypt; CodeS1, CodeS2: String): String;
var
  tmp : String;
begin
  tmp := RightStr(CodeS1, 16) + RightStr(CodeS2, 16);
  if Length(tmp) > 1 then begin
    Result := c.DecodeHex(tmp);
    Result := StringReplace(Result, '.', DM.FFS.DecimalSeparator, [rfReplaceAll]);
  end
  else
    Result := '';
end;

function TDM.GetRetUpCost(BaseCost: Currency): Integer;
var
  I, Ret : Integer;
begin
  Ret := 0;
  I := 0;
  while (I < Length(FRetMargins)) and (BaseCost >= FRetMargins[i][1]) do begin
    if (FRetMargins[i][1] <= BaseCost) and (BaseCost <= FRetMargins[i][2]) then begin
      Ret := FRetMargins[i][3];
      Break;
    end;
    Inc(I);
  end;
  Result := Ret;
end;

{$ifdef DEBUG}
procedure TDM.UpdateDBFileDataFor36(dbCon: TpFIBDatabase;
  trMain: TpFIBTransaction);
var
  adsAllOrdersUpdate : TpFIBDataSet;
  CDS,
  BaseCostPass,
  SynonymPass,
  CodesPass,
  oldDBUIN,
  newCDS,
  Price : String;
  pc,
  bc : TINFCrypt;
  AllCount,
  CryptErrorCount : Integer;
  p, ch : String;
  I : Integer;
begin
  adsAllOrdersUpdate := TpFIBDataSet.Create(nil);

  try
    adsAllOrdersUpdate.Database := dbCon;
    adsAllOrdersUpdate.Transaction := trMain;
    adsAllOrdersUpdate.UpdateTransaction := trMain;
    adsAllOrdersUpdate.SelectSQL.Text := 'SELECT ORDERS.* FROM ORDERS, ordersh where ordersh.orderid = orders.orderid and ordersh.closed = 1';
    adsAllOrdersUpdate.UpdateSQL.Text := 'UPDATE ORDERS SET SENDPRICE = :SENDPRICE WHERE ID = :OLD_ID';
    adsAllOrdersUpdate.Options := adsAllOrdersUpdate.Options - [poTrimCharFields];

    trMain.StartTransaction;

    try
      CDS := dbCon.QueryValue('select CDS from params where ID = 0', 0);
      ch := IntToHex(GetOld427UniqueID(Application.ExeName, ''), 8);
      p := '';
      for I := 1 to Length(ch) do
        p := p + ch[i] + PassPassW[i];
      pc := TINFCrypt.Create(p, 48);
      //Если это поле пустое, то ничего не делаем, предполагая, что база пустая
      if Length(CDS) = 0 then
        Exit;
      SynonymPass := pc.DecodeHex(Copy(CDS, 1, 64));
      CodesPass := pc.DecodeHex(Copy(CDS, 65, 64));
      BaseCostPass := pc.DecodeHex(Copy(CDS, 129, 64));
      oldDBUIN := pc.DecodeHex(Copy(CDS, 193, 32));

      if Length(BaseCostPass) = 0 then
        raise Exception.Create('Нет необходимой информации.');
      if Length(oldDBUIN) = 0 then
        raise Exception.Create('Нет необходимой информации 2.');
      if oldDBUIN <> ch then
        raise Exception.Create('Не совпадает DBUIN в обновляемой базе данных.');

      //Обновляем значение CDS в базе с новым CopyID
      newCDS :=
        PassC.EncodeHex(SynonymPass) +
        PassC.EncodeHex(CodesPass) +
        PassC.EncodeHex(BaseCostPass) +
        PassC.EncodeHex(IntToHex(GetCopyID, 8));
      dbCon.QueryValue('update params set CDS = :CDS where ID = 0', -1, [newCDS]);
    except
      on E : Exception do
       raise Exception.CreateFmt('Невозможно произвести обновление данных: %s', [E.Message]);
    end;

    bc := TINFCrypt.Create(BaseCostPass, 50);
    try

      CryptErrorCount := 0;

      adsAllOrdersUpdate.Open;

      while not adsAllOrdersUpdate.Eof do begin

        try
          Price := D_B_N_C(bc, adsAllOrdersUpdate.FieldByName('PRICE').AsString);

          adsAllOrdersUpdate.Edit;
          adsAllOrdersUpdate.FieldByName('SENDPRICE').AsCurrency := StrToCurr( Price );
          adsAllOrdersUpdate.Post;
        except
          on E : Exception do
            Inc(CryptErrorCount)
        end;

        adsAllOrdersUpdate.Next;
      end;

      AllCount := adsAllOrdersUpdate.RecordCount;

      adsAllOrdersUpdate.Close;

      if CryptErrorCount > 0 then
        AProc.LogCriticalError('Количество нерасшифрованных позиций в заказах : ' + IntToStr(CryptErrorCount) + ' Всего позиций : ' + IntToStr(AllCount));

    finally
      try bc.Free except end;
    end;

    trMain.Commit;

  finally
    try adsAllOrdersUpdate.Free; except end;
  end;
end;
{$endif}

function TDM.D_B_N_C(c: TINFCrypt; BaseC: String): String;
var
  tmp : String;
  Len : Integer;
begin
  Len := Length(BaseC);
  if Len > 6 then begin

    tmp := BaseC[1] + Copy(BaseC, 3, Len-6) + Copy(BaseC, Len-2, 3);
    if Length(tmp) > 1 then begin
      Result := c.DecodeMix(tmp);
      Result := StringReplace(Result, '.', DM.FFS.DecimalSeparator, [rfReplaceAll]);
    end
    else
      Result := '';
  end
  else
    Result := '';
end;

{$ifdef DEBUG}
procedure TDM.UpdateDBFileDataFor37(dbCon: TpFIBDatabase;
  trMain: TpFIBTransaction);
var
  CDS,
  BaseCostPass,
  SynonymPass,
  CodesPass,
  oldDBUIN,
  newCDS : String;
begin
  trMain.StartTransaction;

  try
    CDS := dbCon.QueryValue('select CDS from params where ID = 0', 0);
    //Если это поле пустое, то ничего не делаем, предполагая, что база пустая
    if Length(CDS) = 0 then
      Exit;
    SynonymPass := PassC.DecodeHex(Copy(CDS, 1, 64));
    CodesPass := PassC.DecodeHex(Copy(CDS, 65, 64));
    BaseCostPass := PassC.DecodeHex(Copy(CDS, 129, 64));
    oldDBUIN := PassC.DecodeHex(Copy(CDS, 193, 32));

    if Length(BaseCostPass) = 0 then
      raise Exception.Create('Нет необходимой информации.');
    if Length(oldDBUIN) = 0 then
      raise Exception.Create('Нет необходимой информации 2.');

    //Обновляем значение CDS в базе с новым CopyID
    newCDS :=
      PassC.EncodeHex(SynonymPass) +
      PassC.EncodeHex(CodesPass) +
      PassC.EncodeHex(BaseCostPass) +
      PassC.EncodeHex(oldDBUIN + '0000001');
    dbCon.QueryValue('update params set CDS = :CDS where ID = 0', -1, [newCDS]);
  except
    on E : Exception do
     raise Exception.CreateFmt('Невозможно произвести обновление данных: %s', [E.Message]);
  end;

  trMain.Commit;
end;
{$endif}


procedure TDM.SetSendToNotClosedOrders;
begin
  adcUpdate.SQL.Text := 'update OrdersHead set Send = 1 where (Closed = 0)';
  adcUpdate.Execute;
end;

{ TOrderInfo }

constructor TOrderInfo.Create(APriceCode, ARegionCode : Integer);
begin
  Summ := 0;
  PriceCode := APriceCode;
  RegionCode := ARegionCode;
end;

function TDM.FindOrderInfo(APriceCode, ARegionCode: Integer): Currency;
begin
  try
    Result := DM.QueryValue(
      'SELECT ifnull(sum(osbc.price * osbc.OrderCount), 0) SumOrder '
      + 'FROM '
      + ' OrdersHead '
      + ' INNER JOIN OrdersList osbc ON '
      + '       (OrdersHead.orderid = osbc.OrderId) '
      + '   and (osbc.OrderCount > 0) '
      + ' INNER JOIN PricesRegionalData PRD ON '
      + '       (PRD.RegionCode = OrdersHead.RegionCode) '
      + '   AND (PRD.PriceCode = OrdersHead.PriceCode) '
      + ' inner JOIN PricesData ON (PricesData.PriceCode=PRD.PriceCode) '
      + 'WHERE '
      + '    (OrdersHead.CLIENTID = :AClientID) '
      + 'and (OrdersHead.Closed <> 1) '
      + 'and (PRD.PRICECODE = :PriceCode) '
      + 'and (PRD.Regioncode = :RegionCode) ',
      ['AClientID', 'PriceCode', 'RegionCode'],
      [adtClients.FieldByName( 'ClientId').Value, APriceCode, ARegionCode]);
  except
    Result := 0;
  end;
end;

function TDM.GetLastCreateScript: String;
var
  LastCreateScript : TResourceStream;
begin
  LastCreateScript := TResourceStream.Create( hInstance, 'LastScript', RT_RCDATA);
  try
    LastCreateScript.Position := 0;
    SetString(Result, nil, LastCreateScript.Size);
    LastCreateScript.Read(Result[1], LastCreateScript.Size);
  finally
    try LastCreateScript.Free; except end;
  end;
end;

function TDM.GetFullLastCreateScript: String;
begin
  Result := GetLastCreateScript();
  Result := Concat(Result,
    #13#10#13#10 +
    'insert into analitf.params set ' +
    'Id = 0,' +
    'ClientId = null,' +
    'RasConnect = 0,' +
    'RasEntry = null,' +
    'RasName = null,' +
    'RasPass = null,' +
    'ConnectCount = 5,' +
    'ConnectPause = 5,' +
    'ProxyConnect = 0,' +
    'ProxyName = null,' +
    'ProxyPort = null,' +
    'ProxyUser = null,' +
    'ProxyPass = null,' +
    'HTTPHost = ''ios.analit.net'',' +
    'HTTPName = null,' +
    'HTTPPass = null,' +
    'UpdateDatetime = null,' +
    'LastDatetime = null,' +
    'ShowRegister = 1,' +
    'UseForms = 1,' +
    'OperateForms = 0,' +
    'OperateFormsSet = 0,' +
    'StartPage = 0,' +
    'LastCompact = null,' +
    'Cumulative = 0,' +
    'Started = 0,' +
    'RASSLEEP = 3,' +
    'HTTPNAMECHANGED = 1,' +
    'SHOWALLCATALOG = 0,' +
    'CDS = '''',' +
    'ORDERSHISTORYDAYCOUNT = 35,' +
    'CONFIRMDELETEOLDORDERS = 1,' +
    'USEOSOPENWAYBILL = 0,' +
    'USEOSOPENREJECT = 1,' +
    'GROUPBYPRODUCTS = 0,' +
    'PRINTORDERSAFTERSEND = 0,' +
    'ProviderName = ''АК "Инфорум"'',' +
    'ProviderAddress = ''Ленинский пр-т, 160 оф.415'',' +
    'ProviderPhones = ''4732-606000'',' +
    'ProviderEmail = ''farm@analit.net'',' +
    'ProviderWeb = ''http://www.analit.net/'',' +
    'ProviderMDBVersion = ' + IntToStr(CURRENT_DB_VERSION) + ';'#13#10#13#10 +
    'INSERT INTO RETAILMARGINS (ID, LEFTLIMIT, RIGHTLIMIT, RETAIL) VALUES (1, 0, 1000000, 30);'#13#10#13#10
    );
end;

procedure TDM.CreateClearDatabaseFromScript(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
var
  //FIBScript : TpFIBScript;
  FEmbConnection : TMyEmbConnection;
  MyDump : TMyDump;
  MyServerControl : TMyServerControl;
begin
{
  FIBScript := TpFIBScript.Create(nil);
  try

    FIBScript.Script.Text := GetFullLastCreateScript();

    FIBScript.OnExecuteError := OnScriptExecuteError;
    try
      FIBScript.ExecuteScript;
    finally
      FIBScript.OnExecuteError := nil;
    end;

  finally
    try FIBScript.Free; except  end;
  end;
}  

  //Когда мы запускаем программу и не можем открыть базу данных AnalitF,
  //то сохраняются embedded-параметры (настройки соединения) внутри MyDac с открытой базой AnalitF,
  //хотя на самом деле она не открыта и увеличивается счетчик открытых соедиений.
  //После того, как мы открываем базу здесь (строки ниже),
  //счетчик открытых соединений увеличивается еще раз и становится равным 2,
  //после закрытия данного соединения он уменьшается на 1 и становится равным 1.
  //Но MyDac не позволяет открыть еще одно соедиение, т.к. параметры различны.
  //Поэтому в нитках приходится создавать свои соединения и это работает,
  //либо все соединения открывать в папке ..\AnalitF\Data, а потом изменять базу данных на AnalitF
  FEmbConnection := TMyEmbConnection.Create(nil);
  FEmbConnection.Database := '';
  FEmbConnection.Username := MainConnection.Username;
  FEmbConnection.DataDir := DBDirectoryName;
  FEmbConnection.Options := TMyEmbConnection(MainConnection).Options;
  FEmbConnection.Params.Clear;
  FEmbConnection.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
  FEmbConnection.LoginPrompt := False;

  try

    if DirectoryExists(ExePath + SDirData + '\analitf') or DirectoryExists(ExePath + SDirData + '\mysql')
    then begin
      FEmbConnection.Open;
      try
        MyServerControl := TMyServerControl.Create(nil);
        try
          MyServerControl.Connection := FEmbConnection;
          MyServerControl.DropDatabase('analitf');
          MyServerControl.DropDatabase('mysql');
        finally
          MyServerControl.Free;
        end;
      finally
        FEmbConnection.Close;
      end;
      DeleteDataDir(DBDirectoryName);
    end;

    CopyDataDirToBackup(ExePath + SDirDataEtalon, DBDirectoryName);
    CreateDir(ExePath + SDirData + '\analitf');

    FEmbConnection.Database := 'analitf';

    FEmbConnection.Open;
    try
      MyDump := TMyDump.Create(nil);
      try
        MyDump.Connection := FEmbConnection;
        MyDump.Objects := [doStoredProcs, doTables, doViews];
        MyDump.SQL.Text := GetFullLastCreateScript();
        MyDump.Restore;
      finally
        MyDump.Free;
      end;
    finally
      FEmbConnection.Close;
    end;

  finally
    FEmbConnection.Free;
  end;

end;

procedure TDM.RecoverDatabase(E: Exception);
var
  UserErrorMessage,
  DBErrorMess : String;
  OldDBFileName,
  ErrFileName : String;
begin
  {
  Здесь мы должны сделать:
  1. Закрыть соединение, если открыто
  2. Запомнить код ошибки при открытии
  3. Переименовать в ошибочную базу данных
  4. Скопировать из эталонной базы данных
  5. Открыть эталонную базу данных
  }
  UserErrorMessage := 'Не удается открыть базу данных программы.';
  DBErrorMess := Format('Не удается открыть базу данных программы.'#13#10 +
    'Ошибка        : %s'#13#10,
    [E.Message]
  );
  if (E is EMyError) then
    DBErrorMess := DBErrorMess +
      Format(
        'Код SQL       : %d'#13#10 +
        'Сообщение     : %s'#13#10 +
        'Fatal         : %s',
        [EMyError(E).ErrorCode, EMyError(E).Message, BoolToStr(EMyError(E).IsFatalError)]
    );

  if not DirectoryExists(ExePath + SDirDataPrev) then begin
    DBErrorMess := DBErrorMess + #13#10#13#10 + 'Будет произведено создание базы данных.';
    UserErrorMessage := UserErrorMessage + #13#10 + 'Будет произведено создание базы данных.';
  end
  else begin
    DBErrorMess := DBErrorMess + #13#10#13#10 + 'Будет произведено восстановление из эталонной копии.';
    UserErrorMessage := UserErrorMessage + #13#10 + 'Будет произведено восстановление из эталонной копии.';
  end;

  //Логируем наши действия и отображаем пользователю
  AProc.LogCriticalError(DBErrorMess);

  //Если нет предыдущей копии, то создаем базу даннных
  if not DirectoryExists(ExePath + SDirDataPrev) then begin
    RunUpdateDBFile(nil, ExePath + SDirData, CURRENT_DB_VERSION, CreateClearDatabaseFromScript, nil, 'Происходит создание базы данных. Подождите...');
    FCreateClearDatabase := True;
    FNeedImportAfterRecovery := False;
    WriteExchangeLog('AnalitF', 'Произведено создание базы.');
  end
  else
    try
      RunUpdateDBFile(nil, ExePath + SDirData, CURRENT_DB_VERSION, RestoreDatabaseFromPrevios, nil, 'Происходит восстановление базы данных из предыдущей копии. Подождите...');
      //Значит восстановили из предыдущей копии
      FNeedImportAfterRecovery := True;
      WriteExchangeLog('AnalitF', 'Произведено копирование из предыдущей копии.');
    except
      on E : Exception do
        raise Exception.CreateFmt(
        'Не удалось скопировать из предыдущей копии : %s'#13#10 +
        'Windows-ошибка: %s',
          [E.Message, SysErrorMessage(GetLastError)]);
    end;
end;

procedure TDM.CheckDBObjects(dbCon : TCustomMyConnection;
  DBDirectoryName : String; OldDBVersion : Integer;
  AOnUpdateDBFileData : TOnUpdateDBFileData);
var
  MyDump : TMyDump;
  ExistsScript, RightScript : String;
begin
  try
    dbCon.Database := 'analitf';

    dbCon.Open;
    try
      MyDump := TMyDump.Create(nil);
      try
        dbCon.ExecSQL('use analitf', []);
        MyDump.Connection := dbCon;
        MyDump.Objects := [doStoredProcs, doTables, doViews];
        MyDump.Backup;
        ReplaceAutoIncrement(MyDump.SQL);
        ExistsScript := Trim(MyDump.SQL.Text);
      finally
        MyDump.Free;
      end;
    finally
      dbCon.Close;
      //dbCon.RemoveFromPool;
    end;

  finally
    dbCon.Database := '';
  end;


  RightScript := Trim(GetLastCreateScript());

  if ExistsScript <> RightScript then begin
    LogCriticalError('Скрипт с некорректными метаданными:'#13#10 + ExistsScript);
    raise Exception.Create('База данных содержит некорректные метаданные.');
  end;
end;

procedure TDM.ProcessDocs;
var
  //Открыть только директорию с файлами
  OnlyDirOpen : Boolean;
  MaxFileDate : TDateTime;
  DocsFL,
  WaybillsFL,
  RejectsFL : TStringList;
begin
{
  1. Если в таблице все пусто, то открываем только папки
  2. Если не пусто, что выбираем максимальную дату файла
  3. Открываем Датасет с файлами и пробуем искать, добавляя элементы в список
  4.
}
  adtReceivedDocs.Close;
  adtReceivedDocs.Open;
  try
    DocsFL := TStringList.Create();
    WaybillsFL := TStringList.Create();
    RejectsFL := TStringList.Create();
    try
      OnlyDirOpen := adtReceivedDocs.RecordCount = 0;
      if OnlyDirOpen then
        MaxFileDate := 0
      else
        MaxFileDate := IncSecond(adtReceivedDocs.FieldByName('FileDateTime').AsDateTime, - 1);

      ProcessDocsDir(SDirDocs, MaxFileDate, DocsFL);
      ProcessDocsDir(SDirWaybills, MaxFileDate, WaybillsFL);
      ProcessDocsDir(SDirRejects, MaxFileDate, RejectsFL);

      OpenDocsDir(SDirDocs, DocsFL, not OnlyDirOpen);
      OpenDocsDir(SDirWaybills, WaybillsFL, not OnlyDirOpen and adtParams.FieldByName('USEOSOPENWAYBILL').AsBoolean);
      OpenDocsDir(SDirRejects, RejectsFL, not OnlyDirOpen and adtParams.FieldByName('USEOSOPENREJECT').AsBoolean);

    finally
      DocsFL.Free;
      WaybillsFL.Free;
      RejectsFL.Free;
    end;
  finally
    adtReceivedDocs.Close;
  end;
end;

procedure TDM.ProcessDocsDir(DirName: String; MaxFileDate : TDateTime; FileList: TStringList);
var
  DocsSR: TSearchRec;
  CurrentFileDate : TDateTime;
begin
  if DirectoryExists(ExePath + DirName) then begin
    if FindFirst( ExePath + DirName + '\*.*', faAnyFile, DocsSR) = 0 then
    try
      repeat
        if (DocsSR.Name <> '.') and (DocsSR.Name <> '..')
        then begin
          CurrentFileDate := FileDateToDateTime(DocsSR.Time);
          if CurrentFileDate > MaxFileDate then
            if not adtReceivedDocs.Locate('FILENAME', DirName + '\' + DocsSR.Name, [loCaseInsensitive]) then begin
              adtReceivedDocs.Insert;
              adtReceivedDocs['FILENAME'] := DirName + '\' + DocsSR.Name;
              adtReceivedDocs['FILEDATETIME'] := CurrentFileDate;
              adtReceivedDocs.Post;
              FileList.Add(ExePath + DirName + '\' + DocsSR.Name);
            end;
        end;
      until (FindNext( DocsSR ) <> 0)
    finally
      SysUtils.FindClose( DocsSR );
    end;
  end;
end;

procedure TDM.OpenDocsDir(DirName: String; FileList: TStringList;
  OpenEachFile: Boolean);
var
  I : Integer;
begin
  if FileList.Count > 0 then
    if not OpenEachFile then
    	ShellExecute( 0, 'Open', PChar(ExePath + DirName + '\'),
        nil, nil, SW_SHOWDEFAULT)
    else
      for I := 0 to FileList.Count-1 do
      	ShellExecute( 0, 'Open', PChar(FileList[i]),
          nil, nil, SW_SHOWDEFAULT);
end;

{$ifdef DEBUG}
procedure TDM.ExtractDBScript(dbCon: TCustomMyConnection);
var
  MyDump : TMyDump;
begin
  MyDump := TMyDump.Create(nil);
  try
    MyDump.Connection := dbCon;
    MyDump.Objects := [doStoredProcs, doTables, doViews];
    MyDump.Backup;
    ReplaceAutoIncrement(MyDump.SQL);
    MyDump.SQL.SaveToFile('extract_mysql.sql');
  finally
    MyDump.Free;
  end;
end;
{$endif}

procedure TDM.InternalSetHTTPParams(SetHTTP: TIdHTTP);
begin
	// выставляем параметры HTTP-клиента
	if adtParams.FieldByName( 'ProxyConnect').AsBoolean then
        begin
		SetHTTP.ProxyParams.ProxyServer := adtParams.FieldByName( 'ProxyName').AsString;
		SetHTTP.ProxyParams.ProxyPort := adtParams.FieldByName( 'ProxyPort').AsInteger;
		SetHTTP.ProxyParams.ProxyUsername := adtParams.FieldByName( 'ProxyUser').AsString;
		SetHTTP.ProxyParams.ProxyPassword := adtParams.FieldByName( 'ProxyPass').AsString;
    SetHTTP.Request.ProxyConnection := 'keep-alive';
	end
	else
	begin
		SetHTTP.ProxyParams.ProxyServer := '';
		SetHTTP.ProxyParams.ProxyPort := 0;
		SetHTTP.ProxyParams.ProxyUsername := '';
		SetHTTP.ProxyParams.ProxyPassword := '';
    SetHTTP.Request.ProxyConnection := '';
	end;
	SetHTTP.Request.Username := adtParams.FieldByName( 'HTTPName').AsString;
  SetHTTP.AllowCookies := True;
  SetHTTP.HandleRedirects := False;
  SetHTTP.HTTPOptions := [hoForceEncodeParams];
	SetHTTP.ReadTimeout := 0; // Без тайм-аута
	SetHTTP.ConnectTimeout := -2; // Без тайм-аута
  SetHTTP.Request.Accept := 'text/html, */*';
  SetHTTP.Request.BasicAuthentication := True;
  SetHTTP.Request.Connection := 'keep-alive';
  SetHTTP.Request.ContentLength := -1;
  SetHTTP.Request.ContentRangeEnd := 0;
  SetHTTP.Request.ContentRangeStart := 0;
  SetHTTP.Request.ContentType := 'text/html';
  SetHTTP.Request.UserAgent := 'Mozilla/3.0 (compatible; Indy Library)';
end;

function gcp : String;
var
  ch : String;
  I : Integer;
begin
  ch := IntToHex(GetDBID, 8);
  Result := '';
  for I := 1 to Length(ch) do
    Result := Result + ch[i] + PassPassW[i];
end;

function gop : String;
var
  ch : String;
  I : Integer;
begin
  ch := IntToHex(GetOldDBID, 8);
  Result := '';
  for I := 1 to Length(ch) do
    Result := Result + ch[i] + PassPassW[i];
end;

{$ifdef DEBUG}
procedure TDM.UpdateDBFileDataFor40(dbCon: TpFIBDatabase;
  trMain: TpFIBTransaction);
var
  ch,
  p,
  CDS,
  BaseCostPass,
  SynonymPass,
  CodesPass,
  oldDBUIN,
  oldSaveGrids,
  newCDS : String;
  pc : TINFCrypt;
  I : Integer;
begin
  trMain.StartTransaction;

  try
    CDS := dbCon.QueryValue('select CDS from params where ID = 0', 0);
    //Если это поле пустое, то ничего не делаем, предполагая, что база пустая
    if Length(CDS) = 0 then
      Exit;
    ch := IntToHex(GetCopyID(), 8);
    p := '';
    for I := 1 to Length(ch) do
      p := p + ch[i] + PassPassW[i];
    pc := TINFCrypt.Create(p, 48);
    try
      SynonymPass := pc.DecodeHex(Copy(CDS, 1, 64));
      CodesPass := pc.DecodeHex(Copy(CDS, 65, 64));
      BaseCostPass := pc.DecodeHex(Copy(CDS, 129, 64));
      oldDBUIN := pc.DecodeHex(Copy(CDS, 193, 32));
      oldSaveGrids := Copy(oldDBUIN, 9, 7);
      oldDBUIN := Copy(oldDBUIN, 1, 8);
    finally
      pc.Free;
    end;

    if Length(BaseCostPass) = 0 then
      raise Exception.Create('Нет необходимой информации.');
    if Length(oldDBUIN) = 0 then
      raise Exception.Create('Нет необходимой информации 2.');
    if oldDBUIN <> IntToHex(GetCopyID(), 8) then
      raise Exception.Create('Не совпадает DBUIN в обновляемой базе данных.');

    pc := TINFCrypt.Create(gop, 48);
    try
      newCDS :=
        pc.EncodeHex(SynonymPass) +
        pc.EncodeHex(CodesPass) +
        pc.EncodeHex(BaseCostPass) +
        pc.EncodeHex(IntToHex(GetOldDBID(), 8) + oldSaveGrids);
    finally
      pc.Free;
    end;

    //Обновляем значение CDS в базе с новым CopyID
    dbCon.QueryValue('update params set CDS = :CDS where ID = 0', -1, [newCDS]);
  except
    on E : Exception do
     raise Exception.CreateFmt('Невозможно произвести обновление данных: %s', [E.Message]);
  end;

  trMain.Commit;
end;
{$endif}

procedure TDM.UpdateDBUIN(dbCon: TCustomMyConnection);
var
  CDS,
  BaseCostPass,
  SynonymPass,
  CodesPass,
  oldDBUIN,
  oldSaveGrids,
  newCDS : String;
  pc : TINFCrypt;
begin
  try
    dbCon.Open();
    try

      CDS := DBProc.QueryValue(dbCon, 'select CDS from analitf.params where ID = 0', [], []);
      //Если это поле пустое, то ничего не делаем, предполагая, что база пустая
      if Length(CDS) = 0 then
        Exit;
      pc := TINFCrypt.Create(gop, 48);
      try
        SynonymPass := pc.DecodeHex(Copy(CDS, 1, 64));
        CodesPass := pc.DecodeHex(Copy(CDS, 65, 64));
        BaseCostPass := pc.DecodeHex(Copy(CDS, 129, 64));
        oldDBUIN := pc.DecodeHex(Copy(CDS, 193, 32));
        oldSaveGrids := Copy(oldDBUIN, 9, 7);
        oldDBUIN := Copy(oldDBUIN, 1, 8);
      finally
        pc.Free;
      end;

      if Length(BaseCostPass) = 0 then
        raise Exception.Create('Нет необходимой информации.');
      if Length(oldDBUIN) = 0 then
        raise Exception.Create('Нет необходимой информации 2.');
      if oldDBUIN <> IntToHex(GetOldDBID(), 8) then
        raise Exception.Create('Не совпадает DBUIN в обновляемой базе данных.');

      pc := TINFCrypt.Create(gcp, 48);
      try
        newCDS :=
          pc.EncodeHex(SynonymPass) +
          pc.EncodeHex(CodesPass) +
          pc.EncodeHex(BaseCostPass) +
          pc.EncodeHex(IntToHex(GetDBID(), 8) + oldSaveGrids);
      finally
        pc.Free;
      end;

      //Обновляем значение CDS в базе с новым CopyID
      dbCon.ExecSQL('update params set CDS = :CDS where ID = 0', [newCDS]);

    finally
      try dbCon.Close(); except end;
    end;
  except
    on E : Exception do begin
      AProc.LogCriticalError('Ошибка при обновлении UIN : ' + E.Message);
    end;
  end;
end;

procedure TDM.UpdateDBFileDataFor42(dbCon: TpFIBDatabase;
  trMain: TpFIBTransaction);
var
  CDS,
  BaseCostPass,
  SynonymPass,
  CodesPass,
  oldDBUIN,
  oldSaveGrids,
  newCDS : String;
  pc : TINFCrypt;
  p, ch : String;
  I : Integer;
begin
  trMain.StartTransaction;

  try
    CDS := dbCon.QueryValue('select CDS from params where ID = 0', 0);
    //Расчитываем уникальный идентификатор для старого exe (525) по старой формуле
    ch := IntToHex(GetOld525UniqueID(Application.ExeName,
{$ifdef DEBUG}
'E99E483DDE777778ADEFCB3DCD988BC9'
{$else}
AProc.GetFileHash(ExePath + SBackDir + '\' + ExtractFileName(Application.ExeName) + '.bak')
{$ENDIF}
      ),
      8);
    p := '';
    for I := 1 to Length(ch) do
      p := p + ch[i] + PassPassW[i];
    pc := TINFCrypt.Create(p, 48);
    try
      //Если это поле пустое, то ничего не делаем, предполагая, что база пустая
      if Length(CDS) = 0 then
        Exit;
      SynonymPass := pc.DecodeHex(Copy(CDS, 1, 64));
      CodesPass := pc.DecodeHex(Copy(CDS, 65, 64));
      BaseCostPass := pc.DecodeHex(Copy(CDS, 129, 64));
      oldDBUIN := pc.DecodeHex(Copy(CDS, 193, 32));
      oldSaveGrids := Copy(oldDBUIN, 9, 7);
      oldDBUIN := Copy(oldDBUIN, 1, 8);
    finally
      pc.Free;
    end;

    if Length(BaseCostPass) = 0 then
      raise Exception.Create('Нет необходимой информации.');
    if Length(oldDBUIN) = 0 then
      raise Exception.Create('Нет необходимой информации 2.');

    //Обновляем значение CDS в базе с новым CopyID
    //Шифруем данные с уникальным идентификатором старого exe (525) по новой формуле
    pc := TINFCrypt.Create(gop, 48);
    try
      newCDS :=
        pc.EncodeHex(SynonymPass) +
        pc.EncodeHex(CodesPass) +
        pc.EncodeHex(BaseCostPass) +
        pc.EncodeHex(IntToHex(GetOldDBID(), 8) + oldSaveGrids);
    finally
      pc.Free;
    end;

    dbCon.QueryValue('update params set CDS = :CDS where ID = 0', -1, [newCDS]);
  except
    on E : Exception do
     raise Exception.CreateFmt('Невозможно произвести обновление данных: %s', [E.Message]);
  end;

  trMain.Commit;

  trMain.StartTransaction;

  dbCon.QueryValue('select count(*) from MinPrices where ServerCoreID is not null', 0);

  dbCon.QueryValue('select count(*) from Core where productid is not null', 0);

  dbCon.QueryValue('select count(*) from PricesData where Fresh is not null', 0);

  trMain.Commit;
end;

function TDM.GetServerUpdateId: String;
begin
  Result := FServerUpdateId;
end;

procedure TDM.SetServerUpdateId(AServerUpdateId: String);
begin
  FServerUpdateId := AServerUpdateId;
end;

procedure TDM.ShowOrderDetailsReport(OrderId: Integer; Closed, Send,
  Preview, PrintDlg: Boolean);
begin
  if adsOrdersHeaders.Active then
    adsOrdersHeaders.Close;
  //Получаем информацию о текущих отправляемых заказах
	adsOrdersHeaders.ParamByName( 'AClientId').Value := adtClients.FieldByName( 'ClientId').Value;
	adsOrdersHeaders.ParamByName( 'AClosed').Value := Closed;
	adsOrdersHeaders.ParamByName( 'ASend').Value := Send;
	adsOrdersHeaders.ParamByName( 'TimeZoneBias').Value := AProc.TimeZoneBias;
	adsOrdersHeaders.Open;

  try
    if adsOrdersHeaders.Locate('OrderId', OrderId, []) then begin
      if adsOrderDetails.Active then
        adsOrderDetails.Close();

      adsOrderDetails.ParamByName('AOrderId').Value := OrderId;
      adsOrderDetails.Open;

      try

        frdsReportOrder.DataSet := adsOrderDetails;
        //готовим печать
        frVariables[ 'DisplayOrderId'] := adsOrdersHeaders.FieldByName('DisplayOrderId').AsVariant;
        frVariables[ 'DatePrice'] := adsOrdersHeaders.FieldByName('DatePrice').AsVariant;
        frVariables[ 'OrdersComments'] := adsOrdersHeaders.FieldByName('Comments').AsString;
        frVariables[ 'SupportPhone'] := adsOrdersHeaders.FieldByName('SupportPhone').AsString;
        frVariables[ 'OrderDate'] := adsOrdersHeaders.FieldByName('OrderDate').AsVariant;
        frVariables[ 'PriceName'] := adsOrdersHeaders.FieldByName('PriceName').AsString;
        frVariables[ 'Closed'] := adsOrdersHeaders.FieldByName('Closed').AsBoolean;

        DM.ShowFastReport( 'Orders.frf', nil, Preview, PrintDlg);

      finally
        adsOrderDetails.Close;
      end;
    end;
  finally
    adsOrdersHeaders.Close;
  end;
end;

procedure TDM.MySQLMonitorSQL(Sender: TObject; Text: String;
  Flag: TDATraceFlag);
const
  DATraceFlagNames : array[TDATraceFlag] of string =
    ('tfQPrepare', 'tfQExecute', 'tfQFetch', 'tfError', 'tfStmt', 'tfConnect',
     'tfTransact', 'tfBlob', 'tfService', 'tfMisc', 'tfParams');
begin
{
  if (Sender is TMyQuery) and (TMyQuery(Sender).Name = 'adsOrdersHForm')
  then
    Tracer.TR('Monitor', Format('Sender : %s  Flag : %s'#13#10'Text : %s ', [Sender.ClassName, DATraceFlagNames[Flag], Text]))
  else
    if (Sender = nil) then
      Tracer.TR('Monitor', Format('Sender : nil  Flag : %s'#13#10'Text : %s ', [DATraceFlagNames[Flag], Text]))
    else
      Tracer.TR('Monitor', Format('Sender : %s  Flag : %s'#13#10'Text : %s ', [Sender.ClassName, DATraceFlagNames[Flag], Text]))
}      
end;

{$ifdef TestEmbeddedMysql}
procedure TDM.TestEmbeddedMysql;
begin
{$ifdef USEMYSQLEMBEDDED}
  //TestDumpDatabase();

  //TestOpenDatabase();

  //TestEmbeddedThread();
{$endif}

  //TestDirectoriesOperation();
end;

{$ifdef USEMYSQLEMBEDDED}
procedure TDM.TestOpenDatabase;
const
  DirDataTest : String = 'Data_Test';
var
  FEmbConnection : TMyEmbConnection;
  MyServerControl : TMyServerControl;
begin
  WriteExchangeLog('DBtest', 'start TestOpenDatabase');
  FEmbConnection := TMyEmbConnection.Create(nil);
  FEmbConnection.Database := MainConnection.Database;
  FEmbConnection.Username := MainConnection.Username;
  FEmbConnection.DataDir := TMyEmbConnection(MainConnection).DataDir;
  FEmbConnection.Options := TMyEmbConnection(MainConnection).Options;
  FEmbConnection.Params.Clear;
  FEmbConnection.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
  FEmbConnection.LoginPrompt := False;

  try

  try
    if DirectoryExists(ExePath + SDirData) then begin
      DeleteDirectory(ExePath + DirDataTest);
      CopyDataDirToBackup(ExePath + SDirData, ExePath + DirDataTest);
      DeleteDataDir(ExePath + SDirData);
    end;

    if DirectoryExists(ExePath + SDirData + '\analitf') then
      raise Exception.CreateFmt('Cуществует директория %s, чего быть не должно.', [ExePath + SDirData + '\analitf']);

    //Попытка открыть базу при несуществовании папок "analitf" и "mysql"
    try
      FEmbConnection.Open;
      try 
      finally
        FEmbConnection.Close;
      end;
    except
      on E : Exception do
        if (E is EMyError) and (not EMyError(E).IsFatalError) and (EMyError(E).ErrorCode = 1049)
        then
          WriteExchangeLog('DBtest.TestOpenDatabase', 'Получили ошибку не существования базы данных' )
        else
          raise;
    end;

    //Попытка открыть базу при несуществовании папки analitf
{
    CreateDir(ExePath + SDirData);
    try
      FEmbConnection.Open;
    except
      on E : Exception do
        if (E is EMyError) and (not EMyError(E).IsFatalError) and (EMyError(E).ErrorCode = 1049)
        then
          WriteExchangeLog('DBtest.TestOpenDatabase', 'Получили ошибку не существования базы данных' )
        else
          raise;
    end;
}    

    //Попытка выбрать данные из таблицы params при пустой базе данных analitf
    CreateDir(ExePath + SDirData + '\analitf');
    try
      FEmbConnection.Open;
      try
        FEmbConnection.ExecSQL('use analitf', []);
        FEmbConnection.ExecSQL('select * from params', []);
      finally
        FEmbConnection.Close;
      end;
    except
      on E : Exception do
        if (E is EMyError) and (not EMyError(E).IsFatalError) and (EMyError(E).ErrorCode = 1146)
        then
          WriteExchangeLog('DBtest.TestOpenDatabase', 'Получили ошибку не существования таблицы' )
        else
          raise;
    end;

    //создаем тестовую таблицу
    FEmbConnection.Open;
    try
      FEmbConnection.ExecSQL('use analitf', []);
      FEmbConnection.ExecSQL('create table TestTable(id int, namecolumn varchar(255))', []);
    finally
      FEmbConnection.Close;
    end;

    //пытаемся выбрать из information_schema
    FEmbConnection.Open;
    try
      FEmbConnection.ExecSQL('use analitf', []);
      FEmbConnection.ExecSQL('select * from information_schema.tables', []);
    finally
      FEmbConnection.Close;
    end;

    //попытка воспользоваться ХП, которой не существует
    try
      FEmbConnection.Open;
      try
        FEmbConnection.ExecSQL('use analitf', []);
        FEmbConnection.ExecSQL('select analitf.x_cast_to_tinyint(323232323)', []);
      finally
        FEmbConnection.Close;
      end;
    except
      on E : Exception do
        if (E is EMyError) and (not EMyError(E).IsFatalError) and (EMyError(E).ErrorCode = 1146)
        then
          WriteExchangeLog('DBtest.TestOpenDatabase', 'Получили ошибку не существования таблицы mysql.proc из-за чего нельзя использовать ХП')
        else
          raise;
    end;

    //попытка создать ХП, при несуществующей базе mysql
    try
      FEmbConnection.Open;
      try
        FEmbConnection.ExecSQL('use analitf', []);
        FEmbConnection.ExecSQL('create FUNCTION analitf.x_cast_to_tinyint(number BIGINT) RETURNS tinyint(1) BEGIN return number;END', []);
      finally
        FEmbConnection.Close;
      end;
    except
      on E : Exception do
        if (E is EMyError) and (not EMyError(E).IsFatalError) and (EMyError(E).ErrorCode = 1146)
        then
          WriteExchangeLog('DBtest.TestOpenDatabase', 'Получили ошибку не существования таблицы mysql.proc  из-за чего нельзя создать ХП')
        else
          raise;
    end;

    //удаляем все базы данных, чтобы Embedded-сервер отпустил файлы
    FEmbConnection.Open;
    try
      MyServerControl := TMyServerControl.Create(nil);
      try
        MyServerControl.Connection := FEmbConnection;
        MyServerControl.DropDatabase('analitf');
        MyServerControl.DropDatabase('mysql');
      finally
        MyServerControl.Free;
      end;
    finally
      FEmbConnection.Close;
      //Здесь пока удалять не буду
      //FEmbConnection.RemoveFromPool;
    end;

    //удаляем директорию
    DeleteDataDir(ExePath + SDirData);

    //копируем данные из эталонной копии
    CopyDataDirToBackup(ExePath + SDirDataEtalon, ExePath + SDirData);

    //пытаемся создать ХП
    CreateDir(ExePath + SDirData + '\analitf');
    FEmbConnection.Open;
    try
      FEmbConnection.ExecSQL('use analitf', []);
      FEmbConnection.ExecSQL('create FUNCTION analitf.x_cast_to_tinyint(number BIGINT) RETURNS tinyint(1) BEGIN return number;END', []);
    finally
      FEmbConnection.Close;
    end;

    //пытаемся выбрать с помощью созданной ХП
    FEmbConnection.Open;
    try
      FEmbConnection.ExecSQL('use analitf', []);
      FEmbConnection.ExecSQL('select analitf.x_cast_to_tinyint(323232323)', []);
    finally
      FEmbConnection.Close;
    end;

    //Возвращаем все в исходное положение
    FEmbConnection.Open;
    try
      MyServerControl := TMyServerControl.Create(nil);
      try
        MyServerControl.Connection := FEmbConnection;
        MyServerControl.DropDatabase('analitf');
        MyServerControl.DropDatabase('mysql');
      finally
        MyServerControl.Free;
      end;
    finally
      FEmbConnection.Close;
      //Здесь пока удалять не буду
      //FEmbConnection.RemoveFromPool;
    end;


    //удаляем директорию
    DeleteDataDir(ExePath + SDirData);

    //переносим данные, которые сохранили перед тестом
    if DirectoryExists(ExePath + DirDataTest) then
      MoveDirectories(ExePath + DirDataTest, ExePath + SDirData);

  finally
    FEmbConnection.Free;
  end;
  
  except
    on E : Exception do
      WriteExchangeLog('DBtest.TestOpenDatabase', 'ClassName:' + E.ClassName + '  Message:' + E.Message );
  end;

  WriteExchangeLog('DBtest', 'stop TestOpenDatabase');
end;

procedure TDM.TestDumpDatabase;
var
  FEmbConnection : TMyEmbConnection;
  MyDump : TMyDump;
  ExtentionError : EMyError;
begin
  FEmbConnection := TMyEmbConnection.Create(nil);
  FEmbConnection.Database := MainConnection.Database;
  FEmbConnection.Username := MainConnection.Username;
  FEmbConnection.DataDir := TMyEmbConnection(MainConnection).DataDir;
  FEmbConnection.Options := TMyEmbConnection(MainConnection).Options;
  FEmbConnection.Params.Clear;
  FEmbConnection.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
  FEmbConnection.LoginPrompt := False;

  try
    try

      FEmbConnection.Open;
      try
        MyDump := TMyDump.Create(nil);
        try
          MyDump.Connection := FEmbConnection;
          MyDump.Objects := [doStoredProcs, doTables, doViews];
          MyDump.BackupToFile('extract_mysql.sql');
        finally
          MyDump.Free;
        end;
      finally
        FEmbConnection.Close;
      end;

    except
      on E : Exception do
        if E is EMyError then
        begin
          ExtentionError := EMyError(E);
          if ExtentionError.IsFatalError then
            LogCriticalError('Fatal Error');
          LogCriticalError('EMyError : ' + IntToStr(ExtentionError.ErrorCode) + '  ' + ExtentionError.Message);
          WriteExchangeLog('DBtest.TestDumpDatabase.EMyError',
            'ErrorCode:' + IntToStr(ExtentionError.ErrorCode) +
            '  FatalError: ' + BoolToStr(ExtentionError.IsFatalError) +
            '  Message:' + ExtentionError.Message);
        end
        else
          WriteExchangeLog('DBtest.TestDumpDatabase.Error', 'ClassName:' + E.ClassName + '  Message:' + E.Message );
    end;
  finally
    FEmbConnection.Free;
  end;
end;

procedure TDM.TestEmbeddedThread;
var
  testThread : TTestMyDBThread;
  FQuery : TMyQuery;
begin
  if MainConnection.Connected then begin
    WriteExchangeLog('DBtest', 'start test');
    MainConnection.Close;
    MainConnection.Open;
    testThread := TTestMyDBThread.Create(MainConnection as TMyEmbConnection);
    while (testThread.State <> mtsClosinginMain) do
      Sleep(500);

    if MainConnection.Connected then begin

      FQuery := TMyQuery.Create(nil);
      try
        FQuery.Connection := MainConnection;

        try
          FQuery.SQL.Text := 'select * from analitf.params';
          FQuery.Open;
          if FQuery.RecordCount = 1 then
            WriteExchangeLog('DBtest.ParentClose', 'Params consists data')
          else
            WriteExchangeLog('DBtest.ParentClose', 'Params - no data');
          FQuery.Close;
        except
          on E : Exception do
            WriteExchangeLog('DBtest.ErrorOn_ParentClose_Select', E.Message);
        end;

        try
          FQuery.SQL.Text := 'update analitF.params set RasName = "test" where Id = 0';
          FQuery.Execute;
        except
          on E : Exception do
            WriteExchangeLog('DBtest.ErrorOn_ParentClose_Update', E.Message);
        end;

      finally
        FQuery.Free;
      end;

      try
        MainConnection.Close;
      except
        on E : Exception do
          WriteExchangeLog('DBtest.ErrorOnParentClose', E.Message);
      end;
    end
    else
      WriteExchangeLog('DBtest', 'Connection already closed');

    testThread.State := mtsClosedInMain;

    while (testThread.State <> mtsStopped) do
      Sleep(500);

    WriteExchangeLog('DBtest', 'stop test');
  end;
end;
{$endif}


procedure TDM.TestDirectoriesOperation;
begin
  DeleteDirectory(ExePath + SDirDataBackup);

  CopyDataDirToBackup(ExePath + SDirData, ExePath + SDirDataBackup);
  if not DirectoryExists(ExePath + SDirDataBackup) then
    raise Exception.Create('Директория с Backup не существует')
  else
    DeleteDirectory(ExePath + SDirDataBackup);
  CopyDataDirToBackup(ExePath + SDirData, ExePath + SDirDataBackup);

  MoveDirectories(ExePath + SDirDataBackup, ExePath + SDirData);
  if DirectoryExists(ExePath + SDirDataBackup) then
    raise Exception.Create('Директория с Backup существует');
end;
{$endif}


function TDM.QueryValue(SQL: String; Params: array of string;
  Values: array of Variant): Variant;
begin
  Result := DBProc.QueryValue(MainConnection, SQL, Params, Values);
end;

function TDM.GetMainConnection: TCustomMyConnection;
begin
{$ifdef USEMYSQLEMBEDDED}
  Result := (MyEmbConnection as TCustomMyConnection);
{$else}
  Result := (MyConnection as TCustomMyConnection);
{$endif}
end;

procedure TDM.PatchMyDataSets;
var
  I : Integer;
begin
  MyServerControl.Connection := MainConnection;
  for I := 0 to ComponentCount-1 do
    if Components[i] is TCustomMyDataSet then
      TCustomMyDataSet(Components[i]).Connection := DM.MainConnection;
end;

procedure TDM.RestoreDatabaseFromPrevios(dbCon: TCustomMyConnection;
  DBDirectoryName: String; OldDBVersion: Integer;
  AOnUpdateDBFileData: TOnUpdateDBFileData);
var
  Succes : Boolean;
  RepeatCount : Integer;
begin
  Succes := False;
  RepeatCount := 0;
  repeat
    try
      DeleteDataDir(ExePath + SDirData);
      Succes := True;
    except
      Sleep(500);
      Inc(RepeatCount);
      if RepeatCount > 10 then
        raise;
    end;
  until Succes;

  Succes := False;
  RepeatCount := 0;
  repeat
    try
      MoveDirectories(ExePath + SDirDataPrev, ExePath + SDirData);
      Succes := True;
    except
      Sleep(500);
      Inc(RepeatCount);
      if RepeatCount > 10 then
        raise;
    end;
  until Succes;
end;

procedure TDM.UpdateFirebirdToMySql(dbCon: TCustomMyConnection;
  DBDirectoryName: String; OldDBVersion: Integer;
  AOnUpdateDBFileData: TOnUpdateDBFileData);
var
  firebirdDB : TpFIBDatabase;
  firebirdTransaction : TpFIBTransaction;
begin
  dbCon.Open;
  try
   firebirdDB := TpFIBDatabase.Create(nil);
   try
      firebirdDB.DBName := ExePath + DatabaseName;
      firebirdDB.DBParams.Text := MainConnectionOld.DBParams.Text;
      firebirdDB.LibraryName := MainConnectionOld.LibraryName;
      firebirdDB.SQLDialect := MainConnectionOld.SQLDialect;

      firebirdTransaction := TpFIBTransaction.Create(nil);

      firebirdTransaction.DefaultDatabase := firebirdDB;
      firebirdDB.DefaultTransaction := firebirdTransaction;
      firebirdDB.DefaultUpdateTransaction := firebirdTransaction;

      try
        try
          firebirdDB.Open;
        except
          on OpenException : Exception do begin
            AProc.LogCriticalError('Ошибка при открытии старой базы данных : ' + OpenException.Message);
            raise Exception.Create('Не получилось открыть старую базу данных');
          end;
        end;

        try
          try
            InternalUpdateFirebirdToMySql(dbCon, firebirdDB, firebirdTransaction);
          except
            on UpdateException : Exception do begin
              AProc.LogCriticalError('Ошибка при переносе данных : ' + UpdateException.Message);
              raise Exception.Create(
                'При перемещении данных из старой базы в новою возникла ошибка.' +
                #13#10 +
                'Пожалуйста, свяжитесь со службой техничесской поддержки для получения инструкций.');
            end;
          end;
        finally
          firebirdDB.Close;
        end;
      finally
        firebirdTransaction.Free;
      end;
   finally
     firebirdDB.Free;
   end;
  finally
    try dbCon.Close; except end;
  end;
end;

procedure TDM.InternalUpdateFirebirdToMySql(dbCon : TCustomMyConnection;
  firebirdDB : TpFIBDatabase; firebirdTransaction : TpFIBTransaction);
var
  selectMySql : TMyQuery;
  updateMySql : TMyQuery;
  selectFirebird : TpFIBDataSet;
  UpdateParamsSQL : String;
  I : Integer;
  ExistsField : TField;
  ExistsParam : TDAParam;
  CDS,
  BaseCostPass,
  SynonymPass,
  CodesPass,
  oldDBUIN,
  oldSaveGrids,
  newCDS : String;
  pc : TINFCrypt;
begin
  selectMySql := TMyQuery.Create(nil);
  selectMySql.Connection := dbCon;
  updateMySql := TMyQuery.Create(nil);
  updateMySql.Connection := dbCon;

  selectFirebird := TpFIBDataSet.Create(nil);
  selectFirebird.Database := firebirdDB;
  selectFirebird.Transaction := firebirdTransaction;
  selectFirebird.UpdateTransaction := firebirdTransaction;
  selectFirebird.Options := selectFirebird.Options - [poTrimCharFields];

  try
    //Производим перемещение наценок
    updateMySql.SQL.Text := 'delete from analitf.RetailMargins';
    updateMySql.Execute;
    selectFirebird.SelectSQL.Text := 'SELECT * FROM RetailMargins order by Id';
    selectFirebird.Open;
    try
      if selectFirebird.RecordCount > 0 then begin
        updateMySql.SQL.Text := 'insert into analitf.RetailMargins (ID, LeftLIMIT, RIGHTLIMIT, Retail) values (:ID, :LeftLIMIT, :RIGHTLIMIT, :Retail)';
        while not selectFirebird.Eof do begin
          updateMySql.ParamByName('Id').Value := selectFirebird.FieldByName('Id').Value;
          updateMySql.ParamByName('LeftLIMIT').Value := selectFirebird.FieldByName('LeftLIMIT').Value;
          updateMySql.ParamByName('RIGHTLIMIT').Value := selectFirebird.FieldByName('RIGHTLIMIT').Value;
          updateMySql.ParamByName('Retail').Value := selectFirebird.FieldByName('Retail').Value;
          updateMySql.Execute;
          selectFirebird.Next;
        end;
      end
      else begin
        updateMySql.ParamByName('Id').Value := 1;
        updateMySql.ParamByName('LeftLIMIT').Value := 0;
        updateMySql.ParamByName('RIGHTLIMIT').Value := 1000000;
        updateMySql.ParamByName('Retail').Value := 30;
        updateMySql.Execute;
      end;
    finally
      selectFirebird.Close;
    end;

    //Производим перемещение заголовков заказов
    updateMySql.SQL.Text := 'delete from analitf.ordershead';
    updateMySql.Execute;
    selectFirebird.SelectSQL.Text := 'SELECT * FROM ordersh order by orderid';
    selectFirebird.Open;
    try
      if selectFirebird.RecordCount > 0 then begin
        updateMySql.SQL.Text := 'insert into analitf.ordershead set ' +
        'ORDERID  = :ORDERID,' +
        'SERVERORDERID = :SERVERORDERID,' +
        'CLIENTID = :CLIENTID,' +
        'PRICECODE = :PRICECODE,' +
        'REGIONCODE = :REGIONCODE,' +
        'PRICENAME = :PRICENAME,' +
        'REGIONNAME = :REGIONNAME,' +
        'ORDERDATE = :ORDERDATE,' +
        'SENDDATE = :SENDDATE,' +
        'CLOSED = :CLOSED,' +
        'SEND = :SEND,' +
        'COMMENTS = :COMMENTS,' +
        'MESSAGETO = :MESSAGETO';
        while not selectFirebird.Eof do begin
          updateMySql.ParamByName('ORDERID').Value := selectFirebird.FieldByName('ORDERID').Value;
          updateMySql.ParamByName('SERVERORDERID').Value := selectFirebird.FieldByName('SERVERORDERID').Value;
          updateMySql.ParamByName('CLIENTID').Value := selectFirebird.FieldByName('CLIENTID').Value;
          updateMySql.ParamByName('PRICECODE').Value := selectFirebird.FieldByName('PRICECODE').Value;
          updateMySql.ParamByName('REGIONCODE').Value := selectFirebird.FieldByName('REGIONCODE').Value;
          updateMySql.ParamByName('PRICENAME').Value := selectFirebird.FieldByName('PRICENAME').Value;
          updateMySql.ParamByName('REGIONNAME').Value := selectFirebird.FieldByName('REGIONNAME').Value;
          updateMySql.ParamByName('ORDERDATE').Value := selectFirebird.FieldByName('ORDERDATE').Value;
          updateMySql.ParamByName('SENDDATE').Value := selectFirebird.FieldByName('SENDDATE').Value;
          updateMySql.ParamByName('CLOSED').Value := selectFirebird.FieldByName('CLOSED').Value;
          updateMySql.ParamByName('SEND').Value := selectFirebird.FieldByName('SEND').Value;
          updateMySql.ParamByName('COMMENTS').Value := selectFirebird.FieldByName('COMMENTS').Value;
          updateMySql.ParamByName('MESSAGETO').Value := selectFirebird.FieldByName('MESSAGETO').Value;
          updateMySql.Execute;
          selectFirebird.Next;
        end;
      end;
    finally
      selectFirebird.Close;
    end;
    CDS := firebirdDB.QueryValue('select CDS from params where ID = 0', 0);
    //Если это поле пустое, то ничего не делаем, предполагая, что база пустая
    if Length(CDS) = 0 then
      newCDS := ''
    else begin
      pc := TINFCrypt.Create(gop, 48);
      try
        SynonymPass := pc.DecodeHex(Copy(CDS, 1, 64));
        CodesPass := pc.DecodeHex(Copy(CDS, 65, 64));
        BaseCostPass := pc.DecodeHex(Copy(CDS, 129, 64));
        oldDBUIN := pc.DecodeHex(Copy(CDS, 193, 32));
        oldSaveGrids := Copy(oldDBUIN, 9, 7);
        oldDBUIN := Copy(oldDBUIN, 1, 8);
      finally
        pc.Free;
      end;
      if Length(BaseCostPass) = 0 then
        AProc.LogCriticalError('Ошибка при переносе данных : Нет необходимой информации.');
      if Length(oldDBUIN) = 0 then
        AProc.LogCriticalError('Ошибка при переносе данных : Нет необходимой информации 2.');
      if oldDBUIN <> IntToHex(GetOldDBID(), 8) then
        raise Exception.Create('Не совпадает DBUIN в обновляемой базе данных.');

      if (Length(BaseCostPass) > 0) and (Length(oldDBUIN) > 0) then begin
        pc := TINFCrypt.Create(gcp, 48);
        try
          newCDS :=
            pc.EncodeHex(SynonymPass) +
            pc.EncodeHex(CodesPass) +
            pc.EncodeHex(BaseCostPass) +
            pc.EncodeHex(IntToHex(GetDBID(), 8) + oldSaveGrids);
        finally
          pc.Free;
        end;
      end
      else
        newCDS := '';
    end;

    if (Length(newCDS) > 0) and (Length(BaseCostPass) > 0) then
      pc := TINFCrypt.Create(BaseCostPass, 50)
    else
      pc := nil;

    //Производим перемещение содержимого текущих и отправленных заказов
    updateMySql.SQL.Text := 'delete from analitf.orderslist';
    updateMySql.Execute;
    selectFirebird.SelectSQL.Text := 'SELECT * FROM orders order by id';
    selectFirebird.Open;
    try
      if selectFirebird.RecordCount > 0 then begin
        updateMySql.SQL.Text := 'insert into analitf.orderslist set ' +
        'ID  = :ID,' +
        'ORDERID  = :ORDERID,' +
        'CLIENTID = :CLIENTID,' +
        'COREID = :COREID,' +
        'PRODUCTID = :PRODUCTID,' +
        'CODEFIRMCR = :CODEFIRMCR,' +
        'SYNONYMCODE = :SYNONYMCODE,' +
        'SYNONYMFIRMCRCODE = :SYNONYMFIRMCRCODE,' +
        'CODE = :CODE,' +
        'CODECR = :CODECR,' +
        'SYNONYMNAME = :SYNONYMNAME,' +
        'SYNONYMFIRM = :SYNONYMFIRM,' +
        'PRICE = :PRICE,' +
        'AWAIT = :AWAIT,' +
        'JUNK = :JUNK,' +
        'ORDERCOUNT = :ORDERCOUNT,' +
        'REQUESTRATIO = :REQUESTRATIO,' +
        'ORDERCOST = :ORDERCOST,' +
        'MINORDERCOUNT = :MINORDERCOUNT';
        while not selectFirebird.Eof do begin
          updateMySql.ParamByName('ID').Value := selectFirebird.FieldByName('ID').Value;
          updateMySql.ParamByName('ORDERID').Value := selectFirebird.FieldByName('ORDERID').Value;
          updateMySql.ParamByName('CLIENTID').Value := selectFirebird.FieldByName('CLIENTID').Value;
          updateMySql.ParamByName('COREID').Value := selectFirebird.FieldByName('COREID').Value;
          updateMySql.ParamByName('PRODUCTID').Value := selectFirebird.FieldByName('PRODUCTID').Value;
          updateMySql.ParamByName('CODEFIRMCR').Value := selectFirebird.FieldByName('CODEFIRMCR').Value;
          updateMySql.ParamByName('SYNONYMCODE').Value := selectFirebird.FieldByName('SYNONYMCODE').Value;
          updateMySql.ParamByName('SYNONYMFIRMCRCODE').Value := selectFirebird.FieldByName('SYNONYMFIRMCRCODE').Value;
          if selectFirebird.FieldByName('CODE').IsNull then
            updateMySql.ParamByName('CODE').Value := ''
          else
            updateMySql.ParamByName('CODE').Value := selectFirebird.FieldByName('CODE').Value;
          if selectFirebird.FieldByName('CODECR').IsNull then
            updateMySql.ParamByName('CODECR').Value := ''
          else
            updateMySql.ParamByName('CODECR').Value := selectFirebird.FieldByName('CODECR').Value;
          updateMySql.ParamByName('SYNONYMNAME').Value := selectFirebird.FieldByName('SYNONYMNAME').Value;
          updateMySql.ParamByName('SYNONYMFIRM').Value := selectFirebird.FieldByName('SYNONYMFIRM').Value;
          updateMySql.ParamByName('AWAIT').Value := selectFirebird.FieldByName('AWAIT').Value;
          updateMySql.ParamByName('JUNK').Value := selectFirebird.FieldByName('JUNK').Value;
          updateMySql.ParamByName('ORDERCOUNT').Value := selectFirebird.FieldByName('ORDERCOUNT').Value;
          updateMySql.ParamByName('REQUESTRATIO').Value := selectFirebird.FieldByName('REQUESTRATIO').Value;
          updateMySql.ParamByName('ORDERCOST').Value := selectFirebird.FieldByName('ORDERCOST').Value;
          updateMySql.ParamByName('MINORDERCOUNT').Value := selectFirebird.FieldByName('MINORDERCOUNT').Value;
          if selectFirebird.FieldByName('SENDPRICE').IsNull then begin
            //Если пароль для цен известен, то расшифровываем, иначе сбрасываем позицию
            if Assigned(pc) then
              updateMySql.ParamByName('PRICE').Value := StrToCurr(D_B_N_C(pc, selectFirebird.FieldByName('PRICE').AsString))
            else begin
              updateMySql.ParamByName('PRICE').Value := 0;
              updateMySql.ParamByName('ORDERCOUNT').Value := 0;
              updateMySql.ParamByName('COREID').Clear;
            end;
          end
          else begin
            updateMySql.ParamByName('PRICE').Value := selectFirebird.FieldByName('SENDPRICE').Value;
          end;
          updateMySql.Execute;
          selectFirebird.Next;
        end;
      end;
    finally
      selectFirebird.Close;
    end;

    if Assigned(pc) then
      pc.Free;

    selectMySql.SQL.Text := 'select * from analitf.params where id = 0';
    selectMySql.Open;
    selectFirebird.SelectSQL.Text := 'select * from params where id = 0';
    selectFirebird.Open;
    try
      UpdateParamsSQL := '';
      for I := 0 to selectMySql.FieldCount-1 do
        if not AnsiSameText(selectMySql.Fields[i].FieldName, 'ID') then begin
          ExistsField := selectFirebird.FindField(selectMySql.Fields[i].FieldName);
          if Assigned(ExistsField) then begin
            if Length(UpdateParamsSQL) > 0 then
              UpdateParamsSQL := UpdateParamsSQL + ', ';
            UpdateParamsSQL := UpdateParamsSQL + ExistsField.FieldName + ' = :' + ExistsField.FieldName;
          end;
        end;

      UpdateParamsSQL := 'update analitf.params set ' + UpdateParamsSQL + ' where id = 0';
      updateMySql.SQL.Text := UpdateParamsSQL;

      AProc.LogCriticalError('Получившийся update для params: ' + UpdateParamsSQL);

      for I := 0 to selectFirebird.FieldCount-1 do begin
        ExistsParam := updateMySql.FindParam(selectFirebird.Fields[i].FieldName);
        if Assigned(ExistsParam)
        then
          ExistsParam.Value := selectFirebird.Fields[i].Value;
      end;

      updateMySql.ParamByName('CDS').AsString := newCDS;
      if (updateMySql.ParamByName('ORDERSHISTORYDAYCOUNT').Value >= 21) and
         (updateMySql.ParamByName('ORDERSHISTORYDAYCOUNT').Value <= 30)
      then
        updateMySql.ParamByName('ORDERSHISTORYDAYCOUNT').Value := 35;

      updateMySql.Execute;

    finally
      selectFirebird.Close;
      selectMySql.Close;
    end;


    updateMySql.SQL.Text := 'update analitf.params set ProviderMDBVersion = 50 where Id = 0';
    updateMySql.Execute;

  finally
    selectFirebird.Free;
    selectMySql.Free;
    updateMySql.Free;
  end;
end;

initialization
  PassC := TINFCrypt.Create(gcp, 48);
  SummarySelectedPrices := TStringList.Create;
  SynonymSelectedPrices := TStringList.Create;
finalization
  PassC.Free;
  ClearSelectedPrices(SummarySelectedPrices);
  ClearSelectedPrices(SynonymSelectedPrices);
  SummarySelectedPrices.Free;
  SynonymSelectedPrices.Free;
end.
