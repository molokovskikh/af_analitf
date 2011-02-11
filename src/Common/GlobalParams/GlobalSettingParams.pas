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
    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

{ TGlobalSettingParams }

procedure TGlobalSettingParams.ReadParams;
begin
  StoredUserId := GetParamDef('StoredUserId', '');
end;

procedure TGlobalSettingParams.SaveParams;
begin
  SaveParam('StoredUserId', StoredUserId);
  inherited;
end;

end.
