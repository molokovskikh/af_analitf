SET NAMES WIN1251;

SET SQL DIALECT 3;

CONNECT 'localhost:C:\Work\Analit\VSS\Inforoom\Delphi\AnalitF R 4.2.151.470\src\bin\ANALITF.FDB' USER 'SYSDBA' PASSWORD 'masterkey';

SET AUTODDL ON;

/* Declare UDF */
DECLARE EXTERNAL FUNCTION ADDDAY
TIMESTAMP, INTEGER
RETURNS TIMESTAMP
ENTRY_POINT 'addDay' MODULE_NAME 'fbudf';


/* Alter Procedure (Before Drop)... */
SET TERM ^ ;

ALTER PROCEDURE ORDERSHSHOW1(ACLIENTID BIGINT,
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
SUMORDER NUMERIC(18,2),
SUPPORTPHONE VARCHAR(20),
MESSAGETO BLOB SUB_TYPE 1,
COMMENTS BLOB SUB_TYPE 1)
 AS
 BEGIN EXIT; END
^

ALTER PROCEDURE ORDERSSETCORENULL AS
 BEGIN EXIT; END
^


/* Drop Procedure... */
SET TERM ; ^

DROP PROCEDURE ORDERSHSHOW1;

DROP PROCEDURE ORDERSSETCORENULL;


/* Drop table-fields... */
/* Empty UPDATEORDERCOUNT for drop ORDERS(VITALLYIMPORTANT) */
SET TERM ^ ;

ALTER PROCEDURE UPDATEORDERCOUNT(ORDERID BIGINT,
CLIENTID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
ORDERSORDERID BIGINT,
COREID BIGINT,
ORDERCOUNT INTEGER)
 AS
 BEGIN EXIT; END
^

SET TERM ; ^

DROP VIEW CLIENTAVG;

ALTER TABLE ORDERS DROP VITALLYIMPORTANT;


/* Create Views... */
/* Create view: CLIENTAVG (ViwData.CreateDependDef) */
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
and (ordersh.orderdate >= addmonth(current_date, -1))
and (ordersh.closed = 1)
and (ordersh.send = 1)
and (orders.ordercount > 0)
and (orders.sendprice is not null)
group by ordersh.clientid, orders.productid
;


/* Alter Procedure... */
/* Alter (ORDERSHSHOW) */
SET TERM ^ ;

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
^

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
     AND OrdersH.Closed = 1
     AND OrdersH.send = 1
     AND Orders.OrderCount>0
  into :sumbycurrentmonth;
  suspend;
end
end
^

/* Alter (UPDATEORDERCOUNT) */
ALTER PROCEDURE UPDATEORDERCOUNT(ORDERID BIGINT,
CLIENTID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
ORDERSORDERID BIGINT,
COREID BIGINT,
ORDERCOUNT INTEGER)
 AS
begin
  if (orderid is null) then begin
    select orderid from ORDERSHSHOWCURRENT(:CLIENTID, :PRICECODE, :REGIONCODE) into :orderid;
    if (orderid is null) then begin
      SELECT GEN_ID(GEN_ORDERSH_ID, 1) as NewID FROM RDB$DATABASE into :orderid;
      insert into ordersh (OrderID, ClientId, PriceCode, RegionCode, PriceName, RegionName, OrderDate)
        select :OrderID, :ClientId, :PriceCode, :RegionCode, pd.PriceName, r.RegionName, current_timestamp
        from
          pricesdata pd,
          pricesregionaldata prd,
          regions r
        where
          pd.pricecode = :pricecode
          and prd.pricecode = pd.pricecode
          and r.regioncode = prd.regioncode
          and r.regioncode = :regioncode;
    end
  end
  if (ordersorderid is null ) then begin
    select orderid from orders where coreid = :coreid and orderid = :orderid into :ordersorderid;
    if (ordersorderid is null) then
    begin
      INSERT INTO ORDERS(ORDERID, CLIENTID, COREID, PRODUCTID, CODEFIRMCR,
               SYNONYMCODE, SYNONYMFIRMCRCODE, CODE, CODECR, SYNONYMNAME,
               SYNONYMFIRM, PRICE, AWAIT, JUNK, ORDERCOUNT,
               REQUESTRATIO, ORDERCOST, MINORDERCOUNT )
        select :ORDERID, :CLIENTID, :COREID, c.PRODUCTID, c.CODEFIRMCR,
               c.SYNONYMCODE, c.SYNONYMFIRMCRCODE, c.CODE, c.CODECR,
               coalesce(s.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
               sf.synonymname, c.basecost, c.AWAIT, c.JUNK, :ORDERCOUNT,
               c.REQUESTRATIO, c.ORDERCOST, c.MINORDERCOUNT
        from
          core c
          left join products p on p.productid = c.productid
          left join catalogs on catalogs.fullcode = p.catalogid
          left join synonyms s on s.synonymcode = c.synonymcode
          left join synonymfirmcr sf on sf.synonymfirmcrcode = c.synonymfirmcrcode
        where
          c.coreid = :coreid;
    end
    else begin
      update orders set ordercount = :ordercount where orderid = :ordersorderid and coreid = :coreid;
    end
  end
  else begin
    update orders set ordercount = :ordercount where orderid = :ordersorderid and coreid = :coreid;
  end
end
^

