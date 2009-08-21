TYPE=VIEW
query=select `analitf`.`ordershead`.`CLIENTID` AS `CLIENTCODE`,`analitf`.`orderslist`.`PRODUCTID` AS `PRODUCTID`,avg(`analitf`.`orderslist`.`PRICE`) AS `PRICEAVG` from (`analitf`.`ordershead` join `analitf`.`orderslist`) where ((`analitf`.`orderslist`.`ORDERID` = `analitf`.`ordershead`.`ORDERID`) and (`analitf`.`ordershead`.`ORDERDATE` >= (curdate() - interval 1 month)) and (`analitf`.`ordershead`.`CLOSED` = 1) and (`analitf`.`ordershead`.`SEND` = 1) and (`analitf`.`orderslist`.`ORDERCOUNT` > 0) and (`analitf`.`orderslist`.`PRICE` is not null)) group by `analitf`.`ordershead`.`CLIENTID`,`analitf`.`orderslist`.`PRODUCTID`
md5=5ef8269475e26b2d5d31f0fe352fa51b
updatable=0
algorithm=0
definer_user=root
definer_host=localhost
suid=1
with_check_option=0
timestamp=2009-07-29 10:04:24
create-version=1
source=select `ordershead`.`CLIENTID` AS `CLIENTCODE`,`orderslist`.`PRODUCTID` AS `PRODUCTID`,avg(`orderslist`.`PRICE`) AS `PRICEAVG` from (`ordershead` join `orderslist`) where ((`orderslist`.`ORDERID` = `ordershead`.`ORDERID`) and (`ordershead`.`ORDERDATE` >= (curdate() - interval 1 month)) and (`ordershead`.`CLOSED` = 1) and (`ordershead`.`SEND` = 1) and (`orderslist`.`ORDERCOUNT` > 0) and (`orderslist`.`PRICE` is not null)) group by `ordershead`.`CLIENTID`,`orderslist`.`PRODUCTID`
client_cs_name=cp1251
connection_cl_name=cp1251_general_ci
view_body_utf8=select `analitf`.`ordershead`.`CLIENTID` AS `CLIENTCODE`,`analitf`.`orderslist`.`PRODUCTID` AS `PRODUCTID`,avg(`analitf`.`orderslist`.`PRICE`) AS `PRICEAVG` from (`analitf`.`ordershead` join `analitf`.`orderslist`) where ((`analitf`.`orderslist`.`ORDERID` = `analitf`.`ordershead`.`ORDERID`) and (`analitf`.`ordershead`.`ORDERDATE` >= (curdate() - interval 1 month)) and (`analitf`.`ordershead`.`CLOSED` = 1) and (`analitf`.`ordershead`.`SEND` = 1) and (`analitf`.`orderslist`.`ORDERCOUNT` > 0) and (`analitf`.`orderslist`.`PRICE` is not null)) group by `analitf`.`ordershead`.`CLIENTID`,`analitf`.`orderslist`.`PRODUCTID`
