alter table analitf.`client`
  add column `ParseWaybills` tinyint(1) unsigned not null default '0',
  add column  `SendRetailMarkup` tinyint(1) unsigned not null default '0';

alter table analitf.core
  add column `SupplierPriceMarkup` decimal(5,3) default null after `MINORDERCOUNT`;

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
  add column `RetailMarkup` decimal(12,6) default null;

update analitf.params set ProviderMDBVersion = 59 where id = 0;
