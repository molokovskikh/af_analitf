unit Retry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, U_VistaCorrectForm;

type
  TRetryForm = class(TVistaCorrectForm)
    btnRetry: TButton;
    lblRetry: TLabel;
    lblError: TLabel;
    Image1: TImage;
    Timer: TTimer;
    btnCancel: TButton;
    procedure btnRetryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
	Seconds: integer;
	DoRetry: boolean;
    { Public declarations }
  end;

var
  RetryForm: TRetryForm;

implementation

{$R *.dfm}

procedure TRetryForm.FormCreate(Sender: TObject);
begin
	DoRetry := False;
	Timer.Enabled := True;
end;

procedure TRetryForm.FormShow(Sender: TObject);
begin
	lblRetry.Caption := Format( 'ѕовторна€ попытка через %d секунд', [ Seconds]);
	dec( Seconds);
end;

procedure TRetryForm.btnRetryClick(Sender: TObject);
begin
	DoRetry := True;
	Timer.Enabled := False;
end;

procedure TRetryForm.TimerTimer(Sender: TObject);
begin
	//ждем заданное врем€
	if Seconds = 0 then
	begin
		ModalResult := mrOK;
		exit;
	end;
	lblRetry.Caption := Format( 'ѕовторна€ попытка через %d секунд', [ Seconds]);
	dec( Seconds);
end;

procedure TRetryForm.btnCancelClick(Sender: TObject);
begin
	Timer.Enabled := False;
end;

end.
