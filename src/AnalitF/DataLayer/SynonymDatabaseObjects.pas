unit SynonymDatabaseObjects;

interface

uses
  SysUtils, Classes, Contnrs, StrUtils,
  DatabaseObjects;

type
  TSynonymsTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

  TSynonymFirmCrTable = class(TDatabaseTable)
   public
    constructor Create();
    function GetCreateSQL(DatabasePrefix : String = '') : String; override;
  end;

implementation

{ TSynonymsTable }

constructor TSynonymsTable.Create;
begin
  FName := 'synonyms';
  FObjectId := doiSynonyms;
  FRepairType := dortGetPrice;
end;

function TSynonymsTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `SYNONYMCODE` bigint(20) not null       , ' 
+'    `SYNONYMNAME` varchar(250) default null , ' 
+'    primary key (`SYNONYMCODE`)             , ' 
+'    unique key `PK_SYNONYMS` (`SYNONYMCODE`), ' 
+'    FULLTEXT key `IDX_SYNONYMNAME` (`SYNONYMNAME`) ' 
+'  ) ' 
+'  ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;';
end;

{ TSynonymFirmCrTable }

constructor TSynonymFirmCrTable.Create;
begin
  FName := 'synonymfirmcr';
  FObjectId := doiSynonymFirmCr;
  FRepairType := dortGetPrice;
end;

function TSynonymFirmCrTable.GetCreateSQL(DatabasePrefix: String): String;
begin
  Result := inherited GetCreateSQL(DatabasePrefix)
+'  ( ' 
+'    `SYNONYMFIRMCRCODE` bigint(20) not null, ' 
+'    `SYNONYMNAME` varchar(250) default null, ' 
+'    primary key (`SYNONYMFIRMCRCODE`)      , ' 
+'    unique key `PK_SYNONYMFIRMCR` (`SYNONYMFIRMCRCODE`) ' 
+'  ) ' 
+'  ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;';
end;

initialization
  DatabaseController.AddObject(TSynonymsTable.Create());
  DatabaseController.AddObject(TSynonymFirmCrTable.Create());
end.
