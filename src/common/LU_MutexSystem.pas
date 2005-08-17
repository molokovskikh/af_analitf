unit LU_MutexSystem;

interface

uses
  Windows, SysUtils;

var
  LastErrorMsg : String; //�������� �������� ������

  //���������� True, ���� ��������� �������� � ����� ����������
  //� ������� ��������, ����� �������� �����
  function IsOneStart : Boolean;

implementation

var
  GlobalMutex : THandle;
  LastError : Integer;

function IsOneStart : Boolean;
begin
  Result := GlobalMutex <> 0;
end;

initialization
  GlobalMutex := CreateMutex(nil, True, PChar(StringReplace(ParamStr(0),
                                                '\', '%', [rfReplaceAll])));
  if GlobalMutex = 0 then
    LastErrorMsg := SysErrorMessage(GetLastError)
  else begin
    LastError := GetLastError;
    if LastError <> 0 then begin
      if LastError = ERROR_ALREADY_EXISTS then 
        LastErrorMsg := 'Mutex ��� ����������.'
      else
        LastErrorMsg := SysErrorMessage(LastError);
      ReleaseMutex(GlobalMutex);
      GlobalMutex := 0;
    end;
  end;
finalization
  if GlobalMutex <> 0 then ReleaseMutex(GlobalMutex);
end.
