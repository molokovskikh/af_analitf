unit CreateEntry;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Ras;

type
  TCreateRasEntryForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    edtName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtPhone: TEdit;
    cbModem: TComboBox;
    procedure btnOkClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TCreateRasEntryForm.btnOkClick(Sender: TObject);
begin
  if Trim(edtName.Text)='' then raise Exception.Create('Не задано наименование');
  if cbModem.ItemIndex<0 then raise Exception.Create('Не задан модем');
  if Trim(edtPhone.Text)='' then raise Exception.Create('Не задан телефон');
  ModalResult:=mrOk;
end;

end.
