SET AUTODDL ON;

/* Alter Procedure (Before Drop)... */

ALTER PROCEDURE ORDERSINFO1(ACLIENTID BIGINT)
 RETURNS(ORDERID BIGINT,
POSITIONS INTEGER,
SUMORDER NUMERIC(18,2))
 AS
 BEGIN EXIT; END
;

ALTER PROCEDURE ORDERSINFO2(ACLIENTID BIGINT)
 RETURNS(ORDERSCOUNT INTEGER,
POSITIONS INTEGER,
SUMORDER NUMERIC(18,2))
 AS
 BEGIN EXIT; END
;

ALTER PROCEDURE ORDERSINFO3(ACLIENTID BIGINT,
APRICECODE BIGINT,
AREGIONCODE BIGINT)
 RETURNS(POSITIONS INTEGER,
SUMORDER NUMERIC(18,2))
 AS
 BEGIN EXIT; END
;


/* Drop Procedure... */

DROP PROCEDURE ORDERSINFO1;

DROP PROCEDURE ORDERSINFO2;

DROP PROCEDURE ORDERSINFO3;


ALTER TABLE ORDERS ADD SENDPRICE NUMERIC(18,2);

ALTER TABLE PRICESREGIONALDATA ADD PRICESIZE INTEGER;

/* Drop table-fields... */
/* Empty PRICESSHOW for drop PRICESDATA(PRICESIZE) */

ALTER PROCEDURE PRICESSHOW(ACLIENTID BIGINT,
TIMEZONEBIAS INTEGER)
 RETURNS(PRICECODE BIGINT,
PRICENAME VARCHAR(70),
DATEPRICE TIMESTAMP,
UPCOST NUMERIC(18,4),
MINREQ INTEGER,
ENABLED INTEGER,
PRICEINFO BLOB SUB_TYPE 1 SEGMENT SIZE 80,
FIRMCODE BIGINT,
FULLNAME VARCHAR(40),
STORAGE INTEGER,
ADMINMAIL VARCHAR(50),
SUPPORTPHONE VARCHAR(20),
CONTACTINFO BLOB SUB_TYPE 1 SEGMENT SIZE 80,
OPERATIVEINFO BLOB SUB_TYPE 1 SEGMENT SIZE 80,
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
;

/* Empty SETPRICESIZE for drop PRICESDATA(PRICESIZE) */
ALTER PROCEDURE SETPRICESIZE AS
 BEGIN EXIT; END
;


ALTER TABLE PRICESDATA DROP PRICESIZE;


/* Create Procedure... */

CREATE PROCEDURE ORDERSINFOMAIN(ACLIENTID BIGINT)
 RETURNS(ORDERSCOUNT INTEGER,
POSITIONS INTEGER,
SUMORDER NUMERIC(18,2))
 AS
 BEGIN EXIT; END
;


/* Alter Procedure... */
/* Alter (CORESHOWBYFIRM) */
ALTER PROCEDURE CORESHOWBYFIRM(APRICECODE BIGINT,
AREGIONCODE BIGINT,
ACLIENTID BIGINT,
APRICENAME VARCHAR(70))
 RETURNS(COREID BIGINT,
FULLCODE BIGINT,
SHORTCODE BIGINT,
CODEFIRMCR BIGINT,
SYNONYMCODE BIGINT,
SYNONYMFIRMCRCODE BIGINT,
CODE VARCHAR(84),
CODECR VARCHAR(84),
VOLUME VARCHAR(15),
DOC VARCHAR(20),
NOTE VARCHAR(50),
PERIOD VARCHAR(20),
AWAIT INTEGER,
JUNK INTEGER,
BASECOST VARCHAR(60),
QUANTITY VARCHAR(15),
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
MINPRICE NUMERIC(18,2),
LEADERPRICECODE BIGINT,
LEADERREGIONCODE BIGINT,
LEADERREGIONNAME VARCHAR(25),
LEADERPRICENAME VARCHAR(70),
LEADERCODE VARCHAR(84),
LEADERCODECR VARCHAR(84),
LEADERPRICE VARCHAR(60),
ORDERSCOREID BIGINT,
ORDERSORDERID BIGINT,
ORDERSCLIENTID BIGINT,
ORDERSFULLCODE BIGINT,
ORDERSCODEFIRMCR BIGINT,
ORDERSSYNONYMCODE BIGINT,
ORDERSSYNONYMFIRMCRCODE BIGINT,
ORDERSCODE VARCHAR(84),
ORDERSCODECR VARCHAR(84),
ORDERCOUNT INTEGER,
ORDERSSYNONYM VARCHAR(250),
ORDERSSYNONYMFIRM VARCHAR(250),
ORDERSPRICE VARCHAR(60),
ORDERSJUNK INTEGER,
ORDERSAWAIT INTEGER,
ORDERSHORDERID BIGINT,
ORDERSHCLIENTID BIGINT,
ORDERSHPRICECODE BIGINT,
ORDERSHREGIONCODE BIGINT,
ORDERSHPRICENAME VARCHAR(70),
ORDERSHREGIONNAME VARCHAR(25),
REGISTRYCOST NUMERIC(8,2),
VITALLYIMPORTANT INTEGER,
REQUESTRATIO INTEGER)
 AS
begin
for
SELECT
    CCore.CoreId AS CoreId,
    CCore.FullCode,
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
    coalesce(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    MinPrices.MinPrice,
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
    osbc.FullCode AS OrdersFullCode,
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
    CCore.requestratio
FROM
    Core CCore
    left join catalogs      on catalogs.fullcode = CCore.fullcode
    LEFT JOIN MinPrices     ON CCore.FullCode=MinPrices.FullCode and minprices.regioncode = :aregioncode
    left join Core LCore on LCore.servercoreid = minprices.servercoreid and LCore.RegionCode = minprices.regioncode
    LEFT JOIN PricesData ON PricesData.PriceCode=LCore.pricecode
    LEFT JOIN Regions       ON MinPrices.RegionCode=Regions.RegionCode
    LEFT JOIN SynonymFirmCr ON CCore.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
    left join synonyms on CCore.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN Orders osbc ON osbc.ClientID = :AClientId and osbc.CoreId = CCore.CoreId
    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId
WHERE (CCore.PriceCode=:APriceCode) And (CCore.RegionCode=:ARegionCode)
into :CoreId,
    :FullCode,
    :ShortCode,
    :CodeFirmCr,
    :SynonymCode,
    :SynonymFirmCrCode,
    :Code,
    :CodeCr,
    :Volume,
    :Doc,
    :Note,
    :Period,
    :Await,
    :Junk,
    :BaseCost,
    :Quantity,
    :SynonymName,
    :SynonymFirm,
    :MinPrice,
    :LeaderPriceCode,
    :LeaderRegionCode,
    :LeaderRegionName,
    :LeaderPriceName,
    :leadercode,
    :leadercodecr,
    :leaderprice,
    :OrdersCoreId,
    :OrdersOrderId,
    :OrdersClientId,
    :OrdersFullCode,
    :OrdersCodeFirmCr,
    :OrdersSynonymCode,
    :OrdersSynonymFirmCrCode,
    :OrdersCode,
    :OrdersCodeCr,
    :OrderCount,
    :OrdersSynonym,
    :OrdersSynonymFirm,
    :OrdersPrice,
    :OrdersJunk,
    :OrdersAwait,
    :OrdersHOrderId,
    :OrdersHClientId,
    :OrdersHPriceCode,
    :OrdersHRegionCode,
    :OrdersHPriceName,
    :OrdersHRegionName,
    :registrycost,
    :vitallyimportant,
    :requestratio
do
  suspend;
end
;

/* Alter (CORESHOWBYFORM) */
ALTER PROCEDURE CORESHOWBYFORM(ACLIENTID BIGINT,
TIMEZONEBIAS INTEGER,
PARENTCODE BIGINT,
SHOWREGISTER INTEGER,
REGISTERID BIGINT)
 RETURNS(COREID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
FULLCODE BIGINT,
SHORTCODE BIGINT,
CODEFIRMCR BIGINT,
SYNONYMCODE BIGINT,
SYNONYMFIRMCRCODE BIGINT,
CODE VARCHAR(84),
CODECR VARCHAR(84),
PERIOD VARCHAR(20),
SALE INTEGER,
VOLUME VARCHAR(15),
NOTE VARCHAR(50),
BASECOST VARCHAR(60),
QUANTITY VARCHAR(15),
AWAIT INTEGER,
JUNK INTEGER,
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
DATEPRICE TIMESTAMP,
PRICENAME VARCHAR(70),
PRICEENABLED INTEGER,
FIRMCODE BIGINT,
STORAGE INTEGER,
REGIONNAME VARCHAR(25),
ORDERSCOREID BIGINT,
ORDERSORDERID BIGINT,
ORDERSCLIENTID BIGINT,
ORDERSFULLCODE BIGINT,
ORDERSCODEFIRMCR BIGINT,
ORDERSSYNONYMCODE BIGINT,
ORDERSSYNONYMFIRMCRCODE BIGINT,
ORDERSCODE VARCHAR(84),
ORDERSCODECR VARCHAR(84),
ORDERCOUNT INTEGER,
ORDERSSYNONYM VARCHAR(250),
ORDERSSYNONYMFIRM VARCHAR(250),
ORDERSPRICE VARCHAR(60),
ORDERSJUNK INTEGER,
ORDERSAWAIT INTEGER,
ORDERSHORDERID BIGINT,
ORDERSHCLIENTID BIGINT,
ORDERSHPRICECODE BIGINT,
ORDERSHREGIONCODE BIGINT,
ORDERSHPRICENAME VARCHAR(70),
ORDERSHREGIONNAME VARCHAR(25),
DOC VARCHAR(20),
REGISTRYCOST NUMERIC(8,2),
VITALLYIMPORTANT INTEGER,
REQUESTRATIO INTEGER)
 AS
begin
FOR SELECT Core.CoreId,
    Core.PriceCode,
    Core.RegionCode,
    Core.FullCode AS AFullCode,
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
    coalesce(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    CASE
       WHEN (PricesData.DatePrice IS NOT NULL) THEN addminute(PricesData.DatePrice, -:timezonebias)
       ELSE null
    END AS DatePrice,
    PricesData.PriceName,
    Enabled AS PriceEnabled,
    ClientsDataN.FirmCode AS FirmCode,
    Storage,
    Regions.RegionName,
    osbc.CoreId AS OrdersCoreId,
    osbc.OrderId AS OrdersOrderId,
    osbc.ClientId AS OrdersClientId,
    osbc.FullCode AS OrdersFullCode,
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
    Core.requestratio
FROM
    Core
    left join catalogs on catalogs.fullcode = core.fullcode
    left join Synonyms on Core.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
    LEFT JOIN PricesData ON Core.PriceCode=PricesData.PriceCode
    LEFT JOIN PricesRegionalData PRD ON (Core.RegionCode=PRD.RegionCode)
        AND (Core.PriceCode=PRD.PriceCode)
    LEFT JOIN ClientsDataN ON PricesData.FirmCode=ClientsDataN.FirmCode
    LEFT JOIN Regions ON Core.RegionCode=Regions.RegionCode
    LEFT JOIN Orders osbc ON osbc.clientid = :aclientid and osbc.CoreId = Core.CoreId
    LEFT JOIN OrdersH ON OrdersH.OrderId = osbc.OrderId
WHERE (Core.FullCode=:ParentCode)
And (:ShowRegister = 1 Or (ClientsDataN.FirmCode<>:RegisterId))
into CoreId,
    :PriceCode,
    :RegionCode,
    :FullCode,
    :ShortCode,
    :CodeFirmCr,
    :SynonymCode,
    :SynonymFirmCrCode,
    :Code,
    :CodeCr,
    :Period,
    :Sale,
    :Volume,
    :Note,
    :BaseCost,
    :Quantity,
    :Await,
    :Junk,
    :SynonymName,
    :SynonymFirm,
    :DatePrice,
    :PriceName,
    :PriceEnabled,
    :FirmCode,
    :Storage,
    :RegionName,
    :OrdersCoreId,
    :OrdersOrderId,
    :OrdersClientId,
    :OrdersFullCode,
    :OrdersCodeFirmCr,
    :OrdersSynonymCode,
    :OrdersSynonymFirmCrCode,
    :OrdersCode,
    :OrdersCodeCr,
    :OrderCount,
    :OrdersSynonym,
    :OrdersSynonymFirm,
    :OrdersPrice,
    :OrdersJunk,
    :OrdersAwait,
    :OrdersHOrderId,
    :OrdersHClientId,
    :OrdersHPriceCode,
    :OrdersHRegionCode,
    :OrdersHPriceName,
    :OrdersHRegionName,
    :doc,
    :registrycost,
    :vitallyimportant,
    :requestratio
do
  suspend;
end
;

/* Alter (CORESHOWBYNAME) */
ALTER PROCEDURE CORESHOWBYNAME(ACLIENT BIGINT,
TIMEZONEBIAS INTEGER,
PARENTCODE BIGINT,
SHOWREGISTER INTEGER,
REGISTERID BIGINT)
 RETURNS(COREID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
FULLCODE BIGINT,
SHORTCODE BIGINT,
CODEFIRMCR BIGINT,
SYNONYMCODE BIGINT,
SYNONYMFIRMCRCODE BIGINT,
CODE VARCHAR(84),
CODECR VARCHAR(84),
PERIOD VARCHAR(20),
SALE INTEGER,
VOLUME VARCHAR(15),
NOTE VARCHAR(50),
BASECOST VARCHAR(60),
QUANTITY VARCHAR(15),
AWAIT INTEGER,
JUNK INTEGER,
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
DATEPRICE TIMESTAMP,
PRICENAME VARCHAR(70),
PRICEENABLED INTEGER,
FIRMCODE BIGINT,
STORAGE INTEGER,
REGIONNAME VARCHAR(25),
ORDERSCOREID BIGINT,
ORDERSORDERID BIGINT,
ORDERSCLIENTID BIGINT,
ORDERSFULLCODE BIGINT,
ORDERSCODEFIRMCR BIGINT,
ORDERSSYNONYMCODE BIGINT,
ORDERSSYNONYMFIRMCRCODE BIGINT,
ORDERSCODE VARCHAR(84),
ORDERSCODECR VARCHAR(84),
ORDERCOUNT INTEGER,
ORDERSSYNONYM VARCHAR(250),
ORDERSSYNONYMFIRM VARCHAR(250),
ORDERSPRICE VARCHAR(60),
ORDERSJUNK INTEGER,
ORDERSAWAIT INTEGER,
ORDERSHORDERID BIGINT,
ORDERSHCLIENTID BIGINT,
ORDERSHPRICECODE BIGINT,
ORDERSHREGIONCODE BIGINT,
ORDERSHPRICENAME VARCHAR(70),
ORDERSHREGIONNAME VARCHAR(25),
DOC VARCHAR(20),
REGISTRYCOST NUMERIC(8,2),
VITALLYIMPORTANT INTEGER,
REQUESTRATIO INTEGER)
 AS
begin
for SELECT Core.CoreId,
    Core.PriceCode,
    Core.RegionCode,
    Core.FullCode AS AFullCode,
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
    coalesce(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    CASE
       WHEN (PricesData.DatePrice IS NOT NULL) THEN addminute(PricesData.DatePrice, -:timezonebias)
       ELSE null
    END AS DatePrice,
    PricesData.PriceName,
    Enabled AS PriceEnabled,
    ClientsDataN.FirmCode AS FirmCode,
    Storage,
    Regions.RegionName,
    osbc.CoreId AS OrdersCoreId,
    osbc.OrderId AS OrdersOrderId,
    osbc.ClientId AS OrdersClientId,
    osbc.FullCode AS OrdersFullCode,
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
    Core.requestratio
FROM
    Catalogs
    INNER JOIN Core ON Core.fullcode =Catalogs.fullcode
    LEFT JOIN Synonyms ON Core.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
    LEFT JOIN PricesData ON Core.PriceCode=PricesData.PriceCode
    LEFT JOIN PricesRegionalData PRD ON (Core.RegionCode=PRD.RegionCode)
        AND (Core.PriceCode=PRD.PriceCode)
    LEFT JOIN ClientsDataN ON PricesData.FirmCode=ClientsDataN.FirmCode
    LEFT JOIN Regions ON Core.RegionCode=Regions.RegionCode
    LEFT JOIN Orders osbc ON osbc.clientid = :aclient and osbc.CoreId = Core.CoreId
    LEFT JOIN OrdersH ON OrdersH.OrderId = osbc.OrderId
WHERE (Catalogs.ShortCode=:ParentCode)
And (:ShowRegister = 1 Or (ClientsDataN.FirmCode<>:RegisterId))
into :CoreId,
    :PriceCode,
    :RegionCode,
    :FullCode,
    :ShortCode,
    :CodeFirmCr,
    :SynonymCode,
    :SynonymFirmCrCode,
    :Code,
    :CodeCr,
    :Period,
    :Sale,
    :Volume,
    :Note,
    :BaseCost,
    :Quantity,
    :Await,
    :Junk,
    :SynonymName,
    :SynonymFirm,
    :DatePrice,
    :PriceName,
    :PriceEnabled,
    :FirmCode,
    :Storage,
    :RegionName,
    :OrdersCoreId,
    :OrdersOrderId,
    :OrdersClientId,
    :OrdersFullCode,
    :OrdersCodeFirmCr,
    :OrdersSynonymCode,
    :OrdersSynonymFirmCrCode,
    :OrdersCode,
    :OrdersCodeCr,
    :OrderCount,
    :OrdersSynonym,
    :OrdersSynonymFirm,
    :OrdersPrice,
    :OrdersJunk,
    :OrdersAwait,
    :OrdersHOrderId,
    :OrdersHClientId,
    :OrdersHPriceCode,
    :OrdersHRegionCode,
    :OrdersHPriceName,
    :OrdersHRegionName,
    :doc,
    :registrycost,
    :vitallyimportant,
    :requestratio
do
  suspend;
end
;

/* Alter (ORDERSSHOWBYFORM) */
ALTER PROCEDURE ORDERSSHOWBYFORM(AFULLCODE BIGINT,
ACLIENTID BIGINT)
 RETURNS(FULLCODE BIGINT,
CODE VARCHAR(84),
CODECR VARCHAR(84),
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
ORDERCOUNT INTEGER,
PRICE VARCHAR(60),
ORDERDATE TIMESTAMP,
PRICENAME VARCHAR(70),
REGIONNAME VARCHAR(25),
AWAIT INTEGER,
JUNK INTEGER,
SENDPRICE NUMERIC(18,2))
 AS
begin
for SELECT 
    first 20
    FullCode,
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
  INNER JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId
WHERE
    osbc.clientid = :AClientID
and osbc.OrderCount>0 And FullCode=:AFullCode
And ((OrdersH.Closed = 1) Or (OrdersH.Closed Is Null))
ORDER BY OrdersH.OrderDate DESC
into :FullCode,
    :Code,
    :CodeCR,
    :SynonymName,
    :SynonymFirm,
    :OrderCount,
    :Price,
    :OrderDate,
    :PriceName,
    :RegionName,
    :Await,
    :Junk,
    :sendprice
do
  suspend;
end
;

/* Alter (PRICESREGIONALDATAINSERT) */
ALTER PROCEDURE PRICESREGIONALDATAINSERT AS
begin
EXECUTE STATEMENT 'INSERT INTO PricesRegionalData
(PRICECODE, REGIONCODE, STORAGE, UPCOST, MINREQ, ENABLED, INJOB, ALLOWCOSTCORR, CONTROLMINREQ)
SELECT PriceCode, RegionCode, Storage, UpCost, MinReq, Enabled, InJOB, ALLOWCOSTCORR, CONTROLMINREQ
FROM ExtPricesRegionalData a
WHERE NOT Exists(SELECT PriceCode, RegionCode FROM
PricesRegionalData
WHERE PriceCode=A.PriceCode AND RegionCode=A.RegionCode);
';
end
;

/* Alter (PRICESREGIONALDATAUPDATE) */
ALTER PROCEDURE PRICESREGIONALDATAUPDATE AS
declare variable pricecode bigint;
declare variable storage integer;
declare variable upcost numeric(18,4);
declare variable minreq integer;
declare variable enabled integer;
declare variable injob integer;
declare variable allowcostcorr integer;
declare variable controlminreq integer;
declare variable regioncode bigint;
begin
for select
         PriceCode,
         RegionCode,
         Storage,
         UpCost,
         MinReq,
         Enabled,
         INJOB,
         ALLOWCOSTCORR,
         CONTROLMINREQ
from
  TmpPricesRegionalData TPRD
into
         :PriceCode,
         :RegionCode,
         :Storage,
         :UpCost,
         :MinReq,
         :Enabled,
         :INJOB,
         :ALLOWCOSTCORR,
         :CONTROLMINREQ
do
UPDATE PricesRegionalData PRD
    SET 
         Storage = :Storage,
         UpCost = :UpCost,
         MinReq = :MinReq,
         Enabled = :Enabled,
         INJOB = :INJOB,
         ALLOWCOSTCORR = :ALLOWCOSTCORR,
         CONTROLMINREQ = :CONTROLMINREQ
where PRD.PriceCode = :PriceCode and PRD.regioncode = :RegionCode;
end
;

/* Alter (PRICESSHOW) */
ALTER PROCEDURE PRICESSHOW(ACLIENTID BIGINT,
TIMEZONEBIAS INTEGER)
 RETURNS(PRICECODE BIGINT,
PRICENAME VARCHAR(70),
DATEPRICE TIMESTAMP,
UPCOST NUMERIC(18,4),
MINREQ INTEGER,
ENABLED INTEGER,
PRICEINFO BLOB SUB_TYPE 1 SEGMENT SIZE 80,
FIRMCODE BIGINT,
FULLNAME VARCHAR(40),
STORAGE INTEGER,
ADMINMAIL VARCHAR(50),
SUPPORTPHONE VARCHAR(20),
CONTACTINFO BLOB SUB_TYPE 1 SEGMENT SIZE 80,
OPERATIVEINFO BLOB SUB_TYPE 1 SEGMENT SIZE 80,
REGIONCODE BIGINT,
REGIONNAME VARCHAR(25),
POSITIONS INTEGER,
SUMORDER NUMERIC(18,2),
PRICESIZE INTEGER,
INJOB INTEGER,
ALLOWCOSTCORR INTEGER,
CONTROLMINREQ INTEGER)
 AS
begin
for SELECT PD.PriceCode,
    PriceName,
    addminute(PD.DatePrice, -:TimeZoneBias) AS DatePrice,
    PRD.UpCost,
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
    prd.ALLOWCOSTCORR,
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
    :UpCost,
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
    :ALLOWCOSTCORR,
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
;

/* Alter (SETPRICESIZE) */
ALTER PROCEDURE SETPRICESIZE AS
declare variable pricecode bigint;
declare variable pricesize integer;
declare variable regioncode bigint;
begin
  for select Pricesdata.PriceCode, pricesregionaldata.regioncode
    from
      Pricesdata,
      pricesregionaldata
    where
      pricesregionaldata.pricecode = Pricesdata.pricecode
    into
      :pricecode,
      :regioncode
  do begin
    select count(*)
    from
      Core
    where
      Core.pricecode = :pricecode and Core.regioncode = :regioncode
    into :pricesize;
    update
      pricesregionaldata
    set
      pricesize = :pricesize
    where
      pricecode = :pricecode and regioncode = :regioncode;
  end
end
;

/* Restore procedure body: ORDERSINFOMAIN */
ALTER PROCEDURE ORDERSINFOMAIN(ACLIENTID BIGINT)
 RETURNS(ORDERSCOUNT INTEGER,
POSITIONS INTEGER,
SUMORDER NUMERIC(18,2))
 AS
begin
for SELECT
    count(distinct OrdersH.orderid) as OrdersCount,
    Count(osbc.id) AS Positions,
    Sum (osbc.OrderCount * 0) AS SumOrder
FROM
    OrdersH
    INNER JOIN Orders osbc ON osbc.clientid = :AClientID and OrdersH.orderid=osbc.OrderId
    INNER JOIN PricesRegionalData PRD ON (PRD.RegionCode=OrdersH.RegionCode AND (PRD.PriceCode=OrdersH.PriceCode))
    LEFT JOIN PricesData ON PricesData.PriceCode=PRD.PriceCode
WHERE OrdersH.Closed <> 1
    AND (osbc.OrderCount>0)
into :OrdersCount,
    :Positions,
    :SumOrder
do
  suspend;
end
;

/* Alter Procedure... */

ALTER TABLE ORDERS ALTER COLUMN ID POSITION 1;

ALTER TABLE ORDERS ALTER COLUMN ORDERID POSITION 2;

ALTER TABLE ORDERS ALTER COLUMN CLIENTID POSITION 3;

ALTER TABLE ORDERS ALTER COLUMN COREID POSITION 4;

ALTER TABLE ORDERS ALTER COLUMN FULLCODE POSITION 5;

ALTER TABLE ORDERS ALTER COLUMN CODEFIRMCR POSITION 6;

ALTER TABLE ORDERS ALTER COLUMN SYNONYMCODE POSITION 7;

ALTER TABLE ORDERS ALTER COLUMN SYNONYMFIRMCRCODE POSITION 8;

ALTER TABLE ORDERS ALTER COLUMN CODE POSITION 9;

ALTER TABLE ORDERS ALTER COLUMN CODECR POSITION 10;

ALTER TABLE ORDERS ALTER COLUMN SYNONYMNAME POSITION 11;

ALTER TABLE ORDERS ALTER COLUMN SYNONYMFIRM POSITION 12;

ALTER TABLE ORDERS ALTER COLUMN PRICE POSITION 13;

ALTER TABLE ORDERS ALTER COLUMN AWAIT POSITION 14;

ALTER TABLE ORDERS ALTER COLUMN JUNK POSITION 15;

ALTER TABLE ORDERS ALTER COLUMN ORDERCOUNT POSITION 16;

ALTER TABLE ORDERS ALTER COLUMN SENDPRICE POSITION 17;

ALTER TABLE PRICESDATA ALTER COLUMN FIRMCODE POSITION 1;

ALTER TABLE PRICESDATA ALTER COLUMN PRICECODE POSITION 2;

ALTER TABLE PRICESDATA ALTER COLUMN PRICENAME POSITION 3;

ALTER TABLE PRICESDATA ALTER COLUMN ALLOWINTEGR POSITION 4;

ALTER TABLE PRICESDATA ALTER COLUMN PRICEINFO POSITION 5;

ALTER TABLE PRICESDATA ALTER COLUMN DATEPRICE POSITION 6;

ALTER TABLE PRICESDATA ALTER COLUMN FRESH POSITION 7;

ALTER TABLE PRICESDATA ALTER COLUMN PRICEFMT POSITION 8;

ALTER TABLE PRICESDATA ALTER COLUMN PRICEFILEDATE POSITION 9;

ALTER TABLE PRICESDATA ALTER COLUMN PATHTOPRICE POSITION 10;

ALTER TABLE PRICESDATA ALTER COLUMN DELIMITER POSITION 11;

ALTER TABLE PRICESDATA ALTER COLUMN PARENTSYNONYM POSITION 12;

ALTER TABLE PRICESDATA ALTER COLUMN NAMEMASK POSITION 13;

ALTER TABLE PRICESDATA ALTER COLUMN FORBWORDS POSITION 14;

ALTER TABLE PRICESDATA ALTER COLUMN JUNKPOS POSITION 15;

ALTER TABLE PRICESDATA ALTER COLUMN AWAITPOS POSITION 16;

ALTER TABLE PRICESDATA ALTER COLUMN STARTLINE POSITION 17;

ALTER TABLE PRICESDATA ALTER COLUMN LISTNAME POSITION 18;

ALTER TABLE PRICESDATA ALTER COLUMN TXTCODEBEGIN POSITION 19;

ALTER TABLE PRICESDATA ALTER COLUMN TXTCODEEND POSITION 20;

ALTER TABLE PRICESDATA ALTER COLUMN TXTCODECRBEGIN POSITION 21;

ALTER TABLE PRICESDATA ALTER COLUMN TXTCODECREND POSITION 22;

ALTER TABLE PRICESDATA ALTER COLUMN TXTNAMEBEGIN POSITION 23;

ALTER TABLE PRICESDATA ALTER COLUMN TXTNAMEEND POSITION 24;

ALTER TABLE PRICESDATA ALTER COLUMN TXTFIRMCRBEGIN POSITION 25;

ALTER TABLE PRICESDATA ALTER COLUMN TXTFIRMCREND POSITION 26;

ALTER TABLE PRICESDATA ALTER COLUMN TXTBASECOSTBEGIN POSITION 27;

ALTER TABLE PRICESDATA ALTER COLUMN TXTBASECOSTEND POSITION 28;

ALTER TABLE PRICESDATA ALTER COLUMN TXTUNITBEGIN POSITION 29;

ALTER TABLE PRICESDATA ALTER COLUMN TXTUNITEND POSITION 30;

ALTER TABLE PRICESDATA ALTER COLUMN TXTVOLUMEBEGIN POSITION 31;

ALTER TABLE PRICESDATA ALTER COLUMN TXTVOLUMEEND POSITION 32;

ALTER TABLE PRICESDATA ALTER COLUMN TXTQUANTITYBEGIN POSITION 33;

ALTER TABLE PRICESDATA ALTER COLUMN TXTQUANTITYEND POSITION 34;

ALTER TABLE PRICESDATA ALTER COLUMN TXTNOTEBEGIN POSITION 35;

ALTER TABLE PRICESDATA ALTER COLUMN TXTNOTEEND POSITION 36;

ALTER TABLE PRICESDATA ALTER COLUMN TXTPERIODBEGIN POSITION 37;

ALTER TABLE PRICESDATA ALTER COLUMN TXTPERIODEND POSITION 38;

ALTER TABLE PRICESDATA ALTER COLUMN TXTDOCBEGIN POSITION 39;

ALTER TABLE PRICESDATA ALTER COLUMN TXTDOCEND POSITION 40;

ALTER TABLE PRICESDATA ALTER COLUMN TXTJUNKBEGIN POSITION 41;

ALTER TABLE PRICESDATA ALTER COLUMN TXTJUNKEND POSITION 42;

ALTER TABLE PRICESDATA ALTER COLUMN TXTAWAITBEGIN POSITION 43;

ALTER TABLE PRICESDATA ALTER COLUMN TXTAWAITEND POSITION 44;

ALTER TABLE PRICESDATA ALTER COLUMN FCODE POSITION 45;

ALTER TABLE PRICESDATA ALTER COLUMN FCODECR POSITION 46;

ALTER TABLE PRICESDATA ALTER COLUMN FNAME1 POSITION 47;

ALTER TABLE PRICESDATA ALTER COLUMN FNAME2 POSITION 48;

ALTER TABLE PRICESDATA ALTER COLUMN FNAME3 POSITION 49;

ALTER TABLE PRICESDATA ALTER COLUMN FFIRMCR POSITION 50;

ALTER TABLE PRICESDATA ALTER COLUMN FBASECOST POSITION 51;

ALTER TABLE PRICESDATA ALTER COLUMN FUNIT POSITION 52;

ALTER TABLE PRICESDATA ALTER COLUMN FVOLUME POSITION 53;

ALTER TABLE PRICESDATA ALTER COLUMN FQUANTITY POSITION 54;

ALTER TABLE PRICESDATA ALTER COLUMN FNOTE POSITION 55;

ALTER TABLE PRICESDATA ALTER COLUMN FPERIOD POSITION 56;

ALTER TABLE PRICESDATA ALTER COLUMN FDOC POSITION 57;

ALTER TABLE PRICESDATA ALTER COLUMN FJUNK POSITION 58;

ALTER TABLE PRICESDATA ALTER COLUMN FAWAIT POSITION 59;

ALTER TABLE PRICESDATA ALTER COLUMN PROTEK POSITION 60;

ALTER TABLE PRICESREGIONALDATA ALTER COLUMN PRICECODE POSITION 1;

ALTER TABLE PRICESREGIONALDATA ALTER COLUMN REGIONCODE POSITION 2;

ALTER TABLE PRICESREGIONALDATA ALTER COLUMN STORAGE POSITION 3;

ALTER TABLE PRICESREGIONALDATA ALTER COLUMN UPCOST POSITION 4;

ALTER TABLE PRICESREGIONALDATA ALTER COLUMN MINREQ POSITION 5;

ALTER TABLE PRICESREGIONALDATA ALTER COLUMN ENABLED POSITION 6;

ALTER TABLE PRICESREGIONALDATA ALTER COLUMN INJOB POSITION 7;

ALTER TABLE PRICESREGIONALDATA ALTER COLUMN ALLOWCOSTCORR POSITION 8;

ALTER TABLE PRICESREGIONALDATA ALTER COLUMN CONTROLMINREQ POSITION 9;

ALTER TABLE PRICESREGIONALDATA ALTER COLUMN PRICESIZE POSITION 10;

update PROVIDER set mdbversion = 37 where id = 0;