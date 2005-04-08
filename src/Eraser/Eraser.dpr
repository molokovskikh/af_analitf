library Eraser;

uses
  Windows,
  SysUtils,
  Classes;

{$R *.res}

procedure Erase; stdcall;
var
	SI: TStartupInfo;
	PI: TProcessInformation;
	i: integer;
  PH64 : Int64;
  PH : THandle;
  ExeName,
  ExePath,
  InDir,
  Switch : String;
  SR : TSearchRec;
begin
  try
    if TryStrToInt64(ParamStr(ParamCount-2), PH64) then begin
      PH := OpenProcess(SYNCHRONIZE, FALSE, PH64);
      if PH <> 0 then begin
        WaitForSingleObject(PH, 60000);
        CloseHandle(PH);
      end;
    end;
    InDir := ParamStr(ParamCount);
    ExeName := ParamStr(ParamCount-1);
    Switch := ParamStr(ParamCount-3);
    ExePath := ExtractFilePath(ExeName);
    if FindFirst(InDir + '\*.*', faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then begin
          for I := 1 to 20 do begin
        		if MoveFileEx(PChar(InDir + '\' + sr.Name), PChar(ExePath + sr.Name), MOVEFILE_REPLACE_EXISTING) then
              break;
            Sleep(500);
          end;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
    RemoveDirectory(PChar(InDir));
    FillChar( SI, SizeOf( SI), 0);
    SI.cb := SizeOf( SI);
    CreateProcess( nil, PChar( ExeName + ' ' +
      Switch), nil, nil, False,
      CREATE_DEFAULT_ERROR_MODE, nil,
      PChar( ExePath ), SI, PI);
  except
  end;
 	FreeLibrary( GetModuleHandle(nil) );
end;

exports Erase;

begin
end.
