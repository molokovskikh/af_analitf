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
    //Срок хранения накладных
    WaybillsHistoryDayCount : Integer;
    //Подтверждать удаление устаревшних накладных
    ConfirmDeleteOldWaybills : Boolean;
    procedure ReadParams; override;
    procedure SaveParams; override;
    class function GetConfirmDeleteOldWaybills(Connection : TCustomMyConnection) : Boolean;
    class function GetWaybillsHistoryDayCount(Connection : TCustomMyConnection) : Integer;
  end;

implementation

{ TGlobalSettingParams }

class function TGlobalSettingParams.GetConfirmDeleteOldWaybills(Connection : TCustomMyConnection): Boolean;
begin
  Result := TGlobalParamsHelper.GetParamDef(Connection, 'ConfirmDeleteOldWaybills', True);
end;

class function TGlobalSettingParams.GetWaybillsHistoryDayCount(Connection : TCustomMyConnection): Integer;
begin
  Result := TGlobalParamsHelper.GetParamDef(Connection, 'WaybillsHistoryDayCount', 150);
end;

procedure TGlobalSettingParams.ReadParams;
begin
  StoredUserId := GetParamDef('StoredUserId', '');
  LastDayOfWeek := GetParamDef('LastDayOfWeek', '');
  UseProducerCostWithNDS := GetParamDef('UseProducerCostWithNDS', False);
  GroupWaybillsBySupplier := GetParamDef('GroupWaybillsBySupplier', False);
  WaybillsHistoryDayCount := GetParamDef('WaybillsHistoryDayCount', 150);
  ConfirmDeleteOldWaybills := GetParamDef('ConfirmDeleteOldWaybills', True);
end;

procedure TGlobalSettingParams.SaveParams;
begin
  SaveParam('StoredUserId', StoredUserId);
  SaveParam('LastDayOfWeek', LastDayOfWeek);
  SaveParam('UseProducerCostWithNDS', UseProducerCostWithNDS);
  SaveParam('GroupWaybillsBySupplier', GroupWaybillsBySupplier);
  SaveParam('WaybillsHistoryDayCount', WaybillsHistoryDayCount);
  SaveParam('ConfirmDeleteOldWaybills', ConfirmDeleteOldWaybills);
  inherited;
end;

end.
