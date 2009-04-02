unit CoreFirm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXDBCtrl, Grids, DBGrids, ComCtrls, Db, StrUtils, Child,
  FR_DSet, FR_DBSet, ActnList, StdCtrls, Buttons, DBCtrls, Variants,
  Math, ExtCtrls, DBGridEh, ToughDBGrid, Registry, OleCtrls, SHDocVw,
  FIBDataSet, pFIBDataSet, FIBSQLMonitor, hlpcodecs, LU_Tracer, FIBQuery,
  pFIBQuery, lU_TSGHashTable, SQLWaiting, ForceRus, GridsEh, pFIBProps,
  U_frameLegend;

const
	CoreSql =	'SELECT * FROM CORESHOWBYFIRM(:APRICECODE, :AREGIONCODE, :ACLIENTID) ORDER BY ';

type
  TFilter=( filAll, filOrder, filLeader);

  TCoreFirmForm = class(TChildForm)
    dsCore: TDataSource;
    ActionList: TActionList;
    actFilterAll: TAction;
    actFilterOrder: TAction;
    actFilterLeader: TAction;
    actSaveToFile: TAction;
    actDeleteOrder: TAction;
    frdsCore: TfrDBDataSet;
    lblRecordCount: TLabel;
    cbFilter: TComboBox;
    lblOrderLabel: TLabel;
    btnDeleteOrder: TSpeedButton;
    btnFormHistory: TSpeedButton;
    lblFirmPrice: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    dbgCore: TToughDBGrid;
    Timer: TTimer;
    Bevel1: TBevel;
    actFlipCore: TAction;
    adsCore: TpFIBDataSet;
    adsCoreSumOrder: TCurrencyField;
    adsCountFields: TpFIBDataSet;
    adsOrdersH: TpFIBDataSet;
    adsOrdersShowFormSummary: TpFIBDataSet;
    adsCoreCryptBASECOST: TCurrencyField;
    adsCorePriceRet: TCurrencyField;
    adsCoreCOREID: TFIBBCDField;
    adsCoreFULLCODE: TFIBBCDField;
    adsCoreSHORTCODE: TFIBBCDField;
    adsCoreCODEFIRMCR: TFIBBCDField;
    adsCoreSYNONYMCODE: TFIBBCDField;
    adsCoreSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreCODE: TFIBStringField;
    adsCoreCODECR: TFIBStringField;
    adsCoreVOLUME: TFIBStringField;
    adsCoreDOC: TFIBStringField;
    adsCoreNOTE: TFIBStringField;
    adsCorePERIOD: TFIBStringField;
    adsCoreAWAIT: TFIBIntegerField;
    adsCoreJUNK: TFIBIntegerField;
    adsCoreQUANTITY: TFIBStringField;
    adsCoreSYNONYMNAME: TFIBStringField;
    adsCoreSYNONYMFIRM: TFIBStringField;
    adsCoreLEADERPRICECODE: TFIBBCDField;
    adsCoreLEADERREGIONCODE: TFIBBCDField;
    adsCoreLEADERREGIONNAME: TFIBStringField;
    adsCoreLEADERPRICENAME: TFIBStringField;
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
    adsCoreORDERSJUNK: TFIBIntegerField;
    adsCoreORDERSAWAIT: TFIBIntegerField;
    adsCoreORDERSHORDERID: TFIBBCDField;
    adsCoreORDERSHCLIENTID: TFIBBCDField;
    adsCoreORDERSHPRICECODE: TFIBBCDField;
    adsCoreORDERSHREGIONCODE: TFIBBCDField;
    adsCoreORDERSHPRICENAME: TFIBStringField;
    adsCoreORDERSHREGIONNAME: TFIBStringField;
    adsCoreLEADERCODE: TFIBStringField;
    adsCoreLEADERCODECR: TFIBStringField;
    adsCoreCryptLEADERPRICE: TCurrencyField;
    adsCoreBASECOST: TFIBStringField;
    adsCoreLEADERPRICE: TFIBStringField;
    adsCoreORDERSPRICE: TFIBStringField;
    pTop: TPanel;
    eSearch: TEdit;
    btnSearch: TButton;
    tmrSearch: TTimer;
    adsCoreREGISTRYCOST: TFIBFloatField;
    adsCoreVITALLYIMPORTANT: TFIBIntegerField;
    adsCoreREQUESTRATIO: TFIBIntegerField;
    adsCoreWithLike: TpFIBDataSet;
    adsCoreORDERCOST: TFIBBCDField;
    adsCoreMINORDERCOUNT: TFIBIntegerField;
    adsCorePRODUCTID: TFIBBCDField;
    adsOrdersShowFormSummaryPRODUCTID: TFIBBCDField;
    adsOrdersShowFormSummaryPRICEAVG: TFIBBCDField;
    plOverCost: TPanel;
    lWarning: TLabel;
    frameLegeng: TframeLegeng;
    procedure cbFilterClick(Sender: TObject);
    procedure actDeleteOrderExecute(Sender: TObject);
    procedure adsCore2BeforePost(DataSet: TDataSet);
    procedure adsCore2AfterPost(DataSet: TDataSet);
    procedure adsCore2BeforeEdit(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure actFilterAllExecute(Sender: TObject);
    procedure actFilterOrderExecute(Sender: TObject);
    procedure actFilterLeaderExecute(Sender: TObject);
    procedure btnFormHistoryClick(Sender: TObject);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure dbgCoreKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCoreSortMarkingChanged(Sender: TObject);
    procedure adsCoreLEADERPRICENAMEGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure tmrSearchTimer(Sender: TObject);
    procedure dbgCoreDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
  private
    OldOrder, OrderCount, PriceCode, RegionCode, ClientId: Integer;
    PriceName,
    RegionName : String;
    OrderSum: Double;

    UseExcess: Boolean;
    Excess: Integer;
    InternalSearchText : String;

    BM : TBitmap;

    fr : TForceRus;

    procedure OrderCalc;
    procedure SetOrderLabel;
    procedure SetFilter(Filter: TFilter);
    procedure RefreshOrdersH;
    procedure AllFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure OrderCountFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure LeaderFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure ccf(DataSet: TDataSet);
    procedure SetClear;
    procedure AddKeyToSearch(Key : Char);
  public
    procedure ShowForm(APriceCode, ARegionCode: Integer;
      APriceName, ARegionName : String;
      OnlyLeaders: Boolean=False;
      FromOrders : Boolean = False); reintroduce;
    procedure Print( APreview: boolean = False); override;
    procedure RefreshAllCore;
  end;

var
  CoreFirmForm: TCoreFirmForm;

implementation

uses Main, AProc, DModule, DBProc, FormHistory, Prices, Constant,
  NamesForms, AlphaUtils, Orders;

{$R *.DFM}

procedure TCoreFirmForm.FormCreate(Sender: TObject);
var
	Reg: TRegIniFile;
begin
  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreORDERCOUNT;
  fVolume := adsCoreREQUESTRATIO;
  fOrderCost := adsCoreORDERCOST;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMINORDERCOUNT;

  inherited;

  BM := TBitmap.Create;
  
  fr := TForceRus.Create;
  
  InternalSearchText := '';
  adsCore.OnCalcFields := ccf;
	PrintEnabled := (DM.SaveGridMask and PrintFirmPrice) > 0;
  UseExcess := True;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
	ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
	adsOrdersShowFormSummary.ParamByName('AClientId').Value := ClientId;
	Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, False)
    then
      dbgCore.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
  finally
  	Reg.Free;
  end;
  if dbgCore.SortMarkedColumns.Count = 0 then
    dbgCore.FieldColumns['SYNONYMNAME'].Title.SortMarker := smUpEh;
end;

procedure TCoreFirmForm.FormDestroy(Sender: TObject);
var
	Reg: TRegIniFile;
begin
	inherited;
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey('Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, True);
    dbgCore.SaveColumnsLayout(Reg);
  finally
    Reg.Free;
  end;
  fr.Free;
  BM.Free;
end;

procedure TCoreFirmForm.ShowForm(APriceCode, ARegionCode: Integer;
  APriceName, ARegionName : String; OnlyLeaders: Boolean=False; FromOrders : Boolean = False);
begin
  plOverCost.Hide();
  PriceCode:=APriceCode;
  RegionCode:=ARegionCode;
  PriceName := APriceName;
  RegionName := ARegionName;
  //���� ������ ���� �� ������
  if FromOrders then begin
    dbgCore.InputField := '';
  end
  else begin
    dbgCore.InputField := 'OrderCount';
    RefreshAllCore;
    SetFilter(filAll);
    if adsCore.RecordCount=0 then begin
      AProc.MessageBox('��������� �����-���� �����������',MB_ICONWARNING);
      Abort;
    end;
    if OnlyLeaders then
      SetFilter(filLeader)
    else
      SetFilter(filAll);
  end;
  //������������ ����� ������ � ���������� �������
  OrderCalc;
  SetOrderLabel;
  lblFirmPrice.Caption := Format( '�����-���� %s, ������ %s',[
    PriceName,
    RegionName]);
  if not adsOrdersShowFormSummary.Active then
    adsOrdersShowFormSummary.Open;
  Application.ProcessMessages;
  inherited ShowForm;
end;

procedure TCoreFirmForm.ccf(DataSet: TDataSet);
var
  S : String;
  C : Currency;
begin
  try
    S := DM.D_B_N(adsCoreBASECOST.AsString);
    C := StrToCurr(S);
    adsCoreCryptBASECOST.AsCurrency := C;
    adsCorePriceRet.AsCurrency := DM.GetPriceRet(C);
    adsCoreSumOrder.AsCurrency := adsCoreCryptBASECOST.AsCurrency * adsCoreORDERCOUNT.AsInteger;
    S := DM.D_B_N(adsCoreLEADERPRICE.AsString);
    C := StrToCurr(S);
    adsCoreCryptLEADERPRICE.AsCurrency := C;
  except
    adsCoreSumOrder.AsCurrency := 0;
  end;
end;

procedure TCoreFirmForm.SetFilter(Filter: TFilter);
var
  FP : TFilterRecordEvent;
begin
  FP := nil;
  case Filter of
    filAll:
      begin
        if Length(InternalSearchText) > 0 then
          FP := AllFilterRecord
        else begin
          FP := nil;
          tmrSearch.Enabled := False;
          eSearch.Text := '';
          InternalSearchText := '';
        end;
      end;
    filOrder: FP := OrderCountFilterRecord;
    filLeader: FP := LeaderFilterRecord;
  end;
  DBProc.SetFilterProc(adsCore, FP);
  lblRecordCount.Caption:=Format( '������� : %d', [adsCore.VisibleRecordCount]);
  cbFilter.ItemIndex := Integer(Filter);
end;

procedure TCoreFirmForm.cbFilterClick(Sender: TObject);
begin
  dbgCore.SetFocus;
  SetFilter(TFilter(cbFilter.ItemIndex));
end;

procedure TCoreFirmForm.actFilterAllExecute(Sender: TObject);
begin
	if Self.Visible then SetFilter(filAll);
end;

procedure TCoreFirmForm.actFilterOrderExecute(Sender: TObject);
begin
	if Self.Visible then SetFilter(filOrder);
end;

procedure TCoreFirmForm.actFilterLeaderExecute(Sender: TObject);
begin
	if Self.Visible then SetFilter(filLeader);
end;

procedure TCoreFirmForm.Print( APreview: boolean = False);
var
  OldFilterEvent : TFilterRecordEvent;
  OldFiltered : Boolean;
begin
  RefreshOrdersH;
  OldFiltered := adsCore.Filtered;
  OldFilterEvent := adsCore.OnFilterRecord;
  adsCore.DisableControls;
  try
    adsCore.Filtered := False;
    adsCore.DoSort(['SynonymName'], [True]);
    DM.ShowFastReport('CoreFirm.frf', adsCore, APreview);
    if OldFiltered then
      DBProc.SetFilterProc(adsCore, OldFilterEvent);
    dbgCore.OnSortMarkingChanged(dbgCore);
  finally
    adsCore.EnableControls;
  end;
end;

//������������� ��������� ��� �������� ������
//����� ��� ������. �� �������, �.�. ��������� ������ �����-�����
procedure TCoreFirmForm.RefreshOrdersH;
begin
  with adsOrdersH do begin
    ParamByName('AClientId').Value:=ClientId;
    ParamByName('APriceCode').Value:=PriceCode;
    ParamByName('ARegionCode').Value:=RegionCode;
  end;
end;

procedure TCoreFirmForm.adsCore2BeforeEdit(DataSet: TDataSet);
begin
  OldOrder:=adsCoreORDERCOUNT.AsInteger;
  DM.SetOldOrderCount(OldOrder);
end;

procedure TCoreFirmForm.adsCore2BeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
	PriceAvg: Double;
  PanelCaption : String;
  PanelHeight : Integer;
begin
	try
		{ ��������� ����� �� ������������ ������� ������ �� ������ }
		Val( adsCoreQuantity.AsString, Quantity, E);
		if E <> 0 then Quantity := 0;
		if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity) and
			( AProc.MessageBox( '����� ��������� ������� �� ������. ����������?',
			MB_ICONQUESTION or MB_OKCANCEL) <> IDOK) then adsCoreORDERCOUNT.AsInteger := Quantity;

    PanelCaption := '';
    
		{ ��������� �� ���������� ���� }
		if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) then
		begin
      if (adsOrdersShowFormSummary.Locate('PRODUCTID', adsCorePRODUCTID.AsVariant, [])) then
      begin
        PriceAvg := adsOrdersShowFormSummaryPRICEAVG.AsCurrency;
        if ( PriceAvg > 0) and ( adsCoreCryptBASECOST.AsCurrency>PriceAvg*(1+Excess/100)) then
        begin
          PanelCaption := '���������� ������� ����!';
        end;
      end;
		end;

    if (adsCoreJUNK.AsBoolean) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + '�� �������� �������������� ��������.'
      else
        PanelCaption := '�� �������� �������������� ��������.';

    if (adsCoreORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + '��������! �� �������� ������� ���������� ���������.'
      else
        PanelCaption := '��������! �� �������� ������� ���������� ���������.';

    if Length(PanelCaption) > 0 then begin
      if Timer.Enabled then
        Timer.OnTimer(nil);

      lWarning.Caption := PanelCaption;
      PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
      plOverCost.Height := PanelHeight*WordCount(PanelCaption, [#13, #10]) + 20;

      plOverCost.Top := ( dbgCore.Height - plOverCost.Height) div 2;
      plOverCost.Left := ( dbgCore.Width - plOverCost.Width) div 2;
      plOverCost.BringToFront;
      plOverCost.Show;
      Timer.Enabled := True;
    end;

  except
		adsCore.Cancel;
		raise;
	end;
end;

procedure TCoreFirmForm.adsCore2AfterPost(DataSet: TDataSet);
begin
	OrderCount := OrderCount + Iif( adsCoreORDERCOUNT.AsInteger = 0, 0, 1) - Iif( OldOrder = 0, 0, 1);
	OrderSum := OrderSum + ( adsCoreORDERCOUNT.AsInteger - OldOrder) * adsCoreCryptBASECOST.AsCurrency;
  DM.SetNewOrderCount(adsCoreORDERCOUNT.AsInteger, adsCoreCryptBASECOST.AsCurrency, PriceCode, RegionCode);
	SetOrderLabel;
	MainForm.SetOrdersInfo;
end;

procedure TCoreFirmForm.OrderCalc;
begin
  OrderCount := DM.MyConnection.ExecSQL('SELECT count(*) FROM Orders, ordersh WHERE ' +
    'ordersh.PriceCode = :PriceCode and ordersh.regioncode = :RegionCode ' +
    'and Orders.OrderId = ordersh.orderid and ordersh.closed = 0 ' +
    'AND Orders.OrderCount>0', [PriceCode, RegionCode]);
	OrderSum :=DM.FindOrderInfo(PriceCode, RegionCode).Summ;
end;

procedure TCoreFirmForm.SetOrderLabel;
begin
  lblOrderLabel.Caption:=Format('�������� %d ������� �� ����� %0.2f ���.',
    [OrderCount,OrderSum]);
end;

procedure TCoreFirmForm.btnFormHistoryClick(Sender: TObject);
begin
  ShowFormHistory(adsCoreFullCode.AsInteger,ClientId);
end;

procedure TCoreFirmForm.actDeleteOrderExecute(Sender: TObject);
begin
  if not Visible then Exit;
  if AProc.MessageBox( '������� ���� ����� �� ������� �����-�����?',
    MB_ICONQUESTION or MB_OKCANCEL)<>IDOK then Abort;
  adsCore.DisableControls;
  Screen.Cursor:=crHourGlass;
  try
    with DM.adcUpdate do begin
      //������� ����������� ������ (���� ����)
      SQL.Text:=Format( 'EXECUTE PROCEDURE OrdersHDeleteNotClosed(:ACLIENTID, :APRICECODE, :AREGIONCODE)',
        [DM.adtClients.FieldByName('ClientId').AsInteger,PriceCode,RegionCode]);
      ParamByName('ACLIENTID').Value := DM.adtClients.FieldByName('ClientId').Value;
      ParamByName('APRICECODE').Value := PriceCode;
      ParamByName('AREGIONCODE').Value := RegionCode;
      Execute;
    end;
  finally
    adsCore.EnableControls;
    RefreshAllCore;
    Screen.Cursor:=crDefault;
    OrderCount := 0;
    OrderSum := 0;
  	SetOrderLabel;
    //DM.InitAllSumOrder;
    MainForm.SetOrdersInfo;
  end;
  dbgCore.SetFocus;
  //���� �� ������ ���� �� ����� ������, �� ������������ ���� ��� ������
  if Self.PrevForm is TOrdersForm then begin
    Self.PrevForm := nil;
    Close;
  end;
end;

procedure TCoreFirmForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if adsCoreVITALLYIMPORTANT.AsBoolean then
    AFont.Color := VITALLYIMPORTANT_CLR;

	//������ �����-�����
	if (((adsCoreLEADERPRICECODE.AsInteger = PriceCode) and	( adsCoreLeaderRegionCode.AsInteger = RegionCode))
     or (abs(adsCoreCryptBASECOST.AsCurrency - adsCoreCryptLEADERPRICE.AsCurrency) < 0.01)
     )
    and
		(( Column.Field = adsCoreLEADERREGIONNAME) or ( Column.Field = adsCoreLEADERPRICENAME))
  then
			Background := LEADER_CLR;
	//��������� �����
	if (adsCoreJunk.Value = 1) and (( Column.Field = adsCorePERIOD) or
		( Column.Field = adsCoreCryptBASECOST)) then Background := JUNK_CLR;
	//��������� ����� �������� �������
	if (adsCoreAwait.Value = 1) and ( Column.Field = adsCoreSYNONYMNAME) then
		Background := AWAIT_CLR;
end;

procedure TCoreFirmForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
	if ( Key = VK_RETURN) then
    if tmrSearch.Enabled then
      tmrSearchTimer(nil)
    else
      btnFormHistoryClick( nil);
  if Key = VK_ESCAPE then
    if Assigned(Self.PrevForm) and (Self.PrevForm is TOrdersForm) then begin
      tmrSearch.Enabled := False;
      Self.PrevForm.ShowForm
    end
    else
      if tmrSearch.Enabled or (Length(InternalSearchText) > 0) then
        SetClear
      else
        if Assigned(Self.PrevForm) then
          Self.PrevForm.ShowForm
        else
          Close;
end;

procedure TCoreFirmForm.dbgCoreCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
	CanInput := ( RegionCode and DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
		RegionCode;
	if not CanInput then Exit;
end;

procedure TCoreFirmForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

procedure TCoreFirmForm.actFlipCoreExecute(Sender: TObject);
var
	FullCode, ShortCode: integer;
  CoreId : Int64;
begin
	if MainForm.ActiveChild <> Self then exit;
  if Self.PrevForm is TOrdersForm then exit;

	FullCode := adsCoreFullCode.AsInteger;
	ShortCode := adsCoreShortCode.AsInteger;

  CoreId := adsCoreCOREID.AsInt64;

  FlipToCode(FullCode, ShortCode, CoreId);
end;

procedure TCoreFirmForm.dbgCoreKeyPress(Sender: TObject; var Key: Char);
begin
	if ( Key > #32) and not ( Key in
		[ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
	begin
    AddKeyToSearch(Key);
  end;
end;

procedure TCoreFirmForm.OrderCountFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if Length(InternalSearchText) > 0 then
    Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
      and not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0)
  else
    Accept := not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0);
end;

procedure TCoreFirmForm.LeaderFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if Length(InternalSearchText) > 0 then
    Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
    and
    (
     ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
      or (abs(adsCoreCryptBASECOST.AsCurrency - adsCoreCryptLEADERPRICE.AsCurrency) < 0.01)
    )
  else
    Accept := ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
      or (abs(adsCoreCryptBASECOST.AsCurrency - adsCoreCryptLEADERPRICE.AsCurrency) < 0.01);
end;

procedure TCoreFirmForm.RefreshAllCore;
begin
  Screen.Cursor:=crHourglass;
  try
    adsCore.ParamByName( 'APriceCode').Value:=PriceCode;
    adsCore.ParamByName( 'ARegionCode').Value:=RegionCode;
    adsCore.ParamByName( 'AClientId').Value:=ClientId;
    ShowSQLWaiting(adsCore);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TCoreFirmForm.dbgCoreSortMarkingChanged(Sender: TObject);
begin
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TCoreFirmForm.adsCoreLEADERPRICENAMEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if (abs(adsCoreCryptBASECOST.AsCurrency - adsCoreCryptLEADERPRICE.AsCurrency) < 0.01) then
    Text := PriceName
  else
    Text := Sender.AsString;
end;

procedure TCoreFirmForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if Length(eSearch.Text) > 2 then begin
    InternalSearchText := LeftStr(eSearch.Text, 50);
    if Assigned(Self.PrevForm) and (Self.PrevForm is TOrdersForm) then begin
      adsCore.Close;
      adsCore.SelectSQL.Text := adsCoreWithLike.SelectSQL.Text;
      adsCore.ParamByName('LikeParam').AsString := '%' + InternalSearchText + '%';
      RefreshAllCore;
      dbgCore.InputField := 'OrderCount';
    end;
    if not Assigned(adsCore.OnFilterRecord) then begin
      adsCore.OnFilterRecord := AllFilterRecord;
      adsCore.Filtered := True;
    end
    else
      DBProc.SetFilterProc(adsCore, adsCore.OnFilterRecord);
    lblRecordCount.Caption:=Format( '������� : %d', [adsCore.VisibleRecordCount]);
    eSearch.Text := '';
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TCoreFirmForm.AllFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText);
end;

procedure TCoreFirmForm.SetClear;
var
  p : TFilterRecordEvent;
begin
  tmrSearch.Enabled := False;
  eSearch.Text := '';
  InternalSearchText := '';
  p := AllFilterRecord;
  if @adsCore.OnFilterRecord = @p then begin
    adsCore.Filtered := False;
    adsCore.OnFilterRecord := nil;
  end
  else
    DBProc.SetFilterProc(adsCore, adsCore.OnFilterRecord);
  lblRecordCount.Caption:=Format( '������� : %d', [adsCore.VisibleRecordCount]);
end;

procedure TCoreFirmForm.dbgCoreDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if Column.Field = adsCoreSYNONYMNAME then
    ProduceAlphaBlendRect(InternalSearchText, Column.Field.DisplayText, dbgCore.Canvas, Rect, BM);
end;

procedure TCoreFirmForm.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
    dbgCore.SetFocus;
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TCoreFirmForm.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //���� �� ���-�� ������ � ��������, �� ������ �� ��� �������������
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

procedure TCoreFirmForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

end.
