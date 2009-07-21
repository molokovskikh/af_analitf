type

{ TMyConnectDialog }

  TMyConnectDialog = class(TCustomConnectDialog)
  private
    function GetConnection: TCustomMyConnection;

  protected
    FShowDatabase: boolean;
    FShowPort: boolean;
    FDatabaseLabel: string;
    FPortLabel: string;

    procedure SetLabelSet(Value: TLabelSet); override;

    function DefDialogClass: TClass; override;
  {$IFDEF MSWINDOWS}
    function GetKeyPath: string; override;
    function GetServerStoreName: string; override;
    procedure SaveInfoToRegistry(Registry: TRegistry); override;
    procedure LoadInfoFromRegistry(Registry: TRegistry); override;
  {$ENDIF}
  public
    constructor Create(Owner: TComponent); override;

    function Execute: boolean; override;

    property Connection: TCustomMyConnection read GetConnection;
    procedure GetServerList(List: _TStrings); override;

  published
    property ShowDatabase: boolean read FShowDatabase write FShowDatabase default True;
    property ShowPort: boolean read FShowPort write FShowPort default True;
    property DatabaseLabel: string read FDatabaseLabel write FDatabaseLabel;
    property PortLabel: string read FPortLabel write FPortLabel;

    property Retries;
    property SavePassword;
    property DialogClass;

    property Caption;
    property UsernameLabel;
    property PasswordLabel;
    property ServerLabel;
    property ConnectButton;
    property CancelButton;

    property LabelSet;
    property StoreLogInfo;
  end;

function DefConnectDialogClass: TClass;
procedure GetMyServerList(List: _TStrings; RaiseErrors: boolean = True);

implementation

function DefConnectDialogClass: TClass;
begin
  Result := TMyConnectDialog;
end;

const
  KeyPath = '\SOFTWARE\Devart\MyDAC\';

procedure GetMyServerList(List: _TStrings; RaiseErrors: boolean = True);
const
  sCannotFind = 'Cannot find ';
  sError = 'sError';

{$IFDEF MSWINDOWS}
var
  Registry: TRegistry;
  i: integer;
  ServerLabel: string;
{$ENDIF}

begin
{$IFDEF MSWINDOWS}
  ServerLabel := 'Server ';

  Registry := TRegistry.Create;
  try
    if Registry.OpenKey(KeyPath + 'Connect', False) then begin
      List.Clear;
      i := 1;
      while Registry.ValueExists(ServerLabel + IntToStr(i)) do begin
        List.Add(Registry.ReadString(ServerLabel + IntToStr(i)));
        Inc(i);
      end;
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
{$ENDIF}
end;

{ TMyConnectDialog }

constructor TMyConnectDialog.Create(Owner: TComponent);
begin
  inherited;

  FShowDatabase := True;
  FShowPort := True;
  FDatabaseLabel := 'Database';
  FPortLabel := 'Port';
end;

function TMyConnectDialog.Execute: boolean;
var
  OldDatabase: string;
  OldPort: integer;
begin
  if Connection = nil then
    DatabaseError(SConnectionNotDefined);
  Assert(Connection is TCustomMyConnection);

  Result := False;
  OldDatabase := TCustomMyConnection(Connection).Database;
  if Connection is TMyConnection then
    OldPort := TMyConnection(Connection).Port
  else
    OldPort := 0; // skip warning
  try
    Result := inherited Execute;
  finally
    if not Result then begin
      TCustomMyConnection(Connection).Database := OldDatabase;
      if Connection is TMyConnection then
        TMyConnection(Connection).Port := OldPort;
    end;
  end;
end;

procedure TMyConnectDialog.SetLabelSet(Value: TLabelSet);
begin
  inherited SetLabelSet(Value);

{$IFDEF WIN32}
  if Value <> lsCustom then begin
    FDatabaseLabel := GetString(6);
    FPortLabel := GetString(7);
  end;
{$ELSE}
    FDatabaseLabel := 'Database';
    FPortLabel := 'Port';
{$ENDIF}
end;

function TMyConnectDialog.DefDialogClass: TClass;
begin
  Result := TMyConnectForm;
end;

{$IFDEF MSWINDOWS}
function TMyConnectDialog.GetKeyPath: string;
begin
  Result := KeyPath;
end;

function TMyConnectDialog.GetServerStoreName: string;
begin
  Result := 'Server';
end;

procedure TMyConnectDialog.SaveInfoToRegistry(Registry: TRegistry);
begin
  inherited;
  Registry.WriteInteger('Port', TMyConnection(Connection).Port);
  Registry.WriteString('Database', TMyConnection(Connection).Database);
end;

procedure TMyConnectDialog.LoadInfoFromRegistry(Registry: TRegistry);
begin
  inherited;
  if Registry.ValueExists('Port') and (Connection is TMyConnection) then
      TMyConnection(Connection).Port := Registry.ReadInteger('Port');
  if Registry.ValueExists('Database') then
      TCustomMyConnection(Connection).Database := Registry.ReadString('Database');
end;
{$ENDIF}

procedure TMyConnectDialog.GetServerList(List: _TStrings);
begin
  GetMyServerList(List, False);
end;

function TMyConnectDialog.GetConnection: TCustomMyConnection;
begin
  Result := (inherited Connection) as TCustomMyConnection;
end;

initialization
  DefConnectDialogClassProc := DefConnectDialogClass;
end.
