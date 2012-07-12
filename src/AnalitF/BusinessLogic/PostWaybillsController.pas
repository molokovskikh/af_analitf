unit PostWaybillsController;

interface

uses
  SysUtils, Classes, Contnrs, DB, StrUtils, Variants,
  //App modules
  Constant, DModule, ExchangeParameters, U_ExchangeLog, SOAPThroughHTTP,
  DatabaseObjects, MyAccess, DocumentTypes, AProc, U_SGXMLGeneral, IdCoderMIME,
  SevenZip, IdHttp, FileUtil, U_SXConversions, Windows,
  SendWaybillTypes,
  GlobalSettingParams;

type
  TSendElem = class
   public
    FileName : String;
    SendedFileName : String;
    FirmCode : Int64;
  end;

  WaybillsHelper = class
   public
    class function GetFolderNameFromFullName(fullName : String) : String;
    class function CheckWaybillFolders(Connection : TCustomMyConnection) : Boolean;
  end;

  TPostWaybillsControllerController = class
   private
    FDataLayer : TDM;
    FExchangeParams : TExchangeParams;
    SendIdHTTP : TIdHTTP;    //Компонент для отправки письма
    SendURL : String;        //URL, по которому происходит доступ
    TempSendDir : String;    //Временная папка для создания аттачмента
    Elems   : TObjectList;   //Список отправляемых файлов
    procedure ScanFolders;
    procedure CreateArchive;
    procedure SendArchive;
    procedure DeleteSendedFiles;
   public
    constructor Create(
      dataLayer : TDM;
      exchangeParams : TExchangeParams;
      ASendIdHTTP : TIdHTTP;
      ASendURL : String);
    procedure PostWaybills;
    destructor Destroy; override;
  end;

implementation

uses
  Main,
  UniqueID;
  
{ TPostWaybillsControllerController }

constructor TPostWaybillsControllerController.Create(dataLayer: TDM;
  exchangeParams: TExchangeParams;
  ASendIdHTTP : TIdHTTP;
  ASendURL : String);
begin
  FDataLayer := dataLayer;
  SendIdHTTP := ASendIdHTTP;
  SendURL := ASendURL;
  TempSendDir := 'AFRec';
  Elems   := TObjectList.Create(True);

  FExchangeParams := exchangeParams;
end;

procedure TPostWaybillsControllerController.CreateArchive;
begin

end;

procedure TPostWaybillsControllerController.DeleteSendedFiles;
var
  I : Integer;
begin
  for I := 0 to Elems.Count-1 do
    if FileExists(TSendElem(Elems[i]).FileName) then
      OSDeleteFile(TSendElem(Elems[i]).FileName, False);
end;

destructor TPostWaybillsControllerController.Destroy;
begin

  inherited;
end;

procedure TPostWaybillsControllerController.PostWaybills;
begin
  ScanFolders;
  CreateArchive;
  if Elems.Count > 0 then
    SendArchive;
end;

procedure TPostWaybillsControllerController.ScanFolders;
var
  selectFirmCodes : TMyQuery;
  SR: TSearchrec;
  sendElem : TSendElem;
  folderName : String;
begin
  selectFirmCodes := TMyQuery.Create(nil);
  selectFirmCodes.Connection := FDataLayer.MainConnection;
  selectFirmCodes.SQL.Text := ''
  + 'select '
  + ' Providers.FirmCode, '
  + ' Providers.FullName, '
  + ' ProviderSettings.WaybillFolder '
  + 'from '
  + '  Providers '
  + '  inner join ProviderSettings on ProviderSettings.FirmCode = Providers.FirmCode ';
  selectFirmCodes.Open;
  while not selectFirmCodes.Eof do begin
    if selectFirmCodes.FieldByName('WaybillFolder').AsString = '' then begin
      //Result := False;
      //Break;
    end
    else begin
      folderName := selectFirmCodes.FieldByName('WaybillFolder').AsString;
      folderName := GetFullFileNameByPrefix(folderName, RootFolder());
      if DirectoryExists(folderName) then begin
        try
          if SysUtils.FindFirst(folderName + '\*.*',faAnyFile-faDirectory,SR)=0 then
            repeat
              sendElem := TSendElem.Create;
              sendElem.FirmCode := selectFirmCodes.FieldByName('FirmCode').Value;
              sendElem.FileName := folderName + '\' +SR.Name;
              Elems.Add(sendElem);
              WriteExchangeLog('Exchange',
                Format('Добавляем в архив накладную от поставщика %s: имя файла %s  размер %d',
                [selectFirmCodes.FieldByName('FullName').AsString,
                 SR.Name,
                 FileUtil.GetFileSize(folderName + '\' +SR.Name)]));
            until FindNext(SR)<>0;
        finally
          SysUtils.FindClose(SR);
        end;
        //Result := False;
        //Break;
      end;
    end;
    selectFirmCodes.Next;
  end;
  selectFirmCodes.Close;
end;

procedure TPostWaybillsControllerController.SendArchive;
var
  slLetter : TStringList;
  start,
  stop : Integer;
  SevenZipRes : Integer;
  FS : TFileStream;
  S,
  bs : String;
  LE : TIdEncoderMIME;
  ss : TStringStream;
  OldAccept,
  OldConnection,
  OldContentType : String;
  InternalSendResult : TSendWaybillsStatus;
  InternalSendResultStr : String;

  procedure CopyingFiles;
  var
    I : Integer;
  begin

    for I := 0 to Elems.Count-1 do
      if FileExists(TSendElem(Elems[i]).FileName) then begin
        TSendElem(Elems[i]).SendedFileName := GetAFTempDir() + TempSendDir + '\' + IntToStr(I) + '_' +ExtractFileName(TSendElem(Elems[i]).FileName);
        if not Windows.CopyFile(
           PChar(TSendElem(Elems[i]).FileName),
           PChar(TSendElem(Elems[i]).SendedFileName), false)
        then
          raise Exception.Create('Не удалось скопировать файл: ' + TSendElem(Elems[i]).FileName + #13#10'Причина: ' + SysErrorMessage(GetLastError));
      end;
  end;

  procedure ArchiveAttach;
  begin
    SZCS.Enter;
    try
      SevenZipRes := SevenZipCreateArchive(
        0,
        GetAFTempDir() + TempSendDir + '\Attach.7z',
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

  procedure EncodeToBase64;
  begin
    LE := TIdEncoderMIME.Create(nil);
    try
      FS := TFileStream.Create(GetAFTempDir() + TempSendDir + '\Attach.7z', fmOpenReadWrite);
      try
        bs := le.Encode(FS, ((FS.Size div 3) + 1) * 3);
      finally
        FS.Free;
      end;
    finally
      LE.Free;
    end;
  end;

  procedure FormatSoapMessage;
  var
    I : Integer;
  begin
{
<SendWaybills xmlns="IOS.Service">
      <ClientCode>unsignedInt</ClientCode>
      <FirmCodes>
        <unsignedLong>unsignedLong</unsignedLong>
        <unsignedLong>unsignedLong</unsignedLong>
      </FirmCodes>
      <FileNames>
        <string>string</string>
        <string>string</string>
      </FileNames>
      <Waybills>base64Binary</Waybills>
    </SendWaybills>
}
    slLetter.Add('<?xml version="1.0" encoding="windows-1251"?>');
    slLetter.Add('<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">');
    slLetter.Add('  <soap:Body>');
    slLetter.Add('    <SendWaybillsEx xmlns="IOS.Service">');
    slLetter.Add('      <ClientId>' + FDataLayer.adtClientsCLIENTID.AsString + '</ClientId>');
    slLetter.Add('      <UniqueID>' + IntToHex( GetCopyID, 8) + '</UniqueID>');
    slLetter.Add('      <EXEVersion>' + GetLibraryVersionFromPathForExe(ExePath + ExeName) + '</EXEVersion>');

    slLetter.Add('      <ProviderIds>');
    for I := 0 to Elems.Count-1 do
      slLetter.Add('      <unsignedLong>' + IntToStr(TSendElem(Elems[i]).FirmCode) + '</unsignedLong>');
    slLetter.Add('      </ProviderIds>');

    slLetter.Add('      <FileNames>');
    for I := 0 to Elems.Count-1 do
      slLetter.Add('      <string>' + SXReplaceXML(ExtractFileName( TSendElem(Elems[i]).SendedFileName ) ) + '</string>');
    slLetter.Add('      </FileNames>');

    slLetter.Add(Concat('      <Waybills>', bs, '</Waybills>'));
    slLetter.Add('    </SendWaybillsEx>');
    slLetter.Add('  </soap:Body>');
    slLetter.Add('</soap:Envelope>');
    slLetter.Add('');
    slLetter.Add('');
  end;

begin
  if DirectoryExists(GetAFTempDir() + TempSendDir) then
    if not ClearDir(GetAFTempDir() + TempSendDir, True) then
      raise Exception.Create('Не получилось удалить временную директорию: ' + GetAFTempDir() + TempSendDir);

  if not CreateDir(GetAFTempDir() + TempSendDir) then
    raise Exception.Create('Не получилось создать временную директорию: ' + GetAFTempDir() + TempSendDir);

  slLetter := TStringList.Create;
  try

    //Формируем список файлов
    CopyingFiles;

    ArchiveAttach;

    EncodeToBase64;

    FormatSoapMessage;

    ss := TStringStream.Create(slLetter.Text);
    try
      ss.Position := 0;
      OldAccept := SendIdHTTP.Request.Accept;
      OldConnection := SendIdHTTP.Request.Connection;
      OldContentType := SendIdHTTP.Request.ContentType;
      SendIdHTTP.Request.Accept := '';
      SendIdHTTP.Request.Connection := '';
      SendIdHTTP.Request.ContentType := 'application/soap+xml; charset=windows-1251; action="IOS.Service/SendWaybillsEx"';

      S := SendIdHTTP.Post(SendURL, ss);
      start := PosEx( '>', S, Pos( 'SendWaybillsExResult', S)) + 1;
      stop := PosEx( '</', S, start);
      S := Copy( S, start, stop - start);
      if AnsiStartsText('Status=', S) then
      begin
        InternalSendResultStr := Copy(S, Length('Status=') + 1, Length(S));
        if Pos(';', InternalSendResultStr) > 0 then
          InternalSendResultStr := Copy(InternalSendResultStr, 1, Pos(';', InternalSendResultStr) - 1);

        InternalSendResult := TSendWaybillsStatus(StrToInt(InternalSendResultStr));

        FExchangeParams.SendWaybillsResult := InternalSendResult;

        if InternalSendResult in [swsOk, swsRetryLater] then
          DeleteSendedFiles;

      end
      else begin
        WriteExchangeLog('PostWaybillsControllerController', 'Некорректный ответ от сервера: ' + Utf8ToAnsi(S));
        raise Exception.Create(
          'При загрузке накладных возникла ошибка.'#13#10+
          'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.');
      end

    finally
      SendIdHTTP.Request.Accept := OldAccept;
      SendIdHTTP.Request.Connection := OldConnection;
      SendIdHTTP.Request.ContentType := OldContentType;
      ss.Free;
    end;

  finally
    slLetter.Free;
  end;

  ClearDir(GetAFTempDir() + TempSendDir, True);
end;

{ WaybillsHelper }

class function WaybillsHelper.CheckWaybillFolders(Connection : TCustomMyConnection) : Boolean;
var
  selectFirmCodes : TMyQuery;
  insertSettings : TMyQuery;
  folderName,
  waybillUploadingFolder : String;
  globalParams : TGlobalSettingParams;
begin
  Result := True;
  selectFirmCodes := TMyQuery.Create(nil);
  globalParams := TGlobalSettingParams.Create(Connection);
  try
    selectFirmCodes.Connection := Connection;
    selectFirmCodes.SQL.Text := ''
    + 'select '
    + ' Providers.FirmCode, '
    + ' Providers.FullName, '
    + ' Providers.ShortName '
    + 'from '
    + '  Providers '
    + '  left join ProviderSettings on ProviderSettings.FirmCode = Providers.FirmCode '
    + 'where '
    + '   (ProviderSettings.FirmCode is null) ';
    selectFirmCodes.Open;
    if selectFirmCodes.RecordCount > 0 then
    begin
      insertSettings := TMyQuery.Create(nil);
      try
        insertSettings.Connection := Connection;
        insertSettings.SQL.Text := ''
          + 'insert into ProviderSettings (FirmCode, WaybillFolder, WaybillUnloadingFolder)'
          + ' values (:FirmCode, :WaybillFolder, :WaybillUnloadingFolder);';
        while not selectFirmCodes.Eof do begin
          try
            folderName := GetFolderNameFromFullName(selectFirmCodes.FieldByName('ShortName').AsString);
            waybillUploadingFolder := folderName;

            if not DirectoryExists(RootFolder() + SDirUpload + '\' + folderName) then
              if not CreateDir(RootFolder() + SDirUpload + '\' + folderName) then begin
                Result := False;
                WriteExchangeLog('WaybillsHelper',
                  Format('Ошибка при создании папки %s для поставщика %s: %s',
                  [folderName,
                   selectFirmCodes.FieldByName('FullName').AsString,
                   SysErrorMessage(GetLastError())]));
                folderName := '';
              end;

            if folderName <> '' then
              folderName := '.\' + SDirUpload + '\' + folderName;

            if globalParams.GroupWaybillsBySupplier then begin
              if not DirectoryExists(RootFolder() + SDirWaybills + '\' + waybillUploadingFolder) then
                if not CreateDir(RootFolder() + SDirWaybills + '\' + waybillUploadingFolder) then begin
                  WriteExchangeLog('WaybillsHelper',
                    Format('Ошибка при создании папки %s для поставщика %s: %s',
                    [RootFolder() + SDirWaybills + '\' + waybillUploadingFolder,
                     selectFirmCodes.FieldByName('FullName').AsString,
                     SysErrorMessage(GetLastError())]));
                end;
            end;

            waybillUploadingFolder := '.\' + SDirWaybills + '\' + waybillUploadingFolder;

            insertSettings.ParamByName('FirmCode').Value := selectFirmCodes.FieldByName('FirmCode').Value;
            insertSettings.ParamByName('WaybillFolder').Value := folderName;
            insertSettings.ParamByName('WaybillUnloadingFolder').Value := waybillUploadingFolder;
            insertSettings.Execute;
          except
            on E : Exception do begin
              Result := False;
              WriteExchangeLog('WaybillsHelper',
                Format('Ошибка при сохранении информации о папке %s для поставщика %s: %s',
                [folderName,
                 selectFirmCodes.FieldByName('FullName').AsString,
                 E.Message]));
            end
          end;
          selectFirmCodes.Next;
        end;
      finally
        insertSettings.Free;
      end;
      DatabaseController.BackupDataTable(doiProviderSettings);
    end;
    selectFirmCodes.Close;
    if Result then begin
      selectFirmCodes.SQL.Text := ''
      + 'select '
      + ' Providers.FirmCode, '
      + ' Providers.FullName, '
      + ' ProviderSettings.WaybillFolder '
      + 'from '
      + '  Providers '
      + '  inner join ProviderSettings on ProviderSettings.FirmCode = Providers.FirmCode ';
      selectFirmCodes.Open;
      while not selectFirmCodes.Eof do begin
        if selectFirmCodes.FieldByName('WaybillFolder').AsString = '' then begin
          Result := False;
          Break;
        end
        else begin
          folderName := selectFirmCodes.FieldByName('WaybillFolder').AsString;
          folderName := GetFullFileNameByPrefix(folderName, RootFolder());
          if not DirectoryExists(folderName) then begin
            Result := False;
            Break;
          end;
        end;
        selectFirmCodes.Next;
      end;
      selectFirmCodes.Close;
    end;
  finally
    globalParams.Free;
    selectFirmCodes.Free;
  end;
end;

class function WaybillsHelper.GetFolderNameFromFullName(
  fullName: String): String;
const
  ValidChars = Digit + EnglishLetter + RussianLetter + ['(', ')', ' ', '-'];
var
  I : Integer;
begin
  fullName := StringReplace(fullName, 'ООО' ,'', [rfReplaceAll, rfIgnoreCase]);
  fullName := StringReplace(fullName, 'ЗАО' ,'', [rfReplaceAll, rfIgnoreCase]);
  Result := '';
  for I := 1 to Length(fullName) do
    if fullName[i] in ValidChars then
      Result := Result + fullName[i];
  Result := Trim(Result);
end;

end.
