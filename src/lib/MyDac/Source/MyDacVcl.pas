{$IFNDEF CLR}

{$I MyDac.inc}

unit MyDacVcl;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Registry,
{$ENDIF}
  SysUtils, Classes, DB, MemUtils, DAConsts, DacVcl, DBAccess, MyAccess,
  MyConnectForm;

{$I MyDacGui.inc}

