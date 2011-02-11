unit NetworkParams;

interface

uses
  SysUtils,
  Classes,
  Variants,
  MyAccess,
  GlobalParams;

type
  TNetworkParams = class(TGlobalParams)
   public
    NetworkExportPricesFolder : String;
    NetworkPositionPercent : Double;
    NetworkExternalOrder : Integer;
    NetworkMinCostPercent : Integer;
    procedure ReadParams; override;
    procedure SaveParams; override;
    procedure SaveMinCostPercent;
  end;


implementation

{ TNetworkParams }

procedure TNetworkParams.ReadParams;
var
  value : Variant;
begin
  value := GetParam('NetworkExportPricesFolder');
  if VarIsNull(value) then
    NetworkExportPricesFolder := ''
  else
    NetworkExportPricesFolder := value;
  value := GetParam('NetworkPositionPercent');
  if VarIsNull(value) then
    NetworkPositionPercent := 10
  else
    NetworkPositionPercent := value;
  value := GetParam('NetworkExternalOrder');
  if VarIsNull(value) then
    NetworkExternalOrder := 0
  else
    NetworkExternalOrder := value;
  value := GetParam('NetworkMinCostPercent');
  if VarIsNull(value) then
    NetworkMinCostPercent := 7
  else
    NetworkMinCostPercent := value;
end;

procedure TNetworkParams.SaveMinCostPercent;
begin
  SaveParam('NetworkMinCostPercent', NetworkMinCostPercent);
end;

procedure TNetworkParams.SaveParams;
begin
  SaveParam('NetworkExportPricesFolder', NetworkExportPricesFolder);
  SaveParam('NetworkPositionPercent', NetworkPositionPercent);
  SaveMinCostPercent;
  inherited;
end;

end.
