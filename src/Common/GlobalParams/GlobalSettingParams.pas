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
    //√руппировать оригиналные накладные по поставщику
    GroupWaybillsBySupplier : Boolean;
    //—рок хранени€ накладных
    WaybillsHistoryDayCount : Integer;
    //ѕодтверждать удаление устаревшних накладных
    ConfirmDeleteOldWaybills : Boolean;
    BaseFirmCategory : Integer;
    Excess : Integer;
    ExcessAvgOrderTimes : Integer;
    DeltaMode : Integer;
    ShowPriceName : Boolean;
    UseColorOnWaybillOrders : Boolean;
    ShowRejectsReason : Boolean;
    //¬рем€ последнего успешного запроса, когда были получены новые изменени€ в забраковке
    LastRequestWithRejects : TDateTime;
    //глубина истории дл€ отображени€ изменений в забраковке
    NewRejectsDayCount : Integer;
    procedure ReadParams; override;
    procedure SaveParams; override;
    procedure SaveShowRejectsReason;
    class function GetConfirmDeleteOldWaybills(Connection : TCustomMyConnection) : Boolean;
    class function GetWaybillsHistoryDayCount(Connection : TCustomMyConnection) : Integer;
    class procedure SaveLastRequestWithRejects(Connection : TCustomMyConnection; lastRequestWithRejects : TDateTime);
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
var
  lastRequestWithRejectsVariant : Variant;
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
  UseColorOnWaybillOrders := GetParamDef('UseColorOnWaybillOrders', True);
  ShowRejectsReason := GetParamDef('ShowRejectsReason', False);
  lastRequestWithRejectsVariant := GetParamDef('LastRequestWithRejects', EncodeDate(2012, 09, 01));
  LastRequestWithRejects := VarToDateTime(lastRequestWithRejectsVariant);
  NewRejectsDayCount := GetParamDef('NewRejectsDayCount', 7);
end;

class procedure TGlobalSettingParams.SaveLastRequestWithRejects(
  Connection: TCustomMyConnection; lastRequestWithRejects: TDateTime);
begin
  TGlobalParamsHelper.SaveParam(Connection, 'LastRequestWithRejects', lastRequestWithRejects);
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
  SaveParam('UseColorOnWaybillOrders', UseColorOnWaybillOrders);
  SaveShowRejectsReason;
  SaveLastRequestWithRejects(FConnection, LastRequestWithRejects);
  SaveParam('NewRejectsDayCount', NewRejectsDayCount);
  inherited;
end;

procedure TGlobalSettingParams.SaveShowRejectsReason;
begin
  SaveParam('ShowRejectsReason', ShowRejectsReason);
end;

end.
