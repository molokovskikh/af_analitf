unit U_TSGXMLDocument;


interface

uses
  SysUtils, Classes, U_SGXMLGeneral, U_XMLElementStructs, U_SXConversions;

const
  NotExistRootName      = 'U_TSGXMLDocument:TSGXMLDocument.%s - '+
                                '�������� ������� ����� ������ ���.';
  NotExistMoreRootName  = 'U_TSGXMLDocument:TSGXMLDocument.%s - '+
                                '� ��������� ���� �������� �������.';
  ErrorSaveToStream     = 'U_TSGXMLDocument:TSGXMLDocument.SaveToStream - '+
                          '������ ��� ������ � �����.';
  ErrorSaveToFile       = 'U_TSGXMLDocument:TSGXMLDocument.SaveToFile - '+
                          '������ ��� ������ � ����.';

type

  TSGXMLDocument = class(TSGXMLElement)
   private
    FStandalone: Boolean;
    FEncoding: String;
    FVersion: String;
    procedure   SetEncoding(const Value: String);
    procedure   SetStandalone(const Value: Boolean);
    procedure   SetVersion(const Value: String);
    function    GetRootName: String;
    procedure   SetRootName(const Value: String);
   public
    {������� ��������� ������}
    constructor Create;
    {���������� �������}
    destructor  Destroy; override;
    {������� ��������}
    procedure   Clear;
    {��������� ���� ��������� � ����}
    procedure   SaveToFile(FileName : String);
    {��������� ���� ��������� � �����}
    procedure   SaveToStream(Stream : TStream);
    {� ������ AValue ���� ������������ ������� � �������� �� �� �����}
    procedure   ReplaceEntities(var AValue : String);
    {� ������ AValue ���� ��������� ������� ['''', '<', '>', '&', '"'] �
      �������� �� �� ������������ �������}
    procedure   ReplaceText(var AValue : String);
    {���������� ���� ��������� � ���� ������}
    function    AsText : String;
    {������� ������������ ����� ������� AValue, � ���� �������,
     �� ���������� ������, ����� -1}
    function    FindEntity(AValue : String) : Integer;
    {���������� ������ �� ������ �������.
     ������:

     var
       XMLDoc : TSGXMLDocument;
       XMLTmp : TXMLElement;
     begin
       XMLTmp := XML.DocGetElement('Root.ActionNet', 2).GetElement('TOU', 3);
     end;

         }
    function    GetElement     (
      Path : String)               : TSGXMLElement; overload;
    function    GetElement     (
      Path : string; N : Integer ) : TSGXMLElement; overload;
    function    GetElementCount(Path : String) : Integer; override;
    {��� ��������� ��������}
    property    RootName   : String read GetRootName write SetRootName;
    property    Standalone : Boolean read FStandalone write SetStandalone;
    property    Version    : String read FVersion write SetVersion;
    property    Encoding   : String read FEncoding write SetEncoding;
  end;


implementation

{ TSGXMLDocument }

function TSGXMLDocument.AsText: String;
begin
  Result := '<?xml version = "' + Version + '"';
  if Encoding <> '' then
    Result := Result + ' encoding = "' + Encoding + '"';
    Result := Result + ' standalone = "';
  if Standalone then
     Result := Result + 'yes'
  else Result := Result + 'no';
  Result := Result + '" ?>'#13#10;
  Result := Result + inherited ElementAsText('');
end;

constructor TSGXMLDocument.Create;
begin
  inherited Create('', nil);
end;

destructor TSGXMLDocument.Destroy;
begin
  inherited Destroy;
end;

function TSGXMLDocument.GetElement(Path: String): TSGXMLElement;
var
  PointIndex : Integer;
  ChildName  : String;
begin
  ChildName := Path;
  PointIndex := Pos('.', ChildName);  //���� �����
  if PointIndex <> 0 then begin
    SetLength(ChildName, PointIndex - 1); //�������� ���
    System.Delete(Path, 1, PointIndex);
  end;
  if ChildName = FXMLElemName then     //���������� � ������ �����
    if PointIndex <> 0 then
      Result := inherited GetElement(Path)
    else Result := TSGXMLElement(Self)
  else raise Exception.Create(Format(NotExistRootName, ['GetElement']));
end;

function TSGXMLDocument.FindEntity(AValue: String): Integer;
begin
  for Result := 0 to GeneralEntitiesCount-1 do
    if GeneralEntities[Result] = AValue then Exit;
  Result := -1;
end;

function TSGXMLDocument.GetElement(Path: String; N: Integer): TSGXMLElement;
var
  PointIndex : Integer;
  ChildName  : String;
begin
  ChildName := Path;
  PointIndex := Pos('.', ChildName);  //���� �����
  if PointIndex <> 0 then begin
    SetLength(ChildName, PointIndex - 1);  //�������� ���
    System.Delete(Path, 1, PointIndex);
  end;
  if ChildName = FXMLElemName then      //���������� � ������ �����
    if PointIndex <> 0 then
      Result := inherited GetElement(Path, N)
    else raise Exception.Create(Format(NotExistMoreRootName, ['GetElement']))
  else raise Exception.Create(Format(NotExistRootName, ['GetElement']));
end;

procedure TSGXMLDocument.ReplaceEntities(var AValue: String);
begin
  AValue := SXReplaceText(AValue);
end;

procedure TSGXMLDocument.ReplaceText(var AValue: String);
begin
  AValue := SXReplaceXML(AValue);
end;

procedure TSGXMLDocument.SaveToFile(FileName: String);
var
  Stream : TStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmCreate);
  except
    raise Exception.Create(ErrorSaveToFile);
  end;
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TSGXMLDocument.SaveToStream(Stream: TStream);
var
  S: string;
begin
  try
    S := AsText;
    Stream.WriteBuffer(Pointer(S)^, Length(S));
  except
    raise Exception.Create(ErrorSaveToStream);
  end;
end;

procedure TSGXMLDocument.SetEncoding(const Value: String);
begin
  FEncoding := Value;
end;

procedure TSGXMLDocument.SetStandalone(const Value: Boolean);
begin
  FStandalone := Value;
end;

procedure TSGXMLDocument.SetVersion(const Value: String);
begin
  FVersion := Value;
end;

procedure TSGXMLDocument.Clear;
begin
  inherited Clear;
  RootName := '';
  FEncoding := '';
  FVersion := '';
  FStandalone := False;
end;

function TSGXMLDocument.GetRootName: String;
begin
  Result := FXMLElemName;
end;

procedure TSGXMLDocument.SetRootName(const Value: String);
begin
  FXMLElemName := Value;
end;

function TSGXMLDocument.GetElementCount(Path: String): Integer;
var
  PointIndex : Integer;
  ChildName  : String;
begin
  ChildName := Path;
  PointIndex := Pos('.', ChildName);  //���� �����
  if PointIndex <> 0 then begin
    SetLength(ChildName, PointIndex - 1); //�������� ���
    System.Delete(Path, 1, PointIndex);
  end;
  if ChildName = FXMLElemName then     //���������� � ������ �����
    if PointIndex <> 0 then
      Result := inherited GetElementCount(Path)
    else Result := 1
  else raise Exception.Create(Format(NotExistRootName, ['GetElementCount']));
end;

end.
