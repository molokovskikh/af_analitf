unit WaybillCalculationTests;

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
  SynonymDatabaseObjects,
  WaybillCalculation;

type
  TTestWaybillCalculation = class(TTestCase)
   private
    procedure CreateDB;
    function GetConnection : TCustomMyConnection;
    procedure CopySpecialLib();
   published
    procedure Calculation();
  end;

implementation

{ TTestWaybillCalculation }

procedure TTestWaybillCalculation.Calculation;
var
  connection : TCustomMyConnection;
  waybillDataSet : TMyQuery;
  calculation : TWaybillCalculation;
begin
  DatabaseController.DisableMemoryLib();
  CopySpecialLib();
  CreateDB;

  connection := GetConnection;
  try
    connection.Database := 'analitf';
    connection.Open;
    try

      waybillDataSet := TMyQuery.Create(nil);
      waybillDataSet.Connection := connection;
      try
        calculation := TWaybillCalculation.Create(
          waybillDataSet,
          False,
          False,
          False,
          True);
        try


        finally
          calculation.Free;
        end;
      finally
        waybillDataSet.Free;
      end;

    finally
      connection.Close;
    end;
  finally
    connection.Free;
  end;
end;

procedure TTestWaybillCalculation.CopySpecialLib;
begin
  OSCopyFile('..\SpecialLibs\1833\libmysqld_debug.dll', 'libmysqld.dll');
end;

procedure TTestWaybillCalculation.CreateDB;
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

function TTestWaybillCalculation.GetConnection: TCustomMyConnection;
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

initialization
  TestFramework.RegisterTest(TTestWaybillCalculation.Suite);
end.