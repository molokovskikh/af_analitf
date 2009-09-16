unit Summary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, DB,
  DBCtrls, StdCtrls, Placemnt, FR_DSet, FR_DBSet, Buttons, DBGridEh,
  ToughDBGrid, ExtCtrls, Registry, OleCtrls, SHDocVw, FIBDataSet,
  pFIBDataSet, DBProc, ComCtrls, CheckLst, Menus, GridsEh, DateUtils,
  ActnList, U_frameLegend, MemDS, DBAccess, MyAccess;

const
	SummarySql	= 'SELECT * FROM SUMMARYSHOW(:ACLIENTID)  ORDER BY ';

type
  TSummaryForm = class(TChildForm)
    dsSummary: TDataSource;
    frdsSummary: TfrDBDataSet;
    pClient: TPanel;
    dbgSummary: TToughDBGrid;
    adsSummaryOld: TpFIBDataSet;
    adsSummaryOldSumOrder: TCurrencyField;
    adsSummaryOldCryptBASECOST: TCurrencyField;
    adsSummaryOldPriceRet: TCurrencyField;
    pStatus: TPanel;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
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
    adsCurrentSummaryOld: TpFIBDataSet;
    adsSendSummaryOld: TpFIBDataSet;
    adsSummaryOldVOLUME: TFIBStringField;
    adsSummaryOldQUANTITY: TFIBStringField;
    adsSummaryOldNOTE: TFIBStringField;
    adsSummaryOldPERIOD: TFIBStringField;
    adsSummaryOldJUNK: TFIBBooleanField;
    adsSummaryOldAWAIT: TFIBBooleanField;
    adsSummaryOldCODE: TFIBStringField;
    adsSummaryOldCODECR: TFIBStringField;
    adsSummaryOldSYNONYMNAME: TFIBStringField;
    adsSummaryOldSYNONYMFIRM: TFIBStringField;
    adsSummaryOldBASECOST: TFIBStringField;
    adsSummaryOldPRICENAME: TFIBStringField;
    adsSummaryOldREGIONNAME: TFIBStringField;
    adsSummaryOldORDERCOUNT: TFIBIntegerField;
    adsSummaryOldORDERSCOREID: TFIBBCDField;
    adsSummaryOldORDERSORDERID: TFIBBCDField;
    adsSummaryOldPRICECODE: TFIBBCDField;
    adsSummaryOldREGIONCODE: TFIBBCDField;
    adsSummaryOldDOC: TFIBStringField;
    adsSummaryOldREGISTRYCOST: TFIBFloatField;
    adsSummaryOldVITALLYIMPORTANT: TFIBBooleanField;
    adsSummaryOldREQUESTRATIO: TFIBIntegerField;
    adsSendSummaryOldVOLUME: TFIBStringField;
    adsSendSummaryOldQUANTITY: TFIBStringField;
    adsSendSummaryOldNOTE: TFIBStringField;
    adsSendSummaryOldPERIOD: TFIBStringField;
    adsSendSummaryOldJUNK: TFIBBooleanField;
    adsSendSummaryOldAWAIT: TFIBBooleanField;
    adsSendSummaryOldCODE: TFIBStringField;
    adsSendSummaryOldCODECR: TFIBStringField;
    adsSendSummaryOldSYNONYMNAME: TFIBStringField;
    adsSendSummaryOldSYNONYMFIRM: TFIBStringField;
    adsSendSummaryOldBASECOST: TFIBStringField;
    adsSendSummaryOldPRICENAME: TFIBStringField;
    adsSendSummaryOldREGIONNAME: TFIBStringField;
    adsSendSummaryOldORDERCOUNT: TFIBIntegerField;
    adsSendSummaryOldORDERSCOREID: TFIBBCDField;
    adsSendSummaryOldORDERSORDERID: TFIBBCDField;
    adsSendSummaryOldPRICECODE: TFIBBCDField;
    adsSendSummaryOldREGIONCODE: TFIBBCDField;
    adsSendSummaryOldDOC: TFIBStringField;
    adsSendSummaryOldVITALLYIMPORTANT: TFIBIntegerField;
    adsSendSummaryOldREQUESTRATIO: TFIBIntegerField;
    adsSendSummaryOldREGISTRYCOST: TFIBFloatField;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    adsSummaryOldSENDPRICE: TFIBBCDField;
    adsSummaryOldORDERCOST: TFIBBCDField;
    adsSummaryOldMINORDERCOUNT: TFIBIntegerField;
    adsSummaryOldCOREID: TFIBBCDField;
    ActionList: TActionList;
    actFlipCore: TAction;
    adsSummaryOldFULLCODE: TFIBBCDField;
    adsSummaryOldSHORTCODE: TFIBBCDField;
    plOverCost: TPanel;
    lWarning: TLabel;
    Timer: TTimer;
    frameLegeng: TframeLegeng;
    adsCurrentSummary: TMyQuery;
    adsSendSummary: TMyQuery;
    adsSummary: TMyQuery;
    adsSummaryfullcode: TLargeintField;
    adsSummaryshortcode: TLargeintField;
    adsSummaryCoreID: TLargeintField;
    adsSummaryVolume: TStringField;
    adsSummaryQuantity: TStringField;
    adsSummaryNote: TStringField;
    adsSummaryPeriod: TStringField;
    adsSummaryJunk: TBooleanField;
    adsSummaryAwait: TBooleanField;
    adsSummaryCODE: TStringField;
    adsSummaryCODECR: TStringField;
    adsSummarydoc: TStringField;
    adsSummaryregistrycost: TFloatField;
    adsSummaryordercost: TFloatField;
    adsSummaryCost: TFloatField;
    adsSummarySynonymName: TStringField;
    adsSummarySynonymFirm: TStringField;
    adsSummaryPriceName: TStringField;
    adsSummaryRegionName: TStringField;
    adsSummaryOrderCount: TIntegerField;
    adsSummaryOrdersCoreId: TLargeintField;
    adsSummaryOrdersOrderId: TLargeintField;
    adsSummarypricecode: TLargeintField;
    adsSummaryregioncode: TLargeintField;
    adsSummaryPriceRet: TCurrencyField;
    adsSummaryRequestRatio: TIntegerField;
    adsSummaryMINORDERCOUNT: TIntegerField;
    adsSummaryVitallyImportant: TBooleanField;
    btnGotoCore: TButton;
    adsSummarySumOrder: TCurrencyField;
    adsSummaryOrdersHOrderId: TLargeintField;
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
    procedure btnDeleteClick(Sender: TObject);
    procedure dtpDateCloseUp(Sender: TObject);
    procedure rgSummaryTypeClick(Sender: TObject);
    procedure btnSelectPricesClick(Sender: TObject);
    procedure miSelectedAllClick(Sender: TObject);
    procedure miUnselectedAllClick(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure adsSummaryBeforeInsert(DataSet: TDataSet);
  private
    OrderCount: Integer;
    OrderSum: Double;
    SelectedPrices : TStringList;
    procedure SummaryShow;
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

uses DModule, Main, AProc, Constant, NamesForms, Fr_Class;

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
  rgSummaryType.ItemIndex := LastSymmaryType;
  PrintEnabled := ((LastSymmaryType = 0) and ((DM.SaveGridMask and PrintCurrentSummaryOrder) > 0))
               or ((LastSymmaryType = 1) and ((DM.SaveGridMask and PrintSendedSummaryOrder) > 0));
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
	inherited;
end;

procedure TSummaryForm.SummaryShow;
var
  FilterSQL : String;
begin
	Screen.Cursor := crHourglass;
	try
    if adsSummary.Active then
      adsSummary.Close;
    FilterSQL := GetSelectedPricesSQL(SelectedPrices, 'OrdersHead.');
    if LastSymmaryType = 0 then begin
      adsSummary.SQL.Text := adsCurrentSummary.SQL.Text;
      dbgSummary.InputField := 'OrderCount';
      dbgSummary.Tag := 256;
      btnDelete.Enabled := True;
    end
    else begin
      adsSummary.SQL.Text := adsSendSummary.SQL.Text;
      adsSummary.ParamByName( 'DATEFROM').Value := LastDateFrom;
      adsSummary.ParamByName( 'DATETO').Value := IncDay(LastDateTo);
      dbgSummary.InputField := '';
      dbgSummary.Tag := 512;
      btnDelete.Enabled := False;
    end;
    if Length(FilterSQL) > 0 then
      adsSummary.SQL.Text := adsSummary.SQL.Text + ' and ( ' + FilterSQL + ' )';
    adsSummary.Open;
    SetOrderLabel;
	finally
		Screen.Cursor := crDefault;
	end;
end;

procedure TSummaryForm.scf(DataSet: TDataSet);
begin
	//вычисляем сумму по позиции
  try
    adsSummaryPriceRet.AsCurrency := DM.GetPriceRet(adsSummaryCOST.AsCurrency);
    adsSummarySumOrder.AsCurrency := adsSummaryCost.AsCurrency * adsSummaryOrderCount.AsInteger;
  except
  end;
end;

procedure TSummaryForm.adsSummary2AfterPost(DataSet: TDataSet);
begin
  SetOrderLabel;
	if adsSummaryORDERCOUNT.AsInteger = 0 then SummaryShow;
	MainForm.SetOrdersInfo;
end;

procedure TSummaryForm.Print( APreview: boolean = False);
var
  LastCurrentSQL : String;
begin
  //Если распечатываем текущий сводный заказ, то сбрасываем фильтр по поставщикам
  frVariables[ 'SymmaryType'] := LastSymmaryType;
  frVariables[ 'SymmaryDateFrom'] := DateToStr(LastDateFrom);
  frVariables[ 'SymmaryDateTo'] := DateToStr(LastDateTo);

  if LastSymmaryType = 0 then begin
    adsSummary.DisableControls;
    try
      LastCurrentSQL := adsSummary.SQL.Text;
      if adsSummary.Active then
        adsSummary.Close;
      adsSummary.SQL.Text := adsCurrentSummary.SQL.Text;
      adsSummary.Open;
      adsSummary.IndexFieldNames := 'SynonymName';
      DM.ShowFastReport( 'Summary.frf', adsSummary, APreview);
      adsSummary.Close;
      adsSummary.SQL.Text := LastCurrentSQL;
      adsSummary.Open;
      dbgSummary.OnSortMarkingChanged(dbgSummary);
    finally
      adsSummary.EnableControls;
    end;
  end
  else
	  DM.ShowFastReport( 'Summary.frf', adsSummary, APreview);
end;

procedure TSummaryForm.dbgSummaryGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if (adsSummaryVITALLYIMPORTANT.AsBoolean) then
    AFont.Color := VITALLYIMPORTANT_CLR;

	if adsSummaryJunk.AsBoolean and (( Column.Field = adsSummaryPERIOD)or
		( Column.Field = adsSummaryCOST)) then Background := JUNK_CLR;
	//ожидаемый товар выделяем зеленым
	if adsSummaryAwait.AsBoolean and ( Column.Field = adsSummarySYNONYMNAME) then
		Background := AWAIT_CLR;
end;

procedure TSummaryForm.dbgSummaryCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
	inherited;
  CanInput := (LastSymmaryType = 0) and (not adsSummary.IsEmpty);
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
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TSummaryForm.SetOrderLabel;
var
	V: array[0..0] of Variant;
begin
  DataSetCalc( adsSummary,['SUM(SUMORDER)'], V);
  OrderCount := adsSummary.RecordCount;
  OrderSum := V[0];
  lSumOrder.Caption := Format('%0.2f', [OrderSum]);
  lPosCount.Caption := IntToStr(OrderCount);
end;

procedure TSummaryForm.DeleteOrder;
begin
  if LastSymmaryType = 0 then
    if AProc.MessageBox('Удалить позицию?', MB_ICONQUESTION or MB_YESNO) = IDYES then begin
      OrderCount := OrderCount + Iif( 0 = 0, 0, 1) - Iif( adsSummaryORDERCOUNT.AsInteger = 0, 0, 1);
      OrderSum := OrderSum + ( 0 - adsSummaryORDERCOUNT.AsInteger) * adsSummaryCOST.AsCurrency;
      DM.adcUpdate.SQL.Text :=
        'delete from OrdersList where OrderID = ' +
          IntToStr(adsSummary.FieldByName('OrdersOrderID').AsInteger) +
          ' and CoreID = ' + IntToStr(adsSummary.FieldByName('OrdersCoreID').AsInteger);
      DM.adcUpdate.Execute;
      adsSummary.Close;
      adsSummary.Open;
      SetOrderLabel;
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
    PrintEnabled := ((LastSymmaryType = 0) and ((DM.SaveGridMask and PrintCurrentSummaryOrder) > 0))
                 or ((LastSymmaryType = 1) and ((DM.SaveGridMask and PrintSendedSummaryOrder) > 0));
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

  CoreId := adsSummaryCOREID.AsLargeInt;

  FlipToCode(FullCode, ShortCode, CoreId);
end;

procedure TSummaryForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

procedure TSummaryForm.adsSummaryBeforeInsert(DataSet: TDataSet);
begin
  Abort;
end;

initialization
  LastDateFrom := Date;
  LastDateTo := Date;
  LastSymmaryType := 0;
end.
