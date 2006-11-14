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
    procedure FormCreate(Sender: TObject);
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
    Result := frmOldOrdersDelete.ShowModal = mrOk;
  finally
    frmOldOrdersDelete.Free;
  end;
end;

procedure TfrmOldOrdersDelete.FormCreate(Sender: TObject);
begin
  lblMessage.Caption := Format(
    '¬ архиве заказов обнаружены заказы, сделанные более %d дней назад. –екомендуетс€ удалить их.',
    [DM.adtParams.FieldByName('ORDERSHISTORYDAYCOUNT').AsInteger]);
end;

end.
