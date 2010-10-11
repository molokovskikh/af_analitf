unit UniqueID;

interface

uses Windows, SysUtils;

function GetUniqueID( APath, AFileHash: string): longint;

function GetOld427UniqueID( APath, AVersion: string): longint;

function GetOld525UniqueID( APath, AFileHash: string): longint;

//Получить уникальный идентификатор относильно пути
function GetPathID( APath : string): Longint;

//Уникальный идентификатор, передаваемый при обновлении
function GetCopyID: LongInt;

//Уникальный идентификатор с учетом Hash'а приложения
function GetDBID: LongInt;

//Уникальный идентификатор с учетом Hash'а приложения старой версии
function GetOldDBID: LongInt;

//Получить идентификатор установки программы относительно пути, чтобы сохранять настройки программы в реестре
function GetPathCopyID: String;

implementation

uses
  Forms,
  CRC32Unit,
  AProc;

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

function GetCopyID: LongInt;
begin
{$ifdef NetworkVersion}
  result := StrToInt64('$4BDE55');
{$else}
{$ifdef DSP}
  result := StrToInt64('$E99E48');
{$else}
  result := GetUniqueID( Application.ExeName, '');
{$endif}
{$endif}
end;

function GetDBID: LongInt;
begin
{$ifdef NetworkVersion}
  result := StrToInt64('$4BDE55');
{$else}
{$ifdef DEBUG}
   result := GetUniqueID( Application.ExeName, 'E99E483DDE777778ADEFCB3DCD988BC9');
{$else}
  {$ifdef DSP}
    result := StrToInt64('$3DDE77');
  {$else}
    result := GetUniqueID( Application.ExeName, AProc.GetFileHash(Application.ExeName));
  {$endif}
{$endif}
{$endif}
end;

function GetOldDBID: LongInt;
begin
{$ifdef NetworkVersion}
  result := StrToInt64('$4BDE55');
{$else}
{$ifdef DSP}
  result := StrToInt64('$3DDE77');
{$else}
  result := GetUniqueID( Application.ExeName, AProc.GetFileHash(ExePath + SBackDir + '\' + ExtractFileName(Application.ExeName) + '.bak'));
{$endif}
{$endif}
end;


function GetPathCopyID: String;
begin
  Result := IntToHex( GetPathID(Application.ExeName), 8);
end;

end.
