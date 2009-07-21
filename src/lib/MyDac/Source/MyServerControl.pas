
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyServerControl;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  {$IFNDEF FPC}WinSvc,{$ENDIF} DAConsts, Windows,
{$ENDIF}
  MemUtils, MyAccess, MyConsts, DBAccess, Classes, DB;

type

{ TMyServerControl }

  TMyCheckType = (ctQuick, ctFast, ctChanged, ctMedium, ctExtended); // On change needs to modify EdMyServerControl!
  TMyCheckTypes = set of TMyCheckType;

  TMyRepairType = (rtQuick, rtExtended, rtUseFrm); // On change needs to modify EdMyServerControl!
  TMyRepairTypes = set of TMyRepairType;

  TMyFlushType = (foHosts, foDesKeyFile, foLogs, foPrivileges, foQueryCache, foTables, foStatus, foUserResources);
  TMyFlushTypes = set of TMyFlushType;

{$IFDEF MSWINDOWS}
  TMyServiceStatus = TCRServiceStatus;
{$ENDIF}
  TMyServerControl = class(TCustomMyDataSet)
  protected
    FTables: _TStringList;

    FDesignCreate: boolean;

    procedure AssignTo(Dest: TPersistent); override;
    function GetCanModify: boolean; override;

    procedure SetTables(Value: _TStringList);

    function GetTableNames: _string;
    procedure SetTableNames(Value: _string);
    function GetTableNamesStr: _string; // if TableNames is setted then return GetTableNames else return full tables list

    procedure Loaded; override;

    function GetVariables(const VarName: _string): _string;
    procedure SetVariables(const VarName: _string; Value: _string);

  {$IFDEF MSWINDOWS}
    function GetServerName: string;
  {$ENDIF}
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    procedure CreateDatabase(DatabaseName: string; IfNotExists: boolean = True; CharsetName: string =''; CollationName: string = '');
    procedure DropDatabase(DatabaseName: string; IfExists: boolean = True);

    procedure AnalyzeTable;
    procedure OptimizeTable;
    procedure CheckTable(CheckTypes: TMyCheckTypes = [ctMedium]);
    procedure RepairTable(RepairTypes: TMyRepairTypes = []);

    procedure ShowProcessList(Full: boolean = False);
    procedure KillProcess(ThreadId: integer);
    procedure Flush(FlushTypes: TMyFlushTypes);

    procedure ShowStatus;
    procedure ShowVariables;

    property Variables[const VarName: _string]: _string read GetVariables write SetVariables;
  {$IFDEF MSWINDOWS}
    procedure GetServiceNames(List: TStrings);
    function ServiceStatus(const ServiceName: string): TMyServiceStatus;
    procedure ServiceStart(const ServiceName: string; ParamStr: string = '');
    procedure ServiceStop(const ServiceName: string);
  {$ENDIF}

  published
    property Connection;
    property Debug;
    property CommandTimeout;

    property TableNames: _string read GetTableNames write SetTableNames;

//    property Tables: _TStringList read FTables write SetTables;
  end;

  TMyServerControlUtils = class
  public
    class procedure SetDesignCreate(Obj: TMyServerControl; Value: boolean);
    class function GetDesignCreate(Obj: TMyServerControl): boolean;
  end;

implementation

uses
{$IFDEF CLR}
  System.Runtime.InteropServices, System.text,
{$ELSE}
  CLRClasses,
{$ENDIF}
  SysUtils;

{ TMyServerControl }

constructor TMyServerControl.Create(Owner: TComponent);
begin
  inherited;

  FDesignCreate := csDesigning in ComponentState;
  FTables := _TStringList.Create;
  FetchAll := True;
  ReadOnly := True;
end;

destructor TMyServerControl.Destroy;
begin
  FTables.Free;

  inherited;
end;

procedure TMyServerControl.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TMyServerControl then begin
    TMyServerControl(Dest).FTables.Text := FTables.Text;
  end;
end;

function TMyServerControl.GetCanModify: boolean;
begin
  Result := False;
end;

procedure TMyServerControl.SetTables(Value: _TStringList);
begin
 if FTables.Text <> Value.Text then begin
    FTables.BeginUpdate;
    try
      FTables.Assign(Value);
    finally
      FTables.EndUpdate;
    end;
  end;
end;

function TMyServerControl.GetTableNames: _string;
begin
  Result := TableNamesFromList(FTables);
end;

procedure TMyServerControl.SetTableNames(Value: _string);
begin
  TableNamesToList(Value, FTables);
end;

function TMyServerControl.GetTableNamesStr: _string; // if TableNames is setted then return GetTableNames else return full tables list
begin
  Result := GetTableNames;
  if Result <> '' then
    Exit;

  GetTablesList(Connection, FTables);
  Result := TableNamesFromList(FTables);
  FTables.Clear;
end;

procedure TMyServerControl.Loaded;
begin
  inherited;

  FDesignCreate := False;
end;

procedure TMyServerControl.CreateDatabase(DatabaseName: string; IfNotExists: boolean = True; CharsetName: string =''; CollationName: string = '');
begin
  if IfNotExists then
    SQL.Text := 'CREATE DATABASE IF NOT EXISTS ' + DatabaseName
  else
    SQL.Text := 'CREATE DATABASE ' + DatabaseName;

  if CharsetName <> '' then
    SQL.Text := SQL.Text + ' CHARACTER SET ' + CharsetName;

  if CollationName <> '' then
    SQL.Text := SQL.Text + ' COLLATE ' + CollationName;

  Execute;
end;

procedure TMyServerControl.DropDatabase(DatabaseName: string; IfExists: boolean = True);
begin
  if IfExists then
    SQL.Text := 'DROP DATABASE IF EXISTS ' + DatabaseName
  else
    SQL.Text := 'DROP DATABASE ' + DatabaseName;

  Execute;
end;

procedure TMyServerControl.AnalyzeTable;
begin
  SQL.Text := 'ANALYZE TABLE ' + GetTableNamesStr;
  Execute;
end;

procedure TMyServerControl.OptimizeTable;
begin
  SQL.Text := 'OPTIMIZE TABLE ' + GetTableNamesStr;
  Execute;
end;

procedure TMyServerControl.CheckTable(CheckTypes: TMyCheckTypes = [ctMedium]);
var
  s: string;
begin
  s := '';
  if ctQuick in CheckTypes then
    s := 'QUICK ';
  if ctFast in CheckTypes then
    s := s + 'FAST ';
  if ctMedium in CheckTypes then
    s := s + 'MEDIUM ';
  if ctExtended in CheckTypes then
    s := s + 'EXTENDED ';
  if ctChanged in CheckTypes then
    s := s + 'CHANGED ';

  SQL.Text := 'CHECK TABLE ' + GetTableNamesStr + ' ' + s;
  Execute;
end;

procedure TMyServerControl.RepairTable(RepairTypes: TMyRepairTypes = []);
var
  s: string;
begin
  s := '';
  if rtQuick in RepairTypes then
    s := 'QUICK ';
  if rtExtended in RepairTypes then
    s := s + 'EXTENDED ';
  if rtUseFrm in RepairTypes then
    s := s + 'USE_FRM ';

  SQL.Text := 'REPAIR TABLE ' + GetTableNamesStr + ' ' + s;
  Execute;
end;

procedure TMyServerControl.ShowProcessList(Full: boolean = False);
begin
  if Full then
    SQL.Text := 'SHOW FULL PROCESSLIST'
  else
    SQL.Text := 'SHOW PROCESSLIST';
  Execute;
end;

procedure TMyServerControl.KillProcess(ThreadId: integer);
begin
  SQL.Text := 'KILL ' + IntToStr(ThreadId);
  Execute;
end;

procedure TMyServerControl.Flush(FlushTypes: TMyFlushTypes);
var
  s: string;

  procedure CheckType(const FlushType: TMyFlushType; const Opt: string);
  begin
    if not (FlushType in FlushTypes) then
      Exit;

    if s = '' then
      s := Opt
    else
      s := s + ', ' + Opt;
  end;


begin
  s := '';

  CheckType(foHosts, 'HOSTS');
  CheckType(foDesKeyFile, 'DES_KEY_FILE');
  CheckType(foLogs, 'LOGS');
  CheckType(foPrivileges, 'PRIVILEGES');
  CheckType(foQueryCache, 'QUERY CACHE');
  CheckType(foTables, 'TABLES ' + TableNames);
  CheckType(foStatus, 'STATUS');
  CheckType(foUserResources, 'USER_RESOURCES');

  SQL.Text := 'FLUSH ' + s;
  Execute;
end;

procedure TMyServerControl.ShowStatus;
begin
  SQL.Text := 'SHOW STATUS';
  Execute;
end;

procedure TMyServerControl.ShowVariables;
begin
  SQL.Text := 'SHOW VARIABLES';
  Execute;
end;

function TMyServerControl.GetVariables(const VarName: _string): _string;
begin
  SQL.Text := 'SHOW VARIABLES LIKE ''' + VarName + '''';
  Open;
  if RecordCount = 1 then
    Result := _VarToStr(FieldByName('Value').Value)
  else
    if RecordCount = 0 then
      DatabaseError(Format(sNoVariablesFound, [VarName]))
    else
      DatabaseError(sMultipleVariablesFound);
end;

Procedure TMyServerControl.SetVariables(const VarName: _string; Value: _string);
begin
  SQL.Text := _Format('SET %s = %s', [VarName, Value]);
  Execute;
end;

class procedure TMyServerControlUtils.SetDesignCreate(Obj: TMyServerControl; Value: boolean);
begin
  Obj.FDesignCreate := Value;
end;

class function TMyServerControlUtils.GetDesignCreate(Obj: TMyServerControl): boolean;
begin
  Result := Obj.FDesignCreate;
end;

{$IFDEF MSWINDOWS}
function TMyServerControl.GetServerName: string;
begin
  // Cannot use CheckConnection for stopped service
  if UsedConnection = nil then
    DatabaseError(SConnectionNotDefined);

  Result := Connection.Server;
end;

procedure TMyServerControl.GetServiceNames(List: TStrings);
var
  Services: TCRServicesInfo;
  i: integer;

  ServiceName, DisplayName: string;
  Status: TMyServiceStatus;

begin
  List.Clear;
  Services := TCRNetManager.GetServiceNames(GetServerName);

  for i := 0 to Length(Services) - 1 do begin
    ServiceName := Services[i].ServiceName;
    DisplayName := Services[i].DisplayName;
    Status := Services[i].Status;
    if (Pos('mysql', LowerCase(ServiceName)) <> 0) or (Pos('mysql', LowerCase(DisplayName)) <> 0) then
      List.AddObject(ServiceName, TObject(Integer(Status)));
  end;
end;

function TMyServerControl.ServiceStatus(const ServiceName: string): TMyServiceStatus;
begin
  Result := TCRNetManager.GetServiceStatus(GetServerName, ServiceName);
end;

procedure TMyServerControl.ServiceStart(const ServiceName: string; ParamStr: string = '');
begin
  TCRNetManager.ServiceStart(GetServerName, ServiceName, ParamStr);
end;

procedure TMyServerControl.ServiceStop(const ServiceName: string);
begin
  TCRNetManager.ServiceStop(GetServerName, ServiceName);
end;
{$ENDIF}

end.
