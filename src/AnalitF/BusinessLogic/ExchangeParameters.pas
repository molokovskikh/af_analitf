unit ExchangeParameters;

interface

uses
  SysUtils, Classes, Contnrs;

type
  TExchangeParams = (epTerminated, epCriticalError, epErrorMessage,
                     epDownloadChildThreads, epServerAddition, epSendedOrders,
                     epSendedOrdersErrorLog, epSendWaybillsResult,
                     epFullHistoryOrders,
                     epImportDocs,
                     epBeforeDocsCount,
                     epAfterDocsCount);

  TStringValue = class
    Value : String;
    constructor Create(AValue : String);
  end;


  TBooleanValue = class
    Value : Boolean;
    constructor Create(AValue : Boolean);
  end;

  TIntegerValue = class
    Value : Integer;
    constructor Create(AValue : Integer);
  end;

  TExchangeParamsHelper = class
   public
    class procedure InitExchangeParams(Params : TObjectList);
  end;

var
  GlobalExchangeParams : TObjectList;

implementation

uses
  PostWaybillsController;

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
  //epSendWaybillsResult
  Params.Add(TIntegerValue.Create(Integer(swsNotFiles)));
  //epFullHistoryOrders
  Params.Add(TBooleanValue.Create(False));
  //epImportDocs
  Params.Add(TBooleanValue.Create(False));
  //epBeforeDocsCount
  Params.Add(TIntegerValue.Create(0));
  //epAfterDocsCount
  Params.Add(TIntegerValue.Create(0));
end;

{ TIntegerValue }

constructor TIntegerValue.Create(AValue: Integer);
begin
  Value := AValue;
end;

initialization
  GlobalExchangeParams := nil;
end.
