unit U_frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LU_Tracer, StrUtils, StdCtrls, Contnrs;

const
  SDirData = 'Data';
  SDirDataBackup = 'DataBackupTest';
  SDirDataPrev   = 'DataPrevTest';

type
  TfrmMain = class(TForm)
    btnPrepareOld: TButton;
    btnPrepareNew: TButton;
    btnDeleteOld: TButton;
    btnDeleteNew: TButton;
    btnPrepareEmpty: TButton;
    btnClear: TButton;
    btnTest: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnPrepareOldClick(Sender: TObject);
    procedure btnDeleteOldClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnPrepareEmptyClick(Sender: TObject);
    procedure btnPrepareNewClick(Sender: TObject);
    procedure btnDeleteNewClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    handlers : TObjectList;
    procedure OnMainAppEx(Sender: TObject; E: Exception);
  public
    { Public declarations }
  end;

  TButtonHandler = class
   private
    OldEvent :  TNotifyEvent;
   public
    constructor Create(logButton : TButton);
    procedure LogEvent(Sender: TObject);
  end;

var
  frmMain: TfrmMain;
  ExePath : string;
  logTracer : TTracer;

implementation

{$R *.dfm}

//Common
procedure OSDeleteFile(FileName: string; RaiseException: Boolean=True);
var
  DeleteLastError : Cardinal;
  Ex : EOSError;
begin
  if not Windows.DeleteFile(PChar(FileName)) and RaiseException then
  begin
    DeleteLastError := Windows.GetLastError();
    if DeleteLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при удалении файла %s: %s',
        [FileName, SysErrorMessage(DeleteLastError)]);
      Ex.ErrorCode := DeleteLastError;
      raise Ex;
    end;
  end;
end;

procedure OSCopyFile(Source, Destination: string);
var
  CopyLastError : Cardinal;
  Ex : EOSError;
begin
  if FileExists(Destination) then begin
    SetFileAttributes(PChar(Destination), FILE_ATTRIBUTE_NORMAL);
    OSDeleteFile(Destination, False);
  end;
  if not Windows.CopyFile(PChar(Source), PChar(Destination), False) then
  begin
    CopyLastError := Windows.GetLastError();
    if CopyLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при копировании файла %s в %s: %s',
        [Source, Destination, SysErrorMessage(CopyLastError)]);
      Ex.ErrorCode := CopyLastError;
      raise Ex;
    end;
  end;
end;

procedure OSMoveFile(Source, Destination: string);
var
  MoveLastError : Cardinal;
  Ex : EOSError;
begin
  if FileExists(Destination) then begin
    SetFileAttributes(PChar(Destination), FILE_ATTRIBUTE_NORMAL);
    OSDeleteFile(Destination, False);
  end;
  if not Windows.CopyFile(PChar(Source), PChar(Destination), False) then
  begin
    MoveLastError := Windows.GetLastError();
    if MoveLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при перемещении файла %s в %s: %s',
        [Source, Destination, SysErrorMessage(MoveLastError)]);
      Ex.ErrorCode := MoveLastError;
      raise Ex;
    end;
  end;
  SetFileAttributes(PChar(Source), FILE_ATTRIBUTE_NORMAL);
  OSDeleteFile(Source, True);
end;

//Old
procedure DeleteDirectoryOld(const Dir : String);
var
  SR : TSearchRec;
  DeleteLastError : Cardinal;
  Ex : EOSError;
begin
  //Если удаляемая директория не существует, то просто выходим
  if not DirectoryExists(Dir) then
    Exit;
  if FindFirst(Dir + '\*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then

        //Если мы встретили директорию
        if (sr.Attr and faDirectory > 0) then
          DeleteDirectoryOld(Dir + '\' + sr.Name)
        else
          OSDeleteFile(Dir + '\' + sr.Name);

    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;

  if not Windows.RemoveDirectory(PChar(Dir)) then begin
    DeleteLastError := Windows.GetLastError();
    if DeleteLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при удалении директории %s: %s',
        [Dir, SysErrorMessage(DeleteLastError)]);
      Ex.ErrorCode := DeleteLastError;
      raise Ex;
    end;
  end;
end;

procedure CopyDirectoriesOld(const fromDir, toDir: String);
var
  SR : TSearchRec;
begin
  if not DirectoryExists(toDir) then
    ForceDirectories(toDir);

  if FindFirst(fromDir + '\*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then

        //Если мы встретили директорию
        if (sr.Attr and faDirectory > 0) then
          CopyDirectoriesOld(fromDir + '\' + sr.Name, toDir + '\' + sr.Name)
        else
          OSCopyFile(fromDir + '\' + sr.Name, toDir + '\' + sr.Name);

    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;
end;

procedure CopyDataDirToBackupOld(const dataDir, backupDir: String);
begin
  if not DirectoryExists(backupDir) then
    ForceDirectories(backupDir);

  if DirectoryExists(dataDir + '\analitf') then
    CopyDirectoriesOld(dataDir + '\analitf', backupDir + '\analitf');

  if DirectoryExists(dataDir + '\mysql') then
    CopyDirectoriesOld(dataDir + '\mysql', backupDir + '\mysql');
end;

procedure MoveDirectoriesOld(const fromDir, toDir: String);
var
  SR : TSearchRec;
  DeleteLastError : Cardinal;
  Ex : EOSError;
begin
  if not DirectoryExists(toDir) then
    ForceDirectories(toDir);

  if FindFirst(fromDir + '\*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then

        //Если мы встретили директорию
        if (sr.Attr and faDirectory > 0) then
          MoveDirectoriesOld(fromDir + '\' + sr.Name, toDir + '\' + sr.Name)
        else
          OSMoveFile(fromDir + '\' + sr.Name, toDir + '\' + sr.Name);

    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;

  if not Windows.RemoveDirectory(PChar(fromDir)) then begin
    DeleteLastError := Windows.GetLastError();
    if DeleteLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при перемещении директории %s: %s',
        [fromDir, SysErrorMessage(DeleteLastError)]);
      Ex.ErrorCode := DeleteLastError;
      raise Ex;
    end;
  end;
end;

//New
procedure DeleteDirectoryNew(const Dir : String);
var
  SR : TSearchRec;
  DeleteLastError : Cardinal;
  Ex : EOSError;
begin
  //Если удаляемая директория не существует, то просто выходим
  if not DirectoryExists(Dir) then
    Exit;
  try
    if FindFirst(Dir + '\*.*', faAnyFile, sr) = 0 then
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then

          //Если мы встретили директорию
          if (sr.Attr and faDirectory > 0) then
            DeleteDirectoryNew(Dir + '\' + sr.Name)
          else
            OSDeleteFile(Dir + '\' + sr.Name);

      until FindNext(sr) <> 0;
  finally
    SysUtils.FindClose(sr);
  end;

  if not Windows.RemoveDirectory(PChar(Dir)) then begin
    DeleteLastError := Windows.GetLastError();
    if DeleteLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при удалении директории %s: %s',
        [Dir, SysErrorMessage(DeleteLastError)]);
      Ex.ErrorCode := DeleteLastError;
      raise Ex;
    end;
  end;
end;

procedure CopyDirectoriesNew(const fromDir, toDir: String);
var
  SR : TSearchRec;
begin
  if not DirectoryExists(toDir) then
    ForceDirectories(toDir);

  try
    if FindFirst(fromDir + '\*.*', faAnyFile, sr) = 0 then
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then

          //Если мы встретили директорию
          if (sr.Attr and faDirectory > 0) then
            CopyDirectoriesNew(fromDir + '\' + sr.Name, toDir + '\' + sr.Name)
          else
            OSCopyFile(fromDir + '\' + sr.Name, toDir + '\' + sr.Name);

      until FindNext(sr) <> 0;
  finally
    SysUtils.FindClose(sr);
  end;
end;

procedure CopyDataDirToBackupNew(const dataDir, backupDir: String);
begin
  if not DirectoryExists(backupDir) then
    ForceDirectories(backupDir);

  if DirectoryExists(dataDir + '\analitf') then
    CopyDirectoriesNew(dataDir + '\analitf', backupDir + '\analitf');

  if DirectoryExists(dataDir + '\mysql') then
    CopyDirectoriesNew(dataDir + '\mysql', backupDir + '\mysql');
end;

procedure MoveDirectoriesNew(const fromDir, toDir: String);
var
  SR : TSearchRec;
  DeleteLastError : Cardinal;
  Ex : EOSError;
begin
  if not DirectoryExists(toDir) then
    ForceDirectories(toDir);

  try
    if FindFirst(fromDir + '\*.*', faAnyFile, sr) = 0 then
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then

          //Если мы встретили директорию
          if (sr.Attr and faDirectory > 0) then
            MoveDirectoriesNew(fromDir + '\' + sr.Name, toDir + '\' + sr.Name)
          else
            OSMoveFile(fromDir + '\' + sr.Name, toDir + '\' + sr.Name);

      until FindNext(sr) <> 0;
  finally
    SysUtils.FindClose(sr);
  end;

  if not Windows.RemoveDirectory(PChar(fromDir)) then begin
    DeleteLastError := Windows.GetLastError();
    if DeleteLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при перемещении директории %s: %s',
        [fromDir, SysErrorMessage(DeleteLastError)]);
      Ex.ErrorCode := DeleteLastError;
      raise Ex;
    end;
  end;
end;


procedure TfrmMain.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  Application.OnException := OnMainAppEx;
  ExePath := IncludeTrailingBackslash(ExtractFileDir(ParamStr(0))); //путь к программе
  if DirectoryExists(ExePath + SDirDataBackup) then
  begin
    DeleteDirectoryNew(ExePath + SDirDataBackup);
    logTracer.TR('test', 'Удалили тестовою директорию с Backup');
  end;
  if DirectoryExists(ExePath + SDirDataPrev) then
  begin
    DeleteDirectoryNew(ExePath + SDirDataPrev);
    logTracer.TR('test', 'Удалили тестовою директорию с Prev');
  end;
  handlers := TObjectList.Create;
  for I := 0 to ControlCount-1 do
    if (Controls[i] is TButton) and (Controls[i] <> btnTest) then
      handlers.Add(
        TButtonHandler.Create(
          TButton(Controls[i])));
end;

procedure TfrmMain.OnMainAppEx(Sender: TObject; E: Exception);
var
  S, Mess : String;
begin
  S := 'Sender = ' + IfThen(Assigned(Sender), Sender.ClassName, 'nil');
  logTracer.TR('OnMainAppEx', S);
  Mess := Format('В программе произошла необработанная ошибка:'#13#10 +
    '%s'#13#10'%s', [S, E.Message]);
  MessageBox(0, PChar(Mess), PChar('Ошибка'), MB_ICONERROR or MB_OK);
end;

procedure TfrmMain.btnPrepareOldClick(Sender: TObject);
begin
  CopyDataDirToBackupOld(ExePath + SDirData, ExePath + SDirDataBackup);
end;

procedure TfrmMain.btnDeleteOldClick(Sender: TObject);
begin
  DeleteDirectoryOld(ExePath + SDirDataPrev);
  MoveDirectoriesOld(ExePath + SDirDataBackup, ExePath + SDirDataPrev);
end;

procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  if DirectoryExists(ExePath + SDirDataBackup) then
  begin
    DeleteDirectoryNew(ExePath + SDirDataBackup);
    logTracer.TR('test', 'Удалили тестовою директорию с Backup');
  end;
  if DirectoryExists(ExePath + SDirDataPrev) then
  begin
    DeleteDirectoryNew(ExePath + SDirDataPrev);
    logTracer.TR('test', 'Удалили тестовою директорию с Prev');
  end;
end;

procedure TfrmMain.btnPrepareEmptyClick(Sender: TObject);
begin
  if DirectoryExists(ExePath + SDirDataBackup) or DirectoryExists(ExePath + SDirDataPrev) then
    logTracer.TR('test', 'тестовые директории существуют')
  else
  begin
    ForceDirectories(ExePath + SDirDataBackup + '\analitf');
    ForceDirectories(ExePath + SDirDataBackup + '\mysql');
    ForceDirectories(ExePath + SDirDataPrev + '\analitf');
    ForceDirectories(ExePath + SDirDataPrev + '\mysql');
  end;
end;

procedure TfrmMain.btnPrepareNewClick(Sender: TObject);
begin
  CopyDataDirToBackupNew(ExePath + SDirData, ExePath + SDirDataBackup);
end;

procedure TfrmMain.btnDeleteNewClick(Sender: TObject);
begin
  DeleteDirectoryNew(ExePath + SDirDataPrev);
  MoveDirectoriesNew(ExePath + SDirDataBackup, ExePath + SDirDataPrev);
end;

{ TButtonHandler }

constructor TButtonHandler.Create(logButton: TButton);
begin
  if Assigned(logButton) and Assigned(logButton.OnClick) then begin
    OldEvent := logButton.OnClick;
    logButton.OnClick := LogEvent;
  end;
end;

procedure TButtonHandler.LogEvent(Sender: TObject);
var
  button : TButton;
begin
  button := TButton(Sender);
  logTracer.TR('OnClick."' + button.Caption + '"', 'начато');
  try
    try
      button.Enabled := False;
      OldEvent(Sender);
    finally
      button.Enabled := True;
    end;
  except
    on E : Exception do
      logTracer.TR('OnClick."' + button.Caption + '"', 'Ошибка : ' + E.Message);
  end;
  logTracer.TR('OnClick."' + button.Caption + '"', 'завершено');
end;

procedure TfrmMain.btnTestClick(Sender: TObject);
begin
  btnTest.Enabled := False;
  logTracer.TR('test', 'started');
  try
    btnPrepareOld.Click;
    btnDeleteOld.Click;
    btnPrepareOld.Click;
    btnDeleteOld.Click;

    btnClear.Click;
    btnPrepareEmpty.Click;
    btnDeleteOld.Click;

    btnClear.Click;

    btnPrepareNew.Click;
    btnDeleteNew.Click;
    btnPrepareNew.Click;
    btnDeleteNew.Click;

    btnClear.Click;
    btnPrepareEmpty.Click;
    btnDeleteNew.Click;

    btnClear.Click;

    MessageBox(0, PChar('Тест завершен'), PChar('Информация'), MB_ICONINFORMATION or MB_OK)
  finally
    btnTest.Enabled := True;
    logTracer.TR('test', 'stopped');
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  btnClear.Click;
end;

initialization
  logTracer := TTracer.Create('Удаление директорий', 'log', 1024*1024);
end.
