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
    //Группировать оригиналные накладные по поставщику
    GroupWaybillsBySupplier : Boolean;
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
  GroupWaybillsBySupplier := GetParamDef('GroupWaybillsBySupplier', False);
end;

procedure TGlobalSettingParams.SaveParams;
begin
  SaveParam('StoredUserId', StoredUserId);
  SaveParam('LastDayOfWeek', LastDayOfWeek);
  SaveParam('UseProducerCostWithNDS', UseProducerCostWithNDS);
  SaveParam('GroupWaybillsBySupplier', GroupWaybillsBySupplier);
  inherited;
end;

end.
