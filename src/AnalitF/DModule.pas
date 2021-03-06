unit DModule;

interface

{$I '..\AF.inc'}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Variants, FileUtil, ARas, ComObj, FR_Class, FR_View,
  FR_DBSet, FR_DCtrl, FR_RRect, FR_Chart, FR_Shape, FR_ChBox,
  frRtfExp, frexpimg, FR_E_HTML2, FR_E_TXT, FR_Rich,
//  ActiveX,
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
  UserActions,
  GlobalParams,
  DownloadAppFiles,
  U_LegendHolder,
  U_InstallNetThread;

{
�����������
  �������� - ��� � ����� ��� %
  ����     - ��� � ����� ��� %
  Code, CodeCr - ��������� ���
}

const
  HistoryMaxRec=5;
  //����. ���-�� ����� ����������� � �������
  RegisterId=59; //��� ������� � ����������� ����
  //������ ��� �������� �������
  PassPassW = 'sh' + #90 + 'kjw' + #10 + 'h';
  //������ ����������� ���������
  CriticalLibraryHashes : array[0..15] of array[0..4] of string =
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
      ('vclx70.bpl', 'E12C66FF', 'D510C787', '31D5400E', 'DDECD8C8')
  );

type
  //������ ���������� ������� � ���� �� ������� ����������
  //pdmPrev - �� ����������� ����������, pdmMin - �� ���������� � min �����,
  //pdmMinEnabled - �� ������.����. � min �����
  TPriceDeltaMode =( pdmPrev, pdmMin, pdmMinEnabled);

  //exit codes - ���� ������ ������ �� ���������
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
    adtClientsCalculateWithNDSForOther: TBooleanField;
    adsOrderDetailsMarkup: TFloatField;
    adtClientsExcessAvgOrderTimes: TIntegerField;
    adsOrderDetailsEAN13: TStringField;
    adsOrderDetailsCodeOKP: TStringField;
    adsOrderDetailsSeries: TStringField;
    procedure adtClientsOldAfterOpen(DataSet: TDataSet);
    procedure MainConnectionOldAfterConnect(Sender: TObject);
    procedure adtParamsOldAfterPost(DataSet: TDataSet);
    procedure adtReceivedDocsAfterPost(DataSet: TDataSet);
    procedure frReportPrintReport;
  private
    //��������� �� ������������� ������
    FNeedCommitExchange : Boolean;
    //��� ������������� ����������, ���������� � �������
    FServerUpdateId : String;
    DBUIN : String;
    //��������� ���������� ��-�� ����, ��� ������������ UIN
    FNeedUpdateByCheckUIN : Boolean;
    //��������� ���������� ��-�� ����, ��� ������������ Hash'� ���������
    FNeedUpdateByCheckHashes : Boolean;
    //��������� ������ ����� �������������� �� ��������� �����
    FNeedImportAfterRecovery : Boolean;
    //���� ������� "������" ���� ������
    FCreateClearDatabase     : Boolean;
    FGetCatalogsCount : Integer;
    FRetMargins : TObjectList;
    FVitallyImportantMarkups : TObjectList;
    HTTPC : TINFCrypt;
    OrdersInfo : TStringList;
    //�������� ����� ����� � �������� ��-�� ������� �� �������
    FDisableAllExchange : Boolean;

    //���� ����������� ���������� ��������� � Firebird �� MySql
    FProcessFirebirdUpdate : Boolean;

    //���� ����������� ���������� ��������� � ������ 800-x �� 945
    FProcess800xUpdate : Boolean;

    //���� ����������� ���������� ��������� �� ����� ������ libmysqld
    FProcessUpdateToNewLibMysqlD : Boolean;
    //�� ���� ������������� � �������� ���������� �� ������ ���� ������ �� �����
    FNotImportedWithUpdateToNewLibMysql : TRepairedObjects;

    FReportPrinted : Boolean;

    procedure CheckRestrictToRun;
    function CheckStartupFolder() : Boolean;
    procedure CheckDBFile;
    procedure ReadPasswords;
    function CheckCopyIDFromDB : Boolean;
    function GetCatalogsCount : Integer;
    procedure LoadSelectedPrices;
    function CheckCriticalLibrary : Boolean;
    //��������� ������ ���� � ��������� �� � ������ �������������
    procedure UpdateDB;
    //���������� UIN � ���� ������ � ������ ���������� ������ ���������
    procedure UpdateDBUIN(dbCon : TCustomMyConnection);
    //��������� ������� ���� �������� � ���� ������
    procedure CheckDBObjectsWithDatabaseController(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
{$ifdef ExportData}
    procedure ExportDBObjectsWithDatabaseController(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ImportDBObjectsWithDatabaseController(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ProcessExportImport;
{$endif}
    //��������� � ��������� ������������ ����
    procedure UpdateDBFile(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure OnScriptExecuteError(Sender: TObject;
      E: Exception; SQL: String; var Action: TErrorAction);
    procedure UpdateDBFileDataFor64(dbCon : TCustomMyConnection);
    procedure UpdateDBFileDataFor66(dbCon : TCustomMyConnection);
    procedure DeleteRegistryCostColumn(CurrentKey : TRegistry);
    procedure DeletePriceRetColumn(CurrentKey : TRegistry);
    procedure UpdateDBFileDataFor96(dbCon : TCustomMyConnection);
    //���������� ������� ��������� ��� ������� �������
    procedure SetSendToNotClosedOrders;
    function GetFullLastCreateScript : String;
    //������� ���� ������
    procedure CreateClearDatabaseFromScript(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    //��������������� ���� ������ �� ���������� �������� �����
    procedure RestoreDatabaseFromPrevios(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    //���������� ����������� ���� ������ � 800-� ������ �� ���� ������ MySql ������ �������
    procedure Update800xToMySql(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ExportFrom800xToFiles(oldMySqlDB : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    procedure Import800xFilesToMySql(dbCon : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    //���������� ���������� ���� ������ �� libmysqld  ������ �������
    procedure UpdateToNewLibMySqlD(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ExportFromOldLibMysqlDToFiles(oldMySqlDB : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    procedure ImportOldLibMysqlDFilesToMySql(dbCon : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    procedure UpdateToNewLibMySqlDWithGlobalParams(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ExportGlobalParamsFromOldLibMysqlDToFile(oldMySqlDB : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    procedure ImportOldLibMysqlDGlobalParamsFileToMySql(dbCon : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);

    procedure UpdateToNewLibMySqlD1651(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ExportFromOldLibMysqlDToFiles1651(oldMySqlDB : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    procedure ImportOldLibMysqlDFilesToMySql1651(dbCon : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);

    procedure UpdateToNewLibMySqlD1711(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    procedure ExportFromOldLibMysqlDToFiles1711(oldMySqlDB : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    procedure ImportOldLibMysqlDFilesToMySql1711(dbCon : TCustomMyConnection; PathToBackup, MySqlPathToBackup : String);
    //���������� ������������� �� ��������� ����� (���� ��� ����������) ��� ������� ������ ���� ������
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
    //������� ������ ���������� � Mysql � ���������� � ���������� �������
    procedure DeleteOldMysqlFolder;
    //���������� ���������� � 800-x ������ � ����������
    procedure PrepareUpdate800xToMySql;
    //���������� ���������� ������ libmysqld � ����������
    procedure PrepareUpdateToNewLibMySqlD;
    //���������� ���������� ������ libmysqld � ���������� �� ����� CryptDLL
    procedure PrepareUpdateToNewCryptLibMySqlD;
    //���������� ���������� ������ libmysqld � ���������� �� ����� CryptDLL ����� ������ 1651
    procedure PrepareUpdateToNewCryptLibMySqlDAfter1651;
{$ifdef USEMEMORYCRYPTDLL}
    procedure CheckSpecialLibrary;
{$endif}
{$ifdef DEBUG}
    procedure MySQLMonitorSQL(Sender: TObject; Text: String;
      Flag: TDATraceFlag);
{$endif}
    procedure SetNetworkSettings;
    procedure CheckLocalTime;
    procedure UpdateNewFiles;
  public
    FFS : TFormatSettings;
    SerBeg,
    SerEnd : String;
    SaveGridMask : Integer;
    GlobalExclusiveParams : TExclusiveParams;
    
    AutoComment : String;

    procedure CompactDataBase();
    function ShowFastReport(FileName: string; DataSet: TDataSet = nil;
      APreview: boolean = False; PrintDlg: boolean = True) : Boolean;
    function ShowFastReportWithSave(FileName: string; DataSet: TDataSet = nil;
      APreview: boolean = False; PrintDlg: boolean = True) : Boolean;
    function ShowOrderDetailsReport(
      OrderId  : Integer;
      Closed   : Boolean;
      Send     : Boolean;
      Preview  : Boolean = False;
      PrintDlg : Boolean = True) : Boolean;
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
    function AutoUpdateFailed() : Boolean;
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
    //�������� ��������� ���� ������ � ����������� �� �������
    function GetPriceRet(BaseCost : Currency) : Currency;
    //�������� ��������� ���� ������ � ����������� �� ������������ �������
    function GetPriceRetByMarkup(BaseCost : Currency; Markup : Currency) : Currency;
    //�������� ��������� ������� ������
    function GetRetUpCost(BaseCost : Currency) : Currency;
    //�������� ��������� ������� ������ �� ��������� ����
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
    //�������� ������� ������ ��� �����
    function GetVitallyImportantMarkup(BaseCost : Currency) : Currency;
    function GetMaxVitallyImportantMarkup(BaseCost : Currency) : Currency;
    function GetMaxVitallyImportantSupplierMarkup(BaseCost : Currency) : Currency;
    function VitallyImportantMarkupsExists : Boolean;

    function GetRetailMarkup(Markups : TObjectList; BaseCost : Currency) : TRetailMarkup;
    function GetMarkup(Markups : TObjectList; BaseCost : Currency) : Currency;

    function GetRetailCostLast(
      VitallyImportant : Boolean;
      SupplierCost : Currency;
      individualMarkup : Variant
    ) : Currency;
    function GetRetailMarkupValue(
      VitallyImportant : Boolean;
      SupplierCost : Currency;
      individualMarkup : Variant
    ) : Currency;

    //������������ ����� � �����������
    procedure ProcessDocs(ImportDocs : Boolean);
    //������������ ������ ���������� �����
    procedure ProcessDocsDir(DirName : String; MaxFileDate : TDateTime; FileList : TStringList);
    procedure ProcessWaybillsDir(DirName : String; MaxFileDate : TDateTime; FileList : TStringList);
    function MoveWaybillToSupplierFolder(fullFileName : String) : String;
    procedure OpenDocsDir(DirName : String; FileList : TStringList; OpenEachFile : Boolean);

    //�������� ����� ������
    function  GetSumOrder (OrderID : Integer; Closed : Boolean = False) : Currency;
    procedure GetOrderInfo (
      OrderID : Int64;
      var PriceName,
      RegionName :String);
    //�������� ����� ������ �� PriceCode � RegionCode
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
    //���������� ��������� ��� ���������� TIdHTTP
    procedure InternalSetHTTPParams(SetHTTP : TIdHTTP);
    function  QueryValue(SQL : String; Params: array of string; Values: array of Variant) : Variant;
    property MainConnection : TCustomMyConnection read GetMainConnection;
    //���������� ������� ��������� ������, ����� ����� �������� ���-�� ��� ������ �������
    procedure InsertOrderHeader(orderDataSet : TCustomMyDataSet);
    procedure CheckDataIntegrity;
    //�������� ���������� � �������
    procedure GetClientInformation(
      var ClientName : String;
      var IsFutureClient : Boolean);
    function GetEditNameAndAddress : String;
    function GetClearSendResultSql(ClientId : Int64) : String;
    function NeedUpdate800xToMySql : Boolean;
    function NeedUpdateToNewLibMySqlD : Boolean;
    function NeedUpdateToNewLibMySqlDWithGlobalParams : Boolean;
    function NeedCumulativeAfterUpdateToNewLibMySqlD : Boolean;
    function NeedUpdateToNewCryptLibMySqlD : Boolean;
    function NeedUpdateToNewCryptLibMySqlDAfter1651 : Boolean;
    function NeedUpdateToNewCryptLibMySqlDOn1711 : Boolean;
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

    function NeedShowCertificatesResults() : Boolean;

    function OpenCertificateFiles(certificateId : Int64) : Integer;

    function ShowCertificatesResults() : String;

    function CertificateSourceExists(serverDocumentBodyId : Int64) : Boolean;
    procedure ShowCertificateWarning();

    procedure OpenAttachment(attachmentId : Int64; extension: String);

    procedure StartUp;

    procedure ShowAttachments(fileList : TStringList);

    procedure FillClientAvg();

    function ExistsInFrozenOrders(productId : Int64) : Boolean;
    procedure StartInstallNet();
    procedure StopInstallNet();
    procedure KillInstallNet();
  end;

var
  DM: TDM;
  PassC : TINFCrypt;
  SummarySelectedPrices,
  SynonymSelectedPrices,
  MinCostSelectedPrices : TStringList;
  installNetThread : TInstallNetThread;

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
     CoreFirm,
     FileCountHelper,
     U_WaybillGridFactory;

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
    WriteExchangeLog('AnalitF', '������� ������� ���������.');
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
            AProc.LogCriticalError('������ ��� ��������� ClientId: ' + E.Message);
        end;
        DM.ResetStarted;
      end;

      DM.KillInstallNet;

      ShowSQLWaiting(DM.InternalCloseMySqlDB, '���������� ���������� ���������');
    end;
    WriteExchangeLog('AnalitF', '��������� �������.');
  except
    on E : Exception do
      LogCriticalError('������ ��� ���������� � �������� ��: ' + E.Message);
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

procedure TDM.StartUp;
var
  HTTPS,
  HTTPE : String;
  UpdateByCheckUINExchangeActions : TExchangeActions;
  UpdateByCheckUINSuccess : Boolean;
  fileCountHelper : TFileCountThread; 
begin
{$ifdef USEMEMORYCRYPTDLL}
  //��������� ������������� MemoryLib, �.�. ��� �� ��������
  //DatabaseController.DisableMemoryLib();
{$endif}
  SetNetworkSettings;

{$ifdef DEBUG}
  MySQLMonitor.Active := False;
  MySQLMonitor.OnSQL := MySQLMonitorSQL;
{$endif}
  FRetMargins := TObjectList.Create(True);
  FVitallyImportantMarkups := TObjectList.Create(True);;

  WriteExchangeLog('AnalitF', '��������� ����������� � �������: "' + ExtractFileDir(ParamStr(0)) + '"');
  mainStartupHelper.Write('DModule', '������ ���������������� ��������');

  if not CheckStartupFolder() then
    AProc.MessageBox(
      Format('��������� ����������� � ������������ ������� %s.'#13#10 +
      '������ ��������� ����� ���� ������������.', [ExePath]),
      MB_ICONWARNING or MB_OK);
      
  FProcessFirebirdUpdate := False;
  FProcess800xUpdate := False;
  FProcessUpdateToNewLibMysqlD := False;

  if GetNetworkSettings().IsNetworkVersion then begin
    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ������� ������� ������');
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
    ShowSQLWaiting(PrepareUpdate800xToMySql, '���������� ���������� � ����������');

  if NeedUpdateToNewLibMySqlD then
    ShowSQLWaiting(PrepareUpdateToNewLibMySqlD, '���������� ���������� � ����������');

  if NeedUpdateToNewCryptLibMySqlD then
    ShowSQLWaiting(PrepareUpdateToNewCryptLibMySqlD, '���������� ���������� � ����������');

  if NeedUpdateToNewCryptLibMySqlDAfter1651 then
    ShowSQLWaiting(PrepareUpdateToNewCryptLibMySqlDAfter1651, '���������� ���������� � ����������');

  if NeedUpdateToNewCryptLibMySqlDOn1711 then
    ShowSQLWaiting(PrepareUpdateToNewCryptLibMySqlDAfter1651, '���������� ���������� � ����������');


  DeleteOldMysqlFolder;

  UpdateNewFiles;

  mainStartupHelper.Write('DModule', '��������� ���������������� ��������');

{$ifdef USEMEMORYCRYPTDLL}
  mainStartupHelper.Write('DModule', '������ �������� ������������������ ����������');
  CheckSpecialLibrary;
  mainStartupHelper.Write('DModule', '��������� �������� ������������������ ����������');
{$endif}

  //������������� ��������� embedded-����������
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
  //��� ��������� ����� ��������� ���������� �������� 60% ��������� ������
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
    LogExitError('������ ���� ����� ��������� �� ����� ���������� ����������.', Integer(ecDoubleStart));

  if GetNetworkSettings().IsNetworkVersion then
    CheckNewNetworkVersion;

  WriteExchangeLog('AnalitF', '��������� ��������.');

  fileCountHelper := TFileCountThread.Create; 
{$ifdef TestEmbeddedMysql}
  TestEmbeddedMysql();
  ExitProcess(1);
{$endif}

{
  try
    MainConnection.Open;
  except
    on E : Exception do
      LogExitError(Format( '���������� ������� ���� ������: %s ', [ E.Message ]), Integer(ecDBFileError));
  end;
}

  //������� ����� ���� ������ ��� �������������
{
  if FindCmdLineSwitch('renew') then
    RunDeleteDBFiles();
}    

{$ifdef ExportData}
  //�������/������ ������ �� �������
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
        LogExitError(Format( '���������� ������������ ���� ������ �� ��������� ����� : %s ', [ E.Message ]), Integer(ecDBFileError));
    end;
}    

{
  if FileExists(ExePath + DatabaseName) and ((FileGetAttr(ExePath + DatabaseName) and SysUtils.faReadOnly) = SysUtils.faReadOnly)
  then
    LogExitError(Format( '���� ���� ������ %s ����� ������� "������ ������".', [ ExePath + DatabaseName ]), Integer(ecDBFileReadOnly));
    }

  mainStartupHelper.Write('DModule', '������ �������� ���� ������');
  //������ �������� ����� ���� ������ � � ������ ������� ���������� �������������� �� ���������� ������� �����
  //��������� ����, ���� ���������� Embedded-������, � ���� ������ - ���������� ������� ���������� ��������� � ��������� ������ �� ����
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
  mainStartupHelper.Write('DModule', '��������� �������� ���� ������');

  mainStartupHelper.Write('DModule', '������ �������� ��� �������');
  try
    try
      CheckRestrictToRun;
    finally
      MainConnection.Close;
    end;
  except
    on E : Exception do
      LogExitError(Format( '���������� ������� ���� ���� ������ : %s '#13#10'���������� � �� �������.', [ E.Message ]), Integer(ecDBFileError));
  end;
  mainStartupHelper.Write('DModule', '��������� �������� ��� �������');

  MainConnection.Open;
  GlobalExclusiveParams := TExclusiveParams.Create(MainConnection);
  LegendHolder.ReadLegends(MainConnection);
{$ifdef DEBUG}
  WriteExchangeLog('DModule',
      Concat('UserActionLogs', #13#10,
        DM.DataSetToString('select Id, LogTime, UserActionId, Context from UserActionLogs', [], [])));
{$endif}
  InsertUserActionLog(uaStart);

  //todo: ����� ����� ���� ������ ��� �������� �����, �� ���� ����������
  if not GetNetworkSettings.IsNetworkVersion then
    if not WaybillsHelper.CheckWaybillFolders(MainConnection) then
      AProc.MessageBox('���������� ��������� ����� ��� �������� ��������� �� ����� "������������"', MB_ICONWARNING);

  { ������������� ������� ������ � Clients � Users }
  if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
    then adtClients.First;

  SetStarted;
  ClientChanged;

  WriteExchangeLog('DModule', Concat('�� ������������: ', adtParams.FieldByName('StoredUserId').AsString));
  GetAddressController.UpdateAddresses(MainConnection, DM.adtClientsCLIENTID.Value);
  GetSupplierController.UpdateSuppliers(MainConnection);

  { ������������� ��������� ������ }
  frReport.Title := Application.Title;
  { ��������� � ���� ���� ������� ������ �������� }
  if not DirectoryExists( RootFolder() + SDirDocs) then CreateDir( RootFolder() + SDirDocs);
  if not DirectoryExists( RootFolder() + SDirWaybills) then CreateDir( RootFolder() + SDirWaybills);
  if not DirectoryExists( RootFolder() + SDirRejects) then CreateDir( RootFolder() + SDirRejects);
  if not DirectoryExists( RootFolder() + SDirIn) then CreateDir( RootFolder() + SDirIn);
  if not DirectoryExists( ExePath + SDirIn) then CreateDir( ExePath + SDirIn);
  if not DirectoryExists( ExePath + SDirReclame) then CreateDir( ExePath + SDirReclame);
  if not DirectoryExists( RootFolder() + SDirReclame) then CreateDir( RootFolder() + SDirReclame);
  if not DirectoryExists( RootFolder() + SDirPromotions) then CreateDir( RootFolder() + SDirPromotions);
  if not DirectoryExists( RootFolder() + SDirCertificates) then CreateDir( RootFolder() + SDirCertificates);
  if not DirectoryExists( RootFolder() + SDirNews) then CreateDir( RootFolder() + SDirNews);

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
        //���� �� ���������� ����������, �� ���������� ����� ������������ ��� ������������� �������� � �����������
        UpdateByCheckUINSuccess := (ShowConfig(True) * AuthChanges) <> [];

        //���� ������������ ���� �������������, �� �������� ���������� ��� ���
        if UpdateByCheckUINSuccess then
          UpdateByCheckUINSuccess := RunExchange(UpdateByCheckUINExchangeActions);

        //���� ������������ ��������� �� �������, �� ��������� ������������� �� ���������� ��������
        //���� �������� �� �������������, �� ��������� � ������ ��������� ���������
        //���� �������� �������������, �� �������� ���������� �������� UIN �
        //���������� ��������� � ���������������� ����������
        if not UpdateByCheckUINSuccess then
          if adtParams.FieldByName('HTTPNameChanged').AsBoolean then begin
            MainForm.DisableByHTTPName;
            LogCriticalError('�� ������ �������� �� UIN � ����.');
          end
          else
            LogExitError(
              '�� ������ �������� �� UIN � ����. ' +
                '�� ������� ������������� ���������� ����������',
              Integer(ecNotCheckUIN), False);
      end;
    end;

    if FNeedUpdateByCheckHashes then begin
      if not RunExchange([ eaGetPrice]) then
        LogExitError('�� ������ �������� �� ����������� �����������.', Integer(ecNotChechHashes), False);
    end;

    { ������ � ������ -e (��������� ������ � �����)}
    if FindCmdLineSwitch('e') then
    begin
      MainForm.ExchangeOnly := True;
      //���������� ������ � ��� ������, ���� �� ���� ������� "������" ����
      if not CreateClearDatabase then
        RunExchange([ eaGetPrice]);
      Application.Terminate;
    end;
    //"���������� ��������������" - ������������ � ��� ������, ���� ���� �������� ����� ������ ��������� ���
    if FindCmdLineSwitch('si') then
    begin
      MainForm.ExchangeOnly := True;
      //���������� ������ � ��� ������, ���� �� ���� ������� "������" ����
      if not CreateClearDatabase then
        //����� ���� ��������� ������������ �������� ���������� ����� ��� ���������� ���������
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
  //���� �������� ���������� � �������� ����� ����������, �� ��������� ��������
  //� ����������� ������������
  if GetCurrentThreadId = MainThreadID then begin
    //��������� ��� ����� ����� ������ �������, �.�. �� ��� ������� �� �������
    MainForm.FreeChildForms;
    MainForm.SetOrdersInfo;
  end;
  DoPost(adtParams, True);
end;

{ �������� �� ������������� ������� ��������� }
procedure TDM.CheckRestrictToRun;
var
  MaxUsers, ProcessCount: integer;
  FreeAvail,
  Total,
  TotalFree,
  DBFileSize : Int64;
begin
  if GetDisplayColors < 16 then
    LogExitError('�� �������� ������ ��������� � ������� ��������� �������������. ����������� �������� ������������� : 16 ���.', Integer(ecColor));

  if AutoUpdateFailed() then
    AProc.MessageBox(
      '��������! ��������� ����� ������ ����������� ��������, �������� ������ ������.'#13#10 +
      '�������� ����� � ���������� �������������� � ���������� ���������� � ��������� �������.'#13#10 +
      '��� ���������� ������, ����������, ���������� � ������ ����������� ��������� �� ������� ��� ��������� ����������',
      MB_ICONWARNING or MB_OK);

  if not TCPPresent then
    LogExitError('�� �������� ������ ��������� ��� ������������� ���������� Windows Sockets ������ 2.0.', Integer(ecTCPNotExists));

  LoadSevenZipDLL();

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
      LogExitError(Format( '�������� ����� �� ����������� � ���� ������ (����� : %d). ' +
        '������ ��������� ����������.', [ MaxUsers]), Integer(ecUserLimit));

    if GetDiskFreeSpaceEx(PChar(ExtractFilePath(ParamStr(0))), FreeAvail, Total, @TotalFree) then begin
      DBFileSize := GetDirectorySize(ExePath + SDirData);
      DBFileSize := Max(2*DBFileSize, 200*1024*1024);
      if DBFileSize > FreeAvail then
        LogExitError(Format( '������������ ���������� ����� �� ����� ��� ������� ����������. ���������� %s.',
        [ FormatByteSize(DBFileSize) ]),
        Integer(ecFreeDiskSpace));
    end
    else
      LogExitError(Format( '�� ������� �������� ���������� ���������� ����� �� �����.' +
        #13#10#13#10'��������� �� ������:'#13#10'%s', [ SysErrorMessage(GetLastError) ]), Integer(ecGetFreeDiskSpace));
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
    AProc.MessageBox( '������ �������� ����������� ���������. ���������� ��������� ���������� ������.',
      MB_ICONERROR or MB_OK);
    DM.MainConnection.Open;
    try
      if (Trim( adtParams.FieldByName( 'HTTPName').AsString) = '') then
        ShowConfig( True );
    finally
      DM.MainConnection.Close;
    end;
  end;
{$ifndef DEBUG}
  FNeedUpdateByCheckHashes := not CheckCriticalLibrary or DownloadAppFilesHelper.ProcessCheckDownload();
  if FNeedUpdateByCheckHashes then
    AProc.MessageBox( '������ �������� ����������� ����������� ���������. ���������� ��������� ���������� ������.',
      MB_ICONERROR or MB_OK);
{$endif}
end;

procedure TDM.CompactDataBase();
begin
  MainConnection.Open;
  try
    DatabaseController.OptimizeObjects(MainConnection);
  finally
    MainConnection.Close;
  end;
end;

//��������� ����� � ������� �� ����� ��� ��������; ���� ������ DataSet, ��
//����������� ���������� ����������� �� ���� � ���������� ������� �� ��������� ������
function TDM.ShowFastReport(FileName: string; DataSet: TDataSet = nil;
  APreview: boolean = False; PrintDlg: boolean = True) : Boolean;
var
  Mark: TBookmarkStr;
  t : Boolean;
begin
  Result := False;
  //������� � ��������� ������ ��� �����; ��������� ����
  FileName:=Trim(FileName);
  if FileName<>'' then begin
    FileName:=ExePath + 'Frf\' + FileName;
    if not FileExists(FileName) then
      raise Exception.Create( '���� �� ������:'+#13+FileName);
    frReport.LoadFromFile(FileName);
  end;
  //������� ����� ������ ��� ��������� ����� ��� ����, ����� ������� ���������
  //������������ �� ���� � �������� ���������� ������ � ��������� �� ������ ������
  if (DataSet<>nil) and DataSet.Active then begin
    Mark:=DataSet.BookMark;
    DataSet.DisableControls;
  end;
  try
    frDBDataSet.DataSet := DataSet;

    FReportPrinted := False;

    if not APreview then begin

      frReport.PrepareReport;

      if PrintDlg then
        frReport.PrintPreparedReportDlg
      else
        frReport.PrintPreparedReport( '', 1, False, frAll);
    end
    else
      frReport.ShowReport;

    Result := FReportPrinted and not frReport.Terminated;
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

  //���� �������� ���������� � �������� ����� ����������, �� ��������� ��������
  //� ����������� ������������
  if GetCurrentThreadId() = MainThreadID then begin
    //��������� PopupMenu ��������
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
    //��������������� ���������� �������
    adtClients.Locate('ClientId', LastClientId, []);
  end;
  ClientChanged;
end;

//���������� � �������� ������� ��������� ������� �� ����� In
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
    DoSetCursor(crHourglass);
    Files := TStringList.Create;
    Tables := TStringList.Create;
    try
        if adcUpdate.Active then
          adcUpdate.Close;
        //������� �������� ������� ������� �� ���������� ������
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
      DoSetCursor(crDefault);
    end;
  end
  else
    FindClose(SR);
end;

//��������� ��� ������������ ������� �������
procedure TDM.UnLinkExternalTables;
{$ifndef DEBUG}
var
  I: Integer;
{$endif}
begin
{$ifndef DEBUG}
  //��������� ������ �� ����� ���������� ��������� (������� tmp) � ������� �� ��� ������
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
  DoSetCursor(crHourglass);
  with adcUpdate do try

    MainForm.StatusText:='��������� MinPrices';
    SQL.Text:='truncate MinPrices;'; Execute;
    MainForm.StatusText:='��������� Core';
    SQL.Text:='truncate Core;'; Execute;
    MainForm.StatusText:='��������� Catalog';
    SQL.Text:='truncate CATALOGS;'; Execute;
    MainForm.StatusText:='��������� CatalogNames';
    SQL.Text:='truncate catalognames;'; Execute;
    MainForm.StatusText:='��������� CatalogFarmGroups';
    SQL.Text:='truncate CATALOGFARMGROUPS;'; Execute;
    MainForm.StatusText:='��������� Products';
    SQL.Text:='truncate Products;'; Execute;
    MainForm.StatusText:='��������� PricesRegionalData';
    SQL.Text:='truncate PricesRegionalData;'; Execute;
    MainForm.StatusText:='��������� PricesData';
    SQL.Text:='truncate PricesData;'; Execute;
    MainForm.StatusText:='��������� RegionalData';
    SQL.Text:='truncate RegionalData;'; Execute;
    MainForm.StatusText:='��������� Providers';
    SQL.Text:='truncate Providers;'; Execute;
    MainForm.StatusText:='��������� Synonym';
    SQL.Text:='truncate Synonyms;'; Execute;
    MainForm.StatusText:='��������� SynonymFirmCr';
    SQL.Text:='truncate SynonymFirmCr;'; Execute;
    MainForm.StatusText:='��������� Rejects';
    SQL.Text:='truncate Rejects;'; Execute;
    MainForm.StatusText:='��������� ���';
    SQL.Text:='truncate MNN;'; Execute;
    MainForm.StatusText:='��������� ��������';
    SQL.Text:='truncate Descriptions;'; Execute;
    MainForm.StatusText:='��������� ����������� ���� ��������������';
    SQL.Text:='truncate maxproducercosts;'; Execute;
    MainForm.StatusText:='��������� ������� ��������������';
    SQL.Text:='truncate producers;'; Execute;
    MainForm.StatusText:='��������� ������� ������������ ������';
    SQL.Text:='truncate minreqrules;'; Execute;
    MainForm.StatusText:='��������� ����� �����������';
    SQL.Text:='truncate SupplierPromotions;'; Execute;
    SQL.Text:='truncate PromotionCatalogs;'; Execute;
    MainForm.StatusText:='��������� ���������� ����������';
    SQL.Text:='truncate Schedules;'; Execute;
    MainForm.StatusText:='��������� ���������� �������� ������������';
    SQL.Text:='truncate CertificateRequests;'; Execute;
    MainForm.StatusText:='��������� �������';
    SQL.Text:='truncate News;'; Execute;
    MainForm.StatusText:='��������� ����� ������ ���� ������';
    SQL.Text:='update params set LastCompact = now() where ID = 0;'; Execute;

  finally
    DoSetCursor(crDefault);
    MainForm.StatusText:='';
  end;
end;

procedure TDM.DeleteEmptyOrders;
begin
  DoSetCursor(crHourglass);
  try
    with adcUpdate do begin
      SqL.Text:='DELETE FROM CurrentOrderLists WHERE OrderCount=0'; Execute;
      SQL.Text:='DELETE FROM CurrentOrderHeads WHERE NOT Exists(SELECT OrderId FROM CurrentOrderLists WHERE OrderId=CurrentOrderHeads.OrderId)'; Execute;
      SqL.Text:='DELETE FROM PostedOrderLists WHERE OrderCount=0'; Execute;
      SQL.Text:='DELETE FROM PostedOrderHeads WHERE NOT Exists(SELECT OrderId FROM PostedOrderLists WHERE OrderId=PostedOrderHeads.OrderId)'; Execute;
    end;
  finally
    DoSetCursor(crDefault);
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
  //��������� ������� � �����������
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


    mainStartupHelper.Write('DModule', '������ �������� �������� ���� ������');
    RunUpdateDBFile(
      dbCon,
      ExePath + SDirData,
      0,
      CheckDBObjectsWithDatabaseController,
      nil,
      '���������� �������� ���� ������. ���������...');
    mainStartupHelper.Write('DModule', '��������� �������� �������� ���� ������');

    mainStartupHelper.Write('DModule', '������ �������� ��������');
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

      if DBVersion = 84 then begin
        if NeedUpdateToNewCryptLibMySqlDAfter1651 then begin
          RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateToNewLibMySqlD1651, nil);
          DBVersion := CURRENT_DB_VERSION;
        end
        else
        if NeedUpdateToNewCryptLibMySqlDOn1711() then begin
          RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateToNewLibMySqlD1711, nil);
          DBVersion := CURRENT_DB_VERSION;
        end
        else begin
          DBVersion := CURRENT_DB_VERSION;
        end;
      end;

      if DBVersion = 85 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 86;
      end;
      
      if DBVersion = 86 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 89;
      end;

      if DBVersion = 89 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 90;
      end;

      if DBVersion = 90 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 91;
      end;

      if DBVersion = 91 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 92;
      end;

      if DBVersion = 92 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 93;
      end;

      if DBVersion = 93 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 94;
      end;

      if DBVersion = 94 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 95;
      end;

      if DBVersion = 95 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 96;
      end;

      if DBVersion = 96 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        UpdateDBFileDataFor96(nil);
        DBVersion := 97;
      end;

      if DBVersion = 97 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 98;
      end;

      if DBVersion = 98 then begin
        RunUpdateDBFile(dbCon, ExePath + SDirData, DBVersion, UpdateDBFile, nil);
        DBVersion := 99;
      end;
    end;

    if DBVersion <> CURRENT_DB_VERSION then
      raise Exception.CreateFmt('������ ���� ������ %d �� ��������� � ����������� ������� %d.', [DBVersion, CURRENT_DB_VERSION]);

    //���� ���� ����������� ���������� ���������, �� ��������� �����
    if FindCmdLineSwitch('i') or FindCmdLineSwitch('si') then begin
      UpdateDBUIN(dbCon);
    end;
    mainStartupHelper.Write('DModule', '��������� �������� ��������');

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
      //������ ����� ���������� ���, ��� �� �������� ��������� �����, �� �� �������� ����
      //���� �� ��� ���������
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
      '������ ��� ���������� �������: %s'#13#10'��������: %s'#13#10'��� ����������: %s'#13#10'SQL: %s',
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
        LogCriticalError(Format('������ ��� �������� (%d): %s', [RecoveryCount, E.Message]));
        if (RecoveryCount < 2) then begin
          try
            //��� ���� ���� ����� �����, �.�. �� ����������� ������������ ����� ��� �������� �����������
            //���� �� ���-�� ������������ �������� ����� ������ 0, �� ���� ����� �� ���������
            if MainConnection is TMyEmbConnection then
              DatabaseController.FreeMySQLLib('MySql Clients Count ��� ��������������');
            mainStartupHelper.Write('DModule', '������ �������������� ���� ������');
            RecoverDatabase(E);
            mainStartupHelper.Write('DModule', '��������� �������������� ���� ������');
          except
            on ErrorOnRestore : Exception do begin
              if (RecoveryCount < 1) then
                LogCriticalError(Format('������ ��� �������������� (%d): %s', [RecoveryCount, ErrorOnRestore.Message]))
              else
                raise;
            end;
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
      LogExitError(Format( '���������� ������� ���� ���� ������: %s '#13#10'���������� � �� �������.', [ E.Message ]), Integer(ecDBFileError));
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
  if NeedUpdateToNewCryptLibMySqlDAfter1651() then
    realDBVersion := '84'
  else
  if NeedUpdateToNewCryptLibMySqlDOn1711() then
    realDBVersion := '84'
  else
    realDBVersion := IntToStr(CURRENT_DB_VERSION);

  Result := DatabaseController.GetFullLastCreateScript(realDBVersion);
end;

procedure TDM.CreateClearDatabaseFromScript(dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
var
  FConnection : TCustomMyConnection;
  MyDump : TMyDump;
begin
  //����� �� ��������� ��������� � �� ����� ������� ���� ������ AnalitF,
  //�� ����������� embedded-��������� (��������� ����������) ������ MyDac � �������� ����� AnalitF,
  //���� �� ����� ���� ��� �� ������� � ������������� ������� �������� ���������.
  //����� ����, ��� �� ��������� ���� ����� (������ ����),
  //������� �������� ���������� ������������� ��� ��� � ���������� ������ 2,
  //����� �������� ������� ���������� �� ����������� �� 1 � ���������� ������ 1.
  //�� MyDac �� ��������� ������� ��� ���� ���������, �.�. ��������� ��������.
  //������� � ������ ���������� ��������� ���� ���������� � ��� ��������,
  //���� ��� ���������� ��������� � ����� ..\AnalitF\Data, � ����� �������� ���� ������ �� AnalitF

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
        mainStartupHelper.Write('DModule.CreateClearDatabase', '������ ������������� �������� ���� ������');
        DatabaseController.Initialize(FConnection);
        mainStartupHelper.Write('DModule.CreateClearDatabase', '��������� ������������� �������� ���� ������');
      end;
    finally
      FConnection.Close;
    end;

  finally
    FConnection.Free;
  end;
  //��� ���� ���� ����� �����, �.�. �� ����������� ������������ ����� ��� �������� �����������
  //���� �� ���-�� ������������ �������� ����� ������ 0, �� ���� ����� �� ���������
  if MainConnection is TMyEmbConnection then
  begin
    DatabaseController.FreeMySQLLib('MySql Clients Count ����� �������� ���� ������');
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
  ����� �� ������ �������:
  1. ������� ����������, ���� �������
  2. ��������� ��� ������ ��� ��������
  3. ������������� � ��������� ���� ������
  4. ����������� �� ��������� ���� ������
  5. ������� ��������� ���� ������
  }
  InternalRestore := False;
  UserErrorMessage := '�� ������� ������� ���� ������ ���������.';
  DBErrorMess := Format('�� ������� ������� ���� ������ ���������.'#13#10 +
    '������        : %s'#13#10,
    [E.Message]
  );
  if (E is EMyError) then
    DBErrorMess := DBErrorMess +
      Format(
        '��� SQL       : %d'#13#10 +
        '���������     : %s'#13#10 +
        'Fatal         : %s',
        [EMyError(E).ErrorCode, EMyError(E).Message, BoolToStr(EMyError(E).IsFatalError)]
    );

  if GetNetworkSettings().IsNetworkVersion then begin
    if (E is EMyError) and (EMyError(E).ErrorCode = ER_BAD_DB_ERROR) then begin
      DBErrorMess := DBErrorMess + #13#10#13#10 + '����� ����������� �������� ���� ������.';
      UserErrorMessage := UserErrorMessage + #13#10 + '����� ����������� �������� ���� ������.';
    end
    else begin
      DBErrorMess := DBErrorMess + #13#10#13#10 + '����� ����������� �������������� �� ��������� �����.';
      UserErrorMessage := UserErrorMessage + #13#10 + '����� ����������� �������������� �� ��������� �����.';
      InternalRestore := True;
    end;
  end
  else begin
    if not DirectoryExists(ExePath + SDirDataPrev) then begin
      DBErrorMess := DBErrorMess + #13#10#13#10 + '����� ����������� �������� ���� ������.';
      UserErrorMessage := UserErrorMessage + #13#10 + '����� ����������� �������� ���� ������.';
    end
    else begin
      DBErrorMess := DBErrorMess + #13#10#13#10 + '����� ����������� �������������� �� ��������� �����.';
      UserErrorMessage := UserErrorMessage + #13#10 + '����� ����������� �������������� �� ��������� �����.';
      InternalRestore := True;
    end;
  end;

  //�������� ���� �������� � ���������� ������������
  AProc.LogCriticalError(DBErrorMess);

  //���� ��� ���������� �����, �� ������� ���� �������
  if not InternalRestore then begin
    RunUpdateDBFile(nil, ExePath + SDirData, CURRENT_DB_VERSION, CreateClearDatabaseFromScript, nil, '���������� �������� ���� ������. ���������...');
    FCreateClearDatabase := True;
    FNeedImportAfterRecovery := False;
    WriteExchangeLog('AnalitF', '����������� �������� ����.');
  end
  else
    try
      RunUpdateDBFile(nil, ExePath + SDirData, CURRENT_DB_VERSION, RestoreDatabaseFromPrevios, nil, '���������� �������������� ���� ������ �� ���������� �����. ���������...');
      //������ ������������ �� ���������� �����
      FNeedImportAfterRecovery := True;
      WriteExchangeLog('AnalitF', '����������� ����������� �� ���������� �����.');
    except
      on E : Exception do
        raise Exception.CreateFmt(
        '�� ������� ����������� �� ���������� ����� : %s', [E.Message]);
    end;
end;

procedure TDM.ProcessDocs(ImportDocs : Boolean);
var
  //������� ������ ���������� � �������
  OnlyDirOpen : Boolean;
  MaxFileDate : TDateTime;
  DocsFL,
  WaybillsFL,
  RejectsFL : TStringList;
begin
{
  1. ���� � ������� ��� �����, �� ��������� ������ �����
  2. ���� �� �����, ��� �������� ������������ ���� �����
  3. ��������� ������� � ������� � ������� ������, �������� �������� � ������
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
      ProcessWaybillsDir(SDirWaybills, MaxFileDate, WaybillsFL);
      ProcessDocsDir(SDirRejects, MaxFileDate, RejectsFL);

      if ImportDocs then begin
        DatabaseController.BackupDataTable(doiDocumentHeaders);
        DatabaseController.BackupDataTable(doiDocumentBodies);
        DatabaseController.BackupDataTable(doiInvoiceHeaders);
      end;

      //���� ��������� ���-�� ����������� ������ ������ 5, �� ��������� ������ �����
      if not OnlyDirOpen then
        OnlyDirOpen :=
          (
            IfThen(not ImportDocs and adtParams.FieldByName('USEOSOPENWAYBILL').AsBoolean, WaybillsFL.Count, 0)
            + IfThen(adtParams.FieldByName('USEOSOPENREJECT').AsBoolean, RejectsFL.Count, 0)
          ) > 5;

      //OpenDocsDir(SDirDocs, DocsFL, not OnlyDirOpen);
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
      if FindFirst( RootFolder() + DirName + '\*.*', faAnyFile - faDirectory, DocsSR) = 0 then
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
  // ���������� ��������� HTTP-�������
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
  SetHTTP.ReadTimeout := 0; // ��� ����-����
  SetHTTP.ConnectTimeout := -2; // ��� ����-����
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
      //���� ��� ���� ������, �� ������ �� ������, �����������, ��� ���� ������
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
        raise Exception.Create('��� ����������� ����������.');
      if Length(oldDBUIN) = 0 then
        raise Exception.Create('��� ����������� ���������� 2.');
      if oldDBUIN <> IntToHex(GetOldDBID(), 8) then
        raise Exception.Create('�� ��������� DBUIN � ����������� ���� ������.');

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

      //��������� �������� CDS � ���� � ����� CopyID
      dbCon.ExecSQL('update analitf.params set CDS = :CDS where ID = 0', [newCDS]);

    finally
      try dbCon.Close(); except end;
    end;

    DatabaseController.BackupDataTables();
  except
    on E : Exception do begin
      AProc.LogCriticalError('������ ��� ���������� UIN : ' + E.Message);
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

function TDM.ShowOrderDetailsReport(OrderId: Integer; Closed, Send,
  Preview, PrintDlg: Boolean) : Boolean;
begin
  Result := False;
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


  //�������� ���������� � ������� ������������ �������
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
        //������� ������
        frVariables[ 'DisplayOrderId'] := adsPrintOrderHeader.FieldByName('DisplayOrderId').AsVariant;
        frVariables[ 'DatePrice'] := adsPrintOrderHeader.FieldByName('DatePrice').AsVariant;
        frVariables[ 'OrdersComments'] := adsPrintOrderHeader.FieldByName('Comments').AsString;
        frVariables[ 'SupportPhone'] := adsPrintOrderHeader.FieldByName('SupportPhone').AsString;
        frVariables[ 'OrderDate'] := adsPrintOrderHeader.FieldByName('OrderDate').AsVariant;
        frVariables[ 'PriceName'] := adsPrintOrderHeader.FieldByName('PriceName').AsString;
        frVariables[ 'Closed'] := adsPrintOrderHeader.FieldByName('Closed').AsBoolean;

        Result := DM.ShowFastReport( 'Orders.frf', nil, Preview, PrintDlg);

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
      raise Exception.CreateFmt('C��������� ���������� %s, ���� ���� �� ������.', [ExePath + SDirData + '\analitf']);

    //������� ������� ���� ��� ��������������� ����� "analitf" � "mysql"
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
          WriteExchangeLog('DBtest.TestOpenDatabase', '�������� ������ �� ������������� ���� ������' )
        else
          raise;
    end;

    //������� ������� ���� ��� ��������������� ����� analitf
{
    CreateDir(ExePath + SDirData);
    try
      FEmbConnection.Open;
    except
      on E : Exception do
        if (E is EMyError) and (not EMyError(E).IsFatalError) and (EMyError(E).ErrorCode = 1049)
        then
          WriteExchangeLog('DBtest.TestOpenDatabase', '�������� ������ �� ������������� ���� ������' )
        else
          raise;
    end;
}    

    //������� ������� ������ �� ������� params ��� ������ ���� ������ analitf
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
          WriteExchangeLog('DBtest.TestOpenDatabase', '�������� ������ �� ������������� �������' )
        else
          raise;
    end;

    //������� �������� �������
    FEmbConnection.Open;
    try
      FEmbConnection.ExecSQL('use analitf', []);
      FEmbConnection.ExecSQL('create table TestTable(id int, namecolumn varchar(255))', []);
    finally
      FEmbConnection.Close;
    end;

    //�������� ������� �� information_schema
    FEmbConnection.Open;
    try
      FEmbConnection.ExecSQL('use analitf', []);
      FEmbConnection.ExecSQL('select * from information_schema.tables', []);
    finally
      FEmbConnection.Close;
    end;

    //������� ��������������� ��, ������� �� ����������
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
          WriteExchangeLog('DBtest.TestOpenDatabase', '�������� ������ �� ������������� ������� mysql.proc ��-�� ���� ������ ������������ ��')
        else
          raise;
    end;

    //������� ������� ��, ��� �������������� ���� mysql
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
          WriteExchangeLog('DBtest.TestOpenDatabase', '�������� ������ �� ������������� ������� mysql.proc  ��-�� ���� ������ ������� ��')
        else
          raise;
    end;

    //������� ��� ���� ������, ����� Embedded-������ �������� �����
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
      //����� ���� ������� �� ����
      //FEmbConnection.RemoveFromPool;
    end;

    //������� ����������
    DeleteDataDir(ExePath + SDirData);

    //�������� ������� ��
    CreateDir(ExePath + SDirData + '\analitf');
    FEmbConnection.Open;
    try
      FEmbConnection.ExecSQL('use analitf', []);
      FEmbConnection.ExecSQL('create FUNCTION analitf.x_cast_to_tinyint(number BIGINT) RETURNS tinyint(1) BEGIN return number;END', []);
    finally
      FEmbConnection.Close;
    end;

    //�������� ������� � ������� ��������� ��
    FEmbConnection.Open;
    try
      FEmbConnection.ExecSQL('use analitf', []);
      FEmbConnection.ExecSQL('select analitf.x_cast_to_tinyint(323232323)', []);
    finally
      FEmbConnection.Close;
    end;

    //���������� ��� � �������� ���������
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
      //����� ���� ������� �� ����
      //FEmbConnection.RemoveFromPool;
    end;


    //������� ����������
    DeleteDataDir(ExePath + SDirData);

    //��������� ������, ������� ��������� ����� ������
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
    raise Exception.Create('���������� � Backup �� ����������')
  else
    DeleteDirectory(ExePath + SDirDataBackup);
  CopyDataDirToBackup(ExePath + SDirData, ExePath + SDirDataBackup);

  MoveDirectories(ExePath + SDirDataBackup, ExePath + SDirData);
  if DirectoryExists(ExePath + SDirDataBackup) then
    raise Exception.Create('���������� � Backup ����������');
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
        mainStartupHelper.Write('DModule.RestoreDatabaseFromPrevios', '������ ������������� �������� ���� ������');
        DatabaseController.Initialize(FConnection);
        mainStartupHelper.Write('DModule.RestoreDatabaseFromPrevios', '��������� ������������� �������� ���� ������');
      end;
    finally
      FConnection.Close;
    end;

  finally
    FConnection.Free;
  end;
  //��� ���� ���� ����� �����, �.�. �� ����������� ������������ ����� ��� �������� �����������
  //���� �� ���-�� ������������ �������� ����� ������ 0, �� ���� ����� �� ���������
  if MainConnection is TMyEmbConnection then
    DatabaseController.FreeMySQLLib('MySql Clients Count ����� �������������� ���� ������');

  DatabaseController.RepairTableFromBackup();
end;

procedure TDM.InternalCloseMySqlDB;
begin
  if MainConnection.Connected then
    MainConnection.Disconnect;
  if (MainConnection is TMyEmbConnection)
  then
    DatabaseController.FreeMySQLLib('MySql Clients Count ��� �������� ���������');
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
  //���������, ��� Id ������ ����������, � �� ��� ������,
  //�������� ��-�� ����, ��� � ��� �� �������� �������
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

  //��������� ��, ��� ���� ��������� ������
  //���� ��� ���, �� �������
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
    //������ �� ���������� - ������� ���
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
  ��������, ��� ������� ���������� ������� ������� � ������� �������
  �� ������� �����-�����
  ������� ����� ���� ��������� � ��������������� ������, �.�. � MyIsam
  �� ���������� �������� ����������� � ����� ����� ���� ������,
  � ������� ����� ��������.
  ���� ����� �� ������� ����� ������� � ������� ��.
  }
  if not orderDataSet.FieldByName('ORDERSORDERID').IsNull then begin
    OldOrderIdFromListVariant := orderDataSet.FieldByName('ORDERSORDERID').Value;
    //���� ID ������� �� �����, �� ������� ������� �� ����� ������
    if OldOrderIdFromListVariant <> OrderIdVariant then
    begin
      DM.MainConnection.ExecSQL('delete from CurrentOrderLists where OrderId = :OrderId', [orderDataSet.FieldByName('ORDERSORDERID').Value]);
      orderDataSet.FieldByName('ORDERSORDERID').Clear;
    end
  end;

  {
    ���������, ��� ���� ������� � CurrentOrderLists � ������ OrderId � CoreId
    ���� ������� ���, �� ���������� �������� ORDERSORDERID � null
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
  ������� ���������� ������� � OrdersList �� ������� ������, ���� �� �� ����������
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
+'              ProducerCost     , NDS          , RetailVitallyImportant,  '
+'              EAN13            , CodeOKP      , Series,  Exp  '
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
+'              c.ProducerCost     , c.NDS          , c.RetailVitallyImportant,  '
+'              c.EAN13            , c.CodeOKP      , c.Series, c.Exp  '
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
    DBProc.UpdateValue(
      DM.MainConnection,
      'delete from awaitedproducts using awaitedproducts, core, products '
      + 'where core.CoreId = :CoreId '
      + ' and Products.ProductId = core.ProductId '
      + ' and awaitedproducts.CatalogId = products.CatalogId '
      + ' and core.CodeFirmCr is not null '
      + ' and awaitedproducts.ProducerId is not null '
      + ' and awaitedproducts.ProducerId = core.CodeFirmCr; '
      + 'delete from awaitedproducts using awaitedproducts, core, products '
      + 'where core.CoreId = :CoreId '
      + ' and Products.ProductId = core.ProductId '
      + ' and awaitedproducts.CatalogId = products.CatalogId '
      + ' and awaitedproducts.ProducerId is null; '
      ,
      ['CoreId'],
      [orderDataSet.FieldByName('Coreid').Value]);
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
                '������: %s (%s)  ���������: %s (%s)  �������: %s',
                [adsQueryValue.FieldByName('Name').Value,
                 adsQueryValue.FieldByName('ClientId').Value,
                 adsQueryValue.FieldByName('FullName').Value,
                 adsQueryValue.FieldByName('FirmCode').Value,
                 '��� ������ � ������� ��������, ���� �������� �������� �������']))
          else
            if    not adsQueryValue.FieldByName('DelayFirmCode').IsNull
              and adsQueryValue.FieldByName('Percent').IsNull
            then
              ErrorMessage.Add(
                Format(
                  '������: %s (%d)  ���������: %s (%d)  �������: %s',
                  [adsQueryValue.FieldByName('Name').Value,
                   adsQueryValue.FieldByName('ClientId').Value,
                   adsQueryValue.FieldByName('FullName').Value,
                   adsQueryValue.FieldByName('FirmCode').Value,
                   '�� ����������� �������� (null), ����  ������ � ������� �������� ����']));
          adsQueryValue.Next;
        end;
        ErrorMessage.Insert(
          0,
          '��������� ����������� ������ � ������� �������� �� ��������� �������:');
        WriteExchangeLog('Exchange', ErrorMessage.Text);
      finally
        ErrorMessage.Free;
      end;
    end;
  finally
    adsQueryValue.Close;
  end;
}

  //��������� �������� �� ���� ��������� ������������ � ��������,
  //� ������� ��� ������� � DelayOfPayments
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

  //��������� �������� Percent: ���� �������� �� �������, �� null,
  //����� ������ ���� ��������, ���� ��� �� �����������, �� 0.0
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
    raise EDelayOfPaymentsDataIntegrityException.Create('��������� ����������� � ���������');
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
  + '  CurrentOrderHeads '
  + 'set '
  + '  CurrentOrderHeads.ErrorReason = null '
  + 'where '
  + '     CurrentOrderHeads.Frozen = 1 ';
  if ClientId > 0 then
    Result := Result
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
      mainStartupHelper.Write('DModule', '������ ������������� �������� ���� ������');
      DatabaseController.Initialize(dbCon);
      mainStartupHelper.Write('DModule', '��������� ������������� �������� ���� ������');
    end;

    //��������� ������� ���� �� ���������� ���������� ���������
    if not FindCmdLineSwitch('i') and not FindCmdLineSwitch('si') then begin
      mainStartupHelper.Write('DModule', '������ �������� �� ������������� �������� ���� ������');
      DatabaseController.CheckObjectsExists(
        dbCon,
        FCreateClearDatabase or FNeedImportAfterRecovery,
        CheckedObjectOnStartup,
        True);
      mainStartupHelper.Write('DModule', '��������� �������� �� ������������� �������� ���� ������');
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
      LogCriticalError('������ ��� �������� ���������� ���������� mysql: ' + E.Message);
      LogExitError(
        '���������� ������� ���������� ���������� mysql.'#13#10
        + '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.',
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
      raise Exception.Create('���������� libmysqld.dll ����������.');
    calchash := GetFileHash(ExePath + LibraryFileNameStart + LibraryFileNameEnd);
    if AnsiCompareText(calchash, 'AAA797481BD06F75C8C94F513F09EA0D') <> 0 then
      raise Exception.Create('���������� ��������� ���������� libmysqld.dll.');
  except
    on E : Exception do begin
      LogExitError(
        E.Message + #13#10
          + '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.',
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
      LogCriticalError('������ ��� �������� ���������� ���������� ��� ���������� 800-x ������: ' + E.Message);
      LogExitError(
        '���������� ������� ���������� ����������.'#13#10
        + '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.',
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
  
  DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� � 800-�');
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
          AProc.LogCriticalError('������ ��� �������� ������ ���� ������ : ' + OpenException.Message);
          raise Exception.Create('�� ���������� ������� ������ ���� ������');
        end;
      end;

      try
        try
          ExportFrom800xToFiles(oldMySqlDB, PathToBackup, MySqlPathToBackup);
        except
          on UpdateException : Exception do begin
            AProc.LogCriticalError('������ ��� �������� ������ : ' + UpdateException.Message);
            raise Exception.Create(
              '��� ����������� ������ �� ������ ���� � ����� �������� ������.' +
              #13#10 +
              '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.');
          end;
        end;
      finally
        oldMySqlDB.Close;
      end;
    finally
      oldMySqlDB.Free;
    end;

    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� � 800-�');
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
          AProc.LogCriticalError('������ ��� �������� ������ : ' + UpdateException.Message);
          raise Exception.Create(
            '��� ����������� ������ �� ������ ���� � ����� �������� ������.' +
            #13#10 +
            '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.');
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
          AProc.LogCriticalError('������ ��� �������� ������ (800-�) ���� ������ : ' + E.Message);
      end;
  finally
    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� � 800-� (�������)');
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
            '�� ���������� ���� ��� �������� �������: %s',
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
      LogCriticalError('������ ��� �������� ���������� ���������� ��� ���������� �� ����� libd: ' + E.Message);
      LogExitError(
        '���������� ������� ���������� ����������.'#13#10
        + '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.',
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
    '������ ��� �������� ������� ' + exportObject + ': ' + ExportException.Message);
    if FileExists(PathToBackup + exportObject + '.txt')
      and (GetFileSize(PathToBackup + exportObject + '.txt') = 0)
    then
      try
        OSDeleteFile(PathToBackup + exportObject + '.txt');
      except
        on DeleteFile : Exception do
          WriteExchangeLog('Exchange.ExportFromOldLibMysqlDToFiles',
          '������ ��� �������� ����� ' + exportObject + ': ' + DeleteFile.Message);
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
            '������ ��� �������� ������� ' + exportTable.Name + ': ' + E.Message);
            if FileExists(PathToBackup + exportTable.Name + '.txt')
              and (GetFileSize(PathToBackup + exportTable.Name + '.txt') = 0)
            then
              try
                OSDeleteFile(PathToBackup + exportTable.Name + '.txt');
              except
                on DeleteFile : Exception do
                  WriteExchangeLog('Exchange.ExportFromOldLibMysqlDToFiles',
                  '������ ��� �������� ����� ' + exportTable.Name + ': ' + DeleteFile.Message);
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
              '������ ��� ������� ������� ' + importTable.Name + ': ' + ImportException.Message);
            end;
          end;

          try
            OSDeleteFile(PathToBackup + importTable.Name + '.txt', False);
          except
            on DeleteFile : Exception do
              WriteExchangeLog('Exchange.ImportOldLibMysqlDFilesToMySql',
              '������ ��� �������� ����� ' + importTable.Name + ': ' + DeleteFile.Message);
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

  DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd');
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
          AProc.LogCriticalError('������ ��� �������� ������ ���� ������ : ' + OpenException.Message);
          raise Exception.Create('�� ���������� ������� ������ ���� ������');
        end;
      end;

      try
        try
          ExportFromOldLibMysqlDToFiles(oldMySqlDB, PathToBackup, MySqlPathToBackup);
        except
          on UpdateException : Exception do begin
            AProc.LogCriticalError('������ ��� �������� ������ : ' + UpdateException.Message);
            raise Exception.Create(
              '��� ����������� ������ �� ������ ���� � ����� �������� ������.' +
              #13#10 +
              '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.');
          end;
        end;
      finally
        oldMySqlDB.Close;
      end;
    finally
      oldMySqlDB.Free;
    end;

    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd');
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
          AProc.LogCriticalError('������ ��� �������� ������ : ' + UpdateException.Message);
          raise Exception.Create(
            '��� ����������� ������ �� ������ ���� � ����� �������� ������.' +
            #13#10 +
            '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.');
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
          AProc.LogCriticalError('������ ��� �������� ������ (libd) ���� ������ : ' + E.Message);
      end;
  finally
    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd (�������)');
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
    WriteExchangeLog('UpdateMarkups', '������ �������� �������');
    adcCommand.Close;
    adcCommand.SQL.Text :=
      'select LeftLimit, RightLimit, Markup, MaxMarkup, MaxSupplierMarkup from analitf.' + TableName + ' order by LeftLimit';
    adcCommand.Open;
    try
      Markups.Clear;
      adcCommand.First;
      while not adcCommand.Eof do begin
        WriteExchangeLog('UpdateMarkups',
         Format('�������: LeftLimit %s  RightLimit %s  Markup %s  MaxMarkup %s',
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
      WriteExchangeLog('UpdateMarkups', '��������� �������� �������');
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
        '���������� ������� ���� ������. ���������...');
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
          '���������� ������ ���� ������. ���������...');
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
    AProc.MessageBox('�����, ������������� �� ����������, ������ ������� ���������� ���������� ������ ��� �� �����.', MB_ICONWARNING or MB_OK)
  else
    if (currentTime < updateTime - 30) then begin
      FDisableAllExchange := True;
      MainForm.DisableByHTTPName;
      MainForm.actReceive.Enabled := False;
      MainForm.actReceiveAll.Enabled := False;
      AProc.MessageBox('�����, ������������� �� ����������, ������ ������� ���������� ���������� ������ ��� �����.', MB_ICONERROR or MB_OK)
    end;
end;

function TDM.ShowFastReportWithSave(FileName: string; DataSet: TDataSet;
  APreview, PrintDlg: boolean) : Boolean;
var
  oldButtons : TfrPreviewButtons;
begin
  oldButtons := frReport.PreviewButtons;
  try
    frReport.PreviewButtons := frReport.PreviewButtons + [pbSave];
    Result := ShowFastReport(FileName, DataSet, APreview, PrintDlg);
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

    //���� c����� ��������������� ���� � ���� "CalculateWithNDS" �������, �� ��������� = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      vitallyNDSMultiplier := 1
    else
      vitallyNDSMultiplier := (1 + vitallyNDS/100);

    //����
    if (DM.adtClientsMethodOfTaxation.Value = 0) then begin

      Result := SupplierCost + ProducerCost*vitallyNDSMultiplier*(markup/100);

    end
    else begin

    //���
      Result := SupplierCost + ProducerCost*vitallyNDSMultiplier*(markup/100);

    end;
  end
  else begin

    if VarIsNull(NDS) then
      nonVitallyNDS := 0
    else
      nonVitallyNDS := NDS;

    //���� c����� ��������������� ���� � ���� "CalculateWithNDSForOther" �������, �� ��������� = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDSForOther.Value then
      nonVitallyNDSMultiplier := 1
    else
      nonVitallyNDSMultiplier := (1 + nonVitallyNDS/100);

    //�� ���� �������������
    if DM.adsUser.FieldByName('CalculateOnProducerCost').AsBoolean then begin

      Result := SupplierCost + ProducerCost*nonVitallyNDSMultiplier*(markup/100);

    end
    else begin

    //�� ���� ���������� ��� ���
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

  DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd');
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
          AProc.LogCriticalError('������ ��� �������� ������ ���� ������ : ' + OpenException.Message);
          raise Exception.Create('�� ���������� ������� ������ ���� ������');
        end;
      end;

      try
        try
          ExportGlobalParamsFromOldLibMysqlDToFile(oldMySqlDB, PathToBackup, MySqlPathToBackup);
          WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', '���� ����� ��������');
          Sleep(5000);
        except
          on UpdateException : Exception do begin
            AProc.LogCriticalError('������ ��� �������� ������ : ' + UpdateException.Message);
            raise Exception.Create(
              '��� ����������� ������ �� ������ ���� � ����� �������� ������.' +
              #13#10 +
              '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.');
          end;
        end;
      finally
        oldMySqlDB.Close;
        WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', '���� ����� �������� ����������');
        Sleep(5000);
      end;
    finally
      oldMySqlDB.Free;
      WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', '���� ����� �������� ����������');
      Sleep(5000);
    end;

    WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', '����������� ������ libd');
    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd');
//    WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', '���������� ������ libd � ����');
{$ifdef USEMEMORYCRYPTDLL}
    WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', '������������� �� ����� libd');
    DatabaseController.SwitchMemoryLib();
    //WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', '������������� �� ����� libd � ����');
    //Sleep(5000);
{$endif}

    WriteExchangeLog('UpdateToNewLibMySqlDWithGlobalParams', '�������� �������� ��������� ���� ������');
    UpdateDBFile(dbCon, DBDirectoryName, OldDBVersion, AOnUpdateDBFileData);

    dbCon.Open;
    try
      try
        ImportOldLibMysqlDGlobalParamsFileToMySql(dbCon, PathToBackup, MySqlPathToBackup);
      except
        on UpdateException : Exception do begin
          AProc.LogCriticalError('������ ��� �������� ������ : ' + UpdateException.Message);
          raise Exception.Create(
            '��� ����������� ������ �� ������ ���� � ����� �������� ������.' +
            #13#10 +
            '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.');
        end;
      end;
    finally
      dbCon.Close;
    end;

  finally
    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd (�������)');
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
            '������ ��� �������� ������� ' + exportTable.Name + ': ' + E.Message);
            if FileExists(PathToBackup + exportTable.Name + '.txt')
              and (GetFileSize(PathToBackup + exportTable.Name + '.txt') = 0)
            then
              try
                OSDeleteFile(PathToBackup + exportTable.Name + '.txt');
              except
                on DeleteFile : Exception do
                  WriteExchangeLog('Exchange.ExportGlobalParamsFromOldLibMysqlDToFile',
                  '������ ��� �������� ����� ' + exportTable.Name + ': ' + DeleteFile.Message);
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
              '������ ��� ������� ������� ' + importTable.Name + ': ' + ImportException.Message);
            end;
          end;

          try
            OSDeleteFile(PathToBackup + importTable.Name + '.txt', False);
          except
            on DeleteFile : Exception do
              WriteExchangeLog('Exchange.ImportOldLibMysqlDGlobalParamsFileToMySql',
              '������ ��� �������� ����� ' + importTable.Name + ': ' + DeleteFile.Message);
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
    raise Exception.Create('QueryValue: ���-�� ���������� �� ��������� �� ������� ��������.');

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
  SupplierCost: Currency; individualMarkup : Variant): Currency;
var
  markup : Currency;
begin
  if VarIsNull(individualMarkup) then
    markup := GetRetailMarkupValue(VitallyImportant, SupplierCost, individualMarkup)
  else
    markup := individualMarkup;
  Result := GetPriceRetByMarkup(
    SupplierCost,
    markup);
end;

function TDM.GetRetailMarkupValue(VitallyImportant: Boolean;
  SupplierCost: Currency; individualMarkup : Variant): Currency;
begin
  if not VarIsNull(individualMarkup) then
    Result := individualMarkup
  else
  if VitallyImportant then
    Result := GetVitallyImportantMarkup(SupplierCost)
  else
    Result := GetRetUpCost(SupplierCost);
end;

procedure TDM.CheckNewNetworkVersion;
var
  CurrentBuild,
  NewBuild : Word;
begin
  if SysUtils.DirectoryExists( RootFolder() + SDirNetworkUpdate) and
    FileExists(RootFolder() + SDirNetworkUpdate + '\AnalitF.exe')
  then begin
    CurrentBuild := GetBuildNumberLibraryVersionFromPath(ExePath + ExeName);
    NewBuild := GetBuildNumberLibraryVersionFromPath(RootFolder() + SDirNetworkUpdate + '\AnalitF.exe');

    if NewBuild > CurrentBuild then begin
      DeleteDirectory(ExePath + SDirNetworkUpdate);
      CopyDirectories(RootFolder() + SDirNetworkUpdate, ExePath + SDirNetworkUpdate);

      AProc.MessageBox('�������� ����� ������ ���������. ������ ����� ��������� ����������', MB_OK or MB_ICONWARNING);

      ShellExecute( 0, nil, 'rundll32.exe', PChar( ' '  + ExtractShortPathName(ExePath) + 'Eraser.dll,Erase ' + '-no ' + IntToStr(GetCurrentProcessId) + ' "' +
        ExePath + ExeName + '" "' + ExePath + SDirNetworkUpdate + '"'),
        nil, SW_SHOWNORMAL);

      ExitProcess(1);
    end;
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

function TDM.NeedShowCertificatesResults: Boolean;
var
  updateRecord : Integer;
  openedFiles : Integer;
begin
  updateRecord := DBProc.UpdateValue(
    MainConnection,
    'update CertificateRequests, DocumentBodies ' +
    'set DocumentBodies.RequestCertificate = 0, DocumentBodies.CertificateId = CertificateRequests.CertificateId ' +
    'where DocumentBodies.ServerId = CertificateRequests.DocumentBodyId and CertificateRequests.CertificateId is not null',
    [],
    []);

  if updateRecord > 0 then begin
    openedFiles := 0;
    adsQueryValue.Close;
    adsQueryValue.SQL.Text := 'select CertificateId from CertificateRequests where CertificateId is not null';
    adsQueryValue.Open;
    try
      while not adsQueryValue.Eof do begin
        openedFiles := openedFiles + OpenCertificateFiles(TLargeintField(adsQueryValue.FieldByName('CertificateId')).Value);
        adsQueryValue.Next;

        if (openedFiles >= 10) and not adsQueryValue.Eof then begin
          AProc.MessageBox(
            Format('������������� ������� ������ %d ������ ������������.'#13#10'��������� ����������� ����� ������� �� ���������.', [openedFiles]),
            MB_ICONINFORMATION);
          Break;
        end;
      end;
    finally
      adsQueryValue.Close;
    end;
  end;

  updateRecord := DBProc.UpdateValue(
    MainConnection,
    'update CertificateRequests, DocumentBodies ' +
    'set DocumentBodies.RequestCertificate = 0 ' +
    'where DocumentBodies.ServerId = CertificateRequests.DocumentBodyId and CertificateRequests.CertificateId is null',
    [],
    []);
  Result := updateRecord > 0;
end;

function TDM.OpenCertificateFiles(certificateId: Int64) : Integer;
var
  id : Int64;
  fileName : String;
begin
  Result := 0;

  adcUpdate.Close;
  adcUpdate.SQL.Text := '' +
    'select cf.Id, cf.OriginFilename, cf.ExternalFileId, cf.CertificateSourceId, cf.Extension from ' +
    ' CertificateFiles cf ' +
    ' inner join FileCertificates fc on fc.CertificateFileId = cf.Id ' +
    ' where fc.CertificateId = :CertificateId ' +
    ' group by cf.Id ';
  adcUpdate.ParamByName('CertificateId').Value := certificateId;
  adcUpdate.Open;
  try
    while not adcUpdate.Eof do begin
      id := TLargeintField(adcUpdate.FieldByName('Id')).Value;
      fileName := RootFolder() + SDirCertificates + '\' + IntToStr(id) + adcUpdate.FieldByName('Extension').AsString;
      if (FileExists(fileName)) then begin
        FileExecute(fileName);
        Sleep(750);
        Inc(Result); 
      end;
      adcUpdate.Next;
    end;
  finally
    adcUpdate.Close;
  end;
end;

function TDM.ShowCertificatesResults: String;
var
  sl : TStringList;
begin
  sl := TStringList.Create();
  try
  
    adcUpdate.Close;
    adcUpdate.SQL.Text := '' +
' select ' +
'  Providers.ShortName, ' +
'  DocumentBodies.SerialNumber, ' +
'  DocumentBodies.Product ' +
' from ' +
' CertificateRequests, DocumentBodies, DocumentHeaders, Providers ' +
' where ' +
'  DocumentBodies.ServerId = CertificateRequests.DocumentBodyId ' +
' and CertificateRequests.CertificateId is null ' +
' and DocumentHeaders.Id = DocumentBodies.DocumentId ' +
' and Providers.FirmCode = DocumentHeaders.FirmCode;';
    adcUpdate.Open;
    try
      while not adcUpdate.Eof do begin
        sl.Add(adcUpdate.FieldByName('ShortName').AsString + ' - ' + adcUpdate.FieldByName('SerialNumber').AsString + ' - ' + adcUpdate.FieldByName('Product').AsString);
        adcUpdate.Next;
      end;
    finally
      adcUpdate.Close;
    end;

    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

{
var
  r : HRESULT;
  bR : Boolean;
  d : String;
}

function TDM.NeedUpdateToNewCryptLibMySqlD: Boolean;
var
  buildNumber : Word;
begin
  if FindCmdLineSwitch('i')
    and FileExists(ExePath + SBackDir + '\' + ExeName + '.bak')
  then
  begin
    buildNumber := GetBuildNumberLibraryVersionFromPath(ExePath + SBackDir + '\' + ExeName + '.bak');
    Result := (buildNumber = 1567);
  end
  else
    Result := False;
end;

procedure TDM.PrepareUpdateToNewCryptLibMySqlD;
var
  DocsSR: TSearchRec;
begin
  try
    if not DirectoryExists(ExePath + 'Frf') then
      SysUtils.ForceDirectories(ExePath + 'Frf');

    try
      if FindFirst( ExePath+ '*.frf', faAnyFile - faDirectory, DocsSR) = 0 then
        repeat
          if (DocsSR.Name <> '.') and (DocsSR.Name <> '..')
          then begin
            try
              OSCopyFile(ExePath + DocsSR.Name, ExePath + SBackDir + '\' + DocsSR.Name + '.bak');
              OSMoveFile(ExePath + DocsSR.Name, ExePath + 'Frf' + '\' + DocsSR.Name);
            except
              on E : Exception do
                WriteExchangeLog('PrepareUpdateToNewCryptLibMySqlD', '������: ' + E.Message);
            end;
          end;
        until (FindNext( DocsSR ) <> 0)
    finally
      SysUtils.FindClose( DocsSR );
    end;
  except
    on E : Exception do begin
      LogCriticalError('������ ��� ����������� �������� �������: ' + E.Message);
      LogExitError(
        '���������� ����������� ������� �������.'#13#10
        + '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.',
        Integer(ecDeleteOldMysqlFolder));
    end
  end;
end;

procedure TDM.ExportFromOldLibMysqlDToFiles1651(
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
            WriteExchangeLog('Exchange.ExportFromOldLibMysqlDToFiles1651',
            '������ ��� �������� ������� ' + exportTable.Name + ': ' + E.Message);
            if FileExists(PathToBackup + exportTable.Name + '.txt')
              and (GetFileSize(PathToBackup + exportTable.Name + '.txt') = 0)
            then
              try
                OSDeleteFile(PathToBackup + exportTable.Name + '.txt');
              except
                on DeleteFile : Exception do
                  WriteExchangeLog('Exchange.ExportFromOldLibMysqlDToFiles1651',
                  '������ ��� �������� ����� ' + exportTable.Name + ': ' + DeleteFile.Message);
              end;
          end;
        end;
      end;

  finally
    selectMySql.Free();
  end;
end;

procedure TDM.ImportOldLibMysqlDFilesToMySql1651(
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
              WriteExchangeLog('Exchange.ImportOldLibMysqlDFilesToMySql1651',
              '������ ��� ������� ������� ' + importTable.Name + ': ' + ImportException.Message);
            end;
          end;

          try
            OSDeleteFile(PathToBackup + importTable.Name + '.txt', False);
          except
            on DeleteFile : Exception do
              WriteExchangeLog('Exchange.ImportOldLibMysqlDFilesToMySql1651',
              '������ ��� �������� ����� ' + importTable.Name + ': ' + DeleteFile.Message);
          end;
        end
        else
          FNotImportedWithUpdateToNewLibMysql :=
            FNotImportedWithUpdateToNewLibMysql + [importTable.ObjectId];
      end;

    selectMySql.SQL.Text :=
      'update analitf.clientsettings set CalculateWithNDSForOther = CalculateWithNDS;';
    selectMySql.Execute;
    selectMySql.SQL.Text :=
      'update analitf.params set ' +
        'ProviderMDBVersion = ' + IntToStr(CURRENT_DB_VERSION) + ' ' +
        ' where Id = 0';
    selectMySql.Execute;
  finally
    selectMySql.Free;
  end;
end;

procedure TDM.UpdateToNewLibMySqlD1651(dbCon: TCustomMyConnection;
  DBDirectoryName: String; OldDBVersion: Integer;
  AOnUpdateDBFileData: TOnUpdateDBFileData);
var
  oldMySqlDB : TMyEmbConnection;
  PathToBackup,
  MySqlPathToBackup : String;
begin
  PathToBackup := ExePath + SDirTableBackup + '\';
  MySqlPathToBackup := StringReplace(PathToBackup, '\', '/', [rfReplaceAll]);

  DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd');
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
          AProc.LogCriticalError('������ ��� �������� ������ ���� ������ : ' + OpenException.Message);
          raise Exception.Create('�� ���������� ������� ������ ���� ������');
        end;
      end;

      try
        try
          ExportFromOldLibMysqlDToFiles1651(oldMySqlDB, PathToBackup, MySqlPathToBackup);
        except
          on UpdateException : Exception do begin
            AProc.LogCriticalError('������ ��� �������� ������ : ' + UpdateException.Message);
            raise Exception.Create(
              '��� ����������� ������ �� ������ ���� � ����� �������� ������.' +
              #13#10 +
              '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.');
          end;
        end;
      finally
        oldMySqlDB.Close;
      end;
    finally
      oldMySqlDB.Free;
    end;

    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd');
{$ifdef USEMEMORYCRYPTDLL}
    DatabaseController.SwitchMemoryLib();
{$endif}

    dbCon.Open;
    try

      try
        ImportOldLibMysqlDFilesToMySql1651(dbCon, PathToBackup, MySqlPathToBackup);
        FProcessUpdateToNewLibMysqlD := True;
      except
        on UpdateException : Exception do begin
          AProc.LogCriticalError('������ ��� �������� ������ : ' + UpdateException.Message);
          raise Exception.Create(
            '��� ����������� ������ �� ������ ���� � ����� �������� ������.' +
            #13#10 +
            '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.');
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
          AProc.LogCriticalError('������ ��� �������� ������ (libd) ���� ������ : ' + E.Message);
      end;
  finally
    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd (�������)');
{$ifdef USEMEMORYCRYPTDLL}
    DatabaseController.SwitchMemoryLib();
{$endif}
  end;
end;

procedure TDM.frReportPrintReport;
begin
  FReportPrinted := True;
end;

procedure TDM.ProcessWaybillsDir(DirName: String; MaxFileDate: TDateTime;
  FileList: TStringList);
var
  DocsSR: TSearchRec;
  CurrentFileDate : TDateTime;
  groupWaybillsBySupplier : Boolean;
  fullFillName,
  insertFileName : String;
begin
  groupWaybillsBySupplier := TGlobalParamsHelper.GetParamDef(adtReceivedDocs.Connection, 'GroupWaybillsBySupplier', False);
  if DirectoryExists(RootFolder() + DirName) then begin
    try
      if FindFirst( RootFolder() + DirName + '\*.*', faAnyFile - faDirectory, DocsSR) = 0 then
        repeat
          if (DocsSR.Name <> '.') and (DocsSR.Name <> '..')
          then begin
            CurrentFileDate := FileDateToDateTime(DocsSR.Time);
            if CurrentFileDate > MaxFileDate then begin
              fullFillName := RootFolder() + DirName + '\' + DocsSR.Name;

              if groupWaybillsBySupplier then
                fullFillName := MoveWaybillToSupplierFolder(fullFillName);

              insertFileName := GetShortFileNameByPrefix(fullFillName, RootFolder());

              if not adtReceivedDocs.Locate('FILENAME', insertFileName, [loCaseInsensitive]) then begin
                adtReceivedDocs.Insert;
                adtReceivedDocs['FILENAME'] := insertFileName;
                adtReceivedDocs['FILEDATETIME'] := CurrentFileDate;
                adtReceivedDocs.Post;
                FileList.Add(fullFillName);
              end;              
            end;
          end;
        until (FindNext( DocsSR ) <> 0)
    finally
      SysUtils.FindClose( DocsSR );
    end;
  end;
end;

function TDM.MoveWaybillToSupplierFolder(fullFileName: String): String;
var
  _Index : Integer;
  shortName,
  downloadId,
  WaybillUnloadingFolder,
  supplierFileName : String;
  folder : Variant;
  supplierShortName : string;
begin
  Result := fullFileName;
  shortName := ExtractFileName(fullFileName);
  supplierFileName := GetOriginalWaybillFileName(shortName);
  _Index := Pos('_', shortName);
  if _Index > 1 then begin
    downloadId := LeftStr(shortName, _Index-1);

    supplierShortName := GetSupplierNameFromFileName(shortName);

    folder := QueryValue('' +
      ' select ps.WaybillUnloadingFolder from ' +
      '    DocumentHeaders dh ' +
      '    inner join ProviderSettings ps on ps.FirmCode = dh.FirmCode' +
      ' where ' +
      ' dh.DownloadId = :DownloadId' +
      ' union ' +
      ' select ps.WaybillUnloadingFolder from ' +
      '    Providers p ' +
      '    inner join ProviderSettings ps on ps.FirmCode = p.FirmCode' +
      ' where ' +
      ' p.ShortName like :supplierShortName'
      ,
      ['DownloadId', 'supplierShortName'],
      [downloadId, supplierShortName]);
    if not VarIsNull(folder) and VarIsStr(folder) then begin
      WaybillUnloadingFolder := folder;
      if Length(WaybillUnloadingFolder) > 0 then begin
        WaybillUnloadingFolder := GetFullFileNameByPrefix(WaybillUnloadingFolder, RootFolder());
        if not DirectoryExists(WaybillUnloadingFolder) then
          SysUtils.ForceDirectories(WaybillUnloadingFolder);

        Result :=
          IncludeTrailingBackslash( WaybillUnloadingFolder )
          + GetNonExistsFileNameInFolder(supplierFileName, WaybillUnloadingFolder);

        if not SameFileName(fullFileName, Result) then
          try
            OSMoveFile(fullFileName, Result);
          except
            on E : Exception do begin
              WriteExchangeLog('MoveWaybillToSupplierFolder', '������: ' + ExceptionToString(e));
              Result := fullFileName;
            end
          end;
      end;
    end;
  end;
end;

function TDM.CertificateSourceExists(serverDocumentBodyId : Int64): Boolean;
var
  sourceExists : Variant;
begin
  Result := False;
  if DM.adsUser.FieldByName('ShowCertificatesWithoutRefSupplier').AsBoolean then
    Result := True
  else begin
    sourceExists := DM.QueryValue(
      'select providers.FirmCode from '
        + ' DocumentBodies db, '
        + ' DocumentHeaders dh, '
        + ' providers '
        + ' where '
        + '  db.ServerId = :DocumentBodyId '
        + '  and dh.Id = db.DocumentId '
        + '  and providers.FirmCode = dh.FirmCode '
        + '  and providers.CertificateSourceExists = 1 ',
      ['DocumentBodyId'], [serverDocumentBodyId]);
    if not VarIsNull(sourceExists) then
      Result := True
    else
      Result := False;
  end;
end;

procedure TDM.ShowCertificateWarning;
begin
  AProc.MessageBox('������ ��������� �� ������������� ����������� � �� �������.'#13#10'���������� � ����������.', MB_ICONWARNING);
end;

procedure TDM.UpdateNewFiles;
var
  newFileSearch: TSearchRec;
  newFileName : String;
begin
  try
    if FindFirst( RootFolder() + '*.new', faAnyFile - faDirectory, newFileSearch) = 0 then
      repeat
        if (newFileSearch.Name <> '.') and (newFileSearch.Name <> '..')
        then begin
          try
            newFileName := ChangeFileExt(newFileSearch.Name, '');
            OSMoveFile(RootFolder() + newFileSearch.Name, RootFolder() + newFileName);
            WriteExchangeLog('UpdateNewFiles', '��� �������� ����: ' + newFileName);
          except
            on E : Exception do
              WriteExchangeLog('UpdateNewFiles', '������ ��� ���������� ����� ' + newFileSearch.Name + ' :' + ExceptionToString(E));
          end;
        end;
      until (FindNext( newFileSearch ) <> 0)
  finally
    SysUtils.FindClose( newFileSearch );
  end;
end;

procedure TDM.OpenAttachment(attachmentId: Int64; extension: String);
var
  fileName : String;
begin
  fileName := RootFolder() + SDirDocs + '\' + IntToStr(attachmentId) + extension;
  if (FileExists(fileName)) then
    FileExecute(fileName);
end;

function TDM.NeedUpdateToNewCryptLibMySqlDAfter1651: Boolean;
var
  buildNumber : Word;
begin
  if FindCmdLineSwitch('i')
    and FileExists(ExePath + SBackDir + '\' + ExeName + '.bak')
  then
  begin
    buildNumber := GetBuildNumberLibraryVersionFromPath(ExePath + SBackDir + '\' + ExeName + '.bak');
    Result := (buildNumber >= 1611) and (buildNumber <= 1651);
  end
  else
    Result := False;
end;

procedure TDM.PrepareUpdateToNewCryptLibMySqlDAfter1651;
begin
  try
    if DirectoryExists(ExePath + SDirDataPrev) then
      MoveDirectories(ExePath + SDirDataPrev, ExePath + SBackDir + '\' + SDirDataPrev);
    if DirectoryExists(ExePath + SDirData) then begin
      CopyDirectories(ExePath + SDirData, ExePath + SBackDir + '\' + SDirData);
      MoveDirectories(ExePath + SDirData, ExePath + SDirData + 'Old');
    end;
    if DirectoryExists(ExePath + SDirTableBackup) then begin
      CopyDirectories(ExePath + SDirTableBackup, ExePath + SBackDir + '\' + SDirTableBackup);
      DeleteFilesByMask(ExePath + SDirTableBackup + '\*.*', False);
    end;
  except
    on E : Exception do begin
      LogCriticalError('������ ��� �������� ���������� ���������� ��� ���������� �� ����� libd: ' + E.Message);
      LogExitError(
        '���������� ������� ���������� ����������.'#13#10
        + '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.',
        Integer(ecDeleteOldMysqlFolder));
    end
  end;
end;

function TDM.NeedUpdateToNewCryptLibMySqlDOn1711: Boolean;
var
  buildNumber : Word;
begin
  if FindCmdLineSwitch('i')
    and FileExists(ExePath + SBackDir + '\' + ExeName + '.bak')
  then
  begin
    buildNumber := GetBuildNumberLibraryVersionFromPath(ExePath + SBackDir + '\' + ExeName + '.bak');
    Result := buildNumber = 1711;
  end
  else
    Result := False;
end;

procedure TDM.ExportFromOldLibMysqlDToFiles1711(
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
      then begin
        exportTable := TDatabaseTable(DatabaseController.DatabaseObjects[i]);
        if FileExists(PathToBackup + exportTable.Name + '.txt') then
          OSDeleteFile(PathToBackup + exportTable.Name + '.txt');
        try
          selectMySql.SQL.Text :=
            Format(
            'select %s from analitf.%s INTO OUTFILE ''%s'';',
            [exportTable.GetColumns(),
             exportTable.Name,
             MySqlPathToBackup + exportTable.Name + '.txt']);
          selectMySql.Execute;
        except
          on E : Exception do begin
            WriteExchangeLog('Exchange.ExportFromOldLibMysqlDToFiles1711',
            '������ ��� �������� ������� ' + exportTable.Name + ': ' + E.Message);
            if FileExists(PathToBackup + exportTable.Name + '.txt')
              and (GetFileSize(PathToBackup + exportTable.Name + '.txt') = 0)
            then
              try
                OSDeleteFile(PathToBackup + exportTable.Name + '.txt');
              except
                on DeleteFile : Exception do
                  WriteExchangeLog('Exchange.ExportFromOldLibMysqlDToFiles1711',
                  '������ ��� �������� ����� ' + exportTable.Name + ': ' + DeleteFile.Message);
              end;
          end;
        end;
      end;

  finally
    selectMySql.Free();
  end;
end;

procedure TDM.ImportOldLibMysqlDFilesToMySql1711(
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
              WriteExchangeLog('Exchange.ImportOldLibMysqlDFilesToMySql1711',
              '������ ��� ������� ������� ' + importTable.Name + ': ' + ImportException.Message);
            end;
          end;

          try
            OSDeleteFile(PathToBackup + importTable.Name + '.txt', False);
          except
            on DeleteFile : Exception do
              WriteExchangeLog('Exchange.ImportOldLibMysqlDFilesToMySql1711',
              '������ ��� �������� ����� ' + importTable.Name + ': ' + DeleteFile.Message);
          end;
        end
        else
          FNotImportedWithUpdateToNewLibMysql :=
            FNotImportedWithUpdateToNewLibMysql + [importTable.ObjectId];
      end;

    selectMySql.SQL.Text :=
      'update analitf.clientsettings set CalculateWithNDSForOther = CalculateWithNDS;';
    selectMySql.Execute;
    selectMySql.SQL.Text :=
      'update analitf.params set ' +
        'ProviderMDBVersion = ' + IntToStr(CURRENT_DB_VERSION) + ' ' +
        ' where Id = 0';
    selectMySql.Execute;
  finally
    selectMySql.Free;
  end;
end;

procedure TDM.UpdateToNewLibMySqlD1711(dbCon: TCustomMyConnection;
  DBDirectoryName: String; OldDBVersion: Integer;
  AOnUpdateDBFileData: TOnUpdateDBFileData);
var
  oldMySqlDB : TMyEmbConnection;
  PathToBackup,
  MySqlPathToBackup : String;
begin
  PathToBackup := ExePath + SDirTableBackup + '\';
  MySqlPathToBackup := StringReplace(PathToBackup, '\', '/', [rfReplaceAll]);

  DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd');
{$ifdef USEMEMORYCRYPTDLL}
  DatabaseController.SwitchMemoryLib(ExePath + SBackDir + '\' + 'appdbhlp.dll' + '.bak', akCurrent);
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
          AProc.LogCriticalError('������ ��� �������� ������ ���� ������ : ' + OpenException.Message);
          raise Exception.Create('�� ���������� ������� ������ ���� ������');
        end;
      end;

      try
        try
          ExportFromOldLibMysqlDToFiles1711(oldMySqlDB, PathToBackup, MySqlPathToBackup);
        except
          on UpdateException : Exception do begin
            AProc.LogCriticalError('������ ��� �������� ������ : ' + UpdateException.Message);
            raise Exception.Create(
              '��� ����������� ������ �� ������ ���� � ����� �������� ������.' +
              #13#10 +
              '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.');
          end;
        end;
      finally
        oldMySqlDB.Close;
      end;
    finally
      oldMySqlDB.Free;
    end;

    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd');
{$ifdef USEMEMORYCRYPTDLL}
    DatabaseController.SwitchMemoryLib();
{$endif}

    dbCon.Open;
    try

      try
        ImportOldLibMysqlDFilesToMySql1711(dbCon, PathToBackup, MySqlPathToBackup);
        FProcessUpdateToNewLibMysqlD := True;
      except
        on UpdateException : Exception do begin
          AProc.LogCriticalError('������ ��� �������� ������ : ' + UpdateException.Message);
          raise Exception.Create(
            '��� ����������� ������ �� ������ ���� � ����� �������� ������.' +
            #13#10 +
            '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.');
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
          AProc.LogCriticalError('������ ��� �������� ������ (libd) ���� ������ : ' + E.Message);
      end;
  finally
    DatabaseController.FreeMySQLLib('MySql Clients Count ��� ���������� �� ������ libd (�������)');
{$ifdef USEMEMORYCRYPTDLL}
    DatabaseController.SwitchMemoryLib();
{$endif}
  end;
end;

function TDM.CheckStartupFolder : Boolean;
begin
  Result := True;
  if not DirectoryExists(ExePath + SDirData)
    and not DirectoryExists(ExePath + SDirDataPrev)
    and not DirectoryExists(ExePath + SDirTableBackup)
    and CheckWin32Version(6, 0)
  then
    Result := CheckStartupFolderByPath(ExePath);
end;

procedure TDM.ShowAttachments(fileList : TStringList);
var
  openedFiles : Integer;
  I : Integer;
  fileName : String;
begin
  openedFiles := 0;

  for I := 0 to fileList.Count-1 do begin
    fileName := fileList[i];
    if (FileExists(fileName)) then begin
      FileExecute(fileName);
      Inc(openedFiles);
    end;

    if (openedFiles >= 10) and (i < fileList.Count-1) then begin
      AProc.MessageBox(
        Format('������������� ������� ������ %d ������ �������� ����-�����.'#13#10'��������� ����� ����� ������� �� ����� ����-�����.', [openedFiles]),
        MB_ICONINFORMATION);
      Break;
    end;
  end;
end;

procedure TDM.FillClientAvg;
begin
  WriteExchangeLog('Exchange', '������ ��������� ������� ���� �� ���������');
  adcUpdate.SQL.Text := 'truncate analitf.clientavg';
  adcUpdate.Execute;
  adcUpdate.SQL.Text := 'insert into analitf.clientavg '
+'  select `postedorderheads`.`CLIENTID` as `CLIENTCODE`, ' 
+'    `postedorderlists`.`PRODUCTID`     as `PRODUCTID` , ' 
+'    avg(`postedorderlists`.`PRICE`)    as `PRICEAVG`, '
+'    avg(`postedorderlists`.`ORDERCOUNT`)    as `ORDERCOUNTAVG` '
+'  from (`postedorderheads` '
+'    join `postedorderlists`) ' 
+'  where ( ' 
+'      ( ' 
+'        `postedorderlists`.`ORDERID` = `postedorderheads`.`ORDERID` ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `postedorderheads`.`CLOSED` = 1 ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `postedorderheads`.`SEND` = 1 ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `postedorderlists`.`ORDERCOUNT` > 0 ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `postedorderlists`.`PRICE` is not null ' 
+'      ) ' 
+'    and ' 
+'      ( '
+'        `postedorderlists`.`Junk` = 0 '
+'      ) '
+'    ) '
+'  group by `postedorderheads`.`CLIENTID`, ' 
+'    `postedorderlists`.`PRODUCTID`;';
  adcUpdate.Execute;
  WriteExchangeLog('Exchange', '�������� ������� ���� �� ���������: ' + IntToStr(adcUpdate.RowsAffected));
end;

function TDM.AutoUpdateFailed: Boolean;
var
  currentBuildNumber,
  prevBuildNumber : Word;
begin
  Result := DirectoryExists(RootFolder() + SDirIn + '\' + SDirExe);

  if not Result then begin
    currentBuildNumber := GetBuildNumberLibraryVersionFromPath(ExePath + ExeName);
    prevBuildNumber := GetBuildNumberLibraryVersionFromPath(ExePath + SBackDir + '\' + ExeName + '.bak');
    Result := currentBuildNumber = prevBuildNumber;
  end;
end;

procedure TDM.UpdateDBFileDataFor96(dbCon: TCustomMyConnection);
begin
  try
    TWaybillGridFactory.RearrangeColumnsOnWaybills(MainForm);
  except
    on E : Exception do
      WriteExchangeLog('UpdateDBFileDataFor96', 'Error : ' + E.Message);
  end;
end;

function TDM.ExistsInFrozenOrders(productId: Int64): Boolean;
var
  id : Variant;
begin
  id := QueryValue(''
    +'select CurrentOrderLists.Id '
    +'from   CurrentOrderHeads '
    +'    join CurrentOrderLists on CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId '
    +'where  CurrentOrderHeads.ClientId   = :ClientId '
    +'and CurrentOrderHeads.Frozen = 1 '
    +'and CurrentOrderLists.PRODUCTID = :ProductId',
      ['ClientId', 'ProductId'],
      [adtClientsCLIENTID.Value, productId]);

  Result := not VarIsNull(id);
end;

procedure TDM.StartInstallNet;
begin
  installNetThread := TInstallNetThread.Create(False);
end;

procedure TDM.KillInstallNet;
begin
  if Assigned(installNetThread) and not installNetThread.Stopped then
    TerminateThread(installNetThread.ThreadID, 1);
end;

procedure TDM.StopInstallNet;
begin
  if Assigned(installNetThread) and not installNetThread.Stopped then
    installNetThread.Terminate;  
end;

initialization
{
  ComObj.CoInitFlags := COINIT_MULTITHREADED;

  if (CoInitFlags <> -1) and Assigned(ComObj.CoInitializeEx) then
  begin
    r := ComObj.CoInitializeEx(nil, CoInitFlags);
    bR := Succeeded(r);
    if not bR then begin
      d := SysErrorMessage(r);
      WriteExchangeLog('test', 'OLE: ' + d);
    end;
    IsMultiThread := IsMultiThread or
      ((CoInitFlags and COINIT_APARTMENTTHREADED) <> 0) or
      (CoInitFlags = COINIT_MULTITHREADED);  // this flag has value zero
  end;
}
  installNetThread := nil;
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
