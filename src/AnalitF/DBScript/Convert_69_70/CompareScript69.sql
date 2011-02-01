alter table analitf.ProviderSettings
  add column `OrderFolder` varchar(255) default null;

alter table analitf.clients
   add column `SelfAddressId` varchar(200) default null;

alter table analitf.minprices
   add column `NextCost` decimal(18,2) default null, 
   add column `MinCostCount` int default '0';

create table analitf.networklog(
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, 
  `LogTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  `Source` smallint(5) not null default 0, 
  `MessageType` smallint(5) not null default 0, 
  `Info` text default null, 
  primary key (`Id`), 
  key (`LogTime`) 
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update analitf.params set ProviderMDBVersion = 70 where id = 0;