
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyDump;
{$ENDIF}

interface

uses
  Classes, MemUtils, DADump, DAScript, CRAccess, MyAccess, MyClasses, MyServices;

type
  TMyDump = class;

  TMyDumpObject = (doDatabase, doUsers, doStoredProcs, doTables, doData, doViews);
  TMyDumpObjects = set of TMyDumpObject;

  TMyDumpOptions = class(TDADumpOptions)
  private
    FOwner: TMyDump;
    FAddLock: boolean;
    FDisableKeys: boolean;
    FHexBlob: boolean;
    FUseExtSyntax: boolean;
    FUseDelayedIns: boolean;

    procedure SetAddLock(const Value: boolean);
    procedure SetDisableKeys(const Value: boolean);
    procedure SetHexBlob(const Value: boolean);
    procedure SetUseDelayedIns(const Value: boolean);
    procedure SetUseExtSyntax(const Value: boolean);

  protected
    procedure AssignTo(Dest: TPersistent); override;

  public
    constructor Create(Owner: TDADump);

  published
    property AddLock: boolean read FAddLock write SetAddLock default True;
    property DisableKeys: boolean read FDisableKeys write SetDisableKeys default False;
    property HexBlob: boolean read FHexBlob write SetHexBlob default False;
    property UseExtSyntax: boolean read FUseExtSyntax write SetUseExtSyntax default True;
    property UseDelayedIns: boolean read FUseDelayedIns write SetUseDelayedIns default False;
  end;

  TMyDumpProcessor = class(TCustomMyDumpProcessor)
  private
    FOwner: TMyDump;
  protected
    procedure BackupObjects(const Query: _string); override;
  public
    constructor Create(Owner: TDADump); override;
  end;

  TMyDump = class(TDADump)
  protected
    FObjects: TMyDumpObjects;

    FStoredProcs: _TStringList;

    procedure AssignTo(Dest: TPersistent); override;

    function GetProcessorClass: TDADumpProcessorClass; override;
    procedure SetProcessor(Value: TDADumpProcessor); override;

    function CreateOptions: TDADumpOptions; override;
    function CreateScript: TDAScript; override;

    function GetConnection: TCustomMyConnection;
    procedure SetConnection(Value: TCustomMyConnection);

    function GetOptions: TMyDumpOptions;
    procedure SetOptions(const Value: TMyDumpOptions);

    function GetTableNames: _string; override;
    procedure SetTableNames(Value: _string); override;

    function GetStoredProcNames: _string;
    procedure SetStoredProcNames(Value: _string);
    procedure SetObjects(Value: TMyDumpObjects);

    function GenerateHeader: _string; override;

    property Processor;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    // procedure RestoreFromStream(Stream: TStream);

  published
    property Connection: TCustomMyConnection read GetConnection write SetConnection;
    property StoredProcNames: _string read GetStoredProcNames write SetStoredProcNames;

    property Objects: TMyDumpObjects read FObjects write SetObjects default [doTables, doViews, doData];
    property Options: TMyDumpOptions read GetOptions write SetOptions;
  end;

implementation

uses
{$IFDEF CLR}
  System.Text, System.Runtime.InteropServices,
{$ELSE}
  CLRClasses,
{$ENDIF}
  {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF},
  MyCall, MemData, MyScript, DBAccess, DALoader, MyLoader, DB, SysUtils, MyConsts, DAConsts{$IFDEF VER6P}, Variants{$ENDIF};

{ TMyDumpOptions }

constructor TMyDumpOptions.Create(Owner: TDADump);
begin
  inherited Create(Owner);

  FOwner := TMyDump(Owner);
  FAddLock := True;
  FUseExtSyntax := True;
  FUseDelayedIns := False;
  FGenerateHeader := True;
end;

procedure TMyDumpOptions.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TMyDumpOptions then begin
    TMyDumpOptions(Dest).AddLock := AddLock;
    TMyDumpOptions(Dest).DisableKeys := DisableKeys;
    TMyDumpOptions(Dest).UseExtSyntax := UseExtSyntax;
    TMyDumpOptions(Dest).UseDelayedIns := UseDelayedIns;
    TMyDumpOptions(Dest).HexBlob := HexBlob;
  end
end;

procedure TMyDumpOptions.SetAddLock(const Value: boolean);
begin
  if Value <> FAddLock then begin
    FAddLock := Value;
    if FOwner.Processor <> nil then
      FOwner.Processor.SetProp(prAddLock, Value);
  end;
end;

procedure TMyDumpOptions.SetDisableKeys(const Value: boolean);
begin
  if Value <> FDisableKeys then begin
    FDisableKeys := Value;
    if FOwner.Processor <> nil then
      FOwner.Processor.SetProp(prDisableKeys, Value);
  end;
end;

procedure TMyDumpOptions.SetHexBlob(const Value: boolean);
begin
  if Value <> FHexBlob then begin
    FHexBlob := Value;
    if FOwner.Processor <> nil then
      FOwner.Processor.SetProp(prHexBlob, Value);
  end;
end;

procedure TMyDumpOptions.SetUseDelayedIns(const Value: boolean);
begin
  if Value <> FUseDelayedIns then begin
    FUseDelayedIns := Value;
    if FOwner.Processor <> nil then
      FOwner.Processor.SetProp(prUseDelayedIns, Value);
  end;
end;

procedure TMyDumpOptions.SetUseExtSyntax(const Value: boolean);
begin
  if Value <> FUseExtSyntax then begin
    FUseExtSyntax := Value;
    if FOwner.Processor <> nil then
      FOwner.Processor.SetProp(prUseExtSyntax, Value);
  end;
end;

{ TMyDumpProcessor }

constructor TMyDumpProcessor.Create(Owner: TDADump);
begin
  inherited;

  FOwner := TMyDump(Owner);
end;

procedure TMyDumpProcessor.BackupObjects(const Query: _string);

  procedure BackupDatabase;
  var
    Database: _string;
  begin
    Database := QuoteName(FOwner.Connection.Database);

    if FOwner.Options.GenerateHeader then
      AddLineToSQL(SBHDatabase, [Database]);

    if FOwner.Options.AddDrop then begin
      Add('USE mysql;');
      Add('DROP DATABASE IF EXISTS ' + Database + ';');
    end;

    Add('CREATE DATABASE ' + Database + ';');
    Add('USE ' + Database + ';');

    Add('');
  end;

  procedure BackupUsers;
  var
    UsersList: _TStringList;

    procedure FillUsersList;
    var
      UserField, HostField: TStringField;
      User, Host: _string;
    begin
      UsersList.Clear;
      FQuery.SQL.Text := 'SELECT * FROM mysql.user';
      FQuery.Execute;

      UserField := FQuery.FieldByName('User') as TStringField;
      HostField := FQuery.FieldByName('Host') as TStringField;
      while not FQuery.Eof do begin
        User := BracketIfNeed(UserField.AsString);
        Host := BracketIfNeed(HostField.AsString);
        if User = '' then
          User := '``';
        if Host = '' then
          Host := '``';
        UsersList.Add(User + '@' + Host);
        FQuery.Next;
      end;
    end;

  var
    i: integer;

  begin
    if FOwner.Options.GenerateHeader then
      AddLineToSQL(SBHUsers);

    UsersList := _TStringList.Create;
    try
      FillUsersList;

      {
      if Options.AddDrop then
      begin
        for i := 0 to UsersList.Count - 1 do
          FSQL.Add('REVOKE ALL ON ' + BracketIfNeed(FConnection.Database) + '.* FROM ' + UsersList[i] + ';');
        FSQL.Add('');
      end;
      }

      for i := 0 to UsersList.Count - 1 do begin
        FQuery.SQL.Text := 'SHOW GRANTS FOR ' + UsersList[i];
        FQuery.Execute;
        AddLineToSQL(FQuery.Fields[0].AsString + ';');
      end;

    finally
      UsersList.Free;
    end;
    Add('');
  end;

  procedure BackupSP;
    procedure BackupStoredProc(StoredProcName: _string);
    var
      s: _string;
      PorF: _string;

    begin
      FQuery.SQL.Text := 'SELECT type FROM mysql.proc WHERE (name = ''' + Unbracket(StoredProcname) + ''') AND (LOWER(db) = ''' + AnsiLowerCase(FOwner.Connection.Database) + ''')';
      FQuery.Execute;
      PorF := FQuery.Fields[0].AsString;

      if FOwner.Options.GenerateHeader then
        AddLineToSQL(SBHStoredProcStruct, [StoredProcName]);

      Add('DELIMITER $$');
      if FOwner.Options.AddDrop then
        Add('DROP ' + PorF + ' IF EXISTS ' + QuoteName(StoredProcName) + ' $$');

      FQuery.SQL.Text := 'SHOW CREATE ' + PorF + ' ' + StoredProcName;
      FQuery.Execute;

      s := FQuery.Fields[2].AsString + ' $$';
    {$IFDEF CLR}
      s := StringReplace(s, #$A, LineSeparator, [rfReplaceAll]);
    {$ENDIF}
      AddLineToSQL(s);
      Add('DELIMITER ;');
      Add('');
    end;

  var
    i: integer;
    StoredProcsList: _TStringList;
    StoredProcName: _string;

  begin
    StoredProcsList := nil;
    try
      StoredProcsList := _TStringList.Create;

      if FOwner.FStoredProcs.Count = 0 then
        FOwner.Connection.GetStoredProcNames(StoredProcsList)
      else
        StoredProcsList.Assign(FOwner.FStoredProcs);

      for i := 0 to StoredProcsList.Count - 1 do begin
        StoredProcName := BracketIfNeed(StoredProcsList[i]);

        DoBackupProgress(StoredProcName, i, StoredProcsList.Count, 0);

        BackupStoredProc(StoredProcName);
        Add('');
      end;

    finally
      StoredProcsList.Free;
    end;
  end;

begin
  CheckQuery;

  if doDatabase in FOwner.Objects then
    BackupDatabase;

  if doUsers in FOwner.Objects then
    BackupUsers;

  if doStoredProcs in FOwner.Objects then
    BackupSP;

  inherited;
end;

{ TMyDump }

constructor TMyDump.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FObjects := [doTables, doViews, doData];
  FStoredProcs := _TStringList.Create;
end;

destructor TMyDump.Destroy;
begin
  FStoredProcs.Free;
  
  inherited;
end;

function TMyDump.GetConnection: TCustomMyConnection;
begin
  Result := TCustomMyConnection(inherited Connection);
end;

procedure TMyDump.SetConnection(Value: TCustomMyConnection);
begin
  inherited Connection := Value;
end;

procedure TMyDump.AssignTo(Dest: TPersistent);
begin
  inherited;

  if Dest is TMyDump then begin
    TMyDump(Dest).Objects := Objects;
    TMyDump(Dest).StoredProcNames := StoredProcNames;
  end;
end;

function TMyDump.GetProcessorClass: TDADumpProcessorClass;
begin
  Result := TMyDumpProcessor;
end;

procedure TMyDump.SetProcessor(Value: TDADumpProcessor);
begin
  inherited;

  if FProcessor <> nil then begin
    FProcessor.SetProp(prBackupTables, doTables in FObjects);
    FProcessor.SetProp(prBackupViews, doViews in Objects);
    FProcessor.SetProp(prBackupData, doData in Objects);

    FProcessor.SetProp(prAddLock, Options.AddLock);
    FProcessor.SetProp(prDisableKeys, Options.DisableKeys);
    FProcessor.SetProp(prHexBlob, Options.HexBlob);
    FProcessor.SetProp(prUseExtSyntax, Options.UseExtSyntax);
    FProcessor.SetProp(prUseDelayedIns, Options.UseDelayedIns);
  end;
end;

function TMyDump.GenerateHeader: _string;
begin
  Result := _Format(MyConsts.SBHCaption, [MyDACVersion, Connection.ServerVersion,
    Connection.ClientVersion, DateTimeToStr(Now), Connection.Server, Connection.Database]);
end;

function TMyDump.CreateOptions: TDADumpOptions;
begin
  Result := TMyDumpOptions.Create(Self);
end;

function TMyDump.CreateScript: TDAScript;
begin
  Result := TMyScript.Create(nil);
end;

function TMyDump.GetOptions: TMyDumpOptions;
begin
  Result := TMyDumpOptions(inherited Options);
end;

procedure TMyDump.SetOptions(const Value: TMyDumpOptions);
begin
  inherited Options := Value;
end;

function TMyDump.GetTableNames: _string;
begin
  Result := TableNamesFromList(FTables);
end;

procedure TMyDump.SetTableNames(Value: _string);
begin
  TableNamesToList(Value, FTables);
end;

function TMyDump.GetStoredProcNames: _string;
begin
  Result := TableNamesFromList(FStoredProcs);
end;

procedure TMyDump.SetStoredProcNames(Value: _string);
begin
  TableNamesToList(Value, FStoredProcs);
end;

procedure TMyDump.SetObjects(Value: TMyDumpObjects);
begin
  if Value <> FObjects then begin
    FObjects := Value;
    if FProcessor <> nil then begin
      FProcessor.SetProp(prBackupTables, doTables in FObjects);
      FProcessor.SetProp(prBackupViews, doViews in Objects);
      FProcessor.SetProp(prBackupData, doData in Objects);
    end;
  end;
end;

end.


