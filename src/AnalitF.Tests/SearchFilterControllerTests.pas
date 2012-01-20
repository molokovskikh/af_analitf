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
  CheckTrue(FSearchFilterController.AllowSearch('���� ����'));
  CheckTrue(FSearchFilterController.AllowSearch('��� ���'));
  CheckTrue(FSearchFilterController.AllowSearch('  ���   ���  '));
  CheckTrue(FSearchFilterController.AllowSearch('  ���   ��  '));
  CheckTrue(FSearchFilterController.AllowSearch('  ���    '));

  CheckFalse(FSearchFilterController.AllowSearch('  ��    '));
  CheckFalse(FSearchFilterController.AllowSearch('��'));
  CheckFalse(FSearchFilterController.AllowSearch(' ��   ��   '));
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
  CheckSearch('���� ���', '((synonyms.synonym like :searchText1) and (synonyms.synonym like :searchText0))', ['���', '����']);

  query := TMyQuery.Create(nil);
  try
    query.SQL.Text := 'select * from synonyms  where ' + FSearchFilterController.GetSearchFilter();
    FSearchFilterController.SetSearchParams(query);

    CheckEquals(2, query.ParamCount);
    CheckEqualsString('searchText1', query.Params[0].Name);
    CheckEqualsString('%����%', query.Params[0].AsString);
    CheckEqualsString('searchText0', query.Params[1].Name);
    CheckEqualsString('%���%', query.Params[1].AsString);
  finally
    query.Free
  end;
end;

procedure TTestSearchFilterController.CheckSetSearchText;
begin
  CheckSearch('���� ����', '((synonyms.synonym like :searchText1) and (synonyms.synonym like :searchText0))', ['����', '����']);
  CheckSearch('���� ���� ����', '((synonyms.synonym like :searchText2) and (synonyms.synonym like :searchText1) and (synonyms.synonym like :searchText0))', ['����', '����', '����']);
  CheckSearch('���� ���', '((synonyms.synonym like :searchText1) and (synonyms.synonym like :searchText0))', ['����', '���']);
  CheckSearch('���� ���', '((synonyms.synonym like :searchText1) and (synonyms.synonym like :searchText0))', ['���', '����']);
end;

procedure TTestSearchFilterController.CreateWithNullSearchColumn;
var
  filter : TSearchFilterController;
begin
  try
    filter := TSearchFilterController.Create('');
    Fail('���������� �������� ������ ��� ������� Exception');
  except
    on E : Exception do
      Self.CheckEqualsString('�� ���������� �������� ASearchColumnName', E.Message);
  end;
end;

procedure TTestSearchFilterController.SetNullSearchText;
begin
  FSearchFilterController.SetSearchText('���  ����');
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
