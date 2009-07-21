
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright © 1998-2009 Devart. All right reserved.
//  SQLMonitor supports
//  Created:            17.11.99
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

{$IFDEF BCB}
  {$O-}
{$ENDIF}

unit DASQLMonitor;
{$ENDIF}
interface
uses
{$IFDEF LINUX}
  Types, 
{$ENDIF}
{$IFDEF WIN32}
  ActiveX,
{$ENDIF}
  SysUtils, Classes, DB, MemUtils, MemData, DBAccess,
  DBMonitorClient, DBMonitorIntf;

const
  teStart    = 1;
  teCommit   = 2;
  teRollback = 3;

type
  TDATraceFlag = (tfQPrepare, tfQExecute, tfQFetch, tfError, tfStmt, tfConnect,
    tfTransact, tfBlob, tfService, tfMisc, tfParams);
  TDATraceFlags = set of TDATraceFlag;

  TMonitorOption = (moDialog, moSQLMonitor, moDBMonitor, moCustom, moHandled);
  TMonitorOptions = set of TMonitorOption;

  TOnSQLEvent = procedure (Sender: TObject; Text: _string; Flag: TDATraceFlag) of object;

{ TCustomDASQLMonitor }

  TDASQLMonitorClass = class of TCustomDASQLMonitor;

  TCustomDASQLMonitor = class(TComponent)
  private
    FActive: boolean;
    FTraceFlags: TDATraceFlags;
    FOptions: TMonitorOptions;
    FStreamedActive: boolean;
  {$IFDEF WIN32}
    FRegistered: boolean;
    FSMClient: IUnknown;
    NeedUninitialize :boolean;
  {$ENDIF}
  {$IFNDEF LINUX}
    FDBMonitor: IDBMonitor;
  {$ENDIF}

    procedure SetActive(Value: boolean);
    procedure SetOptions(Value: TMonitorOptions);

  protected
    FOnSQLEvent: TOnSQLEvent;

  { component routines }
    procedure Loaded; override;
    procedure CheckActive;
  { Borland's SQL Monitor support }
    procedure RegisterClient; virtual;
    procedure UnRegisterClient; virtual;
    procedure AddStatement(const St: AnsiString);
    procedure SMClientSignal(Sender: TObject; Data: Integer);

  { DBMonitor support }
    procedure OnConnect(const Username, Server, St: AnsiString; Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
    procedure OnDisconnect(const Username, Server, St: AnsiString; Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
    procedure OnTransact(const St: AnsiString; Component: TComponent; TransactEvent: integer; ATracePoint: TTracePoint; var AMessageID: Cardinal);
    procedure OnPrepare(const SQL: AnsiString; var Params: TSQLParams; const St: AnsiString; Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
    procedure OnUnprepare(const SQL: AnsiString; var Params: TSQLParams; const St: AnsiString; Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
    procedure OnExecute(const SQL: AnsiString; var Params: TSQLParams; const St: AnsiString; Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
    procedure OnError(const ErrorStr: AnsiString);
    procedure OnCustomMessage(const St: AnsiString; Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
    procedure PrepareExecuteMessage(const SQL: AnsiString; var Params: TSQLParams; const St: AnsiString;
      Component: TComponent; ATracePoint: TTracePoint; EventType: TEventType; var AMessageID: Cardinal);

    function GetCompHandle(Comp: TComponent): string;
    function GetParent(Component: TComponent; Index: integer): TComponent; virtual;
    function GetParentCount(Component: TComponent): integer; virtual;

    procedure InternalSQLPrepare(Component: TComponent; const SQL: _string; Params: TDAParams; ATracePoint: TTracePoint; var MessageID: Cardinal);
    procedure InternalSQLUnprepare(Component: TComponent; const SQL: _string; Params: TDAParams; ATracePoint: TTracePoint; var MessageID: Cardinal);
    procedure InternalSQLExecute(Component: TComponent; const SQL: _string; Params: TDAParams; const Caption: string; ATracePoint: TTracePoint; var MessageID: Cardinal); virtual;
    procedure InternalDBConnect(Connection: TCustomDAConnection; ATracePoint: TTracePoint; var MessageID: Cardinal);
    procedure InternalDBDisconnect(Connection: TCustomDAConnection; ATracePoint: TTracePoint; var MessageID: Cardinal);
    procedure InternalTRStart(Component: TComponent; ATracePoint: TTracePoint; var MessageID: Cardinal); virtual;
    procedure InternalTRCommit(Component: TComponent; ATracePoint: TTracePoint; var MessageID: Cardinal); virtual;
    procedure InternalTRRollback(Component: TComponent; ATracePoint: TTracePoint; var MessageID: Cardinal); virtual;

    procedure InternalTRSavepoint(Component: TComponent; const Savepoint: _string);
    procedure InternalTRRollbackToSavepoint(Component: TComponent; const Savepoint: _string);
    procedure InternalTRReleaseSavepoint(Component: TComponent; const Savepoint: _string);
    procedure InternalTRCommitRetaining(Component: TComponent; ATracePoint: TTracePoint; var MessageID: Cardinal);
    procedure InternalTRRollbackRetaining(Component: TComponent; ATracePoint: TTracePoint; var MessageID: Cardinal);

    procedure InternalDBError(Exception: EDAError);
    procedure InternalCustomMessage(Connection: TCustomDAConnection; const Msg: _string; var AMessageID: Cardinal);

    class function GetMonitor: TCustomDASQLMonitor; virtual;

  public
    class procedure SQLPrepare(Component: TComponent; const SQL: _string; Params: TDAParams; var MessageID: Cardinal; BeforeEvent: boolean);
    class procedure SQLUnprepare(Component: TComponent; const SQL: _string; Params: TDAParams; var MessageID: Cardinal; BeforeEvent: boolean);
    class procedure SQLExecute(Component: TComponent; const SQL: _string; Params: TDAParams; const Caption: string; var MessageID: Cardinal; BeforeEvent: boolean);
    class procedure DBConnect(Connection: TCustomDAConnection; var MessageID: Cardinal; BeforeEvent: boolean);
    class procedure DBDisconnect(Connection: TCustomDAConnection; var MessageID: Cardinal; BeforeEvent: boolean);

    class procedure TRStart(Component: TComponent; var MessageID: Cardinal; BeforeEvent: boolean); virtual;
    class procedure TRCommit(Component: TComponent; var MessageID: Cardinal; BeforeEvent: boolean); virtual;
    class procedure TRRollback(Component: TComponent; var MessageID: Cardinal; BeforeEvent: boolean); virtual;
    class procedure TRSavepoint(Component: TComponent; const Savepoint: _string);
    class procedure TRRollbackToSavepoint(Component: TComponent; const Savepoint: _string);
    class procedure TRReleaseSavepoint(Component: TComponent; const Savepoint: _string);
    class procedure TRCommitRetaining(Component: TComponent; var MessageID: Cardinal; BeforeEvent: boolean);
    class procedure TRRollbackRetaining(Component: TComponent; var MessageID: Cardinal; BeforeEvent: boolean);

    class procedure DBError(Exception: EDAError);
    class procedure CustomMessage(Connection: TCustomDAConnection; const Msg: _string; var MessageID: Cardinal);
    class function HasMonitor: boolean;

    class function GetParamDataType(Param: TDAParam): string; virtual;
    class function GetParamParamType(Param: TDAParam): string; virtual;
    class function GetParamValue(Param: TDAParam): string; virtual;
    class function GetParam(Param: TDAParam; var SQLParam: TSQLParam): _string;
    class function GetParams(Params: TDAParams; var SQLParams: TSQLParams): _string; overload;
    class function GetParams(Params: TDAParams): string; overload;
    class function GetCaption: AnsiString; virtual;
    class procedure ShowDebug(Component: TComponent; const SQL: _string; Params: TDAParams; const Caption: string);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Active: boolean read FActive write SetActive default True;
    property TraceFlags: TDATraceFlags read FTraceFlags write FTraceFlags default [tfQPrepare, tfQExecute, tfError, tfConnect, tfTransact, tfParams, tfMisc];
    property Options: TMonitorOptions read FOptions write SetOptions default [moDialog, moSQLMonitor, moDBMonitor, moCustom];

    property OnSQL: TOnSQLEvent read FOnSQLEvent write FOnSQLEvent;
  end;

var
  ShowDebugFormProc: procedure (DASQLMonitorClass: TDASQLMonitorClass;
    Component: TComponent; SQL: string; Params: TDAParams; Caption: string);

  function GetComponentID(Component: TComponent): cardinal;
  function GetComponentName(Component: TComponent): AnsiString;
  
implementation

{$IFDEF WIN32}
const
  Class_SMClient: TGUID = '{CB9879E2-4395-11D0-9FFC-00A0248E4B9A}';

type
  ISMClient = interface(IUnknown)
    ['{CB9879E1-4395-11D0-9FFC-00A0248E4B9A}']
    function RegisterClient(ID: Integer; Name: PAnsiChar;
      Instance, SignalProc: Pointer): WordBool; stdcall;
    function AddStatement(Statement: PAnsiChar; Len: Integer): WordBool; stdcall;
  end;
{$ENDIF}


function GetComponentID(Component: TComponent): cardinal;
begin
{$IFDEF CLR}
  if Component = nil then
    Result := 0
  else
{$ENDIF}
    Result := Cardinal(Component{$IFDEF CLR}.GetHashCode{$ENDIF});

  if Result <> 0 then
    if (Component is TCustomDADataSet) then
      Result := Result xor Reverse4(GetComponentID(TCustomDADataSet(Component).Connection))
    else
    if (Component is TCustomDASQL) then
      Result := Result xor Reverse4(GetComponentID(TCustomDASQL(Component).Connection));
end;

function GetComponentName(Component: TComponent): AnsiString;
begin
  if Component.Name <> '' then
    Result := AnsiString(Component.Name)
  else
    Result := AnsiString(Component.ClassName + ' ($' + IntToHex(GetComponentID(Component), 8) + ')');
end;

{ TCustomDASQLMonitor }

const
  fmtConnectInfo  = 'Username=%s'#13#10'Server=%s';

constructor TCustomDASQLMonitor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FActive := False;
  FOptions := [moDialog, moSQLMonitor, moDBMonitor, moCustom];
  FTraceFlags := [tfQPrepare, tfQExecute, tfError, tfConnect, tfTransact, tfParams, tfMisc];
  FStreamedActive := True;
  if (csDesigning in ComponentState) or (AOwner = nil) or not (csReading in AOwner.ComponentState) then
    Active := True
end;

destructor TCustomDASQLMonitor.Destroy;
begin
  Active := False;
  {$IFDEF WIN32}
  if NeedUninitialize then
    CoUninitialize;
  {$ENDIF}

  inherited;
end;

class procedure TCustomDASQLMonitor.SQLPrepare(Component: TComponent;
  const SQL: _string; Params: TDAParams; var MessageID: Cardinal;
  BeforeEvent: boolean);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    if BeforeEvent then
      Monitor.InternalSQLPrepare(Component, TrimRight(SQL), Params, tpBeforeEvent, MessageID)
    else
      Monitor.InternalSQLPrepare(Component, TrimRight(SQL), Params, tpAfterEvent, MessageID)
  else
    if BeforeEvent then
      ShowDebug(Component, TrimRight(SQL), Params, 'Prepare');
end;

class procedure TCustomDASQLMonitor.SQLUnprepare(Component: TComponent;
  const SQL: _string; Params: TDAParams; var MessageID: Cardinal;
  BeforeEvent: boolean);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    if BeforeEvent then
      Monitor.InternalSQLUnprepare(Component, TrimRight(SQL), Params, tpBeforeEvent, MessageID)
    else
      Monitor.InternalSQLUnprepare(Component, TrimRight(SQL), Params, tpAfterEvent, MessageID)
  else
    if BeforeEvent then
      ShowDebug(Component, TrimRight(SQL), Params, 'Unprepare');
end;

class procedure TCustomDASQLMonitor.SQLExecute(Component: TComponent;
  const SQL: _string; Params: TDAParams; const Caption: string;
  var MessageID: Cardinal; BeforeEvent: boolean);
var
  Monitor: TCustomDASQLMonitor;
  ACaption: string;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    if BeforeEvent then
      Monitor.InternalSQLExecute(Component, SQL, Params, Caption, tpBeforeEvent, MessageID)
    else
      Monitor.InternalSQLExecute(Component, SQL, Params, Caption, tpAfterEvent, MessageID)
  else
    begin
      if Caption = '' then
        ACaption := 'Execute'
      else
        ACaption := Caption;

      if BeforeEvent then
        ShowDebug(Component, SQL, Params, ACaption);
    end;
end;

class procedure TCustomDASQLMonitor.DBConnect(Connection: TCustomDAConnection;
  var MessageID: Cardinal; BeforeEvent: boolean);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    if BeforeEvent then
      Monitor.InternalDBConnect(Connection, tpBeforeEvent, MessageID)
    else
      Monitor.InternalDBConnect(Connection, tpAfterEvent, MessageID)
end;

class procedure TCustomDASQLMonitor.DBDisconnect(Connection: TCustomDAConnection;
 var MessageID: Cardinal; BeforeEvent: boolean);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    if BeforeEvent then
      Monitor.InternalDBDisconnect(Connection, tpBeforeEvent, MessageId)
    else
      Monitor.InternalDBDisconnect(Connection, tpAfterEvent, MessageId);
end;

class procedure TCustomDASQLMonitor.TRStart(Component: TComponent;
  var MessageID: Cardinal; BeforeEvent: boolean);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    if BeforeEvent then
      Monitor.InternalTRStart(Component, tpBeforeEvent, MessageID)
    else
      Monitor.InternalTRStart(Component, tpAfterEvent, MessageID);
end;

class procedure TCustomDASQLMonitor.TRCommit(Component: TComponent;
  var MessageID: Cardinal; BeforeEvent: boolean);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    if BeforeEvent then
      Monitor.InternalTRCommit(Component, tpBeforeEvent, MessageID)
    else
      Monitor.InternalTRCommit(Component, tpAfterEvent, MessageID);
end;

class procedure TCustomDASQLMonitor.TRRollback(Component: TComponent;
  var MessageID: Cardinal; BeforeEvent: boolean);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    if BeforeEvent then
      Monitor.InternalTRRollback(Component, tpBeforeEvent, MessageID)
    else
      Monitor.InternalTRRollback(Component, tpAfterEvent, MessageID);
end;

class procedure TCustomDASQLMonitor.TRSavepoint(Component: TComponent; const Savepoint: _string);
begin
  if GetMonitor <> nil then
    GetMonitor.InternalTRSavepoint(Component, Savepoint);
end;

class procedure TCustomDASQLMonitor.TRRollbackToSavepoint(Component: TComponent; const Savepoint: _string);
begin
  if GetMonitor <> nil then
    GetMonitor.InternalTRRollbackToSavepoint(Component, Savepoint);
end;

class procedure TCustomDASQLMonitor.TRReleaseSavepoint(Component: TComponent; const Savepoint: _string);
begin
  if GetMonitor <> nil then
    GetMonitor.InternalTRReleaseSavepoint(Component, Savepoint);
end;

class procedure TCustomDASQLMonitor.TRCommitRetaining(Component: TComponent; var MessageID: Cardinal; BeforeEvent: boolean);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    if BeforeEvent then
      Monitor.InternalTRCommitRetaining(Component, tpBeforeEvent, MessageID)
    else
      Monitor.InternalTRCommitRetaining(Component, tpAfterEvent, MessageID);
end;

class procedure TCustomDASQLMonitor.TRRollbackRetaining(Component: TComponent; var MessageID: Cardinal; BeforeEvent: boolean);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    if BeforeEvent then
      Monitor.InternalTRRollbackRetaining(Component, tpBeforeEvent, MessageID)
    else
      Monitor.InternalTRRollbackRetaining(Component, tpAfterEvent, MessageID);
end;

class procedure TCustomDASQLMonitor.DBError(Exception: EDAError);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    Monitor.InternalDBError(Exception);
end;

class procedure TCustomDASQLMonitor.CustomMessage(Connection: TCustomDAConnection;
  const Msg: _string; var MessageID: Cardinal);
var
  Monitor: TCustomDASQLMonitor;
begin
  Monitor := GetMonitor;
  if Assigned(Monitor) then
    Monitor.InternalCustomMessage(Connection, Msg, MessageID);
end;

class function TCustomDASQLMonitor.GetParamDataType(Param: TDAParam): string;
begin
{$IFNDEF VER10P}
  if Integer(Param.DataType) = Integer(ftFixedWideChar) then
    Result := 'FixedWideChar'
  else
{$ENDIF}
    Result := FieldTypeNames[Param.DataType];
  if (Param.DataType in [ftString,ftFixedChar,ftWideString]) or
    (Integer(Param.DataType) = Integer(ftFixedWideChar))
  then
    Result := Result + '[' + IntToStr(Length(Param.AsString)) + ']';
end;

class function TCustomDASQLMonitor.GetParamParamType(Param: TDAParam): string;
begin
  case Param.ParamType of
  ptInput:
    Result := 'IN';
  ptOutput:
    Result := 'OUT';
  ptInputOutput:
    Result := 'IN/OUT';
  ptResult:
    Result := 'RESULT';
  else
    Result := '';
  end;
end;

class function TCustomDASQLMonitor.GetParamValue(Param: TDAParam): string;
begin
  Result := '';
  if Param.IsNull then
    Result := '<NULL>'
  else
    case Param.DataType of
      ftDate:
        Result := DateToStr(Param.AsDate);
      ftDateTime:
        Result := DateTimeToStr(Param.AsDateTime);
      ftBlob, ftOraBlob, ftOraClob, ftMemo{$IFDEF VER10P}, ftWideMemo{$ENDIF}: begin
        Result := '<BLOB:' + IntToStr(Param.AsBlobRef.Size) + '>';
      end;
      ftCursor:
        Result := '<CURSOR>';
      ftBytes, ftVarBytes:
        Result := '<BLOB:' + IntToStr(Length(Param.AsBlob)) + '>'
    else
      if (Param.DataType in [ftString, ftFixedChar, ftWideString]) or
        (Integer(Param.DataType) = Integer(ftFixedWideChar))
      then
        Result := '''' + Param.AsString + ''''
      else
        Result := Param.AsString;
    end;
end;

function ConcatWith(const Args: array of string; const AConcatWith: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to Length(Args)-1 do begin
    if Args[i] <> '' then
      if Result <> '' then
        Result := Result + AConcatWith + Args[i]
      else
        Result := Args[i];
  end;
end;

class function TCustomDASQLMonitor.GetParam(Param: TDAParam; var SQLParam: TSQLParam): _string;
var
  DataType, ParamType, Value: _string;
begin
  DataType := GetParamDataType(Param);
  ParamType := GetParamParamType(Param);
  Value := GetParamValue(Param);

  SQLParam.Name := AnsiString(Param.Name);
  SQLParam.DataType := AnsiString(DataType);
  SQLParam.ParamType := AnsiString(ParamType);
  SQLParam.Value := AnsiString(Value);
  Result := ':' + Param.Name + '(' + ConcatWith([DataType,
    ParamType],',') + ConcatWith([')', Value], '=');
end;

class function TCustomDASQLMonitor.GetParams(Params: TDAParams; var SQLParams: TSQLParams): _string;
var
  i: integer;
begin
  Result := '';
  if Params <> nil then begin
    SetLength(SQLParams, Params.Count);
    for i := 0 to Params.Count - 1 do
      Result := Result + GetParam(Params[i], SQLParams[i]) + ' '#13#10;
  end;
end;

class function TCustomDASQLMonitor.GetParams(Params: TDAParams): string;
var
  SQLParams: TSQLParams;
begin
  Result := GetParams(Params, SQLParams);
end;

class procedure TCustomDASQLMonitor.ShowDebug(Component: TComponent;
  const SQL: _string; Params: TDAParams; const Caption: string);
begin
  if Assigned(ShowDebugFormProc) then
    ShowDebugFormProc(Self, Component, SQL, Params, Caption);
end;

class function TCustomDASQLMonitor.GetMonitor: TCustomDASQLMonitor;
begin
  Result := nil;
end;

class function TCustomDASQLMonitor.GetCaption: AnsiString;
begin
  Result := 'DataAccess';
end;

function TCustomDASQLMonitor.GetCompHandle(Comp: TComponent): string;
var
  Conn: TCustomDAConnection;
begin
  if moHandled in Options then begin
    Result := ' [' + Comp.Name + '$' + IntToHex(GetComponentID(Comp), 8);

    if Comp is TCustomDADataSet then
      Conn := TCustomDADataSet(Comp).Connection
    else
      if Comp is TCustomDASQL then
        Conn := TCustomDASQL(Comp).Connection
      else
        Conn := nil;

    if Conn <> nil then
      Result := Result + '; ' + Conn.Name + '$' + IntToHex(GetComponentID(Conn), 8);

    Result := Result + '] ';
  end
  else
    Result := '';
end;

function TCustomDASQLMonitor.GetParent(Component: TComponent; Index: integer): TComponent;
begin
  if (Component is TDATransaction) then
    Result := TDBAccessUtils.GetConnection(TDATransaction(Component), Index)
  else
  if (Component is TCustomDASQL) then
    Result := TCustomDASQL(Component).Connection
  else  
  if (Component is TCustomDADataSet) then
    Result := TCustomDADataSet(Component).Connection
  else
    Result := nil;
end;

function TCustomDASQLMonitor.GetParentCount(Component: TComponent): integer;
begin
  if (Component is TDATransaction) then
    Result := TDBAccessUtils.GetConnectionCount(TDATransaction(Component))
  else
    Result := 1;
end;

procedure TCustomDASQLMonitor.InternalSQLPrepare(Component: TComponent; const SQL: _string; Params: TDAParams; ATracePoint: TTracePoint; var MessageID: Cardinal);
var
  ParamSt: _string;
  SQLParams: TSQLParams;
  ASQL: _string;
begin
  CheckActive;

  if Active and (tfQPrepare in TraceFlags) then begin
    if ((moDialog in Options) and (not((moCustom in Options) or (csDesigning in ComponentState)) or
     ((Component is TCustomDADataSet) and TCustomDADataSet(Component).Debug or
      (Component is TCustomDASQL) and TCustomDASQL(Component).Debug))) and
      (ATracePoint = tpBeforeEvent)
    then
      ShowDebug(Component, SQL, Params, 'Prepare');

    ParamSt := TrimRight(GetParams(Params, SQLParams));

    if (moSQLMonitor in Options) and (ATracePoint <> tpAfterEvent) then begin
      AddStatement(AnsiString('SQL Prepare' + GetCompHandle(Component) + ': ' + SQL));
      if (ParamSt <> '') and (tfParams in TraceFlags) then
        AddStatement(AnsiString(ParamSt));
    end;

    OnPrepare(AnsiString(SQL), SQLParams, AnsiString('SQL Prepare' + GetCompHandle(Component) + ': ' + SQL + #13#10 + ParamSt), Component, ATracePoint, MessageID);

    if Assigned(FOnSQLEvent) and (ATracePoint <> tpAfterEvent) then begin
      if ParamSt <> '' then
        ASQL := SQL + #13#10 + ParamSt
      else
        ASQL := SQL;
      FOnSQLEvent(Component, 'Prepare: ' + ASQL, tfQPrepare);
    end;
  end;
end;

procedure TCustomDASQLMonitor.InternalSQLUnprepare(Component: TComponent; const SQL: _string; Params: TDAParams; ATracePoint: TTracePoint; var MessageID: Cardinal);
var
  ParamSt: _string;
  SQLParams: TSQLParams;
  ASQL: _string;
begin
  CheckActive;

  if Active and (tfQPrepare in TraceFlags) then begin
    if ((moDialog in Options) and (not ((moCustom in Options) or (csDesigning in ComponentState)) or
     ((Component is TCustomDADataSet) and TCustomDADataSet(Component).Debug or
      (Component is TCustomDASQL) and TCustomDASQL(Component).Debug))) and
      (ATracePoint = tpBeforeEvent)
    then
      ShowDebug(Component, SQL, Params, 'Unprepare');

    ParamSt := TrimRight(GetParams(Params, SQLParams));

    if (moSQLMonitor in Options) then begin
      AddStatement(AnsiString('SQL Unprepare' + GetCompHandle(Component) + ': ' + SQL));
      if (ParamSt <> '') and (tfParams in TraceFlags) then
        AddStatement(AnsiString(ParamSt));
    end;

    OnUnprepare(AnsiString(SQL), SQLParams, AnsiString('SQL Unprepare' + GetCompHandle(Component) + ': ' + SQL + #13#10 + ParamSt), Component, ATracePoint, MessageID);

    if Assigned(FOnSQLEvent) and (ATracePoint <> tpAfterEvent) then begin
      if ParamSt <> '' then
        ASQL := SQL + #13#10 + ParamSt
      else
        ASQL := SQL;
      FOnSQLEvent(Component, 'Unprepare: ' + ASQL, tfQPrepare);
    end;
  end;
end;

procedure TCustomDASQLMonitor.InternalSQLExecute(Component:TComponent; const SQL: _string; Params: TDAParams; const Caption: string; ATracePoint: TTracePoint; var MessageID: Cardinal);
var
  ParamSt: _string;
  ACaption: string;
  SQLParams: TSQLParams;
  ASQL: _string;
begin
  CheckActive;

  if Active and (tfQExecute in TraceFlags) then begin
    if (moDialog in Options) and (not ((moCustom in Options) or (csDesigning in ComponentState)) or
     ((Component is TCustomDADataSet) and TCustomDADataSet(Component).Debug or
      (Component is TCustomDASQL) and TCustomDASQL(Component).Debug)) and
      (ATracePoint = tpBeforeEvent)
    then begin
      if Caption = '' then
        ACaption := 'Execute'
      else
        ACaption := Caption;

      ShowDebug(Component, SQL, Params, ACaption);
    end;

    ParamSt := TrimRight(GetParams(Params, SQLParams));

    if (moSQLMonitor in Options) and (ATracePoint <> tpAfterEvent) then begin
      ACaption := 'SQL Execute';
      if Caption <> '' then
        ACaption := ACaption + ' [' + Caption + ']';

      AddStatement(AnsiString(ACaption + GetCompHandle(Component) + ': '{#13#10} + SQL));
      if (ParamSt <> '') and (tfParams in TraceFlags) then
        AddStatement(AnsiString(ParamSt));
    end;

    OnExecute(AnsiString(SQL), SQLParams, AnsiString('SQL Execute' + GetCompHandle(Component) + ': ' + SQL + #13#10 + ParamSt), Component, ATracePoint, MessageID);

    if Assigned(FOnSQLEvent) and (ATracePoint <> tpAfterEvent) then begin
      if ParamSt <> '' then
        ASQL := SQL + #13#10 + ParamSt
      else
        ASQL := SQL;
      FOnSQLEvent(Component, ASQL, tfQExecute);
    end;
  end;
end;

procedure TCustomDASQLMonitor.InternalDBConnect(Connection: TCustomDAConnection; ATracePoint: TTracePoint; var MessageID: Cardinal);
var
  St: _string;
begin
  CheckActive;

  if Active and (tfConnect in TraceFlags) then begin
    St := 'Connect: ' + Connection.Username + '@' + Connection.Server + GetCompHandle(Connection);

    if (moSQLMonitor in Options) and (ATracePoint <> tpAfterEvent) then
      AddStatement(AnsiString(St));

    OnConnect(AnsiString(Connection.Username), AnsiString(Connection.Server),
      AnsiString(St), Connection, ATracePoint, MessageID);

    if Assigned(FOnSQLEvent) and (ATracePoint <> tpAfterEvent) then
      FOnSQLEvent(Connection, St, tfConnect);
  end;
end;

procedure TCustomDASQLMonitor.InternalDBDisconnect(Connection: TCustomDAConnection; ATracePoint: TTracePoint; var MessageID: Cardinal);
var
  St: _string;
begin
  CheckActive;

  if Active and (tfConnect in TraceFlags) then begin
    St := 'Disconnect: ' + Connection.Username + '@' + Connection.Server + GetCompHandle(Connection);

    if (moSQLMonitor in Options) and (ATracePoint <> tpAfterEvent) then
      AddStatement(AnsiString(St));

    OnDisconnect(AnsiString(Connection.Username), AnsiString(Connection.Server),
      AnsiString(St), Connection, ATracePoint, MessageID);

    if Assigned(FOnSQLEvent) and (ATracePoint <> tpAfterEvent) then
      FOnSQLEvent(Connection, St, tfConnect);
  end;
end;

procedure TCustomDASQLMonitor.InternalTRStart(Component: TComponent; ATracePoint: TTracePoint; var MessageID: Cardinal);
var
  St: _string;
begin
  CheckActive;

  if Active and (tfTransact in TraceFlags) then begin
    St := 'Start: ';
    if Component is TCustomDAConnection then
      St := St + TCustomDAConnection(Component).Username + '@' + TCustomDAConnection(Component).Server;
    St := St + GetCompHandle(Component);

    if (moSQLMonitor in Options) and (ATracePoint <> tpAfterEvent) then
      AddStatement(AnsiString(St));

    OnTransact(AnsiString(St), Component, teStart, ATracePoint, MessageID);

    if Assigned(FOnSQLEvent) and (ATracePoint <> tpAfterEvent) then
      FOnSQLEvent(Component, St, tfTransact);
  end;
end;

procedure TCustomDASQLMonitor.InternalTRCommit(Component: TComponent; ATracePoint: TTracePoint; var MessageID: Cardinal);
var
  St: _string;
begin
  CheckActive;

  if Active and (tfTransact in TraceFlags) then begin
    St := 'Commit: ';
    if Component is TCustomDAConnection then
      St := St + TCustomDAConnection(Component).Username + '@' + TCustomDAConnection(Component).Server;
    St := St + GetCompHandle(Component);

    if (moSQLMonitor in Options) and (ATracePoint <> tpAfterEvent) then
      AddStatement(AnsiString(St));

    OnTransact(AnsiString(St), Component, teCommit, ATracePoint, MessageID);

    if Assigned(FOnSQLEvent) and (ATracePoint <> tpAfterEvent) then
      FOnSQLEvent(Component, St, tfTransact);
  end;
end;

procedure TCustomDASQLMonitor.InternalTRRollback(Component: TComponent; ATracePoint: TTracePoint; var MessageID: Cardinal);
var
  St: _string;
begin
  CheckActive;

  if Active and (tfTransact in TraceFlags) then begin
    St := 'Rollback: ';
    if Component is TCustomDAConnection then
      St := St + TCustomDAConnection(Component).Username + '@' + TCustomDAConnection(Component).Server;
    St := St + GetCompHandle(Component);

    if (moSQLMonitor in Options) and (ATracePoint <> tpAfterEvent) then
      AddStatement(AnsiString(St));

    OnTransact(AnsiString(St), Component, teRollback, ATracePoint, MessageID);

    if Assigned(FOnSQLEvent) and (ATracePoint <> tpAfterEvent) then
      FOnSQLEvent(Component, St, tfTransact);
  end;
end;

procedure TCustomDASQLMonitor.InternalTRSavepoint(Component: TComponent; const Savepoint: _string);
var
  St: _string;
begin
  CheckActive;

  if Active then begin
    St := 'Savepoint ' + Savepoint + ' ' + GetCompHandle(Component);

    if (moSQLMonitor in Options) and (tfTransact in TraceFlags) then
      AddStatement(AnsiString(St));

    if Assigned(FOnSQLEvent) then
      FOnSQLEvent(Component, St, tfTransact);
  end;
end;

procedure TCustomDASQLMonitor.InternalTRRollbackToSavepoint(Component: TComponent; const Savepoint: _string);
var
  St: _string;
begin
  CheckActive;

  if Active then begin
    St := 'Rollback to savepoint ' + Savepoint + ' ' + GetCompHandle(Component);

    if (moSQLMonitor in Options) and (tfTransact in TraceFlags) then
      AddStatement(AnsiString(St));

    if Assigned(FOnSQLEvent) then
      FOnSQLEvent(Component, St, tfTransact);
  end;
end;

procedure TCustomDASQLMonitor.InternalTRReleaseSavepoint(Component: TComponent; const Savepoint: _string);
var
  St: _string;
begin
  CheckActive;

  if Active then begin
    St := 'Release savepoint ' + Savepoint + ' ' + GetCompHandle(Component);

    if (moSQLMonitor in Options) and (tfTransact in TraceFlags) then
      AddStatement(AnsiString(St));

    if Assigned(FOnSQLEvent) then
      FOnSQLEvent(Component, St, tfTransact);
  end;
end;

procedure TCustomDASQLMonitor.InternalTRCommitRetaining(Component: TComponent; ATracePoint: TTracePoint; var MessageID: Cardinal);
var
  St: _string;
begin
  CheckActive;

  if Active then begin
    St := 'CommitRetaining: ' + GetCompHandle(Component);

    if (moSQLMonitor in Options) and (tfTransact in TraceFlags) and (ATracePoint <> tpAfterEvent) then
      AddStatement(AnsiString(St));

    OnTransact(AnsiString(St), Component, teCommit, ATracePoint, MessageID);

    if Assigned(FOnSQLEvent) and (ATracePoint <> tpAfterEvent) then
      FOnSQLEvent(Component, St, tfTransact);
  end;
end;

procedure TCustomDASQLMonitor.InternalTRRollbackRetaining(Component: TComponent; ATracePoint: TTracePoint; var MessageID: Cardinal);
var
  St: _string;
begin
  CheckActive;

  if Active then begin
    St := 'RollbackRetaining: ' + GetCompHandle(Component);

    if (moSQLMonitor in Options) and (tfTransact in TraceFlags) and (ATracePoint <> tpAfterEvent) then
      AddStatement(AnsiString(St));

    OnTransact(AnsiString(St), Component, teRollback, ATracePoint, MessageID);

    if Assigned(FOnSQLEvent) and (ATracePoint <> tpAfterEvent) then
      FOnSQLEvent(Component, St, tfTransact);
  end;
end;

procedure TCustomDASQLMonitor.InternalDBError(Exception: EDAError);
var
  St: _string;
begin
  CheckActive;

  if Active and (tfError in TraceFlags) then begin
    St := 'Error: ' + Exception.Message;

    if (moSQLMonitor in Options) then
      AddStatement(AnsiString(St));

    OnError(AnsiString(Exception.Message));

    if Assigned(FOnSQLEvent) then
      FOnSQLEvent(Exception, St, tfError);
  end;
end;

procedure TCustomDASQLMonitor.InternalCustomMessage(Connection: TCustomDAConnection;
  const Msg: _string; var AMessageID: Cardinal);
begin
  CheckActive;

  if Active and (tfMisc in TraceFlags) then begin
    if (moSQLMonitor in Options) then
      AddStatement(AnsiString(Msg));

    OnCustomMessage(AnsiString(Msg), Connection, tpBeforeEvent, AMessageID);
    OnCustomMessage(AnsiString(Msg), Connection, tpAfterEvent, AMessageID);

    if Assigned(FOnSQLEvent) then
      FOnSQLEvent(Connection, Msg, tfMisc);
  end;
end;

{ Borland's SQL Monitor support }

procedure TCustomDASQLMonitor.RegisterClient;
{$IFDEF WIN32}
var
  Title: AnsiString;
{$ENDIF}
begin
{$IFDEF WIN32}
  if not FRegistered and (GetMonitor = Self) then
    if Succeeded(CoInitialize(nil)) then begin
      if not Succeeded(CoCreateInstance(Class_SMClient, nil, CLSCTX_INPROC_SERVER or
        CLSCTX_LOCAL_SERVER, IUnknown, FSMClient))
      then begin
        CoUninitialize;
        Exit;
      end;

      Title := AnsiString(ApplicationTitle);
      if csDesigning in ComponentState then
        Title := Title + ': ' + GetCaption;
      try
        (FSMClient as ISMClient).RegisterClient(Integer(Self), PAnsiChar(Title), Self,
          @TCustomDASQLMonitor.SMClientSignal);
        FRegistered := True;
      except
      end;
    end;
{$ENDIF}
end;

procedure TCustomDASQLMonitor.UnRegisterClient;
begin
{$IFDEF WIN32}
  FSMClient := nil;
  if FRegistered then begin
    FRegistered := False;
    CoUninitialize;
  end;
{$ENDIF}
end;

procedure TCustomDASQLMonitor.AddStatement(const St: AnsiString);
begin
{$IFDEF WIN32}
  if Assigned(FSMClient) then
    (FSMClient as ISMClient).AddStatement(PAnsiChar(St), Length(St));
{$ENDIF}
end;

{    0  none
     1  Prepare
     2  Execute
     4  Error
     8  Statement
    16  Connect/Disconnect
    32  Transaction
    64  Blob
   128  Misc
   256  Vendor call
   512  Input params
  1024  Fetch}

procedure TCustomDASQLMonitor.SMClientSignal(Sender: TObject; Data: Integer);
begin
  FTraceFlags := {$IFNDEF FPC}TDATraceFlags(Word(Data)){$ELSE}[TDATraceFlag(Word(Data))]{$ENDIF};
end;

procedure TCustomDASQLMonitor.SetActive(Value: boolean);
begin
  FStreamedActive := Value;
  if not (csReading in ComponentState) and (Value <> FActive) then begin
    FActive := Value;

    if moSQLMonitor in Options then
      if FActive then
        RegisterClient
      else
        UnRegisterClient;
  {$IFDEF MSWINDOWS}
    if moDBMonitor in Options then
      if FActive then begin
      {$IFDEF CLR}
        FDBMonitor := GetDBMonitor;
        if FDBMonitor <> nil then
          FDBMonitor.SetCaption(GetCaption);
      {$ELSE}
        if not NeedUninitialize then
          NeedUninitialize := Succeeded(CoInitialize(nil));
        FDBMonitor := GetDBMonitor;
        if FDBMonitor <> nil then
          FDBMonitor.SetCaption(PAnsiChar(GetCaption));
      {$ENDIF}
      end
      else begin
        FDBMonitor := nil;
      end;
  {$ENDIF}
  end;
end;

procedure TCustomDASQLMonitor.SetOptions(Value: TMonitorOptions);
begin
  FOptions := Value;
  if FActive then begin
    if moSQLMonitor in FOptions then
      RegisterClient
    else
      UnRegisterClient;

{$IFDEF WIN32}
    if moDBMonitor in FOptions then begin
      if not NeedUninitialize then
        NeedUninitialize := Succeeded(CoInitialize(nil));
      FDBMonitor := GetDBMonitor;
      if FDBMonitor <> nil then
        FDBMonitor.SetCaption(PAnsiChar(GetCaption));
    end
    else begin
      FDBMonitor := nil;
    end;
{$ENDIF}
  end;
end;

procedure TCustomDASQLMonitor.OnConnect(const Username, Server, St: AnsiString;
  Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
{$IFDEF MSWINDOWS}
var
  Msg: TMonitorMessage;
  ParamStr: AnsiString;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if FDBMonitor <> nil then begin
    with Msg do begin
      MessageID := AMessageID;
      EventType := Integer(etConnect);
      TracePoint := Integer(ATracePoint);
      ObjectID := GetComponentID(Component);
      OwnerID := 0;
      OwnerName := '';
      ParamStr := AnsiString(Format(fmtConnectInfo, [Username, Server]));
    {$IFDEF CLR}
      ObjectName := GetComponentName(Component);
      Description := St;
      FDBMonitor.OnEvent(Msg, ParamStr);
    {$ELSE}
      ObjectName := PAnsiChar(GetComponentName(Component));
      Description := PAnsiChar(St);
      FDBMonitor.OnEvent(Msg, PAnsiChar(ParamStr));
    {$ENDIF}
    end;
    if ATracePoint = tpBeforeEvent then
      AMessageID := Msg.MessageID;
  end;
{$ENDIF}
end;

procedure TCustomDASQLMonitor.OnDisconnect(const Username, Server,
  St: AnsiString; Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
{$IFDEF MSWINDOWS}
var
  Msg: TMonitorMessage;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if FDBMonitor <> nil then begin
    with Msg do begin
      MessageID := AMessageID;
      EventType := Integer(etDisconnect);
      TracePoint := Integer(ATracePoint);
      ObjectID := GetComponentID(Component);
      OwnerID := 0;
      OwnerName := '';
    {$IFDEF CLR}
      ObjectName := GetComponentName(Component);
      Description := St;
      FDBMonitor.OnEvent(Msg, '');
    {$ELSE}
      ObjectName := PAnsiChar(GetComponentName(Component));
      Description := PAnsiChar(St);
      FDBMonitor.OnEvent(Msg, nil);
    {$ENDIF}
    end;
    if ATracePoint = tpBeforeEvent then
      AMessageID := Msg.MessageID;
  end;
{$ENDIF}
end;

procedure TCustomDASQLMonitor.OnError(const ErrorStr: AnsiString);
{$IFDEF MSWINDOWS}
var
  Msg: TMonitorMessage;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if FDBMonitor <> nil then begin
    with Msg do begin
      TracePoint := Integer(tpAfterEvent);
      EventType := Integer(etError);
      Description := '';
    end;
  {$IFDEF CLR}
    FDBMonitor.OnEvent(Msg, ErrorStr);
  {$ELSE}
    FDBMonitor.OnEvent(Msg, PAnsiChar(ErrorStr));
  {$ENDIF}
  end;
{$ENDIF}
end;

procedure TCustomDASQLMonitor.OnCustomMessage(const St: AnsiString; Component: TComponent;
  ATracePoint: TTracePoint; var AMessageID: Cardinal);
{$IFDEF MSWINDOWS}
var
  Msg: TMonitorMessage;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if FDBMonitor <> nil then begin
    with Msg do begin
      MessageID := AMessageID;
      EventType := Integer(etConnect);
      TracePoint := Integer(ATracePoint);
      ObjectID := GetComponentID(Component);
      OwnerID := 0;
      OwnerName := '';
  {$IFDEF CLR}
      ObjectName := GetComponentName(Component);
      Description := St;
      FDBMonitor.OnEvent(Msg, '');
  {$ELSE}
      ObjectName := PAnsiChar(GetComponentName(Component));
      Description := PAnsiChar(St);
      FDBMonitor.OnEvent(Msg, nil);
  {$ENDIF}
    end;
    if ATracePoint = tpBeforeEvent then
      AMessageID := Msg.MessageID;
  end;
{$ENDIF}
end;

procedure TCustomDASQLMonitor.PrepareExecuteMessage(const SQL: AnsiString; var Params: TSQLParams; const St: AnsiString;
  Component: TComponent; ATracePoint: TTracePoint; EventType: TEventType; var AMessageID: Cardinal);
{$IFDEF MSWINDOWS}
var
  RowsAffected: integer;
  Connection: TComponent;
  Msg: TMonitorMessage;
{$IFNDEF CLR}
  PParam: PSQLParam;
{$ENDIF}
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if FDBMonitor <> nil then begin
    RowsAffected := 0;
    if (Component is TCustomDASQL) then
      RowsAffected := TCustomDASQL(Component).RowsAffected
    else
    if (Component is TCustomDADataSet) then
      RowsAffected := TCustomDADataSet(Component).RowsAffected;
    Connection := GetParent(Component, 0);
    with Msg do begin
      MessageID := AMessageID;
      EventType := Integer(etExecute);
      TracePoint := Integer(ATracePoint);
      ObjectID := GetComponentID(Component);
      OwnerID := GetComponentID(Connection);
    {$IFDEF CLR}
      ObjectName := GetComponentName(Component);
      if Connection <> nil then
        OwnerName := GetComponentName(Connection)
      else
        OwnerName := '';
      Description := St;
      FDBMonitor.OnExecute(Msg, SQL, Params, Length(Params), RowsAffected);
    {$ELSE}
      ObjectName := PAnsiChar(GetComponentName(Component));
      if Connection <> nil then
        OwnerName := PAnsiChar(GetComponentName(Connection))
      else
        OwnerName := '';
      Description := PAnsiChar(St);
      PParam := nil;
      if Length(Params) > 0 then
        PParam := @Params[0];
      FDBMonitor.OnExecute(Msg, PAnsiChar(SQL), PParam, Length(Params), RowsAffected);
    {$ENDIF}
    end;
    if ATracePoint = tpBeforeEvent then
      AMessageID := Msg.MessageID;
  end;
{$ENDIF}
end;

procedure TCustomDASQLMonitor.OnExecute(const SQL: AnsiString; var Params: TSQLParams;
  const St: AnsiString; Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
begin
  PrepareExecuteMessage(SQL, Params, St, Component, ATracePoint, etExecute, AMessageID);
end;

procedure TCustomDASQLMonitor.OnPrepare(const SQL: AnsiString; var Params: TSQLParams;
  const St: AnsiString; Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
begin
  PrepareExecuteMessage(SQL, Params, St, Component, ATracePoint, etPrepare, AMessageID);
end;

procedure TCustomDASQLMonitor.OnUnprepare(const SQL: AnsiString; var Params: TSQLParams;
  const St: AnsiString; Component: TComponent; ATracePoint: TTracePoint; var AMessageID: Cardinal);
begin
  PrepareExecuteMessage(SQL, Params, St, Component, ATracePoint, etPrepare, AMessageID);
end;

procedure TCustomDASQLMonitor.OnTransact(const St: AnsiString;
  Component: TComponent; TransactEvent: integer; ATracePoint: TTracePoint; var AMessageID: Cardinal);
{$IFDEF MSWINDOWS}
var
  Msg: TMonitorMessage;
  i: integer;
  Parent: TComponent;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if FDBMonitor <> nil then begin
    with Msg do begin
      MessageID := AMessageID;
      case TransactEvent of
        teCommit:
          EventType := Integer(etCommit);
        teRollback:
          EventType := Integer(etRollback);
      else
        EventType := Integer(etConnect);
      end;
      TracePoint := Integer(ATracePoint);
      ObjectID := GetComponentID(Component);
    {$IFDEF CLR}
      ObjectName := GetComponentName(Component);
      Description := St;
    {$ELSE}
      ObjectName := PAnsiChar(GetComponentName(Component));
      Description := PAnsiChar(St);
    {$ENDIF}
      for i := 0 to GetParentCount(Component) - 1 do begin
        Parent := GetParent(Component, i);
        OwnerID := GetComponentID(Parent);
        if Parent <> nil then
          OwnerName := {$IFNDEF CLR}PAnsiChar{$ENDIF}(GetComponentName(Parent))
        else
          OwnerName := '';
      {$IFDEF CLR}
        FDBMonitor.OnEvent(Msg, '');
      {$ELSE}
        FDBMonitor.OnEvent(Msg, nil)
      {$ENDIF}
      end;
    end;
    if ATracePoint = tpBeforeEvent then
      AMessageID := Msg.MessageID;
  end;
{$ENDIF}
end;

class function TCustomDASQLMonitor.HasMonitor: boolean;
begin
  Result := GetMonitor <> nil;
end;

procedure TCustomDASQLMonitor.Loaded;
begin
  inherited Loaded;
  CheckActive;
end;

procedure TCustomDASQLMonitor.CheckActive;
begin
  Active := FStreamedActive;
end;

initialization
  ShowDebugFormProc := nil;
end.
