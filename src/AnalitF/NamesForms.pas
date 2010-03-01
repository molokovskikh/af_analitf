unit NamesForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Placemnt, DB, StdCtrls, ExtCtrls, Grids, DBGrids,
  RXDBCtrl, ActnList, DBGridEh, ToughDBGrid, OleCtrls, SHDocVw, FIBDataSet,
  pFIBDataSet, Registry, ForceRus, StrUtils, GridsEh, MemDS, DBAccess,
  MyAccess, Menus, Buttons, U_framePosition;

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
    pmNotFoundPositions: TPopupMenu;
    miNotFound: TMenuItem;
    miViewOrdersHistory: TMenuItem;
    gbFilters: TGroupBox;
    cbMnnFilter: TComboBox;
    lUsedFilter: TLabel;
    sbShowSynonymMNN: TSpeedButton;
    actShowSynonymMNN: TAction;
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
    procedure dbgNamesExit(Sender: TObject);
    procedure miViewOrdersHistoryClick(Sender: TObject);
    procedure cbMnnFilterSelect(Sender: TObject);
    procedure sbShowSynonymMNNClick(Sender: TObject);
    procedure actShowSynonymMNNExecute(Sender: TObject);
  private
    fr : TForceRus;
    BM : TBitmap;
    InternalSearchText : String;
    LastDBGrid : TWinControl;
    procedure SetNamesParams;
    procedure SetFormsParams;
    procedure AddKeyToSearch(Key : Char);
    procedure SetGrids;
    procedure NamesToCore(MouseClick : Boolean);
    procedure FormsToCore(MouseClick : Boolean);
    procedure CatalogToCore(MouseClick : Boolean);
    procedure ShowNotFoundPositionsPopup(Grid : TToughDBGrid; MouseClick : Boolean);
  protected
    InternalMnnId : Int64;
    InternalFilterMnn : Integer;
    GotoFromMNNSearch : Boolean;
    namesFrame : TframePosition;
    formsFrame : TframePosition;
    procedure DoShow; override;
    procedure CheckCanFocus;
    procedure SetUsedFilter;
    procedure ApplyMNNFilters;
    procedure DeleteLastMNNFilter;
  public
    procedure ShowForm; override;
    procedure SetCatalog;
  end;

procedure ShowOrderAll;

procedure FlipToCode(FullCode, ShortCode: Integer; CoreId : Int64{; APrevForm : TChildForm = nil});

procedure FlipToMNN(MnnId : Int64);

procedure FlipToMNNFromMNNSearch(MnnId : Int64);

implementation

uses DModule, AProc, Core, Main, Types, AlphaUtils, LU_Tracer, PreviousOrders,
     MnnSearch;

{$R *.dfm}

var
  SearchInBegin : Boolean;

type
  TDelayPopupMenuThread = class(TThread)
   protected
     procedure Execute; override;
   public
    f : TNamesFormsForm;
  end;

procedure ShowOrderAll;
begin
  MainForm.ShowChildForm(TNamesFormsForm);
end;

procedure FlipToCode(FullCode, ShortCode: Integer; CoreId : Int64{;
APrevForm : TChildForm = nil});
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

{
    if Assigned(APrevForm) then
      CoreForm.SetPrevForm(APrevForm);
}
		CoreForm.adsCore.Locate( 'CoreId', CoreId, []);
	end;
end;

procedure FlipToMNN(MnnId : Int64);
begin
  ShowOrderAll;

  with TNamesFormsForm( MainForm.ActiveChild) do
  begin
    InternalMnnId := MnnId;
    sbShowSynonymMNN.Down := True;
    sbShowSynonymMNN.Caption := 'Убрать синонимы (Esc)';
    InternalFilterMnn := 0;
    cbMnnFilter.ItemIndex := 0;
    if actNewSearch.Checked then
      SetCatalog
    else begin
      SetNamesParams;
      SetFormsParams;
    end;
  end;
end;

procedure FlipToMNNFromMNNSearch(MnnId : Int64);
var
  _CatalogForm : TNamesFormsForm;
begin
  _CatalogForm := TNamesFormsForm( FindChildControlByClass(MainForm, TNamesFormsForm) );
  if not Assigned(_CatalogForm) then
    _CatalogForm := TNamesFormsForm.Create(Application)
  else
    _CatalogForm.ShowForm;
  with _CatalogForm do
  begin
    InternalMnnId := MnnId;
    sbShowSynonymMNN.Down := True;
    sbShowSynonymMNN.Caption := 'Убрать синонимы (Esc)';
    InternalFilterMnn := 0;
    cbMnnFilter.ItemIndex := 0;
    if actNewSearch.Checked then begin
      SetCatalog;
      dbgCatalog.SetFocus;
    end
    else begin
      SetNamesParams;
      SetFormsParams;
      dbgNames.SetFocus;
    end;
  end;
end;

procedure TNamesFormsForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
begin
	inherited;

  InternalMnnId := -1;
  sbShowSynonymMNN.Down := False;
  sbShowSynonymMNN.Caption := 'Показать синонимы (Ctrl+N)';
  InternalFilterMnn := 0;

  TframePosition.AddFrame(Self, pnlTop, dsCatalog, 'FullName', 'Mnn', ShowDescriptionAction);
  formsFrame := TframePosition.AddFrame(Self, pClient, dsForms, 'FullName', 'Mnn', ShowDescriptionAction);
  formsFrame.Visible := False;
  namesFrame := TframePosition.AddFrame(Self, pClient, dsNames, 'FullName', 'Mnn', ShowDescriptionAction);

  LastDBGrid := nil;

  BM := TBitmap.Create;

  InternalSearchText := '';
  
  NeedFirstOnDataSet := False;

  fr := TForceRus.Create;

  //Читаем настройки из реестра
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

  CoreForm := TCoreForm( FindChildControlByClass(MainForm, TCoreForm) );
  if CoreForm = nil then
    CoreForm := TCoreForm.Create(Application);

  PreviousOrdersForm := TPreviousOrdersForm(FindChildControlByClass(MainForm, TPreviousOrdersForm) );
  if PreviousOrdersForm = nil then
    PreviousOrdersForm := TPreviousOrdersForm.Create(Application);

  SetGrids;

  dbgNames.PopupMenu := nil;
  dbgNames.Options := dbgNames.Options - [dgColumnResize];
  dbgForms.PopupMenu := nil;
  dbgForms.Options := dbgForms.Options - [dgColumnResize];
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
  with DM.adtParams do
  begin
    Edit;
    FieldByName( 'UseForms').AsBoolean := actUseForms.Checked;
    FieldByName( 'ShowAllCatalog').AsBoolean := actShowAll.Checked;
    Post;
  end;
  fr.Free;
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID, True);
  Reg.WriteBool('NewSearch', actNewSearch.Checked);
	Reg.Free;
  BM.Free;
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
var
  FilterSQL,
  InternalFilterMnnSQL : String;
begin
  Screen.Cursor:=crHourglass;
  try
    adsForms.Close;
    if adsNames.Active then
      adsNames.Close;

    FilterSQL := '';
    if InternalMnnId > 0 then
      FilterSQL := ' (Mnn.Id = ' + IntToStr(InternalMnnId) + ') ';

    if (InternalFilterMnn > 0) then begin
      if (InternalFilterMnn = 1) then
        InternalFilterMnnSQL := ' (CATALOGS.VitallyImportant = 1) '
      else
        InternalFilterMnnSQL := ' (CATALOGS.MandatoryList = 1) ';
      if Length(FilterSQL) > 0 then
        FilterSQL := FilterSQL + ' and ' + InternalFilterMnnSQL
      else
        FilterSQL := InternalFilterMnnSQL;
    end;

    if actShowAll.Checked then begin
      adsNames.SQL.Text := ''
      +'SELECT '
      +'  CATALOGS.ShortCode AS AShortCode, '
      +'  CATALOGS.FullCode, '
      +'  CATALOGS.Name, '
      +'  CATALOGS.Name as FullName, '
      +'  CATALOGS.DescriptionId, '
      +'  sum(catalogs.VitallyImportant) as CatalogVitallyImportant, '
      +'  sum(catalogs.MandatoryList) as CatalogMandatoryList, '
      +'  sum(CATALOGS.CoreExists) as CoreExists, '
      +'  Mnn.Id as MnnId, '
      +'  Mnn.Mnn '
      +'FROM CATALOGS '
      +'  left join Mnn on mnn.Id = CATALOGS.MnnId ';

      if Length(FilterSQL) > 0 then
        adsNames.SQL.Text := adsNames.SQL.Text+ ' where ' + FilterSQL;

      adsNames.SQL.Text := adsNames.SQL.Text
      +'group by CATALOGS.ShortCode, CATALOGS.Name '
      +'ORDER BY CATALOGS.Name;';

      adsForms.SQL.Text := '' +
      'SELECT CATALOGS.FullCode, CATALOGS.Form, catalogs.coreexists, '
      +'  concat(CATALOGS.Name, '' '', CATALOGS.Form) as FullName, '
      +'  CATALOGS.DescriptionId, '
      +'  catalogs.VitallyImportant as CatalogVitallyImportant, '
      +'  catalogs.MandatoryList as CatalogMandatoryList, '
      +'  Mnn.Id as MnnId, '
      +'  Mnn.Mnn '
      +' FROM CATALOGS '
      +'  left join Mnn on mnn.Id = Catalogs.MnnId '
      +' WHERE CATALOGS.ShortCode = :ashortcode ';

      if Length(FilterSQL) > 0 then
        adsForms.SQL.Text := adsForms.SQL.Text+ ' and ' + FilterSQL;

      adsForms.SQL.Text := adsForms.SQL.Text
      + 'order by CATALOGS.Form;';
    end
    else begin
      adsNames.SQL.Text := ''
      +'SELECT '
      +'  CATALOGS.ShortCode AS AShortCode, '
      +'  CATALOGS.FullCode, '
      +'  CATALOGS.Name, '
      +'  CATALOGS.Name as FullName, '
      +'  CATALOGS.DescriptionId, '
      +'  sum(catalogs.VitallyImportant) as CatalogVitallyImportant, '
      +'  sum(catalogs.MandatoryList) as CatalogMandatoryList, '
      +'  sum(CATALOGS.CoreExists) as CoreExists, '
      +'  Mnn.Id as MnnId, '
      +'  Mnn.Mnn '
      +'FROM CATALOGS '
      +'  left join Mnn on mnn.Id = CATALOGS.MnnId '
      +'where '
      +'   (CATALOGS.CoreExists = 1) ';

      if Length(FilterSQL) > 0 then
        adsNames.SQL.Text := adsNames.SQL.Text+ ' and ' + FilterSQL;

      adsNames.SQL.Text := adsNames.SQL.Text
      +'group by CATALOGS.ShortCode, CATALOGS.Name '
      +'ORDER BY CATALOGS.Name;';

      adsForms.SQL.Text := '' +
      'SELECT CATALOGS.FullCode, CATALOGS.Form, catalogs.coreexists, '
      +'  concat(CATALOGS.Name, '' '', CATALOGS.Form) as FullName, '
      +'  CATALOGS.DescriptionId, '
      +'  catalogs.VitallyImportant as CatalogVitallyImportant, '
      +'  catalogs.MandatoryList as CatalogMandatoryList, '
      +'  Mnn.Id as MnnId, '
      +'  Mnn.Mnn '
      +' FROM CATALOGS '
      +'  left join Mnn on mnn.Id = Catalogs.MnnId '
      +' WHERE CATALOGS.ShortCode = :ashortcode ' +
      'and catalogs.coreexists = 1 ';

      if Length(FilterSQL) > 0 then
        adsForms.SQL.Text := adsForms.SQL.Text+ ' and ' + FilterSQL;

      adsForms.SQL.Text := adsForms.SQL.Text
      + 'order by CATALOGS.Form;';
    end;

    adsNames.Open;
    adsForms.Open;
    SetUsedFilter;
  finally
    Screen.Cursor := crDefault;
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
	if Key = VK_RETURN then
    NamesToCore(False);
  if (Key = VK_ESCAPE) and ((InternalMnnId > 0) or (InternalFilterMnn > 0)) then
  begin
    DeleteLastMNNFilter;
    Exit;
  end
  else
    if (Key = VK_ESCAPE) and Assigned(Self.PrevForm) and (Self.PrevForm is TMnnSearchForm) then
    begin
      tmrSearch.Enabled := False;
      Self.PrevForm.ShowForm;
      MainForm.AddFormToFree(Self);
    end;
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
    NamesToCore(False);
end;

procedure TNamesFormsForm.dbgNamesEnter(Sender: TObject);
begin
	dbgNames.Color := clWindow;
	dbgForms.Color := clBtnFace;
  namesFrame.Visible := True;
  formsFrame.Visible := False;
end;

procedure TNamesFormsForm.dbgFormsEnter(Sender: TObject);
begin
	dbgNames.Color := clBtnFace;
	dbgForms.Color := clWindow;
	dbgForms.Options := dbgForms.Options + [dgAlwaysShowSelection]; 
  formsFrame.Visible := True;
  namesFrame.Visible := False;
end;

procedure TNamesFormsForm.dbgFormsExit(Sender: TObject);
begin
  dbgForms.Options := dbgForms.Options - [dgAlwaysShowSelection];
  LastDBGrid := dbgForms;
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
    FormsToCore(True);
end;

procedure TNamesFormsForm.dbgFormsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	inherited;
  if Key = VK_RETURN then
    FormsToCore(False);
	if ( Key = VK_ESCAPE){ or ( Key = VK_SPACE)} then dbgNames.SetFocus;
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
var
  ShortCode, FullCode : Variant;
  NamesIsFocus : Boolean;
begin
  CheckCanFocus;

	actShowAll.Checked := not actShowAll.Checked;

  if actNewSearch.Checked then begin
    if Length(InternalSearchText) > 0 then
      tmrSearchTimer(nil)
    else
      SetCatalog;
    dbgCatalog.SetFocus
  end
  else begin
    NamesIsFocus := LastDBGrid = dbgNames;
    ShortCode := adsNames.FieldByName('AShortCode').Value;
    if not NamesIsFocus then
      FullCode := adsForms.FieldByName('FullCode').Value;
    SetNamesParams;

    if adsNames.Locate('AShortCode', ShortCode, []) then begin
      if NamesIsFocus then
        dbgNames.SetFocus
      else
        if adsForms.Locate('FullCode', FullCode, []) then
          dbgForms.SetFocus
        else begin
          adsForms.First;
          dbgForms.SetFocus;
        end
    end
    else begin
      adsNames.First;
      dbgNames.SetFocus;
    end
  end;

end;

procedure TNamesFormsForm.SetCatalog;
var
  FilterSQL,
  InternalFilterMnnSQL : String;
begin
  FilterSQL := '';
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
      SQL.Text := ''
      +'SELECT '
      +'  CATALOGS.ShortCode, '
      +'  CATALOGS.Name, '
      +'  CATALOGS.fullcode, '
      +'  CATALOGS.form, '
      +'  CATALOGS.COREEXISTS, '
      +'  concat(CATALOGS.Name, '' '', CATALOGS.Form) as FullName, '
      +'  CATALOGS.DescriptionId, '
      +'  catalogs.VitallyImportant as CatalogVitallyImportant, '
      +'  catalogs.MandatoryList as CatalogMandatoryList, '
      +'  Mnn.Id as MnnId, '
      +'  Mnn.Mnn '
      +'FROM '
      +'  CATALOGS '
      +'  left join Mnn on mnn.Id = Catalogs.MnnId ';
      if not actShowAll.Checked then
        FilterSQL := ' (CATALOGS.COREEXISTS = 1) ';
      if InternalMnnId > 0 then
        if Length(FilterSQL) > 0 then
          FilterSQL := FilterSQL + ' and (Mnn.Id = ' + IntToStr(InternalMnnId) + ') '
        else
          FilterSQL := ' (Mnn.Id = ' + IntToStr(InternalMnnId) + ') ';
      if (InternalFilterMnn > 0) then begin
        if (InternalFilterMnn = 1) then
          InternalFilterMnnSQL := ' (Catalogs.VitallyImportant = 1) '
        else
          InternalFilterMnnSQL := '(Catalogs.MandatoryList = 1) ';
        if Length(FilterSQL) > 0 then
          FilterSQL := FilterSQL + ' and ' + InternalFilterMnnSQL
        else
          FilterSQL := InternalFilterMnnSQL;
      end;
      if Length(FilterSQL) > 0 then
        SQL.Text := SQL.Text + ' where ' + FilterSQL;
      SQL.Text := SQL.Text + ' order by CATALOGS.Name, CATALOGS.form ';
      Open;
      SetUsedFilter;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TNamesFormsForm.tmrShowCatalogTimer(Sender: TObject);
begin
  try
    if actNewSearch.Checked then begin
      if dbgCatalog.CanFocus then begin
        dbgCatalog.SetFocus;
        tmrShowCatalog.Enabled := False;
      end;
    end
    else
      if not dbgForms.Focused and dbgNames.CanFocus then
      begin
        dbgNames.SetFocus;
        tmrShowCatalog.Enabled := False;
      end;
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
  if Length(eSearch.Text) > 2 then
  begin
    InternalSearchText := LeftStr(eSearch.Text, 50);
    eSearch.Text := '';
    adsCatalog.Close;
    adsCatalog.SQL.Text := ''
      +'SELECT '
      +'  CATALOGS.ShortCode, '
      +'  CATALOGS.Name, '
      +'  CATALOGS.fullcode, '
      +'  CATALOGS.form, '
      +'  CATALOGS.COREEXISTS, '
      +'  concat(CATALOGS.Name, '' '', CATALOGS.Form) as FullName, '
      +'  CATALOGS.DescriptionId, '
      +'  catalogs.VitallyImportant as CatalogVitallyImportant, '
      +'  catalogs.MandatoryList as CatalogMandatoryList, '
      +'  Mnn.Id as MnnId, '
      +'  Mnn.Mnn '
      +'FROM '
      +'  CATALOGS '
      +'  left join Mnn on mnn.Id = Catalogs.MnnId '
      +'where '
      +'  ((upper(Name) like upper(:LikeParam)) or (upper(Form) like upper(:LikeParam)))';
    if not actShowAll.Checked then
      adsCatalog.SQL.Text := adsCatalog.SQL.Text + ' and (CATALOGS.COREEXISTS = 1) ';
    if InternalMnnId > 0 then
      adsCatalog.SQL.Text := adsCatalog.SQL.Text + ' and (Mnn.Id = ' + IntToStr(InternalMnnId) + ') ';
    if (InternalFilterMnn > 0) then
      if (InternalFilterMnn = 1) then
        adsCatalog.SQL.Text := adsCatalog.SQL.Text + ' and (CATALOGS.VitallyImportant = 1) '
      else
        adsCatalog.SQL.Text := adsCatalog.SQL.Text + ' and (CATALOGS.MandatoryList = 1) ';
    adsCatalog.SQL.Text := adsCatalog.SQL.Text + ' order by CATALOGS.Name, CATALOGS.form ';
    adsCatalog.ParamByName('LikeParam').AsString := iif(SearchInBegin, '', '%') + InternalSearchText + '%';
    adsCatalog.Open;
    SetUsedFilter;
    dbgCatalog.SetFocus;
  end;
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
      CatalogToCore(False);
  end
  else
    if Key = VK_ESCAPE then begin
      if ((InternalMnnId > 0) or (InternalFilterMnn > 0)) then
        DeleteLastMNNFilter
      else
        if (Length(InternalSearchText) > 0) or (Length(eSearch.Text) > 0) then
          SetCatalog
        else
          if Assigned(Self.PrevForm) and (Self.PrevForm is TMnnSearchForm) then begin
            tmrSearch.Enabled := False;
            Self.PrevForm.ShowForm;
          end;
    end
    else
      if Key = VK_BACK then begin
        tmrSearch.Enabled := False;
        eSearch.Text := Copy(eSearch.Text, 1, Length(eSearch.Text)-1);
        tmrSearch.Enabled := True;
      end;
end;

procedure TNamesFormsForm.dbgCatalogDblClick(Sender: TObject);
var
  C : GridsEh.TGridCoord;
  P : TPoint;
begin
  p := dbgCatalog.ScreenToClient(Mouse.CursorPos);
  C := dbgCatalog.MouseCoord(p.X, p.Y);
  if C.Y > 0 then
    CatalogToCore(True);
end;

procedure TNamesFormsForm.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //Если мы что-то нажали в элементе, то должны на это отреагировать
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

procedure TNamesFormsForm.NamesToCore(MouseClick : Boolean);
begin
  if not actUseForms.Checked then
    if (adsNames.FieldByName('COREEXISTS').AsFloat < 0.001 ) then
      ShowNotFoundPositionsPopup(dbgNames, MouseClick)
    else
      CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
        adsNames.FieldByName( 'Name').AsString, '', actUseForms.Checked, False);
  if actUseForms.Checked and ( adsForms.RecordCount < 2) then
    if not adsForms.FieldByName('COREEXISTS').AsBoolean then
      ShowNotFoundPositionsPopup(dbgNames, MouseClick)
    else
      CoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
        adsNames.FieldByName( 'Name').AsString,
        adsForms.FieldByName( 'Form').AsString, False, False);
  if actUseForms.Checked and ( adsForms.RecordCount > 1) then
    dbgForms.SetFocus;
end;

procedure TNamesFormsForm.FormsToCore(MouseClick : Boolean);
begin
  if not adsForms.FieldByName('COREEXISTS').AsBoolean then
    ShowNotFoundPositionsPopup(dbgForms, MouseClick)
  else
    CoreForm.ShowForm( adsForms.FieldByName( 'FullCode').AsInteger,
      adsNames.FieldByName( 'Name').AsString, adsForms.FieldByName( 'Form').AsString,
      actUseForms.Checked, False);
end;

procedure TNamesFormsForm.CatalogToCore(MouseClick : Boolean);
begin
  if not adsCatalog.FieldByName('COREEXISTS').AsBoolean then
    ShowNotFoundPositionsPopup(dbgCatalog, MouseClick)
  else
    CoreForm.ShowForm( adsCatalog.FieldByName( 'FullCode').AsInteger,
      adsCatalog.FieldByName( 'Name').AsString, adsCatalog.FieldByName( 'Form').AsString,
      True, True);
end;

procedure TNamesFormsForm.dbgNamesExit(Sender: TObject);
begin
  LastDBGrid := dbgNames;
end;

{ TDelayPopupMenuThread }

procedure TDelayPopupMenuThread.Execute;
begin
  //Это хак, чтобы подсветилось первый пункт в PopupMenu
  //взято отсюда: http://www.eggheadcafe.com/conversation.aspx?messageid=29197437&threadid=29197437
  Sleep(100);
  keybd_event( VK_DOWN, MapVirtualKey( VK_DOWN,0), 0, 0);
end;

procedure TNamesFormsForm.miViewOrdersHistoryClick(Sender: TObject);
begin
  if actNewSearch.Checked then
    PreviousOrdersForm.ShowForm(adsCatalog.FieldByName( 'FullCode').AsInteger, False)
  else
    if LastDBGrid = dbgNames then
      PreviousOrdersForm.ShowForm(adsNames.FieldByName('AShortCode').AsInteger, True)
    else
      PreviousOrdersForm.ShowForm(adsForms.FieldByName('FullCode').AsInteger, False);
end;

procedure TNamesFormsForm.ShowNotFoundPositionsPopup(Grid: TToughDBGrid;
MouseClick : Boolean);
var
  P : TPoint;
  t : TDelayPopupMenuThread;
  GridCellRect : TRect;
begin
  t := TDelayPopupMenuThread.Create(true);
  t.FreeOnTerminate := True;
  t.f := Self;
  t.Resume;
  if not MouseClick then begin
    GridCellRect := Grid.CellRect(Grid.Col, Grid.Row);
    P := Grid.ClientToScreen(Point(GridCellRect.Left, GridCellRect.Top));
    pmNotFoundPositions.Popup(P.X, P.Y + 20)
  end
  else
    pmNotFoundPositions.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TNamesFormsForm.CheckCanFocus;
begin
  if actNewSearch.Checked then begin
    if not dbgCatalog.CanFocus then Abort;
  end
  else
    if not dbgNames.CanFocus then Abort;
end;

procedure TNamesFormsForm.SetUsedFilter;
var
  mnnName : String;
  filterText : String;
begin
  filterText := '';
  if (InternalMnnId > 0) or (InternalFilterMnn > 0) then begin
    if actNewSearch.Checked then
      mnnName := adsCatalog.FieldByName('Mnn').AsString
    else
      mnnName := adsNames.FieldByName('Mnn').AsString;
    if (InternalMnnId > 0) then begin
      filterText := 'Фильтр по  "' + mnnName +'"';
      if (InternalFilterMnn = 1) then
        filterText := filterText + '  только жизненно важные'
      else
        if (InternalFilterMnn = 2) then
          filterText := filterText + '  только обязательный ассортимент';

    end
    else
      if (InternalFilterMnn = 1) then
        filterText := 'Фильтр по жизненно важным'
      else
        if (InternalFilterMnn = 2) then
          filterText := 'Фильтр по обязательному ассортименту';
  end;
  lUsedFilter.Caption := filterText;
end;

procedure TNamesFormsForm.cbMnnFilterSelect(Sender: TObject);
begin
  CheckCanFocus;
  InternalMnnId := -1;
  sbShowSynonymMNN.Down := False;
  sbShowSynonymMNN.Caption := 'Показать синонимы (Ctrl+N)';
  InternalFilterMnn := TComboBox(Sender).ItemIndex;
  ApplyMNNFilters;
end;

procedure TNamesFormsForm.ApplyMNNFilters;
var
  ShortCode, FullCode : Variant;
begin
  if actNewSearch.Checked then begin
    FullCode := adsCatalog.FieldByName('FullCode').Value;
    SetCatalog;
    if not adsCatalog.Locate('FullCode', FullCode, []) then
      adsCatalog.First;
    dbgCatalog.SetFocus();
  end
  else begin
    ShortCode := adsNames.FieldByName('AShortCode').Value;
    SetNamesParams;
    if not adsNames.Locate('AShortCode', ShortCode, []) then
      adsNames.First;
    dbgNames.SetFocus();
  end;
end;

procedure TNamesFormsForm.DeleteLastMNNFilter;
begin
  if (InternalMnnId > 0) then begin
    InternalMnnId := -1;
    sbShowSynonymMNN.Down := False;
    sbShowSynonymMNN.Caption := 'Показать синонимы (Ctrl+N)';
  end
  else
    if (InternalFilterMnn > 0) then begin
      cbMnnFilter.ItemIndex := 0;
      InternalFilterMnn := 0;
    end;
  ApplyMNNFilters;
end;

procedure TNamesFormsForm.sbShowSynonymMNNClick(Sender: TObject);
var
  MnnField : TField;
begin
  try
  CheckCanFocus;
  if sbShowSynonymMNN.Down then begin
    if actNewSearch.Checked then
      MnnField := adsCatalog.FindField('MnnId')
    else
      MnnField := adsNames.FindField('MnnId');
    if Assigned(MnnField) and (MnnField is TLargeintField)
      and not TLargeintField(MnnField).IsNull
      and (TLargeintField(MnnField).Value <> InternalMnnId)
    then begin
      InternalMnnId := TLargeintField(MnnField).Value;
      ApplyMNNFilters;
    end
    else
      Abort;
    sbShowSynonymMNN.Caption := 'Убрать синонимы (Esc)';
  end
  else begin
    InternalMnnId := -1;
    ApplyMNNFilters;
    sbShowSynonymMNN.Caption := 'Показать синонимы (Ctrl+N)';
  end;
  except
    on E : EAbort do
      sbShowSynonymMNN.Down := not sbShowSynonymMNN.Down;
  end;
end;

procedure TNamesFormsForm.actShowSynonymMNNExecute(Sender: TObject);
begin
  if not sbShowSynonymMNN.Down then begin
    sbShowSynonymMNN.Down := True;
    sbShowSynonymMNN.Click;
  end;
end;

initialization
  SearchInBegin := False;
end.
