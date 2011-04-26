unit DayOfWeekDelaysController;

interface

uses
  SysUtils, Classes, Contnrs, DB, StrUtils, Variants,
  DateUtils,
  //App modules
  Constant, DModule, ExchangeParameters, U_ExchangeLog,
  InternalRepareOrdersController,
  DayOfWeekHelper,
  GlobalSettingParams;

type
  TDayOfWeekDelaysController = class
   protected
    class procedure UpdateMinPrices;
    class procedure RecalcOrders;
    class procedure InternalExecute;
   public
    class function NeedUpdateDelays(dataLayer : TDM) : Boolean;
    class procedure UpdateDayOfWeek(dataLayer : TDM);
    class procedure RecalcOrdersByDelays();
  end;

implementation

{ TDayOfWeekDelaysController }

class procedure TDayOfWeekDelaysController.InternalExecute;
begin
  DM.adcUpdate.Execute;
end;

class function TDayOfWeekDelaysController.NeedUpdateDelays(
  dataLayer: TDM): Boolean;
var
  val : Variant;
  orderCount : Int64;
  settings : TGlobalSettingParams;
begin
  Result := False;
  if not dataLayer.adtClients.IsEmpty
    and dataLayer.adtClientsAllowDelayOfPayment.Value
    and not dataLayer.adtParams.FieldByName( 'UpdateDateTime').IsNull
    and (Date() > dataLayer.adtParams.FieldByName( 'UpdateDateTime').AsDateTime)
  then begin
    val := dataLayer.QueryValue('select count(*) from CurrentOrderHeads', [], []);
    if VarIsNull(val) then
      orderCount := 0
    else
      orderCount := val;

    if orderCount > 0 then begin
      settings := TGlobalSettingParams.Create(dataLayer.MainConnection);
      try
        Result := TDayOfWeekHelper.AnotherDay(settings.LastDayOfWeek);
      finally
        settings.Free;
      end;
    end;
  end;
end;

class procedure TDayOfWeekDelaysController.RecalcOrders;
var
  t : TInternalRepareOrders;
begin
  t := TInternalRepareOrders.Create;
  try
    t.ProcessSendOrdersResponse := False;
    t.RestoreAfterOpen := True;
    t.RepareOrders;
  finally
    t.Free;
  end;

end;

class procedure TDayOfWeekDelaysController.RecalcOrdersByDelays;
begin
  UpdateMinPrices();
  RecalcOrders;
end;

class procedure TDayOfWeekDelaysController.UpdateDayOfWeek(
  dataLayer: TDM);
var
  settings : TGlobalSettingParams;
begin
  settings := TGlobalSettingParams.Create(dataLayer.MainConnection);
  try
    settings.LastDayOfWeek := TDayOfWeekHelper.DayOfWeek();
    settings.SaveParams();
  finally
    settings.Free;
  end;
end;

class procedure TDayOfWeekDelaysController.UpdateMinPrices;
var
  MainClientIdAllowDelayOfPayment : Variant;
begin
  with DM.adcUpdate do begin
    //Обновление ServerCoreID в MinPrices
    SQL.Text:='truncate minprices ;';
    InternalExecute;

    //Пытаем получить код "основного" клиента
    //Если не null, то для основного клиента включен механизм отсрочек
    MainClientIdAllowDelayOfPayment := DM.QueryValue(''
      +'select Clients.ClientId '
      +'from   Clients, '
      +'       Userinfo '
      +'where  (Clients.CLIENTID = Userinfo.ClientId) '
      +'   and (Clients.AllowDelayOfPayment = 1)',
      [],
      []);
    SQL.Text := ''
      + 'drop temporary table if exists MinPricesNext;'
      + 'create temporary table MinPricesNext ('
      +'   `PRODUCTID` bigint(20) not null default ''0''   , '
      +'   `REGIONCODE` bigint(20) not null default ''0''  , '
      +'   `NextCost` decimal(18,2) default null           , '
      +'   `MinCostCount` int default ''0''                , '
      +'   primary key (`PRODUCTID`,`REGIONCODE`)            '
      + ') engine=Memory;';
    InternalExecute;
    if VarIsNull(MainClientIdAllowDelayOfPayment) then begin
      SQL.Text := ''
        + 'INSERT IGNORE '
        + 'INTO    MinPrices '
        + '(ProductId, RegionCode, MinCost) '
        + 'SELECT '
        + '  ProductId, '
        + '  RegionCode, '
        + '  min(if(Junk = 0, Cost, null)) '
        + 'FROM    Core '
        + 'GROUP BY ProductId, RegionCode';
      InternalExecute;
      SQL.Text := ''
        + 'insert ignore into MinPricesNext (ProductId, RegionCode, NextCost, MinCostCount) '
        + ' SELECT '
        + '   Core.ProductId, '
        + '   Core.RegionCode, '
        + '   min(nullif(Core.Cost, MinPrices.MinCost)) as NextCost, '
        + '   sum(Core.Cost = MinPrices.MinCost) as MinCostCount '
        + ' FROM '
        + '    MinPrices '
        + '    inner join Core on Core.ProductId = MinPrices.ProductId and Core.RegionCode = MinPrices.RegionCode and Core.Junk = 0 '
        + ' where '
        + '   MinPrices.MinCost is not null '
        + ' GROUP BY MinPrices.ProductId, MinPrices.RegionCode';
      InternalExecute;
    end
    else begin
      SQL.Text := ''
        + 'INSERT IGNORE '
        + 'INTO    MinPrices '
        + '(ProductId, RegionCode, MinCost) '
        +'select   Core.ProductId , '
        +'         Core.RegionCode, '
        +'         min( '
        +'             if(Junk <> 0, '
        +'                  null,'
        +'                  if(Delayofpayments.DayOfWeek is null, '
        +'                      Cost, '
        +'                      if(Core.VitallyImportant || ifnull(catalogs.VitallyImportant, 0), '
        +'                          Cost * (1 + Delayofpayments.VitallyImportantDelay/100), '
        +'                          Cost * (1 + Delayofpayments.OtherDelay/100) '
        +'                       ) '
        +'                  ) '
        +'             ) '
        +'         ) '
        +'from     Core       '
        +'         inner join Pricesdata on Pricesdata.PRICECODE = Core.Pricecode '
        +'         left join products on products.ProductId = Core.ProductId '
        +'         left join catalogs on catalogs.FullCode = products.CatalogId '
        +'         left join Delayofpayments '
        +'           on (Delayofpayments.FirmCode = pricesdata.Firmcode) and '
        +'              (Delayofpayments.DayOfWeek = "' + TDayOfWeekHelper.DayOfWeek() + '") '
        +'group by Core.ProductId, '
        +'         Core.RegionCode';
      InternalExecute;
      SQL.Text := ''
        + 'insert ignore into MinPricesNext (ProductId, RegionCode, NextCost, MinCostCount) '
        + ' SELECT '
        + '   Core.ProductId, '
        + '   Core.RegionCode, '
        + '   min('
        + '        nullif('
        + '               cast( '
        + '                  if(Delayofpayments.DayOfWeek is null, '
        + '                      Cost, '
        + '                      if(Core.VitallyImportant || ifnull(catalogs.VitallyImportant, 0), '
        + '                          Cost * (1 + Delayofpayments.VitallyImportantDelay/100), '
        + '                          Cost * (1 + Delayofpayments.OtherDelay/100) '
        + '                       ) '
        + '                  ) '
        + '               as decimal(18, 2)) '
        + '               , MinPrices.MinCost)'
        + '   ) as NextCost, '
        + '   sum( '
        + '       cast( '
        + '                  if(Delayofpayments.DayOfWeek is null, '
        + '                      Cost, '
        + '                      if(Core.VitallyImportant || ifnull(catalogs.VitallyImportant, 0), '
        + '                          Cost * (1 + Delayofpayments.VitallyImportantDelay/100), '
        + '                          Cost * (1 + Delayofpayments.OtherDelay/100) '
        + '                       ) '
        + '                  ) '
        + '       as decimal(18, 2)) '
        + '       = '
        + '       MinPrices.MinCost'
        + '   ) as MinCostCount '
        + ' FROM '
        + '    MinPrices '
        + '    inner join Core on Core.ProductId = MinPrices.ProductId and Core.RegionCode = MinPrices.RegionCode and Core.Junk = 0 '
        + '    inner join Pricesdata on Pricesdata.PRICECODE     = Core.Pricecode '
        + '    left join products on products.ProductId = Core.ProductId '
        + '    left join catalogs on catalogs.FullCode = products.CatalogId '
        + '    left join Delayofpayments '
        + '      on (Delayofpayments.FirmCode = pricesdata.Firmcode)  and '
        + '              (Delayofpayments.DayOfWeek = "' + TDayOfWeekHelper.DayOfWeek() + '") '
        + ' where '
        + '   MinPrices.MinCost is not null '
        + ' GROUP BY MinPrices.ProductId, MinPrices.RegionCode';
      InternalExecute;
    end;

    SQL.Text := ''
      + ' update '
      + '   MinPrices '
      + '   left join MinPricesNext on MinPricesNext.ProductId = MinPrices.ProductId and MinPricesNext.RegionCode = MinPrices.RegionCode '
      + ' set '
      + '   MinPrices.NextCost = MinPricesNext.NextCost, '
      + '   MinPrices.Percent = if(MinPricesNext.NextCost is not null and MinPrices.MinCost is not null, (MinPricesNext.NextCost / MinPrices.MinCost - 1) * 100, null), '
      + '   MinPrices.MinCostcount = MinPricesNext.MinCostCount; ';
    InternalExecute;

    SQL.Text := 'drop temporary table if exists MinPricesNext';
    InternalExecute;

    //Пытаем получить код "основного" клиента
    //Если не null, то для основного клиента включен механизм отсрочек
    MainClientIdAllowDelayOfPayment := DM.QueryValue(''
      +'select Clients.ClientId '
      +'from   Clients, '
      +'       Userinfo '
      +'where  (Clients.CLIENTID = Userinfo.ClientId) '
      +'   and (Clients.AllowDelayOfPayment = 1)',
      [],
      []);
    if VarIsNull(MainClientIdAllowDelayOfPayment) then begin
      SQL.Text := ''
        + 'UPDATE '
        + '  MinPrices, '
        + '  Core '
        + 'SET '
        + '  MinPrices.SERVERCOREID = Core.ServerCoreId, '
        + '  MinPrices.PriceCode  = Core.PriceCode '
        + 'WHERE '
        + '    Core.ProductId  = MinPrices.ProductId '
        + 'and Core.RegionCode = MinPrices.RegionCode '
        + 'and Core.Cost       = MinPrices.MinCost';
      InternalExecute;
    end
    else begin
      SQL.Text := ''
        + 'UPDATE '
        + '  MinPrices '
        + '  inner join Core on Core.ProductId = MinPrices.ProductId and Core.RegionCode = MinPrices.RegionCode '
        + '  inner join Pricesdata on Pricesdata.PRICECODE = Core.Pricecode '
        + '  left join products on products.ProductId = Core.ProductId '
        + '  left join catalogs on catalogs.FullCode = products.CatalogId '
        + '  left join Delayofpayments '
        + '    on (Delayofpayments.FirmCode = pricesdata.Firmcode) and '
        + '              (Delayofpayments.DayOfWeek = "' + TDayOfWeekHelper.DayOfWeek() + '") '
        + 'SET '
        + '  MinPrices.SERVERCOREID = Core.ServerCoreId, '
        + '  MinPrices.PriceCode  = Core.PriceCode '
        + 'WHERE '
        + '    ('
        + '       cast( '
        + '                  if(Delayofpayments.DayOfWeek is null, '
        + '                      Cost, '
        + '                      if(Core.VitallyImportant || ifnull(catalogs.VitallyImportant, 0), '
        + '                          Cost * (1 + Delayofpayments.VitallyImportantDelay/100), '
        + '                          Cost * (1 + Delayofpayments.OtherDelay/100) '
        + '                       ) '
        + '                  ) '
        + '       as decimal(18, 2)) '
        + '      = '
        + '      MinPrices.MinCost'
        +'     )';
      InternalExecute;
    end;
    
  end;
end;

end.
