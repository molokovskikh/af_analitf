unit Prices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, StdCtrls, DBCtrls, Grids, DBGrids, RXDBCtrl,
  ActnList, DB, ADODB, Buttons, ComCtrls, ExtCtrls, DBGridEh, ToughDBGrid,
  Registry, DBGridEhImpExp;

const
	PricesSql =	'SELECT * FROM PricesShow ORDER BY ';

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
    adsPrices: TADODataSet;
    dsPrices: TDataSource;
    dbtMinOrder: TDBText;
    adsPricesFullName: TWideStringField;
    actCurrentOrders: TAction;
    adsPricesPositions: TIntegerField;
    adsPricesStorage: TBooleanField;
    adsPricesAdminMail: TWideStringField;
    adsPricesSupportPhone: TWideStringField;
    adsPricesContactInfo: TMemoField;
    adsPricesOperativeInfo: TMemoField;
    adsPricesEnabled: TBooleanField;
    adsPricesPriceCode: TIntegerField;
    adsPricesPriceName: TWideStringField;
    adsPricesDatePrice: TDateTimeField;
    adsPricesFirmCode: TIntegerField;
    adsPricesRegionCode: TIntegerField;
    adsPricesRegionName: TWideStringField;
    adsClientsData: TADODataSet;
    Label4: TLabel;
    adsPricesSumOrder: TBCDField;
    adsPricesPriceSize: TIntegerField;
    adsPricesUpCost: TFloatField;
    adsPricesPriceInfo: TMemoField;
    Panel1: TPanel;
    Panel2: TPanel;
    adsPricesMinReq: TIntegerField;
    Label3: TLabel;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    dbgPrices: TToughDBGrid;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label6: TLabel;
    DBMemo3: TDBMemo;
    Bevel3: TBevel;
    Panel3: TPanel;
    lblPriceCount: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actOnlyLeadersExecute(Sender: TObject);
    procedure dbtAdminMailClick(Sender: TObject);
    procedure dbgPricesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgPricesGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgPricesDblClick(Sender: TObject);
    procedure dbgPricesSortChange(Sender: TObject; SQLOrderBy: String);
    procedure adsPricesAfterScroll(DataSet: TDataSet);
    procedure adsPricesAfterOpen(DataSet: TDataSet);
  private
    procedure GetLastPrice;
    procedure SetLastPrice;
  public
    procedure ShowForm; override;
  end;

var
  PricesForm: TPricesForm;

procedure ShowPrices;

implementation

uses Main, DModule, AProc, DBProc, CoreFirm;

{$R *.dfm}

var
	LastPriceCode, LastRegionCode: Integer;

procedure ShowPrices;
begin
	PricesForm := TPricesForm( MainForm.ShowChildForm( TPricesForm));
	PricesForm.dbgPrices.SetFocus;
	PricesForm.ShowForm;
end;

procedure TPricesForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;
	CoreFirmForm := TCoreFirmForm.Create( Application);
	actOnlyLeaders.Checked := DM.adtClients.FieldByName( 'OnlyLeaders').AsBoolean;
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, False) then dbgPrices.LoadFromRegistry( Reg);
	Reg.Free;
	ShowForm;
end;

procedure TPricesForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;
	if not DM.adtClients.IsEmpty then
	begin
		DM.adtClients.Edit;
		DM.adtClients.FieldByName( 'OnlyLeaders').AsBoolean := actOnlyLeaders.Checked;
		DM.adtClients.Post;
		GetLastPrice;
	end;
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, True);
	dbgPrices.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TPricesForm.ShowForm;
begin
  //открываем список фирм
  with adsPrices do begin
    Parameters.ParamByName('AClientId').Value:=DM.adtClients.FieldByName('ClientId').Value;
    Screen.Cursor:=crHourglass;
    try
      if Active then begin
        GetLastPrice;
        Requery;
      end
      else
        Open;
      SetLastPrice;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
  //открываем список прайс-листов - регионов
  with adsPrices do begin
    Parameters.ParamByName('TimeZoneBias').Value:=TimeZoneBias;
    Open;
  end;
  inherited;
end;

procedure TPricesForm.GetLastPrice;
begin
	LastPriceCode := adsPricesPriceCode.AsInteger;
	LastRegionCode := adsPricesRegionCode.AsInteger;
end;

procedure TPricesForm.SetLastPrice;
begin
	if not adsPrices.IsEmpty then
		adsPrices.Locate( 'PriceCode;RegionCode',
		VarArrayOf([ LastPriceCode, LastRegionCode]),[]);
end;

procedure TPricesForm.actOnlyLeadersExecute(Sender: TObject);
begin
	actOnlyLeaders.Checked:=not actOnlyLeaders.Checked;
	dbgPrices.SetFocus;
end;

procedure TPricesForm.dbtAdminMailClick(Sender: TObject);
begin
	MailTo( dbtAdminMail.Field.AsString, '');
end;

procedure TPricesForm.dbgPricesDblClick(Sender: TObject);
begin
	inherited;
	if adsPricesFirmCode.AsInteger=RegisterId then MainForm.actRegistry.Execute
		else CoreFirmForm.ShowForm(adsPrices.FieldByName( 'PriceCode').AsInteger,
			adsPrices.FieldByName( 'RegionCode').AsInteger, actOnlyLeaders.Checked);
end;

procedure TPricesForm.dbgPricesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
	if Key = VK_RETURN then dbgPricesDblClick( Sender);
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

procedure TPricesForm.dbgPricesSortChange(Sender: TObject;
  SQLOrderBy: String);
begin
	adsPrices.Close;
	adsPrices.CommandText := PricesSql + SQLOrderBy;
	adsPrices.Parameters.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	adsPrices.Parameters.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	adsPrices.Open;
end;

procedure TPricesForm.adsPricesAfterScroll(DataSet: TDataSet);
begin
	inherited;
	if DBMemo2.Lines.Count > 8 then DBMemo2.ScrollBars := ssVertical
		else DBMemo2.ScrollBars := ssNone;
	if DBMemo3.Lines.Count > 8 then DBMemo3.ScrollBars := ssVertical
		else DBMemo3.ScrollBars := ssNone;
end;

procedure TPricesForm.adsPricesAfterOpen(DataSet: TDataSet);
begin
	lblPriceCount.Caption := 'Всего прайс-листов : ' + IntToStr( DataSet.RecordCount);
end;

end.
