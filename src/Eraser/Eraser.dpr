library Eraser;

uses Windows, SysUtils;

{$R *.res}

procedure Erase; stdcall;
var
	SI: TStartupInfo;
	PI: TProcessInformation;
	i: integer;
begin
	for i := 1 to 20 do
	begin
		if DeleteFile( PChar( ParamStr( ParamCount - 1))) then break;
		Sleep( 500);
	end;
	MoveFile( PChar( ParamStr( ParamCount)), PChar( ParamStr( ParamCount - 1)));
	FillChar( SI, SizeOf( SI), 0);
	SI.cb := SizeOf( SI);
	CreateProcess( nil, PChar( ParamStr( ParamCount - 1) + ' ' +
		ParamStr( ParamCount - 2)), nil, nil, False,
		CREATE_DEFAULT_ERROR_MODE, nil,
		PChar( ExtractFilePath( ParamStr( ParamCount - 1))), SI, PI);
	FreeLibrary( GetModuleHandle( nil));
end;

exports Erase;

begin
end.
