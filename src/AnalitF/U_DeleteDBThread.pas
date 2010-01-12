unit U_DeleteDBThread;

interface

uses
  SysUtils, Classes;

  procedure RunDeleteDBFiles();

implementation

uses
  DModule, Waiting, AProc, U_ExchangeLog, DatabaseObjects;

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
    DeleteDirectory(DeleteDirectoryName);
  except
    on E : Exception do
      LogExitError(Format( 'Не возможно удалить папку %s : %s ', [DeleteDirectoryName, E.Message ]), Integer(ecDeleteDBFiles));
  end;
end;

procedure TDeleteDBFiles.Execute;
begin
  WriteExchangeLog('AnalitF', 'Попытка удалить файлы базы данных для пересоздания базы данных.');
  DeleteDBDirectory(ExePath + SDirData + '\analitf');
  WriteExchangeLog('AnalitF', 'Удаление файлов базы данных завершилось успешно.');
end;

procedure RunDeleteDBFiles();
var
  RunThread : TDeleteDBFiles;
begin
  RunThread := TDeleteDBFiles.Create(True);
  try
    RunThread.FreeOnTerminate := False;
    ShowWaiting('Происходит удаление файлов базы данных...', RunThread);
  finally
    RunThread.Free;
  end;
end;


end.
