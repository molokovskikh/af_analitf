unit RollbackAFThread;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Tlhelp32,
  StrUtils,
  LU_Tracer,
  FileUtil,
  Waiting,
  U_TUpdateFileHelper;

const
  BackDir = 'UpdateBackup';
  AnalitFExe = 'AnalitF.exe';

type
  TRollbackAFThread = class(TWaitingThread)
   private
    trLog : TTracer;
    rootFolder : String;
    backupDirExists : Boolean;
    analitFBakExists : Boolean;
    dataBakExists : Boolean;
    tableBackupBakExists : Boolean;
    function Check() : Boolean;
    function NetworkVersion() : Boolean;
    function AnalitFRunning() : Boolean;
    function FindProcess(ExeFileName: string): Boolean;
    procedure Prepare();
    procedure RollbackFiles();
    function RenameFiles(folder : String) : Boolean;
    function RollbackDataFiles() : Boolean;
    procedure RunAnalitF();
   protected
    procedure Execute; override;
  end;

implementation

{ TRollbackAFThread }

{

Что надо сделать:

1. Спросить пользователя, что он действительно этого хочет, если есть чего обновлять
2. Проверить, что не сетевая версия
3. Проверить, что программа не запущена
4. Если есть, какая-либо папка: Data или TableBackup, то надо сделать:
    - удалить папки In, DataBackup, Data, DataPrev, TableBackup
    - скопировать папки Data и TableBackup на уровень выше
    - удалить папки Data и TableBackup
5. Переименовать все файлы, удаляя bak из расширения
6. Перенести все файлы на уровень выше
7. Запустить AnalitF

  SDirData = 'Data';
  SDirDataTmpDir = 'DataTmpDir';
  SDirTableBackup = 'TableBackup';
  SDirDataBackup = 'DataBackup';
  SDirDataPrev   = 'DataPrev';


}

function TRollbackAFThread.AnalitFRunning: Boolean;
begin
  Result := FindProcess(rootFolder + AnalitFExe);
  if Result then
    MessageBox(WaitFormHandle,
      'Перед откатом обновления AnalitF необходимо закрыть программу.',
      'Ошибка',
      MB_ICONERROR);
end;

function TRollbackAFThread.Check: Boolean;
begin
  Result := analitFBakExists;
  if Result then begin
    Result :=
      MessageBox(WaitFormHandle,
        'Откат обновления AnalitF является необратимой операцией.'#13#10 +
        'Вы действительно хотите выполнить эту операцию?',
        'Вопрос',
        MB_ICONQUESTION or MB_YESNO) = ID_YES;
    if Result then
      Result := not NetworkVersion();
    if Result then
      Result := not AnalitFRunning();
  end;
end;

procedure TRollbackAFThread.Execute;
begin
  try
    Prepare();

    if Check() then begin
      trLog := TTracer.Create(rootFolder + 'Exchange', 'log', 0);
      try
        trLog.TR('RollbackAF', 'Начали откат обновления');
        RollbackFiles();

        trLog.TR('RollbackAF', 'Закончили откат обновления');
        FreeAndNil(trLog);

        RunAnalitF();
      finally
        if Assigned(trLog) then
          trLog.Free;
      end;
    end;
  except
  end;
end;

function TRollbackAFThread.FindProcess(ExeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := False;

  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

    while integer(ContinueLoop) <> 0 do
    begin
      if LowerCase(FProcessEntry32.szExeFile) = LowerCase(ExeFileName)
      then begin
        Result := True;
        Exit;
      end;
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
  finally
    CloseHandle(FSnapshotHandle);
  end;
end;

function TRollbackAFThread.NetworkVersion: Boolean;
var
  sl : TStringList;
begin
  Result := FileExists(rootFolder + 'AnalitF.config');
  if Result then begin
    sl := TStringList.Create;
    try
      sl.LoadFromFile(rootFolder + 'AnalitF.config');
      Result := Trim(sl.Values['IsNetworkVersion']) = '1';
    finally
      sl.Free
    end;
  end;
  if Result then
    MessageBox(WaitFormHandle,
      'На "сетевой" версии откат обновления AnalitF невозможен.',
      'Ошибка',
      MB_ICONERROR);
end;

procedure TRollbackAFThread.Prepare;
begin
  rootFolder := ExtractFilePath(ParamStr(0));
  backupDirExists := DirectoryExists(rootFolder + BackDir);
  analitFBakExists := backupDirExists and FileExists(rootFolder + BackDir + '\' + AnalitFExe + '.bak');
  dataBakExists := backupDirExists and DirectoryExists(rootFolder + BackDir + '\' + 'Data');
  tableBackupBakExists := backupDirExists and DirectoryExists(rootFolder + BackDir + '\' + 'TableBackup');
end;

function TRollbackAFThread.RenameFiles(folder: String) : Boolean;
var
  SR : TSearchRec;
begin
  Result := True;
  //Если удаляемая директория не существует, то просто выходим
  if not DirectoryExists(folder) then
    Exit;

  try
    if FindFirst(folder + '\*.*', faAnyFile, sr) = 0 then
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then
          //Если мы встретили директорию
          if (sr.Attr and faDirectory > 0) then begin
            Result := RenameFiles(folder + '\' + sr.Name);
            if not Result then
              Exit;
          end
          else begin
            if LowerCase(ExtractFileExt(sr.Name)) = '.bak' then begin
              Result := TUpdateFileHelper.MoveFile(folder + '\' + sr.Name, folder + '\' + ChangeFileExt(sr.Name, ''), trLog, 'RollbackAF');
              if not Result then
                Exit;
            end;
          end;

      until FindNext(sr) <> 0;
  finally
    SysUtils.FindClose(sr);
  end;
end;

function TRollbackAFThread.RollbackDataFiles : Boolean;
begin
  Result := True;

  if DirectoryExists(rootFolder + 'In') then
    Result := TUpdateFileHelper.DeleteDirectory(rootFolder + 'In', trLog, 'RollbackAF');
  if Result and DirectoryExists(rootFolder + 'DataBackup') then
    Result := TUpdateFileHelper.DeleteDirectory(rootFolder + 'DataBackup', trLog, 'RollbackAF');
  if Result and DirectoryExists(rootFolder + 'DataPrev') then
    Result := TUpdateFileHelper.DeleteDirectory(rootFolder + 'DataPrev', trLog, 'RollbackAF');
  if Result and DirectoryExists(rootFolder + 'TableBackup') then
    Result := TUpdateFileHelper.DeleteDirectory(rootFolder + 'TableBackup', trLog, 'RollbackAF');
  if Result and DirectoryExists(rootFolder + 'Data') then
    Result := TUpdateFileHelper.DeleteDirectory(rootFolder + 'Data', trLog, 'RollbackAF');

  if Result and dataBakExists then
    Result := TUpdateFileHelper.MoveDirectories(rootFolder + BackDir + '\' + 'Data', rootFolder + 'Data', trLog, 'RollbackAF');

  if Result and tableBackupBakExists then
    Result := TUpdateFileHelper.MoveDirectories(rootFolder + BackDir + '\' + 'TableBackup', rootFolder + 'TableBackup', trLog, 'RollbackAF');
end;

procedure TRollbackAFThread.RollbackFiles;
var
  osResult : Boolean;
begin
  osResult := True;
  if dataBakExists or tableBackupBakExists then
    osResult := RollbackDataFiles();

  if osResult then
    osResult := RenameFiles(rootFolder);

  if osResult then
    osResult := TUpdateFileHelper.UpdateFiles(NormalDir(rootFolder + BackDir), NormalDir(rootFolder), '', trLog, 'RollbackAF');

  if not osResult then
    MessageBox(WaitFormHandle, 'Откат обновления программы завершилось с ошибкой.'#13#10'Пожалуйста, свяжитесь с АК Инфорум.', 'Ошибка', MB_ICONERROR);
end;

procedure TRollbackAFThread.RunAnalitF;
var
  SI: TStartupInfo;
  PI: TProcessInformation;
begin
  FillChar( SI, SizeOf( SI), 0);
  SI.cb := SizeOf( SI);
  CreateProcess(
    nil,
    PChar( rootFolder + AnalitFExe),
    nil,
    nil,
    False,
    CREATE_DEFAULT_ERROR_MODE,
    nil,
    PChar( rootFolder ),
    SI,
    PI);
end;

end.
