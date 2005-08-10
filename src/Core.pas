unit Core;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, DBGrids, ComCtrls, Db, StrUtils,
  StdCtrls, Buttons, DBCtrls, FR_Class, FR_DSet, FR_DBSet,
  Child, ADODB, RXDBCtrl, Variants, AdoInt, Math, DBGridEh,
  ToughDBGrid, Registry, OleCtrls, SHDocVw, ActnList;

const
	ALL_REGIONS	= 'Все регионы';

type
  TCoreForm = class(TChildForm)
    dsCore: TDataSource;
    gbPrevOrders: TGroupBox;
    lblPriceAvg: TLabel;
    frdsCore: TfrDBDataSet;
    dsOrders: TDataSource;
    adsOrders: TADODataSet;
    dbtPriceAvg: TDBText;
    adsOrdersSynonym: TWideStringField;
    adsOrdersSynonymFirm: TWideStringField;
    adsOrdersOrder: TIntegerField;
    adsOrdersPrice: TBCDField;
    adsOrdersOrderDate: TDateTimeField;
    adsOrdersH: TADODataSet;
    adsOrdersShowFormSummary: TADODataSet;
    dsOrdersShowFormSummary: TDataSource;
    adsOrdersShowFormSummaryPriceAvg: TBCDField;
    pBottom: TPanel;
    dbgHistory: TToughDBGrid;
    pTop: TPanel;
    lblName: TLabel;
    adsFirmsInfo: TADODataSet;
    dsFirmsInfo: TDataSource;
    dbmContactInfo: TDBMemo;
    lblSupportPhone: TLabel;
    dbtSupportPhone: TDBText;
    gbFirmInfo: TGroupBox;
    plOverCost: TPanel;
    Timer: TTimer;
    adsCore: TADODataSet;
    adsCoreCoreId: TAutoIncField;
    adsCorePriceCode: TIntegerField;
    adsCoreRegionCode: TIntegerField;
    adsCoreAFullCode: TIntegerField;
    adsCoreShortCode: TIntegerField;
    adsCoreCodeFirmCr: TIntegerField;
    adsCoreSynonymCode: TIntegerField;
    adsCoreSynonymFirmCrCode: TIntegerField;
    adsCoreCode: TWideStringField;
    adsCoreCodeCr: TWideStringField;
    adsCorePeriod: TWideStringField;
    adsCoreSale: TSmallintField;
    adsCoreVolume: TWideStringField;
    adsCoreNote: TWideStringField;
    adsCoreBaseCost: TBCDField;
    adsCoreQuantity: TWideStringField;
    adsCoreAwait: TBooleanField;
    adsCoreJunk: TBooleanField;
    adsCoreSynonym: TWideStringField;
    adsCoreSynonymFirm: TWideStringField;
    adsCoreDatePrice: TDateTimeField;
    adsCorePriceEnabled: TBooleanField;
    adsCorePriceName: TWideStringField;
    adsCoreStorage: TBooleanField;
    adsCoreRegionName: TWideStringField;
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
    adsCoreSumOrder: TCurrencyField;
    adsCorePriceRet: TCurrencyField;
    adsCorePriceDelta: TFloatField;
    cbFilter: TComboBox;
    adsRegions: TADODataSet;
    adsOrdersPriceName: TWideStringField;
    cbEnabled: TComboBox;
    adsOrdersAwait: TBooleanField;
    adsOrdersJunk: TBooleanField;
    ActionList: TActionList;
    actFlipCore: TAction;
    adsCoreFirmCode: TAutoIncField;
    pCenter: TPanel;
    pWebBrowser: TPanel;
    Bevel1: TBevel;
    WebBrowser1: TWebBrowser;
    dbgCore: TToughDBGrid;
    procedure adsCoreCalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure adsCoreBeforePost(DataSet: TDataSet);
    procedure adsCoreAfterOpen(DataSet: TDataSet);
    procedure adsCoreBeforeClose(DataSet: TDataSet);
    procedure adsCoreBeforeEdit(DataSet: TDataSet);
    procedure adsCoreSynonymGetText(Sender: TField; var Text: String;
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
    procedure adsCoreAfterPost(DataSet: TDataSet);
    procedure cbFilterSelect(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure dbgHistoryGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure adsCoreAfterScroll(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
  private
    RegionCodeStr, RegionPriceRet: string;
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
  Prices, pFIBDataSet;

{$R *.DFM}

procedure TCoreForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;
	PrintEnabled:=True;
	UseExcess := DM.adtClients.FieldByName( 'UseExcess').AsBoolean;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
        DeltaMode := DM.adtClients.FieldByName( 'DeltaMode').AsInteger;
	RetailForcount := 1 + DM.adtClients.FieldByName( 'Forcount').AsFloat / 100;
	RegionCodeStr := DM.adtClients.FieldByName( 'RegionCode').AsString;

	adsOrders.Parameters.ParamByName( 'AClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').AsInteger;
	adsOrdersShowFormSummary.Parameters.ParamByName( 'AClientId').Value :=
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
			if UseForms then CommandText := 'SELECT * FROM CoreShowByForm'
				else CommandText := 'SELECT * FROM CoreShowByName';
			Parameters.ParamByName( 'RegisterId').Value := RegisterId;
			Parameters.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
			Parameters.ParamByName( 'AClientId').Value := ClientId;
		end;
		Parameters.ParamByName( 'ParentCode').Value := AParentCode;
	end;
	{ открываем запрос }
	with adsCore do
	begin
		Parameters.ParamByName( 'ShowRegister').Value :=
			DM.adtParams.FieldByName( 'ShowRegister').AsBoolean;
		Screen.Cursor := crHourglass;
		try
			if Active then Requery else Open;
		finally
			Screen.Cursor := crDefault;
		end;
        end;

	{ проверка непустоты }
	if adsCore.RecordCount = 0 then
	begin
		MessageBox( 'Нет предложений', MB_ICONWARNING);
		Abort;
	end;

	{ заполняем список регионов для фильтрации }
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

	//готовим значения для колонки "Разница"
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
			//переменные, необходимые для расчета разницы в цене
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
			if ( D = 0) or ( adsCoreBaseCost.AsCurrency = 0) then
				RecInfos[ I] := 0
			else
				RecInfos[ I] := RoundTo(( adsCoreBaseCost.AsCurrency - D)/D*100,-1);
			if adsCoreSynonymCode.AsInteger >= 0 then
			begin
				if adsCoreBaseCost.AsCurrency > 0 then PrevPrice := adsCoreBaseCost.AsCurrency;
				if ( FirstPrice=0) and (( DeltaMode <> 2) or adsCorePriceEnabled.AsBoolean) then
					FirstPrice := adsCoreBaseCost.AsCurrency;
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

procedure TCoreForm.adsCoreSynonymGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
	if adsCoreSynonymCode.AsInteger < 0 then
	begin
		if Pos( '  ', Sender.AsString) > 0 then
			Text := Copy( Sender.AsString, Pos( '  ', Sender.AsString) + 2, Length( Sender.AsString));
	end
	else Text := Sender.AsString;
end;

procedure TCoreForm.adsCoreCalcFields(DataSet: TDataSet);
begin
try
  //вычисляем розничную цену PriceRet
  if adsCoreFirmCode.AsInteger=RegisterId then begin
    with DM.adsSelect do begin
      //TODO:Посмотреть сюда
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
  //вычисляем сумму заказа по товару SumOrder
  adsCoreSumOrder.AsCurrency:=adsCoreBaseCost.AsCurrency*adsCoreOrder.AsInteger;
  //вычисляем разницу в цене PriceDelta
  if Length(RecInfos)>0 then
    adsCorePriceDelta.AsFloat:=RecInfos[Abs(adsCore.RecNo)-1];
except
	on E: Exception do ShowMessage( 'Check point #2 : ' + E.Message);
end;
end;

procedure TCoreForm.adsCoreBeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
	PriceAvg: Double;
begin
	try
		{ проверяем заказ на соответствие наличию товара на складе }
		Val( adsCoreQuantity.AsString,Quantity,E);
		if E<>0 then Quantity := 0;
		if ( Quantity > 0) and ( adsCoreOrder.AsInteger > Quantity) and
			( MessageBox( 'Заказ превышает остаток на складе. Продолжить?',
			MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) then adsCoreOrder.AsInteger := Quantity;

		{ проверяем на превышение цены }
		if UseExcess and ( adsCoreOrder.AsInteger>0) then
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
        except
		adsCore.Cancel;
		raise;
	end;
end;

procedure TCoreForm.Print( APreview: boolean = False);
begin
	DM.ShowFastReport( 'Core.frf', adsCore, APreview);
end;

procedure TCoreForm.adsCoreAfterOpen(DataSet: TDataSet);
begin
	adsOrders.Open;
	adsOrdersShowFormSummary.Open;
end;

procedure TCoreForm.adsCoreBeforeClose(DataSet: TDataSet);
begin
	adsOrders.Close;
	adsOrdersShowFormSummary.Close;
end;

procedure TCoreForm.adsCoreBeforeEdit(DataSet: TDataSet);
begin
	if adsCoreFirmCode.AsInteger = RegisterId then Abort;
end;

procedure TCoreForm.dbgCoreCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
	CanInput := ( adsCoreSynonymCode.AsInteger >= 0) and
		(( adsCoreRegionCode.AsInteger and DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
			adsCoreRegionCode.AsInteger);
	if not CanInput then exit;

	// создаем записи из Orders и OrdersH, если их нет
	if adsCoreOrdersOrderId.IsNull then // нет соответствующей записи в Orders
	begin
		RefreshOrdersH;
		if adsOrdersH.IsEmpty then // нет заголовка заказа из OrdersH
		begin
			// добавляем запись в OrdersH
			adsCore.Edit;
			adsCoreOrdersHClientId.AsInteger := ClientId;
			adsCoreOrdersHPriceCode.AsInteger := adsCorePriceCode.AsInteger;
			adsCoreOrdersHRegionCode.AsInteger := adsCoreRegionCode.AsInteger;
			adsCoreOrdersHPriceName.AsString := adsCorePriceName.AsString;
			adsCoreOrdersHRegionName.AsString := adsCoreRegionName.AsString;
			adsCore.Post; // на этот момент уже имеем OrdersHOrderId (автоинкремент)
                end;

		//добавляем запись в Orders
		adsCore.Edit;
		if adsOrdersH.IsEmpty then adsCoreOrdersOrderId.AsInteger :=
			adsCoreOrdersHOrderId.AsInteger
		else adsCoreOrdersOrderId.AsInteger := adsOrdersH.FieldByName( 'OrderId').AsInteger;
		adsCoreOrdersClientId.AsInteger := ClientId;
		adsCoreOrdersFullCode.AsInteger := adsCoreAFullCode.AsInteger;
		adsCoreOrdersCodeFirmCr.AsInteger := adsCoreCodeFirmCr.AsInteger;
		adsCoreOrdersCoreId.AsInteger := adsCoreCoreId.AsInteger;
		adsCoreOrdersSynonymCode.AsInteger := adsCoreSynonymCode.AsInteger;
		adsCoreOrdersSynonymFirmCrCode.AsInteger := adsCoreSynonymFirmCrCode.AsInteger;
		adsCoreOrdersCode.AsString := adsCoreCode.AsString;
		adsCoreOrdersCodeCr.AsString := adsCoreCodeCr.AsString;
		adsCoreOrdersPrice.AsCurrency := adsCoreBaseCost.AsCurrency;
		adsCoreOrdersJunk.AsBoolean := adsCoreJunk.AsBoolean;
		adsCoreOrdersAwait.AsBoolean := adsCoreAwait.AsBoolean;
		adsCoreOrdersSynonym.AsString := adsCoreSynonym.AsString;
		adsCoreOrdersSynonymFirm.AsString := adsCoreSynonymFirm.AsString;
		adsCore.Post;
		if adsOrdersH.IsEmpty then RefreshOrdersH;
	end;
end;

//переоткрывает заголовок для текущего заказа
//нужна для поиска текущего OrdersH.OrderId при вводе заказа
procedure TCoreForm.RefreshOrdersH;
begin
	adsOrdersH.Parameters.ParamByName( 'AClientId').Value := ClientId;
	adsOrdersH.Parameters.ParamByName( 'APriceCode').Value := adsCorePriceCode.AsInteger;
	adsOrdersH.Parameters.ParamByName( 'ARegionCode').Value := adsCoreRegionCode.AsInteger;
	if adsOrdersH.Active then adsOrdersH.Requery else adsOrdersH.Open;
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
		//если это реестр, изменяем цвета
		if ( Column.FieldName = 'Synonym') or ( Column.FieldName = 'SynonymFirm') or
			( Column.FieldName = 'BaseCost')or
			( Column.FieldName = 'PriceRet') then Background := REG_CLR;
        end
	else
	begin
		if not adsCorePriceEnabled.AsBoolean then
		begin
			//если фирма недоступна, изменяем цвет
			if ( Column.FieldName = 'Synonym') or ( Column.FieldName = 'SynonymFirm')
				then Background := clBtnFace;
		end;

		//если уцененный товар, изменяем цвет
		if adsCoreJunk.AsBoolean and (( Column.FieldName = 'Period') or ( Column.FieldName = 'BaseCost')) then
			Background := JUNK_CLR;
		//ожидаемый товар выделяем зеленым
		if adsCoreAwait.AsBoolean and ( Column.FieldName = 'Synonym') then
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
		OrdersH.adsOrdersH.Requery;
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

procedure TCoreForm.adsCoreAfterPost(DataSet: TDataSet);
begin
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
	//если уцененный товар, изменяем цвет
	if adsOrdersJunk.AsBoolean and ( Column.FieldName = 'Price') then
		Background := JUNK_CLR;
	//ожидаемый товар выделяем зеленым
	if adsOrdersAwait.AsBoolean and ( Column.FieldName = 'Price') then
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

procedure TCoreForm.adsCoreAfterScroll(DataSet: TDataSet);
var
  C : Integer;
begin
  C := dbgCore.Canvas.TextHeight('Wg') + 2;
  if (adsCore.RecordCount > 0) and ((adsCore.RecordCount*C)/(pCenter.Height-pWebBrowser.Height) > 13/10) then
    pWebBrowser.Visible := False
  else
    pWebBrowser.Visible := True;
end;

procedure TCoreForm.FormResize(Sender: TObject);
begin
  adsCoreAfterScroll(adsCore);
end;

end.
