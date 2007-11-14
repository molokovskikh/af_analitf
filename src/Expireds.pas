unit Expireds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, RXDBCtrl, DModule, DB, AProc,
  Placemnt, StdCtrls, ExtCtrls, DBGridEh, ToughDBGrid, Registry, OleCtrls,
  SHDocVw, FIBDataSet, pFIBDataSet, FIBSQLMonitor, DBProc, FIBQuery, Constant,
  GridsEh, ActnList;

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
    adsExpiredsBASECOST: TFIBStringField;
    adsExpiredsORDERSPRICE: TFIBStringField;
    adsExpiredsDOC: TFIBStringField;
    adsExpiredsREGISTRYCOST: TFIBFloatField;
    adsExpiredsVITALLYIMPORTANT: TFIBIntegerField;
    adsExpiredsREQUESTRATIO: TFIBIntegerField;
    adsExpiredsORDERCOST: TFIBBCDField;
    adsExpiredsMINORDERCOUNT: TFIBIntegerField;
    adsOrdersShowFormSummaryPRICEAVG: TFIBBCDField;
    ActionList: TActionList;
    actFlipCore: TAction;
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
var
  S : String;
  C : Currency;
begin
  try
    S := DM.D_B_N(adsExpiredsBASECOST.AsString);
    C := StrToCurr(S);
    adsExpiredsCryptBASECOST.AsCurrency := C;
    adsExpiredsPriceRet.AsCurrency := DM.GetPriceRet(C);
	  //вычисл€ем сумму заказа
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
		{ провер€ем заказ на соответствие наличию товара на складе }
		Val( adsExpiredsQuantity.AsString, Quantity, E);
		if E <> 0 then Quantity := 0;
		if ( Quantity > 0) and ( adsExpiredsORDERCOUNT.AsInteger > Quantity)and
			(MessageBox('«аказ превышает остаток на складе. ѕродолжить?',
			MB_ICONQUESTION or MB_OKCANCEL) <> IDOK) then adsExpiredsORDERCOUNT.AsInteger := Quantity;

		{ провер€ем на превышение цены }
		if UseExcess and ( adsExpiredsORDERCOUNT.AsInteger > 0) then
		begin
			PriceAvg := adsOrdersShowFormSummaryPRICEAVG.AsCurrency;
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
  DM.SetNewOrderCount(adsExpiredsORDERCOUNT.AsInteger, adsExpiredsCryptBASECOST.AsCurrency, adsExpiredsPRICECODE.AsInteger, adsExpiredsREGIONCODE.AsInteger);
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

procedure TExpiredsForm.actFlipCoreExecute(Sender: TObject);
var
	FullCode, ShortCode: integer;
  CoreId : Int64;
begin
	if MainForm.ActiveChild <> Self then exit;
  if adsExpireds.IsEmpty then Exit;

	FullCode := adsExpiredsFullCode.AsInteger;
	ShortCode := DM.MainConnection1.QueryValue('select ShortCode from catalogs where FullCode = ' + IntToStr(FullCode), 0);

  CoreId := adsExpiredsCOREID.AsInt64;

  FlipToCode(FullCode, ShortCode, CoreId);
end;

end.
