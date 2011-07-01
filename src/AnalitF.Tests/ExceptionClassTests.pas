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
  CheckTrue(exceptionClassInstanse = EHeapException, 'Ёкземпл€р описани€ класса не равен EHeapException');
  CheckTrue(exceptionClassInstanse.InheritsFrom(Exception), 'Ёкземпл€р описани€ класса не унаследован от Exception');
  CheckTrue(exceptionClassInstanse.InheritsFrom(EHeapException), 'Ёкземпл€р описани€ класса не унаследован от EHeapException');
  CheckFalse(exceptionClassInstanse = EOutOfMemory, 'Ёкземпл€р описани€ класса равен EOutOfMemory');
  CheckFalse(exceptionClassInstanse.InheritsFrom(EOutOfMemory), 'Ёкземпл€р описани€ класса унаследован от EOutOfMemory');

  exceptionClassInstanse := EOutOfMemory;
  CheckTrue(exceptionClassInstanse = EOutOfMemory, 'Ёкземпл€р описани€ класса не равен EOutOfMemory');
  CheckTrue(exceptionClassInstanse.InheritsFrom(Exception), 'Ёкземпл€р описани€ класса не унаследован от Exception');
  CheckTrue(exceptionClassInstanse.InheritsFrom(EHeapException), 'Ёкземпл€р описани€ класса не унаследован от EHeapException');
  CheckTrue(exceptionClassInstanse.InheritsFrom(EOutOfMemory), 'Ёкземпл€р описани€ класса не унаследован от EOutOfMemory');
  CheckFalse(exceptionClassInstanse = EHeapException, 'Ёкземпл€р описани€ класса равен EHeapException');
  CheckFalse(exceptionClassInstanse = Exception, 'Ёкземпл€р описани€ класса равен Exception');
end;

procedure TTestExceptionClass.SimpleClassEquals;
var
  exceptionClassInstanse : ExceptionClass;
begin
  exceptionClassInstanse := EAbort;
  CheckTrue(exceptionClassInstanse = EAbort, 'Ёкземпл€р описани€ класса не равен EAbort');
  CheckTrue(exceptionClassInstanse.InheritsFrom(Exception), 'Ёкземпл€р описани€ класса не унаследован от Exception');
  CheckTrue(exceptionClassInstanse.InheritsFrom(EAbort), 'Ёкземпл€р описани€ класса не унаследован от EAbort');
  CheckFalse(exceptionClassInstanse.InheritsFrom(EOutOfMemory), 'Ёкземпл€р описани€ класса унаследован от EOutOfMemory');
end;

initialization
  TestFramework.RegisterTest(TTestExceptionClass.Suite);
end.
