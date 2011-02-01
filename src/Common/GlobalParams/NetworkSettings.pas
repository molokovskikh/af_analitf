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
    IsNetworkVersion : Boolean;
    Server : String;
    Username : String;
    Password : String;
    Port : Integer;
    ShareFolderName : String;
    DisableUpdate : Boolean;
    DisableSendOrders : Boolean;
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
  IsNetworkVersion := False;
  FSettingFileName := ChangeFileExt(ParamStr(0), '.config');
  Server := 'localhost';
  Username := 'root';
  Password := '';
  Port := 3306;
  ShareFolderName := 'AnalitF';
  DisableUpdate := False;
  DisableSendOrders := False;
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
    IsNetworkVersion := sl.Values['IsNetworkVersion'] = '1';
    Server := sl.Values['Server'];
    Username := sl.Values['Username'];
    Password := sl.Values['Password'];
    ShareFolderName := sl.Values['ShareFolderName'];
    Port := StrToIntDef(sl.Values['Port'], 3306);
    DisableUpdate := sl.Values['DisableUpdate'] = '1';
    DisableSendOrders := sl.Values['DisableSendOrders'] = '1';
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
