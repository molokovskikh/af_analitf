unit GeneralDatabaseObjects;

interface

uses
  SysUtils, Classes, Contnrs, StrUtils,
  DatabaseObjects;

type
  TUserInfoTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TClientTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TClientsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TDefectivesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TProvidersTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TRegionsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TRegionalDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TPricesDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TPricesRegionalDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TDelayOfPaymentsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TCatalogNamesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TCatalogFarmGroupsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TCatalogsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TProductsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TCoreTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TMinPricesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TMNNTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TDescriptionsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TMaxProducerCostsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TProducersTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TMinReqRulesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TSupplierPromotionsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TPromotionCatalogsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

implementation

{ TUserInfoTable }

constructor TUserInfoTable.Create;
begin
  FName := 'userinfo';
  FObjectId := doiUserInfo;
  FRepairType := dortCumulative;
end;

function TUserInfoTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `ClientId` bigint(20) not null                 , ' 
+'    `UserId` bigint(20) not null                   , ' 
+'    `Addition`       varchar(50) default null       , ' 
+'    `InheritPrices`  tinyint(1) not null default ''0'', '
+'    `IsFutureClient` tinyint(1) not null default ''0'', '
+'    `UseCorrectOrders` tinyint(1) not null default ''0''  '
+'  ) '
+ GetTableOptions();
end;

{ TClientTable }

constructor TClientTable.Create;
begin
  FName := 'client';
  FObjectId := doiClient;
  FRepairType := dortCumulative;
end;

function TClientTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `Id` bigint(20) not null   , '
+'    `Name` varchar(50) not null, '
+'    `CalculateOnProducerCost` tinyint(1) unsigned NOT NULL DEFAULT ''0'', '
+'    `ParseWaybills` tinyint(1) unsigned not null default ''0'', '
+'    `SendRetailMarkup` tinyint(1) unsigned not null default ''0'', '
+'    `ShowAdvertising` tinyint(1) unsigned not null default ''1'', '
+'    `SendWaybillsFromClient` tinyint(1) unsigned not null default ''0'', '
+'    `EnableSmartOrder` tinyint(1) unsigned not null default ''0'', '
+'    `EnableImpersonalPrice` tinyint(1) unsigned not null default ''0'', '
+'    primary key (`Id`) '
+'  ) ' 
+ GetTableOptions();
end;

{ TClientsTable }

constructor TClientsTable.Create;
begin
  FName := 'clients';
  FObjectId := doiClients;
  FRepairType := dortCumulative;
end;

function TClientsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `CLIENTID` bigint(20) not null      , ' 
+'    `NAME` varchar(255) not null         , '
+'    `REGIONCODE` bigint(20) default null, '
+'    `EXCESS`    int(10) not null           , '
+'    `DELTAMODE` smallint(5) default null   , '
+'    `MAXUSERS`  int(10) not null           , '
+'    `REQMASK` bigint(20) default null      , '
+'    `CALCULATELEADER`     tinyint(1) not null  , '
+'    `AllowDelayOfPayment` tinyint(1) not null  , '
+'    `FullName` varchar(255) default null, '
+'    `SelfAddressId` varchar(200) default null, '
+'    primary key (`CLIENTID`)                   , '
+'    unique key `PK_CLIENTS` (`CLIENTID`)       , ' 
+'    key `FK_CLIENTS_REGIONCODE` (`REGIONCODE`) ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TDefectivesTable }

constructor TDefectivesTable.Create;
begin
  FName := 'defectives';
  FObjectId := doiDefectives;
  FRepairType := dortCumulative;
end;

function TDefectivesTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `ID` bigint(20) not null        , ' 
+'    `NAME`         varchar(250) default null, ' 
+'    `PRODUCER`     varchar(150) default null, ' 
+'    `COUNTRY`      varchar(150) default null, ' 
+'    `SERIES`       varchar(50) default null , ' 
+'    `LETTERNUMBER` varchar(50) default null , ' 
+'    `LETTERDATE` timestamp null default null, ' 
+'    `LABORATORY` varchar(200) default null  , ' 
+'    `REASON` text                           , ' 
+'    `CHECKPRINT` tinyint(1) not null        , ' 
+'    primary key (`ID`)                      , ' 
+'    unique key `PK_DEFECTIVES` (`ID`) ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TProvidersTable }

constructor TProvidersTable.Create;
begin
  FName := 'providers';
  FObjectId := doiProviders;
  FRepairType := dortCumulative;
end;

function TProvidersTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `FIRMCODE` bigint(20) not null         , ' 
+'    `FULLNAME`    varchar(40) default null , ' 
+'    `FAX`         varchar(20) default null , ' 
+'    `MANAGERMAIL` varchar(255) default null, ' 
+'    `ShortName`    varchar(50) default null , '
+'    primary key (`FIRMCODE`)               , '
+'    unique key `PK_CLIENTSDATAN` (`FIRMCODE`) ' 
+'  ) ' 
+ GetTableOptions();  
end;

{ TRegionsTable }

constructor TRegionsTable.Create;
begin
  FName := 'regions';
  FObjectId := doiRegions;
  FRepairType := dortCumulative;
end;

function TRegionsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+ '  ( ' 
+'    `REGIONCODE` bigint(20) not null      , ' 
+'    `REGIONNAME` varchar(25) default null , ' 
+'    `PRICERET`   varchar(254) default null, ' 
+'    primary key (`REGIONCODE`)            , ' 
+'    unique key `PK_REGIONS` (`REGIONCODE`), ' 
+'    unique key `IDX_REGIONS_REGIONNAME` (`REGIONNAME`) ' 
+'  ) ' 
+ GetTableOptions();  
end;

{ TRegionalDataTable }

constructor TRegionalDataTable.Create;
begin
  FName := 'regionaldata';
  FObjectId := doiRegionalData;
  FRepairType := dortCumulative;
end;

function TRegionalDataTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `FIRMCODE` bigint(20) not null default ''0''  , '
+'    `REGIONCODE` bigint(20) not null default ''0'', '
+'    `SUPPORTPHONE` varchar(20) default null     , '
+'    `CONTACTINFO` text                          , '
+'    `OPERATIVEINFO` text                        , '
+'    primary key (`FIRMCODE`,`REGIONCODE`)       , '
+'    key `FK_REGIONALDATA_FIRMCODE` (`FIRMCODE`) , '
+'    key `FK_REGIONALDATA_REGIONCODE` (`REGIONCODE`) '
+'  ) '
+ GetTableOptions();
end;

{ TPricesDataTable }

constructor TPricesDataTable.Create;
begin
  FName := 'pricesdata';
  FObjectId := doiPricesData;
  FRepairType := dortCumulative;
end;

function TPricesDataTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `FIRMCODE` bigint(20) not null          , ' 
+'    `PRICECODE` bigint(20) not null         , ' 
+'    `PRICENAME` varchar(70) default null    , ' 
+'    `PRICEINFO` text                        , ' 
+'    `DATEPRICE` datetime default null       , ' 
+'    `FRESH`     tinyint(1) not null         , ' 
+'    primary key (`PRICECODE`)               , ' 
+'    unique key `PK_PRICESDATA` (`PRICECODE`), ' 
+'    key `FK_PRICESDATA_FIRMCODE` (`FIRMCODE`) ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TPricesRegionalDataTable }

constructor TPricesRegionalDataTable.Create;
begin
  FName := 'pricesregionaldata';
  FObjectId := doiPricesRegionalData;
  FRepairType := dortCumulative;
end;

function TPricesRegionalDataTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `PRICECODE` bigint(20) not null default ''0'' , '
+'    `REGIONCODE` bigint(20) not null default ''0'', '
+'    `STORAGE`       tinyint(1) not null               , '
+'    `MINREQ`        int(10) default null              , '
+'    `ENABLED`       tinyint(1) not null               , '
+'    `INJOB`         tinyint(1) not null               , '
+'    `CONTROLMINREQ` tinyint(1) not null               , '
+'    `PRICESIZE`     int(10) default null              , '
+'    primary key (`PRICECODE`,`REGIONCODE`)            , '
+'    key `FK_PRD_REGIONCODE` (`REGIONCODE`)            , '
+'    key `FK_PRICESREGIONALDATA_PRICECODE` (`PRICECODE`) '
+'  ) '
+ GetTableOptions();
end;

{ TDelayOfPaymentsTable }

constructor TDelayOfPaymentsTable.Create;
begin
  FName := 'delayofpayments';
  FObjectId := doiDelayOfPayments;
  FRepairType := dortCumulative;
end;

function TDelayOfPaymentsTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `FirmCode` bigint(20) not null      , ' 
+'    `Percent` decimal(18,2) default null, ' 
+'    primary key (`FirmCode`) ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TCatalogNamesTable }

constructor TCatalogNamesTable.Create;
begin
  FNeedCompact := True;
  FName := 'catalognames';
  FObjectId := doiCatalogNames;
  FRepairType := dortCumulative;
end;

function TCatalogNamesTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `ID` bigint(20) not null        , ' 
+'    `NAME`      varchar(250) default null, ' 
+'    `LATINNAME` varchar(250) default null, ' 
+'    `DESCRIPTION` text                   , ' 
+'    primary key (`ID`)                   , ' 
+'    unique key `PK_CATALOGNAMES` (`ID`) ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TCatalogFarmGroupsTable }

constructor TCatalogFarmGroupsTable.Create;
begin
  FNeedCompact := True;
  FName := 'catalogfarmgroups';
  FObjectId := doiCatalogFarmGroups;
  FRepairType := dortCumulative;
end;

function TCatalogFarmGroupsTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `ID` bigint(20) not null                , '
+'    `NAME` varchar(250) default null        , '
+'    `DESCRIPTION` text                      , '
+'    `PARENTID` bigint(20) default null      , '
+'    `GROUPTYPE` int(10) default null        , '
+'    primary key (`ID`)                      , '
+'    unique key `PK_CATALOGFARMGROUPS` (`ID`), '
+'    key `FK_CATALOG_FARM_GROUPS_PARENT` (`PARENTID`) '
+'  ) '
+ GetTableOptions();
end;

{ TCatalogsTable }

constructor TCatalogsTable.Create;
begin
  FNeedCompact := True;
  FName := 'catalogs';
  FObjectId := doiCatalogs;
  FRepairType := dortCumulative;
end;

function TCatalogsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `FULLCODE` bigint(20) not null  , '
+'    `SHORTCODE` bigint(20) not null , '
+'    `NAME`             varchar(250) default null, '
+'    `FORM`             varchar(250) default null, '
+'    `VITALLYIMPORTANT` tinyint(1) not null      , '
+'    `NEEDCOLD`         tinyint(1) not null      , '
+'    `FRAGILE`          tinyint(1) not null      , '
+'    `MandatoryList`    tinyint(1) not null      , '
+'    `MnnId`            bigint(20) default null  , '
+'    `DescriptionId`    bigint(20) default null  , '
+'    `Hidden`           tinyint(1) not null      , '
+'    `COREEXISTS`       tinyint(1) not null      , '
+'    `PromotionsCount`  int not null default ''0'', '
+'    `NamePromotionsCount`  int not null default ''0'', '
+'    primary key (`FULLCODE`)                    , '
+'    unique key `PK_CATALOGS` (`FULLCODE`)       , '
+'    key `IDX_CATALOG_FORM` (`FORM`)             , '
+'    key `IDX_CATALOG_NAME` (`NAME`)             , '
+'    key `IDX_CATALOG_SHORTCODE` (`SHORTCODE`)   , '
+'    key `IDX_CATALOG_MnnID` (`MnnId`)           , '
+'    key `IDX_CATALOG_DescriptionId` (`DescriptionId`) '
+'  ) '
+ GetTableOptions();
end;

{ TProductsTable }

constructor TProductsTable.Create;
begin
  FNeedCompact := True;
  FName := 'products';
  FObjectId := doiProducts;
  FRepairType := dortCumulative;
end;

function TProductsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `PRODUCTID` bigint(20) not null       , ' 
+'    `CATALOGID` bigint(20) not null       , ' 
+'    primary key (`PRODUCTID`)             , ' 
+'    unique key `PK_PRODUCTS` (`PRODUCTID`), ' 
+'    key `FK_PRODUCTS_CATALOGID` (`CATALOGID`) ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TCoreTable }

constructor TCoreTable.Create;
begin
  FNeedCompact := True;
  FName := 'core';
  FObjectId := doiCore;
  FRepairType := dortCumulative;
end;

function TCoreTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `PRICECODE` bigint(20) default null        , ' 
+'    `REGIONCODE` bigint(20) default null       , ' 
+'    `PRODUCTID` bigint(20) not null            , ' 
+'    `CODEFIRMCR` bigint(20) default null       , ' 
+'    `SYNONYMCODE` bigint(20) default null      , ' 
+'    `SYNONYMFIRMCRCODE` bigint(20) default null, ' 
+'    `CODE`             varchar(84) default null            , ' 
+'    `CODECR`           varchar(84) default null            , ' 
+'    `UNIT`             varchar(15) default null            , ' 
+'    `VOLUME`           varchar(15) default null            , ' 
+'    `JUNK`             tinyint(1) not null                 , ' 
+'    `AWAIT`            tinyint(1) not null                 , ' 
+'    `QUANTITY`         varchar(15) default null            , ' 
+'    `NOTE`             varchar(50) default null            , ' 
+'    `PERIOD`           varchar(20) default null            , ' 
+'    `DOC`              varchar(20) default null            , ' 
+'    `REGISTRYCOST`     decimal(8,2) default null           , ' 
+'    `VITALLYIMPORTANT` tinyint(1) not null                 , ' 
+'    `REQUESTRATIO`     int(10) default null                , ' 
+'    `Cost`             decimal(18,2) default null          , ' 
+'    `SERVERCOREID` bigint(20) default null                 , ' 
+'    `ORDERCOST`     decimal(18,2) default null                 , ' 
+'    `MINORDERCOUNT` int(10) default null                       , '
+'    `SupplierPriceMarkup` decimal(5,3) default null            , '
+'    `ProducerCost` decimal(18,2) default null                  , '
+'    `NDS` smallint(5) default null                             , '
+'    `BuyingMatrixType` smallint(5) default null                , '
+'    `CryptCost`    VARCHAR(32) default null                    , '
+'    `COREID` bigint(20) not null AUTO_INCREMENT                , '
+'    primary key (`COREID`)                                     , ' 
+'    unique key `PK_CORE` (`COREID`)                            , ' 
+'    key `FK_CORE_PRICECODE` (`PRICECODE`)                      , ' 
+'    key `FK_CORE_PRODUCTID` (`PRODUCTID`)                      , ' 
+'    key `FK_CORE_REGIONCODE` (`REGIONCODE`)                    , ' 
+'    key `FK_CORE_SYNONYMCODE` (`SYNONYMCODE`)                  , ' 
+'    key `FK_CORE_SYNONYMFIRMCRCODE` (`SYNONYMFIRMCRCODE`)      , ' 
+'    key `IDX_CORE_JUNK` (`PRODUCTID`,`JUNK`)                   , ' 
+'    key `IDX_CORE_SERVERCOREID` (`SERVERCOREID`) ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TMinPricesTable }

constructor TMinPricesTable.Create;
begin
  FName := 'minprices';
  FObjectId := doiMinPrices;
  FRepairType := dortCumulative;
end;

function TMinPricesTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `PRODUCTID` bigint(20) not null default ''0'' , '
+'    `REGIONCODE` bigint(20) not null default ''0'', '
+'    `SERVERCOREID` bigint(20) default null      , '
+'    `PriceCode` bigint(20) default null         , '
+'    `MinCost` decimal(18,2) default null        , '
+'    `NextCost` decimal(18,2) default null    , '
+'    `MinCostCount` int default ''0''            , '
+'    `Percent` decimal(18,2) default null    , '
+'    primary key (`PRODUCTID`,`REGIONCODE`)      , '
+'    key `FK_MINPRICES_PRODUCTID` (`PRODUCTID`)  , '
+'    key `FK_MINPRICES_REGIONCODE` (`REGIONCODE`), '
+'    key `IDX_MINPRICES_MinCost` (`MinCost`), '
+'    key `IDX_MINPRICES_NextCost` (`NextCost`), '
+'    key `IDX_MINPRICES_Percent` (`Percent`) '
+'  ) '
+ GetTableOptions();
end;

{ TMNNTable }

constructor TMNNTable.Create;
begin
  FNeedCompact := True;
  FName := 'mnn';
  FObjectId := doiMNN;
  FRepairType := dortCumulative;
end;

function TMNNTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `Id`               bigint(20) not null  , '
+'    `Mnn`              varchar(250) not null, '
+'    `Hidden`           tinyint(1) not null  , '
+'    primary key (`Id`)                      , '
+'    key `IDX_MNN_Mnn` (`Mnn`)                 '
+'  ) '
+ GetTableOptions();
end;

{ TDescriptionsTable }

constructor TDescriptionsTable.Create;
begin
  FNeedCompact := True;
  FName := 'Descriptions';
  FObjectId := doiDescriptions;
  FRepairType := dortCumulative;
end;

function TDescriptionsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'  `Id`               bigint(20) not null  , '
+'  `Name`             varchar(255) not null, '
+'  `EnglishName`  varchar(255) default null, '
+'  `Description`    TEXT DEFAULT NULL, '
+'  `Interaction`    TEXT DEFAULT NULL, '
+'  `SideEffect`    TEXT DEFAULT NULL, '
+'  `IndicationsForUse` TEXT DEFAULT NULL, '
+'  `Dosing` TEXT DEFAULT NULL, '
+'  `Warnings` TEXT DEFAULT NULL, '
+'  `ProductForm` TEXT DEFAULT NULL, '
+'  `PharmacologicalAction` TEXT DEFAULT NULL, '
+'  `Storage` TEXT DEFAULT NULL, '
+'  `Expiration` TEXT DEFAULT NULL, '
+'  `Composition` TEXT DEFAULT NULL, '
+'  `Hidden`           tinyint(1) not null, '
+'  PRIMARY KEY (`Id`)                      , '
+'  Key(`Name`)                             , '
+'  Key(`EnglishName`)                        '
+'  ) '
+ GetTableOptions();
end;

{ TMaxProducerCostsTable }

constructor TMaxProducerCostsTable.Create;
begin
  FName := 'maxproducercosts';
  FObjectId := doiMaxProducerCosts;
  FRepairType := dortCumulative;
end;

function TMaxProducerCostsTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'  `Id`          bigint(20) not null  , '
+'  `CatalogId`   bigint(20) not null  , '
+'  `ProductId`   bigint(20) not null  , '
+'  `Product`     varchar(255) not null, '
+'  `Producer`    varchar(255) not null, '
+'  `Cost`        varchar(50) default null, '
+'  `ProducerId`  bigint(20) default null  , '
+'  `RealCost`    decimal(12,6) default null  , '
+'  PRIMARY KEY (`Id`), '
+'  Key(`CatalogId`), '
+'  Key(`ProductId`), '
+'  Key(`Product`), '
+'  Key(`Producer`), '
+'  Key(`ProducerId`) '
+'  ) '
+ GetTableOptions();
end;

{ TProducersTable }

constructor TProducersTable.Create;
begin
  FNeedCompact := True;
  FName := 'producers';
  FObjectId := doiProducers;
  FRepairType := dortCumulative;
end;

function TProducersTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'  `Id`          bigint(20) not null  , '
+'  `Name`        varchar(255) not null, '
+'  `Hidden`      tinyint(1) not null, '
+'  PRIMARY KEY (`Id`), '
+'  Key(`Name`) '
+'  ) '
+ GetTableOptions();
end;

{ TMinReqRulesTable }

constructor TMinReqRulesTable.Create;
begin
  FName := 'minreqrules';
  FObjectId := doiMinReqRules;
  FRepairType := dortCumulative;
end;

function TMinReqRulesTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'  `ClientId`      bigint(20) not null, '
+'  `PriceCode`     bigint(20) not null, '
+'  `RegionCode`    bigint(20) not null, '
+'  `ControlMinReq` tinyint(1) not null, '
+'  `MinReq`        int(10) default null, '
+'  primary key (`ClientId`, `PriceCode`, `RegionCode`), '
+'  key `FK_minreqrules_ClientId` (`ClientId`), '
+'  key `FK_minreqrules_PriceCode` (`PriceCode`), '
+'  key `FK_minreqrules_RegionCode` (`RegionCode`) '
+'  ) '
+ GetTableOptions();
end;

{ TSupplierPromotionsTable }

constructor TSupplierPromotionsTable.Create;
begin
  FName := 'supplierpromotions';
  FObjectId := doiSupplierPromotions;
  FRepairType := dortCumulative;
end;

function TSupplierPromotionsTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'  `Id` bigint(20) NOT NULL, '
+'  `Status` tinyint(1) unsigned NOT NULL DEFAULT ''0'', '
+'  `SupplierId` bigint(20) NOT NULL, '
+'  `Name` varchar(255) NOT NULL, '
+'  `Annotation` TEXT NOT NULL, '
+'  `PromoFile` varchar(255) default NULL, '
+'  PRIMARY KEY (`Id`), '
+'  KEY `IDX_SupplierPromotions_SupplierId` (`SupplierId`) '
+'  ) '
+ GetTableOptions();
end;

{ TPromotionCatalogsTable }

constructor TPromotionCatalogsTable.Create;
begin
  FName := 'promotioncatalogs';
  FObjectId := doiPromotionCatalogs;
  FRepairType := dortCumulative;
end;

function TPromotionCatalogsTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'  `CatalogId` bigint(20)NOT NULL, '
+'  `PromotionId` bigint(20)NOT NULL, '
+'  `Hidden` tinyint(1) unsigned NOT NULL DEFAULT ''0'', '
+'  PRIMARY KEY (`CatalogId`, `PromotionId`), '
+'  KEY `IDX_PromotionCatalogs_CatalogId` (`CatalogId`), '
+'  KEY `IDX_PromotionCatalogs_PromotionId` (`PromotionId`) '
+'  ) '
+ GetTableOptions();
end;

initialization
  DatabaseController.AddObject(TUserInfoTable.Create());
  DatabaseController.AddObject(TClientTable.Create());
  DatabaseController.AddObject(TClientsTable.Create());
  DatabaseController.AddObject(TDefectivesTable.Create());

  DatabaseController.AddObject(TProvidersTable.Create());
  DatabaseController.AddObject(TRegionsTable.Create());
  DatabaseController.AddObject(TRegionalDataTable.Create());
  DatabaseController.AddObject(TPricesDataTable.Create());
  DatabaseController.AddObject(TPricesRegionalDataTable.Create());

  DatabaseController.AddObject(TDelayOfPaymentsTable.Create());
  DatabaseController.AddObject(TCatalogNamesTable.Create());
  DatabaseController.AddObject(TCatalogFarmGroupsTable.Create());
  DatabaseController.AddObject(TCatalogsTable.Create());

  DatabaseController.AddObject(TProductsTable.Create());
  DatabaseController.AddObject(TCoreTable.Create());
  DatabaseController.AddObject(TMinPricesTable.Create());

  DatabaseController.AddObject(TMNNTable.Create());
  DatabaseController.AddObject(TDescriptionsTable.Create());
  DatabaseController.AddObject(TMaxProducerCostsTable.Create());
  DatabaseController.AddObject(TProducersTable.Create());

  DatabaseController.AddObject(TMinReqRulesTable.Create());

  DatabaseController.AddObject(TSupplierPromotionsTable.Create());
  DatabaseController.AddObject(TPromotionCatalogsTable.Create());
end.

