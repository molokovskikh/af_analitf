//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("CRControls60.res");
USEPACKAGE("vcl60.bpi");
USEPACKAGE("Vcldb60.bpi");
USEUNIT("..\CRControlsReg.pas");
USEPACKAGE("dac60.bpi");
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
