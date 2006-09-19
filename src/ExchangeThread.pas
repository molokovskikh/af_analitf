unit ExchangeThread;

interface

uses
	Classes, SysUtils, Windows, StrUtils, ComObj, Variants, XSBuiltIns,
	SOAPThroughHTTP, DateUtils, ShellAPI, ExtCtrls, RecThread, ActiveX,
  IdException, WinSock, RxVerInf, DB, pFIBQuery, pFIBDatabase, FIBMiscellaneous,
  FIBQuery, ibase, U_TINFIBInputDelimitedStream, VCLUnZip, SevenZip,
  IdStackConsts, infvercls, Contnrs, IdHashMessageDigest,
  DADAuthenticationNTLM, IdComponent, IdHTTP, FIB;

const
  UpadateErrorText = 'Вероятно, предыдущая операция импорта не была завершена.';
  //Критические сообщения об ошибках при отправке заказов
  SendOrdersErrorTexts : array[0..3] of string =
  ('Доступ запрещен.',
   'Программа была зарегистрирована на другом компьютере.',
   'Отправка заказов для данного клиента запрещена.',
   'Отправка заказов завершилась неудачно.');

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
  utMinPrices,
  utPriceAVG,
  utCatalogFarmGroups,
  utCatFarmGroupsDEL,
  utCatalogNames);

TUpdateTables = set of TUpdateTable;

TFileUpdateInfo = class
 public
  FileName, Version, MD5 : String;
  constructor Create(AFileName, AVersion, AMD5 : String);
end;

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
  URL : String;
  HTTPName,
  HTTPPass : String;
  StartDownPosition : Integer;

  upB : TpFIBQuery;
  //Будем обновляться из-за того, что дата обновления не совпала
  UpdateByUpdate : Boolean;

	procedure SetStatus;
  procedure SetDownStatus;
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

  procedure UpdateFromFile(
    FileName,
    InsertSQL : String;
    OnBatching : TOnBatching = nil;
    OnExecuteError : TFIBQueryErrorEvent = nil);

	function GetXMLDateTime( ADateTime: TDateTime): string;
	function FromXMLToDateTime( AStr: string): TDateTime;
	function StringToCodes( AStr: string): string;
	function RusError( AStr: string): string;
  procedure OnConnectError (AMessage : String);
  procedure OnReclameTerminate(Sender: TObject);
  function  GetLibraryVersion : TObjectList;
  procedure GetWinVersion(var ANumber, ADesc : String);
  function GetLibraryVersionByName(AName: String): String;
  function GetLibraryVersionFromPath(AName: String): String;
  procedure adcUpdateBeforeExecute(Sender: TObject);
  procedure adcUpdateAfterExecute(Sender: TObject);
  function GetFileHash(AFileName: String): String;
  //"Молчаливое" выполнение запроса изменения метаданных.
  //Не вызывает исключение в случае ошибки -607
  procedure SilentExecute(q : TpFIBQuery; SQL : String);
  procedure HTTPWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
  procedure ThreadOnBatching(BatchOperation:TBatchOperation;RecNumber:integer;var BatchAction:TBatchAction);
  procedure ThreadOnExecuteError(pFIBQuery:TpFIBQuery; E:EFIBError; var Action:TDataAction);
protected
	procedure Execute; override;
public
  destructor Destroy; override;
end;

implementation

uses Exchange, DModule, AProc, Main, Retry, Integr, Exclusive, ExternalOrders,
  U_FolderMacros, LU_Tracer, FIBDatabase, FIBDataSet, Math, DBProc;

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
    CoInitialize(nil);
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
					GetReclame;
          UpdateByUpdate := False;
					QueryData;
          if UpdateByUpdate then
            QueryData;
          GetPass;
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
				if ErrorMessage = '' then
          ErrorMessage := E.ClassName + ': ' + E.Message;
			end;
		end;
    finally
      CoUninitialize;
    end;
	except
		on E: Exception do ErrorMessage := E.Message;
	end;
	Synchronize( EnableCancel);
	Terminated := True;
end;

procedure TExchangeThread.HTTPConnect;
begin
	{ создаем экземпляр класса TSOAP для работы с SOAP через HTTP вручную }
	URL := 'https://' + ExtractURL( DM.adtParams.FieldByName( 'HTTPHost').AsString) +
		'/' + DM.SerBeg + DM.SerEnd + '/code.asmx';
  HTTPName := DM.adtParams.FieldByName( 'HTTPName').AsString;
  HTTPPass := DM.D_HP( DM.adtParams.FieldByName( 'HTTPPass').AsString );
	SOAP := TSOAP.Create( URL, HTTPName, HTTPPass, OnConnectError, ExchangeForm.HTTP);
end;

procedure TExchangeThread.GetReclame;
begin
	RecThread := TReclameThread.Create( True);
	RecThread.RegionCode := DM.adtClients.FieldByName( 'RegionCode').AsString;
  RecThread.ReclameURL := URL;
  RecThread.HTTPName := HTTPName;
  RecThread.HTTPPass := HTTPPass;
	RecThread.Resume;
end;

procedure TExchangeThread.QueryData;
const
  StaticParamCount : Integer = 7;
var
	Res: TStrings;
	LibVersions: TObjectList;
  Error : String;
  ParamNames, ParamValues : array of String;
  I : Integer;
  WinNumber, WinDesc : String;
  fi : TFileUpdateInfo;
begin
	{ запрашиваем данные }
	StatusText := 'Запрос данных';
	Synchronize( SetStatus);
	try
    LibVersions := GetLibraryVersion;
    try
      SetLength(ParamNames, StaticParamCount + LibVersions.Count*3);
      SetLength(ParamValues, StaticParamCount + LibVersions.Count*3);
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

      for I := 0 to LibVersions.Count-1 do begin
        fi := TFileUpdateInfo(LibVersions[i]);
        ParamNames[StaticParamCount+i*3] := 'LibraryName';
        ParamValues[StaticParamCount+i*3] := fi.FileName;
        ParamNames[StaticParamCount+i*3+1] := 'LibraryVersion';
        ParamValues[StaticParamCount+i*3+1] := fi.Version;
        ParamNames[StaticParamCount+i*3+2] := 'LibraryHash';
        ParamValues[StaticParamCount+i*3+2] := fi.MD5;
      end;
    finally
      LibVersions.Free;
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
    //Если получили специфичное сообщение об ошибке, что
    if (Error <> '') and AnsiStartsText(UpadateErrorText, Utf8ToAnsi( Res.Values[ 'Desc'])) then begin
      UpdateByUpdate := True;
      ExchangeForm.ExchangeActs := ExchangeForm.ExchangeActs + [eaGetFullData];
    end
    else begin
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
      LocalFileName := ExePath + SDirIn + '\UpdateData.zip';
    end;
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
const
  FReconnectCount = 10;
var
  OldReconnectCount : Integer;
  ErrorCount : Integer;
  PostSuccess : Boolean;
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
			if FileStream.Size > 1024 then
        FileStream.Seek( -1024, soFromEnd)
      else
        FileStream.Seek( 0, soFromEnd);
		end
		else
			FileStream := TFileStream.Create( LocalFileName, fmCreate);

    try
      if AnsiStartsText('https', HostFileName) then
        HostFileName := StringReplace(HostFileName, 'https', 'http', [rfIgnoreCase]);
      ExchangeForm.HTTP.Disconnect;
    except
    end;

		try
      OldReconnectCount := ExchangeForm.HTTP.ReconnectCount;
      ExchangeForm.HTTP.OnWork := HTTPWork;
      ExchangeForm.HTTP.ReconnectCount := 0;
      ExchangeForm.HTTP.Request.BasicAuthentication := True;
      //ExchangeForm.HTTP.Request.Authentication := TDADNTLMAuthentication.Create;
//      if not AnsiStartsText('analit\', HTTPName) then
//        ExchangeForm.HTTP.Request.Username := 'ANALIT\' + HTTPName;
      Progress := 0;
      Synchronize( SetProgress );

      try

        ErrorCount := 0;
        PostSuccess := False;
        repeat
          try

            if FileStream.Size > 1024 then
              FileStream.Seek( -1024, soFromEnd)
            else
              FileStream.Seek( 0, soFromEnd);

            StartDownPosition := FileStream.Position;

            ExchangeForm.HTTP.Get( HostFileName +
              IfThen(FileStream.Position > 0, '?RangeStart=' + IntToStr(FileStream.Position), ''),
              FileStream);
            Writeln(ExchangeForm.LogFile, 'Recieve file : ' + IntToStr(FileStream.Size));
            PostSuccess := True;

          except
            on E : EIdConnClosedGracefully do begin
              if (ErrorCount < FReconnectCount) then begin
                if ExchangeForm.HTTP.Connected then
                try
                  ExchangeForm.HTTP.Disconnect;
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
                if ExchangeForm.HTTP.Connected then
                try
                  ExchangeForm.HTTP.Disconnect;
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
        ExchangeForm.HTTP.ReconnectCount := OldReconnectCount;
        ExchangeForm.HTTP.OnWork := nil;
        ExchangeForm.HTTP.Request.Username := HTTPName;
        ExchangeForm.HTTP.Request.BasicAuthentication := True;
{
        try
          ExchangeForm.HTTP.Request.Authentication.Free;
        except
        end;
        ExchangeForm.HTTP.Request.Authentication := nil;
}        
      end;

			Synchronize( ExchangeForm.CheckStop);
		finally
      try
        ExchangeForm.HTTP.Disconnect;
      except
      end;

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
const
  OrderParamCount : Integer = 15;
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
		SetLength( params, 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount + 1);
		SetLength( values, 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount + 1);

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
			params[ i * OrderParamCount + 6] := 'FullCode';
			params[ i * OrderParamCount + 7] := 'OrderId';
			params[ i * OrderParamCount + 8] := 'CodeFirmCr';
			params[ i * OrderParamCount + 9] := 'SynonymCode';
			params[ i * OrderParamCount + 10] := 'SynonymFirmCrCode';
			params[ i * OrderParamCount + 11] := 'Code';
			params[ i * OrderParamCount + 12] := 'CodeCr';
			params[ i * OrderParamCount + 13] := 'Quantity';
			params[ i * OrderParamCount + 14] := 'Junk';
			params[ i * OrderParamCount + 15] := 'Await';
			params[ i * OrderParamCount + 16] := 'Cost';
			values[ i * OrderParamCount + 6] := DM.adsOrders.FieldByName( 'FullCode').AsString;
			values[ i * OrderParamCount + 7] := DM.adsOrders.FieldByName( 'OrderId').AsString;
			values[ i * OrderParamCount + 8] := DM.adsOrders.FieldByName( 'CodeFirmCr').AsString;
			values[ i * OrderParamCount + 9] := DM.adsOrders.FieldByName( 'SynonymCode').AsString;
			values[ i * OrderParamCount + 10] := DM.adsOrders.FieldByName( 'SynonymFirmCrCode').AsString;
      values[ i * OrderParamCount + 11] := DM.adsOrders.FieldByName( 'Code').AsString;
      values[ i * OrderParamCount + 12] := DM.adsOrders.FieldByName( 'CodeCr').AsString;
			values[ i * OrderParamCount + 13] := DM.adsOrders.FieldByName( 'Ordercount').AsString;
			values[ i * OrderParamCount + 14] := BoolToStr( DM.adsOrders.FieldByName( 'Junk').AsBoolean, True);
			values[ i * OrderParamCount + 15] := BoolToStr( DM.adsOrders.FieldByName( 'Await').AsBoolean, True);
      try
        S := DM.D_B_N(DM.adsOrders.FieldByName( 'PRICE').AsString);
        S := StringReplace(S, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
        values[ i * OrderParamCount + 16] := S;
      except
        values[ i * OrderParamCount + 16] := '0.0';
      end;

			params[ i * OrderParamCount + 17] := 'MinCost';
			params[ i * OrderParamCount + 18] := 'MinPriceCode';
			params[ i * OrderParamCount + 19] := 'LeaderMinCost';
			params[ i * OrderParamCount + 20] := 'LeaderMinPriceCode';

      //Если выставлено поле - рассчитывать лидеров,
      if DM.adtClientsCALCULATELEADER.Value then begin
      
        if DM.adsOrderCore.Active then
          DM.adsOrderCore.Close();

        DM.adsOrderCore.ParamByName( 'RegisterId').Value := RegisterId;
        DM.adsOrderCore.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
        DM.adsOrderCore.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
        DM.adsOrderCore.ParamByName( 'ParentCode').Value := DM.adsOrders.FieldByName( 'FullCode').Value;
        DM.adsOrderCore.ParamByName( 'ShowRegister').Value := False;
        DM.adsOrderCore.Open;
        DM.adsOrderCore.FetchAll;
        DM.adsOrderCore.DoSort(['CryptBaseCost'], [True]);
        DM.adsOrderCore.DoSort(['CryptBaseCost'], [True]);

        //Выбираем минимального из всех прайсов
        DBProc.SetFilter(DM.adsOrderCore, 'JUNK = ' + DM.adsOrders.FieldByName( 'Junk').AsString);

        DM.adsOrderCore.First;

        try
          S := DM.D_B_N(DM.adsOrderCoreBASECOST.AsString);
          S := StringReplace(S, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
          values[ i * OrderParamCount + 17] := S;
        except
          values[ i * OrderParamCount + 17] := '0.0';
        end;
        values[ i * OrderParamCount + 18] := DM.adsOrderCorePRICECODE.AsString;

        //Выбираем минимального из основных прайсов
        DBProc.SetFilter(DM.adsOrderCore, 'JUNK = ' + DM.adsOrders.FieldByName( 'Junk').AsString + ' and PriceEnabled = True');

        DM.adsOrderCore.First;
        
        //В основных прайс-листах может не быть предложений
        if not DM.adsOrderCore.IsEmpty then begin
          try
            S := DM.D_B_N(DM.adsOrderCoreBASECOST.AsString);
            S := StringReplace(S, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
            values[ i * OrderParamCount + 19] := S;
          except
            values[ i * OrderParamCount + 19] := '0.0';
          end;
          values[ i * OrderParamCount + 20] := DM.adsOrderCorePRICECODE.AsString;
        end
        else begin
          values[ i * OrderParamCount + 19] := '';
          values[ i * OrderParamCount + 20] := '';
        end;

        DM.adsOrderCore.Close;
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
      params[ 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount ] := 'UniqueID';
      values[ 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount ] := IntToHex( GetCopyID, 8);
			Res := Soap.Invoke( 'PostOrder1', params, values);
			// проверяем отсутствие ошибки при удаленном запросе
			ResError := Utf8ToAnsi( Res.Values[ 'Error']);
			if ResError <> '' then begin
        if AnsiIndexText(ResError, SendOrdersErrorTexts) = -1 then begin
          SendError := True;
          ExchangeForm.SendOrdersLog.Add(
            Format('Заказ по прайс-листу %s (%s) не был отправлен. Причина : %s',
              [DM.adsOrdersH.FieldByName( 'PriceName').AsString,
               DM.adsOrdersH.FieldByName( 'RegionName').AsString,
              ResError])
          );
        end
        else
				  raise Exception.Create( ResError + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));
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
	SR, DeleteSR, ExportsSR: TSearchRec;
  SevenZipRes : Integer;
  I : Integer;
  DeletedText, NewImportFileName : String;
  FoundDeletedText : Boolean;
  FoundIndex : Integer;
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
}
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
        SZCS.Enter;
        try
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
        finally
          SZCS.Leave;
        end;

				DeleteFileA( ExePath + SDirIn + '\' + SR.Name);
				DeleteFileA( ExePath + SDirIn + '\' + ChangeFileExt( SR.Name, '.zi_'));
			end;
			Synchronize( ExchangeForm.CheckStop);
		until FindNext( SR) <> 0;
	finally
		SysUtils.FindClose( SR);
		ExchangeForm.UnZip.ZipName := '';
	end;

  //Переименовываем файлы с кодом клиента в файлы без код клиента
  if FindFirst( ExePath + SDirIn + '\*.txt', faAnyFile, DeleteSR) = 0 then
  try

    repeat
      if (DeleteSR.Name <> '.') and (DeleteSR.Name <> '..')
      then begin

        FoundDeletedText := False;
        FoundIndex := -1;
        for I := Length(DeleteSR.Name)-4 downto 1 do
          if not (DeleteSR.Name[i] in ['0'..'9']) then begin
            FoundDeletedText := True;
            FoundIndex := I;
            Break;
          end;

        if (FoundDeletedText) and (FoundIndex < Length(DeleteSR.Name)-4) then begin
          DeletedText := Copy(DeleteSR.Name, FoundIndex + 1, Length(DeleteSR.Name));
          NewImportFileName := StringReplace(DeleteSR.Name, DeletedText, '.txt', []);
          MoveFileA(
            ExePath + SDirIn + '\' + DeleteSR.Name,
            ExePath + SDirIn + '\' + NewImportFileName, True);
        end;

      end;
    until (FindNext( DeleteSR ) <> 0)
    
  finally
    SysUtils.FindClose( DeleteSR );
  end;


  //Обрабатываем папку Exports
  if DirectoryExists(ExePath + SDirIn + '\' + SDirExports) then begin
    if FindFirst( ExePath + SDirIn + '\' + SDirExports + '\*.*', faAnyFile, ExportsSR) = 0 then
    try
      repeat
        if (ExportsSR.Name <> '.') and (ExportsSR.Name <> '..') then
          MoveFileA(
            ExePath + SDirIn + '\' + SDirExports + '\' + ExportsSR.Name,
            ExePath + SDirExports + '\' + ExportsSR.Name,
            True);
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

	MessageBox('Получена новая версия программы. Сейчас будет выполнено обновление', MB_OK or MB_ICONWARNING);
	EraserDll := TResourceStream.Create( hInstance, 'ERASER', RT_RCDATA);
	try
		EraserDll.SaveToFile( 'Eraser.dll');
	finally
		EraserDll.Free;
	end;

	ShellExecute( 0, nil, 'rundll32.exe', PChar( ' Eraser.dll,Erase ' + IfThen(SilentMode, '-si ', '-i ') + IntToStr(GetCurrentProcessId) + ' "' +
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
//if Tables.IndexOf( 'EXTSECTION') >= 0 then UpdateTables:=UpdateTables+[utSection];
	if Tables.IndexOf( 'EXTSYNONYM') >= 0 then UpdateTables := UpdateTables + [utSynonym];
	if Tables.IndexOf( 'EXTSYNONYMFIRMCR')>=0 then UpdateTables := UpdateTables + [utSynonymFirmCr];
	if Tables.IndexOf( 'EXTREJECTS')>=0 then UpdateTables := UpdateTables + [utRejects];
//if Tables.IndexOf( 'EXTREGISTRY')>=0 then UpdateTables := UpdateTables + [utRegistry];
	if Tables.IndexOf( 'EXTWAYBILLHEAD')>=0 then UpdateTables := UpdateTables + [utWayBillHead];
	if Tables.IndexOf( 'EXTWAYBILLLIST')>=0 then UpdateTables := UpdateTables + [utWayBillList];
	if Tables.IndexOf( 'EXTMINPRICES')>=0 then UpdateTables := UpdateTables + [utMinPrices];
	if Tables.IndexOf( 'EXTPRICEAVG')>=0 then UpdateTables := UpdateTables + [utPriceAVG];
	if Tables.IndexOf( 'EXTCATALOGFARMGROUPS')>=0 then UpdateTables := UpdateTables + [utCatalogFarmGroups];
	if Tables.IndexOf( 'EXTCATFARMGROUPSDEL')>=0 then UpdateTables := UpdateTables + [utCatFarmGroupsDEL];
	if Tables.IndexOf( 'EXTCATALOGNAMES')>=0 then UpdateTables := UpdateTables + [utCatalogNames];


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
    CatalogFarmGroups       +       +       +
    CatalogNames                    +       +
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
	//Synonym
	if (utSynonym in UpdateTables) and (eaGetFullData in ExchangeForm.ExchangeActs) then begin
    SilentExecute(DM.adcUpdate, 'DROP INDEX IDX_PRICECODE');
    SilentExecute(DM.adcUpdate, 'DROP INDEX IDX_SYNONYMNAME');
    SilentExecute(DM.adcUpdate, 'ALTER TABLE SYNONYMS DROP CONSTRAINT FK_SYNONYMS_FULLCODE');
    SilentExecute(DM.adcUpdate, 'ALTER TABLE SYNONYMS DROP CONSTRAINT PK_SYNONYMS');
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
	// PriceAVG
	if utPriceAVG in UpdateTables then begin
    try
     	SQL.Text := 'drop table PriceAVG;';	ExecQuery;
    except
    end;
   	SQL.Text := 'CREATE TABLE PRICEAVG (CLIENTCODE FB_ID, FULLCODE FB_ID, ORDERPRICEAVG NUMERIC(15,2))';	ExecQuery;
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
	//CatalogNames
	if utCatalogNames in UpdateTables then begin
	  if (eaGetFullData in ExchangeForm.ExchangeActs) then begin
      UpdateFromFile(ExePath+SDirIn+'\CatalogNames.txt',
        'INSERT INTO catalognames ' +
        '(ID, NAME, LATINNAME, Description) '+
        'values ( :ID, :NAME, :LATINNAME, :Description)');
    end
    else begin
      UpdateFromFile(ExePath+SDirIn+'\CatalogNames.txt',
        'EXECUTE PROCEDURE CATALOGNAMES_IU(:ID, :NAME, :LATINNAME, :DESCRIPTION)');
    end;
	end;
	//Catalog
	if utCatalog in UpdateTables then begin

	  if (eaGetFullData in ExchangeForm.ExchangeActs) then begin
      UpdateFromFile(ExePath+SDirIn+'\Catalog.txt',
        'INSERT INTO catalogs ' +
        '(FULLCODE, SHORTCODE, NAME, FORM, VITALLYIMPORTANT, NEEDCOLD, FRAGILE) '+
        'values ( :FULLCODE, :SHORTCODE, :NAME, :FORM, :VITALLYIMPORTANT, :NEEDCOLD, :FRAGILE)');
    end
    else begin
      //catalogs_iu
      UpdateFromFile(ExePath+SDirIn+'\Catalog.txt',
        'EXECUTE PROCEDURE catalogs_iu(:FULLCODE, :SHORTCODE, :NAME, :FORM, :VITALLYIMPORTANT, :NEEDCOLD, :FRAGILE)');
      if utCatDel in UpdateTables then begin
        UpdateFromFile(ExePath+SDirIn+'\CatDel.txt',
          'delete from catalogs where (fullcode = :fullcode)');
      end;
    end;
	  SQL.Text:='EXECUTE PROCEDURE CatalogSetFormNotNull'; ExecQuery;
	end;
	//CatalogFarmGroups
	if utCatalogFarmGroups in UpdateTables then begin
	  if (eaGetFullData in ExchangeForm.ExchangeActs) then begin
      UpdateFromFile(ExePath+SDirIn+'\CatalogFarmGroups.txt',
        'INSERT INTO catalogfarmgroups ' +
        '(ID, Name, Description, ParentID, GroupType) '+
        'values ( :ID, :Name, :Description, :ParentID, :GroupType )');
    end
    else begin
      UpdateFromFile(ExePath+SDirIn+'\CatalogFarmGroups.txt',
        'EXECUTE PROCEDURE catalogfarmgroups_iu(:ID, :NAME, :DESCRIPTION, :PARENTID, :GROUPTYPE)');
      if utCatFarmGroupsDel in UpdateTables then begin
        UpdateFromFile(ExePath+SDirIn+'\CatFarmGroupsDel.txt',
          'delete from catalogfarmgroups where (ID = :ID)');
      end;
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
    UpdateFromFile(ExePath+SDirIn+'\Clients.txt',
        'EXECUTE PROCEDURE CLIENTS_IU(:CLIENTID, :NAME, :REGIONCODE, :EXCESS, :DELTAMODE, :MAXUSERS, :REQMASK, :TECHSUPPORT, :CALCULATELEADER)');
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
	  if (eaGetFullData in ExchangeForm.ExchangeActs) then begin
      UpdateFromFile(ExePath+SDirIn+'\Synonym.txt',
        'INSERT INTO Synonyms ' +
        '(Synonymcode, Synonymname, fullcode, shortcode, pricecode) '+
        'values (:Synonymcode, :Synonymname, :fullcode, :shortcode, :pricecode )');
  	  SQL.Text:='ALTER TABLE SYNONYMS ADD CONSTRAINT PK_SYNONYMS PRIMARY KEY (SYNONYMCODE)'; ExecQuery;
  	  SQL.Text:='ALTER TABLE SYNONYMS ADD CONSTRAINT FK_SYNONYMS_FULLCODE FOREIGN KEY (FULLCODE) REFERENCES CATALOGS (FULLCODE) ON DELETE CASCADE ON UPDATE CASCADE'; ExecQuery;
  	  SQL.Text:='CREATE INDEX IDX_PRICECODE ON SYNONYMS (PRICECODE)'; ExecQuery;
  	  SQL.Text:='CREATE INDEX IDX_SYNONYMNAME ON SYNONYMS (SYNONYMNAME)'; ExecQuery;
    end
    else begin
      UpdateFromFile(ExePath+SDirIn+'\Synonym.txt',
        'INSERT INTO Synonyms ' +
        '(Synonymcode, Synonymname, fullcode, shortcode, pricecode) '+
        'SELECT :Synonymcode, :Synonymname, :fullcode, :shortcode, :pricecode '+
        'FROM rdb$database '+
        'WHERE Not Exists(SELECT SynonymCode FROM Synonyms WHERE SynonymCode=:Synonymcode)');
    end;
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
    SilentExecute(DM.adcUpdate, 'alter table core DROP CONSTRAINT FK_CORE_FULLCODE');
    SilentExecute(DM.adcUpdate, 'alter table core DROP CONSTRAINT FK_CORE_PRICECODE');
    SilentExecute(DM.adcUpdate, 'alter table core DROP CONSTRAINT FK_CORE_REGIONCODE');
    SilentExecute(DM.adcUpdate, 'alter table core DROP CONSTRAINT PK_CORE');
    SilentExecute(DM.adcUpdate, 'drop index FK_CORE_SYNONYMCODE');
    SilentExecute(DM.adcUpdate, 'drop index FK_CORE_SYNONYMFIRMCRCODE');
    SilentExecute(DM.adcUpdate, 'drop index IDX_CORE_SERVERCOREID');
    SilentExecute(DM.adcUpdate, 'drop index IDX_CORE_JUNK');
    DM.MainConnection1.DefaultUpdateTransaction.Commit;

    DM.MainConnection1.Close;
    DM.MainConnection1.Open;
    DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;
    UpdateFromFile(ExePath+SDirIn+'\Core.txt',
'INSERT INTO Core '+
'(Pricecode, RegionCode, FullCode, CodeFirmCr, SynonymCode, SynonymFirmCrCode,' +
'Code, CodeCr, Unit, Volume, Junk, Await, Quantity, Note, Period, Doc, RegistryCost, VitallyImportant, RequestRatio, BaseCost, ServerCOREID)' +
'values (:Pricecode, :RegionCode, :FullCode, :CodeFirmCr, :SynonymCode, ' +
':SynonymFirmCrCode, :Code, :CodeCr, :Unit, :Volume, :Junk, :Await, :Quantity, ' +
':Note, :Period, :Doc, :RegistryCost, :VitallyImportant, :RequestRatio, :BaseCost, :ServerCOREID)');
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT PK_CORE PRIMARY KEY (COREID)'; ExecQuery;
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT FK_CORE_FULLCODE FOREIGN KEY (FULLCODE) REFERENCES CATALOGS (FULLCODE) ON DELETE CASCADE ON UPDATE CASCADE'; ExecQuery;
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT FK_CORE_PRICECODE FOREIGN KEY (PRICECODE) REFERENCES PRICESDATA (PRICECODE) ON DELETE CASCADE ON UPDATE CASCADE'; ExecQuery;
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT FK_CORE_REGIONCODE FOREIGN KEY (REGIONCODE) REFERENCES REGIONS (REGIONCODE) ON UPDATE CASCADE'; ExecQuery;
	  SQL.Text:='CREATE INDEX IDX_CORE_JUNK ON CORE (FULLCODE, JUNK)'; ExecQuery;
	  SQL.Text:='CREATE INDEX IDX_CORE_SERVERCOREID ON CORE (SERVERCOREID)'; ExecQuery;
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
	//проставляем мин. цены и лидеров
	SQL.Text := 'EXECUTE PROCEDURE MinPricesInsert';	ExecQuery;
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

	SQL.Text := 'update catalogs set CoreExists = 0 where FullCode > 0'; ExecQuery;
	SQL.Text := 'update catalogs set CoreExists = 1 where FullCode > 0 and exists(select * from core c where c.Fullcode = catalogs.fullcode)'; ExecQuery;
	Progress := 65;
	Synchronize( SetProgress);
  DM.adtParams.CloseOpen(True);
	if DM.adtParams.FieldByName( 'OperateFormsSet').AsBoolean then
	begin
		Progress := 70;
		Synchronize( SetProgress);
		SQL.Text := 'EXECUTE PROCEDURE CoreInsertFormHeaders'; ExecQuery;
		Progress := 80;
		Synchronize( SetProgress);
	end;

  SQL.Text:='update params set OperateForms = OperateFormsSet where ID = 0'; ExecQuery;

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
	if utMinPrices in UpdateTables then
	begin
    UpdateFromFile(ExePath+SDirIn+'\MinPrices.txt',
      'update minprices set servercoreid = :servercoreid where fullcode = :fullcode and regioncode = :regioncode');
  end;

	if utPriceAVG in UpdateTables then
	begin
    UpdateFromFile(ExePath+SDirIn+'\PriceAVG.txt',
      'insert into PriceAVG (ClientCode, fullcode, OrderPriceAVG) values (:ClientCode, :fullcode, :OrderPriceAVG)');
   	SQL.Text := 'ALTER TABLE PRICEAVG ADD CONSTRAINT PK_PRICEAVG PRIMARY KEY (CLIENTCODE, FULLCODE)';	ExecQuery;
  end;
	Progress := 90;
	Synchronize( SetProgress);
	TotalProgress := 85;
	Synchronize( SetTotalProgress);
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

function TExchangeThread.GetLibraryVersion: TObjectList;
var
  DirPath : String;

  function IsExeFile(Name : String) : Boolean;
  begin
    Result := AnsiEndsText('.exe', Name) or AnsiEndsText('.bpl', Name) or AnsiEndsText('.dll', Name); 
  end;

  procedure FindVersionsEx(StartDir : String; Res : TObjectList);
  var
    sr : TSearchRec;
    FName, FVersion, FHash : String;
  begin
    if SysUtils.FindFirst(StartDir + '*.*', faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then begin
          if sr.Attr and faDirectory > 0 then begin
            FindVersionsEx(StartDir + sr.Name + '\', Res);
          end
          else
            if IsExeFile(sr.Name) then begin
              FName := sr.Name;
              FVersion := GetLibraryVersionFromPath(StartDir + sr.Name);
              FHash := GetFileHash(StartDir + sr.Name);
              Res.Add(TFileUpdateInfo.Create(FName, FVersion, FHash));
            end;
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
  end;

begin
  Result := TObjectList.Create(True);
  try
    DirPath := ExtractFilePath(ParamStr(0));
    FindVersionsEx(DirPath, Result);
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
    try
      RxVer := TVersionInfo.Create(AName);
      try
        Result := LongVersionToString(RxVer.FileLongVersion);
      finally
        RxVer.Free;
      end;
    except
      Result := '';
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

procedure TExchangeThread.UpdateFromFile(
  FileName, InsertSQL: String;
  OnBatching : TOnBatching = nil;
  OnExecuteError : TFIBQueryErrorEvent = nil);
var
  up : TpFIBQuery;
  InDelimitedFile : TFIBInputDelimitedFile;
  StopExec : TDateTime;
  Secs : Int64;
begin
  up := TpFIBQuery.Create(nil);
  try
    up.Database := DM.MainConnection1;
    up.Transaction := DM.UpTran;
    upB := up;

    InDelimitedFile := TFIBInputDelimitedFile.Create;
    try
      InDelimitedFile.SkipTitles := False;
      InDelimitedFile.ReadBlanksAsNull := True;
      InDelimitedFile.ColDelimiter := Chr(159);
      InDelimitedFile.RowDelimiter := Chr(161);

      up.SQL.Text := InsertSQL;
      InDelimitedFile.Filename := FileName;
      up.OnBatching := OnBatching;
      up.OnExecuteError := OnExecuteError;

      Tracer.TR('Import', 'Exec : ' + InsertSQL);
      StartExec := Now;
      try
        up.BatchInput(InDelimitedFile);
      finally
        StopExec := Now;
        Secs := SecondsBetween(StopExec, StartExec);
        if Secs > 3 then
          Tracer.TR('Import', 'ExcecTime : ' + IntToStr(Secs));
      end;

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
  SetString(ASynPass, nil, INFDataLen);
  HexToBin(PChar(Res.Values['Synonym']), PChar(ASynPass), INFDataLen);
  SetString(ACodesPass, nil, INFDataLen);
  HexToBin(PChar(Res.Values['Codes']), PChar(ACodesPass), INFDataLen);
  SetString(ABPass, nil, INFDataLen);
  HexToBin(PChar(Res.Values['BaseCost']), PChar(ABPass), INFDataLen);
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
  if DM.adsSelect.Active then
   	DM.adsSelect.Close;
  DM.adsSelect.SelectSQL.Text := 'select prd.pricecode, prd.regioncode, prd.injob, prd.upcost ' +
    'from pricesregionaldata prd inner join pricesregionaldataup prdu on prdu.PriceCode = prd.PriceCode and prdu.RegionCode = prd.regioncode';
	DM.adsSelect.Open;
  //Отправляем настройки только в том случае, если есть что отправлять
	if not DM.adsSelect.Eof then
	begin
		StatusText := 'Отправка настроек прайс-листов';
		Synchronize( SetStatus);
    SetLength(ParamNames, StaticParamCount + DM.adsSelect.RecordCountFromSrv*4);
    SetLength(ParamValues, StaticParamCount + DM.adsSelect.RecordCountFromSrv*4);
    ParamNames[0] := 'UniqueID';
    ParamValues[0] := IntToHex( GetCopyID, 8);
    I := 0;
    while not DM.adsSelect.Eof do begin
      //PriceCodes As Int32(), ByVal RegionCodes As Int32(), ByVal INJobs As Boolean(), ByVal UpCosts
      ParamNames[StaticParamCount+i*4] := 'PriceCodes';
      ParamValues[StaticParamCount+i*4] := DM.adsSelect.FieldByName('PriceCode').AsString;
      ParamNames[StaticParamCount+i*4+1] := 'RegionCodes';
      ParamValues[StaticParamCount+i*4+1] := DM.adsSelect.FieldByName('RegionCode').AsString;
      ParamNames[StaticParamCount+i*4+2] := 'INJobs';
      ParamValues[StaticParamCount+i*4+2] := BoolToStr(DM.adsSelect.FieldByName('INJob').AsBoolean, True);
      ParamNames[StaticParamCount+i*4+3] := 'UpCosts';
      ParamValues[StaticParamCount+i*4+3] :=
        StringReplace(DM.adsSelect.FieldByName('UPCOST').AsString, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
      DM.adsSelect.Next;
      Inc(i);
    end;
    DM.adsSelect.Close;
    Res := SOAP.Invoke( 'PostPriceDataSettings', ParamNames, ParamValues);
    Error := Utf8ToAnsi( Res.Values[ 'Error']);
    if Error <> '' then
      raise Exception.Create( Error + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));
    DM.adcUpdate.Transaction.StartTransaction;
    try
      with DM.adcUpdate do begin
        //удаляем признак того, что настройки прайс-листов были изменены
        SQL.Text := 'delete from pricesregionaldataup';
        ExecQuery;
      end;
      DM.adcUpdate.Transaction.Commit;
    except
      DM.adcUpdate.Transaction.Rollback;
      raise;
    end;
	end
  else
    DM.adsSelect.Close;
  CriticalError := False;
end;

function TExchangeThread.GetFileHash(AFileName: String): String;
var
  md5 : TIdHashMessageDigest5;
  fs : TFileStream;
begin
  try
    md5 := TIdHashMessageDigest5.Create;
    try

      fs := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
      try
        Result := md5.AsHex( md5.HashValue(fs) );
      finally
        fs.Free;
      end;

    finally
      md5.Free;
    end;
  except
    Result := '';
  end;
end;

procedure TExchangeThread.SilentExecute(q: TpFIBQuery; SQL: String);
begin
  try
    q.SQL.Text := SQL;
    q.ExecQuery;
  except
    on E : EFIBInterBaseError do begin
      if e.SQLCode <> -607 then
        raise;
    end;
  end;
end;

procedure TExchangeThread.HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
var
	Total, Current: real;
	TSuffix, CSuffix: string;
  inHTTP : TidHTTP;
  INFileSize : Integer;
  ProgressPosition : Integer;
begin
  inHTTP := TidHTTP(Sender);

//  Tracer.TR('Main.HTTPWork', 'WorkMode : ' + IntToStr(Integer(AWorkMode)) + '  WorkCount : ' + IntToStr(AWorkCount) + '  RawHeaders : ' + inHTTP.Response.RawHeaders.Text);

//	Writeln( ExchangeForm.LogFile, 'Main.HTTPWork   WorkMode : ' + IntToStr(Integer(AWorkMode)) + '  WorkCount : ' + IntToStr(AWorkCount) + '  RawHeaders : ' + inHTTP.Response.RawHeaders.Text);

  if inHTTP.Response.RawHeaders.IndexOfName('INFileSize') > -1 then
	begin
    INFileSize := StrToInt(inHTTP.Response.RawHeaders.Values['INFileSize']);

		ProgressPosition := Round( ((StartDownPosition+AWorkCount)/INFileSize) *100);

		TSuffix := 'Кб';
		CSuffix := 'Кб';

		Total := RoundTo(INFileSize/1024, -2);
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

    if (ProgressPosition > 0) and ((ProgressPosition - Progress > 5) or (ProgressPosition > 97)) then
    begin
      Progress := ProgressPosition;
      Synchronize( SetProgress );
      StatusText := 'Загрузка данных   (' +
        FloatToStrF( Current, ffFixed, 10, 2) + ' ' + CSuffix + ' / ' +
        FloatToStrF( Total, ffFixed, 10, 2) + ' ' + TSuffix + ')';
      Synchronize( SetDownStatus );
    end;
	end;

	if CriticalError then
    Abort;
end;

procedure TExchangeThread.SetDownStatus;
begin
  ExchangeForm.stStatus.Caption := StatusText; 
end;

procedure TExchangeThread.ThreadOnBatching(BatchOperation: TBatchOperation;
  RecNumber: integer; var BatchAction: TBatchAction);
begin
  //
end;

procedure TExchangeThread.ThreadOnExecuteError(pFIBQuery: TpFIBQuery;
  E: EFIBError; var Action: TDataAction);
begin
//  Tracer.TR('ThreadOnExecuteError', e.Message);
end;

{ TFileUpdateInfo }

constructor TFileUpdateInfo.Create(AFileName, AVersion, AMD5: String);
begin
  FileName := AFileName;
  Version := AVersion;
  MD5 := AMD5;
end;

initialization
finalization
  UnloadSevenZipDLL;
end.
