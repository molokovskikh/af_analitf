
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyDAC Package for C++ Builder 5
//  Created:            13.03.00
//////////////////////////////////////////////////

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEPACKAGE("dcldb50.bpi");
USEUNIT("..\Design\MyDacReg.pas");
USEUNIT("..\Design\MyDesign.pas");
USERES("dclmydac50.res");
USEPACKAGE("mydac50.bpi");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("vclbde50.bpi");
USEPACKAGE("dcldac50.bpi");
USEPACKAGE("vcljpg50.bpi");
USEUNIT("..\Design\MyMenu.pas");
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
