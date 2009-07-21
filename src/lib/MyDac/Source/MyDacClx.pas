
{$I MyDac.inc}

unit MyDacClx;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Registry,
{$ENDIF}
  SysUtils, Classes, DacClx, DB, MemUtils, DAConsts, DBAccess, MyAccess, MyConnectForm;

{$I MyDacGui.inc}

