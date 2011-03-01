drop table if exists analitf.globalparams;

create table analitf.globalparams(
  `Name` varchar(255) not null,
  `Value` varchar(255) default null,
  primary key (`Name`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


alter table analitf.minprices
  add column `Percent` decimal(18,2) default null,
  add key `IDX_MINPRICES_MinCost` (`MinCost`),
  add key `IDX_MINPRICES_NextCost` (`NextCost`),
  add key `IDX_MINPRICES_Percent` (`Percent`);

update analitf.params set ProviderMDBVersion = 72 where id = 0;