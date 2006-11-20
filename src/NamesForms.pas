unit NamesForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Placemnt, DB, StdCtrls, ExtCtrls, Grids, DBGrids,
  RXDBCtrl, ActnList, DBGridEh, ToughDBGrid, OleCtrls, SHDocVw, FIBDataSet,
  pFIBDataSet, Registry, ForceRus, StrUtils;

type
  TNamesFormsForm = class(TChildForm)
    Splitter1: TSplitter;
    pnlBottom: TPanel;
    chkUseForms: TCheckBox;
    dsNames: TDataSource;
    dsForms: TDataSource;
    ActionList: TActionList;
    actNewWares: TAction;
    actUseForms: TAction;
    pnlTopOld: TPanel;
    dbgNames: TToughDBGrid;
    dbgForms: TToughDBGrid;
    pClient: TPanel;
    adsNames: TpFIBDataSet;
    adsForms: TpFIBDataSet;
    cbShowAll: TCheckBox;
    actShowAll: TAction;
    pnlTop: TPanel;
    pWebBrowser: TPanel;
    Bevel1: TBevel;
    WebBrowser1: TWebBrowser;
    pWebBrowserCatalog: TPanel;
    Bevel2: TBevel;
    WebBrowser2: TWebBrowser;
    dbgCatalog: TToughDBGrid;
    cbNewSearch: TCheckBox;
    adsCatalog: TpFIBDataSet;
    dsCatalog: TDataSource;
    tmrShowCatalog: TTimer;
    pnlSearch: TPanel;
    eSearch: TEdit;
    btnSearch: TButton;
    tmrSearch: TTimer;
    actNewSearch: TAction;
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
    procedure dbgNamesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgFormsExit(Sender: TObject);
    procedure adsForms2AfterScroll(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
    procedure actShowAllExecute(Sender: TObject);
    procedure tmrShowCatalogTimer(Sender: TObject);
    procedure dbgCatalogKeyPress(Sender: TObject; var Key: Char);
    procedure tmrSearchTimer(Sender: TObject);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCatalogKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCatalogDblClick(Sender: TObject);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure actNewSearchExecute(Sender: TObject);
    procedure dbgCatalogDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure dbgNamesGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgFormsGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgCatalogGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    fr : TForceRus;
    BM : TBitmap;
    InternalSearchText : String;
    procedure SetNamesParams;
    procedure SetFormsParams;
    procedure AddKeyToSearch(Key : Char);
    procedure SetGrids;
  protected
    procedure DoShow; override;
  public
    procedure ShowForm; override;
    procedure SetCatalog;
  end;

procedure ShowOrderAll;

implementation

uses DModule, AProc, Core, Main, Types, AlphaUtils;

{$R *.dfm}

procedure ShowOrderAll;
begin
  MainForm.ShowChildForm(TNamesFormsForm);
end;

procedure TNamesFormsForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;

  BM := TBitmap.Create;

  InternalSearchText := '';
  
  NeedFirstOnDataSet := False;

  fr := TForceRus.Create;

  //„итаем настройки из реестра
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID, True);
  actNewSearch.Checked := False;
  if Reg.ValueExists('NewSearch') then
    actNewSearch.Checked := Reg.ReadBool('NewSearch');
	Reg.Free;

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

	CoreForm := TCoreForm.Create(Application);

  SetGrids;

	ShowForm;
end;

procedure TNamesFormsForm.ShowForm;
begin
	inherited;
end;

procedure TNamesFormsForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;
  fr.Free;
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID, True);
  Reg.WriteBool('NewSearch', actNewSearch.Checked);
	Reg.Free;
	with DM.adtParams do
	begin
		Edit;
		FieldByName( 'UseForms').AsBoolean := actUseForms.Checked;
		FieldByName( 'ShowAllCatalog').AsBoolean := actShowAll.Checked;
		Post;
	end;
  BM.Free;
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
      if Active then CloseOpen(False) else Open;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

//устанавливает параметры показа форм выпуска
procedure TNamesFormsForm.SetFormsParams;
begin
	dbgForms.Enabled := actUseForms.Checked;
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
			adsNames.FieldByName( 'Name').AsString, '', actUseForms.Checked, False);
	if actUseForms.Checked and ( adsForms.RecordCount < 2) then
		CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
			adsNames.FieldByName( 'Name').AsString,
			adsForms.FieldByName( 'Form').AsString, False, False);
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
		actUseForms.Checked, False);
end;

procedure TNamesFormsForm.dbgFormsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
        if Key = VK_RETURN then dbgFormsDblClick( Sender);
	if ( Key = VK_ESCAPE) or ( Key = VK_SPACE) then dbgNames.SetFocus;
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
  if not actNewSearch.Checked then
    adsForms2AfterScroll(adsForms);
end;

procedure TNamesFormsForm.actShowAllExecute(Sender: TObject);
begin
  if actNewSearch.Checked then begin
  	if not dbgCatalog.CanFocus then exit;
  end
  else
  	if not dbgNames.CanFocus then exit;

	actShowAll.Checked := not actShowAll.Checked;

  if actNewSearch.Checked then begin
    if Length(InternalSearchText) > 0 then
      tmrSearchTimer(nil)
    else
      SetCatalog;
  end
  else
    SetNamesParams;

  if actNewSearch.Checked then
    dbgCatalog.SetFocus
  else
  	dbgNames.SetFocus;
end;

procedure TNamesFormsForm.SetCatalog;
begin
  tmrSearch.Enabled := False;
  eSearch.Text := '';
  InternalSearchText := '';
  with adsCatalog do begin
    Screen.Cursor:=crHourglass;
    try
      if Active then Close;
      SelectSQL.Text := 'SELECT CATALOGS.ShortCode, CATALOGS.Name, CATALOGS.fullcode, CATALOGS.form, CATALOGS.COREEXISTS FROM CATALOGS';
      if not actShowAll.Checked then
        SelectSQL.Text := SelectSQL.Text + ' where CATALOGS.COREEXISTS = 1';
      Open;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TNamesFormsForm.tmrShowCatalogTimer(Sender: TObject);
begin
  try
    if actNewSearch.Checked then
      dbgCatalog.SetFocus
    else
      if not dbgForms.Focused then
        dbgNames.SetFocus;
    tmrShowCatalog.Enabled := False;
  except
  end;
end;

procedure TNamesFormsForm.dbgCatalogKeyPress(Sender: TObject;
  var Key: Char);
begin
  AddKeyToSearch(Key);
end;

procedure TNamesFormsForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + fr.DoIt(Key);
    tmrSearch.Enabled := True;
  end;
end;

procedure TNamesFormsForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  InternalSearchText := LeftStr(eSearch.Text, 50);
  eSearch.Text := '';
  adsCatalog.Close;
  adsCatalog.SelectSQL.Text := 'SELECT CATALOGS.ShortCode, CATALOGS.Name, CATALOGS.fullcode, CATALOGS.form, CATALOGS.COREEXISTS ' +
    'FROM CATALOGS where ((upper(Name) like upper(:LikeParam)) or (upper(Form) like upper(:LikeParam)))';
  if not actShowAll.Checked then
    adsCatalog.SelectSQL.Text := adsCatalog.SelectSQL.Text + ' and CATALOGS.COREEXISTS = 1';
  adsCatalog.ParamByName('LikeParam').AsString := '%' + InternalSearchText + '%';
  adsCatalog.Open;
  dbgCatalog.SetFocus;
end;

procedure TNamesFormsForm.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
  end
  else
    if Key = VK_ESCAPE then
      SetCatalog;
end;

procedure TNamesFormsForm.dbgCatalogKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    dbgCatalogDblClick(nil)
  else
    if Key = VK_ESCAPE then
      SetCatalog;
end;

procedure TNamesFormsForm.dbgCatalogDblClick(Sender: TObject);
begin
	CoreForm.ShowForm( adsCatalog.FieldByName( 'FullCode').AsInteger,
		adsCatalog.FieldByName( 'Name').AsString, adsCatalog.FieldByName( 'Form').AsString,
		True, True);
end;

procedure TNamesFormsForm.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //≈сли мы что-то нажали в элементе, то должны на это отреагировать
  tmrSearch.Enabled := True;
end;

procedure TNamesFormsForm.SetGrids;
begin
  actUseForms.Visible := not actNewSearch.Checked;
  if actNewSearch.Checked then begin
    pnlTop.BringToFront;
    SetCatalog;
  end
  else begin
    pnlTopOld.BringToFront;
    SetNamesParams;
    SetFormsParams;
  end;
  tmrShowCatalog.Enabled := True;
end;

procedure TNamesFormsForm.actNewSearchExecute(Sender: TObject);
begin
	actNewSearch.Checked := not actNewSearch.Checked;
  SetGrids;
end;

procedure TNamesFormsForm.dbgCatalogDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  ProduceAlphaBlendRect(InternalSearchText, Column.Field.DisplayText, dbgCatalog.Canvas, Rect, BM);
end;

procedure TNamesFormsForm.dbgNamesGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not adsNames.IsEmpty and (adsNames.FieldByName('COREEXISTS').AsInteger = 0) then
    Background := clSilver;
end;

procedure TNamesFormsForm.dbgFormsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not adsForms.IsEmpty and (adsForms.FieldByName('COREEXISTS').AsInteger = 0) then
    Background := clSilver;
end;

procedure TNamesFormsForm.dbgCatalogGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not adsCatalog.IsEmpty then
   if (adsCatalog.FieldByName('COREEXISTS').AsInteger = 0) then
     Background := clSilver;
end;

procedure TNamesFormsForm.DoShow;
begin
  inherited;
  tmrShowCatalog.Enabled := True;
end;

end.
