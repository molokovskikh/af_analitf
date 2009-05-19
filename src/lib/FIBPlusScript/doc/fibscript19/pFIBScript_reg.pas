{*************************************************}
{                                                 }
{             FIBPlus Script, version 1.9         }
{                                                 }
{     Copyright by Nikolay Trifonov, 2003-2007    }
{                                                 }
{           E-mail: t_nick@mail.ru                }
{                                                 }
{*************************************************}

unit pFIBScript_reg;

interface

uses Classes;

procedure Register;

implementation

uses pFIBScript, pFIBExtract;

{$R fibscript.dcr}

procedure Register;
begin
  RegisterComponents('FIBPlusScript', [TpFIBScript,TpFIBExtract]);
end;

end.
