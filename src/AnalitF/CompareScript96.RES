        ��  ��                  �   <   ��
 C O M P A R E S C R I P T 9 6       0         alter table analitf.documentbodies
  add column `LastRejectStatusTime` datetime default null;

update analitf.params set ProviderMDBVersion = 97 where id = 0;   