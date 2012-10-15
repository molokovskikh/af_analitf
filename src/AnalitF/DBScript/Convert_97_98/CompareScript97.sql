create table analitf.awaitedproducts
(
    `ID` bigint(20) not null AUTO_INCREMENT,
    `CatalogId` bigint(20) not null,
    `ProducerId` bigint(20) default null,
    primary key (Id),
    key `IDX_awaitedproducts_CatalogId` (`CatalogId`),
    key `IDX_awaitedproducts_ProducerId` (`ProducerId`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

alter table analitf.core
  modify column `Note` varchar(100) default null;

alter table analitf.currentorderlists
  modify column `Note` varchar(100) default null;

alter table analitf.postedorderlists
  modify column `Note` varchar(100) default null;

update analitf.globalparams
set
  Value = "90"
where
  Name = "NewRejectsDayCount";

update analitf.globalparams
set
  Value = "33023"
where
  Name = "lnModifiedWaybillByReject";

update analitf.globalparams
set
  Value = "33023"
where
  Name = "lnRejectedWaybillPosition";

update analitf.globalparams
set
  Value = "32896"
where
  Name = "lnUnrejectedWaybillPosition";

update analitf.params set ProviderMDBVersion = 98 where id = 0;