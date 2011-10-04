unit U_ServiceLogForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls,
  StdCtrls,
  ComCtrls,
  DBCtrls,
  StrUtils,
  DateUtils,
  DB,
  DBAccess,
  MyAccess,
  GridsEh,
  DbGridEh,
  ToughDBGrid,
  U_frameServiceLogLegend;

type
  TServiceLogForm = class(TChildForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    adsLog : TMyQuery;
    dsLog : TDataSource;

    IdField : TLargeintField;
    LogTimeField : TDateTimeField;
    SourceField : TSmallintField;
    MessageTypeField : TSmallintField;
    InfoField : TMemoField;

    pTop : TPanel;
    lStart : TLabel;
    lEnd : TLabel;
    dtpStart : TDateTimePicker;
    dtpEnd : TDateTimePicker;

    pGrid : TPanel;
    dbgLog : TToughDBGrid;
    gbInfo : TGroupBox;
    dbmInfo : TDBMemo;

    frameLegend : TframeServiceLogLegend;

    procedure CreateNonVisualComponent;
    procedure SourceGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);

    procedure CreateVisualComponent;

    procedure CreateTopPanel;

    procedure CreateGridPanel;
    procedure LogGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);

    procedure CreateLegendPanel;

    procedure BindFields;
  public
    { Public declarations }
    procedure ShowForm; override;
  end;

  procedure ShowServiceLog();

implementation

{$R *.dfm}

uses
  Main,
  DModule,
  DBGridHelper,
  DataSetHelper,
  AProc,
  DBProc;

{
,
  Exchange,
  NamesForms,
  NetworkSettings}  

procedure ShowServiceLog();
var
  ServiceLogForm: TServiceLogForm;
begin
  ServiceLogForm := TServiceLogForm(MainForm.ShowChildForm( TServiceLogForm ));
  ServiceLogForm.ShowForm;
end;

procedure TServiceLogForm.BindFields;
begin
  dbgLog.DataSource := dsLog;

  dbmInfo.DataField := 'Info';
  dbmInfo.DataSource := dsLog;

  adsLog.Open;
end;

procedure TServiceLogForm.CreateGridPanel;
begin
  pGrid := TPanel.Create(Self);
  pGrid.Parent := Self;
  pGrid.Align := alClient;

  gbInfo := TGroupBox.Create(Self);
  gbInfo.Parent := pGrid;
  gbInfo.Caption := ' Дополнительная информация ';
  gbInfo.Align := alBottom;

  dbmInfo := TDBMemo.Create(Self);
  dbmInfo.Parent := gbInfo;
  dbmInfo.Align := alClient;
  dbmInfo.ReadOnly := True;
  dbmInfo.ScrollBars := ssBoth;
  dbmInfo.Color := clBtnFace;

  dbgLog := TToughDBGrid.Create(Self);
  dbgLog.Name := 'dbgLog';
  dbgLog.Parent := pGrid;
  dbgLog.Align := alClient;
  dbgLog.DrawMemoText := True;

  TDBGridHelper.SetDefaultSettingsToGrid(dbgLog);

  dbgLog.OnGetCellParams := LogGetCellParams;

  TDBGridHelper.AddColumn(dbgLog, 'LogTime', 'Дата', Self.Canvas.TextWidth(DateTimeToStr(Now())));
  TDBGridHelper.AddColumn(dbgLog, 'Source', 'Источник', Self.Canvas.TextWidth('Импорт заказов'));
  TDBGridHelper.AddColumn(dbgLog, 'Info', 'Дополнительная информация', Self.Canvas.TextWidth('Это очень очень очень очень очень очень очень длинный текст'));
end;

procedure TServiceLogForm.CreateLegendPanel;
begin
  frameLegend := TframeServiceLogLegend.Create(Self);
  frameLegend.Parent := Self;
  frameLegend.Align := alBottom;
end;

procedure TServiceLogForm.CreateNonVisualComponent;
begin
  adsLog := TMyQuery.Create(Self);
  adsLog.Name := 'adsLog';
  adsLog.SQL.Text := 'select Id, LogTime, Source, MessageType, Info from networklog order by LogTime desc';

  IdField := TDataSetHelper.AddLargeIntField(adsLog, 'Id');
  LogTimeField := TDataSetHelper.AddDateTimeField(adsLog, 'LogTime');
  SourceField := TDataSetHelper.AddSmallintField(adsLog, 'Source');
  SourceField.OnGetText := SourceGetText;
  MessageTypeField := TDataSetHelper.AddSmallintField(adsLog, 'MessageType');
  InfoField := TDataSetHelper.AddMemoField(adsLog, 'Info');

  dsLog := TDataSource.Create(Self);
  dsLog.DataSet := adsLog;
end;

procedure TServiceLogForm.CreateTopPanel;
var
  Year, Month, Day: Word;
begin
  pTop := TPanel.Create(Self);
  pTop.Parent := Self;
  pTop.Align := alTop;

  lStart := TLabel.Create(Self);
  lStart.Parent := pTop;
  lStart.Caption := 'Вывести за период с ';
  lStart.Width := lStart.Canvas.TextWidth(lStart.Caption);

  lEnd := TLabel.Create(Self);
  lEnd.Parent := pTop;
  lEnd.Caption := ' по ';
  lEnd.Width := lStart.Canvas.TextWidth(lEnd.Caption);

  dtpStart := TDateTimePicker.Create(Self);
  dtpStart.Parent := pTop;
  dtpStart.Width := Self.Canvas.TextWidth(DateToStr(Now())) + 30;

  dtpEnd := TDateTimePicker.Create(Self);
  dtpEnd.Parent := pTop;
  dtpEnd.Width := dtpStart.Width;

  lStart.Left := 10;
  dtpStart.Left := lStart.Left + lStart.Width + 5;
  lEnd.Left := dtpStart.Left + dtpStart.Width + 5;
  dtpEnd.Left := lEnd.Left + lEnd.Width + 5;

  Year := YearOf( Date);
  Month := MonthOf( Date);
  Day := DayOf( Date);
  IncAMonth( Year, Month, Day, -3);
  dtpStart.Date := StartOfTheMonth( EncodeDate( Year, Month, Day));
  dtpEnd.Date := Date;

  pTop.Height := dtpStart.Height+10;
  dtpStart.Top := 5;
  dtpEnd.Top := dtpStart.Top;
  lStart.Top := (pTop.ClientHeight - dtpStart.Height) div 2;
  lEnd.Top := lStart.Top;

  //  dtpEnd : TDateTimePicker;

end;

procedure TServiceLogForm.CreateVisualComponent;
begin
  CreateTopPanel;

  CreateLegendPanel;

  CreateGridPanel;
end;

procedure TServiceLogForm.FormCreate(Sender: TObject);
begin
  CreateNonVisualComponent;
  CreateVisualComponent;

  inherited;
end;

procedure TServiceLogForm.LogGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not MessageTypeField.IsNull then begin
    case MessageTypeField.Value of
      1 : Background := clYellow;
      2 : Background := clRed;
    end;
  end;
end;

procedure TServiceLogForm.ShowForm;
begin
  BindFields;

  inherited;

  dbgLog.SetFocus();
end;

procedure TServiceLogForm.SourceGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if DisplayText then
    Text := IfThen(Sender.AsInteger = 0, 'Обновление', 'Импорт заказов');
end;

end.
