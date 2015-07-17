unit U_InstallNetThread;

interface

uses
  Windows, Messages, SysUtils, Classes,
  AProc,
  StrUtils,
  ShellAPI,
  U_ExchangeLog,
  UrlMon,
  Registry;

const
  InstallNetLog = 'InstallNet';

type
  TOKEN_ELEVATION = record
    TokenIsElevated: DWORD;
  end;

  TInstallNetThread = class(TThread)
  public
    Stopped: boolean;
  protected
    procedure Execute; override;
  end;


implementation

{ TInstallNetThread }

procedure TInstallNetThread.Execute;
var
  url: string;
  version: TOsVersionInfo;
  tmpPath: string;
  tmpfile: string;
  filename: string;
  dotPos: integer;
  info: TShellExecuteInfo;
  exitCode: DWORD;
  result: HResult;
  size: integer;
  reg : TRegistry;
  install: integer;
  release: integer;
  processToken: THandle;
  elevation: TOKEN_ELEVATION;
  elevationSize: DWORD;
begin
  Stopped := False;
  try
  try
    WriteExchangeLog(InstallNetLog, 'Стартовали нитку');

    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full') then begin
      install := 0;
      release := 0;
      try
        install := reg.ReadInteger('Install')
      except
      end;
      try
        release := reg.ReadInteger('Release')
      except
      end;
      if install = 1 then begin
        WriteExchangeLog(InstallNetLog, '.net уже установлен, релиз ' + IntToStr(release));
        exit;
      end
    end;

    WriteExchangeLog(InstallNetLog, '.net не установлен');
    FillChar(version, SizeOf(TOsVersionInfo), 0);
    version.dwOSVersionInfoSize := sizeof(version);
    url := 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe';
    GetVersionEx(version);
    if (version.dwMajorVersion > 5) then begin
      url := 'http://go.microsoft.com/fwlink/?LinkId=397707';
      //если мы на висте и выше нужно проверить uac и выйте если проверка не прошла
      if OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, processToken) then begin
         if GetTokenInformation(processToken, TTokenInformationClass(20) {TokenElevation}, Addr(elevation), SizeOf(TOKEN_ELEVATION), elevationSize) then begin
            if elevation.TokenIsElevated = 0 then begin
              WriteExchangeLog(InstallNetLog, 'не прав для установки, отмена');
              exit;
            end;
         end;
      end;
    end;

    SetLength(tmpPath, MAX_PATH);
    size := GetTempPath(MAX_PATH, PChar(tmpPath));
    Win32CheckA(size <> 0);
    SetLength(tmpPath, size);

    SetLength(filename, MAX_PATH);
    SetLength(tmpfile, MAX_PATH);
    Win32CheckA(GetTempFileName(PChar(tmpPath), PChar('NDP'), 0, PChar(tmpfile)) <> 0);
    tmpfile := PChar(tmpfile);
    filename := tmpfile + '.exe';

    WriteExchangeLog(InstallNetLog, 'Загружаю ' + url);
    result := URLDownloadToFile(nil, PChar(url), PChar(filename), 0, nil);
    if result <> S_OK then begin
      WriteExchangeLog(InstallNetLog, 'Не удалось загрузить установщик, код ошибки ' + IntToStr(result));
      exit;
    end;
    WriteExchangeLog(InstallNetLog, 'Загружен ' + url + ' в ' + filename);
    FillChar(Info, SizeOf(info), 0);
    info.cbSize := SizeOf(TShellExecuteInfo);
    info.fMask := SEE_MASK_NOCLOSEPROCESS;
    info.lpVerb := PChar('open');
    info.lpFile := PChar(filename);
    info.lpParameters := PChar('/q /norestart');
    info.nShow := SW_SHOW;
    Win32CheckA(ShellExecuteEx(@Info));
    WaitForSingleObject(info.hProcess, INFINITE);
    Win32CheckA(GetExitCodeProcess(info.hProcess, exitCode));
    WriteExchangeLog(InstallNetLog, 'Установка завершена, код выхода ' + IntToStr(exitCode));
  except
    on E : Exception do
      WriteExchangeLog(InstallNetLog, 'Ошибка в нитке: ' + E.ClassName + ' ' + ExceptionToString(E));
  end;
  finally
    if (info.hProcess <> THandle(0)) and (info.hProcess <> INVALID_HANDLE_VALUE) then
      CloseHandle(info.hProcess);
    DeleteFile(tmpfile);
    DeleteFile(filename);
    if reg <> nil then
      reg.Free();
  end;
  WriteExchangeLog(InstallNetLog, 'Нитка завершена');
  Stopped := True;
end;

end.
