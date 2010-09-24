unit ExchangeThread;

interface

uses
  Classes, SysUtils, Windows, StrUtils, ComObj, Variants,
  SOAPThroughHTTP, DateUtils, ShellAPI, ExtCtrls, RecThread, ActiveX,
  IdException, WinSock, RxVerInf, DB, 
  SevenZip,
  IdStackConsts, infvercls, Contnrs, IdHashMessageDigest,
  DADAuthenticationNTLM, IdComponent, IdHTTP, FileUtil, 
  U_frmOldOrdersDelete, U_RecvThread, IdStack, MyAccess, DBAccess,
  DataIntegrityExceptions, PostSomeOrdersController, ExchangeParameters,
  DatabaseObjects, HFileHelper, NetworkAdapterHelpers, PostWaybillsController,
  ArchiveHelper;

type

TUpdateTable = (
  utCatalogs,
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
  utClient,
  utMNN,
  utDescriptions,
  utMaxProducerCosts,
  utProducers,
  utMinReqRules,
  utBatchReport);

TUpdateTables = set of TUpdateTable;

TExchangeThread = class( TThread)
 public
  ExchangeParams : TExchangeParams;
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
  ASaveGridMask : String;
  CostSessionKey : String;
  URL : String;
  HTTPName,
  HTTPPass : String;
  StartDownPosition : Integer;
  //Уникальный идентификатор обновления, должен передаваться при подтверждении
  UpdateId : String;

  HostFileName, LocalFileName: string;

  //Список дочерних ниток
  ChildThreads : TObjectList;

  hfileHelper : THFileHelper;
  ChangeHFile : boolean;
  NewHFile : String;

  ChangenahFile : Boolean;
  NewnahSetting : String;
  NAHChanged    : Boolean;
  PreviousAdapter : TNetworkAdapterSettings;

  CheckSendUData : Boolean;

  //Используется при получении истории заказов с сервера
  MaxOrderId : String;

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
  function  GetEncodedBatchFileContent : String;
  procedure GetMaxIds(var MaxOrderId, MaxOrderListId, MaxBatchId : String);
  procedure GetMaxPostedIds(var MaxOrderId, MaxOrderListId : String);
  procedure GetPostedServerOrderId(PostParams : TStringList);
  procedure SendULoginData;
  procedure GetPass;
  procedure PriceDataSettings;
  procedure CommitExchange;
  procedure DoExchange;
  procedure DoSendLetter;
  procedure DoSendSomeOrders;
  procedure DoSendWaybills;
  procedure HTTPDisconnect;
  procedure RasDisconnect;
  procedure UnpackFiles;
  procedure ImportData;
  procedure ImportBatchReport;
  procedure CheckNewExe;
  procedure CheckNewMDB;
  procedure CheckNewFRF;
  procedure GetAbsentPriceCode;

  procedure GetHistoryOrders;
  procedure CommitHistoryOrders;
  procedure ImportHistoryOrders;


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
  procedure UpdateClientFile(ClientContent : String);
  procedure UpdateClientNAHFile(NAHState : Boolean; NAHSetting : String);
  //Получить UIN у Роста
  function  GetRSTUIN : String;

  procedure CheckFieldAfterUpdate(fieldName : String);
  procedure ProcessClientToAddressMigration;
protected
  procedure Execute; override;
public
  constructor Create(CreateSuspended: Boolean);
  destructor Destroy; override;
end;

implementation

uses Exchange, DModule, AProc, Main, Retry, 
  LU_Tracer, Math, DBProc, U_frmSendLetter,
  Constant, U_ExchangeLog, U_SendArchivedOrdersThread, ULoginHelper,
  Registry;

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
      if ( [eaGetPrice, eaSendOrders, eaGetWaybills, eaSendLetter, eaSendWaybills, eaPostOrderBatch, eaGetHistoryOrders] * ExchangeForm.ExchangeActs <> [])
      then
      begin
        RasConnect;
        HTTPConnect;
        TotalProgress := 10;
        Synchronize( SetTotalProgress);
        //Отправяем настройки прайс-листов при запросе данных (обычно или кумулятивном)
        if ([eaGetPrice, eaPostOrderBatch] * ExchangeForm.ExchangeActs <> [])
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
          ExchangeParams.CriticalError := True;
          ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
          ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
          DoSendSomeOrders;
          ExchangeParams.CriticalError := False;
        end;
        if eaSendLetter in ExchangeForm.ExchangeActs then
        begin
          ExchangeParams.CriticalError := True;
          ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
          ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
          DoSendLetter;
          ExchangeParams.CriticalError := False;
        end;
        //DoSendWaybills
        if (eaSendWaybills in ExchangeForm.ExchangeActs)
          and not DM.adsUser.IsEmpty
          and DM.adsUser.FieldByName('ParseWaybills').AsBoolean
          and DM.adsUser.FieldByName('SendWaybillsFromClient').AsBoolean
        then
        begin
          ExchangeParams.CriticalError := True;
          ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
          ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
          DoSendWaybills;
          ExchangeParams.CriticalError := False;
        end;

        TotalProgress := 20;
        Synchronize( SetTotalProgress);
        if ([eaGetPrice, eaGetWaybills, eaSendWaybills, eaPostOrderBatch] * ExchangeForm.ExchangeActs <> [])
           and not DM.NeedCommitExchange
        then
        begin
          ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
          ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута

          //Запускаем дочерние нитки только тогда, когда получаем обновление данных, но не накладные
          if eaGetPrice in ExchangeForm.ExchangeActs
          then
            CreateChildThreads;

          Synchronize( ExchangeForm.CheckStop);
          try
{$ifndef DEBUG}
            Synchronize( DisableCancel);
{$endif}
            QueryData;
            GetPass;
          finally
{$ifndef DEBUG}
            Synchronize( EnableCancel);
{$endif}
          end;
          
          if CheckSendUData or (NAHChanged and Assigned(PreviousAdapter))
          then
            SendULoginData;
          if eaGetFullData in ExchangeForm.ExchangeActs then
            DM.SetCumulative;
          ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
          ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута
          DoExchange;
        end;

        if ([eaGetHistoryOrders] * ExchangeForm.ExchangeActs <> [])
        then
        begin
          ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
          ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута

          GetHistoryOrders;

          ExchangeForm.HTTP.ReadTimeout := 0; // Без тайм-аута
          ExchangeForm.HTTP.ConnectTimeout := -2; // Без тайм-аута

          if not ExchangeParams.FullHistoryOrders
          then
            DoExchange;
        end;

        TotalProgress := 40;
        Synchronize( SetTotalProgress);
      end;

      { Распаковка файлов }
      if ( [eaGetPrice, eaImportOnly, eaGetWaybills, eaSendWaybills, eaPostOrderBatch] * ExchangeForm.ExchangeActs <> [])
      then
        UnpackFiles;

      if ([eaGetHistoryOrders] * ExchangeForm.ExchangeActs <> [])
         and not ExchangeParams.FullHistoryOrders
      then
        UnpackFiles;

      { Поддтверждение обмена }
      if [eaGetPrice, eaGetWaybills, eaSendWaybills, eaPostOrderBatch] * ExchangeForm.ExchangeActs <> []
      then
        CommitExchange;

      if ([eaGetHistoryOrders] * ExchangeForm.ExchangeActs <> [])
         and not ExchangeParams.FullHistoryOrders
         and (Length(UpdateId) > 0)
      then
        CommitHistoryOrders;

      { Отключение }
      if ( [eaGetWaybills, eaSendLetter, eaSendWaybills] * ExchangeForm.ExchangeActs <> []) then
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

      if ([eaGetHistoryOrders] * ExchangeForm.ExchangeActs <> [])
         and not ExchangeParams.FullHistoryOrders
      then
        ImportHistoryOrders;

      if ( [eaGetPrice, eaImportOnly, eaPostOrderBatch] * ExchangeForm.ExchangeActs <> []) then
      begin
        TotalProgress := 50;
        Synchronize( SetTotalProgress);
        ExchangeParams.CriticalError := True;
        CheckNewExe;
        CheckNewFRF;
        CheckNewMDB;
        try
          //DM.adcUpdate.OnExecuteError := ThreadOnExecuteError;
          ImportData;
        finally
{$ifndef DEBUG}
          //Надо перенести загрузку разобранных документов в другое место,
          //т.к. после удаления файлов с разобранными документами не будет
          { очищаем папку In }
          DeleteFilesByMask( ExePath + SDirIn + '\*.txt');
{$endif}
          //DM.adcUpdate.OnExecuteError := nil;
        end;

        DM.CheckDataIntegrity;

        StatusText := 'Обновление завершено';
         Synchronize( SetStatus);
      end;

      ImportComplete := True;

      except
{
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

          Если получили ошибку целостности:
            1. Если не было запроса кумулятивного обновления, то откатываемся и запрашиваем КО
            2. Если запрос КО уже был, то высылаем данные в АК Инфорум и прерываем обновление

          Если это другая ошибка, то пишем сообщение и прерываем обмен данными

          if ((EFIB.SQLCode = sqlcode_foreign_or_create_schema) or (EFIB.SQLCode = sqlcode_unique_violation))
          then begin
            WriteExchangeLog('Exchange', 'Нарушение целостности при импорте.');

            Progress := 0;
            Synchronize( SetProgress);
            StatusText := 'Откат изменений';
            Synchronize( SetStatus);
            DatabaseController.RestoreDatabase;
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
                'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.');
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
              'Пожалуйста, свяжитесь со службой технической поддержки для получения инструкций.');
          end;
        end;
}        
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
        ExchangeParams.DownloadChildThreads := True;
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
        if ExchangeParams.ErrorMessage = '' then
          ExchangeParams.ErrorMessage := RusError( E.Message);
        if ExchangeParams.ErrorMessage = '' then
          ExchangeParams.ErrorMessage := E.ClassName + ': ' + E.Message;
        if (E is EIdHTTPProtocolException) then
          ExchangeParams.ErrorMessage :=
            'При выполнении вашего запроса произошла ошибка.'#13#10 +
            'Повторите запрос через несколько минут.'#13#10 +
            ExchangeParams.ErrorMessage
        else
        if (E is EIdException) then
          ExchangeParams.ErrorMessage :=
            'Проверьте подключение к Интернет.'#13#10 +
            ExchangeParams.ErrorMessage;
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
      ExchangeParams.ErrorMessage := E.Message;
  end;
  Synchronize( EnableCancel);
  ExchangeParams.Terminated := True;
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
{$ifdef UsePrgDataTest}
    URL := 'https://test.analit.net/' + DM.SerBeg + DM.SerEnd + '/code.asmx';
{$else}
    URL := 'https://ios.analit.net/' + DM.SerBeg + DM.SerEnd + '/code.asmx';
{$endif}
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
  if not ChildThreadClassIsExists(TReclameThread)
    and (DM.adsUser.FieldByName('ShowAdvertising').IsNull
         or DM.adsUser.FieldByName('ShowAdvertising').AsBoolean)
  then
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
  StaticParamCount : Integer = 12;
var
  Res: TStrings;
  LibVersions: TObjectList;
  Error : String;
  ParamNames, ParamValues : array of String;
  I : Integer;
  WinNumber, WinDesc : String;
  fi : TFileUpdateInfo;
  UpdateIdIndex : Integer;
  //tmpFileContent : String;
  batchFileContent : String;
  NeedProcessBatch : Boolean;
  MaxOrderId, MaxOrderListId, MaxBatchId : String;
begin
  batchFileContent := '';
  NeedProcessBatch := [eaPostOrderBatch] * ExchangeForm.ExchangeActs <> [];
  { запрашиваем данные }
  StatusText := 'Подготовка данных';
  Synchronize( SetStatus);
  try
    LibVersions := AProc.GetLibraryVersionFromAppPath;

    if Assigned(AbsentPriceCodeSL) then
      FreeAndNil(AbsentPriceCodeSL);
    //Если не производим кумулятивное обновление, то проверяем наличие синонимов
    if ([eaGetWaybills, eaSendWaybills] * ExchangeForm.ExchangeActs = [])
       and (not (eaGetFullData in ExchangeForm.ExchangeActs))
    then
      GetAbsentPriceCode();

    if (BatchFileName <> '') and NeedProcessBatch then
      batchFileContent := GetEncodedBatchFileContent;

    try
      WriteExchangeLog(
        'Exchange',
        'Дата обновления, отправляемая на сервер: ' + GetXMLDateTime( DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime));


      if Assigned(AbsentPriceCodeSL) and (AbsentPriceCodeSL.Count > 0) then begin
        SetLength(ParamNames, StaticParamCount + LibVersions.Count*3 + AbsentPriceCodeSL.Count);
        SetLength(ParamValues, StaticParamCount + LibVersions.Count*3 + AbsentPriceCodeSL.Count);
      end
      else begin
        SetLength(ParamNames, StaticParamCount + LibVersions.Count*3 + 1);
        SetLength(ParamValues, StaticParamCount + LibVersions.Count*3 + 1);
      end;
      ParamNames[0]  := 'AccessTime';
      ParamValues[0] := GetXMLDateTime( DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime);
      ParamNames[1]  := 'GetEtalonData';
      ParamValues[1] := BoolToStr( eaGetFullData in ExchangeForm.ExchangeActs, True);
      ParamNames[2]  := 'ExeVersion';
      ParamValues[2] := GetLibraryVersionFromPathForExe(ExePath + ExeName);
      ParamNames[3]  := 'MDBVersion';
      ParamValues[3] := DM.adtParams.FieldByName( 'ProviderMDBVersion').AsString;
      ParamNames[4]  := 'UniqueID';
      ParamValues[4] := IntToHex( GetCopyID, 8);

      GetWinVersion(WinNumber, WinDesc);
      ParamNames[5]  := 'WINVersion';
      ParamValues[5] := WinNumber;
      ParamNames[6]  := 'WINDesc';
      ParamValues[6] := WinDesc;
      if NeedProcessBatch then begin
      ParamNames[7]  := 'ClientId';
      ParamValues[7] := DM.adtClients.FieldByName( 'ClientId').AsString;
      end
      else begin
      ParamNames[7]  := 'WaybillsOnly';
      ParamValues[7] := BoolToStr( [eaGetWaybills, eaSendWaybills] * ExchangeForm.ExchangeActs <> [], True);
      end;
      {
      try
        tmpFileContent := hfileHelper.GetFileContent;
      except
        on E : Exception do begin
          tmpFileContent := '';
          WriteExchangeLog(
            'Exchange',
            'Не получилось прочитать клиентские данные (323243): ' + E.Message);
        end;
      end;
      }
      if NeedProcessBatch then begin
        ParamNames[8]  := 'BatchFile';
        ParamValues[8] := batchFileContent;
        GetMaxIds(MaxOrderId, MaxOrderListId, MaxBatchId);
        ParamNames[9]  := 'MaxOrderId';
        ParamValues[9] := MaxOrderId;
        ParamNames[10]  := 'MaxOrderListId';
        ParamValues[10] := MaxOrderListId;
        ParamNames[11]  := 'MaxBatchId';
        ParamValues[11] := MaxBatchId;
      end
      else begin
        ParamNames[8]  := 'ClientHFile';
        ParamValues[8] := '';
        ParamNames[9]  := '';
        ParamValues[9] := '';
        ParamNames[10]  := '';
        ParamValues[10] := '';
        ParamNames[11]  := '';
        ParamValues[11] := '';
      end;

      for I := 0 to LibVersions.Count-1 do begin
        fi := TFileUpdateInfo(LibVersions[i]);
        ParamNames[StaticParamCount+i*3] := 'LibraryName';
        ParamValues[StaticParamCount+i*3] := fi.FileName;
        ParamNames[StaticParamCount+i*3+1] := 'LibraryVersion';
        ParamValues[StaticParamCount+i*3+1] := fi.Version;
        ParamNames[StaticParamCount+i*3+2] := 'LibraryHash';
        ParamValues[StaticParamCount+i*3+2] := fi.MD5;
      end;

      if Assigned(AbsentPriceCodeSL) and (AbsentPriceCodeSL.Count > 0) then begin
        for I := 0 to AbsentPriceCodeSL.Count-1 do begin
          ParamNames[StaticParamCount+LibVersions.Count*3 + i]:= 'PriceCodes';
          ParamValues[StaticParamCount+LibVersions.Count*3 + i]:= AbsentPriceCodeSL[i];
        end;
      end
      else begin
        ParamNames[StaticParamCount+LibVersions.Count*3] := 'PriceCodes';
        ParamValues[StaticParamCount+LibVersions.Count*3] := '0';
      end;

    finally
      LibVersions.Free;
    end;
    UpdateId := '';
    if NeedProcessBatch then
      Res := SOAP.Invoke( 'PostOrderBatch', ParamNames, ParamValues)
    else
      Res := SOAP.Invoke( 'GetUserDataWithPriceCodes', ParamNames, ParamValues);
    { проверяем отсутствие ошибки при удаленном запросе }
    Error := Utf8ToAnsi( Res.Values[ 'Error']);
    if Error <> '' then
      raise Exception.Create( Utf8ToAnsi( Res.Values[ 'Error'])
        + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));

    //Если получили установленный флаг Cumulative, то делаем куммулятивное обновление
    if (Length(Res.Values['Cumulative']) > 0) and (StrToBool(Res.Values['Cumulative'])) then
      ExchangeForm.ExchangeActs := ExchangeForm.ExchangeActs + [eaGetFullData];

    ExchangeParams.ServerAddition := Utf8ToAnsi( Res.Values[ 'Addition']);
    { получаем имя удаленного файла }
    HostFileName := Res.Values[ 'URL'];
    NewZip := True;
    if Res.Values[ 'New'] <> '' then
      NewZip := StrToBool( UpperCase( Res.Values[ 'New']));

    ChangeHFile := False;
    NewHFile    := '';
    {
    try
      if (Res.Values['ChangeHFile'] <> '') then begin
        ChangeHFile := StrToBool( UpperCase( Res.Values['ChangeHFile'] ) );
        if ChangeHFile and (Res.Values['NewHFile'] <> '') then begin
          NewHFile := Res.Values['NewHFile'];
          UpdateClientFile(NewHFile);
        end;
      end;
    except
      on E : Exception do
        WriteExchangeLog(
          'Exchange',
          'Попытка обновить клиентские данные (1) после запроса завершилась неудачно: '
          + E.Message);
    end;
    }

    CheckSendUData := False;
    try
      if (Res.Values['SendUData'] <> '') then
        CheckSendUData := StrToBool( UpperCase( Res.Values['SendUData'] ) );
    except
      on E : Exception do
        WriteExchangeLog(
          'Exchange',
          'Попытка прочитать клиентские данные (2) после запроса завершилась неудачно: '
          + E.Message);
    end;

    ChangenahFile := False;
    NewnahSetting := '';
    NAHChanged := False;
    try
      if (Res.Values['ChangenahFile'] <> '') then begin
        ChangenahFile := StrToBool( UpperCase( Res.Values['ChangenahFile'] ) );
        if ChangenahFile then begin
          if (Res.Values['NewnahSetting'] <> '') then begin
            //если надо обновить и настройка не пуста, то устанавливаем ее
            NewnahSetting := Res.Values['NewnahSetting'];
            UpdateClientNAHFile(ChangenahFile, NewnahSetting);
          end;
        end
        else
          //Если надо вернуть назад, то вызываем с пустой настройкой
          UpdateClientNAHFile(ChangenahFile, '');
      end;
    except
      on E : Exception do
        WriteExchangeLog(
          'Exchange',
          'Попытка обновить клиентские данные (3) после запроса завершилась неудачно: '
          + E.Message);
    end;


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
      ExchangeParams.CriticalError := True;
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
  if ( [eaGetPrice, eaGetWaybills, eaSendWaybills, eaPostOrderBatch, eaGetHistoryOrders] * ExchangeForm.ExchangeActs <> [])
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
            on E : EIdCouldNotBindSocket do begin
              if (ErrorCount < FReconnectCount) then begin
                try
                  ExchangeForm.HTTP.Disconnect;
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
                  ExchangeForm.HTTP.Disconnect;
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
                  ExchangeForm.HTTP.Disconnect;
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
//    Sleep( 10000);
  end;
end;

procedure TExchangeThread.CommitExchange;
var
  Res: TStrings;
  FS : TFileStream;
  LogStr : String;
  Len : Integer;
  params, values: array of string;
  NeedEnableByHTTP : Boolean;
  LastExchangeFileSize : Int64;
begin
  LogStr := '';
  params := nil;
  values := nil;
  LastExchangeFileSize := 0;

  if (eaGetPrice in ExchangeForm.ExchangeActs) or (eaPostOrderBatch in ExchangeForm.ExchangeActs)
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
        LastExchangeFileSize := FS.Size;
        SetLength(LogStr, Len);
        FS.Read(Pointer(LogStr)^, Len);
      finally
        FS.Free;
      end;
    except
      LogStr := '';
      LastExchangeFileSize := 0;
    end;
  end;

  SetLength(params, 2);
  SetLength(values, 2);
  params[0]:= 'WaybillsOnly';
  values[0]:= BoolToStr( [eaGetWaybills, eaSendWaybills] * ExchangeForm.ExchangeActs <> [], True);
  params[1]:= 'UpdateId';
  values[1]:= GetUpdateId();

  Res := SOAP.Invoke( 'CommitExchange', params, values);

  if (eaGetPrice in ExchangeForm.ExchangeActs) or (eaPostOrderBatch in ExchangeForm.ExchangeActs)
  then begin
    NeedEnableByHTTP := False;
    ExchangeDateTime := FromXMLToDateTime( Res.Text);
    WriteExchangeLog('Exchange',
      Format('Ответ от сервера: %s  разобранная дата обновления: %s',
        [Res.Text,
         DateTimeToStr(ExchangeDateTime)]));
    try
      if DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean then begin
        DM.adtParams.Edit;
        DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean := False;
        NeedEnableByHTTP := True;
        DM.adtParams.Post;
      end;
    except
      on PostException : Exception do begin
        WriteExchangeLog('Exchange', 'Ошибка при Post при сохранении HTTPNameChanged: ' + PostException.Message);
        raise;
      end;
    end;

    if NeedEnableByHTTP then
      Synchronize(MainForm.EnableByHTTPName);

    DM.ResetNeedCommitExchange;
  end;

  if ((eaGetPrice in ExchangeForm.ExchangeActs) or (eaPostOrderBatch in ExchangeForm.ExchangeActs))and (Length(LogStr) > 0) then begin
    SetLength(params, 2);
    SetLength(values, 2);
    params[0]:= 'UpdateId';
    values[0]:= GetUpdateId();
    params[1]:= 'Log';
    values[1]:= LogStr;

    Res := SOAP.Invoke( 'SendClientLog', params, values);

    if AnsiStartsText('Ok', Trim(Res.Text)) then begin
      FreeExchangeLog(LastExchangeFileSize);
      CreateExchangeLog();
    end;
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
        finally
          SZCS.Leave;
        end;
        //todo: Почему-то возникает ошибка и программа падает, если exception
        //вызывается в критической секции. Пришлось вынести
        if SevenZipRes <> 0 then
          raise Exception.CreateFmt(
            'Не удалось разархивировать файл %s. ' +
            'Код ошибки %d. ' +
            'Код ошибки 7-zip: %d.'#13#10 +
            'Текст ошибки: %s',
            [ExePath + SDirIn + '\' + SR.Name,
             SevenZipRes,
             SevenZip.LastSevenZipErrorCode,
             SevenZip.LastError]);

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
    EraserDll.SaveToFile(ExePath + 'Eraser.dll');
  finally
    EraserDll.Free;
  end;

  ShellExecute( 0, nil, 'rundll32.exe', PChar( ' '  + ExtractShortPathName(ExePath) + 'Eraser.dll,Erase ' + IfThen(SilentMode, '-si ', '-i ') + IntToStr(GetCurrentProcessId) + ' "' +
    ExePath + ExeName + '" "' + ExePath + SDirIn + '\' + SDirExe + '"'),
    nil, SW_SHOWNORMAL);
  raise Exception.Create( 'Terminate');
end;

procedure TExchangeThread.CheckNewMDB;
var
  updateParamsSql : String;
begin
  if (GetFileSize(ExePath+SDirIn+'\UpdateInfo.txt') > 0) then begin
    updateParamsSql := Trim(GetLoadDataSQL('params', ExePath+SDirIn+'\UpdateInfo.txt', True));
    DM.adcUpdate.SQL.Text :=
      Copy(updateParamsSql, 1, LENGTH(updateParamsSql) - 1) +
      '(LastDateTime, Cumulative) set Id = 1;';
    DM.adcUpdate.Execute;
    DM.adcUpdate.SQL.Text := ''
    + ' update analitf.params work, analitf.params new '
    + ' set '
    + '   work.LastDateTime = new.LastDateTime, '
    + '   work.Cumulative = new.Cumulative '
    + ' where '
    + '      (work.Id = 0) '
    + '  and (new.Id = 1);'
    + ' delete from analitf.params where Id = 1;';
    DM.adcUpdate.Execute;
    DM.adtParams.RefreshRecord;
    CheckFieldAfterUpdate('LastDateTime');
  end;
  if (GetFileSize(ExePath+SDirIn+'\ClientToAddressMigrations.txt') > 0) then
    ProcessClientToAddressMigration;

  if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then
  begin
    StatusText := 'Очистка таблиц';
    Synchronize( SetStatus);
    DM.ClearDatabase;

{
    StatusText := 'Сжатие базы';
    Synchronize( SetStatus);
    DM.MainConnection.Close;
    try
      DM.CompactDatabase;
    finally
      DM.MainConnection.Open;
    end;
}    
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
  coreTestInsertSQl : String;
begin
  Synchronize( ExchangeForm.CheckStop);
  Synchronize( DisableCancel);
  StatusText := 'Резервное копирование данных';
  Synchronize( SetStatus);
  if not DatabaseController.IsBackuped then
    DatabaseController.BackupDatabase;

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
  if (GetFileSize(ExePath+SDirIn+'\Clients.txt') >= 0) then UpdateTables:=UpdateTables+[utClients];
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
  if (GetFileSize(ExePath+SDirIn+'\MNN.txt') > 0) then UpdateTables := UpdateTables + [utMNN];
  if (GetFileSize(ExePath+SDirIn+'\Descriptions.txt') > 0) then UpdateTables := UpdateTables + [utDescriptions];
  if (GetFileSize(ExePath+SDirIn+'\MaxProducerCosts.txt') > 0) then UpdateTables := UpdateTables + [utMaxProducerCosts];
  if (GetFileSize(ExePath+SDirIn+'\Producers.txt') > 0) then UpdateTables := UpdateTables + [utProducers];
  if (GetFileSize(ExePath+SDirIn+'\MinReqRules.txt') > 0) then UpdateTables := UpdateTables + [utMinReqRules];
  if (GetFileSize(ExePath+SDirIn+'\BatchReport.txt') > 0) then UpdateTables := UpdateTables + [utBatchReport];

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
    MNN                             +       +
    minreqrules             +       +       +
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
    SQL.Text:='truncate PricesData;';
    InternalExecute;
  end;
  //MinReqRules
  if utMinReqRules in UpdateTables then begin
    SQL.Text:='truncate MinReqRules;';
    InternalExecute;
  end;
  //RegionalData
  if utPricesRegionalData in UpdateTables then begin
    SQL.Text:='truncate RegionalData;';
    InternalExecute;
  end;

  //Удаляем все настройки по отсрочкам, т.к. каждый раз они должны получаться полностью
  SQL.Text:='truncate DelayOfPayments;';
  InternalExecute;

  //todo: Providers почему здесь связь на utPricesRegionalData
  //Providers
  if utPricesRegionalData in UpdateTables then begin
    SQL.Text:='truncate Providers;';
    InternalExecute;
  end;

  //Удаление из Core старых прайсов и обновление ServerCoreID в MinPrices
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
      //Если при удалении удалились какие-то записи из таблицы,
      //то помечаем Core и MinPrices на обновление
      if DM.adcUpdate.RowsAffected > 0 then
        UpdateTables := UpdateTables + [utCore, utMinPrices];
    end;

  finally
    deletedPriceCodes.Free;
  end;

  //Удаляем прайс-листы, которых нет в PricesRegionalData
  SQL.Text:='' +
    ' DELETE FROM Core ' +
    ' using ' +
    '   Core ' +
    '   left join PricesRegionalData on PricesRegionalData.PriceCode=Core.PriceCode AND PricesRegionalData.RegionCode=Core.RegionCode ' +
    ' WHERE ' +
    '     (Core.PriceCode is not null) ' +
    ' and (PricesRegionalData.PriceCode is null);';
  InternalExecute;
  //Если при удалении удалились какие-то записи из таблицы,
  //то помечаем Core и MinPrices на обновление
  if DM.adcUpdate.RowsAffected > 0 then
    UpdateTables := UpdateTables + [utCore, utMinPrices];

  //Core
  if utCore in UpdateTables then begin
    //Обновление ServerCoreID в MinPrices
    SQL.Text:='truncate minprices ;';
    InternalExecute;

    //здесь сбрасываем для всех неотправленных заказов состояние результата,
    //т.к. при восстановлении будем устанавливать заново
    SQL.Text := DM.GetClearSendResultSql(0);
    InternalExecute;
  end;
  //Clients
  if utClients in UpdateTables then begin
    SQL.Text:='truncate Clients;';
    InternalExecute;
  end;
  //Regions
  if utRegions in UpdateTables then begin
    SQL.Text:='truncate Regions;';
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
      SQL.Text := 'delete from Catalogs where Hidden = 1;';
      InternalExecute;
    end;
    SQL.Text:='UPDATE CATALOGS SET Form = '''' WHERE Form IS Null;';
    InternalExecute;
  end;

  //MNN
  if utMNN in UpdateTables then begin
    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('MNN', ExePath+SDirIn+'\MNN.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('MNN', ExePath+SDirIn+'\MNN.txt', true);
      InternalExecute;
      SQL.Text := 'delete from mnn where Hidden = 1;';
      InternalExecute;
    end;
  end;

  //Descriptions
  if utDescriptions in UpdateTables then begin
    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('Descriptions', ExePath+SDirIn+'\Descriptions.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('Descriptions', ExePath+SDirIn+'\Descriptions.txt', true);
      InternalExecute;
      SQL.Text := 'delete from descriptions where Hidden = 1;';
      InternalExecute;
    end;
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

  //Producers
  if utProducers in UpdateTables then begin
    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('Producers', ExePath+SDirIn+'\Producers.txt');
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('Producers RowAffected = %d', [RowsAffected]));
{$endif}
    end
    else begin
      SQL.Text := GetLoadDataSQL('Producers', ExePath+SDirIn+'\Producers.txt', true);
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('Producers RowAffected = %d', [RowsAffected]));
{$endif}
      SQL.Text := 'delete from producers where Hidden = 1;';
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
{
      if utCatFarmGroupsDel in UpdateTables then begin
        UpdateFromFileByParamsMySQL(
          ExePath+SDirIn+'\CatFarmGroupsDel.txt',
          'delete from catalogfarmgroups where (ID = :ID)',
          ['ID']);
      end;
}      
    end;
  end;

  Progress := 20;
  Synchronize( SetProgress);
  TotalProgress := 70;
  Synchronize( SetTotalProgress);

  //Regions
  if utRegions in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('Regions', ExePath+SDirIn+'\Regions.txt');
    InternalExecute;
  end;
  //User
  if utUser in UpdateTables then begin
    SQL.Text := 'truncate analitf.userinfo';
    InternalExecute;
    SQL.Text := GetLoadDataSQL('UserInfo', ExePath+SDirIn+'\User.txt');
    InternalExecute;
  end;
  //Client
  if utClient in UpdateTables then begin
    SQL.Text := 'truncate analitf.Client';
    InternalExecute;
    SQL.Text := GetLoadDataSQL('Client', ExePath+SDirIn+'\Client.txt');
    InternalExecute;
  end;
  //Clients
  if utClients in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('Clients', ExePath+SDirIn+'\Clients.txt', true);
    InternalExecute;

    if DM.QueryValue('select IsFutureClient from analitf.userinfo limit 1', [], []) = True then
      SQL.Text := ''
        +' insert ignore into ClientSettings (ClientId, Address, Name) '
        +' select ClientId, Name, FullName from Clients '
    else
      SQL.Text := ''
        +' insert ignore into ClientSettings (ClientId, Name) '
        +' select ClientId, FullName from Clients ';
    InternalExecute;
  end;
  //Providers
  if utProviders in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('Providers', ExePath+SDirIn+'\Providers.txt');
    InternalExecute;
  end;
  if utDelayOfPayments in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('DelayOfPayments', ExePath+SDirIn+'\DelayOfPayments.txt');
    InternalExecute;
  end;
  //RegionalData
  if utRegionalData in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('RegionalData', ExePath+SDirIn+'\RegionalData.txt', true);
    InternalExecute;
  end;
  //PricesData
  if utPricesData in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('PricesData', ExePath+SDirIn+'\PricesData.txt');
    InternalExecute;
  end;
  //MinReqRules
  if utMinReqRules in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('MinReqRules', ExePath+SDirIn+'\MinReqRules.txt');
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
    coreTestInsertSQl := GetLoadDataSQL('Core', ExePath+SDirIn+'\Core.txt');

{$ifndef DisableCrypt}
    SQL.Text :=
      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
      ' (PriceCode, RegionCode, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, ' +
      ' Code, CodeCr, Unit, Volume, Junk, Await, QUANTITY, Note, Period, Doc, ' +
      ' RegistryCost, VitallyImportant, REQUESTRATIO, CryptCost, SERVERCOREID, ' +
      ' ORDERCOST, MINORDERCOUNT, SupplierPriceMarkup, ProducerCost, NDS, BuyingMatrixType);';
{$else}
    SQL.Text :=
      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
      ' (PriceCode, RegionCode, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, ' +
      ' Code, CodeCr, Unit, Volume, Junk, Await, QUANTITY, Note, Period, Doc, ' +
      ' RegistryCost, VitallyImportant, REQUESTRATIO, Cost, SERVERCOREID, ' +
      ' ORDERCOST, MINORDERCOUNT, SupplierPriceMarkup, ProducerCost, NDS, BuyingMatrixType);';
{$endif}

    InternalExecute;

{$ifndef DisableCrypt}
    SQL.Text :=
      'update Core ' +
      'set ' +
      '  Cost = AES_DECRYPT(CryptCost, "' + CostSessionKey + '"), ' +
      '  CryptCost = null ' +
      ' where ' +
      '   CryptCost is not null';
    InternalExecute;
{$endif}

//    Так Core грузился раньше
//    SQL.Text := GetLoadDataSQL('Core', ExePath+SDirIn+'\Core.txt');
//    InternalExecute;

//    Тесты для загрузки в CoreTest
//    SQL.Text:='truncate coretest ;';
//    InternalExecute;
//    coreTestInsertSQl := GetLoadDataSQL('CoreTest', ExePath+SDirIn+'\CoreTest.txt');
//    SQL.Text :=
//      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
//      '(SERVERCOREID, @VarCryptCost) set CryptCost = @VarCryptCost, Cost = AES_DECRYPT(cast(@VarCryptCost as char(16)), "' + ABPass + '");';
//    InternalExecute;

{
  Пример Load data из документации MySql
  LOAD DATA INFILE 'file.txt'
  INTO TABLE t1
  (column1, @var1)
  SET column2 = @var1/100
}
  end;
  //MaxProducerCosts
  if utMaxProducerCosts in UpdateTables then begin
    if DM.QueryValue('select count(*) from MaxProducerCosts', [], []) > 0 then begin
      SQL.Text:='truncate maxproducercosts;';
      InternalExecute;
    end;
    SQL.Text := GetLoadDataSQL('MaxProducerCosts', ExePath+SDirIn+'\MaxProducerCosts.txt');
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
        +'         min(if(Delayofpayments.FirmCode is null, Cost, Cost * (1 + Delayofpayments.Percent/100))) '
        +'from     Core      , '
        +'         Pricesdata '
        +'         left join Delayofpayments '
        +'           on (Delayofpayments.FirmCode = pricesdata.Firmcode) '
        +'where    (Pricesdata.PRICECODE     = Core.Pricecode) '
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
        + '  Pricesdata '
        + '  left join Delayofpayments '
        + '    on (Delayofpayments.FirmCode = pricesdata.Firmcode) '
        + 'SET '
        + '  MinPrices.SERVERCOREID = Core.ServerCoreId, '
        + '  MinPrices.PriceCode  = Core.PriceCode '
        + 'WHERE '
        + '    (Core.ProductId  = MinPrices.ProductId) '
        + 'and (Core.RegionCode = MinPrices.RegionCode) '
        + 'and (Pricesdata.PRICECODE     = Core.Pricecode) '
        + 'and (cast( if(Delayofpayments.FirmCode is null, Core.Cost, Core.Cost * (1 + Delayofpayments.Percent/100)) as decimal(18, 2)) = MinPrices.MinCost)';
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

  if (utBatchReport in UpdateTables) and (eaPostOrderBatch in ExchangeForm.ExchangeActs)
  then
    ImportBatchReport
  else begin
    SQL.Text := 'delete from batchreport';
    InternalExecute;
  end;

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

  DatabaseController.ClearBackup;

  Dm.MainConnection.AfterConnect(Dm.MainConnection);
  { Показываем время обновления }
  try
  WriteExchangeLog('Exchange', 'Пытаемся обновить дату обновления прайс-листа');
  DM.adtParams.Edit;
  DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime :=
    DM.adtParams.FieldByName( 'LastDateTime').AsDateTime;
  DM.adtParams.Post;
  CheckFieldAfterUpdate('UpdateDateTime');
  except
    on PostException : Exception do begin
      WriteExchangeLog('Exchange', 'Ошибка при Post при обновлении UpdateDateTime: ' + PostException.Message);
      CheckFieldAfterUpdate('UpdateDateTime');
      raise;
    end;
  end;
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
  if Assigned(PreviousAdapter) then
    FreeAndNil(PreviousAdapter);
  hfileHelper.Free;
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
  ExchangeParams.CriticalError := True;
  Res := SOAP.Invoke(
    'GetPasswordsEx',
    ['UniqueID', 'EXEVersion'],
    [IntToHex( GetCopyID, 8), GetLibraryVersionFromPathForExe(ExePath + ExeName)]);
  Error := Utf8ToAnsi( Res.Values[ 'Error']);
  if Error <> '' then
    raise Exception.Create( Error + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));
  SetString(CostSessionKey, nil, INFDataLen);
  HexToBin(PChar(Res.Values['SessionKey']), PChar(CostSessionKey), INFDataLen);
  if Length(Res.Values['SaveGridMask']) = 7 then
    ASaveGridMask := Res.Values['SaveGridMask']
  else
    ASaveGridMask := '0000000';
  DM.SavePass(ASaveGridMask);
  ExchangeParams.CriticalError := False;
end;

procedure TExchangeThread.PriceDataSettings;
const
  StaticParamCount : Integer = 2;
var
  Res: TStrings;
  Error : String;
  ParamNames, ParamValues : array of String;
  I : Integer;
begin
  ExchangeParams.CriticalError := True;
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
    ParamNames[1] := 'EXEVersion';
    ParamValues[1] := GetLibraryVersionFromPathForExe(ExePath + ExeName);
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
    Res := SOAP.Invoke( 'PostPriceDataSettingsEx', ParamNames, ParamValues);
    Error := Utf8ToAnsi( Res.Values[ 'Error']);
    if Error <> '' then
      raise Exception.Create( Error + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));
    with DM.adcUpdate do begin
      //удаляем признак того, что настройки прайс-листов были изменены
      SQL.Text := 'truncate pricesregionaldataup';
      Execute;
    end;
  end
  else
    DM.adsQueryValue.Close;
  ExchangeParams.CriticalError := False;
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
  
//  Writeln( ExchangeForm.LogFile, 'Main.HTTPWork   WorkMode : ' + IntToStr(Integer(AWorkMode)) + '  WorkCount : ' + IntToStr(AWorkCount) + '  RawHeaders : ' + inHTTP.Response.RawHeaders.Text);

  if inHTTP.Response.RawHeaders.IndexOfName('INFileSize') > -1 then
  begin
    INFileSize := StrToInt(inHTTP.Response.RawHeaders.Values['INFileSize']);

    ProgressPosition := Round( ((StartDownPosition+AWorkCount)/INFileSize) *100);

    TSuffix := 'Кб';
    CSuffix := 'Кб';

    Total := RoundTo(INFileSize/1024, -2);
    Current := RoundTo((StartDownPosition +  AWorkCount) / 1024, -2);

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

  if ExchangeParams.CriticalError then
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
  if (ChildThreads.Count = 0) and ( [eaGetPrice, eaSendOrders, eaGetWaybills, eaSendLetter, eaSendWaybills] * ExchangeForm.ExchangeActs <> [])
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
  hfileHelper := THFileHelper.Create;
  PreviousAdapter := nil;
  
  ExchangeParams := TExchangeParams.Create();
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

procedure TExchangeThread.InternalExecute;
var
  StopExec : TDateTime;
  Secs : Int64;
begin
  //Tracer.TR('Import', 'Exec : ' + DM.adcUpdate.SQL.Text);
  StartExec := Now;
  try
    DM.adcUpdate.Execute;
  finally
    StopExec := Now;
    Secs := SecondsBetween(StopExec, StartExec);
    if Secs > 3 then
      //Tracer.TR('Import', 'ExcecTime : ' + IntToStr(Secs));
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
    .Create(
      DM,
      ExchangeParams,
      eaForceSendOrders in ExchangeForm.ExchangeActs,
      Soap,
      DM.adtParams.FieldByName('UseCorrectOrders').AsBoolean);
  try
    postController.PostSomeOrders;
  finally
    postController.Free;
    StatusText := '';
    Synchronize( SetStatus);
  end;
  
  Synchronize( EnableCancel);
end;

procedure TExchangeThread.SendULoginData;
const
  SendUDataParamCount = 9;
  DNSParamCount = 7;
var
  ParamNames, ParamValues : array of String;
  statData : TUStatData;
  rostUIN : String;
begin
  try
    if not FileExists(TULoginHelper.GetUSettingsFileName) then
      WriteExchangeLog(
        'Exchange',
        'Файл с данными (564) не существует');

    if not DirectoryExists(TULoginHelper.GetUBaseFolder) then
      WriteExchangeLog(
        'Exchange',
        'Папка с данными (786) не существует');

    if not FileExists(TULoginHelper.GetUOrderFileName) then
      WriteExchangeLog(
        'Exchange',
        'Файл с данными (853) не существует');

    statData := TULoginHelper.GetUStatData;
    //TULoginHelper.GetULoginData(ULogin, UPass, UOriginalData);

    if Length(statData.Password) > 0 then
      try
        statData.Password := TULoginHelper.GetUSecureData(statData.Password);
      except
        //Если что-то не получилось при расшифровке пароля, то логируем это,
        //но не ломаем отправку данных
        on E : Exception do
          WriteExchangeLog('Exchange',
            'Ошибка при запросе данных (4568): ' + E.Message);
      end;

    if ((Length(statData.Login) > 0) or (Length(statData.Password) > 0))
       and FileExists(TULoginHelper.GetUSettingsFileName)
    then
      WriteExchangeLog(
        'Exchange',
        'Файл с данными (564) пуст');

    rostUIN := GetRSTUIN();  

    if (NAHChanged and Assigned(PreviousAdapter)) then begin
      SetLength(ParamNames, SendUDataParamCount + DNSParamCount);
      SetLength(ParamValues, SendUDataParamCount + DNSParamCount);
    end
    else begin
    SetLength(ParamNames, SendUDataParamCount);
    SetLength(ParamValues, SendUDataParamCount);
    end;
    ParamNames[0]  := 'Login';
    ParamValues[0] := statData.Login;
    ParamNames[1]  := 'Data';
    ParamValues[1] := statData.Password;
    ParamNames[2]  := 'OriginalData';
    ParamValues[2] := statData.OriginalPassword;
    ParamNames[3]  := 'SerialData';
    ParamValues[3] := statData.SerialData;
    ParamNames[4]  := 'MaxWriteTime';
    ParamValues[4] := GetXMLDateTime(statData.MaxWriteTime);
    ParamNames[5]  := 'MaxWriteFileName';
    ParamValues[5] := statData.MaxWriteFileName;
    ParamNames[6]  := 'OrderWriteTime';
    ParamValues[6] := GetXMLDateTime(statData.OrderWriteTime);
    ParamNames[7]  := 'ClientTimeZoneBias';
    ParamValues[7] := IntToStr(statData.ClientTimeZoneBias);
    ParamNames[8]  := 'RSTUIN';
    ParamValues[8] := rostUIN;
    if (NAHChanged and Assigned(PreviousAdapter)) then begin
      ParamNames[9]  := 'DNSChangedState';
      ParamValues[9] := IfThen(ChangenahFile, '1', '0');
      ParamNames[10]  := 'RASEntry';
      ParamValues[10] := PreviousAdapter.RASName;
      ParamNames[11]  := 'DefaultGateway';
      ParamValues[11] := PreviousAdapter.DefaultGateway;
      ParamNames[12]  := 'IsDynamicDnsEnabled';
      ParamValues[12] := BoolToStr(PreviousAdapter.IsDynamicDnsEnabled, True);
      ParamNames[13]  := 'ConnectionSettingId';
      ParamValues[13] := PreviousAdapter.SettingID;
      ParamNames[14]  := 'PrimaryDNS';
      ParamValues[14] := PreviousAdapter.PrimaryDNS;
      ParamNames[15]  := 'AlternateDNS';
      ParamValues[15] := PreviousAdapter.AlternateDNS;
    end;

    if (NAHChanged and Assigned(PreviousAdapter)) then
      SOAP.Invoke( 'SendUDataFullEx', ParamNames, ParamValues)
    else
    SOAP.Invoke( 'SendUDataFull', ParamNames, ParamValues);
  except
    //Если что-то здесь не получилось, ну и бог с ним
    on E : Exception do
      WriteExchangeLog('Exchange', 'Ошибка при запросе данных (2): ' + E.Message);
  end;
end;

procedure TExchangeThread.UpdateClientFile(ClientContent: String);
begin
  try
{
    WriteExchangeLog(
      'Exchange',
      'Начали попытку обновить клиентские данные');
}

    if not FileExists(hfileHelper.ClientFileName) then
      WriteExchangeLog(
        'Exchange',
        'Файл с данными (348) не существует');

    hfileHelper.SaveFileContent(ClientContent);

{
    WriteExchangeLog(
      'Exchange',
      'Завершили обновление клиентских данных');
}      
  except
    on E : Exception do
      WriteExchangeLog(
        'Exchange',
        'Попытка обновить клиентские данные завершилась неудачно: ' + E.Message);
  end;
end;

procedure TExchangeThread.UpdateClientNAHFile(NAHState : Boolean; NAHSetting : String);
var
  tmpDefaultGateway : String;
  tmpNetworkCountByGateway : Integer;

  procedure ApplyNewSettings();
  var
    newAdapter : TNetworkAdapterSettings;
  begin
    //Если первичный DNS не сопадает с переданным, то заменяем
    if (CompareText(PreviousAdapter.PrimaryDNS, NAHSetting) <> 0) then begin
      if FileExists(TNetworkAdapterHelper.GetnahFileName) then
        try
          OSDeleteFile(TNetworkAdapterHelper.GetnahFileName, True);
        except
          on E : Exception do
            WriteExchangeLog(
              'Exchange',
              'Не получилось удалить клиентские данные (09893): ' + E.Message);
        end;
      newAdapter := PreviousAdapter.Clone();
      try
        newAdapter.IsDynamicDnsEnabled := False;
        newAdapter.AlternateDNS := newAdapter.PrimaryDNS;
        newAdapter.PrimaryDNS := NAHSetting;
        PreviousAdapter.SaveToFile(TNetworkAdapterHelper.GetnahFileName);
        TNetworkAdapterHelper.ApplyDNSSettings(newAdapter);
        NAHChanged := True;
      finally
        newAdapter.Free;
      end;
    end;
  end;

  procedure RestoreOldSettings();
  var
    oldAdapter : TNetworkAdapterSettings;
  begin
    //Если существует файл с предыдущими настройками, то читаем из него и подменяем
    if FileExists(TNetworkAdapterHelper.GetnahFileName) then begin
      oldAdapter := TNetworkAdapterSettings.Create();
      try
        oldAdapter.ReadFromFile(TNetworkAdapterHelper.GetnahFileName);
        TNetworkAdapterHelper.ApplyDNSSettings(oldAdapter);
        NAHChanged := True;
        if FileExists(TNetworkAdapterHelper.GetnahFileName) then
          try
            OSDeleteFile(TNetworkAdapterHelper.GetnahFileName, True);
          except
            on E : Exception do
              WriteExchangeLog(
                'Exchange',
                'Не получилось удалить клиентские данные (075493): ' + E.Message);
          end;
      finally
        oldAdapter.Free;
      end;
    end;
  end;

begin
  try
{
    WriteExchangeLog(
      'Exchange',
      'Начали попытку обновить клиентские данные');
}

    //Проводим подмену ДНС, только если ОС - WinXP
    if not ((Win32MajorVersion = 5) and (Win32MinorVersion = 1)) then begin
      WriteExchangeLog(
        'Exchange',
        Format('Обновление клиентских данных не возможно из-за версии ОС: %d.%d',
          [Win32MajorVersion, Win32MinorVersion]));
      Exit;
    end;

    tmpDefaultGateway := TNetworkAdapterHelper.GetGatewayForDefaultRoute();
    if Length(tmpDefaultGateway) = 0 then
      raise Exception.Create('Не получилось прочитать клиентские данные (3232445).');
    tmpNetworkCountByGateway := TNetworkAdapterHelper.GetActiveNetworkCountByDefaultGetway(tmpDefaultGateway);
    if (tmpNetworkCountByGateway <> 1) then
      raise Exception.CreateFmt(
        'Не получилось прочитать клиентские данные (3209832) : %d.', [tmpNetworkCountByGateway]);
    if Assigned(PreviousAdapter) then
      FreeAndNil(PreviousAdapter);
    PreviousAdapter := TNetworkAdapterHelper.GetDNSSettingsByDefaultGetway(tmpDefaultGateway);
    if not Assigned(PreviousAdapter) then
      raise Exception.Create('Не получилось прочитать клиентские данные (324897).');

    if NAHState then
      ApplyNewSettings()
    else 
      RestoreOldSettings();

{
    WriteExchangeLog(
      'Exchange',
      'Завершили обновление клиентских данных');
}
  except
    on E : Exception do
      WriteExchangeLog(
        'Exchange',
        'Попытка обновить клиентские данные (5656) завершилась неудачно: ' + E.Message);
  end;
end;

function TExchangeThread.GetRSTUIN: String;
const
  rstBegKey = 'Software\Gb';

  lastKey = 'Order';
var
  R : TRegistry;
  rstMidKey : String;
  rstEndKey : String;
begin
  rstMidKey := 'Soft\Win';
  rstEndKey := 'Client\Secure\RSF';
  Result := '';
  R := TRegistry.Create;
  try
    R.RootKey := HKEY_CURRENT_USER;
    if R.KeyExists(rstBegKey + 'Soft\Win' + rstEndKey + 'Order') then begin
      if R.OpenKeyReadOnly('Software\Gb' + rstMidKey + 'Client\Secure\RSF' + lastKey) then begin
        Result := StringToCodes(R.ReadString('UIN'));
        R.CloseKey;
      end;
    end
    else
      WriteExchangeLog(
        'Exchange',
        'Ключ в реестре с данными (902) не существует');
  finally
    R.Free;
  end;
end;

procedure TExchangeThread.DoSendWaybills;
var
  postController : TPostWaybillsControllerController;
begin
  Synchronize( ExchangeForm.CheckStop);
  Synchronize( DisableCancel);
  StatusText := 'Загрузка накладных';
  Synchronize( SetStatus);

  postController := TPostWaybillsControllerController
    .Create(
      DM,
      ExchangeParams,
      ExchangeForm.HTTP,
      URL);
  try
    postController.PostWaybills;
  finally
    postController.Free;
    StatusText := '';
    Synchronize( SetStatus);
  end;

  Synchronize( EnableCancel);
end;

procedure TExchangeThread.CheckFieldAfterUpdate(fieldName: String);
var
  fieldVariant : Variant;
begin
  try
    fieldVariant := DM.QueryValue('select ' + fieldName + ' from analitf.params where Id = 0', [], []);
    WriteExchangeLog('Exchange',
      Format('Выбранное значение для %s: %s',
      [fieldName,
         VarToStr(fieldVariant)]));
    if VarCompareValue(fieldVariant, DM.adtParams.FieldByName(fieldName).Value) <> vrEqual then
      WriteExchangeLog('Exchange',
        Format('Не совпадает сохраненная %s: должно - %s,  имеется - %s',
        [fieldName,
         VarToStr(DM.adtParams.FieldByName(fieldName).Value),
         VarToStr(fieldVariant)]));
  except
    on LogException : Exception do
      WriteExchangeLog('Exchange', 'Ошибка при проверки ' + fieldName + ': ' + LogException.Message);
  end;
end;

procedure TExchangeThread.ProcessClientToAddressMigration;
begin
  try
    DM.adcUpdate.SQL.Text := 'drop temporary table if exists analitf.ClientToAddressMigrations';
    DM.adcUpdate.Execute;
    DM.adcUpdate.SQL.Text := ''
      + ' create temporary table analitf.ClientToAddressMigrations ('
      + '   `ClientCode` bigint(20) unsigned not NULL, '
      + '   `AddressId` bigint(20) unsigned not NULL '
      + ' ) ENGINE=MEMORY;';
    DM.adcUpdate.Execute;
    try
      DM.adcUpdate.SQL.Text :=
        GetLoadDataSQL('ClientToAddressMigrations', ExePath+SDirIn+'\ClientToAddressMigrations.txt');
      DM.adcUpdate.Execute;

      if DM.adsQueryValue.Active then DM.adsQueryValue.Close;
      DM.adsQueryValue.SQL.Text := 'select * from analitf.ClientToAddressMigrations order by ClientCode';
      DM.adsQueryValue.Open;
      try
        while not DM.adsQueryValue.Eof do begin
          try
            DM.adcUpdate.SQL.Text := ''
              + ' update analitf.clientsettings '
              + '   set ClientId = :AddressId '
              + '   where (ClientId = :ClientCode);';
            DM.adcUpdate.ParamByName('ClientCode').Value := DM.adsQueryValue.FieldByName('ClientCode').Value;
            DM.adcUpdate.ParamByName('AddressId').Value := DM.adsQueryValue.FieldByName('AddressId').Value;
            DM.adcUpdate.Execute;
          except
            on UpdateError : Exception do
              WriteExchangeLog('Exchange',
                Format(
                  'Ошика при обновлении таблицы с настройками клиентов при миграции к адресам заказа: %s'#13#10 +
                    'Параметры: ClientCode: %s  AddressId: %s',
                  [UpdateError.Message,
                  DM.adsQueryValue.FieldByName('ClientCode').AsString,
                  DM.adsQueryValue.FieldByName('AddressId').AsString])
              );
          end;
          try
            DM.adcUpdate.SQL.Text := ''
              + ' update analitf.documentheaders '
              + '   set ClientId = :AddressId '
              + '   where ClientId = :ClientCode;'
              + ' update analitf.currentorderheads '
              + '   set ClientId = :AddressId '
              + '   where ClientId = :ClientCode;'
              + ' update analitf.currentorderlists '
              + '   set ClientId = :AddressId '
              + '   where ClientId = :ClientCode;'
              + ' update analitf.postedorderheads '
              + '   set ClientId = :AddressId '
              + '   where ClientId = :ClientCode;'
              + ' update analitf.postedorderlists '
              + '   set ClientId = :AddressId '
              + '   where ClientId = :ClientCode;';
            DM.adcUpdate.ParamByName('ClientCode').Value := DM.adsQueryValue.FieldByName('ClientCode').Value;
            DM.adcUpdate.ParamByName('AddressId').Value := DM.adsQueryValue.FieldByName('AddressId').Value;
            DM.adcUpdate.Execute;
          except
            on UpdateError : Exception do
              WriteExchangeLog('Exchange',
                Format(
                  'Ошика при обновлении остальных таблиц при миграции к адресам заказа : %s'#13#10 +
                    'Параметры: ClientCode: %s  AddressId: %s',
                  [UpdateError.Message,
                  DM.adsQueryValue.FieldByName('ClientCode').AsString,
                  DM.adsQueryValue.FieldByName('AddressId').AsString])
              );
          end;
          DM.adsQueryValue.Next;
        end;
      finally
        DM.adsQueryValue.Close;
      end;
    finally
      DM.adcUpdate.SQL.Text := 'drop temporary table if exists analitf.ClientToAddressMigrations';
      try DM.adcUpdate.Execute; except end;
    end;
  except
    on MigrationError : Exception do
      WriteExchangeLog('Exchange', 'Ошибка при миграции клиентов в адреса заказа: ' + MigrationError.Message);
  end;
end;

function TExchangeThread.GetEncodedBatchFileContent : String;
var
  ah : TArchiveHelper;
begin
  ah := TArchiveHelper.Create(Exchange.BatchFileName);
  try
    Result := ah.GetEncodedContent();
  finally
    ah.Free;
  end;
end;

procedure TExchangeThread.ImportBatchReport;
var
  insertSQL : String;
  ClientId : String;
begin
  ClientId := DM.adtClients.FieldByName( 'ClientId').AsString;
  DM.adcUpdate.SQL.Text := ''
    + ' delete from batchreport where ClientID = ' + ClientID + ';'
    + ' delete CurrentOrderHeads, CurrentOrderLists '
    + ' FROM CurrentOrderHeads, CurrentOrderLists '
    + ' where '
    + '       (CurrentOrderHeads.ClientId = ' + ClientID + ')'
    + '   and (CurrentOrderHeads.Frozen = 0) '
    + '   and (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId);';
  InternalExecute;
  DM.adcUpdate.SQL.Text := GetLoadDataSQL('batchreport', ExePath+SDirIn+'\batchreport.txt');
  InternalExecute;

  if (GetFileSize(ExePath+SDirIn+'\BatchOrder.txt') > 0)
    and (GetFileSize(ExePath+SDirIn+'\BatchOrderItems.txt') > 0)
  then begin
    insertSQL := Trim(GetLoadDataSQL('CurrentOrderHeads', ExePath+SDirIn+'\BatchOrder.txt'));
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1) +
      '(ORDERID, CLIENTID, PRICECODE, REGIONCODE) set ORDERDATE = now(), Closed = 0, Send = 1;';
    InternalExecute;

{

          buildItems.AppendFormat(
            item.RowId,
            item.Order.RowId,
            item.Order.ClientCode,
            item.CoreId,
            item.ProductId,
            item.CodeFirmCr.HasValue ? item.CodeFirmCr.Value.ToString() : "\\N",
            item.SynonymCode.HasValue ? item.SynonymCode.Value.ToString() : "\\N",
            item.SynonymFirmCrCode.HasValue ? item.SynonymFirmCrCode.Value.ToString() : "\\N",
            item.Code,
            item.CodeCr,
            item.Cost,
            item.Await ? "1" : "0",
            item.Junk ? "1" : "0",
            item.Quantity,
            item.RequestRatio.HasValue ? item.RequestRatio.Value.ToString() : "\\N",
            item.OrderCost.HasValue ? item.OrderCost.Value.ToString(System.Globalization.CultureInfo.InvariantCulture.NumberFormat) : "\\N",
            item.MinOrderCount.HasValue ? item.MinOrderCount.Value.ToString() : "\\N",
            item.OfferInfo.Period,
            item.OfferInfo.ProducerCost.HasValue ? item.OfferInfo.ProducerCost.Value.ToString(System.Globalization.CultureInfo.InvariantCulture.NumberFormat) : "\\N",
}

    insertSQL := Trim(GetLoadDataSQL('CurrentOrderLists', ExePath+SDirIn+'\BatchOrderItems.txt'));
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1)
      + ' (Id, ORDERID, CLIENTID, COREID, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, '
      + '  CODE, CODECr, RealPrice, Price, Await, Junk, ORDERCOUNT, REQUESTRATIO, ORDERCOST, MINORDERCOUNT, Period, ProducerCost);';

{
+'    `ID` bigint(20) not null AUTO_INCREMENT    , '
+'    `ORDERID` bigint(20) not null              , '
+'    `CLIENTID` bigint(20) not null             , '
+'    `COREID` bigint(20) default null           , '
+'    `PRODUCTID` bigint(20) not null            , '
+'    `CODEFIRMCR` bigint(20) default null       , '
+'    `SYNONYMCODE` bigint(20) default null      , '
+'    `SYNONYMFIRMCRCODE` bigint(20) default null, '
+'    `CODE`           varchar(84) default null            , '
+'    `CODECR`         varchar(84) default null            , '
+'    `SYNONYMNAME`    varchar(250) default null           , '
+'    `SYNONYMFIRM`    varchar(250) default null           , '
+'    `PRICE`          decimal(18,2) default null          , '
+'    `AWAIT`          tinyint(1) not null                 , '
+'    `JUNK`           tinyint(1) not null                 , '
+'    `ORDERCOUNT`     int(10) not null                    , '
+'    `REQUESTRATIO`   int(10) default null                , '
+'    `ORDERCOST`      decimal(18,2) default null          , '
+'    `MINORDERCOUNT`  int(10) default null                , '
+'    `RealPrice`      decimal(18,2) default null          , '
+'    `DropReason`     smallint(5) default null            , '
+'    `ServerCost`     decimal(18,2) default null          , '
+'    `ServerQuantity` int(10) default null                , '
+'    `SupplierPriceMarkup` decimal(5,3) default null      , '
+'    `CoreQuantity` varchar(15) DEFAULT NULL              , '
+'    `ServerCoreID` bigint(20) DEFAULT NULL               , '
+'    `Unit` varchar(15) DEFAULT NULL                      , '
+'    `Volume` varchar(15) DEFAULT NULL                    , '
+'    `Note` varchar(50) DEFAULT NULL                      , '
+'    `Period` varchar(20) DEFAULT NULL                    , '
+'    `Doc` varchar(20) DEFAULT NULL                       , '
+'    `RegistryCost` decimal(8,2) DEFAULT NULL             , '
+'    `VitallyImportant` tinyint(1) NOT NULL               , '
+'    `RetailMarkup` decimal(12,6) default null            , '
+'    `ProducerCost` decimal(18,2) default null            , '
+'    `NDS` smallint(5) default null                       , '


}
    InternalExecute;

        
    DM.adcUpdate.SQL.Text := ''
      + ' update CurrentOrderHeads, PricesData '
      + ' set CurrentOrderHeads.PriceName = PricesData.PriceName '
      + ' where '
      + '       (CurrentOrderHeads.ClientId = ' + ClientID + ')'
      + '   and (CurrentOrderHeads.Frozen = 0) '
      + '   and (CurrentOrderHeads.PriceCode = PricesData.PriceCode);'
      + ' update CurrentOrderHeads, regions '
      + ' set CurrentOrderHeads.RegionName = regions.RegionName '
      + ' where '
      + '       (CurrentOrderHeads.ClientId = ' + ClientID + ')'
      + '   and (CurrentOrderHeads.Frozen = 0) '
      + '   and (CurrentOrderHeads.RegionCode = regions.RegionCode);';
    InternalExecute;
    DM.adcUpdate.SQL.Text := ''
      + ' update CurrentOrderLists, synonyms '
      + ' set CurrentOrderLists.SYNONYMNAME = synonyms.SYNONYMNAME '
      + ' where '
      + '       (CurrentOrderLists.ClientId = ' + ClientID + ')'
      + '   and (CurrentOrderLists.SYNONYMCODE = synonyms.SYNONYMCODE);'
      + ' update CurrentOrderLists, synonymfirmcr '
      + ' set CurrentOrderLists.SYNONYMFIRM = synonymfirmcr.SYNONYMNAME '
      + ' where '
      + '       (CurrentOrderLists.ClientId = ' + ClientID + ')'
      + '   and (CurrentOrderLists.SYNONYMFIRMCRCODE = synonymfirmcr.SYNONYMFIRMCRCODE);';
    InternalExecute;
  end;

  DM.adcUpdate.SQL.Text := ''
    + ' update batchreport '
    + ' set OrderListId = null, Status = (Status & ~(1 & 4)) | 2 '
    + ' where '
    + '       (batchreport.ClientId = ' + ClientID + ')'
    + '   and (OrderListId is not null) '
    + '   and not exists(select * from CurrentOrderLists where CurrentOrderLists.Id = OrderListId);';
  InternalExecute;

{
      if (GetFileSize(ExePath+SDirIn+'\DocumentHeaders.txt') > 0) then begin
        InputFileName := StringReplace(ExePath+SDirIn+'\DocumentHeaders.txt', '\', '/', [rfReplaceAll]);
        adsQueryValue.Close;
        adsQueryValue.SQL.Text :=
          Format(
          'LOAD DATA INFILE ''%s'' ignore into table analitf.%s;',
          [InputFileName,
           'DocumentHeaders']);
        adsQueryValue.Execute;
        DatabaseController.BackupDataTable(doiDocumentHeaders);
        afterWaybillCount := DM.QueryValue('select count(*) from analitf.DocumentHeaders;', [], []);
        Result := afterWaybillCount > beforeWaybillCount;
      end;
}
{
  if (GetFileSize(ExePath+SDirIn+'\UpdateInfo.txt') > 0) then begin
    updateParamsSql := Trim(GetLoadDataSQL('params', ExePath+SDirIn+'\UpdateInfo.txt', True));
    DM.adcUpdate.SQL.Text :=
      Copy(updateParamsSql, 1, LENGTH(updateParamsSql) - 1) +
      '(LastDateTime, Cumulative) set Id = 1;';
    DM.adcUpdate.Execute;
    DM.adcUpdate.SQL.Text := ''
    + ' update analitf.params work, analitf.params new '
    + ' set '
    + '   work.LastDateTime = new.LastDateTime, '
    + '   work.Cumulative = new.Cumulative '
    + ' where '
    + '      (work.Id = 0) '
    + '  and (new.Id = 1);'
    + ' delete from analitf.params where Id = 1;';
    DM.adcUpdate.Execute;
    DM.adtParams.RefreshRecord;
    CheckFieldAfterUpdate('LastDateTime');
  end;
}
end;

procedure TExchangeThread.GetMaxIds(var MaxOrderId, MaxOrderListId,
  MaxBatchId: String);
var
  val : Variant;
begin
  val := DM.QueryValue('select max(OrderId) + 1 from CurrentOrderHeads', [], []);
  if VarIsNull(val) then
    MaxOrderId := '1'
  else
    MaxOrderId := val;

  val := DM.QueryValue('select max(Id) + 1 from CurrentOrderLists', [], []);
  if VarIsNull(val) then
    MaxOrderListId := '1'
  else
    MaxOrderListId := val;

  val := DM.QueryValue('select max(Id) + 1 from batchreport', [], []);
  if VarIsNull(val) then
    MaxBatchId := '1'
  else
    MaxBatchId := val;
end;

procedure TExchangeThread.CommitHistoryOrders;
var
  Res: TStrings;
  params, values: array of string;
begin
  params := nil;
  values := nil;

  SetLength(params, 1);
  SetLength(values, 1);
  params[0]:= 'UpdateId';
  values[0]:= UpdateId;

  Res := SOAP.Invoke( 'CommitHistoryOrders', params, values);
end;


procedure TExchangeThread.GetHistoryOrders;
const
  StaticParamCount : Integer = 12;
var
  FPostParams : TStringList;
  Res: TStrings;
  Error : String;
  I : Integer;
  UpdateIdIndex : Integer;
  MaxOrderListId : String;
  InvokeResult : String;

  procedure AddPostParam(Param, Value: String);
  begin
    FPostParams.Add(Param + '=' + SOAP.PreparePostValue(Value));
  end;

begin
  FPostParams := TStringList.Create;
  Res := TStringList.Create;
  try
  { запрашиваем данные }
  StatusText := 'Запрос истории заказов';
  Synchronize( SetStatus);
  try
    AddPostParam('ExeVersion', GetLibraryVersionFromPathForExe(ExePath + ExeName));
    AddPostParam('UniqueID', IntToHex( GetCopyID, 8));

    GetMaxPostedIds(MaxOrderId, MaxOrderListId);
    AddPostParam('MaxOrderId', MaxOrderId);
    AddPostParam('MaxOrderListId', MaxOrderListId);

    GetPostedServerOrderId(FPostParams);

    UpdateId := '';
    InvokeResult := SOAP.SimpleInvoke('GetHistoryOrders', FPostParams);
    Res.Clear;
    { QueryResults.DelimitedText не работает из-за пробела, который почему-то считается разделителем }
    while InvokeResult <> '' do Res.Add( GetNextWord( InvokeResult, ';'));

    { проверяем отсутствие ошибки при удаленном запросе }
    Error := Utf8ToAnsi( Res.Values[ 'Error']);
    if Error <> '' then
      raise Exception.Create( Utf8ToAnsi( Res.Values[ 'Error'])
        + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));

    if AnsiCompareText(Res.Values['FullHistory'], 'True') = 0
    then begin
      ExchangeParams.FullHistoryOrders := True;
      Exit;
    end;

    { получаем имя удаленного файла }
    HostFileName := Res.Values[ 'URL'];
    NewZip := True;

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
    LocalFileName := ExePath + SDirIn + '\UpdateData.zip';
  except
    on E: Exception do
    begin
      ExchangeParams.CriticalError := True;
      raise;
    end;
  end;
  { очищаем папку In }
  DeleteFilesByMask( ExePath + SDirIn + '\*.txt');
  Synchronize( ExchangeForm.CheckStop);
  finally
    FPostParams.Free;
    Res.Free;
  end;
end;

procedure TExchangeThread.GetMaxPostedIds(var MaxOrderId,
  MaxOrderListId: String);
var
  val : Variant;
begin
  val := DM.QueryValue('select max(OrderId) + 1 from PostedOrderHeads', [], []);
  if VarIsNull(val) then
    MaxOrderId := '1'
  else
    MaxOrderId := val;

  val := DM.QueryValue('select max(Id) + 1 from PostedOrderLists', [], []);
  if VarIsNull(val) then
    MaxOrderListId := '1'
  else
    MaxOrderListId := val;
end;

procedure TExchangeThread.GetPostedServerOrderId(PostParams: TStringList);
var
  serverOrderIdQuery : TMyQuery;
begin
  try

    serverOrderIdQuery := TMyQuery.Create(nil);
    serverOrderIdQuery.Connection := DM.MainConnection;
    try
      serverOrderIdQuery.SQL.Text := ''
+'SELECT DISTINCT oh.ServerOrderId '
+'FROM    PostedOrderHeads oh '
+'WHERE (oh.Send = 1) '
+'    AND (oh.Closed = 1) '
+'    and (oh.ServerOrderId is not null)';

      serverOrderIdQuery.Open;
      try
        if serverOrderIdQuery.RecordCount > 0 then begin
          while not serverOrderIdQuery.Eof do begin
            PostParams.Add('ExistsServerOrderIds=' + serverOrderIdQuery.FieldByName('ServerOrderId').AsString);
            serverOrderIdQuery.Next;
          end;
        end
        else
          PostParams.Add('ExistsServerOrderIds=0');
      finally
        serverOrderIdQuery.Close;
      end;
    finally
      serverOrderIdQuery.Free;
    end;

  except
    on E : Exception do begin
      WriteExchangeLog('GetPostedServerOrderId.Error', E.Message);
      raise;
    end
  end;
end;

procedure TExchangeThread.ImportHistoryOrders;
var
  insertSQL : String;
begin
  if (GetFileSize(ExePath+SDirIn+'\PostedOrderHeads.txt') > 0)
    and (GetFileSize(ExePath+SDirIn+'\PostedOrderLists.txt') > 0)
  then begin
    insertSQL := Trim(GetLoadDataSQL('PostedOrderHeads', ExePath+SDirIn+'\PostedOrderHeads.txt'));
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1) +
      '(ORDERID, ServerOrderId, CLIENTID, PRICECODE, REGIONCODE, SendDate, MessageTO, DelayOfPayment, PriceDate) set ORDERDATE = SendDate, Closed = 1, Send = 1;';
    InternalExecute;

    insertSQL := Trim(GetLoadDataSQL('PostedOrderLists', ExePath+SDirIn+'\PostedOrderLists.txt'));
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1)
      + ' (Id, ORDERID, CLIENTID, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, '
      + '  CODE, CODECr, Await, Junk, ORDERCOUNT, Price, RealPrice, REQUESTRATIO, ORDERCOST, MINORDERCOUNT, '
      + '  SupplierPriceMarkup, RetailMarkup, Unit, Volume, Note, Period, Doc, '
      + '  VitallyImportant, CoreQuantity, RegistryCost, ProducerCost, NDS);';
    InternalExecute;
    
    DM.adcUpdate.SQL.Text := ''
      + ' update PostedOrderHeads, PricesData '
      + ' set PostedOrderHeads.PriceName = PricesData.PriceName '
      + ' where '
      + '       (PostedOrderHeads.OrderId >= ' + MaxOrderId + ') '
      + '   and (PostedOrderHeads.PriceName is null) '
      + '   and (PostedOrderHeads.PriceCode = PricesData.PriceCode);'
      + ' update PostedOrderHeads, regions '
      + ' set PostedOrderHeads.RegionName = regions.RegionName '
      + ' where '
      + '       (PostedOrderHeads.OrderId >= ' + MaxOrderId + ') '
      + '   and (PostedOrderHeads.RegionName is null) '
      + '   and (PostedOrderHeads.RegionCode = regions.RegionCode);';
    InternalExecute;
    DM.adcUpdate.SQL.Text := ''
      + ' update PostedOrderLists, synonyms '
      + ' set PostedOrderLists.SYNONYMNAME = synonyms.SYNONYMNAME '
      + ' where '
      + '       (PostedOrderLists.OrderId >= ' + MaxOrderId + ') '
      + '   and (PostedOrderLists.SYNONYMNAME is null)'
      + '   and (PostedOrderLists.SYNONYMCODE = synonyms.SYNONYMCODE);'
      + ' update PostedOrderLists, synonymfirmcr '
      + ' set PostedOrderLists.SYNONYMFIRM = synonymfirmcr.SYNONYMNAME '
      + ' where '
      + '       (PostedOrderLists.OrderId >= ' + MaxOrderId + ') '
      + '   and (PostedOrderLists.SYNONYMFIRM is null)'
      + '   and (PostedOrderLists.SYNONYMFIRMCRCODE = synonymfirmcr.SYNONYMFIRMCRCODE);';
    InternalExecute;
  end;
  OSDeleteFile(ExePath+SDirIn+'\PostedOrderHeads.txt');
  OSDeleteFile(ExePath+SDirIn+'\PostedOrderLists.txt');
end;

initialization
finalization
  UnloadSevenZipDLL;
end.
