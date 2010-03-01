unit U_frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBAccess, MyAccess, MyEmbConnection, AProc, StdCtrls, U_ExchangeLog,
  DASQLMonitor, MyDacMonitor, MySQLMonitor;

{$ifdef USEMEMORYCRYPTDLL}
  {$ifndef USENEWMYSQLTYPES}
    {$define USENEWMYSQLTYPES}
  {$endif}
{$endif}

type
  TfrmMain = class(TForm)
    MyEmbConnection: TMyEmbConnection;
    btnDeleteWithPrepare: TButton;
    btnDeleteWithoutPrepare: TButton;
    MySQLMonitor1: TMySQLMonitor;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDeleteWithPrepareClick(Sender: TObject);
    procedure btnDeleteWithoutPrepareClick(Sender: TObject);
    procedure MySQLMonitor1SQL(Sender: TObject; Text: String;
      Flag: TDATraceFlag);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //Устанавливаем параметры embedded-соединения
  MyEmbConnection.Params.Clear();
  MyEmbConnection.Params.Add('--basedir=.');
  MyEmbConnection.Params.Add('--datadir=data');
  MyEmbConnection.Params.Add('--character_set_server=cp1251');
  //MyEmbConnection.Params.Add('--tmpdir=' + SDirDataTmpDir);
  if not DirectoryExists(ExePath + 'data') then
    ForceDirectories(ExePath + 'data\test');
  if not DirectoryExists(ExePath + 'data\test') then
    ForceDirectories(ExePath + 'data\test');
  MyEmbConnection.Database := 'test';
  MyEmbConnection.Open;
  MyEmbConnection.ExecSQL('drop table if exists Catalogs;', []);
  MyEmbConnection.ExecSQL(
 'create table Catalogs'
+'  ( '
+'    `FULLCODE` bigint(20) not null  , '
+'    `SHORTCODE` bigint(20) not null , '
+'    `NAME`             varchar(250) default null, '
+'    `FORM`             varchar(250) default null, '
+'    primary key (`FULLCODE`)                    , '
+'    unique key `PK_CATALOGS` (`FULLCODE`)       , '
+'    key `IDX_CATALOG_FORM` (`FORM`)             , '
+'    key `IDX_CATALOG_NAME` (`NAME`)             , '
+'    key `IDX_CATALOG_SHORTCODE` (`SHORTCODE`) '
+'  ) '
+'  ENGINE=MyISAM default CHARSET=cp1251;',
    []);
  MyEmbConnection.ExecSQL('insert into Catalogs (fullcode, shortcode, name, form) values (1, 1, "масло", "пихтовое");', []);
  MyEmbConnection.ExecSQL('insert into Catalogs (fullcode, shortcode, name, form) values (2, 1, "масло", "чайного дерева");', []);
  MyEmbConnection.ExecSQL('insert into Catalogs (fullcode, shortcode, name, form) values (3, 2, "крем", "детский");', []);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  MyEmbConnection.Close;
end;

procedure TfrmMain.btnDeleteWithPrepareClick(Sender: TObject);
var
  up : TMyQuery;
begin
  up := TMyQuery.Create(nil);
  try
    up.Connection := MyEmbConnection;

    up.SQL.Text := 'delete from catalogs where (fullcode = :fullcode)';
    up.Prepare;
    up.ParamByName('fullcode').AsString := '10';
    up.Execute;
    
  finally
    up.Free;
  end;
end;

procedure TfrmMain.btnDeleteWithoutPrepareClick(Sender: TObject);
var
  up : TMyQuery;
begin
  up := TMyQuery.Create(nil);
  try
    up.Connection := MyEmbConnection;

    up.SQL.Text := 'delete from catalogs where (fullcode = :fullcode)';
    up.ParamByName('fullcode').AsString := '10';
    up.Execute;

  finally
    up.Free;
  end;
end;

procedure TfrmMain.MySQLMonitor1SQL(Sender: TObject; Text: String;
  Flag: TDATraceFlag);
begin
  WriteExchangeLog('SQLMonitor', Text);
end;

end.
