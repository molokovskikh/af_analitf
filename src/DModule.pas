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
  pFIBProps, U_UpdateDBThread;

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
  //способ вычисления разницы в цены от другого поставщика
  //pdmPrev - от предыдущего Поставщика, pdmMin - от Поставщика с min ценой,
  //pdmMinEnabled - от Основн.Пост. с min ценой
  TPriceDeltaMode =( pdmPrev, pdmMin, pdmMinEnabled);

  //exit codes - Коды ошибок выхода из программы
  TAnalitFExitCode = (ecOK, ecDBFileNotExists, ecDBFileReadOnly, ecDBFileError,
    ecDoubleStart, ecColor, ecTCPNotExists, ecUserLimit, ecFreeDiskSpace,
    ecGetFreeDiskSpace, ecIE40, ecSevenZip, ecNotCheckUIN, ecSSLOpen, ecNotChechHashes,
    ecDBUpdateError, ecDiffDBVersion);

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
    adsSelect3: TpFIBDataSet;
    adsCore: TpFIBDataSet;
    adsOrdersH: TpFIBDataSet;
    adsOrders: TpFIBDataSet;
    BackService: TpFIBBackupService;
    RestService: TpFIBRestoreService;
    ConfigService: TpFIBConfigService;
    ValidService: TpFIBValidationService;
    t: TpFIBQuery;
    UpTran: TpFIBTransaction;
    adsSelect3ID: TFIBBCDField;
    adsSelect3COREID: TFIBBCDField;
    adsSelect3PRICECODE: TFIBBCDField;
    adsSelect3REGIONCODE: TFIBBCDField;
    adsSelect3CODE: TFIBStringField;
    adsSelect3CODECR: TFIBStringField;
    adsSelect3SYNONYMCODE: TFIBBCDField;
    adsSelect3SYNONYMFIRMCRCODE: TFIBBCDField;
    adsSelect3SYNONYMNAME: TFIBStringField;
    adsSelect3SYNONYMFIRM: TFIBStringField;
    adsSelect3JUNK: TFIBBooleanField;
    adsSelect3AWAIT: TFIBBooleanField;
    adsSelect3ORDERCOUNT: TFIBIntegerField;
    adsSelect3PRICENAME: TFIBStringField;
    adsSelect3CryptPRICE: TCurrencyField;
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
    adsCoreMINPRICE: TFIBBCDField;
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
    adsOrdersCryptSUMORDER: TCurrencyField;
    adsOrdersORDERID: TFIBBCDField;
    adsOrdersCLIENTID: TFIBBCDField;
    adsOrdersCOREID: TFIBBCDField;
    adsOrdersFULLCODE: TFIBBCDField;
    adsOrdersCODEFIRMCR: TFIBBCDField;
    adsOrdersSYNONYMCODE: TFIBBCDField;
    adsOrdersSYNONYMFIRMCRCODE: TFIBBCDField;
    adsOrdersCODE: TFIBStringField;
    adsOrdersCODECR: TFIBStringField;
    adsOrdersSYNONYMNAME: TFIBStringField;
    adsOrdersSYNONYMFIRM: TFIBStringField;
    adsOrdersORDERCOUNT: TFIBIntegerField;
    adsAllOrders: TpFIBDataSet;
    adsAllOrdersID: TFIBBCDField;
    adsAllOrdersORDERID: TFIBBCDField;
    adsAllOrdersCLIENTID: TFIBBCDField;
    adsAllOrdersCOREID: TFIBBCDField;
    adsAllOrdersFULLCODE: TFIBBCDField;
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
    adsPricesUPCOST: TFIBBCDField;
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
    adsSelect3PRICE: TFIBStringField;
    adsCoreBASECOST: TFIBStringField;
    adsCoreORDERSPRICE: TFIBStringField;
    adsOrdersPRICE: TFIBStringField;
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
    adsOrdersSENDPRICE: TFIBBCDField;
    adsOrdersAWAIT: TFIBBooleanField;
    adsOrdersJUNK: TFIBBooleanField;
    adsOrdersID: TFIBBCDField;
    procedure DMCreate(Sender: TObject);
    procedure adtClientsAfterOpen(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure MainConnection1AfterConnect(Sender: TObject);
    procedure adsRetailMarginsLEFTLIMITChange(Sender: TField);
  private
    //Требуется ли подтверждение обмена
    FNeedCommitExchange : Boolean;
    SynonymPassword,
    CodesPassword,
    BaseCostPassword,
    DBUIN : String;
    //Требуется обновления из-за того, что некорректный UIN
    NeedUpdateByCheckUIN : Boolean;
    //Требуется обновления из-за того, что некорректные Hash'и компонент
    NeedUpdateByCheckHashes : Boolean;
    //Требуется импорт после восстановления из эталонной копии
    NeedImportAfterRecovery : Boolean;
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
    //Проверяем версию базы и обновляем ее в случае необходимости
    procedure UpdateDB;
    //Проверяем и обновляем определенный файл
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
    //Обновление определенных данных в таблице
    procedure UpdateDBFileDataFor35(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor29(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor36(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    procedure UpdateDBFileDataFor37(dbCon : TpFIBDatabase; trMain : TpFIBTransaction);
    //Установить галочку отправить для текущих заказов
    procedure SetSendToNotClosedOrders;
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
    function Unpacked: boolean;
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
    procedure SetNeedCommitExchange;
    procedure ResetNeedCommitExchange;

    //Эти процедуры нужны для того, чтобы корректно применять дату обновления рекламы
    procedure ResetReclame;
    procedure SetReclame;
    procedure UpdateReclame;
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

    procedure InitAllSumOrder;
    procedure SetOldOrderCount(AOldOrderCount : Integer);
    procedure SetNewOrderCount(ANewOrderCount : Integer; ABaseCost : Currency; APriceCode, ARegionCode : Integer);
    function GetAllSumOrder : Currency;
    function GetSumOrder (AOrderID : Integer) : Currency;
    function FindOrderInfo (APriceCode, ARegionCode : Integer) : TOrderInfo;
  end;

var
  DM: TDM;
  PassC : TINFCrypt;
  SummarySelectedPrices,
  SynonymSelectedPrices : TStringList;

procedure ClearSelectedPrices(SelectedPrices : TStringList);

function GetSelectedPricesSQL(SelectedPrices : TStringList; Suffix : String = '') : String;

implementation

{$R *.DFM}

uses AProc, Main, DBProc, Exchange, Constant, SysNames, UniqueID, RxVerInf,
     U_FolderMacros, LU_Tracer, LU_MutexSystem, Config;

var
  ch, p : String;
  I : Integer;

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
  SerBeg := '2AFF';
  SerEnd := '674C';
  HTTPS := 'rkhgjsdk';
  HTTPE := 'fhhjfgfh';

  OrdersInfo := TStringList.Create;
  OrdersInfo.Sorted := True;

  adsSelect3.OnCalcFields := s3cf;
  adsOrders.OnCalcFields := ocf;
  adsSumOrders.OnCalcFields := socf;
  adsOrderCore.OnCalcFields := occf;

  SynC := TINFCrypt.Create('', 300);
  CodeC := TINFCrypt.Create('', 60);
  BasecostC := TINFCrypt.Create('', 50);
  HTTPC := TINFCrypt.Create(HTTPS + HTTPE, 255);

  ResetNeedCommitExchange;
  GetLocaleFormatSettings(0, FFS);

  MainConnection1.DBName := ExePath + DatabaseName;

  if not IsOneStart then begin
    MessageBox( 'Запуск двух копий программы на одном компьютере невозможен.',
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecDoubleStart) );
  end;

  if FileExists(ExePath + DatabaseName) and ((FileGetAttr(ExePath + DatabaseName) and SysUtils.faReadOnly) = SysUtils.faReadOnly)
  then begin
    MessageBox( Format( 'Файл базы данных %s имеет атрибут "Только чтение".', [ ExePath + DatabaseName ]),
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecDBFileReadOnly) );
  end;

  //Делаем проверку файла базы данных и в случае проблем производим восстановление из эталонной копии
  CheckDBFile;

  LDBFileName := ChangeFileExt(ExeName, '.ldb');
  DBCompress := FileExists(LDBFileName) and DeleteFile(LDBFileName);


  //Делаем проверки на необходимость обновить базу в любом случае
  UpdateDB;

  try
    try
      CheckRestrictToRun;
    finally
      MainConnection1.Close;
    end;
  except
    on E : Exception do begin
      MessageBox( Format( 'Не возможно открыть файл базы данных : %s ', [ E.Message ]),
        MB_ICONERROR or MB_OK);
      ExitProcess( Integer(ecDBFileError) );
    end;
  end;

  MainConnection1.Open;
  { устанавливаем текущие записи в Clients и Users }
  if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
    then adtClients.First;
  //Проверяем, что работа с программой была завершена корректно
  if DBCompress then
  begin
    MessageBox(
      'Последний сеанс работы с программой не был корректно завершен. '+
        'Сейчас будет произведено сжатие базы данных.');
    MainForm.FreeChildForms;
    RunCompactDataBase;
    MessageBox( 'Сжатие базы данных завершено.');
  end;
  SetStarted;
  //MainForm.dblcbClients.KeyValue:=adtClients.FieldByName('ClientId').Value;
  ClientChanged;
  { устанавливаем параметры печати }
  frReport.Title := Application.Title;
  { проверяем и если надо создаем нужные каталоги }
  if not DirectoryExists( ExePath + SDirDocs) then CreateDir( ExePath + SDirDocs);
  if not DirectoryExists( ExePath + SDirWaybills) then CreateDir( ExePath + SDirWaybills);
  if not DirectoryExists( ExePath + SDirIn) then CreateDir( ExePath + SDirIn);
  if not DirectoryExists( ExePath + SDirReclame) then CreateDir( ExePath + SDirReclame);
  MainForm.SetUpdateDateTime;
  Application.HintPause := 0;

  DeleteFilesByMask(ExePath + SDirIn + '\*.zip', False);
  DeleteFilesByMask(ExePath + SDirIn + '\*.zi_', False);

  SetSendToNotClosedOrders;

  if NeedUpdateByCheckUIN then begin
    if not RunExchange([ eaGetPrice]) then
      ExitProcess( Integer(ecNotCheckUIN) );
  end;

  if NeedUpdateByCheckHashes then begin
    if not RunExchange([ eaGetPrice]) then
      ExitProcess( Integer(ecNotChechHashes) );
  end;

  { Запуск с ключем -e (Получение данных и выход)}
  if FindCmdLineSwitch('e') then
  begin
    MainForm.ExchangeOnly := True;
    RunExchange([ eaGetPrice]);
    Application.Terminate;
  end;
  //"Безмолвное импортирование" - производится в том случае, если была получена новая версия программы при
  if FindCmdLineSwitch('si') then
  begin
    MainForm.ExchangeOnly := True;
    RunExchange([ eaImportOnly]);
    Application.Terminate;
  end;

  //Необходимо выполнить импорт, после восстановления из эталонной копии
  if NeedImportAfterRecovery then begin
    RunCompactDatabase;
    RunExchange([ eaImportOnly ]);
  end;

  if adtParams.FieldByName('HTTPNameChanged').AsBoolean then
    MainForm.DisableByHTTPName;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  if not MainConnection1.Connected then exit;

  try
    adtParams.Edit;
    adtParams.FieldByName( 'ClientId').Value := adtClients.FieldByName( 'ClientId').Value;
    adtParams.Post;
  except
  end;
  ResetStarted;
end;

procedure TDM.ClientChanged;
begin
  MainForm.FreeChildForms;
  MainForm.SetOrdersInfo;
  DoPost(adtParams, True);
  InitAllSumOrder;
end;

{ Проверки на невозможность запуска программы }
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
    if ( ExID = IntToHex( GetUniqueID( Application.ExeName,
      ''), 8)) or ( ExID = '') then exit;

    MessageBox( Format( 'Копия программы на компьютере %s работает в режиме ' + #10 + #13 +
      'монопольного доступ к базе данных. Запуск программы невозможен.', [ CompName]),
      MB_ICONWARNING or MB_OK);
    ExitProcess(3);
  end;
}
  if GetDisplayColors < 16 then begin
    MessageBox( 'Не возможен запуск программы с текущим качеством цветопередачи. Минимальное качество цветопередачи : 16 бит.',
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecColor) );
  end;

  if not TCPPresent then begin
    MessageBox( 'Не возможен запуск программы без установленной библиотеки Windows Sockets версии 2.0.',
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecTCPNotExists) );
  end;

  if not LoadSevenZipDLL then begin
    MessageBox( 'Не найдена библиотека 7-zip32.dll, необходимая для работы программы.',
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecSevenZip) );
  end;

  if not IdSSLOpenSSLHeaders.Load then begin
    MessageBox( 'Не найдены библиотеки libeay32.dll и ssleay32.dll, необходимые для работы программы.',
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecSSLOpen) );
  end;

  DM.MainConnection1.Open;
  try
    MaxUsers := DM.adtClients.FieldByName( 'MaxUsers').AsInteger;
    FGetCatalogsCount := GetCatalogsCount;
    list := DM.MainConnection1.UserNames;
  finally
    DM.MainConnection1.Close;
  end;
  if ( MaxUsers > 0) and ( list.Count > MaxUsers) then
  begin
    MessageBox( Format( 'Исчерпан лимит на подключение к базе данных (копий : %d). ' +
      'Запуск программы невозможен.', [ MaxUsers]),
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecUserLimit) );
  end;

  if GetDiskFreeSpaceEx(PChar(ExtractFilePath(ParamStr(0))), FreeAvail, Total, @TotalFree) then begin
    DBFileSize := GetFileSize(MainConnection1.DBName);
    DBFileSize := Max(2*DBFileSize, 200*1024*1024);
    if DBFileSize > FreeAvail then begin
      MessageBox( Format( 'Недостаточно свободного места на диске для запуска приложения. Необходимо %d байт.', [ DBFileSize ]),
        MB_ICONERROR or MB_OK);
      ExitProcess( Integer(ecFreeDiskSpace) );
    end;
  end
  else begin
    MessageBox( Format( 'Не удается получить количество свободного места на диске.' +
      #13#10#13#10'Сообщение об ошибке:'#13#10'%s', [ SysErrorMessage(GetLastError) ]),
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecGetFreeDiskSpace) );
  end;

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
    MessageBox( 'Ошибка проверки подлинности программы. Необходимо выполнить обновление данных.',
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
    MessageBox( 'Ошибка проверки подлинности компонент программы. Необходимо выполнить обновление данных.',
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
begin
  ok := False;
  //TODO: ___ Процедура не до конца готова. Использовать другое имя для нормального подключения
  Tracer.TR('BackupRestore', 'Start');
  MainConnection1.Close;
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
      ok := True;
    except
      on E : Exception do
        Tracer.TR('BackupRestore', 'Error : ' + E.Message);
    end;
  finally
    Tracer.TR('BackupRestore', 'Stop');
    MainConnection1.Open;
  end;
  if ok then
  begin
    adtParams.Edit;
    adtParams.FieldByName( 'LastCompact').AsDateTime := Now;
    adtParams.Post;
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

//получает информацию об обновлении заданного отношения из TablesUpdates
function TDM.GetTablesUpdatesInfo(ParamTableName: string): string;
begin
  Result:='';
  with adtTablesUpdates do begin
    Open;
    try
      if Locate('TableName',ParamTableName,[loCaseInsensitive]) then
        Result:='Данные обновлены : '+FieldByName('UpdateDate').AsString;
    finally
      Close;
    end;
  end;
end;

//подключает в качестве внешних текстовые таблицы из папки In
procedure TDM.LinkExternalTables;
const
  ExcludeExtTables : array[0..9] of string =
  ('EXTCORE', 'EXTSYNONYM', 'EXTREGISTRY', 'EXTMINPRICES', 'EXTPRICEAVG',
   'EXTCATALOGFARMGROUPS', 'EXTCATALOG', 'EXTCATDEL', 'EXTCATFARMGROUPSDEL',
   'EXTCATALOGNAMES');
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

        //Сначала создали внешние таблицы
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

        //Потом наполнили их данными
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

// подключает таблицы из старого MDB
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

//отключает все подключенные внешние таблицы
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

      MainForm.StatusText:='Очищается MinPrices';
      SQL.Text:='EXECUTE PROCEDURE MinPricesDeleteALL';
      ExecQuery;
      SQL.Text:='EXECUTE PROCEDURE OrdersSetCoreNull'; ExecQuery;
      SQL.Text:='EXECUTE PROCEDURE OrdersHDeleteNotClosedAll'; ExecQuery;
      MainForm.StatusText:='Очищается Core';
      SQL.Text:='EXECUTE PROCEDURE CoreDeleteAll'; ExecQuery;
      MainForm.StatusText:='Очищается CatalogCurrency';
      SQL.Text:='EXECUTE PROCEDURE CatalogCurrencyDelete'; ExecQuery;
      MainForm.StatusText:='Очищается Catalog';
      SQL.Text:='EXECUTE PROCEDURE CatalogDelete'; ExecQuery;
      MainForm.StatusText:='Очищается CatalogNames';
      SQL.Text:='EXECUTE PROCEDURE CatalogNamesDelete'; ExecQuery;
      MainForm.StatusText:='Очищается CatalogFarmGroups';
      SQL.Text:='EXECUTE PROCEDURE CatalogFarmGroupsDelete'; ExecQuery;
      MainForm.StatusText:='Очищается PricesRegionalData';
      SQL.Text:='EXECUTE PROCEDURE PricesRegionalDataDeleteAll'; ExecQuery;
      MainForm.StatusText:='Очищается PricesData';
      SQL.Text:='EXECUTE PROCEDURE PricesDataDeleteAll'; ExecQuery;
      MainForm.StatusText:='Очищается RegionalData';
      SQL.Text:='EXECUTE PROCEDURE RegionalDataDeleteAll'; ExecQuery;
      MainForm.StatusText:='Очищается ClientsDataN';
      SQL.Text:='EXECUTE PROCEDURE ClientsDataNDeleteAll'; ExecQuery;
      MainForm.StatusText:='Очищается Synonym';
      SQL.Text:='EXECUTE PROCEDURE SynonymDeleteAll'; ExecQuery;
      MainForm.StatusText:='Очищается SynonymFirmCr';
      SQL.Text:='EXECUTE PROCEDURE SynonymFirmCrDeleteAll'; ExecQuery;
      MainForm.StatusText:='Очищается Defectives';
      SQL.Text:='EXECUTE PROCEDURE DefectivesDeleteAll'; ExecQuery;
      MainForm.StatusText:='Очищается Registry';
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
      if Result=0 then raise Exception.Create('Не удается создать заголовок заказа');
    end
    else
      Result:=0;
  end
  else if NRecs>1 then
    raise Exception.Create('По данным клиенту, прайс-листу и региону найдено больше одного неотправленного заказа');
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

{ Запомнить последнюю успешную стадию импорта }
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
  Windows.DeleteFile( PChar( APath + ChangeFileExt( DatabaseName, '.ldb')));
  MoveFile_( APath + ChangeFileExt( DatabaseName, '.bak'),
    APath + DatabaseName);
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

function TDM.Unpacked: boolean;
var
  SR: TSearchRec;
begin
  result := FindFirst( ExePath + SDirIn + '\*.zi_', faAnyFile, SR) <> 0;
  if not result then
  begin
    MoveFile_( ExePath + SDirIn + '\' + SR.Name,
      ExePath + SDirIn + '\' + ChangeFileExt( SR.Name, '.zip'));
  end;
  FindClose( SR);
end;

procedure TDM.ResetExclusive;
begin
  { Снятие запроса на монопольный доступ }
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
  { Установка запроса на монопольный доступ }
  MainForm.CS.Enter;
  try
    try
      adtFlags.Edit;
      adtFlags.FieldByName( 'ComputerName').AsString := GetComputerName_;
      adtFlags.FieldByName( 'ExclusiveID').AsString := IntToHex(
        GetUniqueID( Application.ExeName, ''{MainForm.VerInfo.FileVersion}), 8);
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
  //открываем таблицы с параметрами
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
//  idPing : TIdIcmpClient;
  hWS : THandle;
begin
  try
    hWS := LoadLibrary('ws2_32.dll');
    Result := hWS <> 0;
    if Result then
      FreeLibrary(hWS);
      {
    idPing := TIdIcmpClient.Create(nil);
    try
      idPing.Host := 'localhost';
      idPing.Ping();
      Result := idPing.ReplyStatus.ReplyStatusType = rsEcho;
    finally
      idPing.Free;
    end;
    }
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
end;

procedure TDM.SetNeedCommitExchange;
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
    PassC.EncodeHex(IntToHex(GetCopyID, 8) + ASGM);
  adtParams.Post;
end;

procedure TDM.s3cf(DataSet: TDataSet);
begin
  try
    adsSelect3CryptPRICE.AsCurrency := StrToFloat(DM.D_B_N(adsSelect3PRICE.AsString));
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
  //Очищаем данные по заказам
  ClearSelectedPrices(OrdersInfo);
  AllSumOrder := 0;
 	adsOrdersH.Close;
  //Получаем информацию о текущих отправляемых заказах
	adsOrdersH.ParamByName( 'AClientId').Value := adtClients.FieldByName( 'ClientId').Value;
	adsOrdersH.ParamByName( 'AClosed').Value := False;
	adsOrdersH.ParamByName( 'ASend').Value := True;
	adsOrdersH.ParamByName( 'TimeZoneBias').Value := 0;
	adsOrdersH.Open;
  try
  while not adsOrdersH.Eof do begin
    CurrOrderInfo := FindOrderInfo(adsOrdersH.FieldByName('PriceCode').AsInteger, adsOrdersH.FieldByName('RegionCode').AsInteger);
    CurrOrderInfo.Summ := GetSumOrder(adsOrdersH.FieldByName('OrderID').AsInteger);
    AllSumOrder := AllSumOrder + CurrOrderInfo.Summ;
    adsOrdersH.Next;
  end;
  finally
   	adsOrdersH.Close;
  end;

	adsOrdersH.ParamByName( 'ASend').Value := False;
	adsOrdersH.Open;
  try
  while not adsOrdersH.Eof do begin
    CurrOrderInfo := FindOrderInfo(adsOrdersH.FieldByName('PriceCode').AsInteger, adsOrdersH.FieldByName('RegionCode').AsInteger);
    CurrOrderInfo.Summ := GetSumOrder(adsOrdersH.FieldByName('OrderID').AsInteger);
    AllSumOrder := AllSumOrder + CurrOrderInfo.Summ;
    adsOrdersH.Next;
  end;
  finally
   	adsOrdersH.Close;
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
    S := DM.D_B_N(adsOrders.FieldByName('PRICE').AsString);
    adsOrdersCryptSUMORDER.AsCurrency := StrToFloat(S) * adsOrders.FieldByName('ORDERCOUNT').AsInteger;
  except
  end;
end;

function TDM.GetSumOrder(AOrderID: Integer): Currency;
var
	V: array[0..0] of Variant;
begin
  try
    with adsOrders do begin
      ParamByName('AOrderId').Value:=AOrderId;
      if Active then CloseOpen(True) else Open;
    end;
    DataSetCalc(adsOrders, ['SUM(CryptSUMORDER)'], V);
    Result := V[0];
  finally
    adsOrders.Close;
  end;
end;

function TDM.CheckCopyIDFromDB: Boolean;
begin
  Result := DBUIN = IntToHex(GetCopyID, 8);
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
  DBVersion := 0;
  try
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
        DBVersion := dbCon.QueryValue('select mdbversion from provider where id = 0', 0);
        dbCon.Close;

        if DBVersion = 29 then begin
          etlname := GetLastEtalonFileName;
          //Если существует эталонный файл, то обновляем его
          if Length(etlname) > 0 then
            RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, UpdateDBFileDataFor29);
          RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, UpdateDBFileDataFor29);
          DBVersion := 36;
        end;

        if DBVersion = 35 then begin
          etlname := GetLastEtalonFileName;
          if Length(etlname) > 0 then
            RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, UpdateDBFileDataFor35);
          RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, UpdateDBFileDataFor35);
          DBVersion := 36;
        end;

        if DBVersion = 36 then begin
          etlname := GetLastEtalonFileName;
          if Length(etlname) > 0 then
            RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, UpdateDBFileDataFor36);
          RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, UpdateDBFileDataFor36);
          DBVersion := 37;
        end;

        if DBVersion = 37 then begin
          etlname := GetLastEtalonFileName;
          if Length(etlname) > 0 then
            RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, UpdateDBFileDataFor37);
          RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, UpdateDBFileDataFor37);
          DBVersion := 38;
        end;

        if DBVersion = 38 then begin
          etlname := GetLastEtalonFileName;
          if Length(etlname) > 0 then
            RunUpdateDBFile(dbCon, trMain, etlname, DBVersion, UpdateDBFile, nil);
          RunUpdateDBFile(dbCon, trMain, MainConnection1.DBName, DBVersion, UpdateDBFile, nil);
          DBVersion := 39;
        end;

      finally
        trMain.Free;
      end;

    finally
      dbCon.Free;
    end;
  except
    on E : Exception do begin
      LogCriticalError('Ошибка при обновлении базы данных : ' + E.Message);
      MessageBox( 'Ошибка при обновлении базы данных : ' + E.Message, MB_ICONERROR or MB_OK);
      ExitProcess( Integer(ecDBUpdateError) );
    end;
  end;

  if DBVersion <> CURRENT_DB_VERSION then begin
    MessageBox( Format('Версия базы данных %d не совпадает с необходимой версией %d.', [DBVersion, CURRENT_DB_VERSION]), MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecDiffDBVersion) );
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

      trMain.StartTransaction;

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

      trMain.Commit;

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

procedure TDM.CheckDBFile;
var
  dbCon : TpFIBDatabase;
  DBErrorMess : String;
  N : Integer;
  OldDBFileName,
  EtalonDBFileName,
  ErrFileName : String;
begin
  NeedImportAfterRecovery := False;
  dbCon := TpFIBDatabase.Create(nil);
  try
    try

        dbCon.DBName := MainConnection1.DBName;
        dbCon.DBParams.Text := MainConnection1.DBParams.Text;
        dbCon.LibraryName := MainConnection1.LibraryName;
        dbCon.SQLDialect := MainConnection1.SQLDialect;
        dbCon.Open;
        dbCon.Close;

    except
      on EFIB : EFIBError do begin
        try

          if EFIB.IBErrorCode = isc_network_error then
            raise Exception.Create('Не возможен запуск программы с сетевого диска. Пожалуйста, используйте локальный диск.')
          else begin
            {
            Здесь мы должны сделать:
            1. Закрыть соединение, если открыто
            2. Запомнить код ошибки при открытии
            3. Переименовать в ошибочную базу данных
            4. Скопировать из эталонной базы данных
            5. Открыть эталонную базу данных
            }
            DBErrorMess := Format('Не удается открыть базу данных программы.'#13#10 +
              'Код SQL       : %d'#13#10 +
              'Сообщение SQL : %s'#13#10 +
              'Код IB        : %d'#13#10 +
              'Сообщение IB  : %s',
              [EFIB.SQLCode, EFIB.SQLMessage, EFIB.IBErrorCode, EFIB.IBMessage]
            );
            AProc.LogCriticalError(DBErrorMess);
            MessageBox(DBErrorMess + #13#10#13#10 + 'Будет произведено восстановление из эталонной копии.', MB_ICONERROR or MB_OK);
            //Возможно проблема в каком-то запросе и сама база данных открылась, поэтому закрываем ее.
            if dbCon.Connected then
              try
                dbCon.Close;
              except
              end;

            //Формируем имя ошибочного файла
            ErrFileName := ChangeFileExt(ParamStr(0), '.e');
            N := 0;
            while (FileExists(ErrFileName + IntToHex(N, 2)) and (N <= 255)) do Inc(N);

            if N > 255 then
              //Слишком много ошибочный файлов
              raise Exception.Create('Удалите старые ошибочные файлы базы данных.')
            else begin
              ErrFileName := ErrFileName + IntToHex(N, 2);
              OldDBFileName := ChangeFileExt(ParamStr(0), '.fdb');

              if FileExists(OldDBFileName) then
                if not Windows.MoveFile(PChar(OldDBFileName), PChar(ErrFileName)) then
                  raise Exception.CreateFmt('Не удалось переименовать в ошибочный файл %s : %s',
                    [ErrFileName, SysErrorMessage(GetLastError)]);

              EtalonDBFileName := GetLastEtalonFileName;

              if Length(EtalonDBFileName) = 0 then
                raise Exception.Create('Не найден файл с эталонной копией.')
              else
                if not Windows.CopyFile(PChar(EtalonDBFileName), PChar(OldDBFileName), True) then
                  raise Exception.CreateFmt('Не удалось скопировать из эталонной копии : %s',
                    [SysErrorMessage(GetLastError)]);

              try
                dbCon.Open;
                dbCon.Close;
                NeedImportAfterRecovery := True;
              except
                on E : Exception do
                  raise Exception.CreateFmt('Не удалось восстановить базу данных из эталонной копии. '#13#10 +
                    'Сообщение об ошибке : %s'#13#10 + 'Пожалуйста, обратитесь в службу поддержки.',
                    [E.Message]);
              end;
            end;
          end;

        except
          on E : Exception do begin
            MessageBox( Format( 'Не возможно открыть файл базы данных : %s ', [ E.Message ]),
              MB_ICONERROR or MB_OK);
            ExitProcess( Integer(ecDBFileError) );
          end;
        end
      end;

      //Если произошла какая-то другая ошибка, то отображаем ее
      on E : Exception do begin
        MessageBox( Format( 'Не возможно открыть файл базы данных : %s ', [ E.Message ]),
          MB_ICONERROR or MB_OK);
        ExitProcess( Integer(ecDBFileError) );
      end;
    end;
  finally
    try
      dbCon.Free;
    except
    end;
  end;
end;

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

initialization
  ch := IntToHex(GetCopyID, 8);
  p := '';
  for I := 1 to Length(ch) do
    p := p + ch[i] + PassPassW[i];
  PassC := TINFCrypt.Create(p, 48);
  SummarySelectedPrices := TStringList.Create;
  SynonymSelectedPrices := TStringList.Create;
finalization
  PassC.Free;
  ClearSelectedPrices(SummarySelectedPrices);
  ClearSelectedPrices(SynonymSelectedPrices);
  SummarySelectedPrices.Free;
  SynonymSelectedPrices.Free;
end.
