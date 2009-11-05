program TestLibMySqlDConsole;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DBAccess,
  MyAccess,
  MyEmbConnection,
  LU_Tracer in '..\common\LU_Tracer.pas',
  MySqlApi;

type
  TLogHandler = class
   public
    procedure OnLog(const Text: String);
    procedure OnLogError(const Text: String);
  end;

var
  MyConnection: TMyEmbConnection;
  LogHandler : TLogHandler;
  err : String;

{ TLogHandler }

procedure TLogHandler.OnLog(const Text: String);
begin
  Tracer.TR('OnLog', Text);
end;

procedure TLogHandler.OnLogError(const Text: String);
begin
  Tracer.TR('OnLogError', Text);
end;

begin
  { TODO -oUser -cConsole Main : Insert code here }
  try
    MySQLEmbDisableEventLog := True;
    LogHandler := TLogHandler.Create();
    MyConnection := TMyEmbConnection.Create(nil);
    MyAPIEmbedded.RegisterOnLogEvent(LogHandler.OnLog);
    MyAPIEmbedded.RegisterOnLogErrorEvent(LogHandler.OnLogError);
//    MyConnection.OnLog := LogHandler.OnLog;
//    MyConnection.OnLogError := LogHandler.OnLogError;

    MyConnection.Username := 'root';
    MyConnection.Database := 'test';

    MyConnection.Params.Clear;
    MyConnection.Params.Add('--basedir=.');
    MyConnection.Params.Add('--datadir=data');
    MyConnection.Params.Add('--character_set_server=cp1251');
    MyConnection.Params.Add('--character_set_filesystem=cp1251');
    MyConnection.Params.Add('--log');
    MyConnection.Params.Add('--log-error');
    //--skip-innodb
    MyConnection.Params.Add('--skip-innodb');

    MyConnection.Open;
    try
      WriteLn('Press Enter...');
      Readln;
    finally
      MyConnection.Close;
    end;
  except
    on E : Exception do begin
      try
        Err := MyAPIEmbedded.mysql_error(nil);
        Writeln('Server Error : ' + Err);
      except
        on GetError : Exception do
          Writeln('On Ger Error : ' + GetError.Message);
      end;
      Writeln('Error : ' + E.Message);
      WriteLn('Press Enter...');
      ReadLn;
    end;
  end;
end.
