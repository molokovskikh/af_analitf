unit ShowLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmShowLog = class(TForm)
    mLog: TMemo;
    btnClose: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmShowLog: TfrmShowLog;

procedure RunShowLog(ALog : String);

implementation

{$R *.dfm}

procedure RunShowLog(ALog : String);
begin
  frmShowLog:= TfrmShowLog.Create(Application);
  try
    frmShowLog.mLog.Text := ALog;
    frmShowLog.ShowModal;
  finally
    frmShowLog.Free;
  end;
end;


end.
