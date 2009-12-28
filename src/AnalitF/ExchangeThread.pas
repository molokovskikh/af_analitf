unit ExchangeThread;

interface

uses
	Classes, SysUtils, Windows, StrUtils, ComObj, Variants,
	SOAPThroughHTTP, DateUtils, ShellAPI, ExtCtrls, RecThread, ActiveX,
  IdException, WinSock, RxVerInf, DB, pFIBQuery, pFIBDatabase, FIBMiscellaneous,
  FIBQuery, ibase, U_TINFIBInputDelimitedStream, SevenZip,
  IdStackConsts, infvercls, Contnrs, IdHashMessageDigest,
  DADAuthenticationNTLM, IdComponent, IdHTTP, FIB, FileUtil, pFIBProps,
  U_frmOldOrdersDelete, IB_ErrorCodes, U_RecvThread, IdStack, MyAccess, DBAccess,
  DataIntegrityExceptions, PostSomeOrdersController, ExchangeParameters;

type

TUpdateTable = (
	utCatalogs,
	utCatDel,
	utClients,
	utProviders,
	utPricesData,
	utRegionalData,
	utPricesRegionalData,
	utCore,
	utRegions,
	utSynonyms,
	utSynonymFirmCr,
	utRejects,
  utMinPrices,
  utCatalogFarmGroups,
  utCatFarmGroupsDEL,
  utCatalogNames,
  utProducts,
  utUser,
  utDelayOfPayments,
  utClient);

TUpdateTables = set of TUpdateTable;

TExchangeThread = class( TThread)
 public
  ExchangeParams : TObjectList;
  procedure StopChildThreads;
private
	StatusText: string;
	Progress: integer;
	TotalProgress: integer;
	SOAP: TSOAP;
	ExchangeDateTime: TDateTime;
	NewZip: boolean;
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

	HostFileName, LocalFileName: string;

  //Список дочерних ниток
  ChildThreads : TObjectList;

	procedure SetStatus;
  procedure SetDownStatus;
	procedure SetProgress;
	procedure SetTotalProgress;
	procedure DisableCancel;
	procedure EnableCancel;

	procedure RasConnect;
	procedure HTTPConnect;
	procedure CreateChildThreads;
  procedure CreateChildSendArhivedOrdersThread;
  function  ChildThreadClassIsExists(ChildThreadClass : TReceiveThreadClass) : Boolean;
	procedure QueryData;
  procedure GetPass;
  procedure PriceDataSettings;
  procedure DMSavePass;
	procedure CommitExchange;
	procedure DoExchange;
	procedure DoSendLetter;
  procedure DoSendSomeOrders;
	procedure HTTPDisconnect;
	procedure RasDisconnect;
	procedure UnpackFiles;
	procedure ImportData;
	procedure CheckNewExe;
	procedure CheckNewMDB;
	procedure CheckNewFRF;
  procedure GetAbsentPriceCode;

  procedure UpdateFromFileByParamsMySQL(
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
  procedure InternalExecute;
  procedure HTTPWork(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
  //Извлечь документы из папки In\<DirName> и переместить их на уровень выше
  procedure ExtractDocs(DirName : String);
  function  GetUpdateId() : String;
  //Отправляем сообщение в tech@analit.net из программы с информацией об ошибке для техподдержки
  procedure SendLetterWithTechInfo(Subject, Body : String);
protected
	procedure Execute; override;
public
  constructor Create(CreateSuspended: Boolean);
  destructor Destroy; override;
end;

implementation

uses Exchange, DModule, AProc, Main, Retry, 
  LU_Tracer, FIBDatabase, FIBDataSet, Math, DBProc, U_frmSendLetter,
  Constant, U_ExchangeLog, U_SendArchivedOrdersThread;

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

procedure TExchangeThread.Execute;
var
	LastStatus: string;
  I : Integer;
begin
  ChildThreads := TObjectList.Create(False);
	TotalProgress := 0;
	Synchronize( SetTotalProgress);
	try
    CoInitialize(nil);
    DM.MainConnection.Open;
    try
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
        //Отправяем настройки прайс-листов при запросе данных (обычно или кумулятивном)
        if (eaGetPrice in ExchangeForm.ExchangeActs)
          and not DM.adsUser.FieldByName('InheritPrices').AsBoolean
        then
        begin
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
					PriceDataSettings;
        end;
				TotalProgress := 15;
				Synchronize( SetTotalProgress);

				if eaSendOrders in ExchangeForm.ExchangeActs then
				begin
          TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value := True;
          ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
          ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
          DoSendSomeOrders;
          TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value := False;
				end;
				if eaSendLetter in ExchangeForm.ExchangeActs then
				begin
					TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value := True;
					ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
					ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
					DoSendLetter;
					TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value := False;
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
				TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value := True;
				CheckNewExe;
				CheckNewFRF;
				CheckNewMDB;
        try
          //DM.adcUpdate.OnExecuteError := ThreadOnExecuteError;
          ImportData;
        finally
          //DM.adcUpdate.OnExecuteError := nil;
        end;

        DM.CheckDataIntegrity;

      	StatusText := 'Обновление завершено';
     	  Synchronize( SetStatus);
			end;

      ImportComplete := True;

      except
        on EFIB : EFIBError do
        begin
          WriteExchangeLog(
            'Exchange',
            'Ошибка при импорте данных:' + CRLF +
            'SQLCode       = ' + IntToStr(EFIB.SQLCode) + CRLF +
            'IBErrorCode   = ' + IntToStr(EFIB.IBErrorCode) + CRLF +
            'RaiserName    =  ' + EFIB.RaiserName + CRLF +
            'SQLMessage    = ' + EFIB.SQLMessage + CRLF +
            'IBMessage     = ' + EFIB.IBMessage + CRLF +
            'CustomMessage = ' + EFIB.CustomMessage + CRLF +
            'Msg           = ' + EFIB.Msg + CRLF +
            'Message       = ' + EFIB.Message);

          {
          Если получили ошибку целостности:
            1. Если не было запроса кумулятивного обновления, то откатываемся и запрашиваем КО
            2. Если запрос КО уже был, то высылаем данные в АК Инфорум и прерываем обновление

          Если это другая ошибка, то пишем сообщение и прерываем обмен данными
          }

          if ((EFIB.SQLCode = sqlcode_foreign_or_create_schema) or (EFIB.SQLCode = sqlcode_unique_violation))
          then begin
            WriteExchangeLog('Exchange', 'Нарушение целостности при импорте.');

            Progress := 0;
            Synchronize( SetProgress);
            StatusText := 'Откат изменений';
            Synchronize( SetStatus);
            DM.RestoreDatabase;
            //Если мы получили ошибку целостности данных, то мы должны выставить флаг "Получить кумулятивное обновление",
            //чтобы при любом обновлении сразу происходил запрос кумулятивное обновления
            DM.SetCumulative;

            if not (eaGetFullData in ExchangeForm.ExchangeActs) then
              //Если не было запроса кумулятивного обновления, то выставляем его и запрашиваем КО
              ExchangeForm.ExchangeActs := ExchangeForm.ExchangeActs + [eaGetPrice, eaGetFullData]
            else begin
              //Если запрос КО уже был, то отправляем тех. информацию в техподдержку и останавливаем обмен данными
              SendLetterWithTechInfo(
                'Ошибка целостности данных после запроса кумулятивного обновления',
                'У клиента возникла ошибка целостности данных после запроса кумулятивного обновления.');
              raise Exception.Create(
                'Ошибка получения обновления.'#13#10 +
                'Информация об ошибке отправлена в AK Инфорум.'#13#10 +
                'Пожалуйста, свяжитесь со службой техничесской поддержки для получения инструкций.');
            end;
          end
          else begin
            WriteExchangeLog('Exchange', 'Ошибка базы данных при импорте.');
            SendLetterWithTechInfo(
              'Ошибка базы данных при импорте данных',
              'У клиента возникла ошибка при работе с базой данных при импорте данных.');
            raise Exception.Create(
              'Ошибка получения обновления.'#13#10 +
              'Информация об ошибке отправлена в AK Инфорум.'#13#10 +
              'Пожалуйста, свяжитесь со службой техничесской поддержки для получения инструкций.');
          end;
        end;
        on E : EDelayOfPaymentsDataIntegrityException do begin
          SendLetterWithTechInfo(
            'Ошибка целостности базы данных в таблице отсрочек при импорте данных',
            'У клиента возникла ошибка целостности базы данных в таблице отсрочек при импорте данных.');
          StatusText := 'Обновление завершено';
          Synchronize( SetStatus);
          ImportComplete := True;
        end;
      end;

      until ImportComplete;

			{ Дожидаемся завершения работы дочерних ниток : рекламы, шпионской нитки }
			if ( [eaGetPrice, eaSendOrders] * ExchangeForm.ExchangeActs <> [])
      then begin
        TBooleanValue(ExchangeParams[Integer(epDownloadChildThreads)]).Value := True;
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
				if TStringValue(ExchangeParams[Integer(epErrorMessage)]).Value = '' then
          TStringValue(ExchangeParams[Integer(epErrorMessage)]).Value := RusError( E.Message);
				if TStringValue(ExchangeParams[Integer(epErrorMessage)]).Value = '' then
          TStringValue(ExchangeParams[Integer(epErrorMessage)]).Value := E.ClassName + ': ' + E.Message;
        if (E is EIdHTTPProtocolException) then
          TStringValue(ExchangeParams[Integer(epErrorMessage)]).Value :=
            'При выполнении вашего запроса произошла ошибка.'#13#10 +
            'Повторите запрос через несколько минут.'#13#10 +
            TStringValue(ExchangeParams[Integer(epErrorMessage)]).Value
        else
        if (E is EIdException) then
          TStringValue(ExchangeParams[Integer(epErrorMessage)]).Value :=
            'Проверьте подключение к Интернет.'#13#10 +
            TStringValue(ExchangeParams[Integer(epErrorMessage)]).Value;
			end;
		end;
    finally
      try DM.MainConnection.Close;
      except
        on E : Exception do
          WriteExchangeLog('Exchange', 'Ошибка при закрытии соединения : ' + E.Message);
      end;
      CoUninitialize;
    end;
	except
		on E: Exception do
      TStringValue(ExchangeParams[Integer(epErrorMessage)]).Value := E.Message;
	end;
	Synchronize( EnableCancel);
	TBooleanValue(ExchangeParams[Integer(epTerminated)]).Value := True;
end;

procedure TExchangeThread.HTTPConnect;
begin
	if DM.adtParams.FieldByName( 'ProxyConnect').AsBoolean
  then
    WriteExchangeLog('Exchange',
      'Используется proxy-сервер "' +
      DM.adtParams.FieldByName( 'ProxyName').AsString + ':' + DM.adtParams.FieldByName( 'ProxyPort').AsString + '"' +
      IfThen(DM.adtParams.FieldByName( 'ProxyUser').AsString <> '',
        ' с именем пользователя "' + DM.adtParams.FieldByName( 'ProxyUser').AsString + '"'));
	{ создаем экземпляр класса TSOAP для работы с SOAP через HTTP вручную }
  //Если запущены в DSP (для служебного пользования), то урл берется из настройки, если нет, то формируем автоматически
{$ifdef DSP}
  URL := DM.adtParams.FieldByName( 'HTTPHost').AsString + '/code.asmx';
{$else}
  if (FindCmdLineSwitch('extd')) and
    (DM.adtParams.FieldByName( 'HTTPHost').AsString <> '')
  then
    URL := 'https://' + DM.adtParams.FieldByName( 'HTTPHost').AsString+
           '/' + DM.SerBeg + DM.SerEnd + '/code.asmx'
  else
    URL := 'https://ios.analit.net/' + DM.SerBeg + DM.SerEnd + '/code.asmx';
{$endif}
  HTTPName := DM.adtParams.FieldByName( 'HTTPName').AsString;
  HTTPPass := DM.D_HP( DM.adtParams.FieldByName( 'HTTPPass').AsString );
	SOAP := TSOAP.Create(
    URL,
    HTTPName,
    HTTPPass,
    OnConnectError,
    ExchangeForm.HTTP);
end;

procedure TExchangeThread.CreateChildThreads;
var
  T : TThread;
begin
  if not ChildThreadClassIsExists(TReclameThread) then
  begin
    T := TReclameThread.Create( True);
    T.FreeOnTerminate := True;
    TReclameThread(T).RegionCode := DM.adtClients.FieldByName( 'RegionCode').AsString;
    TReclameThread(T).SetParams(ExchangeForm.HTTPReclame, URL, HTTPName, HTTPPass);
    T.OnTerminate := OnChildTerminate;
    TReclameThread(T).Resume;
    ChildThreads.Add(T);
  end;

  CreateChildSendArhivedOrdersThread;
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
      ParamValues[2] := GetLibraryVersionFromPath(ExePath + ExeName);
      ParamNames[3]  := 'MDBVersion';
      ParamValues[3] := DM.adtParams.FieldByName( 'ProviderMDBVersion').AsString;
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

    TStringValue(ExchangeParams[Integer(epServerAddition)]).Value := Utf8ToAnsi( Res.Values[ 'Addition']);
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
			TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value := True;
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
      ExchangeForm.HTTP.OnWork := HTTPWork;
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
        ExchangeForm.HTTP.OnWork := nil;
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
        if (FS.Size > 50*1024)
        then begin
          FS.Position := (FS.Size - 50*1024);
          Len := 50*1024;
        end
        else
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
      GetAbsentPriceCode();

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

procedure TExchangeThread.RasConnect;
var
  RasTimeout : Integer;
begin

	if DM.adtParams.FieldByName( 'RasConnect').AsBoolean then begin
      WriteExchangeLog('Exchange',
        'Используется удаленное соединение "' +
        DM.adtParams.FieldByName( 'RasEntry').AsString + '"' +
        IfThen(DM.adtParams.FieldByName( 'RasName').AsString <> '',
          ' с именем пользователя "' + DM.adtParams.FieldByName( 'RasName').AsString + '"'));
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
  try
    StatusText := 'Распаковка данных';
    Synchronize( SetStatus);
    if FindFirst( ExePath + SDirIn + '\*.zip', faAnyFile, SR) = 0 then
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

  try
  
    //Переименовываем файлы с кодом клиента в файлы без код клиента
    if FindFirst( ExePath + SDirIn + '\*.txt', faAnyFile, DeleteSR) = 0 then
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
	if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then
	begin
		StatusText := 'Очистка таблиц';
		Synchronize( SetStatus);
		DM.ClearDatabase;

		StatusText := 'Сжатие базы';
		Synchronize( SetStatus);
    DM.MainConnection.Close;
    try
      DM.CompactDatabase;
    finally
      DM.MainConnection.Open;
    end;
	end;
end;

procedure TExchangeThread.CheckNewFRF;
var
	SR: TSearchRec;
  SourceFile,
  DestFile : String;
begin
  try
    if FindFirst( ExePath + SDirIn + '\*.frf', faAnyFile, SR) = 0 then
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
  finally
    SysUtils.FindClose(SR);
  end;
end;

procedure TExchangeThread.ImportData;
var
	UpdateTables: TUpdateTables;
  deletedPriceCodes : TStringList;
  I : Integer;
  MainClientIdAllowDelayOfPayment : Variant;
begin
	Synchronize( ExchangeForm.CheckStop);
	Synchronize( DisableCancel);
	StatusText := 'Резервное копирование данных';
	Synchronize( SetStatus);
  if not DM.IsBackuped then
  	DM.BackupDatabase;

	TotalProgress := 65;
	Synchronize( SetTotalProgress);

	StatusText := 'Импорт данных';
	Synchronize( SetStatus);
	Progress := 0;
	Synchronize( SetProgress);
	DM.UnLinkExternalTables;
	DM.LinkExternalTables;

  UpdateTables := [];

	if (GetFileSize(ExePath+SDirIn+'\Catalogs.txt') > 0) then UpdateTables:=UpdateTables+[utCatalogs];
	if (GetFileSize(ExePath+SDirIn+'\CatDel.txt') > 0) then UpdateTables:=UpdateTables+[utCatDel];
	if (GetFileSize(ExePath+SDirIn+'\Clients.txt') > 0) then UpdateTables:=UpdateTables+[utClients];
	if (GetFileSize(ExePath+SDirIn+'\Providers.txt') > 0) then UpdateTables:=UpdateTables+[utProviders];
	if (GetFileSize(ExePath+SDirIn+'\RegionalData.txt') > 0) then UpdateTables:=UpdateTables+[utRegionalData];
	if (GetFileSize(ExePath+SDirIn+'\PricesData.txt') > 0) then UpdateTables:=UpdateTables+[utPricesData];
	if (GetFileSize(ExePath+SDirIn+'\PricesRegionalData.txt') > 0) then UpdateTables:=UpdateTables+[utPricesRegionalData];
	if (GetFileSize(ExePath+SDirIn+'\Core.txt') > 0) then UpdateTables:=UpdateTables+[utCore];
	if (GetFileSize(ExePath+SDirIn+'\Regions.txt') > 0) then UpdateTables:=UpdateTables+[utRegions];
	if (GetFileSize(ExePath+SDirIn+'\Synonyms.txt') > 0) then UpdateTables := UpdateTables + [utSynonyms];
	if (GetFileSize(ExePath+SDirIn+'\SynonymFirmCr.txt') > 0) then UpdateTables := UpdateTables + [utSynonymFirmCr];
	if (GetFileSize(ExePath+SDirIn+'\Rejects.txt') > 0) then UpdateTables := UpdateTables + [utRejects];
  //Удаляем минимальные цены, если есть обновления в Core
	if (GetFileSize(ExePath+SDirIn+'\Core.txt') > 0) then UpdateTables := UpdateTables + [utMinPrices];
	if (GetFileSize(ExePath+SDirIn+'\CatalogFarmGroups.txt') > 0) then UpdateTables := UpdateTables + [utCatalogFarmGroups];
	if (GetFileSize(ExePath+SDirIn+'\CatFarmGroupsDel.txt') > 0) then UpdateTables := UpdateTables + [utCatFarmGroupsDEL];
	if (GetFileSize(ExePath+SDirIn+'\CatalogNames.txt') > 0) then UpdateTables := UpdateTables + [utCatalogNames];
	if (GetFileSize(ExePath+SDirIn+'\Products.txt') > 0) then UpdateTables := UpdateTables + [utProducts];
  if (GetFileSize(ExePath+SDirIn+'\User.txt') > 0) then UpdateTables := UpdateTables + [utUser];
  if (GetFileSize(ExePath+SDirIn+'\DelayOfPayments.txt') > 0) then UpdateTables := UpdateTables + [utDelayOfPayments];
  if (GetFileSize(ExePath+SDirIn+'\Client.txt') > 0) then UpdateTables := UpdateTables + [utClient];


    //обновляем таблицы
    {
    Таблица               DELETE  INSERT  UPDATE
    --------------------  ------  ------  ------
    Catalog                 +       +       +
    Clients                 +       +       +
    User                    +       +          если получили таблицу User в обновлении, то тупо удаляем все и вставляем заново
    DelayOfPayments         +       +       +
    Providers               +       +       +
    Core                    +       +
    Prices                  +       +       +
    Regions                 +       +       +
    Synonym                         +
    SynonymFirmCr                   +
    CatalogFarmGroups       +       +       +
    CatalogNames                    +       +
    Products                        +       +
    MinPrices               +       +       +
    }

	Progress := 5;
	Synchronize( SetProgress);

   with DM.adcUpdate do begin

	//удаляем из таблиц ненужные данные: прайс-листы, регионы, поставщиков, которые теперь не доступны данному клиенту
	//PricesRegionalData
	if utPricesRegionalData in UpdateTables then begin
	  SQL.Text:='DELETE FROM PricesRegionalData WHERE NOT Exists(SELECT PriceCode, RegionCode FROM TmpPricesRegionalData  WHERE PriceCode=PricesRegionalData.PriceCode AND RegionCode=PricesRegionalData.RegionCode);';
    InternalExecute;
	end;
	//PricesData
	if utPricesRegionalData in UpdateTables then begin
	  SQL.Text:='DELETE FROM PricesData WHERE NOT Exists(SELECT FirmCode, PriceCode FROM tmpPricesData WHERE FirmCode=PricesData.FirmCode AND PriceCode=PricesData.PriceCode);';
    InternalExecute;
	end;
	//RegionalData
	if utPricesRegionalData in UpdateTables then begin
	  SQL.Text:='DELETE FROM RegionalData WHERE NOT Exists(SELECT FirmCode, RegionCode FROM tmpRegionalData WHERE FirmCode=RegionalData.FirmCode AND RegionCode=RegionalData.RegionCode);';
    InternalExecute;
	end;

  //Удаляем все настройки по отсрочкам, т.к. каждый раз они должны получаться полностью
  SQL.Text:='DELETE FROM DelayOfPayments;';
  InternalExecute;

  //todo: Providers почему здесь связь на utPricesRegionalData
	//Providers
	if utPricesRegionalData in UpdateTables then begin
	  SQL.Text:='DELETE FROM Providers WHERE NOT Exists(SELECT FirmCode FROM tmpProviders WHERE FirmCode=Providers.FirmCode);';
    InternalExecute;
	end;
	//Core
	if utCore in UpdateTables then begin
    //Удаление из Core старых прайсов и обновление ServerCoreID в MinPrices
    //SELECT cast(PriceCode as BIGINT) FROM ExtPricesData where Fresh = ''1''
    DM.adcUpdate.SQL.Text := 'SELECT PriceCode FROM tmpPricesData where Fresh = 1;';
    deletedPriceCodes := TStringList.Create;
    try

      //получили список обновленных файлов
      DM.adcUpdate.Open;
      try
        while not DM.adcUpdate.Eof do begin
          deletedPriceCodes.Add(DM.adcUpdate.FieldByName('PriceCode').AsString);
          DM.adcUpdate.Next;
        end
      finally
        DM.adcUpdate.Close;
      end;

      DM.adcUpdate.SQL.Text := 'delete from core where PriceCode = :PriceCode;';
      for I := 0 to deletedPriceCodes.Count-1 do begin
        DM.adcUpdate.ParamByName('PriceCode').AsString := deletedPriceCodes[i];
        InternalExecute;
      end;

    finally
      deletedPriceCodes.Free;
    end;

	  SQL.Text:='delete from minprices ;';
    InternalExecute;

    //здесь сбрасываем для всех неотправленных заказов состояние результата,
    //т.к. при восстановлении будем устанавливать заново
    SQL.Text := DM.GetClearSendResultSql(0);
    InternalExecute;
	end;
	if utCore in UpdateTables then begin
 	  SQL.Text:='DELETE FROM Core WHERE PriceCode is not null and NOT Exists(SELECT PriceCode, RegionCode FROM PricesRegionalData WHERE PriceCode=Core.PriceCode AND RegionCode=Core.RegionCode);';
    InternalExecute;
	end;
	//Clients
	if utClients in UpdateTables then begin
    SQL.Text:='DELETE FROM Clients WHERE NOT Exists(SELECT ClientId FROM tmpClients WHERE ClientId=Clients.ClientId);';
    InternalExecute;
	end;
	//Regions
	if utRegions in UpdateTables then begin
	  SQL.Text:='DELETE FROM Regions WHERE NOT Exists(SELECT RegionCode FROM tmpRegions WHERE RegionCode=Regions.RegionCode);';
    InternalExecute;
	end;

  DM.MainConnection.Close;

  DM.MainConnection.Open;

	Progress := 10;
	Synchronize( SetProgress);

	//добавляем в таблицы новые данные и изменяем имеющиеся
	//CatalogNames
	if utCatalogNames in UpdateTables then begin
	  if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('catalognames', ExePath+SDirIn+'\CatalogNames.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('catalognames', ExePath+SDirIn+'\CatalogNames.txt', true);
      InternalExecute;
    end;
	end;

	//Catalog
	if utCatalogs in UpdateTables then begin

	  if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('Catalogs', ExePath+SDirIn+'\Catalogs.txt');
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('Catalog RowAffected = %d', [RowsAffected]));
{$endif}
    end
    else begin
      //catalogs_iu
      SQL.Text := GetLoadDataSQL('Catalogs', ExePath+SDirIn+'\Catalogs.txt', true);
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('Catalog RowAffected = %d', [RowsAffected]));
{$endif}
      if utCatDel in UpdateTables then begin
        UpdateFromFileByParamsMySQL(
          ExePath+SDirIn+'\CatDel.txt',
          'delete from catalogs where (fullcode = :fullcode)',
          ['fullcode']);
      end;
    end;
	  SQL.Text:='UPDATE CATALOGS SET Form = '''' WHERE Form IS Null;';
    InternalExecute;
	end;

  if (utProducts in UpdateTables) then begin
	  if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('Products', ExePath+SDirIn+'\Products.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('Products', ExePath+SDirIn+'\Products.txt', true);
      InternalExecute;
    end;
  end;

	//CatalogFarmGroups
	if utCatalogFarmGroups in UpdateTables then begin
	  if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('CatalogFarmGroups', ExePath+SDirIn+'\CatalogFarmGroups.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('CatalogFarmGroups', ExePath+SDirIn+'\CatalogFarmGroups.txt', true);
      InternalExecute;
      if utCatFarmGroupsDel in UpdateTables then begin
        UpdateFromFileByParamsMySQL(
          ExePath+SDirIn+'\CatFarmGroupsDel.txt',
          'delete from catalogfarmgroups where (ID = :ID)',
          ['ID']);
      end;
    end;
	end;

	Progress := 20;
	Synchronize( SetProgress);
	TotalProgress := 70;
	Synchronize( SetTotalProgress);

	//Regions
	if utRegions in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('Regions', ExePath+SDirIn+'\Regions.txt', true);
    InternalExecute;
	end;
  //User
  if utUser in UpdateTables then begin
    SQL.Text := 'delete from analitf.userinfo';
    InternalExecute;
    SQL.Text := GetLoadDataSQL('UserInfo', ExePath+SDirIn+'\User.txt', true);
    InternalExecute;
	end;
  //Client
  if utClient in UpdateTables then begin
    SQL.Text := 'delete from analitf.Client';
    InternalExecute;
    SQL.Text := GetLoadDataSQL('Client', ExePath+SDirIn+'\Client.txt', true);
    InternalExecute;
  end;
	//Clients
	if utClients in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('Clients', ExePath+SDirIn+'\Clients.txt', true);
    InternalExecute;
	end;
	//Providers
	if utProviders in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('Providers', ExePath+SDirIn+'\Providers.txt', true);
    InternalExecute;
	end;
  if utDelayOfPayments in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('DelayOfPayments', ExePath+SDirIn+'\DelayOfPayments.txt', true);
    InternalExecute;
	end;
	//RegionalData
	if utRegionalData in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('RegionalData', ExePath+SDirIn+'\RegionalData.txt', true);
    InternalExecute;
	end;
	//PricesData
	if utPricesData in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('PricesData', ExePath+SDirIn+'\PricesData.txt', true);
    InternalExecute;
	end;
	//PricesRegionalData
	if utPricesData in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('PricesRegionalData', ExePath+SDirIn+'\PricesRegionalData.txt', true);
    InternalExecute;
	end;

	Progress := 30;
	Synchronize( SetProgress);

	//Synonym
	if utSynonyms in UpdateTables then begin
	  if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('Synonyms', ExePath+SDirIn+'\Synonyms.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('Synonyms', ExePath+SDirIn+'\Synonyms.txt', true);
      InternalExecute;
    end;
	end;
	//SynonymFirmCr
	if utSynonymFirmCr in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('SynonymFirmCr', ExePath+SDirIn+'\SynonymFirmCr.txt', true);
    InternalExecute;
	end;
	//Core
	if utCore in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('Core', ExePath+SDirIn+'\Core.txt');
    InternalExecute;
	end;

  DM.MainConnection.Close;
  DM.MainConnection.Open;

	Progress := 40;
	Synchronize( SetProgress);
	SQL.Text := 'DELETE FROM Core WHERE SynonymCode<0;'; InternalExecute;
	Progress := 50;
	Synchronize( SetProgress);

  {todo: подумать, а может быть цены с отсрочками рассчитывать при обновлении,
  чтобы во время работы не переливать из пустого в порожнее}
  //проставляем мин. цены и лидеров
  if utMinPrices in UpdateTables then begin
    //Пытаем получить код "основного" клиента
    //Если не null, то для основного клиента включен механизм отсрочек
    MainClientIdAllowDelayOfPayment := DM.QueryValue(''
      +'select Clients.ClientId '
      +'from   Clients, '
      +'       Userinfo '
      +'where  (Clients.CLIENTID = Userinfo.ClientId) '
      +'   and (Clients.AllowDelayOfPayment = 1)',
      [],
      []);
    if VarIsNull(MainClientIdAllowDelayOfPayment) then begin
      SQL.Text := ''
        + 'INSERT IGNORE '
        + 'INTO    MinPrices '
        + '(ProductId, RegionCode, MinCost) '
        + 'SELECT '
        + '  ProductId, '
        + '  RegionCode, '
        + '  min(Cost) '
        + 'FROM    Core '
        + 'GROUP BY ProductId, RegionCode';
      InternalExecute;
    end
    else begin
      SQL.Text := ''
        + 'INSERT IGNORE '
        + 'INTO    MinPrices '
        + '(ProductId, RegionCode, MinCost) '
        +'select   ProductId , '
        +'         RegionCode, '
        +'         min(Cost * (1 + Delayofpayments.Percent/100)) '
        +'from     Core      , '
        +'         Pricesdata, '
        +'         Delayofpayments '
        +'where    (Pricesdata.PRICECODE     = Core.Pricecode) '
        +'and      (Delayofpayments.FirmCode = pricesdata.Firmcode) '
        +'group by ProductId, '
        +'         RegionCode';
      InternalExecute;
    end;
  end;
  Progress := 60;
	Synchronize( SetProgress);
	TotalProgress := 75;
	Synchronize( SetTotalProgress);

  DM.MainConnection.Close;
  DM.MainConnection.Open;

	StatusText := 'Импорт данных';
	Synchronize( SetStatus);

	SQL.Text := 'update catalogs set CoreExists = 0 where FullCode > 0'; InternalExecute;
	SQL.Text := 'update catalogs set CoreExists = 1 where FullCode > 0 and exists(select * from core c, products p where p.catalogid = catalogs.fullcode and c.productid = p.productid)';
  InternalExecute;
	Progress := 65;
	Synchronize( SetProgress);
  DM.adtParams.Close;
  DM.adtParams.Open;
	if DM.adtParams.FieldByName( 'OperateFormsSet').AsBoolean then
	begin
		Progress := 70;
		Synchronize( SetProgress);
		SQL.Text :=
      'insert into Core (ProductId, SynonymCode) ' +
      'select products.productid, -products.catalogid ' +
      'from ' +
         'products, ' +
      '(' +
       'select DISTINCT CATALOGS.FullCode ' +
         'from ' +
           'core ' +
           'inner join products on products.productid = core.productid ' +
           'inner join CATALOGS ON CATALOGS.FullCode = products.catalogid ' +
      ') distinctfulcodes ' +
      'where ' +
         'products.catalogid = distinctfulcodes.FullCode ' +
      'group by products.CATALOGID';
    InternalExecute;
		Progress := 80;
		Synchronize( SetProgress);
	end;

  SQL.Text:='update params set OperateForms = OperateFormsSet where ID = 0'; InternalExecute;

	TotalProgress := 80;
	Synchronize( SetTotalProgress);

	{ Добавляем забракованые препараты }
	if utRejects in UpdateTables then
	begin
    SQL.Text := GetLoadDataSQL('Defectives', ExePath+SDirIn+'\Rejects.txt', True);
    InternalExecute;
	end;

  //todo: Здесь возможно засада, т.к. идет обработка AfterOpen и поэтому возможна ошибка "Canvas does not drawing"
  //Это нужно, чтобы обновилась информация о клиенте, отображаемая на главной форме
  DM.adtClients.Close;
  DM.adtClients.Open;
	//проставляем мин. цены и лидеров
	if utMinPrices in UpdateTables then
	begin
    //Пытаем получить код "основного" клиента
    //Если не null, то для основного клиента включен механизм отсрочек
    MainClientIdAllowDelayOfPayment := DM.QueryValue(''
      +'select Clients.ClientId '
      +'from   Clients, '
      +'       Userinfo '
      +'where  (Clients.CLIENTID = Userinfo.ClientId) '
      +'   and (Clients.AllowDelayOfPayment = 1)',
      [],
      []);
    if VarIsNull(MainClientIdAllowDelayOfPayment) then begin
      SQL.Text := ''
        + 'UPDATE '
        + '  MinPrices, '
        + '  Core '
        + 'SET '
        + '  MinPrices.SERVERCOREID = Core.ServerCoreId, '
        + '  MinPrices.PriceCode  = Core.PriceCode '
        + 'WHERE '
        + '    Core.ProductId  = MinPrices.ProductId '
        + 'and Core.RegionCode = MinPrices.RegionCode '
        + 'and Core.Cost       = MinPrices.MinCost';
      InternalExecute;
    end
    else begin
      SQL.Text := ''
        + 'UPDATE '
        + '  MinPrices, '
        + '  Core, '
        + '  Pricesdata, '
        + '  Delayofpayments '
        + 'SET '
        + '  MinPrices.SERVERCOREID = Core.ServerCoreId, '
        + '  MinPrices.PriceCode  = Core.PriceCode '
        + 'WHERE '
        + '    (Core.ProductId  = MinPrices.ProductId) '
        + 'and (Core.RegionCode = MinPrices.RegionCode) '
        + 'and (Pricesdata.PRICECODE     = Core.Pricecode) '
        + 'and (Delayofpayments.FirmCode = pricesdata.Firmcode) '
        + 'and (cast((Core.Cost * (1 + Delayofpayments.Percent/100)) as decimal(18, 2)) = MinPrices.MinCost)';
      InternalExecute;
    end;
  end;

	Progress := 90;
	Synchronize( SetProgress);
	TotalProgress := 85;
	Synchronize( SetTotalProgress);

	SQL.Text := ''
+'UPDATE pricesregionaldata                    , '
+'       ( SELECT  Pricesdata.PriceCode        , '
+'                pricesregionaldata.regioncode, '
+'                COUNT(core.Servercoreid) AS PriceCount '
+'       FROM ( Pricesdata, pricesregionaldata) '
+'                LEFT JOIN core '
+'                ON       core.PriceCode      = Pricesdata.PriceCode '
+'                     AND Core.RegionCode     = pricesregionaldata.RegionCode '
+'       WHERE    pricesregionaldata.pricecode = Pricesdata.pricecode '
+'       GROUP BY Pricesdata.PriceCode, '
+'                pricesregionaldata.RegionCode '
+'       ) PriceSizes '
+'SET    pricesregionaldata.pricesize  = PriceSizes.PriceCount '
+'WHERE  pricesregionaldata.pricecode  = PriceSizes.pricecode '
+'   AND pricesregionaldata.regioncode = PriceSizes.regioncode';
	InternalExecute;

  DM.MainConnection.Close;
  DM.MainConnection.Open;

	Progress := 100;
	Synchronize( SetProgress);
	TotalProgress := 90;
	Synchronize( SetTotalProgress);
  end; {with DM.adcUpdate do begin}

  DM.MainConnection.Close;
  DM.MainConnection.Open;

	DM.UnLinkExternalTables;

  DM.ClearBackup;

  Dm.MainConnection.AfterConnect(Dm.MainConnection);
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
  try
  //Здесь надо все переделать в связи с требованием #1632 Ошибка при обновлении
  if Assigned(Sender) then
    ChildThreads.Remove(Sender);
  except
  end;
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
      //Здесь надо все переделать в связи с требованием #1632 Ошибка при обновлении
      //надо логировать сообщение об ошибке при останове нитки
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

destructor TExchangeThread.Destroy;
begin
  if Assigned(AbsentPriceCodeSL) then
    AbsentPriceCodeSL.Free;
  if Assigned(ChildThreads) then
    try ChildThreads.Free; except end;
  inherited;
end;

procedure TExchangeThread.GetAbsentPriceCode;
var
  absentQuery : TMyQuery;
begin
  try

    absentQuery := TMyQuery.Create(nil);
    absentQuery.Connection := DM.MainConnection;
    try
      absentQuery.SQL.Text := ''
+'SELECT DISTINCT c.Pricecode '
+'FROM    core c '
+'        LEFT JOIN synonyms s '
+'        ON      s.synonymcode = c.synonymcode '
+'        LEFT JOIN synonymfirmcr sfc '
+'        ON      sfc.synonymfirmcrcode = c.synonymfirmcrcode '
+'WHERE (c.synonymcode > 0) '
+'    AND ((s.synonymcode IS NULL) '
+'     OR ((c.synonymfirmcrcode is not null) and (sfc.synonymfirmcrcode IS NULL)))';

      absentQuery.Open;
      try
        if absentQuery.RecordCount > 0 then begin
          AbsentPriceCodeSL := TStringList.Create;
          while not absentQuery.Eof do begin
            AbsentPriceCodeSL.Add(absentQuery.FieldByName('PRICECODE').AsString);
            absentQuery.Next;
          end;
        end;
      finally
        absentQuery.Close;
      end;
    finally
      absentQuery.Free;
    end;

  except
    on E : Exception do
      WriteExchangeLog('GetAbsentPriceCode.Error', E.Message);
  end;
end;

procedure TExchangeThread.GetPass;
var
  Res : TStrings;
  Error : String;
begin
  TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value := True;
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
  DMSavePass;
  TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value := False;
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
  TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value := True;
  if DM.adsQueryValue.Active then
   	DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text := '' +
      '  select '
    + ' prd.pricecode, prd.regioncode, prd.injob '
    + ' from '
    + '   pricesregionaldata prd '
    + '   inner join pricesregionaldataup prdu on prdu.PriceCode = prd.PriceCode and prdu.RegionCode = prd.regioncode';
	DM.adsQueryValue.Open;
  //Отправляем настройки только в том случае, если есть что отправлять
	if not DM.adsQueryValue.Eof then
	begin
		StatusText := 'Отправка настроек прайс-листов';
		Synchronize( SetStatus);
    SetLength(ParamNames, StaticParamCount + DM.adsQueryValue.RecordCount*4);
    SetLength(ParamValues, StaticParamCount + DM.adsQueryValue.RecordCount*4);
    ParamNames[0] := 'UniqueID';
    ParamValues[0] := IntToHex( GetCopyID, 8);
    I := 0;
    while not DM.adsQueryValue.Eof do begin
      //PriceCodes As Int32(), ByVal RegionCodes As Int32(), ByVal INJobs As Boolean(), ByVal UpCosts
      ParamNames[StaticParamCount+i*4] := 'PriceCodes';
      ParamValues[StaticParamCount+i*4] := DM.adsQueryValue.FieldByName('PriceCode').AsString;
      ParamNames[StaticParamCount+i*4+1] := 'RegionCodes';
      ParamValues[StaticParamCount+i*4+1] := DM.adsQueryValue.FieldByName('RegionCode').AsString;
      ParamNames[StaticParamCount+i*4+2] := 'INJobs';
      ParamValues[StaticParamCount+i*4+2] := BoolToStr(DM.adsQueryValue.FieldByName('INJob').AsBoolean, True);
      ParamNames[StaticParamCount+i*4+3] := 'UpCosts';
      //TODO: Пока здесь передаем 0, потом этот параметр надо удалить 
      ParamValues[StaticParamCount+i*4+3] := '0.0';
      DM.adsQueryValue.Next;
      Inc(i);
    end;
    DM.adsQueryValue.Close;
    Res := SOAP.Invoke( 'PostPriceDataSettings', ParamNames, ParamValues);
    Error := Utf8ToAnsi( Res.Values[ 'Error']);
    if Error <> '' then
      raise Exception.Create( Error + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));
    with DM.adcUpdate do begin
      //удаляем признак того, что настройки прайс-листов были изменены
      SQL.Text := 'delete from pricesregionaldataup';
      Execute;
    end;
	end
  else
    DM.adsQueryValue.Close;
  TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value := False;
end;

procedure TExchangeThread.HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
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

	if TBooleanValue(ExchangeParams[Integer(epCriticalError)]).Value then
    Abort;
end;

procedure TExchangeThread.SetDownStatus;
begin
  ExchangeForm.stStatus.Caption := StatusText; 
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

procedure TExchangeThread.ExtractDocs(DirName: String);
var
  DocsSR: TSearchRec;
begin
  if DirectoryExists(ExePath + SDirIn + '\' + DirName) then begin
    try
      if FindFirst( ExePath + SDirIn + '\' + DirName + '\*.*', faAnyFile, DocsSR) = 0 then
        repeat
          if (DocsSR.Name <> '.') and (DocsSR.Name <> '..') then
            OSMoveFile(
              ExePath + SDirIn + '\' + DirName + '\' + DocsSR.Name,
              ExePath + DirName + '\' + DocsSR.Name);
        until (FindNext( DocsSR ) <> 0)
    finally
      SysUtils.FindClose( DocsSR );
    end;
    AProc.RemoveDirectory(ExePath + SDirIn + '\' + DirName);
  end;
end;

procedure TExchangeThread.OnFullChildTerminate(Sender : TObject);
begin
  try
  //Здесь надо все переделать в связи с требованием #1632 Ошибка при обновлении
  if Assigned(Sender) then 
    ChildThreads.Remove(Sender);
  if (ChildThreads.Count = 0) and ( [eaGetPrice, eaSendOrders, eaGetWaybills, eaSendLetter] * ExchangeForm.ExchangeActs <> [])
  then begin
    HTTPDisconnect;
    RasDisconnect;
  end;
  except
  end;
end;

procedure TExchangeThread.CreateChildSendArhivedOrdersThread;
var
  T : TThread;
begin
  if not ChildThreadClassIsExists(TSendArchivedOrdersThread) then begin
    T := TSendArchivedOrdersThread.Create(True);
    TSendArchivedOrdersThread(T).SetParams(ExchangeForm.httpReceive, URL, HTTPName, HTTPPass);
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

constructor TExchangeThread.Create(CreateSuspended: Boolean);
begin
  inherited;
  ExchangeParams := TObjectList.Create(True);
  TExchangeParamsHelper.InitExchangeParams(ExchangeParams);
end;

function TExchangeThread.ChildThreadClassIsExists(
  ChildThreadClass: TReceiveThreadClass): Boolean;
var
  I : Integer;
begin
  Result := False;
  for I := 0 to ChildThreads.Count -1 do
    if ChildThreads[i] is ChildThreadClass then begin
      Result := True;
      Break;
    end;
end;

procedure TExchangeThread.SendLetterWithTechInfo(Subject, Body: String);
var
  Attachs : TStringList;
  I : Integer;

  procedure AddFile(FileName : String);
  begin
    if Attachs.IndexOf(FileName) = -1 then
      Attachs.Add(FileName);
  end;

begin
  try
    //Не позволяем дочерним ниткам разрывать соединение
    if ChildThreads.Count > 0 then
      for I := ChildThreads.Count-1 downto 0 do
        TThread(ChildThreads[i]).OnTerminate := OnChildTerminate;

    //Производим подключение, если его нет
    RasConnect;
    HTTPConnect;

    Attachs := TStringList.Create;
    Attachs.CaseSensitive := False;
    try

      AddFile(ExeName + '.TR');
      AddFile(ExeName + '.old.TR');
      AddFile(ExePath + 'Exchange.log');
      AddFile(ExePath + 'AnalitFup.log');

      AProc.InternalDoSendLetter(
        ExchangeForm.HTTP,
        URL,
        'AFTechSend',
        Attachs,
        Subject,
        Body + #13#10 + 'Смотрите вложения.'#13#10 + 'С уважением,'#13#10 + '  AnalitF.exe');
    finally
      Attachs.Free;
    end;
  except
    on E : Exception do
      WriteExchangeLog('Exchange',
        'При отправке письма с технической информацией произошла ошибка : ' + E.Message);
  end;
end;

procedure TExchangeThread.UpdateFromFileByParamsMySQL(FileName,
  InsertSQL: String; Names: array of string; LogSQL: Boolean);
var
  up : TMyQuery;
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
  LogText : String;
begin
  up := TMyQuery.Create(nil);
  SetLength(Values, Length(Names));
  try
    up.Connection := DM.MainConnection;

    InDelimitedFile := TFIBInputDelimitedFile.Create;
    try
      InDelimitedFile.SkipTitles := False;
      InDelimitedFile.ReadBlanksAsNull := True;
      InDelimitedFile.ColDelimiter := Chr(9);
      InDelimitedFile.RowDelimiter := #13#10;

      up.SQL.Text := InsertSQL;
      InDelimitedFile.Filename := FileName;

      if LogSQL then
        Tracer.TR('Import', 'Exec : ' + InsertSQL);
      try

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
                  up.ParamByName(Names[i]).Clear
                else
                  up.ParamByName(Names[i]).AsString := Values[i];
              up.Execute;
            end;
          until FEOF;
        finally
          StopExec := Now;
          Secs := SecondsBetween(StopExec, StartExec);
          if (Secs > 3) and LogSQL then
            Tracer.TR('Import', 'ExcecTime : ' + IntToStr(Secs));
        end;

      except
        on E : Exception do
        begin
          LogText := 'FileName : ' + FileName + CRLF +
            ' ErrorMessage : ' + E.Message + CRLF;
          if up.ParamCount > 0 then begin
            LogText := LogText + '  Params ( ';
            for I := 0 to up.ParamCount-1 do
              LogText := LogText +
                up.Params.Items[i].Name + ' : ' + up.Params.Items[i].AsString + ';';
            LogText := LogText + ' )';
          end;
          //TODO: Пока эта информация пишется в Exchange.log, возможно ее стоит убрать
          WriteExchangeLog('Exchange.UpdateFromFileByParamsMySQL', LogText);
          raise;
        end;
      end;

    finally
      InDelimitedFile.Free;
    end;

  finally
    up.Free;
  end;
end;

procedure TExchangeThread.InternalExecute;
var
  StopExec : TDateTime;
  Secs : Int64;
begin
  Tracer.TR('Import', 'Exec : ' + DM.adcUpdate.SQL.Text);
  StartExec := Now;
  try
    DM.adcUpdate.Execute;
  finally
    StopExec := Now;
    Secs := SecondsBetween(StopExec, StartExec);
    if Secs > 3 then
      Tracer.TR('Import', 'ExcecTime : ' + IntToStr(Secs));
  end;
end;

procedure TExchangeThread.DoSendSomeOrders;
var
  postController : TPostSomeOrdersController;
begin
  Synchronize( ExchangeForm.CheckStop);
  Synchronize( DisableCancel);
  StatusText := 'Отправка заказов';
  Synchronize( SetStatus);

  postController := TPostSomeOrdersController
    .Create(DM, ExchangeParams, eaForceSendOrders in ExchangeForm.ExchangeActs, Soap);
  try
    postController.PostSomeOrders;
  finally
    postController.Free;
    StatusText := '';
    Synchronize( SetStatus);
  end;
  
  Synchronize( EnableCancel);
end;

initialization
finalization
  UnloadSevenZipDLL;
end.
