unit Orders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB,  DBCtrls, StdCtrls, Grids, DBGrids, RXDBCtrl,
  Placemnt, FR_DSet, FR_DBSet, DBGridEh, ToughDBGrid, ExtCtrls, FIBDataSet,
  pFIBDataSet, DBProc, AProc;

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
    adsOrdersAWAIT: TFIBIntegerField;
    adsOrdersJUNK: TFIBIntegerField;
    adsOrdersORDERCOUNT: TFIBIntegerField;
    adsOrdersSUMORDER: TFIBBCDField;
    lSumOrder: TLabel;
    adsOrdersPRICE: TFIBStringField;
    procedure dbgOrdersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgOrdersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgOrdersSortMarkingChanged(Sender: TObject);
    procedure adsOrdersBeforeEdit(DataSet: TDataSet);
    procedure adsOrdersAfterPost(DataSet: TDataSet);
  private
    OldOrder, OrderCount: Integer;
    OrderSum: Double;
    procedure SetOrderLabel;
    procedure ocf(DataSet: TDataSet);
  public
    procedure ShowForm(AOrderId: Integer); reintroduce;
    procedure Print( APreview: boolean = False); override;
    procedure SetParams(AOrderId: Integer);
  end;

var
  OrdersForm: TOrdersForm;

implementation

uses OrdersH, DModule, Constant, Main;

{$R *.dfm}

procedure TOrdersForm.ShowForm(AOrderId: Integer);
begin
  //PrintEnabled:=False;
  SaveEnabled := OrdersHForm.TabControl.TabIndex = 1;
  SetParams(AOrderId);
  inherited ShowForm;
end;

procedure TOrdersForm.SetParams(AOrderId: Integer);
var
	V: array[0..0] of Variant;
begin
  adsOrders.OnCalcFields := ocf;
  with adsOrders do begin
    ParamByName('AOrderId').Value:=AOrderId;
    if Active then CloseOpen(True) else Open;
  	DataSetCalc( adsOrders,['SUM(CryptSUMORDER)'], V);
  	OrderCount := adsOrders.RecordCount;
  	OrderSum := V[0];
    SetOrderLabel;
//    lSumOrder.Caption := V[0];
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
	inherited;
	if Key = VK_ESCAPE then PrevForm.ShowForm;
	if ( Key = VK_DELETE) and not ( adsOrders.IsEmpty) and (OrdersHForm.TabControl.TabIndex = 0) then
	begin
    OrderCount := OrderCount + Iif( 0 = 0, 0, 1) - Iif( adsOrdersORDERCOUNT.AsInteger = 0, 0, 1);
    OrderSum := OrderSum + ( 0 - adsOrdersORDERCOUNT.AsInteger) * adsOrdersCryptPRICE.AsCurrency;
    DM.SetOldOrderCount(adsOrdersORDERCOUNT.AsInteger);
    DM.SetNewOrderCount(0, adsOrdersCryptPRICE.AsCurrency);
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
      OrdersHForm.adsOrdersHForm.CloseOpen(True);
      MainForm.SetOrdersInfo;
    end;

	end;
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
  DM.SetNewOrderCount(adsOrdersORDERCOUNT.AsInteger, adsOrdersCryptPRICE.AsCurrency);
  SetOrderLabel;
	MainForm.SetOrdersInfo;
end;

procedure TOrdersForm.SetOrderLabel;
begin
  lSumOrder.Caption := Format('%0.2f', [OrderSum]);
end;

end.
