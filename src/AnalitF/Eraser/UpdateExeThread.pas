unit UpdateExeThread;

interface

uses
  Windows,
  SysUtils,
  Classes,
  StrUtils,
  LU_Tracer,
  FileUtil;

const
  BackDir = 'UpdateBackup';
  
type
  TUpdateExeThread = class(TThread)
   private
    trLog : TTracer;
    function UpdateFiles(InDir, OutDir, BackDir : String) : Boolean;
    function WaitParentProcess : Boolean;
   protected
    procedure Execute; override;
   public
    WaitFormHandle : HWND;
  end;


implementation

{ TUpdateExeThread }

procedure TUpdateExeThread.Execute;
var
	SI: TStartupInfo;
	PI: TProcessInformation;
  ExeName,
  ExePath,
  InDir,
  Switch : String;
begin
  try
    //����, ���� ��������� ������� �� �������� ������
    if not WaitParentProcess then begin
      MessageBox(WaitFormHandle, '����������� ����� �������� ���������� ����������� ���������.'#13#10'����������, ��������� � �� �������.', '������', MB_ICONERROR);
      Exit;
    end;

    trLog := TTracer.Create(
      IncludeTrailingBackslash(ExtractFileDir(ParamStr(ParamCount-1))) + 'Exchange', 'log', 0);
    try


      //������ ��������� ������
      //���������� � ������������ (��� �����)
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
          MessageBox(WaitFormHandle, '���������� ��������� ����������� � �������.'#13#10'����������, ��������� � �� �������.', '������', MB_ICONERROR)
      end
      else begin
        if not ClearDir(InDir, True) then
          trLog.TR('Eraser', '�� ���������� ������� ���������� ' + InDir
            + ': ' + SysErrorMessage(GetLastError()));

        FreeAndNil(trLog);
        FillChar( SI, SizeOf( SI), 0);
        SI.cb := SizeOf( SI);
        CreateProcess( nil, PChar( ExeName + ' ' +
          Switch), nil, nil, False,
          CREATE_DEFAULT_ERROR_MODE, nil,
          PChar( ExePath ), SI, PI);
      end;

    finally
      if Assigned(trLog) then
        trLog.Free;
    end;
  except
  end;
end;

function TUpdateExeThread.UpdateFiles(InDir, OutDir, BackDir : String) : Boolean;
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


          //�������� �������� ���� � ������� �����������, � ����� �������� ����������,
          //�.�. � ��������� ������� MoveFile � Vista �������� �����������
          Result := False;
          for I := 1 to 20 do begin
            if Windows.CopyFile(PChar(InDir +  sr.Name), PChar(OutDir + sr.Name), False) then begin
              Result := True;
              break;
            end;
            Sleep(500);
          end;
          if not Result then begin
            trLog.TR('Eraser', '�� ���������� ����������� ���� ' + sr.Name + ' � ������� �����: ' +
              SysErrorMessage(GetLastError()));
            Exit;
          end;

          //�������� ���������� �������� ����� � ����� In
          Result := False;
          for I := 1 to 20 do begin
            if Windows.SetFileAttributes(PChar(InDir +  sr.Name), FILE_ATTRIBUTE_NORMAL) then begin
              Result := True;
              break;
            end;
            Sleep(500);
          end;
          if not Result then begin
            trLog.TR('Eraser', '�� ���������� ���������� �������� ����� ' + sr.Name + ' � ����� In: ' +
              SysErrorMessage(GetLastError()));
            Exit;
          end;

          //�������� ������� ���� � ����� In
          Result := False;
          for I := 1 to 20 do begin
            if Windows.DeleteFile(PChar(InDir +  sr.Name)) then begin
              Result := True;
              break;
            end;
            Sleep(500);
          end;
          if not Result then begin
            trLog.TR('Eraser', '�� ���������� ������� ���� ' + sr.Name + ' � ����� In: ' +
              SysErrorMessage(GetLastError()));
            Exit;
          end;

        end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

function TUpdateExeThread.WaitParentProcess: Boolean;
var
  ExternalProcessId : Int64;
  ExternalProcessHandle : THandle;
begin
  Result := True;
  if TryStrToInt64(ParamStr(ParamCount-2), ExternalProcessId) then begin
    ExternalProcessHandle := OpenProcess(Windows.SYNCHRONIZE, FALSE, ExternalProcessId);
    if ExternalProcessHandle <> 0 then begin
      if WaitForSingleObject(ExternalProcessHandle, 3 * 60 * 1000) <> WAIT_OBJECT_0
      then
        //�� ��������� ���������� ���������
        Result := False;
      CloseHandle(ExternalProcessHandle);
    end
    else
      Sleep(10 * 1000);
  end;
end;

end.
