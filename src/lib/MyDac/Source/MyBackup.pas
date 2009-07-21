
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyBackup;
{$ENDIF}

interface

uses
  Classes, MemUtils, MyAccess, MyClasses;

const
  DefFieldsTerminatedBy = '\t';
  DefEnclosedBy = '';
  DefEscapedBy = '\\';
  DefLinesTerminatedBy = '\n';

type

{ TMyBackup }

  TMyBackupPriority = (bpDefault, bpLowPriority, bpConcurrent); // Define priority on restore table

  TMyRestoreDuplicates = (bdIgnore, bdReplace, bdError);

  TMyBackupMode = (bmBinary, bmText);

  TMyBackup = class;
  TMyTableMsgEvent = procedure (Sender: TObject; TableName: _string; MsgText: string) of object;

  TMyBackup = class(TComponent)
  protected
    FConnection: TCustomMyConnection;
    FQuery: TMyQuery;

    FMode: TMyBackupMode;
    FOnTableMsg: TMyTableMsgEvent;
    FDesignCreate: boolean;

    FTables: _TStringList;
    FFields: _string;
    FPath: string;

    FBackupPriority: TMyBackupPriority;
    FLocal: boolean; // Use local file
    FDuplicates: TMyRestoreDuplicates;

    // Separator properties
    FFieldsTerminatedBy: string;
    FEnclosedBy: string;
    FEscapedBy: string;
    FLinesTerminatedBy: string;

    // Restore
    FIgnoreLines: integer;

    procedure Notification(Component: TComponent; Operation: TOperation); override;
    procedure SetConnection(Value: TCustomMyConnection);
    procedure BeginConnection;
    procedure EndConnection;

    function GetDebug: boolean;
    procedure SetDebug(Value: boolean);
    function GetTableNames: _string;
    procedure SetTableNames(Value: _string);
    //function GetCommandTimeout: integer;
    //procedure SetCommandTimeout(Value: integer);

    procedure SendEvents;
    procedure Loaded; override;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    procedure Backup;
    procedure Restore;
    
  published
    property Connection: TCustomMyConnection read FConnection write SetConnection;
    property Debug: boolean read GetDebug write SetDebug default False;
    property TableNames: _string read GetTableNames write SetTableNames;
    //property CommandTimeout: integer read GetCommandTimeout write SetCommandTimeout;

    property Mode: TMyBackupMode read FMode write FMode default bmBinary;

    property Fields: _string read FFields write FFields;
    property Path: string read FPath write FPath;

    // Backup
    property BackupPriority: TMyBackupPriority read FBackupPriority write FBackupPriority default bpDefault;

    // Restore
    property Local: boolean read FLocal write FLocal default False; // Use local file
    property Duplicates: TMyRestoreDuplicates read FDuplicates write FDuplicates default bdError;
    property IgnoreLines: integer read FIgnoreLines write FIgnoreLines default 0;
    
    // Separator properties
    property FieldsTerminatedBy: string read FFieldsTerminatedBy write FFieldsTerminatedBy;
    property EnclosedBy: string read FEnclosedBy write FEnclosedBy;
    property EscapedBy: string read FEscapedBy write FEscapedBy;
    property LinesTerminatedBy: string read FLinesTerminatedBy write FLinesTerminatedBy;

    property OnTableMsg: TMyTableMsgEvent read FOnTableMsg write FOnTableMsg;
  end;

  TMyBackupUtils = class
  public
    class procedure SetDesignCreate(Obj: TMyBackup; Value: boolean);
    class function GetDesignCreate(Obj: TMyBackup): boolean;
  end;

implementation

uses
  DB, MyConsts, DAConsts, SysUtils, DBAccess, CRAccess, MyCall;

{ TMyBackup }


constructor TMyBackup.Create(Owner: TComponent);
begin
  inherited;

  FQuery := TMyQuery.Create(nil);
  FQuery.FetchAll := True;
  FQuery.ReadOnly := True;

  FFieldsTerminatedBy := DefFieldsTerminatedBy;
  FEnclosedBy := DefEnclosedBy;
  FEscapedBy := DefEscapedBy;
  FLinesTerminatedBy := DefLinesTerminatedBy;

  FBackupPriority := bpDefault;
  FDuplicates := bdError;

  FTables := _TStringList.Create;

  FDesignCreate := csDesigning in ComponentState;
end;

destructor TMyBackup.Destroy;
begin
  FQuery.Free;
  FTables.Free;
  inherited;
end;

procedure TMyBackup.Notification(Component: TComponent; Operation: TOperation);
begin
  if (Component = FConnection) and (Operation = opRemove) then
    Connection := nil;

  inherited;
end;

procedure TMyBackup.SetConnection(Value: TCustomMyConnection);
begin
  if Value <> FConnection then begin
    if FConnection <> nil then
      RemoveFreeNotification(FConnection);

    FConnection := Value;

    if FConnection <> nil then
      FreeNotification(FConnection);
  end;
end;

procedure TMyBackup.BeginConnection;
begin
  if FConnection = nil then
    DatabaseError(SConnectionNotDefined);
  TDBAccessUtils.InternalConnect(FConnection);
  FQuery.Connection := Connection;
end;

procedure TMyBackup.EndConnection;
begin
  TDBAccessUtils.InternalDisconnect(FConnection);
end;

function TMyBackup.GetDebug: boolean;
begin
  Result := FQuery.Debug;
end;

procedure TMyBackup.SetDebug(Value: boolean);
begin
  FQuery.Debug := Value;
end;

function TMyBackup.GetTableNames: _string;
begin
  Result := TableNamesFromList(FTables);
end;

procedure TMyBackup.SetTableNames(Value: _string);
begin
  TableNamesToList(Value, FTables);
end;

{function TMyBackup.GetCommandTimeout: integer;
begin
  Result := FQuery.CommandTimeout;
end;

procedure TMyBackup.SetCommandTimeout(Value: integer);
begin
  FQuery.CommandTimeout := Value;
end;}

function DuplicateBackSlash(const s: _string): _string;
var
  i: integer;
begin
  Result := '';

  for i := 1 to Length(s) do begin
    if (s[i] =  '/') or (s[i] =  '\') then
      Result := Result + '\\'
    else
      Result := Result + s[i];
  end;
end;


procedure TMyBackup.SendEvents;
var
  TableNameFld, MsgTypeFld, MsgTextFld: TStringField;
  Msg: string;
begin
  Msg := '';
  TableNameFld := FQuery.FieldByName('Table') as TStringField;
  MsgTypeFld := FQuery.FieldByName('Msg_type') as TStringField;
  MsgTextFld := FQuery.FieldByName('Msg_text') as TStringField;
  while not FQuery.Eof do begin
    if not ((MsgTypeFld.AsString = 'status') and (MsgTextFld.AsString = 'OK')) then begin
      if Msg <> '' then
        Msg := Msg + #$D#$A;
      Msg := Msg + Format(STableMsgEvent, [MsgTypeFld.AsString, TableNameFld.AsString, MsgTextFld.AsString]);
    end;
    FQuery.Next;
  end;

  if Msg <> '' then
    DatabaseError(Msg);
end;

{$IFDEF VER6P}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

procedure TMyBackup.Backup;
var
  TablesList: _TStringList;

  procedure BackupText;
    function GetFieldsString: _string;
    begin
      if Trim(Fields) = '' then
        Result := '*'
      else
        Result := Fields;
    end;

  var
    s: _string;

    TableName, FileName: _string;
    i: integer;
  begin
    for i := 0 to TablesList.Count - 1 do begin
      TableName := BracketIfNeed(TablesList[i]);
      FileName := DuplicateBackSlash(IncludeTrailingBackslash(Path) + TableName);

      s :=
        'SELECT ' + GetFieldsString + ' INTO OUTFILE "' + FileName + '"'#$D#$A +
        'FIELDS TERMINATED BY "' + FFieldsTerminatedBy + '" OPTIONALLY ENCLOSED BY "' + FEnclosedBy + '"'#$D#$A +
        'LINES TERMINATED BY "' + FLinesTerminatedBy + '"'#$D#$A +
        'FROM ' + BracketIfNeed(TableName);

      FQuery.SQL.Text := s;
      FQuery.Execute;
    end;
  end;

  procedure BackupBinary;
  var
    TableNames: _string;
    i: integer;
  begin
    TableNames := '';
    for i := 0 to TablesList.Count - 1 do begin
      if i = 0 then
        TableNames := BracketIfNeed(TablesList[i])
      else
        TableNames := TableNames + ', ' + BracketIfNeed(TablesList[i]);
      TableNames := TableNames + ' READ';
    end;

    FQuery.SQL.Text := 'LOCK TABLES ' + TableNames;
    FQuery.Execute;
    try
      TableNames := TableNamesFromList(TablesList);
      FQuery.SQL.Text := 'FLUSH TABLES ' + TableNames;
      FQuery.Execute;

      FQuery.SQL.Text := 'BACKUP TABLE ' + TableNames + ' TO "' + DuplicateBackSlash(IncludeTrailingBackslash(Path)) + '"';
      FQuery.Execute;

      SendEvents;
    finally
      FQuery.SQL.Text := 'UNLOCK TABLES';
      FQuery.Execute;
    end;
  end;

begin
  BeginConnection;
  try
    TablesList := _TStringList.Create;
    try
      if FTables.Count = 0 then
        GetTablesList(Connection, TablesList)
      else
        TablesList.Assign(FTables);

      if Mode = bmText then
        BackupText
      else
        BackupBinary;

    finally
      TablesList.Free;
    end;
  finally
    EndConnection;
  end;

end;

procedure TMyBackup.Restore;
var
  TablesList: _TStringList;

  procedure RestoreText;
    function GetPriorityString: string;
    begin
      case FBackupPriority of
        bpDefault:
          Result := '';
        bpLowPriority:
          Result := 'LOW_PRIORITY ';
        bpConcurrent:
          Result := 'CONCURRENT ';
      end;
    end;

    function GetLocalString: string;
    begin
      if FLocal then
        Result := 'LOCAL '
      else
        Result := '';
    end;

    function GetDupString: string;
    begin
      case FDuplicates of
        bdIgnore:
          Result := 'IGNORE ';
        bdReplace:
          Result := 'REPLACE ';
        bdError:
          Result := '';
      end;
    end;

    function GetFieldsString: _string;
    begin
      if Trim(Fields) = '' then
        Result := ''
      else
        Result := '(' + Fields + ')';
    end;

  var
    s: _string;

    TableName, FileName: _string;
    i: integer;
  begin
    for i := 0 to TablesList.Count - 1 do begin
      TableName := BracketIfNeed(TablesList[i]);
      FileName := DuplicateBackSlash(IncludeTrailingBackslash(Path) + TableName);

      s :=
        'LOAD DATA ' + GetPriorityString + GetLocalString + 'INFILE "' + FileName + '"'#$D#$A +
        GetDupString + 'INTO TABLE ' + BracketIfNeed(TableName) + #$D#$A +
        'FIELDS TERMINATED BY "' + FFieldsTerminatedBy + '" OPTIONALLY ENCLOSED BY "' + FEnclosedBy + '" ESCAPED BY "' + FEscapedBy + '"'#$D#$A +
        'LINES TERMINATED BY "' + FLinesTerminatedBy + '"'#$D#$A;

      if FIgnoreLines <> 0 then
        s := s + 'IGNORE ' + IntToStr(FIgnoreLines) + ' LINES'#$D#$A;

      s := s + GetFieldsString;

      FQuery.SQL.Text := s;
      FQuery.Execute;

      if Assigned(FOnTableMsg) then
        FOnTableMsg(Self, TableName, FConnection.GetExecuteInfo);
    end;
  end;

  procedure RestoreBinary;
  begin
    FQuery.SQL.Text := 'RESTORE TABLE ' + TableNamesFromList(TablesList) + ' FROM "' + DuplicateBackSlash(IncludeTrailingBackslash(Path)) + '"';
    FQuery.Execute;

    SendEvents;
  end;

begin
  BeginConnection;
  try
    TablesList := _TStringList.Create;
    try
      if FTables.Count = 0 then
        GetTablesList(Connection, TablesList)
      else
        TablesList.Assign(FTables);

      if Mode = bmText then
        RestoreText
      else
        RestoreBinary;

    finally
      TablesList.Free;
    end;
  finally
    EndConnection;
  end;
end;

class procedure TMyBackupUtils.SetDesignCreate(Obj: TMyBackup; Value: boolean);
begin
  Obj.FDesignCreate := Value;
end;

class function TMyBackupUtils.GetDesignCreate(Obj: TMyBackup): boolean;
begin
  Result := Obj.FDesignCreate;
end;

procedure TMyBackup.Loaded;
begin
  inherited;
  FDesignCreate := False;
end;

end.
