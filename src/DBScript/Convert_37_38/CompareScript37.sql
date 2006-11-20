SET AUTODDL ON;

/* Alter Field (Null / Not Null)... */
UPDATE RDB$RELATION_FIELDS SET RDB$NULL_FLAG = NULL WHERE RDB$FIELD_NAME='PRICE' AND RDB$RELATION_NAME='ORDERS';

COMMIT;

update orders set price = null where orderid in (select oh.orderid from ordersh oh where oh.closed = 1);

update PROVIDER set mdbversion = 38 where id = 0;
