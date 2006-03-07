unit CoreFirm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXDBCtrl, Grids, DBGrids, ComCtrls, Db, StrUtils, Child,
  FR_DSet, FR_DBSet, ActnList, StdCtrls, Buttons, DBCtrls, Variants,
  Math, ExtCtrls, DBGridEh, ToughDBGrid, Registry, OleCtrls, SHDocVw,
  FIBDataSet, pFIBDataSet, FIBSQLMonitor, hlpcodecs, LU_Tracer, FIBQuery,
  pFIBQuery, lU_TSGHashTable, U_CryptIndex;

const
	CoreSql =	'SELECT * FROM CORESHOWBYFIRM(:APRICECODE, :AREGIONCODE, :ACLIENTID, :APRICENAME) ORDER BY ';

type
  TFilter=( filAll, filOrder, filLeader);

  TCoreFirmForm = class(TChildForm)
    dsCore: TDataSource;
    ActionList: TActionList;
    actFilterAll: TAction;
    actFilterOrder: TAction;
    actFilterLeader: TAction;
    actSaveToFile: TAction;
    actDeleteOrder: TAction;
    frdsCore: TfrDBDataSet;
    lblRecordCount: TLabel;
    cbFilter: TComboBox;
    lblOrderLabel: TLabel;
    btnDeleteOrder: TSpeedButton;
    btnFormHistory: TSpeedButton;
    lblFirmPrice: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    dbgCore: TToughDBGrid;
    plOverCost: TPanel;
    Timer: TTimer;
    Bevel1: TBevel;
    actFlipCore: TAction;
    adsCore: TpFIBDataSet;
    adsCoreSumOrder: TCurrencyField;
    adsCountFields: TpFIBDataSet;
    adsOrdersH: TpFIBDataSet;
    adsOrdersShowFormSummary: TpFIBDataSet;
    adsCoreCryptSYNONYMNAME: TStringField;
    adsCoreCryptSYNONYMFIRM: TStringField;
    adsCoreCryptBASECOST: TCurrencyField;
    adsCorePriceRet: TCurrencyField;
    adsCoreCryptCODE: TStringField;
    adsCoreCryptCODECR: TStringField;
    qCore: TpFIBQuery;
    qCoreUpdate: TpFIBQuery;
    qCoreRefresh: TpFIBQuery;
    adsCoreCOREID: TFIBBCDField;
    adsCoreFULLCODE: TFIBBCDField;
    adsCoreSHORTCODE: TFIBBCDField;
    adsCoreCODEFIRMCR: TFIBBCDField;
    adsCoreSYNONYMCODE: TFIBBCDField;
    adsCoreSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreCODE: TFIBStringField;
    adsCoreCODECR: TFIBStringField;
    adsCoreVOLUME: TFIBStringField;
    adsCoreDOC: TFIBStringField;
    adsCoreNOTE: TFIBStringField;
    adsCorePERIOD: TFIBStringField;
    adsCoreAWAIT: TFIBIntegerField;
    adsCoreJUNK: TFIBIntegerField;
    adsCoreBASECOST: TFIBStringField;
    adsCoreQUANTITY: TFIBStringField;
    adsCoreSYNONYMNAME: TFIBStringField;
    adsCoreSYNONYMFIRM: TFIBStringField;
    adsCoreMINPRICE: TFIBBCDField;
    adsCoreLEADERPRICECODE: TFIBBCDField;
    adsCoreLEADERREGIONCODE: TFIBBCDField;
    adsCoreLEADERREGIONNAME: TFIBStringField;
    adsCoreLEADERPRICENAME: TFIBStringField;
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
    adsCoreORDERSJUNK: TFIBIntegerField;
    adsCoreORDERSAWAIT: TFIBIntegerField;
    adsCoreORDERSHORDERID: TFIBBCDField;
    adsCoreORDERSHCLIENTID: TFIBBCDField;
    adsCoreORDERSHPRICECODE: TFIBBCDField;
    adsCoreORDERSHREGIONCODE: TFIBBCDField;
    adsCoreORDERSHPRICENAME: TFIBStringField;
    adsCoreORDERSHREGIONNAME: TFIBStringField;
    adsOrdersShowFormSummaryPRICEAVG: TFIBBCDField;
    adsCoreLEADERCODE: TFIBStringField;
    adsCoreLEADERCODECR: TFIBStringField;
    adsCoreLEADERPRICE: TFIBStringField;
    adsCoreCryptLEADERPRICE: TCurrencyField;
    procedure cbFilterClick(Sender: TObject);
    procedure actDeleteOrderExecute(Sender: TObject);
    procedure adsCore2BeforePost(DataSet: TDataSet);
    procedure adsCore2AfterPost(DataSet: TDataSet);
    procedure adsCore2BeforeEdit(DataSet: TDataSet);
    procedure adsCore2CalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure actFilterAllExecute(Sender: TObject);
    procedure actFilterOrderExecute(Sender: TObject);
    procedure actFilterLeaderExecute(Sender: TObject);
    procedure btnFormHistoryClick(Sender: TObject);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure adsCore2AfterOpen(DataSet: TDataSet);
    procedure adsCore2BeforeClose(DataSet: TDataSet);
    procedure TimerTimer(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure dbgCoreKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCoreSortMarkingChanged(Sender: TObject);
    procedure adsCoreLEADERPRICENAMEGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
  private
    OldOrder, OrderCount, PriceCode, RegionCode, ClientId: Integer;
    OrderSum: Double;

    UseExcess: Boolean;
    Excess: Integer;

    procedure OrderCalc;
    procedure SetOrderLabel;
    procedure SetFilter(Filter: TFilter);
    procedure RefreshOrdersH;
    procedure OrderCountFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure LeaderFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  public
    procedure ShowForm(APriceCode, ARegionCode: Integer;
      OnlyLeaders: Boolean=False); reintroduce;
    procedure Print( APreview: boolean = False); override;
    procedure RefreshAllCore;
  end;

var
  CoreFirmForm: TCoreFirmForm;

implementation

uses Main, AProc, DModule, DBProc, FormHistory, Prices, Constant,
  NamesForms, Core;

{$R *.DFM}

procedure TCoreFirmForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;
	PrintEnabled := False;
	UseExcess := DM.adtClients.FieldByName( 'UseExcess').AsBoolean;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
	ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
	adsOrdersShowFormSummary.ParamByName('AClientId').Value := ClientId;
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, False) then dbgCore.LoadFromRegistry( Reg);
  if dbgCore.SortMarkedColumns.Count = 0 then
    dbgCore.Columns[1].Title.SortMarker := smUpEh;
	Reg.Free;
end;

procedure TCoreFirmForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, True);
	dbgCore.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TCoreFirmForm.ShowForm(APriceCode, ARegionCode: Integer;
  OnlyLeaders: Boolean=False);
begin
  PriceCode:=APriceCode;
  RegionCode:=ARegionCode;
  adsOrdersShowFormSummary.DataSource := nil;
  with adsCore do begin
    ParamByName( 'APriceCode').Value:=PriceCode;
    ParamByName( 'ARegionCode').Value:=RegionCode;
    ParamByName( 'AClientId').Value:=ClientId;
    ParamByName( 'APriceName').Value:=PricesForm.adsPrices.FieldByName('PriceName').AsString;
  end;
  RefreshAllCore;
  SetFilter(filAll);
  if adsCore.RecordCount=0 then begin
    MessageBox('Выбранный прайс-лист отсутствует',MB_ICONWARNING);
    Abort;
  end;
  //определяем, какие колонки прайс-листа фирмы показывать (не показываем пустые)
  with adsCountFields do begin
    ParamByName('APriceCode').Value:=PriceCode;
    ParamByName('ARegionCode').Value:=RegionCode;
    Open;
    try
      ColumnByNameT(dbgCore,'CryptCODE').Visible:=FieldByName('CODE').AsInteger>0;
      ColumnByNameT(dbgCore,'CryptSYNONYMFIRM').Visible:=FieldByName('SYNONYMFIRM').AsInteger>0;
      ColumnByNameT(dbgCore,'Volume').Visible:=FieldByName('Volume').AsInteger>0;
      ColumnByNameT(dbgCore,'Doc').Visible:=FieldByName('Doc').AsInteger>0;
      ColumnByNameT(dbgCore,'Note').Visible:=FieldByName('Note').AsInteger>0;
      ColumnByNameT(dbgCore,'Period').Visible:=FieldByName('Period').AsInteger>0;
      ColumnByNameT(dbgCore,'Quantity').Visible:=FieldByName('Quantity').AsInteger>0;
    finally
      Close;
    end;
  end;
  //подсчитываем сумму заявки и количество записей
  SetFilter(filOrder);
  OrderCalc;
  SetOrderLabel;
  if OnlyLeaders then
    SetFilter(filLeader)
  else
    SetFilter(filAll);
  lblFirmPrice.Caption := Format( 'Прайс-лист %s, регион %s',[
    PricesForm.adsPrices.FieldByName('PriceName').AsString,
    PricesForm.adsPrices.FieldByName('RegionName').AsString]);
  RefreshOrdersH;
  adsOrdersShowFormSummary.DataSource := dsCore;
  adsCore.First;
  inherited ShowForm;
end;

procedure TCoreFirmForm.adsCore2CalcFields(DataSet: TDataSet);
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
    adsCoreCryptCODE.AsString := DM.D_C(adsCoreCODE.AsString);
    adsCoreSumOrder.AsCurrency := adsCoreCryptBASECOST.AsCurrency * adsCoreORDERCOUNT.AsInteger;
    S := DM.D_B(adsCoreLEADERCODE.AsString, adsCoreLEADERCODECR.AsString);
    C := StrToCurr(S);
    adsCoreCryptLEADERPRICE.AsCurrency := C;
  except
    adsCoreSumOrder.AsCurrency := 0;
  end;
end;

procedure TCoreFirmForm.SetFilter(Filter: TFilter);
var
  FP : TFilterRecordEvent;
begin
  FP := nil;
  case Filter of
    filAll: FP := nil;
    filOrder: FP := OrderCountFilterRecord;
    filLeader: FP := LeaderFilterRecord;
  end;
  DBProc.SetFilterProc(adsCore, FP);
  lblRecordCount.Caption:=Format( 'Позиций : %d', [adsCore.RecordCount]);
  cbFilter.ItemIndex := Integer(Filter);
end;

procedure TCoreFirmForm.cbFilterClick(Sender: TObject);
begin
  dbgCore.SetFocus;
  SetFilter(TFilter(cbFilter.ItemIndex));
end;

procedure TCoreFirmForm.actFilterAllExecute(Sender: TObject);
begin
	if Self.Visible then SetFilter(filAll);
end;

procedure TCoreFirmForm.actFilterOrderExecute(Sender: TObject);
begin
	if Self.Visible then SetFilter(filOrder);
end;

procedure TCoreFirmForm.actFilterLeaderExecute(Sender: TObject);
begin
	if Self.Visible then SetFilter(filLeader);
end;

procedure TCoreFirmForm.Print( APreview: boolean = False);
begin
  RefreshOrdersH;
  DM.ShowFastReport('CoreFirm.frf',adsCore, APreview);
end;

//переоткрывает заголовок для текущего заказа
//нужна для печати и для поиска текущего OrdersH.OrderId при вводе заказа
procedure TCoreFirmForm.RefreshOrdersH;
begin
  with adsOrdersH do begin
    ParamByName('AClientId').Value:=ClientId;
    ParamByName('APriceCode').Value:=PriceCode;
    ParamByName('ARegionCode').Value:=RegionCode;
//    if Active then CloseOpen(True) else Open;
  end;
end;

procedure TCoreFirmForm.adsCore2BeforeEdit(DataSet: TDataSet);
begin
  OldOrder:=adsCoreORDERCOUNT.AsInteger;
  DM.SetOldOrderCount(OldOrder);
end;

procedure TCoreFirmForm.adsCore2BeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
	//PriceAvg: Double;
begin
	try
		{ проверяем заказ на соответствие наличию товара на складе }
		Val( adsCoreQuantity.AsString, Quantity, E);
		if E <> 0 then Quantity := 0;
		if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity) and
			( MessageBox( 'Заказ превышает остаток на складе. Продолжить?',
			MB_ICONQUESTION or MB_OKCANCEL) <> IDOK) then adsCoreORDERCOUNT.AsInteger := Quantity;

		{ проверяем на превышение цены }
{
    TODO: Не забыть включить
		if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) then
		begin
			PriceAvg := adsOrdersShowFormSummaryPriceAvg.AsCurrency;
			if ( PriceAvg > 0) and ( adsCoreBaseCost.AsCurrency>PriceAvg*(1+Excess/100)) then
			begin
				plOverCost.Top := ( dbgCore.Height - plOverCost.Height) div 2;
				plOverCost.Left := ( dbgCore.Width - plOverCost.Width) div 2;
				plOverCost.BringToFront;
				plOverCost.Show;
				Timer.Enabled := True;
			end;
		end;
}
  except
		adsCore.Cancel;
		raise;
	end;
end;

procedure TCoreFirmForm.adsCore2AfterPost(DataSet: TDataSet);
begin
	OrderCount := OrderCount + Iif( adsCoreORDERCOUNT.AsInteger = 0, 0, 1) - Iif( OldOrder = 0, 0, 1);
	OrderSum := OrderSum + ( adsCoreORDERCOUNT.AsInteger - OldOrder) * adsCoreCryptBASECOST.AsCurrency;
  DM.SetNewOrderCount(adsCoreORDERCOUNT.AsInteger, adsCoreCryptBASECOST.AsCurrency);
	SetOrderLabel;
	MainForm.SetOrdersInfo;
end;

procedure TCoreFirmForm.OrderCalc;
var
	V: array [ 0..1] of Variant;
begin
	DataSetCalc( adsCore,[ 'COUNT', 'SUM(SumOrder)'], V);
	OrderCount := V[ 0];
	OrderSum :=V[ 1];
end;

procedure TCoreFirmForm.SetOrderLabel;
begin
  lblOrderLabel.Caption:=Format('Заказано %d позиций на сумму %0.2f руб.',
    [OrderCount,OrderSum]);
end;

procedure TCoreFirmForm.btnFormHistoryClick(Sender: TObject);
begin
  ShowFormHistory(adsCoreFullCode.AsInteger,ClientId);
end;

procedure TCoreFirmForm.actDeleteOrderExecute(Sender: TObject);
begin
  if not Visible then Exit;
  if MessageBox( 'Удалить весь заказ по данному прайс-листу?',
    MB_ICONQUESTION or MB_OKCANCEL)<>IDOK then Abort;
  adsCore.DisableControls;
  Screen.Cursor:=crHourGlass;
  try
    DM.adcUpdate.Transaction.StartTransaction;
    try
      with DM.adcUpdate do begin
        //удаляем сохраненную заявку (если есть)
        SQL.Text:=Format( 'EXECUTE PROCEDURE OrdersHDeleteNotClosed(:ACLIENTID, :APRICECODE, :AREGIONCODE)',
          [DM.adtClients.FieldByName('ClientId').AsInteger,PriceCode,RegionCode]);
        ParamByName('ACLIENTID').Value := DM.adtClients.FieldByName('ClientId').Value;
        ParamByName('APRICECODE').Value := PriceCode;
        ParamByName('AREGIONCODE').Value := RegionCode;
        ExecQuery;
      end;
      DM.adcUpdate.Transaction.Commit;
    except
      DM.adcUpdate.Transaction.Rollback;
      raise;
    end;
  finally
    adsCore.EnableControls;
//    adsCore.CloseOpen(True);
    RefreshAllCore;
//    adsOrdersH.CloseOpen(True);
    Screen.Cursor:=crDefault;
    MainForm.SetOrdersInfo;
  end;
  dbgCore.SetFocus;
end;

procedure TCoreFirmForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	//данный прайс-лидер
	if (((adsCoreLEADERPRICECODE.AsInteger = PriceCode) and	( adsCoreLeaderRegionCode.AsInteger = RegionCode))
     or (abs(adsCoreCryptBASECOST.AsCurrency - adsCoreCryptLEADERPRICE.AsCurrency) < 0.01)
     )
    and
		(( Column.Field = adsCoreLEADERREGIONNAME) or ( Column.Field = adsCoreLEADERPRICENAME))
  then
			Background := LEADER_CLR;
	//уцененный товар
	if (adsCoreJunk.Value = 1) and (( Column.Field = adsCorePERIOD) or
		( Column.Field = adsCoreCryptBASECOST)) then Background := JUNK_CLR;
	//ожидаемый товар выделяем зеленым
	if (adsCoreAwait.Value = 1) and ( Column.Field = adsCoreCryptSYNONYMNAME) then
		Background := AWAIT_CLR;
end;

procedure TCoreFirmForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
	if ( Key = VK_RETURN) then btnFormHistoryClick( nil);
	if (( Key = VK_ESCAPE) and not TToughDBGrid( Sender).InSearch) then
		Self.PrevForm.ShowForm;
end;

procedure TCoreFirmForm.dbgCoreCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
	CanInput := ( RegionCode and DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
		RegionCode;
	if not CanInput then Exit;
	{ создаем записи из Orders и OrdersH, если их нет }
{
  if adsCoreOrdersOrderId.IsNull then begin //нет соответствующей записи в Orders
    if adsOrdersH.IsEmpty then begin //нет заголовка заказа из OrdersH
      //добавляем запись в OrdersH
      adsCore.Edit;
      adsCoreOrdersHClientId.AsInteger:=ClientId;
      adsCoreOrdersHPriceCode.AsInteger:=PriceCode;
      adsCoreOrdersHRegionCode.AsInteger:=RegionCode;
      adsCoreOrdersHPriceName.AsString:=PricesForm.adsPrices.FieldByName('PriceName').AsString;
      adsCoreOrdersHRegionName.AsString:=PricesForm.adsPrices.FieldByName('RegionName').AsString;
      adsCore.Post; //на этот момент уже имеем OrdersHOrderId (автоинкремент)
    end;
    //добавляем запись в Orders
    adsCore.Edit;
    if adsOrdersH.IsEmpty then
      adsCoreOrdersOrderId.AsInteger:=adsCoreOrdersHOrderId.AsInteger
    else
      adsCoreOrdersOrderId.AsInteger:=adsOrdersH.FieldByName('OrderId').AsInteger;
    adsCoreOrdersClientId.AsInteger := ClientId;
    adsCoreOrdersFullCode.AsInteger:=adsCoreFullCode.AsInteger;
    adsCoreOrdersCodeFirmCr.AsInteger := adsCoreCodeFirmCr.AsInteger;
    adsCoreOrdersCoreId.AsInteger:=adsCoreCoreId.AsInteger;
    adsCoreOrdersSynonymCode.AsInteger:=adsCoreSynonymCode.AsInteger;
    adsCoreOrdersSynonymFirmCrCode.AsInteger:=adsCoreSynonymFirmCrCode.AsInteger;
    adsCoreOrdersCode.AsString:=adsCoreCode.AsString;
    adsCoreOrdersCodeCr.AsString := adsCoreCodeCr.AsString;
    adsCoreOrdersPrice.AsCurrency:=adsCoreBaseCost.AsCurrency;
    adsCoreOrdersJunk.AsBoolean:=adsCoreJunk.AsBoolean;
    adsCoreOrdersAwait.AsBoolean := adsCoreAwait.AsBoolean;
    adsCoreOrdersSynonym.AsString := adsCoreSYNONYMNAME.AsString;
    adsCoreOrdersSynonymFirm.AsString := adsCoreSynonymFirm.AsString;
    adsCore.Post;
    if adsOrdersH.IsEmpty then RefreshOrdersH;
  end;
}
end;

procedure TCoreFirmForm.adsCore2AfterOpen(DataSet: TDataSet);
begin
//	adsOrdersShowFormSummary.Open;
end;

procedure TCoreFirmForm.adsCore2BeforeClose(DataSet: TDataSet);
begin
//	adsOrdersShowFormSummary.Close;
end;

procedure TCoreFirmForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

procedure TCoreFirmForm.actFlipCoreExecute(Sender: TObject);
var
	FullCode, ShortCode, lPriceCode, lRegionCode: integer;
	SynonymCode, SynonymFirmCrCode: integer;
begin
	if MainForm.ActiveChild <> Self then exit;
	FullCode := adsCoreFullCode.AsInteger;
	ShortCode := adsCoreShortCode.AsInteger;
	SynonymCode := adsCoreSynonymCode.AsInteger;
	SynonymFirmCrCode := adsCoreSynonymFirmCrCode.AsInteger;
	lPriceCode := PriceCode;
	lRegionCode := RegionCode;
	ShowOrderAll;

	with TNamesFormsForm( MainForm.ActiveChild) do
	begin
		adsNames.Locate( 'AShortCode', ShortCode, []);

		if not actUseForms.Checked then
			CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
				adsNames.FieldByName( 'Name').AsString, '', actUseForms.Checked);
		if actUseForms.Checked and ( adsForms.RecordCount < 2) then
			CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
				adsNames.FieldByName( 'Name').AsString,
				adsForms.FieldByName( 'Form').AsString, False);
		if actUseForms.Checked and ( adsForms.RecordCount > 1) then
		begin
			adsForms.Locate( 'FullCode', FullCode, []);
			CoreForm.ShowForm( adsForms.FieldByName( 'FullCode').AsInteger,
				adsNames.FieldByName( 'Name').AsString,
				adsForms.FieldByName( 'Form').AsString,
				actUseForms.Checked);
		end;
		CoreForm.adsCore.Locate( 'SynonymCode;SynonymFirmCrCode;PriceCode;RegionCode',
			VarArrayOf([ SynonymCode, SynonymFirmCrCode, lPriceCode, lRegionCode]), []);
	end;
end;

procedure TCoreFirmForm.dbgCoreKeyPress(Sender: TObject; var Key: Char);
begin
  if (KEY in ['0'..'9']) and dbgCore.InSearch then begin
		SendMessage( dbgCore.Handle, WM_KEYDOWN, VK_ESCAPE, 0);
		SendMessage( dbgCore.Handle, WM_CHAR, Ord( Key), 0);
  end;
  inherited;
end;

procedure TCoreFirmForm.OrderCountFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0);
end;

procedure TCoreFirmForm.LeaderFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
    or (abs(adsCoreCryptBASECOST.AsCurrency - adsCoreCryptLEADERPRICE.AsCurrency) < 0.01);
end;

procedure TCoreFirmForm.RefreshAllCore;
begin
  Screen.Cursor:=crHourglass;
  try
    adsCore.ParamByName( 'APriceCode').Value:=PriceCode;
    adsCore.ParamByName( 'ARegionCode').Value:=RegionCode;
    adsCore.ParamByName( 'AClientId').Value:=ClientId;
    adsCore.ParamByName( 'APriceName').Value:=PricesForm.adsPrices.FieldByName('PriceName').AsString;
    if adsCore.Active then adsCore.CloseOpen(True) else adsCore.Open;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TCoreFirmForm.dbgCoreSortMarkingChanged(Sender: TObject);
begin
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TCoreFirmForm.adsCoreLEADERPRICENAMEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if (abs(adsCoreCryptBASECOST.AsCurrency - adsCoreCryptLEADERPRICE.AsCurrency) < 0.01) then
    Text := PricesForm.adsPrices.FieldByName('PriceName').AsString
  else
    Text := Sender.AsString;
end;

end.
