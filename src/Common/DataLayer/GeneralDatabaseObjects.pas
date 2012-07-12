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
    function GetColumns() : String; override;
  end;

  TClientTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TClientsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TRejectsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TProvidersTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TRegionsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TRegionalDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TPricesDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TPricesRegionalDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TDelayOfPaymentsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TCatalogNamesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TCatalogFarmGroupsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TCatalogsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TProductsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TCoreTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TMinPricesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TMNNTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TDescriptionsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TMaxProducerCostsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TProducersTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TMinReqRulesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TSupplierPromotionsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TPromotionCatalogsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TSchedulesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TCertificatesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TCertificateFilesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TCertificateSourcesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TSourceSuppliersTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TFileCertificatesTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TNewsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

implementation

{ TUserInfoTable }

constructor TUserInfoTable.Create;
begin
  FName := 'userinfo';
  FObjectId := doiUserInfo;
  FRepairType := dortCumulative;
end;

function TUserInfoTable.GetColumns: String;
begin
  Result := ''
+'    `ClientId` , '
+'    `UserId` , '
+'    `Addition` , '
+'    `InheritPrices` , '
+'    `IsFutureClient` , '
+'    `UseCorrectOrders` ,  '
+'    `ShowSupplierCost`   ';
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
+'    `UseCorrectOrders` tinyint(1) not null default ''0'',  '
+'    `ShowSupplierCost` tinyint(1) not null default ''1''  '
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

function TClientTable.GetColumns: String;
begin
  Result := ''
+'    `Id` , '
+'    `Name` , '
+'    `CalculateOnProducerCost` , '
+'    `ParseWaybills` , '
+'    `SendRetailMarkup` , '
+'    `ShowAdvertising` , '
+'    `SendWaybillsFromClient` , '
+'    `EnableSmartOrder` , '
+'    `EnableImpersonalPrice` , '
+'    `AllowDelayOfPayment` ,  '
+'    `ShowCertificatesWithoutRefSupplier` ,  '
+'    `HomeRegion` ,  '
+'    `TechContact` ,  '
+'    `TechOperatingMode`  ';
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
+'    `AllowDelayOfPayment` tinyint(1) not null default ''0'',  '
+'    `ShowCertificatesWithoutRefSupplier` tinyint(1) not null default ''0'',  '
+'    `HomeRegion` bigint(20) not null , '
+'    `TechContact` TEXT, '
+'    `TechOperatingMode` TEXT, '
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

function TClientsTable.GetColumns: String;
begin
  Result := ''
+'    `CLIENTID` , '
+'    `NAME` , '
+'    `REGIONCODE` , '
+'    `EXCESS` , '
+'    `DELTAMODE` , '
+'    `MAXUSERS` , '
+'    `REQMASK` , '
+'    `CALCULATELEADER` , '
+'    `AllowDelayOfPayment` , '
+'    `FullName` , '
+'    `SelfAddressId` ';
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
+'    `ExcessAvgOrderTimes` int(10) not null default ''5'', '
+'    primary key (`CLIENTID`)                   , '
+'    unique key `PK_CLIENTS` (`CLIENTID`)       , '
+'    key `FK_CLIENTS_REGIONCODE` (`REGIONCODE`) '
+'  ) '
+ GetTableOptions();
end;

{ TRejectsTable }

constructor TRejectsTable.Create;
begin
  FName := 'rejects';
  FObjectId := doiRejects;
  FRepairType := dortCumulative;
end;

function TRejectsTable.GetColumns: String;
begin
  Result := ''
+'    `ID` , '
+'    `NAME` , '
+'    `ProductId` , '
+'    `PRODUCER` , '
+'    `ProducerId` , '
+'    `SERIES` , '
+'    `LETTERNUMBER` , '
+'    `LETTERDATE` , '
+'    `REASON` , '
+'    `Hidden` , '
+'    `CHECKPRINT`  ';
end;

function TRejectsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `ID` bigint(20) not null        , '
+'    `NAME`         varchar(250) default null, '
+'    `ProductId` bigint(20) default null     , '
+'    `PRODUCER`     varchar(150) default null, '
+'    `ProducerId`     bigint(20) default null, '
+'    `SERIES`       varchar(50) default null , '
+'    `LETTERNUMBER` varchar(50) default null , '
+'    `LETTERDATE` timestamp null default null, '
+'    `REASON` text                           , '
+'    `Hidden` tinyint(1) not null            , '
+'    `CHECKPRINT` tinyint(1) not null        , '
+'    primary key (`ID`)                      , '
+'    key `IDX_Rejects_Name` (`Name`)         , '
+'    key `IDX_Rejects_ProductId` (`ProductId`), '
+'    key `IDX_Rejects_SERIES` (`SERIES`)       '
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

function TProvidersTable.GetColumns: String;
begin
  Result := ''
+'    `FIRMCODE` , '
+'    `FULLNAME` , '
+'    `FAX` , '
+'    `MANAGERMAIL` , '
+'    `ShortName` , '
+'    `CertificateSourceExists`,  '
+'    `SupplierCategory`,  '
+'    `MainFirm`  ';
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
+'    `CertificateSourceExists`  tinyint(1) not null default ''0'' , '
+'    `SupplierCategory`  int(10) not null default ''0'' , '
+'    `MainFirm`  tinyint(1) not null default ''0'' , '
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

function TRegionsTable.GetColumns: String;
begin
  Result := ''
+'    `REGIONCODE` , '
+'    `REGIONNAME` , '
+'    `PRICERET`    ';
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

function TRegionalDataTable.GetColumns: String;
begin
  Result := ''
+'    `FIRMCODE` , '
+'    `REGIONCODE` , '
+'    `SUPPORTPHONE` , '
+'    `CONTACTINFO` , '
+'    `OPERATIVEINFO`  ';
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

function TPricesDataTable.GetColumns: String;
begin
  Result := ''
+'    `FIRMCODE` , ' 
+'    `PRICECODE` , ' 
+'    `PRICENAME` , ' 
+'    `PRICEINFO` , ' 
+'    `DATEPRICE` , '
+'    `FRESH`  ';
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

function TPricesRegionalDataTable.GetColumns: String;
begin
  Result := ''
+'    `PRICECODE` , '
+'    `REGIONCODE` , '
+'    `STORAGE` , '
+'    `MINREQ` , '
+'    `ENABLED` , '
+'    `INJOB` , '
+'    `CONTROLMINREQ` , '
+'    `PRICESIZE` ';
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

function TDelayOfPaymentsTable.GetColumns: String;
begin
  Result := ''
+'    `PriceCode` , '
+'    `DayOfWeek`, '
+'    `VitallyImportantDelay` , '
+'    `OtherDelay`  ';
end;

function TDelayOfPaymentsTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `PriceCode` bigint(20) not null      , '
+'    `DayOfWeek` enum (''Monday'', ''Tuesday'', ''Wednesday'', ''Thursday'', ''Friday'', ''Saturday'', ''Sunday'') not null, '
+'    `VitallyImportantDelay` decimal(18,2) default null, '
+'    `OtherDelay` decimal(18,2) default null, '
+'    key `IDX_DelayOfPayments_PriceCode` (`PriceCode`), '
+'    key `IDX_DelayOfPayments_Week` (`PriceCode`, `DayOfWeek`) '
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

function TCatalogNamesTable.GetColumns: String;
begin
  Result := ''
+'    `ID` , ' 
+'    `NAME` , ' 
+'    `LATINNAME` , ' 
+'    `DESCRIPTION` '; 
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

function TCatalogFarmGroupsTable.GetColumns: String;
begin
  Result := ''
+'    `ID` , '
+'    `NAME` , '
+'    `DESCRIPTION` , '
+'    `PARENTID` , '
+'    `GROUPTYPE` ';
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

function TCatalogsTable.GetColumns: String;
begin
  Result := ''
+'    `FULLCODE` , '
+'    `SHORTCODE` , '
+'    `NAME` , '
+'    `FORM` , '
+'    `VITALLYIMPORTANT` , '
+'    `NEEDCOLD` , '
+'    `FRAGILE` , '
+'    `MandatoryList` , '
+'    `MnnId` , '
+'    `DescriptionId` , '
+'    `Hidden` , '
+'    `Markup`,'
+'    `MaxMarkup`,'
+'    `MaxSupplierMarkup`, '
+'    `COREEXISTS` , '
+'    `PromotionsCount` , '
+'    `NamePromotionsCount`  ';
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
+'    `Markup`     decimal(5,2) default NULL, '
+'    `MaxMarkup` decimal(5,2) default NULL, '
+'    `MaxSupplierMarkup` decimal(5,2) default NULL, '
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

function TProductsTable.GetColumns: String;
begin
  Result := ''
+'    `PRODUCTID` , '
+'    `CATALOGID`  ';
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

function TCoreTable.GetColumns: String;
begin
  Result := ''
+'    `PRICECODE` , ' 
+'    `REGIONCODE` , ' 
+'    `PRODUCTID` , ' 
+'    `CODEFIRMCR` , ' 
+'    `SYNONYMCODE` , ' 
+'    `SYNONYMFIRMCRCODE` , ' 
+'    `CODE` , ' 
+'    `CODECR` , ' 
+'    `UNIT` , ' 
+'    `VOLUME` , ' 
+'    `JUNK` , ' 
+'    `AWAIT` , ' 
+'    `QUANTITY` , ' 
+'    `NOTE` , ' 
+'    `PERIOD` , ' 
+'    `DOC` , ' 
+'    `REGISTRYCOST` , ' 
+'    `VITALLYIMPORTANT` , ' 
+'    `REQUESTRATIO` , ' 
+'    `Cost` , ' 
+'    `SERVERCOREID` , ' 
+'    `ORDERCOST` , ' 
+'    `MINORDERCOUNT` , '
+'    `SupplierPriceMarkup` , '
+'    `ProducerCost` , '
+'    `NDS` , '
+'    `RetailVitallyImportant` , ' 
+'    `BuyingMatrixType` , '
+'    `CryptCost` , '
+'    `COREID`  ';
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
+'    `RetailVitallyImportant` tinyint(1) not null default ''0'', ' 
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

function TMinPricesTable.GetColumns: String;
begin
  Result := ''
+'    `PRODUCTID` , '
+'    `REGIONCODE` , '
+'    `SERVERCOREID` , '
+'    `PriceCode` , '
+'    `MinCost` , '
+'    `NextCost` , '
+'    `MinCostCount` , '
+'    `Percent`  ';
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
+'    key `IDX_MINPRICES_Percent` (`Percent`), '
+'    key `IDX_MinPrices_MinCostCount` (`MinCostCount`) '
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

function TMNNTable.GetColumns: String;
begin
  Result := ''
+'    `Id` , '
+'    `Mnn` , '
+'    `Hidden` ';
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

function TDescriptionsTable.GetColumns: String;
begin
  Result := ''
+'  `Id` , '
+'  `Name` , '
+'  `EnglishName` , '
+'  `Description` , '
+'  `Interaction` , '
+'  `SideEffect` , '
+'  `IndicationsForUse` , '
+'  `Dosing` , '
+'  `Warnings` , '
+'  `ProductForm` , '
+'  `PharmacologicalAction` , '
+'  `Storage` , '
+'  `Expiration` , '
+'  `Composition` , '
+'  `Hidden` ';
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

function TMaxProducerCostsTable.GetColumns: String;
begin
  Result := ''
+'  `Id` , '
+'  `CatalogId` , '
+'  `ProductId` , '
+'  `Product` , '
+'  `Producer` , '
+'  `Cost` , '
+'  `ProducerId` , '
+'  `RealCost` '
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

function TProducersTable.GetColumns: String;
begin
  Result := ''
+'  `Id` , '
+'  `Name` , '
+'  `Hidden` ';
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

function TMinReqRulesTable.GetColumns: String;
begin
  Result := ''
+'  `ClientId` , '
+'  `PriceCode` , '
+'  `RegionCode` , '
+'  `ControlMinReq` , '
+'  `MinReq`  ';
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

function TSupplierPromotionsTable.GetColumns: String;
begin
  Result := ''
+'  `Id` , '
+'  `Status` , '
+'  `SupplierId` , '
+'  `Name` , '
+'  `Annotation` , '
+'  `PromoFile` , '
+'  `Begin` , '
+'  `End` ';
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
+'  `Begin` datetime DEFAULT NULL, '
+'  `End` datetime DEFAULT NULL, '
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

function TPromotionCatalogsTable.GetColumns: String;
begin
  Result := ''
+'  `CatalogId` , '
+'  `PromotionId` , '
+'  `Hidden`  ';
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

{ TSchedulesTable }

constructor TSchedulesTable.Create;
begin
  FName := 'schedules';
  FObjectId := doiSchedules;
  FRepairType := dortCumulative;
end;

function TSchedulesTable.GetColumns: String;
begin
  Result := ''
+'  `Id` , '
+'  `Hour` , '
+'  `Minute`  ';
end;

function TSchedulesTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT, '
+'  `Hour` int NOT NULL DEFAULT ''0'', '
+'  `Minute` int NOT NULL DEFAULT ''0'', '
+'  PRIMARY KEY (`Id`) '
+'  ) '
+ GetTableOptions();
end;

{ TCertificatesTable }

constructor TCertificatesTable.Create;
begin
  FName := 'certificates';
  FObjectId := doiCertificates;
  FRepairType := dortCumulative;
end;

function TCertificatesTable.GetColumns: String;
begin
  Result := ''
+'    Id , '
+'    CatalogId , '
+'    SerialNumber  ';
end;

function TCertificatesTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    Id bigint(20) NOT NULL, '
+'    CatalogId bigint(20) NOT NULL, '
+'    SerialNumber VARCHAR(50) NOT NULL, '
+'    PRIMARY KEY (Id), '
+'    key IDX_Certificate (CatalogId, SerialNumber) '
+'  ) '
+ GetTableOptions();
end;

{ TCertificateFilesTable }

constructor TCertificateFilesTable.Create;
begin
  FName := 'certificatefiles';
  FObjectId := doiCertificateFiles;
  FRepairType := dortCumulative;
end;

function TCertificateFilesTable.GetColumns: String;
begin
  Result := ''
+'      Id , '
+'      OriginFilename , '
+'      ExternalFileId , '
+'      CertificateSourceId , '
+'      Extension  ';
end;

function TCertificateFilesTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'      Id bigint(20) NOT NULL, '
+'      OriginFilename VARCHAR(255) NOT NULL, '
+'      ExternalFileId VARCHAR(255) NOT NULL, '
+'      CertificateSourceId bigint(20) NOT NULL, '
+'      Extension VARCHAR(255) NOT NULL, '
+'      PRIMARY KEY (Id), '
+'      key IDX_CertificateSourceId (CertificateSourceId) '
+'  ) '
+ GetTableOptions();
end;

{ TFileCertificatesTable }

constructor TFileCertificatesTable.Create;
begin
  FName := 'filecertificates';
  FObjectId := doiFileCertificates;
  FRepairType := dortCumulative;
end;

function TFileCertificatesTable.GetColumns: String;
begin
  Result := ''
+'      CertificateId,  '
+'      CertificateFileId  ';
end;

function TFileCertificatesTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'      CertificateId bigint(20) NOT NULL, '
+'      CertificateFileId bigint(20) NOT NULL, '
+'      KEY (CertificateId), '
+'      KEY (CertificateFileId) '
+'  ) '
+ GetTableOptions();
end;

{ TCertificateSourcesTable }

constructor TCertificateSourcesTable.Create;
begin
  FName := 'certificatesources';
  FObjectId := doiCertificateSources;
  FRepairType := dortCumulative;
end;

function TCertificateSourcesTable.GetColumns: String;
begin
  Result := ''
+'      Id  ';
end;

function TCertificateSourcesTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'      Id bigint(20) NOT NULL, '
+'      PRIMARY KEY (Id) '
+'  ) '
+ GetTableOptions();
end;

{ TSourceSuppliersTable }

constructor TSourceSuppliersTable.Create;
begin
  FName := 'sourcesuppliers';
  FObjectId := doiSourceSuppliers;
  FRepairType := dortCumulative;
end;

function TSourceSuppliersTable.GetColumns: String;
begin
  Result := ''
+'      CertificateSourceId , '
+'      SupplierId  ';
end;

function TSourceSuppliersTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'      CertificateSourceId bigint(20) NOT NULL, '
+'      SupplierId bigint(20) NOT NULL, '
+'      KEY (CertificateSourceId), '
+'      KEY (SupplierId) '
+'  ) '
+ GetTableOptions();
end;

{ TNewsTable }

constructor TNewsTable.Create;
begin
  FName := 'news';
  FObjectId := doiNews;
  FRepairType := dortCumulative;
end;

function TNewsTable.GetColumns: String;
begin
  Result := ''
+'      Id , '
+'      PublicationDate , '
+'      Header  ';
end;

function TNewsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'      Id bigint(20) NOT NULL, '
+'      PublicationDate datetime NOT NULL, '
+'      Header varchar(255) default NULL, '
+'      primary key (Id), '
+'      key (PublicationDate) '
+'  ) '
+ GetTableOptions();
end;

initialization
  DatabaseController.AddObject(TUserInfoTable.Create());
  DatabaseController.AddObject(TClientTable.Create());
  DatabaseController.AddObject(TClientsTable.Create());
  DatabaseController.AddObject(TRejectsTable.Create());

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

  DatabaseController.AddObject(TSchedulesTable.Create());

  DatabaseController.AddObject(TCertificatesTable.Create());
  DatabaseController.AddObject(TCertificateFilesTable.Create());
  DatabaseController.AddObject(TCertificateSourcesTable.Create());
  DatabaseController.AddObject(TSourceSuppliersTable.Create());
  DatabaseController.AddObject(TFileCertificatesTable.Create());

  DatabaseController.AddObject(TNewsTable.Create());
end.

