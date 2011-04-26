unit GlobalSettingParams;

interface

uses
  SysUtils,
  Classes,
  Variants,
  MyAccess,
  GlobalParams;

type
  TGlobalSettingParams = class(TGlobalParams)
   public
    StoredUserId : String;
    LastDayOfWeek : String;
    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

{ TGlobalSettingParams }

procedure TGlobalSettingParams.ReadParams;
begin
  StoredUserId := GetParamDef('StoredUserId', '');
  LastDayOfWeek := GetParamDef('LastDayOfWeek', '');
end;

procedure TGlobalSettingParams.SaveParams;
begin
  SaveParam('StoredUserId', StoredUserId);
  SaveParam('LastDayOfWeek', LastDayOfWeek);
  inherited;
end;

end.
