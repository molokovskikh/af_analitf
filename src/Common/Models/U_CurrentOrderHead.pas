unit U_CurrentOrderHead;

interface

uses
  SysUtils,
  Types,
  Classes,
  Contnrs,
  U_Address,
  U_Offer;

type
  TGroupByCoreId = class
   public
    CoreId : Int64;
    Items : TObjectList;
    constructor Create();
    destructor Destroy; override;
  end;

  TMatchingProvider = class
   public
    function SubSystem() : String; virtual; abstract;
    function FirstAction() : String; virtual; abstract;
    function SecondAction() : String; virtual; abstract;
    function Matching(item : TObject; offer : TOffer) : Boolean; virtual; abstract;
  end;

  TRestoreProvider = class(TMatchingProvider)
   public
    function SubSystem() : String; override;
    function FirstAction() : String; override;
    function SecondAction() : String; override;
    function Matching(item : TObject; offer : TOffer) : Boolean; override;
  end;

  TMoveToPriceProvider = class(TMatchingProvider)
   public
    function SubSystem() : String; override;
    function FirstAction() : String; override;
    function SecondAction() : String; override;
    function Matching(item : TObject; offer : TOffer) : Boolean; override;
  end;

  TCurrentOrderHead = class
   private
    FOrderItems : TObjectList;

    function GetGroupedByCoreId() : TObjectList;
   protected
    function OffersToString(aOffers : TObjectList) : String;
    function OrderItemsToString(aItems : TObjectList) : String;
    function FindOffer(aOffers : TObjectList; item : TObject; provider : TMatchingProvider) : TOffer;
    procedure MatchingOrderItemsToOffers(Offers : TObjectList; provider : TMatchingProvider);
   public
    OrderId : Int64;
    AddressId : Int64;
    Address : TAddress;
    PriceCode : Int64;
    RegionCode : Int64;
    PriceName : String;
    RegionName : String;
    Closed : Boolean;
    Send : Boolean;
    Frozen : Boolean;
    property OrderItems : TObjectList read FOrderItems;

    constructor Create();
    destructor Destroy; override;
    function CorrectionExists() : Boolean;

    function ToString() : String;

    procedure RestoreOrderItems(Offers : TObjectList);
    procedure RestoreOrderItemsToAnotherPrice(Offers : TObjectList);

    function GetProductIds() : TProductIds;
  end;


implementation

uses
  U_CurrentOrderItem,
  Variants,
  U_ExchangeLog;

function CompareValue(const A, B: Integer): TValueRelationship;
begin
  if A = B then
    Result := EqualsValue
  else if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function SortOrderItemByOrderCount(Item1, Item2: Pointer): Integer;
var
  Elem1, Elem2 : TCurrentOrderItem;
begin
  Elem1 := TCurrentOrderItem(Item1);
  Elem2 := TCurrentOrderItem(Item2);
  Result := Integer(CompareValue(Elem1.OrderCount, Elem2.OrderCount));
end;

{ TCurrentOrderHead }

function TCurrentOrderHead.CorrectionExists: Boolean;
var
  I : Integer;
  item : TCurrentOrderItem;
begin
  Result := False;
  for I := 0 to OrderItems.Count-1 do begin
    item := TCurrentOrderItem(OrderItems[i]);
    if not VarIsNull(item.DropReason) then begin
      Result := True;
      Exit;
    end;
  end;
end;

constructor TCurrentOrderHead.Create;
begin
  FOrderItems := TObjectList.Create();
  Address := nil;
end;

destructor TCurrentOrderHead.Destroy;
begin
  FreeAndNil(FOrderItems);
  inherited;
end;

function TCurrentOrderHead.FindOffer(aOffers: TObjectList;
  item: TObject; provider : TMatchingProvider): TOffer;
var
  I : Integer;
  Index : Integer;
  offer : TOffer;
  remainder : Integer;
  orderItem : TCurrentOrderItem;
begin
  orderItem := TCurrentOrderItem(item);
  Result := nil;

  Index := -1;
  for I := 0 to aOffers.Count-1 do
    if TOffer(aOffers[i]).ProductId = orderItem.ProductId then begin
      Index := i;
      Break;
    end;

  if (Index > -1) then begin
    for I := Index to aOffers.Count-1 do begin
      offer := TOffer(aOffers[i]);
      if (offer.ProductId = orderItem.ProductId) then
      begin
        if (provider.Matching(orderItem, offer)) then begin
          if (offer.IsMinOrderCountValid(orderItem.OrderCount)
            and offer.IsMinOrderSumValid(orderItem.OrderCount)
            and offer.GetRequestRationRemainder(orderItem.OrderCount, remainder))
          then begin
            if not Assigned(Result) or orderItem.IsOfferValid(offer) then
              Result := offer;
            if orderItem.IsOfferValid(Result) then
              Exit;
          end;
        end
      end
      else
        Exit;
    end
  end;
end;

function TCurrentOrderHead.GetGroupedByCoreId: TObjectList;

  function FindOrAdd(items : TObjectList; CoreId : Int64) : TGroupByCoreId;
  var
    addIndex : Integer;
  begin
    Result := nil;
    for addIndex := 0 to items.Count-1 do begin
      if (TGroupByCoreId(items[addIndex]).CoreId = CoreId) then begin
        Result := TGroupByCoreId(items[addIndex]);
        Exit;
      end;
    end;

    if (Result = nil) then begin
      Result := TGroupByCoreId.Create;
      Result.CoreId := CoreId;
      items.Add(Result);
    end;
  end;

var
  I : Integer;
  selected : TCurrentOrderItem;
  finded : TGroupByCoreId;
  deletedIndex : Integer;
  deleted : TGroupByCoreId;
begin
  Result := TObjectList.Create();

  try

    //var grouped = OrderItems.GroupBy(g => new { g.CoreId }).Where(g => g.Key.CoreId.HasValue && g.Count() > 1).ToList();
    //groupedItems := GetGroupedByCoreId(OrderItems);
    for I := 0 to OrderItems.Count-1 do begin
      selected := TCurrentOrderItem(OrderItems[i]);
      if (not VarIsNull(selected.CoreId)) then begin
        finded := FindOrAdd(Result, selected.CoreId);
        finded.Items.Add(selected);
      end;
    end;

    for deletedIndex := Result.Count-1 downto 0 do begin
      deleted := TGroupByCoreId(Result[deletedIndex]);
      if deleted.Items.Count < 2 then
        Result.Delete(deletedIndex);
    end;

  except
    Result.Free;
    raise;
  end;
end;

function TCurrentOrderHead.GetProductIds: TProductIds;
var
  I : Integer;
begin
  SetLength(Result, OrderItems.Count);
  for I := 0 to OrderItems.Count-1 do
    Result[i] := TCurrentOrderItem(OrderItems[i]).ProductId;
end;

procedure TCurrentOrderHead.MatchingOrderItemsToOffers(Offers: TObjectList;
  provider: TMatchingProvider);
var
  IsDebugEnabled : Boolean;
  restoreIndex : Integer;
  item : TCurrentOrderItem;
  offer : TOffer;
  groupedItems : TObjectList;
  groupedIndex : Integer;
  g : TGroupByCoreId;
  byCount : TObjectList;
  mainItem : TCurrentOrderItem;
  unionIndex : Integer;
  currentItem : TCurrentOrderItem;
begin
  IsDebugEnabled := True;

  if (IsDebugEnabled) then
    WriteExchangeLog(
      provider.SubSystem(),
      Format(
        '%s заказ %s с позициями:'#13#10'%s'#13#10'По предложениями:'#13#10'%s',
        [
          provider.FirstAction(),
          ToString(),
          OrderItemsToString(OrderItems),
          OffersToString(Offers)
        ]));

  for restoreIndex := 0 to OrderItems.Count-1 do begin
    item := TCurrentOrderItem(OrderItems[restoreIndex]);

    item.ServerCost := item.Price;
    item.ServerQuantity := item.OrderCount;

    offer := FindOffer(offers, item, provider);
    if (offer = nil) then
    begin
      if (IsDebugEnabled) then
        WriteExchangeLog(
          provider.SubSystem(),
          Format('Для CurrentOrderItem.Id = %d не было найдено подходящее предложение', [item.Id]));
      item.DropReason := psrNotExists;
      item.CoreId := Null;
      item.OrderCount := 0;
    end
    else begin
      if (IsDebugEnabled) then
        WriteExchangeLog(
          provider.SubSystem(),
          Format('Для CurrentOrderItem.Id = %d найдено предложение с Offer.CoreId: %d', [item.Id, offer.CoreId]));
      item.Offer := offer;
      item.CoreId := offer.CoreId;
      item.Price := offer.Cost;
      item.RealPrice := offer.RealCost;

      item.RecalcOrderCount();
    end;
  end;

  //var grouped = OrderItems.GroupBy(g => new { g.CoreId }).Where(g => g.Key.CoreId.HasValue && g.Count() > 1).ToList();
  //groupedItems := GetGroupedByCoreId(OrderItems);

  groupedItems := GetGroupedByCoreId();

  try

    for groupedIndex := 0 to groupedItems.Count-1 do begin
      g := TGroupByCoreId(groupedItems[groupedIndex]);

      //var byCount = g.OrderByDescending(item => item.OrderCount).ToList();
      g.Items.Sort(SortOrderItemByOrderCount);
      byCount := g.Items;

      mainItem := TCurrentOrderItem(byCount[0]);
      if (IsDebugEnabled) then
        WriteExchangeLog(
          provider.SubSystem(),
          Format('Существуют дублирующиеся позиции по Offer.CoreId %d:\r\n%s', [g.CoreId, OrderItemsToString(byCount)]));
      for unionIndex := 1 to byCount.Count-1 do begin
        currentItem := TCurrentOrderItem(byCount[unionIndex]);
        if (mainItem.IsFullOffer(mainItem.Offer)) then
        begin
          currentItem.DropReason := psrNotExists;
          currentItem.CoreId := Null;
          currentItem.OrderCount := 0;

          if (IsDebugEnabled) then
            WriteExchangeLog(
              provider.SubSystem(),
              Format('CurrentOrderItem.Id = %d была помечена как не найденная', [currentItem.Id]));
        end
        else begin
          mainItem.OrderCount := mainItem.OrderCount + currentItem.OrderCount;
          currentItem.DropReason := psrUnoin;
          currentItem.UnionOrderItem := mainItem;
          currentItem.CoreId := Null;
          currentItem.OrderCount := 0;

          if (IsDebugEnabled) then
            WriteExchangeLog(
              provider.SubSystem(),
              Format('CurrentOrderItem.Id = %d была помечена как объединенная', [currentItem.Id]));

          mainItem.RecalcOrderCount();
        end;
      end
    end;

  finally
    FreeAndNil(groupedItems);
  end;

  if (IsDebugEnabled) then
    WriteExchangeLog(
      provider.SubSystem(),
      Format('Закончили %s позиций по заказу: %d',
      [provider.SecondAction(),
       OrderId]));
end;

function TCurrentOrderHead.OffersToString(aOffers: TObjectList): String;
var
  I : Integer;
begin
  if (aOffers.Count = 0) then
    Result := ''
  else begin
    Result := TOffer(aOffers[0]).ToString();
    for I := 1 to aOffers.Count-1 do
      Result := Result + #13#10 + TOffer(aOffers[i]).ToString();
  end;
end;

function TCurrentOrderHead.OrderItemsToString(aItems: TObjectList): String;
var
  I : Integer;
begin
  if (aItems.Count = 0) then
    Result := ''
  else begin
    Result := TCurrentOrderItem(aItems[0]).ToString();
    for I := 1 to aItems.Count-1 do
      Result := Result + #13#10 + TCurrentOrderItem(aItems[i]).ToString();
  end;
end;

procedure TCurrentOrderHead.RestoreOrderItems(Offers: TObjectList);
begin
  MatchingOrderItemsToOffers(Offers, TRestoreProvider.Create());
end;

procedure TCurrentOrderHead.RestoreOrderItemsToAnotherPrice(
  Offers: TObjectList);
begin
  MatchingOrderItemsToOffers(Offers, TMoveToPriceProvider.Create());
end;

function TCurrentOrderHead.ToString: String;
begin
  Result :=
    Format(
      'CurrentOrderHead   OrderId: %d  AddressId: %d  PriceName: %s (%d)  RegionName: %s (%d)',
      [
        OrderId,
        AddressId,
        PriceName,
        PriceCode,
        RegionName,
        RegionCode
      ]);
end;

{ TGroupByCoreId }

constructor TGroupByCoreId.Create;
begin
  Items := TObjectList.Create(False);
end;

destructor TGroupByCoreId.Destroy;
begin
  FreeAndNil(Items);
  inherited;
end;

{ TRestoreProvider }

function TRestoreProvider.FirstAction: String;
begin
  Result := 'Восстанавливаем';
end;

function TRestoreProvider.Matching(item: TObject; offer: TOffer): Boolean;
begin
  Result := False;
  if item is TCurrentOrderItem then
    Result := TCurrentOrderItem(item).IsOfferExists(offer);
end;

function TRestoreProvider.SecondAction: String;
begin
  Result := 'восстановление';
end;

function TRestoreProvider.SubSystem: String;
begin
  Result := 'RestoreOrders';
end;

{ TMoveToPriceProvider }

function TMoveToPriceProvider.FirstAction: String;
begin
  Result := 'Перемещаем';
end;

function TMoveToPriceProvider.Matching(item: TObject;
  offer: TOffer): Boolean;
begin
  Result := False;
  if item is TCurrentOrderItem then
    Result := TCurrentOrderItem(item).IsAnotherOfferExists(offer);
end;

function TMoveToPriceProvider.SecondAction: String;
begin
  Result := 'перемещение';
end;

function TMoveToPriceProvider.SubSystem: String;
begin
  Result := 'MoveToPrice';
end;

end.