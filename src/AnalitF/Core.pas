unit Core;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, DBGrids, ComCtrls, Db, StrUtils,
  StdCtrls, Buttons, DBCtrls, FR_Class, FR_DSet, FR_DBSet,
  Child, RXDBCtrl, Variants, Math, DBGridEh,
  ToughDBGrid, Registry, OleCtrls, SHDocVw, ActnList, FIBDataSet,
  pFIBDataSet, pFIBDatabase, pFIBQuery, FIBDatabase, FIBSQLMonitor, Spin,
  GridsEh, pFIBProps, U_frameLegend, MemDS, DBAccess, MyAccess;

const
	ALL_REGIONS	= 'Все регионы';

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
    adsCoreOld: TpFIBDataSet;
    adsCoreOldCOREID: TFIBBCDField;
    adsCoreOldPRICECODE: TFIBBCDField;
    adsCoreOldREGIONCODE: TFIBBCDField;
    adsCoreOldFULLCODE: TFIBBCDField;
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
    adsCoreOldSYNONYMNAME: TFIBStringField;
    adsCoreOldSYNONYMFIRM: TFIBStringField;
    adsCoreOldDATEPRICE: TFIBDateTimeField;
    adsCoreOldPRICENAME: TFIBStringField;
    adsCoreOldFIRMCODE: TFIBBCDField;
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
    adsCoreOldORDERSHORDERID: TFIBBCDField;
    adsCoreOldORDERSHCLIENTID: TFIBBCDField;
    adsCoreOldORDERSHPRICECODE: TFIBBCDField;
    adsCoreOldORDERSHREGIONCODE: TFIBBCDField;
    adsCoreOldORDERSHPRICENAME: TFIBStringField;
    adsCoreOldORDERSHREGIONNAME: TFIBStringField;
    adsCoreOldSumOrder: TCurrencyField;
    adsCoreOldPriceRet: TCurrencyField;
    adsCoreOldPriceDelta: TFloatField;
    adsRegionsOld: TpFIBDataSet;
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
    adsOrdersShowFormSummaryOld: TpFIBDataSet;
    adsFirmsInfoOld: TpFIBDataSet;
    adsCoreOldSTORAGE: TFIBBooleanField;
    adsCoreOldAWAIT: TFIBBooleanField;
    adsCoreOldJUNK: TFIBBooleanField;
    adsCoreOldPRICEENABLED: TFIBBooleanField;
    adsCoreOldORDERSJUNK: TFIBBooleanField;
    adsCoreOldORDERSAWAIT: TFIBBooleanField;
    adsCoreOldCryptBASECOST: TCurrencyField;
    adsCoreOldQUANTITY: TFIBStringField;
    adsOrdersOldCODE: TFIBStringField;
    adsOrdersOldCODECR: TFIBStringField;
    adsCoreOldBASECOST: TFIBStringField;
    adsCoreOldORDERSPRICE: TFIBStringField;
    adsOrdersOldPRICE: TFIBStringField;
    adsCoreOldDOC: TFIBStringField;
    adsCoreOldREGISTRYCOST: TFIBFloatField;
    adsCoreOldVITALLYIMPORTANT: TFIBIntegerField;
    adsCoreOldREQUESTRATIO: TFIBIntegerField;
    adsOrdersOldSENDPRICE: TFIBBCDField;
    pRight: TPanel;
    gbRetUpCost: TGroupBox;
    seRetUpCost: TSpinEdit;
    eRetUpCost: TEdit;
    gbSum: TGroupBox;
    lCurrentSumma: TLabel;
    adsCoreOldORDERCOST: TFIBBCDField;
    adsCoreOldMINORDERCOUNT: TFIBIntegerField;
    adsCoreOldPRODUCTID: TFIBBCDField;
    adsOrdersShowFormSummaryOldPRICEAVG: TFIBBCDField;
    lWarning: TLabel;
    adsCoreOldSortOrder: TIntegerField;
    btnGroupUngroup: TButton;
    frameLegeng: TframeLegeng;
    adsCore: TMyQuery;
    adsRegions: TMyQuery;
    adsOrders: TMyQuery;
    adsOrdersShowFormSummary: TMyQuery;
    adsFirmsInfo: TMyQuery;
    adsOrdersFullCode: TLargeintField;
    adsOrdersCode: TStringField;
    adsOrdersCodeCR: TStringField;
    adsOrdersSynonymName: TStringField;
    adsOrdersSynonymFirm: TStringField;
    adsOrdersOrderCount: TIntegerField;
    adsOrdersPrice: TStringField;
    adsOrdersOrderDate: TDateTimeField;
    adsOrdersPriceName: TStringField;
    adsOrdersRegionName: TStringField;
    adsOrdersAwait: TIntegerField;
    adsOrdersJunk: TIntegerField;
    adsOrderssendprice: TFloatField;
    adsCoreCoreId: TLargeintField;
    adsCoreClientid: TLargeintField;
    adsCorePriceCode: TLargeintField;
    adsCoreRegionCode: TLargeintField;
    adsCoreproductid: TLargeintField;
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
    adsCoreordercost: TFloatField;
    adsCoreminordercount: TIntegerField;
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
    adsCorePriceDelta: TCurrencyField;
    adsCoreSortOrder: TIntegerField;
    adsCoreEtalon: TMyQuery;
    adsCorefullcode: TLargeintField;
    adsOrdersShowFormSummaryPRICEAVG: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure adsCore2BeforePost(DataSet: TDataSet);
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
    procedure adsCoreOldSTORAGEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure seRetUpCostChange(Sender: TObject);
    procedure btnGroupUngroupClick(Sender: TObject);
  private
    RegionCodeStr: string;
    RecInfos: array of Double;
    UseExcess, CurrentUseForms: Boolean;
    DeltaMode, Excess, ClientId: Integer;
    //Список сортировки
    SortList : TStringList;
    CoreGroupByProducts : Boolean;

    procedure ccf(DataSet: TDataSet);
    procedure RefreshCurrentSumma;
    procedure GroupedCore;
    procedure UpdatePriceDelta;
  public
    procedure ShowForm( AParentCode: Integer; AName, AForm: string; UseForms, NewSearch: Boolean); reintroduce;
    procedure Print( APreview: boolean = False); override;
    procedure ShowOrdersH;
  end;

var
  CoreForm: TCoreForm;

implementation

uses Main, AProc, DModule, NamesForms, Constant, OrdersH, DBProc, CoreFirm,
  Prices, U_GroupUtils;

var
  UserSetRetUpCost : Boolean;
  RetUpCostValue   : Integer;


{$R *.DFM}

procedure TCoreForm.FormCreate(Sender: TObject);
var
	Reg: TRegIniFile;
begin
  SortList := nil;
  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreORDERCOUNT;
  fVolume := adsCoreREQUESTRATIO;
  fOrderCost := adsCoreORDERCOST;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMINORDERCOUNT;
	inherited;
	PrintEnabled := (DM.SaveGridMask and PrintCombinedPrice) > 0;
  NeedFirstOnDataSet := False;
  adsCore.OnCalcFields := ccf;
  UseExcess := True;
  CoreGroupByProducts := DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean;
  if CoreGroupByProducts then
    btnGroupUngroup.Caption := 'Разгруппировать'
  else
    btnGroupUngroup.Caption := 'Группировать';
	Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
        DeltaMode := DM.adtClients.FieldByName( 'DeltaMode').AsInteger;
	RegionCodeStr := DM.adtClients.FieldByName( 'RegionCode').AsString;

	adsOrders.ParamByName( 'ClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').AsInteger;
	adsOrdersShowFormSummary.ParamByName( 'ClientId').Value :=
		DM.adtClients.FieldByName( 'ClientId').AsInteger;

	Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, False)
    then
      dbgCore.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
  finally
  	Reg.Free;
  end;
end;

procedure TCoreForm.FormDestroy(Sender: TObject);
var
	Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey('Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, True);
    dbgCore.SaveColumnsLayout(Reg);
  finally
    Reg.Free;
  end;
end;

procedure TCoreForm.ShowForm(AParentCode: Integer; AName, AForm: string; UseForms, NewSearch: Boolean);
var
	I: Integer;
	OrdersH: TOrdersHForm;
  TmpSortList : TStringList;
begin
  plOverCost.Hide();
  //Если в прошлый раз пользователь изменил наценку, то выставляем ее
  if UserSetRetUpCost then
    seRetUpCost.Value := RetUpCostValue;
	OrdersH := TOrdersHForm( FindChildControlByClass( MainForm, TOrdersHForm));
	if OrdersH <> nil then OrdersH.Free;
	SetLength( RecInfos, 0);

	adsOrders.MasterSource := nil;
	adsOrdersShowFormSummary.MasterSource := nil;
	ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;

  TmpSortList := SortList;
  SortList := nil;
  
	{ готовим запрос в зависимости от того, показываем по наименованию или форме выпуска }
	with adsCore do
        begin
		if not Active or ( CurrentUseForms <> UseForms) then
		begin
			CurrentUseForms := UseForms;
			Close;
			if UseForms then
        SQL.Text := StringReplace(adsCoreEtalon.SQL.Text, '(Catalogs.ShortCode =', '(Catalogs.FullCode =', [])
      else
        SQL.Text := adsCoreEtalon.SQL.Text;
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
			if Active then Close;
      //adsCore.Options := adsCore.Options - [poCacheCalcFields];
      Open;
      //FetchAll;

		finally
			Screen.Cursor := crDefault;
		end;
  end;

  if Assigned(TmpSortList) then begin
    for I := 0 to TmpSortList.Count-1 do
      TmpSortList.Objects[i].Free;
    TmpSortList.Free;
  end;

  adsCore.DisableControls;
  try
    TmpSortList := GetSortedGroupList(adsCore, True, CoreGroupByProducts);
  finally
    adsCore.EnableControls;
  end;

  SortList := TmpSortList;
  UpdatePriceDelta;

  //Второе открытие нужно, чтобы отобразилась сортировка, т.к. она не отображается
  adsCore.Close;
  adsCore.Open;

  //adsCore.DoSort(['SortOrder'], [True]);
  adsCore.IndexFieldNames := 'SortOrder';
  adsCore.First;

	{ проверка непустоты }
	if adsCore.RecordCount = 0 then
	begin
		AProc.MessageBox( 'Нет предложений', MB_ICONWARNING);
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

	if not adsCore.Locate( 'PriceEnabled', 'True', []) then
		adsCore.Locate( 'PriceEnabled', 'False', []);
	adsOrders.MasterSource := dsCore;
	adsOrdersShowFormSummary.MasterSource := dsCore;
//  adsOrders.Open;
//	adsOrdersShowFormSummary.Open;
	lblName.Caption := AName + ' ' + AForm;

	adsFirmsInfo.Open;

	inherited ShowForm; // д.б. перед MainForm.actPrint.OnExecute
	//готовим печать
	frVariables[ 'UseForms'] := UseForms;
	frVariables[ 'NewSearch'] := NewSearch;
	frVariables[ 'CatalogName'] := AName;
	frVariables[ 'CatalogForm'] := AForm;
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

procedure TCoreForm.ccf(DataSet: TDataSet);
var
  elemIndex : Integer;
begin
  try
    if Assigned(SortList) then begin
      elemIndex := SortList.IndexOf(adsCoreCOREID.AsString);
      adsCoreSortOrder.AsInteger := elemIndex;
      adsCorePriceDelta.AsCurrency := SortElem(SortList.Objects[elemIndex]).PriceDelta;
    end;
    adsCorePriceRet.AsCurrency := DM.GetPriceRet(adsCoreCOST.AsCurrency);
  except
  end;
end;

procedure TCoreForm.adsCore2BeforePost(DataSet: TDataSet);
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

    if (adsCoreJUNK.Value) then
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

procedure TCoreForm.Print( APreview: boolean = False);
begin
	DM.ShowFastReport( 'Core.frf', adsCore, APreview);
end;

procedure TCoreForm.adsCore2BeforeEdit(DataSet: TDataSet);
begin
	if adsCoreFirmCode.AsInteger = RegisterId then Abort;
end;

procedure TCoreForm.dbgCoreCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
	CanInput := ( adsCoreSynonymCode.AsInteger >= 0) and
		(( adsCoreRegionCode.AsInteger and DM.adtClients.FieldByName( 'ReqMask').AsInteger) =
			adsCoreRegionCode.AsInteger);
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
      if TNamesFormsForm( Self.PrevForm).actNewSearch.Checked then
         TNamesFormsForm( Self.PrevForm).dbgCatalog.SetFocus
      else
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
      if TNamesFormsForm( Self.PrevForm).actNewSearch.Checked then begin
        TNamesFormsForm( Self.PrevForm).dbgCatalog.SetFocus;
        TNamesFormsForm( Self.PrevForm).eSearch.Text := '';
      end
      else
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
		if ( Column.Field = adsCoreSYNONYMNAME) or ( Column.Field = adsCoreSYNONYMFIRM)
			 or ( Column.Field = adsCoreCOST)
       or ( Column.Field = adsCorePriceRet)
      then Background := REG_CLR;
        end
	else
	begin
    if (not adsCore.IsEmpty) and CoreGroupByProducts and (Assigned(SortList))
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
		if adsCoreJunk.AsBoolean and (( Column.Field = adsCorePERIOD) {or ( Column.Field = adsCoreCryptBASECOST)})
    then
			Background := JUNK_CLR;
		//ожидаемый товар выделяем зеленым
		if adsCoreAwait.AsBoolean and ( Column.Field = adsCoreSYNONYMNAME) then
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
    OrdersH.adsOrdersHForm.Close;
    OrdersH.adsOrdersHForm.Open;
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
	MainForm.SetOrdersInfo;
  RefreshCurrentSumma;
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
	if adsOrdersJunk.AsBoolean and ( Column.Field = adsOrdersPRICE) then
		Background := JUNK_CLR;
	//ожидаемый товар выделяем зеленым
	if adsOrdersAwait.AsBoolean and ( Column.Field = adsOrdersPRICE) then
		Background := AWAIT_CLR;
end;

procedure TCoreForm.actFlipCoreExecute(Sender: TObject);
var
	PriceCode, RegionCode: integer;
  CoreId : Int64;
  PriceName, RegionName : String;
begin
	if MainFOrm.ActiveChild <> Self then exit;

	PriceCode := adsCorePriceCode.AsInteger;
	RegionCode := adsCoreRegionCode.AsInteger;
  PriceName := adsCorePRICENAME.AsString;
  RegionName := adsCoreREGIONNAME.AsString;
  CoreId := adsCoreCOREID.AsLargeInt;
	ShowPrices;

	with TPricesForm( MainForm.ActiveChild) do
	begin
		adsPrices.Locate( 'PriceCode;RegionCode', VarArrayOf([ PriceCode, RegionCode]), []);
		CoreFirmForm.ShowForm( PriceCode, RegionCode, PriceName, RegionName, actOnlyLeaders.Checked);
    CoreFirmForm.adsCore.Locate('CoreId', CoreId, []);
	end;
end;

procedure TCoreForm.adsCore2AfterScroll(DataSet: TDataSet);
//var
//  C : Integer;
begin
  if not adsCore.IsEmpty and (adsCoreSynonymCode.AsInteger >= 0) then begin
    //Если пользователь не изменял сам наценку, то применяем текущую наценку
    if not UserSetRetUpCost then
      seRetUpCost.Value := DM.GetRetUpCost(adsCoreCOST.AsCurrency);
    seRetUpCostChange(seRetUpCost);
  end;
  RefreshCurrentSumma;
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

procedure TCoreForm.adsCoreOldSTORAGEGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  text := Iif(Sender.AsBoolean, '+', '');
end;

procedure TCoreForm.seRetUpCostChange(Sender: TObject);
begin
  UserSetRetUpCost := True;
  RetUpCostValue   := seRetUpCost.Value;
  if not adsCore.IsEmpty and (adsCoreSynonymCode.AsInteger >= 0) then
    eRetUpCost.Text := CurrToStrF((1 + seRetUpCost.Value/100) * adsCoreCOST.AsCurrency, ffCurrency, 2)
  else
    eRetUpCost.Text := '';
end;

procedure TCoreForm.RefreshCurrentSumma;
var
  Summ : Currency;
begin
  if not adsCore.IsEmpty then begin
    Summ := DM.FindOrderInfo(adsCorePRICECODE.AsInteger, adsCoreREGIONCODE.AsInteger);
    if Summ > 0 then
    begin
      lCurrentSumma.Caption := CurrToStr(Summ);
      if not adsFirmsInfo.IsEmpty and not adsFirmsInfo.FieldByName('MinReq').IsNull
        and (adsFirmsInfo.FieldByName('MinReq').AsCurrency > Summ)
      then
        lCurrentSumma.Font.Color := clRed
      else
        lCurrentSumma.Font.Color := clGreen;
    end
    else
      lCurrentSumma.Caption := '';
  end
  else begin
    lCurrentSumma.Caption := '';
  end;
end;

procedure TCoreForm.btnGroupUngroupClick(Sender: TObject);
begin
  CoreGroupByProducts := not CoreGroupByProducts;
  GroupedCore;
  dbgCore.SetFocus;
end;

procedure TCoreForm.GroupedCore;
var
  TmpSortList : TStringList;
  I : Integer;
begin
  TmpSortList := SortList;
  SortList := nil;

  if CoreGroupByProducts then
    btnGroupUngroup.Caption := 'Разгруппировать'
  else
    btnGroupUngroup.Caption := 'Группировать';

  if Assigned(TmpSortList) then begin
    for I := 0 to TmpSortList.Count-1 do
      TmpSortList.Objects[i].Free;
    TmpSortList.Free;
  end;

  adsCore.DisableControls;
  try
    DBProc.SetFilter( adsCore, '');
    TmpSortList := GetSortedGroupList(adsCore, True, CoreGroupByProducts);
  finally
    adsCore.EnableControls;
  end;

  SortList := TmpSortList;
  UpdatePriceDelta;

  //Второе открытие нужно, чтобы отобразилась сортировка, т.к. она не отображается
  adsCore.Close;
  adsCore.Open;

  cbFilterSelect(nil);

  adsCore.IndexFieldNames := 'SortOrder';
  adsCore.First;

	if not adsCore.Locate( 'PriceEnabled', 'True', []) then
		adsCore.Locate( 'PriceEnabled', 'False', []);
end;

procedure TCoreForm.UpdatePriceDelta;
var
	FirstPrice, PrevPrice, D: Currency;
  I : Integer;
  elem : SortElem;
begin
	FirstPrice := 0;
	PrevPrice := 0;
  for I := 0 to SortList.Count-1 do begin
    elem := SortElem(SortList.Objects[i]);
    //попали на заголовок формы выпуска
    if elem.Cost < 0 then begin
      PrevPrice := 0;
      FirstPrice := 0;
    end;
		//разница в цене от другого поставщика PRICE_DELTA
    case DeltaMode of
      1, 2:
      D := FirstPrice;
    else
      D := PrevPrice;
    end;
    if ( D = 0) or ( elem.Cost <= 0) then
      elem.PriceDelta := 0
    else
      elem.PriceDelta := RoundTo(( elem.Cost - D)/D*100,-1);
    if elem.Cost >= 0 then
    begin
      if elem.Cost > 0 then
        PrevPrice := elem.Cost;
      if ( FirstPrice=0) and (( DeltaMode <> 2) or elem.IsBaseCategory) then
        FirstPrice := elem.Cost;
    end;
  end;
end;

initialization
  UserSetRetUpCost := False;
end.
