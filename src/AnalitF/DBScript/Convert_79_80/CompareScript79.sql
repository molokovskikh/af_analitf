alter table analitf.currentorderlists
  add column `Comment` varchar(255) default null;

alter table analitf.postedorderlists
  add column `Comment` varchar(255) default null;

create table analitf.useractionlogs
(
  `Id` bigint(20) not null AUTO_INCREMENT,
  `LogTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UserActionId` bigint(20) NOT NULL,
  `Context` varchar(255) DEFAULT NULL,
  primary key (`Id`),
  KEY (`LogTime`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

create table analitf.schedules
(
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Hour` int NOT NULL DEFAULT '0',
  `Minute` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update analitf.params set ProviderMDBVersion = 80 where id = 0;