unit DocumentHeaders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, ComCtrls, StdCtrls, GridsEh, DBGridEh,
  ToughDBGrid, DB, MemDS, DBAccess, MyAccess;

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
    procedure FormCreate(Sender: TObject);
    procedure dtpDateCloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetParameters;
    procedure SetDateInterval;
  end;

  procedure ShowDocumentHeaders;

implementation

uses Main, DateUtils, DModule;

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
{
  FOrdersForm := TOrdersForm( FindChildControlByClass(MainForm, TOrdersForm) );
  if FOrdersForm = nil then
    FOrdersForm := TOrdersForm.Create( Application);
}

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



end.
