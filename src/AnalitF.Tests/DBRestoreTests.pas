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
   published
    procedure RestoreGlobalParamsTable();
  end;

implementation

{ TTestDBRestore }

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
        Self.Status('���������� ������� ������� ���� ������');
        MyDump.Restore;
      finally
        MyDump.Free;
      end;
      Self.Status('���� ������ �������');

      DatabaseController.Initialize(connection);
      Self.Status('��������� ������������� ������');

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
  //globalParams.FileSystemName + DataFileExtention
  DeleteTableFile(globalParams.FileSystemName + IndexFileExtention);
  DeleteTableFile(globalParams.FileSystemName + StructFileExtention);

  connection := GetConnection;
  try
    connection.Database := 'analitf';
    connection.Open;
    try
      try
        DBProc.QueryValue(connection, 'select name from globalparams limit 1', [], []);
        Fail('������ ���������� ����������');
      except
        on E : EMyError do
          CheckEquals(1017, e.ErrorCode, '����������� ������: ' + e.Message);
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

  //������������� ��������� embedded-����������
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
  //��� ��������� ����� ��������� ���������� �������� 60% ��������� ������
  //MyEmbConnection.Params.Add('--key_buffer_size==30M');
{$endif}

  Result := MyEmbConnection;
end;

procedure TTestDBRestore.RestoreGlobalParamsTable;
begin
  DatabaseController.DisableMemoryLib();
  CopySpecialLib();
  CreateDB;
  //����������� ����������, ����� ������� �����
  DatabaseController.FreeMySQLLib('');
  
  DeleteTableGlobalParams;
end;

initialization
  TestFramework.RegisterTest(TTestDBRestore.Suite);
end.
