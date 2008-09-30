program ExternalP;

uses
  Windows, SysUtils;

var
  TempDir : String;
  SR : TSearchRec;

  Log : Text;

begin
  AssignFile(Log, ChangeFileExt(ParamStr(0), '.log'));
  Rewrite(Log);
  WriteLn(Log, 'Started');
  if ParamCount > 0 then
    WriteLn(Log, 'Params : ' + ParamStr(1));
  TempDir := ExtractFilePath(ParamStr(0));
  if FindFirst(TempDir + 'Out\*.*', faAnyFile, SR) = 0 then begin
    repeat
      if (SR.Attr and faDirectory) = 0 then begin
        WriteLn(Log, 'Find : ' + TempDir + 'Out\' + SR.Name);
        if DeleteFile(TempDir + 'Out\' + SR.Name) then 
          WriteLn(Log, 'Delete : OK');
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  Sleep(5000);
  WriteLn(Log, 'Stopped');
  CloseFile(Log);
end.