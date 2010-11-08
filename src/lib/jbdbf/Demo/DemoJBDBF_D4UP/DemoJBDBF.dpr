program DemoJBDBF;

uses
{$IfNDef LINUX}
  Forms,
{$Else}
  QForms,
{$EndIf}
  Demo in 'Demo.pas' {FDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Demo JBDBF';
  Application.CreateForm(TFDemo, FDemo);
  Application.Run;
end.
