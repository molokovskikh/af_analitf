
{$IFNDEF CLR}

{$I Dac.inc}

unit DBMonitorIntf;
{$ENDIF}
interface

{$IFDEF CLR}
uses
  Windows, System.Runtime.InteropServices;
{$ENDIF}

{$IFNDEF CLR}
const
// IID_IDBMonitor must be changed if any interface changes are performed
  IID_IDBMonitor: TGUID = '{89F49E64-F6E0-11D6-9038-00C02631BDC7}';
{$ENDIF}

const
  Class_DBMonitor: TGUID = '{89F49E65-F6E0-11D6-9038-00C02631BDC7}';

type
  TEventType = (etAppStarted, etAppFinished, etConnect, etDisconnect, etCommit,
    etRollback, etPrepare, etUnprepare, etExecute, etBlob, etError, etMisc);

  TTracePoint = (tpBeforeEvent, tpAfterEvent);

{$IFDEF CLR}
  [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
  TSQLParam = record
    [MarshalAs(UnmanagedType.LPStr)]
    Name: string;
    [MarshalAs(UnmanagedType.LPStr)]
    DataType: string;
    [MarshalAs(UnmanagedType.LPStr)]
    ParamType: string;
    [MarshalAs(UnmanagedType.LPStr)]
    Value: string;
  end;
  TSQLParams = array of TSQLParam;

  [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
  TMonitorMessage = record
    MessageID: cardinal;
    EventType: integer;
    TracePoint: integer;
    ObjectID: cardinal;
    OwnerID: cardinal;
    [MarshalAs(UnmanagedType.LPStr)]
    ObjectName: string;
    [MarshalAs(UnmanagedType.LPStr)]
    OwnerName: string;
    [MarshalAs(UnmanagedType.LPStr)]
    Description: string;
  end;

  [ComImport, GuidAttribute('89F49E64-F6E0-11D6-9038-00C02631BDC7'), InterfaceTypeAttribute(ComInterfaceType.InterfaceIsIUnknown)]
//  [Guid('89F49E64-F6E0-11D6-9038-00C02631BDC7'), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
  IDBMonitor = interface
    [PreserveSig]
    function GetVersion([Out, MarshalAs(UnmanagedType.LPStr)] out Version: string): HRESULT;
    [PreserveSig]
    function SetCaption([In, MarshalAs(UnmanagedType.LPStr)] Caption: string): HRESULT;
    [PreserveSig]
    function IsMonitorActive(out Active: integer): HRESULT;
    [PreserveSig]
    function OnEvent(var Msg: TMonitorMessage; [In, MarshalAs(UnmanagedType.LPStr)] ParamStr: string): HRESULT;
    [PreserveSig]
    function OnExecute(var Msg: TMonitorMessage; [In, MarshalAs(UnmanagedType.LPStr)] SQL: string;
      [In, MarshalAs(UnmanagedType.LPArray, ArraySubType = UnmanagedType.Struct)] Params: array of TSQLParam;
      ParamCount: integer; RowsAffected: integer): HRESULT; 
  end;

//TODO
//[ComImport, Guid('89F49E65-F6E0-11D6-9038-00C02631BDC7')]
  DbMonitorClass = class
  end;
{$ELSE}
  TSQLParam = record
    Name: AnsiString;
    DataType: AnsiString;
    ParamType: AnsiString;
    Value: AnsiString;
  end;
  TSQLParams = array of TSQLParam;

  PSQLParam = ^TSQLParam;

  TMonitorMessage = record
    MessageID: cardinal;
    EventType: integer;
    TracePoint: integer;
    ObjectID: cardinal;
    OwnerID: cardinal;
    ObjectName: PAnsiChar;
    OwnerName: PAnsiChar;
    Description: PAnsiChar;
  end;

  IDBMonitor = interface(IUnknown)
  ['{89F49E64-F6E0-11D6-9038-00C02631BDC7}']
    function GetVersion(out pVersion: PAnsiChar): HRESULT; stdcall;
    function SetCaption(Caption: PAnsiChar): HRESULT; stdcall;
    function IsMonitorActive(out Active: integer): HRESULT; stdcall;
    function OnEvent(var Msg: TMonitorMessage; ParamStr: PAnsiChar): HRESULT; stdcall;
    function OnExecute(var Msg: TMonitorMessage; SQL: PAnsiChar; Params: PSQLParam;
      ParamCount: integer; RowsAffected: integer): HRESULT; stdcall;
  end;
{$ENDIF}

implementation

end.


