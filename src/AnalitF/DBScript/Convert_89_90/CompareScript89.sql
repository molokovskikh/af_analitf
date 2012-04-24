alter table analitf.clients
  add column `ExcessAvgOrderTimes` int(10) not null default '5';

update analitf.params set ProviderMDBVersion = 90 where id = 0;