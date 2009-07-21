
{******************************************}
{                                          }
{             FastReport v4.0              }
{       MYDAC components registration      }
{                                          }

// Created by: Devart
// E-mail: mydac@devart.com

{                                          }
{******************************************}

unit frxMYDACReg;

interface

{$I frx.inc}

procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Classes
{$IFNDEF Delphi6}
, DsgnIntf
{$ELSE}
, DesignIntf, DesignEditors
{$ENDIF}
, frxMYDACComponents;

procedure Register;
begin
  RegisterComponents('FastReport 4.0', [TfrxMYDACComponents]);
end;

end.
