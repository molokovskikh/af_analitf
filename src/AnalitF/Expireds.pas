unit Expireds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, RXDBCtrl, DModule, DB, AProc,
  Placemnt, StdCtrls, ExtCtrls, DBGridEh, ToughDBGrid, OleCtrls,
  DBProc, Constant,
  GridsEh, ActnList, MemDS, DBAccess, MyAccess, Buttons,
  DayOfWeekHelper;

type
  TExpiredsForm = class(TChildForm)
    dsExpireds: TDataSource;
    pClient: TPanel;
    dbgExpireds: TToughDBGrid;
    pRecordCount: TPanel;
    lblRecordCount: TLabel;
    Bevel1: TBevel;
    ActionList: TActionList;
    actFlipCore: TAction;
    adsAvgOrders: TMyQuery;
    adsExpireds: TMyQuery;
    adsAvgOrdersPRICEAVG: TFloatField;
    adsExpiredsCoreId: TLargeintField;
    adsExpiredsPriceCode: TLargeintField;
    adsExpiredsRegionCode: TLargeintField;
    adsExpiredsproductid: TLargeintField;
    adsExpiredsfullcode: TLargeintField;
    adsExpiredsCodeFirmCr: TLargeintField;
    adsExpiredsSynonymCode: TLargeintField;
    adsExpiredsSynonymFirmCrCode: TLargeintField;
    adsExpiredsCode: TStringField;
    adsExpiredsCodeCr: TStringField;
    adsExpiredsNote: TStringField;
    adsExpiredsPeriod: TStringField;
    adsExpiredsVolume: TStringField;
    adsExpiredsCost: TFloatField;
    adsExpiredsQuantity: TStringField;
    adsExpiredsdoc: TStringField;
    adsExpiredsregistrycost: TFloatField;
    adsExpiredsvitallyimportant: TBooleanField;
    adsExpiredsrequestratio: TIntegerField;
    adsExpiredsordercost: TFloatField;
    adsExpiredsminordercount: TIntegerField;
    adsExpiredsSynonymName: TStringField;
    adsExpiredsSynonymFirm: TStringField;
    adsExpiredsAwait: TBooleanField;
    adsExpiredsPriceName: TStringField;
    adsExpiredsDatePrice: TDateTimeField;
    adsExpiredsRegionName: TStringField;
    adsExpiredsOrdersCoreId: TLargeintField;
    adsExpiredsOrdersOrderId: TLargeintField;
    adsExpiredsOrdersClientId: TLargeintField;
    adsExpiredsOrdersFullCode: TLargeintField;
    adsExpiredsOrdersCodeFirmCr: TLargeintField;
    adsExpiredsOrdersSynonymCode: TLargeintField;
    adsExpiredsOrdersSynonymFirmCrCode: TLargeintField;
    adsExpiredsOrdersCode: TStringField;
    adsExpiredsOrdersCodeCr: TStringField;
    adsExpiredsOrdersSynonym: TStringField;
    adsExpiredsOrdersSynonymFirm: TStringField;
    adsExpiredsOrderCount: TIntegerField;
    adsExpiredsOrdersPrice: TFloatField;
    adsExpiredsSumOrder: TFloatField;
    adsExpiredsOrdersJunk: TBooleanField;
    adsExpiredsOrdersAwait: TBooleanField;
    adsExpiredsOrdersHOrderId: TLargeintField;
    adsExpiredsOrdersHClientId: TLargeintField;
    adsExpiredsOrdersHPriceCode: TLargeintField;
    adsExpiredsOrdersHRegionCode: TLargeintField;
    adsExpiredsOrdersHPriceName: TStringField;
    adsExpiredsOrdersHRegionName: TStringField;
    adsExpiredsCryptPriceRet: TCurrencyField;
    adsAvgOrdersPRODUCTID: TLargeintField;
    btnGotoCore: TSpeedButton;
    adsExpiredsRealCost: TFloatField;
    adsExpiredsSupplierPriceMarkup: TFloatField;
    adsExpiredsProducerCost: TFloatField;
    adsExpiredsNDS: TSmallintField;
    adsExpiredsMnnId: TLargeintField;
    adsExpiredsMnn: TStringField;
    btnGotoMNN: TSpeedButton;
    adsExpiredsDescriptionId: TLargeintField;
    adsExpiredsCatalogVitallyImportant: TBooleanField;
    adsExpiredsCatalogMandatoryList: TBooleanField;
    adsExpiredsMaxProducerCost: TFloatField;
    adsExpiredsBuyingMatrixType: TIntegerField;
    adsExpiredsProducerName: TStringField;
    adsExpiredsRetailVitallyImportant: TBooleanField;
    adsExpiredsMarkup: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure adsExpireds2BeforePost(DataSet: TDataSet);
    procedure dbgExpiredsCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure adsExpireds2AfterPost(DataSet: TDataSet);
    procedure dbgExpiredsSortMarkingChanged(Sender: TObject);
    procedure dbgExpiredsGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure actFlipCoreExecute(Sender: TObject);
  private
    ClientId: Integer;
    UseExcess: Boolean;
    Excess: Integer;

    procedure ecf(DataSet: TDataSet);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Main, NamesForms, U_framePosition, DBGridHelper;

procedure TExpiredsForm.FormCreate(Sender: TObject);
begin
  pRecordCount.ControlStyle := pRecordCount.ControlStyle - [csParentBackground] + [csOpaque];
  dsCheckVolume := adsExpireds;
  dgCheckVolume := dbgExpireds;
  fOrder := adsExpiredsORDERCOUNT;
  fVolume := adsExpiredsREQUESTRATIO;
  fOrderCost := adsExpiredsORDERCOST;
  fSumOrder := adsExpiredsSumOrder;
  fMinOrderCount := adsExpiredsMINORDERCOUNT;
  fBuyingMatrixType := adsExpiredsBuyingMatrixType;
  gotoMNNButton := btnGotoMNN;
  inherited;
  TframePosition.AddFrame(Self, pClient, dsExpireds, 'SynonymName', 'MnnId', ShowDescriptionAction);
  adsExpireds.OnCalcFields := ecf;
  ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
  UseExcess := True;
  Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
  adsAvgOrders.ParamByName('ClientId').Value := ClientId;
  adsExpireds.ParamByName( 'ClientId').Value := ClientId;
  adsExpireds.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
  adsExpireds.ParamByName( 'DayOfWeek').Value := TDayOfWeekHelper.DayOfWeek();
  Screen.Cursor := crHourGlass;
  try
    adsExpireds.Open;
    adsAvgOrders.Open;
  finally
    Screen.Cursor := crDefault;
  end;
  lblRecordCount.Caption := Format( lblRecordCount.Caption, [adsExpireds.RecordCount]);
  TDBGridHelper.RestoreColumnsLayout(dbgExpireds, Self.ClassName);
  if dbgExpireds.SortMarkedColumns.Count = 0 then
    dbgExpireds.FieldColumns['SYNONYMNAME'].Title.SortMarker := smUpEh;
  ShowForm;
  adsExpireds.First;
end;

procedure TExpiredsForm.FormDestroy(Sender: TObject);
begin
  TDBGridHelper.SaveColumnsLayout(dbgExpireds, Self.ClassName);
end;

procedure TExpiredsForm.ecf(DataSet: TDataSet);
begin
  try
    if FAllowDelayOfPayment and not FShowSupplierCost then
      adsExpiredsCryptPriceRet.AsCurrency :=
        DM.GetRetailCostLast(
          adsExpiredsRetailVitallyImportant.Value,
          adsExpiredsCost.AsCurrency,
          adsExpiredsMarkup.AsVariant)
    else
      adsExpiredsCryptPriceRet.AsCurrency :=
        DM.GetRetailCostLast(
          adsExpiredsRetailVitallyImportant.Value,
          adsExpiredsRealCost.AsCurrency,
          adsExpiredsMarkup.AsVariant);
  except
  end;
end;

procedure TExpiredsForm.adsExpireds2BeforePost(DataSet: TDataSet);
var
  Quantity, E: Integer;
  PriceAvg: Double;
  PanelCaption : String;
  PanelHeight : Integer;
begin
  try
    { проверяем заказ на соответствие наличию товара на складе }
    Val( adsExpiredsQuantity.AsString, Quantity, E);
    if E <> 0 then Quantity := 0;
    if ( Quantity > 0) and ( adsExpiredsORDERCOUNT.AsInteger > Quantity)
    then begin
      AProc.MessageBox(
        'Заказ превышает остаток на складе, товар будет заказан в количестве ' + adsExpiredsQuantity.AsString,
        MB_ICONWARNING);
      adsExpiredsORDERCOUNT.AsInteger := Quantity;
    end;

    PanelCaption := '';

    if (adsExpiredsBuyingMatrixType.Value > 0) and (adsExpiredsORDERCOUNT.AsInteger > 0)
    then begin
      if (adsExpiredsBuyingMatrixType.Value = 1) then begin
        PanelCaption := DisableProductOrderMessage;

        ShowOverCostPanel(PanelCaption, dbgExpireds);

        Abort;
      end;
    end;

    { проверяем на превышение цены }
    if UseExcess and ( adsExpiredsORDERCOUNT.AsInteger > 0) and (not adsAvgOrdersPRODUCTID.IsNull) then
    begin
      PriceAvg := adsAvgOrdersPRICEAVG.AsCurrency;
      if ( PriceAvg > 0) and ( adsExpiredsCOST.AsCurrency>PriceAvg*(1+Excess/100)) then
      begin
        if Length(PanelCaption) > 0 then
          PanelCaption := PanelCaption + #13#10 + ExcessAvgCostMessage
        else
          PanelCaption := ExcessAvgCostMessage;
      end;
    end;

    if Length(PanelCaption) > 0 then
      PanelCaption := PanelCaption + #13#10 + OrderJunkMessage
    else
      PanelCaption := OrderJunkMessage;

    if (adsExpiredsORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + WarningOrderCountMessage
      else
        PanelCaption := WarningOrderCountMessage;

    if Length(PanelCaption) > 0 then
      ShowOverCostPanel(PanelCaption, dbgExpireds);

  except
    adsExpireds.Cancel;
    raise;
  end;
end;

procedure TExpiredsForm.dbgExpiredsCanInput(Sender: TObject;
  Value: Integer; var CanInput: Boolean);
begin
  CanInput :=
    (not adsExpireds.IsEmpty)
    and ((adsExpiredsRegionCode.AsLargeInt and DM.adtClientsREQMASK.AsLargeInt)
      = adsExpiredsRegionCode.AsLargeInt);
  if not CanInput then exit;
end;

procedure TExpiredsForm.adsExpireds2AfterPost(DataSet: TDataSet);
begin
  MainForm.SetOrdersInfo;
end;

procedure TExpiredsForm.dbgExpiredsSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TExpiredsForm.dbgExpiredsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if adsExpiredsVITALLYIMPORTANT.AsBoolean then
    AFont.Color := VITALLYIMPORTANT_CLR;

  //уцененный товар
  if (( Column.Field = adsExpiredsPERIOD) or ( Column.Field = adsExpiredsCOST))
  then Background := JUNK_CLR;
end;

procedure TExpiredsForm.actFlipCoreExecute(Sender: TObject);
var
  FullCode, ShortCode: integer;
  CoreId : Int64;
begin
  if MainForm.ActiveChild <> Self then exit;
  if adsExpireds.IsEmpty then Exit;

  FullCode := adsExpiredsFullCode.AsInteger;
  ShortCode := DM.QueryValue('select ShortCode from catalogs where FullCode = ' + IntToStr(FullCode), [] , []);

  CoreId := adsExpiredsCOREID.AsLargeInt;

  FlipToCodeWithReturn(FullCode, ShortCode, CoreId);
end;

end.
