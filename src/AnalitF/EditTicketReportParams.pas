unit EditTicketReportParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, U_VistaCorrectForm, DModule,
  TicketReportParams;

type
  TEditTicketReportParamsForm = class(TVistaCorrectForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    btnSave : TButton;
    btnCancel : TButton;
    pButton : TPanel;

    pSettings : TPanel;
    cbPrintEmptyTickets : TCheckBox;
    cbDeleteUnprintableElemnts : TCheckBox;

    gbColumns : TGroupBox;
    cbClientName : TCheckBox;
    cbProduct : TCheckBox;
    cbCountry : TCheckBox;
    cbProducer : TCheckBox;
    cbPeriod : TCheckBox;
    cbProviderDocumentId : TCheckBox;
    cbSignature : TCheckBox;
    cbSerialNumber : TCheckBox;
    cbDocumentDate : TCheckBox;

    cbTicketSize : TComboBox;

    procedure CreateVisibleComponents;
    procedure AddBottomPanel;
    procedure FormCloseQuery(
      Sender: TObject;
      var CanClose: Boolean);
    function AddCheckBox(Top: Integer; Caption : String; Value : Boolean) : TCheckBox;
    procedure SizeChange(Sender: TObject);
  public
    { Public declarations }
    TicketParams : TTicketReportParams;
  end;

  procedure ShowEditTicketReportParams;

implementation

{$R *.dfm}

procedure ShowEditTicketReportParams;
var
  EditTicketReportParamsForm: TEditTicketReportParamsForm;
  modalResultForm : TModalResult;
begin
  EditTicketReportParamsForm := TEditTicketReportParamsForm.Create(Application);
  try
    modalResultForm := EditTicketReportParamsForm.ShowModal;
    if modalResultForm = mrOk then begin
      EditTicketReportParamsForm.TicketParams.SaveParams;
    end;
  finally
    EditTicketReportParamsForm.Free;
  end;
end;

{ TEditTicketReportParamsForm }

procedure TEditTicketReportParamsForm.AddBottomPanel;
begin
  pButton := TPanel.Create(Self);
  pButton.Parent := Self;
  pButton.Align := alBottom;
  pButton.Caption := '';
  pButton.BevelOuter := bvNone;

  btnSave := TButton.Create(Self);
  btnSave.Parent := pButton;
  btnSave.Caption := '���������';
  btnSave.Width := Self.Canvas.TextWidth(btnSave.Caption) + 20;
  pButton.Height := btnSave.Height + 20;
  btnSave.Left := 10;
  btnSave.Top := 10;
  btnSave.Default := True;
  btnSave.ModalResult := mrOk;

  btnCancel := TButton.Create(Self);
  btnCancel.Parent := pButton;
  btnCancel.Caption := '��������';
  btnCancel.Width := Self.Canvas.TextWidth(btnCancel.Caption) + 20;
  btnCancel.Left := 10 + btnSave.Width + 10;
  btnCancel.Top := 10;
  btnCancel.Cancel := True;
  btnCancel.ModalResult := mrCancel;
end;

function TEditTicketReportParamsForm.AddCheckBox(Top: Integer;
  Caption: String; Value : Boolean): TCheckBox;
begin
  Result := TCheckBox.Create(Self);
  Result.Parent := gbColumns;
  Result.Caption := Caption;
  Result.Width := Self.Canvas.TextWidth(Result.Caption) + 50;
  Result.Left := 5;
  Result.Top := Top;
  Result.Checked := Value;
end;

procedure TEditTicketReportParamsForm.CreateVisibleComponents;
begin
  AddBottomPanel;

  pSettings := TPanel.Create(Self);
  pSettings.Parent := Self;
  pSettings.Caption := '';
  pSettings.BevelOuter := bvNone;

  cbTicketSize := TComboBox.Create(Self);
  cbTicketSize.Parent := pSettings;
  cbTicketSize.Style := csDropDownList;
  cbTicketSize.Items.Add('����������� ������');
  cbTicketSize.Items.Add('����� ������');
  cbTicketSize.Items.Add('����� ������ � ������� �����');
  cbTicketSize.ItemIndex := Integer(TicketParams.TicketSize);
  cbTicketSize.Width := Self.Canvas.TextWidth('����� ������ � ������� �����') + 50;
  cbTicketSize.Left := 5;
  cbTicketSize.Top := 5;

  cbPrintEmptyTickets := TCheckBox.Create(Self);
  cbPrintEmptyTickets.Parent := pSettings;
  cbPrintEmptyTickets.Caption := '������ "������" ��������';
  cbPrintEmptyTickets.Width := Self.Canvas.TextWidth(cbPrintEmptyTickets.Caption) + 50;
  cbPrintEmptyTickets.Left := 5;
  cbPrintEmptyTickets.Top := 5 + cbTicketSize.Top + cbTicketSize.Height;
  cbPrintEmptyTickets.Checked := TicketParams.PrintEmptyTickets;

  cbDeleteUnprintableElemnts := TCheckBox.Create(Self);
  cbDeleteUnprintableElemnts.Parent := pSettings;
  cbDeleteUnprintableElemnts.Caption := '������� ������������ ��������';
  cbDeleteUnprintableElemnts.Width := Self.Canvas.TextWidth(cbDeleteUnprintableElemnts.Caption) + 50;
  cbDeleteUnprintableElemnts.Left := 5;
  cbDeleteUnprintableElemnts.Top := 5 + cbPrintEmptyTickets.Top + cbPrintEmptyTickets.Height;
  cbDeleteUnprintableElemnts.Checked := TicketParams.DeleteUnprintableElemnts;

  gbColumns := TGroupBox.Create(Self);
  gbColumns.Parent := pSettings;
  gbColumns.Caption := ' ���������� �������� ������� ';
  gbColumns.Width := Self.Canvas.TextWidth(gbColumns.Caption) + 30;
  gbColumns.Left := 5;
  gbColumns.Top := 5 + cbDeleteUnprintableElemnts.Top + cbDeleteUnprintableElemnts.Height;

  cbClientName := AddCheckBox(15, '������������ �������', TicketParams.ClientNameVisible);
  cbProduct := AddCheckBox(5 + cbClientName.Top + cbClientName.Height, '������������', TicketParams.ProductVisible);
  cbCountry := AddCheckBox(5+ cbProduct.Top + cbProduct.Height, '������', TicketParams.CountryVisible);
  cbProducer := AddCheckBox(5+ cbCountry.Top + cbCountry.Height, '�������������', TicketParams.ProducerVisible);
  cbPeriod := AddCheckBox(5+ cbProducer.Top + cbProducer.Height, '���� ��������', TicketParams.PeriodVisible);
  cbProviderDocumentId := AddCheckBox(5+ cbPeriod.Top + cbPeriod.Height, '����� ���������', TicketParams.ProviderDocumentIdVisible);
  cbSignature := AddCheckBox(5+ cbProviderDocumentId.Top + cbProviderDocumentId.Height, '���������', TicketParams.SignatureVisible);
  cbSerialNumber := AddCheckBox(5+ cbSignature.Top + cbSignature.Height, '����� ������', TicketParams.SerialNumberVisible);
  cbDocumentDate := AddCheckBox(5+ cbSerialNumber.Top + cbSerialNumber.Height, '���� ���������', TicketParams.DocumentDateVisible);
  gbColumns.Height := cbDocumentDate.Top + cbDocumentDate.Height + 20;
  if gbColumns.Width < cbClientName.Width + 10 then
    gbColumns.Width := cbClientName.Width + 10;

  pSettings.Width := gbColumns.Width + 30;
  Self.Width := pSettings.Width;

  pSettings.Height := gbColumns.Top + gbColumns.Height + 20;
  Self.Height := pSettings.Height + pButton.Height + 20;

  pSettings.Align := alClient;

  cbTicketSize.OnChange := SizeChange;
  SizeChange(cbTicketSize);
end;

procedure TEditTicketReportParamsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOK) and CanClose
  then begin
    TicketParams.TicketSize := TTicketSize(cbTicketSize.ItemIndex);
    TicketParams.PrintEmptyTickets := cbPrintEmptyTickets.Checked;
    //TicketParams.SizePercent := tbSizePercent.Position;
    TicketParams.ClientNameVisible := cbClientName.Checked;
    TicketParams.ProductVisible := cbProduct.Checked;
    TicketParams.CountryVisible := cbCountry.Checked;
    TicketParams.ProducerVisible := cbProducer.Checked;
    TicketParams.PeriodVisible := cbPeriod.Checked;
    TicketParams.ProviderDocumentIdVisible := cbProviderDocumentId.Checked;
    TicketParams.SignatureVisible := cbSignature.Checked;
    TicketParams.SerialNumberVisible := cbSerialNumber.Checked;
    TicketParams.DocumentDateVisible := cbDocumentDate.Checked;
    TicketParams.DeleteUnprintableElemnts := cbDeleteUnprintableElemnts.Checked;
  end;
end;

procedure TEditTicketReportParamsForm.FormCreate(Sender: TObject);
begin
  inherited;
  TicketParams := TTicketReportParams.Create(DM.MainConnection);
  Self.Caption := '��������� ������ ��������';
  Self.Position := poMainFormCenter;
  Self.OnCloseQuery := FormCloseQuery;
  CreateVisibleComponents;
end;

procedure TEditTicketReportParamsForm.FormDestroy(Sender: TObject);
begin
  TicketParams.Free;
  inherited;
end;

procedure TEditTicketReportParamsForm.SizeChange(Sender: TObject);
begin
  gbColumns.Enabled := cbTicketSize.ItemIndex = 0;
  cbDeleteUnprintableElemnts.Enabled := cbTicketSize.ItemIndex = 0;
end;

end.
