unit ExchangeParameters;

interface

uses
  SysUtils, Classes, Contnrs;

type
  TExchangeParams = (epTerminated, epCriticalError, epErrorMessage,
                     epDownloadChildThreads, epServerAddition, epSendedOrders,
                     epSendedOrdersErrorLog);

  TStringValue = class
    Value : String;
    constructor Create(AValue : String);
  end;

  TBooleanValue = class
    Value : Boolean;
    constructor Create(AValue : Boolean);
  end;

  TExchangeParamsHelper = class
   public
    class procedure InitExchangeParams(Params : TObjectList);
  end;

var
  GlobalExchangeParams : TObjectList;

implementation

{ TStringValue }

constructor TStringValue.Create(AValue: String);
begin
  Value := AValue;
end;

{ TBooleanValue }

constructor TBooleanValue.Create(AValue: Boolean);
begin
  Value := AValue;
end;

{ TExchangeParamsHelper }

class procedure TExchangeParamsHelper.InitExchangeParams(
  Params: TObjectList);
begin
  //epTerminated
  Params.Add(TBooleanValue.Create(False));
  //epCriticalError
  Params.Add(TBooleanValue.Create(False));
  //epErrorMessage
  Params.Add(TStringValue.Create(''));
  //epDownloadChildThreads
  Params.Add(TBooleanValue.Create(False));
  //epServerAddition
  Params.Add(TStringValue.Create(''));
  //epSendedOrders
  Params.Add(TStringList.Create());
  //epSendedOrdersErrorLog
  Params.Add(TStringList.Create());
end;

initialization
  GlobalExchangeParams := nil;
end.
