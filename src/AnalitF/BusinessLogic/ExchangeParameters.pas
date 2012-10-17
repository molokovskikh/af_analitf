unit ExchangeParameters;

interface

uses
  SysUtils, Classes, Contnrs,
  SendWaybillTypes;

const
  UserAbortMessage = '�������� �������� �������������';
    
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
    NewMailsExists : Boolean;
    RecievedAttachments : TStringList;
    NewRejectsExists : Boolean;
    LastRequestWithRejects : TDateTime;
    AwaitedProductsExists : Boolean;
    GotoAddressIdByRejects : Int64;

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
  NewMailsExists := False;
  RecievedAttachments := TStringList.Create;
  NewRejectsExists := False;
  LastRequestWithRejects := Now();
  AwaitedProductsExists := False;
  GotoAddressIdByRejects := 0;
end;

destructor TExchangeParams.Destroy;
begin
  SendedOrders.Free;
  SendedOrdersErrorLog.Free;
  RecievedAttachments.Free;
  inherited;
end;

end.
