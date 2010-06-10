unit ArchiveHelper;

interface

uses
  SysUtils, Classes,
    Constant, DModule, ExchangeParameters, U_ExchangeLog, SOAPThroughHTTP,
  DatabaseObjects, MyAccess, DocumentTypes, AProc, U_SGXMLGeneral, IdCoderMIME,
  SevenZip, IdHttp, FileUtil, U_SXConversions, Windows;
  
type
  TArchiveHelper = class
   private
    TempSendDir : String;    //Временная папка для создания аттачмента
   public
    ArchFileName : String;
    constructor Create(FileName : String);
    function GetEncodedContent : String;
  end;


implementation

{ TArchiveHelper }

constructor TArchiveHelper.Create(FileName: String);
begin
  TempSendDir := 'AFRec';
  ArchFileName := FileName;
end;

function TArchiveHelper.GetEncodedContent: String;
var
  SevenZipRes : Integer;
  FS : TFileStream;
  bs : String;
  LE : TIdEncoderMIME;

  procedure CopyingFiles;
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

  procedure ArchiveAttach;
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

  procedure EncodeToBase64;
  begin
    LE := TIdEncoderMIME.Create(nil);
    try
      FS := TFileStream.Create(GetTempDir + TempSendDir + '\Attach.7z', fmOpenReadWrite);
      try
        //bs := le.Encode(FS, ((FS.Size div 3) + 1) * 3);
        bs := le.Encode(FS);
//        Result.Clear;
//        FS.Position := 0;
//        le.Encode(FS, Result);
      finally
        FS.Free;
      end;
    finally
      LE.Free;
    end;
  end;

begin
  if DirectoryExists(GetTempDir + TempSendDir) then
    if not ClearDir(GetTempDir + TempSendDir, True) then
      raise Exception.Create('Не получилось удалить временную директорию: ' + GetTempDir + TempSendDir);

  if not CreateDir(GetTempDir + TempSendDir) then
    raise Exception.Create('Не получилось создать временную директорию: ' + GetTempDir + TempSendDir);

  //Формируем список файлов
  CopyingFiles;

  ArchiveAttach;

  EncodeToBase64;

  Result := bs;
end;

end.
