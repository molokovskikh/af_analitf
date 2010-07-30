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
  ToughDBGrid,
  StrHlder,
  ActnList,
  ShellAPI,
  StrUtils,
  AlphaUtils,
  U_framePosition;

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
    '   Минимальные',
    '   Не минимальные',
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
    shCore: TStrHolder;
    tmrSearch: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmRunBatchTimer(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure actGotoMNNActionUpdate(Sender: TObject);
    procedure actGotoMNNActionExecute(Sender: TObject);
    procedure tmrUpdatePreviosOrdersTimer(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    BM : TBitmap;
    InternalSearchText : String;

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
    procedure EditRuleClick(Sender: TObject);
    procedure FormResize(Sender: TObject);

    procedure InternalSearch;
    procedure SetClear;
    procedure AddKeyToSearch(Key : Char);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ProducerStatusGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
  protected
    procedure OpenFile(Sender : TObject);
    procedure BatchReportGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure BatchReportCanInput(Sender: TObject; Value: Integer; var CanInput: Boolean);
    procedure UpdateOrderDataset; override;
    procedure DeletePositions(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure dbgOrderBatchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgOrderBatchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgOrderBatchDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
  public
    { Public declarations }

    odBatch: TOpenDialog;

    eSearch : TEdit;

    pTop : TPanel;
    spLoad : TSpeedButton;
    cbFilter : TComboBox;
    spGotoCatalog : TSpeedButton;
    spDelete : TSpeedButton;
    spGotoMNNButton : TSpeedButton;
    lEditRule : TLabel;

    pBottom : TPanel;
    pLegendAndComment : TPanel;
    pLegend : TPanel;
    dbmComment : TDBMemo;
    dbgHistory : TToughDBGrid;
    dbgCore : TToughDBGrid;

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

    adsCore : TMyQuery;
    dsCore : TDataSource;

    IdField : TLargeintField;
    ProducerStatusField : TField;
    SynonymNameField : TStringField;
    ProductIdField : TLargeintField;
    OrderListIdField : TLargeintField;
    StatusField : TIntegerField;
    CoreIdField : TLargeintField;
    OrderCountField : TIntegerField;
    FullcodeField : TLargeintField;
    ShortCodeField : TLargeintField;
    MnnField : TLargeintField;

    CurrentFilter : TFilterReport;

    framePosition : TframePosition;

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
  NamesForms;

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

  dbgCore.DataSource := dsCore;

  IdField := TLargeintField (adsReport.FieldByName('Id'));
  ProducerStatusField := TField (adsReport.FieldByName('ProducerStatus'));;
  ProducerStatusField.OnGetText := ProducerStatusGetText;
  SynonymNameField := TStringField (adsReport.FieldByName('SynonymName'));
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
  column : TColumnEh;
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

  dbgHistory := TToughDBGrid.Create(Self);
  dbgHistory.Parent := pLegendAndComment;
  dbgHistory.Align := alLeft;
  dbgHistory.Width := 480;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgHistory);

  OneLineHeight := TDBGridHelper.GetStdDefaultRowHeight(dbgHistory);

  pLegendAndComment.Height := pLegend.Height + (OneLineHeight * 6);
  pLegendAndComment.Constraints.MaxHeight := pLegendAndComment.Height;

  TDBGridHelper.AddColumn(dbgHistory, 'PriceName', 'Прайс-лист', Self.Canvas.TextWidth('Большое имя прайс-листа'));
  TDBGridHelper.AddColumn(dbgHistory, 'SynonymFirm', 'Производитель', Self.Canvas.TextWidth('Большое имя синонима'));
  TDBGridHelper.AddColumn(dbgHistory, 'OrderCount', 'Заказ', Self.Canvas.TextWidth('999'));
  TDBGridHelper.AddColumn(dbgHistory, 'ProducerCost', 'Цена производителя', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgHistory, 'Price', 'Цена', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgHistory, 'OrderDate', 'Дата', 0);

  dbgCore := TToughDBGrid.Create(Self);
  dbgCore.Parent := pBottom;
  dbgCore.Align := alClient;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgCore);

  TDBGridHelper.AddColumn(dbgCore, 'SynonymName', 'Наименование у поставщика', 196);
  TDBGridHelper.AddColumn(dbgCore, 'SynonymFirm', 'Производитель', 85);
  TDBGridHelper.AddColumn(dbgCore, 'Volume', 'Упаковка', 63);
  TDBGridHelper.AddColumn(dbgCore, 'Note', 'Примечание', 69);
  column := TDBGridHelper.AddColumn(dbgCore, 'Doc', 'Документ');
  column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Period', 'Срок годн.', 85);
  column.Alignment := taCenter;
  TDBGridHelper.AddColumn(dbgCore, 'PriceName', 'Прайс-лист', 85);
  column := TDBGridHelper.AddColumn(dbgCore, 'RegionName', 'Регион', 72);
  column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Storage', 'Склад', 37);
  column.Alignment := taCenter;
  column.Visible := False;
  column.Checkboxes := False;
  TDBGridHelper.AddColumn(dbgCore, 'DatePrice', 'Дата прайс-листа', 'dd.mm.yyyy hh:nn', 103);
  TDBGridHelper.AddColumn(dbgCore, 'registrycost', 'Реестр. цена', '0.00;;''''', 0);
  TDBGridHelper.AddColumn(dbgCore, 'requestratio', 'Кратность');
  TDBGridHelper.AddColumn(dbgCore, 'ordercost', 'Мин. сумма', '0.00;;''''', 0);
  TDBGridHelper.AddColumn(dbgCore, 'minordercount', 'Мин. кол-во');
  //удаляем столбец "Цена без отсрочки", если не включен механизм с отсрочкой платежа
  if DM.adtClientsAllowDelayOfPayment.Value then
    column := TDBGridHelper.AddColumn(dbgCore, 'RealCost', 'Цена поставщика');
  //column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Cost', 'Цена', '0.00;;''''', 55);
  column.Font.Style := [fsBold];
  TDBGridHelper.AddColumn(dbgCore, 'PriceRet', 'Розн. цена', '0.00;;''''', 62);
  column := TDBGridHelper.AddColumn(dbgCore, 'Quantity', 'Количество', 68);
  column.Alignment := taRightJustify;
  {
  column := TDBGridHelper.AddColumn(dbgCore, 'OrderCount', 'Заказ', 47);
  column.Color := TColor(16775406);
  column := TDBGridHelper.AddColumn(dbgCore, 'SumOrder', 'Сумма', '0.00;;''''', 70);
  column.Color := TColor(16775406);
  }

  pBottom.Height := pLegendAndComment.Height + (OneLineHeight * 10);
  pBottom.Constraints.MaxHeight := pBottom.Height;
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
  dbgOrderBatch.OnKeyPress := dbgOrderBatchKeyPress;
  dbgOrderBatch.OnSortMarkingChanged := ReportSortMarkingChanged;
  dbgOrderBatch.OnDrawColumnCell := dbgOrderBatchDrawColumnCell;
  dbgOrderBatch.InputField := 'OrderCount';

  TDBGridHelper.AddColumn(dbgOrderBatch, 'SimpleStatus', 'Сформирован заказ', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'ProducerStatus', 'Известен изготовитель', Self.Canvas.TextWidth('Нет   '));
  TDBGridHelper.AddColumn(dbgOrderBatch, 'SynonymName', 'Наименование', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'SynonymFirm', 'Производитель', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'PriceName', 'Прайс-лист', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'OrderCount', 'Заказ', 0);
  if DM.adtClientsAllowDelayOfPayment.Value then
    TDBGridHelper.AddColumn(dbgOrderBatch, 'RealCost', 'Цена поставщика', '0.00;;''''', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'Cost', 'Цена', '0.00;;''''', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'RetailSumm', 'Сумма', '0.00;;''''', 0);
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
  newLeft := CreateLegendLabel(lOptimalCost, 'Минимальная цена', RGB(172, 255, 151), newLeft, newTop);
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

  adsCore := TMyQuery.Create(Self);
  adsCore.SQL.Text := shCore.Strings.Text;
  adsCore.ParamByName('TimeZoneBias').Value := AProc.TimeZoneBias;
  adsCore.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;

  dsCore := TDataSource.Create(Self);
  dsCore.DataSet := adsCore;
end;

procedure TOrderBatchForm.CreateTopPanel;
var
  filter : TFilterReport;
begin
  pTop := TPanel.Create(Self);
  pTop.ControlStyle := pTop.ControlStyle - [csParentBackground] + [csOpaque];
  pTop.Align := alTop;
  pTop.Parent := Self;

  eSearch := TEdit.Create(Self);
  eSearch.Parent := pTop;
  eSearch.Left := 5;
  eSearch.Width := Self.Canvas.TextWidth('Это очень очень длинная строка поиска');
  eSearch.OnKeyPress := eSearchKeyPress;
  eSearch.OnKeyDown := eSearchKeyDown;

  cbFilter := TComboBox.Create(Self);
  cbFilter.Parent := pTop;
  cbFilter.Style := csDropDownList;
  for filter := Low(TFilterReport) to High(TFilterReport) do
    cbFilter.Items.Add(FilterReportNames[filter]);
  cbFilter.ItemIndex := 0;
  cbFilter.Width := cbFilter.Canvas.TextWidth(FilterReportNames[frNotOrderedErrorQuantity]) + 5;
  cbFilter.Left := eSearch.Left + eSearch.Width + 5;
  cbFilter.OnClick := FilterClick;


  spLoad := TSpeedButton.Create(Self);
  spLoad.Height := 25;
  spLoad.Caption := 'Загрузить';
  spLoad.Parent := pTop;
  spLoad.Width := Self.Canvas.TextWidth(spLoad.Caption) + 20;
  spLoad.Left := 3;
  spLoad.Top := 5;
  spLoad.OnClick := OpenFile;

  pTop.Height := spLoad.Height + 10;
  eSearch.Top := (pTop.Height - eSearch.Height) div 2;

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

  lEditRule := TLabel.Create(Self);
  lEditRule.Parent := pTop;
  lEditRule.Caption := 'Настройка';
  lEditRule.Hint := 'Настройка правил автозаказа';
  lEditRule.ShowHint := True;
  lEditRule.OnClick := EditRuleClick;
  lEditRule.Cursor := crHandPoint;
  lEditRule.ParentFont := False;
  lEditRule.Font.Color := clBlue;
  lEditRule.Font.Style := [fsBold, fsUnderline];
  lEditRule.Top := (pTop.Height - lEditRule.Height) div 2;
  lEditRule.Left := spLoad.Left + spLoad.Width + 5;
end;

procedure TOrderBatchForm.CreateVisualComponent;
begin
  CreateTopPanel;
  CreateBottomPanel;
  CreateGridPanel;

  Self.OnResize := FormResize;
end;

procedure TOrderBatchForm.FormCreate(Sender: TObject);
begin
  InternalSearchText := '';
  BM := TBitmap.Create;

  CreateNonVisualComponent;
  CreateVisualComponent;

  inherited;

  framePosition := TframePosition.AddFrame(Self, pGrid, dsReport, 'SynonymName', 'MnnId', ShowDescriptionAction);
end;

procedure TOrderBatchForm.OpenFile(Sender: TObject);
begin
  if AProc.MessageBox('После успешной отправки дефектуры будут удалены текущие заказы.'#13#10'Продолжить?', MB_ICONWARNING or MB_OKCANCEL) = IDOK
  then begin
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
  eSearch.Text := '';
  InternalSearchText := '';
  FP := nil;
  if Filter <> frAll then
    FP := FilterRecord;
  CurrentFilter := Filter;
  DBProc.SetFilterProc(adsReport, FP);
end;

procedure TOrderBatchForm.FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if Length(InternalSearchText) > 0 then
    Accept := AnsiContainsText(SynonymNameField.DisplayText, InternalSearchText);

  if Accept then begin

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
    else
      if CurrentFilter <> frAll then
      begin
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
end;

procedure TOrderBatchForm.AfterPost(DataSet: TDataSet);
begin
  MainForm.SetOrdersInfo;
end;

procedure TOrderBatchForm.dbgOrderBatchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_DELETE) then begin
    Key := 0;
    if not adsReport.IsEmpty then
      DeleteOrder;
  end
  else
    if Key = VK_RETURN then begin
      if (Length(eSearch.Text) > 0) then
        tmrSearchTimer(nil);
    end
    else
      if Key = VK_ESCAPE then
        SetClear
      else
        if Key = VK_BACK then begin
          tmrSearch.Enabled := False;
          eSearch.Text := Copy(eSearch.Text, 1, Length(eSearch.Text)-1);
          tmrSearch.Enabled := True;
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
  if adsCore.Active then
    adsCore.Close;
  if adsReport.Active and not adsReport.IsEmpty
  then begin
    adsPreviosOrders.ParamByName( 'GroupByProducts').Value :=
      DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean;
    adsPreviosOrders.ParamByName( 'FullCode').Value := FullcodeField.Value;
    adsPreviosOrders.ParamByName( 'ProductId').Value := ProductIdField.Value;
    adsPreviosOrders.Open;
    adsCore.ParamByName( 'ProductId').Value := ProductIdField.Value;
    adsCore.Open;
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

procedure TOrderBatchForm.EditRuleClick(Sender: TObject);
var
  settingUrl : String;
begin
  settingUrl := 'https://stat.analit.net/CI/SmartOrderRule/show.rails?ClientId=';
  if DM.adsUser.FieldByName('IsFutureClient').AsBoolean then
    settingUrl := settingUrl + DM.adsUser.FieldByName('MainClientId').AsString
  else
    settingUrl := settingUrl + DM.adtClients.FieldByName('ClientId').AsString;
  ShellExecute(
    0,
    'open',
    PChar(settingUrl),
    nil,
    nil,
    SW_SHOWDEFAULT);
end;

procedure TOrderBatchForm.FormResize(Sender: TObject);
var
  AllUnresizedControl : Integer;
  ResidualHeight : Integer;
  NewHistoryHeight : Integer;
begin
  AllUnresizedControl := pTop.Height + framePosition.Height + pLegend.Height;
  ResidualHeight := Self.ClientHeight - AllUnresizedControl;
  NewHistoryHeight := ResidualHeight div 5;
  pLegendAndComment.Height := pLegend.Height + NewHistoryHeight;
  pBottom.Height := pLegendAndComment.Height + ((ResidualHeight - NewHistoryHeight) div 2);
  
  dbgHistory.Width := pBottom.ClientWidth div 2;
end;

procedure TOrderBatchForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if (Length(eSearch.Text) > 2) then begin
    InternalSearchText := LeftStr(eSearch.Text, 50);
    InternalSearch;
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TOrderBatchForm.InternalSearch;
begin
  DBProc.SetFilterProc(adsReport, FilterRecord);

  dbgOrderBatch.SetFocus;
end;

procedure TOrderBatchForm.SetClear;
begin
  tmrSearch.Enabled := False;

  SetFilter(TFilterReport(cbFilter.ItemIndex));

  dbgOrderBatch.SetFocus;
end;

procedure TOrderBatchForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TOrderBatchForm.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //Если мы что-то нажали в элементе, то должны на это отреагировать
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

procedure TOrderBatchForm.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
    dbgOrderBatch.SetFocus;
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TOrderBatchForm.dbgOrderBatchDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if (Column.Field = SynonymNameField) then
    ProduceAlphaBlendRect(InternalSearchText, Column.Field.DisplayText, dbgOrderBatch.Canvas, Rect, BM);
end;

procedure TOrderBatchForm.FormDestroy(Sender: TObject);
begin
  BM.Free;
  inherited;
end;

procedure TOrderBatchForm.dbgOrderBatchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ( Key > #32) and not ( Key in
    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
  begin
    if not tmrSearch.Enabled and (InternalSearchText = eSearch.Text) then
      eSearch.Text := '';
    AddKeyToSearch(Key);
  end;
end;

procedure TOrderBatchForm.ProducerStatusGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if DisplayText then
    Text := IfThen(Sender.AsInteger = 0, 'Нет', 'Да');
end;

end.


