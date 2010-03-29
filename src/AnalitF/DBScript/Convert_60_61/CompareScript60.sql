CREATE TABLE analitf.`clientsettings` (
  `ClientId`         bigint(20) not null,
  `OnlyLeaders`      tinyint(1) not null,
  `Address`          varchar(255) default null,
  `Director`         varchar(255) default null,
  `DeputyDirector`   varchar(255) default null,
  `Accountant`       varchar(255) default null,
  `MethodOfTaxation` smallint(5) not null default '0',
  `CalculateWithNDS` tinyint(1) not null default '1',
  primary key (`CLIENTID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

insert into analitf.`clientsettings`
  (ClientId, OnlyLeaders, Address, Director, DeputyDirector, Accountant, MethodOfTaxation)
select 
  ClientId, OnlyLeaders, Address, Director, DeputyDirector, Accountant, MethodOfTaxation
from
  analitf.`clients`;

alter table analitf.`clients`
  drop column `OnlyLeaders`,
  drop column `Address`,
  drop column `Director`,
  drop column `DeputyDirector`,
  drop column `Accountant`,
  drop column `MethodOfTaxation`;

update analitf.params set ProviderMDBVersion = 61 where id = 0;