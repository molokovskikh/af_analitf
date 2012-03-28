alter table analitf.catalogs
  add column `Markup`     decimal(5,2) default NULL after `Hidden`, 
  add column `MaxMarkup` decimal(5,2) default NULL after `Markup`,
  add column `MaxSupplierMarkup` decimal(5,2) default NULL after `MaxMarkup`;


alter table analitf.documentheaders
  add column `ServerId` bigint(20) unsigned DEFAULT NULL after `Id`,
  add column `CreatedByUser` tinyint(1) not null default '0';

alter table analitf.documentbodies
  modify column `DocumentId` bigint(20) unsigned DEFAULT NULL,
  add column `ServerId` bigint(20) unsigned DEFAULT NULL after `DocumentId`,
  add column `ServerDocumentId` bigint(20) unsigned DEFAULT NULL after `ServerId`;

update analitf.documentheaders
set
  ServerId = Id;

update analitf.documentbodies
set
  ServerId = Id,
  ServerDocumentId = DocumentId;

update analitf.params set ProviderMDBVersion = 88 where id = 0;