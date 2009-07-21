
{******************************************}
{                                          }
{             FastScript v1.9              }
{        MYDAC classes and functions       }
{                                          }
{          Created by: Devart              }
{         E-mail: mydac@devart.com         }
{                                          }
{******************************************}

unit fs_imydacrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_idbrtti, fs_idacrtti, DB,
  MyClasses, MyAccess;

type
  TfsMYDACRTTI = class(TComponent); // fake component

implementation

type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
    procedure SetProp(Instance: TObject; ClassType: TClass;
      const PropName: String; Value: Variant);
  public
    constructor Create(AScript: TfsScript); override;
  end;

{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  
  with AScript do begin
    with AddClass(TMyConnection, 'TCustomDAConnection') do begin
      AddMethod('procedure GetCharsetNames(List: TStrings)', CallMethod);
      AddMethod('procedure GetIndexNames(List: TStrings; TableName: string)', CallMethod);
      AddMethod('function GetExecuteInfo: string', CallMethod);
      AddMethod('procedure Ping', CallMethod);
    
      AddProperty('ClientVersion', 'string', GetProp);
      AddProperty('ServerVersion', 'string', GetProp);
    end;

    AddEnum('TMyIsolationLevel', 'ilReadCommitted, ilReadUnCommitted, ilRepeatableRead, ilSerializable');
    AddEnum('TMyProtocol', 'mpDefault, mpTCP, mpSocket, mpPipe, mpMemory, mpSSL');

    AddClass(TCustomMyConnection, 'TDAConnectionOptions');
    AddClass(TMyConnectionOptions, 'TCustomMyConnectionOptions');
    AddClass(TMyConnectionSSLOptions, 'TPersistent');
    
    with AddClass(TCustomMyDataSet, 'TCustomDADataSet') do begin
      AddMethod('function OpenNext: boolean', CallMethod);
      AddMethod('procedure BreakExec', CallMethod);
      AddMethod('procedure RefreshQuick(const CheckDeleted: boolean)', CallMethod);
      AddMethod('procedure LockTable(LockType: TLockType)', CallMethod);
      AddMethod('procedure UnLockTable', CallMethod);
      AddMethod('procedure Lock(LockType: TLockRecordType)', CallMethod);

      AddProperty('CommandTimeout', 'integer', GetProp, SetProp);
    end;
    AddEnum('TLockType', 'ltRead, ltReadLocal, ltWrite, ltWriteLowPriority');
    AddEnum('TLockRecordType', 'lrImmediately, lrDelayed');
    
    AddClass(TMyDataSetOptions, 'TDADataSetOptions');

    AddClass(TMyQuery, 'TCustomMyDataSet');

    with AddClass(TMyTable, 'TCustomMyDataSet') do begin
      AddMethod('procedure PrepareSQL', CallMethod);
      AddMethod('procedure EmptyTable', CallMethod);
      
      AddProperty('TableName', 'string', GetProp, SetProp);
      AddProperty('Limit', 'integer', GetProp, SetProp);
      AddProperty('OrderFields', 'string', GetProp, SetProp);
    end;

    AddClass(TMyTableOptions, 'TMyDataSetOptions');
    
    with AddClass(TMyStoredProc, 'TCustomMyDataSet') do begin
      AddMethod('procedure ExecProc', CallMethod);
      AddMethod('procedure PrepareSQL', CallMethod);

      AddProperty('StoredProcName', 'string', GetProp, SetProp);
    end;
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TMyConnection then begin
    if MethodName = 'GETCHARSETNAMES' then
      TMyConnection(Instance).GetCharsetNames(TStrings(Integer(Caller.Params[0])))
    else
    if MethodName = 'GETINDEXNAMES' then
      TMyConnection(Instance).GetIndexNames(TStrings(Integer(Caller.Params[0])), Caller.Params[1])
    else
    if MethodName = 'GETEXECUTEINFO' then
      Result := TMyConnection(Instance).GetExecuteInfo
    else
    if MethodName = 'PING' then
      TMyConnection(Instance).Ping;
  end
  else
  if ClassType = TCustomMyDataSet then begin
    if MethodName = 'OPENNEXT' then
      Result := TCustomMyDataSet(Instance).OpenNext
    else
    if MethodName = 'BREAKEXEC' then
      TCustomMyDataSet(Instance).BreakExec
    else
    if MethodName = 'REFRESHQUICK' then
      TCustomMyDataSet(Instance).RefreshQuick(Caller.Params[0])
    else
    if MethodName = 'LOCKTABLE' then
      TCustomMyDataSet(Instance).LockTable(TLockType(Integer(Caller.Params[0])))
    else
    if MethodName = 'UNLOCKTABLE' then
      TCustomMyDataSet(Instance).UnLockTable
    else
    if MethodName = 'LOCK' then
      TCustomMyDataSet(Instance).Lock(TLockRecordType(Integer(Caller.Params[0])));
  end
  else
  if ClassType = TMyTable then begin
    if MethodName = 'PREPARESQL' then
      TMyTable(Instance).PrepareSQL
    else
    if MethodName = 'EMPTYTABLE' then
      TMyTable(Instance).EmptyTable;
  end
  else
  if ClassType = TMyStoredProc then begin
    if MethodName = 'EXECPROC' then
      TMyStoredProc(Instance).ExecProc
    else
    if MethodName = 'PREPARESQL' then
      TMyStoredProc(Instance).PrepareSQL;
  end;
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TMyConnection then begin
    if PropName = 'CLIENTVERSION' then
      Result := TMyConnection(Instance).ClientVersion
    else
    if PropName = 'SERVERVERSION' then
      Result := TMyConnection(Instance).ServerVersion
  end
  else
  if ClassType = TCustomMyDataSet then begin
    if PropName = 'COMMANDTIMEOUT' then
      Result := TCustomMyDataSet(Instance).CommandTimeout;
  end
  else
  if ClassType = TMyTable then begin
    if PropName = 'TABLENAME' then
      Result := TMyTable(Instance).TableName
    else
    if PropName = 'ORDERFIELDS' then
      Result := TMyTable(Instance).OrderFields
    else
    if PropName = 'LIMIT' then
      Result := TMyTable(Instance).Limit;
  end
  else
  if ClassType = TMyStoredProc then begin
    if PropName = 'STOREDPROCNAME' then
      Result := TMyStoredProc(Instance).StoredProcName;
  end;
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TCustomMyDataSet then begin
    if PropName = 'COMMANDTIMEOUT' then
      TCustomMyDataSet(Instance).CommandTimeout := Value;
  end
  else
  if ClassType = TMyTable then begin
    if PropName = 'TABLENAME' then
      TMyTable(Instance).TableName := Value
    else
    if PropName = 'ORDERFIELDS' then
      TMyTable(Instance).OrderFields := Value
    else
    if PropName = 'LIMIT' then
      TMyTable(Instance).Limit := Value;
  end
  else
  if ClassType = TMyStoredProc then begin
    if PropName = 'STOREDPROCNAME' then
      TMyStoredProc(Instance).StoredProcName := Value;
  end;
end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.

