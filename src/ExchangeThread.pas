unit ExchangeThread;

interface

uses
	Classes, SysUtils, Windows, StrUtils, ComObj, Variants, XSBuiltIns,
	SOAPThroughHTTP, DateUtils, ShellAPI, ExtCtrls, RecThread, ActiveX,
  IdException, WinSock, RxVerInf, pFIBQuery, pFIBDatabase, FIBMiscellaneous,
  FIBQuery, ibase, U_TINFIBInputDelimitedStream, VCLUnZip, SevenZip;

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
  utWayBillList,
  utMinPrices);

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
  StartExec : TDateTime;
  AbsentPriceCodeSL : TStringList;
  ASynPass,
  ACodesPass,
  ABPass : String;

  upB : TpFIBQuery;

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
  procedure GetPass;
  procedure PriceDataSettings;
  procedure DMSavePass;
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
  procedure GetAbsentPriceCode;

  procedure UpdateFromFile(FileName, InsertSQL : String; OnBatching : TOnBatching = nil);
  
	procedure ImportFromExternalMDB;
	function GetXMLDateTime( ADateTime: TDateTime): string;
	function FromXMLToDateTime( AStr: string): TDateTime;
	function StringToCodes( AStr: string): string;
	function RusError( AStr: string): string;
  procedure OnConnectError (AMessage : String);
  procedure OnReclameTerminate(Sender: TObject);
  function  GetLibraryVersion : TStrings;
  procedure GetWinVersion(var ANumber, ADesc : String);
  procedure GetJETMDACVersions(var AJETVersion, AJETDesc, AMDACVersion, AMDACDesc : String);
  function GetLibraryVersionByName(AName: String): String;
  function GetLibraryVersionFromPath(AName: String): String;
  procedure adcUpdateBeforeExecute(Sender: TObject);
  procedure adcUpdateAfterExecute(Sender: TObject);
protected
	procedure Execute; override;
public
  destructor Destroy; override;
end;

implementation

uses Exchange, DModule, AProc, Main, Retry, Integr, Exclusive, ExternalOrders,
  DB, U_FolderMacros, LU_Tracer, FIBDatabase, FIBDataSet;

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
				if ([eaImportOnly, eaGetFullData, eaMDBUpdate] * ExchangeForm.ExchangeActs = []) then
        begin
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
					PriceDataSettings;
        end;
				TotalProgress := 15;
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
				if (eaGetPrice in ExchangeForm.ExchangeActs) and not DM.NeedCommitExchange then
				begin
//					ExchangeForm.HTTP.ReadTimeout := 1000000; // 1000 секунд на запрос
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
					QueryData;
          GetPass;
					GetReclame;
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
      if ( eaSendOrders in ExchangeForm.ExchangeActs) then
        OnReclameTerminate(nil)
      else
        if eaGetPrice in ExchangeForm.ExchangeActs then
          if Assigned(RecThread) and not RecThread.RecTerminated then
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
        if Assigned(RecThread) then begin
          if not RecThread.RecTerminated then RecThread.WaitFor;
          RecThread.Free;
        end;
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
        //если это сокетная ошибка, то не рвем DialUp
        if not (E is EIdException) then
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
begin
	{ создаем экземпляр класса TSOAP для работы с SOAP через HTTP вручную }
	URL := 'http://' + ExtractURL( DM.adtParams.FieldByName( 'HTTPHost').AsString) +
		':80/' + DM.adtParams.FieldByName( 'ServiceName').AsString + '/code.asmx';
	SOAP := TSOAP.Create( URL, DM.adtParams.FieldByName( 'HTTPName').AsString,
		DM.adtParams.FieldByName( 'HTTPPass').AsString, OnConnectError, ExchangeForm.HTTP);
end;

procedure TExchangeThread.GetReclame;
begin
	RecThread := TReclameThread.Create( True);
	RecThread.Resume;
end;

procedure TExchangeThread.QueryData;
const
  StaticParamCount : Integer = 11;
var
	Res: TStrings;
  Error : String;
  ParamNames, ParamValues : array of String;
  I : Integer;
  WinNumber, WinDesc : String;
  AJETVersion, AJETDesc, AMDACVersion, AMDACDesc : String;
begin
	{ запрашиваем данные }
	StatusText := 'Запрос данных';
	Synchronize( SetStatus);
	try
    Res := GetLibraryVersion;
    try
      SetLength(ParamNames, StaticParamCount + Res.Count*2);
      SetLength(ParamValues, StaticParamCount + Res.Count*2);
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

      GetWinVersion(WinNumber, WinDesc);
      ParamNames[5]  := 'WINVersion';
      ParamValues[5] := WinNumber;
      ParamNames[6]  := 'WINDesc';
      ParamValues[6] := WinDesc;
      
      GetJETMDACVersions(AJETVersion, AJETDesc, AMDACVersion, AMDACDesc);
      ParamNames[7]  := 'JETVersion';
      ParamValues[7] := AJETVersion;
      ParamNames[8]  := 'JETDesc';
      ParamValues[8] := AJETDesc;

      ParamNames[9]  := 'MDACVersion';
      ParamValues[9] := AMDACVersion;
      ParamNames[10]  := 'MDACDesc';
      ParamValues[10] := AMDACDesc;

      for I := 0 to Res.Count-1 do begin
        ParamNames[StaticParamCount+i*2] := 'LibraryName';
        ParamValues[StaticParamCount+i*2] := Res.Names[i];
        ParamNames[StaticParamCount+i*2+1] := 'LibraryVersion';
        ParamValues[StaticParamCount+i*2+1] := Res.Values[Res.Names[i]];
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
	params, values: array of string;
  I : Integer;
begin
  DM.SetNeedCommitExchange;

  try
    Flush(ExchangeForm.LogFile);
    FS := TFileStream.Create(ExePath + 'Exchange.log', fmOpenRead or fmShareDenyNone);
    try
      Len := Integer(FS.Size);
      SetLength(LogStr, Len);
      FS.Read(Pointer(LogStr)^, Len);
    finally
      FS.Free;
    end;
  except
    LogStr := '';
  end;

  Synchronize(GetAbsentPriceCode);

  if Assigned(AbsentPriceCodeSL) and (AbsentPriceCodeSL.Count > 0) then begin
    SetLength(params, AbsentPriceCodeSL.Count + 1);
    SetLength(values, AbsentPriceCodeSL.Count + 1);
    for I := 0 to AbsentPriceCodeSL.Count-1 do begin
      params[i]:= 'PriceCode';
      values[i]:= AbsentPriceCodeSL[i];
    end;
    params[AbsentPriceCodeSL.Count]:= 'Log';
    values[AbsentPriceCodeSL.Count]:= LogStr;
  end
  else begin
    SetLength(params, 2);
    SetLength(values, 2);
    params[0]:= 'PriceCode';
    values[0]:= '0';
    params[1]:= 'Log';
    values[1]:= LogStr;
  end;

//  Res := SOAP.Invoke( 'MaxSynonymCode', ['Log'], [LogStr]);
//	Res := SOAP.Invoke( 'MaxSynonymCodeV2', ['Log'], [LogStr]);
//	Res := SOAP.Invoke( 'MaxSynonymCodeV2', params, values);
	Res := SOAP.Invoke( 'MaxSynonymCodeV3', params, values);

	ExchangeDateTime := FromXMLToDateTime( Res.Text);
	DM.adtParams.Edit;
	DM.adtParams.FieldByName( 'LastDateTime').AsDateTime := ExchangeDateTime;
  if DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean then begin
    DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean := False;
    MainForm.EnableByHTTPName;
  end;
	DM.adtParams.Post;
	CloseFile( ExchangeForm.LogFile);
  SysUtils.DeleteFile(ExePath + 'Exchange.log');
  Rewrite( ExchangeForm.LogFile); //создаем лог-файл
  DM.ResetNeedCommitExchange;
end;

procedure TExchangeThread.DoSendOrders;
var
	params, values: array of string;
	i: integer;
	Res: TStrings;
  ResError : String;
	ServerOrderId: integer;
  SendError : Boolean;
  ExternalRes : Boolean;
  ErrorStr : PChar;
  ExtErrorMessage : String;
  S : String;
begin
 	DM.adsOrdersH.Close;
	DM.adsOrdersH.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').Value;
	DM.adsOrdersH.ParamByName( 'AClosed').Value := False;
	DM.adsOrdersH.ParamByName( 'ASend').Value := True;
	DM.adsOrdersH.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	DM.adsOrdersH.Open;
	if not DM.adsOrdersH.Eof then
	begin
		StatusText := 'Отправка заказов';
		Synchronize( SetStatus);
	end;
	while not DM.adsOrdersH.Eof do
	begin
    SendError := False;
    DM.adsOrders.Close;
		DM.adsOrders.ParamByName( 'AOrderId').Value :=
      DM.adsOrdersH.FieldByName( 'OrderId').Value;
    DM.adsOrders.Open;

    WriteLn(ExchangeForm.LogFile,
      'Отправка заказа #' + DM.adsOrdersH.FieldByName( 'OrderId').AsString +
      '  по прайсу ' + DM.adsOrdersH.FieldByName( 'PriceCode').AsString);
		SetLength( params, 6 + DM.adsOrders.RecordCountFromSrv * 11 + 1);
		SetLength( values, 6 + DM.adsOrders.RecordCountFromSrv * 11 + 1);

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
		values[ 4] := StringToCodes( DM.adsOrdersH.FieldByName( 'MessageTO').AsString);
		values[ 5] := IntToStr( DM.adsOrders.RecordCountFromSrv);

		for i := 0 to DM.adsOrders.RecordCountFromSrv - 1 do
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
      try
   			values[ i * 11 + 11] := DM.D_C( DM.adsOrders.FieldByName( 'Code').AsString );
      except
        values[ i * 11 + 11] := DM.adsOrders.FieldByName( 'Code').AsString;
      end;
      try
  			values[ i * 11 + 12] := DM.D_C( DM.adsOrders.FieldByName( 'CodeCr').AsString );
      except
        values[ i * 11 + 12] := DM.adsOrders.FieldByName( 'CodeCr').AsString;
      end;
			values[ i * 11 + 13] := DM.adsOrders.FieldByName( 'Ordercount').AsString;
			values[ i * 11 + 14] := BoolToStr( DM.adsOrders.FieldByName( 'Junk').AsBoolean, True);
			values[ i * 11 + 15] := BoolToStr( DM.adsOrders.FieldByName( 'Await').AsBoolean, True);
      try
        S := DM.D_B(DM.adsOrders.FieldByName( 'Code').AsString, DM.adsOrders.FieldByName( 'CodeCr').AsString);
        S := StringReplace(S, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
        values[ i * 11 + 16] := S;
      except
        values[ i * 11 + 16] := '0.0';
      end;
			DM.adsOrders.Edit;
			DM.adsOrders.FieldByName( 'CoreId').AsVariant := Null;
      DM.adsOrders.Post;
			DM.adsOrders.Next;
		end;

    if IsExternalOrdersDLLPresent then
      if ExternalOrdersPriceIsProtek(DM.MainConnection1, DM.adsOrdersH.FieldByName( 'OrderId').AsInteger)
      then begin
        Inc(ExchangeForm.ExternalOrdersCount);
        try
          ExternalRes := ExternalOrdersThreading(
            ExchangeForm.AppHandle,
            DM.MainConnection1,
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

    ServerOrderId := 0;
		try
      //Передаем уникальный идентификатор
      params[ 6 + DM.adsOrders.RecordCountFromSrv * 11 ] := 'UniqueID';
      values[ 6 + DM.adsOrders.RecordCountFromSrv * 11 ] := IntToHex( GetCopyID, 8);
			Res := Soap.Invoke( 'PostOrder1', params, values);
//			ExchangeForm.QueryResults.Clear;
			// QueryResults.DelimitedText не работает из-за пробела, который почему-то считается разделителем
//			while Res <> '' do ExchangeForm.QueryResults.Add( GetNextWord( Res, ';'));
			// проверяем отсутствие ошибки при удаленном запросе
			ResError := Utf8ToAnsi( Res.Values[ 'Error']);
			if ResError <> '' then begin
        SendError := True;
        ExchangeForm.SendOrdersLog.Add(
          Format('Заказ по прайс-листу %s (%s) не был отправлен. Причина : %s',
            [DM.adsOrdersH.FieldByName( 'PriceName').AsString,
             DM.adsOrdersH.FieldByName( 'RegionName').AsString,
            ResError])
        );
				//raise Exception.Create( ResError + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));
      end;
      if not SendError then
        try
          ServerOrderId := StrToInt( Res.Values[ 'OrderId']);
        except
          ServerOrderId := 0;
          SendError := True;
          ExchangeForm.SendOrdersLog.Add(
            Format('Заказ по прайс-листу %s (%s) не был отправлен. Причина : Не удалось конвертировать строку "%s"',
              [DM.adsOrdersH.FieldByName( 'PriceName').AsString,
               DM.adsOrdersH.FieldByName( 'RegionName').AsString,
               Res.Values[ 'OrderId']])
          );
        end;
		except
			DM.adsOrdersH.Close;
			DM.adsOrders.Close;
			Synchronize( MainForm.SetOrdersInfo);
			raise;
		end;

		try
			DM.adsOrders.Close;
      if not SendError then begin
        DM.adsOrdersH.Edit;
        { Заказ был отправлен, а не переведен }
        DM.adsOrdersH.FieldByName( 'Send').AsBoolean := True;
        DM.adsOrdersH.FieldByName( 'SendDate').AsDateTime := Now;
        { Закрываем заказ }
        DM.adsOrdersH.FieldByName( 'Closed').AsBoolean := True;
        DM.adsOrdersH.FieldByName( 'ServerOrderId').AsInteger := ServerOrderId;
        DM.adsOrdersH.Post;
      end;
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
  SevenZipRes : Integer;
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
{
				ExchangeForm.UnZip.DestDir := ExePath + SDirReclame;
				ExchangeForm.UnZip.UnZip;
}        

        SevenZipRes := SevenZipExtractArchive(
          0,
          ExePath + SDirIn + '\' + SR.Name,
          '*.*',
          True,
          '',
          True,
          ExePath + SDirReclame,
          False,
          nil);

        if SevenZipRes <> 0 then
          raise Exception.CreateFmt('Не удалось разархивировать файл %s. Код ошибки %d', [ExePath + SDirIn + '\' + SR.Name, SevenZipRes]);

				DeleteFileA( ExePath + SDirIn + '\' + SR.Name);
			end
                	{ Если это данные }
			else
			begin
{
				ExchangeForm.UnZip.DestDir := ExePath + SDirIn;
				ExchangeForm.UnZip.UnZip;
				DeleteFileA( ExchangeForm.UnZip.ZipName);
				DeleteFileA( ExePath + SDirIn + '\' + ChangeFileExt( SR.Name, '.zi_'));
}
        SevenZipRes := SevenZipExtractArchive(
          0,
          ExePath + SDirIn + '\' + SR.Name,
          '*.*',
          True,
          '',
          True,
          ExePath + SDirIn,
          False,
          nil);
        if SevenZipRes <> 0 then
          raise Exception.CreateFmt('Не удалось разархивировать файл %s. Код ошибки %d', [ExePath + SDirIn + '\' + SR.Name, SevenZipRes]);

				DeleteFileA( ExePath + SDirIn + '\' + SR.Name);
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
begin
	if eaGetFullData in ExchangeForm.ExchangeActs then
	begin
		StatusText := 'Очистка таблиц';
		Synchronize( SetStatus);
		DM.ClearDatabase;
    DM.MainConnection1.DefaultTransaction.CommitRetaining;
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
{
	tl := TStringList.Create;
	try
		DM.MainConnection.GetTableNames( tl, false);
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
}  
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
{
var
	Catalog: Variant;
	i, j, qnum: integer;
}  
begin
{
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
}  
end;

procedure TExchangeThread.ImportData;
var
//	I: Integer;
//	Catalog: Variant;
	Tables: TStrings;
	UpdateTables: TUpdateTables;
//	IntegrCount: Word;
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
{
		Catalog := CreateOleObject( 'ADOX.Catalog');
		try
			Catalog.ActiveConnection := DM.MainConnection.ConnectionObject;
			for I := Catalog.Tables.Count - 1 downto 0 do
				if Catalog.Tables.Item[ I].Type = 'LINK' then
					Tables.Add(UpperCase(Catalog.Tables.Item[I].Name));
		finally
			Catalog := Unassigned;
		end;
}
  DM.MainConnection1.GetTableNames(Tables, False);
  UpdateTables := [];

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
//	if Tables.IndexOf( 'EXTREGISTRY')>=0 then UpdateTables := UpdateTables + [utRegistry];
	if Tables.IndexOf( 'EXTWAYBILLHEAD')>=0 then UpdateTables := UpdateTables + [utWayBillHead];
	if Tables.IndexOf( 'EXTWAYBILLLIST')>=0 then UpdateTables := UpdateTables + [utWayBillList];
	if Tables.IndexOf( 'EXTMINPRICES')>=0 then UpdateTables := UpdateTables + [utMinPrices];
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

   DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;
   try
   DM.adcUpdate.BeforeExecute := adcUpdateBeforeExecute;
   DM.adcUpdate.AfterExecute := adcUpdateAfterExecute;
   with DM.adcUpdate do begin
	//удаляем минимальные цены
	SQL.Text:='EXECUTE PROCEDURE MinPricesDelete'; ExecQuery;
	//удаляем из таблиц ненужные данные
	//CatalogCurrency
	if utCatalogCurrency in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE CatalogCurrencyDelete'; ExecQuery;
	end;
	//PricesRegionalData
	if utPricesRegionalData in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE PricesRegionalDataDelete'; ExecQuery;
	end;
	//PricesData
	if utPricesRegionalData in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE PricesDataDelete'; ExecQuery;
	end;
	//RegionalData
	if utPricesRegionalData in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE RegionalDataDelete'; ExecQuery;
	end;
	//ClientsDataN
	if utPricesRegionalData in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE ClientsDataNDelete'; ExecQuery;
	end;
	//Core
	if utCore in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE CoreDeleteNewPrices'; ExecQuery;
	end;
	if utCore in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE CoreDeleteOldPrices'; ExecQuery;
	end;
	//Clients
	if utClients in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE ClientsDelete'; ExecQuery;
	end;
	//Regions
	if utRegions in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE RegionsDelete'; ExecQuery;
	end;
	// Registry
	if utRegistry in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE RegistryDelete'; ExecQuery;
	end;

  DM.MainConnection1.DefaultUpdateTransaction.Commit;
  
  DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;

	SQL.Text := 'select count(*) from MinPrices where PriceCode is not null';
	ExecQuery;
  Close;
	SQL.Text := 'select count(*) from pricesregionaldata where regioncode is not null';
	ExecQuery;
  Close;
	SQL.Text := 'select count(*) from PricesData where PriceFiledate is null';
	ExecQuery;
  Close;
	SQL.Text := 'select count(*) from RegionalData where regioncode is not null';
	ExecQuery;
  Close;
	SQL.Text := 'select count(*) from ClientsDataN where fullname is not null';
	ExecQuery;
  Close;
	SQL.Text := 'select count(*) from Core where Fullcode is not null';
	ExecQuery;
  Close;
	SQL.Text := 'select count(*) from Clients where regioncode is not null';
	ExecQuery;
  Close;
	SQL.Text := 'select count(*) from regions where regionname is not null';
	ExecQuery;
  Close;
  DM.MainConnection1.DefaultUpdateTransaction.Commit;
//  DM.MainConnection1.DefaultTransaction.CommitRetaining;
  DM.MainConnection1.Commit;
  DM.MainConnection1.Close;

  //Чистим мусор после обновления.
//  DM.SweepDB;
//  if not (eaGetFullData in ExchangeForm.ExchangeActs) then
//    DM.CompactDataBase();

  DM.MainConnection1.Open;
  DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;

	Progress := 10;
	Synchronize( SetProgress);

	//добавляем в таблицы новые данные и изменяем имеющиеся
	//изменяем и добавляем Section (надо сделать до изменения Catalog)
	if utSection in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE TmpSectionDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpSectionInsert'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE SectionUpdate'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpSectionDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE SectionInsert'; ExecQuery;
	end;
	//Catalog
	if utCatalog in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE TmpCatalogDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpCatalogInsert'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE CatalogUpdate'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpCatalogDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE CatalogInsert'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE CatalogSetFormNotNull'; ExecQuery;
   	if utCatDel in UpdateTables then begin
      SQL.Text:='EXECUTE PROCEDURE CatalogDeleteHide'; ExecQuery;
    end;
	end;

	Progress := 20;
	Synchronize( SetProgress);
	TotalProgress := 70;
	Synchronize( SetTotalProgress);

	//удаляем из Section (можно сделать только после изменения Catalog)
	if utSection in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE SectionDelete'; ExecQuery;
	end;
	//CatalogCurrency
	if utCatalogCurrency in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE TmpCatalogCurrencyDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpCatalogCurrencyInsert'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE CatalogCurrencyUpdate'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpCatalogCurrencyDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE CatalogCurrencyInsert'; ExecQuery;
	end;
	//Regions
	if utRegions in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE TmpRegionsDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpRegionsInsert'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE RegionsUpdate'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpRegionsDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE RegionsInsert'; ExecQuery;
	end;
	//Clients
	if utClients in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE TmpClientsDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpClientsInsert'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE ClientsUpdate'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpClientsDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE ClientsInsert'; ExecQuery;
	end;
	//ClientsDataN
	if utClientsDataN in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE TmpClientsDataNDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpClientsDataNInsert'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE ClientsDataNUpdate'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpClientsDataNDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE ClientsDataNInsert'; ExecQuery;
	end;
	//RegionalData
	if utRegionalData in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE TmpRegionalDataDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpRegionalDataInsert'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE RegionalDataUpdate'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpRegionalDataDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE RegionalDataInsert'; ExecQuery;
	end;
	//PricesData
	if utPricesData in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE TmpPricesDataDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpPricesDataInsert'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE PricesDataUpdate'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpPricesDataDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE PricesDataInsert'; ExecQuery;
	end;
	//PricesRegionalData
	if utPricesData in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE TmpPricesRegionalDataDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpPricesRegionalDataInsert'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE PricesRegionalDataUpdate'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE TmpPricesRegionalDataDelete'; ExecQuery;
	  SQL.Text:='EXECUTE PROCEDURE PricesRegionalDataInsert'; ExecQuery;
	end;

	Progress := 30;
	Synchronize( SetProgress);

	//Synonym
	if utSynonym in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE SynonymInsert'; ExecQuery;
    UpdateFromFile(ExePath+SDirIn+'\Synonym.txt',
'INSERT INTO Synonyms ' +
'(Synonymcode, Synonymname, fullcode, shortcode, pricecode) '+
'SELECT :Synonymcode, :Synonymname, :fullcode, :shortcode, :pricecode '+
'FROM rdb$database '+
'WHERE Not Exists(SELECT SynonymCode FROM Synonyms WHERE SynonymCode=:Synonymcode)');
	  //SQL.Text:='EXECUTE PROCEDURE SynonymInsertUnfounded'; ExecQuery;
	end;
	//SynonymFirmCr
	if utSynonymFirmCr in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE SynonymFirmCrInsert'; ExecQuery;
	end;
	//Core
	if utCore in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE CoreDeleteOldPrices'; ExecQuery;
	end;
	if utCore in UpdateTables then begin
//	  SQL.Text:='EXECUTE PROCEDURE CoreInsert'; ExecQuery;
	  SQL.Text:='alter table core DROP CONSTRAINT FK_CORE_FULLCODE'; ExecQuery;
	  SQL.Text:='alter table core DROP CONSTRAINT FK_CORE_PRICECODE'; ExecQuery;
	  SQL.Text:='alter table core DROP CONSTRAINT FK_CORE_REGIONCODE'; ExecQuery;
	  SQL.Text:='alter table core DROP CONSTRAINT PK_CORE'; ExecQuery;
	  SQL.Text:='drop index FK_CORE_SYNONYMCODE'; ExecQuery;
	  SQL.Text:='drop index FK_CORE_SYNONYMFIRMCRCODE'; ExecQuery;
//	  SQL.Text:='drop index IDX_CORE_FULLCODE_BASECOST'; ExecQuery;
	  SQL.Text:='drop index IDX_CORE_SERVERCOREID'; ExecQuery;
	  SQL.Text:='drop index IDX_CORE_JUNK'; ExecQuery;
//	  SQL.Text:='drop index IDX_CORE_SHORTCODE'; ExecQuery;
    DM.MainConnection1.DefaultUpdateTransaction.Commit;

    DM.MainConnection1.Close;
    DM.MainConnection1.Open;
    DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;
//	  SQL.Text:='alter index PK_CORE inactive'; ExecQuery;
    UpdateFromFile(ExePath+SDirIn+'\Core.txt',
'INSERT INTO Core '+
'(Pricecode, RegionCode, FullCode, CodeFirmCr, SynonymCode, SynonymFirmCrCode,' +
'Code, CodeCr, Unit, Volume, Junk, Await, Quantity, Note, Period, Doc, BaseCost, ServerCOREID)' +
'values (:Pricecode, :RegionCode, :FullCode, :CodeFirmCr, :SynonymCode, ' +
':SynonymFirmCrCode, :Code, :CodeCr, :Unit, :Volume, :Junk, :Await, :Quantity, ' +
':Note, :Period, :Doc, :BaseCost, :ServerCOREID)');
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT PK_CORE PRIMARY KEY (COREID)'; ExecQuery;
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT FK_CORE_FULLCODE FOREIGN KEY (FULLCODE) REFERENCES CATALOGS (FULLCODE) ON DELETE CASCADE ON UPDATE CASCADE'; ExecQuery;
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT FK_CORE_PRICECODE FOREIGN KEY (PRICECODE) REFERENCES PRICESDATA (PRICECODE) ON DELETE CASCADE ON UPDATE CASCADE'; ExecQuery;
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT FK_CORE_REGIONCODE FOREIGN KEY (REGIONCODE) REFERENCES REGIONS (REGIONCODE) ON UPDATE CASCADE'; ExecQuery;
//	  SQL.Text:='CREATE INDEX IDX_CORE_FULLCODE_BASECOST ON CORE (FULLCODE, BASECOST)'; ExecQuery;
	  SQL.Text:='CREATE INDEX IDX_CORE_JUNK ON CORE (FULLCODE, JUNK)'; ExecQuery;
	  SQL.Text:='CREATE INDEX IDX_CORE_SERVERCOREID ON CORE (SERVERCOREID)'; ExecQuery;
//	  SQL.Text:='CREATE INDEX IDX_CORE_SHORTCODE ON CORE (SHORTCODE)'; ExecQuery;
	  SQL.Text:='CREATE INDEX FK_CORE_SYNONYMCODE ON CORE (SYNONYMCODE)'; ExecQuery;
	  SQL.Text:='CREATE INDEX FK_CORE_SYNONYMFIRMCRCODE ON CORE (SYNONYMFIRMCRCODE)'; ExecQuery;
	end;
	//WayBillHead
	if utWayBillHead in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE WayBillHeadInsert'; ExecQuery;
	end;
	//WayBillList
	if utWayBillList in UpdateTables then begin
	  SQL.Text:='EXECUTE PROCEDURE WayBillListInsert'; ExecQuery;
	end;

	Progress := 40;
	Synchronize( SetProgress);
	SQL.Text := 'EXECUTE PROCEDURE CoreDeleteFormHeaders'; ExecQuery;
	Progress := 50;
	Synchronize( SetProgress);
	SQL.Text := 'EXECUTE PROCEDURE SynonymDeleteFormHeaders'; ExecQuery;
	Progress := 60;
	Synchronize( SetProgress);
	TotalProgress := 75;
	Synchronize( SetTotalProgress);

	{ Блок интеграции прайс листов }
{
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
}

  DM.MainConnection1.DefaultUpdateTransaction.Commit;

  DM.MainConnection1.Close;
  DM.MainConnection1.Open;
  DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;

	StatusText := 'Импорт данных';
	Synchronize( SetStatus);

  DM.adtParams.CloseOpen(True);
	if DM.adtParams.FieldByName( 'OperateFormsSet').AsBoolean then
	begin
		SQL.Text := 'EXECUTE PROCEDURE SynonymInsertFormHeaders'; ExecQuery;
		Progress := 70;
		Synchronize( SetProgress);
		SQL.Text := 'EXECUTE PROCEDURE CoreInsertFormHeaders'; ExecQuery;
		Progress := 80;
		Synchronize( SetProgress);
	end;

  SQL.Text:='update params set OperateForms = OperateFormsSet where ID = 0'; ExecQuery;
{
	DM.adtParams.Edit;
	DM.adtParams.FieldByName( 'OperateForms').AsBoolean :=
		DM.adtParams.FieldByName( 'OperateFormsSet').AsBoolean;
	DM.adtParams.Post;
}  

	TotalProgress := 80;
	Synchronize( SetTotalProgress);

	{ Добавляем забракованые препараты }
	if utRejects in UpdateTables then
	begin
		SQL.Text:='EXECUTE PROCEDURE DefectivesInsert'; ExecQuery;
	end;
	{ Добавляем реестр }
	if utRegistry in UpdateTables then
	begin
		SQL.Text := 'EXECUTE PROCEDURE RegistryInsert'; ExecQuery;
	end;

	DM.adtClients.CloseOpen(True);
	//проставляем мин. цены и лидеров
	SQL.Text := 'EXECUTE PROCEDURE MinPricesInsert(' +
		DM.adtClients.FieldByName( 'LeadFromBasic').AsString + ')';
	ExecQuery;
	if utMinPrices in UpdateTables then
	begin
    UpdateFromFile(ExePath+SDirIn+'\MinPrices.txt',
      'update minprices set servercoreid = :servercoreid where fullcode = :fullcode and regioncode = :regioncode');
  end;
	Progress := 90;
	Synchronize( SetProgress);
	TotalProgress := 85;
	Synchronize( SetTotalProgress);
	SQL.Text := 'EXECUTE PROCEDURE MinPricesSetPriceCode(' +
		DM.adtClients.FieldByName( 'LeadFromBasic').AsString + ')';
	ExecQuery;
	SQL.Text := 'EXECUTE PROCEDURE SETPRICESIZE';
	ExecQuery;
  DM.MainConnection1.DefaultUpdateTransaction.CommitRetaining;
  //DM.MainConnection1.DefaultTransaction.StartTransaction;
	SQL.Text := 'EXECUTE PROCEDURE UPDATEALLINDICES';
	ExecQuery;
//  DM.MainConnection1.DefaultTransaction.CommitRetaining;
  DM.MainConnection1.DefaultUpdateTransaction.Commit;

  DM.MainConnection1.Close;
  DM.MainConnection1.Open;
  DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;
	SQL.Text := 'select count(*) from MinPrices where Pricecode is not null';
	ExecQuery;
  Close;
	SQL.Text := 'select count(*) from Core where FullCode is not null';
	ExecQuery;
  Close;
	SQL.Text := 'select count(*) from PricesData where PriceFileDate is not null';
	ExecQuery;
  Close;
	Progress := 100;
	Synchronize( SetProgress);
	TotalProgress := 90;
	Synchronize( SetTotalProgress);
//  DM.MainConnection1.DefaultTransaction.CommitRetaining;
    end;

  except
//    DM.MainConnection1.DefaultTransaction.Rollback;
    raise;
  end;
  finally
  DM.adcUpdate.BeforeExecute := nil;
  DM.adcUpdate.AfterExecute := nil;
	Tables.Free;
  end;

  DM.MainConnection1.Close;
  DM.MainConnection1.Open;
  if not DM.MainConnection1.DefaultTransaction.Active then
    Dm.MainConnection1.DefaultTransaction.StartTransaction;
	DM.UnLinkExternalTables;
	DM.ClearBackup( ExePath);
  Dm.MainConnection1.AfterConnect(nil);
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

procedure TExchangeThread.GetWinVersion(var ANumber, ADesc: String);
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    with OSVersionInfo do
    begin
      if dwPlatformId = VER_PLATFORM_WIN32_WINDOWS then
        dwBuildNumber := dwBuildNumber and $FFFF
      else
        dwBuildNumber := dwBuildNumber;
      ANumber := Format('%d.%d.%d_%d', [dwMajorVersion, dwMinorVersion, dwBuildNumber, dwPlatformId]);
      ADesc := szCSDVersion;
    end
  else begin
    ANumber := '';
    ADesc := '';
  end;
end;

procedure TExchangeThread.GetJETMDACVersions(var AJETVersion, AJETDesc,
  AMDACVersion, AMDACDesc: String);
const
  JETVersions : array[0..8, 0..1] of String = (
    ('4.0.2927.4', 'Пакет обновления 3 (SP3)'),
    ('4.0.3714.7', 'Пакет обновления 4 (SP4)'),
    ('4.0.4431.1', 'Пакет обновления 5 (SP5)'),
    ('4.0.4431.3', 'Пакет обновления 5 (SP5)'),
    ('4.0.6218.0', 'Пакет обновления 6 (SP6)'),
    ('4.0.6807.0', 'Пакет обновления 6 (SP6), поставляется только с Windows Server 2003'),
    ('4.0.7328.0', 'Пакет обновления 7 (SP7)'),
    ('4.0.8015.0', 'Пакет обновления 8 (SP8)'),
    ('4.0.8618.0', 'Пакет обновления 8 (SP8) c бюллетенем по безопасности MS04-014')
  );

  MDACVersions : array[0..13, 0..1] of String = (
    ('2.10.4202.0', 'MDAC 2.1 SP2'),
    ('2.50.4403.6', 'MDAC 2.5'),
    ('2.51.5303.2', 'MDAC 2.5 SP1'),
    ('2.52.6019.0', 'MDAC 2.5 SP2'),
    ('2.53.6200.0', 'MDAC 2.5 SP3'),
    ('2.60.6526.0', 'MDAC 2.6 RTM'),
    ('2.61.7326.0', 'MDAC 2.6 SP1'),
    ('2.62.7926.0', 'MDAC 2.6 SP2'),
    ('2.62.7400.0', 'MDAC 2.6 SP2 Refresh'),
    ('2.70.7713.0', 'MDAC 2.7 RTM'),
    ('2.70.9001.0', 'MDAC 2.7 Refresh'),
    ('2.71.9030.0', 'MDAC 2.7 SP1'),
    ('2.80.1022.0', 'MDAC 2.8 RTM'),
    ('2.81.1117.0', 'MDAC 2.8 SP1 on Windows XP SP2')
  );

var
  I : Integer;
  Found : Boolean;
begin
  AJETVersion := '';
  AJETDesc := '';
  AMDACVersion := '';
  AMDACDesc := '';
  try
  AJETVersion := GetLibraryVersionByName('Msjet40.dll');
  if Length(AJETVersion) = 0 then
    AJETVersion := 'JET не установлен'
  else begin
    if AnsiCompareStr(AJETVersion, JETVersions[0, 0]) < 0 then begin
      AJETVersion := AJETVersion;
      AJETDesc := 'Ниже чем ' + JETVersions[0, 1];
    end
    else
      if AnsiCompareStr(AJETVersion, JETVersions[8, 0]) > 0 then begin
        AJETVersion := AJETVersion;
        AJETDesc := 'Выше чем ' + JETVersions[8, 1];
      end
      else begin
        Found := False;
        for I := 0 to 8 do
          if AnsiCompareStr(AJETVersion, JETVersions[i, 0]) = 0 then begin
            Found := True;
            AJETVersion := AJETVersion;
            AJETDesc := JETVersions[i, 1];
            Break;
          end;
        if not Found then begin
          AJETVersion := AJETVersion;
          AJETDesc := 'Версия не установлена';
        end;
      end;
  end;

  //Проверить MDDAC с помощью MSDASQL.DLL
  AMDACVersion := GetLibraryVersionFromPath(ReplaceMacros('$(COMMONFILES)\system\ole db\') + 'MSDASQL.DLL');
  if Length(AMDACVersion) = 0 then
    AMDACVersion := 'MDAC не установлен'
  else begin
    if AnsiCompareStr(AMDACVersion, MDACVersions[0, 0]) < 0 then begin
      AMDACDesc := 'Ниже чем ' + MDACVersions[0, 1];
    end
    else
      if AnsiCompareStr(AMDACVersion, MDACVersions[High(MDACVersions), 0]) > 0 then begin
        AMDACDesc := 'Выше чем ' + MDACVersions[High(MDACVersions), 1];
      end
      else begin
        Found := False;
        for I := 0 to High(MDACVersions) do
          if AnsiCompareStr(AMDACVersion, MDACVersions[i, 0]) = 0 then begin
            Found := True;
            AMDACDesc := MDACVersions[i, 1];
            Break;
          end;
        if not Found then begin
          AMDACDesc := 'Версия не установлена';
        end;
      end;
  end;
  except
  end;
end;

function TExchangeThread.GetLibraryVersionByName(AName: String): String;
var
  hLib : THandle;
  FileName : String;
begin
  Result := '';
  hLib := LoadLibraryEx(PChar(AName), 0, 0);
  if hLib <> 0 then begin
    try
      FileName := GetModuleName(hLib);
      Result := GetLibraryVersionFromPath(FileName);
    finally
      FreeLibrary(hLib);
    end;
  end;
end;

function TExchangeThread.GetLibraryVersionFromPath(AName: String): String;
var
  RxVer : TVersionInfo;
begin
  if FileExists(AName) then begin
    RxVer := TVersionInfo.Create(AName);
    try
      Result := LongVersionToString(RxVer.FileLongVersion);
    finally
      RxVer.Free;
    end;
  end
  else
    Result := '';
end;

procedure TExchangeThread.adcUpdateBeforeExecute(Sender: TObject);
begin
  Tracer.TR('Import', 'Exec : ' + TpFIBQuery(Sender).SQL.Text);
  StartExec := Now;
end;

procedure TExchangeThread.adcUpdateAfterExecute(Sender: TObject);
var
  StopExec : TDateTime;
  Secs : Int64;
begin
  StopExec := Now;
  Secs := SecondsBetween(StopExec, StartExec);
  if Secs > 3 then
    Tracer.TR('Import', 'ExcecTime : ' + IntToStr(Secs));
end;

destructor TExchangeThread.Destroy;
begin
  if Assigned(AbsentPriceCodeSL) then
    AbsentPriceCodeSL.Free;
  inherited;
end;

procedure TExchangeThread.GetAbsentPriceCode;
begin
  try
    //Tracer.TR('test', 'Before');
    DM.t.ExecQuery;
    try
      //Tracer.TR('test', 'In');
      if DM.t.RecordCount > 0 then begin
        AbsentPriceCodeSL := TStringList.Create;
        while not DM.t.Eof do begin
          AbsentPriceCodeSL.Add(DM.t.FieldByName('PRICECODE').AsString);
          DM.t.Next;
        end;
      end;
    finally
      DM.t.Close;
      //Tracer.TR('test', 'After');
    end;
  except
    on E : Exception do
      //Tracer.TR('test', E.Message);
  end;
end;

procedure TExchangeThread.UpdateFromFile(FileName, InsertSQL: String; OnBatching : TOnBatching = nil);
var
  up : TpFIBQuery;
  InDelimitedFile : TFIBInputDelimitedFile;
begin
  up := TpFIBQuery.Create(nil);
  try
    up.Database := DM.MainConnection1;
    up.Transaction := DM.UpTran;
    upB := up;

    InDelimitedFile := TFIBInputDelimitedFile.Create;
    try
      InDelimitedFile.SkipTitles := False;
      InDelimitedFile.ReadBlanksAsNull := False;
      InDelimitedFile.ColDelimiter := Chr(159);
      InDelimitedFile.RowDelimiter := Chr(161);

      up.SQL.Text := InsertSQL;
      InDelimitedFile.Filename := FileName;
      up.OnBatching := OnBatching;

      up.BatchInput(InDelimitedFile);

    finally
      InDelimitedFile.Free;
    end;

  finally
    upB := nil;
    up.Free;
  end;
end;

procedure TExchangeThread.GetPass;
var
  Res : TStrings;
  Error : String;
begin
  CriticalError := True;
  Res := SOAP.Invoke( 'GetPasswords', ['UniqueID'], [IntToHex( GetCopyID, 8)]);
  Error := Utf8ToAnsi( Res.Values[ 'Error']);
  if Error <> '' then
    raise Exception.Create( Error + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));
  ASynPass := Res.Values['Synonym'];
  ACodesPass := Res.Values['Codes'];
  ABPass := Res.Values['BaseCost'];
  Synchronize(DMSavePass);
  CriticalError := False;
end;

procedure TExchangeThread.DMSavePass;
begin
  DM.SavePass(ASynPass, ACodesPass, ABPass);
end;

procedure TExchangeThread.PriceDataSettings;
const
  StaticParamCount : Integer = 1;
var
	Res: TStrings;
  Error : String;
  ParamNames, ParamValues : array of String;
  I : Integer;
begin
  CriticalError := True;
 	DM.adsPrices.Close;
	DM.adsPrices.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').Value;
	DM.adsPrices.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	DM.adsPrices.Open;
	if not DM.adsPrices.Eof then
	begin
		StatusText := 'Отправка настроек прайс-листов';
		Synchronize( SetStatus);
    SetLength(ParamNames, StaticParamCount + DM.adsPrices.RecordCountFromSrv*4);
    SetLength(ParamValues, StaticParamCount + DM.adsPrices.RecordCountFromSrv*4);
    ParamNames[0] := 'UniqueID';
    ParamValues[0] := IntToHex( GetCopyID, 8);
	end;
  I := 0;
  while not DM.adsPrices.Eof do begin
    //PriceCodes As Int32(), ByVal RegionCodes As Int32(), ByVal INJobs As Boolean(), ByVal UpCosts
    ParamNames[StaticParamCount+i*4] := 'PriceCodes';
    ParamValues[StaticParamCount+i*4] := DM.adsPrices.FieldByName('PriceCode').AsString;
    ParamNames[StaticParamCount+i*4+1] := 'RegionCodes';
    ParamValues[StaticParamCount+i*4+1] := DM.adsPrices.FieldByName('RegionCode').AsString;
    ParamNames[StaticParamCount+i*4+2] := 'INJobs';
    ParamValues[StaticParamCount+i*4+2] := BoolToStr(DM.adsPrices.FieldByName('INJob').AsBoolean, True);
    ParamNames[StaticParamCount+i*4+3] := 'UpCosts';
    ParamValues[StaticParamCount+i*4+3] :=
      StringReplace(DM.adsPrices.FieldByName('UPCOST').AsString, DM.FFS.DecimalSeparator, ',', [rfReplaceAll]);
    DM.adsPrices.Next;
    Inc(i);
  end;
  DM.adsPrices.Close;
  Res := SOAP.Invoke( 'PostPriceDataSettings', ParamNames, ParamValues);
  Error := Utf8ToAnsi( Res.Values[ 'Error']);
  if Error <> '' then
    raise Exception.Create( Error + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));
  CriticalError := False;
end;

initialization
finalization
  UnloadSevenZipDLL;
end.
