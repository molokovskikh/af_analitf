unit Config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, ComCtrls, DBCtrls, Mask, Menus, DBGridEh, ShellAPI,
  Buttons, ExtCtrls, ToughDBGrid;

type
  TConfigForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    PageControl: TPageControl;
    tshAuth: TTabSheet;
    tshClients: TTabSheet;
    btnClientsEdit: TButton;
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
    procedure btnClientsEditClick(Sender: TObject);
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
  private
    HTTPNameChanged : Boolean;
    OldHTTPName : String;
    PrevLimit : Variant;
    procedure GetEntries;
    procedure DisableRemoteAccess;
    procedure EnableRemoteAccess;
    procedure OnAppEx(Sender: TObject; E: Exception);
  public
  end;

var
  ConfigForm: TConfigForm;

function ShowConfig( Auth: boolean = False): boolean;

implementation

{$R *.DFM}

uses DBProc, AProc, DModule, Client, Main, DB, LU_Tracer;

function ShowConfig( Auth: boolean = False): boolean;
var
	IsRasPresent: boolean;
  OldExep : TExceptionEvent;
begin
  MainForm.FreeChildForms; //вид дочерних форм зависит от параметров
  Result:=False;
  with TConfigForm.Create(Application) do try
    OldExep := Application.OnException;
    try
      Application.OnException := OnAppEx;
    HTTPNameChanged := False;
    OldHTTPName := dbeHTTPName.Field.AsString;
	if Auth then PageControl.ActivePageIndex := 2
		else PageControl.ActivePageIndex := 0;

    //читаем параметры соединени€
    IsRasPresent := True;
    try
	GetEntries;
	DM.Ras.Entry:=DM.adtParams.FieldByName('RasEntry').AsString;
	cbRas.ItemIndex:=DM.Ras.GetEntryIndex;
    except
	IsRasPresent := False;
    end;
    if IsRasPresent then EnableRemoteAccess
    	else DisableRemoteAccess;
//    DM.MainConnection.BeginTrans;
    try
      DM.adtParams.Edit;
      Result:=ShowModal=mrOk;
      if Result then begin
        DM.adtParams.FieldByName('RasEntry').AsString:=cbRas.Items[cbRas.ItemIndex];
        if HTTPNameChanged and (OldHTTPName <> dbeHTTPName.Field.AsString) then begin
          DM.adtParams.FieldByName('HTTPNameChanged').AsBoolean := True;
          MainForm.DisableByHTTPName;
          DM.adcUpdate.Transaction.StartTransaction;
          try
            DM.adcUpdate.SQL.Text := 'EXECUTE PROCEDURE OrdersHDeleteNotClosedAll';
            DM.adcUpdate.ExecQuery;
            DM.adcUpdate.Transaction.Commit;
          except
            DM.adcUpdate.Transaction.Rollback;
            raise;
          end;
        end;
        DM.adtParams.Post;
        DM.adsRetailMargins.ApplyUpdates;
        DM.LoadRetailMargins;
      //  DM.MainConnection.CommitTrans;
      end
      else begin
        DM.adtParams.Cancel;
        DM.adsRetailMargins.CancelUpdates;
//        DM.MainConnection.RollbackTrans;
      end;
    except
//      DM.MainConnection.RollbackTrans;
      raise;
    end;

    finally
      Application.OnException := OldExep;
    end;

  finally
    Free;
  end;
  //если RollBack - надо освежить
  DM.adtParams.CloseOpen(True);
  DM.adtClients.CloseOpen(True);
  DM.adsRetailMargins.CloseOpen(True);
  DM.ClientChanged;
end;

procedure TConfigForm.btnClientsEditClick(Sender: TObject);
begin
  ShowClient;
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
  //если нажать Enter в поле кода dbeID, то значение не заноситс€, поэтому перемещаем фокус
  btnOk.SetFocus;
  if DM.adtParams.FieldByName('RasConnect').AsBoolean then begin
    if cbRas.ItemIndex<0 then
      raise Exception.Create('Ќе задано удаленное соединение');
    DM.Ras.Entry:=cbRas.Items[cbRas.ItemIndex];
    if DM.Ras.GetEntryIndex<0 then
      raise Exception.Create('”даленное соединение не существует');
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
  if (cbRas.ItemIndex>=0)and(MessageBox('”далить удаленное соединение?',
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
	Windows.MessageBox( Self.Handle, '»зменени€ вступ€т в силу после получени€ данных',
		'¬нимание', MB_OK or MB_ICONWARNING);
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
      if MessageBox('»зменение имени авторизации удалит все неотправленные заказы. ѕродолжить?' , MB_ICONQUESTION or MB_YESNO) <> IDYES then
        CanClose := False;
    end;
    if CanClose then begin
    DM.adsRetailMargins.DoSort(['LEFTLIMIT'], [True]);
    if DM.adsRetailMargins.RecordCount > 0 then begin
      DM.adsRetailMargins.First;
      Res := DM.adsRetailMarginsLEFTLIMIT.AsCurrency <= DM.adsRetailMarginsRIGHTLIMIT.AsCurrency;
      PrevRight := DM.adsRetailMarginsRIGHTLIMIT.AsCurrency;
      DM.adsRetailMargins.Next;
      while not DM.adsRetailMargins.Eof and Res do begin
        Res := PrevRight <= DM.adsRetailMarginsLEFTLIMIT.AsCurrency;
        if Res then
          Res := DM.adsRetailMarginsLEFTLIMIT.AsCurrency <= DM.adsRetailMarginsRIGHTLIMIT.AsCurrency;
        DM.adsRetailMargins.Next;
      end;
      if not Res then begin
        CanClose := False;
        PageControl.ActivePage := tshClients;
        tdbgRetailMargins.SetFocus;
        MessageBox('Ќекорректно введены границы цен.', MB_ICONWARNING);
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
  DM.adsRetailMargins.Append;
end;

procedure TConfigForm.btnDelRetailClick(Sender: TObject);
begin
  if not DM.adsRetailMargins.IsEmpty then
    DM.adsRetailMargins.Delete;
end;

procedure TConfigForm.tdbgRetailMarginsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  V1, V2 : Variant;
begin
  if (DM.adsRetailMarginsLEFTLIMIT.AsCurrency > DM.adsRetailMarginsRIGHTLIMIT.AsCurrency) and
    ((Column.Field = DM.adsRetailMarginsLEFTLIMIT) or (Column.Field = DM.adsRetailMarginsRIGHTLIMIT))
  then
    Background := clRed;

  if (DM.adsRetailMargins.RecNo = 1) then
    PrevLimit := DM.adsRetailMarginsRIGHTLIMIT.AsVariant;

  if (DM.adsRetailMargins.RecNo > 1)
    and (PrevLimit > DM.adsRetailMarginsLEFTLIMIT.Value)
    and (Column.Field = DM.adsRetailMarginsLEFTLIMIT)
  then
    Background := clOlive;

{
  else begin
    DM.adsRetailMargins.RecordFieldValue()
    if (DM.adsRetailMargins.RecNo < DM.adsRetailMargins.RecordCount) then begin
      V1 := DM.adsRetailMargins.RecordFieldValue(DM.adsRetailMarginsLEFTLIMIT, DM.adsRetailMargins.RecNo+1);
      V2 := DM.adsRetailMarginsRIGHTLIMIT.Value;
      if (DM.adsRetailMargins.RecNo < DM.adsRetailMargins.RecordCount)
        and (V1 < V2)
        and (Column.Field = DM.adsRetailMarginsRIGHTLIMIT)
      then
        Background := clOlive;
    end;
  end;
}  
end;

end.

