unit NetworkSettings;

interface

uses
  SysUtils,
  Classes;

type
  TNetworkSettings = class
   private
    FSettingFileName : String;
   public
    Server : String;
    Username : String;
    Password : String;
    Port : Integer;
    ShareFolderName : String;
    constructor Create();
    function SettingsExists() : Boolean;
    procedure ReadSettings();
  end;

  function GetNetworkSettings() : TNetworkSettings;

implementation

var
  FNetworkSettings : TNetworkSettings;

function GetNetworkSettings() : TNetworkSettings;
begin
  Result := FNetworkSettings;
end;

{ TNetworkSettings }

constructor TNetworkSettings.Create;
begin
  FSettingFileName := ChangeFileExt(ParamStr(0), '.config');
  Server := 'localhost';
  Username := 'root';
  Password := '';
  Port := 3306;
  ShareFolderName := 'AnalitF';
  if SettingsExists then
    ReadSettings;
end;

procedure TNetworkSettings.ReadSettings;
var
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(FSettingFileName);
    Server := sl.Values['Server'];
    Username := sl.Values['Username'];
    Password := sl.Values['Password'];
    ShareFolderName := sl.Values['ShareFolderName'];
    Port := StrToIntDef(sl.Values['Port'], 3306);
  finally
    sl.Free;
  end;
end;

function TNetworkSettings.SettingsExists: Boolean;
begin
  Result := FileExists(FSettingFileName);
end;

initialization
  FNetworkSettings := TNetworkSettings.Create();
end.
