unit uData;

interface

uses
  SysUtils, Classes, DB, DBAccess, MyAccess, MemData;

type
  TDM = class(TDataModule)
    Connection: TMyConnection;
    procedure ConnectionBeforeConnect(Sender: TObject);
    procedure ConnectionAfterConnect(Sender: TObject);
    procedure ConnectionAfterDisconnect(Sender: TObject);
    procedure ConnectionConnectionLost(Sender: TObject;
      Component: TComponent; ConnLostCause: TConnLostCause;
      var RetryMode: TRetryMode);
  end;

implementation

{$R *.dfm}

uses IWInit, ServerController;

{ TDM }

procedure TDM.ConnectionBeforeConnect(Sender: TObject);
begin
  Connection.Username := UserSession.Username;
  Connection.Password := UserSession.Password;
  Connection.Server := UserSession.Server;
  Connection.Database := UserSession.Database;
  Connection.Options.DisconnectedMode := UserSession.DisconnectedMode;
  Connection.Pooling := UserSession.Pooling;
  Connection.PoolingOptions := UserSession.PoolingOptions;
  if UserSession.FailOver then
    Connection.OnConnectionLost := ConnectionConnectionLost
  else
    Connection.OnConnectionLost := nil;
end;

procedure TDM.ConnectionAfterConnect(Sender: TObject);
begin
  UserSession.IsGoodConnection := True;
  UserSession.ConnectionResult := 'Connected';
end;

procedure TDM.ConnectionAfterDisconnect(Sender: TObject);
begin
  if not (csDestroying in Connection.ComponentState) then
    UserSession.ConnectionResult := '';
end;

procedure TDM.ConnectionConnectionLost(Sender: TObject;
  Component: TComponent; ConnLostCause: TConnLostCause;
  var RetryMode: TRetryMode);
var
  Msg: string;
begin
  UserSession.IsGoodConnection := False;
  case ConnLostCause of
    clUnknown:
      Msg := 'Unknown';
    clConnect:
      Msg := 'Connect';
    clExecute:
      Msg := 'Execute';
    clOpen:
      Msg := 'Open';
    clApply:
      Msg := 'Apply';
  end;
  UserSession.ConnectionResult := 'Connection lost: ' +
    Component.Name + ' - ' + Msg;
end;

end.
