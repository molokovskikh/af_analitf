unit Summary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, DB, 
  DBCtrls, StdCtrls, Placemnt, FR_DSet, FR_DBSet, Buttons, DBGridEh,
  ToughDBGrid, ExtCtrls, Registry, OleCtrls, SHDocVw, FIBDataSet,
  pFIBDataSet;

const
	SummarySql	= 'SELECT * FROM SUMMARYSHOW(:ACLIENTID, :RETAILFORCOUNT)  ORDER BY ';

type
  TSummaryForm = class(TChildForm)
    dsSummary: TDataSource;
    Label1: TLabel;
    dsSummaryH: TDataSource;
    Label2: TLabel;
    dbtCountOrder: TDBText;
    dbtSumOrder: TDBText;
    frdsSummary: TfrDBDataSet;
    Panel1: TPanel;
    Bevel1: TBevel;
    pClient: TPanel;
    pWebBrowser: TPanel;
    Bevel2: TBevel;
    WebBrowser1: TWebBrowser;
    dbgSummary: TToughDBGrid;
    adsSummary: TpFIBDataSet;
    adsSummaryVOLUME: TFIBStringField;
    adsSummaryQUANTITY: TFIBStringField;
    adsSummaryNOTE: TFIBStringField;
    adsSummaryPERIOD: TFIBStringField;
    adsSummaryJUNK: TFIBIntegerField;
    adsSummaryAWAIT: TFIBIntegerField;
    adsSummarySYNONYMNAME: TFIBStringField;
    adsSummarySYNONYMFIRM: TFIBStringField;
    adsSummaryBASECOST: TFIBBCDField;
    adsSummaryPRICENAME: TFIBStringField;
    adsSummaryREGIONNAME: TFIBStringField;
    adsSummaryPRICERET: TFIBBCDField;
    adsSummaryORDERCOUNT: TFIBIntegerField;
    adsSummaryORDERSCOREID: TFIBBCDField;
    adsSummaryORDERSORDERID: TFIBBCDField;
    adsSummarySumOrder: TCurrencyField;
    adsSummaryH: TpFIBDataSet;
    procedure adsSummary2CalcFields(DataSet: TDataSet);
    procedure adsSummary2AfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure dbgSummaryGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgSummarySortChange(Sender: TObject; SQLOrderBy: String);
    procedure dbgSummaryCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure adsSummary2BeforePost(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure adsSummary2AfterScroll(DataSet: TDataSet);
    procedure dbgSummaryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure SummaryShow;
    procedure SummaryHShow;
  public
    procedure Print( APreview: boolean = False); override;
    procedure ShowForm; reintroduce;
  end;

var
  SummaryForm: TSummaryForm;

procedure ShowSummary;

implementation

uses DModule, Main, AProc, Constant;

{$R *.dfm}

procedure ShowSummary;
begin
	SummaryForm := TSummaryForm( MainForm.ShowChildForm( TSummaryForm));
end;

procedure TSummaryForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;
	PrintEnabled := False;
	adsSummary.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	adsSummary.ParamByName( 'RetailForcount').Value := DM.adtClients.FieldByName( 'Forcount').Value;
	adsSummaryH.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, False) then dbgSummary.LoadFromRegistry( Reg);
	Reg.Free;
	ShowForm;
end;

procedure TSummaryForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, True);
	dbgSummary.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TSummaryForm.ShowForm;
begin
	SummaryShow;
	SummaryHShow;
	inherited;
end;

procedure TSummaryForm.SummaryShow;
begin
	Screen.Cursor := crHourglass;
	try
		with adsSummary do if Active then CloseOpen(True) else Open;
	finally
		Screen.Cursor := crDefault;
	end;
end;

procedure TSummaryForm.SummaryHShow;
begin
	Screen.Cursor := crHourglass;
	try
		with adsSummaryH do if Active then CloseOpen(True) else Open;
	finally
		Screen.Cursor := crDefault;
	end;
end;

procedure TSummaryForm.adsSummary2CalcFields(DataSet: TDataSet);
begin
	//вычисл€ем сумму по позиции
	adsSummarySumOrder.AsFloat := adsSummaryBaseCost.AsCurrency *
		adsSummaryORDERCOUNT.AsInteger;
end;

procedure TSummaryForm.adsSummary2AfterPost(DataSet: TDataSet);
begin
	SummaryHShow;
	if adsSummaryORDERCOUNT.AsInteger = 0 then SummaryShow;
	MainForm.SetOrdersInfo;
end;

procedure TSummaryForm.Print( APreview: boolean = False);
begin
	DM.ShowFastReport( 'Summary.frf', adsSummary, APreview);
end;

procedure TSummaryForm.dbgSummaryGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if adsSummaryJunk.AsBoolean and (( Column.FieldName = 'Period')or
		( Column.FieldName = 'BaseCost')) then Background := JUNK_CLR;
	//ожидаемый товар выдел€ем зеленым
	if adsSummaryAwait.AsBoolean and ( Column.FieldName = 'Synonym') then
		Background := AWAIT_CLR;
end;

procedure TSummaryForm.dbgSummarySortChange(Sender: TObject;
  SQLOrderBy: String);
begin
        adsSummary.DisableControls;
	Screen.Cursor := crHourglass;
	adsSummary.Close;
	adsSummary.SelectSQL.Text := SummarySql + SQLOrderBy;
	adsSummary.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	adsSummary.ParamByName( 'RetailForcount').Value := DM.adtClients.FieldByName( 'Forcount').Value;
	adsSummaryH.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	try
		adsSummary.Open;
	finally
		Screen.Cursor := crDefault;
		adsSummary.EnableControls;
	end;
end;

procedure TSummaryForm.dbgSummaryCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
	inherited;
//
end;

procedure TSummaryForm.adsSummary2BeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
begin
	try
		{ провер€ем заказ на соответствие наличию товара на складе }
		Val( adsSummaryQuantity.AsString, Quantity, E);
		if E<>0 then Quantity := 0;
		if ( Quantity > 0) and ( adsSummaryORDERCOUNT.AsInteger > Quantity) and
			( MessageBox( '«аказ превышает остаток на складе. ѕродолжить?',
			MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) then adsSummaryORDERCOUNT.AsInteger := Quantity;
	except
		adsSummary.Cancel;
		raise;
	end;
	inherited;
end;

procedure TSummaryForm.FormResize(Sender: TObject);
begin
  adsSummary2AfterScroll(adsSummary);
end;

procedure TSummaryForm.adsSummary2AfterScroll(DataSet: TDataSet);
//var
//  C : Integer;
begin
{
  C := dbgSummary.Canvas.TextHeight('Wg') + 2;
  if (adsSummary.RecordCount > 0) and ((adsSummary.RecordCount*C)/(pClient.Height-pWebBrowser.Height) > 13/10) then
    pWebBrowser.Visible := False
  else
    pWebBrowser.Visible := True;
}    
end;

procedure TSummaryForm.dbgSummaryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_DELETE) then begin
    if MessageBox('”далить позицию?', MB_ICONQUESTION or MB_YESNO) = IDYES then begin
      DM.adcUpdate.SQL.Text :=
        'delete from Orders where OrderID = ' +
          IntToStr(adsSummary.FieldByName('OrdersOrderID').AsInteger) +
          ' and CoreID = ' + IntToStr(adsSummary.FieldByName('OrdersCoreID').AsInteger);
      DM.adcUpdate.ExecQuery;
      adsSummary.CloseOpen(True);
      Key := 0;
    end;
  end
  else
    inherited;
end;

end.
