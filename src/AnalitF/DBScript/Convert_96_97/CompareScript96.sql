alter table analitf.documentbodies
  add column `LastRejectStatusTime` datetime default null;

update analitf.params set ProviderMDBVersion = 97 where id = 0;