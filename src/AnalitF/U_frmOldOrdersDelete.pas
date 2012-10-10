unit U_frmOldOrdersDelete;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, U_VistaCorrectForm,
  GlobalSettingParams;

type
  TfrmOldOrdersDelete = class(TVistaCorrectForm)
    btnOK: TButton;
    btnCancel: TButton;
    Image1: TImage;
    lblMessage: TLabel;
  end;

var
  frmOldOrdersDelete: TfrmOldOrdersDelete;

function ConfirmDeleteOldOrders : Boolean;

function ConfirmDeleteOldWaybills : Boolean;

function ShowNewRejects() : Boolean;

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

function ConfirmDeleteOldWaybills : Boolean;
begin
  frmOldOrdersDelete := TfrmOldOrdersDelete.Create(Application);
  try
    frmOldOrdersDelete.btnOK.Caption := 'Удалить';
    frmOldOrdersDelete.btnCancel.Caption := 'Отмена';
    frmOldOrdersDelete.lblMessage.Caption := Format(
      'В архиве заказов обнаружены документы (накладные, отказы), сделанные более %d дней назад. Рекомендуется удалить их.',
      [TGlobalSettingParams.GetWaybillsHistoryDayCount(DM.MainConnection)]);
    Result := frmOldOrdersDelete.ShowModal = mrOk;
  finally
    frmOldOrdersDelete.Free;
  end;
end;

function ShowNewRejects() : Boolean;
begin
  frmOldOrdersDelete := TfrmOldOrdersDelete.Create(Application);
  try
    frmOldOrdersDelete.btnOK.Caption := 'ОК';
    frmOldOrdersDelete.btnCancel.Caption := 'Показать';
    frmOldOrdersDelete.Caption := 'Изменение статуса забраковки';
    frmOldOrdersDelete.lblMessage.Caption := 'Изменился список забракованных препаратов.';
    Result := frmOldOrdersDelete.ShowModal = mrCancel;
  finally
    frmOldOrdersDelete.Free;
  end;
end;

end.
