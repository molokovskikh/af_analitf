        ��  ��                  �   <   ��
 C O M P A R E S C R I P T 8 9       0         alter table analitf.clients
  add column `ExcessAvgOrderTimes` int(10) not null default '5';

update analitf.params set ProviderMDBVersion = 90 where id = 0;