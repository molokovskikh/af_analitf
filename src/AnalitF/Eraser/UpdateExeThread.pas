unit UpdateExeThread;

interface

uses
  Windows,
  SysUtils,
  Classes,
  StrUtils,
  LU_Tracer,
  FileUtil,
  Waiting,
  U_TUpdateFileHelper;

const
  BackDir = 'UpdateBackup';

  NetworkDir = 'AnalitFUpdate';

type
  TUpdateExeThread = class(TWaitingThread)
   private
    trLog : TTracer;
    function WaitParentProcess : Boolean;
   protected
    procedure Execute; override;
  end;


implementation

{ TUpdateExeThread }

procedure TUpdateExeThread.Execute;
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  ExeName,
  ExePath,
  InDir,
  Switch : String;
begin
  try
    //Ждем, пока вызвавший процесс не закончит работу
    if not WaitParentProcess then begin
      MessageBox(WaitFormHandle, 'Закончилось время ожидания завершения обновляемой программы.'#13#10'Пожалуйста, свяжитесь с АК Инфорум.', 'Ошибка', MB_ICONERROR);
      Exit;
    end;

    trLog := TTracer.Create(
      IncludeTrailingBackslash(ExtractFileDir(ParamStr(ParamCount-1))) + 'Exchange', 'log', 0);
    try


      //Читаем параметры вызова
      //Директория с обновлениями (без слеша)
      InDir := ParamStr(ParamCount);
      //имя файла для запуска
      ExeName := ParamStr(ParamCount-1);
      //переключатель для запуска
      Switch := ParamStr(ParamCount-3);
      if AnsiSameText(Switch, '/no') or AnsiSameText(Switch, '-no') then
        Switch := '';
      //директория с исполняемыми файлами (со слешем)
      ExePath := ExtractFilePath(ExeName);

      //Пытаемся удалить директорию для Backup
      if DirectoryExists(ExePath + BackDir) then
        if not ClearDir(ExePath + BackDir, True) then
          trLog.TR('Eraser', 'Не получилось удалить директорию ' + BackDir
            + ': ' + SysErrorMessage(GetLastError()));

      //Спим несколько секунд, чтобы система смогла удалить директорию
      Sleep(5000);

      //Создаем директорию для Backup
      if not DirectoryExists(ExePath + BackDir) then
        if not CreateDir(ExePath + BackDir) then begin
          trLog.TR('Eraser', 'Не получилось создать директорию ' + BackDir
            + ': ' + SysErrorMessage(GetLastError()));
          Exit;
        end;

      if not TUpdateFileHelper.UpdateFiles(NormalDir(InDir), NormalDir(ExePath), NormalDir(ExePath + BackDir), trLog, 'Eraser')
      then begin
        if AnsiSameText(Switch, '/si') or AnsiSameText(Switch, '-si') then
          trLog.TR('Eraser', 'Обновления программы завершилось с ошибкой.'#13#10'Пожалуйста, свяжитесь с АК Инфорум.')
        else
          MessageBox(WaitFormHandle, 'Обновления программы завершилось с ошибкой.'#13#10'Пожалуйста, свяжитесь с АК Инфорум.', 'Ошибка', MB_ICONERROR)
      end
      else begin
        if not ClearDir(InDir, True) then
          trLog.TR('Eraser', 'Не получилось удалить директорию ' + InDir
            + ': ' + SysErrorMessage(GetLastError()));

        FreeAndNil(trLog);
        FillChar( SI, SizeOf( SI), 0);
        SI.cb := SizeOf( SI);
        CreateProcess( nil, PChar( ExeName + ' ' +
          Switch), nil, nil, False,
          CREATE_DEFAULT_ERROR_MODE, nil,
          PChar( ExePath ), SI, PI);
      end;

    finally
      if Assigned(trLog) then
        trLog.Free;
    end;
  except
  end;
end;

function TUpdateExeThread.WaitParentProcess: Boolean;
var
  ExternalProcessId : Int64;
  ExternalProcessHandle : THandle;
begin
  Result := True;
  if TryStrToInt64(ParamStr(ParamCount-2), ExternalProcessId) then begin
    ExternalProcessHandle := OpenProcess(Windows.SYNCHRONIZE, FALSE, ExternalProcessId);
    if ExternalProcessHandle <> 0 then begin
      if WaitForSingleObject(ExternalProcessHandle, 3 * 60 * 1000) <> WAIT_OBJECT_0
      then
        //Не дождались завершения программы
        Result := False;
      CloseHandle(ExternalProcessHandle);
    end
    else
      Sleep(10 * 1000);
  end;
end;

end.
