unit Config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, ComCtrls, DBCtrls, Mask, Menus, DBGridEh, ShellAPI,
  Buttons, ExtCtrls, ToughDBGrid, DB, RxMemDS, DModule, GridsEh, U_VistaCorrectForm,
  MyAccess, FileCtrl, U_frameEditVitallyImportantMarkups, U_frameEditAddress,
  DatabaseObjects;

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
    DBCheckBox2: TDBCheckBox;
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
    dbchbGroupByProducts: TDBCheckBox;
    dbchbPrintOrdersAfterSend: TDBCheckBox;
    dbchbConfirmSendingOrders: TDBCheckBox;
    dbchbUseCorrectOrders: TDBCheckBox;
    pHTTP: TPanel;
    gbHTTP: TGroupBox;
    Label1: TLabel;
    dbeHTTPHost: TDBEdit;
    pAccount: TPanel;
    gbAccount: TGroupBox;
    Label4: TLabel;
    Label3: TLabel;
    dbeHTTPName: TDBEdit;
    dbeHTTPPass: TDBEdit;
    eHTTPPass: TEdit;
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
  private
    HTTPNameChanged, HTTPPassChanged : Boolean;
    OldHTTPName : String;
    OldHTTPHost : String;
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
    procedure AddWaybillFoldersSheet;
    procedure SelectFolderClick(Sender : TObject);
    procedure WaybillFolderChange(Sender : TObject);
    procedure AddVitallyImportantMarkups;
    procedure AddRetailMarkups;
    procedure AddBottomPanel;
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

    tsVitallyImportantMarkups : TTabSheet;
    frameEditVitallyImportantMarkups : TframeEditVitallyImportantMarkups;

    frameEditRetailMarkups : TframeEditVitallyImportantMarkups;

    pButton : TPanel;
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
  //вид дочерних форм зависит от параметров, поэтому закрываем окна
  MainForm.FreeChildForms;
  with TConfigForm.Create(Application) do try

{
    oldKbd := GetKeyboardHelper.GetCurrentKeyboard();
    //Если текущая клавиатура не английская, то переключаемся на английскую
    if oldKbd <> GetKeyboardHelper.EnglishKeyboard then
      GetKeyboardHelper.SwitchToEnglish();
}
    //Вроде бы заработало простое переключение, если и дальше будет работать,
    //то код в комментарии выше надо удалить
    oldKbd := GetKeyboardHelper.SwitchToEnglish();
      
    OldExep := Application.OnException;
    try
      Application.OnException := OnAppEx;
      HTTPNameChanged := False;
      OldHTTPName := dbeHTTPName.Field.AsString;
      OldHTTPHost := dbeHTTPHost.Field.AsString;
      dbchbPrintOrdersAfterSend.Enabled := (DM.SaveGridMask and PrintSendedOrder) > 0;
{$ifndef DSP}
      //Если в параметрах программы нет ключа "extd", то скрываем настройку "Хост"
      if (not FindCmdLineSwitch('extd')) then
        pHTTP.Visible := False;
{$endif}
      if Auth then
        PageControl.ActivePage := tshAuth
      else
        PageControl.ActivePageIndex := 0;

      //читаем параметры соединения
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
              'Ошибка при расшифровке строки "%s" : %s',
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

        if adsWaybillFolders.Active then begin
          SoftPost(adsWaybillFolders);
          adsWaybillFolders.ApplyUpdates;
          DatabaseController.BackupDataTable(doiProviderSettings);
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
              'Изменился пароль. Пароль: "%s"  Зашифрованный : "%s"  В датасет : "%s"',
              [NewPass,
              CryptNewPass,
              DM.adtParams.FieldByName('HTTPPass').AsString]));
}              
        end;
        if HTTPNameChanged and (OldHTTPName <> dbeHTTPName.Field.AsString) then begin
          Result := Result + [ccHTTPName];
          DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean := True;
          MainForm.DisableByHTTPName;
          // удаляем все неотправленные открытые заявки
          DM.adcUpdate.SQL.Text := ''
           + ' delete CurrentOrderHeads, CurrentOrderLists'
           + ' FROM CurrentOrderHeads, CurrentOrderLists '
           + ' where '
           + '    (Closed = 0)'
           + ' and (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId)';
          DM.adcUpdate.Execute;
          //удаляем изменения в настройках прайс-листов
          DM.adcUpdate.SQL.Text := 'truncate pricesregionaldataup';
          DM.adcUpdate.Execute;
        end;
        if (OldHTTPHost <> dbeHTTPHost.Field.AsString) then
          Result := Result + [ccHTTPHost];
        DM.adtParams.Post;
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
      //Если до переключения была не английская, то переключаемся обратно
      if oldKbd <> GetKeyboardHelper.EnglishKeyboard then
        GetKeyboardHelper.SwitchToPrev;
}        
      //Вроде бы заработало простое переключение, если и дальше будет работать,
      //то код в комментарии выше надо удалить
      GetKeyboardHelper.SwitchToLanguage(oldKbd);

      Application.OnException := OldExep;
    end;

  finally
    Free;
  end;
  //если RollBack - надо освежить
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
  //если нажать Enter в поле кода dbeID, то значение не заносится, поэтому перемещаем фокус
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
  if (cbRas.ItemIndex>=0)and(AProc.MessageBox('Удалить удаленное соединение?',
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
  AProc.MessageBox('Изменения вступят в силу после получения данных', MB_OK or MB_ICONWARNING);
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
begin
  if (ModalResult = mrOK) then begin
    if HTTPNameChanged and (OldHTTPName <> dbeHTTPName.Field.AsString) then begin
      if MainForm.CheckUnsendOrders and
         (AProc.MessageBox('Изменение имени авторизации удалит все неотправленные заказы. Продолжить?' , MB_ICONQUESTION or MB_YESNO) <> IDYES)
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
        AProc.MessageBox('Не задано удаленное соединение.', MB_ICONWARNING);
      end;
      if CanClose then begin
        DM.Ras.Entry:=cbRas.Items[cbRas.ItemIndex];
        if (DM.Ras.GetEntryIndex < 0) then begin
          CanClose := False;
          PageControl.ActivePage := tshConnect;
          cbRas.SetFocus;
          AProc.MessageBox('Удаленное соединение не существует.', MB_ICONWARNING);
        end;
      end;
    end;
    if CanClose
      and ((dbeHistoryDayCount.Field.AsInteger < udHistoryDayCount.Min)
          or (dbeHistoryDayCount.Field.AsInteger > udHistoryDayCount.Max))
    then begin
      CanClose := False;
      AProc.MessageBox(
        Format('Пожалуйста, скорректируйте значение в поле "%s".'#13#10
          + 'Оно должно быть в диапазоне [%d, %d].',
          [lHistoryDayCount.Caption,
           udHistoryDayCount.Min,
           udHistoryDayCount.Max]),
        MB_ICONWARNING);
      PageControl.ActivePage := tshOther;
      dbeHistoryDayCount.SetFocus;
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
  inherited;
  AddBottomPanel;
  AddRetailMarkups;
  AddVitallyImportantMarkups;
  AddEditAddressSheet;
  AddWaybillFoldersSheet;

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
  tsEditAddress.PageIndex := tsVitallyImportantMarkups.PageIndex + 1;
  tsEditAddress.Caption := 'Накладные';

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
  tsWaybillFolders.Caption := 'Настройки поставщиков';

  if not DM.adsUser.IsEmpty
    and DM.adsUser.FieldByName('ParseWaybills').AsBoolean
    and DM.adsUser.FieldByName('SendWaybillsFromClient').AsBoolean
  then begin
    //Открываем дата сет
    adsWaybillFolders.CachedUpdates := True;
    adsWaybillFolders.SQL.Text := ''
      + 'select '
      + ' Providers.FirmCode, '
      + ' Providers.FullName, '
      + ' ProviderSettings.WaybillFolder '
      + 'from '
      + '  Providers '
      + '  inner join ProviderSettings on ProviderSettings.FirmCode = Providers.FirmCode '
      + 'order by Providers.FullName ';
    adsWaybillFolders.SQLUpdate.Text := ''
      + 'update ProviderSettings '
      + 'set '
      + '  WaybillFolder = :WaybillFolder '
      + 'where '
      + ' FirmCode = :FirmCode';
    adsWaybillFolders.Open;

    gbWaybillFolders := TGroupBox.Create(Self);
    gbWaybillFolders.Caption := ' Настройка поставщиков ';
    gbWaybillFolders.Parent := tsWaybillFolders;
    gbWaybillFolders.Align := alClient;

    lProviderId := TLabel.Create(Self);
    lProviderId.Caption := 'Поставщик:';
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

    AddLabelAndDBEdit(gbWaybillFolders, dsWaybillFolders, nextTop, lWaybillFolder, dbeWaybillFolder, 'Папка:', 'WaybillFolder');
    dbeWaybillFolder.OnChange := WaybillFolderChange;

    sbSelectFolder := TSpeedButton.Create(Self);
    sbSelectFolder.Parent := gbWaybillFolders;
    sbSelectFolder.Anchors := [akTop, akRight];
    sbSelectFolder.Top := dbeWaybillFolder.Top;
    sbSelectFolder.Height := dbeWaybillFolder.Height;
    sbSelectFolder.Caption := '...';
    sbSelectFolder.Width := sbSelectFolder.Height;
    sbSelectFolder.Left := dbeWaybillFolder.Left + dbeWaybillFolder.Width - sbSelectFolder.Width;
    dbeWaybillFolder.Width := dbeWaybillFolder.Width - sbSelectFolder.Width - 5;
    sbSelectFolder.OnClick := SelectFolderClick;

    lFolderNotExists := TLabel.Create(Self);
    lFolderNotExists.Caption := 'Папка не существует';
    lFolderNotExists.Parent := gbWaybillFolders;
    lFolderNotExists.Top := sbSelectFolder.Top + sbSelectFolder.Height + 10;
    lFolderNotExists.Left := 10;
    lFolderNotExists.Visible := False;
    lFolderNotExists.Font.Color := clRed;
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
    if AnsiStartsText('.\', DirName) then
      DirName := ExePath + Copy(DirName, 3, Length(DirName));

  if FileCtrl.SelectDirectory(
       'Выберите директорию для поставщика ' + adsWaybillFolders.FieldByName('FullName').AsString,
       '',
       DirName)
  then begin
    if AnsiStartsText(ExePath, DirName) then
      DirName := '.\' + Copy(DirName, Length(ExePath) + 1 , Length(DirName));
    SoftEdit(adsWaybillFolders);
    adsWaybillFolders.FieldByName('WaybillFolder').AsString := DirName;
  end;
end;

procedure TConfigForm.WaybillFolderChange(Sender: TObject);
var
  dirName : String;
begin
  dirName := dbeWaybillFolder.Text;
  if AnsiStartsText('.\', dirName) then
    dirName := ExePath + Copy(dirName, 3, Length(dirName));
  lFolderNotExists.Visible := not DirectoryExists(dirName);
end;

procedure TConfigForm.AddVitallyImportantMarkups;
begin
  tsVitallyImportantMarkups := TTabSheet.Create(Self);
  tsVitallyImportantMarkups.PageControl := PageControl;
  tsVitallyImportantMarkups.PageIndex := 1;
  tsVitallyImportantMarkups.Caption := 'Наценки ЖНВЛС';

  frameEditVitallyImportantMarkups := TframeEditVitallyImportantMarkups
    .CreateFrame(Self, doiVitallyImportantMarkups, DM.LoadVitallyImportantMarkups);

  tsVitallyImportantMarkups.Constraints.MinHeight := frameEditVitallyImportantMarkups.Height;
  tsVitallyImportantMarkups.Constraints.MinWidth := frameEditVitallyImportantMarkups.Width;

  frameEditVitallyImportantMarkups.Parent := tsVitallyImportantMarkups;
  frameEditVitallyImportantMarkups.Align := alClient;
end;

procedure TConfigForm.AddRetailMarkups;
begin
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
  btnCancel.Caption := 'Отменить';
  btnCancel.Left := 10 + btnOk.Width + 10;
  btnCancel.Top := 10;
end;

end.

