unit Orders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB,  DBCtrls, StdCtrls, Grids, DBGrids, RXDBCtrl,
  Placemnt, FR_DSet, FR_DBSet, DBGridEh, ToughDBGrid, ExtCtrls,
  DBProc, AProc, GridsEh, U_frameLegend, MemDS, DBAccess,
  MyAccess, ActnList, Buttons,
  Menus, U_frameBaseLegend,
  U_CurrentOrderItem,
  ContextMenuGrid, StrHlder,
  U_framePosition,
  U_frameMatchWaybill,
  U_LegendHolder;

type
  TOrdersForm = class(TChildForm)
    dsOrders: TDataSource;
    dbgOrders: TToughDBGrid;
    tmrCheckOrderCount: TTimer;
    adsOrders: TMyQuery;
    adsOrdersOrderId: TLargeintField;
    adsOrdersClientId: TLargeintField;
    adsOrdersCoreId: TLargeintField;
    adsOrdersfullcode: TLargeintField;
    adsOrdersproductid: TLargeintField;
    adsOrderscodefirmcr: TLargeintField;
    adsOrderssynonymcode: TLargeintField;
    adsOrderssynonymfirmcrcode: TLargeintField;
    adsOrderscode: TStringField;
    adsOrderscodecr: TStringField;
    adsOrderssynonymname: TStringField;
    adsOrderssynonymfirm: TStringField;
    adsOrdersawait: TBooleanField;
    adsOrdersjunk: TBooleanField;
    adsOrdersordercount: TIntegerField;
    adsOrdersprice: TFloatField;
    adsOrdersrequestratio: TIntegerField;
    adsOrdersordercost: TFloatField;
    adsOrdersminordercount: TIntegerField;
    adsOrdersOrdersrequestratio: TIntegerField;
    adsOrdersOrdersordercost: TFloatField;
    adsOrdersOrdersminordercount: TIntegerField;
    adsOrdersSumOrder: TCurrencyField;
    pClient: TPanel;
    gbMessageTo: TGroupBox;
    dbmMessageTo: TDBMemo;
    adsOrdersId: TLargeintField;
    adsOrdersRealPrice: TFloatField;
    adsOrdersDropReason: TSmallintField;
    adsOrdersServerCost: TFloatField;
    adsOrdersServerQuantity: TIntegerField;
    pTop: TPanel;
    pOrderHeader: TPanel;
    dbtPriceName: TDBText;
    Label1: TLabel;
    dbtId: TDBText;
    Label2: TLabel;
    dbtOrderDate: TDBText;
    lblRecordCount: TLabel;
    lblSum: TLabel;
    dbtPositions: TDBText;
    dbtSumOrder: TDBText;
    Label4: TLabel;
    Label5: TLabel;
    dbtRegionName: TDBText;
    lSumOrder: TLabel;
    cbNeedCorrect: TCheckBox;
    gbCorrectMessage: TGroupBox;
    mCorrectMessage: TMemo;
    adsOrdersSupplierPriceMarkup: TFloatField;
    adsOrdersProducerCost: TFloatField;
    adsOrdersNDS: TSmallintField;
    adsOrdersMnnId: TLargeintField;
    adsOrdersMnn: TStringField;
    ActionList: TActionList;
    pButtons: TPanel;
    btnGotoMNN: TSpeedButton;
    adsOrdersDescriptionId: TLargeintField;
    adsOrdersCatalogVitallyImportant: TBooleanField;
    adsOrdersCatalogMandatoryList: TBooleanField;
    actFlipCore: TAction;
    btnGotoCore: TSpeedButton;
    adsOrdersRetailPrice: TFloatField;
    adsOrdersRetailMarkup: TFloatField;
    adsOrdersMaxProducerCost: TFloatField;
    adsOrdersEditRetailMarkup: TFloatField;
    adsOrdersVitallyImportant: TBooleanField;
    btnGotoPrice: TSpeedButton;
    adsOrdersPeriod: TStringField;
    adsOrdersProducerName: TStringField;
    lDatePrice: TLabel;
    dbtDatePrice: TDBText;
    adsOrdersRetailCost: TFloatField;
    adsOrdersRetailVitallyImportant: TBooleanField;
    adsOrdersComment: TStringField;
    gbComment: TGroupBox;
    dbmComment: TDBMemo;
    adsOrdersMarkup: TFloatField;
    adsOrdersServerDocumentLineId: TLargeintField;
    adsOrdersRejectId: TLargeintField;
    adsOrdersServerDocumentId: TLargeintField;
    adsOrdersSupplierCost: TFloatField;
    adsOrdersWaybillQuantity: TIntegerField;
    pClientBottom: TPanel;
    pClientRight: TPanel;
    pClientLeft: TPanel;
    adsOrdersQuantity: TStringField;
    adsOrdersExp: TDateField;
    procedure dbgOrdersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgOrdersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgOrdersSortMarkingChanged(Sender: TObject);
    procedure adsOrdersOldAfterPost(DataSet: TDataSet);
    procedure dbgOrdersCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure dbgOrdersKeyPress(Sender: TObject; var Key: Char);
    procedure tmrCheckOrderCountTimer(Sender: TObject);
    procedure adsOrdersOldBeforePost(DataSet: TDataSet);
    procedure dbgOrdersDblClick(Sender: TObject);
    procedure dbmMessageToExit(Sender: TObject);
    procedure dbmMessageToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbNeedCorrectClick(Sender: TObject);
    procedure adsOrdersAfterScroll(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure btnGotoPriceClick(Sender: TObject);
    procedure dbmCommentExit(Sender: TObject);
    procedure dbmCommentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure adsOrdersAfterOpen(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
  private
    ParentOrdersHForm : TChildForm;
    OrderID,
    PriceCode : Integer;
    RegionCode : Int64;
    PriceName, RegionName : String;
    ClosedOrder : Boolean;
    EtalonSQL : String;
    //����� ����� ������� � ����������� ��������������, ������� �� �������
    //�� ����� ������� �������� ������
    OrderWithSendError : Boolean;
    dbgEditOrders: TDBGridEh;
    FContextMenuGrid : TContextMenuGrid;
    procedure SetOrderLabel;
    procedure ocf(DataSet: TDataSet);
    procedure FlipToCore;
    procedure PrepareEditOrdersGrid;
    procedure EditColumnGetCellParams(Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
    procedure OrderCountUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure RetailMarkupUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure RetailPriceUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure DeleteOrderPosition;
    procedure SetWaybillGrid;
    procedure UpdateMatchWaybillTimer;
    procedure SetHeightClientBottomPanel;
    procedure UpdateGridOnLegend(Sender : TObject);
  protected
    procedure UpdateOrderDataset; override;
    procedure AddRetailPriceColumn(dbgrid : TDBGridEh);
  public
    pGrid: TPanel;
    framePositionHeight,
    frameLegendHeight,
    frameWaybillHeight : Integer;
    framePosition : TframePosition;
    frameLegend : TframeLegend;
    frameMatchWaybill : TframeMatchWaybill;
    lMatchWaybill : TLabel;
    procedure ShowForm(OrderId: Integer; ParentForm : TChildForm; ExternalClosed : Boolean); overload; //reintroduce;
    procedure ShowForm; override;
    procedure Print( APreview: boolean = False); override;
    procedure SetParams(OrderId: Integer; ExternalClosed : Boolean);
  end;

implementation

uses OrdersH, DModule, Constant, Main, Math, CoreFirm, NamesForms, Core,
     PostSomeOrdersController, DBGridHelper,
     ToughDBGridColumns;

{$R *.dfm}

procedure TOrdersForm.ShowForm(OrderId: Integer; ParentForm : TChildForm; ExternalClosed : Boolean);
begin
  cbNeedCorrect.Checked := False;
  //PrintEnabled:=False;
  Self.OrderID := OrderId;
  SetParams(OrderId, ExternalClosed);
  inherited ShowForm;
  if Assigned(PrevForm) and (PrevForm is TOrdersHForm) then begin
    ParentOrdersHForm := PrevForm;
    dbgOrders.Tag := IfThen(TOrdersHForm(ParentOrdersHForm).TabControl.TabIndex = 1, 1, 2);
    SaveEnabled := TOrdersHForm(ParentOrdersHForm).TabControl.TabIndex = 1;
    PriceCode := TOrdersHForm(ParentOrdersHForm).adsOrdersHFormPRICECODE.AsInteger;
    RegionCode := TOrdersHForm(ParentOrdersHForm).adsOrdersHFormREGIONCODE.AsLargeInt;
    PriceName := TOrdersHForm(ParentOrdersHForm).adsOrdersHFormPRICENAME.AsString;
    RegionName := TOrdersHForm(ParentOrdersHForm).adsOrdersHFormREGIONNAME.AsString;

    dbmMessageTo.DataSource := TOrdersHForm(ParentOrdersHForm).dsOrdersH;
    dbtPriceName.DataSource := dbmMessageTo.DataSource;
    dbtId.DataSource := dbmMessageTo.DataSource;
    dbtOrderDate.DataSource := dbmMessageTo.DataSource;
    dbtPositions.DataSource := dbmMessageTo.DataSource;
    dbtSumOrder.DataSource := dbmMessageTo.DataSource;
    dbtRegionName.DataSource := dbmMessageTo.DataSource;
  end;
  if not ClosedOrder and DM.adsUser.FieldByName('SendRetailMarkup').AsBoolean then begin
    if dbgEditOrders.CanFocus then begin
      dbgEditOrders.SetFocus;
      dbgEditOrders.SelectedField := adsOrdersordercount;
    end;
  end
  else begin
    if dbgOrders.CanFocus then begin
      dbgOrders.SetFocus;
      dbgOrders.SelectedField := adsOrdersordercount;
    end;
  end;
end;

procedure TOrdersForm.SetParams(OrderId: Integer; ExternalClosed : Boolean);
var
  SendResult : Variant;
begin
  frameMatchWaybill.Visible := False;
  ClosedOrder := ExternalClosed;

  btnGotoPrice.Visible := not ClosedOrder;
  lMatchWaybill.Visible := ClosedOrder;
  if lMatchWaybill.Visible then
    lMatchWaybill.Visible := FGS.UseColorOnWaybillOrders;

  if not ClosedOrder and DM.adsUser.FieldByName('SendRetailMarkup').AsBoolean then begin
    dbgOrders.Visible := False;
    dbgEditOrders.Visible := True;
    dbgOrders.DataSource := nil;
    dbgEditOrders.DataSource := dsOrders;
    if dbgEditOrders.CanFocus then
      dbgEditOrders.SetFocus;
  end
  else begin
    dbgEditOrders.Visible := False;
    dbgOrders.Visible := True;
    dbgEditOrders.DataSource := nil;
    dbgOrders.DataSource := dsOrders;
    frameMatchWaybill.Visible := True;
    if dbgOrders.CanFocus then
      dbgOrders.SetFocus;
  end;

  //���������� ��������� � �������� ������������� ������ ���� ����� ������ � ������������ �������� ������������� �������
  gbCorrectMessage.Visible := (not ClosedOrder)  and FUseCorrectOrders;
  //���������� ���� �����-����� ������ ��� ������������� ������
  dbtDatePrice.Visible := ClosedOrder;
  lDatePrice.Visible := dbtDatePrice.Visible;
  if not gbCorrectMessage.Visible then
    pTop.Height := pOrderHeader.Height;
  if not ClosedOrder then
    SendResult := DM.QueryValue('select SendResult from CurrentOrderHeads where orderid = ' + IntToStr(OrderId), [], [])
  else
    SendResult := Null;
  OrderWithSendError := not VarIsNull(SendResult);
  adsOrders.OnCalcFields := ocf;
  if not ClosedOrder then begin
    adsOrders.SQL.Text := EtalonSQL;
    dbgOrders.InputField := 'OrderCount';
    dbgOrders.SearchField := '';
    dbgOrders.ForceRus := False;
    dbmMessageTo.ReadOnly := False;
    actFlipCore.Enabled := True;
  end
  else begin
    adsOrders.SQL.Text := StringReplace(EtalonSQL, 'CurrentOrderLists', 'PostedOrderLists', [rfReplaceAll, rfIgnoreCase]);
    dbgOrders.InputField := '';
    dbgOrders.SearchField := 'SynonymName';
    dbgOrders.ForceRus := True;
    dbmMessageTo.ReadOnly := True;
    actFlipCore.Enabled := False;
  end;
  dbmMessageTo.Color := Iif(dbmMessageTo.ReadOnly, clBtnFace, clWindow);
  with adsOrders do begin
    ParamByName('OrderId').Value:=OrderId;
    ParamByName('NeedCorrect').Value:=cbNeedCorrect.Checked;
    if Active
    then begin
      Close;
      Open;
    end
    else
      Open;
    SetOrderLabel;
  end;
  SetHeightClientBottomPanel;
end;

procedure TOrdersForm.Print( APreview: boolean = False);
begin
  if Assigned(ParentOrdersHForm) then
    DM.ShowOrderDetailsReport(
      TOrdersHForm(ParentOrdersHForm).adsOrdersHFormORDERID.AsInteger,
      TOrdersHForm(ParentOrdersHForm).adsOrdersHFormCLOSED.Value,
      TOrdersHForm(ParentOrdersHForm).adsOrdersHFormSEND.Value,
      APreview)
  else
    raise Exception.Create('�� ����������� ����� "������"!');
end;

procedure TOrdersForm.dbgOrdersGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  PositionResult : TPositionSendResult;
begin
  if adsOrdersVITALLYIMPORTANT.AsBoolean then
    AFont.Color := LegendHolder.Legends[lnVitallyImportant];

  //��������� ����� �������� �������
  if adsOrdersAwait.AsBoolean and ( Column.Field = adsOrdersSYNONYMNAME) then
    Background := LegendHolder.Legends[lnAwait];

  if not adsOrdersRejectId.IsNull then
    Background := LegendHolder.Legends[lnRejectedColor];

  if FUseCorrectOrders and not adsOrdersDropReason.IsNull then begin
    PositionResult := TPositionSendResult(adsOrdersDropReason.AsInteger);

    //�� ����� ����� �������� ��������� �����������, �� ��� ������� ��������,
    //�.�. ���������� � ������������� ������ ������� ������
    if ( Column.Field = adsOrderssynonymname) and (PositionResult = psrNotExists)
    then
      Background := LegendHolder.Legends[lnNeedCorrect];

    if ( Column.Field = adsOrdersSumOrder)
      and (PositionResult in [psrDifferentCost, psrDifferentCostAndQuantity])
    then
      Background := LegendHolder.Legends[lnNeedCorrect];

    if ( Column.Field = adsOrdersordercount)
      and (PositionResult in [psrDifferentQuantity, psrDifferentCostAndQuantity])
    then
      Background := LegendHolder.Legends[lnNeedCorrect];
  end;
  { ���� ��������� �����, �������� ���� }
  if adsOrdersJunk.AsBoolean and ( Column.Field = adsOrdersPRICE) then
    Background := LegendHolder.Legends[lnJunk];

  if ClosedOrder and FGS.UseColorOnWaybillOrders then begin
    if adsOrdersServerDocumentId.IsNull then
      Background := LegendHolder.Legends[lnMatchWaybill]
    else begin
      if adsOrdersWaybillQuantity.Value < adsOrdersordercount.Value then
        Background := LegendHolder.Legends[lnMatchWaybill];

      if (abs(adsOrdersRealPrice.Value - adsOrdersSupplierCost.Value) > 0.02) then
        Background := LegendHolder.Legends[lnMatchWaybill];
    end;
  end;
end;

procedure TOrdersForm.dbgOrdersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN)
  then begin
    if dbgEditOrders.Visible and
      (   (dbgEditOrders.SelectedField = adsOrdersordercount)
        or (dbgEditOrders.SelectedField = adsOrdersRetailPrice)
        or (dbgEditOrders.SelectedField = adsOrdersEditRetailMarkup))
    then
      //���� �� ����� ������������� ����, �� ����� �� ������������ Enter,
      //�������� ���������� Enter ����� ������
    else
      if not dbmMessageTo.ReadOnly then
        FlipToCore;
  end
  else
    if Key = VK_ESCAPE then begin
      if dbgEditOrders.Visible and dbgEditOrders.EditorMode then
      else
        if Assigned(ParentOrdersHForm) then
          ParentOrdersHForm.ShowAsPrevForm
        else
          if Assigned(PrevForm) then
            PrevForm.ShowAsPrevForm;
    end
    else
      if (Key = VK_DELETE) then begin
        if (Sender = dbgEditOrders) then
          DeleteOrderPosition
        else begin
          //���� ������� �� dbgEditOrders, �� ��� dbgOrders, ��� ��� �� ������������
          //������� ������� Delete � �������� "������� ��������", �� ������� ��� �������
          Key := 0;
          if not ClosedOrder then
            //������� ������� ������ �� ������� �������
            DeleteOrderPosition;
        end;
      end;
end;

procedure TOrdersForm.dbgOrdersSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TOrdersForm.adsOrdersOldAfterPost(DataSet: TDataSet);
begin
  SetOrderLabel;
  MainForm.SetOrdersInfo;
  if Assigned(ParentOrdersHForm) then
    TOrdersHForm(ParentOrdersHForm).adsOrdersHForm.RefreshRecord;
  //���� ������� ������� �� ������, �� ��������� ������ �� �������� ���� ������� �� DataSet
  if (adsOrdersORDERCOUNT.AsInteger = 0) then begin
    adsOrders.Delete;
    tmrCheckOrderCount.Enabled := False;
    tmrCheckOrderCount.Enabled := True;
  end;
end;

procedure TOrdersForm.SetOrderLabel;
begin
  lSumOrder.Caption := Format('%0.2f', [ DM.GetSumOrder(OrderID, ClosedOrder) ]);
end;

procedure TOrdersForm.dbgOrdersCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
  inherited;
  CanInput := (not adsOrders.IsEmpty) and Assigned(ParentOrdersHForm) and (TOrdersHForm(ParentOrdersHForm).TabControl.TabIndex = 0);
end;

procedure TOrdersForm.FormCreate(Sender: TObject);
begin
  pGrid := TPanel.Create(Self);
  pGrid.Parent := pClient;
  pGrid.Name := 'pGrid';
  pGrid.Caption := '';
  pGrid.BevelOuter := bvNone;
  pGrid.Align := alClient;
  dbgOrders.Parent := pGrid;

  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
  pClient.ControlStyle := pClient.ControlStyle - [csParentBackground] + [csOpaque];
  pClientBottom.ControlStyle := pClientBottom.ControlStyle - [csParentBackground] + [csOpaque];
  pClientRight.ControlStyle := pClientRight.ControlStyle - [csParentBackground] + [csOpaque];
  pClientLeft.ControlStyle := pClientLeft.ControlStyle - [csParentBackground] + [csOpaque];
  gbCorrectMessage.ControlStyle := gbCorrectMessage.ControlStyle - [csParentBackground] + [csOpaque];
  gbComment.ControlStyle := gbComment.ControlStyle - [csParentBackground] + [csOpaque];

  dbgEditOrders:= TDBGridEh.Create(Self);
  dbgEditOrders.Parent := pGrid;
  dbgEditOrders.Align := alClient;
  dbgEditOrders.Visible := False;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgEditOrders);
  dbgEditOrders.Options := dbgEditOrders.Options + [dgEditing];
  dbgEditOrders.Columns.Assign(dbgOrders.Columns);
  dbgEditOrders.SelectedField := adsOrdersordercount;
  dbgEditOrders.OnDblClick := dbgOrdersDblClick;
  dbgEditOrders.OnGetCellParams := dbgOrdersGetCellParams;
  dbgEditOrders.OnKeyDown := dbgOrdersKeyDown;
  dbgEditOrders.OnKeyPress := dbgOrdersKeyPress;
  dbgEditOrders.OnSortMarkingChanged := dbgOrdersSortMarkingChanged;

  FContextMenuGrid := TContextMenuGrid.Create(dbgEditOrders, DM.SaveGridMask);

  EtalonSQL := adsOrders.SQL.Text;
  dsCheckVolume := adsOrders;
  if DM.adsUser.FieldByName('SendRetailMarkup').AsBoolean then
    dgCheckVolume := TToughDBGrid(dbgEditOrders)
  else
    dgCheckVolume := dbgOrders;

  fOrder := adsOrdersORDERCOUNT;
  fVolume := adsOrdersREQUESTRATIO;
  fOrderCost := adsOrdersORDERCOST;
  fSumOrder := adsOrdersSUMORDER;
  fMinOrderCount := adsOrdersMINORDERCOUNT;
  fCoreQuantity := adsOrdersQuantity;
  disableCoreQuantityCheck := True;
  disableClearOrder := True;
  gotoMNNButton := btnGotoMNN;

  SetWaybillGrid;

  inherited;

  frameLegend := TframeLegend.CreateFrame(Self, False, False, False);
  frameLegendHeight := frameLegend.Height;
  frameLegend.Parent := pClientBottom;
  frameLegend.Align := alTop;
  frameLegend.UpdateGrids := UpdateGridOnLegend;
  lMatchWaybill := frameLegend.CreateLegendLabel(lnMatchWaybill);

  if dgCheckVolume <> dbgOrders then
    PrepareColumnsInOrderGrid(dbgOrders);

  AddRetailPriceColumn(dbgOrders);
  AddRetailPriceColumn(dbgEditOrders);

  PrepareEditOrdersGrid;

  framePosition := TframePosition.AddFrame(Self, pClientLeft, dsOrders, 'SynonymName', 'MnnId', ShowDescriptionAction);
  framePositionHeight := framePosition.Height;
  framePosition.Align := alClient;
  TDBGridHelper.RestoreColumnsLayout(dbgOrders, 'DetailOrder');
  TDBGridHelper.RestoreColumnsLayout(dbgEditOrders, 'DetailOrder');
end;

procedure TOrdersForm.dbgOrdersKeyPress(Sender: TObject; var Key: Char);
const
  SymbolsForEdit = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '.'];
var
  _CoreFirmForm : TCoreFirmForm;
begin
  if Assigned(ParentOrdersHForm)
    and (TOrdersHForm(ParentOrdersHForm).TabControl.TabIndex = 0)
    and ( Key > #32)
    and not ( Key in SymbolsForEdit)
  then begin
    _CoreFirmForm := TCoreFirmForm( FindChildControlByClass(MainForm, TCoreFirmForm) );
    if not Assigned(_CoreFirmForm) then
      _CoreFirmForm := TCoreFirmForm.Create(Application);
    _CoreFirmForm.ShowForm(PriceCode, RegionCode, PriceName, RegionName, False, True);
    _CoreFirmForm.dbgCore.SetFocus;
    _CoreFirmForm.eSearch.Text := '';
    SendMessage(GetFocus, WM_CHAR, Ord( Key), 0);
  end
  else begin
    if (Sender = dbgEditOrders)
      and ((dbgEditOrders.SelectedField = adsOrdersordercount)
      or (dbgEditOrders.SelectedField = adsOrdersRetailPrice)
      or (dbgEditOrders.SelectedField = adsOrdersEditRetailMarkup))
    then begin
      if (Key in ['.', ',']) and (Key <> DecimalSeparator) then
        Key := DecimalSeparator;
    end;

    if (Sender = dbgEditOrders)
      and (dbgEditOrders.SelectedField <> adsOrdersordercount)
      and (dbgEditOrders.SelectedField <> adsOrdersRetailPrice)
      and (dbgEditOrders.SelectedField <> adsOrdersEditRetailMarkup)
    then begin
      if (Key in SymbolsForEdit) then begin
        dbgEditOrders.SelectedField := adsOrdersordercount;
        SendMessage(dbgEditOrders.Handle, WM_CHAR, Ord( Key), 0);
        Key := #0;
      end;
    end;
  end;
end;

procedure TOrdersForm.ShowForm;
begin
  inherited;
  //���� �� ���������� ������� �� ����� "������ ����������", �� ���� �������� ������
  if Assigned(PrevForm) and ((PrevForm is TCoreFirmForm) or (PrevForm is TCoreForm)) then
    SetParams(OrderID, ClosedOrder);
end;

procedure TOrdersForm.tmrCheckOrderCountTimer(Sender: TObject);
begin
  tmrCheckOrderCount.Enabled := False;
  //adsOrders.Refresh;
  SetOrderLabel;
  MainForm.SetOrdersInfo;
  //adsOrders.Delete;
  if adsOrders.RecordCount = 0 then begin
    //todo: ���� ����� �������� � ���, ����� ������������ �������� ��������� ������
    //DM.adcUpdate.SQL.Text := 'delete from CurrentOrderHeads where OrderId = ' + IntToStr(OrderID);
    //DM.adcUpdate.Execute;
    if Assigned(ParentOrdersHForm) then begin
      TOrdersHForm(ParentOrdersHForm).adsOrdersHForm.Close;
      TOrdersHForm(ParentOrdersHForm).adsOrdersHForm.Open;
    end;
    MainForm.SetOrdersInfo;
    PrevForm.ShowAsPrevForm;
  end
  else begin
    if Assigned(ParentOrdersHForm) then
     TOrdersHForm(ParentOrdersHForm).adsOrdersHForm.RefreshRecord;
    MainForm.SetOrdersInfo;
  end;
end;

procedure TOrdersForm.ocf(DataSet: TDataSet);
begin
  try
    if adsOrdersRetailCost.IsNull then begin
      if FAllowDelayOfPayment and not FShowSupplierCost then begin
        adsOrdersRetailPrice.AsCurrency := DM
          .GetRetailCostLast(
            adsOrdersRetailVitallyImportant.Value,
            adsOrdersPrice.AsCurrency,
            adsOrdersMarkup.AsVariant);
        adsOrdersEditRetailMarkup.AsCurrency := DM
          .GetRetailMarkupValue(
            adsOrdersRetailVitallyImportant.Value,
            adsOrdersPrice.AsCurrency,
            adsOrdersMarkup.AsVariant);
      end
      else begin
        adsOrdersRetailPrice.AsCurrency := DM
          .GetRetailCostLast(
            adsOrdersRetailVitallyImportant.Value,
            adsOrdersRealPrice.AsCurrency,
            adsOrdersMarkup.AsVariant);
        adsOrdersEditRetailMarkup.AsCurrency := DM
          .GetRetailMarkupValue(
            adsOrdersRetailVitallyImportant.Value,
            adsOrdersRealPrice.AsCurrency,
            adsOrdersMarkup.AsVariant);
      end;
    end
    else begin
      adsOrdersRetailPrice.AsCurrency := adsOrdersRetailCost.AsCurrency;
      if FAllowDelayOfPayment and not FShowSupplierCost then
        adsOrdersEditRetailMarkup.AsCurrency := DM.GetRetUpCostByRetailCost(adsOrdersPrice.AsCurrency, adsOrdersRetailCost.AsCurrency)
      else
        adsOrdersEditRetailMarkup.AsCurrency := DM.GetRetUpCostByRetailCost(adsOrdersRealPrice.AsCurrency, adsOrdersRetailCost.AsCurrency);
    end;

    if FAllowDelayOfPayment and not FShowSupplierCost then
      adsOrdersSumOrder.AsCurrency := adsOrdersPrice.AsCurrency * adsOrdersORDERCOUNT.AsInteger
    else
      adsOrdersSumOrder.AsCurrency := adsOrdersRealPrice.AsCurrency * adsOrdersORDERCOUNT.AsInteger;
  except
  end;
end;

procedure TOrdersForm.adsOrdersOldBeforePost(DataSet: TDataSet);
var
  PanelCaption : String;
begin
  PanelCaption := '';

  if (adsOrdersORDERCOUNT.AsInteger > WarningOrderCount) then
    if Length(PanelCaption) > 0 then
      PanelCaption := PanelCaption + #13#10 + WarningOrderCountMessage
    else
      PanelCaption := WarningOrderCountMessage;

  if Length(PanelCaption) > 0 then begin
    if DM.adsUser.FieldByName('SendRetailMarkup').AsBoolean then
      ShowOverCostPanel(PanelCaption, dbgEditOrders)
    else
      ShowOverCostPanel(PanelCaption, dbgOrders);
  end;
end;

procedure TOrdersForm.FlipToCore;
var
  FullCode, ShortCode: integer;
  CoreId : Int64;
begin
  if MainForm.ActiveChild <> Self then exit;
  if adsOrders.IsEmpty then Exit;

  FullCode := adsOrdersFullCode.AsInteger;
  ShortCode := DM.QueryValue('select ShortCode from catalogs where FullCode = ' + IntToStr(FullCode), [] , []);

  CoreId := adsOrdersCOREID.AsLargeInt;

  FlipToCodeWithReturn(FullCode, ShortCode, CoreId);
end;

procedure TOrdersForm.dbgOrdersDblClick(Sender: TObject);
begin
  if (not dbmMessageTo.ReadOnly) then
    FlipToCore
end;

procedure TOrdersForm.dbmMessageToExit(Sender: TObject);
begin
  try
    if Assigned(ParentOrdersHForm) then
      SoftPost(TOrdersHForm(ParentOrdersHForm).adsOrdersHForm);
  except
  end;
end;

procedure TOrdersForm.dbmMessageToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    if Assigned(ParentOrdersHForm) then
      ParentOrdersHForm.ShowAsPrevForm
    else
      PrevForm.ShowAsPrevForm;
end;

procedure TOrdersForm.cbNeedCorrectClick(Sender: TObject);
begin
  SetParams(OrderID, ClosedOrder);
  dbgOrders.SetFocus;
end;

procedure TOrdersForm.adsOrdersAfterScroll(DataSet: TDataSet);
var
  PositionResult : TPositionSendResult;
  CorrectMessage : String;
  newOrder, oldOrder, newCost, oldCost : String;
begin
  UpdateMatchWaybillTimer;
  if FUseCorrectOrders and not adsOrdersDropReason.IsNull then begin
    PositionResult := TPositionSendResult(adsOrdersDropReason.AsInteger);
    CorrectMessage := PositionSendResultText[PositionResult];
    CorrectMessage := CorrectMessage + ' (';
    if PositionResult = psrNotExists then begin
      CorrectMessage := CorrectMessage +
        Format(
          '������ ����: %s; ������ �����: %s',
          [adsOrdersServerCost.AsString,
          adsOrdersServerQuantity.AsString]);
    end
    else begin
      if OrderWithSendError then begin
        newOrder := adsOrdersServerQuantity.AsString;
        newCost := adsOrdersServerCost.AsString;
        oldOrder := adsOrdersordercount.AsString;
        oldCost := adsOrdersprice.AsString;
      end
      else begin
        newOrder := adsOrdersordercount.AsString;
        newCost := adsOrdersprice.AsString;
        oldOrder := adsOrdersServerQuantity.AsString;
        oldCost := adsOrdersServerCost.AsString;
      end;

      if PositionResult in [psrDifferentCost, psrDifferentCostAndQuantity] then
        CorrectMessage := CorrectMessage +
          Format('������ ����: %s; ����� ����: %s', [oldCost, newCost]);

      if PositionResult in [psrDifferentQuantity, psrDifferentCostAndQuantity] then
        CorrectMessage := CorrectMessage +
          Format('������ �����: %s; ����� �����: %s', [oldOrder, newOrder]);
    end;
    CorrectMessage := CorrectMessage + ')';
    mCorrectMessage.Text := CorrectMessage;
  end
  else
    mCorrectMessage.Text := '';
end;

procedure TOrdersForm.FormDestroy(Sender: TObject);
begin
  FContextMenuGrid.Free;
  inherited;
  TDBGridHelper.SaveColumnsLayout(dbgEditOrders, 'DetailOrder');
  TDBGridHelper.SaveColumnsLayout(dbgOrders, 'DetailOrder');
end;

procedure TOrdersForm.actFlipCoreExecute(Sender: TObject);
begin
  FlipToCore
end;

procedure TOrdersForm.UpdateOrderDataset;
var
  lastCoreId : Variant;
begin
  if not dbmMessageTo.ReadOnly then begin
    lastCoreId := adsOrdersCoreId.AsVariant;
    SetParams(OrderID, ClosedOrder);
    if adsOrders.RecordCount > 0 then begin
      if not adsOrders.Locate('CoreId', lastCoreId, []) then
        adsOrders.First;
      if Assigned(ParentOrdersHForm) then
        TOrdersHForm(ParentOrdersHForm).adsOrdersHForm.RefreshRecord;
    end
    else begin
      MainForm.SetOrdersInfo;
      if Assigned(ParentOrdersHForm) then begin
        TOrdersHForm(ParentOrdersHForm).adsOrdersHForm.Close;
        TOrdersHForm(ParentOrdersHForm).adsOrdersHForm.Open;
        ParentOrdersHForm.ShowAsPrevForm;
      end;
    end;
  end;
end;

procedure TOrdersForm.AddRetailPriceColumn(dbgrid : TDBGridEh);
var
  orderCountColumn : TColumnEh;
  retailPriceColumn : TColumnEh;
  retailMarkupColumn : TColumnEh;
  realPriceCoumn : TColumnEh;
  priceColumn : TColumnEh;
begin
  if DM.adsUser.FieldByName('SendRetailMarkup').AsBoolean then begin
    orderCountColumn := ColumnByNameT(TToughDBGrid(dbgrid), adsOrdersordercount.FieldName);
    if Assigned(orderCountColumn) then begin
      retailPriceColumn := ColumnByNameT(TToughDBGrid(dbgrid), adsOrdersRetailPrice.FieldName);
      if not Assigned(retailPriceColumn) then begin
        retailPriceColumn := TColumnEh(dbgrid.Columns.Insert(orderCountColumn.Index));
        retailPriceColumn.FieldName := adsOrdersRetailPrice.FieldName;
        retailPriceColumn.Title.Caption := '����.����';
        retailPriceColumn.Title.TitleButton := True;
      end;
      retailMarkupColumn := ColumnByNameT(TToughDBGrid(dbgrid), adsOrdersEditRetailMarkup.FieldName);
      if not Assigned(retailMarkupColumn) then begin
        retailMarkupColumn := TColumnEh(dbgrid.Columns.Insert(retailPriceColumn.Index));
        retailMarkupColumn.FieldName := adsOrdersEditRetailMarkup.FieldName;
        retailMarkupColumn.Title.Caption := '����.�������';
        retailMarkupColumn.Title.TitleButton := True;
      end;
    end;
  end;
  if FAllowDelayOfPayment and FShowSupplierCost then begin
    realPriceCoumn := ColumnByNameT(TToughDBGrid(dbgrid), adsOrdersRealPrice.FieldName);
    priceColumn := ColumnByNameT(TToughDBGrid(dbgrid), adsOrdersprice.FieldName);
    if Assigned(realPriceCoumn) and Assigned(priceColumn) then begin
      priceColumn.Font.Style := priceColumn.Font.Style - [fsBold];
      realPriceCoumn.Font.Style := realPriceCoumn.Font.Style + [fsBold];
    end;
  end;
end;

procedure TOrdersForm.PrepareEditOrdersGrid;
var
  I : Integer;
  editColumn : TColumnEh;
begin
  if DM.adsUser.FieldByName('SendRetailMarkup').AsBoolean then begin
    dbgEditOrders.ReadOnly := True;
    for I := 0 to dbgEditOrders.Columns.Count-1 do
      dbgEditOrders.Columns[i].ReadOnly := True;

    editColumn := ColumnByNameT(TToughDBGrid(dbgEditOrders), adsOrdersRetailPrice.FieldName);
    if Assigned(editColumn) then begin
      editColumn.ReadOnly := False;
      editColumn.OnGetCellParams := EditColumnGetCellParams;
      editColumn.OnUpdateData := RetailPriceUpdateData;
    end;

    editColumn := ColumnByNameT(TToughDBGrid(dbgEditOrders), adsOrdersEditRetailMarkup.FieldName);
    if Assigned(editColumn) then begin
      editColumn.ReadOnly := False;
      editColumn.OnGetCellParams := EditColumnGetCellParams;
      editColumn.OnUpdateData := RetailMarkupUpdateData;
    end;

    editColumn := ColumnByNameT(TToughDBGrid(dbgEditOrders), adsOrdersordercount.FieldName);
    if Assigned(editColumn) then begin
      editColumn.ReadOnly := False;
      editColumn.OnGetCellParams := EditColumnGetCellParams;
      editColumn.OnUpdateData := OrderCountUpdateData;
    end;
  end;
end;

procedure TOrdersForm.EditColumnGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if (Sender is TColumnEh) and Params.ReadOnly then
    Params.ReadOnly := False;
end;

procedure TOrdersForm.OrderCountUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  orderCount : Integer;
begin
  if (adsOrders.State in [dsEdit])
  then begin
    if (Length(Text) > 0) and (StrToIntDef(Value, -1) >= 0) then begin
      orderCount := Value;
      if (orderCount >= 0) then begin
        adsOrdersordercount.Value := orderCount;
        adsOrders.Post;
      end
      else
        adsOrders.Cancel;
    end;
    Handled := True;
  end;
end;

procedure TOrdersForm.RetailMarkupUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  markup: Double;
begin
  if (adsOrders.State in [dsEdit])
  then begin
    if StrToFloatDef(Value, 0.0) > 0 then begin
      markup := Value;
      if (markup > 0) then begin
        if FAllowDelayOfPayment and not FShowSupplierCost then
          adsOrdersRetailCost.AsVariant := DM.GetPriceRetByMarkup(
            adsOrdersPrice.AsCurrency,
            markup)
        else
          adsOrdersRetailCost.AsVariant := DM.GetPriceRetByMarkup(
            adsOrdersRealPrice.AsCurrency,
            markup);
        adsOrders.Post;
      end
      else
        adsOrders.Cancel;
    end;
    Handled := True;
  end;
end;

procedure TOrdersForm.RetailPriceUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  price : Double;
begin
  if (adsOrders.State in [dsEdit])
  then begin
    if StrToFloatDef(Value, 0.0) > 0 then begin
      price := Value;
      if (price > 0) then begin
        adsOrdersRetailCost.AsVariant := price;
        adsOrders.Post;
      end
      else
        adsOrders.Cancel;
    end;
    Handled := True;
  end;
end;

procedure TOrdersForm.btnGotoPriceClick(Sender: TObject);
var
  _CoreFirmForm : TCoreFirmForm;
begin
{
  ���� ��������� ������� �����������:
    if CheckWin32Version(5, 1) then
      Params.ExStyle := Params.ExStyle or WS_EX_COMPOSITED;
  �� ��� ������ ������ ����� ����� ����� ��������� �������� ���� �����,
  ��������� � TframePosition.
}

  if Assigned(ParentOrdersHForm)
    and (TOrdersHForm(ParentOrdersHForm).TabControl.TabIndex = 0)
  then begin
    _CoreFirmForm := TCoreFirmForm( FindChildControlByClass(MainForm, TCoreFirmForm) );
    if not Assigned(_CoreFirmForm) then
      _CoreFirmForm := TCoreFirmForm.Create(Application);
    _CoreFirmForm.ShowForm(PriceCode, RegionCode, PriceName, RegionName, False, False);
    _CoreFirmForm.dbgCore.SetFocus;
  end;
end;

procedure TOrdersForm.dbmCommentExit(Sender: TObject);
begin
  try
    SoftPost(adsOrders);
  except
  end;
end;

procedure TOrdersForm.dbmCommentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    if Assigned(ParentOrdersHForm) then
      ParentOrdersHForm.ShowAsPrevForm
    else
      PrevForm.ShowAsPrevForm;
end;

procedure TOrdersForm.DeleteOrderPosition;
begin
  if AProc.MessageBox('������� �������?', MB_ICONQUESTION or MB_YESNO) = IDYES then begin
    adsOrders.Delete();
    tmrCheckOrderCount.Enabled := False;
    tmrCheckOrderCount.Enabled := True;
  end;
end;

procedure TOrdersForm.SetWaybillGrid;
begin
  frameWaybillHeight := 150;

  frameMatchWaybill := TframeMatchWaybill.AddFrame(Self, pClientBottom, adsOrders);
  frameMatchWaybill.Visible := False;
  frameMatchWaybill.Height := frameWaybillHeight;
  frameMatchWaybill.Align := alBottom;
end;

procedure TOrdersForm.UpdateMatchWaybillTimer;
begin
  if ClosedOrder then begin
    frameMatchWaybill.UpdateMatchWaybillTimer;
  end;
end;

procedure TOrdersForm.adsOrdersAfterOpen(DataSet: TDataSet);
begin
  UpdateMatchWaybillTimer;
end;

procedure TOrdersForm.FormResize(Sender: TObject);
begin
  pClientRight.Width := pClientBottom.Width div 2;
end;

procedure TOrdersForm.SetHeightClientBottomPanel;
var
  panelHeight : Integer;
begin
  panelHeight := frameLegendHeight + framePositionHeight;
  if gbCorrectMessage.Visible then
    panelHeight := panelHeight + gbCorrectMessage.Height;
  if gbComment.Visible then
    panelHeight := panelHeight + gbComment.Height;
  if frameMatchWaybill.Visible then
    panelHeight := panelHeight + frameWaybillHeight;
  pClientBottom.Height := panelHeight + 10;
end;

procedure TOrdersForm.UpdateGridOnLegend(Sender: TObject);
begin
  dbgOrders.Invalidate;
end;

end.
