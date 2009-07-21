//////////////////////////////////////////////////
//  FastReport v2.7 - MyDAC components
//  Copyright (c) 2004 Devart. All right reserved.
//  Table component
//  Created:
//  Last modified:
//////////////////////////////////////////////////

unit FR_MyDACreg;

interface

{$I FR.inc}

procedure Register;

implementation

uses
  Windows, Messages, Classes, SysUtils, Graphics
{$IFNDEF Delphi6}
, DsgnIntf
{$ELSE}
, DesignIntf, DesignEditors
{$ENDIF}
,FR_MyDACDB;

procedure Register;
begin
  RegisterComponents('FastReport', [TfrMyDACComponents]);
end;

end.
