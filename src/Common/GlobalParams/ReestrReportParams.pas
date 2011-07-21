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
    //Номер реестра, берется из номера накладной
    ReestrNumber : String;
    //Дата реестра
    ReestrDate : TDateTime;
    //Члены коммисии 1
    CommitteeMember1 : String;
    //Члены коммисии 2
    CommitteeMember2 : String;
    //Члены коммисии 3
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
