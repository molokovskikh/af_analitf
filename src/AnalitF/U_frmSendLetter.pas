unit U_frmSendLetter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmSendLetter = class(TForm)
    cbAddLogs: TCheckBox;
    btnSend: TButton;
    btnCancel: TButton;
    odAttach: TOpenDialog;
    gbMessage: TGroupBox;
    leSubject: TLabeledEdit;
    lBody: TLabel;
    mBody: TMemo;
    gbAttach: TGroupBox;
    lbFiles: TListBox;
    btnAddFile: TButton;
    btnDelFile: TButton;
    procedure btnAddFileClick(Sender: TObject);
    procedure btnDelFileClick(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshScrollWidth;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
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

procedure TfrmSendLetter.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  {
    This only works on Windows XP and above
    Ёто решение по скрытию компонентов при нажатии Alt при теме "Windows Vista"
    ¬з€то отсюда: http://www.stevetrefethen.com/blog/UsingTheWSEXCOMPOSITEWindowStyleToEliminateFlickerOnWindowsXP.aspx
    Ќа этой странице есть другие решени€ дл€ проблем под Vista: http://www.installationexcellence.com/articles/VistaWithDelphi/Index.html
  }
  if CheckWin32Version(5, 1) then
    Params.ExStyle := Params.ExStyle or WS_EX_COMPOSITED;
end;

end.
