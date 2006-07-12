unit SynonymSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB, FIBDataSet, pFIBDataSet, ActnList, ExtCtrls, FR_DSet,
  FR_DBSet, Grids, DBGridEh, ToughDBGrid, StdCtrls, Registry, Constant,
  ForceRus, DBGrids, Buttons, Menus;

type
  TSynonymSearchForm = class(TChildForm)
    plOverCost: TPanel;
    pTop: TPanel;
    pCenter: TPanel;
    dbgCore: TToughDBGrid;
    dsCore: TDataSource;
    frdsCore: TfrDBDataSet;
    Timer: TTimer;
    ActionList: TActionList;
    actFlipCore: TAction;
    adsCore: TpFIBDataSet;
    adsCoreSumOrder: TCurrencyField;
    adsCorePriceRet: TCurrencyField;
    adsCorePriceDelta: TFloatField;
    adsCoreCryptSYNONYMNAME: TStringField;
    adsCoreCryptSYNONYMFIRM: TStringField;
    adsCoreCryptBASECOST: TCurrencyField;
    adsRegions: TpFIBDataSet;
    adsOrdersH: TpFIBDataSet;
    eSearch: TEdit;
    btnSearch: TButton;
    tmrSearch: TTimer;
    adsCoreCOREID: TFIBBCDField;
    adsCorePRICECODE: TFIBBCDField;
    adsCoreREGIONCODE: TFIBBCDField;
    adsCoreSHORTCODE: TFIBBCDField;
    adsCoreCODEFIRMCR: TFIBBCDField;
    adsCoreSYNONYMCODE: TFIBBCDField;
    adsCoreSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreCODE: TFIBStringField;
    adsCoreCODECR: TFIBStringField;
    adsCorePERIOD: TFIBStringField;
    adsCoreSALE: TFIBIntegerField;
    adsCoreVOLUME: TFIBStringField;
    adsCoreNOTE: TFIBStringField;
    adsCoreBASECOST: TFIBStringField;
    adsCoreQUANTITY: TFIBStringField;
    adsCoreAWAIT: TFIBBooleanField;
    adsCoreJUNK: TFIBBooleanField;
    adsCoreSYNONYMNAME: TFIBStringField;
    adsCoreSYNONYMFIRM: TFIBStringField;
    adsCoreDATEPRICE: TFIBStringField;
    adsCorePRICENAME: TFIBStringField;
    adsCorePRICEENABLED: TFIBBooleanField;
    adsCoreFIRMCODE: TFIBBCDField;
    adsCoreSTORAGE: TFIBBooleanField;
    adsCoreREGIONNAME: TFIBStringField;
    adsCoreORDERSCOREID: TFIBBCDField;
    adsCoreORDERSORDERID: TFIBBCDField;
    adsCoreORDERSCLIENTID: TFIBBCDField;
    adsCoreORDERSFULLCODE: TFIBBCDField;
    adsCoreORDERSCODEFIRMCR: TFIBBCDField;
    adsCoreORDERSSYNONYMCODE: TFIBBCDField;
    adsCoreORDERSSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreORDERSCODE: TFIBStringField;
    adsCoreORDERSCODECR: TFIBStringField;
    adsCoreORDERCOUNT: TFIBIntegerField;
    adsCoreORDERSSYNONYM: TFIBStringField;
    adsCoreORDERSSYNONYMFIRM: TFIBStringField;
    adsCoreORDERSPRICE: TFIBStringField;
    adsCoreORDERSJUNK: TFIBBooleanField;
    adsCoreORDERSAWAIT: TFIBBooleanField;
    adsCoreORDERSHORDERID: TFIBBCDField;
    adsCoreORDERSHCLIENTID: TFIBBCDField;
    adsCoreORDERSHPRICECODE: TFIBBCDField;
    adsCoreORDERSHREGIONCODE: TFIBBCDField;
    adsCoreORDERSHPRICENAME: TFIBStringField;
    adsCoreORDERSHREGIONNAME: TFIBStringField;
    adsCoreFULLCODE: TFIBBCDField;
    cbBaseOnly: TCheckBox;
    btnSelectPrices: TBitBtn;
    pmSelectedPrices: TPopupMenu;
    miSelectAll: TMenuItem;
    miUnselecAll: TMenuItem;
    miSep: TMenuItem;
    lFilter: TLabel;
    adsOrdersShowFormSummary: TpFIBDataSet;
    adsOrdersShowFormSummaryORDERPRICEAVG: TFIBBCDField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
    procedure adsCoreCalcFields(DataSet: TDataSet);
    procedure adsCoreBeforePost(DataSet: TDataSet);
    procedure adsCoreBeforeEdit(DataSet: TDataSet);
    procedure adsCoreAfterPost(DataSet: TDataSet);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCoreDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure btnSelectPricesClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure miUnselecAllClick(Sender: TObject);
    procedure cbBaseOnlyClick(Sender: TObject);
  private
    { Private declarations }
    fr : TForceRus;
    UseExcess, CurrentUseForms: Boolean;
    DeltaMode, Excess, ClientId: Integer;
    slColors : TStringList;
    StartSQL : String;
    SelectedPrices : TStringList;
    procedure AddKeyToSearch(Key : Char);
    procedure SetClear;
    procedure ChangeSelected(ASelected : Boolean);
    procedure OnSPClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  SynonymSearchForm: TSynonymSearchForm;

procedure ShowSynonymSearch;


implementation

uses DModule, AProc, Main, SQLWaiting;

{$R *.dfm}

procedure ShowSynonymSearch;
begin
  MainForm.ShowChildForm(TSynonymSearchForm);
end;


procedure TSynonymSearchForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
  I : Integer;
  sp : TSelectPrice;
  mi :TMenuItem;
begin
  inherited;
  //dbgCore.Columns.State := csDefault;
  StartSQL := adsCore.SelectSQL.Text; 
  slColors := TStringList.Create;

  fr := TForceRus.Create;

	//UseExcess := DM.adtClients.FieldByName( 'UseExcess').AsBoolean;
  UseExcess := True;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
        DeltaMode := DM.adtClients.FieldByName( 'DeltaMode').AsInteger;
	adsOrdersShowFormSummary.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').AsInteger;

	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'TCoreForm', False) then
		dbgCore.LoadFromRegistry( Reg);
	Reg.Free;

  SelectedPrices := SynonymSelectedPrices;
  for I := 0 to SelectedPrices.Count-1 do begin
    sp := TSelectPrice(SelectedPrices.Objects[i]);
    mi := TMenuItem.Create(pmSelectedPrices);
    mi.Name := 'sl' + SelectedPrices[i];
    mi.Caption := sp.PriceName;
    mi.Checked := sp.Selected;
    mi.Tag := Integer(sp);
    mi.OnClick := OnSPClick;
    pmSelectedPrices.Items.Add(mi);
  end;

  ShowForm;
end;

procedure TSynonymSearchForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
  slColors.Free;
  fr.Free;
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\'	+ 'TCoreForm', True);
	dbgCore.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TSynonymSearchForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

procedure TSynonymSearchForm.tmrSearchTimer(Sender: TObject);
var
  PrevFullCode: Integer;
  SelectedColor : TColor;
  FilterSQL : String;
begin
  tmrSearch.Enabled := False;
  if Length(eSearch.Text) > 2 then begin
  	adsOrdersShowFormSummary.DataSource := nil;
    if adsCore.Active then
      adsCore.Close;
    adsCore.ParamByName('LikeParam').AsString := '%' + eSearch.Text + '%';
    adsCore.ParamByName('AClientID').AsInteger := DM.adtClients.FieldByName( 'ClientId').Value;
    FilterSQL := GetSelectedPricesSQL(SelectedPrices, 'PRD.');
    adsCore.SelectSQL.Text := StartSQL;
    lFilter.Visible := Length(FilterSQL) > 0;
    if lFilter.Visible then
      adsCore.SelectSQL.Text := adsCore.SelectSQL.Text + 'and (' + FilterSQL + ')';
    if cbBaseOnly.Checked then
      adsCore.SelectSQL.Text := adsCore.SelectSQL.Text + ' and (PRD.Enabled = 1)';

    ShowSQLWaiting(adsCore);

    if not adsCore.Sorted then begin
      adsCore.DoSort(['FullCode', 'CryptBaseCost'], [True, True]);
      adsCore.DoSort(['FullCode', 'CryptBaseCost'], [True, True]);
      adsCore.First;
    end;
    adsCore.DisableControls;
    try
      PrevFullCode := 0;
      while not adsCore.Eof do begin
        if adsCoreFULLCODE.AsInteger <> PrevFullCode then begin
          case (slColors.Count mod 3) of
            0 : SelectedColor := clWhite;
            1 : SelectedColor := clSkyBlue;
            else
                SelectedColor := clMoneyGreen;
          end;
          slColors.AddObject(IntToStr(adsCoreFULLCODE.AsInteger), TObject(SelectedColor));
          PrevFullCode := adsCoreFULLCODE.AsInteger;
        end;
        adsCore.Next;
      end;
      adsCore.First;
    finally
      adsCore.EnableControls;
    end;
  	adsOrdersShowFormSummary.DataSource := dsCore;
    dbgCore.SetFocus;
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TSynonymSearchForm.adsCoreCalcFields(DataSet: TDataSet);
var
  S : String;
  C : Currency;
begin
  try
    adsCoreCryptSYNONYMNAME.AsString := DM.D_S(adsCoreSYNONYMNAME.AsString);
    adsCoreCryptSYNONYMFIRM.AsString := DM.D_S(adsCoreSYNONYMFIRM.AsString);
    S := DM.D_B(adsCoreCODE.AsString, adsCoreCODECR.AsString);
    C := StrToCurr(S);
    adsCoreCryptBASECOST.AsCurrency := C;
    adsCorePriceRet.AsCurrency := DM.GetPriceRet(C);
    //вычисляем сумму заказа по товару SumOrder
    adsCoreSumOrder.AsCurrency:=C*adsCoreORDERCOUNT.AsInteger;
  except
  end;
end;

procedure TSynonymSearchForm.adsCoreBeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
	PriceAvg: Double;
begin
	try
		{ проверяем заказ на соответствие наличию товара на складе }
		Val( adsCoreQuantity.AsString,Quantity,E);
		if E<>0 then Quantity := 0;
		if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity) and
			( MessageBox( 'Заказ превышает остаток на складе. Продолжить?',
			MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) then adsCoreORDERCOUNT.AsInteger := Quantity;

		{ проверяем на превышение цены }
		if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) then
		begin
			PriceAvg := adsOrdersShowFormSummaryORDERPRICEAVG.AsCurrency;
			if ( PriceAvg > 0) and ( adsCoreCryptBASECOST.AsCurrency>PriceAvg*( 1 + Excess / 100)) then
			begin
				plOverCost.Top := ( dbgCore.Height - plOverCost.Height) div 2;
				plOverCost.Left := ( dbgCore.Width - plOverCost.Width) div 2;
				plOverCost.BringToFront;
				plOverCost.Show;
				Timer.Enabled := True;
			end;
		end;
  except
		adsCore.Cancel;
		raise;
	end;
end;

procedure TSynonymSearchForm.adsCoreBeforeEdit(DataSet: TDataSet);
begin
	if adsCoreFirmCode.AsInteger = RegisterId then Abort;
  DM.SetOldOrderCount(adsCoreORDERCOUNT.AsInteger);
end;

procedure TSynonymSearchForm.adsCoreAfterPost(DataSet: TDataSet);
begin
  DM.SetNewOrderCount(adsCoreORDERCOUNT.AsInteger, adsCoreCryptBASECOST.AsCurrency);
	MainForm.SetOrdersInfo;
end;

procedure TSynonymSearchForm.dbgCoreCanInput(Sender: TObject;
  Value: Integer; var CanInput: Boolean);
begin
	CanInput := ( adsCoreSynonymCode.AsInteger >= 0) and
		(( adsCoreRegionCode.AsInteger and DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
			adsCoreRegionCode.AsInteger);
end;

procedure TSynonymSearchForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if adsCoreSynonymCode.AsInteger < 0 then
	begin
		Background := $00fff1d8;
                AFont.Style := [fsBold];
	end
	else
	if adsCoreFirmCode.AsInteger = RegisterId then
	begin
		//если это реестр, изменяем цвета
		if ( Column.Field = adsCoreCryptSYNONYMNAME) or ( Column.Field = adsCoreCryptSYNONYMFIRM) or
			( Column.Field = adsCoreCryptBASECOST)or
			( Column.Field = adsCorePriceRet) then Background := REG_CLR;
        end
	else
	begin
    if not adsCore.IsEmpty then
      Background := TColor(slColors.Objects[ slColors.IndexOf(adsCoreFULLCODE.AsString)]); 
		if not adsCorePriceEnabled.AsBoolean then
		begin
			//если фирма недоступна, изменяем цвет
			if ( Column.Field = adsCoreCryptSYNONYMNAME) or ( Column.Field = adsCoreCryptSYNONYMFIRM)
				then Background := clBtnFace;
		end;

		//если уцененный товар, изменяем цвет
		if adsCoreJunk.AsBoolean and (( Column.Field = adsCorePERIOD) or ( Column.Field = adsCoreCryptBASECOST)) then
			Background := JUNK_CLR;
		//ожидаемый товар выделяем зеленым
		if adsCoreAwait.AsBoolean and ( Column.Field = adsCoreCryptSYNONYMNAME) then
			Background := AWAIT_CLR;
	end;
end;

procedure TSynonymSearchForm.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TSynonymSearchForm.eSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //Если мы что-то нажали в элементе, то должны на это отреагировать
  tmrSearch.Enabled := True;
end;

procedure TSynonymSearchForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + fr.DoIt(Key);
    tmrSearch.Enabled := True;
  end;
end;

procedure TSynonymSearchForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    SetClear;
end;

procedure TSynonymSearchForm.SetClear;
begin
  tmrSearch.Enabled := False;
  eSearch.Text := '';
  adsCore.Close;
end;

procedure TSynonymSearchForm.dbgCoreKeyPress(Sender: TObject;
  var Key: Char);
begin
	if ( Key > #32) and not ( Key in
		[ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
	begin
    AddKeyToSearch(Key);
  end;
end;

procedure TSynonymSearchForm.dbgCoreDrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
begin
  if Field = adsCoreCryptSYNONYMNAME then begin
    dbgCore.Canvas.FillRect(Rect);
  end;
end;

procedure TSynonymSearchForm.btnSelectPricesClick(Sender: TObject);
begin
  pmSelectedPrices.Popup(btnSelectPrices.ClientOrigin.X, btnSelectPrices.ClientOrigin.Y + btnSelectPrices.Height);
end;

procedure TSynonymSearchForm.ChangeSelected(ASelected: Boolean);
var
  I : Integer;
begin
  tmrSearch.Enabled := False;
  for I := 3 to pmSelectedPrices.Items.Count-1 do begin
    pmSelectedPrices.Items.Items[i].Checked := ASelected;
    TSelectPrice(TMenuItem(pmSelectedPrices.Items.Items[i]).Tag).Selected := ASelected;
  end;
  pmSelectedPrices.Popup(pmSelectedPrices.PopupPoint.X, pmSelectedPrices.PopupPoint.Y);
  tmrSearch.Enabled := True;
end;

procedure TSynonymSearchForm.miSelectAllClick(Sender: TObject);
begin
  ChangeSelected(True);
end;

procedure TSynonymSearchForm.miUnselecAllClick(Sender: TObject);
begin
  ChangeSelected(False);
end;

procedure TSynonymSearchForm.OnSPClick(Sender: TObject);
var
  sp : TSelectPrice;
begin
  tmrSearch.Enabled := False;
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  sp := TSelectPrice(TMenuItem(Sender).Tag);
  sp.Selected := TMenuItem(Sender).Checked;
  pmSelectedPrices.Popup(pmSelectedPrices.PopupPoint.X, pmSelectedPrices.PopupPoint.Y);
  tmrSearch.Enabled := True;
end;

procedure TSynonymSearchForm.cbBaseOnlyClick(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  tmrSearch.Enabled := True;
end;

end.
