unit EditVitallyImportantMarkups;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm, StdCtrls, ExtCtrls, GridsEh, DBGridEh, ToughDBGrid,
  DBGridHelper, RxMemDS, DB, DModule, DBProc, AProc, Buttons, DatabaseObjects,
  U_frameEditVitallyImportantMarkups;

type
  TEditVitallyImportantMarkupsForm = class(TVistaCorrectForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    btnSave : TButton;
    btnCancel : TButton;
    pButton : TPanel;


    procedure CreateVisibleComponents;
    procedure AddBottomPanel;
    procedure FormCloseQuery(
      Sender: TObject;
      var CanClose: Boolean);

  public
    { Public declarations }
    frameEdit : TframeEditVitallyImportantMarkups;
  end;


  procedure ShowEditVitallyImportantMarkups;

implementation

{$R *.dfm}

procedure ShowEditVitallyImportantMarkups;
var
  EditVitallyImportantMarkupsForm: TEditVitallyImportantMarkupsForm;
  modalResultForm : TModalResult;
begin
  EditVitallyImportantMarkupsForm := TEditVitallyImportantMarkupsForm.Create(Application);
  try
    EditVitallyImportantMarkupsForm.ActiveControl := EditVitallyImportantMarkupsForm.frameEdit.dbgMarkups; 
    modalResultForm := EditVitallyImportantMarkupsForm.ShowModal;
    if modalResultForm = mrOk then begin
      EditVitallyImportantMarkupsForm.frameEdit.SaveVitallyImportantMarkups;
    end;
  finally
    EditVitallyImportantMarkupsForm.Free;
  end;
end;

procedure TEditVitallyImportantMarkupsForm.AddBottomPanel;
begin
  pButton := TPanel.Create(Self);
  pButton.Parent := Self;
  pButton.Align := alBottom;
  pButton.Caption := '';
  pButton.BevelOuter := bvNone;

  btnSave := TButton.Create(Self);
  btnSave.Parent := pButton;
  btnSave.Caption := '���������';
  btnSave.Width := Self.Canvas.TextWidth(btnSave.Caption) + 20;
  pButton.Height := btnSave.Height + 20;
  btnSave.Left := 10;
  btnSave.Top := 10;
  btnSave.Default := True;
  btnSave.ModalResult := mrOk;

  btnCancel := TButton.Create(Self);
  btnCancel.Parent := pButton;
  btnCancel.Caption := '��������';
  btnCancel.Width := Self.Canvas.TextWidth(btnCancel.Caption) + 20;
  btnCancel.Left := 10 + btnSave.Width + 10;
  btnCancel.Top := 10;
  btnCancel.Cancel := True;
  btnCancel.ModalResult := mrCancel;
end;

procedure TEditVitallyImportantMarkupsForm.CreateVisibleComponents;
begin
  AddBottomPanel;

  frameEdit := TframeEditVitallyImportantMarkups
    .CreateFrame(Self, doiVitallyImportantMarkups, DM.LoadVitallyImportantMarkups);
  frameEdit.Parent := Self;
  Self.Width := frameEdit.Width;
  pButton.Constraints.MinHeight := pButton.Height;
  frameEdit.Constraints.MinHeight := frameEdit.Height;
  frameEdit.Constraints.MinWidth := frameEdit.pEditButtons.Width + 100;
  frameEdit.Align := alClient;
end;


procedure TEditVitallyImportantMarkupsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOK) and CanClose and not frameEdit.ProcessCloseQuery(CanClose)
  then
    frameEdit.dbgMarkups.SetFocus;
end;

procedure TEditVitallyImportantMarkupsForm.FormCreate(Sender: TObject);
begin
  inherited;
  Self.Caption := '�������������� ������� ��� �����';
  Self.Position := poMainFormCenter;
  Self.OnCloseQuery := FormCloseQuery;
  CreateVisibleComponents;
end;

end.
