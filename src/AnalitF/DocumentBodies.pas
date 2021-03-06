unit DocumentBodies;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, StdCtrls, DBCtrls, GridsEh, DBGridEh,
  ToughDBGrid, DB, MemDS, DBAccess, MyAccess, DModule, DocumentTypes,
  FR_DSet, FR_DBSet, Buttons, FR_Class,
  RxMemDS,
  Menus,
  U_frameBaseLegend,
  WaybillReportParams,
  U_WaybillPrintSettingsForm,
  ReestrReportParams,
  U_ReestrPrintSettingsForm,
  DataSetHelper,
  VitallyImportantMarkupsParams,
  ContextMenuGrid, StrHlder,
  UserActions,
  WaybillCalculation,
  U_LegendHolder,
  U_WaybillGridFactory,
  U_frameRejectedPosition;

const
  NDSNullValue = '��� ��������';
  
type
  TCheckBoxEx = class(TCheckBox);

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
    adsDocumentBodiesUnit: TStringField;
    adsDocumentBodiesExciseTax: TFloatField;
    adsDocumentBodiesBillOfEntryNumber: TStringField;
    adsDocumentBodiesEAN13: TStringField;
    adsInvoiceHeaders: TMyQuery;
    dsInvoiceHeaders: TDataSource;
    adsDocumentBodiesRequestCertificate: TBooleanField;
    adsDocumentBodiesCertificateId: TLargeintField;
    adsDocumentBodiesDocumentBodyId: TLargeintField;
    tmrShowCertificateWarning: TTimer;
    adsDocumentBodiesServerId: TLargeintField;
    adsDocumentBodiesServerDocumentId: TLargeintField;
    adsDocumentHeadersCreatedByUser: TBooleanField;
    adsDocumentBodiesCatalogMarkup: TFloatField;
    adsDocumentBodiesCatalogMaxMarkup: TFloatField;
    adsDocumentBodiesCatalogMaxSupplierMarkup: TFloatField;
    shPositionInsert: TStrHolder;
    shPositionDelete: TStrHolder;
    shPositionFullUpdate: TStrHolder;
    shPositionUpdate: TStrHolder;
    adsOrder: TMyQuery;
    dsOrder: TDataSource;
    shOrder: TStrHolder;
    adsDocumentBodiesRejectId: TLargeintField;
    adsDocumentBodiesServerOrderListId: TLargeintField;
    adsDocumentBodiesOrderId: TLargeintField;
    tmrShowMatchOrder: TTimer;
    tmRunRequestCertificate: TTimer;
    adsDocumentBodiesVitallyImportantByUser: TBooleanField;
    pFrameOrder: TPanel;
    dsOrdersH: TDataSource;
    adsOrdersHForm: TMyQuery;
    adsOrdersHFormOrderId: TLargeintField;
    adsOrdersHFormClientID: TLargeintField;
    adsOrdersHFormServerOrderId: TLargeintField;
    adsOrdersHFormDatePrice: TDateTimeField;
    adsOrdersHFormPriceCode: TLargeintField;
    adsOrdersHFormRegionCode: TLargeintField;
    adsOrdersHFormOrderDate: TDateTimeField;
    adsOrdersHFormSendDate: TDateTimeField;
    adsOrdersHFormClosed: TBooleanField;
    adsOrdersHFormSend: TBooleanField;
    adsOrdersHFormPriceName: TStringField;
    adsOrdersHFormRegionName: TStringField;
    adsOrdersHFormSupportPhone: TStringField;
    adsOrdersHFormMessageTo: TMemoField;
    adsOrdersHFormComments: TMemoField;
    adsOrdersHFormPriceEnabled: TBooleanField;
    adsOrdersHFormPositions: TLargeintField;
    adsOrdersHFormSumOrder: TFloatField;
    adsOrdersHFormsumbycurrentmonth: TFloatField;
    adsOrdersHFormDisplayOrderId: TLargeintField;
    adsOrdersHFormMinReq: TLargeintField;
    adsOrdersHFormDifferentCostCount: TLargeintField;
    adsOrdersHFormDifferentQuantityCount: TLargeintField;
    adsOrdersHFormsumbycurrentweek: TFloatField;
    adsOrdersHFormFrozen: TBooleanField;
    adsOrdersHFormAddressName: TStringField;
    adsOrdersHFormNotExistsCount: TLargeintField;
    adsOrdersHFormRealClientId: TLargeintField;
    pNotFound: TPanel;
    pOrderGrid: TPanel;
    pOrderDetail: TPanel;
    dbtPriceName: TDBText;
    Label3: TLabel;
    DBText1: TDBText;
    Label5: TLabel;
    DBText2: TDBText;
    Label6: TLabel;
    lblSum: TLabel;
    DBText3: TDBText;
    dbtSumOrder: TDBText;
    Label7: TLabel;
    Label8: TLabel;
    dbtRegionName: TDBText;
    lSumOrder: TLabel;
    lDatePrice: TLabel;
    dbtDatePrice: TDBText;
    dbgOrder: TDBGridEh;
    adsDocumentHeadersProviderShortName: TStringField;
    cbSelect: TCheckBox;
    adsDocumentBodiesRejectStatus: TStringField;
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
    procedure FormDestroy(Sender: TObject);
    procedure adsDocumentBodiesCertificateIdGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure adsDocumentBodiesRequestCertificateValidate(Sender: TField);
    procedure tmrShowCertificateWarningTimer(Sender: TObject);
    procedure tmrShowMatchOrderTimer(Sender: TObject);
    procedure adsDocumentBodiesAfterScroll(DataSet: TDataSet);
    procedure adsDocumentBodiesAfterOpen(DataSet: TDataSet);
    procedure tmRunRequestCertificateTimer(Sender: TObject);
    procedure adsDocumentBodiesAfterDelete(DataSet: TDataSet);
    procedure adsDocumentBodiesAfterPost(DataSet: TDataSet);
    procedure cbSelectClick(Sender: TObject);
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

    FContextMenuGrid : TContextMenuGrid;

    NeedLog,
    NeedCalcFieldsLog : Boolean;

    legeng : TframeBaseLegend;

    pButtons : TPanel;
    sbAdd : TSpeedButton;
    sbDelete : TSpeedButton;
    sbRequestCertificates : TSpeedButton;
{$ifdef DEBUG}
    sbMarkAsReject : TSpeedButton;
    sbMarkAsUnReject : TSpeedButton;
    sbMarkAsOrder1 : TSpeedButton;
    sbMarkAsOrder2 : TSpeedButton;
    sbDeleteMarks : TSpeedButton;
{$endif}


    internalWaybillReportParams : TWaybillReportParams;
    internalReestrReportParams : TReestrReportParams;

    mdReport : TRxMemoryData;

    FParams : TVitallyImportantMarkupsParams;

    FWaybillDataSetState : set of TDataSetState;

    EtalonSQL : String;

    procedure SetParams;
    procedure PrepareGrid;
    procedure WaybillCalcFields(DataSet : TDataSet);
    procedure UserWaybillNewRecord(DataSet: TDataSet);
    procedure UserWaybillBeforePost(DataSet: TDataSet);
    procedure UserWaybillAfterNewRecord(DataSet: TDataSet);
    procedure LoadFromRegistry();
    procedure RecalcDocument;
    procedure RecalcPosition;
    procedure WaybillGetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure WaybillDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure WaybillKeyPress(Sender: TObject; var Key: Char);
    procedure WaybillCellClick(Column: TColumnEh);
    //procedure FieldOnChange(Sender: TField);
    procedure RetailPriceUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure RetailPriceGetCellParams(Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
    procedure RetailMarkupUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure RetailMarkupGetCellParams(Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
    procedure RealMarkupUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure RealMarkupGetCellParams(Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
    procedure ProductUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure UserWaybillIntegerUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure UserWaybillFloatUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);

    //������ ��� ������� ��������� ������� � ���
    //�������� ���� �� �������, �� ����� ���������� ���� �������
    function GetRetailPriceByMarkup(var markup : Double) : Double;
    //�������� ������� �� ����
    function GetRetailMarkupByPrice(price : Double) : Double;
    //����� �� �� ���������� ��������� �������, ����������� �� ���������� ������
    function CanCalculateRetailMarkup : Boolean;

    function GetMinProducerCost() : Double;
    function GetMinProducerCostByField(RegistryCost, ProducerCost : TFloatField) : Double;

    function GetMinProducerCostForMarkup() : Double;
    function GetMinProducerCostByFieldForMarkup(
      RegistryCost, ProducerCost : TFloatField;
      NDSValue : TField) : Double;

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
    function  GetNDSFilter(): String;
    procedure ReadSettings();

    function GetMarkupValue(afValue : Currency; individualMarkup : TFloatField) : Currency;

    function AllowRealValue(text : String) : Boolean;
    procedure sbAddRowClick(Sender: TObject);
    procedure sbDeleteRowClick(Sender: TObject);
    procedure sbRequestCertificatesClick(Sender: TObject);
{$ifdef DEBUG}
    procedure sbMarkAsRejectClick(Sender: TObject);
    procedure sbMarkAsUnRejectClick(Sender: TObject);
    procedure sbMarkAsOrder1Click(Sender: TObject);
    procedure sbMarkAsOrder2Click(Sender: TObject);
    procedure sbDeleteMarksClick(Sender: TObject);
    procedure markAsOrderBy(serverOrderListId : Int64);
{$endif}
    procedure SetOrderByPosition;
    procedure SetOrderGrid;
    procedure UpdateMatchOrderTimer;
    procedure UpdateRequestCertificates;
    function GetPrintedDocumentLineCount() : Integer;
    procedure SetPrintedOnDocumentLines(value : Boolean);
    procedure UpdateSelectState();
    function GetDocumentLineCount(ndsFilter,
      additionFilter: String): Integer;
    procedure UpdateGridOnLegend(Sender : TObject);
  public
    { Public declarations }
    frameRejectedPosition : TframeRejectedPosition;
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

{ TDocumentBodiesForm }

procedure TDocumentBodiesForm.SetParams;
begin
  adsDocumentHeaders.Close;
  adsDocumentHeaders.ParamByName('DocumentId').Value := FDocumentId;
  adsDocumentHeaders.Open;
  adsInvoiceHeaders.Close;
  adsInvoiceHeaders.ParamByName('DocumentId').Value := FDocumentId;
  adsInvoiceHeaders.Open;
  adsDocumentBodies.Close;
  adsDocumentBodies.SQL.Text := EtalonSQL;
  PrepareGrid;
  gbPrint.Visible := adsDocumentHeadersDocumentType.Value = 1;
  adsDocumentBodies.ParamByName('DocumentId').Value := FDocumentId;
  adsDocumentBodies.ParamByName('LastRequestTime').Value := FGS.LastRequestWithRejects;
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
  frameRejectedPosition.HideReject();
  SetParams;
  inherited ShowForm;
  if adsDocumentHeadersDocumentType.Value = 1 then begin
    SetButtonPositions;
    UpdateSelectState();
    Self.OnResize := OnResizeForm;
    //��� ���, ����� ������ � ������������� �������� ����� ������������
    if (not adsDocumentBodiesRejectId.IsNull) then
      adsDocumentBodiesAfterScroll(adsDocumentBodies);
  end;
end;

procedure TDocumentBodiesForm.dbgDocumentBodiesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
{
var
  lastField : TField;
}  
begin
  if Key = VK_DELETE then begin
    if not dbgDocumentBodies.EditorMode and adsDocumentHeadersCreatedByUser.Value
      and not adsDocumentBodies.IsEmpty
    then begin
      if AProc.MessageBox( '������� ������� ���������?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then
        adsDocumentBodies.Delete;
    end;
  end
  else
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
  I : Integer;
begin
  pButtons.Visible := False;
  pFrameOrder.Visible := False;
  dbgDocumentBodies.MinAutoFitWidth := DBGridColumnMinWidth;
  dbgDocumentBodies.Flat := True;
  dbgDocumentBodies.Options := dbgDocumentBodies.Options + [dgRowLines];
  dbgDocumentBodies.OptionsEh := dbgDocumentBodies.OptionsEh + [dghResizeWholeRightPart];
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
    pFrameOrder.Visible := True;
    adsDocumentBodies.OnCalcFields := WaybillCalcFields;
    dbgDocumentBodies.OnGetCellParams := WaybillGetCellParams;
    dbgDocumentBodies.OnKeyPress := WaybillKeyPress;
    dbgDocumentBodies.OnCellClick := WaybillCellClick;
    dbgDocumentBodies.OnDrawColumnCell := WaybillDrawColumnCell;
    dbgDocumentBodies.ReadOnly := True;

    if adsDocumentHeadersCreatedByUser.Value then begin
      legeng.Visible := False;
      pFrameOrder.Visible := False;
      pButtons.Visible := True;
      sbAdd.Visible := True;
      sbDelete.Visible := True;
      sbRequestCertificates.Visible := False;
{$ifdef DEBUG}
      sbMarkAsReject.Visible := False;
      sbMarkAsUnReject.Visible := False;
      sbMarkAsOrder1.Visible := False;
      sbMarkAsOrder2.Visible := False;
      sbDeleteMarks.Visible := False;
{$endif}
      legeng.Visible := True;
      FWaybillDataSetState := [dsEdit, dsInsert];
      adsDocumentBodies.OnNewRecord := UserWaybillNewRecord;
      adsDocumentBodies.SQLInsert.Text := shPositionInsert.Strings.Text;
      adsDocumentBodies.SQLDelete.Text := shPositionDelete.Strings.Text;
      adsDocumentBodies.SQLUpdate.Text := shPositionFullUpdate.Strings.Text;
      adsDocumentBodies.BeforePost := UserWaybillBeforePost;
      adsDocumentBodies.AfterInsert := UserWaybillAfterNewRecord;
    end
    else begin
      legeng.Visible := False;
      pButtons.Visible := True;
      sbAdd.Visible := False;
      sbDelete.Visible := False;
      sbRequestCertificates.Visible := True;
{$ifdef DEBUG}
      sbMarkAsReject.Visible := True;
      sbMarkAsUnReject.Visible := True;
      sbMarkAsOrder1.Visible := True;
      sbMarkAsOrder2.Visible := True;
      sbDeleteMarks.Visible := True;
{$endif}
      UpdateRequestCertificates;
      legeng.Visible := True;
      adsDocumentBodies.OnNewRecord := nil;
      adsDocumentBodies.BeforePost := nil;
      adsDocumentBodies.AfterInsert := nil;
      FWaybillDataSetState := [dsEdit];
      adsDocumentBodies.SQLUpdate.Text := shPositionUpdate.Strings.Text;
    end;

    TWaybillGridFactory.AddColumnsToGrid(
      dbgDocumentBodies,
      adsDocumentHeadersCreatedByUser.Value,
      ProductUpdateData,
      UserWaybillFloatUpdateData,
      UserWaybillIntegerUpdateData,
      RetailMarkupUpdateData,
      RealMarkupUpdateData,
      RetailPriceUpdateData,
      RetailMarkupGetCellParams,
      RealMarkupGetCellParams,
      RetailPriceGetCellParams);

    dbgDocumentBodies.ReadOnly := False;
    dbgDocumentBodies.Options := dbgDocumentBodies.Options + [dgEditing];
    dbgDocumentBodies.SelectedField := retailMarkupField;
    if adsDocumentHeadersCreatedByUser.Value then
      dbgDocumentBodies.AllowedOperations := [alopUpdateEh, alopInsertEh, alopAppendEh]
    else
      dbgDocumentBodies.AllowedOperations := [alopUpdateEh];
  end
  else begin
    legeng.Visible := False;
    pButtons.Visible := False;
    adsDocumentBodies.OnCalcFields := nil;
    adsDocumentBodies.OnNewRecord := nil;
    adsDocumentBodies.BeforePost := nil;
    adsDocumentBodies.AfterInsert := nil;
    dbgDocumentBodies.OnGetCellParams := nil;
    dbgDocumentBodies.OnKeyPress := nil;
    dbgDocumentBodies.OnCellClick := nil;
    dbgDocumentBodies.OnDrawColumnCell := nil;
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
      or (adsDocumentBodiesVitallyImportant.IsNull and adsDocumentBodiesVitallyImportantByUser.Value)
      then begin
        if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '������������ ������� ����� �� �����');
        if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', 'GetMinProducerCostForMarkup(): ' + FloatToStr(GetMinProducerCostForMarkup()));
        maxMarkup := GetMarkupValue(DM.GetMaxVitallyImportantMarkup(GetMinProducerCostForMarkup()), adsDocumentBodiesCatalogMaxMarkup);
      end
      else begin
        if CalculateOnProducerCost then begin
          if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '������������ ������� ����� �� ��-����� ������������ ProducerCost');
          maxMarkup := GetMarkupValue(DM.GetMaxRetailMarkup(adsDocumentBodiesProducerCost.Value), adsDocumentBodiesCatalogMaxMarkup);
        end
        else begin
          if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '������������ ������� ����� �� ��-����� ������������ SupplierCostWithoutNDS');
          if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', 'SupplierCostWithoutNDS: ' + adsDocumentBodiesSupplierCostWithoutNDS.AsString);
          maxMarkup := GetMarkupValue(DM.GetMaxRetailMarkup(adsDocumentBodiesSupplierCostWithoutNDS.Value), adsDocumentBodiesCatalogMaxMarkup);
        end;
      end;
      maxRetailMarkupField.Value := maxMarkup;
      if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '������������ ��������� �������: ' + maxRetailMarkupField.AsString);
    end
    else begin
      if NeedLog and NeedCalcFieldsLog then Tracer.TR('WaybillCalcFields', '���� �������������: null');
      if not CalculateOnProducerCost and not adsDocumentBodiesVitallyImportant.Value
      then begin
        maxMarkup := GetMarkupValue(DM.GetMaxRetailMarkup(adsDocumentBodiesSupplierCostWithoutNDS.Value), adsDocumentBodiesCatalogMaxMarkup);
        maxRetailMarkupField.Value := maxMarkup;
      end;
    end;

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
  SoftPost(adsDocumentBodies);
  inherited;
  TDBGridHelper.SaveColumnsLayout(
    dbgDocumentBodies,
    IfThen(adsDocumentHeadersDocumentType.Value = 1,
      ifthen(adsDocumentHeadersCreatedByUser.Value,
        TWaybillGridFactory.GetDetailUserWaybillSectionName(),
        TWaybillGridFactory.GetDetailWaybillSectionName()),
      TWaybillGridFactory.GetDetailRejectSectionName()));
end;

procedure TDocumentBodiesForm.LoadFromRegistry;
begin
  TDBGridHelper.SetTitleButtonToColumns(dbgDocumentBodies);
  TDBGridHelper.RestoreColumnsLayout(
    dbgDocumentBodies,
    IfThen(adsDocumentHeadersDocumentType.Value = 1,
      ifthen(adsDocumentHeadersCreatedByUser.Value,
        TWaybillGridFactory.GetDetailUserWaybillSectionName(),
        TWaybillGridFactory.GetDetailWaybillSectionName()),
      TWaybillGridFactory.GetDetailRejectSectionName()));
  MyDacDataSetSortMarkingChanged( TToughDBGrid(dbgDocumentBodies) );
  if Length(adsDocumentBodies.IndexFieldNames) = 0 then
    adsDocumentBodies.IndexFieldNames := 'Product';
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
begin
  EtalonSQL := adsDocumentBodies.SQL.Text;
  FParams := TVitallyImportantMarkupsParams.Create(DM.MainConnection);
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


  TDataSetHelper.SetDisplayFormat(
    adsDocumentBodies,
    [
      'ProducerCost',
      'RegistryCost',
      'SupplierPriceMarkup',
      'SupplierCostWithoutNDS',
      'SupplierCost'
    ]);

  //��������� ����������� ���� � �������
  retailSummField := TDataSetHelper.AddCalculatedCurrencyField(adsDocumentBodies, 'RetailSumm');
  maxRetailMarkupField := TDataSetHelper.AddCalculatedCurrencyField(adsDocumentBodies, 'MaxRetailMarkup');
  retailPriceField := TDataSetHelper.AddCalculatedFloatField(adsDocumentBodies, 'RetailPrice');
  realMarkupField := TDataSetHelper.AddCalculatedFloatField(adsDocumentBodies, 'RealMarkup');

  FContextMenuGrid := TContextMenuGrid.Create(dbgDocumentBodies, DM.SaveGridMask);

  CreateLegenPanel();

  frameRejectedPosition := TframeRejectedPosition.AddFrame(
    Self,
    pGrid,
    dbgDocumentBodies);
    
  SetOrderGrid();

  inherited;
end;

procedure TDocumentBodiesForm.cbClearRetailPriceClick(Sender: TObject);
begin
  dbgDocumentBodies.SetFocus();
  RecalcDocument;
end;

procedure TDocumentBodiesForm.sbPrintReestrClick(Sender: TObject);
begin
  ReestrPrintSettingsForm := TReestrPrintSettingsForm.Create(Application);
  try
    ReestrPrintSettingsForm.UpdateParams(
      adsDocumentHeadersProviderDocumentId.AsString,
      adsDocumentHeadersLocalWriteTime.AsDateTime);
    if ReestrPrintSettingsForm.ShowModal = mrOk then begin
      internalReestrReportParams := ReestrPrintSettingsForm.ReestrReportParams;
      DoActionOnPrinted(PrintReestr);
    end;
  finally
    FreeAndNil(ReestrPrintSettingsForm);
  end;
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
  if not adsDocumentBodiesRejectId.IsNull then
    if adsDocumentBodiesRejectStatus.Value = '1' then
      Background := LegendHolder.Legends[lnRejectedWaybillPosition]
    else
      Background := LegendHolder.Legends[lnRejectedColor]
  else
    if adsDocumentBodiesRejectStatus.Value = '1' then
      Background := LegendHolder.Legends[lnUnrejectedWaybillPosition];

  if (retailMarkupField.Value < 0) then
    if AnsiMatchText(Column.FieldName,
        ['RetailMarkup', 'RetailPrice', 'RetailSumm', 'RealMarkup'])
    then
      Background := LegendHolder.Legends[lnRetailPrice];

  if (retailMarkupField.Value > maxRetailMarkupField.Value)
     and AnsiMatchText(Column.FieldName, ['RetailMarkup', 'MaxRetailMarkup'])
  then
    Background := LegendHolder.Legends[lnRetailMarkup];

  if not retailMarkupField.IsNull and (Column.Field = adsDocumentBodiesSupplierPriceMarkup) then
  begin
    if adsDocumentBodiesVitallyImportant.Value
    or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
    or (adsDocumentBodiesVitallyImportant.IsNull and adsDocumentBodiesVitallyImportantByUser.Value)
    then
      maxSupplierMarkup := GetMarkupValue(DM.GetMaxVitallyImportantSupplierMarkup(GetMinProducerCostForMarkup()), adsDocumentBodiesCatalogMaxSupplierMarkup)
    else begin
      if CalculateOnProducerCost then
        maxSupplierMarkup := GetMarkupValue(DM.GetMaxRetailSupplierMarkup(adsDocumentBodiesProducerCost.Value), adsDocumentBodiesCatalogMaxSupplierMarkup)
      else
        maxSupplierMarkup := GetMarkupValue(DM.GetMaxRetailSupplierMarkup(adsDocumentBodiesSupplierCostWithoutNDS.Value), adsDocumentBodiesCatalogMaxSupplierMarkup);
    end;
    if adsDocumentBodiesSupplierPriceMarkup.Value > maxSupplierMarkup then
      Background := LegendHolder.Legends[lnSupplierPriceMarkup];
  end;

  if (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
    or (not adsDocumentBodiesVitallyImportant.IsNull and adsDocumentBodiesVitallyImportant.AsBoolean)
    or (adsDocumentBodiesVitallyImportant.IsNull and adsDocumentBodiesVitallyImportantByUser.Value)
  then begin
    AFont.Color := LegendHolder.Legends[lnVitallyImportant];
    if (Column.Field = NDSField) and not NDSField.IsNull and (NDSField.Value <> 10)
    then
      Background := LegendHolder.Legends[lnNotSetNDS];
  end;

  if (Column.Field = adsDocumentBodiesCertificateId) then begin
    if not adsDocumentBodiesCertificateId.IsNull then begin
      AFont.Style := AFont.Style + [fsUnderline];
      AFont.Color := clHotLight;
    end
    else
      //���������� �� ��� �������, �� ������ ���
      if not adsDocumentBodiesDocumentBodyId.IsNull then
        Background := LegendHolder.Legends[lnCertificateNotFound];
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
  ReadSettings();
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
    adsDocumentBodies.SQL.Text := EtalonSQL;
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
    or (adsDocumentBodiesVitallyImportant.IsNull and adsDocumentBodiesVitallyImportantByUser.Value)
    then begin
      if not adsDocumentBodiesProducerCost.IsNull and (adsDocumentBodiesProducerCost.Value > 0)
      then begin
        if NeedLog then Tracer.TR('RecalcPosition', '��������� ������� ����� �� �����');
        if NeedLog then Tracer.TR('RecalcPosition', 'GetMinProducerCostForMarkup(): ' + FloatToStr(GetMinProducerCostForMarkup()));
        upCostVariant := GetMarkupValue(DM.GetVitallyImportantMarkup(GetMinProducerCostForMarkup()), adsDocumentBodiesCatalogMarkup);
      end
    end
    else begin
      if CalculateOnProducerCost then begin
        if not adsDocumentBodiesProducerCost.IsNull and (adsDocumentBodiesProducerCost.Value > 0)
        then begin
          if NeedLog then Tracer.TR('RecalcPosition', '��������� ������� ����� �� ��-����� ������������ ProducerCost');
          upCostVariant := GetMarkupValue(DM.GetRetUpCost(adsDocumentBodiesProducerCost.Value), adsDocumentBodiesCatalogMarkup);
        end
      end
      else begin
       if NeedLog then Tracer.TR('RecalcPosition', 'SupplierCostWithoutNDS: '  + adsDocumentBodiesSupplierCostWithoutNDS.AsString);
        if not adsDocumentBodiesSupplierCostWithoutNDS.IsNull
           and (adsDocumentBodiesSupplierCostWithoutNDS.Value > 0)
        then begin
          if NeedLog then Tracer.TR('RecalcPosition', '��������� ������� ����� �� ��-����� ������������ SupplierCostWithoutNDS');
          upCostVariant := GetMarkupValue(DM.GetRetUpCost(adsDocumentBodiesSupplierCostWithoutNDS.Value), adsDocumentBodiesCatalogMarkup);
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
    if sbRequestCertificates.Visible then
      UpdateRequestCertificates;
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
  if (adsDocumentBodies.State in FWaybillDataSetState) then begin
    if not retailMarkupField.IsNull then begin
      if AllowRealValue(Text) and (StrToFloatDef(Value, 0.0) > 0) then begin
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
      if AllowRealValue(Text) and (StrToFloatDef(Value, 0.0) > 0) then begin
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
  //���� ����������� ���� � ������, �� �������� �����
  if (dbgDocumentBodies.SelectedField is TFloatField)
  then begin
    if (Key in ['.', ',']) and (Key <> DecimalSeparator) then
      Key := DecimalSeparator;
  end;
  //���� �������� ������ ����� �� � ����������� ���������, �� ��������� � �������������� �������
  if not adsDocumentHeadersCreatedByUser.Value then
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
  if (adsDocumentBodies.State in FWaybillDataSetState) and not retailMarkupField.IsNull
  then begin
    if AllowRealValue(Text) and (StrToFloatDef(Value, 0.0) > 0) then begin
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
  supplierCostWithNDSMultiplier : Double;
begin
  if cbClearRetailPrice.Checked and (Abs(price - RoundToOneDigit(price)) > 0.001)
  then
    price := RoundToOneDigit(price);

  if adsDocumentBodiesVitallyImportant.Value
  or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
  or (adsDocumentBodiesVitallyImportant.IsNull and adsDocumentBodiesVitallyImportantByUser.Value)
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

    //���� c����� ��������������� ���� � ���� "CalculateWithNDSForOther" �������, �� ��������� = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDSForOther.Value then begin
      nonVitallyNDSMultiplier := 1;
      supplierCostWithNDSMultiplier := adsDocumentBodiesSupplierCostWithoutNDS.Value;
    end
    else begin
      nonVitallyNDSMultiplier := (1 + NDSField.Value/100);
      supplierCostWithNDSMultiplier := adsDocumentBodiesSupplierCost.Value;
    end;

    //�� ���� �������������
    if CalculateOnProducerCost then
      Result := ((price - adsDocumentBodiesSupplierCost.Value)*100)/(adsDocumentBodiesProducerCost.Value * nonVitallyNDSMultiplier)
    else
    //�� ���� ���������� ��� ���
      Result := ((price - adsDocumentBodiesSupplierCost.Value)*100)/(supplierCostWithNDSMultiplier);
  end;
end;

function TDocumentBodiesForm.GetRetailPriceByMarkup(
  var markup: Double): Double;
var
  vitallyNDS : Integer;
  vitallyNDSMultiplier : Double;
  nonVitallyNDSMultiplier : Double;
  supplierCostWithNDSMultiplier : Double;
begin
  if adsDocumentBodiesVitallyImportant.Value
  or (cbWaybillAsVitallyImportant.Checked and adsDocumentBodiesVitallyImportant.IsNull)
  or (adsDocumentBodiesVitallyImportant.IsNull and adsDocumentBodiesVitallyImportantByUser.Value)
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

    //���� c����� ��������������� ���� � ���� "CalculateWithNDSForOther" �������, �� ��������� = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDSForOther.Value then begin
      nonVitallyNDSMultiplier := 1;
      supplierCostWithNDSMultiplier := adsDocumentBodiesSupplierCostWithoutNDS.Value;
    end
    else begin
      nonVitallyNDSMultiplier := (1 + NDSField.Value/100);
      supplierCostWithNDSMultiplier := adsDocumentBodiesSupplierCost.Value;
    end;

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
      Result := adsDocumentBodiesSupplierCost.Value + supplierCostWithNDSMultiplier*(markup/100);

      if cbClearRetailPrice.Checked and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        markup := ((Result - adsDocumentBodiesSupplierCost.Value)*100)/(supplierCostWithNDSMultiplier);
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
  or (adsDocumentBodiesVitallyImportant.IsNull and adsDocumentBodiesVitallyImportantByUser.Value)
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
  if (adsDocumentBodies.State in FWaybillDataSetState) and not retailMarkupField.IsNull
  then begin
    if AllowRealValue(Text) and (StrToFloatDef(Value, 0.0) > 0) then begin
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
  WaybillPrintSettingsForm := TWaybillPrintSettingsForm.Create(Application);
  try
    WaybillPrintSettingsForm.UpdateParams(
      adsDocumentHeadersProviderDocumentId.AsString,
      adsDocumentHeadersLocalWriteTime.AsDateTime);
    if WaybillPrintSettingsForm.ShowModal = mrOk then begin
      internalWaybillReportParams := WaybillPrintSettingsForm.WaybillReportParams;
      DoActionOnPrinted(PrintWaybill);
    end;
  finally
    FreeAndNil(WaybillPrintSettingsForm);
  end;
end;

procedure TDocumentBodiesForm.sbPrintInvoiceClick(Sender: TObject);
var
  LastId : Int64;
  LastSort : String;
begin
  adsDocumentBodies.DisableControls;
  LastId := adsDocumentBodiesId.Value;
  LastSort := adsDocumentBodies.IndexFieldNames;
  adsDocumentBodies.IndexFieldNames := '';
  adsDocumentBodies.Close;
  adsDocumentBodies.SQL.Text := EtalonSQL;
  adsDocumentBodies.SQL.Text := adsDocumentBodies.SQL.Text
    + #13#10' group by dbodies.Id '
    + #13#10' order by dbodies.NDS, dbodies.Product ';
  adsDocumentBodies.Open;
  try
    PrintInvoice();
  finally
    adsDocumentBodies.Close;
    adsDocumentBodies.SQL.Text := EtalonSQL;
    AddNDSFilter();
    adsDocumentBodies.Open;
    if LastSort <> '' then
      adsDocumentBodies.IndexFieldNames := LastSort;
    if not adsDocumentBodies.Locate('Id', LastId, []) then
      adsDocumentBodies.First;
    adsDocumentBodies.EnableControls;
  end;
end;

function TDocumentBodiesForm.GetMinProducerCost: Double;
begin
  Result := GetMinProducerCostByField(adsDocumentBodiesRegistryCost, adsDocumentBodiesProducerCost);
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
  supplierCostField,
  quantityField : TField;
begin
  Result := 0;
  supplierCostField := mdReport.FindField('SupplierCost');
  quantityField := mdReport.FindField('Quantity');
  mdReport.DisableControls;
  Mark := mdReport.Bookmark;
  try
    mdReport.First;
    while not mdReport.Eof do begin
      Result := Result + supplierCostField.AsFloat * quantityField.AsInteger;
      mdReport.Next;
    end;
  finally
    mdReport.Bookmark := Mark;
    mdReport.EnableControls;
  end;

end;

procedure TDocumentBodiesForm.DoActionOnPrinted(Action: TThreadMethod);
var
  LastId : Int64;
  calculation : TWaybillCalculation;
begin
  mdReport := TRxMemoryData.Create(Self);
  try
    adsDocumentBodies.DisableControls;
    LastId := adsDocumentBodiesId.Value;
    adsDocumentBodies.Close;
    adsDocumentBodies.SQL.Text := EtalonSQL;
    adsDocumentBodies.SQL.Text := adsDocumentBodies.SQL.Text
      + #13#10' and dbodies.Printed = 1 ';
    AddNDSFilter();
    adsDocumentBodies.Open;
    try
      mdReport.CopyStructure(adsDocumentBodies);

      TDataSetHelper.SetDisplayFormat(
        mdReport,
        [
          'ProducerCost',
          'RegistryCost',
          'SupplierPriceMarkup',
          'SupplierCostWithoutNDS',
          'SupplierCost',
          'RetailMarkup',
          'ManualRetailPrice',
          'RetailAmount'
        ]);

      calculation := TWaybillCalculation.Create(
        mdReport,
        cbWaybillAsVitallyImportant.Checked,
        FParams.UseProducerCostWithNDS,
        CalculateOnProducerCost,
        cbClearRetailPrice.Checked);

      mdReport.LoadFromDataSet(adsDocumentBodies, 0, lmAppend);
    finally
      adsDocumentBodies.Close;
      adsDocumentBodies.SQL.Text := EtalonSQL;
      AddNDSFilter();
      adsDocumentBodies.Open;
      if not adsDocumentBodies.Locate('Id', LastId, []) then
        adsDocumentBodies.First;
      adsDocumentBodies.EnableControls;
    end;


    try

      Action();

    finally
      calculation.Free;
    end;

  finally
    mdReport.Free;
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

    mdReport.First;
    rowNumber := 1;
    while not mdReport.Eof do begin
      exportData.WriteRow([
        IntToStr(rowNumber),
        mdReport.FieldByName('Product').AsString,
        mdReport.FieldByName('SerialNumber').AsString + ' ' + mdReport.FieldByName('Certificates').AsString,
        mdReport.FieldByName('Period').AsString,
        mdReport.FieldByName('Producer').AsString,
        mdReport.FieldByName('ProducerCost').AsString,
        mdReport.FieldByName('Quantity').AsString,
        mdReport.FieldByName('SupplierPriceMarkup').DisplayText,
        mdReport.FieldByName('SupplierCostWithoutNDS').DisplayText,
        mdReport.FieldByName('NDS').AsString,
        mdReport.FieldByName('SupplierCost').DisplayText,
        mdReport.FieldByName('RetailMarkup').DisplayText,
        mdReport.FieldByName('RetailPrice').DisplayText,
        mdReport.FieldByName('Quantity').AsString,
        mdReport.FieldByName('RetailSumm').DisplayText
        ]);

      Inc(rowNumber);
      mdReport.Next;
    end;
  finally
    exportData.Free;
  end;

{
  ShellExecute(
    0,
    'Open',
    PChar(exportFile),
    nil, nil, SW_SHOWNORMAL);
}    

  FileExecute(exportFile);
end;

procedure TDocumentBodiesForm.PrintRackCard;
var
  RackCardReportParams : TRackCardReportParams;
  rackCardReportFile : String;
begin
  RackCardReportParams := TRackCardReportParams.Create(DM.MainConnection);
  try
    frVariables[ 'DeleteUnprintableElemnts'] := RackCardReportParams.DeleteUnprintableElemnts;
    frVariables[ 'ClientNameAndAddress'] := DM.GetEditNameAndAddress;
    frVariables[ 'ProviderDocumentId'] := adsDocumentHeadersProviderDocumentId.AsString;
    frVariables[ 'DocumentDate'] := IfThen(not adsDocumentHeadersLocalWriteTime.IsNull, DateToStr(adsDocumentHeadersLocalWriteTime.AsDateTime));
    frVariables[ 'ProviderName'] := Trim(adsDocumentHeadersProviderShortName.AsString);

    frVariables['ProductVisible'] := RackCardReportParams.ProductVisible;
    frVariables['ProducerVisible'] := RackCardReportParams.ProducerVisible;
    frVariables['SerialNumberVisible'] := RackCardReportParams.SerialNumberVisible;
    frVariables['PeriodVisible'] := RackCardReportParams.PeriodVisible;
    frVariables['QuantityVisible'] := RackCardReportParams.QuantityVisible;
    frVariables['ProviderVisible'] := RackCardReportParams.ProviderVisible;
    frVariables['CostVisible'] := RackCardReportParams.CostVisible;
    frVariables['CertificatesVisible'] := RackCardReportParams.CertificatesVisible;
    frVariables['DateOfReceiptVisible'] := RackCardReportParams.DateOfReceiptVisible;

    case RackCardReportParams.RackCardSize of
      rcsStandart : rackCardReportFile := 'RackCard.frf';
      rcsBig : rackCardReportFile := 'BigRackCard.frf';
      rcsRackCard2 : rackCardReportFile := 'RackCard2.frf';
      else
        rackCardReportFile := '����������� �����.frf';
    end;

    DM.ShowFastReportWithSave(
      rackCardReportFile,
      mdReport,
      True);
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

    mdReport.First;
    rowNumber := 1;
    while not mdReport.Eof do begin
      exportData.WriteRow([
        IntToStr(rowNumber),
        mdReport.FieldByName('Product').AsString,
        mdReport.FieldByName('SerialNumber').AsString,
        mdReport.FieldByName('Period').AsString,
        mdReport.FieldByName('Producer').AsString,
        mdReport.FieldByName('ProducerCost').AsString,
        mdReport.FieldByName('RegistryCost').AsString,
        mdReport.FieldByName('SupplierPriceMarkup').DisplayText,
        mdReport.FieldByName('SupplierCostWithoutNDS').DisplayText,
        mdReport.FieldByName('NDS').AsString,
        mdReport.FieldByName('SupplierCost').DisplayText,
        mdReport.FieldByName('RetailMarkup').DisplayText,
        mdReport.FieldByName('RetailPrice').DisplayText,
        mdReport.FieldByName('Quantity').AsString,
        mdReport.FieldByName('RetailSumm').DisplayText
        ]);

      Inc(rowNumber);
      mdReport.Next;
    end;
  finally
    exportData.Free;
  end;

{
  ShellExecute(
    0,
    'Open',
    PChar(exportFile),
    nil, nil, SW_SHOWNORMAL);
}

  FileExecute(exportFile);
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

  frVariables[ 'Director'] := DM.adtClientsDirector.AsString;
  frVariables[ 'DeputyDirector'] := DM.adtClientsDeputyDirector.AsString;
  frVariables[ 'Accountant'] := DM.adtClientsAccountant.AsString;

  frVariables[ 'TotalRetailSumm'] := totalRetailSumm;
  frVariables[ 'TotalRetailSummText'] := AnsiLowerCase(MoneyToString(totalRetailSumm, True, False));

  frVariables[ 'InvoiceNumber'] := adsInvoiceHeaders['InvoiceNumber'];
  frVariables[ 'InvoiceDate'] := adsInvoiceHeaders['InvoiceDate'];

  frVariables[ 'SellerName'] := adsInvoiceHeaders['SellerName'];
  frVariables[ 'SellerAddress'] := adsInvoiceHeaders['SellerAddress'];
  frVariables[ 'SellerINN'] := adsInvoiceHeaders['SellerINN'];
  frVariables[ 'SellerKPP'] := adsInvoiceHeaders['SellerKPP'];

  frVariables[ 'ShipperInfo'] := adsInvoiceHeaders['ShipperInfo'];
  frVariables[ 'ConsigneeInfo'] := adsInvoiceHeaders['ConsigneeInfo'];
  frVariables[ 'PaymentDocumentInfo'] := adsInvoiceHeaders['PaymentDocumentInfo'];

  frVariables[ 'BuyerName'] := adsInvoiceHeaders['BuyerName'];
  frVariables[ 'BuyerAddress'] := adsInvoiceHeaders['BuyerAddress'];
  frVariables[ 'BuyerINN'] := adsInvoiceHeaders['BuyerINN'];
  frVariables[ 'BuyerKPP'] := adsInvoiceHeaders['BuyerKPP'];

  frVariables[ 'BuyerName'] := adsInvoiceHeaders['BuyerName'];
  frVariables[ 'BuyerAddress'] := adsInvoiceHeaders['BuyerAddress'];
  frVariables[ 'BuyerINN'] := adsInvoiceHeaders['BuyerINN'];
  frVariables[ 'BuyerKPP'] := adsInvoiceHeaders['BuyerKPP'];

  frVariables[ 'AmountWithoutNDS0'] := adsInvoiceHeaders['AmountWithoutNDS0'];

  frVariables[ 'AmountWithoutNDS10'] := adsInvoiceHeaders['AmountWithoutNDS10'];
  frVariables[ 'NDSAmount10'] := adsInvoiceHeaders['NDSAmount10'];
  frVariables[ 'Amount10'] := adsInvoiceHeaders['Amount10'];

  frVariables[ 'AmountWithoutNDS18'] := adsInvoiceHeaders['AmountWithoutNDS18'];
  frVariables[ 'NDSAmount18'] := adsInvoiceHeaders['NDSAmount18'];
  frVariables[ 'Amount18'] := adsInvoiceHeaders['Amount18'];

  frVariables[ 'TotalAmountWithoutNDS'] := adsInvoiceHeaders['AmountWithoutNDS'];
  frVariables[ 'TotalNDSAmount'] := adsInvoiceHeaders['NDSAmount'];
  frVariables[ 'TotalAmount'] := adsInvoiceHeaders['Amount'];

  DM.ShowFastReportWithSave('Invoice.frf', adsDocumentBodies, True);
end;

procedure TDocumentBodiesForm.PrintWaybill;
var
  totalRetailSumm : Currency;
  totatSupplierSumm : Currency;
  V: array[0..0] of Variant;
begin
  DBProc.DataSetCalc(mdReport, ['Sum(RetailSumm)'], V);
  totalRetailSumm := V[0];
  totatSupplierSumm := GetTotalSupplierSumm();

  frVariables[ 'ClientNameAndAddress'] := DM.GetEditNameAndAddress;
  frVariables[ 'ProviderName'] := Trim(adsDocumentHeadersProviderShortName.AsString);
  frVariables[ 'ProviderDocumentId'] := internalWaybillReportParams.WaybillNumber;
  frVariables[ 'DocumentDate'] := DateToStr(internalWaybillReportParams.WaybillDate);

  frVariables[ 'ReestrNumber'] := '17';
  frVariables[ 'ReestrAppend'] := '5';

  frVariables[ 'Director'] := DM.adtClientsDirector.AsString;
  frVariables[ 'DeputyDirector'] := DM.adtClientsDeputyDirector.AsString;
  frVariables[ 'Accountant'] := DM.adtClientsAccountant.AsString;

  frVariables[ 'TotalRetailSumm'] := totalRetailSumm;
  frVariables[ 'TotalRetailSummText'] := AnsiLowerCase(MoneyToString(totalRetailSumm, True, False));

  frVariables[ 'TotalSupplierSumm'] := totatSupplierSumm;
  frVariables[ 'TotalSupplierSummText'] := AnsiLowerCase(MoneyToString(totatSupplierSumm, True, False));

  frVariables[ 'ByWhomName'] := internalWaybillReportParams.ByWhomName;
  frVariables[ 'RequestedName'] := internalWaybillReportParams.RequestedName;
  frVariables[ 'ServeName'] := internalWaybillReportParams.ServeName;
  frVariables[ 'ReceivedName'] := internalWaybillReportParams.ReceivedName;

  DM.ShowFastReportWithSave(
    'Waybill.frf',
    mdReport,
    True);
end;

procedure TDocumentBodiesForm.PrintReestr;
var
  totalRetailSumm : Currency;
  totatSupplierSumm : Currency;
  V: array[0..0] of Variant;
begin
  DBProc.DataSetCalc(mdReport, ['Sum(RetailSumm)'], V);
  totalRetailSumm := V[0];
  totatSupplierSumm := GetTotalSupplierSumm();

  frVariables[ 'ClientNameAndAddress'] := DM.GetEditNameAndAddress;
  frVariables[ 'ProviderName'] := adsDocumentHeadersProviderName.AsString;
  frVariables[ 'ProviderDocumentId'] := adsDocumentHeadersProviderDocumentId.AsString;
  frVariables[ 'DocumentDate'] := DateToStr(adsDocumentHeadersLocalWriteTime.AsDateTime);

  frVariables[ 'ReestrNumber'] := '17';
  frVariables[ 'ReestrAppend'] := '5';

  frVariables[ 'ReestrNumberId'] := internalReestrReportParams.GetReestrNumber();
  frVariables[ 'ReestrDate'] := DateToStr(internalReestrReportParams.ReestrDate);

  frVariables[ 'Director'] := DM.adtClientsDirector.AsString;
  frVariables[ 'DeputyDirector'] := DM.adtClientsDeputyDirector.AsString;
  frVariables[ 'Accountant'] := DM.adtClientsAccountant.AsString;

  frVariables[ 'TotalRetailSumm'] := totalRetailSumm;
  frVariables[ 'TotalRetailSummText'] := AnsiLowerCase(MoneyToString(totalRetailSumm, True, False));

  frVariables[ 'TotalSupplierSumm'] := totatSupplierSumm;
  frVariables[ 'TotalSupplierSummText'] := AnsiLowerCase(MoneyToString(totatSupplierSumm, True, False));

  frVariables[ 'CommitteeMember1'] := internalReestrReportParams.CommitteeMember1;
  frVariables[ 'CommitteeMember2'] := internalReestrReportParams.CommitteeMember2;
  frVariables[ 'CommitteeMember3'] := internalReestrReportParams.CommitteeMember3;

  DM.ShowFastReportWithSave(
    'Reestr.frf',
    mdReport,
    True);
end;

procedure TDocumentBodiesForm.PrintTickets;
var
  TicketParams : TTicketReportParams;
  ticketReportFile : String;
begin
  TicketParams := TTicketReportParams.Create(DM.MainConnection);
  try
    frVariables[ 'PrintEmptyTickets'] := TicketParams.PrintEmptyTickets;
    frVariables[ 'ClientNameAndAddress'] := DM.GetEditNameAndAddress;
    frVariables[ 'ProviderDocumentId'] := adsDocumentHeadersProviderDocumentId.AsString;
    frVariables[ 'DocumentDate'] := DateToStr(adsDocumentHeadersLocalWriteTime.AsDateTime);
    frVariables[ 'TicketSignature'] := Trim(adsDocumentHeadersProviderShortName.AsString);
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

    case TicketParams.TicketSize of
      tsStandart : ticketReportFile := 'Ticket.frf';
      tsSmall : ticketReportFile := 'SmallTicket.frf';
      tsSmallWithBigCost : ticketReportFile := 'BigCostTicket.frf';
      tsSmallWithBigCost2 : ticketReportFile := 'BigCostTicket2.frf';
      else
        ticketReportFile := '����������� �����.frf';
    end;

    DM.ShowFastReportWithSave(
      ticketReportFile,
      mdReport,
      True);
  finally
    TicketParams.Free;
  end;
end;

procedure TDocumentBodiesForm.CreateLegenPanel;
var
  lLegend : TLabel;
begin
  pButtons := TPanel.Create(Self);
  pButtons.Parent := Self;
  pButtons.Name := 'pButtons';
  pButtons.Caption := '';
  pButtons.BevelOuter := bvNone;
  pButtons.Align := alBottom;
  pButtons.Height := sbPrintTickets.Height + 15;


  sbAdd := TSpeedButton.Create(Self);
  sbAdd.Parent := pButtons;
  sbAdd.Top := 8;
  sbAdd.Left := 5;
  sbAdd.Caption := '�������� ������ (Insert)';
  sbAdd.Width := Self.Canvas.TextWidth(sbAdd.Caption) + 20;
  sbAdd.OnClick := sbAddRowClick;

  sbDelete := TSpeedButton.Create(Self);
  sbDelete.Parent := pButtons;
  sbDelete.Top := 8;
  sbDelete.Left := sbAdd.Left + sbAdd.Width + 5;
  sbDelete.Caption := '������� ������ (Delete)';
  sbDelete.Width := Self.Canvas.TextWidth(sbDelete.Caption) + 20;
  sbDelete.OnClick := sbDeleteRowClick;

  sbRequestCertificates := TSpeedButton.Create(Self);
  sbRequestCertificates.Parent := pButtons;
  sbRequestCertificates.Top := 8;
  sbRequestCertificates.Left := sbAdd.Left;
  sbRequestCertificates.Caption := '�������� �����������';
  sbRequestCertificates.Width := Self.Canvas.TextWidth(sbRequestCertificates.Caption) + 20;
  sbRequestCertificates.OnClick := sbRequestCertificatesClick;

{$ifdef DEBUG}
  sbMarkAsReject := TSpeedButton.Create(Self);
  sbMarkAsReject.Parent := pButtons;
  sbMarkAsReject.Top := 8;
  sbMarkAsReject.Left := sbRequestCertificates.Left + sbRequestCertificates.Width + 10;
  sbMarkAsReject.Caption := '�������� ��� ����������';
  sbMarkAsReject.Width := Self.Canvas.TextWidth(sbMarkAsReject.Caption) + 20;
  sbMarkAsReject.OnClick := sbMarkAsRejectClick;

  sbMarkAsUnReject := TSpeedButton.Create(Self);
  sbMarkAsUnReject.Parent := pButtons;
  sbMarkAsUnReject.Top := 8;
  sbMarkAsUnReject.Left := sbMarkAsReject.Left + sbMarkAsReject.Width + 10;
  sbMarkAsUnReject.Caption := '�������� ��� �����������';
  sbMarkAsUnReject.Width := Self.Canvas.TextWidth(sbMarkAsUnReject.Caption) + 20;
  sbMarkAsUnReject.OnClick := sbMarkAsUnRejectClick;

  sbMarkAsOrder1 := TSpeedButton.Create(Self);
  sbMarkAsOrder1.Parent := pButtons;
  sbMarkAsOrder1.Top := 8;
  sbMarkAsOrder1.Left := sbMarkAsUnReject.Left + sbMarkAsUnReject.Width + 10;
  sbMarkAsOrder1.Caption := '����������� � 1';
  sbMarkAsOrder1.Width := Self.Canvas.TextWidth(sbMarkAsOrder1.Caption) + 20;
  sbMarkAsOrder1.OnClick := sbMarkAsOrder1Click;

  sbMarkAsOrder2 := TSpeedButton.Create(Self);
  sbMarkAsOrder2.Parent := pButtons;
  sbMarkAsOrder2.Top := 8;
  sbMarkAsOrder2.Left := sbMarkAsOrder1.Left + sbMarkAsOrder1.Width + 10;
  sbMarkAsOrder2.Caption := '����������� � 2';
  sbMarkAsOrder2.Width := Self.Canvas.TextWidth(sbMarkAsOrder2.Caption) + 20;
  sbMarkAsOrder2.OnClick := sbMarkAsOrder2Click;

  sbDeleteMarks := TSpeedButton.Create(Self);
  sbDeleteMarks.Parent := pButtons;
  sbDeleteMarks.Top := 8;
  sbDeleteMarks.Left := sbMarkAsOrder2.Left + sbMarkAsOrder2.Width + 10;
  sbDeleteMarks.Caption := '������� �������������';
  sbDeleteMarks.Width := Self.Canvas.TextWidth(sbDeleteMarks.Caption) + 20;
  sbDeleteMarks.OnClick := sbDeleteMarksClick;
{$endif}

  legeng := TframeBaseLegend.Create(Self);
  legeng.PrepareMinWidth;
  legeng.Parent := pGrid;
  legeng.Align := alBottom;

  lLegend := legeng.CreateLegendLabel(lnNotSetNDS);

  lLegend := legeng.CreateLegendLabel(lnSupplierPriceMarkup);

  lLegend := legeng.CreateLegendLabel(lnRetailMarkup);

  lLegend := legeng.CreateLegendLabel(lnRetailPrice);

  lLegend := legeng.CreateLegendLabel(lnCertificateNotFound);

  lLegend := legeng.CreateLegendLabel(lnRejectedColor);

  lLegend := legeng.CreateLegendLabel(lnRejectedWaybillPosition);

  lLegend := legeng.CreateLegendLabel(lnUnrejectedWaybillPosition);

  legeng.UpdateGrids := UpdateGridOnLegend;
end;

procedure TDocumentBodiesForm.adsDocumentBodiesPrintedChange(
  Sender: TField);
begin
  if (Sender = adsDocumentBodiesRequestCertificate) and adsDocumentBodiesRequestCertificate.Value
  then
    DM.InsertUserActionLog(
      uaRequestCertificate,
      ['�������: ' + adsDocumentBodiesServerId.AsString]);
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
var
  filter : String;
begin
  filter := GetNDSFilter();
  if Length(filter) > 0 then
    adsDocumentBodies.SQL.Text := adsDocumentBodies.SQL.Text  + ' and ' + filter ;
  if not adsDocumentHeadersCreatedByUser.Value then
    adsDocumentBodies.SQL.Text := adsDocumentBodies.SQL.Text  + #13#10' group by dbodies.Id ';
end;

procedure TDocumentBodiesForm.ForceRecalcDocument(DocumentId: Int64);
begin
  FDocumentId := DocumentId;
  SetParams;
end;

function TDocumentBodiesForm.GetMinProducerCostByField(RegistryCost,
  ProducerCost: TFloatField): Double;
begin
  if not RegistryCost.IsNull
    and (RegistryCost.Value > 0)
    and (RegistryCost.Value < ProducerCost.Value)
  then
    Result := RegistryCost.Value
  else
    Result := ProducerCost.Value;
end;

procedure TDocumentBodiesForm.FormDestroy(Sender: TObject);
begin
  FParams.Free;
  FContextMenuGrid.Free;
  inherited;
end;

function TDocumentBodiesForm.GetMinProducerCostByFieldForMarkup(
  RegistryCost, ProducerCost: TFloatField; NDSValue : TField): Double;
var
  minProducerCost : Double;
begin
  minProducerCost := GetMinProducerCostByField(RegistryCost, ProducerCost);
  if FParams.UseProducerCostWithNDS then
    minProducerCost := minProducerCost * (1 + NDSValue.AsInteger/100);
  Result := minProducerCost;
end;

function TDocumentBodiesForm.GetMinProducerCostForMarkup: Double;
begin
  Result := GetMinProducerCostByFieldForMarkup(
    adsDocumentBodiesRegistryCost,
    adsDocumentBodiesProducerCost,
    NDSField); 
end;

procedure TDocumentBodiesForm.ReadSettings;
begin
  CalculateOnProducerCost := DM.adsUser.FieldByName('CalculateOnProducerCost').AsBoolean;
  FParams.ReadParams;
end;

procedure TDocumentBodiesForm.adsDocumentBodiesCertificateIdGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if DisplayText and not Sender.IsNull then
    Text := '��������';
end;

procedure TDocumentBodiesForm.WaybillCellClick(Column: TColumnEh);
begin
  if (Column.Field = adsDocumentBodiesCertificateId) and not adsDocumentBodiesCertificateId.IsNull then
    DM.OpenCertificateFiles(adsDocumentBodiesCertificateId.Value);
end;

procedure TDocumentBodiesForm.adsDocumentBodiesRequestCertificateValidate(
  Sender: TField);
begin
  if Sender.AsBoolean then
    if not DM.CertificateSourceExists(adsDocumentBodiesServerId.Value) then begin
      tmrShowCertificateWarning.Enabled := False;
      tmrShowCertificateWarning.Enabled := true;
      Abort;
    end;
end;

procedure TDocumentBodiesForm.tmrShowCertificateWarningTimer(
  Sender: TObject);
begin
  tmrShowCertificateWarning.Enabled := False;
  DM.ShowCertificateWarning();
end;

procedure TDocumentBodiesForm.UserWaybillNewRecord(DataSet: TDataSet);
begin
  adsDocumentBodiesDocumentId.Value := FDocumentId;
  adsDocumentBodiesProduct.Value := '����� ������� ���������';
  //adsDocumentBodiesVitallyImportant.Value := False;
  //adsDocumentBodiesPrinted.Value := True;
  //adsDocumentBodiesRequestCertificate.Value := False;
  manualCorrectionField.Value := False;
end;

procedure TDocumentBodiesForm.ProductUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
begin
  if (adsDocumentBodies.State in FWaybillDataSetState)
  then begin
    TDBGridColumnEh(Sender).Field.AsVariant := Value;
    adsDocumentBodies.Post;
    Handled := True;
  end;
end;

function TDocumentBodiesForm.GetMarkupValue(afValue: Currency;
  individualMarkup: TFloatField): Currency;
begin
  if not individualMarkup.IsNull then
    Result := individualMarkup.Value
  else
    Result := afValue;
end;

procedure TDocumentBodiesForm.UserWaybillBeforePost(DataSet: TDataSet);
begin
  RecalcPosition;
end;

procedure TDocumentBodiesForm.UserWaybillAfterNewRecord(DataSet: TDataSet);
begin
  dbgDocumentBodies.SelectedField := adsDocumentBodiesProduct;
end;

procedure TDocumentBodiesForm.UserWaybillIntegerUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  changedValue : Integer;
begin
  if (adsDocumentBodies.State in FWaybillDataSetState)
  then begin
    if (Sender is TDBGridColumnEh) and TryStrToInt(Text, changedValue) then begin
      TDBGridColumnEh(Sender).Field.AsInteger := changedValue;
      if not adsDocumentBodiesQuantity.IsNull and not manualRetailPriceField.IsNull
      then
        retailAmountField.Value := RoundTo(manualRetailPriceField.Value, -2) * adsDocumentBodiesQuantity.Value;
      RecalcPosition;
      adsDocumentBodies.Post;
    end
    else
      adsDocumentBodies.Cancel;
    Handled := True;
  end;
end;

procedure TDocumentBodiesForm.UserWaybillFloatUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  changedValue : Double;
begin
  if (adsDocumentBodies.State in FWaybillDataSetState)
  then begin
    if (Sender is TDBGridColumnEh) and AllowRealValue(Text)
      and TryStrToFloat(Text, changedValue)
    then begin
      TDBGridColumnEh(Sender).Field.AsFloat := changedValue;
      RecalcPosition;
      adsDocumentBodies.Post;
    end
    else
      adsDocumentBodies.Cancel;
    Handled := True;
  end;
end;

function TDocumentBodiesForm.AllowRealValue(text: String): Boolean;
begin
  Result := Length(text) < 7;
end;

procedure TDocumentBodiesForm.sbAddRowClick(Sender: TObject);
begin
  adsDocumentBodies.Insert;
end;

procedure TDocumentBodiesForm.sbDeleteRowClick(Sender: TObject);
begin
  if not adsDocumentBodies.IsEmpty then
    adsDocumentBodies.Delete;
end;

procedure TDocumentBodiesForm.SetOrderByPosition;
begin
  lSumOrder.Caption := '';

  if adsOrder.Active then
    adsOrder.Close;

  if adsOrdersHForm.Active then
    adsOrdersHForm.Close;

  if adsDocumentBodies.Active and not adsDocumentBodies.IsEmpty and not adsDocumentBodiesOrderId.IsNull
  then begin
    lSumOrder.Caption := Format('%0.2f', [ DM.GetSumOrder(adsDocumentBodiesOrderId.Value, True) ]);
    adsOrdersHForm.ParamByName('OrderId').Value := adsDocumentBodiesOrderId.Value;
    adsOrdersHForm.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
    adsOrdersHForm.Open;
    adsOrder.ParamByName('OrderId').Value := adsDocumentBodiesOrderId.Value;
    adsOrder.Open;
    if not adsOrder.Locate('ServerDocumentLineId', adsDocumentBodiesServerId.AsVariant, []) then
      adsOrder.First;
  end;

  if adsOrder.Active and not adsOrder.IsEmpty then begin
    pNotFound.Visible := False;
    pOrderGrid.Visible := True;
  end
  else begin
    pNotFound.Visible := True;
    pOrderGrid.Visible := False;
  end;
end;

procedure TDocumentBodiesForm.SetOrderGrid;
var
  column : TColumnEh;
begin
  pFrameOrder.Visible := False;
  pFrameOrder.Height := 150;

  TDBGridHelper.SetDefaultSettingsToGrid(dbgOrder);

  dbgOrder.AutoFitColWidths := False;
  try
    TDBGridHelper.AddColumn(dbgOrder, 'SynonymName', '������������', 0);
    TDBGridHelper.AddColumn(dbgOrder, 'SynonymFirm', '�������������', 0);
    TDBGridHelper.AddColumn(dbgOrder, 'Period', '���� ��������', 0);
    column := TDBGridHelper.AddColumn(dbgOrder, 'RealPrice', '����', '0.00;;''''', 0);
    column.Font.Style := column.Font.Style + [fsBold]; 
    TDBGridHelper.AddColumn(dbgOrder, 'OrderCount', '�����', 0);
    TDBGridHelper.AddColumn(dbgOrder, 'RetailSumm', '�����', '0.00;;''''', 0);
  finally
    dbgOrder.AutoFitColWidths := True;
  end;

  dbgOrder.ReadOnly := False;

  dbgOrder.DataSource := dsOrder;
end;

procedure TDocumentBodiesForm.tmrShowMatchOrderTimer(Sender: TObject);
begin
  tmrShowMatchOrder.Enabled := False;
  SetOrderByPosition;
end;

procedure TDocumentBodiesForm.UpdateMatchOrderTimer;
begin
  if pFrameOrder.Visible then begin
    tmrShowMatchOrder.Enabled := False;
    tmrShowMatchOrder.Enabled := True;
  end;
end;

procedure TDocumentBodiesForm.adsDocumentBodiesAfterScroll(
  DataSet: TDataSet);
begin
  UpdateMatchOrderTimer;
  if dbgDocumentBodies.Visible and (adsDocumentHeadersDocumentType.Value = 1) then
    if adsDocumentBodies.Active and not adsDocumentBodies.IsEmpty
    then begin
      if not adsDocumentBodiesRejectId.IsNull then
        frameRejectedPosition.ShowReject(adsDocumentBodiesRejectId.Value)
      else
        frameRejectedPosition.HideReject();
    end
    else
      frameRejectedPosition.HideReject();
end;

procedure TDocumentBodiesForm.adsDocumentBodiesAfterOpen(
  DataSet: TDataSet);
begin
  UpdateMatchOrderTimer;
  UpdateSelectState;
end;

procedure TDocumentBodiesForm.tmRunRequestCertificateTimer(
  Sender: TObject);
begin
  tmRunRequestCertificate.Enabled := False;
  MainForm.actWayBill.Execute;
end;

procedure TDocumentBodiesForm.sbRequestCertificatesClick(Sender: TObject);
begin
  tmRunRequestCertificate.Enabled := True;
end;

procedure TDocumentBodiesForm.UpdateRequestCertificates;
var
  requestCount : Integer;
begin
  try
    requestCount := DM.QueryValue('SELECT COUNT(Id) AS newMailCount FROM DocumentBodies where RequestCertificate = 1', [], []);
  except
    requestCount := 0;
  end;
  sbRequestCertificates.Enabled := requestCount > 0;
end;

procedure TDocumentBodiesForm.UpdateSelectState;
var
  filter : String;
  allLinesCount,
  printedLinesCount : Integer;
begin
  if adsDocumentHeadersDocumentType.Value = 1 then begin
    if Self.Visible then begin
      cbSelect.Visible := adsDocumentBodies.RecordCount > 0;

      TCheckBoxEx(cbSelect).ClicksDisabled := True;
      try
        if adsDocumentBodies.RecordCount = 0 then
          cbSelect.State := cbUnchecked
        else begin
          printedLinesCount := GetPrintedDocumentLineCount();
          if printedLinesCount = 0 then
            cbSelect.State := cbUnchecked
          else if printedLinesCount = adsDocumentBodies.RecordCount then
            cbSelect.State := cbChecked
          else
            cbSelect.State := cbGrayed;
        end;
      finally
        TCheckBoxEx(cbSelect).ClicksDisabled := False;
      end;
    end;
  end;
end;

procedure TDocumentBodiesForm.WaybillDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  rowHeigth : Integer;
begin
  if (Column.Field = adsDocumentBodiesPrinted) then begin
    rowHeigth := Rect.Bottom - Rect.Top;
    cbSelect.Left := dbgDocumentBodies.Left + Rect.Left + 1;
    cbSelect.Top := dbgDocumentBodies.Top + (rowHeigth - cbSelect.Height) div 2;
  end;
end;

procedure TDocumentBodiesForm.adsDocumentBodiesAfterDelete(
  DataSet: TDataSet);
begin
  UpdateSelectState;
end;

procedure TDocumentBodiesForm.adsDocumentBodiesAfterPost(
  DataSet: TDataSet);
begin
  UpdateSelectState;
end;

procedure TDocumentBodiesForm.cbSelectClick(Sender: TObject);
begin
  inherited;
  dbgDocumentBodies.SetFocus();
  SetPrintedOnDocumentLines(cbSelect.Checked);
end;

function TDocumentBodiesForm.GetNDSFilter: String;
begin
  Result := '';
  if cbNDS.ItemIndex > 0 then
    if NDSNullValue = cbNDS.Items[cbNDS.ItemIndex] then
      Result := 'dbodies.NDS is null'
    else
      Result := 'dbodies.NDS = ' + cbNDS.Items[cbNDS.ItemIndex];
end;

function TDocumentBodiesForm.GetDocumentLineCount(ndsFilter,
  additionFilter: String): Integer;
begin
  Result := 0;
end;

function TDocumentBodiesForm.GetPrintedDocumentLineCount: Integer;
var
  filter : String;
  sql : String;
  count : Variant;
begin
  Result := 0;
  sql := 'select count(dbodies.Id) from DocumentBodies dbodies where dbodies.DocumentId = :DocumentId and dbodies.Printed = 1 ';
  filter := GetNDSFilter();
  if Length(filter) > 0 then
    sql :=  sql + ' and ' + filter;

  count := DBProc.QueryValue(
    DM.MainConnection,
    sql,
    ['DocumentId'],
    [FDocumentId]);

  if not VarIsNull(count) then
    Result := count;
end;

procedure TDocumentBodiesForm.SetPrintedOnDocumentLines(value: Boolean);
var
  LastId : Int64;
begin
  adsDocumentBodies.DisableControls;
  try
    LastId := adsDocumentBodiesId.Value;
    adsDocumentBodies.First;
    while not adsDocumentBodies.Eof do begin
      adsDocumentBodies.Edit;
      adsDocumentBodiesPrinted.Value := value;
      adsDocumentBodies.Post;
      adsDocumentBodies.Next;
    end;

    if not adsDocumentBodies.Locate('Id', LastId, []) then
      adsDocumentBodies.First;
  finally
    adsDocumentBodies.EnableControls;
  end;
end;

procedure TDocumentBodiesForm.UpdateGridOnLegend(Sender: TObject);
begin
  dbgDocumentBodies.Invalidate;
end;

{$ifdef DEBUG}
procedure TDocumentBodiesForm.sbMarkAsRejectClick(Sender: TObject);
var
  rejectId : String;
begin
  rejectId := DM.QueryValue('select Id from rejects limit 1', [], []);
  DM.MainConnection.ExecSQL('update documentBodies set LastRejectStatusTime = now(), RejectId = ' + rejectId + ' where Id = ' + adsDocumentBodiesId.AsString, []);
end;

procedure TDocumentBodiesForm.sbMarkAsUnRejectClick(Sender: TObject);
begin
  DM.MainConnection.ExecSQL('update documentBodies set LastRejectStatusTime = now() where Id = ' + adsDocumentBodiesId.AsString, []);
end;

procedure TDocumentBodiesForm.sbDeleteMarksClick(Sender: TObject);
var
  deleteCount : Integer;
begin
  WriteExchangeLog('sbDeleteMarksClick', '������� ������������� ��� adsDocumentBodiesServerId=' + adsDocumentBodiesServerId.AsString);
  deleteCount := DBProc.UpdateValue(DM.MainConnection,
    'delete from waybillOrders where waybillOrders.ServerDocumentLineId = :ServerId',
    ['ServerId'],
    [adsDocumentBodiesServerId.Value]);
  ShowMessageFmt('������� %d �������������', [deleteCount]);
end;

procedure TDocumentBodiesForm.sbMarkAsOrder1Click(Sender: TObject);
var
  orderListId : Variant;
begin
  orderListId := DM.QueryValue('select ServerOrderListId from postedorderlists limit 1', [], []);
  if not VarIsNull(orderListId) then
    markAsOrderBy(orderListId);
end;

procedure TDocumentBodiesForm.sbMarkAsOrder2Click(Sender: TObject);
var
  orderListId : Variant;
begin
  orderListId := DM.QueryValue('select ServerOrderListId from postedorderlists limit 2, 1', [], []);
  if not VarIsNull(orderListId) then
    markAsOrderBy(orderListId);
end;

procedure TDocumentBodiesForm.markAsOrderBy(serverOrderListId: Int64);
var
  insertCount : Integer;
begin
  WriteExchangeLog('markAsOrderBy', '��������� ������������� ��� adsDocumentBodiesServerId=' + adsDocumentBodiesServerId.AsString
    + '  ServerOrderListId=' + IntToStr(serverOrderListId));
  insertCount := DBProc.UpdateValue(DM.MainConnection,
    'insert into waybillOrders (ServerDocumentLineId, ServerOrderListId) values (:ServerDocumentLineId, :ServerOrderListId)',
    ['ServerDocumentLineId', 'ServerOrderListId'],
    [adsDocumentBodiesServerId.Value, serverOrderListId]);
  ShowMessageFmt('��������� %d �������������', [insertCount]);
end;
{$endif}

end.
