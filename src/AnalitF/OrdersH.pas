unit OrdersH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, DB, RXDBCtrl, Buttons,
  StdCtrls, Math, ComCtrls, DBCtrls, ExtCtrls, DBGridEh, ToughDBGrid, DateUtils,
  FR_DSet, FR_DBSet, OleCtrls,
  SQLWaiting, ShellAPI, GridsEh, MemDS,
  Contnrs,
  DBAccess, MyAccess, MemData, Orders,
  DModule,
  U_frameOrderHeadLegend, Menus,
  AddressController,
  U_frameFilterAddresses,
  U_Address,
  U_DBMapping,
  U_CurrentOrderHead,
  U_CurrentOrderItem,
  DayOfWeekHelper,
  StrHlder,
  U_LegendHolder, ActnList;

const
  postedOrdersLimit = 1000;

type
  TOrdersHForm = class(TChildForm)
    dsOrdersH: TDataSource;
    TabControl: TTabControl;
    btnDelete: TButton;
    btnMoveSend: TButton;
    pBottom: TPanel;
    pTop: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    Bevel1: TBevel;
    pTabSheet: TPanel;
    btnWayBillList: TButton;
    pClient: TPanel;
    pGrid: TPanel;
    dbgCurrentOrders: TToughDBGrid;
    pRight: TPanel;
    gbMessage: TGroupBox;
    dbmMessage: TDBMemo;
    gbComments: TGroupBox;
    dbmComments: TDBMemo;
    tmOrderDateChange: TTimer;
    bevClient: TBevel;
    dbgSendedOrders: TToughDBGrid;
    adsOrdersHForm: TMyQuery;
    adsOrdersHFormOrderId: TLargeintField;
    adsOrdersHFormClientID: TLargeintField;
    adsOrdersHFormServerOrderId: TLargeintField;
    adsOrdersHFormDatePrice: TDateTimeField;
    adsOrdersHFormPriceCode: TLargeintField;
    adsOrdersHFormRegionCode: TLargeintField;
    adsOrdersHFormOrderDate: TDateTimeField;
    adsOrdersHFormSendDate: TDateTimeField;
    adsOrdersHFormClosed: TBooleanField;
    adsOrdersHFormSend: TBooleanField;
    adsOrdersHFormPriceName: TStringField;
    adsOrdersHFormRegionName: TStringField;
    adsOrdersHFormSupportPhone: TStringField;
    adsOrdersHFormMessageTo: TMemoField;
    adsOrdersHFormComments: TMemoField;
    adsOrdersHFormPriceEnabled: TBooleanField;
    adsOrdersHFormPositions: TLargeintField;
    adsOrdersHFormSumOrder: TFloatField;
    adsOrdersHFormsumbycurrentmonth: TFloatField;
    adsOrdersHFormDisplayOrderId: TLargeintField;
    adsCore: TMyQuery;
    adsOrdersHFormMinReq: TLargeintField;
    adsOrdersHFormDifferentCostCount: TLargeintField;
    adsOrdersHFormDifferentQuantityCount: TLargeintField;
    adsOrdersHFormsumbycurrentweek: TFloatField;
    adsCurrentOrders: TMyQuery;
    adsSendOrders: TMyQuery;
    adsOrdersHFormFrozen: TBooleanField;
    btnFrozen: TButton;
    btnUnFrozen: TButton;
    sbMoveToClient: TSpeedButton;
    pmDestinationClients: TPopupMenu;
    adsOrdersHFormAddressName: TStringField;
    tmrFillReport: TTimer;
    sbMoveToPrice: TSpeedButton;
    pmDestinationPrices: TPopupMenu;
    adsOrdersHFormNotExistsCount: TLargeintField;
    adsOrdersHFormRealClientId: TLargeintField;
    strhPostedBegin: TStrHolder;
    strhPostedEnd: TStrHolder;
    ActionList: TActionList;
    actMoveToPrice: TAction;
    procedure btnMoveSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dbgCurrentOrdersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCurrentOrdersExit(Sender: TObject);
    procedure dbgCurrentOrdersDblClick(Sender: TObject);
    procedure adsOrdersH2AfterPost(DataSet: TDataSet);
    procedure dbgCurrentOrdersKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCurrentOrdersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dtpDateCloseUp(Sender: TObject);
    procedure btnWayBillListClick(Sender: TObject);
    procedure adsOrdersH2SendChange(Sender: TField);
    procedure tmOrderDateChangeTimer(Sender: TObject);
    procedure adsOrdersH2BeforePost(DataSet: TDataSet);
    procedure dbgCurrentOrdersSortMarkingChanged(Sender: TObject);
    procedure adsOrdersHFormBeforeInsert(DataSet: TDataSet);
    procedure adsCoreBeforePost(DataSet: TDataSet);
    procedure btnFrozenClick(Sender: TObject);
    procedure dbgCurrentOrdersColumns4GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure btnUnFrozenClick(Sender: TObject);
    procedure sbMoveToClientClick(Sender: TObject);
    procedure tmrFillReportTimer(Sender: TObject);
    procedure dbMemoEnter(Sender: TObject);
    procedure actMoveToPriceExecute(Sender: TObject);
    procedure actMoveToPriceUpdate(Sender: TObject);
  private
    Strings: TStrings;
    SelectedPrices : TStringList;
    //Список выбранных строк в гридах
    FSelectedRows : TStringList;
    MoveToPriceFromSend : Boolean;
    procedure MoveToPrice;
    procedure InternalMoveToPrice;
    procedure SetDateInterval;
    procedure OrderEnter;
    procedure FillSelectedRows(Grid : TToughDBGrid);
    procedure FillDestinationClients;
    procedure MoveToClient(DestinationClientId : Integer);
    procedure OnDectinationClientClick(Sender: TObject);
    procedure OnChangeCheckBoxAllOrders;
    procedure OnChangeFilterAllOrders;
    function GetActionDescription() : String;
    function OffersByPriceExists(PriceCode, RegionCode : Int64) : Boolean;
    procedure ShowCurrentActionButtons;
    procedure ShowSendActionButtons;
    procedure ButtonLayout(buttons : array of TControl);
    procedure PrepareDestinationPrices;
    procedure OnDectinationPriceClick(Sender: TObject);
    procedure InternalMoveToAnotherPrice;
    function GetOrderFormMove() : TCurrentOrderHead;
  protected
    FOrdersForm: TOrdersForm;
    RestoreUnFrozenOrMoveToClient : Boolean;
    RestoreFrozen : Boolean;
    InternalDestinationClientId : Integer;
    frameFilterAddresses : TframeFilterAddresses;
    frameFilterAddressesSend : TframeFilterAddresses;
    procedure SavePeriodToGlobals;
    function GetPostedCriteria() : String;
    procedure CheckPostedOrdersCountToShow(postedCriteria : String);
    procedure UpdateGridOnLegend(Sender : TObject);
    procedure InternalMoveToPriceAction(Sender: TObject);
  public
    frameOrderHeadLegend : TframeOrderHeadLegend;
    procedure SetParameters;
    procedure Print( APreview: boolean = False); override;
    procedure ShowForm; override;
    procedure ShowAsPrevForm; override;
  end;

procedure ShowOrdersH;

var
  ordersDateFrom,
  ordersDateTo : TDateTime;

implementation

uses Main, AProc, NotFound, DBProc, Core, WayBillList, Constant,
     DBGridHelper,
     U_ExchangeLog;

{$R *.dfm}

procedure ShowOrdersH;
begin
  MainForm.ShowChildForm( TOrdersHForm );
end;

procedure TOrdersHForm.FormCreate(Sender: TObject);
begin
  inherited;

  pBottom.ControlStyle := pBottom.ControlStyle - [csParentBackground] + [csOpaque];

  PrepareDestinationPrices;

  if DM.adtClients.RecordCount = 1 then
    sbMoveToClient.Enabled := False
  else
    if DM.adtClients.RecordCount = 2 then
      sbMoveToClient.Glyph := nil;
  FillDestinationClients;    

  frameOrderHeadLegend := TframeOrderHeadLegend.Create(Self);
  frameOrderHeadLegend.Parent := pGrid;
  frameOrderHeadLegend.Align := alBottom;
  frameOrderHeadLegend.lNeedCorrect.Visible := FUseCorrectOrders;
  frameOrderHeadLegend.UpdateGrids := UpdateGridOnLegend;

  NeedFirstOnDataSet := False;
  FSelectedRows := TStringList.Create;
  PrintEnabled := False;

  frameFilterAddresses := TframeFilterAddresses.AddFrame(
    Self,
    pTop,
    dtpDateTo.Left + dtpDateTo.Width + 5,
    pTop.Height,
    dbgCurrentOrders,
    OnChangeCheckBoxAllOrders,
    OnChangeFilterAllOrders);
  frameFilterAddressesSend := TframeFilterAddresses.AddFrame(
    Self,
    pTop,
    dtpDateTo.Left + dtpDateTo.Width + 5,
    pTop.Height,
    dbgSendedOrders,
    OnChangeCheckBoxAllOrders,
    OnChangeFilterAllOrders);
  tmrFillReport.Enabled := False;
  tmrFillReport.Interval := 500;
  frameFilterAddresses.Visible := False;
  frameFilterAddressesSend.Visible := False;

  FOrdersForm := TOrdersForm( FindChildControlByClass(MainForm, TOrdersForm) );
  if FOrdersForm = nil then
    FOrdersForm := TOrdersForm.Create( Application);

  WayBillListForm := TWayBillListForm.Create(Application);
  TDBGridHelper.RestoreColumnsLayout(dbgCurrentOrders, 'CurrentOrders');
  TDBGridHelper.RestoreColumnsLayout(dbgSendedOrders, 'SendedOrders');

  dtpDateFrom.Date := ordersDateFrom;
  dtpDateTo.Date := ordersDateTo;;

  TabControl.TabIndex := 0;
  DoSetCursor(crHourglass);
  try
    SetParameters;
  finally
    DoSetCursor(crDefault);
  end;

  ShowForm;
end;

procedure TOrdersHForm.FormDestroy(Sender: TObject);
begin
  SavePeriodToGlobals();
  try
    //TODO: ___ Здесь возникает ошибка с AccessViolation в FBPlus.
    //Возможно эта моя ошибка, но я пока не могу ее исправить
    SoftPost(adsOrdersHForm);
  except
  end;
  TDBGridHelper.SaveColumnsLayout(dbgCurrentOrders, 'CurrentOrders');
  TDBGridHelper.SaveColumnsLayout(dbgSendedOrders, 'SendedOrders');
  FSelectedRows.Free;
end;

procedure TOrdersHForm.SetParameters;
var
  Grid : TDBGridEh;
  clientsSql : String;
  postedCriteria : String;
begin
  Grid := nil;
  clientsSql := '';
  SoftPost( adsOrdersHForm);
  adsOrdersHForm.IndexFieldNames := '';
  adsOrdersHForm.Close;

  case TabControl.TabIndex of
    0:
    begin
      frameFilterAddresses.Visible := GetAddressController.AllowAllOrders;
      frameFilterAddressesSend.Visible := False;
      if frameFilterAddresses.Visible then
        frameFilterAddresses.UpdateFrame();
      adsOrdersHForm.SQL.Text := adsCurrentOrders.SQL.Text;

      if GetAddressController.ShowAllOrders then begin
        clientsSql := GetAddressController.GetFilter('CurrentOrderHeads.ClientId');
        if clientsSql <> '' then
          adsOrdersHForm.SQL.Text := adsOrdersHForm.SQL.Text
            + #13#10' and ' + clientsSql + ' '#13#10;
      end
      else
        adsOrdersHForm.SQL.Text := adsOrdersHForm.SQL.Text
          + #13#10' and (CurrentOrderHeads.ClientId = ' + IntToStr(DM.adtClientsCLIENTID.Value) + ') '#13#10;

      adsOrdersHForm.SQL.Text := adsOrdersHForm.SQL.Text
        + ' group by CurrentOrderHeads.OrderId having count(CurrentOrderLists.Id) > 0 order by CurrentOrderHeads.PriceName ';

      adsOrdersHForm.SQLRefresh.Text := adsCurrentOrders.SQLRefresh.Text;
      adsOrdersHForm.SQLDelete.Text := adsCurrentOrders.SQLDelete.Text;
      adsOrdersHForm.SQLUpdate.Text := adsCurrentOrders.SQLUpdate.Text;

      ShowCurrentActionButtons();

      dbgCurrentOrders.Visible := True;
      dbgSendedOrders.Visible := False;
      frameOrderHeadLegend.Visible := True;
      Grid := dbgCurrentOrders;
      //try except необходим, т.к. вызвается когда форма еще не отображена
      try
        dbgCurrentOrders.SetFocus;
      except end;
    end;
    1:
    begin
      frameFilterAddresses.Visible := False;
      frameFilterAddressesSend.Visible := GetAddressController.AllowAllOrders;
      if frameFilterAddressesSend.Visible then
        frameFilterAddressesSend.UpdateFrame();

      postedCriteria := GetPostedCriteria();

      CheckPostedOrdersCountToShow(postedCriteria);

      adsOrdersHForm.SQL.Text :=
        strhPostedBegin.Strings.Text + #13#10 + postedCriteria + ';'#13#10
        + strhPostedEnd.Strings.Text;

      adsOrdersHForm.SQLRefresh.Text := adsSendOrders.SQLRefresh.Text;
      adsOrdersHForm.SQLDelete.Text := adsSendOrders.SQLDelete.Text;
      adsOrdersHForm.SQLUpdate.Text := adsSendOrders.SQLUpdate.Text;

      adsOrdersHForm.ParamByName( 'DateFrom').AsDate := ordersDateFrom;
      adsOrdersHForm.ParamByName( 'DateTo').AsDate := IncDay(ordersDateTo);

      ShowSendActionButtons();

      dbgCurrentOrders.Visible := False;
      dbgSendedOrders.Visible := True;
      frameOrderHeadLegend.Visible := False;
      Grid := dbgSendedOrders;
      //try except необходим, т.к. вызвается когда форма еще не отображена
      try
        dbgSendedOrders.SetFocus;
      except end;
    end;
  end;

  if Assigned(adsOrdersHForm.Params.FindParam('ClientId'))
  then
    adsOrdersHForm.ParamByName( 'ClientId').Value :=
      DM.adtClients.FieldByName( 'ClientId').Value;
  adsOrdersHForm.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;

  adsOrdersHForm.Open;

  if Assigned(Grid.OnSortMarkingChanged) then begin
    Grid.OnSortMarkingChanged(Grid);
    adsOrdersHForm.First;
  end;

  dtpDateFrom.Enabled := TabControl.TabIndex = 1;
  dtpDateTo.Enabled   := dtpDateFrom.Enabled;

  dbmMessage.ReadOnly := TabControl.TabIndex = 1;
  PrintEnabled := ((TabControl.TabIndex = 0) and ((DM.SaveGridMask and PrintCurrentOrder) > 0))
               or ((TabControl.TabIndex = 1) and ((DM.SaveGridMask and PrintSendedOrder) > 0));
  FOrdersForm.PrintEnabled := PrintEnabled;
  dbmMessage.Color := Iif(TabControl.TabIndex = 0, clWindow, clBtnFace);
  if adsOrdersHForm.RecordCount = 0 then begin
    dbgCurrentOrders.ReadOnly := True;
    dbgSendedOrders.ReadOnly := True;
  end
  else begin
    dbgCurrentOrders.ReadOnly := False;
    dbgSendedOrders.ReadOnly := False;
  end;
end;

procedure TOrdersHForm.TabControlChange(Sender: TObject);
begin
  SetParameters;
end;

procedure TOrdersHForm.btnDeleteClick(Sender: TObject);
var
  Grid : TToughDBGrid;
  I : Integer;
  logMessage : String;
begin
  if TabControl.TabIndex = 0 then
    Grid := dbgCurrentOrders
  else
    Grid := dbgSendedOrders;

  Grid.SetFocus;
  if not adsOrdersHForm.IsEmpty then
  begin
    FillSelectedRows(Grid);
    if FSelectedRows.Count > 0 then
      if AProc.MessageBox( 'Удалить выбранные заявки?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then begin
        Grid.DataSource.DataSet.DisableControls;
        try
          for I := 0 to FSelectedRows.Count-1 do begin
            Grid.DataSource.DataSet.Bookmark := FSelectedRows[i];
            if TabControl.TabIndex = 0 then
              logMessage := Format('Удаление текущего заказа Id: %s  Прайс-лист: %s  Дата создания: %s',
                [adsOrdersHFormDisplayOrderId.AsString,
                adsOrdersHFormPriceName.AsString,
                adsOrdersHFormOrderDate.AsString])
            else
              logMessage := Format('Удаление отправленного заказа Id: %s', [adsOrdersHFormDisplayOrderId.AsString]);
            Grid.DataSource.DataSet.Delete;
            WriteExchangeLog('DeleteOrders', logMessage);
          end;
        finally
          Grid.DataSource.DataSet.EnableControls;
        end;
        MainForm.SetOrdersInfo;
      end;
  end;
  if adsOrdersHForm.RecordCount = 0 then begin
    dbgCurrentOrders.ReadOnly := True;
    dbgSendedOrders.ReadOnly := True;
  end
  else begin
    dbgCurrentOrders.ReadOnly := False;
    dbgSendedOrders.ReadOnly := False;
  end;
end;

procedure TOrdersHForm.btnMoveSendClick(Sender: TObject);
begin
  if TabControl.TabIndex = 1 then begin
    dbgSendedOrders.SetFocus;
    FillSelectedRows(dbgSendedOrders);
    MoveToPrice;
    MainForm.SetOrdersInfo;
  end;
end;

procedure TOrdersHForm.MoveToPrice;
begin
  RestoreUnFrozenOrMoveToClient := False;
  RestoreFrozen := False;
  InternalDestinationClientId := 0;
  if adsOrdersHForm.IsEmpty or ( TabControl.TabIndex<>1) then Exit;

  if FSelectedRows.Count = 0 then Exit;

  if AProc.MessageBox( 'Вернуть выбранные заявки в работу?',MB_ICONQUESTION+MB_OKCANCEL)<>IDOK then exit;

  Strings:=TStringList.Create;
  try
    ShowSQLWaiting(InternalMoveToPrice, 'Происходит восстановление заявок');

    //если не нашли что-то, то выводим сообщение
    if Strings.Count > 0 then begin
      WriteExchangeLog('RestoreSendOrders', 'Заказы, восстановленные из отправленных:'#13#10 + Strings.Text);
      ShowNotFound(Strings);
    end;

  finally
    Strings.Free;
  end;
end;

procedure TOrdersHForm.dbgCurrentOrdersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    SoftPost( adsOrdersHForm);
    if not adsOrdersHForm.Isempty then OrderEnter;
  end;
  if ( Key = VK_ESCAPE) and ( Self.PrevForm <> nil) and
    ( Self.PrevForm is TCoreForm) then
  begin
    //todo: непонятно что-то здесь происходит
    Self.PrevForm.Show;
    MainForm.ActiveChild := Self.PrevForm;
    MainForm.ActiveControl := Self.PrevForm.ActiveControl;
  end;
  if ( Key = VK_DELETE) and not ( adsOrdersHForm.IsEmpty) then
  begin
    btnDeleteClick(nil);
    MainForm.SetOrdersInfo;
  end;
end;

procedure TOrdersHForm.dbgCurrentOrdersExit(Sender: TObject);
begin
  SoftPost( adsOrdersHForm);
end;

procedure TOrdersHForm.dbgCurrentOrdersDblClick(Sender: TObject);
var
  C : GridsEh.TGridCoord;
  P : TPoint;
begin
  SoftPost( adsOrdersHForm);
  p := TToughDBGrid(Sender).ScreenToClient(Mouse.CursorPos);
  C := TToughDBGrid(Sender).MouseCoord(p.X, p.Y);
  if C.Y > 0 then
    if not adsOrdersHForm.Isempty then OrderEnter;
end;

procedure TOrdersHForm.adsOrdersH2AfterPost(DataSet: TDataSet);
begin
  MainForm.SetOrdersInfo;
end;

procedure TOrdersHForm.dbgCurrentOrdersKeyPress(Sender: TObject; var Key: Char);
begin
  if ( TabControl.TabIndex = 0) and ( Ord( Key) > 32) and
    not adsOrdersHForm.IsEmpty then
  begin
    dbmMessage.SetFocus;
    SendMessage( GetFocus, WM_CHAR, Ord( Key), 0);
  end;
end;

procedure TOrdersHForm.dbgCurrentOrdersGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if TabControl.TabIndex = 0 then begin
    if (Column.Field = adsOrdersHFormMINREQ) and not adsOrdersHFormMINREQ.IsNull and (adsOrdersHFormMINREQ.AsInteger > adsOrdersHFormSumOrder.AsCurrency) then
      Background := LegendHolder.Legends[lnMinReq];

    if adsOrdersHFormFrozen.Value then
      Background := LegendHolder.Legends[lnFrozenOrder];

    if FUseCorrectOrders then begin
      if (adsOrdersHFormDifferentCostCount.Value > 0)
         and (Column.Field = adsOrdersHFormSumOrder)
      then
        Background := LegendHolder.Legends[lnNeedCorrect];

      if (adsOrdersHFormDifferentQuantityCount.Value > 0)
         and (Column.Field = adsOrdersHFormPositions)
      then
        Background := LegendHolder.Legends[lnNeedCorrect];

      if (adsOrdersHFormNotExistsCount.Value > 0)
         and (Column.Field = adsOrdersHFormPriceName)
      then
        Background := LegendHolder.Legends[lnNeedCorrect];
    end;
  end;

  if TabControl.TabIndex = 1 then
  begin
    if not Column.Field.DataSet.FieldByName( 'Send').AsBoolean then
      Background := clSilver;
  end;
end;

procedure TOrdersHForm.SetDateInterval;
begin
  with adsOrdersHForm do begin
  SavePeriodToGlobals();
  ParamByName('DateFrom').AsDate := ordersDateFrom;
  ParamByName('DateTo').AsDate := IncDay(ordersDateTo);
    DoSetCursor(crHourglass);
    try
      if Active then
      begin
        Close;
        Open;
      end
      else
        Open;
    finally
      DoSetCursor(crDefault);
    end;
  end;
end;

procedure TOrdersHForm.dtpDateCloseUp(Sender: TObject);
var
  Grid : TToughDBGrid;
begin
  if TabControl.TabIndex = 0 then
    Grid := dbgCurrentOrders
  else
    Grid := dbgSendedOrders;
  SetDateInterval;
  Grid.SetFocus;
end;

procedure TOrdersHForm.Print(APreview: boolean);
var
  Mark: TBookmarkStr;
  printedReport : Boolean;
begin
  if not adsOrdersHForm.Active or adsOrdersHForm.IsEmpty then exit;

  //Если вызван "Предварительный просмотр", то отображаем только текущий заказ,
  //иначе выводим на печать все заказы из списка
  if APreview then
    DM.ShowOrderDetailsReport(
      adsOrdersHFormORDERID.AsInteger,
      adsOrdersHFormCLOSED.Value,
      adsOrdersHFormSEND.Value,
      APreview)
  else begin
    Mark := adsOrdersHForm.Bookmark;
    adsOrdersHForm.DisableControls;
    try
      adsOrdersHForm.First;
      if not adsOrdersHForm.Eof then begin
        printedReport := DM.ShowOrderDetailsReport(
          adsOrdersHFormORDERID.AsInteger,
          adsOrdersHFormCLOSED.Value,
          adsOrdersHFormSEND.Value,
          APreview,
          True);
        adsOrdersHForm.Next;
      end
      else
        printedReport := False;

      while not adsOrdersHForm.Eof and printedReport do
      begin
        //Если заказ закрыт или не закрыт и разрешен к отправке
        if adsOrdersHFormCLOSED.Value or (adsOrdersHFormSEND.Value) then
        begin
          printedReport := DM.ShowOrderDetailsReport(
            adsOrdersHFormORDERID.AsInteger,
            adsOrdersHFormCLOSED.Value,
            adsOrdersHFormSEND.Value,
            APreview,
            False);
        end;
        adsOrdersHForm.Next;
      end;

    finally
      adsOrdersHForm.BookMark := Mark;
      adsOrdersHForm.EnableControls;
    end;
  end;
end;

procedure TOrdersHForm.btnWayBillListClick(Sender: TObject);
begin
  ShellExecute( 0, 'Open', PChar(RootFolder() + SDirWaybills + '\'),
    nil, nil, SW_SHOWDEFAULT);
end;

procedure TOrdersHForm.adsOrdersH2SendChange(Sender: TField);
begin
  //По-другому решить проблему не удалось. Запускаю таймер, чтобы он в главной нити
  //произвел сохранение dataset
  tmOrderDateChange.Enabled := True;
end;

procedure TOrdersHForm.tmOrderDateChangeTimer(Sender: TObject);
begin
  try
    SoftPost( adsOrdersHForm);
  finally
    tmOrderDateChange.Enabled := False;
  end;
end;

procedure TOrdersHForm.adsOrdersH2BeforePost(DataSet: TDataSet);
begin
  if adsOrdersHFormORDERID.IsNull then Abort; 
end;

procedure TOrdersHForm.dbgCurrentOrdersSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TOrdersHForm.OrderEnter;
begin
  FOrdersForm.ShowForm( adsOrdersHFormORDERID.AsInteger, Self, adsOrdersHFormClosed.Value);
end;

procedure TOrdersHForm.InternalMoveToPrice;
var
  Order, CurOrder, Quantity, E: Integer;
  SynonymFirmCrCode, SynonymCode: Variant;
  Code, RequestRatio, OrderCost, MinOrderCount : Variant;
  I : Integer;
  RecCountSRV : Integer;
  LastBookmark : String;

  procedure SetOrder( Order: Integer);
  begin
    with adsCore do begin
      Edit;
      FieldByName( 'OrderCount').AsInteger := Order;
      Post;
    end;
  end;

begin
  LastBookmark := adsOrdersHForm.Bookmark;
  adsOrdersHForm.DisableControls;
  try
    for I := 0 to FSelectedRows.Count-1 do begin
      adsOrdersHForm.Bookmark := FSelectedRows[i];

      //Производим работу только с заявками текущего клиента
      if not RestoreFrozen and (adsOrdersHFormClientID.Value <> DM.adtClientsCLIENTID.Value) and (not adsOrdersHFormRealClientId.IsNull)
      then
        Continue;

      //"Размораживаем" только замороженные заявки
      if RestoreUnFrozenOrMoveToClient and (InternalDestinationClientId = 0) then
        if not adsOrdersHFormFrozen.Value then
          Continue;

      { проверяем наличие прайс-листа }
      if not OffersByPriceExists(adsOrdersHFormPRICECODE.Value, adsOrdersHFormREGIONCODE.Value) then begin
        Strings.Append(
          Format('Заказ №%s невозможно %s, т.к. прайс-листа %s - %s нет в обзоре.',
          [adsOrdersHFormDisplayOrderId.AsString,
          GetActionDescription(),
          adsOrdersHFormPriceName.AsString,
          adsOrdersHFormRegionName.AsString]));
        Continue;
      end;
      Application.ProcessMessages;

      DoSetCursor(crHourglass);
      try
        { открываем сохраненный заказ }
        FOrdersForm.SetParams( adsOrdersHFormORDERID.AsInteger, not RestoreUnFrozenOrMoveToClient);
        Application.ProcessMessages;
        { переписываем позиции в текущий прайс-лист }
        while not FOrdersForm.adsOrders.Eof do begin
          Order:=FOrdersForm.adsOrdersORDERCOUNT.AsInteger;

          Code := FOrdersForm.adsOrdersCode.AsVariant;
          RequestRatio := FOrdersForm.adsOrdersORDERSREQUESTRATIO.AsVariant;
          OrderCost := FOrdersForm.adsOrdersORDERSORDERCOST.AsVariant;
          MinOrderCount := FOrdersForm.adsOrdersORDERSMINORDERCOUNT.AsVariant;

          SynonymCode:=FOrdersForm.adsOrdersSynonymCode.AsInteger;
          SynonymFirmCrCode:=FOrdersForm.adsOrdersSynonymFirmCrCode.AsVariant;

          with adsCore do begin
            if RestoreFrozen then begin
              //Если значение realClientid = null, то пытаемся восстановить заказ для удаленного адреса доставки,
              //поэтому восстанавливаем под текущим адресом доставки
              if not adsOrdersHFormRealClientId.IsNull then
                ParamByName( 'ClientId').Value := adsOrdersHFormRealClientId.Value
              else
                ParamByName( 'ClientId').Value := DM.adtClients.FieldByName('ClientId').Value
            end
            else
              if RestoreUnFrozenOrMoveToClient and (InternalDestinationClientId <> 0) then
                ParamByName( 'ClientId').Value := InternalDestinationClientId
              else
                ParamByName( 'ClientId').Value := DM.adtClients.FieldByName('ClientId').Value;
            ParamByName( 'PriceCode').Value:=adsOrdersHFormPRICECODE.Value;
            ParamByName( 'RegionCode').Value:=adsOrdersHFormREGIONCODE.Value;
            ParamByName( 'DayOfWeek').Value := TDayOfWeekHelper.DayOfWeek();

            RestoreSQL;
            AddWhere('(CCore.SYNONYMCODE = :SYNONYMCODE)');
            ParamByName( 'SynonymCode').Value:=SynonymCode;
            if (VarIsNull(SynonymFirmCrCode)) then
              AddWhere('(CCore.SYNONYMFIRMCRCODE is null)')
            else begin
              AddWhere('(CCore.SYNONYMFIRMCRCODE = :SYNONYMFIRMCRCODE)');
              ParamByName( 'SYNONYMFIRMCRCODE').Value := SynonymFirmCrCode;
            end;

            Open;
            FetchAll;
            IndexFieldNames := 'Cost ASC';
            First;

            RecCountSRV := adsCore.RecordCount;
            try
              { пытаемся разбросать заказ по нужным Code, SynonymCode и SynonymFirmCrCode }
              if LocateEx( 'Code;REQUESTRATIO;ORDERCOST;MINORDERCOUNT', VarArrayOf([ Code, RequestRatio, OrderCost, MinOrderCount]), [])
              then
              begin
                repeat
                  Val(FieldByName( 'Quantity').AsString,Quantity,E);
                  if E <> 0 then Quantity := 0;
                  if Quantity > 0 then
                    CurOrder := Min( Order, Quantity - FieldByName('OrderCount').AsInteger)
                  else
                    CurOrder := Order;
                  if not FieldByName( 'RequestRatio').IsNull and (FieldByName( 'RequestRatio').AsInteger > 0) then
                    CurOrder := CurOrder - (CurOrder mod FieldByName( 'RequestRatio').AsInteger);
                  if CurOrder < 0 then CurOrder := 0;
                  Order := Order - CurOrder;
                  if CurOrder > 0 then SetOrder( FieldByName( 'OrderCount').AsInteger + CurOrder);
                until ( Order = 0) or (not LocateEx( 'Code;REQUESTRATIO;ORDERCOST;MINORDERCOUNT', VarArrayOf([ Code, RequestRatio, OrderCost, MinOrderCount]), [lxNext])) or (RecCountSRV = adsCore.RecordCount);
              end;

              { если все еще не разбросали, то пишем сообщение }
              if Order > 0 then
              begin
                if ( FOrdersForm.adsOrdersORDERCOUNT.AsInteger - Order) > 0 then
                begin
                  Strings.Append( Format( '%s : %s - %s : %d вместо %d',
                    [adsOrdersHFormPRICENAME.AsString,
                    FOrdersForm.adsOrdersSYNONYMNAME.AsString,
                    FOrdersForm.adsOrdersSYNONYMFIRM.AsString,
                    FOrdersForm.adsOrdersORDERCOUNT.AsInteger - Order,
                    FOrdersForm.adsOrdersORDERCOUNT.AsInteger]));
                end
                else
                  Strings.Append( Format( '%s : %s - %s : предложение не найдено',
                    [adsOrdersHFormPRICENAME.AsString,
                    FOrdersForm.adsOrdersSYNONYMNAME.AsString,
                    FOrdersForm.adsOrdersSYNONYMFIRM.AsString]));
              end;

            finally
              Close;
            end;
          end;

          FOrdersForm.adsOrders.Next;
          Application.ProcessMessages;
        end;
      finally
        DoSetCursor(crDefault);
      end;
    end;

  finally
    adsOrdersHForm.Bookmark := LastBookmark;
    adsOrdersHForm.EnableControls;
  end;

  MainForm.SetOrdersInfo;

  dbgSendedOrders.Selection.Clear;
end;

procedure TOrdersHForm.ShowForm;
begin
  inherited;
  if Assigned(PrevForm) and (PrevForm is TOrdersForm) then begin
    //Если мы производим возврат из окна "Архивный заказ", то надо обновить сумму
    if not adsOrdersHFormCLOSED.AsBoolean then
      adsOrdersHForm.RefreshRecord;
  end;
end;

procedure TOrdersHForm.adsOrdersHFormBeforeInsert(DataSet: TDataSet);
begin
  Abort;
end;

procedure TOrdersHForm.adsCoreBeforePost(DataSet: TDataSet);
begin
  DM.InsertOrderHeader(adsCore);
end;

procedure TOrdersHForm.FillSelectedRows(Grid: TToughDBGrid);
var
  CurrentBookmark : String;
begin
  FSelectedRows.Clear;

  //Если выделение не Rect, то берем только текущую строку, иначе работаем
  //со свойством Grid.Selection.Rect
  if Grid.Selection.SelectionType <> gstRectangle then
    FSelectedRows.Add(Grid.DataSource.DataSet.Bookmark)
  else begin
    CurrentBookmark := Grid.DataSource.DataSet.Bookmark;
    Grid.DataSource.DataSet.DisableControls;
    try
      Grid.DataSource.DataSet.Bookmark := Grid.Selection.Rect.TopRow;
      repeat
        FSelectedRows.Add(Grid.DataSource.DataSet.Bookmark);
        if Grid.DataSource.DataSet.Bookmark = Grid.Selection.Rect.BottomRow then
          Break
        else
          Grid.DataSource.DataSet.Next;
      until Grid.DataSource.DataSet.Eof;
    finally
      Grid.DataSource.DataSet.Bookmark := CurrentBookmark;
      Grid.DataSource.DataSet.EnableControls;
    end;
  end;
end;

procedure TOrdersHForm.ShowAsPrevForm;
begin
  inherited;
  case TabControl.TabIndex of
    0: dbgCurrentOrders.SetFocus;
    1: dbgSendedOrders.SetFocus;
  end;
end;

procedure TOrdersHForm.btnFrozenClick(Sender: TObject);
var
  Grid : TToughDBGrid;
  I : Integer;
begin
  if TabControl.TabIndex = 0 then
    Grid := dbgCurrentOrders
  else
    Exit;

  Grid.SetFocus;
  if not adsOrdersHForm.IsEmpty then
  begin
    FillSelectedRows(Grid);
    if FSelectedRows.Count > 0 then
      if AProc.MessageBox( '"Заморозить" выбранные заявки?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then begin
        Grid.DataSource.DataSet.DisableControls;
        try
          for I := 0 to FSelectedRows.Count-1 do begin
            Grid.DataSource.DataSet.Bookmark := FSelectedRows[i];
            if not adsOrdersHFormFrozen.Value then begin
              DM.adcUpdate.SQL.Text := 'update CurrentOrderLists set CoreId = null where OrderId = ' + adsOrdersHFormOrderId.AsString;
              DM.adcUpdate.Execute;
              Grid.DataSource.DataSet.Edit;
              adsOrdersHFormSend.Value := False;
              adsOrdersHFormFrozen.Value := True;
              Grid.DataSource.DataSet.Post;
            end;
          end;
        finally
          Grid.DataSource.DataSet.EnableControls;
        end;
        MainForm.SetOrdersInfo;
      end;
  end;
  if adsOrdersHForm.RecordCount = 0 then begin
    dbgCurrentOrders.ReadOnly := True;
    dbgSendedOrders.ReadOnly := True;
  end
  else begin
    dbgCurrentOrders.ReadOnly := False;
    dbgSendedOrders.ReadOnly := False;
  end;
end;

procedure TOrdersHForm.dbgCurrentOrdersColumns4GetCellParams(
  Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
begin
  if (Sender is TColumnEh) and (TColumnEh(Sender).Field = adsOrdersHFormSend)
  then
    if adsOrdersHFormFrozen.Value then
      Params.CheckboxState := cbUnchecked;
end;

procedure TOrdersHForm.btnUnFrozenClick(Sender: TObject);
var
  Grid : TToughDBGrid;
  I : Integer;
begin
  if TabControl.TabIndex = 0 then
    Grid := dbgCurrentOrders
  else
    Exit;

  Grid.SetFocus;
  if not adsOrdersHForm.IsEmpty then
  begin
    FillSelectedRows(Grid);
    if FSelectedRows.Count > 0 then
      if AProc.MessageBox(
          'Внимание! "Размороженные" заявки будут объединены с текущими заявками.'#13#10 +
          '"Разморозить" выбранные заявки?',
          MB_ICONQUESTION or MB_OKCANCEL) = IDOK
      then begin

        RestoreUnFrozenOrMoveToClient := True;
        InternalDestinationClientId := 0;
        RestoreFrozen := True;
        Strings:=TStringList.Create;
        try
          ShowSQLWaiting(InternalMoveToPrice, 'Происходит "размороживание" заявок');

          Grid.DataSource.DataSet.DisableControls;
          try
            for I := 0 to FSelectedRows.Count-1 do begin
              Grid.DataSource.DataSet.Bookmark := FSelectedRows[i];
              //Обрабатываем только "замороженные" заявки текущего клиента
              if adsOrdersHFormFrozen.Value
                //and (adsOrdersHFormClientID.Value = DM.adtClientsCLIENTID.Value)
              then
                //удаляем только те "замороженные" заказы, по которым есть предложения
                if OffersByPriceExists(adsOrdersHFormPRICECODE.Value, adsOrdersHFormREGIONCODE.Value) then 
                  Grid.DataSource.DataSet.Delete
            end;
            Grid.DataSource.DataSet.Refresh;
          finally
            Grid.DataSource.DataSet.EnableControls;
          end;

          //если не нашли что-то, то выводим сообщение
          if Strings.Count > 0 then begin
            WriteExchangeLog('RestoreFrozenOrders', 'Заказы, восстановленные из "замороженных":'#13#10 + Strings.Text);
            ShowNotFound(Strings);
          end;

        finally
          Strings.Free;
        end;

        MainForm.SetOrdersInfo;
      end;
  end;
  if adsOrdersHForm.RecordCount = 0 then begin
    dbgCurrentOrders.ReadOnly := True;
    dbgSendedOrders.ReadOnly := True;
  end
  else begin
    dbgCurrentOrders.ReadOnly := False;
    dbgSendedOrders.ReadOnly := False;
  end;
end;

procedure TOrdersHForm.MoveToClient(DestinationClientId: Integer);
var
  Grid : TToughDBGrid;
  I : Integer;
begin
  if TabControl.TabIndex = 0 then
    Grid := dbgCurrentOrders
  else
    Exit;

  Grid.SetFocus;
  if not adsOrdersHForm.IsEmpty then
  begin
    FillSelectedRows(Grid);
    if FSelectedRows.Count > 0 then
      if AProc.MessageBox(
          'Внимание! Перемещаемые заявки будут объединены с текущими заявками.'#13#10 +
          'Перенести выбранные заявки?',
          MB_ICONQUESTION or MB_OKCANCEL) = IDOK
      then begin

        RestoreUnFrozenOrMoveToClient := True;
        InternalDestinationClientId := DestinationClientId;
        RestoreFrozen := False;
        Strings:=TStringList.Create;
        try
          ShowSQLWaiting(InternalMoveToPrice, 'Происходит перемещение заявок');

          Grid.DataSource.DataSet.DisableControls;
          try
            for I := 0 to FSelectedRows.Count-1 do begin
              Grid.DataSource.DataSet.Bookmark := FSelectedRows[i];
              //Обрабатываем только заявки текущего клиента или отсутствующего адреса заказа
              if (adsOrdersHFormClientID.Value = DM.adtClientsCLIENTID.Value)
                or adsOrdersHFormRealClientId.IsNull
              then
                Grid.DataSource.DataSet.Delete
            end;
            Grid.DataSource.DataSet.Refresh;
          finally
            Grid.DataSource.DataSet.EnableControls;
          end;

          //если не нашли что-то, то выводим сообщение
          if Strings.Count > 0 then ShowNotFound(Strings);

        finally
          Strings.Free;
        end;

        MainForm.SetOrdersInfo;
      end;
  end;
  if adsOrdersHForm.RecordCount = 0 then begin
    dbgCurrentOrders.ReadOnly := True;
    dbgSendedOrders.ReadOnly := True;
  end
  else begin
    dbgCurrentOrders.ReadOnly := False;
    dbgSendedOrders.ReadOnly := False;
  end;
end;

procedure TOrdersHForm.sbMoveToClientClick(Sender: TObject);
begin
  if pmDestinationClients.Items.Count > 0 then
    if pmDestinationClients.Items.Count = 1 then
      pmDestinationClients.Items[0].Click
    else
      pmDestinationClients.Popup(sbMoveToClient.ClientOrigin.X + sbMoveToClient.Width, sbMoveToClient.ClientOrigin.Y);
end;

procedure TOrdersHForm.FillDestinationClients;
var
  mi : TMenuItem;
  DestinationClientId : Integer;
  DestinationClientName : String;
begin
  pmDestinationClients.Items.Clear;

  DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text := 'SELECT ClientId, Name FROM CLIENTS where ClientId <> :ClientId';
  DM.adsQueryValue.ParamByName('ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
  DM.adsQueryValue.Open;
  try
    while not DM.adsQueryValue.Eof do begin
      DestinationClientId := DM.adsQueryValue.FieldByName('ClientId').AsInteger;
      DestinationClientName := DM.adsQueryValue.FieldByName('Name').AsString;

      mi := TMenuItem.Create(pmDestinationClients);
      mi.Name := 'dc' + IntToStr(DestinationClientId);
      mi.Caption := DestinationClientName;
      mi.Tag := DestinationClientId;
      mi.OnClick := OnDectinationClientClick;
      pmDestinationClients.Items.Add(mi);

      DM.adsQueryValue.Next;
    end;
  finally
    DM.adsQueryValue.Close;
  end;
end;

procedure TOrdersHForm.OnDectinationClientClick(Sender: TObject);
var
  mi : TMenuItem;
begin
  mi := TMenuItem(Sender);
  MoveToClient(mi.Tag);
end;

procedure TOrdersHForm.OnChangeCheckBoxAllOrders;
begin

end;

procedure TOrdersHForm.OnChangeFilterAllOrders;
begin
  tmrFillReport.Enabled := False;
  tmrFillReport.Enabled := True;
end;

procedure TOrdersHForm.tmrFillReportTimer(Sender: TObject);
begin
  tmrFillReport.Enabled := False;
  SetParameters;
end;

function TOrdersHForm.GetActionDescription: String;
begin
  if not RestoreUnFrozenOrMoveToClient then
    Result := 'восстановить'
  else
    if InternalDestinationClientId = 0 then
      Result := '"разморозить"'
    else
      Result := 'переместить';
end;

function TOrdersHForm.OffersByPriceExists(PriceCode,
  RegionCode: Int64): Boolean;
begin
  Result := False;

  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;

  try
    DM.adsQueryValue.SQL.Text:='SELECT PriceCode FROM PricesRegionalData where PriceCode = :PriceCode and RegionCode = :RegionCode and InJob = 1';
    DM.adsQueryValue.ParamByName('PriceCode').Value := PriceCode;
    DM.adsQueryValue.ParamByName('RegionCode').Value := RegionCode;
    DM.adsQueryValue.Open;

    if DM.adsQueryValue.IsEmpty then
      Exit;
  finally
    DM.adsQueryValue.Close();
  end;

  try
    DM.adsQueryValue.SQL.Text:='SELECT PriceCode FROM Core where PriceCode = :PriceCode and RegionCode = :RegionCode limit 10';
    DM.adsQueryValue.ParamByName('PriceCode').Value := PriceCode;
    DM.adsQueryValue.ParamByName('RegionCode').Value := RegionCode;
    DM.adsQueryValue.Open;

    if DM.adsQueryValue.IsEmpty then 
      Exit;
  finally
    DM.adsQueryValue.Close();
  end;

  Result := True;
end;

procedure TOrdersHForm.ShowCurrentActionButtons;
begin
  sbMoveToClient.Visible := sbMoveToClient.Enabled;
  btnFrozen.Visible := True;
  btnUnFrozen.Visible := True;
  btnMoveSend.Caption := '';
  btnMoveSend.Visible := False;
  btnWayBillList.Visible := False;
  ButtonLayout([btnDelete, btnFrozen, btnUnFrozen, sbMoveToClient, sbMoveToPrice]);
end;

procedure TOrdersHForm.ShowSendActionButtons;
begin
  sbMoveToClient.Visible := False;
  btnFrozen.Visible := False;
  btnUnFrozen.Visible := False;
  btnMoveSend.Caption := 'Вернуть в текущие';
  btnMoveSend.Visible := True;
  btnWayBillList.Visible := False;
  ButtonLayout([btnDelete, btnMoveSend, sbMoveToPrice]);
end;

procedure TOrdersHForm.ButtonLayout(buttons: array of TControl);
var
  i : Integer;
  prevButton : TControl;
begin
  If Length(buttons) > 0 then begin
    buttons[0].Left := 3;
    prevButton := buttons[0];
    for i := 1 to Length(buttons)-1 do
      if buttons[i].Visible then begin
        buttons[i].Left := prevButton.Left + prevButton.Width + 5;
        prevButton := buttons[i];
      end;
  end;
end;

procedure TOrdersHForm.PrepareDestinationPrices;
var
  i : Integer;
  sp : TSelectPrice;
  mi :TMenuItem;
begin
  sbMoveToPrice.Visible := not DM.adsUser.FieldByName('EnableImpersonalPrice').AsBoolean;
  if sbMoveToPrice.Visible then begin
    SelectedPrices := SummarySelectedPrices;
    for I := 0 to SelectedPrices.Count-1 do begin
      sp := TSelectPrice(SelectedPrices.Objects[i]);

      if sp.PriceSize > 0 then begin
        mi := TMenuItem.Create(pmDestinationPrices);
        mi.Name := 'sl' + SelectedPrices[i];
        mi.Caption := sp.PriceName;
        mi.Tag := Integer(sp);
        mi.OnClick := OnDectinationPriceClick;
        pmDestinationPrices.Items.Add(mi);
      end;
    end;
  end;
end;

procedure TOrdersHForm.OnDectinationPriceClick(Sender: TObject);
var
  Grid : TToughDBGrid;
begin
  if TabControl.TabIndex = 0 then
    Grid := dbgCurrentOrders
  else
    Grid := dbgSendedOrders;

  if AProc.MessageBox( 'Перераспределить выбранную заявку на других поставщиков?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK
  then begin

    MoveToPriceFromSend := Grid = dbgSendedOrders;

    Strings := TStringList.Create;
    try
      ShowSQLWaiting(
        InternalMoveToAnotherPrice,
        'Перемещение заявки на других поставщиков');

      Grid.DataSource.DataSet.DisableControls;
      try
        Grid.DataSource.DataSet.Bookmark := FSelectedRows[0];
        Grid.DataSource.DataSet.Refresh;
      finally
        Grid.DataSource.DataSet.EnableControls;
      end;

      //если не нашли что-то, то выводим сообщение
      if Strings.Count > 0 then ShowNotFound(Strings);

    finally
      Strings.Free;
    end;

    MainForm.SetOrdersInfo;

    if adsOrdersHForm.RecordCount = 0 then begin
      dbgCurrentOrders.ReadOnly := True;
      dbgSendedOrders.ReadOnly := True;
    end
    else begin
      dbgCurrentOrders.ReadOnly := False;
      dbgSendedOrders.ReadOnly := False;
    end;
  end;
end;

procedure TOrdersHForm.InternalMoveToAnotherPrice;
var
  I : Integer;
  LastBookmark : String;
  movedOrder : TCurrentOrderHead;
  offers : TObjectList;
  positionIndex : Integer;
  position : TCurrentOrderItem;
  notFoundPositionCount : Integer;

  procedure SetOrder( Order: Integer);
  begin
    with adsCore do begin
      Edit;
      FieldByName( 'OrderCount').AsInteger := Order;
      Post;
    end;
  end;

  procedure SaveOrderItem(orderItem : TCurrentOrderItem);
  begin
    with adsCore do begin
      ParamByName( 'ClientId').Value := DM.adtClients.FieldByName('ClientId').Value;
      ParamByName( 'PriceCode').Value := orderItem.Offer.PriceCode;
      ParamByName( 'RegionCode').Value := orderItem.Offer.RegionCode;
      ParamByName( 'DayOfWeek').Value := TDayOfWeekHelper.DayOfWeek();

      RestoreSQL;
      AddWhere('(CCore.CoreId = :CoreId)');
      ParamByName( 'CoreId').Value := orderItem.CoreId;

      Open;
      First;

      try
        SetOrder( FieldByName( 'OrderCount').AsInteger + orderItem.OrderCount);
      finally
        Close;
      end;
    end;
  end;

begin
  LastBookmark := adsOrdersHForm.Bookmark;
  adsOrdersHForm.DisableControls;
  try
    for I := 0 to FSelectedRows.Count-1 do begin
      adsOrdersHForm.Bookmark := FSelectedRows[i];

      //Производим работу только с заявками текущего клиента
      if adsOrdersHFormClientID.Value <> DM.adtClientsCLIENTID.Value then
        Continue;

      Application.ProcessMessages;

      DoSetCursor(crHourglass);
      try
        { открываем сохраненный заказ }
        movedOrder := GetOrderFormMove();
        try
          offers := TDBMapping.GetOffersByCurrentOrdersAndProductId(
            DM.MainConnection,
            movedOrder.AddressId,
            movedOrder.PriceCode,
            movedOrder.RegionCode,
            movedOrder.GetProductIds()
            );

          try
            movedOrder.RestoreOrderItemsToAnotherPrice(offers);

            Application.ProcessMessages;

            if movedOrder.CorrectionExists() then
              Strings.Add('   прайс-лист ' + movedOrder.PriceName);

            notFoundPositionCount := 0;
            for positionIndex := 0 to movedOrder.OrderItems.Count-1 do begin
              position := TCurrentOrderItem(movedOrder.OrderItems[positionIndex]);

              if not VarIsNull(position.CoreId) then begin
                SaveOrderItem(position);
                if not MoveToPriceFromSend then
                  DM.MainConnection.ExecSQL('delete from CurrentOrderLists where Id = ' + IntToStr(position.Id), []);
              end
              else
                Inc(notFoundPositionCount);

              if (not VarIsNull(position.DropReason)) then
                Strings.Add('      ' + position.ToRestoreReport());
            end;

            //Если работает с текущим заказом и все перераспределили, то удаляем заказ
            if not MoveToPriceFromSend and (notFoundPositionCount = 0) then
              DM.MainConnection.ExecSQL(
                'delete from CurrentOrderLists where OrderId = ' +IntToStr(movedOrder.OrderId) +';'#13#10 +
                  'delete from CurrentOrderHeads where ORDERID = ' + IntToStr(movedOrder.OrderId),
                []);
          finally
            offers.Free;
          end;

        finally
          movedOrder.Free;
        end;

      finally
        DoSetCursor(crDefault);
      end;
    end;

  finally
    adsOrdersHForm.Bookmark := LastBookmark;
    adsOrdersHForm.EnableControls;
  end;

  MainForm.SetOrdersInfo;

  dbgSendedOrders.Selection.Clear;
end;

function TOrdersHForm.GetOrderFormMove: TCurrentOrderHead;
var
  orderList : TObjectList;
begin
  Result := TCurrentOrderHead.Create();
  Result.Address := TAddress.Create();

  Result.Address.Id := adsOrdersHFormClientID.Value;
  Result.Address.Name := adsOrdersHFormAddressName.Value;

  Result.OrderId := adsOrdersHFormOrderId.Value;
  Result.AddressId := adsOrdersHFormClientID.Value;
  Result.PriceCode := adsOrdersHFormPriceCode.Value;
  Result.RegionCode := adsOrdersHFormRegionCode.Value;
  Result.PriceName := adsOrdersHFormPriceName.Value;
  Result.RegionName := adsOrdersHFormRegionName.Value;

  if not MoveToPriceFromSend then
    orderList := TDBMapping.GetCurrentOrderItemsByOrder(DM.MainConnection, Result)
  else
    orderList := TDBMapping.GetPostedOrderItemsByOrder(DM.MainConnection, Result);
  try
    orderList.OwnsObjects := False;
    Result.OrderItems.Assign(orderList);
  finally
    orderList.Free;
  end;
end;

procedure TOrdersHForm.SavePeriodToGlobals;
begin
  ordersDateFrom := dtpDateFrom.Date;
  ordersDateTo := dtpDateTo.Date;
end;

function TOrdersHForm.GetPostedCriteria: String;
begin
  Result := '';
  if GetAddressController.ShowAllOrders then begin
    Result := GetAddressController.GetFilter('PostedOrderHeads.ClientId');
  end
  else
    Result := #13#10' (PostedOrderHeads.ClientId = ' + IntToStr(DM.adtClientsCLIENTID.Value) + ') ';

  if Result <> '' then
    Result := Result + #13#10' and ';

  Result := Result
      + ' (PostedOrderHeads.SendDate >= :DateFrom) '
      + #13#10' and (PostedOrderHeads.SendDate <= :DateTo ) '
      + #13#10' and (PostedOrderHeads.Closed = 1) ';
end;

procedure TOrdersHForm.CheckPostedOrdersCountToShow(
  postedCriteria: String);
var
  ordersCount : Integer;
begin
  ordersCount := DM.QueryValue(
    'select count(OrderId) FROM PostedOrderHeads where ' + postedCriteria,
    ['DateFrom', 'DateTo'],
    [ordersDateFrom, IncDay(ordersDateTo)]);
  if ordersCount > postedOrdersLimit then begin
    AProc.MessageBox(Format('Внимание! Отображены последние %d документов', [postedOrdersLimit]), MB_ICONWARNING);
    ordersDateFrom := DM.QueryValue('' +
'select ' +
'  date(min(d.SendDate)) ' +
'from ' +
'  ( ' +
'   select ' +
'     PostedOrderHeads.SendDate ' +
'   FROM ' +
'     PostedOrderHeads ' +
'   where ' +
postedCriteria +
'   order by PostedOrderHeads.SendDate desc ' +
'   limit ' + IntToStr(postedOrdersLimit) +
'   ) d ',
      ['DateFrom', 'DateTo'],
      [ordersDateFrom, IncDay(ordersDateTo)]);
    //увеличиваем день на один, т.к. запросом выше может прийти середина дня,
    //а при выборке с начала суток количество заказов будет больше лимита
    //пример, пришла дата 01.07.2012 10:00, с этой даты будет 1000 заказов,
    // но в запросе мы передаем дату без времени, поэтому в результате может получиться больше 1000 заказов.
    ordersDateFrom := IncDay(ordersDateFrom);
    dtpDateFrom.DateTime := ordersDateFrom;
  end;
end;

procedure TOrdersHForm.dbMemoEnter(Sender: TObject);
begin
  inherited;
  if (Sender is TDBMemo)
    and not TDBMemo(Sender).ReadOnly
    and Assigned(TDBMemo(Sender).Field) then
    SoftEdit(TDBMemo(Sender).Field.DataSet);
end;

procedure TOrdersHForm.UpdateGridOnLegend(Sender: TObject);
begin
  if TabControl.TabIndex = 0 then
    dbgCurrentOrders.Invalidate
  else
    dbgSendedOrders.Invalidate;
end;

procedure TOrdersHForm.InternalMoveToPriceAction(Sender: TObject);
var
  Grid : TToughDBGrid;
begin
  if TabControl.TabIndex = 0 then
    Grid := dbgCurrentOrders
  else
    Grid := dbgSendedOrders;

  Grid.SetFocus;
  if not adsOrdersHForm.IsEmpty then
  begin
    FillSelectedRows(Grid);

    if FSelectedRows.Count > 1 then
      AProc.MessageBox( 'Перемещать в прайс-лист можно только по одной заявке.', MB_ICONWARNING)
    else
      if adsOrdersHFormClientID.Value <> DM.adtClientsCLIENTID.Value then
        AProc.MessageBox( 'Перемещать в прайс-лист можно только заявки текущего адреса заказа.', MB_ICONWARNING)
      else
        if FSelectedRows.Count = 1 then
          OnDectinationPriceClick(sbMoveToPrice);
  end;
end;

procedure TOrdersHForm.actMoveToPriceExecute(Sender: TObject);
begin
  InternalMoveToPriceAction(Sender);
end;

procedure TOrdersHForm.actMoveToPriceUpdate(Sender: TObject);
begin
  actMoveToPrice.Enabled := MainForm.actSendOrders.Enabled;
end;

initialization
  ordersDateFrom := StartOfTheMonth( IncMonth(Date, -3) );
  ordersDateTo := Date;
end.
