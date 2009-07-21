
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyDAC Package for C++ Builder 5
//////////////////////////////////////////////////

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEUNIT("..\MySQLMonitor.pas");        
USERES("mysqlmon50.res");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("vclbde50.bpi");
USEPACKAGE("dac50.bpi");
USEPACKAGE("mydac50.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
    return 1;
}
//---------------------------------------------------------------------------
