alter table analitf.Params
  add column  `StoredUserId`           varchar(255) default null;

alter table analitf.currentorderlists
  add column  `RetailCost`      decimal(18,2) default null;

alter table analitf.postedorderlists
  add column  `RetailCost`      decimal(18,2) default null;

alter table analitf.client
  add column `EnableImpersonalPrice` tinyint(1) unsigned not null default '0';

alter table analitf.userinfo
  add column `UseCorrectOrders` tinyint(1) not null default '0';

create table IF NOT EXISTS analitf.globalparams(
  `Name` varchar(255) not null,
  `Value` varchar(255) default null,
  primary key (`Name`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update
  analitf.params,
  analitf.userinfo
set
  params.StoredUserId =  userinfo.UserId
where
  params.id = 0;

update analitf.params set ProviderMDBVersion = 71 where id = 0;