
alter table analitf.currentorderlists
  add key `IDX_CurrentOrderLists_ServerOrderListId` (`ServerOrderListId`);

alter table analitf.postedorderlists
  add key `IDX_PostedOrderLists_ServerOrderListId` (`ServerOrderListId`);

drop temporary table if exists analitf.clientavg;

create table analitf.clientavg
(
    `ClientCode` bigint(20) default null                 , 
    `ProductId` bigint(20) default null                  , 
    `PriceAvg` decimal(18,2) default null     , 
    `OrderCountAvg` decimal(18,2) default null, 
    key `IDX_clientavg_ClientCode` (`ClientCode`)        , 
    key `IDX_clientavg_ProductId` (`ProductId`)            
) ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

update analitf.params set ProviderMDBVersion = 94 where id = 0;