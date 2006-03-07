unit LU_TSGHashTable;
interface
uses
  SysUtils, Classes, syncobjs;

type
  //Основной элемент хеш-таблицы
  PHashItem = ^THashItem;
  THashItem = record
    Key  : String;
    Data : Pointer;
  end;
  //Массив хеш-элементов
  PHashArray = ^THashArray;  THashArray = array[0..MaxListSize] of PHashItem;

  //Базовый класс для генерации ключа
  type
    TFKey = function (AValue : String; ATableSize : Integer) : Integer;

  TSGHashTable = class
  private
    FCriticalSection : TCriticalSection;//Рабочая критическая секция
    FTableSize : Integer;     //Длина хеш-таблицы
    FAddItemCount: Integer;   //Количество добавленных элементов
    FHashTable : PHashArray;  //Хеш-таблица
    FMaxInternalList : Integer; //Количество скученных элементов, перебираемых при вставке или поиске
    FKeyFH : TFKey; //Функция вычисления ключа
    //Добавляет элемент в хеш-таблицу
    procedure   Add(AKey : String; AValue : Pointer);
    //Поиск простого размера таблицы следующего после переданного значения
    function FindTableSize (ASize: integer): integer;
    //Поиск индекса нужного элемента
    function FindIndex (AKey : String): integer;
    //Производит инициализацию объекта
    procedure Init (ATableSize : Integer; KeyFH: TFKey);
  public
    //Создание хеш-таблицы определенной длины и с заданной функцией вычисления ключа
    constructor Create(ATableSize : Integer); overload;
    //Создание хеш-таблицы произвольной длины и с заданной функцией вычисления ключа
    constructor Create;overload;
    //Создание хеш-таблицы произвольной длины и с переданной функцией вычисления ключа
    constructor Create( KeyFH: TFKey);overload;
    //Создание хеш-таблицы переданной длины и с переданной функцией вычисления ключа
    constructor Create( ATableSize : Integer; KeyFH: TFKey);overload;
    //Рехеширование хеш-таблицы, увеличение её размера
    procedure ReHash;
    destructor  Destroy; override;
    //Добавление элемента (с заменой) и производит рехеширование, если нужно
    procedure   AddItem(AKey : String; AValue : Pointer);
    //Поиск нужного элемента
    function    FindItem(AKey : String) : Pointer;
    //Возвращает максимальное количество элементов во внутреннем списке.
    function    MaxInternalList : Integer;
  end;


implementation
uses Windows;

const
  //Используемая часть хеш-таблицы
  UsePart = 0.5;
  //Количество элементов в таблицк прростых чисел
  TableSizeCount = 43;
  //Таблица простых чисел
  TableSizeAsPrimeNumber: array[0..TableSizeCount-1] of integer =
                           (67, 89, 113, 149, 191, 239, 307, 389, 487, 613,
                            769, 967, 1213, 1523, 1907, 2389, 2999, 3761, 4703,
                            5879, 7349, 9187, 11489, 14369, 17971, 22469, 28087,
                            35111, 43889, 54869, 68597, 85751, 107197, 133999,
                            167521, 209431, 261791, 327247, 409063, 511333,
                            639167, 798961, 998717);

function Key(AValue: String; ATableSize : Integer): Integer;
type
  BaseKeyType  = DWORD;
  PBaseKeyType = ^BaseKeyType;
const
  ModCon = SizeOf(BaseKeyType);
  nbits = 28;
  ShrV = ModCon*8 - nbits;
var
  Sum : BaseKeyType;
  D   : PBaseKeyType;
  L   : Integer;
  Str : String;
begin
  Str := AValue + StringOfChar(#$AA, ModCon - Length ( AValue ) mod ModCon);
  L := Length ( Str ) div ModCon;
  d   := PBaseKeyType ( Addr ( Str[1] ) );
  Sum := d^;
  Dec(L);
  while L > 0 do begin
    Inc ( d );
    Sum := (Sum shl nbits) or (Sum shr ShrV);
    Sum := Sum xor d^;
    Dec(L);
  end;
  Result := Sum mod BaseKeyType(ATableSize);
end;
{ TSGHashTable }
procedure TSGHashTable.Add(AKey: String; AValue: Pointer);
var
  i : Integer;
  CurrItem : PHashItem;
begin
 FCriticalSection.Enter;
 try
  //Поиск индекса вставки элемента
  i := FindIndex(AKey);
  if FHashTable^[i] = nil then
  begin
    //Вставка элемента
    New(CurrItem);
    CurrItem^.Key  := AKey;
    CurrItem^.Data := AValue;
    FHashTable^[i] := CurrItem;
    FAddItemCount := FAddItemCount + 1;
  end
  else
    //Если ключи совпадают, то происходит замена содержимого
      FHashTable^[i]^.Data := AValue
 finally
   FCriticalSection.Leave;
 end;
end;

procedure TSGHashTable.AddItem(AKey: String; AValue: Pointer);
begin
   if Length(AKey) = 0 then
    raise Exception.Create('LU_TSGHashTable:TSGHashTable.AddItem - ' +
        'Произошла попытка вставки элемента с пустым ключом.');
  //Попытка рехеширования
  ReHash;
  FCriticalSection.Enter;
  try
   //Вставка элемента
   Add(AKey, AValue);
  finally
    FCriticalSection.Leave;
  end;
end;

constructor TSGHashTable.Create(ATableSize: Integer);
begin
  inherited Create;
  Init(FindTableSize(Round(ATableSize/UsePart) + 2), Key);
end;

constructor TSGHashTable.Create;
begin
  inherited Create;
  Init(TableSizeAsPrimeNumber[0], Key);
end;

constructor TSGHashTable.Create(KeyFH: TFKey);
begin
  inherited Create;
  Init(TableSizeAsPrimeNumber[0], KeyFH);
end;

constructor TSGHashTable.Create(ATableSize: Integer; KeyFH: TFKey);
begin
  inherited Create;
  Init(FindTableSize(Round(ATableSize/UsePart) + 2), KeyFH);
end;

destructor TSGHashTable.Destroy;
var
  I : Integer;

begin
  for I := 0 to FTableSize-1 do
    if FHashTable^[i]<>nil then Dispose(FHashTable^[i]);

  ReallocMem(FHashTable, 0);
  FCriticalSection.Free;
  inherited;
end;

function TSGHashTable.FindIndex(AKey: String): integer;
var
  i, CurrItemListCount : Integer;
begin
 FCriticalSection.Enter;
 try
  CurrItemListCount := 1;
  //Вычисление ключа
  i := FKeyFH(AKey, FTableSize);
  while (FHashTable^[i] <> nil) and (FHashTable^[i]^.Key <> AKey) do
  begin
    i := (i + 1) mod FTableSize;
    Inc(CurrItemListCount);
  end;
  Result := i;
  if FMaxInternalList < CurrItemListCount then
    FMaxInternalList := CurrItemListCount;
 finally
   FCriticalSection.Leave;
 end;

end;

function TSGHashTable.FindItem(AKey: String): Pointer;
var
  i : Integer;
begin
 FCriticalSection.Enter;
 try
  Result := nil;
  if Length(AKey) = 0 then
    raise Exception.Create('LU_TSGHashTable:TSGHashTable.FindItem - ' +
        'Произошла попытка поиска элемента с пустым ключом.');
  i := FKeyFH(AKey, FTableSize);
  while (FHashTable^[i] <> nil) and (FHashTable^[i]^.Key <> AKey) do
    i := (i + 1) mod FTableSize;
  if FHashTable^[i]<>nil then
      Result := FHashTable^[i]^.Data;
 finally
   FCriticalSection.Leave;
 end;
end;
function TSGHashTable.FindTableSize(ASize:integer): integer;
var
  i: integer;
begin
  Result := ASize;
  for i := 0 to TableSizeCount-1 do
    if TableSizeAsPrimeNumber[i] > ASize then
    begin
      Result := TableSizeAsPrimeNumber[i];
      exit;
    end;
end;

procedure TSGHashTable.Init(ATableSize: Integer; KeyFH: TFKey);
var
  I: integer;
begin
  FCriticalSection := TCriticalSection.Create;
  FKeyFH     := KeyFH;
  FTableSize := ATableSize;
  FHashTable := nil;
  ReallocMem(FHashTable, FTableSize*SizeOf(PHashItem));
  FMaxInternalList := 0;
  FAddItemCount := 0;
  for I := 0 to FTableSize-1 do
    FHashTable^[i] := nil;
end;

function TSGHashTable.MaxInternalList: Integer;
begin
  Result := FMaxInternalList;
end;

procedure TSGHashTable.ReHash;
var
  NewSize, i: integer;//Размер новой хеш-таблицы
  NewHashTable : TSGHashTable;  // Новая хеш-таблица
begin
 FCriticalSection.Enter;
 try
  if FAddItemCount/FTableSize < UsePart then
    exit;
  NewSize := FindTableSize(FTableSize);
  if NewSize = FTableSize then
    raise Exception.Create('LU_TSGHashTable:TSGHashTable.ReHash - ' +
        'Хеш-таблица достигла максимального размера')
  else
  begin
    //Создание новой хеш-таблицы
    NewHashTable:=TSGHashTable.Create(FKeyFH);
    NewHashTable.FTableSize := NewSize;
    ReallocMem(NewHashTable.FHashTable, NewSize*SizeOf(PHashItem));
    for I := 0 to NewSize-1 do
      NewHashTable.FHashTable^[i] := nil;

    //Просмотр старой хеш-таблицы и добавление из неё всех элементов в новую
    for i := 0 to FTableSize-1 do
    begin
      if FHashTable^[i] <> nil then
      begin
        NewHashTable.Add(FHashTable^[i]^.Key, FHashTable^[i]^.Data);
        Dispose(FHashTable^[i]);
      end;
    end;
    //Изменяем старую таблицу в соответствии с новой
    ReallocMem(FHashTable, 0);
    FTableSize := NewSize;
    FHashTable := NewHashTable.FHashTable;
    NewHashTable.FHashTable := nil;
    NewHashTable.FTableSize := 0;
    FMaxInternalList := NewHashTable.FMaxInternalList;
    FAddItemCount:= NewHashTable.FAddItemCount;
    NewHashTable.Free;
  end;
 finally
   FCriticalSection.Leave;
 end;

end;



end.
