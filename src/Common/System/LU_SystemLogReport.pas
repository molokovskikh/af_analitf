unit LU_SystemLogReport;

interface

uses
  Windows,  SysUtils, LU_DynamicArrays;

const
  kernel32  = 'kernel32.dll';

type
  //Типы событий в системном логе
  TSGLogEventType = (
    letError,           //Ошибка
    letWarrning,        //Предупреждение
    letInformation,     //Информация
    letAuditSuccess,    //Аудит успехов
    letAuditFailure);   //Аудит отказов

  //Тип для получения дискового пространства  
  PULARGE_INTEGER = ^ULARGE_INTEGER;

   //Пишет сообщение об ошибке в системный лог
  procedure    WriteEventInLog(Msg : String; RawData : TSGByteArray);

  //Пишет сообщение в системный лог
  procedure    WriteInSystemLog(
    EventType : TSGLogEventType;
    Msg : String;
    RawData : TSGByteArray);

 {Функция Windows GetDiskFreeSpaceEx - выдает информация о состоянии диска
 Параметры:
  lpDirectoryName - имя интересующей директории на диске
  lpFreeBytesAvailableToCaller - свободное место на диске для текущего процесса
  lpTotalNumberOfBytes - общее количество байт на диске
  lpTotalNumberOfFreeBytes - общее количество свободных байт на диске
 }
function SGGetDiskFreeSpaceExA(
      lpDirectoryName: PAnsiChar;
  var lpFreeBytesAvailableToCaller,
      lpTotalNumberOfBytes: ULARGE_INTEGER;
      lpTotalNumberOfFreeBytes: PULARGE_INTEGER): BOOL; stdcall;

function SGGetDiskFreeSpaceExW(
      lpDirectoryName: PWideChar;
  var lpFreeBytesAvailableToCaller,
      lpTotalNumberOfBytes: ULARGE_INTEGER;
      lpTotalNumberOfFreeBytes: PULARGE_INTEGER): BOOL; stdcall;

function SGGetDiskFreeSpaceEx(
      lpDirectoryName: PChar;
  var lpFreeBytesAvailableToCaller,
      lpTotalNumberOfBytes: ULARGE_INTEGER;
      lpTotalNumberOfFreeBytes: PULARGE_INTEGER): BOOL; stdcall;

implementation

var
  EventLog : THandle;

procedure    WriteEventInLog(Msg : String; RawData : TSGByteArray);
begin
  WriteInSystemLog(letError, Msg, RawData);
end;

procedure    WriteInSystemLog(EventType : TSGLogEventType; Msg : String;
 RawData : TSGByteArray);
var
  wType : Word;
  lpMSG : ^PChar;
begin
  //Если еще не использовали, то регестрим
  if EventLog = INVALID_HANDLE_VALUE then
    EventLog := RegisterEventSource(nil, PChar(ExtractFileName(ParamStr(0))));
  //Получилось зарегестрировать - пишем в лог
  if EventLog <> 0 then begin
    case EventType of
      letError        : wType := EVENTLOG_ERROR_TYPE;
      letWarrning     : wType := EVENTLOG_WARNING_TYPE;
      letInformation  : wType := EVENTLOG_INFORMATION_TYPE;
      letAuditSuccess : wType := EVENTLOG_AUDIT_SUCCESS;
      else              wType := EVENTLOG_AUDIT_FAILURE;
    end;
    New(lpMSG);
    lpMSG^ := PChar(Msg);
    //В зависимости от наличия бинарных данных
    if not Assigned(RawData) then
      ReportEvent(EventLog, wType, 0, 0, nil, 1, 0,
                  lpMSG, nil)
    else
      ReportEvent(EventLog, wType, 0, 0, nil, 1, RawData.Length,
                  lpMSG, RawData.RawData);
    Dispose(lpMSG);
  end
  else
    EventLog := INVALID_HANDLE_VALUE;
end;

function SGGetDiskFreeSpaceExA; external kernel32 name 'GetDiskFreeSpaceExA';
function SGGetDiskFreeSpaceExW; external kernel32 name 'GetDiskFreeSpaceExW';
function SGGetDiskFreeSpaceEx; external kernel32 name 'GetDiskFreeSpaceExA';

initialization
  EventLog := INVALID_HANDLE_VALUE;
finalization
  //Если был зарегестрирован, то аккуратно закрываем
  if EventLog <> INVALID_HANDLE_VALUE then
    DeregisterEventSource(EventLog);
end.
