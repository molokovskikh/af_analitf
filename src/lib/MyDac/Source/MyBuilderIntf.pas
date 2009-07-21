{$IFNDEF CLR}

{$I MyDac.inc}

unit MyBuilderIntf;
{$ENDIF}
interface

{$IFDEF MSWINDOWS}

{$IFDEF CLR}
uses
  Windows, System.Runtime.InteropServices;
{$ELSE}
uses
  Windows;
{$ENDIF}

const
{$IFNDEF CLR}
// IID_IMybuilder must be changed if any interface changes are performed
  IID_IMyBuilder: TGUID = '{B00192F8-2D46-4091-8D48-648F8F02F145}';
{$ENDIF}

{$IFDEF MYSQLDIRECT}
  Class_MyBuilder: TGUID = '{D7E38829-F6D7-11D6-9038-00C02631BDC7}';
{$ELSE}
  Class_MyBuilder: TGUID = '{0A0CF116-AF57-11D6-8FDE-00C02631BDC7}';
{$ENDIF}

type
{$IFDEF CLR}
  PAnsiChar = string;

  [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
  TConnection = packed record
    [MarshalAs(UnmanagedType.LPStr)]
    Username: PAnsiChar;
    [MarshalAs(UnmanagedType.LPStr)]
    Password: PAnsiChar;
    [MarshalAs(UnmanagedType.LPStr)]
    Server: PAnsiChar;
    [MarshalAs(UnmanagedType.LPStr)]
    Database: PAnsiChar;
    ConnectionTimeout: integer;
    Port: integer;
    Connected: integer;
    Direct: integer;
    Protocol: integer;
  end;

  [ComImport, GuidAttribute('B00192F8-2D46-4091-8D48-648F8F02F145'), InterfaceTypeAttribute(ComInterfaceType.InterfaceIsIUnknown)]
  IMyBuilder = interface
    [PreserveSig]
    function GetVersion([Out, MarshalAs(UnmanagedType.LPStr)]out pVersion: PAnsiChar): HRESULT; 
    [PreserveSig]
    function SetOwner(Window: HWND): HRESULT; 
    [PreserveSig]
    function SetParent(Window: HWND): HRESULT; 
    [PreserveSig]
    function SetBounds(Top, Left, Width, Height: integer): HRESULT; 
    [PreserveSig]
    function SetConnection(Connection: TConnection): HRESULT; 
    [PreserveSig]
    function RemoveConnection: HRESULT; 
    [PreserveSig]
    function Show: HRESULT; 
    [PreserveSig]
    function ShowModal(out ModalResult: integer): HRESULT; 
    [PreserveSig]
    function GetModified(out Modified: integer): HRESULT; 
    [PreserveSig]
    function SetSQL([In, MarshalAs(UnmanagedType.LPStr)]SQL: PAnsiChar): HRESULT; 
    [PreserveSig]
    function GetSQL([Out, MarshalAs(UnmanagedType.LPStr)] out SQL: PAnsiChar): HRESULT; 
  end;
{$ELSE}
  TConnection = packed record
    Username: PAnsiChar;
    Password: PAnsiChar;
    Server: PAnsiChar;
    Database: PAnsiChar;
    ConnectionTimeout: integer;
    Port: integer;
    Connected: integer;
    Direct: integer;
    Protocol: integer;
  end;

  IMyBuilder = interface(IUnknown)
  ['{B00192F8-2D46-4091-8D48-648F8F02F145}']
    function GetVersion(out pVersion: PAnsiChar): HRESULT; stdcall;
    function SetOwner(Window: HWND): HRESULT; stdcall;
    function SetParent(Window: HWND): HRESULT; stdcall;
    function SetBounds(Top, Left, Width, Height: integer): HRESULT; stdcall;
    function SetConnection(Connection: TConnection): HRESULT; stdcall;
    function RemoveConnection: HRESULT; stdcall;
    function Show: HRESULT; stdcall;
    function ShowModal(out ModalResult: integer): HRESULT; stdcall;
    function GetModified(out Modified: integer): HRESULT; stdcall;
    function SetSQL(SQL: PAnsiChar): HRESULT; stdcall;
    function GetSQL(out SQL: PAnsiChar): HRESULT; stdcall;
  end;
{$ENDIF}

{$ENDIF}

implementation

end.
