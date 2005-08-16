unit NamesForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Placemnt, DB, ADODB, StdCtrls, ExtCtrls, Grids, DBGrids,
  RXDBCtrl, ActnList, DBGridEh, ToughDBGrid, OleCtrls, SHDocVw, FIBDataSet,
  pFIBDataSet;

const
	NamesSql =	'SELECT * FROM CatalogShowByName ORDER BY ';
	FormsSql =	'SELECT * FROM CatalogShowByForm ORDER BY ';

type
  TNamesFormsForm = class(TChildForm)
    Splitter1: TSplitter;
    pnlBottom: TPanel;
    chkUseForms: TCheckBox;
    dsNames: TDataSource;
    adsForms2: TADODataSet;
    dsForms: TDataSource;
    ActionList: TActionList;
    actNewWares: TAction;
    actUseForms: TAction;
    adsNames2: TADODataSet;
    pnlTop: TPanel;
    dbgNames: TToughDBGrid;
    dbgForms: TToughDBGrid;
    pClient: TPanel;
    pWebBrowser: TPanel;
    Bevel1: TBevel;
    WebBrowser1: TWebBrowser;
    adsNames: TpFIBDataSet;
    adsForms: TpFIBDataSet;
    cbShowAll: TCheckBox;
    actShowAll: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actUseFormsExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actNewWaresExecute(Sender: TObject);
    procedure dbgNamesEnter(Sender: TObject);
    procedure dbgFormsEnter(Sender: TObject);
    procedure dbgFormsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgNamesDblClick(Sender: TObject);
    procedure dbgFormsDblClick(Sender: TObject);
    procedure dbgNamesSortChange(Sender: TObject; SQLOrderBy: String);
    procedure dbgNamesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgFormsExit(Sender: TObject);
    procedure adsForms2AfterScroll(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
    procedure actShowAllExecute(Sender: TObject);
  private
    procedure SetNamesParams;
    procedure SetFormsParams;
  public
	procedure ShowForm; override;
  end;

procedure ShowOrderAll;

implementation

uses DModule, AProc, Core, Main;

{$R *.dfm}

procedure ShowOrderAll;
begin
  MainForm.ShowChildForm(TNamesFormsForm);
end;

procedure TNamesFormsForm.FormCreate(Sender: TObject);
begin
	inherited;
	with DM.adtParams do
	begin
		if not DM.adtParams.FieldByName( 'OperateForms').AsBoolean then
		begin
			actUseForms.Checked := True;
			actUseForms.Enabled := False;
		end
		else
		begin
			actUseForms.Checked := FieldByName( 'UseForms').AsBoolean;
			actUseForms.Enabled := True;
		end;
  	actShowAll.Checked := FieldByName( 'ShowAllCatalog').AsBoolean;
	end;
	SetNamesParams;
	SetFormsParams;
	CoreForm := TCoreForm.Create(Application);
	ShowForm;
end;

procedure TNamesFormsForm.ShowForm;
begin
	inherited;
end;

procedure TNamesFormsForm.FormDestroy(Sender: TObject);
begin
	inherited;
	with DM.adtParams do
	begin
		Edit;
		FieldByName( 'UseForms').AsBoolean := actUseForms.Checked;
		FieldByName( 'ShowAllCatalog').AsBoolean := actShowAll.Checked;
		Post;
	end;
end;

procedure TNamesFormsForm.actNewWaresExecute(Sender: TObject);
begin
	if not dbgNames.CanFocus then exit;
	actNewWares.Checked := not actNewWares.Checked;
	SetNamesParams;
	dbgNames.SetFocus;
end;

procedure TNamesFormsForm.actUseFormsExecute(Sender: TObject);
begin
	if not dbgNames.CanFocus then exit;
	actUseForms.Checked := not actUseForms.Checked;
	SetFormsParams;
	dbgNames.SetFocus;
end;

//устанавливает параметры показа наименований
procedure TNamesFormsForm.SetNamesParams;
begin
  with adsNames do begin
    Screen.Cursor:=crHourglass;
    try
      ParamByName('ShowAll').Value := actShowAll.Checked;
      adsForms.ParamByName('ShowAll').Value := actShowAll.Checked;
      if Active then CloseOpen(True) else Open;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

//устанавливает параметры показа форм выпуска
procedure TNamesFormsForm.SetFormsParams;
begin
	dbgForms.Enabled := actUseForms.Checked;
//	if not adsForms.Active then adsForms.Open;
end;

procedure TNamesFormsForm.dbgNamesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
	if Key = VK_RETURN then dbgNamesDblClick( Sender);
end;

procedure TNamesFormsForm.dbgNamesDblClick(Sender: TObject);
begin
	inherited;
	if not actUseForms.Checked then
		CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
			adsNames.FieldByName( 'Name').AsString, '', actUseForms.Checked);
	if actUseForms.Checked and ( adsForms.RecordCount < 2) then
		CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
			adsNames.FieldByName( 'Name').AsString,
			adsForms.FieldByName( 'Form').AsString, False);
	if actUseForms.Checked and ( adsForms.RecordCount > 1) then dbgForms.SetFocus;
end;

procedure TNamesFormsForm.dbgNamesEnter(Sender: TObject);
begin
	dbgNames.Color := clWindow;
	dbgForms.Color := clBtnFace;
end;

procedure TNamesFormsForm.dbgFormsEnter(Sender: TObject);
begin
	dbgNames.Color := clBtnFace;
	dbgForms.Color := clWindow;
	dbgForms.Options := dbgForms.Options + [dgAlwaysShowSelection]; 
end;

procedure TNamesFormsForm.dbgFormsExit(Sender: TObject);
begin
	dbgForms.Options := dbgForms.Options - [dgAlwaysShowSelection];
end;

procedure TNamesFormsForm.dbgFormsDblClick(Sender: TObject);
begin
	inherited;
	CoreForm.ShowForm( adsForms.FieldByName( 'FullCode').AsInteger,
		adsNames.FieldByName( 'Name').AsString, adsForms.FieldByName( 'Form').AsString,
		actUseForms.Checked);
end;

procedure TNamesFormsForm.dbgFormsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
        if Key = VK_RETURN then dbgFormsDblClick( Sender);
	if ( Key = VK_ESCAPE) or ( Key = VK_SPACE) then dbgNames.SetFocus;
end;

procedure TNamesFormsForm.dbgNamesSortChange(Sender: TObject;
  SQLOrderBy: String);
begin
	inherited;
	adsNames.Close;
	adsNames.SelectSQL.Text := NamesSql + SQLOrderBy;
	SetNamesParams;
	SetFormsParams;
end;

procedure TNamesFormsForm.adsForms2AfterScroll(DataSet: TDataSet);
var
  C : Integer;
begin
  C := dbgForms.Canvas.TextHeight('Wg') + 2;
  if (adsForms.RecordCount > 0) and ((adsForms.RecordCount*C)/(pClient.Height-pWebBrowser.Height) > 13/10) then
    pWebBrowser.Visible := False
  else
    pWebBrowser.Visible := True;
end;

procedure TNamesFormsForm.FormResize(Sender: TObject);
begin
  adsForms2AfterScroll(adsForms);
end;

procedure TNamesFormsForm.actShowAllExecute(Sender: TObject);
begin
	if not dbgNames.CanFocus then exit;
	actShowAll.Checked := not actShowAll.Checked;
  SetNamesParams;
	dbgNames.SetFocus;
end;

end.
