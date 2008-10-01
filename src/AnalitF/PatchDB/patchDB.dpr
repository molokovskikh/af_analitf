program patchDB;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows, FIB, FIBDatabase, pFIBDatabase, pFIBQuery;

const
  AlterSQLs : array[0..21] of string =
  ('DROP INDEX IDX_PRICECODE',
   'ALTER TABLE SYNONYMS DROP CONSTRAINT FK_SYNONYMS_FULLCODE',
   'ALTER TABLE SYNONYMS DROP CONSTRAINT PK_SYNONYMS',
   'ALTER TABLE SYNONYMS ADD CONSTRAINT PK_SYNONYMS PRIMARY KEY (SYNONYMCODE)',
   'ALTER TABLE SYNONYMS ADD CONSTRAINT FK_SYNONYMS_FULLCODE FOREIGN KEY (FULLCODE) REFERENCES CATALOGS (FULLCODE) ON DELETE CASCADE ON UPDATE CASCADE',
   'CREATE INDEX IDX_PRICECODE ON SYNONYMS (PRICECODE)',
   'alter table core DROP CONSTRAINT FK_CORE_FULLCODE',
   'alter table core DROP CONSTRAINT FK_CORE_PRICECODE',
   'alter table core DROP CONSTRAINT FK_CORE_REGIONCODE',
   'alter table core DROP CONSTRAINT PK_CORE',
   'drop index FK_CORE_SYNONYMCODE',
   'drop index FK_CORE_SYNONYMFIRMCRCODE',
   'drop index IDX_CORE_SERVERCOREID',
   'drop index IDX_CORE_JUNK',
   'ALTER TABLE CORE ADD CONSTRAINT PK_CORE PRIMARY KEY (COREID)',
   'ALTER TABLE CORE ADD CONSTRAINT FK_CORE_FULLCODE FOREIGN KEY (FULLCODE) REFERENCES CATALOGS (FULLCODE) ON DELETE CASCADE ON UPDATE CASCADE',
   'ALTER TABLE CORE ADD CONSTRAINT FK_CORE_PRICECODE FOREIGN KEY (PRICECODE) REFERENCES PRICESDATA (PRICECODE) ON DELETE CASCADE ON UPDATE CASCADE',
   'ALTER TABLE CORE ADD CONSTRAINT FK_CORE_REGIONCODE FOREIGN KEY (REGIONCODE) REFERENCES REGIONS (REGIONCODE) ON UPDATE CASCADE',
	 'CREATE INDEX IDX_CORE_JUNK ON CORE (FULLCODE, JUNK)',
	 'CREATE INDEX IDX_CORE_SERVERCOREID ON CORE (SERVERCOREID)',
	 'CREATE INDEX FK_CORE_SYNONYMCODE ON CORE (SYNONYMCODE)',
	 'CREATE INDEX FK_CORE_SYNONYMFIRMCRCODE ON CORE (SYNONYMFIRMCRCODE)'
   );

var
  db : TpFIBDatabase;
  tr : TpFIBTransaction;
  q : TpFIBQuery;
  I : Integer;

begin
  try
    db := TpFIBDatabase.Create(nil);
    db.DBName := ExtractFilePath(ParamStr(0)) + 'AnalitF.fdb';
    db.LibraryName := 'fbclient.dll';
    db.ConnectParams.UserName := 'sysdba';
    db.ConnectParams.Password := 'masterkey';
    db.ConnectParams.CharSet := 'WIN1251';
    db.SQLDialect := 3;
    tr := TpFIBTransaction.Create(nil);
    tr.DefaultDatabase := db;
    db.DefaultUpdateTransaction := tr;
    tr.TimeoutAction := TACommit;
    q := TpFIBQuery.Create(nil);
    q.Database := db;
    db.Open;
    q.Transaction := tr;
    tr.StartTransaction;
    try
{
      for I := Low(AlterSQLs) to High(AlterSQLs) do
        try
          q.SQL.Text := AlterSQLs[i];
          q.ExecQuery;
          Write('.');
        except
          on E : EFIBInterBaseError do begin
            if e.SQLCode <> -607 then
              raise;
          end;
        end;
}

      //2006-09-08 09:17:11
      q.SQL.Text := 'update params set UpdateDateTime = cast(''2006.09.08 05:17:11'' as timestamp), LastDateTime = cast(''2006.09.08 05:17:11'' as timestamp) where ID = 0';
      q.ExecQuery;
      WriteLn;
      tr.Commit;
    except
      try tr.Rollback except end;
      raise;
    end;
//    MessageBox(0, 'Обновление завершено успешно.', 'Обновление', MB_ICONINFORMATION);
//    WriteLn('Обновление завершено успешно.');
    WriteLn('ЋЎ­®ў«Ґ­ЁҐ § ўҐаиҐ­® гбЇҐи­®.');
  except
    on E : Exception do begin
//      MessageBox(0, PChar('Обновление завершилось с ошибкой: ' + E.Message), 'Обновление', MB_ICONINFORMATION);
//      WriteLn('Обновление завершилось с ошибкой: ' + E.Message);
      WriteLn('ЋЎ­®ў«Ґ­ЁҐ § ўҐаиЁ«®бм б ®иЁЎЄ®©: ' + E.Message);
    end;
  end;
//  WriteLn('Для выхода нажмите Enter...');
  WriteLn('„«п ўле®¤  ­ ¦¬ЁвҐ Enter...');
  ReadLn;
end.
