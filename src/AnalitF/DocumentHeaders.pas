unit DocumentHeaders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, ComCtrls, StdCtrls, GridsEh, DBGridEh,
  ToughDBGrid, DB, MemDS, DBAccess, MyAccess, DocumentBodies, DocumentTypes;

type
  TDocumentHeaderForm = class(TChildForm)
    pTop: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel1: TBevel;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    pGrid: TPanel;
    dbgHeaders: TToughDBGrid;
    adsDocumentHeaders: TMyQuery;
    adsDocumentHeadersId: TLargeintField;
    adsDocumentHeadersDownloadId: TLargeintField;
    adsDocumentHeadersWriteTime: TDateTimeField;
    adsDocumentHeadersFirmCode: TLargeintField;
    adsDocumentHeadersClientId: TLargeintField;
    adsDocumentHeadersDocumentType: TWordField;
    adsDocumentHeadersProviderDocumentId: TStringField;
    adsDocumentHeadersOrderId: TLargeintField;
    adsDocumentHeadersHeader: TStringField;
    dsDocumentHeaders: TDataSource;
    adsDocumentHeadersProviderName: TStringField;
    adsDocumentHeadersLocalWriteTime: TDateTimeField;
    procedure FormCreate(Sender: TObject);
    procedure dtpDateCloseUp(Sender: TObject);
    procedure dbgHeadersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgHeadersDblClick(Sender: TObject);
    procedure adsDocumentHeadersDocumentTypeGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
  private
    { Private declarations }
  protected
    FDocumentBodiesForm: TDocumentBodiesForm;
    procedure ProcessDocument;
    procedure ShowArchiveOrder;
  public
    { Public declarations }
    procedure SetParameters;
    procedure SetDateInterval;
  end;

  procedure ShowDocumentHeaders;

implementation

uses Main, DateUtils, DModule, AProc, Orders;

{$R *.dfm}

procedure ShowDocumentHeaders;
var
  document : TDocumentHeaderForm;
begin
  document := TDocumentHeaderForm(MainForm.ShowChildForm( TDocumentHeaderForm ));
  document.ShowForm;
end;

{ TDocumentHeaderForm }

procedure TDocumentHeaderForm.SetParameters;
begin
  adsDocumentHeaders.Close;

  adsDocumentHeaders.ParamByName( 'TimeZoneBias').Value := AProc.TimeZoneBias;
  adsDocumentHeaders.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').Value;
  adsDocumentHeaders.ParamByName( 'DateFrom').AsDate := dtpDateFrom.Date;
  dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
  adsDocumentHeaders.ParamByName( 'DateTo').AsDateTime := dtpDateTo.DateTime;

  adsDocumentHeaders.Open;
end;

procedure TDocumentHeaderForm.FormCreate(Sender: TObject);
var
  Year, Month, Day: Word;
begin
  inherited;
  FDocumentBodiesForm := TDocumentBodiesForm( FindChildControlByClass(MainForm, TDocumentBodiesForm) );
  if not Assigned(FDocumentBodiesForm) then
    FDocumentBodiesForm := TDocumentBodiesForm.Create( Application);

  Year := YearOf( Date);
  Month := MonthOf( Date);
  Day := DayOf( Date);
  IncAMonth( Year, Month, Day, -3);
  dtpDateFrom.Date := StartOfTheMonth( EncodeDate( Year, Month, Day));
  dtpDateTo.Date := Date;

  SetParameters;
end;

procedure TDocumentHeaderForm.dtpDateCloseUp(Sender: TObject);
begin
  SetDateInterval;
  dbgHeaders.SetFocus;
end;

procedure TDocumentHeaderForm.SetDateInterval;
begin
  with adsDocumentHeaders do begin
	ParamByName('DateFrom').AsDate:=dtpDateFrom.Date;
	dtpDateTo.Time := EncodeTime( 23, 59, 59, 999);
	ParamByName('DateTo').AsDateTime := dtpDateTo.DateTime;
    Screen.Cursor:=crHourglass;
    try
      if Active then
      begin
        Close;
        Open;
      end
      else
        Open;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
end;



procedure TDocumentHeaderForm.dbgHeadersKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (Shift = []) then
    ProcessDocument
  else
    if (Key = VK_RETURN) and (Shift = [ssShift]) and not adsDocumentHeadersOrderId.IsNull then
      ShowArchiveOrder;
end;

procedure TDocumentHeaderForm.ProcessDocument;
begin
  if not adsDocumentHeaders.IsEmpty and not adsDocumentHeadersId.IsNull
    and not adsDocumentHeadersDocumentType.IsNull
    and (adsDocumentHeadersDocumentType.Value <> 3) 
  then
    FDocumentBodiesForm.ShowForm(adsDocumentHeadersId.Value, Self);
end;

procedure TDocumentHeaderForm.dbgHeadersDblClick(Sender: TObject);
var
  C : GridsEh.TGridCoord;
  P : TPoint;
begin
  p := TToughDBGrid(Sender).ScreenToClient(Mouse.CursorPos);
  C := TToughDBGrid(Sender).MouseCoord(p.X, p.Y);
  if C.Y > 0 then
    ProcessDocument;
end;

procedure TDocumentHeaderForm.ShowArchiveOrder;
var
  FOrdersForm : TOrdersForm;
begin
  FOrdersForm := TOrdersForm( FindChildControlByClass(MainForm, TOrdersForm) );
  if not Assigned(FOrdersForm) then
    FOrdersForm := TOrdersForm.Create( Application);

  FOrdersForm.ShowForm(adsDocumentHeadersOrderId.AsInteger, Self);
end;

procedure TDocumentHeaderForm.adsDocumentHeadersDocumentTypeGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if DisplayText then
    Text := RussianDocumentType[TDocumentType(Sender.AsInteger)];
end;

end.
