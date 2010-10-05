unit U_XMLElementContents;

interface

uses
  SysUtils;
   
const
  NotExistIndex   = 'U_ElementContents:TSGChildrenContent.%s - '+
                        '�������� ������� � ����� �������� �� ����������.';

type

{������� EC = Element Content}

  TECType 	= (ectANY, ectEMPTY, ectPCDATA, ectELEMENT, ectSEQ, ectCHOICE);
{TECType ������ ��������� ���� ����������� ��������� � ���������:
  ectANY 	- ����� ����������;
  ectPCDATA	- ����� ���������� ������;
  ectEMPTY	- ������� ������ ���� ������;
  ectELEMENT	- ���������� �������� ������ �������;
  ectSEQ	- ���������� �������� ������������������ ���������;
  ectCHOICE	- ���������� �������� ����� ��������� ���������.
}


  TECModificator= (ecmNone, ecmStar, ecmPlus, ecmQuestion);
{TECModificator ������ �������� ����������� ����������� ��������:
  ecmNone 	- ���������� �������� ������������ ������ ��������;
  ecmStar	- ���������� ����� ����������� � �������� 0 � ����� ���;
  ecmPlus	- ���������� ����� ����������� � �������� 1 � ����� ���;
  ecmQuestion	- ���������� ����� �������������� ��� ���, � ����� ������
                  � �������� ��� ���������� ����� ���� ���.
}
  TSGContent = class
   private
    FECModificator      : TECModificator;
    FECType             : TECType;
    procedure           SetECModificator(const Value: TECModificator);
    procedure           SetECType(const Value: TECType);
   protected
    FOwner              : TSGContent; {�������� ��������}
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
    {��� ��������}
    property    Name : String read FName;
  end;

  TSGContents = array of TSGContent;

  TSGChildrenContent = class(TSGContent)
   private
    FContents		: TSGContents;
    {��������� ����� ������� � ������}
    procedure   Add(AContent : TSGContent);
   public
    {������� ������ � ��������� ������ ����}
    constructor Create(
      AECType		: TECType;
      AECModificator	: TECModificator;
      AOwner            : TSGContent);
    {���������� ��� �������� ��������}
    destructor 	Destroy;override;
    {������� �������� ���������� �� ������� � ������}
    procedure	RemoveChildContent	(Index 		: Integer );
    {��������� � ������ FContents �������� ���������� � ������}
    function   AddChildElem 	(
      AName             : String;
      AECModificator    : TECModificator) : TSGNamedContent;
    {��������� � ������ FContents �������� ���������� ���� [ectSEQ, ectCHOICE]}
    function    AddChildContent  (
      AECType : TECType;
      AECModificator : TECModificator) : TSGContent;
    {���������� ������ �� �������� �������,
      Index - ������ ��������� �������� � ������}
    function 	GetChildContent		(Index : Integer ) : TSGContent;
    {���������� ���������� �������� ���������}
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
