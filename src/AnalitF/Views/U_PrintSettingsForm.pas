unit U_PrintSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls,
  U_VistaCorrectForm;

type
  TPrintSettingsForm = class(TVistaCorrectForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    btnOk : TButton;
    btnCancel : TButton;
    pButton : TPanel;

    pSettings : TPanel;

    procedure CreateVisibleComponents; virtual;
    procedure AddBottomPanel;
    function AllowClose : Boolean; virtual;
    procedure BeforeClose; virtual;
    procedure FormCloseQuery(
      Sender: TObject;
      var CanClose: Boolean);
    procedure SetFormWidth();
    function AddLabel(
      Top: Integer; Caption: String) : TLabel;
    function AddEdit(
      Top: Integer; Left: Integer; Value: String) : TEdit;
    function AddDateTimePicker(
      Top: Integer; Left: Integer) : TDateTimePicker;
  public
    { Public declarations }
  end;

var
  PrintSettingsForm: TPrintSettingsForm;

implementation

{$R *.dfm}

{ TPrintSettingsForm }

procedure TPrintSettingsForm.AddBottomPanel;
begin
  pButton := TPanel.Create(Self);
  pButton.Parent := Self;
  pButton.Align := alBottom;
  pButton.Caption := '';
  pButton.BevelOuter := bvNone;

  btnOk := TButton.Create(Self);
  btnOk.Parent := pButton;
  btnOk.Caption := 'Ok';
  btnOk.Width := Self.Canvas.TextWidth('Сохранить') + 20;
  pButton.Height := btnOk.Height + 20;
  btnOk.Left := 10;
  btnOk.Top := 10;
  btnOk.Default := True;
  btnOk.ModalResult := mrOk;

  btnCancel := TButton.Create(Self);
  btnCancel.Parent := pButton;
  btnCancel.Caption := 'Отменить';
  btnCancel.Width := Self.Canvas.TextWidth(btnCancel.Caption) + 20;
  btnCancel.Left := 10 + btnOk.Width + 10;
  btnCancel.Top := 10;
  btnCancel.Cancel := True;
  btnCancel.ModalResult := mrCancel;
end;

function TPrintSettingsForm.AddDateTimePicker(Top,
  Left: Integer): TDateTimePicker;
begin
  Result := TDateTimePicker.Create(Self);
  Result.Parent := pSettings;
  Result.Left := Left;
  Result.Top := Top;
  Result.Width := Self.Canvas.TextWidth(DateToStr(Now())) + 30;
end;

function TPrintSettingsForm.AddEdit(Top, Left: Integer;
  Value: String): TEdit;
begin
  Result := TEdit.Create(Self);
  Result.Parent := pSettings;
  Result.Top := Top;
  Result.Left := Left;
  Result.Text := Value;
  Result.Width := Self.Canvas.TextWidth('0123456789012345');
end;

function TPrintSettingsForm.AddLabel(Top: Integer;
  Caption: String): TLabel;
begin
  Result := TLabel.Create(Self);
  Result.Parent := pSettings;
  Result.Top := Top;
  Result.Left := 5;
  Result.Caption := Caption;
end;

function TPrintSettingsForm.AllowClose: Boolean;
begin
  Result := True;
end;

procedure TPrintSettingsForm.BeforeClose;
begin

end;

procedure TPrintSettingsForm.CreateVisibleComponents;
begin
  AddBottomPanel;
  
  pSettings := TPanel.Create(Self);
  pSettings.Parent := Self;
  pSettings.Caption := '';
  pSettings.BevelOuter := bvNone;
end;

procedure TPrintSettingsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOK) and CanClose
  then
    if AllowClose then
      BeforeClose
    else
      CanClose := False;
end;

procedure TPrintSettingsForm.FormCreate(Sender: TObject);
begin
  inherited;
  Self.Position := poMainFormCenter;
  Self.OnCloseQuery := FormCloseQuery;
  CreateVisibleComponents;
  SetFormWidth;
end;

procedure TPrintSettingsForm.SetFormWidth;
begin
  //pSettings.Width := gbColumns.Width + 30;
  Self.Width := pSettings.Width;

  //pSettings.Height := gbColumns.Top + gbColumns.Height + 20;
  Self.Height := pSettings.Height + pButton.Height + 20;

  pSettings.Align := alClient;
end;

end.
