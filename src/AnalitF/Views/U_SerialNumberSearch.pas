unit U_SerialNumberSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, GridsEh, DBGridEh, StdCtrls,
  ToughDBGrid,
  StrUtils,
  AlphaUtils,
  DBGridHelper,
  DBProc, DB, MemDS, DBAccess, MyAccess, Buttons,
  UserActions;

type
  TSerialNumberSearchForm = class(TChildForm)
    pTop: TPanel;
    pGrid: TPanel;
    eSearch: TEdit;
    dbgSerialNumberSearch: TDBGridEh;
    tmrSearch: TTimer;
    dsSerialNumberSearch: TDataSource;
    adsSerialNumberSearch: TMyQuery;
    adsSerialNumberSearchProduct: TStringField;
    adsSerialNumberSearchSerialNumber: TStringField;
    adsSerialNumberSearchRequestCertificate: TBooleanField;
    adsSerialNumberSearchCertificateId: TLargeintField;
    adsSerialNumberSearchLocalWriteTime: TDateTimeField;
    adsSerialNumberSearchProviderName: TStringField;
    adsSerialNumberSearchId: TLargeintField;
    tmrPrintedChange: TTimer;
    spDelete: TSpeedButton;
    tmrShowCertificateWarning: TTimer;
    adsSerialNumberSearchServerId: TLargeintField;
    adsSerialNumberSearchServerDocumentId: TLargeintField;
    procedure FormHide(Sender: TObject);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgSerialNumberSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgSerialNumberSearchKeyPress(Sender: TObject;
      var Key: Char);
    procedure dbgSerialNumberSearchDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumnEh;
      State: TGridDrawState);
    procedure tmrPrintedChangeTimer(Sender: TObject);
    procedure adsSerialNumberSearchRequestCertificateChange(
      Sender: TField);
    procedure adsSerialNumberSearchCertificateIdGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure spDeleteClick(Sender: TObject);
    procedure dbgSerialNumberSearchGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure dbgSerialNumberSearchCellClick(Column: TColumnEh);
    procedure dbgSerialNumberSearchSortMarkingChanged(Sender: TObject);
    procedure tmrShowCertificateWarningTimer(Sender: TObject);
    procedure adsSerialNumberSearchRequestCertificateValidate(
      Sender: TField);
  private
    { Private declarations }
    InternalSearchText : String;
    BM : TBitmap;
    procedure SetClear;
  public
    { Public declarations }
    procedure ShowForm( DateFrom, DateTo : TDateTime; supplierFilter : String); reintroduce;
    procedure SetParams;
    procedure PrepareGrid;
    procedure LoadFromRegistry();
    procedure InternalSearch;
    procedure AddKeyToSearch(Key : Char);
  end;

var
  SerialNumberSearchForm: TSerialNumberSearchForm;

implementation

uses DModule;

{$R *.dfm}

{ TSerialNumberSearchForm }

procedure TSerialNumberSearchForm.LoadFromRegistry;
begin
  TDBGridHelper.SetTitleButtonToColumns(dbgSerialNumberSearch);
  TDBGridHelper.RestoreColumnsLayout(dbgSerialNumberSearch, Self.ClassName);
  MyDacDataSetSortMarkingChanged( TToughDBGrid(dbgSerialNumberSearch) );
end;

procedure TSerialNumberSearchForm.PrepareGrid;
var
  column : TColumnEh;
begin
  dbgSerialNumberSearch.MinAutoFitWidth := DBGridColumnMinWidth;
  dbgSerialNumberSearch.Flat := True;
  dbgSerialNumberSearch.Options := dbgSerialNumberSearch.Options + [dgRowLines];
  dbgSerialNumberSearch.OptionsEh := dbgSerialNumberSearch.OptionsEh + [dghResizeWholeRightPart];
  dbgSerialNumberSearch.Font.Size := 10;
  dbgSerialNumberSearch.GridLineColors.DarkColor := clBlack;
  dbgSerialNumberSearch.GridLineColors.BrightColor := clDkGray;
  dbgSerialNumberSearch.AllowedSelections := [gstRecordBookmarks, gstRectangle];
  if CheckWin32Version(5, 1) then
    dbgSerialNumberSearch.OptionsEh := dbgSerialNumberSearch.OptionsEh + [dghTraceColSizing];

  dbgSerialNumberSearch.SelectedField := nil;
  dbgSerialNumberSearch.Columns.Clear();
  dbgSerialNumberSearch.ShowHint := True;
  dbgSerialNumberSearch.ReadOnly := True;
  dbgSerialNumberSearch.AutoFitColWidths := False;
  try
    TDBGridHelper.AddColumn(dbgSerialNumberSearch, 'LocalWriteTime', 'Дата документа', dbgSerialNumberSearch.Canvas.TextWidth('20110920'));
    TDBGridHelper.AddColumn(dbgSerialNumberSearch, 'ProviderName', 'Поставщик', 0);
    TDBGridHelper.AddColumn(dbgSerialNumberSearch, 'Product', 'Наименование', 0);
    TDBGridHelper.AddColumn(dbgSerialNumberSearch, 'SerialNumber', 'Серия товара', 0);
    column := TDBGridHelper.AddColumn(dbgSerialNumberSearch, 'RequestCertificate', 'Получить', dbgSerialNumberSearch.Canvas.TextWidth('Получить'), False);
    column.Checkboxes := True;
    column := TDBGridHelper.AddColumn(dbgSerialNumberSearch, 'CertificateId', 'Сертификаты', dbgSerialNumberSearch.Canvas.TextWidth('Сертификаты'), True);
  finally
    dbgSerialNumberSearch.AutoFitColWidths := True;
  end;
  dbgSerialNumberSearch.ReadOnly := False;
  dbgSerialNumberSearch.Options := dbgSerialNumberSearch.Options + [dgEditing];

  LoadFromRegistry();
end;

procedure TSerialNumberSearchForm.SetParams;
begin
  PrepareGrid();
end;

procedure TSerialNumberSearchForm.ShowForm(DateFrom, DateTo : TDateTime; supplierFilter : String);
begin
  adsSerialNumberSearch.ParamByName('DateFrom').Value := DateFrom;
  adsSerialNumberSearch.ParamByName('DateTo').Value := DateTo;
  adsSerialNumberSearch.ParamByName('LikeParam').AsString := '%';
  SetParams;
  inherited ShowForm;
  SetClear;
end;

procedure TSerialNumberSearchForm.FormHide(Sender: TObject);
begin
  inherited;
  TDBGridHelper.SaveColumnsLayout(dbgSerialNumberSearch, Self.ClassName);
end;

procedure TSerialNumberSearchForm.eSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
    dbgSerialNumberSearch.SetFocus;
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TSerialNumberSearchForm.SetClear;
begin
  tmrSearch.Enabled := False;
  eSearch.Text := '';
  InternalSearchText := '';
  if adsSerialNumberSearch.Active then
    adsSerialNumberSearch.Close;

  adsSerialNumberSearch.ParamByName('LikeParam').AsString := '%';
  adsSerialNumberSearch.Open;

  dbgSerialNumberSearch.SetFocus;
end;

procedure TSerialNumberSearchForm.dbgSerialNumberSearchKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    if tmrSearch.Enabled then
      tmrSearchTimer(nil);
  if Key = VK_ESCAPE then
    if tmrSearch.Enabled or (Length(InternalSearchText) > 0) then
      SetClear
    else
      if Assigned(Self.PrevForm) then
        //Если возвращаемся в Prices, то вызываем ShowForm, т.к. почему
        //уходит фокус с таблицы предложений на форме "Заявка поставщику"
        Self.PrevForm.ShowAsPrevForm
      else
        if Assigned(Self.PrevForm) then
          Self.PrevForm.ShowAsPrevForm
        else
          Close;
end;

procedure TSerialNumberSearchForm.FormCreate(Sender: TObject);
begin
  inherited;

  NeedFirstOnDataSet := False;
  InternalSearchText := '';
  BM := TBitmap.Create;
end;

procedure TSerialNumberSearchForm.FormDestroy(Sender: TObject);
begin
  BM.Free;
  inherited;
end;

procedure TSerialNumberSearchForm.InternalSearch;
begin
  if adsSerialNumberSearch.Active then
    adsSerialNumberSearch.Close;

  adsSerialNumberSearch.ParamByName('LikeParam').AsString := '%' + InternalSearchText + '%';

  adsSerialNumberSearch.Open;

  adsSerialNumberSearch.First;

  dbgSerialNumberSearch.SetFocus;
end;

procedure TSerialNumberSearchForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if (Length(eSearch.Text) > 2) then begin
    InternalSearchText := LeftStr(eSearch.Text, 50);
    InternalSearch;
    eSearch.Text := '';
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TSerialNumberSearchForm.eSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //Если мы что-то нажали в элементе, то должны на это отреагировать
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

procedure TSerialNumberSearchForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TSerialNumberSearchForm.dbgSerialNumberSearchKeyPress(
  Sender: TObject; var Key: Char);
begin
  AddKeyToSearch(Key);
{
  if ( Key > #32) and not ( Key in
    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
  begin
  end;
}  
end;

procedure TSerialNumberSearchForm.dbgSerialNumberSearchDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if (Column.Field = adsSerialNumberSearchProduct) or (Column.Field = adsSerialNumberSearchSerialNumber) then
    ProduceAlphaBlendRect(InternalSearchText, Column.Field.DisplayText, dbgSerialNumberSearch.Canvas, Rect, BM);
end;

procedure TSerialNumberSearchForm.tmrPrintedChangeTimer(Sender: TObject);
begin
  try
    SoftPost( adsSerialNumberSearch );
  finally
    tmrPrintedChange.Enabled := False;
  end;
end;

procedure TSerialNumberSearchForm.adsSerialNumberSearchRequestCertificateChange(
  Sender: TField);
begin
  if adsSerialNumberSearchRequestCertificate.Value
  then
    DM.InsertUserActionLog(
      uaRequestCertificate,
      ['Позиция: ' + adsSerialNumberSearchServerId.AsString]);
  //По-другому решить проблему не удалось. Запускаю таймер, чтобы он в главной нити
  //произвел сохранение dataset
  tmrPrintedChange.Enabled := False;
  tmrPrintedChange.Enabled := True;
end;

procedure TSerialNumberSearchForm.adsSerialNumberSearchCertificateIdGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if DisplayText and not Sender.IsNull then
    Text := 'Показать';
end;

procedure TSerialNumberSearchForm.spDeleteClick(Sender: TObject);
begin
  if Assigned(Self.PrevForm) then
    Self.PrevForm.ShowAsPrevForm
end;

procedure TSerialNumberSearchForm.dbgSerialNumberSearchGetCellParams(
  Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if (Column.Field = adsSerialNumberSearchCertificateId) then begin
    if not adsSerialNumberSearchCertificateId.IsNull then begin
      AFont.Style := AFont.Style + [fsUnderline];
      AFont.Color := clHotLight;
    end
    else
      //Сертификат не был получен, но запрос был
      if not adsSerialNumberSearchId.IsNull then
        Background := clGray;
  end;
end;

procedure TSerialNumberSearchForm.dbgSerialNumberSearchCellClick(
  Column: TColumnEh);
begin
  if (Column.Field = adsSerialNumberSearchCertificateId) and not adsSerialNumberSearchCertificateId.IsNull then
    DM.OpenCertificateFiles(adsSerialNumberSearchCertificateId.Value);
end;

procedure TSerialNumberSearchForm.dbgSerialNumberSearchSortMarkingChanged(
  Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TSerialNumberSearchForm.tmrShowCertificateWarningTimer(
  Sender: TObject);
begin
  tmrShowCertificateWarning.Enabled := False;
  DM.ShowCertificateWarning();
end;

procedure TSerialNumberSearchForm.adsSerialNumberSearchRequestCertificateValidate(
  Sender: TField);
begin
  if Sender.AsBoolean then
    if not DM.CertificateSourceExists(adsSerialNumberSearchServerId.Value) then begin
      tmrShowCertificateWarning.Enabled := False;
      tmrShowCertificateWarning.Enabled := true;
      Abort;
    end;
end;

end.
