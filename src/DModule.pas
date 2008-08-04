unit DModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Variants, FileUtil, ARas, ComObj, FR_Class, FR_View,
  FR_DBSet, FR_DCtrl, FR_RRect, FR_Chart, FR_Shape, FR_ChBox, IB_Services,
  FIBQuery, pFIBQuery, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase,
  frRtfExp, frexpimg, FR_E_HTML2, FR_E_TXT, FR_Rich,
  CompactThread, FIB, IB_ErrorCodes, Math, IdIcmpClient, FIBMiscellaneous, VCLUnZip,
  U_TINFIBInputDelimitedStream, incrt, hlpcodecs, StrUtils, RxMemDS,
  Contnrs, SevenZip, infvercls, IdHashMessageDigest, IdSSLOpenSSLHeaders, pFIBScript,
  pFIBProps, U_UpdateDBThread, pFIBExtract, DateUtils, ShellAPI, ibase, IdHTTP,
  IdGlobal, FR_DSet;

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
  CriticalLibraryHashes : array[0..16] of array[0..4] of string =
  (
      ('dbrtl70.bpl', '0650B08C', '583E1038', '5F35A236', '6DD703FA'),
      ('designide70.bpl', 'F16F1849', 'E4827C1D', 'C4FD04B9', '968D63F9'),
      ('EhLib70.bpl', '10FCCB4D', '5DE0A836', 'CCBC83EC', 'B5A52ACC'),
      ('FIBPlus7.bpl', '93C1BA38', '07A95850', '3E51729A', '30003797'),
      ('fr7.bpl', 'F7516F76', '2191B5F2', '43975BC8', '5602F31A'),
      ('Indy70.bpl', '1E271033', 'BD6CE031', '6F82664D', '1111221B'),
      ('rtl70.bpl', 'E4E90D2F', 'C6C35486', '68351583', '3D4ECB44'),
      ('tee70.bpl', '0AADB9CB', '5EE4338D', '61BA4EA3', 'A9E6098C'),
      ('Tough.bpl', '37D3BB15', '2C5BB401', 'BFEC91D6', '5AA3C24B'),
      ('vcl70.bpl', 'DCBC1726', '16A4CA76', '7D5C8162', '2D7512E7'),
      ('vclactnband70.bpl', '86913722', '1C217FB1', 'C86C8AA3', '3132DDFC'),
      ('vcldb70.bpl', 'EAC7B8AE', '4E416522', '6E16BA01', '4FDC98D7'),
//      ('vclie70.bpl', '463BB658', '6C74C812', '33C92380', 'CAC85ED6'),
      ('vcljpg70.bpl', '334355C1', '34EDB2AE', '88BC6505', '9AB7B17E'),
      ('vclsmp70.bpl', 'D7B49DA9', '80884F53', 'C3D78E1E', '853B02E4'),
      ('vclx70.bpl', 'E12C66FF', 'D510C787', '31D5400E', 'DDECD8C8'),
      ('libeay32.dll', '66CB9170', 'A505A6E0', '39877EEC', '976C7931'),
      ('ssleay32.dll', 'ECDEB2FD', '0ED62E52', '20592768', '0F98E2E3')
  );

//Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=AnalitF.mdb;Persist Security Info=False;Jet OLEDB:Registry Path="";Jet OLEDB:Database Password=commonpas;Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False

type
  //������ ���������� ������� � ���� �� ������� ����������
  //pdmPrev - �� ����������� ����������, pdmMin - �� ���������� � min �����,
  //pdmMinEnabled - �� ������.����. � min �����
  TPriceDeltaMode =( pdmPrev, pdmMin, pdmMinEnabled);

  //exit codes - ���� ������ ������ �� ���������
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

  TDM = class(TDataModule)
    frReport: TfrReport;
    dsParams: TDataSource;
    dsAnalit: TDataSource;
    dsClients: TDataSource;
    dsTablesUpdates: TDataSource;
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
    dsReclame: TDataSource;
    MainConnection1: TpFIBDatabase;
    DefTran: TpFIBTransaction;
    adtParams: TpFIBDataSet;
    adtProvider: TpFIBDataSet;
    adtReclame: TpFIBDataSet;
    adtClients: TpFIBDataSet;
    adtTablesUpdates: TpFIBDataSet;
    adtFlags: TpFIBDataSet;
    adcUpdate: TpFIBQuery;
    adsSelect: TpFIBDataSet;
    adsSelect2: TpFIBDataSet;
    adsRepareOrders: TpFIBDataSet;
    adsCore: TpFIBDataSet;
    adsOrdersHeaders: TpFIBDataSet;
    adsOrderDetails: TpFIBDataSet;
    BackService: TpFIBBackupService;
    RestService: TpFIBRestoreService;
    ConfigService: TpFIBConfigService;
    ValidService: TpFIBValidationService;
    t: TpFIBQuery;
    UpTran: TpFIBTransaction;
    adsRepareOrdersID: TFIBBCDField;
    adsRepareOrdersCOREID: TFIBBCDField;
    adsRepareOrdersPRICECODE: TFIBBCDField;
    adsRepareOrdersREGIONCODE: TFIBBCDField;
    adsRepareOrdersCODE: TFIBStringField;
    adsRepareOrdersCODECR: TFIBStringField;
    adsRepareOrdersSYNONYMCODE: TFIBBCDField;
    adsRepareOrdersSYNONYMFIRMCRCODE: TFIBBCDField;
    adsRepareOrdersSYNONYMNAME: TFIBStringField;
    adsRepareOrdersSYNONYMFIRM: TFIBStringField;
    adsRepareOrdersJUNK: TFIBBooleanField;
    adsRepareOrdersAWAIT: TFIBBooleanField;
    adsRepareOrdersORDERCOUNT: TFIBIntegerField;
    adsRepareOrdersPRICENAME: TFIBStringField;
    adsRepareOrdersCryptPRICE: TCurrencyField;
    adsCoreCOREID: TFIBBCDField;
    adsCoreFULLCODE: TFIBBCDField;
    adsCoreSHORTCODE: TFIBBCDField;
    adsCoreCODEFIRMCR: TFIBBCDField;
    adsCoreSYNONYMCODE: TFIBBCDField;
    adsCoreSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreCODE: TFIBStringField;
    adsCoreCODECR: TFIBStringField;
    adsCoreVOLUME: TFIBStringField;
    adsCoreDOC: TFIBStringField;
    adsCoreNOTE: TFIBStringField;
    adsCorePERIOD: TFIBStringField;
    adsCoreQUANTITY: TFIBStringField;
    adsCoreSYNONYMNAME: TFIBStringField;
    adsCoreSYNONYMFIRM: TFIBStringField;
    adsCoreLEADERPRICECODE: TFIBBCDField;
    adsCoreLEADERREGIONCODE: TFIBBCDField;
    adsCoreLEADERREGIONNAME: TFIBStringField;
    adsCoreLEADERPRICENAME: TFIBStringField;
    adsCoreORDERSCOREID: TFIBBCDField;
    adsCoreORDERSORDERID: TFIBBCDField;
    adsCoreORDERSCLIENTID: TFIBBCDField;
    adsCoreORDERSFULLCODE: TFIBBCDField;
    adsCoreORDERSCODEFIRMCR: TFIBBCDField;
    adsCoreORDERSSYNONYMCODE: TFIBBCDField;
    adsCoreORDERSSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreORDERSCODE: TFIBStringField;
    adsCoreORDERSCODECR: TFIBStringField;
    adsCoreORDERCOUNT: TFIBIntegerField;
    adsCoreORDERSSYNONYM: TFIBStringField;
    adsCoreORDERSSYNONYMFIRM: TFIBStringField;
    adsCoreORDERSHORDERID: TFIBBCDField;
    adsCoreORDERSHCLIENTID: TFIBBCDField;
    adsCoreORDERSHPRICECODE: TFIBBCDField;
    adsCoreORDERSHREGIONCODE: TFIBBCDField;
    adsCoreORDERSHPRICENAME: TFIBStringField;
    adsCoreORDERSHREGIONNAME: TFIBStringField;
    adsRetailMargins: TpFIBDataSet;
    adsRetailMarginsID: TFIBBCDField;
    adsRetailMarginsLEFTLIMIT: TFIBBCDField;
    adsRetailMarginsRIGHTLIMIT: TFIBBCDField;
    adsRetailMarginsRETAIL: TFIBIntegerField;
    dsRetailMargins: TDataSource;
    adsSumOrders: TpFIBDataSet;
    adsSumOrdersCODE: TFIBStringField;
    adsSumOrdersCODECR: TFIBStringField;
    adsSumOrdersORDERCOUNT: TFIBIntegerField;
    adsSumOrdersCryptPRICE: TCurrencyField;
    adsSumOrdersSumOrders: TCurrencyField;
    adsPrices: TpFIBDataSet;
    adsOrderDetailsCryptSUMORDER: TCurrencyField;
    adsOrderDetailsORDERID: TFIBBCDField;
    adsOrderDetailsCLIENTID: TFIBBCDField;
    adsOrderDetailsCOREID: TFIBBCDField;
    adsOrderDetailsCODEFIRMCR: TFIBBCDField;
    adsOrderDetailsSYNONYMCODE: TFIBBCDField;
    adsOrderDetailsSYNONYMFIRMCRCODE: TFIBBCDField;
    adsOrderDetailsCODE: TFIBStringField;
    adsOrderDetailsCODECR: TFIBStringField;
    adsOrderDetailsSYNONYMNAME: TFIBStringField;
    adsOrderDetailsSYNONYMFIRM: TFIBStringField;
    adsOrderDetailsORDERCOUNT: TFIBIntegerField;
    adsAllOrders: TpFIBDataSet;
    adsAllOrdersID: TFIBBCDField;
    adsAllOrdersORDERID: TFIBBCDField;
    adsAllOrdersCLIENTID: TFIBBCDField;
    adsAllOrdersCOREID: TFIBBCDField;
    adsAllOrdersCODEFIRMCR: TFIBBCDField;
    adsAllOrdersSYNONYMCODE: TFIBBCDField;
    adsAllOrdersSYNONYMFIRMCRCODE: TFIBBCDField;
    adsAllOrdersCODE: TFIBStringField;
    adsAllOrdersCODECR: TFIBStringField;
    adsAllOrdersSYNONYMNAME: TFIBStringField;
    adsAllOrdersSYNONYMFIRM: TFIBStringField;
    adsAllOrdersAWAIT: TFIBBooleanField;
    adsAllOrdersJUNK: TFIBBooleanField;
    adsAllOrdersORDERCOUNT: TFIBIntegerField;
    adsAllOrdersCryptPRICE: TCurrencyField;
    adsPricesPRICECODE: TFIBBCDField;
    adsPricesPRICENAME: TFIBStringField;
    adsPricesDATEPRICE: TFIBDateTimeField;
    adsPricesMINREQ: TFIBIntegerField;
    adsPricesENABLED: TFIBIntegerField;
    adsPricesPRICEINFO: TFIBMemoField;
    adsPricesFIRMCODE: TFIBBCDField;
    adsPricesFULLNAME: TFIBStringField;
    adsPricesSTORAGE: TFIBIntegerField;
    adsPricesADMINMAIL: TFIBStringField;
    adsPricesSUPPORTPHONE: TFIBStringField;
    adsPricesCONTACTINFO: TFIBMemoField;
    adsPricesOPERATIVEINFO: TFIBMemoField;
    adsPricesREGIONCODE: TFIBBCDField;
    adsPricesREGIONNAME: TFIBStringField;
    adsPricesPOSITIONS: TFIBIntegerField;
    adsPricesSUMORDER: TFIBBCDField;
    adsPricesPRICESIZE: TFIBIntegerField;
    adsPricesINJOB: TFIBIntegerField;
    adsCoreAWAIT: TFIBBooleanField;
    adsCoreJUNK: TFIBBooleanField;
    adsRepareOrdersPRICE: TFIBStringField;
    adsCoreBASECOST: TFIBStringField;
    adsCoreORDERSPRICE: TFIBStringField;
    adsOrderDetailsPRICE: TFIBStringField;
    adsSumOrdersPRICE: TFIBStringField;
    adsAllOrdersPRICE: TFIBStringField;
    adsCoreORDERSJUNK: TFIBBooleanField;
    adsCoreORDERSAWAIT: TFIBBooleanField;
    adsOrderCore: TpFIBDataSet;
    adsOrderCorePRICECODE: TFIBBCDField;
    adsOrderCoreBASECOST: TFIBStringField;
    adsOrderCoreCryptBASECOST: TCurrencyField;
    adsOrderCorePRICEENABLED: TFIBIntegerField;
    adsOrderCoreJUNK: TFIBIntegerField;
    adtClientsCLIENTID: TFIBBCDField;
    adtClientsNAME: TFIBStringField;
    adtClientsREGIONCODE: TFIBBCDField;
    adtClientsEXCESS: TFIBIntegerField;
    adtClientsDELTAMODE: TFIBSmallIntField;
    adtClientsMAXUSERS: TFIBIntegerField;
    adtClientsREQMASK: TFIBBCDField;
    adtClientsTECHSUPPORT: TFIBStringField;
    adtClientsCALCULATELEADER: TFIBBooleanField;
    adtClientsONLYLEADERS: TFIBBooleanField;
    adsOrderCoreCODEFIRMCR: TFIBBCDField;
    adsCoreREQUESTRATIO: TFIBIntegerField;
    adsOrderDetailsSENDPRICE: TFIBBCDField;
    adsOrderDetailsAWAIT: TFIBBooleanField;
    adsOrderDetailsJUNK: TFIBBooleanField;
    adsOrderDetailsID: TFIBBCDField;
    adtReceivedDocs: TpFIBDataSet;
    adsOrderDetailsPRODUCTID: TFIBBCDField;
    adsOrderDetailsFULLCODE: TFIBBCDField;
    adsOrderCorePRODUCTID: TFIBBCDField;
    adsAllOrdersPRODUCTID: TFIBBCDField;
    adsRepareOrdersVITALLYIMPORTANT: TFIBBooleanField;
    adsRepareOrdersREQUESTRATIO: TFIBIntegerField;
    adsRepareOrdersORDERCOST: TFIBBCDField;
    adsRepareOrdersMINORDERCOUNT: TFIBIntegerField;
    adsCoreVITALLYIMPORTANT: TFIBBooleanField;
    adsCoreORDERCOST: TFIBBCDField;
    adsCoreMINORDERCOUNT: TFIBIntegerField;
    frdsReportOrder: TfrDBDataSet;
    adsOrderDetailsSUMORDER: TFIBBCDField;
    adsOrderDetailsCryptPRICE: TCurrencyField;
    procedure DMCreate(Sender: TObject);
    procedure adtClientsAfterOpen(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure MainConnection1AfterConnect(Sender: TObject);
    procedure adsRetailMarginsLEFTLIMITChange(Sender: TField);
  private
    //��������� �� ������������� ������
    FNeedCommitExchange : Boolean;
    //��� ������������� ����������, ���������� � �������
    FServerUpdateId : String;
    SynonymPassword,
    CodesPassword,
    BaseCostPassword,
    DBUIN : String;
    //��������� ���������� ��-�� ����, ��� ������������ UIN
    NeedUpdateByCheckUIN : Boolean;
    //��������� ���������� ��-�� ����, ��� ������������ Hash'� ���������
    NeedUpdateByCheckHashes : Boolean;
    //��������� ������ ����� �������������� �� ��������� �����
    FNeedImportAfterRecovery : Boolean;
    //���� ������� "������" ���� ������
    FCreateClearDatabase     : Boolean;
    FGetCatalogsCount : Integer;
    FRetMargins : array of TRetMass;
    OldOrderCount : Integer;
    AllSumOrder : Currency;
    UpdateReclameDT : TDateTime;
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
    procedure ocf(DataSet: TDataSet);
    procedure socf(DataSet: TDataSet);
    procedure occf(DataSet: TDataSet);
    //��������� ������ ���� � ��������� �� � ������ �������������
    procedure UpdateDB;
    //���������� UIN � ���� ������ � ������ ���������� ������ ���������
    procedure UpdateDBUIN(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    //��������� ������� ���� �������� � ���� ������
    procedure CheckDBObjects(dbCon : TpFIBDatabase; trMain : TpFIBTransaction; FileName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    //��������� � ��������� ������������ ����
    procedure UpdateDBFile(dbCon : TpFIBDatabase; trMain : TpFIBTransaction; FileName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    function GetLastEtalonFileName : String;
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
    //���������� ������������ ������ � �������
{$ifdef DEBUG}
    procedure UpdateDBFileDataFor29(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor36(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor35(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor37(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor40(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
{$endif}
    procedure UpdateDBFileDataFor42(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    //���������� ������� ��������� ��� ������� �������
    procedure SetSendToNotClosedOrders;
    function GetLastCreateScript : String;
    function GetFullLastCreateScript : String;
    procedure CreateClearDatabaseFromScript(dbCon : TpFIBDatabase; trMain : TpFIBTransaction; FileName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
    //���������� ������������� �� ��������� ����� (���� ��� ����������) ��� ������� ������ ���� ������
    procedure RecoverDatabase(E : Exception);
{$ifdef DEBUG}
    procedure ExtractDBScript(dbCon : TpFIBDatabase);
{$endif}
  public
    FFS : TFormatSettings;
    SerBeg,
    SerEnd : String;
    SaveGridMask : Integer;
    function DatabaseOpenedBy: string;
    function DatabaseOpenedList( var ExclusiveID, ComputerName: string): TStringList;
    procedure CompactDataBase(NewPassword: string='');
    procedure ClearPassword( ADatasource: string);
    procedure OpenDatabase( ADatasource: string);
    procedure ShowFastReport(FileName: string; DataSet: TDataSet = nil;
      APreview: boolean = False; PrintDlg: boolean = True);
    procedure ShowOrderDetailsReport(
      OrderId  : Integer;
      Closed   : Boolean;
      Send     : Boolean;
      Preview  : Boolean = False;
      PrintDlg : Boolean = True);
    procedure ClientChanged;
    function GetTablesUpdatesInfo(ParamTableName: string): string;
    procedure LinkExternalTables;
    procedure LinkExternalMDB( ATablesList: TStringList);
    procedure UnLinkExternalTables;
    procedure ClearDatabase;
    function GetCurrentOrderId(ClientId, PriceCode, RegionCode: Integer;
      CreateIfNotExists: Boolean=True): Integer;
    procedure DeleteEmptyOrders;
    procedure SetImportStage( AValue: integer);
    function GetImportStage: integer;
    procedure BackupDatabase( APath: string);
    procedure RestoreDatabase( APath: string);
    function IsBackuped( APath: string): boolean;
    procedure ClearBackup( APath: string);
    procedure SetExclusive;
    procedure ResetExclusive;
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

    //��� ��������� ����� ��� ����, ����� ��������� ��������� ���� ���������� �������
    procedure ResetReclame;
    procedure SetReclame;
    procedure UpdateReclame;
    function D_B_N(BaseC: String) : String;
    function D_B_N_C(c : TINFCrypt; BaseC: String) : String;
    function E_B_N(c : TINFCrypt; BaseCost: String) : String;
    function D_B_N_OLD(c : TINFCrypt; BaseC: String) : String;
    function E_B_N_OLD(c : TINFCrypt; BaseCost: String) : String;
    //���������� ���� CODE �� ������ 29
    function D_29_C_OLD(c : TINFCrypt; CodeS : String) : String;
    //���������� ���� PRICE �� ������ 29
    function D_29_B_OLD(c : TINFCrypt; CodeS1, CodeS2 : String) : String;
    function D_HP(HTTPPassC: String) : String;
    function E_HP(HTTPPass: String) : String;
    procedure SavePass(ASyn, ACodes, AB, ASGM : String);
    procedure LoadRetailMargins;
    //�������� ��������� ���� ������ � ����������� �� �������
    function GetPriceRet(BaseCost : Currency) : Currency;
    //�������� ��������� ������� ������
    function GetRetUpCost(BaseCost : Currency) : Integer;

    //������������ ����� � �����������
    procedure ProcessDocs;
    //������������ ������ ���������� �����
    procedure ProcessDocsDir(DirName : String; MaxFileDate : TDateTime; FileList : TStringList);
    procedure OpenDocsDir(DirName : String; FileList : TStringList; OpenEachFile : Boolean);

    procedure InitAllSumOrder;
    procedure SetOldOrderCount(AOldOrderCount : Integer);
    procedure SetNewOrderCount(ANewOrderCount : Integer; ABaseCost : Currency; APriceCode, ARegionCode : Integer);
    function GetAllSumOrder : Currency;
    function GetSumOrder (AOrderID : Integer) : Currency;
    function FindOrderInfo (APriceCode, ARegionCode : Integer) : TOrderInfo;
    property NeedImportAfterRecovery : Boolean read FNeedImportAfterRecovery;
    property CreateClearDatabase : Boolean read FCreateClearDatabase;
    //���������� ��������� ��� ���������� TIdHTTP
    procedure InternalSetHTTPParams(SetHTTP : TIdHTTP);
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
     U_FolderMacros, LU_Tracer, LU_MutexSystem, Config, U_ExchangeLog,
     U_DeleteDBThread;

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
  LDBFileName : String;
  DBCompress : Boolean;
  HTTPS,
  HTTPE : String;
begin
  SerBeg := '8F24';
  SerEnd := 'BB48';
  HTTPS := 'rkhgjsdk';
  HTTPE := 'fhhjfgfh';

  OrdersInfo := TStringList.Create;
  OrdersInfo.Sorted := True;

  adsRepareOrders.OnCalcFields := s3cf;
  adsOrderDetails.OnCalcFields := ocf;
  adsSumOrders.OnCalcFields := socf;
  adsOrderCore.OnCalcFields := occf;

  SynC := TINFCrypt.Create('', 300);
  CodeC := TINFCrypt.Create('', 60);
  BasecostC := TINFCrypt.Create('', 50);
  HTTPC := TINFCrypt.Create(HTTPS + HTTPE, 255);

  ResetNeedCommitExchange;
  GetLocaleFormatSettings(0, FFS);

  MainConnection1.DBName := ExePath + DatabaseName;

  if not IsOneStart then
    LogExitError('������ ���� ����� ��������� �� ����� ���������� ����������.', Integer(ecDoubleStart));

  WriteExchangeLog('AnalitF', '��������� ��������.');

  //������� ����� ���� ������ ��� �������������
  if FindCmdLineSwitch('renew') then
    RunDeleteDBFiles();

  //TODO: ����� ���� ��������� �������� � ������ � ����� ���� ������, ����� ��������� �������� � ������� ������
  FNeedImportAfterRecovery := False;
  FCreateClearDatabase     := False;
  if IsBackuped(ExePath) then
    try
      AProc.OSMoveFile(ChangeFileExt(ParamStr(0), '.bak'), MainConnection1.DBName);
      FNeedImportAfterRecovery := True;
    except
      on E : Exception do
        LogExitError(Format( '�� �������� ����������� AnalitF.bak � AnalitF.fdb : %s ', [ E.Message ]), Integer(ecDBFileError));
    end;

  if FileExists(ExePath + DatabaseName) and ((FileGetAttr(ExePath + DatabaseName) and SysUtils.faReadOnly) = SysUtils.faReadOnly)
  then
    LogExitError(Format( '���� ���� ������ %s ����� ������� "������ ������".', [ ExePath + DatabaseName ]), Integer(ecDBFileReadOnly));

  //������ �������� ����� ���� ������ � � ������ ������� ���������� �������������� �� ��������� �����
  CheckDBFile;

  LDBFileName := ChangeFileExt(ExeName, '.ldb');
  DBCompress := FileExists(LDBFileName) and DeleteFile(LDBFileName);

  try
    try
      CheckRestrictToRun;
    finally
      MainConnection1.Close;
    end;
  except
    on E : Exception do
      LogExitError(Format( '�� �������� ������� ���� ���� ������ : %s ', [ E.Message ]), Integer(ecDBFileError));
  end;

  MainConnection1.Open;
  { ������������� ������� ������ � Clients � Users }
  if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
    then adtClients.First;
  //���������, ��� ������ � ���������� ���� ��������� ���������
  if DBCompress then
  begin
    AProc.MessageBox(
      '��������� ����� ������ � ���������� �� ��� ��������� ��������. '+
        '������ ����� ����������� ������ ���� ������.');
    MainForm.FreeChildForms;
    RunCompactDataBase;
    AProc.MessageBox( '������ ���� ������ ���������.');
  end;
  SetStarted;
  //MainForm.dblcbClients.KeyValue:=adtClients.FieldByName('ClientId').Value;
  ClientChanged;
  { ������������� ��������� ������ }
  frReport.Title := Application.Title;
  { ��������� � ���� ���� ������� ������ �������� }
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
    if (adtParams.FieldByName( 'UpdateDateTime').AsDateTime = adtParams.FieldByName( 'LastDateTime').AsDateTime)
    then begin
      if not RunExchange([ eaGetPrice]) then
        LogExitError('�� ������ �������� �� UIN � ����.', Integer(ecNotCheckUIN), False);
    end
    else
      if not RunExchange([eaGetPrice, eaGetFullData, eaSendOrders]) then
        LogExitError('�� ������ �������� �� UIN � ����.', Integer(ecNotCheckUIN), False);
  end;

  if NeedUpdateByCheckHashes then begin
    if not RunExchange([ eaGetPrice]) then
      LogExitError('�� ������ �������� �� ����������� ���������.', Integer(ecNotChechHashes), False);
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
      RunExchange([ eaImportOnly]);
    Application.Terminate;
  end;

  if adtParams.FieldByName('HTTPNameChanged').AsBoolean then
    MainForm.DisableByHTTPName;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  WriteExchangeLog('AnalitF', '������� ������� ���������.');
  if not MainConnection1.Connected then exit;

  try
    adtParams.Edit;
    adtParams.FieldByName( 'ClientId').Value := adtClients.FieldByName( 'ClientId').Value;
    adtParams.Post;
  except
    on E : Exception do
      AProc.LogCriticalError('������ ��� ��������� ClientId: ' + E.Message);
  end;
  ResetStarted;
  WriteExchangeLog('AnalitF', '��������� �������.');
end;

procedure TDM.ClientChanged;
begin
  MainForm.FreeChildForms;
  MainForm.SetOrdersInfo;
  DoPost(adtParams, True);
  InitAllSumOrder;
end;

{ �������� �� ������������� ������� ��������� }
procedure TDM.CheckRestrictToRun;
var
  list: TStringList;
//  ExID, CompName: string;
  MaxUsers: integer;
  FreeAvail,
  Total,
  TotalFree,
  DBFileSize : Int64;
begin
{
  DM.MainConnection.Open;
  MaxUsers := DM.adtClients.FieldByName( 'MaxUsers').AsInteger;
  list := DM.DatabaseOpenedList( ExID, CompName);
  DM.MainConnection.Close;

  if list.Count > 1 then
  begin
    if ( ExID = GetExclusiveID()) or ( ExID = '') then exit;

    AProc.MessageBox( Format( '����� ��������� �� ���������� %s �������� � ������ ' + #10 + #13 +
      '������������ ������ � ���� ������. ������ ��������� ����������.', [ CompName]),
      MB_ICONWARNING or MB_OK);
    ExitProcess(3);
  end;
}
  if GetDisplayColors < 16 then
    LogExitError('�� �������� ������ ��������� � ������� ��������� �������������. ����������� �������� ������������� : 16 ���.', Integer(ecColor));

  if not TCPPresent then
    LogExitError('�� �������� ������ ��������� ��� ������������� ���������� Windows Sockets ������ 2.0.', Integer(ecTCPNotExists));

  if not LoadSevenZipDLL then
    LogExitError('�� ������� ���������� 7-zip32.dll, ����������� ��� ������ ���������.', Integer(ecSevenZip));

  if not IdSSLOpenSSLHeaders.Load then
    LogExitError('�� ������� ���������� libeay32.dll � ssleay32.dll, ����������� ��� ������ ���������.', Integer(ecSSLOpen));

  DM.MainConnection1.Open;
  try
    MaxUsers := DM.adtClients.FieldByName( 'MaxUsers').AsInteger;
    FGetCatalogsCount := GetCatalogsCount;
    list := DM.MainConnection1.UserNames;
  finally
    DM.MainConnection1.Close;
  end;
  if ( MaxUsers > 0) and ( list.Count > MaxUsers)
  then
    LogExitError(Format( '�������� ����� �� ����������� � ���� ������ (����� : %d). ' +
      '������ ��������� ����������.', [ MaxUsers]), Integer(ecUserLimit));

  if GetDiskFreeSpaceEx(PChar(ExtractFilePath(ParamStr(0))), FreeAvail, Total, @TotalFree) then begin
    DBFileSize := GetFileSize(MainConnection1.DBName);
    DBFileSize := Max(2*DBFileSize, 200*1024*1024);
    if DBFileSize > FreeAvail then
      LogExitError(Format( '������������ ���������� ����� �� ����� ��� ������� ����������. ���������� %d ����.', [ DBFileSize ]), Integer(ecFreeDiskSpace));
  end
  else
    LogExitError(Format( '�� ������� �������� ���������� ���������� ����� �� �����.' +
      #13#10#13#10'��������� �� ������:'#13#10'%s', [ SysErrorMessage(GetLastError) ]), Integer(ecGetFreeDiskSpace));

  NeedUpdateByCheckUIN := not CheckCopyIDFromDB;
  if NeedUpdateByCheckUIN then begin
    DM.MainConnection1.Open;
    try
      adtParams.Edit;
      adtParams.FieldByName('CDS').AsString := '';
      adtParams.Post;
    finally
      DM.MainConnection1.Close;
    end;
    AProc.MessageBox( '������ �������� ����������� ���������. ���������� ��������� ���������� ������.',
      MB_ICONERROR or MB_OK);
    DM.MainConnection1.Open;
    try
      if (Trim( adtParams.FieldByName( 'HTTPName').AsString) = '') then
        ShowConfig( True );
    finally
      DM.MainConnection1.Close;
    end;
  end;

  NeedUpdateByCheckHashes := not CheckCriticalLibrary;
  if NeedUpdateByCheckHashes then
    AProc.MessageBox( '������ �������� ����������� ��������� ���������. ���������� ��������� ���������� ������.',
      MB_ICONERROR or MB_OK);
end;

function TDM.DatabaseOpenedBy: string;
//var
//  WasConnected: boolean;
begin
  result := '';
{
  WasConnected := MainConnection.Connected;
  MainConnection.OpenSchema( siProviderSpecific, EmptyParam,
    JET_SCHEMA_USERROSTER, adsSelect);
  if adsSelect.RecordCount > 1 then
    result := adsSelect.FieldByName( 'COMPUTER_NAME').AsString;
  adsSelect.Close;
  if not WasConnected then MainConnection.Close;
}  
end;

function TDM.DatabaseOpenedList( var ExclusiveID, ComputerName: string): TStringList;
//var
//  WasConnected: boolean;
begin
  result := TStringList.Create;
{
  WasConnected := MainConnection.Connected;
  MainConnection.OpenSchema( siProviderSpecific, EmptyParam,
    JET_SCHEMA_USERROSTER, adsSelect);
  while not adsSelect.Eof do
  begin
    result.Add( adsSelect.FieldByName( 'COMPUTER_NAME').AsString);
    adsSelect.Next;
  end;
  MainForm.CS.Enter;
  try
    ExclusiveID := DM.adtFlags.FieldByName( 'ExclusiveID').AsString;
    ComputerName := DM.adtFlags.FieldByName( 'ComputerName').AsString;
  except
    ExclusiveID := '';
    ComputerName := '';
  end;
  MainForm.CS.Leave;
  adsSelect.Close;
  if not WasConnected then MainConnection.Close;
}  
end;

procedure TDM.CompactDataBase(NewPassword: string='');
var
  ok: boolean;
  dbc : TpFIBDatabase;
begin
  ok := False;
  //TODO: ___ ��������� �� �� ����� ������. ������������ ������ ��� ��� ����������� �����������
  Tracer.TR('BackupRestore', 'Start');
  try
    try
      with ConfigService do
      begin
        ServerName := '';
        DatabaseName := MainConnection1.DBName;
        Params.Clear;
        Params.Add('user_name=' + MainConnection1.ConnectParams.UserName);
        Params.Add('password=' + MainConnection1.ConnectParams.Password);
        Active := True;
        try
          Tracer.TR('BackupRestore', 'Try shutdown database');
          ShutdownDatabase(Forced, 0);
          Tracer.TR('BackupRestore', 'Shutdown complete');
        finally
          Active := False;
        end;
      end;
      with BackService do
      begin
        ServerName := '';
        Params.Clear;
        Params.Add('user_name=' + MainConnection1.ConnectParams.UserName);
        Params.Add('password=' + MainConnection1.ConnectParams.Password);
        Active := True;
        try
          Verbose := True;
          DatabaseName := MainConnection1.DBName;
          BackupFile.Clear;
          BackupFile.Add(ChangeFileExt(MainConnection1.DBName, '.gbk'));

          ServiceStart;
          While not Eof do
            Tracer.TR('Backup', GetNextLine);
        finally
          Active := False;
        end;
      end;
      with RestService do
      begin
        ServerName := '';
        Params.Clear;
        Params.Add('user_name=' + MainConnection1.ConnectParams.UserName);
        Params.Add('password=' + MainConnection1.ConnectParams.Password);
        Active := True;
        try
          Verbose := True;
          DatabaseName.Clear;
          DatabaseName.Add(MainConnection1.DBName);
          BackupFile.Clear;
          BackupFile.Add(ChangeFileExt(MainConnection1.DBName, '.gbk'));
          ServiceStart;
          While not Eof do
            Tracer.TR('Restore', GetNextLine);
        finally
          Active := False;
        end;
      end;
      with ConfigService do
      begin
        ServerName := '';
        DatabaseName := MainConnection1.DBName;
        Params.Clear;
        Params.Add('user_name=' + MainConnection1.ConnectParams.UserName);
        Params.Add('password=' + MainConnection1.ConnectParams.Password);
        Active := True;
        try
          Tracer.TR('BackupRestore', 'Try BringDatabaseOnline');
          BringDatabaseOnline;
          Tracer.TR('BackupRestore', 'BringDatabaseOnline complete');
        finally
          Active := False;
        end;
      end;
      ok := True;
    except
      on E : Exception do
        Tracer.TR('BackupRestore', 'Error : ' + E.Message);
    end;
  finally
    Tracer.TR('BackupRestore', 'Stop');
  end;
  if ok then
  begin

    dbc := TpFIBDatabase.Create(nil);
    try
      dbc.DBName := MainConnection1.DBName;
      dbc.DBParams.Text := MainConnection1.DBParams.Text;
      dbc.LibraryName := MainConnection1.LibraryName;
      dbc.SQLDialect := MainConnection1.SQLDialect;

      dbc.Open;
      dbc.QueryValue('update params set LastCompact = :LastCompact where ID = 0', -1, [Now]);
      dbc.Close;

    finally
      dbc.Free;
    end;
  end;
end;

procedure TDM.ClearPassword( ADatasource: string);
begin
{
  if MainConnection.Connected then MainConnection.Close;
  MainConnection.Mode := cmShareExclusive;
  MainConnection.ConnectionString := SetConnectionProperty(
    MainConnection.ConnectionString, 'Data Source', ADataSource);
  MainConnection.Open;
  adcUpdate.CommandText := 'ALTER DATABASE PASSWORD NULL ' +
    GetConnectionProperty( MainConnection.ConnectionString,
    'Jet OLEDB:Database Password');
  try
    adcUpdate.Execute;
  except
  end;
  MainConnection.Close;
  MainConnection.Mode := cmReadWrite;
}  
end;

procedure TDM.OpenDatabase( ADatasource: string);
begin
  if MainConnection1.Connected then MainConnection1.Close;
{
  MainConnection.ConnectionString :=
    SetConnectionProperty( MainConnection.ConnectionString, 'Data Source',
      ADatasource);
}
  MainConnection1.Open;
end;

//��������� ����� � ������� �� ����� ��� ��������; ���� ������ DataSet, ��
//����������� ���������� ����������� �� ���� � ���������� ������� �� ��������� ������
procedure TDM.ShowFastReport(FileName: string; DataSet: TDataSet = nil;
  APreview: boolean = False; PrintDlg: boolean = True);
var
  Mark: TBookmarkStr;
begin
  //������� � ��������� ������ ��� �����; ��������� ����
  FileName:=Trim(FileName);
  if FileName<>'' then begin
    FileName:=ExePath+FileName;
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

procedure TDM.adtClientsAfterOpen(DataSet: TDataSet);
begin
  if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
  then begin
    adtClients.First;
    adtParams.Edit;
    adtParams.FieldByName( 'ClientId').Value := adtClients.FieldByName( 'ClientId').Value;
    adtParams.Post;
  end;
  //MainForm.dblcbClients.KeyValue:=adtClients.FieldByName('ClientId').Value;
  ClientChanged;
end;

//�������� ���������� �� ���������� ��������� ��������� �� TablesUpdates
function TDM.GetTablesUpdatesInfo(ParamTableName: string): string;
begin
  Result:='';
  with adtTablesUpdates do begin
    Open;
    try
      if Locate('TableName',ParamTableName,[loCaseInsensitive]) then
        Result:='������ ��������� : '+FieldByName('UpdateDate').AsString;
    finally
      Close;
    end;
  end;
end;

//���������� � �������� ������� ��������� ������� �� ����� In
procedure TDM.LinkExternalTables;
const
  ExcludeExtTables : array[0..10] of string =
  ('EXTCORE', 'EXTSYNONYM', 'EXTREGISTRY', 'EXTMINPRICES', 'EXTPRICEAVG',
   'EXTCATALOGFARMGROUPS', 'EXTCATALOG', 'EXTCATDEL', 'EXTCATFARMGROUPSDEL',
   'EXTCATALOGNAMES', 'EXTPRODUCTS');
var
  SR: TSearchRec;
  FileName,
  ShortName : String;
  up : TpFIBDataSet;
  Files : TStringList;
  Tables : TStringList;
  I : Integer;
  InDelimitedFile : TFIBInputDelimitedFile;

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
      UpTran.StartTransaction;
      try

        //������� ������� ������� �������
        repeat
          FileName := ExePath+SDirIn+ '\' + SR.Name;
          ShortName := ChangeFileExt(SR.Name,'');
          adcUpdate.SQL.Text := 'EXECUTE PROCEDURE CREATEEXT' + ShortName + '(:PATH)';
          adcUpdate.ParamByName('PATH').Value := FileName;
          Tracer.TR('CreateExternal', adcUpdate.SQL.Text);
          adcUpdate.ExecQuery;
          Files.Add(FileName);
          Tables.Add('EXT' + UpperCase(ShortName));
        until FindNext(SR)<>0;
        FindClose(SR);

        UpTran.CommitRetaining;

        //����� ��������� �� �������
        up := TpFIBDataSet.Create(nil);
        try
          up.Database := MainConnection1;
          up.Transaction := UpTran;

          InDelimitedFile := TFIBInputDelimitedFile.Create;
          try
            InDelimitedFile.SkipTitles := False;
            InDelimitedFile.ReadBlanksAsNull := True;
            InDelimitedFile.ColDelimiter := Chr(159);
            InDelimitedFile.RowDelimiter := Chr(161);


            for I := 0 to Files.Count-1 do begin
              if NeedImport(Tables[i]) then begin
                up.SelectSQL.Text := 'select * from ' + Tables[i];
                up.Prepare;
                up.Open;
                up.AutoUpdateOptions.UpdateTableName := Tables[i];
                up.InsertSQL.Text := up.GenerateSQLText(Tables[i], up.Fields[0].FieldName, skInsert);
                Tracer.TR(Tables[i], up.InsertSQL.Text);
                up.Close;
                up.SelectSQL.Text := up.InsertSQL.Text;
                InDelimitedFile.Filename := Files[i];
                up.BatchInput(InDelimitedFile);
              end;
            end;

          finally
            InDelimitedFile.Free;
          end;

        finally
          up.Free;
        end;

        UpTran.Commit;
      except
        UpTran.Rollback;
        raise;
      end;

    finally
      Files.Free;
      Tables.Free;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

// ���������� ������� �� ������� MDB
procedure TDM.LinkExternalMDB( ATablesList: TStringList);
//var
//  Table, Catalog: Variant;
//  i: integer;
begin
{
  Catalog := CreateOleObject( 'ADOX.Catalog');
        Catalog.ActiveConnection := MainConnection.ConnectionObject;

  try
    for i := 0 to ATablesList.Count - 1 do
    begin
      if Pos( 'Tmp', ATablesList[ i]) = 1 then continue;
      Table := CreateOleObject( 'ADOX.Table');
      Table.ParentCatalog := Catalog;
      Table.Name := 'Old' + ATablesList[ i];
      Table.Properties( 'Jet OLEDB:Create Link') := True;
      Table.Properties( 'Jet OLEDB:Link Datasource') := ExePath + DatabaseName;
      Table.Properties( 'Jet OLEDB:Remote Table Name') := ATablesList[ i];
      try
        Catalog.Tables.Append( Table);
      except
      end;
      Table := Unassigned;
    end;
  finally
    Catalog := Unassigned;
  end;
  }
end;

//��������� ��� ������������ ������� �������
procedure TDM.UnLinkExternalTables;
var
  I: Integer;
//  Catalog: Variant;
  TN : TStringList;
begin
{
  Screen.Cursor:=crHourglass;
  try
    Catalog:=CreateOleObject('ADOX.Catalog');
    try
      Catalog.ActiveConnection:=MainConnection.ConnectionObject;
      for I:=Catalog.Tables.Count-1 downto 0 do
        if Catalog.Tables.Item[I].Type='LINK' then
          Catalog.Tables.Delete(Catalog.Tables.Item[I].Name);
    finally
      Catalog:=Unassigned;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
  }
  Screen.Cursor:=crHourglass;
  try
    TN := TStringList.Create;
    try
      MainConnection1.GetTableNames(TN, False);
      DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;
      try
        for I:=TN.Count-1 downto 0 do
          if Pos('EXT', UpperCase(TN[i])) = 1 then
          begin
            adcUpdate.SQL.Text := 'drop table ' + TN[i];
            adcUpdate.ExecQuery;
          end;
        DM.MainConnection1.DefaultUpdateTransaction.Commit;
      except
        DM.MainConnection1.DefaultUpdateTransaction.Rollback;
        raise;
      end;
    finally
      TN.Free;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TDM.ClearDatabase;
begin
  Screen.Cursor:=crHourglass;
  with adcUpdate do try
    UpTran.StartTransaction;
    try

      MainForm.StatusText:='��������� MinPrices';
      SQL.Text:='EXECUTE PROCEDURE MinPricesDeleteALL';
      ExecQuery;
      SQL.Text:='EXECUTE PROCEDURE OrdersSetCoreNull'; ExecQuery;
      SQL.Text:='EXECUTE PROCEDURE OrdersHDeleteNotClosedAll'; ExecQuery;
      MainForm.StatusText:='��������� Core';
      SQL.Text:='EXECUTE PROCEDURE CoreDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� CatalogCurrency';
      SQL.Text:='EXECUTE PROCEDURE CatalogCurrencyDelete'; ExecQuery;
      MainForm.StatusText:='��������� Catalog';
      SQL.Text:='EXECUTE PROCEDURE CatalogDelete'; ExecQuery;
      MainForm.StatusText:='��������� CatalogNames';
      SQL.Text:='EXECUTE PROCEDURE CatalogNamesDelete'; ExecQuery;
      MainForm.StatusText:='��������� CatalogFarmGroups';
      SQL.Text:='EXECUTE PROCEDURE CatalogFarmGroupsDelete'; ExecQuery;
      MainForm.StatusText:='��������� PricesRegionalData';
      SQL.Text:='EXECUTE PROCEDURE PricesRegionalDataDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� PricesData';
      SQL.Text:='EXECUTE PROCEDURE PricesDataDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� RegionalData';
      SQL.Text:='EXECUTE PROCEDURE RegionalDataDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� ClientsDataN';
      SQL.Text:='EXECUTE PROCEDURE ClientsDataNDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� Synonym';
      SQL.Text:='EXECUTE PROCEDURE SynonymDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� SynonymFirmCr';
      SQL.Text:='EXECUTE PROCEDURE SynonymFirmCrDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� Defectives';
      SQL.Text:='EXECUTE PROCEDURE DefectivesDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� Registry';
      SQL.Text:='EXECUTE PROCEDURE RegistryDelete'; ExecQuery;

      UpTran.Commit;
    except
      UpTran.Rollback;
      raise;
    end;
  finally
    Screen.Cursor:=crDefault;
    MainForm.StatusText:='';
  end;
end;

function TDM.GetCurrentOrderId(ClientId, PriceCode, RegionCode: Integer;
  CreateIfNotExists: Boolean=True): Integer;
var
  NRecs: Integer;
begin
  with adsSelect do begin
    SelectSQL.Text:=Format('SELECT OrderId FROM OrdersH WHERE ClientId=%d And PriceCode=%d And RegionCode=%d And Closed = 0',
      [ClientId, PriceCode, RegionCode]);
    Open;
    try
      NRecs:=RecordCount;
      Result:=Fields[0].AsInteger;
    finally
      Close;
    end;
  end;
  if NRecs=0 then begin
    if CreateIfNotExists then with adcUpdate do begin
      SQL.Text:=Format('INSERT INTO OrdersH (ClientId,PriceCode,RegionCode) VALUES (%d,%d,%d)',
        [ClientId, PriceCode, RegionCode]);
      ExecQuery;
      Result:=GetCurrentOrderId(ClientId,PriceCode,RegionCode,False);
      if Result=0 then raise Exception.Create('�� ������� ������� ��������� ������');
    end
    else
      Result:=0;
  end
  else if NRecs>1 then
    raise Exception.Create('�� ������ �������, �����-����� � ������� ������� ������ ������ ��������������� ������');
end;

procedure TDM.DeleteEmptyOrders;
begin
  Screen.Cursor:=crHourglass;
  try
    UpTran.StartTransaction;
    try
      with adcUpdate do begin
        SqL.Text:='EXECUTE PROCEDURE OrdersDeleteEmpty'; ExecQuery;
        SQL.Text:='EXECUTE PROCEDURE OrdersHDeleteEmpty'; ExecQuery;
      end;
      UpTran.Commit;
    except
      UpTran.Rollback;
      raise;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

{ ��������� ��������� �������� ������ ������� }
procedure TDM.SetImportStage( AValue: integer);
begin
  DM.adtParams.Edit;
  DM.adtParams.FieldByName( 'ImportStage').AsInteger := AValue;
  DM.adtParams.Post;
end;

function TDM.GetImportStage: integer;
begin
  result := DM.adtParams.FieldByName( 'ImportStage').AsInteger;
end;

procedure TDM.BackupDatabase( APath: string);
begin
  MainConnection1.Close;
  Windows.CopyFile( PChar( APath + DatabaseName),
    PChar( APath + ChangeFileExt( DatabaseName, '.bak')), False);
end;

function TDM.IsBackuped( APath: string): boolean;
begin
  result := FileExists( APath + ChangeFileExt( DatabaseName, '.bak'));
end;

procedure TDM.RestoreDatabase( APath: string);
begin
  OSMoveFile(APath + ChangeFileExt( DatabaseName, '.bak'), APath + DatabaseName);
end;

procedure TDM.ClearBackup( APath: string);
var
  MoveRes : Boolean;
  BackupFileName,
  TemplateEtlName,
  NewEtlName : String;
  N : Integer;
begin
  BackupFileName := APath + ChangeFileExt( DatabaseName, '.bak');
  TemplateEtlName := APath + DatabaseName + '.etl';
  NewEtlName := TemplateEtlName;
  N := 0;
  repeat
    Windows.DeleteFile(PChar(NewEtlName));
    MoveRes := Windows.MoveFile(PChar(BackupFileName), PChar(NewEtlName));
    if not MoveRes then begin
      if N <= 255 then begin
        NewEtlName := TemplateEtlName + '.e' + IntToHex(N, 2);
        Inc(N);
      end
      else
        Break;
    end;
  until MoveRes;
  if not MoveRes then
    Windows.DeleteFile( PChar( BackupFileName ) );
end;

procedure TDM.ResetExclusive;
begin
  { ������ ������� �� ����������� ������ }
  MainForm.CS.Enter;
  try
    try
      adtFlags.Edit;
      adtFlags.FieldByName( 'ComputerName').AsString := '';
      adtFlags.FieldByName( 'ExclusiveID').AsString := '';
      adtFlags.Post;
    except
    end;
  finally
    MainForm.CS.Leave;
  end;
end;

procedure TDM.SetExclusive;
begin
  { ��������� ������� �� ����������� ������ }
  MainForm.CS.Enter;
  try
    try
      adtFlags.Edit;
      adtFlags.FieldByName( 'ComputerName').AsString := GetComputerName_;
      adtFlags.FieldByName( 'ExclusiveID').AsString := GetExclusiveID();
      adtFlags.Post;
    except
    end;
  finally
    MainForm.CS.Leave;
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

procedure TDM.MainConnection1AfterConnect(Sender: TObject);
begin
  //��������� ������� � �����������
  adtParams.CloseOpen(True);
  ReadPasswords;
  adtProvider.CloseOpen(True);
  adtReclame.CloseOpen(True);
  adtClients.CloseOpen(True);
  adsRetailMargins.CloseOpen(True);
  LoadRetailMargins;
  LoadSelectedPrices;
  try
    adtFlags.CloseOpen(True);
  except
  end;
end;

procedure TDM.SweepDB;
begin
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
var
  Price : String;
  tmps,
  tmpc,
  tmpb,
  tmpvb : TINFCrypt;
begin
  if (SynonymPassword <> ASyn) or (CodesPassword <> ACodes) or (BaseCostPassword <> AB) then
    try
      UpTran.StartTransaction;
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
      UpTran.Commit;
    except
      on E : Exception do begin
        Tracer.TR('SavePass', 'Error : ' + E.Message);
        UpTran.Rollback;
      end;
    end;

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
    adsRepareOrdersCryptPRICE.AsCurrency := StrToFloat(DM.D_B_N(adsRepareOrdersPRICE.AsString));
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

procedure TDM.adsRetailMarginsLEFTLIMITChange(Sender: TField);
begin
//  adsRetailMargins.DoSort(['LEFTLIMIT'], [True]);
end;

procedure TDM.socf(DataSet: TDataSet);
var
  S : String;
begin
  try
    S := D_B_N(adsSumOrdersPRICE.AsString);
    adsSumOrdersCryptPRICE.AsCurrency := StrToCurr(S);
    adsSumOrdersSumOrders.AsCurrency := StrToCurr(S) * adsSumOrdersORDERCOUNT.AsInteger;
  except
  end;
end;

function TDM.GetAllSumOrder: Currency;
begin
  Result := AllSumOrder;
end;

procedure TDM.SetNewOrderCount(ANewOrderCount: Integer;
  ABaseCost: Currency; APriceCode, ARegionCode : Integer);
var
  CurrOI : TOrderInfo;
begin
  CurrOI := FindOrderInfo(APriceCode, ARegionCode);
  AllSumOrder := AllSumOrder + ( ANewOrderCount - OldOrderCount) * ABaseCost;
  CurrOI.Summ := CurrOI.Summ + ( ANewOrderCount - OldOrderCount) * ABaseCost;
end;

procedure TDM.SetOldOrderCount(AOldOrderCount: Integer);
begin
  OldOrderCount := AOldOrderCount;
end;

procedure TDM.InitAllSumOrder;
var
  CurrOrderInfo : TOrderInfo;
begin
  //������� ������ �� �������
  ClearSelectedPrices(OrdersInfo);
  AllSumOrder := 0;
 	adsOrdersHeaders.Close;
  //�������� ���������� � ������� ������������ �������
	adsOrdersHeaders.ParamByName( 'AClientId').Value := adtClients.FieldByName( 'ClientId').Value;
	adsOrdersHeaders.ParamByName( 'AClosed').Value := False;
	adsOrdersHeaders.ParamByName( 'ASend').Value := True;
	adsOrdersHeaders.ParamByName( 'TimeZoneBias').Value := 0;
	adsOrdersHeaders.Open;
  try
  while not adsOrdersHeaders.Eof do begin
    CurrOrderInfo := FindOrderInfo(adsOrdersHeaders.FieldByName('PriceCode').AsInteger, adsOrdersHeaders.FieldByName('RegionCode').AsInteger);
    CurrOrderInfo.Summ := GetSumOrder(adsOrdersHeaders.FieldByName('OrderID').AsInteger);
    AllSumOrder := AllSumOrder + CurrOrderInfo.Summ;
    adsOrdersHeaders.Next;
  end;
  finally
   	adsOrdersHeaders.Close;
  end;

	adsOrdersHeaders.ParamByName( 'ASend').Value := False;
	adsOrdersHeaders.Open;
  try
  while not adsOrdersHeaders.Eof do begin
    CurrOrderInfo := FindOrderInfo(adsOrdersHeaders.FieldByName('PriceCode').AsInteger, adsOrdersHeaders.FieldByName('RegionCode').AsInteger);
    CurrOrderInfo.Summ := GetSumOrder(adsOrdersHeaders.FieldByName('OrderID').AsInteger);
    AllSumOrder := AllSumOrder + CurrOrderInfo.Summ;
    adsOrdersHeaders.Next;
  end;
  finally
   	adsOrdersHeaders.Close;
  end;
end;

procedure TDM.ResetReclame;
begin
  UpdateReclameDT := 0;
end;

procedure TDM.SetReclame;
begin
  UpdateReclameDT := Now();
end;

procedure TDM.UpdateReclame;
begin
  if (UpdateReclameDT > 1) then begin
    adtReclame.Edit;
    adtReclame.FieldByName( 'UpdateDateTime').AsDateTime := UpdateReclameDT;
    adtReclame.Post;
  end;
end;

procedure TDM.ocf(DataSet: TDataSet);
var
  S : String;
begin
  try
    S := DM.D_B_N(adsOrderDetails.FieldByName('PRICE').AsString);
    adsOrderDetailsCryptPRICE.AsString := S;
    adsOrderDetailsCryptSUMORDER.AsCurrency := StrToCurr(S) * adsOrderDetails.FieldByName('ORDERCOUNT').AsInteger;
  except
  end;
end;

function TDM.GetSumOrder(AOrderID: Integer): Currency;
var
	V: array[0..0] of Variant;
begin
  try
    with adsOrderDetails do begin
      ParamByName('AOrderId').Value:=AOrderId;
      if Active then CloseOpen(True) else Open;
    end;
    DataSetCalc(adsOrderDetails, ['SUM(CryptSUMORDER)'], V);
    Result := V[0];
  finally
    adsOrderDetails.Close;
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
    DM.adsSelect.Close;
  except
  end;
	DM.adsSelect.SelectSQL.Text := 'SELECT COUNT(*) AS CatNum FROM Catalogs';
	try
		DM.adsSelect.Open;
    try
  		Result := DM.adsSelect.FieldByName( 'CatNum').AsInteger;
    finally
      try
        DM.adsSelect.Close;
      except
      end;
    end;
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
  if adsPrices.Active then
    adsPrices.Close;
  adsPrices.Open;
  try
    adsPrices.DoSort(['PRICENAME'], [True]);
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
      Result := md5.AsHex( md5.HashValue(fs) );
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

procedure TDM.occf(DataSet: TDataSet);
var
  S : String;
begin
  try
    S := D_B_N(adsOrderCoreBASECOST.AsString);
    adsOrderCoreCryptBASECOST.AsCurrency := StrToCurr(S);
  except
  end;
end;

procedure TDM.UpdateDB;
var
  dbCon : TpFIBDatabase;
  trMain : TpFIBTransaction;
  DBVersion : Integer;
  EtlName : String;
begin
  dbCon := TpFIBDatabase.Create(nil);
  try

    trMain := TpFIBTransaction.Create(nil);
    try
      dbCon.DBName := MainConnection1.DBName;
      dbCon.DBParams.Text := MainConnection1.DBParams.Text;
      dbCon.LibraryName := MainConnection1.LibraryName;
      dbCon.SQLDialect := MainConnection1.SQLDialect;
      trMain.DefaultDatabase := dbCon;
      dbCon.DefaultTransaction := trMain;
      dbCon.DefaultUpdateTransaction := trMain;
      dbCon.Open;
{$ifdef DEBUG}
      ExtractDBScript(dbCon);
{$endif}
      DBVersion := dbCon.QueryValue('select mdbversion from provider where id = 0', 0);
      dbCon.Close;

      //��� ������ � 515, �� ��� �������������� �� ���������
      if DBVersion = 41 then begin
        etlname := GetLastEtalonFileName;
        //���� ���������� ��������� ����, �� ��������� ���
        if Length(etlname) > 0 then
          RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, nil);
        RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, nil);
        DBVersion := 42;
      end;

      if DBVersion = 42 then begin
        etlname := GetLastEtalonFileName;
        if Length(etlname) > 0 then
          RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, UpdateDBFileDataFor42);
        RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, UpdateDBFileDataFor42);
        DBVersion := 43;
      end;

      if DBVersion = 43 then begin
        etlname := GetLastEtalonFileName;
        if Length(etlname) > 0 then
          RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, nil);
        RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, nil);
        DBVersion := 44;
      end;

      if DBVersion = 44 then begin
        etlname := GetLastEtalonFileName;
        if Length(etlname) > 0 then
          RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, nil);
        RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, nil);
        DBVersion := 45;
      end;

      if DBVersion = 45 then begin
        etlname := GetLastEtalonFileName;
        if Length(etlname) > 0 then
          RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, nil);
        RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, nil);
        DBVersion := 46;
      end;

      if DBVersion = 46 then begin
        etlname := GetLastEtalonFileName;
        if Length(etlname) > 0 then
          RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, nil);
        RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, nil);
        DBVersion := 47;
      end;

      if DBVersion <> CURRENT_DB_VERSION then
        raise Exception.CreateFmt('������ ���� ������ %d �� ��������� � ����������� ������� %d.', [DBVersion, CURRENT_DB_VERSION])
      //���� � ��� �� ���������� ������, �� ������� �������� ����������� ���� ������
{$ifndef DEBUG}
      else
        RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, CheckDBObjects, nil, '���������� �������� ���� ������. ���������...');
{$else}
        ;
{$endif}

      //���� ���� ����������� ���������� ���������, �� ��������� �����
	    if FindCmdLineSwitch('i') or FindCmdLineSwitch('si') then
        UpdateDBUIN(dbCon, trMain);

    finally
      trMain.Free;
    end;

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
    //����-������ ����� ������� DDL-�������
    FIBScript.AutoDDL := True;

    try

      //������ ����� ���������� ���, ��� �� �������� ��������� �����, �� �� �������� ����
      //���� �� ��� ���������
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

      if Assigned(AOnUpdateDBFileData) then
        AOnUpdateDBFileData(dbCon, trMain);

    finally
      try FIBScript.Free; except  end;
    end;

  finally
    try dbCon.Close; except end;
  end;
end;

function TDM.GetLastEtalonFileName: String;
var
  CurrFileName,
  FindFileName,
  TemplateName : String;
  FindFileAge,
  CurrFileAge : Integer;
	EtlSR: TSearchRec;
begin
  TemplateName := ChangeFileExt(ParamStr(0), '.fdb') + '.etl';
  CurrFileName := TemplateName;
  CurrFileAge := FileAge(CurrFileName);

  if FindFirst( TemplateName + '.e*', faAnyFile, EtlSR) = 0 then
  try

    repeat
      if (EtlSR.Name <> '.') and (EtlSR.Name <> '..')
      then begin
        FindFileName := ExePath + EtlSR.Name;
        FindFileAge := FileAge(FindFileName);
        if FindFileAge > CurrFileAge then begin
          CurrFileName := FindFileName;
          CurrFileAge := FindFileAge;
        end;
      end;
    until (FindNext( EtlSR ) <> 0)

  finally
    SysUtils.FindClose( EtlSR );
  end;

  if not AnsiSameText(TemplateName, CurrFileName) then begin
    if Windows.DeleteFile( PChar( TemplateName ) ) then
      if Windows.MoveFile(PChar(CurrFileName), PChar( TemplateName )) then begin
        DeleteFilesByMask(TemplateName + '.e*', False);
        Result := TemplateName;
      end
      else
        Result := CurrFileName
    else
      Result := CurrFileName;
  end
  else begin
    if CurrFileAge = -1 then
      Result := ''
    else
      Result := TemplateName;
  end;
end;

procedure TDM.OnScriptParseError(Sender: TObject; Error, SQLText: string;
  LineIndex: Integer);
begin
  raise Exception.CreateFmt('������ ��� ������� �������: %s'#13#10'SQL: %s'#13#10'����� ������: %d', [Error, SQLText, LineIndex]);
end;

procedure TDM.OnScriptExecuteError(Sender: TObject; Error, SQLText: string;
  LineIndex: Integer; var Ignore: Boolean);
begin
  raise Exception.CreateFmt('������ ��� ���������� �������: %s'#13#10'SQL: %s'#13#10'����� ������: %d', [Error, SQLText, LineIndex]);
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
      //���� ��� ���� ������, �� ������ �� ������, �����������, ��� ���� ������
      if Length(CDS) = 0 then
        Exit;
      BaseCostPass := PassC.DecodeHex(Copy(CDS, 129, 64));
      if Length(BaseCostPass) = 0 then
        raise Exception.Create('��� ����������� ����������.');
    except
      on E : Exception do
       raise Exception.CreateFmt('���������� ���������� ���������� ������: %s', [E.Message]);
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
        AProc.LogCriticalError('���������� ���������������� ������� � ������� : ' + IntToStr(CryptErrorCount) + ' ����� ������� : ' + IntToStr(AllCount));

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
      on EFIB : EFIBError do begin
        if EFIB.IBErrorCode = isc_network_error then
          LogExitError('�� �������� ������ ��������� � �������� �����. ����������, ����������� ��������� ����.', Integer(ecDBFileError))
        else begin
          LogCriticalError(Format('������ ��� �������� (%d): %s'#13#10'StatusVector : %s', [RecoveryCount, EFIB.Message, StatusVectorAsText]));
          if (RecoveryCount < 2) then begin
            try
              //TODO: ����� ���� ��������� �������� � ������, ����� �������� ������� ������
              if (EFIB.IBErrorCode = isc_sys_request) and FileExists(MainConnection1.DBName) then begin
                LogCriticalError(Format('������ ��� �������� (CreateFile): %s', [EFIB.Message]));
                Sleep(1000);
              end
              else
                RecoverDatabase(EFIB);
            except
              on E : Exception do
                if (RecoveryCount < 1) then
                  LogCriticalError(Format('������ ��� �������������� (%d): %s', [RecoveryCount, E.Message]))
                else
                  raise;
            end;
            Inc(RecoveryCount);
          end
          else
            raise;
        end;
      end;

      on E : Exception do begin
        LogCriticalError(Format('������ ��� �������� (%d): %s', [RecoveryCount, E.Message]));
        if (RecoveryCount < 2) then begin
          try
            RecoverDatabase(E);
          except
            on E : Exception do
              if (RecoveryCount < 1) then
                LogCriticalError(Format('������ ��� �������������� (%d): %s', [RecoveryCount, E.Message]))
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
      LogExitError(Format( '�� �������� ������� ���� ���� ������: %s ', [ E.Message ]), Integer(ecDBFileError));
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
      //���� ��� ���� ������, �� ������ �� ������, �����������, ��� ���� ������
      if Length(CDS) = 0 then
        Exit;

      BaseCostPass := PassC.DecodeHex(Copy(CDS, 129, 64));
      if Length(BaseCostPass) = 0 then
        raise Exception.Create('��� ����������� ���������� 1.');

      CodesPass := PassC.DecodeHex(Copy(CDS, 65, 64));
      if Length(CodesPass) = 0 then
        raise Exception.Create('��� ����������� ���������� 2.');
    except
      on E : Exception do
       raise Exception.CreateFmt('���������� ���������� ���������� ������: %s', [E.Message]);
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
        AProc.LogCriticalError('���������� ���������������� ������� � ������� : ' + IntToStr(CryptErrorCount) + ' ����� ������� : ' + IntToStr(AllCount));

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
      //���� ��� ���� ������, �� ������ �� ������, �����������, ��� ���� ������
      if Length(CDS) = 0 then
        Exit;
      SynonymPass := pc.DecodeHex(Copy(CDS, 1, 64));
      CodesPass := pc.DecodeHex(Copy(CDS, 65, 64));
      BaseCostPass := pc.DecodeHex(Copy(CDS, 129, 64));
      oldDBUIN := pc.DecodeHex(Copy(CDS, 193, 32));

      if Length(BaseCostPass) = 0 then
        raise Exception.Create('��� ����������� ����������.');
      if Length(oldDBUIN) = 0 then
        raise Exception.Create('��� ����������� ���������� 2.');
      if oldDBUIN <> ch then
        raise Exception.Create('�� ��������� DBUIN � ����������� ���� ������.');

      //��������� �������� CDS � ���� � ����� CopyID
      newCDS :=
        PassC.EncodeHex(SynonymPass) +
        PassC.EncodeHex(CodesPass) +
        PassC.EncodeHex(BaseCostPass) +
        PassC.EncodeHex(IntToHex(GetCopyID, 8));
      dbCon.QueryValue('update params set CDS = :CDS where ID = 0', -1, [newCDS]);
    except
      on E : Exception do
       raise Exception.CreateFmt('���������� ���������� ���������� ������: %s', [E.Message]);
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
        AProc.LogCriticalError('���������� ���������������� ������� � ������� : ' + IntToStr(CryptErrorCount) + ' ����� ������� : ' + IntToStr(AllCount));

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
    //���� ��� ���� ������, �� ������ �� ������, �����������, ��� ���� ������
    if Length(CDS) = 0 then
      Exit;
    SynonymPass := PassC.DecodeHex(Copy(CDS, 1, 64));
    CodesPass := PassC.DecodeHex(Copy(CDS, 65, 64));
    BaseCostPass := PassC.DecodeHex(Copy(CDS, 129, 64));
    oldDBUIN := PassC.DecodeHex(Copy(CDS, 193, 32));

    if Length(BaseCostPass) = 0 then
      raise Exception.Create('��� ����������� ����������.');
    if Length(oldDBUIN) = 0 then
      raise Exception.Create('��� ����������� ���������� 2.');

    //��������� �������� CDS � ���� � ����� CopyID
    newCDS :=
      PassC.EncodeHex(SynonymPass) +
      PassC.EncodeHex(CodesPass) +
      PassC.EncodeHex(BaseCostPass) +
      PassC.EncodeHex(oldDBUIN + '0000001');
    dbCon.QueryValue('update params set CDS = :CDS where ID = 0', -1, [newCDS]);
  except
    on E : Exception do
     raise Exception.CreateFmt('���������� ���������� ���������� ������: %s', [E.Message]);
  end;

  trMain.Commit;
end;
{$endif}


procedure TDM.SetSendToNotClosedOrders;
begin
  adcUpdate.Transaction.StartTransaction;
  try
    adcUpdate.SQL.Text := 'update ORDERSH set Send = 1 where (Closed = 0)';
    adcUpdate.ExecQuery;
    adcUpdate.Transaction.Commit;
  except
    adcUpdate.Transaction.Rollback;
    raise;
  end;
end;

{ TOrderInfo }

constructor TOrderInfo.Create(APriceCode, ARegionCode : Integer);
begin
  Summ := 0;
  PriceCode := APriceCode;
  RegionCode := ARegionCode;
end;

function TDM.FindOrderInfo(APriceCode, ARegionCode: Integer): TOrderInfo;
var
  Index : Integer;
  OrderIDStr : String;
begin
  OrderIDStr := IntToStr(APriceCode) + '_' + IntToStr(ARegionCode);
  if OrdersInfo.Find(OrderIDStr, Index) then
    Result := TOrderInfo(OrdersInfo.Objects[Index])
  else begin
    Result := TOrderInfo.Create(APriceCode, ARegionCode);
    OrdersInfo.AddObject(OrderIDStr, Result);
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
  Result :=
    'SET SQL DIALECT 3;'#13#10#13#10 +
    'SET NAMES WIN1251;'#13#10#13#10 +
    //TODO: ����� ���� ��������� ��������� ���� ���� ������ � ����������� �� ���� ����� ������
    Format('CREATE DATABASE ''%s'' USER ''SYSDBA'' PASSWORD ''masterkey'' PAGE_SIZE 4096 DEFAULT CHARACTER SET WIN1251;'#13#10#13#10,
      [ChangeFileExt(ParamStr(0), '.fdb')]);
  Result := Concat(Result, GetLastCreateScript());
  Result := Concat(Result,
    'SET GENERATOR GEN_CORE_ID TO 0;'#13#10#13#10 +
    'SET GENERATOR GEN_ORDERSH_ID TO 0;'#13#10#13#10 +
    'SET GENERATOR GEN_ORDERS_ID TO 0;'#13#10#13#10 +
    'SET GENERATOR GEN_REGISTRY_ID TO 0;'#13#10#13#10 +
    'SET GENERATOR GEN_RETAILMARGINS_ID TO 1;'#13#10#13#10 +
    'COMMIT WORK;'#13#10#13#10 +
    'INSERT INTO FLAGS (ID, COMPUTERNAME, EXCLUSIVEID) VALUES (0, NULL, NULL);'#13#10#13#10 +
    'COMMIT WORK;'#13#10#13#10 +
    'INSERT INTO PARAMS (ID, CLIENTID, RASCONNECT, RASENTRY, RASNAME, RASPASS, CONNECTCOUNT, CONNECTPAUSE, PROXYCONNECT, PROXYNAME, PROXYPORT, PROXYUSER, PROXYPASS, SERVICENAME, HTTPHOST, HTTPPORT, HTTPNAME, HTTPPASS, UPDATEDATETIME, LASTDATETIME, FASTPRINT, ' +
      'SHOWREGISTER, NEWWARES, USEFORMS, OPERATEFORMS, OPERATEFORMSSET, AUTOPRINT, STARTPAGE, LASTCOMPACT, CUMULATIVE, STARTED, EXTERNALORDERSEXE, EXTERNALORDERSPATH, EXTERNALORDERSCREATE, RASSLEEP, HTTPNAMECHANGED, SHOWALLCATALOG, CDS, ORDERSHISTORYDAYCOUNT, ' +
      'CONFIRMDELETEOLDORDERS, USEOSOPENWAYBILL, USEOSOPENREJECT, GROUPBYPRODUCTS, PRINTORDERSAFTERSEND) VALUES ' +
      '(0, NULL, 0, NULL, NULL, NULL, 5, 5, 0, NULL, NULL, NULL, NULL, ''GetData'', ''ios.analit.net'', 80, NULL, NULL, NULL, NULL, 0, 1, 0, 1, 0, 0, 0, 0, NULL, 0, 0, NULL, NULL, 0, 3, 1, 0, '''', 21, 1, 0, 1, 0, 0);'#13#10#13#10 +
    'COMMIT WORK;'#13#10#13#10 +
    'INSERT INTO PROVIDER (ID, NAME, ADDRESS, PHONES, EMAIL, WEB, MDBVERSION) VALUES (0, ''�� "�������"'', ''��������� ��-�, 160 ��.415'', ''4732-606000'', ''farm@analit.net'', ''http://www.analit.net/'', ' + IntToStr(CURRENT_DB_VERSION) +');'#13#10#13#10 +
    'COMMIT WORK;'#13#10#13#10 +
    'INSERT INTO RECLAME (RECLAMEURL, UPDATEDATETIME) VALUES (''http://ios.analit.net/results/reclame/r#.zip'', NULL);'#13#10#13#10 +
    'COMMIT WORK;'#13#10#13#10 +
    'INSERT INTO RETAILMARGINS (ID, LEFTLIMIT, RIGHTLIMIT, RETAIL) VALUES (0, 0, 1000000, 30);'#13#10#13#10 +
    'COMMIT WORK;'#13#10#13#10
    );
end;

procedure TDM.CreateClearDatabaseFromScript(dbCon : TpFIBDatabase; trMain : TpFIBTransaction; FileName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData);
var
 FIBScript : TpFIBScript;
begin
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
end;

procedure TDM.RecoverDatabase(E: Exception);
var
  DBErrorMess : String;
  N : Integer;
  OldDBFileName,
  EtalonDBFileName,
  ErrFileName : String;
begin
  //TODO: �������������� �� ��������� ����� �������� � ������� ������. ���� ������!!!
  {
  ����� �� ������ �������:
  1. ������� ����������, ���� �������
  2. ��������� ��� ������ ��� ��������
  3. ������������� � ��������� ���� ������
  4. ����������� �� ��������� ���� ������
  5. ������� ��������� ���� ������
  }
  DBErrorMess := Format('�� ������� ������� ���� ������ ���������.'#13#10 +
    '������        : %s'#13#10,
    [E.Message]
  );
  if (E is EFIBError) then
    DBErrorMess := DBErrorMess +
      Format(
        '��� SQL       : %d'#13#10 +
        '��������� SQL : %s'#13#10 +
        '��� IB        : %d'#13#10 +
        '��������� IB  : %s',
        [EFIBError(E).SQLCode, EFIBError(E).SQLMessage, EFIBError(E).IBErrorCode, EFIBError(E).IBMessage]
    );

  //�������� ����� ��������� ���� ���� ������, ����� ������������ � ��������������� ��� ���������
  EtalonDBFileName := GetLastEtalonFileName;

  if Length(EtalonDBFileName) = 0 then
    DBErrorMess := DBErrorMess + #13#10#13#10 + '����� ����������� �������� ���� ������.'
  else
    DBErrorMess := DBErrorMess + #13#10#13#10 + '����� ����������� �������������� �� ��������� �����.';

  //�������� ���� �������� � ���������� ������������
  AProc.LogCriticalError(DBErrorMess);
  AProc.MessageBox(DBErrorMess, MB_ICONERROR or MB_OK);

  //��������� ��� ���������� �����
  ErrFileName := ChangeFileExt(ParamStr(0), '.e');
  N := 0;
  while (FileExists(ErrFileName + IntToHex(N, 2)) and (N <= 255)) do Inc(N);

  if N > 255 then begin
    //����� ��������� ������ - ����� ��� �������
    DeleteFilesByMask(ErrFileName + '*', False);
    N := 0;
  end;

  ErrFileName := ErrFileName + IntToHex(N, 2);
  OldDBFileName := ChangeFileExt(ParamStr(0), '.fdb');

  if FileExists(OldDBFileName) then
    if not Windows.MoveFile(PChar(OldDBFileName), PChar(ErrFileName)) then
      raise Exception.CreateFmt('�� ������� ������������� � ��������� ���� %s : %s',
        [ErrFileName, SysErrorMessage(GetLastError)]);

  if Length(EtalonDBFileName) = 0 then begin
    RunUpdateDBFile(nil, nil, '', CURRENT_DB_VERSION, CreateClearDatabaseFromScript, nil, '���������� �������� ���� ������. ���������...');
    FCreateClearDatabase := True;
    FNeedImportAfterRecovery := False;
    WriteExchangeLog('AnalitF', '����������� �������� ����.');
  end
  else
    if Windows.MoveFile(PChar(EtalonDBFileName), PChar(OldDBFileName)) then begin
      //������ ������������ �� �������
      FNeedImportAfterRecovery := True;
      WriteExchangeLog('AnalitF', '����������� ����������� �� ��������� �����.');
    end
    else
      raise Exception.CreateFmt('�� ������� ����������� �� ��������� ����� : %s',
        [SysErrorMessage(GetLastError)]);
end;

procedure TDM.CheckDBObjects(dbCon: TpFIBDatabase;
  trMain: TpFIBTransaction; FileName: String; OldDBVersion: Integer;
  AOnUpdateDBFileData: TOnUpdateDBFileData);
var
  exc : TpFIBExtract;
  ExistsScript, RightScript : String;
begin
  dbCon.Open;
  try
    exc := TpFIBExtract.Create(nil);
    try
      exc.Database := dbCon;
      exc.Transaction := trMain;
      exc.IncludeSetTerm := False;
      exc.ExtractOptions := exc.ExtractOptions - [CreateDb];
      exc.ExtractObject(eoDatabase);

      //������� ������ ��� ������ �� �������
      exc.Items.Delete(0);
      exc.Items.Delete(0);

      //exc.Items.SaveToFile('extract.log');

      ExistsScript := Trim(exc.Items.Text);
    finally
      exc.Free;
    end;
  finally
    dbCon.Close;
  end;

  RightScript := Trim(GetLastCreateScript());

  if ExistsScript <> RightScript then begin
    LogCriticalError('������ � ������������� �����������:'#13#10 + ExistsScript);
    raise Exception.Create('���� ������ �������� ������������ ����������.');
  end;
end;

procedure TDM.ProcessDocs;
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
procedure TDM.ExtractDBScript(dbCon: TpFIBDatabase);
var
  exc : TpFIBExtract;
begin
  exc := TpFIBExtract.Create(nil);
  try
    exc.Database := dbCon;
    exc.Transaction := TpFIBTransaction(dbCon.DefaultTransaction);
    exc.IncludeSetTerm := False;
    exc.ExtractOptions := exc.ExtractOptions - [CreateDb];
    exc.ExtractObject(eoDatabase);
    exc.Items.SaveToFile('extract.sql');
  finally
    exc.Free;
  end;
end;
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
	SetHTTP.Request.Username := adtParams.FieldByName( 'HTTPName').AsString;
	SetHTTP.Port := adtParams.FieldByName( 'HTTPPort').AsInteger;
	SetHTTP.Host := ExtractURL( adtParams.FieldByName( 'HTTPHost').AsString);
  SetHTTP.AllowCookies := True;
  SetHTTP.HandleRedirects := True;
  SetHTTP.HTTPOptions := [hoInProcessAuth, hoKeepOrigProtocol, hoForceEncodeParams];
  SetHTTP.MaxLineAction := maException;
  SetHTTP.RecvBufferSize := 1024;
  SetHTTP.SendBufferSize := 1024;
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
    //���� ��� ���� ������, �� ������ �� ������, �����������, ��� ���� ������
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
      raise Exception.Create('��� ����������� ����������.');
    if Length(oldDBUIN) = 0 then
      raise Exception.Create('��� ����������� ���������� 2.');
    if oldDBUIN <> IntToHex(GetCopyID(), 8) then
      raise Exception.Create('�� ��������� DBUIN � ����������� ���� ������.');

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

    //��������� �������� CDS � ���� � ����� CopyID
    dbCon.QueryValue('update params set CDS = :CDS where ID = 0', -1, [newCDS]);
  except
    on E : Exception do
     raise Exception.CreateFmt('���������� ���������� ���������� ������: %s', [E.Message]);
  end;

  trMain.Commit;
end;
{$endif}

procedure TDM.UpdateDBUIN(dbCon: TpFIBDatabase; trMain: TpFIBTransaction);
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
      trMain.StartTransaction;

      CDS := dbCon.QueryValue('select CDS from params where ID = 0', 0);
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
      dbCon.QueryValue('update params set CDS = :CDS where ID = 0', -1, [newCDS]);

      trMain.Commit;
    finally
      try dbCon.Close(); except end;
    end;
  except
    on E : Exception do begin
      AProc.LogCriticalError('������ ��� ���������� UIN : ' + E.Message);
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
    //����������� ���������� ������������� ��� ������� exe (525) �� ������ �������
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
      //���� ��� ���� ������, �� ������ �� ������, �����������, ��� ���� ������
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
      raise Exception.Create('��� ����������� ����������.');
    if Length(oldDBUIN) = 0 then
      raise Exception.Create('��� ����������� ���������� 2.');

    //��������� �������� CDS � ���� � ����� CopyID
    //������� ������ � ���������� ��������������� ������� exe (525) �� ����� �������
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
     raise Exception.CreateFmt('���������� ���������� ���������� ������: %s', [E.Message]);
  end;

  trMain.Commit;

  trMain.StartTransaction;

  dbCon.QueryValue('select count(*) from MinPrices where ServerCoreID is not null', 0);

  dbCon.QueryValue('select count(*) from Core where productid is not null', 0);

  dbCon.QueryValue('select count(*) from PricesData where PriceFileDate is not null', 0);

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
  //�������� ���������� � ������� ������������ �������
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
        //������� ������
        frVariables[ 'OrderId'] := adsOrdersHeaders.FieldByName('OrderId').AsVariant;
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
