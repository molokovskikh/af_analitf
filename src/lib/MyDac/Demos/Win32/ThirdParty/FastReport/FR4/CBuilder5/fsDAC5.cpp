//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("FS5.res");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("dac50.bpi");
USEPACKAGE("fs5.bpi");
USEPACKAGE("fsDB5.bpi");
USEUNIT("..\fs_idacrtti.pas");
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
