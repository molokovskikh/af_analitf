unit ReestrReportParams;

interface

uses
  SysUtils,
  Classes,
  MyAccess,
  GlobalParams;

type

  TReestrReportParams = class(TGlobalParams)
   public
    //����� �������, ������� �� ������ ���������
    ReestrNumber : String;
    //���� �������
    ReestrDate : TDateTime;
    //����� �������� 1
    CommitteeMember1 : String;
    //����� �������� 2
    CommitteeMember2 : String;
    //����� �������� 3
    CommitteeMember3 : String;

    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

{ TReestrReportParams }

procedure TReestrReportParams.ReadParams;
begin
  ReestrNumber := '';
  ReestrDate := Date();
  CommitteeMember1 := GetParamDef('ReestrReportCommitteeMember1', '');
  CommitteeMember2 := GetParamDef('ReestrReportCommitteeMember2', '');
  CommitteeMember3 := GetParamDef('ReestrReportCommitteeMember3', '');
end;

procedure TReestrReportParams.SaveParams;
begin
  SaveParam('ReestrReportCommitteeMember1', CommitteeMember1);
  SaveParam('ReestrReportCommitteeMember2', CommitteeMember2);
  SaveParam('ReestrReportCommitteeMember3', CommitteeMember3);
  inherited;
end;

end.
