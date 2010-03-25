unit Orders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB,  DBCtrls, StdCtrls, Grids, DBGrids, RXDBCtrl,
  Placemnt, FR_DSet, FR_DBSet, DBGridEh, ToughDBGrid, ExtCtrls, FIBDataSet,
  pFIBDataSet, DBProc, AProc, GridsEh, U_frameLegend, MemDS, DBAccess,
  MyAccess, ActnList, Registry, Buttons;

type
  TOrdersForm = class(TChildForm)
    dsOrders: TDataSource;
    frdsOrders: TfrDBDataSet;
    dbgOrders: TToughDBGrid;
    adsOrdersOld: TpFIBDataSet;
    adsOrdersOldCryptPRICE: TCurrencyField;
    adsOrdersOldCryptSUMORDER: TCurrencyField;
    adsOrdersOldORDERID: TFIBBCDField;
    adsOrdersOldCLIENTID: TFIBBCDField;
    adsOrdersOldCOREID: TFIBBCDField;
    adsOrdersOldFULLCODE: TFIBBCDField;
    adsOrdersOldCODEFIRMCR: TFIBBCDField;
    adsOrdersOldSYNONYMCODE: TFIBBCDField;
    adsOrdersOldSYNONYMFIRMCRCODE: TFIBBCDField;
    adsOrdersOldCODE: TFIBStringField;
    adsOrdersOldCODECR: TFIBStringField;
    adsOrdersOldSYNONYMNAME: TFIBStringField;
    adsOrdersOldSYNONYMFIRM: TFIBStringField;
    adsOrdersOldORDERCOUNT: TFIBIntegerField;
    adsOrdersOldPRICE: TFIBStringField;
    adsOrdersOldAWAIT: TFIBBooleanField;
    adsOrdersOldJUNK: TFIBBooleanField;
    adsOrdersOldSUMORDER: TFIBBCDField;
    adsOrdersOldSENDPRICE: TFIBBCDField;
    adsOrdersOldREQUESTRATIO: TFIBIntegerField;
    tmrCheckOrderCount: TTimer;
    adsOrdersOldORDERCOST: TFIBBCDField;
    adsOrdersOldMINORDERCOUNT: TFIBIntegerField;
    adsOrdersOldPRODUCTID: TFIBBCDField;
    plOverCost: TPanel;
    lWarning: TLabel;
    Timer: TTimer;
    adsOrdersOldORDERSREQUESTRATIO: TFIBIntegerField;
    adsOrdersOldORDERSORDERCOST: TFIBBCDField;
    adsOrdersOldORDERSMINORDERCOUNT: TFIBIntegerField;
    frameLegeng: TframeLegeng;
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
  private
    ParentOrdersHForm : TChildForm;
    OrderID,
    PriceCode : Integer;
    RegionCode : Int64;
    PriceName, RegionName : String;
    ClosedOrder : Boolean;
    //«аказ имеет позиции с необходимой корректировкой, которые он получил
    //во врем€ попытки отправки заказа
    OrderWithSendError : Boolean;
    procedure SetOrderLabel;
    procedure ocf(DataSet: TDataSet);
    procedure FlipToCore;
  protected
    procedure UpdateOrderDataset; override;
    procedure AddRetailPriceColumn;
  public
    procedure ShowForm(OrderId: Integer; ParentForm : TChildForm); overload; //reintroduce;
    procedure ShowForm; override;
    procedure Print( APreview: boolean = False); override;
    procedure SetParams(OrderId: Integer);
  end;

implementation

uses OrdersH, DModule, Constant, Main, Math, CoreFirm, NamesForms, Core,
     PostSomeOrdersController, U_framePosition;

{$R *.dfm}

procedure TOrdersForm.ShowForm(OrderId: Integer; ParentForm : TChildForm);
begin
  plOverCost.Hide();
  cbNeedCorrect.Checked := False;
  //PrintEnabled:=False;
  Self.OrderID := OrderId;
  SetParams(OrderId);
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
  end
end;

procedure TOrdersForm.SetParams(OrderId: Integer);
var
  Closed : Variant;
  SendResult : Variant;
begin
  Closed := DM.QueryValue('select Closed from ordershead where orderid = ' + IntToStr(OrderId), [], []);
  ClosedOrder := Closed <> 0;
  //ќтображаем сообщение с причиной корректировки только если заказ открыт и используетс€ механизм корректировки заказов
  gbCorrectMessage.Visible := (Closed = 0)  and FUseCorrectOrders;
  if not gbCorrectMessage.Visible then
    pTop.Height := pOrderHeader.Height;
  SendResult := DM.QueryValue('select SendResult from ordershead where orderid = ' + IntToStr(OrderId), [], []);
  OrderWithSendError := not VarIsNull(SendResult);
  adsOrders.OnCalcFields := ocf;
  if Closed = 0 then begin
    dbgOrders.SearchField := '';
    dbgOrders.ForceRus := False;
    dbmMessageTo.ReadOnly := False;
    actFlipCore.Enabled := True;
  end
  else begin
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
    raise Exception.Create('Ќе установлена форма "«аказы"!');
end;

procedure TOrdersForm.dbgOrdersGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  PositionResult : TPositionSendResult;
begin
  //ожидаемый товар выдел€ем зеленым
  if adsOrdersAwait.AsBoolean and ( Column.Field = adsOrdersSYNONYMNAME) then
    Background := AWAIT_CLR;

  if FUseCorrectOrders and not adsOrdersDropReason.IsNull then begin
    PositionResult := TPositionSendResult(adsOrdersDropReason.AsInteger);

    //ћы здесь можем затереть подсветку ожидаемости, но это сделано осознано,
    //т.к. информаци€ о невозможности заказа позиции важнее
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
  { если уцененный товар, измен€ем цвет }
  if adsOrdersJunk.AsBoolean and ( Column.Field = adsOrdersPRICE) then
    Background := JUNK_CLR;
end;

procedure TOrdersForm.dbgOrdersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (not dbmMessageTo.ReadOnly)
  then
    FlipToCore
  else
    if Key = VK_ESCAPE then
      if Assigned(ParentOrdersHForm) then
        ParentOrdersHForm.ShowForm
      else
        if Assigned(PrevForm) then
          PrevForm.ShowAsPrevForm;
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
  //≈сли удалили позицию из заказа, то запускаем таймер на удаление этой позиции из DataSet
  if (adsOrdersORDERCOUNT.AsInteger = 0) then begin
    adsOrders.Delete;
    tmrCheckOrderCount.Enabled := False;
    tmrCheckOrderCount.Enabled := True;
  end;
end;

procedure TOrdersForm.SetOrderLabel;
begin
  lSumOrder.Caption := Format('%0.2f', [ DM.GetSumOrder(OrderID) ]);
end;

procedure TOrdersForm.dbgOrdersCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
  inherited;
  CanInput := (not adsOrders.IsEmpty) and Assigned(ParentOrdersHForm) and (TOrdersHForm(ParentOrdersHForm).TabControl.TabIndex = 0);
end;

procedure TOrdersForm.FormCreate(Sender: TObject);
var
  Reg: TRegIniFile;
begin
  dsCheckVolume := adsOrders;
  dgCheckVolume := dbgOrders;
  fOrder := adsOrdersORDERCOUNT;
  fVolume := adsOrdersREQUESTRATIO;
  fOrderCost := adsOrdersORDERCOST;
  fSumOrder := adsOrdersSUMORDER;
  fMinOrderCount := adsOrdersMINORDERCOUNT;
  gotoMNNButton := btnGotoMNN;
  inherited;
  AddRetailPriceColumn;
  TframePosition.AddFrame(Self, pClient, dsOrders, 'SynonymName', 'Mnn', ShowDescriptionAction);
  Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'DetailOrder', False)
    then
      try
        dbgOrders.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
      finally
        Reg.CloseKey;
      end;
  finally
    Reg.Free;
  end;
end;

procedure TOrdersForm.dbgOrdersKeyPress(Sender: TObject; var Key: Char);
var
  _CoreFirmForm : TCoreFirmForm;
begin
	if Assigned(ParentOrdersHForm) and (TOrdersHForm(ParentOrdersHForm).TabControl.TabIndex = 0) and ( Key > #32) and not ( Key in
		[ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
	begin
    _CoreFirmForm := TCoreFirmForm( FindChildControlByClass(MainForm, TCoreFirmForm) );
    if not Assigned(_CoreFirmForm) then
      _CoreFirmForm := TCoreFirmForm.Create(Application);
    _CoreFirmForm.ShowForm(PriceCode, RegionCode, PriceName, RegionName, False, True);
    _CoreFirmForm.dbgCore.SetFocus;
    _CoreFirmForm.eSearch.Text := '';
    SendMessage(GetFocus, WM_CHAR, Ord( Key), 0);
	end;
end;

procedure TOrdersForm.ShowForm;
begin
  inherited;
  //≈сли мы производим возврат из формы "«а€вка поставщику", то надо обновить данные
  if Assigned(PrevForm) and ((PrevForm is TCoreFirmForm) or (PrevForm is TCoreForm)) then
    SetParams(OrderID);
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
    //DM.adcUpdate.SQL.Text := 'delete from OrdersHead where OrderId = ' + IntToStr(OrderID);
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
    if not ClosedOrder or adsOrdersRetailMarkup.IsNull then
      adsOrdersRetailPrice.AsCurrency := DM.GetPriceRet(adsOrdersprice.AsCurrency)
    else
      adsOrdersRetailPrice.AsCurrency :=
        (1 + adsOrdersRetailMarkup.Value/100)*adsOrdersprice.AsCurrency;
    adsOrdersSumOrder.AsCurrency := adsOrdersprice.AsCurrency * adsOrdersORDERCOUNT.AsInteger;
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
      PanelCaption := PanelCaption + #13#10 + '¬нимание! ¬ы заказали большое количество препарата.'
    else
      PanelCaption := '¬нимание! ¬ы заказали большое количество препарата.';

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
      ParentOrdersHForm.ShowForm
    else
      PrevForm.ShowAsPrevForm;
end;

procedure TOrdersForm.cbNeedCorrectClick(Sender: TObject);
begin
  SetParams(OrderID);
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
          'стара€ цена: %s; старый заказ: %s',
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
          Format('стара€ цена: %s; нова€ цена: %s', [oldCost, newCost]);

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
var
  Reg: TRegIniFile;
begin
  inherited;
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'DetailOrder', True);
    try
      dbgOrders.SaveColumnsLayout(Reg);
    finally
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
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
    SetParams(OrderID);
    if adsOrders.RecordCount > 0 then begin
      if not adsOrders.Locate('CoreId', lastCoreId, []) then
        adsOrders.First;
    end
    else
      ParentOrdersHForm.ShowForm;
  end;
end;

procedure TOrdersForm.AddRetailPriceColumn;
var
  orderCountColumn : TColumnEh;
  retailPriceColumn : TColumnEh;
begin
  if DM.adsUser.FieldByName('SendRetailMarkup').AsBoolean then begin
    orderCountColumn := ColumnByNameT(dbgOrders, 'orderCount');
    if Assigned(orderCountColumn) then begin
      retailPriceColumn := ColumnByNameT(dbgOrders, 'RetailPrice');
      if not Assigned(retailPriceColumn) then begin
        retailPriceColumn := TColumnEh(dbgOrders.Columns.Insert(orderCountColumn.Index));
        retailPriceColumn.FieldName := 'RetailPrice';
        retailPriceColumn.Title.Caption := '–озн. цена';
        retailPriceColumn.Title.TitleButton := True;
      end;
    end;
  end;
end;

end.
