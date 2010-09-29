unit EditTicketReportParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Buttons, 
  U_VistaCorrectForm,
  DModule,
  TicketReportParams;

type
  TEditTicketReportParamsForm = class(TVistaCorrectForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    btnSave : TButton;
    btnCancel : TButton;
    pButton : TPanel;

    pSettings : TPanel;

    procedure CreateVisibleComponents;
    procedure AddBottomPanel;
    procedure FormCloseQuery(
      Sender: TObject;
      var CanClose: Boolean);
  public
    { Public declarations }
    TicketParams : TTicketReportParams
  end;

  procedure ShowEditTicketReportParams;


implementation

{$R *.dfm}

procedure ShowEditTicketReportParams;
var
  EditTicketReportParamsForm: TEditTicketReportParamsForm;
  modalResultForm : TModalResult;
begin
  EditTicketReportParamsForm := TEditTicketReportParamsForm.Create(Application);
  try
    //EditVitallyImportantMarkupsForm.ActiveControl := EditVitallyImportantMarkupsForm.frameEdit.dbgMarkups;
    modalResultForm := EditTicketReportParamsForm.ShowModal;
    if modalResultForm = mrOk then begin
      EditTicketReportParamsForm.TicketParams.SaveParams;
    end;
  finally
    EditTicketReportParamsForm.Free;
  end;
end;


procedure TEditTicketReportParamsForm.AddBottomPanel;
begin
  pButton := TPanel.Create(Self);
  pButton.Parent := Self;
  pButton.Align := alBottom;
  pButton.Caption := '';
  pButton.BevelOuter := bvNone;

  btnSave := TButton.Create(Self);
  btnSave.Parent := pButton;
  btnSave.Caption := 'Сохранить';
  btnSave.Width := Self.Canvas.TextWidth(btnSave.Caption) + 20;
  pButton.Height := btnSave.Height + 20;
  btnSave.Left := 10;
  btnSave.Top := 10;
  btnSave.Default := True;
  btnSave.ModalResult := mrOk;

  btnCancel := TButton.Create(Self);
  btnCancel.Parent := pButton;
  btnCancel.Caption := 'Отменить';
  btnCancel.Width := Self.Canvas.TextWidth(btnCancel.Caption) + 20;
  btnCancel.Left := 10 + btnSave.Width + 10;
  btnCancel.Top := 10;
  btnCancel.Cancel := True;
  btnCancel.ModalResult := mrCancel;
end;

procedure TEditTicketReportParamsForm.CreateVisibleComponents;
begin
  AddBottomPanel;

  pSettings := TPanel.Create(Self);
  pSettings.Parent := Self;
  pSettings.Caption := '';
  pSettings.BevelOuter := bvNone;
  pSettings.Align := alClient;
{
  frameEdit := TframeEditVitallyImportantMarkups
    .CreateFrame(Self, doiVitallyImportantMarkups, DM.LoadVitallyImportantMarkups);
  frameEdit.Parent := Self;
  Self.Width := frameEdit.Width;
  pButton.Constraints.MinHeight := pButton.Height;
  frameEdit.Constraints.MinHeight := frameEdit.Height;
  frameEdit.Constraints.MinWidth := frameEdit.pEditButtons.Width + 100;
  frameEdit.Align := alClient;
}
end;

procedure TEditTicketReportParamsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
{
  if (ModalResult = mrOK) and CanClose and not frameEdit.ProcessCloseQuery(CanClose)
  then
    frameEdit.dbgMarkups.SetFocus;
}  
end;

procedure TEditTicketReportParamsForm.FormCreate(Sender: TObject);
begin
  inherited;
  TicketParams := TTicketReportParams.Create(DM.MainConnection);
  Self.Caption := 'Настройка печати ценников';
  Self.Position := poMainFormCenter;
  Self.OnCloseQuery := FormCloseQuery;
  CreateVisibleComponents;
end;

procedure TEditTicketReportParamsForm.FormDestroy(Sender: TObject);
begin
  TicketParams.Free;
  inherited;
end;

end.
