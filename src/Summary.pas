unit Summary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, DB, ADODB, ADOInt,
  DBCtrls, StdCtrls, Placemnt, FR_DSet, FR_DBSet, Buttons, DBGridEh,
  ToughDBGrid, ExtCtrls, Registry, OleCtrls, SHDocVw;

const
	SummarySql	= 'SELECT * FROM SummaryShow ORDER BY ';

type
  TSummaryForm = class(TChildForm)
    adsSummary: TADODataSet;
    dsSummary: TDataSource;
    adsSummaryH: TADODataSet;
    Label1: TLabel;
    dsSummaryH: TDataSource;
    Label2: TLabel;
    dbtCountOrder: TDBText;
    dbtSumOrder: TDBText;
    adsSummaryHCountOrder: TIntegerField;
    adsSummaryHSumOrder: TBCDField;
    adsSummarySynonym: TWideStringField;
    adsSummarySynonymFirm: TWideStringField;
    adsSummaryVolume: TWideStringField;
    adsSummaryNote: TWideStringField;
    adsSummaryPeriod: TWideStringField;
    adsSummaryBaseCost: TBCDField;
    adsSummaryPriceRet: TFloatField;
    adsSummaryQuantity: TWideStringField;
    adsSummaryOrder: TIntegerField;
    adsSummarySumOrder: TCurrencyField;
    frdsSummary: TfrDBDataSet;
    adsSummaryPriceName: TWideStringField;
    adsSummaryRegionName: TWideStringField;
    adsSummaryJunk: TBooleanField;
    Panel1: TPanel;
    Bevel1: TBevel;
    adsSummaryAwait: TBooleanField;
    pClient: TPanel;
    pWebBrowser: TPanel;
    Bevel2: TBevel;
    WebBrowser1: TWebBrowser;
    dbgSummary: TToughDBGrid;
    procedure adsSummaryCalcFields(DataSet: TDataSet);
    procedure adsSummaryAfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure dbgSummaryGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgSummarySortChange(Sender: TObject; SQLOrderBy: String);
    procedure dbgSummaryCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure adsSummaryBeforePost(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure adsSummaryAfterScroll(DataSet: TDataSet);
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
	PrintEnabled := True;
	adsSummary.Parameters.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	adsSummary.Parameters.ParamByName( 'RetailForcount').Value := DM.adtClients.FieldByName( 'Forcount').Value;
	adsSummaryH.Parameters.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
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
		with adsSummary do if Active then Requery else Open;
	finally
		Screen.Cursor := crDefault;
	end;
end;

procedure TSummaryForm.SummaryHShow;
begin
	Screen.Cursor := crHourglass;
	try
		with adsSummaryH do if Active then Requery else Open;
	finally
		Screen.Cursor := crDefault;
	end;
end;

procedure TSummaryForm.adsSummaryCalcFields(DataSet: TDataSet);
begin
	//вычисл€ем сумму по позиции
	adsSummarySumOrder.AsFloat := adsSummaryBaseCost.AsCurrency *
		adsSummaryOrder.AsInteger;
end;

procedure TSummaryForm.adsSummaryAfterPost(DataSet: TDataSet);
begin
	SummaryHShow;
	if adsSummaryOrder.AsInteger = 0 then SummaryShow;
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
	adsSummary.CommandText := SummarySql + SQLOrderBy;
	adsSummary.Parameters.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	adsSummary.Parameters.ParamByName( 'RetailForcount').Value := DM.adtClients.FieldByName( 'Forcount').Value;
	adsSummaryH.Parameters.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
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

procedure TSummaryForm.adsSummaryBeforePost(DataSet: TDataSet);
var
	Quantity, E: Integer;
begin
	try
		{ провер€ем заказ на соответствие наличию товара на складе }
		Val( adsSummaryQuantity.AsString, Quantity, E);
		if E<>0 then Quantity := 0;
		if ( Quantity > 0) and ( adsSummaryOrder.AsInteger > Quantity) and
			( MessageBox( '«аказ превышает остаток на складе. ѕродолжить?',
			MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) then adsSummaryOrder.AsInteger := Quantity;
	except
		adsSummary.Cancel;
		raise;
	end;
	inherited;
end;

procedure TSummaryForm.FormResize(Sender: TObject);
begin
  adsSummaryAfterScroll(adsSummary);
end;

procedure TSummaryForm.adsSummaryAfterScroll(DataSet: TDataSet);
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

end.
