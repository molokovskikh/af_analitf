program testLibMysqlDAcceessViolation;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  ActiveX,
  MyAccess,
  MySqlApi,
  MyEmbConnection,
  MDLHelper in '..\..\Common\DLLHelper\MDLHelper.pas',
  hlpcodecs in '..\..\AnalitF\RC_RND\hlpcodecs.pas',
  incrt in '..\..\AnalitF\RC_RND\incrt.pas',
  INFHelpers in '..\..\AnalitF\RC_RND\INFHelpers.pas',
  inforoomalg in '..\..\AnalitF\RC_RND\inforoomalg.pas',
  inforoomapi in '..\..\AnalitF\RC_RND\inforoomapi.pas',
  infver in '..\..\AnalitF\RC_RND\infver.pas',
  infvercls in '..\..\AnalitF\RC_RND\infvercls.pas',
  DLLLoader in 'DLLLoader.pas',
  MemoryLoadLibraryHelper in 'MemoryLoadLibraryHelper.pas',
  BTMemoryModule in 'BTMemoryModule.pas';

type
  TOpenTableThread = class(TThread)
   protected
    Stopped : Boolean; 
    procedure Execute; override;
  end;
  
var
  RealExePath : String;
  t : TOpenTableThread;

  function CreateConnection() : TCustomMyConnection;
  begin
    Result := TMyEmbConnection.Create(nil);
{
    if Main is TMyEmbConnection then
      Result := TMyEmbConnection.Create(nil)
    else
      Result := TMyConnection.Create(nil);
}

    Result.Server := '';
    Result.Database := '';
    Result.Username := 'root';
    Result.Password := '';
    Result.LoginPrompt := False;
    if Result is TMyEmbConnection then begin
      TMyEmbConnection(Result).DataDir := RealExePath + 'Data';
      TMyEmbConnection(Result).Options.Charset := 'cp1251';
      TMyEmbConnection(Result).Params.Clear;
      //TMyEmbConnection(Result).Params.AddStrings(TMyEmbConnection(Main).Params);

      TMyEmbConnection(Result).Params.Add('--basedir=' + RealExePath);
      TMyEmbConnection(Result).Params.Add('--datadir=' + RealExePath + 'Data\');

      //TMyEmbConnection(Result).Params.Add('--character_set_server=cp1251');

      //TMyEmbConnection(Result).Params.Add('--tmp_table_size=' + IntToStr(33554432));
      //TMyEmbConnection(Result).Params.Add('--max_heap_table_size=' + IntToStr(33554432));

      //TMyEmbConnection(Result).Params.Add('--tmpdir=' + ExtractFileDir(ParamStr(0)) + '\' + SDirDataTmpDir  + '\');

      //TMyEmbConnection(Result).Params.Add('--sort_buffer_size=64M');
      //TMyEmbConnection(Result).Params.Add('--read_buffer_size=2M');
    end
    else begin
{
      TMyConnection(Result).Port := TMyConnection(Main).Port;
      TMyConnection(Result).Options := TMyConnection(Main).Options;
}      
    end;
  end;

  procedure PrepareDatabase();
  var
    needCreate : Boolean;
    connection : TCustomMyConnection;
  begin
    needCreate := False;
    if not DirectoryExists(RealExePath + 'Data\analitf') then begin
      needCreate := True;
      ForceDirectories(RealExePath + 'Data\analitf');
    end;

    if needCreate then begin
      connection := CreateConnection();
      try
        connection.Open;
        try
          connection.ExecSQL('' +
          'create table analitF.userinfo '
          +'  ( '
+'    `ClientId` bigint(20) not null                 , '
+'    `UserId` bigint(20) not null                   , '
+'    `Addition`       varchar(50) default null       , '
+'    `InheritPrices`  tinyint(1) not null default ''0'', '
+'    `IsFutureClient` tinyint(1) not null default ''0'', '
+'    `UseCorrectOrders` tinyint(1) not null default ''0'',  '
+'    `ShowSupplierCost` tinyint(1) not null default ''1''  '
+'  ) '
+ 'ENGINE=MyISAM default CHARSET=cp1251 ROW_FORMAT=DYNAMIC;'
+ ' insert into analitf.UserInfo (ClientId, UserId) values (1, 2);',
[]
);
        finally
          connection.Close;
        end;
      finally
        connection.Free;
      end;
    end;
  end;

  procedure CheckOpen();
  var
    connection : TCustomMyConnection;
    query : TMyQuery;
  begin
    connection := CreateConnection();
    try
      connection.Open;
      WriteLn('Open connection');
      try
        query := TMyQuery.Create(nil);
        try
          query.Connection := connection;

          {
          query.SQL.Text := 'select now() from analitf.UserInfo';
          try
            query.Open;
            query.Close;
          except
            on E : Exception do
              WriteLn('Error on fist open: ', E.Message);
          end;

          Sleep(500);

          query.SQL.Text := 'select curdate() from analitf.UserInfo';
          try
            query.Open;
            query.Close;
          except
            on E : Exception do
              WriteLn('Error on second open: ', E.Message);
          end;
          }

        finally
          query.Free;
        end;
      finally
        WriteLn('before connection close');
        connection.Close;
      end;
    finally
      WriteLn('before connection free');
      connection.Free;
      WriteLn('before unload library');
      MyAPIEmbedded.FreeMySQLLib();
    end;
  end;



{ TOpenTableThread }

procedure TOpenTableThread.Execute;
begin
  Stopped := False;
  CoInitialize(nil);
//  try
    CheckOpen;
//  except
//    on E : Exception do
//      WriteLn('Error on thread: ', E.Message);
//  end;
  CoUninitialize();
  Stopped := True;
end;

begin
  { TODO -oUser -cConsole Main : Insert code here }
  RealExePath := ExtractFilePath(ParamStr(0));
  WriteLn('Path :', RealExePath);
  Write('Press any button to continue');
  ReadLn;

  //CoInitialize(nil);
  try
    //PrepareDatabase;

    CheckOpen;


{
    t := TOpenTableThread.Create(False);
    while not t.Stopped do begin
      Sleep(500);
    end;
}
    WriteLn('After test');
  except
    on E : Exception do
      WriteLn('Error on execute: ', E.Message);
  end;
{
}
  //CoUninitialize();

  Write('Press any button to exit');
  ReadLn;
end.
