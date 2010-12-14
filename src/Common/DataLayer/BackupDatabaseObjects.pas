unit BackupDatabaseObjects;

interface

uses
  SysUtils, Classes, Contnrs, StrUtils,
  DatabaseObjects;

type
  TRetailMarginsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetInsertSQL(DatabasePrefix : String = '') : String; override;
  end;

  TPostedOrderHeadsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TPostedOrderListsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TReceivedDocsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TDocumentHeadersTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;
  
  TDocumentBodiesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TVitallyImportantMarkupsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TProviderSettingsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TClientSettingsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TCurrentOrderHeadsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TCurrentOrderListsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TGlobalParamsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

implementation

{ TRetailMarginsTable }

constructor TRetailMarginsTable.Create;
begin
  FName := 'retailmargins';
  FObjectId := doiRetailMargins;
  FRepairType := dortBackup;
end;

function TRetailMarginsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `ID` bigint(20) not null AUTO_INCREMENT, ' 
+'    `LEFTLIMIT`  decimal(18,2) not null     , '
+'    `RIGHTLIMIT` decimal(18,2) not null     , ' 
+'    `Markup`     decimal(5,2) not null           , '
+'    `MaxMarkup` decimal(5,2) NOT NULL, '
+'    `MaxSupplierMarkup` decimal(5,2) default NULL, '
+'    primary key (`ID`)                      , '
+'    unique key `PK_RETAILMARGINS` (`ID`) '
+'  ) '
+ GetTableOptions();
end;

function TRetailMarginsTable.GetInsertSQL(DatabasePrefix: String): String;
begin
  Result := ''
  + 'INSERT INTO '
  + IfThen(Length(DatabasePrefix) > 0, DatabasePrefix + '.')
  + FName
  +'(ID, LEFTLIMIT, RIGHTLIMIT, Markup, MaxMarkup, MaxSupplierMarkup) VALUES (1, 0, 1000000, 30, 30, null);';
end;

{ TPostedOrderHeadsTable }

constructor TPostedOrderHeadsTable.Create;
begin
  FName := 'postedorderheads';
  FObjectId := doiPostedOrderHeads;
  FRepairType := dortBackup;
end;

function TPostedOrderHeadsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `ORDERID` bigint(20) not null AUTO_INCREMENT, '
+'    `SERVERORDERID` bigint(20) default null     , '
+'    `CLIENTID` bigint(20) not null              , '
+'    `PRICECODE` bigint(20) not null             , '
+'    `REGIONCODE` bigint(20) not null            , '
+'    `PRICENAME`  varchar(70) default null        , '
+'    `REGIONNAME` varchar(25) default null        , '
+'    `ORDERDATE` timestamp null default null      , '
+'    `SENDDATE` timestamp null default null       , '
+'    `CLOSED` tinyint(1) not null                 , '
+'    `SEND`   tinyint(1) not null default ''1''     , '
+'    `COMMENTS` text                              , '
+'    `MESSAGETO` text                             , '
+'    `SendResult`   smallint(5) default null        , '
+'    `ErrorReason`  varchar(250) default null       , '
+'    `ServerMinReq` int(10) default null            , '
+'    `DelayOfPayment` decimal(5,3) default null     , '
+'    `PriceDate` datetime null default null       , '
+'    primary key (`ORDERID`)                        , '
+'    unique key `PK_ORDERSH` (`ORDERID`)            , '
+'    key `FK_ORDERSH_CLIENTID` (`CLIENTID`)         , '
+'    key `IDX_ORDERSH_ORDERDATE` (`ORDERDATE`)      , '
+'    key `IDX_ORDERSH_PRICECODE` (`PRICECODE`)      , '
+'    key `IDX_ORDERSH_REGIONCODE` (`REGIONCODE`)    , '
+'    key `IDX_ORDERSH_SENDDATE` (`SENDDATE`) '
+'  ) '
+ GetTableOptions();
end;

{ TPostedOrderListsTable }

constructor TPostedOrderListsTable.Create;
begin
  FName := 'postedorderlists';
  FObjectId := doiPostedOrderLists;
  FRepairType := dortBackup;
end;

function TPostedOrderListsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `ID` bigint(20) not null AUTO_INCREMENT    , '
+'    `ORDERID` bigint(20) not null              , '
+'    `CLIENTID` bigint(20) not null             , '
+'    `COREID` bigint(20) default null           , '
+'    `PRODUCTID` bigint(20) not null            , '
+'    `CODEFIRMCR` bigint(20) default null       , '
+'    `SYNONYMCODE` bigint(20) default null      , '
+'    `SYNONYMFIRMCRCODE` bigint(20) default null, '
+'    `CODE`           varchar(84) default null            , '
+'    `CODECR`         varchar(84) default null            , '
+'    `SYNONYMNAME`    varchar(250) default null           , '
+'    `SYNONYMFIRM`    varchar(250) default null           , '
+'    `PRICE`          decimal(18,2) default null          , '
+'    `AWAIT`          tinyint(1) not null                 , '
+'    `JUNK`           tinyint(1) not null                 , '
+'    `ORDERCOUNT`     int(10) not null                    , '
+'    `REQUESTRATIO`   int(10) default null                , '
+'    `ORDERCOST`      decimal(18,2) default null          , '
+'    `MINORDERCOUNT`  int(10) default null                , '
+'    `RealPrice`      decimal(18,2) default null          , '
+'    `DropReason`     smallint(5) default null            , '
+'    `ServerCost`     decimal(18,2) default null          , '
+'    `ServerQuantity` int(10) default null                , '
+'    `SupplierPriceMarkup` decimal(5,3) default null      , '
+'    `CoreQuantity` varchar(15) DEFAULT NULL              , '
+'    `ServerCoreID` bigint(20) DEFAULT NULL               , '
+'    `Unit` varchar(15) DEFAULT NULL                      , '
+'    `Volume` varchar(15) DEFAULT NULL                    , '
+'    `Note` varchar(50) DEFAULT NULL                      , '
+'    `Period` varchar(20) DEFAULT NULL                    , '
+'    `Doc` varchar(20) DEFAULT NULL                       , '
+'    `RegistryCost` decimal(8,2) DEFAULT NULL             , '
+'    `VitallyImportant` tinyint(1) NOT NULL               , '
+'    `RetailMarkup` decimal(12,6) default null            , '
+'    `ProducerCost` decimal(18,2) default null            , '
+'    `NDS` smallint(5) default null                       , '
+'    primary key (`ID`)                                   , '
+'    unique key `PK_ORDERS` (`ID`)                        , '
+'    key `FK_ORDERS_CLIENTID` (`CLIENTID`)                , '
+'    key `FK_ORDERS_ORDERID` (`ORDERID`)                  , '
+'    key `IDX_ORDERS_CODEFIRMCR` (`CODEFIRMCR`)           , '
+'    key `IDX_ORDERS_COREID` (`COREID`)                   , '
+'    key `IDX_ORDERS_ORDERCOUNT` (`ORDERCOUNT`)           , '
+'    key `IDX_ORDERS_PRODUCTID` (`PRODUCTID`)             , '
+'    key `IDX_ORDERS_SYNONYMCODE` (`SYNONYMCODE`)         , '
+'    key `IDX_ORDERS_SYNONYMFIRMCRCODE` (`SYNONYMFIRMCRCODE`) '
+'  ) '
+ GetTableOptions();
end;

{ TReceivedDocsTable }

constructor TReceivedDocsTable.Create;
begin
  FName := 'receiveddocs';
  FObjectId := doiReceivedDocs;
  FRepairType := dortBackup;
end;

function TReceivedDocsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `ID` bigint(20) not null AUTO_INCREMENT, '
+'    `FILENAME` varchar(255) not null       , '
+'    `FILEDATETIME` timestamp not null default current_timestamp on '
+'  update current_timestamp, '
+'    primary key (`ID`)    , '
+'    unique key `PK_RECEIVEDDOCS` (`ID`) '
+'  ) '
+ GetTableOptions();
end;

{ TDocumentHeadersTable }

constructor TDocumentHeadersTable.Create;
begin
  FName := 'DocumentHeaders';
  FObjectId := doiDocumentHeaders;
  FRepairType := dortBackup;
end;

function TDocumentHeadersTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+' ( '
+'  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, '
+'  `DownloadId` bigint(20) unsigned DEFAULT NULL, '
+'  `WriteTime` datetime NOT NULL, '
+'  `FirmCode` bigint(20) unsigned DEFAULT NULL, '
+'  `ClientId` bigint(20) unsigned DEFAULT NULL, '
+'  `DocumentType` tinyint(3) unsigned DEFAULT NULL, '
+'  `ProviderDocumentId` varchar(20) DEFAULT NULL, '
+'  `OrderId` bigint(20) unsigned DEFAULT NULL, '
+'  `Header` varchar(255) DEFAULT NULL, '
+'  `LoadTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, '
+'  PRIMARY KEY (`Id`), '
+'  KEY (`LoadTime`), '
+'  KEY (`DownloadId`), '
+'  KEY (`ClientId`) '
+' ) '
+ GetTableOptions();
end;

{ TDocumentBodiesTable }

constructor TDocumentBodiesTable.Create;
begin
  FName := 'DocumentBodies';
  FObjectId := doiDocumentBodies;
  FRepairType := dortBackup;
end;

function TDocumentBodiesTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+' ( '
+'  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, '
+'  `DocumentId` bigint(20) unsigned NOT NULL, '
+'  `Product` varchar(255) not null, '
+'  `Code` varchar(20) default null, '
+'  `Certificates` varchar(50) default null, '
+'  `Period` varchar(20) default null, '
+'  `Producer` varchar(255) default null, '
+'  `Country` varchar(150) default null, '
+'  `ProducerCost` decimal(18,2) default null, '
+'  `RegistryCost` decimal(18,2) default null, '
+'  `SupplierPriceMarkup` decimal(5,2) default null, '
+'  `SupplierCostWithoutNDS` decimal(18,2) default null, '
+'  `SupplierCost` decimal(18,2) default null, '
+'  `Quantity` int(10) DEFAULT NULL, '
+'  `VitallyImportant` tinyint(1) unsigned default null, '
+'  `NDS` int(10) unsigned DEFAULT NULL, '
+'  `SerialNumber` varchar(50) default null, '
+'  `RetailMarkup` decimal(12,6) default null, '
+'  `ManualCorrection` tinyint(1) unsigned not null default ''0'', '
+'  `ManualRetailPrice` decimal(12,6) default null, '
+'  `Printed` tinyint(1) unsigned default 1, '
+'  PRIMARY KEY (`Id`) '
+' ) '
+ GetTableOptions();
end;

{ TVitallyImportantMarkupsTable }

constructor TVitallyImportantMarkupsTable.Create;
begin
  FName := 'VitallyImportantMarkups';
  FObjectId := doiVitallyImportantMarkups;
  FRepairType := dortBackup;
end;

function TVitallyImportantMarkupsTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+' ( '
+'  `ID` bigint(20) NOT NULL AUTO_INCREMENT, '
+'  `LeftLimit` decimal(18,2) NOT NULL, '
+'  `RightLimit` decimal(18,2) NOT NULL, '
+'  `Markup` decimal(5,2) NOT NULL, '
+'  `MaxMarkup` decimal(5,2) NOT NULL, '
+'  `MaxSupplierMarkup` decimal(5,2) default NULL, '
+'  PRIMARY KEY (`ID`), '
+'  UNIQUE KEY `PK_VitallyImportantMarkups` (`ID`) '
+' ) '
+ GetTableOptions();
end;

{ TProviderSettingsTable }

constructor TProviderSettingsTable.Create;
begin
  FName := 'ProviderSettings';
  FObjectId := doiProviderSettings;
  FRepairType := dortBackup;
end;

function TProviderSettingsTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+' ( '
+'  `FirmCode` bigint(20) NOT NULL, '
+'  `WaybillFolder` varchar(255) default null, '
+'  PRIMARY KEY (`FirmCode`), '
+'  UNIQUE KEY `PK_ProviderSettings` (`FirmCode`) '
+' ) '
+ GetTableOptions();
end;

{ TClientSettingsTable }

constructor TClientSettingsTable.Create;
begin
  FName := 'clientsettings';
  FObjectId := doiClientSettings;
  FRepairType := dortBackup;
end;

function TClientSettingsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+' ( '
+'    `ClientId`         bigint(20) not null, '
+'    `OnlyLeaders`      tinyint(1) not null, '
+'    `Address`          varchar(255) default null, '
+'    `Director`         varchar(255) default null, '
+'    `DeputyDirector`   varchar(255) default null, '
+'    `Accountant`       varchar(255) default null, '
+'    `MethodOfTaxation` smallint(5) not null default ''0'', '
+'    `CalculateWithNDS` tinyint(1) not null default ''1'', '
+'    `Name` varchar(255) default null, '
+'    primary key (`CLIENTID`) '
+' ) '
+ GetTableOptions();
end;

{ TCurrentOrderHeadsTable }

constructor TCurrentOrderHeadsTable.Create;
begin
  FName := 'currentorderheads';
  FObjectId := doiCurrentOrderHeads;
  FRepairType := dortBackup;
end;

function TCurrentOrderHeadsTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `ORDERID` bigint(20) not null AUTO_INCREMENT, '
+'    `SERVERORDERID` bigint(20) default null     , '
+'    `CLIENTID` bigint(20) not null              , '
+'    `PRICECODE` bigint(20) not null             , '
+'    `REGIONCODE` bigint(20) not null            , '
+'    `PRICENAME`  varchar(70) default null        , '
+'    `REGIONNAME` varchar(25) default null        , '
+'    `ORDERDATE` timestamp null default null      , '
+'    `SENDDATE` timestamp null default null       , '
+'    `CLOSED` tinyint(1) not null                 , '
+'    `SEND`   tinyint(1) not null default ''1''     , '
+'    `COMMENTS` text                              , '
+'    `MESSAGETO` text                             , '
+'    `SendResult`   smallint(5) default null        , '
+'    `ErrorReason`  varchar(250) default null       , '
+'    `ServerMinReq` int(10) default null            , '
+'    `DelayOfPayment` decimal(5,3) default null     , '
+'    `Frozen` tinyint(1) not null default ''0''     , '
+'    primary key (`ORDERID`)                        , '
+'    unique key `PK_ORDERSH` (`ORDERID`)            , '
+'    key `FK_ORDERSH_CLIENTID` (`CLIENTID`)         , '
+'    key `IDX_ORDERSH_ORDERDATE` (`ORDERDATE`)      , '
+'    key `IDX_ORDERSH_PRICECODE` (`PRICECODE`)      , '
+'    key `IDX_ORDERSH_REGIONCODE` (`REGIONCODE`)    , '
+'    key `IDX_ORDERSH_SENDDATE` (`SENDDATE`) '
+'  ) '
+ GetTableOptions();
end;

{ TCurrentOrderListsTable }

constructor TCurrentOrderListsTable.Create;
begin
  FName := 'currentorderlists';
  FObjectId := doiCurrentOrderLists;
  FRepairType := dortBackup;
end;

function TCurrentOrderListsTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `ID` bigint(20) not null AUTO_INCREMENT    , '
+'    `ORDERID` bigint(20) not null              , '
+'    `CLIENTID` bigint(20) not null             , '
+'    `COREID` bigint(20) default null           , '
+'    `PRODUCTID` bigint(20) not null            , '
+'    `CODEFIRMCR` bigint(20) default null       , '
+'    `SYNONYMCODE` bigint(20) default null      , '
+'    `SYNONYMFIRMCRCODE` bigint(20) default null, '
+'    `CODE`           varchar(84) default null            , '
+'    `CODECR`         varchar(84) default null            , '
+'    `SYNONYMNAME`    varchar(250) default null           , '
+'    `SYNONYMFIRM`    varchar(250) default null           , '
+'    `PRICE`          decimal(18,2) default null          , '
+'    `AWAIT`          tinyint(1) not null                 , '
+'    `JUNK`           tinyint(1) not null                 , '
+'    `ORDERCOUNT`     int(10) not null                    , '
+'    `REQUESTRATIO`   int(10) default null                , '
+'    `ORDERCOST`      decimal(18,2) default null          , '
+'    `MINORDERCOUNT`  int(10) default null                , '
+'    `RealPrice`      decimal(18,2) default null          , '
+'    `DropReason`     smallint(5) default null            , '
+'    `ServerCost`     decimal(18,2) default null          , '
+'    `ServerQuantity` int(10) default null                , '
+'    `SupplierPriceMarkup` decimal(5,3) default null      , '
+'    `CoreQuantity` varchar(15) DEFAULT NULL              , '
+'    `ServerCoreID` bigint(20) DEFAULT NULL               , '
+'    `Unit` varchar(15) DEFAULT NULL                      , '
+'    `Volume` varchar(15) DEFAULT NULL                    , '
+'    `Note` varchar(50) DEFAULT NULL                      , '
+'    `Period` varchar(20) DEFAULT NULL                    , '
+'    `Doc` varchar(20) DEFAULT NULL                       , '
+'    `RegistryCost` decimal(8,2) DEFAULT NULL             , '
+'    `VitallyImportant` tinyint(1) NOT NULL               , '
+'    `RetailMarkup` decimal(12,6) default null            , '
+'    `ProducerCost` decimal(18,2) default null            , '
+'    `NDS` smallint(5) default null                       , '
+'    `CryptPrice`    VARCHAR(32) default null             , '
+'    `CryptRealPrice`    VARCHAR(32) default null         , '
+'    primary key (`ID`)                                   , '
+'    unique key `PK_ORDERS` (`ID`)                        , '
+'    key `FK_ORDERS_CLIENTID` (`CLIENTID`)                , '
+'    key `FK_ORDERS_ORDERID` (`ORDERID`)                  , '
+'    key `IDX_ORDERS_CODEFIRMCR` (`CODEFIRMCR`)           , '
+'    key `IDX_ORDERS_COREID` (`COREID`)                   , '
+'    key `IDX_ORDERS_ORDERCOUNT` (`ORDERCOUNT`)           , '
+'    key `IDX_ORDERS_PRODUCTID` (`PRODUCTID`)             , '
+'    key `IDX_ORDERS_SYNONYMCODE` (`SYNONYMCODE`)         , '
+'    key `IDX_ORDERS_SYNONYMFIRMCRCODE` (`SYNONYMFIRMCRCODE`) '
+'  ) '
+ GetTableOptions();
end;

{ TGlobalParamsTable }

constructor TGlobalParamsTable.Create;
begin
  FName := 'globalparams';
  FObjectId := doiGlobalParams;
  FRepairType := dortBackup;
end;

function TGlobalParamsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `Name` varchar(255) not null, '
+'    `Value` varchar(255) default null, '
+'    primary key (`Name`) '
+'  ) '
+ GetTableOptions();
end;

initialization
  DatabaseController.AddObject(TRetailMarginsTable.Create());
  DatabaseController.AddObject(TPostedOrderHeadsTable.Create());
  DatabaseController.AddObject(TPostedOrderListsTable.Create());
  DatabaseController.AddObject(TReceivedDocsTable.Create());
  DatabaseController.AddObject(TDocumentHeadersTable.Create());
  DatabaseController.AddObject(TDocumentBodiesTable.Create());
  DatabaseController.AddObject(TVitallyImportantMarkupsTable.Create());
  DatabaseController.AddObject(TProviderSettingsTable.Create());
  DatabaseController.AddObject(TClientSettingsTable.Create());
  DatabaseController.AddObject(TCurrentOrderHeadsTable.Create());
  DatabaseController.AddObject(TCurrentOrderListsTable.Create());
  DatabaseController.AddObject(TGlobalParamsTable.Create());
end.
