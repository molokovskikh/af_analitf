create table analitf.certificaterequests
(
  `DocumentBodyId` bigint(20) not null,  
  `CertificateId` bigint(20) default null
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


create table analitf.certificates
(
  Id bigint(20) NOT NULL,
  CatalogId bigint(20) NOT NULL,
  SerialNumber VARCHAR(50) NOT NULL,
  PRIMARY KEY (Id),
  key IDX_Certificate (CatalogId, SerialNumber)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

create table analitf.certificatefiles
(
  Id bigint(20) NOT NULL,
  CertificateId bigint(20) NOT NULL,
  OriginFilename VARCHAR(255) NOT NULL,
  SupplierId bigint(20) NOT NULL,
  PRIMARY KEY (Id),
  key IDX_CertificateId (CertificateId),
  key IDX_SupplierId (SupplierId)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;


alter table analitf.client
  add column `ShowCertificatesWithoutRefSupplier` tinyint(1) not null default '0';

alter table analitf.DocumentBodies
  add column `RequestCertificate` tinyint(1) not null default '0',
  add column `ProductId` bigint(20) default null,
  add column `ProducerId` bigint(20) default null,
  add column `CertificateId` bigint(20) default null;

update analitf.params set ProviderMDBVersion = 82 where id = 0;