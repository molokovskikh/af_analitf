unit SearchFilterControllerTests;

interface

uses
  SysUtils,
  Windows,
  TestFrameWork,
  MyAccess,
  SearchFilterController;

type
  TTestSearchFilterController = class(TTestCase)
   private
    FSearchFilterController : TSearchFilterController;
    procedure CheckSearch(searchText : String; searchFilter : String; searchList : array of String);
   protected
    procedure SetUp(); override;
    procedure TearDown(); override;
   published
    procedure CreateWithNullSearchColumn;
    procedure CheckSearchColumnAfterCreate;
    procedure CheckAllowSearch;
    procedure SetNullSearchText;
    procedure CheckSetSearchText;
    procedure CheckSetQueryParams;
  end;

implementation

{ TTestSearchFilterController }

procedure TTestSearchFilterController.CheckAllowSearch;
begin
  CheckTrue(FSearchFilterController.AllowSearch('мама мыла'));
  CheckTrue(FSearchFilterController.AllowSearch('мам мыл'));
  CheckTrue(FSearchFilterController.AllowSearch('  мам   мыл  '));
  CheckTrue(FSearchFilterController.AllowSearch('  мам   мы  '));
  CheckTrue(FSearchFilterController.AllowSearch('  мам    '));

  CheckFalse(FSearchFilterController.AllowSearch('  ма    '));
  CheckFalse(FSearchFilterController.AllowSearch('ма'));
  CheckFalse(FSearchFilterController.AllowSearch(' ма   мы   '));
end;

procedure TTestSearchFilterController.CheckSearch(searchText,
  searchFilter: String; searchList: array of String);
var
  i : Integer;
begin
  FSearchFilterController.SetSearchText(searchText);
  CheckTrue(FSearchFilterController.AllowSearchFilter());
  CheckEqualsString(searchText, FSearchFilterController.InternalSearchText);
  CheckEqualsString(searchFilter, FSearchFilterController.GetSearchFilter());
  CheckEquals(Length(searchList), FSearchFilterController.Searchs.Count);
  for i := 0 to High(searchList) do
    CheckEqualsString(searchList[i], FSearchFilterController.Searchs[i]);
end;

procedure TTestSearchFilterController.CheckSearchColumnAfterCreate;
var
  filter : TSearchFilterController;
begin
  filter := TSearchFilterController.Create('table.SearchColumn');
  try
    CheckEqualsString('table.SearchColumn', filter.SearchColumnName);
  finally
    filter.Free;
  end;
end;

procedure TTestSearchFilterController.CheckSetQueryParams;
var
  query : TMyQuery;
  i : Integer;
begin
  CheckSearch('крем кре', '((synonyms.synonym like :searchText1) and (synonyms.synonym like :searchText0))', ['кре', 'крем']);

  query := TMyQuery.Create(nil);
  try
    query.SQL.Text := 'select * from synonyms  where ' + FSearchFilterController.GetSearchFilter();
    FSearchFilterController.SetSearchParams(query);

    CheckEquals(2, query.ParamCount);
    CheckEqualsString('searchText1', query.Params[0].Name);
    CheckEqualsString('%крем%', query.Params[0].AsString);
    CheckEqualsString('searchText0', query.Params[1].Name);
    CheckEqualsString('%кре%', query.Params[1].AsString);
  finally
    query.Free
  end;
end;

procedure TTestSearchFilterController.CheckSetSearchText;
begin
  CheckSearch('мама мыла', '((synonyms.synonym like :searchText1) and (synonyms.synonym like :searchText0))', ['мама', 'мыла']);
  CheckSearch('мама мыла раму', '((synonyms.synonym like :searchText2) and (synonyms.synonym like :searchText1) and (synonyms.synonym like :searchText0))', ['мама', 'мыла', 'раму']);
  CheckSearch('крем сод', '((synonyms.synonym like :searchText1) and (synonyms.synonym like :searchText0))', ['крем', 'сод']);
  CheckSearch('крем кре', '((synonyms.synonym like :searchText1) and (synonyms.synonym like :searchText0))', ['кре', 'крем']);
end;

procedure TTestSearchFilterController.CreateWithNullSearchColumn;
var
  filter : TSearchFilterController;
begin
  try
    filter := TSearchFilterController.Create('');
    Fail('Предыдущий оператор должен был вызвать Exception');
  except
    on E : Exception do
      Self.CheckEqualsString('Не установлен параметр ASearchColumnName', E.Message);
  end;
end;

procedure TTestSearchFilterController.SetNullSearchText;
begin
  FSearchFilterController.SetSearchText('мам  мыла');
  CheckTrue(FSearchFilterController.AllowSearchFilter());
  Check(Length(FSearchFilterController.InternalSearchText) > 0);
  FSearchFilterController.SetSearchText('');
  CheckFalse(FSearchFilterController.AllowSearchFilter());
  CheckEqualsString('', FSearchFilterController.InternalSearchText);
  CheckEquals(0, FSearchFilterController.Searchs.Count);
end;

procedure TTestSearchFilterController.SetUp;
begin
  inherited;
  FSearchFilterController := TSearchFilterController.Create('synonyms.synonym');
end;

procedure TTestSearchFilterController.TearDown;
begin
  if Assigned(FSearchFilterController) then
    FSearchFilterController.Free;
  inherited;
end;

initialization
  TestFramework.RegisterTest(TTestSearchFilterController.Suite);
end.
