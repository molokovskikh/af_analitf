alter table analitf.`client`
  add column  `ShowAdvertising` tinyint(1) unsigned not null default '1';

alter table analitf.core
  add column `ProducerCost` decimal(18,2) default null after `SupplierPriceMarkup`,
  add column `NDS` smallint(5) default null after `ProducerCost`;

alter table analitf.mnn
  add column `RussianMnn` varchar(250) default null,
  add index `IDX_MNN_RussianMnn` (`RussianMnn`);

alter table analitf.orderslist
  add column `ProducerCost` decimal(18,2) default null,
  add column `NDS` smallint(5) default null;

update analitf.params set ProviderMDBVersion = 60 where id = 0;
