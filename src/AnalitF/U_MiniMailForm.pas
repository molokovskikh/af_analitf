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
  private
    { Private declarations }
    FirstKey : Boolean;
  public
    { Public declarations }
    frameMiniMail : TframeMiniMail;
  end;

  function ShowMiniMail() : TModalResult;

implementation

{$R *.dfm}

function ShowMiniMail() : TModalResult;
var
  FMiniMailForm: TMiniMailForm;
begin
  FMiniMailForm := TMiniMailForm.Create(Application);
  try
    Result := FMiniMailForm.ShowModal;
  finally
    FMiniMailForm.Free;
  end;
end;

procedure TMiniMailForm.FormCreate(Sender: TObject);
begin
  inherited;

  FirstKey := True;
  frameMiniMail := TframeMiniMail.Create(Self);
  frameMiniMail.Parent := Self;
  frameMiniMail.Align := alClient;
end;

procedure TMiniMailForm.FormShow(Sender: TObject);
begin
  inherited;
  Height := 250 + pBottom.Height;
  Width := Application.MainForm.Width;
  Left := Application.MainForm.Left;
  Top := Application.MainForm.Height - Height - 40;
  frameMiniMail.PrepareFrame;
  frameMiniMail.dbgMailHeaders.SetFocus();
end;

procedure TMiniMailForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Escape then
    ModalResult := mrOk;
  if (Key = VK_SPACE) and FirstKey then
    ModalResult := mrRetry;
  FirstKey := False;
end;

procedure TMiniMailForm.spbCloseClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
