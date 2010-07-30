alter table analitf.`currentorderheads`
  add column `Frozen` tinyint(1) not null default '0';

alter table analitf.`core`
  add column `BuyingMatrixType` smallint(5) default null after `NDS`;

update analitf.params set ProviderMDBVersion = 66 where id = 0;