unit U_frameMiniMail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
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
  DataSetHelper;

type
  TframeMiniMail = class(TFrame)
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    FCanvas : TCanvas;
    
    procedure CreateVisualComponent;
    procedure CreateNonVisualComponent;

    procedure InsertTestData();

    procedure ProcessResize;
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

{
+'  `Id`                  bigint(20) unsigned NOT NULL DEFAULT ''0'', '
+'  `MailId`              bigint(20) unsigned NOT NULL, '
+'  `FileName`            varchar(255) NOT NULL, '
+'  `Extension`           varchar(255) NOT NULL, '
+'  `Size`                bigint(20) unsigned NOT NULL, '
+'  `RequestAttachment`   tinyint(1) not null default ''0'', '
+'  `RecievedAttachment`  tinyint(1) not null default ''0'', '
}

    gbMail: TGroupBox;

    pMailBody : TPanel;

    dbgMailHeaders : TToughDBGrid;

    dbmBody : TDBMemo;
    dbgMailAttachemts : TToughDBGrid;

    constructor Create(AOwner: TComponent); override;
    procedure PrepareFrame;
    class function AddFrame(
      Owner: TComponent;
      Parent: TWinControl) : TframeMiniMail;
    procedure UpdateMail();
  end;

implementation

{$R *.dfm}

{ TframeMiniMail }

class function TframeMiniMail.AddFrame(Owner: TComponent;
  Parent: TWinControl): TframeMiniMail;
begin
  Result := TframeMiniMail.Create(Owner);
  Result.Parent := Parent;
  //Result.Promotion := Promotion;
  Result.PrepareFrame;
end;

constructor TframeMiniMail.Create(AOwner: TComponent);
begin
  inherited;

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

  dbgMailHeaders := TToughDBGrid.Create(Self);
  dbgMailHeaders.Parent := gbMail;
  dbgMailHeaders.Align := alClient;

  TDBGridHelper.SetDefaultSettingsToGrid(dbgMailHeaders);
  //dbgMailHeaders.Options := dbgMailHeaders.Options + [dgEditing];

  //dbgMailHeaders.AutoFitColWidths := False;

  //dbgMailHeaders.OnGetCellParams := MarkupsGetCellParams;

  TDBGridHelper.AddColumn(dbgMailHeaders, 'LogTime', 'Дата', FCanvas.TextWidth('20110000 0000'));
  TDBGridHelper.AddColumn(dbgMailHeaders, 'IsImportantMail', 'Важное', FCanvas.TextWidth('Важное'), False);
  TDBGridHelper.AddColumn(dbgMailHeaders, 'SupplierName', 'Отправитель', FCanvas.TextWidth('Отправитель'));
  TDBGridHelper.AddColumn(dbgMailHeaders, 'Subject', 'Тема', FCanvas.TextWidth('это очень большая тема письма, которая только может быть в письме'));

  dbgMailHeaders.DataSource := dsMails;

  //dbgMailAttachemts : TToughDBGrid;


  dbgMailAttachemts := TToughDBGrid.Create(Self);
  dbgMailAttachemts.Parent := pMailBody;
  dbgMailAttachemts.Align := alRight;

  TDBGridHelper.SetDefaultSettingsToGrid(dbgMailAttachemts);
  //dbgMailAttachemts.Options := dbgMailAttachemts.Options + [dgEditing];

  //dbgMailAttachemts.AutoFitColWidths := False;

  //dbgMailAttachemts.OnGetCellParams := MarkupsGetCellParams;

  column := TDBGridHelper.AddColumn(dbgMailAttachemts, 'RequestAttachment', 'Получить', FCanvas.TextWidth('Получить'));
  column.ReadOnly := False;
  TDBGridHelper.AddColumn(dbgMailAttachemts, 'FileName', 'Файл', FCanvas.TextWidth('Файл'));
  TDBGridHelper.AddColumn(dbgMailAttachemts, 'FileName', 'Вложение');
  TDBGridHelper.AddColumn(dbgMailAttachemts, 'Size', 'Размер', FCanvas.TextWidth('Размер'));

  dbgMailAttachemts.Width := FCanvas.TextWidth('Получить') + FCanvas.TextWidth('Вложение это большое длиное имя') + 30;

  dbgMailAttachemts.DataSource := dsAttachments;

  dbmBody := TDBMemo.Create(Self);
  dbmBody.Parent := pMailBody;
  dbmBody.Align := alClient;
  dbmBody.ReadOnly := True;
  dbmBody.Color := clBtnFace;
  dbmBody.DataField := 'Body';
  dbmBody.DataSource := dsMails;
end;

procedure TframeMiniMail.PrepareFrame;
begin
end;

procedure TframeMiniMail.ProcessResize;
begin
  if Assigned(pMailBody) then
    pMailBody.Width := gbMail.Width div 2;
end;

procedure TframeMiniMail.FrameResize(Sender: TObject);
begin
  ProcessResize;
end;

procedure TframeMiniMail.CreateNonVisualComponent;
begin
  mdMails := TMyQuery.Create(Self);
  mdMails.Connection := DM.MainConnection;

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
  mdAttachments.Connection := DM.MainConnection;

  fAttachmentId := TDataSetHelper.AddLargeIntField(mdAttachments, 'Id');
  fMailId := TDataSetHelper.AddLargeIntField(mdAttachments, 'MailId');
  fFileName := TDataSetHelper.AddStringField(mdAttachments, 'FileName');
  fExtension := TDataSetHelper.AddStringField(mdAttachments, 'Extension');
  fSize := TDataSetHelper.AddLargeIntField(mdAttachments, 'Size');
  fRequestAttachment := TDataSetHelper.AddBooleanField(mdAttachments, 'RequestAttachment');
  fRecievedAttachment := TDataSetHelper.AddBooleanField(mdAttachments, 'RecievedAttachment');

  mdAttachments.SQL.Text := 'select Id, MailId, FileName, Extension, Size, RequestAttachment, RecievedAttachment from Attachments ';

  mdAttachments.MasterSource := dsMails;
  mdAttachments.MasterFields := 'Id';
  mdAttachments.DetailFields := 'MailId';

  dsAttachments := TDataSource.Create(Self);
  dsAttachments.DataSet := mdAttachments;

  InsertTestData();

  mdMails.Open();
  mdAttachments.Open;
  //mdMails.First;
end;

procedure TframeMiniMail.UpdateMail;
begin
  //ShowMessage('UpdateMail');
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

end.
