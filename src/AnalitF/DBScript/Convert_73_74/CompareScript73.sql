drop table if exists analitf.delayofpayments;

create table analitf.delayofpayments
(
    `FirmCode` bigint(20) not null      , 
    `DayOfWeek` enum ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') not null,
    `VitallyImportantDelay` decimal(18,2) default null,
    `OtherDelay` decimal(18,2) default null,
    key `IDX_DelayOfPayments_FirmCode` (`FirmCode`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

alter table analitf.documentbodies
   add column `Amount` decimal(18,4) unsigned DEFAULT NULL,
   add column `NdsAmount` decimal(18,4) unsigned DEFAULT NULL;

update analitf.params set ProviderMDBVersion = 74 where id = 0;