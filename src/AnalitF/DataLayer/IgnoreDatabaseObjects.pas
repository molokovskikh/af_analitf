unit IgnoreDatabaseObjects;

interface

uses
  SysUtils, Classes, Contnrs, StrUtils,
  DatabaseObjects;
  
type
  TPricesRegionalDataUpTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TTmpClientsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TTmpRegionsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TTmpProvidersTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TTmpRegionalDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TTmpPricesDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TTmpPricesRegionalDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

implementation

{ TPricesRegionalDataUpTable }

constructor TPricesRegionalDataUpTable.Create;
begin
  FName := 'pricesregionaldataup';
  FObjectId := doiPricesRegionalDataUp;
  FRepairType := dortIgnore;
end;

function TPricesRegionalDataUpTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `PRICECODE` bigint(20) not null, ' 
+'    `REGIONCODE` bigint(20) not null ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TTmpClientsTable }

constructor TTmpClientsTable.Create;
begin
  FName := 'tmpclients';
  FObjectId := doiTmpClients;
  FRepairType := dortIgnore;
end;

function TTmpClientsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `CLIENTID` bigint(20) not null      , ' 
+'    `NAME` varchar(50) not null         , ' 
+'    `REGIONCODE` bigint(20) default null, ' 
+'    `EXCESS`    int(10) not null           , ' 
+'    `DELTAMODE` smallint(5) default null   , ' 
+'    `MAXUSERS`  int(10) not null           , ' 
+'    `REQMASK` bigint(20) default null      , ' 
+'    `TECHSUPPORT`     varchar(255) default null, ' 
+'    `CALCULATELEADER` tinyint(1) not null      , ' 
+'    `ONLYLEADERS`     tinyint(1) not null ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TTmpRegionsTable }

constructor TTmpRegionsTable.Create;
begin
  FName := 'tmpregions';
  FObjectId := doiTmpRegions;
  FRepairType := dortIgnore;
end;

function TTmpRegionsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `REGIONCODE` bigint(20) not null     , ' 
+'    `REGIONNAME` varchar(25) default null, ' 
+'    `PRICERET`   varchar(254) default null ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TTmpProvidersTable }

constructor TTmpProvidersTable.Create;
begin
  FName := 'tmpproviders';
  FObjectId := doiTmpProviders;
  FRepairType := dortIgnore;
end;

function TTmpProvidersTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `FIRMCODE` bigint(20) not null     , '
+'    `FULLNAME`    varchar(40) default null, '
+'    `FAX`         varchar(20) default null, '
+'    `MANAGERMAIL` varchar(255) default null '
+'  ) '
+ GetTableOptions();
end;

{ TTmpRegionalDataTable }

constructor TTmpRegionalDataTable.Create;
begin
  FName := 'tmpregionaldata';
  FObjectId := doiTmpRegionalData;
  FRepairType := dortIgnore;
end;

function TTmpRegionalDataTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `FIRMCODE` bigint(20) not null         , ' 
+'    `REGIONCODE` bigint(20) not null       , ' 
+'    `SUPPORTPHONE` varchar(20) default null, ' 
+'    `CONTACTINFO` text                     , ' 
+'    `OPERATIVEINFO` text ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TTmpPricesDataTable }

constructor TTmpPricesDataTable.Create;
begin
  FName := 'tmppricesdata';
  FObjectId := doiTmpPricesData;
  FRepairType := dortIgnore;
end;

function TTmpPricesDataTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `FIRMCODE` bigint(20) not null      , ' 
+'    `PRICECODE` bigint(20) not null     , ' 
+'    `PRICENAME` varchar(70) default null, ' 
+'    `PRICEINFO` text                    , ' 
+'    `DATEPRICE` datetime default null   , ' 
+'    `FRESH`     tinyint(1) not null ' 
+'  ) ' 
+ GetTableOptions();
end;

{ TTmpPricesRegionalDataTable }

constructor TTmpPricesRegionalDataTable.Create;
begin
  FName := 'tmppricesregionaldata';
  FObjectId := doiTmpPricesRegionalData;
  FRepairType := dortIgnore;
end;

function TTmpPricesRegionalDataTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `PRICECODE` bigint(20) not null , ' 
+'    `REGIONCODE` bigint(20) not null, ' 
+'    `STORAGE`       tinyint(1) not null   , ' 
+'    `MINREQ`        int(10) default null  , ' 
+'    `ENABLED`       tinyint(1) not null   , ' 
+'    `INJOB`         tinyint(1) not null   , ' 
+'    `CONTROLMINREQ` tinyint(1) not null ' 
+'  ) ' 
+ GetTableOptions()
end;

initialization
  DatabaseController.AddObject(TPricesRegionalDataUpTable.Create());
  DatabaseController.AddObject(TTmpClientsTable.Create());
  DatabaseController.AddObject(TTmpRegionsTable.Create());
  DatabaseController.AddObject(TTmpProvidersTable.Create());
  DatabaseController.AddObject(TTmpRegionalDataTable.Create());
  DatabaseController.AddObject(TTmpPricesDataTable.Create());
  DatabaseController.AddObject(TTmpPricesRegionalDataTable.Create());
end.
