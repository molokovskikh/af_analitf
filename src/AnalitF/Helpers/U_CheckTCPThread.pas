unit U_CheckTCPThread;

interface

uses
  Windows, Messages, SysUtils, Classes,
  AProc,
  StrUtils,
  U_ExchangeLog,
  IdException,
  IdExceptionCore,
  IdComponent,
  IdTCPClient,
  IdHTTP,
  ARas;

type
  TCheckTCPResult = record
    Error : Boolean;
    connectTo80 : Boolean;
    connectTo443 : Boolean;
    downloadSpeed : Int64;
  end;

function CheckTCPConnection(
  useRas : Boolean;
  rasEntry : String;
  rasUser : String;
  rasPass : String;
  rasSleep : Integer;
  useProxy : Boolean;
  proxyHost : String;
  proxyPort : Integer;
  proxyUser : String;
  proxyPassword : String;
  ShowCaption : String = 'Происходит проверка соединения. Подождите...') : TCheckTCPResult;

implementation

uses
  Waiting, IdBaseComponent;

type
  TCheckTCPThread = class(TThread)
   private
   public
    State : TCheckTCPResult;
    FidHttp : TIdHTTP;
    FRas : TARas;

    FuseRas : Boolean;
    FrasEntry : String;
    FrasUser : String;
    FrasPass : String;
    FrasSleep : Integer;
    FuseProxy : Boolean;
    FproxyHost : String;
    FproxyPort : Integer;
    FproxyUser : String;
    FproxyPassword : String;

    StartFilePosition,
    Speed : Int64;
    DownSecs : Double;
    StartDownTime,
    EndDownTime : TDateTime;

    function ConnectToPort(port : Integer) : Boolean;
    function GetDowloadSpeed() : Int64;
    procedure RasConnect;
    procedure HTTPPrepare;
    procedure RasDisconnect;
    function UsingRas() : Boolean;
    function UsingProxy() : Boolean;
    procedure HTTPWork(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
   protected
    procedure Execute; override;
  end;

{ TCheckTCPThread }

function TCheckTCPThread.ConnectToPort(port: Integer): Boolean;
begin
  Result := False;
  try
    try
      FidHttp.Connect('ios.analit.net', port);
      Result := True;
    finally
      if FidHttp.Connected then
        try FidHttp.Disconnect() except end;
    end;
  except
    on E : EIdConnClosedGracefully do
      WriteExchangeLog('TCheckTCPThread.ConnectToPort', 'Ошибка EIdConnClosedGracefully при подключении к порту ' + IntToStr(port));
    on E : EIdConnectTimeout do begin
      WriteExchangeLog('TCheckTCPThread.ConnectToPort', 'Ошибка EIdConnectTimeout при подключении к порту ' + IntToStr(port));
    end;
    on E : Exception do begin
      WriteExchangeLog('TCheckTCPThread.ConnectToPort', 'Ошибка при подключении к порту ' + IntToStr(port) + ' : ' + ExceptionToString(E));
      raise;
    end;
  end;
end;

procedure TCheckTCPThread.Execute;
begin
  State.Error := False;
  State.connectTo80 := False;
  State.connectTo443 := False;
  State.downloadSpeed := 0;
  try
    FRas := TARas.Create(nil);
    try

      FidHttp := TIdHTTP.Create();
      try
        HTTPPrepare;

        RasConnect();
        try
          try

            State.connectTo80 := ConnectToPort(80);
            State.connectTo443 := ConnectToPort(443);
            State.downloadSpeed := GetDowloadSpeed();

          finally
            if FidHttp.Connected then
              try FidHttp.Disconnect() except end;
          end;
        finally
          RasDisconnect();
        end;
      finally
        FidHttp.Free;
      end;

    finally
      FRas.Free;
    end;
  except
    on E : Exception do begin
      State.Error := True;
      WriteExchangeLog('TCheckTCPThread.Execute', 'Возникла ошибка в нитке : ' + ExceptionToString(E));
    end;
  end;
end;

function CheckTCPConnection(
  useRas : Boolean;
  rasEntry : String;
  rasUser : String;
  rasPass : String;
  rasSleep : Integer;
  useProxy : Boolean;
  proxyHost : String;
  proxyPort : Integer;
  proxyUser : String;
  proxyPassword : String;
  ShowCaption : String = 'Происходит проверка соединения. Подождите...') : TCheckTCPResult;
var
  RunT : TCheckTCPThread;
begin
  RunT := TCheckTCPThread.Create(True);
  try
    RunT.FuseRas := useRas;
    RunT.FrasEntry := rasEntry;
    RunT.FrasUser := rasUser;
    RunT.FrasPass :=  rasPass;
    RunT.FrasSleep :=  rasSleep;
    RunT.FuseProxy := useProxy;
    RunT.FproxyHost := proxyHost;
    RunT.FproxyPort := proxyPort;
    RunT.FproxyUser := proxyUser;
    RunT.FproxyPassword :=proxyPassword;

    ShowWaiting(ShowCaption, RunT);
    Result := RunT.State;
  finally
    RunT.Free;
  end;
end;

function TCheckTCPThread.GetDowloadSpeed: Int64;
var
  memoryStream : TMemoryStream;
begin
  Result := 0;
  StartDownTime := Now;

  try
    memoryStream := TMemoryStream.Create;
    try
      memoryStream.Position := 0;

      try
        FidHttp.Disconnect;
      except
      end;

      FidHttp.ReadTimeout := 500;
      FidHttp.ConnectTimeout := -2; // Без тайм-аута
      FidHttp.OnWork := HTTPWork;
      FidHttp.Request.BasicAuthentication := True;

      StartFilePosition := memoryStream.Position;
      try

        FidHttp.Get('http://ios.analit.net/Files/Useful/aftest.bin', memoryStream);

        WriteExchangeLog('CheckTCPThread', 'Recieve file : ' + IntToStr(memoryStream.Size));

      finally
        FidHttp.OnWork := nil;
        try
          EndDownTime := Now();
          Speed := memoryStream.Size - StartFilePosition;
          DownSecs := (EndDownTime - StartDownTime) * SecsPerDay;
          if DownSecs >= 1 then
            Speed := Round(Speed / DownSecs)
          else
            Speed := Round(Speed * DownSecs);
          Result := Speed;
          WriteExchangeLog('CheckTCPThread', 'Скорость загрузки файла: ' + FormatSpeedSize(Speed));
        except
          on CalcException : Exception do begin
            WriteExchangeLog('CheckTCPThread', 'Ошибка при вычислении скорости: ' + CalcException.Message);
          end;
        end;
      end;

    finally
      memoryStream.Free;
    end;
  except
    on E : Exception do
      WriteExchangeLog('TCheckTCPThread.GetDowloadSpeed',
        'Ошибка при скачивании файла : ' + E.ClassName + '  ' + ExceptionToString(E));
  end;
end;

procedure TCheckTCPThread.HTTPPrepare;
begin
  FidHttp.ConnectTimeout := 30;
  FidHttp.ReadTimeout := 500;

  if UsingProxy() then begin
    FidHttp.ProxyParams.ProxyServer := FproxyHost;
    FidHttp.ProxyParams.ProxyPort := FproxyPort;
    FidHttp.ProxyParams.ProxyUsername := FproxyUser;
    FidHttp.ProxyParams.ProxyPassword := FproxyPassword;
    FidHttp.Request.ProxyConnection := 'keep-alive';
    WriteExchangeLog('CheckTCPThread',
      'Используется proxy-сервер "' + FproxyHost + ':' + IntToStr(FproxyPort) + '"' +
      IfThen(FproxyUser <> '', ' с именем пользователя "' + FproxyUser + '"'));
  end
  else begin
    FidHttp.ProxyParams.ProxyServer := '';
    FidHttp.ProxyParams.ProxyPort := 0;
    FidHttp.ProxyParams.ProxyUsername := '';
    FidHttp.ProxyParams.ProxyPassword := '';
    FidHttp.Request.ProxyConnection := '';
  end;

  FidHttp.Request.Password := '';
  FidHttp.AllowCookies := True;
  FidHttp.HandleRedirects := False;
  FidHttp.HTTPOptions := [hoForceEncodeParams];
  FidHttp.Request.Accept := 'text/html, */*';
  FidHttp.Request.BasicAuthentication := True;
  FidHttp.Request.Connection := 'keep-alive';
  FidHttp.Request.ContentLength := -1;
  FidHttp.Request.ContentRangeEnd := 0;
  FidHttp.Request.ContentRangeStart := 0;
  FidHttp.Request.ContentType := 'text/html';
  FidHttp.Request.UserAgent := 'Mozilla/3.0 (compatible; Indy Library)';
end;

procedure TCheckTCPThread.HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  if (Now() - StartDownTime) > (60 / SecsPerDay) then
    Abort;
end;

procedure TCheckTCPThread.RasConnect;
begin
  if UsingRas() then begin
    FRas.Sync := True;
    FRas.UseProcessMessages := False;
    FRas.Entry := FrasEntry;
    FRas.UserName := FrasUser;
    FRas.Password := FrasPass;
    WriteExchangeLog('CheckTCPThread',
      'Используется удаленное соединение "' + FrasEntry + '"' +
        IfThen(FrasUser <> '', ' с именем пользователя "' + FrasUser + '"'));
    FRas.Connect;
    if FrasSleep > 0 then begin
      WriteExchangeLog('CheckTCPThread', 'Ожидаем после подключения RAS = ' + IntToStr(FrasSleep));
      Sleep(FrasSleep * 1000);
    end;
  end;
end;

procedure TCheckTCPThread.RasDisconnect;
begin
  if UsingRas() then
    try
      FRas.Disconnect;
    except
    end;
end;

function TCheckTCPThread.UsingProxy: Boolean;
begin
  Result := FuseProxy and (Length(FproxyHost) > 0);
end;

function TCheckTCPThread.UsingRas: Boolean;
begin
  Result := FuseRas and (Length(FrasEntry) > 0);
end;

end.
