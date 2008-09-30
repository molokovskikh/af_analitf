unit U_frmOldOrdersDelete;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms;

type
  TfrmOldOrdersDelete = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Image1: TImage;
    lblMessage: TLabel;
  end;

var
  frmOldOrdersDelete: TfrmOldOrdersDelete;

function ConfirmDeleteOldOrders : Boolean;

implementation

{$R *.DFM}

uses
  DModule;

function ConfirmDeleteOldOrders : Boolean;
begin
  frmOldOrdersDelete := TfrmOldOrdersDelete.Create(Application);
  try
    frmOldOrdersDelete.btnOK.Caption := '�������';
    frmOldOrdersDelete.btnCancel.Caption := '������';
    frmOldOrdersDelete.lblMessage.Caption := Format(
      '� ������ ������� ���������� ������, ��������� ����� %d ���� �����. ������������� ������� ��.',
      [DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger]);
    Result := frmOldOrdersDelete.ShowModal = mrOk;
  finally
    frmOldOrdersDelete.Free;
  end;
end;

end.
