CREATE TABLE analitf.`batchreport` (
  `Id` bigint(20) not null ,
  `ClientId` bigint(20) not null ,
  `SynonymName` varchar(250) default null ,
  `SynonymFirm` varchar(250) default null ,
  `Quantity`  int(10) not null            ,
  `Comment`  text                         ,
  `OrderListId` bigint(20) default null   ,
  `Status`     smallint(5) default null   ,
  `ProductId` bigint(20) default null     ,
  `CodeFirmCr` bigint(20) default null    ,
  primary key (`Id`)                       
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update analitf.params set ProviderMDBVersion = 65 where id = 0;