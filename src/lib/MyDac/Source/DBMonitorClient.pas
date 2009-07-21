
{$IFNDEF CLR}

{$I Dac.inc}

unit DBMonitorClient;
{$ENDIF}
interface

uses
{$IFDEF MSWINDOWS}
  Windows, DBMonitorIntf,
{$ENDIF}
  Classes;

{$IFDEF MSWINDOWS}
  function GetDBMonitor: IDBMonitor;
  function GetDBMonitorVersion: AnsiString;
{$ENDIF}

  function HasMonitor: boolean;
  function WhereMonitor: string;

implementation

uses
  SysUtils
{$IFDEF CLR}
  ,System.IO
{$ENDIF}
{$IFDEF MSWINDOWS}
  ,ComObj, ActiveX, Registry
{$ENDIF};

{$IFDEF MSWINDOWS}
const
  sDBMonitorKey  = 'Software\Devart\DBMonitor';
  sDBMonitorKeyCR  = 'Software\CoreLab\DBMonitor';
{$ENDIF}

function WhereMonitor: string;
{$IFDEF MSWINDOWS}
var
  FRegIniFile: TRegIniFile;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  FRegIniFile := TRegIniFile.Create(sDBMonitorKey);
  try
    Result := FRegIniFile.ReadString('', 'Self', '');
  finally
    FRegIniFile.Free;
  end;

  if Result = '' then begin
    FRegIniFile := TRegIniFile.Create(sDBMonitorKeyCR);
    try
      Result := FRegIniFile.ReadString('', 'Self', '');
    finally
      FRegIniFile.Free;
    end;
  end;  
{$ELSE}
  Result := '';
{$ENDIF}
end;

function HasMonitor: boolean;
begin
{$IFDEF MSWINDOWS}
  Result := FileExists(WhereMonitor);
{$ELSE}
  Result := False;
{$ENDIF}
end;

{$IFDEF MSWINDOWS}
function GetDBMonitor: IDBMonitor;
var
{$IFDEF CLR}
  Obj: TObject;
{$ELSE}
  Res: HResult;
{$ENDIF}
begin
{$IFNDEF CLR}
  Res := CoCreateInstance(Class_DBMonitor, nil, CLSCTX_INPROC_SERVER, IDBMonitor, Result);
  if not Succeeded(Res) then
    if HasMonitor then
      raise Exception.Create('Current DBMonitor version is out of date. Please update.')
    else
      Result := nil;
{$ELSE}
  try
    Obj := CreateComObject(Class_DBMonitor);
    Result := Obj as IDBMonitor;
  except
    Result := nil;
    if HasMonitor then
      raise Exception.Create('Current DBMonitor version is out of date. Please update.');
  end;
{$ENDIF}
end;

function GetDBMonitorVersion: AnsiString;
var
  DBMonitor: IDBMonitor;
{$IFDEF CLR}
  Version: string;
{$ELSE}
  pVersion: PAnsiChar;
{$ENDIF}
begin
  result := 'not available';
  try
    DBMonitor := GetDBMonitor;
    if DBMonitor <> nil then begin
    {$IFDEF CLR}
      DBMonitor.GetVersion(Version);
      Result := Version;
    {$ELSE}
      CoInitialize(nil);
      try
        DBMonitor.GetVersion(pVersion);
      finally
        CoUninitialize;
      end;
      Result := AnsiString(pVersion);
    {$ENDIF}
    end
  except
  end;
end;

{$ENDIF}

end.
