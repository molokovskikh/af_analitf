
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyDAC registration
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MySQLMonReg;
{$ENDIF}

interface

procedure Register;

implementation

uses     
  Classes, MySQLMonitor,
{$IFDEF MSWINDOWS}
  {$IFNDEF STD}MyBuilderClient, {$ENDIF}MyDacVcl;
{$ENDIF}
{$IFDEF LINUX}
  MyDacClx;
{$ENDIF}

// {$R MyDesign.res}
// {$IFDEF VER10P}
//   {$R MyDesign10P.res}
// {$ENDIF}

procedure Register;
begin
  RegisterComponents('MySQL Access', [TMySQLMonitor]);
end;

end.

