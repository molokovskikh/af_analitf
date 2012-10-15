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
    btnRetry: TButton;
   public
    procedure RecalcHeight();
  end;

var
  frmOldOrdersDelete: TfrmOldOrdersDelete;

function ConfirmDeleteOldOrders : Boolean;

function ConfirmDeleteOldWaybills : Boolean;

function ShowNewRejects() : Boolean;

function ShowQuestionAfterUpdate(awaited, rejects : Boolean) : TModalResult;

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

function ShowQuestionAfterUpdate(awaited, rejects : Boolean) : TModalResult;
var
  modalFormResult : TModalResult;
begin
  frmOldOrdersDelete := TfrmOldOrdersDelete.Create(Application);
  try
    frmOldOrdersDelete.btnOK.Caption := 'ОК';
    frmOldOrdersDelete.btnCancel.Cancel := False;
    frmOldOrdersDelete.btnCancel.Caption := 'Показать забраковку';
    frmOldOrdersDelete.btnCancel.Width := frmOldOrdersDelete.Canvas.TextWidth(frmOldOrdersDelete.btnCancel.Caption) + 20;
    frmOldOrdersDelete.btnRetry.Caption := 'Показать ожидаемые позиции';
    frmOldOrdersDelete.btnRetry.Width := frmOldOrdersDelete.Canvas.TextWidth(frmOldOrdersDelete.btnRetry.Caption) + 20;
    frmOldOrdersDelete.Caption := 'Обновление';
    frmOldOrdersDelete.lblMessage.Caption :=
      'Обновление завершено успешно.'#13#10 +
      'Обнаружены следующие события:';
    if rejects then
      frmOldOrdersDelete.lblMessage.Caption := frmOldOrdersDelete.lblMessage.Caption +
        #13#10'  - обнаружены препараты, предписанные к изъятию, в имеющихся у Вас электронных накладных';
    if awaited then
      frmOldOrdersDelete.lblMessage.Caption := frmOldOrdersDelete.lblMessage.Caption +
        #13#10'  - появились препараты, которые включены Вами в список ожидаемых позиций';

    frmOldOrdersDelete.RecalcHeight;

    if awaited and rejects then begin
      frmOldOrdersDelete.btnCancel.Visible := True;
      frmOldOrdersDelete.btnRetry.Visible := True;
      frmOldOrdersDelete.btnCancel.Top := frmOldOrdersDelete.btnOK.Top;
      frmOldOrdersDelete.btnRetry.Top := frmOldOrdersDelete.btnCancel.Top;
      frmOldOrdersDelete.btnRetry.Left := frmOldOrdersDelete.Width - frmOldOrdersDelete.btnRetry.Width - 10;
      frmOldOrdersDelete.btnCancel.Left := frmOldOrdersDelete.btnRetry.Left - frmOldOrdersDelete.btnCancel.Width - 10;
      frmOldOrdersDelete.btnOk.Left := frmOldOrdersDelete.btnCancel.Left - frmOldOrdersDelete.btnOK.Width - 10;
    end
    else begin
      frmOldOrdersDelete.btnOk.Left := frmOldOrdersDelete.Width - frmOldOrdersDelete.btnOk.Width - 10;
      frmOldOrdersDelete.btnCancel.Visible := False;
      frmOldOrdersDelete.btnRetry.Visible := False;
    end;

    modalFormResult := frmOldOrdersDelete.ShowModal;
    Result := mrOk;
    if awaited and rejects then
      Result := modalFormResult
    else
      if rejects then
        Result := mrCancel
      else
        if awaited then
          Result := mrRetry;
  finally
    frmOldOrdersDelete.Free;
  end;
end;

{ TfrmOldOrdersDelete }

procedure TfrmOldOrdersDelete.RecalcHeight;
var
  labelHeight : Integer;
begin
  labelHeight := 30;
  Self.Height := Self.Height + labelHeight;
  lblMessage.Height := lblMessage.Height + labelHeight;
  btnOK.Top := btnOK.Top + labelHeight;
end;

end.
