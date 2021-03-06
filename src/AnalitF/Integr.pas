unit Integr;

interface

uses {ADODB,} StdCtrls, ComCtrls, Windows;

//type

{ �������� ����� ��������� ������� ������� �����-������ }
{ HomeRegionCode - ���  �������, � ������� ��������� �������� ������������, }
{ AHandle := Application.Handle }
{
TIntegrConfig = procedure( ADOConnection: TADOConnection;
  HomeRegionCode: integer; AHandle: THandle);
  }

{
TIntegrThreading = procedure( AHandle: THandle; ADOConnection: TADOConnection;
  HomeRegionCode: integer; inStStatus: TLabel; inProgressBar: TProgressBar;
  inTotalProgressBar: TProgressBar; Async: boolean = False);
}

{ OutCount ����� ��������� ���������� �����-������, ������� ������������� ������� }
{
TIntegrTotalWellPrices = procedure( ADOConnection: TADOConnection;
  HomeRegionCode: integer; var OutCount: Word);
}  

var
  hDLL: THandle;
  {
  IntegrConfig: TIntegrConfig;
  IntegrThreading: TIntegrThreading;
  IntegrTotalWellPrices: TIntegrTotalWellPrices;
}

function LoadIntegrDLL: boolean;
procedure UnLoadIntegrDLL;
function IsIntegrDLLPresent: boolean;

implementation

function LoadIntegrDLL: boolean;
begin
  result := True;
  try
    hDLL := LoadLibrary( 'Integr.dll');
    if hDLL <> 0 then
    begin
{
      @IntegrConfig := GetProcAddress( hDLL, 'IntegrConfig');
      @IntegrThreading := GetProcAddress( hDLL, 'IntegrThreading');
      @IntegrTotalWellPrices := GetProcAddress( hDLL, 'IntegrTotalWellPrices');


      if ( Addr( IntegrConfig) = nil) or ( Addr( IntegrThreading) = nil) or
        ( Addr( IntegrTotalWellPrices) = nil) then result := False;
}
      result := False;
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

procedure UnLoadIntegrDLL;
begin
  if hDLL <> 0 then begin
    FreeLibrary(hDLL);
{
    IntegrConfig := nil;
    IntegrThreading := nil;
    IntegrTotalWellPrices := nil;
}    
    hDLL := 0;
  end;
end;

initialization
  LoadIntegrDLL;
finalization
  UnLoadIntegrDLL;
end.
