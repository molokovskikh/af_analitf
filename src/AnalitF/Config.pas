unit Config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, ComCtrls, DBCtrls, Mask, Menus, DBGridEh, ShellAPI,
  Buttons, ExtCtrls, ToughDBGrid, DB, RxMemDS, DModule, GridsEh;

type
  TConfigForm = class(TForm)
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
    Label3: TLabel;
    dbeHTTPName: TDBEdit;
    Label4: TLabel;
    dbeHTTPPass: TDBEdit;
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
    gbHTTP: TGroupBox;
    Label1: TLabel;
    dbeHTTPHost: TDBEdit;
    gbAccount: TGroupBox;
    Label2: TLabel;
    dbeServiceName: TDBEdit;
    btnRasActions: TBitBtn;
    lblTip: TLabel;
    imgTip: TImage;
    Label9: TLabel;
    dbeRasSleep: TDBEdit;
    udRasSleep: TUpDown;
    tdbgRetailMargins: TToughDBGrid;
    btnAddRetail: TButton;
    btnDelRetail: TButton;
    lLR: TLabel;
    lLRInfo: TLabel;
    lPN: TLabel;
    lPNInfo: TLabel;
    mdRetail: TRxMemoryData;
    mdRetailID: TIntegerField;
    mdRetailLEFTLIMIT: TCurrencyField;
    mdRetailRIGHTLIMIT: TCurrencyField;
    dsRetail: TDataSource;
    mdRetailRETAIL: TIntegerField;
    lRaz: TLabel;
    lRazInfo: TLabel;
    eHTTPPass: TEdit;
    gbDeleteHistory: TGroupBox;
    Label11: TLabel;
    dbeHistoryDayCount: TDBEdit;
    udHistoryDayCount: TUpDown;
    Label16: TLabel;
    dbcbConfirmDeleteOldOrders: TDBCheckBox;
    dbchbUseOSOpenWaybill: TDBCheckBox;
    dbchbUseOSOpenReject: TDBCheckBox;
    dbchbGroupByProducts: TDBCheckBox;
    dbchbPrintOrdersAfterSend: TDBCheckBox;
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
    procedure btnAddRetailClick(Sender: TObject);
    procedure btnDelRetailClick(Sender: TObject);
    procedure tdbgRetailMarginsGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure mdRetailAfterPost(DataSet: TDataSet);
    procedure mdRetailBeforePost(DataSet: TDataSet);
    procedure dbeHistoryDayCountChange(Sender: TObject);
    procedure udHistoryDayCountClick(Sender: TObject; Button: TUDBtnType);
    procedure eHTTPPassChange(Sender: TObject);
  private
    HTTPNameChanged, HTTPPassChanged : Boolean;
    OldHTTPName : String;
    FRXRetMargins : array of TRetMass;
    RetMarginsChanges : Boolean;
    procedure GetEntries;
    procedure DisableRemoteAccess;
    procedure EnableRemoteAccess;
    procedure OnAppEx(Sender: TObject; E: Exception);
    procedure RXLoadRetailMargins;
  public
  end;

var
  ConfigForm: TConfigForm;

function ShowConfig( Auth: boolean = False): boolean;

implementation

{$R *.DFM}

uses DBProc, AProc, Main, LU_Tracer, Constant;

function ShowConfig( Auth: boolean = False): boolean;
var
	IsRasPresent: boolean;
  OldExep : TExceptionEvent;
  HTTPPass : String;
  NewPass,
  CryptNewPass : String;
begin
  MainForm.FreeChildForms; //вид дочерних форм зависит от параметров
  with TConfigForm.Create(Application) do try
    OldExep := Application.OnException;
    try
      Application.OnException := OnAppEx;
      HTTPNameChanged := False;
      OldHTTPName := dbeHTTPName.Field.AsString;
      dbchbPrintOrdersAfterSend.Enabled := (DM.SaveGridMask and PrintSendedOrder) > 0;
{$ifndef DSP}
      gbHTTP.Visible := False;
      gbAccount.Top := 8;
{$endif}
      if Auth then
        PageControl.ActivePageIndex := 2
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
      mdRetail.LoadFromDataSet(DM.adsRetailMargins, 0, lmAppend);
      RXLoadRetailMargins;
      RetMarginsChanges := False;
      Result := ShowModal=mrOk;
      if Result then begin
        DM.adtParams.FieldByName('RasEntry').AsString := cbRas.Items[cbRas.ItemIndex];
        if HTTPPassChanged then begin
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
          DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean := True;
          MainForm.DisableByHTTPName;
          // удаляем все неотправленные открытые заявки
          DM.adcUpdate.SQL.Text := ''
           + ' delete OrdersHead, OrdersList'
           + ' FROM OrdersHead, OrdersList '
           + ' where '
           + '    (Closed = 0)';
          DM.adcUpdate.Execute;
        end;
        DM.adtParams.Post;
        while not DM.adsRetailMargins.IsEmpty do
          DM.adsRetailMargins.Delete;
        //todo: надо восстановить
        //mdRetail.SaveToDataSet(DM.adsRetailMargins, 0);
        //DM.adsRetailMargins.ApplyUpdates;
        DM.LoadRetailMargins;
      end
      else begin
        DM.adtParams.Cancel;
        //todo: надо восстановить
        //DM.adsRetailMargins.CancelUpdates;
      end;

    finally
      Application.OnException := OldExep;
    end;

  finally
    Free;
  end;
  //если RollBack - надо освежить
  DM.adtParams.Close;
  DM.adtParams.Open;
  DM.adtClients.Close;
  DM.adtClients.Open;
  DM.adsRetailMargins.Close;
  DM.adsRetailMargins.Open;
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
  if DM.adtParams.FieldByName('RasConnect').AsBoolean then begin
    if cbRas.ItemIndex<0 then
      raise Exception.Create('Не задано удаленное соединение');
    DM.Ras.Entry:=cbRas.Items[cbRas.ItemIndex];
    if DM.Ras.GetEntryIndex<0 then
      raise Exception.Create('Удаленное соединение не существует');
  end;
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
	ShellExecute( 0, 'Open', PChar( 'https://stat.analit.net/ci/auth'),
		nil, nil, SW_SHOWDEFAULT);
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
  Res : Boolean;
  PrevRight : Currency;
begin
  if (ModalResult = mrOK) then begin
    if HTTPNameChanged and (OldHTTPName <> dbeHTTPName.Field.AsString) then begin
      if MainForm.CheckUnsendOrders and
         (AProc.MessageBox('Изменение имени авторизации удалит все неотправленные заказы. Продолжить?' , MB_ICONQUESTION or MB_YESNO) <> IDYES)
      then
        CanClose := False;
    end;
    if CanClose and RetMarginsChanges then begin
      try
        SoftPost(mdRetail);
      except
      end;
      mdRetail.SortOnFields(mdRetailLEFTLIMIT.FieldName);
      if mdRetail.RecordCount > 0 then begin
        mdRetail.First;
        Res := (not mdRetailLEFTLIMIT.IsNull) and (not mdRetailRIGHTLIMIT.IsNull) and (not mdRetailRETAIL.IsNull) and
              (mdRetailLEFTLIMIT.AsCurrency <= mdRetailRIGHTLIMIT.AsCurrency);
        PrevRight := mdRetailRIGHTLIMIT.AsCurrency;
        mdRetail.Next;
        while not mdRetail.Eof and Res do begin
          Res := PrevRight <= mdRetailLEFTLIMIT.AsCurrency;
          if Res then
            Res := (not mdRetailLEFTLIMIT.IsNull) and (not mdRetailRIGHTLIMIT.IsNull) and (not mdRetailRETAIL.IsNull) and
                  (mdRetailLEFTLIMIT.AsCurrency <= mdRetailRIGHTLIMIT.AsCurrency);
          mdRetail.Next;
        end;
        if not Res then begin
          CanClose := False;
          PageControl.ActivePage := tshClients;
          tdbgRetailMargins.SetFocus;
          AProc.MessageBox('Некорректно введены границы цен.', MB_ICONWARNING);
        end;
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

procedure TConfigForm.btnAddRetailClick(Sender: TObject);
begin
//  DM.adsRetailMargins.Append;
  mdRetail.Append;
end;

procedure TConfigForm.btnDelRetailClick(Sender: TObject);
begin
//  if not DM.adsRetailMargins.IsEmpty then
//    DM.adsRetailMargins.Delete;
  if not mdRetail.IsEmpty then
    mdRetail.Delete;
end;

procedure TConfigForm.tdbgRetailMarginsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if (mdRetailLEFTLIMIT.AsCurrency > mdRetailRIGHTLIMIT.AsCurrency) and
    ((Column.Field = mdRetailLEFTLIMIT) or (Column.Field = mdRetailLEFTLIMIT))
  then
    Background := lLR.Color;

//  if (mdRetail.RecNo = 1) then
//    PrevLimit := mdRetailRIGHTLIMIT.AsVariant;

  if (mdRetail.RecNo > 1) and (Length(FRXRetMargins) >= mdRetail.RecNo-1)
  then begin
    if (FRXRetMargins[mdRetail.RecNo-2][2] > mdRetailLEFTLIMIT.Value)
      and (Column.Field = mdRetailLEFTLIMIT)
    then
      Background := lPN.Color
    else
      if (FRXRetMargins[mdRetail.RecNo-2][2] <> mdRetailLEFTLIMIT.Value)
        and (Column.Field = mdRetailLEFTLIMIT)
      then
        Background := lRaz.Color
  end;
end;

procedure TConfigForm.mdRetailAfterPost(DataSet: TDataSet);
begin
  mdRetail.SortOnFields(mdRetailLEFTLIMIT.FieldName);
  RXLoadRetailMargins;
  RetMarginsChanges := True;
end;

procedure TConfigForm.RXLoadRetailMargins;
var
  I : Integer;
  C : Integer;
begin
  SetLength(FRXRetMargins, mdRetail.RecordCount);
  C := mdRetail.RecNo;
  try
    mdRetail.First;
    I := 0;
    while not mdRetail.Eof do begin
      FRXRetMargins[i][1] := mdRetailLEFTLIMIT.AsCurrency;
      FRXRetMargins[i][2] := mdRetailRIGHTLIMIT.AsCurrency;
      FRXRetMargins[i][3] := mdRetailRETAIL.Value;
      Inc(I);
      mdRetail.Next;
    end;
  finally
    mdRetail.RecNo := C;
  end;
end;

procedure TConfigForm.mdRetailBeforePost(DataSet: TDataSet);
begin
  if (mdRetailLEFTLIMIT.IsNull) or (mdRetailRIGHTLIMIT.IsNull) or (mdRetailRETAIL.IsNull) then
    Abort;
end;

procedure TConfigForm.dbeHistoryDayCountChange(Sender: TObject);
var
  V, E: Integer;
begin
  Val(dbeHistoryDayCount.Text,V,E);
  udHistoryDayCount.Position:=V;
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

end.

