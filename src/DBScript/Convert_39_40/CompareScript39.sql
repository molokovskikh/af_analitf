SET AUTODDL ON;

/* Alter Field (Null / Not Null)... */
UPDATE RDB$RELATION_FIELDS SET RDB$NULL_FLAG = NULL WHERE RDB$FIELD_NAME='ID' AND RDB$RELATION_NAME='RETAILMARGINS';

update PROVIDER set mdbversion = 40 where id = 0;