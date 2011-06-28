unit U_TUpdateFileHelper;

interface

uses
  Windows,
  SysUtils,
  Classes,
  StrUtils,
  LU_Tracer,
  FileUtil;

const
  //Максимальное кол-во повторов в файловых операциях
  MaxRepeatCount = 20;

type
  TUpdateFileHelper = class
   private
    class function RemoveDirectory(const Dir : String) : LongBool;
   public
    class function CopyFile(sourceFile, destinationFile : String; log : TTracer; subsystem : String) : Boolean;
    class function DeleteFile(deleteFile : String; log : TTracer; subsystem : String) : Boolean;
    class function MoveFile(sourceFile, destinationFile : String; log : TTracer; subsystem : String) : Boolean;
    class function SetFileAttributes(fileName : String; log : TTracer; subsystem : String) : Boolean;
    class function UpdateFiles(InDir, OutDir, BackDir : String; log : TTracer; subsystem : String) : Boolean;
    class function DeleteDirectory(const Dir : String; log : TTracer; subsystem : String) : Boolean;
    class function MoveDirectories(const fromDir, toDir: String; log : TTracer; subsystem : String) : Boolean;
  end;

implementation

{ TUpdateFileHelper }

class function TUpdateFileHelper.CopyFile(sourceFile, destinationFile : String; log : TTracer; subsystem : String): Boolean;
var
  I : Integer;
begin
  //Пытаемся обновить файл с помощью копирования, а потом удаления исходников,
  //т.к. в некоторых случаях MoveFile в Vista работает некорректно
  Result := False;
  for I := 1 to MaxRepeatCount do begin
    if Windows.CopyFile(PChar(sourceFile), PChar(destinationFile), False) then begin
      Result := True;
      break;
    end;
    Sleep(500);
  end;
  if not Result then
    log.TR(
      subsystem,
      'Не получилось скопировать файл ' + sourceFile + ' в ' + destinationFile + ' : ' +
        SysErrorMessage(GetLastError()));
end;

class function TUpdateFileHelper.DeleteDirectory(const Dir: String;
  log: TTracer; subsystem: String): Boolean;
var
  SR : TSearchRec;
  DeleteLastError : Cardinal;
  DirList : TStringList;
  I : Integer;
begin
  Result := True;
  //Если удаляемая директория не существует, то просто выходим
  if not DirectoryExists(Dir) then
    Exit;

  DirList := TStringList.Create();
  try
    try
      if FindFirst(Dir + '\*.*', faAnyFile, sr) = 0 then
        repeat
          if (sr.Name <> '.') and (sr.Name <> '..') then

            //Если мы встретили директорию
            if (sr.Attr and faDirectory > 0) then
              DirList.Add(sr.Name)
              //DeleteDirectory(Dir + '\' + sr.Name)
            else begin
              Result := DeleteFile(Dir + '\' + sr.Name, log, subsystem);
              if not Result then
                Exit;
            end;

        until FindNext(sr) <> 0;
    finally
      SysUtils.FindClose(sr);
    end;

    for I := 0 to DirList.Count-1 do begin
      Result := DeleteDirectory(Dir + '\' + DirList[i], log, subsystem);
      if not Result then
        Exit;
    end;
  finally
    DirList.Free;
  end;

  if not RemoveDirectory(Dir) then begin
    DeleteLastError := Windows.GetLastError();
    if DeleteLastError <> Windows.ERROR_SUCCESS then
    begin
      log.TR(
        subsystem,
        Format('Ошибка при удалении директории %s: (%d) %s',
         [Dir, DeleteLastError, SysErrorMessage(DeleteLastError)]));
      Result := False;
    end;
  end;
end;

class function TUpdateFileHelper.DeleteFile(deleteFile: String;
  log: TTracer; subsystem: String): Boolean;
var
  I : Integer;
begin
  Result := False;
  for I := 1 to MaxRepeatCount do begin
    if Windows.DeleteFile(PChar(deleteFile)) then begin
      Result := True;
      break;
    end;
    Sleep(500);
  end;
  if not Result then
    log.TR(
      subsystem,
      'Не получилось удалить файл ' + deleteFile + ': ' +
        SysErrorMessage(GetLastError()));
end;

class function TUpdateFileHelper.MoveDirectories(const fromDir,
  toDir: String; log: TTracer; subsystem: String): Boolean;
var
  SR : TSearchRec;
  fileList : String;
  DeleteLastError : Cardinal;
  DirList : TStringList;
  I : Integer;
begin
  Result := True;
  fileList := '';
  if not DirectoryExists(toDir) then
    ForceDirectories(toDir);

  DirList := TStringList.Create();
  try
    try
      if FindFirst(fromDir + '\*.*', faAnyFile, sr) = 0 then
        repeat
          if (sr.Name <> '.') and (sr.Name <> '..') then

            //Если мы встретили директорию
            if (sr.Attr and faDirectory > 0) then
              DirList.Add(sr.Name)
              //MoveDirectories(fromDir + '\' + sr.Name, toDir + '\' + sr.Name)
            else begin
              Result := MoveFile(fromDir + '\' + sr.Name, toDir + '\' + sr.Name, log, subsystem);
              if not Result then
                Exit;
            end;

        until FindNext(sr) <> 0;
    finally
      SysUtils.FindClose(sr);
    end;

    for I := 0 to DirList.Count-1 do begin
      Result := MoveDirectories(fromDir + '\' + DirList[i], toDir + '\' + DirList[i], log, subsystem);
      if not Result then
        Exit;
    end;
  finally
    DirList.Free;
  end;

  if not RemoveDirectory(fromDir) then begin
    DeleteLastError := Windows.GetLastError();
    if DeleteLastError <> Windows.ERROR_SUCCESS then
    begin
      Sleep(1000);

      if not Windows.RemoveDirectory(PChar(fromDir)) then begin
        DeleteLastError := Windows.GetLastError();
        if DeleteLastError <> Windows.ERROR_SUCCESS then
        begin
          log.TR(
            subsystem,
            Format('Ошибка при перемещении директории %s: (%d) %s',
             [fromDir, DeleteLastError, SysErrorMessage(DeleteLastError)]));
          Result := False;
        end;
      end;
    end;
  end;
end;

class function TUpdateFileHelper.MoveFile(sourceFile, destinationFile : String; log: TTracer;
  subsystem: String): Boolean;
begin
  Result := SetFileAttributes(sourceFile, log, subsystem);
  if Result then
    Result := CopyFile(sourceFile, destinationFile, log, subsystem);
  if Result then
    Result := DeleteFile(sourceFile, log, subsystem);
end;

class function TUpdateFileHelper.RemoveDirectory(const Dir: String): LongBool;
var
  SleepCount : Integer;
begin
  SleepCount := 0;
  repeat
    Result := Windows.RemoveDirectory(PChar(Dir));
    if not Result then begin
      Inc(SleepCount);
      Sleep(3000);
    end;
  until Result or (SleepCount >= 3);
end;

class function TUpdateFileHelper.SetFileAttributes(fileName: String;
  log: TTracer; subsystem: String): Boolean;
var
  I : Integer;
begin
  Result := False;
  for I := 1 to MaxRepeatCount do begin
    if Windows.SetFileAttributes(PChar(fileName), FILE_ATTRIBUTE_NORMAL) then begin
      Result := True;
      break;
    end;
    Sleep(500);
  end;
  if not Result then
    log.TR(
      subsystem,
      'Не получилось установить атрибуты файла ' + fileName + ': ' +
        SysErrorMessage(GetLastError()));
end;

class function TUpdateFileHelper.UpdateFiles(
  InDir,
  OutDir,
  BackDir: String;
  log: TTracer;
  subsystem: String): Boolean;
var
  SR : TSearchRec;
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
              log.TR(
                subsystem,
                'Не получилось создать директорию ' + OutDir + sr.Name + ': ' +
                  SysErrorMessage(GetLastError()));
              Exit;
            end;

          //Пытаемся создать директорию в Backup-директории, если задан параметр BackDir
          if (Length(BackDir) > 0) and not DirectoryExists(BackDir + sr.Name) then
            if not CreateDir(BackDir + sr.Name) then begin
              Result := False;
              log.TR(
                subsystem,
                'Не получилось создать директорию ' + BackDir + sr.Name + ': ' +
                  SysErrorMessage(GetLastError()));
              Exit;
            end;

          //Запускаем процесс обновления для вложенных директорий
          if (Length(BackDir) > 0) then
            Result := UpdateFiles(InDir + sr.Name + '\', OutDir + sr.Name + '\', BackDir + sr.Name + '\', log, subsystem)
          else
            Result := UpdateFiles(InDir + sr.Name + '\', OutDir + sr.Name + '\', '', log, subsystem);
          if not Result then
            Exit;
        end
        else begin

          //Пытаемся сделать резервную копию обновляемого файла и после этого удаляем файл
          if FileExists(OutDir + sr.Name) then begin

            //если задан параметр BackDir, то делаем backup файла 
            if (Length(BackDir) > 0) then begin
              Result := TUpdateFileHelper.CopyFile(OutDir + sr.Name, BackDir + sr.Name + '.bak', log, subsystem);
              if not Result then
                Exit;
            end;

            //Пытаемся установить атрибуты файла
            Result := TUpdateFileHelper.SetFileAttributes(OutDir + sr.Name, log, subsystem);
            if not Result then
              Exit;

            //Пытаемся удалить файл
            Result := TUpdateFileHelper.DeleteFile(OutDir + sr.Name, log, subsystem);
            if not Result then
              Exit;
          end;


          //Пытаемся обновить файл с помощью копирования, а потом удаления исходников,
          //т.к. в некоторых случаях MoveFile в Vista работает некорректно
          Result := TUpdateFileHelper.CopyFile(InDir +  sr.Name, OutDir + sr.Name, log, subsystem);
          if not Result then
            Exit;

          //Пытаемся установить атрибуты файла в папке In
          Result := TUpdateFileHelper.SetFileAttributes(InDir +  sr.Name, log, subsystem);
          if not Result then
            Exit;

          //Пытаемся удалить файл в папке In
          Result := TUpdateFileHelper.DeleteFile(InDir +  sr.Name, log, subsystem);
          if not Result then
            Exit;
        end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

end.
