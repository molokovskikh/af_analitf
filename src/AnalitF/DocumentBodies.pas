unit DocumentBodies;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, StdCtrls, DBCtrls, GridsEh, DBGridEh,
  ToughDBGrid, DB, MemDS, DBAccess, MyAccess, DModule, DocumentTypes,
  FR_DSet, FR_DBSet, Buttons, FR_Class,
  Menus,
  U_frameBaseLegend;

const
  NDSNullValue = '��� ��������';
  
type
  TDocumentBodiesForm = class(TChildForm)
    pOrderHeader: TPanel;
    dbtProviderName: TDBText;
    Label1: TLabel;
    dbtId: TDBText;
    Label2: TLabel;
    dbtOrderDate: TDBText;
    lblRecordCount: TLabel;
    dbtPositions: TDBText;
    Label4: TLabel;
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
    sbPrintTickets: TSpeedButton;
    adsDocumentHeadersLocalWriteTime: TDateTimeField;
    cbClearRetailPrice: TCheckBox;
    sbPrintReestr: TSpeedButton;
    cbWaybillAsVitallyImportant: TCheckBox;
    adsDocumentBodiesQuantity: TIntegerField;
    sbEditAddress: TSpeedButton;
    adsDocumentBodiesVitallyImportant: TBooleanField;
    tmrPrintedChange: TTimer;
    adsDocumentBodiesSerialNumber: TStringField;
    sbPrintWaybill: TSpeedButton;
    sbPrintInvoice: TSpeedButton;
    sbEditTicketReportParams: TSpeedButton;
    sbPrintRackCard: TSpeedButton;
    sbEditRackCardParams: TSpeedButton;
    sbReestrToExcel: TSpeedButton;
    lProviderDocumentId: TLabel;
    dbtProviderDocumentId: TDBText;
    sbWaybillToExcel: TSpeedButton;
    adsDocumentBodiesPrinted: TBooleanField;
    adsDocumentBodiesAmount: TFloatField;
    adsDocumentBodiesNdsAmount: TFloatField;
    lNDS: TLabel;
    cbNDS: TComboBox;
    procedure dbgDocumentBodiesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormHide(Sender: TObject);
    procedure adsDocumentHeadersDocumentTypeGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure sbPrintTicketsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbClearRetailPriceClick(Sender: TObject);
    procedure sbPrintReestrClick(Sender: TObject);
    procedure cbWaybillAsVitallyImportantClick(Sender: TObject);
    procedure sbEditAddressClick(Sender: TObject);
    procedure tmrPrintedChangeTimer(Sender: TObject);
    procedure dbgDocumentBodiesSortMarkingChanged(Sender: TObject);
    procedure sbPrintWaybillClick(Sender: TObject);
    procedure sbPrintInvoiceClick(Sender: TObject);
    procedure sbEditTicketReportParamsClick(Sender: TObject);
    procedure sbEditRackCardParamsClick(Sender: TObject);
    procedure sbReestrToExcelClick(Sender: TObject);
    procedure sbPrintRackCardClick(Sender: TObject);
    procedure sbWaybillToExcelClick(Sender: TObject);
    procedure adsDocumentBodiesPrintedChange(Sender: TField);
    procedure cbNDSSelect(Sender: TObject);
  private
    { Private declarations }
    FDocumentId : Int64;
    CalculateOnProducerCost : Boolean;
    retailPriceField : TFloatField;
    retailMarkupField : TFloatField;
    manualCorrectionField : TBooleanField;
    NDSField : TIntegerField;
    retailSummField : TCurrencyField;
    retailAmountField : TFloatField;
    maxRetailMarkupField : TCurrencyField;
    realMarkupField : TFloatField;
    manualRetailPriceField : TFloatField;

    FGridPopup : TPopupMenu;
    FGridColumns : TMenuItem;

    NeedLog,
    NeedCalcFieldsLog : Boolean;

    legeng : TframeBaseLegend;

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

    //������ ��� ������� ��������� ������� � ���
    //�������� ���� �� �������, �� ����� ���������� ���� �������
    function GetRetailPriceByMarkup(var markup : Double) : Double;
    //�������� ������� �� ����
    function GetRetailMarkupByPrice(price : Double) : Double;
    //����� �� �� ���������� ��������� �������, ����������� �� ���������� ������
    function CanCalculateRetailMarkup : Boolean;

    procedure GridColumnsClick( Sender: TObject);

    function GetMinProducerCost() : Double;

    procedure SetButtonPositions;
    procedure OnResizeForm(Sender: TObject);
    function  NeedReplaceButtons : Boolean;
    function GetTotalSupplierSumm() : Double;
    procedure DoActionOnPrinted(Action : TThreadMethod);
    procedure WaybillToExcel();
    procedure PrintRackCard();
    procedure ReestrToExcel();
    procedure PrintInvoice();
    procedure PrintWaybill();
    procedure PrintReestr();
    procedure PrintTickets();
    procedure CreateLegenPanel;
    procedure FillNDSFilter();
    procedure AddNDSFilter();
  public
    { Public declarations }
    procedure ShowForm(DocumentId: Int64; ParentForm : TChildForm); overload; //reintroduce;
    procedure ForceRecalcDocument(DocumentId: Int64);
  end;

implementation

{$R *.dfm}

uses
  Main, StrUtils, AProc, Math, DBProc, sumprops, EditVitallyImportantMarkups,
  EditAddressForm, Constant, DBGridHelper,
  ToughDBGridColumns,
  U_ExchangeLog,
  LU_Tracer,
  EditTicketReportParams,
  TicketReportParams,
  RackCardReportParams,
  EditRackCardReportParams,
  ShellAPI,
  LU_TDataExportAsXls;

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
  adsDocumentHeaders.ParamByName('DocumentId').Value := FDocumentId;
  adsDocumentHeaders.Open;
  adsDocumentBodies.Close;
  adsDocumentBodies.RestoreSQL;
  PrepareGrid;
  gbPrint.Visible := adsDocumentHeadersDocumentType.Value = 1;
  adsDocumentBodies.ParamByName('DocumentId').Value := FDocumentId;
  if adsDocumentHeadersDocumentType.Value = 1 then begin
    FillNDSFilter();
    RecalcDocument();
  end
  else
    adsDocumentBodies.Open;
  Self.Caption := '����������� ' + RussianDocumentTypeForHeaderForm[TDocumentType(adsDocumentHeadersDocumentType.Value)];
end;

procedure TDocumentBodiesForm.ShowForm(DocumentId: Int64;
  ParentForm: TChildForm);
begin
  Self.OnResize := nil;
  FDocumentId := DocumentId;
  SetParams;
  inherited ShowForm;
  if adsDocumentHeadersDocumentType.Value = 1 then begin
    SetButtonPositions;
    Self.OnResize := OnResizeForm;
  end;
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
      //� ����� � ��������� �� TDBGridEh ��� ��� �� �����
      dbgDocumentBodies.EditorMode := False;
      if adsDocumentBodies.State in [dsEdit, dsInsert] then begin
        //���� �� � ��������� dsEdit, �� �� ������������� ���� �� ��������� �����:
        //��������� ������� ��� ��������� ����, �� ������ ���� ��������� ManualCorrection
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
      //� ����� � ��������� �� TDBGridEh ��� ��� �� �����
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
  dbgDocumentBodies.MinAutoFitWidth := DBGridColumnMinWidth;
  dbgDocumentBodies.Flat := True;
  dbgDocumentBodies.Options := dbgDocumentBodies.Options + [dgRowLines];
  dbgDocumentBodies.Font.Size := 10;
  dbgDocumentBodies.GridLineColors.DarkColor := clBlack;
  dbgDocumentBodies.GridLineColors.BrightColor := clDkGray;
  dbgDocumentBodies.AllowedSelections := [gstRecordBookmarks, gstRectangle];
  if CheckWin32Version(5, 1) then
    dbgDocumentBodies.OptionsEh := dbgDocumentBodies.OptionsEh + [dghTraceColSizing];

  dbgDocumentBodies.SelectedField := nil;
  dbgDocumentBodies.Columns.Clear();
  dbgDocumentBodies.ShowHint := True;
  if adsDocumentHeadersDocumentType.Value = 1 then begin
    legeng.Visible := True;
    adsDocumentBodies.OnCalcFields := WaybillCalcFields;
    dbgDocumentBodies.OnGetCellParams := WaybillGetCellParams;
    dbgDocumentBodies.OnKeyPress := WaybillKeyPress;
    dbgDocumentBodies.ReadOnly := True;

    dbgDocumentBodies.AutoFitColWidths := False;
    try
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Product', '������������', 0);
      column := TDBGridHelper.AddColumn(dbgDocumentBodies, 'Printed', '��������', dbgDocumentBodies.Canvas.TextWidth('��������'), False);
      column.Checkboxes := True;
      column := TDBGridHelper.AddColumn(dbgDocumentBodies, 'Certificates', '����� �����������', 0);
      column.Visible := False;
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'SerialNumber', '����� ������', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Period', '���� ��������', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Producer', '�������������', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Country', '������', 0);
      //TDBGridHelper.AddColumn(dbgDocumentBodies, 'VitallyImportant', '������� �����', 0, False);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'ProducerCost', '���� ������������� ��� ���', dbgDocumentBodies.Canvas.TextWidth('99999.99'), False);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'RegistryCost', '���� ��', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'SupplierPriceMarkup', '�������� ������� ��������', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'SupplierCostWithoutNDS', '���� ���������� ��� ���', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'NDS', '���', dbgDocumentBodies.Canvas.TextWidth('999'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'SupplierCost', '���� ���������� � ���', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'MaxRetailMarkup', '����. ��������� �������', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      column := TDBGridHelper.AddColumn(dbgDocumentBodies, 'RetailMarkup', '��������� �������', dbgDocumentBodies.Canvas.TextWidth('99999.99'), False);
      column.OnUpdateData := RetailMarkupUpdateData;
      column.OnGetCellParams := RetailMarkupGetCellParams;
      column := TDBGridHelper.AddColumn(dbgDocumentBodies, 'RealMarkup', '�������� �������', dbgDocumentBodies.Canvas.TextWidth('99999.99'), False);
      column.OnUpdateData := RealMarkupUpdateData;
      column.OnGetCellParams := RealMarkupGetCellParams;
      column := TDBGridHelper.AddColumn(dbgDocumentBodies, 'RetailPrice', '��������� ����', dbgDocumentBodies.Canvas.TextWidth('99999.99'), False);
      column.OnUpdateData := RetailPriceUpdateData;
      column.OnGetCellParams := RetailPriceGetCellParams;
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Quantity', '�����', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'RetailSumm', '��������� �����', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
    finally
      dbgDocumentBodies.AutoFitColWidths := True;
    end;
    dbgDocumentBodies.ReadOnly := False;
    dbgDocumentBodies.Options := dbgDocumentBodies.Options + [dgEditing];
    dbgDocumentBodies.SelectedField := retailMarkupField;
  end
  else begin
    legeng.Visible := False;
    adsDocumentBodies.OnCalcFields := nil;
    dbgDocumentBodies.OnGetCellParams := nil;
    dbgDocumentBodies.OnKeyPress := nil;
    dbgDocumentBodies.Options := dbgDocumentBodies.Options - [dgEditing];
    dbgDocumentBodies.AutoFitColWidths := False;
    dbgDocumentBodies.ReadOnly := True;
    try
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Product', '������������', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Producer', '�������������', 0);
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'SupplierCost', '����', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
      TDBGridHelper.AddColumn(dbgDocumentBodies, 'Quantity', '�����', dbgDocumentBodies.Canvas.TextWidth('99999.99'));
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
  if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '������ �������� �������: ' + adsDocumentBodiesId.AsString);
  try
    if not adsDocumentBodiesProducerCost.IsNull then begin
      if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '���� �������������: ' + adsDocumentBodiesProducerCost.AsString);
      if adsDocumentBodiesVitallyImportant.Value
      or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
      then begin
        if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '������������ ������� ����� �� �����');
        if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', 'GetMinProducerCost: ' + FloatToStr(GetMinProducerCost()));
        maxMarkup := DM.GetMaxVitallyImportantMarkup(GetMinProducerCost())
      end
      else begin
        if CalculateOnProducerCost then begin
          if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '������������ ������� ����� �� ��-����� ������������ ProducerCost');
          maxMarkup := DM.GetMaxRetailMarkup(adsDocumentBodiesProducerCost.Value)
        end
        else begin
          if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '������������ ������� ����� �� ��-����� ������������ SupplierCostWithoutNDS');
          if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', 'SupplierCostWithoutNDS: ' + adsDocumentBodiesSupplierCostWithoutNDS.AsString);
          maxMarkup := DM.GetMaxRetailMarkup(adsDocumentBodiesSupplierCostWithoutNDS.Value);
        end;
      end;
      maxRetailMarkupField.Value := maxMarkup;
      if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '������������ ��������� �������: ' + maxRetailMarkupField.AsString);
    end
    else
      if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '���� �������������: null');

    if not retailMarkupField.IsNull then begin
      if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '��������� �������: ' + retailMarkupField.AsString);
      markup := retailMarkupField.Value;
      price := GetRetailPriceByMarkup(markup);
      retailPriceField.Value := price;
      retailSummField.Value := RoundTo(price, -2) * adsDocumentBodiesQuantity.Value;
      realMarkupField.Value := ((price - adsDocumentBodiesSupplierCost.Value) * 100)/ adsDocumentBodiesSupplierCost.Value;
      if NeedLog and NeedCalcFieldsLog then
        Tracer.TR('WaybillCalcFields',
          Format(
            '��������� ����: %s  ' +
            '��������� �����: %s  ' +
            '�������� �������: %s  ',
            [retailPriceField.AsString,
             retailSummField.AsString,
             realMarkupField.AsString]));
    end
    else begin
      if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '��������� �������: null');
      if not manualRetailPriceField.IsNull then begin
        if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '��������� ���� ������� �������: ' + manualRetailPriceField.AsString);
        price := manualRetailPriceField.Value;
        retailPriceField.Value := price;
        retailSummField.Value := RoundTo(price, -2) * adsDocumentBodiesQuantity.Value;
      end;
    end;

  except
    on E : Exception do
      WriteExchangeLog('TDocumentBodiesForm.WaybillCalcFields', '������: ' + E.Message);
  end;
  if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '��������� �������� �������: ' + adsDocumentBodiesId.AsString);
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
  TDBGridHelper.SetTitleButtonToColumns(dbgDocumentBodies);
  TDBGridHelper.RestoreColumnsLayout(
    dbgDocumentBodies,
    IfThen(adsDocumentHeadersDocumentType.Value = 1, 'DetailWaybill', 'DetailReject'));
  MyDacDataSetSortMarkingChanged( TToughDBGrid(dbgDocumentBodies) );
end;

procedure TDocumentBodiesForm.adsDocumentHeadersDocumentTypeGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if DisplayText then
    Text := RussianDocumentType[TDocumentType(Sender.AsInteger)];
end;

procedure TDocumentBodiesForm.sbPrintTicketsClick(Sender: TObject);
begin
  DoActionOnPrinted(PrintTickets);
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
  NeedLog := FindCmdLineSwitch('extd');
  //�������� �������
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

  manualRetailPriceField := TFloatField(adsDocumentBodies.FindField('ManualRetailPrice'));
  if not Assigned(manualRetailPriceField) then begin
    manualRetailPriceField := TFloatField.Create(adsDocumentBodies);
    manualRetailPriceField.FieldName := 'ManualRetailPrice';
    manualRetailPriceField.DisplayFormat := '0.00;;';
    manualRetailPriceField.DataSet := adsDocumentBodies;
  end;
  retailAmountField := TFloatField(adsDocumentBodies.FindField('RetailAmount'));
  if not Assigned(retailAmountField) then begin
    retailAmountField := TFloatField.Create(adsDocumentBodies);
    retailAmountField.FieldName := 'RetailAmount';
    retailAmountField.DisplayFormat := '0.00;;';
    retailAmountField.DataSet := adsDocumentBodies;
  end;


  SetDisplayFormat(
  [
    'ProducerCost',
    'RegistryCost',
    'SupplierPriceMarkup',
    'SupplierCostWithoutNDS',
    'SupplierCost'
  ]);

  //��������� ����������� ���� � �������
  retailSummField := AddField('RetailSumm');
  maxRetailMarkupField := AddField('MaxRetailMarkup');
  retailPriceField := AddFloatField('RetailPrice');
  realMarkupField := AddFloatField('RealMarkup');

  FGridPopup := TPopupMenu.Create( Self);
  dbgDocumentBodies.PopupMenu := FGridPopup;
  FGridColumns := TMenuItem.Create(FGridPopup);
  FGridColumns.Caption := '�������...';
  FGridColumns.OnClick := GridColumnsClick;
  FGridPopup.Items.Add(FGridColumns);

  CreateLegenPanel();

  inherited;
end;

procedure TDocumentBodiesForm.cbClearRetailPriceClick(Sender: TObject);
begin
  dbgDocumentBodies.SetFocus();
  RecalcDocument;
end;

procedure TDocumentBodiesForm.sbPrintReestrClick(Sender: TObject);
begin
  DoActionOnPrinted(PrintReestr);
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
var
  maxSupplierMarkup : Currency;
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

  if not retailMarkupField.IsNull and (Column.Field = adsDocumentBodiesSupplierPriceMarkup) then
  begin
    if adsDocumentBodiesVitallyImportant.Value
    or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
    then
      maxSupplierMarkup := DM.GetMaxVitallyImportantSupplierMarkup(GetMinProducerCost())
    else begin
      if CalculateOnProducerCost then
        maxSupplierMarkup := DM.GetMaxRetailSupplierMarkup(adsDocumentBodiesProducerCost.Value)
      else
        maxSupplierMarkup := DM.GetMaxRetailSupplierMarkup(adsDocumentBodiesSupplierCostWithoutNDS.Value);
    end;
    if adsDocumentBodiesSupplierPriceMarkup.Value > maxSupplierMarkup then
      Background := clRed;
  end;

  if (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
    or (not adsDocumentBodiesVitallyImportant.IsNull and adsDocumentBodiesVitallyImportant.AsBoolean)
  then begin
    AFont.Color := VITALLYIMPORTANT_CLR;
    if (Column.Field = NDSField) and not NDSField.IsNull and (NDSField.Value <> 10)
    then
      Background := clRed;
  end;
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
    //���� ��� �������� �����������, �.�. �� ����� ������������� ��������-�������� � �������
//    if not manualCorrectionField.Value then
//      RecalcPosition;
//    //��-������� ������ �������� �� �������. �������� ������, ����� �� � ������� ����
//    //�������� ���������� dataset
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
  RecalcCount : Integer;
  blockedWaybillAsVitallyImportant : Boolean;
  LastSort : String;
begin
  //retailPriceField.OnChange := nil;
  //retailMarkupField.OnChange := nil;
  //adsDocumentBodiesVitallyImportant.OnChange := nil;
  if NeedLog then Tracer.TR('RecalcDocument', '������ ������ ���������: ' + adsDocumentBodiesDocumentId.AsString);
  blockedWaybillAsVitallyImportant := False;
  RecalcCount := 0;
  adsDocumentBodies.DisableControls;
  try
    LastId := adsDocumentBodiesId.Value;
    LastSort := adsDocumentBodies.IndexFieldNames;
    adsDocumentBodies.IndexFieldNames := '';
    adsDocumentBodies.Close;
    adsDocumentBodies.RestoreSQL;
    AddNDSFilter();
    adsDocumentBodies.Open;
    adsDocumentBodies.First;
    while not adsDocumentBodies.Eof do begin
      if not adsDocumentBodiesVitallyImportant.IsNull then
        blockedWaybillAsVitallyImportant := True;
      adsDocumentBodies.Edit;
      RecalcPosition;
      adsDocumentBodies.Post;
      adsDocumentBodies.Next;
      Inc(RecalcCount);
    end;

    if LastSort <> '' then
      adsDocumentBodies.IndexFieldNames := LastSort;
    if not adsDocumentBodies.Locate('Id', LastId, []) then
      adsDocumentBodies.First;

    cbWaybillAsVitallyImportant.Enabled := not blockedWaybillAsVitallyImportant;

    DBProc.UpdateValue(
        DM.MainConnection,
        'update DocumentHeaders set RetailAmountCalculated = 1 where Id = :Id',
        ['Id'],
        [FDocumentId]);
  finally
    adsDocumentBodies.EnableControls;
    if NeedLog then Tracer.TR('RecalcDocument',
      '��������� ������ ���������: ' + IntToStr(RecalcCount));
    //retailPriceField.OnChange := FieldOnChange;
    //retailMarkupField.OnChange := FieldOnChange;
    //adsDocumentBodiesVitallyImportant.OnChange := FieldOnChange;
  end;
end;

procedure TDocumentBodiesForm.RecalcPosition;
var
  upCostVariant : Variant;
  upcost : Double;
  retailPrice : Double;
begin
  if NeedLog then Tracer.TR('RecalcPosition', '������ ������ �������: ' + adsDocumentBodiesId.AsString);
  upCostVariant := Null;
  if not manualCorrectionField.Value then begin

    if NeedLog then Tracer.TR('RecalcPosition', '������� ��� ������ �������������');
    if NeedLog then Tracer.TR('RecalcPosition', 'ProducerCost: '  + adsDocumentBodiesProducerCost.AsString);
    if adsDocumentBodiesVitallyImportant.Value
    or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
    then begin
      if not adsDocumentBodiesProducerCost.IsNull and (adsDocumentBodiesProducerCost.Value > 0)
      then begin
        if NeedLog then Tracer.TR('RecalcPosition', '��������� ������� ����� �� �����');
        if NeedLog then Tracer.TR('RecalcPosition', 'GetMinProducerCost: ' + FloatToStr(GetMinProducerCost()));
        upCostVariant := DM.GetVitallyImportantMarkup(GetMinProducerCost());
      end
    end
    else begin
      if CalculateOnProducerCost then begin
        if not adsDocumentBodiesProducerCost.IsNull and (adsDocumentBodiesProducerCost.Value > 0)
        then begin
          if NeedLog then Tracer.TR('RecalcPosition', '��������� ������� ����� �� ��-����� ������������ ProducerCost');
          upCostVariant := DM.GetRetUpCost(adsDocumentBodiesProducerCost.Value);
        end
      end
      else begin
       if NeedLog then Tracer.TR('RecalcPosition', 'SupplierCostWithoutNDS: '  + adsDocumentBodiesSupplierCostWithoutNDS.AsString);
        if not adsDocumentBodiesSupplierCostWithoutNDS.IsNull
           and (adsDocumentBodiesSupplierCostWithoutNDS.Value > 0)
        then begin
          if NeedLog then Tracer.TR('RecalcPosition', '��������� ������� ����� �� ��-����� ������������ SupplierCostWithoutNDS');
          upCostVariant := DM.GetRetUpCost(adsDocumentBodiesSupplierCostWithoutNDS.Value);
        end
      end;
    end;

    if NeedLog then Tracer.TR('RecalcPosition', '��������� �������: ' + VarToStr(upCostVariant));
  end
  else begin
    if NeedLog then Tracer.TR('RecalcPosition', '������� � ������ ��������������');
    if NeedLog then Tracer.TR('RecalcPosition', '��������� �������: ' + retailMarkupField.AsString);
    upCostVariant := retailMarkupField.AsVariant;
  end;

  if not VarIsNull(upCostVariant) then begin
    if NeedLog then Tracer.TR('RecalcPosition', '��������� ������� �� �����');
    if CanCalculateRetailMarkup() then begin
      if NeedLog then Tracer.TR('RecalcPosition', '��������� ������� ���������� �����');
      upcost := upCostVariant;
      retailPrice := GetRetailPriceByMarkup(upcost);
      retailAmountField.Value := RoundTo(retailPrice, -2) * adsDocumentBodiesQuantity.Value;
      if NeedLog then NeedCalcFieldsLog := True;
      try
        retailMarkupField.Value := upcost;
      finally
        if NeedCalcFieldsLog then
          NeedCalcFieldsLog := False;
      end
    end
    else begin
      if NeedLog then Tracer.TR('RecalcPosition', '��������� ������� ���������� ������');
      //���� �� ����� ����������, �� ���� ���������� �������
      if NeedLog then NeedCalcFieldsLog := True;
      try
        retailMarkupField.Clear;
      finally
        if NeedCalcFieldsLog then
          NeedCalcFieldsLog := False;
      end
    end;
  end;
  if NeedLog then Tracer.TR('RecalcPosition', '��������� ������ �������: ' + adsDocumentBodiesId.AsString);
end;

procedure TDocumentBodiesForm.tmrPrintedChangeTimer(
  Sender: TObject);
begin
  try
    SoftPost( adsDocumentBodies );
  finally
    tmrPrintedChange.Enabled := False;
  end;
end;

procedure TDocumentBodiesForm.RetailPriceUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  markup,
  price : Double;
begin
  if (adsDocumentBodies.State in [dsEdit]) then begin
    if not retailMarkupField.IsNull then begin
      if StrToFloatDef(Value, 0.0) > 0 then begin
        price := Value;
        markup := GetRetailMarkupByPrice(price);
        if (price > 0) and (markup > 0) then begin
          manualCorrectionField.Value := True;
          retailMarkupField.AsVariant := markup;
          retailAmountField.Value := RoundTo(GetRetailPriceByMarkup(markup), -2) * adsDocumentBodiesQuantity.Value;
          adsDocumentBodies.Post;
        end
        else
          adsDocumentBodies.Cancel;
      end;
      Handled := True;
    end
    else begin
      if StrToFloatDef(Value, 0.0) > 0 then begin
        price := Value;
        if (price > 0) then begin
          manualCorrectionField.Value := True;
          manualRetailPriceField.Value := price;
          retailAmountField.Value := RoundTo(manualRetailPriceField.Value, -2) * adsDocumentBodiesQuantity.Value;
          adsDocumentBodies.Post;
        end
        else
          adsDocumentBodies.Cancel;
      end;
      Handled := True;
    end;
  end;
end;

procedure TDocumentBodiesForm.WaybillKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (dbgDocumentBodies.SelectedField = retailPriceField)
    or (dbgDocumentBodies.SelectedField = retailMarkupField)
    or (dbgDocumentBodies.SelectedField = realMarkupField)
  then begin
    if (Key in ['.', ',']) and (Key <> DecimalSeparator) then
      Key := DecimalSeparator;
  end;
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
        retailAmountField.Value := RoundTo(GetRetailPriceByMarkup(markup), -2) * adsDocumentBodiesQuantity.Value;
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
      Params.ReadOnly := False
    else
      if Params.ReadOnly then
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

    //���� c����� ��������������� ���� � ���� "CalculateWithNDS" �������, �� ��������� = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      vitallyNDSMultiplier := 1
    else
      vitallyNDSMultiplier := (1 + vitallyNDS/100);

    //����
    if (DM.adtClientsMethodOfTaxation.Value = 0) then

      Result := ((price - adsDocumentBodiesSupplierCost.Value)*100)/(GetMinProducerCost() * vitallyNDSMultiplier)

    else
    //���

      Result := ((price/vitallyNDSMultiplier - adsDocumentBodiesSupplierCostWithoutNDS.Value) *100) / GetMinProducerCost();

  end
  else begin

    //���� c����� ��������������� ���� � ���� "CalculateWithNDS" �������, �� ��������� = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      nonVitallyNDSMultiplier := 1
    else
      nonVitallyNDSMultiplier := (1 + NDSField.Value/100);

    //�� ���� �������������
    if CalculateOnProducerCost then
      Result := ((price - adsDocumentBodiesSupplierCost.Value)*100)/(adsDocumentBodiesProducerCost.Value * nonVitallyNDSMultiplier)
    else
    //�� ���� ���������� ��� ���
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

    //���� c����� ��������������� ���� � ���� "CalculateWithNDS" �������, �� ��������� = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      vitallyNDSMultiplier := 1
    else
      vitallyNDSMultiplier := (1 + vitallyNDS/100);

    //����
    if (DM.adtClientsMethodOfTaxation.Value = 0) then begin
      Result := adsDocumentBodiesSupplierCost.Value + GetMinProducerCost()*vitallyNDSMultiplier*(markup/100);

      if cbClearRetailPrice.Checked and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        //markup := ((Result - adsDocumentBodiesSupplierCost.Value) / adsDocumentBodiesProducerCost.Value)*100;
        markup := ((Result - adsDocumentBodiesSupplierCost.Value)*100)/(GetMinProducerCost() * vitallyNDSMultiplier)
      end;

    end
    else begin
    //���
      Result := (adsDocumentBodiesSupplierCostWithoutNDS.Value + GetMinProducerCost()*(markup/100)) * vitallyNDSMultiplier;

      if cbClearRetailPrice.Checked and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        //markup := ((Result/1.1 - adsDocumentBodiesSupplierCostWithoutNDS.Value) / adsDocumentBodiesProducerCost.Value)*100;
        markup := ((Result/vitallyNDSMultiplier - adsDocumentBodiesSupplierCostWithoutNDS.Value) *100) / GetMinProducerCost();
      end;
    end;
  end
  else begin

    //���� c����� ��������������� ���� � ���� "CalculateWithNDS" �������, �� ��������� = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      nonVitallyNDSMultiplier := 1
    else
      nonVitallyNDSMultiplier := (1 + NDSField.Value/100);

    //�� ���� �������������
    if CalculateOnProducerCost then begin
      Result := adsDocumentBodiesSupplierCost.Value + adsDocumentBodiesProducerCost.Value*nonVitallyNDSMultiplier*(markup/100);

      if cbClearRetailPrice.Checked and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        markup := ((Result - adsDocumentBodiesSupplierCost.Value)*100)/(adsDocumentBodiesProducerCost.Value * nonVitallyNDSMultiplier);
      end;
    end
    else begin
    //�� ���� ���������� ��� ���
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
    //����
    if (DM.adtClientsMethodOfTaxation.Value = 0) then begin
      Result :=
            not adsDocumentBodiesSupplierCost.IsNull
        and (adsDocumentBodiesSupplierCost.Value > 0);
     if NeedLog then Tracer.TR('CanCalculateRetailMarkup', '����� ����: ' + BoolToStr(Result, True));
    end
    else begin
    //���
      Result :=
            not adsDocumentBodiesSupplierCostWithoutNDS.IsNull
        and (adsDocumentBodiesSupplierCostWithoutNDS.Value > 0);
     if NeedLog then Tracer.TR('CanCalculateRetailMarkup', '����� ���: ' + BoolToStr(Result, True));
    end
  end
  else begin
    //�� ���� �������������
    if CalculateOnProducerCost then begin
      Result :=
            not NDSField.IsNull
        and not adsDocumentBodiesSupplierCost.IsNull
        and (adsDocumentBodiesSupplierCost.Value > 0);
     if NeedLog then Tracer.TR('CanCalculateRetailMarkup', '��-����� ProducerCost: ' + BoolToStr(Result, True));
    end
    else begin
    //�� ���� ���������� ��� ���
      Result :=
            not adsDocumentBodiesSupplierCostWithoutNDS.IsNull
        and not NDSField.IsNull
        and not adsDocumentBodiesSupplierCost.IsNull
        and (adsDocumentBodiesSupplierCost.Value > 0)
        and (adsDocumentBodiesSupplierCostWithoutNDS.Value > 0);
     if NeedLog then Tracer.TR('CanCalculateRetailMarkup', '��-����� SupplierCostWithoutNDS: ' + BoolToStr(Result, True));
    end
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
        retailAmountField.Value := RoundTo(GetRetailPriceByMarkup(markup), -2) * adsDocumentBodiesQuantity.Value;
        adsDocumentBodies.Post;
      end
      else
        adsDocumentBodies.Cancel;
    end;
    Handled := True;
  end;
end;

procedure TDocumentBodiesForm.dbgDocumentBodiesSortMarkingChanged(
  Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TDocumentBodiesForm.sbPrintWaybillClick(Sender: TObject);
begin
  DoActionOnPrinted(PrintWaybill);
end;

procedure TDocumentBodiesForm.sbPrintInvoiceClick(Sender: TObject);
var
  LastId : Int64;
begin
  adsDocumentBodies.DisableControls;
  LastId := adsDocumentBodiesId.Value;
  adsDocumentBodies.Close;
  adsDocumentBodies.RestoreSQL;
  adsDocumentBodies.Open;
  try
    PrintInvoice();
  finally
    adsDocumentBodies.Close;
    adsDocumentBodies.RestoreSQL;
    AddNDSFilter();
    adsDocumentBodies.Open;
    if not adsDocumentBodies.Locate('Id', LastId, []) then
      adsDocumentBodies.First;
    adsDocumentBodies.EnableControls;
  end;
end;

function TDocumentBodiesForm.GetMinProducerCost: Double;
begin
  if not adsDocumentBodiesRegistryCost.IsNull
    and (adsDocumentBodiesRegistryCost.Value > 0)
    and (adsDocumentBodiesRegistryCost.Value < adsDocumentBodiesProducerCost.Value)
  then
    Result := adsDocumentBodiesRegistryCost.Value
  else
    Result := adsDocumentBodiesProducerCost.Value;
end;

procedure TDocumentBodiesForm.sbEditTicketReportParamsClick(
  Sender: TObject);
begin
  ShowEditTicketReportParams;
end;

procedure TDocumentBodiesForm.SetButtonPositions;
const
  topButton = 12;
  buttonInterval = 5;
  leftButton = 310;
begin
  if leftButton + 4*sbPrintTickets.Width + 3*buttonInterval + 2*sbEditAddress.Width + 2*buttonInterval > gbPrint.ClientWidth
  then begin
    //����������� �� ��� � �������
    sbPrintTickets.Left := leftButton;
    sbPrintReestr.Left := sbPrintTickets.Left;
    sbPrintWaybill.Left := sbPrintTickets.Left;

    sbPrintInvoice.Left := sbPrintTickets.Left + sbPrintTickets.Width + buttonInterval;
    sbPrintRackCard.Left := sbPrintInvoice.Left;
    sbReestrToExcel.Left := sbPrintInvoice.Left;

    sbPrintTickets.Top := topButton;
    sbPrintReestr.Top := sbPrintTickets.Top + sbPrintTickets.Height + buttonInterval;
    sbPrintWaybill.Top := sbPrintReestr.Top + sbPrintReestr.Height + buttonInterval;

    sbPrintInvoice.Top := topButton;
    sbPrintRackCard.Top := sbPrintInvoice.Top + sbPrintInvoice.Height + buttonInterval;
    sbReestrToExcel.Top := sbPrintRackCard.Top + sbPrintRackCard.Height + buttonInterval;

    sbWaybillToExcel.Top := topButton;
    sbWaybillToExcel.Left := sbPrintInvoice.Left + sbPrintInvoice.Width + buttonInterval;
    

    sbEditAddress.Top := topButton;
    sbEditTicketReportParams.Top := sbEditAddress.Top + sbEditAddress.Height + buttonInterval;
    sbEditRackCardParams.Top := sbEditTicketReportParams.Top + sbEditTicketReportParams.Height + buttonInterval;

    sbEditAddress.Left := gbPrint.ClientWidth - buttonInterval - sbEditAddress.Width;
    sbEditTicketReportParams.Left := sbEditAddress.Left;
    sbEditRackCardParams.Left := sbEditTicketReportParams.Left;
  end
  else begin
    //����������� �� ��� � �������
    sbPrintTickets.Left := leftButton;
    sbPrintReestr.Left := sbPrintTickets.Left;
    
    sbPrintWaybill.Left := sbPrintTickets.Left + sbPrintTickets.Width + buttonInterval;
    sbPrintInvoice.Left := sbPrintWaybill.Left;

    sbPrintRackCard.Left := sbPrintInvoice.Left + sbPrintInvoice.Width + buttonInterval;
    sbReestrToExcel.Left := sbPrintRackCard.Left;

    sbPrintTickets.Top := topButton;
    sbPrintReestr.Top := sbPrintTickets.Top + sbPrintTickets.Height + buttonInterval;

    sbPrintWaybill.Top := topButton;
    sbPrintInvoice.Top := sbPrintReestr.Top;

    sbPrintRackCard.Top := topButton;
    sbReestrToExcel.Top := sbPrintReestr.Top;
    
    sbWaybillToExcel.Top := topButton;
    sbWaybillToExcel.Left := sbPrintRackCard.Left + sbPrintRackCard.Width + buttonInterval;

    sbEditAddress.Top := topButton;
    sbEditTicketReportParams.Top := topButton;
    sbEditRackCardParams.Top := sbEditTicketReportParams.Top + sbEditTicketReportParams.Height + buttonInterval;
    sbEditTicketReportParams.Left := gbPrint.ClientWidth - buttonInterval - sbEditTicketReportParams.Width;
    sbEditRackCardParams.Left := sbEditTicketReportParams.Left;
    sbEditAddress.Left := sbEditTicketReportParams.Left - buttonInterval - sbEditAddress.Width;
  end;

  gbPrint.ClientHeight := sbEditRackCardParams.Top + sbEditRackCardParams.Height + buttonInterval;
end;

function TDocumentBodiesForm.NeedReplaceButtons: Boolean;
begin
  Result := True;
end;

procedure TDocumentBodiesForm.OnResizeForm(Sender: TObject);
begin
  if NeedReplaceButtons then
    SetButtonPositions;
end;

procedure TDocumentBodiesForm.sbEditRackCardParamsClick(Sender: TObject);
begin
  ShowEditRackCardReportParams();
end;

procedure TDocumentBodiesForm.sbReestrToExcelClick(Sender: TObject);
begin
  DoActionOnPrinted(ReestrToExcel);
end;

procedure TDocumentBodiesForm.sbPrintRackCardClick(Sender: TObject);
begin
  DoActionOnPrinted(PrintRackCard);
end;

procedure TDocumentBodiesForm.sbWaybillToExcelClick(Sender: TObject);
begin
  DoActionOnPrinted(WaybillToExcel);
end;

function TDocumentBodiesForm.GetTotalSupplierSumm: Double;
var
  Mark: String;
begin
  Result := 0;
  adsDocumentBodies.DisableControls;
  Mark := adsDocumentBodies.Bookmark;
  try
    adsDocumentBodies.First;
    while not adsDocumentBodies.Eof do begin
      Result := Result + adsDocumentBodiesSupplierCost.Value * adsDocumentBodiesQuantity.Value; 
      adsDocumentBodies.Next;
    end;
  finally
    adsDocumentBodies.Bookmark := Mark;
    adsDocumentBodies.EnableControls;
  end;
end;

procedure TDocumentBodiesForm.DoActionOnPrinted(Action: TThreadMethod);
var
  LastId : Int64;
begin
  adsDocumentBodies.DisableControls;
  LastId := adsDocumentBodiesId.Value;
  adsDocumentBodies.Close;
  adsDocumentBodies.RestoreSQL;
  adsDocumentBodies.AddWhere('Printed = 1');
  AddNDSFilter();
  adsDocumentBodies.Open;
  try
    Action();
  finally
    adsDocumentBodies.Close;
    adsDocumentBodies.RestoreSQL;
    AddNDSFilter();
    adsDocumentBodies.Open;
    if not adsDocumentBodies.Locate('Id', LastId, []) then
      adsDocumentBodies.First;
    adsDocumentBodies.EnableControls;
  end;
end;

procedure TDocumentBodiesForm.WaybillToExcel;
var
  exportFile : String;
  exportData : TDataExportAsXls;
  rowNumber : Integer;
begin
  exportFile := TDBGridHelper.GetTempFileToExport();

  exportData := TDataExportAsXls.Create(exportFile);
  try

    exportData.WriteBlankRow;
    exportData.WriteRow([
      '',
      '',
      '',
      '',
      '',
      '������������ �����������: ' + DM.GetEditNameAndAddress
      ]);
    exportData.WriteRow([
      '',
      '',
      '�����:',
      '_______________________________________'
      ]);
    exportData.WriteRow([
      '���������� �',
      '_______________________',
      '',
      '',
      '',
      '��������� �',
      '_______________________'
      ]);
    exportData.WriteRow([
      '',
      '�� "___"_________________20___�',
      '',
      '',
      '',
      '',
      '�� "___"_________________20___�'
      ]);
    exportData.WriteRow([
      '����: �������� �����',
      '_______________________',
      '',
      '',
      '',
      '����� ����',
      '_______________________'
      ]);
    exportData.WriteRow([
      '��������� �������',
      '_______________________',
      '',
      '',
      '',
      '������������ �_____',
      '�� "___"_________________20___�'
      ]);
    exportData.WriteBlankRow;

    exportData.WriteRow([
      '� ��',
      '������������ � ������� �������������� ������',
      '����� ������ ����������',
      '���� ��������',
      '�������������',
      '���� ��� ���, ���',
      '����������.�����.',
      '���. ����. %',
      '������. ���� ���-�� ��� ���, ���',
      '��� ���-��, ���',
      '������. ���� ���-�� � ���, ���',
      '����. ����. ����. %',
      '����. ���� �� ��., ���',
      '���-��',
      '����. �����, ���']);

    adsDocumentBodies.First;
    rowNumber := 1;
    while not adsDocumentBodies.Eof do begin
      exportData.WriteRow([
        IntToStr(rowNumber),
        adsDocumentBodiesProduct.AsString,
        adsDocumentBodiesSerialNumber.AsString + ' ' + adsDocumentBodiesCertificates.AsString,
        adsDocumentBodiesPeriod.AsString,
        adsDocumentBodiesProducer.AsString,
        adsDocumentBodiesProducerCost.AsString,
        adsDocumentBodiesQuantity.AsString,
        adsDocumentBodiesSupplierPriceMarkup.AsString,
        adsDocumentBodiesSupplierCostWithoutNDS.AsString,
        NDSField.AsString,
        adsDocumentBodiesSupplierCost.AsString,
        retailMarkupField.AsString,
        retailPriceField.AsString,
        adsDocumentBodiesQuantity.AsString,
        retailSummField.AsString
        ]);

      Inc(rowNumber);
      adsDocumentBodies.Next;
    end;
  finally
    exportData.Free;
  end;

  ShellExecute(
    0,
    'Open',
    PChar(exportFile),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TDocumentBodiesForm.PrintRackCard;
var
  priceNameVariant : Variant;
  priceName : String;
  bracketIndex : Integer;
  RackCardReportParams : TRackCardReportParams;
begin
  RackCardReportParams := TRackCardReportParams.Create(DM.MainConnection);
  try
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

    frVariables[ 'DeleteUnprintableElemnts'] := RackCardReportParams.DeleteUnprintableElemnts;
    frVariables[ 'ClientNameAndAddress'] := DM.GetEditNameAndAddress;
    frVariables[ 'ProviderDocumentId'] := adsDocumentHeadersProviderDocumentId.AsString;
    frVariables[ 'DocumentDate'] := DateToStr(adsDocumentHeadersLocalWriteTime.AsDateTime);
    frVariables[ 'ProviderName'] := priceName;

    frVariables['ProductVisible'] := RackCardReportParams.ProductVisible;
    frVariables['ProducerVisible'] := RackCardReportParams.ProducerVisible;
    frVariables['SerialNumberVisible'] := RackCardReportParams.SerialNumberVisible;
    frVariables['PeriodVisible'] := RackCardReportParams.PeriodVisible;
    frVariables['QuantityVisible'] := RackCardReportParams.QuantityVisible;
    frVariables['ProviderVisible'] := RackCardReportParams.ProviderVisible;
    frVariables['CostVisible'] := RackCardReportParams.CostVisible;
    frVariables['CertificatesVisible'] := RackCardReportParams.CertificatesVisible;

    DM.ShowFastReportWithSave('RackCard.frf', adsDocumentBodies, True);
  finally
    RackCardReportParams.Free;
  end;
end;

procedure TDocumentBodiesForm.ReestrToExcel;
var
  exportFile : String;
  exportData : TDataExportAsXls;
  rowNumber : Integer;
begin
  exportFile := TDBGridHelper.GetTempFileToExport();

  exportData := TDataExportAsXls.Create(exportFile);
  try

    exportData.WriteBlankRow;
    exportData.WriteRow([
      '',
      '',
      '',
      '',
      '',
      '',
      '������'
      ]);
    exportData.WriteRow([
      '',
      '',
      '',
      '',
      '��������� ��� �� ������������� �������� � ������� ������������ ����������,'
      ]);
    exportData.WriteRow([
      '',
      '',
      '',
      '',
      Format('���������� �� %s-�� ����� (���������) �%s �� %s',
        [adsDocumentHeadersProviderName.AsString,
         adsDocumentHeadersProviderDocumentId.AsString,
         DateToStr(adsDocumentHeadersLocalWriteTime.AsDateTime)])
      ]);
    exportData.WriteBlankRow;
      
    exportData.WriteRow([
      '� ��',
      '������������',
      '����� ������',
      '���� ��������',
      '�������������',
      '���� ��� ���, ���',
      '���� ��, ���',
      '���. ����. %',
      '������. ���� ���-�� ��� ���, ���',
      '��� ���-��, ���',
      '������. ���� ���-�� � ���, ���',
      '����. ����. ����. %',
      '����. ���� �� ��., ���',
      '���-��',
      '����. �����, ���']);

    adsDocumentBodies.First;
    rowNumber := 1;
    while not adsDocumentBodies.Eof do begin
      exportData.WriteRow([
        IntToStr(rowNumber),
        adsDocumentBodiesProduct.AsString,
        adsDocumentBodiesSerialNumber.AsString,
        adsDocumentBodiesPeriod.AsString,
        adsDocumentBodiesProducer.AsString,
        adsDocumentBodiesProducerCost.AsString,
        adsDocumentBodiesRegistryCost.AsString,
        adsDocumentBodiesSupplierPriceMarkup.AsString,
        adsDocumentBodiesSupplierCostWithoutNDS.AsString,
        NDSField.AsString,
        adsDocumentBodiesSupplierCost.AsString,
        retailMarkupField.AsString,
        retailPriceField.AsString,
        adsDocumentBodiesQuantity.AsString,
        retailSummField.AsString
        ]);

      Inc(rowNumber);
      adsDocumentBodies.Next;
    end;
  finally
    exportData.Free;
  end;

  ShellExecute(
    0,
    'Open',
    PChar(exportFile),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TDocumentBodiesForm.PrintInvoice;
var
  totalRetailSumm : Currency;
  V: array[0..0] of Variant;
begin
  DBProc.DataSetCalc(adsDocumentBodies, ['Sum(RetailSumm)'], V);
  totalRetailSumm := V[0];

  frVariables[ 'ClientNameAndAddress'] := DM.GetEditNameAndAddress;
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

  frVariables[ '����������'] := '';
  frVariables[ '���������������'] := '';

  DM.ShowFastReportWithSave('Invoice.frf', adsDocumentBodies, True);
end;

procedure TDocumentBodiesForm.PrintWaybill;
var
  totalRetailSumm : Currency;
  totatSupplierSumm : Currency;
  V: array[0..0] of Variant;
begin
  DBProc.DataSetCalc(adsDocumentBodies, ['Sum(RetailSumm)'], V);
  totalRetailSumm := V[0];
  totatSupplierSumm := GetTotalSupplierSumm();

  frVariables[ 'ClientNameAndAddress'] := DM.GetEditNameAndAddress;
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

  frVariables[ 'TotalSupplierSumm'] := totatSupplierSumm;
  frVariables[ 'TotalSupplierSummText'] := AnsiLowerCase(MoneyToString(totatSupplierSumm, True, False));

  DM.ShowFastReportWithSave('Waybill.frf', adsDocumentBodies, True);
end;

procedure TDocumentBodiesForm.PrintReestr;
var
  totalRetailSumm : Currency;
  totatSupplierSumm : Currency;
  V: array[0..0] of Variant;
begin
  DBProc.DataSetCalc(adsDocumentBodies, ['Sum(RetailSumm)'], V);
  totalRetailSumm := V[0];
  totatSupplierSumm := GetTotalSupplierSumm();

  frVariables[ 'ClientNameAndAddress'] := DM.GetEditNameAndAddress;
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

  frVariables[ 'TotalSupplierSumm'] := totatSupplierSumm;
  frVariables[ 'TotalSupplierSummText'] := AnsiLowerCase(MoneyToString(totatSupplierSumm, True, False));

  DM.ShowFastReportWithSave('Reestr.frf', adsDocumentBodies, True);
end;

procedure TDocumentBodiesForm.PrintTickets;
var
  priceNameVariant : Variant;
  priceName : String;
  bracketIndex : Integer;
  TicketParams : TTicketReportParams;
begin
  TicketParams := TTicketReportParams.Create(DM.MainConnection);
  try
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

    frVariables[ 'PrintEmptyTickets'] := TicketParams.PrintEmptyTickets;
    frVariables[ 'ClientNameAndAddress'] := DM.GetEditNameAndAddress;
    frVariables[ 'ProviderDocumentId'] := adsDocumentHeadersProviderDocumentId.AsString;
    frVariables[ 'DocumentDate'] := DateToStr(adsDocumentHeadersLocalWriteTime.AsDateTime);
    frVariables[ 'TicketSignature'] := priceName;
    frVariables[ 'DeleteUnprintableElemnts'] := TicketParams.DeleteUnprintableElemnts;

    if TicketParams.TicketSize = tsStandart then begin
      frVariables['ClientNameVisible'] := TicketParams.ClientNameVisible;
      frVariables['ProductVisible'] := TicketParams.ProductVisible;
      frVariables['CountryVisible'] := TicketParams.CountryVisible;
      frVariables['ProducerVisible'] := TicketParams.ProducerVisible;
      frVariables['PeriodVisible'] := TicketParams.PeriodVisible;
      frVariables['ProviderDocumentIdVisible'] := TicketParams.ProviderDocumentIdVisible;
      frVariables['SignatureVisible'] := TicketParams.SignatureVisible;
      frVariables['SerialNumberVisible'] := TicketParams.SerialNumberVisible;
      frVariables['DocumentDateVisible'] := TicketParams.DocumentDateVisible;
    end;

    DM.ShowFastReportWithSave(
      IfThen(TicketParams.TicketSize = tsStandart, 'Ticket.frf', 'SmallTicket.frf'),
      adsDocumentBodies,
      True);
  finally
    TicketParams.Free;
  end;
end;

procedure TDocumentBodiesForm.CreateLegenPanel;
var
  lLegend : TLabel;
begin
  legeng := TframeBaseLegend.Create(Self);
  legeng.Parent := pGrid;
  legeng.Align := alBottom;

  lLegend := legeng.CreateLegendLabel(
    '���: �� ���������� ��� �����',
    clRed,
    clWindowText,
    '��� �����-������� ����������� ����������� �������� ���');

  lLegend := legeng.CreateLegendLabel(
    '�������� ������� ��������: ���������� ��������� �������',
    clRed,
    clWindowText,
    '�������� �������� ������� �������� ��������� ������������ ������� �������� �����');

  lLegend := legeng.CreateLegendLabel(
    '��������� �������: ���������� ������������ ��������� �������',
    clRed,
    clWindowText,
    '�������� ��������� ������� ��������� ������������ ��������� �������');

  lLegend := legeng.CreateLegendLabel(
    '��������� ����: �� ����������',
    clRed,
    clWindowText,
    '�������� ��������� �������, ��������� ����, ��������� ����� � �������� ������� �� ���� ��������� �������������');
end;

procedure TDocumentBodiesForm.adsDocumentBodiesPrintedChange(
  Sender: TField);
begin
  //��-������� ������ �������� �� �������. �������� ������, ����� �� � ������� ����
  //�������� ���������� dataset
  tmrPrintedChange.Enabled := False;
  tmrPrintedChange.Enabled := True;
end;

procedure TDocumentBodiesForm.FillNDSFilter;
var
  previosIndex : Integer;
  prevoisValue : String;
  nullExists : Boolean;
begin
  nullExists := False;
  previosIndex := 0;
  prevoisValue := '';
  if (cbNDS.ItemIndex > 0) and (cbNDS.ItemIndex < cbNDS.Items.Count) then begin
    previosIndex := cbNDS.ItemIndex;
    prevoisValue := cbNDS.Items[cbNDS.ItemIndex];
  end;

  cbNDS.OnSelect := nil;
  try

    cbNDS.Items.Clear();
    cbNDS.Items.Add('���');
    cbNDS.ItemIndex := 0;

    DM.adsQueryValue.SQL.Text := 'select distinct NDS as NDSValue from DocumentBodies dbodies where dbodies.DocumentId = :DocumentId order by dbodies.NDS';
    DM.adsQueryValue.ParamByName('DocumentId').Value := FDocumentId;
    DM.adsQueryValue.Open;

    try
      while not DM.adsQueryValue.Eof do begin
        if DM.adsQueryValue.FieldByName('NDSValue').IsNull then
          nullExists := True
        else
          cbNDS.Items.Add(DM.adsQueryValue.FieldByName('NDSValue').AsString);
        DM.adsQueryValue.Next;
      end;
    finally
      DM.adsQueryValue.Close;
    end;

    if nullExists then
      cbNDS.Items.Add(NDSNullValue);

    if (Length(prevoisValue) > 0) then begin
      previosIndex := cbNDS.Items.IndexOf(prevoisValue);
      if previosIndex > -1 then
        cbNDS.ItemIndex := previosIndex;
    end;

  finally
    cbNDS.OnSelect := cbNDSSelect;
  end;
end;

procedure TDocumentBodiesForm.cbNDSSelect(Sender: TObject);
begin
  dbgDocumentBodies.SetFocus;
  RecalcDocument;
end;

procedure TDocumentBodiesForm.AddNDSFilter;
begin
  if cbNDS.ItemIndex > 0 then
    if NDSNullValue = cbNDS.Items[cbNDS.ItemIndex] then
      adsDocumentBodies.AddWhere('NDS is null')
    else
      adsDocumentBodies.AddWhere('NDS = ' + cbNDS.Items[cbNDS.ItemIndex]);
end;

procedure TDocumentBodiesForm.ForceRecalcDocument(DocumentId: Int64);
begin
  FDocumentId := DocumentId;
  SetParams;
end;

end.
