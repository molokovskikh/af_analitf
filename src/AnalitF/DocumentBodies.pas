unit DocumentBodies;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, StdCtrls, DBCtrls, GridsEh, DBGridEh,
  ToughDBGrid, DB, MemDS, DBAccess, MyAccess, DModule, DocumentTypes,
  FR_DSet, FR_DBSet, Buttons, FR_Class,
  Menus;

type
  TDocumentBodiesForm = class(TChildForm)
    pOrderHeader: TPanel;
    dbtPriceName: TDBText;
    Label1: TLabel;
    dbtId: TDBText;
    Label2: TLabel;
    dbtOrderDate: TDBText;
    lblRecordCount: TLabel;
    lblSum: TLabel;
    dbtPositions: TDBText;
    dbtSumOrder: TDBText;
    Label4: TLabel;
    Label5: TLabel;
    dbtRegionName: TDBText;
    lSumOrder: TLabel;
    pGrid: TPanel;
    dbgDocumentBodies: TDBGridEh;
    adsDocumentHeaders: TMyQuery;
    adsDocumentHeadersId: TLargeintField;
    adsDocumentHeadersDownloadId: TLargeintField;
    adsDocumentHeadersWriteTime: TDateTimeField;
    adsDocumentHeadersFirmCode: TLargeintField;
    adsDocumentHeadersClientId: TLargeintField;
    adsDocumentHeadersDocumentType: TWordField;
    adsDocumentHeadersProviderDocumentId: TStringField;
    adsDocumentHeadersOrderId: TLargeintField;
    adsDocumentHeadersHeader: TStringField;
    adsDocumentHeadersProviderName: TStringField;
    dsDocumentHeaders: TDataSource;
    adsDocumentHeadersPositions: TLargeintField;
    dbtDocumentType: TDBText;
    dsDocumentBodies: TDataSource;
    adsDocumentBodies: TMyQuery;
    adsDocumentBodiesId: TLargeintField;
    adsDocumentBodiesDocumentId: TLargeintField;
    adsDocumentBodiesProduct: TStringField;
    adsDocumentBodiesCode: TStringField;
    adsDocumentBodiesCertificates: TStringField;
    adsDocumentBodiesPeriod: TStringField;
    adsDocumentBodiesProducer: TStringField;
    adsDocumentBodiesCountry: TStringField;
    adsDocumentBodiesProducerCost: TFloatField;
    adsDocumentBodiesRegistryCost: TFloatField;
    adsDocumentBodiesSupplierPriceMarkup: TFloatField;
    adsDocumentBodiesSupplierCostWithoutNDS: TFloatField;
    adsDocumentBodiesSupplierCost: TFloatField;
    gbPrint: TGroupBox;
    cbPrintEmptyTickets: TCheckBox;
    spPrintTickets: TSpeedButton;
    adsDocumentHeadersLocalWriteTime: TDateTimeField;
    cbClearRetailPrice: TCheckBox;
    spPrintReestr: TSpeedButton;
    cbWaybillAsVitallyImportant: TCheckBox;
    spEditMarkups: TSpeedButton;
    adsDocumentBodiesQuantity: TIntegerField;
    sbEditAddress: TSpeedButton;
    adsDocumentBodiesVitallyImportant: TBooleanField;
    tmrVitallyImportantChange: TTimer;
    procedure dbgDocumentBodiesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormHide(Sender: TObject);
    procedure adsDocumentHeadersDocumentTypeGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure spPrintTicketsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbPrintEmptyTicketsClick(Sender: TObject);
    procedure cbClearRetailPriceClick(Sender: TObject);
    procedure spPrintReestrClick(Sender: TObject);
    procedure cbWaybillAsVitallyImportantClick(Sender: TObject);
    procedure spEditMarkupsClick(Sender: TObject);
    procedure sbEditAddressClick(Sender: TObject);
    procedure tmrVitallyImportantChangeTimer(Sender: TObject);
  private
    { Private declarations }
    FDocumentId : Int64;
    CalculateOnProducerCost : Boolean;
    retailPriceField : TFloatField;
    retailMarkupField : TFloatField;
    manualCorrectionField : TBooleanField;
    NDSField : TIntegerField;
    retailSummField : TCurrencyField;
    maxRetailMarkupField : TCurrencyField;
    realMarkupField : TFloatField;

    FGridPopup : TPopupMenu;
    FGridColumns : TMenuItem;

    procedure SetParams;
    procedure PrepareGrid;
    procedure WaybillCalcFields(DataSet : TDataSet);
    procedure LoadFromRegistry();
    procedure RecalcDocument;
    procedure RecalcPosition;
    procedure WaybillGetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure WaybillKeyPress(Sender: TObject; var Key: Char);
    //procedure FieldOnChange(Sender: TField);
    procedure RetailPriceUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure RetailPriceGetCellParams(Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
    procedure RetailMarkupUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure RetailMarkupGetCellParams(Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
    procedure RealMarkupUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure RealMarkupGetCellParams(Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);

    //методы для расчета розничных наценок и цен
    //Получить цену по наценке, но может измениться сама наценка
    function GetRetailPriceByMarkup(var markup : Double) : Double;
    //Получить наценку по цене
    function GetRetailMarkupByPrice(price : Double) : Double;
    //Можем ли мы рассчитать розничную наценку, основываясь на полученных данных
    function CanCalculateRetailMarkup : Boolean;

    procedure GridColumnsClick( Sender: TObject);
  public
    { Public declarations }
    procedure ShowForm(DocumentId: Int64; ParentForm : TChildForm); overload; //reintroduce;
  end;

implementation

{$R *.dfm}

uses
  Main, StrUtils, AProc, Math, DBProc, sumprops, EditVitallyImportantMarkups,
  EditAddressForm, Constant, DBGridHelper,
  ToughDBGridColumns;

{
  Стандартная фунция RoundTo работала не корректно
  Пример:
    1.23 -> 1.2
    1.29 -> 1.2
    1.2  -> 1.1
  Пришлось ее доработать, чтобы в случае 1.2 получалось 1.2
}
function RoundToOneDigit(const AValue: Double): Double;
var
  LFactor: Double;
begin
  LFactor := IntPower(10, -1);
  if (1 - Frac(AValue / LFactor)) > 0.001  then
    Result := Int(AValue / LFactor) * LFactor
  else
    Result := (AValue / LFactor) * LFactor;
end;


{ TDocumentBodiesForm }

procedure TDocumentBodiesForm.SetParams;
begin
  adsDocumentHeaders.Close;
  adsDocumentHeaders.ParamByName( 'TimeZoneBias').Value := AProc.TimeZoneBias;
  adsDocumentHeaders.ParamByName('DocumentId').Value := FDocumentId;
  adsDocumentHeaders.Open;
  adsDocumentBodies.Close;
  PrepareGrid;
  gbPrint.Visible := adsDocumentHeadersDocumentType.Value = 1;
  adsDocumentBodies.ParamByName('DocumentId').Value := FDocumentId;
  if adsDocumentHeadersDocumentType.Value = 1 then
    RecalcDocument
  else
    adsDocumentBodies.Open;
  Self.Caption := 'Детализация ' + RussianDocumentTypeForHeaderForm[TDocumentType(adsDocumentHeadersDocumentType.Value)];
end;

procedure TDocumentBodiesForm.ShowForm(DocumentId: Int64;
  ParentForm: TChildForm);
begin
  FDocumentId := DocumentId;
  SetParams;
  inherited ShowForm;
end;

procedure TDocumentBodiesForm.dbgDocumentBodiesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
{
var
  lastField : TField;
}  
begin
  if Key = VK_RETURN then begin
    if dbgDocumentBodies.EditorMode then begin
    {
      //В связи с переходом не TDBGridEh это код не нужен
      dbgDocumentBodies.EditorMode := False;
      if adsDocumentBodies.State in [dsEdit, dsInsert] then begin
        //Если мы в состоянии dsEdit, то мы редактировали одно из доступных полей:
        //розничная наценка или розничная цена, то значит надо выставить ManualCorrection
        SoftPost(adsDocumentBodies);
        lastField := dbgDocumentBodies.SelectedField;
        try
          dbgDocumentBodies.SelectedField := adsDocumentBodiesProduct;
        finally
          dbgDocumentBodies.SelectedField := lastField;
        end;
      end;
      }
    end
  end
  else
  if Key = VK_ESCAPE then
    if dbgDocumentBodies.EditorMode then begin
{
      //В связи с переходом не TDBGridEh это код не нужен
      adsDocumentBodies.Cancel;
      lastField := dbgDocumentBodies.SelectedField;
      try
        dbgDocumentBodies.SelectedField := adsDocumentBodiesProduct;
      finally
        dbgDocumentBodies.SelectedField := lastField;
      end;
}      
    end
    else
      if Assigned(PrevForm) then
        PrevForm.ShowAsPrevForm;
end;

procedure TDocumentBodiesForm.PrepareGrid;
var
  column : TColumnEh;
begin
  dbgDocumentBodies.Flat := True;
  dbgDocumentBodies.Options := dbgDocumentBodies.Options + [dgRowLines];
  dbgDocumentBodies.Font.Size := 10;
  dbgDocumentBodies.GridLineColors.DarkColor := clBlack;
  dbgDocumentBodies.GridLineColors.BrightColor := clDkGray;
  if CheckWin32Version(5, 1) then
    dbgDocumentBodies.OptionsEh := dbgDocumentBodies.OptionsEh + [dghTraceColSizing];

  dbgDocumentBodies.SelectedField := nil;
  dbgDocumentBodies.Columns.Clear();
  dbgDocumentBodies.ShowHint := True;
  if adsDocumentHeadersDocumentType.Value = 1 then begin
    adsDocumentBodies.OnCalcFields := WaybillCalcFields;
    dbgDocumentBodies.OnGetCellParams := WaybillGetCellParams;
    dbgDocumentBodies.OnKeyPress := WaybillKeyPress;
    dbgDocumentBodies.ReadOnly := True;

    dbgDocumentBodies.AutoFitColWidths := False;
    try
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Product', 'Наименование', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Certificates', 'Серии сертификатов', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Period', 'Срок годности', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Producer', 'Производитель', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Country', 'Страна', 0);
      //TDBGridHelper.AddColumn(dbgDocumentBodies, 'VitallyImportant', 'Признак ЖНВЛС', 0, False);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'ProducerCost', 'Цена производителя без НДС', dbgDocumentBodies.Canvas.TextWidth('99999.99'), False);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'RegistryCost', 'Цена ГР', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'SupplierPriceMarkup', 'Торговая наценка оптовика', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'SupplierCostWithoutNDS', 'Цена поставщика без НДС', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'NDS', 'НДС', dbgDocumentBodies.Canvas.TextWidth('999'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'SupplierCost', 'Цена поставщика с НДС', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'MaxRetailMarkup', 'Макс. розничная наценка', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      column := TDBGridHelper.AddColumn(dbgDocumentBodies, 'RetailMarkup', 'Розничная наценка', dbgDocumentBodies.Canvas.TextWidth('99999.99'), False);
      column.OnUpdateData := RetailMarkupUpdateData;
      column.OnGetCellParams := RetailMarkupGetCellParams;
      column := TDBGridHelper.AddColumn(dbgDocumentBodies, 'RealMarkup', 'Реальная наценка', dbgDocumentBodies.Canvas.TextWidth('99999.99'), False);
      column.OnUpdateData := RealMarkupUpdateData;
      column.OnGetCellParams := RealMarkupGetCellParams;
      column := TDBGridHelper.AddColumn(dbgDocumentBodies, 'RetailPrice', 'Розничная цена', dbgDocumentBodies.Canvas.TextWidth('99999.99'), False);
      column.OnUpdateData := RetailPriceUpdateData;
      column.OnGetCellParams := RetailPriceGetCellParams;
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Quantity', 'Заказ', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'RetailSumm', 'Розничная сумма', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
    finally
      dbgDocumentBodies.AutoFitColWidths := True;
    end;
    dbgDocumentBodies.ReadOnly := False;
    dbgDocumentBodies.Options := dbgDocumentBodies.Options + [dgEditing];
    dbgDocumentBodies.SelectedField := retailMarkupField;
  end
  else begin
    adsDocumentBodies.OnCalcFields := nil;
    dbgDocumentBodies.OnGetCellParams := nil;
    dbgDocumentBodies.OnKeyPress := nil;
    dbgDocumentBodies.Options := dbgDocumentBodies.Options - [dgEditing];
    dbgDocumentBodies.AutoFitColWidths := False;
    dbgDocumentBodies.ReadOnly := True;
    try
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Product', 'Наименование', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Producer', 'Производитель', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'SupplierCost', 'Цена', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Quantity', 'Заказ', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
    finally
      dbgDocumentBodies.AutoFitColWidths := True;
    end;
  end;
  LoadFromRegistry();
end;

procedure TDocumentBodiesForm.WaybillCalcFields(DataSet: TDataSet);
var
  maxMarkup : Currency;
  price,
  markup : Double;
begin
  try
    if not adsDocumentBodiesProducerCost.IsNull then begin
      if adsDocumentBodiesVitallyImportant.Value
      or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
      then
        maxMarkup := DM.GetMaxVitallyImportantMarkup(adsDocumentBodiesProducerCost.Value)
      else
        maxMarkup := DM.GetMaxRetailMarkup(adsDocumentBodiesProducerCost.Value);
      maxRetailMarkupField.Value := maxMarkup;
    end;

    if not retailMarkupField.IsNull then begin
      markup := retailMarkupField.Value;
      price := GetRetailPriceByMarkup(markup);
      retailPriceField.Value := price;
      retailSummField.Value := price * adsDocumentBodiesQuantity.Value;
      realMarkupField.Value := ((price - adsDocumentBodiesSupplierCost.Value) * 100)/ adsDocumentBodiesSupplierCost.Value; 
    end;

  except
  end;
end;

procedure TDocumentBodiesForm.FormHide(Sender: TObject);
begin
  inherited;
  TDBGridHelper.SaveColumnsLayout(
    dbgDocumentBodies,
    IfThen(adsDocumentHeadersDocumentType.Value = 1, 'DetailWaybill', 'DetailReject'));
end;

procedure TDocumentBodiesForm.LoadFromRegistry;
begin
  TDBGridHelper.RestoreColumnsLayout(
    dbgDocumentBodies,
    IfThen(adsDocumentHeadersDocumentType.Value = 1, 'DetailWaybill', 'DetailReject'));
end;

procedure TDocumentBodiesForm.adsDocumentHeadersDocumentTypeGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if DisplayText then
    Text := RussianDocumentType[TDocumentType(Sender.AsInteger)];
end;

procedure TDocumentBodiesForm.spPrintTicketsClick(Sender: TObject);
var
  priceNameVariant : Variant;
  priceName : String;
  bracketIndex : Integer;
begin
  priceNameVariant := DM.QueryValue(
    'select PriceName from pricesdata where FirmCode = ' + adsDocumentHeadersFirmCode.AsString + ' limit 1',
    [],
    []);
  if not VarIsNull(priceNameVariant) and (VarIsStr(priceNameVariant)) then begin
    priceName := priceNameVariant;
    bracketIndex := Pos('(',priceName);
    if bracketIndex > 0 then
      priceName := Copy(priceName, 1, bracketIndex -1);
  end
  else
    priceName := adsDocumentHeadersProviderName.AsString;
  priceName := Trim(priceName);

  frVariables[ 'PrintEmptyTickets'] := cbPrintEmptyTickets.Checked;
  frVariables[ 'ClientName'] := DM.GetClientNameAndAddress;
  frVariables[ 'ProviderDocumentId'] := adsDocumentHeadersProviderDocumentId.AsString;
  frVariables[ 'DocumentDate'] := DateToStr(adsDocumentHeadersLocalWriteTime.AsDateTime);
  frVariables[ 'TicketSignature'] := priceName;

  DM.ShowFastReport('Ticket.frf', adsDocumentBodies, True);
end;

procedure TDocumentBodiesForm.FormCreate(Sender: TObject);
var
  calc : TField;

  procedure SetDisplayFormat(fieldNames : array of string);
  var
    I : Integer;
    field : TField;
  begin
    for I := Low(fieldNames) to High(fieldNames) do
    begin
      field := adsDocumentBodies.FindField(fieldNames[i]);
      if Assigned(field) and (field is TFloatField) then
        TFloatField(field).DisplayFormat := '0.00;;';
    end;
  end;

  function AddField(FieldName : String) : TCurrencyField;
  begin
    Result := TCurrencyField(adsDocumentBodies.FindField(FieldName));
    if not Assigned(Result) then begin
      Result := TCurrencyField.Create(adsDocumentBodies);
      Result.fieldname := FieldName;
      Result.FieldKind := fkCalculated;
      Result.Calculated := True;
      Result.DisplayFormat := '0.00;;';
      Result.Dataset := adsDocumentBodies;
    end;
  end;

  function AddFloatField(FieldName : String) : TFloatField;
  begin
    Result := TFloatField(adsDocumentBodies.FindField(FieldName));
    if not Assigned(Result) then begin
      Result := TFloatField.Create(adsDocumentBodies);
      Result.fieldname := FieldName;
      Result.FieldKind := fkCalculated;
      Result.Calculated := True;
      Result.DisplayFormat := '0.00;;';
      Result.Dataset := adsDocumentBodies;
    end;
  end;

begin
  CalculateOnProducerCost := DM.adsUser.FieldByName('CalculateOnProducerCost').AsBoolean;
  //Добавлем наценки
  retailMarkupField := TFloatField(adsDocumentBodies.FindField('RetailMarkup'));
  if not Assigned(retailMarkupField) then begin
    retailMarkupField := TFloatField.Create(adsDocumentBodies);
    retailMarkupField.FieldName := 'RetailMarkup';
    retailMarkupField.DisplayFormat := '0.00;;';
    //retailMarkupField.OnChange := FieldOnChange;
    retailMarkupField.DataSet := adsDocumentBodies;
  end;
  //adsDocumentBodiesVitallyImportant.OnChange := FieldOnChange;
  manualCorrectionField := TBooleanField(adsDocumentBodies.FindField('ManualCorrection'));
  if not Assigned(manualCorrectionField) then begin
    manualCorrectionField := TBooleanField.Create(adsDocumentBodies);
    manualCorrectionField.FieldName := 'ManualCorrection';
    manualCorrectionField.DataSet := adsDocumentBodies;
  end;
  NDSField := TIntegerField(adsDocumentBodies.FindField('NDS'));
  if not Assigned(NDSField) then begin
    NDSField := TIntegerField.Create(adsDocumentBodies);
    NDSField.FieldName := 'NDS';
    NDSField.DataSet := adsDocumentBodies;
  end;
  calc := adsDocumentBodies.FindField('Quantity');
  if Assigned(calc) and (calc is TIntegerField) then
    TIntegerField(calc).DisplayFormat := '#';

  SetDisplayFormat(
  [
    'ProducerCost',
    'RegistryCost',
    'SupplierPriceMarkup',
    'SupplierCostWithoutNDS',
    'SupplierCost'
  ]);

  //Добавляем вычисляемые поля в датасет
  retailSummField := AddField('RetailSumm');
  maxRetailMarkupField := AddField('MaxRetailMarkup');
  retailPriceField := AddFloatField('RetailPrice');
  realMarkupField := AddFloatField('RealMarkup');

  FGridPopup := TPopupMenu.Create( Self);
  dbgDocumentBodies.PopupMenu := FGridPopup;
  FGridColumns := TMenuItem.Create(FGridPopup);
  FGridColumns.Caption := 'Столбцы...';
  FGridColumns.OnClick := GridColumnsClick;
  FGridPopup.Items.Add(FGridColumns);

  inherited;
end;

procedure TDocumentBodiesForm.cbPrintEmptyTicketsClick(Sender: TObject);
begin
  dbgDocumentBodies.SetFocus();
end;

procedure TDocumentBodiesForm.cbClearRetailPriceClick(Sender: TObject);
begin
  dbgDocumentBodies.SetFocus();
  RecalcDocument;
end;

procedure TDocumentBodiesForm.spPrintReestrClick(Sender: TObject);
var
  totalRetailSumm : Currency;
  V: array[0..0] of Variant;
begin
  DBProc.DataSetCalc(adsDocumentBodies, ['Sum(RetailSumm)'], V);
  totalRetailSumm := V[0];

  frVariables[ 'ClientName'] := DM.GetClientNameAndAddress;
  frVariables[ 'ProviderName'] := adsDocumentHeadersProviderName.AsString;
  frVariables[ 'ProviderDocumentId'] := adsDocumentHeadersProviderDocumentId.AsString;
  frVariables[ 'DocumentDate'] := DateToStr(adsDocumentHeadersLocalWriteTime.AsDateTime);

  frVariables[ 'ReestrNumber'] := '17';
  frVariables[ 'ReestrAppend'] := '5';

  frVariables[ 'Director'] := DM.adtClientsDirector.AsString;
  frVariables[ 'DeputyDirector'] := DM.adtClientsDeputyDirector.AsString;
  frVariables[ 'Accountant'] := DM.adtClientsAccountant.AsString;

  frVariables[ 'TotalRetailSumm'] := totalRetailSumm;
  frVariables[ 'TotalRetailSummText'] := AnsiLowerCase(MoneyToString(totalRetailSumm, True, False));

  DM.ShowFastReport('Reestr.frf', adsDocumentBodies, True);
end;

procedure TDocumentBodiesForm.cbWaybillAsVitallyImportantClick(
  Sender: TObject);
begin
  if cbWaybillAsVitallyImportant.Checked then
    if not DM.VitallyImportantMarkupsExists then begin
      ShowEditVitallyImportantMarkups;
      cbWaybillAsVitallyImportant.Checked := DM.VitallyImportantMarkupsExists;
    end;

  RecalcDocument;
  dbgDocumentBodies.SetFocus();
end;

procedure TDocumentBodiesForm.WaybillGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if (retailMarkupField.Value < 0) then
    if AnsiMatchText(Column.Field.FieldName,
        ['RetailMarkup', 'RetailPrice', 'RetailSumm', 'RealMarkup'])
    then
      Background := clRed;

  if (retailMarkupField.Value > maxRetailMarkupField.Value)
     and AnsiMatchText(Column.Field.FieldName, ['RetailMarkup', 'MaxRetailMarkup'])
  then
    Background := clRed;

  if (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
    or (not adsDocumentBodiesVitallyImportant.IsNull and adsDocumentBodiesVitallyImportant.AsBoolean)
  then begin
    AFont.Color := VITALLYIMPORTANT_CLR;
    if (Column.Field = NDSField) and not NDSField.IsNull and (NDSField.Value <> 10)
    then
      Background := clRed;
  end;
end;

procedure TDocumentBodiesForm.spEditMarkupsClick(Sender: TObject);
begin
  ShowEditVitallyImportantMarkups;
  RecalcDocument;
end;

procedure TDocumentBodiesForm.sbEditAddressClick(Sender: TObject);
begin
  ShowEditAddress;
  RecalcDocument;
end;

{
procedure TDocumentBodiesForm.FieldOnChange(Sender: TField);
begin
  if Sender = adsDocumentBodiesVitallyImportant then begin
    //Этот код временно комментирую, т.к. не нужно редактировать жизненно-важность у позиции
//    if not manualCorrectionField.Value then
//      RecalcPosition;
//    //По-другому решить проблему не удалось. Запускаю таймер, чтобы он в главной нити
//    //произвел сохранение dataset
//    tmrVitallyImportantChange.Enabled := True;
  end
  else
    if Sender = retailPriceField then begin
    end
    else
    if Sender = retailMarkupField then begin
    end;
  //WriteExchangeLog('OnChange', 'Field = ' + Sender.FieldName);
end;
}

procedure TDocumentBodiesForm.RecalcDocument;
var
  LastId : Int64;
begin
  //retailPriceField.OnChange := nil;
  //retailMarkupField.OnChange := nil;
  //adsDocumentBodiesVitallyImportant.OnChange := nil;
  adsDocumentBodies.DisableControls;
  try
    LastId := adsDocumentBodiesId.Value;
    adsDocumentBodies.Close;
    adsDocumentBodies.Open;
    while not adsDocumentBodies.Eof do begin
{
      if not manualCorrectionField.Value then begin
      end;
}      
      adsDocumentBodies.Edit;
      RecalcPosition;
      adsDocumentBodies.Post;
      adsDocumentBodies.Next;
    end;
    if not adsDocumentBodies.Locate('Id', LastId, []) then
      adsDocumentBodies.First;
  finally
    adsDocumentBodies.EnableControls;
    //retailPriceField.OnChange := FieldOnChange;
    //retailMarkupField.OnChange := FieldOnChange;
    //adsDocumentBodiesVitallyImportant.OnChange := FieldOnChange;
  end;
end;

procedure TDocumentBodiesForm.RecalcPosition;
var
  upCostVariant : Variant;
  upcost : Double;
begin
  upCostVariant := Null;
  if not manualCorrectionField.Value then begin

    if not adsDocumentBodiesProducerCost.IsNull then begin
      if adsDocumentBodiesVitallyImportant.Value
      or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
      then
        upCostVariant := DM.GetVitallyImportantMarkup(adsDocumentBodiesProducerCost.Value)
      else
        upCostVariant := DM.GetRetUpCost(adsDocumentBodiesProducerCost.Value);
    end;

  end
  else
    upCostVariant := retailMarkupField.AsVariant;

  if not VarIsNull(upCostVariant) then begin
    if CanCalculateRetailMarkup() then begin
      upcost := upCostVariant;
      GetRetailPriceByMarkup(upcost);
      retailMarkupField.Value := upcost;
    end
    else
      //Если не можем рассчитать, то надо сбрасывать наценку
      retailMarkupField.Clear;
  end;
end;

procedure TDocumentBodiesForm.tmrVitallyImportantChangeTimer(
  Sender: TObject);
begin
  try
    SoftPost( adsDocumentBodies );
  finally
    tmrVitallyImportantChange.Enabled := False;
  end;
end;

procedure TDocumentBodiesForm.RetailPriceUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  markup,
  price : Double;
begin
  if (adsDocumentBodies.State in [dsEdit]) and not retailMarkupField.IsNull
  then begin
    if StrToFloatDef(Value, 0.0) > 0 then begin
      price := Value;
      markup := GetRetailMarkupByPrice(price);
      if (price > 0) and (markup > 0) then begin
        manualCorrectionField.Value := True;
        retailMarkupField.AsVariant := markup;
        adsDocumentBodies.Post;
      end
      else
        adsDocumentBodies.Cancel;
    end;
    Handled := True;
  end;
end;

procedure TDocumentBodiesForm.WaybillKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (dbgDocumentBodies.SelectedField <> retailPriceField)
    and (dbgDocumentBodies.SelectedField <> retailMarkupField)
    and (dbgDocumentBodies.SelectedField <> realMarkupField)
  then
    if (Key in [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then begin
      dbgDocumentBodies.SelectedField := retailMarkupField;
      SendMessage(dbgDocumentBodies.Handle, WM_CHAR, Ord( Key), 0);
      Key := #0;
    end;
end;

procedure TDocumentBodiesForm.RetailMarkupUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  markup,
  price : Double;
begin
  if (adsDocumentBodies.State in [dsEdit]) and not retailMarkupField.IsNull
  then begin
    if StrToFloatDef(Value, 0.0) > 0 then begin
      markup := Value;
      price := GetRetailPriceByMarkup(markup);
      if (price > 0) and (markup > 0) then begin
        manualCorrectionField.Value := True;
        retailMarkupField.AsVariant := markup;
        adsDocumentBodies.Post;
      end
      else
        adsDocumentBodies.Cancel;
    end;
    Handled := True;
  end;
end;

procedure TDocumentBodiesForm.RetailPriceGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if (Sender is TColumnEh) and (TColumnEh(Sender).Field = retailPriceField)
  then
    if not retailMarkupField.IsNull and Params.ReadOnly then
      Params.ReadOnly := False;
end;

function TDocumentBodiesForm.GetRetailMarkupByPrice(price: Double): Double;
var
  vitallyNDS : Integer;
  vitallyNDSMultiplier : Double;
  nonVitallyNDSMultiplier : Double;
begin
  if cbClearRetailPrice.Checked and (Abs(price - RoundToOneDigit(price)) > 0.001)
  then
    price := RoundToOneDigit(price);

  if adsDocumentBodiesVitallyImportant.Value
  or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
  then begin

    if not NDSField.IsNull then
      vitallyNDS := NDSField.Value
    else
      vitallyNDS := 10;

    //Если cпособ налогообложения ЕНВД и флаг "CalculateWithNDS" сброшен, то множитель = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      vitallyNDSMultiplier := 1
    else
      vitallyNDSMultiplier := (1 + vitallyNDS/100);

    //ЕНВД
    if (DM.adtClientsMethodOfTaxation.Value = 0) then

      Result := ((price - adsDocumentBodiesSupplierCost.Value)*100)/(adsDocumentBodiesProducerCost.Value * vitallyNDSMultiplier)

    else
    //НДС

      Result := ((price/vitallyNDSMultiplier - adsDocumentBodiesSupplierCostWithoutNDS.Value) *100) / adsDocumentBodiesProducerCost.Value;

  end
  else begin

    //Если cпособ налогообложения ЕНВД и флаг "CalculateWithNDS" сброшен, то множитель = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      nonVitallyNDSMultiplier := 1
    else
      nonVitallyNDSMultiplier := (1 + NDSField.Value/100);

    //По цене производителя
    if CalculateOnProducerCost then
      Result := ((price - adsDocumentBodiesSupplierCost.Value)*100)/(adsDocumentBodiesProducerCost.Value * nonVitallyNDSMultiplier)
    else
    //По цене поставщика без НДС
      Result := ((price - adsDocumentBodiesSupplierCost.Value)*100)/(adsDocumentBodiesSupplierCostWithoutNDS.Value * nonVitallyNDSMultiplier);
  end;
end;

function TDocumentBodiesForm.GetRetailPriceByMarkup(
  var markup: Double): Double;
var
  vitallyNDS : Integer;
  vitallyNDSMultiplier : Double;
  nonVitallyNDSMultiplier : Double;
begin
  if adsDocumentBodiesVitallyImportant.Value
  or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
  then begin

    if not NDSField.IsNull then
      vitallyNDS := NDSField.Value
    else
      vitallyNDS := 10;

    //Если cпособ налогообложения ЕНВД и флаг "CalculateWithNDS" сброшен, то множитель = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      vitallyNDSMultiplier := 1
    else
      vitallyNDSMultiplier := (1 + vitallyNDS/100);

    //ЕНВД
    if (DM.adtClientsMethodOfTaxation.Value = 0) then begin
      Result := adsDocumentBodiesSupplierCost.Value + adsDocumentBodiesProducerCost.Value*vitallyNDSMultiplier*(markup/100);

      if cbClearRetailPrice.Checked and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        //markup := ((Result - adsDocumentBodiesSupplierCost.Value) / adsDocumentBodiesProducerCost.Value)*100;
        markup := ((Result - adsDocumentBodiesSupplierCost.Value)*100)/(adsDocumentBodiesProducerCost.Value * vitallyNDSMultiplier)
      end;

    end
    else begin
    //НДС
      Result := (adsDocumentBodiesSupplierCostWithoutNDS.Value + adsDocumentBodiesProducerCost.Value*(markup/100)) * vitallyNDSMultiplier;

      if cbClearRetailPrice.Checked and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        //markup := ((Result/1.1 - adsDocumentBodiesSupplierCostWithoutNDS.Value) / adsDocumentBodiesProducerCost.Value)*100;
        markup := ((Result/vitallyNDSMultiplier - adsDocumentBodiesSupplierCostWithoutNDS.Value) *100) / adsDocumentBodiesProducerCost.Value;
      end;
    end;
  end
  else begin

    //Если cпособ налогообложения ЕНВД и флаг "CalculateWithNDS" сброшен, то множитель = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      nonVitallyNDSMultiplier := 1
    else
      nonVitallyNDSMultiplier := (1 + NDSField.Value/100);

    //По цене производителя
    if CalculateOnProducerCost then begin
      Result := adsDocumentBodiesSupplierCost.Value + adsDocumentBodiesProducerCost.Value*nonVitallyNDSMultiplier*(markup/100);

      if cbClearRetailPrice.Checked and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        markup := ((Result - adsDocumentBodiesSupplierCost.Value)*100)/(adsDocumentBodiesProducerCost.Value * nonVitallyNDSMultiplier);
      end;
    end
    else begin
    //По цене поставщика без НДС
      Result := adsDocumentBodiesSupplierCost.Value + adsDocumentBodiesSupplierCostWithoutNDS.Value*nonVitallyNDSMultiplier*(markup/100);

      if cbClearRetailPrice.Checked and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        markup := ((Result - adsDocumentBodiesSupplierCost.Value)*100)/(adsDocumentBodiesSupplierCostWithoutNDS.Value * nonVitallyNDSMultiplier);
      end;
    end;
  end;
end;

procedure TDocumentBodiesForm.RetailMarkupGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if (Sender is TColumnEh) and (TColumnEh(Sender).Field = retailMarkupField)
    and retailMarkupField.IsNull
  then
    Params.ReadOnly := True;
end;

function TDocumentBodiesForm.CanCalculateRetailMarkup: Boolean;
begin
  if adsDocumentBodiesVitallyImportant.Value
  or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
  then begin
    //ЕНВД
    if (DM.adtClientsMethodOfTaxation.Value = 0) then
      Result := not adsDocumentBodiesSupplierCost.IsNull
    else
    //НДС
      Result := not adsDocumentBodiesSupplierCostWithoutNDS.IsNull;
  end
  else begin
    //По цене производителя
    if CalculateOnProducerCost then
      Result := not NDSField.IsNull and not adsDocumentBodiesSupplierCost.IsNull
    else
    //По цене поставщика без НДС
      Result := not adsDocumentBodiesSupplierCostWithoutNDS.IsNull and not NDSField.IsNull and not adsDocumentBodiesSupplierCost.IsNull;
  end;
end;

procedure TDocumentBodiesForm.GridColumnsClick(Sender: TObject);
var
  FColumnsForm : TfrmColumns;
begin
  FColumnsForm := TfrmColumns.Create(Self);
  try
    FColumnsForm.OwnerDBGrid := TToughDBGrid(dbgDocumentBodies);
    FColumnsForm.ShowModal;
  finally
    FColumnsForm.Free;
  end;
end;

procedure TDocumentBodiesForm.RealMarkupGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if (Sender is TColumnEh) and (TColumnEh(Sender).Field = realMarkupField)
  then
    if not retailMarkupField.IsNull and Params.ReadOnly then
      Params.ReadOnly := False;
end;

procedure TDocumentBodiesForm.RealMarkupUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  realMarkup,
  markup,
  price : Double;
begin
  if (adsDocumentBodies.State in [dsEdit]) and not retailMarkupField.IsNull
  then begin
    if StrToFloatDef(Value, 0.0) > 0 then begin
      realMarkup := Value;
      price := adsDocumentBodiesSupplierCost.Value * (1 + realMarkup/100);
      markup := GetRetailMarkupByPrice(price);
      if (price > 0) and (markup > 0) then begin
        manualCorrectionField.Value := True;
        retailMarkupField.AsVariant := markup;
        adsDocumentBodies.Post;
      end
      else
        adsDocumentBodies.Cancel;
    end;
    Handled := True;
  end;
end;

end.
