
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyDesignUtils;
{$ENDIF}

interface

uses
{$IFDEF DBTOOLS}
  DBToolsClient, DBToolsIntf, DB,
{$ENDIF}
  Classes, SysUtils, MemUtils, DBAccess, CRDesignUtils, DADesignUtils;

type
  TMyDesignUtilsAlias = class(TDADesignUtilsAlias)
    {$IFNDEF VER8}class{$ENDIF} function GetProjectName: string; override;

  { Component }
  {$IFDEF MYDAC}
    {$IFNDEF VER8}class{$ENDIF} function GetConnectionList: TObject; override;
  {$ENDIF}
    {$IFNDEF VER8}class{$ENDIF} function GetDesignCreate(Obj: TComponent): boolean; override;
    {$IFNDEF VER8}class{$ENDIF} procedure SetDesignCreate(Obj: TComponent; Value: boolean); override;

  { Connection support }
    {$IFNDEF VER8}class{$ENDIF} function HasConnection(Obj: TComponent): boolean; override;
    {$IFNDEF VER8}class{$ENDIF} function GetConnection(Obj: TComponent): TCustomDAConnection; override;
    {$IFNDEF VER8}class{$ENDIF} procedure SetConnection(Obj: TComponent; Value: TCustomDAConnection); override;

  { TDATable support }
    {$IFNDEF VER8}class{$ENDIF} function GetTableName(Obj: TCustomDADAtaSet): _string; override;
    {$IFNDEF VER8}class{$ENDIF} procedure SetTableName(Obj: TCustomDADAtaSet; const Value: _string); override;
    {$IFNDEF VER8}class{$ENDIF} function GetOrderFields(Obj: TCustomDADAtaSet): _string; override;
    {$IFNDEF VER8}class{$ENDIF} procedure SetOrderFields(Obj: TCustomDADAtaSet; const Value: _string); override;
    {$IFNDEF VER8}class{$ENDIF} procedure PrepareSQL(Obj: TCustomDADAtaSet); override;
    {$IFNDEF VER8}class{$ENDIF} function GetStoredProcName(Obj: TCustomDADataSet): _string; override;
    {$IFNDEF VER8}class{$ENDIF} procedure SetStoredProcName(Obj: TCustomDADataSet; const Value: _string); override;

  {$IFDEF USE_SYNEDIT}
    {$IFNDEF VER8}class{$ENDIF} function SQLDialect: integer ; override; // SynHighlighterSQL TSQLDialect = (sqlStandard, sqlInterbase6, sqlMSSQL7, sqlMySQL, sqlOracle, sqlSybase, sqlIngres, sqlMSSQL2K);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  {$IFNDEF STD}
    class procedure CheckForMyBuilder(VerbCheck: boolean);
  {$ENDIF}
  {$ENDIF}
  {$IFDEF DBTOOLS}
    class function DBToolsService: TObject; override;
    class function NeedToCheckDbTools: TNeedToCheckDbTools; override;
    class function GetDBToolsServiceVersion: int64; override;
    class function GetDBToolsMenuCaption: string; override;
    class function GetFullName(Obj: TComponent): string; override;
    class function GetObjectType(Obj: TComponent): string; override;
    class function IsStoredProc(Obj: TComponent): boolean; override;

    class procedure GetDBToolsConnectionList(Connection: TCustomDAConnection); override;
    class procedure SetDBToolsDownloadParams(VerbCheck: boolean; Incompatible: boolean); override;
  {$ENDIF}
  end;

{$IFDEF VER8}
  TMyDesignUtilsClass = TMyDesignUtilsAlias;

var
  TMyDesignUtils: TMyDesignUtilsAlias;
{$ELSE}
  TMyDesignUtils = TMyDesignUtilsAlias;
  TMyDesignUtilsClass = class of TMyDesignUtils;
{$ENDIF}

{$IFDEF MSWINDOWS}
{$I MyDacVer.inc}
resourcestring
  sMydacVersion = 'MyDAC ' + MydacVersion;
{$IFNDEF STD}
  sMyBuilderDownloadCaption = 'MyDAC Information';
  sMyBuilderName = 'SQLBuilder for MySQL Add-in';
  sAskIncompatible = 'AskIncompatible';
  sAskNoAddin = 'AskNoAddin';
{$ENDIF}
{$IFDEF DBTOOLS}
  sDevToolsDownloadCaption = 'MyDAC Information';
  sDevToolsName = 'MySQL Developer Tools';
  sDevAskIncompatible = 'DevAskIncompatible';
  sDevAskNoAddin = 'DevAskNoAddin';
  sProductAskIncompatible = 'MyDacAskIncompatible';
{$ENDIF}
{$ENDIF}

implementation

uses
{$IFDEF MYDAC}
  MyDesign,
{$ENDIF}
{$IFNDEF STD}
{$IFDEF MSWINDOWS}
  MyBuilderClient,
{$ENDIF}
{$ENDIF}
{$IFDEF DBTOOLS}
{$IFDEF VER11P}
  DBForgeClientImp,
{$ELSE}
  DBToolsClientImp,
{$ENDIF}
  Download,
{$ELSE}
{$IFDEF MSWINDOWS}
{$IFNDEF STD}
  Download,
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$IFNDEF STD}
  MyBackup, MyDump, DADump, MyServerControl, MyEmbConnection,
{$ENDIF}
  MyAccess;

{ TMyDesignUtils }

{$IFNDEF VER8}class{$ENDIF} function TMyDesignUtilsAlias.GetProjectName: string;
begin
  Result := 'MyDAC';
end;

{$IFNDEF VER8}class{$ENDIF} function TMyDesignUtilsAlias.HasConnection(Obj: TComponent): boolean;
begin
{$IFNDEF STD}
  if Obj is TMyBackup then
    Result := True
  else
  if Obj is TMyDump then
    Result := True
  else
{$IFDEF MSWINDOWS}
  if Obj is TMyBuilder then
    Result := True
  else
{$ENDIF}
  if Obj is TMyServerControl then
    Result := True
  else
{$ENDIF}
    Result := inherited HasConnection(Obj);
end;

{$IFNDEF VER8}class{$ENDIF} function TMyDesignUtilsAlias.GetConnection(Obj: TComponent): TCustomDAConnection;
begin
  Assert(Obj <> nil);
{$IFNDEF STD}
  if Obj is TMyBackup then
    Result := TMyBackup(Obj).Connection
  else
  if Obj is TMyDump then
    Result := TMyDump(Obj).Connection
  else
{$IFDEF MSWINDOWS}
  if Obj is TMyBuilder then
    Result := TMyBuilder(Obj).Connection
  else
{$ENDIF}
  if Obj is TMyServerControl then
    Result := TMyServerControl(Obj).Connection
  else
{$ENDIF}  
    Result := inherited GetConnection(Obj);
end;

{$IFNDEF VER8}class{$ENDIF} procedure TMyDesignUtilsAlias.SetConnection(Obj: TComponent; Value: TCustomDAConnection);
begin
  Assert(Obj <> nil);
{$IFNDEF STD}
  if Obj is TMyBackup then
    TMyBackup(Obj).Connection := Value as TCustomMyConnection
  else
  if Obj is TMyDump then
    TMyDump(Obj).Connection := Value as TCustomMyConnection
  else
{$IFDEF MSWINDOWS}
  if Obj is TMyBuilder then
    TMyBuilder(Obj).Connection := Value as TMyConnection
  else
{$ENDIF}
  if Obj is TMyServerControl then
    TMyServerControl(Obj).Connection := Value as TCustomMyConnection
  else
{$ENDIF}
    inherited;
end;

{$IFNDEF VER8}class{$ENDIF} function TMyDesignUtilsAlias.GetOrderFields(Obj: TCustomDADAtaSet): _string;
begin
  Assert(Obj is TCustomMyTable, Obj.ClassName);
  Result := TCustomMyTable(Obj).OrderFields;
end;

{$IFNDEF VER8}class{$ENDIF} procedure TMyDesignUtilsAlias.SetOrderFields(Obj: TCustomDADAtaSet;
  const Value: _string);
begin
  Assert(Obj is TCustomMyTable, Obj.ClassName);
  TCustomMyTable(Obj).OrderFields := Value;
end;

{$IFNDEF VER8}class{$ENDIF} function TMyDesignUtilsAlias.GetTableName(Obj: TCustomDADAtaSet): _string;
begin
  Assert(Obj is TCustomMyTable, Obj.ClassName);
  Result := TCustomMyTable(Obj).TableName;
end;

{$IFNDEF VER8}class{$ENDIF} procedure TMyDesignUtilsAlias.SetTableName(Obj: TCustomDADAtaSet; const Value: _string);
begin
  Assert(Obj is TCustomMyTable, Obj.ClassName);
  TCustomMyTable(Obj).TableName := Value;
end;

{$IFNDEF VER8}class{$ENDIF} procedure TMyDesignUtilsAlias.PrepareSQL(Obj: TCustomDADAtaSet);
begin
  Assert(Obj is TCustomMyTable, Obj.ClassName);
  TCustomMyTable(Obj).PrepareSQL;
end;

{$IFNDEF VER8}class{$ENDIF} function TMyDesignUtilsAlias.GetStoredProcName(Obj: TCustomDADAtaSet): _string;
begin
  Assert(Obj is TCustomMyStoredProc, Obj.ClassName);
  Result := TCustomMyStoredProc(Obj).StoredProcName;
end;

{$IFNDEF VER8}class{$ENDIF} procedure TMyDesignUtilsAlias.SetStoredProcName(Obj: TCustomDADAtaSet;
  const Value: _string);
begin
  Assert(Obj is TCustomMyStoredProc, Obj.ClassName);
  TCustomMyStoredProc(Obj).StoredProcName := Value;
end;

{$IFDEF USE_SYNEDIT}
class function TMyDesignUtilsAlias.SQLDialect: integer;
begin
  Result := 3; // sqlMySQL
end;
{$ENDIF}

{$IFDEF MYDAC}
{$IFNDEF VER8}class{$ENDIF} function TMyDesignUtilsAlias.GetConnectionList: TObject;
begin
  Result := TMyConnectionList.Create;
end;
{$ENDIF}

{$IFNDEF VER8}class{$ENDIF} function TMyDesignUtilsAlias.GetDesignCreate(Obj: TComponent): boolean;
begin
  Assert(Obj <> nil);
{$IFNDEF STD}
  if Obj is TMyBackup then
    Result := TMyBackupUtils.GetDesignCreate(TMyBackup(Obj))
  else
  if Obj is TMyDump then
    Result := TDADumpUtils.GetDesignCreate(TMyDump(Obj))
  else
{$IFDEF MSWINDOWS}
  if Obj is TMyBuilder then
    Result := TMyBuilderUtils.GetDesignCreate(TMyBuilder(Obj))
  else
{$ENDIF}
  if Obj is TMyServerControl then
    Result := TMyServerControlUtils.GetDesignCreate(TMyServerControl(Obj))
  else
{$ENDIF}  
    Result := inherited GetDesignCreate(Obj);
end;

{$IFNDEF VER8}class{$ENDIF} procedure TMyDesignUtilsAlias.SetDesignCreate(Obj: TComponent; Value: boolean);
begin
  Assert(Obj <> nil);
{$IFNDEF STD}
  if Obj is TMyBackup then
    TMyBackupUtils.SetDesignCreate(TMyBackup(Obj), Value)
  else
  if Obj is TMyDump then
    TDADumpUtils.SetDesignCreate(TMyDump(Obj), Value)
  else
{$IFDEF MSWINDOWS}
  if Obj is TMyBuilder then
    TMyBuilderUtils.SetDesignCreate(TMyBuilder(Obj), Value)
  else
{$ENDIF}
  if Obj is TMyServerControl then
    TMyServerControlUtils.SetDesignCreate(TMyServerControl(Obj), Value)
  else
{$ENDIF}
    inherited;
end;

{$IFDEF MSWINDOWS}
{$IFNDEF STD}
class procedure TMyDesignUtilsAlias.CheckForMyBuilder(VerbCheck: boolean);
var
  AskNoAddin, AskIncompatible, AtomName: string;
begin
  MyBuilderAvailable;
  if NeedToCheckMyBuilder <> cmNone then begin
    if VerbCheck then begin
      AskIncompatible := '';
      AskNoAddin := '';
      AtomName := '';
    end
    else begin
      AskIncompatible := sAskIncompatible;
      AskNoAddin := sAskNoAddin;
      AtomName := 'CheckForMyBuilder atom';
    end;

    SetToolsCheckingParams(sMyBuilderDownloadCaption, sMyBuilderName,
    sMydacVersion, AskIncompatible, AskNoAddin, 'Software\Devart\mydac',
    'Mydac', 'UsingMyBuilderAddin', 'www.devart.com/mybuilder',
    'mybuilderadd.exe', AtomName);
    CheckForTools(NeedToCheckMyBuilder = cmIncompartible);
  end;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF DBTOOLS}
const
{$IFDEF VER9}
  MySqlServiceCLSIDs: array[0..0] of TGUID = ('{DD06A3A9-B493-4a68-AB0E-038B90BBD090}');
{$ENDIF}
{$IFDEF VER10}
  MySqlServiceCLSIDs: array[0..0] of TGUID = ('{DD06A3A9-B493-4a68-AB0E-038B90BBD100}');
{$ENDIF}
{$IFDEF VER11}
  MySqlServiceCLSIDs: array[0..1] of TGUID = ('{DD06A3A9-B493-4a68-AB0E-038B90BBD110}', '{DD06A3A9-B493-4a68-AB0E-038B90BBD111}');
{$ENDIF}
  MySqlProviderKey = {$IFDEF VER9}'Bds3\' +{$ENDIF}
    {$IFDEF VER10}'Bds4\' +{$ENDIF}
    '{59F90733-4D68-4fdf-82A7-F0FCBF5460AA}';

var
  MySqlService: TObject;
  MySqlServiceFault: boolean;
  MySqlServiceNeedToCheck: TNeedToCheckDbTools;
  MySqlServiceVersion: int64;

class function TMyDesignUtilsAlias.DBToolsService: TObject;
const
  dbtBigInt = 1;
  dbtBit = $11;
  dbtBlob = 2;
  dbtChar = 3;
  dbtDate = 4;
  dbtDateTime = 5;
  dbtDecimal = 6;
  dbtDouble = 7;
  dbtFloat = 8;
  dbtInt = 9;
  dbtSmallInt = 10;
  dbtText = 11;
  dbtTime = 12;
  dbtTimeStamp = 13;
  dbtTinyInt = 14;
  dbtVarChar = 15;
  dbtYear = $10;
begin
  if (MySqlService = nil) and not MySqlServiceFault then begin
    MySqlServiceFault := true;
    MySqlService := DBTools.CreateDBToolsService(
      {$IFDEF VER11P}TDBForgeService{$ELSE}TDBToolsService{$ENDIF},
      TMyDesignUtils,
      MySqlServiceCLSIDs,{$IFDEF CLR} 'MySql',{$ENDIF}
      'Host=;User Id=;Password=;Database=;Port=3306;'
      + 'SSL CA Cert=;SSL Cert=;SSL Key=;SSL Cipher List=;Embedded=False;'
      + 'Server Parameters=;Direct=True;Unicode=False;',
      MySqlProviderKey, MySqlServiceVersion, MySqlServiceNeedToCheck);
    MySqlServiceFault := MySqlService = nil;
    if not MySqlServiceFault then
      with TCustomDBToolsService(MySqlService) do begin
        AddParamTypeMap(ftString, dbtVarChar);
        AddParamTypeMap(ftWideString, dbtVarChar);
        AddParamTypeMap(ftBlob, dbtBlob);
        AddParamTypeMap(ftMemo, dbtText);
      {$IFDEF VER10}
        AddParamTypeMap(ftWideMemo, dbtText);
      {$ENDIF}
        AddParamTypeMap(ftVarBytes, dbtText);
        AddParamTypeMap(ftDate, dbtDate);
        AddParamTypeMap(ftDateTime, dbtDateTime);
        AddParamTypeMap(ftDateTime, dbtTimeStamp);
        AddParamTypeMap(ftTime, dbtTime);
        AddParamTypeMap(ftFixedChar, dbtChar);
        AddParamTypeMap(ftFloat, dbtFloat);
        AddParamTypeMap(ftFloat, dbtDouble);
        AddParamTypeMap(ftBCD, dbtDecimal);
        AddParamTypeMap(ftInteger, dbtInt);
        AddParamTypeMap(ftInteger, dbtYear);
        AddParamTypeMap(ftWord, dbtInt);
        AddParamTypeMap(ftLargeInt, dbtBigInt);
        AddParamTypeMap(ftLargeInt, dbtBit);
        AddParamTypeMap(ftBoolean, dbtBit);
        AddParamTypeMap(ftSmallint, dbtSmallInt);
        AddParamTypeMap(ftSmallint, dbtTinyInt);
      end;
  end;
  Result := MySqlService;
end;

class function TMyDesignUtilsAlias.NeedToCheckDbTools: TNeedToCheckDbTools;
begin
  DBToolsAvailable;
  Result := MySqlServiceNeedToCheck;
end;

class function TMyDesignUtilsAlias.GetDBToolsServiceVersion: int64;
begin
  DBToolsAvailable;
  Result := MySqlServiceVersion;
end;

class function TMyDesignUtilsAlias.GetDBToolsMenuCaption: string;
begin
  Result := 'Devart MySQL Developer Tools';
end;

class procedure TMyDesignUtilsAlias.GetDBToolsConnectionList(Connection: TCustomDAConnection);
var
  MyConnection: TMyConnection;
  IsEmbedded: boolean;
  Service: TCustomDBToolsService;
{$IFNDEF STD}
  i: integer;
  s: string;
{$ENDIF}  
begin
  Assert(MySqlService <> nil);
  Service := TCustomDBToolsService(MySqlService);
  if Connection <> nil then
    with TCustomMyConnection(Connection) do begin
      if Connection is TMyConnection then begin
        MyConnection := TMyConnection(Connection);
        IsEmbedded := MyConnection.Embedded;
      end
      else begin
        MyConnection := nil;
        IsEmbedded := True;
      end;
      if IsEmbedded then
        Service.SkipConnectionParams(1)
      else
        Service.PutConnectionParam(MyConnection.Server); //Host
      Service.PutConnectionParam(Username, cfCaseSensitive);//User Id
      Service.PutConnectionParam(Password, cfNone);//Password
      Service.PutConnectionParam(Database); //Database
      if IsEmbedded then
        Service.SkipConnectionParams(5)
      else begin
        Service.PutConnectionParam(IntToStr(MyConnection.Port)); //Port
        Service.PutConnectionParam(MyConnection.SSLOptions.CACert); //SSL CA Cert
        Service.PutConnectionParam(MyConnection.SSLOptions.Cert); //SSL Cert
        Service.PutConnectionParam(MyConnection.SSLOptions.Key); //SSL Key
        Service.PutConnectionParam(MyConnection.SSLOptions.ChipherList); //SSL Cipher List
      end;
      Service.PutConnectionParam(BoolToStr(IsEmbedded, True)); //Embedded

      {$IFNDEF STD}
      if Connection is TMyEmbConnection then begin
        s := '';
        for i := 0 to  TMyEmbConnection(Connection).Params.Count - 1 do begin
          if i <> 0 then
            s := s + ';';
          s := s + TMyEmbConnection(Connection).Params[i];
        end;
        Service.PutConnectionParam(s);
      end
      else
      {$ENDIF}
        if MyConnection.Embedded then
          Service.PutConnectionParam('')
        else
          Service.SkipConnectionParams(1);
  
      {$IFDEF HAVE_DIRECT}
      if not IsEmbedded then
        Service.PutConnectionParam(BoolToStr(MyConnection.Options.Direct, True)) //Direct
      else
      {$ENDIF}
        Service.SkipConnectionParams(1);
      Service.PutConnectionParam(BoolToStr(Options.UseUnicode, True)); //UseUnicode
    end;
end;

class function TMyDesignUtilsAlias.GetFullName(Obj: TComponent): string;
begin
  if Obj is TCustomMyTable then
    Result := GetTableName(TCustomDADataSet(Obj))
  else
  if Obj is TCustomMyStoredProc then
    Result := GetStoredProcName(TCustomDADataSet(Obj))
  else
    Result := inherited GetFullName(Obj);
end;

class function TMyDesignUtilsAlias.GetObjectType(Obj: TComponent): string;
begin
  if Obj is TCustomMyTable then
    Result := 'Table,View'
  else
  if Obj is TCustomMyStoredProc then
    Result := 'Procedure,Function'
  else
    Result := inherited GetObjectType(Obj);
end;

class function TMyDesignUtilsAlias.IsStoredProc(Obj: TComponent): boolean;
begin
  Result := Obj is TCustomMyStoredProc;
end;

class procedure TMyDesignUtilsAlias.SetDBToolsDownloadParams(VerbCheck: boolean; Incompatible: boolean);
var
  AskStr, AtomName: string;
  OutdatedProduct: boolean;
begin
  OutdatedProduct := Incompatible and ((GetDBToolsServiceVersion = 0) or
    (GetDBToolsServiceVersion > 2 * $1000000000000{2.0.0.0}));
  if VerbCheck then begin
    AskStr := '_Verb';
    AtomName := '';
  end
  else begin
    AskStr := '';
    if OutdatedProduct then
      AtomName := 'CheckForMyDac atom'
    else
      AtomName := 'CheckForMySqlDevTools atom';
  end;

  if OutdatedProduct then begin
    SetToolsCheckingParams(sDevToolsDownloadCaption, GetProjectName, sDevToolsName,
      sProductAskIncompatible + AskStr, sProductAskIncompatible + AskStr,
      'Software\Devart\mydac', 'Mydac', 'MySQLDeveloper',
      'www.devart.com/mydac',
      {$IFDEF VER9}'mydac9.exe'{$ENDIF}
      {$IFDEF VER10}'mydac10.exe'{$ENDIF}
      {$IFDEF VER11}'mydac11.exe'{$ENDIF},
      AtomName)
  end    
  else
    SetToolsCheckingParams(sDevToolsDownloadCaption, sDevToolsName, sMydacVersion,
      sDevAskIncompatible + AskStr, sDevAskNoAddin + AskStr,
      'Software\Devart\mydac', 'Mydac', 'MySQLDeveloper',
      'www.devart.com/mysqldevtools',
      {$IFDEF VER9}'mysqldevbds3dac.exe'{$ENDIF}
      {$IFDEF VER10}'mysqldevbds4dac.exe'{$ENDIF}
      {$IFDEF VER11}'mysqldevbds5dac.exe'{$ENDIF},
      AtomName{$IFDEF PRO}, 'MyDAC Developer Edition'{$ENDIF});
end;
{$ENDIF}

initialization
{$IFDEF VER8}
  TMyDesignUtils := TMyDesignUtilsAlias.Create;
{$ENDIF}
{$IFDEF DBTOOLS}
  DBTools.CheckDevTools(MySqlServiceCLSIDs, MySqlProviderKey, TMyDesignUtils, MySQLServiceVersion);
{$ENDIF}

finalization
{$IFDEF VER8}
  TMyDesignUtils.Free;
{$ENDIF}
{$IFDEF DBTOOLS}
  FreeAndNil(MySqlService);
{$ENDIF}

end.
