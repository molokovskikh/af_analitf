unit Exchange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ARas, StrUtils, ComObj,
  Variants, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExchangeThread, CheckLst, DateUtils,
  ActnList, Math, IdAuthentication, IdAntiFreezeBase, IdAntiFreeze, WinSock,
  IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, FIBDataSet, Contnrs,
  IdIOHandlerStack, IdSSL, U_VistaCorrectForm;

type
  TExchangeAction=( eaGetPrice, eaSendOrders, eaImportOnly, eaGetFullData, eaMDBUpdate, eaGetWaybills, eaSendLetter);

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
    procedure HTTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
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
  GlobalExchangeParams : TObjectList;

procedure TryToRepareOrders;
procedure PrintOrdersAfterSend;
function RunExchange(AExchangeActions: TExchangeActions=[eaGetPrice]): Boolean;

implementation

uses Main, AProc, DModule, Retry, NotFound, Constant, Compact, NotOrders,
  CompactThread, DB, SQLWaiting, U_ExchangeLog, OrdersH, Orders,
  Child, Config, RxMemDS, CorrectOrders;

{$R *.DFM}

type
  TInternalRepareOrders = class
   public
    Strings  : TStrings;
    mdOutput : TRxMemoryData;
    procedure RepareOrders;
    procedure InternalRepareOrders;
    procedure FillData;
    procedure FormatOutput;
  end;



function RunExchange( AExchangeActions: TExchangeActions=[eaGetPrice]): Boolean;
var
	mr: integer;
//	hMenuHandle: HMENU;
begin
  //Перед запуском взаимодействия с сервером закрываем все дочерние окна
  MainForm.FreeChildForms;
	Result := False;
  if Assigned(GlobalExchangeParams) then
    FreeAndNil(GlobalExchangeParams);
  GlobalExchangeParams := nil;
	if AExchangeActions = [] then exit;

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

	DM.DeleteEmptyOrders;

  //Если мы выставили флаг "Получать кумулятивное обновление", то при попытки обновления мы будем запрашивать кумулятивное,
  //кроме ситуации, когда пользователь делает "Импортирование данных"
	if DM.GetCumulative and ([eaImportOnly] <> AExchangeActions)
     and (eaGetPrice in AExchangeActions)
  then
    AExchangeActions := AExchangeActions + [eaGetFullData];

	if ( eaSendOrders in AExchangeActions) and not CheckMinReq then exit;

	if ( eaGetPrice in AExchangeActions) and not ( eaGetFullData in AExchangeActions) and
		(DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime <>
		DM.adtParams.FieldByName( 'LastDateTime').AsDateTime) then
	begin
    AProc.MessageBox('Предыдущая операция импорта данных не была завершена.' + #10#13 +
			'Обратитесь в АК "Инфорум"', MB_OK or MB_ICONWARNING);
		exit;
	end;

  if (eaGetFullData in AExchangeActions) then
    DM.ResetNeedCommitExchange;

	//выводим форму и начинаем обмен данными
	ExchangeForm := TExchangeForm.Create( Application);

	if not MainForm.Showing then ExchangeForm.Position := poDesktopCenter;
	try
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
		except
			on E: Exception do
        AProc.MessageBox(Copy(E.Message, 1, 1024), MB_ICONSTOP);
		end;
    WriteExchangeLog('Exchange', 'Сессия окончена');
    WriteExchangeLog('Exchange', '---------------------------');
  finally
		ExchangeForm.Free;
	end;

  //Сбрасываем флаг кумулятивного обновления, когда сделали успешное обновление,
  //или импортирование данных. Т.е. либо мы получили обновление, либо скорректировали входные данные,
  //что смогли их импортировать, либо получили свежую версию после установки новой программы и
  //импортировали данные после замены exe-файла.  
	if Result and
    ((eaGetPrice in AExchangeActions) or (eaGetFullData in AExchangeActions)
      or (eaImportOnly in AExchangeActions))
  then
    DM.ResetCumulative;

	if (( eaGetPrice in AExchangeActions) or
		  (eaImportOnly in AExchangeActions) or (eaGetFullData in AExchangeActions))
      and Result
  then
    TryToRepareOrders;

	if MainForm.ExchangeOnly then exit;

	if Result and (Trim(TStringValue(GlobalExchangeParams[Integer(epServerAddition)]).Value) <> '')
  then
    AProc.MessageBoxEx(
			TStringValue(GlobalExchangeParams[Integer(epServerAddition)]).Value,
      'Сообщение от АК "Инфорум"',
			MB_OK or MB_ICONINFORMATION);

	if Result and (( eaGetPrice in AExchangeActions) or
		( eaImportOnly in AExchangeActions))
  then
    AProc.MessageBox('Обновление завершено успешно.', MB_OK or MB_ICONINFORMATION);

	if Result and (eaGetWaybills in AExchangeActions)
  then
    AProc.MessageBox('Получение документов завершено успешно.', MB_OK or MB_ICONINFORMATION);

	if Result and (eaSendLetter in AExchangeActions)
  then
    AProc.MessageBox('Письмо успешно отправлено.', MB_OK or MB_ICONINFORMATION);

	if Result and ( AExchangeActions = [ eaSendOrders]) then
  begin
    MainForm.SetOrdersInfo;
    if (TStringList(GlobalExchangeParams[Integer(epSendedOrdersErrorLog)]).Count = 0)
    then
      AProc.MessageBox('Отправка заказов завершена успешно.', MB_OK or MB_ICONINFORMATION)
    else
      AProc.MessageBox('Отправка заказов завершена с ошибками.', MB_OK or MB_ICONWARNING);

    if ((DM.SaveGridMask and PrintSendedOrder) > 0)
      and (DM.adtParams.FieldByName('PrintOrdersAfterSend').AsBoolean)
      and (TStringList(GlobalExchangeParams[Integer(epSendedOrders)]).Count > 0)
    then
      PrintOrdersAfterSend;
  end;

	if Result and ( AExchangeActions = [ eaSendOrders])
    and (TStringList(GlobalExchangeParams[Integer(epSendedOrdersErrorLog)]).Count > 0)
  then
    if AProc.MessageBox(
        'Во время отправки заказов возникли ошибки. ' +
            'Желаете посмотреть журнал ошибок?',
        MB_ICONWARNING or MB_YESNO) = IDYES
    then
      ShowNotSended(TStringList(GlobalExchangeParams[Integer(epSendedOrdersErrorLog)]).Text);

  //Пробуем открыть полученные накладные, отказы и документы от АК Инфорум
	if Result and (( eaGetPrice in AExchangeActions) or
		( eaGetWaybills in AExchangeActions))
  then
    DM.ProcessDocs;

	MainForm.UpdateReclame;

	if Result and ( eaGetPrice in AExchangeActions) and
		( DaysBetween( DM.adtParams.FieldByName( 'LastCompact').AsDateTime, Now) >= COMPACT_PERIOD) then
	begin
		CompactForm := TCompactForm.Create( Application);
		CompactForm.lblMessage.Caption := 'Сжатие базы не производилось более ' +
			IntToStr( COMPACT_PERIOD) + ' дней.' + #10 + #13 +
			'Произвести сжатие базы? (Рекомендуется)';
		mr := CompactForm.ShowModal;
		CompactForm.Close;
		CompactForm.Free;
		if mr = mrOK then begin
      //Перед началом сжатия базы данных закрываем все дочерние окна. Возможно, это не надо делать,
      //т.к. дочерние окна закрывали ранее
      MainForm.FreeChildForms;
      Application.ProcessMessages;
      RunCompactDatabase;
      AProc.MessageBox( 'Сжатие базы данных завершено');
    end;
	end;
  if Assigned(GlobalExchangeParams) then
    try FreeAndNil(GlobalExchangeParams) except end;
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
      for I := 0 to TStringList(GlobalExchangeParams[Integer(epSendedOrders)]).Count-1 do
        DM.ShowOrderDetailsReport(
          StrToInt(TStringList(GlobalExchangeParams[Integer(epSendedOrders)])[i]),
          True,
          True,
          False,
          False);

  finally
    PrintDialog.Free;
  end;

end;

{ Восстанавливаем заказы после обновления }
procedure TryToRepareOrders;
var
  t : TInternalRepareOrders;
begin
  t := TInternalRepareOrders.Create;
  try
    t.RepareOrders;
  finally
    t.Free;
  end;
end;


//пауза после ошибки
function TExchangeForm.PauseAfterError : TModalResult;
begin
	RetryForm := TRetryForm.Create( Application);
	RetryForm.lblError.Caption := TStringValue(GlobalExchangeParams[Integer(epErrorMessage)]).Value;
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
		while not TBooleanValue(GlobalExchangeParams[Integer(epTerminated)]).Value do
		begin
			CheckSynchronize;
			Application.ProcessMessages;
			Sleep( 10);
		end;

		if TStringValue(GlobalExchangeParams[Integer(epErrorMessage)]).Value <> '' then
		begin
			if ( ConnectNumber < ConnectCount) and not TBooleanValue(GlobalExchangeParams[Integer(epCriticalError)]).Value then begin
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

  ErrMsg := TStringValue(GlobalExchangeParams[Integer(epErrorMessage)]).Value;

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
	StatusText := '';
	StatusPosition := 0;
	if DoStop then
	begin
		TBooleanValue(GlobalExchangeParams[Integer(epTerminated)]).Value := True;
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
	DoStop := True;
  if TBooleanValue(GlobalExchangeParams[Integer(epDownloadChildThreads)]).Value then
    ExThread.StopChildThreads
  else
    try
      TBooleanValue(GlobalExchangeParams[Integer(epCriticalError)]).Value := True;
      TStringValue(GlobalExchangeParams[Integer(epErrorMessage)]).Value := 'Операция отменена';
      HTTP.Disconnect;
      Ras.Disconnect;
    except
    end;
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

procedure TExchangeForm.HTTPStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  WriteExchangeLog('Exchange', 'IdStatus : ' + AStatusText);
end;

{ TInternalRepareOrders }

procedure TInternalRepareOrders.FillData;
var
	Order, CurOrder, Quantity, E: Integer;
	SynonymCode, SynonymFirmCrCode, JUNK, AWAIT: Variant;
  Code, RequestRatio, OrderCost, MinOrderCount: Variant;
  //Есть ли превышение по цене?
  CostReason : String;
  OldPrice : Currency;

	procedure SetOrder( Order: integer);
	begin
		DM.adsRepareOrders.Edit;
		DM.adsRepareOrdersORDERCOUNT.AsInteger := Order;
		if Order = 0 then
      DM.adsRepareOrdersCOREID.Clear
    else begin
      DM.adsRepareOrdersCOREID.Value := DM.adsCoreRepareCOREID.Value;
      DM.adsRepareOrdersCODE.Value := DM.adsCoreRepareCODE.Value;
      DM.adsRepareOrdersCODECR.Value := DM.adsCoreRepareCODECR.Value;
      DM.adsRepareOrdersPRICE.Value := DM.adsCoreRepareCOST.Value;
      DM.adsRepareOrdersCodeFirmCr.Value := DM.adsCoreRepareCodeFirmCr.Value;
    end;
		DM.adsRepareOrders.Post;
	end;

begin
	while not DM.adsRepareOrders.Eof do
	begin
    Application.ProcessMessages;
    if DM.adsCoreRepare.Active then
  		DM.adsCoreRepare.Close;
		Screen.Cursor := crHourglass;
		try
      //Получаем данные, восстанавливаемой позиции
			Order := DM.adsRepareOrdersORDERCOUNT.AsInteger;
      OldPrice := DM.adsRepareOrdersPrice.AsCurrency;
			CurOrder := 0;
      CostReason := '';

			Code := DM.adsRepareOrdersCODE.AsVariant;
      RequestRatio := DM.adsRepareOrdersREQUESTRATIO.AsVariant;
      OrderCost := DM.adsRepareOrdersORDERCOST.AsVariant;
      MinOrderCount := DM.adsRepareOrdersMINORDERCOUNT.AsVariant;

			SynonymCode := DM.adsRepareOrdersSYNONYMCODE.AsInteger;
			SynonymFirmCrCode := DM.adsRepareOrdersSYNONYMFIRMCRCODE.AsVariant;
      JUNK := DM.adsRepareOrdersJUNK.AsVariant;
      AWAIT := DM.adsRepareOrdersAWAIT.AsVariant;

      DM.adsCoreRepare.ParamByName( 'ClientId').Value :=
        DM.adtClients.FieldByName('ClientId').Value;
      DM.adsCoreRepare.ParamByName( 'PriceCode').Value :=
        DM.adsRepareOrders.FieldByName( 'PriceCode').Value;
      DM.adsCoreRepare.ParamByName( 'RegionCode').Value :=
        DM.adsRepareOrders.FieldByName( 'RegionCode').Value;
      DM.adsCoreRepare.ParamByName( 'SynonymCode').Value := SynonymCode;
      DM.adsCoreRepare.ParamByName( 'SYNONYMFIRMCRCODE').Value := SynonymFirmCrCode;
      DM.adsCoreRepare.ParamByName( 'JUNK').Value := JUNK;
      DM.adsCoreRepare.ParamByName( 'AWAIT').Value := AWAIT;
			DM.adsCoreRepare.Open;
			{ проверяем наличие прайс-листа }
			if DM.adsCoreRepare.IsEmpty then
			begin
{
      mdOutput.FieldDefs.Add('Reason', ftString, 500);
      mdOutput.FieldDefs.Add('OldOrderCount', ftInteger);
      mdOutput.FieldDefs.Add('NewOrderCount', ftInteger);
      mdOutput.FieldDefs.Add('OldPrice', ftCurrency);
      mdOutput.FieldDefs.Add('NewPrice', ftCurrency);
      mdOutput.FieldDefs.Add('OrderListId', ftLargeint);
      mdOutput.FieldDefs.Add('ProductId', ftLargeint);
      mdOutput.FieldDefs.Add('ClientId', ftLargeint);

}
        mdOutput.AppendRecord(
         [DM.adsRepareOrdersClientName.AsString,
         DM.adsRepareOrdersPRICENAME.AsString,
         DM.adsRepareOrdersSYNONYMNAME.AsString,
         DM.adsRepareOrdersSYNONYMFIRM.AsString,
         'предложение отсутствует',
         Order,
         Null,
         OldPrice,
         Null,
         DM.adsRepareOrdersId.AsLargeInt,
         DM.adsRepareOrdersProductId.AsLargeInt,
         DM.adsRepareOrdersClientId.AsLargeInt]);
				DM.adsCoreRepare.Close;
				SetOrder( 0);
				DM.adsRepareOrders.Next;
				continue;
			end;

			if DM.adsCoreRepare.Locate( 'Code;REQUESTRATIO;ORDERCOST;MINORDERCOUNT', VarArrayOf([Code, RequestRatio, OrderCost, MinOrderCount]), [])
      then
			begin
				Val( DM.adsCoreRepareQUANTITY.AsString, Quantity, E);
				if E <> 0 then Quantity := 0;
				if Quantity > 0 then
					CurOrder := Min( Order, Quantity)
				else
          CurOrder := Order;
        if not DM.adsCoreRepareREQUESTRATIO.IsNull and (DM.adsCoreRepareREQUESTRATIO.AsInteger > 0) then
          CurOrder := CurOrder - (CurOrder mod DM.adsCoreRepareREQUESTRATIO.AsInteger);
			end;
			SetOrder( CurOrder);

      if (CurOrder > 0) then
        if OldPrice < DM.adsRepareOrdersPrice.AsCurrency then
          CostReason := 'старая цена заказа меньше текущей цены'
        else
          if OldPrice > DM.adsRepareOrdersPrice.AsCurrency then
            CostReason := 'старая цена заказа больше текущей цены';

			{ Если все еще не разбросали, то пишем сообщение }
			if ( Order - CurOrder) > 0 then
			begin
				if CurOrder > 0 then
				begin
          mdOutput.AppendRecord(
           [DM.adsRepareOrdersClientName.AsString,
           DM.adsRepareOrdersPRICENAME.AsString,
           DM.adsRepareOrdersSYNONYMNAME.AsString,
           DM.adsRepareOrdersSYNONYMFIRM.AsString,
           IfThen(Length(CostReason) > 0, CostReason + '; ') +
             'доступное количество препарата в прайс-листе меньше заказанного ранее',
           Order,
           CurOrder,
           OldPrice,
           DM.adsRepareOrdersPrice.AsCurrency,
           DM.adsRepareOrdersId.AsLargeInt,
           DM.adsRepareOrdersProductId.AsLargeInt,
           DM.adsRepareOrdersClientId.AsLargeInt]);
				end
				else
				begin
          mdOutput.AppendRecord(
           [DM.adsRepareOrdersClientName.AsString,
           DM.adsRepareOrdersPRICENAME.AsString,
           DM.adsRepareOrdersSYNONYMNAME.AsString,
           DM.adsRepareOrdersSYNONYMFIRM.AsString,
           'предложение отсутствует',
           Order,
           Null,
           OldPrice,
           Null,
           DM.adsRepareOrdersId.AsLargeInt,
           DM.adsRepareOrdersProductId.AsLargeInt,
           DM.adsRepareOrdersClientId.AsLargeInt]);
				end;
			end
      else
        if Length(CostReason) > 0 then
          mdOutput.AppendRecord(
           [DM.adsRepareOrdersClientName.AsString,
           DM.adsRepareOrdersPRICENAME.AsString,
           DM.adsRepareOrdersSYNONYMNAME.AsString,
           DM.adsRepareOrdersSYNONYMFIRM.AsString,
           CostReason,
           Order,
           CurOrder,
           OldPrice,
           DM.adsRepareOrdersPrice.AsCurrency,
           DM.adsRepareOrdersId.AsLargeInt,
           DM.adsRepareOrdersProductId.AsLargeInt,
           DM.adsRepareOrdersClientId.AsLargeInt]);

			DM.adsRepareOrders.Next;
		finally
			DM.adsCoreRepare.Close;
      Screen.Cursor := crDefault;
		end;
	end;
end;

procedure TInternalRepareOrders.FormatOutput;
var
  ClientName, PriceName : String;
begin
  mdOutput.SortOnFields('ClientName;PriceName;SynonymName;SynonymFirm');
  mdOutput.First;
  if mdOutput.RecordCount > 0 then begin
    ClientName := mdOutput.FieldByName('ClientName').AsString;
    PriceName := mdOutput.FieldByName('PriceName').AsString;
    Strings.Append(Format('клиент %s', [ClientName]));
    Strings.Append(Format('   прайс-лист %s', [PriceName]));
    while not mdOutput.Eof do begin
      if     (ClientName = mdOutput.FieldByName('ClientName').AsString)
         and (PriceName  <> mdOutput.FieldByName('PriceName').AsString)
      then begin
        PriceName := mdOutput.FieldByName('PriceName').AsString;
        Strings.Append('');
        Strings.Append(Format('   прайс-лист %s', [PriceName]));
      end
      else
        if     (ClientName <> mdOutput.FieldByName('ClientName').AsString)
           and (PriceName  <> mdOutput.FieldByName('PriceName').AsString)
        then begin
          ClientName := mdOutput.FieldByName('ClientName').AsString;
          PriceName := mdOutput.FieldByName('PriceName').AsString;
          Strings.Append('');
          Strings.Append('');
          Strings.Append(Format('клиент %s', [ClientName]));
          Strings.Append(Format('   прайс-лист %s', [PriceName]));
        end;

{
      mdOutput.FieldDefs.Add('OldOrderCount', ftInteger);
      mdOutput.FieldDefs.Add('NewOrderCount', ftInteger);
      mdOutput.FieldDefs.Add('OldPrice', ftCurrency);
      mdOutput.FieldDefs.Add('NewPrice', ftCurrency);
}
      Strings.Append( Format( '      %s - %s : %s (старая цена: %s; старый заказ: %s; новая цена: %s; текущий заказ: %s)',
        [mdOutput.FieldByName('SynonymName').AsString,
         mdOutput.FieldByName('SynonymFirm').AsString,
         mdOutput.FieldByName('Reason').AsString,
         mdOutput.FieldByName('OldPrice').AsString,
         mdOutput.FieldByName('OldOrderCount').AsString,
         mdOutput.FieldByName('NewPrice').AsString,
         mdOutput.FieldByName('NewOrderCount').AsString]));
      mdOutput.Next;
    end;
  end;
end;

procedure TInternalRepareOrders.InternalRepareOrders;
begin
  FillData;
  FormatOutput;
end;

procedure TInternalRepareOrders.RepareOrders;
begin
  DM.adsRepareOrders.Close;
  DM.adsRepareOrders.Open;

	if DM.adsRepareOrders.IsEmpty then
	begin
	 	DM.adsRepareOrders.Close;
		exit;
	end;

	Strings := TStringList.Create;

	try

    mdOutput := TRxMemoryData.Create(nil);
    try

      mdOutput.FieldDefs.Add('ClientName', ftString, 500);
      mdOutput.FieldDefs.Add('PriceName', ftString, 500);
      mdOutput.FieldDefs.Add('SynonymName', ftString, 500);
      mdOutput.FieldDefs.Add('SynonymFirm', ftString, 500);
      mdOutput.FieldDefs.Add('Reason', ftString, 500);
      mdOutput.FieldDefs.Add('OldOrderCount', ftInteger);
      mdOutput.FieldDefs.Add('NewOrderCount', ftInteger);
      mdOutput.FieldDefs.Add('OldPrice', ftCurrency);
      mdOutput.FieldDefs.Add('NewPrice', ftCurrency);
      mdOutput.FieldDefs.Add('OrderListId', ftLargeint);
      mdOutput.FieldDefs.Add('ProductId', ftLargeint);
      mdOutput.FieldDefs.Add('ClientId', ftLargeint);

      mdOutput.Open;
      try
        ShowSQLWaiting(InternalRepareOrders, 'Происходит пересчет заказов');

        { если не нашли что-то, то выводим сообщение }
        if (Strings.Count > 0) and (Length(Strings.Text) > 0) then
        begin
          if (ShowCorrectOrders(mdOutput) = mrYes) then
            ShowNotFound( Strings);
        end;
      finally
        mdOutput.Close;
      end;

    finally
      mdOutput.Free;
    end;

	finally
		Strings.Free;
		DM.adsRepareOrders.Close;
  end;
end;

initialization
  ExThread := nil;
  GlobalExchangeParams := nil;
finalization
end.
