unit U_ExchangeLog;

interface

uses
  LU_Tracer;

procedure CreateExchangeLog();

procedure WriteExchangeLog(ASubSystem, AMessage : string);

procedure FreeExchangeLog();

var
  ExchangeLog : TTracer = nil;

implementation

uses SysUtils, TypInfo;

procedure CreateExchangeLog();
begin
  ExchangeLog := TTracer.Create(
    IncludeTrailingBackslash(ExtractFileDir(ParamStr(0))) + 'Exchange', 'log', -1);
end;

procedure WriteExchangeLog(ASubSystem, AMessage : string);
begin
  if Assigned(ExchangeLog) then
    ExchangeLog.TR(ASubSystem, AMessage);
end;

procedure FreeExchangeLog();
begin
  FreeAndNil(ExchangeLog);
end;


initialization
  CreateExchangeLog();
finalization
  FreeExchangeLog();
end.
