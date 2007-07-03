unit RecThread;

interface

uses Classes, SysUtils, IdException, WinSock, IdComponent, IdHTTP, Math, SOAPThroughHTTP,
  IdStackConsts, StrUtils, DADAuthenticationNTLM, U_RecvThread;

type
  TReclameThread = class(TReceiveThread)
    RecTerminated: boolean;
   private
    { Private declarations }
    FStatusPosition : Integer;
    FStatusStr : String;
    StartDownPosition : Integer;
    procedure ClearProgress;
    procedure UpdateProgress;
    procedure HTTPReclameWork(Sender: TObject;
      AWorkMode: TWorkMode;
	    const AWorkCount: Integer);
    procedure UpdateReclameTable;
   protected
    procedure Execute; override;
   public
  	RegionCode: string;
  end;

implementation

uses Exchange, DModule, AProc, SevenZip;

procedure TReclameThread.ClearProgress;
begin
  FStatusPosition := 0;
  FStatusStr := '';
  ExchangeForm.lReclameStatus.Caption := '';
  ExchangeForm.ReclameBar.Position := 0;
end;

procedure TReclameThread.Execute;
const
  FReconnectCount = 10;
var
	FileStream: TFileStream;
  Res       : TStrings;
  NewReclame : Boolean;
  ZipFileName : String;
  SevenZipRes : Integer;
  OldReconnectCount : Integer;
  ErrorCount : Integer;
  PostSuccess : Boolean;
  SleepCount : Integer;
begin
	RecTerminated := False;
  Synchronize(ClearProgress);
  try
    SleepCount := 0;
    while not Terminated and (SleepCount < 30) do begin
      Sleep(500);
      Inc(SleepCount);
    end;
    if Terminated then exit;
    FStatusStr := 'Запрос информационного блока...';
    Synchronize(UpdateProgress);
    FSOAP := TSOAP.Create(FURL, FHTTPName, FHTTPPass, OnConnectError, ReceiveHTTP);
    try
      Log('Reclame', 'Запущен процесс для получения информационного блока');
      Res := FSOAP.Invoke('GetReclame', [], []);
      //Если в ответ что-то пришло, то скачиваем рекламу
      if Length(Res.Text) > 0 then begin
        Log('Reclame', 'Получена ссылка на архив с информационным блоком');
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

            OldReconnectCount := ReceiveHTTP.ReconnectCount;
            ReceiveHTTP.ReconnectCount := 0;
            if FUseNTLM then begin
              ReceiveHTTP.Request.BasicAuthentication := False;
              ReceiveHTTP.Request.Authentication := TDADNTLMAuthentication.Create;
              if not AnsiStartsText('analit\', FHTTPName) then
                ReceiveHTTP.Request.Username := 'ANALIT\' + FHTTPName;
            end
            else
              ReceiveHTTP.Request.BasicAuthentication := True;
            ReceiveHTTP.OnWork := HTTPReclameWork;
            Log('Reclame', 'Пытаемся скачать архив с информационным блоком...');
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
                  Log('Reclame', 'Архив с информационным блоком успешно скачан');
                  PostSuccess := True;
                  
                except
                  on E : EIdConnClosedGracefully do begin
                    if (ErrorCount < FReconnectCount) then begin
                      if ReceiveHTTP.Connected then
                      try
                        ReceiveHTTP.Disconnect;
                      except
                      end;
                      Inc(ErrorCount);
                      Sleep(100);
                    end
                    else
                      raise;
                  end;
                  on E : EIdSocketError do begin
                    if (ErrorCount < FReconnectCount) and
                      ((e.LastError = Id_WSAECONNRESET) or (e.LastError = Id_WSAETIMEDOUT)
                        or (e.LastError = Id_WSAENETUNREACH) or (e.LastError = Id_WSAECONNREFUSED))
                    then begin
                      if ReceiveHTTP.Connected then
                      try
                        ReceiveHTTP.Disconnect;
                      except
                      end;
                      Inc(ErrorCount);
                      Sleep(100);
                    end
                    else
                      raise;
                  end;
                end;
              until (PostSuccess);

            finally
              ReceiveHTTP.ReconnectCount := OldReconnectCount;
              ReceiveHTTP.OnWork := nil;
              if FUseNTLM then begin
                ReceiveHTTP.Request.Username := FHTTPName;
                ReceiveHTTP.Request.BasicAuthentication := True;
                try
                  ReceiveHTTP.Request.Authentication.Free;
                except
                end;
                ReceiveHTTP.Request.Authentication := nil;
              end;
            end;

          finally
            try
              ReceiveHTTP.Disconnect;
            except
            end;
            
            FileStream.Free;
          end;

          if Terminated then Abort;
          Log('Reclame', 'Пытаемся распаковать архив с информационным блоком...');
          SZCS.Enter;
          try
            SevenZipRes := SevenZipExtractArchive(
              0,
              ExePath + SDirReclame + '\r' + RegionCode + '.zip',
              '*.*',
              True,
              '',
              True,
              ExePath + SDirReclame,
              False,
              nil);

            if SevenZipRes <> 0 then
              raise Exception.CreateFmt('Не удалось разархивировать файл %s. Код ошибки %d',
                [ExePath + SDirReclame + '\r' + RegionCode + '.zip',
                SevenZipRes]);
          finally
            SZCS.Leave;
            SysUtils.DeleteFile(ZipFileName);
          end;
          Log('Reclame', 'Архив с информационным блоком успешно распакован');

          if Terminated then Abort;
          Log('Reclame', 'Пытаемся подтвердить архив с информационным блоком...');
          FSOAP.Invoke('ReclameComplete', [], []);
          Log('Reclame', 'Архив с информационным блоком успешно подтвержден');

          Synchronize(UpdateReclameTable);
        end;

        FStatusStr := 'Загрузка информационного блока завершена';
        Synchronize(UpdateProgress);
      end
      else begin
        Log('Reclame', 'Информационный блок не обновлен');
        FStatusStr := 'Информационный блок не обновлен';
        Synchronize(UpdateProgress);
      end;

      Log('Reclame', 'Процесс обновления информационного блока завершен');
    finally
      FSOAP.Free;
    end;

  except
    on E : Exception do begin
      FStatusStr := 'Ошибка при получении информационного блока';
      Synchronize(UpdateProgress);
      Log('Reclame', 'Процесс обновления информационного блока завершился с ошибкой : ' + E.Message);
    end;
  end;
	RecTerminated := True;
end;

procedure TReclameThread.HTTPReclameWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
var
	Total, Current: real;
	TSuffix, CSuffix: string;
  HTTP : TIdHTTP;
  INFileSize : Integer;
  ProgressPosition : Integer;
begin
  if Terminated then Abort;

  HTTP := TIdHTTP(Sender);
	if HTTP.Response.RawHeaders.IndexOfName('INFileSize') > -1 then 
	begin
    INFileSize := StrToInt(HTTP.Response.RawHeaders.Values['INFileSize']);

		ProgressPosition := Round( ((StartDownPosition+AWorkCount)/INFileSize) *100);

		TSuffix := 'Кб';
		CSuffix := 'Кб';

		Total := RoundTo(INFileSize/ 1024, -2);
		Current := RoundTo((StartDownPosition +	AWorkCount) / 1024, -2);

    if Total > 1000 then
    begin
      Total := RoundTo( Total / 1024, -2);
      TSuffix := 'Мб';
    end;
    if Current > 1000 then
    begin
      Current := RoundTo( Current / 1024, -2);
      CSuffix := 'Мб';
    end;

    if (ProgressPosition > 0) and ((ProgressPosition - FStatusPosition > 5) or (ProgressPosition > 97)) then
    begin
      FStatusStr := 'Загрузка данных   (' +
        FloatToStrF( Current, ffFixed, 10, 2) + ' ' + CSuffix + ' / ' +
        FloatToStrF( Total, ffFixed, 10, 2) + ' ' + TSuffix + ')';
      FStatusPosition := ProgressPosition;
      Synchronize(UpdateProgress);
    end;
	end;

end;

procedure TReclameThread.UpdateProgress;
begin
  ExchangeForm.lReclameStatus.Caption := FStatusStr;
  ExchangeForm.ReclameBar.Position := FStatusPosition;
end;

procedure TReclameThread.UpdateReclameTable;
begin
  DM.SetReclame;
end;

initialization
finalization
end.
