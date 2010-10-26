unit EditAddressForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm, StdCtrls, ExtCtrls, GridsEh, DBGridEh, ToughDBGrid,
  DBGridHelper, RxMemDS, DB, DModule, DBProc, AProc, Buttons, U_frameEditAddress,
  ComCtrls,
  U_frameEditVitallyImportantMarkups,
  DatabaseObjects;

type
  TEditAddressFrm = class(TVistaCorrectForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    btnSave : TButton;
    btnCancel : TButton;
    pButton : TPanel;

    pcMain : TPageControl;

    tsEditAddress : TTabSheet;
    frameEdit : TframeEditAddress;

    tsRetailMarkups : TTabSheet;
    frameEditRetailMarkups : TframeEditVitallyImportantMarkups;

    tsVitallyImportantMarkups : TTabSheet;
    frameEditVitallyImportantMarkups : TframeEditVitallyImportantMarkups;
    
    procedure CreateVisibleComponents;
    procedure AddBottomPanel;
    procedure AddPageControl;
    procedure AddAddressSheet;
    procedure AddRetailMarkups;
    procedure AddVitallyImportantMarkups;

    procedure FormCloseQuery(
      Sender: TObject;
      var CanClose: Boolean);

  public
    { Public declarations }
    procedure SaveChanges;
    procedure CancelChanges;
  end;


  procedure ShowEditAddress;

implementation

{$R *.dfm}

procedure ShowEditAddress;
var
  EditAddressFrm: TEditAddressFrm;
  modalResultForm : TModalResult;
begin
  EditAddressFrm := TEditAddressFrm.Create(Application);
  try
    modalResultForm := EditAddressFrm.ShowModal;
    if modalResultForm = mrOk then
      EditAddressFrm.SaveChanges
    else
      EditAddressFrm.CancelChanges;
  finally
    EditAddressFrm.Free;
  end;
end;

{ TEditAddressFrm }

procedure TEditAddressFrm.AddAddressSheet;
begin
  tsEditAddress := TTabSheet.Create(Self);
  tsEditAddress.PageControl := pcMain;
  tsEditAddress.Caption := 'Настройки накладных';

  frameEdit := TframeEditAddress.Create(Self);
  tsEditAddress.Constraints.MinHeight := frameEdit.Height;
  tsEditAddress.Constraints.MinWidth := frameEdit.Width;

  frameEdit.Parent := tsEditAddress;
  frameEdit.Align := alClient;
end;

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

procedure TEditAddressFrm.AddPageControl;
begin
  pcMain := TPageControl.Create(Self);
  pcMain.Parent := Self;
end;

procedure TEditAddressFrm.AddRetailMarkups;
begin
  tsRetailMarkups := TTabSheet.Create(Self);
  tsRetailMarkups.PageControl := pcMain;
  tsRetailMarkups.Caption := 'Наценки прочий ассортимент';

  frameEditRetailMarkups := TframeEditVitallyImportantMarkups
    .CreateFrame(Self, doiRetailMargins, DM.LoadRetailMargins);

  tsRetailMarkups.Constraints.MinHeight := frameEditRetailMarkups.Height;
  tsRetailMarkups.Constraints.MinWidth := frameEditRetailMarkups.Width;

  frameEditRetailMarkups.Parent := tsRetailMarkups;
  frameEditRetailMarkups.Align := alClient;
end;

procedure TEditAddressFrm.AddVitallyImportantMarkups;
begin
  tsVitallyImportantMarkups := TTabSheet.Create(Self);
  tsVitallyImportantMarkups.PageControl := pcMain;
  tsVitallyImportantMarkups.Caption := 'Наценки ЖНВЛС';

  frameEditVitallyImportantMarkups := TframeEditVitallyImportantMarkups
    .CreateFrame(Self, doiVitallyImportantMarkups, DM.LoadVitallyImportantMarkups);

  tsVitallyImportantMarkups.Constraints.MinHeight := frameEditVitallyImportantMarkups.Height;
  tsVitallyImportantMarkups.Constraints.MinWidth := frameEditVitallyImportantMarkups.Width;
    
  frameEditVitallyImportantMarkups.Parent := tsVitallyImportantMarkups;
  frameEditVitallyImportantMarkups.Align := alClient;
end;

procedure TEditAddressFrm.CancelChanges;
begin
  frameEdit.CancelChanges;
end;

procedure TEditAddressFrm.CreateVisibleComponents;
begin
  AddPageControl;
  AddBottomPanel;
  AddAddressSheet;
  AddRetailMarkups;
  AddVitallyImportantMarkups;
  
  Self.Width := pcMain.Width;
  pcMain.Align := alClient;
  pButton.Constraints.MinHeight := pButton.Height;
end;

procedure TEditAddressFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOK) then begin
    if CanClose and Assigned(frameEditRetailMarkups) and not frameEditRetailMarkups.ProcessCloseQuery(CanClose)
    then begin
      pcMain.ActivePage := tsRetailMarkups;
      frameEditRetailMarkups.dbgMarkups.SetFocus;
    end;
    if CanClose and Assigned(frameEditVitallyImportantMarkups) and not frameEditVitallyImportantMarkups.ProcessCloseQuery(CanClose)
    then begin
      pcMain.ActivePage := tsVitallyImportantMarkups;
      frameEditVitallyImportantMarkups.dbgMarkups.SetFocus;
    end;
  end;
end;

procedure TEditAddressFrm.FormCreate(Sender: TObject);
begin
  inherited;
  Self.Caption := 'Настройки накладных';
  Self.Position := poMainFormCenter;
  Self.OnCloseQuery := FormCloseQuery;
  CreateVisibleComponents;
end;

procedure TEditAddressFrm.SaveChanges;
var
  lastClientId : Int64;
begin
  if Assigned(frameEditVitallyImportantMarkups) then
    frameEditVitallyImportantMarkups.SaveVitallyImportantMarkups;

  if Assigned(frameEditRetailMarkups) then
    frameEditRetailMarkups.SaveVitallyImportantMarkups;
    
  frameEdit.SaveChanges;

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
end;

end.
