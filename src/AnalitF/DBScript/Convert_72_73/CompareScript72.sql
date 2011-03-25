alter table analitf.catalogs
  add column `PromotionsCount`  int not null default '0';

alter table analitf.documentbodies
  modify column `ProducerCost` decimal(18,4) default null,
  modify column `RegistryCost` decimal(18,4) default null,
  modify column `SupplierCostWithoutNDS` decimal(18,4) default null,
  modify column `SupplierCost` decimal(18,4) default null;

create table analitf.supplierpromotions
(
  `Id` bigint(20) NOT NULL,
  `Status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `SupplierId` bigint(20) NOT NULL,
  `Annotation` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IDX_SupplierPromotions_SupplierId` (`SupplierId`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

create table analitf.promotioncatalogs
(
  `CatalogId` bigint(20)NOT NULL, 
  `PromotionId` bigint(20)NOT NULL,
  `Hidden` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`CatalogId`, `PromotionId`),
  KEY `IDX_PromotionCatalogs_CatalogId` (`CatalogId`),
  KEY `IDX_PromotionCatalogs_PromotionId` (`PromotionId`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update analitf.params set ProviderMDBVersion = 73 where id = 0;