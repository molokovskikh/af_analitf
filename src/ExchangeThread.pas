unit ExchangeThread;

interface

uses
	Classes, SysUtils, Windows, StrUtils, ComObj, Variants, XSBuiltIns, 
	SOAPThroughHTTP, DateUtils, ShellAPI, ExtCtrls, RecThread, ActiveX,
  IdException, WinSock, RxVerInf;

type

TUpdateTable = (
	utCatalog,
	utCatDel,
	utCatalogCurrency,
	utClients,
	utClientsDataN,
	utPricesData,
	utRegionalData,
	utPricesRegionalData,
	utCore,
	utRegions,
	utSection,
	utSynonym,
	utSynonymFirmCr,
	utRejects,
	utRegistry,
  utWayBillHead,
  utWayBillList);

TUpdateTables = set of TUpdateTable;

TExchangeThread = class( TThread)
 public
	Terminated, CriticalError: boolean;
	ErrorMessage: string;
  DownloadReclame : Boolean;
  procedure StopReclame;
private
	StatusText: string;
	Progress: integer;
	TotalProgress: integer;
	SOAP: TSOAP;
	ExchangeDateTime: TDateTime;
	NewZip: boolean;
	FileStream: TFileStream;
	RecThread: TReclameThread;

	procedure SetStatus;
	procedure SetProgress;
	procedure SetTotalProgress;
	procedure DisableCancel;
	procedure EnableCancel;
	procedure ShowEx;

	procedure RasConnect;
	procedure HTTPConnect;
	procedure GetReclame;
	procedure QueryData;
	procedure CommitExchange;
	procedure DoExchange;
	procedure DoSendOrders;
	procedure HTTPDisconnect;
	procedure RasDisconnect;
	procedure UnpackFiles;
	procedure ImportData;
	procedure CheckNewExe;
	procedure CheckNewMDB;
	procedure CheckNewFRF;

	procedure ImportFromExternalMDB;
	function GetXMLDateTime( ADateTime: TDateTime): string;
	function FromXMLToDateTime( AStr: string): TDateTime;
	function StringToCodes( AStr: string): string;
	function RusError( AStr: string): string;
  procedure OnConnectError (AMessage : String);
  procedure OnReclameTerminate(Sender: TObject);
  function  GetLibraryVersion : TStrings;
protected
	procedure Execute; override;
end;

implementation

uses Exchange, DModule, AProc, Main, Retry, Integr, Exclusive, ExternalOrders,
  DB;

{ TExchangeThread }

procedure TExchangeThread.SetStatus;
begin
	ExchangeForm.StatusText := StatusText;
end;

procedure TExchangeThread.SetProgress;
begin
	ExchangeForm.ProgressBar.Position := Progress;
end;

procedure TExchangeThread.SetTotalProgress;
begin
	ExchangeForm.TotalProgress.Position := TotalProgress;
end;

procedure TExchangeThread.DisableCancel;
begin
	ExchangeForm.btnCancel.Enabled := False;
end;

procedure TExchangeThread.EnableCancel;
begin
	ExchangeForm.btnCancel.Enabled := True;
end;

procedure TExchangeThread.ShowEx;
begin
	ShowExclusive( False, Self);
end;

procedure TExchangeThread.Execute;
var
	LastStatus: string;
begin
	Terminated := False;
	CriticalError := False;
	TotalProgress := 0;
	Synchronize( SetTotalProgress);
	try
		ErrorMessage := '';
		try
			if ( eaGetPrice in ExchangeForm.ExchangeActs) or
				( eaSendOrders in ExchangeForm.ExchangeActs) then
			begin
				RasConnect;
				HTTPConnect;
				TotalProgress := 10;
				Synchronize( SetTotalProgress);
				if eaSendOrders in ExchangeForm.ExchangeActs then
				begin
					CriticalError := True;
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
					DoSendOrders;
					CriticalError := False;
				end;
				TotalProgress := 20;
				Synchronize( SetTotalProgress);
				if eaGetPrice in ExchangeForm.ExchangeActs then
				begin
					GetReclame;
//					ExchangeForm.HTTP.ReadTimeout := 1000000; // 1000 секунд на запрос
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
					QueryData;
          if eaGetFullData in ExchangeForm.ExchangeActs then
            DM.SetCumulative;
//					ExchangeForm.HTTP.ReadTimeout := 60000; // 60 секунд на получение
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
					DoExchange;
				end;
				TotalProgress := 40;
				Synchronize( SetTotalProgress);
			end;

			{ Распаковка файлов }
			if ( eaGetPrice in ExchangeForm.ExchangeActs) or
				( eaImportOnly in ExchangeForm.ExchangeActs) then UnpackFiles;

			{ Поддтверждение обмена }
			if eaGetPrice in ExchangeForm.ExchangeActs then CommitExchange;

			{ Отключение }
			if eaGetPrice in ExchangeForm.ExchangeActs then
				if not RecThread.RecTerminated then
          RecThread.OnTerminate := OnReclameTerminate
        else
          OnReclameTerminate(nil);

			if ( eaGetPrice in ExchangeForm.ExchangeActs) or
				( eaImportOnly in ExchangeForm.ExchangeActs) then
			begin
				TotalProgress := 50;
				Synchronize( SetTotalProgress);
				CriticalError := True;
				if DM.DatabaseOpenedBy <> '' then Synchronize( ShowEx)
					else
					begin
						MainForm.Timer.Enabled := False;
						DM.SetExclusive;
					end;
				CheckNewExe;
				CheckNewFRF;
				CheckNewMDB;
				ImportData;
				DM.ResetExclusive;
				MainForm.Timer.Enabled := True;
      	StatusText := 'Обоновление завершено';
     	  Synchronize( SetStatus);
			end;

			{ Дожидаемся завершения работы потока, скачивающего рекламу }
			if eaGetPrice in ExchangeForm.ExchangeActs then
			begin
        DownloadReclame := True;
				if not RecThread.RecTerminated then RecThread.WaitFor;
				RecThread.Free;
			end;
      TotalProgress := 100;
      Synchronize( SetTotalProgress);

		except //в случае ошибки показываем сообщение
			on E: Exception do
			begin
				LastStatus := StatusText;
				Progress := 0;
				Synchronize( SetProgress);
				TotalProgress := 0;
				Synchronize( SetTotalProgress);
				try
					HTTPDisconnect;
          StopReclame;
					RecThread.Free;
				except
				end;
				RasDisconnect;
				StatusText := '';
				Synchronize( SetStatus);
				//обрабатываем Отмену
				//if ExchangeForm.DoStop then Abort;
				//обрабатываем ошибку
				Writeln( ExchangeForm.LogFile, LastStatus + ':' + CRLF + E.Message); //пишем в лог
				if ErrorMessage = '' then
          ErrorMessage := RusError( E.Message);
			end;
		end;
	except
		on E: Exception do ErrorMessage := E.Message;
	end;
	Synchronize( EnableCancel);
	Terminated := True;
end;

procedure TExchangeThread.HTTPConnect;
var
	URL: string;
  TmpStr : String;
begin
	{ создаем экземпляр класса TSOAP для работы с SOAP через HTTP вручную }
	URL := 'http://' + ExtractURL( DM.adtParams.FieldByName( 'HTTPHost').AsString) +
		'/' + DM.adtParams.FieldByName( 'ServiceName').AsString + '/code.asmx';
	SOAP := TSOAP.Create( URL, DM.adtParams.FieldByName( 'HTTPName').AsString,
		DM.adtParams.FieldByName( 'HTTPPass').AsString, OnConnectError, ExchangeForm.HTTP);
  try
    TmpStr := ExchangeForm.HTTP.Get('http://' + ExtractURL( DM.adtParams.FieldByName( 'HTTPHost').AsString));
    WriteLn(ExchangeForm.LogFile, DateTimeToStr(Now) + ' Test connect Success');
  except
    on E : Exception do
      WriteLn(ExchangeForm.LogFile, DateTimeToStr(Now) + ' Test connect Error=' + E.Message);
  end;
end;

procedure TExchangeThread.GetReclame;
begin
	RecThread := TReclameThread.Create( True);
	RecThread.Resume;
end;

procedure TExchangeThread.QueryData;
var
	Res: TStrings;
  Error : String;
  ParamNames, ParamValues : array of String;
  I : Integer;
begin
	{ запрашиваем данные }
	StatusText := 'Запрос данных';
	Synchronize( SetStatus);
	try
    Res := GetLibraryVersion;
    try
      SetLength(ParamNames, 5 + Res.Count);
      SetLength(ParamValues, 5 + Res.Count);
      ParamNames[0]  := 'AccessTime';
      ParamValues[0] := GetXMLDateTime( DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime);
      ParamNames[1]  := 'GetEtalonData';
      ParamValues[1] := BoolToStr( eaGetFullData in ExchangeForm.ExchangeActs, True);
      ParamNames[2]  := 'ExeVersion';
      ParamValues[2] := MainForm.VerInfo.FileVersion;
      ParamNames[3]  := 'MDBVersion';
      ParamValues[3] := DM.adtProvider.FieldByName( 'MDBVersion').AsString;
      ParamNames[4]  := 'UniqueID';
      ParamValues[4] := IntToHex( GetCopyID, 8);
      for I := 0 to Res.Count-1 do begin
        ParamNames[5+i] := Res.Names[i];
        ParamValues[5+i] := Res.Values[ParamNames[5+i]];
      end;
    finally
      Res.Free;
    end;
{
		Res := SOAP.Invoke( 'GetUserData', [ 'AccessTime', 'GetEtalonData', 'ExeVersion', 'MDBVersion', 'UniqueID'],
			[GetXMLDateTime( DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime),
			BoolToStr( eaGetFullData in ExchangeForm.ExchangeActs, True),
			MainForm.VerInfo.FileVersion, DM.adtProvider.FieldByName( 'MDBVersion').AsString,
			IntToHex( GetCopyID, 8)]);
}      
		Res := SOAP.Invoke( 'GetUserData', ParamNames, ParamValues);
		{ QueryResults.DelimitedText не работает из-за пробела, который почему-то считается разделителем }
//		while Res <> '' do ExchangeForm.QueryResults.Add( GetNextWord( Res, ';'));
		{ проверяем отсутствие ошибки при удаленном запросе }
		Error := Utf8ToAnsi( Res.Values[ 'Error']);
		if Error <> '' then
			raise Exception.Create( Utf8ToAnsi( Res.Values[ 'Error'])
				+ #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));
		ServerAddition := Utf8ToAnsi( Res.Values[ 'Addition']);
		{ получаем имя удаленного файла }
		HostFileName := Res.Values[ 'URL'];
		NewZip := True;
		if Res.Values[ 'New'] <> '' then
			NewZip := StrToBool( UpperCase( Res.Values[ 'New']));
		if HostFileName = '' then
			raise Exception.Create( 'При выполнении вашего запроса произошла ошибка.' +
				#10#13 + 'Повторите запрос через несколько минут.');
		LocalFileName := ExePath + SDirIn + '\' + ExtractFileName( AnsiReplaceStr( HostFileName, '/', '\'));
	except
		on E: Exception do
		begin
			CriticalError := True;
			raise;
		end;
	end;
	{ очищаем папку In }
	DeleteFilesByMask( ExePath + SDirIn + '\*.txt');
	Synchronize( ExchangeForm.CheckStop);
end;

procedure TExchangeThread.DoExchange;
begin
	//загрузка прайс-листа
	if eaGetPrice in ExchangeForm.ExchangeActs then
	begin
		StatusText := 'Загрузка данных';
		Synchronize( SetStatus);
		if not NewZip then
		begin
			if SysUtils.FileExists( LocalFileName) then
				FileStream := TFileStream.Create( LocalFileName, fmOpenReadWrite)
			else
				FileStream := TFileStream.Create( LocalFileName, fmCreate);
			if FileStream.Size > 1024 then FileStream.Seek( -1024, soFromEnd)
				else FileStream.Seek( 0, soFromEnd);
		end
		else
			FileStream := TFileStream.Create( LocalFileName, fmCreate);

		try
			ExchangeForm.HTTP.Request.ContentRangeStart := FileStream.Position;
      try
        ExchangeForm.ShowStatusText := True;
//            ExchangeForm.HTTP.Get( 'http://' + ExtractURL( DM.adtParams.FieldByName( 'HTTPHost').AsString), FileStream);
        ExchangeForm.HTTP.Get( HostFileName, FileStream);
        Writeln(ExchangeForm.LogFile, 'Recieve file : ' + IntToStr(FileStream.Size));
      finally
        ExchangeForm.ShowStatusText := False;
      end;
			Synchronize( ExchangeForm.CheckStop);
//			ExchangeForm.QueryResults.Clear;
		finally
			FileStream.Free;
		end;
		Windows.CopyFile( PChar( LocalFileName),
			PChar( ChangeFileExt( LocalFileName, '.zi_')), False);
//		Sleep( 10000);
	end;
end;

procedure TExchangeThread.CommitExchange;
var
	Res: TStrings;
  FS : TFileStream;
  LogStr : String;
  Len : Integer;
begin
  try
    Flush(ExchangeForm.LogFile);
    FS := TFileStream.Create(ExePath + 'Exchange.log', fmOpenRead or fmShareDenyNone);
    try
      Len := Integer(FS.Size);
      SetLength(LogStr, Len);
      FS.Read(Pointer(LogStr)^, Len);
      LogStr := StringReplace(LogStr, #13#10, 'CRLN', [rfReplaceAll]);
    finally
      FS.Free;
    end;
  except
    LogStr := '';
  end;

//  Res := SOAP.Invoke( 'MaxSynonymCode', ['Log'], [LogStr]);
	Res := SOAP.Invoke( 'MaxSynonymCodeV2', ['Log'], [LogStr]);

	ExchangeDateTime := FromXMLToDateTime( Res.Text);
	DM.adtParams.Edit;
	DM.adtParams.FieldByName( 'LastDateTime').AsDateTime := ExchangeDateTime;
  if DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean then begin
    DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean := False;
    MainForm.EnableByHTTPName;
  end;
	DM.adtParams.Post;
end;

procedure TExchangeThread.DoSendOrders;
var
	params, values: array of string;
	i: integer;
	Res: TStrings;
  ResError : String;
	ServerOrderId: integer;
	OldDS: Char;
  ExternalRes : Boolean;
  ErrorStr : PChar;
  ExtErrorMessage : String;
begin
 	DM.adsOrdersH.Close;
	DM.adsOrdersH.Parameters.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').Value;
	DM.adsOrdersH.Parameters.ParamByName( 'AClosed').Value := False;
	DM.adsOrdersH.Parameters.ParamByName( 'ASend').Value := True;
	DM.adsOrdersH.Parameters.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	DM.adsOrdersH.Open;
	if not DM.adsOrdersH.Eof then
	begin
		StatusText := 'Отправка заказов';
		Synchronize( SetStatus);
	end;
	while not DM.adsOrdersH.Eof do
	begin
                DM.adsOrders.Close;
		DM.adsOrders.Parameters.ParamByName( 'AOrderId').Value :=
			DM.adsOrdersH.FieldByName( 'OrderId').Value;
                DM.adsOrders.Open;

    WriteLn(ExchangeForm.LogFile,
      'Отправка заказа #' + DM.adsOrdersH.FieldByName( 'OrderId').AsString +
      '  по прайсу ' + DM.adsOrdersH.FieldByName( 'PriceCode').AsString);
		SetLength( params, 6 + DM.adsOrders.RecordCount * 11);
		SetLength( values, 6 + DM.adsOrders.RecordCount * 11);

		params[ 0] := 'ClientCode';
		params[ 1] := 'PriceCode';
		params[ 2] := 'RegionCode';
		params[ 3] := 'PriceDate';
		params[ 4] := 'ClientAddition';
		params[ 5] := 'RowCount';
		values[ 0] := DM.adtClients.FieldByName( 'ClientId').AsString;
		values[ 1] := DM.adsOrdersH.FieldByName( 'PriceCode').AsString;
		values[ 2] := DM.adsOrdersH.FieldByName( 'RegionCode').AsString;
		values[ 3] := GetXMLDateTime( DM.adsOrdersH.FieldByName( 'DatePrice').AsDateTime);
		values[ 4] := StringToCodes( DM.adsOrdersH.FieldByName( 'Message').AsString);
		values[ 5] := IntToStr( DM.adsOrders.RecordCount);

		for i := 0 to DM.adsOrders.RecordCount - 1 do
		begin
			params[ i * 11 + 6] := 'FullCode';
			params[ i * 11 + 7] := 'OrderId';
			params[ i * 11 + 8] := 'CodeFirmCr';
			params[ i * 11 + 9] := 'SynonymCode';
			params[ i * 11 + 10] := 'SynonymFirmCrCode';
			params[ i * 11 + 11] := 'Code';
			params[ i * 11 + 12] := 'CodeCr';
			params[ i * 11 + 13] := 'Quantity';
			params[ i * 11 + 14] := 'Junk';
			params[ i * 11 + 15] := 'Await';
			params[ i * 11 + 16] := 'Cost';
			values[ i * 11 + 6] := DM.adsOrders.FieldByName( 'FullCode').AsString;
			values[ i * 11 + 7] := DM.adsOrders.FieldByName( 'OrderId').AsString;
			values[ i * 11 + 8] := DM.adsOrders.FieldByName( 'CodeFirmCr').AsString;
			values[ i * 11 + 9] := DM.adsOrders.FieldByName( 'SynonymCode').AsString;
			values[ i * 11 + 10] := DM.adsOrders.FieldByName( 'SynonymFirmCrCode').AsString;
			values[ i * 11 + 11] := DM.adsOrders.FieldByName( 'Code').AsString;
			values[ i * 11 + 12] := DM.adsOrders.FieldByName( 'CodeCr').AsString;
			values[ i * 11 + 13] := DM.adsOrders.FieldByName( 'Order').AsString;
			values[ i * 11 + 14] := BoolToStr( DM.adsOrders.FieldByName( 'Junk').AsBoolean, True);
			values[ i * 11 + 15] := BoolToStr( DM.adsOrders.FieldByName( 'Await').AsBoolean, True);
                        OldDS := DecimalSeparator;
			DecimalSeparator := ',';
			values[ i * 11 + 16] := DM.adsOrders.FieldByName( 'Price').AsString;
                        DecimalSeparator := OldDS;
			DM.adsOrders.Edit;
			DM.adsOrders.FieldByName( 'CoreId').AsVariant := Null;
                        DM.adsOrders.Post;
			DM.adsOrders.Next;
		end;

    if IsExternalOrdersDLLPresent then
      if ExternalOrdersPriceIsProtek(DM.MainConnection, DM.adsOrdersH.FieldByName( 'OrderId').AsInteger)
      then begin
        Inc(ExchangeForm.ExternalOrdersCount);
        try
          ExternalRes := ExternalOrdersThreading(
            ExchangeForm.AppHandle,
            DM.MainConnection,
            DM.adsOrdersH.FieldByName( 'OrderId').AsInteger,
            nil,
            nil,
            nil,
            ErrorStr);

          if not ExternalRes then begin
            SetLength(ExtErrorMessage, StrLen(ErrorStr));
            StrCopy(PChar(ExtErrorMessage), ErrorStr);
            CoTaskMemFree(ErrorStr);
            ExchangeForm.ExternalOrdersLog.Add(
              'Ошибка во время формирования заказа №' +
              DM.adsOrdersH.FieldByName( 'OrderId').AsString +
              ' для "Протек" : ' + ExtErrorMessage)
          end;
        except
          on E : Exception do begin
            ExchangeForm.ExternalOrdersLog.Add(
              'Ошибка во время формирования заказа №' +
              DM.adsOrdersH.FieldByName( 'OrderId').AsString +
              ' для "Протек" : ' + E.Message)
          end;
        end;
      end;

		try
			Res := Soap.Invoke( 'PostOrder1', params, values);
//			ExchangeForm.QueryResults.Clear;
			// QueryResults.DelimitedText не работает из-за пробела, который почему-то считается разделителем
//			while Res <> '' do ExchangeForm.QueryResults.Add( GetNextWord( Res, ';'));
			// проверяем отсутствие ошибки при удаленном запросе
			ResError := Utf8ToAnsi( Res.Values[ 'Error']);
			if ResError <> '' then
				raise Exception.Create( ResError + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));
			try
				ServerOrderId := StrToInt( Res.Values[ 'OrderId']);
			except
				ServerOrderId := 0;
			end;
		except
			DM.adsOrdersH.Close;
			DM.adsOrders.Close;
			Synchronize( MainForm.SetOrdersInfo);
			raise;
		end;

		try
			DM.adsOrders.Close;
			DM.adsOrdersH.Edit;
			{ Заказ был отправлен, а не переведен }
			DM.adsOrdersH.FieldByName( 'Send').AsBoolean := True;
			DM.adsOrdersH.FieldByName( 'SendDate').AsDateTime := Now;
			{ Закрываем заказ }
			DM.adsOrdersH.FieldByName( 'Closed').AsBoolean := True;
			DM.adsOrdersH.FieldByName( 'ServerOrderId').AsInteger := ServerOrderId;
			DM.adsOrdersH.Post;
			DM.adsOrdersH.Next;
		except
			DM.adsOrdersH.Close;
			DM.adsOrders.Close;
			Synchronize( MainForm.SetOrdersInfo);
			raise;
		end;
	end;
	Synchronize( MainForm.SetOrdersInfo);
//	ExchangeForm.QueryResults.Clear;
	DM.adsOrdersH.Close;
	DM.adsOrders.Close;
end;

procedure TExchangeThread.RasConnect;
var
  RasTimeout : Integer;
begin
	if DM.adtParams.FieldByName( 'RasConnect').AsBoolean then begin
			Synchronize( ExchangeForm.Ras.Connect);
      RasTimeout := DM.adtParams.FieldByName( 'RasSleep').AsInteger;
      if RasTimeout > 0 then begin
        Writeln(ExchangeForm.LogFile, DateTimeToStr(Now) + '  Sleep = ' + IntToStr(RasTimeout));
        Sleep(RasTimeout * 1000);
      end;
  end;
	Synchronize( ExchangeForm.CheckStop);
end;

procedure TExchangeThread.HTTPDisconnect;
begin
	try
		FreeAndNil( SOAP);
	except
	end;
	ExchangeForm.HTTP.Disconnect;
end;

procedure TExchangeThread.RasDisconnect;
begin
	Synchronize( ExchangeForm.Ras.Disconnect);
end;

procedure TExchangeThread.UnpackFiles;
var
	SR, ExportsSR: TSearchRec;
begin
	if FindFirst( ExePath + SDirIn + '\*.zip', faAnyFile, SR) = 0 then
	try
		StatusText := 'Распаковка данных';
		Synchronize( SetStatus);
		repeat
			ExchangeForm.UnZip.ZipName := ExePath + SDirIn + '\' + SR.Name;
			{ Если это архив с рекламой }
			if ( SR.Name[ 1] = 'r') and ( SR.Size > 0) then
			begin
				ExchangeForm.UnZip.DestDir := ExePath + SDirReclame;
				ExchangeForm.UnZip.UnZip;
				DeleteFileA( ExchangeForm.UnZip.ZipName);
			end
                	{ Если это данные }
			else
			begin
				ExchangeForm.UnZip.DestDir := ExePath + SDirIn;
				ExchangeForm.UnZip.UnZip;
				DeleteFileA( ExchangeForm.UnZip.ZipName);
				DeleteFileA( ExePath + SDirIn + '\' + ChangeFileExt( SR.Name, '.zi_'));
			end;
			Synchronize( ExchangeForm.CheckStop);
		until FindNext( SR) <> 0;
	finally
		SysUtils.FindClose( SR);
		ExchangeForm.UnZip.ZipName := '';
	end;

  //Обрабатываем папку Exports
  if DirectoryExists(ExePath + SDirIn + '\' + SDirExports) then begin
    if FindFirst( ExePath + SDirIn + '\' + SDirExports + '\*.*', faAnyFile, ExportsSR) = 0 then
    try
      repeat
        if (ExportsSR.Name <> '.') and (ExportsSR.Name <> '..') then
          MoveFileEx(
            PChar(ExePath + SDirIn + '\' + SDirExports + '\' + ExportsSR.Name),
            PChar(ExePath + SDirExports + '\' + ExportsSR.Name),
            MOVEFILE_REPLACE_EXISTING);
      until (FindNext( ExportsSR ) <> 0)
    finally
      SysUtils.FindClose( ExportsSR );
    end;
    RemoveDir(ExePath + SDirIn + '\' + SDirExports);
  end;
end;

procedure TExchangeThread.CheckNewExe;
var
	EraserDll: TResourceStream;
begin
	if not SysUtils.DirectoryExists( ExePath + SDirIn + '\' + SDirExe) then exit;

	Windows.MessageBox( 0, 'Получена новая версия программы. Сейчас будет выполнено обновление',
		'Внимание', MB_OK or MB_ICONWARNING);
	EraserDll := TResourceStream.Create( hInstance, 'ERASER', RT_RCDATA);
	try
		EraserDll.SaveToFile( 'Eraser.dll');
	finally
		EraserDll.Free;
	end;

	ShellExecute( 0, nil, 'rundll32.exe', PChar( ' Eraser.dll,Erase -i ' + IntToStr(GetCurrentProcessId) + ' "' +
		ExePath + ExeName + '" "' + ExePath + SDirIn + '\' + SDirExe + '"'),
		nil, SW_SHOWNORMAL);
	raise Exception.Create( 'Terminate');
end;

procedure TExchangeThread.CheckNewMDB;
var
	tl: TStringList;
begin
	if eaGetFullData in ExchangeForm.ExchangeActs then
	begin
		StatusText := 'Очистка таблиц';
		Synchronize( SetStatus);
		DM.ClearDatabase;
		StatusText := 'Сжатие базы';
		Synchronize( SetStatus);
		DM.CompactDatabase;
	end;

	if not SysUtils.FileExists( ExePath + SDirIn + '\' + DatabaseName) then exit;

	if DM.IsBackuped( ExePath + SDirIn + '\') then
		DM.RestoreDatabase( ExePath + SDirIn + '\');
	StatusText := 'Резервное копирование данных';
	Synchronize( SetStatus);
	DM.BackupDatabase( ExePath + SDirIn + '\');

	Windows.MessageBox( 0, 'Сейчас будет выполнено обновление базы данных' + #10#13 +
		'Это достаточно длительный процесс. Пожалуйста дождитесь его окончания.' + #10#13 +
		'Не закрывайте программу и не выключайте компьютер.',
		'Внимание', MB_OK or MB_ICONWARNING);

	StatusText := 'Перенос данных';
	Synchronize( SetStatus);
	Synchronize( DisableCancel);
	DM.adtClients.DisableControls;
	tl := TStringList.Create;
	try
		DM.MainConnection.GetTableNames( tl);
		DM.ClearPassword( ExePath + DatabaseName);
		DM.OpenDatabase( ExePath + SDirIn + '\' + DatabaseName);
		DM.UnLinkExternalTables;
		DM.LinkExternalMDB( tl);
		ImportFromExternalMDB;
		DM.UnLinkExternalTables;
		DM.MainConnection.Close;
//		DM.RestoreDatabase( ExePath + SDirIn + '\');
		MoveFile_( ExePath + SDirIn + '\' + DatabaseName,
			ExePath + DatabaseName);
	finally
		MainForm.StatusText := '';
		DM.adtClients.EnableControls;
                tl.Free;
		Synchronize( EnableCancel);
	end;
	DM.ClearBackup( ExePath + SDirIn + '\');
end;

procedure TExchangeThread.CheckNewFRF;
var
	SR: TSearchRec;
begin
	if FindFirst( ExePath + SDirIn + '\*.frf', faAnyFile, SR) = 0 then
	begin
	        repeat
			if ( SR.Attr and faDirectory) = faDirectory then continue;
			try
				MoveFile_( ExePath + SDirIn + '\' + SR.Name, ExePath + '\' + SR.Name);
			except
			end;
        	until FindNext( SR) <> 0;
	end;
end;

procedure TExchangeThread.ImportFromExternalMDB;
const
	IMPORT_COUNT	= 20;
var
	Catalog: Variant;
	i, j, qnum: integer;
begin
	Catalog := CreateOleObject( 'ADOX.Catalog');
        Catalog.ActiveConnection := DM.MainConnection.ConnectionObject;
	try
		for i := 1 to IMPORT_COUNT do
		begin
			if ( IMPORT_COUNT div i) = 2 then
			begin
				TotalProgress := 55;
				Synchronize( SetTotalProgress);
			end;
			Progress := Round( i / IMPORT_COUNT * 100);
			Synchronize( SetProgress);
			for j := 0 to Catalog.Procedures.Count - 1 do
			begin
				if not TryStrToInt( Copy( Catalog.Procedures.Item[ j].Name,
					Length( Catalog.Procedures.Item[ j].Name) - 1, 2), qnum) then continue;
				if ( Pos( 'Import', Catalog.Procedures.Item[ j].Name) = 1) and
					( qnum = i) then
				begin
					MainForm.StatusText := 'Перенос ' + Copy( Catalog.Procedures.Item[ j].Name,
						7, Length( Catalog.Procedures.Item[ j].Name) - 8);
					DM.adcUpdate.CommandText := 'EXECUTE ' + Catalog.Procedures.Item[ j].Name;
					try
						DM.adcUpdate.Execute;
					except
						if Pos( 'Registry', Catalog.Procedures.Item[ j].Name) = 7 then
						begin
							DM.adcUpdate.CommandText := 'EXECUTE ImportRegistryComp';
							DM.adcUpdate.Execute;
						end
						else raise;
					end;
				end;
			end;
		end;
	finally
		Catalog := Unassigned;
		TotalProgress := 60;
		Synchronize( SetTotalProgress);
		Progress := 0;
		Synchronize( SetProgress);
	end;
end;

procedure TExchangeThread.ImportData;
var
	I: Integer;
	Catalog: Variant;
	Tables: TStrings;
	UpdateTables: TUpdateTables;
	IntegrCount: Word;
begin
	StatusText := 'Резервное копирование данных';
	Synchronize( SetStatus);
	DM.BackupDatabase( ExePath);
	DM.OpenDataBase( ExePath + DatabaseName);
	TotalProgress := 65;
	Synchronize( SetTotalProgress);

	StatusText := 'Импорт данных';
	Synchronize( SetStatus);
	Progress := 0;
	Synchronize( SetProgress);
	Synchronize( DisableCancel);
	DM.UnLinkExternalTables;
	DM.LinkExternalTables;
	// создаем список внешних таблиц
	Tables := TStringList.Create;
	try
		//определяем список обновляемых таблиц
		Catalog := CreateOleObject( 'ADOX.Catalog');
		try
			Catalog.ActiveConnection := DM.MainConnection.ConnectionObject;
			for I := Catalog.Tables.Count - 1 downto 0 do
				if Catalog.Tables.Item[ I].Type = 'LINK' then
					Tables.Add(UpperCase(Catalog.Tables.Item[I].Name));
		finally
			Catalog := Unassigned;
		end;
	if Tables.IndexOf( 'EXTCATALOG') >= 0 then UpdateTables:=UpdateTables+[utCatalog];
	if Tables.IndexOf( 'EXTCATDEL') >= 0 then UpdateTables:=UpdateTables+[utCatDel];
	if Tables.IndexOf( 'EXTCATALOGCURRENCY') >= 0 then UpdateTables:=UpdateTables+[utCatalogCurrency];
	if Tables.IndexOf( 'EXTCLIENTS') >= 0 then UpdateTables:=UpdateTables+[utClients];
	if Tables.IndexOf( 'EXTCLIENTSDATAN') >= 0 then UpdateTables:=UpdateTables+[utClientsDataN];
	if Tables.IndexOf( 'EXTREGIONALDATA') >= 0 then UpdateTables:=UpdateTables+[utRegionalData];
	if Tables.IndexOf( 'EXTPRICESDATA') >= 0 then UpdateTables:=UpdateTables+[utPricesData];
	if Tables.IndexOf( 'EXTPRICESREGIONALDATA') >= 0 then UpdateTables:=UpdateTables+[utPricesRegionalData];
	if Tables.IndexOf( 'EXTCORE') >= 0 then UpdateTables:=UpdateTables+[utCore];
	if Tables.IndexOf( 'EXTREGIONS') >= 0 then UpdateTables:=UpdateTables+[utRegions];
	if Tables.IndexOf( 'EXTSECTION') >= 0 then UpdateTables:=UpdateTables+[utSection];
	if Tables.IndexOf( 'EXTSYNONYM') >= 0 then UpdateTables := UpdateTables + [utSynonym];
	if Tables.IndexOf( 'EXTSYNONYMFIRMCR')>=0 then UpdateTables := UpdateTables + [utSynonymFirmCr];
	if Tables.IndexOf( 'EXTREJECTS')>=0 then UpdateTables := UpdateTables + [utRejects];
	if Tables.IndexOf( 'EXTREGISTRY')>=0 then UpdateTables := UpdateTables + [utRegistry];
	if Tables.IndexOf( 'EXTWAYBILLHEAD')>=0 then UpdateTables := UpdateTables + [utWayBillHead];
	if Tables.IndexOf( 'EXTWAYBILLLIST')>=0 then UpdateTables := UpdateTables + [utWayBillList];
    //обновляем таблицы
    {
    Таблица               DELETE  INSERT  UPDATE
    --------------------  ------  ------  ------
    Catalog                         +       +
    CatalogCurrency         +       +       +
    Clients                 +       +       +
    ClientsData             +       +       +
    Core                    +       +
    Prices                  +       +       +
    Regions                 +       +       +
    Section                 +       +       +
    Synonym                         +
    SynonymFirmCr                   +
    WayBillHead                     +
    WayBillList                     +
    }

	Progress := 5;
	Synchronize( SetProgress);

//    DM.MainConnection.BeginTrans;

   with DM.adcUpdate do begin
	//удаляем минимальные цены
	CommandText:='EXECUTE MinPricesDelete'; Execute;
	//удаляем из таблиц ненужные данные
	//CatalogCurrency
	if utCatalogCurrency in UpdateTables then begin
	  CommandText:='EXECUTE CatalogCurrencyDelete'; Execute;
	end;
	//PricesRegionalData
	if utPricesRegionalData in UpdateTables then begin
	  CommandText:='EXECUTE PricesRegionalDataDelete'; Execute;
	end;
	//PricesData
	if utPricesRegionalData in UpdateTables then begin
	  CommandText:='EXECUTE PricesDataDelete'; Execute;
	end;
	//RegionalData
	if utPricesRegionalData in UpdateTables then begin
	  CommandText:='EXECUTE RegionalDataDelete'; Execute;
	end;
	//ClientsDataN
	if utPricesRegionalData in UpdateTables then begin
	  CommandText:='EXECUTE ClientsDataNDelete'; Execute;
	end;
	//Core
	if utCore in UpdateTables then begin
	  CommandText:='EXECUTE CoreDeleteNewPrices'; Execute;
	end;
	if utCore in UpdateTables then begin
	  CommandText:='EXECUTE CoreDeleteOldPrices'; Execute;
	end;
	//Clients
	if utClients in UpdateTables then begin
	  CommandText:='EXECUTE ClientsDelete'; Execute;
	end;
	//Regions
	if utRegions in UpdateTables then begin
	  CommandText:='EXECUTE RegionsDelete'; Execute;
	end;
	// Registry
	if utRegistry in UpdateTables then begin
	  CommandText:='EXECUTE RegistryDelete'; Execute;
	end;

	Progress := 10;
	Synchronize( SetProgress);

	//добавляем в таблицы новые данные и изменяем имеющиеся
	//изменяем и добавляем Section (надо сделать до изменения Catalog)
	if utSection in UpdateTables then begin
	  CommandText:='EXECUTE TmpSectionDelete'; Execute;
	  CommandText:='EXECUTE TmpSectionInsert'; Execute;
	  CommandText:='EXECUTE SectionUpdate'; Execute;
	  CommandText:='EXECUTE TmpSectionDelete'; Execute;
	  CommandText:='EXECUTE SectionInsert'; Execute;
	end;
	//Catalog
	if utCatalog in UpdateTables then begin
	  CommandText:='EXECUTE TmpCatalogDelete'; Execute;
	  CommandText:='EXECUTE TmpCatalogInsert'; Execute;
	  CommandText:='EXECUTE CatalogUpdate'; Execute;
	  CommandText:='EXECUTE TmpCatalogDelete'; Execute;
	  CommandText:='EXECUTE CatalogInsert'; Execute;
	  CommandText:='EXECUTE CatalogSetFormNotNull'; Execute;
          CommandText:='EXECUTE CatalogDeleteHide'; Execute;
	end;

	Progress := 20;
	Synchronize( SetProgress);
	TotalProgress := 70;
	Synchronize( SetTotalProgress);

	//удаляем из Section (можно сделать только после изменения Catalog)
	if utSection in UpdateTables then begin
	  CommandText:='EXECUTE SectionDelete'; Execute;
	end;
	//CatalogCurrency
	if utCatalogCurrency in UpdateTables then begin
	  CommandText:='EXECUTE TmpCatalogCurrencyDelete'; Execute;
	  CommandText:='EXECUTE TmpCatalogCurrencyInsert'; Execute;
	  CommandText:='EXECUTE CatalogCurrencyUpdate'; Execute;
	  CommandText:='EXECUTE TmpCatalogCurrencyDelete'; Execute;
	  CommandText:='EXECUTE CatalogCurrencyInsert'; Execute;
	end;
	//Regions
	if utRegions in UpdateTables then begin
	  CommandText:='EXECUTE TmpRegionsDelete'; Execute;
	  CommandText:='EXECUTE TmpRegionsInsert'; Execute;
	  CommandText:='EXECUTE RegionsUpdate'; Execute;
	  CommandText:='EXECUTE TmpRegionsDelete'; Execute;
	  CommandText:='EXECUTE RegionsInsert'; Execute;
	end;
	//Clients
	if utClients in UpdateTables then begin
	  CommandText:='EXECUTE TmpClientsDelete'; Execute;
	  CommandText:='EXECUTE TmpClientsInsert'; Execute;
	  CommandText:='EXECUTE ClientsUpdate'; Execute;
	  CommandText:='EXECUTE TmpClientsDelete'; Execute;
	  CommandText:='EXECUTE ClientsInsert'; Execute;
	end;
	//ClientsDataN
	if utClientsDataN in UpdateTables then begin
	  CommandText:='EXECUTE TmpClientsDataNDelete'; Execute;
	  CommandText:='EXECUTE TmpClientsDataNInsert'; Execute;
	  CommandText:='EXECUTE ClientsDataNUpdate'; Execute;
	  CommandText:='EXECUTE TmpClientsDataNDelete'; Execute;
	  CommandText:='EXECUTE ClientsDataNInsert'; Execute;
	end;
	//RegionalData
	if utRegionalData in UpdateTables then begin
	  CommandText:='EXECUTE TmpRegionalDataDelete'; Execute;
	  CommandText:='EXECUTE TmpRegionalDataInsert'; Execute;
	  CommandText:='EXECUTE RegionalDataUpdate'; Execute;
	  CommandText:='EXECUTE TmpRegionalDataDelete'; Execute;
	  CommandText:='EXECUTE RegionalDataInsert'; Execute;
	end;
	//PricesData
	if utPricesData in UpdateTables then begin
	  CommandText:='EXECUTE TmpPricesDataDelete'; Execute;
	  CommandText:='EXECUTE TmpPricesDataInsert'; Execute;
	  CommandText:='EXECUTE PricesDataUpdate'; Execute;
	  CommandText:='EXECUTE TmpPricesDataDelete'; Execute;
	  CommandText:='EXECUTE PricesDataInsert'; Execute;
	end;
	//PricesRegionalData
	if utPricesData in UpdateTables then begin
	  CommandText:='EXECUTE TmpPricesRegionalDataDelete'; Execute;
	  CommandText:='EXECUTE TmpPricesRegionalDataInsert'; Execute;
	  CommandText:='EXECUTE PricesRegionalDataUpdate'; Execute;
	  CommandText:='EXECUTE TmpPricesRegionalDataDelete'; Execute;
	  CommandText:='EXECUTE PricesRegionalDataInsert'; Execute;
	end;

	Progress := 30;
	Synchronize( SetProgress);

	//Synonym
	if utSynonym in UpdateTables then begin
	  CommandText:='EXECUTE SynonymInsert'; Execute;
	  //CommandText:='EXECUTE SynonymInsertUnfounded'; Execute;
	end;
	//SynonymFirmCr
	if utSynonymFirmCr in UpdateTables then begin
	  CommandText:='EXECUTE SynonymFirmCrInsert'; Execute;
	end;
	//Core
	if utCore in UpdateTables then begin
	  CommandText:='EXECUTE CoreDeleteOldPrices'; Execute;
	end;
	if utCore in UpdateTables then begin
	  CommandText:='EXECUTE CoreInsert'; Execute;
	end;
	//WayBillHead
	if utWayBillHead in UpdateTables then begin
	  CommandText:='EXECUTE WayBillHeadInsert'; Execute;
	end;
	//WayBillList
	if utWayBillList in UpdateTables then begin
	  CommandText:='EXECUTE WayBillListInsert'; Execute;
	end;

	Progress := 40;
	Synchronize( SetProgress);
	CommandText := 'EXECUTE CoreDeleteFormHeaders'; Execute;
	Progress := 50;
	Synchronize( SetProgress);
	CommandText := 'EXECUTE SynonymDeleteFormHeaders'; Execute;
	Progress := 60;
	Synchronize( SetProgress);
	TotalProgress := 75;
	Synchronize( SetTotalProgress);

	{ Блок интеграции прайс листов }
	if IsIntegrDLLPresent then
	begin
		IntegrTotalWellPrices( DM.MainConnection,
			DM.adtClients.FieldByName( 'RegionCode').AsInteger,
			IntegrCount);
		try
			if IntegrCount > 0 then IntegrThreading( ExchangeForm.AppHandle,
				DM.MainConnection, DM.adtClients.FieldByName( 'RegionCode').AsInteger,
				ExchangeForm.stStatus, ExchangeForm.ProgressBar, nil, False);
		except
			on E: Exception do Windows.MessageBox( 0, PChar( E.Message),
				'Ошибка', MB_OK or MB_ICONERROR);
		end;
	end;

	StatusText := 'Импорт данных';
	Synchronize( SetStatus);

	if DM.adtParams.FieldByName( 'OperateFormsSet').AsBoolean then
	begin
		CommandText := 'EXECUTE SynonymInsertFormHeaders'; Execute;
		Progress := 70;
		Synchronize( SetProgress);
		CommandText := 'EXECUTE CoreInsertFormHeaders'; Execute;
		Progress := 80;
		Synchronize( SetProgress);
	end;

	DM.adtParams.Edit;
	DM.adtParams.FieldByName( 'OperateForms').AsBoolean :=
		DM.adtParams.FieldByName( 'OperateFormsSet').AsBoolean;
	DM.adtParams.Post;

	TotalProgress := 80;
	Synchronize( SetTotalProgress);

	{ Добавляем забракованые препараты }
	if utRejects in UpdateTables then
	begin
		CommandText:='EXECUTE DefectivesInsert'; Execute;
	end;
	{ Добавляем реестр }
	if utRegistry in UpdateTables then
	begin
		CommandText := 'EXECUTE RegistryInsert'; Execute;
	end;

	DM.adtClients.Requery;
	//проставляем мин. цены и лидеров
	CommandText := 'EXECUTE MinPricesInsert ' +
		BoolToStr( DM.adtClients.FieldByName( 'LeadFromBasic').AsInteger = 1);
	Execute;
	Progress := 90;
	Synchronize( SetProgress);
	TotalProgress := 85;
	Synchronize( SetTotalProgress);
	CommandText := 'EXECUTE MinPricesSetPriceCode ' +
		BoolToStr( DM.adtClients.FieldByName( 'LeadFromBasic').AsInteger = 1);
	Execute;
	Progress := 100;
	Synchronize( SetProgress);
	TotalProgress := 90;
	Synchronize( SetTotalProgress);
    end;
  finally
	Tables.Free;
//	DM.MainConnection.CommitTrans;
  end;
	DM.UnLinkExternalTables;
	DM.ClearBackup( ExePath);
	{ Показываем время обновления }
	DM.adtParams.Edit;
	DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime :=
		DM.adtParams.FieldByName( 'LastDateTime').AsDateTime;
	DM.adtParams.Post;
	Synchronize( MainForm.SetUpdateDateTime);
	Synchronize( EnableCancel);
	//DeleteFilesByMask(ExePath+SDirIn+'\*.*');
end;

function TExchangeThread.GetXMLDateTime( ADateTime: TDateTime): string;
var
	DateTime: TXSDateTime;
begin
	DateTime := TXSDateTime.Create;
	DateTime.AsDateTime := ADateTime;
	result := IntToStr( YearOf( DateTime.AsDateTime)) + '-' +
		IntToStr( MonthOf( DateTime.AsDateTime)) + '-' +
		IntToStr( DayOf( DateTime.AsDateTime)) + ' ' +
		IntToStr( HourOf( DateTime.AsDateTime)) + ':' +
		IntToStr( MinuteOf( DateTime.AsDateTime)) + ':' +
		IntToStr( SecondOf( DateTime.AsDateTime)) {+ '.0000000'};
end;

function TExchangeThread.FromXMLToDateTime( AStr: string): TDateTime;
begin
	result := EncodeDateTime( StrToInt( Copy( AStr, 1, 4)),
		StrToInt( Copy( AStr, 6, 2)),
		StrToInt( Copy( AStr, 9, 2)),
		StrToInt( Copy( AStr, 12, 2)),
		StrToInt( Copy( AStr, 15, 2)),
		StrToInt( Copy( AStr, 18, 2)),
		0);
end;

function TExchangeThread.StringToCodes( AStr: string): string;
var
	i: integer;
	code: string;
begin
	result := '';
	for i := 1 to Length( Astr) do
	begin
		code := IntToStr( Ord( AStr[ i]));
		if Length( code) = 2 then code := '0' + code;
		result := result + code;
	end;
end;

function TExchangeThread.RusError( AStr: string): string;
begin
	result := AStr;
	if AStr = 'Read Timeout' then
	begin
		result :=
			'Соединение разорвано из-за превышения времени ожидания ответа сервера.' +
			#10#13 + 'Повторите запрос через несколько минут.'#13#10#13#10 + AStr;
		exit;
	end;
	if ( Pos( 'connection timeout', AnsiLowerCase( AStr)) > 0) or
		( Pos( 'timed out', AnsiLowerCase( AStr)) > 0) then
	begin
		result := 'Превышения времени ожидания подключения к серверу.' +
			#10#13 + 'Повторите запрос через несколько минут.'#13#10#13#10 + AStr;
		exit;
	end;
	if Pos( 'reset by peer', AnsiLowerCase( AStr)) > 0 then
	begin
		result := 'Соединение разорвано.' + #10#13 +
			'Повторите запрос через несколько минут.'#13#10#13#10 + AStr;
		exit;
	end;
	if Pos( 'connection refused', AnsiLowerCase( AStr)) > 0 then
	begin
		result := 'Не удалось установить соединение.'#13#10#13#10 + AStr;
		exit;
	end;
	if Pos( 'host not found', AnsiLowerCase( AStr)) > 0 then
	begin
		result := 'Сервер не найден.'#13#10#13#10 + AStr;
		exit;
	end;
end;

procedure TExchangeThread.OnConnectError(AMessage: String);
begin
  WriteLn(ExchangeForm.LogFile, AMessage);
end;

procedure TExchangeThread.OnReclameTerminate(Sender: TObject);
begin
  if ( eaGetPrice in ExchangeForm.ExchangeActs) or
    ( eaSendOrders in ExchangeForm.ExchangeActs) then
  begin
    HTTPDisconnect;
    RasDisconnect;
  end;
end;

procedure TExchangeThread.StopReclame;
begin
  RecThread.Terminate;
  try
    ExchangeForm.HTTPReclame.Disconnect;
  except
  end;
end;

function TExchangeThread.GetLibraryVersion: TStrings;
var
  DirPath : String;

  procedure FindVersions(Mask : String; Res : TStrings);
  var
    sr : TSearchRec;
    RxVer : TVersionInfo;
  begin
    if SysUtils.FindFirst(Mask, faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then begin
          try
            RxVer := TVersionInfo.Create(DirPath + sr.Name);
            try
              Result.Add(sr.Name + '=' + RxVer.FileVersion);
            finally
              RxVer.Free;
            end;
          except
          end;
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
  end;

begin
  Result := TStringList.Create;
  try
    DirPath := ExtractFilePath(ParamStr(0));
    FindVersions(DirPath + '*.bpl', Result);
    FindVersions(DirPath + '*.dll', Result);
  except
    Result.Free;
    raise;
  end;
end;

end.
