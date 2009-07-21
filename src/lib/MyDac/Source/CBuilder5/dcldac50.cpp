//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("dcldac50.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("..\Design\DacReg.pas");
USEUNIT("..\Design\DAMenu.pas");
USEUNIT("..\Design\Download.pas");
USEPACKAGE("dac50.bpi");
USEPACKAGE("Vcldb50.bpi");
USEPACKAGE("vclbde50.bpi");
USEUNIT("..\Design\DADesign.pas");
USEUNIT("..\Design\VTDesign.pas");
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
