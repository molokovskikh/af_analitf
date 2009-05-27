CREATE VIEW CLIENTAVG(
    CLIENTCODE,
    PRODUCTID,
    PRICEAVG)
AS
select
  ordersh.clientid as clientcode,
  orders.productid,
  avg(orders.sendprice)
from
  ordersh,
  orders
where
    (orders.orderid = ordersh.orderid)
and (ordersh.orderdate >= current_date() - interval 1 month)
and (ordersh.closed = 1)
and (ordersh.send = 1)
and (orders.ordercount > 0)
and (orders.sendprice is not null)
group by ordersh.clientid, orders.productid;


delimiter $$

create definer = 'root'@'localhost'
procedure analitf.CATALOGSHOWBYFORM(in ashortcode bigint, in showall tinyint(1))
begin
  if (showall = 1) then
    select CATALOGS.FullCode, CATALOGS.Form, catalogs.coreexists
    from CATALOGS
    where CATALOGS.ShortCode = AShortCode
    order by CATALOGS.Form;
  else
    select CATALOGS.FullCode, CATALOGS.Form, catalogs.coreexists
    from CATALOGS
    where CATALOGS.ShortCode= AShortCode
      and catalogs.coreexists = 1
    order by CATALOGS.Form;
  end if;
end
$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.CATALOGSHOWBYNAME(showall tinyint(1))
BEGIN
  if (showall = 1) then
      SELECT
        CATALOGS.ShortCode AS AShortCode, CATALOGS.Name, sum(CoreExists) as CoreExists
      FROM CATALOGS cat
      group by CATALOGS.ShortCode, CATALOGS.Name
      ORDER BY CATALOGS.Name;
  else
      SELECT
        CATALOGS.ShortCode AS AShortCode, CATALOGS.Name, sum(CoreExists) as CoreExists
      FROM CATALOGS cat
      where
        CoreExists = 1
      group by CATALOGS.ShortCode, CATALOGS.Name
      ORDER BY CATALOGS.Name;
  end if;
END
$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.CORECOUNTPRICEFIELDS(aregioncode bigint, apricecode bigint)
BEGIN
SELECT Count(*) AS CCount,
    Count(nullif(code, '')) AS Code,
    Count(SynonymFirmCrCode) AS SynonymFirm,
    Count(nullif(Volume, '')) AS Volume,
    Count(nullif(Doc, '')) AS Doc,
    Count(nullif(Note, '')) AS Note,
    Count(nullif(Period, '')) AS Period,
    Count(nullif(Quantity, '')) AS Quantity
FROM Core
WHERE PriceCode = APriceCode AND RegionCode = ARegionCode;
END
$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.CORESHOWBYFIRM(IN apricecode BIGINT, IN aregioncode BIGINT, IN aclientid BIGINT)
BEGIN
SELECT
    CCore.CoreId AS CoreId,
    CCore.productid,
    catalogs.FullCode,
    catalogs.shortcode,
    CCore.CodeFirmCr,
    CCore.SynonymCode,
    CCore.SynonymFirmCrCode,
    CCore.Code,
    CCore.CodeCr,
    CCore.Volume,
    CCore.Doc,
    CCore.Note,
    CCore.Period,
    CCore.Await,
    CCore.Junk,
    CCore.BaseCost,
    CCore.Quantity,
    ifnull(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    PricesData.PriceCode AS LeaderPriceCode,
    MinPrices.RegionCode AS LeaderRegionCode,
    Regions.RegionName AS LeaderRegionName,
    PricesData.PriceName AS LeaderPriceName,
    LCore.code as LeaderCODE,
    LCore.codecr as LeaderCODECR,
    LCore.basecost as LeaderPRICE,
    osbc.CoreId AS OrdersCoreId,
    osbc.OrderId AS OrdersOrderId,
    osbc.ClientId AS OrdersClientId,
    catalogs.FullCode AS OrdersFullCode,
    osbc.CodeFirmCr AS OrdersCodeFirmCr,
    osbc.SynonymCode AS OrdersSynonymCode,
    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,
    osbc.Code AS OrdersCode,
    osbc.CodeCr AS OrdersCodeCr,
    osbc.OrderCount,
    osbc.SynonymName AS OrdersSynonym,
    osbc.SynonymFirm AS OrdersSynonymFirm,
    osbc.Price AS OrdersPrice,
    osbc.Junk AS OrdersJunk,
    osbc.Await AS OrdersAwait,
    OrdersH.OrderId AS OrdersHOrderId,
    OrdersH.ClientId AS OrdersHClientId,
    OrdersH.PriceCode AS OrdersHPriceCode,
    OrdersH.RegionCode AS OrdersHRegionCode,
    OrdersH.PriceName AS OrdersHPriceName,
    OrdersH.RegionName AS OrdersHRegionName,
    CCore.registrycost,
    CCore.vitallyimportant,
    CCore.requestratio,
    CCore.ordercost,
    CCore.minordercount
FROM
    Core CCore
    inner join products on products.productid = CCore.productid
    inner join catalogs      on catalogs.fullcode = products.catalogid
    inner JOIN MinPrices     ON MinPrices.productid = CCore.productid and minprices.regioncode = CCore.regioncode
    left join Core LCore on LCore.servercoreid = minprices.servercoreid and LCore.RegionCode = minprices.regioncode
    left JOIN PricesData ON PricesData.PriceCode=LCore.pricecode
    left JOIN Regions       ON Regions.RegionCode = MinPrices.RegionCode
    left JOIN SynonymFirmCr ON SynonymFirmCr.SynonymFirmCrCode = CCore.SynonymFirmCrCode
    left join synonyms on Synonyms.SynonymCode = CCore.SynonymCode
    left JOIN Orders osbc ON osbc.ClientID = AClientId and osbc.CoreId = CCore.CoreId
    left JOIN OrdersH ON OrdersH.OrderId = osbc.OrderId
WHERE (CCore.PriceCode = APriceCode) And (CCore.RegionCode = ARegionCode);
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.CORESHOWBYFORM(
    aclientid bigint,
    timezonebias integer,
    parentcode bigint,
    showregister tinyint(1),
    registerid bigint)
BEGIN
SELECT Core.CoreId,
    Core.PriceCode,
    Core.RegionCode,
    Core.productid,
    catalogs.fullcode AS AFullCode,
    catalogs.shortcode,
    Core.CodeFirmCr,
    Core.SynonymCode,
    Core.SynonymFirmCrCode,
    Core.Code,
    Core.CodeCr,
    Core.Period,
    0 AS Sale,
    Core.Volume,
    Core.Note,
    Core.BaseCost,
    Core.Quantity,
    Core.Await,
    Core.Junk,
    ifnull(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    if(PricesData.DatePrice IS NOT NULL, PricesData.DatePrice + interval -timezonebias minute, null) AS DatePrice,
    PricesData.PriceName,
    Enabled AS PriceEnabled,
    ClientsDataN.FirmCode AS FirmCode,
    Storage,
    Regions.RegionName,
    osbc.CoreId AS OrdersCoreId,
    osbc.OrderId AS OrdersOrderId,
    osbc.ClientId AS OrdersClientId,
    catalogs.fullcode AS OrdersFullCode,
    osbc.CodeFirmCr AS OrdersCodeFirmCr,
    osbc.SynonymCode AS OrdersSynonymCode,
    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,
    osbc.Code AS OrdersCode,
    osbc.CodeCr AS OrdersCodeCr,
    osbc.OrderCount,
    osbc.SynonymName AS OrdersSynonym,
    osbc.SynonymFirm AS OrdersSynonymFirm,
    osbc.Price AS OrdersPrice,
    osbc.Junk AS OrdersJunk,
    osbc.Await AS OrdersAwait,
    OrdersH.OrderId AS OrdersHOrderId,
    OrdersH.ClientId AS OrdersHClientId,
    OrdersH.PriceCode AS OrdersHPriceCode,
    OrdersH.RegionCode AS OrdersHRegionCode,
    OrdersH.PriceName AS OrdersHPriceName,
    OrdersH.RegionName AS OrdersHRegionName,
    Core.doc,
    Core.registrycost,
    Core.vitallyimportant,
    Core.requestratio,
    core.ordercost,
    core.minordercount
FROM
    Catalogs
    inner join products on products.catalogid = catalogs.fullcode
    left JOIN Core ON Core.productid = products.productid
    left join Synonyms on Core.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
    LEFT JOIN PricesData ON Core.PriceCode=PricesData.PriceCode
    LEFT JOIN PricesRegionalData PRD ON (Core.RegionCode=PRD.RegionCode)
        AND (Core.PriceCode=PRD.PriceCode)
    LEFT JOIN ClientsDataN ON PricesData.FirmCode=ClientsDataN.FirmCode
    LEFT JOIN Regions ON Core.RegionCode=Regions.RegionCode
    LEFT JOIN Orders osbc ON osbc.clientid = aclientid and osbc.CoreId = Core.CoreId
    LEFT JOIN OrdersH ON OrdersH.OrderId = osbc.OrderId
WHERE (Catalogs.FullCode = ParentCode)
and (Core.coreid is not null)
And ((ShowRegister = 1) Or (ClientsDataN.FirmCode <> RegisterId));
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.CORESHOWBYNAME(
    aclient bigint,
    timezonebias integer,
    parentcode bigint,
    showregister tinyint(1),
    registerid bigint)
BEGIN
SELECT Core.CoreId,
    Core.PriceCode,
    Core.RegionCode,
    Core.productid, 
    catalogs.fullcode AS AFullCode,
    Catalogs.ShortCode,
    Core.CodeFirmCr,
    Core.SynonymCode,
    Core.SynonymFirmCrCode,
    Core.Code,
    Core.CodeCr,
    Core.Period,
    0 AS Sale,
    Core.Volume,
    Core.Note,
    Core.BaseCost,
    Core.Quantity,
    Core.Await,
    Core.Junk,
    ifnull(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    if(PricesData.DatePrice IS NOT NULL, PricesData.DatePrice + interval -timezonebias minute, null) AS DatePrice,
    PricesData.PriceName,
    Enabled AS PriceEnabled,
    ClientsDataN.FirmCode AS FirmCode,
    Storage,
    Regions.RegionName,
    osbc.CoreId AS OrdersCoreId,
    osbc.OrderId AS OrdersOrderId,
    osbc.ClientId AS OrdersClientId,
    catalogs.fullcode AS OrdersFullCode,
    osbc.CodeFirmCr AS OrdersCodeFirmCr,
    osbc.SynonymCode AS OrdersSynonymCode,
    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,
    osbc.Code AS OrdersCode,
    osbc.CodeCr AS OrdersCodeCr,
    osbc.OrderCount,
    osbc.SynonymName AS OrdersSynonym,
    osbc.SynonymFirm AS OrdersSynonymFirm,
    osbc.Price AS OrdersPrice,
    osbc.Junk AS OrdersJunk,
    osbc.Await AS OrdersAwait,
    OrdersH.OrderId AS OrdersHOrderId,
    OrdersH.ClientId AS OrdersHClientId,
    OrdersH.PriceCode AS OrdersHPriceCode,
    OrdersH.RegionCode AS OrdersHRegionCode,
    OrdersH.PriceName AS OrdersHPriceName,
    OrdersH.RegionName AS OrdersHRegionName,
    Core.doc,
    Core.registrycost,
    Core.vitallyimportant,
    Core.requestratio,
    core.ordercost,
    core.minordercount
FROM
    Catalogs
    inner join products on products.catalogid = catalogs.fullcode
    left JOIN Core ON Core.productid = products.productid
    LEFT JOIN Synonyms ON Core.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
    LEFT JOIN PricesData ON Core.PriceCode=PricesData.PriceCode
    LEFT JOIN PricesRegionalData PRD ON (Core.RegionCode=PRD.RegionCode)
        AND (Core.PriceCode=PRD.PriceCode)
    LEFT JOIN ClientsDataN ON PricesData.FirmCode=ClientsDataN.FirmCode
    LEFT JOIN Regions ON Core.RegionCode=Regions.RegionCode
    LEFT JOIN Orders osbc ON osbc.clientid = aclient and osbc.CoreId = Core.CoreId
    LEFT JOIN OrdersH ON OrdersH.OrderId = osbc.OrderId
WHERE (Catalogs.ShortCode = ParentCode)
and (Core.coreid is not null)
And ((ShowRegister = 1) Or (ClientsDataN.FirmCode <> RegisterId));
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.EXPIREDSSHOW(
    timezonebias integer,
    aclientid bigint,
    acoreid bigint)
BEGIN
SELECT Core.CoreId,
    Core.PriceCode,
    Core.RegionCode,
    Core.productid,
    catalogs.fullcode,
    Core.CodeFirmCr,
    Core.SynonymCode,
    Core.SynonymFirmCrCode,
    Core.Code,
    Core.CodeCr,
    Core.Note,
    Core.Period,
    Core.Volume,
    Core.BaseCost,
    Core.Quantity,
    ifnull(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    Core.Await,
    PricesData.PriceName,
    PricesData.DatePrice + interval  -TimeZoneBias minute AS DatePrice,
    Regions.RegionName,
    osbc.CoreId AS OrdersCoreId,
    osbc.OrderId AS OrdersOrderId,
    osbc.ClientId AS OrdersClientId,
    catalogs.fullcode AS OrdersFullCode,
    osbc.CodeFirmCr AS OrdersCodeFirmCr,
    osbc.SynonymCode AS OrdersSynonymCode,
    osbc.SynonymFirmCrCode AS OrdersSynonymFirmCrCode,
    osbc.Code AS OrdersCode,
    osbc.CodeCr AS OrdersCodeCr,
    osbc.SynonymName AS OrdersSynonym,
    osbc.SynonymFirm AS OrdersSynonymFirm,
    osbc.OrderCount,
    osbc.Price AS OrdersPrice,
    osbc.Junk AS OrdersJunk,
    osbc.Await AS OrdersAwait,
    OrdersH.OrderId AS OrdersHOrderId,
    OrdersH.ClientId AS OrdersHClientId,
    OrdersH.PriceCode AS OrdersHPriceCode,
    OrdersH.RegionCode AS OrdersHRegionCode,
    OrdersH.PriceName AS OrdersHPriceName,
    OrdersH.RegionName AS OrdersHRegionName,
    Core.doc,
    Core.registrycost,
    Core.vitallyimportant,
    Core.requestratio,
    Core.ordercost,
    Core.minordercount
FROM
    Core
    left JOIN PricesData ON Core.PriceCode=PricesData.PriceCode
    left JOIN Regions ON Core.RegionCode=Regions.RegionCode
    left join products on products.productid = core.productid
    left join catalogs on catalogs.fullcode = products.catalogid
    left JOIN Synonyms ON Core.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
    LEFT JOIN Orders osbc ON osbc.clientid = AClientId and osbc.CoreId=Core.CoreId
    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId
WHERE
    (Core.productid > 0)
and (Core.Junk = 1)
and (((ACoreID is not null) and (Core.coreid = ACoreID)) or (ACoreID is null));
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.GETABSENTPRICECODE()
BEGIN
    select distinct c.Pricecode
    from
      core c
      left join synonyms s on s.synonymcode = c.synonymcode
      left join synonymfirmcr sfc on sfc.synonymfirmcrcode = c.synonymfirmcrcode
    where
           c.synonymcode > 0
       and ((s.synonymcode is null) or (sfc.synonymfirmcrcode is null));
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.ORDERSHSHOW(
    aclientid bigint,
    aclosed integer,
    timezonebias integer)
BEGIN
-- todo: здесь надо переписать
SELECT
    OrdersH.OrderId,
    OrdersH.ServerOrderId,
    PricesData.DatePrice - interval timezonebias minute AS DatePrice,
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
    (OrdersH.ClientId = AClientId)
and (AClosed = OrdersH.Closed)
and ((AClosed = 1) or ((AClosed = 0) and (PricesData.PriceCode is not null) and (RegionalData.RegionCode is not null) and (pricesregionaldata.PriceCode is not null)));
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.ORDERSHSHOWCURRENT(
    aclientid bigint,
    apricecode bigint,
    aregioncode bigint)
BEGIN
SELECT ORDERID,
    SERVERORDERID,
    CLIENTID,
    PRICECODE,
    REGIONCODE,
    PriceName,
    RegionName,
    OrderDate,
    SendDate,
    Closed,
    Send,
    Comments,
    MessageTo
FROM OrdersH
WHERE ClientId = AClientId
AND PriceCode = APriceCode
AND RegionCode = ARegionCode
AND Closed  <> 1;
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.ORDERSHSHOWSINGLE(aorderid bigint)
BEGIN
SELECT OrdersH.OrderId,
        OrdersH.Comments,
        OrdersH.PriceName,
        OrdersH.RegionName
FROM OrdersH
WHERE OrdersH.OrderId = AOrderId;
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.ORDERSINFOMAIN(aclientid bigint)
BEGIN
SELECT
    count(distinct OrdersH.orderid) as OrdersCount,
    Count(osbc.id) AS Positions,
    Sum (osbc.OrderCount * 0) AS SumOrder
FROM
    OrdersH
    INNER JOIN Orders osbc ON osbc.clientid = AClientID and OrdersH.orderid=osbc.OrderId
    INNER JOIN PricesRegionalData PRD ON (PRD.RegionCode=OrdersH.RegionCode AND (PRD.PriceCode=OrdersH.PriceCode))
    LEFT JOIN PricesData ON PricesData.PriceCode=PRD.PriceCode
WHERE OrdersH.Closed <> 1
    AND (osbc.OrderCount>0);
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.ORDERSSHOWBYFORM(
    afullcode bigint,
    aclientid bigint)
BEGIN
SELECT 
    products.catalogid as FullCode,
    Code,
    CodeCR,
    SynonymName,
    SynonymFirm,
    OrderCount,
    Price,
    OrdersH.OrderDate,
    OrdersH.PriceName,
    OrdersH.RegionName,
    Await,
    Junk,
    orders.sendprice
FROM
  Orders osbc
  inner join products on products.productid = osbc.productid
  INNER JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId
WHERE
    (osbc.clientid = AClientID)
and (osbc.OrderCount > 0)
and (products.catalogid = AFullCode)
And ((OrdersH.Closed = 1) Or (OrdersH.Closed Is Null))
ORDER BY OrdersH.OrderDate DESC
limit 20;
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.PRICESSHOW(
    aclientid bigint,
    timezonebias integer)
BEGIN
-- todo: здесь надо дописать
SELECT PD.PriceCode,
    PriceName,
    PD.DatePrice - interval TimeZoneBias minute AS DatePrice,
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
    PD.PriceFileDate IS NOT NULL;
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.SUMMARYHSHOW(aclientid bigint)
BEGIN
SELECT Count(*) AS CountOrder,
    Sum(0 * Orders.OrderCount) AS SumOrder
FROM Orders INNER JOIN OrdersH ON Orders.OrderId=OrdersH.OrderId
WHERE OrdersH.ClientId = AClientId
    AND OrdersH.Closed <> 1
    And Orders.OrderCount > 0;
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.SUMMARYSHOW(
    aclientid bigint,
    datefrom timestamp,
    dateto timestamp)
BEGIN
SELECT Core.Volume,
    Core.Quantity,
    Core.Note,
    Core.Period,
    Core.Junk,
    Core.Await,
    Core.CODE,
    Core.CODECR,
    ifnull(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    Core.BaseCost,
    PricesData.PriceName,
    Regions.RegionName,
    Orders.OrderCount,
    Orders.CoreId AS OrdersCoreId,
    Orders.OrderId AS OrdersOrderId,
    pricesdata.pricecode,
    Regions.regioncode,
    core.doc,
    core.registrycost,
    core.vitallyimportant,
    core.requestratio
FROM
    PricesData,
    Regions,
    Core,
    OrdersH,
    catalogs,
    products, 
    Orders
    left join Synonyms on Orders.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Orders.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
WHERE
    OrdersH.ClientId = AClientId
and Orders.OrderId=OrdersH.OrderId
and Orders.OrderCount>0
and Core.CoreId=Orders.CoreId
and products.productid = orders.productid
and catalogs.fullcode = products.catalogid
and PricesData.PriceCode = OrdersH.PriceCode
and Regions.RegionCode = OrdersH.RegionCode
and ordersh.orderdate >= datefrom
and ordersh.orderdate <= dateTo;
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.SUMMARYSHOWSEND(
    aclientid bigint,
    datefrom timestamp,
    dateto timestamp)
BEGIN
SELECT '',
    '',
    '',
    '',
    Orders.Junk,
    Orders.Await,
    Orders.CODE,
    Orders.CODECR,
    ifnull(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    Orders.Price as BaseCost,
    PricesData.PriceName,
    Regions.RegionName,
    Orders.OrderCount,
    Orders.CoreId AS OrdersCoreId,
    Orders.OrderId AS OrdersOrderId,
    PricesData.pricecode,
    Regions.regioncode,
    '',
    0.0,
    0,
    0
FROM
    PricesData,
    Regions,
    OrdersH,
    catalogs,
    products,
    Orders
    left join Synonyms on Orders.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Orders.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
WHERE
    OrdersH.ClientId = AClientId
and Orders.OrderId=OrdersH.OrderId
and Orders.OrderCount>0
and Orders.CoreId is null
and products.productid = orders.productid
and catalogs.fullcode = products.catalogid
and PricesData.PriceCode = OrdersH.PriceCode
and Regions.RegionCode = OrdersH.RegionCode
and ordersh.orderdate >= datefrom
and ordersh.orderdate <= dateTo;
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.UPDATEUPCOST(
    pricecode bigint,
    regioncode bigint,
    ainjob integer)
BEGIN
  declare uppricecode bigint;
  update pricesregionaldata set
    INJOB = ainjob
  where
    PriceCode = PRICECODE
    and RegionCode = RegionCODE;
  select
    pricecode
  from pricesregionaldataup
  where
      PriceCode = PRICECODE
    and RegionCode = RegionCODE
  into UPPRICECODE;
  if (UPPRICECODE is null) then
    insert into pricesregionaldataup values (PRICECODE, RegionCODE);
  end if;
END$$

delimiter ;

delimiter $$

create definer = 'root'@'localhost'
PROCEDURE analitf.UPDATEORDERCOUNT(
    aorderid bigint,
    aclientid bigint,
    apricecode bigint,
    aregioncode bigint,
    aordersorderid bigint,
    acoreid bigint,
    aordercount integer)
BEGIN
  if (aorderid is null) then
    SELECT ORDERID 
    FROM OrdersH 
    WHERE ClientId = AClientId 
      AND PriceCode = APriceCode 
      AND RegionCode = ARegionCode 
      AND Closed  <> 1
    into aorderid;

    if (orderid is null) then 
      insert into ordersh (ClientId, PriceCode, RegionCode, PriceName, RegionName, OrderDate)
        select aClientId, aPriceCode, aRegionCode, pd.PriceName, r.RegionName, current_timestamp()
        from
          pricesdata pd,
          pricesregionaldata prd,
          regions r
        where
          pd.pricecode = apricecode
          and prd.pricecode = pd.pricecode
          and r.regioncode = prd.regioncode
          and r.regioncode = aregioncode;
      select last_insert_id() into aorderid;
    end if;
  end if;

  if (aordersorderid is null ) then
    select orderid from orders where coreid = acoreid and orderid = aorderid into aordersorderid;
    if (ordersorderid is null) then
      INSERT INTO ORDERS(ORDERID, CLIENTID, COREID, PRODUCTID, CODEFIRMCR,
               SYNONYMCODE, SYNONYMFIRMCRCODE, CODE, CODECR, SYNONYMNAME,
               SYNONYMFIRM, PRICE, AWAIT, JUNK, ORDERCOUNT,
               REQUESTRATIO, ORDERCOST, MINORDERCOUNT )
        select aORDERID, aCLIENTID, aCOREID, c.PRODUCTID, c.CODEFIRMCR,
               c.SYNONYMCODE, c.SYNONYMFIRMCRCODE, c.CODE, c.CODECR,
               ifnull(s.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
               sf.synonymname, c.basecost, c.AWAIT, c.JUNK, aORDERCOUNT,
               c.REQUESTRATIO, c.ORDERCOST, c.MINORDERCOUNT
        from
          core c
          left join products p on p.productid = c.productid
          left join catalogs on catalogs.fullcode = p.catalogid
          left join synonyms s on s.synonymcode = c.synonymcode
          left join synonymfirmcr sf on sf.synonymfirmcrcode = c.synonymfirmcrcode
        where
          c.coreid = acoreid;
    else 
      update orders set ordercount = aordercount where orderid = aordersorderid and coreid = acoreid;
    end if;
  else 
    update orders set ordercount = aordercount where orderid = aordersorderid and coreid = acoreid;
  end if;

END$$

delimiter ;


delimiter $$

create definer = 'root'@'localhost'
$$

delimiter ;
