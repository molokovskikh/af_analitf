unit UpdateExeThread;

interface

uses
  Windows,
  SysUtils,
  Classes,
  StrUtils,
  LU_Tracer,
  FileUtil;

const
  BackDir = 'UpdateBackup';
  
type
  TUpdateExeThread = class(TThread)
   private
    trLog : TTracer;
    function UpdateFiles(InDir, OutDir, BackDir : String) : Boolean;
    function WaitParentProcess : Boolean;
   protected
    procedure Execute; override;
   public
    WaitFormHandle : HWND;
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

      if not UpdateFiles(NormalDir(InDir), NormalDir(ExePath), NormalDir(ExePath + BackDir)) then begin
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

function TUpdateExeThread.UpdateFiles(InDir, OutDir, BackDir : String) : Boolean;
var
  SR : TSearchRec;
  I : Integer;
begin
  Result := True;
  if FindFirst(InDir + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then

        //Если мы встретили директорию
        if (sr.Attr and faDirectory > 0) then begin

          //Пытаемся создать директорию в результирующей директории
          if not DirectoryExists(OutDir + sr.Name) then
            if not CreateDir(OutDir + sr.Name) then begin
              Result := False;
              trLog.TR('Eraser', 'Не получилось создать директорию ' + OutDir + sr.Name + ': ' +
                SysErrorMessage(GetLastError()));
              Exit;
            end;

          //Пытаемся создать директорию в Backup-директории
          if not DirectoryExists(BackDir + sr.Name) then
            if not CreateDir(BackDir + sr.Name) then begin
              Result := False;
              trLog.TR('Eraser', 'Не получилось создать директорию ' + BackDir + sr.Name + ': ' +
                SysErrorMessage(GetLastError()));
              Exit;
            end;

          //Запускаем процесс обновления для вложенных директорий
          Result := UpdateFiles(InDir + sr.Name + '\', OutDir + sr.Name + '\', BackDir + sr.Name + '\');
          if not Result then
            Exit;
        end
        else begin

          //Пытаемся сделать резервную копию обновляемого файла и после этого удаляем файл
          if FileExists(OutDir + sr.Name) then begin
            Result := False;
            for I := 1 to 20 do begin
              if Windows.CopyFile(PChar(OutDir +  sr.Name), PChar(BackDir + sr.Name + '.bak'), false) then begin
                Result := True;
                break;
              end;
              Sleep(500);
            end;
            if not Result then begin
              trLog.TR('Eraser', 'Не получилось сделать копию файла ' + sr.Name + ': ' +
                SysErrorMessage(GetLastError()));
              Exit;
            end;

            //Пытаемся установить атрибуты файла
            Result := False;
            for I := 1 to 20 do begin
              if Windows.SetFileAttributes(PChar(OutDir + sr.Name), FILE_ATTRIBUTE_NORMAL) then begin
                Result := True;
                break;
              end;
              Sleep(500);
            end;
            if not Result then begin
              trLog.TR('Eraser', 'Не получилось установить атрибуты файла ' + sr.Name + ': ' +
                SysErrorMessage(GetLastError()));
              Exit;
            end;

            //Пытаемся удалить файл
            Result := False;
            for I := 1 to 20 do begin
              if Windows.DeleteFile(PChar(OutDir + sr.Name)) then begin
                Result := True;
                break;
              end;
              Sleep(500);
            end;
            if not Result then begin
              trLog.TR('Eraser', 'Не получилось удалить файл ' + sr.Name + ': ' +
                SysErrorMessage(GetLastError()));
              Exit;
            end;
          end;


          //Пытаемся обновить файл с помощью копирования, а потом удаления исходников,
          //т.к. в некоторых случаях MoveFile в Vista работает некорректно
          Result := False;
          for I := 1 to 20 do begin
            if Windows.CopyFile(PChar(InDir +  sr.Name), PChar(OutDir + sr.Name), False) then begin
              Result := True;
              break;
            end;
            Sleep(500);
          end;
          if not Result then begin
            trLog.TR('Eraser', 'Не получилось скопировать файл ' + sr.Name + ' в рабочую папку: ' +
              SysErrorMessage(GetLastError()));
            Exit;
          end;

          //Пытаемся установить атрибуты файла в папке In
          Result := False;
          for I := 1 to 20 do begin
            if Windows.SetFileAttributes(PChar(InDir +  sr.Name), FILE_ATTRIBUTE_NORMAL) then begin
              Result := True;
              break;
            end;
            Sleep(500);
          end;
          if not Result then begin
            trLog.TR('Eraser', 'Не получилось установить атрибуты файла ' + sr.Name + ' в папке In: ' +
              SysErrorMessage(GetLastError()));
            Exit;
          end;

          //Пытаемся удалить файл в папке In
          Result := False;
          for I := 1 to 20 do begin
            if Windows.DeleteFile(PChar(InDir +  sr.Name)) then begin
              Result := True;
              break;
            end;
            Sleep(500);
          end;
          if not Result then begin
            trLog.TR('Eraser', 'Не получилось удалить файл ' + sr.Name + ' в папке In: ' +
              SysErrorMessage(GetLastError()));
            Exit;
          end;

        end;
    until FindNext(sr) <> 0;
    FindClose(sr);
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
