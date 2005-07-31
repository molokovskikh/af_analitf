unit U_FolderMacros;

interface

uses
  SysUtils, Windows, FileUtil;

{
Cсылка на макросы в MSDN:
ms-help://MS.MSDNQTR.2004OCT.1033/enu_kbvbwin/vbwin/189739.htm

Поддерживаются макросы
$(WinSysPath)
This macro installs files to the System subdirectory under the Windows directory.
The paths below are typical paths to the Windows\System directory.
This macro can be used for both Setup1 Files and Bootstrap Files.
   \Windows\System (Windows 95 or later)
   \Winnt\System32 (Windows NT 4.0 and later)

$(WinPath)
This macro installs files to the directory where Windows is installed.
The examples below are typical paths to the Windows directory.
This macro can be used for both Setup1 Files and BootStrap Files.
   \Windows (Windows 95 or later)
   \Winnt (Windows NT)

$(CommonFiles)
This macro installs files to the Program Files\Common Files folder. Valid only for Setup1 Files.
   \Program Files\Common Files\

$(ProgramFiles)
Installs files to the \Program Files directory. Valid only for Setup1 Files.
   \Program Files
}
function ReplaceMacros(AInput : String) : String;

function GetProgramFilesDir: string;

function GetCommonFilesDir: string;

implementation

type
  //Возвращает значение макроса
  TMacrosFunction = function : String;

  TMacrosInfo = record
    Name : String;
    Func : TMacrosFunction;
  end;

var
  Macros : array of TMacrosInfo;

function GetProgramFilesDirByKeyStr(KeyStr: string): string;
var
  dwKeySize: DWORD;
  Key: HKEY;
  dwType: DWORD;
begin
  if RegOpenKeyEx( HKEY_LOCAL_MACHINE, PChar(KeyStr), 0, KEY_READ, Key ) = ERROR_SUCCESS
  then
  try
    RegQueryValueEx( Key, 'ProgramFilesDir', nil, @dwType, nil, @dwKeySize );
    if (dwType in [REG_SZ, REG_EXPAND_SZ]) and (dwKeySize > 0) then
    begin
      SetLength( Result, dwKeySize );
      RegQueryValueEx( Key, 'ProgramFilesDir', nil, @dwType, PByte(PChar(Result)),
        @dwKeySize );
    end
    else
    begin
      RegQueryValueEx( Key, 'ProgramFilesPath', nil, @dwType, nil, @dwKeySize);
      if (dwType in [REG_SZ, REG_EXPAND_SZ]) and (dwKeySize > 0) then
      begin
        SetLength( Result, dwKeySize );
        RegQueryValueEx( Key, 'ProgramFilesPath', nil, @dwType, PByte(PChar(Result)),
          @dwKeySize );
      end;
    end;
  finally
    RegCloseKey( Key );
  end;
end;

function GetCommonFilesDirByKeyStr(KeyStr: string): string;
var
  dwKeySize: DWORD;
  Key: HKEY;
  dwType: DWORD;
begin
  if RegOpenKeyEx( HKEY_LOCAL_MACHINE, PChar(KeyStr), 0, KEY_READ, Key ) = ERROR_SUCCESS
  then
  try
    RegQueryValueEx( Key, 'CommonFilesDir', nil, @dwType, nil, @dwKeySize );
    if (dwType in [REG_SZ, REG_EXPAND_SZ]) and (dwKeySize > 0) then
    begin
      SetLength( Result, dwKeySize );
      RegQueryValueEx( Key, 'CommonFilesDir', nil, @dwType, PByte(PChar(Result)),
        @dwKeySize );
    end;
  finally
    RegCloseKey( Key );
  end;
end;

function GetProgramFilesDir: string;
const
  DefaultProgramFilesDir = '%SystemDrive%\Program Files';
var
  FolderName: string;
  dwStrSize: DWORD;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    FolderName := GetProgramFilesDirByKeyStr('Software\Microsoft\Windows NT\CurrentVersion');
  end;
  if Length(FolderName) = 0 then
  begin
    FolderName :=
      GetProgramFilesDirByKeyStr('Software\Microsoft\Windows\CurrentVersion');
  end;
  if Length(FolderName) = 0 then FolderName := DefaultProgramFilesDir;
  dwStrSize := ExpandEnvironmentStrings( PChar(FolderName), nil, 0 );
  SetLength( Result, dwStrSize );
  ExpandEnvironmentStrings( PChar(FolderName), PChar(Result), dwStrSize );
  Result := Trim(Result);
end;

function GetCommonFilesDir: string;
var
  FolderName: string;
//  dwStrSize: DWORD;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    FolderName := GetCommonFilesDirByKeyStr('Software\Microsoft\Windows NT\CurrentVersion');
  end;
  if Length(FolderName) = 0 then
  begin
    FolderName :=
      GetCommonFilesDirByKeyStr('Software\Microsoft\Windows\CurrentVersion');
  end;
  if Length(FolderName) = 0 then
    FolderName := GetProgramFilesDir + '\Common Files';
  Result := Trim(FolderName);
{
  dwStrSize := ExpandEnvironmentStrings( PChar(FolderName), nil, 0 );
  SetLength( Result, dwStrSize );
  ExpandEnvironmentStrings( PChar(FolderName), PChar(Result), dwStrSize );
}
end;


function ReplaceMacros(AInput : String) : String;
var
  I : Integer;
begin
  AInput := AnsiUpperCase(AInput);
  for I := Low(Macros) to High(Macros) do
    if Pos(Macros[i].Name, AInput) > 0 then begin
      Result := StringReplace(AInput, Macros[i].Name, Macros[i].Func, []);
      Exit;
    end;
  Result := AInput;
end;


initialization
  SetLength(Macros, 4);
  Macros[0].Name := '$(COMMONFILES)';
  Macros[0].Func := @GetCommonFilesDir;
  Macros[1].Name := '$(PROGRAMFILES)';
  Macros[1].Func := @GetProgramFilesDir;
  Macros[2].Name := '$(WINSYSPATH)';
  Macros[2].Func := @GetSystemDir;
  Macros[3].Name := '$(WINPATH)';
  Macros[3].Func := @GetWindowsDir;
end.
