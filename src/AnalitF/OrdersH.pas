unit OrdersH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, DB, RXDBCtrl, Buttons,
  StdCtrls, Math, ComCtrls, DBCtrls, ExtCtrls, DBGridEh, ToughDBGrid, DateUtils,
  FR_DSet, FR_DBSet, OleCtrls, SHDocVw, 
  SQLWaiting, ShellAPI, GridsEh, MemDS,
  DBAccess, MyAccess, MemData, Orders,
  U_frameOrderHeadLegend, Menus;

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
    pWebBrowser: TPanel;
    Bevel2: TBevel;
    WebBrowser1: TWebBrowser;
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
  private
    Strings: TStrings;
    //Список выбранных строк в гридах
    FSelectedRows : TStringList;
    procedure MoveToPrice;
    procedure InternalMoveToPrice;
    procedure SetDateInterval;
    procedure OrderEnter;
    procedure FillSelectedRows(Grid : TToughDBGrid);
    procedure FillDestinationClients;
    procedure MoveToClient(DestinationClientId : Integer);
    procedure OnDectinationClientClick(Sender: TObject);
  protected
    FOrdersForm: TOrdersForm;
    RestoreUnFrozenOrMoveToClient : Boolean;
    InternalDestinationClientId : Integer;
  public
    frameOrderHeadLegend : TframeOrderHeadLegend;
    procedure SetParameters;
    procedure Print( APreview: boolean = False); override;
    procedure ShowForm; override;
    procedure ShowAsPrevForm; override;
  end;

procedure ShowOrdersH;

implementation

uses DModule, Main, AProc, NotFound, DBProc, Core, WayBillList, Constant,
     DBGridHelper,
     U_ExchangeLog;

{$R *.dfm}

procedure ShowOrdersH;
begin
  MainForm.ShowChildForm( TOrdersHForm );
end;

procedure TOrdersHForm.FormCreate(Sender: TObject);
var
  Year, Month, Day: Word;
begin
  inherited;

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
  NeedFirstOnDataSet := False;
  FSelectedRows := TStringList.Create;
  PrintEnabled := False;

  FOrdersForm := TOrdersForm( FindChildControlByClass(MainForm, TOrdersForm) );
  if FOrdersForm = nil then
    FOrdersForm := TOrdersForm.Create( Application);

  WayBillListForm := TWayBillListForm.Create(Application);
  TDBGridHelper.RestoreColumnsLayout(dbgCurrentOrders, 'CurrentOrders');
  TDBGridHelper.RestoreColumnsLayout(dbgSendedOrders, 'SendedOrders');

  Year := YearOf( Date);
  Month := MonthOf( Date);
  Day := DayOf( Date);
  IncAMonth( Year, Month, Day, -3);
  dtpDateFrom.Date := StartOfTheMonth( EncodeDate( Year, Month, Day));
  dtpDateTo.Date := Date;

  TabControl.TabIndex := 0;
  Screen.Cursor := crHourglass;
  try
    SetParameters;
  finally
    Screen.Cursor := crDefault;
  end;

  ShowForm;
end;

procedure TOrdersHForm.FormDestroy(Sender: TObject);
begin
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
begin
  Grid := nil;
  SoftPost( adsOrdersHForm);
  adsOrdersHForm.IndexFieldNames := '';
  adsOrdersHForm.Close;

  case TabControl.TabIndex of
    0:
    begin
      adsOrdersHForm.SQL.Text := adsCurrentOrders.SQL.Text;
      adsOrdersHForm.SQLRefresh.Text := adsCurrentOrders.SQLRefresh.Text;
      adsOrdersHForm.SQLDelete.Text := adsCurrentOrders.SQLDelete.Text;
      adsOrdersHForm.SQLUpdate.Text := adsCurrentOrders.SQLUpdate.Text;
      sbMoveToClient.Visible := sbMoveToClient.Enabled;
      btnFrozen.Visible := True;
      btnUnFrozen.Visible := True;
      btnMoveSend.Caption := '';
      btnMoveSend.Visible := False;
      btnWayBillList.Visible := False;
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
      adsOrdersHForm.SQL.Text := adsSendOrders.SQL.Text;
      adsOrdersHForm.SQLRefresh.Text := adsSendOrders.SQLRefresh.Text;
      adsOrdersHForm.SQLDelete.Text := adsSendOrders.SQLDelete.Text;
      adsOrdersHForm.SQLUpdate.Text := adsSendOrders.SQLUpdate.Text;
      adsOrdersHForm.ParamByName( 'DateFrom').AsDate := dtpDateFrom.Date;
      dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
      adsOrdersHForm.ParamByName( 'DateTo').AsDateTime := dtpDateTo.DateTime;
      sbMoveToClient.Visible := False;
      btnFrozen.Visible := False;
      btnUnFrozen.Visible := False;
      btnMoveSend.Caption := 'Вернуть в текущие';
      btnMoveSend.Visible := True;
      btnWayBillList.Visible := True;
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
            Grid.DataSource.DataSet.Delete;
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
      Background := clRed;

    if adsOrdersHFormFrozen.Value then
      Background := FrozenOrderColor;

    if FUseCorrectOrders then begin
      if (adsOrdersHFormDifferentCostCount.Value > 0)
         and (Column.Field = adsOrdersHFormSumOrder)
      then
        Background := NeedCorrectColor;

      if (adsOrdersHFormDifferentQuantityCount.Value > 0)
         and (Column.Field = adsOrdersHFormPositions)
      then
        Background := NeedCorrectColor;
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
	ParamByName('DateFrom').AsDate:=dtpDateFrom.Date;
	dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
	ParamByName('DateTo').AsDateTime := dtpDateTo.DateTime;
    Screen.Cursor:=crHourglass;
    try
      if Active then
      begin
        Close;
        Open;
      end
      else
        Open;
    finally
      Screen.Cursor:=crDefault;
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
        DM.ShowOrderDetailsReport(
          adsOrdersHFormORDERID.AsInteger,
          adsOrdersHFormCLOSED.Value,
          adsOrdersHFormSEND.Value,
          APreview,
          True);
        adsOrdersHForm.Next;
      end;

      while not adsOrdersHForm.Eof do
      begin
        //Если заказ закрыт или не закрыт и разрешен к отправке
        if adsOrdersHFormCLOSED.Value or (adsOrdersHFormSEND.Value) then
        begin
          DM.ShowOrderDetailsReport(
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
	ShellExecute( 0, 'Open', PChar(ExePath + SDirWaybills + '\'),
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

      with DM.adsQueryValue do begin
        if Active then
          Close;
        SQL.Text:='SELECT * FROM PricesRegionalData where PriceCode = :PriceCode and RegionCode = :RegionCode';
        ParamByName('PriceCode').Value:=adsOrdersHFormPRICECODE.Value;
        ParamByName('RegionCode').Value:=adsOrdersHFormREGIONCODE.Value;
        Open;
        try
          { проверяем наличие прайс-листа }
          if IsEmpty then
            raise Exception.Create( 'Данный прайс-лист не найден');
        finally
          Close;
        end;
        Application.ProcessMessages;
      end;

      Screen.Cursor:=crHourglass;
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
            if RestoreUnFrozenOrMoveToClient and (InternalDestinationClientId <> 0) then
              ParamByName( 'ClientId').Value := InternalDestinationClientId
            else
              ParamByName( 'ClientId').Value := DM.adtClients.FieldByName('ClientId').Value;
            ParamByName( 'PriceCode').Value:=adsOrdersHFormPRICECODE.Value;
            ParamByName( 'RegionCode').Value:=adsOrdersHFormREGIONCODE.Value;
            ParamByName( 'SynonymCode').Value:=SynonymCode;

            RestoreSQL;
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
        Screen.Cursor:=crDefault;
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
  Strings : TStringList;
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
          'Внимание! "Размороженные" заявки будут объеденены с текущими заявками.'#13#10 +
          '"Разморозить" выбранные заявки?',
          MB_ICONQUESTION or MB_OKCANCEL) = IDOK
      then begin

        RestoreUnFrozenOrMoveToClient := True;
        InternalDestinationClientId := 0;
        Strings:=TStringList.Create;
        try
          ShowSQLWaiting(InternalMoveToPrice, 'Происходит "размороживание" заявок');

          Grid.DataSource.DataSet.DisableControls;
          try
            for I := 0 to FSelectedRows.Count-1 do begin
              Grid.DataSource.DataSet.Bookmark := FSelectedRows[i];
              if adsOrdersHFormFrozen.Value then
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
  Strings : TStringList;
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
          'Внимание! Перемещяемые заявки будут объеденены с текущими заявками.'#13#10 +
          'Перенести выбранные заявки?',
          MB_ICONQUESTION or MB_OKCANCEL) = IDOK
      then begin

        RestoreUnFrozenOrMoveToClient := True;
        InternalDestinationClientId := DestinationClientId;
        Strings:=TStringList.Create;
        try
          ShowSQLWaiting(InternalMoveToPrice, 'Происходит перемещение заявок');

          Grid.DataSource.DataSet.DisableControls;
          try
            for I := 0 to FSelectedRows.Count-1 do begin
              Grid.DataSource.DataSet.Bookmark := FSelectedRows[i];
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
  DM.adsQueryValue.SQL.Text := 'SELECT * FROM CLIENTS where ClientId <> :ClientId';
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

end.
