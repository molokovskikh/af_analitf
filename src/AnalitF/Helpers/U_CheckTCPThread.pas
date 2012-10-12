unit U_CheckTCPThread;

interface

uses
  Windows, Messages, SysUtils, Classes,
  AProc,
  U_ExchangeLog,
  IdException,
  IdExceptionCore,
  IdTCPClient,
  IdHTTP;

type
  TCheckTCPResult = record
    Error : Boolean;
    connectTo80 : Boolean;
    connectTo443 : Boolean;
    downloadSpeed : Int64;
  end;

function CheckTCPConnection(ShowCaption : String = 'Происходит проверка соединения. Подождите...') : TCheckTCPResult;

implementation

uses
  Waiting;

type
  TCheckTCPThread = class(TThread)
   private
   public
    State : TCheckTCPResult;
    function ConnectToPort(port : Integer) : Boolean;
    function GetDowloadSpeed() : Int64;
   protected
    procedure Execute; override;
  end;

{ TCheckTCPThread }

function TCheckTCPThread.ConnectToPort(port: Integer): Boolean;
var
  IdTCPClient : TIdTCPClient;
begin
  Result := False;
  try
    IdTCPClient := TIdTCPClient.Create();
    try
      IdTCPClient.Host := 'ios.analit.net';
      IdTCPClient.Port := port;
      IdTCPClient.ConnectTimeout := 20;
      IdTCPClient.Connect();
      Result := True;
      try
        IdTCPClient.Disconnect()
      except
      end;
    finally
      IdTCPClient.Free;
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
    State.connectTo80 := ConnectToPort(80);
    State.connectTo443 := ConnectToPort(443);
    State.downloadSpeed := GetDowloadSpeed();
  except
    on E : Exception do begin
      State.Error := True;
      WriteExchangeLog('TCheckTCPThread.Execute', 'Возникла ошибка в нитке : ' + ExceptionToString(E));
    end;
  end;
end;

function CheckTCPConnection(ShowCaption : String = 'Происходит проверка соединения. Подождите...') : TCheckTCPResult;
var
  RunT : TCheckTCPThread;
begin
  RunT := TCheckTCPThread.Create(True);
  try
    ShowWaiting(ShowCaption, RunT);
    Result := RunT.State;
  finally
    RunT.Free;
  end;
{
  if Length(Error) <> 0 then begin
    raise Exception.Create(Error);
  end;
}
end;

function TCheckTCPThread.GetDowloadSpeed: Int64;
begin
  Result := 300 * 1024 div 8;
end;

end.
