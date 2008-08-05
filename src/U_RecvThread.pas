unit U_RecvThread;

interface

uses
  Classes, SysUtils, Windows, IdHTTP, AProc, SOAPThroughHTTP;

type
  TReceiveThread = class(TThread)
   protected
    FURL,
    FHTTPName,
    FHTTPPass : String;
    FSOAP : TSOAP;
    ReceiveHTTP : TIdHTTP;
    procedure Log(SybSystem, MessageText : String);
    procedure OnConnectError(AMessage : String);
   public
    procedure DisconnectThread;
    procedure SetParams(
      AHTTP : TIdHTTP;
      AURL,
      AHTTPName,
      AHTTPPass : String);
  end;

implementation

uses
  U_ExchangeLog;

{ TReceiveThread }

procedure TReceiveThread.DisconnectThread;
begin
  try ReceiveHTTP.Disconnect; except end;
end;

procedure TReceiveThread.Log(SybSystem, MessageText: String);
var
  Res : Boolean;
begin
  Res := False;
  repeat
    try
       WriteExchangeLog(SybSystem, MessageText);
       Res := True;
    except
      Sleep(700);
    end;
  until Res;
end;

procedure TReceiveThread.SetParams(AHTTP : TIdHTTP;
  AURL, AHTTPName, AHTTPPass: String);
begin
  FreeOnTerminate := True;
  ReceiveHTTP := AHTTP;
  FURL := AURL;
  FHTTPName := AHTTPName;
  FHTTPPass := AHTTPPass;
end;

procedure TReceiveThread.OnConnectError(AMessage: String);
begin
  if Terminated then Abort;
end;

end.
