
alter table analitf.documentbodies
  modify column `DocumentId` bigint(20) unsigned DEFAULT NULL,
  modify column `ServerId` bigint(20) unsigned DEFAULT NULL after `DocumentId`,
  add column `ServerDocumentId` bigint(20) unsigned DEFAULT NULL after `ServerId`;

update analitf.documentbodies
set  
  ServerDocumentId = DocumentId;

update analitf.params set ProviderMDBVersion = 88 where id = 0;