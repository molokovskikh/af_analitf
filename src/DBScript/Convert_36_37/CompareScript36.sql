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
    pd.pricesize,
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

update PROVIDER set mdbversion = 37 where id = 0;