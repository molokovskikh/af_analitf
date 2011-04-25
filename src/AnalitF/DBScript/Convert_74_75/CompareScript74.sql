alter table analitf.delayofpayments
  add key `IDX_DelayOfPayments_Week` (`FirmCode`, `DayOfWeek`);

alter table analitf.postedorderheads
  add column `VitallyDelayOfPayment` decimal(5,3) default null;

alter table analitf.currentorderheads
  add column `VitallyDelayOfPayment` decimal(5,3) default null;

update analitf.params set ProviderMDBVersion = 75 where id = 0;