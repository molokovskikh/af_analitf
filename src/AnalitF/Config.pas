unit Config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, ComCtrls, DBCtrls, Mask, Menus, DBGridEh, ShellAPI,
  Buttons, ExtCtrls, ToughDBGrid, DB, RxMemDS, DModule, GridsEh, U_VistaCorrectForm,
  MyAccess, FileCtrl, U_frameEditVitallyImportantMarkups, U_frameEditAddress,
  DatabaseObjects,
  NetworkParams,
  NetworkSettings,
  GlobalSettingParams,
  U_ExchangeLog,
  DBGridHelper,
  U_LegendHolder,
  U_CheckTCPThread;

type
  TConfigChange = (ccOk, ccHTTPName, ccHTTPPassword, ccHTTPHost);
  TConfigChanges = set of TConfigChange;

const
  AuthChanges = [ccHTTPName, ccHTTPPassword, ccHTTPHost];

type  
  TConfigForm = class(TVistaCorrectForm)
    btnOk: TButton;
    btnCancel: TButton;
    PageControl: TPageControl;
    tshAuth: TTabSheet;
    tshClients: TTabSheet;
    tshConnect: TTabSheet;
    RasMenu: TPopupMenu;
    itmRasCreate: TMenuItem;
    itmRasDelete: TMenuItem;
    itmRasEdit: TMenuItem;
    itmRasEditName: TMenuItem;
    TabSheet1: TTabSheet;
    dbcbProxyConnect: TDBCheckBox;
    Label10: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    dbeProxyName: TDBEdit;
    dbeProxyPort: TDBEdit;
    dbeProxyUserName: TDBEdit;
    dbeProxyPass: TDBEdit;
    gbRAS: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label7: TLabel;
    dbcbRasConnect: TDBCheckBox;
    cbRas: TComboBox;
    dbeRasName: TDBEdit;
    dbeRasPass: TDBEdit;
    gbAutoDial: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    dbeConnectCount: TDBEdit;
    udConnectCount: TUpDown;
    dbeConnectPause: TDBEdit;
    udConnectPause: TUpDown;
    tshOther: TTabSheet;
    DBCheckBox1: TDBCheckBox;
    lblServerLink: TLabel;
    btnRasActions: TBitBtn;
    lblTip: TLabel;
    imgTip: TImage;
    Label9: TLabel;
    dbeRasSleep: TDBEdit;
    udRasSleep: TUpDown;
    gbDeleteHistory: TGroupBox;
    lHistoryDayCount: TLabel;
    dbeHistoryDayCount: TDBEdit;
    udHistoryDayCount: TUpDown;
    Label16: TLabel;
    dbcbConfirmDeleteOldOrders: TDBCheckBox;
    dbchbUseOSOpenWaybill: TDBCheckBox;
    dbchbUseOSOpenReject: TDBCheckBox;
    dbchbPrintOrdersAfterSend: TDBCheckBox;
    dbchbConfirmSendingOrders: TDBCheckBox;
    pHTTP: TPanel;
    gbHTTP: TGroupBox;
    Label1: TLabel;
    dbeHTTPHost: TDBEdit;
    pAccount: TPanel;
    gbAccount: TGroupBox;
    Label4: TLabel;
    Label3: TLabel;
    dbeHTTPName: TDBEdit;
    eHTTPPass: TEdit;
    lWaybillsHistoryDayCount: TLabel;
    lWaybillsHistoryDayCountTile: TLabel;
    eWaybillsHistoryDayCount: TEdit;
    chbConfirmDeleteOldWaybills: TCheckBox;
    tshVisualization: TTabSheet;
    DBCheckBox2: TDBCheckBox;
    dbchbGroupByProducts: TDBCheckBox;
    LegendColorDialog: TColorDialog;
    bbTestConnection: TBitBtn;
    procedure btnOkClick(Sender: TObject);
    procedure itmRasCreateClick(Sender: TObject);
    procedure itmRasEditClick(Sender: TObject);
    procedure itmRasDeleteClick(Sender: TObject);
    procedure itmRasEditNameClick(Sender: TObject);
    procedure udConnectCountClick(Sender: TObject; Button: TUDBtnType);
    procedure dbeConnectCountChange(Sender: TObject);
    procedure udConnectPauseClick(Sender: TObject; Button: TUDBtnType);
    procedure dbeConnectPauseChange(Sender: TObject);
    procedure DBCheckBox2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblServerLinkClick(Sender: TObject);
    procedure tshAuthShow(Sender: TObject);
    procedure btnRasActionsClick(Sender: TObject);
    procedure udRasSleepClick(Sender: TObject; Button: TUDBtnType);
    procedure dbeRasSleepChange(Sender: TObject);
    procedure dbeHTTPNameChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure dbeHistoryDayCountChange(Sender: TObject);
    procedure udHistoryDayCountClick(Sender: TObject; Button: TUDBtnType);
    procedure eHTTPPassChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bbTestConnectionClick(Sender: TObject);
  private
    HTTPNameChanged, HTTPPassChanged : Boolean;
    OldHTTPName : String;
    OldHTTPHost : String;
    FNetworkParams : TNetworkParams;
    FGlobalSettingParams : TGlobalSettingParams;
    procedure GetEntries;
    procedure DisableRemoteAccess;
    procedure EnableRemoteAccess;
    procedure OnAppEx(Sender: TObject; E: Exception);
    procedure AddEditAddressSheet;
    procedure AddLabelAndDBEdit(
      Parents : TWinControl;
      DataSource : TDataSource;
      var nextTop: Integer;
      var labelInfo : TLabel;
      var dbedit : TDBEdit;
      LabelCaption,
      DataField : String);

    procedure AddControlsToChangeFolder(
      Parents : TWinControl;
      DataSource : TDataSource;
      var nextTop: Integer;
      var labelInfo : TLabel;
      var dbedit : TDBEdit;
      LabelCaption,
      DataField : String;
      OnChangeFolder : TNotifyEvent;
      var selectFolderButton : TSpeedButton;
      OnSelectFolderClick : TNotifyEvent;
      var folderNotExistsLabel : TLabel);
    procedure AddWaybillFoldersSheet;
    procedure OpenWaybillFoldersDataSet();
    procedure SelectFolderClick(Sender : TObject);
    procedure WaybillFolderChange(Sender : TObject);
    procedure OrderFolderChange(Sender : TObject);
    procedure SelectOrderFolderClick(Sender : TObject);
    procedure WaybillUnloadingFolderChange(Sender : TObject);
    procedure SelectWaybillUnloadingFolderClick(Sender : TObject);
    procedure AddVitallyImportantMarkups;
    procedure AddRetailMarkups;
    procedure AddNDS18Markups;
    procedure AddBottomPanel;
    procedure AddNetworkVersionSettings();
    procedure AddLegendsSettings();
    procedure AddLabelAndEdit(
      Parents : TWinControl;
      var nextTop: Integer;
      var labelInfo : TLabel;
      var edit : TEdit;
      LabelCaption : String);
    procedure AddLabelAndCombo(
      Parents : TWinControl;
      var nextTop: Integer;
      var labelInfo : TLabel;
      var combo : TComboBox;
      LabelCaption : String);
    procedure CreateFolders();
    procedure ChangeVisualization;
    procedure LegendsGetCellParams(
      Sender: TObject;
      Column: TColumnEh;
      AFont: TFont;
      var Background: TColor;
      State: TGridDrawState);
    procedure LegendsDblClick(Sender : TObject);
  protected
    tsEditAddress : TTabSheet;
    frameEditAddress : TframeEditAddress;

    tsWaybillFolders : TTabSheet;
    adsWaybillFolders : TMyQuery;
    dsWaybillFolders : TDataSource;

    gbWaybillFolders : TGroupBox;
    lProviderId : TLabel;
    dblProviderId : TDBLookupComboBox;

    lWaybillFolder : TLabel;
    dbeWaybillFolder : TDBEdit;

    sbSelectFolder : TSpeedButton;

    lFolderNotExists : TLabel;

    lOrderFolder : TLabel;
    dbeOrderFolder : TDBEdit;
    sbSelectOrderFolder : TSpeedButton;
    lOrderFolderNotExists : TLabel;

    lWaybillUnloadingFolder : TLabel;
    dbeWaybillUnloadingFolder : TDBEdit;
    sbSelectWaybillUnloadingFolder : TSpeedButton;
    lWaybillUnloadingFolderNotExists : TLabel;

    gbNetworkVersionSettings : TGroupBox;
    lExportPricesFolder : TLabel;
    eExportPricesFolder : TEdit;
    lPositionPercent : TLabel;
    ePositionPercent : TEdit;

    chbGroupWaybillsBySupplier : TCheckBox;

    tsVitallyImportantMarkups : TTabSheet;
    frameEditVitallyImportantMarkups : TframeEditVitallyImportantMarkups;

    tsNDS18Markups : TTabSheet;
    frameEditNDS18Markups : TframeEditVitallyImportantMarkups;

    frameEditRetailMarkups : TframeEditVitallyImportantMarkups;

    lBaseFirmCategory : TLabel;
    eBaseFirmCategory : TEdit;

    lExcess : TLabel;
    eExcess : TEdit;

    lExcessAvgOrderTimes : TLabel;
    eExcessAvgOrderTimes : TEdit;

    lDeltaMode : TLabel;
    cbDeltaMode : TComboBox;

    chbShowPriceName : TCheckBox;

    chbUseColorOnWaybillOrders : TCheckBox;
    
    lNewRejectsDayCount : TLabel;
    eNewRejectsDayCount : TEdit;

    pButton : TPanel;

    tsLegendsSettings : TTabSheet;
    dsLegends : TDataSource;
    dbgLegends : TToughDBGrid;
   public
  end;

var
  ConfigForm: TConfigForm;

function ShowConfig( Auth: boolean = False): TConfigChanges;

implementation

{$R *.DFM}

uses DBProc, AProc, Main, LU_Tracer, Constant, StrUtils,
  KeyboardHelper;

function ShowConfig( Auth: boolean = False): TConfigChanges;
var
  IsRasPresent: boolean;
  OldExep : TExceptionEvent;
  HTTPPass : String;
  NewPass,
  CryptNewPass : String;
  oldKbd : HKL;
begin
  Result := [];
  //��� �������� ���� ������� �� ����������, ������� ��������� ����
  MainForm.FreeChildForms;
  MainForm.UpdateReclame;
  with TConfigForm.Create(Application) do try

{
    oldKbd := GetKeyboardHelper.GetCurrentKeyboard();
    //���� ������� ���������� �� ����������, �� ������������� �� ����������
    if oldKbd <> GetKeyboardHelper.EnglishKeyboard then
      GetKeyboardHelper.SwitchToEnglish();
}
    //����� �� ���������� ������� ������������, ���� � ������ ����� ��������,
    //�� ��� � ����������� ���� ���� �������
    oldKbd := GetKeyboardHelper.SwitchToEnglish();
      
    OldExep := Application.OnException;
    try
      Application.OnException := OnAppEx;
      HTTPNameChanged := False;
      OldHTTPName := dbeHTTPName.Field.AsString;
      OldHTTPHost := dbeHTTPHost.Field.AsString;
      dbchbPrintOrdersAfterSend.Enabled := (DM.SaveGridMask and PrintSendedOrder) > 0;
{$ifndef DSP}
      //���� � ���������� ��������� ��� ����� "extd", �� �������� ��������� "����"
      if (not FindCmdLineSwitch('extd')) then
        pHTTP.Visible := False;
{$endif}
      if Auth then
        PageControl.ActivePage := tshAuth
      else
        PageControl.ActivePageIndex := 0;

      //������ ��������� ����������
      IsRasPresent := True;
      try
        GetEntries;
        DM.Ras.Entry:=DM.adtParams.FieldByName('RasEntry').AsString;
        cbRas.ItemIndex:=DM.Ras.GetEntryIndex;
      except
        IsRasPresent := False;
      end;
      if IsRasPresent then
        EnableRemoteAccess
      else
        DisableRemoteAccess;
      try
        HTTPPass := DM.D_HP(DM.adtParams.FieldByName('HTTPPass').AsString);
      except
        on E : Exception do begin
          LogCriticalError(
            Format(
              '������ ��� ����������� ������ "%s" : %s',
              [DM.adtParams.FieldByName('HTTPPass').AsString,
              E.Message]));
          HTTPPass := '123456';
        end;
      end;
      eHTTPPass.Text := StringOfChar('*', Length(HTTPPass));
      HTTPPassChanged := False;
      DM.adtParams.Edit;
      if ShowModal = mrOk then
        Result := [ccOk];
      if Result = [ccOk] then begin
        if Assigned(frameEditVitallyImportantMarkups) then
          frameEditVitallyImportantMarkups.SaveVitallyImportantMarkups;

        if Assigned(frameEditRetailMarkups) then
          frameEditRetailMarkups.SaveVitallyImportantMarkups;

        if Assigned(frameEditAddress) then
          frameEditAddress.SaveChanges;

        if chbGroupWaybillsBySupplier.Checked <> FGlobalSettingParams.GroupWaybillsBySupplier then
          FGlobalSettingParams.GroupWaybillsBySupplier := chbGroupWaybillsBySupplier.Checked;

        if adsWaybillFolders.Active or FGlobalSettingParams.GroupWaybillsBySupplier then begin
          if FGlobalSettingParams.GroupWaybillsBySupplier and not adsWaybillFolders.Active then
            OpenWaybillFoldersDataSet();
          SoftPost(adsWaybillFolders);
          adsWaybillFolders.ApplyUpdates;
          DatabaseController.BackupDataTable(doiProviderSettings);
          CreateFolders();
        end;

        DM.adtParams.FieldByName('RasEntry').AsString := cbRas.Items[cbRas.ItemIndex];
        if HTTPPassChanged then begin
          Result := Result + [ccHTTPPassword];
          NewPass := eHTTPPass.Text;
          CryptNewPass := DM.E_HP(NewPass);
          DM.adtParams.FieldByName('HTTPPass').AsString := CryptNewPass;
{
          LogCriticalError(
            Format(
              '��������� ������. ������: "%s"  ������������� : "%s"  � ������� : "%s"',
              [NewPass,
              CryptNewPass,
              DM.adtParams.FieldByName('HTTPPass').AsString]));
}
        end;
        if HTTPNameChanged and (not AnsiSameText(OldHTTPName, dbeHTTPName.Field.AsString)) then begin
          if not AnsiSameText(DM.adtParams.FieldByName('StoredUserId').AsString, dbeHTTPName.Field.AsString) then begin
            Result := Result + [ccHTTPName];
            DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean := True;
            MainForm.DisableByHTTPName;
            // ������� ��� �������������� �������� ������
            DM.adcUpdate.SQL.Text := ''
             + ' delete CurrentOrderHeads, CurrentOrderLists'
             + ' FROM CurrentOrderHeads, CurrentOrderLists '
             + ' where '
             + '    (Closed = 0)'
             + ' and (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId)';
            DM.adcUpdate.Execute;
            //������� ��������� � ���������� �����-������
            DM.adcUpdate.SQL.Text := 'truncate pricesregionaldataup';
            DM.adcUpdate.Execute;
            DM.adtParams.FieldByName('UPDATEDATETIME').Clear;
            DM.adtParams.FieldByName('LASTDATETIME').Clear;
            DM.adtParams.FieldByName('StoredUserId').AsString := dbeHTTPName.Field.AsString;
          end;
        end;
        if (OldHTTPHost <> dbeHTTPHost.Field.AsString) then
          Result := Result + [ccHTTPHost];
        if chbConfirmDeleteOldWaybills.Checked <> FGlobalSettingParams.ConfirmDeleteOldWaybills then
          FGlobalSettingParams.ConfirmDeleteOldWaybills := chbConfirmDeleteOldWaybills.Checked;
        DM.adtParams.Post;
        FNetworkParams.SaveParams;
        FGlobalSettingParams.SaveParams;
        LegendHolder.SaveChangesFromDataSet(DM.MainConnection);
      end
      else begin
        if Assigned(frameEditAddress) then
          frameEditAddress.CancelChanges;
        if adsWaybillFolders.Active then
          adsWaybillFolders.CancelUpdates;
        DM.adtParams.Cancel;
      end;

    finally

{
      //���� �� ������������ ���� �� ����������, �� ������������� �������
      if oldKbd <> GetKeyboardHelper.EnglishKeyboard then
        GetKeyboardHelper.SwitchToPrev;
}
      //����� �� ���������� ������� ������������, ���� � ������ ����� ��������,
      //�� ��� � ����������� ���� ���� �������
      GetKeyboardHelper.SwitchToLanguage(oldKbd);

      Application.OnException := OldExep;
    end;

  finally
    Free;
  end;
  //���� RollBack - ���� ��������
  DM.adtParams.Close;
  DM.adtParams.Open;
  DM.adsUser.Close;
  DM.adsUser.Open;
  DM.adtClients.Close;
  DM.adtClients.Open;
  DM.ClientChanged;
end;

procedure TConfigForm.GetEntries;
var
  I: Integer;
begin
  DM.Ras.GetEntries;
  cbRas.Items.Assign(DM.Ras.Items);
  if cbRas.Items.Count = 0 then exit;
  for i := 0 to cbRas.Items.Count - 1 do
    if cbRas.Items[ I] = DM.Ras.Entry then
    begin
      cbRas.ItemIndex := i;
      break;
    end;
  if ( cbRas.ItemIndex = -1) and ( cbRas.Items.Count > 0) then cbRas.ItemIndex := 0;
end;

procedure TConfigForm.btnOkClick(Sender: TObject);
begin
  //���� ������ Enter � ���� ���� dbeID, �� �������� �� ���������, ������� ���������� �����
  btnOk.SetFocus;
  ModalResult:=mrOk;
end;

procedure TConfigForm.itmRasCreateClick(Sender: TObject);
begin
  if DM.Ras.CreateEntryDlg then GetEntries;
end;

procedure TConfigForm.itmRasEditClick(Sender: TObject);
begin
  if cbRas.ItemIndex>=0 then begin
    DM.Ras.Entry:=cbRas.Items[cbRas.ItemIndex];
    DM.Ras.EditEntry;
  end;
end;

procedure TConfigForm.itmRasDeleteClick(Sender: TObject);
begin
  if (cbRas.ItemIndex>=0)and(AProc.MessageBox('������� ��������� ����������?',
    MB_ICONQUESTION+MB_OKCANCEL)=IDOK) then begin
    DM.Ras.Entry:=cbRas.Items[cbRas.ItemIndex];
    DM.Ras.DeleteEntry;
    GetEntries;
  end;
end;

procedure TConfigForm.itmRasEditNameClick(Sender: TObject);
begin
  if cbRas.ItemIndex>=0 then begin
    DM.Ras.Entry:=cbRas.Items[cbRas.ItemIndex];
    if DM.Ras.RenameEntryDlg then GetEntries;
  end;
end;

procedure TConfigForm.udConnectCountClick(Sender: TObject;
  Button: TUDBtnType);
begin
  dbeConnectCount.Field.AsInteger:=udConnectCount.Position;
end;

procedure TConfigForm.dbeConnectCountChange(Sender: TObject);
var
  V, E: Integer;
begin
  Val(dbeConnectCount.Text,V,E);
  udConnectCount.Position:=V;
end;

procedure TConfigForm.udConnectPauseClick(Sender: TObject;
  Button: TUDBtnType);
begin
  dbeConnectPause.Field.AsInteger:=udConnectPause.Position;
end;

procedure TConfigForm.dbeConnectPauseChange(Sender: TObject);
var
  V, E: Integer;
begin
  Val(dbeConnectPause.Text,V,E);
  udConnectPause.Position:=V;
end;

procedure TConfigForm.DBCheckBox2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  AProc.MessageBox('��������� ������� � ���� ����� ��������� ������', MB_OK or MB_ICONWARNING);
end;

procedure TConfigForm.lblServerLinkClick(Sender: TObject);
begin
  ShellExecute(0, 'Open',
    PChar('https://stat.analit.net/ci/auth/logon.aspx'),nil, nil, SW_SHOWDEFAULT);
end;

procedure TConfigForm.tshAuthShow(Sender: TObject);
begin
  dbeHTTPName.SetFocus;  
end;

procedure TConfigForm.btnRasActionsClick(Sender: TObject);
var
  P: TPoint;
begin
  P := btnRasActions.ClientToScreen(Point(0,btnRasActions.Height));
  RasMenu.Popup(P.X-1,P.Y-1);
end;

procedure TConfigForm.DisableRemoteAccess;
begin
  DM.adtParams.Edit;
  DM.adtParams.FieldByName( 'RasConnect').AsBoolean := False;
  DM.adtParams.Post;
  dbcbRasConnect.Enabled := False;
  cbRas.Enabled := False;
  btnRasActions.Enabled := False;
  dbeRasName.Enabled := False;
  dbeRasPass.Enabled := False;
  dbeConnectCount.Enabled := False;
  dbeConnectPause.Enabled := False;
  lblTip.Visible := True;
  imgTip.Visible := True;
end;

procedure TConfigForm.EnableRemoteAccess;
begin
  dbcbRasConnect.Enabled := True;
  cbRas.Enabled := True;
  btnRasActions.Enabled := True;
  dbeRasName.Enabled := True;
  dbeRasPass.Enabled := True;
  dbeConnectCount.Enabled := True;
  dbeConnectPause.Enabled := True;
  lblTip.Visible := False;
  imgTip.Visible := False;
end;

procedure TConfigForm.udRasSleepClick(Sender: TObject; Button: TUDBtnType);
begin
  dbeRasSleep.Field.AsInteger := udRasSleep.Position;
end;

procedure TConfigForm.dbeRasSleepChange(Sender: TObject);
var
  V, E: Integer;
begin
  Val(dbeRasSleep.Text,V,E);
  udRasSleep.Position:=V;
end;

procedure TConfigForm.dbeHTTPNameChange(Sender: TObject);
begin
  HTTPNameChanged := True;
end;

procedure TConfigForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  newPercent : Double;
  newWaybillHistoryDayCount : Integer;
  outInt : Integer;
begin
  if (ModalResult = mrOK) then begin
    if HTTPNameChanged and (not AnsiSameText(OldHTTPName, dbeHTTPName.Field.AsString)) then begin
      if (not AnsiSameText(DM.adtParams.FieldByName('StoredUserId').AsString, dbeHTTPName.Field.AsString)) then
        if MainForm.CheckUnsendOrders and
           (AProc.MessageBox('��������� ����� ����������� ������ ��� �������������� ������. ����������?' , MB_ICONQUESTION or MB_YESNO) <> IDYES)
        then
          CanClose := False;
    end;
    if CanClose and Assigned(frameEditRetailMarkups) and not frameEditRetailMarkups.ProcessCloseQuery(CanClose)
    then begin
      PageControl.ActivePage := tshClients;
      frameEditRetailMarkups.dbgMarkups.SetFocus;
    end;
    if CanClose and Assigned(frameEditVitallyImportantMarkups) and not frameEditVitallyImportantMarkups.ProcessCloseQuery(CanClose)
    then begin
      PageControl.ActivePage := tsVitallyImportantMarkups;
      frameEditVitallyImportantMarkups.dbgMarkups.SetFocus;
    end;
    if CanClose and DM.adtParams.FieldByName('RasConnect').AsBoolean then begin
      if (cbRas.ItemIndex < 0) then begin
        CanClose := False;
        PageControl.ActivePage := tshConnect;
        cbRas.SetFocus;
        AProc.MessageBox('�� ������ ��������� ����������.', MB_ICONWARNING);
      end;
      if CanClose then begin
        DM.Ras.Entry:=cbRas.Items[cbRas.ItemIndex];
        if (DM.Ras.GetEntryIndex < 0) then begin
          CanClose := False;
          PageControl.ActivePage := tshConnect;
          cbRas.SetFocus;
          AProc.MessageBox('��������� ���������� �� ����������.', MB_ICONWARNING);
        end;
      end;
    end;
    if CanClose
      and ((dbeHistoryDayCount.Field.AsInteger < udHistoryDayCount.Min)
          or (dbeHistoryDayCount.Field.AsInteger > udHistoryDayCount.Max))
    then begin
      CanClose := False;
      AProc.MessageBox(
        Format('����������, �������������� �������� � ���� "%s".'#13#10
          + '��� ������ ���� � ��������� [%d, %d].',
          [lHistoryDayCount.Caption,
           udHistoryDayCount.Min,
           udHistoryDayCount.Max]),
        MB_ICONWARNING);
      PageControl.ActivePage := tshOther;
      dbeHistoryDayCount.SetFocus;
    end;

    if CanClose then begin
      if TryStrToFloat(ePositionPercent.Text, newPercent) then begin
        FNetworkParams.NetworkPositionPercent := newPercent;
        if GetNetworkSettings().IsNetworkVersion then
          FNetworkParams.NetworkExportPricesFolder := eExportPricesFolder.Text;
      end
      else begin
        CanClose := False;
        AProc.MessageBox(
          Format('����������, �������������� �������� � ���� "%s".'#13#10
            + '��� ������ ���� ������������ ������.',
            [lPositionPercent.Caption]),
          MB_ICONWARNING);
        PageControl.ActivePage := tshOther;
        ePositionPercent.SetFocus;
      end;
    end;

    if CanClose then begin
      FGlobalSettingParams.ShowPriceName := chbShowPriceName.Checked;
      FGlobalSettingParams.UseColorOnWaybillOrders := chbUseColorOnWaybillOrders.Checked;
      FGlobalSettingParams.DeltaMode := cbDeltaMode.ItemIndex;
      if TryStrToInt(eBaseFirmCategory.Text, outInt) then 
        FGlobalSettingParams.BaseFirmCategory := outInt;
    end;

    if CanClose then begin
      if TryStrToInt(eExcess.Text, outInt) then
        FGlobalSettingParams.Excess := outInt;
    end;

    if CanClose then begin
      if TryStrToInt(eExcessAvgOrderTimes.Text, outInt) then
        FGlobalSettingParams.ExcessAvgOrderTimes := outInt;
    end;

    if CanClose then begin
      if TryStrToInt(eWaybillsHistoryDayCount.Text, newWaybillHistoryDayCount) then begin
        FGlobalSettingParams.WaybillsHistoryDayCount := newWaybillHistoryDayCount;
      end
      else begin
        CanClose := False;
        AProc.MessageBox(
          Format('����������, �������������� �������� � ���� "%s".'#13#10
            + '��� ������ ���� ����� ������.',
            [lWaybillsHistoryDayCount.Caption]),
          MB_ICONWARNING);
        PageControl.ActivePage := tshOther;
        eWaybillsHistoryDayCount.SetFocus;
      end;
    end;

    if CanClose then begin
      if TryStrToInt(eNewRejectsDayCount.Text, outInt) and (outInt > 0) then begin
        FGlobalSettingParams.NewRejectsDayCount := outInt;
      end
      else begin
        CanClose := False;
        AProc.MessageBox(
          Format('����������, �������������� �������� � ���� "%s".'#13#10
            + '��� ������ ���� ����� ������ ������ 0.',
            [lNewRejectsDayCount.Caption]),
          MB_ICONWARNING);
        PageControl.ActivePage := tshVisualization;
        eNewRejectsDayCount.SetFocus;
      end;
    end;
  end;
end;

procedure TConfigForm.OnAppEx(Sender: TObject; E: Exception);
begin
  if Assigned(Sender) then
    Tracer.TR('Config', 'Sender = ' + Sender.ClassName)
  else
    Tracer.TR('Config', 'Sender = nil');
  Tracer.TR('Config', 'AppEx : ' + E.Message);
end;

procedure TConfigForm.dbeHistoryDayCountChange(Sender: TObject);
var
  currentValue : Integer;
begin
  currentValue := StrToIntDef(dbeHistoryDayCount.Text, udHistoryDayCount.Min);
  if (currentValue >= udHistoryDayCount.Min) and (currentValue <= udHistoryDayCount.Max)
  then
    udHistoryDayCount.Position := currentValue;
end;

procedure TConfigForm.udHistoryDayCountClick(Sender: TObject;
  Button: TUDBtnType);
begin
  dbeHistoryDayCount.Field.AsInteger := udHistoryDayCount.Position;
end;

procedure TConfigForm.eHTTPPassChange(Sender: TObject);
begin
  HTTPPassChanged := True;
end;

procedure TConfigForm.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  FNetworkParams := TNetworkParams.Create(DM.MainConnection);
  FGlobalSettingParams := TGlobalSettingParams.Create(DM.MainConnection);
  inherited;
  AddBottomPanel;
  AddVitallyImportantMarkups;
  AddRetailMarkups;
  AddNDS18Markups;
  AddEditAddressSheet;
  AddWaybillFoldersSheet;
  AddNetworkVersionSettings();
  AddLegendsSettings();
  ChangeVisualization();

  for I := 0 to PageControl.PageCount-1 do begin
    if PageControl.Pages[i].Constraints.MinHeight > PageControl.ClientHeight then
      PageControl.ClientHeight := PageControl.Pages[i].Constraints.MinHeight;
    if PageControl.Pages[i].Constraints.MinWidth > PageControl.ClientWidth then
      PageControl.ClientWidth := PageControl.Pages[i].Constraints.MinWidth;
  end;

  PageControl.Constraints.MinHeight := PageControl.Height + tshClients.Top;
  PageControl.Constraints.MinWidth := PageControl.Width;

  PageControl.Align := alClient;
  Self.ClientHeight := PageControl.Height + pButton.Height;
  Self.ClientWidth := PageControl.Width;
  Self.BorderStyle := bsDialog;
end;

procedure TConfigForm.AddEditAddressSheet;
begin
  tsEditAddress := TTabSheet.Create(Self);
  tsEditAddress.PageControl := PageControl;
  tsEditAddress.PageIndex := tsNDS18Markups.PageIndex + 1;
  tsEditAddress.Caption := '���������';

  frameEditAddress := nil;

  if not DM.adsUser.IsEmpty and DM.adsUser.FieldByName('ParseWaybills').AsBoolean
  then begin
    frameEditAddress := TframeEditAddress.Create(Self);

    tsEditAddress.Constraints.MinHeight := frameEditAddress.Height;
    tsEditAddress.Constraints.MinWidth := frameEditAddress.Width;

    frameEditAddress.Parent := tsEditAddress;
    frameEditAddress.Align := alClient;
  end
  else
    tsEditAddress.TabVisible := False;
end;

procedure TConfigForm.AddLabelAndDBEdit(
  Parents : TWinControl;
  DataSource : TDataSource;
  var nextTop: Integer;
  var labelInfo: TLabel; var dbedit: TDBEdit; LabelCaption, DataField: String);
begin
  labelInfo := TLabel.Create(Self);
  labelInfo.Caption := LabelCaption;
  labelInfo.Parent := Parents;
  labelInfo.Top := nextTop;
  labelInfo.Left := 10;

  dbedit := TDBEdit.Create(Self);
  dbedit.Parent := Parents;
  dbedit.Anchors := [akLeft, akTop, akRight];
  dbedit.Top := labelInfo.Top + 3 + labelInfo.Canvas.TextHeight(labelInfo.Caption);
  dbedit.Left := 10;
  dbedit.DataSource := DataSource;
  dbedit.DataField := DataField;
  dbedit.Width := Parents.Width - 20;

  nextTop := dbedit.Top + dbedit.Height + 10;
end;

procedure TConfigForm.AddWaybillFoldersSheet;
var
  nextTop : Integer;
begin
  adsWaybillFolders := TMyQuery.Create(Self);
  adsWaybillFolders.Connection := DM.MainConnection;
  dsWaybillFolders := TDataSource.Create(Self);
  dsWaybillFolders.DataSet := adsWaybillFolders;

  tsWaybillFolders := TTabSheet.Create(Self);
  tsWaybillFolders.PageControl := PageControl;
  tsWaybillFolders.PageIndex := tsEditAddress.PageIndex + 1;
  tsWaybillFolders.Caption := '��������� �����������';

  if not DM.adsUser.IsEmpty
    and ((DM.adsUser.FieldByName('ParseWaybills').AsBoolean
    and DM.adsUser.FieldByName('SendWaybillsFromClient').AsBoolean)
    or GetNetworkSettings().IsNetworkVersion
    or FGlobalSettingParams.GroupWaybillsBySupplier)
  then begin
    OpenWaybillFoldersDataSet();

    gbWaybillFolders := TGroupBox.Create(Self);
    gbWaybillFolders.Caption := ' ��������� ����������� ';
    gbWaybillFolders.Parent := tsWaybillFolders;
    gbWaybillFolders.Align := alClient;

    lProviderId := TLabel.Create(Self);
    lProviderId.Caption := '���������:';
    lProviderId.Parent := gbWaybillFolders;
    lProviderId.Top := 16;
    lProviderId.Left := 10;

    dblProviderId := TDBLookupComboBox.Create(Self);
    dblProviderId.Parent := gbWaybillFolders;
    dblProviderId.Anchors := [akLeft, akTop, akRight];
    dblProviderId.Top := lProviderId.Top + 3 + lProviderId.Canvas.TextHeight(lProviderId.Caption);
    dblProviderId.Left := lProviderId.Left;
    dblProviderId.Width := gbWaybillFolders.Width - 20;
    dblProviderId.DataField := 'FirmCode';
    dblProviderId.KeyField := 'FirmCode';
    dblProviderId.ListField := 'FullName';
    dblProviderId.ListSource := dsWaybillFolders;
    dblProviderId.KeyValue := adsWaybillFolders.FieldByName('FirmCode').Value;

    nextTop := dblProviderId.Top + dblProviderId.Height + 10;

    if FGlobalSettingParams.GroupWaybillsBySupplier then begin
      AddControlsToChangeFolder(
        gbWaybillFolders,
        dsWaybillFolders,
        nextTop,
        lWaybillUnloadingFolder,
        dbeWaybillUnloadingFolder,
        '����� ��� ������������ ���������:',
        'WaybillUnloadingFolder',
        WaybillUnloadingFolderChange,
        sbSelectWaybillUnloadingFolder,
        SelectWaybillUnloadingFolderClick,
        lWaybillUnloadingFolderNotExists
      );

      nextTop := lWaybillUnloadingFolderNotExists.Top + lWaybillUnloadingFolderNotExists.Height + 10;
    end;

    if DM.adsUser.FieldByName('SendWaybillsFromClient').AsBoolean then begin
      AddControlsToChangeFolder(
        gbWaybillFolders,
        dsWaybillFolders,
        nextTop,
        lWaybillFolder,
        dbeWaybillFolder,
        '����� ��� �������� ���������:',
        'WaybillFolder',
        WaybillFolderChange,
        sbSelectFolder,
        SelectFolderClick,
        lFolderNotExists
      );
      nextTop := lFolderNotExists.Top + lFolderNotExists.Height + 10;
    end;

    if GetNetworkSettings().IsNetworkVersion then begin

      AddControlsToChangeFolder(
        gbWaybillFolders,
        dsWaybillFolders,
        nextTop,
        lOrderFolder,
        dbeOrderFolder,
        '����� ��� ������� �������:',
        'OrderFolder',
        OrderFolderChange,
        sbSelectOrderFolder,
        SelectOrderFolderClick,
        lOrderFolderNotExists
      );
    end;
  end
  else
    tsWaybillFolders.TabVisible := False;
end;

procedure TConfigForm.SelectFolderClick(Sender: TObject);
var
  DirName : String;
begin
  DirName := adsWaybillFolders.FieldByName('WaybillFolder').AsString;
  if DirName = '' then
    DirName := '.'
  else
    DirName := GetFullFileNameByPrefix(DirName, RootFolder());

  if FileCtrl.SelectDirectory(
       '�������� ���������� ��� �������� ��������� ���������� ' + adsWaybillFolders.FieldByName('FullName').AsString,
       '',
       DirName)
  then begin
    DirName := GetShortFileNameWithPrefix(DirName, RootFolder());
    SoftEdit(adsWaybillFolders);
    adsWaybillFolders.FieldByName('WaybillFolder').AsString := DirName;
  end;
end;

procedure TConfigForm.WaybillFolderChange(Sender: TObject);
var
  dirName : String;
begin
  dirName := dbeWaybillFolder.Text;
  dirName := GetFullFileNameByPrefix(dirName, RootFolder());
  lFolderNotExists.Visible := not DirectoryExists(dirName);
end;

procedure TConfigForm.AddVitallyImportantMarkups;
begin
  tsVitallyImportantMarkups := TTabSheet.Create(Self);
  tsVitallyImportantMarkups.PageControl := PageControl;
  tsVitallyImportantMarkups.PageIndex := 0;
  tsVitallyImportantMarkups.Caption := '������� �����';

  frameEditVitallyImportantMarkups := TframeEditVitallyImportantMarkups
    .CreateFrame(Self, doiVitallyImportantMarkups, DM.LoadVitallyImportantMarkups);

  tsVitallyImportantMarkups.Constraints.MinHeight := frameEditVitallyImportantMarkups.Height;
  tsVitallyImportantMarkups.Constraints.MinWidth := frameEditVitallyImportantMarkups.Width;

  frameEditVitallyImportantMarkups.Parent := tsVitallyImportantMarkups;
  frameEditVitallyImportantMarkups.Align := alClient;
end;

procedure TConfigForm.AddRetailMarkups;
begin
  tshClients.PageIndex := 1;
  frameEditRetailMarkups := TframeEditVitallyImportantMarkups
    .CreateFrame(Self, doiRetailMargins, DM.LoadRetailMargins);

  tshClients.Constraints.MinHeight := frameEditRetailMarkups.Height;
  tshClients.Constraints.MinWidth := frameEditRetailMarkups.Width;

  frameEditRetailMarkups.Parent := tshClients;
  frameEditRetailMarkups.Align := alClient;
end;

procedure TConfigForm.AddBottomPanel;
begin
  pButton := TPanel.Create(Self);
  pButton.Parent := Self;
  pButton.Align := alBottom;
  pButton.Caption := '';
  pButton.BevelOuter := bvNone;

  btnOk.Parent := pButton;
  pButton.Height := btnOk.Height + 20;
  btnOk.Left := 10;
  btnOk.Top := 10;

  btnCancel.Parent := pButton;
  btnCancel.Caption := '��������';
  btnCancel.Left := 10 + btnOk.Width + 10;
  btnCancel.Top := 10;
end;

procedure TConfigForm.OrderFolderChange(Sender: TObject);
begin
  lOrderFolderNotExists.Visible := not DirectoryExists(dbeOrderFolder.Text);
end;

procedure TConfigForm.SelectOrderFolderClick(Sender: TObject);
var
  DirName : String;
begin
  DirName := adsWaybillFolders.FieldByName('OrderFolder').AsString;

  if FileCtrl.SelectDirectory(
       '�������� ���������� ������� ��� ���������� ' + adsWaybillFolders.FieldByName('FullName').AsString,
       '',
       DirName)
  then begin
    SoftEdit(adsWaybillFolders);
    adsWaybillFolders.FieldByName('OrderFolder').AsString := DirName;
  end;
end;

procedure TConfigForm.AddNetworkVersionSettings;
var
  controlInterval : Integer;
  nextTop : Integer;
begin
  controlInterval := dbchbConfirmSendingOrders.Top - dbchbConfirmSendingOrders.Height - dbchbPrintOrdersAfterSend.Top;
  if GetNetworkSettings().IsNetworkVersion then begin
    gbNetworkVersionSettings := TGroupBox.Create(Self);
    gbNetworkVersionSettings.Parent := tshOther;
    gbNetworkVersionSettings.Caption := ' ������� ������ ';
    gbNetworkVersionSettings.Left := gbDeleteHistory.Left;
    gbNetworkVersionSettings.Width := gbDeleteHistory.Width;
    gbNetworkVersionSettings.Anchors := gbDeleteHistory.Anchors;
    gbNetworkVersionSettings.Top := dbchbConfirmSendingOrders.Top + dbchbConfirmSendingOrders.Height + controlInterval;

    nextTop := 16;

    AddLabelAndEdit(gbNetworkVersionSettings, nextTop, lExportPricesFolder, eExportPricesFolder, '����� ��� �������� �����-������:');
    eExportPricesFolder.Text := FNetworkParams.NetworkExportPricesFolder;

    AddLabelAndEdit(gbNetworkVersionSettings, nextTop, lPositionPercent, ePositionPercent, '���������� ������� ��������� ���� ��� ������:');
    ePositionPercent.Text := FloatToStr(FNetworkParams.NetworkPositionPercent);

    gbNetworkVersionSettings.Height := ePositionPercent.Top + ePositionPercent.Height + 5;

    lblServerLink.Top := gbNetworkVersionSettings.Top + gbNetworkVersionSettings.Height + controlInterval;
    tshOther.Constraints.MinHeight := lblServerLink.Top + lblServerLink.Height + 5;
  end
  else begin
    nextTop := dbchbConfirmSendingOrders.Top + dbchbConfirmSendingOrders.Height + controlInterval;

    chbGroupWaybillsBySupplier := TCheckBox.Create(Self);
    chbGroupWaybillsBySupplier.Caption := '������������ ����� ��������� �� ����������';
    chbGroupWaybillsBySupplier.Parent := tshOther;
    chbGroupWaybillsBySupplier.Top := nextTop;
    chbGroupWaybillsBySupplier.Left := dbchbConfirmSendingOrders.Left;
    chbGroupWaybillsBySupplier.Anchors := [akLeft, akTop, akRight];
    chbGroupWaybillsBySupplier.Width := tshOther.Width - 20;
    chbGroupWaybillsBySupplier.Checked := FGlobalSettingParams.GroupWaybillsBySupplier;

    eWaybillsHistoryDayCount.Text := IntToStr(FGlobalSettingParams.WaybillsHistoryDayCount);
    chbConfirmDeleteOldWaybills.Checked := FGlobalSettingParams.ConfirmDeleteOldWaybills;

    lblServerLink.Top := chbGroupWaybillsBySupplier.Top + chbGroupWaybillsBySupplier.Height + controlInterval;
    tshOther.Constraints.MinHeight := lblServerLink.Top + lblServerLink.Height + 5;
  end;
end;

procedure TConfigForm.AddLabelAndEdit(Parents: TWinControl;
  var nextTop: Integer; var labelInfo: TLabel; var edit: TEdit;
  LabelCaption: String);
begin
  labelInfo := TLabel.Create(Self);
  labelInfo.Caption := LabelCaption;
  labelInfo.Parent := Parents;
  labelInfo.Top := nextTop;
  labelInfo.Left := 10;

  edit := TEdit.Create(Self);
  edit.Parent := Parents;
  edit.Anchors := [akLeft, akTop, akRight];
  edit.Top := labelInfo.Top + 3 + labelInfo.Canvas.TextHeight(labelInfo.Caption);
  edit.Left := 10;
  edit.Width := Parents.Width - 20;

  nextTop := edit.Top + edit.Height + 10;
end;

procedure TConfigForm.AddControlsToChangeFolder(Parents: TWinControl;
  DataSource: TDataSource; var nextTop: Integer; var labelInfo: TLabel;
  var dbedit: TDBEdit; LabelCaption, DataField: String;
  OnChangeFolder: TNotifyEvent; var selectFolderButton: TSpeedButton;
  OnSelectFolderClick: TNotifyEvent; var folderNotExistsLabel: TLabel);
begin
  AddLabelAndDBEdit(Parents, DataSource, nextTop, labelInfo, dbedit, LabelCaption, DataField);
  dbedit.OnChange := OnChangeFolder;

  selectFolderButton := TSpeedButton.Create(Self);
  selectFolderButton.Parent := Parents;
  selectFolderButton.Anchors := [akTop, akRight];
  selectFolderButton.Top := dbedit.Top;
  selectFolderButton.Height := dbedit.Height;
  selectFolderButton.Caption := '...';
  selectFolderButton.Width := selectFolderButton.Height;
  selectFolderButton.Left := dbedit.Left + dbedit.Width - selectFolderButton.Width;
  dbedit.Width := dbedit.Width - selectFolderButton.Width - 5;
  selectFolderButton.OnClick := OnSelectFolderClick;

  folderNotExistsLabel := TLabel.Create(Self);
  folderNotExistsLabel.Caption := '����� �� ���������� � ����� �������';
  folderNotExistsLabel.Parent := Parents;
  folderNotExistsLabel.Top := selectFolderButton.Top + selectFolderButton.Height + 10;
  folderNotExistsLabel.Left := 10;
  folderNotExistsLabel.Visible := False;
  folderNotExistsLabel.Font.Color := clRed;
end;

procedure TConfigForm.WaybillUnloadingFolderChange(Sender: TObject);
var
  dirName : String;
begin
  dirName := dbeWaybillUnloadingFolder.Text;
  dirName := GetFullFileNameByPrefix(dirName, RootFolder());
  lWaybillUnloadingFolderNotExists.Visible := not DirectoryExists(dirName);
end;

procedure TConfigForm.SelectWaybillUnloadingFolderClick(Sender: TObject);
var
  DirName : String;
begin
  DirName := adsWaybillFolders.FieldByName('WaybillUnloadingFolder').AsString;
  if DirName = '' then
    DirName := '.'
  else
    DirName := GetFullFileNameByPrefix(DirName, RootFolder());

  if FileCtrl.SelectDirectory(
       '�������� ���������� ��� ������������ ��������� ���������� ' + adsWaybillFolders.FieldByName('FullName').AsString,
       '',
       DirName)
  then begin
    DirName := GetShortFileNameWithPrefix(DirName, RootFolder());
    SoftEdit(adsWaybillFolders);
    adsWaybillFolders.FieldByName('WaybillUnloadingFolder').AsString := DirName;
  end;
end;

procedure TConfigForm.CreateFolders;

  procedure AddFolder(ProviderName, DirName, FolderName : String);
  begin
    try
      if not SysUtils.DirectoryExists(DirName) then
        if not SysUtils.ForceDirectories(DirName) then
          RaiseLastOSError;
    except
      on E : Exception do
        WriteExchangeLog('CreateFolders',
          Format('�� ���������� ������� %s ��� ���������� %s: %s',
            [FolderName,
            ProviderName,
            ExceptionToString(E)]));
    end;
  end;

begin
  adsWaybillFolders.First;
  while not adsWaybillFolders.Eof do begin
    if FGlobalSettingParams.GroupWaybillsBySupplier
      and (Length(adsWaybillFolders.FieldByName('WaybillUnloadingFolder').AsString) > 0)
    then
      AddFolder(
        adsWaybillFolders.FieldByName('FullName').AsString,
        GetFullFileNameByPrefix(adsWaybillFolders.FieldByName('WaybillUnloadingFolder').AsString, RootFolder()),
        '����� ��� ������������ ���������'
      );

    if DM.adsUser.FieldByName('SendWaybillsFromClient').AsBoolean
      and (Length(adsWaybillFolders.FieldByName('WaybillFolder').AsString) > 0)
    then
      AddFolder(
        adsWaybillFolders.FieldByName('FullName').AsString,
        GetFullFileNameByPrefix(adsWaybillFolders.FieldByName('WaybillFolder').AsString, RootFolder()),
        '����� ��� �������� ���������'
      );

    if GetNetworkSettings().IsNetworkVersion
      and (Length(adsWaybillFolders.FieldByName('OrderFolder').AsString) > 0)
    then
      AddFolder(
        adsWaybillFolders.FieldByName('FullName').AsString,
        adsWaybillFolders.FieldByName('OrderFolder').AsString,
        '����� ��� ������� �������'
      );
    adsWaybillFolders.Next;  
  end;
end;

procedure TConfigForm.ChangeVisualization;
var
  controlInterval : Integer;
  nextTop : Integer;
begin
  controlInterval := dbchbGroupByProducts.Top - dbchbGroupByProducts.Height - DBCheckBox2.Top;
  nextTop := dbchbGroupByProducts.Top + dbchbGroupByProducts.Height + controlInterval;

  AddLabelAndEdit(tshVisualization, nextTop, lPositionPercent, ePositionPercent, '���������� ������� ��������� ���� ��� �������������� ������:');
  ePositionPercent.Text := FloatToStr(FNetworkParams.NetworkPositionPercent);

  AddLabelAndEdit(tshVisualization, nextTop, lBaseFirmCategory, eBaseFirmCategory, '�������� � �������� ������ ����������� ������� �:');
  eBaseFirmCategory.Text := IntToStr(FGlobalSettingParams.BaseFirmCategory);

  AddLabelAndEdit(tshVisualization, nextTop, lExcess, eExcess, '������������� � ���������� ������� ���� ������� �� (%):');
  eExcess.Text := IntToStr(FGlobalSettingParams.Excess);

  AddLabelAndEdit(tshVisualization, nextTop, lExcessAvgOrderTimes, eExcessAvgOrderTimes, '������������� � ���������� �������� ���������� �� ������. ������� � (���):');
  eExcessAvgOrderTimes.Text := IntToStr(FGlobalSettingParams.ExcessAvgOrderTimes);

  AddLabelAndCombo(tshVisualization, nextTop, lDeltaMode, cbDeltaMode, '������ ������� � ������� �����������:');
  cbDeltaMode.Style := csDropDownList;
  cbDeltaMode.Items.Clear;
  cbDeltaMode.Items.Add('�� ����������� �����������');
  cbDeltaMode.Items.Add('�� ����������� ����');
  cbDeltaMode.Items.Add('�� ����������� ���� � �������� �����������');
  cbDeltaMode.ItemIndex := FGlobalSettingParams.DeltaMode;

  chbShowPriceName := TCheckBox.Create(Self);
  chbShowPriceName.Caption := '������ ���������� �������� �����-������';
  chbShowPriceName.Parent := tshVisualization;
  chbShowPriceName.Top := nextTop;
  chbShowPriceName.Left := dbchbGroupByProducts.Left;
  chbShowPriceName.Anchors := [akLeft, akTop, akRight];
  chbShowPriceName.Width := tshVisualization.Width - 20;
  chbShowPriceName.Checked := FGlobalSettingParams.ShowPriceName;

  chbUseColorOnWaybillOrders := TCheckBox.Create(Self);
  chbUseColorOnWaybillOrders.Caption := '�������� ������ ���������������� ������� �������';
  chbUseColorOnWaybillOrders.Parent := tshVisualization;
  chbUseColorOnWaybillOrders.Top := chbShowPriceName.Top + chbShowPriceName.Height + 10;
  chbUseColorOnWaybillOrders.Left := dbchbGroupByProducts.Left;
  chbUseColorOnWaybillOrders.Anchors := [akLeft, akTop, akRight];
  chbUseColorOnWaybillOrders.Width := tshVisualization.Width - 20;
  chbUseColorOnWaybillOrders.Checked := FGlobalSettingParams.UseColorOnWaybillOrders;

  nextTop := chbUseColorOnWaybillOrders.Top + chbUseColorOnWaybillOrders.Height + controlInterval;
  AddLabelAndEdit(tshVisualization, nextTop, lNewRejectsDayCount, eNewRejectsDayCount, '���������� ������ ��������� � ���������� �� (���):');
  eNewRejectsDayCount.Text := IntToStr(FGlobalSettingParams.NewRejectsDayCount);

  tshVisualization.Constraints.MinHeight := eNewRejectsDayCount.Top + eNewRejectsDayCount.Height + controlInterval;
end;

procedure TConfigForm.AddLabelAndCombo(Parents: TWinControl;
  var nextTop: Integer; var labelInfo: TLabel; var combo: TComboBox;
  LabelCaption: String);
begin
  labelInfo := TLabel.Create(Self);
  labelInfo.Caption := LabelCaption;
  labelInfo.Parent := Parents;
  labelInfo.Top := nextTop;
  labelInfo.Left := 10;

  combo := TComboBox.Create(Self);
  combo.Parent := Parents;
  combo.Anchors := [akLeft, akTop, akRight];
  combo.Top := labelInfo.Top + 3 + labelInfo.Canvas.TextHeight(labelInfo.Caption);
  combo.Left := 10;
  combo.Width := Parents.Width - 20;

  nextTop := combo.Top + combo.Height + 10;
end;

procedure TConfigForm.AddLegendsSettings;
begin
  tsLegendsSettings := TTabSheet.Create(Self);
  tsLegendsSettings.PageControl := PageControl;
  tsLegendsSettings.PageIndex := tsWaybillFolders.PageIndex + 1;
  tsLegendsSettings.Caption := '��������� ������';

  dsLegends := TDataSource.Create(Self);
  dsLegends.DataSet := LegendHolder.GetDataSet();

  dsLegends.DataSet.First;

  dbgLegends := TToughDBGrid.Create(Self);
  dbgLegends.Parent := tsLegendsSettings;
  dbgLegends.Align := alClient;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgLegends);

  TDBGridHelper.AddColumn(dbgLegends, 'Name', '�������', True);
  dbgLegends.AutoFitColWidths := True;

  dbgLegends.OnGetCellParams := LegendsGetCellParams;
  dbgLegends.OnDblClick := LegendsDblClick;
  dbgLegends.DataSource := dsLegends;
end;

procedure TConfigForm.LegendsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  db : TToughDBGrid;
  applying : TLegendApplying;
  legendColor : TColor;
begin
  if Sender is TToughDBGrid then begin
    db := TToughDBGrid(Sender);
    applying := TLegendApplying(db.DataSource.DataSet.FieldByName('LegendApplying').AsInteger);
    legendColor := TColor(TLargeintField(db.DataSource.DataSet.FieldByName('Color')).AsLargeInt);
    if applying = laBackground then
      Background := legendColor
    else
      AFont.Color := legendColor
  end;
end;

procedure TConfigForm.LegendsDblClick(Sender: TObject);
var
  color : TColor;
  dataSet : TDataSet;
begin
  if (Sender is TToughDBGrid) then begin
    dataSet := TToughDBGrid(Sender).DataSource.DataSet;
    color := TColor(TLargeintField(dataSet.FieldByName('Color')).AsLargeInt);
    LegendColorDialog.Color := color;
    if LegendColorDialog.Execute then begin
      dataSet.Edit();
      TLargeintField(dataSet.FieldByName('Color')).AsLargeInt := LegendColorDialog.Color;
      dataSet.Post;
      dbgLegends.Invalidate;
    end;
  end;
end;

procedure TConfigForm.bbTestConnectionClick(Sender: TObject);
var
  state : TCheckTCPResult;
  connectionMessage : String;

  function SpeedToTextLevel(speed : Int64) : String;
  const
    B = 1; //byte
    KB = 1024 * B; //kilobyte
    MB = 1024 * KB; //megabyte
    GB = 1024 * MB; //gigabyte
  begin
    Result := '';
    speed := speed * 8;
    if speed < 10 * KB then
      Result := '�������'
    else
    if (10 * KB <= speed) and (speed <= 200 * KB) then
      Result := '����'
    else
    if (200 * KB < speed) and (speed <= 1024 * KB) then
      Result := '���'
    else
    if (1024 * KB < speed) then
      Result := '���';
  end;

begin
  state := CheckTCPConnection(
    dbcbRasConnect.Checked,
    cbRas.Text,
    dbeRasName.Field.AsString,
    dbeRasPass.Field.AsString,
    StrToIntDef(dbeRasSleep.Field.AsString, 5),
    dbcbProxyConnect.Checked,
    dbeProxyName.Field.AsString,
    StrToIntDef(dbeProxyPort.Field.AsString, 3128),
    dbeProxyUserName.Field.AsString,
    dbeProxyPass.Field.AsString
  );
  if state.Error then
    AProc.MessageBox(
        '� �������� ����� ���������� �������� ������.'#13#10
        + '����������, ��������� �� ������� ����������� ��������� ��� ��������� ����������.',
        MB_ICONERROR)
  else begin
    connectionMessage :=
      '���������� ����� ����������:'#13#10+
      '  - ������ � ����� 80: ' + IfThen(state.connectTo80, 'OK', '��� �������') + #13#10 +
      '  - ������ � ����� 443: ' + IfThen(state.connectTo443, 'OK', '��� �������') + #13#10 +
      '  - �������� �����������: ' + SpeedToTextLevel(state.downloadSpeed) + ' (' + FormatSpeedSize(state.downloadSpeed) + ')';
    AProc.MessageBox(connectionMessage, MB_ICONINFORMATION);
  end;
end;

procedure TConfigForm.OpenWaybillFoldersDataSet;
begin
  //��������� ���� ���
  adsWaybillFolders.CachedUpdates := True;
  adsWaybillFolders.SQL.Text := ''
    + 'select '
    + ' Providers.FirmCode, '
    + ' Providers.FullName, '
    + ' ProviderSettings.WaybillFolder, '
    + ' ProviderSettings.OrderFolder, '
    + ' ProviderSettings.WaybillUnloadingFolder '
    + 'from '
    + '  Providers '
    + '  inner join ProviderSettings on ProviderSettings.FirmCode = Providers.FirmCode '
    + 'order by Providers.FullName ';
  adsWaybillFolders.SQLUpdate.Text := ''
    + 'update ProviderSettings '
    + 'set '
    + '  WaybillFolder = :WaybillFolder, '
    + '  OrderFolder = :OrderFolder, '
    + '  WaybillUnloadingFolder = :WaybillUnloadingFolder '
    + 'where '
    + ' FirmCode = :FirmCode';
  adsWaybillFolders.Open;
end;

procedure TConfigForm.AddNDS18Markups;
begin
  tsNDS18Markups := TTabSheet.Create(Self);
  tsNDS18Markups.PageControl := PageControl;
  tsNDS18Markups.PageIndex := tshClients.PageIndex + 1;
  tsNDS18Markups.Caption := '������� ������ � 18% ���';

  frameEditNDS18Markups := TframeEditVitallyImportantMarkups
    .CreateFrame(Self, doiRetailMargins, DM.LoadRetailMargins, 'frameEditRetailNDS18Markups');

  tsNDS18Markups.Constraints.MinHeight := frameEditNDS18Markups.Height;
  tsNDS18Markups.Constraints.MinWidth := frameEditNDS18Markups.Width;

  frameEditNDS18Markups.Parent := tsNDS18Markups;
  frameEditNDS18Markups.Align := alClient;
end;

end.

