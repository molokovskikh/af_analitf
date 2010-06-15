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
    TempSendDir : String;    //Временная папка для создания аттачмента
    procedure CopyingFiles;
    function EncodeToBase64 : String;
    procedure ArchiveAttach;
   public
    ArchFileName : String;
    constructor Create(FileName : String);
    function GetEncodedContent : String;
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
      GetTempDir + TempSendDir + '\Attach.7z',
      GetTempDir + TempSendDir,
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
  SendedFileName : String;
begin
  SendedFileName := GetTempDir + TempSendDir + '\' + ExtractFileName(ArchFileName);
  if not Windows.CopyFile(
     PChar(ArchFileName),
     PChar(SendedFileName), false)
  then
    raise Exception.Create('Не удалось скопировать файл: ' + ArchFileName + #13#10'Причина: ' + SysErrorMessage(GetLastError));
end;

constructor TArchiveHelper.Create(FileName: String);
begin
  TempSendDir := 'AFRec';
  ArchFileName := FileName;
end;

function TArchiveHelper.EncodeToBase64: String;
var
  FS : TFileStream;
  LE : TIdEncoderMIME;
begin
  Result := '';
  LE := TIdEncoderMIME.Create(nil);
  try
    FS := TFileStream.Create(GetTempDir + TempSendDir + '\Attach.7z', fmOpenReadWrite);
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

function TArchiveHelper.GetEncodedContent: String;
begin
  Result := '';

  if DirectoryExists(GetTempDir + TempSendDir) then
    if not ClearDir(GetTempDir + TempSendDir, True) then
      raise Exception.Create('Не получилось удалить временную директорию: ' + GetTempDir + TempSendDir);

  if not CreateDir(GetTempDir + TempSendDir) then
    raise Exception.Create('Не получилось создать временную директорию: ' + GetTempDir + TempSendDir);

  //Формируем список файлов
  CopyingFiles;

  ArchiveAttach;

  Result := EncodeToBase64;
end;

end.
