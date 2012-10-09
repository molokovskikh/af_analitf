unit ArchiveHelper;

interface

uses
  SysUtils, Classes,
  Windows,
  U_ExchangeLog,
  IdCoderMIME,
  AProc,
  SevenZip,
  FileUtil;

type
  TArchiveHelper = class
   private
    //Список вложений
    FAttachs : TStringList;
    TempSendDir : String;    //Временная папка для создания аттачмента
    procedure CopyingFiles;
    function EncodeToBase64 : String;
    procedure ArchiveAttach;
    procedure Init;
    function GetArchFileName() : String;  
   public
    constructor Create(FileName : String); overload;
    constructor Create(Attachs : TStringList); overload;
    function GetEncodedContent : String;
    function GetArchivedSize : Int64;
    destructor Destroy; override;
  end;


implementation

{ TArchiveHelper }

procedure TArchiveHelper.ArchiveAttach;
var
  SevenZipRes : Integer;
begin
  SZCS.Enter;
  try
    SevenZipRes := SevenZipCreateArchive(
      0,
      GetArchFileName(),
      GetAFTempDir() + TempSendDir,
      '*.*',
      9,
      false,
      false,
      '',
      false,
      nil);
  finally
    SZCS.Leave;
  end;
  if SevenZipRes <> 0 then
    raise Exception.CreateFmt(
      'Не удалось заархивировать отправляемые файлы. ' +
      'Код ошибки %d. ' +
      'Код ошибки 7-zip: %d.'#13#10 +
      'Текст ошибки: %s',
      [SevenZipRes,
       SevenZip.LastSevenZipErrorCode,
       SevenZip.LastError]);
end;

procedure TArchiveHelper.CopyingFiles;
var
  I : Integer;
begin
  for I := 0 to FAttachs.Count-1 do
    if FileExists(FAttachs[i]) then
      if not Windows.CopyFile(PChar(FAttachs[i]), PChar(GetAFTempDir() + TempSendDir + '\' +ExtractFileName(FAttachs[i])), false) then
        raise Exception.Create('Не удалось скопировать файл: ' + FAttachs[i] + #13#10'Причина: ' + SysErrorMessage(GetLastError));
end;

constructor TArchiveHelper.Create(FileName: String);
begin
  Init;
  FAttachs.Add(FileName);
end;

constructor TArchiveHelper.Create(Attachs: TStringList);
begin
  Init;
  FAttachs.AddStrings(Attachs);
end;

destructor TArchiveHelper.Destroy;
begin
  FAttachs.Free;
  inherited;
end;

function TArchiveHelper.EncodeToBase64: String;
var
  FS : TFileStream;
  LE : TIdEncoderMIME;
begin
  Result := '';
  LE := TIdEncoderMIME.Create(nil);
  try
    FS := TFileStream.Create(GetArchFileName(), fmOpenReadWrite);
    try
      Result := le.Encode(FS);
      Result := Trim(Result);
    finally
      FS.Free;
    end;
  finally
    LE.Free;
  end;
end;

function TArchiveHelper.GetArchFileName: String;
begin
  Result := GetAFTempDir() + TempSendDir + '\Attach.7z';
end;

function TArchiveHelper.GetArchivedSize: Int64;
begin
  if DirectoryExists(GetAFTempDir() + TempSendDir) then
    DeleteFilesByMask(GetAFTempDir() + TempSendDir + '\*.*');

  if not DirectoryExists(GetAFTempDir() + TempSendDir) then
    if not CreateDir(GetAFTempDir() + TempSendDir) then
      RaiseLastOSErrorWithMessage('Не получилось создать временную директорию: ' + GetAFTempDir() + TempSendDir);

  //Формируем список файлов
  CopyingFiles;

  ArchiveAttach;

  Result := GetFileSize(GetArchFileName());
end;

function TArchiveHelper.GetEncodedContent: String;
begin
  Result := '';

  if DirectoryExists(GetAFTempDir() + TempSendDir) then
    DeleteFilesByMask(GetAFTempDir() + TempSendDir + '\*.*');

  if not DirectoryExists(GetAFTempDir() + TempSendDir) then
    if not CreateDir(GetAFTempDir() + TempSendDir) then
      RaiseLastOSErrorWithMessage('Не получилось создать временную директорию: ' + GetAFTempDir() + TempSendDir);

  //Формируем список файлов
  CopyingFiles;

  ArchiveAttach;

  Result := EncodeToBase64;
end;

procedure TArchiveHelper.Init;
begin
  TempSendDir := 'AFRec';
  FAttachs := TStringList.Create;
end;

end.
