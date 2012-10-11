unit U_AwaitedProductsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, GridsEh, DBGridEh, ToughDBGrid, DB, MemDS,
  DBAccess, MyAccess, Buttons;

type
  TAwaitedProductsForm = class(TChildForm)
    pButtons: TPanel;
    dbgAwaitedProducts: TToughDBGrid;
    adsAwaitedProducts: TMyQuery;
    adsAwaitedProductsId: TLargeintField;
    adsAwaitedProductsCatalogId: TLargeintField;
    adsAwaitedProductsProducerId: TLargeintField;
    adsAwaitedProductsCatalogName: TStringField;
    adsAwaitedProductsProducerName: TStringField;
    dsAwaitedProducts: TDataSource;
    sbAdd: TSpeedButton;
    sbDelete: TSpeedButton;
    sbTest: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sbTestClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure dbgAwaitedProductsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure OpenAwaitedProducts;
    procedure RefreshAwaitedProducts;
    procedure DeleteAwaitedProduct;
  public
    { Public declarations }
  end;

procedure ShowAwaitedProducts;

implementation

uses
  Main,
  AlphaUtils,
  DModule,
  AProc,
  DBGridHelper;

{$R *.dfm}

procedure ShowAwaitedProducts;
begin
  MainForm.ShowChildForm(TAwaitedProductsForm);
end;

procedure TAwaitedProductsForm.FormCreate(Sender: TObject);
begin
  inherited;
  NeedFirstOnDataSet := False;

  dbgAwaitedProducts.PopupMenu := nil;

  TDBGridHelper.RestoreColumnsLayout(dbgAwaitedProducts, Self.ClassName);

  ShowForm;

  OpenAwaitedProducts;
end;

procedure TAwaitedProductsForm.OpenAwaitedProducts;
begin
  if adsAwaitedProducts.Active then
    adsAwaitedProducts.Close;
  adsAwaitedProducts.Open;
end;

procedure TAwaitedProductsForm.RefreshAwaitedProducts;
begin
  adsAwaitedProducts.Refresh;
end;

procedure TAwaitedProductsForm.sbTestClick(Sender: TObject);
begin
  inherited;
  DM.MainConnection.ExecSQL('insert into awaitedproducts (CatalogId) select Catalogs.FullCode from Catalogs where not exists(select Id from awaitedproducts ap where ap.CatalogId = Catalogs.FullCode) limit 1', []);
  RefreshAwaitedProducts;
end;

procedure TAwaitedProductsForm.FormHide(Sender: TObject);
begin
  inherited;
  TDBGridHelper.SaveColumnsLayout(dbgAwaitedProducts, Self.ClassName);
end;

procedure TAwaitedProductsForm.DeleteAwaitedProduct;
begin
  if adsAwaitedProducts.Active and not adsAwaitedProducts.IsEmpty then
    adsAwaitedProducts.Delete;
end;

procedure TAwaitedProductsForm.sbDeleteClick(Sender: TObject);
begin
  DeleteAwaitedProduct();
end;

procedure TAwaitedProductsForm.dbgAwaitedProductsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
    DeleteAwaitedProduct();
end;

end.
