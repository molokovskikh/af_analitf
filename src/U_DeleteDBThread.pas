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
    procedure DeleteDBFile(DeleteDBFileName : String);
   protected
    procedure Execute; override;
  end;


{ TDeleteDBFiles }

procedure TDeleteDBFiles.DeleteDBFile(DeleteDBFileName: String);
begin
  try
    if FileExists(DeleteDBFileName) then
      AProc.DeleteFileA(DeleteDBFileName);
  except
    on E : Exception do
      LogExitError(Format( 'Не возможно удалить файл %s : %s ', [DeleteDBFileName, E.Message ]), Integer(ecDeleteDBFiles));
  end;
end;

procedure TDeleteDBFiles.Execute;
begin
  WriteExchangeLog('AnalitF', 'Попытка удалить файлы базы данных для пересоздания базы данных.');
  DeleteDBFile(ChangeFileExt(ParamStr(0), '.bak'));
  DeleteDBFile(ChangeFileExt(ParamStr(0), '.etl'));
  DeleteDBFile(ChangeFileExt(ParamStr(0), '.fdb'));
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
