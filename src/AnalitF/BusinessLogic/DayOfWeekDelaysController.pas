unit DayOfWeekDelaysController;

interface

uses
  SysUtils, Classes, Contnrs, DB, StrUtils, Variants,
  DateUtils,
  //App modules
  Constant, DModule, ExchangeParameters, U_ExchangeLog,
  DayOfWeekHelper,
  GlobalSettingParams;

type
  TDayOfWeekDelaysController = class
   public
    class function NeedUpdateDelays(dataLayer : TDM) : Boolean;
    class procedure UpdateDayOfWeek(dataLayer : TDM);
    class procedure RecalcOrdersByDelays();
  end;

implementation

{ TDayOfWeekDelaysController }

class function TDayOfWeekDelaysController.NeedUpdateDelays(
  dataLayer: TDM): Boolean;
var
  val : Variant;
  orderCount : Int64;
  settings : TGlobalSettingParams;
begin
  Result := False;
  if not dataLayer.adtClients.IsEmpty
    and dataLayer.adtClientsAllowDelayOfPayment.Value
    and not dataLayer.adtParams.FieldByName( 'UpdateDateTime').IsNull
    and (Date() > dataLayer.adtParams.FieldByName( 'UpdateDateTime').AsDateTime)
  then begin
    val := dataLayer.QueryValue('select count(*) from CurrentOrderHeads', [], []);
    if VarIsNull(val) then
      orderCount := 0
    else
      orderCount := val;

    if orderCount > 0 then begin
      settings := TGlobalSettingParams.Create(dataLayer.MainConnection);
      try
        Result := TDayOfWeekHelper.AnotherDay(settings.LastDayOfWeek);
      finally
        settings.Free;
      end;
    end;
  end;
end;

class procedure TDayOfWeekDelaysController.RecalcOrdersByDelays;
begin

end;

class procedure TDayOfWeekDelaysController.UpdateDayOfWeek(
  dataLayer: TDM);
var
  settings : TGlobalSettingParams;
begin
  settings := TGlobalSettingParams.Create(dataLayer.MainConnection);
  try
    settings.LastDayOfWeek := TDayOfWeekHelper.DayOfWeek();
    settings.SaveParams();
  finally
    settings.Free;
  end;
end;

end.
