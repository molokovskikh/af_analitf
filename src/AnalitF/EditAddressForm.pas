unit EditAddressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm, StdCtrls, ExtCtrls, GridsEh, DBGridEh, ToughDBGrid,
  DBGridHelper, RxMemDS, DB, DModule, DBProc, AProc, Buttons, U_frameEditAddress;

type
  TEditAddressFrm = class(TVistaCorrectForm)
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
    frameEdit : TframeEditAddress;
  end;


  procedure ShowEditAddress;

implementation

{$R *.dfm}

procedure ShowEditAddress;
var
  EditAddressFrm: TEditAddressFrm;
  modalResultForm : TModalResult;
  lastClientId : Int64;
begin
  EditAddressFrm := TEditAddressFrm.Create(Application);
  try
    EditAddressFrm.ActiveControl := EditAddressFrm.frameEdit.dblClientId;
    modalResultForm := EditAddressFrm.ShowModal;
    if modalResultForm = mrOk then begin
      EditAddressFrm.frameEdit.SaveChanges;
      lastClientId := DM.adtClientsCLIENTID.AsLargeInt;
      DM.adtClients.DisableControls;
      try
        DM.adtClients.First;
        while not DM.adtClients.Eof do begin
          DM.adtClients.RefreshRecord;
          DM.adtClients.Next;
        end;
        if not DM.adtClients.Locate('ClientId', lastClientId, []) then
          DM.adtClients.First;
      finally
        DM.adtClients.EnableControls;
      end;
    end
    else
      EditAddressFrm.frameEdit.CancelChanges;
  finally
    EditAddressFrm.Free;
  end;
end;

{ TEditAddressFrm }

procedure TEditAddressFrm.AddBottomPanel;
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

procedure TEditAddressFrm.CreateVisibleComponents;
begin
  AddBottomPanel;

  frameEdit := TframeEditAddress.Create(Self);
  frameEdit.Parent := Self;
  Self.Width := frameEdit.Width;
  pButton.Constraints.MinHeight := pButton.Height;
  frameEdit.Align := alClient;
end;

procedure TEditAddressFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin

end;

procedure TEditAddressFrm.FormCreate(Sender: TObject);
begin
  inherited;
  Self.Caption := 'Настройки накладных';
  Self.Position := poMainFormCenter;
  Self.OnCloseQuery := FormCloseQuery;
  CreateVisibleComponents;
end;

end.
