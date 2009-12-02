program testLibLink;

uses
  Forms,
  U_Main in 'U_Main.pas' {Form1},
  infvercls in '..\AnalitF\RC_RND\infvercls.pas',
  INFHelpers in '..\AnalitF\RC_RND\INFHelpers.pas',
  MDLHelper in '..\Common\DLLHelper\MDLHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
