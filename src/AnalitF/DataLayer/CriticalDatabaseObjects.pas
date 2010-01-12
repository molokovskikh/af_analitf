unit CriticalDatabaseObjects;

interface

uses
  SysUtils, Classes, Contnrs, StrUtils,
  DatabaseObjects;

type
  TParamsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetInsertSQL(DatabasePrefix : String = '') : String; override;
  end;

implementation

{ TParamsTable }

constructor TParamsTable.Create;
begin
  FName := 'params';
  FObjectId := doiParams;
  FRepairType := dortCritical;
end;

function TParamsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `ID` bigint(20) not null                                                          , ' 
+'    `CLIENTID` bigint(20) default null                                                , ' 
+'    `RASCONNECT`             tinyint(1) not null                                      , ' 
+'    `RASENTRY`               varchar(30) default null                                 , ' 
+'    `RASNAME`                varchar(30) default null                                 , ' 
+'    `RASPASS`                varchar(30) default null                                 , ' 
+'    `CONNECTCOUNT`           smallint(5) not null default ''5''                         , '
+'    `CONNECTPAUSE`           smallint(5) not null default ''5''                         , '
+'    `PROXYCONNECT`           tinyint(1) not null                                      , '
+'    `PROXYNAME`              varchar(30) default null                                 , '
+'    `PROXYPORT`              int(10) default null                                     , '
+'    `PROXYUSER`              varchar(30) default null                                 , '
+'    `PROXYPASS`              varchar(255) default null                                , '
+'    `HTTPHOST`               varchar(50) default ''ios.analit.net''                     , '
+'    `HTTPNAME`               varchar(30) default null                                 , '
+'    `HTTPPASS`               varchar(255) default null                                , '
+'    `UPDATEDATETIME`         datetime default null                                    , '
+'    `LASTDATETIME`           datetime default null                                    , '
+'    `SHOWREGISTER`           tinyint(1) not null                                      , '
+'    `USEFORMS`               tinyint(1) not null                                      , '
+'    `OPERATEFORMS`           tinyint(1) not null                                      , '
+'    `OPERATEFORMSSET`        tinyint(1) not null                                      , '
+'    `STARTPAGE`              smallint(5) not null default ''0''                         , '
+'    `LASTCOMPACT`            datetime default null                                    , '
+'    `CUMULATIVE`             tinyint(1) not null                                      , '
+'    `STARTED`                tinyint(1) not null                                      , '
+'    `RASSLEEP`               smallint(5) not null default ''3''                         , '
+'    `HTTPNAMECHANGED`        tinyint(1) not null                                      , '
+'    `SHOWALLCATALOG`         tinyint(1) not null                                      , '
+'    `CDS`                    varchar(224) default null                                , '
+'    `ORDERSHISTORYDAYCOUNT`  int(10) not null default ''21''                            , '
+'    `CONFIRMDELETEOLDORDERS` tinyint(1) not null                                      , '
+'    `USEOSOPENWAYBILL`       tinyint(1) not null                                      , '
+'    `USEOSOPENREJECT`        tinyint(1) not null                                      , '
+'    `GROUPBYPRODUCTS`        tinyint(1) not null                                      , '
+'    `PRINTORDERSAFTERSEND`   tinyint(1) not null                                      , '
+'    `ProviderName`           varchar(50) not null default ''АК "Инфорум"''              , '
+'    `ProviderAddress`        varchar(30) not null default ''Ленинский пр-т, 160 оф.415'', '
+'    `ProviderPhones`         varchar(30) not null default ''4732-606000''               , '
+'    `ProviderEmail`          varchar(30) not null default ''farm@analit.net''           , '
+'    `ProviderWeb`            varchar(30) not null default ''http://www.analit.net/''    , '
+'    `ProviderMDBVersion`     smallint(6) not null default ''49''                        , '
+'    `ConfirmSendingOrders`   tinyint(1) not null default ''0''                          , '
+'    primary key (`ID`)                                                                , '
+'    unique key `PK_PARAMS` (`ID`) ' 
+'  ) ' 
+'  ENGINE=MyISAM default CHARSET=cp1251;';
end;

function TParamsTable.GetInsertSQL(DatabasePrefix: String): String;
begin
  Result := '' +
    'insert into ' +
    IfThen(Length(DatabasePrefix) > 0, DatabasePrefix + '.') +
    FName +
    ' set ' +
    'Id = 0,' +
    'ClientId = null,' +
    'RasConnect = 0,' +
    'RasEntry = null,' +
    'RasName = null,' +
    'RasPass = null,' +
    'ConnectCount = 5,' +
    'ConnectPause = 5,' +
    'ProxyConnect = 0,' +
    'ProxyName = null,' +
    'ProxyPort = null,' +
    'ProxyUser = null,' +
    'ProxyPass = null,' +
    'HTTPHost = ''ios.analit.net'',' +
    'HTTPName = null,' +
    'HTTPPass = null,' +
    'UpdateDatetime = null,' +
    'LastDatetime = null,' +
    'ShowRegister = 1,' +
    'UseForms = 1,' +
    'OperateForms = 0,' +
    'OperateFormsSet = 0,' +
    'StartPage = 0,' +
    'LastCompact = null,' +
    'Cumulative = 0,' +
    'Started = 0,' +
    'RASSLEEP = 3,' +
    'HTTPNAMECHANGED = 1,' +
    'SHOWALLCATALOG = 0,' +
    'CDS = '''',' +
    'ORDERSHISTORYDAYCOUNT = 35,' +
    'CONFIRMDELETEOLDORDERS = 1,' +
    'USEOSOPENWAYBILL = 0,' +
    'USEOSOPENREJECT = 1,' +
    'GROUPBYPRODUCTS = 0,' +
    'PRINTORDERSAFTERSEND = 0,' +
    'ConfirmSendingOrders = 0,' +
    'ProviderName = ''АК "Инфорум"'',' +
    'ProviderAddress = ''Ленинский пр-т, 160 оф.415'',' +
    'ProviderPhones = ''4732-606000'',' +
    'ProviderEmail = ''farm@analit.net'',' +
    'ProviderWeb = ''http://www.analit.net/'',' +
    'ProviderMDBVersion = ' + IntToStr(CURRENT_DB_VERSION) + ';'
end;

initialization
  DatabaseController.AddObject(TParamsTable.Create());
end.
