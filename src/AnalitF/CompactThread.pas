unit CompactThread;

interface

uses
  SysUtils,
  Classes,
  StrUtils,
  DatabaseObjects,
  MyClasses,
  MyAccess,
  MyEmbConnection,
  MyDump,
  DAScript,
  MySqlApi;

type
  TCompactThread = class(TThread)
   protected
    procedure Execute; override;
  end;

  TRestoreThread = class(TThread)
   protected
    procedure Execute; override;
   public
    RepairedObjects : TRepairedObjects;
  end;

  TRestoreFromEtalonThread = class(TThread)
   protected
    procedure OnScriptExecuteError(Sender: TObject;
      E: Exception; SQL: String; var Action: TErrorAction);
    procedure Execute; override;
    procedure FreeMySqlLib;
   public
    Restored : Boolean;
  end;

procedure RunCompactDatabase;

function RunRestoreDatabase : Boolean;

function RunRestoreDatabaseFromEtalon : Boolean;

implementation

uses
  DModule, Waiting,
  U_ExchangeLog,
  AProc,
  SQLWaiting;

type
  TMySQLAPIEmbeddedEx = class(TMySQLAPIEmbedded)
  end;

procedure RunCompactDatabase;
var
  CompactThread : TCompactThread;
begin
  CompactThread := TCompactThread.Create(True);
  CompactThread.FreeOnTerminate := True;
  DM.MainConnection.Close;  
  try
    ShowWaiting('������������ ������ ���� ������. ���������...',
      CompactThread);
  finally
    DM.MainConnection.Open;
  end;
end;

function RunRestoreDatabase : Boolean;
var
  RestoreThread : TRestoreThread;
begin
  RestoreThread := TRestoreThread.Create(True);
  try
    RestoreThread.FreeOnTerminate := False;
    DM.MainConnection.Close;
    try
      ShowWaiting('������������ �������������� ���� ������. ���������...',
        RestoreThread);
      Result := RestoreThread.RepairedObjects = [];
    finally
      DM.MainConnection.Open;
    end;
  finally
    RestoreThread.Free;
  end;
end;

function RunRestoreDatabaseFromEtalon : Boolean;
var
  RestoreThread : TRestoreFromEtalonThread;
begin
  RestoreThread := TRestoreFromEtalonThread.Create(True);
  try
    RestoreThread.FreeOnTerminate := False;
    DM.MainConnection.Close;
    try
      ShowWaiting(
        '������������ �������� ���� ������ � ����������� ������������ �������. ���������...',
        RestoreThread);
      Result := RestoreThread.Restored;
    finally
      DM.MainConnection.Open;
    end;
  finally
    RestoreThread.Free;
  end;
end;

{ TCompactThread }

procedure TCompactThread.Execute;
begin
  try
    DM.CompactDataBase;
  except
    on E : Exception do
      WriteExchangeLog('CompactThread', '������ � ����� ������ ��: ' + E.Message);
  end;
end;

{ TRestoreThread }

procedure TRestoreThread.Execute;
begin
  RepairedObjects := [];
  try
    DM.MainConnection.Open;
    try
      RepairedObjects := DatabaseController.CheckObjects(DM.MainConnection);
    finally
      DM.MainConnection.Close;
    end;
  except
    on E : Exception do begin
      RepairedObjects := [doiCatalogs];
      WriteExchangeLog('RestoreThread', '������ � ����� �������������� ��: ' + E.Message);
    end;
  end;
end;

{ TRestoreFromEtalonThread }

procedure TRestoreFromEtalonThread.Execute;
var
  FEmbConnection : TMyEmbConnection;
  MyDump : TMyDump;
  command : TMyQuery;
begin
  Restored := False;
  try
    WriteExchangeLog('RestoreFromEtalonThread', '������ �������� ���� ������');

    FreeMySqlLib;
    WriteExchangeLog('RestoreFromEtalonThread', '��������� ����������');

    AProc.MoveDirectories(ExePath + SDirTableBackup, ExePath + SDirTableBackup + 'Tmp');
    WriteExchangeLog('RestoreFromEtalonThread', '����������� ���������� TableBackup');
    AProc.DeleteDirectory(ExePath + SDirDataPrev);
    WriteExchangeLog('RestoreFromEtalonThread', '������� ���������� DataPrev');
    AProc.DeleteDataDir(ExePath + SDirData);
    WriteExchangeLog('RestoreFromEtalonThread', '������� ���������� Data');
    SysUtils.ForceDirectories(ExePath + SDirData + '\analitf');
    WriteExchangeLog('RestoreFromEtalonThread', '����������� ���������� Data\analitf');

    FEmbConnection := TMyEmbConnection.Create(nil);
    FEmbConnection.Database := '';
    FEmbConnection.Username := DM.MainConnection.Username;
    FEmbConnection.DataDir := ExePath + SDirData;
    FEmbConnection.Options := TMyEmbConnection(DM.MainConnection).Options;
    FEmbConnection.Params.Clear;
    FEmbConnection.Params.AddStrings(TMyEmbConnection(DM.MainConnection).Params);
    FEmbConnection.LoginPrompt := False;

    try
      FEmbConnection.Open;
      try
        FEmbConnection.ExecSQL('use analitf', []);
        MyDump := TMyDump.Create(nil);
        try
          MyDump.Connection := FEmbConnection;
          MyDump.Objects := [doTables, doViews];
          MyDump.OnError := OnScriptExecuteError;
          MyDump.SQL.Text := DatabaseController.GetFullLastCreateScript();
          MyDump.Restore;
        finally
          MyDump.Free;
        end;
      finally
        FEmbConnection.Close;
      end;
      WriteExchangeLog('RestoreFromEtalonThread', '������� ���� ������');

      FreeMySqlLib;
      WriteExchangeLog('RestoreFromEtalonThread', '��������� ����������');

      DatabaseController.RepairTableFromBackup(SDirTableBackup + 'Tmp');
      WriteExchangeLog('RestoreFromEtalonThread', '������������ �� TableBackup');

      SysUtils.ForceDirectories(ExePath + SDirTableBackup);

      FEmbConnection.Open;
      try
        FEmbConnection.ExecSQL('use analitf', []);
        DatabaseController.CreateViews(FEmbConnection);
        command := TMyQuery.Create(FEmbConnection);
        try
          command.Connection := FEmbConnection;

          command.SQL.Text := 'select * from analitf.pricesshow';
          command.Open;
          command.Close;

          command.SQL.Text := 'select * from analitf.params';
          command.Open;
          command.Close;

          command.SQL.Text := 'select * from analitf.clients';
          command.Open;
          command.Close;

          command.SQL.Text := 'select * from analitf.client';
          command.Open;
          command.Close;

          command.SQL.Text := 'select * from analitf.userinfo';
          command.Open;
          command.Close;         
        finally
          command.Free;
        end;
      finally
        FEmbConnection.Close;
      end;
      WriteExchangeLog('RestoreFromEtalonThread', '��������� ����������� � ����� ���� ������');

      AProc.DeleteDirectory(ExePath + SDirTableBackup + 'Tmp');

    finally
      FEmbConnection.Free;
    end;

    Restored := True;
    WriteExchangeLog('RestoreFromEtalonThread', '�������� ���� ������ ������� ���������');
  except
    on E : Exception do begin
      Restored := False;
      WriteExchangeLog('TRestoreFromEtalonThread', '������ � ����� �������� ��: ' + E.Message);
    end;
  end;
end;

procedure TRestoreFromEtalonThread.FreeMySqlLib;
begin
  //��� ���� ���� ����� �����, �.�. �� ����������� ������������ ����� ��� �������� �����������
  //���� �� ���-�� ������������ �������� ����� ������ 0, �� ���� ����� �� ���������
  if DM.MainConnection is TMyEmbConnection then
  begin
    if TMySQLAPIEmbeddedEx(MyAPIEmbedded).FClientsCount > 0 then
      WriteExchangeLog('RestoreFromEtalonThread',
        Format('MySql Clients Count ����� ��������� ���� ������: %d',
          [TMySQLAPIEmbeddedEx(MyAPIEmbedded).FClientsCount]));
    MyAPIEmbedded.FreeMySQLLib;
  end;
end;

procedure TRestoreFromEtalonThread.OnScriptExecuteError(Sender: TObject;
  E: Exception; SQL: String; var Action: TErrorAction);
begin
  Action := eaFail;
  WriteExchangeLog(
    'RestoreFromEtalonThread',
    Format(
      '������ ��� ���������� �������: %s'#13#10'��������: %s'#13#10'��� ����������: %s'#13#10'SQL: %s',
      [E.Message, IfThen(Assigned(Sender), Sender.ClassName), E.ClassName, SQL]));
end;

end.
