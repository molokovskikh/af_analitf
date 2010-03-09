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
    cbClearRetailPrice: TCheckBox;
    spPrintReestr: TSpeedButton;
    cbWaybillAsVitallyImportant: TCheckBox;
    spEditMarkups: TSpeedButton;
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
  private
    { Private declarations }
    FDocumentId : Int64;
    procedure SetParams;
    procedure PrepareGrid;
    procedure AddColumn(Grid : TToughDBGrid; ColumnName, Caption : String; DisplayFormat : String = '');
    procedure WaybillCalcFields(DataSet : TDataSet);
    procedure LoadFromRegistry();
    procedure RefreshDocument;
    procedure WaybillGetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
  public
    { Public declarations }
    procedure ShowForm(DocumentId: Int64; ParentForm : TChildForm); overload; //reintroduce;
  end;

implementation

{$R *.dfm}

uses
  Main, StrUtils, AProc, Math, DBProc, sumprops, EditVitallyImportantMarkups;

{
  ����������� ������ RoundTo �������� �� ���������
  ������:
    1.23 -> 1.2
    1.29 -> 1.2
    1.2  -> 1.1
  �������� �� ����������, ����� � ������ 1.2 ���������� 1.2
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
  adsDocumentBodies.Open;
  Self.Caption := '����������� ' + RussianDocumentTypeForHeaderForm[TDocumentType(adsDocumentHeadersDocumentType.Value)];
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
begin
  dbgDocumentBodies.Columns.Clear();
  dbgDocumentBodies.ShowHint := True;
  if adsDocumentHeadersDocumentType.Value = 1 then begin
    adsDocumentBodies.OnCalcFields := WaybillCalcFields;
    dbgDocumentBodies.OnGetCellParams := WaybillGetCellParams;

    AddColumn(dbgDocumentBodies, 'PositionName', '������������');
    AddColumn(dbgDocumentBodies, 'SeriesOfCertificates', '����� ������������');
    AddColumn(dbgDocumentBodies, 'Period', '���� ��������');
    AddColumn(dbgDocumentBodies, 'ProducerName', '�������������');
    AddColumn(dbgDocumentBodies, 'Country', '������');
    AddColumn(dbgDocumentBodies, 'ProducerCost', '���� ������������� ��� ���', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'GRCost', '���� ��', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'SupplierPriceMarkup', '�������� �������� ��������', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'SupplierCostWithoutNDS', '���� ���������� ��� ���', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'SupplierCost', '���� ���������� � ���', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'RetailPercent', '��������� ��������', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'RetailPrice', '��������� ����', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'Quantity', '�����', '#');
    AddColumn(dbgDocumentBodies, 'RetailSumm', '��������� �����', '0.00;;''''');
  end
  else begin
    adsDocumentBodies.OnCalcFields := nil;
    dbgDocumentBodies.OnGetCellParams := nil;
    AddColumn(dbgDocumentBodies, 'PositionName', '������������');
    AddColumn(dbgDocumentBodies, 'ProducerName', '�������������');
    AddColumn(dbgDocumentBodies, 'SupplierCost', '����', '0.00;;''''');
    AddColumn(dbgDocumentBodies, 'Quantity', '�����', '#');
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
var
  upcost,
  vitallyImportantMarkup,
  retailPrice : Currency;
begin
  try
    upcost := DM.GetRetUpCost(adsDocumentBodiesSupplierCost.Value);

    if cbWaybillAsVitallyImportant.Checked then begin
      vitallyImportantMarkup := DM.GetVitallyImportantMarkup(adsDocumentBodiesProducerCost.Value);
      if upcost + adsDocumentBodiesSupplierPriceMarkup.Value > vitallyImportantMarkup then
        upcost := vitallyImportantMarkup - adsDocumentBodiesSupplierPriceMarkup.Value;
    end;

    retailPrice := (1 + upcost/100)*adsDocumentBodiesSupplierCost.Value;

    if cbClearRetailPrice.Checked then begin
      retailPrice := RoundToOneDigit(retailPrice);
      upcost := (retailPrice/adsDocumentBodiesSupplierCost.Value-1)*100;
    end;

    DataSet.FieldByName('RetailPercent').Value := upcost;

    DataSet.FieldByName('RetailPrice').Value := retailPrice;
    DataSet.FieldByName('RetailSumm').Value := retailPrice * adsDocumentBodiesQuantity.Value;

    DataSet.FieldByName('SupplierNDS').Value := (adsDocumentBodiesSupplierCost.Value/adsDocumentBodiesSupplierCostWithoutNDS.Value-1)*100;
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
  frVariables[ 'ClientName'] := DM.GetClientNameAndAddress;
  frVariables[ 'ProviderDocumentId'] := adsDocumentHeadersProviderDocumentId.AsString;
  frVariables[ 'DocumentDate'] := DateToStr(adsDocumentHeadersLocalWriteTime.AsDateTime);
  frVariables[ 'TicketSignature'] := priceName;

  DM.ShowFastReport('Ticket.frf', adsDocumentBodies, True);
end;

procedure TDocumentBodiesForm.FormCreate(Sender: TObject);
var
  calc : TField;
begin
  //��������� ����������� ���� � �������
  if adsDocumentBodies.FindField('SupplierNDS') = nil then begin
    calc := TCurrencyField.Create(adsDocumentBodies);
    calc.fieldname := 'SupplierNDS';
    calc.FieldKind := fkCalculated;
    calc.Calculated := True;
    calc.Dataset := adsDocumentBodies;
  end;
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

  inherited;
end;

procedure TDocumentBodiesForm.cbPrintEmptyTicketsClick(Sender: TObject);
begin
  dbgDocumentBodies.SetFocus();
end;

procedure TDocumentBodiesForm.cbClearRetailPriceClick(Sender: TObject);
begin
  RefreshDocument;
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

procedure TDocumentBodiesForm.RefreshDocument;
var
  LastId : Int64;
begin
  dbgDocumentBodies.SetFocus();
  adsDocumentBodies.DisableControls;
  try
    LastId := adsDocumentBodiesId.Value;
    adsDocumentBodies.Refresh;
    if not adsDocumentBodies.Locate('Id', LastId, []) then
      adsDocumentBodies.First;
  finally
    adsDocumentBodies.EnableControls;
  end;
end;

procedure TDocumentBodiesForm.cbWaybillAsVitallyImportantClick(
  Sender: TObject);
begin
  if cbWaybillAsVitallyImportant.Checked then
    if not DM.VitallyImportantMarkupsExists then begin
      ShowEditVitallyImportantMarkups;
      cbWaybillAsVitallyImportant.Checked := DM.VitallyImportantMarkupsExists;
      if cbWaybillAsVitallyImportant.Checked then
        RefreshDocument;
    end
    else
      RefreshDocument
  else
    RefreshDocument
end;

procedure TDocumentBodiesForm.WaybillGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if (adsDocumentBodies.FieldByName('RetailPercent').AsCurrency < 0) then
    if AnsiMatchText(Column.Field.FieldName, ['RetailPercent', 'RetailPrice', 'RetailSumm'])
    then
      Background := clRed;
end;

procedure TDocumentBodiesForm.spEditMarkupsClick(Sender: TObject);
begin
  ShowEditVitallyImportantMarkups;
  if cbWaybillAsVitallyImportant.Checked then
    RefreshDocument;
end;

end.
