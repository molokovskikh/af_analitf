unit U_frameMatchWaybill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, GridsEh, DBGridEh, StdCtrls, DBCtrls, DB, MemDS,
  DBAccess, MyAccess,
  DBGridHelper;

type
  TframeMatchWaybill = class(TFrame)
    pNotFound: TPanel;
    pGrid: TPanel;
    pOrderHeader: TPanel;
    dbtProviderName: TDBText;
    Label1: TLabel;
    dbtId: TDBText;
    Label2: TLabel;
    dbtOrderDate: TDBText;
    lblRecordCount: TLabel;
    dbtPositions: TDBText;
    Label4: TLabel;
    lProviderDocumentId: TLabel;
    dbtProviderDocumentId: TDBText;
    dbgWaybill: TDBGridEh;
    Label3: TLabel;
    dsDocumentBodies: TDataSource;
    adsDocumentBodies: TMyQuery;
    adsDocumentBodiesId: TLargeintField;
    adsDocumentBodiesDocumentId: TLargeintField;
    adsDocumentBodiesProduct: TStringField;
    adsDocumentBodiesCode: TStringField;
    adsDocumentBodiesCertificates: TStringField;
    adsDocumentBodiesPeriod: TStringField;
    adsDocumentBodiesProducer: TStringField;
    adsDocumentBodiesCountry: TStringField;
    adsDocumentBodiesProducerCost: TFloatField;
    adsDocumentBodiesRegistryCost: TFloatField;
    adsDocumentBodiesSupplierPriceMarkup: TFloatField;
    adsDocumentBodiesSupplierCostWithoutNDS: TFloatField;
    adsDocumentBodiesSupplierCost: TFloatField;
    adsDocumentBodiesQuantity: TIntegerField;
    adsDocumentBodiesVitallyImportant: TBooleanField;
    adsDocumentBodiesSerialNumber: TStringField;
    adsDocumentBodiesPrinted: TBooleanField;
    adsDocumentBodiesAmount: TFloatField;
    adsDocumentBodiesNdsAmount: TFloatField;
    adsDocumentBodiesUnit: TStringField;
    adsDocumentBodiesExciseTax: TFloatField;
    adsDocumentBodiesBillOfEntryNumber: TStringField;
    adsDocumentBodiesEAN13: TStringField;
    adsDocumentBodiesRequestCertificate: TBooleanField;
    adsDocumentBodiesCertificateId: TLargeintField;
    adsDocumentBodiesDocumentBodyId: TLargeintField;
    adsDocumentBodiesServerId: TLargeintField;
    adsDocumentBodiesServerDocumentId: TLargeintField;
    adsDocumentBodiesCatalogMarkup: TFloatField;
    adsDocumentBodiesCatalogMaxMarkup: TFloatField;
    adsDocumentBodiesCatalogMaxSupplierMarkup: TFloatField;
    tmrShowMatchWaybill: TTimer;
    adsDocumentHeaders: TMyQuery;
    adsDocumentHeadersId: TLargeintField;
    adsDocumentHeadersDownloadId: TLargeintField;
    adsDocumentHeadersWriteTime: TDateTimeField;
    adsDocumentHeadersFirmCode: TLargeintField;
    adsDocumentHeadersClientId: TLargeintField;
    adsDocumentHeadersDocumentType: TWordField;
    adsDocumentHeadersProviderDocumentId: TStringField;
    adsDocumentHeadersOrderId: TLargeintField;
    adsDocumentHeadersHeader: TStringField;
    adsDocumentHeadersProviderName: TStringField;
    adsDocumentHeadersPositions: TLargeintField;
    adsDocumentHeadersLocalWriteTime: TDateTimeField;
    adsDocumentHeadersCreatedByUser: TBooleanField;
    dsDocumentHeaders: TDataSource;
    procedure tmrShowMatchWaybillTimer(Sender: TObject);
  private
    { Private declarations }
    FOrders : TMyQuery;
    FOrdersServerDocumentId : TLargeintField;
    FOrdersServerDocumentLineId : TLargeintField;

    procedure CreateVisualComponent;
    procedure CreateNonVisualComponent;

    procedure SetWaybillByPosition;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure PrepareFrame;
    class function AddFrame(
      Owner: TComponent;
      Parent: TWinControl;
      AOrders : TMyQuery) : TframeMatchWaybill;
    procedure UpdateMatchWaybillTimer;
  end;

implementation

uses DModule;

{$R *.dfm}

{ TframeMatchWaybill }

class function TframeMatchWaybill.AddFrame(Owner: TComponent;
  Parent: TWinControl;
  AOrders : TMyQuery): TframeMatchWaybill;
begin
  Result := TframeMatchWaybill.Create(Owner);
  Result.Parent := Parent;
  Result.FOrders := AOrders;
  Result.PrepareFrame;
end;

constructor TframeMatchWaybill.Create(AOwner: TComponent);
begin
  inherited;

  CreateNonVisualComponent;
  CreateVisualComponent;

  pNotFound.ControlStyle := pNotFound.ControlStyle - [csParentBackground] + [csOpaque];
  pGrid.ControlStyle := pGrid.ControlStyle - [csParentBackground] + [csOpaque];
  pOrderHeader.ControlStyle := pOrderHeader.ControlStyle - [csParentBackground] + [csOpaque];
  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframeMatchWaybill.CreateNonVisualComponent;
begin

end;

procedure TframeMatchWaybill.CreateVisualComponent;
var
  column : TColumnEh;
begin
  TDBGridHelper.SetDefaultSettingsToGrid(dbgWaybill);

  dbgWaybill.AutoFitColWidths := False;
  try
    column := TDBGridHelper.AddColumn(dbgWaybill, 'Product', 'Наименование', 0);
    TDBGridHelper.AddColumn(dbgWaybill, 'SerialNumber', 'Серия товара', 0);
    TDBGridHelper.AddColumn(dbgWaybill, 'Period', 'Срок годности', 0);
    TDBGridHelper.AddColumn(dbgWaybill, 'Producer', 'Производитель', 0);
    TDBGridHelper.AddColumn(dbgWaybill, 'Country', 'Страна', 0);
    column := TDBGridHelper.AddColumn(dbgWaybill, 'ProducerCost', 'Цена производителя без НДС', dbgWaybill.Canvas.TextWidth('99999.99'));
    column := TDBGridHelper.AddColumn(dbgWaybill, 'RegistryCost', 'Цена ГР', dbgWaybill.Canvas.TextWidth('99999.99'));
    column := TDBGridHelper.AddColumn(dbgWaybill, 'SupplierPriceMarkup', 'Торговая наценка оптовика', dbgWaybill.Canvas.TextWidth('99999.99'));
    column := TDBGridHelper.AddColumn(dbgWaybill, 'SupplierCostWithoutNDS', 'Цена поставщика без НДС', dbgWaybill.Canvas.TextWidth('99999.99'));
    column := TDBGridHelper.AddColumn(dbgWaybill, 'NDS', 'НДС', dbgWaybill.Canvas.TextWidth('999'));
    column := TDBGridHelper.AddColumn(dbgWaybill, 'SupplierCost', 'Цена поставщика с НДС', dbgWaybill.Canvas.TextWidth('99999.99'));
    column.Font.Style := column.Font.Style + [fsBold]; 
    column := TDBGridHelper.AddColumn(dbgWaybill, 'Quantity', 'Заказ', dbgWaybill.Canvas.TextWidth('99999.99'));
  finally
    dbgWaybill.AutoFitColWidths := True;
  end;

  dbgWaybill.ReadOnly := False;

  dbgWaybill.DataSource := dsDocumentBodies;
end;

procedure TframeMatchWaybill.PrepareFrame;
begin
  adsDocumentBodies.Connection := DM.MainConnection;
  adsDocumentHeaders.Connection := DM.MainConnection;
  FOrdersServerDocumentId := TLargeintField(FOrders.FindField('ServerDocumentId'));
  FOrdersServerDocumentLineId := TLargeintField(FOrders.FindField('ServerDocumentLineId'));
end;

procedure TframeMatchWaybill.SetWaybillByPosition;
begin
  if adsDocumentBodies.Active then
    adsDocumentBodies.Close;

  if adsDocumentHeaders.Active then
    adsDocumentHeaders.Close;

  if FOrders.Active and not FOrders.IsEmpty and not FOrdersServerDocumentId.IsNull
  then begin
    adsDocumentHeaders.ParamByName('ServerDocumentId').Value := FOrdersServerDocumentId.Value;
    adsDocumentHeaders.Open;
    adsDocumentBodies.ParamByName('ServerDocumentId').Value := FOrdersServerDocumentId.Value;
    adsDocumentBodies.Open;
    if not adsDocumentBodies.Locate('ServerId', FOrdersServerDocumentLineId.AsVariant, []) then
      adsDocumentBodies.First;
  end;

  if adsDocumentBodies.Active and not adsDocumentBodies.IsEmpty then begin
    pNotFound.Visible := False;
    pGrid.Visible := True;
  end
  else begin
    pNotFound.Visible := True;
    pGrid.Visible := False;
  end;
end;

procedure TframeMatchWaybill.tmrShowMatchWaybillTimer(Sender: TObject);
begin
  tmrShowMatchWaybill.Enabled := False;
  SetWaybillByPosition;
end;

procedure TframeMatchWaybill.UpdateMatchWaybillTimer;
begin
  tmrShowMatchWaybill.Enabled := False;
  tmrShowMatchWaybill.Enabled := True;
end;

end.
