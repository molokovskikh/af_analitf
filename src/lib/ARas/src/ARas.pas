unit ARas;

interface

uses
  Classes, Ras, SysUtils, Windows, Forms, Controls;

const
  SNoEntryName='Не задано имя соединения';

type
  TRasStateChangeEvent=procedure(Sender: TObject; State: TRasConnState;
    StateStr: string) of object;

  ERasException=class(Exception);

  TARas = class(TComponent)
  private
    hRas: THRasConn;
    ConnectionWasEstablished, Connecting, Disconnecting: Boolean;
    FSync, FUseEstablished: Boolean;
    FOnStateChange: TRasStateChangeEvent;
    FState: TRasConnState;
    FEntry, FUserName, FPassword: string;
    FError: Integer;

    function GetConnected: Boolean;
    procedure SetEntry(Value: string);
    procedure DoStateChange(State: TRasConnState);
    procedure RasCheck(ErrorCode: Integer);
  protected
    { Protected declarations }
  public
    Items: TStrings;
    LastError: Integer;
    UseProcessMessages : Boolean;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    procedure GetConnections;
    procedure GetEntries;
    function GetEntryIndex: Integer;
    procedure GetModems;
    procedure CreateEntry(ModemName,ModemType,Phone: string);
    function CreateEntryDlg(Phone: string=''): Boolean;
    procedure EditEntry;
    procedure DeleteEntry;
    procedure RenameEntry(NewName: string);
    function RenameEntryDlg: Boolean;
    procedure ValidateEntryName;
  published
    property Connected: Boolean read GetConnected;
    property Sync: Boolean read FSync write FSync default True;
    property UseEstablished: Boolean read FUseEstablished write FUseEstablished default True;
    property OnStateChange: TRasStateChangeEvent read FOnStateChange write FOnStateChange;
    property Entry: string read FEntry write SetEntry;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
  end;

procedure Register;

function RasStateToString(State: TRasConnState): string;
function RasErrorToString(ErrorCode: Integer): string;

implementation

uses CreateEntry, InputBox;

var
  CurrentRas: TARas;
  DoCallback: Boolean;

{ TARas }

constructor TARas.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  UseProcessMessages := True; 
  FSync:=True;
  FUseEstablished:=True;
  Items:=TStringList.Create;
end;

destructor TARas.Destroy;
begin
  Items.Free;
  inherited Destroy;
end;

procedure RasCallBack(Msg: Integer; State: TRasConnState; Error: Integer); stdcall;
begin
  if DoCallback and not CurrentRas.Disconnecting then begin
    DoCallBack:=False;
    if Assigned(CurrentRas.FOnStateChange) then
      CurrentRas.FOnStateChange(CurrentRas,State,RasStateToString(State));
    CurrentRas.FError:=Error;
    CurrentRas.FState:=State; //самая последняя строка, чтобы вышли из материнского цикла в последнюю очередь
    DoCallBack:=True;
  end;
end;

procedure TARas.Connect;
var
  DialParams: TRasDialParams;
  I: Integer;
  Pas: LongBool;
begin
  if FEntry='' then raise ERasException.Create(SNoEntryName);
  if Connected then Exit;
  Disconnecting:=False;
  ConnectionWasEstablished:=False;
  GetConnections;
  //сначала ищем, не установлено ли уже наше соединение другой программой
  for I:=0 to Items.Count-1 do
    if AnsiUpperCase(FEntry)=AnsiUpperCase(Items[I]) then begin
      hRas:=Integer(Items.Objects[I]);
      Exit;
    end;
  //берем любое другое установленное соединение
  if UseEstablished and (Items.Count>0) then begin
    hRas:=Integer(Items.Objects[0]);
    Exit;
  end;
  //устанавливаем соединение
  FillChar(DialParams,SizeOf(TRasDialParams),0);
  DialParams.dwSize:=SizeOf(TRasDialParams);
  StrPCopy(DialParams.szEntryName,FEntry);
  if Trim(FUserName)='' then begin
    //если не задано имя пользуемся именем и паролем по умолчанию
    Pas:=True;
    RasCheck(RasGetEntryDialParams(nil,DialParams,Pas));
  end
  else begin
    //в противном случае используем заданные имя и пароль
    StrPCopy(DialParams.szUserName,FUserName);
    StrPCopy(DialParams.szPassword,FPassword);
  end;
  //начинаем дозвон
  CurrentRas:=Self; DoCallback:=True; FError:=0;
  Connecting:=True;
  FState := RASCS_Disconnected;
  RasCheck(RasDial(nil,nil,DialParams,0,@RasCallBack,hRas));
  ConnectionWasEstablished:=True;
  if FSync then
    repeat //ожидаем окончания процесса соединения
      if UseProcessMessages then
        Application.ProcessMessages;
      if Disconnecting then Break;
      Sleep(0);
      RasCheck(FError);
    until FState=RASCS_Connected;
  Connecting:=False;
end;

procedure TARas.Disconnect;
var
  Stat: TRasConnStatus;
begin
  if not Disconnecting then begin
    Disconnecting:=True;
    if ConnectionWasEstablished then begin
      ConnectionWasEstablished:=False;
      DoStateChange(RASCS_Disconnected);
      RasHangUp(hRas);
      if FSync then begin
        FillChar(Stat,SizeOf(TRasConnStatus),0);
        Stat.dwSize:=SizeOf(TRasConnStatus);
        repeat
          Sleep(0);
        until RasGetConnectStatus(hRas,Stat)=ERROR_INVALID_HANDLE;
      end;
    end;
    hRas:=0;
  end;
end;

function TARas.GetConnected: Boolean;
var
  Stat: TRasConnStatus;
begin
  FillChar(Stat,SizeOf(TRasConnStatus),0);
  Stat.dwSize:=SizeOf(TRasConnStatus);
  Result:=(RasGetConnectStatus(hRas,Stat)=0)and
    (Stat.dwError=0)and(Stat.rasconnstate=RASCS_Connected);
end;

procedure TARas.SetEntry(Value: string);
begin
  FEntry:=Trim(Value);
end;

procedure TARas.DoStateChange(State: TRasConnState);
begin
  if Assigned(FOnStateChange) then FOnstateChange(Self,State,RasStateToString(State));
end;

procedure TARas.RasCheck(ErrorCode: Integer);
begin
  if (ErrorCode<>0)and(ErrorCode<>ERROR_USER_DISCONNECTION) then begin
    LastError:=ErrorCode;
    Disconnect;
    raise ERasException.Create(RasErrorToString(ErrorCode));
  end;
end;

procedure TARas.GetConnections;
var
  Res, BufSize, NumEntries: Integer;
  I: Integer;
  Entries, P: LPRasConn;
  Stat: TRasConnStatus;
begin
  Items.Clear;
  Entries:=AllocMem(SizeOf(TRasConn));
  try
    Entries^.dwSize:=SizeOf(TRasConn);
    BufSize:=SizeOf(TRasConn);
    Res:=RasEnumConnections(Entries,BufSize,NumEntries);
    if (Res=ERROR_BUFFER_TOO_SMALL)or(Res=ERROR_NOT_ENOUGH_MEMORY) then begin
      ReallocMem(Entries,BufSize);
      FillChar(Entries^,BufSize,0);
      Entries^.dwSize:=SizeOf(TRasConn);
      RasCheck(RasEnumConnections(Entries,BufSize,NumEntries));
    end;
    if NumEntries>0 then begin
      FillChar(Stat,SizeOf(TRasConnStatus),0);
      Stat.dwSize:=SizeOf(TRasConnStatus);
      P:=Entries;
      for I:=0 to NumEntries-1 do begin
        RasCheck(RasGetConnectStatus(P^.hrasconn,Stat));
        if Stat.rasconnstate=RASCS_Connected then begin
          Items.Add(string(P^.szEntryName));
          Items.Objects[I]:=Pointer(P^.hrasconn);
        end;
        Inc(P);
      end;
    end;
  finally
    FreeMem(Entries);
  end;
end;

procedure TARas.GetEntries;
var
  Entries, P: LPRasEntryName;
  BufSize, NumEntries, Res, I: Integer;
begin
  Items.Clear;
  Entries:=AllocMem(SizeOf(TRasEntryName));
  try
    Entries^.dwSize:=SizeOf(TRasEntryName);
    BufSize:=SizeOf(TRasEntryName);
    Res:=RasEnumEntries(nil,nil,Entries,BufSize,NumEntries);
    if (Res=ERROR_BUFFER_TOO_SMALL)or(Res=ERROR_NOT_ENOUGH_MEMORY) then begin
      ReallocMem(Entries,BufSize);
      FillChar(Entries^,BufSize,0);
      Entries^.dwSize:=SizeOf(TRasEntryName);
      Res:=RasEnumEntries(nil,nil,Entries,BufSize,NumEntries);
    end;
    RasCheck(Res);
    if NumEntries>0 then begin
      P:=Entries;
      for I:=1 to NumEntries do begin
        Items.Add(StrPas(P^.szEntryName));
        Inc(P);
      end;
    end;
  finally
    FreeMem(Entries);
  end;
end;

function TARas.GetEntryIndex: Integer;
var
  I: Integer;
begin
  Entry:=AnsiUpperCase(Entry);
  Result:=-1;
  GetEntries;
  for I:=0 to Items.Count-1 do
    if AnsiUppercase(Items[I])=Entry then begin
      Result:=I;
      Break;
    end;
end;

procedure TARas.GetModems;
var
  Devices, P: LPRasDevInfo;
  Res, BufSize, NumDevices, I: Integer;
begin
  Items.Clear;
  Devices:=AllocMem(SizeOf(TRasDevInfo));
  try
    Devices^.dwSize:=SizeOf(TRasDevInfo);
    BufSize:=SizeOf(TRasDevInfo); NumDevices:=0;
    Res:=RasEnumDevices(Devices,BufSize,NumDevices);
    if (Res=ERROR_BUFFER_TOO_SMALL)or(Res=ERROR_NOT_ENOUGH_MEMORY) then begin
      ReallocMem(Devices,BufSize);
      FillChar(Devices^,BufSize,0);
      Devices^.dwSize:=SizeOf(TRasDevInfo);
      Res:=RasEnumDevices(Devices,BufSize,NumDevices);
    end;
    RasCheck(Res);
    if NumDevices>0 then begin
      P:=Devices;
      for I:=1 to NumDevices do begin
        if (StrComp(P^.szDeviceType,RASDT_Modem)=0)or
          (StrComp(P^.szDeviceType,RASDT_Isdn)=0)or
          (StrComp(P^.szDeviceType,RASDT_X25)=0) then
          Items.Values[P^.szDeviceName]:=P^.szDeviceType;
        Inc(P);
      end;
    end;
  finally
    FreeMem(Devices);
  end;
end;

procedure TARas.CreateEntry(ModemName,ModemType,Phone: string);
var
  NewEntry: TRasEntry;
begin
  //проверяем параметры
  ModemName:=Trim(ModemName);
  ModemType:=Trim(ModemType);
  Phone:=Trim(Phone);
  if ModemName='' then raise ERasException.Create('Наименование модема не задано');
  if ModemType='' then raise ERasException.Create('Тип модема не задан');
  if Phone='' then raise ERasException.Create('Телефон не задан');
  //проверяем имя соединения
  ValidateEntryName;
  //заполняем параметры соединения
  FillChar(NewEntry,SizeOf(TRasEntry),0);
  with NewEntry do begin
    dwSize:=SizeOf(TRasEntry);
    dwfOptions:=RASEO_IpHeaderCompression or RASEO_RemoteDefaultGateway or
      RASEO_SwCompression;
    dwfNetProtocols:=RASNP_Ip;
    dwFramingProtocol:=RASFP_Ppp;
    StrPCopy(szLocalPhoneNumber,Phone);
    StrPCopy(szDeviceName,ModemName);
    StrPCopy(szDeviceType,ModemType);
  end;
  RasCheck(RasSetEntryProperties(nil,PChar(FEntry),@NewEntry,SizeOf(TRasEntry),nil,0));
end;

function TARas.CreateEntryDlg(Phone: string=''): Boolean;
var
  I: Integer;
begin
  with TCreateRasEntryForm.Create(Application) do try
    edtName.Text:=Entry;
    edtPhone.Text:=Phone;
    GetModems;
    cbModem.Items.Clear;
    for I:=0 to Items.Count-1 do begin
      cbModem.Items.Add(Items.Names[I]);
      if UpperCase(Items.Values[Items.Names[I]])='MODEM' then
        cbModem.ItemIndex:=I;
    end;
    if (cbModem.ItemIndex=-1)and(cbModem.Items.Count>0) then
      cbModem.ItemIndex:=0;
    Result:=ShowModal=mrOk;
    if Result then begin
      Phone:=edtPhone.Text;
      Entry:=edtName.Text;
      CreateEntry(cbModem.Text,Items.Values[cbModem.Text],Phone);
      Entry:=edtName.Text;
    end;
  finally
    Free;
  end;
end;

procedure TARas.EditEntry;
var
  Handle: HWND;
begin
  if (Screen<>nil)and(Screen.ActiveForm<>nil) then
    Handle:=Screen.ActiveForm.Handle
  else
    Handle:=0;
  RasCheck(RasEditPhonebookEntry(Handle,nil,PChar(Entry)));
end;

procedure TARas.DeleteEntry;
begin
  RasCheck(RasDeleteEntry(nil,PChar(Entry)));
end;

procedure TARas.RenameEntry(NewName: string);
begin
  RasCheck(RasRenameEntry(nil,PChar(Entry),PChar(NewName)));
  FEntry:=NewName;
end;

function TARas.RenameEntryDlg: Boolean;
var
  NewName: string;
begin
  NewName:=Entry;
  Result:=InputBoxA('Изменить имя','Новое имя',NewName,False);
  if Result then
    RenameEntry(NewName);
end;

procedure TARas.ValidateEntryName;
begin
  RasCheck(RasValidateEntryName(nil,PChar(FEntry)));
end;

{ функции и процедуры }

function RasStateToString(State: TRasConnState): string;
begin
  case State of
    RASCS_OpenPort: Result:='Открывается порт';
    RASCS_PortOpened: Result:='Порт открыт';
    RASCS_ConnectDevice: Result:='Подключение устройства связи';
    RASCS_DeviceConnected: Result:='Устройство связи подключено';
    RASCS_AllDevicesConnected: Result:='Все устройства связи подключены';
    RASCS_Authenticate, RASCS_AuthNotify, RASCS_AuthCallback, RASCS_AuthProject,
      RASCS_AuthLinkSpeed, RASCS_StartAuthentication: Result:='Авторизация пользователя';
    RASCS_AuthRetry, RASCS_ReAuthenticate: Result:='Авторизация: повтор';
    RASCS_AuthChangePassword: Result:='Изменение пароля';
    RASCS_AuthAck, RASCS_Authenticated: Result:='Авторизация успешно завершена';
    RASCS_PrepareForCallback: Result:='Подкотовка к коллбэку';
    RASCS_WaitForModemReset: Result:='Ожидание инициализации модема';
    RASCS_WaitForCallback: Result:='Ожидание коллбэка';
    RASCS_Projected: Result:='Проектирование завершено';
    RASCS_CallbackComplete: Result:='Коллбэк завершен';
    RASCS_LogonNetwork: Result:='Вход в сеть';
    RASCS_Interactive: Result:='Пауза';
    RASCS_RetryAuthentication: Result:='Авторизация: повтор';
    RASCS_CallbackSetByCaller: Result:='Коллбэк установлен вызывающим';
    RASCS_PasswordExpired: Result:='Срок действия пароля истек';
    RASCS_Connected: Result:='Соединение установлено';
    RASCS_Disconnected: Result:='Отключение соединения';
  end;
end;

//тексты ошибок при подключении к RAS
function RasErrorToString(ErrorCode: Integer): string;
var
  Buffer: array[0..255] of Char;
  Error: Integer;
begin
  if ErrorCode<>0 then begin
    if ErrorCode = -1  then begin
      Result := 'Не установлена служба удаленного доступа'
    end
    else begin
      Error:=RasGetErrorString(ErrorCode,Buffer,256);
      if Error=0 then
        Result:=Buffer
      else
        if Error=ERROR_INVALID_PARAMETER then
          case ErrorCode of
            ERROR_INVALID_NAME: Result:='Неверное имя удаленного соединения';
            ERROR_ALREADY_EXISTS: Result:='Удаленное соединение с таким именем уже существует';
            ERROR_CANNOT_FIND_PHONEBOOK_ENTRY: Result:='Удаленное соединение не найдено';
            ERROR_INVALID_HANDLE: Result:='Соединение отсутствует';
          else
            raise ERasException.Create(Format('Неизвестная ошибка: %d',[ErrorCode]))
          end
        else
          {$IFDEF VER150}
          RaiseLastOSError;
          {$ELSE}
          RaiseLastWin32Error;
          {$ENDIF}
    end;
  end
end;

procedure Register;
begin
  RegisterComponents('Internet', [TARas]);
end;

end.
