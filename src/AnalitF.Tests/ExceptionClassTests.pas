unit ExceptionClassTests;

interface

uses
  TestFrameWork;

type
  TTestExceptionClass = class(TTestCase)
   published
    procedure SimpleClassEquals;
    procedure InheritsClassEquals;
  end;

implementation

uses SysUtils;

{ TTestExceptionClass }

procedure TTestExceptionClass.InheritsClassEquals;
var
  exceptionClassInstanse : ExceptionClass;
begin
  exceptionClassInstanse := EHeapException;
  CheckTrue(exceptionClassInstanse = EHeapException, '��������� �������� ������ �� ����� EHeapException');
  CheckTrue(exceptionClassInstanse.InheritsFrom(Exception), '��������� �������� ������ �� ����������� �� Exception');
  CheckTrue(exceptionClassInstanse.InheritsFrom(EHeapException), '��������� �������� ������ �� ����������� �� EHeapException');
  CheckFalse(exceptionClassInstanse = EOutOfMemory, '��������� �������� ������ ����� EOutOfMemory');
  CheckFalse(exceptionClassInstanse.InheritsFrom(EOutOfMemory), '��������� �������� ������ ����������� �� EOutOfMemory');

  exceptionClassInstanse := EOutOfMemory;
  CheckTrue(exceptionClassInstanse = EOutOfMemory, '��������� �������� ������ �� ����� EOutOfMemory');
  CheckTrue(exceptionClassInstanse.InheritsFrom(Exception), '��������� �������� ������ �� ����������� �� Exception');
  CheckTrue(exceptionClassInstanse.InheritsFrom(EHeapException), '��������� �������� ������ �� ����������� �� EHeapException');
  CheckTrue(exceptionClassInstanse.InheritsFrom(EOutOfMemory), '��������� �������� ������ �� ����������� �� EOutOfMemory');
  CheckFalse(exceptionClassInstanse = EHeapException, '��������� �������� ������ ����� EHeapException');
  CheckFalse(exceptionClassInstanse = Exception, '��������� �������� ������ ����� Exception');
end;

procedure TTestExceptionClass.SimpleClassEquals;
var
  exceptionClassInstanse : ExceptionClass;
begin
  exceptionClassInstanse := EAbort;
  CheckTrue(exceptionClassInstanse = EAbort, '��������� �������� ������ �� ����� EAbort');
  CheckTrue(exceptionClassInstanse.InheritsFrom(Exception), '��������� �������� ������ �� ����������� �� Exception');
  CheckTrue(exceptionClassInstanse.InheritsFrom(EAbort), '��������� �������� ������ �� ����������� �� EAbort');
  CheckFalse(exceptionClassInstanse.InheritsFrom(EOutOfMemory), '��������� �������� ������ ����������� �� EOutOfMemory');
end;

initialization
  TestFramework.RegisterTest(TTestExceptionClass.Suite);
end.
