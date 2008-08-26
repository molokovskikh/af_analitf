/* Alter Procedure... */
/* Alter (ORDERSHSHOW) */
ALTER PROCEDURE ORDERSHSHOW(ACLIENTID BIGINT,
ACLOSED INTEGER,
TIMEZONEBIAS INTEGER)
 RETURNS(ORDERID BIGINT,
SERVERORDERID BIGINT,
DATEPRICE TIMESTAMP,
PRICECODE BIGINT,
REGIONCODE BIGINT,
ORDERDATE TIMESTAMP,
SENDDATE TIMESTAMP,
CLOSED INTEGER,
SEND INTEGER,
PRICENAME VARCHAR(70),
REGIONNAME VARCHAR(25),
POSITIONS INTEGER,
SUPPORTPHONE VARCHAR(20),
MESSAGETO BLOB SUB_TYPE 1,
COMMENTS BLOB SUB_TYPE 1,
MINREQ INTEGER,
SUMBYCURRENTMONTH NUMERIC(18,2))
 AS
begin
for SELECT
    OrdersH.OrderId,
    OrdersH.ServerOrderId,
    addminute(PricesData.DatePrice, -:timezonebias) AS DatePrice,
    OrdersH.PriceCode,
    OrdersH.RegionCode,
    OrdersH.OrderDate,
    OrdersH.SendDate,
    OrdersH.Closed,
    OrdersH.Send,
    OrdersH.PriceName,
    OrdersH.RegionName,
    RegionalData.SupportPhone,
    OrdersH.MessageTo,
    OrdersH.Comments,
    pricesregionaldata.minreq
FROM
   ((OrdersH
    LEFT JOIN PricesData ON OrdersH.PriceCode=PricesData.PriceCode)
    left join pricesregionaldata on pricesregionaldata.PriceCode = OrdersH.PriceCode and pricesregionaldata.regioncode = OrdersH.regioncode)
    LEFT JOIN RegionalData ON (RegionalData.RegionCode=OrdersH.RegionCode) AND (PricesData.FirmCode=RegionalData.FirmCode)
WHERE
    (OrdersH.ClientId = :AClientId)
and (:AClosed = OrdersH.Closed)
and ((:AClosed = 1) or ((:AClosed = 0) and (PricesData.PriceCode is not null) and (RegionalData.RegionCode is not null) and (pricesregionaldata.PriceCode is not null)))
into :OrderId,
    :ServerOrderId,
    :DatePrice,
    :PriceCode,
    :RegionCode,
    :OrderDate,
    :SendDate,
    :Closed,
    :Send,
    :PriceName,
    :RegionName,
    :SupportPhone,
    :MessageTo,
    :Comments,
    :MinReq
do
begin
  SELECT
    Count(*)
  FROM
    Orders
  WHERE
        Orders.OrderId=:OrderId
    AND Orders.OrderCount>0
  into :Positions;
  if (AClosed = 0) then
  begin
    select
      Sum(Orders.SendPrice * Orders.OrderCount)
    from
      OrdersH
      INNER JOIN Orders ON Orders.OrderId=OrdersH.OrderId
    WHERE OrdersH.ClientId=:AClientId
       AND OrdersH.PriceCode=:PriceCode
       AND OrdersH.RegionCode=:RegionCode
       and ordersh.senddate > addday(current_date, 1-extract(day from current_date))
       AND OrdersH.Closed = 1
       AND OrdersH.send = 1
       AND Orders.OrderCount>0
    into :sumbycurrentmonth;
  end
  else
    SUMBYCURRENTMONTH = 0;
  if (positions > 0) then
    suspend;
end
end
;

/* Alter (PRICESSHOW) */
ALTER PROCEDURE PRICESSHOW(ACLIENTID BIGINT,
TIMEZONEBIAS INTEGER)
 RETURNS(PRICECODE BIGINT,
PRICENAME VARCHAR(70),
DATEPRICE TIMESTAMP,
MINREQ INTEGER,
ENABLED INTEGER,
PRICEINFO BLOB SUB_TYPE 1,
FIRMCODE BIGINT,
FULLNAME VARCHAR(40),
STORAGE INTEGER,
ADMINMAIL VARCHAR(50),
SUPPORTPHONE VARCHAR(20),
CONTACTINFO BLOB SUB_TYPE 1,
OPERATIVEINFO BLOB SUB_TYPE 1,
REGIONCODE BIGINT,
REGIONNAME VARCHAR(25),
POSITIONS INTEGER,
PRICESIZE INTEGER,
INJOB INTEGER,
CONTROLMINREQ INTEGER,
SUMBYCURRENTMONTH NUMERIC(18,2))
 AS
begin
for SELECT PD.PriceCode,
    PriceName,
    addminute(PD.DatePrice, -:TimeZoneBias) AS DatePrice,
    PRD.MinReq,
    Enabled,
    PriceInfo,
    CD.FirmCode,
    CD.FullName,
    Storage,
    AdminMail,
    SupportPhone,
    ContactInfo,
    OperativeInfo,
    R.RegionCode,
    RegionName,
    prd.pricesize,
    prd.INJOB,
    prd.CONTROLMINREQ
FROM (((PricesData PD INNER JOIN PricesRegionalData PRD ON PD.pricecode=PRD.pricecode)
    INNER JOIN Regions R ON PRD.RegionCode=R.RegionCode)
    INNER JOIN ClientsDataN CD ON CD.FirmCode=PD.FirmCode)
    INNER JOIN RegionalData RD ON (RD.RegionCode=PRD.RegionCode) AND (RD.FirmCode=CD.FirmCode)
WHERE
    PD.AllowIntegr <> 1 OR
    PD.PriceFileDate IS NOT NULL
into :PriceCode,
    :PriceName,
    :DatePrice,
    :MinReq,
    :Enabled,
    :PriceInfo,
    :FirmCode,
    :FullName,
    :Storage,
    :AdminMail,
    :SupportPhone,
    :ContactInfo,
    :OperativeInfo,
    :RegionCode,
    :RegionName,
    :pricesize,
    :injob,
    :CONTROLMINREQ
do
begin
  SELECT
    Count(*)
  FROM
    OrdersH
    INNER JOIN Orders ON Orders.OrderId=OrdersH.OrderId
  WHERE OrdersH.ClientId=:AClientId
     AND OrdersH.PriceCode=:PriceCode
     AND OrdersH.RegionCode=:RegionCode
     AND OrdersH.Closed <> 1
     AND Orders.OrderCount>0
  into :Positions;
  select
    Sum(Orders.SendPrice * Orders.OrderCount)
  from
    OrdersH
    INNER JOIN Orders ON Orders.OrderId=OrdersH.OrderId
  WHERE OrdersH.ClientId=:AClientId
     AND OrdersH.PriceCode=:PriceCode
     AND OrdersH.RegionCode=:RegionCode
     and ordersh.senddate > addday(current_date, 1-extract(day from current_date))
     AND OrdersH.Closed = 1
     AND OrdersH.send = 1
     AND Orders.OrderCount>0
  into :sumbycurrentmonth;
  suspend;
end
end
;

update PROVIDER set mdbversion = 49 where id = 0;

commit work;