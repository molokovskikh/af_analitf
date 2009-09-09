unit Expireds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, RXDBCtrl, DModule, DB, AProc,
  Placemnt, StdCtrls, ExtCtrls, DBGridEh, ToughDBGrid, Registry, OleCtrls,
  SHDocVw, FIBDataSet, pFIBDataSet, FIBSQLMonitor, DBProc, FIBQuery, Constant,
  GridsEh, ActnList, MemDS, DBAccess, MyAccess;

const
	ExpiredSql	= 'SELECT * FROM EXPIREDSSHOW(:TIMEZONEBIAS, :ACLIENTID) ORDER BY ';

type
  TExpiredsForm = class(TChildForm)
    dsExpireds: TDataSource;
    Timer: TTimer;
    pClient: TPanel;
    dbgExpireds: TToughDBGrid;
    adsExpiredsOld: TpFIBDataSet;
    adsExpiredsOldSumOrder: TCurrencyField;
    adsOrdersShowFormSummaryOld: TpFIBDataSet;
    adsExpiredsOldPriceRet: TCurrencyField;
    adsExpiredsOldCryptBASECOST: TCurrencyField;
    adsExpiredsOldCOREID: TFIBBCDField;
    adsExpiredsOldPRICECODE: TFIBBCDField;
    adsExpiredsOldREGIONCODE: TFIBBCDField;
    adsExpiredsOldFULLCODE: TFIBBCDField;
    adsExpiredsOldCODEFIRMCR: TFIBBCDField;
    adsExpiredsOldSYNONYMCODE: TFIBBCDField;
    adsExpiredsOldSYNONYMFIRMCRCODE: TFIBBCDField;
    adsExpiredsOldCODE: TFIBStringField;
    adsExpiredsOldCODECR: TFIBStringField;
    adsExpiredsOldNOTE: TFIBStringField;
    adsExpiredsOldPERIOD: TFIBStringField;
    adsExpiredsOldVOLUME: TFIBStringField;
    adsExpiredsOldQUANTITY: TFIBStringField;
    adsExpiredsOldSYNONYMNAME: TFIBStringField;
    adsExpiredsOldSYNONYMFIRM: TFIBStringField;
    adsExpiredsOldAWAIT: TFIBIntegerField;
    adsExpiredsOldPRICENAME: TFIBStringField;
    adsExpiredsOldDATEPRICE: TFIBDateTimeField;
    adsExpiredsOldREGIONNAME: TFIBStringField;
    adsExpiredsOldORDERSCOREID: TFIBBCDField;
    adsExpiredsOldORDERSORDERID: TFIBBCDField;
    adsExpiredsOldORDERSCLIENTID: TFIBBCDField;
    adsExpiredsOldORDERSFULLCODE: TFIBBCDField;
    adsExpiredsOldORDERSCODEFIRMCR: TFIBBCDField;
    adsExpiredsOldORDERSSYNONYMCODE: TFIBBCDField;
    adsExpiredsOldORDERSSYNONYMFIRMCRCODE: TFIBBCDField;
    adsExpiredsOldORDERSCODE: TFIBStringField;
    adsExpiredsOldORDERSCODECR: TFIBStringField;
    adsExpiredsOldORDERSSYNONYM: TFIBStringField;
    adsExpiredsOldORDERSSYNONYMFIRM: TFIBStringField;
    adsExpiredsOldORDERCOUNT: TFIBIntegerField;
    adsExpiredsOldORDERSJUNK: TFIBIntegerField;
    adsExpiredsOldORDERSAWAIT: TFIBIntegerField;
    adsExpiredsOldORDERSHORDERID: TFIBBCDField;
    adsExpiredsOldORDERSHCLIENTID: TFIBBCDField;
    adsExpiredsOldORDERSHPRICECODE: TFIBBCDField;
    adsExpiredsOldORDERSHREGIONCODE: TFIBBCDField;
    adsExpiredsOldORDERSHPRICENAME: TFIBStringField;
    adsExpiredsOldORDERSHREGIONNAME: TFIBStringField;
    pRecordCount: TPanel;
    lblRecordCount: TLabel;
    Bevel1: TBevel;
    pWebBrowser: TPanel;
    Bevel2: TBevel;
    WebBrowser1: TWebBrowser;
    adsExpiredsOldBASECOST: TFIBStringField;
    adsExpiredsOldORDERSPRICE: TFIBStringField;
    adsExpiredsOldDOC: TFIBStringField;
    adsExpiredsOldREGISTRYCOST: TFIBFloatField;
    adsExpiredsOldVITALLYIMPORTANT: TFIBIntegerField;
    adsExpiredsOldREQUESTRATIO: TFIBIntegerField;
    adsExpiredsOldORDERCOST: TFIBBCDField;
    adsExpiredsOldMINORDERCOUNT: TFIBIntegerField;
    adsOrdersShowFormSummaryOldPRICEAVG: TFIBBCDField;
    ActionList: TActionList;
    actFlipCore: TAction;
    plOverCost: TPanel;
    lWarning: TLabel;
    adsAvgOrders: TMyQuery;
    adsExpireds: TMyQuery;
    adsAvgOrdersPRICEAVG: TFloatField;
    adsExpiredsCoreId: TLargeintField;
    adsExpiredsPriceCode: TLargeintField;
    adsExpiredsRegionCode: TLargeintField;
    adsExpiredsproductid: TLargeintField;
    adsExpiredsfullcode: TLargeintField;
    adsExpiredsCodeFirmCr: TLargeintField;
    adsExpiredsSynonymCode: TLargeintField;
    adsExpiredsSynonymFirmCrCode: TLargeintField;
    adsExpiredsCode: TStringField;
    adsExpiredsCodeCr: TStringField;
    adsExpiredsNote: TStringField;
    adsExpiredsPeriod: TStringField;
    adsExpiredsVolume: TStringField;
    adsExpiredsCost: TFloatField;
    adsExpiredsQuantity: TStringField;
    adsExpiredsdoc: TStringField;
    adsExpiredsregistrycost: TFloatField;
    adsExpiredsvitallyimportant: TBooleanField;
    adsExpiredsrequestratio: TIntegerField;
    adsExpiredsordercost: TFloatField;
    adsExpiredsminordercount: TIntegerField;
    adsExpiredsSynonymName: TStringField;
    adsExpiredsSynonymFirm: TStringField;
    adsExpiredsAwait: TBooleanField;
    adsExpiredsPriceName: TStringField;
    adsExpiredsDatePrice: TDateTimeField;
    adsExpiredsRegionName: TStringField;
    adsExpiredsOrdersCoreId: TLargeintField;
    adsExpiredsOrdersOrderId: TLargeintField;
    adsExpiredsOrdersClientId: TLargeintField;
    adsExpiredsOrdersFullCode: TLargeintField;
    adsExpiredsOrdersCodeFirmCr: TLargeintField;
    adsExpiredsOrdersSynonymCode: TLargeintField;
    adsExpiredsOrdersSynonymFirmCrCode: TLargeintField;
    adsExpiredsOrdersCode: TStringField;
    adsExpiredsOrdersCodeCr: TStringField;
    adsExpiredsOrdersSynonym: TStringField;
    adsExpiredsOrdersSynonymFirm: TStringField;
    adsExpiredsOrderCount: TIntegerField;
    adsExpiredsOrdersPrice: TFloatField;
    adsExpiredsSumOrder: TFloatField;
    adsExpiredsOrdersJunk: TBooleanField;
    adsExpiredsOrdersAwait: TBooleanField;
    adsExpiredsOrdersHOrderId: TLargeintField;
    adsExpiredsOrdersHClientId: TLargeintField;
    adsExpiredsOrdersHPriceCode: TLargeintField;
    adsExpiredsOrdersHRegionCode: TLargeintField;
    adsExpiredsOrdersHPriceName: TStringField;
    adsExpiredsOrdersHRegionName: TStringField;
    adsExpiredsCryptPriceRet: TCurrencyField;
    adsAvgOrdersPRODUCTID: TLargeintField;
    btnGotoCore: TButton;
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
    procedure actFlipCoreExecute(Sender: TObject);
  private
    ClientId: Integer;
    UseExcess: Boolean;
    Excess: Integer;

    procedure ecf(DataSet: TDataSet);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Main, NamesForms;

procedure TExpiredsForm.FormCreate(Sender: TObject);
var
	Reg: TRegIniFile;
begin
  plOverCost.Hide();
  dsCheckVolume := adsExpireds;
  dgCheckVolume := dbgExpireds;
  fOrder := adsExpiredsORDERCOUNT;
  fVolume := adsExpiredsREQUESTRATIO;
  fOrderCost := adsExpiredsORDERCOST;
  fSumOrder := adsExpiredsSumOrder;
  fMinOrderCount := adsExpiredsMINORDERCOUNT;
  inherited;
  adsExpireds.OnCalcFields := ecf;
	ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
  UseExcess := True;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
	adsAvgOrders.ParamByName('ClientId').Value := ClientId;
	adsExpireds.ParamByName( 'AClientId').Value := ClientId;
	adsExpireds.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	Screen.Cursor := crHourGlass;
	try
		adsExpireds.Open;
    adsAvgOrders.Open;
	finally
		Screen.Cursor := crDefault;
	end;
	lblRecordCount.Caption := Format( lblRecordCount.Caption, [adsExpireds.RecordCount]);
	Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, False)
    then
      dbgExpireds.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
  finally
  	Reg.Free;
  end;
  if dbgExpireds.SortMarkedColumns.Count = 0 then
    dbgExpireds.FieldColumns['SYNONYMNAME'].Title.SortMarker := smUpEh;
	ShowForm;
  adsExpireds.First;
end;

procedure TExpiredsForm.FormDestroy(Sender: TObject);
var
	Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey('Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, True);
    dbgExpireds.SaveColumnsLayout(Reg);
  finally
    Reg.Free;
  end;
end;

procedure TExpiredsForm.ecf(DataSet: TDataSet);
begin
  try
    adsExpiredsCryptPriceRet.AsCurrency := DM.GetPriceRet(adsExpiredsCOST.AsCurrency);
  except
  end;
end;

procedure TExpiredsForm.adsExpireds2BeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
	PriceAvg: Double;
  PanelCaption : String;
  PanelHeight : Integer;
begin
	try
		{ проверяем заказ на соответствие наличию товара на складе }
		Val( adsExpiredsQuantity.AsString, Quantity, E);
		if E <> 0 then Quantity := 0;
		if ( Quantity > 0) and ( adsExpiredsORDERCOUNT.AsInteger > Quantity)and
			(AProc.MessageBox('Заказ превышает остаток на складе. Продолжить?',
			MB_ICONQUESTION or MB_OKCANCEL) <> IDOK) then adsExpiredsORDERCOUNT.AsInteger := Quantity;

    PanelCaption := '';
    
		{ проверяем на превышение цены }
		if UseExcess and ( adsExpiredsORDERCOUNT.AsInteger > 0) and (not adsAvgOrdersPRODUCTID.IsNull) then
		begin
			PriceAvg := adsAvgOrdersPRICEAVG.AsCurrency;
			if ( PriceAvg > 0) and ( adsExpiredsCOST.AsCurrency>PriceAvg*(1+Excess/100)) then
			begin
        PanelCaption := 'Превышение средней цены!';
			end;
		end;

    if Length(PanelCaption) > 0 then
      PanelCaption := PanelCaption + #13#10 + 'Вы заказали некондиционный препарат.'
    else
      PanelCaption := 'Вы заказали некондиционный препарат.';

    if (adsExpiredsORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + 'Внимание! Вы заказали большое количество препарата.'
      else
        PanelCaption := 'Внимание! Вы заказали большое количество препарата.';

    if Length(PanelCaption) > 0 then begin
      if Timer.Enabled then
        Timer.OnTimer(nil);

      lWarning.Caption := PanelCaption;
      PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
      plOverCost.Height := PanelHeight*WordCount(PanelCaption, [#13, #10]) + 20;

      plOverCost.Top := ( dbgExpireds.Height - plOverCost.Height) div 2;
      plOverCost.Left := ( dbgExpireds.Width - plOverCost.Width) div 2;
      plOverCost.BringToFront;
      plOverCost.Show;
      Timer.Enabled := True;
    end;

  except
		adsExpireds.Cancel;
		raise;
	end;
end;

procedure TExpiredsForm.dbgExpiredsCanInput(Sender: TObject;
  Value: Integer; var CanInput: Boolean);
begin
	CanInput := ( adsExpiredsRegionCode.AsInteger and DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
		adsExpiredsRegionCode.AsInteger;
	if not CanInput then exit;

end;

procedure TExpiredsForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

procedure TExpiredsForm.adsExpireds2AfterPost(DataSet: TDataSet);
begin
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
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TExpiredsForm.dbgExpiredsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if adsExpiredsVITALLYIMPORTANT.AsBoolean then
    AFont.Color := VITALLYIMPORTANT_CLR;

	//уцененный товар
	if (( Column.Field = adsExpiredsPERIOD) or ( Column.Field = adsExpiredsCOST))
  then Background := JUNK_CLR;
end;

procedure TExpiredsForm.actFlipCoreExecute(Sender: TObject);
var
	FullCode, ShortCode: integer;
  CoreId : Int64;
begin
	if MainForm.ActiveChild <> Self then exit;
  if adsExpireds.IsEmpty then Exit;

	FullCode := adsExpiredsFullCode.AsInteger;
	ShortCode := DM.QueryValue('select ShortCode from catalogs where FullCode = ' + IntToStr(FullCode), [] , []);

  CoreId := adsExpiredsCOREID.AsLargeInt;

  FlipToCode(FullCode, ShortCode, CoreId);
end;

end.
