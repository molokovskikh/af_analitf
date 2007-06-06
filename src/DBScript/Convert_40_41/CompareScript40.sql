SET AUTODDL ON;

/* Declare UDF */
DECLARE EXTERNAL FUNCTION BIN_AND
INTEGER, INTEGER
RETURNS INTEGER BY VALUE
ENTRY_POINT 'IB_UDF_bin_and' MODULE_NAME 'ib_udf';

DECLARE EXTERNAL FUNCTION BIN_OR
INTEGER, INTEGER
RETURNS INTEGER BY VALUE
ENTRY_POINT 'IB_UDF_bin_or' MODULE_NAME 'ib_udf';

DECLARE EXTERNAL FUNCTION BIN_XOR
INTEGER, INTEGER
RETURNS INTEGER BY VALUE
ENTRY_POINT 'IB_UDF_bin_xor' MODULE_NAME 'ib_udf';


/* Alter Procedure (Before Drop)... */

ALTER PROCEDURE MINPRICESDELETE AS
 BEGIN EXIT; END
;


/* Drop Procedure... */

DROP PROCEDURE MINPRICESDELETE;


/* Create Table... */
CREATE TABLE RECEIVEDDOCS(ID FB_ID NOT NULL,
FILENAME FB_VC255 NOT NULL,
FILEDATETIME TIMESTAMP NOT NULL);



ALTER TABLE CORE ADD ORDERCOST NUMERIC(18,2);

ALTER TABLE CORE ADD MINORDERCOUNT INTEGER;

ALTER TABLE MINPRICES ADD SERVERMEMOID INTEGER;

ALTER TABLE PARAMS ADD USEOSOPEN FB_BOOLEAN DEFAULT 1;

/* Drop table-fields... */
/* Empty CORESHOWBYFIRM for drop MINPRICES(MINPRICE) */

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
 BEGIN EXIT; END
;


ALTER TABLE MINPRICES DROP MINPRICE;

ALTER TABLE MINPRICES DROP PRICECODE;


/* Create Procedure... */

CREATE PROCEDURE MINPRICES_IU(SERVERCOREID BIGINT,
SERVERMEMOID INTEGER,
FULLCODE BIGINT,
REGIONCODE BIGINT)
 AS
 BEGIN EXIT; END
;

CREATE PROCEDURE PRICEAVG_IU(CLIENTCODE BIGINT,
FULLCODE BIGINT,
ORDERPRICEAVG NUMERIC(15,2))
 AS
 BEGIN EXIT; END
;


/* Create generator... */

CREATE GENERATOR GEN_RECEIVEDDOCS_ID;


/* Create Primary Key... */
ALTER TABLE RECEIVEDDOCS ADD CONSTRAINT PK_RECEIVEDDOCS PRIMARY KEY (ID);

/* Alter Procedure... */
/* Alter (COREDELETENEWPRICES) */

ALTER PROCEDURE COREDELETENEWPRICES AS
declare variable pricecode bigint;
begin
for EXECUTE STATEMENT 'SELECT cast(PriceCode as BIGINT) FROM ExtPricesData where Fresh = ''1'''
into :pricecode
do
begin
  delete from core where PriceCode = :PriceCode;
end
update
  minprices
set
  servercoreid = null,
  servermemoid = null
where
  not exists(select * from core c where c.servercoreid = minprices.servercoreid);
end
;

/* Alter (CORESHOWBYFIRM) */
ALTER PROCEDURE CORESHOWBYFIRM(APRICECODE BIGINT,
AREGIONCODE BIGINT,
ACLIENTID BIGINT)
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
REQUESTRATIO INTEGER,
ORDERCOST NUMERIC(18,2),
MINORDERCOUNT INTEGER)
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
    CCore.requestratio,
    CCore.ordercost,
    CCore.minordercount
FROM
    Core CCore
    inner join catalogs      on catalogs.fullcode = CCore.fullcode
    inner JOIN MinPrices     ON MinPrices.FullCode = CCore.FullCode and minprices.regioncode = CCore.regioncode
    inner join Core LCore on LCore.servercoreid = minprices.servercoreid and LCore.RegionCode = minprices.regioncode
    inner JOIN PricesData ON PricesData.PriceCode=LCore.pricecode
    inner JOIN Regions       ON MinPrices.RegionCode=Regions.RegionCode
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
    :requestratio,
    :ordercost,
    :minordercount
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
REQUESTRATIO INTEGER,
ORDERCOST NUMERIC(18,2),
MINORDERCOUNT INTEGER)
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
    Core.requestratio,
    core.ordercost,
    core.minordercount
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
    :requestratio,
    :ordercost,
    :minordercount
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
REQUESTRATIO INTEGER,
ORDERCOST NUMERIC(18,2),
MINORDERCOUNT INTEGER)
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
    Core.requestratio,
    core.ordercost,
    core.minordercount
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
    :requestratio,
    :ordercost,
    :minordercount
do
  suspend;
end
;

/* Alter (EXPIREDSSHOW) */
ALTER PROCEDURE EXPIREDSSHOW(TIMEZONEBIAS INTEGER,
ACLIENTID BIGINT,
ACOREID BIGINT)
 RETURNS(COREID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
FULLCODE BIGINT,
CODEFIRMCR BIGINT,
SYNONYMCODE BIGINT,
SYNONYMFIRMCRCODE BIGINT,
CODE VARCHAR(84),
CODECR VARCHAR(84),
NOTE VARCHAR(50),
PERIOD VARCHAR(20),
VOLUME VARCHAR(15),
BASECOST VARCHAR(60),
QUANTITY VARCHAR(15),
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
AWAIT INTEGER,
PRICENAME VARCHAR(70),
DATEPRICE TIMESTAMP,
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
ORDERSSYNONYM VARCHAR(250),
ORDERSSYNONYMFIRM VARCHAR(250),
ORDERCOUNT INTEGER,
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
REQUESTRATIO INTEGER,
ORDERCOST NUMERIC(18,2),
MINORDERCOUNT INTEGER)
 AS
begin
for SELECT Core.CoreId,
    Core.PriceCode,
    Core.RegionCode,
    Core.FullCode,
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
    coalesce(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    Core.Await,
    PricesData.PriceName,
    addminute(PricesData.DatePrice, -:TimeZoneBias) AS DatePrice,
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
    left join catalogs on catalogs.fullcode = core.fullcode
    left JOIN Synonyms ON Core.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
    LEFT JOIN Orders osbc ON osbc.clientid = :AClientId and osbc.CoreId=Core.CoreId
    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId
WHERE
    (Core.fullcode > 0)
and (Core.Junk = 1)
and ((:ACoreID is not null and Core.coreid = :ACoreID) or (:ACoreID is null))
into :CoreId,
    :PriceCode,
    :RegionCode,
    :FullCode,
    :CodeFirmCr,
    :SynonymCode,
    :SynonymFirmCrCode,
    :Code,
    :CodeCr,
    :Note,
    :Period,
    :Volume,
    :BaseCost,
    :Quantity,
    :SynonymName,
    :SynonymFirm,
    :Await,
    :PriceName,
    :DatePrice,
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
    :OrdersSynonym,
    :OrdersSynonymFirm,
    :OrderCount,
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
    :requestratio,
    :ordercost,
    :minordercount
do
  suspend;
end
;

/* Restore procedure body: MINPRICES_IU */
ALTER PROCEDURE MINPRICES_IU(SERVERCOREID BIGINT,
SERVERMEMOID INTEGER,
FULLCODE BIGINT,
REGIONCODE BIGINT)
 AS
declare variable oldcoreid bigint;
declare variable oldmemoid integer;
begin
  if (exists(select * from minprices where fullcode = :fullcode and regioncode = :regioncode)) then
  begin
    select servercoreid, servermemoid from minprices where fullcode = :fullcode and regioncode = :regioncode
    into
      :oldcoreid,
      :oldmemoid;
    if ((:oldcoreid is null) or (:oldmemoid is null) or (bin_xor(99999900, :oldmemoid) > bin_xor(99999900, :servermemoid)) ) then
    update minprices
    set servercoreid = :servercoreid,
        servermemoid = :servermemoid
    where
      fullcode = :fullcode and regioncode = :regioncode;
  end
  else
    insert into minprices (
        fullcode,
        regioncode,
        servercoreid,
        servermemoid)
    values (
        :fullcode,
        :regioncode,
        :servercoreid,
        :servermemoid);
end
;

/* Restore procedure body: PRICEAVG_IU */
ALTER PROCEDURE PRICEAVG_IU(CLIENTCODE BIGINT,
FULLCODE BIGINT,
ORDERPRICEAVG NUMERIC(15,2))
 AS
begin
  if (exists(select clientcode from priceavg where (clientcode = :clientcode) and  (fullcode = :fullcode))) then
    update priceavg
    set orderpriceavg = :orderpriceavg
    where (clientcode = :clientcode) and (fullcode = :fullcode);
  else
    insert into priceavg (
        clientcode,
        fullcode,
        orderpriceavg)
    values (
        :clientcode,
        :fullcode,
        :orderpriceavg);
end
;

/* Create Trigger... */
CREATE TRIGGER RECEIVEDDOCS_BI FOR RECEIVEDDOCS
ACTIVE BEFORE INSERT POSITION 0 
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_RECEIVEDDOCS_ID,1);
END
;


/* Alter Procedure... */

ALTER TABLE CORE ALTER COLUMN COREID POSITION 1;

ALTER TABLE CORE ALTER COLUMN PRICECODE POSITION 2;

ALTER TABLE CORE ALTER COLUMN REGIONCODE POSITION 3;

ALTER TABLE CORE ALTER COLUMN FULLCODE POSITION 4;

ALTER TABLE CORE ALTER COLUMN CODEFIRMCR POSITION 5;

ALTER TABLE CORE ALTER COLUMN SYNONYMCODE POSITION 6;

ALTER TABLE CORE ALTER COLUMN SYNONYMFIRMCRCODE POSITION 7;

ALTER TABLE CORE ALTER COLUMN CODE POSITION 8;

ALTER TABLE CORE ALTER COLUMN CODECR POSITION 9;

ALTER TABLE CORE ALTER COLUMN UNIT POSITION 10;

ALTER TABLE CORE ALTER COLUMN VOLUME POSITION 11;

ALTER TABLE CORE ALTER COLUMN JUNK POSITION 12;

ALTER TABLE CORE ALTER COLUMN AWAIT POSITION 13;

ALTER TABLE CORE ALTER COLUMN QUANTITY POSITION 14;

ALTER TABLE CORE ALTER COLUMN NOTE POSITION 15;

ALTER TABLE CORE ALTER COLUMN PERIOD POSITION 16;

ALTER TABLE CORE ALTER COLUMN DOC POSITION 17;

ALTER TABLE CORE ALTER COLUMN REGISTRYCOST POSITION 18;

ALTER TABLE CORE ALTER COLUMN VITALLYIMPORTANT POSITION 19;

ALTER TABLE CORE ALTER COLUMN REQUESTRATIO POSITION 20;

ALTER TABLE CORE ALTER COLUMN BASECOST POSITION 21;

ALTER TABLE CORE ALTER COLUMN SERVERCOREID POSITION 22;

ALTER TABLE CORE ALTER COLUMN ORDERCOST POSITION 23;

ALTER TABLE CORE ALTER COLUMN MINORDERCOUNT POSITION 24;

ALTER TABLE MINPRICES ALTER COLUMN FULLCODE POSITION 1;

ALTER TABLE MINPRICES ALTER COLUMN REGIONCODE POSITION 2;

ALTER TABLE MINPRICES ALTER COLUMN SERVERCOREID POSITION 3;

ALTER TABLE MINPRICES ALTER COLUMN SERVERMEMOID POSITION 4;

ALTER TABLE PARAMS ALTER COLUMN ID POSITION 1;

ALTER TABLE PARAMS ALTER COLUMN CLIENTID POSITION 2;

ALTER TABLE PARAMS ALTER COLUMN RASCONNECT POSITION 3;

ALTER TABLE PARAMS ALTER COLUMN RASENTRY POSITION 4;

ALTER TABLE PARAMS ALTER COLUMN RASNAME POSITION 5;

ALTER TABLE PARAMS ALTER COLUMN RASPASS POSITION 6;

ALTER TABLE PARAMS ALTER COLUMN CONNECTCOUNT POSITION 7;

ALTER TABLE PARAMS ALTER COLUMN CONNECTPAUSE POSITION 8;

ALTER TABLE PARAMS ALTER COLUMN PROXYCONNECT POSITION 9;

ALTER TABLE PARAMS ALTER COLUMN PROXYNAME POSITION 10;

ALTER TABLE PARAMS ALTER COLUMN PROXYPORT POSITION 11;

ALTER TABLE PARAMS ALTER COLUMN PROXYUSER POSITION 12;

ALTER TABLE PARAMS ALTER COLUMN PROXYPASS POSITION 13;

ALTER TABLE PARAMS ALTER COLUMN SERVICENAME POSITION 14;

ALTER TABLE PARAMS ALTER COLUMN HTTPHOST POSITION 15;

ALTER TABLE PARAMS ALTER COLUMN HTTPPORT POSITION 16;

ALTER TABLE PARAMS ALTER COLUMN HTTPNAME POSITION 17;

ALTER TABLE PARAMS ALTER COLUMN HTTPPASS POSITION 18;

ALTER TABLE PARAMS ALTER COLUMN UPDATEDATETIME POSITION 19;

ALTER TABLE PARAMS ALTER COLUMN LASTDATETIME POSITION 20;

ALTER TABLE PARAMS ALTER COLUMN FASTPRINT POSITION 21;

ALTER TABLE PARAMS ALTER COLUMN SHOWREGISTER POSITION 22;

ALTER TABLE PARAMS ALTER COLUMN NEWWARES POSITION 23;

ALTER TABLE PARAMS ALTER COLUMN USEFORMS POSITION 24;

ALTER TABLE PARAMS ALTER COLUMN OPERATEFORMS POSITION 25;

ALTER TABLE PARAMS ALTER COLUMN OPERATEFORMSSET POSITION 26;

ALTER TABLE PARAMS ALTER COLUMN AUTOPRINT POSITION 27;

ALTER TABLE PARAMS ALTER COLUMN STARTPAGE POSITION 28;

ALTER TABLE PARAMS ALTER COLUMN LASTCOMPACT POSITION 29;

ALTER TABLE PARAMS ALTER COLUMN CUMULATIVE POSITION 30;

ALTER TABLE PARAMS ALTER COLUMN STARTED POSITION 31;

ALTER TABLE PARAMS ALTER COLUMN EXTERNALORDERSEXE POSITION 32;

ALTER TABLE PARAMS ALTER COLUMN EXTERNALORDERSPATH POSITION 33;

ALTER TABLE PARAMS ALTER COLUMN EXTERNALORDERSCREATE POSITION 34;

ALTER TABLE PARAMS ALTER COLUMN RASSLEEP POSITION 35;

ALTER TABLE PARAMS ALTER COLUMN HTTPNAMECHANGED POSITION 36;

ALTER TABLE PARAMS ALTER COLUMN SHOWALLCATALOG POSITION 37;

ALTER TABLE PARAMS ALTER COLUMN CDS POSITION 38;

ALTER TABLE PARAMS ALTER COLUMN ORDERSHISTORYDAYCOUNT POSITION 39;

ALTER TABLE PARAMS ALTER COLUMN CONFIRMDELETEOLDORDERS POSITION 40;

ALTER TABLE PARAMS ALTER COLUMN USENTLM POSITION 41;

ALTER TABLE PARAMS ALTER COLUMN USEOSOPEN POSITION 42;

update PROVIDER set mdbversion = 41 where id = 0;