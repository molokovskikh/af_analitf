unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ExtCtrls, DBCtrls, DB, Child, Placemnt,
  ActnList, ImgList, ToolWin, StdCtrls, XPMan, ActnMan, ActnCtrls,
  XPStyleActnCtrls, ActnMenus, ProVersion, DBGridEh, DateUtils, ToughDBGrid,
  OleCtrls, SHDocVw, AppEvnts, SyncObjs, FIBDataSet, pFIBDataSet, Consts, ShellAPI;

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
    ToolButton2: TToolButton;
    itmSendOrders: TMenuItem;
    itmReceiveTickets: TMenuItem;
    N5: TMenuItem;
    CoolBar1: TCoolBar;
    XPManifest1: TXPManifest;
    DownloadMenu: TPopupMenu;
    miReceive: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N17: TMenuItem;
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
    N3: TMenuItem;
    actPreview: TAction;
    N4: TMenuItem;
    actFind: TAction;
    tbFind: TToolButton;
    Browser: TWebBrowser;
    edDummy: TEdit;
    AppEvents: TApplicationEvents;
    Timer: TTimer;
    ImageList: TImageList;
    itmAbout: TMenuItem;
    btnHome: TToolButton;
    actHome: TAction;
    adsOrdersH: TpFIBDataSet;
    tbWaybill: TToolButton;
    actWayBill: TAction;
    tbLastSeparator: TToolButton;
    ToolButton7: TToolButton;
    actSynonymSearch: TAction;
    ToolButton10: TToolButton;
    actSendLetter: TAction;
    miSendLetter: TMenuItem;
    tbViewDocs: TToolButton;
    actViewDocs: TAction;
    pmClients: TPopupMenu;
    est11: TMenuItem;
    est21: TMenuItem;
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
    procedure actCloseAllExecute(Sender: TObject);
    procedure actReceiveAllExecute(Sender: TObject);
    procedure actSendOrdersExecute(Sender: TObject);
    procedure actSendOrdersUpdate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actPreviewExecute(Sender: TObject);
    procedure actPreviewUpdate(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actFindUpdate(Sender: TObject);
    procedure lCurrentClientMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure edDummyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AppEventsIdle(Sender: TObject; var Done: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actHomeExecute(Sender: TObject);
    procedure actHomeUpdate(Sender: TObject);
    procedure itmAboutClick(Sender: TObject);
    procedure actWayBillExecute(Sender: TObject);
    procedure actSynonymSearchExecute(Sender: TObject);
    procedure actReceiveTicketsExecute(Sender: TObject);
    procedure actSendLetterExecute(Sender: TObject);
    procedure actViewDocsExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ToolBarAdvancedCustomDraw(Sender: TToolBar;
      const ARect: TRect; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure ToolBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ToolBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
private
	JustRun: boolean;

	procedure SetStatusText(Value: string);
  procedure OnAppEx(Sender: TObject; E: Exception);
  procedure OnMainAppEx(Sender: TObject; E: Exception);
  function  GetActionLists : TList;
  procedure SetActionLists(AValue : TList);
  function  OldOrders : Boolean;
  procedure DeleteOldOrders;
public
	CurrentUser: string;	// ��� �������� ������������
	ActiveChild: TChildForm;
	VerInfo: TVerInfo;
	ExchangeOnly: boolean;

	RegionFilterIndex: integer;
	EnableFilterIndex: integer;
//	Filter

	CS: TCriticalSection;

  //������������ ������ ������������ �������, ���������� ��� �����������
  MaxClientNameWidth : Integer;
  //������������� �� ToolBar ��� ����������� �������� ������ �������
  ClientNameRect : TRect;

	//��� TChildForm ����� FActionLists, ������� � ������� ������ �������� protected
	property ActionLists: TList read GetActionLists write SetActionLists;
	property StatusText: string write SetStatusText;

	//�������� ���������� ������ FormClass - ���������� TChildForm
	//FormClass - ���������� ���� ���������
	function ShowChildForm(FormClass: TChildFormClass): TChildForm;
	procedure FreeChildForms;
	procedure SetUpdateDateTime;
	procedure SetOrdersInfo;
	procedure UpdateReclame;
  //��������� ��� ��������, ��������� � ���������� ����� �����������
  procedure DisableByHTTPName;
  //�������� ��� ��������, ��������� � ���������� ����� �����������
  procedure EnableByHTTPName;
	function CheckUnsendOrders: boolean;
  procedure OnSelectClientClick(Sender: TObject);
end;

var
	MainForm: TMainForm;

//���������� �������������, ������������ ��� ����������
function GetCopyID: LongInt;

//���������� ������������� � ������ Hash'� ����������
function GetDBID: LongInt;

//���������� ������������� � ������ Hash'� ���������� ������ ������
function GetOldDBID: LongInt;

//�������� ������������� ��������� ��������� ������������ ����, ����� ��������� ��������� ��������� � �������
function GetPathCopyID: String;

implementation

uses
	DModule, AProc, Config, DBProc, NamesForms, Prices,
	Defectives, Registers, Summary, OrdersH,
	Exchange, ActiveUsers, Expireds, Core, UniqueID, CoreFirm,
	Exclusive, Wait, AlphaUtils, About, CompactThread, LU_Tracer,
  SynonymSearch, U_frmOldOrdersDelete, U_frmSendLetter, Types, U_ExchangeLog;

{$R *.DFM}

function GetCopyID: LongInt;
begin
{$ifdef DSP}
  result := StrToInt64('$E99E48');
{$else}
	result := GetUniqueID( Application.ExeName, '');
{$endif}
end;

function GetDBID: LongInt;
begin
{$ifdef DEBUG}
 	result := GetUniqueID( Application.ExeName, 'E99E483DDE777778ADEFCB3DCD988BC9');
{$else}
  {$ifdef DSP}
    result := StrToInt64('$3DDE77');
  {$else}
    result := GetUniqueID( Application.ExeName, AProc.GetFileHash(Application.ExeName));
  {$endif}
{$endif}
end;

function GetOldDBID: LongInt;
begin
{$ifdef DSP}
  result := StrToInt64('$3DDE77');
{$else}
  result := GetUniqueID( Application.ExeName, AProc.GetFileHash(ExePath + SBackDir + '\' + ExtractFileName(Application.ExeName) + '.bak'));
{$endif}
end;


function GetPathCopyID: String;
begin
  Result := IntToHex( GetPathID(Application.ExeName), 8);
end;


procedure TMainForm.FormCreate(Sender: TObject);
//var
//	il32: TImageList;
begin
  FormPlacement.Active := False;
  Application.OnException := OnMainAppEx;
	ExchangeOnly := False;
	Caption := Application.Title;
	VersionInformation( Application.ExeName, VerInfo);
	StatusBar.Panels[ 4].Text := '(������ ' + VerInfo.FileVersion + ')      ';
	RegionFilterIndex := 0;
	EnableFilterIndex := 0;
	JustRun := True;
  if FindCmdLineSwitch('extd') then begin
    N2.Visible := True;
    N6.Visible := True;
    itmLinkExternal.Visible := True;
    itmUnlinkExternal.Visible := True;
    itmClearDatabase.Visible := True;
  end;
	CS := TCriticalSection.Create;
	if Set32BPP then
    LoadToImageList(ImageList, Application.ExeName, 100);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
	CS.Free;
end;

procedure TMainForm.AppEventsIdle(Sender: TObject; var Done: Boolean);
var
  I : Integer;
begin
  //�������� ��� ��� ����, ����� ��������� ��������� pbSelectClient ����� ����������,
  //��-�� ���� ����� ���������� ������ ��������
  FormResize(nil);

	if not JustRun then exit;
  //������ ������ � ��� ������, ���� ���������� ������ ���� ������
  if not Active then exit;
	JustRun := False;

  //���������� ��������������
  FormPlacement.Active := True;
  Self.WindowState := wsMaximized;

	UpdateReclame;
	Timer.Enabled := True;
	CurrentUser := DM.adtClients.FieldByName( 'Name').AsString;

	{ ������ ������� �� ���. ������ ����� ������ }
	CS.Enter;
  try
	  try
		  if DM.adtFlags.FieldByName( 'ExclusiveID').AsString = GetExclusiveID() then DM.ResetExclusive;
   	except
	  end;
  finally
  	CS.Leave;
  end;

	{ ����� ������ }
	if Trim( DM.adtParams.FieldByName( 'HTTPName').AsString) = '' then
	begin
		AProc.MessageBox( '��� ������ ������ � ���������� ���������� ��������� ������� ������',
			MB_ICONWARNING or MB_OK);
		ShowConfig( True);
	end;

  //���� ��������� ��������� � �������� renew, �� ��������� ��� �������� ����� ������������
  if FindCmdLineSwitch('renew') then
  begin
    for I := 0 to ActionList.ActionCount-1 do
      if ActionList.Actions[i] <> actConfig then
        TAction(ActionList.Actions[i]).Enabled := False;
    itmSystem.Enabled := False;
    Exit;
  end;

	{ ������ � ������ -i (������ ������) ��� ��������� ����� ������ ���������}
	if FindCmdLineSwitch('i') then
	begin
    //���������� ������ � ��� ������, ���� �� ���� ������� "������" ����
    if not DM.CreateClearDatabase then
  		RunExchange([ eaImportOnly]);
		exit;
	end;

	{ ���� �������� ������� �� ���� ��������� }
	if DM.IsBackuped( ExePath) or
     DM.IsBackuped( ExePath + SDirIn + '\') or
     DM.NeedImportAfterRecovery
  then
	begin
		AProc.MessageBox( '���������� �������� ������� ������ �� ���� ���������', MB_ICONWARNING or MB_OK);
		if DM.IsBackuped( ExePath) then
		begin
			DM.MainConnection1.Close;
			DM.RestoreDatabase( ExePath);
			DM.MainConnection1.Open;
		end;
    //���������� ������ ���� ������ ��� �������� �� ������
    RunCompactDatabase;
		{ �������������� ������ }
    //���� ������ �� ������, �� ���� ����� ������ �� ������������
		if not RunExchange([ eaImportOnly])
    then
      Exit;
	end;

  //���� ��������� ���� "������ ������������ ����������", �� ������ ���
  //�� ����� ���� ��������� � ����������� ������� ��������� ��� � ���������� ������������ �������,
  //������� ��� ������� ����� �������� ����
  if DM.GetCumulative then
  begin
    WriteExchangeLog('AnalitF',
      '���������� �������� ������� ������ ���� ��������� � ���������� ����������� ������,' +
      '����� ����������� ������������ ����������.');
		RunExchange([eaGetPrice, eaGetFullData]);
    //� ����� ������ ����� �� ������� �� ������ ������, �.�. ���� ���������� � ��� ������,
    //���� ���������� �� ������� � ���� ����� ������ �� ������������
    Exit;
  end;

	if ExchangeOnly then exit;
	{ �� ����������� ������ 20 ����� }
	if ( HourSpan( DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime, Now) > 20) and
		( Trim( DM.adtParams.FieldByName( 'HTTPName').AsString) <> '') then
		if AProc.MessageBox( '�� ��������� � ���������� ������� ������. ��������� ����������?',
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
		if Controls[ i] is TChildForm then
      Controls[ i].Free;
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
var
  OldExep : TExceptionEvent;
begin
  OldExep := Application.OnException;
  try
    Application.OnException := OnAppEx;
  	ShowConfig;
  finally
    Application.OnException := OldExep;
  end;
end;

procedure TMainForm.actCompactExecute(Sender: TObject);
begin
	if AProc.MessageBox( '������ ���� ������ ���������� ���������� �������' + #13 +
		'� ������ ����������� ����������. ����������?', MB_ICONQUESTION or MB_OKCANCEL) <> IDOK then exit;
	FreeChildForms;
	Application.ProcessMessages;
  RunCompactDatabase;
	AProc.MessageBox( '������ ���� ������ ���������');
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
	DM.adsSelect.SelectSQL.Text := 'SELECT COUNT(*) AS CatNum FROM Catalogs';
	try
		DM.adsSelect.Open;
		CatNum := DM.adsSelect.FieldByName( 'CatNum').AsInteger;
	except
		CatNum := 0;
	end;
	DM.adsSelect.Close;

	{ ���� ������� ������, �� ���������� ����� ������������� ������������ }
	if CatNum = 0 then ExAct := ExAct + [eaGetFullData];

	RunExchange( ExAct);
end;

procedure TMainForm.actReceiveAllExecute(Sender: TObject);
begin
	if AProc.MessageBox( '������������ ���������� ���������� ���������� �������. ����������?',
		MB_ICONQUESTION or MB_OKCANCEL) = IDOK then
			RunExchange([eaGetPrice, eaGetFullData]);
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
	if AProc.MessageBox( '������������� �������� ����?',
		MB_ICONQUESTION or MB_OKCANCEL) <> IDOK then exit;
	FreeChildForms;
	Application.ProcessMessages;
	DM.ClearDatabase;
  DM.MainConnection1.DefaultTransaction.CommitRetaining;
	AProc.MessageBox( '������� ���� ���������');
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
var
  SaveGridFlag : Boolean;
  ParentForm : TForm;
  DBGirdName : String;
begin
  if ( Screen.ActiveControl <> nil) and
		 ( Screen.ActiveControl is TCustomDBGridEh) and ( ActiveChild <> nil)
  then begin
    SaveGridFlag := ((Screen.ActiveControl.Tag and DM.SaveGridMask) > 0);

    if not SaveGridFlag then
      Exit;
      
    ParentForm := GetParentForm(Screen.ActiveControl);
    if Assigned(ParentForm) then
      DBGirdName := ParentForm.Name + '.' + TCustomDBGridEh(Screen.ActiveControl).Name
    else
      DBGirdName := TCustomDBGridEh(Screen.ActiveControl).Name;
    AProc.LogCriticalError('SE.' + DBGirdName + ' : ' + BoolToStr(SaveGridFlag) );
    
    SaveGrid( TCustomDBGridEh( Screen.ActiveControl));
  end;
end;

procedure TMainForm.actSaveUpdate(Sender: TObject);
begin
	actSave.Enabled :=
  ( Screen.ActiveControl <> nil) and
		 ( Screen.ActiveControl is TCustomDBGridEh) and ( ActiveChild <> nil)
     and ((Screen.ActiveControl.Tag and DM.SaveGridMask) > 0);
end;

procedure TMainForm.SetOrdersInfo;
begin
	DM.adsSelect.Close;
	DM.adsSelect.SelectSQL.Text := 'SELECT * FROM ORDERSINFOMAIN(:ACLIENTID)';
	DM.adsSelect.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	DM.adsSelect.Open;
	try
		StatusBar.Panels[ 0].Text := Format( '������� : %d',
			 [ DM.adsSelect.FieldByName( 'OrdersCount').AsInteger]);
		StatusBar.Panels[ 1].Text := Format( '������� : %d',
			 [ DM.adsSelect.FieldByName( 'Positions').AsInteger]);
	finally
		DM.adsSelect.Close;
	end;
  StatusBar.Panels[ 2].Text := Format( '����� : %0.2f',	[DM.GetAllSumOrder]);
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
  if DM.MainConnection1.Connected then begin
    adsOrdersH.ParamByName( 'AClientId').Value :=
      DM.adtClients.FieldByName( 'ClientId').Value;
    adsOrdersH.ParamByName( 'AClosed').Value := False;
    adsOrdersH.ParamByName( 'ASend').Value := True;
    adsOrdersH.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
    try
      adsOrdersH.Open;
      if adsOrdersH.RecordCount > 0 then result := True;
    finally
      adsOrdersH.Close;
    end;
  end;
end;

procedure TMainForm.actSendOrdersUpdate(Sender: TObject);
begin
	actSendOrders.Enabled := CheckUnsendOrders;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	if not DM.MainConnection1.Connected then exit;

  if OldOrders then
    if (not DM.adtParams.FieldByName('CONFIRMDELETEOLDORDERS').AsBoolean) or
       ConfirmDeleteOldOrders
    then
      DeleteOldOrders;

	if CheckUnsendOrders then
	begin
		if AProc.MessageBox( '���������� �������������� ������. ' +
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

procedure TMainForm.lCurrentClientMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  try
  //���� ��� �����, �.�. ��������� ������ ������ � DBLookupComboBox ��� ����� �� ����� WebBrowser
	if not ToolBar.Focused and
    Assigned(ActiveControl) and
		not ActiveControl.Focused and
		not ActiveControl.ClassNameIs( 'TWebBrowser')
  then begin
    ToolBar.SetFocus;
  end;
  except
    on E : Exception do
      ShowMessage('Error : ' + E.Message);
  end;
end;

procedure TMainForm.edDummyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if Ord( Key) >= 32 then actOrderAll.Execute;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
	ExID: string;
begin
	if not DM.MainConnection1.Connected then exit;

  if not DM.MainConnection1.DefaultTransaction.Active then begin
    DM.MainConnection1.DefaultTransaction.StartTransaction;
    DM.MainConnection1.AfterConnect(nil);
  end;

	{ �������� �� ������ �� ����������� ������ }
	CS.Enter;
  try
    try
      DM.adtFlags.CloseOpen(True);
      ExID := DM.adtFlags.FieldByName( 'ExclusiveID').AsString;
    except
      ExID := '';
    end;
  finally
		CS.Leave;
  end;
	if ( ExID <> GetExclusiveID()) and ( ExID <> '') then
	begin
		ShowWait;
	end;
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

procedure TMainForm.DisableByHTTPName;
begin
  actSendOrders.Enabled := False;
  actOrderAll.Enabled := False;
  actSynonymSearch.Enabled := False;
  actSale.Enabled := False;
  actOrderPrice.Enabled := False;
  actOrderSummary.Enabled := False;
//  actRegistry.Enabled := False;
  actDefectives.Enabled := False;
  actClosedOrders.Enabled := False;
  actWayBill.Enabled := False;
end;

procedure TMainForm.EnableByHTTPName;
begin
  actSendOrders.Enabled := True;
  actOrderAll.Enabled := True;
  actSynonymSearch.Enabled := True;
  actSale.Enabled := True;
  actOrderPrice.Enabled := True;
  actOrderSummary.Enabled := True;
//  actRegistry.Enabled := True;
  actDefectives.Enabled := True;
  actClosedOrders.Enabled := True;
  actWayBill.Enabled := True;
end;

procedure TMainForm.OnAppEx(Sender: TObject; E: Exception);
begin
  if Assigned(Sender) then
    Tracer.TR('MainForm.OnAppEx', 'Sender = ' + Sender.ClassName)
  else
    Tracer.TR('MainForm.OnAppEx', 'Sender = nil');
  Tracer.TR('MainForm.OnAppEx', 'AppEx : ' + E.Message);
end;

procedure TMainForm.OnMainAppEx(Sender: TObject; E: Exception);
var
  S, Mess : String;
begin
  if SilentMode then begin
    if E.Message <> SCannotFocus then begin
      if Assigned(Sender) then
        Tracer.TR('MainForm.OnMainAppEx', 'Sender = ' + Sender.ClassName)
      else
        Tracer.TR('MainForm.OnMainAppEx', 'Sender = nil');
      Tracer.TR('MainForm.OnMainAppEx', 'OnMainAppEx : ' + E.Message);
      ExitProcess(100);
    end;
  end
  else begin
    if E.Message <> SCannotFocus then begin
      S := 'Sender = ' + Iif(Assigned(Sender), Sender.ClassName, 'nil');
      AProc.LogCriticalError(S + ' ' + E.Message);
      Mess := Format('� ��������� ��������� �������������� ������:'#13#10 +
        '%s'#13#10'%s'#13#10#13#10 +
        '��������� ������ ���������?', [S, E.Message]);
      if AProc.MessageBox(Mess, MB_ICONERROR or MB_YESNO or MB_DEFBUTTON2) = ID_YES then
        ExitProcess(100);
    end;
  end;
end;

function TMainForm.GetActionLists: TList;
begin
  Result := FActionLists;
end;

procedure TMainForm.SetActionLists(AValue: TList);
begin
  if AValue <> FActionLists then
    FActionLists := AValue;
end;

procedure TMainForm.actWayBillExecute(Sender: TObject);
begin
	RunExchange( [eaGetWaybills] );
end;

procedure TMainForm.actSynonymSearchExecute(Sender: TObject);
begin
	ShowSynonymSearch;
end;

function TMainForm.OldOrders: Boolean;
begin
	DM.adsSelect.Close;
	DM.adsSelect.SelectSQL.Text := 'SELECT * FROM ORDERSH where (Closed = 1) and (orderdate < :MinOrderDate)';
  DM.adsSelect.ParamByName('MinOrderDate').AsDateTime := Date - DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger;
	DM.adsSelect.Open;
	try
    Result := not DM.adsSelect.IsEmpty;
	finally
		DM.adsSelect.Close;
	end;
end;

procedure TMainForm.DeleteOldOrders;
begin
  DM.adcUpdate.Transaction.StartTransaction;
  try
    DM.adcUpdate.SQL.Text := 'delete FROM ORDERSH where (Closed = 1) and (orderdate < :MinOrderDate)';
    DM.adcUpdate.ParamByName('MinOrderDate').AsDateTime := Date - DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger;
    DM.adcUpdate.ExecQuery;
    DM.adcUpdate.Transaction.Commit;
  except
    DM.adcUpdate.Transaction.Rollback;
    raise;
  end;
end;

procedure TMainForm.actReceiveTicketsExecute(Sender: TObject);
begin
	RunExchange( [eaGetWaybills] );
end;

procedure TMainForm.actSendLetterExecute(Sender: TObject);
var
  Sended : Boolean;
begin
  frmSendLetter := TfrmSendLetter.Create(Application);
  try

    repeat
      if frmSendLetter.ShowModal = mrOk then
        Sended := RunExchange([eaSendLetter])
      else
        Sended := True;
    until Sended;

  finally
    frmSendLetter.Free;
  end;

end;

procedure TMainForm.actViewDocsExecute(Sender: TObject);
begin
	ShellExecute( 0, 'Open', PChar(ExePath + SDirDocs + '\'),
		nil, nil, SW_SHOWDEFAULT);
	ShellExecute( 0, 'Open', PChar(ExePath + SDirWaybills + '\'),
		nil, nil, SW_SHOWDEFAULT);
	ShellExecute( 0, 'Open', PChar(ExePath + SDirRejects + '\'),
		nil, nil, SW_SHOWDEFAULT);
end;

procedure TMainForm.FormResize(Sender: TObject);
var
  PaintBoxWidth, PanelWidth, NewWidth : Integer;
begin
  //����������� ������ �������������� � ����������� �� ������������ ������ ����� �������
  PaintBoxWidth :=
    MaxClientNameWidth {������������ ������ ������������ �������}
    + 30{�� ������ ����}
    + 12{�� ������ ��� ������ PopupMenu};

  //����������� ������ �������������� �� ������� ToolBar � ����� ���� ������
  PanelWidth := ToolBar.Width - 10 - ClientNameRect.Left;

  //���������� ����������� ��������
  if PaintBoxWidth < PanelWidth then
    NewWidth := PaintBoxWidth
  else
    NewWidth := PanelWidth;

  if NewWidth <> ClientNameRect.Right - ClientNameRect.Left then
  begin
    ClientNameRect.Right := ClientNameRect.Left + NewWidth;
    ToolBar.Invalidate;
  end;
end;

procedure TMainForm.OnSelectClientClick(Sender: TObject);
var
  mi : TMenuItem;
  I : Integer;
begin
  mi := TMenuItem(Sender);
  if not mi.Checked and (CurrentUser <> mi.Caption) then
  begin
    for I := 0 to pmClients.Items.Count - 1 do
      pmClients.Items[i].Checked := False;
    mi.Checked := True;
    DM.adtClients.Locate('ClientId', mi.Tag, []);
    DM.adtParams.Edit;
    DM.adtParams.FieldByName( 'ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
    DM.adtParams.Post;
		DM.ClientChanged;
    CurrentUser := mi.Caption;
    ToolBar.Invalidate;
  end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  ClientNameRect := Rect(tbLastSeparator.Left + tbLastSeparator.Width + 7, 15, 10, 15 + 21{������ ��������});
end;

procedure TMainForm.ToolBarAdvancedCustomDraw(Sender: TToolBar;
  const ARect: TRect; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  OldBkMode: integer;
  TmpRect : TRect;
begin
  if Stage = cdPrePaint then begin

    //������ �����
    OldBkMode := Windows.SetBkMode(ToolBar.Canvas.Handle, TRANSPARENT);
    ToolBar.Canvas.Font.Style := ToolBar.Canvas.Font.Style + [fsBold];
    ToolBar.Canvas.TextOut(ClientNameRect.Left, 0, '������� ������:');
    //TextRect �� ��������, �.�. ������ ��� ��� ��������
    //ToolBar.Canvas.TextRect(LabelRect, ClientNameRect.Left, 0, '������� ������:');
    Windows.SetBkMode(ToolBar.Canvas.Handle, OldBkMode);
    ToolBar.Canvas.Font.Style := ToolBar.Canvas.Font.Style - [fsBold];

    //������ ������� �� ���� � �������� �����
    ToolBar.Canvas.Brush.Color := clWhite;
    ToolBar.Canvas.Rectangle(ClientNameRect);
    //������ ��� �������
    TmpRect := ClientNameRect;
    TmpRect.BottomRight.X := TmpRect.BottomRight.X - 24;
    Windows.InflateRect(TmpRect, -1, -1);
    ToolBar.Canvas.TextRect(TmpRect, TmpRect.Left + 3, TmpRect.Top + 4, DM.adtClients.FieldByName('Name').AsString);

    //������ ������
    TmpRect := ClientNameRect;
    TmpRect.TopLeft.X := TmpRect.BottomRight.X - 21;
    Windows.InflateRect(TmpRect, -1, -1);
    ToolBar.Canvas.Brush.Color := clBtnFace;
    ToolBar.Canvas.Rectangle(TmpRect);
    //������ ����������� �� ������
    ToolBar.Canvas.MoveTo(TmpRect.TopLeft.X + 5, TmpRect.TopLeft.Y + 7);
    ToolBar.Canvas.LineTo(TmpRect.TopLeft.X + 13, TmpRect.TopLeft.Y + 7);
    ToolBar.Canvas.LineTo(TmpRect.TopLeft.X + 9, TmpRect.TopLeft.Y + 11);
    ToolBar.Canvas.LineTo(TmpRect.TopLeft.X + 5, TmpRect.TopLeft.Y + 7);
    ToolBar.Canvas.Brush.Color := ToolBar.Canvas.Pen.Color;
    ToolBar.Canvas.FloodFill(
      TmpRect.TopLeft.X + 9,
      TmpRect.TopLeft.Y + 8,
      ToolBar.Canvas.Pixels[TmpRect.TopLeft.X + 9, TmpRect.TopLeft.Y + 8],
      fsSurface);

  end;
end;

procedure TMainForm.ToolBarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  ResultRect : TRect;
begin
  if Windows.IntersectRect(ResultRect, ClientNameRect, Rect(X, Y, X+1, Y+1))
  then begin
    if Length(ToolBar.Hint) = 0 then
      ToolBar.Hint := '������: ' + DM.adtClients.FieldByName( 'Name').AsString;
  end
  else
    if Length(ToolBar.Hint) > 0 then
      ToolBar.Hint := '';
end;

procedure TMainForm.ToolBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ResultRect : TRect;
  ScreenPoint : TPoint;
begin
  if (Button = mbLeft) and (Windows.IntersectRect(ResultRect, ClientNameRect, Rect(X, Y, X+1, Y+1))) then
  begin
    ScreenPoint := ToolBar.ClientToScreen(Point(ClientNameRect.Left, ClientNameRect.Bottom));
    pmClients.Popup(ScreenPoint.X, ScreenPoint.Y);
  end;
end;

end.

