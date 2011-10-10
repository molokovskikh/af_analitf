unit DLLLoader;
interface
uses
  Windows;

function xLoadLibrary(Image:Pointer):HMODULE;
function xGetProcAddress(Module:HMODULE;ProcName:PChar):Pointer;
function xFreeLibrary(Module:HMODULE):Boolean;

implementation
uses
  Classes,SysUtils,Types,Math;

type
  TSections=array[0..0] of TImageSectionHeader;
  TDllEntryProc=function(Hinst:Integer;Reason:Integer;Resvd:Pointer):LongBool;stdcall;

  TLibInfo=record
    ImageBase:Pointer;//Базовый адрес образа
    DllProc:TDllEntryProc;
    //Список, содержащий имена импользуемых DLL модулей и их значения HModule
    LibsUsed:array of record
      Name:string;
      Instance:HModule;
    end;
    PExports:PImageExportDirectory;
    BlockSize:Cardinal;
  end;
  PLibInfo=^TLibInfo;

  TWordArray=array[0..0] of Word;
  PWordArray=^TWordArray;
  TDWORDArray=array[0..0] of DWORD;
  PDWORDArray=^TDWORDArray;

  TImageBaseRelocation=packed record
    VirtualAddress:Cardinal;
    SizeOfBlock:Cardinal;
  end;
  PImageBaseRelocation=^TImageBaseRelocation;

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

var
  LoadedLibs:TList=nil;

function xFreeLibrary(Module:HMODULE):Boolean;
var
  I,J:Integer;
  LibInfo:PLibInfo;
begin
  Result:=False;
  if (Module=0)or not Assigned(LoadedLibs) then Exit;
  for I:=0 to LoadedLibs.Count-1 do begin
    LibInfo:=LoadedLibs[I];
    if LibInfo.ImageBase=Pointer(Module) then begin
      LoadedLibs.Delete(I);
      try
        if @LibInfo.DllProc<>nil then LibInfo.DllProc(Module,DLL_PROCESS_DETACH,nil);
      except
      end;
      for J:=0 to High(LibInfo.LibsUsed) do
        FreeLibrary(LibInfo.LibsUsed[J].Instance);
      Dispose(LibInfo);
      Result:=True;
      Break;
    end;
  end;
  VirtualFree(Pointer(Module),0,MEM_RELEASE);
end;

function GetLibrary(LibInfo:PLibInfo;const DLLName:string):HModule;
var
  I:Integer;
begin
  for I:=0 to High(LibInfo.LibsUsed) do
    if AnsiSameText(LibInfo.LibsUsed[I].Name,DLLName) then begin
      Result:=LibInfo.LibsUsed[I].Instance;
      Exit;
    end;
  Result:=LoadLibrary(PChar(DllName));
  SetLength(LibInfo.LibsUsed,Length(LibInfo.LibsUsed)+1);
  with LibInfo.LibsUsed[High(LibInfo.LibsUsed)] do begin
    Name:=DllName;
    Instance:=Result;
  end;
end;

function xGetProcAddress(Module:HMODULE;ProcName:PChar):Pointer;
var
  I,J,A:Integer;
  LibInfo:PLibInfo;
  PC:PChar;
  S:string;
begin
  Result:=nil;
  if (Module=0)or not Assigned(LoadedLibs) then Exit;
  for I:=0 to LoadedLibs.Count-1 do
    if TLibInfo(LoadedLibs[I]^).ImageBase=Pointer(Module) then begin
      LibInfo:=LoadedLibs[I];
      //Проход по всем символам, экспортированным по имени
      for J:=0 to LibInfo.PExports.NumberOfNames-1 do
        if StrComp(ProcName,PChar(PDWORDArray(Cardinal(LibInfo.PExports.AddressOfNames)+Cardinal(LibInfo.ImageBase))^[J]+Cardinal(LibInfo.ImageBase)))=0 then begin
          Result:=Pointer(PDWORDArray(Cardinal(LibInfo.PExports.AddressOfFunctions)+Cardinal(LibInfo.ImageBase))^[PWordArray(Cardinal(LibInfo.PExports.AddressOfNameOrdinals)+Cardinal(LibInfo.ImageBase))^[J]]+Cardinal(LibInfo.ImageBase));
          if (PChar(Result)>=PChar(LibInfo.PExports))and(PChar(Result)<PChar(LibInfo.PExports)+LibInfo.BlockSize) then begin
            S:=PChar(Result);
            Result:=nil;
            A:=Pos('.',S);
            if A=0 then Exit;
            if S[A+1]='#' then
              PC:=Pointer(StrToIntDef(Copy(S,A+2,MaxInt),-1))
            else
              PC:=@S[A+1];
            Result:=GetProcAddress(GetLibrary(LibInfo,Copy(S,1,A-1)),PC);
            Exit;
          end;
        end;
      Break;
    end;
end;

function XLoadLibrary(Image:Pointer):HMODULE;
var
  ImageBase,SectionBase:Pointer;
  ImageBaseTest:Int64;
  ImageBaseDelta:Integer;
  PEHeader:PImageNtHeaders;
  PSections:^TSections;
  S:Integer;
  VirtualSectionSize,RawSectionSize,Dummy:Cardinal;
  PNewLibInfo:PLibInfo;
  procedure ProcessRelocs(PRelocs:PImageBaseRelocation);
  var
    PReloc:PImageBaseRelocation;
    P:PWord;
    I:Cardinal;
    v : Int64;
    changed : PDWORD;
  begin
    PReloc:=PRelocs;
    while Cardinal(PReloc)-Cardinal(PRelocs)<PEHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size do begin
      P:=Pointer(Cardinal(PReloc)+SizeOf(PReloc^));
      for I:=0 to(PReloc.SizeOfBlock-SizeOf(TImageBaseRelocation))div 2-1 do begin
        if P^and $F000<>0{//Если тип ссылки - не IMAGE_REL_BASED_ABSOLUTE(=0)} then begin
          changed := PDWORD(Cardinal(ImageBase)+PReloc.VirtualAddress+(P^and $0FFF));
          v := changed^;
          v := v + ImageBaseDelta;
          changed^ := v;
          //Inc(PDWORD(Cardinal(ImageBase)+PReloc.VirtualAddress+(P^and $0FFF))^,ImageBaseDelta);//Исправляем ссылку
        end;
        Inc(P);
      end;
      PReloc:=Pointer(P);
    end;
  end;
  procedure ProcessImports(PImport:PImageImportDescriptor);
  var
    PRVA_Import:LPDWORD;
    LibHandle:HModule;
  begin
    while PImport.Name<>0 do begin
      LibHandle:=GetLibrary(PNewLibInfo,PChar(Cardinal(PImport.Name)+Cardinal(ImageBase)));
      if PImport.TimeDateStamp=0{//Привязка есть?} then
        PRVA_Import:=LPDWORD(pImport.FirstThunk+Cardinal(ImageBase))
      else
        PRVA_Import:=LPDWORD(pImport.OriginalFirstThunk+Cardinal(ImageBase));
      while PRVA_Import^<>0 do begin
        if (PRVA_Import^and $80000000)<>0 then //Это импортирование по номеру
          PPointer(PRVA_Import)^:=GetProcAddress(LibHandle,PChar(PRVA_Import^and $FFFF))
        else
          PPointer(PRVA_Import)^:=GetProcAddress(LibHandle,PChar(PRVA_Import^+Cardinal(ImageBase)+2));
        Inc(PRVA_Import);
      end;
      Inc(PImport);
    end;
  end;
  function GetSectionProtection(SC:Cardinal):Cardinal;
    //SC - значение ImageSectionHeader.Characteristics,
    //на выходе - значение флагов доступа для VirtualProtect
  const
    Mapping:array[0..7] of ULONG=(PAGE_NOACCESS,PAGE_EXECUTE,PAGE_READONLY,PAGE_EXECUTE_READ,PAGE_READWRITE,PAGE_EXECUTE_READWRITE,PAGE_READWRITE,PAGE_EXECUTE_READWRITE);
  begin
    Result:=Mapping[SC shr 29]or DWORD(IfThen((SC and IMAGE_SCN_MEM_NOT_CACHED)<>0,PAGE_NOCACHE));
  end;
begin
  Result:=0;
  try
    PEHeader:=Pointer(int64(Cardinal(Image))+PImageDosHeader(Image)._lfanew);
    ImageBase:=VirtualAlloc(nil,PEHeader.OptionalHeader.SizeOfImage,MEM_RESERVE,PAGE_NOACCESS);
    if ImageBase=nil then Exit;

    ImageBaseTest := Int64(ImageBase)-PEHeader.OptionalHeader.ImageBase;
{
    if Cardinal(ImageBase) > PEHeader.OptionalHeader.ImageBase then
      ImageBaseDelta := Cardinal(ImageBase)-PEHeader.OptionalHeader.ImageBase
    else
      ImageBaseDelta := - (PEHeader.OptionalHeader.ImageBase - Cardinal(ImageBase));
}      

    ImageBaseDelta := Integer(ImageBaseTest);
    SectionBase:=VirtualAlloc(ImageBase,PEHeader.OptionalHeader.SizeOfHeaders,MEM_COMMIT,PAGE_READWRITE);
    if SectionBase=nil then OutOfMemoryError;
    Move(Image^,SectionBase^,PEHeader.OptionalHeader.SizeOfHeaders);
    VirtualProtect(SectionBase,PEHeader.OptionalHeader.SizeOfHeaders,PAGE_READONLY,Dummy);
    PSections:=Pointer(PChar(@(PEHeader.OptionalHeader))+PEHeader.FileHeader.SizeOfOptionalHeader);
    for S:=0 to PEHeader.FileHeader.NumberOfSections-1 do begin
      VirtualSectionSize:=PSections[S].Misc.VirtualSize;
      RawSectionSize:=PSections[S].SizeOfRawData;
      if VirtualSectionSize<RawSectionSize then VirtualSectionSize:=PSections[S].SizeOfRawData;
      SectionBase:=VirtualAlloc(PSections[S].VirtualAddress+PChar(ImageBase),VirtualSectionSize,MEM_COMMIT,PAGE_READWRITE);
      if SectionBase=nil then OutOfMemoryError;
      Move((PChar(Image)+PSections[S].PointerToRawData)^,SectionBase^,RawSectionSize);
    end;
    if LoadedLibs=nil then LoadedLibs:=TList.Create;
    New(PNewLibInfo);
    FillChar(PNewLibInfo^,SizeOf(TLibInfo),0);
    PNewLibInfo^.DllProc:=TDllEntryProc(PEHeader.OptionalHeader.AddressOfEntryPoint+Cardinal(ImageBase));
    PNewLibInfo^.ImageBase:=ImageBase;
    LoadedLibs.Add(PNewLibInfo);
    with PEHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC] do
      if VirtualAddress<>0 then ProcessRelocs(Pointer(VirtualAddress+Cardinal(ImageBase)));
    with PEHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT] do
      if VirtualAddress<>0 then ProcessImports(Pointer(VirtualAddress+Cardinal(ImageBase)));
    with PEHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT] do
      if VirtualAddress<>0 then begin
        PNewLibInfo.PExports:=Pointer(VirtualAddress+Cardinal(ImageBase));
        PNewLibInfo.BlockSize:=Size;
      end;
    for S:=0 to PEHeader.FileHeader.NumberOfSections-1 do
      with PSections[S] do
        VirtualProtect(VirtualAddress+PChar(ImageBase),Misc.VirtualSize,GetSectionProtection(Characteristics),Dummy);
    if (@PNewLibInfo^.DllProc<>nil)and not PNewLibInfo^.DllProc(Cardinal(ImageBase),DLL_PROCESS_ATTACH,nil) then begin
      PNewLibInfo^.DllProc:=nil;
      XFreeLibrary(Result);
      Exit;
    end;
    Result:=Cardinal(ImageBase);
  except
    VirtualFree(ImageBase,0,MEM_RELEASE);
  end;
end;

initialization
finalization
  if Assigned(LoadedLibs) then begin
    while LoadedLibs.Count>0 do
      XFreeLibrary(HMODULE(TLibInfo(LoadedLibs.First^).ImageBase));
    FreeAndNil(LoadedLibs);
  end;
end.
