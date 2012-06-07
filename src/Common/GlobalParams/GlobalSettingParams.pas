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
    //Группировать оригиналные накладные по поставщику
    GroupWaybillsBySupplier : Boolean;
    //Срок хранения накладных
    WaybillsHistoryDayCount : Integer;
    //Подтверждать удаление устаревшних накладных
    ConfirmDeleteOldWaybills : Boolean;
    BaseFirmCategory : Integer;
    Excess : Integer;
    ExcessAvgOrderTimes : Integer;
    DeltaMode : Integer;
    ShowPriceName : Boolean;
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
  GroupWaybillsBySupplier := GetParamDef('GroupWaybillsBySupplier', False);
  WaybillsHistoryDayCount := GetParamDef('WaybillsHistoryDayCount', 150);
  ConfirmDeleteOldWaybills := GetParamDef('ConfirmDeleteOldWaybills', True);
  BaseFirmCategory := GetParamDef('BaseFirmCategory', 0);
  Excess  := GetParamDef('Excess', 5);
  ExcessAvgOrderTimes := GetParamDef('ExcessAvgOrderTimes', 5);
  DeltaMode := GetParamDef('DeltaMode', 1);
  if (DeltaMode < 0) or (DeltaMode > 2) then
    DeltaMode := 1;
  ShowPriceName := GetParamDef('ShowPriceName', False);
end;

procedure TGlobalSettingParams.SaveParams;
begin
  SaveParam('StoredUserId', StoredUserId);
  SaveParam('LastDayOfWeek', LastDayOfWeek);
  SaveParam('GroupWaybillsBySupplier', GroupWaybillsBySupplier);
  SaveParam('WaybillsHistoryDayCount', WaybillsHistoryDayCount);
  SaveParam('ConfirmDeleteOldWaybills', ConfirmDeleteOldWaybills);
  SaveParam('BaseFirmCategory', BaseFirmCategory);
  SaveParam('Excess', Excess);
  SaveParam('ExcessAvgOrderTimes', ExcessAvgOrderTimes);
  SaveParam('DeltaMode', DeltaMode);
  SaveParam('ShowPriceName', ShowPriceName);
  inherited;
end;

end.
