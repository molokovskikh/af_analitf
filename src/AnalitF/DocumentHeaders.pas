unit DocumentHeaders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, ComCtrls, StdCtrls, GridsEh, DBGridEh,
  ToughDBGrid, DB, MemDS, DBAccess, MyAccess, DocumentBodies, DocumentTypes,
  Buttons,
  ShellAPI,
  SyncObjs,
  Math,
  LU_TDataExportAsXls,
  SupplierController,
  U_frameFilterSuppliers,
  StrHlder,
  GlobalParams,
  U_SerialNumberSearch,
  U_frameBaseLegend,
  U_AddWaybillForm;

const
  clCreatedByUser = clMoneyGreen;
    
type
  TExportDocRow = class
   public
    CurrentFirmCode : Integer;
    CurrentYearMonth : String;

    AllTotalSumm,
    AllTotalRetailSumm,
    AllTotalNDSSumm,
    AllTotalMarkup,
    AllTotalMarkupPercent : Double;

    constructor Create();

    function NeedSwitch(dataQuery: TMyQuery) : Boolean;
    procedure Switch(dataQuery: TMyQuery; exportData : TDataExportAsXls);
    procedure ProcessRow(dataQuery: TMyQuery; exportData : TDataExportAsXls);

    function NeedExportCounters() : Boolean;
    procedure ExportCounters(exportData : TDataExportAsXls);
  end;

  TDocumentHeaderForm = class(TChildForm)
    pTop: TPanel;
    lBefore: TLabel;
    lInterval: TLabel;
    Bevel1: TBevel;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    pGrid: TPanel;
    dbgHeaders: TToughDBGrid;
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
    dsDocumentHeaders: TDataSource;
    adsDocumentHeadersProviderName: TStringField;
    adsDocumentHeadersLocalWriteTime: TDateTimeField;
    spDelete: TSpeedButton;
    spOpenFolders: TSpeedButton;
    adsDocumentHeadersLoadTime: TDateTimeField;
    sbListToExcel: TSpeedButton;
    shDocumentHeaders: TStrHolder;
    tmrChangeFilterSuppliers: TTimer;
    adsDocumentHeadersTotalSumm: TFloatField;
    adsDocumentHeadersTotalRetailSumm: TFloatField;
    tmrProcessWaybils: TTimer;
    adsDocumentHeadersRetailAmountCalculated: TBooleanField;
    rgColumn: TRadioGroup;
    sbSearch: TSpeedButton;
    adsDocumentHeadersCreatedByUser: TBooleanField;
    sbAdd: TSpeedButton;
    adsRetailProcessed: TMyQuery;
    procedure FormCreate(Sender: TObject);
    procedure dtpDateCloseUp(Sender: TObject);
    procedure dbgHeadersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgHeadersDblClick(Sender: TObject);
    procedure adsDocumentHeadersDocumentTypeGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure spDeleteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dbgHeadersSortMarkingChanged(Sender: TObject);
    procedure spOpenFoldersClick(Sender: TObject);
    procedure sbListToExcelClick(Sender: TObject);
    procedure tmrChangeFilterSuppliersTimer(Sender: TObject);
    procedure tmrProcessWaybilsTimer(Sender: TObject);
    procedure rgColumnClick(Sender: TObject);
    procedure sbSearchClick(Sender: TObject);
    procedure dbgHeadersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure sbAddClick(Sender: TObject);
  private
    { Private declarations }
    legeng : TframeBaseLegend;

    pButtons : TPanel;

    procedure OnChangeFilterSuppliers;
  protected
    FDocumentBodiesForm: TDocumentBodiesForm;
    FSerialNumberSearchForm: TSerialNumberSearchForm;

    ProcessedList : TStringList;
    csProcessedList : TCriticalSection;

    procedure ProcessDocument;
    procedure ShowArchiveOrder;
    procedure DeleteDocuments;
    procedure UpdateOrderDataset; override;
    procedure RecalcDocument(documentId : Int64);
  public
    { Public declarations }
    frameFilterSuppliers : TframeFilterSuppliers;
    procedure ShowHeaders;
  end;

  procedure ShowDocumentHeaders;



implementation

uses
  Main,
  DateUtils,
  StrUtils,
  DModule,
  AProc,
  Orders,
  DBGridHelper,
  U_ExchangeLog,
  DBProc;

{$R *.dfm}

procedure ShowDocumentHeaders;
var
  document : TDocumentHeaderForm;
begin
  document := TDocumentHeaderForm(MainForm.ShowChildForm( TDocumentHeaderForm ));
  document.ShowForm;
end;

{ TDocumentHeaderForm }

procedure TDocumentHeaderForm.FormCreate(Sender: TObject);
var
  Year, Month, Day: Word;
begin
  csProcessedList := TCriticalSection.Create;
  ProcessedList := TStringList.Create;

  pButtons := TPanel.Create(Self);
  pButtons.Parent := Self;
  pButtons.Name := 'pButtons';
  pButtons.Caption := '';
  pButtons.BevelOuter := bvNone;
  pButtons.Align := alBottom;
  pButtons.Height := spDelete.Height + 15;

  legeng := TframeBaseLegend.Create(Self);
  legeng.Parent := Self;
  legeng.Align := alBottom;

  legeng.CreateLegendLabel(
    'Накладная, созданная пользователем',
    clCreatedByUser,
    clWindowText,
    'Накладная, созданная пользователем');

  inherited;

  frameFilterSuppliers := TframeFilterSuppliers.AddFrame(
    Self,
    pTop,
    spDelete.Left - 5,
    pTop.Height,
    OnChangeFilterSuppliers);
  tmrChangeFilterSuppliers.Enabled := False;
  tmrChangeFilterSuppliers.Interval := 500;

  sbListToExcel.Left := frameFilterSuppliers.Left + frameFilterSuppliers.Width + 5;

  spDelete.Parent := pButtons;
  spDelete.Top := 8;
  spDelete.Left := 5;

  sbAdd.Parent := pButtons;
  sbAdd.Top := 8;
  sbAdd.Left := spDelete.Left + spDelete.Width + 5;
  sbAdd.Caption := 'Создать новую накладную';
  sbAdd.Width := Self.Canvas.TextWidth(sbAdd.Caption) + 10;

  TDBGridHelper.RestoreColumnsLayout(dbgHeaders, Self.ClassName);

  FDocumentBodiesForm := TDocumentBodiesForm( FindChildControlByClass(MainForm, TDocumentBodiesForm) );
  if not Assigned(FDocumentBodiesForm) then
    FDocumentBodiesForm := TDocumentBodiesForm.Create( Application);

  FSerialNumberSearchForm := TSerialNumberSearchForm( FindChildControlByClass(MainForm, TSerialNumberSearchForm) );
  if not Assigned(FSerialNumberSearchForm) then
    FSerialNumberSearchForm := TSerialNumberSearchForm.Create(Application);

  Year := YearOf( Date);
  Month := MonthOf( Date);
  Day := DayOf( Date);
  IncAMonth( Year, Month, Day, -3);
  dtpDateFrom.Date := StartOfTheMonth( EncodeDate( Year, Month, Day));
  dtpDateTo.Date := Date;

  rgColumn.OnClick := nil;
  try
    rgColumn.ItemIndex := TGlobalParamsHelper.GetParamDef(
      DM.MainConnection,
      'DocumentFilterColumn',
      0);
  finally
    rgColumn.OnClick := rgColumnClick;
  end;

  ShowHeaders;
  tmrProcessWaybils.Enabled := True;
end;

procedure TDocumentHeaderForm.dtpDateCloseUp(Sender: TObject);
begin
  ShowHeaders;
  dbgHeaders.SetFocus;
end;

procedure TDocumentHeaderForm.dbgHeadersKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (Shift = []) then
    ProcessDocument
  else
    if (Key = VK_DELETE) and not adsDocumentHeaders.IsEmpty then
      DeleteDocuments
    else
      if (Key = VK_RETURN) and (Shift = [ssShift]) and not adsDocumentHeadersOrderId.IsNull then
        ShowArchiveOrder;
end;

procedure TDocumentHeaderForm.ProcessDocument;
begin
  if not adsDocumentHeaders.IsEmpty and not adsDocumentHeadersId.IsNull
    and not adsDocumentHeadersDocumentType.IsNull
    and (adsDocumentHeadersDocumentType.Value <> 3) 
  then
    FDocumentBodiesForm.ShowForm(adsDocumentHeadersId.Value, Self);
end;

procedure TDocumentHeaderForm.dbgHeadersDblClick(Sender: TObject);
var
  C : GridsEh.TGridCoord;
  P : TPoint;
begin
  p := TToughDBGrid(Sender).ScreenToClient(Mouse.CursorPos);
  C := TToughDBGrid(Sender).MouseCoord(p.X, p.Y);
  if C.Y > 0 then
    ProcessDocument;
end;

procedure TDocumentHeaderForm.ShowArchiveOrder;
var
  FOrdersForm : TOrdersForm;
begin
  FOrdersForm := TOrdersForm( FindChildControlByClass(MainForm, TOrdersForm) );
  if not Assigned(FOrdersForm) then
    FOrdersForm := TOrdersForm.Create( Application);

  FOrdersForm.ShowForm(adsDocumentHeadersOrderId.AsInteger, Self, True);
end;

procedure TDocumentHeaderForm.adsDocumentHeadersDocumentTypeGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if DisplayText then
    Text := RussianDocumentType[TDocumentType(Sender.AsInteger)];
end;

procedure TDocumentHeaderForm.DeleteDocuments;
var
  selectedRows : TStringList;
  documentType : TDocumentType;
  downloadId : String;
  I : Integer;
begin
  if not adsDocumentHeaders.IsEmpty then begin
    selectedRows := TDBGridHelper.GetSelectedRows(dbgHeaders);

    if selectedRows.Count > 0 then
      if AProc.MessageBox( 'Удалить выбранные документы (накладные, отказы, документы)?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then begin
        dbgHeaders.DataSource.DataSet.DisableControls;
        try
          for I := 0 to selectedRows.Count-1 do begin
            dbgHeaders.DataSource.DataSet.Bookmark := selectedRows[i];
            documentType := TDocumentType(adsDocumentHeadersDocumentType.AsInteger);
            downloadId := adsDocumentHeadersDownloadId.AsString;

            WriteExchangeLog(
              'DocumentHeaders',
              Format(
                'Удаление документа Id: %s  Номер документа: %s  Номер поставщика: %s',
                [adsDocumentHeadersId.AsString,
                 downloadId,
                 adsDocumentHeadersProviderDocumentId.AsString]
              )
              );

            if (documentType <> dtUnknown) and (Length(downloadId) > 0) then
            try
              DeleteFilesByMask(
                RootFolder() + DocumentFolders[documentType] + '\' + downloadId + '_*.*',
                True);
            except
              on DeleteFile : Exception do
                WriteExchangeLog(
                  'DocumentHeaders',
                  'Ошибка при файла устаревшего документа '
                  + downloadId + ' : ' + DeleteFile.Message);
            end;
            dbgHeaders.DataSource.DataSet.Delete;
          end;
        finally
          dbgHeaders.DataSource.DataSet.EnableControls;
        end;
      end;
  end;
end;

procedure TDocumentHeaderForm.spDeleteClick(Sender: TObject);
begin
  DeleteDocuments;
end;

procedure TDocumentHeaderForm.FormDestroy(Sender: TObject);
begin
  tmrProcessWaybils.Enabled := False;
  TDBGridHelper.SaveColumnsLayout(dbgHeaders, Self.ClassName);
  TGlobalParamsHelper.SaveParam(
    DM.MainConnection,
    'DocumentFilterColumn',
    rgColumn.ItemIndex
    );
  ProcessedList.Free;
  csProcessedList.Free;
  inherited;
end;

procedure TDocumentHeaderForm.dbgHeadersSortMarkingChanged(
  Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TDocumentHeaderForm.spOpenFoldersClick(Sender: TObject);
begin
  ShellExecute( 0, 'Open', PChar(RootFolder() + SDirDocs + '\'),
    nil, nil, SW_SHOWDEFAULT);
  ShellExecute( 0, 'Open', PChar(RootFolder() + SDirWaybills + '\'),
    nil, nil, SW_SHOWDEFAULT);
  ShellExecute( 0, 'Open', PChar(RootFolder() + SDirRejects + '\'),
    nil, nil, SW_SHOWDEFAULT);
end;

procedure TDocumentHeaderForm.sbListToExcelClick(Sender: TObject);
var
  exportFile : String;
  exportData : TDataExportAsXls;
  supplierFilter : String;

  ItogoTotalSumm,
  ItogoTotalRetailSumm,
  ItogoTotalNDSSumm,
  ItogoTotalMarkup,
  ItogoTotalMarkupPercent : Double;

  exportDocRow : TExportDocRow;
begin
  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;

  exportDocRow := TExportDocRow.Create();

  try

  ItogoTotalSumm := 0;
  ItogoTotalRetailSumm := 0;
  ItogoTotalNDSSumm := 0;
  ItogoTotalMarkup := 0;
  ItogoTotalMarkupPercent := 0;

  supplierFilter := GetSupplierController.GetFilter('p.FirmCode');

  DM.adsQueryValue.SQL.Text := '' +
' select ' +
'  dh.Id, ' +
'  ifnull(dh.DownloadId, dh.Id) as DownloadId, ' +
'  dh.WriteTime, ' +
'  dh.FirmCode, ' +
'  dh.ClientId, ' +
'  dh.DocumentType, ' +
'  dh.ProviderDocumentId, ' +
'  dh.OrderId, ' +
'  dh.Header, ' +
'  dh.LoadTime, ' +
'  dh.RetailAmountCalculated, ' +
'  EXTRACT(YEAR_MONTH FROM ifnull(dh.WriteTime, dh.LoadTime)) as YearMonth, ' +
'  dh.WriteTime as LocalWriteTime, ' +
'  p.FirmCode, ' +
'  p.FullName as ProviderName, ' +
'  sum(dbodies.Amount) as TotalSumm, ' +
'  sum(dbodies.NdsAmount) as TotalNDSSumm, ' +
'  sum(dbodies.RetailAmount) as TotalRetailSumm, ' +
'  count(dbodies.Id) as TotalCount, ' +
'  count(dbodies.Amount) as CostCount, ' +
'  count(dbodies.NdsAmount) as NDSCostCount ' +
' from ' +
'   DocumentHeaders dh, ' +
'   DocumentBodies dbodies, ' +
'   providers p ' +
' where ' +
'     (dh.ClientId = :ClientId) ' +
' and (ifnull(dh.WriteTime, dh.LoadTime) BETWEEN :DateFrom AND :DateTo) ' +
' and (dh.DocumentType = 1) ' +
' and (p.FirmCode = dh.FirmCode) ' +
' and (dbodies.DocumentId = dh.Id) ' +
IfThen(supplierFilter <> '', ' and ' + supplierFilter + ' ') +
' group by dh.Id ' +
' order by EXTRACT(YEAR_MONTH FROM ifnull(dh.WriteTime, dh.LoadTime)) DESC, p.FullName asc, dh.WriteTime DESC ';

  DM.adsQueryValue.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').Value;
  DM.adsQueryValue.ParamByName( 'DateFrom').AsDate := dtpDateFrom.Date;
  dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
  DM.adsQueryValue.ParamByName( 'DateTo').AsDateTime := dtpDateTo.DateTime;

  DM.adsQueryValue.Open;
  try
    if not DM.adsQueryValue.IsEmpty then begin
      exportFile := TDBGridHelper.GetTempFileToExport();

      exportData := TDataExportAsXls.Create(exportFile);
      try

        exportData.WriteRow([
          'Дата',
          'Номер накладной',
          'Поставщик',
          'Сумма Опт без НДС',
          'Сумма Опт',
          'Сумма Розница',
          'Наценка,руб',
          'Наценка,%',
          'Сумма НДС',
          'Срок оплаты']);

        while not DM.adsQueryValue.Eof do begin

          if exportDocRow.NeedSwitch(DM.adsQueryValue) then begin
            if exportDocRow.NeedExportCounters() then begin
              exportDocRow.ExportCounters(exportData);
              ItogoTotalSumm := ItogoTotalSumm + RoundTo(exportDocRow.AllTotalSumm, -2);
              ItogoTotalRetailSumm := ItogoTotalRetailSumm + RoundTo(exportDocRow.AllTotalRetailSumm, -2);
              ItogoTotalNDSSumm := ItogoTotalNDSSumm + RoundTo(exportDocRow.AllTotalNDSSumm, -2);
            end;
            exportDocRow.Switch(DM.adsQueryValue, exportData);
          end;

          exportDocRow.ProcessRow(DM.adsQueryValue, exportData);
          
          DM.adsQueryValue.Next;
        end;

        if exportDocRow.NeedExportCounters() then begin
          exportDocRow.ExportCounters(exportData);
          ItogoTotalSumm := ItogoTotalSumm + RoundTo(exportDocRow.AllTotalSumm, -2);
          ItogoTotalRetailSumm := ItogoTotalRetailSumm + RoundTo(exportDocRow.AllTotalRetailSumm, -2);
          ItogoTotalNDSSumm := ItogoTotalNDSSumm + RoundTo(exportDocRow.AllTotalNDSSumm, -2);
        end;
        
        exportData.WriteBlankRow;
        exportData.WriteBlankRow;
        if (abs(ItogoTotalRetailSumm) > 0.001) and (abs(ItogoTotalSumm) > 0.001) then begin
          ItogoTotalMarkup := RoundTo(ItogoTotalRetailSumm - ItogoTotalSumm, -2);
          ItogoTotalMarkupPercent := RoundTo((ItogoTotalRetailSumm/ItogoTotalSumm - 1) *100, -2);
        end;
        exportData.WriteRow([
          'Итого',
          '',
          '',
          FloatToStr(RoundTo(ItogoTotalSumm - ItogoTotalNDSSumm, -2)),
          FloatToStr(RoundTo(ItogoTotalSumm, -2)),
          FloatToStr(RoundTo(ItogoTotalRetailSumm, -2)),
          IfThen(abs(ItogoTotalMarkup) > 0.001,
            FloatToStr(ItogoTotalMarkup)),
          IfThen(abs(ItogoTotalMarkupPercent) > 0.001,
            FloatToStr(ItogoTotalMarkupPercent)),
          FloatToStr(RoundTo(ItogoTotalNDSSumm, -2))]);
      finally
        exportData.Free;
      end;

      ShellExecute(
        0,
        'Open',
        PChar(exportFile),
        nil, nil, SW_SHOWNORMAL);
    end;
  finally
    DM.adsQueryValue.Close;
  end;

  finally
    exportDocRow.Free;
  end;
end;

procedure TDocumentHeaderForm.OnChangeFilterSuppliers;
begin
  tmrChangeFilterSuppliers.Enabled := False;
  tmrChangeFilterSuppliers.Enabled := True;
end;

procedure TDocumentHeaderForm.ShowHeaders;
var
  supplierFilter : String;
  sl : TStringList;
begin
  adsRetailProcessed.Close;
  adsRetailProcessed.SQL.Text := '';

  adsDocumentHeaders.Close;

  adsDocumentHeaders.SQL.Text := shDocumentHeaders.Strings.Text;

  if rgColumn.ItemIndex = 0 then
    adsDocumentHeaders.SQL.Text := adsDocumentHeaders.SQL.Text
      + #13#10' and ((dh.WriteTime is not null and dh.WriteTime BETWEEN :DateFrom AND :DateTo) or (dh.WriteTime is null and dh.LoadTime BETWEEN :DateFrom AND :DateTo)) '#13#10
  else
    adsDocumentHeaders.SQL.Text := adsDocumentHeaders.SQL.Text
      + #13#10' and (dh.LoadTime BETWEEN :DateFrom AND :DateTo) '#13#10;

  supplierFilter := GetSupplierController.GetFilter('p.FirmCode');
  if supplierFilter <> '' then
    adsDocumentHeaders.SQL.Text := adsDocumentHeaders.SQL.Text
      + #13#10' and ' + supplierFilter + ' '#13#10;

  adsRetailProcessed.SQL.Text := adsDocumentHeaders.SQL.Text
      + #13#10' and (dh.DocumentType = 1) and (dh.RetailAmountCalculated is null or dh.RetailAmountCalculated = 0) '
      + #13#10' group by dh.Id '
      + #13#10' order by dh.LoadTime DESC ';
  adsDocumentHeaders.SQL.Text := adsDocumentHeaders.SQL.Text
      + #13#10' group by dh.Id '
      + #13#10' order by dh.LoadTime DESC ';

  adsDocumentHeaders.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').Value;
  adsDocumentHeaders.ParamByName( 'DateFrom').AsDate := dtpDateFrom.Date;
  dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
  adsDocumentHeaders.ParamByName( 'DateTo').AsDateTime := dtpDateTo.DateTime;

{
  WriteExchangeLog('DocumentHeader',
    'explain adsDocumentHeaders result: ' + #13#10 +
    DM.DataSetToString(
      'explain EXTENDED ' + adsDocumentHeaders.SQL.Text,
      ['ClientId', 'DateFrom', 'DateTo'],
      [adsDocumentHeaders.ParamByName( 'ClientId').Value,
       adsDocumentHeaders.ParamByName( 'DateFrom').AsDate,
       adsDocumentHeaders.ParamByName( 'DateTo').AsDateTime]));
}       

//  WriteExchangeLogTID('DocumentHeader', 'Start adsDocumentHeaders.Open');
  adsDocumentHeaders.Open;
//  WriteExchangeLogTID('DocumentHeader', 'Stop adsDocumentHeaders.Open');

//  WriteExchangeLogTID('DocumentHeader', 'Start adsRetailProcessed.Open');
  adsRetailProcessed.ParamByName( 'ClientId').Value :=
    adsDocumentHeaders.ParamByName( 'ClientId').Value;
  adsRetailProcessed.ParamByName( 'DateFrom').AsDate :=
    adsDocumentHeaders.ParamByName( 'DateFrom').AsDate;
  adsRetailProcessed.ParamByName( 'DateTo').AsDateTime :=
    adsDocumentHeaders.ParamByName( 'DateTo').AsDateTime;

{
  WriteExchangeLog('DocumentHeader',
    'adsRetailProcessed result: ' + #13#10 +
    DM.DataSetToString(
      adsRetailProcessed.SQL.Text,
      ['ClientId', 'DateFrom', 'DateTo'],
      [adsDocumentHeaders.ParamByName( 'ClientId').Value,
       adsDocumentHeaders.ParamByName( 'DateFrom').AsDate,
       adsDocumentHeaders.ParamByName( 'DateTo').AsDateTime]));
}       

  adsRetailProcessed.Open;
  try
    sl := TStringList.Create;
    try
      while not adsRetailProcessed.Eof do begin
        sl.Add(adsRetailProcessed.FieldByName('Id').AsString);
        adsRetailProcessed.Next;
      end;

      if sl.Count > 0 then begin
        csProcessedList.Enter;
        try
          ProcessedList.Clear();
          ProcessedList.Assign(sl);
        finally
          csProcessedList.Leave;
        end;
      end;
    finally
      sl.Free;
    end;
  finally
    adsRetailProcessed.Close;
  end;
//  WriteExchangeLogTID('DocumentHeader', 'Stop adsRetailProcessed processed');
end;

procedure TDocumentHeaderForm.tmrChangeFilterSuppliersTimer(
  Sender: TObject);
begin
  tmrChangeFilterSuppliers.Enabled := False;
  ShowHeaders;
end;

procedure TDocumentHeaderForm.UpdateOrderDataset;
var
  lastId : Variant;
begin
//  WriteExchangeLogTID('DocumentHeader', 'Start UpdateOrderDataset');
  lastId := adsDocumentHeadersId.AsVariant;
  adsDocumentHeaders.DisableControls;
  try
    ShowHeaders;
//    WriteExchangeLogTID('DocumentHeader', 'Start Locate');
    if not adsDocumentHeaders.Locate('Id', lastId, []) then
      adsDocumentHeaders.First;
  finally
    adsDocumentHeaders.EnableControls;
  end;
//  WriteExchangeLogTID('DocumentHeader', 'Stop UpdateOrderDataset');
end;

procedure TDocumentHeaderForm.RecalcDocument(documentId: Int64);
begin
  FDocumentBodiesForm.ForceRecalcDocument(documentId);
end;

{ TExportDocRow }

constructor TExportDocRow.Create;
begin
  CurrentFirmCode := 0;
  CurrentYearMonth := '';

  AllTotalSumm := 0;
  AllTotalRetailSumm := 0;
  AllTotalNDSSumm := 0;
  AllTotalMarkup := 0;
  AllTotalMarkupPercent := 0;
end;

procedure TExportDocRow.ExportCounters(exportData: TDataExportAsXls);
begin
  if (abs(AllTotalRetailSumm) > 0.001) and (abs(AllTotalSumm) > 0.001) then begin
    AllTotalMarkup := RoundTo(AllTotalRetailSumm - AllTotalSumm, -2);
    AllTotalMarkupPercent := RoundTo((AllTotalRetailSumm/AllTotalSumm - 1) *100, -2);
  end;
  exportData.WriteRow([
    'Всего',
    '',
    '',
    FloatToStr(RoundTo(AllTotalSumm - AllTotalNDSSumm, -2)),
    FloatToStr(RoundTo(AllTotalSumm, -2)),
    FloatToStr(RoundTo(AllTotalRetailSumm, -2)),
    IfThen(abs(AllTotalMarkup) > 0.001,
      FloatToStr(AllTotalMarkup)),
    IfThen(abs(AllTotalMarkupPercent) > 0.001,
      FloatToStr(AllTotalMarkupPercent)),
    FloatToStr(RoundTo(AllTotalNDSSumm, -2))]);
end;

function TExportDocRow.NeedExportCounters: Boolean;
begin
  Result := CurrentFirmCode > 0;
end;

function TExportDocRow.NeedSwitch(dataQuery: TMyQuery): Boolean;
begin
  Result :=
  (CurrentFirmCode <> dataQuery.FieldByName('FirmCode').AsInteger) or
            (CurrentYearMonth <> dataQuery.FieldByName('YearMonth').AsString)
end;

procedure TExportDocRow.ProcessRow(dataQuery: TMyQuery;
  exportData: TDataExportAsXls);
var
  prefix,
  ndsPrefix : String;

  CurrentTotalSumm,
  CurrentTotalRetailSumm,
  CurrentTotalNDSSumm,
  CurrentTotalMarkup,
  CurrentTotalMarkupPercent : Double;
begin
  prefix := '';
  ndsPrefix := '';
  if dataQuery.FieldByName('TotalCount').AsInteger <> dataQuery.FieldByName('CostCount').AsInteger
  then
    prefix := '!!! ';
  if dataQuery.FieldByName('TotalCount').AsInteger <> dataQuery.FieldByName('NDSCostCount').AsInteger
  then
    ndsPrefix := '!!! ';

  CurrentTotalSumm := RoundTo(dataQuery.FieldByName('TotalSumm').AsFloat, -2);
  CurrentTotalRetailSumm := RoundTo(dataQuery.FieldByName('TotalRetailSumm').AsFloat, -2);
  CurrentTotalNDSSumm := RoundTo(dataQuery.FieldByName('TotalNDSSumm').AsFloat, -2);

  CurrentTotalMarkup := 0;
  CurrentTotalMarkupPercent := 0;

  if (abs(CurrentTotalRetailSumm) > 0.001) and (abs(CurrentTotalSumm) > 0.001) then begin
    CurrentTotalMarkup := RoundTo(CurrentTotalRetailSumm - CurrentTotalSumm, -2);
    CurrentTotalMarkupPercent := RoundTo((CurrentTotalRetailSumm/CurrentTotalSumm - 1) *100, -2);
  end;

  AllTotalSumm := AllTotalSumm + CurrentTotalSumm;
  AllTotalRetailSumm := AllTotalRetailSumm + CurrentTotalRetailSumm;
  AllTotalNDSSumm := AllTotalNDSSumm + CurrentTotalNDSSumm;

  exportData.WriteRow([
    dataQuery.FieldByName('LocalWriteTime').AsString,
    dataQuery.FieldByName('ProviderDocumentId').AsString,
    dataQuery.FieldByName('ProviderName').AsString,
    prefix + FloatToStr(CurrentTotalSumm - CurrentTotalNDSSumm),
    prefix + FloatToStr(CurrentTotalSumm),
    FloatToStr(CurrentTotalRetailSumm),
    IfThen(abs(CurrentTotalMarkup) > 0.001,
      FloatToStr(CurrentTotalMarkup)),
    IfThen(abs(CurrentTotalMarkupPercent) > 0.001,
      FloatToStr(CurrentTotalMarkupPercent)),
    ndsPrefix + FloatToStr(CurrentTotalNDSSumm)]);
end;

procedure TExportDocRow.Switch(dataQuery: TMyQuery;
  exportData: TDataExportAsXls);
begin
  exportData.WriteBlankRow;
  exportData.WriteBlankRow;

  CurrentFirmCode := dataQuery.FieldByName('FirmCode').AsInteger;
  CurrentYearMonth := dataQuery.FieldByName('YearMonth').AsString;

  AllTotalSumm := 0;
  AllTotalRetailSumm := 0;
  AllTotalNDSSumm := 0;
  AllTotalMarkup := 0;
  AllTotalMarkupPercent := 0;
end;

procedure TDocumentHeaderForm.tmrProcessWaybilsTimer(Sender: TObject);
var
  DocumentId : String;
begin
  if (ProcessedList.Count > 0) and (MainForm.ActiveChild = Self) then begin
    tmrProcessWaybils.Enabled := False;
    try
      DocumentId := '';
      csProcessedList.Enter;
      try
        if ProcessedList.Count > 0 then begin
          DocumentId := ProcessedList[0];
          ProcessedList.Delete(0);
        end;
      finally
        csProcessedList.Leave
      end;

      if Length(DocumentId) > 0 then begin
        RecalcDocument(StrToInt64(DocumentId));
        if (ProcessedList.Count = 0) then
          UpdateOrderDataset;
      end;
    finally
      tmrProcessWaybils.Enabled := True;
    end;
  end;
end;

procedure TDocumentHeaderForm.rgColumnClick(Sender: TObject);
begin
  UpdateOrderDataset;
  dbgHeaders.SetFocus;
end;

procedure TDocumentHeaderForm.sbSearchClick(Sender: TObject);
begin
  dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
  FSerialNumberSearchForm.ShowForm(dtpDateFrom.Date, dtpDateTo.DateTime, '');
end;

procedure TDocumentHeaderForm.dbgHeadersGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if adsDocumentHeadersCreatedByUser.Value then
    Background := clCreatedByUser;
end;

procedure TDocumentHeaderForm.sbAddClick(Sender: TObject);
var
  AddWaybillForm: TAddWaybillForm;
begin
  AddWaybillForm := TAddWaybillForm.Create(Application);
  try
    if AddWaybillForm.ShowModal = mrOk then begin
      DBProc.UpdateValue(
        DM.MainConnection,
        'insert into documentheaders (WriteTime, FirmCode, ClientId, DocumentType, ProviderDocumentId, CreatedByUser) values (:WriteTime, :FirmCode, :ClientId, 1, :ProviderDocumentId, 1);',
        ['WriteTime', 'FirmCode', 'ClientId', 'ProviderDocumentId'],
        [VarAsType(AddWaybillForm.dtpDate.Date, varDate),
        AddWaybillForm.dblcbProvider.KeyValue,
        DM.adtClients.FieldByName( 'ClientId').Value,
        AddWaybillForm.eProviderId.Text]);
      UpdateOrderDataset;
    end;
  finally
    FreeAndNil(AddWaybillForm);
  end;
end;

end.
