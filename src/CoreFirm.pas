unit CoreFirm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXDBCtrl, Grids, DBGrids, ComCtrls, Db, StrUtils, Child,
  FR_DSet, FR_DBSet, ActnList, StdCtrls, Buttons, DBCtrls, Variants,
  Math, ExtCtrls, DBGridEh, ToughDBGrid, Registry, OleCtrls, SHDocVw,
  FIBDataSet, pFIBDataSet, FIBSQLMonitor, hlpcodecs, LU_Tracer, FIBQuery,
  pFIBQuery, lU_TSGHashTable, SQLWaiting, ForceRus;

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
    adsCoreCryptBASECOST: TCurrencyField;
    adsCorePriceRet: TCurrencyField;
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
    adsCoreORDERSJUNK: TFIBIntegerField;
    adsCoreORDERSAWAIT: TFIBIntegerField;
    adsCoreORDERSHORDERID: TFIBBCDField;
    adsCoreORDERSHCLIENTID: TFIBBCDField;
    adsCoreORDERSHPRICECODE: TFIBBCDField;
    adsCoreORDERSHREGIONCODE: TFIBBCDField;
    adsCoreORDERSHPRICENAME: TFIBStringField;
    adsCoreORDERSHREGIONNAME: TFIBStringField;
    adsCoreLEADERCODE: TFIBStringField;
    adsCoreLEADERCODECR: TFIBStringField;
    adsCoreCryptLEADERPRICE: TCurrencyField;
    adsOrdersShowFormSummaryORDERPRICEAVG: TFIBBCDField;
    adsOrdersShowFormSummaryFULLCODE: TFIBBCDField;
    adsCoreBASECOST: TFIBStringField;
    adsCoreLEADERPRICE: TFIBStringField;
    adsCoreORDERSPRICE: TFIBStringField;
    pTop: TPanel;
    eSearch: TEdit;
    btnSearch: TButton;
    tmrSearch: TTimer;
    procedure cbFilterClick(Sender: TObject);
    procedure actDeleteOrderExecute(Sender: TObject);
    procedure adsCore2BeforePost(DataSet: TDataSet);
    procedure adsCore2AfterPost(DataSet: TDataSet);
    procedure adsCore2BeforeEdit(DataSet: TDataSet);
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
    procedure TimerTimer(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure dbgCoreKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCoreSortMarkingChanged(Sender: TObject);
    procedure adsCoreLEADERPRICENAMEGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure tmrSearchTimer(Sender: TObject);
    procedure dbgCoreDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
  private
    OldOrder, OrderCount, PriceCode, RegionCode, ClientId: Integer;
    OrderSum: Double;

    UseExcess: Boolean;
    Excess: Integer;
    InternalSearchText : String;

    BM : TBitmap;
    
    fr : TForceRus;
    
    procedure OrderCalc;
    procedure SetOrderLabel;
    procedure SetFilter(Filter: TFilter);
    procedure RefreshOrdersH;
    procedure AllFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure OrderCountFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure LeaderFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure ccf(DataSet: TDataSet);
    procedure SetClear;
    procedure AddKeyToSearch(Key : Char);
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
  NamesForms, Core, AlphaUtils;

{$R *.DFM}

procedure TCoreFirmForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;

  BM := TBitmap.Create;
  
  fr := TForceRus.Create;
  
  InternalSearchText := '';
  adsCore.OnCalcFields := ccf;
	PrintEnabled := False;
	UseExcess := DM.adtClients.FieldByName( 'UseExcess').AsBoolean;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
	ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
	adsOrdersShowFormSummary.ParamByName('AClientId').Value := ClientId;
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\'
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
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\'
		+ Self.ClassName, True);
	dbgCore.SaveToRegistry( Reg);
	Reg.Free;  
  fr.Free;
  BM.Free;
end;

procedure TCoreFirmForm.ShowForm(APriceCode, ARegionCode: Integer;
  OnlyLeaders: Boolean=False);
begin
  PriceCode:=APriceCode;
  RegionCode:=ARegionCode;
  with adsCore do begin
    ParamByName( 'APriceCode').Value:=PriceCode;
    ParamByName( 'ARegionCode').Value:=RegionCode;
    ParamByName( 'AClientId').Value:=ClientId;
    ParamByName( 'APriceName').Value:=PricesForm.adsPrices.FieldByName('PriceName').AsString;
  end;
  RefreshAllCore;
  SetFilter(filAll);
  if adsCore.RecordCount=0 then begin
    MessageBox('¬ыбранный прайс-лист отсутствует',MB_ICONWARNING);
    Abort;
  end;
  //подсчитываем сумму за€вки и количество записей
  SetFilter(filOrder);
  OrderCalc;
  SetOrderLabel;
  if OnlyLeaders then
    SetFilter(filLeader)
  else
    SetFilter(filAll);
  lblFirmPrice.Caption := Format( 'ѕрайс-лист %s, регион %s',[
    PricesForm.adsPrices.FieldByName('PriceName').AsString,
    PricesForm.adsPrices.FieldByName('RegionName').AsString]);
  RefreshOrdersH;
  if not adsOrdersShowFormSummary.Active then
    adsOrdersShowFormSummary.Open;
  adsCore.First;
  Application.ProcessMessages;
  inherited ShowForm;
end;

procedure TCoreFirmForm.ccf(DataSet: TDataSet);
var
  S : String;
  C : Currency;
begin
  try
    S := DM.D_B_N(adsCoreBASECOST.AsString);
    C := StrToCurr(S);
    adsCoreCryptBASECOST.AsCurrency := C;
    adsCorePriceRet.AsCurrency := DM.GetPriceRet(C);
    adsCoreSumOrder.AsCurrency := adsCoreCryptBASECOST.AsCurrency * adsCoreORDERCOUNT.AsInteger;
    S := DM.D_B_N(adsCoreLEADERPRICE.AsString);
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
    filAll:
      begin
        if Length(InternalSearchText) > 0 then
          FP := AllFilterRecord
        else begin
          FP := nil;
          tmrSearch.Enabled := False;
          eSearch.Text := '';
          InternalSearchText := '';
        end;
      end;
    filOrder: FP := OrderCountFilterRecord;
    filLeader: FP := LeaderFilterRecord;
  end;
  DBProc.SetFilterProc(adsCore, FP);
  lblRecordCount.Caption:=Format( 'ѕозиций : %d', [adsCore.VisibleRecordCount]);
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

//переоткрывает заголовок дл€ текущего заказа
//нужна дл€ печати и дл€ поиска текущего OrdersH.OrderId при вводе заказа
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
	PriceAvg: Double;
begin
	try
		{ провер€ем заказ на соответствие наличию товара на складе }
		Val( adsCoreQuantity.AsString, Quantity, E);
		if E <> 0 then Quantity := 0;
		if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity) and
			( MessageBox( '«аказ превышает остаток на складе. ѕродолжить?',
			MB_ICONQUESTION or MB_OKCANCEL) <> IDOK) then adsCoreORDERCOUNT.AsInteger := Quantity;

		{ провер€ем на превышение цены }
		if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) then
		begin
      if (adsOrdersShowFormSummary.Locate('FULLCODE', adsCoreFULLCODE.AsVariant, [])) then
      begin
			PriceAvg := adsOrdersShowFormSummaryORDERPRICEAVG.AsCurrency;
			if ( PriceAvg > 0) and ( adsCoreCryptBASECOST.AsCurrency>PriceAvg*(1+Excess/100)) then
			begin
				plOverCost.Top := ( dbgCore.Height - plOverCost.Height) div 2;
				plOverCost.Left := ( dbgCore.Width - plOverCost.Width) div 2;
				plOverCost.BringToFront;
				plOverCost.Show;
				Timer.Enabled := True;
			end;
      end;
		end;
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
  lblOrderLabel.Caption:=Format('«аказано %d позиций на сумму %0.2f руб.',
    [OrderCount,OrderSum]);
end;

procedure TCoreFirmForm.btnFormHistoryClick(Sender: TObject);
begin
  ShowFormHistory(adsCoreFullCode.AsInteger,ClientId);
end;

procedure TCoreFirmForm.actDeleteOrderExecute(Sender: TObject);
begin
  if not Visible then Exit;
  if MessageBox( '”далить весь заказ по данному прайс-листу?',
    MB_ICONQUESTION or MB_OKCANCEL)<>IDOK then Abort;
  adsCore.DisableControls;
  Screen.Cursor:=crHourGlass;
  try
    DM.adcUpdate.Transaction.StartTransaction;
    try
      with DM.adcUpdate do begin
        //удал€ем сохраненную за€вку (если есть)
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
	//ожидаемый товар выдел€ем зеленым
	if (adsCoreAwait.Value = 1) and ( Column.Field = adsCoreSYNONYMNAME) then
		Background := AWAIT_CLR;
end;

procedure TCoreFirmForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
	if ( Key = VK_RETURN) then btnFormHistoryClick( nil);
  if Key = VK_ESCAPE then
    if Length(InternalSearchText) > 0 then
      SetClear
    else
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
      //добавл€ем запись в OrdersH
      adsCore.Edit;
      adsCoreOrdersHClientId.AsInteger:=ClientId;
      adsCoreOrdersHPriceCode.AsInteger:=PriceCode;
      adsCoreOrdersHRegionCode.AsInteger:=RegionCode;
      adsCoreOrdersHPriceName.AsString:=PricesForm.adsPrices.FieldByName('PriceName').AsString;
      adsCoreOrdersHRegionName.AsString:=PricesForm.adsPrices.FieldByName('RegionName').AsString;
      adsCore.Post; //на этот момент уже имеем OrdersHOrderId (автоинкремент)
    end;
    //добавл€ем запись в Orders
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
    if actNewSearch.Checked then begin
      SetCatalog;
      adsCatalog.Locate('FullCode', FullCode, []);
      CoreForm.ShowForm( adsCatalog.FieldByName( 'FullCode').AsInteger,
        adsCatalog.FieldByName( 'Name').AsString, adsCatalog.FieldByName( 'Form').AsString,
        True, True);
    end
    else begin
      adsNames.Locate( 'AShortCode', ShortCode, []);

      if not actUseForms.Checked then
        CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
          adsNames.FieldByName( 'Name').AsString, '', actUseForms.Checked, False);
      if actUseForms.Checked and ( adsForms.RecordCount < 2) then
        CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
          adsNames.FieldByName( 'Name').AsString,
          adsForms.FieldByName( 'Form').AsString, False, False);
      if actUseForms.Checked and ( adsForms.RecordCount > 1) then
      begin
        adsForms.Locate( 'FullCode', FullCode, []);
        CoreForm.ShowForm( adsForms.FieldByName( 'FullCode').AsInteger,
          adsNames.FieldByName( 'Name').AsString,
          adsForms.FieldByName( 'Form').AsString,
          actUseForms.Checked, False);
      end;
    end;
		CoreForm.adsCore.Locate( 'SynonymCode;SynonymFirmCrCode;PriceCode;RegionCode',
			VarArrayOf([ SynonymCode, SynonymFirmCrCode, lPriceCode, lRegionCode]), []);
	end;
end;

procedure TCoreFirmForm.dbgCoreKeyPress(Sender: TObject; var Key: Char);
begin
	if ( Key > #32) and not ( Key in
		[ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
	begin
    AddKeyToSearch(Key);
  end;
end;

procedure TCoreFirmForm.OrderCountFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if Length(InternalSearchText) > 0 then
    Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
      and not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0)
  else
    Accept := not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0);
end;

procedure TCoreFirmForm.LeaderFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if Length(InternalSearchText) > 0 then
    Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
    and
    (
     ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
      or (abs(adsCoreCryptBASECOST.AsCurrency - adsCoreCryptLEADERPRICE.AsCurrency) < 0.01)
    )
  else
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
    ShowSQLWaiting(adsCore);
    //if adsCore.Active then adsCore.CloseOpen(True) else adsCore.Open;
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

procedure TCoreFirmForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if Length(eSearch.Text) > 2 then begin
    InternalSearchText := LeftStr(eSearch.Text, 50);
    if not Assigned(adsCore.OnFilterRecord) then begin
      adsCore.OnFilterRecord := AllFilterRecord;
      adsCore.Filtered := True;
    end
    else
      DBProc.SetFilterProc(adsCore, adsCore.OnFilterRecord);
    lblRecordCount.Caption:=Format( 'ѕозиций : %d', [adsCore.VisibleRecordCount]);
    eSearch.Text := '';
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TCoreFirmForm.AllFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText);
end;

procedure TCoreFirmForm.SetClear;
var
  p : TFilterRecordEvent;
begin
  tmrSearch.Enabled := False;
  eSearch.Text := '';
  InternalSearchText := '';
  p := AllFilterRecord;
  if @adsCore.OnFilterRecord = @p then begin
    adsCore.Filtered := False;
    adsCore.OnFilterRecord := nil;
  end
  else
    DBProc.SetFilterProc(adsCore, adsCore.OnFilterRecord);
  lblRecordCount.Caption:=Format( 'ѕозиций : %d', [adsCore.VisibleRecordCount]);
end;

procedure TCoreFirmForm.dbgCoreDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if Column.Field = adsCoreSYNONYMNAME then
    ProduceAlphaBlendRect(InternalSearchText, Column.Field.DisplayText, dbgCore.Canvas, Rect, BM);
end;

procedure TCoreFirmForm.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TCoreFirmForm.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //≈сли мы что-то нажали в элементе, то должны на это отреагировать
  tmrSearch.Enabled := True;
end;

procedure TCoreFirmForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + fr.DoIt(Key);
    tmrSearch.Enabled := True;
  end;
end;

end.
