unit DatabaseObjects;

interface

uses
  SysUtils, Classes, Contnrs, StrUtils,
  U_ExchangeLog, AProc,
  MyAccess, MyServerControl,
  MyClasses,
  MyCall;

{$ifdef USEMEMORYCRYPTDLL}
  {$ifndef USENEWMYSQLTYPES}
    {$define USENEWMYSQLTYPES}
  {$endif}
{$endif}

const
  //Текущая версия базы данных для работы программ
  CURRENT_DB_VERSION = 64;
  SDirData = 'Data';
  SDirDataTmpDir = 'DataTmpDir';
  SDirTableBackup = 'TableBackup';
  SDirDataBackup = 'DataBackup';
  SDirDataPrev   = 'DataPrev';
  SDirUpload     = 'Загрузка';

{$ifndef USENEWMYSQLTYPES}
  DataFileExtention = '.MYD';
  IndexFileExtention = '.MYI';
  StructFileExtention = '.frm';
{$else}
  DataFileExtention = '.dbf';
  IndexFileExtention = '.idx';
  StructFileExtention = '.index';
{$endif}

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
    doiPostedOrderHeads,
    doiPostedOrderLists,
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
    doiClientAvg,
    //Cumulative
    doiMNN,
    doiDescriptions,
    //Backup
    doiDocumentHeaders,
    doiDocumentBodies,
    doiVitallyImportantMarkups,
    doiProviderSettings,
    //Cumulative
    doiMaxProducerCosts,
    //Backup
    doiClientSettings,
    doiCurrentOrderHeads,
    doiCurrentOrderLists,
    //Cumulative
    doiProducers,
    //Ignore
    doiGroupMaxProducerCosts,
    //Cumulative
    doiMinReqRules,
    //Ignore
    doiBatchReport);

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
   protected
     FNeedCompact : Boolean;
     function GetTableOptions() : String; virtual;
     function LogObjectName : String;
   public
    property NeedCompact : Boolean read FNeedCompact;
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
    function ParseMethodResuls(ServiceControl : TMyServerControl; LogObjectName : String) : Boolean;
    function CheckTable(table : TDatabaseTable; WithOptimize : Boolean = False) : Boolean;
    function CheckTableOnOpen(table : TDatabaseTable; IsBackupRepair : Boolean) : Boolean;
    procedure OptimizeTable(table : TDatabaseTable);
   public
    property DatabaseObjects : TObjectList read FDatabaseObjects;

    constructor Create();
    destructor Destroy; override;

    procedure AddObject(DatabaseObject : TDatabaseObject);

    procedure Initialize(connection : TCustomMyConnection);

    procedure CreateViews(connection : TCustomMyConnection);

    procedure CheckObjectsExists(connection : TCustomMyConnection; IsBackupRepair : Boolean);

    procedure RepairTableFromBackup(backupDir : String = '');

    function CheckObjects(connection : TCustomMyConnection) : TRepairedObjects;

    procedure OptimizeObjects(connection : TCustomMyConnection);

    property Initialized : Boolean read FInitialized;

    function FindById(id : TDatabaseObjectId) : TDatabaseObject;

    function GetById(id : TDatabaseObjectId) : TDatabaseObject;

    function TableExists(tableName : String) : Boolean;

    procedure BackupDataTable(ObjectId : TDatabaseObjectId);


    //Методы для работы с backup-ом при импортировании данных
    function IsBackuped : Boolean;
    procedure ClearBackup;
    procedure BackupDatabase;
    procedure RestoreDatabase;

    function GetLastCreateScript : String;
    function GetFullLastCreateScript(DBVersion : String = '') : String;
  end;

  function DatabaseController : TDatabaseController;

implementation

uses
  DModule, MyEmbConnection;

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
      'Объект %s уже добавлен в список.',
      [DatabaseObject.Name]);
  FDatabaseObjects.Add(DatabaseObject);
  FDatabaseObjects.Sort(CompareObjects);
end;

procedure TDatabaseController.BackupDatabase;
{
var
  stream : TFileStream;
}  
begin
  if DM.MainConnection is TMyEmbConnection then begin
    DM.MainConnection.Close;
    CopyDataDirToBackup(ExePath + SDirData, ExePath + SDirDataBackup);
    DM.MainConnection.Open;
  end;
{
  if not FileExists(ExePath + BackupFileFlag) then begin
    stream := TFileStream.Create(ExePath + BackupFileFlag, fmCreate);
    stream.Free;
  end;
}  
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
          Format('Не получилось сделать backup файл %s для таблицы %s: %s',
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
  WriteExchangeLog('DatabaseController', 'Производим восстановление базы данных');
  try
    for I := 0 to FDatabaseObjects.Count-1 do
      if (FDatabaseObjects[i] is TDatabaseTable) then begin
        currentTable := TDatabaseTable(FDatabaseObjects[i]);
        if CheckTable(currentTable) then
        begin
          if currentTable.RepairType = dortCumulative then
            Result := Result + [currentTable.ObjectId];
          WriteExchangeLog('DatabaseController', 'Произведено восстановление объекта : ' + currentTable.LogObjectName);
        end;
      end;
  finally
    FCommand.Connection := nil;
    WriteExchangeLog('DatabaseController', 'Восстановление базы данных завершено');
  end;
end;

procedure TDatabaseController.CheckObjectsExists(
  connection: TCustomMyConnection;
  IsBackupRepair : Boolean);
var
  I : Integer;
  currentTable : TDatabaseTable;
begin
  FCommand.Connection := connection;
  try
    //Если не существует еще самой директории с базой данных, то нечего проверять
    if not DirectoryExists(ExePath + SDirData + '\analitf') then
      Exit;

    for I := 0 to FDatabaseObjects.Count-1 do begin
      if FDatabaseObjects[i] is TDatabaseTable then begin
        currentTable := TDatabaseTable(FDatabaseObjects[i]);
        FCommand.SQL.Text :=
          Format(
            'SELECT * from analitf.%s limit 100;',
            [AnsiLowerCase(currentTable.Name)]);
        try
          FCommand.Open;
          FCommand.Close;
        except
          on E : EMyError do
            if E.ErrorCode = ER_NO_SUCH_TABLE then
              raise
            else begin
              WriteExchangeLog(
                'DatabaseController.CheckObjectsExists',
                Format('Производим попытку восстановления объекта %s, т.к. при проверке была получена ошибка (%d): %s',
                [currentTable.LogObjectName,
                 E.ErrorCode,
                 E.Message]));
            end;
        end;

        CheckTableOnOpen(currentTable, IsBackupRepair);
{
        try
          if (FCommand.RecordCount = 1) then begin
            if (FCommand.Fields.Count = 1) then
              currentTable.FileSystemName := FCommand.Fields[0].AsString
            else
              WriteExchangeLog(
                'DatabaseController.Initialize',
                'Не удалось получить FileSystemName для объекта ' + currentTable.Name  + ', т.к. кол-во полей не равно 1.');
          end
          else
            WriteExchangeLog(
              'DatabaseController.Initialize',
              'Не удалось получить FileSystemName для объекта ' + currentTable.Name  + ', т.к. функция не отработала.');
        finally
          FCommand.Close;
        end;
}        

      end;
    end;

    FInitialized := True;
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
      Format('Ошибка при работе с таблицей: %s; действие: %s; '
        + 'тип исключения: %s; ошибка: %s',
        [tableName, method, e.ClassName, E.Message]));
  end;

{
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
            Format('Статус при работе с таблицей: %s; действие: %s; '
              + 'тип: %s; сообщение: %s',
              [MyServerControl.FieldByName('Table').AsString,
               MyServerControl.FieldByName('Op').AsString,
               MyServerControl.FieldByName('Msg_type').AsString,
               MyServerControl.FieldByName('Msg_text').AsString]));
        end;
  end;
}  

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
            Format('Ошибка при физическом удалении таблицы %s: %s',
            [table.LogObjectName,
            E.Message]));
      end;
    if not FileDropped then
      try
        FCommand.SQL.Text := table.GetDropSQL(WorkSchema);
        FCommand.Execute;
      except
        on E : Exception do
          WriteExchangeLog('DatabaseController.CheckTable',
            Format('Ошибка при удалении таблицы %s: %s',
            [table.LogObjectName,
            E.Message]));
      end;
  end;

  procedure SimpleRepairTable();
  begin
    DropTable();
    FCommand.SQL.Text := table.GetCreateSQL(WorkSchema);
    FCommand.Execute;
    WriteExchangeLog('DatabaseController.CheckTable',
      Format('Объект %s был пересоздан', [table.LogObjectName]));
  end;

  procedure RepairTable();
  var
    //dataFileName : String;
    NeedRepairFromBackup : Boolean;
    NeedInsertData : Boolean;
  begin
    if table.RepairType = dortIgnore then
      SimpleRepairTable()
    else begin
      MyServerControl.RepairTable([rtExtended]);
      NeedRepairFromBackup := ParseMethodResuls(MyServerControl, table.LogObjectName);

      if not NeedRepairFromBackup then begin
        MyServerControl.RepairTable([rtExtended, rtUseFrm]);
        NeedRepairFromBackup := ParseMethodResuls(MyServerControl, table.LogObjectName);

        if not NeedRepairFromBackup then begin
          if (table.RepairType in [dortCritical, dortBackup])
            and FileExists(ExePath + SDirTableBackup + '\'
              + table.FileSystemName + DataFileExtention)
            and FileExists(ExePath + SDirTableBackup + '\'
              + table.FileSystemName + IndexFileExtention)
            and FileExists(ExePath + SDirTableBackup + '\'
              + table.FileSystemName + StructFileExtention)
          then begin
            OSCopyFile(
              ExePath + SDirTableBackup + '\'
              + table.FileSystemName + DataFileExtention,
              ExePath + SDirData + '\' + WorkSchema + '\'
              + table.FileSystemName + DataFileExtention);
            OSCopyFile(
              ExePath + SDirTableBackup + '\'
              + table.FileSystemName + IndexFileExtention,
              ExePath + SDirData + '\' + WorkSchema + '\'
              + table.FileSystemName + IndexFileExtention);
            OSCopyFile(
              ExePath + SDirTableBackup + '\'
              + table.FileSystemName + StructFileExtention,
              ExePath + SDirData + '\' + WorkSchema + '\'
              + table.FileSystemName + StructFileExtention);
            WriteExchangeLog('DatabaseController.CheckTable',
              Format('Объект %s был восстановлен из backupа', [table.LogObjectName]));
          end
          else
            SimpleRepairTable();
        end;
      end

{

      NeedRepairFromBackup := False;
      //Если файл с данными существует, то пытаемся восстановиться с него
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

            //MyServerControl.RepairTable([rtExtended, rtUseFrm]);
            //NeedRepairFromBackup := LastOperationFailed();

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
}      

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
      NeedRepair := ParseMethodResuls(MyServerControl, table.LogObjectName);
    except
      on E : Exception do
        LogError(E, 'check', table.LogObjectName);
    end;

    if not NeedRepair then begin
      Result := True;
      try
        RepairTable();
      except
        on E : Exception do
          LogError(E, 'repair', table.LogObjectName);
      end;
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

{
    if not NeedRepair and WithOptimize then
      try
        MyServerControl.OptimizeTable();
        LastOperationFailed();
      except
        on E : Exception do
          LogError(E, 'check', table.Name);
      end;
}
  finally
    MyServerControl.Free;
  end;
end;

function TDatabaseController.CheckTableOnOpen(table: TDatabaseTable;
  IsBackupRepair: Boolean): Boolean;
var
  MyServerControl : TMyServerControl;
  LastType,
  LastText : String;
  NeedRepair : Boolean;

  procedure LogError(E : Exception; method : String; tableName : String);
  begin
    WriteExchangeLog('DatabaseController.CheckTable',
      Format('Ошибка при работе с таблицей: %s; действие: %s; '
        + 'тип исключения: %s; ошибка: %s',
        [tableName, method, e.ClassName, E.Message]));
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
            Format('Ошибка при физическом удалении таблицы %s: %s',
            [table.LogObjectName,
            E.Message]));
      end;
    if not FileDropped then
      try
        FCommand.SQL.Text := table.GetDropSQL(WorkSchema);
        FCommand.Execute;
      except
        on E : Exception do
          WriteExchangeLog('DatabaseController.CheckTable',
            Format('Ошибка при удалении таблицы %s: %s',
            [table.LogObjectName,
            E.Message]));
      end;
  end;

  procedure SimpleRepairTable();
  begin
    DropTable();
    FCommand.SQL.Text := table.GetCreateSQL(WorkSchema);
    FCommand.Execute;
    WriteExchangeLog('DatabaseController.CheckTable',
      Format('Объект %s был пересоздан', [table.LogObjectName]));
  end;

  procedure RepairTable();
  var
    //dataFileName : String;
    NeedRepairFromBackup : Boolean;
    NeedInsertData : Boolean;
  begin
    if table.RepairType = dortIgnore then
      SimpleRepairTable()
    else begin
      MyServerControl.RepairTable([rtExtended]);
      NeedRepairFromBackup := ParseMethodResuls(MyServerControl, table.LogObjectName);

      if not NeedRepairFromBackup then begin
        MyServerControl.RepairTable([rtExtended, rtUseFrm]);
        NeedRepairFromBackup := ParseMethodResuls(MyServerControl, table.LogObjectName);

        if not NeedRepairFromBackup then begin
          if (table.RepairType in [dortCritical, dortBackup]) then begin
            if IsBackupRepair then
              SimpleRepairTable()
            else begin

              if    FileExists(ExePath + SDirTableBackup + '\'
                  + table.FileSystemName + DataFileExtention)
                and FileExists(ExePath + SDirTableBackup + '\'
                  + table.FileSystemName + IndexFileExtention)
                and FileExists(ExePath + SDirTableBackup + '\'
                  + table.FileSystemName + StructFileExtention)
              then begin
                OSCopyFile(
                  ExePath + SDirTableBackup + '\'
                  + table.FileSystemName + DataFileExtention,
                  ExePath + SDirData + '\' + WorkSchema + '\'
                  + table.FileSystemName + DataFileExtention);
                OSCopyFile(
                  ExePath + SDirTableBackup + '\'
                  + table.FileSystemName + IndexFileExtention,
                  ExePath + SDirData + '\' + WorkSchema + '\'
                  + table.FileSystemName + IndexFileExtention);
                OSCopyFile(
                  ExePath + SDirTableBackup + '\'
                  + table.FileSystemName + StructFileExtention,
                  ExePath + SDirData + '\' + WorkSchema + '\'
                  + table.FileSystemName + StructFileExtention);

                MyServerControl.RepairTable([rtExtended, rtUseFrm]);
                NeedRepairFromBackup := ParseMethodResuls(MyServerControl, table.LogObjectName);
                if not NeedRepairFromBackup then begin
                  SimpleRepairTable();
                end
                else
                  WriteExchangeLog('DatabaseController.CheckTable',
                    Format('Объект %s был восстановлен из backupа', [table.LogObjectName]));
              end
              else
                SimpleRepairTable();

            end;
          end
          else begin
            raise Exception.Create('Ошибка при чтение объекта ' + table.LogObjectName);
          end;

        end;
      end

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
      MyServerControl.CheckTable([ctQuick]);
      NeedRepair := ParseMethodResuls(MyServerControl, table.LogObjectName);
    except
      on E : Exception do
        LogError(E, 'check', table.LogObjectName);
    end;

    if not NeedRepair then begin
      Result := True;
      try
        RepairTable();
      except
        on E : Exception do
          LogError(E, 'repair', table.LogObjectName);
      end;
    end;
  finally
    MyServerControl.Free;
  end;
end;

procedure TDatabaseController.ClearBackup;
begin
  if DM.MainConnection is TMyEmbConnection then begin
    DeleteDirectory(ExePath + SDirDataPrev);
    MoveDirectories(ExePath + SDirDataBackup, ExePath + SDirDataPrev);
  end;
  //OSDeleteFile(ExePath + BackupFileFlag);
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
      'Попытка обратиться к несуществующему объекту базы данных: %d',
      [Integer(id)]);
  Result := TDatabaseObject(FDatabaseObjects[Integer(id)]);
  if Result.ObjectId <> id then
    raise Exception.CreateFmt(
      'Получен не тот объект базы данных: ожидалось: %d  получен: %d',
      [Integer(id),
      Integer(Result.ObjectId)]);
end;

function TDatabaseController.GetFullLastCreateScript(
  DBVersion : String = ''): String;
var
  realDBVersion : String;
begin
  if Length(DBVersion) = 0 then
    realDBVersion := IntToStr(CURRENT_DB_VERSION)
  else
    realDBVersion := DBVersion;

  Result := GetLastCreateScript;
  
  Result := Concat(Result,
    #13#10#13#10 +
    'insert into analitf.params set ' +
    'Id = 0,' +
    'ClientId = null,' +
    'RasConnect = 0,' +
    'RasEntry = null,' +
    'RasName = null,' +
    'RasPass = null,' +
    'ConnectCount = 5,' +
    'ConnectPause = 5,' +
    'ProxyConnect = 0,' +
    'ProxyName = null,' +
    'ProxyPort = null,' +
    'ProxyUser = null,' +
    'ProxyPass = null,' +
    'HTTPHost = ''ios.analit.net'',' +
    'HTTPName = null,' +
    'HTTPPass = null,' +
    'UpdateDatetime = null,' +
    'LastDatetime = null,' +
    'ShowRegister = 1,' +
    'UseForms = 1,' +
    'OperateForms = 0,' +
    'OperateFormsSet = 0,' +
    'StartPage = 0,' +
    'LastCompact = null,' +
    'Cumulative = 0,' +
    'Started = 0,' +
    'RASSLEEP = 3,' +
    'HTTPNAMECHANGED = 1,' +
    'SHOWALLCATALOG = 0,' +
    'CDS = '''',' +
    'ORDERSHISTORYDAYCOUNT = 35,' +
    'CONFIRMDELETEOLDORDERS = 1,' +
    'USEOSOPENWAYBILL = 0,' +
    'USEOSOPENREJECT = 1,' +
    'GROUPBYPRODUCTS = 0,' +
    'PRINTORDERSAFTERSEND = 0,' +
    'ConfirmSendingOrders = 0,' +
    'UseCorrectOrders = 0,' +
    'ProviderName = ''АК "Инфорум"'',' +
    'ProviderAddress = ''Ленинский пр-т, 160 оф.415'',' +
    'ProviderPhones = ''4732-606000'',' +
    'ProviderEmail = ''farm@analit.net'',' +
    'ProviderWeb = ''http://www.analit.net/'',' +
    'ProviderMDBVersion = ' + realDBVersion + ';'#13#10#13#10 +
    'INSERT INTO RETAILMARGINS (ID, LeftLimit, RightLimit, Markup, MaxMarkup) VALUES (1, 0, 1000000, 30, 30);'#13#10#13#10 +
    'INSERT INTO VitallyImportantMarkups (ID, LeftLimit, RightLimit, Markup, MaxMarkup) VALUES (1, 0, 50, 20, 20);'#13#10#13#10  +
    'INSERT INTO VitallyImportantMarkups (ID, LeftLimit, RightLimit, Markup, MaxMarkup) VALUES (2, 50, 500, 20, 20);'#13#10#13#10 +
    'INSERT INTO VitallyImportantMarkups (ID, LeftLimit, RightLimit, Markup, MaxMarkup) VALUES (3, 500, 1000000, 20, 20);'#13#10#13#10
    );
end;

function TDatabaseController.GetLastCreateScript: String;
var
  I : Integer;
  currentTable : TDatabaseTable;
begin
  Result := '';
  for I := 0 to FDatabaseObjects.Count-1 do 
    if FDatabaseObjects[i] is TDatabaseTable then begin
      currentTable := TDatabaseTable(FDatabaseObjects[i]);
      Result := Concat(Result, #13#10#13#10, currentTable.GetDropSQL(), #13#10, currentTable.GetCreateSQL());
    end;
end;

procedure TDatabaseController.Initialize(connection: TCustomMyConnection);
var
  I : Integer;
  currentTable : TDatabaseTable;
begin
  FCommand.Connection := connection;
  try
    if FDatabaseObjects.Count <> (Integer(High(TDatabaseObjectId))+1) then
      raise Exception.CreateFmt(
        'Не сопадает кол-во объектов с заявленым: должно: %d  есть: %d',
        [Integer(High(TDatabaseObjectId))+1,
        FDatabaseObjects.Count]);

    //Если не существует еще самой директории с базой данных, то нечего проверять
    if not DirectoryExists(ExePath + SDirData + '\analitf') then
      Exit;

    for I := 0 to FDatabaseObjects.Count-1 do begin
      if FDatabaseObjects[i] is TDatabaseTable then begin
        currentTable := TDatabaseTable(FDatabaseObjects[i]);
        FCommand.SQL.Text :=
          Format(
            'SELECT PASSWORD(''%s'');',
            [AnsiLowerCase(currentTable.Name)]);
        FCommand.Open;
        try
          if (FCommand.RecordCount = 1) then begin
            if (FCommand.Fields.Count = 1) then
              currentTable.FileSystemName := FCommand.Fields[0].AsString
            else
              WriteExchangeLog(
                'DatabaseController.Initialize',
                'Не удалось получить FileSystemName для объекта ' + currentTable.Name  + ', т.к. кол-во полей не равно 1.');
          end
          else
            WriteExchangeLog(
              'DatabaseController.Initialize',
              'Не удалось получить FileSystemName для объекта ' + currentTable.Name  + ', т.к. функция не отработала.');
        finally
          FCommand.Close;
        end;
      end;
    end;

    FInitialized := True;
  finally
    FCommand.Connection := nil;
  end;
end;

function TDatabaseController.IsBackuped: Boolean;
begin
  if DM.MainConnection is TMyEmbConnection then
    Result := DirectoryExists(ExePath + SDirDataBackup)
  else
    Result := False;
  //Result := FileExists(ExePath + BackupFileFlag);
end;

procedure TDatabaseController.OptimizeObjects(
  connection: TCustomMyConnection);
var
  I : Integer;
  currentTable : TDatabaseTable;
begin
  FCommand.Connection := connection;
  WriteExchangeLog('DatabaseController.OptimizeObjects', 'Запуск оптимизации таблиц');
  try
    for I := 0 to FDatabaseObjects.Count-1 do
      if (FDatabaseObjects[i] is TDatabaseTable) then begin
        currentTable := TDatabaseTable(FDatabaseObjects[i]);
        if currentTable.NeedCompact then
          OptimizeTable(currentTable);
      end;
    try
      connection.ExecSQL('update params set LastCompact = :LastCompact where ID = 0', [Now]);
    except
      on E : Exception do
        WriteExchangeLog('DatabaseController.OptimizeObjects', 'Не получилось обновить LastCompact: ' + E.Message);
    end;
  finally
    FCommand.Connection := nil;
    WriteExchangeLog('DatabaseController.OptimizeObjects', 'Окончание оптимизации таблиц');
  end;
end;

procedure TDatabaseController.OptimizeTable(table: TDatabaseTable);
var
  MyServerControl : TMyServerControl;
begin
  MyServerControl := TMyServerControl.Create(nil);
  try
    MyServerControl.Connection := FCommand.Connection;
    MyServerControl.TableNames := WorkSchema + '.' + table.Name;
    MyServerControl.OptimizeTable();
    if ParseMethodResuls(MyServerControl, table.LogObjectName) then
      WriteExchangeLog('TDatabaseController.OptimizeTable',
        Format('Оптимизация объекта %s успешно завершена.', [table.LogObjectName]))
    else
      WriteExchangeLog('TDatabaseController.OptimizeTable',
        Format('Оптимизация объекта %s завершилась с ошибкой!', [table.LogObjectName]));
  finally
    MyServerControl.Free;
  end;
end;

function TDatabaseController.ParseMethodResuls(
  ServiceControl: TMyServerControl;
  LogObjectName : String): Boolean;
begin
  //Op
  //Msg_type
  //Msg_text
  if (ServiceControl.RecordCount > 0) then begin
    Result :=
      (ServiceControl.RecordCount = 1)
      and
      (AnsiCompareText(ServiceControl.FieldByName('Msg_type').AsString, 'status') = 0)
      and
        (
        (AnsiCompareText(ServiceControl
            .FieldByName('Msg_text').AsString, 'OK') = 0)
        or
        (AnsiCompareText(ServiceControl
            .FieldByName('Msg_text').AsString, 'Table is already up to date') = 0)
        );
    if not Result then begin
      WriteExchangeLog('DatabaseController.ParseMethodResuls',
            Format('Кол-во записей в статусе операции %s: %d для объекта: %s',
              [ServiceControl.FieldByName('Op').AsString,
               ServiceControl.RecordCount,
               LogObjectName])
      );

      while not ServiceControl.Eof do begin
        if
          (AnsiCompareText(ServiceControl.FieldByName('Msg_type').AsString, 'status') = 0)
            and
            (
            (AnsiCompareText(ServiceControl
                .FieldByName('Msg_text').AsString, 'OK') = 0)
            or
            (AnsiCompareText(ServiceControl
                .FieldByName('Msg_text').AsString, 'Table is already up to date') = 0)
            )
        then
          WriteExchangeLog('DatabaseController.ParseMethodResuls',
            Format('операция %s: успешно  тип сообщения: %s  сообщение: %s',
            [
             ServiceControl.FieldByName('Op').AsString,
             ServiceControl.FieldByName('Msg_type').AsString,
             ServiceControl.FieldByName('Msg_text').AsString]))
        else
          WriteExchangeLog('DatabaseController.ParseMethodResuls',
            Format('операция %s: тип сообщения: %s  сообщение: %s',
            [
             ServiceControl.FieldByName('Op').AsString,
             ServiceControl.FieldByName('Msg_type').AsString,
             ServiceControl.FieldByName('Msg_text').AsString]));
        ServiceControl.Next;
      end;

      Result :=
        (AnsiCompareText(ServiceControl.FieldByName('Msg_type').AsString, 'status') = 0)
          and
          (
          (AnsiCompareText(ServiceControl
              .FieldByName('Msg_text').AsString, 'OK') = 0)
          or
          (AnsiCompareText(ServiceControl
              .FieldByName('Msg_text').AsString, 'Table is already up to date') = 0)
          );
    end;
  end
  else begin
    WriteExchangeLog('DatabaseController.ParseMethodResuls',
      Format('Для таблицы %s вызов сервисного метода не вернул результатов.',
      [ServiceControl.TableNames]));
    Result := False;
  end;
end;

procedure TDatabaseController.RepairTableFromBackup(backupDir : String = '');
var
  I : Integer;
  currentTable : TDatabaseTable;
begin
  if Length(backupDir) = 0 then
    backupDir := SDirTableBackup;

  for I := 0 to FDatabaseObjects.Count-1 do begin
    if FDatabaseObjects[i] is TDatabaseTable then begin
      currentTable := TDatabaseTable(FDatabaseObjects[i]);

      if (currentTable.RepairType in [dortCritical, dortBackup]) then
      begin
        if FileExists(ExePath + backupDir + '\' + currentTable.FileSystemName + DataFileExtention)
           and FileExists(ExePath + backupDir + '\' + currentTable.FileSystemName + IndexFileExtention)
           and FileExists(ExePath + backupDir + '\' + currentTable.FileSystemName + StructFileExtention)
        then begin
          OSCopyFile(
            ExePath + backupDir + '\'
            + currentTable.FileSystemName + DataFileExtention,
            ExePath + SDirData + '\' + WorkSchema + '\'
            + currentTable.FileSystemName + DataFileExtention);
          OSCopyFile(
            ExePath + backupDir + '\'
            + currentTable.FileSystemName + IndexFileExtention,
            ExePath + SDirData + '\' + WorkSchema + '\'
            + currentTable.FileSystemName + IndexFileExtention);
          OSCopyFile(
            ExePath + backupDir + '\'
            + currentTable.FileSystemName + StructFileExtention,
            ExePath + SDirData + '\' + WorkSchema + '\'
            + currentTable.FileSystemName + StructFileExtention);
          WriteExchangeLog('DatabaseController.RepairTableFromBackup',
            Format('Объект %s был восстановлен из backupа', [currentTable.LogObjectName]));
        end;
      end;

    end;
  end;
end;

procedure TDatabaseController.RestoreDatabase;
begin
  if DM.MainConnection is TMyEmbConnection then begin
    DM.MainConnection.Close;

    //удаляем директорию
    DeleteDataDir(ExePath + SDirData);

    //копируем данные из backup, который сделали перед импортом
    MoveDirectories(ExePath + SDirDataBackup, ExePath + SDirData);

    DM.MainConnection.Open;
  end;
  //OSDeleteFile(ExePath + BackupFileFlag);
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

function TDatabaseTable.GetTableOptions: String;
begin
  Result := ' ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;';
end;

function TDatabaseTable.LogObjectName: String;
begin
  Result :=
    IfThen(
      Length(Self.FileSystemName) > 0,
      Self.FileSystemName,
      Self.Name);
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
  SetCurrentDir(ExtractFileDir(ParamStr(0)));
  FDatabaseController := TDatabaseController.Create();
end.
