unit U_frameMiniMail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  StrUtils,
  DB,
  DBCtrls,
  Buttons,
  Menus,
  GridsEh,
  DbGridEh,
  DateUtils,
  MyAccess,
  RxMemDS,
  ToughDBGrid,
  DModule,
  AProc,
  DBGridHelper,
  DataSetHelper,
  DBProc,
  Constant,
  U_ExchangeLog,
  U_frameBaseLegend;

type
  TframeMiniMail = class(TFrame)
    tmrSearch: TTimer;
    procedure FrameResize(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
  private
    { Private declarations }
    FCanvas : TCanvas;
    //Список выбранных строк в гридах
    FSelectedRows : TStringList;

    InternalSearchText : String;
    procedure CreateVisualComponent;
    procedure CreateNonVisualComponent;

    procedure InsertTestData();

    procedure ProcessResize;

{
    procedure dbgMinPricesKeyPress(Sender: TObject; var Key: Char);
}
    procedure dbgMailHeadersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgMailHeadersSortMarkingChanged(Sender: TObject);
    procedure dbgMailHeadersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);

    procedure sbDeleteClick(Sender : TObject);

    procedure fRecievedAttachmentGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure dbgMailAttachemtsGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgMailAttachemtsCellClick(Column: TColumnEh);

    procedure DeleteMails;
    procedure FillSelectedRows(Grid : TToughDBGrid);

    procedure BodyEnter(Sender : TObject);
    procedure BodyExit(Sender : TObject);

    procedure SetClear;
    procedure InternalSearch;
    procedure SearchFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure AddKeyToSearch(Key : Char);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
  public
    { Public declarations }
    dsMails : TDataSource;
    dsAttachments : TDataSource;

    mdMails : TMyQuery;
    fId : TLargeintField;
    fLogTime : TDateTimeField;
    fSupplierId : TLargeintField;
    fSupplierName : TStringField;
    fSubject : TStringField;
    fBody : TMemoField;
    fIsVIPMail : TBooleanField;
    fIsNewMail : TBooleanField;
    fIsImportantMail : TBooleanField;

    mdAttachments : TMyQuery;
    fAttachmentId : TLargeintField;
    fMailId : TLargeintField;
    fFileName : TStringField;
    fExtension : TStringField;
    fSize : TLargeintField;
    fRequestAttachment : TBooleanField;
    fRecievedAttachment : TBooleanField;

    gbMail: TGroupBox;

    pMailBody : TPanel;

    pHeaders : TPanel;
    pFilter : TPanel;
    eSearch : TEdit;
    pActions : TPanel;
    sbDelete : TSpeedButton;
    legend : TframeBaseLegend;

    dbgMailHeaders : TToughDBGrid;

    pAttachments : TPanel;
    pAttachmentHeaders : TPanel;
    dbtSubject: TDBText;
    dbtSupplierName: TDBText;
    dbtLogTime: TDBText;
    dbmBody : TDBMemo;
    dbgMailAttachemts : TToughDBGrid;

    constructor Create(AOwner: TComponent); override;
    procedure PrepareFrame;
    class function AddFrame(
      Owner: TComponent;
      Parent: TWinControl) : TframeMiniMail;
    procedure SaveChanges();  
  end;

implementation

{$R *.dfm}

{ TframeMiniMail }

class function TframeMiniMail.AddFrame(Owner: TComponent;
  Parent: TWinControl): TframeMiniMail;
begin
  Result := TframeMiniMail.Create(Owner);
  Result.Parent := Parent;
  Result.PrepareFrame;
end;

constructor TframeMiniMail.Create(AOwner: TComponent);
begin
  inherited;

  FSelectedRows := TStringList.Create();
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  CreateNonVisualComponent;
  CreateVisualComponent;

  gbMail.ControlStyle := gbMail.ControlStyle - [csParentBackground] + [csOpaque];
  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframeMiniMail.CreateVisualComponent;
var
  column : TColumnEh;
  vipLabel : TLabel;
begin
  gbMail := TGroupBox.Create(Self);
  gbMail.Parent := Self;
  gbMail.Align := alClient;
  gbMail.Caption := ' Почта ';

  pMailBody := TPanel.Create(Self);
  pMailBody.Name := 'pMailBody';
  pMailBody.Caption := '';
  pMailBody.BevelInner := bvLowered;
  pMailBody.BevelOuter := bvRaised;
  pMailBody.Parent := gbMail;
  pMailBody.Align := alRight;
  pMailBody.ControlStyle := pMailBody.ControlStyle - [csParentBackground] + [csOpaque];

  pHeaders := TPanel.Create(Self);
  pHeaders.Name := 'pHeaders';
  pHeaders.Caption := '';
  pHeaders.BevelInner := bvLowered;
  pHeaders.BevelOuter := bvRaised;
  pHeaders.Parent := gbMail;
  pHeaders.Align := alClient;
  pHeaders.ControlStyle := pHeaders.ControlStyle - [csParentBackground] + [csOpaque];

  pFilter := TPanel.Create(Self);
  pFilter.Name := 'pFilter';
  pFilter.Caption := '';
  pFilter.BevelInner := bvLowered;
  pFilter.BevelOuter := bvRaised;
  pFilter.Parent := pHeaders;
  pFilter.Align := alTop;
  pFilter.ControlStyle := pFilter.ControlStyle - [csParentBackground] + [csOpaque];

  eSearch := TEdit.Create(Self);
  eSearch.Parent := pFilter;
  eSearch.Left := 7;
  eSearch.Width := FCanvas.TextWidth('Это строка поиска');
  pFilter.Height := eSearch.Height + 15;
  eSearch.Top := 8;

  pActions := TPanel.Create(Self);
  pActions.Name := 'pActions';
  pActions.Caption := '';
  pActions.BevelInner := bvLowered;
  pActions.BevelOuter := bvRaised;
  pActions.Parent := pHeaders;
  pActions.Align := alBottom;
  pActions.ControlStyle := pActions.ControlStyle - [csParentBackground] + [csOpaque];

  sbDelete := TSpeedButton.Create(Self);
  sbDelete.Height := 25;
  sbDelete.Caption := 'Удалить';
  sbDelete.Parent := pActions;
  sbDelete.Width := FCanvas.TextWidth(sbDelete.Caption) + 20;
  sbDelete.Left := 5;
  sbDelete.Top := 8;
  sbDelete.OnClick := sbDeleteClick;
  pFilter.Height := sbDelete.Height + 15;

  legend := TframeBaseLegend.Create(Self);
  legend.Parent := pHeaders;
  legend.Align := alBottom;
  legend.CreateLegendLabel('Новое письмо', GroupColor,  clWindowText, 'Новое письмо');
  legend.CreateLegendLabel('Важное письмо', clLime,  clWindowText, 'Важное письмо');
  vipLabel := legend.CreateLegendLabel('Спец. отправитель', legend.Color,  clWindowText, 'Спец. отправитель');
  vipLabel.Font.Style := vipLabel.Font.Style + [fsBold];

  dbgMailHeaders := TToughDBGrid.Create(Self);
  dbgMailHeaders.Parent := pHeaders;
  dbgMailHeaders.Align := alClient;

  TDBGridHelper.SetDefaultSettingsToGrid(dbgMailHeaders);

  dbgMailHeaders.AllowedSelections := dbgMailHeaders.AllowedSelections - [gstColumns];
  dbgMailHeaders.AllowedOperations := [alopUpdateEh];
  dbgMailHeaders.Options := dbgMailHeaders.Options + [dgMultiSelect];  

  column := TDBGridHelper.AddColumn(dbgMailHeaders, 'LogTime', 'Дата', FCanvas.TextWidth('20110000 0000'));
  column.MinWidth := FCanvas.TextWidth('2011.00.00') + 3;
  column := TDBGridHelper.AddColumn(dbgMailHeaders, 'IsImportantMail', 'Важное', FCanvas.TextWidth('Важное'), False);
  column.MinWidth := FCanvas.TextWidth('Важн') + 3;
  column := TDBGridHelper.AddColumn(dbgMailHeaders, 'SupplierName', 'Отправитель', FCanvas.TextWidth('Отправитель'));
  column.MinWidth := FCanvas.TextWidth('Отправитель') + 3;
  TDBGridHelper.AddColumn(dbgMailHeaders, 'Subject', 'Тема', FCanvas.TextWidth('это очень большая тема письма, которая только может быть в письме'));

  TDBGridHelper.SetTitleButtonToColumns(dbgMailHeaders);

  //dbgMailHeaders.OnKeyPress := dbgMinPricesKeyPress;
  dbgMailHeaders.OnKeyDown := dbgMailHeadersKeyDown;
  dbgMailHeaders.OnSortMarkingChanged := dbgMailHeadersSortMarkingChanged;
  dbgMailHeaders.OnGetCellParams := dbgMailHeadersGetCellParams;

  dbgMailHeaders.DataSource := dsMails;

  pAttachments := TPanel.Create(Self);
  pAttachments.Name := 'pAttachments';
  pAttachments.Caption := '';
  pAttachments.BevelInner := bvLowered;
  pAttachments.BevelOuter := bvRaised;
  pAttachments.Parent := pMailBody;
  pAttachments.Align := alTop;
  pAttachments.ControlStyle := pAttachments.ControlStyle - [csParentBackground] + [csOpaque];

  pAttachmentHeaders := TPanel.Create(Self);
  pAttachmentHeaders.Name := 'pAttachmentHeaders';
  pAttachmentHeaders.Caption := '';
  pAttachmentHeaders.BevelInner := bvNone;
  pAttachmentHeaders.BevelOuter := bvNone;
  pAttachmentHeaders.Parent := pAttachments;
  pAttachmentHeaders.Align := alTop;
  pAttachmentHeaders.ControlStyle := pAttachmentHeaders.ControlStyle - [csParentBackground] + [csOpaque];

  dbtSubject := TDBText.Create(Self);
  dbtSubject.Name := 'dbtSubject';
  dbtSubject.Parent := pAttachmentHeaders;
  dbtSubject.Left := 5;
  dbtSubject.Top := 5;
  dbtSubject.Width := pAttachmentHeaders.Width - 16;
  dbtSubject.Anchors := dbtSubject.Anchors + [akRight];
  dbtSubject.Font.Style := dbtSubject.Font.Style + [fsBold];
  dbtSubject.DataSource := dsMails;
  dbtSubject.DataField := fSubject.FieldName;

  dbtSupplierName := TDBText.Create(Self);
  dbtSupplierName.Name := 'dbtSupplierName';
  dbtSupplierName.Parent := pAttachmentHeaders;
  dbtSupplierName.Left := 5;
  dbtSupplierName.Top := dbtSubject.Top + dbtSubject.Height + 3;
  dbtSupplierName.Width := FCanvas.TextWidth('Это длинное имя поставщика');
  dbtSupplierName.DataSource := dsMails;
  dbtSupplierName.DataField := fSupplierName.FieldName;

  dbtLogTime := TDBText.Create(Self);
  dbtLogTime.Name := 'dbtLogTime';
  dbtLogTime.Parent := pAttachmentHeaders;
  dbtLogTime.Top := dbtSupplierName.Top;
  dbtLogTime.Width := FCanvas.TextWidth('00.00.0000 00:00:00');
  dbtLogTime.Left := pAttachmentHeaders.Width - 16 - dbtLogTime.Width;
  dbtLogTime.DataSource := dsMails;
  dbtLogTime.DataField := fLogTime.FieldName;

  pAttachmentHeaders.Height := dbtSupplierName.Top + dbtSupplierName.Height + 2;

  pAttachments.Height := pAttachmentHeaders.Height + 60;

  dbgMailAttachemts := TToughDBGrid.Create(Self);
  dbgMailAttachemts.Parent := pAttachments;
  dbgMailAttachemts.Align := alClient;

  pAttachments.Height := pAttachmentHeaders.Height + TDBGridHelper.GetStdDefaultRowHeight(dbgMailAttachemts) * 4;

  TDBGridHelper.SetDefaultSettingsToGrid(dbgMailAttachemts);

  column := TDBGridHelper.AddColumn(dbgMailAttachemts, 'RequestAttachment', 'Получить', FCanvas.TextWidth('Получить'));
  column.ReadOnly := False;
  column := TDBGridHelper.AddColumn(dbgMailAttachemts, 'RecievedAttachment', 'Файл', FCanvas.TextWidth('Файл'));
  column.Checkboxes := False;
  TDBGridHelper.AddColumn(dbgMailAttachemts, 'FileName', 'Вложение');
  TDBGridHelper.AddColumn(dbgMailAttachemts, 'Size', 'Размер', FCanvas.TextWidth('Размер'));

  dbgMailAttachemts.OnGetCellParams := dbgMailAttachemtsGetCellParams;
  dbgMailAttachemts.OnCellClick := dbgMailAttachemtsCellClick;

  dbgMailAttachemts.Width := FCanvas.TextWidth('Получить') + FCanvas.TextWidth('Вложение это большое длиное имя') + 30;

  dbgMailAttachemts.DataSource := dsAttachments;

  dbmBody := TDBMemo.Create(Self);
  dbmBody.Parent := pMailBody;
  dbmBody.Align := alClient;
  dbmBody.ReadOnly := True;
  dbmBody.Color := clBtnFace;
  dbmBody.DataField := 'Body';
  dbmBody.DataSource := dsMails;
  dbmBody.OnEnter := BodyEnter;
  dbmBody.OnExit := BodyExit;
end;

procedure TframeMiniMail.PrepareFrame;
begin
  //InsertTestData();

{
  WriteExchangeLog('DModule',
      Concat('Mails', #13#10,
        DM.DataSetToString('select Id, LogTime, SupplierId, SupplierName, Subject, Body, IsNewMail, IsVipMail, IsImportantMail from Mails', [], [])));
}        

  mdMails.Connection := DM.MainConnection;
  mdAttachments.Connection := DM.MainConnection;

  mdMails.Open();
  mdAttachments.Open();
end;

procedure TframeMiniMail.ProcessResize;
var
  minHeight,
  maxHeight,
  needHeight : Integer;
begin
  if Assigned(pMailBody) then begin
    pMailBody.Width := (gbMail.Width div 2);
  end;
  if Assigned(dbtLogTime) and Assigned(pAttachmentHeaders) then
    dbtLogTime.Left := pAttachmentHeaders.Width - 16 - dbtLogTime.Width;
  if Assigned(dbgMailAttachemts) and Assigned(mdAttachments) then begin
    minHeight := TDBGridHelper.GetStdDefaultRowHeight(dbgMailAttachemts)*4;
    maxHeight := pMailBody.Height div 4;
    needHeight := TDBGridHelper.GetStdDefaultRowHeight(dbgMailAttachemts) * (mdAttachments.RecordCount + 2);
    if needHeight > maxHeight then
      needHeight := maxHeight;
    if needHeight < minHeight then
      needHeight := minHeight;
    pAttachments.Height := pAttachmentHeaders.Height + needHeight;
  end;
end;

procedure TframeMiniMail.FrameResize(Sender: TObject);
begin
  ProcessResize;
end;

procedure TframeMiniMail.CreateNonVisualComponent;
begin
  mdMails := TMyQuery.Create(Self);

  fId := TDataSetHelper.AddLargeIntField(mdMails, 'Id');
  fLogTime := TDataSetHelper.AddDateTimeField(mdMails, 'LogTime');
  fSupplierId := TDataSetHelper.AddLargeIntField(mdMails, 'SupplierId');
  fSupplierName := TDataSetHelper.AddStringField(mdMails, 'SupplierName');
  fSubject := TDataSetHelper.AddStringField(mdMails, 'Subject');
  fIsVIPMail := TDataSetHelper.AddBooleanField(mdMails, 'IsVIPMail');
  fIsNewMail := TDataSetHelper.AddBooleanField(mdMails, 'IsNewMail');
  fIsImportantMail := TDataSetHelper.AddBooleanField(mdMails, 'IsImportantMail');

  fBody := TMemoField.Create(mdMails);
  fBody.BlobType := ftMemo;
  fBody.fieldname := 'Body';
  fBody.Dataset := mdMails;

  dsMails := TDataSource.Create(Self);
  dsMails.DataSet := mdMails;

  mdMails.SQL.Text := 'select Id, LogTime, SupplierId, SupplierName, IsVIPMail, Subject, Body, IsNewMail, IsImportantMail from Mails order by LogTime desc ';

  mdAttachments := TMyQuery.Create(Self);

  fAttachmentId := TDataSetHelper.AddLargeIntField(mdAttachments, 'Id');
  fMailId := TDataSetHelper.AddLargeIntField(mdAttachments, 'MailId');
  fFileName := TDataSetHelper.AddStringField(mdAttachments, 'FileName');
  fExtension := TDataSetHelper.AddStringField(mdAttachments, 'Extension');
  fSize := TDataSetHelper.AddLargeIntField(mdAttachments, 'Size');
  fRequestAttachment := TDataSetHelper.AddBooleanField(mdAttachments, 'RequestAttachment');
  fRecievedAttachment := TDataSetHelper.AddBooleanField(mdAttachments, 'RecievedAttachment');
  fRecievedAttachment.OnGetText := fRecievedAttachmentGetText;

  mdAttachments.SQL.Text := 'select Id, MailId, FileName, Extension, Size, RequestAttachment, RecievedAttachment from Attachments ';

  mdAttachments.MasterSource := dsMails;
  mdAttachments.MasterFields := 'Id';
  mdAttachments.DetailFields := 'MailId';

  dsAttachments := TDataSource.Create(Self);
  dsAttachments.DataSet := mdAttachments;
end;

procedure TframeMiniMail.InsertTestData;
begin
  DM.MainConnection.ExecSQL(''
  + 'delete from Attachments;'
  + 'delete from Mails;'
  + 'insert into Mails(Id, LogTime, SupplierId, SupplierName, Subject, Body) values (1, now(), 1, "СИА", "тест 1", "Это тело письма 1");'
  + 'insert into Mails(Id, LogTime, SupplierId, SupplierName, Subject, Body) values (2, now() - interval 1 day, 2, "Протек", "тест 2", "Это тело письма Здесь есть письмо");'
  + 'insert into Mails(Id, LogTime, SupplierId, SupplierName, Subject, Body, IsVipMail) values (3, now() - interval 5 day, 3, "Катрен", "тест 3", "Это тело письма Это еще одно письмо", :IsVipMail);'
  + 'insert into Attachments(Id, MailId, FileName, Extension, Size, RequestAttachment, RecievedAttachment) values (1, 1, "test.zip", ".zip", 100, 1, 0);'
  + 'insert into Attachments(Id, MailId, FileName, Extension, Size, RequestAttachment, RecievedAttachment) values (2, 1, "test3.zip", ".zip", 200, 0, 0);'
  + 'insert into Attachments(Id, MailId, FileName, Extension, Size, RequestAttachment, RecievedAttachment) values (3, 3, "test4.zip", ".zip", 300, 0, 1);'
  ,
  [1]
  );
{
  mdMails.Open;
  mdMails.AppendRecord([1, Now(), 'СИА', 'тест 1', 'Это тело письма 1']);
  mdMails.AppendRecord([2, IncDay(Now(), -1) , 'Протек', 'тест 2', 'Это тело письма Здесь есть письмо']);
  mdMails.AppendRecord([3, IncDay(Now(), -5), 'Катрен', 'тест 3', 'Это тело письма'#13#10'Это еще одно письмо']);
}
end;

procedure TframeMiniMail.dbgMailHeadersSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TframeMiniMail.dbgMailHeadersGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if fIsVIPMail.Value then
    AFont.Style := AFont.Style + [fsBold];
  if fIsNewMail.Value then
    Background := GroupColor;
  if fIsImportantMail.Value then
    Background := clLime;
end;

procedure TframeMiniMail.dbgMailHeadersKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
    DeleteMails();
end;

procedure TframeMiniMail.DeleteMails;
var
  I : Integer;
  logMessage : String;
begin
  if not mdMails.IsEmpty then
  begin
    FillSelectedRows(dbgMailHeaders);
    if FSelectedRows.Count > 0 then
      if AProc.MessageBox( 'Удалить выбранные письма?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then begin
        mdMails.DisableControls;
        try
          for I := 0 to FSelectedRows.Count-1 do begin
            mdMails.Bookmark := FSelectedRows[i];
            logMessage := Format('Удаление письма Id: %s', [fId.AsString]);
            DM.MainConnection.ExecSQL(
              'delete from Attachments where MailId = :MailId;',
              [fId.AsString]
            );
            mdMails.Delete;
            WriteExchangeLog('DeleteMails', logMessage);
          end;
        finally
          mdMails.EnableControls;
        end;
      end;
  end;
end;

procedure TframeMiniMail.sbDeleteClick(Sender: TObject);
begin
  DeleteMails;
end;

procedure TframeMiniMail.FillSelectedRows(Grid: TToughDBGrid);
var
  CurrentBookmark : String;
begin
  FSelectedRows.Clear;

  //Если выделение не Rect, то берем только текущую строку, иначе работаем
  //со свойством Grid.Selection.Rect
  if Grid.Selection.SelectionType <> gstRectangle then
    FSelectedRows.Add(Grid.DataSource.DataSet.Bookmark)
  else begin
    CurrentBookmark := Grid.DataSource.DataSet.Bookmark;
    Grid.DataSource.DataSet.DisableControls;
    try
      Grid.DataSource.DataSet.Bookmark := Grid.Selection.Rect.TopRow;
      repeat
        FSelectedRows.Add(Grid.DataSource.DataSet.Bookmark);
        if Grid.DataSource.DataSet.Bookmark = Grid.Selection.Rect.BottomRow then
          Break
        else
          Grid.DataSource.DataSet.Next;
      until Grid.DataSource.DataSet.Eof;
    finally
      Grid.DataSource.DataSet.Bookmark := CurrentBookmark;
      Grid.DataSource.DataSet.EnableControls;
    end;
  end;
end;

procedure TframeMiniMail.dbgMailAttachemtsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if Column.Field = fRecievedAttachment then
    if not fRecievedAttachment.IsNull and fRecievedAttachment.AsBoolean then begin
      AFont.Style := AFont.Style + [fsUnderline];
      AFont.Color := clHotLight;
    end;
end;

procedure TframeMiniMail.dbgMailAttachemtsCellClick(Column: TColumnEh);
begin
  if (Column.Field = fRecievedAttachment) and not fRecievedAttachment.IsNull
    and fRecievedAttachment.AsBoolean
  then
    DM.OpenAttachment(fAttachmentId.Value);
end;

procedure TframeMiniMail.fRecievedAttachmentGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if DisplayText then
    if fRecievedAttachment.IsNull or not fRecievedAttachment.AsBoolean then
      Text := ''
    else
      Text := 'Показать';
end;

procedure TframeMiniMail.SaveChanges;
begin
  if Assigned(mdAttachments) then
    SoftPost(mdAttachments);
  if Assigned(mdMails) then
    SoftPost(mdMails);
end;

procedure TframeMiniMail.BodyEnter(Sender: TObject);
begin
  dbmBody.Color := clWindowText;
end;

procedure TframeMiniMail.BodyExit(Sender: TObject);
begin
  dbmBody.Color := clBtnFace;
end;

procedure TframeMiniMail.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if (Length(eSearch.Text) > 2) then begin
    InternalSearchText := StrUtils.LeftStr(eSearch.Text, 50);
    InternalSearch;
    eSearch.Text := '';
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TframeMiniMail.InternalSearch;
begin
  DBProc.SetFilterProc(mdMails, SearchFilterRecord);

  mdMails.First;

  dbgMailHeaders.SetFocus;
end;

procedure TframeMiniMail.SetClear;
begin
  tmrSearch.Enabled := False;
  eSearch.Text := '';
  InternalSearchText := '';
  DBProc.SetFilterProc(mdMails, nil);
end;

procedure TframeMiniMail.SearchFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := AnsiContainsText(fSupplierName.DisplayText, InternalSearchText)
    or AnsiContainsText(fSubject.DisplayText, InternalSearchText)
    or AnsiContainsText(fBody.DisplayText, InternalSearchText);
end;

procedure TframeMiniMail.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TframeMiniMail.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TframeMiniMail.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //Если мы что-то нажали в элементе, то должны на это отреагировать
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

end.
