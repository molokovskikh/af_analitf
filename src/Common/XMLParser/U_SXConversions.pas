unit U_SXConversions;

{ Префикс SX означает Sterling XML.
Модуль содержит функции перевода основных типов из строки символов и обратно.
При преобразовании времени и даты в строку используются шаблоны. 
}
interface

uses
  SysUtils, Controls, Math, U_SGXMLGeneral;

{Формат времени : "hh.nn.ss" }
{                  12345678  }
{Формат даты и времени : "yyyy.mm.dd hh.nn.ss" }
{                         1234567890123456789}
{Формат даты : "yyyy.mm.dd" }
{               12345678910}
{Формат вещ. числа:
  N = '0'..'9'
  Float = N (N)* ['.' N*] [('e'|'E') ['+'|'-'] N*]
}
{Формат ISO-8601:
   yyyy-mm-ddThh:nn:ss[.zzz](Z | (('+' | '-')hh:nn))
   12345678901234567890123456
Пример:
2003-03-11T16:26:00.012+03:00
2003-03-11T16:26:01+03:00
2003-03-11T16:26:05
}
const
  SXDecimalSeparator     = '.'; //Десятичный разделитель
  SXDateSeparator        = '.'; //Разделитель, используемый в дате
  SXTimeSeparator        = '.'; //Разделитель, используемый во времени
  SXISODateSeparator     = '-'; //Разделитель, используемый в дате ISO-8601
  SXISOTimeSeparator     = ':'; //Разделитель, используемый во времени ISO-8601
  SXDateTemplate         = 'yyyy"'+SXDateSeparator+'"mm"'+SXDateSeparator+'"dd';
  SXTimeTemplate         = 'hh"'+SXTimeSeparator+'"nn"'+SXTimeSeparator+'"ss';
  SXDateTimeTemplate     = SXDateTemplate + ' ' + SXTimeTemplate;
  SXISODateTimeTemplate  = 'yyyy"' + SXISODateSeparator + '"mm"' +
                           SXISODateSeparator + '"dd"T"hh"' + SXISOTimeSeparator
                           + '"nn"' + SXISOTimeSeparator + '"ss"."zzz"Z"';
  SXDTmlLen              = Length(SXDateTemplate) - 4;
  SXTTmlLen              = Length(SXTimeTemplate) - 4;
  SXDTTmlLen             = SXDTmlLen + SXTTmlLen + 1;
  SXFloatTemplate        = '%e';
  SXFloatXMLTemplate     = '%.20g';
  //Шаблон для функции DateTimeDiff
  SXDateTimeDiffTemplate = '%d Hours %d Minute %d Secs %d MSecs';
  HeaderMsg              = 'U_SXConversions:%s - String "%s" not converted in %s.';

  function      SXStringToString  (S : String) : String;

  function      SXStringToBoolean  (S : String) : Boolean;
  function      SXStringToInteger  (S : String) : Int64;
  function      SXStringToFloat    (S : String) : Extended;
  function      SXStringToDate     (S : String) : TDate;
  function      SXStringToTime     (S : String) : TTime;
  function      SXStringToDateTime (S : String) : TDateTime;
  function      SXISO8601ToDateTime(S : String) : TDateTime;

  function      SXBooleanToString  (B  : Boolean)   : String;
  function      SXIntegerToString  (I  : Int64)   : String;
  function      SXFloatToString    (E  : Extended)  : String;
  function      SXDateToString     (D  : TDate)     : String;
  function      SXTimeToString     (T  : TTime)     : String;
  function      SXDateTimeToString (DT : TDateTime) : String;
  //Время должно передаваться в GMT
  function      SXDateTimeToISO8601(DT : TDateTime) : String;
  function      SXFloatToXML       (E  : Extended)  : String;

  //Заменяет недопустимые символы на макросы
  function      SXReplaceXML      (s  : string)    : string;
  //Заменяет макросы на недопустимые символы  
  function      SXReplaceText(s: string): string;

  //Процедура считает разницу между двумя датами
  procedure DateTimeDiff(MinDate, MaxDate : TDateTime;
    var Hours, Minute, Secs, MSecs : Word);

  function DateTimeDiffToString(MinDate, MaxDate : TDateTime) : String;

implementation

function      SXStringToString  (S : String) : String;
begin
  Result := S;
end;

function      SXStringToBoolean (S : String) : Boolean;
begin
  S := Trim(S);
  if UpperCase(S) = 'TRUE' then
    Result := True
  else
    if UpperCase(S) = 'FALSE' then
      Result := False
    else raise Exception.CreateFmt(HeaderMsg, ['SXStringToBoolean', S, 'Boolean']);
end;

function      SXStringToInteger (S : String) : Int64;
begin
  try
    Result := StrToInt(S);
  except
    raise Exception.CreateFmt(HeaderMsg, ['SXStringToInteger', S, 'Integer']);
  end
end;

function      SXStringToFloat   (S : String) : Extended;
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
      raise Exception.CreateFmt(HeaderMsg, ['SXStringToFloat', S, 'Float']);
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
        else raise Exception.CreateFmt(HeaderMsg, ['SXStringToFloat', S, 'Float']);
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
        SXDecimalSeparator : AnalizeDecimal;
        'e','E'            : AnalizeDegree;
        else raise Exception.CreateFmt(HeaderMsg, ['SXStringToFloat', S, 'Float']);
      end;
  end;

begin
  SourceStr := Trim(S);
  Minus := (SourceStr[1] = '-');
  CurrChar := 1;
  if Minus then CurrChar := 2; //Если отрицательное
  Result := 0;
  if (CurrChar <= Length(SourceStr)) then
    case SourceStr[CurrChar] of
      '0'..'9' : AnalizeLong;
      else raise Exception.CreateFmt(HeaderMsg, ['SXStringToFloat', S, 'Float']);
    end
  else raise Exception.CreateFmt(HeaderMsg, ['SXStringToFloat', S, 'Float']);
  if Minus then Result := -Result;
end;

function      SXStringToDate    (S : String) : TDate;
begin
  S := Trim(S);
  try
    if Length(S) <> SXDTmlLen then
      raise Exception.Create('')
    else
      if (S[5] = SXDateSeparator) and (S[8] = SXDateSeparator) then
        Result := EncodeDate(
                    StrToInt(Copy(S, 1, 4)),
                    StrToInt(Copy(S, 6, 2)),
                    StrToInt(Copy(S, 9, 2)))
      else
        raise Exception.Create('');
  except
    raise Exception.CreateFmt(HeaderMsg, ['SXStringToDate', S, 'Date'])
  end;
end;

function      SXStringToTime    (S : String) : TTime;
begin
  S := Trim(S);
  try
    if Length(S) <> SXTTmlLen then
      raise Exception.Create('')
    else
      if (S[3] = SXTimeSeparator) and (S[6] = SXTimeSeparator) then
        Result := EncodeTime(
                    StrToInt(Copy(S, 1, 2)),
                    StrToInt(Copy(S, 4, 2)),
                    StrToInt(Copy(S, 7, 2)), 0)
      else
        raise Exception.Create('');
  except
    raise Exception.CreateFmt(HeaderMsg, ['SXStringToTime', S, 'Time']);
  end;
end;

function      SXStringToDateTime(S : String) : TDateTime;
begin
  S := Trim(S);
  try
    if Length(S) <> SXDTTmlLen then
      raise Exception.Create('')
    else
      if (S[5] = SXDateSeparator) and (S[8] = SXDateSeparator) and
         (S[14] = SXTimeSeparator) and (S[17] = SXTimeSeparator) then
      begin
        Result := EncodeDate(
                    StrToInt(Copy(S, 1, 4)),
                    StrToInt(Copy(S, 6, 2)),
                    StrToInt(Copy(S, 9, 2)));
        if Result >= 0 then
          Result := Result + EncodeTime(
                               StrToInt(Copy(S, 12, 2)),
                               StrToInt(Copy(S, 15, 2)),
                               StrToInt(Copy(S, 18, 2)), 0)
        else Result := Result - EncodeTime(
                                  StrToInt(Copy(S, 12, 2)),
                                  StrToInt(Copy(S, 15, 2)),
                                  StrToInt(Copy(S, 18, 2)), 0);
      end
      else
        raise Exception.Create('');
  except
    raise Exception.CreateFmt(HeaderMsg, ['SXStringToDateTime', S, 'DateTime'])
  end;
end;

function      SXISO8601ToDateTime(S : String) : TDateTime;
var
  TimeZoneStr,
  Value       : String;
  Milli       : Integer;
  UseMilli    : Boolean;
begin
  UseMilli := False;
  TimeZoneStr := '';
  try
    Value := S;
    if (Length(Value) >= 19)
      and
       ([Value[1], Value[2], Value[3], Value[4],
         Value[6], Value[7],     Value[9], Value[10],
         Value[12], Value[13],   Value[15], Value[16],
         Value[18], Value[19]] <= ['0'..'9']) and
       ([Value[5], Value[8]] = ['-']) and
       ([Value[14], Value[17]] = [':']) and
       (Value[11] = 'T')
    then begin
      //декодируем дату
      try
        Result := EncodeDate(
                StrToInt( Copy(Value, 1, 4) ),
                StrToInt( Copy(Value, 6, 2) ),
                StrToInt( Copy(Value, 9, 2) ));
      except
        raise Exception.CreateFmt(
          'Неправильный формат даты "%s" элемента TimeStamp',
          [Value]);
      end;

      //декодируем милисекунды
      if Length(Value) >= 23 then
        if (Value[20] = '.')
          and
          ([Value[21], Value[22], Value[23]] <= ['0'..'9'])
        then begin
          Milli := StrToInt( Copy(Value, 21, 3) );
          if (Milli < 0) or (Milli > 999) then
            raise Exception.CreateFmt(
              'Значение атрибута Milli "%d" должно принадлежать отрезку [0, 999]',
              [Milli]);
          UseMilli := True;
        end
        else
          Milli := 0
      else
        Milli := 0;

      //декодируем время  
      try
        Result := Result + EncodeTime(
                StrToInt( Copy(Value, 12, 2) ),
                StrToInt( Copy(Value, 15, 2) ),
                StrToInt( Copy(Value, 18, 2) ),
                Milli);
      except
        raise Exception.CreateFmt(
          'Неправильный формат времени "%s" элемента TimeStamp',
          [Value]);
      end;

      //вырезаем временную зону из исходной строки
{
      if not UseMilli and (Length(Value) = 25) then
        TimeZoneStr := Copy(Value, 20, 6)
      else
        if UseMilli and (Length(Value) = 29) then
          TimeZoneStr := Copy(Value, 24, 6);
}

      if not UseMilli then
        TimeZoneStr := Copy(Value, 20, Length(Value))
      else
        TimeZoneStr := Copy(Value, 24, Length(Value));

      //декодируем временную зону
      if (Length(TimeZoneStr) = 1) and (TimeZoneStr = 'Z') then
         //Ничего не делаем - все уже применено
      else
        if (Length(TimeZoneStr) = 6) then
          if ([TimeZoneStr[2], TimeZoneStr[3], TimeZoneStr[5],
                  TimeZoneStr[6]] <= ['0'..'9'])
            and (TimeZoneStr[4] = ':') and (TimeZoneStr[1] in ['-', '+'])
          then
            if TimeZoneStr[1] = '+' then
              try
                Result := Result - EncodeTime(
                        StrToInt( Copy(TimeZoneStr, 2, 2) ),
                        StrToInt( Copy(TimeZoneStr, 5, 2) ),
                        0, 0);
              except
                raise Exception.CreateFmt(
                  'Неправильный формат временой зоны "%s" элемента TimeStamp',
                  [Value]);
              end
            else
              try
                Result := Result + EncodeTime(
                        StrToInt( Copy(TimeZoneStr, 2, 2) ),
                        StrToInt( Copy(TimeZoneStr, 5, 2) ),
                        0, 0);
              except
                raise Exception.CreateFmt(
                  'Неправильный формат временой зоны "%s" элемента TimeStamp',
                  [Value]);
              end
          else
            raise Exception.CreateFmt(
              'Неправильный формат временой зоны "%s" элемента TimeStamp',
              [Value])
        else
          raise Exception.CreateFmt(
            'Неправильный формат временой зоны "%s" элемента TimeStamp',
            [Value]);
    end
    else
      raise Exception.CreateFmt(
        'Неправильный формат даты и времени "%s" элемента TimeStamp',
        [Value]);
  except
    on E : Exception do
      raise Exception.Create(Format(HeaderMsg, ['SXISO8601ToDateTime', S, 'DateTime']) + E.Message)
  end;
end;

function      SXBooleanToString (B  : Boolean)   : String;
begin
  if B then
    Result := 'true'
  else Result := 'false';
end;

function      SXIntegerToString (I  : Int64)   : String;
begin
  Result := IntToStr(I);
end;

function      SXFloatToString   (E  : Extended)  : String;
{
const
  CountAfterSeparator = 5;
}
var
  I
{  ,
  Exponent,
  TruncInt}
   : Integer;
{
  Mantissa : Extended;
  ExpStr : String;
  Minus : Boolean;
}
begin
  Result := Format(SXFloatTemplate, [E]);
  if DecimalSeparator <> SXDecimalSeparator then begin
    I := Pos(DecimalSeparator, Result);
    if I > 0 then Result[i] := SXDecimalSeparator;
  end;
{
  Minus := (E < 0);
  E := ABS(E);
  // Вычленяем из числа мантиссу и экспоненту
  Frexp(E, Mantissa, Exponent);
  TruncInt := ABS(Trunc(Mantissa));
  Mantissa := ABS(Frac(Mantissa));
  Result := '';
  if TruncInt = 0 then
    Result := '0'
  else
    while TruncInt <> 0 do begin
      Result := Chr(Ord('0')+ (TruncInt mod 10)) + Result;
      TruncInt := TruncInt div 10;
    end;
  //Добавляем вперед минус, если число отрицательное
  if Minus then Result := '-' + Result;
  //Добавляем дробный разделитель
  Result := Result + SXDecimalSeparator;
  //Добавляем дробную часть
  for I := 1 to CountAfterSeparator do begin
    Mantissa := Mantissa * 10;
    Result := Result + Chr(Ord('0') + Trunc(Mantissa));
  end;
  //Если степень экспоненты отлична от нуля, то добавляем экспоненту
  if Exponent <> 0 then begin
    Result := Result + 'E';
    if Exponent < 0 then Result := Result + '-';
    Exponent := ABS(Exponent);
    ExpStr := '';
    while Exponent <> 0 do begin
      ExpStr := Chr(Ord('0')+ (Exponent mod 10)) + ExpStr;
      Exponent := Exponent div 10;
    end;
    Result := Result + ExpStr;
  end;
}
end;

function      SXDateToString    (D  : TDate)     : String;
begin
  Result := FormatDateTime(SXDateTemplate, D);
end;

function      SXTimeToString    (T  : TTime)     : String;
begin
  Result := FormatDateTime(SXTimeTemplate, T);
end;

function      SXDateTimeToString(DT : TDateTime) : String;
begin
  Result := FormatDateTime(SXDateTimeTemplate, DT);
end;

function      SXDateTimeToISO8601(DT : TDateTime) : String;
begin
  Result := FormatDateTime(SXISODateTimeTemplate, DT);
end;

function      SXFloatToXML       (E  : Extended)  : String;
var
  I : Integer;
begin
  Result := Format(SXFloatXMLTemplate, [E]);
  if DecimalSeparator <> SXDecimalSeparator then begin
    I := Pos(DecimalSeparator, Result);
    if I > 0 then Result[i] := SXDecimalSeparator;
  end;
end;

function SXReplaceXML(s: string): string;
var
 i : integer;
begin
  Result := s;
  for i := GeneralEntitiesCount-1 downto 0 do
    Result := StringReplace(Result,
                ReplacementText[i], GeneralEntities[i], [rfReplaceAll]);
  for I := 0 to 31 do
    Result := StringReplace(Result, Chr(I), '&#' + IntToStr(I) + ';',
                                [rfReplaceAll]);
end;

function SXReplaceText(s: string): string;
var
 i : integer;
begin
  Result := s;
  for I := 0 to 31 do
    Result := StringReplace(Result, '&#' + IntToStr(I) + ';', Chr(I),
                                [rfReplaceAll]);
  for i := 0 to GeneralEntitiesCount-1 do
    Result := StringReplace(Result,
                GeneralEntities[i], ReplacementText[i], [rfReplaceAll]);
end;

procedure DateTimeDiff(MinDate, MaxDate : TDateTime;
  var Hours, Minute, Secs, MSecs : Word);
var
  SwapDate : TDateTime;
  MaxSecs : Int64;
begin
  if MinDate > MaxDate then begin
    SwapDate := MinDate;
    MinDate := MaxDate;
    MaxDate := SwapDate;
  end;
  MaxSecs := Round((MaxDate - MinDate) * MSecsPerDay);
  MSecs   := MaxSecs mod 1000;
  MaxSecs := MaxSecs div 1000;
  Secs    := MaxSecs mod 60;
  MaxSecs := MaxSecs div 60;
  Minute  := MaxSecs mod 60;
  MaxSecs := MaxSecs div 60;
  Hours   := MaxSecs;
end;

function DateTimeDiffToString(MinDate, MaxDate : TDateTime) : String;
var
  Hours, Minute, Secs, MSecs : Word;
begin
  DateTimeDiff(MinDate, MaxDate, Hours, Minute, Secs, MSecs);
  Result := Format(SXDateTimeDiffTemplate, [Hours, Minute, Secs, MSecs]);
end;

end.
