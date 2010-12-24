unit AllOrdersParams;

interface

uses
  SysUtils,
  Classes,
  Variants,
  MyAccess,
  GlobalParams;

type
  TAllOrdersParams = class(TGlobalParams)
   public
    ShowAllOrders : Boolean;
    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

{ TAllOrdersParams }

procedure TAllOrdersParams.ReadParams;
var
  value : Variant;
begin
  value := GetParam('ShowAllOrders');
  if VarIsNull(value) then
    ShowAllOrders := False
  else
    ShowAllOrders := value;
end;

procedure TAllOrdersParams.SaveParams;
begin
  SaveParam('ShowAllOrders', ShowAllOrders);
end;

end.
