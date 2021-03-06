unit SynonymSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB, ActnList, ExtCtrls, FR_DSet,
  FR_DBSet, Grids, DBGridEh, ToughDBGrid, StdCtrls, Constant,
  ForceRus, DBGrids, Buttons, Menus, DBCtrls, StrUtils, GridsEh,
  U_frameLegend, MemDS, DBAccess, MyAccess, U_frameBaseLegend,
  U_framePromotion,
  DayOfWeekHelper,
  DBViewHelper,
  U_frameAutoComment,
  SearchFilterController,
  U_LegendHolder;

type
  TSynonymSearchForm = class(TChildForm)
    pTop: TPanel;
    pCenter: TPanel;
    dbgCore: TToughDBGrid;
    dsCore: TDataSource;
    ActionList: TActionList;
    actFlipCore: TAction;
    eSearch: TEdit;
    btnSearch: TButton;
    tmrSearch: TTimer;
    cbBaseOnly: TCheckBox;
    btnSelectPrices: TBitBtn;
    pmSelectedPrices: TPopupMenu;
    miSelectAll: TMenuItem;
    miUnselecAll: TMenuItem;
    miSep: TMenuItem;
    lFilter: TLabel;
    pBottom: TPanel;
    gbPrevOrders: TGroupBox;
    lblPriceAvg: TLabel;
    dbtPriceAvg: TDBText;
    dbgHistory: TToughDBGrid;
    dsPreviosOrders: TDataSource;
    dsAvgOrders: TDataSource;
    adsCore: TMyQuery;
    adsCoreCoreId: TLargeintField;
    adsCorePriceCode: TLargeintField;
    adsCoreRegionCode: TLargeintField;
    adsCoreProductID: TLargeintField;
    adsCoreFullCode: TLargeintField;
    adsCoreshortcode: TLargeintField;
    adsCoreCodeFirmCr: TLargeintField;
    adsCoreSynonymCode: TLargeintField;
    adsCoreSynonymFirmCrCode: TLargeintField;
    adsCoreCode: TStringField;
    adsCoreCodeCr: TStringField;
    adsCorePeriod: TStringField;
    adsCoreVolume: TStringField;
    adsCoreNote: TStringField;
    adsCoreCost: TFloatField;
    adsCoreQuantity: TStringField;
    adsCoreAwait: TBooleanField;
    adsCoreJunk: TBooleanField;
    adsCoredoc: TStringField;
    adsCoreregistrycost: TFloatField;
    adsCorevitallyimportant: TBooleanField;
    adsCorerequestratio: TIntegerField;
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
    adsCoreSumOrder: TFloatField;
    adsCoreOrdersJunk: TBooleanField;
    adsCoreOrdersAwait: TBooleanField;
    adsCoreOrdersHOrderId: TLargeintField;
    adsCoreOrdersHClientId: TLargeintField;
    adsCoreOrdersHPriceCode: TLargeintField;
    adsCoreOrdersHRegionCode: TLargeintField;
    adsCoreOrdersHPriceName: TStringField;
    adsCoreOrdersHRegionName: TStringField;
    adsCorePriceRet: TCurrencyField;
    adsCoreSortOrder: TIntegerField;
    adsPreviosOrders: TMyQuery;
    adsPreviosOrdersFullCode: TLargeintField;
    adsPreviosOrdersCode: TStringField;
    adsPreviosOrdersCodeCR: TStringField;
    adsPreviosOrdersSynonymName: TStringField;
    adsPreviosOrdersSynonymFirm: TStringField;
    adsPreviosOrdersOrderCount: TIntegerField;
    adsPreviosOrdersPrice: TFloatField;
    adsPreviosOrdersOrderDate: TDateTimeField;
    adsPreviosOrdersPriceName: TStringField;
    adsPreviosOrdersRegionName: TStringField;
    adsPreviosOrdersAwait: TBooleanField;
    adsPreviosOrdersJunk: TBooleanField;
    adsAvgOrders: TMyQuery;
    adsAvgOrdersPRICEAVG: TFloatField;
    adsAvgOrdersPRODUCTID: TLargeintField;
    tmrUpdatePreviosOrders: TTimer;
    tmrSelectedPrices: TTimer;
    btnGotoCore: TSpeedButton;
    adsCoreStartSQL: TMyQuery;
    adsCoreColorIndex: TLargeintField;
    adsCoreByProducts: TMyQuery;
    adsCoreByFullcode: TMyQuery;
    adsCoreRealCost: TFloatField;
    adsCoreSupplierPriceMarkup: TFloatField;
    adsCoreProducerCost: TFloatField;
    adsCoreNDS: TSmallintField;
    adsCoreMnn: TStringField;
    adsCoreMnnId: TLargeintField;
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
    adsPreviosOrdersPeriod: TStringField;
    adsCoreProducerName: TStringField;
    adsCoreNamePromotionsCount: TIntegerField;
    adsCoreRetailVitallyImportant: TBooleanField;
    cbProducers: TComboBox;
    adsCoreStartSynonym: TMyQuery;
    adsCoreEndSynonym: TMyQuery;
    adsCoreMarkup: TFloatField;
    adsAvgOrdersOrderCountAvg: TFloatField;
    lOrderCountAvg: TLabel;
    dbtOrderCountAvg: TDBText;
    adsCoreOrdersComment: TStringField;
    adsCoreExp: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
    procedure adsCoreOldBeforePost(DataSet: TDataSet);
    procedure adsCoreOldBeforeEdit(DataSet: TDataSet);
    procedure adsCoreOldAfterPost(DataSet: TDataSet);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreKeyPress(Sender: TObject; var Key: Char);
    procedure btnSelectPricesClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure miUnselecAllClick(Sender: TObject);
    procedure cbBaseOnlyClick(Sender: TObject);
    procedure dbgCoreDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure adsCoreOldSTORAGEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure tmrUpdatePreviosOrdersTimer(Sender: TObject);
    procedure adsCoreBeforeClose(DataSet: TDataSet);
    procedure adsCoreAfterOpen(DataSet: TDataSet);
    procedure adsCoreAfterScroll(DataSet: TDataSet);
    procedure tmrSelectedPricesTimer(Sender: TObject);
    procedure cbProducersCloseUp(Sender: TObject);
  private
    { Private declarations }
    fr : TForceRus;
    DeltaMode, Excess, ExcessAvgOrderTimes : Integer;
    slColors : TStringList;
    SelectedPrices : TStringList;
    BM : TBitmap;
    InternalSearchText : String;
    FSearchFilterController : TSearchFilterController;
    //������ ����������
    SortList : TStringList;
    framePromotion : TframePromotion;
    procedure AddKeyToSearch(Key : Char);
    procedure SetClear;
    procedure ChangeSelected(ASelected : Boolean);
    procedure OnSPClick(Sender: TObject);
    procedure ccf(DataSet: TDataSet);
    procedure InternalSearch;
    procedure UpdateGridOnLegend(Sender : TObject);
  public
    { Public declarations }
    frameLegend : TframeLegend;
    frameAutoComment : TframeAutoComment;
    function SearchInProgress : Boolean; override;
  end;

var
  SynonymSearchForm: TSynonymSearchForm;

procedure ShowSynonymSearch;


implementation

uses
  DModule, AProc, Main, SQLWaiting, AlphaUtils, NamesForms, U_GroupUtils,
  U_framePosition, DBGridHelper;

{$R *.dfm}

procedure ShowSynonymSearch;
begin
  MainForm.ShowChildForm(TSynonymSearchForm);
end;


procedure TSynonymSearchForm.FormCreate(Sender: TObject);
var
  I : Integer;
  sp : TSelectPrice;
  mi :TMenuItem;
begin
  SortList := nil;
  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreORDERCOUNT;
  fVolume := adsCoreREQUESTRATIO;
  fOrderCost := adsCoreORDERCOST;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMINORDERCOUNT;
  fBuyingMatrixType := adsCoreBuyingMatrixType;
  fCoreQuantity := adsCoreQuantity;
  gotoMNNButton := btnGotoMNN;
  SortOnOrderGrid := False;

  framePromotion := TframePromotion.AddFrame(Self, pCenter, pCenter, dbgCore, False);
  
  inherited;

  frameLegend := TframeLegend.CreateFrame(Self, True, False, True);
  frameLegend.Parent := Self;
  frameLegend.Align := alBottom;
  frameLegend.UpdateGrids := UpdateGridOnLegend;

  TframePosition.AddFrame(Self, pCenter, dsCore, 'SynonymName', 'MnnId', ShowDescriptionAction);

  frameAutoComment := TframeAutoComment.AddFrame(Self, pTop, btnSelectPrices.Left, pTop.Height - (btnSelectPrices.Top + btnSelectPrices.Height), dbgCore);
  frameAutoComment.Top := btnSelectPrices.Top + btnSelectPrices.Height;

  if adsProducers.Active then
    adsProducers.Close;
  TDBViewHelper.LoadProcedures(cbProducers, adsProducers, adsProducersId, adsProducersName);

  FSearchFilterController := TSearchFilterController.Create('synonyms.synonymname');
  InternalSearchText := '';
  BM := TBitmap.Create;

  adsCore.OnCalcFields := ccf;
  slColors := TStringList.Create;

  fr := TForceRus.Create;

  Excess := FGS.Excess;
  ExcessAvgOrderTimes := FGS.ExcessAvgOrderTimes;
  DeltaMode := DM.adtClients.FieldByName( 'DeltaMode').AsInteger;
  adsPreviosOrders.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').AsInteger;
  adsAvgOrders.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').AsInteger;

  if not adsAvgOrders.Active then
    adsAvgOrders.Open;

  TDBGridHelper.RestoreColumnsLayout(dbgCore, 'TCoreForm');
  TDBGridHelper.RestoreColumnsLayout(dbgHistory, 'TCoreForm');

  SelectedPrices := SynonymSelectedPrices;
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

  ShowForm;
end;

procedure TSynonymSearchForm.FormDestroy(Sender: TObject);
begin
  slColors.Free;
  fr.Free;
  TDBGridHelper.SaveColumnsLayout(dbgCore, 'TCoreForm');
  TDBGridHelper.SaveColumnsLayout(dbgHistory, 'TCoreForm');
  BM.Free;
end;

procedure TSynonymSearchForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if (Length(eSearch.Text) > 2) and FSearchFilterController.AllowSearch(eSearch.Text) then begin
    FSearchFilterController.SetSearchText(eSearch.Text);
    InternalSearchText := StrUtils.LeftStr(eSearch.Text, 50);
    InternalSearch;
    eSearch.Text := '';
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TSynonymSearchForm.ccf(DataSet: TDataSet);
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
{
    if Assigned(SortList) then
      adsCoreSortOrder.AsInteger := SortList.IndexOf(adsCoreCOREID.AsString);
}      
  except
  end;
end;

procedure TSynonymSearchForm.adsCoreOldBeforePost(DataSet: TDataSet);
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

    { ��������� �� ���������� ����������� ���������� }
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

    if DM.ExistsInFrozenOrders(adsCoreProductID.Value) then
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

procedure TSynonymSearchForm.adsCoreOldBeforeEdit(DataSet: TDataSet);
begin
  if adsCoreFirmCode.AsInteger = RegisterId then Abort;
end;

procedure TSynonymSearchForm.adsCoreOldAfterPost(DataSet: TDataSet);
begin
  MainForm.SetOrdersInfo;
end;

procedure TSynonymSearchForm.dbgCoreCanInput(Sender: TObject;
  Value: Integer; var CanInput: Boolean);
begin
  CanInput := (not adsCore.IsEmpty) and ( adsCoreSynonymCode.AsInteger >= 0) and
    (( adsCoreRegionCode.AsLargeInt and DM.adtClientsREQMASK.AsLargeInt) =
      adsCoreRegionCode.AsLargeInt);
end;

procedure TSynonymSearchForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  ColorIndex : Integer;
begin
  if adsCore.Active then begin
    if adsCoreSynonymCode.AsInteger < 0 then
    begin
      Background := $00fff1d8;
                  AFont.Style := [fsBold];
    end
    else
    if adsCoreFirmCode.AsInteger = RegisterId then
    begin
      //���� ��� ������, �������� �����
      if ( Column.Field = adsCoreSYNONYMNAME) or ( Column.Field = adsCoreSYNONYMFIRM) or
        ( Column.Field = adsCoreCOST)or
        ( Column.Field = adsCorePriceRet) then Background := REG_CLR;
          end
    else
    begin
      if (not adsCore.IsEmpty) {and Assigned(SortList)}
          and (Column.Field <> adsCoreOrderCount) and (Column.Field <> adsCoreSumOrder)
      then begin
        ColorIndex := adsCoreColorIndex.AsInteger;
        if ColorIndex mod 2 = 0 then
          Background := GroupColor;
      end;

      if adsCoreVITALLYIMPORTANT.AsBoolean then
        AFont.Color := LegendHolder.Legends[lnVitallyImportant];

      if not adsCorePriceEnabled.AsBoolean then
      begin
        //���� ����� ����������, �������� ����
        if ( Column.Field = adsCoreSYNONYMNAME) or ( Column.Field = adsCoreSYNONYMFIRM)
          then Background := LegendHolder.Legends[lnNonMain];
      end;

      //���� ��������� �����, �������� ����
      if adsCoreJunk.AsBoolean and (( Column.Field = adsCorePERIOD) or ( Column.Field = adsCoreCOST)) then
        Background := LegendHolder.Legends[lnJunk];
      //��������� ����� �������� �������
      if adsCoreAwait.AsBoolean and ( Column.Field = adsCoreSYNONYMNAME) then
        Background := LegendHolder.Legends[lnAwait];
        
      if (adsCoreBuyingMatrixType.Value = 1) then
        Background := LegendHolder.Legends[lnBuyingBan];
    end;
  end;
end;

procedure TSynonymSearchForm.eSearchKeyDown(Sender: TObject; var Key: Word;
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

procedure TSynonymSearchForm.eSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //���� �� ���-�� ������ � ��������, �� ������ �� ��� �������������
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

procedure TSynonymSearchForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TSynonymSearchForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
  end
  else
    if Key = VK_ESCAPE then
      SetClear
    else
      //��������� ������ � ������
      if (Key = VK_SPACE) and SearchInProgress then
        AddKeyToSearch(#32);
end;

procedure TSynonymSearchForm.SetClear;
begin
  tmrSearch.Enabled := False;
  eSearch.Text := '';
  InternalSearchText := '';
  FSearchFilterController.SetSearchText('');
  if adsCore.Active then
    adsCore.Close;
  framePromotion.HidePromotion();
end;

procedure TSynonymSearchForm.dbgCoreKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ( Key >= #32) and not ( Key in
    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
  begin
    AddKeyToSearch(Key);
  end;
end;

procedure TSynonymSearchForm.btnSelectPricesClick(Sender: TObject);
begin
  pmSelectedPrices.Popup(btnSelectPrices.ClientOrigin.X, btnSelectPrices.ClientOrigin.Y + btnSelectPrices.Height);
end;

procedure TSynonymSearchForm.ChangeSelected(ASelected: Boolean);
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

procedure TSynonymSearchForm.miSelectAllClick(Sender: TObject);
begin
  ChangeSelected(True);
end;

procedure TSynonymSearchForm.miUnselecAllClick(Sender: TObject);
begin
  ChangeSelected(False);
end;

procedure TSynonymSearchForm.OnSPClick(Sender: TObject);
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

procedure TSynonymSearchForm.cbBaseOnlyClick(Sender: TObject);
begin
  if not tmrSearch.Enabled and (Length(InternalSearchText) > 0) and FSearchFilterController.AllowSearchFilter() then
    InternalSearch;
end;

procedure TSynonymSearchForm.dbgCoreDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  i : Integer;
begin
  if Column.Field = adsCoreSYNONYMNAME then begin
    if FSearchFilterController.AllowSearchFilter() then
      for i := FSearchFilterController.Searchs.Count-1 downto 0 do
        ProduceAlphaBlendRect(FSearchFilterController.Searchs[i], Column.Field.DisplayText, dbgCore.Canvas, Rect, BM);
    //ProduceAlphaBlendRect(InternalSearchText, Column.Field.DisplayText, dbgCore.Canvas, Rect, BM);
  end;
end;

procedure TSynonymSearchForm.adsCoreOldSTORAGEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Iif(Sender.AsBoolean, '+', '');
end;

procedure TSynonymSearchForm.actFlipCoreExecute(Sender: TObject);
var
  FullCode, ShortCode: integer;
  CoreId : Int64;
begin
  if MainForm.ActiveChild <> Self then exit;
  if adsCore.IsEmpty then Exit;

  FullCode := adsCoreFullCode.AsInteger;
  ShortCode := adsCoreShortCode.AsInteger;

  CoreId := adsCoreCOREID.AsLargeInt;

  FlipToCodeWithReturn(FullCode, ShortCode, CoreId);
end;

procedure TSynonymSearchForm.tmrUpdatePreviosOrdersTimer(Sender: TObject);
begin
  tmrUpdatePreviosOrders.Enabled := False;
  if adsPreviosOrders.Active then
    adsPreviosOrders.Close;
  if adsCore.Active and not adsCore.IsEmpty
  then begin
    adsPreviosOrders.ParamByName( 'GroupByProducts').Value :=
      DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean;
    adsPreviosOrders.ParamByName( 'FullCode').Value := adsCoreFullCode.Value;
    adsPreviosOrders.ParamByName( 'ProductId').Value := adsCoreProductID.Value;
    adsPreviosOrders.Open;

    if adsCoreNamePromotionsCount.AsInteger > 0 then
      framePromotion.ShowPromotion(
        adsCoreshortcode.AsInteger,
        adsCorefullcode.AsInteger,
        adsCoreNamePromotionsCount.AsInteger)
    else
      framePromotion.HidePromotion();
  end;
end;

procedure TSynonymSearchForm.adsCoreBeforeClose(DataSet: TDataSet);
begin
  if adsPreviosOrders.Active then
    adsPreviosOrders.Close;
end;

procedure TSynonymSearchForm.adsCoreAfterOpen(DataSet: TDataSet);
begin
  tmrUpdatePreviosOrders.Enabled := False;
  tmrUpdatePreviosOrders.Enabled := True;
end;

procedure TSynonymSearchForm.adsCoreAfterScroll(DataSet: TDataSet);
begin
  tmrUpdatePreviosOrders.Enabled := False;
  tmrUpdatePreviosOrders.Enabled := True;
end;

procedure TSynonymSearchForm.InternalSearch;
var
  FilterSQL : String;
//  TmpSortList : TStringList;
//  I : Integer;
  StartSQL : String;
begin
//  adsCore.Options.CacheCalcFields := False;
//  adsCore.IndexFieldNames := '';

  if adsCore.Active then
    adsCore.Close;

  StartSQL := adsCoreStartSynonym.SQL.Text;
  if FSearchFilterController.AllowSearchFilter() then
    StartSQL := StartSQL + #13#10 + FSearchFilterController.GetSearchFilter() + adsCoreEndSynonym.SQL.Text;

  FilterSQL := GetSelectedPricesSQL(SelectedPrices, 'PRD.');
  lFilter.Visible := Length(FilterSQL) > 0;
  if lFilter.Visible then
    StartSQL := StartSQL + 'and (' + FilterSQL + ')';
  if cbBaseOnly.Checked then
    StartSQL := StartSQL + ' and (PRD.Enabled = 1)';
  if cbProducers.ItemIndex <> 0 then begin
    if cbProducers.ItemIndex = 1 then
      StartSQL := StartSQL + ' and (Core.CodeFirmCr = 0)'
    else
      StartSQL := StartSQL + ' and (Core.CodeFirmCr = ' + IntToStr(Integer(cbProducers.Items.Objects[cbProducers.ItemIndex])) + ')';
  end;

  StartSQL := StartSQL + ';'#13#10;

  if DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean then
    StartSQL := StartSQL + adsCoreByProducts.SQL.Text
  else
    StartSQL := StartSQL + adsCoreByFullcode.SQL.Text;

  adsCore.SQL.Text := StartSQL;

  //adsCore.ParamByName('LikeParam').AsString := '%' + InternalSearchText + '%';
  adsCore.ParamByName('ClientID').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  adsCore.ParamByName( 'TimeZoneBias').AsInteger := TimeZoneBias;
  adsCore.ParamByName( 'DayOfWeek').Value := TDayOfWeekHelper.DayOfWeek();
  FSearchFilterController.SetSearchParams(adsCore);


  ShowSQLWaiting(adsCore);

  {
  //TODO: ����� ���� �������� ������, ����� �� ���� ������ ������
  TmpSortList := SortList;
  SortList := nil;
  if Assigned(TmpSortList) then begin
    for I := 0 to TmpSortList.Count-1 do
      TmpSortList.Objects[i].Free;
    TmpSortList.Free;
  end;

  adsCore.DisableControls;
  try
    TmpSortList := GetSortedGroupList(adsCore, False, DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean);
  finally
    adsCore.EnableControls;
  end;

  SortList := TmpSortList;
  }

{
  adsCore.Close;
//    adsCore.DoSort(['SortOrder'], [True]);
  adsCore.Options.CacheCalcFields := True;
  adsCore.Open;
  adsCore.First;
  while not adsCore.Eof do begin
    adsCore.Next;
  end;
  adsCore.IndexFieldNames := 'SortOrder';
}
  adsCore.First;

  dbgCore.SetFocus;
end;

procedure TSynonymSearchForm.tmrSelectedPricesTimer(Sender: TObject);
begin
  tmrSelectedPrices.Enabled := False;
  if not tmrSearch.Enabled and (Length(InternalSearchText) > 0) and FSearchFilterController.AllowSearchFilter()
  then
    InternalSearch;
end;

procedure TSynonymSearchForm.cbProducersCloseUp(Sender: TObject);
begin
  if not tmrSearch.Enabled and (Length(InternalSearchText) > 0) and FSearchFilterController.AllowSearchFilter()
  then
    InternalSearch
  else
    dbgCore.SetFocus;
end;

function TSynonymSearchForm.SearchInProgress: Boolean;
begin
  Result := tmrSearch.Enabled;
end;

procedure TSynonymSearchForm.UpdateGridOnLegend(Sender: TObject);
begin
  dbgCore.Invalidate
end;

end.
