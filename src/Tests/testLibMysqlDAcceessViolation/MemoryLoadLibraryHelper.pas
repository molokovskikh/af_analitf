unit MemoryLoadLibraryHelper;

interface

uses
  Windows;

const
//
// Based relocation types.
//

  IMAGE_REL_BASED_ABSOLUTE               = 0;
  IMAGE_REL_BASED_HIGH                   = 1;
  IMAGE_REL_BASED_LOW                    = 2;
  IMAGE_REL_BASED_HIGHLOW                = 3;
  IMAGE_REL_BASED_HIGHADJ                = 4;
  IMAGE_REL_BASED_MIPS_JMPADDR           = 5;
  IMAGE_REL_BASED_MIPS_JMPADDR16         = 9;
  IMAGE_REL_BASED_IA64_IMM64             = 9;
  IMAGE_REL_BASED_DIR64                  = 10;

   IMAGE_ORDINAL_FLAG32 = $80000000;

type
{$ifdef _WIN64}
  //{$define POINTER_TYPE ULONGLONG}
  POINTER_TYPE = ULONGLONG;
{$else}
  //{$define POINTER_TYPE DWORD}
  POINTER_TYPE = DWORD;
{$endif}

  PPOINTER_TYPE = ^POINTER_TYPE; 

  PIMAGE_BASE_RELOCATION = ^_IMAGE_BASE_RELOCATION;
  _IMAGE_BASE_RELOCATION = packed record
    VirtualAddress : DWORD;
    SizeOfBlock : DWORD;
//  WORD    TypeOffset[1];
  end;

//  _IMAGE_BASE_RELOCATION = _IMAGE_DATA_DIRECTORY;
//  PIMAGE_BASE_RELOCATION = ^_IMAGE_BASE_RELOCATION;

(*
typedef struct _IMAGE_IMPORT_DESCRIPTOR {
    union {
        DWORD   Characteristics;            // 0 for terminating null import descriptor
        DWORD   OriginalFirstThunk;         // RVA to original unbound IAT (PIMAGE_THUNK_DATA)
    } DUMMYUNIONNAME;
    DWORD   TimeDateStamp;                  // 0 if not bound,
                                            // -1 if bound, and real date\time stamp
                                            //     in IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT (new BIND)
                                            // O.W. date/time stamp of DLL bound to (Old BIND)

    DWORD   ForwarderChain;                 // -1 if no forwarders
    DWORD   Name;
    DWORD   FirstThunk;                     // RVA to IAT (if bound this IAT has actual addresses)
} IMAGE_IMPORT_DESCRIPTOR;
typedef IMAGE_IMPORT_DESCRIPTOR UNALIGNED *PIMAGE_IMPORT_DESCRIPTOR;
*)

  TImageImportDescriptor=packed record //(C++: IMAGE_IMPORT_DESCRIPTOR)
    OriginalFirstThunk:DWORD;//Ранее это поле называлось Characteristics; в целях сохранения
    //совместимости кода это название поддерживается и сейчас, но не
    //отражает содержание поля. Далее мы на нем остановимся подробнее
    TimeDateStamp:DWORD;//0, если импортирование осуществляется без привязки (binding - см. далее)
    //При импортировании с привязкой содержит отметку времени файла, из которого
    // импортируем, но:
    //Если -1, то здесь использовался новый стиль привязки
    ForwarderChain:DWORD;// См. описание испорта с привязкой (далее)
    Name:DWORD;//Виртуальный адрес ASCIIZ-строки с именем файла, из которого импортируем
    FirstThunk:DWORD;//Виртуальный адрес подтаблицы импортируемых символов
  end;
  PImageImportDescriptor=^TImageImportDescriptor;

(*
typedef struct _IMAGE_IMPORT_BY_NAME {
    WORD    Hint;
    BYTE    Name[1];
} IMAGE_IMPORT_BY_NAME, *PIMAGE_IMPORT_BY_NAME;
*)
   TIMAGE_IMPORT_BY_NAME = record
     Hint : Word;
     Name : array[0..0] of BYTE;
   end;
   PIMAGE_IMPORT_BY_NAME = ^TIMAGE_IMPORT_BY_NAME;

(*
typedef struct _IMAGE_EXPORT_DIRECTORY {
    DWORD   Characteristics;
    DWORD   TimeDateStamp;
    WORD    MajorVersion;
    WORD    MinorVersion;
    DWORD   Name;
    DWORD   Base;
    DWORD   NumberOfFunctions;
    DWORD   NumberOfNames;
    DWORD   AddressOfFunctions;     // RVA from base of image
    DWORD   AddressOfNames;         // RVA from base of image
    DWORD   AddressOfNameOrdinals;  // RVA from base of image
} IMAGE_EXPORT_DIRECTORY, *PIMAGE_EXPORT_DIRECTORY;

*)
  PImageExportDirectoryEx = ^TImageExportDirectoryEx;
  _IMAGE_EXPORT_DIRECTORYEx = packed record
      Characteristics: DWord;
      TimeDateStamp: DWord;
      MajorVersion: Word;
      MinorVersion: Word;
      Name: DWord;
      Base: DWord;
      NumberOfFunctions: DWord;
      NumberOfNames: DWord;
      AddressOfFunctions: DWORD;
      AddressOfNames: DWORD;
      AddressOfNameOrdinals: DWORD;
  end;
  TImageExportDirectoryEx = _IMAGE_EXPORT_DIRECTORYEx;
  IMAGE_EXPORT_DIRECTORYEx = _IMAGE_EXPORT_DIRECTORYEx;

type
  PMemoryModule = ^TMemoryModule;
  TMemoryModule = record
    //PIMAGE_NT_HEADERS headers;
    headers : PImageNtHeaders;
    //unsigned char *codeBase;
    codeBase : PByte;
    //HMODULE *modules;
    modules : array of HMODULE;
    //int numModules;
    numModules : Integer;
    //int initialized;
    initialized : Integer;
  end;

  //typedef BOOL (WINAPI *DllEntryProc)(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved);
  TDllEntryProc = function(hinstDLL : HMODULE; fdwReason : DWORD; lpReserved :Pointer): BOOL; stdcall;

const
  IMAGE_SIZEOF_BASE_RELOCATION = SizeOf(_IMAGE_BASE_RELOCATION);

function MemoryLoadLibrary(data : Pointer) : PMemoryModule;

function MemoryGetProcAddress(module : PMemoryModule; name : PChar) : Pointer;

procedure MemoryFreeLibrary(module : PMemoryModule);

implementation

uses Math, SysUtils;

const
  // Protection flags for memory pages (Executable, Readable, Writeable)
(*
  static int ProtectionFlags[2][2][2] = {
    {
      // not executable
      {PAGE_NOACCESS, PAGE_WRITECOPY},
      {PAGE_READONLY, PAGE_READWRITE},
    }, {
      // executable
      {PAGE_EXECUTE, PAGE_EXECUTE_WRITECOPY},
      {PAGE_EXECUTE_READ, PAGE_EXECUTE_READWRITE},
    },
  };
*)
  ProtectionFlags : array[0..1, 0..1, 0..1] of Integer = (
    (
      // not executable
      (PAGE_NOACCESS, PAGE_WRITECOPY),
      (PAGE_READONLY, PAGE_READWRITE)
    ),
    (
      // executable
      (PAGE_EXECUTE, PAGE_EXECUTE_WRITECOPY),
      (PAGE_EXECUTE_READ, PAGE_EXECUTE_READWRITE)
    )
  );

{$ifdef DEBUG_OUTPUT}
procedure OutputLastError(msg : String);
begin
{
  LPVOID tmp;
  char *tmpmsg;
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
    NULL, GetLastError(), MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPTSTR)&tmp, 0, NULL);
  tmpmsg = (char *)LocalAlloc(LPTR, strlen(msg) + strlen(tmp) + 3);
  sprintf(tmpmsg, "%s: %s", msg, tmp);

  OutputDebugString(tmpmsg);
  LocalFree(tmpmsg);
  LocalFree(tmp);
}  

  OutputDebugString(Format('%s: %s', [msg, SysErrorMessage(GetLastError())]));
end;
{$endif}


//#define GET_HEADER_DICTIONARY(module, idx)	&(module)->headers->OptionalHeader.DataDirectory[idx]
function GET_HEADER_DICTIONARY(module: PMemoryModule ; idx : Integer) : PImageDataDirectory;
begin
  Result := @(module^.headers^.OptionalHeader.DataDirectory[idx]);
end;

function FieldOffset(const Struc; const Field): Cardinal;
begin
  Result := Cardinal(@Field) - Cardinal(@Struc);
end;

function IMAGE_FIRST_SECTION(NtHeader: PImageNtHeaders): PImageSectionHeader;
begin
  Result := PImageSectionHeader(Cardinal(NtHeader) +
      FieldOffset(NtHeader^, NtHeader^.OptionalHeader) +
      NtHeader^.FileHeader.SizeOfOptionalHeader);
end;

procedure CopySections(data : PByte; old_headers: PImageNtHeaders; module: PMemoryModule);
var
  i, size : Integer;
  codeBase : PByte;
  dest : PByte;
  section : PImageSectionHeader;
begin
  codeBase := module^.codeBase;
  section := IMAGE_FIRST_SECTION(module^.headers);
  for I := 0 to module^.headers^.FileHeader.NumberOfSections-1 do begin
    if (section^.SizeOfRawData = 0) then begin
      // section doesn't contain data in the dll itself, but may define
      // uninitialized data
      size := old_headers^.OptionalHeader.SectionAlignment;
      if (size > 0) then begin
        dest := PByte(VirtualAlloc(PChar(codeBase) + section^.VirtualAddress,
          size,
          MEM_COMMIT,
          PAGE_READWRITE));

        section^.Misc.PhysicalAddress := POINTER_TYPE(dest);

        //memset(dest, 0, size);
        ZeroMemory(dest, size);
      end;

      // section is empty
      Inc(section);
      continue;
    end;

    // commit memory block and copy data from dll
{
    dest = (unsigned char *)VirtualAlloc(codeBase + section->VirtualAddress,
              section->SizeOfRawData,
              MEM_COMMIT,
              PAGE_READWRITE);
}
    dest := PByte(VirtualAlloc(PChar(codeBase) + section^.VirtualAddress,
      section^.SizeOfRawData,
      MEM_COMMIT,
      PAGE_READWRITE));
    //memcpy(dest, data + section->PointerToRawData, section->SizeOfRawData);
    CopyMemory(dest, PChar(data) + section^.PointerToRawData, section^.SizeOfRawData);
    section^.Misc.PhysicalAddress := POINTER_TYPE(dest);
    Inc(section);
  end;
end;

procedure FinalizeSections(module : PMemoryModule);
var
  i : Integer;
  section : PImageSectionHeader;
  imageOffset : POINTER_TYPE;
  protect, oldProtect, size : DWORD;
  executable, readable, writeable : Integer;
begin
  section := IMAGE_FIRST_SECTION(module^.headers);
{$ifdef _WIN64}
  imageOffset := (module^.headers^.OptionalHeader.ImageBase and $ffffffff00000000);
{$else}
  imageOffset := 0;
{$endif}

  // loop through all sections and change access flags
  for I := 0 to module^.headers^.FileHeader.NumberOfSections-1 do begin
    executable := IfThen((section^.Characteristics and IMAGE_SCN_MEM_EXECUTE) <> 0, 1);
    readable   := IfThen((section^.Characteristics and IMAGE_SCN_MEM_READ) <> 0, 1);
    writeable  := IfThen((section^.Characteristics and IMAGE_SCN_MEM_WRITE) <> 0, 1);

    if (section^.Characteristics and IMAGE_SCN_MEM_DISCARDABLE > 0) then begin
      // section is not needed any more and can safely be freed
      //VirtualFree((LPVOID)((POINTER_TYPE)section->Misc.PhysicalAddress | imageOffset), section->SizeOfRawData, MEM_DECOMMIT);
      VirtualFree(PChar(POINTER_TYPE(section^.Misc.PhysicalAddress) or imageOffset), section^.SizeOfRawData, MEM_DECOMMIT);
      Inc(section);
      continue;
    end;

    // determine protection flags based on characteristics
    protect := ProtectionFlags[executable][readable][writeable];
    if (section^.Characteristics and IMAGE_SCN_MEM_NOT_CACHED > 0) then begin
      protect := protect or PAGE_NOCACHE;
    end;

    // determine size of region
    size := section^.SizeOfRawData;
    if (size = 0) then begin
      if (section^.Characteristics and IMAGE_SCN_CNT_INITIALIZED_DATA > 0) then begin
        size := module^.headers^.OptionalHeader.SizeOfInitializedData;
      end else if (section^.Characteristics and IMAGE_SCN_CNT_UNINITIALIZED_DATA > 0) then begin
        size := module^.headers^.OptionalHeader.SizeOfUninitializedData;
      end
    end;

    if (size > 0) then begin
      // change memory access flags
      //if (VirtualProtect((LPVOID)((POINTER_TYPE)section->Misc.PhysicalAddress | imageOffset), size, protect, &oldProtect) == 0)
      if (not VirtualProtect(PChar(POINTER_TYPE(section^.Misc.PhysicalAddress) or imageOffset), size, protect, oldProtect)) then
{$ifdef DEBUG_OUTPUT}
        OutputLastError('Error protecting memory page')
{$endif}
      ;
    end;
    Inc(section);
  end;
end;


procedure PerformBaseRelocation(module: PMemoryModule; delta: ULONG);
var
  i : DWORD;
  codeBase : PByte;
  directory : PImageDataDirectory;
  relocation : PIMAGE_BASE_RELOCATION;
  dest : PByte;
  relInfo : PWORD;
  patchAddrHL : PDWORD;
{$ifdef _WIN64}
  patchAddr64 : ULONGLONG;
{$endif}
  typeReloc : Integer;
  offset : Integer;
begin
  codeBase := module^.codeBase;

  directory := GET_HEADER_DICTIONARY(module, IMAGE_DIRECTORY_ENTRY_BASERELOC);
  if (directory^.Size > 0) then begin
    relocation := PIMAGE_BASE_RELOCATION(PChar(codeBase) + directory^.VirtualAddress);

    //for (; relocation->VirtualAddress > 0; ) {
    while (relocation^.VirtualAddress > 0) do begin
      dest := PByte(PChar(codeBase) + relocation^.VirtualAddress);
      relInfo := PWord(PChar(relocation) + IMAGE_SIZEOF_BASE_RELOCATION);
      //for (i=0; i<((relocation->SizeOfBlock-IMAGE_SIZEOF_BASE_RELOCATION) / 2); i++, relInfo++) {
      for i:=0 to ((relocation^.SizeOfBlock-IMAGE_SIZEOF_BASE_RELOCATION) div 2) - 1 do begin

        // the upper 4 bits define the type of relocation
        //typeReloc = *relInfo >> 12;
        typeReloc := relInfo^ shr 12;

        // the lower 12 bits define the offset
        //offset = *relInfo & 0xfff;
        offset := relInfo^ and $fff;

        //switch (type)
        case typeReloc of
          IMAGE_REL_BASED_ABSOLUTE:
          // skip relocation
          ;

        IMAGE_REL_BASED_HIGHLOW:
          begin
          // change complete 32 bit address
          //patchAddrHL = (DWORD *) (dest + offset);
          patchAddrHL := PDWORD (PChar(dest) + offset);
          //*patchAddrHL += delta;
          //?????
          patchAddrHL^ := patchAddrHL^ + delta;
          end;

{$ifdef _WIN64}
        IMAGE_REL_BASED_DIR64:
          begin
          //patchAddr64 = (ULONGLONG *) (dest + offset);
          //*patchAddr64 += delta;
          end;
{$endif}

        else
          //printf("Unknown relocation: %d\n", type);
        end;

        Inc(relInfo);
      end;

      // advance to next relocation block
      //relocation := (PIMAGE_BASE_RELOCATION) (((char *) relocation) + relocation->SizeOfBlock);
      relocation := PIMAGE_BASE_RELOCATION(PChar( relocation) + relocation^.SizeOfBlock);
    end;
  end;
end;


function BuildImportTable(module : PMemoryModule) : Integer;
var
  codeBase : PByte;
  directory : PImageDataDirectory;
  importDesc : PImageImportDescriptor;
  thunkRef : PPOINTER_TYPE;
  funcRef : TFarProc;
  handle : HMODULE;
  thunkData : PIMAGE_IMPORT_BY_NAME;

begin
  Result := 1;
  codeBase := module^.codeBase;

  directory := GET_HEADER_DICTIONARY(module, IMAGE_DIRECTORY_ENTRY_IMPORT);
  if (directory^.Size > 0) then begin
    importDesc := PImageImportDescriptor (PChar(codeBase) + directory^.VirtualAddress);
    //for (; !IsBadReadPtr(importDesc, sizeof(IMAGE_IMPORT_DESCRIPTOR)) && importDesc->Name; importDesc++) {
    while (not IsBadReadPtr(importDesc, sizeof(TImageImportDescriptor)) and (importDesc^.Name > 0)) do begin
      //handle := LoadLibrary((LPCSTR) (codeBase + importDesc->Name));
      handle := LoadLibrary((PChar(codeBase) + importDesc^.Name));
      if (handle = INVALID_HANDLE_VALUE) then begin
{$ifdef DEBUG_OUTPUT}
        OutputLastError("Can't load library");
{$endif}
        Result := 0;
        break;
      end;

      //module->modules = (HMODULE *)realloc(module->modules, (module->numModules+1)*(sizeof(HMODULE)));
      SetLength(module^.modules, module^.numModules + 1);
      if (module^.modules = nil) then begin
        Result := 0;
        break;
      end;

      Inc(module^.numModules);
      module^.modules[module^.numModules-1] := handle;
      if (importDesc^.OriginalFirstThunk > 0) then begin
        //thunkRef = (POINTER_TYPE *) (codeBase + importDesc->OriginalFirstThunk);
        thunkRef := PPOINTER_TYPE ((PChar(codeBase) + importDesc^.OriginalFirstThunk));
        //funcRef = (FARPROC *) (PChar(codeBase) + importDesc^.FirstThunk);
        funcRef := FARPROC (PChar(codeBase) + importDesc^.FirstThunk);
      end else begin
        // no hint table
        //thunkRef = (POINTER_TYPE *) (codeBase + importDesc->FirstThunk);
        thunkRef := PPOINTER_TYPE ((PChar(codeBase) + importDesc^.FirstThunk));
        //funcRef = (FARPROC *) (codeBase + importDesc->FirstThunk);
        funcRef := FARPROC (PChar(codeBase) + importDesc^.FirstThunk);
      end;
      //for (; *thunkRef; thunkRef++, funcRef++) {
      while (thunkRef^ > 0) do begin
        if ((thunkRef^ and IMAGE_ORDINAL_FLAG32) <> 0) then begin
          //*funcRef = (FARPROC)GetProcAddress(handle, (LPCSTR)IMAGE_ORDINAL(*thunkRef));
          funcRef := GetProcAddress(handle, PChar(thunkRef^ and $ffff));
        end else begin
          thunkData := PIMAGE_IMPORT_BY_NAME (PChar(codeBase) + thunkRef^);
          //*funcRef = (FARPROC)GetProcAddress(handle, (LPCSTR)&thunkData->Name);
          funcRef := GetProcAddress(handle, PChar(@thunkData^.Name));
        end;
        if (funcRef = nil) then begin
          Result := 0;
          break;
        end;
        Inc(thunkRef);
        //Inc(funcRef);
      end;

      if (result = 0) then begin
        break;
      end;

      Inc(importDesc);
    end;
  end;

  //return result;
end;



function MemoryLoadLibrary(data : Pointer) : PMemoryModule;
var
  dos_header : PImageDosHeader;
  old_header : PImageNtHeaders;
  code : PByte;
  headers : PByte;
  locationDelta : ULONG;
  DllEntry : TDllEntryProc;
  successfull : BOOL;

  label error;
begin

  dos_header := PImageDosHeader(data);
  if (dos_header^.e_magic <> IMAGE_DOS_SIGNATURE) then begin
{$ifdef DEBUG_OUTPUT}
    OutputDebugString("Not a valid executable file.\n");
{$endif}
    //return NULL;
    Result := nil;
    Exit;
  end;

  //old_header := (PIMAGE_NT_HEADERS)&(PByte(data))[dos_header->e_lfanew];
  //PEHeader:=Pointer(int64(Cardinal(Image))+PImageDosHeader(Image)._lfanew);
  old_header := PImageNtHeaders(PChar(data) + dos_header^._lfanew);
  if (old_header^.Signature <> IMAGE_NT_SIGNATURE) then begin
{$ifdef DEBUG_OUTPUT}
    OutputDebugString("No PE header found.\n");
{$endif}
    //return NULL;
    Result := nil;
    Exit;
  end;

  // reserve memory for image of library
{
  code = (unsigned char *)VirtualAlloc((LPVOID)(old_header->OptionalHeader.ImageBase),
    old_header->OptionalHeader.SizeOfImage,
    MEM_RESERVE,
    PAGE_READWRITE);
}    

  code := PByte(VirtualAlloc(Ptr(old_header^.OptionalHeader.ImageBase),
    old_header^.OptionalHeader.SizeOfImage,
    MEM_RESERVE,
    PAGE_READWRITE));

  if (code = nil) then begin
        // try to allocate memory at arbitrary position
{
        code = (unsigned char *)VirtualAlloc(NULL,
            old_header->OptionalHeader.SizeOfImage,
            MEM_RESERVE,
            PAGE_READWRITE);
}
    code := PByte(VirtualAlloc(nil,
        old_header^.OptionalHeader.SizeOfImage,
        MEM_RESERVE,
        PAGE_READWRITE));
    if (code = nil) then begin
{$ifdef DEBUG_OUTPUT}
      OutputLastError("Can't reserve memory");
{$endif}
      //return NULL;
      Result := nil;
      Exit;
    end;
  end;

  New(result);
  //result := PMEMORYMODULE(HeapAlloc(GetProcessHeap(), 0, sizeof(TMEMORYMODULE)));
  result^.codeBase := code;
  result^.numModules := 0;
  SetLength(result^.modules, 0);
  //result^.modules := nil;
  result^.initialized := 0;

  // XXX: is it correct to commit the complete memory region at once?
    //      calling DllEntry raises an exception if we don't...
{
  VirtualAlloc(code,
    old_header->OptionalHeader.SizeOfImage,
    MEM_COMMIT,
    PAGE_READWRITE);
}
  VirtualAlloc(code,
    old_header^.OptionalHeader.SizeOfImage,
    MEM_COMMIT,
    PAGE_READWRITE);

  // commit memory for headers
{
  headers = (unsigned char *)VirtualAlloc(code,
    old_header->OptionalHeader.SizeOfHeaders,
    MEM_COMMIT,
    PAGE_READWRITE);
}
  headers := PByte(VirtualAlloc(code,
    old_header^.OptionalHeader.SizeOfHeaders,
    MEM_COMMIT,
    PAGE_READWRITE));

  // copy PE header to code
  //memcpy(headers, dos_header, dos_header->e_lfanew + old_header->OptionalHeader.SizeOfHeaders);
  CopyMemory(headers, dos_header, dos_header^._lfanew + old_header^.OptionalHeader.SizeOfHeaders);
  //result->headers = (PIMAGE_NT_HEADERS)&((const unsigned char *)(headers))[dos_header->e_lfanew];
  result^.headers := PImageNtHeaders(PChar(headers) + dos_header^._lfanew);

  // update position
  //result->headers->OptionalHeader.ImageBase = (POINTER_TYPE)code;
  result^.headers^.OptionalHeader.ImageBase := POINTER_TYPE(code);

  // copy sections from DLL file block to new memory location
  CopySections(data, old_header, result);

  // adjust base address of imported data
  //locationDelta = (SIZE_T)(code - old_header->OptionalHeader.ImageBase);
  locationDelta := ULONG(Integer(code) - old_header^.OptionalHeader.ImageBase);
  if (locationDelta <> 0) then begin
    PerformBaseRelocation(result, locationDelta);
  end;

  // load required dlls and adjust function table of imports
  if (BuildImportTable(result) = 0) then begin
    goto error;
  end;

  // mark memory pages depending on section headers and release
  // sections that are marked as "discardable"
  FinalizeSections(result);

  // get entry point of loaded library
  if (result^.headers^.OptionalHeader.AddressOfEntryPoint <> 0) then begin
    DllEntry := TDllEntryProc (Pchar(code) + result^.headers^.OptionalHeader.AddressOfEntryPoint);
    if (not Assigned(DllEntry)) then begin
{$ifdef DEBUG_OUTPUT}
      OutputDebugString("Library has no entry point.\n");
{$endif}
      goto error;
    end;

    // notify library about attaching to process
    //successfull := (*DllEntry)((HINSTANCE)code, DLL_PROCESS_ATTACH, 0);
    successfull := DllEntry(HMODULE(code), DLL_PROCESS_ATTACH, 0);
    if (not successfull) then begin
{$ifdef DEBUG_OUTPUT}
      OutputDebugString("Can't attach library.\n");
{$endif}
      goto error;
    end;
    result^.initialized := 1;
  end;

  //return (HMEMORYMODULE)result;
  Exit;

error:
  // cleanup
  MemoryFreeLibrary(result);
  //return NULL;
  Result := nil;
end;

function MemoryGetProcAddress(module : PMemoryModule; name : PChar) : Pointer;
var
  codeBase : PByte;
  idx : Integer;
  i : DWORD;
  nameRef : PDWORD;
  ordinal : PWORD;
  exportsTable : PImageExportDirectoryEx;
  directory : PImageDataDirectory;
begin
  //unsigned char *codeBase = ((PMEMORYMODULE)module)->codeBase;
  codeBase := module^.codeBase;
  idx := -1;
  directory := GET_HEADER_DICTIONARY(module, IMAGE_DIRECTORY_ENTRY_EXPORT);
  if (directory^.Size = 0) then begin
    // no export table found
    //return NULL;
    Result := nil;
    exit;
  end;

  exportsTable := PImageExportDirectoryEx (PChar(codeBase) + directory^.VirtualAddress);
  if ((exportsTable^.NumberOfNames = 0) or (exportsTable^.NumberOfFunctions = 0)) then begin
    // DLL doesn't export anything
    //return NULL;
    Result := nil;
    exit;
  end;

  // search function name in list of exported names
  {
nameRef = (DWORD *) (codeBase + exports->AddressOfNames);
ordinal = (WORD *) (codeBase + exports->AddressOfNameOrdinals);
}
  nameRef := PDWORD (PChar(codeBase) + exportsTable^.AddressOfNames);
  ordinal := PWORD (PChar(codeBase) + exportsTable^.AddressOfNameOrdinals);
  //for (i=0; i<exports->NumberOfNames; i++, nameRef++, ordinal++) {
  for i:=0 to exportsTable^.NumberOfNames-1 do begin
    //if (stricmp(name, (const char *) (codeBase + (*nameRef))) == 0) {
    if (AnsiStrIComp(name, (PChar(codeBase) + nameRef^)) = 0) then begin
      //idx = *ordinal;
      idx := ordinal^;
      break;
    end;
    Inc(nameRef);
    Inc(ordinal);
  end;

  if (idx = -1) then begin
    // exported symbol not found
    //return NULL;
    Result := nil;
    exit;
  end;

  if (DWORD(idx) > exportsTable^.NumberOfFunctions) then begin
    // name <-> ordinal number don't match
    //return NULL;
    Result := nil;
    exit;
  end;

  // AddressOfFunctions contains the RVAs to the "real" functions
  //return (FARPROC) (codeBase + (*(DWORD *) (codeBase + exports->AddressOfFunctions + (idx*4))));
  //Result:=Pointer(PDWORDArray(Cardinal(LibInfo.PExports.AddressOfFunctions)+Cardinal(LibInfo.ImageBase))^[PWordArray(Cardinal(LibInfo.PExports.AddressOfNameOrdinals)+Cardinal(LibInfo.ImageBase))^[J]]+Cardinal(LibInfo.ImageBase));
  //PDWORD ( PChar(codeBase) +  + exportsTable^.AddressOfFunctions + (idx*4) )^
  Result := TFarProc (PChar(codeBase) + PDWORD ( PChar(codeBase) +  + exportsTable^.AddressOfFunctions + (idx*4) )^  );
end;

procedure MemoryFreeLibrary(module : PMemoryModule);
var
  i : Integer;
  DllEntry : TDllEntryProc;
begin
  if (module <> nil) then begin
    if (module^.initialized <> 0) then begin
      // notify library about detaching from process
      //DllEntryProc DllEntry = (DllEntryProc) (module->codeBase + module->headers->OptionalHeader.AddressOfEntryPoint);
      DllEntry := TDllEntryProc (PChar(module^.codeBase) + module^.headers^.OptionalHeader.AddressOfEntryPoint);
      //(*DllEntry)((HINSTANCE)module->codeBase, DLL_PROCESS_DETACH, 0);
      DllEntry(HMODULE(module^.codeBase), DLL_PROCESS_DETACH, 0);
      module^.initialized := 0;
    end;

    if (module^.modules <> nil) then begin
      // free previously opened libraries
      //for (i=0; i<module->numModules; i++) {
      for I := 0 to module^.numModules-1 do begin
        if (module^.modules[i] <> INVALID_HANDLE_VALUE) then begin
          FreeLibrary(module^.modules[i]);
        end;
      end;

      //free(module->modules);
      SetLength(module^.modules, 0);
    end;

    if (module^.codeBase <> nil) then begin
      // release memory of library
      VirtualFree(module^.codeBase, 0, MEM_RELEASE);
    end;

    //HeapFree(GetProcessHeap(), 0, module);
    Dispose(module);
  end;
end;


end.




