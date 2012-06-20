unit U_AddWaybillForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm, StdCtrls, DBCtrls, ComCtrls,
  AProc,
  DModule, DB, MemDS, DBAccess, MyAccess;

type
  TAddWaybillForm = class(TVistaCorrectForm)
    gbAdd: TGroupBox;
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    eProviderId: TEdit;
    Label3: TLabel;
    dtpDate: TDateTimePicker;
    dsProviders: TDataSource;
    adsProviders: TMyQuery;
    cbProviders: TComboBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetSupplierId() : Variant;
  end;

implementation

{$R *.dfm}

procedure TAddWaybillForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if (ModalResult = mrOK) and CanClose then begin
    if (Length(eProviderId.Text) = 0) then begin
      CanClose := False;
      eProviderId.SetFocus;
      AProc.MessageBox('Не установлен номер накладной.', MB_ICONWARNING)
    end;
    if CanClose and (Length(cbProviders.Text) = 0) then begin
      CanClose := False;
      cbProviders.SetFocus;
      AProc.MessageBox('Не установлен поставщик.', MB_ICONWARNING)
    end;
  end;
end;

procedure TAddWaybillForm.FormCreate(Sender: TObject);
begin
  inherited;
  dtpDate.DateTime := Date();
  cbProviders.Clear;
  adsProviders.Connection := DM.MainConnection;
  adsProviders.Open;
  adsProviders.First;
  try
    while not adsProviders.Eof do begin
      cbProviders.Items.Add(adsProviders.FieldByName('FullName').Value);
      adsProviders.Next;
    end;
  finally
    adsProviders.First;
  end;
  if cbProviders.Items.Count > 0 then
    cbProviders.ItemIndex := 0;
end;

function TAddWaybillForm.GetSupplierId: Variant;
begin
  Result := Null;

  if adsProviders.Locate('FullName', cbProviders.Text, []) then
    Result := adsProviders.FieldByName('FirmCode').Value;
end;

end.
