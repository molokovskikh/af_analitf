unit Prices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, StdCtrls, DBCtrls, Grids, DBGrids, RXDBCtrl,
  ActnList, DB, Buttons, ComCtrls, ExtCtrls, DBGridEh, ToughDBGrid,
  Registry, FIBDataSet, pFIBDataSet, FIBQuery, Menus, GridsEh, MemDS,
  DBAccess, MyAccess;

type
  TPricesForm = class(TChildForm)
    dbtFullName: TDBText;
    dbtPhones: TDBText;
    dbtManagerMail: TDBText;
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
    adsPricesOld: TpFIBDataSet;
    adsPricesOldPRICECODE: TFIBBCDField;
    adsPricesOldPRICENAME: TFIBStringField;
    adsPricesOldDATEPRICE: TFIBDateTimeField;
    adsPricesOldMINREQ: TFIBIntegerField;
    adsPricesOldENABLED: TFIBIntegerField;
    adsPricesOldPRICEINFO: TFIBBlobField;
    adsPricesOldFIRMCODE: TFIBBCDField;
    adsPricesOldFULLNAME: TFIBStringField;
    adsPricesOldSTORAGE: TFIBIntegerField;
    adsPricesOldADMINMAIL: TFIBStringField;
    adsPricesOldSUPPORTPHONE: TFIBStringField;
    adsPricesOldCONTACTINFO: TFIBBlobField;
    adsPricesOldOPERATIVEINFO: TFIBBlobField;
    adsPricesOldREGIONCODE: TFIBBCDField;
    adsPricesOldREGIONNAME: TFIBStringField;
    adsPricesOldPOSITIONS: TFIBIntegerField;
    adsPricesOldPRICESIZE: TFIBIntegerField;
    adsPricesOldSumOrder: TCurrencyField;
    adsPricesOldINJOB: TFIBBooleanField;
    tmStopEdit: TTimer;
    adsPricesOldSUMBYCURRENTMONTH: TFIBBCDField;
    adsPrices: TMyQuery;
    adsPricesPriceCode: TLargeintField;
    adsPricesPriceName: TStringField;
    adsPricesUniversalDatePrice: TDateTimeField;
    adsPricesMinReq: TIntegerField;
    adsPricesEnabled: TBooleanField;
    adsPricesPriceInfo: TMemoField;
    adsPricesFirmCode: TLargeintField;
    adsPricesFullName: TStringField;
    adsPricesStorage: TBooleanField;
    adsPricesManagerMail: TStringField;
    adsPricesSupportPhone: TStringField;
    adsPricesContactInfo: TMemoField;
    adsPricesOperativeInfo: TMemoField;
    adsPricesRegionCode: TLargeintField;
    adsPricesRegionName: TStringField;
    adsPricespricesize: TIntegerField;
    adsPricesINJOB: TBooleanField;
    adsPricesCONTROLMINREQ: TBooleanField;
    adsPricesDatePrice: TDateTimeField;
    adsPricesPositions: TLargeintField;
    adsPricessumbycurrentmonth: TFloatField;
    adsPricesSumOrder: TFloatField;
    adsPricessumbycurrentweek: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actOnlyLeadersExecute(Sender: TObject);
    procedure dbtManagerMailClick(Sender: TObject);
    procedure dbgPricesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgPricesGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgPricesDblClick(Sender: TObject);
    procedure adsPrices2AfterScroll(DataSet: TDataSet);
    procedure adsPrices2AfterOpen(DataSet: TDataSet);
    procedure adsPricesOldSTORAGEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure dbgPricesSortMarkingChanged(Sender: TObject);
    procedure dbgPricesExit(Sender: TObject);
    procedure adsPricesOldINJOBChange(Sender: TField);
    procedure tmStopEditTimer(Sender: TObject);
    procedure adsPricesManagerMailGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure dbtManagerMailMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    procedure GetLastPrice;
    procedure SetLastPrice;
    procedure ProcessPrice;
    // включить/ выключить скроллы в зависимости от объёма текста
    procedure SetScrolls(var Memo: TDBMemo);
    // кол-во видимых строк в Memo
    function LinesVisible(Memo: TDBMemo): Integer;
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
  LastPriceCode: Integer;
  LastRegionCode: Int64;

procedure ShowPrices;
var
  //У клиента всего лишь один прайс-лист, поэтому открываем сразу форму с содержимым прайс-листа
  IsAlonePrice : Boolean;
  AlonePriceCode : Integer;
  AloneRegionCode : Int64;
  AlonePriceName, AloneRegionName : String;
begin
  if DM.adsPrices.Active then
    DM.adsPrices.Close;
  DM.adsPrices.Open;
  try
    //Если всего один прайс-лист, он в работе и кол-во позиций больше нуля
    IsAlonePrice := (DM.adsPrices.RecordCount = 1) and
       (DM.adsPricesINJOB.AsBoolean) and (DM.adsPricesPRICESIZE.AsInteger > 0);
    if IsAlonePrice then begin
      AlonePriceCode  := DM.adsPricesPRICECODE.AsInteger;
      AloneRegionCode := DM.adsPricesREGIONCODE.AsLargeInt;
      AlonePriceName  := DM.adsPricesPRICENAME.AsString;
      AloneRegionName := DM.adsPricesREGIONNAME.AsString;
    end
    else begin
      AlonePriceCode  := 0;
      AloneRegionCode := 0;
    end;
  finally
    DM.adsPrices.Close;
  end;

  if IsAlonePrice then begin
    //Если я переделаю ShowChildForm, то этот вызов не нужен
    MainForm.AddFormsToFree;

    CoreFirmForm := TCoreFirmForm( FindChildControlByClass(MainForm, TCoreFirmForm) );
    if CoreFirmForm = nil then
      CoreFirmForm := TCoreFirmForm.Create( Application );

    CoreFirmForm.ShowForm(
      AlonePriceCode,
      AloneRegionCode,
      AlonePriceName,
      AloneRegionName,
      False);
  end
  else begin
    PricesForm := TPricesForm( MainForm.ShowChildForm( TPricesForm));
    PricesForm.ShowForm;
  end;
end;

procedure TPricesForm.FormCreate(Sender: TObject);
var
	Reg: TRegIniFile;
begin
	inherited;
  NeedFirstOnDataSet := False;
  CoreFirmForm := TCoreFirmForm( FindChildControlByClass(MainForm, TCoreFirmForm) );
  if CoreFirmForm = nil then
    CoreFirmForm := TCoreFirmForm.Create( Application );
	actOnlyLeaders.Checked := DM.adtClients.FieldByName( 'OnlyLeaders').AsBoolean;
	Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, False)
    then
      dbgPrices.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
  finally
  	Reg.Free;
  end;
  //Если наследуются прайс-листы, то редактировать "В работе" запрещено
  adsPricesINJOB.ReadOnly := DM.adsUser.FieldByName('InheritPrices').AsBoolean;
  if dbgPrices.SortMarkedColumns.Count = 0 then
    dbgPrices.FieldColumns['PRICENAME'].Title.SortMarker := smUpEh;
end;

procedure TPricesForm.FormDestroy(Sender: TObject);
var
	Reg: TRegIniFile;
begin
	inherited;
  SoftPost(adsPrices);
  if not DM.adtClients.IsEmpty then
  begin
    GetLastPrice;
  end;
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey('Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, True);
    dbgPrices.SaveColumnsLayout(Reg);
  finally
    Reg.Free;
  end;
end;

procedure TPricesForm.ShowForm;
begin
  //открываем список фирм
  with adsPrices do begin
    ParamByName('ClientId').Value:=DM.adtClients.FieldByName('ClientId').Value;
    ParamByName('TimeZoneBias').Value:=TimeZoneBias;
    Screen.Cursor:=crHourglass;
    try
      if Active then begin
        GetLastPrice;
        Refresh;
        {
        Close;
        Open;
        }
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
  LastRegionCode := adsPricesRegionCode.AsLargeInt;
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

procedure TPricesForm.dbtManagerMailClick(Sender: TObject);
begin
  MailTo( dbtManagerMail.Field.AsString, '');
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
  //Реализация взята отсюда: http://www.autoaf.ru/faq_delphi.htm
	if DBMemo2.Lines.Count > 0 then
    SetScrolls(DBMemo2)
  else
    DBMemo2.ScrollBars := ssNone;
	if DBMemo3.Lines.Count > 0 then
    SetScrolls(DBMemo3)
  else
    DBMemo3.ScrollBars := ssNone;
  dbtManagerMail.Hint := adsPricesManagerMail.AsString;
end;

procedure TPricesForm.adsPrices2AfterOpen(DataSet: TDataSet);
begin
  lblPriceCount.Caption := 'Всего прайс-листов : ' + IntToStr( adsPrices.RecordCount);
  dbtManagerMail.Hint := adsPricesManagerMail.AsString;
end;

procedure TPricesForm.adsPricesOldSTORAGEGetText(Sender: TField;
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
        adsPricesREGIONCODE.AsLargeInt,
        adsPricesPRICENAME.AsString,
        adsPricesREGIONNAME.AsString,
        actOnlyLeaders.Checked);
end;

procedure TPricesForm.dbgPricesSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TPricesForm.dbgPricesExit(Sender: TObject);
begin
  SoftPost(adsPrices);
end;

procedure TPricesForm.adsPricesOldINJOBChange(Sender: TField);
begin
  tmStopEdit.Enabled := False;
  tmStopEdit.Interval := 500;
  tmStopEdit.Enabled := True;
end;

procedure TPricesForm.tmStopEditTimer(Sender: TObject);
begin
  tmStopEdit.Enabled := False;
  AProc.MessageBox('Изменение настроек прайс-листов будет применено при следующем обновлении.', MB_ICONWARNING);
  if dbgPrices.EditorMode then
    dbgPrices.EditorMode := False;
  SoftPost(adsPrices);
end;

function TPricesForm.LinesVisible(Memo: TDBMemo): Integer;
var
  OldFont: HFont;
  Hand: THandle;
  TM: TTextMetric;
  Rect: TRect;
  tempint: integer;
begin
  Hand:= GetDC(Memo.Handle);
  try
    OldFont:= SelectObject(Hand, Memo.Font.Handle);
    try
      GetTextMetrics(Hand, TM);
      Memo.Perform(EM_GETRECT, 0, longint(@Rect));
      tempint:= (Rect.Bottom - Rect.Top) div
      (TM.tmHeight + TM.tmExternalLeading);
    finally
      SelectObject(Hand, OldFont);
    end;
  finally
    ReleaseDC(Memo.Handle, Hand);
  end;
  Result:= tempint;
end;

procedure TPricesForm.SetScrolls(var Memo: TDBMemo);
var
  x, y: integer;
begin
  x := Length(Memo.Text);
  // Кол-во строк в Memo (не линий Lines)
  y := SendMessage(Memo.Handle, EM_LINEFROMCHAR, x, 0) + 1;
  //Кол-во видимых линий
  x := LinesVisible(Memo);
  if y > x then
    Memo.ScrollBars:= ssVertical
  else
    Memo.ScrollBars:= ssNone;
end;

procedure TPricesForm.adsPricesManagerMailGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
var
  CurrentTextWidth : Integer;
begin
  try
    Text := Sender.AsString;
    CurrentTextWidth := dbtManagerMail.Canvas.TextWidth(Text);
    if (CurrentTextWidth > dbtManagerMail.Width - 10) then begin
      repeat
        Text := Copy(Text, 1, Length(Text)-1);
        CurrentTextWidth := dbtManagerMail.Canvas.TextWidth(Text);
      until (CurrentTextWidth < dbtManagerMail.Width - 10);
      Text := Text + '...';
    end;
  except
  end;
end;

procedure TPricesForm.dbtManagerMailMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  dbtManagerMail.Hint := adsPricesManagerMail.AsString;
end;

initialization
  LastPriceCode := -1;
  LastRegionCode := -1;
end.
