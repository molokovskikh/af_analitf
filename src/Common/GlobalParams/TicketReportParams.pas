unit TicketReportParams;

interface

uses
  SysUtils,
  Classes,
  MyAccess,
  GlobalParams;

type
  TTicketReportParams = class(TGlobalParams)
   public
    PrintEmptyTickets : Boolean;
    SizePercent : Integer;
    ClientNameVisible : Boolean;
    ProductVisible : Boolean;
    CountryVisible : Boolean;
    ProducerVisible : Boolean;
    PeriodVisible : Boolean;
    ProviderDocumentIdVisible : Boolean;
    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

{ TTicketReportParams }

procedure TTicketReportParams.ReadParams;
begin
  PrintEmptyTickets := GetParam('TicketReportPrintEmptyTickets');
  SizePercent := GetParam('TicketReportSizePercent');
  ClientNameVisible := GetParam('TicketReportClientNameVisible');
  ProductVisible := GetParam('TicketReportProductVisible');
  CountryVisible := GetParam('TicketReportCountryVisible');
  ProducerVisible := GetParam('TicketReportProducerVisible');
  PeriodVisible := GetParam('TicketReportPeriodVisible');
  ProviderDocumentIdVisible := GetParam('TicketReportProviderDocumentIdVisible');
end;

procedure TTicketReportParams.SaveParams;
begin
  SaveParam('TicketReportPrintEmptyTickets', PrintEmptyTickets);
  SaveParam('TicketReportSizePercent', SizePercent);
  SaveParam('TicketReportClientNameVisible', ClientNameVisible);
  SaveParam('TicketReportProductVisible', ProductVisible);
  SaveParam('TicketReportCountryVisible', CountryVisible);
  SaveParam('TicketReportProducerVisible', ProducerVisible);
  SaveParam('TicketReportPeriodVisible', PeriodVisible);
  SaveParam('TicketReportProviderDocumentIdVisible', ProviderDocumentIdVisible);
end;

end.