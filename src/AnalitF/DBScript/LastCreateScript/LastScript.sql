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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
  `MandatoryList`    tinyint(1) not null,
  `MnnId`            bigint(20) default null, 
  `DescriptionId`    bigint(20) default null,
  `Hidden`           tinyint(1) not null,
  `COREEXISTS` tinyint(1) NOT NULL,
  PRIMARY KEY (`FULLCODE`),
  UNIQUE KEY `PK_CATALOGS` (`FULLCODE`),
  KEY `IDX_CATALOG_FORM` (`FORM`),
  KEY `IDX_CATALOG_NAME` (`NAME`),
  KEY `IDX_CATALOG_SHORTCODE` (`SHORTCODE`),
  key `IDX_CATALOG_MnnId` (`MnnId`),
  key `IDX_CATALOG_DescriptionId` (`DescriptionId`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  client
-- 

DROP TABLE IF EXISTS client;
CREATE TABLE `client` (
  `Id` bigint(20) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `CalculateOnProducerCost` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `ParseWaybills` tinyint(1) unsigned not null default '0',
  `SendRetailMarkup` tinyint(1) unsigned not null default '0',
  `ShowAdvertising` tinyint(1) unsigned not null default '1',
  `SendWaybillsFromClient` tinyint(1) unsigned not null default '0',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
  `FullName` varchar(255) default null,
  PRIMARY KEY (`CLIENTID`),
  UNIQUE KEY `PK_CLIENTS` (`CLIENTID`),
  KEY `FK_CLIENTS_REGIONCODE` (`REGIONCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  clientsettings
-- 

DROP TABLE IF EXISTS clientsettings;
CREATE TABLE `clientsettings` (
  `ClientId`         bigint(20) not null,
  `OnlyLeaders`      tinyint(1) not null,
  `Address`          varchar(255) default null,
  `Director`         varchar(255) default null,
  `DeputyDirector`   varchar(255) default null,
  `Accountant`       varchar(255) default null,
  `MethodOfTaxation` smallint(5) not null default '0',
  `CalculateWithNDS` tinyint(1) not null default '1',
  `Name` varchar(255) default null,
  primary key (`CLIENTID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
  `SupplierPriceMarkup` decimal(5,3) default null,
  `ProducerCost` decimal(18,2) default null,
  `NDS` smallint(5) default null,
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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  delayofpayments
-- 

DROP TABLE IF EXISTS delayofpayments;
CREATE TABLE `delayofpayments` (
  `FirmCode` bigint(20) NOT NULL,
  `Percent` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`FirmCode`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  Descriptions
-- 

DROP TABLE IF EXISTS Descriptions;
CREATE TABLE `Descriptions` (
  `Id`               bigint(20) not null  , 
  `Name` varchar(255) not null,
  `EnglishName` varchar(255) default null,
  `Description` TEXT DEFAULT NULL,
  `Interaction`    TEXT DEFAULT NULL, 
  `SideEffect`    TEXT DEFAULT NULL, 
  `IndicationsForUse` TEXT DEFAULT NULL, 
  `Dosing` TEXT DEFAULT NULL, 
  `Warnings` TEXT DEFAULT NULL, 
  `ProductForm` TEXT DEFAULT NULL, 
  `PharmacologicalAction` TEXT DEFAULT NULL, 
  `Storage` TEXT DEFAULT NULL, 
  `Expiration` TEXT DEFAULT NULL, 
  `Composition` TEXT DEFAULT NULL, 
  `Hidden`           tinyint(1) not null,
  PRIMARY KEY (`Id`),
  Key(`Name`),
  Key(`EnglishName`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  documentbodies
-- 

DROP TABLE IF EXISTS documentbodies;
CREATE TABLE  `documentbodies` (  
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `DocumentId` bigint(20) unsigned NOT NULL,
  `Product` varchar(255) not null,
  `Code` varchar(20) default null,
  `Certificates` varchar(50) default null,
  `Period` varchar(20) default null,
  `Producer` varchar(255) default null,
  `Country` varchar(150) default null,
  `ProducerCost` decimal(18,2) default null,
  `RegistryCost` decimal(18,2) default null,
  `SupplierPriceMarkup` decimal(5,2) default null,
  `SupplierCostWithoutNDS` decimal(18,2) default null,
  `SupplierCost` decimal(18,2) default null,  
  `Quantity` int(10) DEFAULT NULL,
  `VitallyImportant` tinyint(1) unsigned default null,
  `NDS` int(10) unsigned DEFAULT NULL,
  `SerialNumber` varchar(50) default null,
  `RetailMarkup` decimal(12,6) default null,
  `ManualCorrection` tinyint(1) unsigned not null default '0',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  documentheaders
--

DROP TABLE IF EXISTS documentheaders;
CREATE TABLE  `documentheaders` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `DownloadId` bigint(20) unsigned DEFAULT NULL,
  `WriteTime` datetime NOT NULL,
  `FirmCode` bigint(20) unsigned DEFAULT NULL,
  `ClientId` bigint(20) unsigned DEFAULT NULL,
  `DocumentType` tinyint(3) unsigned DEFAULT NULL,
  `ProviderDocumentId` varchar(20) DEFAULT NULL,
  `OrderId` bigint(20) unsigned DEFAULT NULL,
  `Header` varchar(255) DEFAULT NULL,
  `LoadTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  KEY (`LoadTime`),
  KEY (`DownloadId`),
  KEY (`ClientId`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  maxproducercosts
-- 

DROP TABLE IF EXISTS maxproducercosts;
CREATE TABLE `maxproducercosts` (
  `Id`          bigint(20) not null  ,
  `CatalogId`   bigint(20) not null  ,
  `ProductId`   bigint(20) not null  ,
  `Product`     varchar(255) not null,
  `Producer`    varchar(255) not null,
  `Cost`        varchar(50) default null,
  `ProducerId`  bigint(20) default null,
  `RealCost`    decimal(12,6) default null,
  PRIMARY KEY (`Id`),
  Key(`CatalogId`),
  Key(`ProductId`),
  Key(`Product`),
  Key(`Producer`),
  Key(`ProducerId`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  mnn
-- 

DROP TABLE IF EXISTS mnn;
CREATE TABLE `mnn` (
    `Id`               bigint(20) not null  , 
    `Mnn`              varchar(250) not null, 
    `RussianMnn`       varchar(250) default null, 
    `Hidden`           tinyint(1) not null      ,
    primary key (`Id`),
    key `IDX_MNN_Mnn` (`Mnn`),
    key `IDX_MNN_RussianMnn` (`RussianMnn`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  currentorderheads
-- 

DROP TABLE IF EXISTS currentorderheads;
CREATE TABLE `currentorderheads` (
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
  `SendResult` smallint(5) DEFAULT NULL,
  `ErrorReason` varchar(250) DEFAULT NULL,
  `ServerMinReq` int(10) DEFAULT NULL,
  `DelayOfPayment` decimal(5,3) default null,
  PRIMARY KEY (`ORDERID`),
  UNIQUE KEY `PK_ORDERSH` (`ORDERID`),
  KEY `FK_ORDERSH_CLIENTID` (`CLIENTID`),
  KEY `IDX_ORDERSH_ORDERDATE` (`ORDERDATE`),
  KEY `IDX_ORDERSH_PRICECODE` (`PRICECODE`),
  KEY `IDX_ORDERSH_REGIONCODE` (`REGIONCODE`),
  KEY `IDX_ORDERSH_SENDDATE` (`SENDDATE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  currentorderlists
-- 

DROP TABLE IF EXISTS currentorderlists;
CREATE TABLE `currentorderlists` (
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
  `DropReason` smallint(5) DEFAULT NULL,
  `ServerCost` decimal(18,2) DEFAULT NULL,
  `ServerQuantity` int(10) DEFAULT NULL,
  `SupplierPriceMarkup` decimal(5,3) default null,
  `CoreQuantity` varchar(15) DEFAULT NULL,
  `ServerCoreID` bigint(20) DEFAULT NULL, 
  `Unit` varchar(15) DEFAULT NULL,
  `Volume` varchar(15) DEFAULT NULL,
  `Note` varchar(50) DEFAULT NULL,
  `Period` varchar(20) DEFAULT NULL,
  `Doc` varchar(20) DEFAULT NULL,
  `RegistryCost` decimal(8,2) DEFAULT NULL,
  `VitallyImportant` tinyint(1) NOT NULL,
  `RetailMarkup` decimal(12,6) default null,
  `ProducerCost` decimal(18,2) default null, 
  `NDS` smallint(5) default null,
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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  postedorderheads
-- 

DROP TABLE IF EXISTS postedorderheads;
CREATE TABLE `postedorderheads` (
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
  `SendResult` smallint(5) DEFAULT NULL,
  `ErrorReason` varchar(250) DEFAULT NULL,
  `ServerMinReq` int(10) DEFAULT NULL,
  `DelayOfPayment` decimal(5,3) default null,
  PRIMARY KEY (`ORDERID`),
  UNIQUE KEY `PK_ORDERSH` (`ORDERID`),
  KEY `FK_ORDERSH_CLIENTID` (`CLIENTID`),
  KEY `IDX_ORDERSH_ORDERDATE` (`ORDERDATE`),
  KEY `IDX_ORDERSH_PRICECODE` (`PRICECODE`),
  KEY `IDX_ORDERSH_REGIONCODE` (`REGIONCODE`),
  KEY `IDX_ORDERSH_SENDDATE` (`SENDDATE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  postedorderlists
-- 

DROP TABLE IF EXISTS postedorderlists;
CREATE TABLE `postedorderlists` (
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
  `DropReason` smallint(5) DEFAULT NULL,
  `ServerCost` decimal(18,2) DEFAULT NULL,
  `ServerQuantity` int(10) DEFAULT NULL,
  `SupplierPriceMarkup` decimal(5,3) default null,
  `CoreQuantity` varchar(15) DEFAULT NULL,
  `ServerCoreID` bigint(20) DEFAULT NULL, 
  `Unit` varchar(15) DEFAULT NULL,
  `Volume` varchar(15) DEFAULT NULL,
  `Note` varchar(50) DEFAULT NULL,
  `Period` varchar(20) DEFAULT NULL,
  `Doc` varchar(20) DEFAULT NULL,
  `RegistryCost` decimal(8,2) DEFAULT NULL,
  `VitallyImportant` tinyint(1) NOT NULL,
  `RetailMarkup` decimal(12,6) default null,
  `ProducerCost` decimal(18,2) default null, 
  `NDS` smallint(5) default null,
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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
  `ProviderName` varchar(50) NOT NULL DEFAULT '�� "�������"',
  `ProviderAddress` varchar(30) NOT NULL DEFAULT '��������� ��-�, 160 ��.415',
  `ProviderPhones` varchar(30) NOT NULL DEFAULT '4732-606000',
  `ProviderEmail` varchar(30) NOT NULL DEFAULT 'farm@analit.net',
  `ProviderWeb` varchar(30) NOT NULL DEFAULT 'http://www.analit.net/',
  `ProviderMDBVersion` smallint(6) NOT NULL DEFAULT '49',
  `ConfirmSendingOrders` tinyint(1) NOT NULL DEFAULT '0',
  `UseCorrectOrders` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_PARAMS` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  pricesregionaldataup
-- 

DROP TABLE IF EXISTS pricesregionaldataup;
CREATE TABLE `pricesregionaldataup` (
  `PRICECODE` bigint(20) NOT NULL,
  `REGIONCODE` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  producers
-- 

DROP TABLE IF EXISTS producers;
CREATE TABLE `producers` (
  `Id`          bigint(20) not null  , 
  `Name`        varchar(255) not null, 
  `Hidden`      tinyint(1) not null, 
  PRIMARY KEY (`Id`), 
  Key(`Name`) 
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  providersettings
-- 

DROP TABLE IF EXISTS providersettings;
CREATE TABLE `providersettings` (
  `FirmCode` bigint(20) NOT NULL,
  `WaybillFolder` varchar(255) default null,
  PRIMARY KEY (`FirmCode`),
  UNIQUE KEY `PK_ProviderSettings` (`FirmCode`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  retailmargins
-- 

DROP TABLE IF EXISTS retailmargins;
CREATE TABLE `retailmargins` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `LEFTLIMIT` decimal(18,2) NOT NULL,
  `RIGHTLIMIT` decimal(18,2) NOT NULL,
  `Markup` decimal(5,2) NOT NULL,
  `MaxMarkup` decimal(5,2) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_RETAILMARGINS` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  synonymfirmcr
-- 

DROP TABLE IF EXISTS synonymfirmcr;
CREATE TABLE `synonymfirmcr` (
  `SYNONYMFIRMCRCODE` bigint(20) NOT NULL,
  `SYNONYMNAME` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`SYNONYMFIRMCRCODE`),
  UNIQUE KEY `PK_SYNONYMFIRMCR` (`SYNONYMFIRMCRCODE`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  tmpproviders
-- 

DROP TABLE IF EXISTS tmpproviders;
CREATE TABLE `tmpproviders` (
  `FIRMCODE` bigint(20) NOT NULL,
  `FULLNAME` varchar(40) DEFAULT NULL,
  `FAX` varchar(20) DEFAULT NULL,
  `MANAGERMAIL` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


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
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  tmpregions
-- 

DROP TABLE IF EXISTS tmpregions;
CREATE TABLE `tmpregions` (
  `REGIONCODE` bigint(20) NOT NULL,
  `REGIONNAME` varchar(25) DEFAULT NULL,
  `PRICERET` varchar(254) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  userinfo
-- 

DROP TABLE IF EXISTS userinfo;
CREATE TABLE `userinfo` (
  `ClientId` bigint(20) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `Addition` varchar(50) DEFAULT NULL,
  `InheritPrices` tinyint(1) NOT NULL DEFAULT '0',
  `IsFutureClient` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


-- 
-- Table structure for table  vitallyimportantmarkups
-- 

DROP TABLE IF EXISTS vitallyimportantmarkups;
CREATE TABLE `vitallyimportantmarkups` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `LeftLimit` decimal(18,2) NOT NULL,
  `RightLimit` decimal(18,2) NOT NULL,
  `Markup` decimal(5,2) NOT NULL,
  `MaxMarkup` decimal(5,2) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_VitallyImportantMarkups` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
