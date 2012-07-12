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
    function DataSetToString(
      exec : TMyQuery;
      SQL : String;
      Params: array of string;
      Values: array of Variant) : String;
   protected
    procedure SetUp; override;
   published
    procedure RestoreGlobalParamsTable();
    procedure RestorePricesDataTable();
    procedure CheckAllTables();
    procedure CheckMatchWaybillsToRejects();
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

procedure TTestDBRestore.CheckMatchWaybillsToRejects;
var
  connection : TCustomMyConnection;
  exec : TMyQuery;
  InputFileName,
  dbodiesInsertSQL,
  rejectsInsertSQL : String;
begin
  DatabaseController.DisableMemoryLib();
  CopySpecialLib();
  CreateDB;

  connection := GetConnection;
  try
    connection.Database := 'analitf';
    connection.Open;
    try

    InputFileName := StringReplace(ExpandFileName('..\TestData\i10815\DocumentBodies.txt'), '\', '/', [rfReplaceAll]);
    dbodiesInsertSQL :=
      Format(
      'LOAD DATA INFILE ''%s'' ignore into table analitf.%s ' +
      ' ( ' +
      '    ServerId, ServerDocumentId, Product, Code, Certificates, Period, Producer, ' +
      '    Country, ProducerCost, RegistryCost, SupplierPriceMarkup, ' +
      '    SupplierCostWithoutNDS, SupplierCost, Quantity, VitallyImportant, ' +
      '    NDS, SerialNumber, Amount, NdsAmount, Unit, ExciseTax, ' +
      '    BillOfEntryNumber, EAN13, ProductId, ProducerId ' +
      ' ) ' +
      'set Printed = 1, DocumentId = null;',
      [InputFileName,
       'DocumentBodies']);

      rejectsInsertSQL := GetLoadDataSQL('Rejects', ExpandFileName('..\TestData\i10815\Rejects.txt'), True);

      exec := TMyQuery.Create(nil);
      try
        exec.Connection := connection;

        Self.Status('загружаем dbodies : ' + DateTimeToStr(Now()));
        exec.SQL.Text := dbodiesInsertSQL;
        exec.Execute;

        Self.Status('загружаем rejects : ' + DateTimeToStr(Now()));
        exec.SQL.Text := rejectsInsertSQL;
        exec.Execute;

        exec.SQL.Text := 'insert into analitf.rejects (Id, Name, ProductId, Series, Hidden, CheckPrint) values (30000, "123_name", 100100, "123_series", 0, 0)';
        exec.Execute;

        exec.SQL.Text := 'insert into analitf.documentBodies (Product, ProductId, SerialNumber) values ("123_name", null, "123_series")';
        exec.Execute;
        exec.SQL.Text := 'insert into analitf.documentBodies (Product, ProductId, SerialNumber) values ("123_name_test", 100100, "123_series")';
        exec.Execute;

        Self.Status('сопоставление по ProductId : ' + DateTimeToStr(Now()));
        exec.SQL.Text := '' +
      ' update ' +
      '   analitf.DocumentBodies, ' +
      '   analitf.rejects ' +
      ' set ' +
      '   DocumentBodies.RejectId = Rejects.Id ' +
      ' where ' +
      '     DocumentBodies.RejectId is null ' +
      ' and (DocumentBodies.ProductId is not null) ' +
      ' and (DocumentBodies.SerialNumber is not null) ' +
      ' and (DocumentBodies.ProductId = Rejects.ProductId) ' +
      ' and (DocumentBodies.SerialNumber = Rejects.Series) ' ;
        exec.Execute;
        Self.Status('сопоставлено : ' + IntToStr(exec.RowsAffected));

        Self.Status(
          Concat('сопоставление по ProductId Update DocumentBodies by ProductId', #13#10,
            DataSetToString(exec, 'explain EXTENDED select DocumentBodies.RejectId from ' +
          '   analitf.DocumentBodies, ' +
          '   analitf.rejects ' +
          ' where ' +
          '     DocumentBodies.RejectId is null ' +
          ' and (DocumentBodies.ProductId is not null) ' +
          ' and (DocumentBodies.SerialNumber is not null) ' +
          ' and (DocumentBodies.ProductId = Rejects.ProductId) ' +
          ' and (DocumentBodies.SerialNumber = Rejects.Series) ', [], [])));

        Self.Status('сопоставление по Product : ' + DateTimeToStr(Now()));
        exec.SQL.Text := '' +
      ' update ' +
      '   analitf.DocumentBodies, ' +
      '   analitf.rejects ' +
      ' set ' +
      '   DocumentBodies.RejectId = Rejects.Id ' +
      ' where ' +
      '     DocumentBodies.RejectId is null ' +
      ' and (DocumentBodies.ProductId is null) ' +
      ' and (DocumentBodies.Product is not null) ' +
      ' and (DocumentBodies.SerialNumber is not null) ' +
      ' and (DocumentBodies.Product = Rejects.Name) ' +
      ' and (DocumentBodies.SerialNumber = Rejects.Series) ' ;
        exec.Execute;
        Self.Status('сопоставлено : ' + IntToStr(exec.RowsAffected));

        Self.Status(
          Concat('сопоставление по Product Update DocumentBodies by Product', #13#10,
            DataSetToString(exec, 'explain EXTENDED select DocumentBodies.RejectId from ' +
          '   analitf.DocumentBodies, ' +
          '   analitf.rejects ' +
          ' where ' +
          '     DocumentBodies.RejectId is null ' +
          ' and (DocumentBodies.ProductId is null) ' +
          ' and (DocumentBodies.Product is not null) ' +
          ' and (DocumentBodies.SerialNumber is not null) ' +
          ' and (DocumentBodies.Product = Rejects.Name) ' +
          ' and (DocumentBodies.SerialNumber = Rejects.Series) ', [], [])));

        Self.Status('закончили тест : ' + DateTimeToStr(Now()));
      finally
        exec.Free;
      end;
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

function TTestDBRestore.DataSetToString(exec: TMyQuery; SQL: String;
  Params: array of string; Values: array of Variant): String;
var
  Header : String;
  Row : String;
  I : Integer;
begin
  Result := '';
  Header := '';

  if (Length(Params) <> Length(Values)) then
    raise Exception.Create('QueryValue: Кол-во параметров не совпадает со списком значений.');

  if exec.Active then
     exec.Close;
  exec.SQL.Text := SQL;

  for I := Low(Params) to High(Params) do
    exec.ParamByName(Params[i]).Value := Values[i];

  exec.Open;
  try
    for I := 0 to exec.Fields.Count-1 do
      if Header = '' then
        Header := exec.Fields[i].FieldName
      else
        Header := Header + Chr(9) + exec.Fields[i].FieldName;
    Result := Header + #13#10 + StringOfChar('-', Length(Header));
    while not exec.Eof do begin
      Row := '';
      for I := 0 to exec.Fields.Count-1 do
        if Row = '' then
          Row := exec.Fields[i].AsString
        else
          Row := Row + Chr(9) + exec.Fields[i].AsString;
      Result := Concat(Result, #13#10, Row);
      exec.Next;
    end;
  finally
    exec.Close;
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
