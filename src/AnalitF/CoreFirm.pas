unit CoreFirm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXDBCtrl, Grids, DBGrids, ComCtrls, Db, StrUtils, Child,
  FR_DSet, FR_DBSet, ActnList, StdCtrls, Buttons, DBCtrls, Variants,
  Math, ExtCtrls, DBGridEh, ToughDBGrid, OleCtrls, 
  hlpcodecs, LU_Tracer, 
  SQLWaiting, ForceRus, GridsEh, 
  U_frameLegend, MemDS, DBAccess, MyAccess, U_frameBaseLegend,
  U_framePromotion,
  DayOfWeekHelper,
  DBViewHelper,
  U_frameAutoComment;

type
  TFilter=( filAll, filOrder, filLeader, filProducer);

  TCoreFirmForm = class(TChildForm)
    dsCore: TDataSource;
    ActionList: TActionList;
    actFilterAll: TAction;
    actFilterOrder: TAction;
    actFilterLeader: TAction;
    actSaveToFile: TAction;
    actDeleteOrder: TAction;
    lblRecordCount: TLabel;
    cbFilter: TComboBox;
    lblOrderLabel: TLabel;
    btnDeleteOrder: TSpeedButton;
    btnFormHistory: TSpeedButton;
    lblFirmPrice: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    dbgCore: TToughDBGrid;
    Bevel1: TBevel;
    actFlipCore: TAction;
    pTop: TPanel;
    eSearch: TEdit;
    btnSearch: TButton;
    tmrSearch: TTimer;
    adsAvgOrders: TMyQuery;
    adsCurrentOrderHeader: TMyQuery;
    adsCountFields: TMyQuery;
    adsCore: TMyQuery;
    adsCoreCryptPriceRet: TCurrencyField;
    adsAvgOrdersPRODUCTID: TLargeintField;
    adsAvgOrdersPRICEAVG: TFloatField;
    adsCoreCoreId: TLargeintField;
    adsCoreproductid: TLargeintField;
    adsCorePriceCode: TLargeintField;
    adsCoreRegionCode: TLargeintField;
    adsCoreFullCode: TLargeintField;
    adsCoreshortcode: TLargeintField;
    adsCoreCodeFirmCr: TLargeintField;
    adsCoreSynonymCode: TLargeintField;
    adsCoreSynonymFirmCrCode: TLargeintField;
    adsCoreCode: TStringField;
    adsCoreCodeCr: TStringField;
    adsCoreVolume: TStringField;
    adsCoreDoc: TStringField;
    adsCoreNote: TStringField;
    adsCorePeriod: TStringField;
    adsCoreAwait: TBooleanField;
    adsCoreJunk: TBooleanField;
    adsCoreCost: TFloatField;
    adsCoreQuantity: TStringField;
    adsCoreregistrycost: TFloatField;
    adsCorevitallyimportant: TBooleanField;
    adsCorerequestratio: TIntegerField;
    adsCoreordercost: TFloatField;
    adsCoreminordercount: TIntegerField;
    adsCoreSynonymName: TStringField;
    adsCoreSynonymFirm: TStringField;
    adsCoreLeaderPriceCode: TLargeintField;
    adsCoreLeaderRegionCode: TLargeintField;
    adsCoreLeaderRegionName: TStringField;
    adsCoreLeaderPriceName: TStringField;
    adsCoreLeaderPRICE: TFloatField;
    adsCoreOrdersCoreId: TLargeintField;
    adsCoreOrdersOrderId: TLargeintField;
    adsCoreOrdersClientId: TLargeintField;
    adsCoreOrdersFullCode: TLargeintField;
    adsCoreOrdersCodeFirmCr: TLargeintField;
    adsCoreOrdersSynonymCode: TLargeintField;
    adsCoreOrdersSynonymFirmCrCode: TLargeintField;
    adsCoreOrdersCode: TStringField;
    adsCoreOrdersCodeCr: TStringField;
    adsCoreOrderCount: TIntegerField;
    adsCoreOrdersSynonym: TStringField;
    adsCoreOrdersSynonymFirm: TStringField;
    adsCoreOrdersPrice: TFloatField;
    adsCoreOrdersJunk: TBooleanField;
    adsCoreOrdersAwait: TBooleanField;
    adsCoreOrdersHOrderId: TLargeintField;
    adsCoreOrdersHClientId: TLargeintField;
    adsCoreOrdersHPriceCode: TLargeintField;
    adsCoreOrdersHRegionCode: TLargeintField;
    adsCoreOrdersHPriceName: TStringField;
    adsCoreOrdersHRegionName: TStringField;
    adsCoreSumOrder: TFloatField;
    btnGotoCore: TSpeedButton;
    adsCoreWithLike: TMyQuery;
    adsCoreRealCost: TFloatField;
    adsCoreSupplierPriceMarkup: TFloatField;
    adsCoreProducerCost: TFloatField;
    adsCoreNDS: TSmallintField;
    adsCoreMnnId: TLargeintField;
    adsCoreMnn: TStringField;
    btnGotoMNN: TSpeedButton;
    adsCoreDescriptionId: TLargeintField;
    adsCoreCatalogVitallyImportant: TBooleanField;
    adsCoreCatalogMandatoryList: TBooleanField;
    adsCoreMaxProducerCost: TFloatField;
    adsProducers: TMyQuery;
    adsProducersId: TLargeintField;
    adsProducersName: TStringField;
    dsProducers: TDataSource;
    adsCoreBuyingMatrixType: TIntegerField;
    adsCoreProducerName: TStringField;
    adsCoreNamePromotionsCount: TIntegerField;
    adsCoreRetailVitallyImportant: TBooleanField;
    cbProducers: TComboBox;
    adsCoreMarkup: TFloatField;
    procedure cbFilterClick(Sender: TObject);
    procedure actDeleteOrderExecute(Sender: TObject);
    procedure adsCore2BeforePost(DataSet: TDataSet);
    procedure adsCore2AfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure actFilterAllExecute(Sender: TObject);
    procedure actFilterOrderExecute(Sender: TObject);
    procedure actFilterLeaderExecute(Sender: TObject);
    procedure btnFormHistoryClick(Sender: TObject);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure dbgCoreKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCoreSortMarkingChanged(Sender: TObject);
    procedure adsCoreLEADERPRICENAMEGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure tmrSearchTimer(Sender: TObject);
    procedure dbgCoreDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCoreColumns15GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure adsCoreAfterScroll(DataSet: TDataSet);
    procedure cbProducersCloseUp(Sender: TObject);
  private
    PriceCode, ClientId: Integer;
    RegionCode : Int64;
    PriceName,
    RegionName : String;

    UseExcess: Boolean;
    Excess: Integer;
    InternalSearchText : String;

    BM : TBitmap;

    fr : TForceRus;

    FOpenWithSearch : Boolean;

    framePromotion : TframePromotion;
    adsSupplierPromotions : TMyQuery;
    procedure SetOrderLabel;
    procedure SetFilter(Filter: TFilter);
    procedure RefreshCurrentOrderHeader;
    procedure AllFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure OrderCountFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure LeaderFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure ProducerFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure ccf(DataSet: TDataSet);
    procedure SetClear;
    procedure AddKeyToSearch(Key : Char);
    procedure DeleteOrder;
    procedure PrepareDetailPromotions;
  public
    frameLegend : TframeLegend;
    frameAutoComment : TframeAutoComment;
    procedure ShowForm(
      PriceCode: Integer;
      RegionCode: Int64;
      PriceName, RegionName : String;
      OnlyLeaders: Boolean=False;
      OpenWithSearch : Boolean = False); reintroduce;
    procedure Print( APreview: boolean = False); override;
    procedure RefreshAllCore;
  end;

implementation

uses Main, AProc, DModule, DBProc, FormHistory, Prices, Constant,
  NamesForms, AlphaUtils, Orders, DASQLMonitor, FR_Class, U_framePosition,
  DBGridHelper;

{$R *.DFM}

procedure TCoreFirmForm.FormCreate(Sender: TObject);
begin
  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreORDERCOUNT;
  fVolume := adsCoreREQUESTRATIO;
  fOrderCost := adsCoreORDERCOST;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMINORDERCOUNT;
  fBuyingMatrixType := adsCoreBuyingMatrixType;
  gotoMNNButton := btnGotoMNN;

  PrepareDetailPromotions();
  
  framePromotion := TframePromotion.AddFrame(Self, dbgCore, dbgCore, dbgCore, False);

  inherited;

  frameLegend := TframeLegend.CreateFrame(Self, True, True, False);
  frameLegend.Parent := Self;
  frameLegend.Align := alBottom;
  TframePosition.AddFrame(Self, Self, dsCore, 'SynonymName', 'MnnId', ShowDescriptionAction);

  frameAutoComment := TframeAutoComment.AddFrame(Self, pTop, 1, pTop.Height, dbgCore);
  frameAutoComment.Left := cbProducers.Left - frameAutoComment.Width - 5;
  frameAutoComment.Anchors := cbProducers.Anchors;

  BM := TBitmap.Create;

  fr := TForceRus.Create;

  InternalSearchText := '';
  adsCore.OnCalcFields := ccf;
  PrintEnabled := (DM.SaveGridMask and PrintFirmPrice) > 0;
  UseExcess := True;
  Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
  ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
  adsAvgOrders.ParamByName('ClientId').Value := ClientId;
  TDBGridHelper.RestoreColumnsLayout(dbgCore, Self.ClassName);
  if dbgCore.SortMarkedColumns.Count = 0 then
    dbgCore.FieldColumns['SYNONYMNAME'].Title.SortMarker := smUpEh;
end;

procedure TCoreFirmForm.FormDestroy(Sender: TObject);
begin
  inherited;
  TDBGridHelper.SaveColumnsLayout(dbgCore, Self.ClassName);
  fr.Free;
  BM.Free;
end;

procedure TCoreFirmForm.ShowForm(PriceCode: Integer; RegionCode: Int64;
  PriceName, RegionName : String; OnlyLeaders: Boolean=False; OpenWithSearch : Boolean = False);
var
  supplierId : Int64;
begin
  if adsSupplierPromotions.Active then
    adsSupplierPromotions.Close;
  framePromotion.HidePromotion();
  supplierId := DM.QueryValue('select FIRMCODE from PricesData where PriceCode = :PriceCode', ['PriceCode'], [PriceCode]);
  framePromotion.SetSupplierId(supplierId);
  adsSupplierPromotions.ParamByName('SupplierId').Value := supplierId;

  FOpenWithSearch := OpenWithSearch;
  if adsProducers.Active then
    adsProducers.Close;
  adsProducers.ParamByName( 'PriceCode').Value:=PriceCode;
  adsProducers.ParamByName( 'RegionCode').Value:=RegionCode;
  TDBViewHelper.LoadProcedures(cbProducers, adsProducers, adsProducersId, adsProducersName);

  Self.PriceCode  := PriceCode;
  Self.RegionCode := RegionCode;
  Self.PriceName  := PriceName;
  Self.RegionName := RegionName;
  //≈сли пришли сюда из заказа с возможностью поиска
  if FOpenWithSearch then begin
    dbgCore.InputField := '';
    if adsCore.Active then
      adsCore.Close;
  end
  else begin
    dbgCore.InputField := 'OrderCount';
    InternalSearchText := '';
    RefreshAllCore;
    SetFilter(filAll);
    if adsCore.RecordCount=0 then begin
      AProc.MessageBox('¬ыбранный прайс-лист отсутствует',MB_ICONWARNING);
      Abort;
    end;
    if OnlyLeaders then
      SetFilter(filLeader)
    else
      SetFilter(filAll);
  end;
  //подсчитываем сумму за€вки и количество записей
  SetOrderLabel;
  lblFirmPrice.Caption := Format( 'ѕрайс-лист %s, регион %s',[
    PriceName,
    RegionName]);
  if not adsAvgOrders.Active then
    adsAvgOrders.Open;
  if not adsSupplierPromotions.Active then
    adsSupplierPromotions.Open;
  Application.ProcessMessages;
  inherited ShowForm;
end;

procedure TCoreFirmForm.ccf(DataSet: TDataSet);
begin
  try
    if FAllowDelayOfPayment and not FShowSupplierCost then
      adsCoreCryptPriceRet.AsCurrency :=
        DM.GetRetailCostLast(
          adsCoreRetailVitallyImportant.Value,
          adsCoreCost.AsCurrency,
          adsCoreMarkup.AsVariant)
    else
      adsCoreCryptPriceRet.AsCurrency :=
        DM.GetRetailCostLast(
          adsCoreRetailVitallyImportant.Value,
          adsCoreRealCost.AsCurrency,
          adsCoreMarkup.AsVariant);
  except
  end;
end;

procedure TCoreFirmForm.SetFilter(Filter: TFilter);
var
  FP : TFilterRecordEvent;
begin
  FP := nil;
  case Filter of
    filAll:
      begin
        if Length(InternalSearchText) > 0 then
          FP := AllFilterRecord
        else begin
          FP := nil;
          tmrSearch.Enabled := False;
          eSearch.Text := '';
          InternalSearchText := '';
        end;
      end;
    filOrder: FP := OrderCountFilterRecord;
    filLeader: FP := LeaderFilterRecord;
    filProducer: FP := ProducerFilterRecord;
  end;
  DBProc.SetFilterProc(adsCore, FP);
  lblRecordCount.Caption:=Format( 'ѕозиций : %d', [adsCore.RecordCount]);
  cbFilter.ItemIndex := Integer(Filter);
end;

procedure TCoreFirmForm.cbFilterClick(Sender: TObject);
begin
  dbgCore.SetFocus;
  SetFilter(TFilter(cbFilter.ItemIndex));
end;

procedure TCoreFirmForm.actFilterAllExecute(Sender: TObject);
begin
  if Self.Visible then SetFilter(filAll);
end;

procedure TCoreFirmForm.actFilterOrderExecute(Sender: TObject);
begin
  if Self.Visible then SetFilter(filOrder);
end;

procedure TCoreFirmForm.actFilterLeaderExecute(Sender: TObject);
begin
  if Self.Visible then SetFilter(filLeader);
end;

procedure TCoreFirmForm.Print( APreview: boolean = False);
var
  OldFilterEvent : TFilterRecordEvent;
  OldFiltered : Boolean;
begin
  RefreshCurrentOrderHeader;
  OldFiltered := adsCore.Filtered;
  OldFilterEvent := adsCore.OnFilterRecord;
  adsCore.DisableControls;
  try
    adsCore.Filtered := False;
    adsCore.IndexFieldNames := 'SynonymName';
    frVariables[ 'OrdersComments'] := adsCurrentOrderHeader.FieldByName('Comments').AsVariant;

    if DM.adsPrices.Active then
      DM.adsPrices.Close;
    try
      DM.adsPrices.ParamByName('ClientId').Value := Self.ClientId;
      DM.adsPrices.ParamByName('TimeZoneBias').Value := TimeZoneBias;
      DM.adsPrices.Open;
      DM.adsPrices.Locate('PriceCode;RegionCode', VarArrayOf([ PriceCode, RegionCode]), []);
      frVariables[ 'PricesSupportPhone'] := DM.adsPricesSupportPhone.Value;
      frVariables[ 'PricesFullName'] := DM.adsPricesFullName.Value;
      frVariables[ 'PricesDatePrice'] := DM.adsPricesDatePrice.AsString;
    finally
      DM.adsPrices.Close;
    end;

    DM.ShowFastReport('CoreFirm.frf', adsCore, APreview);
  finally
    if OldFiltered then
      DBProc.SetFilterProc(adsCore, OldFilterEvent);
    dbgCore.OnSortMarkingChanged(dbgCore);
    adsCore.EnableControls;
  end;
end;

//переоткрывает заголовок дл€ текущего заказа
//нужна дл€ печати. Ќе удал€ть, т.к. сломаетс€ печать прайс-листа
procedure TCoreFirmForm.RefreshCurrentOrderHeader;
begin
  with adsCurrentOrderHeader do begin
    ParamByName('ClientId').Value:=ClientId;
    ParamByName('PriceCode').Value:=PriceCode;
    ParamByName('RegionCode').Value:=RegionCode;

    if adsCurrentOrderHeader.Active then
      adsCurrentOrderHeader.Close;
    adsCurrentOrderHeader.Open;
  end;
end;

procedure TCoreFirmForm.adsCore2BeforePost(DataSet: TDataSet);
var
  Quantity, E: Integer;
  PriceAvg: Double;
  PanelCaption : String;
  PanelHeight : Integer;
begin
  try
    { провер€ем заказ на соответствие наличию товара на складе }
    Val( adsCoreQuantity.AsString, Quantity, E);
    if E <> 0 then Quantity := 0;
    if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity)
    then begin
      AProc.MessageBox(
        '«аказ превышает остаток на складе, товар будет заказан в количестве ' + adsCoreQuantity.AsString,
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

    { провер€ем на превышение цены }
    if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) and (not adsAvgOrdersPRODUCTID.IsNull) then
    begin
      PriceAvg := adsAvgOrdersPRICEAVG.AsCurrency;
      if ( PriceAvg > 0) and ( adsCoreCOST.AsCurrency>PriceAvg*(1+Excess/100)) then
      begin
        if Length(PanelCaption) > 0 then
          PanelCaption := PanelCaption + #13#10 + ExcessAvgCostMessage
        else
          PanelCaption := ExcessAvgCostMessage;
      end;
    end;

    if (adsCoreJUNK.AsBoolean) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + OrderJunkMessage
      else
        PanelCaption := OrderJunkMessage;

    if (adsCoreORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + WarningOrderCountMessage
      else
        PanelCaption := WarningOrderCountMessage;

    if Length(PanelCaption) > 0 then
      ShowOverCostPanel(PanelCaption, dbgCore);
  except
    adsCore.Cancel;
    raise;
  end;
end;

procedure TCoreFirmForm.adsCore2AfterPost(DataSet: TDataSet);
begin
  SetOrderLabel;
  MainForm.SetOrdersInfo;
end;

procedure TCoreFirmForm.SetOrderLabel;
var
  OrderCount : Integer;
  OrderSum: Double;
begin
  OrderCount := DM.QueryValue(
  'SELECT count(*) FROM CurrentOrderLists, CurrentOrderHeads WHERE ' +
    'CurrentOrderHeads.PriceCode = :PriceCode and CurrentOrderHeads.regioncode = :RegionCode ' +
    ' and CurrentOrderHeads.ClientId = :ClientId and CurrentOrderHeads.Frozen = 0 ' +
    ' and CurrentOrderLists.OrderId = CurrentOrderHeads.orderid and CurrentOrderHeads.closed = 0 ' +
    ' AND CurrentOrderLists.OrderCount>0',
    ['PriceCode', 'RegionCode', 'ClientId'],
    [PriceCode, RegionCode, ClientId]);
  OrderSum := DM.FindOrderInfo(PriceCode, RegionCode);
  lblOrderLabel.Caption:=Format('«аказано %d позиций на сумму %0.2f руб.',
    [OrderCount,OrderSum]);
end;

procedure TCoreFirmForm.btnFormHistoryClick(Sender: TObject);
begin
  if not adsCoreproductid.IsNull then
    ShowFormHistory(
      DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean,
      adsCoreFullCode.Value,
      adsCoreproductid.Value,
      ClientId);
end;

procedure TCoreFirmForm.actDeleteOrderExecute(Sender: TObject);
var
  OldFilterEvent : TFilterRecordEvent;
  OldFiltered : Boolean;
  LastPositionByCoreId : Variant;
begin
  if not Visible then Exit;
  if AProc.MessageBox( '”далить весь заказ по данному прайс-листу?',
    MB_ICONQUESTION or MB_OKCANCEL)<>IDOK then Abort;
  adsCore.DisableControls;
  OldFiltered := adsCore.Filtered;
  OldFilterEvent := adsCore.OnFilterRecord;
  LastPositionByCoreId := adsCoreCoreId.AsVariant;
  Screen.Cursor:=crHourGlass;
  try
    with DM.adcUpdate do begin
      //удал€ем сохраненную за€вку (если есть)
      SQL.Text:= ''
        + ' delete CurrentOrderHeads, CurrentOrderLists'
        + ' FROM CurrentOrderHeads, CurrentOrderLists '
        + ' WHERE '
        + '     (CurrentOrderHeads.ClientId=:ClientId) '
        + ' and (CurrentOrderHeads.PriceCode=:PriceCode) '
        + ' and (CurrentOrderHeads.RegionCode=:RegionCode) '
        + ' and (CurrentOrderHeads.Closed <> 1)'
        + ' and (CurrentOrderHeads.Frozen = 0) '
        + ' and (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId)';
      ParamByName('CLIENTID').Value := DM.adtClients.FieldByName('ClientId').Value;
      ParamByName('PRICECODE').Value := PriceCode;
      ParamByName('REGIONCODE').Value := RegionCode;
      Execute;
    end;

    adsCore.Filtered := False;
    adsCore.First;
    while not adsCore.Eof do begin
      if not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0) then
        adsCore.RefreshRecord;
      adsCore.Next;
    end;
  finally
    if OldFiltered then
      DBProc.SetFilterProc(adsCore, OldFilterEvent);
    adsCore.First;
    adsCore.Locate([adsCoreCoreId], LastPositionByCoreId, []);
    adsCore.EnableControls;
    Screen.Cursor:=crDefault;
    SetOrderLabel;
    MainForm.SetOrdersInfo;
  end;
  dbgCore.SetFocus;
  //≈сли мы пришли сюда из формы заказа, то возвращатьс€ туда нет смысла
  if Self.PrevForm is TOrdersForm then begin
    Self.PrevForm.ShowAsPrevForm;
    //Close;
  end;
end;

procedure TCoreFirmForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if adsCoreVITALLYIMPORTANT.AsBoolean then
    AFont.Color := VITALLYIMPORTANT_CLR;

  //данный прайс-лидер
  if (((adsCoreLEADERPRICECODE.AsInteger = PriceCode) and ( adsCoreLeaderRegionCode.AsLargeInt = RegionCode))
     or adsCoreLEADERPRICE.IsNull
     or (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01)
     )
    and
    (( Column.Field = adsCoreLEADERREGIONNAME) or ( Column.Field = adsCoreLEADERPRICENAME))
  then
    Background := LEADER_CLR;
  //уцененный товар
  if (adsCoreJunk.AsBoolean) and (( Column.Field = adsCorePERIOD) or
    ( Column.Field = adsCoreCOST)) then Background := JUNK_CLR;
  //ожидаемый товар выдел€ем зеленым
  if (adsCoreAwait.AsBoolean) and ( Column.Field = adsCoreSYNONYMNAME) then
    Background := AWAIT_CLR;

  if (adsCoreBuyingMatrixType.Value = 1) then
    Background := BuyingBanColor;
end;

procedure TCoreFirmForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift = []) and (Key = VK_DELETE) and (not adsCore.IsEmpty) then begin
    Key := 0;
    DeleteOrder;
  end
  else
  if ( Key = VK_RETURN) then
    if tmrSearch.Enabled then
      tmrSearchTimer(nil)
    else
      btnFormHistoryClick( nil);
  if Key = VK_ESCAPE then
    if Assigned(Self.PrevForm) and (Self.PrevForm is TOrdersForm) and FOpenWithSearch
    then begin
      tmrSearch.Enabled := False;
      Self.PrevForm.ShowAsPrevForm
    end
    else
      if tmrSearch.Enabled or (Length(InternalSearchText) > 0) then
        SetClear
      else
        if Assigned(Self.PrevForm) and (Self.PrevForm is TPricesForm) then
          //≈сли возвращаемс€ в Prices, то вызываем ShowForm, т.к. почему
          //уходит фокус с таблицы предложений на форме "«а€вка поставщику"
          Self.PrevForm.ShowForm
        else
          if Assigned(Self.PrevForm) then
            Self.PrevForm.ShowAsPrevForm
          else
            Close;
end;

procedure TCoreFirmForm.dbgCoreCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
  CanInput :=
    (not adsCore.IsEmpty)
    and (( RegionCode and DM.adtClientsREQMASK.AsLargeInt) = RegionCode);
  if not CanInput then Exit;
end;

procedure TCoreFirmForm.actFlipCoreExecute(Sender: TObject);
var
  FullCode, ShortCode: integer;
  CoreId : Int64;
begin
  if MainForm.ActiveChild <> Self then exit;
  if Self.PrevForm is TOrdersForm then exit;

  FullCode := adsCoreFullCode.AsInteger;
  ShortCode := adsCoreShortCode.AsInteger;

  CoreId := adsCoreCOREID.AsLargeInt;

  FlipToCode(FullCode, ShortCode, CoreId);
end;

procedure TCoreFirmForm.dbgCoreKeyPress(Sender: TObject; var Key: Char);
begin
  if ( Key > #32) and not ( Key in
    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
  begin
    AddKeyToSearch(Key);
  end;
end;

procedure TCoreFirmForm.OrderCountFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if Length(InternalSearchText) > 0 then
    Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
      and not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0)
  else
    Accept := not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0);
  if Accept and (cbProducers.ItemIndex <> 0) then
    if cbProducers.ItemIndex = 1 then
      Accept := adsCoreCodeFirmCr.AsVariant = 0
    else
      Accept := adsCoreCodeFirmCr.AsVariant = Integer(cbProducers.Items.Objects[cbProducers.ItemIndex]);
end;

procedure TCoreFirmForm.LeaderFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if Length(InternalSearchText) > 0 then
    Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
    and
    (
     ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
      or adsCoreLEADERPRICE.IsNull
      or (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01)
    )
  else
    Accept :=
      ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
        or adsCoreLEADERPRICE.IsNull
        or (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01);
  if Accept and (cbProducers.ItemIndex <> 0) then
    if cbProducers.ItemIndex = 1 then
      Accept := adsCoreCodeFirmCr.AsVariant = 0
    else
      Accept := adsCoreCodeFirmCr.AsVariant = Integer(cbProducers.Items.Objects[cbProducers.ItemIndex]);
end;

procedure TCoreFirmForm.RefreshAllCore;
begin
  Screen.Cursor:=crHourglass;
  try
    adsCore.ParamByName( 'PriceCode').Value:=PriceCode;
    adsCore.ParamByName( 'RegionCode').Value:=RegionCode;
    adsCore.ParamByName( 'ClientId').Value:=ClientId;
    adsCore.ParamByName( 'DayOfWeek').Value:=TDayOfWeekHelper.DayOfWeek();
    ShowSQLWaiting(adsCore);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TCoreFirmForm.dbgCoreSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TCoreFirmForm.adsCoreLEADERPRICENAMEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if adsCoreLEADERPRICE.IsNull or
    (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01)
  then
    Text := PriceName
  else
    Text := Sender.AsString;
end;

procedure TCoreFirmForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if Length(eSearch.Text) > 2 then begin
    eSearch.Enabled := False;
    adsCore.DisableControls;
    try
      InternalSearchText := StrUtils.LeftStr(eSearch.Text, 50);
      if Assigned(Self.PrevForm) and (Self.PrevForm is TOrdersForm) and FOpenWithSearch
      then begin
        adsCore.Close;
        adsCore.SQL.Text := adsCoreWithLike.SQL.Text;
        adsCore.ParamByName('LikeParam').AsString := '%' + InternalSearchText + '%';
        RefreshAllCore;
        dbgCore.InputField := 'OrderCount';
      end;
      if not Assigned(adsCore.OnFilterRecord) then begin
        adsCore.OnFilterRecord := AllFilterRecord;
        adsCore.Filtered := True;
      end
      else
        DBProc.SetFilterProc(adsCore, adsCore.OnFilterRecord);
    finally
      adsCore.EnableControls;
      eSearch.Enabled := True;
    end;
    lblRecordCount.Caption:=Format( 'ѕозиций : %d', [adsCore.RecordCount]);
    eSearch.Text := '';
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TCoreFirmForm.AllFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText);
  if Accept and (cbProducers.ItemIndex <> 0) then
    if cbProducers.ItemIndex = 1 then
      Accept := adsCoreCodeFirmCr.AsVariant = 0
    else
      Accept := adsCoreCodeFirmCr.AsVariant = Integer(cbProducers.Items.Objects[cbProducers.ItemIndex]);
end;

procedure TCoreFirmForm.SetClear;
var
  p : TFilterRecordEvent;
begin
  tmrSearch.Enabled := False;
  eSearch.Enabled := False;
  adsCore.DisableControls;
  try
    eSearch.Text := '';
    InternalSearchText := '';
    p := AllFilterRecord;
    if @adsCore.OnFilterRecord = @p then begin
      adsCore.Filtered := False;
      adsCore.OnFilterRecord := nil;
    end
    else
      DBProc.SetFilterProc(adsCore, adsCore.OnFilterRecord);
  finally
    adsCore.EnableControls;
    eSearch.Enabled := True;
  end;
  lblRecordCount.Caption:=Format( 'ѕозиций : %d', [adsCore.RecordCount]);
end;

procedure TCoreFirmForm.dbgCoreDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if Column.Field = adsCoreSYNONYMNAME then
    ProduceAlphaBlendRect(InternalSearchText, Column.Field.DisplayText, dbgCore.Canvas, Rect, BM);
end;

procedure TCoreFirmForm.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
    dbgCore.SetFocus;
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TCoreFirmForm.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //≈сли мы что-то нажали в элементе, то должны на это отреагировать
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

procedure TCoreFirmForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TCoreFirmForm.ProducerFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  case cbFilter.ItemIndex of
    0 :
      begin
        if Length(InternalSearchText) > 0 then
          Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText);
      end;
    1 :
      begin
        if Length(InternalSearchText) > 0 then
          Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
            and not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0)
        else
          Accept := not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0);
      end;
    2 :
      begin
        if Length(InternalSearchText) > 0 then
          Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
          and
          (
           ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
            or adsCoreLeaderPRICE.IsNull
            or (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01)
          )
        else
          Accept := ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
            or adsCoreLeaderPRICE.IsNull
            or (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01);
      end;
  end;
  if Accept then
    if cbProducers.ItemIndex = 1 then
      Accept := adsCoreCodeFirmCr.AsVariant = 0
    else
      Accept := adsCoreCodeFirmCr.AsVariant = Integer(cbProducers.Items.Objects[cbProducers.ItemIndex]);
end;

procedure TCoreFirmForm.DeleteOrder;
var
  OldFilterEvent : TFilterRecordEvent;
  OldFiltered : Boolean;
  LastPositionByCoreId : Variant;
  I : Integer;
  selectedRows : TStringList;
begin
  if not Visible then Exit;
  selectedRows := TDBGridHelper.GetSelectedRows(dbgCore);
  if (selectedRows.Count > 0)
    and (AProc.MessageBox( '”далить выбранные позиции?', MB_ICONQUESTION or MB_OKCANCEL) <> IDOK)
  then
    Abort;
  adsCore.DisableControls;
  OldFiltered := adsCore.Filtered;
  OldFilterEvent := adsCore.OnFilterRecord;
  LastPositionByCoreId := adsCoreCoreId.AsVariant;
  Screen.Cursor:=crHourGlass;
  try

    for I := 0 to selectedRows.Count-1 do begin
      adsCore.Bookmark := selectedRows[i];
      if adsCoreOrderCount.Value > 0 then begin
        adsCore.Edit;
        adsCoreOrderCount.Value := 0;
        adsCore.Post;
      end;
    end;

  finally
    if OldFiltered then
      DBProc.SetFilterProc(adsCore, OldFilterEvent);
    adsCore.First;
    adsCore.Locate([adsCoreCoreId], LastPositionByCoreId, []);
    adsCore.EnableControls;
    Screen.Cursor:=crDefault;
    SetOrderLabel;
    MainForm.SetOrdersInfo;
  end;
  //≈сли мы пришли сюда из формы заказа, то возвращатьс€ туда нет смысла
  if Self.PrevForm is TOrdersForm then begin
    Self.PrevForm.ShowAsPrevForm;
    //Close;
  end;
end;

procedure TCoreFirmForm.dbgCoreColumns15GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if adsCoreLeaderPRICE.IsNull then
    Params.Text := adsCoreCost.DisplayText
  else
    Params.Text := adsCoreLeaderPRICE.DisplayText;
end;

procedure TCoreFirmForm.adsCoreAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if adsCore.Active and not adsCore.IsEmpty and adsSupplierPromotions.Active and not adsSupplierPromotions.IsEmpty
  then begin
    if (adsCoreNamePromotionsCount.AsInteger > 0)
      and not adsSupplierPromotions.FieldByName('PromotionId').IsNull
    then
      framePromotion.ShowPromotion(
        adsCoreshortcode.AsInteger,
        adsCorefullcode.AsInteger,
        adsCoreNamePromotionsCount.AsInteger)
    else
      framePromotion.HidePromotion();
  end
  else
    framePromotion.HidePromotion();
end;

procedure TCoreFirmForm.PrepareDetailPromotions;
begin
  adsSupplierPromotions := TMyQuery.Create(Self);
  adsSupplierPromotions.Connection := DM.MainConnection;
  adsSupplierPromotions.SQL.Text := ''
+ 'select '
+ '  PromotionCatalogs.PromotionId, '
+ '  PromotionCatalogs.CatalogId, '
+ '  Catalogs.ShortCode '
+ ' from '
+ '   SupplierPromotions '
+ '   inner join PromotionCatalogs on PromotionCatalogs.PromotionId = SupplierPromotions.Id '
+ '   inner join Catalogs on Catalogs.FullCode = PromotionCatalogs.CatalogId '
+ ' where '
+ '   SupplierPromotions.SupplierId = :SupplierId ';

  adsSupplierPromotions.MasterSource := dsCore;
  adsSupplierPromotions.MasterFields := 'ShortCode';
  adsSupplierPromotions.DetailFields := 'ShortCode';
end;

procedure TCoreFirmForm.cbProducersCloseUp(Sender: TObject);
begin
  if cbProducers.ItemIndex = 0 then
    SetFilter(TFilter(cbFilter.ItemIndex))
  else
    SetFilter(filProducer);
  dbgCore.SetFocus;
end;

end.
