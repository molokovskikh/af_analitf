unit NotFound;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TNotFoundForm = class(TForm)
    btnClose: TButton;
    Memo: TMemo;
    Button1: TButton;
    SaveDialog: TSaveDialog;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowNotFound(Strings: TStrings);

procedure ShowNotSended(ALog: String);

implementation

{$R *.dfm}

procedure ShowNotSended(ALog: String);
begin
  with TNotFoundForm.Create(Application) do try
    Caption := '�� ������������ ������';
    Label1.Caption := '��������� ������ �� ������� ��������� :';
    Memo.Lines.Text := ALog;
    ShowModal;
  finally
    Free;
  end;
end;

procedure ShowNotFound(Strings: TStrings);
begin
  with TNotFoundForm.Create(Application) do try
    Caption := '�� ��������� �������';
    Label1.Caption := '����������� �� ������ �������� �� ������ ����������� :';
    Memo.Lines.Assign(Strings);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TNotFoundForm.Button1Click(Sender: TObject);
begin
	if SaveDialog.Execute then Memo.Lines.SaveToFile(SaveDialog.FileName);
end;

end.
