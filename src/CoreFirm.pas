unit CoreFirm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXDBCtrl, Grids, DBGrids, ComCtrls, Db, StrUtils, Child, ADODB,
  FR_DSet, FR_DBSet, ActnList, StdCtrls, Buttons, DBCtrls, Variants, ADOInt,
  Math, ExtCtrls, DBGridEh, ToughDBGrid, Registry, OleCtrls, SHDocVw;

const
	CoreSql =	'SELECT * FROM CoreShowByFirm ORDER BY ';

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
    adsOrdersH: TADODataSet;
    btnFormHistory: TSpeedButton;
    adsCountFields: TADODataSet;
    lblFirmPrice: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    dbgCore: TToughDBGrid;
    adsOrdersShowFormSummary: TADODataSet;
    adsOrdersShowFormSummaryPriceAvg: TBCDField;
    plOverCost: TPanel;
    Timer: TTimer;
    adsCore: TADODataSet;
    adsCoreCoreId: TAutoIncField;
    adsCoreFullCode: TIntegerField;
    adsCoreShortCode: TIntegerField;
    adsCoreCodeFirmCr: TIntegerField;
    adsCoreSynonymCode: TIntegerField;
    adsCoreSynonymFirmCrCode: TIntegerField;
    adsCoreCode: TWideStringField;
    adsCoreCodeCr: TWideStringField;
    adsCoreVolume: TWideStringField;
    adsCoreDoc: TWideStringField;
    adsCoreNote: TWideStringField;
    adsCorePeriod: TWideStringField;
    adsCoreAwait: TBooleanField;
    adsCoreJunk: TBooleanField;
    adsCoreBaseCost: TBCDField;
    adsCoreQuantity: TWideStringField;
    adsCoreSynonym: TWideStringField;
    adsCoreSynonymFirm: TWideStringField;
    adsCoreMinPrice: TBCDField;
    adsCoreLeaderFirmCode: TIntegerField;
    adsCoreLeaderRegionCode: TIntegerField;
    adsCoreLeaderRegionName: TWideStringField;
    adsCoreOrdersCoreId: TIntegerField;
    adsCoreOrdersOrderId: TIntegerField;
    adsCoreOrdersClientId: TSmallintField;
    adsCoreOrdersFullCode: TIntegerField;
    adsCoreOrdersCodeFirmCr: TIntegerField;
    adsCoreOrdersSynonymCode: TIntegerField;
    adsCoreOrdersSynonymFirmCrCode: TIntegerField;
    adsCoreOrdersCode: TWideStringField;
    adsCoreOrdersCodeCr: TWideStringField;
    adsCoreOrder: TIntegerField;
    adsCoreOrdersSynonym: TWideStringField;
    adsCoreOrdersSynonymFirm: TWideStringField;
    adsCoreOrdersPrice: TBCDField;
    adsCoreOrdersJunk: TBooleanField;
    adsCoreOrdersAwait: TBooleanField;
    adsCoreOrdersHOrderId: TAutoIncField;
    adsCoreOrdersHClientId: TSmallintField;
    adsCoreOrdersHPriceCode: TIntegerField;
    adsCoreOrdersHRegionCode: TIntegerField;
    adsCoreOrdersHPriceName: TWideStringField;
    adsCoreOrdersHRegionName: TWideStringField;
    adsCorePriceRet: TFloatField;
    adsCoreSumOrder: TBCDField;
    Bevel1: TBevel;
    adsCoreLeaderPriceName: TWideStringField;
    actFlipCore: TAction;
    procedure cbFilterClick(Sender: TObject);
    procedure actDeleteOrderExecute(Sender: TObject);
    procedure adsCoreBeforePost(DataSet: TDataSet);
    procedure adsCoreAfterPost(DataSet: TDataSet);
    procedure adsCoreBeforeEdit(DataSet: TDataSet);
    procedure adsCoreCalcFields(DataSet: TDataSet);
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
    procedure dbgCoreSortChange(Sender: TObject; SQLOrderBy: String);
    procedure adsCoreAfterOpen(DataSet: TDataSet);
    procedure adsCoreBeforeClose(DataSet: TDataSet);
    procedure TimerTimer(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
  private
    OldOrder, OrderCount, PriceCode, RegionCode, ClientId: Integer;
    OrderSum: Double;

    UseExcess: Boolean;
    Excess: Integer;

    procedure OrderCalc;
    procedure SetOrderLabel;
    procedure SetFilter(Filter: TFilter);
    procedure RefreshOrdersH;
  public
    procedure ShowForm(APriceCode, ARegionCode: Integer;
      OnlyLeaders: Boolean=False); reintroduce;
    procedure Print( APreview: boolean = False); override;
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
	PrintEnabled := True;
	UseExcess := DM.adtClients.FieldByName( 'UseExcess').AsBoolean;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
	ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
	adsOrdersShowFormSummary.Parameters.ParamByName('AClientId').Value := ClientId;
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, False) then dbgCore.LoadFromRegistry( Reg);
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
    Parameters.ParamByName( 'RetailForcount').Value:=DM.adtClients.FieldByName( 'Forcount').Value;
    Parameters.ParamByName( 'APriceCode').Value:=PriceCode;
    Parameters.ParamByName( 'ARegionCode').Value:=RegionCode;
    Parameters.ParamByName( 'AClientId').Value:=ClientId;
    Screen.Cursor:=crHourglass;
    try
      if Active then Requery else Open;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
  SetFilter(filAll);
  if adsCore.RecordCount=0 then begin
    MessageBox('Выбранный прайс-лист отсутствует',MB_ICONWARNING);
    Abort;
  end;
  //определяем, какие колонки прайс-листа фирмы показывать (не показываем пустые)
  with adsCountFields do begin
    Parameters.ParamByName('APriceCode').Value:=PriceCode;
    Parameters.ParamByName('ARegionCode').Value:=RegionCode;
    Open;
    try
      ColumnByNameT(dbgCore,'Code').Visible:=FieldByName('Code').AsInteger>0;
      ColumnByNameT(dbgCore,'SynonymFirm').Visible:=FieldByName('SynonymFirm').AsInteger>0;
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
  inherited ShowForm;
end;

procedure TCoreFirmForm.adsCoreCalcFields(DataSet: TDataSet);
begin
	adsCoreSumOrder.AsCurrency :=
		adsCoreBaseCost.AsCurrency * adsCoreOrder.AsInteger;
end;

procedure TCoreFirmForm.SetFilter(Filter: TFilter);
var
  St: string;
begin
  case Filter of
    filAll: St:= '';
    filOrder: St:= 'Order > 0';
    filLeader: St:=Format( 'LeaderPriceCode = %d AND LeaderRegionCode = %d',
    	[PriceCode, RegionCode]);
  end;
  DBProc.SetFilter(adsCore,St);
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
    Parameters.ParamByName('AClientId').Value:=ClientId;
    Parameters.ParamByName('APriceCode').Value:=PriceCode;
    Parameters.ParamByName('ARegionCode').Value:=RegionCode;
    if Active then Requery else Open;
  end;
end;

procedure TCoreFirmForm.adsCoreBeforeEdit(DataSet: TDataSet);
begin
  OldOrder:=adsCoreOrder.AsInteger;
end;

procedure TCoreFirmForm.adsCoreBeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
	PriceAvg: Double;
begin
	try
		{ проверяем заказ на соответствие наличию товара на складе }
		Val( adsCoreQuantity.AsString, Quantity, E);
		if E <> 0 then Quantity := 0;
		if ( Quantity > 0) and ( adsCoreOrder.AsInteger > Quantity) and
			( MessageBox( 'Заказ превышает остаток на складе. Продолжить?',
			MB_ICONQUESTION or MB_OKCANCEL) <> IDOK) then adsCoreOrder.AsInteger := Quantity;

		{ проверяем на превышение цены }
		if UseExcess and ( adsCoreOrder.AsInteger>0) then
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
        except
		adsCore.Cancel;
		raise;
	end;
end;

procedure TCoreFirmForm.adsCoreAfterPost(DataSet: TDataSet);
begin
	OrderCount := OrderCount + Iif( adsCoreOrder.AsInteger = 0, 0, 1) - Iif( OldOrder = 0, 0, 1);
	OrderSum := OrderSum + ( adsCoreOrder.AsInteger - OldOrder) * adsCoreBaseCost.AsCurrency;
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
    with DM.adcUpdate do begin
      //удаляем сохраненную заявку (если есть)
      CommandText:=Format( 'EXECUTE OrdersHDeleteNotClosed %d, %d, %d',
        [DM.adtClients.FieldByName('ClientId').AsInteger,PriceCode,RegionCode]);
      Execute;
    end;
  finally
    adsCore.EnableControls;
    adsCore.Requery;
    adsOrdersH.Requery;
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
	if ( adsCoreLeaderFirmCode.AsInteger = PriceCode) and
        	( adsCoreLeaderRegionCode.AsInteger = RegionCode) and
		(( Column.FieldName = 'LeaderRegionName') or ( Column.FieldName = 'LeaderPriceName')) then
			Background := LEADER_CLR;
	//уцененный товар
	if adsCoreJunk.AsBoolean and (( Column.FieldName = 'Period') or
		( Column.FieldName = 'BaseCost')) then Background := JUNK_CLR;
	//ожидаемый товар выделяем зеленым
	if adsCoreAwait.AsBoolean and ( Column.FieldName = 'Synonym') then
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
	CanInput := ( adsCore.Parameters.ParamByName( 'ARegionCode').Value and
		DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
		adsCore.Parameters.ParamByName( 'ARegionCode').Value;
	if not CanInput then Exit;
	{ создаем записи из Orders и OrdersH, если их нет }
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
    adsCoreOrdersSynonym.AsString := adsCoreSynonym.AsString;
    adsCoreOrdersSynonymFirm.AsString := adsCoreSynonymFirm.AsString;
    adsCore.Post;
    if adsOrdersH.IsEmpty then RefreshOrdersH;
  end;
end;

procedure TCoreFirmForm.dbgCoreSortChange(Sender: TObject;
  SQLOrderBy: String);
begin
	adsCore.DisableControls;
	adsCore.Close;
	adsCore.CommandText := CoreSql + SQLOrderBy;
	adsCore.Parameters.ParamByName( 'RetailForcount').Value := DM.adtClients.FieldByName( 'Forcount').Value;
	adsCore.Parameters.ParamByName( 'APriceCode').Value := PriceCode;
	adsCore.Parameters.ParamByName( 'ARegionCode').Value := RegionCode;
	adsCore.Parameters.ParamByName( 'AClientId').Value := ClientId;
	Screen.Cursor := crHourglass;
	try
		adsCore.Open;
	finally
		adsCore.EnableControls;
		Screen.Cursor := crDefault;
	end;
end;

procedure TCoreFirmForm.adsCoreAfterOpen(DataSet: TDataSet);
begin
	adsOrdersShowFormSummary.Open;
end;

procedure TCoreFirmForm.adsCoreBeforeClose(DataSet: TDataSet);
begin
	adsOrdersShowFormSummary.Close;
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

end.
