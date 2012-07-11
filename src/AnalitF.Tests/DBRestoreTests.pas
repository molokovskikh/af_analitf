unit DBRestoreTests;

interface

{$I '..\AF.inc'}

uses
  SysUtils,
  Windows,
  Classes,
  TestFrameWork,
  MyClasses,
  MyAccess,
  MyEmbConnection,
  MyDump,
  AProc,
  DBProc,
  DatabaseObjects,
  GeneralDatabaseObjects,
  BackupDatabaseObjects,
  CriticalDatabaseObjects,
  DatabaseViews,
  DocumentTypes,
  IgnoreDatabaseObjects,
  MyEmbConnectionEx,
  SynonymDatabaseObjects;

type
  TTestDBRestore = class(TTestCase)
   private
    procedure CreateDB;
    function GetConnection : TCustomMyConnection;
    procedure CopySpecialLib();
    procedure DeleteTableGlobalParams;
    procedure DeleteTablePricesData;
    procedure InsertDataToPricesData;
   protected
    procedure SetUp; override;
   published
    procedure RestoreGlobalParamsTable();
    procedure RestorePricesDataTable();
    procedure CheckAllTables();
  end;

implementation

{ TTestDBRestore }

procedure TTestDBRestore.CheckAllTables;
var
  connection : TCustomMyConnection;
begin
  DatabaseController.DisableMemoryLib();
  CopySpecialLib();
  CreateDB;

  connection := GetConnection;
  try
    connection.Database := 'analitf';
    connection.Open;
    try

      Self.Status('запуск проверки объектов : ' + DateTimeToStr(Now()));

      //Проверка объектов перед использованием globalParams
      DatabaseController.CheckObjectsExists(
        connection,
        False);

      Self.Status('проверка объектов завершена : ' + DateTimeToStr(Now()));
    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestDBRestore.CopySpecialLib;
begin
  OSCopyFile('..\SpecialLibs\1833\libmysqld_debug.dll', 'libmysqld.dll');
end;

procedure TTestDBRestore.CreateDB;
var
  connection : TCustomMyConnection;
  MyDump : TMyDump;
begin
  DeleteDataDir(ExePath + SDirData);

  ForceDirectories(ExePath + SDirData + '\analitf');

  connection := GetConnection;
  try
    connection.Database := 'analitf';
    connection.Open;
    try
      //connection.ExecSQL('use analitf', []);

      MyDump := TMyDump.Create(nil);
      try
        MyDump.Connection := connection;
        MyDump.Objects := [doTables, doViews];
        //MyDump.OnError := OnScriptExecuteError;
        MyDump.SQL.Text := DatabaseController.GetFullLastCreateScript('');
        Self.Status('производим попытку создать базу данных');
        MyDump.Restore;
      finally
        MyDump.Free;
      end;
      Self.Status('база данных создана : ' + DateTimeToStr(Now()));

      DatabaseController.Initialize(connection);
      Self.Status('произвели инициализацию таблиц : ' + DateTimeToStr(Now()));

    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestDBRestore.DeleteTableGlobalParams;
var
  globalParams : TDatabaseTable;
  connection : TCustomMyConnection;

  procedure DeleteTableFile(fileName : String);
  begin
    OSDeleteFile(ExePath + SDirData + '\' + WorkSchema + '\' + fileName);
  end;

begin
  globalParams := TDatabaseTable(DatabaseController.FindById(doiGlobalParams));

  //При удалении файла с индексами (IndexFileExtention) возникает ошибка
  //(1017) Can't find file: 'globalparams' (errno: 2)
  //DeleteTableFile(globalParams.FileSystemName + DataFileExtention);
  DeleteTableFile(globalParams.FileSystemName + IndexFileExtention);
  //DeleteTableFile(globalParams.FileSystemName + StructFileExtention);

  connection := GetConnection;
  try
    connection.Database := 'analitf';
    connection.Open;
    try
      try
        DBProc.QueryValue(connection, 'select name from globalparams limit 1', [], []);
        Fail('Должно возникнуть исключение');
      except
        on E : EMyError do
          CheckEquals(1017, e.ErrorCode, 'Неожидаемая ошибка: ' + e.Message);
      end;

    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestDBRestore.DeleteTablePricesData;
var
  pricesData : TDatabaseTable;
  connection : TCustomMyConnection;
  t : TStringList;
  i : Integer;
  s : String;

  procedure DeleteTableFile(fileName : String);
  begin
    OSDeleteFile(ExePath + SDirData + '\' + WorkSchema + '\' + fileName);
  end;

begin
  pricesData := TDatabaseTable(DatabaseController.FindById(doiPricesData));

  //При удалении файла с индексами (IndexFileExtention) возникает ошибка
  //(1017) Can't find file: 'globalparams' (errno: 2)
  //DeleteTableFile(pricesData.FileSystemName + DataFileExtention);
  t := TStringList.Create;
  try
    t.LoadFromFile(ExePath + SDirData + '\' + WorkSchema + '\' + pricesData.FileSystemName + DataFileExtention);

    s := t[t.Count-1];
    t.Delete(t.Count-1);
{
    for I := t.Count-1 downto t.Count-3 do
      t.Delete(i);
}
    t.Add('dsdsds');
    t.Add('dsdsdsdsds  ds dsd sd sd sd sd s ds');
    t.Add('dsdsdsdsds  ds dsd sd sd sd sd s ds');
    t.Add('dsdsdsdsds  ds dsd sd sd sd sd s ds');
    t.Add('dsdsdsdsds  ds dsd sd sd sd sd s ds');
    t.Add(s);
    t.SaveToFile(ExePath + SDirData + '\' + WorkSchema + '\' + pricesData.FileSystemName + DataFileExtention);
  finally
    t.Free
  end;

  //DeleteTableFile(pricesData.FileSystemName + IndexFileExtention);
  //DeleteTableFile(pricesData.FileSystemName + StructFileExtention);

  connection := GetConnection;
  try
    connection.Database := 'analitf';
    connection.Open;
    try
      try
        DBProc.QueryValue(connection,
          //'select FirmCode from PricesData limit 1',
'  select pd.PRICECODE     as PriceCode           , '
+'    `pd`.`PRICENAME`      as `PriceName`         , '
+'    `pd`.`DATEPRICE`      as `UniversalDatePrice`, '
+'    `prd`.`ENABLED`       as `Enabled`           , '
+'    `cd`.`FIRMCODE`       as `FirmCode`          , '
+'    `cd`.`FULLNAME`       as `FullName`          , '
+'    `prd`.`STORAGE`       as `Storage`           , '
+'    `cd`.`MANAGERMAIL`    as `ManagerMail`       , '
+'    `r`.`REGIONCODE`      as `RegionCode`        , '
+'    `r`.`REGIONNAME`      as `RegionName`        , '
+'    `prd`.`PRICESIZE`     as `pricesize`          '
+'  from (((`pricesdata` `pd` '
+'    join `pricesregionaldata` `prd` '
+'    on (`pd`.`PRICECODE` = `prd`.`PRICECODE` '
+'      ) '
+'    ) '
+'    join `regions` `r` '
+'    on (`prd`.`REGIONCODE` = `r`.`REGIONCODE` '
+'      ) '
+'    ) '
+'    join `providers` `cd` '
+'    on (`cd`.`FIRMCODE` = `pd`.`FIRMCODE` '
+'      ) '
+'    );',
          [], []);
        Fail('Должно возникнуть исключение');
      except
        on E : EMyError do
          CheckEquals(1146, e.ErrorCode, 'Неожидаемая ошибка: ' + e.Message);
      end;

    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

function TTestDBRestore.GetConnection: TCustomMyConnection;
var
  MyEmbConnection : TMyEmbConnection;
begin
  MyEmbConnection := TMyEmbConnection.Create(nil);

  MyEmbConnection.Database := '';
  MyEmbConnection.Username := 'root';
  MyEmbConnection.Password := '';
  MyEmbConnection.LoginPrompt := False;

  MyEmbConnection.DataDir := '';
  MyEmbConnection.Options.Charset := 'cp1251';

  //Устанавливаем параметры embedded-соединения
  MyEmbConnection.Params.Clear();
{$ifndef USENEWMYSQLTYPES}
  MyEmbConnection.Params.Add('--basedir=' + ExtractFileDir(ParamStr(0)) + '\');
  MyEmbConnection.Params.Add('--datadir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirData  + '\');
  MyEmbConnection.Params.Add('--character_set_server=cp1251');
  MyEmbConnection.Params.Add('--skip-innodb');
  MyEmbConnection.Params.Add('--tmp_table_size=' + DatabaseController.GetMaxTempTableSize());
  MyEmbConnection.Params.Add('--max_heap_table_size=' + DatabaseController.GetMaxTempTableSize());
  MyEmbConnection.Params.Add('--tmpdir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirDataTmpDir  + '\');
{$else}
  MyEmbConnection.Params.Add('--basedir=' + ExtractFileDir(ParamStr(0)) + '\');
  MyEmbConnection.Params.Add('--datadir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirData  + '\');
  MyEmbConnection.Params.Add('--character_set_server=cp1251');
  MyEmbConnection.Params.Add('--tmp_table_size=' + DatabaseController.GetMaxTempTableSize());
  MyEmbConnection.Params.Add('--max_heap_table_size=' + DatabaseController.GetMaxTempTableSize());
  MyEmbConnection.Params.Add('--tmpdir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirDataTmpDir  + '\');

  MyEmbConnection.Params.Add('--sort_buffer_size=64M');
  MyEmbConnection.Params.Add('--read_buffer_size=2M');
  //MyEmbConnection.Params.Add('--write_buffer_size=2M');
  //Для настройки этого параметра необходимо получить 60% свободной памяти
  //MyEmbConnection.Params.Add('--key_buffer_size==30M');
{$endif}

  Result := MyEmbConnection;
end;

procedure TTestDBRestore.InsertDataToPricesData;
var
  connection : TCustomMyConnection;
begin
{
+'    `FIRMCODE` bigint(20) not null          , '
+'    `PRICECODE` bigint(20) not null         , '
+'    `PRICENAME` varchar(70) default null    , '
+'    `PRICEINFO` text                        , '
+'    `DATEPRICE` datetime default null       , '
+'    `FRESH`     tinyint(1) not null         , '
}
  connection := GetConnection;
  try
    connection.Database := 'analitf';
    connection.Open;
    try
      connection.ExecSQL('insert into PricesData(FirmCode, PriceCode, Fresh) values (1, 2, 1)', []);
      connection.ExecSQL('insert into PricesData(FirmCode, PriceCode, Fresh) values (1, 1, 1)', []);
      connection.ExecSQL('insert into PricesData(FirmCode, PriceCode, Fresh) values (1, 3, 1)', []);
      connection.ExecSQL('insert into PricesData(FirmCode, PriceCode, Fresh) values (1, 4, 1)', []);
      connection.ExecSQL('insert into PricesData(FirmCode, PriceCode, Fresh) values (1, 5, 1)', []);
    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestDBRestore.RestoreGlobalParamsTable;
var
  connection : TCustomMyConnection;
begin
  DatabaseController.DisableMemoryLib();
  CopySpecialLib();
  CreateDB;

  Self.Status('запуск выгрузки библиотеки объектов : ' + DateTimeToStr(Now()));
  //Освобождаем библиотеку, чтобы удалить файлы
  DatabaseController.FreeMySQLLib('');
  Self.Status('выгрузка библиотеки завершена : ' + DateTimeToStr(Now()));

  DeleteTableGlobalParams;

  connection := GetConnection;
  try
    connection.Database := 'analitf';
    connection.Open;
    try

      Self.Status('запуск проверки объектов : ' + DateTimeToStr(Now()));

      //Проверка объектов перед использованием globalParams
      DatabaseController.CheckObjectsExists(
        connection,
        False,
        CheckedObjectOnStartup);

      Self.Status('проверка объектов завершена : ' + DateTimeToStr(Now()));

      DBProc.QueryValue(connection, 'select name from globalparams limit 1', [], []);

    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestDBRestore.RestorePricesDataTable;
var
  connection : TCustomMyConnection;
begin
  DatabaseController.DisableMemoryLib();
  CopySpecialLib();
  CreateDB;
  InsertDataToPricesData();

  Self.Status('запуск выгрузки библиотеки объектов : ' + DateTimeToStr(Now()));
  //Освобождаем библиотеку, чтобы удалить файлы
  DatabaseController.FreeMySQLLib('');
  Self.Status('выгрузка библиотеки завершена : ' + DateTimeToStr(Now()));

  DeleteTablePricesData;

  connection := GetConnection;
  try
    connection.Database := 'analitf';
    connection.Open;
    try

      Self.Status('запуск проверки объектов : ' + DateTimeToStr(Now()));

      //Проверка объектов перед использованием globalParams
      DatabaseController.CheckObjectsExists(
        connection,
        False,
        CheckedObjectOnStartup);

      Self.Status('проверка объектов завершена : ' + DateTimeToStr(Now()));

      DBProc.QueryValue(connection, 'select PriceCode from PricesData limit 1', [], []);

    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestDBRestore.SetUp;
begin
  DatabaseController.FreeMySQLLib('Освобождаем базу данных в методе TTestDBRestore.SetUp');
end;

initialization
  TestFramework.RegisterTest(TTestDBRestore.Suite);
end.
