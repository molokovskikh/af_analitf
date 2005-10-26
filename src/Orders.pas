unit Orders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB,  DBCtrls, StdCtrls, Grids, DBGrids, RXDBCtrl,
  Placemnt, FR_DSet, FR_DBSet, DBGridEh, ToughDBGrid, ExtCtrls, FIBDataSet,
  pFIBDataSet, DBProc;

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
    adsOrdersCryptSYNONYMNAME: TStringField;
    adsOrdersCryptSYNONYMFIRM: TStringField;
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
    adsOrdersPRICE: TFIBStringField;
    adsOrdersAWAIT: TFIBIntegerField;
    adsOrdersJUNK: TFIBIntegerField;
    adsOrdersORDERCOUNT: TFIBIntegerField;
    adsOrdersSUMORDER: TFIBBCDField;
    lSumOrder: TLabel;
    procedure dbgOrdersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgOrdersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure adsOrdersCalcFields(DataSet: TDataSet);
    procedure dbgOrdersSortMarkingChanged(Sender: TObject);
  private
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
  SetParams(AOrderId);
  inherited ShowForm;
end;

procedure TOrdersForm.SetParams(AOrderId: Integer);
var
	V: array[0..0] of Variant;
begin
  with adsOrders do begin
    ParamByName('AOrderId').Value:=AOrderId;
    if Active then CloseOpen(True) else Open;
  	DataSetCalc( adsOrders,['SUM(CryptSUMORDER)'], V);
    lSumOrder.Caption := V[0];
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
	if adsOrdersAwait.AsBoolean and ( Column.Field = adsOrdersCryptSYNONYMNAME) then
		Background := AWAIT_CLR;
end;

procedure TOrdersForm.dbgOrdersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
	if Key = VK_ESCAPE then PrevForm.ShowForm;
	if ( Key = VK_DELETE) and not ( adsOrders.IsEmpty) then
	begin
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

procedure TOrdersForm.adsOrdersCalcFields(DataSet: TDataSet);
var
  S : String;
begin
  try
    adsOrdersCryptSYNONYMNAME.AsString := DM.D_S(adsOrdersSYNONYMNAME.AsString);
    adsOrdersCryptSYNONYMFIRM.AsString := DM.D_S(adsOrdersSYNONYMFIRM.AsString);
    S := DM.D_B(adsOrdersCODE.AsString, adsOrdersCODECR.AsString);
    adsOrdersCryptPRICE.AsString := S;
    adsOrdersCryptSUMORDER.AsCurrency := StrToFloat(S) * adsOrdersORDERCOUNT.AsInteger;
  except

  end;
end;

procedure TOrdersForm.dbgOrdersSortMarkingChanged(Sender: TObject);
begin
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

end.
