unit LU_TimeUtils;

interface

uses
  SysUtils;

const
 TZSwitchMonthW = 10;    //def 10 test 9
 TZSwitchMonthS = 3;     //def 3  test 3
 TZSwitchDay    = 1;     //def 1  test 4

//������ �������� � �������, ������� ����� �������� � ���������� �������,
//����� �������� ��������� �����
function        GetTimeBias : LongInt;

//�������� ������� ���� ��� ������� �������
function        GetStandartBias : LongInt;

//�������� ������� ���� ��� ������� �������
function        GetDaylightBias : LongInt;

//��������� ��������� ���������� ������ FLocalBias
procedure       UpdateTimeBias;

//������ ����� ������� ����� GMT � ������� Delphi
function        NowGMT : TDateTime;

//���������� ��������� ���� �������
procedure       SetTimeBias(ABias : LongInt);

//���������� ��� ������� ��������� ����. ���� 'W', ���� 'S'
function GetTZ : char;

// ���������� ��� ��������� ���� ��� ��������� ����
function getDateTZ ( ADate : TDateTime ) : char;

function IsTZSwitchDay ( ADate : TDateTime ) : boolean;

function NearestTZSwitchDay ( ADate : TDateTime ) : TDateTime;

function getHour ( ADate : TDateTime ) : word;

//�������� �� ���������� ������� ��� �������� ������� �� ������ � ������ �����
procedure GetS_DDates(LT : TDateTime; var SDate, DDate : TDateTime);

//�������� "����������" ������� ��������� ����
function GetRightTZ : Char;

//�������� "����������" ��������� ���� ��� ��������� ����
function GetRightDateTZ(Date : TDateTime) : Char;

//�������� �� ���������� ���� ���� �������� �������?
function IsRightTZSwitchDay(Date : TDateTime) : Boolean;

//��������� ��������� ����� � GMT
function LocalTimeToGMT(LT : TDateTime) : TDateTime;

//��������� ��������� ����� � GMT � ��������� ��������� ����� ���������� �������
function LocalTimeToGMTByTZ(LT : TDateTime; TZ : Char) : TDateTime;

//�� GMT �������� ��������� �����
procedure GMTToLocalTime(GMT : TDateTime; var LT : TDateTime; var TZ : Char);

//�� GMT �������� ��������� ����� � ������
function GMTToLocalTimeStr(GMT : TDateTime) : String;


//��������� ����� �� AInt(�������) ����
//�������� �����������
function AdjustedDTDown ( ADT : TDateTime; AInt : Word ) : TDateTime;
//��������� ����� �� AInt(�������) �����
//�������� �����������
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

//��������� ��������� ����� � ������� Day-in-month � ������� �����
//���� ������� ���
function GetRightDateTime(NST : TSystemTime; NeedYear : Word) : TDateTime;
var
  St : TSystemTime;
  MyDayOfWeek : Integer;
  Right : Boolean;
begin
  St       := NST;
  //���������� ������ ��� ����
  St.wYear := NeedYear;
  //������ � ������ ������
  St.wDay  := 1;
  //�������� ���� ������ ������� ��� ������
  MyDayOfWeek := DayOfWeek(SystemTimeToDateTime(St));
//    MyDayOfWeek := MyDayOfWeek + ((NST.wDayOfWeek + 1) - MyDayOfWeek);
  //������ ����� ���������� NST.wDayOfWeek+1?
  //������, ���  DayOfWeek ���������� �� 1 �� 7,
  // � NST.wDayOfWeek ����� ��������� �������� �� 0 �� 6
  if MyDayOfWeek <= NST.wDayOfWeek+1 then
    St.wDay  := St.wDay + (NST.wDayOfWeek+1  - MyDayOfWeek)
  else
    St.wDay  := St.wDay + (7  - MyDayOfWeek) + NST.wDayOfWeek+1;

  //������� �� �� ���� ������ �� �����, ������� �����
  St.wDay := St.wDay + 7*(NST.wDay-1);

  //���� ��� ������� ������������ ���������, �� ���� ��������� ���� ������
  if NST.wDay = 5 then
    repeat
      try
//        Result :=
// �� �������� ��������� ������ �������, ����� �� ���� warning'��
// ����� ����� ��, ����� �� ���� ������ ��� �����������
        SystemTimeToDateTime(ST);
        Right  := True;
      except
        Right := False;
        St.wDay := St.wDay - 7;
      end;
    until Right;

  //�������� ���������
  Result := SystemTimeToDateTime(ST);
end;

//�������� �� ���������� ������� ��� �������� ������� �� ������ � ������ �����
procedure GetS_DDates(LT : TDateTime; var SDate, DDate : TDateTime);
var
  //��� ���������� �������
  LTYear : Word;
begin
  LTYear := ExtractYear(LT);
  SDate := GetRightDateTime(FLastTZI.StandardDate, LTYear);
  DDate := GetRightDateTime(FLastTZI.DaylightDate, LTYear);
end;

function GetRightDateTZ(Date : TDateTime) : Char;
var
  //���� �������� �� ������ �����
  SDate,
  //���� �������� �� ������ �����
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
  //���� �������� �� ������ �����
  SDate,
  //���� �������� �� ������ �����
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
  //���� �������� �� ������ �����
  SDate,
  //���� �������� �� ������ �����
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
