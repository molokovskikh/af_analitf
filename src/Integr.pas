unit Integr;

interface

uses ADODB, StdCtrls, ComCtrls, Windows;

type

{ Вызывает форму настройки сервиса импорта прайс-файлов }
{ HomeRegionCode - код  региона, в котором находится активный пользователь, }
{ AHandle := Application.Handle }
TIntegrConfig = procedure( ADOConnection: TADOConnection;
	HomeRegionCode: integer; AHandle: THandle);

TIntegrThreading = procedure( AHandle: THandle; ADOConnection: TADOConnection;
	HomeRegionCode: integer; inStStatus: TLabel; inProgressBar: TProgressBar;
	inTotalProgressBar: TProgressBar; Async: boolean = False);

{ OutCount будет содержать количество прайс-листов, которые подвергнуться импорту }
TIntegrTotalWellPrices = procedure( ADOConnection: TADOConnection;
	HomeRegionCode: integer; var OutCount: Word);

var
	hDLL: THandle;
	IntegrConfig: TIntegrConfig;
	IntegrThreading: TIntegrThreading;
	IntegrTotalWellPrices: TIntegrTotalWellPrices;

function LoadIntegrDLL: boolean;
function IsIntegrDLLPresent: boolean;

implementation

function LoadIntegrDLL: boolean;
begin
	result := True;
	try
		hDLL := LoadLibrary( 'Integr.dll');
		if hDLL <> 0 then
		begin
			@IntegrConfig := GetProcAddress( hDLL, 'IntegrConfig');
			@IntegrThreading := GetProcAddress( hDLL, 'IntegrThreading');
			@IntegrTotalWellPrices := GetProcAddress( hDLL, 'IntegrTotalWellPrices');

			if ( Addr( IntegrConfig) = nil) or ( Addr( IntegrThreading) = nil) or
				( Addr( IntegrTotalWellPrices) = nil) then result := False;
		end
		else
			result := False;
	except
		result := False;
		hDLL := 0;
	end;
end;

function IsIntegrDLLPresent: boolean;
begin
	result := hDLL <> 0;
end;

end.
