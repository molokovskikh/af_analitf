unit U_MiniMailForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm,
  U_frameMiniMail, Buttons, ExtCtrls;

type
  TMiniMailForm = class(TVistaCorrectForm)
    pBottom: TPanel;
    spbClose: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure spbCloseClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    FirstKey : Boolean;
  public
    { Public declarations }
    frameMiniMail : TframeMiniMail;
  end;

implementation

{$R *.dfm}

uses
  Main,
  DModule;

procedure TMiniMailForm.FormCreate(Sender: TObject);
begin
  inherited;

  FirstKey := True;
  frameMiniMail := TframeMiniMail.Create(Self);
  frameMiniMail.Parent := Self;
  frameMiniMail.Align := alClient;
end;

procedure TMiniMailForm.FormShow(Sender: TObject);
var
  newMailCount : Integer;
begin
  inherited;

  try
    newMailCount := DM.QueryValue('SELECT COUNT(Id) AS newMailCount FROM Mails where IsNewMail = 1', [], []);
  except
    newMailCount := 0;
  end;

  if newMailCount = 0 then
    Caption := 'Мини-почта'
  else
    Caption := Format('Мини-почта: Получено %d новых сообщений', [newMailCount]);

  Height := 400 + pBottom.Height;
  Width := Application.MainForm.Width;
  Left := Application.MainForm.Left;
  Top := Application.MainForm.Top + Application.MainForm.Height - Height - 40;
  frameMiniMail.PrepareFrame;
  frameMiniMail.dbgMailHeaders.SetFocus();
end;

procedure TMiniMailForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Escape) and not frameMiniMail.InSearch() then
    Close;
  if (Key = VK_SPACE) and FirstKey then begin
    MainForm.actOrderAll.Execute;
  end;
  FirstKey := False;
end;

procedure TMiniMailForm.spbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMiniMailForm.FormDeactivate(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TMiniMailForm.FormHide(Sender: TObject);
begin
  if Assigned(frameMiniMail) then
    frameMiniMail.SaveChanges();
  inherited;
end;

end.
