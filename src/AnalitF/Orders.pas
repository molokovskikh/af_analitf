unit Orders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB,  DBCtrls, StdCtrls, Grids, DBGrids, RXDBCtrl,
  Placemnt, FR_DSet, FR_DBSet, DBGridEh, ToughDBGrid, ExtCtrls, FIBDataSet,
  pFIBDataSet, DBProc, AProc, GridsEh, U_frameLegend, MemDS, DBAccess,
  MyAccess;

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
    adsOrdersOld: TpFIBDataSet;
    adsOrdersOldCryptPRICE: TCurrencyField;
    adsOrdersOldCryptSUMORDER: TCurrencyField;
    adsOrdersOldORDERID: TFIBBCDField;
    adsOrdersOldCLIENTID: TFIBBCDField;
    adsOrdersOldCOREID: TFIBBCDField;
    adsOrdersOldFULLCODE: TFIBBCDField;
    adsOrdersOldCODEFIRMCR: TFIBBCDField;
    adsOrdersOldSYNONYMCODE: TFIBBCDField;
    adsOrdersOldSYNONYMFIRMCRCODE: TFIBBCDField;
    adsOrdersOldCODE: TFIBStringField;
    adsOrdersOldCODECR: TFIBStringField;
    adsOrdersOldSYNONYMNAME: TFIBStringField;
    adsOrdersOldSYNONYMFIRM: TFIBStringField;
    adsOrdersOldORDERCOUNT: TFIBIntegerField;
    lSumOrder: TLabel;
    adsOrdersOldPRICE: TFIBStringField;
    adsOrdersOldAWAIT: TFIBBooleanField;
    adsOrdersOldJUNK: TFIBBooleanField;
    adsOrdersOldSUMORDER: TFIBBCDField;
    adsOrdersOldSENDPRICE: TFIBBCDField;
    adsOrdersOldREQUESTRATIO: TFIBIntegerField;
    tmrCheckOrderCount: TTimer;
    adsOrdersOldORDERCOST: TFIBBCDField;
    adsOrdersOldMINORDERCOUNT: TFIBIntegerField;
    adsOrdersOldPRODUCTID: TFIBBCDField;
    plOverCost: TPanel;
    lWarning: TLabel;
    Timer: TTimer;
    adsOrdersOldORDERSREQUESTRATIO: TFIBIntegerField;
    adsOrdersOldORDERSORDERCOST: TFIBBCDField;
    adsOrdersOldORDERSMINORDERCOUNT: TFIBIntegerField;
    frameLegeng: TframeLegeng;
    adsOrders: TMyQuery;
    adsOrdersOrderId: TLargeintField;
    adsOrdersClientId: TLargeintField;
    adsOrdersCoreId: TLargeintField;
    adsOrdersfullcode: TLargeintField;
    adsOrdersproductid: TLargeintField;
    adsOrderscodefirmcr: TLargeintField;
    adsOrderssynonymcode: TLargeintField;
    adsOrderssynonymfirmcrcode: TLargeintField;
    adsOrderscode: TStringField;
    adsOrderscodecr: TStringField;
    adsOrderssynonymname: TStringField;
    adsOrderssynonymfirm: TStringField;
    adsOrdersawait: TBooleanField;
    adsOrdersjunk: TBooleanField;
    adsOrdersordercount: TIntegerField;
    adsOrdersprice: TFloatField;
    adsOrdersrequestratio: TIntegerField;
    adsOrdersordercost: TFloatField;
    adsOrdersminordercount: TIntegerField;
    adsOrdersOrdersrequestratio: TIntegerField;
    adsOrdersOrdersordercost: TFloatField;
    adsOrdersOrdersminordercount: TIntegerField;
    adsOrdersSumOrder: TCurrencyField;
    procedure dbgOrdersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgOrdersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgOrdersSortMarkingChanged(Sender: TObject);
    procedure adsOrdersOldAfterPost(DataSet: TDataSet);
    procedure dbgOrdersCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure dbgOrdersKeyPress(Sender: TObject; var Key: Char);
    procedure tmrCheckOrderCountTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure adsOrdersOldBeforePost(DataSet: TDataSet);
    procedure dbgOrdersDblClick(Sender: TObject);
  private
    ParentOrdersHForm : TChildForm;
    OrderID,
    PriceCode, RegionCode : Integer;
    PriceName, RegionName : String;
    procedure SetOrderLabel;
    procedure ocf(DataSet: TDataSet);
    procedure FlipToCore;
  public
    procedure ShowForm(AOrderId: Integer); overload; //reintroduce;
    procedure ShowForm; override;
    procedure Print( APreview: boolean = False); override;
    procedure SetParams(AOrderId: Integer);
  end;

var
  OrdersForm: TOrdersForm;

implementation

uses OrdersH, DModule, Constant, Main, Math, CoreFirm, NamesForms, Core;

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
  Closed : Variant;
begin
  Closed := DM.QueryValue('select Closed from ordershead where orderid = ' + IntToStr(AOrderId), [], []);
  adsOrders.OnCalcFields := ocf;
  dbgOrders.Columns[2].FieldName := 'PRICE';
  dbgOrders.Columns[4].FieldName := 'SumOrder';
  if Closed = 0 then begin
    dbgOrders.SearchField := '';
    dbgOrders.ForceRus := False;
  end
  else begin
    dbgOrders.SearchField := 'SynonymName';
    dbgOrders.ForceRus := True;
  end;
  with adsOrders do begin
    ParamByName('AOrderId').Value:=AOrderId;
    if Active
    then begin
      Close;
      Open;
    end
    else
      Open;
    SetOrderLabel;
  end;
end;

procedure TOrdersForm.Print( APreview: boolean = False);
begin
  DM.ShowOrderDetailsReport(
    OrdersHForm.adsOrdersHFormORDERID.AsInteger,
    OrdersHForm.adsOrdersHFormCLOSED.Value,
    OrdersHForm.adsOrdersHFormSEND.Value,
    APreview);
end;

procedure TOrdersForm.dbgOrdersGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	{ если уцененный товар, изменяем цвет }
	if adsOrdersJunk.AsBoolean and ( Column.Field = adsOrdersPRICE) then
		Background := JUNK_CLR;
	//ожидаемый товар выделяем зеленым
	if adsOrdersAwait.AsBoolean and ( Column.Field = adsOrdersSYNONYMNAME) then
		Background := AWAIT_CLR;
end;

procedure TOrdersForm.dbgOrdersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN
  then
    FlipToCore
  else
    if Key = VK_ESCAPE then
      if Assigned(ParentOrdersHForm) then
        ParentOrdersHForm.ShowForm
      else
        PrevForm.ShowForm;
end;

procedure TOrdersForm.dbgOrdersSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TOrdersForm.adsOrdersOldAfterPost(DataSet: TDataSet);
begin
  SetOrderLabel;
	MainForm.SetOrdersInfo;
  //Если удалили позицию из заказа, то запускаем таймер на удаление этой позиции из DataSet
  if (adsOrdersORDERCOUNT.AsInteger = 0) then
    tmrCheckOrderCount.Enabled := True;
end;

procedure TOrdersForm.SetOrderLabel;
begin
  lSumOrder.Caption := Format('%0.2f', [ DM.GetSumOrder(OrderID) ]);
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
  fSumOrder := adsOrdersSUMORDER;
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
  if Assigned(PrevForm) and ((PrevForm is TCoreFirmForm) or (PrevForm is TCoreForm)) then
    SetParams(OrderID);
end;

procedure TOrdersForm.tmrCheckOrderCountTimer(Sender: TObject);
begin
  tmrCheckOrderCount.Enabled := False;
  SetOrderLabel;
  MainForm.SetOrdersInfo;
  adsOrders.Delete;
  if adsOrders.RecordCount = 0 then begin
    DM.adcUpdate.SQL.Text := 'delete from OrdersHead where OrderId = ' + OrdersHForm.adsOrdersHFormORDERID.AsString;
    OrdersHForm.adsOrdersHForm.Close;
    DM.adcUpdate.Execute;
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

procedure TOrdersForm.ocf(DataSet: TDataSet);
begin
  try
    adsOrdersSumOrder.AsCurrency := adsOrdersprice.AsCurrency * adsOrdersORDERCOUNT.AsInteger;
  except
  end;
end;

procedure TOrdersForm.adsOrdersOldBeforePost(DataSet: TDataSet);
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

procedure TOrdersForm.FlipToCore;
var
  FullCode, ShortCode: integer;
  CoreId : Int64;
begin
  if MainForm.ActiveChild <> Self then exit;
  if adsOrders.IsEmpty then Exit;

	FullCode := adsOrdersFullCode.AsInteger;
	ShortCode := DM.QueryValue('select ShortCode from catalogs where FullCode = ' + IntToStr(FullCode), [] , []);

  CoreId := adsOrdersCOREID.AsLargeInt;

//  FlipToCode(FullCode, ShortCode, CoreId, Self);
end;

procedure TOrdersForm.dbgOrdersDblClick(Sender: TObject);
begin
  FlipToCore
end;

end.
