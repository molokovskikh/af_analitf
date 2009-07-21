
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit DADump;
{$ENDIF}

interface

uses
{$IFDEF VER6P}
  Variants,
{$ENDIF}
  SysUtils, Classes, DB, MemUtils, CRAccess, DBAccess, DAScript;

type
  TDADump = class;
  TDADumpProcessor = class;
  TDADumpProcessorClass = class of TDADumpProcessor;

  TDABackupProgressEvent = procedure (Sender: TObject; ObjectName: _string; ObjectNum, ObjectCount, Percent: integer) of object;
  TDARestoreProgressEvent = procedure (Sender: TObject; Percent: integer) of object;

  TDADumpOptions = class(TPersistent)
  protected
    FOwner: TDADump;
    FGenerateHeader: boolean;
    FAddDrop: boolean;
    FQuoteNames: boolean;
    FCompleteInsert: boolean;
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Owner: TDADump);
  published
    property GenerateHeader: boolean read FGenerateHeader write FGenerateHeader default True;
    property AddDrop: boolean read FAddDrop write FAddDrop default True;
    property QuoteNames: boolean read FQuoteNames write FQuoteNames default False;
    property CompleteInsert: boolean read FCompleteInsert write FCompleteInsert default False;
  end;

  TDADumpProcessor = class
  protected
    FOwner: TDADump;
    FLeftQuote: _char;
    FRightQuote: _char;
    FQuery: TCustomDADataSet;

    function GetConnection: TCustomDAConnection;
    function GetSQL: _TStrings;
    function GetTables: _TStringList;

    procedure Add(const Line: _string); overload; // Line must be w/o #$D#$A
    procedure Add(const sl: _TStringList); overload;
    procedure AddLineToSQL(const Line: _string); overload; // Line may contains #$D#$A
    procedure AddLineToSQL(const Line: _string; const Args: array of const); overload;

    procedure Backup(Query: _string); virtual;
    procedure CheckTables(const QueryText: _string); virtual;
    procedure AddHeader;
    function CreateQuery: TCustomDADataSet; virtual;
    procedure CheckQuery;
    procedure AddSettings; virtual;
    procedure RestoreSettings; virtual;
    procedure BackupObjects(const QueryText: _string); virtual;
    procedure BackupData(const TableName, QueryText: _string; TableNum, TableCount: integer); virtual;

    procedure DoBackupProgress(ObjectName: _string; ObjectNum, ObjectCount, Percent: integer);
    function GetTableInfoClass: TTableInfoClass; virtual;
    function QuoteName(const AName: _string): _string; virtual;
  public
    constructor Create(Owner: TDADump); virtual;
    destructor Destroy; override;

    function SetProp(Prop: integer; const Value: variant): boolean; virtual;
    function GetProp(Prop: integer; var Value: variant): boolean; virtual;
  end;

  TDADump = class(TComponent)
  protected
    FProcessor: TDADumpProcessor;
    FConnection: TCustomDAConnection;
    FSQL: _TStrings;
    FStream: TStream;
    FOptions: TDADumpOptions;
    FDebug: boolean;
    FDesignCreate: boolean;
    FTables: _TStringList;

    FOnBackupProgress: TDABackupProgressEvent;
    FOnRestoreProgress: TDARestoreProgressEvent;
    FOnError: TOnErrorEvent;

    function GetProcessorClass: TDADumpProcessorClass; virtual;
    procedure SetProcessor(Value: TDADumpProcessor); virtual;
    procedure CreateProcessor;
    procedure FreeProcessor;
    procedure CheckProcessor;

    procedure AssignTo(Dest: TPersistent); override;
    function GetTableNames: _string; virtual;
    procedure SetTableNames(Value: _string); virtual;

    function CreateOptions: TDADumpOptions; virtual;
    function CreateScript: TDAScript; virtual;

    procedure Notification(Component: TComponent; Operation: TOperation); override;
    procedure SetConnection(Value: TCustomDAConnection);
    procedure BeginConnection; virtual;
    procedure EndConnection;

    procedure SetSQL(Value: _TStrings);
    procedure SetOptions(Value: TDADumpOptions);

    procedure Loaded; override;

    procedure InternalBackup(Query: _string);
    function GenerateHeader: _string; virtual; abstract;

    property Processor: TDADumpProcessor read FProcessor;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    procedure Backup;
    procedure BackupToStream(Stream: TStream; const Query: _string = '');
    procedure BackupToFile(const FileName: string; const Query: _string = '');
    procedure BackupQuery(const Query: _string);
    procedure Restore;
    procedure RestoreFromStream(Stream: TStream);
    procedure RestoreFromFile(const FileName: string);

    property Connection: TCustomDAConnection read FConnection write SetConnection;
    property Options: TDADumpOptions read FOptions write SetOptions;
  published
    property TableNames: _string read GetTableNames write SetTableNames;
    property SQL: _TStrings read FSQL write SetSQL;
    property Debug: boolean read FDebug write FDebug default False;

    property OnBackupProgress: TDABackupProgressEvent read FOnBackupProgress write FOnBackupProgress;
    property OnRestoreProgress: TDARestoreProgressEvent read FOnRestoreProgress write FOnRestoreProgress;
    property OnError: TOnErrorEvent read FOnError write FOnError;
  end;

  TDADumpUtils = class
  public
    class procedure SetDesignCreate(Obj: TDADump; Value: boolean);
    class function GetDesignCreate(Obj: TDADump): boolean;
  end;

implementation

uses
  DAConsts;

{ TDADumpOptions }

constructor TDADumpOptions.Create(Owner: TDADump);
begin
  inherited Create;

  FOwner := Owner;
  FGenerateHeader := True;
  FAddDrop := True;
  FQuoteNames := False;
end;

procedure TDADumpOptions.AssignTo(Dest: TPersistent);
begin
  if Dest is TDADumpOptions then begin
    TDADumpOptions(Dest).GenerateHeader := GenerateHeader;
    TDADumpOptions(Dest).AddDrop := AddDrop;
    TDADumpOptions(Dest).QuoteNames := QuoteNames;
    TDADumpOptions(Dest).CompleteInsert := CompleteInsert;
  end
  else
    inherited;
end;

{ TDADumpProcessor }

constructor TDADumpProcessor.Create(Owner: TDADump);
begin
  inherited Create;

  FOwner := Owner;
  FLeftQuote := '"';
  FRightQuote := '"';
end;

destructor TDADumpProcessor.Destroy;
begin
  FQuery.Free;

  inherited;
end;

function TDADumpProcessor.GetProp(Prop: integer; var Value: variant): boolean;
begin
  Assert(False, IntToStr(Prop));
  Result := False;
end;

function TDADumpProcessor.SetProp(Prop: integer; const Value: variant): boolean;
begin
  Assert(False, IntToStr(Prop));
  Result := False;
end;

function TDADumpProcessor.GetConnection: TCustomDAConnection;
begin
  Result := FOwner.FConnection;
end;

function TDADumpProcessor.GetSQL: _TStrings;
begin
  Result := FOwner.FSQL;
end;

function TDADumpProcessor.GetTables: _TStringList;
begin
  Result := FOwner.FTables;
end;

procedure TDADumpProcessor.Add(const Line: _string);  // Line must be w/o #$D#$A
var
  s: AnsiString;
begin
  if FOwner.FStream = nil then
    FOwner.FSQL.Add(Line)
  else
  begin
    s := AnsiString(Line + #$D#$A);
    FOwner.FStream.WriteBuffer(s[1], Length(s));
  end;
end;

procedure TDADumpProcessor.Add(const sl: _TStringList);
var
  i: integer;
begin
  for i := 0 to sl.Count - 1 do
    Add(sl[i]);
end;

procedure TDADumpProcessor.AddLineToSQL(const Line: _string); // Line may contains #$D#$A
var
  sl: _TStringList;
begin
  sl := _TStringList.Create;
  try
    sl.Text := Line;
    Add(sl);
  finally
    sl.Free;
  end;
end;

procedure TDADumpProcessor.AddLineToSQL(const Line: _string; const Args: array of const);
begin
  AddLineToSQL(_Format(Line, Args));
end;

procedure TDADumpProcessor.AddHeader;
begin
  if FOwner.Options.GenerateHeader then
    AddLineToSQL(FOwner.GenerateHeader);
end;

procedure TDADumpProcessor.Backup(Query: _string);
begin
  Query := Trim(Query);
  CheckTables(Query);

  GetSQL.BeginUpdate;
  try
    GetSQL.Clear;
    AddHeader;
    AddSettings;

    BackupObjects(Query);

    RestoreSettings;
  finally
    GetSQL.EndUpdate;
  end;
end;

procedure TDADumpProcessor.CheckTables(const QueryText: _string);
begin
  if (QueryText <> '') and (GetTables.Count > 1) then
    raise Exception.Create(SWrongTblCount);
end;

function TDADumpProcessor.CreateQuery: TCustomDADataSet;
begin
  Result := GetConnection.CreateDataSet;
end;

procedure TDADumpProcessor.CheckQuery;
begin
  if FQuery = nil then
    FQuery := CreateQuery;
end;

procedure TDADumpProcessor.AddSettings;
begin
end;

procedure TDADumpProcessor.RestoreSettings;
begin
end;

procedure TDADumpProcessor.BackupObjects(const QueryText: _string);
var
  i: integer;
  TableName: _string;
  TablesList: _TStringList;
begin
  CheckQuery;
  if QueryText <> '' then
    BackupData('', QueryText, 1, 1)
  else begin
    TablesList := _TStringList.Create;
    try
      if GetTables.Count = 0 then
        GetConnection.GetTableNames(TablesList)
      else
        TablesList.Assign(GetTables);

      for i := 0 to TablesList.Count - 1 do begin
        TableName := QuoteName(TablesList[i]);
        BackupData(TableName, QueryText, i + 1, TablesList.Count);
      end;
    finally
      TablesList.Free;
    end;
  end;
end;

procedure TDADumpProcessor.BackupData(const TableName, QueryText: _string;
  TableNum, TableCount: integer);
var
  Query: TCustomDADataSet;
  i: integer;
  TblName, FieldList, Sql, Header: _string;
  TablesInfo: TCRTablesInfo;
begin
  Query := CreateQuery;
  try
    TDBAccessUtils.CheckConnection(Query);
    TDBAccessUtils.GetIRecordSet(Query).SetProp(prFieldsAsString, True);

    if QueryText <> '' then
      Query.SQL.Text := QueryText
    else
      Query.SQL.Text := 'SELECT * FROM ' + TableName;
    Query.Open;

    if TableName = '' then begin
      TablesInfo := TDBAccessUtils.GetTablesInfo(Query);
      if TablesInfo.Count <> 1 then
        raise Exception.Create(SBackupQueryWrongTableCount);
      TblName := QuoteName(TablesInfo[0].TableName);
    end
    else
      TblName := TableName;

    Add('');
    if FOwner.Options.AddDrop then
      Add('DELETE FROM ' + TblName + ';');

    if Query.RecordCount = 0 then
      exit;

    Header := 'INSERT INTO ' + TblName;
    if FOwner.Options.CompleteInsert then begin
      FieldList := '';
      for i := 0 to Query.Fields.Count - 1 do begin
        if i > 0 then
          FieldList := FieldList + ', ';
        FieldList := FieldList + QuoteName(Query.Fields[i].FieldName);
      end;
      Header := Header + '(' + FieldList + ')';
    end;
    Header := Header + ' VALUES (';

    while not Query.Eof do begin
      Sql := '';
      for i := 0 to Query.Fields.Count - 1 do begin
        if i > 0 then
          Sql := Sql + ', ';
        if Query.Fields[i].IsNull then
          Sql := Sql + 'NULL'
        else begin
          Sql := Sql + AnsiQuotedStr(Query.Fields[i].AsString, '''');
        end;
      end;
      Sql := Header + Sql + ');';
      Add(Sql);

      DoBackupProgress(TblName, TableNum, TableCount, Trunc((Query.RecNo / Query.RecordCount) * 100));

      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

procedure TDADumpProcessor.DoBackupProgress(ObjectName: _string; ObjectNum, ObjectCount, Percent: integer);
begin
  if Assigned(FOwner.FOnBackupProgress) then
    FOwner.FOnBackupProgress(FOwner, ObjectName, ObjectNum, ObjectCount, Percent);
end;

function TDADumpProcessor.GetTableInfoClass: TTableInfoClass;
begin
  Result := TCRTableInfo;
end;

function TDADumpProcessor.QuoteName(const AName: _string): _string;
begin
  Result := GetTableInfoClass.NormalizeName(AName, FLeftQuote, FRightQuote, FOwner.Options.QuoteNames);
end;

{ TDADump }

constructor TDADump.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FDesignCreate := csDesigning in ComponentState;
  FOptions := CreateOptions;
  FSQL := _TStringList.Create;
  FTables := _TStringList.Create;
end;

destructor TDADump.Destroy;
begin
  FTables.Free;
  FSQL.Free;
  FOptions.Free;
  FProcessor.Free;

  inherited;
end;

function TDADump.GetProcessorClass: TDADumpProcessorClass;
begin
  Assert(False);
  Result := TDADumpProcessor;
end;

procedure TDADump.SetProcessor(Value: TDADumpProcessor);
begin
  if Value <> FProcessor then begin
    FreeProcessor;

    FProcessor := Value;
  end;
end;

procedure TDADump.CheckProcessor;
begin
  if not (FProcessor is GetProcessorClass) then begin
    FreeProcessor;
    CreateProcessor;
  end;
end;

procedure TDADump.CreateProcessor;
begin
  SetProcessor(GetProcessorClass.Create(Self));
end;

procedure TDADump.FreeProcessor;
begin
  FProcessor.Free;
  FProcessor := nil;
end;

procedure TDADump.AssignTo(Dest: TPersistent);
begin
  if Dest is TDADump then begin
    TDADump(Dest).TableNames := TableNames;
    TDADump(Dest).Connection := Connection;
    TDADump(Dest).SQL.Text := SQL.Text;
    TDADump(Dest).Debug := Debug;
    TDADump(Dest).Options := Options;
  end
  else
    inherited;
end;

function TDADump.GetTableNames: _string;
begin
  Result := '';
  Assert(False);
end;

procedure TDADump.SetTableNames(Value: _string);
begin
  Assert(False);
end;

function TDADump.CreateOptions: TDADumpOptions;
begin
  Result := TDADumpOptions.Create(Self);
end;

function TDADump.CreateScript: TDAScript;
begin
  Result := TDAScript.Create(nil);
end;

procedure TDADump.Notification(Component: TComponent; Operation: TOperation);
begin
  if (Component = FConnection) and (Operation = opRemove) then
    Connection := nil;

  inherited;
end;

procedure TDADump.SetConnection(Value: TCustomDAConnection);
begin
  if Value <> FConnection then begin
    if FConnection <> nil then
      RemoveFreeNotification(FConnection);

    FConnection := Value;

    if FConnection <> nil then
      FreeNotification(FConnection);
  end;
end;

procedure TDADump.BeginConnection;
begin
  if FConnection = nil then
    raise Exception.Create(SConnectionNotDefined);
  TDBAccessUtils.InternalConnect(FConnection);
end;

procedure TDADump.EndConnection;
begin
  TDBAccessUtils.InternalDisconnect(FConnection);
end;

procedure TDADump.SetSQL(Value: _TStrings);
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

procedure TDADump.SetOptions(Value: TDADumpOptions);
begin
  FOptions.Assign(Value);
end;

procedure TDADump.Loaded;
begin
  inherited;

  FDesignCreate := False;
end;

procedure TDADump.InternalBackup(Query: _string);
begin
  BeginConnection;
  try
    CheckProcessor;
    FProcessor.Backup(Query);
  finally
    EndConnection;
  end;
end;

procedure TDADump.Backup;
begin
  InternalBackup('');
end;

procedure TDADump.BackupToStream(Stream: TStream; const Query: _string = '');
begin
  FStream := Stream;
  try
    InternalBackup(Query);
  finally
    FStream := nil;
  end;
end;

procedure TDADump.BackupToFile(const FileName: string; const Query: _string = '');
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    BackupToStream(Stream, Query);
  finally
    Stream.Free;
  end;
end;

procedure TDADump.BackupQuery(const Query: _string);
var
  OldTables: _TStringList;
begin
  if Trim(Query) = '' then
    raise EDatabaseError.Create(SEmptySQLStatement);

  OldTables := _TStringList.Create;
  OldTables.Assign(FTables);
  FTables.Clear;
  try
    InternalBackup(Query);
  finally
    FTables.Assign(OldTables);
    OldTables.Free;
  end;
end;

procedure TDADump.Restore;
var
  Script: TDAScript;
  Len: integer;
begin
  Script := CreateScript;
  try
    Script.Connection := Connection;
    Script.Debug := Debug;
    Script.SQL := SQL;
    Len := Length(SQL.Text);
    Script.OnError := OnError; 

    while Script.ExecuteNext do
      if Assigned(FOnRestoreProgress) and (Len > 0) then
        FOnRestoreProgress(Self, Trunc((Script.StartPos / Len) * 100{"*" after "/" to prevent IntOverflow}));
  finally
    Script.Free;
  end;
end;

procedure TDADump.RestoreFromStream(Stream: TStream);
const
  BlockSize = 64 * 1024;
var
  Script: TDAScript;
  TotalCount: Int64;
begin
  Script := CreateScript;
  try
    TotalCount := Stream.Size;
    Script.Connection := Connection;
    Script.Debug := Debug;
    Script.OnError := OnError;
    TDAScriptUtils.Open(Script, Stream);
    try
      while Script.ExecuteNext do
        if Assigned(FOnRestoreProgress) and (TotalCount > 0) then
           FOnRestoreProgress(Self, Trunc((Script.StartPos / TotalCount) * 100{"*" after "/" to prevent IntOverflow}));
    finally
      TDAScriptUtils.Close(Script);
    end;
  finally
    Script.Free;
  end;
end;

procedure TDADump.RestoreFromFile(const FileName: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    RestoreFromStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

{ TDADumpUtils }

class procedure TDADumpUtils.SetDesignCreate(Obj: TDADump; Value: boolean);
begin
  Obj.FDesignCreate := Value;
end;

class function TDADumpUtils.GetDesignCreate(Obj: TDADump): boolean;
begin
  Result := Obj.FDesignCreate;
end;

end.
