        ��  ��                  �   <   ��
 C O M P A R E S C R I P T 9 5       0         alter table analitf.regionaldata
  add column `Address` varchar(255) default null;

update analitf.params set ProviderMDBVersion = 96 where id = 0;  