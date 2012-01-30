
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyEmbConnection;
{$ENDIF}

interface

uses
{$IFDEF WIN32}
  Windows,
{$ENDIF}
  Classes,
  MemData, DBAccess, MySqlApi,
  MyClasses, MyAccess, MyConnectionPool;

type

{ TMyEmbConnection }

  TMyEmbConnection = class;

  TMyEmbConnectionOptions = class (TCustomMyConnectionOptions)
  protected
    procedure AssignTo(Dest: TPersistent); override;

  public
    constructor Create(Owner: TMyEmbConnection);

  published
    property UseUnicode default False;
    property Charset;
    property KeepDesignConnected;
    property NumericType default ntFloat;
    property OptimizedBigInt default False;
    property DefaultSortType;
  end;

  TMyEmbConnection = class (TCustomMyConnection)
  protected
    FParams: TStrings;
    FParamsChanged: boolean;

    FOnLog: TMyLogEvent;
    FOnLogError: TMyLogEvent;
    {FOnStdOut: TMyLogEvent;
    FOnStdErr: TMyLogEvent;}

    function GetOptions: TMyEmbConnectionOptions;
    procedure SetOptions(Value: TMyEmbConnectionOptions);
    procedure SetParams(Value: TStrings);

    function GetClientVersion: string; override;
    function CreateOptions: TDAConnectionOptions; override;
    procedure FillConnectionParameters(var ConnectionParameters: TMyConnectionParameters); override;
    procedure FillConnectionProps(MySQLConnection: TMySQLConnection); override;

    procedure ParamsChanging(Sender: TObject);
    procedure ParamsChange(Sender: TObject);

    procedure ReadState(Reader: TReader); override;
    procedure AssignTo(Dest: TPersistent); override;

    procedure SetConnected(Value: boolean); override;
    procedure SetOnLog(Value: TMyLogEvent);
    procedure SetOnLogError(Value: TMyLogEvent);
    {procedure SetOnStdOut(Value: TMyLogEvent);
    procedure SetOnStdErr(Value: TMyLogEvent);}
    function GetEmbParamsStr: string;
    procedure DoConnect; override;

    function GetBaseDir: string;
    procedure SetBaseDir(Value: string);
    function GetDataDir: string;
    procedure SetDataDir(Value: string);

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

  published
    property Database;
    property ConnectionTimeout;
    property IsolationLevel;

    property Options: TMyEmbConnectionOptions read GetOptions write SetOptions;
    property Params: TStrings read FParams write SetParams;
    property BaseDir: string read GetBaseDir write SetBaseDir stored False;
    property DataDir: string read GetDataDir write SetDataDir stored False;

    property OnLog: TMyLogEvent read FOnLog write SetOnLog;
    property OnLogError: TMyLogEvent read FOnLogError write SetOnLogError;
    {property OnStdOut: TMyLogEvent read FOnStdOut write SetOnStdOut;
    property OnStdErr: TMyLogEvent read FOnStdErr write SetOnStdErr;}

    property PoolingOptions;
    property Pooling;

    property Username;
    property Password;
    property Connected;

    property AfterConnect;
    property BeforeConnect;
    property AfterDisconnect;
    property BeforeDisconnect;
    property OnLogin;
    property OnError;
    property ConnectDialog;
    property LoginPrompt;
  end;

var
  CurrentProjectOutputDir: string;

implementation

uses
{$IFDEF CLR}
  Variants,
{$ENDIF}
  SysUtils,
  U_ExchangeLog;

{ TMyEmbConnectionOptions }

procedure TMyEmbConnectionOptions.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TMyEmbConnectionOptions then begin
  end;
end;

constructor TMyEmbConnectionOptions.Create(Owner: TMyEmbConnection);
begin
  inherited Create(Owner);
end;

{ TMyEmbConnection }

constructor TMyEmbConnection.Create(Owner: TComponent);
begin
  inherited;
  FParams := TStringList.Create;
  if not (csReading in ComponentState) then begin
    BaseDir := '.';
    DataDir := 'data';
  end;
  TStringList(FParams).OnChanging := ParamsChanging;
  TStringList(FParams).OnChange := ParamsChange;
end;

destructor TMyEmbConnection.Destroy;
begin
  Disconnect;
  FParams.Free;
  inherited;
end;

procedure TMyEmbConnection.ReadState(Reader: TReader);
begin
  inherited;
  if not FParamsChanged then begin
    BaseDir := '';
    DataDir := '';
  end;
end;

procedure TMyEmbConnection.AssignTo(Dest: TPersistent);
begin
  if Dest is TMyEmbConnection then begin
    TMyEmbConnection(Dest).Params.Assign(Params);
  end;
  inherited;
end;

function TMyEmbConnection.GetClientVersion: string;
var
  Conn: TMySQLConnection;
begin
  if Connected then
  begin
    Assert(FIConnection <> nil);
    Result := IConnection.GetClientVersion;
  end
  else
  begin
    Conn := TMySQLConnection.Create;
    try
      Conn.SetProp(prEmbedded, True);
      Conn.SetProp(prEmbParams, GetEmbParamsStr);
      Result := Conn.GetClientVersion;
    finally
      Conn.Free;
    end;
  end
end;

function TMyEmbConnection.CreateOptions: TDAConnectionOptions;
begin
  Result := TMyEmbConnectionOptions.Create(Self);
end;

function TMyEmbConnection.GetOptions: TMyEmbConnectionOptions;
begin
  Result := FOptions as TMyEmbConnectionOptions;
end;

procedure TMyEmbConnection.SetOptions(Value: TMyEmbConnectionOptions);
begin
  FOptions.Assign(Value);
end;

procedure TMyEmbConnection.SetParams(Value: TStrings);
begin
  CheckInactive;
  FParams.Assign(Value);
end;

procedure TMyEmbConnection.FillConnectionParameters(var ConnectionParameters: TMyConnectionParameters);
begin
  inherited;

  ConnectionParameters.Embedded := True;
  ConnectionParameters.EmbParams.Text := GetEmbParamsStr;
end;

function TMyEmbConnection.GetEmbParamsStr: string;
var
  sl: TStringList;

  procedure CheckDirParam(const ParamName: string);
  var
    s: string;
  begin
    s := sl.Values[ParamName];
    if s = '' then
      Exit;

    if (s <> '') and ((s[1] = '/') or (s[1] = '\')) then
      s := Copy(s, 2, MaxInt);

    if (csDesigning in ComponentState) and
      (s <> '') and (s[1] = '.') and // relative path
      (ParamName = '--basedir') and
      (CurrentProjectOutputDir <> '')
    then
      s := IncludeTrailingBackslash(CurrentProjectOutputDir) + s;

    s := StringReplace(s, '\', '/', [rfReplaceAll]);
    sl.Values[ParamName] := s;
    Result := sl.Text;
  end;

begin
  sl := TStringList.Create;
  try
    sl.AddStrings(FParams);

    CheckDirParam('--basedir');
    CheckDirParam('--datadir');
    CheckDirParam('--character-sets-dir');
    CheckDirParam('--tmpdir');
    CheckDirParam('--log-bin');
    CheckDirParam('--log-bin-index');

    Result := Trim(sl.Text);
  finally
    sl.Free;
  end;
end;

procedure TMyEmbConnection.DoConnect;
begin
  ParamsChange(nil); // Check changes of design time option
  inherited;
end;

procedure TMyEmbConnection.FillConnectionProps(MySQLConnection: TMySQLConnection);
begin
  inherited;

  MySQLConnection.SetProp(prEmbedded, True);
  MySQLConnection.SetProp(prEmbParams, GetEmbParamsStr);
end;

procedure TMyEmbConnection.ParamsChanging(Sender: TObject);
begin
  CheckInactive;
end;

procedure TMyEmbConnection.ParamsChange(Sender: TObject);
begin
  FParamsChanged := csReading in ComponentState;
  if IConnection = nil then
    Exit;

  IConnection.SetProp(prEmbParams, GetEmbParamsStr);
end;

procedure TMyEmbConnection.SetConnected(Value: boolean);
  procedure UnRegisterEvents;
  begin
    if Assigned(FOnLog) then
      MyAPIEmbedded.UnRegisterOnLogEvent(FOnLog);
    if Assigned(FOnLogError) then
      MyAPIEmbedded.UnRegisterOnLogErrorEvent(FOnLogError);
  end;

begin
  if Value = GetConnected then
    Exit;

  if not Value then begin
    WriteExchangeLogTID('TMyEmbConnection.SetConnected=False', 'Будем вызывать Sleep');
    Sleep(1000);
    WriteExchangeLogTID('TMyEmbConnection.SetConnected=False', 'Завершили вызов Sleep');
  end;

  try
    if Value then begin
      if Assigned(FOnLog) then
        MyAPIEmbedded.RegisterOnLogEvent(FOnLog);
      if Assigned(FOnLogError) then
        MyAPIEmbedded.RegisterOnLogErrorEvent(FOnLogError);
    end;

    inherited;

  except
    UnRegisterEvents;
    raise;
  end;

  if not Value then begin
    UnRegisterEvents;
    // Decrement of open connection counter
    // dll released only on call MyAPIEmbedded.FreeMySQLLib
    MyAPIEmbedded.UnRegisterConnection;
  end;
end;

procedure TMyEmbConnection.SetOnLog(Value: TMyLogEvent);
begin
  CheckInactive;
  FOnLog := Value;
end;

procedure TMyEmbConnection.SetOnLogError(Value: TMyLogEvent);
begin
  CheckInactive;
  FOnLogError := Value;
end;

{procedure TMyEmbConnection.SetOnStdOut(Value: TMyLogEvent);
begin
  CheckInactive;
  FOnStdOut := Value;
end;

procedure TMyEmbConnection.SetOnStdErr(Value: TMyLogEvent);
begin
  CheckInactive;
  FOnStdErr := Value;
end;}

function TMyEmbConnection.GetBaseDir: string;
begin
  Result := Params.Values['--basedir'];
end;

procedure TMyEmbConnection.SetBaseDir(Value: string);
begin
  Params.Values['--basedir'] := Value;
end;

function TMyEmbConnection.GetDataDir: string;
begin
  Result := Params.Values['--datadir'];
end;

procedure TMyEmbConnection.SetDataDir(Value: string);
begin
  Params.Values['--datadir'] := Value;
end;

end.
