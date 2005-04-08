unit Expireds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, RXDBCtrl, DModule, DB, ADODB, AProc,
  Placemnt, StdCtrls, ExtCtrls, DBGridEh, ToughDBGrid, Registry, OleCtrls,
  SHDocVw;

const
	ExpiredSql	= 'SELECT * FROM ExpiredsShow ORDER BY ';

type
  TExpiredsForm = class(TChildForm)
    dsExpireds: TDataSource;
    lblRecordCount: TLabel;
    adsOrdersH: TADODataSet;
    Panel1: TPanel;
    plOverCost: TPanel;
    adsOrdersShowFormSummary: TADODataSet;
    adsOrdersShowFormSummaryPriceAvg: TBCDField;
    Timer: TTimer;
    Bevel1: TBevel;
    adsExpireds: TADODataSet;
    adsExpiredsCoreId: TIntegerField;
    adsExpiredsPriceCode: TIntegerField;
    adsExpiredsRegionCode: TIntegerField;
    adsExpiredsFullCode: TIntegerField;
    adsExpiredsCodeFirmCr: TIntegerField;
    adsExpiredsSynonymCode: TIntegerField;
    adsExpiredsSynonymFirmCrCode: TIntegerField;
    adsExpiredsCode: TWideStringField;
    adsExpiredsCodeCr: TWideStringField;
    adsExpiredsOrder: TIntegerField;
    adsExpiredsNote: TWideStringField;
    adsExpiredsAwait: TBooleanField;
    adsExpiredsPeriod: TWideStringField;
    adsExpiredsVolume: TWideStringField;
    adsExpiredsBaseCost: TBCDField;
    adsExpiredsQuantity: TWideStringField;
    adsExpiredsSynonym: TWideStringField;
    adsExpiredsSynonymFirm: TWideStringField;
    adsExpiredsPriceName: TWideStringField;
    adsExpiredsRegionName: TWideStringField;
    adsExpiredsDatePrice: TDateTimeField;
    adsExpiredsPriceRet: TFloatField;
    adsExpiredsSumOrder: TCurrencyField;
    adsExpiredsOrdersCoreId: TIntegerField;
    adsExpiredsOrdersOrderId: TIntegerField;
    adsExpiredsOrdersClientId: TSmallintField;
    adsExpiredsOrdersFullCode: TIntegerField;
    adsExpiredsOrdersCodeFirmCr: TIntegerField;
    adsExpiredsOrdersSynonymCode: TIntegerField;
    adsExpiredsOrdersSynonymFirmCrCode: TIntegerField;
    adsExpiredsOrdersCode: TWideStringField;
    adsExpiredsOrdersCodeCr: TWideStringField;
    adsExpiredsOrdersPrice: TBCDField;
    adsExpiredsOrdersJunk: TBooleanField;
    adsExpiredsOrdersAwait: TBooleanField;
    adsExpiredsOrdersHOrderId: TAutoIncField;
    adsExpiredsOrdersHClientId: TSmallintField;
    adsExpiredsOrdersHPriceCode: TIntegerField;
    adsExpiredsOrdersHRegionCode: TIntegerField;
    adsExpiredsOrdersHPriceName: TWideStringField;
    adsExpiredsOrdersHRegionName: TWideStringField;
    adsExpiredsOrdersSynonym: TWideStringField;
    adsExpiredsOrdersSynonymFirm: TWideStringField;
    pClient: TPanel;
    pWebBrowser: TPanel;
    Bevel2: TBevel;
    WebBrowser1: TWebBrowser;
    dbgExpireds: TToughDBGrid;
    procedure adsExpiredsCalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure adsExpiredsBeforePost(DataSet: TDataSet);
    procedure dbgExpiredsCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure dbgExpiredsSortChange(Sender: TObject; SQLOrderBy: String);
    procedure TimerTimer(Sender: TObject);
    procedure adsExpiredsBeforeClose(DataSet: TDataSet);
    procedure adsExpiredsAfterOpen(DataSet: TDataSet);
    procedure adsExpiredsAfterPost(DataSet: TDataSet);
    procedure adsExpiredsAfterScroll(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
  private
    ClientId: Integer;
    UseExcess: Boolean;
    Excess: Integer;

    procedure RefreshOrdersH;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Main, ADOInt;

procedure TExpiredsForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
	ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
	UseExcess := DM.adtClients.FieldByName( 'UseExcess').AsBoolean;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
	adsOrdersShowFormSummary.Parameters.ParamByName('AClientId').Value := ClientId;
	adsExpireds.Parameters.ParamByName( 'AClientId').Value := ClientId;
	adsExpireds.Parameters.ParamByName( 'RetailForcount').Value := DM.adtClients.FieldByName( 'Forcount').Value;
	adsExpireds.Parameters.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	Screen.Cursor := crHourGlass;
	try
		adsExpireds.Open;
	finally
		Screen.Cursor := crDefault;
	end;
	lblRecordCount.Caption := Format( lblRecordCount.Caption, [adsExpireds.RecordCount]);
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\' +
		Self.ClassName, False) then dbgExpireds.LoadFromRegistry( Reg);
	Reg.Free;
	ShowForm;
end;

procedure TExpiredsForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, True);
	dbgExpireds.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TExpiredsForm.adsExpiredsCalcFields(DataSet: TDataSet);
begin
	//вычисляем сумму заказа
	adsExpiredsSumOrder.AsCurrency:=adsExpiredsBaseCost.AsCurrency*adsExpiredsOrder.AsInteger;
end;

procedure TExpiredsForm.adsExpiredsBeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
	PriceAvg: Double;
begin
	try
		{ проверяем заказ на соответствие наличию товара на складе }
		Val( adsExpiredsQuantity.AsString, Quantity, E);
		if E <> 0 then Quantity := 0;
		if ( Quantity > 0) and ( adsExpiredsOrder.AsInteger > Quantity)and
			(MessageBox('Заказ превышает остаток на складе. Продолжить?',
			MB_ICONQUESTION or MB_OKCANCEL) <> IDOK) then adsExpiredsOrder.AsInteger := Quantity;

		{ проверяем на превышение цены }
		if UseExcess and ( adsExpiredsOrder.AsInteger > 0) then
		begin
			PriceAvg := adsOrdersShowFormSummaryPriceAvg.AsCurrency;
			if ( PriceAvg > 0) and ( adsExpiredsBaseCost.AsCurrency>PriceAvg*(1+Excess/100)) then
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
	adsOrdersH.Parameters.ParamByName( 'AClientId').Value := ClientId;
	adsOrdersH.Parameters.ParamByName( 'APriceCode').Value := adsExpiredsPriceCode.AsInteger;
	adsOrdersH.Parameters.ParamByName( 'ARegionCode').Value := adsExpiredsRegionCode.AsInteger;
	if adsOrdersH.Active then adsOrdersH.Requery else adsOrdersH.Open;
end;

procedure TExpiredsForm.dbgExpiredsCanInput(Sender: TObject;
  Value: Integer; var CanInput: Boolean);
begin
	CanInput := ( adsExpiredsRegionCode.AsInteger and DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
		adsExpiredsRegionCode.AsInteger;
	if not CanInput then exit;

	//создаем записи из Orders и OrdersH, если их нет
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
    adsExpiredsOrdersSynonym.AsString := adsExpiredsSynonym.AsString;
    adsExpiredsOrdersSynonymFirm.AsString := adsExpiredsSynonymFirm.AsString;
    adsExpireds.Post;
    if adsOrdersH.IsEmpty then RefreshOrdersH;
  end;
end;

procedure TExpiredsForm.dbgExpiredsSortChange(Sender: TObject;
  SQLOrderBy: String);
begin
	adsExpireds.Close;
	adsExpireds.CommandText := ExpiredSql + SQLOrderBy;
	ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
	adsExpireds.Parameters.ParamByName( 'AClientId').Value := ClientId;
	adsExpireds.Parameters.ParamByName( 'RetailForcount').Value := DM.adtClients.FieldByName( 'Forcount').Value;
	adsExpireds.Parameters.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	Screen.Cursor := crHourGlass;
	try
		adsExpireds.Open;
	finally
		Screen.Cursor := crDefault;
	end;
end;

procedure TExpiredsForm.adsExpiredsAfterOpen(DataSet: TDataSet);
begin
	adsOrdersShowFormSummary.Open;
end;

procedure TExpiredsForm.adsExpiredsBeforeClose(DataSet: TDataSet);
begin
	adsOrdersShowFormSummary.Close;
end;

procedure TExpiredsForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

procedure TExpiredsForm.adsExpiredsAfterPost(DataSet: TDataSet);
begin
	MainForm.SetOrdersInfo;
end;

procedure TExpiredsForm.adsExpiredsAfterScroll(DataSet: TDataSet);
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
  adsExpiredsAfterScroll(adsExpireds);
end;

end.
