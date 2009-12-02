unit U_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MDLHelper, MySqlApi, DB, DBAccess, MyAccess,
  MyEmbConnection, INFHelpers;

const
SERVER_GROUPS : array [0..2] of PChar = ('embedded'#0, 'server'#0, nil);

DEFAULT_PARAMS : array [0..1] of PChar = ('not_used'#0,
                                          '--datadir=data'#0);
type
  Tmysql_server_init            = function(Argc: Integer; Argv, Groups: Pointer): Integer; cdecl; // stdcall;
  Tmysql_get_client_version     = function: Cardinal; stdcall ;

  TForm1 = class(TForm)
    btnMySqlLoad1: TButton;
    MyEmbConnection1: TMyEmbConnection;
    btnConnect: TButton;
    btnCrypt: TButton;
    btnGetMemoryStream: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnMySqlLoad1Click(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnCryptClick(Sender: TObject);
    procedure btnGetMemoryStreamClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MemoryStream : TMemoryStream;
    MDLHelper : TMDLHelper;
  end;

var
  Form1: TForm1;
  ServerArgs: array of PChar;
  ServerArgsLen: Integer;


implementation

{$R *.dfm}
//{$L lib\test.obj}
//{$L lib\mysqlserver.lib}
//{$L lib\Kernel32.Obj}

procedure BuildServerArguments({Options: TStrings});
var
  TmpList: TStringList;
  i: Integer;
begin
  TmpList := TStringList.Create;
  try
    TmpList.Add(ParamStr(0));
{--basedir=.
--datadir=data
--character_set_server=cp1251
--character_set_filesystem=cp1251
--skip-innodb
}
    TmpList.Add('--basedir=.');
    TmpList.Add('--datadir=data');
    TmpList.Add('--character_set_server=cp1251');
    TmpList.Add('--character_set_filesystem=cp1251');
    TmpList.Add('--skip-innodb');
{
    for i := 0 to Options.Count - 1 do
      if SameText(SERVER_ARGUMENTS_KEY_PREFIX,
                  Copy(Options.Names[i], 1,
                       Length(SERVER_ARGUMENTS_KEY_PREFIX)))
      then
        TmpList.Add(Options.Values[Options.Names[i]]);
}
    //Check if DataDir is specified, if not, then add it to the Arguments List
{
    If TmpList.Values['--datadir'] = '' then
       TmpList.Add('--datadir='+EMBEDDED_DEFAULT_DATA_DIR);
       }
    ServerArgsLen := TmpList.Count;
    SetLength(ServerArgs, ServerArgsLen);
    for i := 0 to ServerArgsLen - 1 do
      ServerArgs[i] := StrNew(PChar(TmpList[i]));
  finally
    TmpList.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MemoryStream := TMemoryStream.Create;
  MemoryStream.LoadFromFile('libmysqld.dat');
  MDLHelper := TMDLHelper.Create();
  MDLHelper.ShowErrors := True;
end;

procedure TForm1.btnMySqlLoad1Click(Sender: TObject);
var
  F : Tmysql_server_init;
  Version : Tmysql_get_client_version;
  ResultCode : Integer;
  LastError : Cardinal;
  MySqlVersion : Cardinal;
begin
  BuildServerArguments();
  F := nil;
  MDLHelper.InjectDll(MemoryStream.Memory, True);
  @F := MDLHelper.GetFDProcAddress('mysql_server_init');
  @Version := MDLHelper.GetFDProcAddress('mysql_get_client_version');
  if Assigned(F) then begin
    //ShowMessage(Format('Procedure %p', [@F]));
    try
      MySqlVersion := Version;
      ResultCode := F(ServerArgsLen, ServerArgs, @SERVER_GROUPS);
      if ResultCode <> 0 then begin
        LastError := GetLastError();
        ShowMessage(Format('Ошибка при вызове %d: %s', [LastError, SysErrorMessage(LastError)]));
      end;
    except
      on E : Exception do
        ShowMessage('Exception : ' + E.Message);
    end;
  end;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  MyEmbConnection1.Open;
end;

procedure TForm1.btnCryptClick(Sender: TObject);
var
  inFile : TFileStream;
  cryptFile : TFileStream;
  decodeFile : TFileStream;
begin
  if FileExists('libmysqld.cry') then
    DeleteFile('libmysqld.cry');
  if FileExists('libmysqld.dec') then
    DeleteFile('libmysqld.dec');

  inFile := TFileStream.Create('libmysqld.dat', fmOpenRead or fmShareDenyWrite);
  cryptFile := TFileStream.Create('libmysqld.cry', fmCreate);
  EncodeStream(inFile, cryptFile);
  inFile.Free;
  cryptFile.Free;

  Sleep(1000);

  cryptFile := TFileStream.Create('libmysqld.cry', fmOpenRead or fmShareDenyWrite);

  decodeFile := TFileStream.Create('libmysqld.dec', fmCreate);

  DecodeStream(cryptFile, decodeFile);
  cryptFile.Free;
  decodeFile.Free;
end;

procedure TForm1.btnGetMemoryStreamClick(Sender: TObject);
var
  MS : TMemoryStream;
begin
  try
    MS := GetEncryptedMemoryStream();
    if Assigned(MS) then begin
      MS.SaveToFile('libmysqld.dec_memory');
      MS.Free;
    end;
  except
    on E : Exception do
      ShowMessage('Ошибка: ' + E.Message);
  end;
end;

end.
