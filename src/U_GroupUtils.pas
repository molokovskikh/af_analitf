unit U_GroupUtils;

interface

uses
  SysUtils, Classes, Graphics, pFIBDataSet;

type
  SortGroup = class
    //Ссылка на каталог
    CatalogId : Integer;
    //Ссылка на продукт
    ProductId : Integer;
    //
    Cataloged : Integer;
    //Форма выпуска
    FormName  : String;
    //Минимальная цена в группе
    MinCost   : Currency;

    constructor Create(
      ACatalogId : Integer;
      AProductId : Integer;
      ACataloged : Integer;
      AFormName  : String;
      AMinCost   : Currency);

    function ToString() : String;
  end;

  SortElem = class
    //Цена
    Cost          : Currency;
    //Выбранный цвет
    SelectedColor : TColor;
    //Разница в цене относительно предыдущей позиции (используется в форме Core)
    PriceDelta    : Currency;
    //Ссылка на группу
    Group         : SortGroup;
    //Находится ли прайс-лист в основной категории
    IsBaseCategory : Boolean;
    constructor Create(ACost : Currency; AGroup : SortGroup; AIsBaseCategory : Boolean);
    function ToString() : String;
  end;

//Отсортировать набор данных в DataSet,
//CatalogExists - внутри набора есть каталожные записи
//GroupByProducts - требуется ли группировать по свойствам продуктов
function GetSortedGroupList(DataSet : TpFIBDataSet; CatalogExists : Boolean; GroupByProducts : Boolean) : TStringList;

implementation

uses Math, LU_Tracer;

{
procedure LogListToTrace(List: TStringList);
var
  I : Integer;
  elem : SortElem;
begin
  Tracer.TR('LogListToTrace', 'Begin');
  for I := 0 to List.Count-1 do begin
    elem := SortElem(List.Objects[i]);
    Tracer.TR('LogListToTrace', Format('CoreId : %s %s', [List[i], elem.ToString()]));
  end;
  Tracer.TR('LogListToTrace', 'End');
end;
}

function SortElemCompareByProducts(List: TStringList; Index1, Index2: Integer): Integer;
var
  Elem1, Elem2 : SortElem;
begin
  Elem1 := SortElem(List.Objects[Index1]);
  Elem2 := SortElem(List.Objects[Index2]);
  Result := CompareStr(Elem1.Group.FormName, Elem2.Group.FormName);
  if Result = 0 then begin
    if Elem1.Group.ProductId = Elem2.Group.ProductId then
      Result := Integer(CompareValue(Elem1.Cost, Elem2.Cost))
    else begin
      Result := Integer(CompareValue(Elem1.Group.MinCost, Elem2.Group.MinCost));
      if Result = 0 then
        Result := Integer(CompareValue(Elem1.Group.ProductId, Elem2.Group.ProductId));
    end;
  end;
end;

function SortElemCompareByCatalog(List: TStringList; Index1, Index2: Integer): Integer;
var
  Elem1, Elem2 : SortElem;
begin
  Elem1 := SortElem(List.Objects[Index1]);
  Elem2 := SortElem(List.Objects[Index2]);
  Result := CompareStr(Elem1.Group.FormName, Elem2.Group.FormName);
  if Result = 0 then begin
    if Elem1.Group.CatalogId = Elem2.Group.CatalogId then
      Result := Integer(CompareValue(Elem1.Cost, Elem2.Cost))
    else begin
      Result := Integer(CompareValue(Elem1.Group.MinCost, Elem2.Group.MinCost));
      if Result = 0 then
        Result := Integer(CompareValue(Elem1.Group.CatalogId, Elem2.Group.CatalogId));
    end;
  end;
end;

function GetSortedGroupList(DataSet : TpFIBDataSet; CatalogExists : Boolean; GroupByProducts : Boolean) : TStringList;
var
  Groups : TStringList;
  I, J : Integer;
  PrevId, CurrId, ColorIndex : Integer;
  CurrElem : SortElem;

  function FindGroup(
      ACatalogId : Integer;
      AProductId : Integer;
      AMinCost   : Currency) : SortGroup;
  var
    g : Integer;
    CurrentGroup : SortGroup;
  begin
    Result := nil;
    for g := 0 to Groups.Count-1 do begin
      CurrentGroup := SortGroup(Groups.Objects[g]);
      if (CurrentGroup.ProductId = AProductId) and (CurrentGroup.CatalogId = ACatalogId) then begin
        Result := CurrentGroup;
        Exit;
      end;
    end;

    if Result = nil then begin
      Result := SortGroup.Create(ACatalogId, AProductId, 1, '', AMinCost);
      Groups.AddObject(IntToStr(Groups.Count), Result);
    end;
  end;

  procedure AddElem();
  var
    CurrentGroup : SortGroup;
  begin
    if (CatalogExists and (DataSet.FBN('SynonymCode').AsInteger < 0))
    then begin
      CurrentGroup := SortGroup.Create(
        DataSet.FBN('Fullcode').AsInteger,
        0,
        0,
        DataSet.FBN('SynonymName').AsString,
        -1);
      Groups.AddObject(IntToStr(Groups.Count), CurrentGroup);
      Result.AddObject(DataSet.FBN('CoreID').AsString, SortElem.Create(-1, CurrentGroup, DataSet.FBN('PriceEnabled').AsBoolean));
    end
    else begin
      CurrentGroup := FindGroup(
        DataSet.FBN('Fullcode').AsInteger,
        DataSet.FBN('ProductId').AsInteger,
        DataSet.FBN('CryptBaseCost').AsCurrency
      );
      if CurrentGroup.MinCost > DataSet.FBN('CryptBaseCost').AsCurrency then
        CurrentGroup.MinCost := DataSet.FBN('CryptBaseCost').AsCurrency;
      Result.AddObject(DataSet.FBN('CoreID').AsString, SortElem.Create(DataSet.FBN('CryptBaseCost').AsCurrency, CurrentGroup, DataSet.FBN('PriceEnabled').AsBoolean));
    end;
  end;

begin
  Result := TStringList.Create();
  Groups := TStringList.Create();
  try
    DataSet.First;
    while (not DataSet.Eof) do begin
      AddElem();
      DataSet.Next;
    end;
    if CatalogExists then
      for I := 0 to Groups.Count-1 do
        if SortGroup(Groups.Objects[i]).Cataloged = 1 then
          for J := 0 to Groups.Count-1 do
            if (SortGroup(Groups.Objects[j]).Cataloged = 0)
              and (SortGroup(Groups.Objects[j]).CatalogId = SortGroup(Groups.Objects[i]).CatalogId)
            then begin
              SortGroup(Groups.Objects[i]).FormName := SortGroup(Groups.Objects[j]).FormName;
              Break;
            end;

    //LogListToTrace(Result);

    if GroupByProducts then
      Result.CustomSort(SortElemCompareByProducts)
    else
      Result.CustomSort(SortElemCompareByCatalog);

    //LogListToTrace(Result);
    
    PrevId := 0;
    ColorIndex := -1;
    for I := 0 to Result.Count-1 do begin
      CurrElem := SortElem(Result.Objects[i]);
      if CurrElem.Group.Cataloged = 1 then begin
        if GroupByProducts then
          CurrId := CurrElem.Group.ProductId
        else
          CurrId := CurrElem.Group.CatalogId;

        if PrevId <> CurrId then begin
          //Здесь 2 - это кол-во цветов
          ColorIndex := (ColorIndex + 1) mod 2;
          PrevId := CurrId;
        end;

        case ColorIndex of
          0 : CurrElem.SelectedColor := clWhite;
          else
              CurrElem.SelectedColor := clSkyBlue;
        end;
      end;
    end;
  finally
    for I := 0 to Groups.Count-1 do
      Groups.Objects[i].Free;
    Groups.Free;
  end;
end;

{ SortGroup }

constructor SortGroup.Create(ACatalogId, AProductId, ACataloged: Integer;
  AFormName: String; AMinCost: Currency);
begin
  CatalogId := ACatalogId;
  ProductId := AProductId;
  Cataloged := ACataloged;
  FormName := AFormName;
  MinCost := AMinCost;
end;

function SortGroup.ToString: String;
begin
  Result := Format('CatalogId : %d  ProductId : %d  Cataloged : %d  FormName : "%s"  MinCost : %f',
    [CatalogId, ProductId, Cataloged, FormName, MinCost]);
end;

{ SortElem }

constructor SortElem.Create(ACost: Currency; AGroup: SortGroup; AIsBaseCategory : Boolean);
begin
  PriceDelta := 0;
  Cost := ACost;
  Group := AGroup;
  IsBaseCategory := AIsBaseCategory;
end;

function SortElem.ToString: String;
begin
  Result := Format('Cost : %f  Group : (%s)', [Cost, Group.ToString()]);
end;

end.
