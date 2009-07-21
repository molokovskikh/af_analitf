//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("mydacsbridge50.res");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("dac50.bpi");
USEPACKAGE("mydac50.bpi");
USEPACKAGE("sbridge50.bpi");
USEUNIT("..\Design\MyIOHandlerReg.pas");
USEUNIT("..\Design\MyIOHandlerDesign.pas");

//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
