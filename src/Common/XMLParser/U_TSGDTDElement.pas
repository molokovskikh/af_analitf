unit U_TSGDTDElement;


interface

uses
  U_XMLElementContents, SysUtils, Controls;

const
  ExistName       = 'U_TSGDTDElemet:TSGDTDElement.AddAttribute - '+
                        'Аттрибут с таким именем уже существует.';
  NotExistIndex   = 'U_TSGDTDElemet:TSGDTDElement.%s - '+
                        'Аттрибут с таким индексом не существует.';
  NotExistName    = 'U_TSGDTDElemet:TSGDTDElement.%s - '+
                        'Аттрибут с таким именем не существует.';
  NotExistPointer = 'U_TSGDTDElemet:TSGDTDElement.Create -'+
                    'Указатель содержит Nil.';


type

{Структура класса TDTDElement}

  {TEAType содержит возможные типы аттрибутов}
  TEAType 	 = (eatNone, eatCDATA, eatID, eatIDREF, eatIDREFS, eatENTITY,
                    eatENTITIES, eatNMTOKEN, eatNMTOKENS, eatEnum);
{TEAType задает возмжные значения типов аттибутов:
  eatNone       - нет типа,
  eatCDATA      - любые символьные данные,
  eatID         - содержит уникальный иденитификатор в документе,
  eatIDREF      - содержит уникальный иденитификатор, описанный в это документе,
  eatIDREFS     - несколько IDREF, разделенных пробелами,
  eatENTITY     - содержит имя ENTITY, описанное в документе,
  eatENTITIES   - несколько ENTITY, разделенных пробелами,
  eatNMTOKEN    - содержит одно слово,
  eatNMTOKENS   - содржит несколько слов, разделенных пробелами,
  eatEnum       - аттрибут имеет перечислимый тип
}

  TEASpecification = (easNone, easRequired, easImplied, easFixed);
  {TEASpecification содержит параметры спецификации аттрибутов:
    easNone 	- нет специфкации;
    easRequired	- аттрибут является обязательным;
    easImplied	- аттрибут не является обязательным;
    easFixed	- аттрибут имеет фиксированное значение.
  }

  {Стуктура аттрибута в DTD-описании}
  TSGDTDAttribute = record
    eaName	       : String;           {Имя аттрибута}
    eaType             : TEAType;          {Тип аттрибута}
    eaSpecification    : TEASpecification; {Спецификация аттрибута}
    eaEnumeratedValues : String;           {Перечисленные значения аттрибута,
                                            пусто если нет значений}
    eaDefaultValue     : String;        {Если не пусто,то значение по умолчанию}
  end;

  TSGDTDAttributes = array of TSGDTDAttribute;

{
Что должен уметь DTDElement:
1. сохранять имя элемента, его содержимое, аттрибуты с их типами и значениями
2. предоставлять удобный доступ к данным
   a) поиск дочернего элемента
   б) поиск аттрибута
   в) данные о дочернем элементе
   г) данные об аттрибуте
   д)

Из аттрибута:
- имя
- спецификацию
- перечисленные значения
- тип
- значение по умолчанию

Из элемента
- имя
- модификатор
- знать иерархическую структуру
}


  {Структура элемента в DTD-описании}
  TSGDTDElement = class
  private
    FDTDElemName   : String;
    FContent       : TSGContent;
    FDTDAttributes : TSGDTDAttributes;
    {Возвращает указатель на содержимое элемента}
    function    GetContent: TSGContent;
  public
     {Обнуляет массив аттрибутов, запоминает имя DTDElemName
      и содержимое Content элемента}
    constructor Create(
          DTDElemName : String;
          AContent    : TSGContent);
     {Особождает массив атрибутов}
    destructor  Destroy;override;
    {Удаляет аттрибут eaName}
    procedure   RemoveAttribute           (eaName : String);    overload;
    procedure   RemoveAttribute           (Index  : Integer);	overload;

    {Добавляет аттрибут в список аттрибутов}
    function    AddAttribute(
      AeaName             : String;
      AeaType             : TEAType;
      AeaSpecification    : TEASpecification;
      AeaEnumeratedValues : String;
      AeaDefaultValue     : String) : Integer;
    {Возвращает индекс аттрибута в списке,
     если аттрибут eaName существует, иначе -1}
    function    FindAttribute            (eaName : String) : Integer;
    {Возвращает количество аттрибутов элемента}
    function    GetAttributeCount	: Integer;
    {По индексу возвращает имя аттрибута}
    function	GetAttributeName	  (Index  : Integer) : String;
    {Возвращает тип аттрибута eaName}
    function    GetAttributeType          (eaName : String)  : TEAType;overload;
    function    GetAttributeType          (Index  : Integer) : TEAType;overload;
    {Возвращает спецификацию аттрибута eaName}
    function    GetAttributeSpecification (
      eaName : String)  : TEASpecification;overload;
    function    GetAttributeSpecification (
      Index  : Integer) : TEASpecification;overload;
    {Возвращает возможные перечисленные значения аттрибута}
    function    GetAttributeEnumValues    (eaName : String)  : String;overload;
    function    GetAttributeEnumValues    (Index  : Integer) : String;overload;
    {Возврщает значение аттрибута по умолчанию}
    function    GetAttributeDefaultValue  (eaName : String)  : String;overload;
    function    GetAttributeDefaultValue  (Index  : Integer) : String;overload;
    {Содержит имя описанного элемента}
    property  	DTDElemName : String      read FDTDElemName;
    property    Content     : TSGContent  read GetContent;
  end;

implementation


{ TSGDTDElement }

constructor TSGDTDElement.Create(DTDElemName: String; AContent: TSGContent);
begin
  inherited Create;
  FDTDElemName := DTDElemName;
  FContent := AContent;
  FDTDAttributes := Nil;
  if AContent = nil then raise Exception.Create(NotExistPointer);
end;

destructor TSGDTDElement.Destroy;
begin
  FDTDAttributes := Nil;
  FContent.Free;
end;

function TSGDTDElement.FindAttribute(eaName: String): Integer;
begin
  for Result := Low(FDTDAttributes) to High(FDTDAttributes) do
    if FDTDAttributes[Result].eaName = eaName then exit;
  Result := -1;
end;

function TSGDTDElement.GetAttributeCount: Integer;
begin
  Result := Length(FDTDAttributes);
end;

function TSGDTDElement.GetAttributeEnumValues(eaName: String): String;
var
  Index : Integer;
begin
  Index := FindAttribute(eaName);
  if (Index = -1) then
    raise Exception.Create(Format(NotExistName, ['GetAttributeEnumValues']))
  else Result := FDTDAttributes[Index].eaEnumeratedValues;
end;

function TSGDTDElement.GetAttributeDefaultValue(eaName: String): String;
var
  Index : Integer;
begin
  Index := FindAttribute(eaName);
  if (Index = -1) then
    raise Exception.Create(Format(NotExistName, ['GetAttributeDefaultValue']))
  else Result := FDTDAttributes[Index].eaDefaultValue;
end;

function TSGDTDElement.GetAttributeDefaultValue(Index: Integer): String;
begin
  if (Index < Low(FDTDAttributes)) and (Index > High(FDTDAttributes)) then
    raise Exception.Create(Format(NotExistIndex,['GetAttributeDefaultValue']))
  else Result := FDTDAttributes[Index].eaDefaultValue;
end;

function TSGDTDElement.GetAttributeEnumValues(Index: Integer): String;
begin
  if (Index < Low(FDTDAttributes)) and (Index > High(FDTDAttributes)) then
    raise Exception.Create(Format(NotExistIndex,['GetAttributeEnumValues']))
  else Result := FDTDAttributes[Index].eaEnumeratedValues;
end;

function TSGDTDElement.GetAttributeName(Index: Integer): String;
begin
  if (Index < Low(FDTDAttributes)) and (Index > High(FDTDAttributes)) then
    raise Exception.Create(Format(NotExistIndex,['GetAttributeName']))
  else Result := FDTDAttributes[Index].eaName;
end;

function TSGDTDElement.GetAttributeSpecification
                                        (Index: Integer): TEASpecification;
begin
  if (Index < Low(FDTDAttributes)) and (Index > High(FDTDAttributes)) then
    raise Exception.Create(Format(NotExistIndex,['GetAttributeSpecification']))
  else Result := FDTDAttributes[Index].eaSpecification;
end;

function TSGDTDElement.GetAttributeSpecification
                                        (eaName: String): TEASpecification;
var
  Index : Integer;
begin
  Index := FindAttribute(eaName);
  if (Index = -1) then
    raise Exception.Create(Format(NotExistName, ['GetAttributeSpecification']))
  else Result := FDTDAttributes[Index].eaSpecification;
end;

function TSGDTDElement.GetAttributeType(Index: Integer): TEAType;
begin
  if (Index < Low(FDTDAttributes)) and (Index > High(FDTDAttributes)) then
    raise Exception.Create(Format(NotExistIndex,['GetAttributeType']))
  else Result := FDTDAttributes[Index].eaType;
end;

function TSGDTDElement.GetAttributeType(eaName: String): TEAType;
var
  Index : Integer;
begin
  Index := FindAttribute(eaName);
  if (Index = -1) then
    raise Exception.Create(Format(NotExistName, ['GetAttributeType']))
  else Result := FDTDAttributes[Index].eaType;
end;

function TSGDTDElement.GetContent: TSGContent;
begin
  Result := FContent;
end;

procedure TSGDTDElement.RemoveAttribute(eaName: String);
var
  Index : Integer;
begin
  Index := FindAttribute(eaName);
  if (Index = -1) then
    raise Exception.Create(Format(NotExistName, ['RemoveAttribute']))
  else RemoveAttribute(Index);
end;

procedure TSGDTDElement.RemoveAttribute(Index: Integer);
var
  I : Integer;
begin
  if (Index < Low(FDTDAttributes)) and (Index > High(FDTDAttributes)) then
    raise Exception.Create(Format(NotExistIndex,['RemoveAttribute']))
  else begin
    if Length(FDTDAttributes) > 1 then begin
      for I := Index to High(FDTDAttributes)-1 do
        FDTDAttributes[i] := FDTDAttributes[i+1];
      SetLength(FDTDAttributes, Length(FDTDAttributes) - 1);
    end
    else FDTDAttributes := nil;
  end;
end;

function TSGDTDElement.AddAttribute(
      AeaName             : String;
      AeaType             : TEAType;
      AeaSpecification    : TEASpecification;
      AeaEnumeratedValues : String;
      AeaDefaultValue     : String): Integer;
begin
  if (FindAttribute(AeaName) <> -1) then
    raise Exception.Create(ExistName)
  else begin
    SetLength(FDTDAttributes, Length(FDTDAttributes) + 1);
    Result := High(FDTDAttributes);
    FDTDAttributes[Result].eaName             := AeaName;
    FDTDAttributes[Result].eaType             := AeaType;
    FDTDAttributes[Result].eaSpecification    := AeaSpecification;
    FDTDAttributes[Result].eaEnumeratedValues := AeaEnumeratedValues;
    FDTDAttributes[Result].eaDefaultValue     := AeaDefaultValue;
  end;
end;

end.