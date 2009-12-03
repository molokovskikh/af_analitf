alter table analitf.userinfo
  add column `InheritPrices` tinyint(1) NOT NULL DEFAULT '0';

update analitf.params set ProviderMDBVersion = 52 where id = 0;