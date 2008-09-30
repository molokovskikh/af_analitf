ALTER TABLE PARAMS ADD PRINTORDERSAFTERSEND FB_BOOLEAN DEFAULT 0;

update PROVIDER set mdbversion = 47 where id = 0;

commit work;