unit SQLWaiting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pFIBDataSet, FIBQuery, FIBDataSet, ExtCtrls;

type
  TfrmSQLWaiting = class(TForm)
    lWait: TLabel;
    tmFill: TTimer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmFillTimer(Sender: TObject);
  private
    { Private declarations }
    ds : TpFIBDataSet;
    OldFetch : TOnFetchRecord;
    Opened : Boolean;
    procedure NewFetch(FromQuery:TFIBQuery;RecordNumber:integer;var StopFetching:boolean);
  public
    { Public declarations }
  end;

var
  frmSQLWaiting: TfrmSQLWaiting;

procedure ShowSQLWaiting(DS : TpFIBDataSet);

implementation

{$R *.dfm}

procedure ShowSQLWaiting(DS : TpFIBDataSet);
begin
  frmSQLWaiting := TfrmSQLWaiting.Create(nil);
  try
    frmSQLWaiting.OldFetch := ds.AfterFetchRecord;
    ds.AfterFetchRecord := frmSQLWaiting.NewFetch;
    frmSQLWaiting.ds := DS;
    frmSQLWaiting.ShowModal;
  finally
    ds.AfterFetchRecord := frmSQLWaiting.OldFetch;
    frmSQLWaiting.Free;
  end;
end;

procedure TfrmSQLWaiting.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := Opened;
end;

procedure TfrmSQLWaiting.NewFetch(FromQuery: TFIBQuery;
  RecordNumber: integer; var StopFetching: boolean);
begin
  Application.ProcessMessages;
  if Assigned(OldFetch) then
    OldFetch(FromQuery, RecordNumber, StopFetching);
end;

procedure TfrmSQLWaiting.tmFillTimer(Sender: TObject);
begin
  tmFill.Enabled := False;
  if ds.Active then ds.CloseOpen(True) else ds.Open;
  Opened := True;
  Close;
end;

end.
