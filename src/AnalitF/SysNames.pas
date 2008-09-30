unit SysNames;

interface

uses SysUtils, Windows;

function GetComputerName_: string;	// ��� ����������
function GetUserName_: string;		// ��� ������������

implementation

function GetComputerName_: string;
var
	Size: cardinal;
	PRes: PChar;
	BRes: boolean;
begin
	Size := MAX_COMPUTERNAME_LENGTH + 1;
	PRes := StrAlloc( Size);
	BRes := GetComputerName( PRes, Size);
	if BRes then result := StrPas( PRes)
		else result := '';
end;

function GetUserName_: string;
var
	Size: cardinal;
	PRes: PChar;
	BRes: boolean;
begin
	Size := MAX_COMPUTERNAME_LENGTH + 1;
	PRes := StrAlloc( Size);
	BRes := GetUserName( PRes, Size);
	if BRes then result := StrPas( PRes)
		else result := '';
end;

end.
