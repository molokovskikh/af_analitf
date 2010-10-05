unit U_XMLElementStructs;

interface

uses
  SysUtils, U_SGXMLGeneral, U_TSGXMLAttribute;

const
  NotExistAttributeIndex = 'U_XMLElementStructs:TSGXMLElement.%s - '+
                                '�������� � ����� �������� �� ����������.';
  NotExistAttributeName  = 'U_XMLElementStructs:TSGXMLElement.%s - '+
                                '�������� � ����� ������ �� ����������.';
  ExistAttributeName     = 'U_XMLElementStructs:TSGXMLElement.%s - '+
                                '�������� � ����� ������ ��� ����������.';
  NotExistChildName      = 'U_XMLElementStructs:TSGXMLElement.%s - '+
                           '�������� ������� � ����� ������ �� ����������.';
  ExistMoreChildName     = 'U_XMLElementStructs:TSGXMLElement.%s - '+
                           '�������� ��������� � ����� ������ ����� ������.';
  NotExistElementIndex   = 'U_XMLElementStructs:TSGXMLElement.%s - '+
                           '�������� ������� � ����� �������� �� ����������.';
  NotExistMoreChildName  = 'U_XMLElementStructs:TSGXMLElement.%s - '+
                                '���������� �������� ��������� � ����� ������ '+
                                '������ �������������� �������.';
  NotExistPCDataIndex    = 'U_XMLElementStructs:TSGXMLElement.GetPCData - '+
                           '������ PCData � ����� �������� �� ����������.';

type

  TSGBasisXMLNode = class
   private
    FOwner : TSGBasisXMLNode;
   public
    constructor Create(AOwner : TSGBasisXMLNode);
    property Owner : TSGBasisXMLNode read FOwner;
  end;

  TSGXMLAttributes = array of TSGXMLAttribute;

  TSGXMLElements   = array of TSGBasisXMLNode;

  TSGXMLPCData     = class;

  TSGXMLElement = class(TSGBasisXMLNode)
   private
    procedure   SetXMLElemName(const Value: String);
    procedure   Add(ABasisXMLNode : TSGBasisXMLNode);
    function    Get(Index: Integer): TSGBasisXMLNode;
    {������� �������� ������� �� ������� � ������ FXMLElements}
    //������� �������� ������� �� ������� Item.
    procedure   RemoveItem(Item : TSGBasisXMLNode);
    {������� �������� ������� � ������, �.�. � �������� FOwner = nil}
    function    FindRoot        : TSGXMLElement;
   protected
    FXMLElemName        : String;
    FXMLAttributes      : TSGXMLAttributes;
    FXMLElements        : TSGXMLElements;
    {���������� ���������� �������� ���������,����� ������ PCData}
    function    GetElementCountByName(AXMLElemName : String) : Integer;
    {���������� ������ N-�� ���������� � ������ ��������
     � ������ AXMLElemName, ���� ��� -1.}
    function    FindElement(
      AXMLElemName : String;
      N   : Integer) : Integer;
    {������� � ������ ��������� FXMLElements ���� ������ PCData.
    Index ��������� ����� ������ PCData, �� ��������� ���� �������. }
    function    FindPCData(Index : Integer) : Integer;
   public
    {������� ������� � ������ XMLElemName}
    constructor Create	       (
      AXMLElemName   	: String;
      AOwner            : TSGXMLElement);
    {�������� ������ ���������� � ������� ��� �������� ��������}
    destructor  Destroy;override;
    {������� ��� �������� ��������}
    procedure   Clear;
    {������� ��������}
    procedure   RemoveAttribute	(AttName      : String);     	overload;
    procedure   RemoveAttribute	(Index	      : Integer);	overload;
    {��������� ��������}
    function    AddAttribute   (
      AAttName : String;
      AAttType : TEAType;
      AAttValue : String) : TSGXMLAttribute;
    {��������� �������� ������� XMLElement � ������ FXMLElements ���������}
    function    AddElement(AXMLElemName : String): TSGXMLElement;overload;
    {��������� �������� ������� XMLElement � ������ FXMLElements
      � �������� Index}
    function    AddElement     (
      AXMLElemName   	: String;
      Index             : Integer): TSGXMLElement;              overload;
    {��������� PCData}
    function    AddPCData(AValue : String) : TSGXMLPCData;
    {���������� ��� �������� ������ PCData � ����� ������}
    function    AllPCData : String;
    {���������� ���� ��������� ��� ��������� ������, ������� ���
    �������� ��������}
    function    ElementAsText(TabShift : String) : String;
    {���������� ������ �� �������� �� ������� � ������}
    function    GetAttribute    (Index  : Integer): TSGXMLAttribute; overload;
    {���������� ������ �� �������� �� �����}
    function    GetAttribute    (AttName : String): TSGXMLAttribute; overload;
    {���������� ��� ��������� �� ������� � ������}
    function	GetAttributeName(Index   : Integer): String;
    {���������� ������ ��������� � ������,
      ���� �������� eaName ����������, ����� -1}
    function    FindAttribute    (AttName : String) : Integer;
    {���������� �������� ���������}
    function	GetAttributeValue(AttName      : String)  : String;  overload;
    function	GetAttributeValue(Index        : Integer) : String; overload;
    {���������� ������ �� ������ �������.
     ������:

     var
       XMLTmp : TSGXMLElement;
     begin
       XMLTmp := Tmp.GetElement('Root.ActionNet', 2).GetElement('TOU', 3);
     end;

         }
    function    GetElement     (
      Path : String)               : TSGXMLElement; overload;
    function    GetElement     (
      Path : String; N : Integer ) : TSGXMLElement; overload;
    {���������� ��������� �� ������ PCData, Index - ����� ������ �� �������}
    function    GetPCData(Index : Integer) : TSGXMLPCData;
    {���������� ���������� ���� ���������}
    function    GetCount : Integer;
    {���������� ���������� �������� ���������,����� ������ PCData}
    function    GetElementCount(Path : String) : Integer; virtual;
    {���������� ���������� ������ PCData}
    function    GetPCDataCount       : Integer;
    {���������� ���������� ����������}
    function    GetAttributeCount : Integer;
    property    XMLElemName : String read FXMLElemName write SetXMLElemName;
    property    Items[Index : Integer] : TSGBasisXMLNode read Get; default;
  end;

  TSGXMLPCData = class(TSGBasisXMLNode)
   private
    FValue: String;
    procedure SetValue(const Value: String);
   public
    constructor Create(AValue : String; AOwner : TSGBasisXMLNode);
    destructor  Destroy; override;
    property    Value : String read FValue write SetValue;
  end;

implementation

uses
  U_TSGXMLDocument;

{ TSGBasisXMLNode }

constructor TSGBasisXMLNode.Create(AOwner: TSGBasisXMLNode);
begin
  FOwner := AOwner;
end;

{ TSGXMLElement }

function TSGXMLElement.AddAttribute(AAttName : String; AAttType : TEAType;
      AAttValue : String): TSGXMLAttribute;
var
  Index : Integer;
  XMLDoc : TSGXMLElement;
begin
  Index := FindAttribute(AAttName);
  if (Index <> -1) then
    raise Exception.Create(Format(ExistAttributeName, ['AddAttribute']));
  XMLDoc := FindRoot;
  if XMLDoc is TSGXMLDocument then
    TSGXMLDocument(XMLDoc).ReplaceEntities(AAttValue);
  Result := TSGXMLAttribute.Create(AAttName, AAttType, AAttValue);
  SetLength(FXMLAttributes, Length(FXMLAttributes) + 1);
  FXMLAttributes[High(FXMLAttributes)] := Result;
end;

function TSGXMLElement.AddElement(AXMLElemName : String): TSGXMLElement;
begin
  Result := TSGXMLElement.Create(AXMLElemName, Self);
  Add(Result as TSGBasisXMLNode)
end;

constructor TSGXMLElement.Create(AXMLElemName : String;
  AOwner: TSGXMLElement);
begin
  inherited Create(AOwner);
  FXMLElements := nil;
  FXMLElemName := AXMLElemName;
end;

destructor TSGXMLElement.Destroy;
begin
  if FOwner <> nil then
    if FOwner is TSGXMLElement then TSGXMLElement(FOwner).RemoveItem(Self);
  Clear;
end;

function TSGXMLElement.GetAttributeName(Index: Integer): String;
begin
  if (Index < Low(FXMLAttributes)) or (Index > High(FXMLAttributes)) then
    raise Exception.Create(Format(NotExistAttributeIndex,['GetAttributeName']));
  Result := FXMLAttributes[Index].AttName;
end;

function TSGXMLElement.GetAttributeValue(AttName: String): String;
var
  Index : Integer;
begin
  Index := FindAttribute(AttName);
  if (Index = -1) then
    raise Exception.Create(Format(NotExistAttributeName,['GetAttributeValue']));
  Result := GetAttributeValue(Index);
end;

function TSGXMLElement.GetAttributeValue(Index: Integer): String;
begin
  if (Index < Low(FXMLAttributes)) or (Index > High(FXMLAttributes)) then
   raise Exception.Create(Format(NotExistAttributeIndex,['GetAttributeValue']));
  Result := FXMLAttributes[Index].Value;
end;

function TSGXMLElement.GetElementCountByName(AXMLElemName : String): Integer;
var
  I : Integer;
begin
  Result := 0;
  for I := Low(FXMLElements) to High(FXMLElements) do
    if FXMLElements[i] is TSGXMLElement then
      if TSGXMLElement(FXMLElements[i]).FXMLElemName = AXMLElemName then
        Inc(Result);
end;

function TSGXMLElement.GetElement(Path: String): TSGXMLElement;
var
  ElemIndex,
  PointIndex : Integer;
  ChildName  : String;
begin
  ChildName := Path;
  PointIndex := Pos('.', ChildName); // ���� �����
  if PointIndex <> 0 then begin
    SetLength(ChildName, PointIndex - 1);  //���� �����, �� �������� ���
    System.Delete(Path, 1, PointIndex);
  end;
  ElemIndex := FindElement(ChildName, 0);//���� �������� �������
  if ElemIndex <> -1 then
    if FindElement(ChildName, 1) = -1 then
                         //���� ��������� ������� � ����� ������
      if PointIndex <> 0 then
        Result := TSGXMLElement(FXMLElements[ElemIndex]).GetElement(Path)
      else Result := TSGXMLElement(FXMLElements[ElemIndex])
    else raise Exception.Create(Format(ExistMoreChildName, ['GetElement']))
  else raise Exception.Create(Format(NotExistChildName, ['GetElement']));
end;

function TSGXMLElement.GetElement(Path: string; N: Integer): TSGXMLElement;
var
  ElemIndex,
  PointIndex : Integer;
  ChildName  : String;
begin
  if N < 0 then
    raise Exception.Create(Format(NotExistElementIndex, ['GetElement']));
  ChildName := Path;
  PointIndex := Pos('.', ChildName); // ���� �����
  if PointIndex <> 0 then begin
    SetLength(ChildName, PointIndex - 1); //���� �����, �� �������� ���
    System.Delete(Path, 1, PointIndex);
  end;
  ElemIndex := FindElement(ChildName, 0); //���� �������� �������
  if ElemIndex <> -1 then
    if PointIndex <> 0 then //���� ����� ����
      if FindElement(ChildName, 1) = -1 then
                     //���� ��������� ������� � ����� ������
        Result := TSGXMLElement(FXMLElements[ElemIndex]).GetElement(Path, N)
      else raise Exception.Create(Format(ExistMoreChildName, ['GetElement']))
    else begin
      //���� ����� ���, �� � ���� N-�� �������� �������
      ElemIndex := FindElement(ChildName, N);
      if ElemIndex <> -1 then
        Result := TSGXMLElement(FXMLElements[ElemIndex])
      else raise Exception.Create(Format(NotExistMoreChildName, ['GetElement']))
    end
  else raise Exception.Create(Format(NotExistChildName, ['GetElement']));
end;

procedure TSGXMLElement.RemoveAttribute(AttName: String);
var
  Index : Integer;
begin
  Index := FindAttribute(AttName);
  if (Index = -1) then
    raise Exception.Create(Format(NotExistAttributeName, ['RemoveAttribute']));
  RemoveAttribute(Index);
end;

procedure TSGXMLElement.RemoveAttribute(Index: Integer);
var
  I : Integer;
begin
  if (Index < Low(FXMLAttributes)) or (Index > High(FXMLAttributes)) then
    raise Exception.Create(Format(NotExistAttributeIndex, ['RemoveAttribute']));
  FXMLAttributes[Index].Free;
  if Length(FXMLAttributes) > 1 then begin
    for I := Index to High(FXMLAttributes)-1 do
      FXMLAttributes[i] := FXMLAttributes[i+1];
    SetLength(FXMLAttributes, Length(FXMLAttributes) - 1);
  end
  else FXMLAttributes := nil;
end;

function TSGXMLElement.FindAttribute(AttName: String): Integer;
begin
  for Result := Low(FXMLAttributes) to High(FXMLAttributes) do
    if FXMLAttributes[Result].AttName = AttName then Exit;
  Result := -1;
end;

function TSGXMLElement.FindElement(AXMLElemName: String;
  N: Integer): Integer;
var
  Count : Integer;
begin
  Count := -1;
  for Result := Low(FXMLElements) to High(FXMLElements) do
    if FXMLElements[Result] is TSGXMLElement then
      if TSGXMLElement(FXMLElements[Result]).XMLElemName = AXMLElemName then
      begin
        Inc(Count);
        if Count = N then exit;
      end;
  Result := -1;
end;

function TSGXMLElement.GetAttributeCount: Integer;
begin
  Result := Length(FXMLAttributes);
end;

procedure TSGXMLElement.Clear;
var
  I : Integer;
begin
  for I := High(FXMLElements) downto Low(FXMLElements) do FXMLElements[i].Free;
  for I := Low(FXMLAttributes) to High(FXMLAttributes)do FXMLAttributes[i].Free;
  FXMLElements := nil;
  FXMLAttributes := nil;
end;

function TSGXMLElement.GetAttribute(Index: Integer): TSGXMLAttribute;
begin
  if (Index < Low(FXMLAttributes)) or (Index > High(FXMLAttributes)) then
    raise Exception.Create(Format(NotExistAttributeIndex, ['GetAttribute']));
  Result := FXMLAttributes[Index];
end;

function TSGXMLElement.GetAttribute(AttName: String): TSGXMLAttribute;
var
  Index : Integer;
begin
  Index := FindAttribute(AttName);
  if (Index = -1) then
    raise Exception.Create(Format(NotExistAttributeName, ['GetAttribute']));
  Result := FXMLAttributes[Index];
end;

procedure TSGXMLElement.SetXMLElemName(const Value: String);
begin
  FXMLElemName := Value;
end;

procedure TSGXMLElement.RemoveItem(Item: TSGBasisXMLNode);
var
  Index,
  I : Integer;
begin
  for Index := Low(FXMLElements) to High(FXMLElements) do
    if FXMLElements[Index] = Item then Break;
  FXMLElements[Index].FOwner := nil;
  if Length(FXMLElements) > 1 then begin
    for I := Index to High(FXMLElements)-1 do
      FXMLElements[i] := FXMLElements[i+1];
    SetLength(FXMLElements, Length(FXMLElements) - 1);
  end
  else FXMLElements := nil;
end;

procedure TSGXMLElement.Add(ABasisXMLNode: TSGBasisXMLNode);
begin
  SetLength(FXMLElements, Length(FXMLElements)+1);
  FXMLElements[High(FXMLElements)] := ABasisXMLNode;
end;

function TSGXMLElement.AddPCData(AValue: String): TSGXMLPCData;
var
  XMLDoc : TSGXMLElement;
begin
  XMLDoc := FindRoot;
  if XMLDoc is TSGXMLDocument then
    TSGXMLDocument(XMLDoc).ReplaceEntities(AValue);
  Result := TSGXMLPCData.Create(AValue, Self);
  Add(Result as TSGBasisXMLNode);
end;

function TSGXMLElement.GetPCDataCount: Integer;
var
  I : Integer;
begin
  Result := 0;
  for I := Low(FXMLElements) to High(FXMLElements) do
    if FXMLElements[i] is TSGXMLPCData then Inc(Result);
end;

function TSGXMLElement.GetPCData(Index: Integer): TSGXMLPCData;
var
  PCDataIndex : Integer;
begin
  PCDataIndex := FindPCData(Index);
  if PCDataIndex = -1 then
    raise Exception.Create(NotExistPCDataIndex);
  Result := TSGXMLPCData(FXMLElements[PCDataIndex]);
end;

function TSGXMLElement.FindPCData(Index: Integer): Integer;
var
  Count : Integer;
begin
  Count := -1;
  for Result := Low(FXMLElements) to High(FXMLElements) do
    if (FXMLElements[Result] is TSGXMLPCData) then begin
      Inc(Count);
      if Count = Index then Exit;
    end;
  Result := -1;
end;

function TSGXMLElement.AllPCData: String;
var
  I : Integer;
begin
  Result := '';
  for I := Low(FXMLElements) to High(FXMLElements) do
    if FXMLElements[i] is TSGXMLPCData then
      Result := Result + TSGXMLPCData(FXMLElements[i]).Value;
end;

function TSGXMLElement.GetCount: Integer;
begin
  Result := Length(FXMLElements);
end;

function TSGXMLElement.Get(Index: Integer): TSGBasisXMLNode;
begin
  if (Index < Low(FXMLElements)) or (Index > High(FXMLElements)) then
    raise Exception.Create(Format(NotExistElementIndex, ['Get']));
  Result := FXMLElements[Index];
end;

function TSGXMLElement.FindRoot: TSGXMLElement;
var
  Temp : TSGBasisXMLNode;
begin
  Temp := Self;
  while Temp.FOwner <> nil do Temp := Temp.FOwner;
  Result := TSGXMLElement(Temp);
end;

function TSGXMLElement.ElementAsText(TabShift: String): String;
var
  XMLDoc : TSGXMLElement;
  TmpStr : String;
  I      : Integer;
  //�������� �������� ������ PCData
  OnlyPCData : Boolean;
begin
  XMLDoc := FindRoot;
  Result := TabShift + '<' + XMLElemName;
  for I := 0 to GetAttributeCount-1 do begin
    Result := Result + #13#10 + TabShift + '  ';
    Result := Result + GetAttributeName(i) + '=';
    TmpStr := GetAttributeValue(i);
    if XMLDoc is TSGXMLDocument then
      TSGXMLDocument(XMLDoc).ReplaceText(TmpStr);
    Result := Result + '"' + TmpStr + '"';
  end;
  if GetCount = 0 then
    Result := Result + '/>'
  else begin
    Result := Result + '>';
  {
    for I := 0 to GetCount-1 do
      if Items[i] is TSGXMLElement then begin
        TmpStr := TSGXMLElement(Items[i]).ElementAsText(TabShift + '  ');
        Result := Result + TmpStr + #13#10;
      end
      else begin
        TmpStr := TSGXMLPCData(Items[i]).Value;
        if XMLDoc is TSGXMLDocument then
          TSGXMLDocument(XMLDoc).ReplaceText(TmpStr);
        Result := Copy(Result, 1, Length(Result)-2) + TmpStr;
      end;
    Result := Result + TabShift + '</' + XMLElemName + '>';
  }

    //����� ������ ������ ��������
    OnlyPCData := GetAttributeCount = 0;
    if OnlyPCData then
      for I := 0 to GetCount-1 do
        if not (Items[i] is TSGXMLPCData) then begin
          OnlyPCData := False;
          Break;
        end;
    if not OnlyPCData then
      Result := Result + #13#10;
    for I := 0 to GetCount-1 do
      if Items[i] is TSGXMLElement then begin
        TmpStr := TSGXMLElement(Items[i]).ElementAsText(TabShift + '  ');
        Result := Result + TmpStr + #13#10;
      end
      else begin
        TmpStr := TSGXMLPCData(Items[i]).Value;
        if XMLDoc is TSGXMLDocument then
          TSGXMLDocument(XMLDoc).ReplaceText(TmpStr);
        if OnlyPCData then
          Result := Result + TmpStr
        else
          Result := Result + TabShift + '  ' + TmpStr + #13#10;
      end;
    if OnlyPCData then
      Result := Result + '</' + XMLElemName + '>'
    else
      Result := Result + TabShift + '</' + XMLElemName + '>';
  end;
end;

function TSGXMLElement.AddElement(AXMLElemName: String;
  Index: Integer): TSGXMLElement;
var
  I : Integer;
begin
  if (Index < Low(FXMLElements)) or (Index > High(FXMLElements)) then
    raise Exception.Create(Format(NotExistElementIndex, ['AddElement']));
  Result := TSGXMLElement.Create(AXMLElemName, Self);
  SetLength(FXMLElements, Length(FXMLElements)+1);
  for I := High(FXMLElements) downto Index+1 do
    FXMLElements[i] := FXMLElements[i-1];
  FXMLElements[Index] := Result;
end;

function TSGXMLElement.GetElementCount(Path: String): Integer;
var
  ElemIndex,
  PointIndex : Integer;
  ChildName  : String;
begin
  ChildName := Path;
  PointIndex := Pos('.', ChildName); // ���� �����
  if PointIndex <> 0 then begin
    SetLength(ChildName, PointIndex - 1);  //���� �����, �� �������� ���
    System.Delete(Path, 1, PointIndex);
  end;
  if PointIndex <> 0 then begin
    ElemIndex := FindElement(ChildName, 0);//���� �������� �������
    if ElemIndex <> -1 then
      if FindElement(ChildName, 1) = -1 then
        Result := TSGXMLElement(FXMLElements[ElemIndex]).GetElementCount(Path)
      else raise Exception.Create(Format(ExistMoreChildName,
                             ['GetElementCount']))
    else raise Exception.Create(Format(NotExistChildName, ['GetElementCount']));
  end
  else Result := GetElementCountByName(ChildName);
end;

{ TSGXMLPCData }

constructor TSGXMLPCData.Create(AValue: String; AOwner: TSGBasisXMLNode);
begin
  inherited Create(AOwner);
  FValue := AValue;
end;

destructor TSGXMLPCData.Destroy;
begin
  if FOwner <> nil then
    if FOwner is TSGXMLElement then TSGXMLElement(FOwner).RemoveItem(Self);
end;

procedure TSGXMLPCData.SetValue(const Value: String);
begin
  FValue := Value;
end;

end.
