unit FileCountHelper;

interface

uses
  SysUtils,
  Classes,
  AProc,
  U_ExchangeLog;

type
  TFileCountThread = class(TThread)
   private
    FFileCount : Int64;
   protected
    procedure Execute; override;
   public
    constructor Create();
  end;

implementation

{ TFileCountThread }

constructor TFileCountThread.Create;
begin
  FFileCount := 0;

  inherited Create(False);

  FreeOnTerminate := True;
end;

procedure TFileCountThread.Execute;
var
  allCount : Int64;
  starStr : String;
begin
  try
    FFileCount := GetDirectoryFileCount(RootFolder() + SDirWaybills);
    allCount := FFileCount div 10;
    starStr := '';
    if (allCount > 0) and (allCount < 10) then
      starStr := StringOfChar('*', allCount)
    else
      if allCount >= 10 then
        starStr := StringOfChar('*', 10);

    WriteExchangeLog('AnalitF', Format('Количество накладных %s %d', [starStr, FFileCount]));
  except
    on E : Exception do
      WriteExchangeLog('TFileCountThread.Execute', E.Message);
  end;
end;

end.
