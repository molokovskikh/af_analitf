unit AlphaUtils;

interface

uses Windows, Types, Controls, Classes, Graphics;

function Set32BPP: boolean;
function GetImageListAlpha( Owner: TComponent; ResPath: string; BaseIndex: integer; WH: integer): TImageList;

implementation

function IsWinXP: boolean;
var
	Version: DWORD;
	Major, Minor: DWORD;
begin
	Version := GetVersion;
	Major := DWORD( LOBYTE( LOWORD( Version)));
	Minor := DWORD( HIBYTE( LOWORD( Version)));
	result := False;

	if (( Version < $80000000) and                 // The OS is a NT family
		( Major >= 5) and ( Minor >= 1))       // Windows NT 5.1 is an Windows XP version
		then result := True;
end;

function ScreenBPP: integer;
var
	dc: HDC;
begin
	// Возвращает количество битов на точку в данном режиме
	result := 0;
	dc := GetDC( 0);
	if ( dc <> 0) then
	begin
		result := GetDeviceCaps( dc, BITSPIXEL);
		ReleaseDC( 0, dc);
	end;
end;

function Set32BPP: boolean;
begin
	result := ( IsWinXP and ( ScreenBPP >= 32));
end;

function GetImageListAlpha( Owner: TComponent; ResPath: string; BaseIndex: integer; WH: integer): TImageList;
var
	icon: TIcon;
	count: integer;
	hi: HICON;
	bm: TBitmap;
begin
	result := TImageList.Create( Owner);
	result.Width := WH;
	result.Height := WH;
	result.BlendColor := clFuchsia;

	count := 0;
	hi := LoadIcon( GetModuleHandle( PChar( ResPath)),
		MakeIntResource( BaseIndex + count));
	while ( hi <> 0) and ( count < 100) do
	begin
		icon := TIcon.Create;
		icon.Handle := hi;

		if Set32BPP then result.AddIcon( icon)
		else
		begin
			icon.Transparent := True;
			bm := TBitmap.Create;
			bm.Canvas.Brush.Color := clFuchsia;
			bm.Width := icon.Width;
			bm.Height := icon.Height;
			bm.Canvas.Draw( 0, 0, icon);
			result.AddMasked( bm, clFuchsia);
		end;
		inc( count);
		hi := LoadIcon( GetModuleHandle( PChar( ResPath)),
			MakeIntResource( BaseIndex + count));
	end;

end;

end.
