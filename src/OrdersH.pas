unit OrdersH;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, DB, ADODB, RXDBCtrl, Buttons, ADOInt,
  StdCtrls, Math, ComCtrls, DBCtrls, ExtCtrls, DBGridEh, ToughDBGrid, Registry, DateUtils,
  FR_DSet, FR_DBSet, OleCtrls, SHDocVw;

const
	OrdersHSql =	'SELECT * FROM OrdersHShow WHERE OrderDate BETWEEN DateFrom AND ' +
				' DateTo ORDER BY ';

type
  TOrdersHForm = class(TChildForm)
    adsOrdersH: TADODataSet;
    dsOrdersH: TDataSource;
    adsOrdersHOrderDate: TDateTimeField;
    adsOrdersHClosed: TBooleanField;
    adsOrdersHPositions: TIntegerField;
    adsOrdersHSumOrder: TBCDField;
    adsOrdersHOrderId: TAutoIncField;
    adsOrdersHPriceName: TWideStringField;
    adsOrdersHRegionName: TWideStringField;
    TabControl: TTabControl;
    btnDelete: TButton;
    btnMoveSend: TButton;
    adsOrdersHSend: TBooleanField;
    adsOrdersHPriceCode: TIntegerField;
    adsOrdersHRegionCode: TIntegerField;
    pBottom: TPanel;
    adsOrdersHDatePrice: TDateTimeField;
    adsOrdersHSupportPhone: TWideStringField;
    adsCore: TADODataSet;
    adsCoreCoreId: TAutoIncField;
    adsCoreFullCode: TIntegerField;
    adsCoreShortCode: TIntegerField;
    adsCoreCodeFirmCr: TIntegerField;
    adsCoreSynonymCode: TIntegerField;
    adsCoreSynonymFirmCrCode: TIntegerField;
    adsCoreCode: TWideStringField;
    adsCoreCodeCr: TWideStringField;
    adsCoreVolume: TWideStringField;
    adsCoreDoc: TWideStringField;
    adsCoreNote: TWideStringField;
    adsCorePeriod: TWideStringField;
    adsCoreAwait: TBooleanField;
    adsCoreJunk: TBooleanField;
    adsCoreBaseCost: TBCDField;
    adsCoreQuantity: TWideStringField;
    adsCoreSynonym: TWideStringField;
    adsCoreSynonymFirm: TWideStringField;
    adsCoreMinPrice: TBCDField;
    adsCoreLeaderFirmCode: TIntegerField;
    adsCoreLeaderRegionCode: TIntegerField;
    adsCoreLeaderRegionName: TWideStringField;
    adsCoreOrdersCoreId: TIntegerField;
    adsCoreOrdersOrderId: TIntegerField;
    adsCoreOrdersClientId: TSmallintField;
    adsCoreOrdersFullCode: TIntegerField;
    adsCoreOrdersCodeFirmCr: TIntegerField;
    adsCoreOrdersSynonymCode: TIntegerField;
    adsCoreOrdersSynonymFirmCrCode: TIntegerField;
    adsCoreOrdersCode: TWideStringField;
    adsCoreOrdersCodeCr: TWideStringField;
    adsCoreOrder: TIntegerField;
    adsCoreOrdersSynonym: TWideStringField;
    adsCoreOrdersSynonymFirm: TWideStringField;
    adsCoreOrdersPrice: TBCDField;
    adsCoreOrdersJunk: TBooleanField;
    adsCoreOrdersAwait: TBooleanField;
    adsCoreOrdersHOrderId: TAutoIncField;
    adsCoreOrdersHClientId: TSmallintField;
    adsCoreOrdersHPriceCode: TIntegerField;
    adsCoreOrdersHRegionCode: TIntegerField;
    adsCoreOrdersHPriceName: TWideStringField;
    adsCoreOrdersHRegionName: TWideStringField;
    adsCorePriceRet: TFloatField;
    adsCoreSumOrder: TBCDField;
    adsOrdersHSendDate: TDateTimeField;
    adsCoreLeaderPriceName: TWideStringField;
    pTop: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    Bevel1: TBevel;
    pTabSheet: TPanel;
    adsOrdersHMessage: TWideStringField;
    adsOrdersHComments: TWideStringField;
    adsWayBillHead: TADODataSet;
    dsWayBillHead: TDataSource;
    adsWayBillHeadServerID: TIntegerField;
    adsWayBillHeadServerOrderID: TIntegerField;
    adsWayBillHeadWriteTime: TDateTimeField;
    adsWayBillHeadClientID: TIntegerField;
    adsWayBillHeadPriceCode: TIntegerField;
    adsWayBillHeadRegionCode: TIntegerField;
    adsWayBillHeadPriceName: TWideStringField;
    adsWayBillHeadRegionName: TWideStringField;
    adsWayBillHeadFirmComment: TWideStringField;
    adsWayBillHeadRowCount: TSmallintField;
    btnWayBillList: TButton;
    adsOrdersHServerOrderId: TIntegerField;
    pClient: TPanel;
    pGrid: TPanel;
    ToughDBGrid1: TToughDBGrid;
    dbgOrdersH: TToughDBGrid;
    pRight: TPanel;
    gbMessage: TGroupBox;
    dbmMessage: TDBMemo;
    gbComments: TGroupBox;
    dbmComments: TDBMemo;
    pWebBrowser: TPanel;
    Bevel2: TBevel;
    WebBrowser1: TWebBrowser;
    tmOrderDateChange: TTimer;
    procedure adsOrdersHBeforeDelete(DataSet: TDataSet);
    procedure btnMoveSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dbgOrdersHKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgOrdersHExit(Sender: TObject);
    procedure dbgOrdersHSortChange(Sender: TObject; SQLOrderBy: String);
    procedure dbgOrdersHDblClick(Sender: TObject);
    procedure adsOrdersHAfterPost(DataSet: TDataSet);
    procedure dbgOrdersHKeyPress(Sender: TObject; var Key: Char);
    procedure dbgOrdersHGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dtpDateCloseUp(Sender: TObject);
    procedure btnWayBillListClick(Sender: TObject);
    procedure adsOrdersHSendChange(Sender: TField);
    procedure tmOrderDateChangeTimer(Sender: TObject);
    procedure adsOrdersHBeforePost(DataSet: TDataSet);
  private
    procedure SetParameters;
    procedure MoveToPrice;
    procedure SendOrders;
    procedure SetDateInterval;
  public
	procedure Print( APreview: boolean = False); override;
  end;

var
  OrdersHForm: TOrdersHForm;

procedure ShowOrdersH;

implementation

uses DModule, Main, AProc, Orders, NotFound, DBProc, Core, WayBillList;

{$R *.dfm}

procedure ShowOrdersH;
begin
	OrdersHForm := TOrdersHForm( MainForm.ShowChildForm( TOrdersHForm));
end;

procedure TOrdersHForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
	Year, Month, Day: Word;
begin
	inherited;
	PrintEnabled := True;
	OrdersForm := TOrdersForm.Create( Application);
  WayBillListForm := TWayBillListForm.Create(Application);
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, False) then dbgOrdersH.LoadFromRegistry( Reg);
	Reg.Free;

	adsOrdersH.CommandText := OrdersHSql + 'SendDate DESC';
	Year := YearOf( Date);
	Month := MonthOf( Date);
	Day := DayOf( Date);
	IncAMonth( Year, Month, Day, -3);
	dtpDateFrom.Date := StartOfTheMonth( EncodeDate( Year, Month, Day));
	dtpDateTo.Date := Date;

	TabControl.TabIndex := 0;
	Screen.Cursor := crHourglass;
	try
		adsOrdersH.Parameters.ParamByName('AClientId').Value:=
			DM.adtClients.FieldByName('ClientId').Value;
		adsOrdersH.Parameters.ParamByName( 'DateFrom').DataType := ftDate;
		adsOrdersH.Parameters.ParamByName( 'DateTo').DataType := ftDate;
                adsOrdersH.Parameters.ParamByName('DateFrom').Value:=dtpDateFrom.Date;
		dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
		adsOrdersH.Parameters.ParamByName('DateTo').Value:=dtpDateTo.Date;
		adsOrdersH.Parameters.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
		SetParameters;
	finally
		Screen.Cursor := crDefault;
	end;

	ShowForm;
end;

procedure TOrdersHForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	SoftPost(adsOrdersH);
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, True);
	dbgOrdersH.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TOrdersHForm.SetParameters;
begin
	SoftPost( adsOrdersH);
	case TabControl.TabIndex of
		0: begin
			adsOrdersH.Close;
			adsOrdersH.CommandText := StringReplace( adsOrdersH.CommandText,
				' OrdersHShow1 ', ' OrdersHShow ', []);
			adsOrdersH.Parameters.ParamByName( 'AClosed').Value := False;
			btnMoveSend.Caption := 'Перевести в отправленные';
      btnMoveSend.Visible := False;
      btnWayBillList.Visible := False;
			PrintEnabled := True;
		end;
		1: begin
			adsOrdersH.Close;
			adsOrdersH.CommandText := StringReplace( adsOrdersH.CommandText,
				' OrdersHShow ', ' OrdersHShow1 ', []);
			adsOrdersH.Parameters.ParamByName( 'AClosed').Value := True;
			btnMoveSend.Caption := 'Вернуть в текущие';
      btnMoveSend.Visible := True;
      btnWayBillList.Visible := True;
			PrintEnabled := False;
		end;
	end;

	adsOrdersH.Parameters.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').Value;
	adsOrdersH.Parameters.ParamByName( 'DateFrom').DataType := ftDate;
	adsOrdersH.Parameters.ParamByName( 'DateTo').DataType := ftDate;
	adsOrdersH.Parameters.ParamByName( 'DateFrom').Value := dtpDateFrom.Date;
	dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
	adsOrdersH.Parameters.ParamByName( 'DateTo').Value := dtpDateTo.Date;
	adsOrdersH.Parameters.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;

	if adsOrdersH.Active then adsOrdersH.Requery else adsOrdersH.Open;
	//свойства надо переназначать и после Resync
	adsOrdersH.Properties[ 'Update Criteria'].Value := adCriteriaKey;
	adsOrdersH.Properties[ 'Unique Table'].Value := 'OrdersH';
	ColumnByNameT( dbgOrdersH, 'Send').Visible := TabControl.TabIndex = 0;
	ColumnByNameT( dbgOrdersH, 'SendDate').Visible := TabControl.TabIndex = 1;
	dbmMessage.ReadOnly := TabControl.TabIndex = 1;
	if adsOrdersH.RecordCount = 0 then dbgOrdersH.ReadOnly := True
		else dbgOrdersH.ReadOnly := False;
end;

procedure TOrdersHForm.TabControlChange(Sender: TObject);
begin
	SetParameters;
end;

procedure TOrdersHForm.btnDeleteClick(Sender: TObject);
begin
	dbgOrdersH.SetFocus;
	if not adsOrdersH.IsEmpty then
	begin
    if (dbgOrdersH.SelectedRows.Count = 0) and (not dbgOrdersH.SelectedRows.CurrentRowSelected) then
      dbgOrdersH.SelectedRows.CurrentRowSelected := True;
    if dbgOrdersH.SelectedRows.Count > 0 then
      if MessageBox( 'Удалить выбранные заявки?', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then begin
        dbgOrdersH.SelectedRows.Delete;
        MainForm.SetOrdersInfo;
      end;
	end;
	if adsOrdersH.RecordCount = 0 then dbgOrdersH.ReadOnly := True
		else dbgOrdersH.ReadOnly := False;
end;

procedure TOrdersHForm.adsOrdersHBeforeDelete(DataSet: TDataSet);
begin
//	if MessageBox( 'Удалить заявку?', MB_ICONQUESTION or MB_OKCANCEL) <> IDOK then abort;
end;

procedure TOrdersHForm.btnMoveSendClick(Sender: TObject);
begin
	dbgOrdersH.SetFocus;
	case TabControl.TabIndex of
		0: SendOrders;
		1: MoveToPrice;
	end;
	MainForm.SetOrdersInfo;
end;

procedure TOrdersHForm.MoveToPrice;
var
	Order, CurOrder, SynonymCode, Quantity, E, OrderId: Integer;
	Code, CodeCr, SynonymFirmCrCode: Variant;
  I : Integer;
	Strings: TStrings;

  procedure SetOrder( Order: Integer);
  begin
    //создаем записи из Orders и OrdersH, если их нет
    with adsCore do begin
      if FieldByName('OrdersOrderId').IsNull then begin //нет соответствующей записи в Orders
        if OrderId = 0 then begin //нет заголовка заказа из OrdersH
          //добавляем запись в OrdersH
          Edit;
          FieldByName('OrdersHClientId').AsInteger:=DM.adtClients.FieldByName('ClientId').AsInteger;
          FieldByName('OrdersHPriceCode').AsInteger:=adsOrdersHPriceCode.AsInteger;
          FieldByName('OrdersHRegionCode').AsInteger:=adsOrdersHRegionCode.AsInteger;
          FieldByName('OrdersHPriceName').AsString:=adsOrdersHPriceName.AsString;
          FieldByName('OrdersHRegionName').AsString:=adsOrdersHRegionName.AsString;
          Post; //на этот момент уже имеем OrdersHOrderId (автоинкремент)
          OrderId:=FieldByName('OrdersHOrderId').AsInteger;
        end;
        //добавляем запись в Orders
        Edit;
        FieldByName( 'OrdersOrderId').AsInteger:=OrderId;
        FieldByName( 'OrdersClientId').AsInteger:=DM.adtClients.FieldByName('ClientId').AsInteger;
        FieldByName( 'OrdersFullCode').AsInteger:=FieldByName('FullCode').AsInteger;
        FieldByName( 'OrdersCodeFirmCr').AsInteger:=FieldByName('CodeFirmCr').AsInteger;
        FieldByName( 'OrdersCoreId').AsInteger:=FieldByName('CoreId').AsInteger;
        FieldByName( 'OrdersSynonymCode').AsInteger:=FieldByName('SynonymCode').AsInteger;
        FieldByName( 'OrdersSynonymFirmCrCode').AsInteger:=FieldByName('SynonymFirmCrCode').AsInteger;
        FieldByName( 'OrdersCode').AsString:=FieldByName('Code').AsString;
        FieldByName( 'OrdersCodeCr').AsString:=FieldByName('CodeCr').AsString;
        FieldByName( 'OrdersSynonym').AsString := FieldByName( 'Synonym').AsString;
        FieldByName( 'OrdersSynonymFirm').AsString := FieldByName( 'SynonymFirm').AsString;
        FieldByName( 'OrdersAwait').AsBoolean := FieldByName( 'Await').AsBoolean;
        FieldByName( 'OrdersJunk').AsBoolean := FieldByName( 'Junk').AsBoolean;
        FieldByName( 'OrdersPrice').AsCurrency:=FieldByName('BaseCost').AsCurrency;
        Post;
      end;
      Edit;
      FieldByName( 'Order').AsInteger := Order;
      Post;
    end;
  end;

begin
  if adsOrdersH.IsEmpty or ( TabControl.TabIndex<>1) then Exit;

  if MessageBox( 'Вернуть выбранные заявки в работу?',MB_ICONQUESTION+MB_OKCANCEL)<>IDOK then exit;

  if (dbgOrdersH.SelectedRows.Count = 0) and (not dbgOrdersH.SelectedRows.CurrentRowSelected) then
    dbgOrdersH.SelectedRows.CurrentRowSelected := True;

  if dbgOrdersH.SelectedRows.Count > 0 then begin
    Strings:=TStringList.Create;
    try
      for I := dbgOrdersH.SelectedRows.Count-1 downto 0 do
      begin
        adsOrdersH.GotoBookmark(Pointer(dbgOrdersH.SelectedRows.Items[i]));

        //находим OrderId
        OrderId:=0;
        with DM.adsSelect do begin
          CommandText:='SELECT OrderId FROM OrdersHShowCurrent';
          Parameters.ParamByName('AClientId').Value:=DM.adtClients.FieldByName('ClientId').Value;
          Parameters.ParamByName('APriceCode').Value:=adsOrdersHPriceCode.Value;
          Parameters.ParamByName('ARegionCode').Value:=adsOrdersHRegionCode.Value;
          Open;
          try
            if not IsEmpty then OrderId:=Fields[0].AsInteger;
          finally
            Close;
          end;
        end;

        with adsCore do begin
          Parameters.ParamByName( 'RetailForcount').Value:=DM.adtClients.FieldByName( 'Forcount').Value;
          Parameters.ParamByName( 'AClientId').Value:=DM.adtClients.FieldByName('ClientId').Value;
          Parameters.ParamByName( 'APriceCode').Value:=adsOrdersHPriceCode.Value;
          Parameters.ParamByName( 'ARegionCode').Value:=adsOrdersHRegionCode.Value;
          Screen.Cursor:=crHourglass;
          try
            Open;
            { проверяем наличие прайс-листа }
            if IsEmpty then raise Exception.Create( 'Данный прайс-лист не найден');
            { открываем сохраненный заказ }
            OrdersForm.SetParams( adsOrdersHOrderId.AsInteger);
            { переписываем позиции в текущий прайс-лист }
            while not OrdersForm.adsOrders.Eof do begin
              Order:=OrdersForm.adsOrdersOrder.AsInteger;
              Code := OrdersForm.adsOrdersCode.AsVariant;
              if Code = '' then Code := Null;
              CodeCr := OrdersForm.adsOrdersCodeCr.AsVariant;
              if CodeCr = '' then CodeCr := Null;
              SynonymCode:=OrdersForm.adsOrdersSynonymCode.AsInteger;
              SynonymFirmCrCode:=OrdersForm.adsOrdersSynonymFirmCrCode.AsInteger;
              //if SynonymFirmCrCode = 0 then SynonymFirmCrCode := Null;

              { пытаемся разбросать заказ по нужным Code, CodeCr, SynonymCode и SynonymFirmCrCode }
              if Locate( 'Code;CodeCr;SynonymCode;SynonymFirmCrCode',
                  VarArrayOf([ Code, CodeCr, SynonymCode, SynonymFirmCrCode]), [])
              then
              begin
                repeat
                  Val(FieldByName( 'Quantity').AsString,Quantity,E);
                  if E <> 0 then Quantity := 0;
                  if Quantity > 0 then
                    CurOrder := Min( Order, Quantity - FieldByName('Order').AsInteger)
                  else
                    CurOrder := Order;
                  if CurOrder < 0 then CurOrder := 0;
                  Order := Order - CurOrder;
                  if CurOrder > 0 then SetOrder( FieldByName( 'Order').AsInteger + CurOrder);
                  Next;
                until ( Order = 0) or Eof or ( FieldByName( 'Code').AsString <> Code) or
                      ( FieldByName( 'CodeCr').AsString <> CodeCr) or
                      ( FieldByName( 'SynonymCode').AsInteger <> SynonymCode) or
                      ( FieldByName( 'SynonymFirmCrCode').AsInteger <> SynonymFirmCrCode);
              end;

              { если все еще не разбросали, то пишем сообщение }
              if Order > 0 then
              begin
                if ( OrdersForm.adsOrdersOrder.AsInteger - Order) > 0 then
                begin
                  Strings.Append( Format( '%s : %s - %s : %d вместо %d',
                    [adsOrdersHPriceName.AsString,
                    OrdersForm.adsOrdersSynonym.AsString,
                    OrdersForm.adsOrdersSynonymFirm.AsString,
                    OrdersForm.adsOrdersOrder.AsInteger - Order,
                    OrdersForm.adsOrdersOrder.AsInteger]));
                end
                else
                  Strings.Append( Format( '%s : %s - %s : предложение не найдено',
                    [adsOrdersHPriceName.AsString,
                    OrdersForm.adsOrdersSynonym.AsString,
                    OrdersForm.adsOrdersSynonymFirm.AsString]));
              end;
              OrdersForm.adsOrders.Next;
            end;
          finally
            Close;
            Screen.Cursor:=crDefault;
          end;
        end;
      end;

      dbgOrdersH.SelectedRows.Clear;

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
	if adsOrdersH.IsEmpty or ( TabControl.TabIndex<>0) then Exit;

  if (dbgOrdersH.SelectedRows.Count = 0) and (not dbgOrdersH.SelectedRows.CurrentRowSelected) then
    dbgOrdersH.SelectedRows.CurrentRowSelected := True;
    
  if dbgOrdersH.SelectedRows.Count > 0 then begin
    for I := dbgOrdersH.SelectedRows.Count-1 downto 0 do
    begin
      adsOrdersH.GotoBookmark(Pointer(dbgOrdersH.SelectedRows.Items[i]));
      if adsOrdersH.FieldByName( 'Send').AsBoolean then
      begin
        adsOrdersHSend.OnChange := nil;
        try
          adsOrdersH.Edit;
          adsOrdersH.FieldByName( 'Send').AsBoolean := False;
          adsOrdersH.FieldByName( 'Closed').AsBoolean := True;
          DM.adcUpdate.CommandText := 'UPDATE Orders SET CoreId=NULL WHERE OrderId=' +
            adsOrdersH.FieldByName( 'OrderId').AsString;
          DM.adcUpdate.Execute;
          adsOrdersH.Post;
        finally
          adsOrdersHSend.OnChange := adsOrdersHSendChange;
        end;
      end;
    end;
    SetParameters;
  end;
end;

procedure TOrdersHForm.dbgOrdersHKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if Key = VK_RETURN then
	begin
		SoftPost( adsOrdersH);
		if not adsOrdersH.Isempty then OrdersForm.ShowForm( adsOrdersHOrderId.AsInteger);
	end;
	if ( Key = VK_ESCAPE) and ( Self.PrevForm <> nil) and
		( Self.PrevForm is TCoreForm) then
	begin
		Self.PrevForm.Show;
		MainForm.ActiveChild := Self.PrevForm;
		MainForm.ActiveControl := Self.PrevForm.ActiveControl;
	end;
	if ( Key = VK_DELETE) and not ( adsOrdersH.IsEmpty) then
	begin
//		adsOrdersH.Delete;
    btnDeleteClick(nil);
		MainForm.SetOrdersInfo;
	end;
end;

procedure TOrdersHForm.dbgOrdersHExit(Sender: TObject);
begin
	SoftPost( adsOrdersH);
end;

procedure TOrdersHForm.dbgOrdersHSortChange(Sender: TObject;
  SQLOrderBy: String);
begin
	adsOrdersH.Close;
	adsOrdersH.CommandText := OrdersHSql + SqlOrderBy;
	SetParameters;
end;

procedure TOrdersHForm.dbgOrdersHDblClick(Sender: TObject);
begin
	SoftPost( adsOrdersH);
	if not adsOrdersH.Isempty then OrdersForm.ShowForm( adsOrdersHOrderId.AsInteger);
end;

procedure TOrdersHForm.adsOrdersHAfterPost(DataSet: TDataSet);
begin
	MainForm.SetOrdersInfo;
end;

procedure TOrdersHForm.dbgOrdersHKeyPress(Sender: TObject; var Key: Char);
begin
	if ( TabControl.TabIndex = 0) and ( Ord( Key) > 32) and
		not adsOrdersH.IsEmpty then
	begin
		dbmMessage.SetFocus;
		SendMessage( GetFocus, WM_CHAR, Ord( Key), 0);
	end;
end;

procedure TOrdersHForm.dbgOrdersHGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if TabControl.TabIndex = 1 then
	begin
		if not Column.Field.DataSet.FieldByName( 'Send').AsBoolean then
			Background := clSilver;
	end;
end;

procedure TOrdersHForm.SetDateInterval;
begin
  with adsOrdersH do begin
	adsOrdersH.Parameters.ParamByName( 'DateFrom').DataType := ftDate;
	adsOrdersH.Parameters.ParamByName( 'DateTo').DataType := ftDate;
	Parameters.ParamByName('DateFrom').Value:=dtpDateFrom.Date;
	dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
	Parameters.ParamByName('DateTo').Value := dtpDateTo.Date;
    Screen.Cursor:=crHourglass;
    try
      if Active then Requery else Open;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure TOrdersHForm.dtpDateCloseUp(Sender: TObject);
begin
	SetDateInterval;
	dbgOrdersH.SetFocus;
end;

procedure TOrdersHForm.Print(APreview: boolean);
var
	Mark: TBookmarkStr;
begin
	if not adsOrdersH.Active or adsOrdersH.IsEmpty then exit;

	Mark := adsOrdersH.Bookmark;
	adsOrdersH.DisableControls;
	try
		adsOrdersH.First;
		OrdersForm.SetParams( adsOrdersHOrderId.AsInteger);

		if APreview then DM.ShowFastReport( 'Orders.frf', nil, APreview)
		else
		begin
			while not adsOrdersH.Eof do
			begin
				DM.ShowFastReport( 'Orders.frf', nil, APreview, False);
				adsOrdersH.Next;
				OrdersForm.SetParams( adsOrdersHOrderId.AsInteger);
			end;
		end;
	finally
		adsOrdersH.BookMark := Mark;
		adsOrdersH.EnableControls;
	end;
end;

procedure TOrdersHForm.btnWayBillListClick(Sender: TObject);
begin
	if not adsOrdersH.IsEmpty then
	begin
    adsWayBillHead.Parameters.ParamByName('[AServerOrderId]').Value := adsOrdersH.FieldByName('ServerOrderID').Value;
    if adsWayBillHead.Active then adsWayBillHead.Requery else adsWayBillHead.Open;
    if not adsWayBillHead.IsEmpty then begin
      WayBillListForm.ShowForm(adsWayBillHeadServerID.Value);
    end;
	end;
end;

procedure TOrdersHForm.adsOrdersHSendChange(Sender: TField);
begin
  //По-другому решить проблему не удалось. Запускаю таймер, чтобы он в главной нити
  //произвел сохранение dataset
  tmOrderDateChange.Enabled := True;
end;

procedure TOrdersHForm.tmOrderDateChangeTimer(Sender: TObject);
begin
  try
    SoftPost( adsOrdersH);
  finally
    tmOrderDateChange.Enabled := False;
  end;
end;

procedure TOrdersHForm.adsOrdersHBeforePost(DataSet: TDataSet);
begin
  //Здесь не нужный комментарий
  if adsOrdersHOrderId.IsNull then Abort; 
end;

end.
