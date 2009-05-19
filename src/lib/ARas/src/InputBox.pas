unit InputBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TInputBoxForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lblPrompt: TLabel;
    edtValue: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function InputBoxA(const ACaption, APrompt: string; var Value: string; Password: Boolean): Boolean;

implementation

{$R *.DFM}

function InputBoxA(const ACaption, APrompt: string; var Value: string; Password: Boolean): Boolean;
begin
  with TInputBoxForm.Create(Application) do try
    if Password then edtValue.PasswordChar:='*';
    Caption:=ACaption;
    lblPrompt.Caption:=APrompt;
    edtValue.Text:=Value;
    Result:=ShowModal=mrOk;
    if Result then Value:=edtValue.Text;
  finally
    Free;
  end;
end;


end.
