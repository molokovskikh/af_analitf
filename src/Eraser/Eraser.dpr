library Eraser;

uses
  Windows,
  SysUtils,
  Classes,
  StrUtils,
  LU_Tracer in '..\common\LU_Tracer.pas',
  FileUtil;

const
  BackDir = 'UpdateBackup';

{$R *.res}

procedure Erase; stdcall;
var
  trLog : TTracer;

  function UpdateFiles(InDir, OutDir, BackDir : String) : Boolean;
  var
    SR : TSearchRec;
    I : Integer;
  begin
    Result := True;
    if FindFirst(InDir + '*.*', faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then

          //���� �� ��������� ����������
          if (sr.Attr and faDirectory > 0) then begin

            //�������� ������� ���������� � �������������� ����������
            if not DirectoryExists(OutDir + sr.Name) then
              if not CreateDir(OutDir + sr.Name) then begin
                Result := False;
                trLog.TR('Eraser', '�� ���������� ������� ���������� ' + OutDir + sr.Name + ': ' +
                  SysErrorMessage(GetLastError()));
                Exit;
              end;

            //�������� ������� ���������� � Backup-����������
            if not DirectoryExists(BackDir + sr.Name) then
              if not CreateDir(BackDir + sr.Name) then begin
                Result := False;
                trLog.TR('Eraser', '�� ���������� ������� ���������� ' + BackDir + sr.Name + ': ' +
                  SysErrorMessage(GetLastError()));
                Exit;
              end;

            //��������� ������� ���������� ��� ��������� ����������
            Result := UpdateFiles(InDir + sr.Name + '\', OutDir + sr.Name + '\', BackDir + sr.Name + '\');
            if not Result then
              Exit;
          end
          else begin

            //�������� ������� ��������� ����� ������������ ����� � ����� ����� ������� ����
            if FileExists(OutDir + sr.Name) then begin
              Result := False;
              for I := 1 to 20 do begin
                if Windows.CopyFile(PChar(OutDir +  sr.Name), PChar(BackDir + sr.Name + '.bak'), false) then begin
                  Result := True;
                  break;
                end;
                Sleep(500);
              end;
              if not Result then begin
                trLog.TR('Eraser', '�� ���������� ������� ����� ����� ' + sr.Name + ': ' +
                  SysErrorMessage(GetLastError()));
                Exit;
              end;

              //�������� ���������� �������� �����
              Result := False;
              for I := 1 to 20 do begin
                if Windows.SetFileAttributes(PChar(OutDir + sr.Name), FILE_ATTRIBUTE_NORMAL) then begin
                  Result := True;
                  break;
                end;
                Sleep(500);
              end;
              if not Result then begin
                trLog.TR('Eraser', '�� ���������� ���������� �������� ����� ' + sr.Name + ': ' +
                  SysErrorMessage(GetLastError()));
                Exit;
              end;

              //�������� ������� ����
              Result := False;
              for I := 1 to 20 do begin
                if Windows.DeleteFile(PChar(OutDir + sr.Name)) then begin
                  Result := True;
                  break;
                end;
                Sleep(500);
              end;
              if not Result then begin
                trLog.TR('Eraser', '�� ���������� ������� ���� ' + sr.Name + ': ' +
                  SysErrorMessage(GetLastError()));
                Exit;
              end;
            end;


            //�������� �������� ����
            Result := False;
            for I := 1 to 20 do begin
              if Windows.MoveFile(PChar(InDir +  sr.Name), PChar(OutDir + sr.Name)) then begin
                Result := True;
                break;
              end;
              Sleep(500);
            end;
            if not Result then begin
              trLog.TR('Eraser', '�� ���������� ������������ ���� ' + sr.Name + ': ' +
                SysErrorMessage(GetLastError()));
              Exit;
            end;
          end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  end;

var
	SI: TStartupInfo;
	PI: TProcessInformation;
  PH64 : Int64;
  PH : THandle;
  ExeName,
  ExePath,
  InDir,
  Switch : String;
  
begin
  try

    trLog := TTracer.Create(ChangeFileExt(ParamStr(ParamCount-1), 'up'), 'log', 0);
    try

      //����, ���� ��������� ������� �� �������� ������
      if TryStrToInt64(ParamStr(ParamCount-2), PH64) then begin
        PH := OpenProcess(SYNCHRONIZE, FALSE, PH64);
        if PH <> 0 then begin
          WaitForSingleObject(PH, 60000);
          CloseHandle(PH);
        end;
      end;

      //������ ��������� ������
      //���������� � ����������� (��� �����)
      InDir := ParamStr(ParamCount);
      //��� ����� ��� �������
      ExeName := ParamStr(ParamCount-1);
      //������������� ��� �������
      Switch := ParamStr(ParamCount-3);
      //���������� � ������������ ������� (�� ������)
      ExePath := ExtractFilePath(ExeName);

      //�������� ������� ���������� ��� Backup
      if DirectoryExists(ExePath + BackDir) then
        if not ClearDir(ExePath + BackDir, True) then
          trLog.TR('Eraser', '�� ���������� ������� ���������� ' + BackDir
            + ': ' + SysErrorMessage(GetLastError()));

      //���� ��������� ������, ����� ������� ������ ������� ����������
      Sleep(5000);

      //������� ���������� ��� Backup
      if not DirectoryExists(ExePath + BackDir) then
        if not CreateDir(ExePath + BackDir) then begin
          trLog.TR('Eraser', '�� ���������� ������� ���������� ' + BackDir
            + ': ' + SysErrorMessage(GetLastError()));
          Exit;
        end;

      if not UpdateFiles(NormalDir(InDir), NormalDir(ExePath), NormalDir(ExePath + BackDir)) then begin
        if AnsiSameText(Switch, '/si') or AnsiSameText(Switch, '-si') then
          trLog.TR('Eraser', '���������� ��������� ����������� � �������.'#13#10'����������, ��������� � �� �������.')
        else
          MessageBox(0, '���������� ��������� ����������� � �������.'#13#10'����������, ��������� � �� �������.', '������', MB_ICONERROR)
      end
      else begin
        if not ClearDir(InDir, True) then
          trLog.TR('Eraser', '�� ���������� ������� ���������� ' + InDir
            + ': ' + SysErrorMessage(GetLastError()));

        FillChar( SI, SizeOf( SI), 0);
        SI.cb := SizeOf( SI);
        CreateProcess( nil, PChar( ExeName + ' ' +
          Switch), nil, nil, False,
          CREATE_DEFAULT_ERROR_MODE, nil,
          PChar( ExePath ), SI, PI);
      end;

    finally
      trLog.Free;
    end;

  except
  end;
 	FreeLibrary( GetModuleHandle(nil) );
end;

exports Erase;

begin
end.
