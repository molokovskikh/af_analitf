unit U_OrderBatchForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child,
  StdCtrls,
  ExtCtrls,
  Buttons,
  DB,
  DBCtrls,
  DBAccess,
  MyAccess,
  GridsEh,
  DbGridEh,
  ToughDBGrid, StrHlder, ActnList;

type
  TItemToOrderStatus = (
    osOrdered = $01,           //Позиция заказана
    osNotOrdered = $02,        //Позиция не заказана
    osOptimalCost = $04,       //Заказан по лучшей цене
    osNotEnoughQuantity = $08, //Не заказан по причине нехватки кол-ва
    OffersExists = $10         //Предложения по данной позиции имелись
  );

  TFilterReport =
  (
    frAll,
    frAllOrdered,
    frOrderedOptimal,
    frOrderedNonOptimal,
    frNotOrdered,
    frNotOrderedNotOffers,
    frNotOrderedErrorQuantity,
    frNotOrderedAnother,
    frNotParsed
  );

const
  FilterReportNames : array[TFilterReport] of String =
  (
    'Все',
    'Заказано',
    '   Оптимальные',
    '   Не оптимальные',
    'Не заказано',
    '   Нет предложений',
    '   Нулевое количество',
    '   Прочее',
    'Не сопоставлено'
  );

type

  TOrderBatchForm = class(TChildForm)
    shBatchReport: TStrHolder;
    tmRunBatch: TTimer;
    shDelete: TStrHolder;
    stUpdate: TStrHolder;
    stRefresh: TStrHolder;
    ActionList: TActionList;
    actFlipCore: TAction;
    actGotoMNNAction: TAction;
    shPreviosOrders: TStrHolder;
    tmrUpdatePreviosOrders: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmRunBatchTimer(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure actGotoMNNActionUpdate(Sender: TObject);
    procedure actGotoMNNActionExecute(Sender: TObject);
    procedure tmrUpdatePreviosOrdersTimer(Sender: TObject);
  private
    { Private declarations }
    procedure CreateNonVisualComponent;
    procedure CreateVisualComponent;
    procedure CreateTopPanel;
    procedure CreateBottomPanel;
    procedure CreateGridPanel;
    procedure CreateLegends;
    function CreateLegendLabel(
      var legendLabel : TLabel;
      legend : String;
      legendColor : TColor;
      newLeft,
      newTop : Integer) : Integer;
    procedure BindFields;
    procedure DeleteOrder;
    procedure SetFilter(Filter: TFilterReport);
    procedure FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure AfterPost(DataSet: TDataSet);
    procedure UpdatePreviosOrders(DataSet: TDataSet);
    procedure ReportBeforeClose(DataSet: TDataSet);
    procedure ReportSortMarkingChanged(Sender: TObject);
  protected
    procedure OpenFile(Sender : TObject);
    procedure BatchReportGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure BatchReportCanInput(Sender: TObject; Value: Integer; var CanInput: Boolean);
    procedure UpdateOrderDataset; override;
    procedure DeletePositions(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure dbgOrderBatchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    { Public declarations }

    odBatch: TOpenDialog;

    pTop : TPanel;
    spLoad : TSpeedButton;
    cbFilter : TComboBox;
    spGotoCatalog : TSpeedButton;
    spDelete : TSpeedButton;
    spGotoMNNButton : TSpeedButton;

    pBottom : TPanel;
    pLegendAndComment : TPanel;
    pLegend : TPanel;
    dbmComment : TDBMemo;
    dbgHistory : TToughDBGrid;

    lOptimalCost : TLabel;
    lErrorQuantity : TLabel;
    lNotOffers : TLabel;
    lNotEnoughQuantity : TLabel;
    lAnotherError : TLabel;
    lNotParsed : TLabel;

    pGrid : TPanel;
    dbgOrderBatch : TToughDBGrid;

    adsReport : TMyQuery;
    dsReport : TDataSource;

    adsPreviosOrders : TMyQuery;
    dsPreviosOrders : TDataSource;

    IdField : TLargeintField;
    ProductIdField : TLargeintField;
    OrderListIdField : TLargeintField;
    StatusField : TIntegerField;
    CoreIdField : TLargeintField;
    OrderCountField : TIntegerField;
    FullcodeField : TLargeintField;
    ShortCodeField : TLargeintField;
    MnnField : TLargeintField;

    CurrentFilter : TFilterReport;

    procedure ShowForm; override;
  end;

var
  OrderBatchForm: TOrderBatchForm;

  procedure ShowOrderBatch;


implementation

{$R *.dfm}

uses
  Main,
  DModule,
  DBGridHelper,
  AProc,
  DBProc,
  Exchange,
  NamesForms,
  U_framePosition;

procedure ShowOrderBatch;
var
  OrderBatchForm: TOrderBatchForm;
begin
  OrderBatchForm := TOrderBatchForm(MainForm.ShowChildForm( TOrderBatchForm ));
  OrderBatchForm.ShowForm;
end;


procedure TOrderBatchForm.BatchReportCanInput(Sender: TObject;
  Value: Integer; var CanInput: Boolean);
begin
  inherited;
  CanInput := (not adsReport.IsEmpty) and not OrderListIdField.IsNull;
end;

procedure TOrderBatchForm.BatchReportGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if StatusField.IsNull or ProductIdField.IsNull then
    Background := lNotParsed.Color
  else begin
    if (StatusField.Value and Integer(osOptimalCost)) > 0 then
      Background := lOptimalCost.Color
    else
    if ((StatusField.Value and Integer(osNotOrdered)) > 0) and (OrderCountField.Value < 1) then
      Background := lErrorQuantity.Color
    else
    if ((StatusField.Value and Integer(osNotOrdered)) > 0) and ((StatusField.Value and Integer(OffersExists)) = 0) then
      Background := lNotOffers.Color
    else
    if (StatusField.Value and Integer(osNotEnoughQuantity)) > 0 then
      Background := lNotEnoughQuantity.Color
    else
    if (StatusField.Value and Integer(osNotOrdered)) > 0 then
      Background := lAnotherError.Color
  end;
end;

procedure TOrderBatchForm.BindFields;
begin
  dbgOrderBatch.DataSource := dsReport;
  dbmComment.DataSource := dsReport;
  adsReport.Open;

  dbgHistory.DataSource := dsPreviosOrders;

  IdField := TLargeintField (adsReport.FieldByName('Id'));
  ProductIdField := TLargeintField  (adsReport.FieldByName('ProductId'));
  OrderListIdField := TLargeintField  (adsReport.FieldByName('OrderListId'));
  StatusField := TIntegerField  (adsReport.FieldByName('Status'));
  CoreIdField := TLargeintField (adsReport.FieldByName('CoreId'));
  OrderCountField := TIntegerField (adsReport.FieldByName('OrderCount'));
  FullcodeField := TLargeintField (adsReport.FieldByName('Fullcode'));
  ShortCodeField := TLargeintField (adsReport.FieldByName('ShortCode'));
  MnnField := TLargeintField (adsReport.FieldByName('MnnId'));
end;

procedure TOrderBatchForm.CreateBottomPanel;
var
  OneLineHeight : Integer;
begin
  OneLineHeight := Self.Canvas.TextHeight('Tes');

  pBottom := TPanel.Create(Self);
  pBottom.Align := alBottom;
  pBottom.Parent := Self;
  pBottom.Height := OneLineHeight * 30;

  pLegendAndComment := TPanel.Create(Self);
  pLegendAndComment.Parent := pBottom;
  pLegendAndComment.Align := alBottom;
  pLegendAndComment.Height := pBottom.Height - 20;

  pLegend := TPanel.Create(Self);
  pLegend.Parent := pLegendAndComment;
  pLegend.Align := alBottom;
  pLegend.Height := OneLineHeight * 3;

  CreateLegends;

  dbmComment := TDBMemo.Create(Self);
  dbmComment.Parent := pLegendAndComment;
  dbmComment.Align := alClient;
  dbmComment.ReadOnly := True;
  dbmComment.Color := clBtnFace;
  dbmComment.DataField := 'Comment';

  pLegendAndComment.Height := pLegend.Height + (OneLineHeight * 6);

  dbgHistory := TToughDBGrid.Create(Self);
  dbgHistory.Parent := pBottom;
  dbgHistory.Align := alClient;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgHistory);

  pBottom.Height := pLegendAndComment.Height + (OneLineHeight * 15);

  TDBGridHelper.AddColumn(dbgHistory, 'PriceName', 'Прайс-лист', Self.Canvas.TextWidth('Большое имя прайс-листа'));
  TDBGridHelper.AddColumn(dbgHistory, 'SynonymFirm', 'Производитель', Self.Canvas.TextWidth('Большое имя синонима'));
  TDBGridHelper.AddColumn(dbgHistory, 'OrderCount', 'Заказ', Self.Canvas.TextWidth('999'));
  TDBGridHelper.AddColumn(dbgHistory, 'ProducerCost', 'Цена производителя', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgHistory, 'Price', 'Цена', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgHistory, 'OrderDate', 'Дата', 0);
end;

procedure TOrderBatchForm.CreateGridPanel;
var
  column : TColumnEh;
begin
  pGrid := TPanel.Create(Self);
  pGrid.Align := alClient;
  pGrid.Parent := Self;

  dbgOrderBatch := TToughDBGrid.Create(Self);
  dbgOrderBatch.Parent := pGrid;
  dbgOrderBatch.Align := alClient;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgOrderBatch);
  dbgOrderBatch.DrawMemoText := True;
  dbgOrderBatch.ParentShowHint := False;
  dbgOrderBatch.ShowHint := True;
  dbgOrderBatch.OnGetCellParams := BatchReportGetCellParams;
  dbgOrderBatch.OnCanInput := BatchReportCanInput;
  dbgOrderBatch.OnKeyDown := dbgOrderBatchKeyDown;
  dbgOrderBatch.OnSortMarkingChanged := ReportSortMarkingChanged;
  dbgOrderBatch.InputField := 'OrderCount';

  TDBGridHelper.AddColumn(dbgOrderBatch, 'SimpleStatus', 'Сформирован заказ', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'SynonymName', 'Наименование', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'SynonymFirm', 'Производитель', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'PriceName', 'Прайс-лист', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'OrderCount', 'Количество', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'Cost', 'Цена', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'RetailSumm', 'Сумма', 0);
  column := TDBGridHelper.AddColumn(dbgOrderBatch, 'Comment', 'Комментарий', 0);
  column.ToolTips := True;
  TDBGridHelper.SetTitleButtonToColumns(dbgOrderBatch);
end;

function TOrderBatchForm.CreateLegendLabel(
  var legendLabel: TLabel;
  legend: String; legendColor: TColor; newLeft, newTop: Integer): Integer;
begin
  legendLabel := TLabel.Create(Self);
  legendLabel.Parent := pLegend;
  legendLabel.AutoSize := False;
  legendLabel.Top := newTop;
  legendLabel.Left := newLeft;
  legendLabel.Caption := legend;
  legendLabel.ParentColor := False;
  legendLabel.Transparent := False;
  legendLabel.Color := legendColor;
  legendLabel.Alignment := taCenter;
  legendLabel.Layout := tlCenter;
  legendLabel.Width := legendLabel.Canvas.TextWidth(legend) + 20;
  legendLabel.Height := legendLabel.Canvas.TextHeight(legend) + 10;
  Result := legendLabel.Left + legendLabel.Width + 6;
end;

procedure TOrderBatchForm.CreateLegends;
var
  newLeft,
  newTop : Integer;
begin
  newLeft := 8;
  newTop := (pLegend.Height - (Self.Canvas.TextHeight('Test') + 10)) div 2;
  newLeft := CreateLegendLabel(lOptimalCost, 'Оптимальная цена', RGB(172, 255, 151), newLeft, newTop);
  newLeft := CreateLegendLabel(lErrorQuantity, 'Указано неверное количество', RGB(200, 203, 206), newLeft, newTop);
  newLeft := CreateLegendLabel(lNotOffers, 'Нет предложений', RGB(226, 180, 181), newLeft, newTop);
  newLeft := CreateLegendLabel(lNotEnoughQuantity, 'Нет достаточного количества', RGB(255, 190, 151), newLeft, newTop);
  newLeft := CreateLegendLabel(lAnotherError, 'Прочие не заказанные', RGB(255, 128, 128), newLeft, newTop);
  CreateLegendLabel(lNotParsed, 'Не найденные в ассортиментном прайс-листе', RGB(245, 233, 160), newLeft, newTop);
end;

procedure TOrderBatchForm.CreateNonVisualComponent;
begin
  odBatch := TOpenDialog.Create(Self);
  odBatch.Filter := 'Все файлы|*.*';

  adsReport := TMyQuery.Create(Self);
  adsReport.Name := 'adsReport';
  adsReport.RefreshOptions := [roAfterUpdate];
  adsReport.Options.StrictUpdate := False;
  adsReport.SQL.Text := shBatchReport.Strings.Text;
  adsReport.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  adsReport.SQLDelete.Text := shDelete.Strings.Text;
  adsReport.SQLUpdate.Text := stUpdate.Strings.Text;
  adsReport.SQLRefresh.Text := stRefresh.Strings.Text;
  adsReport.AfterPost := AfterPost;
  adsReport.BeforeClose := ReportBeforeClose;
  adsReport.AfterOpen := UpdatePreviosOrders;
  adsReport.AfterScroll := UpdatePreviosOrders;

  dsReport := TDataSource.Create(Self);
  dsReport.DataSet := adsReport;

  adsPreviosOrders := TMyQuery.Create(Self);
  adsPreviosOrders.SQL.Text := shPreviosOrders.Strings.Text;
  adsPreviosOrders.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  adsPreviosOrders.ParamByName( 'GroupByProducts').Value := DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean;

  dsPreviosOrders  := TDataSource.Create(Self);
  dsPreviosOrders.DataSet := adsPreviosOrders;

end;

procedure TOrderBatchForm.CreateTopPanel;
var
  filter : TFilterReport;
begin
  pTop := TPanel.Create(Self);
  pTop.Align := alTop;
  pTop.Parent := Self;

  cbFilter := TComboBox.Create(Self);
  cbFilter.Parent := pTop;
  cbFilter.Style := csDropDownList;
  for filter := Low(TFilterReport) to High(TFilterReport) do
    cbFilter.Items.Add(FilterReportNames[filter]);
  cbFilter.ItemIndex := 0;
  cbFilter.Width := cbFilter.Canvas.TextWidth(FilterReportNames[frNotOrderedErrorQuantity]) + 5;
  cbFilter.Left := 5;
  cbFilter.OnClick := FilterClick;


  spLoad := TSpeedButton.Create(Self);
  spLoad.Height := 25;
  spLoad.Caption := 'Загрузить';
  spLoad.Parent := pTop;
  spLoad.Width := Self.Canvas.TextWidth(spLoad.Caption) + 20;
  spLoad.Left := 3;
  spLoad.Top := 5;
  pTop.Height := spLoad.Height + 10;
  spLoad.OnClick := OpenFile;

  cbFilter.Top := (pTop.Height - cbFilter.Height) div 2;

  spGotoCatalog := TSpeedButton.Create(Self);
  spGotoCatalog.Height := 25;
  spGotoCatalog.Action := actFlipCore;
  spGotoCatalog.Caption := actFlipCore.Caption;
  spGotoCatalog.Parent := pTop;
  spGotoCatalog.Width := Self.Canvas.TextWidth(spGotoCatalog.Caption) + 20;
  spGotoCatalog.Top := 5;
  spGotoCatalog.Left := cbFilter.Left + cbFilter.Width + 5;

  spGotoMNNButton := TSpeedButton.Create(Self);
  spGotoMNNButton.Height := 25;
  spGotoMNNButton.Action := actGotoMNNAction;
  spGotoMNNButton.Caption := actGotoMNNAction.Caption;
  spGotoMNNButton.Parent := pTop;
  spGotoMNNButton.Width := Self.Canvas.TextWidth(spGotoMNNButton.Caption) + 20;
  spGotoMNNButton.Top := 5;
  spGotoMNNButton.Left := spGotoCatalog.Left + spGotoCatalog.Width + 5;


  spDelete := TSpeedButton.Create(Self);
  spDelete.OnClick := DeletePositions;
  spDelete.Height := 25;
  spDelete.Caption := 'Удалить';
  spDelete.Parent := pTop;
  spDelete.Width := Self.Canvas.TextWidth(spDelete.Caption) + 20;
  spDelete.Top := 5;
  spDelete.Left := spGotoMNNButton.Left + spGotoMNNButton.Width + 5;

  spLoad.Left := spDelete.Left + spDelete.Width + 5;
end;

procedure TOrderBatchForm.CreateVisualComponent;
begin
  CreateTopPanel;
  CreateBottomPanel;
  CreateGridPanel;
end;

procedure TOrderBatchForm.FormCreate(Sender: TObject);
begin
  CreateNonVisualComponent;
  CreateVisualComponent;

  inherited;

  TframePosition.AddFrame(Self, pGrid, dsReport, 'SynonymName', 'MnnId', ShowDescriptionAction);
end;

procedure TOrderBatchForm.OpenFile(Sender: TObject);
begin
  odBatch.InitialDir := ExePath;
  if odBatch.Execute then begin
    Exchange.BatchFileName := odBatch.FileName;
    tmRunBatch.Enabled := True;
{
    MainForm.ActiveChild := nil;
    MainForm.AddFormToFree(Self);
    Close;
}    
  end;
end;

procedure TOrderBatchForm.ShowForm;
{
var
  adsOrder : TMyQuery;
  dsOrder : TDataSource;
  dbgOrder : TToughDBGrid;
}
begin
  BindFields;

{
  adsOrder := TMyQuery.Create(Self);
  adsOrder.Connection := DM.MainConnection;
  adsOrder.SQL.Text := 'select * from batchreport';
  adsOrder.Open;
  dsOrder := TDataSource.Create(Self);
  dsOrder.DataSet := adsOrder;
  dbgOrder := TToughDBGrid.Create(Self);
  dbgOrder.Parent := pBottom;
  dbgOrder.Align := alClient;
  dbgOrder.DataSource := dsOrder;
}

  inherited;

  dbgOrderBatch.SetFocus;
//  dbgOrder.BringToFront();
end;

procedure TOrderBatchForm.tmRunBatchTimer(Sender: TObject);
begin
  tmRunBatch.Enabled := False;
  RunExchange([eaPostOrderBatch]);
end;

procedure TOrderBatchForm.actFlipCoreExecute(Sender: TObject);
var
  FullCode, ShortCode: integer;
  CoreId : Int64;
begin
  if MainForm.ActiveChild <> Self then exit;
  if adsReport.IsEmpty then Exit;
  if FullcodeField.IsNull or ShortCodeField.IsNull then
    Exit;

  FullCode := FullcodeField.AsInteger;
  ShortCode := ShortCodeField.AsInteger;

  if CoreIdField.IsNull then
    CoreId := 0
  else
    CoreId := CoreIdField.AsLargeInt;

  FlipToCodeWithReturn(FullCode, ShortCode, CoreId);
end;

procedure TOrderBatchForm.UpdateOrderDataset;
begin
  dbgOrderBatch.SetFocus;
end;

procedure TOrderBatchForm.DeletePositions(Sender: TObject);
begin
  dbgOrderBatch.SetFocus;
  if (not adsReport.IsEmpty) then
    DeleteOrder;
end;

procedure TOrderBatchForm.DeleteOrder;
var
  I : Integer;
  selectedRows : TStringList;
begin
  selectedRows := TDBGridHelper.GetSelectedRows(dbgOrderBatch);
  if selectedRows.Count > 0 then begin

    if selectedRows.Count = 1 then begin
      if AProc.MessageBox('Удалить позицию?', MB_ICONQUESTION or MB_YESNO) = IDYES then begin
        adsReport.Delete;
        MainForm.SetOrdersInfo;
      end;
    end
    else begin
      if AProc.MessageBox('Удалить выбранные позиции?', MB_ICONQUESTION or MB_YESNO) = IDYES then begin

        adsReport.DisableControls;
        try
          for I := 0 to selectedRows.Count-1 do begin
            adsReport.Bookmark := selectedRows[i];
            adsReport.Delete;
          end;
        finally
          adsReport.EnableControls;
        end;
        MainForm.SetOrdersInfo;
      end;
    end;
  end;
end;

procedure TOrderBatchForm.FilterClick(Sender: TObject);
begin
  dbgOrderBatch.SetFocus;
  SetFilter(TFilterReport(cbFilter.ItemIndex));
end;

procedure TOrderBatchForm.SetFilter(Filter: TFilterReport);
var
  FP : TFilterRecordEvent;
begin
  FP := nil;
  if Filter <> frAll then
    FP := FilterRecord;
  CurrentFilter := Filter;
  DBProc.SetFilterProc(adsReport, FP);
end;

procedure TOrderBatchForm.FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if CurrentFilter in [frAllOrdered, frOrderedOptimal, frOrderedNonOptimal]
  then begin
    Accept := not OrderListIdField.IsNull;
    if Accept and (CurrentFilter = frOrderedOptimal) then
      Accept := (StatusField.Value and Integer(osOptimalCost)) > 0
    else
      if Accept and (CurrentFilter = frOrderedNonOptimal) then
        Accept := (StatusField.Value and Integer(osOptimalCost)) = 0
  end
  else
  if CurrentFilter = frNotParsed
  then
  begin
    Accept := OrderListIdField.IsNull and ProductIdField.IsNull;
  end
  else begin
    Accept := OrderListIdField.IsNull and not ProductIdField.IsNull;
    if Accept and (CurrentFilter = frNotOrderedNotOffers) then
      Accept := ((StatusField.Value and Integer(OffersExists)) = 0) and (OrderCountField.Value > 0)
    else
    if Accept and (CurrentFilter = frNotOrderedErrorQuantity) then
      Accept := (OrderCountField.Value < 1)
    else
    if Accept and (CurrentFilter = frNotOrderedAnother) then
      Accept := (OrderCountField.Value > 0) and ((StatusField.Value and Integer(OffersExists)) > 0);
  end;
end;

procedure TOrderBatchForm.AfterPost(DataSet: TDataSet);
begin
  MainForm.SetOrdersInfo;
end;

procedure TOrderBatchForm.dbgOrderBatchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_DELETE) and (not adsReport.IsEmpty) then begin
    Key := 0;
    DeleteOrder;
  end;
end;

procedure TOrderBatchForm.actGotoMNNActionUpdate(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TAction) then begin
    if (MainForm.ActiveChild = Self)
       and (Assigned(adsReport))
       and not adsReport.IsEmpty
    then begin
      TAction(Sender).Enabled := Assigned(MnnField) and not MnnField.IsNull
    end
    else
      TAction(Sender).Enabled := False;
  end;
end;

procedure TOrderBatchForm.actGotoMNNActionExecute(Sender: TObject);
var
  MnnId : Int64;
  lastControl : TWinControl;
begin
  lastControl := Self.ActiveControl;
  if (MainForm.ActiveChild = Self)
     and (Assigned(adsReport))
     and not adsReport.IsEmpty
  then begin
    if Assigned(MnnField) then begin
      if not MnnField.IsNull then begin
        MnnId := MnnField.Value;
        FlipToMNNFromMNNSearch(MnnId);
        Exit;
      end
      else
        AProc.MessageBox('Для данной позиции не установлено МНН.', MB_ICONWARNING);
    end;
  end;
  if Assigned(lastControl) and (lastControl is TToughDBGrid) and lastControl.CanFocus
  then
    lastControl.SetFocus;
end;

procedure TOrderBatchForm.tmrUpdatePreviosOrdersTimer(Sender: TObject);
begin
  tmrUpdatePreviosOrders.Enabled := False;
  if adsPreviosOrders.Active then
    adsPreviosOrders.Close;
  if adsReport.Active and not adsReport.IsEmpty
  then begin
    adsPreviosOrders.ParamByName( 'GroupByProducts').Value :=
      DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean;
    adsPreviosOrders.ParamByName( 'FullCode').Value := FullcodeField.Value;
    adsPreviosOrders.ParamByName( 'ProductId').Value := ProductIdField.Value;
    adsPreviosOrders.Open;
  end;
end;

procedure TOrderBatchForm.ReportBeforeClose(DataSet: TDataSet);
begin
  if adsPreviosOrders.Active then
    adsPreviosOrders.Close;
end;

procedure TOrderBatchForm.UpdatePreviosOrders(DataSet: TDataSet);
begin
  tmrUpdatePreviosOrders.Enabled := False;
  tmrUpdatePreviosOrders.Enabled := True;
end;

procedure TOrderBatchForm.ReportSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

end.


