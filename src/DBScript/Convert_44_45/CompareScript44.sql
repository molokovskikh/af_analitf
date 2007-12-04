/* Create Procedure... */
CREATE PROCEDURE PRODUCTS_IU(PRODUCTID BIGINT,
CATALOGID BIGINT)
 AS
 BEGIN EXIT; END
;


/* Alter Procedure... */
/* Restore proc. body: PRODUCTS_IU */
ALTER PROCEDURE PRODUCTS_IU(PRODUCTID BIGINT,
CATALOGID BIGINT)
 AS
begin
  if (exists(select productid from products where (productid = :productid))) then
    update products
    set catalogid = :catalogid
    where (productid = :productid);
  else
    insert into products (
        productid,
        catalogid)
    values (
        :productid,
        :catalogid);
end
;

/* Alter Procedure... */

update PROVIDER set mdbversion = 45 where id = 0;

commit work;