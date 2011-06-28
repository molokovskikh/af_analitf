library Eraser;

uses
  Windows,
  SysUtils,
  Classes,
  StrUtils,
  LU_Tracer in '..\..\Common\Classes\LU_Tracer.pas',
  FileUtil,
  Waiting in 'Waiting.pas' {WaitingForm},
  UpdateExeThread in 'UpdateExeThread.pas',
  U_TUpdateFileHelper in 'U_TUpdateFileHelper.pas';

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
