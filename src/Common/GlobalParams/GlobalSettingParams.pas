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
    UseProducerCostWithNDS : Boolean;
    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

{ TGlobalSettingParams }

procedure TGlobalSettingParams.ReadParams;
begin
  StoredUserId := GetParamDef('StoredUserId', '');
  LastDayOfWeek := GetParamDef('LastDayOfWeek', '');
  UseProducerCostWithNDS := GetParamDef('UseProducerCostWithNDS', False);
end;

procedure TGlobalSettingParams.SaveParams;
begin
  SaveParam('StoredUserId', StoredUserId);
  SaveParam('LastDayOfWeek', LastDayOfWeek);
  SaveParam('UseProducerCostWithNDS', UseProducerCostWithNDS);
  inherited;
end;

end.
