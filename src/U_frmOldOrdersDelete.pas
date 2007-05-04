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

function ConfirmSendCurrentOrders : Boolean;

implementation

{$R *.DFM}

uses
  DModule;

function ConfirmDeleteOldOrders : Boolean;
begin
  frmOldOrdersDelete := TfrmOldOrdersDelete.Create(Application);
  try
    frmOldOrdersDelete.btnOK.Caption := 'Удалить';
    frmOldOrdersDelete.btnCancel.Caption := 'Отмена';
    frmOldOrdersDelete.lblMessage.Caption := Format(
      'В архиве заказов обнаружены заказы, сделанные более %d дней назад. Рекомендуется удалить их.',
      [DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger]);
    Result := frmOldOrdersDelete.ShowModal = mrOk;
  finally
    frmOldOrdersDelete.Free;
  end;
end;

function ConfirmSendCurrentOrders : Boolean;
begin
  frmOldOrdersDelete := TfrmOldOrdersDelete.Create(Application);
  try
    frmOldOrdersDelete.btnOK.Caption := 'Отправить';
    frmOldOrdersDelete.btnCancel.Caption := 'Удалить';
    frmOldOrdersDelete.lblMessage.Caption := 'При кумулятивном обновлении текущие неотправленные заказы должны быть отправлены или удалены. Отправить заказы?';
    Result := frmOldOrdersDelete.ShowModal = mrOk;
  finally
    frmOldOrdersDelete.Free;
  end;
end;

end.
