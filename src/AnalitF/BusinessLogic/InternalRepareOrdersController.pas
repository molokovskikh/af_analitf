unit InternalRepareOrdersController;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Variants,
  Contnrs,
  AProc,
  DatabaseObjects,
  DModule,
  U_ExchangeLog,
  SQLWaiting,
  CorrectOrders,
  DayOfWeekHelper,
  U_CurrentOrderItem,
  U_CurrentOrderHead,
  U_Address,
  U_DBMapping;


type
  TAddressInfo = class
   public
    Address : TAddress;
    Orders : TObjectList;

    constructor Create(aAddress : TAddress);
    destructor Destroy; override;

    function CorrectionExists() : Boolean;
  end;

  TInternalRepareOrders = class
   public
    Strings  : TStrings;
    ProcessSendOrdersResponse : Boolean;
    RestoreAfterOpen : Boolean;

    _infos : TObjectList;

    procedure RepareOrders;
    procedure InternalRepareOrders;

    procedure FillAddresses();
    procedure RestoreOrders();
    procedure FormatLog();
    function  CorrectionExists(): Boolean;

    destructor Destroy; override;
  end;

implementation

{ TInternalRepareOrders }

function TInternalRepareOrders.CorrectionExists: Boolean;
var
  I : Integer;
begin
  Result := False;
  for I := 0 to _infos.Count-1 do
    if (TAddressInfo(_infos[i]).CorrectionExists()) then begin
      Result := True;
      Exit;
    end;
end;

destructor TInternalRepareOrders.Destroy;
begin
  if Assigned(_infos) then
    FreeAndNil(_infos);
  inherited;
end;

procedure TInternalRepareOrders.FillAddresses;
var
  addresses : TObjectList;
  index : Integer;
  info : TAddressInfo;

begin
  addresses := TDBMapping.GetAddresses(DM.MainConnection);
  try
    addresses.OwnsObjects := False;

    for index := 0 to addresses.Count-1 do begin
      info := TAddressInfo.Create(TAddress(addresses[index]));
      _infos.Add(info);
    end;
  finally
    addresses.Free;
  end;
end;

procedure TInternalRepareOrders.FormatLog;
var
  infoIndex : Integer;
  info : TAddressInfo;
  orderIndex : Integer;
  order : TCurrentOrderHead;
  positionIndex : Integer;
  position : TCurrentOrderItem;
begin
  if (CorrectionExists()) then begin

    for infoIndex := 0 to _infos.Count-1 do
      if (TAddressInfo(_infos[infoIndex]).CorrectionExists()) then begin

        info := TAddressInfo(_infos[infoIndex]);
        Strings.Add('клиент ' + info.Address.Name);

        for orderIndex := 0 to info.Orders.Count-1 do
          if (TCurrentOrderHead(info.Orders[orderIndex]).CorrectionExists()) then begin

            order := TCurrentOrderHead(info.Orders[orderIndex]);
            Strings.Add('   прайс-лист ' + order.PriceName);
            if (Length(order.ErrorReason) > 0) then
              Strings.Add('    ' + order.ErrorReason);

            for positionIndex := 0 to order.OrderItems.Count-1 do begin
              position := TCurrentOrderItem(order.OrderItems[positionIndex]);
              if (not VarIsNull(position.DropReason)) then
                Strings.Add('      ' + position.ToRestoreReport());
            end;

          end;

      end;

  end;
end;

procedure TInternalRepareOrders.InternalRepareOrders;
begin
  if not DM.adtClients.IsEmpty
    and DM.adsUser.FieldByName('AllowDelayOfPayment').AsBoolean
  then begin
    DM.adcUpdate.SQL.Text := ''
+' update '
+'   CurrentOrderHeads '
+'   inner join pricesdata on pricesdata.PriceCode = CurrentOrderHeads.PriceCode '
+'   left join DelayOfPayments on (DelayOfPayments.PriceCode = pricesdata.PriceCode) and '
+'             (DelayOfPayments.DayOfWeek = :DayOfWeek) '
+'  set '
+'     CurrentOrderHeads.DelayOfPayment = DelayOfPayments.OtherDelay, '
+'     CurrentOrderHeads.VitallyDelayOfPayment = DelayOfPayments.VitallyImportantDelay ';
    DM.adcUpdate.ParamByName('DayOfWeek').Value := TDayOfWeekHelper.DayOfWeek();
    DM.adcUpdate.Execute;
  end;
  FillAddresses();
  RestoreOrders();
  DatabaseController.BackupOrdersDataTables();
  FormatLog();
end;

procedure TInternalRepareOrders.RepareOrders;
begin
  _infos := TObjectList.Create();

  DM.adsRepareOrders.Close;

  DM.adsRepareOrders.RestoreSQL;
  //≈сли обрабатываем ответ от сервера, то рассматриваем только "отправл€емые" за€вки
//  омментирую это, т.к. это всегда False
//  if ProcessSendOrdersResponse then
//    DM.adsRepareOrders.AddWhere('(CurrentOrderHeads.Send = 1)');

  DM.adsRepareOrders.Open;

  if DM.adsRepareOrders.IsEmpty then
  begin
    DM.adsRepareOrders.Close;
    exit;
  end;

  Strings := TStringList.Create;

  try

    if RestoreAfterOpen then
      InternalRepareOrders
    else
      ShowSQLWaiting(InternalRepareOrders, 'ѕроисходит пересчет заказов');

    if not SilentMode then begin
      { если не нашли что-то, то выводим сообщение }
      if (Strings.Count > 0) and (Length(Strings.Text) > 0) then begin
        if RestoreAfterOpen then
          WriteExchangeLog('RestoreOrders', '¬осстановленные заказы после открыти€ программы:'#13#10 + Strings.Text)
        else begin
          WriteExchangeLog('RestoreOrders', '¬осстановленные заказы после обновлени€:'#13#10 + Strings.Text);
          ShowCorrectOrders(False);
        end;
      end;
    end;

  finally
    Strings.Free;
    DM.adsRepareOrders.Close;
  end;
end;

procedure TInternalRepareOrders.RestoreOrders;
var
  I : Integer;
  info : TAddressInfo;
  order : TCurrentOrderHead;
  orderIndex : Integer;
  offers : TObjectList;
  positionIndex : Integer;
begin
  for I := 0 to _infos.Count-1 do begin
    info := TAddressInfo(_infos[i]);

    info.Orders := TDBMapping.GetCurrentOrderHeadsByAddress(DM.MainConnection, info.Address);

    for orderIndex := 0 to info.Orders.Count-1 do begin
      order := TCurrentOrderHead(info.Orders[orderIndex]);

      offers := TDBMapping.GetOffersByPriceAndProductId(
        DM.MainConnection,
        order.PriceCode,
        order.RegionCode,
        //order.OrderItems.Select(item => item.ProductId).ToArray()
        order.GetProductIds());

      try
        order.RestoreOrderItems(offers);

        if offers.Count = 0 then begin
          WriteExchangeLog('¬осстановление заказа', '«аказ ' + order.ToString() + 'был заморожен, т.к. прайс-лист отсутствует');
          order.ErrorReason := '«аказ был заморожен, т.к. прайс-лист отсутствует';
          DM.adcUpdate.SQL.Text := ''
      +' update '
      +'   CurrentOrderHeads '
      +'  set '
      +'     CurrentOrderHeads.Frozen = 1, '
      +'     CurrentOrderHeads.ErrorReason = "' + order.ErrorReason +'" '
      +'   where CurrentOrderHeads.OrderId = :OrderId';
          DM.adcUpdate.ParamByName('OrderId').Value := order.OrderId;
          DM.adcUpdate.Execute;
        end;

      finally
        offers.Free;
      end;

      for positionIndex := 0 to order.OrderItems.Count-1 do
        TDBMapping.SaveOrderItem(
          DM.MainConnection,
          TCurrentOrderItem(order.OrderItems[positionIndex]));
    end;
  end;
end;

{ TAddressInfo }

function TAddressInfo.CorrectionExists: Boolean;
var
  I : Integer;
begin
  Result := False;
  for I := 0 to Orders.Count-1 do
    if TCurrentOrderHead(Orders[i]).CorrectionExists then begin
      Result := True;
      Exit;
    end
end;

constructor TAddressInfo.Create(aAddress: TAddress);
begin
  Address := aAddress;
  Orders := nil;
end;

destructor TAddressInfo.Destroy;
begin
  if Assigned(Address) then
    FreeAndNil(Address);
  if Assigned(Orders) then
    FreeAndNil(Orders);
  inherited;
end;

end.
