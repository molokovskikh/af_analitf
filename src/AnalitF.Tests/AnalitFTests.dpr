program AnalitFTests;

uses
  Forms,
  TestFrameWork,
  GUITestRunner,
  DatabaseObjects,
  ExceptionClassTests in 'ExceptionClassTests.pas',
  LoadDataTests in 'LoadDataTests.pas',
  TimeZoneTests in 'TimeZoneTests.pas',
  MDLHelper in '..\Common\DLLHelper\MDLHelper.pas',
  SearchFilterControllerTests in 'SearchFilterControllerTests.pas',
  AProcTests in 'AProcTests.pas';

{$R *.res}

begin
{$ifdef USEMEMORYCRYPTDLL}
  //��������� ������������� MemoryLib, �.�. ��� �� ��������
  DatabaseController.DisableMemoryLib();
{$endif}
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.
