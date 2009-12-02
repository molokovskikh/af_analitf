{ ################################################ }
{ #                                              # }
{ #   Simple File_to_Array dumper by Dr.Golova   # }
{ #   mailto: dr.golova@reversing.net            # }
{ #                                              # }
{ ################################################ }

program dll_dump;
{$APPTYPE CONSOLE}

var
  F1   : File;
  F2   : Text;
  I    : Integer;
  S    : String;
  Data : PChar;

begin
  Writeln(#13#10'Simple File_to_Array dumper by Dr.Golova...');
  if ParamCount <> 2 then begin
    Writeln('Usage   : dll_dump.exe <source_file.dll> <destination_file>');
    Writeln('Example : dll_dump.exe test_dll.dll dumpdata.inc');
    Halt(1);
  end;

  try
    Assign(F1, ParamStr(1));
    Assign(F2, ParamStr(2));
    Reset(F1, 1);
    Rewrite(F2);
    GetMem(Data, FileSize(F1));
    BlockRead(F1, Data^, FileSize(F1));
    Str(FileSize(F1), S);
    WriteLn(F2, 'const'#13#10'  DumpData : array[1..'+S+'] of Byte = ('#13#10);
    Write(F2, '    ');
    if FileSize(F1) > 0 then
      for I := 1 to FileSize(F1) do begin
        Write(F2, Byte(Data[I-1]):3);
        if I < FileSize(F1) then Write(F2, ', ');
        if I mod 15 = 0 then Write(F2, #13#10'    ');
      end;
    Write(F2, ' );');
    FreeMem(Data, FileSize(F1));
    Close(F1);
    Close(F2);
  except
    Writeln('Some Fatal Error... Sorry...');
    Halt(2);
  end;

  Writeln('All Done...'#13#10);
end.
