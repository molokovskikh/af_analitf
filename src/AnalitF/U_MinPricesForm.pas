unit U_MinPricesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls,
  StdCtrls,
  StrUtils,
  Buttons,
  ActnList,
  Menus,
  DB,
  DBAccess,
  MyAccess,
  StrHlder,
  GridsEh,
  DbGridEh,
  Constant,
  AProc,
  DBProc,
  ToughDBGrid,
  NetworkParams,
  SQLWaiting,
  U_framePromotion,
  DayOfWeekHelper,
  HtmlView;

{//$define MinPricesLog}

type
  TMinPricesForm = class(TChildForm)
    shShowMinPrices: TStrHolder;
    tmrSearch: TTimer;
    shCore: TStrHolder;
    tmrUpdatePreviosOrders: TTimer;
    ActionList: TActionList;
    actGotoMNNAction: TAction;
    btnSelectPrices: TBitBtn;
    pmSelectedPrices: TPopupMenu;
    miSelectAll: TMenuItem;
    miUnselecAll: TMenuItem;
    miSep: TMenuItem;
    lFilter: TLabel;
    tmrSelectedPrices: TTimer;
    shCoreUpdate: TStrHolder;
    shCoreRefresh: TStrHolder;
    tmrOverCostHide: TTimer;
    StrHolder1: TStrHolder;
    StrHolder2: TStrHolder;
    procedure FormCreate(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
    procedure tmrUpdatePreviosOrdersTimer(Sender: TObject);
    procedure actGotoMNNActionExecute(Sender: TObject);
    procedure actGotoMNNActionUpdate(Sender: TObject);
    procedure tmrSelectedPricesTimer(Sender: TObject);
    procedure btnSelectPricesClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure miUnselecAllClick(Sender: TObject);
    procedure tmrOverCostHideTimer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FNetworkParams : TNetworkParams;
    InternalSearchText : String;
    UseExcess : Boolean;

    SelectedPrices : TStringList;
    InternalSearchNameText : String;

    procedure CreateNonVisualComponent;
    procedure AddCoreFields;

    procedure CreateVisualComponent;
    procedure CreateTopPanel;
    procedure CreateLeftPanel;
    procedure CreateOffersPanel;
    procedure CreateOverCostPanel;

    procedure BindFields;

    procedure AddKeyToSearch(Key : Char);
    procedure AddKeyToSearchName(Key : Char);
    procedure SetClear;
    procedure SetClearByName;
    procedure InternalSearch;

    procedure UpdateOffers();

    procedure ChangeSelected(ASelected : Boolean);

    procedure ShowOverCostPanel(panelCaption : String);
  protected
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure eSearchNameKeyPress(Sender: TObject; var Key: Char);
    procedure eSearchNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure MinPricesAfteOpen(dataSet : TDataSet);
    procedure MinPricesAfteScroll(dataSet : TDataSet);

    procedure dbgMinPricesKeyPress(Sender: TObject; var Key: Char);
    procedure dbgMinPricesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgMinPricesSortMarkingChanged(Sender: TObject);

    procedure OnSPClick(Sender: TObject);

    procedure adsCoreCalcFields(DataSet: TDataSet);
    procedure adsCoreAfterPost(DataSet: TDataSet);
    procedure adsCoreBeforeEdit(DataSet: TDataSet);
    procedure adsCoreBeforePost(DataSet: TDataSet);

    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);

    procedure UpdateOrderDataset; override;
  public
    { Public declarations }
    adsMinPrices : TMyQuery;
    dsMinPrices : TDataSource;
    minProductIdField : TLargeintField;
    minRegionCodeField : TLargeintField;
    minMinCostField : TFloatField;
    minNextCostField : TFloatField;
    minSynonymNameField : TStringField;
    minPercentField : TFloatField;
    minFullCodeField : TLargeintField;

    adsCore : TMyQuery;
    dsCore : TDataSource;

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

    adsCorePriceRet: TCurrencyField;
    adsCoreRetailVitallyImportant: TBooleanField;

    adsCoreNamePromotionsCount: TIntegerField;

    pTop : TPanel;
    lBeforeInfo  : TLabel;
    eSearch : TEdit;
    lAfterInfo  : TLabel;
    lFindCount : TLabel;
    spGotoMNNButton : TSpeedButton;

    pLeft : TPanel;
    dbgMinPrices : TToughDBGrid;

    pOffers : TPanel;
    dbgCore : TToughDBGrid;
    pWebBrowser : TPanel;
    bWebBrowser : TBevel;
    WebBrowser : THTMLViewer;

    plOverCost : TPanel;
    lWarning : TLabel;

    framePromotion : TframePromotion;

    lSearchName : TLabel;
    eSearchName : TEdit;

    procedure ShowForm; override;
    function AllowSearch : Boolean;
    procedure HideSearch();
    procedure ShowSearch();
  end;

  procedure ShowMinPrices;

implementation

uses
  Main,
  DModule,
  DBGridHelper,
  DataSetHelper,
  NamesForms,
  U_framePosition
{$ifdef MinPricesLog}
  ,
  U_ExchangeLog
{$endif}  
  ;

{$R *.dfm}

procedure ShowMinPrices;
var
  MinPricesForm: TMinPricesForm;
begin
  MinPricesForm := TMinPricesForm(MainForm.ShowChildForm( TMinPricesForm ));
  MinPricesForm.ShowForm;
end;

procedure TMinPricesForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TMinPricesForm.BindFields;
begin
{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'dbgMinPrices.DataSource := dsMinPrices');
{$endif}
  dbgMinPrices.DataSource := dsMinPrices;

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'dbgCore.DataSource := dsCore');
{$endif}
  dbgCore.DataSource := dsCore;

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'InternalSearch');
{$endif}
  InternalSearch;
end;

procedure TMinPricesForm.CreateLeftPanel;
begin
  pLeft := TPanel.Create(Self);
  pLeft.ControlStyle := pLeft.ControlStyle - [csParentBackground] + [csOpaque];
  pLeft.Top := pTop.Height + 1;
  pLeft.Height := (Self.ClientHeight - pTop.Height) div 2;
  pLeft.Align := alTop;
  pLeft.Parent := Self;

  dbgMinPrices := TToughDBGrid.Create(Self);
  dbgMinPrices.Name := 'dbgMinPrices';
  dbgMinPrices.Parent := pLeft;
  dbgMinPrices.Align := alClient;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgMinPrices);

  TDBGridHelper.AddColumn(dbgMinPrices, 'SynonymName', 'Наименование', Self.Canvas.TextWidth('Большое наименование'));
  TDBGridHelper.AddColumn(dbgMinPrices, 'MinCost', 'Мин. цена', '0.00;;''''', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgMinPrices, 'NextCost', 'След. цена', '0.00;;''''', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgMinPrices, 'Percent', '%', '0.00;;''''', Self.Canvas.TextWidth('999.99'));

  TDBGridHelper.SetTitleButtonToColumns(dbgMinPrices);

  dbgMinPrices.OnKeyPress := dbgMinPricesKeyPress;
  dbgMinPrices.OnKeyDown := dbgMinPricesKeyDown;
  dbgMinPrices.OnSortMarkingChanged := dbgMinPricesSortMarkingChanged;
end;

procedure TMinPricesForm.CreateNonVisualComponent;
begin
  adsMinPrices := TMyQuery.Create(Self);
  adsMinPrices.Name := 'adsMinPrices';
  adsMinPrices.Connection := DM.MainConnection;
  adsMinPrices.RefreshOptions := [roAfterUpdate];
  adsMinPrices.Options.StrictUpdate := False;
  adsMinPrices.SQL.Text := shShowMinPrices.Strings.Text;
  adsMinPrices.ParamByName('Percent').Value := FNetworkParams.NetworkMinCostPercent;
  InternalSearchText := IntToStr(FNetworkParams.NetworkMinCostPercent);

  adsMinPrices.AfterOpen := MinPricesAfteOpen;
  adsMinPrices.AfterScroll := MinPricesAfteScroll;

  minProductIdField := TDataSetHelper.AddLargeintField(adsMinPrices, 'ProductId');
  minRegionCodeField := TDataSetHelper.AddLargeintField(adsMinPrices, 'RegionCode');
  minMinCostField := TDataSetHelper.AddFloatField(adsMinPrices, 'MinCost');
  minNextCostField := TDataSetHelper.AddFloatField(adsMinPrices, 'NextCost');
  minSynonymNameField := TDataSetHelper.AddStringField(adsMinPrices, 'SynonymName');
  minPercentField := TDataSetHelper.AddFloatField(adsMinPrices, 'Percent');
  minFullCodeField := TDataSetHelper.AddLargeintField(adsMinPrices, 'FullCode');

  dsMinPrices := TDataSource.Create(Self);
  dsMinPrices.DataSet := adsMinPrices;

  adsCore := TMyQuery.Create(Self);
  adsCore.SQL.Text := shCore.Strings.Text;
  adsCore.SQLUpdate.Text := shCoreUpdate.Strings.Text;
  adsCore.SQLRefresh.Text := shCoreRefresh.Strings.Text;
  adsCore.ParamByName('TimeZoneBias').Value := AProc.TimeZoneBias;
  adsCore.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  adsCore.ParamByName( 'DayOfWeek').Value := TDayOfWeekHelper.DayOfWeek();

  dsCore := TDataSource.Create(Self);
  dsCore.DataSet := adsCore;

  AddCoreFields;

  adsCore.OnCalcFields := adsCoreCalcFields;
  adsCore.BeforeUpdateExecute := BeforeUpdateExecuteForClientID;
  adsCore.AfterPost := adsCoreAfterPost;
  adsCore.BeforeEdit := adsCoreBeforeEdit;
  adsCore.BeforePost := adsCoreBeforePost;

  adsCore.RefreshOptions := [roAfterUpdate];
end;

procedure TMinPricesForm.CreateOffersPanel;
var
  column : TColumnEh;
begin
  pOffers := TPanel.Create(Self);
  pOffers.ControlStyle := pLeft.ControlStyle - [csParentBackground] + [csOpaque];
  pOffers.Align := alClient;
  pOffers.Parent := Self;

  pWebBrowser := TPanel.Create(Self);
  pWebBrowser.Parent := pOffers;
  pWebBrowser.Align := alBottom;
  pWebBrowser.BevelOuter := bvNone;
  pWebBrowser.Height := 135;

  bWebBrowser := TBevel.Create(Self);
  bWebBrowser.Parent := pWebBrowser;
  bWebBrowser.Align := alTop;
  bWebBrowser.Height := 4;
  bWebBrowser.Shape := bsTopLine;

  WebBrowser := THTMLViewer.Create(Self);
  WebBrowser.Tag := 2;
  WebBrowser.Name := 'WebBrowser';
  WebBrowser.Parent := pWebBrowser;
  WebBrowser.Align := alClient;
  UpdateReclame;

  dbgCore := TToughDBGrid.Create(Self);
  dbgCore.Name := 'dbgCore';
  dbgCore.Parent := pOffers;
  dbgCore.Align := alClient;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgCore);

  TDBGridHelper.AddColumn(dbgCore, 'SynonymName', 'Наименование у поставщика', 196);
  TDBGridHelper.AddColumn(dbgCore, 'SynonymFirm', 'Производитель', 85);
  column := TDBGridHelper.AddColumn(dbgCore, 'ProducerName', 'Кат. производитель', 50);
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
  TDBGridHelper.AddColumn(dbgCore, 'ordercost', 'Мин. сумма', '0.00;;''''', 20);
  TDBGridHelper.AddColumn(dbgCore, 'minordercount', 'Мин. кол-во', 20);
  TDBGridHelper.AddColumn(dbgCore, 'registrycost', 'Реестр. цена', '0.00;;''''', 20);

  TDBGridHelper.AddColumn(dbgCore, 'MaxProducerCost', 'Пред. зарег. цена', '0.00;;''''', 30);
  TDBGridHelper.AddColumn(dbgCore, 'ProducerCost', 'Цена производителя', '0.00;;''''', 30);
  TDBGridHelper.AddColumn(dbgCore, 'SupplierPriceMarkup', 'Наценка поставщика', '0.00;;''''', 30);
  TDBGridHelper.AddColumn(dbgCore, 'NDS', 'НДС', 20);

  //удаляем столбец "Цена без отсрочки", если не включен механизм с отсрочкой платежа
  if FAllowDelayOfPayment
    and FShowSupplierCost
  then
    column := TDBGridHelper.AddColumn(dbgCore, 'RealCost', 'Цена поставщика', 30);
  column := TDBGridHelper.AddColumn(dbgCore, 'Cost', 'Цена', '0.00;;''''', 55);
  column.Font.Style := [fsBold];
  column := TDBGridHelper.AddColumn(dbgCore, 'PriceRet', 'Розн. цена', '0.00;;''''', 62);
  column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Quantity', 'Количество', 68);
  column.Alignment := taRightJustify;
  column := TDBGridHelper.AddColumn(dbgCore, 'OrderCount', 'Заказ', 47);
  column.Color := TColor(16775406);
  column := TDBGridHelper.AddColumn(dbgCore, 'SumOrder', 'Сумма', '0.00;;''''', 70);
  column.Color := TColor(16775406);

  dbgCore.OnKeyDown := dbgCoreKeyDown;
  dbgCore.OnCanInput := dbgCoreCanInput;
  dbgCore.OnGetCellParams := dbgCoreGetCellParams;

  dbgCore.InputField := 'OrderCount';

  framePromotion := TframePromotion.AddFrame(Self, dbgCore, pOffers, dbgCore, False);
end;

procedure TMinPricesForm.CreateTopPanel;
begin
  pTop := TPanel.Create(Self);
  pTop.Top := 0;
  pTop.ControlStyle := pTop.ControlStyle - [csParentBackground] + [csOpaque];
  pTop.Align := alTop;
  pTop.Parent := Self;

  lBeforeInfo := TLabel.Create(Self);
  lBeforeInfo.Parent := pTop;
  lBeforeInfo.Left := 5;
  lBeforeInfo.Caption := 'Оставить товары с разницей';

  eSearch := TEdit.Create(Self);
  eSearch.Parent := pTop;
  eSearch.Left := lBeforeInfo.Left + lBeforeInfo.Width + 5;
  eSearch.Width := Self.Canvas.TextWidth('00000');
  eSearch.Text := IntToStr(FNetworkParams.NetworkMinCostPercent);
  eSearch.OnKeyPress := eSearchKeyPress;
  eSearch.OnKeyDown := eSearchKeyDown;

  lAfterInfo := TLabel.Create(Self);
  lAfterInfo.Parent := pTop;
  lAfterInfo.Left := eSearch.Left + eSearch.Width + 5;
  lAfterInfo.Caption := '% между первой и второй ценой';

  lFindCount := TLabel.Create(Self);
  lFindCount.Parent := pTop;
  lFindCount.Left := lAfterInfo.Left + lAfterInfo.Width + 15;
  lFindCount.Caption := 'Позиций: ';

  spGotoMNNButton := TSpeedButton.Create(Self);
  spGotoMNNButton.Height := 25;
  spGotoMNNButton.Action := actGotoMNNAction;
  spGotoMNNButton.Caption := actGotoMNNAction.Caption;
  spGotoMNNButton.Parent := pTop;
  spGotoMNNButton.Width := Self.Canvas.TextWidth(spGotoMNNButton.Caption) + 20;
  spGotoMNNButton.Left := lFindCount.Left + lFindCount.Width + 50;

  btnSelectPrices.Parent := pTop;
  btnSelectPrices.Left := spGotoMNNButton.Left + spGotoMNNButton.Width + 15;

  lFilter.Parent := pTop;
  lFilter.Left := btnSelectPrices.Left + btnSelectPrices.Width + 10;

  lSearchName := TLabel.Create(Self);
  lSearchName.Parent := pTop;
  lSearchName.Left := lFilter.Left + lFilter.Width + 10;
  lSearchName.Caption := 'Поиск';

  eSearchName := TEdit.Create(Self);
  eSearchName.Parent := pTop;
  eSearchName.Left := lSearchName.Left + lSearchName.Width + 5;
  eSearchName.Width := Self.Canvas.TextWidth('00000000000000');
  eSearchName.OnKeyPress := eSearchNameKeyPress;
  eSearchName.OnKeyDown := eSearchNameKeyDown;

  pTop.Height := eSearch.Height + 10;
  eSearch.Top := (pTop.Height - eSearch.Height) div 2;
  eSearchName.Top := eSearch.Top;
  spGotoMNNButton.Top := (pTop.Height - spGotoMNNButton.Height) div 2;
  btnSelectPrices.Top := (pTop.Height - btnSelectPrices.Height) div 2;
  lFindCount.Top := (pTop.Height - lFindCount.Height) div 2;
  lBeforeInfo.Top := lFindCount.Top;
  lAfterInfo.Top := lFindCount.Top;
  lSearchName.Top := lFindCount.Top;
end;

procedure TMinPricesForm.CreateVisualComponent;
begin
  CreateOverCostPanel;
  CreateTopPanel;
  CreateLeftPanel;
  CreateOffersPanel;
end;

procedure TMinPricesForm.dbgMinPricesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    if
      ((Length(eSearch.Text) > 0) and (InternalSearchText <> eSearch.Text))
      or
      ((Length(eSearchName.Text) > 0) and (InternalSearchNameText <> eSearchName.Text))
    then
      tmrSearchTimer(nil)
    else
      dbgCore.SetFocus();
  end
  else
    if (Key = VK_ESCAPE) and AllowSearch() then
      SetClearByName;
end;

procedure TMinPricesForm.dbgMinPricesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key in [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
  begin
    if not tmrSearch.Enabled and (InternalSearchText = eSearch.Text) then
      eSearch.Text := '';
    AddKeyToSearch(Key);
  end
  else
    if AllowSearch() then begin
      if not tmrSearch.Enabled and (InternalSearchNameText = eSearchName.Text) then
        eSearchName.Text := '';
      AddKeyToSearchName(Key);
    end;
end;

procedure TMinPricesForm.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
    dbgMinPrices.SetFocus;
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TMinPricesForm.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  if (Key in [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])
  then begin
    AddKeyToSearch(Key);
    //Если мы что-то нажали в элементе, то должны на это отреагировать
    if Ord(Key) <> VK_RETURN then
      tmrSearch.Enabled := True;
  end
  else
    if (Ord(Key) <> VK_RETURN) or (Ord(Key) <> VK_ESCAPE)
    then
      Key := Char(0);
end;

procedure TMinPricesForm.FormCreate(Sender: TObject);
var
  I : Integer;
  sp : TSelectPrice;
  mi :TMenuItem;
begin
  InternalSearchNameText := '';
{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'Start create');
{$endif}
  try
  UseExcess := True;
  FNetworkParams := TNetworkParams.Create(DM.MainConnection);
{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'CreateNonVisualComponent');
{$endif}
  CreateNonVisualComponent;
{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'CreateVisualComponent');
{$endif}
  CreateVisualComponent;

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'config adsCore and inherited');
{$endif}
  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreOrderCount;
  fVolume := adsCoreRequestRatio;
  fOrderCost := adsCoreOrderCost;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMinOrderCount;
  fBuyingMatrixType := adsCoreBuyingMatrixType;
  SortOnOrderGrid := False;

  inherited;

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'add postion frame');
{$endif}
  TframePosition.AddFrame(Self, pOffers, dsCore, 'SynonymName', 'MnnId', ShowDescriptionAction);

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'add prices menu item');
{$endif}
  SelectedPrices := MinCostSelectedPrices;
  for I := 0 to SelectedPrices.Count-1 do begin
    sp := TSelectPrice(SelectedPrices.Objects[i]);
    mi := TMenuItem.Create(pmSelectedPrices);
    mi.Name := 'sl' + SelectedPrices[i];
    mi.Caption := sp.PriceName;
    mi.Checked := sp.Selected;
    mi.Tag := Integer(sp);
    mi.OnClick := OnSPClick;
    pmSelectedPrices.Items.Add(mi);
  end;
  finally
{$ifdef MinPricesLog}
    WriteExchangeLog('MinPricesForm', 'Stop create');
{$endif}
  end;
end;

procedure TMinPricesForm.InternalSearch;
var
  FilterSQL : String;
begin
{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'config adsMinPrices');
{$endif}
  adsMinPrices.Close;
  FNetworkParams.NetworkMinCostPercent := StrToInt(InternalSearchText);
  FNetworkParams.SaveMinCostPercent;

  adsMinPrices.SQL.Text := shShowMinPrices.Strings.Text;
  //adsMinPrices.SQL.Text := StrHolder1.Strings.Text;
  //adsMinPrices.SQL.Text := StrHolder2.Strings.Text;

  FilterSQL := GetSelectedPricesSQL(SelectedPrices, 'Core.');
  lFilter.Visible := Length(FilterSQL) > 0;

  if lFilter.Visible then
    adsMinPrices.SQL.Text := adsMinPrices.SQL.Text + 'and (' + FilterSQL + ')';

  if Length(InternalSearchNameText) > 0 then
    adsMinPrices.SQL.Text := adsMinPrices.SQL.Text + 'and (Synonyms.SYNONYMNAME like :LikeParam) ';

  adsMinPrices.SQL.Text := adsMinPrices.SQL.Text + 'ORDER BY Synonyms.SYNONYMNAME';
  adsMinPrices.ParamByName('Percent').Value := FNetworkParams.NetworkMinCostPercent;

  if Length(InternalSearchNameText) > 0 then
    adsMinPrices.ParamByName('LikeParam').Value := '%' + InternalSearchNameText + '%';

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm',
    'explain adsMinPrices result: ' + #13#10 +
    DM.DataSetToString(
      'explain EXTENDED ' + adsMinPrices.SQL.Text,
      ['Percent'],
      [FNetworkParams.NetworkMinCostPercent]));
{$endif}

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'open adsMinPrices');
{$endif}
  ShowSQLWaiting(adsMinPrices);

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'first adsMinPrices');
{$endif}
  adsMinPrices.First;

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'dbgMinPrices.SetFocus');
{$endif}
  if dbgMinPrices.CanFocus then
    dbgMinPrices.SetFocus;
end;

procedure TMinPricesForm.MinPricesAfteOpen(dataSet: TDataSet);
begin
  lFindCount.Caption := 'Позиций: ' + IntToStr(adsMinPrices.RecordCount);
  UpdateOffers;
end;

procedure TMinPricesForm.MinPricesAfteScroll(dataSet: TDataSet);
begin
  UpdateOffers;
end;

procedure TMinPricesForm.SetClear;
begin
  tmrSearch.Enabled := False;

  if (Length(InternalSearchNameText) > 0) or (Length(eSearchName.Text) > 0) then
  begin
    InternalSearch;
  end;

  //Непонятно, что делать при попытке сброса фильтра

  dbgMinPrices.SetFocus;
end;

procedure TMinPricesForm.ShowForm;
begin
{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'BindFiels');
{$endif}
  BindFields;

  plOverCost.Hide();

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'restore grid layouts');
{$endif}
  TDBGridHelper.RestoreColumnsLayout(dbgMinPrices, Self.ClassName);
  TDBGridHelper.RestoreColumnsLayout(dbgCore, Self.ClassName);

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'inherited ShowForm');
{$endif}
  inherited;

{$ifdef MinPricesLog}
  WriteExchangeLog('MinPricesForm', 'dbgMinPrices.SetFocus');
{$endif}
  dbgMinPrices.SetFocus;
end;

procedure TMinPricesForm.tmrSearchTimer(Sender: TObject);
var
  needSearch : Boolean;
begin
  tmrSearch.Enabled := False;
  needSearch := False;
  if (Length(eSearch.Text) > 0) and (StrToIntDef(eSearch.Text, 0) <> 0) then begin
    InternalSearchText := StrUtils.LeftStr(eSearch.Text, 50);
    needSearch := True;
  end;
  if (Length(eSearchName.Text) > 0) then begin
    InternalSearchNameText := StrUtils.LeftStr(eSearchName.Text, 50);
    needSearch := True;
  end
  else
    InternalSearchNameText := '';

  if needSearch then
    InternalSearch()
  else begin
    SetClearByName;
  end;
end;

procedure TMinPricesForm.tmrUpdatePreviosOrdersTimer(Sender: TObject);
begin
  tmrUpdatePreviosOrders.Enabled := False;
  if adsCore.Active then
    adsCore.Close;
  if adsMinPrices.Active and not adsMinPrices.IsEmpty
  then begin
    adsCore.ParamByName( 'ProductId').Value := minProductIdField.Value;
    adsCore.Open;
    adsCore.First;

    if adsCoreNamePromotionsCount.AsInteger > 0 then
      framePromotion.ShowPromotion(
        adsCoreshortcode.AsInteger,
        adsCorefullcode.AsInteger,
        adsCoreNamePromotionsCount.AsInteger)
    else
      framePromotion.HidePromotion();
  end;
end;

procedure TMinPricesForm.UpdateOffers;
begin
  framePromotion.HidePromotion();
  tmrUpdatePreviosOrders.Enabled := False;
  tmrUpdatePreviosOrders.Enabled := True;
end;

procedure TMinPricesForm.actGotoMNNActionExecute(Sender: TObject);
var
  MnnId : Int64;
  lastControl : TWinControl;
begin
  lastControl := Self.ActiveControl;
  if (MainForm.ActiveChild = Self)
     and (Assigned(adsCore))
     and not adsCore.IsEmpty
  then begin
    if Assigned(adsCoreMnnId) then begin
      if not adsCoreMnnId.IsNull then begin
        MnnId := adsCoreMnnId.Value;
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

procedure TMinPricesForm.actGotoMNNActionUpdate(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TAction) then begin
    if (MainForm.ActiveChild = Self)
       and (Assigned(adsCore))
       and not adsCore.IsEmpty
    then begin
      TAction(Sender).Enabled := Assigned(adsCoreMnnId) and not adsCoreMnnId.IsNull
    end
    else
      TAction(Sender).Enabled := False;
  end;
end;

procedure TMinPricesForm.OnSPClick(Sender: TObject);
var
  sp : TSelectPrice;
begin
  tmrSelectedPrices.Enabled := False;
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  sp := TSelectPrice(TMenuItem(Sender).Tag);
  sp.Selected := TMenuItem(Sender).Checked;
  pmSelectedPrices.Popup(pmSelectedPrices.PopupPoint.X, pmSelectedPrices.PopupPoint.Y);
  tmrSelectedPrices.Enabled := True;
end;

procedure TMinPricesForm.tmrSelectedPricesTimer(Sender: TObject);
begin
  tmrSelectedPrices.Enabled := False;
  if not tmrSearch.Enabled and (Length(InternalSearchText) > 0) then
    InternalSearch;
end;

procedure TMinPricesForm.btnSelectPricesClick(Sender: TObject);
begin
  pmSelectedPrices.Popup(btnSelectPrices.ClientOrigin.X, btnSelectPrices.ClientOrigin.Y + btnSelectPrices.Height);
end;

procedure TMinPricesForm.miSelectAllClick(Sender: TObject);
begin
  ChangeSelected(True);
end;

procedure TMinPricesForm.miUnselecAllClick(Sender: TObject);
begin
  ChangeSelected(False);
end;

procedure TMinPricesForm.ChangeSelected(ASelected: Boolean);
var
  I : Integer;
begin
  tmrSelectedPrices.Enabled := False;
  for I := 3 to pmSelectedPrices.Items.Count-1 do begin
    pmSelectedPrices.Items.Items[i].Checked := ASelected;
    TSelectPrice(TMenuItem(pmSelectedPrices.Items.Items[i]).Tag).Selected := ASelected;
  end;
  pmSelectedPrices.Popup(pmSelectedPrices.PopupPoint.X, pmSelectedPrices.PopupPoint.Y);
  tmrSelectedPrices.Enabled := True;
end;

procedure TMinPricesForm.AddCoreFields;
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

procedure TMinPricesForm.adsCoreCalcFields(DataSet: TDataSet);
begin
  try
    if FAllowDelayOfPayment and not FShowSupplierCost then
      adsCorePriceRet.AsCurrency :=
        DM.GetRetailCostLast(
          adsCoreRetailVitallyImportant.Value,
          adsCoreCost.AsCurrency)
    else
      adsCorePriceRet.AsCurrency :=
        DM.GetRetailCostLast(
          adsCoreRetailVitallyImportant.Value,
          adsCoreRealCost.AsCurrency);
  except
  end;
end;

procedure TMinPricesForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    dbgMinPrices.SetFocus();
end;

procedure TMinPricesForm.dbgCoreCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
  CanInput := (not adsCore.IsEmpty) and ( adsCoreSynonymCode.AsInteger >= 0) and
    (( adsCoreRegionCode.AsLargeInt and DM.adtClientsREQMASK.AsLargeInt) =
      adsCoreRegionCode.AsLargeInt);
end;

procedure TMinPricesForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if adsCoreSynonymCode.AsInteger < 0 then
  begin
    Background := $00fff1d8;
    AFont.Style := [fsBold];
  end
  else
  if adsCoreFirmCode.AsInteger = RegisterId then
  begin
    //если это реестр, изменяем цвета
    if ( Column.Field = adsCoreSYNONYMNAME) or ( Column.Field = adsCoreSYNONYMFIRM)
       or ( Column.Field = adsCoreCOST)
       or ( Column.Field = adsCorePriceRet)
      then Background := REG_CLR;
  end
  else
  begin
    if adsCoreVITALLYIMPORTANT.AsBoolean then
      AFont.Color := VITALLYIMPORTANT_CLR;
    if not adsCorePriceEnabled.AsBoolean then
    begin
      //если фирма недоступна, изменяем цвет
      if ( Column.Field = adsCoreSYNONYMNAME) or ( Column.Field = adsCoreSYNONYMFIRM)
        then Background := clBtnFace;
    end;

    //если уцененный товар, изменяем цвет
    if adsCoreJunk.AsBoolean and (( Column.Field = adsCorePERIOD) or ( Column.Field = adsCoreCost))
    then
      Background := JUNK_CLR;
    //ожидаемый товар выделяем зеленым
    if adsCoreAwait.AsBoolean and ( Column.Field = adsCoreSYNONYMNAME) then
      Background := AWAIT_CLR;
      
    if (adsCoreBuyingMatrixType.Value = 1) then
      Background := BuyingBanColor;
  end;
end;

procedure TMinPricesForm.adsCoreAfterPost(DataSet: TDataSet);
begin
  MainForm.SetOrdersInfo;
end;

procedure TMinPricesForm.adsCoreBeforeEdit(DataSet: TDataSet);
begin
  if adsCoreFirmCode.AsInteger = RegisterId then Abort;
end;

procedure TMinPricesForm.adsCoreBeforePost(DataSet: TDataSet);
var
  Quantity, E: Integer;
  PriceAvg: Double;
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
        PanelCaption := 'Препарат запрещен к заказу.';

        ShowOverCostPanel(PanelCaption);

        Abort;
      end;
    end;
    
    { проверяем на превышение цены }
{
    if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) and (not adsAvgOrdersPRODUCTID.IsNull) then
    begin
      PriceAvg := adsAvgOrdersPRICEAVG.AsCurrency;
      if ( PriceAvg > 0) and ( adsCoreCOST.AsCurrency>PriceAvg*( 1 + Excess / 100)) then
      begin
        if Length(PanelCaption) > 0 then
          PanelCaption := PanelCaption + #13#10 + 'Превышение средней цены!'
        else
          PanelCaption := 'Превышение средней цены!';
      end;
    end;
}

    if (adsCoreJUNK.Value) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + 'Вы заказали некондиционный препарат.'
      else
        PanelCaption := 'Вы заказали некондиционный препарат.';

    if (adsCoreORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + 'Внимание! Вы заказали большое количество препарата.'
      else
        PanelCaption := 'Внимание! Вы заказали большое количество препарата.';

    if Length(PanelCaption) > 0 then
      ShowOverCostPanel(PanelCaption);

  except
    adsCore.Cancel;
    raise;
  end;
end;

procedure TMinPricesForm.CreateOverCostPanel;
begin
  plOverCost := TPanel.Create(Self);
  plOverCost.Visible := False;
  plOverCost.ParentFont := False;
  plOverCost.Font.Color := clRed;
  plOverCost.Font.Size := 16;
  plOverCost.Parent := Self;

  lWarning := TLabel.Create(Self);
  lWarning.AutoSize := False;
  lWarning.Parent := plOverCost;
  lWarning.Align := alClient;
  lWarning.Alignment := taCenter;
  lWarning.Layout := tlCenter;
end;

procedure TMinPricesForm.tmrOverCostHideTimer(Sender: TObject);
begin
  tmrOverCostHide.Enabled := False;
  plOverCost.Hide;
  plOverCost.SendToBack;
end;

procedure TMinPricesForm.ShowOverCostPanel(panelCaption: String);
var
  PanelHeight : Integer;
  sl : TStringList;
  CaptionWordCount,
  I,
  panelWidth : Integer;
begin
  if tmrOverCostHide.Enabled then
    tmrOverCostHide.OnTimer(nil);

  if lWarning.Canvas.Font.Size <> lWarning.Font.Size then
    lWarning.Canvas.Font.Size := lWarning.Font.Size;

  sl := TStringList.Create;
  try
    sl.Text := panelCaption;
    CaptionWordCount := sl.Count;
    panelWidth := lWarning.Canvas.TextWidth(sl[0]);
    for I := 1 to sl.Count-1 do
      if lWarning.Canvas.TextWidth(sl[i]) > panelWidth then
        panelWidth := lWarning.Canvas.TextWidth(sl[i]);
  finally
    sl.Free;
  end;

  lWarning.Caption := PanelCaption;
  PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
  plOverCost.Height := PanelHeight * CaptionWordCount + 20;
  plOverCost.Width := panelWidth + 20;

  plOverCost.Top := pOffers.Top + ( dbgCore.Height - plOverCost.Height) div 2;
  plOverCost.Left := pOffers.Left + ( dbgCore.Width - plOverCost.Width) div 2;
  plOverCost.BringToFront;
  plOverCost.Show;
  tmrOverCostHide.Enabled := True;
end;

procedure TMinPricesForm.UpdateOrderDataset;
begin
  inherited;
  dbgMinPrices.SetFocus();
end;

procedure TMinPricesForm.dbgMinPricesSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TMinPricesForm.FormHide(Sender: TObject);
begin
  inherited;
  if Assigned(dbgMinPrices) then
    TDBGridHelper.SaveColumnsLayout(dbgMinPrices, Self.ClassName);
  if Assigned(dbgCore) then
    TDBGridHelper.SaveColumnsLayout(dbgCore, Self.ClassName);
end;

procedure TMinPricesForm.FormResize(Sender: TObject);
begin
  if Assigned(pWebBrowser) then
    pWebBrowser.Visible := Self.ClientHeight > 800;

  if AllowSearch() then
    ShowSearch
  else
    HideSearch();
end;

function TMinPricesForm.AllowSearch: Boolean;
var
  borderWidth : Integer;
begin
  borderWidth := 850;
  if Assigned(eSearchName) then
    borderWidth := eSearchName.Left + eSearchName.Width + 5;
  Result := Self.Width > borderWidth;
end;

procedure TMinPricesForm.HideSearch;
begin
  if Assigned(eSearchName) then begin
    lSearchName.Visible := False;
    eSearchName.Visible := False;
  end;
end;

procedure TMinPricesForm.ShowSearch;
begin
  if Assigned(eSearchName) then begin
    lSearchName.Visible := True;
    eSearchName.Visible := True;
  end;
end;

procedure TMinPricesForm.eSearchNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
    dbgMinPrices.SetFocus;
  end
  else
    if Key = VK_ESCAPE then
      SetClearByName;
end;

procedure TMinPricesForm.eSearchNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearchName(Key);
  //Если мы что-то нажали в элементе, то должны на это отреагировать
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

procedure TMinPricesForm.AddKeyToSearchName(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearchName.Focused then
      eSearchName.Text := eSearchName.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TMinPricesForm.SetClearByName;
begin
  tmrSearch.Enabled := False;
  eSearchName.Text := '';
  InternalSearchNameText := '';

  InternalSearch;

  dbgMinPrices.SetFocus;
end;

end.
