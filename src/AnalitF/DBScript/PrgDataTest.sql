create definer = 'system'@'%' 
procedure usersettings.PrgDataTest(in ClientCodeParam int unsigned, in FieldsTerminatedParam char(1), in LinesTerminatedParam char(1), in Cumulative bool)
begin
declare FirmSegmentParam, SShowAvgCosts, SShowJunkOffers bool;
declare CostsPasswordParam char(16);
declare FieldsTerminated, LinesTerminated char(1);
declare SClientCode int unsigned;
declare ClientRegionCode bigint unsigned;
drop temporary table if exists MaxCodesSynFirmCr, MinCosts, ActivePrices, Core, tmpprd, MaxCodesSyn, ParentCodes;
set @RowId := 0;
if (FieldsTerminatedParam is null) or (length(FieldsTerminatedParam)<1) then
set FieldsTerminated=char(159);
else
set FieldsTerminated=FieldsTerminatedParam;
end if;
if (LinesTerminatedParam is null) or (length(LinesTerminatedParam)<1) then
set LinesTerminated=char(161);
else
set LinesTerminated=LinesTerminatedParam;
end if;
select FirmSegment into FirmSegmentParam from clientsdata where firmcode=ClientCodeParam;
select BaseCostPassword
        into CostsPasswordParam
        from retclientsset where clientcode=ClientCodeParam;
select  s.OffersClientCode,
        s.ShowAvgCosts,
        s.ShowJunkOffers
into    SClientCode,
        SShowAvgCosts,
        SShowJunkOffers
from    retclientsset r,
        OrderSendRules.smart_order_rules s
where   r.clientcode        =ClientCodeParam
    and s.id                =r.smartorderruleid
    and s.offersclientcode !=r.clientcode;
select  RegionCode
into    ClientRegionCode
from    ClientsData Cd
where   firmcode=SClientCode;
 set @a:=concat(
'SELECT  P.Id, P.CatalogId ',
'FROM    ret_update_info r, ',
'        Catalogs.Products P ',
'WHERE   IF(', not Cumulative, ', (P.UpdateTime >= curdate()- interval 1 week), 1) ',
'    AND hidden       = 0 ',
'    AND clientcode= ',ClientCodeParam ,
' INTO OUTFILE ', '"results/Products', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'Products', 0);
 set @a:=concat(
'SELECT  C.Id            , ',
'        CN.Id           , ',
'        LEFT(name, 250) , ',
'        LEFT(form, 250) , ',
'        vitallyimportant, ',
'        needcold        , ',
'        fragile ',
'FROM    Catalogs.Catalog C      , ',
'        Catalogs.CatalogForms CF, ',
'        Catalogs.CatalogNames CN, ',
'        ret_update_info r ',
'WHERE   C.NameId            =CN.Id ',
'    AND C.FormId            =CF.Id ',
'    AND IF(', not Cumulative, ', (C.UpdateTime >= curdate()- interval 1 week), 1) ',
'    AND hidden              =0 ',
'    AND r.ClientCode        =',ClientCodeParam ,
' INTO OUTFILE ', '"results/Catalogs', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'Catalogs', 0);
set @a:=concat(
'SELECT  C.Id ',
'FROM    Catalogs.Catalog C, ',
'        ret_update_info r ',
'WHERE   C.UpdateTime >= curdate()- interval 1 week',
'    AND hidden       = 1 ',
'    AND NOT ', Cumulative,
'    AND clientcode= ',ClientCodeParam ,
' INTO OUTFILE ', '"results/CatDel', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'CatDel', 0);
  if SShowJunkOffers=1 then
    call GetPrices(ClientCodeParam);
create temporary table PricesTMP select * from Prices where PriceCode=2647;
    call GetPrices(SClientCode);
insert into Prices select * from PricesTMP;
drop temporary table PricesTMP;
      else
        call GetPrices(ClientCodeParam);
  end if;
set @a:=concat(
'SELECT  regions.regioncode, ',
'        region ',
'FROM    farm.regions, ',
'        clientsdata ',
'WHERE   firmcode                           = ',ifnull(SClientCode,ClientCodeParam) ,
'        and regions.regioncode & maskregion> 0 ');
  if  SShowJunkOffers!=1 or SShowJunkOffers is null then
set @a:=concat(@a,
'UNION ',
'        SELECT  regions.regioncode, ',
'        region ',
'FROM    farm.regions, ',
'        clientsdata ',
'WHERE   firmcode              = ',ClientCodeParam ,
'        and regions.regioncode= clientsdata.regioncode ',
'UNION ',
'SELECT  distinct regions.regioncode, ',
'        region ',
'FROM    farm.regions, ',
'        includeregulation, ',
'        clientsdata ',
'WHERE   includeclientcode     = ', ClientCodeParam ,
'        and firmcode          = primaryclientcode ',
'        and includetype        in (1, 2) ',
'        and regions.regioncode & clientsdata.maskregion>0 ',
'UNION ',
'        SELECT  regions.regioncode, ',
'        region ',
'FROM    farm.regions, ',
'        clientsdata, ',
'        includeregulation ',
'WHERE   primaryclientcode     = ',ClientCodeParam ,
'        and firmcode          = includeclientcode ',
'        and firmstatus        = 1 ',
'        and includetype        = 0 ',
'        and regions.regioncode= clientsdata.regioncode ');
  end if;
set @a:=concat(@a,
' INTO OUTFILE ', '"results/Regions', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'Regions', 0);
set @a:=concat(
'SELECT  firm.FirmCode, ',
'        firm.FullName, ',
'        firm.Fax, ',
'        "-", ',
'        "-", ',
'        "-", ',
'        "-", ',
'        "-", ',
'        "-", ',
'        "-", ',
'        "-", ',
'        "-", ',
'        "-", ',
'        "-", ',
'        "-" ',
'FROM    clientsdata as firm ',
'WHERE   firmcode in ',
'        (SELECT DISTINCT FirmCode ',
'        FROM    Prices ',
'        ) ',
' INTO OUTFILE ', '"results/Providers', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'Providers', 0);
set @a:=concat(
'SELECT  DISTINCT regionaldata.FirmCode, ',
'        regionaldata.RegionCode, ',
'        supportphone, ',
'        left(adminmail, 50), ',
'        ContactInfo, ',
'        OperativeInfo ',
'FROM    regionaldata, ',
'        Prices ',
'WHERE   regionaldata.firmcode      = Prices.firmcode ',
'        and regionaldata.regioncode= Prices.regioncode ',
' INTO OUTFILE ', '"results/RegionalData', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'RegionalData', 0);
set @a:=concat(
'SELECT  PriceCode, ',
'        RegionCode, ',
'        Storage, ',
'        MinReq, ',
'        MainFirm, ',
'        not disabledbyclient, ',
'        ControlMinReq ',
'FROM    Prices ',
' INTO OUTFILE ', '"results/PricesRegionalData', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'PricesRegionalData', 0);
create temporary table tmpprd
(
FirmCode int unsigned,
PriceCount int unsigned
)engine=MEMORY;
insert
into    tmpprd
select  firmcode,
        count(pricecode)
from    Prices
group by FirmCode,
        RegionCode;
set @a:=concat(
'SELECT  Prices.FirmCode, ',
'        Prices.pricecode, ',
'        concat(firm.shortname, if(PriceCount> 1 ',
'        or ShowPriceName                    = 1, concat(" (", pricename, ")"), "")), ',
'        " ", ',
'        PriceDate, ',
'        (Fresh                            = 1 and AlowInt= 0) ',
'        or actual=0 ',
'FROM    clientsdata as firm, ',
'        tmpprd, ',
'        Prices ',
'WHERE   tmpprd.firmcode             = firm.firmcode ',
'        and firm.firmcode           = Prices.FirmCode ',
' GROUP BY Prices.FirmCode, ',
'        Prices.pricecode ',
' INTO OUTFILE ', '"results/PricesData', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'PricesData', 0);
 if not Cumulative then
set @a:=concat(
'SELECT  RowId, ',
'        FullName, ',
'        FirmCr, ',
'        CountryCr, ',
'        Series, ',
'        LetterNo, ',
'        LetterDate, ',
'        LaboratoryName, ',
'        CauseRejects ',
'FROM    addition.rejects, ',
'        ret_update_info rui,  ',
'        retclientsset rcs  ',
'WHERE   accessTime      >= rui.RejectTime ',
'        and alowrejection= 1 ',
'        and rui.clientcode   = ',ClientCodeParam ,
'        and rcs.clientcode   = ',ClientCodeParam ,
' INTO OUTFILE ', '"results/Rejects', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'Rejects', 0);
end if;
set @a:=concat(
'SELECT  clientsdata.firmcode, ',
'        ShortName, ',
ifnull(ClientRegionCode, 'RegionCode'), ', ',
'        OverCostPercent, ',
'        DifferenceCalculation, ',
'        MultiUserLevel, ',
'        OrderRegionMask, ',
'        "", ',
'        CalculateLeader ',
'FROM    retclientsset, ',
'        clientsdata ',
'WHERE   clientsdata.firmcode        = ', ClientCodeParam,
'        and retclientsset.clientcode= clientsdata.firmcode ',
'UNION ',
'SELECT  clientsdata.firmcode, ',
'        ShortName, ',
ifnull(ClientRegionCode, 'RegionCode'), ', ',
'        retclientsset.OverCostPercent, ',
'        retclientsset.DifferenceCalculation, ',
'        retclientsset.MultiUserLevel, ',
'        if(IncludeType=3, parent.OrderRegionMask, retclientsset.OrderRegionMask), ',
'        "", ',
'        retclientsset.CalculateLeader ',
'FROM    retclientsset, ',
'        clientsdata, ',
'        retclientsset parent, ',
'        IncludeRegulation ',
'WHERE   clientsdata.firmcode        = IncludeClientCode ',
'        and retclientsset.clientcode= clientsdata.firmcode ',
'        and parent.clientcode  = Primaryclientcode ',
'        and firmstatus              = 1 ',
'        and IncludeType             in (0,3) ',
'        and Primaryclientcode       = ',ClientCodeParam ,
' INTO OUTFILE ', '"results/Clients', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'Clients', 0);
call GetActivePrices(ifnull(SClientCode,ClientCodeParam));
  if SClientCode is not null then
set @a:='SELECT  "" ';
    else
set @a:=concat('SELECT  o.ClientCode, ',
'        ol.ProductId, ',
'        round(avg(ol.Cost), 2) ',
'FROM    orders.ordershead o, ',
'        orders.orderslist ol, ',
'        ret_update_info rcs ',
'WHERE   o.ClientCode    = ', ClientCodeParam,
'        and o.WriteTime > if(', Cumulative, ', curdate() - interval 1 month, rcs.UpdateTime) ',
'        and ol.OrderID  = o.RowID ',
'        and rcs.clientcode = o.ClientCode ',
'GROUP BY o.ClientCode, ',
'        ol.ProductId ',
'UNION ALL ',
'SELECT  cd.FirmCode, ',
'        ol.ProductId, ',
'        round(avg(ol.Cost), 2) ',
'FROM    usersettings.IncludeRegulation ir, ',
'        usersettings.clientsdata cd, ',
'        orders.ordershead o, ',
'        orders.orderslist ol, ',
'        ret_update_info rcs ',
'WHERE   ir.Primaryclientcode = ', ClientCodeParam,
'        and cd.firmstatus    = 1 ',
'        and includetype      = 0 ',
'        and o.WriteTime > if(', Cumulative, ', curdate() - interval 1 month, rcs.UpdateTime) ',
'        and cd.FirmCode      = ir.IncludeClientCode ',
'        and o.ClientCode     = cd.FirmCode ',
'        and rcs.clientcode   = o.ClientCode ',
'        and ol.OrderID       = o.RowID ',
'GROUP BY cd.FirmCode, ',
'        ol.ProductId ');
  end if;
set @a:=concat(@a,
' INTO OUTFILE ', '"results/PriceAvg', ClientCodeParam, '.txt"',
                "FIELDS TERMINATED BY '", FieldsTerminated,
                "' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
                LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'PriceAvg', 0);
create temporary table  MaxCodesSyn
(
PriceCode int unsigned primary key,
Synonym int unsigned
)engine=MEMORY;
create temporary table  MaxCodesSynFirmCr
(
PriceCode int unsigned primary key,
Synonym int unsigned
)engine=MEMORY;
insert
into    MaxCodesSyn
select  Prices.pricecode,
        max(synonym.synonymcode)
        from  ActivePrices Prices,
        farm.synonym
where   synonym.pricecode= PriceSynonymCode
        and synonym.synonymcode> MaxSynonymCode
group by 1;
insert
into    MaxCodesSynFirmCr
select  Prices.pricecode,
        max(synonymfirmcr.synonymfirmcrcode)
from    ActivePrices Prices,
        farm.synonymfirmcr
where   synonymfirmcr.pricecode      = PriceSynonymCode
        and synonymfirmcr.synonymfirmcrcode> MaxSynonymFirmCrCode
group by 1;
create temporary table  ParentCodes
(
PriceCode int unsigned ,
MaxSynonymCode int unsigned,
MaxSynonymFirmCrCode int unsigned,
index  (PriceCode, MaxSynonymCode),
index  (PriceCode, MaxSynonymFirmCrCode)
)engine=MEMORY;
insert
into    ParentCodes
select  PriceSynonymCode,
        max(if(cumulative, 0, MaxSynonymCode)),
        max(if(cumulative, 0, MaxSynonymFirmCrCode))
from    ActivePrices Prices
where   if(cumulative, 1, fresh)
group by 1;
set @a:=concat(
'SELECT synonymfirmcr.synonymfirmcrcode, ',
'        left(Synonym, 250) ');
set @a:=concat(@a,
'FROM    farm.synonymfirmcr,',
'        ParentCodes ',
'WHERE   synonymfirmcr.pricecode             = ParentCodes.PriceCode ',
'        and synonymfirmcr.synonymfirmcrcode>MaxSynonymFirmCrCode ');
if cumulative then
set @a:=concat(@a,
'        union ',
'SELECT  synonymfirmcrcode, ',
'        left(synonym, 250)  ');
set @a:=concat(@a,
'FROM    farm.synonymfirmcr ',
'WHERE   synonymfirmcrcode=0 '
);
end if;
  set @a:=concat(@a, ' INTO OUTFILE ', '"results/SynonymFirmCr', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'SynonymFirmCr', 0);
set @a:=concat(
'SELECT  synonym.synonymcode, ',
'        left(synonym.synonym, 250)  ');
set @a:=concat(@a,
'FROM    farm.synonym, ',
'        ParentCodes ',
'WHERE   synonym.pricecode       = ParentCodes.PriceCode ',
'        and synonym.synonymcode> MaxSynonymCode ',
' INTO OUTFILE ', '"results/Synonyms', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'Synonyms', 0);

-- удаляем импорт таблицы CatalogCurrency
set @a:=concat(
'select currency, exchange ',
'from farm.catalogcurrency  where currency="$" or currency="Eu" ',
' INTO OUTFILE ', '"results/CatalogCurrency', ClientCodeParam, '.txt"',
"FIELDS TERMINATED BY '", FieldsTerminated,
"' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
LinesTerminated, "'");
prepare QueryTXT from @a;
-- EXECUTE QueryTXT;
-- insert into ready_client_files values(null, ClientCodeParam, 'CatalogCurrency', 0);

if Cumulative then
update ret_update_info
        set
        ReclameTime      =default,
        RejectTime       =default,
        CalculateReject  =0,
        RegistryTime     =default,
        CalculateRegistry=0
where   clientcode       =ClientCodeParam;
else
update ret_update_info set CalculateReject=1 where clientcode=ClientCodeParam;
end if;
update intersection_update_info iui,
        MaxCodesSynFirmCr,
        ActivePrices Prices
        set UncMaxSynonymFirmCrCode    = MaxCodesSynFirmCr.synonym,
        CalculateSynonymFirmCr         = 1
where   Prices.pricecode        = iui.pricecode
        and MaxCodesSynFirmCr.pricecode= Prices.pricecode
        and iui.clientcode    = ClientCodeParam;
update intersection_update_info iui,
        maxcodessyn,
        ActivePrices Prices
        set UncMaxSynonymCode      = maxcodessyn.synonym,
        CalculateSynonym           = 1
where   Prices.pricecode    = iui.pricecode
        and maxcodessyn.pricecode  = Prices.pricecode
        and iui.clientcode= ClientCodeParam;
update intersection_update_info iui,
        ActivePrices Prices
        set CalculateDate           = 1
where   Fresh
        and Prices.pricecode = iui.pricecode
        and Prices.RegionCode= iui.RegionCode
        and iui.clientcode = ClientCodeParam;
if SClientCode is null then
if (select sum(fresh)>0  from ActivePrices) or Cumulative  then
call GetOffers(ClientCodeParam, not Cumulative);
update  ActivePrices Prices,
        Core
        set CryptCost          = replace(replace(replace(replace(replace(aes_encrypt(Cost, CostsPasswordParam), char(37), '%25'), char(32), '%20'),
         char(159), '%9F'), char(161), '%A1'), char(0), '%00')
where   Prices.PriceCode= Core.PriceCode
        and if(Cumulative, 1, Fresh)
        and Core.PriceCode!=2647
        ;
update Core
        set CryptCost=concat(left(CryptCost, 1), char(round((rand()*110)+32,0)), substring(CryptCost,2,length(CryptCost)-4), char(round((rand()*110)+32,0)), right(CryptCost, 3))
where  length(CryptCost)>0
       and Core.PriceCode!=2647;
set @a:=concat('SELECT right(MinCosts.ID, 9), MinCosts.ProductId, MinCosts.RegionCode, if(PriceCode=2647, "", (99999900 ^ TRUNCATE((MinCost*100), 0))) FROM MinCosts',
               ' INTO OUTFILE ', '"results/MinPrices', ClientCodeParam, '.txt"',
                "FIELDS TERMINATED BY '", FieldsTerminated,
                "' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
                LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'MinPrices', 0);
set @a:=concat('SELECT CT.PriceCode, CT.regioncode, CT.ProductId, ifnull(Core.codefirmcr, 0), Core.synonymcode, ',
                'ifnull(Core.SynonymFirmCrCode, ""), Core.Code, ',
                'Core.CodeCr, Core.unit, Core.volume , Core.Junk, Core.Await, Core.quantity, Core.note, Core.period, Core.doc,',
                'ifnull(Core.RegistryCost, ""), Core.VitallyImportant, ifnull(Core.RequestRatio, ""), ',
                'CT.CryptCost, ',
                'right(CT.ID, 9), ifnull(OrderCost, ""), ifnull(MinOrderCount, "") from Core CT, ActivePrices AT, farm.core0 Core ',
                'where ct.pricecode=at.pricecode and ct.regioncode=at.regioncode ',
                'and Core.id=CT.id ',
                'and if(', Cumulative, ', 1, fresh) ',
                ' INTO OUTFILE ', '"results/core', ClientCodeParam, '.txt"',
                "FIELDS TERMINATED BY '", FieldsTerminated,
                "' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
                LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'core', 0);
drop temporary table if exists Core, MinCosts;
else
set @a:=concat('SELECT ""',
               ' INTO OUTFILE ', '"results/MinPrices', ClientCodeParam, '.txt"',
                "FIELDS TERMINATED BY '", FieldsTerminated,
                "' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY ''");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'MinPrices', 0);
set @a:=concat('SELECT "" ',
                ' INTO OUTFILE ', '"results/core', ClientCodeParam, '.txt"',
                "FIELDS TERMINATED BY '", FieldsTerminated,
                "' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY ''");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'core', 0);
end if;
else
call GetActivePrices(SClientCode);
call GetOffers(SClientCode, 0);
drop temporary table if exists CoreT,
        CoreTP                      ,
        CoreT2;
create temporary table CoreT(ProductId int unsigned, CodeFirmCr int unsigned, Cost decimal(8,2), CryptCost varchar(32),unique MultiK(ProductId, CodeFirmCr))engine=MEMORY;
create temporary table CoreT2(ProductId int unsigned, CodeFirmCr int unsigned, Cost decimal(8,2), CryptCost varchar(32),unique MultiK(ProductId, CodeFirmCr))engine=MEMORY;
create temporary table CoreTP(ProductId int unsigned, Cost decimal(8,2), CryptCost varchar(32), unique MultiK(ProductId))engine                                     =MEMORY;
insert
into    CoreT
        (
                ProductId ,
                CodeFirmCr,
                Cost
        )
select  core0.ProductId ,
        core0.codefirmcr,
        round(avg(cost), 2)
from    farm.core0,
        Core
where   core0.id=Core.id
group by ProductId,
        CodeFirmCr;
update CoreT
set     CryptCost = replace(replace(replace(replace(replace(aes_encrypt(Cost, CostsPasswordParam), char(37), '%25'), char(32), '%20'), char(159), '%9F'), char(161), '%A1'), char(0), '%00');
update CoreT
        set CryptCost=concat(left(CryptCost, 1), char(round((rand()*110)+32,0)), substring(CryptCost,2,length(CryptCost)-4), char(round((rand()*110)+32,0)), right(CryptCost, 3));
insert
into    CoreTP(ProductId, Cost)
select ProductId, round(avg(cost), 2)
from    CoreT
group by ProductId;
update CoreTP
set     CryptCost = replace(replace(replace(replace(replace(aes_encrypt(Cost, CostsPasswordParam), char(37), '%25'), char(32), '%20'), char(159), '%9F'), char(161), '%A1'), char(0), '%00');
update CoreTP
        set CryptCost=concat(left(CryptCost, 1), char(round((rand()*110)+32,0)), substring(CryptCost,2,length(CryptCost)-4), char(round((rand()*110)+32,0)), right(CryptCost, 3));
insert
into    CoreT2
select  *
from    CoreT;
set @a:=concat(
'SELECT  2647               ,',
        ClientRegionCode,    ',',
'        A.ProductId         ,',
'        A.CodeFirmCr        ,',
'        S.SynonymCode       ,',
'        SF.SynonymFirmCrCode,',
'        ""                  ,',
'        ""                  ,',
'        ""                  ,',
'        ""                  ,',
'        0                   ,',
'        0                   ,',
'        ""                  ,',
'        ""                  ,',
'        ""                  ,',
'        ""                  ,',
'        ""                  ,',
'        0                   ,',
'        ""                  ,',
' if(', SShowAvgCosts,', CryptCost, ""),',
'        @RowId := @RowId + 1,',
'        ""                  ,',
'        ""',
'FROM    farm.Synonym S       ,',
'        farm.SynonymFirmCr SF,',
'        CoreT A            ',
'WHERE   S.PriceCode   =2647',
'    AND SF.PriceCode  =2647',
'    AND S.ProductId   =A.ProductId',
'    AND SF.CodeFirmCr =A.CodeFirmCr',
'    AND A.CodeFirmCr is not null  ',
'',
'UNION  ',
'',
'SELECT  2647             ,',
        ClientRegionCode,',',
'        A.ProductId           ,',
'        1                    ,',
'        S.SynonymCode         ,',
'        0                     ,',
'        ""                    ,',
'        ""                    ,',
'        ""                    ,',
'        ""                    ,',
'        0                     ,',
'        0                     ,',
'        ""                    ,',
'        ""                    ,',
'        ""                    ,',
'        ""                    ,',
'        ""                    ,',
'        0                     ,',
'        ""                    ,',
' if(', SShowAvgCosts,', A.CryptCost, ""),',
'        @RowId := @RowId + 1  ,',
'        ""                    ,',
'        ""',
'FROM    farm.Synonym S ,       ',
'        CoreTP A ',
'WHERE   S.PriceCode          =2647 ',
'    AND S.ProductId          =A.ProductId',
' INTO OUTFILE ', '"results/core', ClientCodeParam, '.txt"',
                 "FIELDS TERMINATED BY '", FieldsTerminated,
                "' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
                LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
set @a:=concat(
'SELECT  0        , ',
'        ProductId, ',
         ClientRegionCode,', ',
'        "" ',
'FROM    CoreTP ',
               ' INTO OUTFILE ', '"results/MinPrices', ClientCodeParam, '.txt"',
                "FIELDS TERMINATED BY '", FieldsTerminated,
                "' OPTIONALLY ENCLOSED BY '' ESCAPED BY '' LINES TERMINATED BY '",
                LinesTerminated, "'");
prepare QueryTXT from @a;
execute QueryTXT;
insert into ready_client_files values(null, ClientCodeParam, 'MinPrices', 0);
insert into ready_client_files values(null, ClientCodeParam, 'core', 0);
end if;
drop temporary table if exists Core, ParentCodes, MaxCodesSynFirmCr, MinCosts, Prices, ActivePrices, tmpprd, MaxCodesSyn, CoreT, CoreTP, CoreT2;
end
/

