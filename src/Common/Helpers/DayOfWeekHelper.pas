unit DayOfWeekHelper;

interface

uses
  SysUtils;

type
  TDayOfWeekHelper = class
   protected
    class function GetDayOfWeek(ADayOfWeek : Integer) : String;
    class procedure Initialize();
   public
    class function DayOfWeek() : String;
    class function AnotherDay(ADayOfWeek : String) : Boolean;
  end;

implementation

const
  DayOfWeekNames : array[1..7] of String = (
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday');

var
  FCurrentDayOfWeek : String;

{ TDayOfWeekHelper }

class function TDayOfWeekHelper.AnotherDay(ADayOfWeek: String): Boolean;
begin
  Result := FCurrentDayOfWeek <> ADayOfWeek;
end;

class function TDayOfWeekHelper.DayOfWeek: String;
begin
  Result := FCurrentDayOfWeek;
end;

class function TDayOfWeekHelper.GetDayOfWeek(ADayOfWeek : Integer): String;
begin
  if (ADayOfWeek < 1) or (ADayOfWeek > 7) then
    raise Exception.CreateFmt('Некорректное значение дня недели: %d', [ADayOfWeek]);
  Result := DayOfWeekNames[ADayOfWeek];
end;

class procedure TDayOfWeekHelper.Initialize;
begin
  FCurrentDayOfWeek := GetDayOfWeek(SysUtils.DayOfWeek(Now));
end;

initialization
  TDayOfWeekHelper.Initialize();
end.
