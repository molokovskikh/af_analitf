unit DocumentBodies;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, StdCtrls, DBCtrls, GridsEh, DBGridEh,
  ToughDBGrid, DB, MemDS, DBAccess, MyAccess, DModule, Registry, DocumentTypes,
  FR_DSet, FR_DBSet, Buttons, FR_Class;

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
    dbgDocumentBodies: TToughDBGrid;
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
    adsDocumentBodiesPositionName: TStringField;
    adsDocumentBodiesCode: TStringField;
    adsDocumentBodiesSeriesOfCertificates: TStringField;
    adsDocumentBodiesPeriod: TStringField;
    adsDocumentBodiesProducerName: TStringField;
    adsDocumentBodiesCountry: TStringField;
    adsDocumentBodiesProducerCost: TFloatField;
    adsDocumentBodiesGRCost: TFloatField;
    adsDocumentBodiesSupplierPriceMarkup: TFloatField;
    adsDocumentBodiesSupplierCostWithoutNDS: TFloatField;
    adsDocumentBodiesSupplierCost: TFloatField;
    adsDocumentBodiesQuantity: TLargeintField;
    frdsDocumentBodies: TfrDBDataSet;
    gbPrint: TGroupBox;
    cbPrintEmptyTickets: TCheckBox;
    spPrintTickets: TSpeedButton;
    adsDocumentHeadersLocalWriteTime: TDateTimeField;
    procedure dbgDocumentBodiesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormHide(Sender: TObject);
    procedure adsDocumentHeadersDocumentTypeGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure spPrintTicketsClick(Sender: TObject);
  private
    { Private declarations }
    FDocumentId : Int64;
    procedure SetParams;
    procedure PrepareGrid;
    procedure AddColumn(Grid : TToughDBGrid; ColumnName, Caption : String; DisplayFormat : String = '');
    procedure WaybillCalcFields(DataSet : TDataSet);
    procedure LoadFromRegistry();
  public
    { Public declarations }
    procedure ShowForm(DocumentId: Int64; ParentForm : TChildForm); overload; //reintroduce;
  end;

implementation

{$R *.dfm}

uses
  Main, StrUtils, AProc;

{ TDocumentBodiesForm }

procedure TDocumentBodiesForm.SetParams;
begin
  adsDocumentHeaders.Close;
  adsDocumentHeaders.ParamByName( 'TimeZoneBias').Value := AProc.TimeZoneBias;
  adsDocumentHeaders.ParamByName('DocumentId').Value := FDocumentId;
  adsDocumentHeaders.Open;
  adsDocumentBodies.Close;
  PrepareGrid;
  adsDocumentBodies.ParamByName('DocumentId').Value := FDocumentId;
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
begin
  if Key = VK_ESCAPE then
    if Assigned(PrevForm) then
        PrevForm.ShowAsPrevForm;
end;

procedure TDocumentBodiesForm.PrepareGrid;
var
  calc : TField;
begin
  dbgDocumentBodies.Columns.Clear();
  dbgDocumentBodies.ShowHint := True;
  if adsDocumentHeadersDocumentType.Value = 1 then begin
    adsDocumentBodies.OnCalcFields := WaybillCalcFields;
    if adsDocumentBodies.FindField('RetailPercent') = nil then begin
      calc := TCurrencyField.Create(adsDocumentBodies);
      calc.fieldname := 'RetailPercent';
      calc.FieldKind := fkCalculated;
      calc.Calculated := True;
      calc.Dataset := adsDocumentBodies;
    end;
    if adsDocumentBodies.FindField('RetailPrice') = nil then begin
      calc := TCurrencyField.Create(adsDocumentBodies);
      calc.fieldname := 'RetailPrice';
      calc.FieldKind := fkCalculated;
      calc.Calculated := True;
      calc.Dataset := adsDocumentBodies;
    end;
    if adsDocumentBodies.FindField('RetailSumm') = nil then begin
      calc := TCurrencyField.Create(adsDocumentBodies);
      calc.fieldname := 'RetailSumm';
      calc.FieldKind := fkCalculated;
      calc.Calculated := True;
      calc.Dataset := adsDocumentBodies;
    end;

    AddColumn(dbgDocumentBodies, 'PositionName', 'Наименование');
    AddColumn(dbgDocumentBodies, 'SeriesOfCertificates', 'Серии сертификатов');
    AddColumn(dbgDocumentBodies, 'Period', 'Срок годности');
    AddColumn(dbgDocumentBodies, 'ProducerName', 'Производитель');
    AddColumn(dbgDocumentBodies, 'Country', 'Страна');
    AddColumn(dbgDocumentBodies, 'ProducerCost', 'Цена производителя без НДС', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'GRCost', 'Цена ГР', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'SupplierPriceMarkup', 'Торговая надбавка оптовика', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'SupplierCostWithoutNDS', 'Цена поставщика без НДС', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'SupplierCost', 'Цена поставщика с НДС', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'RetailPercent', 'Розничная надбавка', '#');
    AddColumn(dbgDocumentBodies, 'RetailPrice', 'Розничная цена', '#');
    AddColumn(dbgDocumentBodies, 'Quantity', 'Заказ', '#');
    AddColumn(dbgDocumentBodies, 'RetailSumm', 'Розничная сумма', '#');
  end
  else begin
    adsDocumentBodies.OnCalcFields := nil;
    AddColumn(dbgDocumentBodies, 'PositionName', 'Наименование');
    AddColumn(dbgDocumentBodies, 'ProducerName', 'Производитель');
    AddColumn(dbgDocumentBodies, 'SupplierCost', 'Цена', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'Quantity', 'Заказ', '#');
  end;
  LoadFromRegistry();
end;

procedure TDocumentBodiesForm.AddColumn(Grid: TToughDBGrid; ColumnName,
  Caption, DisplayFormat: String);
var
  column : TColumnEh;
begin
  column := Grid.Columns.Add;
  column.FieldName := ColumnName;
  column.Title.Caption := Caption;
  column.Title.Hint := Caption;
  column.DisplayFormat := DisplayFormat;
end;

procedure TDocumentBodiesForm.WaybillCalcFields(DataSet: TDataSet);
begin
  try
    DataSet.FieldByName('RetailPercent').Value := DM.GetRetUpCost(adsDocumentBodiesSupplierCost.Value);
    DataSet.FieldByName('RetailPrice').Value := DM.GetPriceRet(adsDocumentBodiesSupplierCost.Value);
    DataSet.FieldByName('RetailSumm').Value := DataSet.FieldByName('RetailPrice').AsCurrency * adsDocumentBodiesQuantity.Value;
  except
  end;
end;

procedure TDocumentBodiesForm.FormHide(Sender: TObject);
var
  Reg: TRegIniFile;
begin
  inherited;
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' +
      IfThen(adsDocumentHeadersDocumentType.Value = 1, 'DetailWaybill', 'DetailReject'),
      True);
    try
      dbgDocumentBodies.SaveColumnsLayout(Reg);
    finally
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TDocumentBodiesForm.LoadFromRegistry;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' +
       IfThen(adsDocumentHeadersDocumentType.Value = 1, 'DetailWaybill', 'DetailReject'),
       False)
    then
      try
        dbgDocumentBodies.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
      finally
        Reg.CloseKey;
      end;
  finally
    Reg.Free;
  end;
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
  frVariables[ 'ShortClientName'] := DM.adtClientsNAME.AsString;
  frVariables[ 'ProviderDocumentId'] := adsDocumentHeadersProviderDocumentId.AsString;
  frVariables[ 'DocumentDate'] := DateToStr(adsDocumentHeadersLocalWriteTime.AsDateTime);
  frVariables[ 'TicketSignature'] := priceName;

  DM.ShowFastReport('Ticket.frf', adsDocumentBodies, True);
end;

end.
