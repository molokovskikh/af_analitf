unit LoadDataTests;

interface

uses
  SysUtils,
  Windows,
  TestFrameWork,
  MyAccess,
  MyEmbConnection,
  MyDump,
  AProc,
  U_ExchangeLog,
  DModule,
  DatabaseObjects,
  GeneralDatabaseObjects,
  BackupDatabaseObjects,
  CriticalDatabaseObjects,
  DatabaseViews,
  DocumentTypes,
  IgnoreDatabaseObjects,
  MyEmbConnectionEx,
  SynonymDatabaseObjects;

{$ifdef USEMEMORYCRYPTDLL}
  {$ifndef USENEWMYSQLTYPES}
    {$define USENEWMYSQLTYPES}
  {$endif}
{$endif}

{$ifdef USEMEMORYCRYPTDLL}
  {$ifndef USENEWMYSQLTYPES}
    {$define USENEWMYSQLTYPES}
  {$endif}
{$endif}
  
type
  TTestLoadData = class(TTestCase)
   private
    function GetConnection : TCustomMyConnection;
    procedure ApplyMigrate();
    procedure DeleteDataFolder;
    procedure TestOpen();
   published
    procedure CreateDB;
    procedure CreateDBVer81;
    procedure LoadData;
    procedure LoadDataWithTruncate;
    procedure LoadDataWithDelete;
    procedure CheckUpdateScript;
    procedure _CreateDBWithClient;
    procedure LoadDataInMain;
    procedure LoadDataInThread;
    procedure _UpdateClientAndOpen;
    procedure _Open;
  end;

implementation

{ TTestLoadData }

procedure TTestLoadData.ApplyMigrate;
var
  connection : TCustomMyConnection;
  MyDump : TMyDump;
begin
  connection := GetConnection;
  try
    connection.Open;
    try
      connection.ExecSQL('use analitf', []);

      MyDump := TMyDump.Create(nil);
      try
        MyDump.Connection := connection;
        MyDump.Objects := [doTables, doViews];
        //MyDump.OnError := OnScriptExecuteError;
        //MyDump.SQL.Text := GetFullLastCreateScript();
        MyDump.SQL.LoadFromFile('..\FullScripts\migrate81to82.sql');
{$ifdef DEBUG}
        //WriteExchangeLog('CreateClearDatabaseFromScript', MyDump.SQL.Text);
{$endif}
        MyDump.Restore;
      finally
        MyDump.Free;
      end;

    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestLoadData.CheckUpdateScript;
var
  connection : TCustomMyConnection;
begin
  ApplyMigrate();
  connection := GetConnection;
  try
    connection.Open;
    try
      connection.ExecSQL('use analitf', []);

      DatabaseController.Initialize(connection);

    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestLoadData.CreateDB;
var
  connection : TCustomMyConnection;
  coreTable : TCoreTable;
begin
  DeleteDataDir(ExePath + SDirData);

  ForceDirectories(ExePath + SDirData + '\analitf');

  connection := GetConnection;
  try
    connection.Open;
    try
      connection.ExecSQL('use analitf', []);

      coreTable := TCoreTable.Create;
      try
        connection.ExecSQL(coreTable.GetCreateSQL(), []);
      finally
        coreTable.Free;
      end;


    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestLoadData.DeleteDataFolder;
begin
  DeleteDataDir(ExePath + SDirData);
end;

procedure TTestLoadData.CreateDBVer81;
var
  connection : TCustomMyConnection;
  MyDump : TMyDump;
begin
  DeleteDataDir(ExePath + SDirData);

  ForceDirectories(ExePath + SDirData + '\analitf');

  connection := GetConnection;
  try
    connection.Open;
    try
      connection.ExecSQL('use analitf', []);

      MyDump := TMyDump.Create(nil);
      try
        MyDump.Connection := connection;
        MyDump.Objects := [doTables, doViews];
        //MyDump.OnError := OnScriptExecuteError;
        //MyDump.SQL.Text := GetFullLastCreateScript();
        MyDump.SQL.LoadFromFile('..\FullScripts\script81.sql');
{$ifdef DEBUG}
        //WriteExchangeLog('CreateClearDatabaseFromScript', MyDump.SQL.Text);
{$endif}
        MyDump.Restore;
      finally
        MyDump.Free;
      end;

    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

function TTestLoadData.GetConnection: TCustomMyConnection;
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

procedure TTestLoadData.LoadData;
var
  connection : TCustomMyConnection;
  coreTestInsertSQl : String;
  exec : TMyQuery;
begin
  connection := GetConnection;
  try
    connection.Open;


    try
      connection.ExecSQL('use analitf', []);

      coreTestInsertSQl := GetLoadDataSQL('Core', ExePath + '\Core.txt');

      exec := TMyQuery.Create(nil);
      try
        exec.Connection := connection;

        exec.SQL.Text := 'truncate core';
        exec.Execute;

{$ifndef DisableCrypt}
    exec.SQL.Text :=
      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
      ' (PriceCode, RegionCode, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, ' +
      ' Code, CodeCr, Unit, Volume, Junk, Await, QUANTITY, Note, Period, Doc, ' +
      ' RegistryCost, VitallyImportant, REQUESTRATIO, CryptCost, SERVERCOREID, ' +
      ' ORDERCOST, MINORDERCOUNT, SupplierPriceMarkup, ProducerCost, NDS, RetailVitallyImportant, BuyingMatrixType);';
{$else}
    exec.SQL.Text :=
      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
      ' (PriceCode, RegionCode, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, ' +
      ' Code, CodeCr, Unit, Volume, Junk, Await, QUANTITY, Note, Period, Doc, ' +
      ' RegistryCost, VitallyImportant, REQUESTRATIO, Cost, SERVERCOREID, ' +
      ' ORDERCOST, MINORDERCOUNT, SupplierPriceMarkup, ProducerCost, NDS, RetailVitallyImportant, BuyingMatrixType);';
{$endif}
        exec.Execute;

{
    InternalExecute;
    WriteExchangeLog('ImportData', 'Import Core count : ' + IntToStr(DM.adcUpdate.RowsAffected));

}
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

procedure TTestLoadData.LoadDataInMain;
var
  I : Integer;
begin
  DeleteDataFolder;

  for I := 0 to 4 do begin
    try
      Self.Status('try open : ' + IntToStr(i));
      TestOpen();
      Self.Status('success open : ' + IntToStr(i));
    except
      on E : Exception do begin
        Self.Status('Получили ошибку после вызова UpdateDB(): ' + ExceptionToString(E));
        DatabaseController.FreeMySQLLib('MySql Clients Count после ошибки');

      end;
    end;
  end;
end;

procedure TTestLoadData.LoadDataInThread;
begin
  DeleteDataFolder;
end;

procedure TTestLoadData.LoadDataWithDelete;
const
  repeatCount = 10;
var
  connection : TCustomMyConnection;
  coreTestInsertSQl : String;
  exec : TMyQuery;
  I : Integer;
  startTicks,
  endTicks,
  summuryTikcs : DWORD;
begin
  connection := GetConnection;
  try
    connection.Open;


    try
      connection.ExecSQL('use analitf', []);

      coreTestInsertSQl := GetLoadDataSQL('Core', ExePath + '\Core.txt');

      exec := TMyQuery.Create(nil);
      try
        exec.Connection := connection;

        summuryTikcs := 0;
        for I := 0 to repeatCount-1 do begin

        startTicks := GetTickCount();
        exec.SQL.Text := 'delete from core';
        exec.Execute;
        endTicks := GetTickCount();

        summuryTikcs := summuryTikcs + (endTicks - startTicks);
        exec.SQL.Text := 'truncate core';
        exec.Execute;

{$ifndef DisableCrypt}
    exec.SQL.Text :=
      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
      ' (PriceCode, RegionCode, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, ' +
      ' Code, CodeCr, Unit, Volume, Junk, Await, QUANTITY, Note, Period, Doc, ' +
      ' RegistryCost, VitallyImportant, REQUESTRATIO, CryptCost, SERVERCOREID, ' +
      ' ORDERCOST, MINORDERCOUNT, SupplierPriceMarkup, ProducerCost, NDS, RetailVitallyImportant, BuyingMatrixType);';
{$else}
    exec.SQL.Text :=
      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
      ' (PriceCode, RegionCode, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, ' +
      ' Code, CodeCr, Unit, Volume, Junk, Await, QUANTITY, Note, Period, Doc, ' +
      ' RegistryCost, VitallyImportant, REQUESTRATIO, Cost, SERVERCOREID, ' +
      ' ORDERCOST, MINORDERCOUNT, SupplierPriceMarkup, ProducerCost, NDS, RetailVitallyImportant, BuyingMatrixType);';
{$endif}
        exec.Execute;

{
    InternalExecute;
    WriteExchangeLog('ImportData', 'Import Core count : ' + IntToStr(DM.adcUpdate.RowsAffected));

}
        end;

        MessageBox('Summary ticks count = ' + IntToStr(summuryTikcs))
        
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

procedure TTestLoadData.LoadDataWithTruncate;
const
  repeatCount = 10;
var
  connection : TCustomMyConnection;
  coreTestInsertSQl : String;
  exec : TMyQuery;
  I : Integer;
  startTicks,
  endTicks,
  summuryTikcs : DWORD;
begin
  connection := GetConnection;
  try
    connection.Open;


    try
      connection.ExecSQL('use analitf', []);

      coreTestInsertSQl := GetLoadDataSQL('Core', ExePath + '\Core.txt');

      exec := TMyQuery.Create(nil);
      try
        exec.Connection := connection;

        summuryTikcs := 0;
        for I := 0 to repeatCount-1 do begin

        startTicks := GetTickCount();
        exec.SQL.Text := 'truncate core';
        exec.Execute;
        endTicks := GetTickCount();

        summuryTikcs := summuryTikcs + (endTicks - startTicks);

{$ifndef DisableCrypt}
    exec.SQL.Text :=
      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
      ' (PriceCode, RegionCode, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, ' +
      ' Code, CodeCr, Unit, Volume, Junk, Await, QUANTITY, Note, Period, Doc, ' +
      ' RegistryCost, VitallyImportant, REQUESTRATIO, CryptCost, SERVERCOREID, ' +
      ' ORDERCOST, MINORDERCOUNT, SupplierPriceMarkup, ProducerCost, NDS, RetailVitallyImportant, BuyingMatrixType);';
{$else}
    exec.SQL.Text :=
      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
      ' (PriceCode, RegionCode, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, ' +
      ' Code, CodeCr, Unit, Volume, Junk, Await, QUANTITY, Note, Period, Doc, ' +
      ' RegistryCost, VitallyImportant, REQUESTRATIO, Cost, SERVERCOREID, ' +
      ' ORDERCOST, MINORDERCOUNT, SupplierPriceMarkup, ProducerCost, NDS, RetailVitallyImportant, BuyingMatrixType);';
{$endif}
        exec.Execute;

{
    InternalExecute;
    WriteExchangeLog('ImportData', 'Import Core count : ' + IntToStr(DM.adcUpdate.RowsAffected));

}
        end;

        MessageBox('Summary ticks count = ' + IntToStr(summuryTikcs))

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

procedure TTestLoadData.TestOpen;
var
  connection : TCustomMyConnection;
begin
  connection := GetConnection();
  try
    connection.Open;
    try
      connection.ExecSQL('select Id from analitf.params', []);
    finally
      Self.Status('Сейчас будет запуск Sleep');
      Sleep(1000);
      Self.Status('запуск Sleep завершен');
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestLoadData._CreateDBWithClient;
var
  connection : TCustomMyConnection;
  clientTestInsertSQl : String;
begin
  DeleteDataDir(ExePath + SDirData);

  ForceDirectories(ExePath + SDirData + '\analitf');

  connection := GetConnection;
  try
    connection.Open;
    try
      connection.ExecSQL('use analitf', []);

      WriteExchangeLog('_CreateDBWithClient', 'create client table');
      connection.ExecSQL('' +
      'create table client     '
      +'  ( '
+'    `Id` bigint(20) not null   , '
+'    `Name` varchar(50) not null, '
+'    `CalculateOnProducerCost` tinyint(1) unsigned NOT NULL DEFAULT ''0'', '
+'    `ParseWaybills` tinyint(1) unsigned not null default ''0'', '
+'    `SendRetailMarkup` tinyint(1) unsigned not null default ''0'', '
+'    `ShowAdvertising` tinyint(1) unsigned not null default ''1'', '
+'    `SendWaybillsFromClient` tinyint(1) unsigned not null default ''0'', '
+'    `EnableSmartOrder` tinyint(1) unsigned not null default ''0'', '
+'    `EnableImpersonalPrice` tinyint(1) unsigned not null default ''0'', '
+'    `AllowDelayOfPayment` tinyint(1) not null default ''0'',  '
+'    primary key (`Id`) '
+'  ) ' + 'ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;', []);

      //connection.ExecSQL('insert into client (Id, Name) values (1, ''test 1'')', []);

      WriteExchangeLog('_CreateDBWithClient', 'insert into client table');
      clientTestInsertSQl := GetLoadDataSQL('Client', ExePath + '\Client.txt');

      connection.ExecSQL(clientTestInsertSQl, []);
    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestLoadData._Open;
var
  connection : TCustomMyConnection;
  exec : TMyQuery;
begin
  connection := GetConnection;
  try
    WriteExchangeLog('_Open', 'open connection');
    connection.Open;
    try
      WriteExchangeLog('_Open', 'use analitf');
      connection.ExecSQL('use analitf', []);

      WriteExchangeLog('_Open', 'DatabaseController.Initialize');
      DatabaseController.Initialize(connection);

      exec := TMyQuery.Create(nil);
      try
        exec.Connection := connection;

        exec.SQL.Text := 'select   client.Id as MainClientId, client.Name as MainClientName, client.CalculateOnProducerCost, client.ParseWaybills, ' +
        'client.SendRetailMarkup, client.ShowAdvertising, client.SendWaybillsFromClient, client.EnableSmartOrder, client.EnableImpersonalPrice, ' +
        'client.AllowDelayOfPayment, client.ShowCertificatesWithoutRefSupplier from client';

        WriteExchangeLog('_Open', 'select from client');
        exec.Open;
        try
          while not exec.Eof do begin
            exec.Next;
          end;
        finally
          WriteExchangeLog('_Open', 'close client');
          exec.Close;
        end;

      finally
        exec.Free;
      end;

    finally
      WriteExchangeLog('_Open', 'close connection');
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestLoadData._UpdateClientAndOpen;
var
  connection : TCustomMyConnection;
  exec : TMyQuery;
begin
  connection := GetConnection;
  try
    WriteExchangeLog('_UpdateClientAndOpen', 'open connection at alter');
    connection.Open;
    try
      WriteExchangeLog('_UpdateClientAndOpen', 'use analitf at alter');
      connection.ExecSQL('use analitf', []);

      WriteExchangeLog('_UpdateClientAndOpen', 'alter client table');
      connection.ExecSQL('' +
      'alter table analitf.client add column `ShowCertificatesWithoutRefSupplier` tinyint(1) not null default ''0'';', []);

    finally
      WriteExchangeLog('_UpdateClientAndOpen', 'close connection at alter');
      connection.Close;
    end;
  finally
    WriteExchangeLog('_UpdateClientAndOpen', 'free connection at alter');
    connection.Free;
  end;

  WriteExchangeLog('_UpdateClientAndOpen', 'free library after alter');
  DatabaseController.FreeMySQLLib('test');

  connection := GetConnection;
  try
    WriteExchangeLog('_UpdateClientAndOpen', 'open connection after alter');
    connection.Open;
    try
      WriteExchangeLog('_UpdateClientAndOpen', 'use analitf after alter');
      connection.ExecSQL('use analitf', []);

      WriteExchangeLog('_UpdateClientAndOpen', 'DatabaseController.Initialize after alter');
      DatabaseController.Initialize(connection);

      exec := TMyQuery.Create(nil);
      try
        exec.Connection := connection;

        exec.SQL.Text := 'select   client.Id as MainClientId, client.Name as MainClientName, client.CalculateOnProducerCost, client.ParseWaybills, ' +
        'client.SendRetailMarkup, client.ShowAdvertising, client.SendWaybillsFromClient, client.EnableSmartOrder, client.EnableImpersonalPrice, ' +
        'client.AllowDelayOfPayment, client.ShowCertificatesWithoutRefSupplier from client';

        WriteExchangeLog('_UpdateClientAndOpen', 'select client after alter');
        exec.Open;
        try
          while not exec.Eof do begin
            exec.Next;
          end;
        finally
          WriteExchangeLog('_UpdateClientAndOpen', 'close client after alter');
          exec.Close;
        end;

      finally
        exec.Free;
      end;

    finally
      WriteExchangeLog('_UpdateClientAndOpen', 'close connection after alter');
      connection.Close;
    end;
  finally
    WriteExchangeLog('_UpdateClientAndOpen', 'free connection after alter');
    connection.Free;
  end;
end;

initialization
  TestFramework.RegisterTest(TTestLoadData.Suite);
end.
