unit Orders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB,  DBCtrls, StdCtrls, Grids, DBGrids, RXDBCtrl,
  Placemnt, FR_DSet, FR_DBSet, DBGridEh, ToughDBGrid, ExtCtrls, FIBDataSet,
  pFIBDataSet, DBProc, AProc, GridsEh;

type
  TOrdersForm = class(TChildForm)
    dsOrders: TDataSource;
    Label1: TLabel;
    dbtId: TDBText;
    Label2: TLabel;
    dbtOrderDate: TDBText;
    lblRecordCount: TLabel;
    lblSum: TLabel;
    dbtPositions: TDBText;
    dbtSumOrder: TDBText;
    frdsOrders: TfrDBDataSet;
    Label4: TLabel;
    dbtPriceName: TDBText;
    Label5: TLabel;
    dbtRegionName: TDBText;
    Panel1: TPanel;
    dbgOrders: TToughDBGrid;
    adsOrders: TpFIBDataSet;
    adsOrdersCryptPRICE: TCurrencyField;
    adsOrdersCryptSUMORDER: TCurrencyField;
    adsOrdersORDERID: TFIBBCDField;
    adsOrdersCLIENTID: TFIBBCDField;
    adsOrdersCOREID: TFIBBCDField;
    adsOrdersFULLCODE: TFIBBCDField;
    adsOrdersCODEFIRMCR: TFIBBCDField;
    adsOrdersSYNONYMCODE: TFIBBCDField;
    adsOrdersSYNONYMFIRMCRCODE: TFIBBCDField;
    adsOrdersCODE: TFIBStringField;
    adsOrdersCODECR: TFIBStringField;
    adsOrdersSYNONYMNAME: TFIBStringField;
    adsOrdersSYNONYMFIRM: TFIBStringField;
    adsOrdersORDERCOUNT: TFIBIntegerField;
    lSumOrder: TLabel;
    adsOrdersPRICE: TFIBStringField;
    adsOrdersAWAIT: TFIBBooleanField;
    adsOrdersJUNK: TFIBBooleanField;
    adsOrdersSUMORDER: TFIBBCDField;
    adsOrdersSENDPRICE: TFIBBCDField;
    adsOrdersREQUESTRATIO: TFIBIntegerField;
    tmrCheckOrderCount: TTimer;
    adsOrdersORDERCOST: TFIBBCDField;
    adsOrdersMINORDERCOUNT: TFIBIntegerField;
    adsOrdersPRODUCTID: TFIBBCDField;
    plOverCost: TPanel;
    lWarning: TLabel;
    Timer: TTimer;
    adsOrdersORDERSREQUESTRATIO: TFIBIntegerField;
    adsOrdersORDERSORDERCOST: TFIBBCDField;
    adsOrdersORDERSMINORDERCOUNT: TFIBIntegerField;
    procedure dbgOrdersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgOrdersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgOrdersSortMarkingChanged(Sender: TObject);
    procedure adsOrdersBeforeEdit(DataSet: TDataSet);
    procedure adsOrdersAfterPost(DataSet: TDataSet);
    procedure dbgOrdersCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure dbgOrdersKeyPress(Sender: TObject; var Key: Char);
    procedure tmrCheckOrderCountTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure adsOrdersBeforePost(DataSet: TDataSet);
  private
    OldOrder, OrderCount: Integer;
    OrderSum: Double;
    ParentOrdersHForm : TChildForm;
    OrderID,
    PriceCode, RegionCode : Integer;
    PriceName, RegionName : String;
    procedure SetOrderLabel;
    procedure ocf(DataSet: TDataSet);
  public
    procedure ShowForm(AOrderId: Integer); overload; //reintroduce;
    procedure ShowForm; override;
    procedure Print( APreview: boolean = False); override;
    procedure SetParams(AOrderId: Integer);
  end;

var
  OrdersForm: TOrdersForm;

implementation

uses OrdersH, DModule, Constant, Main, Math, CoreFirm;

{$R *.dfm}

procedure TOrdersForm.ShowForm(AOrderId: Integer);
begin
  plOverCost.Hide();
  //PrintEnabled:=False;
  dbgOrders.Tag := IfThen(OrdersHForm.TabControl.TabIndex = 1, 1, 2);
  SaveEnabled := OrdersHForm.TabControl.TabIndex = 1;
  ParentOrdersHForm := OrdersHForm;
  PriceCode := OrdersHForm.adsOrdersHFormPRICECODE.AsInteger;
  RegionCode := OrdersHForm.adsOrdersHFormREGIONCODE.AsInteger;
  PriceName := OrdersHForm.adsOrdersHFormPRICENAME.AsString;
  RegionName := OrdersHForm.adsOrdersHFormREGIONNAME.AsString;
  OrderID := AOrderId;
  SetParams(AOrderId);
  inherited ShowForm;
end;

procedure TOrdersForm.SetParams(AOrderId: Integer);
var
	V: array[0..0] of Variant;
  Closed : Variant;
begin
  Closed := DM.MainConnection1.QueryValue('select Closed from ordersh where orderid = ' + IntToStr(AOrderId), 0);
  if Closed = 0 then begin
    adsOrders.OnCalcFields := ocf;
    dbgOrders.Columns[2].FieldName := 'CryptPRICE';
    dbgOrders.Columns[4].FieldName := 'CryptSUMORDER';
    dbgOrders.SearchField := '';
    dbgOrders.ForceRus := False;
  end
  else begin
    adsOrders.OnCalcFields := nil;
    dbgOrders.Columns[2].FieldName := 'SENDPRICE';
    dbgOrders.Columns[4].FieldName := 'SUMORDER';
    dbgOrders.SearchField := 'SynonymName';
    dbgOrders.ForceRus := True;
  end;
  with adsOrders do begin
    ParamByName('AOrderId').Value:=AOrderId;
    if Active then CloseOpen(True) else Open;
    if Closed = 0 then
    	DataSetCalc( adsOrders,['SUM(CryptSUMORDER)'], V)
    else
    	DataSetCalc( adsOrders,['SUM(SUMORDER)'], V);
  	OrderCount := adsOrders.RecordCount;
  	OrderSum := V[0];
    SetOrderLabel;
  end;
end;

procedure TOrdersForm.Print( APreview: boolean = False);
begin
	DM.ShowFastReport( 'Orders.frf', adsOrders, APreview);
end;

procedure TOrdersForm.dbgOrdersGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	{ если уцененный товар, изменяем цвет }
	if adsOrdersJunk.AsBoolean and ( Column.Field = adsOrdersCryptPRICE) then
		Background := JUNK_CLR;
	//ожидаемый товар выделяем зеленым
	if adsOrdersAwait.AsBoolean and ( Column.Field = adsOrdersSYNONYMNAME) then
		Background := AWAIT_CLR;
end;

procedure TOrdersForm.dbgOrdersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if Key = VK_ESCAPE then
    if Assigned(ParentOrdersHForm) then
      ParentOrdersHForm.ShowForm
    else
      PrevForm.ShowForm;
end;

procedure TOrdersForm.ocf(DataSet: TDataSet);
var
  S : String;
begin
  try
    S := DM.D_B_N(adsOrdersPRICE.AsString);
    adsOrdersCryptPRICE.AsString := S;
    adsOrdersCryptSUMORDER.AsCurrency := StrToCurr(S) * adsOrdersORDERCOUNT.AsInteger;
  except
  end;
end;

procedure TOrdersForm.dbgOrdersSortMarkingChanged(Sender: TObject);
begin
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TOrdersForm.adsOrdersBeforeEdit(DataSet: TDataSet);
begin
  OldOrder:=adsOrdersORDERCOUNT.AsInteger;
  DM.SetOldOrderCount(adsOrdersORDERCOUNT.AsInteger);
end;

procedure TOrdersForm.adsOrdersAfterPost(DataSet: TDataSet);
begin
	OrderCount := OrderCount + Iif( adsOrdersORDERCOUNT.AsInteger = 0, 0, 1) - Iif( OldOrder = 0, 0, 1);
	OrderSum := OrderSum + ( adsOrdersORDERCOUNT.AsInteger - OldOrder) * adsOrdersCryptPRICE.AsCurrency;
  DM.SetNewOrderCount(adsOrdersORDERCOUNT.AsInteger, adsOrdersCryptPRICE.AsCurrency, OrdersHForm.adsOrdersHFormPRICECODE.AsInteger, OrdersHForm.adsOrdersHFormREGIONCODE.AsInteger);
  SetOrderLabel;
	MainForm.SetOrdersInfo;
  //Если удалили позицию из заказа, то запускаем таймер на удаление этой позиции из DataSet
  if (adsOrdersORDERCOUNT.AsInteger = 0) then
    tmrCheckOrderCount.Enabled := True;
end;

procedure TOrdersForm.SetOrderLabel;
begin
  lSumOrder.Caption := Format('%0.2f', [OrderSum]);
end;

procedure TOrdersForm.dbgOrdersCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
  inherited;
  CanInput := OrdersHForm.TabControl.TabIndex = 0;
end;

procedure TOrdersForm.FormCreate(Sender: TObject);
begin
  dsCheckVolume := adsOrders;
  dgCheckVolume := dbgOrders;
  fOrder := adsOrdersORDERCOUNT;
  fVolume := adsOrdersREQUESTRATIO;
  fOrderCost := adsOrdersORDERCOST;
  fSumOrder := adsOrdersCryptSUMORDER;
  fMinOrderCount := adsOrdersMINORDERCOUNT;
  inherited;
end;

procedure TOrdersForm.dbgOrdersKeyPress(Sender: TObject; var Key: Char);
var
  _CoreFirmForm : TCoreFirmForm;
begin
	if ( Key > #32) and not ( Key in
		[ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
	begin
    _CoreFirmForm := TCoreFirmForm( FindChildControlByClass(MainForm, TCoreFirmForm) );
    if not Assigned(_CoreFirmForm) then
      _CoreFirmForm := TCoreFirmForm.Create(Application);
    _CoreFirmForm.ShowForm(PriceCode, RegionCode, PriceName, RegionName, False, True);
    _CoreFirmForm.dbgCore.SetFocus;
    _CoreFirmForm.eSearch.Text := '';
    SendMessage(GetFocus, WM_CHAR, Ord( Key), 0);
	end;
end;

procedure TOrdersForm.ShowForm;
begin
  inherited;
  //Если мы производим возврат и формы "Заявка поставщику", то надо обновить данные
  if Assigned(PrevForm) and (PrevForm is TCoreFirmForm) then
    SetParams(OrderID);
end;

procedure TOrdersForm.tmrCheckOrderCountTimer(Sender: TObject);
begin
  tmrCheckOrderCount.Enabled := False;
  SetOrderLabel;
  MainForm.SetOrdersInfo;
  adsOrders.Delete;
  if adsOrders.RecordCount = 0 then begin
    DM.adcUpdate.Transaction.StartTransaction;
    try
      DM.adcUpdate.SQL.Text := 'delete from OrdersH where OrderId = ' + OrdersHForm.adsOrdersHFormORDERID.AsString;
      OrdersHForm.adsOrdersHForm.Close;
      DM.adcUpdate.ExecQuery;
      DM.adcUpdate.Transaction.Commit;
    except
      DM.adcUpdate.Transaction.Rollback;
      raise;
    end;
    OrdersHForm.adsOrdersHForm.Open;
    MainForm.SetOrdersInfo;
    PrevForm.ShowForm;
  end
  else begin
    OrdersHForm.adsOrdersHForm.Refresh;
    MainForm.SetOrdersInfo;
  end;
end;

procedure TOrdersForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

procedure TOrdersForm.adsOrdersBeforePost(DataSet: TDataSet);
var
  PanelCaption : String;
  PanelHeight : Integer;
begin
  PanelCaption := '';

  if (adsOrdersORDERCOUNT.AsInteger > WarningOrderCount) then
    if Length(PanelCaption) > 0 then
      PanelCaption := PanelCaption + #13#10 + 'Внимание! Вы заказали большое количество препарата.'
    else
      PanelCaption := 'Внимание! Вы заказали большое количество препарата.';

  if Length(PanelCaption) > 0 then begin
    if Timer.Enabled then
      Timer.OnTimer(nil);

    lWarning.Caption := PanelCaption;
    PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
    plOverCost.Height := PanelHeight*WordCount(PanelCaption, [#13, #10]) + 20;

    plOverCost.Top := ( dbgOrders.Height - plOverCost.Height) div 2;
    plOverCost.Left := ( dbgOrders.Width - plOverCost.Width) div 2;
    plOverCost.BringToFront;
    plOverCost.Show;
    Timer.Enabled := True;
  end;
end;

end.
