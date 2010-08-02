unit StartupHelper;

interface

uses
  SysUtils,
  Classes,
  Windows,
  DateUtils,
  U_ExchangeLog;
  
type
  TStartupHelper = class
   private
    startTime : TDateTime;
    log : TStringList;
   public
    constructor Create();
    procedure Stop;
    procedure Write(ASubSystem, AMessage: string);
  end;

var
  mainStartupHelper : TStartupHelper;

implementation

{ TStartupHelper }

constructor TStartupHelper.Create;
begin
  log := TStringList.Create;
  startTime := Now;
end;

procedure TStartupHelper.Stop;
var
  stopTime : TDateTime;
  minutesDiff : Int64;
begin
  stopTime := Now();
  minutesDiff := MinutesBetween(stopTime, startTime);
  if (minutesDiff >= 2) then
    WriteExchangeLog(
      'StartupHelper',
      'Запуск программы продолжался (мин):' + IntToStr(minutesDiff) + #13#10
       + log.Text);

  log.Clear;  
end;

procedure TStartupHelper.Write(ASubSystem, AMessage: string);
var
 s  : string;
begin
  try
    s := #9 + FormatDateTime ( 'yyyy.mm.dd hh.nn.ss.zzz' , Now ) + #9 +
        ASubSystem + #9 + AMessage;
    log.Add(s);
  except
    on E : Exception do
      WriteExchangeLog('StartupHelper.Write', 'Error' + E.Message);
  end;
end;

initialization
  mainStartupHelper := TStartupHelper.Create();
end.
