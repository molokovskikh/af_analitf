CREATE TABLE analitf.client (
  `Id` bigint(20) NOT NULL,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

alter table analitf.params
  add column `ConfirmSendingOrders` tinyint(1) NOT NULL DEFAULT '0',
  add column `UseCorrectOrders` tinyint(1) NOT NULL DEFAULT '0';

alter table analitf.userinfo
  add column `IsFutureClient` tinyint(1) NOT NULL DEFAULT '0';

alter table analitf.ordershead
  add column `SendResult` smallint(5) DEFAULT NULL,
  add column `ErrorReason` varchar(250) DEFAULT NULL,
  add column `ServerMinReq` int(10) DEFAULT NULL;

alter table analitf.orderslist
  add column `DropReason` smallint(5) DEFAULT NULL,
  add column `ServerCost` decimal(18,2) DEFAULT NULL,
  add column `ServerQuantity` int(10) DEFAULT NULL;

update analitf.params set ProviderMDBVersion = 54 where id = 0;