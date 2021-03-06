        ��  ��                  9  <   ��
 C O M P A R E S C R I P T 8 0       0         create table analitf.certificaterequests
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
  OriginFilename VARCHAR(255) NOT NULL,
  ExternalFileId VARCHAR(255) NOT NULL,
  CertificateSourceId bigint(20) NOT NULL,
  Extension VARCHAR(255) NOT NULL,
  PRIMARY KEY (Id),
  key IDX_CertificateSourceId (CertificateSourceId)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

create table analitf.filecertificates
(
  CertificateId bigint(20) NOT NULL,
  CertificateFileId bigint(20) NOT NULL,
  KEY (CertificateId),
  KEY (CertificateFileId)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

create table analitf.certificatesources
(
  Id bigint(20) NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

create table analitf.sourcesuppliers
(
  CertificateSourceId bigint(20) NOT NULL,
  SupplierId bigint(20) NOT NULL,
  KEY (CertificateSourceId),
  KEY (SupplierId)
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

alter table analitf.client
  add column `ShowCertificatesWithoutRefSupplier` tinyint(1) not null default '0';

alter table analitf.providers
  add column `CertificateSourceExists`  tinyint(1) not null default '0';

alter table analitf.providersettings
  add column `WaybillUnloadingFolder` varchar(255) default null;

alter table analitf.DocumentBodies
  add column `RequestCertificate` tinyint(1) not null default '0',
  add column `ProductId` bigint(20) default null,
  add column `ProducerId` bigint(20) default null,
  add column `CertificateId` bigint(20) default null;

update analitf.params set ProviderMDBVersion = 82 where id = 0;   