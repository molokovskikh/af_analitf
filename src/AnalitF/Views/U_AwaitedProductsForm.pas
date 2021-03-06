unit U_AwaitedProductsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, GridsEh, DBGridEh, ToughDBGrid, DB, MemDS,
  DBAccess, MyAccess, Buttons, StrHlder,
  Constant,
  StrUtils,
  U_framePosition,
  ActnList,
  U_frameLegend, StdCtrls, DBCtrls;

type
  TAwaitedProductsForm = class(TChildForm)
    pButtons: TPanel;
    adsAwaitedProducts: TMyQuery;
    adsAwaitedProductsId: TLargeintField;
    adsAwaitedProductsCatalogId: TLargeintField;
    adsAwaitedProductsProducerId: TLargeintField;
    adsAwaitedProductsCatalogName: TStringField;
    adsAwaitedProductsProducerName: TStringField;
    dsAwaitedProducts: TDataSource;
    sbAdd: TSpeedButton;
    sbDelete: TSpeedButton;
    shCore: TStrHolder;
    shCoreUpdate: TStrHolder;
    shCoreRefresh: TStrHolder;
    pBottom: TPanel;
    tmrUpdateOffers: TTimer;
    adsAwaitedProductsCoreExists: TBooleanField;
    pGrid: TPanel;
    dbgAwaitedProducts: TToughDBGrid;
    adsAwaitedProductsDescriptionId: TLargeintField;
    adsAwaitedProductsMnnId: TLargeintField;
    adsAwaitedProductsCatalogVitallyImportant: TBooleanField;
    adsAwaitedProductsCatalogMandatoryList: TBooleanField;
    adsAwaitedProductsFullCode: TLargeintField;
    ActionList: TActionList;
    pPreviousOrders: TPanel;
    pCore: TPanel;
    dbgCore: TToughDBGrid;
    gbPrevOrders: TGroupBox;
    dbgHistory: TToughDBGrid;
    gbFirmInfo: TGroupBox;
    lblSupportPhone: TLabel;
    dbtSupportPhone: TDBText;
    dbmContactInfo: TDBMemo;
    dsPreviosOrders: TDataSource;
    adsPreviosOrders: TMyQuery;
    adsPreviosOrdersFullCode: TLargeintField;
    adsPreviosOrdersCode: TStringField;
    adsPreviosOrdersCodeCR: TStringField;
    adsPreviosOrdersSynonymName: TStringField;
    adsPreviosOrdersSynonymFirm: TStringField;
    adsPreviosOrdersOrderCount: TIntegerField;
    adsPreviosOrdersOrderDate: TDateTimeField;
    adsPreviosOrdersPriceName: TStringField;
    adsPreviosOrdersRegionName: TStringField;
    adsPreviosOrdersPrice: TFloatField;
    adsPreviosOrdersAwait: TBooleanField;
    adsPreviosOrdersJunk: TBooleanField;
    adsPreviosOrdersPeriod: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure dbgAwaitedProductsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure dbgCoreEnter(Sender: TObject);
    procedure dbgCoreExit(Sender: TObject);
    procedure dbgAwaitedProductsEnter(Sender: TObject);
    procedure dbgAwaitedProductsExit(Sender: TObject);
    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmrUpdateOffersTimer(Sender: TObject);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure sbAddClick(Sender: TObject);
    procedure dbgAwaitedProductsGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
  private
    { Private declarations }
    procedure OpenAwaitedProducts;
    procedure RefreshAwaitedProducts;
    procedure DeleteAwaitedProduct;
    procedure CreateNonVisualComponent;
    procedure CreateVisualComponent;
    procedure AddCoreFields;
    procedure adsCoreCalcFields(DataSet: TDataSet);
    procedure adsCoreAfterPost(DataSet: TDataSet);
    procedure adsCoreBeforeEdit(DataSet: TDataSet);
    procedure adsCoreBeforePost(DataSet: TDataSet);

    procedure UpdateOffers(DataSet: TDataSet);
    procedure UpdateGridOnLegend(Sender : TObject);
  public
    { Public declarations }
    adsCore : TMyQuery;
    dsCore : TDataSource;

    //���� ��� Core
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
    adsCoreExp: TDateField;
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

    adsCoreSupportPhone : TStringField;
    adsCoreOperativeInfo : TMemoField;

    framePosition : TframePosition;
    frameLegend : TframeLegend;
    procedure Print( APreview: boolean = False); override;
  end;

procedure ShowAwaitedProducts;

implementation

uses
  Main,
  AlphaUtils,
  DModule,
  AProc,
  DBProc,
  DBGridHelper,
  DayOfWeekHelper,
  DataSetHelper,
  U_LegendHolder,
  U_AddAwaitedProducts;

{$R *.dfm}

procedure ShowAwaitedProducts;
begin
  MainForm.ShowChildForm(TAwaitedProductsForm);
end;

procedure TAwaitedProductsForm.FormCreate(Sender: TObject);
begin
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
  NeedFirstOnDataSet := False;

  frameLegend := TframeLegend.CreateFrame(Self, True, False, True);
  frameLegend.Parent := pCore;
  frameLegend.Align := alBottom;
  frameLegend.UpdateGrids := UpdateGridOnLegend;

  framePosition := TframePosition.AddFrame(Self, pGrid, dsAwaitedProducts, 'CatalogName', 'MnnId', ShowDescriptionAction);
  dbgAwaitedProducts.PopupMenu := nil;
  dbgCore.DataSource := dsCore;
  dbtSupportPhone.DataSource := dsCore;
  dbmContactInfo.DataSource := dsCore;

  TDBGridHelper.RestoreColumnsLayout(dbgAwaitedProducts, Self.ClassName);
  TDBGridHelper.RestoreColumnsLayout(dbgCore, Self.ClassName);

  ShowForm;

  OpenAwaitedProducts;
end;

procedure TAwaitedProductsForm.OpenAwaitedProducts;
begin
  adsPreviosOrders.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  adsPreviosOrders.ParamByName( 'GroupByProducts').Value := DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean;
  if adsAwaitedProducts.Active then
    adsAwaitedProducts.Close;
  adsAwaitedProducts.Open;
  if not adsAwaitedProducts.Locate('CoreExists', True, []) then
    adsAwaitedProducts.First;
end;

procedure TAwaitedProductsForm.RefreshAwaitedProducts;
begin
  adsAwaitedProducts.Refresh;
end;

procedure TAwaitedProductsForm.FormHide(Sender: TObject);
begin
  inherited;
  TDBGridHelper.SaveColumnsLayout(dbgAwaitedProducts, Self.ClassName);
  TDBGridHelper.SaveColumnsLayout(dbgCore, Self.ClassName);
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
  if Key = VK_RETURN then
    dbgCore.SetFocus();
end;

procedure TAwaitedProductsForm.FormResize(Sender: TObject);
begin
  pBottom.Height := Self.Height div 2;
end;

procedure TAwaitedProductsForm.CreateNonVisualComponent;
begin
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

  adsAwaitedProducts.AfterOpen := UpdateOffers;
  adsAwaitedProducts.AfterScroll := UpdateOffers;
end;

procedure TAwaitedProductsForm.CreateVisualComponent;
var
  column : TColumnEh;
begin
  TDBGridHelper.AddColumn(dbgCore, 'SynonymName', '������������ � ����������', 196);
  TDBGridHelper.AddColumn(dbgCore, 'SynonymFirm', '�������������', 85);
  column := TDBGridHelper.AddColumn(dbgCore, 'ProducerName', '���.�������������', 50);
  column.Visible := False;
  TDBGridHelper.AddColumn(dbgCore, 'Volume', '��������', 30);
  TDBGridHelper.AddColumn(dbgCore, 'Note', '����������', 30);
  column := TDBGridHelper.AddColumn(dbgCore, 'Doc', '��������');
  column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Exp', '���� ����.', 85);
  column.Alignment := taCenter;
  TDBGridHelper.AddColumn(dbgCore, 'PriceName', '�����-����', 85);
  column := TDBGridHelper.AddColumn(dbgCore, 'RegionName', '������', 72);
  column.Visible := False;
{
  column := TDBGridHelper.AddColumn(dbgCore, 'Storage', '�����', 37);
  column.Alignment := taCenter;
  column.Visible := False;
  column.Checkboxes := False;
}
  TDBGridHelper.AddColumn(dbgCore, 'DatePrice', '���� �����-�����', 'dd.mm.yyyy hh:nn', 103);
  TDBGridHelper.AddColumn(dbgCore, 'requestratio', '���������', 20);
  TDBGridHelper.AddColumn(dbgCore, 'ordercost', '���.�����', '0.00;;''''', 20);
  TDBGridHelper.AddColumn(dbgCore, 'minordercount', '���.���-��', 20);
  TDBGridHelper.AddColumn(dbgCore, 'registrycost', '������.����', '0.00;;''''', 20);

  TDBGridHelper.AddColumn(dbgCore, 'MaxProducerCost', '����.�����.����', '0.00;;''''', 30);
  TDBGridHelper.AddColumn(dbgCore, 'ProducerCost', '���� �������������', '0.00;;''''', 30);
  TDBGridHelper.AddColumn(dbgCore, 'SupplierPriceMarkup', '������� ����������', '0.00;;''''', 30);
  TDBGridHelper.AddColumn(dbgCore, 'NDS', '���', 20);

  //������� ������� "���� ��� ��������", ���� �� ������� �������� � ��������� �������
  if FAllowDelayOfPayment
     and FShowSupplierCost
  then
    column := TDBGridHelper.AddColumn(dbgCore, 'RealCost', '���� ����������', 30);
  //column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Cost', '����', '0.00;;''''', 55);
  column.Font.Style := [fsBold];
  column := TDBGridHelper.AddColumn(dbgCore, 'PriceRet', '����.����', '0.00;;''''', 62);
  column.Visible := False;
  column := TDBGridHelper.AddColumn(dbgCore, 'Quantity', '�������', 68);
  column.Alignment := taRightJustify;
  {
  column := TDBGridHelper.AddColumn(dbgCore, 'OrderCount', '�����', 47);
  column.Color := TColor(16775406);
  column := TDBGridHelper.AddColumn(dbgCore, 'SumOrder', '�����', '0.00;;''''', 70);
  column.Color := TColor(16775406);
  }
  column := TDBGridHelper.AddColumn(dbgCore, 'OrderCount', '�����', 47);
  column.Color := TColor(16775406);
  column := TDBGridHelper.AddColumn(dbgCore, 'SumOrder', '�����', '0.00;;''''', 70);
  column.Color := TColor(16775406);

  dbgCore.InputField := 'OrderCount';
end;

procedure TAwaitedProductsForm.AddCoreFields;
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
  adsCoreExp := TDataSetHelper.AddDateField(adsCore, 'Exp');
  adsCoreVolume := TDataSetHelper.AddStringField(adsCore, 'Volume');
  adsCoreNote := TDataSetHelper.AddStringField(adsCore, 'Note', 100);
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

  adsCoreSupportPhone := TDataSetHelper.AddStringField(adsCore, 'SupportPhone');
  adsCoreOperativeInfo := TDataSetHelper.AddMemoField(adsCore, 'OperativeInfo');
end;

procedure TAwaitedProductsForm.adsCoreAfterPost(DataSet: TDataSet);
begin
  MainForm.SetOrdersInfo;
end;

procedure TAwaitedProductsForm.adsCoreBeforeEdit(DataSet: TDataSet);
begin
  if adsCoreFirmCode.AsInteger = RegisterId then Abort;
end;

procedure TAwaitedProductsForm.adsCoreBeforePost(DataSet: TDataSet);
var
  Quantity, E: Integer;
  PriceAvg,
  OrderCountAvg: Double;
  PanelCaption : String;
begin
  try
    { ��������� ����� �� ������������ ������� ������ �� ������ }
    Val( adsCoreQuantity.AsString,Quantity,E);
    if E<>0 then Quantity := 0;
    if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity)
    then begin
      AProc.MessageBox(
        '����� ��������� ������� �� ������, ����� ����� ������� � ���������� ' + adsCoreQuantity.AsString,
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

    { ��������� �� ���������� ���� }
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
    { ��������� �� ���������� ����������� ���������� }
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

    if DM.ExistsInFrozenOrders(adsCoreProductid.Value) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + WarningLikeFrozenMessage
      else
        PanelCaption := WarningLikeFrozenMessage;

    if Length(PanelCaption) > 0 then
      ShowOverCostPanel(PanelCaption, dbgCore);

  except
    adsCore.Cancel;
    raise;
  end;
end;

procedure TAwaitedProductsForm.adsCoreCalcFields(DataSet: TDataSet);
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

procedure TAwaitedProductsForm.dbgCoreEnter(Sender: TObject);
begin
  PrintEnabled := (DM.SaveGridMask and PrintCombinedPrice) > 0;
end;

procedure TAwaitedProductsForm.dbgCoreExit(Sender: TObject);
begin
  PrintEnabled := False;
end;

procedure TAwaitedProductsForm.dbgAwaitedProductsEnter(Sender: TObject);
begin
  PrintEnabled := True;
end;

procedure TAwaitedProductsForm.dbgAwaitedProductsExit(Sender: TObject);
begin
  PrintEnabled := False;
end;

procedure TAwaitedProductsForm.dbgCoreKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    dbgAwaitedProducts.SetFocus();
end;

procedure TAwaitedProductsForm.tmrUpdateOffersTimer(Sender: TObject);
begin
  tmrUpdateOffers.Enabled := False;
  if adsPreviosOrders.Active then
    adsPreviosOrders.Close;
  if adsCore.Active then
    adsCore.Close;
  if adsAwaitedProducts.Active and not adsAwaitedProducts.IsEmpty
  then begin
    adsPreviosOrders.ParamByName( 'GroupByProducts').Value := False;
    adsPreviosOrders.ParamByName( 'FullCode').Value := adsAwaitedProductsCatalogId.Value;
    adsPreviosOrders.ParamByName( 'ProductId').Value := adsAwaitedProductsCatalogId.Value;
    adsPreviosOrders.Open;
    adsCore.ParamByName( 'CatalogId').Value := adsAwaitedProductsCatalogId.Value;
    adsCore.Open;
    if not adsAwaitedProductsProducerId.IsNull
      and not adsCore.Locate('CodeFirmCr', adsAwaitedProductsProducerId.Value, [])
    then
      adsCore.First;
  end;
end;

procedure TAwaitedProductsForm.UpdateOffers(DataSet: TDataSet);
begin
  tmrUpdateOffers.Enabled := False;
  tmrUpdateOffers.Enabled := True;
end;

procedure TAwaitedProductsForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not adsCore.IsEmpty then begin
    if adsCore.FieldByName('vitallyimportant').AsBoolean then
      AFont.Color := LegendHolder.Legends[lnVitallyImportant];
    //���� ��������� �����, �������� ����
    if adsCore.FieldByName('Junk').AsBoolean and (AnsiIndexText(Column.FieldName, ['Exp', 'Cost']) > -1)
    then
      Background := LegendHolder.Legends[lnJunk];
    //��������� ����� �������� �������
    if adsCore.FieldByName('Await').AsBoolean and AnsiSameText(Column.FieldName, 'SynonymName') then
      Background := LegendHolder.Legends[lnAwait];
  end;
end;

procedure TAwaitedProductsForm.sbAddClick(Sender: TObject);
var
  AddAwaitedProducts: TAddAwaitedProducts;
  lastId : Variant;
begin
  AddAwaitedProducts := TAddAwaitedProducts.Create(Application);
  try
    if AddAwaitedProducts.ShowModal = mrOk then begin

      lastId := DBProc.QueryValue(
        DM.MainConnection,
        'insert into awaitedproducts (CatalogId, ProducerId) values (:CatalogId, :ProducerId);' +
        'select last_insert_id();',
        ['CatalogId', 'ProducerId'],
        [AddAwaitedProducts.SelectedCatalogId,
        AddAwaitedProducts.SelectedProducerId]);

      RefreshAwaitedProducts;

      if not adsAwaitedProducts.Locate('Id', lastId, []) then
        adsAwaitedProducts.First;
    end;
  finally
    FreeAndNil(AddAwaitedProducts);
  end;
end;

procedure TAwaitedProductsForm.dbgAwaitedProductsGetCellParams(
  Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not adsAwaitedProductsCoreExists.Value then
    Background := clSilver;
end;

procedure TAwaitedProductsForm.UpdateGridOnLegend(Sender: TObject);
begin
  dbgCore.Invalidate;
end;

procedure TAwaitedProductsForm.dbgCoreCanInput(Sender: TObject;
  Value: Integer; var CanInput: Boolean);
begin
  CanInput := (not adsCore.IsEmpty) and ( adsCoreSynonymCode.AsInteger >= 0) and
    (( adsCoreRegionCode.AsLargeInt and DM.adtClientsREQMASK.AsLargeInt) =
      adsCoreRegionCode.AsLargeInt);
end;

procedure TAwaitedProductsForm.Print(APreview: boolean);
begin
  if dbgAwaitedProducts.Focused and adsAwaitedProducts.Active then
    DM.ShowFastReport('Awaited.frf', adsAwaitedProducts, APreview);
end;

end.
