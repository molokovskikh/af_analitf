unit RecThread;

interface

uses Classes, SysUtils, IdException, WinSock, IdComponent, IdHTTP, Math, SOAPThroughHTTP;

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

implementation

uses Exchange, DModule, AProc, VCLUnZip;

procedure TReclameThread.ClearProgress;
begin
  FStatusPosition := 0;
  FStatusStr := '';
  ExchangeForm.lReclameStatus.Caption := '';
  ExchangeForm.ReclameBar.Position := 0;
end;

procedure TReclameThread.Execute;
var
	FileStream: TFileStream;
	ReclameURL: string;
	RegionCode: string;
  Res       : TStrings;
//  TmpPos    : Integer;
//  FileSize  : Integer;
  NewReclame : Boolean;
  ZipFileName : String;
  UnZip       : TVCLUnZip;
begin
	RecTerminated := False;
  Synchronize(ClearProgress);
	RegionCode := DM.adtClients.FieldByName( 'RegionCode').AsString;

{
	ReclameURL := StringReplace( DM.adtReclame.FieldByName( 'ReclameURL').AsString, '#',
		RegionCode, [rfReplaceAll, rfIgnoreCase]);
	try
		if ExchangeForm.HTTPReclame.Host = '' then exit;
 		ExchangeForm.HTTPReclame.Head( ReclameURL);
		if ExchangeForm.HTTPReclame.Response.LastModified <=
			DM.adtReclame.FieldByName( 'UpdateDateTime').AsDateTime then
		begin
			Terminated := True;
			exit;
		end;
	except
	end;

	FileStream := TFileStream.Create( ExePath + SDirIn + '\r' + RegionCode + '.zip',
		fmCreate or fmOpenWrite);
	try
    ExchangeForm.HTTPReclame.OnWork := HTTPReclameWork;
    try
      ExchangeForm.HTTPReclame.Get( ReclameURL, FileStream);
    finally
      ExchangeForm.HTTPReclame.OnWork := nil;
    end;
		DM.adtReclame.Edit;
		DM.adtReclame.FieldByName( 'UpdateDateTime').AsDateTime := Now;
		DM.adtReclame.Post;
	except
	end;
	if FileStream.Size = 0 then
	begin
		FileStream.Free;
		DeleteFile( ExePath + SDirIn + '\r' + RegionCode + '.zip');
	end
	else
		FileStream.Free;
}



  try
{
   	ReclameURL := 'http://' + ExtractURL( DM.adtParams.FieldByName( 'HTTPHost').AsString) +
		'/' + DM.adtParams.FieldByName( 'ServiceName').AsString + '/code.asmx/GetReclame';
 		Res := ExchangeForm.HTTPReclame.Get(ReclameURL);
    TmpPos := Pos('URL=', Res);
    if TmpPos > 0 then begin
      Res := Copy(Res, TmpPos + 4, Length(Res));
      TmpPos := Pos(';Size=', Res);
      if TmpPos > 5  then begin
        ReclameURL := Copy(Res, 1, TmpPos-1);
        Res := Copy(Res, TmpPos + 6, Length(Res));
        FileSize := StrToIntDef(Res, 0);

        if FileSize > 0 then begin
          FileStream := TFileStream.Create( ExePath + SDirIn + '\r' + RegionCode + '.zip',
            fmCreate or fmOpenWrite);
          try

            ExchangeForm.HTTPReclame.OnWork := HTTPReclameWork;
            try
              ExchangeForm.HTTPReclame.Get( ReclameURL, FileStream);
            finally
              ExchangeForm.HTTPReclame.OnWork := nil;
            end;

            DM.adtReclame.Edit;
            DM.adtReclame.FieldByName( 'UpdateDateTime').AsDateTime := Now;
            DM.adtReclame.Post;
          except
          end;
          if FileStream.Size = 0 then
          begin
            FileStream.Free;
            DeleteFile( ExePath + SDirIn + '\r' + RegionCode + '.zip');
          end
          else
            FileStream.Free;
        end;

      end;
    end;
}

   	ReclameURL := 'https://' + ExtractURL( DM.adtParams.FieldByName( 'HTTPHost').AsString) +
		':80/' + DM.adtParams.FieldByName( 'ServiceName').AsString + '/code.asmx';
    FStatusStr := '������ ��������������� �����...';
    Synchronize(UpdateProgress);
    FSOAP := TSOAP.Create(ReclameURL, DM.adtParams.FieldByName( 'HTTPName').AsString,
		  DM.adtParams.FieldByName( 'HTTPPass').AsString, OnConnectError, ExchangeForm.HTTPReclame);
    try
      Log('Reclame', '������� ������� ��� ��������� ��������������� �����');
      Res := FSOAP.Invoke('GetReclame', [], []);
      //���� � ����� ���-�� ������, �� ��������� �������
      if Length(Res.Text) > 0 then begin
        Log('Reclame', '�������� ������ �� ����� � �������������� ������');
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

            if FileStream.Size > 1024 then
              FileStream.Seek( -1024, soFromEnd)
            else
              FileStream.Seek( 0, soFromEnd);
          end
          else
            FileStream := TFileStream.Create( ZipFileName, fmCreate);

          try

            if Terminated then Abort;
            ExchangeForm.HTTPReclame.Request.ContentRangeStart := FileStream.Position;
            ExchangeForm.HTTPReclame.OnWork := HTTPReclameWork;
            Log('Reclame', '�������� ������� ����� � �������������� ������...');
            try
              ExchangeForm.HTTPReclame.Get( ReclameURL, FileStream);
              Log('Reclame', '����� � �������������� ������ ������� ������');
            finally
              ExchangeForm.HTTPReclame.OnWork := nil;
            end;

          finally
            FileStream.Free;
          end;

          if Terminated then Abort;
          UnZip := TVCLUnZip.Create(nil);
          Log('Reclame', '�������� ����������� ����� � �������������� ������...');
          try
            UnZip.DoAll := True;
            UnZip.IncompleteZipMode := izAssumeBad;
            UnZip.OverwriteMode := Always;
            UnZip.RecreateDirs := True;
            UnZip.ReplaceReadOnly := True;
            UnZip.ZipName := ZipFileName;
            UnZip.DestDir := ExePath + SDirReclame;
            UnZip.UnZip;
            Log('Reclame', '����� � �������������� ������ ������� ����������');
          finally
            SysUtils.DeleteFile(ZipFileName);
            UnZip.Free;
          end;

          if Terminated then Abort;
          Log('Reclame', '�������� ����������� ����� � �������������� ������...');
          FSOAP.Invoke('ReclameComplete', [], []);
          Log('Reclame', '����� � �������������� ������ ������� �����������');

          Synchronize(UpdateReclameTable);
        end;

        FStatusStr := '�������� ��������������� ����� ���������';
        Synchronize(UpdateProgress);
      end
      else begin
        Log('Reclame', '�������������� ���� �� ��������');
        FStatusStr := '�������������� ���� �� ��������';
        Synchronize(UpdateProgress);
      end;

      Log('Reclame', '������� ���������� ��������������� ����� ��������');
    finally
      FSOAP.Free;
    end;

  except
    on E : Exception do
      Log('Reclame', '������� ���������� ��������������� ����� ���������� � ������� : ' + E.Message);
  end;
{
}
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

		TSuffix := '��';
		CSuffix := '��';

		Total := RoundTo(( HTTP.Response.ContentRangeStart +
			Cardinal( HTTP.Response.ContentLength)) / 1024, -2);
		Current := RoundTo((HTTP.Response.ContentRangeStart +
			Cardinal( AWorkCount)) / 1024, -2);

		if Total <> Current then
		begin
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

			if FStatusPosition > 0 then
      begin
//        ShowStatusText := True;
//        stStatus.Caption := '�������� ������   (' +
        FStatusStr := '�������� ������   (' +
				FloatToStrF( Current, ffFixed, 10, 2) + ' ' + CSuffix + ' / ' +
				FloatToStrF( Total, ffFixed, 10, 2) + ' ' + TSuffix + ')';
//        WriteLn(LogFile, DateTimeToStr(Now) + '  HTTPWork : ' + FStatusStr);
      end;
		end;
	end;

  Synchronize(UpdateProgress);
end;

procedure TReclameThread.Log(SybSystem, MessageText: String);
begin
  try
     WriteLn(ExchangeForm.LogFile, DateTimeToStr(Now) + '  ' + SybSystem + '  ' + MessageText);
  except
  end;
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
  DM.adtReclame.Edit;
  DM.adtReclame.FieldByName( 'UpdateDateTime').AsDateTime := Now;
  DM.adtReclame.Post;
end;

end.
