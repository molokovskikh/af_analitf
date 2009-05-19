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
  if Trim(edtName.Text)='' then raise Exception.Create('�� ������ ������������');
  if cbModem.ItemIndex<0 then raise Exception.Create('�� ����� �����');
  if Trim(edtPhone.Text)='' then raise Exception.Create('�� ����� �������');
  ModalResult:=mrOk;
end;

end.
