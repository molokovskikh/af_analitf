unit Summary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, DB, 
  DBCtrls, StdCtrls, Placemnt, FR_DSet, FR_DBSet, Buttons, DBGridEh,
  ToughDBGrid, ExtCtrls, Registry, OleCtrls, SHDocVw, FIBDataSet,
  pFIBDataSet, DBProc;

const
	SummarySql	= 'SELECT * FROM SUMMARYSHOW(:ACLIENTID)  ORDER BY ';

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
    adsSummaryPRICENAME: TFIBStringField;
    adsSummaryREGIONNAME: TFIBStringField;
    adsSummaryORDERCOUNT: TFIBIntegerField;
    adsSummaryORDERSCOREID: TFIBBCDField;
    adsSummaryORDERSORDERID: TFIBBCDField;
    adsSummarySumOrder: TCurrencyField;
    adsSummaryH: TpFIBDataSet;
    adsSummaryCryptSYNONYMNAME: TStringField;
    adsSummaryCryptSYNONYMFIRM: TStringField;
    adsSummaryCryptBASECOST: TCurrencyField;
    adsSummaryCODE: TFIBStringField;
    adsSummaryCODECR: TFIBStringField;
    adsSummaryBASECOST: TFIBStringField;
    adsSummaryPriceRet: TCurrencyField;
    procedure adsSummary2CalcFields(DataSet: TDataSet);
    procedure adsSummary2AfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure dbgSummaryGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgSummaryCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure adsSummary2BeforePost(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure adsSummary2AfterScroll(DataSet: TDataSet);
    procedure dbgSummaryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgSummarySortMarkingChanged(Sender: TObject);
    procedure adsSummaryBeforeEdit(DataSet: TDataSet);
    procedure adsSummaryBeforeDelete(DataSet: TDataSet);
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
var
  S : String;
  C : Currency;
begin
	//��������� ����� �� �������
  try
    adsSummaryCryptSYNONYMNAME.AsString := DM.D_S(adsSummarySYNONYMNAME.AsString);
    adsSummaryCryptSYNONYMFIRM.AsString := DM.D_S(adsSummarySYNONYMFIRM.AsString);
    S := DM.D_B(adsSummaryCODE.AsString, adsSummaryCODECR.AsString);
    C := StrToCurr(S);
    adsSummaryCryptBASECOST.AsCurrency := C;
    adsSummaryPriceRet.AsCurrency := DM.GetPriceRet(C);
    adsSummarySumOrder.AsCurrency := C * adsSummaryORDERCOUNT.AsInteger;
  except
  end;
end;

procedure TSummaryForm.adsSummary2AfterPost(DataSet: TDataSet);
begin
  DM.SetNewOrderCount(adsSummaryORDERCOUNT.AsInteger, adsSummaryCryptBASECOST.AsCurrency);
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
	if adsSummaryJunk.AsBoolean and (( Column.Field = adsSummaryPERIOD)or
		( Column.Field = adsSummaryCryptBASECOST)) then Background := JUNK_CLR;
	//��������� ����� �������� �������
	if adsSummaryAwait.AsBoolean and ( Column.Field = adsSummaryCryptSYNONYMNAME) then
		Background := AWAIT_CLR;
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
		{ ��������� ����� �� ������������ ������� ������ �� ������ }
		Val( adsSummaryQuantity.AsString, Quantity, E);
		if E<>0 then Quantity := 0;
		if ( Quantity > 0) and ( adsSummaryORDERCOUNT.AsInteger > Quantity) and
			( MessageBox( '����� ��������� ������� �� ������. ����������?',
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
    if MessageBox('������� �������?', MB_ICONQUESTION or MB_YESNO) = IDYES then begin
      DM.adcUpdate.Transaction.StartTransaction;
      try
        DM.adcUpdate.SQL.Text :=
          'delete from Orders where OrderID = ' +
            IntToStr(adsSummary.FieldByName('OrdersOrderID').AsInteger) +
            ' and CoreID = ' + IntToStr(adsSummary.FieldByName('OrdersCoreID').AsInteger);
        DM.adcUpdate.ExecQuery;
        DM.adcUpdate.Transaction.Commit;
      except
        DM.adcUpdate.Transaction.Rollback;
        raise;
      end;
      adsSummary.CloseOpen(True);
      Key := 0;
    end;
  end
  else
    inherited;
end;

procedure TSummaryForm.dbgSummarySortMarkingChanged(Sender: TObject);
begin
{
  adsSummary.DisableControls;
	Screen.Cursor := crHourglass;
	adsSummary.Close;
	adsSummary.SelectSQL.Text := SummarySql + SQLOrderBy;
	adsSummary.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	adsSummaryH.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	try
		adsSummary.Open;
	finally
		Screen.Cursor := crDefault;
		adsSummary.EnableControls;
	end;
}
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TSummaryForm.adsSummaryBeforeEdit(DataSet: TDataSet);
begin
  DM.SetOldOrderCount(adsSummaryORDERCOUNT.AsInteger);
end;

procedure TSummaryForm.adsSummaryBeforeDelete(DataSet: TDataSet);
begin
  DM.SetOldOrderCount(adsSummaryORDERCOUNT.AsInteger);
  DM.SetNewOrderCount(0, adsSummaryCryptBASECOST.AsCurrency);
end;

end.
