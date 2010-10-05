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

  TClientAvgView = class(TDatabaseView)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
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
  FRepairType := dortIgnore;
end;

function TClientAvgView.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  select `postedorderheads`.`CLIENTID` as `CLIENTCODE`, ' 
+'    `postedorderlists`.`PRODUCTID`     as `PRODUCTID` , ' 
+'    avg(`postedorderlists`.`PRICE`)    as `PRICEAVG` ' 
+'  from (`postedorderheads` ' 
+'    join `postedorderlists`) ' 
+'  where ( ' 
+'      ( ' 
+'        `postedorderlists`.`ORDERID` = `postedorderheads`.`ORDERID` ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `postedorderheads`.`ORDERDATE` >= (CURDATE() - INTERVAL 1 month) ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `postedorderheads`.`CLOSED` = 1 ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `postedorderheads`.`SEND` = 1 ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `postedorderlists`.`ORDERCOUNT` > 0 ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `postedorderlists`.`PRICE` is not null ' 
+'      ) ' 
+'    and ' 
+'      ( '
+'        `postedorderlists`.`Junk` = 0 '
+'      ) '
+'    ) '
+'  group by `postedorderheads`.`CLIENTID`, ' 
+'    `postedorderlists`.`PRODUCTID`;';
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
