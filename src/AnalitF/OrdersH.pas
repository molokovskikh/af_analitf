unit OrdersH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, DB, RXDBCtrl, Buttons,
  StdCtrls, Math, ComCtrls, DBCtrls, ExtCtrls, DBGridEh, ToughDBGrid, Registry, DateUtils,
  FR_DSet, FR_DBSet, OleCtrls, SHDocVw, FIBDataSet, pFIBDataSet,
  FIBSQLMonitor, FIBQuery, SQLWaiting, ShellAPI, GridsEh, pFIBProps, MemDS,
  DBAccess, MyAccess, MemData;

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
    adsOrdersHFormOld: TpFIBDataSet;
    adsCoreOld: TpFIBDataSet;
    adsOrdersHFormOldORDERID: TFIBBCDField;
    adsOrdersHFormOldSERVERORDERID: TFIBBCDField;
    adsOrdersHFormOldDATEPRICE: TFIBDateTimeField;
    adsOrdersHFormOldPRICECODE: TFIBBCDField;
    adsOrdersHFormOldREGIONCODE: TFIBBCDField;
    adsOrdersHFormOldORDERDATE: TFIBDateTimeField;
    adsOrdersHFormOldSENDDATE: TFIBDateTimeField;
    adsOrdersHFormOldPRICENAME: TFIBStringField;
    adsOrdersHFormOldREGIONNAME: TFIBStringField;
    adsOrdersHFormOldPOSITIONS: TFIBIntegerField;
    adsOrdersHFormOldSUPPORTPHONE: TFIBStringField;
    adsOrdersHFormOldSumOrder: TFIBBCDField;
    adsOrdersHFormOldSEND: TFIBBooleanField;
    adsOrdersHFormOldCLOSED: TFIBBooleanField;
    adsOrdersHFormOldMESSAGETO: TFIBMemoField;
    adsOrdersHFormOldCOMMENTS: TFIBMemoField;
    bevClient: TBevel;
    adsOrdersHFormOldMINREQ: TFIBIntegerField;
    adsOrdersHFormOldSUMBYCURRENTMONTH: TFIBBCDField;
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
    adsOrdersHFormminreq: TIntegerField;
    adsOrdersHFormPriceEnabled: TBooleanField;
    adsOrdersHFormPositions: TLargeintField;
    adsOrdersHFormSumOrder: TFloatField;
    adsOrdersHFormsumbycurrentmonth: TFloatField;
    adsOrdersHFormDisplayOrderId: TLargeintField;
    adsCore: TMyQuery;
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
    procedure adsOrdersHFormOldCalcFields(DataSet: TDataSet);
    procedure adsOrdersHFormOldAfterFetchRecord(FromQuery: TFIBQuery;
      RecordNumber: Integer; var StopFetching: Boolean);
    procedure adsOrdersHFormBeforeInsert(DataSet: TDataSet);
    procedure adsCoreBeforePost(DataSet: TDataSet);
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
	inherited;
  NeedFirstOnDataSet := False;
  FSumOrders := TStringList.Create;
  FSumOrders.Sorted := True;
	PrintEnabled := False;

  OrdersForm := TOrdersForm( FindChildControlByClass(MainForm, TOrdersForm) );
  if OrdersForm = nil then
    OrdersForm := TOrdersForm.Create( Application);

  WayBillListForm := TWayBillListForm.Create(Application);
	Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'CurrentOrders', False)
    then
      try
        dbgCurrentOrders.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
      finally
        Reg.CloseKey;
      end;
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'SendedOrders', False)
    then
      try
        dbgSendedOrders.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
      finally
        Reg.CloseKey;
      end;
  finally
  	Reg.Free;
  end;

	Year := YearOf( Date);
	Month := MonthOf( Date);
	Day := DayOf( Date);
	IncAMonth( Year, Month, Day, -3);
	dtpDateFrom.Date := StartOfTheMonth( EncodeDate( Year, Month, Day));
	dtpDateTo.Date := Date;

	TabControl.TabIndex := 0;
	Screen.Cursor := crHourglass;
	try
		adsOrdersHForm.ParamByName('ClientId').Value:=
			DM.adtClients.FieldByName('ClientId').Value;
    adsOrdersHForm.ParamByName('DateFrom').AsDate:=dtpDateFrom.Date;
		dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
		adsOrdersHForm.ParamByName('DateTo').AsDateTime:=dtpDateTo.DateTime;
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
    //TODO: ___ ����� ��������� ������ � AccessViolation � FBPlus.
    //�������� ��� ��� ������, �� � ���� �� ���� �� ���������
	  SoftPost(adsOrdersHForm);
  except
  end;
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'CurrentOrders', True);
    try
      dbgCurrentOrders.SaveColumnsLayout(Reg);
    finally
      Reg.CloseKey;
    end;
    Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'SendedOrders', True);
    try
      dbgSendedOrders.SaveColumnsLayout(Reg);
    finally
      Reg.CloseKey;
    end;
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
			btnMoveSend.Caption := '��������� � ������������';
      btnMoveSend.Visible := False;
      btnWayBillList.Visible := False;
      dbgCurrentOrders.Visible := True;
      dbgSendedOrders.Visible := False;
      //try except ���������, �.�. ��������� ����� ����� ��� �� ����������
      try
        dbgCurrentOrders.SetFocus;
      except end;
		end;
		1: begin
			adsOrdersHForm.Close;
			adsOrdersHForm.ParamByName( 'AClosed').Value := True;
			btnMoveSend.Caption := '������� � �������';
      btnMoveSend.Visible := True;
      btnWayBillList.Visible := True;
      dbgCurrentOrders.Visible := False;
      dbgSendedOrders.Visible := True;
      //try except ���������, �.�. ��������� ����� ����� ��� �� ����������
      try
        dbgSendedOrders.SetFocus;
      except end;
		end;
	end;

	adsOrdersHForm.ParamByName( 'ClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').Value;
	adsOrdersHForm.ParamByName( 'DateFrom').AsDate := dtpDateFrom.Date;
	dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
	adsOrdersHForm.ParamByName( 'DateTo').AsDateTime := dtpDateTo.DateTime;
	adsOrdersHForm.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;

  adsOrdersHForm.Close;
  ClearSumOrders;

  adsOrdersHForm.Open;

  dtpDateFrom.Enabled := TabControl.TabIndex = 1;
  dtpDateTo.Enabled   := dtpDateFrom.Enabled;

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
      if AProc.MessageBox( '������� ��������� ������?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then begin
        Grid.SelectedRows.Delete;
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

  if AProc.MessageBox( '������� ��������� ������ � ������?',MB_ICONQUESTION+MB_OKCANCEL)<>IDOK then exit;

  if (dbgSendedOrders.SelectedRows.Count = 0) and (not dbgSendedOrders.SelectedRows.CurrentRowSelected) then
    dbgSendedOrders.SelectedRows.CurrentRowSelected := True;

  if dbgSendedOrders.SelectedRows.Count > 0 then begin
    Strings:=TStringList.Create;
    try
      ShowSQLWaiting(InternalMoveToPrice, '���������� �������������� ������');

      //���� �� ����� ���-��, �� ������� ���������
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
          DM.adcUpdate.SQL.Text := 'UPDATE OrdersList SET CoreId=NULL WHERE OrderId=' +
            adsOrdersHForm.FieldByName( 'OrderId').AsString;
          DM.adcUpdate.Execute;
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

  //���� ������ "��������������� ��������", �� ���������� ������ ������� �����,
  //����� ������� �� ������ ��� ������ �� ������
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
        //���� ����� ������ ��� �� ������ � �������� � ��������
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
  //��-������� ������ �������� �� �������. �������� ������, ����� �� � ������� ����
  //�������� ���������� dataset
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

procedure TOrdersHForm.adsOrdersHFormOldCalcFields(DataSet: TDataSet);
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

procedure TOrdersHForm.adsOrdersHFormOldAfterFetchRecord(FromQuery: TFIBQuery;
  RecordNumber: Integer; var StopFetching: Boolean);
var
  F : TFIBXSQLVAR;
  SumOrder : Currency;
  Index : Integer;
begin
  F := FromQuery.FldByName[adsOrdersHFormORDERID.FieldName];
  //���� ����� �������, �� ������ ����� �� ������ ����
  if not FromQuery.FldByName[adsOrdersHFormCLOSED.FieldName].AsBoolean then begin
    SumOrder := DM.FindOrderInfo(
            FromQuery.FldByName[adsOrdersHFormPRICECODE.FieldName].AsInteger,
            FromQuery.FldByName[adsOrdersHFormREGIONCODE.FieldName].AsInteger);
    Index := FSumOrders.IndexOf(F.AsString);
    if (Index = -1) then
      FSumOrders.AddObject( F.AsString, TSumOrder.Create(SumOrder) )
    else
      TSumOrder(FSumOrders.Objects[Index]).Sum := SumOrder;
  end
  else begin
    //���� ����� ��������, �� ����� �� ����
    try
      SumOrder := DM.QueryValue(
        'SELECT ifnull(Sum(OrdersList.price*OrdersList.OrderCount), 0) SumOrder '
        + 'FROM OrdersList '
        + 'WHERE OrdersList.OrderId = :OrderId AND OrdersList.OrderCount>0',
        ['OrderId'],
        [F.AsString]);
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

    with DM.adsQueryValue do begin
      if Active then
        Close;
      SQL.Text:='SELECT * FROM PricesRegionalData where PriceCode = :APriceCode and RegionCode = :ARegionCode';
      ParamByName('APriceCode').Value:=adsOrdersHFormPRICECODE.Value;
      ParamByName('ARegionCode').Value:=adsOrdersHFormREGIONCODE.Value;
      Open;
      try
        { ��������� ������� �����-����� }
        if IsEmpty then
          raise Exception.Create( '������ �����-���� �� ������');
      finally
        Close;
      end;
      Application.ProcessMessages;
    end;

    Screen.Cursor:=crHourglass;
    try
      { ��������� ����������� ����� }
      OrdersForm.SetParams( adsOrdersHFormORDERID.AsInteger);
      Application.ProcessMessages;
      { ������������ ������� � ������� �����-���� }
      while not OrdersForm.adsOrders.Eof do begin
        Order:=OrdersForm.adsOrdersORDERCOUNT.AsInteger;

        Code := OrdersForm.adsOrdersCode.AsVariant;
        RequestRatio := OrdersForm.adsOrdersORDERSREQUESTRATIO.AsVariant;
        OrderCost := OrdersForm.adsOrdersORDERSORDERCOST.AsVariant;
        MinOrderCount := OrdersForm.adsOrdersORDERSMINORDERCOUNT.AsVariant;

        SynonymCode:=OrdersForm.adsOrdersSynonymCode.AsInteger;
        SynonymFirmCrCode:=OrdersForm.adsOrdersSynonymFirmCrCode.AsVariant;

        with adsCore do begin
          ParamByName( 'ClientId').Value:=DM.adtClients.FieldByName('ClientId').Value;
          ParamByName( 'APriceCode').Value:=adsOrdersHFormPRICECODE.Value;
          ParamByName( 'ARegionCode').Value:=adsOrdersHFormREGIONCODE.Value;
          ParamByName( 'SynonymCode').Value:=SynonymCode;
          ParamByName( 'SynonymFirmCrCode').Value:=SynonymFirmCrCode;
          Open;
          FetchAll;
          RecCountSRV := adsCore.RecordCount;
          try
            { �������� ���������� ����� �� ������ Code, SynonymCode � SynonymFirmCrCode }
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

            { ���� ��� ��� �� ����������, �� ����� ��������� }
            if Order > 0 then
            begin
              if ( OrdersForm.adsOrdersORDERCOUNT.AsInteger - Order) > 0 then
              begin
                Strings.Append( Format( '%s : %s - %s : %d ������ %d',
                  [adsOrdersHFormPRICENAME.AsString,
                  OrdersForm.adsOrdersSYNONYMNAME.AsString,
                  OrdersForm.adsOrdersSYNONYMFIRM.AsString,
                  OrdersForm.adsOrdersORDERCOUNT.AsInteger - Order,
                  OrdersForm.adsOrdersORDERCOUNT.AsInteger]));
              end
              else
                Strings.Append( Format( '%s : %s - %s : ����������� �� �������',
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

  MainForm.SetOrdersInfo;

  dbgSendedOrders.SelectedRows.Clear;
end;

procedure TOrdersHForm.ShowForm;
begin
  inherited;
  if Assigned(PrevForm) and (PrevForm is TOrdersForm) then begin
    //���� �� ���������� ������� �� ���� "�������� �����", �� ���� �������� �����
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

end.
