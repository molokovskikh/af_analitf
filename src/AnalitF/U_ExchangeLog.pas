unit U_ExchangeLog;

interface

uses
  Classes, LU_Tracer;

procedure CreateExchangeLog();

procedure WriteExchangeLog(ASubSystem, AMessage : string);

procedure WriteExchangeLogTID(ASubSystem, AMessage : string);

procedure FreeExchangeLog(LastFileSize : Int64 = 0);

var
  ExchangeLog : TTracer = nil;

implementation

uses SysUtils,
  Windows;

procedure CreateExchangeLog();
begin
  ExchangeLog := TTracer.Create(
    IncludeTrailingBackslash(ExtractFileDir(ParamStr(0))) + 'Exchange', 'log', -1);
end;

procedure InternalWriteExchangeLog(ASubSystem, AMessage : string);
begin
  if Assigned(ExchangeLog) then
    ExchangeLog.TR(ASubSystem, AMessage);
end;

procedure WriteExchangeLog(ASubSystem, AMessage : string);
begin
  WriteExchangeLogTID(ASubSystem, AMessage);
end;

procedure WriteExchangeLogTID(ASubSystem, AMessage : string);
var
  tid : LongWord;
begin
  tid := GetCurrentThreadId();
  InternalWriteExchangeLog(ASubSystem + '.tid=' + IntToStr(tid), AMessage);
end;

procedure FreeExchangeLog(LastFileSize : Int64 = 0);
var
  FS : TFileStream;
  Len : Integer;
  LogStr : String;
begin
  FreeAndNil(ExchangeLog);
  if LastFileSize > 0 then begin
    FS := TFileStream.Create(IncludeTrailingBackslash(ExtractFileDir(ParamStr(0))) + 'Exchange.log', fmOpenReadWrite or fmShareDenyNone);
    try
      if (FS.Size > LastFileSize)
      then begin
        FS.Position := LastFileSize;
        Len := Integer(FS.Size - LastFileSize);
        SetLength(LogStr, Len);
        FS.Read(Pointer(LogStr)^, Len);
        FS.Size := 0;
        FS.Position := 0;
        FS.WriteBuffer(LogStr[1], Length(LogStr));
      end
      else
        Len := 0;
    finally
      FS.Free;
    end;
    if Len = 0 then
      SysUtils.DeleteFile(IncludeTrailingBackslash(ExtractFileDir(ParamStr(0))) + 'Exchange.log');
  end;
end;


initialization
  CreateExchangeLog();
finalization
  FreeExchangeLog();
end.
