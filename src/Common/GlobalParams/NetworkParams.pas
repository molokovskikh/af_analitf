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
    procedure ReadParams; override;
    procedure SaveParams; override;
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
    NetworkPositionPercent := 0
  else
    NetworkPositionPercent := value;
  value := GetParam('NetworkExternalOrder');
  if VarIsNull(value) then
    NetworkExternalOrder := 0
  else
    NetworkExternalOrder := value;
end;

procedure TNetworkParams.SaveParams;
begin
  SaveParam('NetworkExportPricesFolder', NetworkExportPricesFolder);
  SaveParam('NetworkPositionPercent', NetworkPositionPercent);
end;

end.
