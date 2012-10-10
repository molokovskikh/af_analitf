unit U_WaybillGridFactory;

interface

uses
  SysUtils,
  Classes,
  Windows,
  Controls,
  DB,
  DBGridEh,
  DBGridHelper;

type
  TWaybillGridFactory = class
   public
    class procedure AddColumnsToGrid(
      Grid: TCustomDBGridEh;
      CreatedByUser : Boolean;
      stringUpdateData,
      floatUpdateData,
      integerUpdateData,
      retailMarkupUpdateData,
      realMarkupUpdateData,
      retailPriceUpdateData : TColCellUpdateDataEventEh;
      retailMarkupGetCellParams,
      realMarkupGetCellParams,
      retailPriceGetCellParams : TGetColCellParamsEventEh);
    class function GetDetailWaybillSectionName() : String;
    class function GetDetailUserWaybillSectionName() : String;
    class function GetDetailRejectSectionName() : String;
    class procedure RearrangeColumnsOnWaybills(winParent : TWinControl);
  end;

implementation

{ TWaybillGridFactory }

class procedure TWaybillGridFactory.AddColumnsToGrid(
  Grid: TCustomDBGridEh;
  CreatedByUser: Boolean;
  stringUpdateData,
  floatUpdateData,
  integerUpdateData,
  retailMarkupUpdateData,
  realMarkupUpdateData,
  retailPriceUpdateData: TColCellUpdateDataEventEh;
  retailMarkupGetCellParams,
  realMarkupGetCellParams,
  retailPriceGetCellParams : TGetColCellParamsEventEh);
var
  column : TColumnEh;
  I : Integer;
begin
  Grid.AutoFitColWidths := False;
  try
    column := TDBGridHelper.AddColumn(Grid, 'Product', 'Наименование', 0, not CreatedByUser);
    TDBGridHelper.AddColumn(Grid, 'Producer', 'Производитель', 0, not CreatedByUser);
    TDBGridHelper.AddColumn(Grid, 'Country', 'Страна', 0, not CreatedByUser);
    column := TDBGridHelper.AddColumn(Grid, 'Printed', '    Печатать', Grid.Canvas.TextWidth('Печатать'), False);
    column.Checkboxes := True;
    TDBGridHelper.AddColumn(Grid, 'Period', 'Срок годности', 0, not CreatedByUser);
    TDBGridHelper.AddColumn(Grid, 'SerialNumber', 'Серия товара', 0, not CreatedByUser);
    if not CreatedByUser then begin
      column := TDBGridHelper.AddColumn(Grid, 'CertificateId', 'Сертификаты', Grid.Canvas.TextWidth('Сертификаты'), True);
      column := TDBGridHelper.AddColumn(Grid, 'RequestCertificate', 'Получить', Grid.Canvas.TextWidth('Получить'), False);
      column.Checkboxes := True;
    end;
    column := TDBGridHelper.AddColumn(Grid, 'Certificates', 'Номер сертификата', 0, not CreatedByUser);
    column.Visible := False;
    if CreatedByUser then begin
      column := TDBGridHelper.AddColumn(Grid, 'VitallyImportantByUser', 'ЖНВЛС', 0, False);
      column.Checkboxes := True;
    end;
    column := TDBGridHelper.AddColumn(Grid, 'ProducerCost', 'Цена производителя без НДС', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := floatUpdateData;
    column := TDBGridHelper.AddColumn(Grid, 'RegistryCost', 'Цена ГР', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := floatUpdateData;
    column := TDBGridHelper.AddColumn(Grid, 'SupplierPriceMarkup', 'Торговая наценка оптовика', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := floatUpdateData;
    column := TDBGridHelper.AddColumn(Grid, 'SupplierCostWithoutNDS', 'Цена поставщика без НДС', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := floatUpdateData;
    column := TDBGridHelper.AddColumn(Grid, 'NDS', 'НДС', Grid.Canvas.TextWidth('999'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := integerUpdateData;
    column := TDBGridHelper.AddColumn(Grid, 'SupplierCost', 'Цена поставщика с НДС', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := floatUpdateData;
    TDBGridHelper.AddColumn(Grid, 'MaxRetailMarkup', 'Макс. розничная наценка', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    column := TDBGridHelper.AddColumn(Grid, 'RetailMarkup', 'Розничная наценка', Grid.Canvas.TextWidth('99999.99'), False);
    column.OnUpdateData := retailMarkupUpdateData;
    column.OnGetCellParams := retailMarkupGetCellParams;
    column := TDBGridHelper.AddColumn(Grid, 'RealMarkup', 'Реальная наценка', Grid.Canvas.TextWidth('99999.99'), False);
    column.OnUpdateData := realMarkupUpdateData;
    column.OnGetCellParams := realMarkupGetCellParams;
    column := TDBGridHelper.AddColumn(Grid, 'RetailPrice', 'Розничная цена', Grid.Canvas.TextWidth('99999.99'), False);
    column.OnUpdateData := retailPriceUpdateData;
    column.OnGetCellParams := retailPriceGetCellParams;
    column := TDBGridHelper.AddColumn(Grid, 'Quantity', 'Заказ', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := integerUpdateData;
    TDBGridHelper.AddColumn(Grid, 'RetailSumm', 'Розничная сумма', Grid.Canvas.TextWidth('99999.99'));

    if CreatedByUser then
      for I := 0 to Grid.Columns.Count-1 do begin
        column := Grid.Columns[i];
        if Assigned(column.Field) and (column.Field is TStringField) and not Assigned(column.OnUpdateData) then
          column.OnUpdateData := stringUpdateData;
      end;
  finally
    Grid.AutoFitColWidths := True;
  end;
end;

class function TWaybillGridFactory.GetDetailRejectSectionName: String;
begin
  Result := 'DetailReject';
end;

class function TWaybillGridFactory.GetDetailUserWaybillSectionName: String;
begin
  Result := 'DetailUserWaybill';
end;

class function TWaybillGridFactory.GetDetailWaybillSectionName: String;
begin
  Result := 'DetailWaybill';
end;

class procedure TWaybillGridFactory.RearrangeColumnsOnWaybills(
  winParent: TWinControl);
var
  grid : TCustomDBGridEh;
begin
  grid := TDBGridEh.Create(nil);
  try
    grid.Visible := False;
    grid.Name := 'dbgDocumentBodies';
    grid.Parent := winParent;

    AddColumnsToGrid(
      grid,
      False,
      nil, nil, nil, nil, nil, nil,
      nil, nil, nil);

    TDBGridHelper.RestoreColumnsLayout(grid, GetDetailWaybillSectionName(), 'TDocumentBodiesFormdbgDocumentBodies');

    TDBGridHelper.RearrangeColumns(grid,
      ['Product', 'Producer', 'Country', 'Printed', 'Period', 'SerialNumber',
       'CertificateId', 'RequestCertificate' , 'Certificates',
      'ProducerCost', 'RegistryCost', 'SupplierPriceMarkup', 'SupplierCostWithoutNDS',
      'NDS', 'SupplierCost', 'MaxRetailMarkup', 'RetailMarkup', 'RealMarkup',
      'RetailPrice', 'Quantity', 'RetailSumm']);

    TDBGridHelper.SaveColumnsLayout(grid, GetDetailWaybillSectionName(), 'TDocumentBodiesFormdbgDocumentBodies');
  finally
    grid.Free;
  end;
end;

end.
