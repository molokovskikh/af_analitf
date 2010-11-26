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
    lSizePercent : TLabel;
    tbSizePercent : TTrackBar;

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

    procedure CreateVisibleComponents;
    procedure AddBottomPanel;
    procedure FormCloseQuery(
      Sender: TObject;
      var CanClose: Boolean);
    procedure TrackBarChange(Sender: TObject);
    function AddCheckBox(Top: Integer; Caption : String; Value : Boolean) : TCheckBox;
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

  cbPrintEmptyTickets := TCheckBox.Create(Self);
  cbPrintEmptyTickets.Parent := pSettings;
  cbPrintEmptyTickets.Caption := 'Печать "пустых" ценников';
  cbPrintEmptyTickets.Width := Self.Canvas.TextWidth(cbPrintEmptyTickets.Caption) + 50;
  cbPrintEmptyTickets.Left := 5;
  cbPrintEmptyTickets.Top := 5;
  cbPrintEmptyTickets.Checked := TicketParams.PrintEmptyTickets;

  lSizePercent := TLabel.Create(Self);
  lSizePercent.Parent := pSettings;
  lSizePercent.Caption := 'Размер ценников:';
  lSizePercent.Width := Self.Canvas.TextWidth(lSizePercent.Caption);
  lSizePercent.Left := 5;
  lSizePercent.Top := 5 + cbPrintEmptyTickets.Top + cbPrintEmptyTickets.Height;


  tbSizePercent := TTrackBar.Create(Self);
  tbSizePercent.Parent := pSettings;
  tbSizePercent.Orientation := trHorizontal;
  tbSizePercent.Max := 250;
  tbSizePercent.Min := 100;
  tbSizePercent.Frequency := 10;
  tbSizePercent.TickMarks := tmBottomRight;
  tbSizePercent.TickStyle := tsAuto;
  //tbSizePercent.SliderVisible := False;
  tbSizePercent.OnChange := TrackBarChange;
  tbSizePercent.Position := TicketParams.SizePercent;
  TrackBarChange(tbSizePercent);
  tbSizePercent.Left := 5;
  tbSizePercent.Top := 5 + lSizePercent.Top + lSizePercent.Height;
  tbSizePercent.Width := cbPrintEmptyTickets.Width;

  gbColumns := TGroupBox.Create(Self);
  gbColumns.Parent := pSettings;
  gbColumns.Caption := ' Печатаемые элементы ценника ';
  gbColumns.Width := Self.Canvas.TextWidth(gbColumns.Caption) + 30;
  gbColumns.Left := 5;
  gbColumns.Top := 5 + tbSizePercent.Top + tbSizePercent.Height;

  cbClientName := AddCheckBox(15, 'Наименование клиента', TicketParams.ClientNameVisible);
  cbProduct := AddCheckBox(5 + cbClientName.Top + cbClientName.Height, 'Наименование', TicketParams.ProductVisible);
  cbCountry := AddCheckBox(5+ cbProduct.Top + cbProduct.Height, 'Страна', TicketParams.CountryVisible);
  cbProducer := AddCheckBox(5+ cbCountry.Top + cbCountry.Height, 'Производитель', TicketParams.ProducerVisible);
  cbPeriod := AddCheckBox(5+ cbProducer.Top + cbProducer.Height, 'Срок годности', TicketParams.PeriodVisible);
  cbProviderDocumentId := AddCheckBox(5+ cbPeriod.Top + cbPeriod.Height, 'Номер накладной', TicketParams.ProviderDocumentIdVisible);
  cbSignature := AddCheckBox(5+ cbProviderDocumentId.Top + cbProviderDocumentId.Height, 'Поставщик', TicketParams.SignatureVisible);
  cbSerialNumber := AddCheckBox(5+ cbSignature.Top + cbSignature.Height, 'Серия товара', TicketParams.SerialNumberVisible);
  cbDocumentDate := AddCheckBox(5+ cbSerialNumber.Top + cbSerialNumber.Height, 'Дата накладной', TicketParams.DocumentDateVisible);
  gbColumns.Height := cbDocumentDate.Top + cbDocumentDate.Height + 20;
  if gbColumns.Width < cbClientName.Width + 10 then
    gbColumns.Width := cbClientName.Width + 10;

  pSettings.Width := gbColumns.Width + 30;
  Self.Width := pSettings.Width;

  pSettings.Height := gbColumns.Top + gbColumns.Height + 20;
  Self.Height := pSettings.Height + pButton.Height + 20;

  pSettings.Align := alClient;
end;

procedure TEditTicketReportParamsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOK) and CanClose
  then begin
    TicketParams.PrintEmptyTickets := cbPrintEmptyTickets.Checked;
    TicketParams.SizePercent := tbSizePercent.Position;
    TicketParams.ClientNameVisible := cbClientName.Checked;
    TicketParams.ProductVisible := cbProduct.Checked;
    TicketParams.CountryVisible := cbCountry.Checked;
    TicketParams.ProducerVisible := cbProducer.Checked;
    TicketParams.PeriodVisible := cbPeriod.Checked;
    TicketParams.ProviderDocumentIdVisible := cbProviderDocumentId.Checked;
    TicketParams.SignatureVisible := cbSignature.Checked;
    TicketParams.SerialNumberVisible := cbSerialNumber.Checked;
    TicketParams.DocumentDateVisible := cbDocumentDate.Checked;
  end;
end;

procedure TEditTicketReportParamsForm.FormCreate(Sender: TObject);
begin
  inherited;
  TicketParams := TTicketReportParams.Create(DM.MainConnection);
  Self.Caption := 'Настройка печати ценников';
  Self.Position := poMainFormCenter;
  Self.OnCloseQuery := FormCloseQuery;
  CreateVisibleComponents;
end;

procedure TEditTicketReportParamsForm.FormDestroy(Sender: TObject);
begin
  TicketParams.Free;
  inherited;
end;

procedure TEditTicketReportParamsForm.TrackBarChange(Sender: TObject);
begin
  lSizePercent.Caption := 'Размер ценников: ' + IntToStr(tbSizePercent.Position) + '%';
end;


end.
