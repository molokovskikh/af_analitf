
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyAccess;
{$ENDIF}

interface

uses
{$IFDEF CLR}
  Variants, System.XML, System.Text,
{$ELSE}
  CLRClasses, CRXml,
{$ENDIF}
  MyConnectionPool, CRConnectionPool, MySqlApi,
  Classes, SysUtils, DB, MemUtils, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  MemData, CRAccess, DBAccess, MyClasses, CRParser,
  MyCall, DAConsts, CRVio, MyConsts, DASQLMonitor, MyServices
{$IFDEF MSWINDOWS}
  , Win32Timer, Registry
{$ENDIF}
  ;
{$I MyDacVer.inc}


type
  TMyCommand = class;
  TMyUpdateSQL = class;
  TCustomMyConnection = class;
  TMyConnection = class;
  TMyIsolationLevel = (ilReadCommitted, ilReadUnCommitted, ilRepeatableRead, ilSerializable);
  TMyNumericType = TDANumericType;

{ TCustomMyConnection }

  TCustomMyConnectionOptions = class (TDAConnectionOptions)
  protected
    FUseUnicode: boolean;
    FCharset: string;
    FOptimizedBigInt: boolean;

    procedure AssignTo(Dest: TPersistent); override;
    procedure SetUseUnicode(const Value: boolean);
    procedure SetCharset(const Value: string);
    function GetNumericType: TDANumericType;
    procedure SetNumericType(Value: TDANumericType);
    procedure SetOptimizedBigInt(const Value: boolean);

    property EnableBCD;
  {$IFDEF VER6P}
  {$IFNDEF FPC}
    property EnableFMTBCD;
  {$ENDIF}
  {$ENDIF}
  public
    constructor Create(Owner: TCustomDAConnection);

    property UseUnicode: boolean read FUseUnicode write SetUseUnicode
      default {$IFNDEF UNICODE_BUILD}False{$ELSE}True{$ENDIF};
    property Charset: string read FCharset write SetCharset;
    property KeepDesignConnected;
    property NumericType: TDANumericType read GetNumericType write SetNumericType default ntFloat;
    property OptimizedBigInt: boolean read FOptimizedBigInt write SetOptimizedBigInt default False;
  end;

  TCustomMyConnection = class (TCustomDAConnection)
  protected
    FLoginPrompt: boolean;
    FDatabase: string;
    FConnectionTimeout: integer;
    FOptions: TCustomMyConnectionOptions;
    FThreadId: integer;

    function GetIConnectionClass: TCRConnectionClass; override;
    function GetICommandClass: TCRCommandClass; override;
    function GetIRecordSetClass: TCRRecordSetClass; override;
    function GetIMetaDataClass: TCRMetaDataClass; override;

    procedure CreateIConnection; override;
    procedure SetIConnection(Value: TCRConnection); override;
    procedure SetOptions(Value: TCustomMyConnectionOptions);

    procedure FillConnectionParameters(var ConnectionParameters: TMyConnectionParameters); virtual;
    procedure FillConnectionProps(MySQLConnection: TMySQLConnection); virtual;
    function GetMySQLConnection: TMySQLConnection;
    procedure ReturnMySQLConnection(CRConnection: TCRConnection);

    function SQLMonitorClass: TClass; override;
    function ConnectDialogClass: TConnectDialogClass; override;

    procedure SetDatabase(Value: string);
    function GetIsolationLevel: TMyIsolationLevel; 
    procedure SetIsolationLevel(const Value: TMyIsolationLevel);

    procedure SetConnectionTimeout(const Value: integer);
    function NeedPrompt: boolean; override;

    //procedure Check(const Status: HRESULT);
    procedure CheckInactive;

    procedure DoConnect; override;
//upd    function CommitOnDisconnect: boolean; override;

    //function GetCharset: string;
    function GetClientVersion: string; virtual; abstract;
    function GetServerVersion: string;
    function GetThreadId: longword;

    function IConnection: TMySQLConnection;
    procedure AssignConnectOptions(Source: TCustomDAConnection); override;
    procedure AssignTo(Dest: TPersistent); override;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    function CreateDataSet: TCustomDADataSet; override;
    function CreateSQL: TCustomDASQL; override;
    function CreateTransaction: TDATransaction; override;
    function CreateMetaData: TDAMetaData; override;

    procedure AssignConnect(Source: TCustomMyConnection);
    function ExecSQL(Text: _string; const Params: array of variant): variant; override;

    procedure GetStoredProcNames(List: _TStrings; AllProcs: boolean = False); override;
    procedure GetCharsetNames(List: _TStrings);
    procedure GetIndexNames(List: _TStrings; TableName: _string);

    function GetExecuteInfo: string;
    procedure Ping;

    procedure Savepoint(const Name: _string);
    procedure RollbackToSavepoint(const Name: _string);
    procedure ReleaseSavepoint(const Name: _string);

    //property Charset: string read GetCharset;
    property ClientVersion: string read GetClientVersion;
    property ServerVersion: string read GetServerVersion;

    property ThreadId: longword read GetThreadId;

    property Database: string read FDatabase write SetDatabase;
    property ConnectionTimeout: integer read FConnectionTimeout write SetConnectionTimeout default 15;
    property IsolationLevel: TMyIsolationLevel read GetIsolationLevel write SetIsolationLevel default ilReadCommitted;

    property Options: TCustomMyConnectionOptions read FOptions write SetOptions;

    property PoolingOptions;
    property Pooling;

    property Username;
    property Password;

    property AfterConnect;
    property BeforeConnect;
    property AfterDisconnect;
    property BeforeDisconnect;
    property OnLogin;
    property OnError;
    property ConnectDialog;
    property LoginPrompt;
  end;

{ TMyConnection }

  TMyConnectionOptions = class (TCustomMyConnectionOptions)
  protected
    FCompress: boolean;
    FProtocol: TMyProtocol;
    FEmbedded: boolean; // deprecated
  {$IFDEF HAVE_DIRECT}
    FDirect: boolean;
  {$ENDIF}
    FCheckBackslashes: boolean;

    procedure AssignTo(Dest: TPersistent); override;
    procedure SetCompress(const Value: boolean);
    procedure SetProtocol(const Value: TMyProtocol);

    procedure SetEmbedded(const Value: boolean);
  {$IFDEF HAVE_DIRECT}
    procedure SetDirect(const Value: boolean);
  {$ENDIF}
    procedure SetCheckBackslashes(const Value: boolean);

  public
    constructor Create(Owner: TMyConnection);

  published
    property Compress: boolean read FCompress write SetCompress default False;
    property UseUnicode default False;
    property Charset;
    property Protocol: TMyProtocol read FProtocol write SetProtocol default mpDefault;

    property Embedded: boolean read FEmbedded write SetEmbedded default False;
  {$IFDEF HAVE_DIRECT}
    property Direct: boolean read FDirect write SetDirect default True;
  {$ENDIF}
    property CheckBackslashes: boolean read FCheckBackslashes write SetCheckBackslashes default False;

    property KeepDesignConnected;
    property NumericType default ntFloat;
    property OptimizedBigInt default False;
    property DisconnectedMode;
    property LocalFailover;
    property DefaultSortType;
  end;

{$IFDEF HAVE_OPENSSL}
  TMyConnectionSSLOptions = class (TPersistent)
  protected
    FOwner: TCustomDAConnection;

    FChipherList: string;
    FCACert: string;
    FKey: string;
    FCert: string;

    procedure SetChipher(const Value: string);
    procedure SetCA(const Value: string);
    procedure SetKey(const Value: string);
    procedure SetCert(const Value: string);

    procedure AssignTo(Dest: TPersistent); override;

  public
    constructor Create(Owner: TMyConnection);

  published
    property ChipherList: string read FChipherList write SetChipher;
    property CACert: string read FCACert write SetCA;
    property Key: string read FKey write SetKey;
    property Cert: string read FCert write SetCert;

  end;
{$ENDIF}

  TMyConnection = class (TCustomMyConnection)
  protected
    FPort: integer;
  {$IFDEF HAVE_OPENSSL}
    FSSLOptions: TMyConnectionSSLOptions;
  {$ENDIF}

    procedure AssignTo(Dest: TPersistent); override;

    function GetOptions: TMyConnectionOptions;
    procedure SetOptions(Value: TMyConnectionOptions);
  {$IFDEF HAVE_OPENSSL}
    procedure SetSSLOptions(Value: TMyConnectionSSLOptions);
  {$ENDIF}

  {$HPPEMIT '#ifdef SetPort'}
  {$HPPEMIT '#undef SetPort'}
  {$HPPEMIT '#endif'}
    procedure SetPort(Value: integer);
    function GetEmbedded: boolean;
    procedure SetEmbedded(Value: boolean);

    function GetClientVersion: string; override;
    function CreateOptions: TDAConnectionOptions; override;
    procedure FillConnectionParameters(var ConnectionParameters: TMyConnectionParameters); override;
    procedure FillConnectionProps(MySQLConnection: TMySQLConnection); override;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

  published
    property Database;
    property Port: integer read FPort write SetPort default MYSQL_PORT;
    property ConnectionTimeout;
    property IsolationLevel;

    property Options: TMyConnectionOptions read GetOptions write SetOptions;
  {$IFDEF HAVE_OPENSSL}
    property SSLOptions: TMyConnectionSSLOptions read FSSLOptions write SetSSLOptions;
  {$ENDIF}
    property Embedded: boolean read GetEmbedded write SetEmbedded default False;


    property PoolingOptions;
    property Pooling;

    property Username;
    property Password;
    property Server;
    property Connected stored IsConnectedStored;

    property AfterConnect;
    property BeforeConnect;
    property AfterDisconnect;
    property BeforeDisconnect;
    property OnLogin;
    property OnError;
    property OnConnectionLost;
    property ConnectDialog;
    property LoginPrompt;

    property IOHandler;
  end;

  TLockRecordType = (lrImmediately, lrDelayed); // Note: MyServices.TLockRecordTypeI

{ TMySQLGenerator }
  TMySQLGenerator = class(TCustomMySQLGenerator)
  //upd
  end;

  TMyDataSetService = class(TCustomMyDataSetService)
  protected
    procedure CreateSQLGenerator; override;
    procedure CreateDataSetUpdater; override;
  end;

  TMyDataSetUpdater = class(TCustomMyDataSetUpdater)
  protected
    procedure SetUpdateQueryOptions(const StatementType: TStatementType); override;
  end;

{ TCustomMyDataSet }

  TMyDataSetOptions = class (TDADataSetOptions)
  private
    FFieldsAsString: boolean;
    FNullForZeroDate: boolean;
    FCheckRowVersion: boolean;
    FEnableBoolean: boolean;
    FBinaryAsString: boolean;
  {$IFDEF MSWINDOWS}
    FAutoRefresh: boolean;
    FAutoRefreshInterval: integer;
  {$ENDIF}
    FCreateConnection: boolean;

    procedure SetFieldsAsString(Value: boolean);
    procedure SetNullForZeroDate(Value: boolean);
    procedure SetEnableBoolean(Value: boolean);
    procedure SetBinaryAsString(Value: boolean);
  {$IFDEF MSWINDOWS}
    procedure SetAutoRefresh(Value: boolean);
    procedure SetAutoRefreshInterval(Value: integer);
  {$ENDIF}
    procedure SetCreateConnection(Value: boolean);
    procedure SetCheckRowVersion(const Value: boolean);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Owner: TCustomDADataSet);

  published
    property SetFieldsReadOnly;
    property FullRefresh;
    property FieldsAsString: boolean read FFieldsAsString write SetFieldsAsString default False;
  {$IFDEF HAVE_COMPRESS}
    property CompressBlobMode;
  {$ENDIF}
    property NullForZeroDate: boolean read FNullForZeroDate write SetNullForZeroDate default True;
    property CheckRowVersion: boolean read FCheckRowVersion write SetCheckRowVersion default False;
    property EnableBoolean: boolean read FEnableBoolean write SetEnableBoolean default True;
    property BinaryAsString: boolean read FBinaryAsString write SetBinaryAsString default True;
  {$IFDEF MSWINDOWS}
    property AutoRefresh: boolean read FAutoRefresh write SetAutoRefresh default False;
    property AutoRefreshInterval: integer read FAutoRefreshInterval write SetAutoRefreshInterval default 60; /// Seconds dac6.txt
  {$ENDIF}
    property CreateConnection: boolean read FCreateConnection write SetCreateConnection default True;

    property AutoPrepare;
    property LongStrings; /// nonsense in MySQL (max CHAR len is 255). Exception - SHOW CREATE TABLE result!
    property RequiredFields default False;
    property StrictUpdate;
    property NumberRange;
    property ReturnParams;
    property TrimFixedChar stored False; /// nonsense in MySQL - always trimmed by MySQL API
    property QueryRecCount;
    property RemoveOnRefresh;
    property FlatBuffers;
    property QuoteNames;
    property DetailDelay;
    property FieldsOrigin default True;
    property LocalMasterDetail;
    property CacheCalcFields;
    property UpdateBatchSize;
    property UpdateAllFields;
    property DefaultValues;

    // property QueryIdentity is not supported because function mysql_insert_id is very fast
  end;

  TCustomMyDataSet = class;
  TMyUpdateExecuteEvent = procedure (Sender: TCustomMyDataSet;
    StatementTypes: TStatementTypes; Params: TDAParams) of object;

  TLockType = (ltRead, ltReadLocal, ltWrite, ltWriteLowPriority); // Note: MyServices.TLockTypeI

  TCustomMyDataSet = class (TCustomDADataSet)
  private
    function GetConnection: TCustomMyConnection;
    procedure SetConnection(Value: TCustomMyConnection);

    function GetUpdateObject: TMyUpdateSQL;
    procedure SetUpdateObject(Value: TMyUpdateSQL);
  protected
  { IProviderSupport }
  {$IFDEF WITH_IPROVIDER}
    function PSGetQuoteChar: string; override;
  {$ENDIF}

  protected
    FIRecordSet: TMySQLRecordSet;
    FICommand: TMySQLCommand;

    FDataSetService: TMyDataSetService;

    FBeforeUpdateExecute: TMyUpdateExecuteEvent;
    FAfterUpdateExecute: TMyUpdateExecuteEvent;
    FAfterExecProcessing: boolean;

    FOptions: TMyDataSetOptions;

    FCommandTimeout: integer;

  {$IFDEF MSWINDOWS}
    FAutoRefreshTimer: TWin32Timer;
    procedure AutoRefreshTimer(Sender: TObject);
    procedure CheckAutoRefreshTimer;
  {$ENDIF}

    procedure CreateIRecordSet; override;
    procedure SetIRecordSet(Value: TData); override;

    procedure CreateCommand; override;

    function CreateOptions: TDADataSetOptions; override;
    procedure SetOptions(Value: TMyDataSetOptions);

    function GetDataSetServiceClass: TDataSetServiceClass; override;
    procedure SetDataSetService(Value: TDataSetService); override;

    procedure AssignTo(Dest: TPersistent); override;

    procedure SetCommandTimeout(const Value: integer);

  { Open/Close }
    function GetIsQuery: boolean; override;

    procedure InternalOpen; override;
    procedure InternalClose; override;
    procedure BeforeOpenCursor(InfoQuery: boolean); override;
    procedure DoAfterExecute(Result: boolean); override;

  { Fields }
    procedure CreateFieldDefs; override;

    //function GetActualFieldName(FldDesc: TFieldDesc; IsRefresh: boolean): string;

    procedure CheckInactive; override;

  { Before / After UpdateExecute }
    function AssignedBeforeUpdateExecute: boolean; override;
    procedure DoBeforeUpdateExecute(Sender: TDataSet; StatementTypes: TStatementTypes;
      Params: TDAParams); override;
    function AssignedAfterUpdateExecute: boolean; override;
    procedure DoAfterUpdateExecute(Sender: TDataSet; StatementTypes: TStatementTypes;
      Params: TDAParams); override;

  { SQL Modifications }
    function SQLGetFrom(SQLText: _string): _string; override;
    function SQLAddWhere(SQLText, Condition: _string): _string; override;
    function SQLDeleteWhere(SQLText: _string): _string; override;
    function SQLGetWhere(SQLText: _string): _string; override;
    function SQLSetOrderBy(SQLText: _string; Fields: _string): _string; override;
    function SQLGetOrderBy(SQLText: _string): _string; override;

  { XML }
    procedure WriteFieldXMLDataType(Field: TField; FieldDesc: TFieldDesc; const FieldAlias: _string; XMLWriter: XMLTextWriter); override;
    procedure WriteFieldXMLAttributeType(Field: TField; FieldDesc: TFieldDesc; const FieldAlias: _string;
      XMLWriter: XMLTextWriter); override;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    function OpenNext: boolean; // Open next rowset in statement. if rowset not returne theh OpenNext return False. If statement has error, then raised exception
    procedure RefreshQuick(const CheckDeleted: boolean);
    procedure BreakExec;

    procedure LockTable(LockType: TLockType);
    procedure UnLockTable;

    procedure Lock; overload; override;
    procedure Lock(LockType: TLockRecordType); reintroduce; overload;

    procedure GetFieldEnum(List: _TStrings; FieldName: _string; TableName: _string = '');

    property FetchAll default True;
    property LockMode;
    property KeyFields;

    property InsertId: int64 read FLastInsertId;
    property CommandTimeout: integer read FCommandTimeout write SetCommandTimeout default 0;

    property UpdateObject: TMyUpdateSQL read GetUpdateObject write SetUpdateObject;

  { SQL Modify }
    property Connection: TCustomMyConnection read GetConnection write SetConnection;

    property Options: TMyDataSetOptions read FOptions write SetOptions;

    property BeforeUpdateExecute: TMyUpdateExecuteEvent read FBeforeUpdateExecute write FBeforeUpdateExecute;
    property AfterUpdateExecute: TMyUpdateExecuteEvent read FAfterUpdateExecute write FAfterUpdateExecute;
  end;

{ TMyUpdateSQL }

  TMyUpdateSQL = class (TCustomDAUpdateSQL)
  protected
    function DataSetClass: TCustomDADataSetClass; override;
    function SQLClass: TCustomDASQLClass; override;
  end;

{ TMyQuery }

  TMyQuery = class (TCustomMyDataSet)
  published
    property SQLInsert;
    property SQLDelete;
    property SQLUpdate;
    property SQLRefresh;

    property Connection;
    property ParamCheck;
    property SQL;
    property Debug;
    property Macros;
    property Params;
    property FetchRows;
    property ReadOnly;
    property UniDirectional;
    property CachedUpdates;

    property AfterExecute;
    property BeforeUpdateExecute;
    property AfterUpdateExecute;
    property OnUpdateError;
    property OnUpdateRecord;

    property UpdateObject;
    property RefreshOptions;

    property AutoCalcFields;
    property Filtered;
    property Filter;
    property FilterOptions;

    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
    property AfterRefresh;
    property BeforeRefresh;

    property Options;
    property FilterSQL;

    property MasterSource;
    property MasterFields;
    property DetailFields;

    property FetchAll;
    property UpdatingTable;
    property LockMode;
    property KeyFields;
    property IndexFieldNames;
    property CommandTimeout;

    property Active; /// CR DAC 13049  
    property BeforeFetch;
    property AfterFetch;
  end;

{ TMyTable }

  TMyTableOptions = class (TMyDataSetOptions)
  private
    FUseHandler: boolean;
    FHandlerIndex: _string;

    procedure SetUseHandler(const Value: boolean);
    procedure SetHandlerIndex(const Value: _string);
  protected
    procedure AssignTo(Dest: TPersistent); override;

  public
    constructor Create(Owner: TCustomDADataSet);

  published
    property UseHandler: boolean read FUseHandler write SetUseHandler default False;
    property HandlerIndex: _string read FHandlerIndex write SetHandlerIndex;
  end;

  TCustomMyTable = class (TCustomMyDataSet)
  protected
  { IProviderSupport }
  {$IFDEF WITH_IPROVIDER}
    function PSGetTableName: string; override;
    procedure PSSetParams(AParams: DB.TParams); override;
    procedure PSSetCommandText(const CommandText: string); override;
  {$ENDIF}

  protected
    FTableName: _string;
    FOrderFields: _string;
    FLimit: integer;
    FOffset: integer;
    FIndexDefs: TIndexDefs;

    procedure SetTableName(const Value: _string);
    procedure SetOrderFields(Value: _string);
    procedure SetLimit(const Value: integer);
    procedure SetOffset(const Value: integer);

    function CreateOptions: TDADataSetOptions; override;
    function GetOptions: TMyTableOptions;
    procedure SetOptions(Value: TMyTableOptions);

    procedure SetIRecordSet(Value: TData); override;

    procedure AssignTo(Dest: TPersistent); override;

    function SQLAutoGenerated: boolean; override;

  { Open/Close }
    function SeparatedHandler: boolean;
    procedure BeforeOpenCursor(InfoQuery: boolean); override;
    procedure AfterOpenCursor(InfoQuery: boolean); override;
    procedure InternalClose; override;

    function GetIndexDefs: TIndexDefs;
    procedure UpdateIndexDefs; override;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

  { Open/Close }
    procedure Prepare; override;
    procedure PrepareSQL;
    procedure Execute; override;

    procedure EmptyTable;

    property TableName: _string read FTableName write SetTableName;
    property OrderFields: _string read FOrderFields write SetOrderFields;
    property Limit: integer read FLimit write SetLimit default -1;
    property Offset: integer read FOffset write SetOffset default 0;

    property Options: TMyTableOptions read GetOptions write SetOptions;

    property IndexDefs: TIndexDefs read GetIndexDefs;
  end;

  TMyTable = class (TCustomMyTable)
  published
    property TableName;
    property OrderFields;
    property Limit;
    property Offset;

    property MasterFields;
    property DetailFields;
    property MasterSource;
    property ReadOnly;

    property Connection;

    property Debug;
    property FetchRows;
    property UniDirectional;
    property CachedUpdates;

    property OnUpdateError;
    property OnUpdateRecord;

    property UpdateObject;
    property RefreshOptions;

    property Active;
    property AutoCalcFields;
    property Filtered;
    property Filter;
    property FilterOptions;

    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
  {$IFNDEF VER4}
    property AfterRefresh;
    property BeforeRefresh;
  {$ENDIF}
    property Options;
    property FilterSQL;

    property FetchAll;
    property LockMode;
    property KeyFields;
    property IndexFieldNames;
    property IndexDefs;
    property CommandTimeout;
    property BeforeFetch;
    property AfterFetch;
  end;

{ TMyStoredProc }

  TCustomMyStoredProc = class (TCustomMyDataSet)
  protected
  { IProviderSupport }
  {$IFDEF WITH_IPROVIDER}
    procedure PSSetCommandText(const CommandText: string); override;
  {$ENDIF}

  protected
    FStoredProcName: _string;

    procedure SetStoredProcName(const Value: _string);
    procedure AssignTo(Dest: TPersistent); override;

    function SQLAutoGenerated: boolean; override;
    procedure BeforeOpenCursor(InfoQuery: boolean); override;
    procedure BeforeExecute; override;

  public
    procedure ExecProc; // for BDE compatibility

    procedure Prepare; override;
    procedure PrepareSQL;

//    property UpdatingTable;
    property StoredProcName: _string read FStoredProcName write SetStoredProcName;
  end;

  TMyStoredProc = class(TCustomMyStoredProc)
  published
    property StoredProcName;

    property SQLInsert;
    property SQLDelete;
    property SQLUpdate;
    property SQLRefresh;

    property Connection;
    // property ParamCheck;
    property SQL;
    property Debug;
    property Params;
    property FetchRows;
    property ReadOnly;
    property UniDirectional;
    property CachedUpdates;

    property AfterExecute;
    property BeforeUpdateExecute;
    property AfterUpdateExecute;
    property OnUpdateError;
    property OnUpdateRecord;

    property Options;
    property UpdateObject;
    property RefreshOptions;

    property Active;
    property AutoCalcFields;
    property Filtered;
    property Filter;
    property FilterOptions;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
  {$IFNDEF VER4}
    property AfterRefresh;
    property BeforeRefresh;
  {$ENDIF}

    property UpdatingTable;

    property FetchAll;
    property LockMode;
    property KeyFields;
    property CommandTimeout;
    property BeforeFetch;
    property AfterFetch;
  end;

{ TMyCommand }

  TMyCommand = class (TCustomDASQL)
  private
    function GetConnection: TCustomMyConnection;
    procedure SetConnection(Value: TCustomMyConnection);

  protected
    FICommand: TMySQLCommand;
    FCommandTimeout: integer;

    procedure CreateICommand; override;
    procedure SetICommand(Value: TCRCommand); override;
    function GetDataTypesMap: TDataTypesMapClass; override;
    procedure AssignTo(Dest: TPersistent); override;

    procedure AssembleSQL; override;

    procedure SetCommandTimeout(const Value: integer);

    function UsedConnection: TCustomDAConnection; override;
  public
    constructor Create(Owner: TComponent); override;
    procedure BreakExec;
    property AutoCommit;
    property InsertId: int64 read FLastInsertId;

  published
    property Connection: TCustomMyConnection read GetConnection write SetConnection;
    property CommandTimeout: integer read FCommandTimeout write SetCommandTimeout default 0;

    property ParamCheck;
    property SQL;
    property Params;
    property Macros;
    property Debug;

    property AfterExecute;
  end;

{ TMyTransaction }

  TMyTransaction = class (TDATransaction)
  protected
    function SQLMonitorClass: TClass; override;
    function GetITransactionClass: TCRTransactionClass; override;

    property IsolationLevel; //CLR cross assemlby
  end;

{ TMyMetaData }

  TMyMetaData = class (TDAMetaData)
  private
    function GetConnection: TMyConnection;
    procedure SetConnection(Value: TMyConnection);

  published
    property Active;
    property Filtered;
    property Filter;
    property FilterOptions;
    property IndexFieldNames;

    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeScroll;
    property AfterScroll;
    property OnFilterRecord;

    property MetaDataKind;
    property Restrictions;

    property Connection: TMyConnection read GetConnection write SetConnection;
  end;

{ TMyDataSource }

  TMyDataSource = class(TCRDataSource)
  end;

  TMyAccessUtils = class
  public
    class procedure SetDesigning(Obj: TCustomMyDataSet; Value: Boolean; SetChildren: Boolean = True);

    class function FIRecordSet(Obj: TCustomMyDataSet): TMySQLRecordSet;
    class function FICommand(Obj: TComponent): TMySQLCommand;
  end;

  procedure GetDatabasesList(const Connection: TCustomMyConnection; List: _TStrings);
  procedure GetTablesList(const Connection: TCustomMyConnection; List: _TStrings);
  procedure GetServerList(List: _TStrings);
  procedure GetIndexNames(const Connection: TCustomMyConnection; List: _TStrings; TableName: _string);

  function TableNamesFromList(List: _TStrings): _string;
  procedure TableNamesToList(Value: _string; List: _TStrings);

var
  DefConnectDialogClassProc: function: TClass = nil;


implementation

uses
{$IFDEF HAVE_DIRECT}
  MySqlApiDirect,
{$IFNDEF CLR}
{$ENDIF}
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF CLR}
  Borland.Vcl.TypInfo, System.Runtime.InteropServices,
{$ELSE}
{$IFDEF VER6P}
  Variants,
{$ENDIF}
{$ENDIF}
{$IFDEF VER6P}
  DateUtils,
{$ENDIF}
  MyParser, MyDacMonitor;

function TableNamesFromList(List: _TStrings): _string;
var
  i: integer;
begin
  for i := 0 to List.Count - 1 do
    if i = 0 then
      Result := BracketIfNeed(List[i])
    else
      Result := Result + ', ' + BracketIfNeed(List[i]);
end;

procedure TableNamesToList(Value: _string; List: _TStrings);
var
  St: _string;
  i: integer;
begin
  Value := Trim(Value);
  List.Clear;

  St := '';
  for i := 1 to Length(Value) do
    if (Value[i] = ',') or (Value[i] = ';') then begin
      St := UnbracketIfPossible(Trim(St));
      if St <> '' then
        List.Add(St);
      St := '';
    end
    else
      St := St + Value[i];

  St := UnbracketIfPossible(Trim(St));
  if St <> '' then
    List.Add(St);

end;

{ SQL modify}

procedure GetDatabasesList(const Connection: TCustomMyConnection; List: _TStrings);
begin
  if Connection = nil then
    Exit;

  Connection.GetDatabaseNames(List);
end;

procedure GetTablesList(const Connection: TCustomMyConnection; List: _TStrings);
begin
  if Connection = nil then
    Exit;

  Connection.GetTableNames(List);
end;

procedure GetIndexNames(const Connection: TCustomMyConnection; List: _TStrings; TableName: _string);
begin
  if Connection = nil then
    Exit;

  Connection.GetIndexNames(List, TableName);
end;

function SetWhere(SQL: _string; Condition: _string): _string;
begin
  Result := _SetWhere(SQL, Condition, TMyParser, True);
end;

function AddWhere(SQL: _string; Condition: _string): _string;
begin
  Result := _AddWhere(SQL, Condition, TMyParser, False);
end;

function DeleteWhere(SQL: _string): _string;
begin
  Result := SetWhere(SQL, '');
end;

function GetWhere(SQL: _string): _string;
begin
  Result := _GetWhere(SQL, TMyParser, False);
end;

function SetOrderBy(SQL: _string; Fields: _string): _string;
begin
  Result := _SetOrderBy(SQL, Fields, TMyParser);
end;

function GetOrderBy(SQL: _string): _string;
begin
  Result := _GetOrderBy(SQL, TMyParser);
end;

function GetFrom(SQL: _string): _string;
begin
  Result := _GetFrom(SQL, TMyParser, False);
end;

procedure GetServerList(List: _TStrings);
{$IFDEF MSWINDOWS}
var
  (*Timeout, CacheTimeout: integer;
  Registry: TRegistry;*)
  List1: TStringList;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
(*  Timeout := 2; // defaul value = 2 seconds
  CacheTimeout := 120;
  Registry := TRegistry.Create;
  try
    if Registry.OpenKey('\SOFTWARE\Devart\MyDac\Editors\ConnectionEditor', True) then begin
      if Registry.ValueExists('WaitTime') then
        Timeout := Registry.ReadInteger('WaitTime')
      else
        Registry.WriteInteger('WaitTime', Timeout);

      if Registry.ValueExists('CacheTimeout') then
        CacheTimeout := Registry.ReadInteger('CacheTimeout')
      else
        Registry.WriteInteger('CacheTimeout', CacheTimeout);
    end;
  finally
    FreeAndNil(Registry)
  end;
  *)
  List1 := TStringList.Create;
  try
    CRNetManager.GetServerList(List1, 'mysql');
    AssignStrings(List1, List);
  finally
    List1.Free;
  end;
{$ENDIF}
end;

{ TCustomMyConnectionOptions }

constructor TCustomMyConnectionOptions.Create(Owner: TCustomDAConnection);
begin
  inherited Create(Owner);

{$IFDEF UNICODE_BUILD}
  FUseUnicode := True;
{$ENDIF}
end;

procedure TCustomMyConnectionOptions.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TCustomMyConnectionOptions then begin
    TCustomMyConnectionOptions(Dest).UseUnicode := UseUnicode;
    TCustomMyConnectionOptions(Dest).Charset := Charset;
    TCustomMyConnectionOptions(Dest).OptimizedBigInt := OptimizedBigInt;
  end;
end;

procedure TCustomMyConnectionOptions.SetUseUnicode(const Value: boolean);
begin
  if FUseUnicode <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FUseUnicode := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prUseUnicode, Value);
  end;
end;

procedure TCustomMyConnectionOptions.SetCharset(const Value: string);
begin
  if FCharset <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FCharset := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prCharset, Value);
  end;
end;

function TCustomMyConnectionOptions.GetNumericType: TDANumericType;
begin
{$IFDEF VER6P}
{$IFNDEF FPC}
  if EnableFMTBCD then
    Result := ntFmtBCD
  else
{$ENDIF}
{$ENDIF}
  if EnableBCD then
    Result := ntBCD
  else
    Result := ntFloat;
end;

procedure TCustomMyConnectionOptions.SetNumericType(Value: TDANumericType);
begin
  EnableBCD := Value = ntBCD;
{$IFDEF VER6P}
{$IFNDEF FPC}
  EnableFMTBCD := Value = ntFmtBCD;
{$ENDIF}
{$ENDIF}
end;

procedure TCustomMyConnectionOptions.SetOptimizedBigInt(const Value: boolean);
begin
  if FOptimizedBigInt <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FOptimizedBigInt := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prOptimizedBigInt, Value);
  end;
end;

{ TCustomMyConnection }

constructor TCustomMyConnection.Create(Owner: TComponent);
begin
  inherited;

  FOptions := inherited Options as TCustomMyConnectionOptions;

  Database := '';
  ConnectionTimeout := 15;
end;

destructor TCustomMyConnection.Destroy;
begin
  inherited;
end;

function TCustomMyConnection.CreateDataSet: TCustomDADataSet;
begin
  Result := TCustomMyDataSet.Create(nil);
  Result.Connection := Self;
end;

function TCustomMyConnection.CreateSQL: TCustomDASQL;
begin
  Result := TMyCommand.Create(nil);
  Result.Connection := Self;
end;

function TCustomMyConnection.CreateTransaction: TDATransaction;
begin
  Result := TMyTransaction.Create(nil);
  Result.DefaultConnection := Self;
end;

function TCustomMyConnection.CreateMetaData: TDAMetaData;
begin
  Result := TMyMetaData.Create(nil);
  Result.Connection := Self;
end;

procedure TCustomMyConnection.CreateIConnection;
var
  CRConnection: TCRConnection;
begin
  if FIConnection <> nil then
    Exit;

  CRConnection := GetMySQLConnection;
  TMySQLConnection(CRConnection).GetMySQLConnection := GetMySQLConnection;
  TMySQLConnection(CRConnection).ReturnMySQLConnection := ReturnMySQLConnection;

  SetIConnection(CRConnection);
end;

procedure TCustomMyConnection.SetIConnection(Value: TCRConnection);
begin
  inherited;

  FIConnection := Value as TMySQLConnection;
end;

{function TCustomMyConnection.GetCharset: string;
var
  p: variant;
begin
  Connect;
  Assert(FIConnection <> nil);
  Assert(IConnection.GetProp(prCharset, p));
  Result := p;
end;}

procedure TCustomMyConnection.SetOptions(Value: TCustomMyConnectionOptions);
begin
  FOptions.Assign(Value);
end;

function TCustomMyConnection.GetIConnectionClass: TCRConnectionClass;
begin
  Result := TMySQLConnection;
end;

function TCustomMyConnection.GetICommandClass: TCRCommandClass;
begin
  Result := TMySQLCommand;
end;

function TCustomMyConnection.GetIRecordSetClass: TCRRecordSetClass;
begin
  Result := TMySQLRecordSet;
end;

function TCustomMyConnection.GetIMetaDataClass: TCRMetaDataClass;
begin
  Result := TMySQLMetaData;
end;

function TCustomMyConnection.IConnection: TMySQLConnection;
begin
  Result := TMySQLConnection(FIConnection);
end;

procedure TCustomMyConnection.AssignConnectOptions(Source: TCustomDAConnection);
begin
  inherited;

  Database := TCustomMyConnection(Source).Database;
end;

procedure TCustomMyConnection.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TCustomMyConnection then begin
    TCustomMyConnection(Dest).Database := Database;
    TCustomMyConnection(Dest).ConnectionTimeout := ConnectionTimeout;
    TCustomMyConnection(Dest).IsolationLevel := IsolationLevel;
  end;
end;

function TCustomMyConnection.GetServerVersion: string;
begin
  InternalConnect;
  try
    Assert(FIConnection <> nil);
    Result := IConnection.GetServerVersionFull;
  finally
    InternalDisconnect;
  end;
end;

function TCustomMyConnection.GetThreadId: longword;
begin
  InternalConnect;
  try
    Assert(FIConnection <> nil);
    Result := IConnection.GetThreadId;
  finally
    InternalDisconnect;
  end;
end;

function TCustomMyConnection.SQLMonitorClass: TClass;
begin
  Result := TCustomMySQLMonitor;
end;

function TCustomMyConnection.ConnectDialogClass: TConnectDialogClass;
begin
  if Assigned(DefConnectDialogClassProc) then
    Result := TConnectDialogClass(DefConnectDialogClassProc)
  else
    Result := nil;
end;

procedure TCustomMyConnection.SetConnectionTimeout(const Value: integer);
begin
  if FConnectionTimeout <> Value then begin
    FConnectionTimeout := Value;
    if FIConnection <> nil then
      IConnection.SetProp(prConnectionTimeout, Value);
  end;
end;

procedure TCustomMyConnection.SetDatabase(Value: string);
begin
  if Value <> Database then begin
    FDatabase := Value;
    if FIConnection <> nil then
      IConnection.SetProp(prDatabase, Value);
  end;
end;

function TCustomMyConnection.GetIsolationLevel: TMyIsolationLevel;
begin
  Result := TMyIsolationLevel(TMyTransaction(DefaultTransaction).IsolationLevel);
end;

procedure TCustomMyConnection.SetIsolationLevel(const Value: TMyIsolationLevel);
begin
  TMyTransaction(DefaultTransaction).IsolationLevel := TCRIsolationLevel(Value);
end;

function TCustomMyConnection.NeedPrompt: boolean;
begin
  Result := LoginPrompt;
end;

procedure TCustomMyConnection.CheckInactive;
begin
  if Connected then
    if ([csUpdating, csDesigning] * ComponentState) <> [] then
      Close else
      DatabaseError(SConnectionOpen, Self);
end;

procedure TCustomMyConnection.DoConnect;
begin
  inherited;
end;
(*//upd
function TCustomMyConnection.CommitOnDisconnect: boolean;
begin
  Result := False;
end;
*)
procedure TCustomMyConnection.FillConnectionParameters(var ConnectionParameters: TMyConnectionParameters);
begin
  ConnectionParameters.MinPoolSize := PoolingOptions.MinPoolSize;
  ConnectionParameters.MaxPoolSize := PoolingOptions.MaxPoolSize;
  ConnectionParameters.ConnectionLifeTime := PoolingOptions.ConnectionLifetime;
  ConnectionParameters.Validate := PoolingOptions.Validate;
  ConnectionParameters.Username := Username;
  ConnectionParameters.Server := Server;
  ConnectionParameters.Password := Password;

  ConnectionParameters.Database := Database;
  ConnectionParameters.ConnectionTimeout := ConnectionTimeout;
  ConnectionParameters.UseUnicode := Options.UseUnicode;
  ConnectionParameters.Charset := Options.Charset;

  ConnectionParameters.Port := 0;
  ConnectionParameters.Compress := False;
  ConnectionParameters.Embedded := False;
{$IFDEF HAVE_DIRECT}
  ConnectionParameters.Direct := True;
{$ENDIF}
end;

procedure TCustomMyConnection.FillConnectionProps(MySQLConnection: TMySQLConnection);
begin
  MySQLConnection.SetProp(prDatabase, FDatabase);
  MySQLConnection.SetProp(prConnectionTimeout, FConnectionTimeout);
  if FOptions <> nil then begin
    MySQLConnection.SetProp(prUseUnicode, FOptions.FUseUnicode);
    MySQLConnection.SetProp(prCharset, FOptions.FCharset);
  end;
end;

function TCustomMyConnection.GetMySQLConnection: TMySQLConnection;
var
  ConnectionParameters: TMyConnectionParameters;
begin
  if Pooling then begin
    ConnectionParameters := TMyConnectionParameters.Create;
    try
      FillConnectionParameters(ConnectionParameters);
      Result := TMyConnectionPoolManager.GetConnection(ConnectionParameters) as TMySQLConnection;
    finally
      ConnectionParameters.Free;
    end;
  end
  else
  begin
    Result := TMySQLConnection.Create;
    FillConnectionProps(Result);
  end;

  Result.SetProp(prEnableBCD, Options.EnableBCD);
{$IFDEF VER6P}
{$IFNDEF FPC}
  Result.SetProp(prEnableFMTBCD, Options.EnableFMTBCD);
{$ENDIF}
{$ENDIF}
  Result.SetProp(prAutoCommit, AutoCommit);
  Result.SetProp(prConvertEOL, ConvertEOL);
  Result.SetProp(prOptimizedBigInt, Options.OptimizedBigInt);

  if FIConnection <> nil then
    Result.Assign(FIConnection as TMySQLConnection);
end;

procedure TCustomMyConnection.ReturnMySQLConnection(CRConnection: TCRConnection);
begin
  if Pooling then
    CRConnection.ReturnToPool
  else
    CRConnection.Free;
end;

procedure TCustomMyConnection.AssignConnect(Source: TCustomMyConnection);
begin
  inherited AssignConnect(Source);
end;

function TCustomMyConnection.ExecSQL(Text: _string;
  const Params: array of variant): variant;
var
  i: integer;
  SQLResult: pMYSQL_RES;
  SQLText: AnsiString;
begin
  CheckCommand;

  if Length(Params) = 0 then begin
    InternalConnect;
    try
      Connect;

      // Quick execute
      // WAR: without Debug!
      IConnection.MySQLAPI.SetTimeout(IConnection.MySQL, FConnectionTimeout);
      if Options.UseUnicode then
        SQLText := UTF8Encode(Text)
      else
        SQLText := AnsiString(Text);
      IConnection.Check(IConnection.MySQLAPI.mysql_real_query(IConnection.MySQL, SQLText, Length(SQLText)), Self);
      SQLResult := IConnection.MySQLAPI.mysql_use_result(IConnection.MySQL);
      if SQLResult <> nil then
        IConnection.MySQLAPI.mysql_free_result(SQLResult);
    finally
      InternalDisconnect;
    end;
  end
  else
  begin
    FCommand.SQL.Text := ''; // drop params from previous sql
    FCommand.SQL.Text := Text;
    TMyCommand(FCommand).CommandTimeout := FConnectionTimeout;

    for i := 0 to FCommand.ParamCount - 1 do
      if i <= High(Params) then
        FCommand.Params[i].Value := Params[i]
      else
        FCommand.Params[i].Value := Null;

    FCommand.Execute;
  end;

  Result := Null; // For current MySQL server version
end;

procedure TCustomMyConnection.GetStoredProcNames(List: _TStrings; AllProcs: boolean = False);
var
  MyQuery: TMyQuery;

  OldConnected: boolean;
  Major, Minor, Release: integer;
  OldDatabase: string;
  db_name: string;
begin
  // inherited method (TMySQLMetaData) uses information_schema.routines for all versions
  if AllProcs then begin
    inherited;
    exit;
  end;

  List.Clear;

  OldConnected := Connected;
  OldDatabase := Database;

  MyQuery := TMyQuery.Create(nil);
  try
    if not OldConnected then
      Database := '';

    Connect;
    Major := IConnection.ServerPrimaryVer;
    Minor := IConnection.ServerMinorVer;
    Release := IConnection.ServerReleaseVer;
    if Major < 5 then
      Exit;

    MyQuery.Connection := Self;
    if (Major = 5) and (Minor = 0) and (Release = 0) then
      MyQuery.SQL.Text := 'SELECT name FROM mysql.proc ORDER BY name'
    else begin
      if OldDatabase = '' then
        db_name := '''mysql'''
      else // Can't use LOWER(OldDatabase) (5.0.9 bug)
        db_name := '''' + AnsiLowerCase(BracketIfNeed(OldDatabase)) + '''';

      if (Major = 5) and (Minor = 0) and (Release < 4) then
        MyQuery.SQL.Text := 'SELECT name FROM mysql.proc WHERE LOWER(db) = ' + db_name + ' ORDER BY name'
      else
        MyQuery.SQL.Text := 'SELECT ROUTINE_NAME FROM information_schema.routines WHERE LOWER(routine_schema) = ' + db_name + ' ORDER BY ROUTINE_NAME'

    end;
    MyQuery.FetchAll := True;
    MyQuery.Open;
    while not MyQuery.Eof do begin
      List.Add(_VarToStr(MyQuery.Fields[0].Value));
      MyQuery.Next;
    end;
  finally
    MyQuery.Free;

    if not OldConnected then
      Connected := False;

    Database := OldDatabase;
  end;
end;

procedure TCustomMyConnection.GetCharsetNames(List: _TStrings);
var
  MyQuery: TMyQuery;
begin
  List.Clear;

  InternalConnect;
  try
    if (IConnection.ServerPrimaryVer < 4)
      or ((IConnection.ServerPrimaryVer = 4) and (IConnection.ServerMinorVer = 0))
    then
      Exit;

    MyQuery := TMyQuery.Create(nil);
    try
      MyQuery.Connection := Self;
      MyQuery.SQL.Text := 'SHOW CHARSET';
      MyQuery.FetchAll := True;
      MyQuery.Open;
      while not MyQuery.Eof do begin
        List.Add(MyQuery.Fields[0].AsString);
        MyQuery.Next;
      end;
    finally
      MyQuery.Free;
    end;
  finally
    InternalDisconnect;
  end;
end;

procedure TCustomMyConnection.GetIndexNames(List: _TStrings; TableName: _string);
var
  MetaData: TDAMetaData;
  Name: _string;
begin
  MetaData := CreateMetaData;
  try
    MetaData.MetaDataKind := 'indexes';
    MetaData.Restrictions.Add('table_name=' + TMyTableInfo.NormalizeName(TableName));
    MetaData.Open;
    List.Clear;
    while not MetaData.Eof do begin
      Name := _VarToStr(MetaData.FieldByName('INDEX_NAME').Value);
      List.Add(Name);
      MetaData.Next;
    end;
  finally
    MetaData.Free;
  end;
end;

function TCustomMyConnection.GetExecuteInfo: string;
begin
  Connect;
  Assert(FIConnection <> nil);

  Result := string(IConnection.MySQLAPI.mysql_info(IConnection.MySQL));
end;

procedure TCustomMyConnection.Ping;
begin
  Connect;
  Assert(FIConnection <> nil);

  IConnection.MySQLAPI.SetTimeout(IConnection.MySQL, FConnectionTimeout);
  if IConnection.MySQLAPI.mysql_ping(IConnection.MySQL) <> 0 then // connection lost
    IConnection.MySQLError(Self);
end;

procedure TCustomMyConnection.Savepoint(const Name: _string);
begin
  DoSavepoint(Name);
end;

procedure TCustomMyConnection.ReleaseSavepoint(const Name: _string);
begin
  DoReleaseSavepoint(Name);
end;

procedure TCustomMyConnection.RollbackToSavepoint(const Name: _string);
begin
  DoRollbackToSavepoint(Name);
end;

{ TMyConnectionOptions }

procedure TMyConnectionOptions.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TMyConnectionOptions then begin
    TMyConnectionOptions(Dest).Compress := Compress;
    TMyConnectionOptions(Dest).Protocol := Protocol;
  end;
end;

constructor TMyConnectionOptions.Create(Owner: TMyConnection);
begin
  inherited Create(Owner);
{$IFDEF HAVE_DIRECT}
  FDirect := True;
{$ENDIF}
end;

procedure TMyConnectionOptions.SetCompress(const Value: boolean);
begin
  if FCompress <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FCompress := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prCompress, Value);
  end;
end;

procedure TMyConnectionOptions.SetProtocol(const Value: TMyProtocol);
begin
  if FProtocol <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FProtocol := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prProtocol, Integer(Value));
  end;
end;

{$IFDEF HAVE_DIRECT}
procedure TMyConnectionOptions.SetDirect(const Value: boolean);
begin
  if FDirect <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FDirect := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prDirect, Value);
  end;
end;
{$ENDIF}

procedure TMyConnectionOptions.SetEmbedded(const Value: boolean);
begin
  if FEmbedded <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FEmbedded := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prEmbedded, Value);
  end;
end;

procedure TMyConnectionOptions.SetCheckBackslashes(const Value: boolean);
begin
  if FCheckBackslashes <> Value then begin
    FCheckBackslashes := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prCheckBackslashes, Value);
  end;
end;

{ TMyConnection }

constructor TMyConnection.Create(Owner: TComponent);
begin
  inherited;
  Port := MYSQL_PORT;
{$IFDEF HAVE_OPENSSL}
  FSSLOptions := TMyConnectionSSLOptions.Create(Self);
{$ENDIF}
end;

destructor TMyConnection.Destroy;
begin
{$IFDEF HAVE_OPENSSL}
  SSLOptions.Free;
{$ENDIF}

  inherited;
end;

procedure TMyConnection.AssignTo(Dest: TPersistent);
begin
  if Dest is TMyConnection then begin
    TMyConnection(Dest).Port := Port;
  {$IFDEF HAVE_OPENSSL}
    SSLOptions.AssignTo(TMyConnection(Dest).SSLOptions);
  {$ENDIF}
  end;
  inherited;
end;

function TMyConnection.GetClientVersion: string;
var
  Conn: TMySQLConnection;
begin
{$IFDEF HAVE_DIRECT}
  if Options.Direct and not Options.Embedded then
    Result := MYSQL_SERVER_VERSION
  else
{$ENDIF}
  if Connected then
  begin
    Assert(FIConnection <> nil);
    Result := IConnection.GetClientVersion;
  end
  else
  begin
    Conn := TMySQLConnection.Create;
    try
      Conn.SetProp(prEmbedded, Options.Embedded);
    {$IFDEF HAVE_DIRECT}
      Conn.SetProp(prDirect, False);
    {$ENDIF}
      Result := Conn.GetClientVersion;
    finally
      Conn.Free;
    end;
  end
end;

function TMyConnection.GetEmbedded: boolean;
begin
  Assert(FOptions <> nil);
  Result := Options.Embedded;
end;

procedure TMyConnection.SetEmbedded(Value: boolean);
begin
  Assert(FOptions <> nil);
  Options.Embedded := Value;
end;

function TMyConnection.CreateOptions: TDAConnectionOptions;
begin
  Result := TMyConnectionOptions.Create(Self);
end;

function TMyConnection.GetOptions: TMyConnectionOptions;
begin
  Result := FOptions as TMyConnectionOptions;
end;

procedure TMyConnection.SetOptions(Value: TMyConnectionOptions);
begin
  FOptions.Assign(Value);
end;

{$IFDEF HAVE_OPENSSL}
procedure TMyConnection.SetSSLOptions(Value: TMyConnectionSSLOptions);
begin
  FSSLOptions.Assign(Value);
end;
{$ENDIF}

procedure TMyConnection.SetPort(Value: integer);
begin
  if FPort <> Value then begin
    Disconnect;
    FPort := Value;
    if FIConnection <> nil then
      IConnection.SetProp(prPort, Value);
  end;
end;

procedure TMyConnection.FillConnectionParameters(var ConnectionParameters: TMyConnectionParameters);
begin
  inherited;

  ConnectionParameters.Port := Port;
  ConnectionParameters.Compress := Options.Compress;
  ConnectionParameters.Protocol := Options.Protocol;
  ConnectionParameters.Embedded := Options.Embedded;
{$IFDEF HAVE_DIRECT}
  ConnectionParameters.Direct := Options.Direct;
{$ENDIF}

  ConnectionParameters.IOHandler := FIOHandler;
{$IFDEF HAVE_OPENSSL}
  ConnectionParameters.SSL_Chipher := SSLOptions.ChipherList;
  ConnectionParameters.SSL_CA := SSLOptions.CACert;
  ConnectionParameters.SSL_Key := SSLOptions.Key;
  ConnectionParameters.SSL_Cert := SSLOptions.Cert;
{$ENDIF}
end;

procedure TMyConnection.FillConnectionProps(MySQLConnection: TMySQLConnection);
begin
  inherited;

  MySQLConnection.IOHandler := FIOHandler;
  MySQLConnection.SetProp(prPort, FPort);
  if FOptions <> nil then begin
    MySQLConnection.SetProp(prEmbedded, Options.Embedded);
  {$IFDEF HAVE_DIRECT}
    MySQLConnection.SetProp(prDirect, Options.Direct);
  {$ENDIF}
    MySQLConnection.SetProp(prCompress, Options.FCompress);
    MySQLConnection.SetProp(prProtocol, Integer(Options.FProtocol));

  {$IFDEF HAVE_OPENSSL}
    MySQLConnection.SetProp(prSSL_Chipher, SSLOptions.ChipherList);
    MySQLConnection.SetProp(prSSL_CA, SSLOptions.CACert);
    MySQLConnection.SetProp(prSSL_Key, SSLOptions.Key);
    MySQLConnection.SetProp(prSSL_Cert, SSLOptions.Cert);
  {$ENDIF}
  end;
end;

{ TMyDataSetOptions }

constructor TMyDataSetOptions.Create(Owner: TCustomDADataSet);
begin
  inherited Create(Owner);

  LongStrings := True; /// SHOW CREATE TABLE on old MySQL servers (4.0.12?). See CR-M3578
  RequiredFields := False;
  FNullForZeroDate := True;
  CheckRowVersion := False;
  FEnableBoolean := True;
  FBinaryAsString := True;
{$IFDEF MSWINDOWS}
  FAutoRefreshInterval := 60;
{$ENDIF}
  FieldsOrigin := True;
  FCreateConnection := True;
end;

procedure TMyDataSetOptions.AssignTo(Dest: TPersistent); 
begin
  inherited;

  if Dest is TMyDataSetOptions then begin
    TMyDataSetOptions(Dest).LongStrings := LongStrings;
    TMyDataSetOptions(Dest).FullRefresh := FullRefresh;

    TMyDataSetOptions(Dest).FieldsAsString := FieldsAsString;
  {$IFDEF HAVE_COMPRESS}
    TMyDataSetOptions(Dest).CompressBlobMode := CompressBlobMode;
  {$ENDIF}
    TMyDataSetOptions(Dest).NullForZeroDate := NullForZeroDate;
    TMyDataSetOptions(Dest).EnableBoolean := EnableBoolean;
    TMyDataSetOptions(Dest).BinaryAsString := BinaryAsString;
    TMyDataSetOptions(Dest).FieldsOrigin := FieldsOrigin;
    TMyDataSetOptions(Dest).CreateConnection := CreateConnection;
  end;
end;

procedure TMyDataSetOptions.SetFieldsAsString(Value: boolean);
begin
  if FFieldsAsString <> Value then begin
    TCustomMyDataSet(FOwner).CheckInactive;
    FFieldsAsString := Value;
    if TCustomMyDataSet(FOwner).FIRecordSet <> nil then
      TCustomMyDataSet(FOwner).FIRecordSet.SetProp(prFieldsAsString, Value);
    FOwner.FieldDefs.Updated := False;
  end;
end;

procedure TMyDataSetOptions.SetNullForZeroDate(Value: boolean);
begin
  if FNullForZeroDate <> Value then begin
    TCustomMyDataSet(FOwner).CheckInactive;
    FNullForZeroDate := Value;
    if TCustomMyDataSet(FOwner).FIRecordSet <> nil then
      TCustomMyDataSet(FOwner).FIRecordSet.SetProp(prNullForZeroDate, Value)
  end;
end;

procedure TMyDataSetOptions.SetEnableBoolean(Value: boolean);
begin
  if FEnableBoolean <> Value then begin
    TCustomMyDataSet(FOwner).CheckInactive;
    FEnableBoolean := Value;
    if TCustomMyDataSet(FOwner).FIRecordSet <> nil then
      TCustomMyDataSet(FOwner).FIRecordSet.SetProp(prEnableBoolean, Value);
    FOwner.FieldDefs.Updated := False;
  end;
end;

procedure TMyDataSetOptions.SetBinaryAsString(Value: boolean);
begin
  if FBinaryAsString <> Value then begin
    TCustomMyDataSet(FOwner).CheckInactive;
    FBinaryAsString := Value;
    if TCustomMyDataSet(FOwner).FIRecordSet <> nil then
      TCustomMyDataSet(FOwner).FIRecordSet.SetProp(prBinaryAsString, Value);
    FOwner.FieldDefs.Updated := False;
  end;
end;

{$IFDEF MSWINDOWS}
procedure TMyDataSetOptions.SetAutoRefresh(Value: boolean);
begin
  if FAutoRefresh <> Value then begin
    FAutoRefresh := Value;
    if not (csDesigning in FOwner.ComponentState) then begin
      TCustomMyDataSet(FOwner).CheckAutoRefreshTimer;
      TCustomMyDataSet(FOwner).FAutoRefreshTimer.Enabled := Value;
    end;
  end;
end;

procedure TMyDataSetOptions.SetAutoRefreshInterval(Value: integer);
begin
  if FAutoRefreshInterval <> Value then begin
    FAutoRefreshInterval := Value;
    if TCustomMyDataSet(FOwner).FAutoRefreshTimer <> nil then
      TCustomMyDataSet(FOwner).FAutoRefreshTimer.Interval := Value * MSecsPerSec;
  end;
end;
{$ENDIF}

procedure TMyDataSetOptions.SetCreateConnection(Value: boolean);
begin
  if FCreateConnection <> Value then begin
    TCustomMyDataSet(FOwner).CheckInactive;
    FCreateConnection := Value;
    if TCustomMyDataSet(FOwner).FIRecordSet <> nil then
      TCustomMyDataSet(FOwner).FIRecordSet.SetProp(prCreateConnection, Value);
  end;
end;

procedure TMyDataSetOptions.SetCheckRowVersion(const Value: boolean);
begin
  FCheckRowVersion := Value;
  if TCustomMyDataSet(FOwner).FDataSetService <> nil then
    TCustomMyDataSet(FOwner).FDataSetService.SetProp(prCheckRowVersion, Value);
end;

{ TMyDataSetService }

procedure TMyDataSetService.CreateSQLGenerator;
begin
  SetSQLGenerator(TMySQLGenerator.Create(Self));
end;

procedure TMyDataSetService.CreateDataSetUpdater;
begin
  SetDataSetUpdater(TMyDataSetUpdater.Create(Self));
end;

{ TMyDataSetUpdater }

procedure TMyDataSetUpdater.SetUpdateQueryOptions(const StatementType: TStatementType);
var
  Source, Dest: TCustomMyDataSet;
begin
  Source := TCustomMyDataSet(FDataSet);
  Dest := TCustomMyDataSet(UpdateQuery);

  Dest.Options.EnableBoolean := Source.Options.EnableBoolean;
end;

{ TCustomMyDataSet }

constructor TCustomMyDataSet.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FOptions := inherited Options as TMyDataSetOptions;

  FetchAll := True;
  CommandTimeout := DefaultCommandTimeout;

{$IFDEF MSWINDOWS}
  FAutoRefreshTimer := nil;
{$ENDIF}
end;

destructor TCustomMyDataSet.Destroy;
begin
{$IFDEF MSWINDOWS}
  FAutoRefreshTimer.Free;
{$ENDIF}
  
  inherited;
end;

function TCustomMyDataSet.OpenNext: boolean;
begin
  Result := DoOpenNext;
end;

procedure TCustomMyDataSet.RefreshQuick(const CheckDeleted: boolean);
begin
  InternalRefreshQuick(CheckDeleted);
end;

procedure TCustomMyDataSet.BreakExec;
begin
  Assert(FICommand <> nil);
  FICommand.BreakExec;
  FIRecordSet.BreakFetch;
end;

{$IFDEF MSWINDOWS}
procedure TCustomMyDataSet.CheckAutoRefreshTimer;
begin
  if FAutoRefreshTimer = nil then begin
    FAutoRefreshTimer := TWin32Timer.Create(nil);
    FAutoRefreshTimer.OnTimer := AutoRefreshTimer;
    FAutoRefreshTimer.Interval := Options.AutoRefreshInterval * MSecsPerSec;
    FAutoRefreshTimer.Enabled := Options.AutoRefresh;
  end;
end;

procedure TCustomMyDataSet.AutoRefreshTimer(Sender: TObject);
begin
  if State = dsBrowse then begin
    try
      if FDataSetService.TimestampField <> nil then
        RefreshQuick(True)
      else
        Refresh;
    except
      Options.AutoRefresh := False;
      raise;
    end;
    // Reset timer
    FAutoRefreshTimer.Enabled := False;
    FAutoRefreshTimer.Enabled := True;
  end;
end;
{$ENDIF}

procedure TCustomMyDataSet.LockTable(LockType: TLockType);
var
  TableName: _string;
  s: _string;
begin
  CheckActive;

  Assert(FDataSetService <> nil);
  if FDataSetService.UpdatingTableInfoIdx = - 1 then
    Exit;

  if FetchAll = False then
    DatabaseError(SLockTableVsFetchAll);
  if Connection = nil then
    DatabaseError(SConnectionNotDefined);

  TableName := TablesInfo[FDataSetService.UpdatingTableInfoIdx].TableName;

  case LockType of
    ltRead:
      s := 'LOCK TABLES ' + TableName + ' READ';
    ltReadLocal:
      s := 'LOCK TABLES ' + TableName + ' READ LOCAL';
    ltWrite:
      s := 'LOCK TABLES ' + TableName + ' WRITE';
    ltWriteLowPriority:
      s := 'LOCK TABLES ' + TableName + ' LOW_PRIORITY WRITE';
  end;

  Connection.ExecSQL(s, []);
end;

procedure TCustomMyDataSet.UnLockTable;
begin
  if Connection = nil then
    DatabaseError(SConnectionNotDefined);

  Connection.ExecSQL('UNLOCK TABLES', []);
end;

procedure TCustomMyDataSet.Lock;
begin
  Lock(lrImmediately);
end;

procedure TCustomMyDataSet.Lock(LockType: TLockRecordType);
begin
  CheckActive;
  if RecordCount = 0 then
    DatabaseError(SNoRecordToLock);

  Assert(FDataSetService <> nil);
  FDataSetService.SetProp(prLockType, Variant(LockType));

  inherited Lock;
end;

procedure TCustomMyDataSet.GetFieldEnum(List: _TStrings; FieldName: _string; TableName: _string = '');
var
  Query: TMyQuery;
  s, val: string;
  CurrPos: integer;
  n: integer;
  ReadingValue: Boolean;

  function NormalizeFieldName(Value: _string): _string;
  var
    i: integer;
    c: _char;
  begin
    Result := '';
    for i := 1 to length(Value) do begin
      c := Value[i];
      case c of
        '%', '''', '\':
         Result := Result + '\' + c;
        else
          Result := Result + c;
      end;
    end;
  end;

begin
  if FieldName = '' then
    raise EDatabaseError.Create(SFieldNameNotDefined);

  if TableName = '' then
    if TCRFieldDesc(GetFieldDesc(FieldName)).TableInfo <> nil then
      TableName := TCRFieldDesc(GetFieldDesc(FieldName)).TableInfo.TableName;
  List.Clear;
  CurrPos := -1;
  Query := TMyQuery.Create(nil);

  try
    Query.Connection := Connection;   // unable to use EscapeAndQuoteStr
    CheckDataSetService;
    Query.SQL.Text := 'DESCRIBE ' + FDataSetService.QuoteName(TableName) + ' ' +
      FDataSetService.QuoteName(NormalizeFieldName(FieldName));
    Query.Open;
    if Query.RecordCount = 0 then
      raise EDatabaseError.Create(Format(SFieldNotFound, [FieldName]));
    if Query.RecordCount > 1 then
      raise EDatabaseError.Create(sMultipleFieldsFound);
    s := Query.FieldByName('Type').AsString;
    Query.Close;
  finally
    Query.Free;
  end;

  if pos('enum', s) = 1 then
    CurrPos := 7
  else
    if pos('set', s) = 1 then
      CurrPos := 6;

  if CurrPos < 0 then // field is not of ENUM or SET type
    Exit;

  n := length(s);
  ReadingValue := True;
  val := '';
    while CurrPos <= n do begin
      if ReadingValue then
        if (s[CurrPos] = '''') then begin
          if (CurrPos < n) and (s[CurrPos + 1] = '''') then begin //quote char in value
            val := val + s[CurrPos];          // read it
            inc(CurrPos);                     // and jump over one quote
          end
          else begin
            ReadingValue := False;   // stop reading value
            List.Add(val);
          end;
        end
        else
          val := val + s[CurrPos]       // continue reading value
      else
        if s[CurrPos] = '''' then begin // start reading new value
          val := '';
          ReadingValue := True;
        end;
      Inc(CurrPos);
    end;
end;

function TCustomMyDataSet.GetConnection: TCustomMyConnection;
begin
  Result := TCustomMyConnection(inherited Connection);
end;

procedure TCustomMyDataSet.SetConnection(Value: TCustomMyConnection);
begin
  inherited Connection := Value;
end;

{$IFDEF WITH_IPROVIDER}
function TCustomMyDataSet.PSGetQuoteChar: string;
begin
  Result := '`';
end;
{$ENDIF}

procedure TCustomMyDataSet.CreateFieldDefs;
begin
  if Prepared and (TCRRecordSet(Data).CommandType = ctCursor) then
    FieldDefs.Updated := False;

  inherited;
end;

procedure TCustomMyDataSet.CreateIRecordSet;
begin
  inherited;

  if FIRecordSet = nil then
    SetIRecordSet(TMySQLRecordSet.Create);
end;

procedure TCustomMyDataSet.SetIRecordSet(Value: TData);
var
  b: boolean;
begin
  inherited;

  FIRecordSet := TMySQLRecordSet(Value);

  if FIRecordSet <> nil then begin
    FICommand := TMySQLCommand(FIRecordSet.GetCommand);

    if FOptions <> nil then begin
      FIRecordSet.SetProp(prFieldsAsString, FOptions.FFieldsAsString);
      FIRecordSet.SetProp(prNullForZeroDate, FOptions.FNullForZeroDate);
      FIRecordSet.SetProp(prEnableBoolean, FOptions.FEnableBoolean);
      FIRecordSet.SetProp(prBinaryAsString, FOptions.FBinaryAsString);
      FIRecordSet.SetProp(prCreateConnection, FOptions.FCreateConnection);
    end;

    b := True;
    FIRecordSet.SetProp(prEnableEmptyStrings, b);
    FIRecordSet.SetProp(prCommandTimeout, CommandTimeout);
  end
  else
    FICommand := nil;
end;

procedure TCustomMyDataSet.CreateCommand;
begin
  SetCommand(TMyCommand.Create(Self));
end;

function TCustomMyDataSet.CreateOptions: TDADataSetOptions;
begin
  Result := TMyDataSetOptions.Create(Self);
end;

procedure TCustomMyDataSet.SetOptions(Value: TMyDataSetOptions);
begin
  Options.Assign(Value);
end;

function TCustomMyDataSet.GetDataSetServiceClass: TDataSetServiceClass;
begin
  Result := TMyDataSetService;
end;

procedure TCustomMyDataSet.SetDataSetService(Value: TDataSetService);
begin
  inherited;

  FDataSetService := TMyDataSetService(Value);

  if FDataSetService <> nil then begin
    FDataSetService.SetProp(prCheckRowVersion, Options.CheckRowVersion);
  end;
end;

procedure TCustomMyDataSet.SetCommandTimeout(const Value: integer);
begin
  if FCommandTimeout <> Value then begin
    FCommandTimeout := Value;
    if FIRecordSet <> nil then
      FIRecordSet.SetProp(prCommandTimeout, FCommandTimeout);
  end;
end;

procedure TCustomMyDataSet.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TCustomMyDataSet then
    TCustomMyDataSet(Dest).Params.Assign(Params);
end;

procedure TCustomMyDataSet.BeforeOpenCursor(InfoQuery: boolean);
begin

  if SQL.Count = 0 then
    DatabaseError(SEmptySQLStatement, Self);
    
  inherited;
end;

procedure TCustomMyDataSet.DoAfterExecute(Result: boolean);
begin
  FAfterExecProcessing := Result;
  try
    inherited;
  finally
    FAfterExecProcessing := False;
  end;
end;

function TCustomMyDataSet.GetIsQuery: boolean;
var
  CRConnection: TMySQLConnection;
begin
  if (FIRecordSet.CommandType = ctUnknown)
    and (UsedConnection <> nil) and UsedConnection.Options.DisconnectedMode
    and FAfterExecProcessing
    and (FICommand.GetCursorState = csExecuted)
  then begin
    CRConnection := TMySQLConnection(TDBAccessUtils.GetIConnection(UsedConnection));
    if (CRConnection <> nil)
      and CRConnection.IsValid
      and not CRConnection.Reconnected then begin
      Result := True; /// CR 20648
      Exit;
    end;
  end;

  Result := inherited GetIsQuery;
end;

procedure TCustomMyDataSet.InternalOpen;
begin
  TMySQLConnection(TDBAccessUtils.GetIConnection(UsedConnection)).Reconnected := False; /// CR 20648
  inherited;
end;

procedure TCustomMyDataSet.InternalClose;
begin
  inherited;
end;

{function TCustomMyDataSet.GetActualFieldName(FldDesc: TFieldDesc; IsRefresh: boolean): string;
var
  SQLObjName: string;
  SQLObjIdx: integer;
begin
  if not IsRefresh then begin
    Result := FldDesc.Name;
    if Result = '' then
      Result := FldDesc.ActualName;
    Result := QuoteName(Result);
    Exit;
  end;

  if Self is TCustomMyTable then
    SQLObjName := TCustomMyTable(Self).FTableName
  else
    SQLObjName := GenerateTableName(FldDesc);

  if SQLObjName <> '' then begin // All
    SQLObjIdx := FIRecordSet.GetSQLObjectIndex(SQLObjName);
    Assert(SQLObjIdx <> - 1);

    if TablesInfo[SQLObjIdx].TableAlias <> '' then
      Result := TablesInfo[SQLObjIdx].TableAlias + '.' + QuoteName(FldDesc.ActualName)
    else
      Result := TablesInfo[SQLObjIdx].TableName + '.' + QuoteName(FldDesc.ActualName);
  end
  else
    Result := QuoteName(FldDesc.ActualName);
end;}

procedure TCustomMyDataSet.CheckInactive; 
begin
  inherited;
end;

{ Before / After UpdateExecute }

function TCustomMyDataSet.AssignedBeforeUpdateExecute: boolean;
begin
  Result := Assigned(FBeforeUpdateExecute);
end;

procedure TCustomMyDataSet.DoBeforeUpdateExecute(Sender: TDataSet; StatementTypes: TStatementTypes;
  Params: TDAParams);
begin
  if AssignedBeforeUpdateExecute then
    FBeforeUpdateExecute(Sender as TCustomMyDataSet, StatementTypes, Params);
end;

function TCustomMyDataSet.AssignedAfterUpdateExecute: boolean;
begin
  Result := Assigned(FAfterUpdateExecute);
end;

procedure TCustomMyDataSet.DoAfterUpdateExecute(Sender: TDataSet; StatementTypes: TStatementTypes;
  Params: TDAParams);
begin
  if AssignedAfterUpdateExecute then
    FAfterUpdateExecute(Sender as TCustomMyDataSet, StatementTypes, Params);
end;

function TCustomMyDataSet.SQLGetFrom(SQLText: _string): _string;
begin
  Result := {$IFDEF CLR}Devart.MyDac.{$ENDIF}MyAccess.GetFrom(SQLText);
end;

function TCustomMyDataSet.SQLAddWhere(SQLText, Condition: _string): _string;
begin
  Result := {$IFDEF CLR}Devart.MyDac.{$ENDIF}MyAccess.AddWhere(SQLText, Condition);
end;

function TCustomMyDataSet.SQLDeleteWhere(SQLText: _string): _string;
begin
  Result := {$IFDEF CLR}Devart.MyDac.{$ENDIF}MyAccess.DeleteWhere(SQLText);
end;

function TCustomMyDataSet.SQLGetWhere(SQLText: _string): _string;
begin
  Result := {$IFDEF CLR}Devart.MyDac.{$ENDIF}MyAccess.GetWhere(SQLText);
end;

function TCustomMyDataSet.SQLSetOrderBy(SQLText: _string; Fields: _string): _string;
begin
  Result := {$IFDEF CLR}Devart.MyDac.{$ENDIF}MyAccess.SetOrderBy(SQLText, Fields);
end;

function TCustomMyDataSet.SQLGetOrderBy(SQLText: _string): _string;
begin
  Result := {$IFDEF CLR}Devart.MyDac.{$ENDIF}MyAccess.GetOrderBy(SQLText);
end;

procedure TCustomMyDataSet.WriteFieldXMLDataType(Field: TField; FieldDesc: TFieldDesc; const FieldAlias: _string; XMLWriter: XMLTextWriter);
begin
  inherited;

  if FieldDesc is TMySQLFieldDesc then begin
    if TMySQLFieldDesc(FieldDesc).IsAutoIncrement
      and not (Field.Required and not Field.ReadOnly) // Already writed in MemDS
    then
      XmlWriter.WriteAttributeString('rs:maybenull', 'false');
  end;
end;

procedure TCustomMyDataSet.WriteFieldXMLAttributeType(Field: TField; FieldDesc: TFieldDesc; const FieldAlias: _string; XMLWriter: XMLTextWriter);
begin
  inherited;

  if FieldDesc is TMySQLFieldDesc then begin
    {if TMySQLFieldDesc(FieldDesc).BaseCatalogName <> '' then
      XmlWriter.WriteAttributeString('rs:basecatalog', TMySQLFieldDesc(FieldDesc).BaseCatalogName);}

    if TMySQLFieldDesc(FieldDesc).MySQLType = FIELD_TYPE_TIMESTAMP then
      XmlWriter.WriteAttributeString('rs:rowver', 'true');
  end;
end;

function TCustomMyDataSet.GetUpdateObject: TMyUpdateSQL;
begin
  Result := TMyUpdateSQL(inherited UpdateObject);
end;

procedure TCustomMyDataSet.SetUpdateObject(Value: TMyUpdateSQL);
begin
  inherited UpdateObject := Value;
end;

{ TMyUpdateSQL }

function TMyUpdateSQL.DataSetClass: TCustomDADataSetClass;
begin
  Result := TCustomMyDataSet;
end;

function TMyUpdateSQL.SQLClass: TCustomDASQLClass;
begin
  Result := TMyCommand;
end;

{ TMyTable }

{ TMyTableOptions }

constructor TMyTableOptions.Create(Owner: TCustomDADataSet);
begin
  inherited Create(Owner);

  FUseHandler := False;
  FHandlerIndex := '';
end;

procedure TMyTableOptions.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TMyTableOptions then begin
    TMyTableOptions(Dest).UseHandler := UseHandler;
    TMyTableOptions(Dest).HandlerIndex := HandlerIndex;
  end;
end;

procedure TMyTableOptions.SetUseHandler(const Value: boolean);
begin
  if FUseHandler <> Value then begin
    TCustomMyDataSet(FOwner).CheckInactive;
    FUseHandler := Value;
    if TCustomMyDataSet(FOwner).FIRecordSet <> nil then
      TCustomMyDataSet(FOwner).FIRecordSet.SetProp(prUseHandler, Value);
    TCustomMyDataSet(FOwner).SQL.Clear;
  end;
end;

procedure TMyTableOptions.SetHandlerIndex(const Value: _string);
begin
  if FHandlerIndex <> Value then begin
    TCustomMyDataSet(FOwner).CheckInactive;
    FHandlerIndex := Value;
  end;
end;

{ TCustomMyTable }
 
{$IFDEF WITH_IPROVIDER}
function TCustomMyTable.PSGetTableName: string;
begin
  Result := TableName;
end;

procedure TCustomMyTable.PSSetParams(AParams: DB.TParams);
var
  St: _string;
  i: integer;
begin
  if (Params.Count <> AParams.Count) then begin
    SQL.Text := '';
    St := '';
    
    for i := 0 to AParams.count - 1 do begin
      if St <> '' then
        St := St + ' AND ';
      St := AParams[i].Name + ' = :' + AParams[i].Name;
    end;

    PrepareSQL;

    if St <> '' then
      AddWhere(St);
  end;

  inherited;
end;

procedure TCustomMyTable.PSSetCommandText(const CommandText: string);
begin
  if CommandText <> '' then
    TableName := CommandText;
end;
{$ENDIF}

procedure TCustomMyTable.SetTableName(const Value: _string);
begin
  if not (csReading in ComponentState) then begin
    Active := False;
    SQL.Clear;
    FIndexDefs.Updated := False;
  end;
  FTableName := UnbracketIfPossible(Trim(Value));
end;

procedure TCustomMyTable.SetOrderFields(Value: _string);
var
  OldActive: boolean;
begin
  Value := Trim(Value);
  if Value <> FOrderFields then begin
    FOrderFields := Value;
    OldActive := Active;
    if not (csLoading in ComponentState) then
      SQL.Text := '';

    if OldActive then
      Open;
  end;
end;

constructor TCustomMyTable.Create(Owner: TComponent);
begin
  inherited;
  FLimit := -1;
  FIndexDefs := TIndexDefs.Create(Self);
end;

destructor TCustomMyTable.Destroy;
begin
  FIndexDefs.Free;
  inherited;
end;

procedure TCustomMyTable.SetLimit(const Value: integer);
begin
  Active := False;
  FLimit := Value;

  SQL.Clear;
end;

procedure TCustomMyTable.SetOffset(const Value: integer);
begin
  Active := False;
  FOffset := Value;

  SQL.Clear;
end;

procedure TCustomMyTable.PrepareSQL;
begin
  if SQL.Count = 0 then begin
    if TableName = '' then
      DatabaseError(STableNameNotDefined);

    CheckDataSetService;
    with TCustomMySQLGenerator(FDataSetService.SQLGenerator) do begin
      Limit := FLimit;
      Offset := FOffset;
      UseHandler := Options.UseHandler; //TODO: add support in UniDAC
      HandlerIndex := Options.HandlerIndex;
    end;

    SQL.Text := TMyDataSetService(FDataSetService).SQLGenerator.GenerateTableSQL(TableName, OrderFields);
  end;
end;

procedure TCustomMyTable.Prepare;
begin
  PrepareSQL;

  inherited;
end;

function TCustomMyTable.SeparatedHandler: boolean;
begin
  Result := Options.UseHandler;
  if Result then begin
    Assert(Connection <> nil);
    Assert(Connection.IConnection <> nil);

    Result := not Connection.IConnection.IsClient41 or not Connection.IConnection.IsServer41;
  end;
end;

procedure TCustomMyTable.BeforeOpenCursor(InfoQuery: boolean);
begin
  PrepareSQL;

  if SeparatedHandler then begin
    CheckDataSetService;
    UsedConnection.ExecSQL('HANDLER ' + FDataSetService.QuoteName(TableName) + ' OPEN', []);
  end;

  inherited;
end;

procedure TCustomMyTable.AfterOpenCursor(InfoQuery: boolean);
begin
  if SeparatedHandler then begin
    CheckDataSetService;
    UsedConnection.ExecSQL('HANDLER ' + FDataSetService.QuoteName(TableName) + ' CLOSE', []);
  end;

  inherited;
end;

procedure TCustomMyTable.InternalClose; 
begin
  if SeparatedHandler then
    EndConnection;

  inherited;
end;

function TCustomMyTable.GetIndexDefs: TIndexDefs;
begin
  Assert(Self <> nil);
  FIndexDefs.Update;
  Result := FIndexDefs;
end;

procedure TCustomMyTable.UpdateIndexDefs;
var
  UQ: TCustomMyDataSet;
  Idx: integer;
  IndexName, ColumnName: string;
  IndexDef: TIndexDef;
  OldEnableBoolean: boolean;

begin
  if (Connection = nil) or not Connection.Connected or (Trim(TableName) = '') then
    Exit;

  CheckDataSetService;
  TMyDataSetUpdater(FDataSetService.FUpdater).CheckUpdateQuery(stCustom);
  UQ := FDataSetService.FUpdater.UpdateQuery as TCustomMyDataSet;
  UQ.SQL.Text := 'SHOW INDEX FROM ' + BracketIfNeed(TableName);
  OldEnableBoolean := TMyDataSetOptions(UQ.Options).EnableBoolean;
  try
    UQ.Close;
    TMyDataSetOptions(UQ.Options).EnableBoolean := False;
    UQ.Execute;

    while not UQ.Eof do begin
      IndexName := UQ.FieldByName('Key_name').AsString;
      ColumnName := UQ.FieldByName('Column_name').AsString;

      Idx := FIndexDefs.IndexOf(IndexName);
      if Idx = -1 then
      begin
        IndexDef := FIndexDefs.AddIndexDef;
        IndexDef.Name := IndexName;
      end
      else
        IndexDef := FIndexDefs[Idx];

      if IndexDef.Fields <> '' then
        IndexDef.Fields := IndexDef.Fields + ';' + ColumnName
      else
        IndexDef.Fields := ColumnName;

      if UQ.FieldByName('Non_unique').AsInteger = 0 then
        IndexDef.Options := IndexDef.Options + [ixUnique];

      UQ.Next;
    end;
    UQ.Close;
  except
    // Silent
  end;
  UQ.Close;
  TMyDataSetOptions(UQ.Options).EnableBoolean := OldEnableBoolean;
end;

procedure TCustomMyTable.Execute;
begin
  PrepareSQL;

  inherited;
end;

function TCustomMyTable.CreateOptions: TDADataSetOptions;
begin
  Result := TMyTableOptions.Create(Self);
end;

function TCustomMyTable.GetOptions: TMyTableOptions;
begin
  Result := inherited Options as TMyTableOptions;
end;

procedure TCustomMyTable.SetOptions(Value: TMyTableOptions);
begin
  Options.Assign(Value);
end;

procedure TCustomMyTable.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TCustomMyTable then begin
    TCustomMyTable(Dest).OrderFields := OrderFields;
    TCustomMyTable(Dest).TableName := TableName;
    TCustomMyTable(Dest).MasterSource := MasterSource;
    TCustomMyTable(Dest).MasterFields := MasterFields;
    TCustomMyTable(Dest).DetailFields := DetailFields;
  end;
end;

function TCustomMyTable.SQLAutoGenerated: boolean;
begin
  Result := True;
end;

procedure TCustomMyTable.EmptyTable;
begin
  if TableName = '' then
    DatabaseError(STableNameNotDefined);

  BeginConnection;
  try
    Connection.ExecSQL('TRUNCATE TABLE ' + TableName, [Null]);

    if Active then
      Refresh;
  finally
    EndConnection;
  end;
end;

procedure TCustomMyTable.SetIRecordSet(Value: TData);
begin
  inherited;

  if FIRecordSet <> nil then
    if FOptions <> nil then begin
      FIRecordSet.SetProp(prUseHandler, Options.FUseHandler);
    end;
end;

{ TCustomMyStoredProc }

{$IFDEF WITH_IPROVIDER}
procedure TCustomMyStoredProc.PSSetCommandText(const CommandText: string);
begin
  if CommandText <> '' then
    StoredProcName := CommandText;
end;
{$ENDIF}

procedure TCustomMyStoredProc.SetStoredProcName(const Value: _string);
begin
  if Value <> FStoredProcName then begin
    SQL.Text := '';

    FStoredProcName := Trim(Value);

    if (Connection <> nil) and Connection.Connected and (FStoredProcName <> '') then
      PrepareSQL;
  end;
end;

procedure TCustomMyStoredProc.PrepareSQL;
begin
  if SQL.Count = 0 then
    InternalCreateProcCall(StoredProcName, True)
end;

procedure TCustomMyStoredProc.Prepare;
begin
  PrepareSQL;

  inherited;
end;

function TCustomMyStoredProc.SQLAutoGenerated: boolean;
begin
  Result := True;
end;

procedure TCustomMyStoredProc.BeforeExecute;
begin
  if not Prepared then
    PrepareSQL;
  inherited;
end;

procedure TCustomMyStoredProc.BeforeOpenCursor(InfoQuery: boolean);
begin
  PrepareSQL;

  inherited;
end;

procedure TCustomMyStoredProc.ExecProc;
begin
  Execute;
end;

procedure TCustomMyStoredProc.AssignTo(Dest: TPersistent);
var
  I: Integer;
  P: TDAParam;
begin
  inherited;

  if Dest is TCustomMyStoredProc then begin
    TCustomMyStoredProc(Dest).StoredProcName := FStoredProcName;

    for I := 0 to Params.Count - 1 do begin
      P := TCustomMyStoredProc(Dest).FindParam(Params[I].Name);
      if (P <> nil) and (P.DataType = Params[I].DataType) then begin
        P.Assign(Params[I]);
      end;
    end;
  end;
end;

{ TMyCommand }

constructor TMyCommand.Create(Owner: TComponent);
begin
  inherited;

  FAutoCommit := True;  
  Macros.SetParserClass(TMyParser);
  CommandTimeout := DefaultCommandTimeout;
end;

function TMyCommand.GetConnection: TCustomMyConnection;
begin
  Result := TCustomMyConnection(inherited Connection);
  if (FDataSet <> nil) and (Result = nil) then
    Result := TCustomMyConnection(FDataset.Connection);
end;

procedure TMyCommand.SetConnection(Value: TCustomMyConnection);
begin
  inherited Connection := Value;
end;

procedure TMyCommand.CreateICommand; 
begin
  inherited;

  if FICommand = nil then
    SetICommand(TMySQLCommand.Create);
end;

procedure TMyCommand.SetICommand(Value: TCRCommand);
begin
  FICommand := TMySQLCommand(Value);

  if FICommand <> nil then begin
    FICommand.SetProp(prCommandTimeout, CommandTimeout);
  end;

  inherited;
end;

procedure TMyCommand.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TMyCommand then begin
    TMyCommand(Dest).AfterExecute := AfterExecute;
  end;
end;

procedure TMyCommand.AssembleSQL;
begin
  CheckICommand;

  if ParamCheck or (csDesigning in ComponentState) then begin
    FICommand.SetProp(prFillParamPosition, True);
    try
      inherited;
    finally
      FICommand.SetProp(prFillParamPosition, False);
    end;
  end
  else
    inherited;
end;

procedure TMyCommand.BreakExec;
begin
  Assert(FICommand <> nil);
  FICommand.BreakExec;
end;

procedure TMyCommand.SetCommandTimeout(const Value: integer);
begin
  if FCommandTimeout <> Value then begin
    FCommandTimeout := Value;
    if FICommand <> nil then
      FICommand.SetProp(prCommandTimeout, FCommandTimeout);
  end;
end;

function TMyCommand.UsedConnection: TCustomDAConnection;
begin
  Result := Connection;
end;

function TMyCommand.GetDataTypesMap: TDataTypesMapClass;
begin
  Result := TCustomMyDataTypesMap;
end;

{ TMyAccessUtils }

class procedure TMyAccessUtils.SetDesigning(Obj: TCustomMyDataSet; Value: Boolean; SetChildren: Boolean = True);
begin
  Obj.SetDesigning(Value{$IFNDEF FPC}, SetChildren{$ENDIF});
end;

class function TMyAccessUtils.FIRecordSet(Obj: TCustomMyDataSet): TMySQLRecordSet;
begin
  Result := Obj.FIRecordSet;
end;

class function TMyAccessUtils.FICommand(Obj: TComponent): TMySQLCommand;
begin
  Result := nil;
  if IsClass(Obj, TCustomMyDataSet) then
    Result := TCustomMyDataSet(Obj).FICommand
  else
  if IsClass(Obj, TMyCommand) then
    Result := TMyCommand(Obj).FICommand
  else
    Assert(False);
end;

{ TMyConnectionSSLOptions }

{$IFDEF HAVE_OPENSSL}
constructor TMyConnectionSSLOptions.Create(Owner: TMyConnection);
begin
  inherited Create;

  FOwner := Owner;
end;

procedure TMyConnectionSSLOptions.AssignTo(Dest: TPersistent);
begin
  if Dest is TMyConnectionSSLOptions then begin
    TMyConnectionSSLOptions(Dest).ChipherList := ChipherList;
    TMyConnectionSSLOptions(Dest).CACert := CACert;
    TMyConnectionSSLOptions(Dest).Key := Key;
    TMyConnectionSSLOptions(Dest).Cert := Cert;
  end
  else
    inherited;
end;

procedure TMyConnectionSSLOptions.SetCA(const Value: string);
begin
  if FCACert <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FCACert := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prSSL_CA, Value);
  end;
end;

procedure TMyConnectionSSLOptions.SetCert(const Value: string);
begin
  if FCert <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FCert := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prSSL_Cert, Value);
  end;
end;

procedure TMyConnectionSSLOptions.SetChipher(const Value: string);
begin
  if FChipherList <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FChipherList := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prSSL_Chipher, Value);
  end;
end;

procedure TMyConnectionSSLOptions.SetKey(const Value: string);
begin
  if FKey <> Value then begin
    TCustomMyConnection(FOwner).CheckInactive;
    FKey := Value;
    if TCustomMyConnection(FOwner).IConnection <> nil then
      TCustomMyConnection(FOwner).IConnection.SetProp(prSSL_Key, Value);
  end;
end;
{$ENDIF}

{ TMyTransaction }

function TMyTransaction.SQLMonitorClass: TClass;
begin
  Result := TCustomMySQLMonitor;
end;

function TMyTransaction.GetITransactionClass: TCRTransactionClass;
begin
  Result := TMySQLTransaction;
end;

{ TMyMetaData }

function TMyMetaData.GetConnection: TMyConnection;
begin
  Result := TMyConnection(inherited Connection);
end;

procedure TMyMetaData.SetConnection(Value: TMyConnection);
begin
  inherited Connection := Value;
end;

initialization
  try
    TMyConnectionPoolManager.Clear;
  except
  end;

end.
