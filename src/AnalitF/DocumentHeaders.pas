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
  U_frameFilterSuppliers, StrHlder;

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
    Label7: TLabel;
    Label8: TLabel;
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
  private
    { Private declarations }
    procedure OnChangeFilterSuppliers;
  protected
    FDocumentBodiesForm: TDocumentBodiesForm;

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
  inherited;

  frameFilterSuppliers := TframeFilterSuppliers.AddFrame(
    Self,
    pTop,
    spDelete.Left - 5,
    pTop.Height,
    OnChangeFilterSuppliers);
  tmrChangeFilterSuppliers.Enabled := False;
  tmrChangeFilterSuppliers.Interval := 500;

  spDelete.Left := frameFilterSuppliers.Left + frameFilterSuppliers.Width + 5;
  sbListToExcel.Left := spDelete.Left + spDelete.Width + 5;

  TDBGridHelper.RestoreColumnsLayout(dbgHeaders, Self.ClassName);

  FDocumentBodiesForm := TDocumentBodiesForm( FindChildControlByClass(MainForm, TDocumentBodiesForm) );
  if not Assigned(FDocumentBodiesForm) then
    FDocumentBodiesForm := TDocumentBodiesForm.Create( Application);

  Year := YearOf( Date);
  Month := MonthOf( Date);
  Day := DayOf( Date);
  IncAMonth( Year, Month, Day, -3);
  dtpDateFrom.Date := StartOfTheMonth( EncodeDate( Year, Month, Day));
  dtpDateTo.Date := Date;

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
      if AProc.MessageBox( '������� ��������� ��������� (���������, ������, ���������)?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then begin
        dbgHeaders.DataSource.DataSet.DisableControls;
        try
          for I := 0 to selectedRows.Count-1 do begin
            dbgHeaders.DataSource.DataSet.Bookmark := selectedRows[i];
            documentType := TDocumentType(adsDocumentHeadersDocumentType.AsInteger);
            downloadId := adsDocumentHeadersDownloadId.AsString;

            WriteExchangeLog(
              'DocumentHeaders',
              Format(
                '�������� ��������� Id: %s  ProviderDocumentId: %s  DownloadId: %s',
                [adsDocumentHeadersId.AsString,
                 adsDocumentHeadersProviderDocumentId.AsString,
                 downloadId]
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
                  '������ ��� ����� ����������� ��������� '
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
'  dh.*, ' +
'  EXTRACT(YEAR_MONTH FROM dh.LoadTime) as YearMonth, ' +
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
' and (dh.LoadTime BETWEEN :DateFrom AND :DateTo) ' +
' and (dh.DocumentType = 1) ' +
' and (p.FirmCode = dh.FirmCode) ' +
' and (dbodies.DocumentId = dh.Id) ' +
IfThen(supplierFilter <> '', ' and ' + supplierFilter + ' ') +
' group by dh.Id ' +
' order by EXTRACT(YEAR_MONTH FROM dh.LoadTime) DESC, p.FullName asc, dh.WriteTime DESC ';

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
          '����',
          '����� ���������',
          '���������',
          '����� ���',
          '����� �������',
          '�������,���',
          '�������,%',
          '����� ���',
          '���� ������']);

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
        if abs(ItogoTotalRetailSumm) > 0.001 then begin
          ItogoTotalMarkup := RoundTo(ItogoTotalRetailSumm - ItogoTotalSumm, -2);
          ItogoTotalMarkupPercent := RoundTo((ItogoTotalRetailSumm/ItogoTotalSumm - 1) *100, -2);
        end;
        exportData.WriteRow([
          '�����',
          '',
          '',
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
  adsDocumentHeaders.Close;

  adsDocumentHeaders.SQL.Text := shDocumentHeaders.Strings.Text;

  supplierFilter := GetSupplierController.GetFilter('p.FirmCode');
  if supplierFilter <> '' then
    adsDocumentHeaders.SQL.Text := adsDocumentHeaders.SQL.Text
      + #13#10' and ' + supplierFilter + ' '#13#10;

  adsDocumentHeaders.SQL.Text := adsDocumentHeaders.SQL.Text
      + #13#10' order by dh.LoadTime DESC ';

  adsDocumentHeaders.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').Value;
  adsDocumentHeaders.ParamByName( 'DateFrom').AsDate := dtpDateFrom.Date;
  dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
  adsDocumentHeaders.ParamByName( 'DateTo').AsDateTime := dtpDateTo.DateTime;

  adsDocumentHeaders.Open;

  adsDocumentHeaders.DisableControls;
  sl := TStringList.Create;
  try
    while not adsDocumentHeaders.Eof do begin
      if not adsDocumentHeadersRetailAmountCalculated.Value
        and (adsDocumentHeadersDocumentType.Value = 1)
      then
        sl.Add(adsDocumentHeadersId.AsString);
      adsDocumentHeaders.Next;
    end;
    adsDocumentHeaders.First;

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
    adsDocumentHeaders.EnableControls;
    sl.Free;
  end;
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
  lastId := adsDocumentHeadersId.AsVariant;
  adsDocumentHeaders.DisableControls;
  try
    ShowHeaders;
    if not adsDocumentHeaders.Locate('Id', lastId, []) then
      adsDocumentHeaders.First;
  finally
    adsDocumentHeaders.EnableControls;
  end;
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
  if abs(AllTotalRetailSumm) > 0.001 then begin
    AllTotalMarkup := RoundTo(AllTotalRetailSumm - AllTotalSumm, -2);
    AllTotalMarkupPercent := RoundTo((AllTotalRetailSumm/AllTotalSumm - 1) *100, -2);
  end;
  exportData.WriteRow([
    '�����',
    '',
    '',
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

  if abs(CurrentTotalRetailSumm) > 0.001 then begin
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

end.
