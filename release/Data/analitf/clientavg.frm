TYPE=VIEW
query=select `analitf`.`ordershead`.`CLIENTID` AS `CLIENTCODE`,`analitf`.`orderslist`.`PRODUCTID` AS `PRODUCTID`,avg(`analitf`.`orderslist`.`PRICE`) AS `PRICEAVG` from (`analitf`.`ordershead` join `analitf`.`orderslist`) where ((`analitf`.`orderslist`.`ORDERID` = `analitf`.`ordershead`.`ORDERID`) and (`analitf`.`ordershead`.`ORDERDATE` >= (curdate() - interval 1 month)) and (`analitf`.`ordershead`.`CLOSED` = 1) and (`analitf`.`ordershead`.`SEND` = 1) and (`analitf`.`orderslist`.`ORDERCOUNT` > 0) and (`analitf`.`orderslist`.`PRICE` is not null)) group by `analitf`.`ordershead`.`CLIENTID`,`analitf`.`orderslist`.`PRODUCTID`
md5=5ef8269475e26b2d5d31f0fe352fa51b
updatable=0
algorithm=0
definer_user=root
definer_host=localhost
suid=1
with_check_option=0
timestamp=2009-04-09 12:04:29
create-version=1
source=SELECT   `analitf`.`ordershead`.`CLIENTID`      AS `CLIENTCODE`,\n	         `analitf`.`orderslist`.`PRODUCTID`      AS `PRODUCTID` ,\n	         AVG(`analitf`.`orderslist`.`PRICE`) AS `PRICEAVG`\n	FROM     `analitf`.`ordershead`\n	         JOIN `analitf`.`orderslist`\n	WHERE ((`analitf`.`orderslist`.`ORDERID` = `analitf`.`ordershead`.`ORDERID`) AND (`analitf`.`ordershead`.`ORDERDATE` >= (curdate() - interval 1 MONTH)) AND (`analitf`.`ordershead`.`CLOSED` = 1) AND (`analitf`.`ordershead`.`SEND` = 1) AND (`analitf`.`orderslist`.`ORDERCOUNT` > 0) AND (`analitf`.`orderslist`.`PRICE` IS NOT NULL))\n	GROUP BY `analitf`.`ordershead`.`CLIENTID`,\n	         `analitf`.`orderslist`.`PRODUCTID`
client_cs_name=utf8
connection_cl_name=utf8_general_ci
view_body_utf8=select `analitf`.`ordershead`.`CLIENTID` AS `CLIENTCODE`,`analitf`.`orderslist`.`PRODUCTID` AS `PRODUCTID`,avg(`analitf`.`orderslist`.`PRICE`) AS `PRICEAVG` from (`analitf`.`ordershead` join `analitf`.`orderslist`) where ((`analitf`.`orderslist`.`ORDERID` = `analitf`.`ordershead`.`ORDERID`) and (`analitf`.`ordershead`.`ORDERDATE` >= (curdate() - interval 1 month)) and (`analitf`.`ordershead`.`CLOSED` = 1) and (`analitf`.`ordershead`.`SEND` = 1) and (`analitf`.`orderslist`.`ORDERCOUNT` > 0) and (`analitf`.`orderslist`.`PRICE` is not null)) group by `analitf`.`ordershead`.`CLIENTID`,`analitf`.`orderslist`.`PRODUCTID`
