
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright � 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

// Type of build

{$I Dac.inc}

{$I '..\..\..\AF.inc'}

{$DEFINE HAVE_DIRECT}

{$IFNDEF LITE}
  {$DEFINE HAVE_OPENSSL}
{$ENDIF}

{$DEFINE _TRIAL}       // TRIAL

{$DEFINE _DEBUG}       // DEBUG
{$DEFINE _MYBUILDER}   // DEBUG

{$IFDEF MSWINDOWS}
  {$DEFINE MYBUILDER}
{$ENDIF}

{$IFDEF WIN32}
{$IFNDEF FPC}
  {//$DEFINE EMBLOG}
{$ENDIF}
{$ENDIF}
