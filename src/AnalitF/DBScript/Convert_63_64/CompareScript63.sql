alter table analitf.providers
  add column `ShortName`    varchar(50) default null;

alter table analitf.retailmargins
  add column `MaxSupplierMarkup` decimal(5,2) default NULL;

alter table analitf.VitallyImportantMarkups
  add column `MaxSupplierMarkup` decimal(5,2) default NULL;

CREATE TABLE analitf.`minreqrules` (
  `ClientId`      bigint(20) not null,
  `PriceCode`     bigint(20) not null,
  `RegionCode`    bigint(20) not null,
  `ControlMinReq` tinyint(1) not null,
  `MinReq`        int(10) default null,
  primary key (`ClientId`, `PriceCode`, `RegionCode`),
  key `FK_minreqrules_ClientId` (`ClientId`),
  key `FK_minreqrules_PriceCode` (`PriceCode`),
  key `FK_minreqrules_RegionCode` (`RegionCode`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


delete from analitf.VitallyImportantMarkups;

INSERT INTO analitf.VitallyImportantMarkups (ID, LeftLimit, RightLimit, Markup, MaxMarkup) VALUES (1, 0, 50, 20, 20);

INSERT INTO analitf.VitallyImportantMarkups (ID, LeftLimit, RightLimit, Markup, MaxMarkup) VALUES (2, 50, 500, 20, 20);

INSERT INTO analitf.VitallyImportantMarkups (ID, LeftLimit, RightLimit, Markup, MaxMarkup) VALUES (3, 500, 1000000, 20, 20);

update analitf.params set ProviderMDBVersion = 64 where id = 0;