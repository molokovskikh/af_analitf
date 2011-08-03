unit EditRackCardReportParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls,
  U_VistaCorrectForm,
  DModule,
  RackCardReportParams;

type
  TEditRackCardReportParamsForm = class(TVistaCorrectForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    btnSave : TButton;
    btnCancel : TButton;
    pButton : TPanel;

    pSettings : TPanel;
    cbDeleteUnprintableElemnts : TCheckBox;

    gbColumns : TGroupBox;

    cbProduct : TCheckBox;
    cbProducer : TCheckBox;
    cbSerialNumber : TCheckBox;
    cbPeriod : TCheckBox;
    cbQuantity : TCheckBox;
    cbProvider : TCheckBox;
    cbCertificates : TCheckBox;
    cbDateOfReceipt : TCheckBox;
    cbCost : TCheckBox;

    cbRackCardSize : TComboBox;

    procedure CreateVisibleComponents;
    procedure AddBottomPanel;
    procedure FormCloseQuery(
      Sender: TObject;
      var CanClose: Boolean);
    function AddCheckBox(Top: Integer; Caption : String; Value : Boolean) : TCheckBox;
  public
    { Public declarations }
    RackCardReportParams : TRackCardReportParams;
  end;

  procedure ShowEditRackCardReportParams;

implementation

{$R *.dfm}

procedure ShowEditRackCardReportParams;
var
  EditRackCardReportParamsForm: TEditRackCardReportParamsForm;
  modalResultForm : TModalResult;
begin
  EditRackCardReportParamsForm := TEditRackCardReportParamsForm.Create(Application);
  try
    modalResultForm := EditRackCardReportParamsForm.ShowModal;
    if modalResultForm = mrOk then begin
      EditRackCardReportParamsForm.RackCardReportParams.SaveParams;
    end;
  finally
    EditRackCardReportParamsForm.Free;
  end;
end;

procedure TEditRackCardReportParamsForm.AddBottomPanel;
begin
  pButton := TPanel.Create(Self);
  pButton.Parent := Self;
  pButton.Align := alBottom;
  pButton.Caption := '';
  pButton.BevelOuter := bvNone;

  btnSave := TButton.Create(Self);
  btnSave.Parent := pButton;
  btnSave.Caption := 'Сохранить';
  btnSave.Width := Self.Canvas.TextWidth(btnSave.Caption) + 20;
  pButton.Height := btnSave.Height + 20;
  btnSave.Left := 10;
  btnSave.Top := 10;
  btnSave.Default := True;
  btnSave.ModalResult := mrOk;

  btnCancel := TButton.Create(Self);
  btnCancel.Parent := pButton;
  btnCancel.Caption := 'Отменить';
  btnCancel.Width := Self.Canvas.TextWidth(btnCancel.Caption) + 20;
  btnCancel.Left := 10 + btnSave.Width + 10;
  btnCancel.Top := 10;
  btnCancel.Cancel := True;
  btnCancel.ModalResult := mrCancel;
end;

function TEditRackCardReportParamsForm.AddCheckBox(Top: Integer;
  Caption: String; Value: Boolean): TCheckBox;
begin
  Result := TCheckBox.Create(Self);
  Result.Parent := gbColumns;
  Result.Caption := Caption;
  Result.Width := Self.Canvas.TextWidth(Result.Caption) + 50;
  Result.Left := 5;
  Result.Top := Top;
  Result.Checked := Value;
end;

procedure TEditRackCardReportParamsForm.CreateVisibleComponents;
begin
  AddBottomPanel;

  pSettings := TPanel.Create(Self);
  pSettings.Parent := Self;
  pSettings.Caption := '';
  pSettings.BevelOuter := bvNone;

  cbRackCardSize := TComboBox.Create(Self);
  cbRackCardSize.Parent := pSettings;
  cbRackCardSize.Style := csDropDownList;
  cbRackCardSize.Items.Add('Стандартный размер');
  cbRackCardSize.Items.Add('Большой размер');
  cbRackCardSize.ItemIndex := Integer(RackCardReportParams.RackCardSize);
  cbRackCardSize.Width := Self.Canvas.TextWidth('Стандартный размер') + 50;
  cbRackCardSize.Left := 5;
  cbRackCardSize.Top := 5;

  cbDeleteUnprintableElemnts := TCheckBox.Create(Self);
  cbDeleteUnprintableElemnts.Parent := pSettings;
  cbDeleteUnprintableElemnts.Caption := 'Удалять непечатаемые элементы';
  cbDeleteUnprintableElemnts.Width := Self.Canvas.TextWidth(cbDeleteUnprintableElemnts.Caption) + 50;
  cbDeleteUnprintableElemnts.Left := 5;
  cbDeleteUnprintableElemnts.Top := 5 + cbRackCardSize.Top + cbRackCardSize.Height;
  cbDeleteUnprintableElemnts.Checked := RackCardReportParams.DeleteUnprintableElemnts;

  gbColumns := TGroupBox.Create(Self);
  gbColumns.Parent := pSettings;
  gbColumns.Caption := ' Печатаемые элементы стеллажной карты ';
  gbColumns.Width := Self.Canvas.TextWidth(gbColumns.Caption) + 30;
  gbColumns.Left := 5;
  gbColumns.Top := 5 + cbDeleteUnprintableElemnts.Top + cbDeleteUnprintableElemnts.Height;

  cbProduct := AddCheckBox(15, 'Наименование', RackCardReportParams.ProductVisible);
  cbProducer := AddCheckBox(5 + cbProduct.Top + cbProduct.Height, 'Производитель', RackCardReportParams.ProducerVisible);
  cbSerialNumber := AddCheckBox(5 + cbProducer.Top + cbProducer.Height, 'Серия товара', RackCardReportParams.SerialNumberVisible);
  cbPeriod := AddCheckBox(5 + cbSerialNumber.Top + cbSerialNumber.Height, 'Срок годности', RackCardReportParams.PeriodVisible);
  cbQuantity := AddCheckBox(5 + cbPeriod.Top + cbPeriod.Height, 'Количество', RackCardReportParams.QuantityVisible);
  cbProvider := AddCheckBox(5 + cbQuantity.Top + cbQuantity.Height, 'Поставщик', RackCardReportParams.ProviderVisible);
  cbCertificates := AddCheckBox(5 + cbProvider.Top + cbProvider.Height, 'Номер сертификата', RackCardReportParams.CertificatesVisible);
  cbDateOfReceipt := AddCheckBox(5 + cbCertificates.Top + cbCertificates.Height, 'Дата поступления', RackCardReportParams.DateOfReceiptVisible);
  cbCost := AddCheckBox(5 + cbDateOfReceipt.Top + cbDateOfReceipt.Height, 'Цена', RackCardReportParams.CostVisible);


  gbColumns.Height := cbCost.Top + cbCost.Height + 20;
  if gbColumns.Width < cbProducer.Width + 10 then
    gbColumns.Width := cbProducer.Width + 10;

  pSettings.Width := gbColumns.Width + 30;
  Self.Width := pSettings.Width;

  pSettings.Height := gbColumns.Top + gbColumns.Height + 20;
  Self.Height := pSettings.Height + pButton.Height + 20;

  pSettings.Align := alClient;
end;

procedure TEditRackCardReportParamsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOK) and CanClose
  then begin
    RackCardReportParams.RackCardSize := TRackCardSize(cbRackCardSize.ItemIndex);
    RackCardReportParams.DeleteUnprintableElemnts := cbDeleteUnprintableElemnts.Checked;

    RackCardReportParams.ProductVisible := cbProduct.Checked;
    RackCardReportParams.ProducerVisible := cbProducer.Checked;
    RackCardReportParams.SerialNumberVisible := cbSerialNumber.Checked;
    RackCardReportParams.PeriodVisible := cbPeriod.Checked;
    RackCardReportParams.QuantityVisible := cbQuantity.Checked;
    RackCardReportParams.ProviderVisible := cbProvider.Checked;
    RackCardReportParams.CostVisible := cbCost.Checked;
    RackCardReportParams.CertificatesVisible := cbCertificates.Checked;
    RackCardReportParams.DateOfReceiptVisible := cbDateOfReceipt.Checked;
  end;
end;

procedure TEditRackCardReportParamsForm.FormCreate(Sender: TObject);
begin
  inherited;
  RackCardReportParams := TRackCardReportParams.Create(DM.MainConnection);
  Self.Caption := 'Настройки стеллажной карты';
  Self.Position := poMainFormCenter;
  Self.OnCloseQuery := FormCloseQuery;
  CreateVisibleComponents;
end;

procedure TEditRackCardReportParamsForm.FormDestroy(Sender: TObject);
begin
  RackCardReportParams.Free;
  inherited;
end;

end.
