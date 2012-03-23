unit ExchangeThread;

interface

uses
  Classes, SysUtils, Windows, StrUtils, ComObj, Variants,
  SOAPThroughHTTP, DateUtils, ShellAPI, ExtCtrls, RecThread, ActiveX,
  IdException, WinSock, RxVerInf, DB,
  SevenZip,
  IdStackConsts, infvercls, Contnrs, IdHashMessageDigest,
  IdComponent, IdHTTP, FileUtil,
  U_frmOldOrdersDelete, U_RecvThread, IdStack, MyAccess, DBAccess,
  DataIntegrityExceptions, PostSomeOrdersController, ExchangeParameters,
  DatabaseObjects, HFileHelper, NetworkAdapterHelpers, PostWaybillsController,
  ArchiveHelper,
  UserMessageParams,
  NetworkSettings,
  DayOfWeekHelper,
  GlobalParams,
  DBGridHelper;

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
  utBatchReport,
  utDocumentHeaders,
  utDocumentBodies,
  utSupplierPromotions,
  utPromotionCatalogs,
  utCurrentOrderHeads,
  utInvoiceHeaders,
  utSchedules,
  utCertificateRequests,
  utMails,
  utAttachmentRequests
);

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
  DocumentBodyIdsSL : TStringList;
  AttachmentIdsSL : TStringList;
  ASaveGridMask : String;
  CostSessionKey : String;
  URL : String;
  HTTPName,
  HTTPPass : String;
  StartDownPosition : Integer;
  LastPacketTime : TDateTime;
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

  FUserMessageParams : TUserMessageParams;

  FirstResponseServer : Boolean;
  StatusBeforeFirst : String;

  procedure SetStatus;
  procedure SetStatusText(AStatusText : String);
  procedure SetStatusTextHTTP(AStatusText : String);
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
  procedure DoProcessAsync(url : String);
  function  GetEncodedBatchFileContent : String;
  procedure GetMaxIds(var MaxOrderId, MaxOrderListId, MaxBatchId : String);
  procedure GetMaxPostedIds(var MaxOrderId, MaxOrderListId : String);
  procedure GetPostedServerOrderId(PostParams : TStringList);
  procedure SendULoginData;
  procedure GetPass;
  procedure PriceDataSettings;
  procedure CommitExchange;
  procedure SendUserActions;
  function GetUserLogCount() : Integer;
  procedure ExportUserLogs(exportFileName, limitCondition : String);
  function  GetEncodedUserLogsFileContent(exportFileName: String) : String;
  procedure DoExchange;
  procedure DoSendLetter;
  procedure DoSendSomeOrders;
  procedure DoSendWaybills;
  procedure HTTPDisconnect;
  procedure RasDisconnect;
  procedure UnpackFiles;
  procedure ImportData;
  procedure ImportBatchReport;
  procedure ImportDocs;
  procedure ImportDownloadOrders;
  procedure FillDistinctOrderAddresses(OrderHeadsFile : String);
  procedure ImportOrders(OrderHeadsFile, OrderListsFile : String; FrozenOrders : Boolean);
  procedure ClearPromotions;
  procedure ProcessPromoFileState(promoFileName : String);
  procedure CheckNewExe;
  procedure CheckNewMDB;
  procedure CheckNewFRF;
  procedure GetAbsentPriceCode;

  procedure GetCertificateRequests();
  procedure GetAttachmentRequests();

  procedure GetHistoryOrders;
  procedure CommitHistoryOrders;
  procedure ImportHistoryOrders;

  procedure ImportCertificates();

  procedure ImportMails();

  procedure ConfirmUserMessage;

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

  procedure HTTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);

  procedure ProcessImportData;
  function RestoreDb : Boolean;
  procedure FreeMySqlLibOnRestore;
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
  Registry,
  UniqueID,
  MyClasses,
  MyEmbConnection,
  MySqlApi;

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
    FUserMessageParams := TUserMessageParams.Create(DM.MainConnection);
    try
      ImportComplete := False;
      repeat
      try
      if ( [eaGetPrice, eaSendOrders, eaGetWaybills, eaSendLetter, eaSendWaybills, eaPostOrderBatch, eaGetHistoryOrders] * ExchangeForm.ExchangeActs <> [])
      then
      begin
        FirstResponseServer := False;
        RasConnect;
        SetStatusText('Соединение...');
        HTTPConnect;
        TotalProgress := 10;
        Synchronize( SetTotalProgress);

        if FUserMessageParams.NeedConfirm then
          ConfirmUserMessage;

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

            //Пытаемся получить пароли только при обновлении или автозаказе
            if ([eaGetPrice, eaPostOrderBatch] * ExchangeForm.ExchangeActs <> [])
            then
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

      if ( [eaGetWaybills, eaSendWaybills] * ExchangeForm.ExchangeActs <> [])
      then begin
        ImportDocs;
        ImportCertificates();
      end;

      if ( [eaGetPrice, eaImportOnly, eaPostOrderBatch] * ExchangeForm.ExchangeActs <> []) then
      begin
        ProcessImportData;
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
          SetStatusText('Обновление завершено');
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
        SetStatusText('');
        //обрабатываем Отмену
        //if ExchangeForm.DoStop then Abort;
        //обрабатываем ошибку
        WriteExchangeLog('Exchange', LastStatus + ':' + CRLF + E.Message);
        if (E is EAbort) and (ExchangeParams.ErrorMessage = '') then
          ExchangeParams.ErrorMessage := UserAbortMessage;
        if ExchangeParams.ErrorMessage = '' then
          ExchangeParams.ErrorMessage := RusError( E.Message);
        if ExchangeParams.ErrorMessage = '' then
          ExchangeParams.ErrorMessage := E.ClassName + ': ' + E.Message;
        if (E is EIdHTTPProtocolException)
           and (ExchangeParams.ErrorMessage <> UserAbortMessage)
        then
          ExchangeParams.ErrorMessage :=
            'При выполнении вашего запроса произошла ошибка.'#13#10 +
            'Повторите запрос через несколько минут.'#13#10 +
            ExchangeParams.ErrorMessage
        else
        if (E is EIdException)
            and (ExchangeParams.ErrorMessage <> UserAbortMessage)
        then
          ExchangeParams.ErrorMessage :=
            'Проверьте подключение к Интернет.'#13#10 +
            ExchangeParams.ErrorMessage;
      end;
    end;
    finally
      FUserMessageParams.Free;
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
var
  FPostParams : TStringList;
  Res: TStrings;
  LibVersions: TObjectList;
  Error : String;
  I : Integer;
  WinNumber, WinDesc : String;
  fi : TFileUpdateInfo;
  UpdateIdIndex : Integer;
  //tmpFileContent : String;
  batchFileContent : String;
  NeedProcessBatch : Boolean;
  MaxOrderId, MaxOrderListId, MaxBatchId : String;

  waybillsWithCertificate : Boolean;

  requestAttachs : Boolean;

  processAsync : Boolean;

  procedure AddPostParam(Param, Value: String);
  begin
    FPostParams.Add(Param + '=' + SOAP.PreparePostValue(Value));
  end;

begin
  batchFileContent := '';
  waybillsWithCertificate := False;
  requestAttachs := False;
  NeedProcessBatch := [eaPostOrderBatch] * ExchangeForm.ExchangeActs <> [];
  { запрашиваем данные }
  SetStatusTextHTTP('Подготовка данных');
  FPostParams := TStringList.Create;
  try
  try
    LibVersions := AProc.GetLibraryVersionFromAppPath;

    if Assigned(AbsentPriceCodeSL) then
      FreeAndNil(AbsentPriceCodeSL);
    if Assigned(DocumentBodyIdsSL) then
      FreeAndNil(DocumentBodyIdsSL);
    if Assigned(AttachmentIdsSL) then
      FreeAndNil(AttachmentIdsSL);
    //Если не производим кумулятивное обновление, то проверяем наличие синонимов
    if ([eaGetWaybills, eaSendWaybills] * ExchangeForm.ExchangeActs = [])
       and (not (eaGetFullData in ExchangeForm.ExchangeActs))
    then
      GetAbsentPriceCode();

    if [eaGetWaybills, eaSendWaybills] * ExchangeForm.ExchangeActs <> [] then begin
      GetCertificateRequests();
      if Assigned(DocumentBodyIdsSL) and (DocumentBodyIdsSL.Count > 0) then
        waybillsWithCertificate := True;
    end;

    if [eaGetPrice] * ExchangeForm.ExchangeActs <> [] then begin
      GetAttachmentRequests();
      if Assigned(AttachmentIdsSL) and (AttachmentIdsSL.Count > 0) then
        requestAttachs := True;
    end;

    if (BatchFileName <> '') and NeedProcessBatch then
      batchFileContent := GetEncodedBatchFileContent;

    try
      WriteExchangeLog(
        'Exchange',
        'Дата обновления, отправляемая на сервер: ' + GetXMLDateTime( DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime));

      AddPostParam('AccessTime', GetXMLDateTime( DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime));
      AddPostParam('GetEtalonData', BoolToStr( eaGetFullData in ExchangeForm.ExchangeActs, True));
      AddPostParam('ExeVersion', GetLibraryVersionFromPathForExe(ExePath + ExeName));
      AddPostParam('MDBVersion', DM.adtParams.FieldByName( 'ProviderMDBVersion').AsString);
      AddPostParam('UniqueID', IntToHex( GetCopyID, 8));
      GetWinVersion(WinNumber, WinDesc);
      AddPostParam('WINVersion', WinNumber);
      AddPostParam('WINDesc', WinDesc);

      if NeedProcessBatch then begin
        AddPostParam('ClientId', DM.adtClients.FieldByName( 'ClientId').AsString);
      end
      else begin
        AddPostParam('WaybillsOnly', BoolToStr( [eaGetWaybills, eaSendWaybills] * ExchangeForm.ExchangeActs <> [], True));
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
        //!!! Заполнение этих переменных нужно для корректного формирования
        //выгрузки автозаказа: отчета, заголовков заказа и позиций заказа
        GetMaxIds(MaxOrderId, MaxOrderListId, MaxBatchId);

        AddPostParam('BatchFile', batchFileContent);
        AddPostParam('MaxOrderId', MaxOrderId);
        AddPostParam('MaxOrderListId', MaxOrderListId);
        AddPostParam('MaxBatchId', MaxBatchId);
      end
      else begin
        //!!! Заполнение этих переменных нужно для корректного формирования
        //выгрузки неподтвержденных заказов с сервера (с 1стола): заголовков заказа и позиций заказа
        //Они будут выгружаться:
        // - у пользователя включена опция "Загружать неподтвержденные заказы"
        // - имеются неподтвержденные заказы
        // - значения переданных переменных MaxOrderId, MaxOrderListId > 0
        GetMaxIds(MaxOrderId, MaxOrderListId, MaxBatchId);

        AddPostParam('ClientHFile', '');
        AddPostParam('MaxOrderId', MaxOrderId);
        AddPostParam('MaxOrderListId', MaxOrderListId);
      end;

      for I := 0 to LibVersions.Count-1 do begin
        fi := TFileUpdateInfo(LibVersions[i]);
        AddPostParam('LibraryName', fi.FileName);
        AddPostParam('LibraryVersion', fi.Version);
        AddPostParam('LibraryHash', fi.MD5);
      end;

      if Assigned(AbsentPriceCodeSL) and (AbsentPriceCodeSL.Count > 0) then begin
        for I := 0 to AbsentPriceCodeSL.Count-1 do begin
          AddPostParam('PriceCodes', AbsentPriceCodeSL[i]);
        end;
      end
      else begin
        AddPostParam('PriceCodes', '0');
      end;

      if waybillsWithCertificate then
        for I := 0 to DocumentBodyIdsSL.Count-1 do
          AddPostParam('DocumentBodyIds', DocumentBodyIdsSL[i])
      else
        AddPostParam('DocumentBodyIds', '0');

      if requestAttachs then
        for I := 0 to AttachmentIdsSL.Count-1 do
          AddPostParam('AttachmentIds', AttachmentIdsSL[i])
      else
        AddPostParam('AttachmentIds', '0');

    finally
      LibVersions.Free;
    end;
    UpdateId := '';
    processAsync := False;
    if NeedProcessBatch then
      Res := SOAP.Invoke( 'PostOrderBatch', FPostParams)
    else begin
      if waybillsWithCertificate then
        Res := SOAP.Invoke( 'GetUserDataWithOrdersAsyncCert', FPostParams)
      else begin
        Res := SOAP.Invoke( 'GetUserDataWithAttachments', FPostParams);
      end;
    end;
    { проверяем отсутствие ошибки при удаленном запросе }
    Error := Utf8ToAnsi( Res.Values[ 'Error']);
    if Error <> '' then
      raise Exception.Create( Utf8ToAnsi( Res.Values[ 'Error'])
        + #13 + #10 + Utf8ToAnsi( Res.Values[ 'Desc']));

    if processAsync then
      DoProcessAsync(Res.Values[ 'URL']);

    //Если получили установленный флаг Cumulative, то делаем куммулятивное обновление
    if (Length(Res.Values['Cumulative']) > 0) and (StrToBool(Res.Values['Cumulative'])) then
      ExchangeForm.ExchangeActs := ExchangeForm.ExchangeActs + [eaGetFullData];

    ExchangeParams.ServerAddition := Utf8ToAnsi( Res.Values[ 'Addition']);
    if ExchangeParams.ServerAddition <> ''
    then
      FUserMessageParams.UpdateUserMessage(ExchangeParams.ServerAddition);

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
  finally
    FPostParams.Free;
  end;
  { очищаем папку In }
  DeleteFilesByMask( RootFolder() + SDirIn + '\*.txt');
  Synchronize( ExchangeForm.CheckStop);
end;

procedure TExchangeThread.DoExchange;
const
  FReconnectCount = 10;
var
  ErrorCount : Integer;
  PostSuccess : Boolean;
  StartFilePosition,
  Speed : Int64;
  DownSecs : Double;
  StartDownTime,
  EndDownTime : TDateTime;
begin
  //загрузка прайс-листа
  if ( [eaGetPrice, eaGetWaybills, eaSendWaybills, eaPostOrderBatch, eaGetHistoryOrders] * ExchangeForm.ExchangeActs <> [])
  then begin
//    Tracer.TR('DoExchange', 'Загрузка данных');
    SetStatusText('Загрузка данных');
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

      StartDownTime := Now();
      StartFilePosition := FileStream.Position;
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
            LastPacketTime := Now();

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
        try
          EndDownTime := Now();
          Speed := FileStream.Size - StartFilePosition;
          DownSecs := (EndDownTime - StartDownTime) * SecsPerDay;
          if DownSecs >= 1 then
            Speed := Round(Speed / DownSecs)
          else
            Speed := Round(Speed * DownSecs);
          WriteExchangeLog('Exchange', 'Скорость загрузки файла: ' + FormatSpeedSize(Speed));
        except
          on CalcException : Exception do begin
            WriteExchangeLog('DoExchange', 'Ошибка при вычислении скорости: ' + CalcException.Message);
          end;
        end;

      end;

      Synchronize( ExchangeForm.CheckStop);
    finally
      try
        ExchangeForm.HTTP.Disconnect;
      except
      end;

      FileStream.Free;
    end;
    if GetNetworkSettings.IsNetworkVersion then
      OSMoveFile(LocalFileName,
        RootFolder() + SDirIn + '\' + ExtractFileName(LocalFileName));
    Windows.CopyFile(
      PChar( RootFolder() + SDirIn + '\' + ExtractFileName(LocalFileName)),
      PChar( RootFolder() + SDirIn + '\' + ChangeFileExt( ExtractFileName(LocalFileName), '.zi_')), False);
//    Sleep( 10000);
  end;
end;

procedure TExchangeThread.CommitExchange;
const
  //Максимальный размер лога, отправляемый на сервер
  MaxLogLen = 300*1024;
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
        if (FS.Size > MaxLogLen)
        then begin
          FS.Position := (FS.Size - MaxLogLen);
          Len := MaxLogLen;
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
  
  if ((eaGetPrice in ExchangeForm.ExchangeActs) or (eaPostOrderBatch in ExchangeForm.ExchangeActs))
  then
    SendUserActions();
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
  SetStatusText('');
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
    SetStatusText('Распаковка данных');
    if FindFirst( RootFolder() + SDirIn + '\*.zip', faAnyFile, SR) = 0 then
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
            RootFolder() + SDirIn + '\' + SR.Name,
            '*.*',
            True,
            '',
            True,
            RootFolder() + SDirIn,
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
            [RootFolder() + SDirIn + '\' + SR.Name,
             SevenZipRes,
             SevenZip.LastSevenZipErrorCode,
             SevenZip.LastError]);

        OSDeleteFile( RootFolder() + SDirIn + '\' + SR.Name);
        //Если нет файла ".zi_", то это не является проблемой и импорт может быть осуществлен
        OSDeleteFile( RootFolder() + SDirIn + '\' + ChangeFileExt( SR.Name, '.zi_'), False);
      end;
      Synchronize( ExchangeForm.CheckStop);
    until FindNext( SR) <> 0;
  finally
    SysUtils.FindClose( SR);
  end;

  try

    //Переименовываем файлы с кодом клиента в файлы без код клиента
    if FindFirst( RootFolder() + SDirIn + '\*.txt', faAnyFile, DeleteSR) = 0 then
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
            RootFolder() + SDirIn + '\' + DeleteSR.Name,
            RootFolder() + SDirIn + '\' + NewImportFileName);
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
  //Обрабатываем папку Promotions
  ExtractDocs(SDirPromotions);
  //Обрабатываем папку Certificates
  ExtractDocs(SDirCertificates);
end;

procedure TExchangeThread.CheckNewExe;
begin
  if not SysUtils.DirectoryExists( RootFolder() + SDirIn + '\' + SDirExe) then exit;

  if GetNetworkSettings().IsNetworkVersion then begin
    DeleteDirectory(RootFolder() + SDirNetworkUpdate);
    DeleteDirectory(ExePath + SDirNetworkUpdate);
    CopyDirectories(RootFolder() + SDirIn + '\' + SDirExe, ExePath + SDirNetworkUpdate);
    MoveDirectories(RootFolder() + SDirIn + '\' + SDirExe, RootFolder() + SDirNetworkUpdate);
  end;

  AProc.MessageBox('Получена новая версия программы. Сейчас будет выполнено обновление', MB_OK or MB_ICONWARNING);

  if GetNetworkSettings().IsNetworkVersion then
    ShellExecute( 0, nil, 'rundll32.exe', PChar( ' '  + ExtractShortPathName(ExePath) + 'Eraser.dll,Erase ' + IfThen(SilentMode, '-si ', '-i ') + IntToStr(GetCurrentProcessId) + ' "' +
     ExePath + ExeName + '" "' + ExePath + SDirNetworkUpdate + '"'),
     nil, SW_SHOWNORMAL)
  else
    ShellExecute( 0, nil, 'rundll32.exe', PChar( ' '  + ExtractShortPathName(ExePath) + 'Eraser.dll,Erase ' + IfThen(SilentMode, '-si ', '-i ') + IntToStr(GetCurrentProcessId) + ' "' +
      ExePath + ExeName + '" "' + RootFolder() + SDirIn + '\' + SDirExe + '"'),
      nil, SW_SHOWNORMAL);
  raise Exception.Create( 'Terminate');
end;

procedure TExchangeThread.CheckNewMDB;
var
  updateParamsSql : String;
begin
  if (GetFileSize(RootFolder()+SDirIn+'\UpdateInfo.txt') > 0) then begin
    updateParamsSql := Trim(GetLoadDataSQL('params', RootFolder()+SDirIn+'\UpdateInfo.txt', True));
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
  if (GetFileSize(RootFolder()+SDirIn+'\ClientToAddressMigrations.txt') > 0) then
    ProcessClientToAddressMigration;

  if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then
  begin
    SetStatusText('Очистка таблиц');
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
    if FindFirst( RootFolder() + SDirIn + '\*.frf', faAnyFile, SR) = 0 then
      repeat
        if ( SR.Attr and faDirectory) = faDirectory then continue;
        try
          SourceFile := RootFolder() + SDirIn + '\' + SR.Name;
          DestFile := RootFolder() + '\' + SR.Name;
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
  SetStatusText('Резервное копирование данных');
  if not DatabaseController.IsBackuped then
    DatabaseController.BackupDatabase;

  TotalProgress := 65;
  Synchronize( SetTotalProgress);

  SetStatusText('Импорт данных');
  Progress := 0;
  Synchronize( SetProgress);
  DM.UnLinkExternalTables;
  DM.LinkExternalTables;

  UpdateTables := [];

  if (GetFileSize(RootFolder()+SDirIn+'\Catalogs.txt') > 0) then UpdateTables:=UpdateTables+[utCatalogs];
  if (GetFileSize(RootFolder()+SDirIn+'\Clients.txt') >= 0) then UpdateTables:=UpdateTables+[utClients];
  if (GetFileSize(RootFolder()+SDirIn+'\Providers.txt') > 0) then UpdateTables:=UpdateTables+[utProviders];
  if (GetFileSize(RootFolder()+SDirIn+'\RegionalData.txt') > 0) then UpdateTables:=UpdateTables+[utRegionalData];
  if (GetFileSize(RootFolder()+SDirIn+'\PricesData.txt') > 0) then UpdateTables:=UpdateTables+[utPricesData];
  if (GetFileSize(RootFolder()+SDirIn+'\PricesRegionalData.txt') > 0) then UpdateTables:=UpdateTables+[utPricesRegionalData];
  if (GetFileSize(RootFolder()+SDirIn+'\Core.txt') > 0) then UpdateTables:=UpdateTables+[utCore];
  if (GetFileSize(RootFolder()+SDirIn+'\Regions.txt') > 0) then UpdateTables:=UpdateTables+[utRegions];
  if (GetFileSize(RootFolder()+SDirIn+'\Synonyms.txt') > 0) then UpdateTables := UpdateTables + [utSynonyms];
  if (GetFileSize(RootFolder()+SDirIn+'\SynonymFirmCr.txt') > 0) then UpdateTables := UpdateTables + [utSynonymFirmCr];
  if (GetFileSize(RootFolder()+SDirIn+'\Rejects.txt') > 0) then UpdateTables := UpdateTables + [utRejects];
  //Удаляем минимальные цены, если есть обновления в Core
  if (GetFileSize(RootFolder()+SDirIn+'\Core.txt') > 0) then UpdateTables := UpdateTables + [utMinPrices];
  if (GetFileSize(RootFolder()+SDirIn+'\CatalogFarmGroups.txt') > 0) then UpdateTables := UpdateTables + [utCatalogFarmGroups];
  if (GetFileSize(RootFolder()+SDirIn+'\CatFarmGroupsDel.txt') > 0) then UpdateTables := UpdateTables + [utCatFarmGroupsDEL];
  if (GetFileSize(RootFolder()+SDirIn+'\CatalogNames.txt') > 0) then UpdateTables := UpdateTables + [utCatalogNames];
  if (GetFileSize(RootFolder()+SDirIn+'\Products.txt') > 0) then UpdateTables := UpdateTables + [utProducts];
  if (GetFileSize(RootFolder()+SDirIn+'\User.txt') > 0) then UpdateTables := UpdateTables + [utUser];
  if (GetFileSize(RootFolder()+SDirIn+'\DelayOfPayments.txt') > 0) then UpdateTables := UpdateTables + [utDelayOfPayments];
  if (GetFileSize(RootFolder()+SDirIn+'\Client.txt') > 0) then UpdateTables := UpdateTables + [utClient];
  if (GetFileSize(RootFolder()+SDirIn+'\MNN.txt') > 0) then UpdateTables := UpdateTables + [utMNN];
  if (GetFileSize(RootFolder()+SDirIn+'\Descriptions.txt') > 0) then UpdateTables := UpdateTables + [utDescriptions];
  if (GetFileSize(RootFolder()+SDirIn+'\MaxProducerCosts.txt') > 0) then UpdateTables := UpdateTables + [utMaxProducerCosts];
  if (GetFileSize(RootFolder()+SDirIn+'\Producers.txt') > 0) then UpdateTables := UpdateTables + [utProducers];
  if (GetFileSize(RootFolder()+SDirIn+'\MinReqRules.txt') > 0) then UpdateTables := UpdateTables + [utMinReqRules];
  if (GetFileSize(RootFolder()+SDirIn+'\BatchReport.txt') > 0) then UpdateTables := UpdateTables + [utBatchReport];
  if (GetFileSize(RootFolder()+SDirIn+'\DocumentHeaders.txt') > 0) then UpdateTables := UpdateTables + [utDocumentHeaders];
  if (GetFileSize(RootFolder()+SDirIn+'\DocumentBodies.txt') > 0) then UpdateTables := UpdateTables + [utDocumentBodies];
  if (GetFileSize(RootFolder()+SDirIn+'\SupplierPromotions.txt') > 0) then UpdateTables := UpdateTables + [utSupplierPromotions];
  if (GetFileSize(RootFolder()+SDirIn+'\PromotionCatalogs.txt') > 0) then UpdateTables := UpdateTables + [utPromotionCatalogs];
  if (GetFileSize(RootFolder()+SDirIn+'\CurrentOrderHeads.txt') > 0) then UpdateTables := UpdateTables + [utCurrentOrderHeads];
  if (GetFileSize(RootFolder()+SDirIn+'\InvoiceHeaders.txt') > 0) then UpdateTables := UpdateTables + [utInvoiceHeaders];
  if (GetFileSize(RootFolder()+SDirIn+'\Schedules.txt') > 0) then UpdateTables := UpdateTables + [utSchedules];
  if (GetFileSize(RootFolder()+SDirIn+'\CertificateRequests.txt') > 0) then UpdateTables := UpdateTables + [utCertificateRequests];
  if (GetFileSize(RootFolder()+SDirIn+'\Mails.txt') > 0) then UpdateTables := UpdateTables + [utMails];
  if (GetFileSize(RootFolder()+SDirIn+'\AttachmentRequests.txt') > 0) then UpdateTables := UpdateTables + [utAttachmentRequests];

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
    WriteExchangeLog('ImportData',
      Concat('Core before start import', #13#10,
        DM.DataSetToString('select PriceCode, RegionCode, count(COREID) from Core group by PriceCode, RegionCode', [], [])));

  //удаляем из таблиц ненужные данные: прайс-листы, регионы, поставщиков, которые теперь не доступны данному клиенту
  //PricesRegionalData
  if utPricesRegionalData in UpdateTables then begin
    SQL.Text:='DELETE FROM PricesRegionalData WHERE NOT Exists(SELECT PriceCode, RegionCode FROM TmpPricesRegionalData  WHERE PriceCode=PricesRegionalData.PriceCode AND RegionCode=PricesRegionalData.RegionCode);';
    InternalExecute;
    WriteExchangeLog('ImportData', 'Delete not exists: ' + IntToStr(DM.adcUpdate.RowsAffected));
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

  //utSchedules
  if (utSchedules in UpdateTables)
    or ([eaGetPrice, eaPostOrderBatch] * ExchangeForm.ExchangeActs <> [])
  then begin
    SQL.Text:='truncate Schedules;';
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

    WriteExchangeLog('ImportData', 'Deleted Prices: ' + deletedPriceCodes.CommaText);
    DM.adcUpdate.SQL.Text := 'delete from core where PriceCode = :PriceCode;';
    for I := 0 to deletedPriceCodes.Count-1 do begin
      DM.adcUpdate.ParamByName('PriceCode').AsString := deletedPriceCodes[i];
      InternalExecute;
      WriteExchangeLog('ImportData', 'Deleted position by price ' + deletedPriceCodes[i] + ' : ' + IntToStr(DM.adcUpdate.RowsAffected));
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
  WriteExchangeLog('ImportData', 'Deleted position by PricesRegionalData: ' + IntToStr(DM.adcUpdate.RowsAffected));
  //Если при удалении удалились какие-то записи из таблицы,
  //то помечаем Core и MinPrices на обновление
  if DM.adcUpdate.RowsAffected > 0 then
    UpdateTables := UpdateTables + [utCore, utMinPrices];

  //В связи с обновлением таблицы MinPrices надо заново его рассчитать,
  //чтобы на форме "Минимальные значения" отображались предложения  
  if DM.NeedUpdateToNewLibMySqlDWithGlobalParams then
    UpdateTables := UpdateTables + [utMinPrices];

  //MinPrices
  if utMinPrices in UpdateTables then begin
    //Обновление ServerCoreID в MinPrices
    SQL.Text:='truncate minprices ;';
    InternalExecute;
  end;
  //Core
  if utCore in UpdateTables then begin
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
      SQL.Text := GetLoadDataSQL('catalognames', RootFolder()+SDirIn+'\CatalogNames.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('catalognames', RootFolder()+SDirIn+'\CatalogNames.txt', true);
      InternalExecute;
    end;
  end;

  //Catalog
  if utCatalogs in UpdateTables then begin

    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('Catalogs', RootFolder()+SDirIn+'\Catalogs.txt');
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('Catalog RowAffected = %d', [RowsAffected]));
{$endif}
    end
    else begin
      //catalogs_iu
      SQL.Text := GetLoadDataSQL('Catalogs', RootFolder()+SDirIn+'\Catalogs.txt', true);
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
      SQL.Text := GetLoadDataSQL('MNN', RootFolder()+SDirIn+'\MNN.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('MNN', RootFolder()+SDirIn+'\MNN.txt', true);
      InternalExecute;
      SQL.Text := 'delete from mnn where Hidden = 1;';
      InternalExecute;
    end;
  end;

  //Descriptions
  if utDescriptions in UpdateTables then begin
    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('Descriptions', RootFolder()+SDirIn+'\Descriptions.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('Descriptions', RootFolder()+SDirIn+'\Descriptions.txt', true);
      InternalExecute;
      SQL.Text := 'delete from descriptions where Hidden = 1;';
      InternalExecute;
    end;
  end;

  if (utProducts in UpdateTables) then begin
    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('Products', RootFolder()+SDirIn+'\Products.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('Products', RootFolder()+SDirIn+'\Products.txt', true);
      InternalExecute;
    end;
  end;

  //Producers
  if utProducers in UpdateTables then begin
    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('Producers', RootFolder()+SDirIn+'\Producers.txt');
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('Producers RowAffected = %d', [RowsAffected]));
{$endif}
    end
    else begin
      SQL.Text := GetLoadDataSQL('Producers', RootFolder()+SDirIn+'\Producers.txt', true);
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('Producers RowAffected = %d', [RowsAffected]));
{$endif}
      SQL.Text := 'delete from producers where Hidden = 1;';
      InternalExecute;
    end;
  end;
  //
  if utPromotionCatalogs in UpdateTables then begin
    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('PromotionCatalogs', RootFolder()+SDirIn+'\PromotionCatalogs.txt');
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('PromotionCatalogs RowAffected = %d', [RowsAffected]));
{$endif}
    end
    else begin
      SQL.Text := GetLoadDataSQL('PromotionCatalogs', RootFolder()+SDirIn+'\PromotionCatalogs.txt', true);
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('PromotionCatalogs RowAffected = %d', [RowsAffected]));
{$endif}
      SQL.Text := 'delete from PromotionCatalogs where Hidden = 1;';
      InternalExecute;
    end;
  end;
  if utSupplierPromotions in UpdateTables then begin
    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('SupplierPromotions', RootFolder()+SDirIn+'\SupplierPromotions.txt');
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('SupplierPromotions RowAffected = %d', [RowsAffected]));
{$endif}
    end
    else begin
      SQL.Text := GetLoadDataSQL('SupplierPromotions', RootFolder()+SDirIn+'\SupplierPromotions.txt', true);
      InternalExecute;
{$ifdef DEBUG}
      WriteExchangeLog('Import', Format('SupplierPromotions RowAffected = %d', [RowsAffected]));
{$endif}
      SQL.Text := 'delete from SupplierPromotions where Status = 0;';
      InternalExecute;
    end;
  end;

  if utSchedules in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('Schedules', RootFolder()+SDirIn+'\Schedules.txt', true);
    InternalExecute;
  end;

  //CatalogFarmGroups
  if utCatalogFarmGroups in UpdateTables then begin
    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('CatalogFarmGroups', RootFolder()+SDirIn+'\CatalogFarmGroups.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('CatalogFarmGroups', RootFolder()+SDirIn+'\CatalogFarmGroups.txt', true);
      InternalExecute;
{
      if utCatFarmGroupsDel in UpdateTables then begin
        UpdateFromFileByParamsMySQL(
          RootFolder()+SDirIn+'\CatFarmGroupsDel.txt',
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
    SQL.Text := GetLoadDataSQL('Regions', RootFolder()+SDirIn+'\Regions.txt');
    InternalExecute;
  end;
  //User
  if utUser in UpdateTables then begin
    SQL.Text := 'truncate analitf.userinfo';
    InternalExecute;
    SQL.Text := GetLoadDataSQL('UserInfo', RootFolder()+SDirIn+'\User.txt');
    InternalExecute;
  end;
  //Client
  if utClient in UpdateTables then begin
    SQL.Text := 'truncate analitf.Client';
    InternalExecute;
    SQL.Text := GetLoadDataSQL('Client', RootFolder()+SDirIn+'\Client.txt');
    InternalExecute;
  end;
  //Clients
  if utClients in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('Clients', RootFolder()+SDirIn+'\Clients.txt', true);
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
    SQL.Text := GetLoadDataSQL('Providers', RootFolder()+SDirIn+'\Providers.txt');
    InternalExecute;
  end;
  if (utPromotionCatalogs in UpdateTables)
    or (utSupplierPromotions in UpdateTables)
    or (utProviders in UpdateTables)
  then
    ClearPromotions;
  if utDelayOfPayments in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('DelayOfPayments', RootFolder()+SDirIn+'\DelayOfPayments.txt');
    InternalExecute;
  end;
  //RegionalData
  if utRegionalData in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('RegionalData', RootFolder()+SDirIn+'\RegionalData.txt', true);
    InternalExecute;
  end;
  //PricesData
  if utPricesData in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('PricesData', RootFolder()+SDirIn+'\PricesData.txt');
    InternalExecute;
  end;
  //MinReqRules
  if utMinReqRules in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('MinReqRules', RootFolder()+SDirIn+'\MinReqRules.txt');
    InternalExecute;
  end;
  //PricesRegionalData
  if utPricesData in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('PricesRegionalData', RootFolder()+SDirIn+'\PricesRegionalData.txt', true);
    InternalExecute;
  end;

  Progress := 30;
  Synchronize( SetProgress);

  //Synonym
  if utSynonyms in UpdateTables then begin
    if (eaGetFullData in ExchangeForm.ExchangeActs) or DM.GetCumulative then begin
      SQL.Text := GetLoadDataSQL('Synonyms', RootFolder()+SDirIn+'\Synonyms.txt');
      InternalExecute;
    end
    else begin
      SQL.Text := GetLoadDataSQL('Synonyms', RootFolder()+SDirIn+'\Synonyms.txt', true);
      InternalExecute;
    end;
  end;
  //SynonymFirmCr
  if utSynonymFirmCr in UpdateTables then begin
    SQL.Text := GetLoadDataSQL('SynonymFirmCr', RootFolder()+SDirIn+'\SynonymFirmCr.txt', true);
    InternalExecute;
  end;
  //Core
  if utCore in UpdateTables then begin
    WriteExchangeLog('ImportData',
      Concat('Core before import', #13#10,
        DM.DataSetToString('select PriceCode, RegionCode, count(COREID) from Core group by PriceCode, RegionCode', [], [])));
    coreTestInsertSQl := GetLoadDataSQL('Core', RootFolder()+SDirIn+'\Core.txt');

{$ifndef DisableCrypt}
    SQL.Text :=
      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
      ' (PriceCode, RegionCode, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, ' +
      ' Code, CodeCr, Unit, Volume, Junk, Await, QUANTITY, Note, Period, Doc, ' +
      ' RegistryCost, VitallyImportant, REQUESTRATIO, CryptCost, SERVERCOREID, ' +
      ' ORDERCOST, MINORDERCOUNT, SupplierPriceMarkup, ProducerCost, NDS, RetailVitallyImportant, BuyingMatrixType);';
{$else}
    SQL.Text :=
      Copy(coreTestInsertSQl, 1, LENGTH(coreTestInsertSQl) - 1) +
      ' (PriceCode, RegionCode, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, ' +
      ' Code, CodeCr, Unit, Volume, Junk, Await, QUANTITY, Note, Period, Doc, ' +
      ' RegistryCost, VitallyImportant, REQUESTRATIO, Cost, SERVERCOREID, ' +
      ' ORDERCOST, MINORDERCOUNT, SupplierPriceMarkup, ProducerCost, NDS, RetailVitallyImportant, BuyingMatrixType);';
{$endif}

    InternalExecute;
    WriteExchangeLog('ImportData', 'Import Core count : ' + IntToStr(DM.adcUpdate.RowsAffected));
    WriteExchangeLog('ImportData',
      Concat('Core after import', #13#10,
        DM.DataSetToString('select PriceCode, RegionCode, count(COREID) from Core group by PriceCode, RegionCode', [], [])));

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
//    SQL.Text := GetLoadDataSQL('Core', RootFolder()+SDirIn+'\Core.txt');
//    InternalExecute;

//    Тесты для загрузки в CoreTest
//    SQL.Text:='truncate coretest ;';
//    InternalExecute;
//    coreTestInsertSQl := GetLoadDataSQL('CoreTest', RootFolder()+SDirIn+'\CoreTest.txt');
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
    if DM.QueryValue('select count(Id) from MaxProducerCosts', [], []) > 0 then begin
      SQL.Text:='truncate maxproducercosts;';
      InternalExecute;
    end;
    SQL.Text := GetLoadDataSQL('MaxProducerCosts', RootFolder()+SDirIn+'\MaxProducerCosts.txt');
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
      +'select Client.Id '
      +'from   Client '
      +'where  (Client.AllowDelayOfPayment = 1) ',
      [],
      []);
    SQL.Text := ''
      + 'drop temporary table if exists MinPricesNext;'
      + 'create temporary table MinPricesNext ('
      +'   `PRODUCTID` bigint(20) not null default ''0''   , '
      +'   `REGIONCODE` bigint(20) not null default ''0''  , '
      +'   `NextCost` decimal(18,2) default null           , '
      +'   `MinCostCount` int default ''0''                , '
      +'   primary key (`PRODUCTID`,`REGIONCODE`)            '
      + ') engine=Memory;';
    InternalExecute;
    if VarIsNull(MainClientIdAllowDelayOfPayment) then begin
      SQL.Text := ''
        + 'INSERT IGNORE '
        + 'INTO    MinPrices '
        + '(ProductId, RegionCode, MinCost) '
        + 'SELECT '
        + '  ProductId, '
        + '  RegionCode, '
        + '  min(if(Junk = 0, Cost, null)) '
        + 'FROM    Core '
        + 'GROUP BY ProductId, RegionCode';
      InternalExecute;
      SQL.Text := ''
        + 'insert ignore into MinPricesNext (ProductId, RegionCode, NextCost, MinCostCount) '
        + ' SELECT '
        + '   Core.ProductId, '
        + '   Core.RegionCode, '
        + '   min(nullif(Core.Cost, MinPrices.MinCost)) as NextCost, '
        + '   sum(Core.Cost = MinPrices.MinCost) as MinCostCount '
        + ' FROM '
        + '    MinPrices '
        + '    inner join Core on Core.ProductId = MinPrices.ProductId and Core.RegionCode = MinPrices.RegionCode and Core.Junk = 0 '
        + ' where '
        + '   MinPrices.MinCost is not null '
        + ' GROUP BY MinPrices.ProductId, MinPrices.RegionCode';
      InternalExecute;
    end
    else begin
      SQL.Text := ''
        + 'INSERT IGNORE '
        + 'INTO    MinPrices '
        + '(ProductId, RegionCode, MinCost) '
        +'select   Core.ProductId , '
        +'         Core.RegionCode, '
        +'         min( '
        +'             if(Junk <> 0, '
        +'                  null,'
        +'                  if(Delayofpayments.OtherDelay is null, '
        +'                      Cost, '
        +'                      if(Core.VitallyImportant || ifnull(catalogs.VitallyImportant, 0), '
        +'                          Cost * (1 + Delayofpayments.VitallyImportantDelay/100), '
        +'                          Cost * (1 + Delayofpayments.OtherDelay/100) '
        +'                       ) '
        +'                  ) '
        +'             ) '
        +'         ) '
        +'from     Core       '
        +'         inner join Pricesdata on Pricesdata.PRICECODE = Core.Pricecode '
        +'         left join products on products.ProductId = Core.ProductId '
        +'         left join catalogs on catalogs.FullCode = products.CatalogId '
        +'         left join Delayofpayments '
        +'           on (Delayofpayments.PriceCode = pricesdata.PriceCode) and '
        +'              (Delayofpayments.DayOfWeek = "' + TDayOfWeekHelper.DayOfWeek() + '") '
        +'group by Core.ProductId, '
        +'         Core.RegionCode';
      InternalExecute;
      SQL.Text := ''
        + 'insert ignore into MinPricesNext (ProductId, RegionCode, NextCost, MinCostCount) '
        + ' SELECT '
        + '   Core.ProductId, '
        + '   Core.RegionCode, '
        + '   min('
        + '        nullif('
        + '               cast( '
        + '                  if(Delayofpayments.OtherDelay is null, '
        + '                      Cost, '
        + '                      if(Core.VitallyImportant || ifnull(catalogs.VitallyImportant, 0), '
        + '                          Cost * (1 + Delayofpayments.VitallyImportantDelay/100), '
        + '                          Cost * (1 + Delayofpayments.OtherDelay/100) '
        + '                       ) '
        + '                  ) '
        + '               as decimal(18, 2)) '
        + '               , MinPrices.MinCost)'
        + '   ) as NextCost, '
        + '   sum( '
        + '       cast( '
        + '                  if(Delayofpayments.OtherDelay is null, '
        + '                      Cost, '
        + '                      if(Core.VitallyImportant || ifnull(catalogs.VitallyImportant, 0), '
        + '                          Cost * (1 + Delayofpayments.VitallyImportantDelay/100), '
        + '                          Cost * (1 + Delayofpayments.OtherDelay/100) '
        + '                       ) '
        + '                  ) '
        + '       as decimal(18, 2)) '
        + '       = '
        + '       MinPrices.MinCost'
        + '   ) as MinCostCount '
        + ' FROM '
        + '    MinPrices '
        + '    inner join Core on Core.ProductId = MinPrices.ProductId and Core.RegionCode = MinPrices.RegionCode and Core.Junk = 0 '
        + '    inner join Pricesdata on Pricesdata.PRICECODE     = Core.Pricecode '
        + '    left join products on products.ProductId = Core.ProductId '
        + '    left join catalogs on catalogs.FullCode = products.CatalogId '
        + '    left join Delayofpayments '
        + '      on (Delayofpayments.PriceCode = pricesdata.PriceCode)  and '
        + '              (Delayofpayments.DayOfWeek = "' + TDayOfWeekHelper.DayOfWeek() + '") '
        + ' where '
        + '   MinPrices.MinCost is not null '
        + ' GROUP BY MinPrices.ProductId, MinPrices.RegionCode';
      InternalExecute;
    end;

    SQL.Text := ''
      + ' update '
      + '   MinPrices '
      + '   left join MinPricesNext on MinPricesNext.ProductId = MinPrices.ProductId and MinPricesNext.RegionCode = MinPrices.RegionCode '
      + ' set '
      + '   MinPrices.NextCost = MinPricesNext.NextCost, '
      + '   MinPrices.Percent = if(MinPricesNext.NextCost is not null and MinPrices.MinCost is not null, (MinPricesNext.NextCost / MinPrices.MinCost - 1) * 100, null), '
      + '   MinPrices.MinCostcount = MinPricesNext.MinCostCount; ';
    InternalExecute;

    SQL.Text := 'drop temporary table if exists MinPricesNext';
    InternalExecute;
  end;
  Progress := 60;
  Synchronize( SetProgress);
  TotalProgress := 75;
  Synchronize( SetTotalProgress);

  DM.MainConnection.Close;
  DM.MainConnection.Open;

  SetStatusText('Импорт данных');

  SQL.Text := 'update catalogs set CoreExists = 0, PromotionsCount = 0, NamePromotionsCount = 0 where FullCode > 0'; InternalExecute;
  SQL.Text := 'update catalogs set CoreExists = 1 where FullCode > 0 and exists(select c.COREID from core c, products p where p.catalogid = catalogs.fullcode and c.productid = p.productid)';
  InternalExecute;
  SQL.Text :=
'update ' +
'  catalogs, ' +
'  (select ' +
'      pc.CatalogId, count(*) PCount ' +
' from ' +
'   SupplierPromotions promo ' +
'   join Providers on FirmCode = promo.SupplierId ' +
'   join PromotionCatalogs pc on pc.PromotionId = promo.Id ' +
'   group by pc.CatalogId ) ' +
'   as PromoCounts ' +
' set catalogs.PromotionsCount = PromoCounts.PCount ' +
' where catalogs.FullCode = PromoCounts.CatalogId';
  InternalExecute;
  SQL.Text :=
'update ' +
'  catalogs, ' +
'  (select ' +
'      cat.ShortCode, sum(cat.PromotionsCount) PCount ' +
' from ' +
'   catalogs cat ' +
'   where ' +
'     cat.PromotionsCount > 0 ' +
'   group by cat.ShortCode ) ' +
'   as PromoCounts ' +
' set catalogs.NamePromotionsCount = PromoCounts.PCount ' +
' where catalogs.ShortCode = PromoCounts.ShortCode';
  InternalExecute;
{$ifdef DEBUG}
  WriteExchangeLog('Import', Format('Catalogs RowAffected = %d', [RowsAffected]));
{$endif}
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
    SQL.Text := GetLoadDataSQL('Defectives', RootFolder()+SDirIn+'\Rejects.txt', True);
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
      +'select Client.Id '
      +'from   Client '
      +'where  (Client.AllowDelayOfPayment = 1) ',
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
        + '  MinPrices '
        + '  inner join Core on Core.ProductId = MinPrices.ProductId and Core.RegionCode = MinPrices.RegionCode '
        + '  inner join Pricesdata on Pricesdata.PRICECODE = Core.Pricecode '
        + '  left join products on products.ProductId = Core.ProductId '
        + '  left join catalogs on catalogs.FullCode = products.CatalogId '
        + '  left join Delayofpayments '
        + '    on (Delayofpayments.PriceCode = pricesdata.PriceCode) and '
        + '              (Delayofpayments.DayOfWeek = "' + TDayOfWeekHelper.DayOfWeek() + '") '
        + 'SET '
        + '  MinPrices.SERVERCOREID = Core.ServerCoreId, '
        + '  MinPrices.PriceCode  = Core.PriceCode '
        + 'WHERE '
        + '    ('
        + '       cast( '
        + '                  if(Delayofpayments.OtherDelay is null, '
        + '                      Cost, '
        + '                      if(Core.VitallyImportant || ifnull(catalogs.VitallyImportant, 0), '
        + '                          Cost * (1 + Delayofpayments.VitallyImportantDelay/100), '
        + '                          Cost * (1 + Delayofpayments.OtherDelay/100) '
        + '                       ) '
        + '                  ) '
        + '       as decimal(18, 2)) '
        + '      = '
        + '      MinPrices.MinCost'
        +'     )';
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

  if (utCurrentOrderHeads in UpdateTables)
  then
    ImportDownloadOrders;

  if (utDocumentHeaders in UpdateTables) or (utDocumentBodies in UpdateTables) or (utInvoiceHeaders in UpdateTables)
  then
    ImportDocs;

  if utCertificateRequests in UpdateTables then
    ImportCertificates();

  if (utMails in UpdateTables) or (utAttachmentRequests in UpdateTables) then
    ImportMails();

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
  DM.adtParams.FieldByName('StoredUserId').AsString :=
    DM.adsUser.FieldByName('UserId').AsString;
  DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime :=
    DM.adtParams.FieldByName( 'LastDateTime').AsDateTime;
  DM.adtParams.Post;
  TGlobalParamsHelper.SaveParam(DM.MainConnection, 'LocalUpdateDateTime', Now());
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
  if Assigned(DocumentBodyIdsSL) then
    DocumentBodyIdsSL.Free;
  if Assigned(AttachmentIdsSL) then
    AttachmentIdsSL.Free;
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

{$ifndef DisableCrypt}
  SetString(CostSessionKey, nil, INFDataLen);
  HexToBin(PChar(Res.Values['SessionKey']), PChar(CostSessionKey), INFDataLen);
{$else}
  CostSessionKey := '0123456789012345';
{$endif}

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
    SetStatusTextHTTP('Отправка настроек прайс-листов');
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
  CurrentPacketTime : TDateTime;
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
    CurrentPacketTime := Now();
    try

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

    if (ProgressPosition > 0)
      and (
        (ProgressPosition - Progress > 5)
        or (ProgressPosition > 97)
        or (Abs(CurrentPacketTime - LastPacketTime) > 1/SecsPerDay)
      )
    then
    begin
      Progress := ProgressPosition;
      Synchronize( SetProgress );
      StatusText := 'Загрузка данных   (' +
        FloatToStrF( Current, ffFixed, 10, 2) + ' ' + CSuffix + ' / ' +
        FloatToStrF( Total, ffFixed, 10, 2) + ' ' + TSuffix + ')';
      Synchronize( SetDownStatus );
//      Tracer.TR('Main.HTTPWork', 'StatusText : ' + StatusText);
    end;
    finally
      LastPacketTime := CurrentPacketTime;
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
  SetStatusTextHTTP('Отправка письма');

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
      frmSendLetter.mBody.Text,
      frmSendLetter.rgEmailGroup.ItemIndex);
  finally
    Attachs.Free;
  end;
end;

procedure TExchangeThread.ExtractDocs(DirName: String);
var
  DocsSR: TSearchRec;
begin
  if DirectoryExists(RootFolder() + SDirIn + '\' + DirName) then begin
    try
      if FindFirst( RootFolder() + SDirIn + '\' + DirName + '\*.*', faAnyFile, DocsSR) = 0 then
        repeat
          if (DocsSR.Name <> '.') and (DocsSR.Name <> '..') then
            OSMoveFile(
              RootFolder() + SDirIn + '\' + DirName + '\' + DocsSR.Name,
              RootFolder() + DirName + '\' + DocsSR.Name);
        until (FindNext( DocsSR ) <> 0)
    finally
      SysUtils.FindClose( DocsSR );
    end;
    AProc.RemoveDirectory(RootFolder() + SDirIn + '\' + DirName);
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
  ExchangeForm.HTTP.OnStatus := HTTPStatus;
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
        Body + #13#10 + 'Смотрите вложения.'#13#10 + 'С уважением,'#13#10 + '  AnalitF.exe',
        0);
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
{$ifdef DEBUG}
  Tracer.TR('Import', 'Exec : ' + DM.adcUpdate.SQL.Text);
{$endif}
  StartExec := Now;
  try
    DM.adcUpdate.Execute;
  finally
    StopExec := Now;
    Secs := SecondsBetween(StopExec, StartExec);
{$ifdef DEBUG}
    if Secs > 3 then
      Tracer.TR('Import', 'ExcecTime : ' + IntToStr(Secs));
{$endif}
  end;
end;

procedure TExchangeThread.DoSendSomeOrders;
var
  postController : TPostSomeOrdersController;
begin
  Synchronize( ExchangeForm.CheckStop);
  Synchronize( DisableCancel);
  SetStatusTextHTTP('Отправка заказов');

  postController := TPostSomeOrdersController
    .Create(
      DM,
      ExchangeParams,
      eaForceSendOrders in ExchangeForm.ExchangeActs,
      Soap,
      DM.adsUser.FieldByName('UseCorrectOrders').AsBoolean);
  try
    postController.PostSomeOrders;
  finally
    postController.Free;
    SetStatusText('');
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
        Format('Обновление клиентских данных невозможно из-за версии ОС: %d.%d',
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
  SetStatusTextHTTP('Загрузка накладных');

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
    SetStatusText('');
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
        GetLoadDataSQL('ClientToAddressMigrations', RootFolder()+SDirIn+'\ClientToAddressMigrations.txt');
      DM.adcUpdate.Execute;

      if DM.adsQueryValue.Active then DM.adsQueryValue.Close;
      DM.adsQueryValue.SQL.Text := 'select ClientCode, AddressId from analitf.ClientToAddressMigrations order by ClientCode';
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

  FillDistinctOrderAddresses('BatchOrder');

  DM.adcUpdate.SQL.Text := ''
    + ' delete from batchreport using batchreport, analitf.DistinctOrderAddresses where ClientID = AddressId;'
    + ' delete from batchreportservicefields using batchreportservicefields, analitf.DistinctOrderAddresses where ClientID = AddressId;';
  InternalExecute;

  DM.adcUpdate.SQL.Text := GetLoadDataSQL('batchreport', RootFolder()+SDirIn+'\batchreport.txt');
  InternalExecute;

  //Загружаем название служебных колонок относительно пользователя
  if (GetFileSize(RootFolder()+SDirIn+'\BatchReportServiceFields.txt') > 0) then begin
    insertSQL := Trim(GetLoadDataSQL('batchreportservicefields', RootFolder()+SDirIn+'\BatchReportServiceFields.txt'));
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1) +
      '(FieldName) set ClientId = '+ ClientID + ';';
    InternalExecute;
    DM.adcUpdate.SQL.Text := ''
      + ' insert into batchreportservicefields (ClientId, FieldName) '
      + ' select AddressId, FieldName '
      + ' from batchreportservicefields, analitf.DistinctOrderAddresses '
      + ' where ClientId = ' + ClientID + ' '
      + '    and AddressId <> ' + ClientID + ' '
      + ' order by AddressId, Id; ';
    InternalExecute;
  end;

  ImportOrders('BatchOrder', 'BatchOrderItems', False);

  //Сбрасываем OrderListId и статус у тех элементов BatchReport,
  //у которых не нашли соответствующую запись в CurrentOrderLists
  DM.adcUpdate.SQL.Text := ''
    + ' update batchreport, analitf.DistinctOrderAddresses '
    + ' set OrderListId = null, Status = (Status & ~(1 & 4)) | 2 '
    + ' where '
    + '       (batchreport.ClientId = DistinctOrderAddresses.AddressId)'
    + '   and (OrderListId is not null) '
    + '   and not exists(select Id from CurrentOrderLists where CurrentOrderLists.Id = OrderListId);';
  InternalExecute;
end;

procedure TExchangeThread.GetMaxIds(var MaxOrderId, MaxOrderListId,
  MaxBatchId: String);
begin
  MaxOrderId := DatabaseController().GetLastInsertId(DM.MainConnection, doiCurrentOrderHeads, 'ORDERID',
    ['CLIENTID', 'PRICECODE', 'REGIONCODE', 'CLOSED', 'SEND', 'Frozen']);

  MaxOrderListId := DatabaseController().GetLastInsertId(DM.MainConnection, doiCurrentOrderLists, 'ID',
    ['ORDERID', 'CLIENTID', 'PRODUCTID', 'AWAIT', 'JUNK', 'ORDERCOUNT', 'VitallyImportant', 'RetailVitallyImportant']);

  MaxBatchId := DatabaseController().GetLastInsertId(DM.MainConnection, doiBatchReport, 'ID',
    ['CLIENTID', 'Quantity']);
end;

procedure TExchangeThread.CommitHistoryOrders;
var
  params, values: array of string;
begin
  params := nil;
  values := nil;

  SetLength(params, 1);
  SetLength(values, 1);
  params[0]:= 'UpdateId';
  values[0]:= UpdateId;

  SOAP.Invoke( 'CommitHistoryOrders', params, values);
end;


procedure TExchangeThread.GetHistoryOrders;
const
  StaticParamCount : Integer = 12;
var
  FPostParams : TStringList;
  Res: TStrings;
  Error : String;
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
  SetStatusTextHTTP('Запрос истории заказов');
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
  DeleteFilesByMask( RootFolder() + SDirIn + '\*.txt');
  Synchronize( ExchangeForm.CheckStop);
  finally
    FPostParams.Free;
    Res.Free;
  end;
end;

procedure TExchangeThread.GetMaxPostedIds(var MaxOrderId,
  MaxOrderListId: String);
begin
  MaxOrderId := DatabaseController().GetLastInsertId(DM.MainConnection, doiPostedOrderHeads, 'ORDERID',
    ['CLIENTID', 'PRICECODE', 'REGIONCODE', 'CLOSED', 'SEND']);
  MaxOrderListId := DatabaseController().GetLastInsertId(DM.MainConnection, doiPostedOrderLists, 'ID',
    ['ORDERID', 'CLIENTID', 'PRODUCTID', 'AWAIT', 'JUNK', 'ORDERCOUNT', 'VitallyImportant', 'RetailVitallyImportant']);
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
  if (GetFileSize(RootFolder()+SDirIn+'\PostedOrderHeads.txt') > 0)
    and (GetFileSize(RootFolder()+SDirIn+'\PostedOrderLists.txt') > 0)
  then begin
    insertSQL := Trim(GetLoadDataSQL('PostedOrderHeads', RootFolder()+SDirIn+'\PostedOrderHeads.txt'));
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1) +
      '(ORDERID, ServerOrderId, CLIENTID, PRICECODE, REGIONCODE, SendDate, MessageTO, DelayOfPayment, PriceDate) set ORDERDATE = SendDate, Closed = 1, Send = 1;';
    InternalExecute;

    insertSQL := Trim(GetLoadDataSQL('PostedOrderLists', RootFolder()+SDirIn+'\PostedOrderLists.txt'));
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1)
      + ' (Id, ORDERID, CLIENTID, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, '
      + '  CODE, CODECr, Await, Junk, ORDERCOUNT, Price, RealPrice, REQUESTRATIO, ORDERCOST, MINORDERCOUNT, '
      + '  SupplierPriceMarkup, RetailMarkup, Unit, Volume, Note, Period, Doc, '
      + '  VitallyImportant, CoreQuantity, RegistryCost, ProducerCost, NDS, RetailCost);';
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
  OSDeleteFile(RootFolder()+SDirIn+'\PostedOrderHeads.txt');
  OSDeleteFile(RootFolder()+SDirIn+'\PostedOrderLists.txt');
end;

procedure TExchangeThread.ImportDocs;
var
  InputFileName : String;
  beforeWaybillCount,
  afterWaybillCount : Integer;
begin
  beforeWaybillCount := DM.QueryValue('select count(*) from analitf.DocumentHeaders;', [], []);
  if (GetFileSize(RootFolder()+SDirIn+'\DocumentHeaders.txt') > 0) then begin
    InputFileName := StringReplace(RootFolder()+SDirIn+'\DocumentHeaders.txt', '\', '/', [rfReplaceAll]);
    DM.adcUpdate.Close;
    DM.adcUpdate.SQL.Text :=
      Format(
      'LOAD DATA INFILE ''%s'' ignore into table analitf.%s' +
      '('
+'  `ServerId` , '
+'  `DownloadId` , '
+'  `WriteTime` , '
+'  `FirmCode` , '
+'  `ClientId` , '
+'  `DocumentType` , '
+'  `ProviderDocumentId` , '
+'  `OrderId` , '
+'  `Header` ' +
      ');'
      ,
      [InputFileName,
       'DocumentHeaders']);
    DM.adcUpdate.Execute;
    afterWaybillCount := DM.QueryValue('select count(*) from analitf.DocumentHeaders;', [], []);
    ExchangeParams.ImportDocs := afterWaybillCount > beforeWaybillCount;
  end;

  if (GetFileSize(RootFolder()+SDirIn+'\DocumentBodies.txt') > 0) then begin
    InputFileName := StringReplace(RootFolder()+SDirIn+'\DocumentBodies.txt', '\', '/', [rfReplaceAll]);
    DM.adcUpdate.Close;
    DM.adcUpdate.SQL.Text :=
      Format(
      'LOAD DATA INFILE ''%s'' ignore into table analitf.%s ' +
      ' ( ' +
      '    ServerId, DocumentId, Product, Code, Certificates, Period, Producer, ' +
      '    Country, ProducerCost, RegistryCost, SupplierPriceMarkup, ' +
      '    SupplierCostWithoutNDS, SupplierCost, Quantity, VitallyImportant, ' +
      '    NDS, SerialNumber, Amount, NdsAmount, Unit, ExciseTax, ' +
      '    BillOfEntryNumber, EAN13, ProductId, ProducerId ' +
      ' ) ' +
      'set Printed = 1;',
      [InputFileName,
       'DocumentBodies']);
    DM.adcUpdate.Execute;
  end;
  
  if (GetFileSize(RootFolder()+SDirIn+'\InvoiceHeaders.txt') > 0) then begin
    InputFileName := StringReplace(RootFolder()+SDirIn+'\InvoiceHeaders.txt', '\', '/', [rfReplaceAll]);
    DM.adcUpdate.Close;
    DM.adcUpdate.SQL.Text :=
      Format(
      'LOAD DATA INFILE ''%s'' ignore into table analitf.%s ' +
      ' ( ' +
      '    Id, InvoiceNumber, InvoiceDate, SellerName, SellerAddress, ' +
      '    SellerINN, SellerKPP, ShipperInfo, ConsigneeInfo, PaymentDocumentInfo, ' +
      '    BuyerName, BuyerAddress, BuyerINN, BuyerKPP, ' +
      '    AmountWithoutNDS0, AmountWithoutNDS10, NDSAmount10, Amount10, ' +
      '    AmountWithoutNDS18, NDSAmount18, Amount18, ' +
      '    AmountWithoutNDS, NDSAmount, Amount ' +
      ' ); ',
      [InputFileName,
       'InvoiceHeaders']);
    DM.adcUpdate.Execute;
  end;
end;

procedure TExchangeThread.ConfirmUserMessage;
var
  FPostParams : TStringList;
  InvokeResult : String;

  procedure AddPostParam(Param, Value: String);
  begin
    FPostParams.Add(Param + '=' + SOAP.PreparePostValue(Value));
  end;

begin
  FPostParams := TStringList.Create;
  try
  { запрашиваем данные }
  SetStatusTextHTTP('Подтверждение о прочтении');
  try
    AddPostParam('ExeVersion', GetLibraryVersionFromPathForExe(ExePath + ExeName));
    AddPostParam('UniqueID', IntToHex( GetCopyID, 8));

    AddPostParam('ConfirmedMessage', FUserMessageParams.UserMessage);

    InvokeResult := SOAP.SimpleInvoke('ConfirmUserMessage', FPostParams);

    if AnsiCompareText(InvokeResult, 'Res=Ok') = 0 then begin
      FUserMessageParams.ConfirmedMessage;
    end
    else begin
      WriteExchangeLog('ConfirmUserMessage', 'При подтверждении сообщения возникла ошибка: ' + InvokeResult);
    end;
    
  except
    on E: Exception do
    begin
      ExchangeParams.CriticalError := True;
      raise;
    end;
  end;
  Synchronize( ExchangeForm.CheckStop);
  finally
    FPostParams.Free;
  end;
end;

procedure TExchangeThread.SetStatusText(AStatusText: String);
begin
  StatusText := AStatusText;
  Synchronize( SetStatus );
end;

procedure TExchangeThread.SetStatusTextHTTP(AStatusText: String);
begin
  if FirstResponseServer then
    SetStatusText(AStatusText)
  else
    StatusBeforeFirst := AStatusText;
end;

procedure TExchangeThread.HTTPStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  WriteExchangeLog('Exchange', 'IdStatus : ' + AStatusText);
  if not FirstResponseServer then
    if AStatus = hsConnected then begin
      FirstResponseServer := True;
      SetStatusText(StatusBeforeFirst);
    end;
end;

procedure TExchangeThread.ProcessImportData;
var
  ProcessFatalMySqlError : Boolean;
begin
  TotalProgress := 50;
  Synchronize( SetTotalProgress);
  ExchangeParams.CriticalError := True;
  CheckNewExe;
  CheckNewFRF;
  CheckNewMDB;
  try
    //DM.adcUpdate.OnExecuteError := ThreadOnExecuteError;
    ProcessFatalMySqlError := False;
    repeat
    try
      ImportData;
      ProcessFatalMySqlError := False;
    except
      on EMyDb : EMyError do begin
        WriteExchangeLog('Exchange', 'Ошибка при импорте: ' + ExceptionToString(EMyDb));
        if not ProcessFatalMySqlError and DatabaseController.IsFatalError(EMyDb) then begin
          ProcessFatalMySqlError := True;
          WriteExchangeLog('Exchange',
            Format('Будем производить восстановление БД из-за ошибки: (%d) %s',
              [EMyDb.ErrorCode, EMyDb.Message]));
          if not RestoreDb then
            raise;    
        end
        else
          raise;
      end;
      on E : Exception do begin
        WriteExchangeLog('Exchange', 'Неожидаемая ошибка при импорте: ' + ExceptionToString(E));
        raise;
      end;
    end;
    until not ProcessFatalMySqlError;
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

  SetStatusText('Обновление завершено');
end;

function TExchangeThread.RestoreDb : Boolean;
var
  FEmbConnection : TMyEmbConnection;
  command : TMyQuery;
  Restored : Boolean;
begin
  Result := False;
  DM.MainConnection.Close;
  try
  Restored := False;
  try
    WriteExchangeLog('RestoreDb', 'Начали восстановление базы данных');

    FreeMySqlLibOnRestore;
    WriteExchangeLog('RestoreDb', 'Выгрузили библиотеку');

    FEmbConnection := TMyEmbConnection.Create(nil);
    FEmbConnection.Database := '';
    FEmbConnection.Username := DM.MainConnection.Username;
    FEmbConnection.DataDir := ExePath + SDirData;
    FEmbConnection.Options := TMyEmbConnection(DM.MainConnection).Options;
    FEmbConnection.Params.Clear;
    FEmbConnection.Params.AddStrings(TMyEmbConnection(DM.MainConnection).Params);
    FEmbConnection.LoginPrompt := False;

    try

      FEmbConnection.Open;
      try
        DatabaseController.CheckObjectsExists(FEmbConnection, False);
        WriteExchangeLog('RestoreDb', 'Проверили объекты базы данных');

        FEmbConnection.ExecSQL('use analitf', []);
        DatabaseController.CreateViews(FEmbConnection);
        command := TMyQuery.Create(FEmbConnection);
        try
          command.Connection := FEmbConnection;

          command.SQL.Text := 'select PriceCode from analitf.pricesshow';
          command.Open;
          command.Close;

          command.SQL.Text := 'select Id from analitf.params';
          command.Open;
          command.Close;

          command.SQL.Text := 'select CLIENTID from analitf.clients';
          command.Open;
          command.Close;

          command.SQL.Text := 'select Id from analitf.client';
          command.Open;
          command.Close;

          command.SQL.Text := 'select UserId from analitf.userinfo';
          command.Open;
          command.Close;
        finally
          command.Free;
        end;
      finally
        FEmbConnection.Close;
      end;
      WriteExchangeLog('RestoreDb', 'Проверили подключение к новой базе данных');

    finally
      FEmbConnection.Free;
    end;

    DatabaseController.BackupDataTables();
    WriteExchangeLog('RestoreDb', 'Произвели backup таблиц в TableBackup');

    Restored := True;
    WriteExchangeLog('RestoreDb', 'Восстановление базы данных успешно завершено');
  except
    on E : Exception do begin
      Restored := False;
      WriteExchangeLog('RestoreDb', 'Ошибка в нитке создания БД: ' + E.Message);
    end;
  end;
  Result := Restored;
  finally
    DM.MainConnection.Open;
  end;
end;

procedure TExchangeThread.FreeMySqlLibOnRestore;
begin
  //Все таки этот вызов нужен, т.к. не отпускаются определенные файлы при закрытии подключения
  //Если же кол-во подключенных клиентов будет больше 0, то этот вызов не сработает
  if DM.MainConnection is TMyEmbConnection then
    DatabaseController.FreeMySQLLib(
      'MySql Clients Count перед созданием базы данных',
      'FreeMySqlLibOnRestore');
end;

procedure TExchangeThread.ClearPromotions;
var
  SR: TSearchrec;
  FFileList : TStringList;
  I : Integer;
begin
  //Удаляем акции, по которым нет поставщиков
  DM.adcUpdate.SQL.Text:='' +
    ' DELETE FROM SupplierPromotions ' +
    ' using ' +
    '   SupplierPromotions ' +
    '   left join Providers on Providers.FirmCode = SupplierPromotions.SupplierId ' +
    ' WHERE ' +
    '     (SupplierPromotions.SupplierId is not null) ' +
    ' and (Providers.FirmCode is null);';
  InternalExecute;
  //Удаляем связи, по которым нет записей в каталоге
  DM.adcUpdate.SQL.Text:='' +
    ' DELETE FROM PromotionCatalogs ' +
    ' using ' +
    '   PromotionCatalogs ' +
    '   left join Catalogs on Catalogs.FullCode = PromotionCatalogs.CatalogId ' +
    ' WHERE ' +
    '     (PromotionCatalogs.CatalogId is not null) ' +
    ' and (Catalogs.FullCode is null);';
  InternalExecute;
  //Удаляем связи, по которым нет записей в списке акций
  DM.adcUpdate.SQL.Text:='' +
    ' DELETE FROM PromotionCatalogs ' +
    ' using ' +
    '   PromotionCatalogs ' +
    '   left join SupplierPromotions on SupplierPromotions.Id = PromotionCatalogs.PromotionId ' +
    ' WHERE ' +
    '     (PromotionCatalogs.CatalogId is not null) ' +
    ' and (SupplierPromotions.Id is null);';
  InternalExecute;

  FFileList := TStringList.Create;
  try
    try
      if SysUtils.FindFirst(RootFolder() + SDirPromotions + '\*.*', faAnyFile - faDirectory, SR ) = 0
      then
        repeat
          FFileList.Add(RootFolder() + SDirPromotions + '\' + SR.Name);
        until FindNext(SR)<>0;
    finally
      SysUtils.FindClose(SR);
    end;

    if FFileList.Count > 0 then
      for I := 0 to FFileList.Count-1 do
        ProcessPromoFileState(FFileList[i]);
  finally
    FFileList.Free;
  end;
end;

procedure TExchangeThread.ProcessPromoFileState(promoFileName: String);
var
  shortName : String;
  index : Integer;
  promotionId : String;
  promoExists : Boolean;
  id : Variant;
begin
  shortName := ChangeFileExt(ExtractFileName(promoFileName), '');
  index := Pos('_', shortName);
  if index <= 0 then
    promotionId := shortName
  else
    promotionId := StrUtils.LeftStr(shortName, index-1);
  promoExists := StrToIntDef(promotionId, 0) > 0;
  if promoExists then begin
    id := DM.QueryValue(
      'select Id from SupplierPromotions where Id = :Id',
      ['Id'],
      [promotionId]);
    promoExists := not VarIsNull(id) and (id > 0);
  end;

  if not promoExists then
    try
      OSDeleteFile(promoFileName);
    except
      on E : Exception do
        WriteExchangeLog('ImportData',
          'Ошибка при удалении файла промо-акции ' + shortName + ': ' +
          E.Message);
    end;
end;

procedure TExchangeThread.ImportOrders(OrderHeadsFile,
  OrderListsFile: String; FrozenOrders: Boolean);
var
  insertSQL : String;
begin
  {Здесь удаляем записи из batchreport и batchreportservicefields}

  if FrozenOrders then begin
    DM.adcUpdate.SQL.Text := ''
      + ' update CurrentOrderHeads, CurrentOrderLists, analitf.DistinctOrderAddresses '
      + ' set '
      + '   CurrentOrderHeads.Frozen = 1, '
      + '   CurrentOrderLists.CoreId = null '
      + ' where '
      + '       (CurrentOrderHeads.ClientId = DistinctOrderAddresses.AddressId) '
      + '   and (CurrentOrderHeads.Frozen = 0) '
      + '   and (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId);';
    InternalExecute;
  end
  else begin
    DM.adcUpdate.SQL.Text := ''
      + ' delete FROM CurrentOrderHeads, CurrentOrderLists '
      + ' using CurrentOrderHeads, CurrentOrderLists, analitf.DistinctOrderAddresses '
      + ' where '
      + '       (CurrentOrderHeads.ClientId = DistinctOrderAddresses.AddressId)'
      + '   and (CurrentOrderHeads.Frozen = 0) '
      + '   and (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId);';
    InternalExecute;
  end;

  {Здесь импортировали batchreport и batchreportservicefields}

  if (GetFileSize(RootFolder()+SDirIn+'\' + OrderHeadsFile + '.txt') > 0)
    and (GetFileSize(RootFolder()+SDirIn+'\' + OrderListsFile + '.txt') > 0)
  then begin
    insertSQL := Trim(GetLoadDataSQL('CurrentOrderHeads', RootFolder()+SDirIn+'\' + OrderHeadsFile + '.txt'));
    if FrozenOrders then begin
      DM.adcUpdate.SQL.Text :=
        Copy(insertSQL, 1, LENGTH(insertSQL) - 1) +
        '(ORDERID, CLIENTID, PRICECODE, REGIONCODE, @SendDate) set ORDERDATE = @SendDate + interval -:timezonebias minute, Closed = 0, Send = 1;';
      DM.adcUpdate.ParamByName('timezonebias').Value := TimeZoneBias;
      InternalExecute;
    end
    else begin
      DM.adcUpdate.SQL.Text :=
        Copy(insertSQL, 1, LENGTH(insertSQL) - 1) +
        '(ORDERID, CLIENTID, PRICECODE, REGIONCODE) set ORDERDATE = now(), Closed = 0, Send = 1;';
      InternalExecute;
    end;

    insertSQL := Trim(GetLoadDataSQL('CurrentOrderLists', RootFolder()+SDirIn+'\' + OrderListsFile + '.txt'));

{$ifndef DisableCrypt}
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1)
      + ' (Id, ORDERID, CLIENTID, COREID, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, '
      + '  CODE, CODECr, CryptRealPrice, CryptPrice, Await, Junk, ORDERCOUNT, REQUESTRATIO, ORDERCOST, MINORDERCOUNT, Period, ProducerCost);';
    InternalExecute;

    DM.adcUpdate.SQL.Text := ''
      + ' update CurrentOrderLists, analitf.DistinctOrderAddresses '
      + ' set '
      + '    CurrentOrderLists.Price = AES_DECRYPT(CurrentOrderLists.CryptPrice, "' + CostSessionKey + '"), '
      + '    CurrentOrderLists.CryptPrice = null '
      + ' where '
      + '       (CurrentOrderLists.ClientId = DistinctOrderAddresses.AddressId)'
      + '   and (CurrentOrderLists.CryptPrice is not null);'
      + ' update CurrentOrderLists, analitf.DistinctOrderAddresses '
      + ' set '
      + '    CurrentOrderLists.RealPrice = AES_DECRYPT(CurrentOrderLists.CryptRealPrice, "' + CostSessionKey + '"), '
      + '    CurrentOrderLists.CryptRealPrice = null '
      + ' where '
      + '       (CurrentOrderLists.ClientId = DistinctOrderAddresses.AddressId)'
      + '   and (CurrentOrderLists.CryptRealPrice is not null);';
    InternalExecute;
{$else}
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1)
      + ' (Id, ORDERID, CLIENTID, COREID, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, '
      + '  CODE, CODECr, RealPrice, Price, Await, Junk, ORDERCOUNT, REQUESTRATIO, ORDERCOST, MINORDERCOUNT, Period, ProducerCost);';
    InternalExecute;
{$endif}

    DM.adcUpdate.SQL.Text := ''
      + ' update CurrentOrderHeads, PricesData, analitf.DistinctOrderAddresses '
      + ' set CurrentOrderHeads.PriceName = PricesData.PriceName '
      + ' where '
      + '       (CurrentOrderHeads.ClientId = DistinctOrderAddresses.AddressId)'
      + '   and (CurrentOrderHeads.Frozen = 0) '
      + '   and (CurrentOrderHeads.PriceCode = PricesData.PriceCode);'
      + ' update CurrentOrderHeads, regions, analitf.DistinctOrderAddresses '
      + ' set CurrentOrderHeads.RegionName = regions.RegionName '
      + ' where '
      + '       (CurrentOrderHeads.ClientId = DistinctOrderAddresses.AddressId)'
      + '   and (CurrentOrderHeads.Frozen = 0) '
      + '   and (CurrentOrderHeads.RegionCode = regions.RegionCode);';
    InternalExecute;
    DM.adcUpdate.SQL.Text := ''
      + ' update CurrentOrderLists, synonyms, analitf.DistinctOrderAddresses '
      + ' set CurrentOrderLists.SYNONYMNAME = synonyms.SYNONYMNAME '
      + ' where '
      + '       (CurrentOrderLists.ClientId = DistinctOrderAddresses.AddressId)'
      + '   and (CurrentOrderLists.SYNONYMCODE = synonyms.SYNONYMCODE);'
      + ' update CurrentOrderLists, synonymfirmcr, analitf.DistinctOrderAddresses '
      + ' set CurrentOrderLists.SYNONYMFIRM = synonymfirmcr.SYNONYMNAME '
      + ' where '
      + '       (CurrentOrderLists.ClientId = DistinctOrderAddresses.AddressId)'
      + '   and (CurrentOrderLists.SYNONYMFIRMCRCODE = synonymfirmcr.SYNONYMFIRMCRCODE);';
    InternalExecute;
  end;

  {Здесь было}
  //Сбрасываем OrderListId и статус у тех элементов BatchReport,
  //у которых не нашли соответствующую запись в CurrentOrderLists
end;

procedure TExchangeThread.FillDistinctOrderAddresses(OrderHeadsFile: String);
var
  insertSQL : String;
  ClientId : String;
begin
  ClientId := DM.adtClients.FieldByName( 'ClientId').AsString;

  DM.adcUpdate.SQL.Text := 'drop temporary table if exists analitf.OrderAddresses, analitf.DistinctOrderAddresses;'
      + ' create temporary table analitf.OrderAddresses ('
      + '   `AddressId` bigint(20) unsigned not NULL ) ENGINE=MEMORY;'
      + 'insert into analitf.OrderAddresses (AddressId) value (' + ClientId + ');';
  InternalExecute;

  if (GetFileSize(ExePath+SDirIn+'\' + OrderHeadsFile + '.txt') > 0) then begin
    insertSQL := Trim(GetLoadDataSQL('OrderAddresses', ExePath+SDirIn+'\' + OrderHeadsFile + '.txt'));
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1) +
      '(@dummy, AddressId);';
    InternalExecute;
  end;

  DM.adcUpdate.SQL.Text := 'create temporary table analitf.DistinctOrderAddresses ENGINE=MEMORY as '
      + ' select distinct AddressId as AddressId from analitf.OrderAddresses ;';
  InternalExecute;
end;

procedure TExchangeThread.ImportDownloadOrders;
begin
  FillDistinctOrderAddresses('CurrentOrderHeads');
  ImportOrders('CurrentOrderHeads', 'CurrentOrderLists', True);
end;

procedure TExchangeThread.SendUserActions;
const
  MaxSendLogCount = 3000;
var
  Res: TStrings;
  ParamNames, ParamValues : array of String;
  logCount : Integer;
  limitCondition : String;
  exportFileName : String;
  archiveContent : String;
begin
  try
    logCount := GetUserLogCount();

    if logCount > 0 then begin
      if logCount <= MaxSendLogCount then
        limitCondition := ' limit ' + IntToStr(logCount)
      else
        limitCondition := ' limit ' + IntToStr(logCount - MaxSendLogCount) + ', 3000 ';

      exportFileName := ChangeFileExt(TDBGridHelper.GetTempFileToExport(), '.txt');
      try
        ExportUserLogs(exportFileName, limitCondition);

        archiveContent := GetEncodedUserLogsFileContent(exportFileName);

        SetLength(ParamNames, 3);
        SetLength(ParamValues, 3);
        ParamNames[0]  := 'ExeVersion';
        ParamValues[0] := GetLibraryVersionFromPathForExe(ExePath + ExeName);
        ParamNames[1]  := 'UpdateId';
        ParamValues[1] := GetUpdateId();
        ParamNames[2]  := 'UserActionLogsFile';
        ParamValues[2] := archiveContent;

        Res := SOAP.Invoke( 'SendUserActions', ParamNames, ParamValues);

        if AnsiContainsText(Res.Text, 'Res=OK') then
          DBProc.UpdateValue(
            DM.MainConnection,
            'delete from analitf.useractionlogs',
            [],
            [])
        else
          WriteExchangeLog('SendUserActions', 'При отправки статистики возникла ошибка: ' + Res.Text);

      finally
        if FileExists(exportFileName) then
          OSDeleteFile(exportFileName, False);
      end;
    end;
  except
    on E : Exception do
      WriteExchangeLog('SendUserActions', 'Ошибка: ' + ExceptionToString(E));
  end;
end;

function TExchangeThread.GetUserLogCount: Integer;
begin
  try
    Result := DM.QueryValue('SELECT COUNT(*) FROM UserActionLogs', [], []);
  except
    on E : Exception do begin
      Result := 0;
      WriteExchangeLog('GetUserLogCount', 'Ошибка: ' + ExceptionToString(E));
    end;
  end;
end;

procedure TExchangeThread.ExportUserLogs(exportFileName, limitCondition: String);
var
  MySqlPathToBackup : String;
begin
  MySqlPathToBackup := StringReplace(exportFileName, '\', '/', [rfReplaceAll]);
  try
    DBProc.UpdateValue(
      DM.MainConnection,
      Format(
        'select LogTime, UserActionId, Context from analitf.useractionlogs %s INTO OUTFILE ''%s'';',
        [
         limitCondition,
         MySqlPathToBackup
        ]
      ),
      [],
      []);
  except
    on E : Exception do begin
      WriteExchangeLog('ExportUserLogs', 'Во время экспорта логов возникла ошибка: ' + ExceptionToString(E));
      raise;
    end;
  end;
end;

function TExchangeThread.GetEncodedUserLogsFileContent(
  exportFileName: String): String;
var
  ah : TArchiveHelper;
begin
  ah := TArchiveHelper.Create(exportFileName);
  try
    Result := ah.GetEncodedContent();
  finally
    ah.Free;
  end;
end;

procedure TExchangeThread.GetCertificateRequests;
var
  absentQuery : TMyQuery;
begin
  try

    absentQuery := TMyQuery.Create(nil);
    absentQuery.Connection := DM.MainConnection;
    try
      absentQuery.SQL.Text := 'select ID from DocumentBodies where RequestCertificate = 1';

      absentQuery.Open;
      try
        if absentQuery.RecordCount > 0 then begin
          DocumentBodyIdsSL := TStringList.Create;
          while not absentQuery.Eof do begin
            DocumentBodyIdsSL.Add(absentQuery.FieldByName('Id').AsString);
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
      WriteExchangeLog('GetCertificateRequests.Error', E.Message);
  end;
end;

procedure TExchangeThread.ImportCertificates;
begin
  //Очищаем таблицу с логом запроса сертификата
  DM.adcUpdate.SQL.Text:='truncate CertificateRequests;';
  InternalExecute;

  if (GetFileSize(RootFolder()+SDirIn+'\CertificateRequests.txt') > 0) then begin
    DM.adcUpdate.SQL.Text := GetLoadDataSQL('CertificateRequests', RootFolder()+SDirIn+'\CertificateRequests.txt', true);
    InternalExecute;
  end;

  if (GetFileSize(RootFolder()+SDirIn+'\Certificates.txt') > 0) then begin
    DM.adcUpdate.SQL.Text := GetLoadDataSQL('Certificates', RootFolder()+SDirIn+'\Certificates.txt', true);
    InternalExecute;
  end;

  if (GetFileSize(RootFolder()+SDirIn+'\CertificateFiles.txt') > 0) then begin
    DM.adcUpdate.SQL.Text := GetLoadDataSQL('CertificateFiles', RootFolder()+SDirIn+'\CertificateFiles.txt', true);
    InternalExecute;
  end;

  if (GetFileSize(RootFolder()+SDirIn+'\CertificateSources.txt') > 0) then begin
    DM.adcUpdate.SQL.Text := GetLoadDataSQL('CertificateSources', RootFolder()+SDirIn+'\CertificateSources.txt', true);
    InternalExecute;
  end;

  if (GetFileSize(RootFolder()+SDirIn+'\SourceSuppliers.txt') > 0) then begin
    DM.adcUpdate.SQL.Text := GetLoadDataSQL('SourceSuppliers', RootFolder()+SDirIn+'\SourceSuppliers.txt', true);
    InternalExecute;
  end;

  if (GetFileSize(RootFolder()+SDirIn+'\FileCertificates.txt') > 0) then begin
    DM.adcUpdate.SQL.Text := GetLoadDataSQL('FileCertificates', RootFolder()+SDirIn+'\FileCertificates.txt', true);
    InternalExecute;
  end;
end;

procedure TExchangeThread.GetAttachmentRequests;
var
  absentQuery : TMyQuery;
begin
  try

    absentQuery := TMyQuery.Create(nil);
    absentQuery.Connection := DM.MainConnection;
    try
      absentQuery.SQL.Text := 'select ID from Attachments where RequestAttachment = 1';

      absentQuery.Open;
      try
        if absentQuery.RecordCount > 0 then begin
          AttachmentIdsSL := TStringList.Create;
          while not absentQuery.Eof do begin
            AttachmentIdsSL.Add(absentQuery.FieldByName('Id').AsString);
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
      WriteExchangeLog('GetAttachmentRequests.Error', E.Message);
  end;
end;

procedure TExchangeThread.ImportMails;
var
  insertSQL : String;
begin
  if (GetFileSize(RootFolder()+SDirIn+'\Mails.txt') > 0) then begin
    //Помечаем все новые письма без вложений, как старые
    DM.adcUpdate.SQL.Text:='update Mails set IsNewMail = 0 where not exists(select Attachments.Id from Attachments where Attachments.MailId = Mails.Id);';
    InternalExecute;

    insertSQL := Trim(GetLoadDataSQL('Mails', RootFolder()+SDirIn+'\Mails.txt', true));
    DM.adcUpdate.SQL.Text :=
      Copy(insertSQL, 1, LENGTH(insertSQL) - 1) +
      '(Id, LogTime, SupplierId, SupplierName, IsVIPMail, Subject, Body) set IsNewMail = 1;';
    InternalExecute;
    
    ExchangeParams.NewMailsExists := True;
  end;

  if (GetFileSize(RootFolder()+SDirIn+'\Attachments.txt') > 0) then begin
    DM.adcUpdate.SQL.Text := GetLoadDataSQL('Attachments', RootFolder()+SDirIn+'\Attachments.txt', true);
    InternalExecute;
  end;

  if (GetFileSize(RootFolder()+SDirIn+'\AttachmentRequests.txt') > 0) then begin
    //Очищаем таблицу с логом запроса сертификата
    DM.adcUpdate.SQL.Text:='truncate AttachmentRequests;';
    InternalExecute;

    DM.adcUpdate.SQL.Text := GetLoadDataSQL('AttachmentRequests', RootFolder()+SDirIn+'\AttachmentRequests.txt', true);
    InternalExecute;

    DM.adcUpdate.SQL.Text:='' +
    'update Mails, Attachments, AttachmentRequests ' +
    ' set ' +
    '  IsNewMail = 0, ' +
    '  RequestAttachment = 0, ' +
    '  RecievedAttachment  = 1 ' +
    ' where ' +
    '  Attachments.Id = AttachmentRequests.AttachmentId ' +
    '  and Mails.Id = Attachments.MailId ';
    InternalExecute;
  end;
end;

procedure TExchangeThread.DoProcessAsync(url: String);
var
  UpdateIdIndex : Integer;
  asyncUpdateId : String;
  asyncResponse : String;
  sleepCount : Integer;
begin
  asyncUpdateId := '';
  UpdateIdIndex := AnsiPos(UpperCase('?Id='), UpperCase(url));
  if UpdateIdIndex = 0 then begin
    WriteExchangeLog('Exchange', 'Не найдена строка "?Id=" в URL : ' + url);
    raise Exception.Create( 'При выполнении вашего запроса произошла ошибка.' +
      #10#13 + 'Повторите запрос через несколько минут.');
  end
  else begin
    asyncUpdateId := Copy(url, UpdateIdIndex + 4, Length(url));
    if asyncUpdateId = '' then begin
      WriteExchangeLog('Exchange', 'UpdateId - пустой, URL : ' + url);
      raise Exception.Create( 'При выполнении вашего запроса произошла ошибка.' +
        #10#13 + 'Повторите запрос через несколько минут.');
    end;
  end;

  asyncResponse := '';
  sleepCount := 0;
  repeat
    asyncResponse := SOAP.SimpleInvoke('CheckAsyncRequest', ['UpdateId'], [asyncUpdateId]);
    if (asyncResponse = 'Res=Wait') then begin
      Inc(sleepCount);
      Sleep(5000);
    end
    else
      Break;
  until ((asyncResponse = 'Res=OK') or (sleepCount > 20*12));

  if (asyncResponse <> 'Res=OK') then
    raise Exception.Create( 'При выполнении вашего запроса произошла ошибка.' +
      #10#13 + 'Повторите запрос через несколько минут.');
end;

initialization
finalization
  UnloadSevenZipDLL;
end.
