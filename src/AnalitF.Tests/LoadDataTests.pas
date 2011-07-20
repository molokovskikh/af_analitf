unit LoadDataTests;

interface

uses
  SysUtils,
  Windows,
  TestFrameWork,
  MyAccess,
  MyEmbConnection,
  AProc,
  DatabaseObjects,
  GeneralDatabaseObjects;

type
  TTestLoadData = class(TTestCase)
   private
    function GetConnection : TCustomMyConnection;
   published
    procedure CreateDB;
    procedure LoadData;
    procedure LoadDataWithTruncate;
    procedure LoadDataWithDelete;
  end;

implementation

{ TTestLoadData }

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

initialization
  TestFramework.RegisterTest(TTestLoadData.Suite);
end.
