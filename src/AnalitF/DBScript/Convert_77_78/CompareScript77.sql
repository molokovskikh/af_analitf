alter table analitf.documentbodies
  add column Unit varchar(20) default null,
  add column ExciseTax decimal(12,6) default null,
  add column BillOfEntryNumber varchar(30) default null,
  add column EAN13 varchar(13) default null;

create table analitf.invoiceheaders
(
  Id bigint(20) unsigned not null default '0',
  InvoiceNumber varchar(20) default null,
  InvoiceDate datetime default null,
  SellerName varchar(255) default null,
  SellerAddress varchar(255) default null,
  SellerINN varchar(20) default null,
  SellerKPP varchar(20) default null,
  ShipperInfo varchar(255) default null,
  ConsigneeInfo varchar(255) default null,
  PaymentDocumentInfo varchar(255) default null,
  BuyerName varchar(255) default null,
  BuyerAddress varchar(255) default null,
  BuyerINN varchar(20) default null,
  BuyerKPP varchar(20) default null,

  AmountWithoutNDS0 decimal(12,6) default null,

  AmountWithoutNDS10 decimal(12,6) default null,
  NDSAmount10 decimal(12,6) default null,
  Amount10 decimal(12,6) default null,

  AmountWithoutNDS18 decimal(12,6) default null,
  NDSAmount18 decimal(12,6) default null,
  Amount18 decimal(12,6) default null,

  AmountWithoutNDS decimal(12,6) default null,
  NDSAmount decimal(12,6) default null,
  Amount decimal(12,6) default null,

  primary key (Id)
)  ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update analitf.params set ProviderMDBVersion = 78 where id = 0;