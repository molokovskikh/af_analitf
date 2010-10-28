unit U_DBMapping;

interface

uses
  SysUtils,
  Classes,
  StrUtils,
  Contnrs,
  DB,
  MyAccess,
  DBProc,
  U_Address,
  U_Offer,
  U_CurrentOrderHead,
  U_CurrentOrderItem;

type
  TDBMapping = class
   public
    class function GetSqlDataSet(
      connection: TCustomMyConnection;
      SQL: String;
      Params: array of string;
      Values: array of Variant) : TMyQuery;
    class function GetCurrentOrderHeadsByAddress(connection : TCustomMyConnection; address : TAddress) : TObjectList;

    class function GetCurrentOrderItemsByOrder(connection : TCustomMyConnection; currentOrderHead : TCurrentOrderHead) : TObjectList;

    class function GetOffersByPriceAndProductId(
      connection : TCustomMyConnection;
      priceCode : Int64;
      regionCode : Int64;
      productIds : TProductIds) : TObjectList;

    class procedure SaveOrderItem(connection : TCustomMyConnection; currentOrderItem : TCurrentOrderItem);

    class function GetAddresses(connection : TCustomMyConnection) : TObjectList;
  end;

implementation

uses Variants;

{ TDBMapping }

class function TDBMapping.GetAddresses(
  connection: TCustomMyConnection): TObjectList;
var
  dataSet : TMyQuery;
  address : TAddress;
begin
  dataSet := GetSqlDataSet(
    connection,
 'select '
+'  ClientId, '
+'  Name, '
+'  FullName, '
+'  RegionCode, '
+'  Name as SelfAddressId, '
+'  ReqMask '
+'from        '
+'    clients '
+'order by Name',
    [],
    []);

  Result := TObjectList.Create();
  try
    try
      while not dataSet.Eof do begin
        address := TAddress.Create();
        address.Id := dataSet['ClientId'];
        address.Name := VarToStr(dataSet['Name']);
        address.FullName := VarToStr(dataSet['FullName']);
        address.RegionCode := dataSet['RegionCode'];
        address.SelfAddressId := VarToStr(dataSet['SelfAddressId']);
        address.ReqMask := dataSet['ReqMask'];
        Result.Add(address);
        dataSet.Next;
      end;
    finally
      dataSet.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TDBMapping.GetCurrentOrderHeadsByAddress(
  connection: TCustomMyConnection; address: TAddress): TObjectList;
var
  dataSet : TMyQuery;
  order : TCurrentOrderHead;
  orderList : TObjectList;
  I : Integer;
begin
  dataSet := GetSqlDataSet(
    connection,
    ''
+' select '
+'  CurrentOrderHeads.OrderId, '
+'  CurrentOrderHeads.ClientId as AddressId, '
+'  CurrentOrderHeads.PriceCode, '
+'  CurrentOrderHeads.RegionCode, '
+'  CurrentOrderHeads.PriceName, '
+'  CurrentOrderHeads.RegionName,  '
+'  CurrentOrderHeads.Closed, '
+'  CurrentOrderHeads.Send, '
+'  CurrentOrderHeads.Frozen, '
+'  CurrentOrderHeads.OrderDate, '
+'  CurrentOrderHeads.SendDate '
+' from '
+'  CurrentOrderHeads '
+'  inner join CurrentOrderLists on '
+'    (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId) '
+'    and (CurrentOrderLists.OrderCount > 0) '
+' where '
+'    (CurrentOrderHeads.ClientId = :AddressId) '
+' and (CurrentOrderHeads.Closed = 0) '
+' and (CurrentOrderHeads.Frozen = 0) '
+' group by CurrentOrderHeads.OrderId '
+' order by CurrentOrderHeads.PriceName '
    ,
    ['AddressId'],
    [address.Id]);

  Result := TObjectList.Create();
  try
    try
      while not dataSet.Eof do begin
        order := TCurrentOrderHead.Create();
        order.Address := address;

        order.OrderId := dataSet['OrderId'];
        order.AddressId := dataSet['AddressId'];
        order.PriceCode := dataSet['PriceCode'];
        order.RegionCode := dataSet['RegionCode'];
        order.PriceName := dataSet['PriceName'];
        order.RegionName := dataSet['RegionName'];

        order.Closed := dataSet.FieldByName('Closed').AsBoolean;
        order.Send := dataSet.FieldByName('Send').AsBoolean;
        order.Frozen := dataSet.FieldByName('Frozen').AsBoolean;

        Result.Add(order);
        dataSet.Next;
      end;
    finally
      dataSet.Free;
    end;

    for I := 0 to Result.Count-1 do begin
      order := TCurrentOrderHead(Result[i]);

      orderList := GetCurrentOrderItemsByOrder(connection, order);
      try
        orderList.OwnsObjects := False;
        order.OrderItems.Assign(orderList);
      finally
        orderList.Free;
      end;
    end;

  except
    Result.Free;
    raise;
  end;
end;

class function TDBMapping.GetCurrentOrderItemsByOrder(
  connection: TCustomMyConnection;
  currentOrderHead: TCurrentOrderHead): TObjectList;
var
  dataSet : TMyQuery;
  orderItem : TCurrentOrderItem;
begin
  //Order by SynonymName
  dataSet := GetSqlDataSet(
    connection,
      ''
+' select '
+'   col.Id, '
+'   col.CoreId, '
+'   col.OrderCount, '
+'   col.OrderId, '
+'   col.ProductId, '
+'   col.CodeFirmCr, '
+'   col.SynonymCode, '
+'   col.SynonymFirmCrCode, '
+'   col.SynonymName, '
+'   col.SynonymFirm, '
+'   col.Code, '
+'   col.CodeCr, '
+'   col.Junk, '
+'   col.Await, '
+'   col.RealPrice, '
+'   col.Price, '
+'   col.MinOrderCount, '
+'   col.OrderCost, '
+'   col.RequestRatio, '
+'   col.DropReason, '
+'   col.ServerCost, '
+'   col.ServerQuantity, '
+'   col.Period, '
+'   col.ProducerCost '
+' from '
+'   CurrentOrderLists col '
+'   inner join CurrentOrderHeads h on h.OrderId = col.OrderId and h.Frozen = 0 and h.Closed = 0 '
+'   inner join pricesData pd on pd.PriceCode = h.PriceCode '
+'   left join Core on Core.PriceCode = h.PriceCode and Core.RegionCode = h.RegionCode and Core.CoreId = col.CoreId '
+' where '
+'    col.OrderId = :OrderId '
+' order by col.SynonymName '
    ,
    ['OrderId'],
    [currentOrderHead.OrderId]);

  Result := TObjectList.Create();
  try
    try
      while not dataSet.Eof do begin
        orderItem := TCurrentOrderItem.Create();

        orderItem.Order := currentOrderHead;

        orderItem.Id := dataSet['Id'];
        orderItem.CoreId := dataSet['CoreId'];
        orderItem.OrderCount := dataSet['OrderCount'];
        orderItem.OrderId := dataSet['OrderId'];
        orderItem.ProductId := dataSet['ProductId'];
        orderItem.CodeFirmCr := dataSet['CodeFirmCr'];
        orderItem.SynonymCode := dataSet['SynonymCode'];
        orderItem.SynonymFirmCrCode := dataSet['SynonymFirmCrCode'];
        orderItem.SynonymName := VarToStr(dataSet['SynonymName']);
        orderItem.SynonymFirm := VarToStr(dataSet['SynonymFirm']);
        orderItem.Code := VarToStr(dataSet['Code']);
        orderItem.CodeCr := VarToStr(dataSet['CodeCr']);

        orderItem.Junk := dataSet.FieldByName('Junk').AsBoolean;
        orderItem.Await := dataSet.FieldByName('Await').AsBoolean;

        orderItem.RealPrice := dataSet['RealPrice'];
        orderItem.Price := dataSet['Price'];

        orderItem.MinOrderCount := dataSet['MinOrderCount'];
        orderItem.OrderCost := dataSet['OrderCost'];
        orderItem.RequestRatio := dataSet['RequestRatio'];

        orderItem.DropReason := dataSet['DropReason'];

        orderItem.ServerCost := dataSet['ServerCost'];
        orderItem.ServerQuantity := dataSet['ServerQuantity'];

        orderItem.Period := VarToStr(dataSet['Period']);
        orderItem.ProducerCost := dataSet['ProducerCost'];

        Result.Add(orderItem);
        dataSet.Next;
      end;
    finally
      dataSet.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TDBMapping.GetOffersByPriceAndProductId(
  connection: TCustomMyConnection; priceCode, regionCode: Int64;
  productIds: TProductIds): TObjectList;
var
  dataSet : TMyQuery;
  offer : TOffer;
  //Order by ProductId and Cost
  productSql : String;
  i : Integer;
  tmpQuantity : Integer;
begin
  productSql := '';
  if (Length(productIds) > 0) then begin
    if Length(productIds) = 1 then
      productSql := IntToStr(productIds[0])
    else begin
      productSql := IntToStr(productIds[0]);
      for I := Low(productIds)+1 to High(productIds) do begin
        productSql := productSql + ', ' + IntToStr(productIds[i]);
      end;
    end;
  end;

  dataSet := GetSqlDataSet(
    connection,
    ''
+' select '
+'   Core.CoreId, '
+'   Core.Period, '
+'   Core.Await, '
+'   Core.Junk, '
+'   Core.Code, '
+'   Core.CodeCr, '
+'   synonyms.SynonymName, '
+'   synonymFirmCr.SynonymName as SynonymFirm, '
+'   Core.ProductId, '
+'   Core.CodeFirmCr, '
+'   Core.Cost as RealCost, '
+'   if(dop.Percent is null, Core.Cost, cast(Core.Cost * (1 + dop.Percent/100) as decimal(18, 2))) as Cost, '
+'   Core.ProducerCost, '
+'   Core.SynonymCode, '
+'   Core.SynonymFirmCrCode, '
+'   Core.Quantity, '
+'   Core.RequestRatio, '
+'   Core.OrderCost, '
+'   Core.MinOrderCount, '
+'   Core.PriceCode, '
+'   Core.RegionCode, '
+'   pricesdata.PriceName '
+' from '
+'   core '
+'   inner join pricesdata on Core.PriceCode = pricesdata.PriceCode '
+'   left join DelayOfPayments dop on (dop.FirmCode = pricesdata.FirmCode) '
+'   left join synonyms on synonyms.SynonymCode = Core.SynonymCode '
+'   left join synonymFirmCr on synonymFirmCr.synonymFirmCrCode = Core.synonymFirmCrCode '
+' where '
+ '  PricesData.PriceCode = :PriceCode and Core.RegionCode = :RegionCode '
+ IfThen(Length(productSql) > 0, ' and Core.ProductId in ( ' + productSql + ') ')
+ '  order by Core.ProductId, Cost asc'
    ,
    ['PriceCode', 'RegionCode'],
    [priceCode, regionCode]);

  Result := TObjectList.Create();
  try
    try
      while not dataSet.Eof do begin
        offer := TOffer.Create();

        offer.CoreId := dataSet['CoreId'];
        offer.Period := VarToStr(dataSet['Period']);
        offer.Await := dataSet.FieldByName('Await').AsBoolean;
        offer.Junk := dataSet.FieldByName('Junk').AsBoolean;
        offer.Code := VarToStr(dataSet['Code']);
        offer.CodeCr := VarToStr(dataSet['CodeCr']);
        offer.ProductId := dataSet['ProductId'];
        offer.CodeFirmCr := dataSet['CodeFirmCr'];
        offer.RealCost := dataSet['RealCost'];
        offer.Cost := dataSet['Cost'];

        offer.ProducerCost := dataSet['ProducerCost'];
        offer.SynonymCode :=  dataSet['SynonymCode'];
        offer.SynonymFirmCrCode :=  dataSet['SynonymFirmCrCode'];

        offer.Quantity := Null;
        tmpQuantity := StrToIntDef(dataSet.FieldByName('Quantity').AsString, -1);
        if tmpQuantity > 0 then
          offer.Quantity := tmpQuantity;

        offer.RequestRatio := dataSet['RequestRatio'];
        offer.OrderCost := dataSet['OrderCost'];
        offer.MinOrderCount := dataSet['MinOrderCount'];

        offer.PriceCode := dataSet['PriceCode'];
        offer.RegionCode := dataSet['RegionCode'];
        offer.PriceName := VarToStr(dataSet['PriceName']);

        Result.Add(offer);
        dataSet.Next;
      end;
    finally
      dataSet.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TDBMapping.GetSqlDataSet(connection: TCustomMyConnection;
  SQL: String; Params: array of string;
  Values: array of Variant): TMyQuery;
var
  I : Integer;
  adsQueryValue : TMyQuery;
begin
  if (Length(Params) <> Length(Values)) then
    raise Exception.Create('QueryValue: ���-�� ���������� �� ��������� �� ������� ��������.');

  adsQueryValue := TMyQuery.Create(nil);
  try
    adsQueryValue.Connection := connection;
    
    adsQueryValue.SQL.Text := SQL;
    for I := Low(Params) to High(Params) do
      adsQueryValue.ParamByName(Params[i]).Value := Values[i];

    adsQueryValue.Open;
  except
    adsQueryValue.Free;
    raise;
  end;
  Result := adsQueryValue;
end;

class procedure TDBMapping.SaveOrderItem(connection: TCustomMyConnection;
  currentOrderItem: TCurrentOrderItem);
begin
  DBProc.UpdateValue(
    connection,
    ''
+' update '
+'  CurrentOrderLists '
+' set '
+'  CoreId = :CoreId, '
+'  Price = :Price, '
+'  RealPrice = :RealPrice, '
+'  OrderCount = :OrderCount, '
+'  DropReason = :DropReason, '
+'  ServerCost = :ServerCost, '
+'  ServerQuantity = :ServerQuantity '
+'where '
+'  ID = :ID ',
    ['Id', 'CoreId', 'Price', 'RealPrice', 'OrderCount', 'DropReason', 'ServerCost', 'ServerQuantity'],
    [currentOrderItem.Id, currentOrderItem.CoreId, currentOrderItem.Price,
     currentOrderItem.RealPrice, currentOrderItem.OrderCount,
     currentOrderItem.DropReason, currentOrderItem.ServerCost, currentOrderItem.ServerQuantity]);

  if not VarIsNull(currentOrderItem.DropReason) and (TPositionSendResult(currentOrderItem.DropReason) = psrUnoin)
    and Assigned(currentOrderItem.UnionOrderItem)
  then
    DBProc.UpdateValue(
      connection,
      ''
+' update '
+'  batchreport '
+' set '
+'  OrderListId = :NewOrderListId '
+'where '
+'  OrderListId = :OldOrderListId ',
      ['OldOrderListId', 'NewOrderListId'],
      [currentOrderItem.Id, currentOrderItem.UnionOrderItem.Id]);

  if not VarIsNull(currentOrderItem.CoreId)
  then
    DBProc.UpdateValue(
      connection,
      ''
+' update '
+'   CurrentOrderLists, '
+'   Core '
+' set '
+'   CurrentOrderLists.CodeFirmCr = Core.CodeFirmCr, '
+'   CurrentOrderLists.CODECR = Core.CODECR, '
+'   CurrentOrderLists.SupplierPriceMarkup = Core.SupplierPriceMarkup, '
+'   CurrentOrderLists.CoreQuantity = Core.Quantity, '
+'   CurrentOrderLists.ServerCoreID = Core.ServerCoreID, '
+'   CurrentOrderLists.Unit = Core.Unit, '
+'   CurrentOrderLists.Volume = Core.Volume, '
+'   CurrentOrderLists.Note = Core.Note, '
+'   CurrentOrderLists.Doc = Core.Doc, '
+'   CurrentOrderLists.RegistryCost = Core.RegistryCost, '
+'   CurrentOrderLists.VitallyImportant = Core.VitallyImportant, '
+'   CurrentOrderLists.NDS = Core.NDS '
+' where '
+'   CurrentOrderLists.ID = :ID '
+' and CurrentOrderLists.CoreId = Core.CoreId '
+' and Core.CoreId = :CoreId'
      ,
      ['Id', 'CoreId'],
      [currentOrderItem.Id, currentOrderItem.CoreId]);
end;

end.