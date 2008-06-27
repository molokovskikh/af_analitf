unit ExchangeThread;

interface

uses
	Classes, SysUtils, Windows, StrUtils, ComObj, Variants,
	SOAPThroughHTTP, DateUtils, ShellAPI, ExtCtrls, RecThread, ActiveX,
  IdException, WinSock, RxVerInf, DB, pFIBQuery, pFIBDatabase, FIBMiscellaneous,
  FIBQuery, ibase, U_TINFIBInputDelimitedStream, SevenZip,
  IdStackConsts, infvercls, Contnrs, IdHashMessageDigest,
  DADAuthenticationNTLM, IdComponent, IdHTTP, FIB, FileUtil, pFIBProps,
  U_frmOldOrdersDelete, IB_ErrorCodes;

const
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
  utCatalogNames,
  utProducts);

TUpdateTables = set of TUpdateTable;

TExchangeThread = class( TThread)
 public
	Terminated, CriticalError: boolean;
	ErrorMessage: string;
  DownloadChildThreads : Boolean;
  procedure StopChildThreads;
private
	StatusText: string;
	Progress: integer;
	TotalProgress: integer;
	SOAP: TSOAP;
	ExchangeDateTime: TDateTime;
	NewZip: boolean;
  NeedSendOrders,
  ImportComplete : Boolean;
	FileStream: TFileStream;
  StartExec : TDateTime;
  AbsentPriceCodeSL : TStringList;
  ASynPass,
  ACodesPass,
  ABPass,
  ASaveGridMask : String;
  URL : String;
  HTTPName,
  HTTPPass : String;
  StartDownPosition : Integer;
  //Уникальный идентификатор обновления, должен передаваться при подтверждении
  UpdateId : String;

  upB : TpFIBQuery;

  //Список дочерних ниток
  ChildThreads : TObjectList;

	procedure SetStatus;
  procedure SetDownStatus;
	procedure SetProgress;
	procedure SetTotalProgress;
	procedure DisableCancel;
	procedure EnableCancel;
	procedure ShowEx;
	procedure CheckSendCurrentOrders;

	procedure RasConnect;
	procedure HTTPConnect;
	procedure CreateChildThreads;
  procedure CreateChildReceiveThread;
	procedure QueryData;
  procedure GetPass;
  procedure PriceDataSettings;
  procedure DMSavePass;
	procedure CommitExchange;
	procedure DoExchange;
	procedure DoSendLetter;
	procedure DoSendOrders;
	procedure HTTPDisconnect;
	procedure RasDisconnect;
	procedure UnpackFiles;
	procedure ImportData;
	procedure CheckNewExe;
	procedure CheckNewMDB;
	procedure CheckNewFRF;
  procedure GetAbsentPriceCode;

  //
  procedure UpdateFromFile(
    FileName,
    InsertSQL : String;
    OnExecuteError : TFIBQueryErrorEvent = nil;
    OnBatching : TOnBatching = nil);
  procedure UpdateFromFileByParams(
    FileName,
    InsertSQL : String;
    Names : array of string;
    LogSQL : Boolean = True);


	function FromXMLToDateTime( AStr: string): TDateTime;
	function RusError( AStr: string): string;
  procedure OnConnectError (AMessage : String);
  procedure OnChildTerminate(Sender: TObject);
  procedure OnFullChildTerminate(Sender: TObject);
  procedure GetWinVersion(var ANumber, ADesc : String);
  procedure adcUpdateBeforeExecute(Sender: TObject);
  procedure adcUpdateAfterExecute(Sender: TObject);
  //"Молчаливое" выполнение запроса изменения метаданных.
  //Не вызывает исключение в случае ошибки -607
  procedure SilentExecute(q : TpFIBQuery; SQL : String);
  procedure HTTPWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
  procedure HTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
  procedure ThreadOnBatching(BatchOperation:TBatchOperation;RecNumber:integer;var BatchAction:TBatchAction);
  procedure ThreadOnExecuteError(pFIBQuery:TpFIBQuery; E:EFIBError; var Action:TDataAction);
  //Извлечь документы из папки In\<DirName> и переместить их на уровень выше
  procedure ExtractDocs(DirName : String);
  function  GetUpdateId() : String;
protected
	procedure Execute; override;
public
  destructor Destroy; override;
end;

implementation

uses Exchange, DModule, AProc, Main, Retry, Exclusive,
  U_FolderMacros, LU_Tracer, FIBDatabase, FIBDataSet, Math, DBProc, U_frmSendLetter,
  U_RecvThread, Constant, U_ExchangeLog;

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
  I : Integer;
begin
  ChildThreads := TObjectList.Create(False);
	Terminated := False;
	CriticalError := False;
	TotalProgress := 0;
	Synchronize( SetTotalProgress);
	try
    CoInitialize(nil);
    try
		ErrorMessage := '';
		try
      ImportComplete := False;
      repeat
      try
			if ( [eaGetPrice, eaSendOrders, eaGetWaybills, eaSendLetter] * ExchangeForm.ExchangeActs <> [])
      then
			begin
				RasConnect;
				HTTPConnect;
				TotalProgress := 10;
				Synchronize( SetTotalProgress);
				if ([eaImportOnly, eaGetFullData, eaMDBUpdate, eaSendLetter] * ExchangeForm.ExchangeActs = []) then
        begin
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
					PriceDataSettings;
        end;
				TotalProgress := 15;
				Synchronize( SetTotalProgress);

				if eaSendOrders in ExchangeForm.ExchangeActs then
				begin
          NeedSendOrders := True;

          //Если производим кумулятивное обновление, то спрашиваем: отправлять ли заказы?
          if eaGetFullData in ExchangeForm.ExchangeActs then
            Synchronize(CheckSendCurrentOrders);

          if NeedSendOrders then
          begin
            CriticalError := True;
            ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
            ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
            //Запускаем нитку на отправку архивных заказов
            CreateChildReceiveThread;
            DoSendOrders;
            CriticalError := False;
          end;
				end;
				if eaSendLetter in ExchangeForm.ExchangeActs then
				begin
					CriticalError := True;
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
					DoSendLetter;
					CriticalError := False;
				end;
				TotalProgress := 20;
				Synchronize( SetTotalProgress);
				if ([eaGetPrice, eaGetWaybills] * ExchangeForm.ExchangeActs <> [])
           and not DM.NeedCommitExchange
        then
				begin
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута

          //Запускаем дочерние нитки только тогда, когда получаем обновление данных, но не накладные
          if eaGetPrice in ExchangeForm.ExchangeActs then
            CreateChildThreads;
					QueryData;
          GetPass;
          if eaGetFullData in ExchangeForm.ExchangeActs then
            DM.SetCumulative;
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
					DoExchange;
				end;
				TotalProgress := 40;
				Synchronize( SetTotalProgress);
			end;

			{ Распаковка файлов }
			if ( [eaGetPrice, eaImportOnly, eaGetWaybills] * ExchangeForm.ExchangeActs <> [])
      then UnpackFiles;

			{ Поддтверждение обмена }
			if [eaGetPrice, eaGetWaybills] * ExchangeForm.ExchangeActs <> []
      then
        CommitExchange;

			{ Отключение }
      if ( [eaGetWaybills, eaSendLetter] * ExchangeForm.ExchangeActs <> []) then
        OnFullChildTerminate(nil)
      else
        if ([eaGetPrice, eaSendOrders] * ExchangeForm.ExchangeActs <> [])
        then begin
          if ChildThreads.Count > 0 then begin
            for I := ChildThreads.Count-1 downto 0 do
              TThread(ChildThreads[i]).OnTerminate := OnFullChildTerminate;
            if ChildThreads.Count = 0 then
              OnFullChildTerminate(nil);
          end
          else
            OnFullChildTerminate(nil);
        end;

			if ( [eaGetPrice, eaImportOnly] * ExchangeForm.ExchangeActs <> []) then
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
        try
          DM.adcUpdate.OnExecuteError := ThreadOnExecuteError;
          ImportData;
        finally
          DM.adcUpdate.OnExecuteError := nil;
        end;
				DM.ResetExclusive;
				MainForm.Timer.Enabled := True;
      	StatusText := 'Обновление завершено';
     	  Synchronize( SetStatus);
			end;

      ImportComplete := True;

      except
        on EFIB : EFIBError do
          //Если возникла ошибка нарушения целостности, то сразу же запрашиваем кумулятивное обновление
          if not (eaGetFullData in ExchangeForm.ExchangeActs) and
              ((EFIB.SQLCode = sqlcode_foreign_or_create_schema) or (EFIB.SQLCode = sqlcode_unique_violation))
          then begin
            WriteExchangeLog(
              'Exchange',
              'Нарушение целостности при импорте:' + CRLF +
              'SQLCode       = ' + IntToStr(EFIB.SQLCode) + CRLF +
              'IBErrorCode   = ' + IntToStr(EFIB.IBErrorCode) + CRLF +
              'RaiserName    =  ' + EFIB.RaiserName + CRLF +
              'SQLMessage    = ' + EFIB.SQLMessage + CRLF +
              'IBMessage     = ' + EFIB.IBMessage + CRLF +
              'CustomMessage = ' + EFIB.CustomMessage + CRLF +
              'Msg           = ' + EFIB.Msg + CRLF +
              'Message       = ' + EFIB.Message);
            Progress := 0;
            Synchronize( SetProgress);
            StatusText := 'Откат изменений';
            Synchronize( SetStatus);
            DM.MainConnection1.Close;
            DM.RestoreDatabase(ExePath);
      			DM.MainConnection1.Open;
            ExchangeForm.ExchangeActs := ExchangeForm.ExchangeActs + [eaGetPrice, eaGetFullData, eaSendOrders];
          end
          else
            raise;
      end;

      until ImportComplete;

			{ Дожидаемся завершения работы дочерних ниток : рекламы, шпионской нитки }
			if ( [eaGetPrice, eaSendOrders] * ExchangeForm.ExchangeActs <> [])
      then begin
        DownloadChildThreads := True;
        while ChildThreads.Count > 0 do
          Sleep(500);
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
          StopChildThreads;
          while ChildThreads.Count > 0 do
            Sleep(500);
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
        WriteExchangeLog('Exchange', LastStatus + ':' + CRLF + E.Message);
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
  //Если запущены в DSP (для служебного пользования), то урл берется из настройки, если нет, то формируем автоматически
{$ifdef DSP}
  URL := DM.adtParams.FieldByName( 'HTTPHost').AsString + '/code.asmx';
{$else}
  URL := 'https://ios.analit.net/' + DM.SerBeg + DM.SerEnd + '/code.asmx';
{$endif}
  HTTPName := DM.adtParams.FieldByName( 'HTTPName').AsString;
  HTTPPass := DM.D_HP( DM.adtParams.FieldByName( 'HTTPPass').AsString );
	SOAP := TSOAP.Create( URL, HTTPName, HTTPPass, OnConnectError, ExchangeForm.HTTP);
end;

procedure TExchangeThread.CreateChildThreads;
var
  T : TThread;
begin
	T := TReclameThread.Create( True);
  T.FreeOnTerminate := True;
	TReclameThread(T).RegionCode := DM.adtClients.FieldByName( 'RegionCode').AsString;
  TReclameThread(T).SetParams(ExchangeForm.HTTPReclame, URL, HTTPName, HTTPPass);
  T.OnTerminate := OnChildTerminate;
	TReclameThread(T).Resume;
  ChildThreads.Add(T);

  CreateChildReceiveThread;
end;

procedure TExchangeThread.QueryData;
const
  StaticParamCount : Integer = 8;
var
	Res: TStrings;
	LibVersions: TObjectList;
  Error : String;
  ParamNames, ParamValues : array of String;
  I : Integer;
  WinNumber, WinDesc : String;
  fi : TFileUpdateInfo;
  UpdateIdIndex : Integer;
begin
	{ запрашиваем данные }
	StatusText := 'Подготовка данных';
	Synchronize( SetStatus);
	try
    LibVersions := AProc.GetLibraryVersionFromAppPath;
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
      ParamNames[7]  := 'WaybillsOnly';
      ParamValues[7] := BoolToStr( eaGetWaybills in ExchangeForm.ExchangeActs, True);

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
    UpdateId := '';
		Res := SOAP.Invoke( 'GetUserData', ParamNames, ParamValues);
		{ проверяем отсутствие ошибки при удаленном запросе }
		Error := Utf8ToAnsi( Res.Values[ 'Error']);
    if Error <> '' then
      raise Exception.Create( Utf8ToAnsi( Res.Values[ 'Error'])
        + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));

    //Если получили установленный флаг Cumulative, то делаем куммулятивное обновление
    if (Length(Res.Values['Cumulative']) > 0) and (StrToBool(Res.Values['Cumulative'])) then
      ExchangeForm.ExchangeActs := ExchangeForm.ExchangeActs + [eaGetFullData];

    ServerAddition := Utf8ToAnsi( Res.Values[ 'Addition']);
    { получаем имя удаленного файла }
    HostFileName := Res.Values[ 'URL'];
    NewZip := True;
    if Res.Values[ 'New'] <> '' then
      NewZip := StrToBool( UpperCase( Res.Values[ 'New']));
    if HostFileName = '' then
      raise Exception.Create( 'При выполнении вашего запроса произошла ошибка.' +
        #10#13 + 'Повторите запрос через несколько минут.');

    //Вырезаем из URL параметр ID, чтобы потом передать его при подтверждении
    UpdateIdIndex := AnsiPos(UpperCase('?Id='), UpperCase(HostFileName));
    if UpdateIdIndex = 0 then begin
      WriteExchangeLog('Exchange', 'Не найдена строка "?Id=" в URL : ' + HostFileName);
      raise Exception.Create( 'При выполнении вашего запроса произошла ошибка.' +
        #10#13 + 'Повторите запрос через несколько минут.');
    end
    else begin
      UpdateId := Copy(HostFileName, UpdateIdIndex + 4, Length(HostFileName));
      if UpdateId = '' then begin
        WriteExchangeLog('Exchange', 'UpdateId - пустой, URL : ' + HostFileName);
        raise Exception.Create( 'При выполнении вашего запроса произошла ошибка.' +
          #10#13 + 'Повторите запрос через несколько минут.');
      end;
    end;
    DM.SetServerUpdateId(UpdateId);
    LocalFileName := ExePath + SDirIn + '\UpdateData.zip';
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
	if ( [eaGetPrice, eaGetWaybills] * ExchangeForm.ExchangeActs <> [])
  then begin
		StatusText := 'Загрузка данных';
//    Tracer.TR('DoExchange', 'Загрузка данных');
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
      ExchangeForm.HTTP.OnWorkBegin := HTTPWorkBegin;
      ExchangeForm.HTTP.ReconnectCount := 0;
      ExchangeForm.HTTP.Request.BasicAuthentication := True;

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

            ExchangeForm.HTTP.Get( AddRangeStartToURL(HostFileName, FileStream.Position),
              FileStream);
            WriteExchangeLog('Exchange', 'Recieve file : ' + IntToStr(FileStream.Size));
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
        ExchangeForm.HTTP.OnWorkBegin := nil;
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
  LogStr := '';
  params := nil;
  values := nil;

  if (eaGetPrice in ExchangeForm.ExchangeActs)
  then begin
    DM.SetNeedCommitExchange();

    try
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

    //Если не производили кумулятивное обновление, то проверяем наличие синонимов
    if (not (eaGetFullData in ExchangeForm.ExchangeActs))
    then begin
      Synchronize(GetAbsentPriceCode);

      if Assigned(AbsentPriceCodeSL) and (AbsentPriceCodeSL.Count > 0) then begin
        SetLength(params, AbsentPriceCodeSL.Count + 3);
        SetLength(values, AbsentPriceCodeSL.Count + 3);
        for I := 0 to AbsentPriceCodeSL.Count-1 do begin
          params[i]:= 'PriceCode';
          values[i]:= AbsentPriceCodeSL[i];
        end;
        params[AbsentPriceCodeSL.Count]:= 'Log';
        values[AbsentPriceCodeSL.Count]:= LogStr;
        params[AbsentPriceCodeSL.Count + 1]:= 'WaybillsOnly';
        values[AbsentPriceCodeSL.Count + 1]:= BoolToStr( False, True);
        params[AbsentPriceCodeSL.Count + 2]:= 'UpdateId';
        values[AbsentPriceCodeSL.Count + 2]:= GetUpdateId();
      end;
    end;
  end;

  if length(params) = 0 then begin
    SetLength(params, 4);
    SetLength(values, 4);
    params[0]:= 'PriceCode';
    values[0]:= '0';
    params[1]:= 'Log';
    values[1]:= LogStr;
    params[2]:= 'WaybillsOnly';
    values[2]:= BoolToStr( eaGetWaybills in ExchangeForm.ExchangeActs, True);
    params[3]:= 'UpdateId';
    values[3]:= GetUpdateId();
  end;

	Res := SOAP.Invoke( 'MaxSynonymCode', params, values);

  if (eaGetPrice in ExchangeForm.ExchangeActs) then begin
    ExchangeDateTime := FromXMLToDateTime( Res.Text);
    DM.adtParams.Edit;
    DM.adtParams.FieldByName( 'LastDateTime').AsDateTime := ExchangeDateTime;
    if DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean then begin
      DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean := False;
      MainForm.EnableByHTTPName;
    end;
    DM.adtParams.Post;
    FreeExchangeLog();
    SysUtils.DeleteFile(ExePath + 'Exchange.log');
    CreateExchangeLog();
    DM.ResetNeedCommitExchange;
  end;
end;

procedure TExchangeThread.DoSendOrders;
const
  OrderParamCount : Integer = 14;
var
	params, values: array of string;
	i: integer;
	Res: TStrings;
  ResError : String;
	ServerOrderId: integer;
  SendError : Boolean;
{
  ExternalRes : Boolean;
  ErrorStr : PChar;
  ExtErrorMessage : String;
}  
  S : String;
  TmpOrderCost, TmpMinCost : String;
begin
	Synchronize( ExchangeForm.CheckStop);
	Synchronize( DisableCancel);
 	DM.adsOrdersH.Close;
	DM.adsOrdersH.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').Value;
	DM.adsOrdersH.ParamByName( 'AClosed').Value := False;
	DM.adsOrdersH.ParamByName( 'ASend').Value := True;
	DM.adsOrdersH.ParamByName( 'TimeZoneBias').Value := 0;
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

    WriteExchangeLog('Exchange',
      'Отправка заказа #' + DM.adsOrdersH.FieldByName( 'OrderId').AsString +
      '  по прайсу ' + DM.adsOrdersH.FieldByName( 'PriceCode').AsString);
		SetLength( params, 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount + 3);
		SetLength( values, 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount + 3);

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
			params[ i * OrderParamCount + 6] := 'ProductId';
			params[ i * OrderParamCount + 7] := 'CodeFirmCr';
			params[ i * OrderParamCount + 8] := 'SynonymCode';
			params[ i * OrderParamCount + 9] := 'SynonymFirmCrCode';
			params[ i * OrderParamCount + 10] := 'Code';
			params[ i * OrderParamCount + 11] := 'CodeCr';
			params[ i * OrderParamCount + 12] := 'Quantity';
			params[ i * OrderParamCount + 13] := 'Junk';
			params[ i * OrderParamCount + 14] := 'Await';
			params[ i * OrderParamCount + 15] := 'Cost';
			values[ i * OrderParamCount + 6] := DM.adsOrders.FieldByName( 'Productid').AsString;
			values[ i * OrderParamCount + 7] := DM.adsOrders.FieldByName( 'CodeFirmCr').AsString;
			values[ i * OrderParamCount + 8] := DM.adsOrders.FieldByName( 'SynonymCode').AsString;
			values[ i * OrderParamCount + 9] := DM.adsOrders.FieldByName( 'SynonymFirmCrCode').AsString;
      values[ i * OrderParamCount + 10] := DM.adsOrders.FieldByName( 'Code').AsString;
      values[ i * OrderParamCount + 11] := DM.adsOrders.FieldByName( 'CodeCr').AsString;
			values[ i * OrderParamCount + 12] := IfThen(DM.adsOrders.FieldByName( 'Ordercount').AsInteger <= MaxOrderCount, DM.adsOrders.FieldByName( 'Ordercount').AsString, IntToStr(MaxOrderCount)) ;
			values[ i * OrderParamCount + 13] := BoolToStr( DM.adsOrders.FieldByName( 'Junk').AsBoolean, True);
			values[ i * OrderParamCount + 14] := BoolToStr( DM.adsOrders.FieldByName( 'Await').AsBoolean, True);
      try
        if Length(DM.adsOrders.FieldByName( 'PRICE').AsString) > 0 then
          S := DM.D_B_N(DM.adsOrders.FieldByName( 'PRICE').AsString)
        else
          S := CurrToStr(0.0);
        TmpOrderCost := StringReplace(S, '.', DM.FFS.DecimalSeparator, [rfReplaceAll]);
        S := StringReplace(S, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
        values[ i * OrderParamCount + 15] := S;
      except
        on E : Exception do begin
          WriteExchangeLog('Exchange', 'Ошибка при расшифровке цены : ' + E.Message
            + '  Строка : "' + DM.adsOrders.FieldByName( 'PRICE').AsString + '"');
          raise Exception.CreateFmt('При отправке заказа для "%s" невозможно сформировать цену по позиции "%s".',
            [DM.adsOrdersH.FieldByName( 'PriceName').AsString, DM.adsOrders.FieldByName('SYNONYMNAME').AsString]);
        end;
      end;

			params[ i * OrderParamCount + 16] := 'MinCost';
			params[ i * OrderParamCount + 17] := 'MinPriceCode';
			params[ i * OrderParamCount + 18] := 'LeaderMinCost';
			params[ i * OrderParamCount + 19] := 'LeaderMinPriceCode';

      //Если выставлено поле - рассчитывать лидеров,
      if DM.adtClientsCALCULATELEADER.Value then begin

        if DM.adsOrderCore.Active then
          DM.adsOrderCore.Close();

        DM.adsOrderCore.ParamByName( 'RegisterId').Value := RegisterId;
        DM.adsOrderCore.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
        DM.adsOrderCore.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
        DM.adsOrderCore.ParamByName( 'ParentCode').Value := DM.adsOrders.FieldByName( 'FullCode').Value;
        DM.adsOrderCore.ParamByName( 'ShowRegister').Value := False;
        DM.adsOrderCore.Options := DM.adsOrderCore.Options - [poCacheCalcFields];
        DM.adsOrderCore.Open;
        DM.adsOrderCore.FetchAll;
        DM.adsOrderCore.DoSort(['CryptBaseCost'], [True]);

        //Выбираем минимального из всех прайсов
        DBProc.SetFilter(DM.adsOrderCore,
          'JUNK = ' + DM.adsOrders.FieldByName( 'Junk').AsString +
          ' and CodeFirmCr = ' + DM.adsOrders.FieldByName( 'CodeFirmCr').AsString +
          ' and ProductId = ' + DM.adsOrders.FieldByName( 'ProductId').AsString);

        DM.adsOrderCore.First;

        try
          S := DM.D_B_N(DM.adsOrderCoreBASECOST.AsString);
          TmpMinCost := StringReplace(S, '.', DM.FFS.DecimalSeparator, [rfReplaceAll]);
          S := StringReplace(S, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
          values[ i * OrderParamCount + 16] := S;
          values[ i * OrderParamCount + 17] := DM.adsOrderCorePRICECODE.AsString;

          //Если минимальная цена совпадает с ценой заказа, то минимальный прайс-лист - прайс-лист заказа
          if (TmpMinCost <> '') and (Abs(StrToCurr(TmpMinCost) - StrToCurr(TmpOrderCost)) < 0.01)
          then begin
            values[ i * OrderParamCount + 17] := DM.adsOrdersH.FieldByName( 'PriceCode').AsString;
          end;
        except
          on E : Exception do begin
            WriteExchangeLog('Exchange', 'Ошибка при расшифровке минимальной цены : ' + E.Message
              + '  Строка : "' + DM.adsOrderCoreBASECOST.AsString + '"');
            values[ i * OrderParamCount + 16] := '';
            values[ i * OrderParamCount + 17] := '';
          end;
        end;

        //Выбираем минимального из основных прайсов
        DBProc.SetFilter(DM.adsOrderCore,
          'JUNK = ' + DM.adsOrders.FieldByName( 'Junk').AsString +
          ' and CodeFirmCr = ' + DM.adsOrders.FieldByName( 'CodeFirmCr').AsString +
          ' and ProductId = ' + DM.adsOrders.FieldByName( 'ProductId').AsString +
          ' and PriceEnabled = True');

        DM.adsOrderCore.First;

        //В основных прайс-листах может не быть предложений
        if not DM.adsOrderCore.IsEmpty then begin
          try
            S := DM.D_B_N(DM.adsOrderCoreBASECOST.AsString);
            TmpMinCost := StringReplace(S, '.', DM.FFS.DecimalSeparator, [rfReplaceAll]);
            S := StringReplace(S, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
            values[ i * OrderParamCount + 18] := S;
            values[ i * OrderParamCount + 19] := DM.adsOrderCorePRICECODE.AsString;

            //Если минимальная цена лидеров совпадает с ценой заказа и прайс-лист тоже лидер, то минимальный прайс-лист - прайс-лист заказа
            if (TmpMinCost <> '')
              and (DM.adsOrdersH.FieldByName( 'PriceEnabled').AsBoolean)
              and (Abs(StrToCurr(TmpMinCost) - StrToCurr(TmpOrderCost)) < 0.01)
            then begin
              values[ i * OrderParamCount + 19] := DM.adsOrdersH.FieldByName( 'PriceCode').AsString;
            end;
          except
            on E : Exception do begin
              WriteExchangeLog('Exchange', 'Ошибка при расшифровке минимальной цены лидера : ' + E.Message
                + '  Строка : "' + DM.adsOrderCoreBASECOST.AsString + '"');
              values[ i * OrderParamCount + 18] := '';
              values[ i * OrderParamCount + 19] := '';
            end;
          end;
        end
        else begin
          values[ i * OrderParamCount + 18] := '';
          values[ i * OrderParamCount + 19] := '';
        end;

        DM.adsOrderCore.Close;
      end;

			DM.adsOrders.Edit;
			DM.adsOrders.FieldByName( 'PRICE').Clear;
			DM.adsOrders.FieldByName( 'CoreId').Clear;
			DM.adsOrders.FieldByName( 'SendPrice').AsCurrency := StrToCurr(TmpOrderCost);
      DM.adsOrders.Post;
			DM.adsOrders.Next;
		end;

    ServerOrderId := 0;
		try
      //Передаем уникальный идентификатор
      params[ 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount ] := 'UniqueID';
      values[ 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount ] := IntToHex( GetCopyID, 8);
      params[ 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount + 1] := 'ClientOrderID';
      values[ 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount + 1] := DM.adsOrdersH.FieldByName( 'OrderId').AsString;
      params[ 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount + 2] := 'ServerOrderId';
      values[ 6 + DM.adsOrders.RecordCountFromSrv * OrderParamCount + 2] := '0';
			Res := Soap.Invoke( 'PostOrder2', params, values);
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
      if not SendError then begin
        DM.UpTran.StartTransaction;
        try
          DM.adsOrders.ApplyUpdates;
          DM.adsOrdersH.Edit;
          { Заказ был отправлен, а не переведен }
          DM.adsOrdersH.FieldByName( 'Send').AsBoolean := True;
          DM.adsOrdersH.FieldByName( 'SendDate').AsDateTime := Now;
          { Закрываем заказ }
          DM.adsOrdersH.FieldByName( 'Closed').AsBoolean := True;
          DM.adsOrdersH.FieldByName( 'ServerOrderId').AsInteger := ServerOrderId;
          DM.adsOrdersH.Post;
          DM.UpTran.Commit;
        except
          try
            DM.UpTran.Rollback; except end;
            raise;
        end;
      end
      else
        DM.adsOrders.CancelUpdates;
			DM.adsOrders.Close;
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
	Synchronize( EnableCancel);
end;

procedure TExchangeThread.RasConnect;
var
  RasTimeout : Integer;
begin
	if DM.adtParams.FieldByName( 'RasConnect').AsBoolean then begin
			Synchronize( ExchangeForm.Ras.Connect);
      RasTimeout := DM.adtParams.FieldByName( 'RasSleep').AsInteger;
      if RasTimeout > 0 then begin
        WriteExchangeLog('Exchange', 'Sleep = ' + IntToStr(RasTimeout));
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
	SR, DeleteSR: TSearchRec;
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
			{ Если это архив с рекламой }
			if ( SR.Name[ 1] = 'r') and ( SR.Size > 0) then
			begin
{
        Это делается в нитке с рекламой
}
			end
                	{ Если это данные }
			else
			begin
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

				OSDeleteFile( ExePath + SDirIn + '\' + SR.Name);
        //Если нет файла ".zi_", то это не является проблемой и импорт может быть осуществлен
				OSDeleteFile( ExePath + SDirIn + '\' + ChangeFileExt( SR.Name, '.zi_'), False);
			end;
			Synchronize( ExchangeForm.CheckStop);
		until FindNext( SR) <> 0;
	finally
		SysUtils.FindClose( SR);
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
          OSMoveFile(
            ExePath + SDirIn + '\' + DeleteSR.Name,
            ExePath + SDirIn + '\' + NewImportFileName);
        end;

      end;
    until (FindNext( DeleteSR ) <> 0)

  finally
    SysUtils.FindClose( DeleteSR );
  end;


  //Обрабатываем папку Waybills
  ExtractDocs(SDirWaybills);
  //Обрабатываем папку Docs
  ExtractDocs(SDirDocs);
  //Обрабатываем папку Rejects
  ExtractDocs(SDirRejects);
end;

procedure TExchangeThread.CheckNewExe;
var
	EraserDll: TResourceStream;
begin
	if not SysUtils.DirectoryExists( ExePath + SDirIn + '\' + SDirExe) then exit;

	AProc.MessageBox('Получена новая версия программы. Сейчас будет выполнено обновление', MB_OK or MB_ICONWARNING);
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
    DM.MainConnection1.Close;
    try
      DM.CompactDatabase;
    finally
      DM.MainConnection1.Open;
    end;
	end;
end;

procedure TExchangeThread.CheckNewFRF;
var
	SR: TSearchRec;
  SourceFile,
  DestFile : String;
begin
	if FindFirst( ExePath + SDirIn + '\*.frf', faAnyFile, SR) = 0 then
	begin
	  repeat
			if ( SR.Attr and faDirectory) = faDirectory then continue;
			try
        SourceFile := ExePath + SDirIn + '\' + SR.Name;
        DestFile := ExePath + '\' + SR.Name;
        if FileExists(DestFile) then begin
          Windows.SetFileAttributes(PChar(DestFile), FILE_ATTRIBUTE_NORMAL);
          Windows.DeleteFile(PChar(DestFile));
          Sleep(500);
        end;
        Windows.MoveFile(PChar(SourceFile), PChar(DestFile))
			except
			end;
    until FindNext( SR) <> 0;
    SysUtils.FindClose(SR);
	end;
end;

procedure TExchangeThread.ImportData;
var
//	I: Integer;
//	Catalog: Variant;
	Tables: TStrings;
	UpdateTables: TUpdateTables;
begin
	Synchronize( ExchangeForm.CheckStop);
	Synchronize( DisableCancel);
	StatusText := 'Резервное копирование данных';
	Synchronize( SetStatus);
  if not DM.IsBackuped(ExePath) then
  	DM.BackupDatabase( ExePath);
	DM.OpenDataBase( ExePath + DatabaseName);
	TotalProgress := 65;
	Synchronize( SetTotalProgress);

	StatusText := 'Импорт данных';
	Synchronize( SetStatus);
	Progress := 0;
	Synchronize( SetProgress);
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
  //Удаляем минимальные цены, если есть обновления в Core
	if (Tables.IndexOf( 'EXTMINPRICES')>=0) and (GetFileSize(ExePath+SDirIn+'\Core.txt') > 0) then UpdateTables := UpdateTables + [utMinPrices];
	if Tables.IndexOf( 'EXTPRICEAVG')>=0 then UpdateTables := UpdateTables + [utPriceAVG];
	if Tables.IndexOf( 'EXTCATALOGFARMGROUPS')>=0 then UpdateTables := UpdateTables + [utCatalogFarmGroups];
	if Tables.IndexOf( 'EXTCATFARMGROUPSDEL')>=0 then UpdateTables := UpdateTables + [utCatFarmGroupsDEL];
	if Tables.IndexOf( 'EXTCATALOGNAMES')>=0 then UpdateTables := UpdateTables + [utCatalogNames];
	if Tables.IndexOf( 'EXTPRODUCTS')>=0 then UpdateTables := UpdateTables + [utProducts];


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
    //Удаление из Core старых прайсов и обновление ServerCoreID в MinPrices
	  SQL.Text:='EXECUTE PROCEDURE CoreDeleteNewPrices'; ExecQuery;
	end;
	//Synonym
	if (utSynonym in UpdateTables) and (eaGetFullData in ExchangeForm.ExchangeActs) then begin
    SilentExecute(DM.adcUpdate, 'DROP INDEX IDX_SYNONYMNAME');
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

  DM.MainConnection1.DefaultUpdateTransaction.Commit;

  DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;

	SQL.Text := 'select count(*) from MinPrices where ServerCoreID is not null';
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
	SQL.Text := 'select count(*) from Core where ProductId is not null';
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

  if (utProducts in UpdateTables) then begin
	  if (eaGetFullData in ExchangeForm.ExchangeActs) then begin
      UpdateFromFile(ExePath+SDirIn+'\Products.txt',
        'INSERT INTO products (productid, catalogid) values (:productid, :catalogid)');
    end
    else begin
      //products_iu
      UpdateFromFile(ExePath+SDirIn+'\Products.txt',
        'EXECUTE PROCEDURE products_iu(:productid, :catalogid)');
    end;
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
        '(Synonymcode, Synonymname) '+
        'values (:Synonymcode, :Synonymname)');
  	  SQL.Text:='ALTER TABLE SYNONYMS ADD CONSTRAINT PK_SYNONYMS PRIMARY KEY (SYNONYMCODE)'; ExecQuery;
  	  SQL.Text:='CREATE INDEX IDX_SYNONYMNAME ON SYNONYMS (SYNONYMNAME)'; ExecQuery;
    end
    else begin
      UpdateFromFile(ExePath+SDirIn+'\Synonym.txt',
        'INSERT INTO Synonyms ' +
        '(Synonymcode, Synonymname) '+
        'SELECT :Synonymcode, :Synonymname '+
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
    SilentExecute(DM.adcUpdate, 'alter table core DROP CONSTRAINT FK_CORE_ProductId');
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
'(Pricecode, RegionCode, ProductId, CodeFirmCr, SynonymCode, SynonymFirmCrCode,' +
'Code, CodeCr, Unit, Volume, Junk, Await, Quantity, Note, Period, Doc, RegistryCost, VitallyImportant, RequestRatio, BaseCost, ServerCOREID, OrderCost, MinOrderCount)' +
'values (:Pricecode, :RegionCode, :ProductId, :CodeFirmCr, :SynonymCode, ' +
':SynonymFirmCrCode, :Code, :CodeCr, :Unit, :Volume, :Junk, :Await, :Quantity, ' +
':Note, :Period, :Doc, :RegistryCost, :VitallyImportant, :RequestRatio, :BaseCost, :ServerCOREID, :OrderCost, :MinOrderCount)');
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT PK_CORE PRIMARY KEY (COREID)'; ExecQuery;
    SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT FK_CORE_ProductId FOREIGN KEY (ProductId) REFERENCES PRODUCTS (ProductId) ON DELETE CASCADE ON UPDATE CASCADE'; ExecQuery;
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT FK_CORE_PRICECODE FOREIGN KEY (PRICECODE) REFERENCES PRICESDATA (PRICECODE) ON DELETE CASCADE ON UPDATE CASCADE'; ExecQuery;
	  SQL.Text:='ALTER TABLE CORE ADD CONSTRAINT FK_CORE_REGIONCODE FOREIGN KEY (REGIONCODE) REFERENCES REGIONS (REGIONCODE) ON UPDATE CASCADE'; ExecQuery;
	  SQL.Text:='CREATE INDEX IDX_CORE_JUNK ON CORE (ProductId, JUNK)'; ExecQuery;
	  SQL.Text:='CREATE INDEX IDX_CORE_SERVERCOREID ON CORE (SERVERCOREID)'; ExecQuery;
	  SQL.Text:='CREATE INDEX FK_CORE_SYNONYMCODE ON CORE (SYNONYMCODE)'; ExecQuery;
	  SQL.Text:='CREATE INDEX FK_CORE_SYNONYMFIRMCRCODE ON CORE (SYNONYMFIRMCRCODE)'; ExecQuery;
	end;
  
  DM.MainConnection1.DefaultUpdateTransaction.Commit;

  DM.MainConnection1.Close;
  DM.MainConnection1.Open;
  DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;
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
	//проставляем мин. цены и лидеров
	SQL.Text := 'EXECUTE PROCEDURE MinPricesInsert';	ExecQuery;
  Progress := 60;
	Synchronize( SetProgress);
	TotalProgress := 75;
	Synchronize( SetTotalProgress);

  DM.MainConnection1.DefaultUpdateTransaction.Commit;

  DM.MainConnection1.Close;
  DM.MainConnection1.Open;
  DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;

	StatusText := 'Импорт данных';
	Synchronize( SetStatus);

	SQL.Text := 'update catalogs set CoreExists = 0 where FullCode > 0'; ExecQuery;
	SQL.Text := 'update catalogs set CoreExists = 1 where FullCode > 0 and exists(select * from core c, products p where p.catalogid = catalogs.fullcode and c.productid = p.productid)'; ExecQuery;
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
    UpdateFromFileByParams(ExePath+SDirIn+'\MinPrices.txt',
      'update minprices set servercoreid = case when ((servercoreid is null) or (servermemoid is null)) then coalesce(:servercoreid, servermemoid) when (bin_xor(99999900, servermemoid) >= bin_xor(99999900, coalesce(:servermemoid, servermemoid))) then ' + 'coalesce(:servercoreid, servercoreid) ' + ' else servercoreid end, ' +
      'servermemoid = case when ((servercoreid is null) or (servermemoid is null)) then coalesce(:servermemoid, servermemoid) when (bin_xor(99999900, servermemoid) >= bin_xor(99999900, coalesce(:servermemoid, servermemoid))) ' + 'then coalesce(:servermemoid, servermemoid) else servermemoid end ' +
      'where productid = :productid and regioncode = :regioncode',
      ['servercoreid', 'productid', 'regioncode', 'servermemoid'],
      False);
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
	SQL.Text := 'select count(*) from MinPrices where ServerCoreID is not null';
	ExecQuery;
  Close;
	SQL.Text := 'select count(*) from Core where productid is not null';
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
  WriteExchangeLog('Exchange', AMessage);
end;

procedure TExchangeThread.OnChildTerminate(Sender: TObject);
begin
  if Assigned(Sender) then
    ChildThreads.Remove(Sender);
end;

procedure TExchangeThread.StopChildThreads;
var
  I : Integer;
  S : String;
begin
  for I := ChildThreads.Count-1 downto 0 do begin
    try
      TReceiveThread(ChildThreads[i]).Terminate;
      TReceiveThread(ChildThreads[i]).DisconnectThread;
    except
      on E : Exception do
        S := E.Message;
    end;
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
  if Assigned(ChildThreads) then
    try ChildThreads.Free; except end;
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
  OnExecuteError : TFIBQueryErrorEvent = nil;
  OnBatching : TOnBatching = nil);
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
      if Assigned(OnExecuteError) then
        up.OnExecuteError := OnExecuteError
      else
        up.OnExecuteError := ThreadOnExecuteError;

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
  if Length(Res.Values['SaveGridMask']) = 7 then
    ASaveGridMask := Res.Values['SaveGridMask']
  else
    ASaveGridMask := '0000000';
  Synchronize(DMSavePass);
  CriticalError := False;
end;

procedure TExchangeThread.DMSavePass;
begin
  DM.SavePass(ASynPass, ACodesPass, ABPass, ASaveGridMask);
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
  DM.adsSelect.SelectSQL.Text := 'select prd.pricecode, prd.regioncode, prd.injob ' +
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
      //TODO: Пока здесь передаем 0, потом этот параметр надо удалить 
      ParamValues[StaticParamCount+i*4+3] := '0.0';
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

//  Tracer.TR('Main.HTTPWork', 'WorkMode : ' + IntToStr(Integer(AWorkMode)) + '  WorkCount : ' + IntToStr(AWorkCount));
//  Tracer.TR('Main.HTTPWork', 'Request.RawHeaders : ' + inHTTP.Request.RawHeaders.Text);
//  Tracer.TR('Main.HTTPWork', 'Response.RawHeaders : ' + inHTTP.Response.RawHeaders.Text);
  
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

//    Tracer.TR('Main.HTTPWork', 'INFileSize : -1');

    if (ProgressPosition > 0) and ((ProgressPosition - Progress > 5) or (ProgressPosition > 97)) then
    begin
      Progress := ProgressPosition;
      Synchronize( SetProgress );
      StatusText := 'Загрузка данных   (' +
        FloatToStrF( Current, ffFixed, 10, 2) + ' ' + CSuffix + ' / ' +
        FloatToStrF( Total, ffFixed, 10, 2) + ' ' + TSuffix + ')';
//      Tracer.TR('Main.HTTPWork', 'StatusText : ' + StatusText);
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
  //Tracer.TR('ThreadOnBatching', 'RecNumber=' + IntToStr(RecNumber));
end;

procedure TExchangeThread.ThreadOnExecuteError(pFIBQuery: TpFIBQuery;
  E: EFIBError; var Action: TDataAction);
var
  LogText : String;
  I : Integer;
begin
  Action := daFail;

  LogText := 'Query : ' + pFIBQuery.Name + CRLF +
    ' SQL : ' + pFIBQuery.SQL.Text + CRLF;
  if pFIBQuery.ParamCount > 0 then begin
    LogText := LogText + '  Params ( ';
    for I := 0 to pFIBQuery.ParamCount-1 do
      LogText := LogText +
        pFIBQuery.Params.Vars[i].Name + ' : ' + pFIBQuery.Params.Vars[i].AsString + ';';
    LogText := LogText + ' )';
  end;

  //TODO: Пока эта информация пишется в Exchange.log, возможно ее стоит убрать
  WriteExchangeLog('Exchange.ThreadOnExecuteError', LogText);
end;

procedure TExchangeThread.DoSendLetter;
var
  Attachs : TStringList;

  procedure AddFile(FileName : String);
  begin
    if Attachs.IndexOf(FileName) = -1 then
      Attachs.Add(FileName);
  end;

begin
  StatusText := 'Отправка письма';
	Synchronize( SetStatus);

  Attachs := TStringList.Create;
  Attachs.CaseSensitive := False;
  try

    Attachs.AddStrings(frmSendLetter.lbFiles.Items);
    if frmSendLetter.cbAddLogs.Checked then begin
      AddFile(ExeName + '.TR');
      AddFile(ExeName + '.old.TR');
      AddFile(ExePath + 'Exchange.log');
      AddFile(ExePath + 'AnalitFup.log');
    end;
    
    AProc.InternalDoSendLetter(
      ExchangeForm.HTTP,
      URL,
      'AFSend',
      Attachs,
      frmSendLetter.leSubject.Text,
      frmSendLetter.mBody.Text);
  finally
    Attachs.Free;
  end;
end;

procedure TExchangeThread.HTTPWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
end;

procedure TExchangeThread.CheckSendCurrentOrders;
begin
  NeedSendOrders := MainForm.CheckUnsendOrders;
  if NeedSendOrders then
    NeedSendOrders := ConfirmSendCurrentOrders;
end;

procedure TExchangeThread.ExtractDocs(DirName: String);
var
  DocsSR: TSearchRec;
begin
  if DirectoryExists(ExePath + SDirIn + '\' + DirName) then begin
    if FindFirst( ExePath + SDirIn + '\' + DirName + '\*.*', faAnyFile, DocsSR) = 0 then
    try
      repeat
        if (DocsSR.Name <> '.') and (DocsSR.Name <> '..') then
          OSMoveFile(
            ExePath + SDirIn + '\' + DirName + '\' + DocsSR.Name,
            ExePath + DirName + '\' + DocsSR.Name);
      until (FindNext( DocsSR ) <> 0)
    finally
      SysUtils.FindClose( DocsSR );
    end;
    RemoveDir(ExePath + SDirIn + '\' + DirName);
  end;
end;

procedure TExchangeThread.UpdateFromFileByParams(FileName,
  InsertSQL: String; Names: array of string;
  LogSQL : Boolean = True);
var
  up : TpFIBQuery;
  InDelimitedFile : TFIBInputDelimitedFile;
  StopExec : TDateTime;
  Secs : Int64;
  Col : String;
  Values : array of Variant;
  FEOF : Boolean;
  FEOL : Boolean;
  CurColumn : Integer;
  ResultRead : Integer;
  I : Integer;
begin
  up := TpFIBQuery.Create(nil);
  SetLength(Values, Length(Names));
  try
    up.Database := DM.MainConnection1;
    up.Transaction := DM.UpTran;

    InDelimitedFile := TFIBInputDelimitedFile.Create;
    try
      InDelimitedFile.SkipTitles := False;
      InDelimitedFile.ReadBlanksAsNull := True;
      InDelimitedFile.ColDelimiter := Chr(159);
      InDelimitedFile.RowDelimiter := Chr(161);

      up.SQL.Text := InsertSQL;
      InDelimitedFile.Filename := FileName;

      if LogSQL then
        Tracer.TR('Import', 'Exec : ' + InsertSQL);
      StartExec := Now;
      try
        up.Prepare;
        InDelimitedFile.ReadyStream;
        FEOF := False;
        repeat
          FEOL := False;
          CurColumn := 0;
          for I := 0 to Length(Names)-1 do
            Values[i] := Unassigned;
          repeat
            ResultRead := InDelimitedFile.GetColumn(Col);
            if ResultRead = 0 then FEOF := True;
            if ResultRead = 2 then FEOL := True;
            if (CurColumn < Length(Names)) then
            try
              if (Col = '') then
                Values[CurColumn] := Null
              else
                Values[CurColumn] := Col;
              Inc(CurColumn);
            except
              on E: Exception do
              begin
                if not (FEOF and (CurColumn = Length(Names))) then
                  raise;
              end;
            end;
          until FEOL or FEOF;
          if ((FEOF) and (CurColumn = Length(Names))) or (not FEOF)
          then begin
            for I := 0 to Length(Names)-1 do
              if Values[i] = Null then
                case up.ParamByName(Names[i]).ServerSQLType of
                  SQL_TEXT,SQL_VARYING:
                   if InDelimitedFile.ReadBlanksAsNull then
                     up.ParamByName(Names[i]).IsNull := True
                   else
                    up.ParamByName(Names[i]).AsString := '';
                else
                  up.ParamByName(Names[i]).IsNull := True
                end
              else
                up.ParamByName(Names[i]).AsString := Values[i];
            up.ExecQuery;
          end;
        until FEOF;
      finally
        StopExec := Now;
        Secs := SecondsBetween(StopExec, StartExec);
        if (Secs > 3) and LogSQL then
          Tracer.TR('Import', 'ExcecTime : ' + IntToStr(Secs));
      end;

    finally
      InDelimitedFile.Free;
    end;

  finally
    up.Free;
  end;
end;

procedure TExchangeThread.OnFullChildTerminate(Sender : TObject);
begin
  if Assigned(Sender) then
    ChildThreads.Remove(Sender);
  if (ChildThreads.Count = 0) and ( [eaGetPrice, eaSendOrders, eaGetWaybills, eaSendLetter] * ExchangeForm.ExchangeActs <> [])
  then begin
    HTTPDisconnect;
    RasDisconnect;
  end;
end;

procedure TExchangeThread.CreateChildReceiveThread;
var
  T : TThread;
  I : Integer;
  Find : Boolean;
begin
  Find := False;
  for I := 0 to ChildThreads.Count -1 do
    if ChildThreads[i] is TReceiveThread then begin
      Find := True;
      Break;
    end;

  if not Find then begin
    T := TReceiveThread.Create(True);
    TReceiveThread(T).SetParams(ExchangeForm.httpReceive, URL, HTTPName, HTTPPass);
    T.OnTerminate := OnChildTerminate;
    T.Resume;
    ChildThreads.Add(T);
  end;
end;

function TExchangeThread.GetUpdateId: String;
begin
  if (Length(UpdateId) > 0) then
    Result := UpdateId
  else
    Result := DM.GetServerUpdateId();
end;

initialization
finalization
  UnloadSevenZipDLL;
end.
