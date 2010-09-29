unit Expireds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, RXDBCtrl, DModule, DB, AProc,
  Placemnt, StdCtrls, ExtCtrls, DBGridEh, ToughDBGrid, OleCtrls,
  SHDocVw, DBProc, Constant,
  GridsEh, ActnList, MemDS, DBAccess, MyAccess, Buttons;

type
  TExpiredsForm = class(TChildForm)
    dsExpireds: TDataSource;
    Timer: TTimer;
    pClient: TPanel;
    dbgExpireds: TToughDBGrid;
    pRecordCount: TPanel;
    lblRecordCount: TLabel;
    Bevel1: TBevel;
    pWebBrowser: TPanel;
    Bevel2: TBevel;
    WebBrowser1: TWebBrowser;
    ActionList: TActionList;
    actFlipCore: TAction;
    plOverCost: TPanel;
    lWarning: TLabel;
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
    procedure FormCreate(Sender: TObject);
    procedure adsExpireds2BeforePost(DataSet: TDataSet);
    procedure dbgExpiredsCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure adsExpireds2AfterPost(DataSet: TDataSet);
    procedure adsExpireds2AfterScroll(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
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
  plOverCost.Hide();
  dsCheckVolume := adsExpireds;
  dgCheckVolume := dbgExpireds;
  fOrder := adsExpiredsORDERCOUNT;
  fVolume := adsExpiredsREQUESTRATIO;
  fOrderCost := adsExpiredsORDERCOST;
  fSumOrder := adsExpiredsSumOrder;
  fMinOrderCount := adsExpiredsMINORDERCOUNT;
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
    adsExpiredsCryptPriceRet.AsCurrency := DM.GetPriceRet(adsExpiredsCOST.AsCurrency);
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
    if ( Quantity > 0) and ( adsExpiredsORDERCOUNT.AsInteger > Quantity)and
      (AProc.MessageBox('Заказ превышает остаток на складе. Продолжить?',
      MB_ICONQUESTION or MB_OKCANCEL) <> IDOK) then adsExpiredsORDERCOUNT.AsInteger := Quantity;

    PanelCaption := '';

    if (adsExpiredsBuyingMatrixType.Value > 0) then begin
      if (adsExpiredsBuyingMatrixType.Value = 1) then begin
        PanelCaption := 'Препарат запрещен к заказу.';

        begin
        if Timer.Enabled then
          Timer.OnTimer(nil);

        lWarning.Caption := PanelCaption;
        PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
        plOverCost.Height := PanelHeight*WordCount(PanelCaption, [#13, #10]) + 20;

        plOverCost.Top := ( dbgExpireds.Height - plOverCost.Height) div 2;
        plOverCost.Left := ( dbgExpireds.Width - plOverCost.Width) div 2;
        plOverCost.BringToFront;
        plOverCost.Show;
        Timer.Enabled := True;
        end;

        Abort;
      end
      else begin
        //PanelCaption := 'Препарат не желателен к заказу';
        if AProc.MessageBox(
            'Препарат не входит в разрешенную матрицу закупок.'#13#10 +
            'Вы действительно хотите заказать его?',
             MB_ICONWARNING or MB_OKCANCEL) = ID_CANCEL
        then
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
          PanelCaption := PanelCaption + #13#10 + 'Превышение средней цены!'
        else
          PanelCaption := 'Превышение средней цены!';
      end;
    end;

    if Length(PanelCaption) > 0 then
      PanelCaption := PanelCaption + #13#10 + 'Вы заказали некондиционный препарат.'
    else
      PanelCaption := 'Вы заказали некондиционный препарат.';

    if (adsExpiredsORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + 'Внимание! Вы заказали большое количество препарата.'
      else
        PanelCaption := 'Внимание! Вы заказали большое количество препарата.';

    if Length(PanelCaption) > 0 then begin
      if Timer.Enabled then
        Timer.OnTimer(nil);

      lWarning.Caption := PanelCaption;
      PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
      plOverCost.Height := PanelHeight*WordCount(PanelCaption, [#13, #10]) + 20;

      plOverCost.Top := ( dbgExpireds.Height - plOverCost.Height) div 2;
      plOverCost.Left := ( dbgExpireds.Width - plOverCost.Width) div 2;
      plOverCost.BringToFront;
      plOverCost.Show;
      Timer.Enabled := True;
    end;

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

procedure TExpiredsForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  plOverCost.Hide;
  plOverCost.SendToBack;
end;

procedure TExpiredsForm.adsExpireds2AfterPost(DataSet: TDataSet);
begin
  MainForm.SetOrdersInfo;
end;

procedure TExpiredsForm.adsExpireds2AfterScroll(DataSet: TDataSet);
//var
//  C : Integer;
begin
{
  C := dbgExpireds.Canvas.TextHeight('Wg') + 2;
  if (adsExpireds.RecordCount > 0) and ((adsExpireds.RecordCount*C)/(pClient.Height-pWebBrowser.Height) > 13/10) then
    pWebBrowser.Visible := False
  else
    pWebBrowser.Visible := True;
}
end;

procedure TExpiredsForm.FormResize(Sender: TObject);
begin
  adsExpireds2AfterScroll(adsExpireds);
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
