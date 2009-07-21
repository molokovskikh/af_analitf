unit ServerController;
{PUBDIST}

interface

uses
  SysUtils, Classes, IWServerControllerBase,
  // For OnNewSession Event
  IWApplication, IWBaseForm,
  IWInit, IWInitISAPI,
  uData, uMain, uQuery, uCachedUpdates, uMasterDetail,
  MemDS, DBAccess;

type
  TIWServerController = class(TIWServerControllerBase)
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication;
      var VMainForm: TIWBaseForm);
  private
  public
  end;

  // This is a class which you can add variables to that are specific to the user. Add variables
  // to this class instead of creating global variables. This object can references by using:
  //   UserSession
  // So if a variable named UserName of type string is added, it can be referenced by using:
  //   UserSession.UserName
  // Such variables are similar to globals in a normal application, however these variables are
  // specific to each user.
  //
  // See the IntraWeb Manual for more details.
  TUserSession = class
  public
    { Common }
    DM: TDM;
    fmMain: TfmMain;
    fmQuery: TfmQuery;
    fmCachedUpdates: TfmCachedUpdates;
    fmMasterDetail: TfmMasterDetail;

    { Main }
    Username,
    Password,
    Server,
    Database: string;
    Pooling,
    DisconnectedMode,
    FailOver: boolean;
    PoolingOptions: TPoolingOptions;
    ConnectionResult: string;
    IsGoodConnection: boolean;

    { Query }
    QueryDependency: boolean;
    QuerySQL,
    QueryResult: string;
    isGoodQuery: boolean;

    { MasterDetail }
    MasterSQL,
    DetailSQL,
    MasterFields,
    DetailFields: string;
    LocalMasterDetail,
    CacheCalcFields: boolean;
    MasterDetailResult: string;
    isGoodMasterDetail: boolean;

    { CachedUpdates }
    CachedSQL: string;
    UseCachedUpdates: boolean;
    CachedRecordTypes: TUpdateRecordTypes;
    CachedResult: string;
    isGoodCached: boolean;

    constructor Create; overload;
    destructor Destroy; override;
  end;

// Procs 
  function UserSession: TUserSession;
  function DM: TDM;

implementation

{$R *.dfm}

function UserSession: TUserSession;
begin
  Result := TUserSession(WebApplication.Data);
end;

function DM: TDM;
begin
  Result := TUserSession(WebApplication.Data).DM;
end;

{ TUserSession }

constructor TUserSession.Create;
begin
  QuerySQL := 'select * from emp';
  MasterSQL := 'select * from dept';
  DetailSQL := QuerySQL;
  CachedSQL := QuerySQL;
  MasterFields := 'deptno';
  DetailFields := 'deptno';
  LocalMasterDetail := True;
  CacheCalcFields  := True;
  UseCachedUpdates := True;
  Pooling := True;
  DisconnectedMode := True;
  CachedRecordTypes := [rtUnmodified, rtModified, rtInserted];

  PoolingOptions := TPoolingOptions.Create(nil);
end;

destructor TUserSession.Destroy;
begin
  PoolingOptions.Free;
  inherited;
end;

{ TIWServerController }

procedure TIWServerController.IWServerControllerBaseNewSession(
  ASession: TIWApplication; var VMainForm: TIWBaseForm);
begin
  ASession.Data := TUserSession.Create;
  with TUserSession(ASession.Data) do begin
    DM := TDM.Create(ASession);
    fmQuery := TfmQuery.Create(ASession);
    fmCachedUpdates := TfmCachedUpdates.Create(ASession);
    fmMasterDetail := TfmMasterDetail.Create(ASession);
  end;
end;


initialization
  TIWServerController.SetServerControllerClass;
end.
