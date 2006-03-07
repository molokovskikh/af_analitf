unit Core;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, DBGrids, ComCtrls, Db, StrUtils,
  StdCtrls, Buttons, DBCtrls, FR_Class, FR_DSet, FR_DBSet,
  Child, RXDBCtrl, Variants, Math, DBGridEh,
  ToughDBGrid, Registry, OleCtrls, SHDocVw, ActnList, FIBDataSet,
  pFIBDataSet, pFIBDatabase, pFIBQuery, FIBDatabase, FIBSQLMonitor;

const
	ALL_REGIONS	= '¬се регионы';

type
  TCoreForm = class(TChildForm)
    dsCore: TDataSource;
    gbPrevOrders: TGroupBox;
    lblPriceAvg: TLabel;
    frdsCore: TfrDBDataSet;
    dsOrders: TDataSource;
    dbtPriceAvg: TDBText;
    dsOrdersShowFormSummary: TDataSource;
    pBottom: TPanel;
    dbgHistory: TToughDBGrid;
    pTop: TPanel;
    lblName: TLabel;
    dsFirmsInfo: TDataSource;
    dbmContactInfo: TDBMemo;
    lblSupportPhone: TLabel;
    dbtSupportPhone: TDBText;
    gbFirmInfo: TGroupBox;
    plOverCost: TPanel;
    Timer: TTimer;
    cbFilter: TComboBox;
    cbEnabled: TComboBox;
    ActionList: TActionList;
    actFlipCore: TAction;
    pCenter: TPanel;
    pWebBrowser: TPanel;
    Bevel1: TBevel;
    WebBrowser1: TWebBrowser;
    dbgCore: TToughDBGrid;
    adsCore: TpFIBDataSet;
    adsCoreCOREID: TFIBBCDField;
    adsCorePRICECODE: TFIBBCDField;
    adsCoreREGIONCODE: TFIBBCDField;
    adsCoreFULLCODE: TFIBBCDField;
    adsCoreSHORTCODE: TFIBBCDField;
    adsCoreCODEFIRMCR: TFIBBCDField;
    adsCoreSYNONYMCODE: TFIBBCDField;
    adsCoreSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreCODE: TFIBStringField;
    adsCoreCODECR: TFIBStringField;
    adsCorePERIOD: TFIBStringField;
    adsCoreSALE: TFIBIntegerField;
    adsCoreVOLUME: TFIBStringField;
    adsCoreNOTE: TFIBStringField;
    adsCoreSYNONYMNAME: TFIBStringField;
    adsCoreSYNONYMFIRM: TFIBStringField;
    adsCoreDATEPRICE: TFIBDateTimeField;
    adsCorePRICENAME: TFIBStringField;
    adsCoreFIRMCODE: TFIBBCDField;
    adsCoreREGIONNAME: TFIBStringField;
    adsCoreORDERSCOREID: TFIBBCDField;
    adsCoreORDERSORDERID: TFIBBCDField;
    adsCoreORDERSCLIENTID: TFIBBCDField;
    adsCoreORDERSFULLCODE: TFIBBCDField;
    adsCoreORDERSCODEFIRMCR: TFIBBCDField;
    adsCoreORDERSSYNONYMCODE: TFIBBCDField;
    adsCoreORDERSSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreORDERSCODE: TFIBStringField;
    adsCoreORDERSCODECR: TFIBStringField;
    adsCoreORDERCOUNT: TFIBIntegerField;
    adsCoreORDERSSYNONYM: TFIBStringField;
    adsCoreORDERSSYNONYMFIRM: TFIBStringField;
    adsCoreORDERSHORDERID: TFIBBCDField;
    adsCoreORDERSHCLIENTID: TFIBBCDField;
    adsCoreORDERSHPRICECODE: TFIBBCDField;
    adsCoreORDERSHREGIONCODE: TFIBBCDField;
    adsCoreORDERSHPRICENAME: TFIBStringField;
    adsCoreORDERSHREGIONNAME: TFIBStringField;
    adsCoreSumOrder: TCurrencyField;
    adsCorePriceRet: TCurrencyField;
    adsCorePriceDelta: TFloatField;
    adsRegions: TpFIBDataSet;
    adsOrdersH: TpFIBDataSet;
    adsOrders: TpFIBDataSet;
    adsOrdersFULLCODE: TFIBBCDField;
    adsOrdersSYNONYMNAME: TFIBStringField;
    adsOrdersSYNONYMFIRM: TFIBStringField;
    adsOrdersORDERCOUNT: TFIBIntegerField;
    adsOrdersORDERDATE: TFIBDateTimeField;
    adsOrdersPRICENAME: TFIBStringField;
    adsOrdersREGIONNAME: TFIBStringField;
    adsOrdersAWAIT: TFIBIntegerField;
    adsOrdersJUNK: TFIBIntegerField;
    adsOrdersShowFormSummary: TpFIBDataSet;
    adsFirmsInfo: TpFIBDataSet;
    adsCoreSTORAGE: TFIBBooleanField;
    adsCoreAWAIT: TFIBBooleanField;
    adsCoreJUNK: TFIBBooleanField;
    adsCorePRICEENABLED: TFIBBooleanField;
    adsCoreORDERSJUNK: TFIBBooleanField;
    adsCoreORDERSAWAIT: TFIBBooleanField;
    adsCoreCryptSYNONYMNAME: TStringField;
    adsCoreCryptSYNONYMFIRM: TStringField;
    adsCoreCryptBASECOST: TCurrencyField;
    adsCoreBASECOST: TFIBStringField;
    adsCoreQUANTITY: TFIBStringField;
    adsCoreORDERSPRICE: TFIBStringField;
    adsOrdersShowFormSummaryPRICEAVG: TFIBBCDField;
    adsOrdersPRICE: TFIBStringField;
    procedure adsCore2CalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure adsCore2BeforePost(DataSet: TDataSet);
    procedure adsCore2AfterOpen(DataSet: TDataSet);
    procedure adsCore2BeforeClose(DataSet: TDataSet);
    procedure adsCore2BeforeEdit(DataSet: TDataSet);
    procedure adsCore2SynonymGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgCoreKeyPress(Sender: TObject; var Key: Char);
    procedure TimerTimer(Sender: TObject);
    procedure adsCore2AfterPost(DataSet: TDataSet);
    procedure cbFilterSelect(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure dbgHistoryGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure adsCore2AfterScroll(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
    procedure adsCoreSTORAGEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    RegionCodeStr: string;
    RecInfos: array of Double;
    UseExcess, CurrentUseForms: Boolean;
    DeltaMode, Excess, ClientId: Integer;
    RetailForcount: Double;

    procedure RefreshOrdersH;
  public
    procedure ShowForm( AParentCode: Integer; AName, AForm: string; UseForms: Boolean); reintroduce;
    procedure Print( APreview: boolean = False); override;
    procedure ShowOrdersH;
  end;

var
  CoreForm: TCoreForm;

implementation

uses Main, AProc, DModule, NamesForms, Constant, OrdersH, DBProc, CoreFirm,
  Prices;

{$R *.DFM}

procedure TCoreForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;
	PrintEnabled:=False;
	UseExcess := DM.adtClients.FieldByName( 'UseExcess').AsBoolean;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
        DeltaMode := DM.adtClients.FieldByName( 'DeltaMode').AsInteger;
	RetailForcount := 1 + DM.adtClients.FieldByName( 'Forcount').AsFloat / 100;
	RegionCodeStr := DM.adtClients.FieldByName( 'RegionCode').AsString;

	adsOrders.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').AsInteger;
	adsOrdersShowFormSummary.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').AsInteger;
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, False) then
		dbgCore.LoadFromRegistry( Reg);
	Reg.Free;
end;

procedure TCoreForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, True);
	dbgCore.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TCoreForm.ShowForm(AParentCode: Integer; AName, AForm: string; UseForms: Boolean);
var
	I: Integer;
	FirstPrice, PrevPrice, D: Currency;
	OrdersH: TOrdersHForm;
begin
	OrdersH := TOrdersHForm( FindChildControlByClass( MainForm, TOrdersHForm));
	if OrdersH <> nil then OrdersH.Free;
	SetLength( RecInfos, 0);

	adsOrders.DataSource := nil;
	adsOrdersShowFormSummary.DataSource := nil;
	ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
	{ готовим запрос в зависимости от того, показываем по наименованию или форме выпуска }
	with adsCore do
        begin
		if not Active or ( CurrentUseForms <> UseForms) then
		begin
			CurrentUseForms := UseForms;
			Close;
			if UseForms then SelectSQL.Text := 'SELECT * FROM CORESHOWBYFORM(:ACLIENTID, :TIMEZONEBIAS, :PARENTCODE, :SHOWREGISTER, :REGISTERID)'
				else SelectSQL.Text := 'SELECT * FROM CORESHOWBYNAME(:ACLIENTID, :TIMEZONEBIAS, :PARENTCODE, :SHOWREGISTER, :REGISTERID)';
			ParamByName( 'RegisterId').Value := RegisterId;
			ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
			ParamByName( 'AClientId').Value := ClientId;
		end;
		ParamByName( 'ParentCode').Value := AParentCode;
	end;
	{ открываем запрос }
	with adsCore do
	begin
		ParamByName( 'ShowRegister').Value :=
			DM.adtParams.FieldByName( 'ShowRegister').AsBoolean;
		Screen.Cursor := crHourglass;
		try
			if Active then CloseOpen(True) else Open;
      if not adsCore.Sorted then
        DoSort(['FullCode', 'CryptBaseCost'], [True, True]);
		finally
			Screen.Cursor := crDefault;
		end;
        end;

	{ проверка непустоты }
	if adsCore.RecordCount = 0 then
	begin
		MessageBox( 'Ќет предложений', MB_ICONWARNING);
		Abort;
	end;

	{ заполн€ем список регионов дл€ фильтрации }
	cbFilter.Clear;
	cbFilter.Items.Add( ALL_REGIONS);
	adsRegions.Open;
	try
		while not adsRegions.Eof do
		begin
			cbFilter.Items.Add( adsRegions.FieldByName( 'RegionName').AsString);
			adsRegions.Next;
		end;
	finally
		adsRegions.Close;
	end;
	cbFilter.ItemIndex := MainForm.RegionFilterIndex;
	cbEnabled.ItemIndex := MainForm.EnableFilterIndex;

	//готовим значени€ дл€ колонки "–азница"
	FirstPrice := 0;
	PrevPrice := 0;
        I := -1;
	RecInfos := nil;
	with adsCore do
	begin
		SetLength( RecInfos, adsCore.RecordCount);
		First;
		while not Eof do
		begin
			Inc(I);
			//переменные, необходимые дл€ расчета разницы в цене
			if adsCoreSynonymCode.AsInteger<0 then
			begin //попали на заголовок формы выпуска
				PrevPrice := 0;
				FirstPrice := 0;
			end;
			//разница в цене от другого поставщика PRICE_DELTA
			case DeltaMode of
				1, 2: D := FirstPrice;
			else
				D := PrevPrice;
			end;
			if ( D = 0) or ( adsCoreCryptBASECOST.AsCurrency = 0) then
				RecInfos[ I] := 0
			else
				RecInfos[ I] := RoundTo(( adsCoreCryptBASECOST.AsCurrency - D)/D*100,-1);
			if adsCoreSynonymCode.AsInteger >= 0 then
			begin
				if adsCoreCryptBASECOST.AsCurrency > 0 then PrevPrice := adsCoreCryptBASECOST.AsCurrency;
				if ( FirstPrice=0) and (( DeltaMode <> 2) or adsCorePriceEnabled.AsBoolean) then
					FirstPrice := adsCoreCryptBASECOST.AsCurrency;
			end;
			Next;
		end;
		First;
	end;

	if not adsCore.Locate( 'PriceEnabled', 'True', []) then
		adsCore.Locate( 'PriceEnabled', 'False', []);
	adsOrders.DataSource := dsCore;
	adsOrdersShowFormSummary.DataSource := dsCore;
	lblName.Caption := AName + ' ' + AForm;

	adsFirmsInfo.Open;

	inherited ShowForm; // д.б. перед MainForm.actPrint.OnExecute
	//готовим печать
	frVariables[ 'UseForms'] := UseForms;
	cbFilterSelect( nil);
end;

procedure TCoreForm.adsCore2SynonymGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
	if adsCoreSynonymCode.AsInteger < 0 then
	begin
		if Pos( '  ', Sender.AsString) > 0 then
			Text := Copy( Sender.AsString, Pos( '  ', Sender.AsString) + 2, Length( Sender.AsString));
	end
	else Text := Sender.AsString;
end;

procedure TCoreForm.adsCore2CalcFields(DataSet: TDataSet);
var
  S : String;
  C : Currency;
begin
try
{
  //TODO: Ќе забыть включить
  //вычисл€ем розничную цену PriceRet
  if adsCoreFirmCode.AsInteger=RegisterId then begin
    with DM.adsSelect do begin
      //TODO:ѕосмотреть сюда
      SelectSQL.Text:='SELECT '+RegionPriceRet+' FROM Regions WHERE Id='+RegionCodeStr;
      ParamByName('Price').Value:=adsCoreBaseCost.Value;
      Open;
      try
        if not IsEmpty then
          adsCorePriceRet.AsCurrency:=Fields[0].AsCurrency;
      finally
        Close;
      end;
    end;
  end
  else
    adsCorePriceRet.AsCurrency:=RoundTo(adsCoreBaseCost.AsCurrency*RetailForcount,-2);
}    

 try
   adsCoreCryptSYNONYMNAME.AsString := DM.D_S(adsCoreSYNONYMNAME.AsString);
   adsCoreCryptSYNONYMFIRM.AsString := DM.D_S(adsCoreSYNONYMFIRM.AsString);
   S := DM.D_B(adsCoreCODE.AsString, adsCoreCODECR.AsString);
   C := StrToCurr(S);
   adsCoreCryptBASECOST.AsCurrency := C;
   adsCorePriceRet.AsCurrency := DM.GetPriceRet(C);
  //вычисл€ем сумму заказа по товару SumOrder
  adsCoreSumOrder.AsCurrency:=C*adsCoreORDERCOUNT.AsInteger;
 except
 end;
  //вычисл€ем разницу в цене PriceDelta
  if Length(RecInfos)>0 then
    adsCorePriceDelta.AsFloat:=RecInfos[Abs(adsCore.RecNo)-1];
except
end;
end;

procedure TCoreForm.adsCore2BeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
	//PriceAvg: Double;
begin
	try
		{ провер€ем заказ на соответствие наличию товара на складе }
		Val( adsCoreQuantity.AsString,Quantity,E);
		if E<>0 then Quantity := 0;
		if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity) and
			( MessageBox( '«аказ превышает остаток на складе. ѕродолжить?',
			MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) then adsCoreORDERCOUNT.AsInteger := Quantity;

		{ провер€ем на превышение цены }
{
    //TODO: Ќе забыть включить
		if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) then
		begin
			PriceAvg := adsOrdersShowFormSummaryPriceAvg.AsCurrency;
			if ( PriceAvg > 0) and ( adsCoreBaseCost.AsCurrency>PriceAvg*( 1 + Excess / 100)) then
			begin
				plOverCost.Top := ( dbgCore.Height - plOverCost.Height) div 2;
				plOverCost.Left := ( dbgCore.Width - plOverCost.Width) div 2;
				plOverCost.BringToFront;
				plOverCost.Show;
				Timer.Enabled := True;
			end;
		end;
}    
  except
		adsCore.Cancel;
		raise;
	end;
end;

procedure TCoreForm.Print( APreview: boolean = False);
begin
	DM.ShowFastReport( 'Core.frf', adsCore, APreview);
end;

procedure TCoreForm.adsCore2AfterOpen(DataSet: TDataSet);
begin
//	adsOrders.Open;
//	adsOrdersShowFormSummary.Open;
end;

procedure TCoreForm.adsCore2BeforeClose(DataSet: TDataSet);
begin
//	adsOrders.Close;
//	adsOrdersShowFormSummary.Close;
end;

procedure TCoreForm.adsCore2BeforeEdit(DataSet: TDataSet);
begin
	if adsCoreFirmCode.AsInteger = RegisterId then Abort;
  DM.SetOldOrderCount(adsCoreORDERCOUNT.AsInteger);
end;

procedure TCoreForm.dbgCoreCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
	CanInput := ( adsCoreSynonymCode.AsInteger >= 0) and
		(( adsCoreRegionCode.AsInteger and DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
			adsCoreRegionCode.AsInteger);
	//if not CanInput then exit;

{
	// создаем записи из Orders и OrdersH, если их нет
	if adsCoreOrdersOrderId.IsNull then // нет соответствующей записи в Orders
	begin
		RefreshOrdersH;
		if adsOrdersH.IsEmpty then // нет заголовка заказа из OrdersH
		begin
			// добавл€ем запись в OrdersH
			adsCore.Edit;
			adsCoreOrdersHClientId.AsInteger := ClientId;
			adsCoreOrdersHPriceCode.AsInteger := adsCorePriceCode.AsInteger;
			adsCoreOrdersHRegionCode.AsInteger := adsCoreRegionCode.AsInteger;
			adsCoreOrdersHPriceName.AsString := adsCorePriceName.AsString;
			adsCoreOrdersHRegionName.AsString := adsCoreRegionName.AsString;
			adsCore.Post; // на этот момент уже имеем OrdersHOrderId (автоинкремент)
    end;

		//добавл€ем запись в Orders
		adsCore.Edit;
		if adsOrdersH.IsEmpty then adsCoreOrdersOrderId.AsInteger :=
			adsCoreOrdersHOrderId.AsInteger
		else adsCoreOrdersOrderId.AsInteger := adsOrdersH.FieldByName( 'OrderId').AsInteger;
		adsCoreOrdersClientId.AsInteger := ClientId;
		adsCoreOrdersFullCode.AsInteger := adsCoreFullCode.AsInteger;
		adsCoreOrdersCodeFirmCr.AsInteger := adsCoreCodeFirmCr.AsInteger;
		adsCoreOrdersCoreId.AsInteger := adsCoreCoreId.AsInteger;
		adsCoreOrdersSynonymCode.AsInteger := adsCoreSynonymCode.AsInteger;
		adsCoreOrdersSynonymFirmCrCode.AsInteger := adsCoreSynonymFirmCrCode.AsInteger;
		adsCoreOrdersCode.AsString := adsCoreCode.AsString;
		adsCoreOrdersCodeCr.AsString := adsCoreCodeCr.AsString;
		adsCoreOrdersPrice.AsCurrency := adsCoreBaseCost.AsCurrency;
		adsCoreOrdersJunk.AsBoolean := adsCoreJunk.AsBoolean;
		adsCoreOrdersAwait.AsBoolean := adsCoreAwait.AsBoolean;
		adsCoreOrdersSynonym.AsString := adsCoreSYNONYMNAME.AsString;
		adsCoreOrdersSynonymFirm.AsString := adsCoreSynonymFirm.AsString;
		adsCore.Post;
		if adsOrdersH.IsEmpty then RefreshOrdersH;
	end;
}
end;

//переоткрывает заголовок дл€ текущего заказа
//нужна дл€ поиска текущего OrdersH.OrderId при вводе заказа
procedure TCoreForm.RefreshOrdersH;
begin
	adsOrdersH.ParamByName( 'AClientId').Value := ClientId;
	adsOrdersH.ParamByName( 'APriceCode').Value := adsCorePriceCode.AsInteger;
	adsOrdersH.ParamByName( 'ARegionCode').Value := adsCoreRegionCode.AsInteger;
	if adsOrdersH.Active then adsOrdersH.CloseOpen(True) else adsOrdersH.Open;
end;

procedure TCoreForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (( Key = VK_ESCAPE) or ( Key = VK_SPACE)) and
		not TToughDBGrid( Sender).InSearch then
	begin
		if Self.PrevForm is TNamesFormsForm then
		begin
			Self.PrevForm.ShowForm;
			if TNamesFormsForm( Self.PrevForm).actUseForms.Checked then
				TNamesFormsForm( Self.PrevForm).dbgForms.SetFocus
			else TNamesFormsForm( Self.PrevForm).dbgNames.SetFocus;
		end;
	end;
end;

procedure TCoreForm.dbgCoreKeyPress(Sender: TObject; var Key: Char);
begin
	if ( Key > #32) and not ( Key in
		[ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
	begin
		if Self.PrevForm is TNamesFormsForm then
		begin
			Self.PrevForm.ShowForm;
			TNamesFormsForm( Self.PrevForm).dbgNames.SetFocus;
			SendMessage( GetFocus, WM_CHAR, Ord( Key), 0);
		end;
	end;
end;

procedure TCoreForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if adsCoreSynonymCode.AsInteger < 0 then
	begin
		Background := $00fff1d8;
                AFont.Style := [fsBold];
	end
	else
	if adsCoreFirmCode.AsInteger = RegisterId then
	begin
		//если это реестр, измен€ем цвета
		if ( Column.Field = adsCoreCryptSYNONYMNAME) or ( Column.Field = adsCoreCryptSYNONYMFIRM) or
			( Column.Field = adsCoreCryptBASECOST)or
			( Column.Field = adsCorePriceRet) then Background := REG_CLR;
        end
	else
	begin
		if not adsCorePriceEnabled.AsBoolean then
		begin
			//если фирма недоступна, измен€ем цвет
			if ( Column.Field = adsCoreCryptSYNONYMNAME) or ( Column.Field = adsCoreCryptSYNONYMFIRM)
				then Background := clBtnFace;
		end;

		//если уцененный товар, измен€ем цвет
		if adsCoreJunk.AsBoolean and (( Column.Field = adsCorePERIOD) or ( Column.Field = adsCoreCryptBASECOST)) then
			Background := JUNK_CLR;
		//ожидаемый товар выдел€ем зеленым
		if adsCoreAwait.AsBoolean and ( Column.Field = adsCoreCryptSYNONYMNAME) then
			Background := AWAIT_CLR;
	end;
end;

procedure TCoreForm.ShowOrdersH;
var
	OrdersH: TOrdersHForm;
begin
	OrdersH := TOrdersHForm( FindChildControlByClass( MainForm, TOrdersHForm));
	if OrdersH = nil then
	begin
		OrdersHForm := TOrdersHForm.Create( Application);
//		OrdersHForm.Show;
	end
	else
	begin
		OrdersHForm := OrdersH;
		OrdersHForm.Show;
		OrdersH.adsOrdersHForm.CloseOpen(True);
	end;
	MainForm.ActiveChild := OrdersHForm;
	MainForm.ActiveControl := OrdersHForm.ActiveControl;
end;

procedure TCoreForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

procedure TCoreForm.adsCore2AfterPost(DataSet: TDataSet);
begin
  DM.SetNewOrderCount(adsCoreORDERCOUNT.AsInteger, adsCoreCryptBASECOST.AsCurrency);
	MainForm.SetOrdersInfo;
end;

procedure TCoreForm.cbFilterSelect(Sender: TObject);
var
	ft: string;
begin
	if cbEnabled.ItemIndex = 0 then ft := ''
		else if cbEnabled.ItemIndex = 1 then ft := 'PriceEnabled = True'
			else ft := 'PriceEnabled = False';

	if cbFilter.Items[ cbFilter.ItemIndex] <> ALL_REGIONS then
	begin
		if ft <> '' then ft := ft + ' AND ';
		ft := ft + 'RegionName = ''' + cbFilter.Items[ cbFilter.ItemIndex] +
                ''' OR RegionName = NULL';
	end
	else
	begin
		if ft <> '' then ft := ft + ' OR PriceEnabled = NULL';
	end;
	DBProc.SetFilter( adsCore, ft);
	dbgCore.SetFocus;
end;

procedure TCoreForm.FormHide(Sender: TObject);
begin
	MainForm.RegionFilterIndex := cbFilter.ItemIndex;
	MainForm.EnableFilterIndex := cbEnabled.ItemIndex;
end;

procedure TCoreForm.dbgHistoryGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	//если уцененный товар, измен€ем цвет
	if adsOrdersJunk.AsBoolean and ( Column.Field = adsOrdersPRICE) then
		Background := JUNK_CLR;
	//ожидаемый товар выдел€ем зеленым
	if adsOrdersAwait.AsBoolean and ( Column.Field = adsOrdersPRICE) then
		Background := AWAIT_CLR;
end;

procedure TCoreForm.actFlipCoreExecute(Sender: TObject);
var
	SynonymCode, SynonymFirmCrCode, PriceCode, RegionCode: integer;
begin
	if MainFOrm.ActiveChild <> Self then exit;
	SynonymCode := adsCoreSynonymCode.AsInteger;
	SynonymFirmCrCode := adsCoreSynonymFirmCrCode.AsInteger;
	PriceCode := adsCorePriceCode.AsInteger;
	RegionCode := adsCoreRegionCode.AsInteger;
	ShowPrices;

	with TPricesForm( MainForm.ActiveChild) do
	begin
		adsPrices.Locate( 'PriceCode;RegionCode', VarArrayOf([ PriceCode, RegionCode]), []);
		CoreFirmForm.ShowForm( PriceCode, RegionCode, actOnlyLeaders.Checked);
		CoreFirmForm.adsCore.Locate( 'SynonymCode;SynonymFirmCrCode',
			VarArrayOf([ SynonymCode, SynonymFirmCrCode]), []);
	end;
end;

procedure TCoreForm.adsCore2AfterScroll(DataSet: TDataSet);
//var
//  C : Integer;
begin
{
  C := dbgCore.Canvas.TextHeight('Wg') + 2;
  if (adsCore.RecordCount > 0) and ((adsCore.RecordCount*C)/(pCenter.Height-pWebBrowser.Height) > 13/10) then
    pWebBrowser.Visible := False
  else
    pWebBrowser.Visible := True;
}
end;

procedure TCoreForm.FormResize(Sender: TObject);
begin
  adsCore2AfterScroll(adsCore);
end;

procedure TCoreForm.adsCoreSTORAGEGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  text := Iif(Sender.AsBoolean, '+', '');
end;

end.
