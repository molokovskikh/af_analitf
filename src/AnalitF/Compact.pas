unit Compact;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, U_VistaCorrectForm;

type
  TCompactForm = class(TVistaCorrectForm)
    Timer: TTimer;
    Image1: TImage;
    lblCompact: TLabel;
    btnCancel: TButton;
    lblMessage: TLabel;
    btnOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
	Seconds: integer;
  public
    { Public declarations }
  end;

var
  CompactForm: TCompactForm;

implementation

{$R *.dfm}

procedure TCompactForm.FormCreate(Sender: TObject);
begin
	Seconds := 3;
	Timer.Enabled := True;
end;

procedure TCompactForm.FormShow(Sender: TObject);
begin
	lblCompact.Caption := Format( '—жатие будет произведено через %d секунд', [ Seconds]);
	dec( Seconds);
end;

procedure TCompactForm.btnCancelClick(Sender: TObject);
begin
	Timer.Enabled := False;
end;

procedure TCompactForm.TimerTimer(Sender: TObject);
begin
	//ждем заданное врем€
	if Seconds = 0 then
	begin
		ModalResult := mrOK;
		exit;
	end;
	lblCompact.Caption := Format( '—жатие будет произведено через %d секунд', [ Seconds]);
	dec( Seconds);
end;

end.
