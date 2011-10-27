unit MnnSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, StdCtrls, GridsEh, DBGridEh, ToughDBGrid, DB,
  MemDS, DBAccess, MyAccess, StrUtils, ActnList;

type
  TMnnSearchForm = class(TChildForm)
    pnlTop: TPanel;
    dbgMnn: TToughDBGrid;
    pnlSearch: TPanel;
    eSearch: TEdit;
    dsMNN: TDataSource;
    adsMNN: TMyQuery;
    tmrSearch: TTimer;
    adsMNNId: TLargeintField;
    adsMNNMnn: TStringField;
    tmrFlipToMNN: TTimer;
    ActionList: TActionList;
    actShowAll: TAction;
    adsMNNCoreExists: TFloatField;
    cbShowAll: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dbgMnnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgMnnKeyPress(Sender: TObject; var Key: Char);
    procedure dbgMnnDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure tmrFlipToMNNTimer(Sender: TObject);
    procedure dbgMnnDblClick(Sender: TObject);
    procedure actShowAllExecute(Sender: TObject);
    procedure dbgMnnGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    { Private declarations }
    BM : TBitmap;
    InternalSearchText : String;
    procedure SetClear;
    procedure InternalSearch;
    procedure AddKeyToSearch(Key : Char);
    procedure SaveActionStates;
  public
    { Public declarations }
  end;

procedure ShowMnnSearch;

implementation

uses Main, AlphaUtils, SQLWaiting, NamesForms, DModule, AProc;

{$R *.dfm}

procedure ShowMnnSearch;
begin
  MainForm.ShowChildForm(TMnnSearchForm);
end;


procedure TMnnSearchForm.FormCreate(Sender: TObject);
begin
  inherited;
  NeedFirstOnDataSet := False;
  InternalSearchText := '';
  BM := TBitmap.Create;

  dbgMnn.PopupMenu := nil;

  with DM.adtParams do
  begin
    actShowAll.Checked := FieldByName( 'ShowAllCatalog').AsBoolean;
  end;

  ShowForm;

  SetClear;
end;

procedure TMnnSearchForm.FormDestroy(Sender: TObject);
begin
  SaveActionStates;
  BM.Free;
  inherited;
end;

procedure TMnnSearchForm.InternalSearch;
begin
  if adsMNN.Active then
    adsMNN.Close;

  adsMNN.ParamByName('LikeParam').AsString := '%' + InternalSearchText + '%';
  if actShowAll.Checked then
    adsMNN.ParamByName('ShowAll').Value := 0
  else
    adsMNN.ParamByName('ShowAll').Value := 1;

  adsMNN.Open;

  adsMNN.First;

  dbgMnn.SetFocus;
end;

procedure TMnnSearchForm.SetClear;
begin
  tmrSearch.Enabled := False;
  eSearch.Text := '';
  InternalSearchText := '';
  if adsMNN.Active then
    adsMNN.Close;

  adsMNN.ParamByName('LikeParam').AsString := '%';
  if actShowAll.Checked then
    adsMNN.ParamByName('ShowAll').Value := 0
  else
    adsMNN.ParamByName('ShowAll').Value := 1;

  adsMNN.Open;

  adsMNN.First;

  dbgMnn.SetFocus;
end;

procedure TMnnSearchForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if (Length(eSearch.Text) > 2) then begin
    InternalSearchText := StrUtils.LeftStr(eSearch.Text, 50);
    InternalSearch;
    eSearch.Text := '';
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TMnnSearchForm.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
    dbgMnn.SetFocus;
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TMnnSearchForm.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //Если мы что-то нажали в элементе, то должны на это отреагировать
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

procedure TMnnSearchForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TMnnSearchForm.dbgMnnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    if not adsMNN.IsEmpty and not adsMNNId.IsNull and (Length(eSearch.Text) = 0) then
      {
       Это "грязный" хак
       Если делать переход явно, как строчкой ниже, то возникает AccessViolation
       при отображении формы NamesForms, как в требовании:
       #1678 Ошибка при переходи из прайс листа в каталог
      }
      tmrFlipToMNN.Enabled := True
      //FlipToMNN(adsMNNId.Value);
    else
      tmrSearchTimer(nil);
  end
  else
    if Key = VK_ESCAPE then
      SetClear
    else
      if Key = VK_BACK then begin
        tmrSearch.Enabled := False;
        eSearch.Text := Copy(eSearch.Text, 1, Length(eSearch.Text)-1);
        tmrSearch.Enabled := True;
      end;
end;

procedure TMnnSearchForm.dbgMnnKeyPress(Sender: TObject; var Key: Char);
begin
  if ( Key > #32) and not ( Key in
    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
  begin
    AddKeyToSearch(Key);
  end;
end;

procedure TMnnSearchForm.dbgMnnDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if (Column.Field = adsMNNMnn) then
    ProduceAlphaBlendRect(InternalSearchText, Column.Field.DisplayText, dbgMnn.Canvas, Rect, BM);
end;

procedure TMnnSearchForm.tmrFlipToMNNTimer(Sender: TObject);
var
  showAllCatalog : Boolean;
  count : Variant;
begin
  tmrFlipToMNN.Enabled := False;
  if not adsMNN.IsEmpty and not adsMNNId.IsNull and (Length(eSearch.Text) = 0) then
  begin
    showAllCatalog := DM.adtParams.FieldByName('ShowAllCatalog').AsBoolean;
    count := DM.QueryValue(
      'select count(*) from catalogs, mnn ' +
      ' where catalogs.MnnId = mnn.Id and mnn.Id = ' + adsMNNId.AsString +
      IfThen(not showAllCatalog, ' and catalogs.CoreExists = 1'), [], []);
    if VarIsNull(count) or (count = 0) then
      if showAllCatalog then
        AProc.MessageBox('Для МНН "' + adsMNNMnn.AsString + '" не существует позиций в каталоге.', MB_ICONWARNING)
      else
        AProc.MessageBox('Для МНН "' + adsMNNMnn.AsString + '" не существует позиций в каталоге с предложениями.', MB_ICONWARNING)
    else
      FlipToMNNFromMNNSearch(adsMNNId.Value);
  end;
end;

procedure TMnnSearchForm.dbgMnnDblClick(Sender: TObject);
begin
  if not adsMNN.IsEmpty and not adsMNNId.IsNull then
    {
     Это "грязный" хак
     Если делать переход явно, как строчкой ниже, то возникает AccessViolation
     при отображении формы NamesForms, как в требовании:
     #1678 Ошибка при переходи из прайс листа в каталог
    }
    tmrFlipToMNN.Enabled := True
    //FlipToMNN(adsMNNId.Value);
end;

procedure TMnnSearchForm.SaveActionStates;
begin
  with DM.adtParams do
  begin
    Edit;
    FieldByName( 'ShowAllCatalog').AsBoolean := actShowAll.Checked;
    Post;
  end;
end;

procedure TMnnSearchForm.actShowAllExecute(Sender: TObject);
begin
  if not dbgMnn.CanFocus then Abort;

  actShowAll.Checked := not actShowAll.Checked;
  SaveActionStates;

  if not tmrSearch.Enabled and (Length(InternalSearchText) > 0) then
    InternalSearch
  else
    if not tmrSearch.Enabled then
      SetClear;

  dbgMnn.SetFocus();
end;

procedure TMnnSearchForm.dbgMnnGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not adsMNN.IsEmpty and (adsMNNCoreExists.Value < 0.001 ) then
    Background := clSilver;
end;

end.
