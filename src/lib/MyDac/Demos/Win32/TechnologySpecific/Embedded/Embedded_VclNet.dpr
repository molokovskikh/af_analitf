program Embedded_VclNet;

{%DelphiDotNetAssemblyCompiler '$(SystemRoot)\microsoft.net\framework\v1.1.4322\system.drawing.dll'}

uses
  Forms,
  Main in 'Main.pas' {fmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
