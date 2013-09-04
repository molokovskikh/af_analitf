alter table analitf.core
  add column `Exp` date default null after `Series`;

update analitf.params set ProviderMDBVersion = 99 where id = 0;