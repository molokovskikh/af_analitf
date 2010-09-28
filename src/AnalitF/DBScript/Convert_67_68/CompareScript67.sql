alter table analitf.postedorderheads
  add column `PriceDate` datetime null default null;

alter table analitf.core
  add column `CryptCost`    VARCHAR(32) default null after `BuyingMatrixType`;

alter table analitf.currentorderlists
  add column `CryptPrice`    VARCHAR(32) default null,
  add column `CryptRealPrice`    VARCHAR(32) default null;

alter table analitf.batchreport
  add column `ServiceField1` varchar(255) default null,
  add column `ServiceField2` varchar(255) default null,
  add column `ServiceField3` varchar(255) default null,
  add column `ServiceField4` varchar(255) default null,
  add column `ServiceField5` varchar(255) default null,
  add column `ServiceField6` varchar(255) default null,
  add column `ServiceField7` varchar(255) default null,
  add column `ServiceField8` varchar(255) default null,
  add column `ServiceField9` varchar(255) default null,
  add column `ServiceField10` varchar(255) default null,
  add column `ServiceField11` varchar(255) default null,
  add column `ServiceField12` varchar(255) default null,
  add column `ServiceField13` varchar(255) default null,
  add column `ServiceField14` varchar(255) default null,
  add column `ServiceField15` varchar(255) default null,
  add column `ServiceField16` varchar(255) default null,
  add column `ServiceField17` varchar(255) default null,
  add column `ServiceField18` varchar(255) default null,
  add column `ServiceField19` varchar(255) default null,
  add column `ServiceField20` varchar(255) default null,
  add column `ServiceField21` varchar(255) default null,
  add column `ServiceField22` varchar(255) default null,
  add column `ServiceField23` varchar(255) default null,
  add column `ServiceField24` varchar(255) default null,
  add column `ServiceField25` varchar(255) default null;

create table analitf.batchreportservicefields(
  `Id` bigint(20) not null AUTO_INCREMENT,
  `ClientId` bigint(20) not null ,
  `FieldName` varchar(250) not null ,
  primary key (`Id`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update 
  analitf.postedorderheads
set
  PriceDate = SendDate
where
  PriceDate is null;

update analitf.params set ProviderMDBVersion = 68 where id = 0;