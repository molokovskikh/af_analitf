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
+'    `prd`.`MINREQ`        as `MinReq`            , ' 
+'    `prd`.`ENABLED`       as `Enabled`           , ' 
+'    `cd`.`FIRMCODE`       as `FirmCode`          , ' 
+'    `cd`.`FULLNAME`       as `FullName`          , ' 
+'    `prd`.`STORAGE`       as `Storage`           , ' 
+'    `cd`.`MANAGERMAIL`    as `ManagerMail`       , ' 
+'    `r`.`REGIONCODE`      as `RegionCode`        , ' 
+'    `r`.`REGIONNAME`      as `RegionName`        , ' 
+'    `prd`.`PRICESIZE`     as `pricesize`         , ' 
+'    `prd`.`CONTROLMINREQ` as `CONTROLMINREQ` ' 
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
+'  select `ordershead`.`CLIENTID` as `CLIENTCODE`, ' 
+'    `orderslist`.`PRODUCTID`     as `PRODUCTID` , ' 
+'    avg(`orderslist`.`PRICE`)    as `PRICEAVG` ' 
+'  from (`ordershead` ' 
+'    join `orderslist`) ' 
+'  where ( ' 
+'      ( ' 
+'        `orderslist`.`ORDERID` = `ordershead`.`ORDERID` ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `ordershead`.`ORDERDATE` >= (CURDATE() - INTERVAL 1 month) ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `ordershead`.`CLOSED` = 1 ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `ordershead`.`SEND` = 1 ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `orderslist`.`ORDERCOUNT` > 0 ' 
+'      ) ' 
+'    and ' 
+'      ( ' 
+'        `orderslist`.`PRICE` is not null ' 
+'      ) ' 
+'    ) ' 
+'  group by `ordershead`.`CLIENTID`, ' 
+'    `orderslist`.`PRODUCTID`;';
end;

initialization
  DatabaseController.AddObject(TPricesShowView.Create());
  DatabaseController.AddObject(TClientAvgView.Create());
end.
