unit Exchange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ARas, StrUtils, ComObj,
  Variants, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExchangeThread, CheckLst, DateUtils,
  ActnList, Math, IdAuthentication, IdAntiFreezeBase, IdAntiFreeze, WinSock,
  IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, FIBDataSet;

type
  TExchangeAction=( eaGetPrice, eaSendOrders, eaImportOnly, eaGetFullData, eaMDBUpdate, eaGetWaybills, eaSendLetter);

  TExchangeActions=set of TExchangeAction;

  TExchangeForm = class(TForm)
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
    gbReclame: TGroupBox;
    ReclameBar: TProgressBar;
    lReclameStatus: TLabel;
    sslMain: TIdSSLIOHandlerSocket;
    sslReclame: TIdSSLIOHandlerSocket;
    httpReceive: TIdHTTP;
    sslReceive: TIdSSLIOHandlerSocket;
    procedure RasStateChange(Sender: TObject; State: Integer;
      StateStr: String);
    procedure TimerTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HTTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
  private
    FStatusPosition: Integer;
	  ExchangeActions: TExchangeActions;
	  StartTime: TTime;
	  ConnectCount: integer;
	  ConnectPause: cardinal;

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
    QueryResults: TStrings;

    //Текст ошибки, которая произошла
  	ErrMsg: string;
    //Отображает лог неотправленных заказов
    SendOrdersLog : TStringList;

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
	HostFileName, LocalFileName: string;
	ServerAddition: string;

procedure TryToRepareOrders;
function RunExchange(AExchangeActions: TExchangeActions=[eaGetPrice]): Boolean;

implementation

uses Main, AProc, DModule, Retry, NotFound, Constant, Compact, NotOrders,
  Exclusive, CompactThread, DB, SQLWaiting, U_ExchangeLog;

{$R *.DFM}
type
  TInternalRepareOrders = class
   public
    Strings : TStrings;
    procedure RepareOrders;
    procedure InternalRepareOrders;
  end;



function RunExchange( AExchangeActions: TExchangeActions=[eaGetPrice]): Boolean;
var
	mr: integer;
  SendOrdersLog   : String;
//	hMenuHandle: HMENU;
begin
	MainForm.FreeChildForms;
	Result := False;
	ServerAddition := '';
  SendOrdersLog := '';
	if AExchangeActions = [] then exit;
	DM.DeleteEmptyOrders;

	if DM.GetCumulative and ([eaImportOnly] <> AExchangeActions) then
    AExchangeActions := AExchangeActions + [ eaGetFullData, eaSendOrders];

  //TODO: ___ надо подумать, что здесь происходит
	if ( eaSendOrders in AExchangeActions)
    and not ( [eaGetPrice, eaGetWaybills] * AExchangeActions <> [])
    and ( DM.DatabaseOpenedBy <> '')
  then
		if not ShowExclusive then
		begin
			DM.ResetExclusive;
			MainForm.Timer.Enabled := True;
			exit;
		end;

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
      DM.ResetReclame;
			ExchangeForm.Timer.Enabled := True;
			Result := ExchangeForm.ShowModal = mrOk;
      if not Result then
        AProc.MessageBox(ExchangeForm.ErrMsg, MB_ICONERROR);
      SendOrdersLog := ExchangeForm.SendOrdersLog.Text;
			DM.MainConnection1.Close;
      Sleep(500);
			DM.MainConnection1.Open;
      DM.UpdateReclame;
		except
			on E: Exception do
        AProc.MessageBox(Copy(E.Message, 1, 1024), MB_ICONSTOP);
		end;
    WriteExchangeLog('Exchange', 'Сессия окончена');
    WriteExchangeLog('Exchange', '---------------------------');
  finally
		ExchangeForm.Free;
	end;

	DM.ResetExclusive;
	MainForm.Timer.Enabled := True;

	if Result then DM.ResetCumulative;

	if (( eaGetPrice in AExchangeActions) or
		( eaImportOnly in AExchangeActions)) and Result then TryToRepareOrders;

	if MainForm.ExchangeOnly then exit;

	if Result and ( Trim( ServerAddition) <> '')
  then
    AProc.MessageBoxEx(
			PChar( ServerAddition), 'Сообщение от АК "Инфорум"',
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
    if (Length(SendOrdersLog) = 0)
    then
      AProc.MessageBox('Отправка заказов завершена успешно.', MB_OK or MB_ICONINFORMATION)
    else
      AProc.MessageBox('Отправка заказов завершена с ошибками.', MB_OK or MB_ICONWARNING);

	if Result and ( AExchangeActions = [ eaSendOrders]) and (Length(SendOrdersLog) > 0)
  then
    if AProc.MessageBox(
        'Во время отправки заказов возникли ошибки. ' +
            'Желаете посмотреть журнал ошибок?',
        MB_ICONWARNING or MB_YESNO) = IDYES
    then
      ShowNotSended(SendOrdersLog);

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
      MainForm.FreeChildForms;
      Application.ProcessMessages;
      RunCompactDatabase;
      AProc.MessageBox( 'Сжатие базы данных завершено');
    end;
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
	RetryForm.lblError.Caption := ExThread.ErrorMessage;
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

	ConnectCount := DM.adtParams.FieldByName( 'ConnectCount').AsInteger;
	ConnectPause := DM.adtParams.FieldByName( 'ConnectPause').AsInteger;
	Caption := 'Обмен данными';

	QueryResults := TStringList.Create;
	//главный цикл соединения
	for ConnectNumber := 1 to ConnectCount do
	begin
		ExThread := TExchangeThread.Create( False);
		while not ExThread.Terminated do
		begin
			CheckSynchronize;
			Application.ProcessMessages;
			Sleep( 10);
		end;

		if ExThread.ErrorMessage <> '' then
		begin
			if ( ConnectNumber < ConnectCount) and not ExThread.CriticalError then begin
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
	QueryResults.Free;

	//очищаем папку In
//	DeleteFilesByMask( ExePath + SDirIn + '\*.*');

        ErrMsg := ExThread.ErrorMessage;

	{ Требуется завершение программы }
	if Assigned( ExThread) and ( ErrMsg = 'Terminate') then
	begin
		DM.MainConnection1.Close;
		Application.Terminate;
	end;

	{ Отмена действия }
	if Assigned( ExThread) and ( ErrMsg = 'Cancel') then
	begin
		ModalResult := mrCancel;
		exit;
	end;

	if Assigned( ExThread) and ( ErrMsg <> '') then
	begin
		ModalResult := mrAbort;
		ExThread.Free;
//		raise Exception.Create( ErrMsg);
	end
	else
	begin
		ModalResult := mrOk;
		if Assigned( ExThread) then ExThread.Free;
	end;
end;


procedure TExchangeForm.CheckStop;
begin
	StatusText := '';
	StatusPosition := 0;
	if DoStop then
	begin
		ExThread.Terminated := True;
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
  if ExThread.DownloadChildThreads then
    ExThread.StopChildThreads
  else
    try
      ExThread.CriticalError := True;
      ExThread.ErrorMessage := 'Операция отменена';
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
  SendOrdersLog := TStringList.Create;
  HTTP.ConnectTimeout := -2;
  HTTPReclame.ConnectTimeout := -2;
  httpReceive.ConnectTimeout := -2;
end;

procedure TExchangeForm.FormDestroy(Sender: TObject);
begin
  SendOrdersLog.Free;
end;

procedure TExchangeForm.HTTPStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  WriteExchangeLog('Exchange', 'IdStatus : ' + AStatusText);
end;

{ TInternalRepareOrders }

procedure TInternalRepareOrders.InternalRepareOrders;
var
	Order, CurOrder, Quantity, E: Integer;
	SynonymCode, SynonymFirmCrCode, JUNK, AWAIT: Variant;
  Code, VitallyImportant, RequestRatio, OrderCost, MinOrderCount : Variant;

	procedure SetOrder( Order: integer);
	begin
		DM.adsRepareOrders.Edit;
		DM.adsRepareOrdersORDERCOUNT.AsInteger := Order;
		if Order = 0 then
      DM.adsRepareOrdersCOREID.Clear
    else begin
      DM.adsRepareOrdersCOREID.AsInt64 := DM.adsCoreCOREID.Value;
      DM.adsRepareOrdersCODE.Value := DM.adsCoreCODE.Value;
      DM.adsRepareOrdersCODECR.Value := DM.adsCoreCODECR.Value;
      DM.adsRepareOrdersPRICE.AsString := DM.adsCoreBASECOST.Value;
    end;
		DM.adsRepareOrders.Post;
	end;

begin
	while not DM.adsRepareOrders.Eof do
	begin
    Application.ProcessMessages;
    if DM.adsCore.Active then
  		DM.adsCore.Close;
		Screen.Cursor := crHourglass;
		try
      //Получаем данные, восстанавливаемой позиции
			Order := DM.adsRepareOrdersORDERCOUNT.AsInteger;
			CurOrder := 0;

			Code := DM.adsRepareOrdersCODE.AsVariant;
      VitallyImportant := DM.adsRepareOrdersVITALLYIMPORTANT.AsVariant;
      RequestRatio := DM.adsRepareOrdersREQUESTRATIO.AsVariant;
      OrderCost := DM.adsRepareOrdersORDERCOST.AsVariant;
      MinOrderCount := DM.adsRepareOrdersMINORDERCOUNT.AsVariant;

			SynonymCode := DM.adsRepareOrdersSYNONYMCODE.AsInteger;
			SynonymFirmCrCode := DM.adsRepareOrdersSYNONYMFIRMCRCODE.AsInteger;
      JUNK := DM.adsRepareOrdersJUNK.AsInteger;
      AWAIT := DM.adsRepareOrdersAWAIT.AsInteger;

      DM.adsCore.ParamByName( 'AClientId').Value :=
        DM.adtClients.FieldByName('ClientId').Value;
      DM.adsCore.ParamByName( 'APriceCode').Value :=
        DM.adsRepareOrders.FieldByName( 'PriceCode').Value;
      DM.adsCore.ParamByName( 'ARegionCode').Value :=
        DM.adsRepareOrders.FieldByName( 'RegionCode').Value;
      DM.adsCore.ParamByName( 'SynonymCode').Value := SynonymCode;
      DM.adsCore.ParamByName( 'SYNONYMFIRMCRCODE').Value := SynonymFirmCrCode;
      DM.adsCore.ParamByName( 'JUNK').Value := JUNK;
      DM.adsCore.ParamByName( 'AWAIT').Value := AWAIT;
			DM.adsCore.Open;
			{ проверяем наличие прайс-листа }
			if DM.adsCore.IsEmpty then
			begin
				Strings.Append( Format( '%s : %s - %s : позиция отсутствует',
					[ DM.adsRepareOrdersPRICENAME.AsString,
					DM.adsRepareOrdersSYNONYMNAME.AsString,
					DM.adsRepareOrdersSYNONYMFIRM.AsString]));
				DM.adsCore.Close;
				SetOrder( 0);
				DM.adsRepareOrders.Next;
				continue;
			end;

			if DM.adsCore.Locate( 'Code;VITALLYIMPORTANT;REQUESTRATIO;ORDERCOST;MINORDERCOUNT', VarArrayOf([Code, VitallyImportant, RequestRatio, OrderCost, MinOrderCount]), [])
      then
			begin
				Val( DM.adsCoreQUANTITY.AsString, Quantity, E);
				if E <> 0 then Quantity := 0;
				if Quantity > 0 then
					CurOrder := Min( Order, Quantity)
				else
          CurOrder := Order;
        if not DM.adsCoreREQUESTRATIO.IsNull and (DM.adsCoreREQUESTRATIO.AsInteger > 0) then
          CurOrder := CurOrder - (CurOrder mod DM.adsCoreREQUESTRATIO.AsInteger);
			end;
			SetOrder( CurOrder);

			{ Если все еще не разбросали, то пишем сообщение }
			if ( Order - CurOrder) > 0 then
			begin
				if CurOrder > 0 then
				begin
					Strings.Append( Format( '%s : %s - %s : %d вместо %d (старая цена : %s)',
						[ DM.adsRepareOrdersPRICENAME.AsString,
						DM.adsRepareOrdersSYNONYMNAME.AsString,
						DM.adsRepareOrdersSYNONYMFIRM.AsString,
						CurOrder,
						Order,
						DM.adsRepareOrdersCryptPRICE.AsString]));
				end
				else
				begin
					Strings.Append( Format( '%s : %s - %s : предложение отсутствует (старая цена : %s)',
						[ DM.adsRepareOrdersPRICENAME.AsString,
						DM.adsRepareOrdersSYNONYMNAME.AsString,
						DM.adsRepareOrdersSYNONYMFIRM.AsString,
						DM.adsRepareOrdersCryptPRICE.AsString]));
				end;
			end;
			DM.adsRepareOrders.Next;
		finally
			DM.adsCore.Close;
      Screen.Cursor := crDefault;
		end;
	end;
end;

procedure TInternalRepareOrders.RepareOrders;
begin
 	DM.adsRepareOrders.CloseOpen(False);

	if DM.adsRepareOrders.IsEmpty then
	begin
	 	DM.adsRepareOrders.Close;
		exit;
	end;

	Strings := TStringList.Create;

	try

    ShowSQLWaiting(InternalRepareOrders, 'Происходит пересчет заказов');

  	{ если не нашли что-то, то выводим сообщение }
	  if (Strings.Count > 0) and (Length(Strings.Text) > 0) then ShowNotFound( Strings);

	finally
		Strings.Free;
		DM.adsRepareOrders.Close;
  end;
end;

end.
