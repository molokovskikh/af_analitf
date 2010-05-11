unit CompactThread;

interface

uses
  SysUtils,
  Classes,
  DatabaseObjects;

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


procedure RunCompactDatabase;

function RunRestoreDatabase : Boolean;


implementation

uses
  DModule, Waiting,
  U_ExchangeLog;

procedure RunCompactDatabase;
var
  CompactThread : TCompactThread;
begin
  CompactThread := TCompactThread.Create(True);
  CompactThread.FreeOnTerminate := True;
  DM.MainConnection.Close;
  try
    ShowWaiting('Производится сжатие базы данных. Подождите...',
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
      ShowWaiting('Производится восстановление базы данных. Подождите...',
        RestoreThread);
      Result := RestoreThread.RepairedObjects = [];
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
      WriteExchangeLog('CompactThread', 'Ошибка в нитке сжатия БД: ' + E.Message);
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
      WriteExchangeLog('RestoreThread', 'Ошибка в нитке восстановления БД: ' + E.Message);
    end;
  end;
end;

end.
