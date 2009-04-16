unit Waiting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TWaitingForm = class(TForm)
    lInformation: TLabel;
    Timer: TTimer;
    Animate1: TAnimate;
    Label2: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Terminated : Boolean;
    procedure OnTerminate(Sender: TObject);
  public
    { Public declarations }
  end;

procedure ShowWaiting( Information : String; ChildThread: TThread);

implementation

uses Main, AProc, DModule, UniqueID, SysNames, Exchange;

{$R *.dfm}

procedure ShowWaiting( Information : String; ChildThread: TThread);
var
	WaitingForm: TWaitingForm;
	ProgressAVI: TResourceStream;
begin
	if not SysUtils.FileExists( ExePath + 'Progress.avi') then
	begin
		ProgressAVI := TResourceStream.Create( hInstance, 'PROGRESS', RT_RCDATA);
		try
			ProgressAVI.SaveToFile( ExePath + 'Progress.avi');
		except
			ProgressAVI.Free;
		end;
	end;


  try

    WaitingForm := TWaitingForm.Create(MainForm);
    WaitingForm.lInformation.Caption := Information;
    ChildThread.OnTerminate := WaitingForm.OnTerminate;
    try
      if not SysUtils.FileExists( ExePath + 'Progress.avi') then
        WaitingForm.Animate1.Visible := False
      else
      begin
        WaitingForm.Animate1.FileName := ExePath + 'Progress.avi';
        WaitingForm.Animate1.Active := True;
      end;
      ChildThread.Resume;
      WaitingForm.ShowModal
    finally
      WaitingForm.Free;
    end;

  finally
  end;
end;

procedure TWaitingForm.FormKeyDown(Sender: TObject; var Key: Word;
	Shift: TShiftState);
begin
//	if EnableEscape and ( Key = VK_ESCAPE) then ModalResult := mrCancel;
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

end.
