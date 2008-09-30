RECONNECT;

ALTER TABLE PRICEAVG DROP CONSTRAINT PK_PRICEAVG;

ALTER TABLE SYNONYMS DROP CONSTRAINT FK_SYNONYMS_FULLCODE;

ALTER TABLE MINPRICES DROP CONSTRAINT FK_MINPRICES_FULLCODE;

ALTER TABLE CORE DROP CONSTRAINT FK_CORE_FULLCODE;

/* Declare UDF */
DECLARE EXTERNAL FUNCTION ADDMONTH
TIMESTAMP, INTEGER
RETURNS TIMESTAMP
ENTRY_POINT 'addMonth' MODULE_NAME 'fbudf';


/* Alter Procedure (Before Drop)... */

ALTER PROCEDURE GETWAREDATA(AFULLCODE BIGINT,
ACLIENTID BIGINT)
 RETURNS(NAME VARCHAR(250),
FORM VARCHAR(250),
PRICEAVG NUMERIC(18,2))
 AS
 BEGIN EXIT; END
;

ALTER PROCEDURE MINPRICES_IU(SERVERCOREID BIGINT,
SERVERMEMOID INTEGER,
FULLCODE BIGINT,
REGIONCODE BIGINT)
 AS
 BEGIN EXIT; END
;

ALTER PROCEDURE ORDERSSHOW(AORDERID BIGINT)
 RETURNS(ORDERID BIGINT,
CLIENTID BIGINT,
COREID BIGINT,
FULLCODE BIGINT,
CODEFIRMCR BIGINT,
SYNONYMCODE BIGINT,
SYNONYMFIRMCRCODE BIGINT,
CODE VARCHAR(84),
CODECR VARCHAR(84),
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
PRICE VARCHAR(60),
AWAIT INTEGER,
JUNK INTEGER,
ORDERCOUNT INTEGER,
SUMORDER NUMERIC(18,2))
 AS
 BEGIN EXIT; END
;

ALTER PROCEDURE ORDERSSHOWBYCLIENT(ACLIENTID BIGINT)
 RETURNS(ORDERID BIGINT,
CLIENTID BIGINT,
COREID BIGINT,
FULLCODE BIGINT,
CODEFIRMCR BIGINT,
SYNONYMCODE BIGINT,
SYNONYMFIRMCRCODE BIGINT,
CODE VARCHAR(84),
CODECR VARCHAR(84),
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
PRICE VARCHAR(60),
AWAIT INTEGER,
JUNK INTEGER,
ORDERCOUNT INTEGER)
 AS
 BEGIN EXIT; END
;

ALTER PROCEDURE ORDERSSHOWFORMSUMMARY(AFULLCODE BIGINT,
ACLIENTID BIGINT)
 RETURNS(PRICEAVG NUMERIC(18,2))
 AS
 BEGIN EXIT; END
;

ALTER PROCEDURE PRICEAVG_IU(CLIENTCODE BIGINT,
FULLCODE BIGINT,
ORDERPRICEAVG NUMERIC(15,2))
 AS
 BEGIN EXIT; END
;

ALTER PROCEDURE SYNONYMDELETEFORMHEADERS AS
 BEGIN EXIT; END
;

ALTER PROCEDURE TESTWAYBILLHEADINSERT AS
 BEGIN EXIT; END
;

ALTER PROCEDURE TESTWAYBILLLISTINSERT AS
 BEGIN EXIT; END
;


/* Drop Procedure... */

DROP PROCEDURE GETWAREDATA;

DROP PROCEDURE MINPRICES_IU;

DROP PROCEDURE ORDERSSHOW;

DROP PROCEDURE ORDERSSHOWBYCLIENT;

DROP PROCEDURE ORDERSSHOWFORMSUMMARY;

DROP PROCEDURE PRICEAVG_IU;

DROP PROCEDURE SYNONYMDELETEFORMHEADERS;

DROP PROCEDURE TESTWAYBILLHEADINSERT;

DROP PROCEDURE TESTWAYBILLLISTINSERT;


/* Drop Index... */
RECONNECT;

/* Drop: IDX_ORDERS_FULLCODE (TIdxData) */
DROP INDEX IDX_ORDERS_FULLCODE;

RECONNECT;

/* Drop: IDX_PRICECODE (TIdxData) */
DROP INDEX IDX_PRICECODE;


/* Create Table... */
CREATE TABLE PRODUCTS(PRODUCTID FB_ID,
CATALOGID FB_ID);

insert into products (productid, catalogid) select fullcode, fullcode from catalogs;

commit work;

RECONNECT;

ALTER TABLE CORE ADD PRODUCTID FB_ID;

ALTER TABLE MINPRICES ADD PRODUCTID FB_REF;

ALTER TABLE ORDERS ADD PRODUCTID FB_ID;

ALTER TABLE CORE ALTER PRODUCTID POSITION 4;

ALTER TABLE MINPRICES ALTER PRODUCTID POSITION 1;

ALTER TABLE ORDERS ALTER PRODUCTID POSITION 5;

update core set productid = fullcode;

update minprices set productid = fullcode;

update orders set productid = fullcode;

commit work;

RECONNECT;

/* Drop table-fields... */
/* Empty COREINSERTFORMHEADERS for drop CORE(FULLCODE) */

ALTER PROCEDURE COREINSERTFORMHEADERS AS
 BEGIN EXIT; END
;

/* Empty CORESHOWBYFIRM for drop CORE(FULLCODE) */
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
 BEGIN EXIT; END
;

/* Empty CORESHOWBYFORM for drop CORE(FULLCODE) */
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
 BEGIN EXIT; END
;

/* Empty CORESHOWBYNAME for drop CORE(FULLCODE) */
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
 BEGIN EXIT; END
;

/* Empty EXPIREDSSHOW for drop CORE(FULLCODE) */
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
 BEGIN EXIT; END
;

/* Empty MINPRICESINSERT for drop CORE(FULLCODE) */
ALTER PROCEDURE MINPRICESINSERT AS
 BEGIN EXIT; END
;

/* Empty UPDATEORDERCOUNT for drop CORE(FULLCODE) */
ALTER PROCEDURE UPDATEORDERCOUNT(ORDERID BIGINT,
CLIENTID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
ORDERSORDERID BIGINT,
COREID BIGINT,
ORDERCOUNT INTEGER)
 AS
 BEGIN EXIT; END
;


RECONNECT;

/* Drop: IDX_CORE_JUNK (TIdxData) */
DROP INDEX IDX_CORE_JUNK;

ALTER TABLE CORE DROP FULLCODE;

ALTER TABLE MINPRICES DROP FULLCODE;

/* Empty ORDERSSHOWBYFORM for drop ORDERS(FULLCODE) */

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
 BEGIN EXIT; END
;

/* Empty SUMMARYSHOW for drop ORDERS(FULLCODE) */
ALTER PROCEDURE SUMMARYSHOW(ACLIENTID BIGINT,
DATEFROM TIMESTAMP,
DATETO TIMESTAMP)
 RETURNS(VOLUME VARCHAR(15),
QUANTITY VARCHAR(15),
NOTE VARCHAR(50),
PERIOD VARCHAR(20),
JUNK INTEGER,
AWAIT INTEGER,
CODE VARCHAR(84),
CODECR VARCHAR(84),
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
BASECOST VARCHAR(60),
PRICENAME VARCHAR(70),
REGIONNAME VARCHAR(25),
ORDERCOUNT INTEGER,
ORDERSCOREID BIGINT,
ORDERSORDERID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
DOC VARCHAR(20),
REGISTRYCOST NUMERIC(8,2),
VITALLYIMPORTANT INTEGER,
REQUESTRATIO INTEGER)
 AS
 BEGIN EXIT; END
;

/* Empty SUMMARYSHOWSEND for drop ORDERS(FULLCODE) */
ALTER PROCEDURE SUMMARYSHOWSEND(ACLIENTID BIGINT,
DATEFROM TIMESTAMP,
DATETO TIMESTAMP)
 RETURNS(VOLUME VARCHAR(15),
QUANTITY VARCHAR(15),
NOTE VARCHAR(50),
PERIOD VARCHAR(20),
JUNK INTEGER,
AWAIT INTEGER,
CODE VARCHAR(84),
CODECR VARCHAR(84),
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
BASECOST VARCHAR(60),
PRICENAME VARCHAR(70),
REGIONNAME VARCHAR(25),
ORDERCOUNT INTEGER,
ORDERSCOREID BIGINT,
ORDERSORDERID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
DOC VARCHAR(20),
REGISTRYCOST NUMERIC(8,2),
VITALLYIMPORTANT INTEGER,
REQUESTRATIO INTEGER)
 AS
 BEGIN EXIT; END
;


ALTER TABLE ORDERS DROP FULLCODE;

ALTER TABLE SYNONYMFIRMCR DROP PRICECODE;

ALTER TABLE SYNONYMS DROP FULLCODE;

ALTER TABLE SYNONYMS DROP SHORTCODE;

ALTER TABLE SYNONYMS DROP PRICECODE;


RECONNECT;

/* Drop tables... */
DROP TABLE PRICEAVG;


/* Create Procedure... */

CREATE PROCEDURE CREATEEXTPRODUCTS(PATH VARCHAR(255))
 AS
 BEGIN EXIT; END
;


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


/* Create index... */
CREATE INDEX IDX_CORE_JUNK ON CORE(PRODUCTID, JUNK);

CREATE INDEX IDX_ORDERS_PRODUCTID ON ORDERS(PRODUCTID);

CREATE INDEX IDX_ORDERSH_ORDERDATE ON ORDERSH(ORDERDATE);

CREATE INDEX IDX_ORDERSH_SENDDATE ON ORDERSH(SENDDATE);


/* Alter index (Drop, Create)... */
RECONNECT;

/* Drop: IDX_CORE_JUNK (TIdxData) */
DROP INDEX IDX_CORE_JUNK;

CREATE INDEX IDX_CORE_JUNK ON CORE(PRODUCTID, JUNK);


/* Create Primary Key... */
ALTER TABLE PRODUCTS ADD CONSTRAINT PK_PRODUCTS PRIMARY KEY (PRODUCTID);

/* Create Foreign Key... */
RECONNECT;

ALTER TABLE CORE ADD CONSTRAINT FK_CORE_PRODUCTID FOREIGN KEY (PRODUCTID) REFERENCES PRODUCTS (PRODUCTID) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE MINPRICES ADD CONSTRAINT FK_MINPRICES_PRODUCTID FOREIGN KEY (PRODUCTID) REFERENCES PRODUCTS (PRODUCTID) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE PRODUCTS ADD CONSTRAINT FK_PRODUCTS_CATALOGID FOREIGN KEY (CATALOGID) REFERENCES CATALOGS (FULLCODE) ON UPDATE CASCADE ON DELETE CASCADE;

/* Alter Procedure... */
/* Alter (COREINSERTFORMHEADERS) */

ALTER PROCEDURE COREINSERTFORMHEADERS AS
declare variable distinctfullcode bigint;
begin
  for
    select DISTINCT CATALOGS.FullCode
    from
      core
      inner join products on products.productid = core.productid
      inner join CATALOGS ON CATALOGS.FullCode = products.catalogid
    into
      :DistinctFullCode
  do
  begin
    insert into Core (ProductId, SynonymCode)
    select first 1 productid, -catalogid
    from
      products
    where
      products.catalogid = :DistinctFullCode;
  end
end
;

/* Alter (CORESHOWBYFIRM) */
ALTER PROCEDURE CORESHOWBYFIRM(APRICECODE BIGINT,
AREGIONCODE BIGINT,
ACLIENTID BIGINT)
 RETURNS(COREID BIGINT,
PRODUCTID BIGINT,
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
    inner join Core LCore on LCore.servercoreid = minprices.servercoreid and LCore.RegionCode = minprices.regioncode
    inner JOIN PricesData ON PricesData.PriceCode=LCore.pricecode
    inner JOIN Regions       ON MinPrices.RegionCode=Regions.RegionCode
    LEFT JOIN SynonymFirmCr ON CCore.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
    left join synonyms on CCore.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN Orders osbc ON osbc.ClientID = :AClientId and osbc.CoreId = CCore.CoreId
    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId
WHERE (CCore.PriceCode=:APriceCode) And (CCore.RegionCode=:ARegionCode)
into :CoreId,
    :productid,
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
PRODUCTID BIGINT,
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
    INNER JOIN Core ON Core.productid = products.productid
    left join Synonyms on Core.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Core.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
    LEFT JOIN PricesData ON Core.PriceCode=PricesData.PriceCode
    LEFT JOIN PricesRegionalData PRD ON (Core.RegionCode=PRD.RegionCode)
        AND (Core.PriceCode=PRD.PriceCode)
    LEFT JOIN ClientsDataN ON PricesData.FirmCode=ClientsDataN.FirmCode
    LEFT JOIN Regions ON Core.RegionCode=Regions.RegionCode
    LEFT JOIN Orders osbc ON osbc.clientid = :aclientid and osbc.CoreId = Core.CoreId
    LEFT JOIN OrdersH ON OrdersH.OrderId = osbc.OrderId
WHERE (Catalogs.FullCode=:ParentCode)
And (:ShowRegister = 1 Or (ClientsDataN.FirmCode<>:RegisterId))
into CoreId,
    :PriceCode,
    :RegionCode,
    :productid,
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
PRODUCTID BIGINT,
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
    INNER JOIN Core ON Core.productid = products.productid
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
    :ProductId,
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

/* Alter (CREATEEXTMINPRICES) */
ALTER PROCEDURE CREATEEXTMINPRICES(PATH VARCHAR(255))
 AS
begin
    execute statement 'Create Table EXTMINPRICES (
    PRODUCTID   FB_ID /* FB_ID = BIGINT NOT NULL */,
    REGIONCODE  fb_ref,
    SERVERCOREID fb_ref,
    SERVERMEMOID fb_REF);';
end
;

/* Alter (CREATEEXTSYNONYMFIRMCR) */
ALTER PROCEDURE CREATEEXTSYNONYMFIRMCR(PATH VARCHAR(255))
 AS
begin
  execute statement 'CREATE TABLE ExtSynonymFirmCr (
    SYNONYMFIRMCRCODE  FB_ID /* FB_ID = BIGINT NOT NULL */,
    SYNONYMNAME        FB_VC255 /* FB_VC255 = VARCHAR(255) */
);';
end
;

/* Alter (EXPIREDSSHOW) */
ALTER PROCEDURE EXPIREDSSHOW(TIMEZONEBIAS INTEGER,
ACLIENTID BIGINT,
ACOREID BIGINT)
 RETURNS(COREID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
PRODUCTID BIGINT,
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
    coalesce(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
    SynonymFirmCr.SynonymName AS SynonymFirm,
    Core.Await,
    PricesData.PriceName,
    addminute(PricesData.DatePrice, -:TimeZoneBias) AS DatePrice,
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
    LEFT JOIN Orders osbc ON osbc.clientid = :AClientId and osbc.CoreId=Core.CoreId
    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId
WHERE
    (Core.productid > 0)
and (Core.Junk = 1)
and ((:ACoreID is not null and Core.coreid = :ACoreID) or (:ACoreID is null))
into :CoreId,
    :PriceCode,
    :RegionCode,
    :productid,
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

/* Alter (MINPRICESINSERT) */
ALTER PROCEDURE MINPRICESINSERT AS
begin
  INSERT INTO MinPrices ( productid, RegionCode )
  select
    distinct c.productid, c.regioncode
  from
    core c
  where
        c.Synonymcode > 0
    and not exists(select * from minprices m where m.productid = c.productid and m.regioncode = c.regioncode);
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
    (osbc.clientid = :AClientID)
and (osbc.OrderCount > 0)
and (products.catalogid = :AFullCode)
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

/* Alter (SUMMARYSHOW) */
ALTER PROCEDURE SUMMARYSHOW(ACLIENTID BIGINT,
DATEFROM TIMESTAMP,
DATETO TIMESTAMP)
 RETURNS(VOLUME VARCHAR(15),
QUANTITY VARCHAR(15),
NOTE VARCHAR(50),
PERIOD VARCHAR(20),
JUNK INTEGER,
AWAIT INTEGER,
CODE VARCHAR(84),
CODECR VARCHAR(84),
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
BASECOST VARCHAR(60),
PRICENAME VARCHAR(70),
REGIONNAME VARCHAR(25),
ORDERCOUNT INTEGER,
ORDERSCOREID BIGINT,
ORDERSORDERID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
DOC VARCHAR(20),
REGISTRYCOST NUMERIC(8,2),
VITALLYIMPORTANT INTEGER,
REQUESTRATIO INTEGER)
 AS
begin
for SELECT Core.Volume,
    Core.Quantity,
    Core.Note,
    Core.Period,
    Core.Junk,
    Core.Await,
    Core.CODE,
    Core.CODECR,
    coalesce(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
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
    OrdersH.ClientId = :AClientId
and Orders.OrderId=OrdersH.OrderId
and Orders.OrderCount>0
and Core.CoreId=Orders.CoreId
and products.productid = orders.productid
and catalogs.fullcode = products.catalogid
and PricesData.PriceCode = OrdersH.PriceCode
and Regions.RegionCode = OrdersH.RegionCode
and ordersh.orderdate >= :datefrom
and ordersh.orderdate <= :dateTo
into :Volume,
    :Quantity,
    :Note,
    :Period,
    :Junk,
    :Await,
    :Code,
    :CodeCR,
    :SynonymName,
    :SynonymFirm,
    :BaseCost,
    :PriceName,
    :RegionName,
    :OrderCount,
    :OrdersCoreId,
    :OrdersOrderId,
    :PriceCode,
    :regioncode,
    :doc,
    :registrycost,
    :vitallyimportant,
    :requestratio
do
  suspend;
end
;

/* Alter (SUMMARYSHOWSEND) */
ALTER PROCEDURE SUMMARYSHOWSEND(ACLIENTID BIGINT,
DATEFROM TIMESTAMP,
DATETO TIMESTAMP)
 RETURNS(VOLUME VARCHAR(15),
QUANTITY VARCHAR(15),
NOTE VARCHAR(50),
PERIOD VARCHAR(20),
JUNK INTEGER,
AWAIT INTEGER,
CODE VARCHAR(84),
CODECR VARCHAR(84),
SYNONYMNAME VARCHAR(250),
SYNONYMFIRM VARCHAR(250),
BASECOST VARCHAR(60),
PRICENAME VARCHAR(70),
REGIONNAME VARCHAR(25),
ORDERCOUNT INTEGER,
ORDERSCOREID BIGINT,
ORDERSORDERID BIGINT,
PRICECODE BIGINT,
REGIONCODE BIGINT,
DOC VARCHAR(20),
REGISTRYCOST NUMERIC(8,2),
VITALLYIMPORTANT INTEGER,
REQUESTRATIO INTEGER)
 AS
begin
for SELECT '',
    '',
    '',
    '',
    Orders.Junk,
    Orders.Await,
    Orders.CODE,
    Orders.CODECR,
    coalesce(Synonyms.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName,
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
    OrdersH.ClientId = :AClientId
and Orders.OrderId=OrdersH.OrderId
and Orders.OrderCount>0
and Orders.CoreId is null
and products.productid = orders.productid
and catalogs.fullcode = products.catalogid
and PricesData.PriceCode = OrdersH.PriceCode
and Regions.RegionCode = OrdersH.RegionCode
and ordersh.orderdate >= :datefrom
and ordersh.orderdate <= :dateTo
into :Volume,
    :Quantity,
    :Note,
    :Period,
    :Junk,
    :Await,
    :Code,
    :CodeCR,
    :SynonymName,
    :SynonymFirm,
    :BaseCost,
    :PriceName,
    :RegionName,
    :OrderCount,
    :OrdersCoreId,
    :OrdersOrderId,
    :pricecode,
    :regioncode,
    :doc,
    :registrycost,
    :vitallyimportant,
    :requestratio
do
  suspend;
end
;

/* Alter (SYNONYMFIRMCRINSERT) */
ALTER PROCEDURE SYNONYMFIRMCRINSERT AS
begin
EXECUTE STATEMENT 'INSERT INTO SynonymFirmCr
(SynonymFirmCrCode, SynonymName)
SELECT SynonymFirmCrCode, SynonymName
FROM ExtSynonymFirmCr ESFC
WHERE Not Exists(SELECT SynonymFirmCrCode
                FROM SynonymFirmCr WHERE SynonymFirmCrCode=ESFC.SynonymFirmCrCode);';
end
;

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
      INSERT INTO ORDERS(ORDERID, CLIENTID, COREID, PRODUCTID, CODEFIRMCR, SYNONYMCODE, SYNONYMFIRMCRCODE, CODE, CODECR, SYNONYMNAME, SYNONYMFIRM, PRICE, AWAIT, JUNK, ORDERCOUNT )
        select :ORDERID, :CLIENTID, :COREID, c.PRODUCTID, c.CODEFIRMCR, c.SYNONYMCODE, c.SYNONYMFIRMCRCODE, c.CODE, c.CODECR, coalesce(s.SynonymName, catalogs.name || ' ' || catalogs.form) as SynonymName, sf.synonymname, c.basecost, c.AWAIT, c.JUNK, :ORDERCOUNT
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
;

/* Restore proc. body: CREATEEXTPRODUCTS */
ALTER PROCEDURE CREATEEXTPRODUCTS(PATH VARCHAR(255))
 AS
begin
  execute statement 'Create Table EXTPRODUCTS (
    PRODUCTID   FB_ID /* FB_ID = BIGINT NOT NULL */,
    CATALOGID  fb_ref);';
end
;

/* Create Views... */

/* Alter Procedure... */

update PROVIDER set mdbversion = 43 where id = 0;

commit work;