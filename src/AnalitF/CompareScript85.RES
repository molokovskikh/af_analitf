        ��  ��                  �   <   ��
 C O M P A R E S C R I P T 8 5       0         alter table analitf.batchreport
  modify column `Id` bigint(20) not null AUTO_INCREMENT;

update analitf.params set ProviderMDBVersion = 86 where id = 0;