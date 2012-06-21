drop table if exists analitf.defectives;

create table analitf.rejects
(
    `ID` bigint(20) not null        ,
    `NAME`         varchar(250) default null,
    `ProductId` bigint(20) default null     ,
    `PRODUCER`     varchar(150) default null,
    `ProducerId`     bigint(20) default null,
    `SERIES`       varchar(50) default null ,
    `LETTERNUMBER` varchar(50) default null ,
    `LETTERDATE` timestamp null default null,
    `REASON` text                           ,
    `Hidden` tinyint(1) not null            ,
    `CHECKPRINT` tinyint(1) not null        ,
    primary key (`ID`)                       
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

alter table analitf.documentbodies
  add column `RejectId` bigint(20) default null,
  add column `VitallyImportantByUser` tinyint(1) unsigned default null;

alter table analitf.documentheaders
  add column `SupplierNameByUser` varchar(255) DEFAULT NULL;

create table analitf.news
(
    Id bigint(20) NOT NULL,
    PublicationDate datetime NOT NULL,
    Header varchar(255) default NULL,
    primary key (Id),
    key (PublicationDate)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

alter table analitf.client
  add column `HomeRegion` bigint(20) not null ,
  add column `TechContact` TEXT,
  add column `TechOperatingMode` TEXT;

alter table analitf.currentorderlists
  add ServerOrderListId bigint(20) default null;

alter table analitf.postedorderlists
  add ServerOrderListId bigint(20) default null;

create table analitf.waybillorders
(
  `ServerDocumentLineId` bigint(20) unsigned NOT NULL, 
  `ServerOrderListId`    bigint(20) unsigned NOT NULL, 
  KEY `IDX_waybillorders_ServerDocumentLineId` (`ServerDocumentLineId`),
  KEY `IDX_waybillorders_ServerOrderListId` (`ServerOrderListId`)
)ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update analitf.params set ProviderMDBVersion = 92 where id = 0;