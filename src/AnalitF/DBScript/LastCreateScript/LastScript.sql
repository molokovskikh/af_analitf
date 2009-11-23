/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES cp1251 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
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
  `AllowDelayOfPayment` tinyint(1) NOT NULL,
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
-- Table structure for table  delayofpayments
-- 

DROP TABLE IF EXISTS delayofpayments;
CREATE TABLE `delayofpayments` (
  `ClientId` bigint(20) NOT NULL,
  `FirmCode` bigint(20) NOT NULL,
  `Percent` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`ClientId`,`FirmCode`)
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
  `RealPrice` decimal(18,2) DEFAULT NULL,
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
-- Table structure for table  userinfo
-- 

DROP TABLE IF EXISTS userinfo;
CREATE TABLE `userinfo` (
  `ClientId` bigint(20) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `Addition` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
