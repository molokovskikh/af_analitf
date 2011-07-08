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
    //����� ���������
    WaybillNumber : String;
    //���� ���������
    WaybillDate : TDateTime;
    //����� ����
    ByWhomName : String;
    //����������
    RequestedName : String;
    //��������
    ServeName : String;
    //�������
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
