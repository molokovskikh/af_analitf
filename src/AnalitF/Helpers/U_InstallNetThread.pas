unit U_InstallNetThread;

interface

uses
  Windows, Messages, SysUtils, Classes,
  AProc,
  StrUtils,
  ShellAPI,
  U_ExchangeLog;

const
  InstallNetLog = 'InstallNet';

type
  TInstallNetThread = class(TThread)
   private
    InstallFile : String;
   public
    Stopped : Boolean;
    function NeedInstallNet : Boolean;
    procedure DoInstallNet;
    function FileExecute(const FileName: string; Params: string='';
      StartDir: string=''; ShowFlag: Integer=SW_SHOWNORMAL; Wait: Boolean=False): Integer;
   protected
    procedure Execute; override;
  end;


implementation

{ TInstallNetThread }

procedure TInstallNetThread.DoInstallNet;
var
  resultInstall : Integer;
begin
  WriteExchangeLog(InstallNetLog, 'Начали установку Net');
  resultInstall := FileExecute(InstallFile, '/q /norestart', '', 1, True);
  if Self.Terminated then
    WriteExchangeLog(InstallNetLog, 'Нитка установки прервана');
  WriteExchangeLog(InstallNetLog, 'Результат установки: ' + IntToStr(resultInstall));
end;

procedure TInstallNetThread.Execute;
begin
  Stopped := False;
  try
    WriteExchangeLog(InstallNetLog, 'Стартовали нитку');
    if NeedInstallNet then
      DoInstallNet;
  except
    on E : Exception do
      WriteExchangeLog(InstallNetLog, 'Ошибка в нитке: ' + E.ClassName + ' ' + ExceptionToString(E));
  end;
  WriteExchangeLog(InstallNetLog, 'Нитка завершена');
  Stopped := True;
end;

function TInstallNetThread.NeedInstallNet: Boolean;
begin
  InstallFile := ExePath + 'InstallNet\dotNetFx40_Full_x86_x64.exe';
  Result := FileExists(InstallFile);
end;

function TInstallNetThread.FileExecute(const FileName: string; Params: string='';
  StartDir: string=''; ShowFlag: Integer=SW_SHOWNORMAL; Wait: Boolean=False): Integer;
var
  Info: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  FillChar(Info, SizeOf(Info), 0);
  Info.cbSize := SizeOf(TShellExecuteInfo);
  with Info do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    //Wnd := Application.Handle;
    Wnd := 0;
    lpFile := PChar(FileName);
    lpParameters := PChar(Params);
    lpDirectory := PChar(StartDir);
    lpVerb := 'runas';
    nShow := ShowFlag; //SW_SHOWNORMAL, SW_MINIMIZE, SW_SHOWMAXIMIZED, SW_HIDE
  end;
  Win32CheckA(ShellExecuteEx(@Info));
  if Wait then begin
    repeat
      Sleep(500);
      GetExitCodeProcess(Info.hProcess, ExitCode);
    until (ExitCode<>STILL_ACTIVE) or Self.Terminated;
    Result:=ExitCode;
  end
  else
    Result:=0;
end;

end.
