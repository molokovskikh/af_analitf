unit DocumentHeaders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, ComCtrls, StdCtrls, GridsEh, DBGridEh,
  ToughDBGrid, DB, MemDS, DBAccess, MyAccess, DocumentBodies, DocumentTypes,
  Buttons,
  ShellAPI,
  SupplierController,
  U_frameFilterSuppliers, StrHlder;

type
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
  private
    { Private declarations }
    procedure OnChangeFilterSuppliers;
  protected
    FDocumentBodiesForm: TDocumentBodiesForm;
    procedure ProcessDocument;
    procedure ShowArchiveOrder;
    procedure DeleteDocuments;
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
  DBProc,
  LU_TDataExportAsXls;

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
      if AProc.MessageBox( 'Удалить выбранные документы (накладные, отказы, докумнеты)?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then begin
        dbgHeaders.DataSource.DataSet.DisableControls;
        try
          for I := 0 to selectedRows.Count-1 do begin
            dbgHeaders.DataSource.DataSet.Bookmark := selectedRows[i];
            documentType := TDocumentType(adsDocumentHeadersDocumentType.AsInteger);
            downloadId := adsDocumentHeadersDownloadId.AsString;

            WriteExchangeLog(
              'DocumentHeaders',
              Format(
                'Удаление документа Id: %s  ProviderDocumentId: %s  DownloadId: %s',
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
  TDBGridHelper.SaveColumnsLayout(dbgHeaders, Self.ClassName);
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
  prefix,
  ndsPrefix : String;
  supplierFilter : String;
begin
  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;

  supplierFilter := GetSupplierController.GetFilter('p.FirmCode');

  DM.adsQueryValue.SQL.Text := '' +
' select ' +
'  dh.*, ' +
'  dh.WriteTime as LocalWriteTime, ' +
'  p.FullName as ProviderName, ' +
'  sum(dbodies.SupplierCost*Quantity) as TotalSumm, ' +
'  sum(dbodies.SupplierCost*Quantity) - sum(dbodies.SupplierCostWithoutNDS*Quantity) as TotalNDSSumm, ' +
'  count(dbodies.Id) as TotalCount, ' +
'  count(dbodies.SupplierCost) as CostCount, ' +
'  count(dbodies.SupplierCostWithoutNDS) as NDSCostCount ' +
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
' order by dh.LoadTime DESC ';

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
          'Сумма',
          'Сумма НДС',
          'Срок оплаты']);

        while not DM.adsQueryValue.Eof do begin
          prefix := '';
          ndsPrefix := '';
          if DM.adsQueryValue.FieldByName('TotalCount').AsInteger <> DM.adsQueryValue.FieldByName('CostCount').AsInteger
          then
            prefix := '!!! ';
          if DM.adsQueryValue.FieldByName('TotalCount').AsInteger <> DM.adsQueryValue.FieldByName('NDSCostCount').AsInteger
          then
            ndsPrefix := '!!! ';

          exportData.WriteRow([
            DM.adsQueryValue.FieldByName('LocalWriteTime').AsString,
            DM.adsQueryValue.FieldByName('ProviderDocumentId').AsString,
            DM.adsQueryValue.FieldByName('ProviderName').AsString,
            prefix + DM.adsQueryValue.FieldByName('TotalSumm').AsString,
            ndsPrefix + DM.adsQueryValue.FieldByName('TotalNDSSumm').AsString]);
          DM.adsQueryValue.Next;
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
  finally
    DM.adsQueryValue.Close;
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
end;

procedure TDocumentHeaderForm.tmrChangeFilterSuppliersTimer(
  Sender: TObject);
begin
  tmrChangeFilterSuppliers.Enabled := False;
  ShowHeaders;
end;

end.
