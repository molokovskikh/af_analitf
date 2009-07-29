/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES cp1251 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
-- 
-- StoredProc  CATALOGSHOWBYFORM
-- 

DELIMITER $$
DROP PROCEDURE IF EXISTS CATALOGSHOWBYFORM $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CATALOGSHOWBYFORM`(
    ashortcode bigint,
    showall tinyint(1))
BEGIN
  if (showall = 1) then
    SELECT CATALOGS.FullCode, CATALOGS.Form, catalogs.coreexists
    FROM CATALOGS
    WHERE CATALOGS.ShortCode = AShortCode
    order by CATALOGS.Form;
  else
    SELECT CATALOGS.FullCode, CATALOGS.Form, catalogs.coreexists
    FROM CATALOGS
    WHERE CATALOGS.ShortCode= AShortCode
      and catalogs.coreexists = 1
    order by CATALOGS.Form;
  end if;
END $$
DELIMITER ;


-- 
-- StoredProc  CATALOGSHOWBYNAME
-- 

DELIMITER $$
DROP PROCEDURE IF EXISTS CATALOGSHOWBYNAME $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CATALOGSHOWBYNAME`(IN showall TINYINT(1))
BEGIN
  if (showall = 1) then 
      SELECT
        cat.ShortCode AS AShortCode, cat.Name, sum(CoreExists) as CoreExists
      FROM CATALOGS cat
      group by cat.ShortCode, cat.Name
      ORDER BY cat.Name;
  else 
      SELECT
        cat.ShortCode AS AShortCode, cat.Name, sum(CoreExists) as CoreExists
      FROM CATALOGS cat
      where
        CoreExists = 1
      group by cat.ShortCode, cat.Name
      ORDER BY cat.Name;
  end if;  
END $$
DELIMITER ;


-- 
-- StoredProc  DeleteOrder
-- 

DELIMITER $$
DROP PROCEDURE IF EXISTS DeleteOrder $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteOrder`(IN aorderid BIGINT)
BEGIN
  delete from Ordershead where OrderId = aorderid;
  delete from OrdersList where OrderId = aorderid;
END $$
DELIMITER ;


-- 
-- StoredProc  UPDATEORDERCOUNT
-- 

DELIMITER $$
DROP PROCEDURE IF EXISTS UPDATEORDERCOUNT $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATEORDERCOUNT`(IN aorderid BIGINT, IN aclientid BIGINT, IN apricecode BIGINT, IN aregioncode BIGINT, IN aordersorderid BIGINT, IN acoreid BIGINT, IN aordercount INTEGER)
BEGIN
  if (aorderid is null) then
    SELECT ORDERID 
    FROM OrdersHead 
    WHERE ClientId = AClientId 
      AND PriceCode = APriceCode 
      AND RegionCode = ARegionCode 
      AND Closed  <> 1
    into aorderid;

    if (aorderid is null) then 
      insert into OrdersHead (ClientId, PriceCode, RegionCode, PriceName, RegionName, OrderDate)
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
    select orderid from OrdersList where coreid = acoreid and orderid = aorderid into aordersorderid;
    if (aordersorderid is null) then
      INSERT INTO OrdersList(ORDERID, CLIENTID, COREID, PRODUCTID, CODEFIRMCR,
               SYNONYMCODE, SYNONYMFIRMCRCODE, CODE, CODECR, SYNONYMNAME,
               SYNONYMFIRM, PRICE, AWAIT, JUNK, ORDERCOUNT,
               REQUESTRATIO, ORDERCOST, MINORDERCOUNT )
        select aORDERID, aCLIENTID, aCOREID, c.PRODUCTID, c.CODEFIRMCR,
               c.SYNONYMCODE, c.SYNONYMFIRMCRCODE, c.CODE, c.CODECR,
               ifnull(s.SynonymName, concat(catalogs.name, ' ', catalogs.form)) as SynonymName,
               sf.synonymname, c.cost, c.AWAIT, c.JUNK, aORDERCOUNT,
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
      update OrdersList set ordercount = aordercount where orderid = aordersorderid and coreid = acoreid;
    end if;
  else 
    update OrdersList set ordercount = aordercount where orderid = aordersorderid and coreid = acoreid;
  end if;

END $$
DELIMITER ;


-- 
-- StoredProc  UPDATEUPCOST
-- 

DELIMITER $$
DROP PROCEDURE IF EXISTS UPDATEUPCOST $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATEUPCOST`(IN inPricecode BIGINT, IN inRegioncode BIGINT, IN ainjob INTEGER)
BEGIN
  declare uppricecode bigint;
  update pricesregionaldata set
    INJOB = ainjob
  where
    PriceCode = inPricecode
    and RegionCode = inRegioncode;
  select
    pricecode
  from pricesregionaldataup
  where
      PriceCode = inPricecode
    and RegionCode = inRegioncode
  into UPPRICECODE;
  if (UPPRICECODE is null) then
    insert into pricesregionaldataup values (inPricecode, inRegioncode);
  end if;
END $$
DELIMITER ;


-- 
-- StoredProc  x_cast_to_int10
-- 

DELIMITER $$
DROP FUNCTION IF EXISTS x_cast_to_int10 $$
CREATE DEFINER=`root`@`localhost` FUNCTION `x_cast_to_int10`(number bigint) RETURNS int(10)
BEGIN    return number;END $$
DELIMITER ;


-- 
-- StoredProc  x_cast_to_tinyint
-- 

DELIMITER $$
DROP FUNCTION IF EXISTS x_cast_to_tinyint $$
CREATE DEFINER=`root`@`localhost` FUNCTION `x_cast_to_tinyint`(number BIGINT) RETURNS tinyint(1)
BEGIN    return number;END $$
DELIMITER ;


-- 
-- Table structure for table  catalogfarmgroups
-- 

DROP TABLE IF EXISTS catalogfarmgroups;
CREATE TABLE `catalogfarmgroups` (
  `ID` bigint(20) NOT NULL,
  `NAME` varchar(250) DEFAULT NULL,
  `DESCRIPTION` text,
  `PARENTID` bigint(20) DEFAULT NULL,
  `GROUPTYPE` int(10) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_CATALOGFARMGROUPS` (`ID`),
  KEY `FK_CATALOG_FARM_GROUPS_PARENT` (`PARENTID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  catalognames
-- 

DROP TABLE IF EXISTS catalognames;
CREATE TABLE `catalognames` (
  `ID` bigint(20) NOT NULL,
  `NAME` varchar(250) DEFAULT NULL,
  `LATINNAME` varchar(250) DEFAULT NULL,
  `DESCRIPTION` text,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_CATALOGNAMES` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  catalogs
-- 

DROP TABLE IF EXISTS catalogs;
CREATE TABLE `catalogs` (
  `FULLCODE` bigint(20) NOT NULL,
  `SHORTCODE` bigint(20) NOT NULL,
  `NAME` varchar(250) DEFAULT NULL,
  `FORM` varchar(250) DEFAULT NULL,
  `VITALLYIMPORTANT` tinyint(1) NOT NULL,
  `NEEDCOLD` tinyint(1) NOT NULL,
  `FRAGILE` tinyint(1) NOT NULL,
  `COREEXISTS` tinyint(1) NOT NULL,
  PRIMARY KEY (`FULLCODE`),
  UNIQUE KEY `PK_CATALOGS` (`FULLCODE`),
  KEY `IDX_CATALOG_FORM` (`FORM`),
  KEY `IDX_CATALOG_NAME` (`NAME`),
  KEY `IDX_CATALOG_SHORTCODE` (`SHORTCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  clients
-- 

DROP TABLE IF EXISTS clients;
CREATE TABLE `clients` (
  `CLIENTID` bigint(20) NOT NULL,
  `NAME` varchar(50) NOT NULL,
  `REGIONCODE` bigint(20) DEFAULT NULL,
  `EXCESS` int(10) NOT NULL,
  `DELTAMODE` smallint(5) DEFAULT NULL,
  `MAXUSERS` int(10) NOT NULL,
  `REQMASK` bigint(20) DEFAULT NULL,
  `CALCULATELEADER` tinyint(1) NOT NULL,
  `ONLYLEADERS` tinyint(1) NOT NULL,
  PRIMARY KEY (`CLIENTID`),
  UNIQUE KEY `PK_CLIENTS` (`CLIENTID`),
  KEY `FK_CLIENTS_REGIONCODE` (`REGIONCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  core
-- 

DROP TABLE IF EXISTS core;
CREATE TABLE `core` (
  `PRICECODE` bigint(20) DEFAULT NULL,
  `REGIONCODE` bigint(20) DEFAULT NULL,
  `PRODUCTID` bigint(20) NOT NULL,
  `CODEFIRMCR` bigint(20) DEFAULT NULL,
  `SYNONYMCODE` bigint(20) DEFAULT NULL,
  `SYNONYMFIRMCRCODE` bigint(20) DEFAULT NULL,
  `CODE` varchar(84) DEFAULT NULL,
  `CODECR` varchar(84) DEFAULT NULL,
  `UNIT` varchar(15) DEFAULT NULL,
  `VOLUME` varchar(15) DEFAULT NULL,
  `JUNK` tinyint(1) NOT NULL,
  `AWAIT` tinyint(1) NOT NULL,
  `QUANTITY` varchar(15) DEFAULT NULL,
  `NOTE` varchar(50) DEFAULT NULL,
  `PERIOD` varchar(20) DEFAULT NULL,
  `DOC` varchar(20) DEFAULT NULL,
  `REGISTRYCOST` decimal(8,2) DEFAULT NULL,
  `VITALLYIMPORTANT` tinyint(1) NOT NULL,
  `REQUESTRATIO` int(10) DEFAULT NULL,
  `Cost` decimal(18,2) DEFAULT NULL,
  `SERVERCOREID` bigint(20) DEFAULT NULL,
  `ORDERCOST` decimal(18,2) DEFAULT NULL,
  `MINORDERCOUNT` int(10) DEFAULT NULL,
  `COREID` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`COREID`),
  UNIQUE KEY `PK_CORE` (`COREID`),
  KEY `FK_CORE_PRICECODE` (`PRICECODE`),
  KEY `FK_CORE_PRODUCTID` (`PRODUCTID`),
  KEY `FK_CORE_REGIONCODE` (`REGIONCODE`),
  KEY `FK_CORE_SYNONYMCODE` (`SYNONYMCODE`),
  KEY `FK_CORE_SYNONYMFIRMCRCODE` (`SYNONYMFIRMCRCODE`),
  KEY `IDX_CORE_JUNK` (`PRODUCTID`,`JUNK`),
  KEY `IDX_CORE_SERVERCOREID` (`SERVERCOREID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  defectives
-- 

DROP TABLE IF EXISTS defectives;
CREATE TABLE `defectives` (
  `ID` bigint(20) NOT NULL,
  `NAME` varchar(250) DEFAULT NULL,
  `PRODUCER` varchar(150) DEFAULT NULL,
  `COUNTRY` varchar(150) DEFAULT NULL,
  `SERIES` varchar(50) DEFAULT NULL,
  `LETTERNUMBER` varchar(50) DEFAULT NULL,
  `LETTERDATE` timestamp NULL DEFAULT NULL,
  `LABORATORY` varchar(200) DEFAULT NULL,
  `REASON` text,
  `CHECKPRINT` tinyint(1) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_DEFECTIVES` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  minprices
-- 

DROP TABLE IF EXISTS minprices;
CREATE TABLE `minprices` (
  `PRODUCTID` bigint(20) NOT NULL DEFAULT '0',
  `REGIONCODE` bigint(20) NOT NULL DEFAULT '0',
  `SERVERCOREID` bigint(20) DEFAULT NULL,
  `PriceCode` bigint(20) DEFAULT NULL,
  `MinCost` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`PRODUCTID`,`REGIONCODE`),
  KEY `FK_MINPRICES_PRODUCTID` (`PRODUCTID`),
  KEY `FK_MINPRICES_REGIONCODE` (`REGIONCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  ordershead
-- 

DROP TABLE IF EXISTS ordershead;
CREATE TABLE `ordershead` (
  `ORDERID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SERVERORDERID` bigint(20) DEFAULT NULL,
  `CLIENTID` bigint(20) NOT NULL,
  `PRICECODE` bigint(20) NOT NULL,
  `REGIONCODE` bigint(20) NOT NULL,
  `PRICENAME` varchar(70) DEFAULT NULL,
  `REGIONNAME` varchar(25) DEFAULT NULL,
  `ORDERDATE` timestamp NULL DEFAULT NULL,
  `SENDDATE` timestamp NULL DEFAULT NULL,
  `CLOSED` tinyint(1) NOT NULL,
  `SEND` tinyint(1) NOT NULL DEFAULT '1',
  `COMMENTS` text,
  `MESSAGETO` text,
  PRIMARY KEY (`ORDERID`),
  UNIQUE KEY `PK_ORDERSH` (`ORDERID`),
  KEY `FK_ORDERSH_CLIENTID` (`CLIENTID`),
  KEY `IDX_ORDERSH_ORDERDATE` (`ORDERDATE`),
  KEY `IDX_ORDERSH_PRICECODE` (`PRICECODE`),
  KEY `IDX_ORDERSH_REGIONCODE` (`REGIONCODE`),
  KEY `IDX_ORDERSH_SENDDATE` (`SENDDATE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  orderslist
-- 

DROP TABLE IF EXISTS orderslist;
CREATE TABLE `orderslist` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ORDERID` bigint(20) NOT NULL,
  `CLIENTID` bigint(20) NOT NULL,
  `COREID` bigint(20) DEFAULT NULL,
  `PRODUCTID` bigint(20) NOT NULL,
  `CODEFIRMCR` bigint(20) DEFAULT NULL,
  `SYNONYMCODE` bigint(20) DEFAULT NULL,
  `SYNONYMFIRMCRCODE` bigint(20) DEFAULT NULL,
  `CODE` varchar(84) DEFAULT NULL,
  `CODECR` varchar(84) DEFAULT NULL,
  `SYNONYMNAME` varchar(250) DEFAULT NULL,
  `SYNONYMFIRM` varchar(250) DEFAULT NULL,
  `PRICE` decimal(18,2) DEFAULT NULL,
  `AWAIT` tinyint(1) NOT NULL,
  `JUNK` tinyint(1) NOT NULL,
  `ORDERCOUNT` int(10) NOT NULL,
  `REQUESTRATIO` int(10) DEFAULT NULL,
  `ORDERCOST` decimal(18,2) DEFAULT NULL,
  `MINORDERCOUNT` int(10) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_ORDERS` (`ID`),
  KEY `FK_ORDERS_CLIENTID` (`CLIENTID`),
  KEY `FK_ORDERS_ORDERID` (`ORDERID`),
  KEY `IDX_ORDERS_CODEFIRMCR` (`CODEFIRMCR`),
  KEY `IDX_ORDERS_COREID` (`COREID`),
  KEY `IDX_ORDERS_ORDERCOUNT` (`ORDERCOUNT`),
  KEY `IDX_ORDERS_PRODUCTID` (`PRODUCTID`),
  KEY `IDX_ORDERS_SYNONYMCODE` (`SYNONYMCODE`),
  KEY `IDX_ORDERS_SYNONYMFIRMCRCODE` (`SYNONYMFIRMCRCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  params
-- 

DROP TABLE IF EXISTS params;
CREATE TABLE `params` (
  `ID` bigint(20) NOT NULL,
  `CLIENTID` bigint(20) DEFAULT NULL,
  `RASCONNECT` tinyint(1) NOT NULL,
  `RASENTRY` varchar(30) DEFAULT NULL,
  `RASNAME` varchar(30) DEFAULT NULL,
  `RASPASS` varchar(30) DEFAULT NULL,
  `CONNECTCOUNT` smallint(5) NOT NULL DEFAULT '5',
  `CONNECTPAUSE` smallint(5) NOT NULL DEFAULT '5',
  `PROXYCONNECT` tinyint(1) NOT NULL,
  `PROXYNAME` varchar(30) DEFAULT NULL,
  `PROXYPORT` int(10) DEFAULT NULL,
  `PROXYUSER` varchar(30) DEFAULT NULL,
  `PROXYPASS` varchar(255) DEFAULT NULL,
  `HTTPHOST` varchar(50) DEFAULT 'ios.analit.net',
  `HTTPNAME` varchar(30) DEFAULT NULL,
  `HTTPPASS` varchar(255) DEFAULT NULL,
  `UPDATEDATETIME` datetime DEFAULT NULL,
  `LASTDATETIME` datetime DEFAULT NULL,
  `SHOWREGISTER` tinyint(1) NOT NULL,
  `USEFORMS` tinyint(1) NOT NULL,
  `OPERATEFORMS` tinyint(1) NOT NULL,
  `OPERATEFORMSSET` tinyint(1) NOT NULL,
  `STARTPAGE` smallint(5) NOT NULL DEFAULT '0',
  `LASTCOMPACT` datetime DEFAULT NULL,
  `CUMULATIVE` tinyint(1) NOT NULL,
  `STARTED` tinyint(1) NOT NULL,
  `RASSLEEP` smallint(5) NOT NULL DEFAULT '3',
  `HTTPNAMECHANGED` tinyint(1) NOT NULL,
  `SHOWALLCATALOG` tinyint(1) NOT NULL,
  `CDS` varchar(224) DEFAULT NULL,
  `ORDERSHISTORYDAYCOUNT` int(10) NOT NULL DEFAULT '21',
  `CONFIRMDELETEOLDORDERS` tinyint(1) NOT NULL,
  `USEOSOPENWAYBILL` tinyint(1) NOT NULL,
  `USEOSOPENREJECT` tinyint(1) NOT NULL,
  `GROUPBYPRODUCTS` tinyint(1) NOT NULL,
  `PRINTORDERSAFTERSEND` tinyint(1) NOT NULL,
  `ProviderName` varchar(50) NOT NULL DEFAULT 'АК "Инфорум"',
  `ProviderAddress` varchar(30) NOT NULL DEFAULT 'Ленинский пр-т, 160 оф.415',
  `ProviderPhones` varchar(30) NOT NULL DEFAULT '4732-606000',
  `ProviderEmail` varchar(30) NOT NULL DEFAULT 'farm@analit.net',
  `ProviderWeb` varchar(30) NOT NULL DEFAULT 'http://www.analit.net/',
  `ProviderMDBVersion` smallint(6) NOT NULL DEFAULT '49',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_PARAMS` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  pricesdata
-- 

DROP TABLE IF EXISTS pricesdata;
CREATE TABLE `pricesdata` (
  `FIRMCODE` bigint(20) NOT NULL,
  `PRICECODE` bigint(20) NOT NULL,
  `PRICENAME` varchar(70) DEFAULT NULL,
  `PRICEINFO` text,
  `DATEPRICE` datetime DEFAULT NULL,
  `FRESH` tinyint(1) NOT NULL,
  PRIMARY KEY (`PRICECODE`),
  UNIQUE KEY `PK_PRICESDATA` (`PRICECODE`),
  KEY `FK_PRICESDATA_FIRMCODE` (`FIRMCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  pricesregionaldata
-- 

DROP TABLE IF EXISTS pricesregionaldata;
CREATE TABLE `pricesregionaldata` (
  `PRICECODE` bigint(20) NOT NULL DEFAULT '0',
  `REGIONCODE` bigint(20) NOT NULL DEFAULT '0',
  `STORAGE` tinyint(1) NOT NULL,
  `MINREQ` int(10) DEFAULT NULL,
  `ENABLED` tinyint(1) NOT NULL,
  `INJOB` tinyint(1) NOT NULL,
  `CONTROLMINREQ` tinyint(1) NOT NULL,
  `PRICESIZE` int(10) DEFAULT NULL,
  PRIMARY KEY (`PRICECODE`,`REGIONCODE`),
  KEY `FK_PRD_REGIONCODE` (`REGIONCODE`),
  KEY `FK_PRICESREGIONALDATA_PRICECODE` (`PRICECODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  pricesregionaldataup
-- 

DROP TABLE IF EXISTS pricesregionaldataup;
CREATE TABLE `pricesregionaldataup` (
  `PRICECODE` bigint(20) NOT NULL,
  `REGIONCODE` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  products
-- 

DROP TABLE IF EXISTS products;
CREATE TABLE `products` (
  `PRODUCTID` bigint(20) NOT NULL,
  `CATALOGID` bigint(20) NOT NULL,
  PRIMARY KEY (`PRODUCTID`),
  UNIQUE KEY `PK_PRODUCTS` (`PRODUCTID`),
  KEY `FK_PRODUCTS_CATALOGID` (`CATALOGID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  providers
-- 

DROP TABLE IF EXISTS providers;
CREATE TABLE `providers` (
  `FIRMCODE` bigint(20) NOT NULL,
  `FULLNAME` varchar(40) DEFAULT NULL,
  `FAX` varchar(20) DEFAULT NULL,
  `MANAGERMAIL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`FIRMCODE`),
  UNIQUE KEY `PK_CLIENTSDATAN` (`FIRMCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  receiveddocs
-- 

DROP TABLE IF EXISTS receiveddocs;
CREATE TABLE `receiveddocs` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `FILENAME` varchar(255) NOT NULL,
  `FILEDATETIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_RECEIVEDDOCS` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  regionaldata
-- 

DROP TABLE IF EXISTS regionaldata;
CREATE TABLE `regionaldata` (
  `FIRMCODE` bigint(20) NOT NULL DEFAULT '0',
  `REGIONCODE` bigint(20) NOT NULL DEFAULT '0',
  `SUPPORTPHONE` varchar(20) DEFAULT NULL,
  `CONTACTINFO` text,
  `OPERATIVEINFO` text,
  PRIMARY KEY (`FIRMCODE`,`REGIONCODE`),
  KEY `FK_REGIONALDATA_FIRMCODE` (`FIRMCODE`),
  KEY `FK_REGIONALDATA_REGIONCODE` (`REGIONCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  regions
-- 

DROP TABLE IF EXISTS regions;
CREATE TABLE `regions` (
  `REGIONCODE` bigint(20) NOT NULL,
  `REGIONNAME` varchar(25) DEFAULT NULL,
  `PRICERET` varchar(254) DEFAULT NULL,
  PRIMARY KEY (`REGIONCODE`),
  UNIQUE KEY `PK_REGIONS` (`REGIONCODE`),
  UNIQUE KEY `IDX_REGIONS_REGIONNAME` (`REGIONNAME`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  retailmargins
-- 

DROP TABLE IF EXISTS retailmargins;
CREATE TABLE `retailmargins` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `LEFTLIMIT` decimal(18,4) NOT NULL,
  `RIGHTLIMIT` decimal(18,4) NOT NULL,
  `RETAIL` int(10) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_RETAILMARGINS` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  synonymfirmcr
-- 

DROP TABLE IF EXISTS synonymfirmcr;
CREATE TABLE `synonymfirmcr` (
  `SYNONYMFIRMCRCODE` bigint(20) NOT NULL,
  `SYNONYMNAME` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`SYNONYMFIRMCRCODE`),
  UNIQUE KEY `PK_SYNONYMFIRMCR` (`SYNONYMFIRMCRCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  synonyms
-- 

DROP TABLE IF EXISTS synonyms;
CREATE TABLE `synonyms` (
  `SYNONYMCODE` bigint(20) NOT NULL,
  `SYNONYMNAME` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`SYNONYMCODE`),
  UNIQUE KEY `PK_SYNONYMS` (`SYNONYMCODE`),
  FULLTEXT KEY `IDX_SYNONYMNAME` (`SYNONYMNAME`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  tmpclients
-- 

DROP TABLE IF EXISTS tmpclients;
CREATE TABLE `tmpclients` (
  `CLIENTID` bigint(20) NOT NULL,
  `NAME` varchar(50) NOT NULL,
  `REGIONCODE` bigint(20) DEFAULT NULL,
  `EXCESS` int(10) NOT NULL,
  `DELTAMODE` smallint(5) DEFAULT NULL,
  `MAXUSERS` int(10) NOT NULL,
  `REQMASK` bigint(20) DEFAULT NULL,
  `TECHSUPPORT` varchar(255) DEFAULT NULL,
  `CALCULATELEADER` tinyint(1) NOT NULL,
  `ONLYLEADERS` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  tmppricesdata
-- 

DROP TABLE IF EXISTS tmppricesdata;
CREATE TABLE `tmppricesdata` (
  `FIRMCODE` bigint(20) NOT NULL,
  `PRICECODE` bigint(20) NOT NULL,
  `PRICENAME` varchar(70) DEFAULT NULL,
  `PRICEINFO` text,
  `DATEPRICE` datetime DEFAULT NULL,
  `FRESH` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  tmppricesregionaldata
-- 

DROP TABLE IF EXISTS tmppricesregionaldata;
CREATE TABLE `tmppricesregionaldata` (
  `PRICECODE` bigint(20) NOT NULL,
  `REGIONCODE` bigint(20) NOT NULL,
  `STORAGE` tinyint(1) NOT NULL,
  `MINREQ` int(10) DEFAULT NULL,
  `ENABLED` tinyint(1) NOT NULL,
  `INJOB` tinyint(1) NOT NULL,
  `CONTROLMINREQ` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  tmpproviders
-- 

DROP TABLE IF EXISTS tmpproviders;
CREATE TABLE `tmpproviders` (
  `FIRMCODE` bigint(20) NOT NULL,
  `FULLNAME` varchar(40) DEFAULT NULL,
  `FAX` varchar(20) DEFAULT NULL,
  `MANAGERMAIL` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  tmpregionaldata
-- 

DROP TABLE IF EXISTS tmpregionaldata;
CREATE TABLE `tmpregionaldata` (
  `FIRMCODE` bigint(20) NOT NULL,
  `REGIONCODE` bigint(20) NOT NULL,
  `SUPPORTPHONE` varchar(20) DEFAULT NULL,
  `CONTACTINFO` text,
  `OPERATIVEINFO` text
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  tmpregions
-- 

DROP TABLE IF EXISTS tmpregions;
CREATE TABLE `tmpregions` (
  `REGIONCODE` bigint(20) NOT NULL,
  `REGIONNAME` varchar(25) DEFAULT NULL,
  `PRICERET` varchar(254) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


-- 
-- Table structure for table  clientavg
-- 

DROP VIEW IF EXISTS clientavg;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `clientavg` AS select `ordershead`.`CLIENTID` AS `CLIENTCODE`,`orderslist`.`PRODUCTID` AS `PRODUCTID`,avg(`orderslist`.`PRICE`) AS `PRICEAVG` from (`ordershead` join `orderslist`) where ((`orderslist`.`ORDERID` = `ordershead`.`ORDERID`) and (`ordershead`.`ORDERDATE` >= (curdate() - interval 1 month)) and (`ordershead`.`CLOSED` = 1) and (`ordershead`.`SEND` = 1) and (`orderslist`.`ORDERCOUNT` > 0) and (`orderslist`.`PRICE` is not null)) group by `ordershead`.`CLIENTID`,`orderslist`.`PRODUCTID`;


-- 
-- Table structure for table  pricesshow
-- 

DROP VIEW IF EXISTS pricesshow;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pricesshow` AS select `pd`.`PRICECODE` AS `PriceCode`,`pd`.`PRICENAME` AS `PriceName`,`pd`.`DATEPRICE` AS `UniversalDatePrice`,`prd`.`MINREQ` AS `MinReq`,`prd`.`ENABLED` AS `Enabled`,`pd`.`PRICEINFO` AS `PriceInfo`,`cd`.`FIRMCODE` AS `FirmCode`,`cd`.`FULLNAME` AS `FullName`,`prd`.`STORAGE` AS `Storage`,`cd`.`MANAGERMAIL` AS `ManagerMail`,`rd`.`SUPPORTPHONE` AS `SupportPhone`,`rd`.`CONTACTINFO` AS `ContactInfo`,`rd`.`OPERATIVEINFO` AS `OperativeInfo`,`r`.`REGIONCODE` AS `RegionCode`,`r`.`REGIONNAME` AS `RegionName`,`prd`.`PRICESIZE` AS `pricesize`,`prd`.`INJOB` AS `INJOB`,`prd`.`CONTROLMINREQ` AS `CONTROLMINREQ` from ((((`pricesdata` `pd` join `pricesregionaldata` `prd` on((`pd`.`PRICECODE` = `prd`.`PRICECODE`))) join `regions` `r` on((`prd`.`REGIONCODE` = `r`.`REGIONCODE`))) join `providers` `cd` on((`cd`.`FIRMCODE` = `pd`.`FIRMCODE`))) join `regionaldata` `rd` on(((`rd`.`REGIONCODE` = `prd`.`REGIONCODE`) and (`rd`.`FIRMCODE` = `cd`.`FIRMCODE`))));


/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
