        ��  ��                  x  <   ��
 C O M P A R E S C R I P T 9 8       0         alter table analitf.core
  add column `Exp` date default null after `Series`;

update analitf.core
set
  Exp = Period
where
  Period is not null and Period <> '';

alter table analitf.postedorderlists
  add column `Exp` date default null after `Series`;

update analitf.postedorderlists
set
  Exp = Period
where
  Period is not null and Period <> '';

alter table analitf.currentorderlists
  add column `Exp` date default null after `Series`;

update analitf.currentorderlists
set
  Exp = Period
where
  Period is not null and Period <> '';

update analitf.params set ProviderMDBVersion = 99 where id = 0;