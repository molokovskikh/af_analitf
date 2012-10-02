unit WaybillGridColumnTests;

interface

{$I '..\AF.inc'}

uses
  SysUtils,
  Windows,
  Classes,
  Controls,
  Comctrls,
  DB,
  TestFrameWork,
  DBGridEh,
  UniqueID,
  AProc,
  DBProc,
  DBGridHelper,
  U_WaybillGridFactory;

type
  TTestWaybillGridColumn = class(TTestCase)
   private
    procedure CheckColumsOrder(gris : TCustomDBGridEh; columns : array of String);
    procedure CheckColumsOrderByCurrent(grid : TCustomDBGridEh);
    procedure CheckColumsOrderByOld(grid : TCustomDBGridEh);
    procedure OldAddColumnsToGrid(
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
   published
    procedure CheckCurrentWaybillTableColumnsOrder();
    procedure CheckDBGridHelperRearrangeColumns();
    procedure CheckRearrangeColumnsOnWaybills();
  end;

implementation

{ TTestWaybillGridColumn }

procedure TTestWaybillGridColumn.CheckColumsOrder(gris: TCustomDBGridEh;
  columns: array of String);
var
  I : Integer;
begin
  CheckEquals(Length(columns), gris.Columns.Count, '�� ��������� ���������� ��������');
  for I := 0 to gris.Columns.Count-1 do
    CheckTrue(AnsiSameText(gris.Columns[i].FieldName, columns[i]),
      Format('��� ������� %d ����������� ������� %s ������ %s',
        [i, gris.Columns[i].FieldName, columns[i]]));
end;

procedure TTestWaybillGridColumn.CheckColumsOrderByCurrent(
  grid: TCustomDBGridEh);
begin
  CheckColumsOrder(grid,
    ['Product', 'Producer', 'Country', 'Printed', 'Period', 'SerialNumber',
     'CertificateId', 'RequestCertificate' , 'Certificates',
    'ProducerCost', 'RegistryCost', 'SupplierPriceMarkup', 'SupplierCostWithoutNDS',
    'NDS', 'SupplierCost', 'MaxRetailMarkup', 'RetailMarkup', 'RealMarkup',
    'RetailPrice', 'Quantity', 'RetailSumm']);
end;

procedure TTestWaybillGridColumn.CheckColumsOrderByOld(
  grid: TCustomDBGridEh);
begin
  CheckColumsOrder(grid,
    ['Product', 'Printed', 'Certificates', 'SerialNumber',
    'RequestCertificate', 'CertificateId', 'Period', 'Producer', 'Country',
    'ProducerCost', 'RegistryCost', 'SupplierPriceMarkup', 'SupplierCostWithoutNDS',
    'NDS', 'SupplierCost', 'MaxRetailMarkup', 'RetailMarkup', 'RealMarkup',
    'RetailPrice', 'Quantity', 'RetailSumm']);
end;

procedure TTestWaybillGridColumn.CheckCurrentWaybillTableColumnsOrder;
var
  grid : TCustomDBGridEh;
  gui : TObject;
begin
  grid := TDBGridEh.Create(nil);
  grid.Visible := False;
  gui := GetGUIObject;
  if (gui is TTreeNode) then
    grid.Parent := TTreeNode(gui).TreeView.Parent;
  try
    TWaybillGridFactory.AddColumnsToGrid(
      grid,
      False,
      nil, nil, nil, nil, nil, nil,
      nil, nil, nil);
    CheckColumsOrderByCurrent(grid);
  finally
    grid.Free;
  end;
end;

procedure TTestWaybillGridColumn.CheckRearrangeColumnsOnWaybills;
var
  grid : TCustomDBGridEh;
  gui : TObject;
  winParent : TWinControl;
begin
  Status('CopyId: ' + GetPathCopyID());

  gui := GetGUIObject();
  winParent := nil;
  if (gui is TTreeNode) then
    winParent := TTreeNode(gui).TreeView.Parent;

  grid := TDBGridEh.Create(nil);
  grid.Visible := False;
  try
    grid.Name := 'dbgDocumentBodies';
    grid.Parent := winParent;
    OldAddColumnsToGrid(
      grid,
      False,
      nil, nil, nil, nil, nil, nil,
      nil, nil, nil);
    CheckColumsOrderByOld(grid);

    TDBGridHelper.SaveColumnsLayout(grid, TWaybillGridFactory.GetDetailWaybillSectionName(), 'TDocumentBodiesFormdbgDocumentBodies');
  finally
    grid.Free;
  end;

  TWaybillGridFactory.RearrangeColumnsOnWaybills(winParent);

  grid := TDBGridEh.Create(nil);
  grid.Visible := False;
  try
    grid.Name := 'dbgDocumentBodies';
    grid.Parent := winParent;
    OldAddColumnsToGrid(
      grid,
      False,
      nil, nil, nil, nil, nil, nil,
      nil, nil, nil);
    CheckColumsOrderByOld(grid);

    TDBGridHelper.RestoreColumnsLayout(grid, TWaybillGridFactory.GetDetailWaybillSectionName(), 'TDocumentBodiesFormdbgDocumentBodies');

    CheckColumsOrderByCurrent(grid);
  finally
    grid.Free;
  end;
end;

procedure TTestWaybillGridColumn.CheckDBGridHelperRearrangeColumns;
var
  grid : TCustomDBGridEh;
  gui : TObject;
begin
  Status('CopyId: ' + GetPathCopyID());
  grid := TDBGridEh.Create(nil);
  grid.Visible := False;
  gui := GetGUIObject;
  if (gui is TTreeNode) then
    grid.Parent := TTreeNode(gui).TreeView.Parent;
  try
    OldAddColumnsToGrid(
      grid,
      False,
      nil, nil, nil, nil, nil, nil,
      nil, nil, nil);
    CheckColumsOrderByOld(grid);
    TDBGridHelper.RearrangeColumns(grid,
      ['Product', 'Producer', 'Country', 'Printed', 'Period', 'SerialNumber',
       'CertificateId', 'RequestCertificate' , 'Certificates',
      'ProducerCost', 'RegistryCost', 'SupplierPriceMarkup', 'SupplierCostWithoutNDS',
      'NDS', 'SupplierCost', 'MaxRetailMarkup', 'RetailMarkup', 'RealMarkup',
      'RetailPrice', 'Quantity', 'RetailSumm']);
    CheckColumsOrderByCurrent(grid);
  finally
    grid.Free;
  end;
end;

procedure TTestWaybillGridColumn.OldAddColumnsToGrid(Grid: TCustomDBGridEh;
  CreatedByUser: Boolean; stringUpdateData, floatUpdateData,
  integerUpdateData, retailMarkupUpdateData, realMarkupUpdateData,
  retailPriceUpdateData: TColCellUpdateDataEventEh;
  retailMarkupGetCellParams, realMarkupGetCellParams,
  retailPriceGetCellParams: TGetColCellParamsEventEh);
var
  column : TColumnEh;
  I : Integer;
begin
  Grid.AutoFitColWidths := False;
  try
    column := TDBGridHelper.AddColumn(Grid, 'Product', '������������', 0, not CreatedByUser);
    column := TDBGridHelper.AddColumn(Grid, 'Printed', '    ��������', Grid.Canvas.TextWidth('��������'), False);
    column.Checkboxes := True;
    column := TDBGridHelper.AddColumn(Grid, 'Certificates', '����� �����������', 0, not CreatedByUser);
    column.Visible := False;
    TDBGridHelper.AddColumn(Grid, 'SerialNumber', '����� ������', 0, not CreatedByUser);
    if not CreatedByUser then begin
      column := TDBGridHelper.AddColumn(Grid, 'RequestCertificate', '��������', Grid.Canvas.TextWidth('��������'), False);
      column.Checkboxes := True;
      column := TDBGridHelper.AddColumn(Grid, 'CertificateId', '�����������', Grid.Canvas.TextWidth('�����������'), True);
    end;
    TDBGridHelper.AddColumn(Grid, 'Period', '���� ��������', 0, not CreatedByUser);
    TDBGridHelper.AddColumn(Grid, 'Producer', '�������������', 0, not CreatedByUser);
    TDBGridHelper.AddColumn(Grid, 'Country', '������', 0, not CreatedByUser);
    if CreatedByUser then begin
      column := TDBGridHelper.AddColumn(Grid, 'VitallyImportantByUser', '�����', 0, False);
      column.Checkboxes := True;
    end;
    column := TDBGridHelper.AddColumn(Grid, 'ProducerCost', '���� ������������� ��� ���', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := floatUpdateData;
    column := TDBGridHelper.AddColumn(Grid, 'RegistryCost', '���� ��', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := floatUpdateData;
    column := TDBGridHelper.AddColumn(Grid, 'SupplierPriceMarkup', '�������� ������� ��������', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := floatUpdateData;
    column := TDBGridHelper.AddColumn(Grid, 'SupplierCostWithoutNDS', '���� ���������� ��� ���', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := floatUpdateData;
    column := TDBGridHelper.AddColumn(Grid, 'NDS', '���', Grid.Canvas.TextWidth('999'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := integerUpdateData;
    column := TDBGridHelper.AddColumn(Grid, 'SupplierCost', '���� ���������� � ���', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := floatUpdateData;
    TDBGridHelper.AddColumn(Grid, 'MaxRetailMarkup', '����. ��������� �������', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    column := TDBGridHelper.AddColumn(Grid, 'RetailMarkup', '��������� �������', Grid.Canvas.TextWidth('99999.99'), False);
    column.OnUpdateData := retailMarkupUpdateData;
    column.OnGetCellParams := retailMarkupGetCellParams;
    column := TDBGridHelper.AddColumn(Grid, 'RealMarkup', '�������� �������', Grid.Canvas.TextWidth('99999.99'), False);
    column.OnUpdateData := realMarkupUpdateData;
    column.OnGetCellParams := realMarkupGetCellParams;
    column := TDBGridHelper.AddColumn(Grid, 'RetailPrice', '��������� ����', Grid.Canvas.TextWidth('99999.99'), False);
    column.OnUpdateData := retailPriceUpdateData;
    column.OnGetCellParams := retailPriceGetCellParams;
    column := TDBGridHelper.AddColumn(Grid, 'Quantity', '�����', Grid.Canvas.TextWidth('99999.99'), not CreatedByUser);
    if CreatedByUser then
      column.OnUpdateData := integerUpdateData;
    TDBGridHelper.AddColumn(Grid, 'RetailSumm', '��������� �����', Grid.Canvas.TextWidth('99999.99'));

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

initialization
  TestFramework.RegisterTest(TTestWaybillGridColumn.Suite);
end.