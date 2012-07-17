unit DatabaseViews;

interface

uses
  SysUtils, Classes, Contnrs, StrUtils,
  DatabaseObjects;

type
{
    doiPricesShow,
    doiClientAvg);
}
  TPricesShowView = class(TDatabaseView)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TClientAvgView = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
    function GetColumns() : String; override;
  end;

  TGroupMaxProducerCostsView = class(TDatabaseView)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;
  
implementation

{ TPricesShowView }

constructor TPricesShowView.Create;
begin
  FName := 'pricesshow';
  FObjectId := doiPricesShow;
  FRepairType := dortIgnore;
end;

function TPricesShowView.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  select pd.PRICECODE     as PriceCode           , ' 
+'    `pd`.`PRICENAME`      as `PriceName`         , ' 
+'    `pd`.`DATEPRICE`      as `UniversalDatePrice`, ' 
+'    `prd`.`ENABLED`       as `Enabled`           , '
+'    `cd`.`FIRMCODE`       as `FirmCode`          , '
+'    `cd`.`FULLNAME`       as `FullName`          , '
+'    `prd`.`STORAGE`       as `Storage`           , '
+'    `cd`.`MANAGERMAIL`    as `ManagerMail`       , '
+'    `r`.`REGIONCODE`      as `RegionCode`        , '
+'    `r`.`REGIONNAME`      as `RegionName`        , '
+'    `prd`.`PRICESIZE`     as `pricesize`          '
+'  from (((`pricesdata` `pd` '
+'    join `pricesregionaldata` `prd` ' 
+'    on (`pd`.`PRICECODE` = `prd`.`PRICECODE` ' 
+'      ) ' 
+'    ) ' 
+'    join `regions` `r` ' 
+'    on (`prd`.`REGIONCODE` = `r`.`REGIONCODE` ' 
+'      ) ' 
+'    ) ' 
+'    join `providers` `cd` ' 
+'    on (`cd`.`FIRMCODE` = `pd`.`FIRMCODE` ' 
+'      ) ' 
+'    );';
end;

{ TClientAvgView }

constructor TClientAvgView.Create;
begin
  FName := 'clientavg';
  FObjectId := doiClientAvg;
  FRepairType := dortCumulative;
end;

function TClientAvgView.GetColumns: String;
begin
  Result := ''
+'    `ClientCode` , '
+'    `ProductId` , '
+'    `PriceAvg` , '
+'    `OrderCountAvg`  ';
end;

function TClientAvgView.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( '
+'    `ClientCode` bigint(20) default null                 , '
+'    `ProductId` bigint(20) default null                  , '
+'    `PriceAvg` decimal(18,2) default null     , '
+'    `OrderCountAvg` decimal(18,2) default null, '
+'    key `IDX_clientavg_ClientCode` (`ClientCode`)        , '
+'    key `IDX_clientavg_ProductId` (`ProductId`)            '
+'  ) '
+ GetTableOptions();
end;

{ TGroupMaxProducerCostsView }

constructor TGroupMaxProducerCostsView.Create;
begin
  FName := 'groupmaxproducercosts';
  FObjectId := doiGroupMaxProducerCosts;
  FRepairType := dortIgnore;
end;

function TGroupMaxProducerCostsView.GetCreateSQL(
  DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  select  '
+'    ProductId , '
+'    ProducerId, '
+'    Max(RealCost) as MaxProducerCost '
+'  from `maxproducercosts` '
+'  group by ProductId, ProducerId;';
end;

initialization
  DatabaseController.AddObject(TPricesShowView.Create());
  DatabaseController.AddObject(TClientAvgView.Create());
  DatabaseController.AddObject(TGroupMaxProducerCostsView.Create());
end.
