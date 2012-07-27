unit U_OrderBatchForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child,
  StdCtrls,
  ExtCtrls,
  Buttons,
  Contnrs,
  DB,
  DBCtrls,
  DBAccess,
  MyAccess,
  GridsEh,
  DbGridEh,
  Constant,
  ToughDBGrid,
  StrHlder,
  ActnList,
  ShellAPI,
  StrUtils,
  Fr_class,
  rxStrUtils,
  AlphaUtils,
  U_framePosition,
  AddressController,
  U_frameFilterAddresses,
  DayOfWeekHelper,
  LU_TDataExportAsXls;


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
    '   Не сопоставлено'
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
    shStartClients: TStrHolder;
    shEndClients: TStrHolder;
    tmrFillReport: TTimer;
    shCoreRefresh: TStrHolder;
    shCoreUpdate: TStrHolder;
    procedure FormCreate(Sender: TObject);
    procedure tmRunBatchTimer(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure actGotoMNNActionUpdate(Sender: TObject);
    procedure actGotoMNNActionExecute(Sender: TObject);
    procedure tmrUpdatePreviosOrdersTimer(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure tmrFillReportTimer(Sender: TObject);
  private
    { Private declarations }
    BM : TBitmap;
    InternalSearchText : String;

    procedure CreateNonVisualComponent;
    procedure CreateVisualComponent;
    procedure CreateTopPanel;
    procedure CreateBottomPanel;
    procedure CreateGridPanel;
    function AddServiceFields : Integer;
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

    procedure FillReport;
    procedure OnChangeCheckBoxAllOrders;
    procedure OnChangeFilterAllOrders;
  protected
    procedure OpenFile(Sender : TObject);
    procedure SaveReport(Sender : TObject);
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
    procedure dbgOrderBatchDblClick(Sender: TObject);

    procedure dbgOrderBatchOnEnter(Sender: TObject);
    procedure dbgOrderBatchOnExit(Sender: TObject);
    procedure dbgCoreOnEnter(Sender: TObject);
    procedure dbgCoreOnExit(Sender: TObject);

    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure CoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);

    procedure SaveReportToFile(FileName : String);
    procedure SaveExcelReportToFile(FileName : String; exportServiceFields : Boolean);
    procedure SaveCSVReportToFile(FileName : String);

    procedure adsCoreCalcFields(DataSet: TDataSet);
    procedure adsCoreAfterPost(DataSet: TDataSet);
    procedure adsCoreBeforeEdit(DataSet: TDataSet);
    procedure adsCoreBeforePost(DataSet: TDataSet);

    procedure AddCoreFields;
  public
    { Public declarations }

    odBatch: TOpenDialog;

    sdReport: TSaveDialog;

    eSearch : TEdit;

    pTop : TPanel;
    spLoad : TSpeedButton;
    cbFilter : TComboBox;
    spGotoCatalog : TSpeedButton;
    spDelete : TSpeedButton;
    spGotoMNNButton : TSpeedButton;
    lEditRule : TLabel;
    spSaveReport : TSpeedButton;

    pBottom : TPanel;
    pLegendAndComment : TPanel;
    pLegend : TPanel;
    dbmComment : TDBMemo;
    dbgHistory : TToughDBGrid;
    dbgCore : TToughDBGrid;
    bevelHistory : TBevel;
    gbHistory : TGroupBox;

    lOptimalCost : TLabel;
    lErrorQuantity : TLabel;
    lNotOffers : TLabel;
    lNotEnoughQuantity : TLabel;
    lAnotherError : TLabel;
    lNotParsed : TLabel;

    lJunkLegend : TLabel;
    lAwaitLegend : TLabel;
    lVitallyImportantLegend : TLabel;


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
    CommentField : TField;

    SimpleStatusField : TStringField;
    SynonymFirmField : TStringField;
    PriceNameField : TStringField;
    RealCostField : TFloatField;
    CostField : TFloatField;
    PrintCostField : TFloatField;
    RetailSummField : TFloatField;
    SumOrderField : TFloatField;
    DescriptionIdField : TLargeintField;
    CatalogVitallyImportantField : TSmallintField;
    CatalogMandatoryListField : TSmallintField;
    ProducerNameField : TStringField;

    AddressNameField : TStringField;

    CurrentFilter : TFilterReport;

    framePosition : TframePosition;
    frameFilterAddresses : TframeFilterAddresses;

    //Поля для Core
    adsCoreCoreId: TLargeintField;
    adsCorePriceCode: TLargeintField;
    adsCoreRegionCode: TLargeintField;
    adsCoreProductid: TLargeintField;
    adsCoreShortcode: TLargeintField;
    adsCoreCodeFirmCr: TLargeintField;
    adsCoreSynonymCode: TLargeintField;
    adsCoreSynonymFirmCrCode: TLargeintField;
    adsCoreCode: TStringField;
    adsCoreCodeCr: TStringField;
    adsCorePeriod: TStringField;
    adsCoreVolume: TStringField;
    adsCoreNote: TStringField;
    adsCoreCost: TFloatField;
    adsCoreQuantity: TStringField;
    adsCoreAwait: TBooleanField;
    adsCoreJunk: TBooleanField;
    adsCoreDoc: TStringField;
    adsCoreRegistryCost: TFloatField;
    adsCoreVitallyImportant: TBooleanField;
    adsCoreRequestRatio: TIntegerField;
    adsCoreOrderCost: TFloatField;
    adsCoreMinOrderCount: TIntegerField;
    adsCoreSynonymName: TStringField;
    adsCoreSynonymFirm: TStringField;
    adsCoreDatePrice: TDateTimeField;
    adsCorePriceName: TStringField;
    adsCorePriceEnabled: TBooleanField;
    adsCoreFirmCode: TLargeintField;
    adsCoreStorage: TBooleanField;
    adsCoreRegionName: TStringField;
    adsCoreFullcode: TLargeintField;
    adsCoreRealCost: TFloatField;
    adsCoreSupplierPriceMarkup: TFloatField;
    adsCoreProducerCost: TFloatField;
    adsCoreNDS: TSmallintField;
    adsCoreMnnId: TLargeintField;
    adsCoreMnn: TStringField;
    adsCoreDescriptionId: TLargeintField;
    adsCoreCatalogVitallyImportant: TBooleanField;
    adsCoreCatalogMandatoryList: TBooleanField;
    adsCoreMaxProducerCost: TFloatField;
    adsCoreBuyingMatrixType: TIntegerField;
    adsCoreProducerName: TStringField;

    adsCoreOrdersOrderId: TLargeintField;
    adsCoreOrdersHOrderId: TLargeintField;
    adsCoreOrderCount: TIntegerField;
    adsCoreSumOrder: TFloatField;
    adsCoreMarkup: TFloatField;

    adsCorePriceRet: TCurrencyField;
    adsCoreRetailVitallyImportant: TBooleanField;

    adsCoreNamePromotionsCount: TIntegerField;

    procedure ShowForm; override;
    procedure Print( APreview: boolean = False); override;
    procedure GetLastBatchId;
    procedure SetLastBatchId;
  end;

var
  OrderBatchForm: TOrderBatchForm;
  //Последний открытый каталог для отправки дефектуры
  LastUsedDir : String;
  LastUsedSaveDir : String;
  LastBatchId : Int64;

  procedure ShowOrderBatch;


implementation

{$R *.dfm}

uses
  Main,
  DModule,
  DBGridHelper,
  DataSetHelper,
  AProc,
  DBProc,
  Exchange,
  NamesForms,
  NetworkSettings,
  jbdbf;

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
    Background := lAnotherError.Color
  else begin
    if (StatusField.Value and Integer(osOptimalCost)) > 0 then
      Background := lOptimalCost.Color
    else
    if (StatusField.Value and Integer(osNotOrdered)) > 0 then
      Background := lAnotherError.Color
  end;
end;

procedure TOrderBatchForm.BindFields;
begin
  dbgOrderBatch.DataSource := dsReport;
  dbmComment.DataSource := dsReport;

  FillReport;

  dbgHistory.DataSource := dsPreviosOrders;

  dbgCore.DataSource := dsCore;
end;

procedure TOrderBatchForm.CreateBottomPanel;
var
  OneLineHeight : Integer;
  column : TColumnEh;
begin
  OneLineHeight := Self.Canvas.TextHeight('Tes');

  pBottom := TPanel.Create(Self);
  pBottom.ControlStyle := pBottom.ControlStyle - [csParentBackground] + [csOpaque];
  pBottom.Align := alBottom;
  pBottom.Parent := Self;
  pBottom.Height := OneLineHeight * 30;

  pLegendAndComment := TPanel.Create(Self);
  pLegendAndComment.ControlStyle := pLegendAndComment.ControlStyle - [csParentBackground] + [csOpaque];
  pLegendAndComment.Parent := pBottom;
  pLegendAndComment.Align := alBottom;
  pLegendAndComment.Height := pBottom.Height - 20;

  pLegend := TPanel.Create(Self);
  pLegend.ControlStyle := pLegend.ControlStyle - [csParentBackground] + [csOpaque];
  pLegend.Parent := pLegendAndComment;
  pLegend.Align := alBottom;
  pLegend.Height := OneLineHeight * 3;

  CreateLegends;

  bevelHistory := TBevel.Create(Self);
  bevelHistory.Parent := pLegendAndComment;
  bevelHistory.Align := alTop;
  bevelHistory.Shape := bsTopLine;
  bevelHistory.Height := 4;

  dbmComment := TDBMemo.Create(Self);
  dbmComment.Parent := pLegendAndComment;
  dbmComment.Align := alClient;
  dbmComment.ReadOnly := True;
  dbmComment.Color := clBtnFace;
  dbmComment.DataField := 'Comment';

  gbHistory := TGroupBox.Create(Self);
  gbHistory.Parent := pLegendAndComment;
  gbHistory.Caption := ' Предыдущие заказы ';
  gbHistory.Align := alLeft;
  gbHistory.Width := 480;
  gbHistory.Constraints.MinWidth := 480;

  dbgHistory := TToughDBGrid.Create(Self);
  dbgHistory.Name := 'dbgHistory';
  dbgHistory.Parent := gbHistory;
  dbgHistory.Align := alClient;
  dbgHistory.Width := 480;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgHistory);

  OneLineHeight := TDBGridHelper.GetStdDefaultRowHeight(dbgHistory);

  pLegendAndComment.Height := pLegend.Height + (OneLineHeight * 6);
  pLegendAndComment.Constraints.MaxHeight := pLegendAndComment.Height;

  TDBGridHelper.AddColumn(dbgHistory, 'PriceName', 'Прайс-лист', Self.Canvas.TextWidth('Большое имя прайс-листа'));
  TDBGridHelper.AddColumn(dbgHistory, 'SynonymFirm', 'Производитель', Self.Canvas.TextWidth('Большое имя синонима'));
  TDBGridHelper.AddColumn(dbgHistory, 'Period', 'Срок годн.', Self.Canvas.TextWidth('12.00.10'));
  TDBGridHelper.AddColumn(dbgHistory, 'OrderCount', 'Заказ', Self.Canvas.TextWidth('999'));
  TDBGridHelper.AddColumn(dbgHistory, 'ProducerCost', 'Цена производителя', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgHistory, 'Price', 'Цена', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgHistory, 'OrderDate', 'Дата', 0);

  dbgCore := TToughDBGrid.Create(Self);
  dbgCore.Name := 'dbgCore';
  dbgCore.Parent := pBottom;
  dbgCore.Align := alClient;
  dbgCore.Tag := 32;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgCore);
  dbgCore.OnGetCellParams := CoreGetCellParams;
  dbgCore.OnEnter := dbgCoreOnEnter;
  dbgCore.OnExit := dbgCoreOnExit;
  dbgCore.OnKeyDown := dbgCoreKeyDown;


  TDBGridHelper.AddColumn(dbgCore, 'SynonymName', 'Наименование у поставщика', 196);
  TDBGridHelper.AddColumn(dbgCore, 'SynonymFirm', 'Производитель', 85);
  column := TDBGridHelper.AddColumn(dbgCore, 'ProducerName', 'Кат.производитель', 50);
  column.Visible := False;
  TDBGridHelper.AddColumn(dbgCore, 'Volume', 'Упаковка', 30);
  TDBGridHelper.AddColumn(dbgCore, 'Note', 'Примечание', 30);
  column := TDBGridHelper.AddColumn(dbgCore, 'Doc', 'Документ');
  column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Period', 'Срок годн.', 85);
  column.Alignment := taCenter;
  TDBGridHelper.AddColumn(dbgCore, 'PriceName', 'Прайс-лист', 85);
  column := TDBGridHelper.AddColumn(dbgCore, 'RegionName', 'Регион', 72);
  column.Visible := False;
{
  column := TDBGridHelper.AddColumn(dbgCore, 'Storage', 'Склад', 37);
  column.Alignment := taCenter;
  column.Visible := False;
  column.Checkboxes := False;
}  
  TDBGridHelper.AddColumn(dbgCore, 'DatePrice', 'Дата прайс-листа', 'dd.mm.yyyy hh:nn', 103);
  TDBGridHelper.AddColumn(dbgCore, 'requestratio', 'Кратность', 20);
  TDBGridHelper.AddColumn(dbgCore, 'ordercost', 'Мин.сумма', '0.00;;''''', 20);
  TDBGridHelper.AddColumn(dbgCore, 'minordercount', 'Мин.кол-во', 20);
  TDBGridHelper.AddColumn(dbgCore, 'registrycost', 'Реестр.цена', '0.00;;''''', 20);

  TDBGridHelper.AddColumn(dbgCore, 'MaxProducerCost', 'Пред.зарег.цена', '0.00;;''''', 30);
  TDBGridHelper.AddColumn(dbgCore, 'ProducerCost', 'Цена производителя', '0.00;;''''', 30);
  TDBGridHelper.AddColumn(dbgCore, 'SupplierPriceMarkup', 'Наценка поставщика', '0.00;;''''', 30);
  TDBGridHelper.AddColumn(dbgCore, 'NDS', 'НДС', 20);

  //удаляем столбец "Цена без отсрочки", если не включен механизм с отсрочкой платежа
  if FAllowDelayOfPayment
     and FShowSupplierCost
  then
    column := TDBGridHelper.AddColumn(dbgCore, 'RealCost', 'Цена поставщика', 30);
  //column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Cost', 'Цена', '0.00;;''''', 55);
  column.Font.Style := [fsBold];
  column := TDBGridHelper.AddColumn(dbgCore, 'PriceRet', 'Розн.цена', '0.00;;''''', 62);
  column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Quantity', 'Остаток', 68);
  column.Alignment := taRightJustify;
  {
  column := TDBGridHelper.AddColumn(dbgCore, 'OrderCount', 'Заказ', 47);
  column.Color := TColor(16775406);
  column := TDBGridHelper.AddColumn(dbgCore, 'SumOrder', 'Сумма', '0.00;;''''', 70);
  column.Color := TColor(16775406);
  }
  column := TDBGridHelper.AddColumn(dbgCore, 'OrderCount', 'Заказ', 47);
  column.Color := TColor(16775406);
  column := TDBGridHelper.AddColumn(dbgCore, 'SumOrder', 'Сумма', '0.00;;''''', 70);
  column.Color := TColor(16775406);
  
  dbgCore.InputField := 'OrderCount';

  pBottom.Height := pLegendAndComment.Height + (OneLineHeight * 10);
  pBottom.Constraints.MaxHeight := pBottom.Height;
end;

procedure TOrderBatchForm.CreateGridPanel;
var
  column : TColumnEh;
  serviceFieldsCount : Integer;
begin
  pGrid := TPanel.Create(Self);
  pGrid.ControlStyle := pGrid.ControlStyle - [csParentBackground] + [csOpaque];
  pGrid.Align := alClient;
  pGrid.Parent := Self;

  dbgOrderBatch := TToughDBGrid.Create(Self);
  dbgOrderBatch.Name := 'dbgOrderBatch';
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
  dbgOrderBatch.OnDblClick := dbgOrderBatchDblClick;
  //dbgOrderBatch.Tag := 4194304;
  dbgOrderBatch.Tag := 256;
  dbgOrderBatch.OnEnter := dbgOrderBatchOnEnter;
  dbgOrderBatch.OnExit := dbgOrderBatchOnExit;


  TDBGridHelper.AddColumn(dbgOrderBatch, 'SimpleStatus', 'Заказано', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'ProducerStatus', 'Есть производитель', Self.Canvas.TextWidth('Нет   '));
  TDBGridHelper.AddColumn(dbgOrderBatch, 'SynonymName', 'Наименование', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'SynonymFirm', 'Производитель', 0);
  column := TDBGridHelper.AddColumn(dbgOrderBatch, 'ProducerName', 'Кат.производитель', 0);
  column.Visible := False;
  TDBGridHelper.AddColumn(dbgOrderBatch, 'PriceName', 'Прайс-лист', 0);
  if FAllowDelayOfPayment
    and FShowSupplierCost
  then
    TDBGridHelper.AddColumn(dbgOrderBatch, 'RealCost', 'Цена поставщика', '0.00;;''''', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'Cost', 'Цена', '0.00;;''''', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'OrderCount', 'Заказ', 0);
  TDBGridHelper.AddColumn(dbgOrderBatch, 'RetailSumm', 'Сумма', '0.00;;''''', 0);
  column := TDBGridHelper.AddColumn(dbgOrderBatch, 'Comment', 'Комментарий', 0);
  column.ToolTips := True;

  serviceFieldsCount := AddServiceFields;
  if serviceFieldsCount > 0 then
    dbgOrderBatch.AutoFitColWidths := False;
      
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
  //newLeft := CreateLegendLabel(lErrorQuantity, 'Указано неверное количество', RGB(200, 203, 206), newLeft, newTop);
  //newLeft := CreateLegendLabel(lNotOffers, 'Нет предложений', RGB(226, 180, 181), newLeft, newTop);
  //newLeft := CreateLegendLabel(lNotEnoughQuantity, 'Нет достаточного количества', RGB(255, 190, 151), newLeft, newTop);
  //newLeft :=
  newLeft := CreateLegendLabel(lAnotherError, 'Не заказанные', RGB(255, 128, 128), newLeft, newTop);
  //CreateLegendLabel(lNotParsed, 'Не найденные в ассортиментном прайс-листе', RGB(245, 233, 160), newLeft, newTop);

  newLeft := CreateLegendLabel(lJunkLegend, 'Уцененные препараты', JUNK_CLR, newLeft, newTop);
  newLeft := CreateLegendLabel(lAwaitLegend, 'Ожидаемая позиция', AWAIT_CLR, newLeft, newTop);
  newLeft := CreateLegendLabel(lVitallyImportantLegend, 'Жизненно важные препараты', clWindow, newLeft, newTop);
  lVitallyImportantLegend.Font.Color := VITALLYIMPORTANT_CLR;
end;

procedure TOrderBatchForm.CreateNonVisualComponent;
var
  I : Integer;
begin
  odBatch := TOpenDialog.Create(Self);
  odBatch.Filter := 'Все файлы|*.*';

  sdReport := TSaveDialog.Create(Self);
  sdReport.DefaultExt := 'dbf';
  sdReport.Filter := 'Отчет (*.dbf)|*.dbf|Все файлы (*.*)|*.*|Excel (*.xls)|*.xls|Расширенный Excel (*.xls)|*.xls|Excel (*.csv)|*.csv';

  adsReport := TMyQuery.Create(Self);
  adsReport.Name := 'adsReport';
  adsReport.RefreshOptions := [roAfterUpdate];
  adsReport.Options.StrictUpdate := False;
  adsReport.SQL.Text := shBatchReport.Strings.Text;
  adsReport.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  adsReport.SQLDelete.Text := shDelete.Strings.Text;
  adsReport.SQLRefresh.Text := stRefresh.Strings.Text;
  adsReport.AfterPost := AfterPost;
  adsReport.BeforeClose := ReportBeforeClose;
  adsReport.AfterOpen := UpdatePreviosOrders;
  adsReport.AfterScroll := UpdatePreviosOrders;

  IdField := TDataSetHelper.AddLargeintField(adsReport, 'Id');
  ProducerStatusField := TDataSetHelper.AddLargeintField(adsReport, 'ProducerStatus');
  ProducerStatusField.OnGetText := ProducerStatusGetText;
  SynonymNameField := TDataSetHelper.AddStringField(adsReport, 'SynonymName');
  ProductIdField := TDataSetHelper.AddLargeintField(adsReport, 'ProductId');
  OrderListIdField := TDataSetHelper.AddLargeintField(adsReport, 'OrderListId');
  StatusField := TDataSetHelper.AddIntegerField(adsReport, 'Status');
  CoreIdField := TDataSetHelper.AddLargeintField(adsReport, 'CoreId');
  OrderCountField := TDataSetHelper.AddIntegerField(adsReport, 'OrderCount');
  FullcodeField := TDataSetHelper.AddLargeintField(adsReport, 'Fullcode');
  ShortCodeField := TDataSetHelper.AddLargeintField(adsReport, 'ShortCode');
  MnnField := TDataSetHelper.AddLargeintField (adsReport, 'MnnId');
  CommentField := TDataSetHelper.AddMemoField(adsReport, 'Comment');

  SimpleStatusField := TDataSetHelper.AddStringField(adsReport, 'SimpleStatus');
  SynonymFirmField := TDataSetHelper.AddStringField(adsReport, 'SynonymFirm');
  PriceNameField := TDataSetHelper.AddStringField(adsReport, 'PriceName');
  RealCostField := TDataSetHelper.AddFloatField(adsReport, 'RealCost');
  CostField := TDataSetHelper.AddFloatField(adsReport, 'Cost');
  PrintCostField := TDataSetHelper.AddFloatField(adsReport, 'PrintCost');
  RetailSummField := TDataSetHelper.AddFloatField(adsReport, 'RetailSumm');
  SumOrderField := TDataSetHelper.AddFloatField(adsReport, 'SumOrder');

  DescriptionIdField := TDataSetHelper.AddLargeintField(adsReport, 'DescriptionId');
  CatalogVitallyImportantField := TDataSetHelper.AddSmallintField(adsReport, 'CatalogVitallyImportant');
  CatalogMandatoryListField := TDataSetHelper.AddSmallintField(adsReport, 'CatalogMandatoryList');

  ProducerNameField := TDataSetHelper.AddStringField(adsReport, 'ProducerName');

  AddressNameField := TDataSetHelper.AddStringField(adsReport, 'AddressName');

  for I := 1 to 25 do
    TDataSetHelper.AddStringField(adsReport, 'ServiceField' + IntToStr(i));

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
  adsCore.SQLUpdate.Text := shCoreUpdate.Strings.Text;
  adsCore.SQLRefresh.Text := shCoreRefresh.Strings.Text;
  adsCore.ParamByName('TimeZoneBias').Value := AProc.TimeZoneBias;
  adsCore.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  adsCore.ParamByName( 'DayOfWeek').Value := TDayOfWeekHelper.DayOfWeek();

  adsCore.OnCalcFields := adsCoreCalcFields;
  adsCore.BeforeUpdateExecute := BeforeUpdateExecuteForClientID;
  adsCore.AfterPost := adsCoreAfterPost;
  adsCore.BeforeEdit := adsCoreBeforeEdit;
  adsCore.BeforePost := adsCoreBeforePost;

  adsCore.RefreshOptions := [roAfterUpdate];

  AddCoreFields;
  
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
  if GetNetworkSettings().IsNetworkVersion then
    spLoad.Enabled := not GetNetworkSettings.DisableUpdate;
  if spLoad.Enabled then
    spLoad.Enabled := DM.adtClients.RecordCount > 0;


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

  spLoad.Left := spGotoMNNButton.Left + spGotoMNNButton.Width + 5;

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

  spSaveReport := TSpeedButton.Create(Self);
  spSaveReport.Height := 25;
  spSaveReport.Caption := 'Сохранить';
  spSaveReport.Parent := pTop;
  spSaveReport.Width := Self.Canvas.TextWidth(spSaveReport.Caption) + 20;
  spSaveReport.Top := 5;
  spSaveReport.Left := lEditRule.Left + lEditRule.Width + 5;
  spSaveReport.OnClick := SaveReport;
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

  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreOrderCount;
  fVolume := adsCoreRequestRatio;
  fOrderCost := adsCoreOrderCost;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMinOrderCount;
  fBuyingMatrixType := adsCoreBuyingMatrixType;
  fCoreQuantity := adsCoreQuantity;
  SortOnOrderGrid := False;
  
  inherited;

  framePosition := TframePosition.AddFrame(Self, pGrid, dsReport, 'SynonymName', 'MnnId', ShowDescriptionAction);
  frameFilterAddresses := TframeFilterAddresses.AddFrame(
    Self,
    pTop,
    spSaveReport.Left + spSaveReport.Width + 5,
    pTop.Height,
    dbgOrderBatch,
    OnChangeCheckBoxAllOrders,
    OnChangeFilterAllOrders);
  tmrFillReport.Enabled := False;
  tmrFillReport.Interval := 500;
  frameFilterAddresses.Visible := GetAddressController.AllowAllOrders;

  spDelete := TSpeedButton.Create(Self);
  spDelete.OnClick := DeletePositions;
  spDelete.Height := framePosition.btnShowDescription.Height;
  spDelete.Caption := 'Удалить';
  spDelete.Parent := framePosition.btnShowDescription.Parent;
  spDelete.Width := Self.Canvas.TextWidth(spDelete.Caption) + 20;
  spDelete.Top := framePosition.btnShowDescription.Top;
  spDelete.Left := framePosition.btnShowDescription.Parent.Width - spDelete.Width - framePosition.btnShowDescription.Left;
  spDelete.Anchors := [akTop, akRight];
end;

procedure TOrderBatchForm.OpenFile(Sender: TObject);
begin
  //Если есть текущие заказы и пользователь не подтвердил отправку дефектуры, то выходим
  if MainForm.CheckUnsendOrders and
      (AProc.MessageBox('После успешной отправки дефектуры будут заморожены текущие заказы.'#13#10'Продолжить?', MB_ICONWARNING or MB_OKCANCEL) <> IDOK)
  then
    Exit;

  odBatch.InitialDir := LastUsedDir;
  if odBatch.Execute then begin
    LastUsedDir := ExtractFileDir(odBatch.FileName);
    Exchange.BatchFileName := odBatch.FileName;
    tmRunBatch.Enabled := True;
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
  dbgOrder.DrawMemoText := True;
  dbgOrder.Parent := pBottom;
  dbgOrder.Align := alClient;
  dbgOrder.DataSource := dsOrder;
  TDBGridHelper.SetTitleButtonToColumns(dbgOrder);
}

  TDBGridHelper.RestoreColumnsLayout(dbgOrderBatch, Self.ClassName);
  TDBGridHelper.RestoreColumnsLayout(dbgCore, Self.ClassName);
  TDBGridHelper.RestoreColumnsLayout(dbgHistory, Self.ClassName);

  inherited;

  dbgOrderBatch.SetFocus;
//  dbgOrder.BringToFront();

  //После этого мы выставляем позицию на последнюю просматриваемую позицию
  SetLastBatchId;
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
      if CurrentFilter <> frAll then
      begin

        Accept := OrderListIdField.IsNull;

        if Accept and (CurrentFilter = frNotParsed) then
          Accept := ProductIdField.IsNull
        else
        if Accept and (CurrentFilter = frNotOrderedNotOffers) then
          Accept := ((StatusField.Value and Integer(OffersExists)) = 0) and (OrderCountField.Value > 0) and not ProductIdField.IsNull
        else
        if Accept and (CurrentFilter = frNotOrderedErrorQuantity) then
          Accept := (OrderCountField.Value < 1) and not ProductIdField.IsNull
        else
        if Accept and (CurrentFilter = frNotOrderedAnother) then
          Accept := (OrderCountField.Value > 0) and ((StatusField.Value and Integer(OffersExists)) > 0) and not ProductIdField.IsNull;
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
      if (Length(eSearch.Text) > 0) and (InternalSearchText <> eSearch.Text) then
        tmrSearchTimer(nil)
      else
        dbgCore.SetFocus();
        //actFlipCoreExecute(nil);
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
    if not CoreIdField.IsNull and not adsCore.Locate('CoreId', CoreIdField.Value, [])
    then
      adsCore.First;
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
  MyDacDataSetSortMarkingChangedForMemo( TToughDBGrid(Sender) );
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

  gbHistory.Width := Trunc(pBottom.ClientWidth * 0.4);
end;

procedure TOrderBatchForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if (Length(eSearch.Text) > 2) then begin
    InternalSearchText := StrUtils.LeftStr(eSearch.Text, 50);
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
  if not adsReport.IsEmpty then
    GetLastBatchId;
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

procedure TOrderBatchForm.dbgOrderBatchDblClick(Sender: TObject);
var
  C : GridsEh.TGridCoord;
  P : TPoint;
begin
  inherited;
  p := dbgOrderBatch.ScreenToClient(Mouse.CursorPos);
  C := dbgOrderBatch.MouseCoord(p.X, p.Y);
  if C.Y > 0 then
    actFlipCoreExecute(nil);
end;

procedure TOrderBatchForm.FormHide(Sender: TObject);
begin
  inherited;
  if Assigned(dbgOrderBatch) then
    TDBGridHelper.SaveColumnsLayout(dbgOrderBatch, Self.ClassName);
  if Assigned(dbgCore) then
    TDBGridHelper.SaveColumnsLayout(dbgCore, Self.ClassName);
  if Assigned(dbgHistory) then
    TDBGridHelper.SaveColumnsLayout(dbgHistory, Self.ClassName);
end;

function TOrderBatchForm.AddServiceFields : Integer;
var
  adsServiceFields : TMyQuery;
  index : Integer;
begin
  adsServiceFields := TMyQuery.Create(Self);
  try
    adsServiceFields.Connection := DM.MainConnection;
    adsServiceFields.SQL.Text := 'select Id, FieldName from batchreportservicefields where ClientId = :ClientId order by Id';
    adsServiceFields.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;

    adsServiceFields.Open;
    try
      Result := adsServiceFields.RecordCount;
      if Result <= 0 then
        Exit;

      index := 1;
      while not adsServiceFields.Eof do begin
        TDBGridHelper.AddColumn(
          dbgOrderBatch,
          'ServiceField' + IntToStr(Index),
          adsServiceFields.FieldByName('FieldName').AsString,
          0);
        adsServiceFields.Next;
        inc(index);
      end;
    finally
      adsServiceFields.Close;
    end;

  finally
    adsServiceFields.Free;
  end;
end;

procedure TOrderBatchForm.SaveReport(Sender: TObject);
begin
  sdReport.InitialDir := LastUsedSaveDir;
  if sdReport.Execute then begin
    LastUsedSaveDir := ExtractFileDir(sdReport.FileName);
    if sdReport.FilterIndex <= 1 then
      SaveReportToFile(sdReport.FileName)
    else
      if sdReport.FilterIndex <= 3 then
        SaveExcelReportToFile(sdReport.FileName, False)
      else
      if sdReport.FilterIndex = 4 then
        SaveExcelReportToFile(sdReport.FileName, True)
      else
        SaveCSVReportToFile(sdReport.FileName)
  end;
end;

procedure TOrderBatchForm.SaveReportToFile(FileName: String);
var
  DBF: TjbDBF;
begin
  if FileExists(FileName) then
    OSDeleteFile(FileName);

  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;

  DM.adsQueryValue.SQL.Text := ''
  + ' select '
  + '   left(ol.Code, 9) as Code, left(br.SynonymName, 100) as SynonymName, '
  + '   ol.OrderCount, ol.Price, ol.Id, '
  + '   left(br.ServiceField1, 6) as ServiceField1 '
  + ' from BatchReport br, CurrentOrderLists ol '
  + ' where '
  + '  br.OrderListId is not null '
  + '  and ol.Id = br.OrderListId '
  + ' order by br.SynonymName';

  DM.adsQueryValue.Open;

  try

    DBF := TjbDBF.Create(Self);

    try
      DBF.MakeField(1, 'KOD', 'c', 9, 0, '', dbfDuplicates, dbfAscending);
      DBF.MakeField(2, 'NAME', 'c', 100, 0, '', dbfDuplicates, dbfAscending);
      DBF.MakeField(3, 'KOL', 'F', 17, 3, '', dbfDuplicates, dbfAscending);
      DBF.MakeField(4, 'PRICE', 'F', 17, 3, '', dbfDuplicates, dbfAscending);
      DBF.MakeField(5, 'NOM_ZAK', 'c', 10, 0, '', dbfDuplicates, dbfAscending);
      DBF.MakeField(6, 'NOM_AU', 'c', 6, 0, '', dbfDuplicates, dbfAscending);
      DBF.CreateDB(FileName, 9+100+21+21+10+6, 6, 1251);

      DBF.FileName := FileName;
      if DBF.Open then begin
        while not DM.adsQueryValue.Eof do begin
          DBF.Store('KOD', ShortString(StrToOem(DM.adsQueryValue.FieldByName('Code').AsString)));
          DBF.Store('NAME', ShortString(StrToOem(DM.adsQueryValue.FieldByName('SynonymName').AsString)));
          DBF.Store('KOL', ShortString(StrToOem(DM.adsQueryValue.FieldByName('OrderCount').AsString)));
          DBF.Store('PRICE', ShortString(FloatToStr(DM.adsQueryValue.FieldByName('Price').AsFloat, DM.FFS)));
          DBF.Store('NOM_ZAK', ShortString(StrToOem(DM.adsQueryValue.FieldByName('Id').AsString)));
          DBF.Store('NOM_AU', ShortString(StrToOem(DM.adsQueryValue.FieldByName('ServiceField1').AsString)));
          DBF.NewRecord;
          DM.adsQueryValue.Next;
        end;
        DBF.Close;
      end;

    finally
      DBF.Free;
    end;
  finally
    DM.adsQueryValue.Close;
  end;
end;

procedure TOrderBatchForm.FillReport;
var
  lastOrderBy : String;
  FilterSql : String;
begin
  adsReport.Close;
  lastOrderBy := adsReport.GetOrderBy;

  adsReport.SQL.Text := '';

  if GetAddressController.ShowAllOrders then begin
    FilterSql := GetAddressController.GetFilter('batchreport.ClientId');
    adsReport.SQL.Text := shStartClients.Strings.Text;
    if FilterSql <> '' then
      adsReport.SQL.Text := adsReport.SQL.Text + ' where ' + FilterSql + #13#10;

    adsReport.SQL.Text := adsReport.SQL.Text + ' union '#13#10 + shEndClients.Strings.Text;
    if FilterSql <> '' then
      adsReport.SQL.Text := adsReport.SQL.Text + ' and ' + FilterSql + #13#10;
  end
  else begin
    adsReport.SQL.Text := shBatchReport.Strings.Text;
    adsReport.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  end;

  if (lastOrderBy <> '') then
    adsReport.SetOrderBy(lastOrderBy)
  else
    adsReport.SetOrderBy('SynonymName');

  adsReport.Open;
end;

procedure TOrderBatchForm.OnChangeCheckBoxAllOrders;
begin

end;

procedure TOrderBatchForm.OnChangeFilterAllOrders;
begin
  tmrFillReport.Enabled := False;
  tmrFillReport.Enabled := True;
end;

procedure TOrderBatchForm.tmrFillReportTimer(Sender: TObject);
begin
  tmrFillReport.Enabled := False;
  FillReport;
end;

procedure TOrderBatchForm.SaveExcelReportToFile(FileName : String; exportServiceFields : Boolean);
var
  exportData : TDataExportAsXls;
  realExport : Boolean;
  exportList : TStringList;
  serviceFields : TObjectList;
  exportArray : array of String;
  I : Integer;
  column : TColumnEh;

  procedure GetListToArray(values : TStringList);
  var
    I : Integer;
  begin
    SetLength(exportArray, values.Count);
    for I := 0 to values.Count-1 do
      exportArray[i] := values[i];
  end;

begin
  if FileExists(FileName) then
    OSDeleteFile(FileName);

  realExport := exportServiceFields and (not dbgOrderBatch.AutoFitColWidths) and (ColumnByNameT(dbgOrderBatch, 'ServiceField1') <> nil);

  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;

  DM.adsQueryValue.SQL.Text := shBatchReport.Strings.Text;
  DM.adsQueryValue.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;

  DM.adsQueryValue.Open;

  try
    exportList := TStringList.Create;
    serviceFields := TObjectList.Create(False);
    exportData := TDataExportAsXls.Create(FileName);

    try
      exportList.Add('Наименование');
      exportList.Add('Производитель');
      exportList.Add('Прайс-лист');
      exportList.Add('Цена');
      exportList.Add('Заказ');
      exportList.Add('Сумма');
      exportList.Add('Комментарий');
      if (realExport) then
        for I := 1 to 25 do begin
          column := ColumnByNameT(dbgOrderBatch, 'ServiceField' + IntToStr(i));
          if not Assigned(column) then
           Break;
          serviceFields.Add(column);
          exportList.Add(column.Title.Caption);
        end;

      GetListToArray(exportList);
      exportData.WriteRow(exportArray);

      while not DM.adsQueryValue.Eof do begin
        exportList.Clear();

        exportList.Add(DM.adsQueryValue.FieldByName('SynonymName').AsString);
        exportList.Add(DM.adsQueryValue.FieldByName('SynonymFirm').AsString);
        exportList.Add(DM.adsQueryValue.FieldByName('PriceName').AsString);
        exportList.Add(DM.adsQueryValue.FieldByName('Cost').AsString);
        exportList.Add(DM.adsQueryValue.FieldByName('OrderCount').AsString);
        exportList.Add(DM.adsQueryValue.FieldByName('RetailSumm').AsString);
        exportList.Add(DM.adsQueryValue.FieldByName('Comment').AsString);

        if (realExport) then
          for I := 0 to serviceFields.Count-1 do begin
            column := TColumnEh(serviceFields[i]);
            exportList.Add(DM.adsQueryValue.FieldByName(column.FieldName).AsString);
          end;

        GetListToArray(exportList);
        exportData.WriteRow(exportArray);

        DM.adsQueryValue.Next;
      end;

    finally
      exportData.Free;
      exportList.Free;
      serviceFields.Free;
    end;
  finally
    DM.adsQueryValue.Close;
  end;
end;

procedure TOrderBatchForm.CoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not adsCore.IsEmpty then begin
    if adsCore.FieldByName('vitallyimportant').AsBoolean then
      AFont.Color := VITALLYIMPORTANT_CLR;
    //если уцененный товар, изменяем цвет
    if adsCore.FieldByName('Junk').AsBoolean and (AnsiIndexText(Column.Field.FieldName, ['Period', 'Cost']) > -1)
    then
      Background := JUNK_CLR;
    //ожидаемый товар выделяем зеленым
    if adsCore.FieldByName('Await').AsBoolean and AnsiSameText(Column.Field.FieldName, 'SynonymName') then
      Background := AWAIT_CLR;
  end;
end;

procedure TOrderBatchForm.Print(APreview: boolean);
begin
  if dbgCore.Focused then begin
    if adsCore.Active then begin
      frVariables[ 'UseForms'] := True;
      frVariables[ 'NewSearch'] := True;
      frVariables[ 'CatalogName'] := framePosition.dbtSynonymName.Caption;
      frVariables[ 'CatalogForm'] := '';
      DM.ShowFastReport( 'Core.frf', adsCore, APreview);
    end;
  end
  else
    if dbgOrderBatch.Focused and adsReport.Active then begin
      frVariables[ 'SymmaryType'] := 0;
      frVariables[ 'SymmaryDateFrom'] := DateToStr(Now);
      frVariables[ 'SymmaryDateTo'] := DateToStr(Now);
      DM.ShowFastReport( 'Summary.frf', adsReport, APreview);
    end;
end;

procedure TOrderBatchForm.dbgCoreOnEnter(Sender: TObject);
begin
  PrintEnabled := (DM.SaveGridMask and PrintCombinedPrice) > 0;
end;

procedure TOrderBatchForm.dbgCoreOnExit(Sender: TObject);
begin
  PrintEnabled := False;
end;

procedure TOrderBatchForm.dbgOrderBatchOnEnter(Sender: TObject);
begin
  PrintEnabled := (DM.SaveGridMask and PrintCurrentSummaryOrder) > 0;
end;

procedure TOrderBatchForm.dbgOrderBatchOnExit(Sender: TObject);
begin
  PrintEnabled := False;
end;

procedure TOrderBatchForm.SaveCSVReportToFile(FileName: String);
var
  realExport : Boolean;
  exportList : TStringList;
  serviceFields : TObjectList;
  I : Integer;
  column : TColumnEh;
  exportFile : TFileStream;
  exportString : String;
begin
  if FileExists(FileName) then
    OSDeleteFile(FileName);

  realExport := (not dbgOrderBatch.AutoFitColWidths) and (ColumnByNameT(dbgOrderBatch, 'ServiceField1') <> nil);

  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;

  DM.adsQueryValue.SQL.Text := shBatchReport.Strings.Text;
  DM.adsQueryValue.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;

  DM.adsQueryValue.Open;

  try
    exportList := TStringList.Create;
    serviceFields := TObjectList.Create(False);

    exportFile := TFileStream.Create(FileName, fmCreate);

    try
      exportList.Add('Наименование');
      exportList.Add('Производитель');
      exportList.Add('Прайс-лист');
      exportList.Add('Цена');
      exportList.Add('Заказ');
      exportList.Add('Сумма');
      exportList.Add('Комментарий');
      if (realExport) then
        for I := 1 to 25 do begin
          column := ColumnByNameT(dbgOrderBatch, 'ServiceField' + IntToStr(i));
          if not Assigned(column) then
           Break;
          serviceFields.Add(column);
          exportList.Add(column.Title.Caption);
        end;

      exportList.Delimiter := ';';
      exportList.QuoteChar := '"';
      exportString := exportList.DelimitedText + #13#10;
      exportFile.WriteBuffer(exportString[1], Length(exportString));

      while not DM.adsQueryValue.Eof do begin
        exportString := ''
          + AnsiQuotedStr(DM.adsQueryValue.FieldByName('SynonymName').AsString, '"') + ';'
          + AnsiQuotedStr(DM.adsQueryValue.FieldByName('SynonymFirm').AsString, '"') + ';'
          + AnsiQuotedStr(DM.adsQueryValue.FieldByName('PriceName').AsString, '"') + ';'
          + AnsiQuotedStr(DM.adsQueryValue.FieldByName('Cost').AsString, '"') + ';'
          + AnsiQuotedStr(DM.adsQueryValue.FieldByName('OrderCount').AsString, '"') + ';'
          + AnsiQuotedStr(DM.adsQueryValue.FieldByName('RetailSumm').AsString, '"') + ';'
          + AnsiQuotedStr(DM.adsQueryValue.FieldByName('Comment').AsString, '"');

        if (realExport) then
          for I := 0 to serviceFields.Count-1 do begin
            column := TColumnEh(serviceFields[i]);
            exportString := exportString
              + ';' + AnsiQuotedStr(DM.adsQueryValue.FieldByName(column.FieldName).AsString, '"');
          end;

        exportString := exportString + #13#10;
        exportFile.WriteBuffer(exportString[1], Length(exportString));
        DM.adsQueryValue.Next;
      end;

    finally
      exportFile.Free;
      exportList.Free;
      serviceFields.Free;
    end;
  finally
    DM.adsQueryValue.Close;
  end;
end;

procedure TOrderBatchForm.adsCoreAfterPost(DataSet: TDataSet);
begin
  MainForm.SetOrdersInfo;
  adsReport.RefreshRecord;
end;

procedure TOrderBatchForm.adsCoreBeforeEdit(DataSet: TDataSet);
begin
  if adsCoreFirmCode.AsInteger = RegisterId then Abort;
end;

procedure TOrderBatchForm.adsCoreBeforePost(DataSet: TDataSet);
var
  Quantity, E: Integer;
  PriceAvg,
  OrderCountAvg: Double;
  PanelCaption : String;
begin
  try
    { проверяем заказ на соответствие наличию товара на складе }
    Val( adsCoreQuantity.AsString,Quantity,E);
    if E<>0 then Quantity := 0;
    if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity) 
    then begin
      AProc.MessageBox(
        'Заказ превышает остаток на складе, товар будет заказан в количестве ' + adsCoreQuantity.AsString,
        MB_ICONWARNING);
      adsCoreORDERCOUNT.AsInteger := Quantity;
    end;

    PanelCaption := '';

    if (adsCoreBuyingMatrixType.Value > 0) and (adsCoreORDERCOUNT.AsInteger > 0)
    then begin
      if (adsCoreBuyingMatrixType.Value = 1) then begin
        PanelCaption := DisableProductOrderMessage;

        ShowOverCostPanel(PanelCaption, dbgCore);

        Abort;
      end;
    end;

    { проверяем на превышение цены }
{
    if ( adsCoreORDERCOUNT.AsInteger>0) and (not adsAvgOrdersPRODUCTID.IsNull) then
    begin
      PriceAvg := adsAvgOrdersPRICEAVG.AsCurrency;
      if ( PriceAvg > 0) and ( adsCoreCOST.AsCurrency>PriceAvg*( 1 + Excess / 100)) then
      begin
        if Length(PanelCaption) > 0 then
          PanelCaption := PanelCaption + #13#10 + ExcessAvgCostMessage
        else
          PanelCaption := ExcessAvgCostMessage;
      end;
    end;
 }   

    { проверяем на превышение заказанного количества }
{
    if ( adsCoreORDERCOUNT.AsInteger>0) and (not adsAvgOrdersPRODUCTID.IsNull) then
    begin
      OrderCountAvg := adsAvgOrdersOrderCountAvg.AsCurrency;
      if ( OrderCountAvg > 0) and ( adsCoreORDERCOUNT.AsInteger > OrderCountAvg*ExcessAvgOrderTimes ) then
      begin
        if Length(PanelCaption) > 0 then
          PanelCaption := PanelCaption + #13#10 + ExcessAvgOrderCountMessage
        else
          PanelCaption := ExcessAvgOrderCountMessage;
      end;
    end;
}

    if (adsCoreJUNK.Value) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + OrderJunkMessage
      else
        PanelCaption := OrderJunkMessage;

    if (adsCoreORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + WarningOrderCountMessage
      else
        PanelCaption := WarningOrderCountMessage;

    if Length(PanelCaption) > 0 then
      ShowOverCostPanel(PanelCaption, dbgCore);

  except
    adsCore.Cancel;
    raise;
  end;
end;

procedure TOrderBatchForm.adsCoreCalcFields(DataSet: TDataSet);
begin
  try
    if FAllowDelayOfPayment and not FShowSupplierCost then
      adsCorePriceRet.AsCurrency :=
        DM.GetRetailCostLast(
          adsCoreRetailVitallyImportant.Value,
          adsCoreCost.AsCurrency,
          adsCoreMarkup.AsVariant)
    else
      adsCorePriceRet.AsCurrency :=
        DM.GetRetailCostLast(
          adsCoreRetailVitallyImportant.Value,
          adsCoreRealCost.AsCurrency,
          adsCoreMarkup.AsVariant);
  except
  end;
end;

procedure TOrderBatchForm.GetLastBatchId;
begin
  LastBatchId := IdField.Value;
end;

procedure TOrderBatchForm.SetLastBatchId;
begin
  if not adsReport.IsEmpty then
    //Если был первый запуск, то устанавливаем в начало списка
    if LastBatchId <= 0 then
      adsReport.First
    else
      if not adsReport.Locate('Id', LastBatchId, []) then
        adsReport.First;
end;

procedure TOrderBatchForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    dbgOrderBatch.SetFocus();
end;

procedure TOrderBatchForm.dbgCoreCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
  CanInput := (not adsCore.IsEmpty) and ( adsCoreSynonymCode.AsInteger >= 0) and
    (( adsCoreRegionCode.AsLargeInt and DM.adtClientsREQMASK.AsLargeInt) =
      adsCoreRegionCode.AsLargeInt);
end;

procedure TOrderBatchForm.AddCoreFields;
begin
  adsCoreCoreId := TDataSetHelper.AddLargeintField(adsCore, 'CoreId');
  adsCorePriceCode := TDataSetHelper.AddLargeintField(adsCore, 'PriceCode');
  adsCoreRegionCode := TDataSetHelper.AddLargeintField(adsCore, 'RegionCode');
  adsCoreproductid := TDataSetHelper.AddLargeintField(adsCore, 'productid');
  adsCoreShortcode := TDataSetHelper.AddLargeintField(adsCore, 'shortcode');
  adsCoreCodeFirmCr := TDataSetHelper.AddLargeintField(adsCore, 'CodeFirmCr');
  adsCoreSynonymCode := TDataSetHelper.AddLargeintField(adsCore, 'SynonymCode');
  adsCoreSynonymFirmCrCode := TDataSetHelper.AddLargeintField(adsCore, 'SynonymFirmCrCode');
  adsCoreCode := TDataSetHelper.AddStringField(adsCore, 'Code');
  adsCoreCodeCr := TDataSetHelper.AddStringField(adsCore, 'CodeCr');
  adsCorePeriod := TDataSetHelper.AddStringField(adsCore, 'Period');
  adsCoreVolume := TDataSetHelper.AddStringField(adsCore, 'Volume');
  adsCoreNote := TDataSetHelper.AddStringField(adsCore, 'Note');
  adsCoreCost := TDataSetHelper.AddFloatField(adsCore, 'Cost');
  adsCoreQuantity := TDataSetHelper.AddStringField(adsCore, 'Quantity');
  adsCoreAwait := TDataSetHelper.AddBooleanField(adsCore, 'Await');
  adsCoreJunk := TDataSetHelper.AddBooleanField(adsCore, 'Junk');
  adsCoreDoc := TDataSetHelper.AddStringField(adsCore, 'doc');
  adsCoreRegistryCost := TDataSetHelper.AddFloatField(adsCore, 'registrycost');
  adsCoreVitallyImportant := TDataSetHelper.AddBooleanField(adsCore, 'vitallyimportant');
  adsCoreRequestRatio := TDataSetHelper.AddIntegerField(adsCore, 'requestratio');
  adsCoreOrderCost := TDataSetHelper.AddFloatField(adsCore, 'ordercost');
  adsCoreMinOrderCount := TDataSetHelper.AddIntegerField(adsCore, 'minordercount');
  adsCoreSynonymName := TDataSetHelper.AddStringField(adsCore, 'SynonymName');
  adsCoreSynonymFirm := TDataSetHelper.AddStringField(adsCore, 'SynonymFirm');
  adsCoreDatePrice := TDataSetHelper.AddDateTimeField(adsCore, 'DatePrice');
  adsCorePriceName := TDataSetHelper.AddStringField(adsCore, 'PriceName');
  adsCorePriceEnabled := TDataSetHelper.AddBooleanField(adsCore, 'PriceEnabled');
  adsCoreFirmCode := TDataSetHelper.AddLargeintField(adsCore, 'FirmCode');
  adsCoreStorage := TDataSetHelper.AddBooleanField(adsCore, 'Storage');
  adsCoreRegionName := TDataSetHelper.AddStringField(adsCore, 'RegionName');
  adsCoreFullcode := TDataSetHelper.AddLargeintField(adsCore, 'fullcode');
  adsCoreRealCost := TDataSetHelper.AddFloatField(adsCore, 'RealCost');
  adsCoreSupplierPriceMarkup := TDataSetHelper.AddFloatField(adsCore, 'SupplierPriceMarkup');
  adsCoreProducerCost := TDataSetHelper.AddFloatField(adsCore, 'ProducerCost');
  adsCoreNDS := TDataSetHelper.AddSmallintField(adsCore, 'NDS');
  adsCoreMnnId := TDataSetHelper.AddLargeintField(adsCore, 'MnnId');
  adsCoreMnn := TDataSetHelper.AddStringField(adsCore, 'Mnn');
  adsCoreDescriptionId := TDataSetHelper.AddLargeintField(adsCore, 'DescriptionId');
  adsCoreCatalogVitallyImportant := TDataSetHelper.AddBooleanField(adsCore, 'CatalogVitallyImportant');
  adsCoreCatalogMandatoryList := TDataSetHelper.AddBooleanField(adsCore, 'CatalogMandatoryList');
  adsCoreMaxProducerCost := TDataSetHelper.AddFloatField(adsCore, 'MaxProducerCost');
  adsCoreBuyingMatrixType := TDataSetHelper.AddIntegerField(adsCore, 'BuyingMatrixType');
  adsCoreProducerName := TDataSetHelper.AddStringField(adsCore, 'ProducerName');


  adsCoreOrderCount := TDataSetHelper.AddIntegerField(adsCore, 'OrderCount');
  adsCoreSumOrder := TDataSetHelper.AddFloatField(adsCore, 'SumOrder');

  adsCoreOrdersOrderId := TDataSetHelper.AddLargeintField(adsCore, 'OrdersOrderId');
  adsCoreOrdersHOrderId := TDataSetHelper.AddLargeintField(adsCore, 'OrdersHOrderId');

  adsCoreMarkup := TDataSetHelper.AddFloatField(adsCore, 'Markup');

  adsCoreCost.DisplayFormat := '0.00;;''''';
  adsCoreRealCost.DisplayFormat := '0.00;;''''';
  adsCoreRegistryCost.DisplayFormat := '0.00;;''''';
  adsCoreProducerCost.DisplayFormat := '0.00;;''''';
  adsCoreSumOrder.DisplayFormat := '0.00;;''''';
  adsCoreRequestRatio.DisplayFormat := '#';
  adsCoreOrderCount.DisplayFormat := '#';

  adsCorePriceRet := TCurrencyField.Create(adsCore);
  adsCorePriceRet.FieldName := 'PriceRet';
  adsCorePriceRet.FieldKind := fkCalculated;
  adsCorePriceRet.Calculated := True;
  adsCorePriceRet.DisplayFormat := '0.00;;';
  adsCorePriceRet.Dataset := adsCore;

  adsCoreRetailVitallyImportant := TDataSetHelper.AddBooleanField(adsCore, 'RetailVitallyImportant');

  adsCoreNamePromotionsCount := TDataSetHelper.AddIntegerField(adsCore, 'NamePromotionsCount');
end;

initialization
  LastUsedDir := ExePath;
  LastUsedSaveDir := ExePath;
  LastBatchId := 0;
end.


