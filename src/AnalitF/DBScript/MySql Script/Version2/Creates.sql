-- ----------------------------------------------------------------------
-- MySQL Migration Toolkit
-- SQL Create Script
-- ----------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `AnalitF`
  CHARACTER SET cp1251 COLLATE cp1251_general_ci;
USE `AnalitF`;
-- -------------------------------------
-- Tables

DROP TABLE IF EXISTS `AnalitF`.`CATALOGCURRENCY`;
CREATE TABLE `AnalitF`.`CATALOGCURRENCY` (
  `CURRENCY` VARCHAR(6) NOT NULL,
  `EXCHANGE` DECIMAL(18, 4) NOT NULL,
  PRIMARY KEY (`CURRENCY`),
  UNIQUE INDEX `PK_CATALOGCURRENCY` (`CURRENCY`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`CATALOGFARMGROUPS`;
CREATE TABLE `AnalitF`.`CATALOGFARMGROUPS` (
  `ID` BIGINT NOT NULL,
  `NAME` VARCHAR(250) NULL,
  `DESCRIPTION` TEXT NULL,
  `PARENTID` BIGINT NULL,
  `GROUPTYPE` INT(10) NULL,
  PRIMARY KEY (`ID`),
  INDEX `FK_CATALOG_FARM_GROUPS_PARENT` (`PARENTID`),
  UNIQUE INDEX `PK_CATALOGFARMGROUPS` (`ID`),
  CONSTRAINT `FK_CATALOG_FARM_GROUPS_PARENT` FOREIGN KEY `FK_CATALOG_FARM_GROUPS_PARENT` (`PARENTID`)
    REFERENCES `AnalitF`.`CATALOGFARMGROUPS` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`CATALOGNAMES`;
CREATE TABLE `AnalitF`.`CATALOGNAMES` (
  `ID` BIGINT NOT NULL,
  `NAME` VARCHAR(250) NULL,
  `LATINNAME` VARCHAR(250) NULL,
  `DESCRIPTION` TEXT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `PK_CATALOGNAMES` (`ID`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`CATALOGS`;
CREATE TABLE `AnalitF`.`CATALOGS` (
  `FULLCODE` BIGINT NOT NULL,
  `SHORTCODE` BIGINT NOT NULL,
  `NAME` VARCHAR(250) NULL,
  `FORM` VARCHAR(250) NULL,
  `COREEXISTS` INT(10) NOT NULL,
  `VITALLYIMPORTANT` INT(10) NOT NULL,
  `NEEDCOLD` INT(10) NOT NULL,
  `FRAGILE` INT(10) NOT NULL,
  PRIMARY KEY (`FULLCODE`),
  INDEX `IDX_CATALOG_FORM` (`FORM`),
  INDEX `IDX_CATALOG_NAME` (`NAME`),
  INDEX `IDX_CATALOG_SHORTCODE` (`SHORTCODE`),
  UNIQUE INDEX `PK_CATALOGS` (`FULLCODE`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`CLIENTS`;
CREATE TABLE `AnalitF`.`CLIENTS` (
  `CLIENTID` BIGINT NOT NULL,
  `NAME` VARCHAR(50) NOT NULL,
  `REGIONCODE` BIGINT NULL,
  `EXCESS` INT(10) NOT NULL,
  `DELTAMODE` SMALLINT(5) NULL,
  `MAXUSERS` INT(10) NOT NULL,
  `REQMASK` BIGINT NULL,
  `TECHSUPPORT` VARCHAR(255) NULL,
  `CALCULATELEADER` INT(10) NOT NULL,
  `ONLYLEADERS` INT(10) NOT NULL,
  PRIMARY KEY (`CLIENTID`),
  INDEX `FK_CLIENTS_REGIONCODE` (`REGIONCODE`),
  UNIQUE INDEX `PK_CLIENTS` (`CLIENTID`),
  CONSTRAINT `FK_CLIENTS_REGIONCODE` FOREIGN KEY `FK_CLIENTS_REGIONCODE` (`REGIONCODE`)
    REFERENCES `AnalitF`.`REGIONS` (`REGIONCODE`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`CLIENTSDATAN`;
CREATE TABLE `AnalitF`.`CLIENTSDATAN` (
  `FIRMCODE` BIGINT NOT NULL,
  `FULLNAME` VARCHAR(40) NULL,
  `FAX` VARCHAR(20) NULL,
  `PHONE` VARCHAR(20) NULL,
  `MAIL` VARCHAR(50) NULL,
  `ADDRESS` VARCHAR(100) NULL,
  `BUSSSTOP` VARCHAR(100) NULL,
  `URL` VARCHAR(35) NULL,
  `ORDERMANAGERNAME` VARCHAR(100) NULL,
  `ORDERMANAGERPHONE` VARCHAR(35) NULL,
  `ORDERMANAGERMAIL` VARCHAR(50) NULL,
  `CLIENTMANAGERNAME` VARCHAR(100) NULL,
  `CLIENTMANAGERPHONE` VARCHAR(35) NULL,
  `CLIENTMANAGERMAIL` VARCHAR(50) NULL,
  PRIMARY KEY (`FIRMCODE`),
  UNIQUE INDEX `PK_CLIENTSDATAN` (`FIRMCODE`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`CORE`;
CREATE TABLE `AnalitF`.`CORE` (
  `COREID` BIGINT NOT NULL AUTO_INCREMENT,
  `PRICECODE` BIGINT NULL,
  `REGIONCODE` BIGINT NULL,
  `PRODUCTID` BIGINT NOT NULL,
  `CODEFIRMCR` BIGINT NULL,
  `SYNONYMCODE` BIGINT NULL,
  `SYNONYMFIRMCRCODE` BIGINT NULL,
  `CODE` VARCHAR(84) NULL,
  `CODECR` VARCHAR(84) NULL,
  `UNIT` VARCHAR(15) NULL,
  `VOLUME` VARCHAR(15) NULL,
  `JUNK` INT(10) NOT NULL,
  `AWAIT` INT(10) NOT NULL,
  `QUANTITY` VARCHAR(15) NULL,
  `NOTE` VARCHAR(50) NULL,
  `PERIOD` VARCHAR(20) NULL,
  `DOC` VARCHAR(20) NULL,
  `REGISTRYCOST` DECIMAL(8, 2) NULL,
  `VITALLYIMPORTANT` INT(10) NOT NULL,
  `REQUESTRATIO` INT(10) NULL,
  `BASECOST` VARCHAR(60) NULL,
  `SERVERCOREID` BIGINT NULL,
  `ORDERCOST` DECIMAL(18, 2) NULL,
  `MINORDERCOUNT` INT(10) NULL,
  PRIMARY KEY (`COREID`),
  UNIQUE INDEX `PK_CORE` (`COREID`),
  INDEX `FK_CORE_PRICECODE` (`PRICECODE`),
  INDEX `FK_CORE_PRODUCTID` (`PRODUCTID`),
  INDEX `FK_CORE_REGIONCODE` (`REGIONCODE`),
  INDEX `FK_CORE_SYNONYMCODE` (`SYNONYMCODE`),
  INDEX `FK_CORE_SYNONYMFIRMCRCODE` (`SYNONYMFIRMCRCODE`),
  INDEX `IDX_CORE_JUNK` (`PRODUCTID`, `JUNK`),
  INDEX `IDX_CORE_SERVERCOREID` (`SERVERCOREID`),
  CONSTRAINT `FK_CORE_PRICECODE` FOREIGN KEY `FK_CORE_PRICECODE` (`PRICECODE`)
    REFERENCES `AnalitF`.`PRICESDATA` (`PRICECODE`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_CORE_PRODUCTID` FOREIGN KEY `FK_CORE_PRODUCTID` (`PRODUCTID`)
    REFERENCES `AnalitF`.`PRODUCTS` (`PRODUCTID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_CORE_REGIONCODE` FOREIGN KEY `FK_CORE_REGIONCODE` (`REGIONCODE`)
    REFERENCES `AnalitF`.`REGIONS` (`REGIONCODE`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`DEFECTIVES`;
CREATE TABLE `AnalitF`.`DEFECTIVES` (
  `ID` BIGINT NOT NULL,
  `NAME` VARCHAR(250) NULL,
  `PRODUCER` VARCHAR(150) NULL,
  `COUNTRY` VARCHAR(150) NULL,
  `SERIES` VARCHAR(50) NULL,
  `LETTERNUMBER` VARCHAR(50) NULL,
  `LETTERDATE` TIMESTAMP NULL,
  `LABORATORY` VARCHAR(200) NULL,
  `REASON` TEXT NULL,
  `CHECKPRINT` INT(10) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `PK_DEFECTIVES` (`ID`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`FLAGS`;
CREATE TABLE `AnalitF`.`FLAGS` (
  `ID` BIGINT NOT NULL,
  `COMPUTERNAME` VARCHAR(50) NULL,
  `EXCLUSIVEID` VARCHAR(50) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `PK_FLAGS` (`ID`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`MINPRICES`;
CREATE TABLE `AnalitF`.`MINPRICES` (
  `PRODUCTID` BIGINT NULL,
  `REGIONCODE` BIGINT NULL,
  `SERVERCOREID` BIGINT NULL,
  `SERVERMEMOID` INT(10) NULL,
  INDEX `FK_MINPRICES_PRODUCTID` (`PRODUCTID`),
  INDEX `FK_MINPRICES_REGIONCODE` (`REGIONCODE`),
  CONSTRAINT `FK_MINPRICES_PRODUCTID` FOREIGN KEY `FK_MINPRICES_PRODUCTID` (`PRODUCTID`)
    REFERENCES `AnalitF`.`PRODUCTS` (`PRODUCTID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_MINPRICES_REGIONCODE` FOREIGN KEY `FK_MINPRICES_REGIONCODE` (`REGIONCODE`)
    REFERENCES `AnalitF`.`REGIONS` (`REGIONCODE`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`ORDERS`;
CREATE TABLE `AnalitF`.`ORDERS` (
  `ID` BIGINT NOT NULL AUTO_INCREMENT,
  `ORDERID` BIGINT NOT NULL,
  `CLIENTID` BIGINT NOT NULL,
  `COREID` BIGINT NULL,
  `PRODUCTID` BIGINT NOT NULL,
  `CODEFIRMCR` BIGINT NULL,
  `SYNONYMCODE` BIGINT NULL,
  `SYNONYMFIRMCRCODE` BIGINT NULL,
  `CODE` VARCHAR(84) NULL,
  `CODECR` VARCHAR(84) NULL,
  `SYNONYMNAME` VARCHAR(250) NULL,
  `SYNONYMFIRM` VARCHAR(250) NULL,
  `PRICE` VARCHAR(60) NULL,
  `AWAIT` INT(10) NOT NULL,
  `JUNK` INT(10) NOT NULL,
  `ORDERCOUNT` INT(10) NOT NULL,
  `SENDPRICE` DECIMAL(18, 2) NULL,
  `REQUESTRATIO` INT(10) NULL,
  `ORDERCOST` DECIMAL(18, 2) NULL,
  `MINORDERCOUNT` INT(10) NULL,
  PRIMARY KEY (`ID`),
  INDEX `FK_ORDERS_CLIENTID` (`CLIENTID`),
  INDEX `FK_ORDERS_ORDERID` (`ORDERID`),
  INDEX `IDX_ORDERS_CODEFIRMCR` (`CODEFIRMCR`),
  INDEX `IDX_ORDERS_COREID` (`COREID`),
  INDEX `IDX_ORDERS_ORDERCOUNT` (`ORDERCOUNT`),
  INDEX `IDX_ORDERS_PRODUCTID` (`PRODUCTID`),
  INDEX `IDX_ORDERS_SYNONYMCODE` (`SYNONYMCODE`),
  INDEX `IDX_ORDERS_SYNONYMFIRMCRCODE` (`SYNONYMFIRMCRCODE`),
  UNIQUE INDEX `PK_ORDERS` (`ID`),
  CONSTRAINT `FK_ORDERS_CLIENTID` FOREIGN KEY `FK_ORDERS_CLIENTID` (`CLIENTID`)
    REFERENCES `AnalitF`.`CLIENTS` (`CLIENTID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_ORDERS_ORDERID` FOREIGN KEY `FK_ORDERS_ORDERID` (`ORDERID`)
    REFERENCES `AnalitF`.`ORDERSH` (`ORDERID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`ORDERSH`;
CREATE TABLE `AnalitF`.`ORDERSH` (
  `ORDERID` BIGINT NOT NULL AUTO_INCREMENT,
  `SERVERORDERID` BIGINT NULL,
  `CLIENTID` BIGINT NOT NULL,
  `PRICECODE` BIGINT NOT NULL,
  `REGIONCODE` BIGINT NOT NULL,
  `PRICENAME` VARCHAR(70) NULL,
  `REGIONNAME` VARCHAR(25) NULL,
  `ORDERDATE` TIMESTAMP NULL,
  `SENDDATE` TIMESTAMP NULL,
  `CLOSED` INT(10) NOT NULL,
  `SEND` INT(10) NOT NULL DEFAULT 1,
  `COMMENTS` TEXT NULL,
  `MESSAGETO` TEXT NULL,
  PRIMARY KEY (`ORDERID`),
  INDEX `FK_ORDERSH_CLIENTID` (`CLIENTID`),
  INDEX `IDX_ORDERSH_ORDERDATE` (`ORDERDATE`),
  INDEX `IDX_ORDERSH_PRICECODE` (`PRICECODE`),
  INDEX `IDX_ORDERSH_REGIONCODE` (`REGIONCODE`),
  INDEX `IDX_ORDERSH_SENDDATE` (`SENDDATE`),
  UNIQUE INDEX `PK_ORDERSH` (`ORDERID`),
  CONSTRAINT `FK_ORDERSH_CLIENTID` FOREIGN KEY `FK_ORDERSH_CLIENTID` (`CLIENTID`)
    REFERENCES `AnalitF`.`CLIENTS` (`CLIENTID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`PARAMS`;
CREATE TABLE `AnalitF`.`PARAMS` (
  `ID` BIGINT NOT NULL,
  `CLIENTID` BIGINT NULL,
  `RASCONNECT` INT(10) NOT NULL,
  `RASENTRY` VARCHAR(30) NULL,
  `RASNAME` VARCHAR(30) NULL,
  `RASPASS` VARCHAR(30) NULL,
  `CONNECTCOUNT` SMALLINT(5) NOT NULL DEFAULT 5,
  `CONNECTPAUSE` SMALLINT(5) NOT NULL DEFAULT 5,
  `PROXYCONNECT` INT(10) NOT NULL,
  `PROXYNAME` VARCHAR(30) NULL,
  `PROXYPORT` INT(10) NULL,
  `PROXYUSER` VARCHAR(30) NULL,
  `PROXYPASS` VARCHAR(255) NULL,
  `SERVICENAME` VARCHAR(50) NULL DEFAULT 'PrgData',
  `HTTPHOST` VARCHAR(50) NULL DEFAULT 'ios.analit.net',
  `HTTPPORT` INT(10) NULL DEFAULT 80,
  `HTTPNAME` VARCHAR(30) NULL,
  `HTTPPASS` VARCHAR(255) NULL,
  `UPDATEDATETIME` TIMESTAMP NULL,
  `LASTDATETIME` TIMESTAMP NULL,
  `FASTPRINT` INT(10) NOT NULL,
  `SHOWREGISTER` INT(10) NOT NULL,
  `NEWWARES` INT(10) NOT NULL,
  `USEFORMS` INT(10) NOT NULL,
  `OPERATEFORMS` INT(10) NOT NULL,
  `OPERATEFORMSSET` INT(10) NOT NULL,
  `AUTOPRINT` INT(10) NOT NULL,
  `STARTPAGE` SMALLINT(5) NOT NULL DEFAULT 0,
  `LASTCOMPACT` TIMESTAMP NULL,
  `CUMULATIVE` INT(10) NOT NULL,
  `STARTED` INT(10) NOT NULL,
  `EXTERNALORDERSEXE` VARCHAR(255) NULL,
  `EXTERNALORDERSPATH` VARCHAR(255) NULL,
  `EXTERNALORDERSCREATE` INT(10) NOT NULL,
  `RASSLEEP` SMALLINT(5) NOT NULL DEFAULT 3,
  `HTTPNAMECHANGED` INT(10) NOT NULL,
  `SHOWALLCATALOG` INT(10) NOT NULL,
  `CDS` VARCHAR(224) NULL,
  `ORDERSHISTORYDAYCOUNT` INT(10) NOT NULL DEFAULT 21,
  `CONFIRMDELETEOLDORDERS` INT(10) NOT NULL DEFAULT 1,
  `USEOSOPENWAYBILL` INT(10) NOT NULL DEFAULT 0,
  `USEOSOPENREJECT` INT(10) NOT NULL DEFAULT 1,
  `GROUPBYPRODUCTS` INT(10) NOT NULL DEFAULT 0,
  `PRINTORDERSAFTERSEND` INT(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `PK_PARAMS` (`ID`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`PRICESDATA`;
CREATE TABLE `AnalitF`.`PRICESDATA` (
  `FIRMCODE` BIGINT NOT NULL,
  `PRICECODE` BIGINT NOT NULL,
  `PRICENAME` VARCHAR(70) NULL,
  `ALLOWINTEGR` INT(10) NOT NULL,
  `PRICEINFO` TEXT NULL,
  `DATEPRICE` TIMESTAMP NULL,
  `FRESH` INT(10) NOT NULL,
  `PRICEFMT` VARCHAR(3) NULL,
  `PRICEFILEDATE` TIMESTAMP NULL,
  `PATHTOPRICE` VARCHAR(255) NULL,
  `DELIMITER` VARCHAR(3) NULL,
  `PARENTSYNONYM` BIGINT NULL,
  `NAMEMASK` VARCHAR(255) NULL,
  `FORBWORDS` VARCHAR(255) NULL,
  `JUNKPOS` VARCHAR(10) NULL,
  `AWAITPOS` VARCHAR(10) NULL,
  `STARTLINE` INT(10) NULL,
  `LISTNAME` VARCHAR(50) NULL,
  `TXTCODEBEGIN` SMALLINT(5) NULL,
  `TXTCODEEND` SMALLINT(5) NULL,
  `TXTCODECRBEGIN` SMALLINT(5) NULL,
  `TXTCODECREND` SMALLINT(5) NULL,
  `TXTNAMEBEGIN` SMALLINT(5) NULL,
  `TXTNAMEEND` SMALLINT(5) NULL,
  `TXTFIRMCRBEGIN` SMALLINT(5) NULL,
  `TXTFIRMCREND` SMALLINT(5) NULL,
  `TXTBASECOSTBEGIN` SMALLINT(5) NULL,
  `TXTBASECOSTEND` SMALLINT(5) NULL,
  `TXTUNITBEGIN` SMALLINT(5) NULL,
  `TXTUNITEND` SMALLINT(5) NULL,
  `TXTVOLUMEBEGIN` SMALLINT(5) NULL,
  `TXTVOLUMEEND` SMALLINT(5) NULL,
  `TXTQUANTITYBEGIN` SMALLINT(5) NULL,
  `TXTQUANTITYEND` SMALLINT(5) NULL,
  `TXTNOTEBEGIN` SMALLINT(5) NULL,
  `TXTNOTEEND` SMALLINT(5) NULL,
  `TXTPERIODBEGIN` SMALLINT(5) NULL,
  `TXTPERIODEND` SMALLINT(5) NULL,
  `TXTDOCBEGIN` SMALLINT(5) NULL,
  `TXTDOCEND` SMALLINT(5) NULL,
  `TXTJUNKBEGIN` SMALLINT(5) NULL,
  `TXTJUNKEND` SMALLINT(5) NULL,
  `TXTAWAITBEGIN` SMALLINT(5) NULL,
  `TXTAWAITEND` SMALLINT(5) NULL,
  `FCODE` VARCHAR(20) NULL,
  `FCODECR` VARCHAR(20) NULL,
  `FNAME1` VARCHAR(20) NULL,
  `FNAME2` VARCHAR(20) NULL,
  `FNAME3` VARCHAR(20) NULL,
  `FFIRMCR` VARCHAR(20) NULL,
  `FBASECOST` VARCHAR(20) NULL,
  `FUNIT` VARCHAR(20) NULL,
  `FVOLUME` VARCHAR(20) NULL,
  `FQUANTITY` VARCHAR(20) NULL,
  `FNOTE` VARCHAR(20) NULL,
  `FPERIOD` VARCHAR(20) NULL,
  `FDOC` VARCHAR(20) NULL,
  `FJUNK` VARCHAR(20) NULL,
  `FAWAIT` VARCHAR(20) NULL,
  `PROTEK` INT(10) NOT NULL,
  PRIMARY KEY (`PRICECODE`),
  INDEX `FK_PRICESDATA_FIRMCODE` (`FIRMCODE`),
  UNIQUE INDEX `PK_PRICESDATA` (`PRICECODE`),
  CONSTRAINT `FK_PRICESDATA_FIRMCODE` FOREIGN KEY `FK_PRICESDATA_FIRMCODE` (`FIRMCODE`)
    REFERENCES `AnalitF`.`CLIENTSDATAN` (`FIRMCODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`PRICESREGIONALDATA`;
CREATE TABLE `AnalitF`.`PRICESREGIONALDATA` (
  `PRICECODE` BIGINT NOT NULL,
  `REGIONCODE` BIGINT NOT NULL,
  `STORAGE` INT(10) NOT NULL,
  `MINREQ` INT(10) NULL,
  `ENABLED` INT(10) NOT NULL,
  `INJOB` INT(10) NOT NULL,
  `CONTROLMINREQ` INT(10) NOT NULL,
  `PRICESIZE` INT(10) NULL,
  INDEX `FK_PRD_REGIONCODE` (`REGIONCODE`),
  INDEX `FK_PRICESREGIONALDATA_PRICECODE` (`PRICECODE`),
  CONSTRAINT `FK_PRICESREGIONALDATA_PRICECODE` FOREIGN KEY `FK_PRICESREGIONALDATA_PRICECODE` (`PRICECODE`)
    REFERENCES `AnalitF`.`PRICESDATA` (`PRICECODE`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_PRD_REGIONCODE` FOREIGN KEY `FK_PRD_REGIONCODE` (`REGIONCODE`)
    REFERENCES `AnalitF`.`REGIONS` (`REGIONCODE`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`PRICESREGIONALDATAUP`;
CREATE TABLE `AnalitF`.`PRICESREGIONALDATAUP` (
  `PRICECODE` BIGINT NOT NULL,
  `REGIONCODE` BIGINT NOT NULL
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`PRODUCTS`;
CREATE TABLE `AnalitF`.`PRODUCTS` (
  `PRODUCTID` BIGINT NOT NULL,
  `CATALOGID` BIGINT NOT NULL,
  PRIMARY KEY (`PRODUCTID`),
  INDEX `FK_PRODUCTS_CATALOGID` (`CATALOGID`),
  UNIQUE INDEX `PK_PRODUCTS` (`PRODUCTID`),
  CONSTRAINT `FK_PRODUCTS_CATALOGID` FOREIGN KEY `FK_PRODUCTS_CATALOGID` (`CATALOGID`)
    REFERENCES `AnalitF`.`CATALOGS` (`FULLCODE`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`PROVIDER`;
CREATE TABLE `AnalitF`.`PROVIDER` (
  `ID` BIGINT NOT NULL,
  `NAME` VARCHAR(50) NOT NULL,
  `ADDRESS` VARCHAR(30) NULL,
  `PHONES` VARCHAR(30) NULL,
  `EMAIL` VARCHAR(30) NULL,
  `WEB` VARCHAR(30) NULL,
  `MDBVERSION` SMALLINT(5) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `PK_PROVIDER` (`ID`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`RECEIVEDDOCS`;
CREATE TABLE `AnalitF`.`RECEIVEDDOCS` (
  `ID` BIGINT NOT NULL AUTO_INCREMENT,
  `FILENAME` VARCHAR(255) NOT NULL,
  `FILEDATETIME` TIMESTAMP NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `PK_RECEIVEDDOCS` (`ID`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`RECLAME`;
CREATE TABLE `AnalitF`.`RECLAME` (
  `RECLAMEURL` VARCHAR(128) NULL,
  `UPDATEDATETIME` TIMESTAMP NULL
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`REGIONALDATA`;
CREATE TABLE `AnalitF`.`REGIONALDATA` (
  `FIRMCODE` BIGINT NOT NULL,
  `REGIONCODE` BIGINT NOT NULL,
  `SUPPORTPHONE` VARCHAR(20) NULL,
  `ADMINMAIL` VARCHAR(50) NULL,
  `CONTACTINFO` TEXT NULL,
  `OPERATIVEINFO` TEXT NULL,
  INDEX `FK_REGIONALDATA_FIRMCODE` (`FIRMCODE`),
  INDEX `FK_REGIONALDATA_REGIONCODE` (`REGIONCODE`),
  CONSTRAINT `FK_REGIONALDATA_FIRMCODE` FOREIGN KEY `FK_REGIONALDATA_FIRMCODE` (`FIRMCODE`)
    REFERENCES `AnalitF`.`CLIENTSDATAN` (`FIRMCODE`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_REGIONALDATA_REGIONCODE` FOREIGN KEY `FK_REGIONALDATA_REGIONCODE` (`REGIONCODE`)
    REFERENCES `AnalitF`.`REGIONS` (`REGIONCODE`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`REGIONS`;
CREATE TABLE `AnalitF`.`REGIONS` (
  `REGIONCODE` BIGINT NOT NULL,
  `REGIONNAME` VARCHAR(25) NULL,
  `PRICERET` VARCHAR(254) NULL,
  PRIMARY KEY (`REGIONCODE`),
  UNIQUE INDEX `IDX_REGIONS_REGIONNAME` (`REGIONNAME`),
  UNIQUE INDEX `PK_REGIONS` (`REGIONCODE`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`REGISTRY`;
CREATE TABLE `AnalitF`.`REGISTRY` (
  `ID` BIGINT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(250) NULL,
  `FORM` VARCHAR(250) NULL,
  `PRODUCER` VARCHAR(150) NULL,
  `BOX` VARCHAR(10) NULL,
  `PRICE` DECIMAL(18, 4) NULL,
  `CURR` VARCHAR(10) NULL,
  `PRICERUB` DECIMAL(18, 4) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `PK_REGISTRY` (`ID`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`RETAILMARGINS`;
CREATE TABLE `AnalitF`.`RETAILMARGINS` (
  `ID` BIGINT NOT NULL AUTO_INCREMENT,
  `LEFTLIMIT` DECIMAL(18, 4) NOT NULL,
  `RIGHTLIMIT` DECIMAL(18, 4) NOT NULL,
  `RETAIL` INT(10) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `PK_RETAILMARGINS` (`ID`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`SYNONYMFIRMCR`;
CREATE TABLE `AnalitF`.`SYNONYMFIRMCR` (
  `SYNONYMFIRMCRCODE` BIGINT NOT NULL,
  `SYNONYMNAME` VARCHAR(250) NULL,
  PRIMARY KEY (`SYNONYMFIRMCRCODE`),
  UNIQUE INDEX `PK_SYNONYMFIRMCR` (`SYNONYMFIRMCRCODE`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`SYNONYMS`;
CREATE TABLE `AnalitF`.`SYNONYMS` (
  `SYNONYMCODE` BIGINT NOT NULL,
  `SYNONYMNAME` VARCHAR(250) NULL,
  PRIMARY KEY (`SYNONYMCODE`),
  UNIQUE INDEX `PK_SYNONYMS` (`SYNONYMCODE`),
  INDEX `IDX_SYNONYMNAME` (`SYNONYMNAME`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`TABLESUPDATES`;
CREATE TABLE `AnalitF`.`TABLESUPDATES` (
  `TABLENAME` VARCHAR(150) NULL,
  `UPDATEDATE` TIMESTAMP NULL
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`TMPCATALOGCURRENCY`;
CREATE TABLE `AnalitF`.`TMPCATALOGCURRENCY` (
  `CURRENCY` VARCHAR(6) NOT NULL,
  `EXCHANGE` DECIMAL(18, 4) NOT NULL
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`TMPCLIENTS`;
CREATE TABLE `AnalitF`.`TMPCLIENTS` (
  `CLIENTID` BIGINT NOT NULL,
  `NAME` VARCHAR(50) NOT NULL,
  `REGIONCODE` BIGINT NOT NULL,
  `ADDRESS` VARCHAR(100) NULL,
  `PHONE` VARCHAR(50) NULL,
  `FORCOUNT` INT(10) NULL,
  `EMAIL` VARCHAR(30) NULL,
  `MAXUSERS` INT(10) NOT NULL,
  `USEEXCESS` INT(10) NOT NULL,
  `EXCESS` INT(10) NOT NULL,
  `DELTAMODE` SMALLINT(5) NULL,
  `ONLYLEADERS` INT(10) NOT NULL,
  `REQMASK` BIGINT NULL,
  `TECHSUPPORT` VARCHAR(255) NULL,
  `LEADFROMBASIC` SMALLINT(5) NULL
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`TMPCLIENTSDATAN`;
CREATE TABLE `AnalitF`.`TMPCLIENTSDATAN` (
  `FIRMCODE` BIGINT NOT NULL,
  `FULLNAME` VARCHAR(40) NULL,
  `FAX` VARCHAR(20) NULL,
  `PHONE` VARCHAR(20) NULL,
  `MAIL` VARCHAR(50) NULL,
  `ADDRESS` VARCHAR(100) NULL,
  `BUSSSTOP` VARCHAR(100) NULL,
  `URL` VARCHAR(35) NULL,
  `ORDERMANAGERNAME` VARCHAR(100) NULL,
  `ORDERMANAGERPHONE` VARCHAR(35) NULL,
  `ORDERMANAGERMAIL` VARCHAR(50) NULL,
  `CLIENTMANAGERNAME` VARCHAR(100) NULL,
  `CLIENTMANAGERPHONE` VARCHAR(35) NULL,
  `CLIENTMANAGERMAIL` VARCHAR(50) NULL
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`TMPPRICESDATA`;
CREATE TABLE `AnalitF`.`TMPPRICESDATA` (
  `FIRMCODE` BIGINT NOT NULL,
  `PRICECODE` BIGINT NOT NULL,
  `PRICENAME` VARCHAR(70) NULL,
  `ALLOWINTEGR` INT(10) NOT NULL,
  `PRICEINFO` TEXT NULL,
  `DATEPRICE` TIMESTAMP NULL,
  `FRESH` INT(10) NOT NULL,
  `PRICEFMT` VARCHAR(3) NULL,
  `DELIMITER` VARCHAR(3) NULL,
  `PARENTSYNONYM` BIGINT NULL,
  `NAMEMASK` VARCHAR(255) NULL,
  `FORBWORDS` VARCHAR(255) NULL,
  `JUNKPOS` VARCHAR(10) NULL,
  `AWAITPOS` VARCHAR(10) NULL,
  `STARTLINE` INT(10) NULL,
  `LISTNAME` VARCHAR(50) NULL,
  `TXTCODEBEGIN` SMALLINT(5) NULL,
  `TXTCODEEND` SMALLINT(5) NULL,
  `TXTCODECRBEGIN` SMALLINT(5) NULL,
  `TXTCODECREND` SMALLINT(5) NULL,
  `TXTNAMEBEGIN` SMALLINT(5) NULL,
  `TXTNAMEEND` SMALLINT(5) NULL,
  `TXTFIRMCRBEGIN` SMALLINT(5) NULL,
  `TXTFIRMCREND` SMALLINT(5) NULL,
  `TXTBASECOSTBEGIN` SMALLINT(5) NULL,
  `TXTBASECOSTEND` SMALLINT(5) NULL,
  `TXTUNITBEGIN` SMALLINT(5) NULL,
  `TXTUNITEND` SMALLINT(5) NULL,
  `TXTVOLUMEBEGIN` SMALLINT(5) NULL,
  `TXTVOLUMEEND` SMALLINT(5) NULL,
  `TXTQUANTITYBEGIN` SMALLINT(5) NULL,
  `TXTQUANTITYEND` SMALLINT(5) NULL,
  `TXTNOTEBEGIN` SMALLINT(5) NULL,
  `TXTNOTEEND` SMALLINT(5) NULL,
  `TXTPERIODBEGIN` SMALLINT(5) NULL,
  `TXTPERIODEND` SMALLINT(5) NULL,
  `TXTDOCBEGIN` SMALLINT(5) NULL,
  `TXTDOCEND` SMALLINT(5) NULL,
  `TXTJUNKBEGIN` SMALLINT(5) NULL,
  `TXTJUNKEND` SMALLINT(5) NULL,
  `TXTAWAITBEGIN` SMALLINT(5) NULL,
  `TXTAWAITEND` SMALLINT(5) NULL,
  `FCODE` VARCHAR(20) NULL,
  `FCODECR` VARCHAR(20) NULL,
  `FNAME1` VARCHAR(20) NULL,
  `FNAME2` VARCHAR(20) NULL,
  `FNAME3` VARCHAR(20) NULL,
  `FFIRMCR` VARCHAR(20) NULL,
  `FBASECOST` VARCHAR(20) NULL,
  `FUNIT` VARCHAR(20) NULL,
  `FVOLUME` VARCHAR(20) NULL,
  `FQUANTITY` VARCHAR(20) NULL,
  `FNOTE` VARCHAR(20) NULL,
  `FPERIOD` VARCHAR(20) NULL,
  `FDOC` VARCHAR(20) NULL,
  `FJUNK` VARCHAR(20) NULL,
  `FAWAIT` VARCHAR(20) NULL,
  `PROTEK` INT(10) NOT NULL
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`TMPPRICESREGIONALDATA`;
CREATE TABLE `AnalitF`.`TMPPRICESREGIONALDATA` (
  `PRICECODE` BIGINT NOT NULL,
  `REGIONCODE` BIGINT NOT NULL,
  `STORAGE` INT(10) NOT NULL,
  `MINREQ` INT(10) NULL,
  `ENABLED` INT(10) NOT NULL,
  `INJOB` INT(10) NOT NULL,
  `CONTROLMINREQ` INT(10) NOT NULL
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`TMPREGIONALDATA`;
CREATE TABLE `AnalitF`.`TMPREGIONALDATA` (
  `FIRMCODE` BIGINT NOT NULL,
  `REGIONCODE` BIGINT NOT NULL,
  `SUPPORTPHONE` VARCHAR(20) NULL,
  `ADMINMAIL` VARCHAR(50) NULL,
  `CONTACTINFO` TEXT NULL,
  `OPERATIVEINFO` TEXT NULL
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`TMPREGIONS`;
CREATE TABLE `AnalitF`.`TMPREGIONS` (
  `REGIONCODE` BIGINT NOT NULL,
  `REGIONNAME` VARCHAR(25) NULL,
  `PRICERET` VARCHAR(254) NULL
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`WAYBILLHEAD`;
CREATE TABLE `AnalitF`.`WAYBILLHEAD` (
  `SERVERID` BIGINT NOT NULL,
  `SERVERORDERID` BIGINT NOT NULL,
  `WRITETIME` TIMESTAMP NULL,
  `CLIENTID` BIGINT NOT NULL,
  `PRICECODE` BIGINT NOT NULL,
  `REGIONCODE` BIGINT NOT NULL,
  `PRICENAME` VARCHAR(70) NULL,
  `REGIONNAME` VARCHAR(25) NULL,
  `FIRMCOMMENT` VARCHAR(100) NULL,
  `ROWCOUNT` INT(10) NULL,
  PRIMARY KEY (`SERVERID`),
  UNIQUE INDEX `PK_WAYBILLHEAD` (`SERVERID`)
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

DROP TABLE IF EXISTS `AnalitF`.`WAYBILLLIST`;
CREATE TABLE `AnalitF`.`WAYBILLLIST` (
  `SERVERID` BIGINT NOT NULL,
  `SERVERWAYBILLID` BIGINT NOT NULL,
  `FULLCODE` BIGINT NOT NULL,
  `CODEFIRMCR` BIGINT NOT NULL,
  `SYNONYMCODE` BIGINT NULL,
  `SYNONYMFIRMCRCODE` BIGINT NULL,
  `SYNONYMNAME` VARCHAR(250) NULL,
  `SYNONYMFIRM` VARCHAR(250) NULL,
  `CODE` VARCHAR(84) NULL,
  `CODECR` VARCHAR(84) NULL,
  `QUANTITY` INT(10) NULL,
  `BASECOST` VARCHAR(60) NULL,
  INDEX `FK_WAYBILLLIST_SERVERWAYBILLID` (`SERVERWAYBILLID`),
  CONSTRAINT `FK_WAYBILLLIST_SERVERWAYBILLID` FOREIGN KEY `FK_WAYBILLLIST_SERVERWAYBILLID` (`SERVERWAYBILLID`)
    REFERENCES `AnalitF`.`WAYBILLHEAD` (`SERVERID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = MyIsam
CHARACTER SET cp1251 COLLATE cp1251_general_ci;



SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------
-- EOF

