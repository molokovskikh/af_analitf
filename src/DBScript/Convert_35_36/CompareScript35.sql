SET AUTODDL ON;

RECONNECT;

ALTER TABLE CATALOGS DROP CONSTRAINT FK_CATALOGS_SECTIONID;

ALTER TABLE SECTIONS DROP CONSTRAINT PK_SECTIONS;

RECONNECT;

/* Declare UDF */
DECLARE EXTERNAL FUNCTION LPAD
CSTRING(255), INTEGER, CSTRING(1)
RETURNS CSTRING(255) FREE_IT
ENTRY_POINT 'IB_UDF_lpad' MODULE_NAME 'ib_udf';


/* Alter Procedure (Before Drop)... */

ALTER PROCEDURE CATALOGUPDATE AS
 BEGIN EXIT; END
;

ALTER PROCEDURE SECTIONDELETEALL AS
 BEGIN EXIT; END
;

ALTER PROCEDURE SECTIONUPDATE AS
 BEGIN EXIT; END
;

ALTER PROCEDURE TMPCATALOGDELETE AS
 BEGIN EXIT; END
;

ALTER PROCEDURE TMPSECTIONDELETE AS
 BEGIN EXIT; END
;


/* Drop Procedure... */

DROP PROCEDURE CATALOGDELETEHIDE;

DROP PROCEDURE CATALOGINSERT;

DROP PROCEDURE CATALOGUPDATE;

DROP PROCEDURE CREATEEXTSECTION;

DROP PROCEDURE MINPRICESSETPRICECODE;

DROP PROCEDURE SECTIONDELETE;

DROP PROCEDURE SECTIONDELETEALL;

DROP PROCEDURE SECTIONINSERT;

DROP PROCEDURE SECTIONUPDATE;

DROP PROCEDURE SYNONYMINSERT;

DROP PROCEDURE SYNONYMINSERTALL;

DROP PROCEDURE SYNONYMINSERTFORMHEADERS;

DROP PROCEDURE SYNONYMINSERTUNFOUNDED;

DROP PROCEDURE TMPCATALOGDELETE;

DROP PROCEDURE TMPCATALOGINSERT;

DROP PROCEDURE TMPSECTIONDELETE;

DROP PROCEDURE TMPSECTIONINSERT;


/* Drop Index... */
RECONNECT;

/* Drop: IDX_SECTIONS_SECTIONNAME (TIdxData) */
DROP INDEX IDX_SECTIONS_SECTIONNAME;


/* Create Table... */
CREATE TABLE CATALOGFARMGROUPS(ID FB_ID,
NAME FB_VC250,
DESCRIPTION BLOB SUB_TYPE 1 SEGMENT SIZE 80,
PARENTID FB_REF,
GROUPTYPE INTEGER);


CREATE TABLE CATALOGNAMES(ID FB_ID,
NAME FB_VC250,
LATINNAME FB_VC250,
DESCRIPTION BLOB SUB_TYPE 1 SEGMENT SIZE 80);



ALTER TABLE CATALOGS ADD VITALLYIMPORTANT FB_BOOLEAN;

ALTER TABLE CATALOGS ADD NEEDCOLD FB_BOOLEAN;

ALTER TABLE CATALOGS ADD FRAGILE FB_BOOLEAN;

ALTER TABLE CLIENTS ADD CALCULATELEADER FB_BOOLEAN;

ALTER TABLE CORE ADD REGISTRYCOST NUMERIC(8,2);

ALTER TABLE CORE ADD VITALLYIMPORTANT FB_BOOLEAN;

ALTER TABLE CORE ADD REQUESTRATIO INTEGER;

/* Drop table-fields... */
ALTER TABLE CATALOGS DROP SECTIONID;

ALTER TABLE CATALOGS DROP ATC4;

ALTER TABLE CATALOGS DROP FTG;

ALTER TABLE CATALOGS DROP MNN;

/* Empty CLIENTSUPDATE for drop CLIENTS(ADDRESS) */

ALTER PROCEDURE CLIENTSUPDATE AS
 BEGIN EXIT; END
;


ALTER TABLE CLIENTS DROP ADDRESS;

ALTER TABLE CLIENTS DROP PHONE;

ALTER TABLE CLIENTS DROP FORCOUNT;

ALTER TABLE CLIENTS DROP EMAIL;

ALTER TABLE CLIENTS DROP USEEXCESS;

ALTER TABLE CLIENTS DROP LEADFROMBASIC;


RECONNECT;

/* Drop tables... */
DROP TABLE SECTIONS;

DROP TABLE TMPCATALOG;

DROP TABLE TMPSECTION;


/* Create Procedure... */

CREATE PROCEDURE CATALOGFARMGROUPS_IU(ID BIGINT,
NAME VARCHAR(250),
DESCRIPTION BLOB SUB_TYPE 1 SEGMENT SIZE 80,
PARENTID BIGINT,
GROUPTYPE INTEGER)
 AS
 BEGIN EXIT; END
;

CREATE PROCEDURE CATALOGFARMGROUPSDELETE AS
 BEGIN EXIT; END
;

CREATE PROCEDURE CATALOGNAMES_IU(ID BIGINT,
NAME VARCHAR(250),
LATINNAME VARCHAR(250),
DESCRIPTION BLOB SUB_TYPE 1 SEGMENT SIZE 80)
 AS
 BEGIN EXIT; END
;

CREATE PROCEDURE CATALOGNAMESDELETE AS
 BEGIN EXIT; END
;

CREATE PROCEDURE CATALOGS_IU(FULLCODE BIGINT,
SHORTCODE BIGINT,
NAME VARCHAR(250),
FORM VARCHAR(250),
VITALLYIMPORTANT INTEGER,
NEEDCOLD INTEGER,
FRAGILE INTEGER)
 AS
 BEGIN EXIT; END
;

CREATE PROCEDURE CLIENTS_IU(CLIENTID BIGINT,
NAME VARCHAR(50),
REGIONCODE BIGINT,
EXCESS INTEGER,
DELTAMODE SMALLINT,
MAXUSERS INTEGER,
REQMASK BIGINT,
TECHSUPPORT VARCHAR(255),
CALCULATELEADER INTEGER)
 AS
 BEGIN EXIT; END
;

CREATE PROCEDURE CREATEEXTCATALOGFARMGROUPS(PATH VARCHAR(255))
 AS
 BEGIN EXIT; END
;

CREATE PROCEDURE CREATEEXTCATALOGNAMES(PATH VARCHAR(255))
 AS
 BEGIN EXIT; END
;

CREATE PROCEDURE CREATEEXTCATFARMGROUPSDEL(PATH VARCHAR(255))
 AS
 BEGIN EXIT; END
;


/* Create Primary Key... */

ALTER TABLE CATALOGFARMGROUPS ADD CONSTRAINT PK_CATALOGFARMGROUPS PRIMARY KEY (ID);

ALTER TABLE CATALOGNAMES ADD CONSTRAINT PK_CATALOGNAMES PRIMARY KEY (ID);

/* Create Foreign Key... */
RECONNECT;

ALTER TABLE CATALOGFARMGROUPS ADD CONSTRAINT FK_CATALOG_FARM_GROUPS_PARENT FOREIGN KEY (PARENTID) REFERENCES CATALOGFARMGROUPS (ID) ON UPDATE CASCADE ON DELETE CASCADE;

/* Alter Procedure... */
/* Alter (CLIENTSINSERT) */

ALTER PROCEDURE CLIENTSINSERT AS
begin 
EXECUTE STATEMENT
'INSERT INTO Clients (
    ClientId,
    Name,
    RegionCode,
    MaxUsers, Excess, DeltaMode, ReqMask, TechSupport, LeadFromBasic )
SELECT ClientId,
    rtrim(Name),
    RegionCode,
    MaxUsers, Excess, DeltaMode, ReqMask, rtrim(TechSupport), LeadFromBasic
FROM ExtClients
WHERE NOT Exists(SELECT ClientId FROM Clients WHERE ClientId=ExtClients.ClientId);';
end
;

/* Alter (CLIENTSUPDATE) */
ALTER PROCEDURE CLIENTSUPDATE AS
declare variable clientid bigint;
declare variable name varchar(50);
declare variable regioncode bigint;
declare variable maxusers integer;
declare variable excess integer;
declare variable deltamode smallint;
declare variable reqmask bigint;
declare variable techsupport varchar(255);
begin
for select tc.clientid, rtrim(tc.name), tc.regioncode,
           tc.maxusers, tc.excess, tc.deltamode, tc.reqmask, rtrim(tc.techsupport)
    from tmpclients TC
    into :clientid, :name, :regioncode, :maxusers, :excess, :deltamode, :reqmask, :techsupport
    do
UPDATE Clients C
    SET Name = :Name,
         RegionCode = :RegionCode,
         MaxUsers = :MaxUsers,
         Excess = :Excess,
         DeltaMode = :DeltaMode,
         ReqMask = :ReqMask,
         TechSupport = :TechSupport
where C.ClientId = :ClientId;
end
;

/* Alter (COREDELETENEWPRICES) */
ALTER PROCEDURE COREDELETENEWPRICES AS
DECLARE VARIABLE PRICECODE BIGINT;
begin
for EXECUTE STATEMENT 'SELECT cast(PriceCode as BIGINT) FROM ExtPricesData where Fresh = ''1'''
into :pricecode
do
begin
  delete from core where PriceCode = :PriceCode;
end
end
;

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
    left join Core LCore on LCore.servercoreid = minprices.servercoreid
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
    LEFT JOIN OrdersShowByClient(:aclientid) osbc ON Core.CoreId=osbc.CoreId
    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId
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
    LEFT JOIN Orders osbc ON osbc.clientid = :aclient and Core.CoreId=osbc.CoreId
    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId
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

/* Alter (CREATEEXTCATALOG) */
ALTER PROCEDURE CREATEEXTCATALOG(PATH VARCHAR(255))
 AS
begin
  execute statement 'Create Table ExtCatalog (
    FULLCODE   FB_ID /* FB_ID = BIGINT NOT NULL */,
    SHORTCODE  FB_ID /* FB_ID = BIGINT NOT NULL */,
    NAME       FB_VC255 /* FB_VC250 = VARCHAR(250) */,
    FORM       FB_VC255 /* FB_VC250 = VARCHAR(250) */);';
end
;

/* Alter (CREATEEXTCATALOGCURRENCY) */
ALTER PROCEDURE CREATEEXTCATALOGCURRENCY(PATH VARCHAR(255))
 AS
begin
execute statement 'CREATE TABLE ExtCatalogCurrency (
    CURRENCY  VARCHAR(6) CHARACTER SET WIN1251 NOT NULL,
    EXCHANGE  NUMERIC(18,4) NOT NULL
);';
end
;

/* Alter (CREATEEXTCATDEL) */
ALTER PROCEDURE CREATEEXTCATDEL(PATH VARCHAR(255))
 AS
begin
  execute statement 'Create Table Extcatdel
(fullcode FB_REF);';
end
;

/* Alter (CREATEEXTCLIENTS) */
ALTER PROCEDURE CREATEEXTCLIENTS(PATH VARCHAR(255))
 AS
begin
execute statement 'CREATE TABLE ExtClients (
    CLIENTID       FB_ID /* FB_ID = BIGINT NOT NULL */,
    NAME           VARCHAR(50) CHARACTER SET WIN1251 NOT NULL,
    REGIONCODE     FB_ID /* FB_ID = BIGINT NOT NULL */,
    EXCESS         INTEGER NOT NULL,
    DELTAMODE      SMALLINT,
    MAXUSERS       INTEGER NOT NULL,
    REQMASK        BIGINT,
    TECHSUPPORT    VARCHAR(255) CHARACTER SET WIN1251,
    CALCULATELEADER  SMALLINT
);';
end
;

/* Alter (CREATEEXTCLIENTSDATAN) */
ALTER PROCEDURE CREATEEXTCLIENTSDATAN(PATH VARCHAR(255))
 AS
begin
execute statement 'CREATE TABLE ExtClientsDataN (
    FIRMCODE            FB_ID /* FB_ID = BIGINT NOT NULL */,
    FULLNAME            VARCHAR(40) CHARACTER SET WIN1251,
    FAX                 VARCHAR(20) CHARACTER SET WIN1251,
    PHONE               VARCHAR(20) CHARACTER SET WIN1251,
    MAIL                VARCHAR(50) CHARACTER SET WIN1251,
    ADDRESS             VARCHAR(100) CHARACTER SET WIN1251,
    BUSSSTOP            VARCHAR(100) CHARACTER SET WIN1251,
    BussInfo char(100),
    URL                 VARCHAR(35) CHARACTER SET WIN1251,
    ORDERMANAGERNAME    VARCHAR(100) CHARACTER SET WIN1251,
    ORDERMANAGERPHONE   VARCHAR(35) CHARACTER SET WIN1251,
    ORDERMANAGERMAIL    VARCHAR(50) CHARACTER SET WIN1251,
    CLIENTMANAGERNAME   VARCHAR(100) CHARACTER SET WIN1251,
    CLIENTMANAGERPHONE  VARCHAR(35) CHARACTER SET WIN1251,
    CLIENTMANAGERMAIL   VARCHAR(50) CHARACTER SET WIN1251
);';

end
;

/* Alter (CREATEEXTCORE) */
ALTER PROCEDURE CREATEEXTCORE(PATH VARCHAR(255))
 AS
begin
execute statement 'CREATE TABLE ExtCore (
    PRICECODE          FB_REF /* FB_REF = BIGINT */,
    REGIONCODE         FB_REF /* FB_REF = BIGINT */,
    FULLCODE           FB_ID /* FB_ID = BIGINT NOT NULL */,
    SHORTCODE          FB_ID /* FB_ID = BIGINT NOT NULL */,
    CODEFIRMCR         FB_REF /* FB_REF = BIGINT */,
    SYNONYMCODE        FB_REF /* FB_REF = BIGINT */,
    SYNONYMFIRMCRCODE  FB_REF /* FB_REF = BIGINT */,
    CODE               VARCHAR(76) CHARACTER SET WIN1251,
    CODECR             VARCHAR(76) CHARACTER SET WIN1251,
    UNIT               VARCHAR(15) CHARACTER SET WIN1251,
    VOLUME             VARCHAR(15) CHARACTER SET WIN1251,
    JUNK               FB_BOOLEAN /* FB_BOOLEAN = INTEGER DEFAULT 0 NOT NULL CHECK (VALUE IN (0, 1)) */,
    AWAIT              FB_BOOLEAN /* FB_BOOLEAN = INTEGER DEFAULT 0 NOT NULL CHECK (VALUE IN (0, 1)) */,
    QUANTITY           VARCHAR(15) CHARACTER SET WIN1251,
    NOTE               VARCHAR(50) CHARACTER SET WIN1251,
    PERIOD             VARCHAR(20) CHARACTER SET WIN1251,
    DOC                VARCHAR(20) CHARACTER SET WIN1251,
    BASECOST           NUMERIC(18,4)
);';
end
;

/* Alter (CREATEEXTPRICESDATA) */
ALTER PROCEDURE CREATEEXTPRICESDATA(PATH VARCHAR(255))
 AS
begin
execute statement 'CREATE TABLE ExtPricesData (
    FIRMCODE          FB_ID /* FB_ID = BIGINT NOT NULL */,
    PRICECODE         FB_ID /* FB_ID = BIGINT NOT NULL */,
    PRICENAME         VARCHAR(70) CHARACTER SET WIN1251,
    ALLOWINTEGR       FB_BOOLEAN /* FB_BOOLEAN = INTEGER DEFAULT 0 NOT NULL CHECK (VALUE IN (0, 1)) */,
    PRICEINFO         BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    DATEPRICE         TIMESTAMP,
    FRESH             FB_BOOLEAN /* FB_BOOLEAN = INTEGER DEFAULT 0 NOT NULL CHECK (VALUE IN (0, 1)) */,
    PRICEFMT          VARCHAR(3) CHARACTER SET WIN1251,
    DELIMITER         VARCHAR(3) CHARACTER SET WIN1251,
    PARENTSYNONYM     FB_REF /* FB_REF = BIGINT */,
    NAMEMASK          VARCHAR(255) CHARACTER SET WIN1251,
    FORBWORDS         VARCHAR(255) CHARACTER SET WIN1251,
    JUNKPOS           VARCHAR(10) CHARACTER SET WIN1251,
    AWAITPOS          VARCHAR(10) CHARACTER SET WIN1251,
    STARTLINE         INTEGER,
    LISTNAME          VARCHAR(50) CHARACTER SET WIN1251,
    TXTCODEBEGIN      SMALLINT,
    TXTCODEEND        SMALLINT,
    TXTCODECRBEGIN    SMALLINT,
    TXTCODECREND      SMALLINT,
    TXTNAMEBEGIN      SMALLINT,
    TXTNAMEEND        SMALLINT,
    TXTFIRMCRBEGIN    SMALLINT,
    TXTFIRMCREND      SMALLINT,
    TXTBASECOSTBEGIN  SMALLINT,
    TXTBASECOSTEND    SMALLINT,
    TXTUNITBEGIN      SMALLINT,
    TXTUNITEND        SMALLINT,
    TXTVOLUMEBEGIN    SMALLINT,
    TXTVOLUMEEND      SMALLINT,
    TXTQUANTITYBEGIN  SMALLINT,
    TXTQUANTITYEND    SMALLINT,
    TXTNOTEBEGIN      SMALLINT,
    TXTNOTEEND        SMALLINT,
    TXTPERIODBEGIN    SMALLINT,
    TXTPERIODEND      SMALLINT,
    TXTDOCBEGIN       SMALLINT,
    TXTDOCEND         SMALLINT,
    TXTJUNKBEGIN      SMALLINT,
    TXTJUNKEND        SMALLINT,
    TXTAWAITBEGIN     SMALLINT,
    TXTAWAITEND       SMALLINT,
    FCODE             VARCHAR(20) CHARACTER SET WIN1251,
    FCODECR           VARCHAR(20) CHARACTER SET WIN1251,
    FNAME1            VARCHAR(20) CHARACTER SET WIN1251,
    FNAME2            VARCHAR(20) CHARACTER SET WIN1251,
    FNAME3            VARCHAR(20) CHARACTER SET WIN1251,
    FFIRMCR           VARCHAR(20) CHARACTER SET WIN1251,
    FBASECOST         VARCHAR(20) CHARACTER SET WIN1251,
    FUNIT             VARCHAR(20) CHARACTER SET WIN1251,
    FVOLUME           VARCHAR(20) CHARACTER SET WIN1251,
    FQUANTITY         VARCHAR(20) CHARACTER SET WIN1251,
    FNOTE             VARCHAR(20) CHARACTER SET WIN1251,
    FPERIOD           VARCHAR(20) CHARACTER SET WIN1251,
    FDOC              VARCHAR(20) CHARACTER SET WIN1251,
    FJUNK             VARCHAR(20) CHARACTER SET WIN1251,
    FAWAIT            VARCHAR(20) CHARACTER SET WIN1251,
    PROTEK            FB_BOOLEAN /* FB_BOOLEAN = INTEGER DEFAULT 0 NOT NULL CHECK (VALUE IN (0, 1)) */
);';
end
;

/* Alter (CREATEEXTPRICESREGIONALDATA) */
ALTER PROCEDURE CREATEEXTPRICESREGIONALDATA(PATH VARCHAR(255))
 AS
begin
  execute statement 'CREATE TABLE ExtPricesRegionalData (
    PRICECODE   FB_ID /* FB_ID = BIGINT NOT NULL */,
    REGIONCODE  FB_ID /* FB_ID = BIGINT NOT NULL */,
    STORAGE     FB_BOOLEAN /* FB_BOOLEAN = INTEGER DEFAULT 0 NOT NULL CHECK (VALUE IN (0, 1)) */,
    UPCOST      NUMERIC(18,4),
    MINREQ      INTEGER,
    ENABLED     FB_BOOLEAN, /* FB_BOOLEAN = INTEGER DEFAULT 0 NOT NULL CHECK (VALUE IN (0, 1)) */
    INJOB       FB_BOOLEAN /* FB_BOOLEAN = INTEGER DEFAULT 0 NOT NULL CHECK (VALUE IN (0, 1)) */,
    ALLOWCOSTCORR FB_BOOLEAN /* FB_BOOLEAN = INTEGER DEFAULT 0 NOT NULL CHECK (VALUE IN (0, 1)) */,
    CONTROLMINREQ FB_BOOLEAN
);';
end
;

/* Alter (CREATEEXTREGIONALDATA) */
ALTER PROCEDURE CREATEEXTREGIONALDATA(PATH VARCHAR(255))
 AS
begin
  execute statement 'CREATE TABLE ExtRegionalData (
    FIRMCODE       FB_ID /* FB_ID = BIGINT NOT NULL */,
    REGIONCODE     FB_ID /* FB_ID = BIGINT NOT NULL */,
    SUPPORTPHONE   VARCHAR(20) CHARACTER SET WIN1251,
    ADMINMAIL      VARCHAR(50) CHARACTER SET WIN1251,
    CONTACTINFO    BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    OPERATIVEINFO  BLOB SUB_TYPE 1 SEGMENT SIZE 80
);';
end
;

/* Alter (CREATEEXTREGIONS) */
ALTER PROCEDURE CREATEEXTREGIONS(PATH VARCHAR(255))
 AS
begin
  execute statement 'CREATE TABLE ExtRegions (
    REGIONCODE  FB_ID /* FB_ID = BIGINT NOT NULL */,
    REGIONNAME  VARCHAR(25) CHARACTER SET WIN1251
);';
end
;

/* Alter (CREATEEXTREJECTS) */
ALTER PROCEDURE CREATEEXTREJECTS(PATH VARCHAR(255))
 AS
begin
  execute statement 'Create Table ExtRejects
(FirmCr char(150),
CountryCr char(150),
FullName char(254),
Series char(50),
LetterNo char(50),
LetterDate char(10),
LaboratoryName char(200),
CauseRejects BLOB SUB_TYPE 1 SEGMENT SIZE 80);';
end
;

/* Alter (CREATEEXTSYNONYM) */
ALTER PROCEDURE CREATEEXTSYNONYM(PATH VARCHAR(255))
 AS
begin
  execute statement 'CREATE TABLE ExtSynonym (
    SYNONYMCODE  FB_ID /* FB_ID = BIGINT NOT NULL */,
    SYNONYMNAME  FB_VC255 /* FB_VC255 = VARCHAR(255) */,
    FULLCODE     FB_REF /* FB_REF = BIGINT */,
    SHORTCODE    FB_REF /* FB_REF = BIGINT */,
    PRICECODE    FB_REF /* FB_REF = BIGINT */
);';
end
;

/* Alter (CREATEEXTSYNONYMFIRMCR) */
ALTER PROCEDURE CREATEEXTSYNONYMFIRMCR(PATH VARCHAR(255))
 AS
begin
  execute statement 'CREATE TABLE ExtSynonymFirmCr (
    SYNONYMFIRMCRCODE  FB_ID /* FB_ID = BIGINT NOT NULL */,
    SYNONYMNAME        FB_VC255 /* FB_VC255 = VARCHAR(255) */,
    PRICECODE          FB_REF /* FB_REF = BIGINT */
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
REQUESTRATIO INTEGER)
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
    Core.requestratio
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
    :requestratio
do
  suspend;
end
;

/* Alter (GETWAREDATA) */
ALTER PROCEDURE GETWAREDATA(AFULLCODE BIGINT,
ACLIENTID BIGINT)
 RETURNS(NAME VARCHAR(250),
FORM VARCHAR(250),
PRICEAVG NUMERIC(18,2))
 AS
begin
for  SELECT
    CATALOGS.Name,
    CATALOGS.Form,
    0 AS PriceAvg
   FROM
    (CATALOGS LEFT JOIN OrdersShowByClient(:AClientId) osbc ON CATALOGS.FullCode=osbc.FullCode)
    LEFT JOIN OrdersH ON osbc.OrderId=OrdersH.OrderId
  WHERE
    (CATALOGS.FullCode=:AFullCode)
    And ( (OrdersH.Closed = 1) or (OrdersH.Closed Is Null) )
    And (( ((extract(year from current_date) - extract(year from OrdersH.OrderDate))* 12 + extract(month
from current_date) - extract(month from OrdersH.OrderDate)) < 6) Or (OrdersH.OrderDate Is Null))
  GROUP BY CATALOGS.Name, CATALOGS.Form
  into
    :Name,
    :Form,
    :PriceAvg
do
  suspend;
end
;

/* Alter (MINPRICESDELETE) */
ALTER PROCEDURE MINPRICESDELETE AS
begin
update
  MinPrices
set
  minprice = null,
  pricecode = null;
end
;

/* Alter (MINPRICESINSERT) */
ALTER PROCEDURE MINPRICESINSERT AS
begin
  INSERT INTO MinPrices ( FullCode, RegionCode )
  select
    distinct c.fullcode, c.regioncode
  from
    core c
  where
        c.Synonymcode > 0
    and not exists(select * from minprices m where m.fullcode = c.fullcode and m.regioncode = c.regioncode);
end
;

/* empty dependent procedure body */
/* Clear: ORDERSINFO2 for: ORDERSINFO1 */
ALTER PROCEDURE ORDERSINFO2(ACLIENTID BIGINT)
 RETURNS(ORDERSCOUNT INTEGER,
POSITIONS INTEGER,
SUMORDER NUMERIC(18,2))
 AS
 BEGIN EXIT; END
;

/* Alter (ORDERSINFO1) */
ALTER PROCEDURE ORDERSINFO1(ACLIENTID BIGINT)
 RETURNS(ORDERID BIGINT,
POSITIONS INTEGER,
SUMORDER NUMERIC(18,2))
 AS
begin
for SELECT OrdersH.OrderId ,
    Count(*) AS Positions,
    Sum (osbc.OrderCount * 0) AS SumOrder
FROM ((OrdersH INNER JOIN OrdersShowByClient(:AClientId) osbc ON OrdersH.orderid=osbc.OrderId)
    INNER JOIN PricesRegionalData PRD ON (PRD.RegionCode=OrdersH.RegionCode)
    AND (PRD.PriceCode=OrdersH.PriceCode))
    LEFT JOIN PricesData ON PricesData.PriceCode=PRD.PriceCode
WHERE OrdersH.Closed <> 1
    AND (osbc.OrderCount>0)
GROUP BY OrdersH.OrderId
into :orderID,
    :Positions,
    :SumOrder
do
  suspend;
end
;

/* Alter (ORDERSINFO2) */
ALTER PROCEDURE ORDERSINFO2(ACLIENTID BIGINT)
 RETURNS(ORDERSCOUNT INTEGER,
POSITIONS INTEGER,
SUMORDER NUMERIC(18,2))
 AS
begin
for SELECT Count(*) AS OrdersCount,
    Sum(OrdersInfo1.Positions) AS Positions,
    Sum(OrdersInfo1.SumOrder) AS SumOrder
FROM OrdersInfo1(:AClientID)
into :OrdersCount,
    :Positions,
    :SumOrder
do
  suspend;
end
;

/* Alter (ORDERSINFO3) */
ALTER PROCEDURE ORDERSINFO3(ACLIENTID BIGINT,
APRICECODE BIGINT,
AREGIONCODE BIGINT)
 RETURNS(POSITIONS INTEGER,
SUMORDER NUMERIC(18,2))
 AS
begin
for select
    Count(*) AS Positions,
    Sum (orders.OrderCount * 0) AS SumOrder
from
  ORDERSHSHOWCURRENT(:AClientId, :apricecode,  :ARegionCode) osc
  inner join orders on orders.orderid = osc.orderid
WHERE (orders.OrderCount>0)
into
    :Positions,
    :SumOrder
do
  suspend;
end
;

/* Alter (ORDERSSHOW) */
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
begin
For SELECT Orders.OrderId,
    Orders.ClientId,
    Orders.CoreId,
    Orders.fullcode,
    Orders.codefirmcr,
    Orders.synonymcode,
    Orders.synonymfirmcrcode,
    Orders.code,
    Orders.codecr,
    Orders.synonymname,
    Orders.synonymfirm,
    Orders.price,
    Orders.await,
    Orders.junk,
    Orders.ordercount,
    0*Orders.OrderCount AS SumOrder
FROM Orders
WHERE (Orders.OrderId=:AOrderId AND OrderCount>0)
ORDER BY SynonymName, SynonymFirm
into
    :OrderId,
    :ClientId,
    :CoreId,
    :fullcode,
    :codefirmcr,
    :synonymcode,
    :SynonymFirmCrCode,
    :code,
    :codecr,
    :synonymname,
    :synonymfirm,
    :price,
    :await,
    :junk,
    :ordercount,
    :SumOrder
do
  suspend;
end
;

/* Alter (ORDERSSHOWFORMSUMMARY) */
ALTER PROCEDURE ORDERSSHOWFORMSUMMARY(AFULLCODE BIGINT,
ACLIENTID BIGINT)
 RETURNS(PRICEAVG NUMERIC(18,2))
 AS
begin
for SELECT 
  Avg(0) AS PriceAvg
FROM Orders INNER JOIN OrdersH ON OrdersH.OrderId=Orders.OrderId
WHERE Orders.FullCode=:AFullCode
    And Orders.OrderCount>0
    And (OrdersH.ClientId=:AClientId) And ( ((extract(year from current_date) - extract(year from OrdersH.OrderDate))* 12 + extract(month
from current_date) - extract(month from OrdersH.OrderDate)) < 6)
    AND (OrdersH.Closed = 1 OR
    (OrdersH.Closed IS NULL) )
into :PriceAvg
do
  suspend;
when any do
begin
  PriceAvg = null;
end
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
  SELECT Count(*), 
    Sum(0*Orders.OrderCount) 
     FROM Orders
        INNER JOIN OrdersH ON Orders.OrderId=OrdersH.OrderId
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

/* Alter (SUMMARYHSHOW) */
ALTER PROCEDURE SUMMARYHSHOW(ACLIENTID BIGINT)
 RETURNS(COUNTORDER INTEGER,
SUMORDER NUMERIC(18,2))
 AS
begin
for SELECT Count(*) AS CountOrder,
    Sum(0 * Orders.OrderCount) AS SumOrder
FROM Orders INNER JOIN OrdersH ON Orders.OrderId=OrdersH.OrderId
WHERE OrdersH.ClientId=:AClientId
    AND OrdersH.Closed <> 1
    And Orders.OrderCount > 0
into :CountOrder,
    :SumOrder
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
    Orders
    left join Synonyms on Orders.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Orders.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
WHERE
    OrdersH.ClientId = :AClientId
and Orders.OrderId=OrdersH.OrderId
and Orders.OrderCount>0
and Core.CoreId=Orders.CoreId
and catalogs.fullcode = orders.fullcode
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
    Orders
    left join Synonyms on Orders.SynonymCode=Synonyms.SynonymCode
    LEFT JOIN SynonymFirmCr ON Orders.SynonymFirmCrCode=SynonymFirmCr.SynonymFirmCrCode
WHERE
    OrdersH.ClientId = :AClientId
and Orders.OrderId=OrdersH.OrderId
and Orders.OrderCount>0
and Orders.CoreId is null
and catalogs.fullcode = orders.fullcode
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

/* Restore procedure body: CATALOGFARMGROUPS_IU */
ALTER PROCEDURE CATALOGFARMGROUPS_IU(ID BIGINT,
NAME VARCHAR(250),
DESCRIPTION BLOB SUB_TYPE 1 SEGMENT SIZE 80,
PARENTID BIGINT,
GROUPTYPE INTEGER)
 AS
begin
  if (exists(select id from catalogfarmgroups where (id = :id))) then
    update catalogfarmgroups
    set name = :name,
        description = :description,
        parentid = :parentid,
        grouptype = :grouptype
    where (id = :id);
  else
    insert into catalogfarmgroups (
        id,
        name,
        description,
        parentid,
        grouptype)
    values (
        :id,
        :name,
        :description,
        :parentid,
        :grouptype);
end
;

/* Restore procedure body: CATALOGFARMGROUPSDELETE */
ALTER PROCEDURE CATALOGFARMGROUPSDELETE AS
begin
  delete from CATALOGFARMGROUPS;
end
;

/* Restore procedure body: CATALOGNAMES_IU */
ALTER PROCEDURE CATALOGNAMES_IU(ID BIGINT,
NAME VARCHAR(250),
LATINNAME VARCHAR(250),
DESCRIPTION BLOB SUB_TYPE 1 SEGMENT SIZE 80)
 AS
begin
  if (exists(select id from catalognames where (id = :id))) then
    update catalognames
    set name = :name,
        latinname = :latinname,
        description = :description
    where (id = :id);
  else
    insert into catalognames (
        id,
        name,
        latinname,
        description)
    values (
        :id,
        :name,
        :latinname,
        :description);
end
;

/* Restore procedure body: CATALOGNAMESDELETE */
ALTER PROCEDURE CATALOGNAMESDELETE AS
begin
  DELETE FROM catalognames;
end
;

/* Restore procedure body: CATALOGS_IU */
ALTER PROCEDURE CATALOGS_IU(FULLCODE BIGINT,
SHORTCODE BIGINT,
NAME VARCHAR(250),
FORM VARCHAR(250),
VITALLYIMPORTANT INTEGER,
NEEDCOLD INTEGER,
FRAGILE INTEGER)
 AS
begin
  if (exists(select fullcode from catalogs where (fullcode = :fullcode))) then
    update catalogs
    set shortcode = :shortcode,
        name = :name,
        form = :form,
        vitallyimportant = :vitallyimportant,
        needcold = :needcold,
        fragile = :fragile
    where (fullcode = :fullcode);
  else
    insert into catalogs (
        fullcode,
        shortcode,
        name,
        form,
        vitallyimportant,
        needcold,
        fragile)
    values (
        :fullcode,
        :shortcode,
        :name,
        :form,
        :vitallyimportant,
        :needcold,
        :fragile);
end
;

/* Restore procedure body: CLIENTS_IU */
ALTER PROCEDURE CLIENTS_IU(CLIENTID BIGINT,
NAME VARCHAR(50),
REGIONCODE BIGINT,
EXCESS INTEGER,
DELTAMODE SMALLINT,
MAXUSERS INTEGER,
REQMASK BIGINT,
TECHSUPPORT VARCHAR(255),
CALCULATELEADER INTEGER)
 AS
begin
  if (exists(select clientid from clients where (clientid = :clientid))) then
    update clients
    set name = :name,
        regioncode = :regioncode,
        excess = :excess,
        deltamode = :deltamode,
        maxusers = :maxusers,
        reqmask = :reqmask,
        techsupport = :techsupport,
        calculateleader = :calculateleader
    where (clientid = :clientid);
  else
    insert into clients (
        clientid,
        name,
        regioncode,
        excess,
        deltamode,
        maxusers,
        reqmask,
        techsupport,
        calculateleader)
    values (
        :clientid,
        :name,
        :regioncode,
        :excess,
        :deltamode,
        :maxusers,
        :reqmask,
        :techsupport,
        :calculateleader);
end
;

/* Restore procedure body: CREATEEXTCATALOGFARMGROUPS */
ALTER PROCEDURE CREATEEXTCATALOGFARMGROUPS(PATH VARCHAR(255))
 AS
begin
execute statement 'CREATE TABLE ExtCATALOGFARMGROUPS (
  ID FB_ID,
  Name fb_vc250,
  Description blob sub_type 1 segment size 80,
  ParentID fb_ref,
  GroupType integer
);';
end
;

/* Restore procedure body: CREATEEXTCATALOGNAMES */
ALTER PROCEDURE CREATEEXTCATALOGNAMES(PATH VARCHAR(255))
 AS
begin
execute statement 'CREATE TABLE  extcatalognames
(
  ID FB_ID,
  Name fb_vc250,
  LatinName fb_vc250,
  Description blob sub_type 1 segment size 80);';
end
;

/* Restore procedure body: CREATEEXTCATFARMGROUPSDEL */
ALTER PROCEDURE CREATEEXTCATFARMGROUPSDEL(PATH VARCHAR(255))
 AS
begin
execute statement 'CREATE TABLE ExtCATFARMGROUPSDEL (
  ID FB_ID
);'; 
end
;

/* Alter Procedure... */

ALTER TABLE CATALOGS ALTER COLUMN FULLCODE POSITION 1;

ALTER TABLE CATALOGS ALTER COLUMN SHORTCODE POSITION 2;

ALTER TABLE CATALOGS ALTER COLUMN NAME POSITION 3;

ALTER TABLE CATALOGS ALTER COLUMN FORM POSITION 4;

ALTER TABLE CATALOGS ALTER COLUMN COREEXISTS POSITION 5;

ALTER TABLE CATALOGS ALTER COLUMN VITALLYIMPORTANT POSITION 6;

ALTER TABLE CATALOGS ALTER COLUMN NEEDCOLD POSITION 7;

ALTER TABLE CATALOGS ALTER COLUMN FRAGILE POSITION 8;

ALTER TABLE CLIENTS ALTER COLUMN CLIENTID POSITION 1;

ALTER TABLE CLIENTS ALTER COLUMN NAME POSITION 2;

ALTER TABLE CLIENTS ALTER COLUMN REGIONCODE POSITION 3;

ALTER TABLE CLIENTS ALTER COLUMN EXCESS POSITION 4;

ALTER TABLE CLIENTS ALTER COLUMN DELTAMODE POSITION 5;

ALTER TABLE CLIENTS ALTER COLUMN MAXUSERS POSITION 6;

ALTER TABLE CLIENTS ALTER COLUMN REQMASK POSITION 7;

ALTER TABLE CLIENTS ALTER COLUMN TECHSUPPORT POSITION 8;

ALTER TABLE CLIENTS ALTER COLUMN CALCULATELEADER POSITION 9;

ALTER TABLE CLIENTS ALTER COLUMN ONLYLEADERS POSITION 10;

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

update PROVIDER set mdbversion = 36 where id = 0;