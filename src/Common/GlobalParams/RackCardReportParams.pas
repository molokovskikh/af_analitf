unit RackCardReportParams;

interface
uses
  SysUtils,
  Classes,
  MyAccess,
  GlobalParams;

type
  TRackCardSize = (rcsStandart, rcsBig);

  TRackCardReportParams = class(TGlobalParams)
   public
    ProductVisible : Boolean;
    ProducerVisible : Boolean;
    SerialNumberVisible : Boolean;
    PeriodVisible : Boolean;
    QuantityVisible : Boolean;
    ProviderVisible : Boolean;
    CostVisible : Boolean;
    CertificatesVisible : Boolean;
    DateOfReceiptVisible : Boolean;

    RackCardSize : TRackCardSize;

    DeleteUnprintableElemnts : Boolean;
    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

{ TRackCardReportParams }

procedure TRackCardReportParams.ReadParams;
var
  rackCardSizeInt : Integer;
begin
  ProductVisible := GetParamDef('RackCardReportProductVisible', True);
  ProducerVisible := GetParamDef('RackCardReportProducerVisible', True);
  SerialNumberVisible := GetParamDef('RackCardReportSerialNumberVisible', True);
  PeriodVisible := GetParamDef('RackCardReportPeriodVisible', True);
  QuantityVisible := GetParamDef('RackCardReportQuantityVisible', True);
  ProviderVisible := GetParamDef('RackCardReportProviderVisible', True);
  CostVisible := GetParamDef('RackCardReportCostVisible', True);
  CertificatesVisible := GetParamDef('RackCardReportCertificatesVisible', True);
  DateOfReceiptVisible := GetParamDef('RackCardReportDateOfReceiptVisible', True);
  DeleteUnprintableElemnts := GetParamDef('RackCardReportDeleteUnprintableElemnts', False);
  rackCardSizeInt := GetParamDef('RackCardReportRackCardSize', 0);
  RackCardSize := TRackCardSize(rackCardSizeInt);
end;

procedure TRackCardReportParams.SaveParams;
begin
  SaveParam('RackCardReportProductVisible', ProductVisible);
  SaveParam('RackCardReportProducerVisible', ProducerVisible);
  SaveParam('RackCardReportSerialNumberVisible', SerialNumberVisible);
  SaveParam('RackCardReportPeriodVisible', PeriodVisible);
  SaveParam('RackCardReportQuantityVisible', QuantityVisible);
  SaveParam('RackCardReportProviderVisible', ProviderVisible);
  SaveParam('RackCardReportCostVisible', CostVisible);
  SaveParam('RackCardReportCertificatesVisible', CertificatesVisible);
  SaveParam('RackCardReportDateOfReceiptVisible', DateOfReceiptVisible);
  SaveParam('RackCardReportDeleteUnprintableElemnts', DeleteUnprintableElemnts);
  SaveParam('RackCardReportRackCardSize', Integer(RackCardSize));
  inherited;
end;

end.
