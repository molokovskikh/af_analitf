unit NamesForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Placemnt, DB, StdCtrls, ExtCtrls, Grids, DBGrids,
  RXDBCtrl, ActnList, DBGridEh, ToughDBGrid, OleCtrls, SHDocVw, FIBDataSet,
  pFIBDataSet, Registry, ForceRus, StrUtils, GridsEh, MemDS, DBAccess,
  MyAccess;

type
  TNamesFormsForm = class(TChildForm)
    Splitter1: TSplitter;
    pnlBottom: TPanel;
    chkUseForms: TCheckBox;
    dsNames: TDataSource;
    dsForms: TDataSource;
    ActionList: TActionList;
    actUseForms: TAction;
    pnlTopOld: TPanel;
    dbgNames: TToughDBGrid;
    dbgForms: TToughDBGrid;
    pClient: TPanel;
    adsNamesOld: TpFIBDataSet;
    adsFormsOld: TpFIBDataSet;
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
    adsCatalogOld: TpFIBDataSet;
    dsCatalog: TDataSource;
    tmrShowCatalog: TTimer;
    pnlSearch: TPanel;
    eSearch: TEdit;
    btnSearch: TButton;
    tmrSearch: TTimer;
    actNewSearch: TAction;
    cbSearchInBegin: TCheckBox;
    actSearchInBegin: TAction;
    adsForms: TMyQuery;
    adsCatalog: TMyQuery;
    adsNames: TMyQuery;
    procedure FormCreate(Sender: TObject);
    procedure actUseFormsExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    procedure actSearchInBeginExecute(Sender: TObject);
  private
    fr : TForceRus;
    BM : TBitmap;
    InternalSearchText : String;
    procedure SetNamesParams;
    procedure SetFormsParams;
    procedure AddKeyToSearch(Key : Char);
    procedure SetGrids;
    procedure NamesToCore;
    procedure FormsToCore;
    procedure CatalogToCore;
  protected
    procedure DoShow; override;
  public
    procedure ShowForm; override;
    procedure SetCatalog;
  end;

procedure ShowOrderAll;

procedure FlipToCode(FullCode, ShortCode: Integer; CoreId : Int64);

implementation

uses DModule, AProc, Core, Main, Types, AlphaUtils;

{$R *.dfm}

var
  SearchInBegin : Boolean;

procedure ShowOrderAll;
begin
  MainForm.ShowChildForm(TNamesFormsForm);
end;

procedure FlipToCode(FullCode, ShortCode: Integer; CoreId : Int64);
begin
	ShowOrderAll;

	with TNamesFormsForm( MainForm.ActiveChild) do
	begin
    if actNewSearch.Checked then begin
      SetCatalog;
      adsCatalog.Locate('FullCode', FullCode, []);
      CoreForm.ShowForm( adsCatalog.FieldByName( 'FullCode').AsInteger,
        adsCatalog.FieldByName( 'Name').AsString, adsCatalog.FieldByName( 'Form').AsString,
        True, True);
    end
    else begin
      adsNames.Locate( 'AShortCode', ShortCode, []);

      if not actUseForms.Checked then
        CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
          adsNames.FieldByName( 'Name').AsString, '', actUseForms.Checked, False);
      if actUseForms.Checked and ( adsForms.RecordCount < 2) then
        CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
          adsNames.FieldByName( 'Name').AsString,
          adsForms.FieldByName( 'Form').AsString, False, False);
      if actUseForms.Checked and ( adsForms.RecordCount > 1) then
      begin
        adsForms.Locate( 'FullCode', FullCode, []);
        CoreForm.ShowForm( adsForms.FieldByName( 'FullCode').AsInteger,
          adsNames.FieldByName( 'Name').AsString,
          adsForms.FieldByName( 'Form').AsString,
          actUseForms.Checked, False);
      end;
    end;
		CoreForm.adsCore.Locate( 'CoreId', CoreId, []);
	end;
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

  //������ ��������� �� �������
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID, True);
  actNewSearch.Checked := True;
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

  dbgNames.PopupMenu := nil;
  dbgForms.PopupMenu := nil;
  dbgCatalog.PopupMenu := nil;

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

procedure TNamesFormsForm.actUseFormsExecute(Sender: TObject);
begin
	if not dbgNames.CanFocus then exit;
	actUseForms.Checked := not actUseForms.Checked;
	SetFormsParams;
	dbgNames.SetFocus;
end;

//������������� ��������� ������ ������������
procedure TNamesFormsForm.SetNamesParams;
begin
  Screen.Cursor:=crHourglass;
  try
    adsNames.ParamByName('ShowAll').Value := actShowAll.Checked;
    adsForms.ParamByName('ShowAll').Value := actShowAll.Checked;
    adsForms.Close;
    if adsNames.Active then begin
      adsNames.Close;
      adsNames.Open;
    end
    else
      adsNames.Open;
    adsForms.Open;
  finally
    Screen.Cursor := crDefault;
  end;
end;

//������������� ��������� ������ ���� �������
procedure TNamesFormsForm.SetFormsParams;
begin
	dbgForms.Enabled := actUseForms.Checked;
end;

procedure TNamesFormsForm.dbgNamesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
	if Key = VK_RETURN then
    NamesToCore;
end;

procedure TNamesFormsForm.dbgNamesDblClick(Sender: TObject);
var
  C : GridsEh.TGridCoord;
  P : TPoint;
begin
	inherited;
  p := dbgNames.ScreenToClient(Mouse.CursorPos);
  C := dbgNames.MouseCoord(p.X, p.Y);
  if C.Y > 0 then
    NamesToCore;
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
var
  C : GridsEh.TGridCoord;
  P : TPoint;
begin
	inherited;
  p := dbgForms.ScreenToClient(Mouse.CursorPos);
  C := dbgForms.MouseCoord(p.X, p.Y);
  if C.Y > 0 then
    FormsToCore;
end;

procedure TNamesFormsForm.dbgFormsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
  if Key = VK_RETURN then
    FormsToCore;
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
  actSearchInBegin.Checked := SearchInBegin;
  if SearchInBegin then
    dbgCatalog.SearchField := 'Name'
  else
    dbgCatalog.SearchField := '';
  tmrSearch.Enabled := False;
  eSearch.Text := '';
  InternalSearchText := '';
  with adsCatalog do begin
    Screen.Cursor:=crHourglass;
    try
      if Active then Close;
      SQL.Text := 'SELECT CATALOGS.ShortCode, CATALOGS.Name, CATALOGS.fullcode, CATALOGS.form, CATALOGS.COREEXISTS FROM CATALOGS';
      if not actShowAll.Checked then
        SQL.Text := SQL.Text + ' where CATALOGS.COREEXISTS = 1';
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
  if not SearchInBegin then
    AddKeyToSearch(Key);
end;

procedure TNamesFormsForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TNamesFormsForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  InternalSearchText := LeftStr(eSearch.Text, 50);
  eSearch.Text := '';
  adsCatalog.Close;
  adsCatalog.SQL.Text := 'SELECT CATALOGS.ShortCode, CATALOGS.Name, CATALOGS.fullcode, CATALOGS.form, CATALOGS.COREEXISTS ' +
    'FROM CATALOGS where ((upper(Name) like upper(:LikeParam)) or (upper(Form) like upper(:LikeParam)))';
  if not actShowAll.Checked then
    adsCatalog.SQL.Text := adsCatalog.SQL.Text + ' and CATALOGS.COREEXISTS = 1';
  adsCatalog.ParamByName('LikeParam').AsString := iif(SearchInBegin, '', '%') + InternalSearchText + '%';
  adsCatalog.Open;
  dbgCatalog.SetFocus;
end;

procedure TNamesFormsForm.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
    dbgCatalog.SetFocus;
  end
  else
    if Key = VK_ESCAPE then
      SetCatalog;
end;

procedure TNamesFormsForm.dbgCatalogKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    if tmrSearch.Enabled then
      tmrSearchTimer(nil)
    else
      CatalogToCore;
  end
  else
    if Key = VK_ESCAPE then
      SetCatalog;
end;

procedure TNamesFormsForm.dbgCatalogDblClick(Sender: TObject);
var
  C : GridsEh.TGridCoord;
  P : TPoint;
begin
  p := dbgCatalog.ScreenToClient(Mouse.CursorPos);
  C := dbgCatalog.MouseCoord(p.X, p.Y);
  if C.Y > 0 then
    CatalogToCore;
end;

procedure TNamesFormsForm.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //���� �� ���-�� ������ � ��������, �� ������ �� ��� �������������
  if Ord(Key) <> VK_RETURN then
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
  if not adsNames.IsEmpty and (adsNames.FieldByName('COREEXISTS').AsFloat < 0.001 ) then
    Background := clSilver;
end;

procedure TNamesFormsForm.dbgFormsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not adsForms.IsEmpty and (adsForms.FieldByName('COREEXISTS').AsBoolean = False) then
    Background := clSilver;
end;

procedure TNamesFormsForm.dbgCatalogGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not adsCatalog.IsEmpty then
   if (adsCatalog.FieldByName('COREEXISTS').AsBoolean = False) then
     Background := clSilver;
end;

procedure TNamesFormsForm.DoShow;
begin
  inherited;
  tmrShowCatalog.Enabled := True;
end;

procedure TNamesFormsForm.actSearchInBeginExecute(Sender: TObject);
begin
  actSearchInBegin.Checked := not actSearchInBegin.Checked;
  SearchInBegin := actSearchInBegin.Checked;
  dbgCatalog.SetFocus;
  if SearchInBegin then
    dbgCatalog.SearchField := 'Name'
  else
    dbgCatalog.SearchField := '';
end;

procedure TNamesFormsForm.NamesToCore;
begin
  if not actUseForms.Checked then
    CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
      adsNames.FieldByName( 'Name').AsString, '', actUseForms.Checked, False);
  if actUseForms.Checked and ( adsForms.RecordCount < 2) then
    CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
      adsNames.FieldByName( 'Name').AsString,
      adsForms.FieldByName( 'Form').AsString, False, False);
  if actUseForms.Checked and ( adsForms.RecordCount > 1) then dbgForms.SetFocus;
end;

procedure TNamesFormsForm.FormsToCore;
begin
  CoreForm.ShowForm( adsForms.FieldByName( 'FullCode').AsInteger,
    adsNames.FieldByName( 'Name').AsString, adsForms.FieldByName( 'Form').AsString,
    actUseForms.Checked, False);
end;

procedure TNamesFormsForm.CatalogToCore;
begin
  CoreForm.ShowForm( adsCatalog.FieldByName( 'FullCode').AsInteger,
    adsCatalog.FieldByName( 'Name').AsString, adsCatalog.FieldByName( 'Form').AsString,
    True, True);
end;

initialization
  SearchInBegin := False;
end.