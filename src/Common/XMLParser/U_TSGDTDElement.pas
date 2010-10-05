unit U_TSGDTDElement;


interface

uses
  U_XMLElementContents, SysUtils, Controls;

const
  ExistName       = 'U_TSGDTDElemet:TSGDTDElement.AddAttribute - '+
                        '�������� � ����� ������ ��� ����������.';
  NotExistIndex   = 'U_TSGDTDElemet:TSGDTDElement.%s - '+
                        '�������� � ����� �������� �� ����������.';
  NotExistName    = 'U_TSGDTDElemet:TSGDTDElement.%s - '+
                        '�������� � ����� ������ �� ����������.';
  NotExistPointer = 'U_TSGDTDElemet:TSGDTDElement.Create -'+
                    '��������� �������� Nil.';


type

{��������� ������ TDTDElement}

  {TEAType �������� ��������� ���� ����������}
  TEAType 	 = (eatNone, eatCDATA, eatID, eatIDREF, eatIDREFS, eatENTITY,
                    eatENTITIES, eatNMTOKEN, eatNMTOKENS, eatEnum);
{TEAType ������ �������� �������� ����� ���������:
  eatNone       - ��� ����,
  eatCDATA      - ����� ���������� ������,
  eatID         - �������� ���������� �������������� � ���������,
  eatIDREF      - �������� ���������� ��������������, ��������� � ��� ���������,
  eatIDREFS     - ��������� IDREF, ����������� ���������,
  eatENTITY     - �������� ��� ENTITY, ��������� � ���������,
  eatENTITIES   - ��������� ENTITY, ����������� ���������,
  eatNMTOKEN    - �������� ���� �����,
  eatNMTOKENS   - ������� ��������� ����, ����������� ���������,
  eatEnum       - �������� ����� ������������ ���
}

  TEASpecification = (easNone, easRequired, easImplied, easFixed);
  {TEASpecification �������� ��������� ������������ ����������:
    easNone 	- ��� �����������;
    easRequired	- �������� �������� ������������;
    easImplied	- �������� �� �������� ������������;
    easFixed	- �������� ����� ������������� ��������.
  }

  {�������� ��������� � DTD-��������}
  TSGDTDAttribute = record
    eaName	       : String;           {��� ���������}
    eaType             : TEAType;          {��� ���������}
    eaSpecification    : TEASpecification; {������������ ���������}
    eaEnumeratedValues : String;           {������������� �������� ���������,
                                            ����� ���� ��� ��������}
    eaDefaultValue     : String;        {���� �� �����,�� �������� �� ���������}
  end;

  TSGDTDAttributes = array of TSGDTDAttribute;

{
��� ������ ����� DTDElement:
1. ��������� ��� ��������, ��� ����������, ��������� � �� ������ � ����������
2. ������������� ������� ������ � ������
   a) ����� ��������� ��������
   �) ����� ���������
   �) ������ � �������� ��������
   �) ������ �� ���������
   �)

�� ���������:
- ���
- ������������
- ������������� ��������
- ���
- �������� �� ���������

�� ��������
- ���
- �����������
- ����� ������������� ���������
}


  {��������� �������� � DTD-��������}
  TSGDTDElement = class
  private
    FDTDElemName   : String;
    FContent       : TSGContent;
    FDTDAttributes : TSGDTDAttributes;
    {���������� ��������� �� ���������� ��������}
    function    GetContent: TSGContent;
  public
     {�������� ������ ����������, ���������� ��� DTDElemName
      � ���������� Content ��������}
    constructor Create(
          DTDElemName : String;
          AContent    : TSGContent);
     {���������� ������ ���������}
    destructor  Destroy;override;
    {������� �������� eaName}
    procedure   RemoveAttribute           (eaName : String);    overload;
    procedure   RemoveAttribute           (Index  : Integer);	overload;

    {��������� �������� � ������ ����������}
    function    AddAttribute(
      AeaName             : String;
      AeaType             : TEAType;
      AeaSpecification    : TEASpecification;
      AeaEnumeratedValues : String;
      AeaDefaultValue     : String) : Integer;
    {���������� ������ ��������� � ������,
     ���� �������� eaName ����������, ����� -1}
    function    FindAttribute            (eaName : String) : Integer;
    {���������� ���������� ���������� ��������}
    function    GetAttributeCount	: Integer;
    {�� ������� ���������� ��� ���������}
    function	GetAttributeName	  (Index  : Integer) : String;
    {���������� ��� ��������� eaName}
    function    GetAttributeType          (eaName : String)  : TEAType;overload;
    function    GetAttributeType          (Index  : Integer) : TEAType;overload;
    {���������� ������������ ��������� eaName}
    function    GetAttributeSpecification (
      eaName : String)  : TEASpecification;overload;
    function    GetAttributeSpecification (
      Index  : Integer) : TEASpecification;overload;
    {���������� ��������� ������������� �������� ���������}
    function    GetAttributeEnumValues    (eaName : String)  : String;overload;
    function    GetAttributeEnumValues    (Index  : Integer) : String;overload;
    {��������� �������� ��������� �� ���������}
    function    GetAttributeDefaultValue  (eaName : String)  : String;overload;
    function    GetAttributeDefaultValue  (Index  : Integer) : String;overload;
    {�������� ��� ���������� ��������}
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