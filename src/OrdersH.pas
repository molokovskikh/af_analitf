unit OrdersH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, DB, RXDBCtrl, Buttons,
  StdCtrls, Math, ComCtrls, DBCtrls, ExtCtrls, DBGridEh, ToughDBGrid, Registry, DateUtils,
  FR_DSet, FR_DBSet, OleCtrls, SHDocVw, FIBDataSet, pFIBDataSet,
  FIBSQLMonitor, FIBQuery, SQLWaiting, ShellAPI, GridsEh, pFIBProps;

type
  TSumOrder = class
    Sum : Currency;
    constructor Create(ASum : Currency);
  end;

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
    dsWayBillHead: TDataSource;
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
    adsOrdersHForm: TpFIBDataSet;
    adsCore: TpFIBDataSet;
    adsWayBillHead: TpFIBDataSet;
    adsWayBillHeadSERVERID: TFIBBCDField;
    adsWayBillHeadSERVERORDERID: TFIBBCDField;
    adsWayBillHeadWRITETIME: TFIBDateTimeField;
    adsWayBillHeadCLIENTID: TFIBBCDField;
    adsWayBillHeadPRICECODE: TFIBBCDField;
    adsWayBillHeadREGIONCODE: TFIBBCDField;
    adsWayBillHeadPRICENAME: TFIBStringField;
    adsWayBillHeadREGIONNAME: TFIBStringField;
    adsWayBillHeadFIRMCOMMENT: TFIBStringField;
    adsWayBillHeadROWCOUNT: TFIBIntegerField;
    adsOrdersHFormORDERID: TFIBBCDField;
    adsOrdersHFormSERVERORDERID: TFIBBCDField;
    adsOrdersHFormDATEPRICE: TFIBDateTimeField;
    adsOrdersHFormPRICECODE: TFIBBCDField;
    adsOrdersHFormREGIONCODE: TFIBBCDField;
    adsOrdersHFormORDERDATE: TFIBDateTimeField;
    adsOrdersHFormSENDDATE: TFIBDateTimeField;
    adsOrdersHFormPRICENAME: TFIBStringField;
    adsOrdersHFormREGIONNAME: TFIBStringField;
    adsOrdersHFormPOSITIONS: TFIBIntegerField;
    adsOrdersHFormSUPPORTPHONE: TFIBStringField;
    adsOrdersHFormSumOrder: TFIBBCDField;
    adsOrdersHFormSEND: TFIBBooleanField;
    adsOrdersHFormCLOSED: TFIBBooleanField;
    adsOrdersHFormMESSAGETO: TFIBMemoField;
    adsOrdersHFormCOMMENTS: TFIBMemoField;
    bevClient: TBevel;
    adsOrdersHFormMINREQ: TFIBIntegerField;
    adsOrdersHFormSUMBYCURRENTMONTH: TFIBBCDField;
    dbgSendedOrders: TToughDBGrid;
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
    procedure adsOrdersHFormCalcFields(DataSet: TDataSet);
    procedure adsOrdersHFormAfterFetchRecord(FromQuery: TFIBQuery;
      RecordNumber: Integer; var StopFetching: Boolean);
  private
    FSumOrders : TStringList;
    Strings: TStrings;
    procedure MoveToPrice;
    procedure InternalMoveToPrice;
    procedure SendOrders;
    procedure SetDateInterval;
    procedure ClearSumOrders;
    procedure OrderEnter;
  public
    procedure SetParameters;
    procedure Print( APreview: boolean = False); override;
    procedure ShowForm; override;
  end;

var
  OrdersHForm: TOrdersHForm;

procedure ShowOrdersH;

implementation

uses DModule, Main, AProc, Orders, NotFound, DBProc, Core, WayBillList, Constant;

{$R *.dfm}

procedure ShowOrdersH;
begin
	OrdersHForm := TOrdersHForm( MainForm.ShowChildForm( TOrdersHForm));
end;

procedure TOrdersHForm.FormCreate(Sender: TObject);
var
	Reg: TRegIniFile;
	Year, Month, Day: Word;
begin
  adsOrdersHForm.Options := adsOrdersHForm.Options - [poCacheCalcFields];
	inherited;
  NeedFirstOnDataSet := False;
  FSumOrders := TStringList.Create;
  FSumOrders.Sorted := True;
	PrintEnabled := False;
	OrdersForm := TOrdersForm.Create( Application);
  WayBillListForm := TWayBillListForm.Create(Application);
	Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'CurrentOrders', False)
    then
      dbgCurrentOrders.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'SendedOrders', False)
    then
      dbgSendedOrders.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
  finally
  	Reg.Free;
  end;

  adsOrdersHForm.Prepare;

	Year := YearOf( Date);
	Month := MonthOf( Date);
	Day := DayOf( Date);
	IncAMonth( Year, Month, Day, -3);
	dtpDateFrom.Date := StartOfTheMonth( EncodeDate( Year, Month, Day));
	dtpDateTo.Date := Date;

	TabControl.TabIndex := 0;
	Screen.Cursor := crHourglass;
	try
		adsOrdersHForm.ParamByName('AClientId').Value:=
			DM.adtClients.FieldByName('ClientId').Value;
    adsOrdersHForm.ParamByName('DateFrom').AsDate:=dtpDateFrom.Date;
		dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
		adsOrdersHForm.ParamByName('DateTo').AsDate:=dtpDateTo.Date;
		adsOrdersHForm.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
		SetParameters;
	finally
		Screen.Cursor := crDefault;
	end;

	ShowForm;
end;

procedure TOrdersHForm.FormDestroy(Sender: TObject);
var
	Reg: TRegIniFile;
begin
  try
    //TODO: ___ Здесь возникает ошибка с AccessViolation в FBPlus.
    //Возможно эта моя ошибка, но я пока не могу ее исправить
	  SoftPost(adsOrdersHForm);
  except
  end;
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'CurrentOrders', True);
    dbgCurrentOrders.SaveColumnsLayout(Reg);
    Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'SendedOrders', True);
    dbgSendedOrders.SaveColumnsLayout(Reg);
  finally
    Reg.Free;
  end;
  ClearSumOrders;
  FSumOrders.Free;
end;

procedure TOrdersHForm.SetParameters;
begin
	SoftPost( adsOrdersHForm);
	case TabControl.TabIndex of
		0: begin
			adsOrdersHForm.Close;
			adsOrdersHForm.ParamByName( 'AClosed').Value := False;
			btnMoveSend.Caption := 'Перевести в отправленные';
      btnMoveSend.Visible := False;
      btnWayBillList.Visible := False;
      dbgCurrentOrders.Visible := True;
      dbgSendedOrders.Visible := False;
      //try except необходим, т.к. вызвается когда форма еще не отображена
      try
        dbgCurrentOrders.SetFocus;
      except end;
		end;
		1: begin
			adsOrdersHForm.Close;
			adsOrdersHForm.ParamByName( 'AClosed').Value := True;
			btnMoveSend.Caption := 'Вернуть в текущие';
      btnMoveSend.Visible := True;
      btnWayBillList.Visible := True;
      dbgCurrentOrders.Visible := False;
      dbgSendedOrders.Visible := True;
      //try except необходим, т.к. вызвается когда форма еще не отображена
      try
        dbgSendedOrders.SetFocus;
      except end;
		end;
	end;

	adsOrdersHForm.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').Value;
	adsOrdersHForm.ParamByName( 'DateFrom').AsDate := dtpDateFrom.Date;
	dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
	adsOrdersHForm.ParamByName( 'DateTo').AsDateTime := dtpDateTo.DateTime;
	adsOrdersHForm.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;

  adsOrdersHForm.Close;
  ClearSumOrders;

  adsOrdersHForm.Prepare;
  adsOrdersHForm.Open;

	dbmMessage.ReadOnly := TabControl.TabIndex = 1;
  PrintEnabled := ((TabControl.TabIndex = 0) and ((DM.SaveGridMask and PrintCurrentOrder) > 0))
               or ((TabControl.TabIndex = 1) and ((DM.SaveGridMask and PrintSendedOrder) > 0));
  OrdersForm.PrintEnabled := PrintEnabled;
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
begin
  if TabControl.TabIndex = 0 then
    Grid := dbgCurrentOrders
  else
    Grid := dbgSendedOrders;

  Grid.SetFocus;
	if not adsOrdersHForm.IsEmpty then
	begin
    if (Grid.SelectedRows.Count = 0) and (not Grid.SelectedRows.CurrentRowSelected) then
      Grid.SelectedRows.CurrentRowSelected := True;
    if Grid.SelectedRows.Count > 0 then
      if AProc.MessageBox( 'Удалить выбранные заявки?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then begin
        Grid.SelectedRows.Delete;
        DM.InitAllSumOrder;
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
var
  Grid : TToughDBGrid;
begin
  if TabControl.TabIndex = 0 then
    Grid := dbgCurrentOrders
  else
    Grid := dbgSendedOrders;
	Grid.SetFocus;
	case TabControl.TabIndex of
		0: SendOrders;
		1: MoveToPrice;
	end;
	MainForm.SetOrdersInfo;
end;

procedure TOrdersHForm.MoveToPrice;
begin
  if adsOrdersHForm.IsEmpty or ( TabControl.TabIndex<>1) then Exit;

  if AProc.MessageBox( 'Вернуть выбранные заявки в работу?',MB_ICONQUESTION+MB_OKCANCEL)<>IDOK then exit;

  if (dbgSendedOrders.SelectedRows.Count = 0) and (not dbgSendedOrders.SelectedRows.CurrentRowSelected) then
    dbgSendedOrders.SelectedRows.CurrentRowSelected := True;

  if dbgSendedOrders.SelectedRows.Count > 0 then begin
    Strings:=TStringList.Create;
    try
      ShowSQLWaiting(InternalMoveToPrice, 'Происходит восстановление заявок');

      //если не нашли что-то, то выводим сообщение
      if Strings.Count > 0 then ShowNotFound(Strings);

    finally
      Strings.Free;
    end;
  end;
end;

procedure TOrdersHForm.SendOrders;
var
  I : Integer;
begin
	if adsOrdersHForm.IsEmpty or ( TabControl.TabIndex<>0) then Exit;

  if (dbgCurrentOrders.SelectedRows.Count = 0) and (not dbgCurrentOrders.SelectedRows.CurrentRowSelected) then
    dbgCurrentOrders.SelectedRows.CurrentRowSelected := True;

  if dbgCurrentOrders.SelectedRows.Count > 0 then begin
    for I := dbgCurrentOrders.SelectedRows.Count-1 downto 0 do
    begin
      adsOrdersHForm.GotoBookmark(Pointer(dbgCurrentOrders.SelectedRows.Items[i]));
      if adsOrdersHForm.FieldByName( 'Send').AsBoolean then
      begin
        adsOrdersHFormSEND.OnChange := nil;
        try
          adsOrdersHForm.Edit;
          adsOrdersHForm.FieldByName( 'Send').AsBoolean := False;
          adsOrdersHForm.FieldByName( 'Closed').AsBoolean := True;
          DM.adcUpdate.Transaction.StartTransaction;
          try
            DM.adcUpdate.SQL.Text := 'UPDATE Orders SET CoreId=NULL WHERE OrderId=' +
              adsOrdersHForm.FieldByName( 'OrderId').AsString;
            DM.adcUpdate.ExecQuery;
            DM.adcUpdate.Transaction.Commit;
          except
            DM.adcUpdate.Transaction.Rollback;
            raise;
          end;
          adsOrdersHForm.Post;
        finally
          adsOrdersHFormSEND.OnChange := adsOrdersH2SendChange;
        end;
      end;
    end;
    SetParameters;
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
		Self.PrevForm.Show;
		MainForm.ActiveChild := Self.PrevForm;
		MainForm.ActiveControl := Self.PrevForm.ActiveControl;
	end;
	if ( Key = VK_DELETE) and not ( adsOrdersHForm.IsEmpty) then
	begin
    btnDeleteClick(nil);
    DM.InitAllSumOrder;
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
  if TabControl.TabIndex = 0 then
    if (Column.Field = adsOrdersHFormMINREQ) and not adsOrdersHFormMINREQ.IsNull and (adsOrdersHFormMINREQ.AsInteger > adsOrdersHFormSumOrder.AsCurrency) then
      Background := clRed;

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
	ParamByName('DateTo').AsDate := dtpDateTo.Date;
    Screen.Cursor:=crHourglass;
    try
      if Active then CloseOpen(True) else Open;
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
            True);
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
  //Здесь не нужный комментарий
  if adsOrdersHFormORDERID.IsNull then Abort; 
end;

procedure TOrdersHForm.dbgCurrentOrdersSortMarkingChanged(Sender: TObject);
begin
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TOrdersHForm.adsOrdersHFormCalcFields(DataSet: TDataSet);
begin
  adsOrdersHFormSumOrder.AsCurrency :=
    TSumOrder(FSumOrders.Objects[(FSumOrders.IndexOf(adsOrdersHFormORDERID.AsString))]).Sum;
end;

procedure TOrdersHForm.ClearSumOrders;
var
  I : Integer;
begin
  for I := 0 to FSumOrders.Count-1 do
    FSumOrders.Objects[i].Free;
  FSumOrders.Clear;
end;

{ TSumOrder }

constructor TSumOrder.Create(ASum: Currency);
begin
  Sum := ASum;
end;

procedure TOrdersHForm.adsOrdersHFormAfterFetchRecord(FromQuery: TFIBQuery;
  RecordNumber: Integer; var StopFetching: Boolean);
var
  F : TFIBXSQLVAR;
  SumOrder : Currency;
  Index : Integer;
begin
  F := FromQuery.FldByName[adsOrdersHFormORDERID.FieldName];
  //Если заказ текущий, то данные берем из общего кеша
  if not FromQuery.FldByName[adsOrdersHFormCLOSED.FieldName].AsBoolean then begin
    SumOrder := DM.FindOrderInfo(
            FromQuery.FldByName[adsOrdersHFormPRICECODE.FieldName].AsInteger,
            FromQuery.FldByName[adsOrdersHFormREGIONCODE.FieldName].AsInteger).Summ;
    Index := FSumOrders.IndexOf(F.AsString);
    if (Index = -1) then
      FSumOrders.AddObject( F.AsString, TSumOrder.Create(SumOrder) )
    else
      TSumOrder(FSumOrders.Objects[Index]).Sum := SumOrder;
  end
  else begin
    //Если заказ архивный, то берем из базы
    try
      SumOrder := DM.MainConnection1.QueryValue('SELECT Sum(Orders.sendprice*Orders.OrderCount) SumOrder FROM Orders WHERE Orders.OrderId = :OrderId AND Orders.OrderCount>0', 0, [F.AsString]);
    except
      SumOrder := 0;
    end;
    Index := FSumOrders.IndexOf(F.AsString);
    if (Index = -1) then
      FSumOrders.AddObject( F.AsString, TSumOrder.Create(SumOrder) )
    else
      TSumOrder(FSumOrders.Objects[Index]).Sum := SumOrder;
  end;
end;

procedure TOrdersHForm.OrderEnter;
begin
  OrdersForm.ShowForm( adsOrdersHFormORDERID.AsInteger);
end;

procedure TOrdersHForm.InternalMoveToPrice;
var
	Order, CurOrder, Quantity, E: Integer;
	SynonymFirmCrCode, SynonymCode: Variant;
  Code, RequestRatio, OrderCost, MinOrderCount : Variant;
  I : Integer;
  RecCountSRV : Integer;

  procedure SetOrder( Order: Integer);
  begin
    with adsCore do begin
      Edit;
      FieldByName( 'OrderCount').AsInteger := Order;
      Post;
    end;
  end;

begin
  for I := dbgSendedOrders.SelectedRows.Count-1 downto 0 do
  begin
    adsOrdersHForm.GotoBookmark(Pointer(dbgSendedOrders.SelectedRows.Items[i]));

    with DM.adsSelect do begin
      SelectSQL.Text:='SELECT * FROM PricesRegionalData where PriceCode = :APriceCode and RegionCode = :ARegionCode';
      ParamByName('APriceCode').Value:=adsOrdersHFormPRICECODE.Value;
      ParamByName('ARegionCode').Value:=adsOrdersHFormREGIONCODE.Value;
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
      OrdersForm.SetParams( adsOrdersHFormORDERID.AsInteger);
      Application.ProcessMessages;
      { переписываем позиции в текущий прайс-лист }
      while not OrdersForm.adsOrders.Eof do begin
        Order:=OrdersForm.adsOrdersORDERCOUNT.AsInteger;

        Code := OrdersForm.adsOrdersCode.AsVariant;
        RequestRatio := OrdersForm.adsOrdersORDERSREQUESTRATIO.AsVariant;
        OrderCost := OrdersForm.adsOrdersORDERSORDERCOST.AsVariant;
        MinOrderCount := OrdersForm.adsOrdersORDERSMINORDERCOUNT.AsVariant;

        SynonymCode:=OrdersForm.adsOrdersSynonymCode.AsInteger;
        SynonymFirmCrCode:=OrdersForm.adsOrdersSynonymFirmCrCode.AsInteger;
        //if SynonymFirmCrCode = 0 then SynonymFirmCrCode := Null;

        with adsCore do begin
          ParamByName( 'AClientId').Value:=DM.adtClients.FieldByName('ClientId').Value;
          ParamByName( 'APriceCode').Value:=adsOrdersHFormPRICECODE.Value;
          ParamByName( 'ARegionCode').Value:=adsOrdersHFormREGIONCODE.Value;
          ParamByName( 'SynonymCode').Value:=SynonymCode;
          ParamByName( 'SynonymFirmCrCode').Value:=SynonymFirmCrCode;
          Open;
          FetchAll;
          RecCountSRV := adsCore.RecordCountFromSrv;
          try
            { пытаемся разбросать заказ по нужным Code, SynonymCode и SynonymFirmCrCode }
            if Locate( 'Code;REQUESTRATIO;ORDERCOST;MINORDERCOUNT', VarArrayOf([ Code, RequestRatio, OrderCost, MinOrderCount]), [])
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
              until ( Order = 0) or (not LocateNext( 'Code;REQUESTRATIO;ORDERCOST;MINORDERCOUNT', VarArrayOf([ Code, RequestRatio, OrderCost, MinOrderCount]), [])) or (RecCountSRV = adsCore.RecordCount);
            end;

            { если все еще не разбросали, то пишем сообщение }
            if Order > 0 then
            begin
              if ( OrdersForm.adsOrdersORDERCOUNT.AsInteger - Order) > 0 then
              begin
                Strings.Append( Format( '%s : %s - %s : %d вместо %d',
                  [adsOrdersHFormPRICENAME.AsString,
                  OrdersForm.adsOrdersSYNONYMNAME.AsString,
                  OrdersForm.adsOrdersSYNONYMFIRM.AsString,
                  OrdersForm.adsOrdersORDERCOUNT.AsInteger - Order,
                  OrdersForm.adsOrdersORDERCOUNT.AsInteger]));
              end
              else
                Strings.Append( Format( '%s : %s - %s : предложение не найдено',
                  [adsOrdersHFormPRICENAME.AsString,
                  OrdersForm.adsOrdersSYNONYMNAME.AsString,
                  OrdersForm.adsOrdersSYNONYMFIRM.AsString]));
            end;

          finally
            Close;
          end;
        end;

        OrdersForm.adsOrders.Next;
        Application.ProcessMessages;
      end;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;

  DM.InitAllSumOrder;
  MainForm.SetOrdersInfo;

  dbgSendedOrders.SelectedRows.Clear;
end;

procedure TOrdersHForm.ShowForm;
var
  Index : Integer;
begin
  inherited;
  if Assigned(PrevForm) and (PrevForm is TOrdersForm) then begin
    //Если мы производим возврат из окна "Архивный заказ", то надо обновить сумму
    if not adsOrdersHFormCLOSED.AsBoolean then begin
      Index := FSumOrders.IndexOf(adsOrdersHFormORDERID.AsString);
      if (Index > -1) then
        TSumOrder(FSumOrders.Objects[(FSumOrders.IndexOf(adsOrdersHFormORDERID.AsString))]).Sum :=
          DM.FindOrderInfo(adsOrdersHFormPRICECODE.AsInteger, adsOrdersHFormREGIONCODE.AsInteger).Summ;
      adsOrdersHForm.RefreshClientFields();
    end;
  end;
end;

end.
