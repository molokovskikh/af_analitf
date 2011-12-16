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
  RxMemDS,
  ToughDBGrid,
  AProc,
  DBGridHelper;

type
  TframeMiniMail = class(TFrame)
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    FCanvas : TCanvas;
    
    procedure CreateVisualComponent;
    procedure CreateNonVisualComponent;

    procedure ProcessResize;
  public
    { Public declarations }
    dsMails : TDataSource;
    dsAttachemnts : TDataSource;

    mdMails : TRxMemoryData;
    fId : TIntegerField;
    fLogTime : TDateTimeField;
    fSupplierName : TStringField;
    fSubject : TStringField;
    fBody : TStringField;

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

  TDBGridHelper.AddColumn(dbgMailHeaders, 'LogTime', 'Дата');
  TDBGridHelper.AddColumn(dbgMailHeaders, 'SupplierName', 'Поставщик');
  TDBGridHelper.AddColumn(dbgMailHeaders, 'Subject', 'Тема');

  dbgMailHeaders.DataSource := dsMails;

  //dbgMailAttachemts : TToughDBGrid;


  dbgMailAttachemts := TToughDBGrid.Create(Self);
  dbgMailAttachemts.Parent := pMailBody;
  dbgMailAttachemts.Align := alRight;

  TDBGridHelper.SetDefaultSettingsToGrid(dbgMailAttachemts);
  //dbgMailAttachemts.Options := dbgMailAttachemts.Options + [dgEditing];

  //dbgMailAttachemts.AutoFitColWidths := False;

  //dbgMailAttachemts.OnGetCellParams := MarkupsGetCellParams;

  TDBGridHelper.AddColumn(dbgMailAttachemts, 'Request', 'Получить', FCanvas.TextWidth('Получить'));
  TDBGridHelper.AddColumn(dbgMailAttachemts, 'AttachemntName', 'Вложение');

  dbgMailAttachemts.Width := FCanvas.TextWidth('Получить') + FCanvas.TextWidth('Вложение это большое длиное имя') + 30;

  dbgMailAttachemts.DataSource := dsAttachemnts;

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
  mdMails := TRxMemoryData.Create(Self);

  fId := TIntegerField.Create(mdMails);
  fId.fieldname := 'Id';
  fId.Dataset := mdMails;

  fLogTime := TDateTimeField.Create(mdMails);
  fLogTime.fieldname := 'LogTime';
  fLogTime.Dataset := mdMails;

  fSupplierName := TStringField.Create(mdMails);
  fSupplierName.fieldname := 'SupplierName';
  fSupplierName.Size := 50;
  fSupplierName.Dataset := mdMails;

  fSubject := TStringField.Create(mdMails);
  fSubject.fieldname := 'Subject';
  fSubject.Size := 255;
  fSubject.Dataset := mdMails;

  fBody := TStringField.Create(mdMails);
  fBody.fieldname := 'Body';
  fBody.Size := 255;
  fBody.Dataset := mdMails;

  dsMails := TDataSource.Create(Self);
  dsMails.DataSet := mdMails;

  dsAttachemnts := TDataSource.Create(Self);

  mdMails.Open;
  mdMails.AppendRecord([1, Now(), 'СИА', 'тест 1', 'Это тело письма 1']);
  mdMails.AppendRecord([2, IncDay(Now(), -1) , 'Протек', 'тест 2', 'Это тело письма Здесь есть письмо']);
  mdMails.AppendRecord([3, IncDay(Now(), -5), 'Катрен', 'тест 3', 'Это тело письма'#13#10'Это еще одно письмо']);

  mdMails.First;
end;

procedure TframeMiniMail.UpdateMail;
begin
  ShowMessage('UpdateMail');
end;

end.
