unit RecThread;

interface

uses Classes, SysUtils, IdException, WinSock, IdComponent, IdHTTP, Math, SOAPThroughHTTP,
  IdStackConsts, StrUtils, SyncObjs;

type
  TReclameThread = class(TThread)
	 RecTerminated: boolean;
  private
    { Private declarations }
   FStatusPosition : Integer;
   FStatusStr : String;
   FSOAP : TSOAP;
   procedure ClearProgress;
   procedure UpdateProgress;
   procedure HTTPReclameWork(Sender: TObject;
    AWorkMode: TWorkMode;
	  const AWorkCount: Integer);
   procedure OnConnectError(AMessage : String);
   procedure UpdateReclameTable;
   procedure Log(SybSystem, MessageText : String);
   protected
    procedure Execute; override;
  end;

var
  SZCS : TCriticalSection;

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
	ReclameURL: string;
	RegionCode: string;
  Res       : TStrings;
//  TmpPos    : Integer;
//  FileSize  : Integer;
  NewReclame : Boolean;
  ZipFileName : String;
  SevenZipRes : Integer;
  OldReconnectCount : Integer;
  ErrorCount : Integer;
  PostSuccess : Boolean;
begin
	RecTerminated := False;
  Synchronize(ClearProgress);
	RegionCode := DM.adtClients.FieldByName( 'RegionCode').AsString;
  try
   	ReclameURL := 'https://' + ExtractURL( DM.adtParams.FieldByName( 'HTTPHost').AsString) +
		'/' + DM.adtParams.FieldByName( 'ServiceName').AsString + '/code.asmx';
    FStatusStr := 'Запрос информационного блока...';
    Synchronize(UpdateProgress);
    FSOAP := TSOAP.Create(ReclameURL, DM.adtParams.FieldByName( 'HTTPName').AsString,
		  DM.adtParams.FieldByName( 'HTTPPass').AsString, OnConnectError, ExchangeForm.HTTPReclame);
    try
      Log('Reclame', 'Запущен процесс для получения информационного блока');
      Res := FSOAP.Invoke('GetReclame', [], []);
      //Если в ответ что-то пришло, то скачиваем рекламу
      if Length(Res.Text) > 0 then begin
        Log('Reclame', 'Получена ссылка на архив с информационным блоком');
        ReclameURL := Res.Values['URL'];
        NewReclame := StrToBoolDef(UpperCase(Res.Values['New']), True);

        if Length(ReclameURL) > 0 then begin

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

            if Terminated then Abort;
            
            OldReconnectCount := ExchangeForm.HTTPReclame.ReconnectCount;
            ExchangeForm.HTTPReclame.ReconnectCount := 0;
            ExchangeForm.HTTPReclame.OnWork := HTTPReclameWork;
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

                  ExchangeForm.HTTPReclame.Get( ReclameURL +
                    IfThen(FileStream.Position > 0, '?RangeStart=' + IntToStr(FileStream.Position), ''),
                    FileStream);
                  Log('Reclame', 'Архив с информационным блоком успешно скачан');
                  PostSuccess := True;
                  
                except
                  on E : EIdConnClosedGracefully do begin
                    if (ErrorCount < FReconnectCount) then begin
                      if ExchangeForm.HTTPReclame.Connected then
                      try
                        ExchangeForm.HTTPReclame.Disconnect;
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
                      if ExchangeForm.HTTPReclame.Connected then
                      try
                        ExchangeForm.HTTPReclame.Disconnect;
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
              ExchangeForm.HTTPReclame.ReconnectCount := OldReconnectCount;
              ExchangeForm.HTTPReclame.OnWork := nil;
            end;

          finally
            FileStream.Free;
          end;

          if Terminated then Abort;
          Log('Reclame', 'Пытаемся распаковать архив с информационным блоком...');
          try
            SevenZipRes := 0;
{
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
}              

            if SevenZipRes <> 0 then
              raise Exception.CreateFmt('Не удалось разархивировать файл %s. Код ошибки %d',
                [ExePath + SDirReclame + '\r' + RegionCode + '.zip',
                SevenZipRes]);

            Log('Reclame', 'Архив с информационным блоком успешно распакован');
          finally
            SysUtils.DeleteFile(ZipFileName);
          end;

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
begin
  if Terminated then Abort;

  HTTP := TIdHTTP(Sender);
	if HTTP.Response.ContentLength = 0 then FStatusPosition := 0
	else
	begin
		FStatusPosition := Round(( HTTP.Response.ContentRangeStart+Cardinal(AWorkCount))/
			( HTTP.Response.ContentRangeStart+Cardinal(HTTP.Response.ContentLength))*100);

		TSuffix := 'Кб';
		CSuffix := 'Кб';

		Total := RoundTo(( HTTP.Response.ContentRangeStart +
			Cardinal( HTTP.Response.ContentLength)) / 1024, -2);
		Current := RoundTo((HTTP.Response.ContentRangeStart +
			Cardinal( AWorkCount)) / 1024, -2);

		if Total <> Current then
		begin
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

			if FStatusPosition > 0 then
      begin
//        ShowStatusText := True;
//        stStatus.Caption := 'Загрузка данных   (' +
        FStatusStr := 'Загрузка данных   (' +
				FloatToStrF( Current, ffFixed, 10, 2) + ' ' + CSuffix + ' / ' +
				FloatToStrF( Total, ffFixed, 10, 2) + ' ' + TSuffix + ')';
//        WriteLn(LogFile, DateTimeToStr(Now) + '  HTTPWork : ' + FStatusStr);
      end;
		end;
	end;

  Synchronize(UpdateProgress);
end;

procedure TReclameThread.Log(SybSystem, MessageText: String);
var
  Res : Boolean;
begin
  Res := False;
  repeat
    try
       WriteLn(ExchangeForm.LogFile, DateTimeToStr(Now) + '  ' + SybSystem + '  ' + MessageText);
       Res := True;
    except
      Sleep(700);
    end;
  until Res;
end;

procedure TReclameThread.OnConnectError(AMessage: String);
begin
  if Terminated then Abort;
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
  SZCS := TCriticalSection.Create;
finalization
  SZCS.Free;;
end.
