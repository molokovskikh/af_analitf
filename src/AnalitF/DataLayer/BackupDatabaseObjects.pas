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

  TOrdersHeadTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TOrdersListTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TReceivedDocsTable = class(TDatabaseTable)
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
+'    `LEFTLIMIT`  decimal(18,4) not null     , ' 
+'    `RIGHTLIMIT` decimal(18,4) not null     , ' 
+'    `RETAIL`     int(10) not null           , '
+'    primary key (`ID`)                      , '
+'    unique key `PK_RETAILMARGINS` (`ID`) '
+'  ) '
+'  ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;';
end;

function TRetailMarginsTable.GetInsertSQL(DatabasePrefix: String): String;
begin
  Result := ''
  + 'INSERT INTO '
  + IfThen(Length(DatabasePrefix) > 0, DatabasePrefix + '.')
  + FName
  +'(ID, LEFTLIMIT, RIGHTLIMIT, RETAIL) VALUES (1, 0, 1000000, 30);';
end;

{ TOrdersHeadTable }

constructor TOrdersHeadTable.Create;
begin
  FName := 'ordershead';
  FObjectId := doiOrdersHead;
  FRepairType := dortBackup;
end;

function TOrdersHeadTable.GetCreateSQL(DatabasePrefix: String): String;
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
+'    primary key (`ORDERID`)                        , ' 
+'    unique key `PK_ORDERSH` (`ORDERID`)            , ' 
+'    key `FK_ORDERSH_CLIENTID` (`CLIENTID`)         , ' 
+'    key `IDX_ORDERSH_ORDERDATE` (`ORDERDATE`)      , ' 
+'    key `IDX_ORDERSH_PRICECODE` (`PRICECODE`)      , ' 
+'    key `IDX_ORDERSH_REGIONCODE` (`REGIONCODE`)    , ' 
+'    key `IDX_ORDERSH_SENDDATE` (`SENDDATE`) ' 
+'  ) ' 
+'  ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;';
end;

{ TOrdersListTable }

constructor TOrdersListTable.Create;
begin
  FName := 'orderslist';
  FObjectId := doiOrdersList;
  FRepairType := dortBackup;
end;

function TOrdersListTable.GetCreateSQL(DatabasePrefix: String): String;
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
+'  ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;';
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
+'  ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;';
end;

initialization
  DatabaseController.AddObject(TRetailMarginsTable.Create());
  DatabaseController.AddObject(TOrdersHeadTable.Create());
  DatabaseController.AddObject(TOrdersListTable.Create());
  DatabaseController.AddObject(TReceivedDocsTable.Create());
end.
