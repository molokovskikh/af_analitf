unit UniqueID;

interface

uses Windows, SysUtils;

function GetUniqueID( APath, AFileHash: string): longint;

function GetOld427UniqueID( APath, AVersion: string): longint;

function GetOld525UniqueID( APath, AFileHash: string): longint;

//Получить уникальный идентификатор относильно пути
function GetPathID( APath : string): Longint;

function GetExclusiveID : String;

implementation

uses CRC32Unit;

function GetUniqueID( APath, AFileHash: string): longint;
var
	InVal: string;
	VolLabel, FileSystemName: array[ 0..MAX_PATH] of Char;
	NotUsed, VolFlags: DWORD;
	SerialNum: DWORD;
	Drive: PChar;
begin
	FileSystemName[ 0] := #$00;
	VolLabel[ 0] := #$00;
  SerialNum := 0;
  //приводим все в нижний регистр, чтобы все было одинаково, а то в зависимости от того как написали путь GetUniqueID будет разный
  APath := LowerCase(APath);

	Drive := PChar(ExtractFileDrive(APAth) + '\');
	GetVolumeInformation( Drive, VolLabel, DWORD( sizeof( VolLabel)),
		@SerialNum, NotUsed, VolFlags, FileSystemName, DWORD( sizeof( FileSystemName)));

	InVal := APath + AFileHash + IntToHex( SerialNum, 8);
	result := CalcCRC32( PChar( InVal), Length( InVal));
end;

function GetOld427UniqueID( APath, AVersion: string): longint;
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

function GetOld525UniqueID( APath, AFileHash: string): longint;
var
	InVal: string;
	VolLabel, FileSystemName: array[ 0..MAX_PATH] of Char;
	NotUsed, VolFlags: DWORD;
	SerialNum: DWORD;
	Drive: PChar;
begin
	FileSystemName[ 0] := #$00;
	VolLabel[ 0] := #$00;
  SerialNum := 0;

	Drive := PChar(ExtractFileDrive(APAth) + '\');
	GetVolumeInformation( Drive, VolLabel, DWORD( sizeof( VolLabel)),
		@SerialNum, NotUsed, VolFlags, FileSystemName, DWORD( sizeof( FileSystemName)));

	InVal := APath + AFileHash + IntToHex( SerialNum, 8);
	result := CalcCRC32( PChar( InVal), Length( InVal));
end;

function GetPathID( APath : string): Longint;
var
	InVal: string;
begin
	InVal := LowerCase(APath);
	Result := CalcCRC32( PChar( InVal), Length( InVal));
end;

function GetExclusiveID : String;
begin
  Result := IntToHex(GetUniqueID( ParamStr(0), ''), 8);
end;

end.
