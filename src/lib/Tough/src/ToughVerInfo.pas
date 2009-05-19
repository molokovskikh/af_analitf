unit ToughVerInfo;

interface

uses
	SysUtils, Classes, Windows, StrUtils;

const
	LANG_CHARSET = '041904E3';

type

TToughVerInfo = class(TComponent)
private
	FCompanyName: string;
	FFileDescription: string;
	FFileVersion: string;
	FInternalName: string;
	FLegalCopyright: string;
	FLegalTradeMarks: string;
	FOriginalFileName: string;
	FProductName: string;
	FProductVersion: string;
	FComments: string;
	FFileName: string;

	procedure GetVerInfo;
	procedure ClearInfo;
	procedure SetFileName( Value: string);
public
	constructor Create( AOwner: TComponent); override;
	destructor Destroy; override;
published
	property CompanyName: string read FCompanyName write FCompanyName;
	property FileDescription: string read FFileDescription write FFileDescription;
	property FileVersion: string read FFileVersion write FFileVersion;
	property InternalName: string read FInternalName write FInternalName;
	property LegalCopyright: string read FLegalCopyright write FLegalCopyright;
	property LegalTradeMarks: string read FLegalTradeMarks write FLegalTradeMarks;
	property OriginalFileName: string read FOriginalFileName write FOriginalFileName;
	property ProductName: string read FProductName write FProductName;
	property ProductVersion: string read FProductVersion write FProductVersion;
	property Comments: string read FComments write FComments;
	property FileName: string read FFileName write SetFileName;
end;

procedure Register;

implementation

constructor TToughVerInfo.Create(AOwner: TComponent);
{var
	AppName: string;}
begin
	inherited;
{
	try
		AppName := Application.ExeName;
		if AnsiLowerCase( RightStr( AppName, 12)) = 'delphi32.exe' then raise Exception.Create( 'Delphi IDE');
	except
		exit;
	end;
	FileName := AppName;}
end;

destructor TToughVerInfo.Destroy;
begin
	inherited;
end;

procedure TToughVerInfo.GetVerInfo;
var
	n, Len: Longword; //DWORD
	Buf: PChar;
	Value: PChar;
begin
	ClearInfo;
	n := GetFileVersionInfoSize( PChar( FileName), n);
	if n > 0 then
	begin
		Buf := AllocMem( n);
		GetFileVersionInfo( PChar( FileName), 0, n, Buf);
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\CompanyName'), Pointer( Value), Len) then CompanyName := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\FileDescription'), Pointer( Value), Len) then FileDescription := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\FileVersion'), Pointer( Value), Len) then FileVersion := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\InternalName'), Pointer( Value), Len) then InternalName := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\LegalCopyright'), Pointer( Value), Len) then LegalCopyright := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\LegalTradeMarks'), Pointer( Value), Len) then LegalTradeMarks := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\OriginalFileName'), Pointer( Value), Len) then OriginalFileName := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\ProductName'), Pointer( Value), Len) then ProductName := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\ProductVersion'), Pointer( Value), Len) then ProductVersion := Value;
		if VerQueryValue( Buf, PChar( '\StringFileInfo\' + LANG_CHARSET + '\Comments'), Pointer( Value), Len) then Comments := Value;
		FreeMem( Buf, n);
	end;
end;

procedure TToughVerInfo.ClearInfo;
begin
	FCompanyName := '';
	FFileDescription := '';
	FFileVersion := '';
	FInternalName := '';
	FLegalCopyright := '';
	FLegalTradeMarks := '';
	FOriginalFileName := '';
	FProductName := '';
	FProductVersion := '';
	FComments := '';
end;

procedure TToughVerInfo.SetFileName(Value: string);
begin
	FFileName := Value;
	GetVerInfo;
end;

procedure Register;
begin
	RegisterComponents( 'Tough', [TToughVerInfo]);
end;

end.
