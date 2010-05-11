alter table analitf.`client`
  add column `SendWaybillsFromClient` tinyint(1) unsigned not null default '0';

alter table analitf.`clients`
  add column `FullName` varchar(255) default null;

alter table  analitf.`clientsettings`
  add column `Name` varchar(255) default null;

alter table analitf.catalogs
  add column `Hidden`           tinyint(1) not null after `DescriptionId`;

alter table analitf.mnn
  add column `Hidden`           tinyint(1) not null;

alter table analitf.Descriptions
  add column `Hidden`           tinyint(1) not null;

alter table analitf.documentbodies
  add column `SerialNumber` varchar(50) default null after `NDS`;

alter table analitf.documentheaders
  change column `WriteTime` `WriteTime` datetime NOT NULL,
  add column `LoadTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  add KEY (`LoadTime`),
  add KEY (`DownloadId`),
  add KEY (`ClientId`);

update analitf.documentheaders set LoadTime = WriteTime where WriteTime is not null;

alter table analitf.maxproducercosts
  add column `ProducerId`  bigint(20) default null,
  add column `RealCost`    decimal(12,6) default null,
  add KEY(`Producer`),
  add KEY(`ProducerId`);

CREATE TABLE analitf.`producers` (
  `Id`          bigint(20) not null  , 
  `Name`        varchar(255) not null, 
  `Hidden`      tinyint(1) not null, 
  PRIMARY KEY (`Id`), 
  Key(`Name`) 
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


update analitf.params set ProviderMDBVersion = 63 where id = 0;