alter table analitf.batchreport
  modify column `Id` bigint(20) not null AUTO_INCREMENT;

update analitf.params set ProviderMDBVersion = 86 where id = 0;