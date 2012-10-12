create table analitf.awaitedproducts
(
    `ID` bigint(20) not null AUTO_INCREMENT,
    `CatalogId` bigint(20) not null,
    `ProducerId` bigint(20) default null,
    primary key (Id),
    key `IDX_awaitedproducts_CatalogId` (`CatalogId`),
    key `IDX_awaitedproducts_ProducerId` (`ProducerId`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

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