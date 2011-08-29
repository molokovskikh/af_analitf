unit TimeZoneTests;

interface

uses
  SysUtils,
  Windows,
  TestFrameWork,
  AProc,
  U_ExchangeLog;

type
  TTestTimeZone = class(TTestCase)
   published
    procedure GetTimeZone;
    procedure GetTimeZoneWithFunction;
  end;

implementation

{ TTestTimeZone }

procedure TTestTimeZone.GetTimeZone;
var
  timeZone : DWORD;
  tzi : TTimeZoneInformation;
begin
  timeZone := GetTimeZoneInformation(tzi);
  CheckNotEquals(Integer(TIME_ZONE_ID_INVALID), Integer(timeZone), 'Вернулся некорректный часовой пояс');
  //timeZone := TIME_ZONE_ID_UNKNOWN;
  case timeZone of
    TIME_ZONE_ID_UNKNOWN : WriteExchangeLog('TTestTimeZone.GetTimeZone', 'TimeZone = TIME_ZONE_ID_UNKNOWN');
    TIME_ZONE_ID_STANDARD : WriteExchangeLog('TTestTimeZone.GetTimeZone', 'TimeZone = TIME_ZONE_ID_STANDARD');
    TIME_ZONE_ID_DAYLIGHT : WriteExchangeLog('TTestTimeZone.GetTimeZone', 'TimeZone = TIME_ZONE_ID_DAYLIGHT');
    else
      WriteExchangeLog('TTestTimeZone.GetTimeZone', 'TimeZone = ' + IntToStr(timeZone));
  end;

  WriteExchangeLog('TTestTimeZone.GetTimeZone', 'TimeZoneInformation = ' +
    Format('Bias: %d  StandardName: %s  StandardDate: (%d, %d)  StandardBias: %d  DaylightName: %s  DaylightDate: (%d, %d)  DaylightBias: %d',
      [tzi.Bias,
      tzi.StandardName,
      tzi.StandardDate.wMonth, tzi.StandardDate.wDay,
      //DateTimeToStr(SystemTimeToDateTime(tzi.StandardDate)),
      tzi.StandardBias,
      tzi.DaylightName,
      tzi.DaylightDate.wMonth, tzi.DaylightDate.wDay,
      //DateTimeToStr(SystemTimeToDateTime(tzi.DaylightDate)),
      tzi.DaylightBias]));
end;

procedure TTestTimeZone.GetTimeZoneWithFunction;
var
  bias : Integer;
begin
  bias := AProc.GetTimeZoneBias();
  CheckNotEquals(0, bias, 'В текущем часовом поясе смещение = 0');
end;

initialization
  TestFramework.RegisterTest(TTestTimeZone.Suite);
end.
