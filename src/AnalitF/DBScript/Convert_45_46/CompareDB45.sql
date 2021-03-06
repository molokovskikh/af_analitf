SET NAMES WIN1251;

SET SQL DIALECT 3;

CONNECT 'localhost:C:\Work\Analit\VSS\Inforoom\Delphi\AnalitF R 4.2.151.470\src\bin\ANALITF.FDB' USER 'SYSDBA' PASSWORD 'masterkey';

SET AUTODDL ON;

ALTER TABLE PARAMS ADD GROUPBYPRODUCTS FB_BOOLEAN;

ALTER TABLE ORDERS ADD VITALLYIMPORTANT FB_BOOLEAN;

ALTER TABLE ORDERS ADD REQUESTRATIO INTEGER;

ALTER TABLE ORDERS ADD ORDERCOST NUMERIC(18,2);

ALTER TABLE ORDERS ADD MINORDERCOUNT INTEGER;

/* Drop table-fields... */
/* Empty PRICESREGIONALDATAUPDATE for drop PRICESREGIONALDATA(UPCOST) */
SET TERM ^ ;

ALTER PROCEDURE PRICESREGIONALDATAUPDATE AS
 BEGIN EXIT; END
^

/* Empty PRICESSHOW for drop PRICESREGIONALDATA(UPCOST) */
ALTER PROCEDURE PRICESSHOW(ACLIENTID BIGINT,
TIMEZONEBIAS INTEGER)
 RETURNS(PRICECODE BIGINT,
PRICENAME VARCHAR(70),
DATEPRICE TIMESTAMP,
UPCOST NUMERIC(18,4),
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
SUMORDER NUMERIC(18,2),
PRICESIZE INTEGER,
INJOB INTEGER,
ALLOWCOSTCORR INTEGER,
CONTROLMINREQ INTEGER)
 AS
 BEGIN EXIT; END
^

/* Empty UPDATEUPCOST for drop PRICESREGIONALDATA(UPCOST) */
ALTER PROCEDURE UPDATEUPCOST(PRICECODE BIGINT,
REGIONCODE BIGINT,
INJOB INTEGER,
UPCOST NUMERIC(18,4))
 AS
 BEGIN EXIT; END
^

SET TERM ; ^

ALTER TABLE PRICESREGIONALDATA DROP UPCOST;

ALTER TABLE PRICESREGIONALDATA DROP ALLOWCOSTCORR;

ALTER TABLE TMPPRICESREGIONALDATA DROP UPCOST;

ALTER TABLE TMPPRICESREGIONALDATA DROP ALLOWCOSTCORR;


/* Alter Procedure... */
/* Alter (PRICESREGIONALDATAINSERT) */
SET TERM ^ ;

ALTER PROCEDURE PRICESREGIONALDATAINSERT AS
begin
EXECUTE STATEMENT 'INSERT INTO PricesRegionalData
(PRICECODE, REGIONCODE, STORAGE, MINREQ, ENABLED, INJOB, CONTROLMINREQ)
SELECT PriceCode, RegionCode, Storage, MinReq, Enabled, InJOB, CONTROLMINREQ
FROM ExtPricesRegionalData a
WHERE NOT Exists(SELECT PriceCode, RegionCode FROM
PricesRegionalData
WHERE PriceCode=A.PriceCode AND RegionCode=A.RegionCode);
';
end
^

/* Alter (PRICESREGIONALDATAUPDATE) */
ALTER PROCEDURE PRICESREGIONALDATAUPDATE AS
declare variable pricecode bigint;
declare variable storage integer;
declare variable minreq integer;
declare variable enabled integer;
declare variable injob integer;
declare variable controlminreq integer;
declare variable regioncode bigint;
begin
for select
         PriceCode,
         RegionCode,
         Storage,
         MinReq,
         Enabled,
         INJOB,
         CONTROLMINREQ
from
  TmpPricesRegionalData TPRD
into
         :PriceCode,
         :RegionCode,
         :Storage,
         :MinReq,
         :Enabled,
         :INJOB,
         :CONTROLMINREQ
do
UPDATE PricesRegionalData PRD
    SET 
         Storage = :Storage,
         MinReq = :MinReq,
         Enabled = :Enabled,
         INJOB = :INJOB,
         CONTROLMINREQ = :CONTROLMINREQ
where PRD.PriceCode = :PriceCode and PRD.regioncode = :RegionCode;
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
SUMORDER NUMERIC(18,2),
PRICESIZE INTEGER,
INJOB INTEGER,
CONTROLMINREQ INTEGER)
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
    Count(*),
    Sum(0*Orders.OrderCount) 
  FROM
    OrdersH
    INNER JOIN Orders ON Orders.OrderId=OrdersH.OrderId
  WHERE OrdersH.ClientId=:AClientId
     AND OrdersH.PriceCode=:PriceCode
     AND OrdersH.RegionCode=:RegionCode
     AND OrdersH.Closed <> 1
     AND Orders.OrderCount>0
  into :Positions, :SumOrder;
  suspend;
end
end
^

/* Alter (TMPPRICESREGIONALDATAINSERT) */
ALTER PROCEDURE TMPPRICESREGIONALDATAINSERT AS
begin
EXECUTE STATEMENT 'INSERT INTO TmpPricesRegionalData
SELECT PriceCode, RegionCode, Storage, MinReq, Enabled, InJob, CONTROLMINREQ
FROM ExtPricesRegionalData
WHERE Exists(SELECT PriceCode, RegionCode FROM PricesRegionalData WHERE PriceCode=ExtPricesRegionalData.PriceCode
AND RegionCode=ExtPricesRegionalData.RegionCode);
';
end
^

/* Alter (UPDATEUPCOST) */
ALTER PROCEDURE UPDATEUPCOST(PRICECODE BIGINT,
REGIONCODE BIGINT,
INJOB INTEGER)
 AS
declare variable uppricecode bigint;
begin
  update pricesregionaldata set
    INJOB = :INJOB
  where
    PriceCode = :PRICECODE
    and RegionCode = :RegionCODE;
  select
    pricecode
  from pricesregionaldataup
  where
      PriceCode = :PRICECODE
    and RegionCode = :RegionCODE
  into :UPPRICECODE;
  if (UPPRICECODE is null) then
    insert into pricesregionaldataup values (:PRICECODE, :RegionCODE);
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
               VITALLYIMPORTANT, REQUESTRATIO, ORDERCOST, MINORDERCOUNT )
        select :ORDERID, :CLIENTID, :COREID, c.PRODUCTID, c.CODEFIRMCR,
               c.SYNONYMCODE, c.SYNONYMFIRMCRCODE, c.CODE, c.CODECR,
               coalesce(s.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
               sf.synonymname, c.basecost, c.AWAIT, c.JUNK, :ORDERCOUNT,
               c.VITALLYIMPORTANT, c.REQUESTRATIO, c.ORDERCOST, c.MINORDERCOUNT
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




