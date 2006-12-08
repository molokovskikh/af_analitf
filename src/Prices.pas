unit Prices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, StdCtrls, DBCtrls, Grids, DBGrids, RXDBCtrl,
  ActnList, DB, Buttons, ComCtrls, ExtCtrls, DBGridEh, ToughDBGrid,
  Registry, FIBDataSet, pFIBDataSet, FIBQuery, Menus, GridsEh;

const
	PricesSql =	'SELECT * FROM PRICESSHOW(:ACLIENTID, :TIMEZONEBIAS) ORDER BY ';

type
  TPricesForm = class(TChildForm)
    dbtFullName: TDBText;
    dbtPhones: TDBText;
    dbtAdminMail: TDBText;
    Label2: TLabel;
    Label1: TLabel;
    cbOnlyLeaders: TCheckBox;
    ActionList: TActionList;
    actOnlyLeaders: TAction;
    dsPrices: TDataSource;
    dbtMinOrder: TDBText;
    actCurrentOrders: TAction;
    Panel1: TPanel;
    Panel2: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    dbgPrices: TToughDBGrid;
    DBMemo2: TDBMemo;
    Bevel2: TBevel;
    Label6: TLabel;
    DBMemo3: TDBMemo;
    Bevel3: TBevel;
    Panel3: TPanel;
    lblPriceCount: TLabel;
    adsPrices: TpFIBDataSet;
    adsPricesPRICECODE: TFIBBCDField;
    adsPricesPRICENAME: TFIBStringField;
    adsPricesDATEPRICE: TFIBDateTimeField;
    adsPricesUPCOST: TFIBBCDField;
    adsPricesMINREQ: TFIBIntegerField;
    adsPricesENABLED: TFIBIntegerField;
    adsPricesPRICEINFO: TFIBBlobField;
    adsPricesFIRMCODE: TFIBBCDField;
    adsPricesFULLNAME: TFIBStringField;
    adsPricesSTORAGE: TFIBIntegerField;
    adsPricesADMINMAIL: TFIBStringField;
    adsPricesSUPPORTPHONE: TFIBStringField;
    adsPricesCONTACTINFO: TFIBBlobField;
    adsPricesOPERATIVEINFO: TFIBBlobField;
    adsPricesREGIONCODE: TFIBBCDField;
    adsPricesREGIONNAME: TFIBStringField;
    adsPricesPOSITIONS: TFIBIntegerField;
    adsPricesPRICESIZE: TFIBIntegerField;
    adsClientsData: TpFIBDataSet;
    adsPricesSumOrder1: TCurrencyField;
    adsPricesINJOB: TFIBBooleanField;
    adsPricesALLOWCOSTCORR: TFIBIntegerField;
    tmStopEdit: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actOnlyLeadersExecute(Sender: TObject);
    procedure dbtAdminMailClick(Sender: TObject);
    procedure dbgPricesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgPricesGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgPricesDblClick(Sender: TObject);
    procedure adsPrices2AfterScroll(DataSet: TDataSet);
    procedure adsPrices2AfterOpen(DataSet: TDataSet);
    procedure adsPricesSTORAGEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure dbgPricesSortMarkingChanged(Sender: TObject);
    procedure dbgPricesExit(Sender: TObject);
    procedure adsPricesBeforePost(DataSet: TDataSet);
    procedure dbgPricesColumns4GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure adsPricesINJOBChange(Sender: TField);
    procedure adsPricesUPCOSTChange(Sender: TField);
    procedure tmStopEditTimer(Sender: TObject);
    procedure adsPricesAfterEdit(DataSet: TDataSet);
    procedure adsPricesCalcFields(DataSet: TDataSet);
  private
    procedure GetLastPrice;
    procedure SetLastPrice;
    procedure ProcessPrice;
  public
    procedure ShowForm; override;
  end;

var
  PricesForm: TPricesForm;

procedure ShowPrices;

implementation

uses Main, DModule, AProc, DBProc, CoreFirm, StrUtils;

{$R *.dfm}

var
	LastPriceCode, LastRegionCode: Integer;

procedure ShowPrices;
begin
	PricesForm := TPricesForm( MainForm.ShowChildForm( TPricesForm));
	PricesForm.ShowForm;
end;

procedure TPricesForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;
  NeedFirstOnDataSet := False;
	CoreFirmForm := TCoreFirmForm.Create( Application);
	actOnlyLeaders.Checked := DM.adtClients.FieldByName( 'OnlyLeaders').AsBoolean;
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\'
		+ Self.ClassName, False) then dbgPrices.LoadFromRegistry( Reg);
  if dbgPrices.SortMarkedColumns.Count = 0 then
    dbgPrices.FieldColumns['PRICENAME'].Title.SortMarker := smUpEh;
	Reg.Free;
end;

procedure TPricesForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;
  SoftPost(adsPrices);
	if not DM.adtClients.IsEmpty then
	begin
		GetLastPrice;
	end;
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\'
		+ Self.ClassName, True);
	dbgPrices.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TPricesForm.ShowForm;
begin
  //открываем список фирм
  with adsPrices do begin
    ParamByName('AClientId').Value:=DM.adtClients.FieldByName('ClientId').Value;
    ParamByName('TimeZoneBias').Value:=TimeZoneBias;
    Screen.Cursor:=crHourglass;
    try
      if Active then begin
        GetLastPrice;
        CloseOpen(True);
      end
      else
        Open;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
  //Здесь производится сортировка датасета
  inherited;
  //После этого мы выставляем позицию на последний используемый прайс
  SetLastPrice;
end;

procedure TPricesForm.GetLastPrice;
begin
  LastPriceCode := adsPricesPriceCode.AsInteger;
  LastRegionCode := adsPricesRegionCode.AsInteger;
end;

procedure TPricesForm.SetLastPrice;
begin
	if not adsPrices.IsEmpty then
    //Если был первый запуск, то устанавливаем в начало списка
    if LastPriceCode = -1 then
      adsPrices.First
    else
  		adsPrices.Locate( 'PriceCode;RegionCode',
        VarArrayOf([ LastPriceCode, LastRegionCode]),[]);
end;

procedure TPricesForm.actOnlyLeadersExecute(Sender: TObject);
begin
	actOnlyLeaders.Checked:=not actOnlyLeaders.Checked;
  DM.adtClients.Edit;
  DM.adtClients.FieldByName( 'OnlyLeaders').AsBoolean := actOnlyLeaders.Checked;
  DM.adtClients.Post;
	dbgPrices.SetFocus;
end;

procedure TPricesForm.dbtAdminMailClick(Sender: TObject);
begin
	MailTo( dbtAdminMail.Field.AsString, '');
end;

procedure TPricesForm.dbgPricesDblClick(Sender: TObject);
var
  C : GridsEh.TGridCoord;
  P : TPoint;
begin
	inherited;
  p := dbgPrices.ScreenToClient(Mouse.CursorPos);
  C := dbgPrices.MouseCoord(p.X, p.Y);
  if C.Y > 0 then begin
    ProcessPrice;
  end;
end;

procedure TPricesForm.dbgPricesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
	if Key = VK_RETURN then begin
    if (adsPrices.State in [dsEdit, dsInsert]) and (dbgPrices.SelectedField = adsPricesUPCOST) then begin
      tmStopEdit.Enabled := False;
      adsPrices.Post;
      AProc.MessageBox('Изменение настроек прайс-листов будет применено при следующем обновлении.', MB_ICONWARNING);
    end
    else
      ProcessPrice;
  end
  else
    if dbgPrices.EditorMode then begin
      tmStopEdit.Enabled := False;
      tmStopEdit.Interval := 3000;
      tmStopEdit.Enabled := True;
    end;
end;

procedure TPricesForm.dbgPricesGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	inherited;
	if not adsPricesEnabled.AsBoolean and ( Column.Field = adsPricesPriceName) then
		BackGround := clBtnFace;
	if adsPricesPositions.AsInteger > 0 then AFont.Style := [fsBold];
end;

procedure TPricesForm.adsPrices2AfterScroll(DataSet: TDataSet);
begin
	inherited;
	if DBMemo2.Lines.Count > 8 then DBMemo2.ScrollBars := ssVertical
		else DBMemo2.ScrollBars := ssNone;
	if DBMemo3.Lines.Count > 8 then DBMemo3.ScrollBars := ssVertical
		else DBMemo3.ScrollBars := ssNone;
end;

procedure TPricesForm.adsPrices2AfterOpen(DataSet: TDataSet);
begin
	lblPriceCount.Caption := 'Всего прайс-листов : ' + IntToStr( adsPrices.RecordCountFromSrv);
end;

procedure TPricesForm.adsPricesSTORAGEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  text := Iif(Sender.AsBoolean, '+', '');
end;

procedure TPricesForm.ProcessPrice;
begin
  SoftPost(adsPrices);
	if adsPricesFirmCode.AsInteger=RegisterId then
    //MainForm.actRegistry.Execute
  else
    if not adsPricesPRICECODE.IsNull and adsPricesINJOB.Value then
      CoreFirmForm.ShowForm(
        adsPricesPRICECODE.AsInteger,
	     	adsPricesREGIONCODE.AsInteger,
        adsPricesPRICENAME.AsString,
        adsPricesREGIONNAME.AsString,
        actOnlyLeaders.Checked);
end;

procedure TPricesForm.dbgPricesSortMarkingChanged(Sender: TObject);
begin
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TPricesForm.dbgPricesExit(Sender: TObject);
begin
  SoftPost(adsPrices);
end;

procedure TPricesForm.adsPricesBeforePost(DataSet: TDataSet);
begin
  inherited;
  //TODO: ___ Переделать на Value после перехода на FIB 6.4 (E5912)
  if adsPricesALLOWCOSTCORR.AsInteger = 0 then
    adsPricesUPCOST.AsCurrency := adsPricesUPCOST.OldValue;
end;

procedure TPricesForm.dbgPricesColumns4GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if not adsPricesALLOWCOSTCORR.AsBoolean then begin
    Params.Background := clBtnFace;
    Params.ReadOnly := True;
  end;
end;

procedure TPricesForm.adsPricesINJOBChange(Sender: TField);
begin
  tmStopEdit.Enabled := False;
  tmStopEdit.Interval := 500;
  tmStopEdit.Enabled := True;
end;

procedure TPricesForm.adsPricesUPCOSTChange(Sender: TField);
begin
//  AProc.MessageBox('Изменение настроек прайс-листов будет применено при следующем обновлении.', MB_ICONWARNING);
  tmStopEdit.Enabled := False;
  tmStopEdit.Interval := 500;
  tmStopEdit.Enabled := True;
end;

procedure TPricesForm.tmStopEditTimer(Sender: TObject);
begin
  tmStopEdit.Enabled := False;
  if adsPrices.State in [dsEdit, dsInsert] then
    AProc.MessageBox('Изменение настроек прайс-листов будет применено при следующем обновлении.', MB_ICONWARNING);
  if dbgPrices.EditorMode then
    dbgPrices.EditorMode := False;
  SoftPost(adsPrices);
end;

procedure TPricesForm.adsPricesAfterEdit(DataSet: TDataSet);
begin
//  tmStopEdit.Enabled := False;
//  tmStopEdit.Enabled := True;
end;

procedure TPricesForm.adsPricesCalcFields(DataSet: TDataSet);
begin
  if adsPricesPOSITIONS.AsInteger > 0 then
    adsPricesSumOrder1.AsCurrency := DM.FindOrderInfo(adsPricesPRICECODE.AsInteger, adsPricesREGIONCODE.AsInteger).Summ
  else
    adsPricesSumOrder1.AsCurrency := 0;
end;

initialization
  LastPriceCode := -1;
  LastRegionCode := -1;
end.
