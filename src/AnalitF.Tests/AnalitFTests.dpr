program AnalitFTests;

uses
  Forms,
  TestFrameWork,
  GUITestRunner,
  ExceptionClassTests in 'ExceptionClassTests.pas';

{$R *.res}

begin
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.
