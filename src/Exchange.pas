unit Exchange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ARas, StrUtils, ComObj,
  VCLUnZip, Variants, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExchangeThread, CheckLst, DateUtils,
  ActnList, Math, IdAuthentication, IdAntiFreezeBase, IdAntiFreeze, WinSock,
  IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, FIBDataSet;

type
  TExchangeAction=( eaGetPrice, eaSendOrders, eaImportOnly, eaGetFullData, eaMDBUpdate);

  TExchangeActions=set of TExchangeAction;

  TExchangeForm = class(TForm)
    btnCancel: TButton;
    Timer: TTimer;
    ProgressBar: TProgressBar;
    Ras: TARas;
    UnZip: TVCLUnZip;
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
    procedure RasStateChange(Sender: TObject; State: Integer;
      StateStr: String);
    procedure TimerTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure UnZipBadCRC(Sender: TObject; CalcCRC, StoredCRC,
      FileIndex: Integer);
    procedure UnZipInCompleteZip(Sender: TObject;
      var IncompleteMode: TIncompleteZipMode);
    procedure UnZipTotalPercentDone(Sender: TObject; Percent: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HTTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure HTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
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
    LogFile: TextFile;
    DoStop: Boolean;
    QueryResults: TStrings;

    //Текст ошибки, которая произошла
  	ErrMsg: string;
    //Переменные для работы внешних заказов
    ExternalOrdersCount : Integer;
    ExternalOrdersLog : TStringList;
    SendOrdersLog : TStringList;

    //Показывать ли статусный текст о состоянии скаченного файла
    ShowStatusText : Boolean;

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
  Exclusive, CompactThread, ShowLog, ExternalOrders, DB;

{$R *.DFM}

function RunExchange( AExchangeActions: TExchangeActions=[eaGetPrice]): Boolean;
var
	mr: integer;
  ExternalOrdersCount,
  ExternalOrdersErrorCount : Integer;
  ExternalOrdersLog   : String;
  SendOrdersLog   : String;
//	hMenuHandle: HMENU;
begin
	MainForm.FreeChildForms;
	Result := False;
	ServerAddition := '';
  ExternalOrdersCount := 0;
  ExternalOrdersErrorCount := 0;
  ExternalOrdersLog := '';
  SendOrdersLog := '';
	if AExchangeActions = [] then exit;
	DM.DeleteEmptyOrders;

  //Очистили директорию перед отправкой заказов
  if IsExternalOrdersDLLPresent then
    ExternalOrdersClearTempDirectory;

	if DM.GetCumulative then AExchangeActions := AExchangeActions + [ eaGetFullData, eaSendOrders]
		else if eaGetFullData in AExchangeActions then {DM.SetCumulative};

	if ( eaSendOrders in AExchangeActions) and
		not ( eaGetPrice in AExchangeActions) and ( DM.DatabaseOpenedBy <> '') then
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
		Windows.MessageBox( Application.Handle,
			'Предыдущая операция импорта данных не была завершена.' + #10#13 +
			'Обратитесь в АК "Инфорум"', 'Внимание', MB_OK or MB_ICONWARNING);
		exit;
	end;

  if (eaGetFullData in AExchangeActions) then
    DM.ResetNeedCommitExchange;

	//выводим форму и начинаем обмен данными
	ExchangeForm := TExchangeForm.Create( Application);
//	hMenuHandle := GetSystemMenu( ExchangeForm.Handle, False);
//	DeleteMenu( hMenuHandle, SC_CLOSE, MF_BYCOMMAND);

	if not MainForm.Showing then ExchangeForm.Position := poDesktopCenter;
	try
		if AExchangeActions <> [ eaImportOnly] then
		begin
			ExchangeForm.SetRasParams;
			ExchangeForm.SetHTTPParams;
		end;
		ExchangeForm.ExchangeActions := AExchangeActions;
		AssignFile( ExchangeForm.LogFile, ExePath + 'Exchange.log');
    if FileExists(ExePath + 'Exchange.log') then
  		Append( ExchangeForm.LogFile) //будем добавлять лог-файл
    else
  		Rewrite( ExchangeForm.LogFile); //создаем лог-файл
    WriteLn(ExchangeForm.LogFile);
    WriteLn(ExchangeForm.LogFile);
    WriteLn(ExchangeForm.LogFile);
    WriteLn(ExchangeForm.LogFile, '---------------------------');
    WriteLn(ExchangeForm.LogFile, 'Сессия начата в ' + DateTimeToStr(Now));
		try
      DM.ResetReclame;
			ExchangeForm.Timer.Enabled := True;
			Result := ExchangeForm.ShowModal = mrOk;
      if not Result then
        AProc.MessageBox(ExchangeForm.ErrMsg, MB_ICONERROR);
      ExternalOrdersCount := ExchangeForm.ExternalOrdersCount;
      ExternalOrdersErrorCount := ExchangeForm.ExternalOrdersLog.Count;
      ExternalOrdersLog := ExchangeForm.ExternalOrdersLog.Text;
      SendOrdersLog := ExchangeForm.SendOrdersLog.Text;
			DM.MainConnection1.Close;
      Sleep(500);
			DM.MainConnection1.Open;
      DM.UpdateReclame;
		except
			on E: Exception do ShowMessage( E.Message);
		end;
    WriteLn(ExchangeForm.LogFile, 'Сессия окончена в ' + DateTimeToStr(Now));
    WriteLn(ExchangeForm.LogFile, '---------------------------');
		CloseFile( ExchangeForm.LogFile);
  finally
		ExchangeForm.Free;
	end;

	DM.ResetExclusive;
	MainForm.Timer.Enabled := True;

	if Result then DM.ResetCumulative;

	if (( eaGetPrice in AExchangeActions) or
		( eaImportOnly in AExchangeActions)) and Result then TryToRepareOrders;

	if MainForm.ExchangeOnly then exit;

	if Result and ( Trim( ServerAddition) <> '') then Windows.MessageBox( Application.Handle,
			PChar( ServerAddition), 'Сообщение от АК "Инфорум"',
			MB_OK or MB_ICONINFORMATION);

	if Result and (( eaGetPrice in AExchangeActions) or
		( eaImportOnly in AExchangeActions)) then Windows.MessageBox( Application.Handle,
			'Обновление завершено успешно.', 'Информация',
			MB_OK or MB_ICONINFORMATION);

	if Result and ( AExchangeActions = [ eaSendOrders]) then Windows.MessageBox( Application.Handle,
			'Отправка заказов завершена успешно.', 'Информация',
			MB_OK or MB_ICONINFORMATION);

	if Result and ( AExchangeActions = [ eaSendOrders]) and (Length(SendOrdersLog) > 0)
  then
    if MessageBox(
        'Во время отправки заказов возникли ошибки. ' +
            'Желаете посмотреть журнал ошибок?',
        MB_ICONWARNING or MB_YESNO) = IDYES
    then
      ShowNotSended(SendOrdersLog);

	if Result and ( AExchangeActions = [ eaSendOrders]) and (ExternalOrdersCount > 0)
     and (Length(ExternalOrdersLog) > 0)
  then
    if MessageBox(
        'Во время формирования внешних заказов для "Протек" возникли ошибки. ' +
            'Желаете посмотреть журнал ошибок?',
        MB_ICONWARNING or MB_YESNO) = IDYES
    then
      RunShowLog(ExternalOrdersLog);

	if Result and ( AExchangeActions = [ eaSendOrders]) and (ExternalOrdersCount > 0)
    and (ExternalOrdersCount > ExternalOrdersErrorCount) and IsExternalOrdersDLLPresent
  then begin
    if MessageBox(
        'Заказы для "Протек" сформированы. ' +
            'Запустить программу для их отправки сейчас?',
        MB_ICONINFORMATION or MB_YESNO) = IDYES
    then begin
      RunExternalOrders
    end;
  end;

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
//      DM.CompactDatabase;
      MainForm.FreeChildForms;
      Application.ProcessMessages;
      RunCompactDatabase;
    end;
		MessageBox( 'Сжатие базы данных завершено');
	end;
end;

{ Восстанавливаем заказы после обновления }
procedure TryToRepareOrders;
var
	Order, CurOrder, Quantity, E: Integer;
	SynonymCode, SynonymFirmCrCode, JUNK, AWAIT: Variant;
  Code, CodeCr : String;
	Strings: TStrings;
//  FilterStr : String;
//  LocateRes : Boolean;

	procedure SetOrder( Order: integer);
	begin
		DM.adsSelect3.Edit;
		DM.adsSelect3ORDERCOUNT.AsInteger := Order;
		if Order = 0 then
      DM.adsSelect3COREID.Clear
    else begin
      DM.adsSelect3COREID.AsInt64 := DM.adsCoreCOREID.Value;
      DM.adsSelect3CODE.Value := DM.adsCoreCODE.Value;
      DM.adsSelect3CODECR.Value := DM.adsCoreCODECR.Value;
      DM.adsSelect3PRICE.AsString := DM.adsCoreBASECOST.Value;
    end;
		DM.adsSelect3.Post;
	end;

begin
// 	DM.adsSelect3.Close;
{
 	DM.adsSelect3.SelectSQL.Text := 'SELECT Id, CoreId, PriceCode, RegionCode, Code, CodeCr, ' +
		'Price, SynonymCode, SynonymFirmCrCode, SynonymName, SynonymFirm, Junk, Await, OrderCount, PriceName ' +
		'FROM Orders ' +
		'INNER JOIN OrdersH ON (OrdersH.OrderId=Orders.OrderId AND OrdersH.Closed = 0) ' +
		'WHERE (OrderCount>0)';
}    
 	DM.adsSelect3.CloseOpen(True);
	if DM.adsSelect3.IsEmpty then
	begin
	 	DM.adsSelect3.Close;
		exit;
	end;

	Strings := TStringList.Create;

	try

	while not DM.adsSelect3.Eof do
	begin
		DM.adsCore.Close;
		DM.adsCore.ParamByName( 'AClientId').Value :=
			DM.adtClients.FieldByName('ClientId').Value;
		DM.adsCore.ParamByName( 'APriceCode').Value :=
			DM.adsSelect3.FieldByName( 'PriceCode').Value;
		DM.adsCore.ParamByName( 'ARegionCode').Value :=
			DM.adsSelect3.FieldByName( 'RegionCode').Value;
		DM.adsCore.ParamByName( 'APRICENAME').Value :=
			DM.adsSelect3.FieldByName( 'PriceName').Value;
		Screen.Cursor := crHourglass;
		try
			DM.adsCore.Open;
			{ проверяем наличие прайс-листа }
			if DM.adsCore.IsEmpty then
			begin
				Strings.Append( Format( '%s : %s - %s : прайс-лист отсутствует',
					[ DM.adsSelect3PRICENAME.AsString,
					DM.adsSelect3CryptSYNONYMNAME.AsString,
					DM.adsSelect3CryptSYNONYMFIRM.AsString]));
				DM.adsCore.Close;
				SetOrder( 0);
				DM.adsSelect3.Next;
				continue;
			end;
			Order := DM.adsSelect3ORDERCOUNT.AsInteger;
			CurOrder := 0;
			Code := DM.adsSelect3CODE.Value;
      Code := Copy(Code, 1, Length(Code)-16);
      //if Code = '' then Code := Null;
			CodeCr := DM.adsSelect3CODECR.Value;
      CodeCr := Copy(CodeCr, 1, Length(CodeCr)-16);
      //if CodeCr = '' then CodeCr := Null;
			SynonymCode := DM.adsSelect3SYNONYMCODE.AsInteger;
			SynonymFirmCrCode := DM.adsSelect3SYNONYMFIRMCRCODE.AsInteger;
      JUNK := DM.adsSelect3JUNK.AsInteger;
      AWAIT := DM.adsSelect3AWAIT.AsInteger;

			if DM.adsCore.ExtLocate( 'SynonymCode;SynonymFirmCrCode;Junk;Await;Code;CodeCr',
				  VarArrayOf([ SynonymCode, SynonymFirmCrCode, JUNK, AWAIT, Code, CodeCr]), [eloPartialKey])
      then
			begin
				Val( DM.adsCoreQUANTITY.AsString, Quantity, E);
				if E <> 0 then Quantity := 0;
				if Quantity > 0 then
					CurOrder := Min( Order, Quantity)
				else CurOrder := Order;
			end;
			SetOrder( CurOrder);

			{ Если все еще не разбросали, то пишем сообщение }
			if ( Order - CurOrder) > 0 then
			begin
				if CurOrder > 0 then
				begin
					Strings.Append( Format( '%s : %s - %s : %d вместо %d (старая цена : %s)',
						[ DM.adsSelect3PRICENAME.AsString,
						DM.adsSelect3CryptSYNONYMNAME.AsString,
						DM.adsSelect3CryptSYNONYMFIRM.AsString,
						CurOrder,
						Order,
						DM.adsSelect3CryptPRICE.AsString]));
				end
				else
				begin
					Strings.Append( Format( '%s : %s - %s : предложение отсутствует (старая цена : %s)',
						[ DM.adsSelect3PRICENAME.AsString,
						DM.adsSelect3CryptSYNONYMNAME.AsString,
						DM.adsSelect3CryptSYNONYMFIRM.AsString,
						DM.adsSelect3CryptPRICE.AsString]));
				end;
			end;
			DM.adsSelect3.Next;
		finally
			DM.adsCore.Close;
      Screen.Cursor := crDefault;
		end;
	end;

	{ если не нашли что-то, то выводим сообщение }
	if (Strings.Count > 0) and (Length(Strings.Text) > 0) then ShowNotFound( Strings);

	finally
		Strings.Free;
		DM.adsSelect3.Close;
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
  ShowStatusText := False;
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
  if ExThread.DownloadReclame then
    ExThread.StopReclame
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
	// выставляем параметры HTTP-клиента
	if DM.adtParams.FieldByName( 'ProxyConnect').AsBoolean then
        begin
		HTTP.ProxyParams.ProxyServer := DM.adtParams.FieldByName( 'ProxyName').AsString;
		HTTP.ProxyParams.ProxyPort := DM.adtParams.FieldByName( 'ProxyPort').AsInteger;
		HTTP.ProxyParams.ProxyUsername := DM.adtParams.FieldByName( 'ProxyUser').AsString;
		HTTP.ProxyParams.ProxyPassword := DM.adtParams.FieldByName( 'ProxyPass').AsString;
    HTTP.Request.ProxyConnection := 'keep-alive';
		HTTPReclame.ProxyParams.ProxyServer := DM.adtParams.FieldByName( 'ProxyName').AsString;
		HTTPReclame.ProxyParams.ProxyPort := DM.adtParams.FieldByName( 'ProxyPort').AsInteger;
		HTTPReclame.ProxyParams.ProxyUsername := DM.adtParams.FieldByName( 'ProxyUser').AsString;
		HTTPReclame.ProxyParams.ProxyPassword := DM.adtParams.FieldByName( 'ProxyPass').AsString;
    HTTPReclame.Request.ProxyConnection := 'keep-alive';
	end
	else
	begin
		HTTP.ProxyParams.ProxyServer := '';
		HTTP.ProxyParams.ProxyPort := 0;
		HTTP.ProxyParams.ProxyUsername := '';
		HTTP.ProxyParams.ProxyPassword := '';
    HTTP.Request.ProxyConnection := '';
		HTTPReclame.ProxyParams.ProxyServer := '';
		HTTPReclame.ProxyParams.ProxyPort := 0;
		HTTPReclame.ProxyParams.ProxyUsername := '';
		HTTPReclame.ProxyParams.ProxyPassword := '';
    HTTPReclame.Request.ProxyConnection := '';
	end;
	HTTP.Request.Username := DM.adtParams.FieldByName( 'HTTPName').AsString;
	HTTP.Request.Password := DM.adtParams.FieldByName( 'HTTPPass').AsString;
	HTTP.Port := DM.adtParams.FieldByName( 'HTTPPort').AsInteger;
	HTTPReclame.Request.Username := DM.adtParams.FieldByName( 'HTTPName').AsString;
	HTTPReclame.Request.Password := DM.adtParams.FieldByName( 'HTTPPass').AsString;
	HTTPReclame.Port := DM.adtParams.FieldByName( 'HTTPPort').AsInteger;
	HTTP.Host := ExtractURL( DM.adtParams.FieldByName( 'HTTPHost').AsString);
	if not DM.adtReclame.IsEmpty then HTTPReclame.Host :=
		ExtractURL( DM.adtReclame.FieldByName( 'ReclameURL').AsString);
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
	if Value <> '' then Writeln( LogFile, Value);
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

procedure TExchangeForm.HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
	const AWorkCount: Integer);
var
	Total, Current: real;
	TSuffix, CSuffix: string;
begin
	if HTTP.Response.ContentLength = 0 then StatusPosition := 0
	else
	begin
		StatusPosition := Round(( HTTP.Response.ContentRangeStart+Cardinal(AWorkCount))/
			( HTTP.Response.ContentRangeStart+Cardinal(HTTP.Response.ContentLength))*100);

		TSuffix := 'Кб';
		CSuffix := 'Кб';

		Total := RoundTo(( HTTP.Response.ContentRangeStart +
			Cardinal( HTTP.Response.ContentLength)) / 1024, -2);
		Current := RoundTo((HTTP.Response.ContentRangeStart +
			Cardinal( AWorkCount)) / 1024, -2);

		if Total <> Current then
		begin
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

			if FStatusPosition > 0 then
      begin
//        ShowStatusText := True;
//        stStatus.Caption := 'Загрузка данных   (' +
        FStatusStr := 'Загрузка данных   (' +
				FloatToStrF( Current, ffFixed, 10, 2) + ' ' + CSuffix + ' / ' +
				FloatToStrF( Total, ffFixed, 10, 2) + ' ' + TSuffix + ')';
//        WriteLn(LogFile, DateTimeToStr(Now) + '  HTTPWork : ' + FStatusStr);
      end;
		end;
	end;

	if DoStop then Abort;
end;

procedure TExchangeForm.UnZipBadCRC(Sender: TObject; CalcCRC, StoredCRC,
  FileIndex: Integer);
begin
	if not DoStop then raise Exception.Create( 'Неверная контрольная сумма архива');
end;

procedure TExchangeForm.UnZipInCompleteZip(Sender: TObject;
  var IncompleteMode: TIncompleteZipMode);
begin
	if not DoStop then raise Exception.Create( 'Неверный формат архива');
end;

procedure TExchangeForm.UnZipTotalPercentDone(Sender: TObject;
  Percent: Integer);
begin
	if DoStop then UnZip.CancelTheOperation
		else StatusPosition := Percent;
end;

procedure TExchangeForm.Timer1Timer(Sender: TObject);
begin
	lblElapsed.Caption := TimeToStr( Now - StartTime);

  if ShowStatusText then
  begin
    //Вывели статусный текст на экран и сбросили флаг, чтобы еще раз не выводить
//    ShowStatusText := False;
    stStatus.Caption := FStatusStr;
  end;
end;

procedure TExchangeForm.FormCreate(Sender: TObject);
begin
  ExternalOrdersCount := 0;
  ExternalOrdersLog := TStringList.Create;
  SendOrdersLog := TStringList.Create;
  HTTP.ConnectTimeout := -2;
  HTTPReclame.ConnectTimeout := -2;
end;

procedure TExchangeForm.FormDestroy(Sender: TObject);
begin
  ExternalOrdersLog.Free;
  SendOrdersLog.Free;
end;

procedure TExchangeForm.HTTPStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  WriteLn(LogFile, DateTimeToStr(Now) + '  IdStatus : ' + AStatusText);
end;

procedure TExchangeForm.HTTPWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
  WriteLn(LogFile, DateTimeToStr(Now) + '  HTTPWorkBegin : ' + IntToStr(AWorkCountMax));
end;

procedure TExchangeForm.HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  WriteLn(LogFile, DateTimeToStr(Now) + '  HTTPWorkEnd');
end;

end.
