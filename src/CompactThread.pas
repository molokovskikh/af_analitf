unit CompactThread;

interface

uses
  Classes;

type
  TCompactThread = class(TThread)
   protected
    procedure Execute; override;
  end;

procedure RunCompactDatabase;

implementation

uses
  DModule, Waiting;

procedure RunCompactDatabase;
var
  CompactThread : TCompactThread;
begin
  CompactThread := TCompactThread.Create(True);
  CompactThread.FreeOnTerminate := True;
  ShowWaiting('Производится сжатие и восстановление базы данных. Подождите...',
    CompactThread);
end;

{ TCompactThread }

procedure TCompactThread.Execute;
begin
  try
    DM.CompactDataBase;
  except
  end;
end;

end.
