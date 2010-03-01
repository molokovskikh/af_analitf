alter table analitf.catalogs
  add column `MandatoryList`    tinyint(1) not null after `FRAGILE`, 
  add column `MnnId` bigint(20) default null after `MandatoryList`,
  add column `DescriptionId` bigint(20) default null after `MnnId`,
  add key `IDX_CATALOG_MnnId` (`MnnId`),
  add key `IDX_CATALOG_DescriptionId` (`DescriptionId`);

CREATE TABLE analitf.`Descriptions` (
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
  PRIMARY KEY (`Id`),
  Key(`Name`),
  Key(`EnglishName`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

CREATE TABLE analitf.`mnn` (
    `Id`               bigint(20) not null  , 
    `Mnn`              varchar(250) not null, 
    primary key (`Id`),
    key `IDX_MNN_Mnn` (`Mnn`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update analitf.params set ProviderMDBVersion = 56 where id = 0;
