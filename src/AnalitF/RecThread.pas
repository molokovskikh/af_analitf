unit RecThread;

interface

uses Classes, SysUtils, IdException, WinSock, IdComponent, IdHTTP, Math, SOAPThroughHTTP,
  IdStackConsts, StrUtils, DADAuthenticationNTLM, U_RecvThread, IdStack;

type
  TReclameThread = class(TReceiveThread)
    RecTerminated: boolean;
   private
    { Private declarations }
    StartDownPosition : Integer;
   protected
    procedure Execute; override;
   public
    RegionCode: string;
  end;

implementation

uses Exchange, DModule, AProc, SevenZip;

procedure TReclameThread.Execute;
const
  FReconnectCount = 10;
var
  FileStream: TFileStream;
  Res       : TStrings;
  NewReclame : Boolean;
  ZipFileName : String;
  SevenZipRes : Integer;
  ErrorCount : Integer;
  PostSuccess : Boolean;
  SleepCount : Integer;
begin
  RecTerminated := False;
  try
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
      Log('Reclame', 'Запущен процесс для получения рекламного блока');
      Res := FSOAP.Invoke('GetReclame', [], []);
      //Если в ответ что-то пришло, то скачиваем рекламу
      if Length(Res.Text) > 0 then begin
        Log('Reclame', 'Получена ссылка на архив с рекламным блоком');
        FURL := Res.Values['URL'];
        NewReclame := StrToBoolDef(UpperCase(Res.Values['New']), True);

        if Length(FURL) > 0 then begin

          ZipFileName := ExePath + SDirReclame + '\r' + RegionCode + '.zip';

          if not NewReclame then
          begin
            if SysUtils.FileExists( ZipFileName) then
              FileStream := TFileStream.Create( ZipFileName, fmOpenReadWrite)
            else
              FileStream := TFileStream.Create( ZipFileName, fmCreate);
          end
          else
            FileStream := TFileStream.Create( ZipFileName, fmCreate);

          try
            if AnsiStartsText('https', FURL) then
              FURL := StringReplace(FURL, 'https', 'http', [rfIgnoreCase]);
            ReceiveHTTP.Disconnect;
          except
          end;

          try

            if Terminated then Abort;

            ReceiveHTTP.Request.BasicAuthentication := True;
            Log('Reclame', 'Пытаемся скачать архив с рекламным блоком...');
            try

              ErrorCount := 0;
              PostSuccess := False;
              repeat
                if Terminated then Abort;
                try

                  if FileStream.Size > 1024 then
                    FileStream.Seek( -1024, soFromEnd)
                  else
                    FileStream.Seek( 0, soFromEnd);

                  StartDownPosition := FileStream.Position;
                  ReceiveHTTP.Get( AddRangeStartToURL(FURL, FileStream.Position),
                    FileStream);
                  Log('Reclame', 'Архив с рекламным блоком успешно скачан');
                  PostSuccess := True;
                  
                except
                  on E : EIdCouldNotBindSocket do begin
                    if (ErrorCount < FReconnectCount) then begin
                      try
                        ReceiveHTTP.Disconnect;
                      except
                      end;
                      Inc(ErrorCount);
                      Sleep(1000);
                    end
                    else
                      raise;
                  end;
                  on E : EIdConnClosedGracefully do begin
                    if (ErrorCount < FReconnectCount) then begin
                      try
                        ReceiveHTTP.Disconnect;
                      except
                      end;
                      Inc(ErrorCount);
                      Sleep(500);
                    end
                    else
                      raise;
                  end;
                  on E : EIdSocketError do begin
                    if (ErrorCount < FReconnectCount) and
                      ((e.LastError = Id_WSAECONNRESET) or (e.LastError = Id_WSAETIMEDOUT)
                        or (e.LastError = Id_WSAENETUNREACH) or (e.LastError = Id_WSAECONNREFUSED))
                    then begin
                      try
                        ReceiveHTTP.Disconnect;
                      except
                      end;
                      Inc(ErrorCount);
                      Sleep(500);
                    end
                    else
                      raise;
                  end;
                end;
              until (PostSuccess);

            finally
              ReceiveHTTP.OnWork := nil;
            end;

          finally
            try
              ReceiveHTTP.Disconnect;
            except
            end;

            FileStream.Free;
          end;

          if Terminated then Abort;
          Log('Reclame', 'Пытаемся распаковать архив с рекламным блоком...');

          OSMoveFile(
            ExePath + SDirReclame + '\r' + RegionCode + '.zip',
            RootFolder() + SDirReclame + '\r' + RegionCode + '.zip');

          SZCS.Enter;
          try
            SevenZipRes := SevenZipExtractArchive(
              0,
              RootFolder() + SDirReclame + '\r' + RegionCode + '.zip',
              '*.*',
              True,
              '',
              True,
              RootFolder() + SDirReclame,
              False,
              nil);
          finally
            SZCS.Leave;
            SysUtils.DeleteFile(RootFolder() + SDirReclame + '\r' + RegionCode + '.zip');
          end;
          if SevenZipRes <> 0 then
            raise Exception.CreateFmt(
              'Не удалось разархивировать файл %s. ' +
              'Код ошибки %d. ' +
              'Код ошибки 7-zip: %d.'#13#10 +
              'Текст ошибки: %s',
              [RootFolder() + SDirReclame + '\r' + RegionCode + '.zip',
               SevenZipRes,
               SevenZip.LastSevenZipErrorCode,
               SevenZip.LastError]);

          Log('Reclame', 'Архив с рекламным блоком успешно распакован');

          if Terminated then Abort;
          Log('Reclame', 'Пытаемся подтвердить архив с рекламным блоком...');
          FSOAP.Invoke('ReclameComplete', [], []);
          Log('Reclame', 'Архив с рекламным блоком успешно подтвержден');
        end;

      end
      else
        Log('Reclame', 'Рекламный блок не обновлен');

      Log('Reclame', 'Процесс обновления рекламного блока завершен');
    finally
      FSOAP.Free;
    end;

  except
    on E : Exception do begin
      Log('Reclame', 'Процесс обновления рекламного блока завершился с ошибкой : ' + E.Message);
    end;
  end;
  RecTerminated := True;
end;

initialization
finalization
end.
