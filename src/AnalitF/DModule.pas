unit DModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Variants, FileUtil, ARas, ComObj, FR_Class, FR_View,
  FR_DBSet, FR_DCtrl, FR_RRect, FR_Chart, FR_Shape, FR_ChBox, 
  frRtfExp, frexpimg, FR_E_HTML2, FR_E_TXT, FR_Rich,
  CompactThread, Math, IdIcmpClient, 
  incrt, hlpcodecs, StrUtils, RxMemDS,
  Contnrs, SevenZip, infvercls, IdHashMessageDigest, IdSSLOpenSSLHeaders, 
  U_UpdateDBThread, DateUtils, ShellAPI, IdHTTP,
  IdGlobal, FR_DSet, Menus, MyEmbConnection, DBAccess, MyAccess, MemDS,
  MyServerControl, DASQLMonitor, MyDacMonitor, MySQLMonitor, MyBackup, MyClasses,
  MyDump, MySqlApi, DAScript, MyScript, DataIntegrityExceptions, DatabaseObjects,
  MyCall,
  Registry,
  RegistryHelper,
  ExclusiveParams,
  AddressController,
  KeyboardHelper,
  SupplierController,
  DayOfWeekHelper,
  UserActions;

{
Криптование
  Синонимы - все в хексе без %
  Цена     - все в хексе без %
  Code, CodeCr - смешанный тип
}

{$ifdef USEMEMORYCRYPTDLL}
  {$ifndef USENEWMYSQLTYPES}
    {$define USENEWMYSQLTYPES}
  {$endif}
{$endif}

const
  HistoryMaxRec=5;
  //макс. кол-во писем доставаемых с сервера
  RegisterId=59; //код реестра в справочнике фирм
  //Строка для шифрации паролей
  PassPassW = 'sh' + #90 + 'kjw' + #10 + 'h';
  //Список критических библиотек
  CriticalLibraryHashes : array[0..17] of array[0..4] of string =
  (
      ('dbrtl70.bpl', '0650B08C', '583E1038', '5F35A236', '6DD703FA'),
      ('designide70.bpl', 'F16F1849', 'E4827C1D', 'C4FD04B9', '968D63F9'),
      ('EhLib70.bpl', '10FCCB4D', '5DE0A836', 'CCBC83EC', 'B5A52ACC'),
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
    ecDBUpdateError, ecDiffDBVersion, ecDeleteDBFiles, ecDeleteOldMysqlFolder,
    ecLibMysqlDCorrupted);

  TRetailMarkup = class
   public
    LeftLimit,
    RightLimit,
    Markup,
    MaxMarkup,
    MaxSupplierMarkup : Double;
    constructor Create(
      LeftLimit,
      RightLimit,
      Markup,
      MaxMarkup,
      MaxSupplierMarkup : Double);
  end;

  TSelectPrice = class
    PriceCode :Integer;
    RegionCode : Int64;
    Selected : Boolean;
    PriceName : String;
    PriceSize : Integer;
    constructor Create(PriceCode:Integer; RegionCode : Int64;
    Selected : Boolean;
    PriceName : String;
    PriceSize : Integer);
  end;

  TOrderInfo = class
    PriceCode : Integer;
    RegionCode : Int64;
    Summ : Currency;
    constructor Create(PriceCode:Integer; RegionCode : Int64);
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
    frdsReportOrder: TfrDBDataSet;
    MyConnection: TMyConnection;
    adtParamsOld: TMyTable;
    adtClients: TMyQuery;
    adtClientsCLIENTID: TLargeintField;
    adtClientsNAME: TStringField;
    adtClientsREGIONCODE: TLargeintField;
    adtClientsEXCESS: TIntegerField;
    adtClientsDELTAMODE: TSmallintField;
    adtClientsMAXUSERS: TIntegerField;
    adtClientsREQMASK: TLargeintField;
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
    adsRepareOrdersClientName: TStringField;
    MyEmbConnection: TMyEmbConnection;
    adsRepareOrdersClientId: TLargeintField;
    adsRepareOrdersProductId: TLargeintField;
    adsUser: TMyQuery;
    dsUser: TDataSource;
    adsPrintOrderHeader: TMyQuery;
    adsRepareOrdersCodeFirmCr: TLargeintField;
    adcTemporaryTable: TMyQuery;
    adsRepareOrdersRealPrice: TFloatField;
    adsOrderCoreRealCost: TFloatField;
    adsRepareOrdersDropReason: TSmallintField;
    adsRepareOrdersServerCost: TFloatField;
    adsRepareOrdersServerQuantity: TIntegerField;
    adsOrderDetailsRealPrice: TFloatField;
    adsOrderDetailsSupplierPriceMarkup: TFloatField;
    adsRepareOrdersSupplierPriceMarkup: TFloatField;
    adsOrderDetailsCoreQuantity: TStringField;
    adsOrderDetailsServerCoreID: TLargeintField;
    adsOrderDetailsUnit: TStringField;
    adsOrderDetailsVolume: TStringField;
    adsOrderDetailsNote: TStringField;
    adsOrderDetailsPeriod: TStringField;
    adsOrderDetailsDoc: TStringField;
    adsOrderDetailsRegistryCost: TFloatField;
    adsOrderDetailsVitallyImportant: TBooleanField;
    adtClientsAddress: TStringField;
    adtClientsDirector: TStringField;
    adtClientsDeputyDirector: TStringField;
    adtClientsAccountant: TStringField;
    adtClientsMethodOfTaxation: TSmallintField;
    adsRepareOrdersCoreQuantity: TStringField;
    adsRepareOrdersServerCoreID: TLargeintField;
    adsRepareOrdersUnit: TStringField;
    adsRepareOrdersVolume: TStringField;
    adsRepareOrdersNote: TStringField;
    adsRepareOrdersPeriod: TStringField;
    adsRepareOrdersDoc: TStringField;
    adsRepareOrdersRegistryCost: TFloatField;
    adsRepareOrdersVitallyImportant: TBooleanField;
    adsRepareOrdersProducerCost: TFloatField;
    adsRepareOrdersNDS: TSmallintField;
    adsOrderDetailsProducerCost: TFloatField;
    adsOrderDetailsNDS: TSmallintField;
    adtClientsCalculateWithNDS: TBooleanField;
    frDBDataSet: TfrDBDataSet;
    adtClientsEditName: TStringField;
    adsOrderDetailsEtalon: TMyQuery;
    adsOrderDetailsRetailMarkup: TFloatField;
    adtClientsSelfAddressId: TStringField;
    adsOrderDetailsRetailCost: TFloatField;
    adsOrderDetailsRetailVitallyImportant: TBooleanField;
    adsOrderDetailsComment: TStringField;
    adsOrderDetailsPrintPrice: TFloatField;
    adtParams: TMyQuery;
    procedure DMCreate(Sender: TObject);
    procedure adtClientsOldAfterOpen(DataSet: TDataSet);
    procedure MainConnectionOldAfterConnect(Sender: TObject);
    procedure adtParamsOldAfterPost(DataSet: TDataSet);
    procedure adtReceivedDocsAfterPost(DataSet: TDataSet);
  private
    //Требуется ли подтверждение обмена
    FNeedCommitExchange : Boolean;
    //Код подтверждения обновления, полученный с сервера
    FServerUpdateId : String;
    DBUIN : String;
    //Требуется обновления из-за того, что некорректный UIN
    FNeedUpdateByCheckUIN : Boolean;
    //Требуется обновления из-за того, что некорректные Hash'и компонент
    FNeedUpdateByCheckHashes : Boolean;
    //Требуется импорт после восстановления из эталонной копии
    FNeedImportAfterRecovery : Boolean;
    //Была создана "чистая" база данных
    FCreateClearDatabase     : Boolean;
    FGetCatalogsCount : Integer;
    FRetMargins : TObjectList;
    FVitallyImportantMarkups : TObjectList;
    HTTPC : TINFCrypt;
    OrdersInfo : TStringList;
    //Запрещен любой обмен с сервером из-за разницы во времени
    FDisableAllExchange : Boolean;

    //Было произведено обновление программы с Firebird на MySql
    FProcessFirebirdUpdate : Boolean;

    //Было произведено обновление программы с версии 800-x на 945
    FProcess800xUpdate : Boolean;

    //Было произведено обновление программы на новую версию libmysqld
    FProcessUpdateToNewLibMysqlD : Boolean;
    //Не были восстановлены в процессе обновления со старой базы данных на новую
    FNotImportedWithUpdateToNewLibMysql : TRepairedObjects;

    procedure CheckRestrictToRun;
    procedure CheckDBFile;
    procedure ReadPasswords;
    function CheckCopyIDFromDB : Boolean;
    function GetCatalogsCount : Integer;
    procedure LoadSelectedPrices;
    function CheckCriticalLibrary : Boolean;
    function GetFileHash(AFileName : String) : String;
    //Проверяем версию базы и обновляем ее в случае необходимости
    procedure UpdateDB;
    //Обновления UIN в базе данных в случае обновления версии программы
    procedure UpdateDBUIN(dbCon : TCustomMyConnection);
    //Проверяем наличие всех объектов в базе данных
    procedure CheckDBObjectsWithDatabaseController(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
{$ifdef ExportData}
    procedure ExportDBObjectsWithDatabaseController(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ImportDBObjectsWithDatabaseController(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ProcessExportImport;
{$endif}
    //Проверяем и обновляем определенный файл
    procedure UpdateDBFile(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure OnScriptExecuteError(Sender: TObject;
      E: Exception; SQL: String; var Action: TErrorAction);
    procedure UpdateDBFileDataFor64(dbCon : TCustomMyConnection);
    procedure UpdateDBFileDataFor66(dbCon : TCustomMyConnection);
    procedure DeleteRegistryCostColumn(CurrentKey : TRegistry);
    procedure DeletePriceRetColumn(CurrentKey : TRegistry);
    //Установить галочку отправить для текущих заказов
    procedure SetSendToNotClosedOrders;
    function GetFullLastCreateScript : String;
    //создаем базу данных
    procedure CreateClearDatabaseFromScript(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    //восстанавливаем базу данных из предыдущей успешной копии
    procedure RestoreDatabaseFromPrevios(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    //Производим обновлением базы данных с 800-х версий на базу данных MySql нового формата
    procedure Update800xToMySql(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ExportFrom800xToFiles(oldMySqlDB : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    procedure Import800xFilesToMySql(dbCon : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    //Производим обновление базы данных на libmysqld  нового формата
    procedure UpdateToNewLibMySqlD(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ExportFromOldLibMysqlDToFiles(oldMySqlDB : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    procedure ImportOldLibMysqlDFilesToMySql(dbCon : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    procedure UpdateToNewLibMySqlDWithGlobalParams(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ExportGlobalParamsFromOldLibMysqlDToFile(oldMySqlDB : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    procedure ImportOldLibMysqlDGlobalParamsFileToMySql(dbCon : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    //Производим восстановлени из эталонной копии (если она существует) или создаем чистую базу данных
    procedure RecoverDatabase(E : Exception);
{$ifdef DEBUG}
{$ifndef USENEWMYSQLTYPES}
    procedure ExtractDBScript(dbCon : TCustomMyConnection);
{$endif}
{$endif}
{//$define TestEmbeddedMysql}
{$ifdef TestEmbeddedMysql}
    procedure TestEmbeddedMysql;
  {$ifndef USEMYSQLSTANDALONE}
    procedure TestOpenDatabase;
    procedure TestDumpDatabase;
    procedure TestEmbeddedThread;
  {$endif}
    procedure TestDirectoriesOperation;
{$endif}
    function GetMainConnection: TCustomMyConnection;
    procedure PatchMyDataSets;
    procedure InternalCloseMySqlDB;
    //Удаляем старую директорию с Mysql и директорию с эталонными данными
    procedure DeleteOldMysqlFolder;
    //Подготовка директорий к 800-x версий к обновлению
    procedure PrepareUpdate800xToMySql;
    //Подготовка директорий старой libmysqld к обновлению
    procedure PrepareUpdateToNewLibMySqlD;
{$ifdef USEMEMORYCRYPTDLL}
    procedure CheckSpecialLibrary;
{$endif}
{$ifdef DEBUG}
    procedure MySQLMonitorSQL(Sender: TObject; Text: String;
      Flag: TDATraceFlag);
{$endif}
    procedure SetNetworkSettings;
    procedure CheckLocalTime;
    procedure ExtractRollbackAF();
  public
    FFS : TFormatSettings;
    SerBeg,
    SerEnd : String;
    SaveGridMask : Integer;
    GlobalExclusiveParams : TExclusiveParams;
    
    AutoComment : String;

    procedure CompactDataBase();
    procedure ShowFastReport(FileName: string; DataSet: TDataSet = nil;
      APreview: boolean = False; PrintDlg: boolean = True);
    procedure ShowFastReportWithSave(FileName: string; DataSet: TDataSet = nil;
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

    function D_HP(HTTPPassC: String) : String;
    function E_HP(HTTPPass: String) : String;
    procedure SavePass(ASGM : String);
    procedure LoadRetailMargins;
    procedure LoadVitallyImportantMarkups;
    procedure LoadMarkups(TableName : String; Markups : TObjectList);
    //Получить розничную цену товара в зависимости от наценки
    function GetPriceRet(BaseCost : Currency) : Currency;
    //Получить розничную цену товара в зависимости от определенной наценки
    function GetPriceRetByMarkup(BaseCost : Currency; Markup : Currency) : Currency;
    //Получить розничную наценку товара
    function GetRetUpCost(BaseCost : Currency) : Currency;
    //Получить розничную наценку товара от розничной цены
    function GetRetUpCostByRetailCost(BaseCost : Currency; RetailCost : Currency) : Currency;
    function GetRetailCost(
      VitallyImportant : Boolean;
      NDS : Variant;
      ProducerCost : Variant;
      SupplierCost : Currency
    ) : Currency;
    function CalcRetailMarkup(
      VitallyImportant : Boolean;
      ProducerCost : Variant;
      SupplierCost : Currency
    ) : Variant;
    function InternalCalcRetailCost(
      markup : Currency;
      VitallyImportant : Boolean;
      NDS : Variant;
      ProducerCost : Variant;
      SupplierCost : Currency
    ) : Currency;
    procedure CalcRetailCost(
      VitallyImportant : Boolean;
      NDS : Variant;
      ProducerCost : Variant;
      SupplierCost : Currency;
      RetailMarkup : TField;
      RetailCost : TField
    );
    function GetRetailCostByMarkup(
      VitallyImportant : Boolean;
      NDS : Variant;
      ProducerCost : Variant;
      SupplierCost : Currency;
      markup : Currency
    ) : Currency;
    function GetMaxRetailMarkup(BaseCost : Currency) : Currency;
    function GetMaxRetailSupplierMarkup(BaseCost : Currency) : Currency;
    //Получить наценку товара для ЖНВЛС
    function GetVitallyImportantMarkup(BaseCost : Currency) : Currency;
    function GetMaxVitallyImportantMarkup(BaseCost : Currency) : Currency;
    function GetMaxVitallyImportantSupplierMarkup(BaseCost : Currency) : Currency;
    function VitallyImportantMarkupsExists : Boolean;

    function GetRetailMarkup(Markups : TObjectList; BaseCost : Currency) : TRetailMarkup;
    function GetMarkup(Markups : TObjectList; BaseCost : Currency) : Currency;

    function GetRetailCostLast(
      VitallyImportant : Boolean;
      SupplierCost : Currency
    ) : Currency;
    function GetRetailMarkupValue(
      VitallyImportant : Boolean;
      SupplierCost : Currency
    ) : Currency;

    //Обрабатываем папки с документами
    procedure ProcessDocs(ImportDocs : Boolean);
    //обрабатываем каждую конкретную папку
    procedure ProcessDocsDir(DirName : String; MaxFileDate : TDateTime; FileList : TStringList);
    procedure OpenDocsDir(DirName : String; FileList : TStringList; OpenEachFile : Boolean);

    //получить сумму заказа
    function  GetSumOrder (OrderID : Integer; Closed : Boolean = False) : Currency;
    procedure GetOrderInfo (
      OrderID : Int64;
      var PriceName,
      RegionName :String);
    //получить сумму заказа по PriceCode и RegionCode
    function FindOrderInfo (PriceCode: Integer; RegionCode : Int64) : Currency;

    property NeedImportAfterRecovery : Boolean read FNeedImportAfterRecovery;
    property CreateClearDatabase : Boolean read FCreateClearDatabase;
    property DisableAllExchange : Boolean read FDisableAllExchange;
    property NeedUpdateByCheckUIN : Boolean read FNeedUpdateByCheckUIN;
    property NeedUpdateByCheckHashes : Boolean read FNeedUpdateByCheckHashes;
    property ProcessFirebirdUpdate : Boolean read FProcessFirebirdUpdate;
    property Process800xUpdate : Boolean read FProcess800xUpdate;
    property ProcessUpdateToNewLibMysqlD : Boolean read FProcessUpdateToNewLibMysqlD;
    property NotImportedWithUpdateToNewLibMysql : TRepairedObjects read FNotImportedWithUpdateToNewLibMysql;
    //Установить параметры для компонента TIdHTTP
    procedure InternalSetHTTPParams(SetHTTP : TIdHTTP);
    function  QueryValue(SQL : String; Params: array of string; Values: array of Variant) : Variant;
    property MainConnection : TCustomMyConnection read GetMainConnection;
    //произвести вставку заголовка заказа, чтобы потом обновить кол-во при заказе позиции
    procedure InsertOrderHeader(orderDataSet : TCustomMyDataSet);
    procedure CheckDataIntegrity;
    //Получить информацию о клиенте
    procedure GetClientInformation(
      var ClientName : String;
      var IsFutureClient : Boolean);
    function GetEditNameAndAddress : String;
    function GetClearSendResultSql(ClientId : Int64) : String;
    function NeedUpdate800xToMySql : Boolean;
    function NeedUpdateToNewLibMySqlD : Boolean;
    function NeedUpdateToNewLibMySqlDWithGlobalParams : Boolean;
    function NeedCumulativeAfterUpdateToNewLibMySqlD : Boolean;
    function DataSetToString(
      SQL : String;
      Params: array of string;
      Values: array of Variant) : String;
    procedure CheckNewNetworkVersion;

    function AllowAutoComment : Boolean;
    procedure UpdateComment(
      comment : String;
      OrderId : Int64;
      CoreId : Variant);

    procedure InsertUserActionLog(UserActionId : TUserAction); overload;  
    procedure InsertUserActionLog(UserActionId : TUserAction; Contexts : array of string); overload;

  end;

var
  DM: TDM;
  PassC : TINFCrypt;
  SummarySelectedPrices,
  SynonymSelectedPrices,
  MinCostSelectedPrices : TStringList;

procedure ClearSelectedPrices(SelectedPrices : TStringList);

function GetSelectedPricesSQL(SelectedPrices : TStringList; Suffix : String = '') : String;

function gcp : String;

function gop : String;

implementation

{$R *.DFM}

uses AProc, Main, DBProc, Exchange, Constant, SysNames, UniqueID, RxVerInf,
     LU_Tracer, LU_MutexSystem, Config, U_ExchangeLog,
     U_DeleteDBThread, SQLWaiting, INFHelpers, PostWaybillsController,
     StartupHelper,
     NetworkSettings,
     Core,
     SynonymSearch,
     CoreFirm;

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

function CloseDB: Boolean;
begin
  try
    WriteExchangeLog('AnalitF', 'Попытка закрыть программу.');
    if Assigned(DM) then begin
      if DM.MainConnection.Connected then begin
        DM.InsertUserActionLog(uaStop);
        try
          DM.adtParams.Edit;
          DM.adtParams.FieldByName( 'ClientId').Value :=
            DM.adtClients.FieldByName( 'ClientId').Value;
          DM.adtParams.Post;
        except
          on E : Exception do
            AProc.LogCriticalError('Ошибка при изменении ClientId: ' + E.Message);
        end;
        DM.ResetStarted;
      end;

      ShowSQLWaiting(DM.InternalCloseMySqlDB, 'Происходит завершение программы');
    end;
    WriteExchangeLog('AnalitF', 'Программа закрыта.');
  except
    on E : Exception do
      LogCriticalError('Ошибка при завершении и закрытии БД: ' + E.Message);
  end;
  Result := True;
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
  SetNetworkSettings;

{$ifdef DEBUG}
  MySQLMonitor.Active := False;
  MySQLMonitor.OnSQL := MySQLMonitorSQL;
{$endif}
  FRetMargins := TObjectList.Create(True);
  FVitallyImportantMarkups := TObjectList.Create(True);;

  WriteExchangeLog('AnalitF', 'Программа установлена в каталог: "' + ExtractFileDir(ParamStr(0)) + '"');
  mainStartupHelper.Write('DModule', 'Начали подготовительные действия');

  FProcessFirebirdUpdate := False;
  FProcess800xUpdate := False;
  FProcessUpdateToNewLibMysqlD := False;

  if GetNetworkSettings().IsNetworkVersion then begin
    DatabaseController.FreeMySQLLib('MySql Clients Count при запуске сетевой версии');
    DatabaseController.SwithTypes(False);
  end;

  if not DirectoryExists( RootFolder() + SDirUpload) then CreateDir( RootFolder() + SDirUpload);
  if not GetNetworkSettings().IsNetworkVersion then begin
    if not DirectoryExists( ExePath + SDirTableBackup) then CreateDir( ExePath + SDirTableBackup);
    if not DirectoryExists( ExePath + SDirDataTmpDir) then
      CreateDir( ExePath + SDirDataTmpDir)
    else
      DeleteFilesByMask(ExePath + SDirDataTmpDir + '\*.*', False);
  end;
  //MySqlApi.MySQLEmbDisableEventLog := True;

  if NeedUpdate800xToMySql then
    ShowSQLWaiting(PrepareUpdate800xToMySql, 'Происходит подготовка к обновлению');

  if NeedUpdateToNewLibMySqlD then
    ShowSQLWaiting(PrepareUpdateToNewLibMySqlD, 'Происходит подготовка к обновлению');

  DeleteOldMysqlFolder;

  mainStartupHelper.Write('DModule', 'Закончили подготовительные действия');

{$ifdef USEMEMORYCRYPTDLL}
  mainStartupHelper.Write('DModule', 'Начали проверку специализированной библиотеки');
  CheckSpecialLibrary;
  mainStartupHelper.Write('DModule', 'Закончили проверку специализированной библиотеки');
{$endif}

  //Устанавливаем параметры embedded-соединения
  MyEmbConnection.Params.Clear();
{$ifndef USENEWMYSQLTYPES}
  MyEmbConnection.Params.Add('--basedir=' + ExtractFileDir(ParamStr(0)) + '\');
  MyEmbConnection.Params.Add('--datadir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirData  + '\');
  MyEmbConnection.Params.Add('--character_set_server=cp1251');
  MyEmbConnection.Params.Add('--skip-innodb');
  MyEmbConnection.Params.Add('--tmp_table_size=' + DatabaseController.GetMaxTempTableSize());
  MyEmbConnection.Params.Add('--max_heap_table_size=' + DatabaseController.GetMaxTempTableSize());
  MyEmbConnection.Params.Add('--tmpdir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirDataTmpDir  + '\');
{$else}
  MyEmbConnection.Params.Add('--basedir=' + ExtractFileDir(ParamStr(0)) + '\');
  MyEmbConnection.Params.Add('--datadir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirData  + '\');
  MyEmbConnection.Params.Add('--character_set_server=cp1251');
  MyEmbConnection.Params.Add('--tmp_table_size=' + DatabaseController.GetMaxTempTableSize());
  MyEmbConnection.Params.Add('--max_heap_table_size=' + DatabaseController.GetMaxTempTableSize());
  MyEmbConnection.Params.Add('--tmpdir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirDataTmpDir  + '\');

  MyEmbConnection.Params.Add('--sort_buffer_size=64M');
  MyEmbConnection.Params.Add('--read_buffer_size=2M');
  //MyEmbConnection.Params.Add('--write_buffer_size=2M');
  //Для настройки этого параметра необходимо получить 60% свободной памяти
  //MyEmbConnection.Params.Add('--key_buffer_size==30M');
{$endif}

{$ifdef UsePrgDataTest}
  SerBeg := 'Prg';
  SerEnd := 'DataSmart';
{$else}
  SerBeg := 'Prg';
  {$ifdef DEBUG}
  SerEnd := 'Data';
  {$else}
  SerEnd := 'DataEx';
  {$endif}
{$endif}
  HTTPS := 'rkhgjsdk';
  HTTPE := 'fhhjfgfh';

  PatchMyDataSets;

  OrdersInfo := TStringList.Create;
  OrdersInfo.Sorted := True;

  //adsOrderDetails.OnCalcFields := ocf;
 // adsOrderCore.OnCalcFields := occf;

  HTTPC := TINFCrypt.Create(HTTPS + HTTPE, 255);

  ResetNeedCommitExchange;
  FillChar(FFS, SizeOf(FFS), 0);
  GetLocaleFormatSettings(0, FFS);
  FFS.ThousandSeparator := #0;
  FFS.DecimalSeparator := '.';

  if not IsOneStart then
    LogExitError('Запуск двух копий программы на одном компьютере невозможен.', Integer(ecDoubleStart));

  if GetNetworkSettings().IsNetworkVersion then
    CheckNewNetworkVersion;

  WriteExchangeLog('AnalitF', 'Программа запущена.');

{$ifdef TestEmbeddedMysql}
  TestEmbeddedMysql();
  ExitProcess(1);
{$endif}

{
  try
    MainConnection.Open;
  except
    on E : Exception do
      LogExitError(Format( 'Невозможно открыть базу данных: %s ', [ E.Message ]), Integer(ecDBFileError));
  end;
}  

  //Удаляем файлы базы данных для переустановки
{
  if FindCmdLineSwitch('renew') then
    RunDeleteDBFiles();
}    

{$ifdef ExportData}
  //экспорт/импорт файлов от клиента
  ProcessExportImport;
{$endif}  

{
  FNeedImportAfterRecovery := False;
  FCreateClearDatabase     := False;
  if DatabaseController.IsBackuped then
    try
      DatabaseController.RestoreDatabase;
      FNeedImportAfterRecovery := True;
    except
      on E : Exception do
        LogExitError(Format( 'Невозможно восстановить базу данных из резервной копии : %s ', [ E.Message ]), Integer(ecDBFileError));
    end;
}    

{
  if FileExists(ExePath + DatabaseName) and ((FileGetAttr(ExePath + DatabaseName) and SysUtils.faReadOnly) = SysUtils.faReadOnly)
  then
    LogExitError(Format( 'Файл базы данных %s имеет атрибут "Только чтение".', [ ExePath + DatabaseName ]), Integer(ecDBFileReadOnly));
    }

  mainStartupHelper.Write('DModule', 'Начали проверку базы данных');
  //Делаем проверку файла базы данных и в случае проблем производим восстановление из предыдущей удачной копии
  //Проверяем файл, если используем Embedded-сервер, в ином случае - происходит процесс разработки программы и проверять ничего не надо
  if MainConnection is TMyEmbConnection then
    CheckDBFile
  else begin
    if GetNetworkSettings().IsNetworkVersion then
      CheckDBFile;
{$ifdef DEBUG}
    try
      MainConnection.Database := 'analitf';
      MainConnection.Open;
      try
{$ifndef USENEWMYSQLTYPES}
        ExtractDBScript(MainConnection);
{$endif}
      finally
        MainConnection.Close;
      end;
    finally
      MainConnection.Database := '';
    end;
{$endif}
  end;
  mainStartupHelper.Write('DModule', 'Закончили проверку базы данных');

  mainStartupHelper.Write('DModule', 'Начали проверки для запуска');
  try
    try
      CheckRestrictToRun;
    finally
      MainConnection.Close;
    end;
  except
    on E : Exception do
      LogExitError(Format( 'Невозможно открыть файл базы данных : %s '#13#10'Обратитесь в АК Инфорум.', [ E.Message ]), Integer(ecDBFileError));
  end;
  mainStartupHelper.Write('DModule', 'Закончили проверки для запуска');

  MainConnection.Open;
  GlobalExclusiveParams := TExclusiveParams.Create(MainConnection);
{$ifdef DEBUG}
  WriteExchangeLog('DModule',
      Concat('UserActionLogs', #13#10,
        DM.DataSetToString('select Id, LogTime, UserActionId, Context from UserActionLogs', [], [])));
{$endif}
  InsertUserActionLog(uaStart);

  //todo: здесь могут быть ошибки при создании папки, их надо обработать
  if not GetNetworkSettings.IsNetworkVersion then
    if not WaybillsHelper.CheckWaybillFolders(MainConnection) then
      AProc.MessageBox('Необходимо настроить папки для загрузки накладных на форме "Конфигурация"', MB_ICONWARNING);

  { устанавливаем текущие записи в Clients и Users }
  if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
    then adtClients.First;

  SetStarted;
  ClientChanged;

  GetAddressController.UpdateAddresses(MainConnection, DM.adtClientsCLIENTID.Value);
  GetSupplierController.UpdateSuppliers(MainConnection);

  { устанавливаем параметры печати }
  frReport.Title := Application.Title;
  { проверяем и если надо создаем нужные каталоги }
  if not DirectoryExists( RootFolder() + SDirDocs) then CreateDir( RootFolder() + SDirDocs);
  if not DirectoryExists( RootFolder() + SDirWaybills) then CreateDir( RootFolder() + SDirWaybills);
  if not DirectoryExists( RootFolder() + SDirRejects) then CreateDir( RootFolder() + SDirRejects);
  if not DirectoryExists( RootFolder() + SDirIn) then CreateDir( RootFolder() + SDirIn);
  if not DirectoryExists( ExePath + SDirIn) then CreateDir( ExePath + SDirIn);
  if not DirectoryExists( ExePath + SDirReclame) then CreateDir( ExePath + SDirReclame);
  if not DirectoryExists( RootFolder() + SDirReclame) then CreateDir( RootFolder() + SDirReclame);
  if not DirectoryExists( RootFolder() + SDirPromotions) then CreateDir( RootFolder() + SDirPromotions);
  //if not DirectoryExists( RootFolder() + SDirContextReclame) then CreateDir( RootFolder() + SDirContextReclame);
  MainForm.SetUpdateDateTime;
  Application.HintPause := 0;

  DeleteFilesByMask(ExePath + SDirIn + '\*.zip', False);
  DeleteFilesByMask(ExePath + SDirIn + '\*.zi_', False);
  DeleteFilesByMask(RootFolder() + SDirIn + '\*.zip', False);
  DeleteFilesByMask(RootFolder() + SDirIn + '\*.zi_', False);

  SetSendToNotClosedOrders;

  CheckLocalTime;

  if not DisableAllExchange then begin
    if FNeedUpdateByCheckUIN then begin
      UpdateByCheckUINExchangeActions := [eaGetPrice];
      if (adtParams.FieldByName( 'UpdateDateTime').AsDateTime <> adtParams.FieldByName( 'LastDateTime').AsDateTime)
      then
        UpdateByCheckUINExchangeActions := UpdateByCheckUINExchangeActions + [eaGetFullData];

      if not RunExchange(UpdateByCheckUINExchangeActions)
      then begin
        //Если не получилось обновиться, то отображаем форму конфигурации для корректировки настроек и авторизации
        UpdateByCheckUINSuccess := (ShowConfig(True) * AuthChanges) <> [];

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

    if FNeedUpdateByCheckHashes then begin
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
        //Здесь надо корректно обрабатывать передачу сессионого ключа при обновлении программы
        RunExchange([eaImportOnly]);
      Application.Terminate;
    end;
  end;

  if adtParams.FieldByName('HTTPNameChanged').AsBoolean then
    MainForm.DisableByHTTPName;
end;

procedure TDM.ClientChanged;
begin
  GetClientInformation(MainForm.CurrentUser, MainForm.IsFutureClient);
  //Если действия происходят в основной ветки приложения, то позволяем работать
  //с визуальными компонентами
  if GetCurrentThreadId = MainThreadID then begin
    //Закрываем все формы перед сменой клиента, т.к. их вид зависит от клиента
    MainForm.FreeChildForms;
    MainForm.SetOrdersInfo;
  end;
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
begin
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
    FGetCatalogsCount := GetCatalogsCount;
    if not GetNetworkSettings().IsNetworkVersion then begin
      MaxUsers := DM.adtClients.FieldByName( 'MaxUsers').AsInteger;
      try
        MyServerControl.ShowProcessList();
        ProcessCount := MyServerControl.RecordCount;
      finally
        MyServerControl.Close;
      end;
    end;
  finally
    DM.MainConnection.Close;
  end;

  if not GetNetworkSettings().IsNetworkVersion then begin
    if ( MaxUsers > 0) and ( ProcessCount > MaxUsers)
    then
      LogExitError(Format( 'Исчерпан лимит на подключение к базе данных (копий : %d). ' +
        'Запуск программы невозможен.', [ MaxUsers]), Integer(ecUserLimit));

    if GetDiskFreeSpaceEx(PChar(ExtractFilePath(ParamStr(0))), FreeAvail, Total, @TotalFree) then begin
      DBFileSize := GetDirectorySize(ExePath + SDirData);
      DBFileSize := Max(2*DBFileSize, 200*1024*1024);
      if DBFileSize > FreeAvail then
        LogExitError(Format( 'Недостаточно свободного места на диске для запуска приложения. Необходимо %s.',
        [ FormatByteSize(DBFileSize) ]),
        Integer(ecFreeDiskSpace));
    end
    else
      LogExitError(Format( 'Не удается получить количество свободного места на диске.' +
        #13#10#13#10'Сообщение об ошибке:'#13#10'%s', [ SysErrorMessage(GetLastError) ]), Integer(ecGetFreeDiskSpace));
  end;

  FNeedUpdateByCheckUIN := not CheckCopyIDFromDB;
{$ifdef ViewAsTable}
  FNeedUpdateByCheckUIN := False;
{$endif}
  if FNeedUpdateByCheckUIN then begin
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

  FNeedUpdateByCheckHashes := not CheckCriticalLibrary;
  if FNeedUpdateByCheckHashes then
    AProc.MessageBox( 'Ошибка проверки подлинности компонент программы. Необходимо выполнить обновление данных.',
      MB_ICONERROR or MB_OK);
end;

procedure TDM.CompactDataBase();
begin
  MainConnection.Open;
  try
{//$ifndef USENEWMYSQLTYPES}
    //todo: Надо будет восстановить сжатие, когда сборка Михаила сможет восстанавливать таблицы
    DatabaseController.OptimizeObjects(MainConnection);
{//$endif}
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
    frDBDataSet.DataSet := DataSet;

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
  LastClientId : Variant;
  MaxClientNameWidth, CurrentClientNameWidth : Integer;
begin
  if (adtClients.RecordCount > 0) and not adtParams.FieldByName('ClientId').IsNull then
    if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
    then begin
      adtClients.First;
      adtParams.Edit;
      adtParams.FieldByName( 'ClientId').Value := adtClients.FieldByName( 'ClientId').Value;
      adtParams.Post;
    end;

  //Если действия происходят в основной ветки приложения, то позволяем работать
  //с визуальными компонентами
  if GetCurrentThreadId() = MainThreadID then begin
    //Заполняем PopupMenu клиентов
    MainForm.pmClients.Items.Clear;
    LastClientId := adtClients.FieldByName( 'ClientId').Value;
    adtClients.First;
    MaxClientNameWidth := 0;
    while not adtClients.Eof do begin
      mi := TMenuItem.Create(MainForm.pmClients);
      mi.Name := 'miClient' + adtClients.FieldByName('ClientId').AsString;
      mi.Caption := adtClients.FieldByName('Name').AsString;
      mi.Tag := adtClients.FieldByName('ClientId').AsInteger;
      mi.Checked := LastClientId = adtClients.FieldByName('ClientId').Value;

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
  end;
  ClientChanged;
end;

//подключает в качестве внешних текстовые таблицы из папки In
procedure TDM.LinkExternalTables;
var
  SR: TSearchRec;
  FileName,
  ShortName : String;
  Files : TStringList;
  Tables : TStringList;
  I : Integer;
begin
  if FindFirst(RootFolder()+SDirIn+'\*.txt',faAnyFile,SR)=0 then begin
    Screen.Cursor:=crHourglass;
    Files := TStringList.Create;
    Tables := TStringList.Create;
    try
        if adcUpdate.Active then
          adcUpdate.Close;
        //Сначала очистили внешние таблицы от предыдущих данных
        repeat
          FileName := RootFolder()+SDirIn+ '\' + SR.Name;
          ShortName := ChangeFileExt(SR.Name,'');

          if DatabaseController.TableExists('tmp' + ShortName) then begin
            adcUpdate.SQL.Text := 'truncate tmp' + ShortName;
            adcUpdate.Execute;

            Tracer.TR('CreateExternal', ShortName);

            Files.Add(FileName);
            Tables.Add(UpperCase(ShortName));
          end;          
        until FindNext(SR)<>0;
        FindClose(SR);

        for I := 0 to Files.Count-1 do begin
          adcUpdate.SQL.Text := GetLoadDataSQL('tmp' + Tables[i], Files[i]);
          adcUpdate.Execute;
        end;

    finally
      Files.Free;
      Tables.Free;
      Screen.Cursor:=crDefault;
    end;
  end
  else
    FindClose(SR);
end;

//отключает все подключенные внешние таблицы
procedure TDM.UnLinkExternalTables;
{$ifndef DEBUG}
var
  I: Integer;
{$endif}
begin
{$ifndef DEBUG}
  //Заполняем список со всеми временными таблицами (префикс tmp) и удаляем из них данные
  for I := 0 to DatabaseController.DatabaseObjects.Count-1 do
    if (DatabaseController.DatabaseObjects[i] is TDatabaseTable)
      and AnsiStartsText('tmp', TDatabaseTable(DatabaseController.DatabaseObjects[i]).Name)
    then begin
      adcUpdate.SQL.Text := 'truncate ' + TDatabaseTable(DatabaseController.DatabaseObjects[i]).Name;
      adcUpdate.Execute;
    end;
{$endif}
end;

procedure TDM.ClearDatabase;
begin
  Screen.Cursor:=crHourglass;
  with adcUpdate do try

    MainForm.StatusText:='Очищается MinPrices';
    SQL.Text:='truncate MinPrices;'; Execute;
    MainForm.StatusText:='Очищается Core';
    SQL.Text:='truncate Core;'; Execute;
    MainForm.StatusText:='Очищается Catalog';
    SQL.Text:='truncate CATALOGS;'; Execute;
    MainForm.StatusText:='Очищается CatalogNames';
    SQL.Text:='truncate catalognames;'; Execute;
    MainForm.StatusText:='Очищается CatalogFarmGroups';
    SQL.Text:='truncate CATALOGFARMGROUPS;'; Execute;
    MainForm.StatusText:='Очищается Products';
    SQL.Text:='truncate Products;'; Execute;
    MainForm.StatusText:='Очищается PricesRegionalData';
    SQL.Text:='truncate PricesRegionalData;'; Execute;
    MainForm.StatusText:='Очищается PricesData';
    SQL.Text:='truncate PricesData;'; Execute;
    MainForm.StatusText:='Очищается RegionalData';
    SQL.Text:='truncate RegionalData;'; Execute;
    MainForm.StatusText:='Очищается Providers';
    SQL.Text:='truncate Providers;'; Execute;
    MainForm.StatusText:='Очищается Synonym';
    SQL.Text:='truncate Synonyms;'; Execute;
    MainForm.StatusText:='Очищается SynonymFirmCr';
    SQL.Text:='truncate SynonymFirmCr;'; Execute;
    MainForm.StatusText:='Очищается Defectives';
    SQL.Text:='truncate Defectives;'; Execute;
    MainForm.StatusText:='Очищается МНН';
    SQL.Text:='truncate MNN;'; Execute;
    MainForm.StatusText:='Очищаются описания';
    SQL.Text:='truncate Descriptions;'; Execute;
    MainForm.StatusText:='Очищаются макимальные цены производителей';
    SQL.Text:='truncate maxproducercosts;'; Execute;
    MainForm.StatusText:='Очищаются каталог производителей';
    SQL.Text:='truncate producers;'; Execute;
    MainForm.StatusText:='Очищаются правила минимального заказа';
    SQL.Text:='truncate minreqrules;'; Execute;
    MainForm.StatusText:='Очищаются акции поставщиков';
    SQL.Text:='truncate SupplierPromotions;'; Execute;
    SQL.Text:='truncate PromotionCatalogs;'; Execute;
    MainForm.StatusText:='Очищается расписание обновлений';
    SQL.Text:='truncate Schedules;'; Execute;
    MainForm.StatusText:='Очищается время сжатия базы данных';
    SQL.Text:='update params set LastCompact = now() where ID = 0;'; Execute;

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
      SqL.Text:='DELETE FROM CurrentOrderLists WHERE OrderCount=0'; Execute;
      SQL.Text:='DELETE FROM CurrentOrderHeads WHERE NOT Exists(SELECT OrderId FROM CurrentOrderLists WHERE OrderId=CurrentOrderHeads.OrderId)'; Execute;
      SqL.Text:='DELETE FROM PostedOrderLists WHERE OrderCount=0'; Execute;
      SQL.Text:='DELETE FROM PostedOrderHeads WHERE NOT Exists(SELECT OrderId FROM PostedOrderLists WHERE OrderId=PostedOrderHeads.OrderId)'; Execute;
    end;
  finally
    Screen.Cursor:=crDefault;
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
  DatabaseController.CreateViews(MainConnection);
  //adcTemporaryTable.Execute;
  //открываем таблицы с параметрами
  adtParams.Close;
  adtParams.Open;
  ReadPasswords;
  adsUser.Close;
  adsUser.Open;
  adtClients.Close;
  adtClients.Open;
  LoadRetailMargins;
  LoadVitallyImportantMarkups;
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
{
    SynonymPassword := Copy(adtParams.FieldByName('CDS').AsString, 1, 64);
    CodesPassword := Copy(adtParams.FieldByName('CDS').AsString, 65, 64);
    BasecostPassword := Copy(adtParams.FieldByName('CDS').AsString, 129, 64);
}
    DBUIN := Copy(adtParams.FieldByName('CDS').AsString, 193, 32);
{
    SynonymPassword := PassC.DecodeHex(SynonymPassword);
    CodesPassword := PassC.DecodeHex(CodesPassword);
    BasecostPassword := PassC.DecodeHex(BasecostPassword);
}    
    DBUIN := PassC.DecodeHex(DBUIN);
    SaveGridMaskStr := '$' + Copy(DBUIN, 9, 7);
    DBUIN := Copy(DBUIN, 1, 8);
    SaveGridMask := StrToIntDef(SaveGridMaskStr, 0);
  except
{
    SynonymPassword := '';
    CodesPassword := '';
    BasecostPassword := '';
}    
    DBUIN := '';
  end;
end;

procedure TDM.SavePass(ASGM: String);

  function GetRandomString() : String;
  var
    I : Integer;
  begin
    Result := '';
    for I := 1 to 16 do
      Result := Result + Chr(33 + Random(60));
  end;

begin
  Randomize;
  adtParams.Edit;
  adtParams.FieldByName('CDS').AsString :=
    PassC.EncodeHex(GetRandomString()) +
    PassC.EncodeHex(GetRandomString()) +
    PassC.EncodeHex(GetRandomString()) +
    PassC.EncodeHex(IntToHex(GetDBID(), 8) + ASGM);
  adtParams.Post;
end;

function TDM.GetPriceRet(BaseCost: Currency): Currency;
begin
  Result := GetPriceRetByMarkup(BaseCost, GetRetUpCost(BaseCost));
end;

procedure TDM.LoadRetailMargins;
begin
  LoadMarkups('retailmargins', FRetMargins);
end;

function TDM.GetSumOrder(OrderID: Integer; Closed : Boolean = False): Currency;
begin
  try
    if not Closed then
      Result := DM.QueryValue(
        'SELECT ifnull(Sum(CurrentOrderLists.RealPrice*CurrentOrderLists.OrderCount), 0) SumOrder '
        + 'FROM CurrentOrderLists '
        + 'WHERE CurrentOrderLists.OrderId = :OrderId AND CurrentOrderLists.OrderCount>0',
        ['OrderId'],
        [OrderID])
    else
      Result := DM.QueryValue(
        'SELECT ifnull(Sum(PostedOrderLists.RealPrice*PostedOrderLists.OrderCount), 0) SumOrder '
        + 'FROM PostedOrderLists '
        + 'WHERE PostedOrderLists.OrderId = :OrderId AND PostedOrderLists.OrderCount>0',
        ['OrderId'],
        [OrderID]);
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
    Result := QueryValue('SELECT COUNT(FullCode) AS CatNum FROM Catalogs', [], []);
  except
    Result := 0;
  end;
end;

{ TSelectPrice }

constructor TSelectPrice.Create(PriceCode:Integer; RegionCode: Int64; Selected: Boolean;
  PriceName: String; PriceSize : Integer);
begin
  Self.PriceCode := PriceCode;
  Self.RegionCode := RegionCode;
  Self.Selected := Selected;
  Self.PriceName := PriceName;
  Self.PriceSize := PriceSize;
end;

procedure TDM.LoadSelectedPrices;
begin
  ClearSelectedPrices(SummarySelectedPrices);
  ClearSelectedPrices(SynonymSelectedPrices);
  ClearSelectedPrices(MinCostSelectedPrices);
  adsPrices.IndexFieldNames := 'PRICENAME';
  adsPrices.ParamByName('ClientId').Value := DM.adtClients.FieldByName('ClientId').Value;
  if adsPrices.Active then
    adsPrices.Close;
  adsPrices.Open;
  try
    adsPrices.First;
    while not adsPrices.Eof do begin
      SummarySelectedPrices.AddObject(
        adsPricesPRICECODE.AsString + '_' + adsPricesREGIONCODE.AsString,
        TSelectPrice.Create(
          adsPricesPRICECODE.AsInteger,
          adsPricesREGIONCODE.AsLargeInt,
          True,
          adsPricesPRICENAME.Value,
          adsPricespricesize.Value));
      SynonymSelectedPrices.AddObject(
        adsPricesPRICECODE.AsString + '_' + adsPricesREGIONCODE.AsString,
        TSelectPrice.Create(
          adsPricesPRICECODE.AsInteger,
          adsPricesREGIONCODE.AsLargeInt,
          True,
          adsPricesPRICENAME.Value,
          adsPricespricesize.Value));
      MinCostSelectedPrices.AddObject(
        adsPricesPRICECODE.AsString + '_' + adsPricesREGIONCODE.AsString,
        TSelectPrice.Create(
          adsPricesPRICECODE.AsInteger,
          adsPricesREGIONCODE.AsLargeInt,
          True,
          adsPricesPRICENAME.Value,
          adsPricespricesize.Value));
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
  dbCon : TCustomMyConnection;
  DBVersion : Integer;
begin
  dbCon := DatabaseController.GetNewConnection(MainConnection);
  try

{
    dbCon.Database := MainConnection.Database;
    dbCon.Username := MainConnection.Username;
    dbCon.DataDir := TMyEmbConnection(MainConnection).DataDir;
    dbCon.Options := TMyEmbConnection(MainConnection).Options;
    dbCon.Params.Clear;
    dbCon.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
    dbCon.LoginPrompt := False;
}

{$ifdef DEBUG}
    try
//      dbCon.Database := 'analitf';
//      dbCon.Open;
      try
{$ifndef USENEWMYSQLTYPES}
//        ExtractDBScript(dbCon);
{$endif USENEWMYSQLTYPES}
      finally
//        dbCon.Close;
      end;
    finally
//      dbCon.Database := '';
    end;
{$endif}


    mainStartupHelper.Write('DModule', 'Начали проверку объектов базы данных');
    RunUpdateDBFile(
      dbCon,
      ExePath + SDirData,
      0,
      CheckDBObjectsWithDatabaseController,
      nil,
      'Происходит проверка базы данных. Подождите...');
    mainStartupHelper.Write('DModule', 'Закончили проверку объектов базы данных');

    mainStartupHelper.Write('DModule', 'Начали проверки миграций');
    dbCon.Open;
    try
      if GetNetworkSettings().IsNetworkVersion then
        dbCon.ExecSQL('use analitf;', []);
      DBVersion := DBProc.QueryValue(dbCon, 'select ProviderMDBVersion from analitf.params where id = 0', [], []);
    finally
      dbCon.Close;
      //dbCon.RemoveFromPool;
    end;

    if not GetNetworkSettings().IsNetworkVersion then begin
      if DBVersion = 50 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 51;
      end;

      if DBVersion = 51 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 52;
      end;
    
      if DBVersion = 52 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 53;
      end;

      if DBVersion = 53 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 54;
      end;

      if DBVersion = 54 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 55;
      end;

      if DBVersion = 55 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 56;
      end;

      if DBVersion = 56 then begin
        if NeedUpdate800xToMySql then begin
          RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, Update800xToMySql, nil);
          DBVersion := CURRENT_DB_VERSION;
        end
        else begin
          RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
          DBVersion := 57;
        end;
      end;

      if DBVersion = 57 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 58;
      end;

      if DBVersion = 58 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, 60, UpdateDBFile, nil);
        DBVersion := 61;
      end;

      if DBVersion = 61 then begin
        if NeedUpdateToNewLibMySqlD then begin
          RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateToNewLibMySqlD, nil);
          DBVersion := CURRENT_DB_VERSION;
        end
        else begin
          DBVersion := CURRENT_DB_VERSION;
        end;
      end;

      if DBVersion = 62 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 63;
      end;

      if DBVersion = 63 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, UpdateDBFileDataFor64);
        DBVersion := 64;
      end;

      if DBVersion = 64 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 65;
      end;

      if DBVersion = 65 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, UpdateDBFileDataFor66);
        DBVersion := 66;
      end;

      if DBVersion = 66 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 67;
      end;

      if DBVersion = 67 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 68;
      end;

      if DBVersion = 68 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 69;
      end;

      if DBVersion = 69 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 70;
      end;

      if DBVersion = 70 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 71;
      end;

      if DBVersion = 71 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateToNewLibMySqlDWithGlobalParams, nil);
        DBVersion := 72;
      end;

      if DBVersion = 72 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 73;
      end;

      if DBVersion = 73 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 75;
      end;

      if DBVersion = 74 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 75;
      end;

      if DBVersion = 75 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 76;
      end;

      if DBVersion = 76 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 77;
      end;

      if DBVersion = 77 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 78;
      end;

      if DBVersion = 78 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 79;
      end;

      if DBVersion = 79 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 80;
      end;
    end;


    if DBVersion <> CURRENT_DB_VERSION then
      raise Exception.CreateFmt('Версия базы данных %d не совпадает с необходимой версией %d.', [DBVersion, CURRENT_DB_VERSION]);

    //Если было произведено обновление программы, то обновляем ключи
    if FindCmdLineSwitch('i') or FindCmdLineSwitch('si') then begin
      ExtractRollbackAF();
      UpdateDBUIN(dbCon);
    end;
    mainStartupHelper.Write('DModule', 'Закончили проверки миграций');

  finally
    dbCon.Free;
  end;
end;

procedure TDM.UpdateDBFile(dbCon : TCustomMyConnection;
DBDirectoryName : String;
OldDBVersion : Integer;
AOnUpdateDBFileData : TOnUpdateDBFileData);
var
 MySqlScript : TMyScript;
 CompareScript: TResourceStream;
 CurrentDBVersion : Integer;

begin
  dbCon.Open;
  try
    MySqlScript := TMyScript.Create(nil);
    MySqlScript.Connection := dbCon;

    try
      //Иногда может получиться так, что мы обновили эталонную копию, но не обновили файл
      //Этим мы это проверяем
      CurrentDBVersion := DBProc.QueryValue(dbCon, 'select ProviderMDBVersion from analitf.params where id = 0', [], []);
      if CurrentDBVersion > OldDBVersion then
        Exit;

      CompareScript := TResourceStream.Create( hInstance, 'COMPARESCRIPT' + IntToStr(OldDBVersion), RT_RCDATA);
      try
        MySqlScript.SQL.LoadFromStream(CompareScript);
      finally
        try CompareScript.Free; except end;
      end;

      MySqlScript.OnError := OnScriptExecuteError;
      try
        MySqlScript.Execute;
      finally
        MySqlScript.OnError := nil;
      end;

      if Assigned(AOnUpdateDBFileData) then
        AOnUpdateDBFileData(dbCon);

    finally
      try MySqlScript.Free; except  end;
    end;

  finally
    try dbCon.Close; except end;
  end;
end;

procedure TDM.OnScriptExecuteError(Sender: TObject; E: Exception;
  SQL: String; var Action: TErrorAction);
begin
  Action := eaFail;
  LogCriticalError(
    Format(
      'Ошибка при выполнении скрипта: %s'#13#10'Источник: %s'#13#10'Тип исключения: %s'#13#10'SQL: %s',
      [E.Message, IfThen(Assigned(Sender), Sender.ClassName), E.ClassName, SQL]));
end;

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
            //Все таки этот вызов нужен, т.к. не отпускаются определенные файлы при закрытии подключения
            //Если же кол-во подключенных клиентов будет больше 0, то этот вызов не сработает
            if MainConnection is TMyEmbConnection then
              DatabaseController.FreeMySQLLib('MySql Clients Count при восстановлении');
            mainStartupHelper.Write('DModule', 'Начали восстановление базы данных');
            RecoverDatabase(E);
            mainStartupHelper.Write('DModule', 'Закончили восстановление базы данных');
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
      LogExitError(Format( 'Невозможно открыть файл базы данных: %s '#13#10'Обратитесь в АК Инфорум.', [ E.Message ]), Integer(ecDBFileError));
  end;
end;

function TDM.GetRetUpCost(BaseCost: Currency): Currency;
begin
  Result := GetMarkup(FRetMargins, BaseCost);
end;

procedure TDM.SetSendToNotClosedOrders;
begin
  adcUpdate.SQL.Text := 'update CurrentOrderHeads set Send = 1 where (Closed = 0) and (CurrentOrderHeads.Frozen = 0) ';
  adcUpdate.Execute;
end;

{ TOrderInfo }

constructor TOrderInfo.Create(PriceCode: Integer; RegionCode : Int64);
begin
  Summ := 0;
  Self.PriceCode := PriceCode;
  Self.RegionCode := RegionCode;
end;

function TDM.FindOrderInfo(PriceCode:Integer; RegionCode: Int64): Currency;
begin
  try
    Result := DM.QueryValue(
      'SELECT ifnull(sum(osbc.RealPrice * osbc.OrderCount), 0) SumOrder '
      + 'FROM '
      + ' CurrentOrderHeads '
      + ' INNER JOIN CurrentOrderLists osbc ON '
      + '       (CurrentOrderHeads.orderid = osbc.OrderId) '
      + '   and (osbc.OrderCount > 0) '
      + ' INNER JOIN PricesRegionalData PRD ON '
      + '       (PRD.RegionCode = CurrentOrderHeads.RegionCode) '
      + '   AND (PRD.PriceCode = CurrentOrderHeads.PriceCode) '
      + ' inner JOIN PricesData ON (PricesData.PriceCode=PRD.PriceCode) '
      + 'WHERE '
      + '    (CurrentOrderHeads.CLIENTID = :ClientID) '
      + 'and (CurrentOrderHeads.Closed <> 1) '
      + 'and (CurrentOrderHeads.Frozen = 0) '
      + 'and (PRD.PRICECODE = :PriceCode) '
      + 'and (PRD.Regioncode = :RegionCode) ',
      ['ClientID', 'PriceCode', 'RegionCode'],
      [adtClients.FieldByName( 'ClientId').Value, PriceCode, RegionCode]);
  except
    Result := 0;
  end;
end;

function TDM.GetFullLastCreateScript: String;
var
  realDBVersion : String;
begin
  if NeedUpdate800xToMySql then
    realDBVersion := '56'
  else
  if NeedUpdateToNewLibMySqlD then
    realDBVersion := '61'
  else
    realDBVersion := IntToStr(CURRENT_DB_VERSION);

  Result := DatabaseController.GetFullLastCreateScript(realDBVersion);
end;

procedure TDM.CreateClearDatabaseFromScript(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
var
  FConnection : TCustomMyConnection;
  MyDump : TMyDump;
begin
  //Когда мы запускаем программу и не можем открыть базу данных AnalitF,
  //то сохраняются embedded-параметры (настройки соединения) внутри MyDac с открытой базой AnalitF,
  //хотя на самом деле она не открыта и увеличивается счетчик открытых соедиений.
  //После того, как мы открываем базу здесь (строки ниже),
  //счетчик открытых соединений увеличивается еще раз и становится равным 2,
  //после закрытия данного соединения он уменьшается на 1 и становится равным 1.
  //Но MyDac не позволяет открыть еще одно соедиение, т.к. параметры различны.
  //Поэтому в нитках приходится создавать свои соединения и это работает,
  //либо все соединения открывать в папке ..\AnalitF\Data, а потом изменять базу данных на AnalitF

  FConnection := DatabaseController.GetNewConnection(MainConnection);

  if MainConnection is TMyEmbConnection then
    TMyEmbConnection(FConnection).DataDir := DBDirectoryName;

{
  FEmbConnection := TMyEmbConnection.Create(nil);
  FEmbConnection.Database := '';
  FEmbConnection.Username := MainConnection.Username;
  FEmbConnection.DataDir := DBDirectoryName;
  FEmbConnection.Options := TMyEmbConnection(MainConnection).Options;
  FEmbConnection.Params.Clear;
  FEmbConnection.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
  FEmbConnection.LoginPrompt := False;
}  

  try

    if DatabaseController.WorkSchemaExists(FConnection) then
      DatabaseController.DropWorkSchema(FConnection);

{
    if DirectoryExists(ExePath + SDirData + '\analitf')
    then
      DeleteDataDir(DBDirectoryName);
}

    //SysUtils.ForceDirectories(ExePath + SDirData + '\analitf');
    DatabaseController.CreateWorkSchema(FConnection);

    FConnection.Database := 'analitf';

    FConnection.Open;
    try
      MyDump := TMyDump.Create(nil);
      try
        MyDump.Connection := FConnection;
        MyDump.Objects := [doTables, doViews];
        MyDump.OnError := OnScriptExecuteError;
        MyDump.SQL.Text := GetFullLastCreateScript();
{$ifdef DEBUG}
        WriteExchangeLog('CreateClearDatabaseFromScript', MyDump.SQL.Text);
{$endif}
        MyDump.Restore;
      finally
        MyDump.Free;
      end;

      if not DatabaseController.Initialized then begin
        mainStartupHelper.Write('DModule.CreateClearDatabase', 'Начали инициализацию объектов базы данных');
        DatabaseController.Initialize(FConnection);
        mainStartupHelper.Write('DModule.CreateClearDatabase', 'Закончили инициализацию объектов базы данных');
      end;
    finally
      FConnection.Close;
    end;

  finally
    FConnection.Free;
  end;
  //Все таки этот вызов нужен, т.к. не отпускаются определенные файлы при закрытии подключения
  //Если же кол-во подключенных клиентов будет больше 0, то этот вызов не сработает
  if MainConnection is TMyEmbConnection then
  begin
    DatabaseController.FreeMySQLLib('MySql Clients Count после создания базы данных');
    DatabaseController.RepairTableFromBackup();
  end;
end;

procedure TDM.RecoverDatabase(E: Exception);
var
  UserErrorMessage,
  DBErrorMess : String;
  InternalRestore : Boolean;
begin
  {
  Здесь мы должны сделать:
  1. Закрыть соединение, если открыто
  2. Запомнить код ошибки при открытии
  3. Переименовать в ошибочную базу данных
  4. Скопировать из эталонной базы данных
  5. Открыть эталонную базу данных
  }
  InternalRestore := False;
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

  if GetNetworkSettings().IsNetworkVersion then begin
    if (E is EMyError) and (EMyError(E).ErrorCode = ER_BAD_DB_ERROR) then begin
      DBErrorMess := DBErrorMess + #13#10#13#10 + 'Будет произведено создание базы данных.';
      UserErrorMessage := UserErrorMessage + #13#10 + 'Будет произведено создание базы данных.';
    end
    else begin
      DBErrorMess := DBErrorMess + #13#10#13#10 + 'Будет произведено восстановление из эталонной копии.';
      UserErrorMessage := UserErrorMessage + #13#10 + 'Будет произведено восстановление из эталонной копии.';
      InternalRestore := True;
    end;
  end
  else begin
    if not DirectoryExists(ExePath + SDirDataPrev) then begin
      DBErrorMess := DBErrorMess + #13#10#13#10 + 'Будет произведено создание базы данных.';
      UserErrorMessage := UserErrorMessage + #13#10 + 'Будет произведено создание базы данных.';
    end
    else begin
      DBErrorMess := DBErrorMess + #13#10#13#10 + 'Будет произведено восстановление из эталонной копии.';
      UserErrorMessage := UserErrorMessage + #13#10 + 'Будет произведено восстановление из эталонной копии.';
      InternalRestore := True;
    end;
  end;

  //Логируем наши действия и отображаем пользователю
  AProc.LogCriticalError(DBErrorMess);

  //Если нет предыдущей копии, то создаем базу даннных
  if not InternalRestore then begin
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
        'Не удалось скопировать из предыдущей копии : %s', [E.Message]);
    end;
end;

procedure TDM.ProcessDocs(ImportDocs : Boolean);
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

      if ImportDocs then begin
        DatabaseController.BackupDataTable(doiDocumentHeaders);
        DatabaseController.BackupDataTable(doiDocumentBodies);
        DatabaseController.BackupDataTable(doiInvoiceHeaders);
      end;

      //Если суммарное кол-во открываемых файлов больше 5, то открываем только папки
      if not OnlyDirOpen then
        OnlyDirOpen :=
          (
            DocsFL.Count
            + IfThen(not ImportDocs and adtParams.FieldByName('USEOSOPENWAYBILL').AsBoolean, WaybillsFL.Count, 0)
            + IfThen(adtParams.FieldByName('USEOSOPENREJECT').AsBoolean, RejectsFL.Count, 0)
          ) > 5;

      OpenDocsDir(SDirDocs, DocsFL, not OnlyDirOpen);
      if not ImportDocs then
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
  if DirectoryExists(RootFolder() + DirName) then begin
    try
      if FindFirst( RootFolder() + DirName + '\*.*', faAnyFile, DocsSR) = 0 then
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
                FileList.Add(RootFolder() + DirName + '\' + DocsSR.Name);
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
      ShellExecute( 0, 'Open', PChar(RootFolder() + DirName + '\'),
        nil, nil, SW_SHOWDEFAULT)
    else
      for I := 0 to FileList.Count-1 do
        ShellExecute( 0, 'Open', PChar(FileList[i]),
          nil, nil, SW_SHOWDEFAULT);
end;

{$ifdef DEBUG}
{$ifndef USENEWMYSQLTYPES}
procedure TDM.ExtractDBScript(dbCon: TCustomMyConnection);
var
  MyDump : TMyDump;
begin
  MyDump := TMyDump.Create(nil);
  try
    MyDump.Connection := dbCon;
    MyDump.Objects := [doTables, doViews];
    MyDump.OnError := OnScriptExecuteError;
    MyDump.Backup;
    ReplaceAutoIncrement(MyDump.SQL);
    MyDump.SQL.SaveToFile('extract_mysql.sql');
  finally
    MyDump.Free;
  end;
end;
{$endif}
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
  if Assigned(SetHTTP.Request.Authentication) then begin
    SetHTTP.Request.Authentication.Free;
    SetHTTP.Request.Authentication := nil;
  end;
  SetHTTP.Request.Username := adtParams.FieldByName( 'HTTPName').AsString;
  SetHTTP.Request.Password := '';
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
      dbCon.ExecSQL('update analitf.params set CDS = :CDS where ID = 0', [newCDS]);

    finally
      try dbCon.Close(); except end;
    end;

    DatabaseController.BackupDataTables();
  except
    on E : Exception do begin
      AProc.LogCriticalError('Ошибка при обновлении UIN : ' + E.Message);
    end;
  end;
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
  if adsPrintOrderHeader.Active then
    adsPrintOrderHeader.Close;
  if adsOrderDetails.Active then
    adsOrderDetails.Close;

  adsPrintOrderHeader.SQL.Text := adsPrintOrderHeader.SQLRefresh.Text;
  adsOrderDetails.SQL.Text := adsOrderDetailsEtalon.SQL.Text;

  if adsUser.FieldByName('AllowDelayOfPayment').AsBoolean and not adsUser.FieldByName('ShowSupplierCost').AsBoolean then begin
    adsOrderDetails.SQL.Text := StringReplace(adsOrderDetails.SQL.Text, 'list.RealPrice as PrintPrice', 'list.Price as PrintPrice', [rfReplaceAll, rfIgnoreCase]);
    adsOrderDetails.SQL.Text := StringReplace(adsOrderDetails.SQL.Text, 'list.RealPrice*list.OrderCount AS SumOrder', 'list.Price*list.OrderCount AS SumOrder', [rfReplaceAll, rfIgnoreCase]);
  end;

  if Closed then begin
    adsPrintOrderHeader.SQL.Text := StringReplace(adsPrintOrderHeader.SQL.Text, 'CurrentOrderHeads', 'PostedOrderHeads', [rfReplaceAll, rfIgnoreCase]);
    adsPrintOrderHeader.SQL.Text := StringReplace(adsPrintOrderHeader.SQL.Text, 'CurrentOrderLists', 'PostedOrderLists', [rfReplaceAll, rfIgnoreCase]);
    adsPrintOrderHeader.SQL.Text := StringReplace(adsPrintOrderHeader.SQL.Text, 'PricesData.DatePrice', 'header.PriceDate', [rfReplaceAll, rfIgnoreCase]);
    adsOrderDetails.SQL.Text := StringReplace(adsOrderDetails.SQL.Text, 'CurrentOrderLists', 'PostedOrderLists', [rfReplaceAll, rfIgnoreCase]);
  end;


  //Получаем информацию о текущих отправляемых заказах
  adsPrintOrderHeader.ParamByName( 'OrderId').Value := OrderId;
  adsPrintOrderHeader.ParamByName( 'ClientId').Value := adtClients.FieldByName( 'ClientId').Value;
  adsPrintOrderHeader.ParamByName( 'Closed').Value := Closed;
  adsPrintOrderHeader.ParamByName( 'Send').Value := Send;
  adsPrintOrderHeader.ParamByName( 'TimeZoneBias').Value := AProc.TimeZoneBias;
  adsPrintOrderHeader.Open;

  try
    if not adsPrintOrderHeader.IsEmpty then begin
      if adsOrderDetails.Active then
        adsOrderDetails.Close();

      adsOrderDetails.ParamByName('OrderId').Value := OrderId;
      adsOrderDetails.Open;

      try

        frdsReportOrder.DataSet := adsOrderDetails;
        //готовим печать
        frVariables[ 'DisplayOrderId'] := adsPrintOrderHeader.FieldByName('DisplayOrderId').AsVariant;
        frVariables[ 'DatePrice'] := adsPrintOrderHeader.FieldByName('DatePrice').AsVariant;
        frVariables[ 'OrdersComments'] := adsPrintOrderHeader.FieldByName('Comments').AsString;
        frVariables[ 'SupportPhone'] := adsPrintOrderHeader.FieldByName('SupportPhone').AsString;
        frVariables[ 'OrderDate'] := adsPrintOrderHeader.FieldByName('OrderDate').AsVariant;
        frVariables[ 'PriceName'] := adsPrintOrderHeader.FieldByName('PriceName').AsString;
        frVariables[ 'Closed'] := adsPrintOrderHeader.FieldByName('Closed').AsBoolean;

        DM.ShowFastReport( 'Orders.frf', nil, Preview, PrintDlg);

      finally
        adsOrderDetails.Close;
      end;
    end;
  finally
    adsPrintOrderHeader.Close;
  end;
end;

{$ifdef DEBUG}
procedure TDM.MySQLMonitorSQL(Sender: TObject; Text: String;
  Flag: TDATraceFlag);
const
  DATraceFlagNames : array[TDATraceFlag] of string =
    ('tfQPrepare', 'tfQExecute', 'tfQFetch', 'tfError', 'tfStmt', 'tfConnect',
     'tfTransact', 'tfBlob', 'tfService', 'tfMisc', 'tfParams');
begin
{
  if (Sender is TMyQuery) and (TMyQuery(Sender).Name = 'adsOrders')
     and (TMyQuery(Sender).Owner is TForm) and (TForm(TMyQuery(Sender).Owner).Name = 'OrdersForm')
  then
    Tracer.TR('Monitor', Format('Sender : %s  Flag : %s'#13#10'Text : %s ', [Sender.ClassName, DATraceFlagNames[Flag], Text]))
  else
    if (Sender = nil) then
      Tracer.TR('Monitor', Format('Sender : nil  Flag : %s'#13#10'Text : %s ', [DATraceFlagNames[Flag], Text]))
    else
      Tracer.TR('Monitor', Format('Sender : %s  Flag : %s'#13#10'Text : %s ', [Sender.ClassName, DATraceFlagNames[Flag], Text]))
  if (Sender = nil) then
    WriteExchangeLog('Monitor', Format('Sender : nil  Flag : %s'#13#10'Text : %s ', [DATraceFlagNames[Flag], Text]))
  else
    WriteExchangeLog('Monitor', Format('Sender : %s  Flag : %s'#13#10'Text : %s ', [Sender.ClassName, DATraceFlagNames[Flag], Text]))
  if (Sender = nil) then
    WriteExchangeLog('Monitor', Format('Sender : nil  Flag : %s'#13#10'Text : %s ', [DATraceFlagNames[Flag], Text]))
  else //adsDocumentBodies
    if (Sender is TMyQuery) and (TMyQuery(Sender).Name = 'adsDocumentBodies') then
    WriteExchangeLog('Monitor', Format('Sender : %s  Flag : %s'#13#10'Text : %s ', [Sender.ClassName, DATraceFlagNames[Flag], Text]))
    if (Sender is TMyQuery) and (TMyQuery(Sender).Name = 'adsOrdersHForm') then
    WriteExchangeLog('Monitor', Format('Sender : %s  Flag : %s'#13#10'Text : %s ', [Sender.ClassName, DATraceFlagNames[Flag], Text]))
}
end;
{$endif}

{$ifdef TestEmbeddedMysql}
procedure TDM.TestEmbeddedMysql;
begin
{$ifndef USEMYSQLSTANDALONE}
  //TestDumpDatabase();

  //TestOpenDatabase();

  //TestEmbeddedThread();
{$endif}

  //TestDirectoriesOperation();
end;

{$ifndef USEMYSQLSTANDALONE}
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
          MyDump.Objects := [doTables, doViews];
          MyDump.OnError := OnScriptExecuteError;
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
{$ifndef USEMYSQLSTANDALONE}
  if GetNetworkSettings().IsNetworkVersion then
    Result := (MyConnection as TCustomMyConnection)
  else
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
  FConnection : TCustomMyConnection;
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

  FConnection := DatabaseController.GetNewConnection(MainConnection);

  if MainConnection is TMyEmbConnection then
    TMyEmbConnection(FConnection).DataDir := DBDirectoryName;

{
  FEmbConnection.Database := '';
  FEmbConnection.Username := MainConnection.Username;
  FEmbConnection.DataDir := DBDirectoryName;
  FEmbConnection.Options := TMyEmbConnection(MainConnection).Options;
  FEmbConnection.Params.Clear;
  FEmbConnection.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
  FEmbConnection.LoginPrompt := False;
}  

  try

    FConnection.Open;
    try
      if not DatabaseController.Initialized then begin
        mainStartupHelper.Write('DModule.RestoreDatabaseFromPrevios', 'Начали инициализацию объектов базы данных');
        DatabaseController.Initialize(FConnection);
        mainStartupHelper.Write('DModule.RestoreDatabaseFromPrevios', 'Закончили инициализацию объектов базы данных');
      end;
    finally
      FConnection.Close;
    end;

  finally
    FConnection.Free;
  end;
  //Все таки этот вызов нужен, т.к. не отпускаются определенные файлы при закрытии подключения
  //Если же кол-во подключенных клиентов будет больше 0, то этот вызов не сработает
  if MainConnection is TMyEmbConnection then
    DatabaseController.FreeMySQLLib('MySql Clients Count после восстановления базы данных');

  DatabaseController.RepairTableFromBackup();
end;

procedure TDM.InternalCloseMySqlDB;
begin
  if MainConnection.Connected then
    MainConnection.Disconnect;
  if (MainConnection is TMyEmbConnection)
  then
    DatabaseController.FreeMySQLLib('MySql Clients Count при закрытии программы');
end;

procedure TDM.InsertOrderHeader(orderDataSet: TCustomMyDataSet);
var
  OrderId : Int64;
  OrderIdVariant : Variant;
  OrderIdFromListVariant : Variant;
  OldOrderIdFromListVariant : Variant;
  tmpAllowAutoComment : Boolean;
begin
  tmpAllowAutoComment := AllowAutoComment();
  //Проверяем, что Id заказа существует, а не был удален,
  //например из-за того, что в нем не осталось позиций
  if not orderDataSet.FieldByName('ORDERSHORDERID').IsNull then begin
    OrderIdVariant := DM.QueryValue(''
+'select ORDERID '
+'from   CurrentOrderHeads '
+'where  ORDERID   = :ORDERID ',
      ['ORDERID'],
      [orderDataSet.FieldByName('ORDERSHORDERID').Value]);
    if VarIsNull(OrderIdVariant) then
      orderDataSet.FieldByName('ORDERSHORDERID').Clear();
  end;

  //Проверяем то, что есть заголовок заказа
  //Если его нет, то создаем
  if orderDataSet.FieldByName('ORDERSHORDERID').IsNull then begin
    OrderIdVariant := DM.QueryValue(''
+'select ORDERID '
+'from   CurrentOrderHeads '
+'where  ClientId   = :ClientId '
+'and    PriceCode  = :PriceCode '
+'and    RegionCode = :RegionCode '
+'and    CurrentOrderHeads.Frozen = 0 '
+'and    Closed    <> 1',
      ['ClientId', 'PriceCode', 'RegionCode'],
      [orderDataSet.ParamByName('ClientId').Value,
       orderDataSet.FieldByName('PriceCode').Value,
       orderDataSet.FieldByName('RegionCode').Value]);
    //Заказа не существует - создаем его
    if VarIsNull(OrderIdVariant) then begin
      OrderIdVariant := DM.QueryValue(''
+'insert '
+'into   CurrentOrderHeads '
+'       ( '
+'              ClientId, PriceCode, RegionCode, PriceName, RegionName, OrderDate, DelayOfPayment, VitallyDelayOfPayment '
+'       ) '
+'select :ClientId, pd.PriceCode, prd.RegionCode, pd.PriceName, r.RegionName, current_timestamp(), dop.OtherDelay, dop.VitallyImportantDelay '
+'from   (pricesdata pd, pricesregionaldata prd, regions r) '
+'       left join DelayOfPayments dop '
+'       on     dop.PriceCode = pd.PriceCode '
+'       and     (dop.DayOfWeek = :DayOfWeek) '
+'where  pd.pricecode  = :pricecode '
+'and    prd.pricecode = pd.pricecode '
+'and    r.regioncode  = prd.regioncode '
+'and    r.regioncode  = :regioncode; '
+' '
+'select last_insert_id() ;',
        ['ClientId', 'PriceCode', 'RegionCode', 'DayOfWeek'],
        [orderDataSet.ParamByName('ClientId').Value,
         orderDataSet.FieldByName('PriceCode').Value,
         orderDataSet.FieldByName('RegionCode').Value,
         TDayOfWeekHelper.DayOfWeek()]);
    end;
    OrderId := OrderIdVariant;
  end
  else begin
    OrderId := orderDataSet.FieldByName('ORDERSHORDERID').Value;
    OrderIdVariant := orderDataSet.FieldByName('ORDERSHORDERID').Value;
  end;

  {
  Проверям, что текущая заказанная позиция связана с текущим заказом
  по данному прайс-листу
  Позиция может быть привязана к несуществующему заказу, т.к. в MyIsam
  не существует проверки целостности и заказ может быть удален,
  а позиция может остаться.
  Этим кодом мы находим такие позиции и удаляем их.
  }
  if not orderDataSet.FieldByName('ORDERSORDERID').IsNull then begin
    OldOrderIdFromListVariant := orderDataSet.FieldByName('ORDERSORDERID').Value;
    //Если ID заказов не равны, то удаляем позицию по этому заказу
    if OldOrderIdFromListVariant <> OrderIdVariant then
    begin
      DM.MainConnection.ExecSQL('delete from CurrentOrderLists where OrderId = :OrderId', [orderDataSet.FieldByName('ORDERSORDERID').Value]);
      orderDataSet.FieldByName('ORDERSORDERID').Clear;
    end
  end;

  {
    Проверяем, что есть позиция в CurrentOrderLists с данным OrderId и CoreId
    Если позиции нет, то сбрасываем значение ORDERSORDERID в null
  }
  if not orderDataSet.FieldByName('ORDERSORDERID').IsNull then begin
    OrderIdFromListVariant := DM.QueryValue(''
+'select ORDERID '
+'from   CurrentOrderLists '
+'where  coreid   = :coreid '
+'and    orderid  = :orderid ',
      ['coreid', 'orderid'],
      [orderDataSet.FieldByName('CoreId').Value,
       OrderId]);
    if VarIsNull(OrderIdFromListVariant) then
      orderDataSet.FieldByName('ORDERSORDERID').Clear;
  end;

  {
  Создаем собственно позицию в OrdersList по данному заказу, если ее не существует
  }
  if orderDataSet.FieldByName('ORDERSORDERID').IsNull then begin
    OrderIdFromListVariant := DM.QueryValue(''
+'select ORDERID '
+'from   CurrentOrderLists '
+'where  coreid   = :coreid '
+'and    orderid  = :orderid ',
      ['coreid', 'orderid'],
      [orderDataSet.FieldByName('CoreId').Value,
       OrderId]);
    if VarIsNull(OrderIdFromListVariant) then begin
      OrderIdFromListVariant := DM.QueryValue(''
+'insert '
+'into   CurrentOrderLists '
+'       ( '
+'              ORDERID          , CLIENTID, COREID, PRODUCTID, CODEFIRMCR, SYNONYMCODE, '
+'              SYNONYMFIRMCRCODE, CODE, CODECR, SYNONYMNAME, SYNONYMFIRM, '
+'              PRICE            , AWAIT, JUNK, ORDERCOUNT, REQUESTRATIO, '
+'              ORDERCOST        , MINORDERCOUNT, RealPrice, SupplierPriceMarkup, '
+'              CoreQuantity     , ServerCoreID, '
+'              Unit             , Volume       , Note, '
+'              Period           , Doc          , REGISTRYCOST, VITALLYIMPORTANT, '
+'              ProducerCost     , NDS          , RetailVitallyImportant  '
+'       ) '
+'select :ORDERID     , :CLIENTID, c.COREID, c.PRODUCTID, c.CODEFIRMCR, '
+'       c.SYNONYMCODE, c.SYNONYMFIRMCRCODE, c.CODE, c.CODECR, ifnull '
+'       (s.SynonymName, concat(catalogs.name, '' '', catalogs.form)) as '
+'       SynonymName   , sf.synonymname, '
+'                  if(dop.OtherDelay is null, '
+'                      c.Cost, '
+'                      if(c.VitallyImportant || ifnull(catalogs.VitallyImportant, 0), '
+'                          cast(c.Cost * (1 + dop.VitallyImportantDelay/100) as decimal(18, 2)), '
+'                          cast(c.Cost * (1 + dop.OtherDelay/100) as decimal(18, 2)) '
+'                       ) '
+'                  ) '
+'       , '
+'       c.AWAIT, c.JUNK, 0, '
+'       c.REQUESTRATIO, c.ORDERCOST, c.MINORDERCOUNT, c.cost, '
+'       c.SupplierPriceMarkup, '
+'              c.Quantity     , c.ServerCoreID, '
+'              c.Unit             , c.Volume       , c.Note, '
+'              c.Period           , c.Doc          , c.REGISTRYCOST, c.VITALLYIMPORTANT, '
+'              c.ProducerCost     , c.NDS          , c.RetailVitallyImportant  '
+'from   core c '
+'       inner join pricesdata pd '
+'       on     pd.PriceCode = c.PriceCode '
+'       inner join products p '
+'       on     p.productid = c.productid '
+'       inner join catalogs '
+'       on     catalogs.fullcode = p.catalogid '
+'       left join DelayOfPayments dop '
+'       on     dop.PriceCode = pd.PriceCode '
+'       and     (dop.DayOfWeek = :DayOfWeek) '
+'       left join synonyms s '
+'       on     s.synonymcode = c.synonymcode '
+'       left join synonymfirmcr sf '
+'       on     sf.synonymfirmcrcode = c.synonymfirmcrcode '
+'where  c.coreid                    = :coreid; '
+' '
+'select last_insert_id();',
        ['ORDERID', 'ClientId', 'CoreId', 'DayOfWeek'],
        [OrderId,
         orderDataSet.ParamByName('ClientId').Value,
         orderDataSet.FieldByName('Coreid').Value,
         TDayOfWeekHelper.DayOfWeek()]);
    end;
    orderDataSet.FieldByName('ORDERSORDERID').Value := OrderId;
  end;

  if tmpAllowAutoComment then
    UpdateComment(
      AutoComment,
      orderDataSet.FieldByName('ORDERSORDERID').Value,
      orderDataSet.FieldByName('Coreid').Value);
end;

procedure TDM.CheckDataIntegrity;
var
  RaiseException : Boolean;
  ErrorMessage : TStringList;
begin
  RaiseException := False;

  adsQueryValue.Close;

{

  adsQueryValue.SQL.Text := ''
  +'select clients.ClientId             , '
  +'       clients.Name                 , '
  +'       providers.FirmCode           , '
  +'       providers.FullName           , '
  +'       dop.FirmCode as DelayFirmCode, '
  +'       dop.Percent '
  +'from   ( clients, providers, userinfo ) '
  +'       left join delayofpayments dop '
  +'       on     (dop.FirmCode         = providers.FirmCode) '
  +'where  (clients.AllowDelayOfPayment = 1) '
  +'and    (userinfo.ClientId = clients.ClientId)'
  +'and    ((dop.FirmCode         is null) '
  +'       or     (dop.Percent    is null))';

  adsQueryValue.Open;
  try
    if not adsQueryValue.IsEmpty then begin
      RaiseException := True;
      ErrorMessage := TStringList.Create;
      try
        while not adsQueryValue.Eof do begin
          if adsQueryValue.FieldByName('DelayFirmCode').IsNull then
            ErrorMessage.Add(
              Format(
                'Клиент: %s (%s)  Поставщик: %s (%s)  Причина: %s',
                [adsQueryValue.FieldByName('Name').Value,
                 adsQueryValue.FieldByName('ClientId').Value,
                 adsQueryValue.FieldByName('FullName').Value,
                 adsQueryValue.FieldByName('FirmCode').Value,
                 'Нет записи в таблице отсрочек, хотя механизм отсрочек включен']))
          else
            if    not adsQueryValue.FieldByName('DelayFirmCode').IsNull
              and adsQueryValue.FieldByName('Percent').IsNull
            then
              ErrorMessage.Add(
                Format(
                  'Клиент: %s (%d)  Поставщик: %s (%d)  Причина: %s',
                  [adsQueryValue.FieldByName('Name').Value,
                   adsQueryValue.FieldByName('ClientId').Value,
                   adsQueryValue.FieldByName('FullName').Value,
                   adsQueryValue.FieldByName('FirmCode').Value,
                   'Не установлена отсрочка (null), хотя  запись в таблице отсрочек есть']));
          adsQueryValue.Next;
        end;
        ErrorMessage.Insert(
          0,
          'Нарушение целостности данных в таблице отсрочек по следующим записям:');
        WriteExchangeLog('Exchange', ErrorMessage.Text);
      finally
        ErrorMessage.Free;
      end;
    end;
  finally
    adsQueryValue.Close;
  end;
}

  //Добавляем отсрочки по всем остальным поставщиками и клиентам,
  //у которых нет записей в DelayOfPayments
  adsQueryValue.SQL.Text := ''
  +'insert '
  +'into   Delayofpayments '
  +'       ( '
  +'              PriceCode, '
  +'              DayOfWeek, '
  +'              VitallyImportantDelay, '
  +'              OtherDelay '
  +'       ) '
  +'select  '
  +'       pricesdata.PriceCode, '
  +'       d.DayOfWeek, '
  +'       if(clients.AllowDelayOfPayment = 1, 0.0, null),  '
  +'       if(clients.AllowDelayOfPayment = 1, 0.0, null)   '
  +'from   '
  +'  ( clients, pricesdata, userinfo, '
  +'      ( '
  +'          select "Monday" as DayOfWeek '
  +'          union '
  +'          select "Tuesday" '
  +'          union '
  +'          select "Wednesday" '
  +'          union '
  +'          select "Thursday" '
  +'          union '
  +'          select "Friday" '
  +'          union '
  +'          select "Saturday" '
  +'          union '
  +'          select "Sunday" '
  +'      ) d '
  +' ) '
  +'       left join delayofpayments dop '
  +'       on     (dop.PriceCode = pricesdata.PriceCode) and (dop.DayOfWeek = d.DayOfWeek) '
  +'where  (dop.PriceCode  is null)'
  +'and    (userinfo.ClientId = clients.ClientId)';
  adsQueryValue.Execute;

  //Обновляем значение Percent: если механизм не включен, то null,
  //иначе должно быть значение, если оно не установлено, то 0.0
  adsQueryValue.SQL.Text := ''
  +'update clients, '
  +'       userinfo, '
  +'       delayofpayments dop '
  +'set    '
  +'  dop.OtherDelay   = if(clients.AllowDelayOfPayment = 0, null, IFNULL(dop.OtherDelay, 0.0)), '
  +'  dop.VitallyImportantDelay   = if(clients.AllowDelayOfPayment = 0, null, IFNULL(dop.VitallyImportantDelay, 0.0))'
  +'where  '
  +' (userinfo.ClientId = clients.ClientId)';
  adsQueryValue.Execute;

  if RaiseException then
    raise EDelayOfPaymentsDataIntegrityException.Create('Нарушение целостности в отсрочках');
end;

procedure TDM.GetOrderInfo(
  OrderID: Int64;
  var PriceName,
  RegionName: String);
begin
  try
    PriceName := DM.QueryValue(
      'SELECT PriceName '
      + 'FROM CurrentOrderHeads '
      + 'WHERE OrderId = :OrderId ',
      ['OrderId'],
      [OrderID]);
  except
    PriceName := '';
  end;
  try
    RegionName := DM.QueryValue(
      'SELECT RegionName '
      + 'FROM CurrentOrderHeads '
      + 'WHERE OrderId = :OrderId',
      ['OrderId'],
      [OrderID]);
  except
    RegionName := '';
  end;
end;

procedure TDM.GetClientInformation(var ClientName: String;
  var IsFutureClient: Boolean);
var
  tmpClientName : Variant;
begin
  IsFutureClient := adsUser.FieldByName('IsFutureClient').AsBoolean;
  if not IsFutureClient then
    ClientName := adtClients.FieldByName('Name').AsString
  else begin
    ClientName := '';
    tmpClientName := DM.QueryValue('select Name from Client', [], []);
    if not VarIsNull(tmpClientName) then
      ClientName := tmpClientName;
  end
end;

function TDM.GetClearSendResultSql(ClientId : Int64): String;
begin
  Result := ''
  + 'update '
  + '  CurrentOrderHeads '
  + 'set '
  + '  CurrentOrderHeads.SendResult = null, '
  + '  CurrentOrderHeads.ErrorReason = null, '
  + '  CurrentOrderHeads.ServerMinReq = null '
  + 'where '
  + '     CurrentOrderHeads.Closed = 0 '
  + 'and CurrentOrderHeads.Frozen = 0 ';
  if ClientId > 0 then
    Result := Result
    + 'and CurrentOrderHeads.Send = 1 '
    + 'and CurrentOrderHeads.ClientId = ' + IntToStr(ClientId) + '; '
  else
    Result := Result + '; ';

  Result := Result
  + 'update '
  + '  CurrentOrderHeads, '
  + '  CurrentOrderLists '
  + 'set '
  + '  CurrentOrderLists.DropReason = null, '
  + '  CurrentOrderLists.ServerCost = null, '
  + '  CurrentOrderLists.ServerQuantity = null '
  + 'where '
  + '     CurrentOrderHeads.Closed = 0 '
  + 'and  CurrentOrderHeads.Frozen = 0 '
  + 'and  CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId ';
  if ClientId > 0 then
    Result := Result
    + 'and CurrentOrderHeads.Send = 1 '
    + 'and CurrentOrderHeads.ClientId = ' + IntToStr(ClientId) + '; '
  else
    Result := Result + '; ';
end;

procedure TDM.adtParamsOldAfterPost(DataSet: TDataSet);
begin
  DatabaseController.BackupDataTable(doiParams);
end;

procedure TDM.adtReceivedDocsAfterPost(DataSet: TDataSet);
begin
  DatabaseController.BackupDataTable(doiReceivedDocs);
end;

procedure TDM.CheckDBObjectsWithDatabaseController(
  dbCon: TCustomMyConnection; DBDirectoryName: String;
  OldDBVersion: Integer; AOnUpdateDBFileData: TOnUpdateDBFileData);
begin
  dbCon.Open;
  try
    if not DatabaseController.Initialized then begin
      mainStartupHelper.Write('DModule', 'Начали инициализацию объектов базы данных');
      DatabaseController.Initialize(dbCon);
      mainStartupHelper.Write('DModule', 'Закончили инициализацию объектов базы данных');
    end;

    //Проверяем объекты если не производим обновление программы
    if not FindCmdLineSwitch('i') and not FindCmdLineSwitch('si') then begin
      mainStartupHelper.Write('DModule', 'Начали проверку на существование объектов базы данных');
      DatabaseController.CheckObjectsExists(
        dbCon,
        FCreateClearDatabase or FNeedImportAfterRecovery,
        [doiParams,
         doiUserInfo, doiClient, doiClients, doiClientSettings,
         doiRetailMargins, doiVitallyImportantMarkups,
         doiPostedOrderHeads, doiPostedOrderLists, doiCurrentOrderHeads, doiCurrentOrderLists,
         doiProviders, doiRegionalData, doiPricesData, doiPricesRegionalData, 
         doiRegions,
         doiMaxProducerCosts,
         doiMinReqRules]);
      mainStartupHelper.Write('DModule', 'Закончили проверку на существование объектов базы данных');
    end;
  finally
    dbCon.Close;
    //dbCon.RemoveFromPool;
  end;
end;

procedure TDM.DeleteOldMysqlFolder;
begin
  try
    DeleteDirectory(ExePath + SDirData + '\mysql');
    DeleteDirectory(ExePath + 'DataEtalon');
    DeleteDirectory(ExePath + SDirDataBackup + '\mysql');
    DeleteDirectory(ExePath + SDirDataPrev + '\mysql');
  except
    on E : Exception do begin
      LogCriticalError('Ошибка при удалении устаревшей директории mysql: ' + E.Message);
      LogExitError(
        'Невозможно удалить устаревшую директорию mysql.'#13#10
        + 'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.',
        Integer(ecDeleteOldMysqlFolder));
    end
  end;
end;

{$ifdef USEMEMORYCRYPTDLL}
procedure TDM.CheckSpecialLibrary;
var
  calchash : String;
begin
  try
    if not FileExists(ExePath + LibraryFileNameStart + LibraryFileNameEnd)
    then
      raise Exception.Create('Библиотека libmysqld.dll повреждена.');
    calchash := GetFileHash(ExePath + LibraryFileNameStart + LibraryFileNameEnd);
    if AnsiCompareText(calchash, 'B96036E9548DA25E17FC79B3E3CAF6A2') <> 0 then
      raise Exception.Create('Невозможно загрузить библиотеку libmysqld.dll.');
  except
    on E : Exception do begin
      LogExitError(
        E.Message + #13#10
          + 'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.',
        Integer(ecLibMysqlDCorrupted));
    end;
  end;
end;
{$endif}

function TDM.NeedUpdate800xToMySql: Boolean;
var
  buildNumber : Word;
begin
  if FindCmdLineSwitch('i') and
    FileExists(ExePath + SBackDir + '\' + ExeName + '.bak')
  then
  begin
    buildNumber := GetBuildNumberLibraryVersionFromPath(ExePath + SBackDir + '\' + ExeName + '.bak');
    Result := (buildNumber >= 829) and (buildNumber <= 837);
  end
  else
    Result := False;
end;

procedure TDM.PrepareUpdate800xToMySql;
begin
  try
    if DirectoryExists(ExePath + SDirDataPrev) then
      MoveDirectories(ExePath + SDirDataPrev, ExePath + SBackDir + '\' + SDirDataPrev);
    if DirectoryExists(ExePath + SDirData) then begin
      CopyDirectories(ExePath + SDirData, ExePath + SBackDir + '\' + SDirData);
      MoveDirectories(ExePath + SDirData, ExePath + SDirData + 'Old');
    end;
  except
    on E : Exception do begin
      LogCriticalError('Ошибка при удалении устаревших директорий при обновлении 800-x версий: ' + E.Message);
      LogExitError(
        'Невозможно удалить устаревшие директории.'#13#10
        + 'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.',
        Integer(ecDeleteOldMysqlFolder));
    end
  end;
end;

procedure TDM.Update800xToMySql(dbCon: TCustomMyConnection;
  DBDirectoryName: String; OldDBVersion: Integer;
  AOnUpdateDBFileData: TOnUpdateDBFileData);
var
  oldMySqlDB : TMyEmbConnection;
  PathToBackup,
  MySqlPathToBackup : String;
begin
  PathToBackup := ExePath + SDirTableBackup + '\';
  MySqlPathToBackup := StringReplace(PathToBackup, '\', '/', [rfReplaceAll]);
  
  DatabaseController.FreeMySQLLib('MySql Clients Count при обновлении с 800-х');
{$ifdef USEMEMORYCRYPTDLL}
  //TMySQLAPIEmbeddedEx(MyAPIEmbedded).FUseNewTypes := False;
{$endif}
  //MyCall.SwithTypesToOld;
  DatabaseController.SwithTypes(False);

  try

    oldMySqlDB := TMyEmbConnection.Create(nil);
    try
      oldMySqlDB.Params.Clear();
      oldMySqlDB.Params.Add('--basedir=' + ExtractFileDir(ParamStr(0)) + '\');
      oldMySqlDB.Params.Add('--datadir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirData  + 'Old\');
      oldMySqlDB.Params.Add('--character_set_server=cp1251');
      oldMySqlDB.Params.Add('--skip-innodb');
      oldMySqlDB.Params.Add('--tmp_table_size=33554432');
      oldMySqlDB.Params.Add('--max_heap_table_size=33554432');

      try
        oldMySqlDB.Open;
      except
        on OpenException : Exception do begin
          AProc.LogCriticalError('Ошибка при открытии старой базы данных : ' + OpenException.Message);
          raise Exception.Create('Не получилось открыть старую базу данных');
        end;
      end;

      try
        try
          ExportFrom800xToFiles(oldMySqlDB, PathToBackup, MySqlPathToBackup);
        except
          on UpdateException : Exception do begin
            AProc.LogCriticalError('Ошибка при переносе данных : ' + UpdateException.Message);
            raise Exception.Create(
              'При перемещении данных из старой базы в новою возникла ошибка.' +
              #13#10 +
              'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.');
          end;
        end;
      finally
        oldMySqlDB.Close;
      end;
    finally
      oldMySqlDB.Free;
    end;

    DatabaseController.FreeMySQLLib('MySql Clients Count при обновлении с 800-х');
{$ifdef USEMEMORYCRYPTDLL}
//    TMySQLAPIEmbeddedEx(MyAPIEmbedded).FUseNewTypes := True;
{$endif}
//    MyCall.SwithTypesToNew;
    DatabaseController.SwithTypes(True);

    dbCon.Open;
    try

      try
        Import800xFilesToMySql(dbCon, PathToBackup, MySqlPathToBackup);
        FProcess800xUpdate := True;
      except
        on UpdateException : Exception do begin
          AProc.LogCriticalError('Ошибка при переносе данных : ' + UpdateException.Message);
          raise Exception.Create(
            'При перемещении данных из старой базы в новою возникла ошибка.' +
            #13#10 +
            'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.');
        end;
      end;
    finally
      dbCon.Close;
    end;

    if DirectoryExists(ExePath + SDirData + 'Old') then
      try
        DeleteDirectory(ExePath + SDirData + 'Old');
      except
        on E : Exception do
          AProc.LogCriticalError('Ошибка при удалении старой (800-х) базы данных : ' + E.Message);
      end;
  finally
    DatabaseController.FreeMySQLLib('MySql Clients Count при обновлении с 800-х (обратно)');
{$ifdef USEMEMORYCRYPTDLL}
//    TMySQLAPIEmbeddedEx(MyAPIEmbedded).FUseNewTypes := True;
{$endif}
//    MyCall.SwithTypesToNew;
    DatabaseController.SwithTypes(True);
  end;
end;

procedure TDM.ExportFrom800xToFiles(
  oldMySqlDB: TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
var
  selectMySql : TMyQuery;
  I : Integer;
  exportTable : TDatabaseTable;
begin
  selectMySql := TMyQuery.Create(nil);
  try
    selectMySql.Connection := oldMySqlDB;

    for I := 0 to DatabaseController.DatabaseObjects.Count-1 do
      if (DatabaseController.DatabaseObjects[i] is TDatabaseTable)
         and (TDatabaseTable(DatabaseController.DatabaseObjects[i]).RepairType <> dortIgnore)
         and not (TDatabaseTable(DatabaseController.DatabaseObjects[i]).ObjectId
               in [doiCatalogs, doiClient, doiDelayOfPayments, doiDescriptions, doiMNN,
                   doiDocumentBodies, doiDocumentHeaders, doiProviderSettings,
                   doiVitallyImportantMarkups, doiMaxProducerCosts,
                   doiClientSettings])
      then begin
        exportTable := TDatabaseTable(DatabaseController.DatabaseObjects[i]);
        if FileExists(PathToBackup + exportTable.Name + '.txt') then
          OSDeleteFile(PathToBackup + exportTable.Name + '.txt');
        selectMySql.SQL.Text :=
          Format(
          'select * from analitf.%s INTO OUTFILE ''%s'';',
          [exportTable.Name,
           MySqlPathToBackup + exportTable.Name + '.txt']);
        selectMySql.Execute;
      end;
  finally
    selectMySql.Free();
  end;
end;

procedure TDM.Import800xFilesToMySql(dbCon : TCustomMyConnection;
  PathToBackup, MySqlPathToBackup : String);
var
  selectMySql : TMyQuery;
  I : Integer;
  importTable : TDatabaseTable;
begin
  selectMySql := TMyQuery.Create(nil);
  try
    selectMySql.Connection := dbCon;

    for I := 0 to DatabaseController.DatabaseObjects.Count-1 do
      if (DatabaseController.DatabaseObjects[i] is TDatabaseTable)
         and (TDatabaseTable(DatabaseController.DatabaseObjects[i]).RepairType <> dortIgnore)
         and not (TDatabaseTable(DatabaseController.DatabaseObjects[i]).ObjectId
               in [doiCatalogs, doiClient, doiDelayOfPayments, doiDescriptions, doiMNN,
                   doiDocumentBodies, doiDocumentHeaders, doiProviderSettings,
                   doiVitallyImportantMarkups, doiMaxProducerCosts,
                   doiClientSettings])
      then begin
        importTable := TDatabaseTable(DatabaseController.DatabaseObjects[i]);
        if not FileExists(PathToBackup + importTable.Name + '.txt') then
          raise Exception.CreateFmt(
            'Не существует файл для загрузки таблицы: %s',
            [importTable.Name]);
        selectMySql.SQL.Text :=
          Format('delete from analitf.%s;', [importTable.Name]);
        selectMySql.Execute;
        selectMySql.SQL.Text :=
          Format(
          'LOAD DATA INFILE ''%s'' into table analitf.%s;',
          [MySqlPathToBackup + importTable.Name + '.txt',
           importTable.Name]);
        selectMySql.Execute;

        OSDeleteFile(PathToBackup + importTable.Name + '.txt', False);
      end;

    selectMySql.SQL.Text :=
      'update analitf.retailmargins set MaxMarkup = Markup;';
    selectMySql.Execute;

    selectMySql.SQL.Text :=
      'update analitf.orderslist set RealPrice = Price;';
    selectMySql.Execute;

    selectMySql.SQL.Text :=
      'update analitf.params set ' +
        'ProviderMDBVersion = ' + IntToStr(CURRENT_DB_VERSION) + ', ' +
        'ConfirmSendingOrders = 0, ' +
        'UseCorrectOrders = 0 ' +
        ' where Id = 0';
    selectMySql.Execute;
  finally
    selectMySql.Free;
  end;
end;

function TDM.GetEditNameAndAddress: String;
begin
  Result := adtClientsEditName.AsString + ', ' + adtClientsAddress.AsString;
end;

procedure TDM.LoadVitallyImportantMarkups;
begin
  LoadMarkups('VitallyImportantMarkups', FVitallyImportantMarkups);
end;

function TDM.GetVitallyImportantMarkup(BaseCost: Currency): Currency;
begin
  Result := GetMarkup(FVitallyImportantMarkups, BaseCost);
end;

function TDM.VitallyImportantMarkupsExists: Boolean;
begin
  Result := FVitallyImportantMarkups.Count > 0;
end;

{ TRetailMarkup }

constructor TRetailMarkup.Create(LeftLimit, RightLimit, Markup,
  MaxMarkup, MaxSupplierMarkup: Double);
begin
  Self.LeftLimit := LeftLimit;
  Self.RightLimit := RightLimit;
  Self.Markup := Markup;
  Self.MaxMarkup := MaxMarkup;
  Self.MaxSupplierMarkup := MaxSupplierMarkup;
end;

procedure TDM.LoadMarkups(TableName: String; Markups: TObjectList);
begin
  adsQueryValue.Close;
  adsQueryValue.SQL.Text :=
    'select LeftLimit, RightLimit, Markup, MaxMarkup, MaxSupplierMarkup from ' + TableName + ' order by LeftLimit';
  adsQueryValue.Open;
  try
    Markups.Clear;
    adsQueryValue.First;
    while not adsQueryValue.Eof do begin
      Markups.Add(TRetailMarkup
        .Create(
          adsQueryValue.FieldByName('LeftLimit').AsCurrency,
          adsQueryValue.FieldByName('RightLimit').AsCurrency,
          adsQueryValue.FieldByName('Markup').AsCurrency,
          adsQueryValue.FieldByName('MaxMarkup').AsCurrency,
          adsQueryValue.FieldByName('MaxSupplierMarkup').AsCurrency));
      adsQueryValue.Next;
    end;
  finally
    adsQueryValue.Close;
  end;
end;

function TDM.GetMarkup(Markups: TObjectList; BaseCost: Currency): Currency;
var
  retail : TRetailMarkup;
begin
  retail := GetRetailMarkup(Markups, BaseCost);
  if Assigned(retail) then
    Result := retail.Markup
  else
    Result := 0;
end;

function TDM.GetRetailMarkup(Markups: TObjectList;
  BaseCost: Currency): TRetailMarkup;
var
  I : Integer;
begin
  Result := nil;
  I := 0;
  while (I < Markups.Count) and (BaseCost > TRetailMarkup(Markups[i]).LeftLimit) do begin
    if (TRetailMarkup(Markups[i]).LeftLimit < BaseCost) and (BaseCost <= TRetailMarkup(Markups[i]).RightLimit) then begin
      Result := TRetailMarkup(Markups[i]);
      Break;
    end;
    Inc(I);
  end;
end;

function TDM.GetMaxRetailMarkup(BaseCost: Currency): Currency;
var
  retail : TRetailMarkup;
begin
  retail := GetRetailMarkup(FRetMargins, BaseCost);
  if Assigned(retail) then
    Result := retail.MaxMarkup
  else
    Result := 0;
end;

function TDM.GetMaxVitallyImportantMarkup(BaseCost: Currency): Currency;
var
  retail : TRetailMarkup;
begin
  retail := GetRetailMarkup(FVitallyImportantMarkups, BaseCost);
  if Assigned(retail) then
    Result := retail.MaxMarkup
  else
    Result := 0;
end;

function TDM.NeedUpdateToNewLibMySqlD: Boolean;
var
  buildNumber : Word;
begin
  if FindCmdLineSwitch('i')
    and FileExists(ExePath + SBackDir + '\' + ExeName + '.bak')
    and FileExists(ExePath + SBackDir + '\' + 'appdbhlp.dll' + '.bak')
  then
  begin
    buildNumber := GetBuildNumberLibraryVersionFromPath(ExePath + SBackDir + '\' + ExeName + '.bak');
    Result := (buildNumber >= 1063) and (buildNumber <= 1079);
  end
  else
    Result := False;
end;

procedure TDM.PrepareUpdateToNewLibMySqlD;
begin
  try
    if DirectoryExists(ExePath + SDirDataPrev) then
      MoveDirectories(ExePath + SDirDataPrev, ExePath + SBackDir + '\' + SDirDataPrev);
    if DirectoryExists(ExePath + SDirData) then begin
      CopyDirectories(ExePath + SDirData, ExePath + SBackDir + '\' + SDirData);
      MoveDirectories(ExePath + SDirData, ExePath + SDirData + 'Old');
    end;
  except
    on E : Exception do begin
      LogCriticalError('Ошибка при удалении устаревших директорий при обновлении на новую libd: ' + E.Message);
      LogExitError(
        'Невозможно удалить устаревшие директории.'#13#10
        + 'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.',
        Integer(ecDeleteOldMysqlFolder));
    end
  end;
end;

procedure TDM.ExportFromOldLibMysqlDToFiles(
  oldMySqlDB: TCustomMyConnection; PathToBackup,
  MySqlPathToBackup: String);
var
  selectMySql : TMyQuery;
  I : Integer;
  exportTable : TDatabaseTable;
  ordersExportTableName : String;

  procedure OnExportException(ExportException : Exception; exportObject : String);
  begin
    WriteExchangeLog('Exchange.ExportFromOldLibMysqlDToFiles',
    'Ошибка при экспорте таблицы ' + exportObject + ': ' + ExportException.Message);
    if FileExists(PathToBackup + exportObject + '.txt')
      and (GetFileSize(PathToBackup + exportObject + '.txt') = 0)
    then
      try
        OSDeleteFile(PathToBackup + exportObject + '.txt');
      except
        on DeleteFile : Exception do
          WriteExchangeLog('Exchange.ExportFromOldLibMysqlDToFiles',
          'Ошибка при удалении файла ' + exportObject + ': ' + DeleteFile.Message);
      end;
  end;

begin
  selectMySql := TMyQuery.Create(nil);
  try
    selectMySql.Connection := oldMySqlDB;

    for I := 0 to DatabaseController.DatabaseObjects.Count-1 do
      if (DatabaseController.DatabaseObjects[i] is TDatabaseTable)
         and (TDatabaseTable(DatabaseController.DatabaseObjects[i]).RepairType <> dortIgnore)
         and not (TDatabaseTable(DatabaseController.DatabaseObjects[i]).ObjectId
               in [doiPostedOrderHeads, doiPostedOrderLists,
                   doiCurrentOrderHeads, doiCurrentOrderLists])
      then begin
        exportTable := TDatabaseTable(DatabaseController.DatabaseObjects[i]);
        if FileExists(PathToBackup + exportTable.Name + '.txt') then
          OSDeleteFile(PathToBackup + exportTable.Name + '.txt');
        try
          selectMySql.SQL.Text :=
            Format(
            'select * from analitf.%s INTO OUTFILE ''%s'';',
            [exportTable.Name,
             MySqlPathToBackup + exportTable.Name + '.txt']);
          selectMySql.Execute;
        except
          on E : Exception do begin
            WriteExchangeLog('Exchange.ExportFromOldLibMysqlDToFiles',
            'Ошибка при экспорте таблицы ' + exportTable.Name + ': ' + E.Message);
            if FileExists(PathToBackup + exportTable.Name + '.txt')
              and (GetFileSize(PathToBackup + exportTable.Name + '.txt') = 0)
            then
              try
                OSDeleteFile(PathToBackup + exportTable.Name + '.txt');
              except
                on DeleteFile : Exception do
                  WriteExchangeLog('Exchange.ExportFromOldLibMysqlDToFiles',
                  'Ошибка при удалении файла ' + exportTable.Name + ': ' + DeleteFile.Message);
              end;
          end;
        end;
      end;

    ordersExportTableName := 'currentorderheads';
    if FileExists(PathToBackup + ordersExportTableName + '.txt') then
      OSDeleteFile(PathToBackup + ordersExportTableName + '.txt');
    try
    selectMySql.SQL.Text :=
      Format(
      'select * from analitf.%s where Closed = 0 INTO OUTFILE ''%s'';',
      ['ordershead',
       MySqlPathToBackup + ordersExportTableName + '.txt']);
    selectMySql.Execute;
    except
      on E : Exception do 
        OnExportException(E, ordersExportTableName);
    end;

    ordersExportTableName := 'postedorderheads';
    if FileExists(PathToBackup + ordersExportTableName + '.txt') then
      OSDeleteFile(PathToBackup + ordersExportTableName + '.txt');
    try
    selectMySql.SQL.Text :=
      Format(
      'select * from analitf.%s where Closed = 1 INTO OUTFILE ''%s'';',
      ['ordershead',
       MySqlPathToBackup + ordersExportTableName + '.txt']);
    selectMySql.Execute;
    except
      on E : Exception do 
        OnExportException(E, ordersExportTableName);
    end;

    ordersExportTableName := 'currentorderlists';
    if FileExists(PathToBackup + ordersExportTableName + '.txt') then
      OSDeleteFile(PathToBackup + ordersExportTableName + '.txt');
    try
    selectMySql.SQL.Text :=
      Format(
      'select ol.* from analitf.%s ol, analitf.ordershead where (ordershead.Closed = 0) and (ordershead.OrderId = ol.OrderId) INTO OUTFILE ''%s'';',
      ['orderslist',
       MySqlPathToBackup + ordersExportTableName + '.txt']);
    selectMySql.Execute;
    except
      on E : Exception do 
        OnExportException(E, ordersExportTableName);
    end;

    ordersExportTableName := 'postedorderlists';
    if FileExists(PathToBackup + ordersExportTableName + '.txt') then
      OSDeleteFile(PathToBackup + ordersExportTableName + '.txt');
    try
    selectMySql.SQL.Text :=
      Format(
      'select ol.* from analitf.%s ol, analitf.ordershead where (ordershead.Closed = 1) and (ordershead.OrderId = ol.OrderId) INTO OUTFILE ''%s'';',
      ['orderslist',
       MySqlPathToBackup + ordersExportTableName + '.txt']);
    selectMySql.Execute;
    except
      on E : Exception do 
        OnExportException(E, ordersExportTableName);
    end;

  finally
    selectMySql.Free();
  end;
end;

procedure TDM.ImportOldLibMysqlDFilesToMySql(dbCon: TCustomMyConnection;
  PathToBackup, MySqlPathToBackup: String);
var
  selectMySql : TMyQuery;
  I : Integer;
  importTable : TDatabaseTable;
begin
  FNotImportedWithUpdateToNewLibMysql := [];
  selectMySql := TMyQuery.Create(nil);
  try
    selectMySql.Connection := dbCon;

    for I := 0 to DatabaseController.DatabaseObjects.Count-1 do
      if (DatabaseController.DatabaseObjects[i] is TDatabaseTable)
         and (TDatabaseTable(DatabaseController.DatabaseObjects[i]).RepairType <> dortIgnore)
{
         and not (TDatabaseTable(DatabaseController.DatabaseObjects[i]).ObjectId
               in [doiCatalogs, doiClient, doiDelayOfPayments, doiDescriptions, doiMNN,
                   doiDocumentBodies, doiDocumentHeaders, doiProviderSettings,
                   doiVitallyImportantMarkups, doiMaxProducerCosts,
                   doiClientSettings])
}
      then begin
        importTable := TDatabaseTable(DatabaseController.DatabaseObjects[i]);
        if FileExists(PathToBackup + importTable.Name + '.txt') then
        begin
          try
            selectMySql.SQL.Text :=
              Format('delete from analitf.%s;', [importTable.Name]);
            selectMySql.Execute;
            selectMySql.SQL.Text :=
              Format(
              'LOAD DATA INFILE ''%s'' into table analitf.%s;',
              [MySqlPathToBackup + importTable.Name + '.txt',
               importTable.Name]);
            selectMySql.Execute;
          except
            on ImportException : Exception do begin
              FNotImportedWithUpdateToNewLibMysql :=
                FNotImportedWithUpdateToNewLibMysql + [importTable.ObjectId];
              WriteExchangeLog('Exchange.ImportOldLibMysqlDFilesToMySql',
              'Ошибка при импорте таблицы ' + importTable.Name + ': ' + ImportException.Message);
            end;
          end;

          try
            OSDeleteFile(PathToBackup + importTable.Name + '.txt', False);
          except
            on DeleteFile : Exception do
              WriteExchangeLog('Exchange.ImportOldLibMysqlDFilesToMySql',
              'Ошибка при удалении файла ' + importTable.Name + ': ' + DeleteFile.Message);
          end;
        end
        else
          FNotImportedWithUpdateToNewLibMysql :=
            FNotImportedWithUpdateToNewLibMysql + [importTable.ObjectId];
      end;

    selectMySql.SQL.Text :=
      'update analitf.params set ' +
        'ProviderMDBVersion = ' + IntToStr(CURRENT_DB_VERSION) + ' ' +
        ' where Id = 0';
    selectMySql.Execute;
  finally
    selectMySql.Free;
  end;
end;

procedure TDM.UpdateToNewLibMySqlD(dbCon: TCustomMyConnection;
  DBDirectoryName: String; OldDBVersion: Integer;
  AOnUpdateDBFileData: TOnUpdateDBFileData);
var
  oldMySqlDB : TMyEmbConnection;
  PathToBackup,
  MySqlPathToBackup : String;
begin
  PathToBackup := ExePath + SDirTableBackup + '\';
  MySqlPathToBackup := StringReplace(PathToBackup, '\', '/', [rfReplaceAll]);

  DatabaseController.FreeMySQLLib('MySql Clients Count при обновлении со старой libd');
{$ifdef USEMEMORYCRYPTDLL}
  DatabaseController.SwitchMemoryLib(ExePath + SBackDir + '\' + 'appdbhlp.dll' + '.bak');
{$endif}

  try

    oldMySqlDB := TMyEmbConnection.Create(nil);
    try
      oldMySqlDB.Params.Clear();
      oldMySqlDB.Params.Add('--basedir=' + ExtractFileDir(ParamStr(0)) + '\');
      oldMySqlDB.Params.Add('--datadir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirData  + 'Old\');
      oldMySqlDB.Params.Add('--character_set_server=cp1251');
      oldMySqlDB.Params.Add('--tmp_table_size=33554432');
      oldMySqlDB.Params.Add('--max_heap_table_size=33554432');

      try
        oldMySqlDB.Open;
      except
        on OpenException : Exception do begin
          AProc.LogCriticalError('Ошибка при открытии старой базы данных : ' + OpenException.Message);
          raise Exception.Create('Не получилось открыть старую базу данных');
        end;
      end;

      try
        try
          ExportFromOldLibMysqlDToFiles(oldMySqlDB, PathToBackup, MySqlPathToBackup);
        except
          on UpdateException : Exception do begin
            AProc.LogCriticalError('Ошибка при переносе данных : ' + UpdateException.Message);
            raise Exception.Create(
              'При перемещении данных из старой базы в новою возникла ошибка.' +
              #13#10 +
              'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.');
          end;
        end;
      finally
        oldMySqlDB.Close;
      end;
    finally
      oldMySqlDB.Free;
    end;

    DatabaseController.FreeMySQLLib('MySql Clients Count при обновлении со старой libd');
{$ifdef USEMEMORYCRYPTDLL}
    DatabaseController.SwitchMemoryLib();
{$endif}

    dbCon.Open;
    try

      try
        ImportOldLibMysqlDFilesToMySql(dbCon, PathToBackup, MySqlPathToBackup);
        FProcessUpdateToNewLibMysqlD := True;
      except
        on UpdateException : Exception do begin
          AProc.LogCriticalError('Ошибка при переносе данных : ' + UpdateException.Message);
          raise Exception.Create(
            'При перемещении данных из старой базы в новою возникла ошибка.' +
            #13#10 +
            'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.');
        end;
      end;
    finally
      dbCon.Close;
    end;

    if DirectoryExists(ExePath + SDirData + 'Old') then
      try
        DeleteDataDir(ExePath + SDirData + 'Old');
        DeleteDirectory(ExePath + SDirData + 'Old');
      except
        on E : Exception do
          AProc.LogCriticalError('Ошибка при удалении старой (libd) базы данных : ' + E.Message);
      end;
  finally
    DatabaseController.FreeMySQLLib('MySql Clients Count при обновлении со старой libd (обратно)');
{$ifdef USEMEMORYCRYPTDLL}
    DatabaseController.SwitchMemoryLib();
{$endif}
  end;
end;

function TDM.NeedCumulativeAfterUpdateToNewLibMySqlD: Boolean;
var
  I : Integer;
begin
  Result := False;
  if FNotImportedWithUpdateToNewLibMysql <> [] then
    for I := 0 to DatabaseController.DatabaseObjects.Count-1 do
      if (DatabaseController.DatabaseObjects[i] is TDatabaseTable)
          and (TDatabaseTable(DatabaseController.DatabaseObjects[i]).RepairType = dortCumulative)
          and (TDatabaseTable(DatabaseController.DatabaseObjects[i]).ObjectId in FNotImportedWithUpdateToNewLibMysql)
      then begin
        Result := True;
        Exit;
      end;
end;

function TDM.GetMaxRetailSupplierMarkup(BaseCost: Currency): Currency;
var
  retail : TRetailMarkup;
begin
  retail := GetRetailMarkup(FRetMargins, BaseCost);
  if Assigned(retail) then
    Result := retail.MaxSupplierMarkup
  else
    Result := 0;
end;

function TDM.GetMaxVitallyImportantSupplierMarkup(
  BaseCost: Currency): Currency;
var
  retail : TRetailMarkup;
begin
  retail := GetRetailMarkup(FVitallyImportantMarkups, BaseCost);
  if Assigned(retail) then
    Result := retail.MaxSupplierMarkup
  else
    Result := 0;
end;

procedure TDM.UpdateDBFileDataFor64(dbCon: TCustomMyConnection);
var
  adcCommand : TMyQuery;
  ExistsMarkups : TObjectList;
  NewMarkups : TObjectList;

  procedure LoadMarkups(TableName: String; Markups: TObjectList);
  begin
    WriteExchangeLog('UpdateMarkups', 'Начали загрузку наценок');
    adcCommand.Close;
    adcCommand.SQL.Text :=
      'select LeftLimit, RightLimit, Markup, MaxMarkup, MaxSupplierMarkup from analitf.' + TableName + ' order by LeftLimit';
    adcCommand.Open;
    try
      Markups.Clear;
      adcCommand.First;
      while not adcCommand.Eof do begin
        WriteExchangeLog('UpdateMarkups',
         Format('Наценка: LeftLimit %s  RightLimit %s  Markup %s  MaxMarkup %s',
          [adcCommand.FieldByName('LeftLimit').AsString,
           adcCommand.FieldByName('RightLimit').AsString,
           adcCommand.FieldByName('Markup').AsString,
           adcCommand.FieldByName('MaxMarkup').AsString]));
        Markups.Add(TRetailMarkup
          .Create(
            adcCommand.FieldByName('LeftLimit').AsCurrency,
            adcCommand.FieldByName('RightLimit').AsCurrency,
            adcCommand.FieldByName('Markup').AsCurrency,
            adcCommand.FieldByName('MaxMarkup').AsCurrency,
            adcCommand.FieldByName('MaxSupplierMarkup').AsCurrency));
        adcCommand.Next;
      end;
    finally
      adcCommand.Close;
      WriteExchangeLog('UpdateMarkups', 'Закончили загрузку наценок');
    end;
  end;

  procedure SaveMarkups(Markups: TObjectList);
  var
    I : Integer;
    markup : TRetailMarkup;
  begin
    dbCon.ExecSQL(
      'truncate analitf.' + DatabaseController.GetById(doiVitallyImportantMarkups).Name, []);
    adcCommand.Close;
    adcCommand.SQL.Text :=
       'insert into analitf.' +
       DatabaseController.GetById(doiVitallyImportantMarkups).Name +
      ' (LeftLimit, RightLimit, Markup, MaxMarkup) values ' +
      '(:LeftLimit, :RightLimit, :Markup, :MaxMarkup);';

    for I := 0 to Markups.Count-1 do begin
      markup := TRetailMarkup(Markups[i]);
      adcCommand.ParamByName('LeftLimit').Value := markup.LeftLimit;
      adcCommand.ParamByName('RightLimit').Value := markup.RightLimit;
      adcCommand.ParamByName('Markup').Value := markup.Markup;
      adcCommand.ParamByName('MaxMarkup').Value := markup.MaxMarkup;
      adcCommand.Execute;
    end;

    DatabaseController.BackupDataTable(doiVitallyImportantMarkups);
  end;

  function GetExistsMarkup(Point: Double): TRetailMarkup;
  var
    I : Integer;
  begin
    Result := nil;
    I := 0;
    while (I < ExistsMarkups.Count) and (Point > TRetailMarkup(ExistsMarkups[i]).LeftLimit) do begin
      if (TRetailMarkup(ExistsMarkups[i]).LeftLimit < Point) and (Point <= TRetailMarkup(ExistsMarkups[i]).RightLimit) then begin
        Result := TRetailMarkup(ExistsMarkups[i]);
        Break;
      end;
      Inc(I);
    end;
  end;

  procedure MoveMarkup(LeftLimit, RightLimit : Double);
  var
    ExistsMarkup : TRetailMarkup;
    NewMarkup : TRetailMarkup;
  begin
    ExistsMarkup := GetExistsMarkup(LeftLimit + 0.01);
    if Assigned(ExistsMarkup) then begin
      NewMarkup := TRetailMarkup
        .Create(
          LeftLimit,
          RightLimit,
          ExistsMarkup.Markup,
          ExistsMarkup.MaxMarkup,
          20);
      ExistsMarkups.Remove(ExistsMarkup);
    end
    else
      NewMarkup := TRetailMarkup
        .Create(
          LeftLimit,
          RightLimit,
          20,
          20,
          20);
    NewMarkups.Add(NewMarkup);
  end;

begin
  adcCommand := TMyQuery.Create(nil);
  try
    adcCommand.Connection := dbCon;

    ExistsMarkups := TObjectList.Create(True);
    NewMarkups := TObjectList.Create(True);
    try
      LoadMarkups(DatabaseController.GetById(doiVitallyImportantMarkups).Name, ExistsMarkups);

      MoveMarkup(0, 50);
      MoveMarkup(50, 500);
      MoveMarkup(500, 1000000);

      SaveMarkups(NewMarkups);
    finally
      ExistsMarkups.Free;
      NewMarkups.Free;
    end;

  finally
    adcCommand.Free;
  end;

  try
    TRegistryHelper.DoAction('Software\Inforoom\AnalitF\' + GetPathCopyID, DeleteRegistryCostColumn);
  except
    on E : Exception do
      WriteExchangeLog('UpdateRegistry', 'Error : ' + E.Message);
  end;
end;

procedure TDM.DeleteRegistryCostColumn(CurrentKey: TRegistry);
var
  names : TStringList;
  I : Integer;
begin
  names := TStringList.Create;
  try
    CurrentKey.GetValueNames(names);
    for I := 0 to names.Count-1 do
      if AnsiEndsText('RegistryCost', names[i]) then
        CurrentKey.DeleteValue(names[i]);
  finally
    names.Free;
  end;
end;

procedure TDM.UpdateDBFileDataFor66(dbCon: TCustomMyConnection);
begin
  try
    TRegistryHelper.DoAction('Software\Inforoom\AnalitF\' + GetPathCopyID, DeletePriceRetColumn);
  except
    on E : Exception do
      WriteExchangeLog('UpdateRegistryFor66', 'Error : ' + E.Message);
  end;
end;

procedure TDM.DeletePriceRetColumn(CurrentKey: TRegistry);
var
  names : TStringList;
  I : Integer;
begin
  names := TStringList.Create;
  try
    CurrentKey.GetValueNames(names);
    for I := 0 to names.Count-1 do
      if AnsiEndsText('PriceRet', names[i]) then
        CurrentKey.DeleteValue(names[i]);
  finally
    names.Free;
  end;
end;

{$ifdef ExportData}
procedure TDM.ExportDBObjectsWithDatabaseController(
  dbCon: TCustomMyConnection; DBDirectoryName: String;
  OldDBVersion: Integer; AOnUpdateDBFileData: TOnUpdateDBFileData);
begin
  dbCon.Open;
  try
    DatabaseController.ExportObjects(dbCon);
  finally
    dbCon.Close;
  end;
end;

procedure TDM.ImportDBObjectsWithDatabaseController(
  dbCon: TCustomMyConnection; DBDirectoryName: String;
  OldDBVersion: Integer; AOnUpdateDBFileData: TOnUpdateDBFileData);
begin
  dbCon.Open;
  try
    DatabaseController.ImportObjects(dbCon);
  finally
    dbCon.Close;
  end;
end;

procedure TDM.ProcessExportImport;
var
  dbExportCon : TMyEmbConnection;
begin
  if FindCmdLineSwitch('export') then begin
    dbExportCon := TMyEmbConnection.Create(nil);
    try

      dbExportCon.Database := MainConnection.Database;
      dbExportCon.Username := MainConnection.Username;
      dbExportCon.DataDir := TMyEmbConnection(MainConnection).DataDir;
      dbExportCon.Options := TMyEmbConnection(MainConnection).Options;
      dbExportCon.Params.Clear;
      dbExportCon.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
      dbExportCon.LoginPrompt := False;

      RunUpdateDBFile(
        dbExportCon,
        ExePath + SDirData,
        0,
        ExportDBObjectsWithDatabaseController,
        nil,
        'Происходит экспорт базы данных. Подождите...');
    finally
      dbExportCon.Free;
    end;
    ExitProcess(1);
  end
  else
    if FindCmdLineSwitch('import') then begin
      dbExportCon := TMyEmbConnection.Create(nil);
      try

        dbExportCon.Database := MainConnection.Database;
        dbExportCon.Username := MainConnection.Username;
        dbExportCon.DataDir := TMyEmbConnection(MainConnection).DataDir;
        dbExportCon.Options := TMyEmbConnection(MainConnection).Options;
        dbExportCon.Params.Clear;
        dbExportCon.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
        dbExportCon.LoginPrompt := False;

        RunUpdateDBFile(
          dbExportCon,
          ExePath + SDirData,
          0,
          ImportDBObjectsWithDatabaseController,
          nil,
          'Происходит импорт базы данных. Подождите...');
      finally
        dbExportCon.Free;
      end;
      ExitProcess(1);
    end;
end;
{$endif}

procedure TDM.CheckLocalTime;
var
  currentTime : TDateTime;
  updateTime : TDateTime;
begin
  currentTime := Now();
  updateTime := UTCToLocalTime(adtParams.FieldByName( 'UpdateDateTime').AsDateTime);
  if (currentTime < updateTime - 1) and (currentTime > updateTime - 30)
  then
    AProc.MessageBox('Время, установленное на компьютере, старше времени последнего обновления больше чем на сутки.', MB_ICONWARNING or MB_OK)
  else
    if (currentTime < updateTime - 30) then begin
      FDisableAllExchange := True;
      MainForm.DisableByHTTPName;
      MainForm.actReceive.Enabled := False;
      MainForm.actReceiveAll.Enabled := False;
      AProc.MessageBox('Время, установленное на компьютере, старше времени последнего обновления больше чем месяц.', MB_ICONERROR or MB_OK)
    end;
end;

procedure TDM.ShowFastReportWithSave(FileName: string; DataSet: TDataSet;
  APreview, PrintDlg: boolean);
var
  oldButtons : TfrPreviewButtons;
begin
  oldButtons := frReport.PreviewButtons;
  try
    frReport.PreviewButtons := frReport.PreviewButtons + [pbSave];
    ShowFastReport(FileName, DataSet, APreview, PrintDlg);
  finally
    frReport.PreviewButtons := oldButtons;
  end;
end;

procedure TDM.SetNetworkSettings;
begin
  MyConnection.Server := GetNetworkSettings.Server;
  MyConnection.Username := GetNetworkSettings.Username;
  MyConnection.Password := GetNetworkSettings.Password;
  MyConnection.Port := GetNetworkSettings.Port;
end;

function TDM.GetRetailCost(VitallyImportant: Boolean; NDS,
  ProducerCost: Variant; SupplierCost: Currency): Currency;
var
  markupVariant : Variant;
  markup : Currency;
begin
  if (VitallyImportant and VarIsNull(ProducerCost))
    or (not VitallyImportant and VarIsNull(ProducerCost) and DM.adsUser.FieldByName('CalculateOnProducerCost').AsBoolean)
  then
    Result := 0
  else begin
    markupVariant := CalcRetailMarkup(
      VitallyImportant,
      ProducerCost,
      SupplierCost);
    if VarIsNull(markupVariant) then begin
      Result := 0;
    end
    else begin
      markup := markupVariant;
      Result := InternalCalcRetailCost(
        markup,
        VitallyImportant,
        NDS,
        ProducerCost,
        SupplierCost
      );
    end;
  end;
end;

procedure TDM.CalcRetailCost(VitallyImportant: Boolean; NDS,
  ProducerCost: Variant; SupplierCost: Currency; RetailMarkup,
  RetailCost: TField);
var
  markupVariant : Variant;
  markup : Currency;
begin
  if (VitallyImportant and VarIsNull(ProducerCost))
    or (not VitallyImportant and VarIsNull(ProducerCost) and DM.adsUser.FieldByName('CalculateOnProducerCost').AsBoolean)
  then begin
    RetailMarkup.Clear;
    RetailCost.Clear;
  end
  else begin
    markupVariant := CalcRetailMarkup(
      VitallyImportant,
      ProducerCost,
      SupplierCost);
    if VarIsNull(markupVariant) then begin
      RetailMarkup.Clear;
      RetailCost.Clear;
    end
    else begin
      RetailMarkup.Value := markupVariant;
      markup := markupVariant;

      RetailCost.Value := InternalCalcRetailCost(
        markup,
        VitallyImportant,
        NDS,
        ProducerCost,
        SupplierCost
      );
    end;
  end;
end;

function TDM.CalcRetailMarkup(VitallyImportant: Boolean;
  ProducerCost: Variant; SupplierCost: Currency): Variant;
begin
  Result := Null;

  if VitallyImportant
  then begin
    if not VarIsNull(ProducerCost) and (ProducerCost > 0)
    then begin
      Result := DM.GetVitallyImportantMarkup(ProducerCost);
    end
  end
  else begin
    if DM.adsUser.FieldByName('CalculateOnProducerCost').AsBoolean then begin
      if not VarIsNull(ProducerCost) and (ProducerCost > 0)
      then begin
        Result := DM.GetRetUpCost(ProducerCost);
      end
    end
    else begin
      Result := DM.GetRetUpCost(SupplierCost);
    end;
  end;
end;

function TDM.InternalCalcRetailCost(markup: Currency;
  VitallyImportant: Boolean; NDS, ProducerCost: Variant;
  SupplierCost: Currency): Currency;
var
  vitallyNDS : Integer;
  vitallyNDSMultiplier : Double;
  nonVitallyNDS : Integer;
  nonVitallyNDSMultiplier : Double;
begin
  if VitallyImportant
  then begin

    if not VarIsNull(NDS) then
      vitallyNDS := NDS
    else
      vitallyNDS := 10;

    //Если cпособ налогообложения ЕНВД и флаг "CalculateWithNDS" сброшен, то множитель = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      vitallyNDSMultiplier := 1
    else
      vitallyNDSMultiplier := (1 + vitallyNDS/100);

    //ЕНВД
    if (DM.adtClientsMethodOfTaxation.Value = 0) then begin

      Result := SupplierCost + ProducerCost*vitallyNDSMultiplier*(markup/100);

    end
    else begin

    //НДС
      Result := SupplierCost + ProducerCost*vitallyNDSMultiplier*(markup/100);

    end;
  end
  else begin

    if VarIsNull(NDS) then
      nonVitallyNDS := 0
    else
      nonVitallyNDS := NDS;

    //Если cпособ налогообложения ЕНВД и флаг "CalculateWithNDS" сброшен, то множитель = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      nonVitallyNDSMultiplier := 1
    else
      nonVitallyNDSMultiplier := (1 + nonVitallyNDS/100);

    //По цене производителя
    if DM.adsUser.FieldByName('CalculateOnProducerCost').AsBoolean then begin

      Result := SupplierCost + ProducerCost*nonVitallyNDSMultiplier*(markup/100);

    end
    else begin

    //По цене поставщика без НДС
      Result := SupplierCost + SupplierCost*(markup/100);

    end;
  end;
end;

function TDM.GetRetailCostByMarkup(VitallyImportant: Boolean; NDS,
  ProducerCost: Variant; SupplierCost, markup: Currency): Currency;
begin
  if (VitallyImportant and VarIsNull(ProducerCost))
    or (not VitallyImportant and VarIsNull(ProducerCost) and DM.adsUser.FieldByName('CalculateOnProducerCost').AsBoolean)
  then begin
    Result := 0;
  end
  else begin
    if (markup > 0.001) then
      Result := InternalCalcRetailCost(
        markup,
        VitallyImportant,
        NDS,
        ProducerCost,
        SupplierCost
      )
    else
      Result := 0;
  end;
end;

procedure TDM.UpdateToNewLibMySqlDWithGlobalParams(
  dbCon: TCustomMyConnection; DBDirectoryName: String;
  OldDBVersion: Integer; AOnUpdateDBFileData: TOnUpdateDBFileData);
var
  oldMySqlDB : TMyEmbConnection;
  PathToBackup,
  MySqlPathToBackup : String;
begin
  PathToBackup := ExePath + SDirTableBackup + '\';
  MySqlPathToBackup := StringReplace(PathToBackup, '\', '/', [rfReplaceAll]);

  DatabaseController.FreeMySQLLib('MySql Clients Count при обновлении со старой libd');
{$ifdef USEMEMORYCRYPTDLL}
  DatabaseController.SwitchMemoryLib(ExePath + SBackDir + '\' + 'appdbhlp.dll' + '.bak');
{$endif}

  try

    oldMySqlDB := TMyEmbConnection.Create(nil);
    try
      oldMySqlDB.Params.Clear();
      oldMySqlDB.Params.Add('--basedir=' + ExtractFileDir(ParamStr(0)) + '\');
      oldMySqlDB.Params.Add('--datadir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirData  + '\');
      oldMySqlDB.Params.Add('--character_set_server=cp1251');
      oldMySqlDB.Params.Add('--tmp_table_size=33554432');
      oldMySqlDB.Params.Add('--max_heap_table_size=33554432');

      try
        oldMySqlDB.Open;
      except
        on OpenException : Exception do begin
          AProc.LogCriticalError('Ошибка при открытии старой базы данных : ' + OpenException.Message);
          raise Exception.Create('Не получилось открыть старую базу данных');
        end;
      end;

      try
        try
          ExportGlobalParamsFromOldLibMysqlDToFile(oldMySqlDB, PathToBackup, MySqlPathToBackup);
          WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', 'Ждем после экспорта');
          Sleep(5000);
        except
          on UpdateException : Exception do begin
            AProc.LogCriticalError('Ошибка при переносе данных : ' + UpdateException.Message);
            raise Exception.Create(
              'При перемещении данных из старой базы в новою возникла ошибка.' +
              #13#10 +
              'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.');
          end;
        end;
      finally
        oldMySqlDB.Close;
        WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', 'Ждем после закрытия соединения');
        Sleep(5000);
      end;
    finally
      oldMySqlDB.Free;
      WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', 'Ждем после закрытия соединения');
      Sleep(5000);
    end;

    WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', 'Освобождаем старую libd');
    DatabaseController.FreeMySQLLib('MySql Clients Count при обновлении со старой libd');
//    WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', 'Освободили старую libd и ждем');
{$ifdef USEMEMORYCRYPTDLL}
    WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', 'Переключаемся на новую libd');
    DatabaseController.SwitchMemoryLib();
    //WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', 'Переключились на новую libd и ждем');
    //Sleep(5000);
{$endif}

    WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', 'Пытаемся обновить структуру базы данных');
    UpdateDBFile(dbCon, DBDirectoryName, OldDBVersion, AOnUpdateDBFileData);

    dbCon.Open;
    try
      try
        ImportOldLibMysqlDGlobalParamsFileToMySql(dbCon, PathToBackup, MySqlPathToBackup);
      except
        on UpdateException : Exception do begin
          AProc.LogCriticalError('Ошибка при переносе данных : ' + UpdateException.Message);
          raise Exception.Create(
            'При перемещении данных из старой базы в новою возникла ошибка.' +
            #13#10 +
            'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.');
        end;
      end;
    finally
      dbCon.Close;
    end;

  finally
    DatabaseController.FreeMySQLLib('MySql Clients Count при обновлении со старой libd (обратно)');
{$ifdef USEMEMORYCRYPTDLL}
    DatabaseController.SwitchMemoryLib();
{$endif}
  end;
end;

procedure TDM.ExportGlobalParamsFromOldLibMysqlDToFile(
  oldMySqlDB: TCustomMyConnection; PathToBackup,
  MySqlPathToBackup: String);
var
  selectMySql : TMyQuery;
  I : Integer;
  exportTable : TDatabaseTable;
  ordersExportTableName : String;
begin
  selectMySql := TMyQuery.Create(nil);
  try
    selectMySql.Connection := oldMySqlDB;

    for I := 0 to DatabaseController.DatabaseObjects.Count-1 do
      if (DatabaseController.DatabaseObjects[i] is TDatabaseTable)
         and (TDatabaseTable(DatabaseController.DatabaseObjects[i]).RepairType <> dortIgnore)
         and (TDatabaseTable(DatabaseController.DatabaseObjects[i]).ObjectId in [doiGlobalParams])
      then begin
        exportTable := TDatabaseTable(DatabaseController.DatabaseObjects[i]);
        if FileExists(PathToBackup + exportTable.Name + '.txt') then
          OSDeleteFile(PathToBackup + exportTable.Name + '.txt');
        try
          selectMySql.SQL.Text :=
            Format(
            'select * from analitf.%s INTO OUTFILE ''%s'';',
            [exportTable.Name,
             MySqlPathToBackup + exportTable.Name + '.txt']);
          selectMySql.Execute;
        except
          on E : Exception do begin
            WriteExchangeLog('Exchange.ExportGlobalParamsFromOldLibMysqlDToFile',
            'Ошибка при экспорте таблицы ' + exportTable.Name + ': ' + E.Message);
            if FileExists(PathToBackup + exportTable.Name + '.txt')
              and (GetFileSize(PathToBackup + exportTable.Name + '.txt') = 0)
            then
              try
                OSDeleteFile(PathToBackup + exportTable.Name + '.txt');
              except
                on DeleteFile : Exception do
                  WriteExchangeLog('Exchange.ExportGlobalParamsFromOldLibMysqlDToFile',
                  'Ошибка при удалении файла ' + exportTable.Name + ': ' + DeleteFile.Message);
              end;
          end;
        end;
      end;

  finally
    selectMySql.Free();
  end;
end;

procedure TDM.ImportOldLibMysqlDGlobalParamsFileToMySql(
  dbCon: TCustomMyConnection; PathToBackup, MySqlPathToBackup: String);
var
  selectMySql : TMyQuery;
  I : Integer;
  importTable : TDatabaseTable;
begin
  FNotImportedWithUpdateToNewLibMysql := [];
  selectMySql := TMyQuery.Create(nil);
  try
    selectMySql.Connection := dbCon;

    for I := 0 to DatabaseController.DatabaseObjects.Count-1 do
      if (DatabaseController.DatabaseObjects[i] is TDatabaseTable)
         and (TDatabaseTable(DatabaseController.DatabaseObjects[i]).RepairType <> dortIgnore)
         and (TDatabaseTable(DatabaseController.DatabaseObjects[i]).ObjectId = doiGlobalParams)
      then begin
        importTable := TDatabaseTable(DatabaseController.DatabaseObjects[i]);
        if FileExists(PathToBackup + importTable.Name + '.txt') then
        begin
          try
            selectMySql.SQL.Text :=
              Format('delete from analitf.%s;', [importTable.Name]);
            selectMySql.Execute;
            selectMySql.SQL.Text :=
              Format(
              'LOAD DATA INFILE ''%s'' into table analitf.%s;',
              [MySqlPathToBackup + importTable.Name + '.txt',
               importTable.Name]);
            selectMySql.Execute;
          except
            on ImportException : Exception do begin
              FNotImportedWithUpdateToNewLibMysql :=
                FNotImportedWithUpdateToNewLibMysql + [importTable.ObjectId];
              WriteExchangeLog('Exchange.ImportOldLibMysqlDGlobalParamsFileToMySql',
              'Ошибка при импорте таблицы ' + importTable.Name + ': ' + ImportException.Message);
            end;
          end;

          try
            OSDeleteFile(PathToBackup + importTable.Name + '.txt', False);
          except
            on DeleteFile : Exception do
              WriteExchangeLog('Exchange.ImportOldLibMysqlDGlobalParamsFileToMySql',
              'Ошибка при удалении файла ' + importTable.Name + ': ' + DeleteFile.Message);
          end;
        end
        else
          FNotImportedWithUpdateToNewLibMysql :=
            FNotImportedWithUpdateToNewLibMysql + [importTable.ObjectId];
      end;
      
  finally
    selectMySql.Free;
  end;
end;

function TDM.DataSetToString(
  SQL: String;
  Params: array of string;
  Values: array of Variant): String;
var
  Header : String;
  Row : String;
  I : Integer;
begin
  Result := '';
  Header := '';

  if (Length(Params) <> Length(Values)) then
    raise Exception.Create('QueryValue: Кол-во параметров не совпадает со списком значений.');

  if DM.adsQueryValue.Active then
     DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text := SQL;

  for I := Low(Params) to High(Params) do
    DM.adsQueryValue.ParamByName(Params[i]).Value := Values[i];

  DM.adsQueryValue.Open;
  try
    for I := 0 to DM.adsQueryValue.Fields.Count-1 do
      if Header = '' then
        Header := DM.adsQueryValue.Fields[i].FieldName
      else
        Header := Header + Chr(9) + DM.adsQueryValue.Fields[i].FieldName;
    Result := Header + #13#10 + StringOfChar('-', Length(Header));
    while not DM.adsQueryValue.Eof do begin
      Row := '';
      for I := 0 to DM.adsQueryValue.Fields.Count-1 do
        if Row = '' then
          Row := DM.adsQueryValue.Fields[i].AsString
        else
          Row := Row + Chr(9) + DM.adsQueryValue.Fields[i].AsString;
      Result := Concat(Result, #13#10, Row);
      DM.adsQueryValue.Next;
    end;
  finally
    DM.adsQueryValue.Close;
  end;
end;

function TDM.NeedUpdateToNewLibMySqlDWithGlobalParams: Boolean;
var
  buildNumber : Word;
begin
  if FindCmdLineSwitch('i')
    and FileExists(ExePath + SBackDir + '\' + ExeName + '.bak')
    and FileExists(ExePath + SBackDir + '\' + 'appdbhlp.dll' + '.bak')
  then
  begin
    buildNumber := GetBuildNumberLibraryVersionFromPath(ExePath + SBackDir + '\' + ExeName + '.bak');
    Result := (buildNumber >= 1295) and (buildNumber <= 1349);
  end
  else
    if FindCmdLineSwitch('i')
      and FileExists(ExePath + SBackDir + '\' + ExeName + '.bak')
    then
    begin
      buildNumber := GetBuildNumberLibraryVersionFromPath(ExePath + SBackDir + '\' + ExeName + '.bak');
      Result := (buildNumber > 1349) and (buildNumber <= 1353);
    end
    else
      Result := False;
end;

function TDM.GetPriceRetByMarkup(BaseCost, Markup: Currency): Currency;
begin
  Result := (1 + Markup/100)*BaseCost;
end;

function TDM.GetRetUpCostByRetailCost(BaseCost,
  RetailCost: Currency): Currency;
begin
  Result := (RetailCost/BaseCost - 1)* 100;
end;

function TDM.GetRetailCostLast(VitallyImportant: Boolean;
  SupplierCost: Currency): Currency;
begin
  Result := GetPriceRetByMarkup(
    SupplierCost,
    GetRetailMarkupValue(VitallyImportant, SupplierCost));
end;

function TDM.GetRetailMarkupValue(VitallyImportant: Boolean;
  SupplierCost: Currency): Currency;
begin
  if VitallyImportant then
    Result := GetVitallyImportantMarkup(SupplierCost)
  else
    Result := GetRetUpCost(SupplierCost);
end;

procedure TDM.CheckNewNetworkVersion;
var
  CurrentBuild,
  NewBuild : Word;
  EraserDll: TResourceStream;
begin
  if SysUtils.DirectoryExists( RootFolder() + SDirNetworkUpdate) and
    FileExists(RootFolder() + SDirNetworkUpdate + '\AnalitF.exe')
  then begin
    CurrentBuild := GetBuildNumberLibraryVersionFromPath(ExePath + ExeName);
    NewBuild := GetBuildNumberLibraryVersionFromPath(RootFolder() + SDirNetworkUpdate + '\AnalitF.exe');

    if NewBuild > CurrentBuild then begin
      DeleteDirectory(ExePath + SDirNetworkUpdate);
      CopyDirectories(RootFolder() + SDirNetworkUpdate, ExePath + SDirNetworkUpdate);

      AProc.MessageBox('Получена новая версия программы. Сейчас будет выполнено обновление', MB_OK or MB_ICONWARNING);

      EraserDll := TResourceStream.Create( hInstance, 'ERASER', RT_RCDATA);
      try
        EraserDll.SaveToFile(ExePath + 'Eraser.dll');
      finally
        EraserDll.Free;
      end;

      ShellExecute( 0, nil, 'rundll32.exe', PChar( ' '  + ExtractShortPathName(ExePath) + 'Eraser.dll,Erase ' + '-no ' + IntToStr(GetCurrentProcessId) + ' "' +
        ExePath + ExeName + '" "' + ExePath + SDirNetworkUpdate + '"'),
        nil, SW_SHOWNORMAL);

      ExitProcess(1);
    end;
  end;
end;

procedure TDM.ExtractRollbackAF;
var
  RollbackAF: TResourceStream;
begin
  RollbackAF := TResourceStream.Create( hInstance, 'RollbackAF', RT_RCDATA);
  try
    RollbackAF.SaveToFile(ExePath + 'RollbackAF.exe');
  finally
    RollbackAF.Free;
  end;
end;

function TDM.AllowAutoComment: Boolean;
begin
  Result := (Length(AutoComment) > 0)
  and ((MainForm.ActiveChild is TCoreForm)
      or (MainForm.ActiveChild is TSynonymSearchForm)
      or (MainForm.ActiveChild is TCoreFirmForm));
end;

procedure TDM.UpdateComment(comment: String; OrderId : Int64; CoreId: Variant);
var
  currentComment : Variant;
  tmpCommet,
  newComment : String;
begin
  currentComment := DM.QueryValue(''
+' select '
+'   Comment '
+' from '
+'   CurrentOrderLists '
+' where '
+'   OrderId = :OrderId  '
+'  and CoreId = :CoreId  '
+' limit 1 ',
      ['OrderId', 'CoreId'],
      [OrderId, CoreId]);

   if VarIsNull(currentComment) or (not VarIsNull(currentComment) and (Length(currentComment) = 0))
   then
     newComment := AutoComment
   else begin
     tmpCommet := currentComment;
     if AnsiPos(AutoComment, tmpCommet) = 0 then
       newComment := tmpCommet + '/' + AutoComment
     else
       newComment := tmpCommet;
   end;

   MainConnection.ExecSQL(
    'update CurrentOrderLists set `Comment` = :Comment where OrderId = :OrderId and CoreId = :CoreId',
    [newComment, OrderId, CoreId]);
end;

procedure TDM.InsertUserActionLog(UserActionId: TUserAction);
begin
  InsertUserActionLog(UserActionId, []);
end;

procedure TDM.InsertUserActionLog(UserActionId: TUserAction;
  Contexts: array of string);
var
  context : String;
  I : Integer;
  contextVariant : Variant;
begin
  context := '';
  contextVariant := Null;
  for I := Low(Contexts) to High(Contexts) do
    if Length(Contexts[i]) > 0 then
      if Length(context) > 0 then
        context := context + ', ' + Contexts[i]
      else
        context := Contexts[i];
  if Length(context) > 0 then
    contextVariant := context;

  DBProc.UpdateValue(
    MainConnection,
    'insert into useractionlogs (UserActionId, Context) values (:UserActionId, :Context)',
    ['UserActionId', 'Context'],
    [UserActionId, contextVariant]);
end;

initialization
  AddTerminateProc(CloseDB);
  PassC := TINFCrypt.Create(gcp, 48);
  SummarySelectedPrices := TStringList.Create;
  SynonymSelectedPrices := TStringList.Create;
  MinCostSelectedPrices := TStringList.Create;
finalization
  PassC.Free;
  ClearSelectedPrices(SummarySelectedPrices);
  ClearSelectedPrices(SynonymSelectedPrices);
  ClearSelectedPrices(MinCostSelectedPrices);
  SummarySelectedPrices.Free;
  SynonymSelectedPrices.Free;
  MinCostSelectedPrices.Free;
end.
