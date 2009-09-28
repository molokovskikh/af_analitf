CREATE TABLE analitf.`userinfo` (
  `ClientId` bigint(20) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `Addition` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

update analitf.params set ProviderMDBVersion = 51 where id = 0;