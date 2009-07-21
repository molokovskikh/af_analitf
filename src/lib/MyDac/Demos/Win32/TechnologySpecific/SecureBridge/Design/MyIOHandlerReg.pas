unit MyIOHandlerReg;

{$I SB.inc}

interface

uses
  Classes, MySSHIOHandler, MySSLIOHandler;

procedure Register;

implementation

{$R MyIOHandlerDesign.res}
(*
{$IFNDEF CLR}
  {$IFDEF VER9}
    {$R MyIOHandlerDesign9.res}
  {$ELSE}
    {$R MyIOHandlerDesign.res}
  {$ENDIF}
  {$IFDEF VER10P}
    {$R MyIOHandlerDesign10p.res}
  {$ENDIF}
{$ELSE}
  {$R MyIOHandlerDesign.res}
  {$IFDEF VER10P}
    {$R ..\Images\TMySSHIOHandler.bmp}
    {$R ..\Images\TMySSHIOHandler16.bmp}
    {$R ..\Images\TMySSHIOHandler32.bmp}
    {$R ..\Images\TMySSLIOHandler.bmp}
    {$R ..\Images\TMySSLIOHandler16.bmp}
    {$R ..\Images\TMySSLIOHandler32.bmp}
  {$ELSE}
    {$R ..\Images\TMySSHIOHandler16.bmp}
    {$R ..\Images\TMySSLIOHandler16.bmp}
  {$ENDIF}
{$ENDIF}
*)

procedure Register;
begin
  RegisterComponents('MySQL Access', [TMySSHIOHandler]);
  RegisterComponents('MySQL Access', [TMySSLIOHandler]);
end;

end.

