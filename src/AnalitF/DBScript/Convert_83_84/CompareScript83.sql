alter table analitf.clientsettings
  add column `CalculateWithNDSForOther` tinyint(1) not null default '1';

update
  analitf.clientsettings
set
  CalculateWithNDSForOther = 1;

update analitf.params set ProviderMDBVersion = 84 where id = 0;