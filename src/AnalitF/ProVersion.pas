unit ProVersion;
// Подходит только для поектов компилированых под русский язык
// LocalID = $0419
// Charset = $04E3

interface

uses Windows, SysUtils;

const
	LANG_CHARSET = '041904E3';

type

TVerInfo = record
	CompanyName: string;
	FileDescription: string;
	FileVersion: string;
	InternalName: string;
	LegalCopyright: string;
	LegalTradeMarks: string;
	OriginalFileName: string;
	ProductName: string;
	ProductVersion: string;
	Comments: string;
end;

function VersionInformation( ExeName: string; var VerInfo: TVerInfo): boolean;

implementation

function VersionInformation( ExeName: string; var VerInfo: TVerInfo): boolean;
var
	n, Len: Longword; //DWORD
	Buf: PChar;
	Value: PChar;
begin
	n := GetFileVersionInfoSize( PChar( ExeName), n);
	if n > 0 then
	begin
		Buf := AllocMem( n);
		GetFileVersionInfo( PChar( ExeName), 0, n, Buf);
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\CompanyName'), Pointer( Value), Len) then VerInfo.CompanyName := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\FileDescription'), Pointer( Value), Len) then VerInfo.FileDescription := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\FileVersion'), Pointer( Value), Len) then VerInfo.FileVersion := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\InternalName'), Pointer( Value), Len) then VerInfo.InternalName := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\LegalCopyright'), Pointer( Value), Len) then VerInfo.LegalCopyright := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\LegalTradeMarks'), Pointer( Value), Len) then VerInfo.LegalTradeMarks := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\OriginalFileName'), Pointer( Value), Len) then VerInfo.OriginalFileName := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\ProductName'), Pointer( Value), Len) then VerInfo.ProductName := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\ProductVersion'), Pointer( Value), Len) then VerInfo.ProductVersion := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\Comments'), Pointer( Value), Len) then VerInfo.Comments := Value;
		FreeMem( Buf, n);
		result := True;
	end
	else
		result := False;
end;


end.
