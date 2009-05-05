unit SynonymSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DB, FIBDataSet, pFIBDataSet, ActnList, ExtCtrls, FR_DSet,
  FR_DBSet, Grids, DBGridEh, ToughDBGrid, StdCtrls, Registry, Constant,
  ForceRus, DBGrids, Buttons, Menus, ibase, DBCtrls, StrUtils, GridsEh,
  U_frameLegend, MemDS, DBAccess, MyAccess;

type
  TSynonymSearchForm = class(TChildForm)
    pTop: TPanel;
    pCenter: TPanel;
    dbgCore: TToughDBGrid;
    dsCore: TDataSource;
    frdsCore: TfrDBDataSet;
    Timer: TTimer;
    ActionList: TActionList;
    actFlipCore: TAction;
    adsCoreOld: TpFIBDataSet;
    adsCoreOldSumOrder: TCurrencyField;
    adsCoreOldPriceRet: TCurrencyField;
    adsCoreOldPriceDelta: TFloatField;
    adsCoreOldCryptBASECOST: TCurrencyField;
    adsOrdersHOld: TpFIBDataSet;
    eSearch: TEdit;
    btnSearch: TButton;
    tmrSearch: TTimer;
    adsCoreOldCOREID: TFIBBCDField;
    adsCoreOldPRICECODE: TFIBBCDField;
    adsCoreOldREGIONCODE: TFIBBCDField;
    adsCoreOldSHORTCODE: TFIBBCDField;
    adsCoreOldCODEFIRMCR: TFIBBCDField;
    adsCoreOldSYNONYMCODE: TFIBBCDField;
    adsCoreOldSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreOldCODE: TFIBStringField;
    adsCoreOldCODECR: TFIBStringField;
    adsCoreOldPERIOD: TFIBStringField;
    adsCoreOldSALE: TFIBIntegerField;
    adsCoreOldVOLUME: TFIBStringField;
    adsCoreOldNOTE: TFIBStringField;
    adsCoreOldQUANTITY: TFIBStringField;
    adsCoreOldAWAIT: TFIBBooleanField;
    adsCoreOldJUNK: TFIBBooleanField;
    adsCoreOldSYNONYMNAME: TFIBStringField;
    adsCoreOldSYNONYMFIRM: TFIBStringField;
    adsCoreOldPRICENAME: TFIBStringField;
    adsCoreOldPRICEENABLED: TFIBBooleanField;
    adsCoreOldFIRMCODE: TFIBBCDField;
    adsCoreOldSTORAGE: TFIBBooleanField;
    adsCoreOldREGIONNAME: TFIBStringField;
    adsCoreOldORDERSCOREID: TFIBBCDField;
    adsCoreOldORDERSORDERID: TFIBBCDField;
    adsCoreOldORDERSCLIENTID: TFIBBCDField;
    adsCoreOldORDERSFULLCODE: TFIBBCDField;
    adsCoreOldORDERSCODEFIRMCR: TFIBBCDField;
    adsCoreOldORDERSSYNONYMCODE: TFIBBCDField;
    adsCoreOldORDERSSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreOldORDERSCODE: TFIBStringField;
    adsCoreOldORDERSCODECR: TFIBStringField;
    adsCoreOldORDERCOUNT: TFIBIntegerField;
    adsCoreOldORDERSSYNONYM: TFIBStringField;
    adsCoreOldORDERSSYNONYMFIRM: TFIBStringField;
    adsCoreOldORDERSJUNK: TFIBBooleanField;
    adsCoreOldORDERSAWAIT: TFIBBooleanField;
    adsCoreOldORDERSHORDERID: TFIBBCDField;
    adsCoreOldORDERSHCLIENTID: TFIBBCDField;
    adsCoreOldORDERSHPRICECODE: TFIBBCDField;
    adsCoreOldORDERSHREGIONCODE: TFIBBCDField;
    adsCoreOldORDERSHPRICENAME: TFIBStringField;
    adsCoreOldORDERSHREGIONNAME: TFIBStringField;
    adsCoreOldFULLCODE: TFIBBCDField;
    cbBaseOnly: TCheckBox;
    btnSelectPrices: TBitBtn;
    pmSelectedPrices: TPopupMenu;
    miSelectAll: TMenuItem;
    miUnselecAll: TMenuItem;
    miSep: TMenuItem;
    lFilter: TLabel;
    adsOrdersShowFormSummaryOld: TpFIBDataSet;
    adsCoreOldDATEPRICE: TFIBDateTimeField;
    adsCoreOldBASECOST: TFIBStringField;
    adsCoreOldORDERSPRICE: TFIBStringField;
    pBottom: TPanel;
    gbPrevOrders: TGroupBox;
    lblPriceAvg: TLabel;
    dbtPriceAvg: TDBText;
    dbgHistory: TToughDBGrid;
    adsOrdersOld: TpFIBDataSet;
    adsOrdersOldFULLCODE: TFIBBCDField;
    adsOrdersOldSYNONYMNAME: TFIBStringField;
    adsOrdersOldSYNONYMFIRM: TFIBStringField;
    adsOrdersOldORDERCOUNT: TFIBIntegerField;
    adsOrdersOldORDERDATE: TFIBDateTimeField;
    adsOrdersOldPRICENAME: TFIBStringField;
    adsOrdersOldREGIONNAME: TFIBStringField;
    adsOrdersOldAWAIT: TFIBIntegerField;
    adsOrdersOldJUNK: TFIBIntegerField;
    adsOrdersOldCODE: TFIBStringField;
    adsOrdersOldCODECR: TFIBStringField;
    adsOrdersOldPRICE: TFIBStringField;
    dsOrders: TDataSource;
    dsOrdersShowFormSummary: TDataSource;
    adsCoreOldDOC: TFIBStringField;
    adsCoreOldREGISTRYCOST: TFIBFloatField;
    adsCoreOldVITALLYIMPORTANT: TFIBBooleanField;
    adsCoreOldREQUESTRATIO: TFIBIntegerField;
    adsOrdersOldSENDPRICE: TFIBBCDField;
    adsCoreOldORDERCOST: TFIBBCDField;
    adsCoreOldMINORDERCOUNT: TFIBIntegerField;
    adsOrdersShowFormSummaryOldPRICEAVG: TFIBBCDField;
    adsCoreOldPRODUCTID: TFIBBCDField;
    plOverCost: TPanel;
    lWarning: TLabel;
    adsCoreOldSortOrder: TIntegerField;
    frameLegeng: TframeLegeng;
    adsOrdersH: TMyQuery;
    adsCore: TMyQuery;
    adsCoreCoreId: TLargeintField;
    adsCoreCLIENTID: TLargeintField;
    adsCorePriceCode: TLargeintField;
    adsCoreRegionCode: TLargeintField;
    adsCoreProductID: TLargeintField;
    adsCoreFullCode: TLargeintField;
    adsCoreshortcode: TLargeintField;
    adsCoreCodeFirmCr: TLargeintField;
    adsCoreSynonymCode: TLargeintField;
    adsCoreSynonymFirmCrCode: TLargeintField;
    adsCoreCode: TStringField;
    adsCoreCodeCr: TStringField;
    adsCorePeriod: TStringField;
    adsCoreVolume: TStringField;
    adsCoreNote: TStringField;
    adsCoreCost: TFloatField;
    adsCoreQuantity: TStringField;
    adsCoreAwait: TBooleanField;
    adsCoreJunk: TBooleanField;
    adsCoredoc: TStringField;
    adsCoreregistrycost: TFloatField;
    adsCorevitallyimportant: TBooleanField;
    adsCorerequestratio: TIntegerField;
    adsCoreOrderCost: TFloatField;
    adsCoreMinOrderCount: TIntegerField;
    adsCoreSynonymName: TStringField;
    adsCoreSynonymFirm: TStringField;
    adsCoreDatePrice: TDateTimeField;
    adsCorePriceName: TStringField;
    adsCorePriceEnabled: TBooleanField;
    adsCoreFirmCode: TLargeintField;
    adsCoreStorage: TBooleanField;
    adsCoreRegionName: TStringField;
    adsCoreOrdersCoreId: TLargeintField;
    adsCoreOrdersOrderId: TLargeintField;
    adsCoreOrdersClientId: TLargeintField;
    adsCoreOrdersFullCode: TLargeintField;
    adsCoreOrdersCodeFirmCr: TLargeintField;
    adsCoreOrdersSynonymCode: TLargeintField;
    adsCoreOrdersSynonymFirmCrCode: TLargeintField;
    adsCoreOrdersCode: TStringField;
    adsCoreOrdersCodeCr: TStringField;
    adsCoreOrderCount: TIntegerField;
    adsCoreOrdersSynonym: TStringField;
    adsCoreOrdersSynonymFirm: TStringField;
    adsCoreOrdersPrice: TFloatField;
    adsCoreSumOrder: TFloatField;
    adsCoreOrdersJunk: TBooleanField;
    adsCoreOrdersAwait: TBooleanField;
    adsCoreOrdersHOrderId: TLargeintField;
    adsCoreOrdersHClientId: TLargeintField;
    adsCoreOrdersHPriceCode: TLargeintField;
    adsCoreOrdersHRegionCode: TLargeintField;
    adsCoreOrdersHPriceName: TStringField;
    adsCoreOrdersHRegionName: TStringField;
    adsCorePriceRet: TCurrencyField;
    adsCoreSortOrder: TIntegerField;
    adsOrders: TMyQuery;
    adsOrdersFullCode: TLargeintField;
    adsOrdersCode: TStringField;
    adsOrdersCodeCR: TStringField;
    adsOrdersSynonymName: TStringField;
    adsOrdersSynonymFirm: TStringField;
    adsOrdersOrderCount: TIntegerField;
    adsOrdersPrice: TFloatField;
    adsOrdersOrderDate: TDateTimeField;
    adsOrdersPriceName: TStringField;
    adsOrdersRegionName: TStringField;
    adsOrdersAwait: TBooleanField;
    adsOrdersJunk: TBooleanField;
    adsOrdersShowFormSummary: TMyQuery;
    adsOrdersShowFormSummaryPRICEAVG: TFloatField;
    adsOrdersShowFormSummaryPRODUCTID: TLargeintField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
    procedure adsCoreOldBeforePost(DataSet: TDataSet);
    procedure adsCoreOldBeforeEdit(DataSet: TDataSet);
    procedure adsCoreOldAfterPost(DataSet: TDataSet);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreKeyPress(Sender: TObject; var Key: Char);
    procedure btnSelectPricesClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure miUnselecAllClick(Sender: TObject);
    procedure cbBaseOnlyClick(Sender: TObject);
    procedure dbgCoreDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure adsCoreOldSTORAGEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure actFlipCoreExecute(Sender: TObject);
  private
    { Private declarations }
    fr : TForceRus;
    UseExcess: Boolean;
    DeltaMode, Excess : Integer;
    slColors : TStringList;
    StartSQL : String;
    SelectedPrices : TStringList;
    BM : TBitmap;
    InternalSearchText : String;
    //Список сортировки 
    SortList : TStringList;
    procedure AddKeyToSearch(Key : Char);
    procedure SetClear;
    procedure ChangeSelected(ASelected : Boolean);
    procedure OnSPClick(Sender: TObject);
    procedure ccf(DataSet: TDataSet);
  public
    { Public declarations }
  end;

var
  SynonymSearchForm: TSynonymSearchForm;

procedure ShowSynonymSearch;


implementation

uses
  DModule, AProc, Main, SQLWaiting, AlphaUtils, pFIBProps, NamesForms, U_GroupUtils;

{$R *.dfm}

procedure ShowSynonymSearch;
begin
  MainForm.ShowChildForm(TSynonymSearchForm);
end;


procedure TSynonymSearchForm.FormCreate(Sender: TObject);
var
	Reg: TRegIniFile;
  I : Integer;
  sp : TSelectPrice;
  mi :TMenuItem;
begin
  SortList := nil;
  plOverCost.Hide();
  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreORDERCOUNT;
  fVolume := adsCoreREQUESTRATIO;
  fOrderCost := adsCoreORDERCOST;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMINORDERCOUNT;
  inherited;
  
  InternalSearchText := '';
  BM := TBitmap.Create;

  adsCore.OnCalcFields := ccf;
  StartSQL := adsCore.SQL.Text; 
  slColors := TStringList.Create;

  fr := TForceRus.Create;

  UseExcess := True;
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
        DeltaMode := DM.adtClients.FieldByName( 'DeltaMode').AsInteger;
	adsOrders.ParamByName( 'ClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').AsInteger;
	adsOrdersShowFormSummary.ParamByName( 'ClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').AsInteger;

	Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'TCoreForm', False)
    then
      dbgCore.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
  finally
  	Reg.Free;
  end;

  SelectedPrices := SynonymSelectedPrices;
  for I := 0 to SelectedPrices.Count-1 do begin
    sp := TSelectPrice(SelectedPrices.Objects[i]);
    mi := TMenuItem.Create(pmSelectedPrices);
    mi.Name := 'sl' + SelectedPrices[i];
    mi.Caption := sp.PriceName;
    mi.Checked := sp.Selected;
    mi.Tag := Integer(sp);
    mi.OnClick := OnSPClick;
    pmSelectedPrices.Items.Add(mi);
  end;

  ShowForm;
end;

procedure TSynonymSearchForm.FormDestroy(Sender: TObject);
var
	Reg: TRegIniFile;
begin
  slColors.Free;
  fr.Free;
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey('Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + 'TCoreForm', True);
    dbgCore.SaveColumnsLayout(Reg);
  finally
    Reg.Free;
  end;
  BM.Free;
end;

procedure TSynonymSearchForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	plOverCost.Hide;
	plOverCost.SendToBack;
end;

procedure TSynonymSearchForm.tmrSearchTimer(Sender: TObject);
var
  FilterSQL : String;
  TmpSortList : TStringList;
  I : Integer;
begin
  tmrSearch.Enabled := False;
  if Length(eSearch.Text) > 2 then begin
    InternalSearchText := LeftStr(eSearch.Text, 50);
    if adsCore.Active then
      adsCore.Close;
  	//adsOrdersShowFormSummary.DataSource := nil;
  	//adsOrders.DataSource := nil;
    //adsCore.Options := adsCore.Options - [poCacheCalcFields];
    adsCore.ParamByName('LikeParam').AsString := '%' + InternalSearchText + '%';
    adsCore.ParamByName('AClientID').AsInteger := DM.adtClients.FieldByName( 'ClientId').Value;
  	adsCore.ParamByName( 'TimeZoneBias').AsInteger := TimeZoneBias;
    FilterSQL := GetSelectedPricesSQL(SelectedPrices, 'PRD.');
    adsCore.SQL.Text := StartSQL;
    lFilter.Visible := Length(FilterSQL) > 0;
    if lFilter.Visible then
      adsCore.SQL.Text := adsCore.SQL.Text + 'and (' + FilterSQL + ')';
    if cbBaseOnly.Checked then
      adsCore.SQL.Text := adsCore.SQL.Text + ' and (PRD.Enabled = 1)';

    if adsCore.Active then
    begin
      adsCore.Close;
      adsCore.Open;
    end
    else
      adsCore.Open;
    //ShowSQLWaiting(adsCore);

    //TODO: Здесь надо очистить массив, чтобы не было утечки памяти
    TmpSortList := SortList;
    SortList := nil;
    if Assigned(TmpSortList) then begin
      for I := 0 to TmpSortList.Count-1 do
        TmpSortList.Objects[i].Free;
      TmpSortList.Free;
    end;

    adsCore.DisableControls;
    try
      TmpSortList := GetSortedGroupList(adsCore, False, DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean);
    finally
      adsCore.EnableControls;
    end;

    SortList := TmpSortList;

//    adsCore.DoSort(['SortOrder'], [True]);
    adsCore.IndexFieldNames := 'SortOrder';
    adsCore.First;

    //adsOrders.DataSource := dsCore;
  	//adsOrdersShowFormSummary.DataSource := dsCore;
    dbgCore.SetFocus;
    eSearch.Text := '';
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TSynonymSearchForm.ccf(DataSet: TDataSet);
begin
  try
    adsCorePriceRet.AsCurrency := DM.GetPriceRet(adsCoreCost.AsCurrency);
    if Assigned(SortList) then
      adsCoreSortOrder.AsInteger := SortList.IndexOf(adsCoreCOREID.AsString);
  except
  end;
end;

procedure TSynonymSearchForm.adsCoreOldBeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
	PriceAvg: Double;
  PanelCaption : String;
  PanelHeight : Integer;
begin
	try
		{ проверяем заказ на соответствие наличию товара на складе }
		Val( adsCoreQuantity.AsString,Quantity,E);
		if E<>0 then Quantity := 0;
		if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity) and
			( AProc.MessageBox( 'Заказ превышает остаток на складе. Продолжить?',
			MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) then adsCoreORDERCOUNT.AsInteger := Quantity;

    PanelCaption := '';
    
		{ проверяем на превышение цены }
		if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) then
		begin
			PriceAvg := adsOrdersShowFormSummaryPRICEAVG.AsCurrency;
			if ( PriceAvg > 0) and ( adsCoreCOST.AsCurrency>PriceAvg*( 1 + Excess / 100)) then
			begin
        PanelCaption := 'Превышение средней цены!';
			end;
		end;

    if (adsCoreJUNK.AsBoolean) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + 'Вы заказали некондиционный препарат.'
      else
        PanelCaption := 'Вы заказали некондиционный препарат.';

    if (adsCoreORDERCOUNT.AsInteger > WarningOrderCount) then
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

procedure TSynonymSearchForm.adsCoreOldBeforeEdit(DataSet: TDataSet);
begin
	if adsCoreFirmCode.AsInteger = RegisterId then Abort;
end;

procedure TSynonymSearchForm.adsCoreOldAfterPost(DataSet: TDataSet);
begin
	MainForm.SetOrdersInfo;
end;

procedure TSynonymSearchForm.dbgCoreCanInput(Sender: TObject;
  Value: Integer; var CanInput: Boolean);
begin
	CanInput := (not adsCore.IsEmpty) and ( adsCoreSynonymCode.AsInteger >= 0) and
		(( adsCoreRegionCode.AsInteger and DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
			adsCoreRegionCode.AsInteger);
end;

procedure TSynonymSearchForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if adsCore.Active then begin
    if adsCoreSynonymCode.AsInteger < 0 then
    begin
      Background := $00fff1d8;
                  AFont.Style := [fsBold];
    end
    else
    if adsCoreFirmCode.AsInteger = RegisterId then
    begin
      //если это реестр, изменяем цвета
      if ( Column.Field = adsCoreSYNONYMNAME) or ( Column.Field = adsCoreSYNONYMFIRM) or
        ( Column.Field = adsCoreCOST)or
        ( Column.Field = adsCorePriceRet) then Background := REG_CLR;
          end
    else
    begin
      if (not adsCore.IsEmpty) and Assigned(SortList)
          and (Column.Field <> adsCoreOrderCount) and (Column.Field <> adsCoreSumOrder)
      then
        Background := SortElem(SortList.Objects[ SortList.IndexOf(adsCoreCOREID.AsString)]).SelectedColor;

      if adsCoreVITALLYIMPORTANT.AsBoolean then
        AFont.Color := VITALLYIMPORTANT_CLR;

      if not adsCorePriceEnabled.AsBoolean then
      begin
        //если фирма недоступна, изменяем цвет
        if ( Column.Field = adsCoreSYNONYMNAME) or ( Column.Field = adsCoreSYNONYMFIRM)
          then Background := clBtnFace;
      end;

      //если уцененный товар, изменяем цвет
      if adsCoreJunk.AsBoolean and (( Column.Field = adsCorePERIOD) or ( Column.Field = adsCoreCOST)) then
        Background := JUNK_CLR;
      //ожидаемый товар выделяем зеленым
      if adsCoreAwait.AsBoolean and ( Column.Field = adsCoreSYNONYMNAME) then
        Background := AWAIT_CLR;
    end;
  end;
end;

procedure TSynonymSearchForm.eSearchKeyDown(Sender: TObject; var Key: Word;
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

procedure TSynonymSearchForm.eSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //Если мы что-то нажали в элементе, то должны на это отреагировать
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

procedure TSynonymSearchForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TSynonymSearchForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TSynonymSearchForm.SetClear;
begin
  tmrSearch.Enabled := False;
  eSearch.Text := '';
  InternalSearchText := '';
  if adsCore.Active then
    adsCore.Close;
end;

procedure TSynonymSearchForm.dbgCoreKeyPress(Sender: TObject;
  var Key: Char);
begin
	if ( Key > #32) and not ( Key in
		[ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
	begin
    AddKeyToSearch(Key);
  end;
end;

procedure TSynonymSearchForm.btnSelectPricesClick(Sender: TObject);
begin
  pmSelectedPrices.Popup(btnSelectPrices.ClientOrigin.X, btnSelectPrices.ClientOrigin.Y + btnSelectPrices.Height);
end;

procedure TSynonymSearchForm.ChangeSelected(ASelected: Boolean);
var
  I : Integer;
begin
  tmrSearch.Enabled := False;
  for I := 3 to pmSelectedPrices.Items.Count-1 do begin
    pmSelectedPrices.Items.Items[i].Checked := ASelected;
    TSelectPrice(TMenuItem(pmSelectedPrices.Items.Items[i]).Tag).Selected := ASelected;
  end;
  pmSelectedPrices.Popup(pmSelectedPrices.PopupPoint.X, pmSelectedPrices.PopupPoint.Y);
  tmrSearch.Enabled := True;
end;

procedure TSynonymSearchForm.miSelectAllClick(Sender: TObject);
begin
  ChangeSelected(True);
end;

procedure TSynonymSearchForm.miUnselecAllClick(Sender: TObject);
begin
  ChangeSelected(False);
end;

procedure TSynonymSearchForm.OnSPClick(Sender: TObject);
var
  sp : TSelectPrice;
begin
  tmrSearch.Enabled := False;
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  sp := TSelectPrice(TMenuItem(Sender).Tag);
  sp.Selected := TMenuItem(Sender).Checked;
  pmSelectedPrices.Popup(pmSelectedPrices.PopupPoint.X, pmSelectedPrices.PopupPoint.Y);
  tmrSearch.Enabled := True;
end;

procedure TSynonymSearchForm.cbBaseOnlyClick(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  tmrSearch.Enabled := True;
end;

procedure TSynonymSearchForm.dbgCoreDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if Column.Field = adsCoreSYNONYMNAME then
    ProduceAlphaBlendRect(InternalSearchText, Column.Field.DisplayText, dbgCore.Canvas, Rect, BM);
end;

procedure TSynonymSearchForm.adsCoreOldSTORAGEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Iif(Sender.AsBoolean, '+', '');
end;

procedure TSynonymSearchForm.actFlipCoreExecute(Sender: TObject);
var
	FullCode, ShortCode: integer;
  CoreId : Int64;
begin
	if MainForm.ActiveChild <> Self then exit;
  if adsCore.IsEmpty then Exit;

	FullCode := adsCoreFullCode.AsInteger;
	ShortCode := adsCoreShortCode.AsInteger;

  CoreId := adsCoreCOREID.AsLargeInt;

  FlipToCode(FullCode, ShortCode, CoreId);
end;

end.
