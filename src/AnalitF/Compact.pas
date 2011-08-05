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
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
  Seconds: integer;
  Action : String;
  public
    { Public declarations }
  end;

  procedure ShowAction(Caption, Action : String; Seconds : Integer; ShowCancel : Boolean = False);

implementation

{$R *.dfm}

procedure ShowAction(Caption, Action : String; Seconds : Integer; ShowCancel : Boolean = False);
var
  CompactForm: TCompactForm;
begin
  CompactForm := TCompactForm.Create(Application);
  try
    CompactForm.lblMessage.Caption := Caption;
    CompactForm.btnCancel.Visible := ShowCancel;
    CompactForm.Action := Action;
    CompactForm.Seconds := Seconds;
    CompactForm.ShowModal;
  finally
    CompactForm.Free;
  end;
end;

procedure TCompactForm.FormShow(Sender: TObject);
begin
  lblCompact.Caption :=
    Format(
      '%s будет произведено через %d секунд',
      [Action, Seconds]);
  dec( Seconds);
  Timer.Enabled := True;
end;

procedure TCompactForm.btnCancelClick(Sender: TObject);
begin
  Timer.Enabled := False;
end;

procedure TCompactForm.TimerTimer(Sender: TObject);
begin
  //ждем заданное время
  if Seconds = 0 then
  begin
    ModalResult := mrOK;
    exit;
  end;
  lblCompact.Caption :=
    Format(
      '%s будет произведено через %d секунд',
      [Action, Seconds]);
  dec( Seconds);
end;

end.
