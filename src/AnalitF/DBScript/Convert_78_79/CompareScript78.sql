alter table analitf.userinfo
  add column `ShowSupplierCost` tinyint(1) not null default '1';

alter table analitf.client
  add column `AllowDelayOfPayment` tinyint(1) not null default '0';

update analitf.params set ProviderMDBVersion = 79 where id = 0;