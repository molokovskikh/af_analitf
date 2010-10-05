unit LU_TimeUtils;

interface

uses
  SysUtils;

const
 TZSwitchMonthW = 10;    //def 10 test 9
 TZSwitchMonthS = 3;     //def 3  test 3
 TZSwitchDay    = 1;     //def 1  test 4

//Выдает интервал в минутах, который нужно добавить к системному времени,
//чтобы получить локальное время
function        GetTimeBias : LongInt;

//Получить часовой пояс для зимнего времени
function        GetStandartBias : LongInt;

//Получить часовой пояс для летнего времени
function        GetDaylightBias : LongInt;

//Обновляет внутренюю переменную модуля FLocalBias
procedure       UpdateTimeBias;

//Выдает время текущее время GMT в формате Delphi
function        NowGMT : TDateTime;

//Установить локальный БИАС вручную
procedure       SetTimeBias(ABias : LongInt);

//Возвращает код текущей временной зоны. Зима 'W', лето 'S'
function GetTZ : char;

// Возвращает код временной зоны для указанной даты
function getDateTZ ( ADate : TDateTime ) : char;

function IsTZSwitchDay ( ADate : TDateTime ) : boolean;

function NearestTZSwitchDay ( ADate : TDateTime ) : TDateTime;

function getHour ( ADate : TDateTime ) : word;

//Получить из локального времени дни перевода времени на зимнее и летнее время
procedure GetS_DDates(LT : TDateTime; var SDate, DDate : TDateTime);

//Получить "правильную" текущую временную зону
function GetRightTZ : Char;

//Получить "правильную" временную зону для указанной даты
function GetRightDateTZ(Date : TDateTime) : Char;

//Является ли переданная дата днем перевода времени?
function IsRightTZSwitchDay(Date : TDateTime) : Boolean;

//Переводит локальное время в GMT
function LocalTimeToGMT(LT : TDateTime) : TDateTime;

//Переводит локальное время в GMT с указанием временной зонны локального времени
function LocalTimeToGMTByTZ(LT : TDateTime; TZ : Char) : TDateTime;

//Из GMT получаем локальное время
procedure GMTToLocalTime(GMT : TDateTime; var LT : TDateTime; var TZ : Char);

//Из GMT получаем локальное время в строку
function GMTToLocalTimeStr(GMT : TDateTime) : String;


//Выровнять время по AInt(секунды) вниз
//Обнуляет милисекунды
function AdjustedDTDown ( ADT : TDateTime; AInt : Word ) : TDateTime;
//Выровнять время по AInt(секунды) вверх
//Обнуляет милисекунды
function AdjustedDTUp ( ADT : TDateTime; AInt : Word ) : TDateTime;

implementation

uses
  DateUtil,
  Windows;

var
  FLastTimeZoneID : DWORD;
  FLastTZI : TTimeZoneInformation;
  FStandartBias,
  FDayligntBias,
  FLocalBias : LongInt;

function NearestTZSwitchDay ( ADate : TDateTime ) : TDateTime;
begin
 while not IsTZSwitchDay ( ADate ) do
  ADate := ADate - 1;
 Result := ADate;
end;

function IsTZSwitchDay ( ADate : TDateTime ) : boolean;
var
 m : word;
begin
 Result := False;
 m := ExtractMonth ( ADate );
 if ( m <> TZSwitchMonthS ) and ( m <> TZSwitchMonthW ) then
  exit;
 if DayOfWeek ( ADate ) <> TZSwitchDay then
  exit;
 if ExtractMonth ( IncDay ( ADate , 7 ) ) =
    ExtractMonth ( ADate ) + 1 then
  begin
   Result := True;
   exit;
  end;
end;

function getHour ( ADate : TDateTime ) : word;
var
 h , m , s , ms : word;
begin
 DecodeTime ( ADate , h , m , s, ms );
 Result := h;
end;

function getDateTZ ( ADate : TDateTime ) : char;
begin
 if not IsTZSwitchDay ( ADate ) then
  begin
   if ExtractMonth ( NearestTZSwitchDay ( ADate ) ) = TZSwitchMonthS
        then Result := 'S'
        else Result := 'W';
   exit;
  end;
 if  ( ( ExtractMonth ( ADate ) = TZSwitchMonthS  ) and ( getHour ( ADate ) < 2 ) ) or
     ( ( ExtractMonth ( ADate ) = TZSwitchMonthW ) and ( getHour ( ADate ) >= 2 ) ) then
   Result := 'W'
  else
   Result := 'S';
end;


function GetTimeBias : LongInt;
begin
  Result := FLocalBias;
end;

function GetStandartBias : LongInt;
begin
  Result := FStandartBias;
end;

function GetDaylightBias : LongInt;
begin
  Result := FDayligntBias;
end;

procedure UpdateTimeBias;
begin
  try
    FLastTimeZoneID := GetTimeZoneInformation ( FLastTZI );
    if FLastTimeZoneID = TIME_ZONE_ID_STANDARD then
      FLocalBias := FLastTZI.Bias + FLastTZI.StandardBias
    else
      if FLastTimeZoneID = TIME_ZONE_ID_DAYLIGHT then
        FLocalBias := FLastTZI.Bias + FLastTZI.DaylightBias
      else
        FLocalBias := FLastTZI.Bias;
    FStandartBias := FLastTZI.Bias + FLastTZI.StandardBias;
    FDayligntBias := FLastTZI.Bias + FLastTZI.DaylightBias;
  except
    raise Exception.Create(SysErrorMessage(GetLastError));
  end
end;

function NowGMT : TDateTime;
var
  SystemTime: TSystemTime;
begin
  GetSystemTime(SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

procedure SetTimeBias(ABias : LongInt);
begin
  FLocalBias := ABias;
end;

function GetTZ : char;
begin
 Result := GetDateTZ ( Now );
end;

function LocalTimeToGMTByTZ(LT : TDateTime; TZ : Char) : TDateTime;
begin
  if TZ = 'W' then
    Result := LT + FStandartBias/(24*60)
  else
    Result := LT + FDayligntBias/(24*60);
end;

function GetRightTZ : Char;
begin
  if FLastTimeZoneID = TIME_ZONE_ID_DAYLIGHT then
    Result := 'S'
  else
    Result := 'W';
end;

//переводит системное время в формате Day-in-month в обычное время
//Надо указать год
function GetRightDateTime(NST : TSystemTime; NeedYear : Word) : TDateTime;
var
  St : TSystemTime;
  MyDayOfWeek : Integer;
  Right : Boolean;
begin
  St       := NST;
  //Установили нужный нам день
  St.wYear := NeedYear;
  //Начали с начала месяца
  St.wDay  := 1;
  //Получили день недели первого дня месяца
  MyDayOfWeek := DayOfWeek(SystemTimeToDateTime(St));
//    MyDayOfWeek := MyDayOfWeek + ((NST.wDayOfWeek + 1) - MyDayOfWeek);
  //Почему здесь происходит NST.wDayOfWeek+1?
  //Потому, что  DayOfWeek возвращает от 1 до 7,
  // а NST.wDayOfWeek может принимать значения от 0 до 6
  if MyDayOfWeek <= NST.wDayOfWeek+1 then
    St.wDay  := St.wDay + (NST.wDayOfWeek+1  - MyDayOfWeek)
  else
    St.wDay  := St.wDay + (7  - MyDayOfWeek) + NST.wDayOfWeek+1;

  //Перешли на то день недели по счету, который нужен
  St.wDay := St.wDay + 7*(NST.wDay-1);

  //Если нам сказали использовать последний, то ищем последний день недели
  if NST.wDay = 5 then
    repeat
      try
//        Result :=
// Не сохраняю результат работы функции, чтобы не было warning'ов
// Здесь важно то, чтобы не было ошибок при конвертации
        SystemTimeToDateTime(ST);
        Right  := True;
      except
        Right := False;
        St.wDay := St.wDay - 7;
      end;
    until Right;

  //Получаем результат
  Result := SystemTimeToDateTime(ST);
end;

//Получить из локального времени дни перевода времени на зимнее и летнее время
procedure GetS_DDates(LT : TDateTime; var SDate, DDate : TDateTime);
var
  //Год локального времени
  LTYear : Word;
begin
  LTYear := ExtractYear(LT);
  SDate := GetRightDateTime(FLastTZI.StandardDate, LTYear);
  DDate := GetRightDateTime(FLastTZI.DaylightDate, LTYear);
end;

function GetRightDateTZ(Date : TDateTime) : Char;
var
  //Дата перехода на зимнее время
  SDate,
  //Дата перехода на летнее время
  DDate : TDateTime;
begin
  GetS_DDates(Date, SDate, DDate);
  if (Int(SDate)+2/24 <= Date) or (Date < Int(DDate)+2/24) then
    Result := 'W'
  else
    Result := 'S';
end;

function IsRightTZSwitchDay(Date : TDateTime) : Boolean;
var
  //Дата перехода на зимнее время
  SDate,
  //Дата перехода на летнее время
  DDate : TDateTime;
begin
  GetS_DDates(Date, SDate, DDate);
  Result := (Trunc(SDate) = Trunc(Date)) or (Trunc(DDate) = Trunc(Date));
end;

function LocalTimeToGMT(LT : TDateTime) : TDateTime;
begin
  Result := LocalTimeToGMTByTZ(LT, GetRightDateTZ(LT));
end;

{
---------------------------------------------------------------------------
   0   1    2    3                          0    1    2    3
            SD                                        DD

}
procedure GMTToLocalTime(GMT : TDateTime; var LT : TDateTime; var TZ : Char);
var
  TmpLT,
  //Дата перехода на зимнее время
  SDate,
  //Дата перехода на летнее время
  DDate : TDateTime;
begin
  TmpLT := GMT - FStandartBias/(24*60);
  GetS_DDates(TmpLT, SDate, DDate);
  if (Int(SDate)+2/24 <= TmpLT) or (TmpLT < Int(DDate)+2/24) then begin
    TZ := 'W';
    LT := TmpLT;
  end
  else begin
    TZ := 'S';
    LT := GMT - FDayligntBias/(24*60);
  end;
end;

function GMTToLocalTimeStr(GMT : TDateTime) : String;
var
  LT : TDateTime;
  TZ : Char;
begin
  GMTToLocalTime(GMT, LT, TZ);
  Result := FormatDateTime('yyyy"."mm"."dd hh"."nn"."ss"`"', LT) + TZ;
end;

function AdjustedDTDown ( ADT : TDateTime; AInt : Word ) : TDateTime;
var
  ST : TSystemTime;
  SecCount : Word;
begin
  DateTimeToSystemTime(ADT, ST);
  ST.wMilliseconds := 0;
  if (AInt > 0) and (AInt <= 60*60) then begin
    SecCount := ST.wSecond + ST.wMinute*60;
//    ST.wMinute := ( ST.wMinute div AInt ) * AInt;
    ST.wMinute := 0;
    ST.wSecond := 0;
    Result := SystemTimeToDateTime(ST);
    Result := Result + ((SecCount div AInt) * AInt)/SecsPerDay;
  end
  else
    Result := SystemTimeToDateTime(ST);
end;

function AdjustedDTUp ( ADT : TDateTime; AInt : Word ) : TDateTime;
var
  ST : TSystemTime;
  SecCount : Word;
begin
  DateTimeToSystemTime(ADT, ST);
  ST.wMilliseconds := 0;
  if (AInt > 0) and (AInt <= 60*60) then begin
    SecCount := ST.wSecond + ST.wMinute*60;
//    ST.wMinute := ( ST.wMinute div AInt ) * AInt;
    ST.wMinute := 0;
    ST.wSecond := 0;
    Result := SystemTimeToDateTime(ST);
    Result := Result + ((SecCount div AInt) * AInt)/SecsPerDay;
    if SecCount mod AInt > 0 then
//    if ADT - Result > 1/SecsPerDay then
      Result := Result + AInt/SecsPerDay;
  end
  else
    Result := SystemTimeToDateTime(ST);
end;

initialization
  try
    UpdateTimeBias;
  except
  end;
end.
