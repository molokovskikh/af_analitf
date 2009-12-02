library test_dll;
{$IMAGEBASE $10000000}

uses
  Windows, Messages;

const
  Caption   = 'Hi from dll...';
  Init      = 'Now DLL is Initialized !!!';
  NameFunc1 = 'This is Function1 by Name call.';
  NameFunc2 = 'This is Function2 by Name call.';
  NameFunc3 = 'This is Function3 by Name call.';
  OrdFunc1  = 'This is Function1 by Ordinal call.';
  OrdFunc2  = 'This is Function2 by Ordinal call.';
  OrdFunc3  = 'This is Function3 by Ordinal call.';

procedure Function1;
begin
  MessageBox(0, NameFunc1, Caption , 0);
end;

procedure Function2;
begin
  MessageBox(0, NameFunc2, Caption , 0);
end;

procedure Function3;
begin
  MessageBox(0, NameFunc3, Caption , 0);
end;

procedure Ord1;
begin
  MessageBox(0, OrdFunc1, Caption , 0);
end;

procedure Ord2;
begin
  MessageBox(0, OrdFunc2, Caption , 0);
end;

procedure Ord3;
begin
  MessageBox(0, OrdFunc3, Caption , 0);
end;

exports
  Function1,    // By Names.
  Function2,
  Function3,
  Ord1 index 1, // By Ordinals.
  Ord2 index 2,
  Ord3 index 3;

begin
  MessageBox(0, Init, Caption, 0);
end.
