unit Exchange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ARas, StrUtils, ComObj,
  Variants, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExchangeThread, CheckLst, DateUtils,
  ActnList, Math, IdAuthentication, IdAntiFreezeBase, IdAntiFreeze, WinSock,
  IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, Contnrs,
  IdIOHandlerStack, IdSSL, U_VistaCorrectForm, ExchangeParameters,
  GlobalExchangeParameters,
  DayOfWeekHelper,
  U_CurrentOrderItem,
  U_CurrentOrderHead,
  U_Address,
  U_DBMapping,
  InternalRepareOrdersController;

type
  TExchangeAction=(
    eaGetPrice,
    eaSendOrders,
    eaImportOnly,
    eaGetFullData,
    eaMDBUpdate,
    eaGetWaybills,
    eaSendLetter,
    eaForceSendOrders,
    eaSendWaybills,
    eaPostOrderBatch,
    eaGetHistoryOrders,
    eaRequestAttachments);

  TExchangeActions=set of TExchangeAction;

  TExchangeForm = class(TVistaCorrectForm)
    btnCancel: TButton;
    Timer: TTimer;
    ProgressBar: TProgressBar;
    Ras: TARas;
    TotalProgress: TProgressBar;
    Image1: TImage;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    lblElapsed: TLabel;
    stStatus: TLabel;
    Timer1: TTimer;
    HTTP: TIdHTTP;
    HTTPReclame: TIdHTTP;
    sslMain: TIdSSLIOHandlerSocketOpenSSL;
    sslReclame: TIdSSLIOHandlerSocketOpenSSL;
    httpReceive: TIdHTTP;
    sslReceive: TIdSSLIOHandlerSocketOpenSSL;
    procedure RasStateChange(Sender: TObject; State: Integer;
      StateStr: String);
    procedure TimerTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FStatusPosition: Integer;
    ExchangeActions: TExchangeActions;
    StartTime: TTime;
    ConnectCount: integer;
    ConnectPause: cardinal;

    //Текст ошибки, которая произошла
    ErrMsg: string;

    //Содержимое статусного текста
    FStatusStr      : String;

    function GetAppHandle: HWND;
    function GetStatusText: string;
    procedure SetStatusText(Value: string);
    procedure SetStatusPosition(Value: Integer);
    procedure SetRasParams;
    procedure SetHTTPParams;
  public
    DoStop: Boolean;

    property StatusText: string read GetStatusText write SetStatusText;
    property StatusPosition: Integer write SetStatusPosition;
    property ExchangeActs: TExchangeActions read ExchangeActions write ExchangeActions;
    property AppHandle: HWND read GetAppHandle;
    procedure CheckStop;
    function PauseAfterError : TModalResult;
  end;

var
  ExchangeForm: TExchangeForm;
  ExThread: TExchangeThread;
  NeedRetrySendOrder : Boolean;
  NeedEditCurrentOrders : Boolean;
  NeedShowMiniMail : Boolean;
  BatchFileName : String;

procedure TryToRepareOrders();
procedure PrintOrdersAfterSend;
function RunExchange(AExchangeActions: TExchangeActions=[eaGetPrice]): Boolean;

implementation

uses Main, AProc, DModule, Retry, NotFound, Constant, Compact, NotOrders,
  CompactThread, DB, SQLWaiting, U_ExchangeLog, OrdersH, Orders,
  Child, Config, RxMemDS, CorrectOrders, PostSomeOrdersController,
  DatabaseObjects,
  PostWaybillsController,
  DocumentHeaders,
  U_OrderBatchForm,
  SendWaybillTypes,
  Exclusive,
  NetworkSettings,
  AddressController,
  UserMessageParams,
  SupplierController;

{$R *.DFM}

function RunExchange( AExchangeActions: TExchangeActions=[eaGetPrice]): Boolean;
var
//  hMenuHandle: HMENU;
  needAuth : Boolean;
begin
  NeedRetrySendOrder := False;
  NeedEditCurrentOrders := False;
  NeedShowMiniMail := False;
  //Перед запуском взаимодействия с сервером закрываем все дочерние окна
  MainForm.FreeChildForms;
  Result := False;
  if Assigned(GlobalExchangeParams) then
    FreeAndNil(GlobalExchangeParams);
  GlobalExchangeParams := nil;
  if AExchangeActions = [] then exit;
  if (eaPostOrderBatch in AExchangeActions) and (Length(BatchFileName) = 0) then
    Exit;

  if GetNetworkSettings().IsNetworkVersion then begin
    if GetNetworkSettings.DisableUpdate
      and ([eaGetPrice, eaGetFullData, eaGetWaybills, eaSendWaybills, eaPostOrderBatch, eaGetHistoryOrders, eaRequestAttachments] * AExchangeActions <> [])
    then
      Exit;
    if GetNetworkSettings.DisableSendOrders and (eaSendOrders in AExchangeActions)
    then
      Exit;
  end;

  try

  if (Length(DM.adtParams.FieldByName( 'HTTPName').AsString) = 0)
  then begin
    AProc.MessageBox( 'Для начала работы с программой необходимо заполнить учетные данные',
      MB_ICONWARNING or MB_OK);
    if FindCmdLineSwitch('e') then
      Exit
    else begin
      ShowConfig( True );
      if (Length(DM.adtParams.FieldByName( 'HTTPName').AsString) = 0) then
        Exit;
    end;
  end;

  if GetNetworkSettings().IsNetworkVersion then
    if [eaSendLetter] <> AExchangeActions then begin
      DM.GlobalExclusiveParams.ReadParams;
      if not DM.GlobalExclusiveParams.ClearOrSelfExclusive then
        Exit
      else
        if not ShowExclusive() then
          Exit;
    end;

  DM.DeleteEmptyOrders;

  //Если мы выставили флаг "Получать кумулятивное обновление", то при попытки обновления мы будем запрашивать кумулятивное,
  //кроме ситуации, когда пользователь делает "Импортирование данных"
  if DM.GetCumulative and ([eaImportOnly] <> AExchangeActions)
     and (eaGetPrice in AExchangeActions)
  then
    AExchangeActions := AExchangeActions + [eaGetFullData];

  if ( eaSendOrders in AExchangeActions) and not CheckMinReq then begin
    NeedEditCurrentOrders := True;
    Exit;
  end;

  if (eaGetFullData in AExchangeActions) then
    DM.ResetNeedCommitExchange;

  //выводим форму и начинаем обмен данными
  ExchangeForm := TExchangeForm.Create( Application);

  if not MainForm.Showing then ExchangeForm.Position := poDesktopCenter;
  try
    needAuth := False;
    repeat
      ExchangeForm.ErrMsg := '';
      if Assigned(GlobalExchangeParams) then
        FreeAndNil(GlobalExchangeParams);
      GlobalExchangeParams := nil;
      //Эти параметры выставляются всегда, раньше не выставлялись при импорте
      //Сейчас если импорт не пройдет, то будет производиться подключение к серверу, поэтому параметры необходимы
      ExchangeForm.SetRasParams;
      ExchangeForm.SetHTTPParams;

      ExchangeForm.ExchangeActions := AExchangeActions;
      WriteExchangeLog('Exchange', '-');
      WriteExchangeLog('Exchange', '-');
      WriteExchangeLog('Exchange', '-');
      WriteExchangeLog('Exchange', '---------------------------');
      WriteExchangeLog('Exchange', 'Сессия начата');
      try
        ExchangeForm.Timer.Enabled := True;
        DM.MainConnection.Close;
        Result := ExchangeForm.ShowModal = mrOk;
        if not Result then
          AProc.MessageBox(ExchangeForm.ErrMsg, MB_ICONERROR);
        Sleep(500);
        DM.MainConnection.Open;
        if not Result and AnsiStartsText('Доступ запрещен', ExchangeForm.ErrMsg)
        then begin
          if needAuth then
            needAuth := False
          else
            needAuth := (ShowConfig( True ) * AuthChanges) <> [];
        end
        else
          needAuth := False;
      except
        on E: Exception do
          AProc.MessageBox(Copy(E.Message, 1, 1024), MB_ICONSTOP);
      end;
      WriteExchangeLog('Exchange', 'Сессия окончена');
      WriteExchangeLog('Exchange', '---------------------------');
    until not needAuth;
  finally
    ExchangeForm.Free;
  end;

  //Сбрасываем флаг кумулятивного обновления, когда сделали успешное обновление,
  //или импортирование данных. Т.е. либо мы получили обновление, либо скорректировали входные данные,
  //что смогли их импортировать, либо получили свежую версию после установки новой программы и
  //импортировали данные после замены exe-файла.
  if Result and
    ((eaGetPrice in AExchangeActions) or (eaGetFullData in AExchangeActions)
      or (eaImportOnly in AExchangeActions)
      or (eaPostOrderBatch in AExchangeActions)
      )
  then
    DM.ResetCumulative;

  if (( eaGetPrice in AExchangeActions) or
      (eaImportOnly in AExchangeActions) or (eaGetFullData in AExchangeActions)
      or (eaPostOrderBatch in AExchangeActions)
      )
      and Result
  then
    TryToRepareOrders();

  if MainForm.ExchangeOnly then exit;

  if Result and (Trim(GlobalExchangeParams.ServerAddition) <> '')
  then
    ShowUserMessage(DM.MainConnection);

  if Result and (( eaGetPrice in AExchangeActions) or
    ( eaImportOnly in AExchangeActions) or (eaPostOrderBatch in AExchangeActions))
  then begin
    GetAddressController.UpdateAddresses(DM.MainConnection, DM.adtClientsCLIENTID.Value);
    GetSupplierController.UpdateSuppliers(DM.MainConnection);
    AProc.MessageBox('Обновление завершено успешно.', MB_OK or MB_ICONINFORMATION);
    if not GetNetworkSettings.IsNetworkVersion then
      if not WaybillsHelper.CheckWaybillFolders(DM.MainConnection) then
        AProc.MessageBox('Необходимо настроить папки для загрузки накладных на форме "Конфигурация"', MB_ICONWARNING);
  end;

  if Result and (eaRequestAttachments in AExchangeActions) then
    AProc.MessageBox('Запрос вложений завершен успешно успешно.', MB_OK or MB_ICONINFORMATION);

  if Result and ( [eaGetWaybills, eaSendWaybills] * AExchangeActions <> []) and DM.NeedShowCertificatesResults() then
    ShowNotFoundCertificates(DM.ShowCertificatesResults());

  if Result and (eaGetWaybills in AExchangeActions)
  then
    AProc.MessageBox('Получение документов завершено успешно.', MB_OK or MB_ICONINFORMATION);

  if Result and (eaSendWaybills in AExchangeActions)
  then begin
    case
      GlobalExchangeParams.SendWaybillsResult
    of
      swsNotFiles:
        AProc.MessageBox('Получение документов завершено успешно.', MB_OK or MB_ICONINFORMATION);
      swsOk:
        AProc.MessageBox('Загрузка накладных завершена успешно.', MB_OK or MB_ICONINFORMATION);
      swsRepeat:
        AProc.MessageBox(
         'Получение документов от поставщиков завершено успешно.'#13#10 +
         'Загрузку накладных повторите позднее.',
         MB_OK or MB_ICONWARNING);
      swsRetryLater:
        AProc.MessageBox(
         'Получение документов от поставщиков завершено успешно.'#13#10 +
         'Получение разобранных накладных повторите позднее.',
         MB_OK or MB_ICONWARNING);
    end;
  end;


  if Result and (eaSendLetter in AExchangeActions)
  then
    AProc.MessageBox('Письмо успешно отправлено.', MB_OK or MB_ICONINFORMATION);

  if Result and ([eaSendOrders] * AExchangeActions = [eaSendOrders]) then
  begin
    MainForm.SetOrdersInfo;
    if (GlobalExchangeParams.SendedOrdersErrorLog.Count = 0)
    then
      AProc.MessageBox('Отправка заказов завершена успешно.', MB_OK or MB_ICONINFORMATION);

    if ((DM.SaveGridMask and PrintSendedOrder) > 0)
      and (DM.adtParams.FieldByName('PrintOrdersAfterSend').AsBoolean)
      and (GlobalExchangeParams.SendedOrders.Count > 0)
    then
      PrintOrdersAfterSend;
  end;

  if Result and ([eaSendOrders] * AExchangeActions = [eaSendOrders])
    and (GlobalExchangeParams.SendedOrdersErrorLog.Count > 0)
  then begin
    NeedRetrySendOrder := True;
  end;

  //Если успешный результат и есть полученные вложения мини-почты, то открываем файлы
  if Result and (GlobalExchangeParams.RecievedAttachments.Count > 0) then
    DM.ShowAttachments(GlobalExchangeParams.RecievedAttachments);

  //Пробуем открыть полученные накладные, отказы и документы от АК Инфорум
  if Result and (( eaGetPrice in AExchangeActions) or
    ( eaGetWaybills in AExchangeActions) or (eaSendWaybills in AExchangeActions)
    or (eaImportOnly in AExchangeActions) or (eaPostOrderBatch in AExchangeActions)
    or (eaGetHistoryOrders in AExchangeActions) or (eaRequestAttachments in AExchangeActions))
  then
    DM.ProcessDocs(GlobalExchangeParams.ImportDocs);

  if Result and (AExchangeActions = [ eaGetHistoryOrders])
  then
    if GlobalExchangeParams.FullHistoryOrders
    then
      AProc.MessageBox('С сервера загружена вся история заказов и документов.', MB_OK or MB_ICONINFORMATION)
    else
      AProc.MessageBox('Загрузка истории заказов и документов завершена успешно.', MB_OK or MB_ICONINFORMATION);

  if Result and GlobalExchangeParams.NewMailsExists then
    NeedShowMiniMail := True;

  MainForm.UpdateReclame;

//В специализированной сборке не работает пока сжатие базы данных,
//незачем его сейчас запускать и при оригинальной сборке
  if Result and ( eaGetPrice in AExchangeActions) and
    ( DaysBetween( DM.adtParams.FieldByName( 'LastCompact').AsDateTime, Now) >= COMPACT_PERIOD) then
  begin
    //Перед началом сжатия базы данных закрываем все дочерние окна. Возможно, это не надо делать,
    //т.к. дочерние окна закрывали ранее
    MainForm.FreeChildForms;
    Application.ProcessMessages;
    RunCompactDatabase;
  end;

  if Result then
    if (eaPostOrderBatch in AExchangeActions) then
      ShowOrderBatch
    else
      if ( (eaGetWaybills in AExchangeActions) or (eaSendWaybills in AExchangeActions)
           or (eaImportOnly in AExchangeActions) or (eaGetHistoryOrders in AExchangeActions))
         and GlobalExchangeParams.ImportDocs
      then
        ShowDocumentHeaders;

  finally
    BatchFileName := '';
    if ([eaSendLetter] <> AExchangeActions) and DM.GlobalExclusiveParams.SelfExclusive then
      try DM.GlobalExclusiveParams.ResetExclusive; except end;
    if Assigned(GlobalExchangeParams) then
      try FreeAndNil(GlobalExchangeParams) except end;
  end;
end;

//Распечатываем отправленные заказы
procedure PrintOrdersAfterSend;
var
  I : Integer;
  PrintDialog : TPrintDialog;
begin
  PrintDialog := TPrintDialog.Create(Application);
  try

    if PrintDialog.Execute then
      for I := 0 to GlobalExchangeParams.SendedOrders.Count-1 do
        DM.ShowOrderDetailsReport(
          StrToInt(GlobalExchangeParams.SendedOrders[i]),
          True,
          True,
          False,
          False);

  finally
    PrintDialog.Free;
  end;

end;

{ Восстанавливаем заказы после обновления }
procedure TryToRepareOrders();
var
  t : TInternalRepareOrders;
begin
  t := TInternalRepareOrders.Create;
  try
    t.ProcessSendOrdersResponse := False;
    t.RepareOrders;
  finally
    t.Free;
  end;
end;


//пауза после ошибки
function TExchangeForm.PauseAfterError : TModalResult;
begin
  RetryForm := TRetryForm.Create( Application);
  RetryForm.lblError.Caption := GlobalExchangeParams.ErrorMessage;
  RetryForm.Seconds := ConnectPause;
  Result := RetryForm.ShowModal;
  RetryForm.Close;
  RetryForm.Free;
end;

procedure TExchangeForm.TimerTimer(Sender: TObject);
var
  ConnectNumber: Integer;
begin
  //здесь производим те действия, которые могут быть отменены
  StartTime := Now;
  FStatusStr := '';
  Timer1.Enabled := True;
  Timer.Enabled := False;
  DoStop := False;

  Caption := 'Обмен данными';

  //главный цикл соединения
  for ConnectNumber := 1 to ConnectCount do
  begin
    ExThread := TExchangeThread.Create( False);
    GlobalExchangeParams := ExThread.ExchangeParams;
    while not GlobalExchangeParams.Terminated do
    begin
      CheckSynchronize;
      Application.ProcessMessages;
      Sleep( 10);
    end;

    if GlobalExchangeParams.ErrorMessage <> '' then
    begin
      if ( ConnectNumber < ConnectCount) and not GlobalExchangeParams.CriticalError then begin
        if PauseAfterError = mrCancel then begin
          btnCancel.Click;
          break;
        end;
      end
      else begin
        //Разрываем DialUp в случае ошибки
        try
          Ras.Disconnect;
        except
        end;
        break;
      end;
    end
    else break;
  end;

  ErrMsg := GlobalExchangeParams.ErrorMessage;

  { Требуется завершение программы }
  if Assigned( ExThread) and ( ErrMsg = 'Terminate') then
  begin
    DM.MainConnection.Close;
    Application.Terminate;
  end;

  if Assigned( ExThread) and ( ErrMsg <> '') then
  begin
    //Эта ситация происходит когда возникает ошибка или пользователь отменяет действие
    ModalResult := mrAbort;
    {
    Здесь надо все переделать в связи с требованием #1632 Ошибка при обновлении
    При отмене обмена данными (нажатии на кнопку "Отмена") нельзя просто
    удалить нитку ExThread, надо либо дождаться удаления дочерних ниток,
    либо отвязать их, чтобы они не обновляли ChildThreads,
    а то возникает ошибка при обращении к ChildThreads
    }
    if Assigned( ExThread) then
      FreeAndNil(ExThread);
  end
  else
  begin
    ModalResult := mrOk;
    //Это тоже относится к требованию #1632 Ошибка при обновлении
    if Assigned( ExThread) then
      FreeAndNil(ExThread);
  end;
end;


procedure TExchangeForm.CheckStop;
begin
  StatusPosition := 0;
  if DoStop then
  begin
    GlobalExchangeParams.Terminated := True;
    Abort;
  end;
end;

procedure TExchangeForm.RasStateChange(Sender: TObject; State: Integer;
  StateStr: String);
begin
  StatusText := StateStr;
end;

procedure TExchangeForm.btnCancelClick(Sender: TObject);
begin
  if GlobalExchangeParams.DownloadChildThreads then
    ExThread.StopChildThreads
  else
    try
      //Сначала установлю сообщение и помечу, что возникла критическая ошибка,
      //а потом выставлю флаг DoStop, что EAbort в ExchangeThread не было обработано первым 
      GlobalExchangeParams.ErrorMessage := UserAbortMessage;
      GlobalExchangeParams.CriticalError := True;
      DoStop := True;
      HTTP.Disconnect;
      Ras.Disconnect;
    except
    end;
  DoStop := True;
end;

procedure TExchangeForm.SetRasParams;
begin
  // параметры удаленного соединения
  if DM.adtParams.FieldByName( 'RasConnect').AsBoolean then
  begin
    Ras.Entry := DM.adtParams.FieldByName( 'RasEntry').AsString;
    Ras.UserName := DM.adtParams.FieldByName( 'RasName').AsString;
    Ras.Password := DM.adtParams.FieldByName( 'RasPass').AsString;
  end;
end;

procedure TExchangeForm.SetHTTPParams;
begin
  DM.InternalSetHTTPParams(HTTP);
  DM.InternalSetHTTPParams(HTTPReclame);
  DM.InternalSetHTTPParams(httpReceive);
  AProc.InternalSetSSLParams(sslMain);
  AProc.InternalSetSSLParams(sslReclame);
  AProc.InternalSetSSLParams(sslReceive);
end;

function TExchangeForm.GetAppHandle: HWND;
begin
  result := Application.Handle;
end;

function TExchangeForm.GetStatusText: string;
begin
  result := stStatus.Caption;
end;

procedure TExchangeForm.SetStatusText(Value: string);
begin
  Value := Trim( Value);
  stStatus.Caption := Value;
  if Value <> '' then
    WriteExchangeLog('Exchange', Value);
  Application.ProcessMessages;
end;

procedure TExchangeForm.SetStatusPosition(Value: Integer);
begin
  if FStatusPosition<>Value then
  begin
    FStatusPosition := Value;
    ProgressBar.Position := Value;
    Application.ProcessMessages;
  end;
end;

procedure TExchangeForm.Timer1Timer(Sender: TObject);
begin
  lblElapsed.Caption := TimeToStr( Now - StartTime);
end;

procedure TExchangeForm.FormCreate(Sender: TObject);
begin
  HTTP.ConnectTimeout := -2;
  HTTPReclame.ConnectTimeout := -2;
  httpReceive.ConnectTimeout := -2;
  ConnectCount := DM.adtParams.FieldByName( 'ConnectCount').AsInteger;
  ConnectPause := DM.adtParams.FieldByName( 'ConnectPause').AsInteger;
end;

initialization
  BatchFileName := '';
  ExThread := nil;
finalization
end.
