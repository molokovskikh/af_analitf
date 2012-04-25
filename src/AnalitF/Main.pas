unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ExtCtrls, DBCtrls, DB, Child, Placemnt,
  ActnList, ImgList, ToolWin, StdCtrls, XPMan, ActnMan, ActnCtrls,
  XPStyleActnCtrls, ActnMenus, DBGridEh, DateUtils, ToughDBGrid,
  OleCtrls, AppEvnts, SyncObjs, Consts, ShellAPI,
  MemDS, DBAccess, MyAccess, U_VistaCorrectForm, Contnrs,
  DayOfWeekDelaysController,
  SQLWaiting,
  U_SchedulesController,
  UserActions,
  GlobalSettingParams,
  StrUtils,
  U_MiniMailForm,
  HtmlView,
  VistaAltFixUnit;

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
    AppEvents: TApplicationEvents;
    ImageList: TImageList;
    itmAbout: TMenuItem;
    btnHome: TToolButton;
    actHome: TAction;
    tbWaybill: TToolButton;
    actWayBill: TAction;
    tbLastSeparator: TToolButton;
    tbSynonymSearch: TToolButton;
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
    actRestoreDatabaseFromEtalon: TAction;
    itmRestoreDatabaseFromEtalon: TMenuItem;
    miOrderBatch: TMenuItem;
    btnPostOrderBatch: TToolButton;
    actPostOrderBatch: TAction;
    tmrRestoreOnError: TTimer;
    actGetHistoryOrders: TAction;
    miGetHistoryOrders: TMenuItem;
    tmrOnExclusive: TTimer;
    actShowMinPrices: TAction;
    btnShowMinPrices: TToolButton;
    actServiceLog: TAction;
    itmServiceLog: TMenuItem;
    SearchMenu: TPopupMenu;
    miOrderAll: TMenuItem;
    miSynonymSearch: TMenuItem;
    miMnnSearch: TMenuItem;
    miShowMinPrices: TMenuItem;
    JunkMenu: TPopupMenu;
    miSale: TMenuItem;
    miDefectives: TMenuItem;
    WaybillMenu: TPopupMenu;
    ConfigMenu: TPopupMenu;
    miViewDocs: TMenuItem;
    miWayBill: TMenuItem;
    miConfig: TMenuItem;
    miHome: TMenuItem;
    tmrOnNeedUpdate: TTimer;
    tmrNeedUpdateCheck: TTimer;
    actMiniMail: TAction;
    itmMiniMail: TMenuItem;
    miMiniMailFromDocs: TMenuItem;
    HTMLViewer: THTMLViewer;
    pStartUp: TPanel;
    tmrStartUp: TTimer;
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
    procedure actRestoreDatabaseFromEtalonExecute(Sender: TObject);
    procedure actPostOrderBatchExecute(Sender: TObject);
    procedure tmrRestoreOnErrorTimer(Sender: TObject);
    procedure actGetHistoryOrdersExecute(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure tmrOnExclusiveTimer(Sender: TObject);
    procedure actShowMinPricesExecute(Sender: TObject);
    procedure actServiceLogExecute(Sender: TObject);
    procedure tmrOnNeedUpdateTimer(Sender: TObject);
    procedure tmrNeedUpdateCheckTimer(Sender: TObject);
    procedure actMiniMailExecute(Sender: TObject);
    procedure tmrStartUpTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
private
  JustRun: boolean;
  ApplicationVersionText : String;
  deletedForms : TObjectList;
  incompleteImport : Boolean;

  LastOrderCount,
  LastPositionCount : Integer;

  procedure SetStatusText(Value: string);
  procedure OnAppEx(Sender: TObject; E: Exception);
  procedure OnMainAppEx(Sender: TObject; E: Exception);
  function  GetActionLists : TList;
  procedure SetActionLists(AValue : TList);
  function  OldOrders : Boolean;
  function  OldWaybills : Boolean;
  procedure DeleteOldOrders;
  procedure DeleteOldWaybills;
  procedure RealFreeChildForms;
  procedure SetFocusOnMainForm;
  function  NeedUpdateClientLabel : Boolean;
  function DontShowAddresses : Boolean;
  procedure UpdateAddressName;
  procedure ToggleToolBar;
  procedure CollapseToolBar;
  procedure CallMiniMail();
  procedure HotSpotClick(Sender: TObject; const URL: string; var Handled: boolean);
public
  // ��� �������� ������������
  CurrentUser    : string;
  //��� ���������� ������ ��������
  CurrentAddressName : String;
  //���������� �� ������� ����� �������� �� ����� Future
  IsFutureClient : Boolean;
  ActiveChild: TChildForm;
  ExchangeOnly: boolean;

  RegionFilterIndex: integer;
  EnableFilterIndex: integer;
//  Filter

  //������������ ������ ������������ �������, ���������� ��� �����������
  MaxClientNameWidth : Integer;
  //������������� �� ToolBar ��� ����������� �������� ������ �������
  ClientNameRect : TRect;

  MiniMailForm: TMiniMailForm;

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
  procedure DisableByNetworkSettings;
  //�������� ��� ��������, ��������� � ���������� ����� �����������
  procedure EnableByHTTPName;
  function CheckUnsendOrders: boolean;
  procedure OnSelectClientClick(Sender: TObject);
  //���������� ��������� ����, ������� ���� ������ �� ������������
  //��� ���� ���� � ����������� ���� MessageBox
  function ModalExists : Boolean;
end;

var
  MainForm: TMainForm;
  ProcessFatalMySqlError : Boolean;

implementation

uses
  DModule, AProc, Config, DBProc, NamesForms, Prices,
  Defectives, Registers, Summary, OrdersH,
  Exchange, Expireds, Core, UniqueID, CoreFirm,
  AlphaUtils, About, CompactThread, LU_Tracer,
  SynonymSearch, U_frmOldOrdersDelete, U_frmSendLetter, Types, U_ExchangeLog,
  Variants, ExchangeParameters, CorrectOrders, DatabaseObjects,
  MnnSearch, DocumentHeaders, DBGridHelper, DocumentTypes,
  U_OrderBatchForm,
  StartupHelper,
  MyClasses,
  GlobalExchangeParameters,
  Wait,
  U_MinPricesForm,
  AddressController,
  KeyboardHelper,
  NetworkSettings,
  U_ServiceLogForm,
  Compact;

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
//var
//  il32: TImageList;
begin
  TVistaAltFix2.Create(Self);
{$ifndef DEBUG}
  itmImport.Visible := False;
{$endif}
  actCompact.Visible := False;
  actServiceLog.Visible := GetNetworkSettings().IsNetworkVersion;
  ClientNameRect := Rect(0, 0, 10, 10);
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
{$ifdef DEBUG}
    N2.Visible := True;
    N6.Visible := True;
    itmLinkExternal.Visible := True;
    itmUnlinkExternal.Visible := True;
{$endif}
    itmClearDatabase.Visible := True;
  end;

  LoadToImageList(ImageList, Application.ExeName, 100, Set32BPP);
  MiniMailForm := TMiniMailForm.Create(Application);
  HtmlViewer.OnHotSpotClick := HotSpotClick;
end;

procedure TMainForm.AppEventsIdle(Sender: TObject; var Done: Boolean);
begin
  //�������� ��� ��� ����, ����� ��������� ��������� pbSelectClient ����� ����������,
  //��-�� ���� ����� ���������� ������ ��������
  //����� �� �������� ��� ����
  //FormResize(Self);

  //������� �����, ���������� ��� ���������
  RealFreeChildForms;

  if not JustRun then exit;
  //������ ������ � ��� ������, ���� ���������� ������ ���� ������
  if not Active then exit;
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
  DM.InsertUserActionLog(uaShowConfig);
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
var
  newSearch,
  allCatalog,
  useForms : Boolean;
begin
  try
    if not DM.adtParams.FieldByName( 'OperateForms').AsBoolean then
      useForms := True
    else
      useForms := DM.adtParams.FieldByName( 'UseForms').AsBoolean;
    allCatalog := DM.adtParams.FieldByName( 'ShowAllCatalog').AsBoolean;
    newSearch := TNamesFormsForm.UseNewSearch();

    DM.InsertUserActionLog(
      uaCatalogSearch,
      [
        IfThen(newSearch, '����� �� ����� ������������'),
        IfThen(allCatalog, '���������� ���� �������'),
        IfThen(useForms, '����� �� ����� �������')
      ]);
  except
    on E : Exception do
      WriteExchangeLog('TMainForm.actOrderAllExecute',
        '������ ��� �����������: ' + ExceptionToString(E));
  end;
  ShowOrderAll;
end;

procedure TMainForm.actOrderPriceExecute(Sender: TObject);
begin
  DM.InsertUserActionLog(uaShowPrices);
  ShowPrices;
end;

procedure TMainForm.actOrderSummaryExecute(Sender: TObject);
begin
  DM.InsertUserActionLog(uaShowSummaryOrder);
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
  DM.InsertUserActionLog(uaShowDefectives);
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
  DM.InsertUserActionLog(uaShowOrders);
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
  DM.InsertUserActionLog(uaShowExpireds);
  ShowChildForm( TExpiredsForm );
end;

procedure TMainForm.actReceiveExecute(Sender: TObject);
var
  CatNum: integer;
  ExAct: TExchangeActions;
  result : Boolean;
begin
  DM.InsertUserActionLog(uaGetData);
  ExAct := [ eaGetPrice];

  { ��������� ������� �� ������� ������� }
  try
    CatNum := DM.QueryValue('SELECT COUNT(FullCode) AS CatNum FROM Catalogs', [], []);
  except
    CatNum := 0;
  end;

  { ���� ������� ������, �� ���������� ����� ������������� ������������ }
  if CatNum = 0 then ExAct := ExAct + [eaGetFullData];

  result := RunExchange( ExAct);

  //��������� ToolBar � ������ ����� ������� ����� ����������
  UpdateAddressName;

  if NeedShowMiniMail then
    CallMiniMail;
end;

procedure TMainForm.actReceiveAllExecute(Sender: TObject);
var
  result : Boolean;
begin
  DM.InsertUserActionLog(uaGetCumulative);
  if AProc.MessageBox( '������������ ���������� ���������� ���������� �������. ����������?',
    MB_ICONQUESTION or MB_OKCANCEL) = IDOK
  then begin
    result := RunExchange([eaGetPrice, eaGetFullData]);

    //��������� ToolBar � ������ ����� ������� ����� ����������
    UpdateAddressName;
    if NeedShowMiniMail then
      CallMiniMail;
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
{$ifdef DEBUG}
  RunExchange([ eaImportOnly]);
{$endif}
  //��������� ToolBar � ������ ����� ������� ����� ����������
  UpdateAddressName;
end;

procedure TMainForm.SetUpdateDateTime;
var
  updateTimePanel : TStatusPanel;
begin
  updateTimePanel := StatusBar.Panels[3];
  incompleteImport := False;
  updateTimePanel.Style := psText;
  if DM.adtParams.FieldByName( 'UpdateDateTime').IsNull then
    updateTimePanel.Text := '���������� �� �����������'
  else begin
    incompleteImport :=
      DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime <
        DM.adtParams.FieldByName( 'LastDateTime').AsDateTime;
    if incompleteImport then
      updateTimePanel.Style := psOwnerDraw;
    updateTimePanel.Text := '���������� : ' +
      DateTimeToStr( UTCToLocalTime(
        DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime));
  end;
  updateTimePanel.Width := StatusBar.Canvas.TextWidth(updateTimePanel.Text) + 15;
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

    if Assigned(TCustomDBGridEh(Screen.ActiveControl).DataSource)
      and Assigned(TCustomDBGridEh(Screen.ActiveControl).DataSource.DataSet)
      and TCustomDBGridEh(Screen.ActiveControl).DataSource.DataSet.Active
    then begin
      ParentForm := GetParentForm(Screen.ActiveControl);
      if Assigned(ParentForm) then
        DBGirdName := ParentForm.Name + '.' + TCustomDBGridEh(Screen.ActiveControl).Name
      else
        DBGirdName := TCustomDBGridEh(Screen.ActiveControl).Name;
      AProc.LogCriticalError('SE.' + DBGirdName + ' : ' + BoolToStr(SaveGridFlag) );

      TDBGridHelper.SaveGrid( TCustomDBGridEh( Screen.ActiveControl ) );
    end;
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
  I : Integer;
  IdTextWidth,
  NeedWidth,
  AllWidth : Integer;

begin
try
  if DM.MainConnection.Connected then begin
    if Length(DM.adtParams.FieldByName('StoredUserId').AsString) = 0 then
      StatusBar.Panels[StatusBar.Panels.Count-1].Text := '�� : �� ����������  '
        + ApplicationVersionText
    else
      StatusBar.Panels[StatusBar.Panels.Count-1].Text := '�� : ' + DM.adtParams.FieldByName('StoredUserId').AsString + '  '
        + ApplicationVersionText;
    IdTextWidth := StatusBar.Canvas.TextWidth(StatusBar.Panels[StatusBar.Panels.Count-1].Text) + 15;

    //������� �������, ������� �� ��������� �� � ������ ������
    if DM.adcUpdate.Active then
      DM.adcUpdate.Close;
    DM.adcUpdate.SQL.Text := 'DELETE FROM CurrentOrderLists WHERE NOT Exists(SELECT CurrentOrderHeads.OrderId FROM CurrentOrderHeads WHERE CurrentOrderHeads.OrderId=CurrentOrderLists.OrderId)';
    DM.adcUpdate.Execute;

    //������� ������� � ������� ������ � ����������� ������ = 0
    DM.adcUpdate.SQL.Text := 'DELETE FROM CurrentOrderLists WHERE OrderCount=0';
    DM.adcUpdate.Execute;

    //������� ������� ������ ��� �������
    DM.adcUpdate.SQL.Text := 'DELETE FROM CurrentOrderHeads WHERE NOT Exists(SELECT OrderId FROM CurrentOrderLists WHERE OrderId=CurrentOrderHeads.OrderId)';
    DM.adcUpdate.Execute;

    if DM.adsQueryValue.Active then
      DM.adsQueryValue.Close;
    DM.adsQueryValue.SQL.Text := ''
  +'SELECT '
  +'       COUNT(DISTINCT CurrentOrderHeads.orderid) AS OrdersCount, '
  +'       COUNT(osbc.id)                     AS Positions  , '
  +'       ifnull(SUM(osbc.RealPrice * osbc.OrderCount), 0) SumOrder, '
  +'  ( '
  +'    select '
  +'      ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.OrderCount), 0) '
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
  +'      ifnull(Sum(PostedOrderLists.RealPrice * PostedOrderLists.OrderCount), 0) '
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
  +'       inner JOIN PricesRegionalData PRD ON (PRD.RegionCode      = CurrentOrderHeads.RegionCode) AND (PRD.PriceCode = CurrentOrderHeads.PriceCode) '
  +'       inner JOIN PricesData             ON (PricesData.PriceCode=PRD.PriceCode) '
  +'WHERE (CurrentOrderHeads.CLIENTID                                      = :ClientID) '
  +'   and (CurrentOrderHeads.Frozen = 0) '
  +'   AND (CurrentOrderHeads.Closed                                      <> 1)';

    DM.adsQueryValue.ParamByName( 'ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
    DM.adsQueryValue.Open;
    try
      LastOrderCount := DM.adsQueryValue.FieldByName( 'OrdersCount').AsInteger;
      LastPositionCount := DM.adsQueryValue.FieldByName( 'Positions').AsInteger;
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
  DM.InsertUserActionLog(uaSendOrders);
  if DM.adtParams.FieldByName('ConfirmSendingOrders').AsBoolean then
    if AProc.MessageBox( '�� ������������� ������ ��������� ������?',
       MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = IDNO
    then
      Exit;

  if RunExchange([eaSendOrders]) then
  begin
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
    end
  end
  else
    if NeedEditCurrentOrders then
      ShowOrdersH;

  //��������� ToolBar � ������ ����� ������� ����� ����������
  UpdateAddressName;
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
  if GetNetworkSettings().IsNetworkVersion then
    actSendOrders.Enabled := not DM.DisableAllExchange and not GetNetworkSettings.DisableSendOrders and CheckUnsendOrders
  else
    actSendOrders.Enabled := not DM.DisableAllExchange and CheckUnsendOrders;
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
  //��������� ������ � ��������� ��������������� ���������� 
  tmrNeedUpdateCheck.Enabled := False;
  if not DM.MainConnection.Connected then exit;

  if OldOrders then
    if (not DM.adtParams.FieldByName('CONFIRMDELETEOLDORDERS').AsBoolean) or
       ConfirmDeleteOldOrders
    then
      DeleteOldOrders;

  if OldWaybills then
    if (not TGlobalSettingParams.GetConfirmDeleteOldWaybills(DM.MainConnection)
      or ConfirmDeleteOldWaybills)
    then
      DeleteOldWaybills;

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
  SchedulesController().LoadSchedules();
  
  actPostOrderBatch.Visible := DM.adsUser.FieldByName('EnableSmartOrder').AsBoolean;

  actGetHistoryOrders.Visible := not DM.adsUser.FieldByName('EnableImpersonalPrice').AsBoolean;

  actWayBill.Visible := not DontShowAddresses();

  if DM.adsUser.FieldByName('ShowAdvertising').IsNull or DM.adsUser.FieldByName('ShowAdvertising').AsBoolean
  then begin
    openFileName := RootFolder() + SDirReclame + '\' + FormatFloat('00', HtmlViewer.Tag) + '.htm';
    if SysUtils.FileExists( openFileName ) then
    try
      HtmlViewer.LoadFromFile(openFileName);
    except
      on E : Exception do
        LogCriticalError(
          '������ ��� �������� ����� � WebBrowser� � MainForm: ' + E.Message + #13#10 +
          '��������� ������: ' + SysErrorMessage(GetLastError()));
    end;
  end
  else begin
    try
      HtmlViewer.Clear();
    except
      on E : Exception do
        LogCriticalError(
          '������ ��� �������� ������ �������� � WebBrowser� � MainForm: ' + E.Message + #13#10 +
          '��������� ������: ' + SysErrorMessage(GetLastError()));
    end;
    DeleteFilesByMask(RootFolder() + SDirReclame + '\*.*', False);
  end;
  SetFocusOnMainForm;
end;

procedure TMainForm.actHomeExecute(Sender: TObject);
begin
  DM.InsertUserActionLog(uaHome);
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
  actPostOrderBatch.Enabled := False;
  actGetHistoryOrders.Enabled := False;
  actShowMinPrices.Enabled := False;
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
  actPostOrderBatch.Enabled := True;
  actGetHistoryOrders.Enabled := True;
  actShowMinPrices.Enabled := True;
  DisableByNetworkSettings;
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

      if not JustRun and (E is EMyError) and not ProcessFatalMySqlError
        and  DatabaseController.IsFatalError(EMyError(E))
      then begin
        ProcessFatalMySqlError := True;
        WriteExchangeLog('OnMainAppEx',
          Format('����� ����������� �������������� �� ��-�� ������: (%d) %s',
            [EMyError(E).ErrorCode, EMyError(E).Message]));
        AProc.MessageBox(
          '�������� ������ ��� ������ � ����� ������.'#13#10 +
          '����� ����������� �������������� ���� ������.',
          MB_ICONERROR);
        tmrRestoreOnError.Enabled := True;
      end
      else begin
        AProc.LogCriticalError(S + ' ' + ExceptionToString(E));
        Mess := Format('� ��������� ��������� �������������� ������:'#13#10 +
          '%s'#13#10'%s'#13#10#13#10 +
          '��������� ������ ���������?', [S, E.Message]);
        if AProc.MessageBox(Mess, MB_ICONERROR or MB_YESNO or MB_DEFBUTTON2) = ID_YES then
          ExitProcess(100);
      end;
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
var
  requestCount : Integer;
begin
  requestCount := DM.QueryValue('select count(RequestCertificate) from DocumentBodies where RequestCertificate = 1', [], []);
  if (requestCount > 20)
    and (AProc.MessageBox('�������� ����� 20 ������������ ���������� ���������� �������.'#13#10'����������?', MB_YESNO OR MB_DEFBUTTON1) = ID_NO)
  then
    Exit;

  DM.InsertUserActionLog(uaSendWaybills);
  RunExchange( [eaSendWaybills] );

  //��������� ToolBar � ������ ����� ������� ����� ����������
  UpdateAddressName;
end;

procedure TMainForm.actSynonymSearchExecute(Sender: TObject);
begin
  DM.InsertUserActionLog(uaSynonymSearch);
  ShowSynonymSearch;
end;

function TMainForm.OldOrders: Boolean;
begin
  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text := 'SELECT OrderId FROM PostedOrderHeads where (Closed = 1) and (orderdate < :MinOrderDate)';
  DM.adsQueryValue.ParamByName('MinOrderDate').AsDateTime := Date - DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger;
  DM.adsQueryValue.Open;
  try
    Result := not DM.adsQueryValue.IsEmpty;
  finally
    DM.adsQueryValue.Close;
  end;
end;

procedure TMainForm.DeleteOldOrders;
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
    if DM.adcUpdate.RowsAffected > 0 then
      WriteExchangeLog('DeleteOldOrders', '���������� ������������� ��������� ���������� �������: '
        + IntToStr(DM.adcUpdate.RowsAffected));
  except
    on E : Exception do
      LogCriticalError('������ ��� �������� ���������� ������� : ' + E.Message);
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
  UpdateAddressName;
end;

procedure TMainForm.actViewDocsExecute(Sender: TObject);
begin
  DM.InsertUserActionLog(uaShowDocuments);
  if not DM.adsUser.IsEmpty and DM.adsUser.FieldByName('ParseWaybills').AsBoolean
  then
    ShowDocumentHeaders
  else begin
    ShellExecute( 0, 'Open', PChar(RootFolder() + SDirDocs + '\'),
      nil, nil, SW_SHOWDEFAULT);
    ShellExecute( 0, 'Open', PChar(RootFolder() + SDirWaybills + '\'),
      nil, nil, SW_SHOWDEFAULT);
    ShellExecute( 0, 'Open', PChar(RootFolder() + SDirRejects + '\'),
      nil, nil, SW_SHOWDEFAULT);
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
{
  ���������� ����������� ������ ������� �������� �������� � ��� ����� ���� 
  if NeedUpdateClientLabel then
    ToolBar.Invalidate;
}

  if not JustRun and Self.Active and Self.Visible and (Screen.ActiveForm = Self)
    and not Assigned(GlobalExchangeParams)
  then begin
    SetOrdersInfo;

    if Self.Width < 900 then
      CollapseToolBar()
    else
      ToggleToolBar();
  end;
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
    GetAddressController.ChangeCurrent(DM.adtClientsCLIENTID.Value);
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
    NeedUpdateClientLabel;

    //������ �� ������, ���� ���������� � ����� ������������ ����, � �� ������� �������� ���
    if DontShowAddresses then
      Exit;

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
    if DM.adtClients.Active and (DM.adtClients.RecordCount > 0) and not DM.adtClients.FieldByName('Name').IsNull then
      CurrentAddressName := DM.adtClients.FieldByName('Name').AsString;
    ToolBar.Canvas.TextRect(TmpRect, TmpRect.Left + 3, TmpRect.Top + 4, CurrentAddressName);

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
      if DontShowAddresses then
        ToolBar.Hint := ''
      else
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
    if DontShowAddresses then
      Exit;
    ScreenPoint := ToolBar.ClientToScreen(Point(ClientNameRect.Left, ClientNameRect.Bottom));
    pmClients.Popup(ScreenPoint.X, ScreenPoint.Y);
  end;
end;

procedure TMainForm.AppEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if ((Msg.Message = WM_KEYDOWN) or (Msg.Message = WM_SYSKEYDOWN))
     and (Ord(Msg.wParam) = 32)
  then begin
  if     Self.Active
     and not Assigned(ActiveChild)
     and (not Assigned(ActiveControl) or (ActiveControl = HTMLViewer))
  then
  begin
    actOrderAll.Execute;
    Handled:=true;
  end;
  end;
end;

procedure TMainForm.actMnnSearchExecute(Sender: TObject);
begin
  DM.InsertUserActionLog(uaMnnSearch);
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
        Controls[i].Visible := False;
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
    childForm.Visible := False;
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

procedure TMainForm.actRestoreDatabaseFromEtalonExecute(Sender: TObject);
begin
  if AProc.MessageBox(
    '��� �������� ���� ������ ����� �������� ������� ������. ����������?',
    MB_ICONWARNING or MB_OKCANCEL) = IDOK
  then begin
    //��������� ��� ���� ����� ���������������
    FreeChildForms;
    Application.ProcessMessages;
    if RunRestoreDatabaseFromEtalon then
      RunExchange([eaGetPrice, eaGetFullData])
    else
      AProc.MessageBox('�������� ���� ������ ����������� � ��������.'#13#10 +
      '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.', MB_ICONWARNING);
  end;
end;

procedure TMainForm.SetFocusOnMainForm;
begin
  try
    Self.SetFocusedControl(Self);
  except
  end;
  try
    //������� ���������� ����� �� �����, �.�. �� ������ �� ����������
    Self.SetFocus;
  except
  end;
end;

procedure TMainForm.actPostOrderBatchExecute(Sender: TObject);
begin
  DM.InsertUserActionLog(uaShowOrderBatch);
  ShowOrderBatch;
end;

function TMainForm.NeedUpdateClientLabel: Boolean;
var
  PaintBoxWidth, PanelWidth, NewWidth : Integer;
  newClientNameRect : TRect;
begin
  Result := False;
  newClientNameRect := Rect(tbLastSeparator.Left + tbLastSeparator.Width + 7, 15, 10, 15 + 21{������ ��������});

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

  if (NewWidth <> ClientNameRect.Right - ClientNameRect.Left) or (newClientNameRect.Left <> ClientNameRect.Left)
  then begin
    ClientNameRect := newClientNameRect;
    ClientNameRect.Right := ClientNameRect.Left + NewWidth;
    Result := True;
  end;
end;

procedure TMainForm.tmrRestoreOnErrorTimer(Sender: TObject);
begin
  tmrRestoreOnError.Enabled := False;
  //��������� ��� ���� ����� ���������������
  FreeChildForms;
  Application.ProcessMessages;
  if RunRestoreDatabaseOnError then
    AProc.MessageBox('�������������� ���� ������ ��������� �������.')
  else
    AProc.MessageBox(
        '�������������� ���� ������ ����������� � ������.'#13#10
        +'����������, ������������� ���������.'#13#10
        +'���� �������� ����������, �� ��������� �� ������� ����������� ��������� ��� ��������� ����������.',
        MB_ICONWARNING)
end;

procedure TMainForm.actGetHistoryOrdersExecute(Sender: TObject);
begin
  inherited;
  RunExchange([eaGetHistoryOrders]);
end;

procedure TMainForm.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  if (Panel.Index = 3) and incompleteImport then begin
    StatusBar.Canvas.Brush.Color := clRed;
    //Panel background color
    StatusBar.Canvas.FillRect(Rect);
    //Panel Text
    StatusBar.Canvas.TextRect(Rect, Rect.Left, Rect.Top, Panel.Text) ;
  end;
end;

function TMainForm.DontShowAddresses: Boolean;
begin
  Result := IsFutureClient and (DM.adsUser.RecordCount > 0) and (DM.adtClients.RecordCount = 0);
end;

procedure TMainForm.tmrOnExclusiveTimer(Sender: TObject);
var
  BeforeOrderCount,
  BeforePositionCount : Integer;
  IsDebugLog : Boolean;
begin
  if not GetNetworkSettings().IsNetworkVersion then
    Exit;

  IsDebugLog := FindCmdLineSwitch('extd');
  if IsDebugLog then
    WriteExchangeLog('tmrOnExclusiveTimer', 'Start timer');
  BeforeOrderCount := LastOrderCount;
  BeforePositionCount := LastPositionCount;
  if not Assigned(GlobalExchangeParams) and DM.MainConnection.Connected then begin
    if IsDebugLog then
      WriteExchangeLog('tmrOnExclusiveTimer', 'Start exclusive');
    try
      SetOrdersInfo;
      BeforeOrderCount := LastOrderCount;
      BeforePositionCount := LastPositionCount;
    except
      on E : Exception do
        WriteExchangeLog('tmrOnExclusiveTimer', 'Error on SetOrdersInfo: ' + E.Message);
    end;
    if IsDebugLog then
      WriteExchangeLog('tmrOnExclusiveTimer', 'Before ReadParams');
    try
      DM.GlobalExclusiveParams.ReadParams;
    except
      on E : Exception do
        WriteExchangeLog('tmrOnExclusiveTimer', 'Error on Read: ' + E.Message);
    end;
    if IsDebugLog then
      WriteExchangeLog('tmrOnExclusiveTimer', 'After ReadParams');
    if not DM.GlobalExclusiveParams.ClearOrSelfExclusive
    then begin
      tmrOnExclusive.Enabled := False;
      try
        ShowWait;
      finally
        tmrOnExclusive.Enabled := True;
      end;
      try
        SetOrdersInfo;
      except
      end;
      if (BeforeOrderCount <> LastOrderCount) or (BeforePositionCount <> LastPositionCount) then
        AProc.MessageBox(
          '�������� ��� ������� ������ ������� �������.'#13#10 +
          '��������� �������� � ������� ������ �������.');
      DM.CheckNewNetworkVersion();
    end
    else begin
      if IsDebugLog then begin
        WriteExchangeLog('tmrOnExclusiveTimer', 'ExclusiveId: ' + DM.GlobalExclusiveParams.ExclusiveId);
        WriteExchangeLog('tmrOnExclusiveTimer', 'ExclusiveComputerName: ' + DM.GlobalExclusiveParams.ExclusiveComputerName);
        WriteExchangeLog('tmrOnExclusiveTimer', 'GetNetworkCopyID: ' + GetNetworkCopyID());
      end;
    end;
    if IsDebugLog then
      WriteExchangeLog('tmrOnExclusiveTimer', 'Stop exclusive');
  end
  else begin
    if IsDebugLog then begin
      WriteExchangeLog('tmrOnExclusiveTimer', 'else not Assigned(GlobalExchangeParams): ' + BoolToStr(not Assigned(GlobalExchangeParams), True));
      WriteExchangeLog('tmrOnExclusiveTimer', 'else DM.MainConnection.Connected: ' + BoolToStr(DM.MainConnection.Connected, True));
    end;
  end;
  if IsDebugLog then
    WriteExchangeLog('tmrOnExclusiveTimer', 'End timer');
end;

procedure TMainForm.actShowMinPricesExecute(Sender: TObject);
begin
  DM.InsertUserActionLog(uaShowMinPrices);
  ShowMinPrices;
end;

procedure TMainForm.DisableByNetworkSettings;
begin
  if GetNetworkSettings().IsNetworkVersion then begin
    actReceive.Enabled := not GetNetworkSettings.DisableUpdate;
    actReceiveAll.Enabled := not GetNetworkSettings.DisableUpdate;
    actWayBill.Enabled := not GetNetworkSettings.DisableUpdate;
    actGetHistoryOrders.Enabled := not GetNetworkSettings.DisableUpdate;
  end;
end;

procedure TMainForm.actServiceLogExecute(Sender: TObject);
begin
  ShowServiceLog;
end;

procedure TMainForm.UpdateAddressName;
begin
  CurrentAddressName := '';
  ToolBar.Invalidate;
end;

procedure TMainForm.CollapseToolBar;
begin
  if not Assigned(btnOrderAll.DropdownMenu) then begin
    tbSynonymSearch.Visible := False;
    tbMnnSearch.Visible := False;
    btnShowMinPrices.Visible := False;
    btnOrderAll.DropdownMenu := SearchMenu;
    btnOrderAll.Style := tbsDropDown;

    btnDefectives.Visible := False;
    btnExpireds.DropdownMenu := JunkMenu;
    btnExpireds.Style := tbsDropDown;

    tbWaybill.Visible := False;
    tbViewDocs.DropdownMenu := WaybillMenu;
    tbViewDocs.Style := tbsDropDown;

    btnHome.Visible := False;
    btnConfig.DropdownMenu := ConfigMenu;
    btnConfig.Style := tbsDropDown;
  end;
end;

procedure TMainForm.ToggleToolBar;
begin
  if Assigned(btnOrderAll.DropdownMenu) then begin
    tbSynonymSearch.Visible := True;
    tbMnnSearch.Visible := True;
    btnShowMinPrices.Visible := True;
    btnOrderAll.DropdownMenu := nil;
    btnOrderAll.Style := tbsButton;

    btnDefectives.Visible := True;
    btnExpireds.DropdownMenu := nil;
    btnExpireds.Style := tbsButton;

    tbWaybill.Visible := True;
    tbViewDocs.DropdownMenu := nil;
    tbViewDocs.Style := tbsButton;

    btnHome.Visible := True;
    btnConfig.DropdownMenu := nil;
    btnConfig.Style := tbsButton;
  end;
end;

procedure TMainForm.tmrOnNeedUpdateTimer(Sender: TObject);
begin
  tmrOnNeedUpdate.Enabled := False;
  actReceiveExecute(nil);
end;

procedure TMainForm.tmrNeedUpdateCheckTimer(Sender: TObject);
{
var
  forms : String;
}
begin
  if not SchedulesController().SchedulesEnabled then
    Exit;

  //���� ������� �����-���� ��������� ����, �� �������������� ���������� �� ����������
  if ModalExists then
    Exit;

{$ifdef DEBUG}
{
  try
  forms := '';
  if Assigned(Self.ActiveChild) then
    forms := '  Self.ActiveChild = ' + Self.ActiveChild.ClassName
  else
    forms := '  Self.ActiveChild = nil ';
  if Assigned(Screen.ActiveForm) then
    forms := forms + '  Screen.ActiveForm = ' + Screen.ActiveForm.ClassName
  else
    forms := forms + '  Screen.ActiveForm = nil ';
  if Assigned(Screen.ActiveCustomForm) then
    forms := forms + '  Screen.ActiveCustomForm = ' + Screen.ActiveCustomForm.ClassName
  else
    forms := forms + '  Screen.ActiveCustomForm = nil ';
  WriteExchangeLog('tmrNeedUpdateCheckTimer', forms);
  except
    on E : Exception do
     WriteExchangeLog('tmrNeedUpdateCheckTimer', 'Error = ' + ExceptionToString(E));
  end;
}
{$endif}

  if not Assigned(GlobalExchangeParams) and DM.MainConnection.Connected then begin
    if SchedulesController().NeedUpdate then begin
      tmrNeedUpdateCheck.Enabled := False;
      try
        ShowAction(
          '������ ����� ����������� ���������� ������ '#13#10 +
          '�� �������������� ����������.',
          '����������',
          10);
        tmrOnNeedUpdate.Enabled := False;
        tmrOnNeedUpdate.Enabled := True;
      finally
        tmrNeedUpdateCheck.Enabled := True;
      end;
    end;
  end;
end;

function GetClassNameHlp(h : HWND) : String;
var
  Buf: array [Byte] of Char;
begin
  FillChar(Buf, sizeof(Buf), 0);
  GetClassName(h, Buf, sizeof(Buf));
  Result := Trim(Buf);
end;

function GetTopWindowClbk(Wnd: THandle; var ReturnVar: THandle):Bool; stdcall;
var
  wndClassName : String;
begin
  wndClassName := GetClassNameHlp(Wnd);
  //WriteExchangeLog('GetTopWindowClbk', 'topWindow : ' + IntToStr(Wnd) + '  classname : ' + wndClassName);
  Result := True;
  //���� ���� � ������� #32770
  //��������: http://msdn.microsoft.com/en-us/library/ms697615
  if AnsiContainsText(wndClassName, '#32770') then begin
    ReturnVar := Wnd;
    Result := False;
  end;
end;

function TMainForm.ModalExists: Boolean;
var
  FFormHandle: THandle;
{
  GUIThreadInfo : TGUIThreadInfo;
  topWindow : HWND;
}
begin
  //��������� ���� �������, ���� �������� ����� - �� ������� ���� � �� �������� ����������� ��������� MDI-����
  Result := Assigned(Screen.ActiveCustomForm) and not (Screen.ActiveCustomForm is TMainForm) and not (Screen.ActiveCustomForm is TChildForm);

  //���� ��������� ���� �� �������, �� �������� ������� ���� ���� MessageBox
  if not Result then begin
    FFormHandle := 0;
    EnumThreadWindows(GetCurrentThreadID, @GetTopWindowClbk, LPARAM(@FFormHandle));
    Result := FFormHandle > 0;
{
    WriteExchangeLog('ModalExists', 'EnumThreadWindows : ' + IntToStr(FFormHandle));

    topWindow := GetTopWindow(Application.Handle);
    WriteExchangeLog('ModalExists', 'topWindow : ' + IntToStr(topWindow) + '  classname : ' + GetClassNameHlp(topWindow));
    FillChar(GUIThreadInfo, SizeOf(GUIThreadInfo), 0);
    GUIThreadInfo.cbSize := SizeOf(GUIThreadInfo);
    if GetGUIThreadInfo(MainThreadID, GUIThreadInfo) then begin
      WriteExchangeLog('ModalExists', 'Active : ' + IntToStr(GUIThreadInfo.hwndActive) + '  classname : ' + GetClassNameHlp(GUIThreadInfo.hwndActive));
    end;
}
  end;
end;

procedure TMainForm.CallMiniMail;
begin
  MiniMailForm.Show;
end;

procedure TMainForm.actMiniMailExecute(Sender: TObject);
begin
  CallMiniMail;
end;

procedure TMainForm.HotSpotClick(Sender: TObject; const URL: string;
  var Handled: boolean);
begin
  if Pos('@analit.net', URL) > 0 then
    MailTo(URL, '')
  else
    ShellExecute( Self.Handle, 'open', pchar(URL), nil, nil, SW_SHOWNORMAL);
  Handled := True;
end;

function TMainForm.OldWaybills: Boolean;
begin
  DM.adsQueryValue.SQL.Text := 'SELECT Id FROM DocumentHeaders where (LoadTime < :MinOrderDate)';
  DM.adsQueryValue.ParamByName('MinOrderDate').AsDateTime := Date - TGlobalSettingParams.GetWaybillsHistoryDayCount(DM.MainConnection);
  DM.adsQueryValue.Open;
  try
    Result := not DM.adsQueryValue.IsEmpty;
  finally
    DM.adsQueryValue.Close;
  end;
end;

procedure TMainForm.DeleteOldWaybills;
var
  documentType : TDocumentType;
  downloadId : String;
  histortDayCount : Integer;
begin
  histortDayCount := TGlobalSettingParams.GetWaybillsHistoryDayCount(DM.MainConnection);
  try
    if DM.adsQueryValue.Active then
      DM.adsQueryValue.Close;
    DM.adsQueryValue.SQL.Text := 'SELECT Id, DocumentType, DownloadId FROM DocumentHeaders where (LoadTime < :MinOrderDate)';
    DM.adsQueryValue.ParamByName('MinOrderDate').AsDateTime := Date - histortDayCount;
    DM.adsQueryValue.Open;
    try
      while not DM.adsQueryValue.Eof do begin
        documentType := TDocumentType(DM.adsQueryValue.FieldByName('DocumentType').AsInteger);
        downloadId := DM.adsQueryValue.FieldByName('DownloadId').AsString;
        if (documentType <> dtUnknown) and (Length(downloadId) > 0) then
        try
          DeleteFilesByMask(
            RootFolder() + DocumentFolders[documentType] + '\' + downloadId + '_*.*',
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
    DM.adcUpdate.ParamByName('MinOrderDate').AsDateTime := Date - histortDayCount;
    DM.adcUpdate.Execute;
    if DM.adcUpdate.RowsAffected > 0 then
      WriteExchangeLog('DeleteOldOrders', '���������� ������������� ��������� ���������� ���������: '
        + IntToStr(DM.adcUpdate.RowsAffected));
    //�������� ������ ����������, � ������� �� ���������� ���� (������� ������)
    DM.adcUpdate.SQL.Text := ''
     + ' delete '
     + ' FROM DocumentHeaders '
     + ' where '
     + '    (LoadTime < :MinOrderDate)';
    DM.adcUpdate.ParamByName('MinOrderDate').AsDateTime := Date - histortDayCount;
    DM.adcUpdate.Execute;
    if DM.adcUpdate.RowsAffected > 0 then
      WriteExchangeLog('DeleteOldOrders', '���������� ������������� ��������� ���������� ����������: '
        + IntToStr(DM.adcUpdate.RowsAffected));
  except
    on E : Exception do
      LogCriticalError('������ ��� �������� ���������� ���������� : ' + E.Message);
  end;
end;

procedure TMainForm.tmrStartUpTimer(Sender: TObject);
var
  I : Integer;
  LoggedOn : Boolean;
begin
  tmrStartUp.Enabled := False;

  Self.WindowState := wsMaximized;
  Self.Repaint;

  //������ ������ ������
  DM.StartUp;

  JustRun := False;
  mainStartupHelper.Stop;
try
  try
  DisableByNetworkSettings;

  tmrOnExclusive.Enabled := True;
  //���������� ��������������
  FormPlacement.Active := True;
  GetKeyboardHelper.SwitchToRussian();

  pStartUp.Visible := False;
  UpdateReclame;
  //� UpdateReclame ����� ��������� ����������� ������ actPostOrderBatch,
  //������� ���� ��� ��� �����������
  //����� �� �������� ��� ����
  //FormResize(Self);

  //todo: ClientId-UserId
  DM.GetClientInformation(CurrentUser, IsFutureClient);
  CurrentAddressName := '';
  if (Length(CurrentUser) > 0) then
    Self.Caption := Application.Title + ' - ' + CurrentUser
  else
    Self.Caption := Application.Title;


  // ����� ������
  LoggedOn := False;
  if Trim( DM.adtParams.FieldByName( 'HTTPName').AsString) = '' then
  begin
    AProc.MessageBox( '��� ������ ������ � ���������� ���������� ��������� ������� ������',
      MB_ICONWARNING or MB_OK);
    LoggedOn := (ShowConfig( True) * [ccHTTPName]) <> [];
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
        //����� ���� ��������� ������������ �������� ���������� ����� ��� ���������� ���������
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
    if not RunExchange([eaGetPrice])
    then
      Exit;
  end;

  //���� �������� ����� � ��������, �� ������� �� ���������
  if DM.DisableAllExchange then
    Exit;

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

  if DM.CreateClearDatabase and (DM.adtParams.FieldByName('HTTPName').AsString <> '') and not LoggedOn
  then begin
    WriteExchangeLog('AnalitF',
      '��������� ������������ ���� ������ � ��������������� ������� ������ �� TableBackup,' +
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
    then begin
      actReceiveExecute( nil);
    end;
  end
  else begin
    if SchedulesController().SchedulesEnabled and SchedulesController().NeedUpdateOnBegin
    then begin
      ShowAction(
        '������ ����� ����������� ���������� ������ '#13#10 +
        '�� �������������� ����������.',
        '����������',
        10);
      actReceiveExecute( nil);
      //���� �� ���������� ��������� ���������� �� ����������, �� ����� �������
      //���������� �� ����������, �.�. ���� ����������, ���� �� ����������, ���� �������� ����� ������
      //���� �� ������, �� ��� ��������� ����� ������ ������ �� ���������� ����������
      //� ����� � ���������� ������� ������
      Exit;
    end;

    if ( HourSpan( DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime, Now) >= 8) and
      ( Trim( DM.adtParams.FieldByName( 'HTTPName').AsString) <> '') then
      if AProc.MessageBox( '�� ��������� � ���������� ������� ������. ��������� ����������?',
         MB_ICONQUESTION or MB_YESNO) = IDYES
      then begin
        actReceiveExecute( nil);
      end;
  end;

  finally
    //�������� �������� ������� ����� ����� ��� ��������� ������
    if not GetNetworkSettings().IsNetworkVersion then
      if TDayOfWeekDelaysController.NeedUpdateDelays(DM) then begin
        ShowSQLWaiting(TDayOfWeekDelaysController.RecalcOrdersByDelays, '���������� ����c��� �������� �������');
        SetOrdersInfo;
      end;
    TDayOfWeekDelaysController.UpdateDayOfWeek(DM);
    
    tmrNeedUpdateCheck.Enabled := True;
  end;

finally
  SetFocusOnMainForm;
  //��������� ToolBar � ������ ����� ������� ����� ����������
  UpdateAddressName;
  if NeedShowMiniMail then
    CallMiniMail;
end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if JustRun then
    tmrStartUp.Enabled := True;
end;

initialization
  ProcessFatalMySqlError := False;
end.

