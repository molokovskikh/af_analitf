unit U_MinPricesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls,
  StdCtrls,
  StrUtils,
  DB,
  DBAccess,
  MyAccess,
  StrHlder,
  GridsEh,
  DbGridEh,
  AProc,
  ToughDBGrid;

type
  TMinPricesForm = class(TChildForm)
    shShowMinPrices: TStrHolder;
    tmrSearch: TTimer;
    shCore: TStrHolder;
    tmrUpdatePreviosOrders: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
    procedure tmrUpdatePreviosOrdersTimer(Sender: TObject);
  private
    { Private declarations }
    InternalSearchText : String;
    
    procedure CreateNonVisualComponent;

    procedure CreateVisualComponent;
    procedure CreateTopPanel;
    procedure CreateLeftPanel;
    procedure CreateOffersPanel;

    procedure BindFields;

    procedure AddKeyToSearch(Key : Char);
    procedure SetClear;
    procedure InternalSearch;

    procedure UpdateOffers();
  protected
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure MinPricesAfteOpen(dataSet : TDataSet);
    procedure MinPricesAfteScroll(dataSet : TDataSet);
  public
    { Public declarations }
    adsMinPrices : TMyQuery;
    dsMinPrices : TDataSource;
    minProductIdField : TLargeintField;
    minRegionCodeField : TLargeintField;
    minMinCostField : TFloatField;
    minNextCostField : TFloatField;
    //minMinCostCount : TIntegerField;
    minSynonymNameField : TStringField;
    minPercentField : TFloatField;

    adsCore : TMyQuery;
    dsCore : TDataSource;

    pTop : TPanel;
    eSearch : TEdit;
    lFindCount : TLabel;

    pLeft : TPanel;
    dbgMinPrices : TToughDBGrid;

    pOffers : TPanel;
    dbgCore : TToughDBGrid;

    procedure ShowForm; override;
  end;

  procedure ShowMinPrices;

implementation

uses
  Main,
  DModule,
  DBGridHelper,
  DataSetHelper;

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
  dbgMinPrices.DataSource := dsMinPrices;

  dbgCore.DataSource := dsCore;

  adsMinPrices.Open;
end;

procedure TMinPricesForm.CreateLeftPanel;
begin
  pLeft := TPanel.Create(Self);
  pLeft.ControlStyle := pLeft.ControlStyle - [csParentBackground] + [csOpaque];
  pLeft.Align := alLeft;
  pLeft.Parent := Self;

  dbgMinPrices := TToughDBGrid.Create(Self);
  dbgMinPrices.Name := 'dbgMinPrices';
  dbgMinPrices.Parent := pLeft;
  dbgMinPrices.Align := alClient;
  dbgMinPrices.Width := 480;
  pLeft.Width := dbgMinPrices.Width;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgMinPrices);

  TDBGridHelper.AddColumn(dbgMinPrices, 'SynonymName', 'Наименование', Self.Canvas.TextWidth('Большое наименование'));
  TDBGridHelper.AddColumn(dbgMinPrices, 'MinCost', 'Мин. цена', '0.00;;''''', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgMinPrices, 'NextCost', 'След. цена', '0.00;;''''', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgMinPrices, 'Percent', '%', '0.00;;''''', Self.Canvas.TextWidth('999.99'));
{
  TDBGridHelper.AddColumn(dbgMinPrices, 'OrderCount', 'Заказ', Self.Canvas.TextWidth('999'));
  TDBGridHelper.AddColumn(dbgMinPrices, 'ProducerCost', 'Цена производителя', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgMinPrices, 'Price', 'Цена', Self.Canvas.TextWidth('999.99'));
  TDBGridHelper.AddColumn(dbgMinPrices, 'OrderDate', 'Дата', 0);
}

end;

procedure TMinPricesForm.CreateNonVisualComponent;
begin
  adsMinPrices := TMyQuery.Create(Self);
  adsMinPrices.Name := 'adsMinPrices';
  adsMinPrices.Connection := DM.MainConnection;
  adsMinPrices.RefreshOptions := [roAfterUpdate];
  adsMinPrices.Options.StrictUpdate := False;
  adsMinPrices.SQL.Text := shShowMinPrices.Strings.Text;
  adsMinPrices.ParamByName('Percent').Value := 30;

  adsMinPrices.AfterOpen := MinPricesAfteOpen;
  adsMinPrices.AfterScroll := MinPricesAfteScroll;
  //adsReport.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
{
  adsMinPrices.SQLDelete.Text := shDelete.Strings.Text;
  adsMinPrices.SQLUpdate.Text := stUpdate.Strings.Text;
  adsMinPrices.SQLRefresh.Text := stRefresh.Strings.Text;
}
{
  adsMinPrices.AfterPost := AfterPost;
  adsMinPrices.BeforeClose := ReportBeforeClose;
  adsMinPrices.AfterOpen := UpdatePreviosOrders;
  adsMinPrices.AfterScroll := UpdatePreviosOrders;
}

  minProductIdField := TDataSetHelper.AddLargeintField(adsMinPrices, 'ProductId');
  minRegionCodeField := TDataSetHelper.AddLargeintField(adsMinPrices, 'RegionCode');
  minMinCostField := TDataSetHelper.AddFloatField(adsMinPrices, 'MinCost');
  minNextCostField := TDataSetHelper.AddFloatField(adsMinPrices, 'NextCost');
//  minMinCostCount := TDataSetHelper.AddIntegerField(adsMinPrices, 'MinCostCount');
  minSynonymNameField := TDataSetHelper.AddStringField(adsMinPrices, 'SynonymName');
  minPercentField := TDataSetHelper.AddFloatField(adsMinPrices, 'Percent');

{
  IdField := TDataSetHelper.AddLargeintField(adsReport, 'Id');
  ProducerStatusField := TDataSetHelper.AddLargeintField(adsReport, 'ProducerStatus');
  ProducerStatusField.OnGetText := ProducerStatusGetText;
  SynonymNameField := TDataSetHelper.AddStringField(adsReport, 'SynonymName');
  ProductIdField := TDataSetHelper.AddLargeintField(adsReport, 'ProductId');
  OrderListIdField := TDataSetHelper.AddLargeintField(adsReport, 'OrderListId');
  StatusField := TDataSetHelper.AddIntegerField(adsReport, 'Status');
  CoreIdField := TDataSetHelper.AddLargeintField(adsReport, 'CoreId');
}

  dsMinPrices := TDataSource.Create(Self);
  dsMinPrices.DataSet := adsMinPrices;


  adsCore := TMyQuery.Create(Self);
  adsCore.SQL.Text := shCore.Strings.Text;
  adsCore.ParamByName('TimeZoneBias').Value := AProc.TimeZoneBias;
  adsCore.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;

  dsCore := TDataSource.Create(Self);
  dsCore.DataSet := adsCore;
end;

procedure TMinPricesForm.CreateOffersPanel;
var
  column : TColumnEh;
begin
  pOffers := TPanel.Create(Self);
  pOffers.ControlStyle := pLeft.ControlStyle - [csParentBackground] + [csOpaque];
  pOffers.Align := alClient;
  pOffers.Parent := Self;

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
  if DM.adtClientsAllowDelayOfPayment.Value then
    column := TDBGridHelper.AddColumn(dbgCore, 'RealCost', 'Цена поставщика', 30);
  //column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Cost', 'Цена', '0.00;;''''', 55);
  column.Font.Style := [fsBold];
  column := TDBGridHelper.AddColumn(dbgCore, 'PriceRet', 'Розн. цена', '0.00;;''''', 62);
  column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Quantity', 'Количество', 68);
  column.Alignment := taRightJustify;
  {
  column := TDBGridHelper.AddColumn(dbgCore, 'OrderCount', 'Заказ', 47);
  column.Color := TColor(16775406);
  column := TDBGridHelper.AddColumn(dbgCore, 'SumOrder', 'Сумма', '0.00;;''''', 70);
  column.Color := TColor(16775406);
  }
end;

procedure TMinPricesForm.CreateTopPanel;
begin
  pTop := TPanel.Create(Self);
  pTop.ControlStyle := pTop.ControlStyle - [csParentBackground] + [csOpaque];
  pTop.Align := alTop;
  pTop.Parent := Self;

  eSearch := TEdit.Create(Self);
  eSearch.Parent := pTop;
  eSearch.Left := 5;
  eSearch.Width := Self.Canvas.TextWidth('Это очень очень длинная строка поиска');
  eSearch.Text := '30';
  eSearch.OnKeyPress := eSearchKeyPress;
  eSearch.OnKeyDown := eSearchKeyDown;

  lFindCount := TLabel.Create(Self);
  lFindCount.Parent := pTop;
  lFindCount.Left := eSearch.Left + eSearch.Width + 15;
  lFindCount.Caption := 'Количество найденных позиций: ';

  pTop.Height := eSearch.Height + 10;
  eSearch.Top := (pTop.Height - eSearch.Height) div 2;
  lFindCount.Top := (pTop.Height - lFindCount.Height) div 2;
end;

procedure TMinPricesForm.CreateVisualComponent;
begin
  CreateTopPanel;
  CreateLeftPanel;
  CreateOffersPanel;
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
  AddKeyToSearch(Key);
  //Если мы что-то нажали в элементе, то должны на это отреагировать
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

procedure TMinPricesForm.FormCreate(Sender: TObject);
begin
  InternalSearchText := '';

  CreateNonVisualComponent;
  CreateVisualComponent;

  inherited;


end;

procedure TMinPricesForm.InternalSearch;
begin
  //DBProc.SetFilterProc(adsReport, FilterRecord);

  adsMinPrices.Close;
  adsMinPrices.ParamByName('Percent').Value := eSearch.Text;
  adsMinPrices.Open;

  adsMinPrices.First;

  dbgMinPrices.SetFocus;
end;

procedure TMinPricesForm.MinPricesAfteOpen(dataSet: TDataSet);
begin
  lFindCount.Caption := 'Количество найденных позиций: ' + IntToStr(adsMinPrices.RecordCount);
  UpdateOffers;
end;

procedure TMinPricesForm.MinPricesAfteScroll(dataSet: TDataSet);
begin
  UpdateOffers;
end;

procedure TMinPricesForm.SetClear;
begin
  tmrSearch.Enabled := False;

  //SetFilter(TFilterReport(cbFilter.ItemIndex));

  dbgMinPrices.SetFocus;
end;

procedure TMinPricesForm.ShowForm;
begin
  BindFields;

  inherited;

  dbgMinPrices.SetFocus;
end;

procedure TMinPricesForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if (Length(eSearch.Text) > 1) and (StrToIntDef(eSearch.Text, 0) <> 0) then begin
    InternalSearchText := LeftStr(eSearch.Text, 50);
    InternalSearch;
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TMinPricesForm.tmrUpdatePreviosOrdersTimer(Sender: TObject);
begin
  tmrUpdatePreviosOrders.Enabled := False;
  if adsCore.Active then
    adsCore.Close;
  if adsMinPrices.Active and not adsMinPrices.IsEmpty
  then begin
{
    adsPreviosOrders.ParamByName( 'GroupByProducts').Value :=
      DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean;
    adsPreviosOrders.ParamByName( 'FullCode').Value := FullcodeField.Value;
    adsPreviosOrders.ParamByName( 'ProductId').Value := minProductIdField.Value;
    adsPreviosOrders.Open;
}    
    adsCore.ParamByName( 'ProductId').Value := minProductIdField.Value;
    adsCore.Open;
    adsCore.First;
{
    if not CoreIdField.IsNull and not adsCore.Locate('CoreId', CoreIdField.Value, [])
    then
      adsCore.First;
}      
  end;
end;

procedure TMinPricesForm.UpdateOffers;
begin
  tmrUpdatePreviosOrders.Enabled := False;
  tmrUpdatePreviosOrders.Enabled := True;
end;

end.
