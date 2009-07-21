
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}
{$IFNDEF UNIDACPRO}
{$I MyDac.inc}
unit MySqlType;
{$ENDIF}
{$ENDIF}

interface

type
  TMySqlType = (
    mtBigInt,
    mtBlob,
    mtChar,
    mtDate,
    mtDateTime,
//    mtDecimal,
    mtDouble,
    mtFloat,
    mtInt,
    mtSmallInt,
    mtText,
    mtTime,
//    mtTimeStamp,
    mtTinyInt,
    mtVarChar,
    mtYear
  );

implementation

end.
