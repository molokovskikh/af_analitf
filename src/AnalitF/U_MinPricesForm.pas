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
  ToughDBGrid;

type
  TMinPricesForm = class(TChildForm)
    shShowMinPrices: TStrHolder;
    tmrSearch: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
  private
    { Private declarations }
    InternalSearchText : String;
    
    procedure CreateNonVisualComponent;

    procedure CreateVisualComponent;
    procedure CreateTopPanel;
    procedure CreateLeftPanel;

    procedure BindFields;

    procedure AddKeyToSearch(Key : Char);
    procedure SetClear;
    procedure InternalSearch;
  protected
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    { Public declarations }
    adsMinPrices : TMyQuery;
    dsMinPrices : TDataSource;
    minProductIdField : TLargeintField;
    minRegionCodeField : TLargeintField;
    minMinCostField : TFloatField;
    minNextCostField : TFloatField;
    minMinCostCount : TIntegerField;
    minSynonymNameField : TStringField;
    minPercentField : TFloatField;

    pTop : TPanel;
    eSearch : TEdit;

    pLeft : TPanel;
    dbgMinPrices : TToughDBGrid;

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
  minMinCostCount := TDataSetHelper.AddIntegerField(adsMinPrices, 'MinCostCount');
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
  eSearch.OnKeyPress := eSearchKeyPress;
  eSearch.OnKeyDown := eSearchKeyDown;

  pTop.Height := eSearch.Height + 10;
  eSearch.Top := (pTop.Height - eSearch.Height) div 2;
end;

procedure TMinPricesForm.CreateVisualComponent;
begin
  CreateTopPanel;
  CreateLeftPanel;
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

  dbgMinPrices.SetFocus;
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

end.
