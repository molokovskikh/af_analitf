{$IFNDEF CLR}

{$I MyDac.inc}

unit MyBuilderClient;
{$ENDIF}
interface

{$IFDEF MSWINDOWS}

uses
  Classes, MyAccess, MyBuilderIntf;

type
  TMyBuilder = class(TComponent)
  protected
    FConnection: TMyConnection;
    FSQL: TStrings;
    FDesignCreate: boolean;
    FMyBuilderI: IMyBuilder;
    FSyncNeeded: boolean;

    function GetAvailable: boolean;
    function GetVersion: string;
    procedure Notification(Component: TComponent; Operation: TOperation); override;
    procedure SetConnection(Value: TMyConnection);

    function GetSQL: TStrings;
    procedure SetSQL(Value: TStrings);
    procedure SQLChanged(Sender: TObject);

    function ShowMyBuilder(Modal: boolean): boolean;
    procedure GetMyByilder;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    procedure Show;
    function ShowModal: boolean;

    property Available: boolean read GetAvailable;
    property Version: string read GetVersion;

  published
    property Connection: TMyConnection read FConnection write SetConnection;
    property SQL: TStrings read GetSQL write SetSQL;
  end;

  TMyBuilderUtils = class
  public
    class procedure SetDesignCreate(Obj: TMyBuilder; Value: boolean);
    class function GetDesignCreate(Obj: TMyBuilder): boolean;
  end;

  TNeedToCheckMyBuilder = (cmNone, cmNoAddin, cmIncompartible);

function MyBuilderAvailable: boolean;
function ShowMyBuilder(DataSet: TCustomMyDataSet): boolean;

var
  NeedToCheckMyBuilder: TNeedToCheckMyBuilder;

{$ENDIF}

implementation

{$IFDEF MSWINDOWS}

uses
  ActiveX, ComObj, SysUtils, Registry, Windows, MyConsts, DB, Forms;

var
  NeedUninitialize: boolean;

function MyBuilderAvailable: boolean;
var
  MyBuilderI: TMyBuilder;
begin
  MyBuilderI := TMyBuilder.Create(nil);
  try
    Result := MyBuilderI.Available; 
  finally
    MyBuilderI.Free;
  end;
end;

function ShowMyBuilder(DataSet: TCustomMyDataSet): boolean;
var
  MyBuilderI: TMyBuilder;
begin
  Result := False;
  MyBuilderI := TMyBuilder.Create(nil);
  try
    if DataSet <> nil then begin
      if not (DataSet.Connection is TMyConnection) then
        Exit;
      MyBuilderI.Connection := TMyConnection(DataSet.Connection);
      MyBuilderI.SQL.Text := DataSet.SQL.Text;
    end;
    Result := MyBuilderI.ShowMyBuilder(True);
    if Result and (DataSet <> nil) then
      DataSet.SQL.Text := MyBuilderI.SQL.Text;
  finally
    MyBuilderI.Free;
  end;
end;

{ TMyBuilder }

constructor TMyBuilder.Create(Owner: TComponent);
begin
  inherited;
  FSQL := TStringList.Create;
  TStringList(FSQL).OnChange := SQLChanged;
end;

destructor TMyBuilder.Destroy;
begin
  FSQL.Free;
  inherited;
end;

function TMyBuilder.GetAvailable: boolean;
begin
  GetMyByilder;
  Result := FMyBuilderI <> nil; 
end;

function TMyBuilder.GetVersion: string;
var
  p: PAnsiChar;
begin
  if Available then begin
    FMyBuilderI.GetVersion(p);
    Result := string(p);
  end
  else
    Result := '';
end;

procedure TMyBuilder.Notification(Component: TComponent;
  Operation: TOperation);
begin
  if (Component = FConnection) and (Operation = opRemove) then
    Connection := nil;

  inherited;
end;

procedure TMyBuilder.SetConnection(Value: TMyConnection);
begin
  if Value <> FConnection then begin
    if FConnection <> nil then
      RemoveFreeNotification(FConnection);

    FConnection := Value;

    if FConnection <> nil then
      FreeNotification(FConnection);
  end;
end;

function TMyBuilder.GetSQL: TStrings;
var
  p: PAnsiChar;
begin
  if (FMyBuilderI <> nil) and FSyncNeeded then begin
    FMyBuilderI.GetSQL(p);
    FSQL.Text := string(p);
  end;

  Result := FSQL;
end;

procedure TMyBuilder.SetSQL(Value: TStrings);
begin
  if FSQL.Text <> Value.Text then begin
    FSQL.BeginUpdate;
    try
      FSQL.Assign(Value);
    finally
      FSQL.EndUpdate;
    end;
  end;
end;

procedure TMyBuilder.SQLChanged(Sender: TObject);
var
  ASQLText: AnsiString;
begin
  if (FMyBuilderI <> nil) and FSyncNeeded then begin
    ASQLText := AnsiString(TrimRight(FSQL.Text));
    FMyBuilderI.SetSQL(PAnsiChar(ASQLText));
  end;
end;

procedure TMyBuilder.Show;
begin
  ShowMyBuilder(False);
end;

function TMyBuilder.ShowModal: boolean;
begin
  Result := ShowMyBuilder(True);
end;

function TMyBuilder.ShowMyBuilder(Modal: boolean): boolean;
  procedure InternalSetConnection(Connection: TMyConnection);
  var
    AConnection: TConnection;
  begin
    if Connection <> nil then begin
      AConnection.Username := PAnsiChar(AnsiString(Connection.Username));
      AConnection.Password := PAnsiChar(AnsiString(Connection.Password));
      AConnection.Server := PAnsiChar(AnsiString(Connection.Server));
      AConnection.Database := PAnsiChar(AnsiString(Connection.DataBase));
      AConnection.ConnectionTimeout := Connection.ConnectionTimeout;
      AConnection.Port := Connection.Port;
    {$IFDEF HAVE_DIRECT}
      AConnection.Direct := Integer(Connection.Options.Direct);
    {$ENDIF}
      AConnection.Protocol := Integer(Connection.Options.Protocol);
      AConnection.Connected := Integer(Connection.Connected);
      FMyBuilderI.SetConnection(AConnection);
    end;
  end;

var
  Res: integer;
  SQLText: PAnsiChar;
  ASQLText: AnsiString;

begin
  Result := False;
  GetMyByilder;
  if FMyBuilderI = nil then
    if csDesigning in ComponentState then
      Exit
    else
      DatabaseError(SMyBuilderNA);

  if Connection <> nil then
    InternalSetConnection(TMyConnection(Connection));

  if Modal or not FSyncNeeded then begin
    ASQLText := AnsiString(TrimRight(SQL.Text));
    if ASQLText <> '' then
      FMyBuilderI.SetSQL(PAnsiChar(ASQLText))
    else
      FMyBuilderI.SetSQL('');
  end;

  if Modal then begin
    FMyBuilderI.ShowModal(Res);

    FMyBuilderI.GetModified(Res);
    Result := Res <> 0;
    if Result then begin
      FMyBuilderI.GetSQL(SQLText);
      SQL.Text := string(SQLText);
      FMyBuilderI.SetSQL('');
    end
  end
  else begin
    FSyncNeeded := True;
    FMyBuilderI.Show;
  end;
end;

procedure TMyBuilder.GetMyByilder;
  procedure CreateMyBuilder;
  var
  {$IFDEF CLR}
    Obj: TObject;
  {$ELSE}
    Obj: IUnknown;
  {$ENDIF}
    //OldNeedToCheckMyBuilder: TNeedToCheckMyBuilder;
  begin
    //OldNeedToCheckMyBuilder := NeedToCheckMyBuilder;
    NeedToCheckMyBuilder := cmNone;
    with TRegistry.Create do
    try
      RootKey := HKEY_CLASSES_ROOT;
    {$IFDEF CLR}
      if OpenKeyReadOnly('CLSID\{' + GUIDToString(Class_MyBuilder) + '}\InprocServer32') /// CR-M13455
    {$ELSE}
      if OpenKeyReadOnly('CLSID\' + GUIDToString(Class_MyBuilder) + '\InprocServer32') /// CR-M13455
    {$ENDIF}
      then begin
        if FileExists(ReadString('')) then begin
          NeedUninitialize := Succeeded(CoInitialize(nil));
        {$IFDEF CLR}
          Obj := CreateComObject(Class_MyBuilder);
          FMyBuilderI := Obj as IMyBuilder;
        {$ELSE}
          Obj := CreateComObject(Class_MyBuilder);
          Obj.QueryInterface(IMyBuilder, FMyBuilderI);
        {$ENDIF}
          if FMyBuilderI <> nil then begin
            if Application.MainForm <> nil then
              FMyBuilderI.SetOwner(Application.MainForm.Handle)
            else
              FMyBuilderI.SetOwner({$IFNDEF FPC}Application.Handle{$ELSE}0{$ENDIF});
          end
          else
            NeedToCheckMyBuilder := cmIncompartible;
          Obj := nil;
        end
        else
          NeedToCheckMyBuilder := cmNoAddin;
        CloseKey;
      end
      else begin
        FMyBuilderI := nil;
        NeedToCheckMyBuilder := cmNoAddin;
      end;
    finally
      Free;
    end;

    //NeedToRebuildMenu := (OldNeedToCheckMyBuilder <> cmNone) and (NeedToCheckMyBuilder = cmNone);
  end;

begin
  if FMyBuilderI <> nil then
    Exit;

  CreateMyBuilder;
{$IFNDEF CLR}
{$IFNDEF FPC}
  if FMyBuilderI = nil then begin
    try
      RegisterComServer('MyBuilder.dll');
    except
      Exit;
    end;
    CreateMyBuilder;
  end;
{$ENDIF}
{$ENDIF}
end;

class procedure TMyBuilderUtils.SetDesignCreate(Obj: TMyBuilder; Value: boolean);
begin
  Obj.FDesignCreate := Value;
end;

class function TMyBuilderUtils.GetDesignCreate(Obj: TMyBuilder): boolean;
begin
  Result := Obj.FDesignCreate;
end;

initialization
  NeedUninitialize := False;

finalization
  if NeedUninitialize then
    CoUninitialize;

{$ENDIF}
end.
