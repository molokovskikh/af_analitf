unit Server_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.130.1.0.1.0.1.6  $
// File generated on 7/23/02 6:06:49 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Projects\Delphi\MyDac\Demos\Midas\Server.tlb (1)
// LIBID: {07DB43ED-D8D6-4119-9861-2B7B79032B5F}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 Midas, (D:\WINNT\System32\midas.dll)
//   (2) v2.0 stdole, (D:\WINNT\System32\stdole2.tlb)
//   (3) v4.0 StdVCL, (D:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$IFDEF VER140}
{$WARN SYMBOL_PLATFORM OFF}
{$VARPROPSETTER ON}
{$ENDIF}
{$WRITEABLECONST ON}
interface

uses Windows, ActiveX, Classes, Graphics, Midas, StdVCL{$IFDEF VER140}, Variants{$ENDIF};


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ServerMajorVersion = 1;
  ServerMinorVersion = 0;

  LIBID_Server: TGUID = '{07DB43ED-D8D6-4119-9861-2B7B79032B5F}';

  IID_IDatas: TGUID = '{E79F2D5B-8F47-4CB6-B441-251950054002}';
  CLASS_Datas: TGUID = '{706739B2-FB40-49CC-9041-2B82CFFC520C}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDatas = interface;
  IDatasDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Datas = IDatas;


// *********************************************************************//
// Interface: IDatas
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E79F2D5B-8F47-4CB6-B441-251950054002}
// *********************************************************************//
  IDatas = interface(IAppServer)
    ['{E79F2D5B-8F47-4CB6-B441-251950054002}']
  end;

// *********************************************************************//
// DispIntf:  IDatasDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E79F2D5B-8F47-4CB6-B441-251950054002}
// *********************************************************************//
  IDatasDisp = dispinterface
    ['{E79F2D5B-8F47-4CB6-B441-251950054002}']
    function AS_ApplyUpdates(const ProviderName: WideString; Delta: OleVariant; MaxErrors: Integer; 
                             out ErrorCount: Integer; var OwnerData: OleVariant): OleVariant; dispid 20000000;
    function AS_GetRecords(const ProviderName: WideString; Count: Integer; out RecsOut: Integer; 
                           Options: Integer; const CommandText: WideString; var Params: OleVariant; 
                           var OwnerData: OleVariant): OleVariant; dispid 20000001;
    function AS_DataRequest(const ProviderName: WideString; Data: OleVariant): OleVariant; dispid 20000002;
    function AS_GetProviderNames: OleVariant; dispid 20000003;
    function AS_GetParams(const ProviderName: WideString; var OwnerData: OleVariant): OleVariant; dispid 20000004;
    function AS_RowRequest(const ProviderName: WideString; Row: OleVariant; RequestType: Integer; 
                           var OwnerData: OleVariant): OleVariant; dispid 20000005;
    procedure AS_Execute(const ProviderName: WideString; const CommandText: WideString; 
                         var Params: OleVariant; var OwnerData: OleVariant); dispid 20000006;
  end;

// *********************************************************************//
// The Class CoDatas provides a Create and CreateRemote method to          
// create instances of the default interface IDatas exposed by              
// the CoClass Datas. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDatas = class
    class function Create: IDatas;
    class function CreateRemote(const MachineName: string): IDatas;
  end;

implementation

uses ComObj;

class function CoDatas.Create: IDatas;
begin
  Result := CreateComObject(CLASS_Datas) as IDatas;
end;

class function CoDatas.CreateRemote(const MachineName: string): IDatas;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Datas) as IDatas;
end;

end.
