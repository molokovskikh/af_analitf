alter table analitf.core
  add column `EAN13`                varchar(20) default null after `BuyingMatrixType`,
  add column `CodeOKP`              varchar(50) default null after `EAN13`,
  add column `Series`               varchar(20) default null after `CodeOKP`;

alter table analitf.currentorderlists
  add column `EAN13`                varchar(20) default null,
  add column `CodeOKP`              varchar(50) default null,
  add column `Series`               varchar(20) default null;

alter table analitf.postedorderlists
  add column `EAN13`                varchar(20) default null,
  add column `CodeOKP`              varchar(50) default null,
  add column `Series`               varchar(20) default null;

update analitf.params set ProviderMDBVersion = 95 where id = 0;