alter table analitf.`client`
  add column `CalculateOnProducerCost` tinyint(1) unsigned NOT NULL DEFAULT '0';

alter table analitf.`clients`
  add column `Address` varchar(255) default null,
  add column `Director` varchar(255) default null,
  add column `DeputyDirector` varchar(255) default null,
  add column `Accountant` varchar(255) default null,
  add column `MethodOfTaxation` smallint(5) not null default '0';

CREATE TABLE analitf.`documentbodies` (  
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
  `RetailMarkup` decimal(12,6) default null,
  `ManualCorrection` tinyint(1) unsigned not null default '0',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

CREATE TABLE analitf.`documentheaders` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `DownloadId` bigint(20) unsigned DEFAULT NULL,
  `WriteTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `FirmCode` bigint(20) unsigned DEFAULT NULL,
  `ClientId` bigint(20) unsigned DEFAULT NULL,
  `DocumentType` tinyint(3) unsigned DEFAULT NULL,
  `ProviderDocumentId` varchar(20) DEFAULT NULL,
  `OrderId` bigint(20) unsigned DEFAULT NULL,
  `Header` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

CREATE TABLE analitf.`providersettings` (
  `FirmCode` bigint(20) NOT NULL,
  `WaybillFolder` varchar(255) default null,
  PRIMARY KEY (`FirmCode`),
  UNIQUE KEY `PK_ProviderSettings` (`FirmCode`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

alter table analitf.`retailmargins`
  modify column `LEFTLIMIT` decimal(18,2) NOT NULL,
  modify column `RIGHTLIMIT` decimal(18,2) NOT NULL,
  change column `RETAIL` `Markup` decimal(5,2) NOT NULL,
  add column `MaxMarkup` decimal(5,2) NOT NULL;

update
  analitf.`retailmargins`
set
  MaxMarkup = Markup;  

CREATE TABLE analitf.`vitallyimportantmarkups` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `LeftLimit` decimal(18,2) NOT NULL,
  `RightLimit` decimal(18,2) NOT NULL,
  `Markup` decimal(5,2) NOT NULL,
  `MaxMarkup` decimal(5,2) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PK_VitallyImportantMarkups` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update analitf.params set ProviderMDBVersion = 58 where id = 0;
