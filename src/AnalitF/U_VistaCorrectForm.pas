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
    Ёто решение по скрытию компонентов при нажатии Alt при теме "Windows Vista"
    ¬з€то отсюда: http://www.stevetrefethen.com/blog/UsingTheWSEXCOMPOSITEWindowStyleToEliminateFlickerOnWindowsXP.aspx
    Ќа этой странице есть другие решени€ дл€ проблем под Vista: http://www.installationexcellence.com/articles/VistaWithDelphi/Index.html
  }
{
  if CheckWin32Version(5, 1) then
    Params.ExStyle := Params.ExStyle or WS_EX_COMPOSITED;
}    
end;

end.
