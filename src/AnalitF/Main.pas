unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ExtCtrls, DBCtrls, DB, Child, Placemnt,
  ActnList, ImgList, ToolWin, StdCtrls, XPMan, ActnMan, ActnCtrls,
  XPStyleActnCtrls, ActnMenus, DBGridEh, DateUtils, ToughDBGrid,
  OleCtrls, SHDocVw, AppEvnts, SyncObjs, Consts, ShellAPI,
  MemDS, DBAccess, MyAccess, U_VistaCorrectForm, Contnrs;

type

TMainForm = class(TVistaCorrectForm)
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
    itmClosedOrders: TMenuItem;
    itmExpireds: TMenuItem;
    btnClosedOrders: TToolButton;
    btnDefectives: TToolButton;
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
    actClosedOrders: TAction;
    actExit: TAction;
    actSave: TAction;
    actCloseAll: TAction;
    actReceiveAll: TAction;
    N3: TMenuItem;
    actPreview: TAction;
    N4: TMenuItem;
    actFind: TAction;
    tbFind: TToolButton;
    Browser: TWebBrowser;
    AppEvents: TApplicationEvents;
    ImageList: TImageList;
    itmAbout: TMenuItem;
    btnHome: TToolButton;
    actHome: TAction;
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
    adsOrdersHead: TMyQuery;
    tbMnnSearch: TToolButton;
    actMnnSearch: TAction;
    actRestoreDatabase: TAction;
    itmRestoreDatabase: TMenuItem;
    procedure imgLogoDblClick(Sender: TObject);
    procedure actConfigExecute(Sender: TObject);
    procedure actCompactExecute(Sender: TObject);
    procedure actOrderAllExecute(Sender: TObject);
    procedure actOrderPriceExecute(Sender: TObject);
    procedure actOrderSummaryExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actPrintUpdate(Sender: TObject);
    procedure actRegistryExecute(Sender: TObject);
    procedure actDefectivesExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actClosedOrdersExecute(Sender: TObject);
    procedure actSaleExecute(Sender: TObject);
    procedure actReceiveExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
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
    procedure AppEventsIdle(Sender: TObject; var Done: Boolean);
    procedure actHomeExecute(Sender: TObject);
    procedure actHomeUpdate(Sender: TObject);
    procedure itmAboutClick(Sender: TObject);
    procedure actWayBillExecute(Sender: TObject);
    procedure actSynonymSearchExecute(Sender: TObject);
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
    procedure AppEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure actMnnSearchExecute(Sender: TObject);
    procedure actSendWaybillsExecute(Sender: TObject);
    procedure actRestoreDatabaseExecute(Sender: TObject);
private
	JustRun: boolean;
  ApplicationVersionText : String;
  deletedForms : TObjectList;

	procedure SetStatusText(Value: string);
  procedure OnAppEx(Sender: TObject; E: Exception);
  procedure OnMainAppEx(Sender: TObject; E: Exception);
  function  GetActionLists : TList;
  procedure SetActionLists(AValue : TList);
  function  OldOrders : Boolean;
  procedure DeleteOldOrders;
  procedure RealFreeChildForms;
public
  // ��� �������� ������������
  CurrentUser    : string;
  //���������� �� ������� ����� �������� �� ����� Future
  IsFutureClient : Boolean;
	ActiveChild: TChildForm;
	ExchangeOnly: boolean;

	RegionFilterIndex: integer;
	EnableFilterIndex: integer;
//	Filter

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
  procedure AddFormsToFree;
  procedure AddFormToFree(childForm : TChildForm);
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
	Exchange, Expireds, Core, UniqueID, CoreFirm,
	AlphaUtils, About, CompactThread, LU_Tracer,
  SynonymSearch, U_frmOldOrdersDelete, U_frmSendLetter, Types, U_ExchangeLog,
  Variants, ExchangeParameters, CorrectOrders, DatabaseObjects,
  MnnSearch, DocumentHeaders, DBGridHelper, DocumentTypes;

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
  deletedForms := TObjectList.Create(False);
  FormPlacement.Active := False;
  Application.OnException := OnMainAppEx;
	ExchangeOnly := False;
	Caption := Application.Title;
  ApplicationVersionText := '(������ ' + GetLibraryVersionFromPath(Application.ExeName) + ')      ';
	StatusBar.Panels[StatusBar.Panels.Count-1].Text := ApplicationVersionText;
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
	if Set32BPP then
    LoadToImageList(ImageList, Application.ExeName, 100);
end;

procedure TMainForm.AppEventsIdle(Sender: TObject; var Done: Boolean);
var
  I : Integer;
begin
  //�������� ��� ��� ����, ����� ��������� ��������� pbSelectClient ����� ����������,
  //��-�� ���� ����� ���������� ������ ��������
  FormResize(nil);

  //������� �����, ���������� ��� ���������
  RealFreeChildForms;

	if not JustRun then exit;
  //������ ������ � ��� ������, ���� ���������� ������ ���� ������
  if not Active then exit;
	JustRun := False;

try
  //���������� ��������������
  FormPlacement.Active := True;
  Self.WindowState := wsMaximized;

	UpdateReclame;
  //todo: ClientId-UserId
  DM.GetClientInformation(CurrentUser, IsFutureClient);
  if (Length(CurrentUser) > 0) then
    Self.Caption := Application.Title + ' - ' + CurrentUser
  else
    Self.Caption := Application.Title;


  // ����� ������
	if Trim( DM.adtParams.FieldByName( 'HTTPName').AsString) = '' then
	begin
		AProc.MessageBox( '��� ������ ������ � ���������� ���������� ��������� ������� ������',
			MB_ICONWARNING or MB_OK);
		ShowConfig( True);
	end;

  // ���� ��������� ��������� � �������� renew, �� ��������� ��� �������� ����� ������������
  if FindCmdLineSwitch('renew') then
  begin
    for I := 0 to ActionList.ActionCount-1 do
      if ActionList.Actions[i] <> actConfig then
        TAction(ActionList.Actions[i]).Enabled := False;
    itmSystem.Enabled := False;
    Exit;
  end;

  // ������ � ������ -i (������ ������) ��� ��������� ����� ������ ���������}
  if FindCmdLineSwitch('i') then
  begin
    //���������� ������ � ��� ������, ���� �� ���� ������� "������" ����,
    //�� ���� ���������� �� ������ UIN � �� ���� ���������� �� ������ ����� ���������
    if
      (
        not DM.CreateClearDatabase
          //������ ��� ������ � ������ ���������� Firebird �� Mysql
        or DM.ProcessFirebirdUpdate
          //������ ��� ������ � ������ ���������� 800x �� ������ 945
        or DM.Process800xUpdate
          //������ ��� ������ � ������ ���������� libmysqld �� ����� ������
        or DM.ProcessUpdateToNewLibMysqlD
      )
      and not DM.NeedUpdateByCheckUIN
      and not DM.NeedUpdateByCheckHashes
    then begin
      if DM.ProcessUpdateToNewLibMysqlD and DM.NeedCumulativeAfterUpdateToNewLibMySqlD
      then begin
        AProc.MessageBox(
          '� ���������� ���������� ���� ������ ��������� ������ ���� �������� � ���������� ������� ������������ ����������.',
          MB_ICONWARNING or MB_OK);
        RunExchange([eaGetPrice, eaGetFullData]);
      end
      else
        RunExchange([ eaImportOnly]);
    end;
    exit;
  end;

  // ���� �������� ������� �� ���� ��������� }
	if DatabaseController.IsBackuped or
     DM.NeedImportAfterRecovery
  then
	begin
		AProc.MessageBox( '���������� �������� ������� ������ �� ���� ���������', MB_ICONWARNING or MB_OK);
    if DatabaseController.IsBackuped then
      DatabaseController.RestoreDatabase;

    //���������� ������ ���� ������ ��� �������� �� ������
    RunCompactDatabase;

  // �������������� ������ }
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
  // ��������� ������ ��� ����������� ��� �� ����������� ������ 20 ����� }
  if (DM.adtParams.FieldByName( 'UpdateDateTime').IsNull and (Trim( DM.adtParams.FieldByName( 'HTTPName').AsString) <> ''))
  then begin
    if AProc.MessageBox( '���� ������ ��������� �� ���������. ��������� ����������?',
       MB_ICONQUESTION or MB_YESNO) = IDYES
    then
      actReceiveExecute( nil);
  end
  else
    if ( HourSpan( DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime, Now) > 20) and
      ( Trim( DM.adtParams.FieldByName( 'HTTPName').AsString) <> '') then
      if AProc.MessageBox( '�� ��������� � ���������� ������� ������. ��������� ����������?',
         MB_ICONQUESTION or MB_YESNO) = IDYES
      then
        actReceiveExecute( nil);

finally
  try
  //������� ���������� ����� �� �����, �.�. �� ������ �� ����������
  Self.SetFocus;
  except
  end;
  //��������� ToolBar � ������ ����� ������� ����� ����������
  ToolBar.Invalidate;
end;
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
  //todo: ClientId-UserId
  if (Length(CurrentUser) > 0) then
    Self.Caption := Application.Title + ' - ' + CurrentUser
  else
    Self.Caption := Application.Title;
	SetOrdersInfo;
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
	if AProc.MessageBox( '������ ���� ������ ���������� ���������� �������.'#13#10'����������?', MB_ICONQUESTION or MB_OKCANCEL) <> IDOK
  then
    Exit;
  //��������� ��� ���� ����� ������� ���� ������
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
  ShowChildForm( TRegistersForm );
end;

procedure TMainForm.actDefectivesExecute(Sender: TObject);
begin
  ShowChildForm( TDefectivesForm );
end;

{ �������� ���������� ������ FormClass - ���������� TChildForm }
function TMainForm.ShowChildForm( FormClass: TChildFormClass): TChildForm;
begin
  try
    //������� ��� ������������ ����� � ������� ����� �����
    //���� ����� ��������, ��� ��������� ����� ��� ��������� �����
    AddFormsToFree;
    Result := FormClass.Create(Application);
{
    result := TChildForm( FindChildControlByClass( Self, FormClass));
    if result = nil then
    begin
      //���� � ��������� ShowChildForm, �� ���� ����� �� �����
      AddFormsToFree;
      Result := FormClass.Create(Application);
    end
    else result.Show;
}    
  except
    FreeChildForms;
    raise;
  end;
end;

procedure TMainForm.actClosedOrdersExecute( Sender: TObject);
begin
	if ActiveChild is TCoreForm then
	begin
		TCoreForm(ActiveChild).ShowOrdersH;
	end
	else
	begin
    //���� � ��������� ShowChildForm, �� ���� ����� �� ����� 
    FreeChildForms;
		ShowOrdersH;
	end;
end;

procedure TMainForm.actSaleExecute(Sender: TObject);
begin
  ShowChildForm( TExpiredsForm );
end;

procedure TMainForm.actReceiveExecute(Sender: TObject);
var
	CatNum: integer;
	ExAct: TExchangeActions;
begin
	ExAct := [ eaGetPrice];

	{ ��������� ������� �� ������� ������� }
	try
		CatNum := DM.QueryValue('SELECT COUNT(*) AS CatNum FROM Catalogs', [], []);
	except
		CatNum := 0;
	end;

	{ ���� ������� ������, �� ���������� ����� ������������� ������������ }
	if CatNum = 0 then ExAct := ExAct + [eaGetFullData];

	RunExchange( ExAct);

  //��������� ToolBar � ������ ����� ������� ����� ����������
  ToolBar.Invalidate;
end;

procedure TMainForm.actReceiveAllExecute(Sender: TObject);
begin
	if AProc.MessageBox( '������������ ���������� ���������� ���������� �������. ����������?',
		MB_ICONQUESTION or MB_OKCANCEL) = IDOK
  then begin
    RunExchange([eaGetPrice, eaGetFullData]);

    //��������� ToolBar � ������ ����� ������� ����� ����������
    ToolBar.Invalidate;
  end;
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
	Close;
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
  //����� �������� ���� ������ ��������� ��� ����
  FreeChildForms;
	Application.ProcessMessages;
	DM.ClearDatabase;
	AProc.MessageBox( '������� ���� ���������');
end;

procedure TMainForm.itmImportClick(Sender: TObject);
begin
	RunExchange([ eaImportOnly]);
  //��������� ToolBar � ������ ����� ������� ����� ����������
  ToolBar.Invalidate;
end;

procedure TMainForm.SetUpdateDateTime;
begin
  if DM.adtParams.FieldByName( 'UpdateDateTime').IsNull then
    StatusBar.Panels[ 3].Text := '���������� �� �����������'
  else
    StatusBar.Panels[ 3].Text := '���������� : ' +
      DateTimeToStr( UTCToLocalTime(
        DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime));
  StatusBar.Panels[3].Width :=
    StatusBar.Canvas.TextWidth(StatusBar.Panels[3].Text) + 15;
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
    
    TDBGridHelper.SaveGrid( TCustomDBGridEh( Screen.ActiveControl ) );
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
var
  UserId : Variant;
  I : Integer;
  IdTextWidth,
  NeedWidth,
  AllWidth : Integer;

begin
try
  if DM.MainConnection.Connected then begin
    UserId := DM.QueryValue('select UserId from UserInfo', [], []);
    if VarIsNull(UserId) then
      StatusBar.Panels[StatusBar.Panels.Count-1].Text := '�� : �� ����������  '
        + ApplicationVersionText
    else
      StatusBar.Panels[StatusBar.Panels.Count-1].Text := '�� : ' + VarToStr(UserId) + '  '
        + ApplicationVersionText;
    IdTextWidth := StatusBar.Canvas.TextWidth(StatusBar.Panels[StatusBar.Panels.Count-1].Text) + 15;
    if DM.adsQueryValue.Active then
      DM.adsQueryValue.Close;
    DM.adsQueryValue.SQL.Text := ''
  +'SELECT '
  +'       COUNT(DISTINCT CurrentOrderHeads.orderid) AS OrdersCount, '
  +'       COUNT(osbc.id)                     AS Positions  , '
  +'       ifnull(SUM(osbc.price * osbc.OrderCount), 0) SumOrder, '
  +'  ( '
  +'    select '
  +'      ifnull(Sum(PostedOrderLists.Price * PostedOrderLists.OrderCount), 0) '
  +'    from '
  +'      PostedOrderHeads '
  +'      INNER JOIN PostedOrderLists ON PostedOrderLists.OrderId=PostedOrderHeads.OrderId '
  +'    WHERE PostedOrderHeads.ClientId = :ClientId '
  +'       and PostedOrderHeads.senddate > curdate() + interval (1-day(curdate())) day '
  +'       AND PostedOrderHeads.Closed = 1 '
  +'       AND PostedOrderHeads.send = 1 '
  +'       AND PostedOrderLists.OrderCount>0 '
  +'  ) as sumbycurrentmonth, '
  +'  ( '
  +'    select '
  +'      ifnull(Sum(PostedOrderLists.Price * PostedOrderLists.OrderCount), 0) '
  +'    from '
  +'      PostedOrderHeads '
  +'      INNER JOIN PostedOrderLists ON PostedOrderLists.OrderId=PostedOrderHeads.OrderId '
  +'    WHERE PostedOrderHeads.ClientId = :ClientId '
  +'       and PostedOrderHeads.senddate > curdate() + interval (-WEEKDAY(curdate())) day '
  +'       AND PostedOrderHeads.Closed = 1 '
  +'       AND PostedOrderHeads.send = 1 '
  +'       AND PostedOrderLists.OrderCount>0 '
  +'  ) as sumbycurrentweek '
  +'FROM '
  +'       CurrentOrderHeads '
  +'       INNER JOIN CurrentOrderLists osbc       ON (CurrentOrderHeads.orderid  = osbc.OrderId) AND (osbc.OrderCount > 0) '
  +'       LEFT JOIN PricesRegionalData PRD ON (PRD.RegionCode      = CurrentOrderHeads.RegionCode) AND (PRD.PriceCode = CurrentOrderHeads.PriceCode) '
  +'       LEFT JOIN PricesData             ON (PricesData.PriceCode=PRD.PriceCode) '
  +'WHERE (CurrentOrderHeads.CLIENTID                                      = :ClientID) '
  +'   AND (CurrentOrderHeads.Closed                                      <> 1)';

    DM.adsQueryValue.ParamByName( 'ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
    DM.adsQueryValue.Open;
    try
      StatusBar.Panels[ 0].Text := Format( '������� : %d',
         [ DM.adsQueryValue.FieldByName( 'OrdersCount').AsInteger]);
      StatusBar.Panels[ 1].Text := Format( '������� : %d',
         [ DM.adsQueryValue.FieldByName( 'Positions').AsInteger]);
      StatusBar.Panels[ 2].Text := Format( '����� : %0.2f',
         [ DM.adsQueryValue.FieldByName( 'SumOrder').AsCurrency ]);
      StatusBar.Panels[ 4].Text := Format( '�� ����� : %0.2f',
         [ DM.adsQueryValue.FieldByName( 'sumbycurrentmonth').AsCurrency ]);
      StatusBar.Panels[ 5].Text := Format( '�� ������ : %0.2f',
         [ DM.adsQueryValue.FieldByName( 'sumbycurrentweek').AsCurrency ]);
      for I := 0 to StatusBar.Panels.Count-2 do
        StatusBar.Panels[i].Width :=
          StatusBar.Canvas.TextWidth(StatusBar.Panels[i].Text) + 15;
      AllWidth := 0;
      for I := 0 to StatusBar.Panels.Count-2 do
        AllWidth := AllWidth + StatusBar.Panels[i].Width;
      NeedWidth := StatusBar.Width - IdTextWidth;
      I := StatusBar.Panels.Count-2;
      while (NeedWidth < AllWidth) and (I >= 0) do begin
        AllWidth := AllWidth - StatusBar.Panels[i].Width;
        StatusBar.Panels[i].Width := 0;
        I := I - 1;
      end;
    finally
      DM.adsQueryValue.Close;
    end;
  end;
except
  on E : Exception do
    WriteExchangeLog('SetOrdersInfo', '������ : ' + E.Message);
end;
end;

procedure TMainForm.actCloseAllExecute(Sender: TObject);
begin
  //��������� ��� ���� �� ���������� ������������
  //���� ��������� ����������� ������ "�����", ��������� �����
  FreeChildForms;
end;

procedure TMainForm.actSendOrdersExecute(Sender: TObject);
var
  correctResult : TCorrectResult;
begin
  if DM.adtParams.FieldByName('ConfirmSendingOrders').AsBoolean then
    if AProc.MessageBox( '�� ������������� ������ ��������� ������?',
       MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = IDNO
    then
      Exit;

  RunExchange([eaSendOrders]);
  if NeedRetrySendOrder then begin
    correctResult := ShowCorrectOrders(True);
    case correctResult of
      crForceSended :
        RunExchange([eaSendOrders, eaForceSendOrders]);
      crGetPrice :
        RunExchange([eaGetPrice]);
      crEditOrders :
        ShowSummary;
    end;
  end;
  //��������� ToolBar � ������ ����� ������� ����� ����������
  ToolBar.Invalidate;
end;

function TMainForm.CheckUnsendOrders: boolean;
begin
	result := False;
  if not Assigned(GlobalExchangeParams) and DM.MainConnection.Connected then begin
    adsOrdersHead.Connection := DM.MainConnection;
    adsOrdersHead.ParamByName( 'ClientId').Value :=
      DM.adtClients.FieldByName( 'ClientId').Value;
    adsOrdersHead.ParamByName( 'Closed').Value := False;
    adsOrdersHead.ParamByName( 'Send').Value := True;
    try
      adsOrdersHead.Open;
      if adsOrdersHead.RecordCount > 0 then result := True;
    finally
      adsOrdersHead.Close;
    end;
  end;
end;

procedure TMainForm.actSendOrdersUpdate(Sender: TObject);
begin
	actSendOrders.Enabled := CheckUnsendOrders;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {
    ��������� ������� � ����������� #1845 ������ ��� �������� ���������,
    ��������� � adsRetailMargins: "adsRetailMargins: Cannot perform this
    operation on a closed dataset"
    ���� �� ������ ����������� � ���� �� ���������� ������� �����, � ����������
    ����� ������������, �� �� ��������� ���������
  }
  if JustRun then begin
    CanClose := False;
    Exit;
  end;
  {
    ��������� ������� � ����������� #1845 ������ ��� �������� ���������,
    ��������� � adsRetailMargins: "adsRetailMargins: Cannot perform this
    operation on a closed dataset"
    ������� ��������� ��� �������� �����, ����� � ��� ��������� Destroy �
    ��� ��������� ���������� �������� � ��������� ��������� � ���� 
  }
  FreeChildForms;
  if not DM.MainConnection.Connected then exit;

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
var
  openFileName : String;
begin
  if DM.adsUser.FieldByName('ShowAdvertising').IsNull or DM.adsUser.FieldByName('ShowAdvertising').AsBoolean
  then begin
    openFileName := ExePath + SDirReclame + '\' + FormatFloat('00', Browser.Tag) + '.htm';
    if SysUtils.FileExists( openFileName ) then
    try
      Browser.Navigate( openFileName );
    except
      on E : Exception do
        LogCriticalError(
          '������ ��� �������� ����� � WebBrowser� � MainForm: ' + E.Message + #13#10 +
          '��������� ������: ' + SysErrorMessage(GetLastError()));
    end;
  end
  else begin
    try
      Browser.Navigate( 'about:blank' );
    except
      on E : Exception do
        LogCriticalError(
          '������ ��� �������� ������ �������� � WebBrowser� � MainForm: ' + E.Message + #13#10 +
          '��������� ������: ' + SysErrorMessage(GetLastError()));
    end;
    DeleteFilesByMask(ExePath + SDirReclame + '\*.*', False);
  end;
end;

procedure TMainForm.actHomeExecute(Sender: TObject);
begin
  //���������� "������" ������� ����, ������� ��������� ��� �������� ����� 
  MainForm.FreeChildForms;
  UpdateReclame;
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
  actMnnSearch.Enabled := False;
  actWayBill.Enabled := False;
  actViewDocs.Enabled := False;
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
  actMnnSearch.Enabled := True;
  actWayBill.Enabled := True;
  actViewDocs.Enabled := True;
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
	RunExchange( [eaSendWaybills] );

  //��������� ToolBar � ������ ����� ������� ����� ����������
  ToolBar.Invalidate;
end;

procedure TMainForm.actSynonymSearchExecute(Sender: TObject);
begin
	ShowSynonymSearch;
end;

function TMainForm.OldOrders: Boolean;
begin
  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text := 'SELECT * FROM PostedOrderHeads where (Closed = 1) and (orderdate < :MinOrderDate)';
  DM.adsQueryValue.ParamByName('MinOrderDate').AsDateTime := Date - DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger;
  DM.adsQueryValue.Open;
  try
    Result := not DM.adsQueryValue.IsEmpty;
  finally
    DM.adsQueryValue.Close;
  end;
  if not Result then begin
    DM.adsQueryValue.SQL.Text := 'SELECT * FROM DocumentHeaders where (LoadTime < :MinOrderDate)';
    DM.adsQueryValue.ParamByName('MinOrderDate').AsDateTime := Date - DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger;
    DM.adsQueryValue.Open;
    try
      Result := not DM.adsQueryValue.IsEmpty;
    finally
      DM.adsQueryValue.Close;
    end;
  end;
end;

procedure TMainForm.DeleteOldOrders;
var
  documentType : TDocumentType;
  downloadId : String;
begin
  try
    DM.adcUpdate.SQL.Text := ''
     + ' delete PostedOrderHeads, PostedOrderLists'
     + ' FROM PostedOrderHeads, PostedOrderLists '
     + ' where '
     + '    (Closed = 1)'
     + ' and (PostedOrderLists.OrderId = PostedOrderHeads.OrderId)'
     + ' and (orderdate < :MinOrderDate)';
    DM.adcUpdate.ParamByName('MinOrderDate').AsDateTime := Date - DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger;
    DM.adcUpdate.Execute;
  except
    on E : Exception do
      LogCriticalError('������ ��� �������� ���������� ������� : ' + E.Message);
  end;
  try
    if DM.adsQueryValue.Active then
      DM.adsQueryValue.Close;
    DM.adsQueryValue.SQL.Text := 'SELECT * FROM DocumentHeaders where (LoadTime < :MinOrderDate)';
    DM.adsQueryValue.ParamByName('MinOrderDate').AsDateTime := Date - DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger;
    DM.adsQueryValue.Open;
    try
      while not DM.adsQueryValue.Eof do begin
        documentType := TDocumentType(DM.adsQueryValue.FieldByName('DocumentType').AsInteger);
        downloadId := DM.adsQueryValue.FieldByName('DownloadId').AsString;
        if (documentType <> dtUnknown) and (Length(downloadId) > 0) then
        try
          DeleteFilesByMask(
            ExePath + DocumentFolders[documentType] + '\' + downloadId + '_*.*',
            True);
        except
          on DeleteFile : Exception do
            LogCriticalError('������ ��� ����� ����������� ��������� ' + downloadId + ' : ' + DeleteFile.Message);
        end;
        DM.adsQueryValue.Next;
      end;
    finally
      DM.adsQueryValue.Close;
    end;
    //�������� ��������� � �������
    DM.adcUpdate.SQL.Text := ''
     + ' delete DocumentHeaders, DocumentBodies'
     + ' FROM DocumentHeaders, DocumentBodies '
     + ' where '
     + '     (DocumentBodies.DocumentId = DocumentHeaders.Id) '
     + ' and (LoadTime < :MinOrderDate)';
    DM.adcUpdate.ParamByName('MinOrderDate').AsDateTime := Date - DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger;
    DM.adcUpdate.Execute;
    //�������� ������ ����������, � ������� �� ���������� ���� (������� ������)
    DM.adcUpdate.SQL.Text := ''
     + ' delete '
     + ' FROM DocumentHeaders '
     + ' where '
     + '    (LoadTime < :MinOrderDate)';
    DM.adcUpdate.ParamByName('MinOrderDate').AsDateTime := Date - DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger;
    DM.adcUpdate.Execute;
  except
    on E : Exception do
      LogCriticalError('������ ��� �������� ���������� ���������� : ' + E.Message);
  end;
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

  //��������� ToolBar � ������ ����� ������� ����� ����������
  ToolBar.Invalidate;
end;

procedure TMainForm.actViewDocsExecute(Sender: TObject);
begin
  if not DM.adsUser.IsEmpty and DM.adsUser.FieldByName('ParseWaybills').AsBoolean
  then
    ShowDocumentHeaders
  else begin
    ShellExecute( 0, 'Open', PChar(ExePath + SDirDocs + '\'),
      nil, nil, SW_SHOWDEFAULT);
    ShellExecute( 0, 'Open', PChar(ExePath + SDirWaybills + '\'),
      nil, nil, SW_SHOWDEFAULT);
    ShellExecute( 0, 'Open', PChar(ExePath + SDirRejects + '\'),
      nil, nil, SW_SHOWDEFAULT);
  end;
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
  if not JustRun and Self.Active and Self.Visible and (Screen.ActiveForm = Self)
    and not Assigned(GlobalExchangeParams)
  then
    SetOrdersInfo;
end;

procedure TMainForm.OnSelectClientClick(Sender: TObject);
var
  mi : TMenuItem;
  I : Integer;
begin
  //todo: ClientId-UserId
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
    if not IsFutureClient then begin
      CurrentUser := mi.Caption;
      if (Assigned(ActiveChild) and (Length(ActiveChild.Caption) > 0)) then
        Self.Caption := Application.Title + ' - ' + CurrentUser + ' - ' + ActiveChild.Caption
      else
        Self.Caption := Application.Title + ' - ' + CurrentUser;
    end;
    ToolBar.Invalidate;
  end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  ClientNameRect := Rect(tbLastSeparator.Left + tbLastSeparator.Width + 7, 15, 10, 15 + 21{������ ��������});
end;

procedure TMainForm.ToolBarAdvancedCustomDraw(Sender: TToolBar;
  const ARect: TRect; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
const
  LabelCaption : array[Boolean] of String =
    ('������� ������:', '����� ������:');
var
  TmpRect : TRect;
  OldStyle : TBrushStyle;
  LabelRect : TRect;
  LabelWidth : Integer;
begin
  if Stage = cdPrePaint then begin

    //������ �����
    //��������� ���������� ����� �����, ����� ����� ��� ������������
    OldStyle := ToolBar.Canvas.Brush.Style;
    //���������� ����� ����� bsClear, ����� ��� ��������� ������� ��� ���������� ���
    ToolBar.Canvas.Brush.Style := bsClear;
    ToolBar.Canvas.Font.Style := ToolBar.Canvas.Font.Style + [fsBold];
    LabelWidth := ToolBar.Canvas.TextWidth(LabelCaption[IsFutureClient]);
    if ClientNameRect.Left + LabelWidth > ToolBar.Width then
      LabelWidth := ToolBar.Width - ClientNameRect.Left - 5;
    //���������� ������������� ��� ������� � ���������� ���������
    LabelRect := Rect(ClientNameRect.Left, 0, ClientNameRect.Left + LabelWidth, 13);
    ToolBar.Canvas.TextRect(LabelRect, ClientNameRect.Left, 0, LabelCaption[IsFutureClient]);
    //��������������� ����� ����� � ����� ������
    ToolBar.Canvas.Brush.Style := OldStyle;
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

procedure TMainForm.AppEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if     Self.Active
     and not Assigned(ActiveChild)
     and (not Assigned(ActiveControl) or (ActiveControl = Browser))
     and (Msg.Message = WM_KEYDOWN)
     and (Ord(Msg.wParam) = 32)
  then
  begin
    actOrderAll.Execute;
    Handled:=true;
  end;
end;

procedure TMainForm.actMnnSearchExecute(Sender: TObject);
begin
  ShowMnnSearch;
end;

procedure TMainForm.AddFormsToFree;
var
  i: Integer;
begin
  for i := ControlCount - 1 downto 0 do
    if Controls[i] is TChildForm then
      if deletedForms.IndexOf(Controls[i]) = -1 then begin
        deletedForms.Add(Controls[i]);
        Controls[i].Parent := nil;
      end;
  ActiveChild := nil;
  //todo: ClientId-UserId
  if (Length(CurrentUser) > 0) then
    Self.Caption := Application.Title + ' - ' + CurrentUser
  else
    Self.Caption := Application.Title;
  SetOrdersInfo;
end;

procedure TMainForm.RealFreeChildForms;
var
  i: Integer;
begin
  for i := deletedForms.Count - 1 downto 0 do begin
    deletedForms[i].Free;
    deletedForms.Delete(i);
  end;
end;

procedure TMainForm.AddFormToFree(childForm: TChildForm);
begin
  if deletedForms.IndexOf(childForm) = -1 then begin
    deletedForms.Add(childForm);
    childForm.Parent := nil;
  end
end;

procedure TMainForm.actSendWaybillsExecute(Sender: TObject);
begin
  RunExchange([eaSendWaybills]);
end;

procedure TMainForm.actRestoreDatabaseExecute(Sender: TObject);
begin
  //��������� ��� ���� ����� ������� ���� ������
  FreeChildForms;
  Application.ProcessMessages;
  if not RunRestoreDatabase then begin
    if AProc.MessageBox(
        '�������������� ���� ������ ���������.'#13#10
        +'� ���������� �������������� ��������� ������ ����� ���� �������� � ���������� ������� ������������ ����������.'#13#10
        +'��������� ������������ ����������?', MB_ICONWARNING or MB_OKCANCEL) = IDOK
    then
      RunExchange([eaGetPrice, eaGetFullData]);
  end
  else
    AProc.MessageBox('�������������� ���� ������ ��������� �������.');
end;

end.

