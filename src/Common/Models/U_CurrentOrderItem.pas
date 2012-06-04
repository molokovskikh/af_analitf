unit U_CurrentOrderItem;

interface

uses
  SysUtils,
  Classes,
  AProc,
  U_CurrentOrderHead,
  U_Offer;

type
  TPositionSendResult =
    (
     //Позиция успешно отправлена
     psrSuccess = -1,
     //Позиция не существует
     psrNotExists = 0,
     //Различия в цене
     psrDifferentCost = 1,
     //Различия в количестве
     psrDifferentQuantity = 2,
     //Различия в цене и количестве
     psrDifferentCostAndQuantity = 3,
     //Позиция объединена
     psrUnoin = 4);
     
const
  PositionSendResultText : array[TPositionSendResult] of string =
  ('успешно отправлена',
   'предложение отсутствует',
   'имеется различие в цене препарата',
   'доступное количество препарата в прайс-листе меньше заказанного ранее',
   'имеются различия с прайс-листом в цене и количестве заказанного препарата',
   'позиция была объединена');

type
  TCurrentOrderItem = class
   public
    Id : Int64;
    Order: TCurrentOrderHead;
    OrderId : Int64;
    ProductId : Int64;
    CodeFirmCr : Variant;
    SynonymCode : Variant;
    SynonymFirmCrCode : Variant;
    SynonymName : String;
    SynonymFirm : String;
    Code : String;
    CodeCr : String;
    OrderCount : Integer;
    Junk : Boolean;
    Await : Boolean;
    MinOrderCount : Variant;
    //float
    OrderCost : Variant;
    RequestRatio : Variant;
    CoreId : Variant;

    Offer : TOffer;

    RealPrice : Double;
    Price : Double;
    RawRealPrice : Variant;
    RawPrice : Variant;

    DropReason : Variant;

    ServerCost : Variant;
    ServerQuantity : Variant;

    Period : String;
    ProducerCost : Variant;

    UnionOrderItem : TCurrentOrderItem;

    function IsOfferExists(aOffer: TOffer) : Boolean;
    function PeriodEquals(aOfferPeriod: String) : Boolean;
    function TryStrToPeriod(aPeriod: String; out Value: TDateTime) : Boolean;
    function IsAnotherOfferExists(aOffer: TOffer) : Boolean;
    function IsOfferValid(aOffer: TOffer) : Boolean;
    function IsFullOffer(aOffer: TOffer) : Boolean;

    procedure RecalcOrderCount();
    procedure UpdateDropReason();

    function ToString() : String;
    function ToRestoreReport() : String;
  end;

implementation

uses
  Variants,
  U_ExchangeLog;

{ TCurrentOrderItem }

function TCurrentOrderItem.IsAnotherOfferExists(aOffer: TOffer): Boolean;
begin
  Result :=
    (ProductId = aOffer.ProductId)
    and (VarIsNull(CodeFirmCr) or (aOffer.CodeFirmCr = CodeFirmCr) or (CodeFirmCr = 1))
end;

function TCurrentOrderItem.IsFullOffer(aOffer: TOffer): Boolean;
begin
  Result := not VarIsNull(aOffer.Quantity) and (aOffer.Quantity = OrderCount);
end;

function TCurrentOrderItem.IsOfferExists(aOffer: TOffer): Boolean;
begin
  Result :=
    (ProductId = aOffer.ProductId)
    and (VarIsNull(CodeFirmCr) or (aOffer.CodeFirmCr = CodeFirmCr) or (CodeFirmCr = 1))
    and (SynonymCode = aOffer.SynonymCode)
    and (SynonymFirmCrCode = aOffer.SynonymFirmCrCode)
    and (Code = aOffer.Code)
    and (Junk = aOffer.Junk)
    and (Await = aOffer.Await)
    and (PeriodEquals(aOffer.Period))
    and (ProducerCost = aOffer.ProducerCost)
end;

function TCurrentOrderItem.IsOfferValid(aOffer: TOffer): Boolean;
begin
  Result := VarIsNull(aOffer.Quantity) or (aOffer.Quantity >= OrderCount);
end;

function TCurrentOrderItem.PeriodEquals(aOfferPeriod: String): Boolean;
var
  orderPeriod,
  offerPeriod : TDateTime;
begin
  Result := Period = aOfferPeriod;
  if not Result then begin
    if TryStrToPeriod(Period, orderPeriod) and
       TryStrToPeriod(aOfferPeriod, offerPeriod)
    then
      Result := Period <= aOfferPeriod
    else
      Result := True;
  end;
end;

procedure TCurrentOrderItem.RecalcOrderCount;
var
  Remainder : Integer;
begin
  if (not IsOfferValid(Offer)) then
    OrderCount := Offer.Quantity;

  Offer.GetRequestRationRemainder(OrderCount, remainder);
  if (remainder > 0) then
    OrderCount := OrderCount - remainder;

  UpdateDropReason();
end;

function TCurrentOrderItem.ToRestoreReport: String;
var
  ServerCostStr,
  ServerQuantityStr : String;
begin
  Result := '';
  try
  
    if not VarIsNull(ServerCost) and (VarType(ServerCost) = varDouble) then
      ServerCostStr := Format('%0.2f', [Double(ServerCost)])
    else
      ServerCostStr := VarToStr(ServerCost);
    if not VarIsNull(ServerQuantity) and (VarType(ServerQuantity) = varInteger) then
      ServerQuantityStr := Format('%d', [Integer(ServerQuantity)])
    else
      ServerQuantityStr := VarToStr(ServerQuantity);

    if (not VarIsNull(DropReason)) then
    begin
      if (TPositionSendResult(DropReason) in [psrNotExists, psrUnoin]) then
        Result :=
          Format(
            '%s - %s : %s (старая цена: %s; старый заказ: %s)',
            [
              SynonymName,
              SynonymFirm,
              PositionSendResultText[TPositionSendResult(DropReason)],
              ServerCostStr,
              ServerQuantityStr
            ])
      else
        Result :=
          Format(
            '%s - %s : %s (старая цена: %s; старый заказ: %s; новая цена: %0.2f; новый заказ: %d)',
            [
              SynonymName,
              SynonymFirm,
              PositionSendResultText[TPositionSendResult(DropReason)],
              ServerCostStr,
              ServerQuantityStr,
              Price,
              OrderCount
            ]);
    end
    else
      Result := '';
  except
    on E : Exception do
      WriteExchangeLog('TCurrentOrderItem.ToRestoreReport', 'Error : ' + E.Message);
  end;
end;

function TCurrentOrderItem.ToString: String;
begin
  Result :=
    'Позиция  ' +
    ListToStr(
      [
        'Ид',
        'ЗаказИд',
        'ПредлИд',
        'Кол-во',
        'ПродуктИд',
        'ПроизводИд',
        'СинонимИд',
        'СинонимПрИд',
        'Code',
        'CodeCr',
        'ЦенаБО',
        'Цена',
        'Уценка',
        'Ожид',
        'Срок',
        'ЦенаПроизод',
        'DropReason'],
      [
        Id,
        OrderId,
        CoreId,
        OrderCount,
        ProductId,
        CodeFirmCr,
        SynonymCode,
        SynonymFirmCrCode,
        Code,
        CodeCr,
        RawRealPrice,
        RawPrice,
        Junk,
        Await,
        Period,
        ProducerCost,
        DropReason
      ]);
end;

function TCurrentOrderItem.TryStrToPeriod(aPeriod: String;
  out Value: TDateTime): Boolean;
begin
  if Length(aPeriod) < 10 then
    Result := False
  else
    Result :=
      TryEncodeDate(
        StrToIntDef(Copy(aPeriod, 7, 4), 0),
        StrToIntDef(Copy(aPeriod, 4, 2), 0),
        StrToIntDef(Copy(aPeriod, 1, 2), 0),
        Value
        );
end;

procedure TCurrentOrderItem.UpdateDropReason;
begin
  if ( not (abs(ServerCost-Price) < 0.001) and not (OrderCount = ServerQuantity)) then
    DropReason := Integer(psrDifferentCostAndQuantity)
  else
    if (not (abs(ServerCost-Price) < 0.001) ) then
      DropReason := Integer(psrDifferentCost)
    else
      if (not (OrderCount = ServerQuantity)) then
        DropReason := Integer(psrDifferentQuantity);
end;

end.
