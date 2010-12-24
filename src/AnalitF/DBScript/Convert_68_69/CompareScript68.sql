alter table analitf.DocumentBodies
  add `Printed` tinyint(1) unsigned not null default '1';

update analitf.params set ProviderMDBVersion = 69 where id = 0;