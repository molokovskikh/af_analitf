unit U_Offer;

interface

uses
  SysUtils,
  Classes;

type
  TProductIds = array of Int64;
  
  TOffer = class
   public
    CoreId : Int64;
    Period : String;
    ProductId : Int64;
    Code : String;
    CodeCr : String;
    Junk : Boolean;
    Await : Boolean;
    CodeFirmCr : Variant;
    RealCost : Double;
    Cost : Double;
    ProducerCost : Variant;
    SynonymCode : Int64;
    SynonymFirmCrCode : Variant;
    Quantity : Variant;
    RequestRatio : Variant;
    OrderCost : Variant;
    MinOrderCount : Variant;
    PriceCode : Int64;
    RegionCode : Int64;
    PriceName : String;

    function ToHumanReadableString() : String;
    function IsMinOrderSumValid(aQuantity : Integer) : Boolean;
    function GetRequestRationRemainder(aQuantity : Integer; var aRemainder : Integer) : Boolean;
    function IsMinOrderCountValid(aQuantity : Integer) : Boolean;
    function ToString() : String;
  end;

implementation

uses Variants;

{ TOffer }

function TOffer.GetRequestRationRemainder(aQuantity: Integer;
  var aRemainder: Integer): Boolean;
begin
  aRemainder := 0;
  if (VarIsNull(RequestRatio)) then
    Result := True
  else
    if (RequestRatio = 0) then
      Result := True
    else begin
      if (aQuantity < RequestRatio) then
        Result := False
      else begin
        aRemainder := aQuantity mod RequestRatio;
        Result := True;
      end;
    end;
end;

function TOffer.IsMinOrderCountValid(aQuantity: Integer): Boolean;
begin
  if (VarIsNull(MinOrderCount)) then
    Result := True
  else
    Result := MinOrderCount <= aQuantity;
end;

function TOffer.IsMinOrderSumValid(aQuantity: Integer): Boolean;
begin
  if (VarIsNull(OrderCost)) then
    Result := True
  else begin
    if (OrderCost = 0) then
      Result := True
    else
      Result := (aQuantity * Cost) >= OrderCost;
  end;
end;

function TOffer.ToHumanReadableString: String;
begin
  Result := Format('Предложение %s по цене %0.2f', [PriceName, Cost]);
end;

function TOffer.ToString: String;
begin
  Result :=
    Format(
      'Offer Id = %d, ProductId = %d, CodeFirmCr = %s, SynonymCode = %d, SynonymFirmCrCode = %s, Code = %s, CodeCr = %s, Period = %s, Junk = %s, Await = %s, ' +
      'RealCost = %0.2f, Cost = %0.2f, Quantity = %s, ProducerCost = %s, OrderCost = %s, RequestRatio = %s, MinOrderCount = %s, PriceName = %s',
      [
        CoreId,
        ProductId,
        VarToStrDef(CodeFirmCr, '(Null)'),
        SynonymCode,
        VarToStrDef(SynonymFirmCrCode, '(Null)'),
        Code,
        CodeCr,
        Period,
        BoolToStr(Junk, True),
        BoolToStr(Await, True),
        RealCost,
        Cost,
        VarToStrDef(Quantity, '(Null)'),
        VarToStrDef(ProducerCost, '(Null)'),
        VarToStrDef(OrderCost, '(Null)'),
        VarToStrDef(RequestRatio, '(Null)'),
        VarToStrDef(MinOrderCount, '(Null)'),
        PriceName
      ]);
end;

end.