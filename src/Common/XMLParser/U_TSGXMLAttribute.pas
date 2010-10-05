unit U_TSGXMLAttribute;

interface

uses
  U_SGXMLGeneral, Controls, SysUtils;

const
  NotBoolean = 'U_TSGXMLAttribute:TSGXMLAttribute.AsBoolean - '+
                        'Значение аттрибута не является булевским.';
  NotInteger = 'U_TSGXMLAttribute:TSGXMLAttribute.AsInteger - '+
                        'Значение аттрибута не является значением целого типа.';
  NotDate    = 'U_TSGXMLAttribute:TSGXMLAttribute.AsDate - '+
                        'Значение аттрибута не является датой.';
  NotTime    = 'U_TSGXMLAttribute:TSGXMLAttribute.AsTime - '+
                        'Значение аттрибута не является временем!';
  NotDateTime= 'U_TSGXMLAttribute:TSGXMLAttribute.AsDateTime - '+
                        'Значение аттрибута не является датой и временем!';
  NotFloat   = 'U_TSGXMLAttribute:TSGXMLAttribute.AsFloat - '+
                        'Значение аттрибута не является действительным числом.';

type

  {Структура аттрибута в при разборе XML-документа}
  TSGXMLAttribute = class
   private
    FAttName  : String;
    FAttType  : TEAType;
    FValue    : String;
    procedure SetValue(const Value: String);
   public
    constructor Create(
      AAttName  : String;
      AAttType  : TEAType;
      AValue    : String);
    {Возвращает True, если аттрибут булевского типа}
    function    IsBoolean : Boolean;
    {Возвращает True, если аттрибут является значением целого типа}
    function    IsInteger : Boolean;
    {Возвращает True, если аттрибут является датой}
    function    IsDate    : Boolean;
    {Возвращает True, если аттрибут является TDateTime}
    function    IsDateTime: Boolean;
    {Возвращает True, если аттрибут является временем}
    function    IsTime    : Boolean;
    {Возвращает True, если аттрибут является действительным числом}
    function    IsFloat   : Boolean;
    {Возвращает значение аттрибута, если он является Boolean, иначе Exception}
    function    AsBoolean : Boolean;
    {Возвращает значение аттрибута, если он является Integer, иначе Exception}
    function    AsInteger : Integer;
    {Возвращает значение аттрибута, если он является TDate, иначе Exception}
    function    AsDate    : TDate;
    {Возвращает значение аттрибута, если он является TDateTime, иначе Exception}
    function    AsDateTime : TDateTime;
    {Возвращает значение аттрибута, если он является TTime, иначе Exception}
    function    AsTime    : TTime;
    {Возвращает значение аттрибута, если он является Extended, иначе Exception}
    function    AsFloat   : Extended;
    {Имя аттрибута}
    property    AttName  : String  read FAttName;
    {Тип аттрибута}
    property    AttType  : TEAType read FAttType;
    {Значение аттрибута}
    property    Value    : String  read FValue write SetValue;
  end;

implementation

{ TSGXMLAttribute }

function TSGXMLAttribute.AsBoolean: Boolean;
begin
  if UpperCase(FValue) = 'TRUE' then
    Result := True
  else if UpperCase(FValue) = 'FALSE' then
         Result := False
       else raise Exception.Create(NotBoolean);
end;

function TSGXMLAttribute.AsDate: TDate;
{Формат даты : "yyyy.mm.dd" }
{               12345678910}
begin
  try
    Result := EncodeDate(
                StrToInt(Copy(FValue, 1, 4)),
                StrToInt(Copy(FValue, 6, 2)),
                StrToInt(Copy(FValue, 9, 2)));
  except
    raise Exception.Create(NotDate)
  end;
end;

function TSGXMLAttribute.AsDateTime: TDateTime;
{Формат даты и времени : "yyyy.mm.dd hh.nn.ss" }
{                         1234567890123456789}
begin
  try
    Result := EncodeDate(
                StrToInt(Copy(FValue, 1, 4)),
                StrToInt(Copy(FValue, 6, 2)),
                StrToInt(Copy(FValue, 9, 2)));
    if Result > 0 then
      Result := Result + EncodeTime(
                           StrToInt(Copy(FValue, 12, 2)),
                           StrToInt(Copy(FValue, 15, 2)),
                           StrToInt(Copy(FValue, 18, 2)), 0)
    else Result := Result - EncodeTime(
                              StrToInt(Copy(FValue, 12, 2)),
                              StrToInt(Copy(FValue, 15, 2)),
                              StrToInt(Copy(FValue, 18, 2)), 0);
  except
    raise Exception.Create(NotDateTime);
  end;
end;

function TSGXMLAttribute.AsFloat: Extended;
const
  IncValue = 10;
var
  Minus : Boolean;
  SourceStr : String;
  CurrChar : Integer;

  procedure AnalizeDegree;
  var
    I,
    DegreeVal : Integer;
    TmpStr : String;
  begin
    Inc(CurrChar);
    TmpStr := Copy(SourceStr, CurrChar, Length(SourceStr)-CurrChar+1);
    try
      DegreeVal := StrToInt(TmpStr);
    except
      raise Exception.Create(NotFloat);
    end;
      for I := 1 to Abs(DegreeVal) do
        if DegreeVal > 0 then
          Result := Result*IncValue
        else
          Result := Result/IncValue;
  end;

  procedure AnalizeDecimal;
  var
    DecValue : Integer;
  begin
    Inc(CurrChar);
    DecValue := IncValue;
    while (CurrChar <= Length(SourceStr)) do begin
      if SourceStr[CurrChar] in ['0'..'9'] then begin
        Result := Result + ((Ord(SourceStr[CurrChar]) - Ord('0')))/DecValue;
        DecValue := DecValue * IncValue;
      end
      else Break;
      Inc(CurrChar);
    end;
    if (CurrChar <= Length(SourceStr)) then
      case SourceStr[CurrChar] of
        'e','E'  : AnalizeDegree;
        else raise Exception.Create(NotFloat);
      end;
  end;

  procedure AnalizeLong;
  begin
    while (CurrChar <= Length(SourceStr)) do begin
      if SourceStr[CurrChar] in ['0'..'9'] then begin
        Result := Result*IncValue + Ord(SourceStr[CurrChar]) - Ord('0');
      end
      else Break;
      Inc(CurrChar);
    end;
    if (CurrChar <= Length(SourceStr)) then
      case SourceStr[CurrChar] of
        '.'      : AnalizeDecimal;
        'e','E'  : AnalizeDegree;
        else raise Exception.Create(NotFloat);
      end;
  end;

begin
  SourceStr := Trim(FValue);
  Minus := (SourceStr[1] = '-');
  CurrChar := 1;
  if Minus then CurrChar := 2; //Если отрицательное
  Result := 0;
  if (CurrChar <= Length(SourceStr)) then
    case SourceStr[CurrChar] of
      '0'..'9' : AnalizeLong;
      else raise Exception.Create(NotFloat);
    end
  else raise Exception.Create(NotFloat);
  if Minus then Result := -Result;
end;

function TSGXMLAttribute.AsInteger: Integer;
begin
  try
    Result := StrToInt(FValue);
  except
    raise Exception.Create(NotInteger)
  end
end;

function TSGXMLAttribute.AsTime: TTime;
{Формат времени : "hh.nn.ss" }
{                  12345678  }
begin
  try
    Result := EncodeTime(
                StrToInt(Copy(FValue, 1, 2)),
                StrToInt(Copy(FValue, 4, 2)),
                StrToInt(Copy(FValue, 7, 2)), 0);
  except
    raise Exception.Create(NotTime)
  end;
end;

constructor TSGXMLAttribute.Create(AAttName: String; AAttType: TEAType;
  AValue: String);
begin
  FAttName := AAttName;
  FAttType := AAttType;
  FValue   := AValue;
end;

function TSGXMLAttribute.IsBoolean: Boolean;
begin
  Result := True;
  try
    AsBoolean;
  except
    Result := False;
  end;
end;

function TSGXMLAttribute.IsDate: Boolean;
begin
  Result := True;
  try
    AsDate;
  except
    Result := False;
  end;
end;

function TSGXMLAttribute.IsDateTime: Boolean;
begin
  Result := True;
  try
    AsDateTime;
  except
    Result := False;
  end;
end;

function TSGXMLAttribute.IsFloat: Boolean;
begin
  Result := True;
  try
    AsFloat;
  except
    Result := False;
  end;
end;

function TSGXMLAttribute.IsInteger: Boolean;
begin
  Result := True;
  try
    AsInteger;
  except
    Result := False;
  end;
end;

function TSGXMLAttribute.IsTime: Boolean;
begin
  Result := True;
  try
    AsTime;
  except
    Result := False;
  end;
end;

procedure TSGXMLAttribute.SetValue(const Value: String);
begin
  FValue := Value;
end;

end.
