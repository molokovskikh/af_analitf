
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright © 1998-2009 Devart. All right reserved.
//  Connection Pooling supports
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit CRConnectionPool;
{$ENDIF}

interface

uses
{$IFDEF CLR}
  ExtCtrls,
{$ELSE}
  CLRClasses,
{$ENDIF}
{$IFDEF VER6P}
  Variants,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Classes, CRAccess, SyncObjs, MemUtils, CRVio;

const
  StatisticsCount = 8;

type
  TCRConnectionParametersClass = class of TCRConnectionParameters;
  TCRConnectionPoolManagerClass = class of TCRConnectionPoolManager;

  TCRConnectionPool = class;
  TCRConnectionPoolManager = class;

  { TCRConnectionParameters }

  TCRConnectionParameters = class(TPersistent)
  protected
    procedure AssignTo(Dest: TPersistent); override;

  public
    MinPoolSize: integer;
    MaxPoolSize: integer;
    Username: _string;
    Server: _string;
    Password: _string;
    ConnectionLifeTime: integer;
    Validate: boolean;
    IOHandler: TCRIOHandler;

    constructor Create; virtual;
    function Equals(ConnectionParameters: TCRConnectionParameters): boolean; reintroduce; virtual;
    function SetProp(Prop: integer; const Value: variant): boolean; virtual;
  end;

  { TCRConnectionPool }

  TCRConnectionPool = class
  private
    FConnectionParameters: TCRConnectionParameters;
    FManager: TCRConnectionPoolManager;
  protected
    FTakenConnectionsCount: integer;

    procedure Validate; virtual;
    procedure Clear; virtual;
    procedure AsyncClear; virtual;
    function GetTotalConnectionsCount: integer; virtual;
    procedure InternalPutConnection(CRConnection: TCRConnection); virtual; abstract;

    property ConnectionParameters: TCRConnectionParameters read FConnectionParameters;
  public
    constructor Create(Manager: TCRConnectionPoolManager; ConnectionParameters: TCRConnectionParameters); virtual;
    destructor Destroy; override;

    function GetConnection: TCRConnection; virtual; abstract;
    procedure PutConnection(CRConnection: TCRConnection);
    procedure Invalidate; virtual;

    property TotalConnectionsCount: integer read GetTotalConnectionsCount;
  end;

  TCRConnectionsArray = array of TCRConnection;
  TIntegerArray = array of integer;
  TStatisticsArray = array [0..StatisticsCount-1] of integer;

  { TCRLocalConnectionPool }

  TCRLocalConnectionPool = class(TCRConnectionPool)
  private
    //private ConnectMode connectMode = ConnectMode.Default;
    FPooledConnections: TCRConnectionsArray;
    FPooledConnectionsCount, FHead, FTail: integer;
    FVersions: TIntegerArray;
    FVersion: integer;
    FStatistics: TStatisticsArray;
    FDoomedConnectionsCount: integer;
    FInvalidateVersion, FClearVersion: integer;

    hBusy: TEvent;
    FLockPooled, FLockTaken, FLockVersion, FLockGet: TCriticalSection;

    function IsLive(CRConnection: TCRConnection): boolean;
    function CheckIsValid(Connection: TCRConnection): boolean;
    procedure ReserveConnection;
    function InternalGetConnection(var Connection: TCRConnection; var Version: integer;
      Reserve: boolean = True): boolean;
    procedure InternalReturnConnection(Connection: TCRConnection; Version: integer);
    procedure InternalFreeConnection(Connection: TCRConnection; Reserved: boolean = False);

  protected
    function CreateNewConnector: TCRConnection; virtual; abstract;

    procedure Validate; override;
    procedure Clear; override;
    procedure AsyncClear; override;    
    function GetTotalConnectionsCount: integer; override;
    procedure InternalPutConnection(CRConnection: TCRConnection); override;
  public
    // TODO: Add transaction context parameter
    constructor Create(Manager: TCRConnectionPoolManager; ConnectionParameters: TCRConnectionParameters); override;
    destructor Destroy; override;

    function GetConnection: TCRConnection; override;
    procedure Invalidate; override;
  end;

  { TValidateThread }

  TValidateThread = class(TThread)
  private
    FManager: TCRConnectionPoolManager;
  {$IFNDEF LINUX}
    FEvent: TEvent;
  {$ENDIF}
  protected
    procedure Execute; override;
  public
    constructor Create(Manager: TCRConnectionPoolManager);
  {$IFNDEF LINUX}
    destructor Destroy; override;
    procedure Terminate;
  {$ENDIF}
  end;

  { TCRConnectionPoolManager }

  TCRConnectionPoolManager = class
  private
    FPools: TDAList;
    FValidateThread: TValidateThread;

  protected  
    FLockGet, FLockList: TCriticalSection;
  protected
    function CreateCRConnectionPool(ConnectionParameters: TCRConnectionParameters): TCRConnectionPool; virtual; abstract;
    procedure InternalClear;
    procedure InternalAsyncClear;
    function GetConnectionPool(ConnectionParameters: TCRConnectionParameters): TCRConnectionPool;
    function InternalGetConnection(ConnectionParameters: TCRConnectionParameters): TCRConnection; virtual;
    function InternalCheckConnection(Connection: TCRConnection): TCRConnection; virtual;
  public
    constructor Create;
    destructor Destroy; override;

    class function GetConnection(ConnectionParameters: TCRConnectionParameters): TCRConnection; virtual;    
  end;

implementation

uses
  SysUtils, DAConsts;

{ TCRConnectionParameters }

constructor TCRConnectionParameters.Create;
begin
  inherited Create;

  MaxPoolSize := 100;
end;

function TCRConnectionParameters.Equals(ConnectionParameters: TCRConnectionParameters): boolean;
begin
  Result := False;
  if ConnectionParameters <> nil then
    Result :=
      (MinPoolSize = ConnectionParameters.MinPoolSize) and
      (MaxPoolSize = ConnectionParameters.MaxPoolSize) and
      (ConnectionLifeTime = ConnectionParameters.ConnectionLifeTime) and
      _SameText(Username, ConnectionParameters.Username) and
      _SameText(Server, ConnectionParameters.Server) and
      (Password = ConnectionParameters.Password) and
      (Validate = ConnectionParameters.Validate) and
      (IOHandler = ConnectionParameters.IOHandler);
end;

procedure TCRConnectionParameters.AssignTo(Dest: TPersistent);
begin
  if Dest is TCRConnectionParameters then begin
    TCRConnectionParameters(Dest).MinPoolSize        := MinPoolSize;
    TCRConnectionParameters(Dest).MaxPoolSize        := MaxPoolSize;
    TCRConnectionParameters(Dest).Username           := Username;
    TCRConnectionParameters(Dest).Password           := Password;
    TCRConnectionParameters(Dest).Server             := Server;
    TCRConnectionParameters(Dest).ConnectionLifeTime := ConnectionLifeTime;
    TCRConnectionParameters(Dest).Validate           := Validate;
    TCRConnectionParameters(Dest).IOHandler          := IOHandler;
  end
  else
    inherited;
end;

function TCRConnectionParameters.SetProp(Prop: integer; const Value: variant): boolean;
begin
  Assert(False, IntToStr(Prop));
  Result := False;
end;

{ TCRConnectionPool }

constructor TCRConnectionPool.Create(Manager: TCRConnectionPoolManager; ConnectionParameters: TCRConnectionParameters);
begin
  inherited Create;

  FConnectionParameters := TCRConnectionParametersClass(ConnectionParameters.ClassType).Create;
  FConnectionParameters.Assign(ConnectionParameters);
  FManager := Manager;
end;

destructor TCRConnectionPool.Destroy;
begin
  FConnectionParameters.Free;

  inherited;
end;

function TCRConnectionPool.GetTotalConnectionsCount: integer;
begin
  Result := FTakenConnectionsCount;
end;

procedure TCRConnectionPool.Invalidate;
begin
end;

procedure TCRConnectionPool.Validate;
begin
end;

procedure TCRConnectionPool.Clear;
begin
end;

procedure TCRConnectionPool.AsyncClear;
begin
end;

procedure TCRConnectionPool.PutConnection(CRConnection: TCRConnection);
begin
  InternalPutConnection(FManager.InternalCheckConnection(CRConnection));
end;

{ TCRLocalConnectionPool }

constructor TCRLocalConnectionPool.Create(Manager: TCRConnectionPoolManager; ConnectionParameters: TCRConnectionParameters);
begin
  inherited;

  SetLength(FPooledConnections, Self.ConnectionParameters.MaxPoolSize);
  SetLength(FVersions, Self.ConnectionParameters.MaxPoolSize);
  hBusy := TEvent.Create(nil, True, True, '');
  FLockPooled := TCriticalSection.Create;
  FLockTaken := TCriticalSection.Create;
  FLockVersion := TCriticalSection.Create;
  FLockGet := TCriticalSection.Create;
end;

destructor TCRLocalConnectionPool.Destroy;
begin
  Clear;
  FLockPooled.Free;
  FLockTaken.Free;
  FLockVersion.Free;
  FLockGet.Free;
  hBusy.Free;

  inherited;
end;

function TCRLocalConnectionPool.IsLive(CRConnection: TCRConnection): boolean;
var
  CurrentTickCount, LifeTime: longword;
begin
  Result := FConnectionParameters.ConnectionLifeTime = 0;
  if Result then // If connector life time is zero then does not remove connector
    Exit;

  CurrentTickCount := GetTickCount;
  if CurrentTickCount >= CRConnection.ConnectionTime then
    LifeTime := CurrentTickCount - CRConnection.ConnectionTime
  else
    LifeTime := longword($ffffffff) - CRConnection.ConnectionTime + CurrentTickCount + 1;
  Result := LifeTime <= Longword(FConnectionParameters.ConnectionLifeTime);
end;

function TCRLocalConnectionPool.CheckIsValid(Connection: TCRConnection): boolean;
begin
  Result := Connection.CheckIsValid;
  Connection.PoolVersion := FInvalidateVersion;
end;

procedure TCRLocalConnectionPool.ReserveConnection;
begin
  Inc(FTakenConnectionsCount);
  if FTakenConnectionsCount >= ConnectionParameters.MaxPoolSize then
    hBusy.ResetEvent;
end;

function TCRLocalConnectionPool.InternalGetConnection(var Connection: TCRConnection;
  var Version: integer; Reserve: boolean = True): boolean;
begin
  if Reserve then begin
    FLockGet.Enter; // must be first
    FLockTaken.Enter;
  end;
  try
    FLockPooled.Enter;
    try
      Result := False;
      if not Reserve or (FTakenConnectionsCount < ConnectionParameters.MaxPoolSize) then
        if FPooledConnectionsCount > 0 then begin
          Connection := FPooledConnections[FHead];
          Version := FVersions[FHead];
          Inc(FHead);
          if FHead = ConnectionParameters.MaxPoolSize then
            FHead := 0;
          Dec(FPooledConnectionsCount);
          if Reserve then
            ReserveConnection;
          Result := True;
        end;
    finally
      FLockPooled.Leave;
    end;
  finally
    if Reserve then begin
      FLockTaken.Leave;
      FLockGet.Leave;
    end;
  end;
end;

procedure TCRLocalConnectionPool.InternalReturnConnection(Connection: TCRConnection;
  Version: integer);
begin
  FLockPooled.Enter;
  try
    FPooledConnections[FTail] := Connection;
    FVersions[FTail] := Version;
    Inc(FTail);
    if FTail = ConnectionParameters.MaxPoolSize then
      FTail := 0;
    Inc(FPooledConnectionsCount);
    {if FDoomedConnectionsCount > FPooledConnectionsCount - ConnectionParameters.MinPoolSize then
      FDoomedConnectionsCount := FPooledConnectionsCount - ConnectionParameters.MinPoolSize;}

    FLockTaken.Enter;
    try
      Dec(FTakenConnectionsCount);
      hBusy.SetEvent;
    finally
      FLockTaken.Leave;
    end;
  finally
    FLockPooled.Leave;
  end;
end;

procedure TCRLocalConnectionPool.InternalFreeConnection(Connection: TCRConnection;
  Reserved: boolean = False);
begin
  // TODO: May be this try-except unnecessary
  try
    Connection.Free;
  except
  end;

  if not Reserved then begin
    FLockTaken.Enter;
    try
      Dec(FTakenConnectionsCount);
      hBusy.SetEvent;
    finally
      FLockTaken.Leave;
    end;
  end;
end;

function TCRLocalConnectionPool.GetConnection: TCRConnection;
const
{$IFDEF LINUX}
  Timeout: Longword = $FFFFFFFF;
{$ELSE}
  Timeout: Longword = 30000;
{$ENDIF}
var
  Version: integer;
{$IFNDEF LINUX}
  Ticks, BeginTickCount: cardinal;
{$ENDIF}
begin
{$IFNDEF LINUX}
  BeginTickCount := GetTickCount;
{$ENDIF}
  FLockGet.Enter;
  try
  {$IFNDEF LINUX}
    Ticks := GetTickCount - BeginTickCount;
  {$ENDIF}
    if hBusy.WaitFor({$IFDEF LINUX}Timeout{$ELSE}Timeout - Ticks{$ENDIF}) = wrTimeout then
      raise Exception.Create(SMaxConnectionsReached);

    FLockTaken.Enter;
    try
      if FTakenConnectionsCount < ConnectionParameters.MaxPoolSize then
        ReserveConnection
      else
        raise Exception.Create(SMaxConnectionsReached);
    finally
      FLockTaken.Leave;
    end;

  finally
    FLockGet.Leave;
  end;

  if InternalGetConnection(Result, Version, False) then begin
    if (Result.PoolVersion < FClearVersion) or
      (ConnectionParameters.Validate or (Result.PoolVersion < FInvalidateVersion))
      and not CheckIsValid(Result)
    then begin
      InternalFreeConnection(Result, True);
      Result := nil;
    end;
  end
  else
    Result := nil;

  if Result = nil then
    Result := CreateNewConnector;
  Result.Pool := Self;
  Result.PoolVersion := FInvalidateVersion;
end;

procedure TCRLocalConnectionPool.InternalPutConnection(CRConnection: TCRConnection);
var
  Version: integer;
begin
  Assert(CRConnection.Pool = Self);
  if not IsLive(CRConnection) or not CRConnection.IsValid or
    (CRConnection.PoolVersion < FClearVersion) or
    (CRConnection.PoolVersion < FInvalidateVersion) and not CheckIsValid(CRConnection)
  then
    InternalFreeConnection(CRConnection)
  else begin
    FLockVersion.Enter;
    try
      Inc(FVersion);
      Version := FVersion;
    finally
      FLockVersion.Leave;
    end;
    CRConnection.Pool := nil; // protection from PutConnection call on already pooled connection
    InternalReturnConnection(CRConnection, Version);
  end;
end;

procedure TCRLocalConnectionPool.Validate;
var
  Connection: TCRConnection;
  i, FirstVersion, LastVersion, Doomed, Removed, Version: integer;
begin
  FirstVersion := FStatistics[0];
  LastVersion := FStatistics[StatisticsCount - 1];
  for i := StatisticsCount - 1 downto 1 do
    FStatistics[i] := FStatistics[i - 1];
  FStatistics[0] := FVersion;
  Doomed := (FDoomedConnectionsCount + StatisticsCount - 2) div StatisticsCount;
  FDoomedConnectionsCount := FPooledConnectionsCount - ConnectionParameters.MinPoolSize - Doomed;

  i := FTail;
  Removed := 0;
  while (FHead <> i) and InternalGetConnection(Connection, Version) do begin
    if (Version <= LastVersion) or not IsLive(Connection) or
      (Connection.PoolVersion < FClearVersion) or
      ((Version <= FirstVersion) or (Connection.PoolVersion < FInvalidateVersion))
      and not CheckIsValid(Connection)
    then begin
      InternalFreeConnection(Connection);
      Inc(Removed);
    end
    else
      InternalReturnConnection(Connection, Version);
  end;

  if Removed < Doomed then begin
    Doomed := Doomed - Removed;
    for i := 0 to Doomed - 1 do
      if InternalGetConnection(Connection, Version) then
        InternalFreeConnection(Connection)
      else
        break;
  end;
end;

procedure TCRLocalConnectionPool.Invalidate;
begin
  Inc(FInvalidateVersion);
end;

procedure TCRLocalConnectionPool.Clear;
var
  Connection: TCRConnection;
  Version: integer;
begin
  while InternalGetConnection(Connection, Version) do
    InternalFreeConnection(Connection);
end;

procedure TCRLocalConnectionPool.AsyncClear;
begin
  Inc(FInvalidateVersion);
  Inc(FClearVersion);
end;

function TCRLocalConnectionPool.GetTotalConnectionsCount: integer;
begin
  FLockPooled.Enter;
  try
    FLockTaken.Enter;
    try
      Result := FTakenConnectionsCount + FPooledConnectionsCount;
    finally
      FLockTaken.Leave;
    end;
  finally
    FLockPooled.Leave;
  end;
end;

{ TCRConnectionPoolManager }

constructor TCRConnectionPoolManager.Create;
begin
  inherited;

  FPools := TDAList.Create;
  FLockGet := TCriticalSection.Create;
  FLockList := TCriticalSection.Create;
  FValidateThread := TValidateThread.Create(Self);
end;

destructor TCRConnectionPoolManager.Destroy;
begin
  if FValidateThread <> nil then begin
    FValidateThread.Terminate;
  {$IFDEF WIN32}
    // infinite wait can hang in DLL
    WaitForSingleObject(FValidateThread.Handle, 5000);
  {$ELSE}
    FValidateThread.WaitFor;
  {$ENDIF}
    FValidateThread.Free;
  end;

  if (FPools <> nil) and (FLockGet <> nil) and (FLockList <> nil) then
    InternalClear;
  FPools.Free;
  FLockGet.Free;
  FLockList.Free;

  inherited;
end;

// Conn parameters used for creating new pool with initial parameters
function TCRConnectionPoolManager.GetConnectionPool(ConnectionParameters: TCRConnectionParameters): TCRConnectionPool;
var
  i: integer;
  Pool: TCRConnectionPool;
begin
  Result := nil;

  // Search if pool with same connection string exist
  for i := 0 to FPools.Count - 1 do begin
    Pool := TCRConnectionPool(FPools.Items[i]);
    if Pool.FConnectionParameters.Equals(ConnectionParameters) then begin
      Result := Pool;
      break;
    end;
  end;

  // Create new pool object if existing not found
  if Result = nil then begin
    Result := CreateCRConnectionPool(ConnectionParameters);
    FPools.Add(Result);
  end;
end;

procedure TCRConnectionPoolManager.InternalClear;
begin
  FLockList.Enter;
  try
    while FPools.Count <> 0 do begin
      TCRConnectionPool(FPools.Items[0]).Free;
      FPools.Delete(0);
    end;
  finally
    FLockList.Leave;
  end;
end;

procedure TCRConnectionPoolManager.InternalAsyncClear;
var
  i: integer;
begin
  FLockList.Enter;
  try
    for i := 0 to FPools.Count - 1 do
      TCRConnectionPool(FPools[i]).AsyncClear;
  finally
    FLockList.Leave;
  end;
end;

function TCRConnectionPoolManager.InternalGetConnection(ConnectionParameters: TCRConnectionParameters): TCRConnection;
begin
  FLockGet.Enter;
  try
    Result := GetConnectionPool(ConnectionParameters).GetConnection;
  finally
    FLockGet.Leave;
  end;
end;

function TCRConnectionPoolManager.InternalCheckConnection(
  Connection: TCRConnection): TCRConnection;
begin
  Result := Connection;
end;

class function TCRConnectionPoolManager.GetConnection(
  ConnectionParameters: TCRConnectionParameters): TCRConnection;
begin
  Result := nil;
  Assert(False, 'Must be overriden');
end;

{ TValidateThread }

constructor TValidateThread.Create(Manager: TCRConnectionPoolManager);
begin
  FManager := Manager;
{$IFNDEF LINUX}
  FEvent := TEvent.Create(nil, True, False, '');
{$ENDIF}
{$IFDEF CLR}
  inherited Create(True);        // to prevent Application hanging on
  Handle.IsBackGround := True;   // close
  Resume;
{$ELSE}
  inherited Create(False);
{$ENDIF}
end;

{$IFNDEF LINUX}
destructor TValidateThread.Destroy;
begin
  FEvent.Free;
end;

procedure TValidateThread.Terminate;
begin
  inherited;
  FEvent.SetEvent;
end;
{$ENDIF}

procedure TValidateThread.Execute;
const
  Timeout = 30000;
var
  i, Count: integer;
  Pool: TCRConnectionPool;
  Ticks, BeginTickCount: cardinal;
begin
  Ticks := 0;
  while True do begin
    if Terminated then
      Exit;
  {$IFNDEF LINUX}
    if (Ticks < Timeout) and (FEvent.WaitFor(Timeout - Ticks) = wrSignaled) then
      Exit;
  {$ELSE}
    while Ticks < Timeout do begin
      Sleep(200);
      if Terminated then
        Exit;
      Ticks := Ticks + 200;
    end;
  {$ENDIF}

    BeginTickCount := GetTickCount;

    FManager.FLockList.Enter;
    try
      for i := FManager.FPools.Count - 1 downto 0 do begin
        if Terminated then
          Exit;
        Pool := TCRConnectionPool(FManager.FPools[i]);
        Pool.Validate;

        FManager.FLockGet.Enter;
        try
          Count := Pool.TotalConnectionsCount;
          if Count = 0 then
            FManager.FPools.Delete(i);
        finally
          FManager.FLockGet.Leave;
        end;
        if Count = 0 then
          Pool.Free;
      end;
    finally
      FManager.FLockList.Leave;
    end;

    Ticks := GetTickCount - BeginTickCount;
  end;
end;

end.
