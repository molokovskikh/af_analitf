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
  //ќтказалс€ от этого решени€ в пользу решени€:
  http://qc.embarcadero.com/wc/qcmain.aspx?d=37403
  ALT Key press causes controls to disappear under Themes in Vista and XP

  Update (Dec 18 2006): Per-Erik Andersson came up with a new approach that is MUCH BETTER.
  It hooks the WM_UPDATEUISTATE message and only requires a single component instance to handle all forms
  in an application. Source is available at http://cc.codegear.com/item/24282

  if CheckWin32Version(5, 1) then
    Params.ExStyle := Params.ExStyle or WS_EX_COMPOSITED;
}    
end;

end.
