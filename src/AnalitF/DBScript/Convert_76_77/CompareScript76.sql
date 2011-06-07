alter table analitf.documentheaders
  add column `RetailAmountCalculated` tinyint(1) not null default '0';

alter table analitf.documentbodies
  add column `RetailAmount` decimal(18,4) unsigned DEFAULT NULL;

update analitf.documentheaders
set
  RetailAmountCalculated = 0
where
  RetailAmountCalculated = 1;

update analitf.params set ProviderMDBVersion = 77 where id = 0;