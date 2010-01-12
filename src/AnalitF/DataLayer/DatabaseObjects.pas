unit DatabaseObjects;

interface

uses
  SysUtils, Classes, Contnrs, StrUtils,
  U_ExchangeLog, AProc,
  MyAccess, MyServerControl;

const
  //������� ������ ���� ������ ��� ������ ��������
  CURRENT_DB_VERSION = 54;
  SDirData = 'Data';
  SDirDataTmpDir = 'DataTmpDir';
  SDirTableBackup = 'TableBackup';
  //SDirDataEtalon = 'DataEtalon';
  SDirDataBackup = 'DataBackup';
  SDirDataPrev   = 'DataPrev';

  DataFileExtention = '.DBD';
  IndexFileExtention = '.DBI';
  StructFileExtention = '.index';

  WorkSchema = 'analitf';

  TestSchema = 'getName';

  BackupFileFlag = 'IsAnalitF.bak';

type
  TDatabaseObjectRepairType = (
    dortCritical,
    dortBackup,
    dortCumulative,
    dortGetPrice,
    dortIgnore);
  TDatabaseObjectId = (
    //Critical
    doiParams,
    //Backup
    doiRetailMargins,
    doiOrdersHead,
    doiOrdersList,
    doiReceivedDocs,
    //Cumulative
    doiUserInfo,
    doiClient,
    doiClients,
    doiDefectives,
    doiProviders,
    doiRegions,
    doiRegionalData,
    doiPricesData,
    doiPricesRegionalData,
    doiDelayOfPayments,
    doiCatalogNames,
    doiCatalogFarmGroups,
    doiCatalogs,
    doiProducts,
    doiCore,
    doiMinPrices,
    //GetPrice
    doiSynonyms,
    doiSynonymFirmCr,
    //Ignore
    doiPricesRegionalDataUp,
    doiTmpClients,
    doiTmpRegions,
    doiTmpProviders,
    doiTmpRegionalData,
    doiTmpPricesData,
    doiTmpPricesRegionalData,
    doiPricesShow,
    doiClientAvg);

  TRepairedObjects = set of TDatabaseObjectId;

  TDatabaseObject = class
   protected
    FName : String;
    FObjectId : TDatabaseObjectId;
    FFileSystemName : String;
    FRepairType : TDatabaseObjectRepairType;
    procedure SetName(Value : String); virtual;
   public
    property Name : String read FName write SetName;
    property ObjectId : TDatabaseObjectId read FObjectId;
    property FileSystemName : String read FFileSystemName write FFileSystemName;
    property RepairType : TDatabaseObjectRepairType read FRepairType;
    function GetDropSQL(DatabasePrefix : String = '') : String; virtual; abstract;
    function GetCreateSQL(DatabasePrefix : String = '') : String; virtual; abstract;
  end;

  TDatabaseTable = class(TDatabaseObject)
   public
    function GetInsertSQL(DatabasePrefix : String = '') : String; virtual;
    function GetDropSQL(DatabasePrefix : String = '') : String; override;
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TDatabaseView = class(TDatabaseObject)
   public
    function GetDropSQL(DatabasePrefix : String = '') : String; override;
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TDatabaseController = class
   private
    FDatabaseObjects : TObjectList;
    FInitialized : Boolean;
    FCommand : TMyQuery;
    function GetFirstFileNameFromDir(DirName : String): String;
    function CheckTable(table : TDatabaseTable; WithOptimize : Boolean = False) : Boolean;
   public
    property DatabaseObjects : TObjectList read FDatabaseObjects;

    constructor Create();
    destructor Destroy; override;

    procedure AddObject(DatabaseObject : TDatabaseObject);

    procedure Initialize(connection : TCustomMyConnection);

    procedure CreateViews(connection : TCustomMyConnection);

    function CheckObjects(connection : TCustomMyConnection) : TRepairedObjects;

    procedure OptimizeObjects(connection : TCustomMyConnection);

    property Initialized : Boolean read FInitialized;

    function FindById(id : TDatabaseObjectId) : TDatabaseObject;

    function GetById(id : TDatabaseObjectId) : TDatabaseObject;

    function TableExists(tableName : String) : Boolean;

    procedure BackupDataTable(ObjectId : TDatabaseObjectId);


    //������ ��� ������ � backup-�� ��� �������������� ������
    function IsBackuped : Boolean;
    procedure ClearBackup;
    procedure BackupDatabase;
    procedure RestoreDatabase;
  end;

  function DatabaseController : TDatabaseController;

implementation

var
  FDatabaseController : TDatabaseController;

function DatabaseController : TDatabaseController;
begin
  Result := FDatabaseController;
end;

function CompareObjects(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(TDatabaseObject(Item1).ObjectId) - Integer(TDatabaseObject(Item2).ObjectId);
end;


{ TDatabaseObject }

procedure TDatabaseObject.SetName(Value: String);
begin
  FName := Value;
end;

{ TDatabaseController }

procedure TDatabaseController.AddObject(DatabaseObject: TDatabaseObject);
begin
  if Assigned(FindById(DatabaseObject.ObjectId)) then
    raise Exception.CreateFmt(
      '������ %s ��� �������� � ������.',
      [DatabaseObject.Name]);
  FDatabaseObjects.Add(DatabaseObject);
  FDatabaseObjects.Sort(CompareObjects);
end;

procedure TDatabaseController.BackupDatabase;
var
  stream : TFileStream;
begin
{
  if MainConnection is TMyEmbConnection then begin
    MainConnection.Close;
    //drop database mysql
    CopyDataDirToBackup(ExePath + SDirData, ExePath + SDirDataBackup);
    MainConnection.Open;
  end;
}
  if not FileExists(ExePath + BackupFileFlag) then begin
    stream := TFileStream.Create(ExePath + BackupFileFlag, fmCreate);
    stream.Free;
  end;
end;

procedure TDatabaseController.BackupDataTable(ObjectId: TDatabaseObjectId);
var
  backupTable : TDatabaseTable;

  procedure backupFileName(fileName : String);
  begin
    try
      OSCopyFile(
        ExePath + SDirData + '\' + WorkSchema + '\' + fileName,
        ExePath + SDirTableBackup + '\' + fileName);
    except
      on E : Exception do
        WriteExchangeLog(
          'DatabaseController.BackupDataTable',
          Format('�� ���������� ������� backup ���� %s ��� ������� %s: %s',
          [fileName,
          backupTable.Name,
          E.Message]));
    end;
  end;
begin
  backupTable := TDatabaseTable(GetById(ObjectId));
  if Length(backupTable.FileSystemName) > 0 then begin
    backupFileName(backupTable.FileSystemName + DataFileExtention);
    backupFileName(backupTable.FileSystemName + IndexFileExtention);
    backupFileName(backupTable.FileSystemName + StructFileExtention);
  end
end;

function TDatabaseController.CheckObjects(
  connection: TCustomMyConnection) : TRepairedObjects;
var
  I : Integer;
  currentTable : TDatabaseTable;
begin
  Result := [];
  FCommand.Connection := connection;
  try
    for I := 0 to FDatabaseObjects.Count-1 do
      if (FDatabaseObjects[i] is TDatabaseTable) then begin
        currentTable := TDatabaseTable(FDatabaseObjects[i]);
        if CheckTable(currentTable) then
          Result := Result + [currentTable.ObjectId];
      end;
  finally
    FCommand.Connection := nil;
  end;
end;

function TDatabaseController.CheckTable(table: TDatabaseTable;
  WithOptimize: Boolean): Boolean;
var
  MyServerControl : TMyServerControl;
  LastType,
  LastText : String;
  NeedRepair : Boolean;

  procedure LogError(E : Exception; method : String; tableName : String);
  begin
    WriteExchangeLog('DatabaseController.CheckTable',
      Format('������ ��� ������ � ��������: %s; ��������: %s; '
        + '��� ����������: %s; ������: %s',
        [tableName, method, e.ClassName, E.Message]));
  end;

  function LastOperationFailed() : Boolean;
  begin
    Result := False;
    if not MyServerControl.Eof then
      if Assigned(MyServerControl.FindField('Msg_type'))
        and Assigned(MyServerControl.FindField('Msg_text'))
        and Assigned(MyServerControl.FindField('Op'))
        and Assigned(MyServerControl.FindField('Table'))
      then
        if (AnsiCompareText(MyServerControl
              .FieldByName('Msg_type').AsString, 'status') <> 0)
          or (AnsiCompareText(MyServerControl
              .FieldByName('Msg_text').AsString, 'OK') <> 0)
        then begin
          Result := True;
          LastType := MyServerControl.FieldByName('Msg_type').AsString;
          LastText := MyServerControl.FieldByName('Msg_text').AsString;
          WriteExchangeLog('DatabaseController.CheckTable',
            Format('������ ��� ������ � ��������: %s; ��������: %s; '
              + '���: %s; ���������: %s',
              [MyServerControl.FieldByName('Table').AsString,
               MyServerControl.FieldByName('Op').AsString,
               MyServerControl.FieldByName('Msg_type').AsString,
               MyServerControl.FieldByName('Msg_text').AsString]));
        end;
  end;

  procedure DropTable();
  var
    FileDropped : Boolean;
  begin
    FileDropped := False;
    if Length(table.FileSystemName) > 0 then
      try
        DeleteFilesByMask(ExePath + SDirData + '\' + WorkSchema + '\'
          + table.FileSystemName + '.*');
        FileDropped := True;
      except
        on E : Exception do
          WriteExchangeLog('DatabaseController.CheckTable',
            Format('������ ��� ���������� �������� ������� %s: %s',
            [table.Name,
            E.Message]));
      end;
    if not FileDropped then
      try
        FCommand.SQL.Text := table.GetDropSQL(WorkSchema);
        FCommand.Execute;
      except
        on E : Exception do
          WriteExchangeLog('DatabaseController.CheckTable',
            Format('������ ��� �������� ������� %s: %s',
            [table.Name,
            E.Message]));
      end;
  end;

  procedure SimpleRepairTable();
  begin
    DropTable();
    FCommand.SQL.Text := table.GetCreateSQL(WorkSchema);
    FCommand.Execute;
  end;

  procedure RepairTable();
  var
    dataFileName : String;
    NeedRepairFromBackup : Boolean;
    NeedInsertData : Boolean;
  begin
    if table.RepairType = dortIgnore then
      SimpleRepairTable()
    else begin
      NeedRepairFromBackup := False;
      //���� ���� � ������� ����������, �� �������� �������������� � ����
      if FileExists(ExePath + SDirData + '\' + WorkSchema + '\'
          + table.FileSystemName + DataFileExtention)
      then begin
        OSMoveFile(
          ExePath + SDirData + '\' + WorkSchema + '\'
          + table.FileSystemName + DataFileExtention,
          ExePath + SDirDataTmpDir + '\'
          + table.FileSystemName + DataFileExtention);
        try
          SimpleRepairTable();
          OSMoveFile(
            ExePath + SDirDataTmpDir + '\'
            + table.FileSystemName + DataFileExtention,
            ExePath + SDirData + '\' + WorkSchema + '\'
            + table.FileSystemName + DataFileExtention);
          try
          {
            MyServerControl.RepairTable([rtExtended, rtUseFrm]);
            NeedRepairFromBackup := LastOperationFailed();
          } 
            MyServerControl.CheckTable([ctExtended]);
            NeedRepairFromBackup := LastOperationFailed();
          except
            on E : Exception do
              LogError(E, 'check', table.Name);
          end;
        finally
          if FileExists(ExePath + SDirDataTmpDir + '\'
                + table.FileSystemName + DataFileExtention)
          then
            OSDeleteFile(ExePath + SDirDataTmpDir + '\'
            + table.FileSystemName + DataFileExtention, False);
        end;
      end;
      if NeedRepairFromBackup then begin
        SimpleRepairTable();
        if table.RepairType in [dortCritical, dortBackup] then begin
          NeedInsertData := not FileExists(ExePath + SDirTableBackup + '\'
            + table.FileSystemName + DataFileExtention);
          if not NeedInsertData
          then begin
            OSCopyFile(
              ExePath + SDirTableBackup + '\'
              + table.FileSystemName + DataFileExtention,
              ExePath + SDirData + '\' + WorkSchema + '\'
              + table.FileSystemName + DataFileExtention);
            try
              MyServerControl.RepairTable([rtExtended, rtUseFrm]);
              if LastOperationFailed() then begin
                SimpleRepairTable();
                NeedInsertData := True;
              end;
            except
              on E : Exception do
                LogError(E, 'check', table.Name);
            end;
          end;
          if NeedInsertData then begin
            FCommand.SQL.Text := table.GetInsertSQL(WorkSchema);
            if Length(FCommand.SQL.Text) > 0 then
              FCommand.Execute;
          end;
        end;
      end;
    end;
  end;

begin
  Result := False;
  NeedRepair := False;
  MyServerControl := TMyServerControl.Create(nil);
  try
    MyServerControl.Connection := FCommand.Connection;
    MyServerControl.TableNames := WorkSchema + '.' + table.Name;
    try
      MyServerControl.CheckTable([ctExtended]);
      NeedRepair := LastOperationFailed();
    except
      on E : Exception do
        LogError(E, 'check', table.Name);
    end;

    if NeedRepair then begin
      Result := True;
      RepairTable();
    end;
{
      try
        MyServerControl.RepairTable([rtExtended, rtUseFrm]);
        if LastOperationFailed() then begin
          Exit;
        end;
      except
        on E : Exception do
          LogError(E, 'check', table.Name);
      end;
}      

    if not NeedRepair and WithOptimize then
      try
        MyServerControl.OptimizeTable();
        LastOperationFailed();
      except
        on E : Exception do
          LogError(E, 'check', table.Name);
      end;
  finally
    MyServerControl.Free;
  end;
end;

procedure TDatabaseController.ClearBackup;
begin
{
  if MainConnection is TMyEmbConnection then
  begin
    DeleteDirectory(ExePath + SDirDataPrev);
    MoveDirectories(ExePath + SDirDataBackup, ExePath + SDirDataPrev);
  end;
}
  OSDeleteFile(ExePath + BackupFileFlag);
end;

constructor TDatabaseController.Create;
begin
  FDatabaseObjects := TObjectList.Create(True);
  FCommand := TMyQuery.Create(nil);
end;

procedure TDatabaseController.CreateViews(connection: TCustomMyConnection);
var
  I : Integer;
begin
  FCommand.Connection := connection;
  try
    for I := 0 to FDatabaseObjects.Count-1 do
      if FDatabaseObjects[i] is TDatabaseView then begin
        FCommand.SQL.Text := TDatabaseView(FDatabaseObjects[i]).GetDropSQL();
        FCommand.Execute;
        FCommand.SQL.Text := TDatabaseView(FDatabaseObjects[i]).GetCreateSQL();
        FCommand.Execute;
      end;
  finally
    FCommand.Connection := nil;
  end;
end;

destructor TDatabaseController.Destroy;
begin
  FCommand.Free;
  FDatabaseObjects.Free;
  inherited;
end;

function TDatabaseController.FindById(
  id: TDatabaseObjectId): TDatabaseObject;
var
  I : Integer;
begin
  for I := 0 to FDatabaseObjects.Count-1 do
    if TDatabaseObject(FDatabaseObjects[i]).ObjectId = id then begin
      Result := TDatabaseObject(FDatabaseObjects[i]);
      Exit;
    end;
  Result := nil;
end;

function TDatabaseController.GetById(
  id: TDatabaseObjectId): TDatabaseObject;
begin
  if Integer(id) >= FDatabaseObjects.Count then
    raise Exception.CreateFmt(
      '������� ���������� � ��������������� ������� ���� ������: %d',
      [Integer(id)]);
  Result := TDatabaseObject(FDatabaseObjects[Integer(id)]);
  if Result.ObjectId <> id then
    raise Exception.CreateFmt(
      '������� �� ��� ������ ���� ������: ���������: %d  �������: %d',
      [Integer(id),
      Integer(Result.ObjectId)]);
end;

function TDatabaseController.GetFirstFileNameFromDir(
  DirName: String): String;
var
  SR: TSearchrec;
begin
  try
    if SysUtils.FindFirst(DirName + '\*.*', faAnyFile-faDirectory,SR)=0
    then begin
      Result := ChangeFileExt(SR.Name, '');
      Exit;
    end;
  finally
    SysUtils.FindClose(SR);
  end;
  Result := '';
end;

procedure TDatabaseController.Initialize(connection: TCustomMyConnection);
var
  I : Integer;
  MyServerControl : TMyServerControl;
  currentTable : TDatabaseTable;
begin
  FCommand.Connection := connection;
  try
    if FDatabaseObjects.Count <> (Integer(High(TDatabaseObjectId))+1) then
      raise Exception.CreateFmt(
        '�� �������� ���-�� �������� � ���������: ������: %d  ����: %d',
        [Integer(High(TDatabaseObjectId))+1,
        FDatabaseObjects.Count]);

    if not DirectoryExists(ExePath + SDirData + '\' + TestSchema) then
      CreateDir(ExePath + SDirData + '\' + TestSchema);
    try
      for I := 0 to FDatabaseObjects.Count-1 do begin
        if FDatabaseObjects[i] is TDatabaseTable then begin
          currentTable := TDatabaseTable(FDatabaseObjects[i]);
          FCommand.SQL.Text := currentTable.GetDropSQL(TestSchema);
          FCommand.Execute;
          FCommand.SQL.Text := currentTable.GetCreateSQL(TestSchema);
          FCommand.Execute;
          currentTable.FileSystemName := GetFirstFileNameFromDir(ExePath + SDirData + '\' + TestSchema);
          if Length(currentTable.FileSystemName) = 0 then
            WriteExchangeLog('DatabaseController.Initialize', '�� ������� �������� FileSystemName ��� ������� ' + currentTable.Name);
          FCommand.SQL.Text := currentTable.GetDropSQL(TestSchema);
          FCommand.Execute;
        end;
      end;
    finally
      DeleteDirectory(ExePath + SDirData + '\' + TestSchema);
    end;

    FInitialized := True;
  finally
    FCommand.Connection := nil;
  end;
end;

function TDatabaseController.IsBackuped: Boolean;
begin
{
  if MainConnection is TMyEmbConnection then
    Result := DirectoryExists(ExePath + SDirDataBackup)
  else
    Result := False;
}
  Result := FileExists(ExePath + BackupFileFlag);    
end;

procedure TDatabaseController.OptimizeObjects(
  connection: TCustomMyConnection);
var
  I : Integer;
  currentTable : TDatabaseTable;
begin
  FCommand.Connection := connection;
  try
    for I := 0 to FDatabaseObjects.Count-1 do
      if (FDatabaseObjects[i] is TDatabaseTable) then begin
        currentTable := TDatabaseTable(FDatabaseObjects[i]);
        CheckTable(currentTable, True);
      end;
    try
      connection.ExecSQL('update params set LastCompact = :LastCompact where ID = 0', [Now]);
    except
      on E : Exception do
        WriteExchangeLog('DatabaseController.OptimizeObjects', '�� ���������� �������� LastCompact: ' + E.Message);
    end;
  finally
    FCommand.Connection := nil;
  end;
end;

procedure TDatabaseController.RestoreDatabase;
begin
{
var
  FEmbConnection : TMyEmbConnection;
  MyServerControl : TMyServerControl;
begin
  if MainConnection is TMyEmbConnection then begin
    MainConnection.Close;

    FEmbConnection := TMyEmbConnection.Create(nil);
    try
      FEmbConnection.Database := MainConnection.Database;
      FEmbConnection.Username := MainConnection.Username;
      FEmbConnection.DataDir := TMyEmbConnection(MainConnection).DataDir;
      FEmbConnection.Options := TMyEmbConnection(MainConnection).Options;
      FEmbConnection.Params.Clear;
      FEmbConnection.Params.AddStrings(TMyEmbConnection(MainConnection).Params);
      FEmbConnection.LoginPrompt := False;
      try
        MyServerControl := TMyServerControl.Create(nil);
        try
          MyServerControl.Connection := FEmbConnection;
          MyServerControl.DropDatabase('analitf');
          MyServerControl.DropDatabase('mysql');
        finally
          MyServerControl.Free;
        end;
      finally
        FEmbConnection.Close;
        //FEmbConnection.RemoveFromPool;
      end;
    finally
      FEmbConnection.Free;
    end;
    
    //������� ����������
    DeleteDataDir(ExePath + SDirData);

    //�������� ������ �� ��������� �����
    MoveDirectories(ExePath + SDirDataBackup, ExePath + SDirData);
    
    MainConnection.Open;
  end;
end;
}
  OSDeleteFile(ExePath + BackupFileFlag);
end;

function TDatabaseController.TableExists(tableName: String): Boolean;
var
  I : Integer;
begin
  for I := 0 to FDatabaseObjects.Count-1 do
    if (FDatabaseObjects[i] is TDatabaseTable)
      and (AnsiCompareText(TDatabaseObject(FDatabaseObjects[i]).Name, tableName) = 0)
    then begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

{ TDatabaseTable }

function TDatabaseTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := ''
+'create table '
+IfThen(Length(DatabasePrefix) > 0, DatabasePrefix + '.')
+FName;
end;

function TDatabaseTable.GetDropSQL(DatabasePrefix: String): String;
begin
  Result := 'drop table if exists '
    + IfThen(Length(DatabasePrefix) > 0, DatabasePrefix + '.')
    + FName + ';';
end;

function TDatabaseTable.GetInsertSQL(DatabasePrefix: String): String;
begin
  Result := '';
end;

{ TDatabaseView }

function TDatabaseView.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := ''
+'create temporary table '
+IfThen(Length(DatabasePrefix) > 0, DatabasePrefix + '.')
+FName
+' ENGINE=MEMORY as ';
end;

function TDatabaseView.GetDropSQL(DatabasePrefix: String): String;
begin
  Result := 'drop temporary table if exists '
    + IfThen(Length(DatabasePrefix) > 0, DatabasePrefix + '.')
    + FName + ';';
end;

initialization
  FDatabaseController := TDatabaseController.Create();
end.
