unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ExtCtrls, DBCtrls, DB, Child, Placemnt,
  ActnList, ImgList, ToolWin, StdCtrls, XPMan, ActnMan, ActnCtrls,
  XPStyleActnCtrls, ActnMenus, ProVersion, DBGridEh, ADODB, DateUtils, ToughDBGrid,
  OleCtrls, SHDocVw, AppEvnts, SyncObjs;

type

TMainForm = class(TForm)
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    itmOrder: TMenuItem;
    itmHelp: TMenuItem;
    itmActions: TMenuItem;
    itmConfig: TMenuItem;
    itmCompact: TMenuItem;
    itmOrderAll: TMenuItem;
    itmOrderPrice: TMenuItem;
    N1: TMenuItem;
    itmReceive: TMenuItem;
    ToolBar: TToolBar;
    itmOrderSummary: TMenuItem;
    itmService: TMenuItem;
    btnStartExchange: TToolButton;
    ToolButton5: TToolButton;
    btnConfig: TToolButton;
    btnOrderAll: TToolButton;
    btnOrderPrice: TToolButton;
    btnOrderSummary: TToolButton;
    ToolButton9: TToolButton;
    FormPlacement: TFormPlacement;
    btnPrint: TToolButton;
    itmPrint: TMenuItem;
    btnOrderRegister: TToolButton;
    itmDocuments: TMenuItem;
    itmRegistry: TMenuItem;
    itmDefective: TMenuItem;
    itmLeadingDocuments: TMenuItem;
    itmClosedOrders: TMenuItem;
    itmExpireds: TMenuItem;
    btnClosedOrders: TToolButton;
    btnDefectives: TToolButton;
    btnNormatives: TToolButton;
    ToolButton11: TToolButton;
    btnExpireds: TToolButton;
    N7: TMenuItem;
    itmExit: TMenuItem;
    N9: TMenuItem;
    itmActiveUsers: TMenuItem;
    itmLinkExternal: TMenuItem;
    itmUnlinkExternal: TMenuItem;
    itmClearDatabase: TMenuItem;
    itmSystem: TMenuItem;
    N6: TMenuItem;
    itmImport: TMenuItem;
    ToolButton1: TToolButton;
    itmSave: TMenuItem;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    itmFreeChildForms: TMenuItem;
    N2: TMenuItem;
    dblcbClients: TDBLookupComboBox;
    ToolButton2: TToolButton;
    itmSendOrders: TMenuItem;
    itmReceiveTickets: TMenuItem;
    N5: TMenuItem;
    CoolBar1: TCoolBar;
    Panel1: TPanel;
    XPManifest1: TXPManifest;
    DownloadMenu: TPopupMenu;
    miReceive: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N17: TMenuItem;
    itmIntegr: TMenuItem;
    Label1: TLabel;
    ActionList: TActionList;
    actReceive: TAction;
    actReceiveTickets: TAction;
    actHelpContent: TAction;
    actSendOrders: TAction;
    actConfig: TAction;
    actOrderAll: TAction;
    actSale: TAction;
    actOrderPrice: TAction;
    actCompact: TAction;
    actOrderSummary: TAction;
    actAbout: TAction;
    actPrint: TAction;
    actRegistry: TAction;
    actDefectives: TAction;
    actNormatives: TAction;
    actClosedOrders: TAction;
    actExit: TAction;
    actActiveUsers: TAction;
    actSave: TAction;
    actCloseAll: TAction;
    actReceiveAll: TAction;
    actIntegr: TAction;
    N3: TMenuItem;
    adsOrdersH: TADODataSet;
    actPreview: TAction;
    N4: TMenuItem;
    actFind: TAction;
    tbFind: TToolButton;
    Browser: TWebBrowser;
    EditDummy: TEdit;
    edDummy: TEdit;
    AppEvents: TApplicationEvents;
    Timer: TTimer;
    ImageList: TImageList;
    itmAbout: TMenuItem;
    btnHome: TToolButton;
    actHome: TAction;
    itmExternalOrders: TMenuItem;
    itmExternal: TMenuItem;
    procedure imgLogoDblClick(Sender: TObject);
    procedure actConfigExecute(Sender: TObject);
    procedure actCompactExecute(Sender: TObject);
    procedure actOrderAllExecute(Sender: TObject);
    procedure actOrderPriceExecute(Sender: TObject);
    procedure actOrderSummaryExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actPrintUpdate(Sender: TObject);
    procedure actRegistryExecute(Sender: TObject);
    procedure actNormativesExecute(Sender: TObject);
    procedure actDefectivesExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actClosedOrdersExecute(Sender: TObject);
    procedure actSaleExecute(Sender: TObject);
    procedure actReceiveExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actActiveUsersExecute(Sender: TObject);
    procedure itmLinkExternalClick(Sender: TObject);
    procedure itmUnlinkExternalClick(Sender: TObject);
    procedure itmClearDatabaseClick(Sender: TObject);
    procedure itmImportClick(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveUpdate(Sender: TObject);
    procedure dblcbClientsCloseUp(Sender: TObject);
    procedure actCloseAllExecute(Sender: TObject);
    procedure actReceiveAllExecute(Sender: TObject);
    procedure actSendOrdersExecute(Sender: TObject);
    procedure actSendOrdersUpdate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actPreviewExecute(Sender: TObject);
    procedure actPreviewUpdate(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actFindUpdate(Sender: TObject);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure edDummyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AppEventsIdle(Sender: TObject; var Done: Boolean);
    procedure actIntegrExecute(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actHomeExecute(Sender: TObject);
    procedure actHomeUpdate(Sender: TObject);
    procedure itmAboutClick(Sender: TObject);
    procedure itmExternalOrdersClick(Sender: TObject);
private
//	FActionLists: TList;
	JustRun: boolean;

	procedure CheckNewDll;
	procedure SetStatusText(Value: string);
	function CheckUnsendOrders: boolean;
public
	CurrentUser: string;	// ��� �������� ������������
	ActiveChild: TChildForm;
	VerInfo: TVerInfo;
	ExchangeOnly: boolean;

	RegionFilterIndex: integer;
	EnableFilterIndex: integer;
//	Filter

	CS: TCriticalSection;

	//��� TChildForm ����� FActionLists, ������� � ������� ������ �������� protected
	property ActionLists: TList read FActionLists write FActionLists;
	property StatusText: string write SetStatusText;

	//�������� ���������� ������ FormClass - ���������� TChildForm
	//FormClass - ���������� ���� ���������
	function ShowChildForm(FormClass: TChildFormClass): TChildForm;
	procedure FreeChildForms;
	procedure SetUpdateDateTime;
	procedure SetOrdersInfo;
	procedure UpdateReclame;
end;

var
	MainForm: TMainForm;

function GetCopyID: LongInt;

implementation

uses
	DModule, AProc, Config, DBProc, NamesForms, Prices,
	Defectives, Registers, Summary, OrdersH,
	Exchange, ActiveUsers, Expireds, Core, UniqueID, CoreFirm, Integr,
	Exclusive, Wait, AlphaUtils, About, ExternalOrders, CompactThread;

{$R *.DFM}

function GetCopyID: LongInt;
begin
	result := GetUniqueID( Application.ExeName, ''{MainForm.VerInfo.FileVersion});
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
	il32: TImageList;
begin
	ExchangeOnly := False;
	Caption := Application.Title;
	VersionInformation( Application.ExeName, VerInfo);
	StatusBar.Panels[ 4].Text := '(������ ' + VerInfo.FileVersion + ')      ';
	RegionFilterIndex := 0;
	EnableFilterIndex := 0;
	JustRun := True;
	CheckNewDll;
	LoadIntegrDLL;
  //���� ���������� ������� ������� ����������, �� ���������� ����� ����
  //Check  IsExternalOrdersDLLPresent
  itmExternalOrders.Visible := IsExternalOrdersDLLPresent;
  itmExternal.Enabled := itmExternalOrders.Visible;
	actIntegr.Enabled := IsIntegrDLLPresent;
	CS := TCriticalSection.Create;
	if Set32BPP then
	begin
		il32 := GetImageListAlpha( Self, Application.ExeName, 100, 32);
//		il16 := GetImageListAlpha( Self, Application.ExeName, 200, 15);
		ToolBar.Images := il32;
//		MainMenu.Images := il16;
	end;
end;

procedure TMainForm.CheckNewDll;
var
	SR: TSearchRec;
begin
	if FindFirst( ExePath + SDirIn + '\*.dll', faAnyFile, SR) = 0 then
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

procedure TMainForm.FormDestroy(Sender: TObject);
begin
	CS.Free;
end;

procedure TMainForm.AppEventsIdle(Sender: TObject; var Done: Boolean);
begin
	if not JustRun then exit;
  //������ ������ � ��� ������, ���� ���������� ������ ���� ������
  if not Active then exit;
	JustRun := False;

	UpdateReclame;
	Timer.Enabled := True;
	CurrentUser := DM.adtClients.FieldByName( 'Name').AsString; 

	{ ������ ������� �� ���. ������ ����� ������ }
	CS.Enter;
	try
		if DM.adtFlags.FieldByName( 'ExclusiveID').AsString = IntToHex(	GetUniqueID(
			Application.ExeName, ''{MainForm.VerInfo.FileVersion}), 8) then DM.ResetExclusive;
	except
	end;
	CS.Leave;

	{ ����� ������ }
	if Trim( DM.adtParams.FieldByName( 'HTTPName').AsString) = '' then
	begin
		MessageBox( '��� ������ ������ � ���������� ���������� ��������� ������� ������',
			MB_ICONWARNING or MB_OK);
		ShowConfig( True);
	end;

	{ ������ � ������ -i (������ ������) }
	if ( AnsiLowerCase( ParamStr( 1)) = '-i') or
		( AnsiLowerCase( ParamStr( 1)) = '/i') then
	begin
		RunExchange([ eaImportOnly]);
		exit;
	end;

	{ ���� �������� ������� �� ���� ��������� }
	if DM.IsBackuped( ExePath) or
		DM.IsBackuped( ExePath + SDirIn + '\') or not DM.Unpacked then
	begin
		MessageBox( '���������� �������� ������� ������ �� ���� ���������', MB_ICONWARNING or MB_OK);
		if DM.IsBackuped( ExePath) then
		begin
			DM.MainConnection.Close;
			DM.RestoreDatabase( ExePath);
			DM.MainConnection.Open;
		end;
		{ �������������� ������ }
		RunExchange([ eaImportOnly]);
	end;

	if ExchangeOnly then exit;
	{ �� ����������� ������ 20 ����� }
	if ( HourSpan( DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime, Now) > 20) and
		( Trim( DM.adtParams.FieldByName( 'HTTPName').AsString) <> '') then
		if MessageBox( '�� ��������� � ���������� ������� ������. ��������� ����������?',
			MB_ICONQUESTION or MB_YESNO) = IDYES then actReceiveExecute( nil);
end;

procedure TMainForm.SetStatusText( Value: string);
begin
	Value := Trim( Value);
	StatusBar.SimpleText := Value;
	StatusBar.SimplePanel := Value <> '';
	Application.ProcessMessages;
end;

procedure TMainForm.FreeChildForms;
var
	i: Integer;
begin
	for i := ControlCount - 1 downto 0 do
		if Controls[ i] is TChildForm then Controls[ i].Free;
	ActiveChild := nil;
	Caption := Application.Title;
	SetOrdersInfo;
	try
		edDummy.SetFocus;
	except
	end;
end;

procedure TMainForm.imgLogoDblClick(Sender: TObject);
begin
	case DM.adtParams.FieldByName( 'StartPage').AsInteger of
		0: ShowOrderAll;
		1: actOrderPrice.Execute;
	end;
end;

procedure TMainForm.actConfigExecute(Sender: TObject);
begin
	ShowConfig;
end;

procedure TMainForm.actCompactExecute(Sender: TObject);
begin
	if MessageBox( '������ � �������������� ���� ������ ���������� ���������� �������' + #13 +
		'� ������ ����������� ����������. ����������?', MB_ICONQUESTION or MB_OKCANCEL) <> IDOK then exit;
	FreeChildForms;
	Application.ProcessMessages;
  RunCompactDatabase;
	MessageBox( '������ � �������������� ���� ������ ���������');
end;

procedure TMainForm.actOrderAllExecute(Sender: TObject);
begin
	ShowOrderAll;
end;

procedure TMainForm.actOrderPriceExecute(Sender: TObject);
begin
	ShowPrices;
end;

procedure TMainForm.actOrderSummaryExecute(Sender: TObject);
begin
	ShowSummary;
end;

procedure TMainForm.actPrintUpdate(Sender: TObject);
begin
	actPrint.Enabled := ( ActiveChild <> nil) and ActiveChild.PrintEnabled;
end;

procedure TMainForm.actPrintExecute(Sender: TObject);
begin
	if ( ActiveChild <> nil) and ActiveChild.PrintEnabled then
		ActiveChild.Print;
end;

procedure TMainForm.actPreviewUpdate(Sender: TObject);
begin
	actPreview.Enabled := ( ActiveChild <> nil) and ActiveChild.PrintEnabled;
end;

procedure TMainForm.actPreviewExecute(Sender: TObject);
begin
	if ( ActiveChild <> nil) and ActiveChild.PrintEnabled then
		ActiveChild.Print( True);
end;

procedure TMainForm.actRegistryExecute(Sender: TObject);
begin
	ShowChildForm( TRegistersForm);
end;

procedure TMainForm.actNormativesExecute(Sender: TObject);
begin
//	ShowChildForm( TNormativesForm);
end;

procedure TMainForm.actDefectivesExecute(Sender: TObject);
begin
	ShowChildForm( TDefectivesForm);
end;

{ �������� ���������� ������ FormClass - ���������� TChildForm }
function TMainForm.ShowChildForm( FormClass: TChildFormClass): TChildForm;
begin
	try
		result := TChildForm( FindChildControlByClass( Self, FormClass));
		if result = nil then
		begin
			FreeChildForms;
			Result := FormClass.Create(Application);
		end
		else result.Show;
	except
		FreeChildForms;
		raise;
	end;
end;

procedure TMainForm.actClosedOrdersExecute( Sender: TObject);
begin
	if ActiveChild is TCoreForm then
	begin
		CoreForm.ShowOrdersH;
	end
	else
	begin
		FreeChildForms;
		ShowOrdersH;
	end;
end;

procedure TMainForm.actSaleExecute(Sender: TObject);
begin
	ShowChildForm( TExpiredsForm);
end;

procedure TMainForm.actReceiveExecute(Sender: TObject);
var
	CatNum: integer;
	ExAct: TExchangeActions;
begin
	ExAct := [ eaGetPrice];

	{ ��������� ������� �� ������� ������� }
	DM.adsSelect.CommandText := 'SELECT COUNT(*) AS CatNum FROM [Catalog]';
	try
		DM.adsSelect.Open;
		CatNum := DM.adsSelect.FieldByName( 'CatNum').AsInteger;
	except
		CatNum := 0;
	end;
	DM.adsSelect.Close;

	{ ���� ������� ������, �� ���������� ����� ������������� ������������ }
	if CatNum = 0 then ExAct := ExAct + [ eaGetFullData, eaSendOrders];

	RunExchange( ExAct);
end;

procedure TMainForm.actReceiveAllExecute(Sender: TObject);
begin
	if MessageBox( '������������ ���������� ���������� ���������� �������. ����������?',
		MB_ICONQUESTION or MB_OKCANCEL) = IDOK then
			RunExchange([ eaGetPrice, eaGetFullData, eaSendOrders]);
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
	Close;
end;

procedure TMainForm.actActiveUsersExecute(Sender: TObject);
begin
	ShowActiveUsers;
end;

procedure TMainForm.itmLinkExternalClick(Sender: TObject);
begin
	DM.LinkExternalTables;
end;

procedure TMainForm.itmUnlinkExternalClick(Sender: TObject);
begin
	DM.UnLinkExternalTables;
end;

procedure TMainForm.itmClearDatabaseClick(Sender: TObject);
begin
	if MessageBox( '������������� �������� ����?',
		MB_ICONQUESTION or MB_OKCANCEL) <> IDOK then exit;
	FreeChildForms;
	Application.ProcessMessages;
	DM.ClearDatabase;
	MessageBox( '������� ���� ���������');
end;

procedure TMainForm.itmImportClick(Sender: TObject);
begin
	RunExchange([ eaImportOnly]);
end;

procedure TMainForm.SetUpdateDateTime;
begin
	StatusBar.Panels[ 3].Text := '���������� : ' +
		DateTimeToStr( UTCToLocalTime(
		DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime));
end;

procedure TMainForm.actSaveExecute(Sender: TObject);
begin
	SaveGrid( TCustomDBGridEh( Screen.ActiveControl));
end;

procedure TMainForm.actSaveUpdate(Sender: TObject);
begin
	actSave.Enabled := ( Screen.ActiveControl <> nil) and
		 ( Screen.ActiveControl is TCustomDBGridEh);
end;

procedure TMainForm.SetOrdersInfo;
begin
	DM.adsSelect.Close;
	DM.adsSelect.CommandText := 'SELECT * FROM OrdersInfo2';
	DM.adsSelect.Parameters.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	DM.adsSelect.Open;
	try
		StatusBar.Panels[ 0].Text := Format( '������� : %d',
			 [ DM.adsSelect.FieldByName( 'OrdersCount').AsInteger]);
		StatusBar.Panels[ 1].Text := Format( '������� : %d',
			 [ DM.adsSelect.FieldByName( 'Positions').AsInteger]);
		StatusBar.Panels[ 2].Text := Format( '����� : %0.2f',
			 [ DM.adsSelect.FieldByName( 'SumOrder').AsFloat]);
	finally
		DM.adsSelect.Close;
	end;
end;

procedure TMainForm.dblcbClientsCloseUp(Sender: TObject);
begin
	if CurrentUser <> TDBLookupComboBox( Sender).ListSource.DataSet.FieldByName( 'Name').AsString then
	begin
		DM.ClientChanged;
		CurrentUser := TDBLookupComboBox( Sender).ListSource.DataSet.FieldByName( 'Name').AsString;
	end;
end;

procedure TMainForm.actCloseAllExecute(Sender: TObject);
begin
	FreeChildForms;
end;

procedure TMainForm.actSendOrdersExecute(Sender: TObject);
begin
	RunExchange([ eaSendOrders]);
end;

function TMainForm.CheckUnsendOrders: boolean;
begin
	result := False;
	adsOrdersH.Parameters.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').Value;
	adsOrdersH.Parameters.ParamByName( 'AClosed').Value := False;
	adsOrdersH.Parameters.ParamByName( 'ASend').Value := True;
	adsOrdersH.Parameters.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	try
		adsOrdersH.Open;
		if adsOrdersH.RecordCount > 0 then result := True;
	finally
		adsOrdersH.Close;
	end;
end;

procedure TMainForm.actSendOrdersUpdate(Sender: TObject);
begin
	actSendOrders.Enabled := CheckUnsendOrders;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	if not DM.MainConnection.Connected then exit;
	if CheckUnsendOrders then
	begin
		if MessageBox( '���������� �������������� ������. ' +
			'��������� �� ������?', MB_ICONQUESTION or MB_YESNO) = IDYES then
			RunExchange([ eaSendOrders]);
	end;
end;

procedure TMainForm.actFindExecute(Sender: TObject);
begin
	TToughDBGrid( Screen.ActiveControl).ShowFind;
end;

procedure TMainForm.actFindUpdate(Sender: TObject);
begin
	TAction( Sender).Enabled := ( Screen.ActiveControl <> nil) and
		( Screen.ActiveControl is TToughDBGrid) and
		( TToughDBGrid( Screen.ActiveControl).SearchField <> '');
end;

procedure TMainForm.UpdateReclame;
begin
	if SysUtils.FileExists( ExePath + SDirReclame + '\' +
		FormatFloat( '00', Browser.Tag) + '.htm') then
		Browser.Navigate( ExePath + SDirReclame + '\' +
			FormatFloat( '00', Browser.Tag) + '.htm');
end;

procedure TMainForm.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
	if not EditDummy.Focused and
		not ActiveControl.Focused and
		not ActiveControl.ClassNameIs( 'TWebBrowser') then EditDummy.SetFocus;
end;

procedure TMainForm.edDummyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if Ord( Key) >= 32 then actOrderAll.Execute;
end;

procedure TMainForm.actIntegrExecute(Sender: TObject);
begin
	if not IsIntegrDLLPresent then exit;

	IntegrConfig( DM.MainConnection,
		DM.adtClients.FieldByName( 'RegionCode').AsInteger,
		Self.Handle);
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
	ExID: string;
begin
	if not DM.MainConnection.Connected then exit;

	{ �������� �� ������ �� ����������� ������ }
	CS.Enter;
	try
		DM.adtFlags.Requery;
		ExID := DM.adtFlags.FieldByName( 'ExclusiveID').AsString;
	except
		ExID := '';
	end;
	if ( ExID <> IntToHex( GetUniqueID( Application.ExeName,
		''{MainForm.VerInfo.FileVersion}), 8)) and ( ExID <> '') then
	begin
		CS.Leave;
		ShowWait;
	end
	else CS.Leave;
end;

procedure TMainForm.actHomeExecute(Sender: TObject);
begin
	MainForm.FreeChildForms;
end;

procedure TMainForm.actHomeUpdate(Sender: TObject);
begin
	if Self.ActiveChild <> nil then TAction( Sender).Enabled := True
		else TAction( Sender).Enabled := False;
end;

procedure TMainForm.itmAboutClick(Sender: TObject);
begin
	with TAboutForm.Create( Self) do
	begin
		ShowModal;
		Free;
	end;
end;

procedure TMainForm.itmExternalOrdersClick(Sender: TObject);
begin
  if not IsExternalOrdersDLLPresent then
    Exit;

  DM.adtParams.Close;
  try
    ExternalOrdersConfig( DM.MainConnection, Self.Handle);
  finally
    DM.adtParams.Open;
  end;
end;

end.
