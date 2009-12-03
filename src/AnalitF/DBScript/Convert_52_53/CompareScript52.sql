DROP PROCEDURE IF EXISTS analitf.CATALOGSHOWBYFORM;

DROP PROCEDURE IF EXISTS analitf.CATALOGSHOWBYNAME;

DROP PROCEDURE IF EXISTS analitf.DeleteOrder;

DROP PROCEDURE IF EXISTS analitf.UPDATEORDERCOUNT;

DROP PROCEDURE IF EXISTS analitf.UPDATEUPCOST;

DROP FUNCTION IF EXISTS analitf.x_cast_to_int10;

DROP FUNCTION IF EXISTS analitf.x_cast_to_tinyint;

alter table analitf.clients 
  add column `AllowDelayOfPayment` tinyint(1) NOT NULL after CALCULATELEADER;

DROP TABLE IF EXISTS analitf.delayofpayments;

CREATE TABLE analitf.`delayofpayments` (
  `FirmCode` bigint(20) NOT NULL,
  `Percent` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`FirmCode`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

alter table analitf.orderslist 
  add column `RealPrice` decimal(18,2) DEFAULT NULL;

DROP VIEW IF EXISTS analitf.clientavg;

DROP VIEW IF EXISTS analitf.pricesshow;


update analitf.params set ProviderMDBVersion = 53 where id = 0;