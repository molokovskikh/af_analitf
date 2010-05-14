unit U_VistaCorrectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TVistaCorrectForm = class(TForm)
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TVistaCorrectForm }

procedure TVistaCorrectForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  {
    This only works on Windows XP and above
    ��� ������� �� ������� ����������� ��� ������� Alt ��� ���� "Windows Vista"
    ����� ������: http://www.stevetrefethen.com/blog/UsingTheWSEXCOMPOSITEWindowStyleToEliminateFlickerOnWindowsXP.aspx
    �� ���� �������� ���� ������ ������� ��� ������� ��� Vista: http://www.installationexcellence.com/articles/VistaWithDelphi/Index.html
  }
{
  if CheckWin32Version(5, 1) then
    Params.ExStyle := Params.ExStyle or WS_EX_COMPOSITED;
}    
end;

end.
