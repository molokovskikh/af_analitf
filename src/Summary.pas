unit Summary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, DB,
  DBCtrls, StdCtrls, Placemnt, FR_DSet, FR_DBSet, Buttons, DBGridEh,
  ToughDBGrid, ExtCtrls, Registry, OleCtrls, SHDocVw, FIBDataSet,
  pFIBDataSet, DBProc, ComCtrls, CheckLst, Menus;

const
	SummarySql	= 'SELECT * FROM SUMMARYSHOW(:ACLIENTID)  ORDER BY ';

type
  TSummaryForm = class(TChildForm)
    dsSummary: TDataSource;
    dsSummaryH: TDataSource;
    frdsSummary: TfrDBDataSet;
    pClient: TPanel;
    dbgSummary: TToughDBGrid;
    adsSummary: TpFIBDataSet;
    adsSummaryVOLUME: TFIBStringField;
    adsSummaryQUANTITY: TFIBStringField;
    adsSummaryNOTE: TFIBStringField;
    adsSummaryPERIOD: TFIBStringField;
    adsSummaryJUNK: TFIBIntegerField;
    adsSummaryAWAIT: TFIBIntegerField;
    adsSummarySYNONYMNAME: TFIBStringField;
    adsSummarySYNONYMFIRM: TFIBStringField;
    adsSummaryPRICENAME: TFIBStringField;
    adsSummaryREGIONNAME: TFIBStringField;
    adsSummaryORDERCOUNT: TFIBIntegerField;
    adsSummaryORDERSCOREID: TFIBBCDField;
    adsSummaryORDERSORDERID: TFIBBCDField;
    adsSummarySumOrder: TCurrencyField;
    adsSummaryH: TpFIBDataSet;
    adsSummaryCryptSYNONYMNAME: TStringField;
    adsSummaryCryptSYNONYMFIRM: TStringField;
    adsSummaryCryptBASECOST: TCurrencyField;
    adsSummaryCODE: TFIBStringField;
    adsSummaryCODECR: TFIBStringField;
    adsSummaryBASECOST: TFIBStringField;
    adsSummaryPriceRet: TCurrencyField;
    pStatus: TPanel;
    Bevel1: TBevel;
    dbtCountOrder: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    dbtSumOrder: TDBText;
    lSumOrder: TLabel;
    pWebBrowser: TPanel;
    Bevel2: TBevel;
    WebBrowser1: TWebBrowser;
    btnDelete: TButton;
    pTopSettings: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    bvSettings: TBevel;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    rgSummaryType: TRadioGroup;
    lPosCount: TLabel;
    gbSelectedPrices: TGroupBox;
    clbSelectedPrices: TCheckListBox;
    btnExpand: TButton;
    pmSelectedPrices: TPopupMenu;
    procedure adsSummary2CalcFields(DataSet: TDataSet);
    procedure adsSummary2AfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure dbgSummaryGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgSummaryCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure adsSummary2BeforePost(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure adsSummary2AfterScroll(DataSet: TDataSet);
    procedure dbgSummaryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgSummarySortMarkingChanged(Sender: TObject);
    procedure adsSummaryBeforeEdit(DataSet: TDataSet);
    procedure adsSummaryBeforeDelete(DataSet: TDataSet);
    procedure btnDeleteClick(Sender: TObject);
    procedure dtpDateCloseUp(Sender: TObject);
    procedure rgSummaryTypeClick(Sender: TObject);
    procedure clbSelectedPricesClickCheck(Sender: TObject);
    procedure btnExpandClick(Sender: TObject);
  private
    OldOrder, OrderCount: Integer;
    OrderSum: Double;
    procedure SummaryShow;
    procedure SummaryHShow;
    procedure DeleteOrder;
    procedure SetDateInterval;
  public
    procedure Print( APreview: boolean = False); override;
    procedure ShowForm; reintroduce;
    procedure SetOrderLabel;
  end;

var
  SummaryForm: TSummaryForm;

procedure ShowSummary;

implementation

uses DModule, Main, AProc, Constant;

var
  LastDateFrom,
  LastDateTo : TDateTime;
  // 0 - из текущих, 1 - из отправленных
  LastSymmaryType : Integer;

{$R *.dfm}

procedure ShowSummary;
begin
	SummaryForm := TSummaryForm( MainForm.ShowChildForm( TSummaryForm));
end;

procedure TSummaryForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
  I : Integer;
  sp : TSelectPrice;
  mi :TMenuItem;
begin
	inherited;
	PrintEnabled := True;
  dtpDateFrom.DateTime := LastDateFrom;
  dtpDateTo.DateTime := LastDateTo;
	adsSummary.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	adsSummary.ParamByName( 'ADATEFROM').Value := LastDateFrom;
	adsSummary.ParamByName( 'ADATETO').Value := LastDateTo;
	adsSummaryH.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  rgSummaryType.ItemIndex := LastSymmaryType;
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, False) then dbgSummary.LoadFromRegistry( Reg);
	Reg.Free;
  clbSelectedPrices.Clear;
  pmSelectedPrices.Items.Clear;
  for I := 0 to SelectedPrices.Count-1 do begin
    sp := TSelectPrice(SelectedPrices.Objects[i]);
    mi := TMenuItem.Create(pmSelectedPrices);
    mi.Name := 'sl' + IntToStr(sp.PriceCode);
    mi.Caption := sp.PriceName;
    mi.Checked := sp.Selected;
    mi.Tag := Integer(sp);
    pmSelectedPrices.Items.Add(mi);
    clbSelectedPrices.Items.AddObject(sp.PriceName, sp);
    clbSelectedPrices.Checked[i] := sp.Selected;
  end;
	ShowForm;
end;

procedure TSummaryForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, True);
	dbgSummary.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TSummaryForm.ShowForm;
begin
	SummaryShow;
	SummaryHShow;
	inherited;
end;

procedure TSummaryForm.SummaryShow;
var
	V: array[0..0] of Variant;
begin
	Screen.Cursor := crHourglass;
	try
    if adsSummary.Active then
      adsSummary.Close;
    if LastSymmaryType = 0 then begin
      adsSummary.SelectSQL.Text := 'SELECT * FROM SUMMARYSHOW(:ACLIENTID, :ADATEFROM, :ADATETO) ' +
        ' where PriceCode in (' + GetSelectedPricesSQL + ')';
      dbgSummary.InputField := 'OrderCount';
      btnDelete.Enabled := True;
    end
    else begin
      adsSummary.SelectSQL.Text := 'SELECT * FROM SUMMARYSHOWSEND(:ACLIENTID, :ADATEFROM, :ADATETO) ' +
        ' where PriceCode in (' + GetSelectedPricesSQL + ')';
      dbgSummary.InputField := '';
      btnDelete.Enabled := False;
    end;
    adsSummary.Open;
    DataSetCalc( adsSummary,['SUM(SUMORDER)'], V);
    OrderCount := adsSummary.RecordCount;
    OrderSum := V[0];
    SetOrderLabel;
//		with adsSummary do if Active then CloseOpen(False) else Open;
	finally
		Screen.Cursor := crDefault;
	end;
end;

procedure TSummaryForm.SummaryHShow;
begin
	Screen.Cursor := crHourglass;
	try
		with adsSummaryH do if Active then CloseOpen(True) else Open;
	finally
		Screen.Cursor := crDefault;
	end;
end;

procedure TSummaryForm.adsSummary2CalcFields(DataSet: TDataSet);
var
  S : String;
  C : Currency;
begin
	//вычисл€ем сумму по позиции
  try
    adsSummaryCryptSYNONYMNAME.AsString := DM.D_S(adsSummarySYNONYMNAME.AsString);
    adsSummaryCryptSYNONYMFIRM.AsString := DM.D_S(adsSummarySYNONYMFIRM.AsString);
    S := DM.D_B(adsSummaryCODE.AsString, adsSummaryCODECR.AsString);
    C := StrToCurr(S);
    adsSummaryCryptBASECOST.AsCurrency := C;
    adsSummaryPriceRet.AsCurrency := DM.GetPriceRet(C);
    adsSummarySumOrder.AsCurrency := C * adsSummaryORDERCOUNT.AsInteger;
  except
  end;
end;

procedure TSummaryForm.adsSummary2AfterPost(DataSet: TDataSet);
begin
	OrderCount := OrderCount + Iif( adsSummaryORDERCOUNT.AsInteger = 0, 0, 1) - Iif( OldOrder = 0, 0, 1);
	OrderSum := OrderSum + ( adsSummaryORDERCOUNT.AsInteger - OldOrder) * adsSummaryCryptBASECOST.AsCurrency;
  DM.SetNewOrderCount(adsSummaryORDERCOUNT.AsInteger, adsSummaryCryptBASECOST.AsCurrency);
  SetOrderLabel;
	SummaryHShow;
	if adsSummaryORDERCOUNT.AsInteger = 0 then SummaryShow;
	MainForm.SetOrdersInfo;
end;

procedure TSummaryForm.Print( APreview: boolean = False);
begin
	DM.ShowFastReport( 'Summary.frf', adsSummary, APreview);
end;

procedure TSummaryForm.dbgSummaryGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if adsSummaryJunk.AsBoolean and (( Column.Field = adsSummaryPERIOD)or
		( Column.Field = adsSummaryCryptBASECOST)) then Background := JUNK_CLR;
	//ожидаемый товар выдел€ем зеленым
	if adsSummaryAwait.AsBoolean and ( Column.Field = adsSummaryCryptSYNONYMNAME) then
		Background := AWAIT_CLR;
end;

procedure TSummaryForm.dbgSummaryCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
	inherited;
//
end;

procedure TSummaryForm.adsSummary2BeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
begin
	try
		{ провер€ем заказ на соответствие наличию товара на складе }
		Val( adsSummaryQuantity.AsString, Quantity, E);
		if E<>0 then Quantity := 0;
		if ( Quantity > 0) and ( adsSummaryORDERCOUNT.AsInteger > Quantity) and
			( MessageBox( '«аказ превышает остаток на складе. ѕродолжить?',
			MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) then adsSummaryORDERCOUNT.AsInteger := Quantity;
	except
		adsSummary.Cancel;
		raise;
	end;
	inherited;
end;

procedure TSummaryForm.FormResize(Sender: TObject);
begin
  adsSummary2AfterScroll(adsSummary);
end;

procedure TSummaryForm.adsSummary2AfterScroll(DataSet: TDataSet);
//var
//  C : Integer;
begin
{
  C := dbgSummary.Canvas.TextHeight('Wg') + 2;
  if (adsSummary.RecordCount > 0) and ((adsSummary.RecordCount*C)/(pClient.Height-pWebBrowser.Height) > 13/10) then
    pWebBrowser.Visible := False
  else
    pWebBrowser.Visible := True;
}
end;

procedure TSummaryForm.dbgSummaryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_DELETE) and (not adsSummary.IsEmpty) then begin
    Key := 0;
    DeleteOrder;
  end
  else
    inherited;
end;

procedure TSummaryForm.dbgSummarySortMarkingChanged(Sender: TObject);
begin
{
  adsSummary.DisableControls;
	Screen.Cursor := crHourglass;
	adsSummary.Close;
	adsSummary.SelectSQL.Text := SummarySql + SQLOrderBy;
	adsSummary.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	adsSummaryH.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	try
		adsSummary.Open;
	finally
		Screen.Cursor := crDefault;
		adsSummary.EnableControls;
	end;
}
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TSummaryForm.adsSummaryBeforeEdit(DataSet: TDataSet);
begin
  OldOrder:=adsSummaryORDERCOUNT.AsInteger;
  DM.SetOldOrderCount(adsSummaryORDERCOUNT.AsInteger);
end;

procedure TSummaryForm.adsSummaryBeforeDelete(DataSet: TDataSet);
begin
  DM.SetOldOrderCount(adsSummaryORDERCOUNT.AsInteger);
  DM.SetNewOrderCount(0, adsSummaryCryptBASECOST.AsCurrency);
end;

procedure TSummaryForm.SetOrderLabel;
begin
  lSumOrder.Caption := Format('%0.2f', [OrderSum]);
  lPosCount.Caption := IntToStr(OrderCount);
end;

procedure TSummaryForm.DeleteOrder;
begin
  if MessageBox('”далить позицию?', MB_ICONQUESTION or MB_YESNO) = IDYES then begin
    OrderCount := OrderCount + Iif( 0 = 0, 0, 1) - Iif( adsSummaryORDERCOUNT.AsInteger = 0, 0, 1);
    OrderSum := OrderSum + ( 0 - adsSummaryORDERCOUNT.AsInteger) * adsSummaryCryptBASECOST.AsCurrency;
    SetOrderLabel;
    DM.SetOldOrderCount(adsSummaryORDERCOUNT.AsInteger);
    DM.SetNewOrderCount(0, adsSummaryCryptBASECOST.AsCurrency);
    DM.adcUpdate.Transaction.StartTransaction;
    try
      DM.adcUpdate.SQL.Text :=
        'delete from Orders where OrderID = ' +
          IntToStr(adsSummary.FieldByName('OrdersOrderID').AsInteger) +
          ' and CoreID = ' + IntToStr(adsSummary.FieldByName('OrdersCoreID').AsInteger);
      DM.adcUpdate.ExecQuery;
      DM.adcUpdate.Transaction.Commit;
    except
      DM.adcUpdate.Transaction.Rollback;
      raise;
    end;
    adsSummary.CloseOpen(True);
    MainForm.SetOrdersInfo;
  end;
end;

procedure TSummaryForm.btnDeleteClick(Sender: TObject);
begin
  dbgSummary.SetFocus;
  if (not adsSummary.IsEmpty) then
    DeleteOrder;
end;

procedure TSummaryForm.dtpDateCloseUp(Sender: TObject);
begin
  SetDateInterval;
  dbgSummary.SetFocus;
end;

procedure TSummaryForm.SetDateInterval;
begin
  LastDateFrom := dtpDateFrom.Date;
  LastDateTo := dtpDateTo.Date;
	adsSummary.ParamByName( 'ADATEFROM').Value := LastDateFrom;
	adsSummary.ParamByName( 'ADATETO').Value := LastDateTo;
  SummaryShow;
end;

procedure TSummaryForm.rgSummaryTypeClick(Sender: TObject);
begin
  if rgSummaryType.ItemIndex <> LastSymmaryType then begin
    LastSymmaryType := rgSummaryType.ItemIndex;
    SummaryShow;
    dbgSummary.SetFocus;
  end;
end;

procedure TSummaryForm.clbSelectedPricesClickCheck(Sender: TObject);
var
  sp : TSelectPrice;
begin
  if clbSelectedPrices.ItemIndex > -1 then begin
    sp := TSelectPrice(clbSelectedPrices.Items.Objects[clbSelectedPrices.ItemIndex]);
    sp.Selected := clbSelectedPrices.Checked[clbSelectedPrices.ItemIndex];
    SummaryShow;
    dbgSummary.SetFocus;
  end;
end;

procedure TSummaryForm.btnExpandClick(Sender: TObject);
begin
  if btnExpand.Caption = '>>' then begin
    btnExpand.Caption := '<<';
    gbSelectedPrices.Height := 250;
    gbSelectedPrices.BringToFront;
    clbSelectedPrices.SetFocus;
  end
  else begin
    btnExpand.Caption := '>>';
    gbSelectedPrices.Height := 48;
    dbgSummary.SetFocus;
  end;
end;

initialization
  LastDateFrom := Date;
  LastDateTo := Date + 1;
  LastSymmaryType := 0;
end.
