drop table if exists analitf.delayofpayments;

create table analitf.delayofpayments
(
    `FirmCode` bigint(20) not null      , 
    `DayOfWeek` enum ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') not null,
    `VitallyImportantDelay` decimal(18,2) default null,
    `OtherDelay` decimal(18,2) default null,
    key `IDX_DelayOfPayments_FirmCode` (`FirmCode`),
    key `IDX_DelayOfPayments_Week` (`FirmCode`, `DayOfWeek`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

alter table analitf.documentbodies
   add column `Amount` decimal(18,4) unsigned DEFAULT NULL,
   add column `NdsAmount` decimal(18,4) unsigned DEFAULT NULL;

alter table analitf.postedorderheads
  add column `VitallyDelayOfPayment` decimal(5,3) default null;

alter table analitf.currentorderheads
  add column `VitallyDelayOfPayment` decimal(5,3) default null;

update analitf.params set ProviderMDBVersion = 75 where id = 0;