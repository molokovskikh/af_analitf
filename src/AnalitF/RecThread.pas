unit RecThread;

interface

uses Classes, SysUtils, IdException, WinSock, IdComponent, IdHTTP, Math, SOAPThroughHTTP,
  IdStackConsts, StrUtils, DADAuthenticationNTLM, U_RecvThread, IdStack;

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
	    AWorkCount: Int64);
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
  ErrorCount : Integer;
  PostSuccess : Boolean;
  SleepCount : Integer;
begin
	RecTerminated := False;
  Synchronize(ClearProgress);
  try
    SleepCount := 0;
    while not Terminated and (SleepCount < 10) do begin
      Sleep(500);
      Inc(SleepCount);
    end;
    if Terminated then exit;
    FStatusStr := '������ ���������� �����...';
    Synchronize(UpdateProgress);
    FSOAP := TSOAP.Create(
      FURL,
      FHTTPName,
      FHTTPPass,
      OnConnectError,
      ReceiveHTTP);
    try
      Log('Reclame', '������� ������� ��� ��������� ���������� �����');
      Res := FSOAP.Invoke('GetReclame', [], []);
      //���� � ����� ���-�� ������, �� ��������� �������
      if Length(Res.Text) > 0 then begin
        Log('Reclame', '�������� ������ �� ����� � ��������� ������');
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
            ReceiveHTTP.OnWork := HTTPReclameWork;
            Log('Reclame', '�������� ������� ����� � ��������� ������...');
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
                  Log('Reclame', '����� � ��������� ������ ������� ������');
                  PostSuccess := True;
                  
                except
                  on E : EIdConnClosedGracefully do begin
                    if (ErrorCount < FReconnectCount) then begin
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
          Log('Reclame', '�������� ����������� ����� � ��������� ������...');
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
              raise Exception.CreateFmt('�� ������� ��������������� ���� %s. ��� ������ %d',
                [ExePath + SDirReclame + '\r' + RegionCode + '.zip',
                SevenZipRes]);
          finally
            SZCS.Leave;
            SysUtils.DeleteFile(ZipFileName);
          end;
          Log('Reclame', '����� � ��������� ������ ������� ����������');

          if Terminated then Abort;
          Log('Reclame', '�������� ����������� ����� � ��������� ������...');
          FSOAP.Invoke('ReclameComplete', [], []);
          Log('Reclame', '����� � ��������� ������ ������� �����������');

          Synchronize(UpdateReclameTable);
        end;

      end
      else
        Log('Reclame', '��������� ���� �� ��������');

      FStatusStr := '�������� ���������� ����� ���������';
      Synchronize(UpdateProgress);
      Log('Reclame', '������� ���������� ���������� ����� ��������');
    finally
      FSOAP.Free;
    end;

  except
    on E : Exception do begin
      FStatusStr := '�������� ���������� ����� ���������';
      Synchronize(UpdateProgress);
      Log('Reclame', '������� ���������� ���������� ����� ���������� � ������� : ' + E.Message);
    end;
  end;
	RecTerminated := True;
end;

procedure TReclameThread.HTTPReclameWork(Sender: TObject;
  AWorkMode: TWorkMode; AWorkCount: Int64);
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

		TSuffix := '��';
		CSuffix := '��';

		Total := RoundTo(INFileSize/ 1024, -2);
		Current := RoundTo((StartDownPosition +	AWorkCount) / 1024, -2);

    if Total > 1000 then
    begin
      Total := RoundTo( Total / 1024, -2);
      TSuffix := '��';
    end;
    if Current > 1000 then
    begin
      Current := RoundTo( Current / 1024, -2);
      CSuffix := '��';
    end;

    if (ProgressPosition > 0) and ((ProgressPosition - FStatusPosition > 5) or (ProgressPosition > 97)) then
    begin
      FStatusStr := '�������� ������   (' +
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
