create table analitf.mails
(
  `Id`                bigint(20) unsigned NOT NULL DEFAULT '0',
  `LogTime`           datetime NOT NULL,
  `SupplierId`        bigint(20) unsigned NOT NULL,
  `SupplierName`      varchar(255) NOT NULL,
  `IsVIPMail`         tinyint(1) not null default '0',
  `Subject`           varchar(255) default null,
  `Body`              TEXT DEFAULT NULL,
  `IsNewMail`         tinyint(1) not null default '1',
  `IsImportantMail`   tinyint(1) not null default '0',
  PRIMARY KEY (`Id`),
  KEY `IDX_Mails_LogTime` (`LogTime`),
  KEY `IDX_Mails_Subject` (`Subject`),
  KEY `IDX_Mails_SupplierId` (`SupplierId`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


create table analitf.attachments
(
  `Id`                  bigint(20) unsigned NOT NULL DEFAULT '0',
  `MailId`              bigint(20) unsigned NOT NULL,
  `FileName`            varchar(255) NOT NULL,
  `Extension`           varchar(255) NOT NULL,
  `Size`                bigint(20) unsigned NOT NULL,
  `RequestAttachment`   tinyint(1) not null default '0',
  `RecievedAttachment`  tinyint(1) not null default '0',
  PRIMARY KEY (`Id`),
  KEY `IDX_Attachments_MailId` (`MailId`) 
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


create table analitf.attachmentrequests
(
  `AttachmentId` bigint(20) not null
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


update analitf.params set ProviderMDBVersion = 83 where id = 0;