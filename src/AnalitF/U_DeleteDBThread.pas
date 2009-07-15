unit U_DeleteDBThread;

interface

uses
  SysUtils, Classes;

  procedure RunDeleteDBFiles();

implementation

uses
  DModule, Waiting, AProc, U_ExchangeLog;

type
  TDeleteDBFiles = class(TThread)
   private
    procedure DeleteDBDirectory(DeleteDirectoryName : String);
   protected
    procedure Execute; override;
  end;


{ TDeleteDBFiles }

procedure TDeleteDBFiles.DeleteDBDirectory(DeleteDirectoryName: String);
begin
  try
    if DirectoryExists(DeleteDirectoryName) then
      DeleteDirectory(DeleteDirectoryName);
  except
    on E : Exception do
      LogExitError(Format( '�� �������� ������� ����� %s : %s ', [DeleteDirectoryName, E.Message ]), Integer(ecDeleteDBFiles));
  end;
end;

procedure TDeleteDBFiles.Execute;
begin
  WriteExchangeLog('AnalitF', '������� ������� ����� ���� ������ ��� ������������ ���� ������.');
  DeleteDBDirectory(ExePath + SDirDataBackup);
  DeleteDBDirectory(ExePath + SDirDataPrev);
  DeleteDBDirectory(ExePath + SDirData);
  WriteExchangeLog('AnalitF', '�������� ������ ���� ������ ����������� �������.');
end;

procedure RunDeleteDBFiles();
var
  RunThread : TDeleteDBFiles;
begin
  RunThread := TDeleteDBFiles.Create(True);
  try
    RunThread.FreeOnTerminate := False;
    ShowWaiting('���������� �������� ������ ���� ������...', RunThread);
  finally
    RunThread.Free;
  end;
end;


end.
