unit DocumentHeaders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, ComCtrls, StdCtrls, GridsEh, DBGridEh,
  ToughDBGrid, DB, MemDS, DBAccess, MyAccess, DocumentBodies, DocumentTypes,
  Buttons,
  ShellAPI;

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
  private
    { Private declarations }
  protected
    FDocumentBodiesForm: TDocumentBodiesForm;
    procedure ProcessDocument;
    procedure ShowArchiveOrder;
    procedure DeleteDocuments;
  public
    { Public declarations }
    procedure SetParameters;
    procedure SetDateInterval;
  end;

  procedure ShowDocumentHeaders;

implementation

uses Main, DateUtils, DModule, AProc, Orders,
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

procedure TDocumentHeaderForm.SetParameters;
begin
  adsDocumentHeaders.Close;

  adsDocumentHeaders.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').Value;
  adsDocumentHeaders.ParamByName( 'DateFrom').AsDate := dtpDateFrom.Date;
  dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
  adsDocumentHeaders.ParamByName( 'DateTo').AsDateTime := dtpDateTo.DateTime;

  adsDocumentHeaders.Open;
end;

procedure TDocumentHeaderForm.FormCreate(Sender: TObject);
var
  Year, Month, Day: Word;
begin
  inherited;

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

  SetParameters;
end;

procedure TDocumentHeaderForm.dtpDateCloseUp(Sender: TObject);
begin
  SetDateInterval;
  dbgHeaders.SetFocus;
end;

procedure TDocumentHeaderForm.SetDateInterval;
begin
  with adsDocumentHeaders do begin
	ParamByName('DateFrom').AsDate:=dtpDateFrom.Date;
	dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
	ParamByName('DateTo').AsDateTime := dtpDateTo.DateTime;
    Screen.Cursor:=crHourglass;
    try
      if Active then
      begin
        Close;
        Open;
      end
      else
        Open;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
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
                ExePath + DocumentFolders[documentType] + '\' + downloadId + '_*.*',
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
  ShellExecute( 0, 'Open', PChar(ExePath + SDirDocs + '\'),
    nil, nil, SW_SHOWDEFAULT);
  ShellExecute( 0, 'Open', PChar(ExePath + SDirWaybills + '\'),
    nil, nil, SW_SHOWDEFAULT);
  ShellExecute( 0, 'Open', PChar(ExePath + SDirRejects + '\'),
    nil, nil, SW_SHOWDEFAULT);
end;

end.
