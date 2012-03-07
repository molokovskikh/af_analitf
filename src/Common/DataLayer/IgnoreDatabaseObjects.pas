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
    function GetColumns() : String; override;
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

  TBatchReportDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TBatchReportServiceFieldsDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TUserActionLogsDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TCertificateRequestsDataTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TAttachmentRequestsDataTable = class(TDatabaseTable)
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

function TPricesRegionalDataUpTable.GetColumns: String;
begin
  Result := ''
+'    `PRICECODE` , '
+'    `REGIONCODE`  ';
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

{ TBatchReportDataTable }

constructor TBatchReportDataTable.Create;
begin
  FName := 'batchreport';
  FObjectId := doiBatchReport;
  FRepairType := dortIgnore;
end;

function TBatchReportDataTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `Id` bigint(20) not null , '
+'    `ClientId` bigint(20) not null , '
+'    `SynonymName` varchar(250) default null , '
+'    `SynonymFirm` varchar(250) default null , '
+'    `Quantity`  int(10) not null            , '
+'    `Comment`  text                         , '
+'    `OrderListId` bigint(20) default null   , '
+'    `Status`     smallint(5) default null   , '
+'    `ProductId` bigint(20) default null         , '
+'    `CodeFirmCr` bigint(20) default null    , '
+'    `ServiceField1` varchar(255) default null, '
+'    `ServiceField2` varchar(255) default null, '
+'    `ServiceField3` varchar(255) default null, '
+'    `ServiceField4` varchar(255) default null, '
+'    `ServiceField5` varchar(255) default null, '
+'    `ServiceField6` varchar(255) default null, '
+'    `ServiceField7` varchar(255) default null, '
+'    `ServiceField8` varchar(255) default null, '
+'    `ServiceField9` varchar(255) default null, '
+'    `ServiceField10` varchar(255) default null, '
+'    `ServiceField11` varchar(255) default null, '
+'    `ServiceField12` varchar(255) default null, '
+'    `ServiceField13` varchar(255) default null, '
+'    `ServiceField14` varchar(255) default null, '
+'    `ServiceField15` varchar(255) default null, '
+'    `ServiceField16` varchar(255) default null, '
+'    `ServiceField17` varchar(255) default null, '
+'    `ServiceField18` varchar(255) default null, '
+'    `ServiceField19` varchar(255) default null, '
+'    `ServiceField20` varchar(255) default null, '
+'    `ServiceField21` varchar(255) default null, '
+'    `ServiceField22` varchar(255) default null, '
+'    `ServiceField23` varchar(255) default null, '
+'    `ServiceField24` varchar(255) default null, '
+'    `ServiceField25` varchar(255) default null, '
+'    primary key (`Id`)                        '
+'  ) '
+ GetTableOptions()
end;

{ TBatchReportServiceFieldsDataTable }

constructor TBatchReportServiceFieldsDataTable.Create;
begin
  FName := 'batchreportservicefields';
  FObjectId := doiBatchReportServiceFields;
  FRepairType := dortIgnore;
end;

function TBatchReportServiceFieldsDataTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `Id` bigint(20) not null AUTO_INCREMENT, '
+'    `ClientId` bigint(20) not null , '
+'    `FieldName` varchar(250) not null , '
+'    primary key (`Id`)                        '
+'  ) '
+ GetTableOptions()
end;

{ TUserActionLogsDataTable }

constructor TUserActionLogsDataTable.Create;
begin
  FName := 'useractionlogs';
  FObjectId := doiUserActionLogs;
  FRepairType := dortIgnore;
end;

function TUserActionLogsDataTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'  `Id` bigint(20) not null AUTO_INCREMENT,   '
+'  `LogTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, '
+'  `UserActionId` bigint(20) NOT NULL, '
+'  `Context` varchar(255) DEFAULT NULL, '
+'  primary key (`Id`), '
+'  KEY (`LogTime`) '
+'  ) '
+ GetTableOptions()
end;

{ TCertificateRequestsDataTable }

constructor TCertificateRequestsDataTable.Create;
begin
  FName := 'certificaterequests';
  FObjectId := doiCertificateRequests;
  FRepairType := dortIgnore;
end;

function TCertificateRequestsDataTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'  `DocumentBodyId` bigint(20) not null,   '
+'  `CertificateId` bigint(20) default null '
+'  ) '
+ GetTableOptions()
end;

{ TAttachmentRequestsDataTable }

constructor TAttachmentRequestsDataTable.Create;
begin
  FName := 'attachmentrequests';
  FObjectId := doiAttachmentRequests;
  FRepairType := dortIgnore;
end;

function TAttachmentRequestsDataTable.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'  `AttachmentId` bigint(20) not null   '
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
  DatabaseController.AddObject(TBatchReportDataTable.Create());
  DatabaseController.AddObject(TBatchReportServiceFieldsDataTable.Create());
  DatabaseController.AddObject(TUserActionLogsDataTable.Create());
  DatabaseController.AddObject(TCertificateRequestsDataTable.Create());
  DatabaseController.AddObject(TAttachmentRequestsDataTable.Create());
end.
