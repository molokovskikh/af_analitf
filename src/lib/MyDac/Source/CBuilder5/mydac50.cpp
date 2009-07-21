
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyDAC Package for C++ Builder 5
//////////////////////////////////////////////////

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEUNIT("..\MyCall.pas");              
USEUNIT("..\MyClasses.pas");           
USEUNIT("..\MyAccess.pas");            
USEUNIT("..\MyConsts.pas");            
USEUNIT("..\MyConnectForm.pas");       
USEUNIT("..\MyParser.pas");            
USEUNIT("..\MyScript.pas");            
USEUNIT("..\MyLoader.pas");            
USEUNIT("..\MyServerControl.pas");     
USEUNIT("..\MyDump.pas");              
USEUNIT("..\MyBackup.pas");            
USEUNIT("..\MyDacVcl.pas");            
USEUNIT("..\MyBuilderClient.pas");     
USEUNIT("..\MyDacMonitor.pas");        
USEUNIT("..\MyEmbConnection.pas"); 
USERES("mydac50.res");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("vclbde50.bpi");
USEPACKAGE("dac50.bpi");
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
