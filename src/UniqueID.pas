unit UniqueID;

interface

uses Windows, SysUtils;

function GetUniqueID( APath, AVersion: string): longint;

implementation

uses CRC32Unit;

function GetUniqueID( APath, AVersion: string): longint;
var
	InVal: string;
	VolLabel, FileSystemName: array[ 0..MAX_PATH] of Char;
	NotUsed, VolFlags: DWORD;
	SerialNum: DWORD;
	Drive: PChar;
begin
	FileSystemName[ 0] := #$00;
	VolLabel[ 0] := #$00;

	Drive := 'C:\';
	GetVolumeInformation( Drive, VolLabel, DWORD( sizeof( VolLabel)),
		@SerialNum, NotUsed, VolFlags, FileSystemName, DWORD( sizeof( FileSystemName)));

	InVal := APath + AVersion + IntToHex( SerialNum, 8);
	result := CalcCRC32( PChar( InVal), Length( InVal));
end;

end.
