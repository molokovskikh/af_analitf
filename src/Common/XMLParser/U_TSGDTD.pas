unit U_TSGDTD;

interface

uses
  U_XMLElementContents, U_TSGDTDElement, SysUtils;

const
  ExistName       = 'U_TSGDTD:TSGDTD.%s - '+
                        '������� � ����� ������ ��� ����������.';
  NotExistIndex   = 'U_TSGDTD:TSGDTD.%s - '+
                        '������� � ����� �������� �� ����������.';
  NotExistName    = 'U_TSGDTD:TSGDTD.%s - '+
                        '������� � ����� ������ �� ����������.';

type

 {��������� ����� ���������� ������������}

  TSGDTDElements = array of TSGDTDElement;

  TSGDTD = class
   private
    FDTDElements: TSGDTDElements;
    FRootName   : String;
   public
    {�������� ������ ���������}
    constructor Create(ARootName : String);
    {�������� ���� ������ � ������� ��� ��������}
    destructor  Destroy; override;
    {������� ��� �������� ��������}
    procedure   Clear;
    {������� ������� � ������ DTDElemName �� ������ ��������� ���������}
    procedure   RemoveElement(DTDElemName : String);    	overload;
    procedure   RemoveElement(Index       : Integer);   	overload;
    {��������� � ������ ��������� ��������� FDTDElements ����� �������
     � ������ DTDElemName � ���������� Content}
    function   AddElement(
                  DTDElemName : String;
                  Content  : TSGContent) : TSGDTDElement;
    {���������� True, ���� ������� DTDElemName ����������}
    function    FindElement  (DTDElemName : String)  : Integer;
    {���������� ���������� ��������� ���������}
    function    GetElementCount : Integer;
    {���������� ������ �� �������, ���� �� ����������}
    function    GetElement   (Index	  : Integer) : TSGDTDElement;overload;
    function    GetElement   (DTDElemName : String)  : TSGDTDElement;overload;
    property    RootName : String read FRootName write FRootName;
  end;

implementation

{ TSGDTD }

function TSGDTD.AddElement(DTDElemName: String;
  Content: TSGContent): TSGDTDElement;
begin
  if (FindElement(DTDElemName) <> -1) then
    raise Exception.Create(Format(ExistName, ['AddElement']))
  else begin
    SetLength(FDTDElements, Length(FDTDElements) + 1);
    Result := TSGDTDElement.Create(DTDElemName, Content);
    FDTDElements[High(FDTDElements)] := Result;
  end;
end;

procedure TSGDTD.Clear;
var
  I : Integer;
begin
  for I := Low(FDTDElements) to High(FDTDElements) do FDTDElements[i].Free;
  FDTDElements := Nil;
end;

constructor TSGDTD.Create(ARootName : String);
begin
  inherited Create;
  FDTDElements := Nil;
  FRootName := ARootName;
end;

destructor TSGDTD.Destroy;
begin
  Clear;
end;

function TSGDTD.FindElement(DTDElemName: String): Integer;
begin
  for Result := Low(FDTDElements) to High(FDTDElements) do
    if FDTDElements[Result].DTDElemName = DTDElemName then exit;
  Result := -1;
end;

function TSGDTD.GetElement(DTDElemName: String): TSGDTDElement;
var
  Index : Integer;
begin
  Index := FindElement(DTDElemName);
  if (Index = -1) then
    raise Exception.Create(Format(NotExistName, ['GetElement']))
  else Result := FDTDElements[Index];
end;

function TSGDTD.GetElement(Index: Integer): TSGDTDElement;
begin
  if (Index < Low(FDTDElements)) and (Index > High(FDTDElements)) then
    raise Exception.Create(Format(NotExistIndex, ['GetElement']))
  else Result := FDTDElements[Index];
end;

function TSGDTD.GetElementCount: Integer;
begin
  Result := Length(FDTDElements);
end;

procedure TSGDTD.RemoveElement(Index: Integer);
var
  I : Integer;
begin
  if (Index < Low(FDTDElements)) and (Index > High(FDTDElements)) then
    raise Exception.Create(Format(NotExistIndex, ['RemoveElement']))
  else begin
    FDTDElements[Index].Free;
    if Length(FDTDElements) > 1 then begin
      for I := Index to High(FDTDElements)-1 do
        FDTDElements[i] := FDTDElements[i+1];
      SetLength(FDTDElements, Length(FDTDElements) - 1);
    end
    else FDTDElements := nil;
  end;
end;

procedure TSGDTD.RemoveElement(DTDElemName: String);
var
  Index : Integer;
begin
  Index := FindElement(DTDElemName);
  if (Index = -1) then
    raise Exception.Create(Format(NotExistName, ['RemoveElement']))
  else RemoveElement(Index);
end;

end.