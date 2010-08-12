unit Waiting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,
  UpdateExeThread;

type
  TWaitingForm = class(TForm)
    lInformation: TLabel;
    Timer: TTimer;
    Animate1: TAnimate;
    Label2: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    Terminated : Boolean;
    procedure OnTerminate(Sender: TObject);
  public
    { Public declarations }
  end;

procedure ShowWaiting( Information : String; ChildThread: TUpdateExeThread);

implementation

{$R *.dfm}

procedure ShowWaiting( Information : String; ChildThread: TUpdateExeThread);
var
	WaitingForm: TWaitingForm;
begin
  try

    WaitingForm := TWaitingForm.Create(Application);
    WaitingForm.lInformation.Caption := Information;
    ChildThread.OnTerminate := WaitingForm.OnTerminate;
    try
      WaitingForm.Animate1.Active := True;
      ChildThread.WaitFormHandle := WaitingForm.Handle;
      ChildThread.Resume;
      WaitingForm.ShowModal
    finally
      WaitingForm.Free;
    end;

  finally
  end;
end;

procedure TWaitingForm.TimerTimer(Sender: TObject);
begin
  if Terminated then ModalResult := mrOK;
end;

procedure TWaitingForm.FormCreate(Sender: TObject);
begin
  Terminated := False;
end;

procedure TWaitingForm.OnTerminate(Sender: TObject);
begin
  Terminated := True;
end;

procedure TWaitingForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := Terminated;
end;

end.
