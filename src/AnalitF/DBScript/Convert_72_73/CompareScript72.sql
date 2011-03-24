alter table analitf.documentbodies
  modify column `ProducerCost` decimal(18,4) default null,
  modify column `RegistryCost` decimal(18,4) default null,
  modify column `SupplierCostWithoutNDS` decimal(18,4) default null,
  modify column `SupplierCost` decimal(18,4) default null;

update analitf.params set ProviderMDBVersion = 73 where id = 0;