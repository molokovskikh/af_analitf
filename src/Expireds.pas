unit Expireds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, RXDBCtrl, DModule, DB, AProc,
  Placemnt, StdCtrls, ExtCtrls, DBGridEh, ToughDBGrid, Registry, OleCtrls,
  SHDocVw, FIBDataSet, pFIBDataSet, FIBSQLMonitor, DBProc, FIBQuery, Constant;

const
	ExpiredSql	= 'SELECT * FROM EXPIREDSSHOW(:TIMEZONEBIAS, :ACLIENTID) ORDER BY ';

type
  TExpiredsForm = class(TChildForm)
    dsExpireds: TDataSource;
    plOverCost: TPanel;
    Timer: TTimer;
    pClient: TPanel;
    dbgExpireds: TToughDBGrid;
    adsExpireds: TpFIBDataSet;
    adsExpiredsSumOrder: TCurrencyField;
    adsOrdersH: TpFIBDataSet;
    adsOrdersShowFormSummary: TpFIBDataSet;
    adsExpiredsPriceRet: TCurrencyField;
    adsExpiredsCryptBASECOST: TCurrencyField;
    adsExpiredsCOREID: TFIBBCDField;
    adsExpiredsPRICECODE: TFIBBCDField;
    adsExpiredsREGIONCODE: TFIBBCDField;
    adsExpiredsFULLCODE: TFIBBCDField;
    adsExpiredsCODEFIRMCR: TFIBBCDField;
    adsExpiredsSYNONYMCODE: TFIBBCDField;
    adsExpiredsSYNONYMFIRMCRCODE: TFIBBCDField;
    adsExpiredsCODE: TFIBStringField;
    adsExpiredsCODECR: TFIBStringField;
    adsExpiredsNOTE: TFIBStringField;
    adsExpiredsPERIOD: TFIBStringField;
    adsExpiredsVOLUME: TFIBStringField;
    adsExpiredsQUANTITY: TFIBStringField;
    adsExpiredsSYNONYMNAME: TFIBStringField;
    adsExpiredsSYNONYMFIRM: TFIBStringField;
    adsExpiredsAWAIT: TFIBIntegerField;
    adsExpiredsPRICENAME: TFIBStringField;
    adsExpiredsDATEPRICE: TFIBDateTimeField;
    adsExpiredsREGIONNAME: TFIBStringField;
    adsExpiredsORDERSCOREID: TFIBBCDField;
    adsExpiredsORDERSORDERID: TFIBBCDField;
    adsExpiredsORDERSCLIENTID: TFIBBCDField;
    adsExpiredsORDERSFULLCODE: TFIBBCDField;
    adsExpiredsORDERSCODEFIRMCR: TFIBBCDField;
    adsExpiredsORDERSSYNONYMCODE: TFIBBCDField;
    adsExpiredsORDERSSYNONYMFIRMCRCODE: TFIBBCDField;
    adsExpiredsORDERSCODE: TFIBStringField;
    adsExpiredsORDERSCODECR: TFIBStringField;
    adsExpiredsORDERSSYNONYM: TFIBStringField;
    adsExpiredsORDERSSYNONYMFIRM: TFIBStringField;
    adsExpiredsORDERCOUNT: TFIBIntegerField;
    adsExpiredsORDERSJUNK: TFIBIntegerField;
    adsExpiredsORDERSAWAIT: TFIBIntegerField;
    adsExpiredsORDERSHORDERID: TFIBBCDField;
    adsExpiredsORDERSHCLIENTID: TFIBBCDField;
    adsExpiredsORDERSHPRICECODE: TFIBBCDField;
    adsExpiredsORDERSHREGIONCODE: TFIBBCDField;
    adsExpiredsORDERSHPRICENAME: TFIBStringField;
    adsExpiredsORDERSHREGIONNAME: TFIBStringField;
    pRecordCount: TPanel;
    lblRecordCount: TLabel;
    Bevel1: TBevel;
    pWebBrowser: TPanel;
    Bevel2: TBevel;
    WebBrowser1: TWebBrowser;
    adsOrdersShowFormSummaryORDERPRICEAVG: TFIBBCDField;
    adsExpiredsBASECOST: TFIBStringField;
    adsExpiredsORDERSPRICE: TFIBStringField;
    adsExpiredsDOC: TFIBStringField;
    adsExpiredsREGISTRYCOST: TFIBFloatField;
    adsExpiredsVITALLYIMPORTANT: TFIBIntegerField;
    adsExpiredsREQUESTRATIO: TFIBIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure adsExpireds2BeforePost(DataSet: TDataSet);
    procedure dbgExpiredsCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure adsExpireds2AfterPost(DataSet: TDataSet);
    procedure adsExpireds2AfterScroll(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
    procedure dbgExpiredsSortMarkingChanged(Sender: TObject);
    procedure dbgExpiredsGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure adsExpiredsBeforeEdit(DataSet: TDataSet);
  private
    ClientId: Integer;
    UseExcess: Boolean;
    Excess: Integer;

    procedure RefreshOrdersH;
    procedure ecf(DataSet: TDataSet);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Main;

procedure TExpiredsForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
  adsExpireds.OnCalcFields := ecf;
	ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
  UseExcess := True;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
	adsOrdersShowFormSummary.ParamByName('AClientId').Value := ClientId;
	adsExpireds.ParamByName( 'AClientId').Value := ClientId;
	adsExpireds.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	Screen.Cursor := crHourGlass;
	try
		adsExpireds.Open;
	finally
		Screen.Cursor := crDefault;
	end;
	lblRecordCount.Caption := Format( lblRecordCount.Caption, [adsExpireds.RecordCountFromSrv]);
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' +
		Self.ClassName, False) then dbgExpireds.LoadFromRegistry( Reg);
  if dbgExpireds.SortMarkedColumns.Count = 0 then
    dbgExpireds.Columns[0].Title.SortMarker := smUpEh;
	Reg.Free;
	ShowForm;
  adsExpireds.First;
end;

procedure TExpiredsForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\'
		+ Self.ClassName, True);
	dbgExpireds.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TExpiredsForm.ecf(DataSet: TDataSet);
var
  S : String;
  C : Currency;
begin
  try
    S := DM.D_B_N(adsExpiredsBASECOST.AsString);
    C := StrToCurr(S);
    adsExpiredsCryptBASECOST.AsCurrency := C;
    adsExpiredsPriceRet.AsCurrency := DM.GetPriceRet(C);
	  //вычисляем сумму заказа
  	adsExpiredsSumOrder.AsCurrency:= C * adsExpiredsORDERCOUNT.AsInteger;
  except
  end;
end;

procedure TExpiredsForm.adsExpireds2BeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
	PriceAvg: Double;
begin
	try
		{ проверяем заказ на соответствие наличию товара на складе }
		Val( adsExpiredsQuantity.AsString, Quantity, E);
		if E <> 0 then Quantity := 0;
		if ( Quantity > 0) and ( adsExpiredsORDERCOUNT.AsInteger > Quantity)and
			(MessageBox('Заказ превышает остаток на складе. Продолжить?',
			MB_ICONQUESTION or MB_OKCANCEL) <> IDOK) then adsExpiredsORDERCOUNT.AsInteger := Quantity;

		{ проверяем на превышение цены }
		if UseExcess and ( adsExpiredsORDERCOUNT.AsInteger > 0) then
		begin
			PriceAvg := adsOrdersShowFormSummaryORDERPRICEAVG.AsCurrency;
			if ( PriceAvg > 0) and ( adsExpiredsCryptBASECOST.AsCurrency>PriceAvg*(1+Excess/100)) then
			begin
				plOverCost.Top := ( dbgExpireds.Height - plOverCost.Height) div 2;
				plOverCost.Left := ( dbgExpireds.Width - plOverCost.Width) div 2;
				plOverCost.BringToFront;
				plOverCost.Show;
				Timer.Enabled := True;
			end;
		end;
  except
		adsExpireds.Cancel;
		raise;
	end;
end;

//переоткрывает заголовок для текущего заказа
//нужна для поиска текущего OrdersH.OrderId при вводе заказа
procedure TExpiredsForm.RefreshOrdersH;
begin
	adsOrdersH.ParamByName( 'AClientId').Value := ClientId;
	adsOrdersH.ParamByName( 'APriceCode').Value := adsExpiredsPriceCode.AsInteger;
	adsOrdersH.ParamByName( 'ARegionCode').Value := adsExpiredsRegionCode.AsInteger;
	if adsOrdersH.Active then adsOrdersH.CloseOpen(True) else adsOrdersH.Open;
end;

procedure TExpiredsForm.dbgExpiredsCanInput(Sender: TObject;
  Value: Integer; var CanInput: Boolean);
begin
	CanInput := ( adsExpiredsRegionCode.AsInteger and DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
		adsExpiredsRegionCode.AsInteger;
	if not CanInput then exit;

	//создаем записи из Orders и OrdersH, если их нет
{
  if adsExpiredsOrdersOrderId.IsNull then begin //нет соответствующей записи в Orders
    RefreshOrdersH;
    if adsOrdersH.IsEmpty then begin //нет заголовка заказа из OrdersH
      //добавляем запись в OrdersH
      adsExpireds.Edit;
      adsExpiredsOrdersHClientId.AsInteger:=ClientId;
      adsExpiredsOrdersHPriceCode.AsInteger:=adsExpiredsPriceCode.AsInteger;
      adsExpiredsOrdersHRegionCode.AsInteger:=adsExpiredsRegionCode.AsInteger;
      adsExpiredsOrdersHPriceName.AsString:=adsExpiredsPriceName.AsString;
      adsExpiredsOrdersHRegionName.AsString:=adsExpiredsRegionName.AsString;
      adsExpireds.Post; //на этот момент уже имеем OrdersHOrderId (автоинкремент)
    end;
    //добавляем запись в Orders
    adsExpireds.Edit;
    if adsOrdersH.IsEmpty then
      adsExpiredsOrdersOrderId.AsInteger:=adsExpiredsOrdersHOrderId.AsInteger
    else
      adsExpiredsOrdersOrderId.AsInteger:=adsOrdersH.FieldByName('OrderId').AsInteger;
    adsExpiredsOrdersClientId.AsInteger := ClientId;
    adsExpiredsOrdersFullCode.AsInteger:=adsExpiredsFullCode.AsInteger;
    adsExpiredsOrdersCodeFirmCr.AsInteger := adsExpiredsCodeFirmCr.AsInteger;
    adsExpiredsOrdersCoreId.AsInteger:=adsExpiredsCoreId.AsInteger;
    adsExpiredsOrdersSynonymCode.AsInteger:=adsExpiredsSynonymCode.AsInteger;
    adsExpiredsOrdersSynonymFirmCrCode.AsInteger:=adsExpiredsSynonymFirmCrCode.AsInteger;
    adsExpiredsOrdersCode.AsString:=adsExpiredsCode.AsString;
    adsExpiredsOrdersCodeCr.AsString := adsExpiredsCodeCr.AsString;
    adsExpiredsOrdersPrice.AsCurrency:=adsExpiredsBaseCost.AsCurrency;
    adsExpiredsOrdersJunk.AsBoolean:=True;
    adsExpiredsOrdersAwait.AsBoolean := adsExpiredsAwait.AsBoolean;
    adsExpiredsOrdersSynonym.AsString := adsExpiredsSYNONYMNAME.AsString;
    adsExpiredsOrdersSynonymFirm.AsString := adsExpiredsSynonymFirm.AsString;
    adsExpireds.Post;
    if adsOrdersH.IsEmpty then RefreshOrdersH;
  end;
  }
end;

procedure TExpiredsForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

procedure TExpiredsForm.adsExpireds2AfterPost(DataSet: TDataSet);
begin
  DM.SetNewOrderCount(adsExpiredsORDERCOUNT.AsInteger, adsExpiredsCryptBASECOST.AsCurrency);
	MainForm.SetOrdersInfo;
end;

procedure TExpiredsForm.adsExpireds2AfterScroll(DataSet: TDataSet);
//var
//  C : Integer;
begin
{
  C := dbgExpireds.Canvas.TextHeight('Wg') + 2;
  if (adsExpireds.RecordCount > 0) and ((adsExpireds.RecordCount*C)/(pClient.Height-pWebBrowser.Height) > 13/10) then
    pWebBrowser.Visible := False
  else
    pWebBrowser.Visible := True;
}
end;

procedure TExpiredsForm.FormResize(Sender: TObject);
begin
  adsExpireds2AfterScroll(adsExpireds);
end;

procedure TExpiredsForm.dbgExpiredsSortMarkingChanged(Sender: TObject);
begin
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TExpiredsForm.dbgExpiredsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if adsExpiredsVITALLYIMPORTANT.AsBoolean then
    AFont.Color := VITALLYIMPORTANT_CLR;

	//уцененный товар
	if (( Column.Field = adsExpiredsPERIOD) or ( Column.Field = adsExpiredsCryptBASECOST))
  then Background := JUNK_CLR;
end;

procedure TExpiredsForm.adsExpiredsBeforeEdit(DataSet: TDataSet);
begin
  DM.SetOldOrderCount(adsExpiredsORDERCOUNT.AsInteger);
end;

end.
