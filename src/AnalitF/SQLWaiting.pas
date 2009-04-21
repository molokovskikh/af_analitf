unit SQLWaiting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pFIBDataSet, FIBQuery, FIBDataSet, ExtCtrls;

type
  TfrmSQLWaiting = class(TForm)
    lWait: TLabel;
    tmFill: TTimer;
    lCaption: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmFillTimer(Sender: TObject);
  private
    { Private declarations }
    ds : TpFIBDataSet;
    TM : TThreadMethod;
    OldFetch : TOnFetchRecord;
    Opened : Boolean;
    FetchCount : Integer;
    procedure NewFetch(FromQuery:TFIBQuery;RecordNumber:integer;var StopFetching:boolean);
  public
    { Public declarations }
  end;

var
  frmSQLWaiting: TfrmSQLWaiting;

procedure ShowSQLWaiting(DS : TpFIBDataSet; lCaption : String = '����������� ������ ������'); overload;

procedure ShowSQLWaiting(TM : TThreadMethod; lCaption : String);overload;

implementation

{$R *.dfm}

procedure ShowSQLWaiting(DS : TpFIBDataSet; lCaption : String);
begin
  frmSQLWaiting := TfrmSQLWaiting.Create(nil);
  try
    frmSQLWaiting.lCaption.Caption := lCaption;
    frmSQLWaiting.OldFetch := ds.AfterFetchRecord;
    ds.AfterFetchRecord := frmSQLWaiting.NewFetch;
    frmSQLWaiting.ds := DS;
    frmSQLWaiting.ShowModal;
  finally
    ds.AfterFetchRecord := frmSQLWaiting.OldFetch;
    frmSQLWaiting.Free;
  end;
end;

procedure ShowSQLWaiting(TM : TThreadMethod; lCaption : String);overload;
begin
  frmSQLWaiting := TfrmSQLWaiting.Create(nil);
  try
    frmSQLWaiting.lCaption.Caption := lCaption;
    frmSQLWaiting.TM := TM;
    frmSQLWaiting.ShowModal;
  finally
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
  Inc(FetchCount);
  if FetchCount mod 200 = 0 then
    Application.ProcessMessages;
  if Assigned(OldFetch) then
    OldFetch(FromQuery, RecordNumber, StopFetching);
end;

procedure TfrmSQLWaiting.tmFillTimer(Sender: TObject);
begin
  tmFill.Enabled := False;
  try
    FetchCount := 0;
    if Assigned(ds) then
      if ds.Active then ds.CloseOpen(True) else ds.Open;
    if Assigned(TM) then
      TM;
  finally
    Opened := True;
    Close;
  end;
end;

end.