
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit DADesignUtils;
{$ENDIF}

interface

uses
{$IFDEF DBTOOLS}
  DBToolsIntf,
  CRAccess,
{$ENDIF}
  Classes, SysUtils, MemUtils, CRDesignUtils, DB, DBAccess;

type
{$IFDEF DBTOOLS}
  TNeedToCheckDbTools = (ncNone, ncExpired, ncNoAddin, ncIncompatible);
{$ENDIF}

  TDADesignUtilsAlias = class(TCRDesignUtilsAlias)
  public
    {$IFNDEF VER8}class{$ENDIF} function GetProjectName: string; override; // Returns ProjectName = ('DataEditor', 'ODAC', 'SDAC', 'MyDAC', ...)

  { Component }
    {$IFNDEF VER8}class{$ENDIF} function GetDesignCreate(Obj: TComponent): boolean; override;
    {$IFNDEF VER8}class{$ENDIF} procedure SetDesignCreate(Obj: TComponent; Value: boolean); override;
  {$IFNDEF FPC}
    {$IFNDEF VER8}class{$ENDIF} function GetConnectionList: TObject; virtual;   //avoid circular link error
  {$ENDIF}

  { Connection support }
    {$IFNDEF VER8}class{$ENDIF} function HasConnection(Obj: TComponent): boolean; virtual;
    {$IFNDEF VER8}class{$ENDIF} function GetConnection(Obj: TComponent): TCustomDAConnection; virtual;
    {$IFNDEF VER8}class{$ENDIF} procedure SetConnection(Obj: TComponent; Value: TCustomDAConnection); virtual;
    {$IFNDEF VER8}class{$ENDIF} function UsedConnection(Obj: TComponent): TCustomDAConnection; virtual;

  { SQL support }
    {$IFNDEF VER8}class{$ENDIF} function GetSQL(Obj: TComponent; StatementType: TStatementType = stQuery): _TStrings; virtual;
    {$IFNDEF VER8}class{$ENDIF} procedure SetSQL(Obj: TComponent; Value: _TStrings; StatementType: TStatementType = stQuery); overload; virtual;
    {$IFNDEF VER8}class{$ENDIF} procedure SetSQL(Obj: TComponent; Value: _string; StatementType: TStatementType = stQuery); overload; virtual;

    {$IFNDEF VER8}class{$ENDIF} function GetSQLPropName(Obj: TComponent; StatementType: TStatementType): string; virtual;

    class function GetParams(Obj: TComponent): TDAParams;
    class procedure SetParams(Obj: TComponent; Value: TDAParams);
    class function GetMacros(Obj: TComponent): TMacros;
    class procedure SetMacros(Obj: TComponent; Value: TMacros);
    class procedure Execute(Obj: TComponent);
    class function GetAfterExecute(Obj: TComponent): TAfterExecuteEvent;
    class procedure SetAfterExecute(Obj: TComponent; Value: TAfterExecuteEvent);

  { DataSet support}
    {$IFNDEF VER8}class{$ENDIF} function GetStatementTypes: TStatementTypes; virtual; // allowable StatementTypes for GetSQL and SetSQL

  { TDATable support }
    {$IFNDEF VER8}class{$ENDIF} function GetTableName(Obj: TCustomDADAtaSet): _string; virtual;
    {$IFNDEF VER8}class{$ENDIF} procedure SetTableName(Obj: TCustomDADAtaSet; const Value: _string); virtual;
    {$IFNDEF VER8}class{$ENDIF} function GetOrderFields(Obj: TCustomDADAtaSet): _string; virtual;
    {$IFNDEF VER8}class{$ENDIF} procedure SetOrderFields(Obj: TCustomDADAtaSet; const Value: _string); virtual;
    {$IFNDEF VER8}class{$ENDIF} procedure PrepareSQL(Obj: TCustomDADAtaSet); virtual;

  { TDAStoredProc support}
    {$IFNDEF VER8}class{$ENDIF} function GetStoredProcName(Obj: TCustomDADataSet): _string; virtual;
    {$IFNDEF VER8}class{$ENDIF} procedure SetStoredProcName(Obj: TCustomDADataSet; const Value: _string); virtual;

  {$IFDEF USE_SYNEDIT}
    {$IFNDEF VER8}class{$ENDIF} function SQLDialect: integer ; override; // SynHighlighterSQL TSQLDialect = (sqlStandard, sqlInterbase6, sqlMSSQL7, sqlMySQL, sqlOracle, sqlSybase, sqlIngres, sqlMSSQL2K);
  {$ENDIF}

    class function DBToolsAvailable: boolean; override;

  {$IFDEF DBTOOLS}
    class function DBToolsService: TObject; virtual; //avoid circular link error
    class function NeedToCheckDbTools: TNeedToCheckDbTools; virtual;
    class function GetDBToolsServiceVersion: int64; virtual;
    class function GetDBToolsServiceVersionStr: string;
    class function GetDBToolsMenuCaption: string; virtual;
    class function GetFullName(Obj: TComponent): string; virtual;
    class function GetObjectType(Obj: TComponent): string; virtual;
    class procedure SetDBToolsDownloadParams(VerbCheck: boolean; Incompatible: boolean); virtual;
    class function HasParams(Obj: TComponent): boolean;
    class function IsStoredProc(Obj: TComponent): boolean; virtual;
    class procedure GetDBToolsConnectionList(Connection: TCustomDAConnection); virtual;
  {$ENDIF}
  end;

{$IFDEF VER8}
  TDADesignUtilsClass = TDADesignUtilsAlias;

var
  TDADesignUtils: TDADesignUtilsAlias;
{$ELSE}
  TDADesignUtils = TDADesignUtilsAlias;
  TDADesignUtilsClass = class of TDADesignUtils;
{$ENDIF}

implementation

uses
{$IFDEF MSWINDOWS}
  Windows, ComObj,
{$ENDIF}
{$IFNDEF KYLIX}
  Forms,
{$ELSE}
  QForms,
{$ENDIF}
{$IFDEF CLR}
  System.Runtime.InteropServices,
{$ELSE}
  CLRClasses,
{$ENDIF}
{$IFDEF DBTOOLS}
  DBToolsClient,
{$ENDIF}
  DALoader, DADump, DAScript;

{ TDADesignUtilsAlias }

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.GetProjectName: string;
begin
 Result := 'DAC';
end;

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.GetDesignCreate(Obj: TComponent): boolean;
begin
  Result := False;
  Assert(Obj <> nil);
  if Obj is TDATransaction then
    Result := TDBAccessUtils.GetDesignCreate(TDATransaction(Obj))
  else
  if Obj is TCustomDASQL then
    Result := TDBAccessUtils.GetDesignCreate(TCustomDASQL(Obj))
  else
  if Obj is TCustomDADataSet then
    Result := TDBAccessUtils.GetDesignCreate(TCustomDADataSet(Obj))
  else
  if Obj is TDALoader then
    Result := TDALoaderUtils.GetDesignCreate(TDALoader(Obj))
  else
  if Obj is TDADump then
    Result := TDADumpUtils.GetDesignCreate(TDADump(Obj))
  else
  if Obj is TDAScript then
    Result := TDAScriptUtils.GetDesignCreate(TDAScript(Obj))
  else
  if Obj is TCustomDAUpdateSQL then
    Result := TDBAccessUtils.GetDesignCreate(TCustomDAUpdateSQL(Obj))
  else
  if Obj is TDAMetaData then
    Result := TDBAccessUtils.GetDesignCreate(TDAMetaData(Obj))
  else
  if Obj is TCRDataSource then
    Result := TDBAccessUtils.GetDesignCreate(TCRDataSource(Obj))
  else
    Assert(False, Obj.ClassName);
end;

{$IFNDEF VER8}class{$ENDIF} procedure TDADesignUtilsAlias.SetDesignCreate(Obj: TComponent; Value: boolean);
begin
  Assert(Obj <> nil);
  if Obj is TDATransaction then
    TDBAccessUtils.SetDesignCreate(TDATransaction(Obj), Value)
  else
  if Obj is TCustomDASQL then
    TDBAccessUtils.SetDesignCreate(TCustomDASQL(Obj), Value)
  else
  if Obj is TCustomDADataSet then
    TDBAccessUtils.SetDesignCreate(TCustomDADataSet(Obj), Value)
  else
  if Obj is TDALoader then
    TDALoaderUtils.SetDesignCreate(TDALoader(Obj), Value)
  else
  if Obj is TDADump then
    TDADumpUtils.SetDesignCreate(TDADump(Obj), Value)
  else
  if Obj is TDAScript then
    TDAScriptUtils.SetDesignCreate(TDAScript(Obj), Value)
  else
  if Obj is TCustomDAUpdateSQL then
    TDBAccessUtils.SetDesignCreate(TCustomDAUpdateSQL(Obj), Value)
  else
  if Obj is TDAMetaData then
    TDBAccessUtils.SetDesignCreate(TDAMetaData(Obj), Value)
  else
  if Obj is TCRDataSource then
    TDBAccessUtils.SetDesignCreate(TCRDataSource(Obj), Value)
  else
    Assert(False, Obj.ClassName);
end;

{$IFNDEF FPC}
{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.GetConnectionList: TObject;
begin
  Result := nil;
  Assert(False, 'Must be overriden on Product layer');
end;
{$ENDIF}

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.HasConnection(Obj: TComponent): boolean;
begin
  Assert(Obj <> nil);
  if Obj is TDATransaction then
    Result := True
  else
  if Obj is TCustomDASQL then
    Result := True
  else
  if Obj is TCustomDADataSet then
    Result := True
  else
  if Obj is TDAScript then
    Result := True
  else
  if Obj is TDALoader then
    Result := True
  else
  if Obj is TDADump then
    Result := True
  else
  if Obj is TDAMetaData then
    Result := True
  else
    Result := False;
end;

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.GetConnection(Obj: TComponent): TCustomDAConnection;
begin
  Result := nil;
  Assert(Obj <> nil);
  if Obj is TDATransaction then
    Result := TDATransaction(Obj).DefaultConnection
  else
  if Obj is TCustomDASQL then
    Result := TCustomDASQL(Obj).Connection
  else
  if Obj is TCustomDADataSet then
    Result := TCustomDADataSet(Obj).Connection
  else
  if Obj is TDAScript then
    Result := TDAScript(Obj).Connection
  else
  if Obj is TDALoader then
    Result := TDALoader(Obj).Connection
  else
  if Obj is TDADump then
    Result := TDADump(Obj).Connection
  else
  if Obj is TDAMetaData then
    Result := TDAMetaData(Obj).Connection
  else
    Assert(False, Obj.ClassName);
end;

{$IFNDEF VER8}class{$ENDIF} procedure TDADesignUtilsAlias.SetConnection(Obj: TComponent; Value: TCustomDAConnection);
begin
  Assert(Obj <> nil);
  if Obj is TDATransaction then
    TDATransaction(Obj).DefaultConnection := Value
  else
  if Obj is TCustomDASQL then
    TCustomDASQL(Obj).Connection := Value
  else
  if Obj is TCustomDADataSet then
    TCustomDADataSet(Obj).Connection := Value
  else
  if Obj is TDAScript then
    TDAScript(Obj).Connection := Value
  else
  if Obj is TDALoader then
    TDALoader(Obj).Connection := Value
  else
  if Obj is TDADump then
    TDADump(Obj).Connection := Value
  else
  if Obj is TDAMetaData then
    TDAMetaData(Obj).Connection := Value
  else
    Assert(False, Obj.ClassName);
end;

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.UsedConnection(Obj: TComponent): TCustomDAConnection;
begin
  Result := nil;
  Assert(Obj <> nil);
  if Obj is TCustomDASQL then
    Result := TDBAccessUtils.UsedConnection(TCustomDASQL(Obj))
  else
  if Obj is TCustomDADataSet then
    Result := TDBAccessUtils.UsedConnection(TCustomDADataSet(Obj))
  else
  if Obj is TDAScript then
    Result := TDAScriptUtils.UsedConnection(TDAScript(Obj))
  else
  if Obj is TDALoader then
    Result := TDALoaderUtils.UsedConnection(TDALoader(Obj))
  else
  if Obj is TCustomDAUpdateSQL then begin
    if TCustomDAUpdateSQL(Obj).DataSet <> nil then
      Result := TDBAccessUtils.UsedConnection(TCustomDAUpdateSQL(Obj).DataSet)
    else
      Result := nil;
  end
  else
  if Obj is TDADump then
    Result := TDADump(Obj).Connection
  else
    Assert(False, Obj.ClassName);
end;

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.GetStatementTypes: TStatementTypes;
begin
  Result := [stQuery, stInsert, stUpdate, stDelete, stRefresh, stLock];
end;

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.GetSQL(Obj: TComponent; StatementType: TStatementType = stQuery): _TStrings;
begin
  Result := nil;
{$IFNDEF FPC}
  Assert(Obj <> nil);
{$ELSE}
  if Obj = nil then
    Exit;
{$ENDIF}

  Assert((StatementType = stQuery) or (Obj is TCustomDADataSet) or (Obj is TCustomDAUpdateSQL));
  if Obj is TCustomDASQL then
    Result := TCustomDASQL(Obj).SQL
  else
  if (Obj is TDADump) then
    Result := TDADump(Obj).SQL
  else
  if (Obj is TDAScript) then
    Result := TDAScript(Obj).SQL
  else
  if Obj is TCustomDADataSet then begin
    case StatementType of
      stQuery:
        Result := TCustomDADataSet(Obj).SQL;
      stInsert:
        Result := TCustomDADataSet(Obj).SQLInsert;
      stUpdate:
        Result := TCustomDADataSet(Obj).SQLUpdate;
      stDelete:
        Result := TCustomDADataSet(Obj).SQLDelete;
      stRefresh:
        Result := TCustomDADataSet(Obj).SQLRefresh;
      stLock:
        Result := TCustomDADataSet(Obj).SQLLock;
      else
      begin
        Result := nil;
        Assert(False, 'StatementType = ' + IntToStr(Integer(StatementType)));
      end;
    end;
  end
  else
  if Obj is TCustomDAUpdateSQL then begin
    case StatementType of
      stInsert:
        Result := TCustomDAUpdateSQL(Obj).InsertSQL;
      stUpdate:
        Result := TCustomDAUpdateSQL(Obj).ModifySQL;
      stDelete:
        Result := TCustomDAUpdateSQL(Obj).DeleteSQL;
      stRefresh:
        Result := TCustomDAUpdateSQL(Obj).RefreshSQL;
      stLock:
        Result := TCustomDAUpdateSQL(Obj).LockSQL;
      else
      begin
        Result := nil;
        Assert(False, 'StatementType = ' + IntToStr(Integer(StatementType)));
      end;
    end;
  end
  else
  if Obj is TDAScript then
    Result := TDAScript(Obj).SQL
  else
    Assert(False, Obj.ClassName);
end;

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.GetSQLPropName(Obj: TComponent; StatementType: TStatementType): string;
begin
  Result := '';
  Assert(Obj <> nil);
  Assert((StatementType = stQuery) or (Obj is TCustomDADataSet) or (Obj is TCustomDAUpdateSQL));
  if (Obj is TCustomDASQL) or (Obj is TDADump) or (Obj is TDAScript) then
    Result := 'SQL'
  else
  if Obj is TCustomDADataSet then
    case StatementType of
      stQuery:
        Result := 'SQL';
      stInsert:
        Result := 'SQLInsert';
      stUpdate:
        Result := 'SQLUpdate';
      stDelete:
        Result := 'SQLDelete';
      stRefresh:
        Result := 'SQLRefresh';
      stLock:
        Result := 'SQLLock';
      else
        Assert(False, 'StatementType = ' + IntToStr(Integer(StatementType)));
    end
  else
  if Obj is TCustomDAUpdateSQL then
    case StatementType of
      stInsert:
        Result := 'InsertSQL';
      stUpdate:
        Result := 'ModifySQL';
      stDelete:
        Result := 'DeleteSQL';
      stRefresh:
        Result := 'RefreshSQL';
      stLock:
        Result := 'LockSQL';
      else
        Assert(False, 'StatementType = ' + IntToStr(Integer(StatementType)));
    end;

end;

{$IFNDEF VER8}class{$ENDIF} procedure TDADesignUtilsAlias.SetSQL(Obj: TComponent; Value: _TStrings; StatementType: TStatementType = stQuery);
begin
  Assert(Obj <> nil);
  Assert((StatementType = stQuery) or (Obj is TCustomDADataSet) or (Obj is TCustomDAUpdateSQL));
  if Obj is TCustomDASQL then
    TCustomDASQL(Obj).SQL := Value
  else
  if (Obj is TDADump) then
    TDADump(Obj).SQL := Value
  else
  if (Obj is TDAScript) then
    TDAScript(Obj).SQL := Value
  else
  if Obj is TCustomDADataSet then begin
    case StatementType of
      stQuery:
        TCustomDADataSet(Obj).SQL := Value;
      stInsert:
        TCustomDADataSet(Obj).SQLInsert := Value;
      stUpdate:
        TCustomDADataSet(Obj).SQLUpdate := Value;
      stDelete:
        TCustomDADataSet(Obj).SQLDelete := Value;
      stRefresh:
        TCustomDADataSet(Obj).SQLRefresh := Value;
      stLock:
        TCustomDADataSet(Obj).SQLLock := Value;
      else
        Assert(False, 'StatementType = ' + IntToStr(Integer(StatementType)));
    end;
  end
  else
  if Obj is TCustomDAUpdateSQL then begin
    case StatementType of
      stInsert:
        TCustomDAUpdateSQL(Obj).InsertSQL := Value;
      stUpdate:
        TCustomDAUpdateSQL(Obj).ModifySQL := Value;
      stDelete:
        TCustomDAUpdateSQL(Obj).DeleteSQL := Value;
      stRefresh:
        TCustomDAUpdateSQL(Obj).RefreshSQL := Value;
      stLock:
        TCustomDAUpdateSQL(Obj).LockSQL := Value;
      else
        Assert(False, 'StatementType = ' + IntToStr(Integer(StatementType)));
    end;
  end
  else
  if Obj is TDAScript then
    TDAScript(Obj).SQL := Value
  else
    Assert(False, Obj.ClassName);
end;

{$IFNDEF VER8}class{$ENDIF} procedure TDADesignUtilsAlias.SetSQL(Obj: TComponent; Value: _string; StatementType: TStatementType = stQuery);
var
  List: _TStringList;
begin
  List := _TStringList.Create;
  try
    List.Text := Value;
    SetSQL(Obj, List, StatementType);
  finally
    List.Free;
  end;
end;

class function TDADesignUtilsAlias.GetParams(Obj: TComponent): TDAParams;
begin
  Result := nil;
  Assert(Obj <> nil);
  if Obj is TCustomDASQL then
    Result := TCustomDASQL(Obj).Params
  else
  if Obj is TCustomDADataSet then
    Result := TCustomDADataSet(Obj).Params
  else
    Assert(False, Obj.ClassName);
end;

class procedure TDADesignUtilsAlias.SetParams(Obj: TComponent; Value: TDAParams);
begin
  Assert(Obj <> nil);
  if Obj is TCustomDASQL then
    TCustomDASQL(Obj).Params := Value
  else
  if Obj is TCustomDADataSet then
    TCustomDADataSet(Obj).Params := Value
  else
    Assert(False, Obj.ClassName);
end;

class function TDADesignUtilsAlias.GetMacros(Obj: TComponent): TMacros;
begin
  Result := nil;
  Assert(Obj <> nil);
  if Obj is TCustomDASQL then
    Result := TCustomDASQL(Obj).Macros
  else
  if Obj is TCustomDADataSet then
    Result := TCustomDADataSet(Obj).Macros
  else
  if Obj is TDAScript then
    Result := TDAScript(Obj).Macros
  else
    Assert(False, Obj.ClassName);
end;

class procedure TDADesignUtilsAlias.SetMacros(Obj: TComponent; Value: TMacros);
begin
  Assert(Obj <> nil);
  if Obj is TCustomDASQL then
    TCustomDASQL(Obj).Macros := Value
  else
  if Obj is TCustomDADataSet then
    TCustomDADataSet(Obj).Macros := Value
  else
  if Obj is TDAScript then
    TDAScript(Obj).Macros := Value
  else
    Assert(False, Obj.ClassName);
end;

class procedure TDADesignUtilsAlias.Execute(Obj: TComponent);
begin
  Assert(Obj <> nil);
  if Obj is TCustomDASQL then
    TCustomDASQL(Obj).Execute
  else
  if Obj is TCustomDADataSet then
    TCustomDADataSet(Obj).Execute
  else
    Assert(False, Obj.ClassName);
end;

class function TDADesignUtilsAlias.GetAfterExecute(Obj: TComponent): DBAccess.TAfterExecuteEvent;
begin
  Result := nil;
  Assert(Obj <> nil);
  if Obj is TCustomDASQL then
    Result := TCustomDASQL(Obj).AfterExecute
  else
  if Obj is TCustomDADataSet then
    Result := TCustomDADataSet(Obj).AfterExecute
  else
    Assert(False, Obj.ClassName);
end;

class procedure TDADesignUtilsAlias.SetAfterExecute(Obj: TComponent; Value: DBAccess.TAfterExecuteEvent);
begin
  Assert(Obj <> nil);
  if Obj is TCustomDASQL then
    TCustomDASQL(Obj).AfterExecute := Value
  else
  if Obj is TCustomDADataSet then
    TCustomDADataSet(Obj).AfterExecute := Value
  else
    Assert(False, Obj.ClassName);
end;

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.GetTableName(Obj: TCustomDADAtaSet): _string;
begin
  Result := '';
  Assert(False, 'Must be overriden - D8 bug');
end;

{$IFNDEF VER8}class{$ENDIF} procedure TDADesignUtilsAlias.SetTableName(Obj: TCustomDADAtaSet; const Value: _string);
begin
  Assert(False, 'Must be overriden - D8 bug');
end;

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.GetOrderFields(Obj: TCustomDADAtaSet): _string;
begin
  Result := '';
  Assert(False, 'Must be overriden - D8 bug');
end;

{$IFNDEF VER8}class{$ENDIF} procedure TDADesignUtilsAlias.SetOrderFields(Obj: TCustomDADAtaSet; const Value: _string);
begin
  Assert(False, 'Must be overriden - D8 bug');
end;

{$IFNDEF VER8}class{$ENDIF} procedure TDADesignUtilsAlias.PrepareSQL(Obj: TCustomDADAtaSet);
begin
  Assert(False, 'Must be overriden - D8 bug');
end;

{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.GetStoredProcName(Obj: TCustomDADataSet): _string;
begin
  Assert(False, 'Must be overriden - D8 bug');
end;

{$IFNDEF VER8}class{$ENDIF} procedure TDADesignUtilsAlias.SetStoredProcName(Obj: TCustomDADataSet; const Value: _string);
begin
  Assert(False, 'Must be overriden - D8 bug');
end;

{$IFDEF USE_SYNEDIT}
{$IFNDEF VER8}class{$ENDIF} function TDADesignUtilsAlias.SQLDialect: integer;
begin
  Result := 0; // sqlStandard
end;
{$ENDIF}

class function TDADesignUtilsAlias.DBToolsAvailable: boolean;
begin
  Result := {$IFDEF DBTOOLS}DBToolsService <> nil{$ELSE}False{$ENDIF};
end;

{$IFDEF DBTOOLS}
class function TDADesignUtilsAlias.DBToolsService: TObject;
begin
  Result := nil;
end;

class function TDADesignUtilsAlias.NeedToCheckDbTools: TNeedToCheckDbTools;
begin
  Result := ncNone;
  Assert(False, 'Must be overriden');
end;

class function TDADesignUtilsAlias.GetDBToolsServiceVersion: int64;
begin
  Result := 0;
  Assert(False, 'Must be overriden');
end;

class function TDADesignUtilsAlias.GetDBToolsServiceVersionStr: string;
var
  n: int64;
  i: integer;
begin
  n := GetDBToolsServiceVersion;
  Result := '';
  for i := 0 to 3 do begin
    Result := IntToStr(n and $ffff) + Result;
    if i < 3 then begin
      Result := '.' + Result;
      n := n shr 16;
    end;
  end;
end;

class function TDADesignUtilsAlias.GetDBToolsMenuCaption: string;
begin
  Result := '';
  Assert(False, 'Must be overriden');
end;

class function TDADesignUtilsAlias.GetFullName(Obj: TComponent): string;
begin
  Result := '';
  if not (Obj is TCustomDAConnection) then
    Assert(False, Obj.ClassName);
end;

class function TDADesignUtilsAlias.GetObjectType(Obj: TComponent): string;
begin
  Result := '';
  if not (Obj is TCustomDAConnection) then
    Assert(False, Obj.ClassName);
end;

class procedure TDADesignUtilsAlias.SetDBToolsDownloadParams(VerbCheck: boolean; Incompatible: boolean);
begin
  Assert(False, 'Must be overriden');
end;

class function TDADesignUtilsAlias.HasParams(Obj: TComponent): boolean;
begin
  Result := (Obj is TCustomDASQL) or (Obj is TCustomDADataSet);
end;

class procedure TDADesignUtilsAlias.GetDBToolsConnectionList(Connection: TCustomDAConnection);
begin
  Assert(False, 'Must be overriden');
end;

class function TDADesignUtilsAlias.IsStoredProc(Obj: TComponent): boolean;
begin
  Result := False;
  Assert(False, 'Must be overriden');
end;
{$ENDIF}

initialization
{$IFDEF VER8}
  TDADesignUtils := TDADesignUtilsAlias.Create;
{$ENDIF}

finalization
{$IFDEF VER8}
  TDADesignUtils.Free;
{$ENDIF}


end.
