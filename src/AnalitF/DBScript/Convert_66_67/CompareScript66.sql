alter table analitf.documentbodies
  add column `ManualRetailPrice` decimal(12,6) default null;

alter table analitf.mnn
  drop key IDX_MNN_RussianMnn;

alter table analitf.mnn
  drop column RussianMnn;

update analitf.params set ProviderMDBVersion = 67 where id = 0;