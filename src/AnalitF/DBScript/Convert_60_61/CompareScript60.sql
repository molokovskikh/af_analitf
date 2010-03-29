alter table analitf.`client`
  add column `ParseWaybills` tinyint(1) unsigned not null default '0',
  add column `SendRetailMarkup` tinyint(1) unsigned not null default '0',
  add column `ShowAdvertising` tinyint(1) unsigned not null default '1';

alter table analitf.core
  add column `SupplierPriceMarkup` decimal(5,3) default null after `MINORDERCOUNT`,
  add column `ProducerCost` decimal(18,2) default null after `SupplierPriceMarkup`,
  add column `NDS` smallint(5) default null after `ProducerCost`;

alter table analitf.ordershead
  add column `DelayOfPayment` decimal(5,3) default null;

alter table analitf.orderslist
  add column `SupplierPriceMarkup` decimal(5,3) default null,
  add column `CoreQuantity` varchar(15) DEFAULT NULL,
  add column `ServerCoreID` bigint(20) DEFAULT NULL, 
  add column `Unit` varchar(15) DEFAULT NULL,
  add column `Volume` varchar(15) DEFAULT NULL,
  add column `Note` varchar(50) DEFAULT NULL,
  add column `Period` varchar(20) DEFAULT NULL,
  add column `Doc` varchar(20) DEFAULT NULL,
  add column `RegistryCost` decimal(8,2) DEFAULT NULL,
  add column `VitallyImportant` tinyint(1) NOT NULL,
  add column `RetailMarkup` decimal(12,6) default null,
  add column `ProducerCost` decimal(18,2) default null,
  add column `NDS` smallint(5) default null;

CREATE TABLE analitf.`maxproducercosts` (
  `Id`          bigint(20) not null  ,
  `CatalogId`   bigint(20) not null  ,
  `ProductId`   bigint(20) not null  ,
  `Product`     varchar(255) not null,
  `Producer`    varchar(255) not null,
  `Cost`        decimal(18,2) default null,
  PRIMARY KEY (`Id`),
  Key(`CatalogId`),
  Key(`ProductId`),
  Key(`Product`),
  Key(`Producer`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

alter table analitf.mnn
  add column `RussianMnn` varchar(250) default null,
  add index `IDX_MNN_RussianMnn` (`RussianMnn`);

CREATE TABLE analitf.`clientsettings` (
  `ClientId`         bigint(20) not null,
  `OnlyLeaders`      tinyint(1) not null,
  `Address`          varchar(255) default null,
  `Director`         varchar(255) default null,
  `DeputyDirector`   varchar(255) default null,
  `Accountant`       varchar(255) default null,
  `MethodOfTaxation` smallint(5) not null default '0',
  `CalculateWithNDS` tinyint(1) not null default '1',
  primary key (`CLIENTID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

insert into analitf.`clientsettings`
  (ClientId, OnlyLeaders, Address, Director, DeputyDirector, Accountant, MethodOfTaxation)
select 
  ClientId, OnlyLeaders, Address, Director, DeputyDirector, Accountant, MethodOfTaxation
from
  analitf.`clients`;

alter table analitf.`clients`
  drop column `OnlyLeaders`,
  drop column `Address`,
  drop column `Director`,
  drop column `DeputyDirector`,
  drop column `Accountant`,
  drop column `MethodOfTaxation`;

update analitf.params set ProviderMDBVersion = 61 where id = 0;