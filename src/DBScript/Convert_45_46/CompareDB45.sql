SET NAMES WIN1251;

SET SQL DIALECT 3;

CONNECT 'localhost:C:\Work\Analit\VSS\Inforoom\Delphi\AnalitF R 4.2.151.470\src\bin\ANALITF.FDB' USER 'SYSDBA' PASSWORD 'masterkey';

SET AUTODDL ON;

ALTER TABLE PARAMS ADD GROUPBYPRODUCTS FB_BOOLEAN;

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

