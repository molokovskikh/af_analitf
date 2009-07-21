
{******************************************}
{                                          }
{             FastScript v1.9              }
{         MyDAC Registration unit          }
{                                          }
{          Created by: Devart              }
{         E-mail: mydac@devart.com         }
{                                          }
{******************************************}

unit fs_imydacreg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  Classes
{$IFNDEF Delphi6}
, DsgnIntf
{$ELSE}
, DesignIntf
{$ENDIF}
, fs_imydacrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents('FastScript', [TfsMYDACRTTI]);
end;

end.
