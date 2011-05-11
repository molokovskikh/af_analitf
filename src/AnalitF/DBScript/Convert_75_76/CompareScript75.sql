alter table analitf.currentorderlists
  add column `RetailVitallyImportant` tinyint(1) not null default '0';

alter table analitf.postedorderlists
  add column `RetailVitallyImportant` tinyint(1) not null default '0';

alter table analitf.core
  add column `RetailVitallyImportant` tinyint(1) not null default '0' after `NDS`;

drop table if exists analitf.delayofpayments;

create table analitf.delayofpayments
(
    `PriceCode` bigint(20) not null, 
    `DayOfWeek` enum ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') not null,
    `VitallyImportantDelay` decimal(18,2) default null,
    `OtherDelay` decimal(18,2) default null,
    key `IDX_DelayOfPayments_PriceCode` (`PriceCode`),
    key `IDX_DelayOfPayments_Week` (`PriceCode`, `DayOfWeek`)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update analitf.params set ProviderMDBVersion = 76 where id = 0;