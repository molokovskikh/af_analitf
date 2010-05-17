unit SQLWaiting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBAccess,
  U_VistaCorrectForm;

type
  TfrmSQLWaiting = class(TVistaCorrectForm)
    lWait: TLabel;
    tmFill: TTimer;
    lCaption: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmFillTimer(Sender: TObject);
  private
    { Private declarations }
    ds : TCustomDADataSet;
    TM : TThreadMethod;
    OldBeforFetch : TBeforeFetchEvent;
    Opened : Boolean;
    FetchCount : Integer;
    procedure NewBeforeFetch(Dataset: TCustomDADataSet; var Cancel: boolean);
  public
    { Public declarations }
  end;

var
  frmSQLWaiting: TfrmSQLWaiting;

procedure ShowSQLWaiting(DS : TCustomDADataSet; lCaption : String = 'Выполняется запрос данных'); overload;

procedure ShowSQLWaiting(TM : TThreadMethod; lCaption : String);overload;

implementation

{$R *.dfm}

procedure ShowSQLWaiting(DS : TCustomDADataSet; lCaption : String);
begin
  frmSQLWaiting := TfrmSQLWaiting.Create(nil);
  try
    frmSQLWaiting.lCaption.Caption := lCaption;
    frmSQLWaiting.OldBeforFetch := ds.BeforeFetch;
    ds.BeforeFetch := frmSQLWaiting.NewBeforeFetch;
    frmSQLWaiting.ds := DS;
    frmSQLWaiting.ShowModal;
  finally
    ds.BeforeFetch := frmSQLWaiting.OldBeforFetch;
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

procedure TfrmSQLWaiting.NewBeforeFetch(Dataset: TCustomDADataSet;
  var Cancel: boolean);
begin
  Inc(FetchCount);
  if FetchCount mod 200 = 0 then
    Application.ProcessMessages;
  if Assigned(OldBeforFetch) then
    OldBeforFetch(Dataset, Cancel);
end;

procedure TfrmSQLWaiting.tmFillTimer(Sender: TObject);
begin
  tmFill.Enabled := False;
  try
    FetchCount := 0;
    if Assigned(ds) then
      if ds.Active then begin
        ds.Close;
        ds.Open;
      end
      else
        ds.Open;
    if Assigned(TM) then
      TM;
  finally
    Opened := True;
    Close;
  end;
end;

end.
