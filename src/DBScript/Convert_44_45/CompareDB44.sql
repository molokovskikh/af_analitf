SET NAMES WIN1251;

SET SQL DIALECT 3;

CONNECT 'localhost:C:\Work\Analit\VSS\Inforoom\Delphi\AnalitF R 4.2.151.470\src\bin\ANALITF.FDB' USER 'SYSDBA' PASSWORD 'masterkey';

SET AUTODDL ON;

/* Create Procedure... */
SET TERM ^ ;

CREATE PROCEDURE PRODUCTS_IU(PRODUCTID BIGINT,
CATALOGID BIGINT)
 AS
 BEGIN EXIT; END
^


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
^

/* Alter Procedure... */
