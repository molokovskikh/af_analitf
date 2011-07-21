unit U_ReestrPrintSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  DModule,
  U_PrintSettingsForm,
  ReestrReportParams;

type
  TReestrPrintSettingsForm = class(TPrintSettingsForm)
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    eNumber : TEdit;
    dtpDate : TDateTimePicker;
    eCommitteeMember1 : TEdit;
    eCommitteeMember2 : TEdit;
    eCommitteeMember3 : TEdit;
    procedure CreateVisibleComponents; override;
    procedure BeforeClose; override;
  public
    { Public declarations }
    ReestrReportParams : TReestrReportParams;
    procedure UpdateParams(number : String; reestrDate : TDateTime);
  end;

var
  ReestrPrintSettingsForm: TReestrPrintSettingsForm;

implementation

uses DateUtils;

{$R *.dfm}

{ TReestrPrintSettingsForm }

procedure TReestrPrintSettingsForm.BeforeClose;
begin
  ReestrReportParams.ReestrNumber := eNumber.Text;
  ReestrReportParams.ReestrDate := dtpDate.Date;

  ReestrReportParams.CommitteeMember1 := eCommitteeMember1.Text;
  ReestrReportParams.CommitteeMember2 := eCommitteeMember2.Text;
  ReestrReportParams.CommitteeMember3 := eCommitteeMember3.Text;
  ReestrReportParams.SaveParams;
end;

procedure TReestrPrintSettingsForm.CreateVisibleComponents;
var
  l : TLabel;
  maxLeft : Integer;
begin
  ReestrReportParams := TReestrReportParams.Create(DM.MainConnection);

  Self.Caption := 'Настройки печати реестра';

  inherited;

  l := AddLabel(5, 'Члены комиссии');
  maxLeft := l.Left + l.Width + 15;
  l.Caption := 'Реестр №';
  eNumber := AddEdit(l.Top, maxLeft, ReestrReportParams.ReestrNumber);

  l := AddLabel(10 + l.Top + l.Height, 'Дата');
  dtpDate := AddDateTimePicker(l.Top, maxLeft);

  l := AddLabel(10 + l.Top + l.Height, 'Члены комиссии');
  eCommitteeMember1 := AddEdit(l.Top, maxLeft, ReestrReportParams.CommitteeMember1);

  eCommitteeMember2 := AddEdit(10 + eCommitteeMember1.Top + l.Height, maxLeft, ReestrReportParams.CommitteeMember2);

  eCommitteeMember3 := AddEdit(10 + eCommitteeMember2.Top + l.Height, maxLeft, ReestrReportParams.CommitteeMember3);

  pSettings.Width := eNumber.Left + eNumber.Width + 30;

  pSettings.Height := eCommitteeMember3.Top + eCommitteeMember3.Height + 20;
end;

procedure TReestrPrintSettingsForm.UpdateParams(number: String;
  reestrDate: TDateTime);
begin
  eNumber.Text := number;
  ReestrReportParams.ReestrNumber := number;

  ReestrReportParams.ReestrDate := DateOf(reestrDate);
  dtpDate.Date := ReestrReportParams.ReestrDate;
end;

procedure TReestrPrintSettingsForm.FormDestroy(Sender: TObject);
begin
  ReestrReportParams.Free;
  inherited;
end;

end.
