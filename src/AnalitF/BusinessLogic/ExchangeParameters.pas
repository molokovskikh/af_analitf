unit ExchangeParameters;

interface

uses
  SysUtils, Classes, Contnrs,
  SendWaybillTypes;

type
  TExchangeParams = class
   public
    Terminated : Boolean;
    CriticalError : Boolean;
    ErrorMessage : String;
    DownloadChildThreads : Boolean;
    ServerAddition : String;
    SendedOrders : TStringList;
    SendedOrdersErrorLog : TStringList;
    SendWaybillsResult : TSendWaybillsStatus;
    FullHistoryOrders : Boolean;
    ImportDocs : Boolean;
    BeforeDocsCount : Integer;
    AfterDocsCount : Integer;

    constructor Create();
    destructor Destroy; override;
  end;

implementation

{ TExchangeParams }

constructor TExchangeParams.Create;
begin
  Terminated := False;
  CriticalError := False;
  ErrorMessage := '';
  DownloadChildThreads := False;
  ServerAddition := '';
  SendedOrders := TStringList.Create();
  SendedOrdersErrorLog := TStringList.Create();
  SendWaybillsResult := swsNotFiles;
  FullHistoryOrders := False;
  ImportDocs := False;
  BeforeDocsCount := 0;
  AfterDocsCount := 0;
end;

destructor TExchangeParams.Destroy;
begin
  SendedOrders.Free;
  SendedOrdersErrorLog.Free;
  inherited;
end;

end.
