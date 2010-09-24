unit U_SendArchivedOrdersThread;

interface

uses
  Classes, SysUtils, Windows, StrUtils, DModule, IdHTTP, IdSSLOpenSSL, AProc,
  SOAPThroughHTTP, Contnrs, U_RecvThread;

type
  TSendArchivedOrdersThread = class(TReceiveThread)
   private
    procedure FillFileList(ASoapResult : String; AFileList : TStringList);
   protected
    procedure Execute; override;
    //Отправка файлов от клиента на сервер
    procedure SendFileFromClient;
  end;

implementation

uses
  Exchange, Main;
  
{ TSendArchivedOrdersThread }

procedure TSendArchivedOrdersThread.Execute;
var
  SleepCount : Integer;
begin
  try
    //Ждем некоторое время пока запустить процесс получения данных (15 сек)
    SleepCount := 0;
    while not Terminated and (SleepCount < 10) do begin
      Sleep(500);
      Inc(SleepCount);
    end;
    if Terminated then exit;

    FSOAP := TSOAP.Create(
      FURL,
      FHTTPName,
      FHTTPPass,
      OnConnectError,
      ReceiveHTTP);
    try

     if Terminated then exit;

     if eaGetPrice in ExchangeForm.ExchangeActs then
       SendFileFromClient();
       
    finally
      FSOAP.Free;
    end;

  except
    on E : Exception do begin
      Log('SendArchivedOrders', 'Ошибка : ' + E.Message);
    end;
  end;
end;

procedure TSendArchivedOrdersThread.FillFileList(ASoapResult: String;
  AFileList: TStringList);
var
  FileName : String;
  DeletedMark : String;
begin
  while (Length(ASoapResult) > 0) do begin
    FileName := GetNextWord(ASoapResult, '|');
    DeletedMark := GetNextWord(ASoapResult, '|');
    //Если есть что-то
    if (Length(FileName) > 0) and ((DeletedMark = '0') or (DeletedMark = '1'))
    then begin
      //Формируем абсолютное имя файла
      FileName := ExtractFilePath(ParamStr(0)) + FileName;
      if FileExists(FileName) then
        AFileList.AddObject(FileName, TObject(StrToInt(DeletedMark)));
    end;
  end;
end;

procedure TSendArchivedOrdersThread.SendFileFromClient;
var
  LibVersions: TObjectList;
  ParamNames, ParamValues : array of String;
  fi : TFileUpdateInfo;
  SoapResult : String;
  FileList : TStringList;
  I : Integer;
begin
  LibVersions := AProc.GetLibraryVersionFromAppPath;
  try
    SetLength(ParamNames, LibVersions.Count*3);
    SetLength(ParamValues, LibVersions.Count*3);
    for I := 0 to LibVersions.Count-1 do begin
      fi := TFileUpdateInfo(LibVersions[i]);
      ParamNames[i*3] := 'LibraryName';
      ParamValues[i*3] := fi.FileName;
      ParamNames[i*3+1] := 'LibraryVersion';
      ParamValues[i*3+1] := fi.Version;
      ParamNames[i*3+2] := 'LibraryHash';
      ParamValues[i*3+2] := fi.MD5;
    end;
  finally
    LibVersions.Free;
  end;

  if Terminated then exit;

  SoapResult := FSOAP.SimpleInvoke('GetInfo', ParamNames, ParamValues);

  if Terminated then exit;

  if (Length(SoapResult) > 0) and not Terminated then begin
    FileList := TStringList.Create;
    try
      FillFileList(SoapResult, FileList);

      if Terminated then exit;

      AProc.InternalDoSendLetter(ReceiveHTTP, FURL, 'AFRec', FileList, 'Файлы от клиента', 'Смотри вложение');

      for I := 0 to FileList.Count-1 do
        if Integer(FileList.Objects[i]) = 1 then
          OSDeleteFile(FileList[i], False);
    finally
      FileList.Free;
    end;
  end;
end;

end.
