program RollbackAF;

uses
  Windows,
  SysUtils,
  Classes,
  StrUtils,
  LU_Tracer in '..\..\Common\Classes\LU_Tracer.pas',
  FileUtil,
  Waiting in '..\Eraser\Waiting.pas' {WaitingForm},
  U_TUpdateFileHelper in '..\Eraser\U_TUpdateFileHelper.pas',
  UpdateExeThread in '..\Eraser\UpdateExeThread.pas',
  RollbackAFThread in 'RollbackAFThread.pas';

{$R *.res}

var
  errorLog : TTracer;
begin
  try
    ShowWaiting('Внимание! Происходит откат обновления программы. Пожалуйста, подождите...', TRollbackAFThread.Create(True));
  except
    on E : Exception do begin
      try
      errorLog := TTracer.Create('', 'log', 0);
      try
        errorLog.TR('RollbackAF', 'Ошибка: ' + E.Message);
      finally
        errorLog.Free;
      end;
      except
      end;
      MessageBox(0, 'Во время отката обновления AnalitF возникла ошибка.'#13#10'Пожалуйста, свяжитесь с АК Инфорум.', 'Ошибка', MB_ICONERROR);
    end;
  end;
end.
