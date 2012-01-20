unit SearchFilterController;

interface

uses
  SysUtils,
  Classes,
  StrUtils,
  Contnrs,
  MyAccess,
  AllOrdersParams,
  U_Address,
  U_DBMapping;

type
  TSearchFilterController = class
   private
    FSearchColumnName : String;
    FInternalSearchText : String;
    FSearchs : TStringList;
    procedure SetSearchList(list : TStringList; searchText : String);
    function ParamNameByIndex(paramIndex : Integer) : String;
   public
    constructor Create(ASearchColumnName : String);
    destructor Destroy; override;

    function AllowSearch(AInternalSearchText : String) : Boolean;
    procedure SetSearchText(AInternalSearchText : String);

    function AllowSearchFilter() : Boolean;
    function GetSearchFilter() : String;
    procedure SetSearchParams(query : TMyQuery);

    property InternalSearchText : String read FInternalSearchText;
    property Searchs : TStringList read FSearchs;
    property SearchColumnName : String read FSearchColumnName;
  end;

implementation

{ TSearchFilterController }

function TSearchFilterController.AllowSearch(
  AInternalSearchText: String): Boolean;
var
  list : TStringList;
begin
  Result := False;
  if Length(AInternalSearchText) > 0 then begin
    list := TStringList.Create;
    try
      SetSearchList(list, AInternalSearchText);
      Result := list.Count > 0;
    finally
      list.Free;
    end;
  end;
end;

function TSearchFilterController.AllowSearchFilter: Boolean;
begin
  Result := FSearchs.Count > 0;
end;

constructor TSearchFilterController.Create(ASearchColumnName: String);
begin
  if Length(ASearchColumnName) < 1 then
    raise Exception.Create('Не установлен параметр ASearchColumnName');
  FSearchColumnName := ASearchColumnName;
  FInternalSearchText := '';
  FSearchs := TStringList.Create;
end;

destructor TSearchFilterController.Destroy;
begin
  if Assigned(FSearchs) then
    FSearchs.Free;
  inherited;
end;

function TSearchFilterController.GetSearchFilter: String;

  function GetParamStr(paramIndex : Integer) : String;
  begin
    Result := Format('(%s like :%s)', [SearchColumnName, ParamNameByIndex(paramIndex)]);
  end;

var
  i : Integer;
begin
  Result := '';
  if AllowSearchFilter() then begin
    Result := GetParamStr(FSearchs.Count-1);
    
    if FSearchs.Count > 1 then
      for i := FSearchs.Count-2 downto 0 do
        Result := Result + ' and ' + GetParamStr(i);

    Result := '(' + Result + ')';
  end;
end;

function TSearchFilterController.ParamNameByIndex(
  paramIndex: Integer): String;
begin
  Result := Format('searchText%d', [paramIndex]);
end;

procedure TSearchFilterController.SetSearchList(list: TStringList;
  searchText: String);
var
  i : Integer;
begin
  list.Clear;
  list.Delimiter := ' ';
  list.DelimitedText := searchText;
  list.Sort;
  for i := list.Count-1 downto 0 do
    if Length(list[i]) < 3 then
      list.Delete(i)
    else
      if Length(list[i]) > 50 then
        list[i] := StrUtils.LeftStr(list[i], 50);
end;

procedure TSearchFilterController.SetSearchParams(query: TMyQuery);
var
  i : Integer;
begin
  for i := FSearchs.Count-1 downto 0 do
    query.ParamByName(ParamNameByIndex(i)).Value := '%' + FSearchs[i] + '%';
end;

procedure TSearchFilterController.SetSearchText(
  AInternalSearchText: String);
begin
  FInternalSearchText := '';
  SetSearchList(FSearchs, AInternalSearchText);
  if AllowSearchFilter() then
    FInternalSearchText := AInternalSearchText;
end;

end.
