program AnalitFTests;

uses
  Forms,
  TestFrameWork,
  GUITestRunner,
  ExceptionClassTests in 'ExceptionClassTests.pas',
  LoadDataTests in 'LoadDataTests.pas',
  TimeZoneTests in 'TimeZoneTests.pas';

{$R *.res}

begin
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.
