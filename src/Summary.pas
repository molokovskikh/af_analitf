unit Summary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, DB,
  DBCtrls, StdCtrls, Placemnt, FR_DSet, FR_DBSet, Buttons, DBGridEh,
  ToughDBGrid, ExtCtrls, Registry, OleCtrls, SHDocVw, FIBDataSet,
  pFIBDataSet, DBProc, ComCtrls, CheckLst, Menus, GridsEh, DateUtils,
  ActnList;

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
    adsSummarySumOrder: TCurrencyField;
    adsSummaryH: TpFIBDataSet;
    adsSummaryCryptBASECOST: TCurrencyField;
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
    bvSettings: TBevel;
    rgSummaryType: TRadioGroup;
    lPosCount: TLabel;
    pmSelectedPrices: TPopupMenu;
    miSelectedAll: TMenuItem;
    btnSelectPrices: TBitBtn;
    miUnselectedAll: TMenuItem;
    miSeparator: TMenuItem;
    adsCurrentSummary: TpFIBDataSet;
    adsSendSummary: TpFIBDataSet;
    adsSummaryVOLUME: TFIBStringField;
    adsSummaryQUANTITY: TFIBStringField;
    adsSummaryNOTE: TFIBStringField;
    adsSummaryPERIOD: TFIBStringField;
    adsSummaryJUNK: TFIBBooleanField;
    adsSummaryAWAIT: TFIBBooleanField;
    adsSummaryCODE: TFIBStringField;
    adsSummaryCODECR: TFIBStringField;
    adsSummarySYNONYMNAME: TFIBStringField;
    adsSummarySYNONYMFIRM: TFIBStringField;
    adsSummaryBASECOST: TFIBStringField;
    adsSummaryPRICENAME: TFIBStringField;
    adsSummaryREGIONNAME: TFIBStringField;
    adsSummaryORDERCOUNT: TFIBIntegerField;
    adsSummaryORDERSCOREID: TFIBBCDField;
    adsSummaryORDERSORDERID: TFIBBCDField;
    adsSummaryPRICECODE: TFIBBCDField;
    adsSummaryREGIONCODE: TFIBBCDField;
    adsSummaryDOC: TFIBStringField;
    adsSummaryREGISTRYCOST: TFIBFloatField;
    adsSummaryVITALLYIMPORTANT: TFIBBooleanField;
    adsSummaryREQUESTRATIO: TFIBIntegerField;
    adsSendSummaryVOLUME: TFIBStringField;
    adsSendSummaryQUANTITY: TFIBStringField;
    adsSendSummaryNOTE: TFIBStringField;
    adsSendSummaryPERIOD: TFIBStringField;
    adsSendSummaryJUNK: TFIBBooleanField;
    adsSendSummaryAWAIT: TFIBBooleanField;
    adsSendSummaryCODE: TFIBStringField;
    adsSendSummaryCODECR: TFIBStringField;
    adsSendSummarySYNONYMNAME: TFIBStringField;
    adsSendSummarySYNONYMFIRM: TFIBStringField;
    adsSendSummaryBASECOST: TFIBStringField;
    adsSendSummaryPRICENAME: TFIBStringField;
    adsSendSummaryREGIONNAME: TFIBStringField;
    adsSendSummaryORDERCOUNT: TFIBIntegerField;
    adsSendSummaryORDERSCOREID: TFIBBCDField;
    adsSendSummaryORDERSORDERID: TFIBBCDField;
    adsSendSummaryPRICECODE: TFIBBCDField;
    adsSendSummaryREGIONCODE: TFIBBCDField;
    adsSendSummaryDOC: TFIBStringField;
    adsSendSummaryVITALLYIMPORTANT: TFIBIntegerField;
    adsSendSummaryREQUESTRATIO: TFIBIntegerField;
    adsSendSummaryREGISTRYCOST: TFIBFloatField;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    adsSummarySENDPRICE: TFIBBCDField;
    adsSummaryORDERCOST: TFIBBCDField;
    adsSummaryMINORDERCOUNT: TFIBIntegerField;
    adsSummaryCOREID: TFIBBCDField;
    ActionList: TActionList;
    actFlipCore: TAction;
    adsSummaryFULLCODE: TFIBBCDField;
    adsSummarySHORTCODE: TFIBBCDField;
    plOverCost: TPanel;
    lWarning: TLabel;
    Timer: TTimer;
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
    procedure btnSelectPricesClick(Sender: TObject);
    procedure miSelectedAllClick(Sender: TObject);
    procedure miUnselectedAllClick(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    OldOrder, OrderCount: Integer;
    OrderSum: Double;
    SelectedPrices : TStringList;
    procedure SummaryShow;
    procedure SummaryHShow;
    procedure DeleteOrder;
    procedure SetDateInterval;
    procedure OnSPClick(Sender: TObject);
    procedure ChangeSelected(ASelected : Boolean);
    procedure scf(DataSet: TDataSet);
  public
    procedure Print( APreview: boolean = False); override;
    procedure ShowForm; override;
    procedure SetOrderLabel;
  end;

var
  SummaryForm: TSummaryForm;

procedure ShowSummary;

implementation

uses DModule, Main, AProc, Constant, NamesForms;

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
	Reg: TRegIniFile;
  I : Integer;
  sp : TSelectPrice;
  mi :TMenuItem;
begin
  dsCheckVolume := adsSummary;
  dgCheckVolume := dbgSummary;
  fOrder := adsSummaryORDERCOUNT;
  fVolume := adsSummaryREQUESTRATIO;
  fOrderCost := adsSummaryORDERCOST;
  fSumOrder := adsSummarySumOrder;
  fMinOrderCount := adsSummaryMINORDERCOUNT;
  inherited;
	PrintEnabled := False;
  adsSummary.OnCalcFields := scf;
  dtpDateFrom.DateTime := LastDateFrom;
  dtpDateTo.DateTime := LastDateTo;
	adsSummary.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	adsSummaryH.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  rgSummaryType.ItemIndex := LastSymmaryType;
  PrintEnabled := LastSymmaryType = 1;
  dtpDateFrom.Enabled := LastSymmaryType = 1;
  dtpDateTo.Enabled := dtpDateFrom.Enabled;
	Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, False)
    then
      dbgSummary.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
  finally
  	Reg.Free;
  end;
  SelectedPrices := SummarySelectedPrices;
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

procedure TSummaryForm.FormDestroy(Sender: TObject);
var
	Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey('Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, True);
    dbgSummary.SaveColumnsLayout(Reg);
  finally
    Reg.Free;
  end;
end;

procedure TSummaryForm.ShowForm;
begin
  plOverCost.Hide();
	SummaryShow;
	SummaryHShow;
	inherited;
end;

procedure TSummaryForm.SummaryShow;
var
	V: array[0..0] of Variant;
  FilterSQL : String;
begin
	Screen.Cursor := crHourglass;
	try
    if adsSummary.Active then
      adsSummary.Close;
    FilterSQL := GetSelectedPricesSQL(SelectedPrices, 'OrdersH.');
    if LastSymmaryType = 0 then begin
      adsSummary.SelectSQL.Text := adsCurrentSummary.SelectSQL.Text;
      dbgSummary.InputField := 'OrderCount';
      dbgSummary.Tag := 256;
      btnDelete.Enabled := True;
    end
    else begin
      adsSummary.SelectSQL.Text := adsSendSummary.SelectSQL.Text;
      adsSummary.ParamByName( 'DATEFROM').Value := LastDateFrom;
      adsSummary.ParamByName( 'DATETO').Value := IncDay(LastDateTo);
      dbgSummary.InputField := '';
      dbgSummary.Tag := 512;
      btnDelete.Enabled := False;
    end;
    if Length(FilterSQL) > 0 then
      adsSummary.SelectSQL.Text := adsSummary.SelectSQL.Text + ' and ( ' + FilterSQL + ' )';
    adsSummary.Open;
    DataSetCalc( adsSummary,['SUM(SUMORDER)'], V);
    OrderCount := adsSummary.RecordCount;
    OrderSum := V[0];
    SetOrderLabel;
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

procedure TSummaryForm.scf(DataSet: TDataSet);
var
  S : String;
  C : Currency;
begin
	//вычисляем сумму по позиции
  try
    if adsSummarySENDPRICE.IsNull then begin
      S := DM.D_B_N(adsSummaryBASECOST.AsString);
      C := StrToCurr(S);
      adsSummaryCryptBASECOST.AsCurrency := C;
    end
    else begin
      C := adsSummarySENDPRICE.AsCurrency;
      adsSummaryCryptBASECOST.AsCurrency := C;
    end;
    adsSummaryPriceRet.AsCurrency := DM.GetPriceRet(C);
    adsSummarySumOrder.AsCurrency := C * adsSummaryORDERCOUNT.AsInteger;
  except
  end;
end;

procedure TSummaryForm.adsSummary2AfterPost(DataSet: TDataSet);
begin
	OrderCount := OrderCount + Iif( adsSummaryORDERCOUNT.AsInteger = 0, 0, 1) - Iif( OldOrder = 0, 0, 1);
	OrderSum := OrderSum + ( adsSummaryORDERCOUNT.AsInteger - OldOrder) * adsSummaryCryptBASECOST.AsCurrency;
  DM.SetNewOrderCount(adsSummaryORDERCOUNT.AsInteger, adsSummaryCryptBASECOST.AsCurrency, adsSummaryPRICECODE.AsInteger, adsSummaryREGIONCODE.AsInteger);
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
  if adsSummaryVITALLYIMPORTANT.AsBoolean then
    AFont.Color := VITALLYIMPORTANT_CLR;

	if adsSummaryJunk.AsBoolean and (( Column.Field = adsSummaryPERIOD)or
		( Column.Field = adsSummaryCryptBASECOST)) then Background := JUNK_CLR;
	//ожидаемый товар выделяем зеленым
	if adsSummaryAwait.AsBoolean and ( Column.Field = adsSummarySYNONYMNAME) then
		Background := AWAIT_CLR;
end;

procedure TSummaryForm.dbgSummaryCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
	inherited;
  CanInput := LastSymmaryType = 0;
end;

procedure TSummaryForm.adsSummary2BeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
  PanelCaption : String;
  PanelHeight : Integer;
begin
	try
		{ проверяем заказ на соответствие наличию товара на складе }
		Val( adsSummaryQuantity.AsString, Quantity, E);
		if E<>0 then Quantity := 0;
		if ( Quantity > 0) and ( adsSummaryORDERCOUNT.AsInteger > Quantity) and
			( AProc.MessageBox( 'Заказ превышает остаток на складе. Продолжить?',
			MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) then adsSummaryORDERCOUNT.AsInteger := Quantity;
      
    PanelCaption := '';
    
    if (adsSummaryORDERCOUNT.AsInteger > WarningOrderCount) then
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

      plOverCost.Top := ( dbgSummary.Height - plOverCost.Height) div 2;
      plOverCost.Left := ( dbgSummary.Width - plOverCost.Width) div 2;
      plOverCost.BringToFront;
      plOverCost.Show;
      Timer.Enabled := True;
    end;
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
  DM.SetNewOrderCount(0, adsSummaryCryptBASECOST.AsCurrency, adsSummaryPRICECODE.AsInteger, adsSummaryREGIONCODE.AsInteger);
end;

procedure TSummaryForm.SetOrderLabel;
begin
  lSumOrder.Caption := Format('%0.2f', [OrderSum]);
  lPosCount.Caption := IntToStr(OrderCount);
end;

procedure TSummaryForm.DeleteOrder;
begin
  if LastSymmaryType = 0 then
    if AProc.MessageBox('Удалить позицию?', MB_ICONQUESTION or MB_YESNO) = IDYES then begin
      OrderCount := OrderCount + Iif( 0 = 0, 0, 1) - Iif( adsSummaryORDERCOUNT.AsInteger = 0, 0, 1);
      OrderSum := OrderSum + ( 0 - adsSummaryORDERCOUNT.AsInteger) * adsSummaryCryptBASECOST.AsCurrency;
      SetOrderLabel;
      DM.SetOldOrderCount(adsSummaryORDERCOUNT.AsInteger);
      DM.SetNewOrderCount(0, adsSummaryCryptBASECOST.AsCurrency, adsSummaryPRICECODE.AsInteger, adsSummaryREGIONCODE.AsInteger);
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
  SummaryShow;
end;

procedure TSummaryForm.rgSummaryTypeClick(Sender: TObject);
begin
  if rgSummaryType.ItemIndex <> LastSymmaryType then begin
    LastSymmaryType := rgSummaryType.ItemIndex;
    PrintEnabled := LastSymmaryType = 1;
    dtpDateFrom.Enabled := LastSymmaryType = 1;
    dtpDateTo.Enabled := dtpDateFrom.Enabled;
    SummaryShow;
    dbgSummary.SetFocus;
  end;
end;

procedure TSummaryForm.OnSPClick(Sender: TObject);
var
  sp : TSelectPrice;
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  sp := TSelectPrice(TMenuItem(Sender).Tag);
  sp.Selected := TMenuItem(Sender).Checked;
  SummaryShow;
  pmSelectedPrices.Popup(pmSelectedPrices.PopupPoint.X, pmSelectedPrices.PopupPoint.Y);
end;

procedure TSummaryForm.btnSelectPricesClick(Sender: TObject);
begin
  pmSelectedPrices.Popup(btnSelectPrices.ClientOrigin.X, btnSelectPrices.ClientOrigin.Y + btnSelectPrices.Height);
end;

procedure TSummaryForm.miSelectedAllClick(Sender: TObject);
begin
  ChangeSelected(True);
end;

procedure TSummaryForm.ChangeSelected(ASelected: Boolean);
var
  I : Integer;
begin
  for I := 3 to pmSelectedPrices.Items.Count-1 do begin
    pmSelectedPrices.Items.Items[i].Checked := ASelected;
    TSelectPrice(TMenuItem(pmSelectedPrices.Items.Items[i]).Tag).Selected := ASelected;
  end;
  SummaryShow;
  pmSelectedPrices.Popup(pmSelectedPrices.PopupPoint.X, pmSelectedPrices.PopupPoint.Y);
end;

procedure TSummaryForm.miUnselectedAllClick(Sender: TObject);
begin
  ChangeSelected(False);
end;

procedure TSummaryForm.actFlipCoreExecute(Sender: TObject);
var
	FullCode, ShortCode: integer;
  CoreId : Int64;
begin
	if MainForm.ActiveChild <> Self then exit;
  if adsSummary.IsEmpty then Exit;
  if LastSymmaryType <> 0 then Exit;

	FullCode := adsSummaryFullCode.AsInteger;
	ShortCode := adsSummaryShortCode.AsInteger;

  CoreId := adsSummaryCOREID.AsInt64;

  FlipToCode(FullCode, ShortCode, CoreId);
end;

procedure TSummaryForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

initialization
  LastDateFrom := Date;
  LastDateTo := Date;
  LastSymmaryType := 0;
end.
