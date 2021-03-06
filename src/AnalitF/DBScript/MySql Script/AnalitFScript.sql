﻿-- Database script was generated by Core Lab MyDeveloper
-- Script date 27.05.2009 15:44:54
-- MySQL server version: 5.1.31-community
-- MySQL client version: 4.1
-- ---------------------------------------------------------------------- 
-- Server: localhost
-- Port: 3306
-- Database: analitf

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Database analitf structure
-- 

create database /*!32312 IF NOT EXISTS*/ analitf
	character set cp1251
	collate cp1251_general_ci;

use analitf;

-- 
-- Table structure for table catalogfarmgroups
-- 
create table `catalogfarmgroups` (
  `ID` bigint(20) not null,
  `NAME` varchar(250) default null,
  `DESCRIPTION` text,
  `PARENTID` bigint(20) default null,
  `GROUPTYPE` int(10) default null,
  primary key (`ID`),
  unique key `PK_CATALOGFARMGROUPS` (`ID`),
  key `FK_CATALOG_FARM_GROUPS_PARENT` (`PARENTID`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table catalognames
-- 
create table `catalognames` (
  `ID` bigint(20) not null,
  `NAME` varchar(250) default null,
  `LATINNAME` varchar(250) default null,
  `DESCRIPTION` text,
  primary key (`ID`),
  unique key `PK_CATALOGNAMES` (`ID`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table catalogs
-- 
create table `catalogs` (
  `FULLCODE` bigint(20) not null,
  `SHORTCODE` bigint(20) not null,
  `NAME` varchar(250) default null,
  `FORM` varchar(250) default null,
  `VITALLYIMPORTANT` tinyint(1) not null,
  `NEEDCOLD` tinyint(1) not null,
  `FRAGILE` tinyint(1) not null,
  `COREEXISTS` tinyint(1) not null,
  primary key (`FULLCODE`),
  unique key `PK_CATALOGS` (`FULLCODE`),
  key `IDX_CATALOG_FORM` (`FORM`),
  key `IDX_CATALOG_NAME` (`NAME`),
  key `IDX_CATALOG_SHORTCODE` (`SHORTCODE`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table clients
-- 
create table `clients` (
  `CLIENTID` bigint(20) not null,
  `NAME` varchar(50) not null,
  `REGIONCODE` bigint(20) default null,
  `EXCESS` int(10) not null,
  `DELTAMODE` smallint(5) default null,
  `MAXUSERS` int(10) not null,
  `REQMASK` bigint(20) default null,
  `CALCULATELEADER` tinyint(1) not null,
  `ONLYLEADERS` tinyint(1) not null,
  primary key (`CLIENTID`),
  unique key `PK_CLIENTS` (`CLIENTID`),
  key `FK_CLIENTS_REGIONCODE` (`REGIONCODE`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table core
-- 
create table `core` (
  `PRICECODE` bigint(20) default null,
  `REGIONCODE` bigint(20) default null,
  `PRODUCTID` bigint(20) not null,
  `CODEFIRMCR` bigint(20) default null,
  `SYNONYMCODE` bigint(20) default null,
  `SYNONYMFIRMCRCODE` bigint(20) default null,
  `CODE` varchar(84) default null,
  `CODECR` varchar(84) default null,
  `UNIT` varchar(15) default null,
  `VOLUME` varchar(15) default null,
  `JUNK` tinyint(1) not null,
  `AWAIT` tinyint(1) not null,
  `QUANTITY` varchar(15) default null,
  `NOTE` varchar(50) default null,
  `PERIOD` varchar(20) default null,
  `DOC` varchar(20) default null,
  `REGISTRYCOST` decimal(8,2) default null,
  `VITALLYIMPORTANT` tinyint(1) not null,
  `REQUESTRATIO` int(10) default null,
  `Cost` decimal(18,2) default null,
  `SERVERCOREID` bigint(20) default null,
  `ORDERCOST` decimal(18,2) default null,
  `MINORDERCOUNT` int(10) default null,
  `COREID` bigint(20) not null auto_increment,
  primary key (`COREID`),
  unique key `PK_CORE` (`COREID`),
  key `FK_CORE_PRICECODE` (`PRICECODE`),
  key `FK_CORE_PRODUCTID` (`PRODUCTID`),
  key `FK_CORE_REGIONCODE` (`REGIONCODE`),
  key `FK_CORE_SYNONYMCODE` (`SYNONYMCODE`),
  key `FK_CORE_SYNONYMFIRMCRCODE` (`SYNONYMFIRMCRCODE`),
  key `IDX_CORE_JUNK` (`PRODUCTID`,`JUNK`),
  key `IDX_CORE_SERVERCOREID` (`SERVERCOREID`)
) engine=MyISAM auto_increment=1906729 default charset=cp1251;

-- 
-- Table structure for table defectives
-- 
create table `defectives` (
  `ID` bigint(20) not null,
  `NAME` varchar(250) default null,
  `PRODUCER` varchar(150) default null,
  `COUNTRY` varchar(150) default null,
  `SERIES` varchar(50) default null,
  `LETTERNUMBER` varchar(50) default null,
  `LETTERDATE` timestamp null default null,
  `LABORATORY` varchar(200) default null,
  `REASON` text,
  `CHECKPRINT` tinyint(1) not null,
  primary key (`ID`),
  unique key `PK_DEFECTIVES` (`ID`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table minprices
-- 
create table `minprices` (
  `PRODUCTID` bigint(20) not null default '0',
  `REGIONCODE` bigint(20) not null default '0',
  `SERVERCOREID` bigint(20) default null,
  `PriceCode` bigint(20) default null,
  `MinCost` decimal(18,2) default null,
  primary key (`PRODUCTID`,`REGIONCODE`),
  key `FK_MINPRICES_PRODUCTID` (`PRODUCTID`),
  key `FK_MINPRICES_REGIONCODE` (`REGIONCODE`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table ordershead
-- 
create table `ordershead` (
  `ORDERID` bigint(20) not null auto_increment,
  `SERVERORDERID` bigint(20) default null,
  `CLIENTID` bigint(20) not null,
  `PRICECODE` bigint(20) not null,
  `REGIONCODE` bigint(20) not null,
  `PRICENAME` varchar(70) default null,
  `REGIONNAME` varchar(25) default null,
  `ORDERDATE` timestamp null default null,
  `SENDDATE` timestamp null default null,
  `CLOSED` tinyint(1) not null,
  `SEND` tinyint(1) not null default '1',
  `COMMENTS` text,
  `MESSAGETO` text,
  primary key (`ORDERID`),
  unique key `PK_ORDERSH` (`ORDERID`),
  key `FK_ORDERSH_CLIENTID` (`CLIENTID`),
  key `IDX_ORDERSH_ORDERDATE` (`ORDERDATE`),
  key `IDX_ORDERSH_PRICECODE` (`PRICECODE`),
  key `IDX_ORDERSH_REGIONCODE` (`REGIONCODE`),
  key `IDX_ORDERSH_SENDDATE` (`SENDDATE`)
) engine=MyISAM auto_increment=40 default charset=cp1251;

-- 
-- Table structure for table orderslist
-- 
create table `orderslist` (
  `ID` bigint(20) not null auto_increment,
  `ORDERID` bigint(20) not null,
  `CLIENTID` bigint(20) not null,
  `COREID` bigint(20) default null,
  `PRODUCTID` bigint(20) not null,
  `CODEFIRMCR` bigint(20) default null,
  `SYNONYMCODE` bigint(20) default null,
  `SYNONYMFIRMCRCODE` bigint(20) default null,
  `CODE` varchar(84) default null,
  `CODECR` varchar(84) default null,
  `SYNONYMNAME` varchar(250) default null,
  `SYNONYMFIRM` varchar(250) default null,
  `PRICE` decimal(18,2) default null,
  `AWAIT` tinyint(1) not null,
  `JUNK` tinyint(1) not null,
  `ORDERCOUNT` int(10) not null,
  `REQUESTRATIO` int(10) default null,
  `ORDERCOST` decimal(18,2) default null,
  `MINORDERCOUNT` int(10) default null,
  primary key (`ID`),
  unique key `PK_ORDERS` (`ID`),
  key `FK_ORDERS_CLIENTID` (`CLIENTID`),
  key `FK_ORDERS_ORDERID` (`ORDERID`),
  key `IDX_ORDERS_CODEFIRMCR` (`CODEFIRMCR`),
  key `IDX_ORDERS_COREID` (`COREID`),
  key `IDX_ORDERS_ORDERCOUNT` (`ORDERCOUNT`),
  key `IDX_ORDERS_PRODUCTID` (`PRODUCTID`),
  key `IDX_ORDERS_SYNONYMCODE` (`SYNONYMCODE`),
  key `IDX_ORDERS_SYNONYMFIRMCRCODE` (`SYNONYMFIRMCRCODE`)
) engine=MyISAM auto_increment=139 default charset=cp1251;

-- 
-- Table structure for table params
-- 
create table `params` (
  `ID` bigint(20) not null,
  `CLIENTID` bigint(20) default null,
  `RASCONNECT` tinyint(1) not null,
  `RASENTRY` varchar(30) default null,
  `RASNAME` varchar(30) default null,
  `RASPASS` varchar(30) default null,
  `CONNECTCOUNT` smallint(5) not null default '5',
  `CONNECTPAUSE` smallint(5) not null default '5',
  `PROXYCONNECT` tinyint(1) not null,
  `PROXYNAME` varchar(30) default null,
  `PROXYPORT` int(10) default null,
  `PROXYUSER` varchar(30) default null,
  `PROXYPASS` varchar(255) default null,
  `SERVICENAME` varchar(50) default 'PrgData',
  `HTTPHOST` varchar(50) default 'ios.analit.net',
  `HTTPPORT` int(10) default '80',
  `HTTPNAME` varchar(30) default null,
  `HTTPPASS` varchar(255) default null,
  `UPDATEDATETIME` timestamp null default null,
  `LASTDATETIME` timestamp null default null,
  `FASTPRINT` tinyint(1) not null,
  `SHOWREGISTER` tinyint(1) not null,
  `USEFORMS` tinyint(1) not null,
  `OPERATEFORMS` tinyint(1) not null,
  `OPERATEFORMSSET` tinyint(1) not null,
  `AUTOPRINT` int(10) not null,
  `STARTPAGE` smallint(5) not null default '0',
  `LASTCOMPACT` timestamp null default null,
  `CUMULATIVE` tinyint(1) not null,
  `STARTED` tinyint(1) not null,
  `EXTERNALORDERSEXE` varchar(255) default null,
  `EXTERNALORDERSPATH` varchar(255) default null,
  `EXTERNALORDERSCREATE` int(10) not null,
  `RASSLEEP` smallint(5) not null default '3',
  `HTTPNAMECHANGED` tinyint(1) not null,
  `SHOWALLCATALOG` tinyint(1) not null,
  `CDS` varchar(224) default null,
  `ORDERSHISTORYDAYCOUNT` int(10) not null default '21',
  `CONFIRMDELETEOLDORDERS` tinyint(1) not null,
  `USEOSOPENWAYBILL` tinyint(1) not null,
  `USEOSOPENREJECT` tinyint(1) not null,
  `GROUPBYPRODUCTS` tinyint(1) not null,
  `PRINTORDERSAFTERSEND` tinyint(1) not null,
  `ProviderName` varchar(50) not null default '�� "�������"',
  `ProviderAddress` varchar(30) not null default '��������� ��-�, 160 ��.415',
  `ProviderPhones` varchar(30) not null default '4732-606000',
  `ProviderEmail` varchar(30) not null default 'farm@analit.net',
  `ProviderWeb` varchar(30) not null default 'http://www.analit.net/',
  `ProviderMDBVersion` smallint(6) not null default '49',
  `ReclameUPDATEDATETIME` datetime default null,
  primary key (`ID`),
  unique key `PK_PARAMS` (`ID`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table pricesdata
-- 
create table `pricesdata` (
  `FIRMCODE` bigint(20) not null,
  `PRICECODE` bigint(20) not null,
  `PRICENAME` varchar(70) default null,
  `PRICEINFO` text,
  `DATEPRICE` datetime default null,
  `FRESH` tinyint(1) not null,
  primary key (`PRICECODE`),
  unique key `PK_PRICESDATA` (`PRICECODE`),
  key `FK_PRICESDATA_FIRMCODE` (`FIRMCODE`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table pricesregionaldata
-- 
create table `pricesregionaldata` (
  `PRICECODE` bigint(20) not null default '0',
  `REGIONCODE` bigint(20) not null default '0',
  `STORAGE` tinyint(1) not null,
  `MINREQ` int(10) default null,
  `ENABLED` tinyint(1) not null,
  `INJOB` tinyint(1) not null,
  `CONTROLMINREQ` tinyint(1) not null,
  `PRICESIZE` int(10) default null,
  primary key (`PRICECODE`,`REGIONCODE`),
  key `FK_PRD_REGIONCODE` (`REGIONCODE`),
  key `FK_PRICESREGIONALDATA_PRICECODE` (`PRICECODE`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table pricesregionaldataup
-- 
create table `pricesregionaldataup` (
  `PRICECODE` bigint(20) not null,
  `REGIONCODE` bigint(20) not null
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table products
-- 
create table `products` (
  `PRODUCTID` bigint(20) not null,
  `CATALOGID` bigint(20) not null,
  primary key (`PRODUCTID`),
  unique key `PK_PRODUCTS` (`PRODUCTID`),
  key `FK_PRODUCTS_CATALOGID` (`CATALOGID`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table providers
-- 
create table `providers` (
  `FIRMCODE` bigint(20) not null,
  `FULLNAME` varchar(40) default null,
  `FAX` varchar(20) default null,
  `PHONE` varchar(20) default null,
  `MAIL` varchar(50) default null,
  `ADDRESS` varchar(100) default null,
  `BUSSSTOP` varchar(100) default null,
  `URL` varchar(35) default null,
  `ORDERMANAGERNAME` varchar(100) default null,
  `ORDERMANAGERPHONE` varchar(35) default null,
  `ORDERMANAGERMAIL` varchar(50) default null,
  `CLIENTMANAGERNAME` varchar(100) default null,
  `CLIENTMANAGERPHONE` varchar(35) default null,
  `CLIENTMANAGERMAIL` varchar(50) default null,
  primary key (`FIRMCODE`),
  unique key `PK_CLIENTSDATAN` (`FIRMCODE`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table receiveddocs
-- 
create table `receiveddocs` (
  `ID` bigint(20) not null auto_increment,
  `FILENAME` varchar(255) not null,
  `FILEDATETIME` timestamp not null default current_timestamp on update current_timestamp,
  primary key (`ID`),
  unique key `PK_RECEIVEDDOCS` (`ID`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table regionaldata
-- 
create table `regionaldata` (
  `FIRMCODE` bigint(20) not null default '0',
  `REGIONCODE` bigint(20) not null default '0',
  `SUPPORTPHONE` varchar(20) default null,
  `ADMINMAIL` varchar(50) default null,
  `CONTACTINFO` text,
  `OPERATIVEINFO` text,
  primary key (`FIRMCODE`,`REGIONCODE`),
  key `FK_REGIONALDATA_FIRMCODE` (`FIRMCODE`),
  key `FK_REGIONALDATA_REGIONCODE` (`REGIONCODE`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table regions
-- 
create table `regions` (
  `REGIONCODE` bigint(20) not null,
  `REGIONNAME` varchar(25) default null,
  `PRICERET` varchar(254) default null,
  primary key (`REGIONCODE`),
  unique key `PK_REGIONS` (`REGIONCODE`),
  unique key `IDX_REGIONS_REGIONNAME` (`REGIONNAME`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table retailmargins
-- 
create table `retailmargins` (
  `ID` bigint(20) not null auto_increment,
  `LEFTLIMIT` decimal(18,4) not null,
  `RIGHTLIMIT` decimal(18,4) not null,
  `RETAIL` int(10) not null,
  primary key (`ID`),
  unique key `PK_RETAILMARGINS` (`ID`)
) engine=MyISAM auto_increment=13 default charset=cp1251;

-- 
-- Table structure for table synonymfirmcr
-- 
create table `synonymfirmcr` (
  `SYNONYMFIRMCRCODE` bigint(20) not null,
  `SYNONYMNAME` varchar(250) default null,
  primary key (`SYNONYMFIRMCRCODE`),
  unique key `PK_SYNONYMFIRMCR` (`SYNONYMFIRMCRCODE`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table synonyms
-- 
create table `synonyms` (
  `SYNONYMCODE` bigint(20) not null,
  `SYNONYMNAME` varchar(250) default null,
  primary key (`SYNONYMCODE`),
  unique key `PK_SYNONYMS` (`SYNONYMCODE`),
  fulltext key `IDX_SYNONYMNAME` (`SYNONYMNAME`)
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table tmpclients
-- 
create table `tmpclients` (
  `CLIENTID` bigint(20) not null,
  `NAME` varchar(50) not null,
  `REGIONCODE` bigint(20) default null,
  `EXCESS` int(10) not null,
  `DELTAMODE` smallint(5) default null,
  `MAXUSERS` int(10) not null,
  `REQMASK` bigint(20) default null,
  `TECHSUPPORT` varchar(255) default null,
  `CALCULATELEADER` tinyint(1) not null,
  `ONLYLEADERS` tinyint(1) not null
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table tmppricesdata
-- 
create table `tmppricesdata` (
  `FIRMCODE` bigint(20) not null,
  `PRICECODE` bigint(20) not null,
  `PRICENAME` varchar(70) default null,
  `PRICEINFO` text,
  `DATEPRICE` datetime default null,
  `FRESH` tinyint(1) not null
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table tmppricesregionaldata
-- 
create table `tmppricesregionaldata` (
  `PRICECODE` bigint(20) not null,
  `REGIONCODE` bigint(20) not null,
  `STORAGE` tinyint(1) not null,
  `MINREQ` int(10) default null,
  `ENABLED` tinyint(1) not null,
  `INJOB` tinyint(1) not null,
  `CONTROLMINREQ` tinyint(1) not null
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table tmpproviders
-- 
create table `tmpproviders` (
  `FIRMCODE` bigint(20) not null,
  `FULLNAME` varchar(40) default null,
  `FAX` varchar(20) default null,
  `PHONE` varchar(20) default null,
  `MAIL` varchar(50) default null,
  `ADDRESS` varchar(100) default null,
  `BUSSSTOP` varchar(100) default null,
  `URL` varchar(35) default null,
  `ORDERMANAGERNAME` varchar(100) default null,
  `ORDERMANAGERPHONE` varchar(35) default null,
  `ORDERMANAGERMAIL` varchar(50) default null,
  `CLIENTMANAGERNAME` varchar(100) default null,
  `CLIENTMANAGERPHONE` varchar(35) default null,
  `CLIENTMANAGERMAIL` varchar(50) default null
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table tmpregionaldata
-- 
create table `tmpregionaldata` (
  `FIRMCODE` bigint(20) not null,
  `REGIONCODE` bigint(20) not null,
  `SUPPORTPHONE` varchar(20) default null,
  `ADMINMAIL` varchar(50) default null,
  `CONTACTINFO` text,
  `OPERATIVEINFO` text
) engine=MyISAM default charset=cp1251;

-- 
-- Table structure for table tmpregions
-- 
create table `tmpregions` (
  `REGIONCODE` bigint(20) not null,
  `REGIONNAME` varchar(25) default null,
  `PRICERET` varchar(254) default null
) engine=MyISAM default charset=cp1251;

-- 
-- Definition for view clientavg
-- 
create algorithm=undefined definer=`root`@`localhost` sql security definer view `clientavg` as select `ordershead`.`CLIENTID` as `CLIENTCODE`,`orderslist`.`PRODUCTID` as `PRODUCTID`,avg(`orderslist`.`PRICE`) as `PRICEAVG` from (`ordershead` join `orderslist`) where ((`orderslist`.`ORDERID` = `ordershead`.`ORDERID`) and (`ordershead`.`ORDERDATE` >= (curdate() - interval 1 month)) and (`ordershead`.`CLOSED` = 1) and (`ordershead`.`SEND` = 1) and (`orderslist`.`ORDERCOUNT` > 0) and (`orderslist`.`PRICE` is not null)) group by `ordershead`.`CLIENTID`,`orderslist`.`PRODUCTID`;

-- 
-- Definition for view pricesshow
-- 
create algorithm=undefined definer=`root`@`localhost` sql security definer view `pricesshow` as select `pd`.`PRICECODE` as `PriceCode`,`pd`.`PRICENAME` as `PriceName`,`pd`.`DATEPRICE` as `UniversalDatePrice`,`prd`.`MINREQ` as `MinReq`,`prd`.`ENABLED` as `Enabled`,`pd`.`PRICEINFO` as `PriceInfo`,`cd`.`FIRMCODE` as `FirmCode`,`cd`.`FULLNAME` as `FullName`,`prd`.`STORAGE` as `Storage`,`rd`.`ADMINMAIL` as `AdminMail`,`rd`.`SUPPORTPHONE` as `SupportPhone`,`rd`.`CONTACTINFO` as `ContactInfo`,`rd`.`OPERATIVEINFO` as `OperativeInfo`,`r`.`REGIONCODE` as `RegionCode`,`r`.`REGIONNAME` as `RegionName`,`prd`.`PRICESIZE` as `pricesize`,`prd`.`INJOB` as `INJOB`,`prd`.`CONTROLMINREQ` as `CONTROLMINREQ` from ((((`pricesdata` `pd` join `pricesregionaldata` `prd` on((`pd`.`PRICECODE` = `prd`.`PRICECODE`))) join `regions` `r` on((`prd`.`REGIONCODE` = `r`.`REGIONCODE`))) join `providers` `cd` on((`cd`.`FIRMCODE` = `pd`.`FIRMCODE`))) join `regionaldata` `rd` on(((`rd`.`REGIONCODE` = `prd`.`REGIONCODE`) and (`rd`.`FIRMCODE` = `cd`.`FIRMCODE`))));

-- 
-- Definition for stored procedure CATALOGSHOWBYFORM
-- 
create definer=`root`@`localhost` procedure `CATALOGSHOWBYFORM`(
    ashortcode bigint,
    showall tinyint(1))
begin
  if (showall = 1) then
    select CATALOGS.FullCode, CATALOGS.Form, catalogs.coreexists
    from CATALOGS
    where CATALOGS.ShortCode = AShortCode
    order by CATALOGS.Form;
  else
    select CATALOGS.FullCode, CATALOGS.Form, catalogs.coreexists
    from CATALOGS
    where CATALOGS.ShortCode= AShortCode
      and catalogs.coreexists = 1
    order by CATALOGS.Form;
  end if;
end;
/

-- 
-- Definition for stored procedure CATALOGSHOWBYNAME
-- 
create definer=`root`@`localhost` procedure `CATALOGSHOWBYNAME`(in showall tinyint(1))
begin
  if (showall = 1) then 
      select
        cat.ShortCode as AShortCode, cat.Name, sum(CoreExists) as CoreExists
      from CATALOGS cat
      group by cat.ShortCode, cat.Name
      order by cat.Name;
  else 
      select
        cat.ShortCode as AShortCode, cat.Name, sum(CoreExists) as CoreExists
      from CATALOGS cat
      where
        CoreExists = 1
      group by cat.ShortCode, cat.Name
      order by cat.Name;
  end if;  
end;
/

-- 
-- Definition for stored procedure DeleteOrder
-- 
create definer=`root`@`localhost` procedure `DeleteOrder`(in aorderid bigint)
begin
  delete from Ordershead where OrderId = aorderid;
  delete from OrdersList where OrderId = aorderid;
end;
/

-- 
-- Definition for stored procedure UPDATEORDERCOUNT
-- 
create definer=`root`@`localhost` procedure `UPDATEORDERCOUNT`(in aorderid bigint, in aclientid bigint, in apricecode bigint, in aregioncode bigint, in aordersorderid bigint, in acoreid bigint, in aordercount integer)
begin
  if (aorderid is null) then
    select ORDERID 
    from OrdersHead 
    where ClientId = AClientId 
      and PriceCode = APriceCode 
      and RegionCode = ARegionCode 
      and Closed  <> 1
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
      insert into OrdersList(ORDERID, CLIENTID, COREID, PRODUCTID, CODEFIRMCR,
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

end;
/

-- 
-- Definition for stored procedure UPDATEUPCOST
-- 
create definer=`root`@`localhost` procedure `UPDATEUPCOST`(in inPricecode bigint, in inRegioncode bigint, in ainjob integer)
begin
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
end;
/

-- 
-- Definition for stored function x_cast_to_int10
-- 
create definer=`root`@`localhost` function `x_cast_to_int10`(number bigint) returns int(10)
begin    return number;end;
/

-- 
-- Definition for stored function x_cast_to_tinyint
-- 
create definer=`root`@`localhost` function `x_cast_to_tinyint`(number bigint) returns tinyint(1)
begin    return number;end;
/

-- 
-- Dumping data for table params
-- 
lock tables params write;
insert into params(ID, CLIENTID, RASCONNECT, RASENTRY, RASNAME, RASPASS, CONNECTCOUNT, CONNECTPAUSE, PROXYCONNECT, PROXYNAME, PROXYPORT, PROXYUSER, PROXYPASS, SERVICENAME, HTTPHOST, HTTPPORT, HTTPNAME, HTTPPASS, UPDATEDATETIME, LASTDATETIME, FASTPRINT, SHOWREGISTER, USEFORMS, OPERATEFORMS, OPERATEFORMSSET, AUTOPRINT, STARTPAGE, LASTCOMPACT, CUMULATIVE, STARTED, EXTERNALORDERSEXE, EXTERNALORDERSPATH, EXTERNALORDERSCREATE, RASSLEEP, HTTPNAMECHANGED, SHOWALLCATALOG, CDS, ORDERSHISTORYDAYCOUNT, CONFIRMDELETEOLDORDERS, USEOSOPENWAYBILL, USEOSOPENREJECT, GROUPBYPRODUCTS, PRINTORDERSAFTERSEND, ProviderName, ProviderAddress, ProviderPhones, ProviderEmail, ProviderWeb, ProviderMDBVersion, ReclameUPDATEDATETIME) values (0, 1349, 0, '', null, null, 5, 5, 0, '', null, null, null, 'GetData', 'http://ios.analit.net/PrgDataTest', 80, 'sergei', ' %6A1№тяф3/щ*™юЩп0y', '2009-05-26 08:17:46', '2009-05-26 08:17:46', 0, 1, 1, 1, 1, 0, 0, '2009-05-26 12:22:00', 0, 0, null, null, 0, 3, 0, 0, '5216DCEB09F44BAE40B02ACC2D003134E7D79EB90FE0B57B20D43F407375F21A74268E8B50541BD37E3600617150CE95E7D79EB90FE0B57B20D43F407375F21AC8F706177BFBFFFB8A92062DAC490FE9E7D79EB90FE0B57B20D43F407375F21AD65F83E7F344DDC940F0438295B1E47B', 31, 1, 0, 1, 0, 0, 'АК \"Инфорум\"', 'Ленинский пр-т, 160 оф.415', '4732-606000', 'farm@analit.net', 'http://www.analit.net/', 49, '2009-05-26 12:17:50');
unlock tables;


/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

