//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("CRControls50.res");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("Vcldb50.bpi");
USEUNIT("..\CRControlsReg.pas");
USEPACKAGE("dac50.bpi");
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
