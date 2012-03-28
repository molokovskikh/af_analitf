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
    dblcbProvider: TDBLookupComboBox;
    Label2: TLabel;
    eProviderId: TEdit;
    Label3: TLabel;
    dtpDate: TDateTimePicker;
    dsProviders: TDataSource;
    adsProviders: TMyQuery;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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
  end;
end;

procedure TAddWaybillForm.FormCreate(Sender: TObject);
begin
  inherited;
  dtpDate.DateTime := Date();
  adsProviders.Connection := DM.MainConnection;
  adsProviders.Open;
  dblcbProvider.KeyValue := adsProviders.FieldByName('FirmCode').Value;
end;

end.
