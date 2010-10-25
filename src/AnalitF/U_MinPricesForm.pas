unit U_MinPricesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls,
  StdCtrls,
  StrUtils,
  Buttons,
  SHDocVw,
  ActnList,
  Menus,
  DB,
  DBAccess,
  MyAccess,
  StrHlder,
  GridsEh,
  DbGridEh,
  AProc,
  ToughDBGrid,
  NetworkParams;

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
    procedure FormCreate(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
    procedure tmrUpdatePreviosOrdersTimer(Sender: TObject);
    procedure actGotoMNNActionExecute(Sender: TObject);
    procedure actGotoMNNActionUpdate(Sender: TObject);
    procedure tmrSelectedPricesTimer(Sender: TObject);
    procedure btnSelectPricesClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure miUnselecAllClick(Sender: TObject);
  private
    { Private declarations }
    FNetworkParams : TNetworkParams;
    InternalSearchText : String;
    
    SelectedPrices : TStringList;

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

    procedure ChangeSelected(ASelected : Boolean);
  protected
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure MinPricesAfteOpen(dataSet : TDataSet);
    procedure MinPricesAfteScroll(dataSet : TDataSet);

    procedure dbgMinPricesKeyPress(Sender: TObject; var Key: Char);
    procedure dbgMinPricesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure OnSPClick(Sender: TObject);
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

    adsCore : TMyQuery;
    dsCore : TDataSource;

    pTop : TPanel;
    eSearch : TEdit;
    lFindCount : TLabel;
    spGotoMNNButton : TSpeedButton;

    pLeft : TPanel;
    dbgMinPrices : TToughDBGrid;

    pOffers : TPanel;
    dbgCore : TToughDBGrid;
    pWebBrowser : TPanel;
    bWebBrowser : TBevel;
    WebBrowser : TWebBrowser;


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

  InternalSearch;
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

  dbgMinPrices.OnKeyPress := dbgMinPricesKeyPress;
  dbgMinPrices.OnKeyDown := dbgMinPricesKeyDown;
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

  WebBrowser := TWebBrowser.Create(Self);
  WebBrowser.Tag := 2;
  TWinControl(WebBrowser).Name := 'WebBrowser';
  TWinControl(WebBrowser).Parent := pWebBrowser;
  TWinControl(WebBrowser).Align := alClient;
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
  if DM.adtClientsAllowDelayOfPayment.Value then
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
  eSearch.Text := IntToStr(FNetworkParams.NetworkMinCostPercent);
  eSearch.OnKeyPress := eSearchKeyPress;
  eSearch.OnKeyDown := eSearchKeyDown;

  lFindCount := TLabel.Create(Self);
  lFindCount.Parent := pTop;
  lFindCount.Left := eSearch.Left + eSearch.Width + 15;
  lFindCount.Caption := 'Количество найденных позиций: ';

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

  pTop.Height := eSearch.Height + 10;
  eSearch.Top := (pTop.Height - eSearch.Height) div 2;
  spGotoMNNButton.Top := (pTop.Height - spGotoMNNButton.Height) div 2;
  btnSelectPrices.Top := (pTop.Height - btnSelectPrices.Height) div 2;
  lFindCount.Top := (pTop.Height - lFindCount.Height) div 2;
end;

procedure TMinPricesForm.CreateVisualComponent;
begin
  CreateTopPanel;
  CreateLeftPanel;
  CreateOffersPanel;
end;

procedure TMinPricesForm.dbgMinPricesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
  end;
end;

procedure TMinPricesForm.dbgMinPricesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key in [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
  begin
    if not tmrSearch.Enabled and (InternalSearchText = eSearch.Text) then
      eSearch.Text := '';
    AddKeyToSearch(Key);
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
  FNetworkParams := TNetworkParams.Create(DM.MainConnection);
  CreateNonVisualComponent;
  CreateVisualComponent;

  inherited;

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
end;

procedure TMinPricesForm.InternalSearch;
var
  FilterSQL : String;
begin
  adsMinPrices.Close;
  FNetworkParams.NetworkMinCostPercent := StrToInt(InternalSearchText);
  FNetworkParams.SaveMinCostPercent;

  adsMinPrices.SQL.Text := shShowMinPrices.Strings.Text;

  FilterSQL := GetSelectedPricesSQL(SelectedPrices, 'Core.');
  lFilter.Visible := Length(FilterSQL) > 0;

  if lFilter.Visible then
    adsMinPrices.SQL.Text := adsMinPrices.SQL.Text + 'and (' + FilterSQL + ')';

  adsMinPrices.SQL.Text := adsMinPrices.SQL.Text + 'ORDER BY Synonyms.SYNONYMNAME';
  adsMinPrices.ParamByName('Percent').Value := FNetworkParams.NetworkMinCostPercent;

  adsMinPrices.Open;

  adsMinPrices.First;

  if dbgMinPrices.CanFocus then
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

  //Непонятно, что делать при попытке сброса фильтра

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
    adsCore.ParamByName( 'ProductId').Value := minProductIdField.Value;
    adsCore.Open;
    adsCore.First;
  end;
end;

procedure TMinPricesForm.UpdateOffers;
begin
  tmrUpdatePreviosOrders.Enabled := False;
  tmrUpdatePreviosOrders.Enabled := True;
end;

procedure TMinPricesForm.actGotoMNNActionExecute(Sender: TObject);
begin
{
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
}
end;

procedure TMinPricesForm.actGotoMNNActionUpdate(Sender: TObject);
begin
{
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
}
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

end.
