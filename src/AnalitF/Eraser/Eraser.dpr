library Eraser;

uses
  Windows,
  SysUtils,
  Classes,
  StrUtils,
  LU_Tracer in '..\common\LU_Tracer.pas',
  FileUtil,
  Waiting in 'Waiting.pas' {WaitingForm},
  UpdateExeThread in 'UpdateExeThread.pas';

{$R *.res}

procedure Erase; stdcall;
begin
  try

    ShowWaiting('Внимание! Происходит обновление программы. Пожалуйста, подождите...', TUpdateExeThread.Create(True));

  except
  end;
 	FreeLibrary( GetModuleHandle(nil) );
end;

exports Erase;

begin
end.
