unit WaybillReportParams;

interface

uses
  SysUtils,
  Classes,
  MyAccess,
  GlobalParams;

type

  TWaybillReportParams = class(TGlobalParams)
   public
    //Номер накладной
    WaybillNumber : String;
    //Дата накладной
    WaybillDate : TDateTime;
    //Через кого
    ByWhomName : String;
    //Затребовал
    RequestedName : String;
    //Отпустил
    ServeName : String;
    //Получил
    ReceivedName : String;

    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

{ TWaybillReportParams }

procedure TWaybillReportParams.ReadParams;
begin
  WaybillNumber := '';
  WaybillDate := Date();
  ByWhomName := GetParamDef('WaybillReportByWhomName', '');
  RequestedName := GetParamDef('WaybillReportRequestedName', '');
  ServeName := GetParamDef('WaybillReportServeName', '');
  ReceivedName := GetParamDef('WaybillReportReceivedName', '');
end;

procedure TWaybillReportParams.SaveParams;
begin
  SaveParam('WaybillReportByWhomName', ByWhomName);
  SaveParam('WaybillReportRequestedName', RequestedName);
  SaveParam('WaybillReportServeName', ServeName);
  SaveParam('WaybillReportReceivedName', ReceivedName);
  inherited;
end;

end.
