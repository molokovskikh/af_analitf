unit Orders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB, ADODB, DBCtrls, StdCtrls, Grids, DBGrids, RXDBCtrl,
  Placemnt, FR_DSet, FR_DBSet, DBGridEh, ToughDBGrid, ExtCtrls;

type
  TOrdersForm = class(TChildForm)
    adsOrders: TADODataSet;
    dsOrders: TDataSource;
    Label1: TLabel;
    dbtId: TDBText;
    Label2: TLabel;
    dbtOrderDate: TDBText;
    adsOrdersPrice: TBCDField;
    adsOrdersOrder: TIntegerField;
    adsOrdersSumOrder: TBCDField;
    lblRecordCount: TLabel;
    lblSum: TLabel;
    dbtPositions: TDBText;
    dbtSumOrder: TDBText;
    frdsOrders: TfrDBDataSet;
    Label4: TLabel;
    dbtPriceName: TDBText;
    Label5: TLabel;
    dbtRegionName: TDBText;
    adsOrdersOrderId: TIntegerField;
    adsOrdersFullCode: TIntegerField;
    adsOrdersSynonymCode: TIntegerField;
    adsOrdersSynonymFirmCrCode: TIntegerField;
    adsOrdersCode: TWideStringField;
    adsOrdersSynonym: TWideStringField;
    adsOrdersSynonymFirm: TWideStringField;
    adsOrdersJunk: TBooleanField;
    Panel1: TPanel;
    dbgOrders: TToughDBGrid;
    adsOrdersCodeCr: TWideStringField;
    adsOrdersAwait: TBooleanField;
    procedure dbgOrdersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgOrdersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
  PrintEnabled:=True;
  SetParams(AOrderId);
  inherited ShowForm;
end;

procedure TOrdersForm.SetParams(AOrderId: Integer);
begin
  with adsOrders do begin
    Parameters.ParamByName('AOrderId').Value:=AOrderId;
    if Active then Requery else Open;
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
	if adsOrdersJunk.AsBoolean and ( Column.FieldName = 'Price') then
		Background := JUNK_CLR;
	//ожидаемый товар выделяем зеленым
	if adsOrdersAwait.AsBoolean and ( Column.FieldName = 'Synonym') then
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
      DM.adcUpdate.SQL.Text := 'delete from OrdersH where OrderId = ' + OrdersHForm.adsOrdersHOrderId.AsString;
      OrdersHForm.adsOrdersH.Close;
      DM.adcUpdate.ExecQuery;
      OrdersHForm.adsOrdersH.Open;
      MainForm.SetOrdersInfo;
      PrevForm.ShowForm;
    end
    else begin
      OrdersHForm.adsOrdersH.Requery;
      MainForm.SetOrdersInfo;
    end;

	end;
end;

end.
