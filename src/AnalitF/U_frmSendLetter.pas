unit U_frmSendLetter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, U_VistaCorrectForm;

type
  TfrmSendLetter = class(TVistaCorrectForm)
    odAttach: TOpenDialog;
    pBottom: TPanel;
    btnSend: TButton;
    btnCancel: TButton;
    pTop: TPanel;
    gbMessage: TGroupBox;
    lBody: TLabel;
    leSubject: TLabeledEdit;
    mBody: TMemo;
    pAttach: TPanel;
    gbAttach: TGroupBox;
    lbFiles: TListBox;
    btnAddFile: TButton;
    btnDelFile: TButton;
    pAddLogs: TPanel;
    cbAddLogs: TCheckBox;
    procedure btnAddFileClick(Sender: TObject);
    procedure btnDelFileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshScrollWidth;
  public
    { Public declarations }
  end;

var
  frmSendLetter: TfrmSendLetter;

implementation

{$R *.dfm}

procedure TfrmSendLetter.btnAddFileClick(Sender: TObject);
begin
  if odAttach.Execute then begin
    lbFiles.Items.AddStrings(odAttach.Files);
    RefreshScrollWidth;
  end;
end;

procedure TfrmSendLetter.btnDelFileClick(Sender: TObject);
begin
  lbFiles.DeleteSelected;
  RefreshScrollWidth;
end;

procedure TfrmSendLetter.RefreshScrollWidth;
var
  MaxTextWidth,
  CurrTextWidth,
  I : Integer;
begin
  if lbFiles.Count = 0 then
    lbFiles.ScrollWidth := 0
  else begin
    MaxTextWidth := lbFiles.Canvas.TextWidth(lbFiles.Items[0]);
    for I := 1 to lbFiles.Count-1 do begin
      CurrTextWidth := lbFiles.Canvas.TextWidth(lbFiles.Items[i]);
      if CurrTextWidth > MaxTextWidth then
        MaxTextWidth := CurrTextWidth;
    end;
    lbFiles.ScrollWidth := MaxTextWidth + 5;
  end;
end;

procedure TfrmSendLetter.FormShow(Sender: TObject);
begin
  {
  Кнопки все равно скрываются при использовании "Крупных шрифтов",
  поэтому им явно высталяется положение слева
  Решение натолкнула страница:
  http://www.delphikingdom.com/asp/answer.asp?IDAnswer=38724
  }
  btnCancel.Left := pBottom.Width - 10 - btnCancel.Width;
  btnSend.Left := btnCancel.Left - 10 - btnSend.Width;
end;

end.
