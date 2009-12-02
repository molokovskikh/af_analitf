unit FakeDll;
interface
uses Windows;

type
  // DWord = Cardinal;

  TFakeDll = class(TObject)
  constructor Create;
  destructor  Destroy; override;
  protected
    FDSelfHandle :HINST;
    DoErrors     :LongBool;
  public
    property  FDHandle   :HINST read FDSelfHandle write FDSelfHandle;
    property  ShowErrors :LongBool read DoErrors write DoErrors;
    procedure InjectDll(MemoryFile :Pointer; FreeOld :LongBool);
    function  GetFDProcAddress(ProcName :PChar) :Pointer;
  private
    MinVer, MajVer :DWord;
    Copyright      :PChar;
    procedure ShowError;
    function  ProcessDll(MemoryFile :Pointer) :Pointer;
    procedure FlushDll;
  end;

// ###########################################################################

implementation
{$L fake_dll.obj}

function _DG_MapPEFile8(MZ_File :Pointer; var pMap :Pointer) :LongBool; stdcall; external;
function _DG_UnMapPEFile4(MZ_Ptr :Pointer)   :LongBool; stdcall; external;
function _DG_ResolveRelocs4(MZ_Ptr :Pointer) :LongBool; stdcall; external;
function _DG_ResolveImport4(MZ_Ptr :Pointer) :LongBool; stdcall; external;
function _DG_CallDllMain8(MZ_Ptr :Pointer; Reason :DWord) :LongBool; stdcall; external;
function _DG_GetProcAddress12(hDll :DWord; Proc :PChar;var Addr :Pointer):LongBool;  stdcall; external;
function _DG_GetErrorBuff4(var Buff :PChar) :LongBool; stdcall; external;

constructor TFakeDll.Create;
begin
  inherited Create;
  FDHandle  := 0;
  DoErrors  := True;
  MajVer    := $01;
  MinVer    := $01;
  Copyright := #10#13#10#13 + 'TFakeDll v1.1 (Beta 2) by Dr.Golova' + #10#13 +
                              '[mailto: dr_golova@pisem.net]' + #10#13#10#13;
end;

destructor TFakeDll.Destroy;
begin
  FlushDll;
  inherited Destroy;
end;

// ######################## Public methods. ##################################

function TFakeDll.GetFDProcAddress(ProcName :PChar) :Pointer;
var
  ProcAddr :Pointer;
begin
  if False = _DG_GetProcAddress12(FDHandle, ProcName, ProcAddr) then Result := nil
  else Result := ProcAddr;
end;

procedure TFakeDll.InjectDll(MemoryFile :Pointer; FreeOld :LongBool);
begin
  if FreeOld = True then FlushDll;
  FDHandle := Cardinal(ProcessDll(MemoryFile));
end;

// ###################### Private methods. ###################################

function TFakeDll.ProcessDll(MemoryFile :Pointer) :Pointer;
var
  pMap :Pointer;
begin
  Result  := nil;
  try
    if ( (False = _DG_MapPEFile8(MemoryFile, pMap)) or
         (False = _DG_ResolveRelocs4(pMap))         or
         (False = _DG_ResolveImport4(pMap))         or
         (False = _DG_CallDllMain8(pMap, DLL_PROCESS_ATTACH)) ) then
    begin
      Self.ShowError;
      Exit;
    end;
  except
    MessageBox(GetDesktopWindow, 'Unknown fatal error !!!', 'TFakeDll Error:',
      MB_ICONSTOP);
    Exit;
  end;

  Result := pMap;
end;

procedure TFakeDll.FlushDll;
begin
  _DG_UnMapPeFile4(Pointer(FDHandle));
  FDHandle := 0;
end;

procedure TFakeDll.ShowError;
var
  Buff :PChar;
begin
  if Self.ShowErrors = False then Exit;
  _DG_GetErrorBuff4(Buff);
  MessageBox(GetDesktopWindow, Buff, 'TFakeDll Error:', MB_ICONSTOP);
end;

// ###########################################################################

var
  __imp__virtualalloc16    :Pointer;
  __imp__wsprintfa         :Pointer;
  __imp__virtualfree12     :Pointer;
  __imp__isbadreadptr8     :Pointer;
  __imp__loadlibrarya4     :Pointer;
  __imp__getmodulehandlea4 :Pointer;
  __imp__getprocaddress8   :Pointer;

begin
  __imp__virtualalloc16    := @VirtualAlloc;
  __imp__wsprintfa         := @wsprintf;
  __imp__virtualfree12     := @VirtualFree;
  __imp__isbadreadptr8     := @IsBadReadPtr;
  __imp__loadlibrarya4     := @LoadLibrary;
  __imp__getmodulehandlea4 := @GetModuleHandle;
  __imp__getprocaddress8   := @GetProcAddress;
end.


