unit NamesForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Placemnt, DB, StdCtrls, ExtCtrls, Grids, DBGrids,
  RXDBCtrl, ActnList, DBGridEh, ToughDBGrid, OleCtrls, SHDocVw,
  Registry, ForceRus, StrUtils, GridsEh, MemDS, DBAccess,
  MyAccess, Menus, Buttons, U_framePosition, PreviousOrders, Core,
  U_frameContextReclame,
  U_ShowPromotionsForm,
  PromotionLabel,
  U_framePromotion;

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
    procedure adsFormsAfterScroll(DataSet: TDataSet);
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
    procedure actUseFormsUpdate(Sender: TObject);
    procedure adsCatalogAfterScroll(DataSet: TDataSet);
  private
    fr : TForceRus;
    BM : TBitmap;
    InternalSearchText : String;
    LastDBGrid : TWinControl;
    FPreviousOrdersForm : TPreviousOrdersForm;
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
    pAdvertisingOldCatalog : TPanel;
    pAdvertisingNewCatalog : TPanel;
    pForms : TPanel;
    //frameContextReclame : TframeContextReclame;
    framePromotion : TframePromotion;
    FCoreForm: TCoreForm;
    procedure DoShow; override;
    procedure CheckCanFocus;
    procedure SetUsedFilter;
    procedure ApplyMNNFilters;
    procedure DeleteLastMNNFilter;
    procedure SaveActionStates;
    procedure PrepareAdvertisingPanel;
    procedure PrepareFormsGridPanel;
  public
    procedure ShowForm; override;
    procedure SetCatalog;
    procedure ReturnFromCore;
  end;

procedure ShowOrderAll;

procedure FlipToCode(FullCode, ShortCode: Integer; CoreId : Int64);

procedure FlipToCodeWithReturn(FullCode, ShortCode: Integer; CoreId : Int64);

procedure FlipToMNN(MnnId : Int64);

procedure FlipToMNNFromMNNSearch(MnnId : Int64);

implementation

uses DModule, AProc, Main, Types, AlphaUtils, LU_Tracer,
     MnnSearch,
     UniqueID,
     U_ExchangeLog,
     DBGridHelper;

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

  THackChildForm = class(TChildForm);

procedure ShowOrderAll;
begin
  //Это хак: если текущей активной формой является форма "Сводный прайс-лист", а у нее предыдущая форма "Поиск в каталоге",
  //то отображаем форму "Поиск в каталоге" как предыдущую форму
  if (MainForm.ActiveChild is TCoreForm) and (THackChildForm(MainForm.ActiveChild).PrevForm is TNamesFormsForm)
  then
    TNamesFormsForm(THackChildForm(MainForm.ActiveChild).PrevForm).ReturnFromCore
  else
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
      FCoreForm.ShowForm( adsCatalog.FieldByName( 'FullCode').AsInteger,
        adsCatalog.FieldByName( 'Name').AsString, adsCatalog.FieldByName( 'Form').AsString,
        True, True);
    end
    else begin
      adsNames.Locate( 'AShortCode', ShortCode, []);

      if not actUseForms.Checked then
        FCoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
          adsNames.FieldByName( 'Name').AsString, '', actUseForms.Checked, False);
      if actUseForms.Checked and ( adsForms.RecordCount < 2) then
        FCoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
          adsNames.FieldByName( 'Name').AsString,
          adsForms.FieldByName( 'Form').AsString, False, False);
      if actUseForms.Checked and ( adsForms.RecordCount > 1) then
      begin
        adsForms.Locate( 'FullCode', FullCode, []);
        FCoreForm.ShowForm( adsForms.FieldByName( 'FullCode').AsInteger,
          adsNames.FieldByName( 'Name').AsString,
          adsForms.FieldByName( 'Form').AsString,
          actUseForms.Checked, False);
      end;
    end;

    FCoreForm.adsCore.Locate( 'CoreId', CoreId, []);
  end;
end;

procedure FlipToCodeWithReturn(FullCode, ShortCode: Integer; CoreId : Int64);
var
  FCoreForm : TCoreForm;
  productName, productForm : String;
  currentBookmark : String;
begin
  productName := '';
  productForm := '';
  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text := 'select Name, Form from catalogs where FullCode = :FullCode';
  DM.adsQueryValue.ParamByName('FullCode').Value := FullCode;
  DM.adsQueryValue.Open;
  try
    if DM.adsQueryValue.RecordCount > 0 then begin
      productName := DM.adsQueryValue.FieldByName('Name').AsString;
      productForm := DM.adsQueryValue.FieldByName('Form').AsString;
    end;
  finally
    DM.adsQueryValue.Close;
  end;

  if (productName <> '') then begin
    FCoreForm := TCoreForm( FindChildControlByClass(MainForm, TCoreForm) );
    if FCoreForm = nil then
      FCoreForm := TCoreForm.Create(Application);
    FCoreForm.ShowForm(
      FullCode,
      productName,
      productForm,
      True, True);
    if CoreId > 0 then begin
      currentBookmark := FCoreForm.adsCore.Bookmark;
      if not FCoreForm.adsCore.Locate( 'CoreId', CoreId, []) then
        FCoreForm.adsCore.Bookmark := currentBookmark;
    end;
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
  PrepareFormsGridPanel;
  PrepareAdvertisingPanel;

  inherited;

  if not DM.adsUser.FieldByName('ShowAdvertising').IsNull
    and not DM.adsUser.FieldByName('ShowAdvertising').AsBoolean
  then begin
    pAdvertisingOldCatalog.Visible := False;
    pAdvertisingNewCatalog.Visible := False;
  end;
  InternalMnnId := -1;
  sbShowSynonymMNN.Down := False;
  sbShowSynonymMNN.Caption := 'Показать синонимы (Ctrl+N)';
  InternalFilterMnn := 0;

  TframePosition.AddFrame(Self, pnlTop, dsCatalog, 'FullName', 'MnnId', ShowDescriptionAction);
  formsFrame := TframePosition.AddFrame(Self, pForms, dsForms, 'FullName', 'MnnId', ShowDescriptionAction);
  formsFrame.Visible := False;
  namesFrame := TframePosition.AddFrame(Self, pForms, dsNames, 'FullName', 'MnnId', ShowDescriptionAction);
  //frameContextReclame := TframeContextReclame.AddFrame(Self, Self);

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
      actUseForms.Checked := True
    else
      actUseForms.Checked := FieldByName( 'UseForms').AsBoolean;
    actShowAll.Checked := FieldByName( 'ShowAllCatalog').AsBoolean;
  end;

  FCoreForm := TCoreForm( FindChildControlByClass(MainForm, TCoreForm) );
  if FCoreForm = nil then
    FCoreForm := TCoreForm.Create(Application);

  FPreviousOrdersForm := TPreviousOrdersForm(FindChildControlByClass(MainForm, TPreviousOrdersForm) );
  if FPreviousOrdersForm = nil then
    FPreviousOrdersForm := TPreviousOrdersForm.Create(Application);

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
begin
  inherited;
  SaveActionStates;
  fr.Free;
  BM.Free;
end;

procedure TNamesFormsForm.actUseFormsExecute(Sender: TObject);
begin
  if not dbgNames.CanFocus then exit;
  actUseForms.Checked := not actUseForms.Checked;
  SaveActionStates; 
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
      +'  catalogs.PromotionsCount, '
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
      +'  catalogs.PromotionsCount, '
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
    if (Key = VK_ESCAPE) and Assigned(Self.PrevForm) and not (Self.PrevForm is TCoreForm) then
    begin
      tmrSearch.Enabled := False;
      MainForm.AddFormToFree(Self);
      Self.PrevForm.ShowAsPrevForm;
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
  //frameContextReclame.GetReclame(adsForms.FieldByName( 'FullCode').AsInteger);
end;

procedure TNamesFormsForm.dbgFormsExit(Sender: TObject);
begin
  dbgForms.Options := dbgForms.Options - [dgAlwaysShowSelection];
  LastDBGrid := dbgForms;
  //frameContextReclame.StopReclame();
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

procedure TNamesFormsForm.adsFormsAfterScroll(DataSet: TDataSet);
var
  rowHeight : Integer;
begin
  if Assigned(pAdvertisingOldCatalog) and
   (DM.adsUser.FieldByName('ShowAdvertising').IsNull or DM.adsUser.FieldByName('ShowAdvertising').AsBoolean)
  then begin
    rowHeight := TDBGridHelper.GetStdDefaultRowHeight(dbgForms);
    if (adsForms.RecordCount > 0) and ((adsForms.RecordCount*rowHeight)/(pClient.Height-pAdvertisingOldCatalog.Height) > 13/10) then
      pAdvertisingOldCatalog.Visible := False
    else begin
      if not pAdvertisingOldCatalog.Visible then begin
        pAdvertisingOldCatalog.Visible := True;
{
        formsFrame.Top := pAdvertisingOldCatalog.Top - (formsFrame.Height + 1);
        namesFrame.Top := formsFrame.Top - (namesFrame.Height + 1);
}        
      end;
    end;
  end;
  if Assigned(pAdvertisingOldCatalog) and pAdvertisingOldCatalog.Visible and adsForms.Active and not adsForms.IsEmpty
  then begin
    if adsForms.FieldByName('PromotionsCount').AsInteger > 0 then
      framePromotion.ShowPromotion(
        adsForms.FieldByName('FullCode').AsInteger,
        adsForms.FieldByName('PromotionsCount').AsInteger)
    else
      framePromotion.Hide();
  end;
{$ifdef DEBUG}
  if adsForms.Active and not adsForms.IsEmpty then
    WriteExchangeLog('adsFormsAfterScroll',
      Format('CatalogId : %s  Name : %s %s',
        [adsForms.FieldByName( 'FullCode').AsString,
         adsNames.FieldByName( 'Name').AsString,
         adsForms.FieldByName( 'Form').AsString
        ]));
{$endif}
{
  if dbgForms.Focused then
    frameContextReclame.GetReclame(adsForms.FieldByName( 'FullCode').AsInteger);
}
end;

procedure TNamesFormsForm.FormResize(Sender: TObject);
begin
  if not actNewSearch.Checked then begin
    if dbgNames.Constraints.MaxWidth <> pnlTopOld.ClientWidth div 2 then
      dbgNames.Constraints.MaxWidth := pnlTopOld.ClientWidth div 2;
    adsFormsAfterScroll(adsForms);
  end;
end;

procedure TNamesFormsForm.actShowAllExecute(Sender: TObject);
var
  ShortCode, FullCode : Variant;
  NamesIsFocus : Boolean;
begin
  CheckCanFocus;

  actShowAll.Checked := not actShowAll.Checked;
  SaveActionStates;
  
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
  Screen.Cursor:=crHourglass;
  try
    if adsCatalog.Active then adsCatalog.Close;
    adsCatalog.SQL.Text := ''
    +'SELECT '
    +'  CATALOGS.ShortCode, '
    +'  CATALOGS.Name, '
    +'  CATALOGS.fullcode, '
    +'  CATALOGS.form, '
    +'  CATALOGS.COREEXISTS, '
    +'  catalogs.PromotionsCount, '
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
      adsCatalog.SQL.Text := adsCatalog.SQL.Text + ' where ' + FilterSQL;
    adsCatalog.SQL.Text := adsCatalog.SQL.Text + ' order by CATALOGS.Name, CATALOGS.form ';
    adsCatalog.Open;
    SetUsedFilter;
  finally
    Screen.Cursor := crDefault;
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
      +'  catalogs.PromotionsCount, '
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
          if Assigned(Self.PrevForm) and not (Self.PrevForm is TCoreForm) then begin
            tmrSearch.Enabled := False;
            MainForm.AddFormToFree(Self);
            Self.PrevForm.ShowAsPrevForm;
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
    framePromotion.SetAdvertisingPanel(pAdvertisingNewCatalog);
    pnlTop.BringToFront;
    SetCatalog;
  end
  else begin
    framePromotion.SetAdvertisingPanel(pAdvertisingOldCatalog);
    pnlTopOld.BringToFront;
    SetNamesParams;
    SetFormsParams;
  end;
  tmrShowCatalog.Enabled := True;
end;

procedure TNamesFormsForm.actNewSearchExecute(Sender: TObject);
begin
  actNewSearch.Checked := not actNewSearch.Checked;
  SaveActionStates;
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
      FCoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
        adsNames.FieldByName( 'Name').AsString, '', actUseForms.Checked, False);
  if actUseForms.Checked and ( adsForms.RecordCount < 2) then
    if not adsForms.FieldByName('COREEXISTS').AsBoolean then
      ShowNotFoundPositionsPopup(dbgNames, MouseClick)
    else
      FCoreForm.ShowForm( adsNames.FieldByName( 'AShortCode').AsInteger,
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
    FCoreForm.ShowForm( adsForms.FieldByName( 'FullCode').AsInteger,
      adsNames.FieldByName( 'Name').AsString, adsForms.FieldByName( 'Form').AsString,
      actUseForms.Checked, False);
end;

procedure TNamesFormsForm.CatalogToCore(MouseClick : Boolean);
begin
  if not adsCatalog.FieldByName('COREEXISTS').AsBoolean then
    ShowNotFoundPositionsPopup(dbgCatalog, MouseClick)
  else
    FCoreForm.ShowForm( adsCatalog.FieldByName( 'FullCode').AsInteger,
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
    FPreviousOrdersForm.ShowForm(adsCatalog.FieldByName( 'FullCode').AsInteger, False)
  else
    if LastDBGrid = dbgNames then
      FPreviousOrdersForm.ShowForm(adsNames.FieldByName('AShortCode').AsInteger, True)
    else
      FPreviousOrdersForm.ShowForm(adsForms.FieldByName('FullCode').AsInteger, False);
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

procedure TNamesFormsForm.ReturnFromCore;
begin
  Self.ShowForm;
  if Self.actNewSearch.Checked then
     Self.dbgCatalog.SetFocus
  else
    if Self.actUseForms.Checked and (Self.adsForms.RecordCount > 1) then
      Self.dbgForms.SetFocus
    else
      Self.dbgNames.SetFocus;
end;

procedure TNamesFormsForm.actUseFormsUpdate(Sender: TObject);
begin
  if (MainForm.ActiveChild = Self) and DM.adtParams.FieldByName( 'OperateForms').AsBoolean
  then
    actUseForms.Enabled := True
  else
    actUseForms.Enabled := False;
end;

procedure TNamesFormsForm.SaveActionStates;
var
  Reg: TRegistry;
begin
  with DM.adtParams do
  begin
    Edit;
    FieldByName( 'UseForms').AsBoolean := actUseForms.Checked;
    FieldByName( 'ShowAllCatalog').AsBoolean := actShowAll.Checked;
    Post;
  end;
  Reg := TRegistry.Create;
  Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID, True);
  Reg.WriteBool('NewSearch', actNewSearch.Checked);
  Reg.Free;
end;

procedure TNamesFormsForm.PrepareAdvertisingPanel;
var
  oldTop : Integer;
begin
  pAdvertisingOldCatalog := TPanel.Create(Self);
  pAdvertisingOldCatalog.Parent := pWebBrowser.Parent;
  pAdvertisingOldCatalog.Name := 'pAdvertisingOldCatalog';
  pAdvertisingOldCatalog.Caption := '';
  pAdvertisingOldCatalog.Height := pWebBrowser.Height;
  oldTop := pWebBrowser.Top;
  pAdvertisingOldCatalog.Align := pWebBrowser.Align;
  pWebBrowser.Parent := pAdvertisingOldCatalog;
  pWebBrowser.Align := alClient;
  pAdvertisingOldCatalog.Top := oldTop;
  pAdvertisingOldCatalog.ControlStyle := pAdvertisingOldCatalog.ControlStyle - [csParentBackground] + [csOpaque];

  pAdvertisingNewCatalog := TPanel.Create(Self);
  pAdvertisingNewCatalog.Parent := pWebBrowserCatalog.Parent;
  pAdvertisingNewCatalog.Name := 'pAdvertisingNewCatalog';
  pAdvertisingNewCatalog.Caption := '';
  pAdvertisingNewCatalog.Height := pWebBrowserCatalog.Height;
  oldTop := pWebBrowserCatalog.Top;
  pAdvertisingNewCatalog.Align := pWebBrowserCatalog.Align;
  pWebBrowserCatalog.Parent := pAdvertisingNewCatalog;
  pWebBrowserCatalog.Align := alClient;
  pAdvertisingNewCatalog.Top := oldTop;
  pAdvertisingNewCatalog.ControlStyle := pAdvertisingNewCatalog.ControlStyle - [csParentBackground] + [csOpaque];

  framePromotion := TframePromotion.AddFrame(Self, Self, pAdvertisingOldCatalog);
end;

procedure TNamesFormsForm.adsCatalogAfterScroll(DataSet: TDataSet);
begin
  if Assigned(pAdvertisingNewCatalog) and pAdvertisingNewCatalog.Visible and adsCatalog.Active and not adsCatalog.IsEmpty
  then begin
    if adsCatalog.FieldByName('PromotionsCount').AsInteger > 0 then
      framePromotion.ShowPromotion(
        adsForms.FieldByName('FullCode').AsInteger,
        adsForms.FieldByName('PromotionsCount').AsInteger)
    else
      framePromotion.Hide();
  end;
end;

procedure TNamesFormsForm.PrepareFormsGridPanel;
begin
  pForms := TPanel.Create(Self);
  pForms.Name := 'pForms';
  pForms.Caption := '';
  pForms.ControlStyle := pForms.ControlStyle - [csParentBackground] + [csOpaque];
  pForms.BevelOuter := bvNone;
  pForms.Parent := dbgForms.Parent;
  pForms.Align := dbgForms.Align;
  dbgForms.Parent := pForms;
  dbgForms.Align := alClient;
end;

initialization
  SearchInBegin := False;
end.
