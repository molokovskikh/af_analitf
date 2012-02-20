unit TicketReportParams;

interface

uses
  SysUtils,
  Classes,
  MyAccess,
  GlobalParams;

type
  TTicketSize = (tsStandart, tsSmall, tsSmallWithBigCost);

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
    SignatureVisible : Boolean;
    SerialNumberVisible : Boolean;
    DocumentDateVisible : Boolean;
    TicketSize : TTicketSize;

    DeleteUnprintableElemnts : Boolean;
    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

{ TTicketReportParams }

procedure TTicketReportParams.ReadParams;
var
  ticketSizeInt : Integer;
begin
  PrintEmptyTickets := GetParam('TicketReportPrintEmptyTickets');
  SizePercent := GetParam('TicketReportSizePercent');
  ClientNameVisible := GetParam('TicketReportClientNameVisible');
  ProductVisible := GetParam('TicketReportProductVisible');
  CountryVisible := GetParam('TicketReportCountryVisible');
  ProducerVisible := GetParam('TicketReportProducerVisible');
  PeriodVisible := GetParam('TicketReportPeriodVisible');
  ProviderDocumentIdVisible := GetParam('TicketReportProviderDocumentIdVisible');
  SignatureVisible := GetParamDef('TicketReportSignatureVisible', True);
  SerialNumberVisible := GetParamDef('TicketReportSerialNumberVisible', True);
  DocumentDateVisible := GetParamDef('TicketReportDocumentDateVisible', True);
  DeleteUnprintableElemnts := GetParamDef('TicketReportDeleteUnprintableElemnts', False);
  ticketSizeInt := GetParamDef('TicketReportTicketSize', 0);
  TicketSize := TTicketSize(ticketSizeInt);
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
  SaveParam('TicketReportSignatureVisible', SignatureVisible);
  SaveParam('TicketReportSerialNumberVisible', SerialNumberVisible);
  SaveParam('TicketReportDocumentDateVisible', DocumentDateVisible);
  SaveParam('TicketReportDeleteUnprintableElemnts', DeleteUnprintableElemnts);
  SaveParam('TicketReportTicketSize', Integer(TicketSize));
  inherited;
end;

end.
