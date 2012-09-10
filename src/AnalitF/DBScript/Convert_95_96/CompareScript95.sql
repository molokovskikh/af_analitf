alter table analitf.regionaldata
  add column `Address` varchar(255) default null;

update analitf.params set ProviderMDBVersion = 96 where id = 0;