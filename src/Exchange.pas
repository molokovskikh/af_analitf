unit Exchange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ARas, InvokeRegistry, StrUtils, ComObj,
  VCLUnZip, Rio, SOAPHTTPClient, Variants, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExchangeThread, CheckLst, DateUtils,
  ActnList, Math, IdAuthentication, IdAntiFreezeBase, IdAntiFreeze, WinSock;

type
  TExchangeAction=( eaGetPrice, eaSendOrders, eaImportOnly, eaGetFullData, eaMDBUpdate);

  TExchangeActions=set of TExchangeAction;

  TExchangeForm = class(TForm)
    btnCancel: TButton;
    Timer: TTimer;
    ProgressBar: TProgressBar;
    Ras: TARas;
    HTTPRIO: THTTPRIO;
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
  private
    FStatusPosition: Integer;
	  ExchangeActions: TExchangeActions;
	  StartTime: TTime;
	  ConnectCount: integer;
	  ConnectPause: cardinal;

    //���������� ���������� ������
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

    //���������� ��� ������ ������� �������
    ExternalOrdersCount : Integer;
    ExternalOrdersLog : TStringList;

    //���������� �� ��������� ����� � ��������� ���������� �����
    ShowStatusText : Boolean;

    property StatusText: string read GetStatusText write SetStatusText;
    property StatusPosition: Integer write SetStatusPosition;
    property ExchangeActs: TExchangeActions read ExchangeActions write ExchangeActions;
    property AppHandle: HWND read GetAppHandle;
    procedure CheckStop;
	procedure PauseAfterError;
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
  Exclusive, CompactThread, ShowLog, ExternalOrders;

{$R *.DFM}

function RunExchange( AExchangeActions: TExchangeActions=[eaGetPrice]): Boolean;
var
	mr: integer;
  ExternalOrdersCount,
  ExternalOrdersErrorCount : Integer;
  ExternalOrdersLog   : String;
//	hMenuHandle: HMENU;
begin
	MainForm.FreeChildForms;
	Result := False;
	ServerAddition := '';
  ExternalOrdersCount := 0;
  ExternalOrdersErrorCount := 0;
  ExternalOrdersLog := '';
	if AExchangeActions = [] then exit;
	DM.DeleteEmptyOrders;

  //�������� ���������� ����� ��������� �������
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
			'���������� �������� ������� ������ �� ���� ���������.' + #10#13 +
			'���������� � �� "�������"', '��������', MB_OK or MB_ICONWARNING);
		exit;
	end;

	//������� ����� � �������� ����� �������
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
  		Append( ExchangeForm.LogFile) //����� ��������� ���-����
    else
  		Rewrite( ExchangeForm.LogFile); //������� ���-����
    WriteLn(ExchangeForm.LogFile);
    WriteLn(ExchangeForm.LogFile);
    WriteLn(ExchangeForm.LogFile);
    WriteLn(ExchangeForm.LogFile, '---------------------------');
    WriteLn(ExchangeForm.LogFile, '������ ������ � ' + DateTimeToStr(Now));
		try
			ExchangeForm.Timer.Enabled := True;
			Result := ExchangeForm.ShowModal = mrOk;
      ExternalOrdersCount := ExchangeForm.ExternalOrdersCount;
      ExternalOrdersErrorCount := ExchangeForm.ExternalOrdersLog.Count;
      ExternalOrdersLog := ExchangeForm.ExternalOrdersLog.Text;
			DM.MainConnection.Close;
			DM.MainConnection.Open;
//		finally
		except
			on E: Exception do ShowMessage( E.Message);
		end;
    WriteLn(ExchangeForm.LogFile, '������ �������� � ' + DateTimeToStr(Now));
    WriteLn(ExchangeForm.LogFile, '---------------------------');
		CloseFile( ExchangeForm.LogFile);
    if ( eaGetPrice in AExchangeActions) and Result then
      DeleteFile(ExePath + 'Exchange.log')
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
			PChar( ServerAddition), '��������� �� �� "�������"',
			MB_OK or MB_ICONINFORMATION);

	if Result and (( eaGetPrice in AExchangeActions) or
		( eaImportOnly in AExchangeActions)) then Windows.MessageBox( Application.Handle,
			'���������� ��������� �������.', '����������',
			MB_OK or MB_ICONINFORMATION);

	if Result and ( AExchangeActions = [ eaSendOrders]) then Windows.MessageBox( Application.Handle,
			'�������� ������� ��������� �������.', '����������',
			MB_OK or MB_ICONINFORMATION);

	if Result and ( AExchangeActions = [ eaSendOrders]) and (ExternalOrdersCount > 0)
     and (Length(ExternalOrdersLog) > 0)
  then
    if MessageBox(
        '�� ����� ������������ ������� ������� ��� "������" �������� ������. ' +
            '������� ���������� ������ ������?',
        MB_ICONWARNING or MB_YESNO) = IDYES
    then
      RunShowLog(ExternalOrdersLog);

	if Result and ( AExchangeActions = [ eaSendOrders]) and (ExternalOrdersCount > 0)
    and (ExternalOrdersCount > ExternalOrdersErrorCount) and IsExternalOrdersDLLPresent
  then begin
    if MessageBox(
        '������ ��� "������" ������������. ' +
            '��������� ��������� ��� �� �������� ������?',
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
		CompactForm.lblMessage.Caption := '������ ���� �� ������������� ����� ' +
			IntToStr( COMPACT_PERIOD) + ' ����.' + #10 + #13 +
			'���������� ������ ����? (�������������)';
		mr := CompactForm.ShowModal;
		CompactForm.Close;
		CompactForm.Free;
		if mr = mrOK then begin
//      DM.CompactDatabase;
      MainForm.FreeChildForms;
      Application.ProcessMessages;
      RunCompactDatabase;
    end;
		MessageBox( '������ � �������������� ���� ������ ���������');
	end;
end;

{ ��������������� ������ ����� ���������� }
procedure TryToRepareOrders;
var
	Order, CurOrder, SynonymCode, SynonymFirmCrCode, Quantity, E: Integer;
	Code, CodeCr: Variant;
	Strings: TStrings;

	procedure SetOrder( Order: integer);
	begin
		DM.adsSelect3.Edit;
		DM.adsSelect3.FieldByName( 'Order').AsInteger := Order;
		if Order = 0 then DM.adsSelect3.FieldByName( 'CoreId').Value := Null
			else DM.adsSelect3.FieldByName( 'CoreId').Value := DM.adsCore.FieldByName( 'CoreId').Value;
		DM.adsSelect3.Post;
	end;

begin
 	DM.adsSelect3.Close;
 	DM.adsSelect3.CommandText := 'SELECT Id, CoreId, PriceCode, RegionCode, Code, CodeCr, ' +
		'Price, SynonymCode, SynonymFirmCrCode, Synonym, SynonymFirm, Order, PriceName ' +
		'FROM Orders ' +
		'INNER JOIN OrdersH ON (OrdersH.OrderId=Orders.OrderId AND NOT OrdersH.Closed) ' +
		'WHERE (Order>0)';
 	DM.adsSelect3.Open;
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
		DM.adsCore.Parameters.ParamByName( 'RetailForcount').Value :=
			DM.adtClients.FieldByName( 'Forcount').Value;
		DM.adsCore.Parameters.ParamByName( 'AClientId').Value :=
			DM.adtClients.FieldByName('ClientId').Value;
		DM.adsCore.Parameters.ParamByName( 'APriceCode').Value :=
			DM.adsSelect3.FieldByName( 'PriceCode').Value;
		DM.adsCore.Parameters.ParamByName( 'ARegionCode').Value :=
			DM.adsSelect3.FieldByName( 'RegionCode').Value;
		Screen.Cursor := crHourglass;
		try
			DM.adsCore.Open;
			{ ��������� ������� �����-����� }
			if DM.adsCore.IsEmpty then
			begin
				Strings.Append( Format( '%s : %s - %s : �����-���� �����������',
					[ DM.adsSelect3.FieldByName( 'PriceName').AsString,
					DM.adsSelect3.FieldByName( 'Synonym').AsString,
					DM.adsSelect3.FieldByName( 'SynonymFirm').AsString]));
				DM.adsCore.Close;
				SetOrder( 0);
				DM.adsSelect3.Next;
				continue;
			end;
			Order := DM.adsSelect3.FieldByName( 'Order').AsInteger;
			CurOrder := 0;
			Code := DM.adsSelect3.FieldByName( 'Code').AsString;
			if Code = '' then Code := Null;
			CodeCr := DM.adsSelect3.FieldByName( 'CodeCr').AsString;
			if CodeCr = '' then CodeCr := Null;
			SynonymCode := DM.adsSelect3.FieldByName( 'SynonymCode').AsInteger;
			SynonymFirmCrCode := DM.adsSelect3.FieldByName( 'SynonymFirmCrCode').AsInteger;

			if DM.adsCore.Locate( 'Code;CodeCr;SynonymCode;SynonymFirmCrCode',
				VarArrayOf([ Code, CodeCr, SynonymCode, SynonymFirmCrCode]), []) then
			begin
				Val( DM.adsCore.FieldByName( 'Quantity').AsString, Quantity, E);
				if E <> 0 then Quantity := 0;
				if Quantity > 0 then
					CurOrder := Min( Order, Quantity)
				else CurOrder := Order;
			end;
			SetOrder( CurOrder);

			{ ���� ��� ��� �� ����������, �� ����� ��������� }
			if ( Order - CurOrder) > 0 then
			begin
				if CurOrder > 0 then
				begin
					Strings.Append( Format( '%s : %s - %s : %d ������ %d (������ ���� : %s)',
						[ DM.adsSelect3.FieldByName( 'PriceName').AsString,
						DM.adsSelect3.FieldByName( 'Synonym').AsString,
						DM.adsSelect3.FieldByName( 'SynonymFirm').AsString,
						CurOrder,
						Order,
						DM.adsSelect3.FieldByName( 'Price').AsString]));
				end
				else
				begin
					Strings.Append( Format( '%s : %s - %s : ����������� ����������� (������ ���� : %s)',
						[ DM.adsSelect3.FieldByName( 'PriceName').AsString,
						DM.adsSelect3.FieldByName( 'Synonym').AsString,
						DM.adsSelect3.FieldByName( 'SynonymFirm').AsString,
						DM.adsSelect3.FieldByName( 'Price').AsString]));
				end;
			end;
			DM.adsSelect3.Next;
		finally
			DM.adsCore.Close;
		        Screen.Cursor := crDefault;
		end;
	end;

	{ ���� �� ����� ���-��, �� ������� ��������� }
	if Strings.Count > 0 then ShowNotFound( Strings);

	finally
		Strings.Free;
		DM.adsSelect3.Close;
        end;
end;


//����� ����� ������
procedure TExchangeForm.PauseAfterError;
begin
	RetryForm := TRetryForm.Create( Application);
	RetryForm.lblError.Caption := ExThread.ErrorMessage;
	RetryForm.Seconds := ConnectPause;
	RetryForm.ShowModal;
	RetryForm.Close;
	RetryForm.Free;
end;

procedure TExchangeForm.TimerTimer(Sender: TObject);
var
	ConnectNumber: Integer;
	ErrMsg: string;
begin
	//����� ���������� �� ��������, ������� ����� ���� ��������
	StartTime := Now;
  ShowStatusText := False;
  FStatusStr := '';
	Timer1.Enabled := True;
	Timer.Enabled := False;
	DoStop := False;

	ConnectCount := DM.adtParams.FieldByName( 'ConnectCount').AsInteger;
	ConnectPause := DM.adtParams.FieldByName( 'ConnectPause').AsInteger;
	Caption := '����� �������';

	QueryResults := TStringList.Create;
	//������� ���� ����������
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
			if ( ConnectNumber < ConnectCount) and not ExThread.CriticalError then PauseAfterError
				else break;
		end
		else break;
	end;
	QueryResults.Free;

	//������� ����� In
//	DeleteFilesByMask( ExePath + SDirIn + '\*.*');

        ErrMsg := ExThread.ErrorMessage;

	{ ��������� ���������� ��������� }
	if Assigned( ExThread) and ( ErrMsg = 'Terminate') then
	begin
		DM.MainConnection.Close;
		Application.Terminate;
	end;

	{ ������ �������� }
	if Assigned( ExThread) and ( ErrMsg = 'Cancel') then
	begin
		ModalResult := mrCancel;
		exit;
	end;

	if Assigned( ExThread) and ( ErrMsg <> '') then
	begin
		ModalResult := mrAbort;
		ExThread.Free;
		raise Exception.Create( ErrMsg);
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
	try
		ExThread.CriticalError := True;
		ExThread.ErrorMessage := '������ ��������';
		HTTP.Disconnect;
		Ras.Disconnect;
	except
	end;
end;

procedure TExchangeForm.SetRasParams;
begin
	// ��������� ���������� ����������
	if DM.adtParams.FieldByName( 'RasConnect').AsBoolean then
	begin
		Ras.Entry := DM.adtParams.FieldByName( 'RasEntry').AsString;
		Ras.UserName := DM.adtParams.FieldByName( 'RasName').AsString;
		Ras.Password := DM.adtParams.FieldByName( 'RasPass').AsString;
	end;
end;

procedure TExchangeForm.SetHTTPParams;
begin
	// ���������� ��������� HTTP-�������
	if DM.adtParams.FieldByName( 'ProxyConnect').AsBoolean then
        begin
		HTTP.ProxyParams.ProxyServer := DM.adtParams.FieldByName( 'ProxyName').AsString;
		HTTP.ProxyParams.ProxyPort := DM.adtParams.FieldByName( 'ProxyPort').AsInteger;
		HTTP.ProxyParams.ProxyUsername := DM.adtParams.FieldByName( 'ProxyUser').AsString;
		HTTP.ProxyParams.ProxyPassword := DM.adtParams.FieldByName( 'ProxyPass').AsString;
		HTTPReclame.ProxyParams.ProxyServer := DM.adtParams.FieldByName( 'ProxyName').AsString;
		HTTPReclame.ProxyParams.ProxyPort := DM.adtParams.FieldByName( 'ProxyPort').AsInteger;
		HTTPReclame.ProxyParams.ProxyUsername := DM.adtParams.FieldByName( 'ProxyUser').AsString;
		HTTPReclame.ProxyParams.ProxyPassword := DM.adtParams.FieldByName( 'ProxyPass').AsString;
	end
	else
	begin
		HTTP.ProxyParams.ProxyServer := '';
		HTTP.ProxyParams.ProxyPort := 0;
		HTTP.ProxyParams.ProxyUsername := '';
		HTTP.ProxyParams.ProxyPassword := '';
		HTTPReclame.ProxyParams.ProxyServer := '';
		HTTPReclame.ProxyParams.ProxyPort := 0;
		HTTPReclame.ProxyParams.ProxyUsername := '';
		HTTPReclame.ProxyParams.ProxyPassword := '';
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

		TSuffix := '��';
		CSuffix := '��';

		Total := RoundTo(( HTTP.Response.ContentRangeStart +
			Cardinal( HTTP.Response.ContentLength)) / 1024, -2);
		Current := RoundTo((HTTP.Response.ContentRangeStart +
			Cardinal( AWorkCount)) / 1024, -2);

		if Total <> Current then
		begin
			if Total > 1000 then
			begin
				Total := RoundTo( Total / 1024, -2);
				TSuffix := '��';
			end;
			if Current > 1000 then
			begin
				Current := RoundTo( Current / 1024, -2);
				CSuffix := '��';
			end;

			if FStatusPosition > 0 then
      begin
//        ShowStatusText := True;
//        stStatus.Caption := '�������� ������   (' +
        FStatusStr := '�������� ������   (' +
				FloatToStrF( Current, ffFixed, 10, 2) + ' ' + CSuffix + ' / ' +
				FloatToStrF( Total, ffFixed, 10, 2) + ' ' + TSuffix + ')';
      end;
		end;
	end;

	if DoStop then Abort;
end;

procedure TExchangeForm.UnZipBadCRC(Sender: TObject; CalcCRC, StoredCRC,
  FileIndex: Integer);
begin
	if not DoStop then raise Exception.Create( '�������� ����������� ����� ������');
end;

procedure TExchangeForm.UnZipInCompleteZip(Sender: TObject;
  var IncompleteMode: TIncompleteZipMode);
begin
	if not DoStop then raise Exception.Create( '�������� ������ ������');
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
    //������ ��������� ����� �� ����� � �������� ����, ����� ��� ��� �� ��������
//    ShowStatusText := False;
    stStatus.Caption := FStatusStr;
  end;
end;

procedure TExchangeForm.FormCreate(Sender: TObject);
begin
  ExternalOrdersCount := 0;
  ExternalOrdersLog := TStringList.Create;
  HTTP.ConnectTimeout := -2;
end;

procedure TExchangeForm.FormDestroy(Sender: TObject);
begin
  ExternalOrdersLog.Free;
end;

procedure TExchangeForm.HTTPStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  WriteLn(LogFile, DateTimeToStr(Now) + '  IdStatus : ' + AStatusText);
end;

end.