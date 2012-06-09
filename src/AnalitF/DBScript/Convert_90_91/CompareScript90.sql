alter table analitf.providers
  add column `SupplierCategory`  int(10) not null default '0',
  add column `MainFirm`  tinyint(1) not null default '0';

INSERT IGNORE INTO analitf.GlobalParams (Name, Value) VALUES ("BaseFirmCategory", "0");

INSERT IGNORE INTO analitf.GlobalParams (Name, Value) VALUES ("Excess", "5");

INSERT IGNORE INTO analitf.GlobalParams (Name, Value) VALUES ("ExcessAvgOrderTimes", "5");

INSERT IGNORE INTO analitf.GlobalParams (Name, Value) VALUES ("DeltaMode", "1");

INSERT IGNORE INTO analitf.GlobalParams (Name, Value) VALUES ("ShowPriceName", "0");

update analitf.params set ProviderMDBVersion = 91 where id = 0;