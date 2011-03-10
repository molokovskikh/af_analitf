unit Orders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB,  DBCtrls, StdCtrls, Grids, DBGrids, RXDBCtrl,
  Placemnt, FR_DSet, FR_DBSet, DBGridEh, ToughDBGrid, ExtCtrls, 
  DBProc, AProc, GridsEh, U_frameLegend, MemDS, DBAccess,
  MyAccess, ActnList, Buttons,
  Menus, U_frameBaseLegend,
  U_CurrentOrderItem;

type
  TOrdersForm = class(TChildForm)
    dsOrders: TDataSource;
    dbgOrders: TToughDBGrid;
    tmrCheckOrderCount: TTimer;
    plOverCost: TPanel;
    lWarning: TLabel;
    Timer: TTimer;
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
    procedure TimerTimer(Sender: TObject);
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
  private
    ParentOrdersHForm : TChildForm;
    OrderID,
    PriceCode : Integer;
    RegionCode : Int64;
    PriceName, RegionName : String;
    ClosedOrder : Boolean;
    EtalonSQL : String;
    //Заказ имеет позиции с необходимой корректировкой, которые он получил
    //во время попытки отправки заказа
    OrderWithSendError : Boolean;
    dbgEditOrders: TDBGridEh;
    FGridPopup : TPopupMenu;
    FGridColumns : TMenuItem;
    procedure SetOrderLabel;
    procedure ocf(DataSet: TDataSet);
    procedure FlipToCore;
    procedure PrepareEditOrdersGrid;
    procedure EditColumnGetCellParams(Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
    procedure OrderCountUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure RetailMarkupUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure RetailPriceUpdateData(Sender: TObject; var Text: String; var Value: Variant; var UseText, Handled: Boolean);
  protected
    procedure UpdateOrderDataset; override;
    procedure AddRetailPriceColumn(dbgrid : TDBGridEh);
    procedure OnPopupGridColumnsClick( Sender: TObject);
  public
    frameLegend : TframeLegend;
    procedure ShowForm(OrderId: Integer; ParentForm : TChildForm; ExternalClosed : Boolean); overload; //reintroduce;
    procedure ShowForm; override;
    procedure Print( APreview: boolean = False); override;
    procedure SetParams(OrderId: Integer; ExternalClosed : Boolean);
  end;

implementation

uses OrdersH, DModule, Constant, Main, Math, CoreFirm, NamesForms, Core,
     PostSomeOrdersController, U_framePosition, DBGridHelper,
     ToughDBGridColumns;

{$R *.dfm}

procedure TOrdersForm.ShowForm(OrderId: Integer; ParentForm : TChildForm; ExternalClosed : Boolean);
begin
  plOverCost.Hide();
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
  ClosedOrder := ExternalClosed;
  
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
    if dbgOrders.CanFocus then
      dbgOrders.SetFocus;
  end;

  //Отображаем сообщение с причиной корректировки только если заказ открыт и используется механизм корректировки заказов
  gbCorrectMessage.Visible := (not ClosedOrder)  and FUseCorrectOrders;
  //Отображаем дату прайс-листа только для отправленного заказа
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
    dbgOrders.SearchField := '';
    dbgOrders.ForceRus := False;
    dbmMessageTo.ReadOnly := False;
    actFlipCore.Enabled := True;
  end
  else begin
    adsOrders.SQL.Text := StringReplace(EtalonSQL, 'CurrentOrderLists', 'PostedOrderLists', [rfReplaceAll, rfIgnoreCase]);
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
    raise Exception.Create('Не установлена форма "Заказы"!');
end;

procedure TOrdersForm.dbgOrdersGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  PositionResult : TPositionSendResult;
begin
  if adsOrdersVITALLYIMPORTANT.AsBoolean then
    AFont.Color := VITALLYIMPORTANT_CLR;

  //ожидаемый товар выделяем зеленым
  if adsOrdersAwait.AsBoolean and ( Column.Field = adsOrdersSYNONYMNAME) then
    Background := AWAIT_CLR;

  if FUseCorrectOrders and not adsOrdersDropReason.IsNull then begin
    PositionResult := TPositionSendResult(adsOrdersDropReason.AsInteger);

    //Мы здесь можем затереть подсветку ожидаемости, но это сделано осознано,
    //т.к. информация о невозможности заказа позиции важнее
    if ( Column.Field = adsOrderssynonymname) and (PositionResult = psrNotExists)
    then
      Background := NeedCorrectColor;

    if ( Column.Field = adsOrdersSumOrder)
      and (PositionResult in [psrDifferentCost, psrDifferentCostAndQuantity])
    then
      Background := NeedCorrectColor;

    if ( Column.Field = adsOrdersordercount)
      and (PositionResult in [psrDifferentQuantity, psrDifferentCostAndQuantity])
    then
      Background := NeedCorrectColor;
  end;
  { если уцененный товар, изменяем цвет }
  if adsOrdersJunk.AsBoolean and ( Column.Field = adsOrdersPRICE) then
    Background := JUNK_CLR;
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
      //Если мы можем редактировать поля, то никак не обрабатываем Enter,
      //позволяя обработать Enter самим гридом
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
  //Если удалили позицию из заказа, то запускаем таймер на удаление этой позиции из DataSet
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
  btnGotoPrice.Visible := False;

  dbgEditOrders:= TDBGridEh.Create(Self);
  dbgEditOrders.Parent := pClient;
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

  FGridPopup := TPopupMenu.Create( Self);
  dbgEditOrders.PopupMenu := FGridPopup;
  FGridColumns := TMenuItem.Create(FGridPopup);
  FGridColumns.Caption := 'Столбцы...';
  FGridColumns.OnClick := OnPopupGridColumnsClick;
  FGridPopup.Items.Add(FGridColumns);

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
  gotoMNNButton := btnGotoMNN;

  inherited;

  frameLegend := TframeLegend.CreateFrame(Self, False, False, False);
  frameLegend.Parent := Self;
  frameLegend.Align := alBottom;

  if dgCheckVolume <> dbgOrders then
    PrepareColumnsInOrderGrid(dbgOrders);

  AddRetailPriceColumn(dbgOrders);
  AddRetailPriceColumn(dbgEditOrders);

  PrepareEditOrdersGrid;

  TframePosition.AddFrame(Self, pClient, dsOrders, 'SynonymName', 'MnnId', ShowDescriptionAction);
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
  //Если мы производим возврат из формы "Заявка поставщику", то надо обновить данные
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
    //todo: надо потом подумать о том, чтобы восстановить удаление заголовка заказа
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

procedure TOrdersForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  plOverCost.Hide;
  plOverCost.SendToBack;
end;

procedure TOrdersForm.ocf(DataSet: TDataSet);
begin
  try
    if adsOrdersRetailCost.IsNull then begin
      adsOrdersRetailPrice.AsCurrency := DM.GetPriceRet(adsOrdersRealPrice.AsCurrency);
      adsOrdersEditRetailMarkup.AsCurrency := DM.GetRetUpCost(adsOrdersRealPrice.AsCurrency);
    end
    else begin
      adsOrdersRetailPrice.AsCurrency := adsOrdersRetailCost.AsCurrency;
      adsOrdersEditRetailMarkup.AsCurrency := DM.GetRetUpCostByRetailCost(adsOrdersRealPrice.AsCurrency, adsOrdersRetailCost.AsCurrency);
    end;

    adsOrdersSumOrder.AsCurrency := adsOrdersRealPrice.AsCurrency * adsOrdersORDERCOUNT.AsInteger;
  except
  end;
end;

procedure TOrdersForm.adsOrdersOldBeforePost(DataSet: TDataSet);
var
  PanelCaption : String;
  PanelHeight : Integer;
begin
  PanelCaption := '';

  if (adsOrdersORDERCOUNT.AsInteger > WarningOrderCount) then
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

    plOverCost.Top := ( dbgOrders.Height - plOverCost.Height) div 2;
    plOverCost.Left := ( dbgOrders.Width - plOverCost.Width) div 2;
    plOverCost.BringToFront;
    plOverCost.Show;
    Timer.Enabled := True;
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
  if FUseCorrectOrders and not adsOrdersDropReason.IsNull then begin
    PositionResult := TPositionSendResult(adsOrdersDropReason.AsInteger);
    CorrectMessage := PositionSendResultText[PositionResult];
    CorrectMessage := CorrectMessage + ' (';
    if PositionResult = psrNotExists then begin
      CorrectMessage := CorrectMessage +
        Format(
          'старая цена: %s; старый заказ: %s',
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
          Format('старая цена: %s; новая цена: %s', [oldCost, newCost]);

      if PositionResult in [psrDifferentQuantity, psrDifferentCostAndQuantity] then
        CorrectMessage := CorrectMessage +
          Format('старый заказ: %s; новый заказ: %s', [oldOrder, newOrder]);
    end;
    CorrectMessage := CorrectMessage + ')';
    mCorrectMessage.Text := CorrectMessage;
  end
  else
    mCorrectMessage.Text := '';
end;

procedure TOrdersForm.FormDestroy(Sender: TObject);
begin
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
        retailPriceColumn.Title.Caption := 'Розн.цена';
        retailPriceColumn.Title.TitleButton := True;
      end;
      retailMarkupColumn := ColumnByNameT(TToughDBGrid(dbgrid), adsOrdersEditRetailMarkup.FieldName);
      if not Assigned(retailMarkupColumn) then begin
        retailMarkupColumn := TColumnEh(dbgrid.Columns.Insert(retailPriceColumn.Index));
        retailMarkupColumn.FieldName := adsOrdersEditRetailMarkup.FieldName;
        retailMarkupColumn.Title.Caption := 'Розн.наценка';
        retailMarkupColumn.Title.TitleButton := True;
      end;
    end;
  end;
  if DM.adtClientsAllowDelayOfPayment.Value then begin
    realPriceCoumn := ColumnByNameT(TToughDBGrid(dbgrid), adsOrdersRealPrice.FieldName);
    priceColumn := ColumnByNameT(TToughDBGrid(dbgrid), adsOrdersprice.FieldName);
    if Assigned(realPriceCoumn) and Assigned(priceColumn) then begin
      priceColumn.Font.Style := priceColumn.Font.Style - [fsBold];
      realPriceCoumn.Font.Style := realPriceCoumn.Font.Style + [fsBold];
    end;
  end;
end;

procedure TOrdersForm.OnPopupGridColumnsClick(Sender: TObject);
var
  FColumnsForm : TfrmColumns;
begin
  FColumnsForm := TfrmColumns.Create(Self);
  try
    FColumnsForm.OwnerDBGrid := TToughDBGrid(dbgEditOrders);
    FColumnsForm.ShowModal;
  finally
    FColumnsForm.Free;
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
    if StrToIntDef(Value, 0) >= 0 then begin
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
  Если выключить двойную буферизацию:
    if CheckWin32Version(5, 1) then
      Params.ExStyle := Params.ExStyle or WS_EX_COMPOSITED;
  то при первом вызове формы можно будет наблюдать моргание всей формы,
  связанное с TframePosition.  

  if Assigned(ParentOrdersHForm)
    and (TOrdersHForm(ParentOrdersHForm).TabControl.TabIndex = 0)
  then begin
    _CoreFirmForm := TCoreFirmForm( FindChildControlByClass(MainForm, TCoreFirmForm) );
    if not Assigned(_CoreFirmForm) then
      _CoreFirmForm := TCoreFirmForm.Create(Application);
    _CoreFirmForm.ShowForm(PriceCode, RegionCode, PriceName, RegionName, False, False);
    _CoreFirmForm.dbgCore.SetFocus;
  end;
}  
end;

end.
