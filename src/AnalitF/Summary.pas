unit Summary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, DB,
  DBCtrls, StdCtrls, Placemnt, FR_DSet, FR_DBSet, Buttons, DBGridEh,
  ToughDBGrid, ExtCtrls, Registry, OleCtrls, SHDocVw,
  DBProc, ComCtrls, CheckLst, Menus, GridsEh, DateUtils,
  ActnList, U_frameLegend, MemDS, DBAccess, MyAccess, U_frameBaseLegend,
  U_CurrentOrderItem,
  AddressController,
  U_frameFilterAddresses;

type
  TSummaryForm = class(TChildForm)
    dsSummary: TDataSource;
    pClient: TPanel;
    dbgSummaryCurrent: TToughDBGrid;
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
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    ActionList: TActionList;
    actFlipCore: TAction;
    plOverCost: TPanel;
    lWarning: TLabel;
    Timer: TTimer;
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
    btnGotoCore: TSpeedButton;
    adsSummarySumOrder: TCurrencyField;
    adsSummaryOrdersHOrderId: TLargeintField;
    adsSummaryRealCost: TFloatField;
    dbgSummarySend: TToughDBGrid;
    adsSummarySendDate: TDateTimeField;
    cbNeedCorrect: TCheckBox;
    adsSummaryDropReason: TSmallintField;
    adsSummaryServerCost: TFloatField;
    adsSummaryServerQuantity: TIntegerField;
    adsSummarySendResult: TSmallintField;
    gbCorrectMessage: TGroupBox;
    mCorrectMessage: TMemo;
    adsSummarySupplierPriceMarkup: TFloatField;
    adsSummaryProducerCost: TFloatField;
    adsSummaryNDS: TSmallintField;
    adsSummaryMnnId: TLargeintField;
    adsSummaryMnn: TStringField;
    btnGotoMNN: TSpeedButton;
    adsSummaryDescriptionId: TLargeintField;
    adsSummaryCatalogVitallyImportant: TBooleanField;
    adsSummaryCatalogMandatoryList: TBooleanField;
    adsSummaryRetailMarkup: TFloatField;
    adsSummaryMaxProducerCost: TFloatField;
    adsSummaryProducerName: TStringField;
    tmrFillReport: TTimer;
    adsSummaryAddressName: TStringField;
    adsSummaryRetailCost: TFloatField;
    procedure adsSummary2AfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure dbgSummaryCurrentGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgSummaryCurrentCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure adsSummary2BeforePost(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure adsSummary2AfterScroll(DataSet: TDataSet);
    procedure dbgSummaryCurrentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgSummaryCurrentSortMarkingChanged(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure dtpDateCloseUp(Sender: TObject);
    procedure rgSummaryTypeClick(Sender: TObject);
    procedure btnSelectPricesClick(Sender: TObject);
    procedure miSelectedAllClick(Sender: TObject);
    procedure miUnselectedAllClick(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure adsSummaryBeforeInsert(DataSet: TDataSet);
    procedure cbNeedCorrectClick(Sender: TObject);
    procedure tmrFillReportTimer(Sender: TObject);
    procedure dbgSummaryCurrentDblClick(Sender: TObject);
  private
    SelectedPrices : TStringList;
    procedure SummaryShow;
    procedure DeleteOrder;
    procedure SetDateInterval;
    procedure OnSPClick(Sender: TObject);
    procedure ChangeSelected(ASelected : Boolean);
    procedure scf(DataSet: TDataSet);
    procedure FillCorrectMessage;
    procedure OnChangeCheckBoxAllOrders;
    procedure OnChangeFilterAllOrders;
    procedure ChangePriceFontInOrderGrid(Grid : TToughDBGrid);
  protected
    frameFilterAddresses : TframeFilterAddresses;
    procedure UpdateOrderDataset; override;
    procedure FlipToCore;
  public
    frameLegend : TframeLegend;
    procedure Print( APreview: boolean = False); override;
    procedure ShowForm; override;
    procedure SetOrderLabel;
  end;

var
  SummaryForm: TSummaryForm;

procedure ShowSummary;

implementation

uses DModule, Main, AProc, Constant, NamesForms, Fr_Class,
      PostSomeOrdersController, U_framePosition, DBGridHelper,
  UniqueID;

var
  LastDateFrom,
  LastDateTo : TDateTime;
  // 0 - из текущих, 1 - из отправленных
  LastSymmaryType : Integer;

{$R *.dfm}

procedure ShowSummary;
begin
  SummaryForm := TSummaryForm( MainForm.ShowChildForm( TSummaryForm ) );
end;

procedure TSummaryForm.FormCreate(Sender: TObject);
var
  Reg: TRegIniFile;
  I : Integer;
  sp : TSelectPrice;
  mi :TMenuItem;
  frameLeft : Integer;
begin
  {
    ѕроблема с отображением кнопки TSpeedButton при глубине вложенности на Panel большей 1.
    т.е. если form -> panel -> TSpeedButton : все хорошо
    а если form -> panel -> panel -> TSpeedButton : Caption у панели отображаетс€ жирным шрифтом
    –ешение найдено здесь:
    http://qc.embarcadero.com/wc/qcmain.aspx?d=49109
    Speedbuttons don't paint correctly when parented by a TGridPanel on a TGroupBox
  }
  pStatus.ControlStyle := pStatus.ControlStyle - [csParentBackground] + [csOpaque];
  dsCheckVolume := adsSummary;
  dgCheckVolume := dbgSummaryCurrent;
  fOrder := adsSummaryORDERCOUNT;
  fVolume := adsSummaryREQUESTRATIO;
  fOrderCost := adsSummaryORDERCOST;
  fSumOrder := adsSummarySumOrder;
  fMinOrderCount := adsSummaryMINORDERCOUNT;
  gotoMNNButton := btnGotoMNN;
  inherited;

  frameLegend := TframeLegend.CreateFrame(Self, True, False, False);
  frameLegend.Parent := Self;
  frameLegend.Align := alBottom;

  PrepareColumnsInOrderGrid(dbgSummarySend);
  ChangePriceFontInOrderGrid(dbgSummaryCurrent);
  ChangePriceFontInOrderGrid(dbgSummarySend);
  TframePosition.AddFrame(Self, pClient, dsSummary, 'SynonymName', 'MnnId', ShowDescriptionAction);

  if not FUseCorrectOrders then begin
    cbNeedCorrect.Checked := False;
    cbNeedCorrect.Visible := False;
    gbCorrectMessage.Visible := False;
  end;

  if cbNeedCorrect.Visible then
    frameLeft := cbNeedCorrect.Left + cbNeedCorrect.Width + 5
  else
    frameLeft := btnSelectPrices.Left + btnSelectPrices.Width + 5;
  frameFilterAddresses := TframeFilterAddresses.AddFrame(
    Self,
    pTopSettings,
    frameLeft,
    pTopSettings.Height,
    dbgSummaryCurrent,
    OnChangeCheckBoxAllOrders,
    OnChangeFilterAllOrders);
  tmrFillReport.Enabled := False;
  tmrFillReport.Interval := 500;
  frameFilterAddresses.Visible := (LastSymmaryType = 0) and GetAddressController.AllowAllOrders;

  PrintEnabled := False;
  adsSummary.OnCalcFields := scf;
  dtpDateFrom.DateTime := LastDateFrom;
  dtpDateTo.DateTime := LastDateTo;
  //adsSummary.ParamByName( 'ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  rgSummaryType.ItemIndex := LastSymmaryType;
  PrintEnabled := ((LastSymmaryType = 0) and ((DM.SaveGridMask and PrintCurrentSummaryOrder) > 0))
               or ((LastSymmaryType = 1) and ((DM.SaveGridMask and PrintSendedSummaryOrder) > 0));
  dtpDateFrom.Enabled := LastSymmaryType = 1;
  dtpDateTo.Enabled := dtpDateFrom.Enabled;
  TDBGridHelper.RestoreColumnsLayout(dbgSummaryCurrent, Self.ClassName);
  Reg := TRegIniFile.Create;
  try
    //ѕытаемс€ прочитать из настроек дл€ отправленных заказов,
    //если их нет, то читаем их текущих заказов
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName + 'Sended', False)
    then
      try
        TDBGridHelper.RestoreColumnsLayout(dbgSummarySend, Self.ClassName + 'Sended');
      finally
        Reg.CloseKey;
      end
    else
      if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, False)
      then
        try
          TDBGridHelper.RestoreColumnsLayout(dbgSummarySend, Self.ClassName);
        finally
          Reg.CloseKey;
        end;
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
  if LastSymmaryType = 1 then
    try dbgSummarySend.SetFocus; except end;
end;

procedure TSummaryForm.FormDestroy(Sender: TObject);
begin
  TDBGridHelper.SaveColumnsLayout(dbgSummaryCurrent, Self.ClassName);
  TDBGridHelper.SaveColumnsLayout(dbgSummarySend, Self.ClassName + 'Sended');
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
  clientsSql : String;
begin
  Screen.Cursor := crHourglass;
  try
    clientsSql := '';
    if adsSummary.Active then
      adsSummary.Close;
    if LastSymmaryType = 0 then begin
      FilterSQL := GetSelectedPricesSQL(SelectedPrices, 'CurrentOrderHeads.');
      dbgSummaryCurrent.Visible := False;
      dbgSummarySend.Visible := False;
      dbgSummaryCurrent.Visible := True;
      adsSummary.SQL.Text := adsCurrentSummary.SQL.Text;
      if GetAddressController.ShowAllOrders then begin
        clientsSql := GetAddressController.GetFilter('CurrentOrderHeads.ClientId');
        if clientsSql <> '' then
          adsSummary.SQL.Text := adsSummary.SQL.Text
            + #13#10' and ' + clientsSql + ' '#13#10;
      end
      else
        adsSummary.SQL.Text := adsSummary.SQL.Text
          + #13#10' and (CurrentOrderHeads.ClientId = ' + DM.adtClientsCLIENTID.AsString + ') '#13#10;
      dbgSummaryCurrent.InputField := 'OrderCount';
      dbgSummaryCurrent.Tag := 256;
      if FUseCorrectOrders then
        cbNeedCorrect.Enabled := True;
      btnDelete.Enabled := True;
    end
    else begin
      FilterSQL := GetSelectedPricesSQL(SelectedPrices, 'PostedOrderHeads.');
      dbgSummaryCurrent.Visible := False;
      dbgSummarySend.Visible := False;
      dbgSummarySend.Visible := True;
      adsSummary.SQL.Text := adsSendSummary.SQL.Text;
      adsSummary.SQL.Text := adsSummary.SQL.Text
        + #13#10' and (PostedOrderHeads.ClientId = ' + DM.adtClientsCLIENTID.AsString + ') '#13#10;
      adsSummary.ParamByName( 'DATEFROM').Value := LastDateFrom;
      adsSummary.ParamByName( 'DATETO').Value := IncDay(LastDateTo);
      dbgSummarySend.InputField := '';
      dbgSummarySend.Tag := 512;
      btnDelete.Enabled := False;
      if FUseCorrectOrders then begin
        cbNeedCorrect.Checked := False;
        cbNeedCorrect.Enabled := False;
      end;
    end;
    if Length(FilterSQL) > 0 then
      adsSummary.SQL.Text := adsSummary.SQL.Text + ' and ( ' + FilterSQL + ' )';
    if (LastSymmaryType = 0) and FUseCorrectOrders and cbNeedCorrect.Checked then
      adsSummary.SQL.Text := adsSummary.SQL.Text
        + ' and ( CurrentOrderLists.DropReason is not null )';
    adsSummary.Open;
    SetOrderLabel;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TSummaryForm.scf(DataSet: TDataSet);
begin
  //вычисл€ем сумму по позиции
  try
    if (LastSymmaryType = 0) or adsSummaryRetailCost.IsNull then begin
      adsSummaryPriceRet.AsCurrency :=
        DM.GetRetailCost(
          adsSummaryCatalogVitallyImportant.Value,
          adsSummaryNDS.AsVariant,
          adsSummaryProducerCost.AsVariant,
          adsSummaryCost.AsCurrency);
    end
    else
      adsSummaryPriceRet.AsCurrency := adsSummaryRetailCost.Value;
    adsSummarySumOrder.AsCurrency := adsSummaryRealCost.AsCurrency * adsSummaryOrderCount.AsInteger;
  except
  end;
end;

procedure TSummaryForm.adsSummary2AfterPost(DataSet: TDataSet);
begin
  SetOrderLabel;
  if adsSummaryORDERCOUNT.AsInteger = 0 then
    adsSummary.Delete;
  MainForm.SetOrdersInfo;
end;

procedure TSummaryForm.Print( APreview: boolean = False);
var
  LastCurrentSQL : String;
begin
  //≈сли распечатываем текущий сводный заказ, то сбрасываем фильтр по поставщикам
  frVariables[ 'SymmaryType'] := LastSymmaryType;
  frVariables[ 'SymmaryDateFrom'] := DateToStr(LastDateFrom);
  frVariables[ 'SymmaryDateTo'] := DateToStr(LastDateTo);

  if LastSymmaryType = 0 then begin
    adsSummary.DisableControls;
    try
      LastCurrentSQL := adsSummary.SQL.Text;
      if adsSummary.Active then
        adsSummary.Close;
      adsSummary.SQL.Text :=
        adsCurrentSummary.SQL.Text
        + #13#10' and (CurrentOrderHeads.ClientId = ' + DM.adtClientsCLIENTID.AsString + ') '#13#10;
      adsSummary.Open;
      adsSummary.IndexFieldNames := 'SynonymName';
      DM.ShowFastReport( 'Summary.frf', adsSummary, APreview);
      adsSummary.Close;
      adsSummary.SQL.Text := LastCurrentSQL;
      adsSummary.Open;
      dbgSummaryCurrent.OnSortMarkingChanged(dbgSummaryCurrent);
    finally
      adsSummary.EnableControls;
    end;
  end
  else
    DM.ShowFastReport( 'Summary.frf', adsSummary, APreview);
end;

procedure TSummaryForm.dbgSummaryCurrentGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  PositionResult : TPositionSendResult;
begin
  //∆изненно-важный подсвечиваем только в текущем сводном заказе,
  //т.к. дл€ отправленного заказа значени€ не установлено
  if (LastSymmaryType = 0) and (adsSummaryVITALLYIMPORTANT.AsBoolean) then
    AFont.Color := VITALLYIMPORTANT_CLR;

  if adsSummaryJunk.AsBoolean and (( Column.Field = adsSummaryPERIOD)or
    ( Column.Field = adsSummaryCOST)) then Background := JUNK_CLR;
  //ожидаемый товар выдел€ем зеленым
  if adsSummaryAwait.AsBoolean and ( Column.Field = adsSummarySYNONYMNAME) then
    Background := AWAIT_CLR;
  //ѕодсветку позиций требующих корректировки осуществл€ем только в текущем заказе
  if (LastSymmaryType = 0) and FUseCorrectOrders and not adsSummaryDropReason.IsNull then begin
    PositionResult := TPositionSendResult(adsSummaryDropReason.AsInteger);

    //ћы здесь можем затереть подсветку ожидаемости, но это сделано осознано,
    //т.к. информаци€ о невозможности заказа позиции важнее
    if ( Column.Field = adsSummarySynonymName) and (PositionResult = psrNotExists)
    then
      Background := NeedCorrectColor;

    if ( Column.Field = adsSummarySumOrder)
      and (PositionResult in [psrDifferentCost, psrDifferentCostAndQuantity])
    then
      Background := NeedCorrectColor;

    if ( Column.Field = adsSummaryOrderCount)
      and (PositionResult in [psrDifferentQuantity, psrDifferentCostAndQuantity])
    then
      Background := NeedCorrectColor;
  end;
end;

procedure TSummaryForm.dbgSummaryCurrentCanInput(Sender: TObject; Value: Integer;
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
    { провер€ем заказ на соответствие наличию товара на складе }
    Val( adsSummaryQuantity.AsString, Quantity, E);
    if E<>0 then Quantity := 0;
    if ( Quantity > 0) and ( adsSummaryORDERCOUNT.AsInteger > Quantity) and
      ( AProc.MessageBox( '«аказ превышает остаток на складе. ѕродолжить?',
      MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) then adsSummaryORDERCOUNT.AsInteger := Quantity;
      
    PanelCaption := '';
    
    if (adsSummaryORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + '¬нимание! ¬ы заказали большое количество препарата.'
      else
        PanelCaption := '¬нимание! ¬ы заказали большое количество препарата.';

    if Length(PanelCaption) > 0 then begin
      if Timer.Enabled then
        Timer.OnTimer(nil);

      lWarning.Caption := PanelCaption;
      PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
      plOverCost.Height := PanelHeight*WordCount(PanelCaption, [#13, #10]) + 20;

      plOverCost.Top := ( dbgSummaryCurrent.Height - plOverCost.Height) div 2;
      plOverCost.Left := ( dbgSummaryCurrent.Width - plOverCost.Width) div 2;
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
  C := dbgSummaryCurrent.Canvas.TextHeight('Wg') + 2;
  if (adsSummary.RecordCount > 0) and ((adsSummary.RecordCount*C)/(pClient.Height-pWebBrowser.Height) > 13/10) then
    pWebBrowser.Visible := False
  else
    pWebBrowser.Visible := True;
}
  if (LastSymmaryType = 0) then
    if FUseCorrectOrders and not adsSummaryDropReason.IsNull then
      FillCorrectMessage
    else
      mCorrectMessage.Text := '';
end;

procedure TSummaryForm.dbgSummaryCurrentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    FlipToCore()
  else
    if (Shift = []) and (Key = VK_DELETE) and (not adsSummary.IsEmpty) then begin
      Key := 0;
      DeleteOrder;
    end
    else
      inherited;
end;

procedure TSummaryForm.dbgSummaryCurrentSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TSummaryForm.SetOrderLabel;
var
  V: array[0..0] of Variant;
  OrderCount: Integer;
  OrderSum: Double;
  FilterSQL : String;
begin
  OrderCount := adsSummary.RecordCount;
  lPosCount.Caption := IntToStr(OrderCount);

  if LastSymmaryType = 0 then begin
    //≈сли работает с текущим заказом, то выбираем сумму текущих заказов с учетом выставленного фильтра
    FilterSQL := GetSelectedPricesSQL(SelectedPrices, 'CurrentOrderHeads.');
    if DM.adsQueryValue.Active then
      DM.adsQueryValue.Close;
    DM.adsQueryValue.SQL.Text := ''
  +'SELECT '
  +'       ifnull(SUM(osbc.RealPrice * osbc.OrderCount), 0) SumOrder '
  +'FROM '
  +'       CurrentOrderHeads '
  +'       INNER JOIN CurrentOrderLists osbc       ON (CurrentOrderHeads.orderid  = osbc.OrderId) AND (osbc.OrderCount > 0) '
  +'       LEFT JOIN PricesRegionalData PRD ON (PRD.RegionCode      = CurrentOrderHeads.RegionCode) AND (PRD.PriceCode = CurrentOrderHeads.PriceCode) '
  +'       LEFT JOIN PricesData             ON (PricesData.PriceCode=PRD.PriceCode) '
  +'WHERE (CurrentOrderHeads.CLIENTID                                      = :ClientID) '
  +'   and (CurrentOrderHeads.Frozen = 0) '
  +'   AND (CurrentOrderHeads.Closed                                      <> 1)';
    if Length(FilterSQL) > 0 then
      DM.adsQueryValue.SQL.Text := DM.adsQueryValue.SQL.Text + ' and ( ' + FilterSQL + ' )';

    DM.adsQueryValue.ParamByName( 'ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
    DM.adsQueryValue.Open;
    try
      OrderSum := DM.adsQueryValue.FieldByName( 'SumOrder').AsCurrency;
    finally
      DM.adsQueryValue.Close;
    end;
  end
  else begin
    DataSetCalc( adsSummary,['SUM(SUMORDER)'], V);
    OrderSum := V[0];
  end;
  lSumOrder.Caption := Format('%0.2f', [OrderSum]);
end;

procedure TSummaryForm.DeleteOrder;
var
  I : Integer;
  selectedRows : TStringList;
begin
  if LastSymmaryType = 0 then begin
    selectedRows := TDBGridHelper.GetSelectedRows(dbgSummaryCurrent);
    if selectedRows.Count > 0 then begin

      if selectedRows.Count = 1 then begin
        if AProc.MessageBox('”далить позицию?', MB_ICONQUESTION or MB_YESNO) = IDYES then begin
          DM.adcUpdate.SQL.Text :=
            'delete from CurrentOrderLists where OrderID = ' +
              IntToStr(adsSummary.FieldByName('OrdersOrderID').AsInteger) +
              ' and CoreID = ' + IntToStr(adsSummary.FieldByName('OrdersCoreID').AsInteger);
          DM.adcUpdate.Execute;

          adsSummary.Close;
          adsSummary.Open;
          SetOrderLabel;
          MainForm.SetOrdersInfo;
        end;
      end
      else begin
        if AProc.MessageBox('”далить выбранные позиции?', MB_ICONQUESTION or MB_YESNO) = IDYES then begin

          adsSummary.DisableControls;
          try
            for I := 0 to selectedRows.Count-1 do begin
              adsSummary.Bookmark := selectedRows[i];
              DM.adcUpdate.SQL.Text :=
                'delete from CurrentOrderLists where OrderID = ' +
                  IntToStr(adsSummary.FieldByName('OrdersOrderID').AsInteger) +
                  ' and CoreID = ' + IntToStr(adsSummary.FieldByName('OrdersCoreID').AsInteger);
              DM.adcUpdate.Execute;
            end;
          finally
            adsSummary.EnableControls;
          end;

          adsSummary.Close;
          adsSummary.Open;
          SetOrderLabel;
          MainForm.SetOrdersInfo;
        end;
      end;
    end;
  end;
end;

procedure TSummaryForm.btnDeleteClick(Sender: TObject);
begin
  dbgSummaryCurrent.SetFocus;
  if (not adsSummary.IsEmpty) then
    DeleteOrder;
end;

procedure TSummaryForm.dtpDateCloseUp(Sender: TObject);
begin
  SetDateInterval;
  dbgSummarySend.SetFocus;
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
    frameFilterAddresses.Visible := (LastSymmaryType = 0) and GetAddressController.AllowAllOrders;
    PrintEnabled := ((LastSymmaryType = 0) and ((DM.SaveGridMask and PrintCurrentSummaryOrder) > 0))
                 or ((LastSymmaryType = 1) and ((DM.SaveGridMask and PrintSendedSummaryOrder) > 0));
    dtpDateFrom.Enabled := LastSymmaryType = 1;
    dtpDateTo.Enabled := dtpDateFrom.Enabled;
    SummaryShow;
    if (LastSymmaryType = 0) then begin
      gbCorrectMessage.Visible := FUseCorrectOrders;
      dbgSummaryCurrent.SetFocus;
    end
    else begin
      gbCorrectMessage.Visible := False;
      dbgSummarySend.SetFocus;
    end;
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
begin
  if MainForm.ActiveChild <> Self then exit;

  FlipToCore();
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

procedure TSummaryForm.cbNeedCorrectClick(Sender: TObject);
begin
  SummaryShow;
  dbgSummaryCurrent.SetFocus;
end;

procedure TSummaryForm.FillCorrectMessage;
var
  PositionResult : TPositionSendResult;
  CorrectMessage : String;
  newOrder, oldOrder, newCost, oldCost : String;
begin
  PositionResult := TPositionSendResult(adsSummaryDropReason.AsInteger);
  CorrectMessage := PositionSendResultText[PositionResult];
  CorrectMessage := CorrectMessage + ' (';
  if PositionResult = psrNotExists then begin
    CorrectMessage := CorrectMessage +
      Format(
        'стара€ цена: %s; старый заказ: %s',
        [adsSummaryServerCost.AsString,
        adsSummaryServerQuantity.AsString]);
  end
  else begin
    if not adsSummarySendResult.IsNull then begin
      newOrder := adsSummaryServerQuantity.AsString;
      newCost := adsSummaryServerCost.AsString;
      oldOrder := adsSummaryOrderCount.AsString;
      oldCost := adsSummaryCost.AsString;
    end
    else begin
      newOrder := adsSummaryOrderCount.AsString;
      newCost := adsSummaryCost.AsString;
      oldOrder := adsSummaryServerQuantity.AsString;
      oldCost := adsSummaryServerCost.AsString;
    end;

    if PositionResult in [psrDifferentCost, psrDifferentCostAndQuantity] then
      CorrectMessage := CorrectMessage +
        Format('стара€ цена: %s; нова€ цена: %s', [oldCost, newCost]);

    if PositionResult in [psrDifferentQuantity, psrDifferentCostAndQuantity] then
      CorrectMessage := CorrectMessage +
        Format('старый заказ: %s; новый заказ: %s', [oldOrder, newOrder]);
  end;
  CorrectMessage := CorrectMessage + ')';
  mCorrectMessage.Text := CorrectMessage;
end;

procedure TSummaryForm.UpdateOrderDataset;
var
  lastCoreId : Variant;
begin
  if LastSymmaryType = 0 then begin
    lastCoreId := adsSummaryCoreID.AsVariant;
    adsSummary.DisableControls;
    try
      if adsSummary.Active then
        adsSummary.Close;
      adsSummary.Open;
      if not adsSummary.Locate('CoreId', lastCoreId, []) then
        adsSummary.First;
    finally
      adsSummary.EnableControls;
    end;
  end;
end;

procedure TSummaryForm.OnChangeCheckBoxAllOrders;
begin

end;

procedure TSummaryForm.OnChangeFilterAllOrders;
begin
  tmrFillReport.Enabled := False;
  tmrFillReport.Enabled := True;
end;

procedure TSummaryForm.tmrFillReportTimer(Sender: TObject);
begin
  tmrFillReport.Enabled := False;
  SummaryShow;
end;

procedure TSummaryForm.ChangePriceFontInOrderGrid(Grid: TToughDBGrid);
var
  realPriceCoumn : TColumnEh;
  priceColumn : TColumnEh;
begin
  if DM.adtClientsAllowDelayOfPayment.Value then begin
    realPriceCoumn := ColumnByNameT(TToughDBGrid(grid), adsSummaryRealCost.FieldName);
    priceColumn := ColumnByNameT(TToughDBGrid(grid), adsSummaryCost.FieldName);
    if Assigned(realPriceCoumn) and Assigned(priceColumn) then begin
      priceColumn.Font.Style := priceColumn.Font.Style - [fsBold];
      realPriceCoumn.Font.Style := realPriceCoumn.Font.Style + [fsBold];
    end;
  end;
end;

procedure TSummaryForm.FlipToCore;
var
  FullCode, ShortCode: integer;
  CoreId : Int64;
begin
  if adsSummary.IsEmpty then Exit;
  if LastSymmaryType <> 0 then Exit;

  FullCode := adsSummaryFullCode.AsInteger;
  ShortCode := adsSummaryShortCode.AsInteger;

  CoreId := adsSummaryCOREID.AsLargeInt;

  FlipToCodeWithReturn(FullCode, ShortCode, CoreId);
end;

procedure TSummaryForm.dbgSummaryCurrentDblClick(Sender: TObject);
var
  C : GridsEh.TGridCoord;
  P : TPoint;
  grid : TCustomDBGridEh;
begin
  inherited;
  if Sender is TCustomDBGridEh then begin
    grid := TCustomDBGridEh(Sender);
    p := grid.ScreenToClient(Mouse.CursorPos);
    C := grid.MouseCoord(p.X, p.Y);
    if C.Y > 0 then
      FlipToCore();
  end;
end;

initialization
  LastDateFrom := Date;
  LastDateTo := Date;
  LastSymmaryType := 0;
end.
