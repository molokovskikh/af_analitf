unit U_WaybillPrintSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  DModule,
  U_PrintSettingsForm,
  WaybillReportParams;

type
  TWaybillPrintSettingsForm = class(TPrintSettingsForm)
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    eNumber : TEdit;
    dtpDate : TDateTimePicker;
    eByWhomName : TEdit;
    eRequestedName : TEdit;
    eServeName : TEdit;
    eReceivedName : TEdit;
    procedure CreateVisibleComponents; override;
    procedure BeforeClose; override;
  public
    { Public declarations }
    WaybillReportParams : TWaybillReportParams;
    procedure UpdateParams(number : String; waybillDate : TDateTime);
  end;

var
  WaybillPrintSettingsForm: TWaybillPrintSettingsForm;

implementation

uses DateUtils;

{$R *.dfm}

{ TWaybillPrintSettingsForm }

procedure TWaybillPrintSettingsForm.BeforeClose;
begin
  WaybillReportParams.WaybillNumber := eNumber.Text;
  WaybillReportParams.WaybillDate := dtpDate.Date;

  WaybillReportParams.ByWhomName := eByWhomName.Text;
  WaybillReportParams.RequestedName := eRequestedName.Text;
  WaybillReportParams.ServeName := eServeName.Text;
  WaybillReportParams.ReceivedName := eReceivedName.Text;
  WaybillReportParams.SaveParams;
end;

procedure TWaybillPrintSettingsForm.CreateVisibleComponents;
var
  l : TLabel;
  maxLeft : Integer;
begin
  WaybillReportParams := TWaybillReportParams.Create(DM.MainConnection);

  Self.Caption := 'Настройки печати накладной';

  inherited;

  l := AddLabel(5, 'Накладная №');
  maxLeft := l.Left + l.Width + 15;
  eNumber := AddEdit(l.Top, maxLeft, WaybillReportParams.WaybillNumber);

  l := AddLabel(10 + l.Top + l.Height, 'Дата');
  dtpDate := AddDateTimePicker(l.Top, maxLeft);

  l := AddLabel(10 + l.Top + l.Height, 'Через кого');
  eByWhomName := AddEdit(l.Top, maxLeft, WaybillReportParams.ByWhomName);

  l := AddLabel(10 + l.Top + l.Height, 'Затребовал');
  eRequestedName := AddEdit(l.Top, maxLeft, WaybillReportParams.RequestedName);

  l := AddLabel(10 + l.Top + l.Height, 'Отпустил');
  eServeName := AddEdit(l.Top, maxLeft, WaybillReportParams.ServeName);

  l := AddLabel(10 + l.Top + l.Height, 'Получил');
  eReceivedName := AddEdit(l.Top, maxLeft, WaybillReportParams.ReceivedName);

  pSettings.Width := eNumber.Left + eNumber.Width + 30;

  pSettings.Height := eReceivedName.Top + eReceivedName.Height + 20;
end;

procedure TWaybillPrintSettingsForm.FormDestroy(Sender: TObject);
begin
  WaybillReportParams.Free;
  inherited;
end;

procedure TWaybillPrintSettingsForm.UpdateParams(number: String;
  waybillDate: TDateTime);
begin
  eNumber.Text := number;
  WaybillReportParams.WaybillNumber := number;

  WaybillReportParams.WaybillDate := DateOf(waybillDate);
  dtpDate.Date := WaybillReportParams.WaybillDate;
end;

end.
