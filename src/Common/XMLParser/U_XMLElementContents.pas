unit U_XMLElementContents;

interface

uses
  SysUtils;
   
const
  NotExistIndex   = 'U_ElementContents:TSGChildrenContent.%s - '+
                        'Дочерний элемент с таким индексом не существует.';

type

{Префикс EC = Element Content}

  TECType 	= (ectANY, ectEMPTY, ectPCDATA, ectELEMENT, ectSEQ, ectCHOICE);
{TECType задает возможные типы содержимого элементов в документе:
  ectANY 	- любое содержимое;
  ectPCDATA	- любые символьные данные;
  ectEMPTY	- элемент должен быть пустым;
  ectELEMENT	- содержимым является другой элемент;
  ectSEQ	- содержимым является последовательность элементов;
  ectCHOICE	- содержимым является набор возможных элементов.
}


  TECModificator= (ecmNone, ecmStar, ecmPlus, ecmQuestion);
{TECModificator задает параметр модификации содержимого элемента:
  ecmNone 	- содержимое является обязательной частью элемента;
  ecmStar	- содержимое может встретиться в элементе 0 и более раз;
  ecmPlus	- содержимое может встретиться в элементе 1 и более раз;
  ecmQuestion	- содержимое может присутствовать или нет, в любом случае
                  в элементе оно появляется всего один раз.
}
  TSGContent = class
   private
    FECModificator      : TECModificator;
    FECType             : TECType;
    procedure           SetECModificator(const Value: TECModificator);
    procedure           SetECType(const Value: TECType);
   protected
    FOwner              : TSGContent; {Владелец элемента}
   public
    constructor Create(
      AECType           : TECType;
      AECModificator    : TECModificator;
      AOwner            : TSGContent);
    property    Owner           : TSGContent read FOwner;
    property	ECModificator 	: TECModificator read FECModificator
                                                      write SetECModificator;
    property	ECType 		: TECType 	 read FECType write SetECType;
  end;

  TSGNamedContent = class(TSGContent)
   private
    FName: String;
   public
    constructor Create(
      AName : String;
      AECModificator : TECModificator;
      AOwner : TSGContent);
    {Имя элемента}
    property    Name : String read FName;
  end;

  TSGContents = array of TSGContent;

  TSGChildrenContent = class(TSGContent)
   private
    FContents		: TSGContents;
    {Добавляет новый элемент в список}
    procedure   Add(AContent : TSGContent);
   public
    {Создает объект и заполняет нужные поля}
    constructor Create(
      AECType		: TECType;
      AECModificator	: TECModificator;
      AOwner            : TSGContent);
    {Уничтожает все дочерние элементы}
    destructor 	Destroy;override;
    {Удаляет дочернее содержимое по индексу в списке}
    procedure	RemoveChildContent	(Index 		: Integer );
    {Добавляет в список FContents дочернее содержимое с именем}
    function   AddChildElem 	(
      AName             : String;
      AECModificator    : TECModificator) : TSGNamedContent;
    {Добавляет в список FContents дочернее содержимое типа [ectSEQ, ectCHOICE]}
    function    AddChildContent  (
      AECType : TECType;
      AECModificator : TECModificator) : TSGContent;
    {Возвращает ссылку на дочерний элемент,
      Index - индекс дочернего элемента в списке}
    function 	GetChildContent		(Index : Integer ) : TSGContent;
    {Возвращает количество дочерних элементов}
    function    GetChildCount 	: Integer;
  end;

implementation

{ TSGBasisContent }

constructor TSGContent.Create(AECType: TECType;
  AECModificator: TECModificator; AOwner : TSGContent);
begin
  FECType := AECType;
  FECModificator := AECModificator;
  FOwner := AOwner;
end;

procedure TSGContent.SetECModificator(const Value: TECModificator);
begin
  FECModificator := Value;
end;

procedure TSGContent.SetECType(const Value: TECType);
begin
  FECType := Value;
end;

{ TSGNamedContent }

constructor TSGNamedContent.Create(AName: String;
  AECModificator: TECModificator; AOwner: TSGContent);
begin
  inherited Create(ectELEMENT, AECModificator, AOwner);
  FName := AName;
end;

{ TSGContent }

procedure TSGChildrenContent.Add(AContent: TSGContent);
begin
  SetLength(FContents, Length(FContents)+1);
  FContents[High(FContents)] := AContent;
end;

function TSGChildrenContent.AddChildContent(AECType: TECType;
  AECModificator: TECModificator): TSGContent;
begin
  Result := TSGContent.Create(AECType, AECModificator, Self);
  Add(Result as TSGContent);
end;

function TSGChildrenContent.AddChildElem(AName: String;
  AECModificator: TECModificator): TSGNamedContent;
begin
  Result := TSGNamedContent.Create(AName, AECModificator, Self);
  Add(Result as TSGContent);
end;

constructor TSGChildrenContent.Create(AECType: TECType;
  AECModificator: TECModificator; AOwner: TSGContent);
begin
  inherited Create(AECType, AECModificator, AOwner);
  FContents := nil;
end;

destructor TSGChildrenContent.Destroy;
var
  I : Integer;
begin
  for I := Low(FContents) to High(FContents) do FContents[i].Free;
  FContents := nil;
end;

function TSGChildrenContent.GetChildContent(Index: Integer): TSGContent;
begin
  if (Index < Low(FContents)) and (Index > High(FContents)) then
    raise Exception.Create(Format(NotExistIndex, ['GetChildContent']))
  else Result := FContents[Index];
end;

function TSGChildrenContent.GetChildCount: Integer;
begin
  Result := Length(FContents);
end;

procedure TSGChildrenContent.RemoveChildContent(Index: Integer);
var
  I : Integer;
begin
  if (Index < Low(FContents)) and (Index > High(FContents)) then
    raise Exception.Create(Format(NotExistIndex, ['RemoveChildContent']))
  else begin
    FContents[Index].Free;
    if Length(FContents) > 1 then begin
      for I := Index to High(FContents)-1 do FContents[i] := FContents[i+1];
      SetLength(FContents, Length(FContents) - 1);
    end
    else FContents := nil;
  end;
end;

end.
